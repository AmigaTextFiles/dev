
; Lezione14-2b.s	** SPIELE EINE HARMONISCHE IN VERSCHIEDENEN NOTEN 2 **


	SECTION	Armonica2b,CODE

Start:
	move.l	4.w,a6
	jsr	-$78(A6)				; _LVODisable
	bset	#1,$bfe001			; Schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7			; dmaconr - speichern DMA für OS

	move.l	#armonica,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.w	#16/2,$a4(a6)		; 16 bytes/2=8 word der Daten (AUD0LEN)

	move.l	#1<<16!2,d0			; spielen RE3 bzw. D5 (589Hz) 
	moveq	#16,d1				; Länge=16 byte
	bsr.s	note2per
	move.w	d0,$a6(a6)			; AUD0PER mit dem Ergebnis

	move.w	#64,$a8(a6)			; AUD0VOL maximal (0 dB)
	move.w	#$8201,$96(a6)		; einschalten AUD0 DMA in DMACONW

WLMB:	btst	#6,$bfe001		; warten mit der linken Maustaste
	bne.s	WLMB

	or.w	#$8000,d7			; Bit 15 schaltet ein (SET/CLR)
	move.w	#$0001,$96(a6)		; dmacon - ausschalten aud0
	move.w	d7,$96(a6)			; dmacon - reset DMA von OS
	move.l	4.w,a6
	jsr	-$7e(a6)				; _LVOEnable
	rts

******************************************************************************
;			« Periode der Note »
;
; Berechnen der einzufügenden Periode in AUDxPER Daten für Note und Oktave
;
; d0hi.w  = Note (0[DO]..6[SI])
; d0lo.w  = Oktave (0[1]..3[4])
; d1.w	  = Länge Harmonische (in byte)
******************************************************************************

Clock	equ	3546895
DO1	equ	131					; Frequenz [Hz] für DO1  ; C3 = 130,81HZ

Note2Per:
	move.w	#do1,d2			; d2.w=DO1
	lsl.w	d0,d2			; d2.w=DOx (zweite Oktave in d0lo.w)
	swap	d0				; d0lo.w=d0hi.w
	add.w	d0,d0			; d0.w=d0.w*4
	add.w	d0,d0			; für Offset longword der NOTEN
	mulu.w	notes(pc,d0.w),d2	; d2.l=DOx*Zähler Bruch
	divu.w	notes+2(pc,d0.w),d2	; d2.l=DOx*Zähler Bruch/Nenner Bruch = Frequenz Note
	mulu.w	d1,d2			; d2.l=Freq. Note*Länge=Samplingfrequenz
	move.l	#clock,d0		; d0.l=Zeitkonstante
	divu.w	d2,d0			; d0.w=Zeit/Samplingfrequenz
	rts						; [d0.w=Periode für Sampling]

Notes:						; deutsche Notennamen
DO:	dc.w	1,1				; C 
RE:	dc.w	9,8				; D
MI:	dc.w	5,4				; E
FA:	dc.w	4,3				; F
SOL:	dc.w	3,2			; G	 
LA:	dc.w	5,3				; A	(z.B. A4=440Hz)
SI:	dc.w	15,8			; H	


******************************************************************************

	SECTION	Sample,DATA_C	; Wird es von der DMA gelesen, muss es sich in CHIP befinden

	; Harmonische von 16 Werten, die mit dem IS von trash'm-one erzeugt wurden 

Armonica:
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5

	END

******************************************************************************

