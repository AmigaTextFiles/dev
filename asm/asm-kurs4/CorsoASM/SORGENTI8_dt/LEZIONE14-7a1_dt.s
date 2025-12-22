
; Lezione14-7a1:  ** MODULATION DER AMPLITUDE EINER HARMONISCHEN **

	SECTION	LEZIONExx1,CODE

Start:

	lea	modvol,a0
	moveq	#0,d0
	moveq	#65-1,d7
.Lp1:	move.w	d0,(a0)+
	addq.w	#1,d0
	dbra	d7,.lp1
	subq.w	#1,d0
.Lp2:	move.w	d0,(a0)+
	dbra	d0,.lp2

_LVODisable	EQU	-120
_LVOEnable	EQU	-126

	move.l	4.w,a6
	jsr	_LVODisable(a6)

	bset	#1,$bfe001			; schaltet den Tiefpassfilter aus

	lea	$dff000,a6
	move.w	$2(a6),d7			; speichern DMA von OS
	move.w	$10(a6),d6			; speichern ADKCON von OS

Clock	equ	3546895

	move.l	#armonica,$b0(a6)					; AUD1LCH
	move.w	#16/2,$b4(a6)						; AUD1LEN (in word)
	move.w	#clock/(16*880),$b6(a6)				; AUD1PER

	move.l	#modvol,$a0(a6)						; AUD0LCH
	move.w	#(modvol_end-modvol)/2,$a4(a6)		; AUD0LEN (in word)
	move.w	#clock/(modvol_end-modvol),$a6(a6)	; AUD0PER

	move.w	#$8001,$9e(a6)		; USE0V1 einstellen

	move.w	#$8203,$96(a6)		; einschalten AUD0 und AUD1 in DMACONW

WLMB:	btst	#6,$bfe001		; warte auf die linke Maustaste
	bne.s	WLMB
								
	move.w	#$0001,$9e(a6)		; ausschalten USE0V1						
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
ModVol:
	blk.w	65*2
ModVol_end:
	END


Ganz einfach, wir haben zuerst eine Tabelle mit 130 Werten erstellt von
0 bis 64 und von 64 bis 0 für die AUD1VOL-Volumes, die wir über Kanal 0
gelesen haben, während Kanal 1 die Harmonische bei der LA3 - Frequenz
(880 Hz) ausliest.
Als eine Periode des Modulatorkanals gaben wir vor, dass er die normale
Probe las und wir gaben ihm die Lesegeschwindigkeit: weil die Tabelle
in 1 Sekunde gelesen wird, muss die Abtastperiode gerade bei der
Taktkonstante geteilt durch die Länge in Bytes der Tabelle = 1 Hz sein.

N.B.:	Beachten Sie, dass die Lautstärke von Kanal 0 (AUD0VOL) nicht
	eingestellt wurde, da es nicht notwendig ist, da seine Ausgabe nicht
	verstärkt wird (64 = -0 dB) und direkt im AUD1VOL-Register endet.
	AUD1VOL wurde auch am Anfang nicht eingestellt, da es sofort
	modifiziert wird durch den Modulator.
