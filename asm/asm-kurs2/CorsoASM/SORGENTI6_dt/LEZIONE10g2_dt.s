
; Lezione10g2.s	Beispiel für ODER zwischen einem aktivierten Kanal und 
				; einem deaktivierten Kanal
				; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE1,d0		; 
	LEA	BPLPOINTERS,A1			; Zeiger COP
	MOVEQ	#1-1,D1				; Anzahl der Bitplanes (hier ist es 1)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0			; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	lea	Figura,a0
	lea	BITPLANE1+20,a1
	bsr.s	copia		; mache die Kopie Figur 2

mouse1:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse1		; wenn nicht, nicht abbrechen

	bsr.s	BlitOR		; Führe das ODER zwischen den 2 Figuren aus

mouse2:
	btst	#6,$bfe001	; linke Maustaste gedrückt?
	bne.s	mouse2		; Wenn nicht, gehe zurück zu mouse2:
	rts


;****************************************************************************
; Diese Routine kopiert die Figur auf den Bildschirm.
; Es braucht als Parameter
; A0 - Quelladresse
; A1 - Zieladresse
;****************************************************************************

Copia:
	btst	#6,2(a5) ; dmaconr
WBlit1:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$09f00000,$40(a5)	; BLTCON0 und BLTCON1 (A+D)
								; normale Kopie
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#30,$66(a5)			; BLTDMOD (40-10=30)
	move.l	a0,$50(a5)			; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)			; BLTDPT  Zeiger Ziel
	move.w	#(64*71)+5,$58(a5)	; BLTSIZE (Blitter starten !)
								; Breite 5 word
	rts							; Höhe 71 Zeilen

;****************************************************************************
; Diese Routine ist das ODER zwischen einer Figur, die durch den Kanal B gelesen 
; wird und dem konstanten Wert, der in BLTADAT enthalten ist
;****************************************************************************

;	  |\__/,|   (`\
;	  |_ _  |.--.) )
;	  ( T   )     /
;	 (((^_(((/(((_>

BlitOR:
	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$05fc0000,$40(a5)	; BLTCON0 und BLTCON1
				; benutze die Kanäle B und D
				; führt das OR zwischen A und B durch (LF = $FC)
	move.w	#0,$62(a5)			; BLTBMOD (=0)
	move.w	#30,$66(a5)			; BLTDMOD (40-10=30)
	move.w	#$CCCC,$74(a5)		; Wert von OR in BLTADAT

	move.l	#Figura,$4c(a5)		; BLTBPT  Zeiger Quelle
	move.l	#BITPLANE1+100*40+10,$54(a5)	; BLTDPT  Zeiger Ziel
	move.w	#(64*71)+5,$58(a5)	; BLTSIZE (Blitter starten!)
								; Breite 5 word
	rts							; Höhe 71 Zeilen

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

	dc.w	$100,$1200	; bplcon0 - 1 bitplane lowres

BPLPOINTERS:
	dc.w $e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$aaa	; color1

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

Figura:
	dc.w	$ffff,$ffff,$ffff,$ffff,$fe00,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,$3800,0,0
	dc.w	0,$0003,$ff80,0,0,0,$001f,$fff0,0,0
	dc.w	0,$01ff,$ffff,0,0,0,$0fff,$ffff,$e000,0
	dc.w	0,$ffff,$ffff,$fe00,0,$0007,$ffff,$ffff,$ffc0,0
	dc.w	$007f,$ffff,$ffff,$fffc,0,$03ff,$ffff,$ffff,$ffff,$8000
	dc.w	$3fff,$ffff,$ffff,$ffff,$f800,$7fff,$ffff,$ffff,$ffff,$fc00
	dc.w	$3fff,$ffff,$ffff,$ffff,$f800,$03ff,$ffff,$ffff,$ffff,$8000
	dc.w	$007f,$ffff,$ffff,$fffc,0,$0007,$ffff,$ffff,$ffc0,0
	dc.w	0,$ffff,$ffff,$fe00,0,0,$0fff,$ffff,$e000,0
	dc.w	0,$01ff,$ffff,0,0,0,$001f,$fff0,0,0
	dc.w	0,$0003,$ff80,0,0,0,0,$3800,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$8000,0,0,0,$0200,$8000,0,0,0,$0200
	dc.w	$ffff,$ffff,$ffff,$ffff,$fe00

;****************************************************************************

	SECTION	bitplane,BSS_C
BITPLANE1:
	ds.b	40*256

	end

;****************************************************************************

In diesem Beispiel führen wir ein ODER zwischen einer Figur, die durch den 
Kanal B gelesen wird und einem konstanten Wert der im BLTADAT-Register enthalten 
ist durch.
Aus diesem Grund haben wir die Kanäle B und D aktiviert und programmieren das 
LF-Byte so dass ein OR zwischen den Quellen A und B durchgeführt wird.