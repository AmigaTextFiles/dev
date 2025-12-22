
; Lezione9b1.s	Beispiel für OR zwischen 2 Kanälen
; Rechte Taste um den Blitt zu starten, links um zu beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; speichern Copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; copper,bitplane,blitter DMA


START:

	MOVE.L	#BITPLANE1,d0	; 
	LEA	BPLPOINTERS,A1		; Zeiger COP
	MOVEQ	#1-1,D1			; Anzahl bitplanes
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0	; + Bitplane Länge (hier 256 Zeilen hoch)
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA ausschalten
	move.w	#$c00,$106(a5)		; AGA ausschalten
	move.w	#$11,$10c(a5)		; AGA ausschalten

	lea	Figura1,a0
	lea	BITPLANE1,a1
	bsr.s	copia		; mach eine Kopie Figur 1

	lea	Figura2,a0
	lea	BITPLANE1+20,a1
	bsr.s	copia		; mach eine Kopie Figur 2

mouse1:
	btst	#2,$dff016	; rechte Maustaste gedrückt?
	bne.s	mouse1		; Wenn nicht, gehe zurück zu mouse1:

	bsr.s	BlitOR		; Führe das ODER zwischen den 2 Figuren aus

mouse2:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse2			; Wenn nicht, gehe zurück zu mouse2:
	rts


;****************************************************************************
; Diese Routine kopiert die Figur auf dem Bildschirm.
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
	move.w	#0,$64(a5)		; BLTAMOD (=0)
	move.w	#30,$66(a5)		; BLTDMOD (40-10=30)
	move.l	a0,$50(a5)		; BLTAPT  Zeiger Quelle
	move.l	a1,$54(a5)		; BLTDPT  Zeiger Ziel
	move.w	#(64*71)+5,$58(a5)	; BLTSIZE (Blitter starten !)
							; Breite 5 word
	rts						; Höhe 71 Zeilen

;****************************************************************************
; diese Routine macht das ODER zwischen 2 Figuren mit den Kanälen A und B
;****************************************************************************