Wie im Text der Lektion erläutert, wird bei jeder Oktave die Frequenz der Note
verdoppelt. Wenn also DO der ersten Oktave 131 Hz hat, so hat DO2 262 Hz,
das DO3 524 Hz usw. Innerhalb der Skala gibt es sehr genaue Zusammenhänge
zwischen den Frequenzen der 7 Noten: DO=1, RE=9/8, MI=5/4, FA=4/3, SOL=3/2, LA=5/3,
SI=15/8 (und das nächste DO = 2). Mit dieser Tabelle ist es sehr einfach möglich
die Frequenz jeder Note eines Oktavenbeginns von einer Note einer Oktave 
zu berechnen.
Das Unterprogramm "Note2Per" möchte als Eingabeparameter: in das hohe Wort von d0
die Note (von 0 für den DO bis 6 für den SI) und die Oktave (von 0 für die erste
bis 3 für die vierte) im Low-Word von d0 und in d1 die Länge des Samples in Bytes.
Es berechnet die in das AUDxPER-Register einzugebende Abtastperiode und muss
nur die Frequenz der Note DO1 und die gewünschte Note kennen.
Wie funktioniert es? Einfach: Beachten Sie zunächst die Beziehungen zwischen den
Noten in Bezug auf das DO. Jeder Note sind Wortdaten zugeordnet. 
Der erste Wert gibt den Zähler des Bruchs an und der zweite den Nenner. Die
Routine verdoppelt zuallererst die Frequenz des DO1 um den Wert im tiefen Word
von Parameter d0, welcher die Oktave angibt, durch einfaches Verschieben nach
links (Multiplikation mit jeweils * 2). Durch Einfachverschiebung wird der
Wert 131 (Frequenz des DO1) mit so vielen Bits wie der Wert in d0lo.w enthält
nach links verschoben.
Dann, basierend auf den in d0hi.w angegebenen Wert, nimmt es ab
Noten + d0hi.w * 4 ein Longword mit dem Zähler im oberen Word und dem 
Nenner des Bruchs im unteren Word, der das Verhältnis der Note angibt.
Damit wird die Frequenz der gewünschten Note durch Multiplikation mit dem Bruch
berechnet. Zuerst durch Multiplikation mit dem Zähler des Bruchs (High Word)
und dann dividieren wir alles durch den Nenner des Bruchs. (Low word)

Endlich haben wir die genaue Frequenz erhalten. Die berechnete Abtastperiode
für das Sample der Länge d1.w wird VOLLSTÄNDIG mit der Frequenz der Note
gelesen.

Wie wir in den vorhergehenden Beispielen erwähnt haben, berechnen wir für die 
abgeleitete Abtastperiode nicht die Anzahl der zu lesenden Bytes pro Sekunde,
aber die Periode der Abtastung abgeleitet aus der Häufigkeit, mit der ALLE
Harmonischen in 1 Sekunde gelesen werden müssen. Es ist gleich dem Produkt 
zwischen der Frequenz und der Länge in Bytes der Welle: ein höherer Wert!),
dividiert durch das Produkt zwischen der Länge des Samples und der Frequenz der Note.

Wenn wir zum Beispiel ein SOL2 spielen wollen, müssen wir den Wert 4 (5.Note)
im hohen Wort und 1 (2. Oktave) im tiefen Wort von d0 haben.
Die Frequenz der Note wird sein:
			       ((131 * 2^Oktave) * 3)/2
					  |					/  \
					 DO1           Zähler  Nenner
					 \____________/
						|
				       DOx

** Grundsätzlich wird zuerst das DO der nächsten Oktave berechent und dann
mit 3/2 ("drei halbe") multipliziert. **
 
N.B.:	
So wie es ist, hat die "Note2Per"-Routine eine Einschränkung: Wie Sie
wissen, wird die 68000 Multiplikationen mit 16 Bit * 16 Bit = 32 Bit und die
Divisionen 32bit / 16bit = 16bit (der Rest im oberen Wort des Ergebnisses)
ausgeführt. Es ist also nicht möglich, zu lange Samples mit einer zu hohen
Frequenz abzuspielen. Einfach, weil das Produkt von Länge und Frequenz
durch die Zeitkonstante geteilt werden muss und daher der Teiler der
DIVU in einem Word sein muss (glücklicherweise ohne Vorzeichen).
** In der Praxis schadet diese Einschränkung jedoch niemandem, da die
Lesegeschwindigkeit = Notenfrequenz * Samplelänge nicht
28836 Hz überschreiten kann, ein Wert, der bequem in ein Wort passt:
VERWENDEN SIE KEINE ZU HOHEN FREQUENZEN FÜR ZU LANGE SAMPLES **