
; Lezione14-8.s:  * MISCHEN 2 SAMPLE *

	section	bau,code

Start:

_LVODisable	EQU	-120
_LVOEnable	EQU	-126

	move.l	4.w,a6
	jsr	_LVODisable(a6)
	bset	#1,$bfe001			; schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7			; speichern DMA von OS

	move.l	#sample1,$a0(a6)
	move.l	#sample2,$b0(a6)
	move.w	#(sample1_end-sample1)/2,$a4(a6)
	move.w	#(sample2_end-sample2)/2,$b4(a6)
Clock	equ	3546895
	move.w	#clock/21056,$a6(a6)
	move.w	#clock/21056,$b6(a6)
	move.w	#64,$a8(a6)
	move.w	#64,$b8(a6)
	move.w	#$8003,$96(a6)		; einschalten AUD0-AUD1 DMA in DMACONW

WLMB:	btst	#6,$bfe001
	bne.s	wlmb

	lea	sample0,a0
	move.l	#sample0_end-sample0,d0
	lea	sample1,a1
	move.l	#sample1_end-sample1,d1
	lea	sample2,a2
	move.l	#sample2_end-sample2,d2
	bsr.s	mixsamples
	move.l	#sample0,$a0(a6)	; wird am Ende von Samples 1 gespielt
	move.l	#sample0,$b0(a6)	; und 2: Erinnern sie sich warum?
	move.w	#(sample0_end-sample0)/2,$a4(a6)
	move.w	#(sample0_end-sample0)/2,$b4(a6)

WRMB:	btst	#10,$dff016
	bne.s	wrmb

	move.w	#$0003,$96(a6)		; DMA ausschalten
	or.w	#$8000,d7			; Bit 15 (SET/CLR) schaltet ein
	move.w	d7,$96(a6)			; wiederherstellen DMA von OS
	move.l	4.w,a6
	jsr	_LVOEnable(a6)
	rts


MixSamples:	;[a0=dst sample, a1=src sample 1, a2=soruce sample 2]
		;[d0.l=dst length.b, d1.l=src1 length.b, d2.l=src2 length.b]
	movem.l	d0-d3/a0-a4,-(sp)
	lea	(a1,d1.l),a3			; a3=Ende von sample 1
	lea	(a2,d2.l),a4			; a4=Ende von sample 2
	moveq	#0,d3				; d3.b=0 für ADDX
.Lp:	move.w	#$f00,$dff180
	move.b	(a1)+,d1			; d1.b=campione del sample 1
	ext.w	d1					; d1.w=d1.b erweitert Vorzeichen zu word
	move.b	(a2)+,d2			; d2.b=campione del sample 2
	ext.w	d2					; d2.w=d2.b erweitert Vorzeichen zu word
	add.w	d1,d2				; d2.w=Summe von sampel 1 und 2 mit Vorzeichen 
	asr.w	#1,d2				; d2.w=Mittelwert Sample (Summe/2)
	addx.b	d3,d2				; d2.w=gerundeter gemischter sample
								; über oder unter
								; von ASR
	move.b	d2,(a0)+			; speichern gemischter sample
	cmp.l	a3,a1				; Ende sample 1 ?
	bhs.s	.quit				; wenn ja: exit
	cmp.l	a4,a2				; Ende sample 2 ?
	bhs.s	.quit				; wenn ja: exit
	subq.l	#1,d0				; verringert die Länge 0.b auf 0 ... ohne
								; DBRA, weil es nur in Word funktioniert...
	bhi.s	.lp
.Quit:	movem.l	(sp)+,d0-d3/a0-a4
	rts


	SECTION	Sample,DATA_C

Sample1:
	incbin	"assembler2:sorgenti8/carrasco.21056"
Sample1_end:

Sample2:
	incbin	"assembler2:sorgenti8/lee3.21056"
Sample2_end:

Sample0:blk.b	sample1_end-sample1
Sample0_end:

	END


Was haben wir diesmal gemacht? Wir konnten 2 verschiedene Samples auf 
dem gleichen Kanal spielen! Wie? Mischen Sie sie per Software mit der CPU!
Sie kennen die Struktur der Wellenform eines Samples und wissen das jeder
sample von 1 Byte von -128 bis 127 variieren kann. Daher handelt es sich um
ein BYTE MIT VORZEICHEN mit denen man arbeiten kann, indem man sie entsprechend
ihrer Natur als 8-Bit Zahlen behandelt, von denen das höchste (MSB) als
Vorzeichen dient. Gibt es einen besseren Weg zwei Sätze von Zahlen zu erhalten,
wenn man eine bekommt, die dem Trend von beiden folgt?
Machen Sie den ARITHMETISCHEN DURCHSCHNITT zwischen jedem Paar einzelner Bytes
/ Samples: Nimm 2 entsprechende Samples beider Proben.
Addiere sie algebraisch (* BERÜCKSICHTIGUNG DES VORZEICHENS *) und teile das
Ergebnis durch 2: MIX = (SAMP1 + SAMP2) / 2.

Wenn zwei Bytes algebraisch addiert werden, kann das Ergebnis größer als 127
sein (wenn zum Beispiel beide 127 sind, beträgt die Summe 254) und daher kann
es nicht mit einer vorzeichenbehafteten 8-Bit-Zahl ausgedrückt werden. Es ist
notwendig, mit Wörtern zu arbeiten um den Durchschnitt zu berechnen und die
Wörter müssen auch das Vorzeichen der ursprünglichen Bytes wiederspiegeln: Aus
diesem Grund haben wir das Vorzeichen des Bytes zum Word erweitert, um die
algebraische Summe mit ADD.W. In der "MixSamples"-Schleife haben wir ein
weiteres Detail für das Erhöhen der Qualität und Präzision des Mischens
übernommen: RUNDEN.
Sobald Sie die Summe gemacht haben, müssen Sie durch 2 teilen, damit die
Rückgabewerte im Bereich von 8 Bit mit Vorzeichen sind (* Sie müssen alle Werte
durch 2 dividieren und lassen Sie diejenigen nicht aus, die zwischen -128 und
127 liegen, auch wenn Sie nur ADD erledigt haben: Die Sample wären nicht mehr
proportional! *)
Eine solche Division wird schnell durch das ASR ausgeführt, die es nach rechts
verschiebt (in diesem Fall um 1). * So BEHALTEN Sie das Vorzeichen links *: 
Das letzte verschobene Bit, das rechts aus dem Register herauskommt ist im
Flag X (eXtend) der CPU enthalten. Das "bisschen" ist wie eine Art "Wert
jenseits des Kommas", der die Annäherung der im  Register enthaltenen
"Ganzzahl" ausdrückt:
Durch Hinzufügen des Inhalts von Flag X auf die ganze Zahl werden alle Zahlen
gerundet.
Zum Beispiel: 17 + 6 = 23, 23/2 = 11,5 (=% x 1) = 12 (gerundet);
oder noch einmal: 11 + 23 = 34, 34/2 = 17 (% x.0) = 17 (gerundet).

N.B.:	Haben Sie bemerkt, dass das Volumen (als Durchschnittswert der Sample
gedacht) der gemischten Sample niedriger ist als die Ausbeute der 2
gleichzeitig gelesenen Sample? Warum?  Die Antwort in der nächsten Folge ...