;	           /#\    ...
;	          /   \  :   :
;	         / /\  \c o o ø
;	        /%/  \  (  ^  )    /)OO
;	       (  u  / __\ O / \   \)(/
;	       UUU_ ( /)  `-'`  \  /%/
;	        /  \| /   <  :\  )/ /
;	       /  . \::.   >.( \ ' /
;	      /  /\   '::./|. ) \#/
;	     /  /  \    ': ). )
;	 __ û%,/    \   / (.  )
;	(  \% /     /  /  ) .'
;	 \_ò /     /  /   `:'
;	  \_/     /  /
;	         /\./
;	        /.%
;	       / %
;	      (  %
;	       \ ~\
;	        \__)

BlitOR:
	btst	#6,2(a5) ; dmaconr
WBlit2:
	btst	#6,2(a5) ; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; Maske
	move.l	#$0dfc0000,$40(a5)	; BLTCON0 und BLTCON1
					; benutze die Kanäle A,B und D
					; Führen Sie das ODER zwischen A und B (LF=$FC) aus
	move.w	#0,$64(a5)		; BLTAMOD (=0)
	move.w	#0,$62(a5)		; BLTBMOD (=0)
	move.w	#30,$66(a5)		; BLTDMOD (40-10=30)

	move.l	#Figura1,$50(a5)		; BLTBPT  Zeiger Quelle
	move.l	#Figura2,$4c(a5)		; BLTAPT  Zeiger Quelle
	move.l	#BITPLANE1+100*40+10,$54(a5)	; BLTDPT  Zeiger Ziel
	move.w	#(64*71)+5,$58(a5)	; BLTSIZE (Blitter starten !)
							; Breite 5 word
	rts						; Höhe 71 Zeilen

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
	dc.w 	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000	; color0
	dc.w	$0182,$aaa	; color1

	dc.w	$FFFF,$FFFE	; Ende copperlist

;****************************************************************************

Figura1:
	dc.w	$ffc0,0,0,$0007,$fe00,$8000,0,$1000,0,$0200
	dc.w	$8000,0,$3800,0,$0200,$8000,0,$3800,0,$0200
	dc.w	$8000,0,$3800,0,$0200,$8000,0,$3800,0,$0200
	dc.w	$8000,0,$7c00,0,$0200,$8000,0,$7c00,0,$0200
	dc.w	$8000,0,$7c00,0,$0200,$8000,0,$fe00,0,$0200
	dc.w	$8000,0,$fe00,0,$0200,$8000,0,$fe00,0,$0200
	dc.w	$8000,0,$fe00,0,$0200,$8000,$0001,$ff00,0,$0200
	dc.w	$8000,$0001,$ff00,0,$0200,$8000,$0001,$ff00,0,$0200
	dc.w	$8000,$0003,$ff80,0,$0200,$8000,$0003,$ff80,0,$0200
	dc.w	$8000,$0003,$ff80,0,$0200,$8000,$0003,$ff80,0,$0200
	dc.w	$8000,$0007,$ffc0,0,$0200,$8000,$0007,$ffc0,0,$0200
	dc.w	$8000,$0007,$ffc0,0,$0200,$8000,$000f,$ffe0,0,$0200
	dc.w	$8000,$000f,$ffe0,0,$0200,$8000,$000f,$ffe0,0,$0200
	dc.w	$8000,$000f,$ffe0,0,$0200,$8000,$001f,$fff0,0,$0200
	dc.w	$8000,$001f,$fff0,0,$0200,$8000,$001f,$fff0,0,$0200
	dc.w	$8000,$003f,$fff8,0,$0200,$8000,$003f,$fff8,0,$0200
	dc.w	$8000,$003f,$fff8,0,$0200,$8000,$003f,$fff8,0,$0200
	dc.w	$8000,$007f,$fffc,0,$0200,$8000,$007f,$fffc,0,$0200
	dc.w	$8000,$007f,$fffc,0,$0200,$8000,$003f,$fff8,0,$0200
	dc.w	$8000,$003f,$fff8,0,$0200,$8000,$003f,$fff8,0,$0200
	dc.w	$8000,$003f,$fff8,0,$0200,$8000,$001f,$fff0,0,$0200
	dc.w	$8000,$001f,$fff0,0,$0200,$8000,$001f,$fff0,0,$0200
	dc.w	$8000,$000f,$ffe0,0,$0200,$8000,$000f,$ffe0,0,$0200
	dc.w	$8000,$000f,$ffe0,0,$0200,$8000,$000f,$ffe0,0,$0200
	dc.w	$8000,$0007,$ffc0,0,$0200,$8000,$0007,$ffc0,0,$0200
	dc.w	$8000,$0007,$ffc0,0,$0200,$8000,$0003,$ff80,0,$0200
	dc.w	$8000,$0003,$ff80,0,$0200,$8000,$0003,$ff80,0,$0200
	dc.w	$8000,$0003,$ff80,0,$0200,$8000,$0001,$ff00,0,$0200
	dc.w	$8000,$0001,$ff00,0,$0200,$8000,$0001,$ff00,0,$0200
	dc.w	$8000,0,$fe00,0,$0200,$8000,0,$fe00,0,$0200
	dc.w	$8000,0,$fe00,0,$0200,$8000,0,$fe00,0,$0200
	dc.w	$8000,0,$7c00,0,$0200,$8000,0,$7c00,0,$0200
	dc.w	$8000,0,$7c00,0,$0200,$8000,0,$3800,0,$0200
	dc.w	$8000,0,$3800,0,$0200,$8000,0,$3800,0,$0200
	dc.w	$8000,0,$3800,0,$0200,$8000,0,$1000,0,$0200
	dc.w	$ffc0,0,0,$0007,$fe00

Figura2:
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

In diesem Beispiel sehen wir das ODER zwischen zwei Figuren. Es ist ein 
einfacher Blitting, welcher das OR zwischen den 2 Kanälen A und B unter 
Verwendung des Wertes von LF wie in der Lektion berechnet durchführt.
Als Übung können Sie zum Lesen den C-Kanal anstelle von B nehmen.
Die vorgenommenen Änderungen sind die Folgenden:
Ersetzen Sie die Modulo- und Zeigerregister von Kanal B durch diejenigen 
von C und aktivieren sie den Kanal C anstatt B. Weiterhin berechnen Sie 
den LF-Wert, um das OR zwischen A und C durchzuführen.
Die Berechnung von LF ist einfach: Schau dir einfach die Tabelle Abb. 27e an.
Stellen Sie 1 bei allen minterms ein, bei der die Kombinationen mit A = 1  
und C = 1 entsprechen. Sie erhalten LF = $FA.
Wiederholen Sie die gleiche Übung, um das ODER zwischen den Kanälen B und 
C zu machen.