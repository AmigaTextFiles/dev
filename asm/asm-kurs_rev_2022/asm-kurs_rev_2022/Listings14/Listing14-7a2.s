                                        
; Listing14-7a2:	** MODULATION DER AMPLITUDE EINER HARMONISCHEN IN STEREO**

	SECTION	LEZIONExx7a2,CODE

Start:

	lea	modvol1,a0
	moveq	#0,d0
	moveq	#65-1,d7
.Lp1:	move.w	d0,(a0)+
	addq.w	#1,d0
	dbra	d7,.lp1
	subq.w	#1,d0
.Lp2:	move.w	d0,(a0)+
	dbra	d0,.lp2

	lea	modvol2,a0
	moveq	#65,d0
	moveq	#65-1,d7
.Lp3:	subq.w	#1,d0
	move.w	d0,(a0)+
	dbra	d7,.lp3
	moveq	#65-1,d7
.Lp4:	move.w	d0,(a0)+
	addq.w	#1,d0
	dbra	d7,.lp4

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
	move.w	#clock/(16*440),$b6(a6)						; AUD1PER - LA2
	move.l	#armonica,$d0(a6)							; AUD3LCH	
	move.w	#16/2,$d4(a6)								; AUD3LEN (in word)
	move.w	#clock/(16*440),$d6(a6)						; AUD3PER - LA2

	move.l	#modvol1,$a0(a6)							; AUD0LCH
	move.w	#(modvol1_end-modvol1)/2,$a4(a6)			; AUD0LEN (in word)
	move.w	#clock/((modvol1_end-modvol1)/2),$a6(a6)	; AUD0PER	
	move.l	#modvol2,$c0(a6)							; AUD2LCH
	move.w	#(modvol2_end-modvol2)/2,$c4(a6)			; AUD2LEN (in word)
	move.w	#clock/((modvol2_end-modvol2)/2),$c6(a6)	; AUD2PER

	move.w	#$8005,$9e(a6)		; einschalten USE0V1 und USE2V3

	move.w	#$820f,$96(a6)		; einschalten AUD0-AUD3 in DMACONW

WLMB:	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	WLMB

	move.w	#$0005,$9e(a6)		; ausschalten USE0V1 und USE2V3
	or.w	#$8000,d6			; Bit 15 schaltet ein (SET/CLR)
	move.w	d6,$9e(a6)			; rücksetzen ADKCON von OS
	move.w	#$000f,$96(a6)		; ausschalten AUD0-AUD3
	or.w	#$8000,d7			; Bit 15 schaltet ein (SET/CLR)
	move.w	d7,$96(a6)			; rücksetzen DMA von OS
	move.l	4.w,a6
	jsr	_LVOEnable(a6)
	rts

	SECTION	Sample,DATA_C	; Wird es von der DMA gelesen, muss es sich im CHIP befinden

Armonica:	; Harmonische von 16 Werten, die mit dem IC des Trash'm-One erzeugt wurden
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5
ModVol1:
	blk.w	65*2
ModVol1_end:
ModVol2:
	blk.w	65*2
ModVol2_end:
	END


Diesmal haben wir 2 "gestaffelte" Tabellen erstellt: die erste, gelesen von	
Kanal 0, moduliert die Lautstärke von Kanal 1 von 0 bis 64 und von 64 bis 0.
Die zweite, gelesen von Kanal 2 moduliert auch die Amplitude von Kanal 3 von
64 bis 0 und von 0 bis 64.
Dies verursacht einen offensichtlichen "Verschiebungsseffekt" der Tonausgabe
in einem STEREO-System.

Hier erfolgt das Lesen der Tabellen mit der Frequenz von "halben" Hz, da
die Hälfte der Tabelle mit 1 Hz gelesen wird.

N.B.:	Wenn Sie ein MONO-System haben, sollten Sie eine fortlaufende Note
	ohne Modulation hören hinsichtlich der Abnahme des Volumens eines Falles
	der andere steigt und kompensiert seine Leistung.
