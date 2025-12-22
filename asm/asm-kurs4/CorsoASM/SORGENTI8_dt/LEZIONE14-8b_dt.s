
; Lezione14-8b.s:  * MISCHEN VON 2 SAMPLES UND VERSTÄRKEN DER LAUTSTÄRKE *

Start:

_LVODisable	EQU	-120
_LVOEnable	EQU	-126

	move.l	4.w,a6
	jsr	_LVODisable(a6)
	bset	#1,$bfe001		; schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7		; speichern DMA von OS


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
	bsr.s	boost_mixsamples

	lea	$dff000,a6
	move.l	#sample0,$a0(a6)
	move.l	#sample0,$b0(a6)
	move.w	#(sample0_end-sample0)/2,$a4(a6)
	move.w	#(sample0_end-sample0)/2,$b4(a6)
	move.w	#$8003,$96(a6)

WRMB:	btst	#10,$dff016
	bne.s	wrmb

	move.w	#$0003,$96(a6)	; DMA ausschalten
	or.w	#$8000,d7		; Bit 15 (SET/CLR) schaltet ein
	move.w	d7,$96(a6)		; wiederherstellen DMA von OS
	move.l	4.w,a6
	jsr	_LVOEnable(a6)
	rts


Boost_MixSamples:
		; [a0=dst sample, a1=src sample 1, a2=source sample 2]
		; [d0.l=dst length.b, d1.l=src1 length.b, d2.l=src2 length.b]
	movem.l	d0-d3/a0-a4,-(sp)
	lea	(a1,d1.l),a3		; a3=Ende des sample 1
	lea	(a2,d2.l),a4		; a4=Ende des sample 2
	moveq	#0,d3			; d3.w=0=MAX Startsample
.Lp1:	move.w	#$f00,$dff180
	move.b	(a1)+,d1		; d1.b= Meister von sample 1
	ext.w	d1				; d1.w=d1.b erweitert zum word
	move.b	(a2)+,d2		; d2.b= Meister von sample 2
	ext.w	d2				; d2.w=d2.b erweitert zum word
	add.w	d1,d2			; d2.w= ADDIEREN der Samples 1 und 2 zusammen
	bpl.s	.noabs
	neg.w	d2
.NoAbs:	cmp.w	d3,d2		; d2.w=absoluter Wert von d2
	bls.s	.nomax
	move.w	d2,d3			; wenn d2>d3: d3(MAX)=d2
.NoMax:	cmp.l	a3,a1		; endete am sample 1 ?
	bhs.s	.quit1			; wenn ja: exit
	cmp.l	a4,a2			; endete am sample 2 ?
	bhs.s	.quit1			; wenn ja: exit
	subq.l	#1,d0
	bhi.s	.lp1
.Quit1:	move.l	(sp),d0		; wiederherstellen d0 
	movem.l	5*4(sp),a1-a2	; wiederherstellen a1 und a2
	move.w	d3,$7ff0000
							; d3.w=durch die Summen erreicht
.Lp2:	move.w	#$00f,$dff180
	move.b	(a1)+,d1		; d1.b= Meister von sample 1
	ext.w	d1				; d1.w=d1.b erweitert zum word
	move.b	(a2)+,d2		; d2.b= Meister von sample 2
	ext.w	d2				; d2.w=d2.b erweitert zum word
	add.w	d1,d2			; d2.w=ADDIEREN der Samples 1 und 2 zusammen

	muls.w	#127,d2			; ANTEIL: d3(MAX)/127=d2/x
	divs.w	d3,d2
	move.b	d2,(a0)+

	cmp.l	a3,a1			; endete am sample 1 ?
	bhs.s	.quit2			; wenn ja: exit
	cmp.l	a4,a2			; endete am sample 2 ?
	bhs.s	.quit2			; wenn ja: exit
	subq.l	#1,d0			; dekrementiert lungh0.b bis 0...ohne
	bhi.s	.lp2
.Quit2:	movem.l	(sp)+,d0-d3/a0-a4
	rts


	SECTION	Sample,DATA_C

Sample1:
	incbin	"assembler3:sorgenti8/carrasco.21056"
Sample1_end:

Sample2:
	incbin	"assembler3:sorgenti8/lee3.21056"
Sample2_end:

Sample0:blk.b	sample1_end-sample1
Sample0_end:
	END


Theoretisch sollte echtes Mischen nur durch algebraisches Addieren von 
Samples erfolgen, jedoch aus offensichtlichen Gründen fallen sie häufig aus
dem 8-Bit-Bereich mit Vorzeichen und um die Wellenform direkt gleichmässig zu
verstärken müssen wir immer durch 2 teilen. 
Ergebnis: Die endgültige Intensitätsausbeute beträgt weniger als das der
2 Samples, die unabhängig voneinander auf zwei verschiedenen Kanälen gespielt
würden. Um den normalen Mischalgorithmus verwenden zu können, wäre es
erforderlich, dass die Summe niemals 127 über- oder -128 unterschreitet, also
niemals die Bereichsgrenzen verlässt.
Da es nicht sinnvoll ist, Samples niedrig abzutasten, weil 8-Bit-Audio keine
große Präzision hat, sind wir gezwungen, die Lautstärke der Samples bis zum 
Anschlag zu mischen: es gilt das höchste erreichte Volumen das durch die 
Summe erreicht werden kann und es wird als maximaler Bereich proportional zu 
127 verwendet (absoluter Wert maximal erreichbar):
NICHT 128, denn nur der negative Teil erreicht -128 und das Positive zu stark
zu verstärken - über 127 hinaus - wären wir am Punkt des ersten)
Die Proportionen - die ich persönlich normalerweise "den Zoom " in der
Mathematik nenne »- sind in diesem Fall nützlich, um das Feld / den Bereich
einzugrenzen. Innerhalb der Grenzen ist es proportional und für alle samples
gleich.
*** Grundsätzlich haben wir bis zum höchsten Wert verstärkt. Die Summen
waren nicht gleich 127 (oder -127) und alles andere ist proportional***.


N.B.: Obwohl es angemessen gewesen sein könnte, wurde keine Rundung angewendet: 
	Es hätte eine Art Annäherung verwendet werden sollen neben dem Kommas
	mehrerer Bits, die beim Inkrementieren - auch wenn nicht tatsächlich
	spürbar - die Qualität des Mischens hätte viele Probleme beim Verstehen
	der Quelle und vor allem der Geschwindigkeit verursacht:
	Nach Multiplikation mit 127 hätten wir alles nach rechts verschieben können
	von 16 Bit (Multiplikation der Zahl mit viel zum Simulieren des Kommas
	mit sehr großen Zahlen, um es dann zu teilen.) wodurch ein 32-Bit-Wert
	erhalten wird.
	Wert, der geteilt werden musste für MAX und dann um 16 Bit nach links
	verschoben und mit dem das höchstwertige Bit des verschobenen Teils
	gerundet um zur	Originalgröße zurückzukehren. All dies würde jedoch ein
	notwendiges Problem mit sich bringen wegen einer Begrenzung von 68000:
	Teilen des 32-Bit-Werts durch MAX, das Ergebnis - wenn MAX nahe am
	aktuellen Summenwert liegt - könnte	immer noch bei 32 sein, und die
	DIVS-Anweisung gibt - leider - das 16-Bit-Ergebnis im unteren Teil des
	Registers und den Rest im hohen zurück, das Wort löschen, das für uns
	so nützlich ist. Das Problem hätte für jede andere Annäherung
	präsentieren können ...


