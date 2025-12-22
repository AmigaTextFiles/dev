                                      
; Lezione14-7b:  ** MODULIEREN DER FREQUENZ EINER HARMONISCHEN  **

	SECTION	LEZIONExx7b,CODE

Start:

	lea	modfq,a0
	moveq	#123,d0
	move.w	#500-1,d7
.Lp1:	move.w	d0,(a0)+
	addq.w	#1,d0
	dbra	d7,.lp1
	move.w	#500-1,d7
.Lp2:	move.w	d0,(a0)+
	subq.w	#1,d0
	dbra	d7,.lp2

_LVODisable	EQU	-120
_LVOEnable	EQU	-126

	move.l	4.w,a6
	jsr	_LVODisable(a6)

	bset	#1,$bfe001		; schaltet den Tiefpassfilter aus

	lea	$dff000,a6
	move.w	$2(a6),d7		; speichern DMA von OS
	move.w	$10(a6),d6		; speichern ADKCON von OS

Clock	equ	3546895

	move.l	#armonica,$b0(a6)						; AUD1LCH
	move.w	#16/2,$b4(a6)							; AUD1LEN (in word)
	move.w	#64,$b8(a6)								; AUD1VOL

	move.l	#modfq,$a0(a6)							; AUD0LCH
	move.w	#(modfq_end-modfq)/2,$a4(a6)			; AUD0LEN (in word)
	move.w	#clock/((modfq_end-modfq)/2),$a6(a6)	; AUD0PER

	move.w	#$8010,$9e(a6)	; USE0P1 einstellen

	move.w	#$8203,$96(a6)	; einschalten AUD0 und AUD1 in DMACONW

WLMB:	btst	#6,$bfe001	; warte auf die linke Maustaste
	bne.s	WLMB

	move.w	#$0010,$9e(a6)	; USE0P1 ausschalten
	or.w	#$8000,d6		; Bit 15 schaltet ein (SET/CLR)
	move.w	d6,$9e(a6)		; rücksetzen ADKCON von OS
	move.w	#$0003,$96(a6)	; ausschalten AUD0 und AUD1
	or.w	#$8000,d7		; Bit 15 schaltet ein (SET/CLR)
	move.w	d7,$96(a6)		; rücksetzen DMA von OS
	move.l	4.w,a6
	jsr	_LVOEnable(a6)
	rts

	SECTION	Sample,DATA_C	; Wird es von der DMA gelesen, muss es sich im CHIP befinden


Armonica:	; Harmonische von 16 Werten, die mit dem IC des Trash'm-One erzeugt wurden
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5
ModFq:
	blk.w	500*2
ModFq_end:
	END


Diesmal wurde AUD1VOL eingestellt, was nicht geschehen ist für das 
AUD1PER, da es kontinuierlich vom Modulatorkanal modifiziert wird.
Der AUD0PER wurde stattdessen so eingestellt, das die 1000-Wörter-Tabelle 
in 2 Sekunden gelesen wird mit der Taktkonstante geteilt durch die halbe
Länge der Tabelle, also bei 1Hz werden 500 Wörter gelesen, das heißt
alles in "halben" Hz lesen.
