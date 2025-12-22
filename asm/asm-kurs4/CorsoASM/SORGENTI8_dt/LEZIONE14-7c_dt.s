                                      
; Lezione14-7c:  * MODULIEREN DER AMPLITUDE UND FREQUENZ EINER HARMONISCHER  *

	SECTION	LEZIONExx7b,CODE

Start:

	lea	modvolfq,a0
	moveq	#0,d0
	moveq	#123,d1
	move.w	#64-1,d7
.Lp1:	move.w	d0,(a0)+
	addq.w	#1,d0
	move.w	d1,(a0)+
	addq.w	#4,d1
	dbra	d7,.lp1
	move.w	#64-1,d7
.Lp2:	move.w	d0,(a0)+
	subq.w	#1,d0
	move.w	d1,(a0)+
	subq.w	#4,d1
	dbra	d7,.lp2

_LVODisable	EQU	-120
_LVOEnable	EQU	-126

	move.l	4.w,a6
	jsr	_LVODisable(a6)

	bset	#1,$bfe001			; schaltet den Tiefpassfilter aus

	lea	$dff000,a6
	move.w	$2(a6),d7			; speichern DMA von OS
	move.w	$10(a6),d6			; speichern ADKCON von OS

Clock	equ	3546895

	move.l	#armonica,$b0(a6)							; AUD1LCH
	move.w	#16/2,$b4(a6)								; AUD1LEN (in word)

	move.l	#modvolfq,$a0(a6)							; AUD0LCH
	move.w	#(modvolfq_end-modvolfq)/2,$a4(a6)			; AUD0LEN
	move.w	#clock/((modvolfq_end-modvolfq)/2),$a6(a6)	; AUD0PER

	move.w	#$8011,$9e(a6)		; USE0V1 und USE0P1 einstellen

	move.w	#$8203,$96(a6)		; einschalten AUD0 und AUD1 in DMACONW

WLMB:	btst	#6,$bfe001		; warte auf die linke Maustaste
	bne.s	WLMB

	move.w	#$0011,$9e(a6)		; USE0V1 und USE0P1 ausschalten
	or.w	#$8000,d6			; Bit 15 schaltet ein (SET/CLR)
	move.w	d6,$9e(a6)			; rücksetzen ADKCON von OS
	move.w	#$0003,$96(a6)		; ausschalten AUD0 und AUD1
	or.w	#$8000,d7			; Bit 15 schaltet ein (SET/CLR)
	move.w	d7,$96(a6)			; rücksetzen DMA von OS
	move.l	4.w,a6
	jsr	_LVOEnable(a6)
	rts

	SECTION	Sample,DATA_C	; Wird es von der DMA gelesen, muss es sich im CHIP befinden

Armonica:	; Harmonische von 16 Werten, die mit dem IC des Trash'm-One erzeugt wurden
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5
ModVolFq:
	blk.w	64*2*2
ModVolFq_end:
	END

So modulieren Sie einen Klang sowohl in der Amplitude als auch in der Frequenz:
Die Tabelle besteht aus 2 alternierenden Werten, zunächst ein Wort mit dem
7-Bit-Volumen für AUD1VOL und dann ein zweites Wort mit der 16-Bit-Periode
für AUD0PER. In derselben Reihenfolge werden die Daten auch in AUD0DAT
eingegeben: zuerst das Volume, dann die Periode.
Natürlich werden sowohl das Bit für die Frequenzmodulation als auch das für
die Amplitudenmodulation von Kanal 0 in Bezug auf Kanal 1 gesetzt.

