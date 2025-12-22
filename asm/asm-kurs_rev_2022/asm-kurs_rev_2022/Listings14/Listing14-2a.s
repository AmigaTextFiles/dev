
; Listing14-2a.s	** SPIELE EINE HARMONISCHE IN VERSCHIEDENEN NOTEN **

	SECTION	Armonica2,CODE

Start:
	move.l	4.w,a6
	jsr	-$78(A6)				; _LVODisable

	bset	#1,$bfe001			; Schaltet den Tiefpassfilter aus

	lea	$dff000,a6
	move.w	$2(a6),d7			; dmaconr - speichern DMA für OS

Clock	equ	3546895

	move.l	#armonica,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.w	#16/2,$a4(a6)		; 16 bytes/2=8 word der Daten (AUD0LEN)
	move.l	#clock/16,d1		; 1/16 = ein 16tel der Zeit
	divu.w	do3(pc),d1			; <<< ÄNDERN SIE DEN ERSTEN OPERANDEN VON
								; DIESER TONLEITER, UM ANDERE ZU GENERIEREN
								; SIEHE ANMERKUNGEN >>>
	move.w	d1,$a6(a6)			; AUD0PER mit der berechneten Periode
	move.w	#64,$a8(a6)			; AUD0VOL maximal (0 dB)
	move.w	#$8001,$96(a6)		; einschalten AUD0 DMA in DMACONW

WLMB:	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	WLMB

	or.w	#$8000,d7			; Bit 15 schaltet ein (SET/CLR)
	move.w	#$0001,$96(a6)		; dmacon - ausschalten  aud0
	move.w	d7,$96(a6)			; dmacon - Reset DMA von OS
	move.l	4.w,a6
	jsr	-$7e(a6)				; _LVOEnable
	rts


DO3:	dc.w	528				; Frequenzen der Note
RE3:	dc.w	528*9/8
MI3:	dc.w	528*5/4
FA3:	dc.w	528*4/3
SOL3:	dc.w	528*3/2
LA3:	dc.w	528*5/3
SI3:	dc.w	528*15/8
DO4:	dc.w	528*2


******************************************************************************

	SECTION	Sample,DATA_C		; Wird es von der DMA gelesen, muss es sich in CHIP befinden

	; Harmonische von 16 Werten, die mit dem IS von trash'm-one erzeugt wurden 

Armonica:
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5

	END

******************************************************************************

Bei 1/16 der Zeit (= 35468095/16) würde die Harmonische mit 1 Hz gelesen, da 
es 16 Bytes lang ist und - wie wir es im ersten Listing gesagt haben - da es 
16 pro Sekunde liest wird die gesamte Harmonische 1 Mal pro Sekunde gelesen 
(= 1 Hz, tatsächlich)
Teilen Sie die den Takt 1/16 durch die Frequenz der zu spielenden Note am
relativen Label im RAM wird die Lesefrequenz mit 1 Hz für die Frequenz der 
Note multipliziert. In der Tat, liest die Hardware die Harmonische 
(das Ganze) mehrmals pro Sekunde. 

Es wäre möglich gewesen, dasselbe Ergebnis zu erzielen, wenn
AUD0PER auch mit folgendem Code eingegeben wurde:

	[...]
	move.l	#clock,d1		; Zeitkonstante
	move.w	do3(pc),d2		; ...oder irgendeine andere Frequenz...
	mulu.w	#16,d2			; d2.l = 16*Frequenz der Note
	divu.w	d2,d1			; d1.w = clock/(16*freq)
	move.w	d1,$a6(a6)		; AUD0PER einstellen
	[...]

AUD0PER=Takt/(Frequenz*Anzahl Samples)
AUD0PER=3546895/(528*16) = 420
oder:
AUD0PER=(3546895/16)/528 = 420