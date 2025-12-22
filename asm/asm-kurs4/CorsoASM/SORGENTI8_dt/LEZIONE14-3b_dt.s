
; Lezione14-3b.s	** HAUPTAKKORD DER HARMONISCHEN MIT 4 STIMMEN **


	section	arm4,code 

Start:
	move.l	4.w,a6
	jsr	-$78(A6)				; _LVODisable
	bset	#1,$bfe001			; Schaltet den Tiefpassfilter aus
	lea	$dff000,a6
	move.w	$2(a6),d7			; dmaconr - speichern DMA für OS

	move.l	#armonica,$a0(a6)	; AUD0LCH.w+AUD0LCL.w=AUD0LC.l
	move.l	#armonica,$b0(a6)	; AUD1LCH.w+AUD1LCL.w=AUD1LC.l
	move.l	#armonica,$c0(a6)	; AUD2LCH.w+AUD2LCL.w=AUD2LC.l
	move.l	#armonica,$d0(a6)	; AUD3LCH.w+AUD2LCL.w=AUD3LC.l
	move.w	#16/2,$a4(a6)		; 16 bytes/2=8 word der Daten (AUD0LEN)
	move.w	#16/2,$b4(a6)		; 16 bytes/2=8 word der Daten (AUD1LEN)
	move.w	#16/2,$c4(a6)		; 16 bytes/2=8 word der Daten (AUD2LEN)
	move.w	#16/2,$d4(a6)		; 16 bytes/2=8 word der Daten (AUD3LEN)

	moveq	#16,d1
	moveq	#12*1+0,d2		; DO2 (Akkord per DO)

	move.l	d2,d0
	bsr.s	halftone2per
	move.w	d0,$a6(a6)		; AUD0PER
	addq.w	#2*2,d2			; + 2 Ton = MI
	move.l	d2,d0
	bsr.s	halftone2per
	move.w	d0,$b6(a6)		; AUD1PER
	addq.w	#2+1,d2			; + 1 Ton + 1 Halbton = SOL
	move.l	d2,d0
	bsr.s	halftone2per
	move.w	d0,$c6(a6)		; AUD2PER
	addq.w	#2+1,d2			; + 1 Ton + 1 Halbton = LA#
	move.l	d2,d0
	bsr.s	halftone2per
	move.w	d0,$d6(a6)		; AUD3PER

	move.w	#64,$a8(a6)		; AUD0VOL maximal (0 dB)
	move.w	#64,$b8(a6)		; AUD1VOL maximal (0 dB)
	move.w	#64,$c8(a6)		; AUD2VOL maximal (0 dB)
	move.w	#64,$d8(a6)		; AUD3VOL maximal (0 dB)
	move.w	#$800f,$96(a6)	; einschalten AUD0-AUD3 DMA in DMACONW

WLMB:
	btst	#6,$bfe001		; warten mit der linken Maustaste
	bne.s	WLMB
	or.w	#$8000,d7		; Bit 15 schaltet ein (SET/CLR)
	move.w	#$000f,$96(a6)	; ausschalten DMA
	move.w	d7,$96(a6)		; dmacon - reset DMA von OS
	move.l	4.w,a6
	jsr	-$7e(a6)			; _LVOEnable
	rts

******************************************************************************
;			« Periode der Halbtöne »
;
; Berechnen Sie die Periode, die in AUDxPER eingefügt werden soll, wenn der 
; Halbton von DO1 ausgeht
; d0.w   = Halbton (ab DO1 = 0)
; d1.w   = Länge Harmonische (in byte)
******************************************************************************

Clock	equ	3546895
DO1	equ	131			; Frequenz [Hz] für DO1  ; C3 = 130,81HZ

HalfTone2Per:
	move.l	d2,-(SP)
	divu.w	#12,d0
	move.w	#do1,d2
	lsl.w	d0,d2
	swap	d0
	add.w	d0,d0
	add.w	d0,d0
	mulu.w	halftones(pc,d0.w),d2
	divu.w	halftones+2(pc,d0.w),d2
	move.l	#clock,d0
	mulu.w	d2,d1
	divu.w	d1,d0		; DIVISION BY ZERO!!!
	move.l	(SP)+,d2
	rts			; [d0.w=Periode für Sampling]

HalfTones:
	dc.w	10000,10000	;DO=1.0
	dc.w	10595,10000	;DO#=1.0595
	dc.w	11225,10000	;RE=1.1225
	dc.w	11892,10000	;RE#=1.1892
	dc.w	12599,10000	;MI=1.2599
	dc.w	13348,10000	;FA=1.3348
	dc.w	14142,10000	;FA#=1.4142
	dc.w	14983,10000	;SOL=1.4983
	dc.w	15874,10000	;SOL#=1.5874
	dc.w	16818,10000	;LA=1.6818
	dc.w	17818,10000	;LA#=1.7818
	dc.w	18877,10000	;SI=1.8877

******************************************************************************

	SECTION	Sample,DATA_C	; wird es von der DMA gelesen, muss es sich in CHIP befinden

	; Harmonische von 16 Werten, die mit dem IS von trash'm-one erzeugt wurden

Armonica:
	DC.B	$19,$46,$69,$7C,$7D,$6A,$47,$1A,$E8,$BB,$97,$84,$83,$95,$B8,$E5

	END

******************************************************************************

Diese Quelle unterscheidet sich in keiner Weise von der vorherigen.
Die einzige Neuerung, die eingeführt wurde, ist die Verwendung aller Hardware-Kanäle
des Sound-Chips des Amiga... eigentlich nichts kompliziertes: Um das gleiche 
sample mit unterschiedlichen Frequenzen zu spielen ist es ausreichend, alle Register
AUDxLC, AUDxLEN und AUDxVOL mit demselben Wert für alle Kanäle zu setzen und
nur die Perioden in AUDxPER zu ändern.

In der Musik, um einen HAUPTAKKORD mit 3 oder mehr Noten zu erstellen (wir haben
hier 4, nur um die letzte Stimme nicht leer zu lassen ...) musst du 
GLEICHZEITIG  alle 3 richtigen Töne, aus denen der Akkord besteht spielen.
Hier ist das allgemeine Schema:

                               ******* WICHTIGE VEREINBARUNGEN *********
                               +------+--------------------------------+
                               | NOTE |       TONART				   |
                               +------+--------------------------------+
                               |  1a  |   Grundton des Akkords         |
                               |  2a  |  + 2 Töne = 4 Halbtöne         |
                               |  3a  |  + 1 Ton und halbe =3 Halbtöne |
                               |  4a  |  + 1 Ton und halbe =3 Halbtöne |
                               +------+--------------------------------+

Zum Beispiel für den MI-Akkord mit 3 Stimmen: MI + SOL # + SI
für den LA-Akkord mit 4 Stimmen: LA + DO # + MI + SOL.
