
; Listing9h1.s		Beispiel für die Verwendung der Maske

; Drücken Sie die linke und rechte Maustaste abwechselnd, um 
; verschiedene Blitts mit verschiedenen Masken zu sehen.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"		; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA ; $83C0


START:	
	MOVE.L	#BITPLANE,d0		; Zeiger auf das Bild
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

; Parameter vorbereiten
	move.w	#$ffff,d0				; erste Wortmaske - alle Bits übergeben
	move.w	#$ffff,d1				; letzte Wortmaske - alle Bits übergeben
	lea	bitplane+2,a0				; Adresse Ziel
	bsr.w	Copia

mouse2:
	btst	#2,$dff016				; rechte Maustaste gedrückt?
	bne.s	mouse2					; Wenn nicht, gehe zurück zu mouse2:

; Parameter vorbereiten
	moveq	#$0000,d0				; erste Wortmaske - alles löschen
	move.w	#$ffff,d1				; letzte Wortmaske - alle Bits übergeben
	move.l	#bitplane+30*40+2,a0	; Adresse Ziel
	bsr.s	Copia

mouse3:
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mouse3					; Wenn nicht, gehe zurück zu mouse3:

; Parameter vorbereiten
	move.w	#%1010101010101010,d0	; erste Wortmaske - ein bisschen ja und nein
	move.w	#%0000000000000001,d1	; letzte Wortmaske - nur etwas mehr nach rechts
	lea	bitplane+60*40+2,a0			; Adresse Ziel
	bsr.s	Copia

mouse4:
	btst	#2,$dff016				; rechte Maustaste gedrückt?
	bne.s	mouse4					; Wenn nicht, gehe zurück zu mouse4:

; Parameter vorbereiten
	moveq	#$0000,d0				; erste Wortmaske - alles löschen
	moveq	#$0000,d1				; letzte Wortmaske - alles löschen
	lea	bitplane+90*40+2,a0			; Adresse Ziel
	bsr.s	Copia

mouse5:
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mouse5					; Wenn nicht, gehe zurück zu mouse5:

; Parameter vorbereiten
	move.w	#%1111000011110000,d0	; erste Wortmaske - 4 Bits ja und 4 nein
	move.w	#%0000011010011100,d1	; letzte Wortmaske - nur die Bits 2,3,4,7,9 und 10
	lea	bitplane+120*40+2,a0		; Adresse Ziel
	bsr.s	Copia

mouse6:
	btst	#2,$dff016				; rechte Maustaste gedrückt?
	bne.s	mouse6					; Wenn nicht, gehe zurück zu mouse6:

; Parameter vorbereiten
	move.w	#%0000000001111111,d0	; erste Wortmaske - lösche die linken 9 Bits
	move.w	#%1111111000000000,d1	; letzte Wortmaske - lösche die 9 am weitesten
									; rechts stehenden Bits
	lea	bitplane+150*40+2,a0		; Adresse Ziel
	bsr.s	Copia

mouse:
	btst	#6,$bfe001
	bne.s	mouse

	rts

;****************************************************************************
; Diese Routine kopiert die Figur auf den Bildschirm.
;
; A0 - Zieladresse
; D0.w - erste Wortmaske
; D1.w - letzte Wortmaske
;****************************************************************************

;	    .....        ___
;	 .:::::::::.  /\////
;	:¦::·_  _·:¦. \  _/
;	:|   ¤,¸¤  l: / /
;	:\ \/\___T /:/ /
;	::\_______/:: /
;	· __|  l__/ :/
;	 /_,       _/
;	/ (__°_X_°__)
;	\  j      |
;	 \ \   .  |
;	  \ \_____|
;	   \ \__" \
;	   (_,_,)  \
;	   | ¯ ¯T   \
;	   |    l_  _)
;	   |    |   /
;	  _l____l__/
;	 (_____)\  \
;	         \__)

Copia:
	btst	#6,2(a5)			; dmaconr
WBlit1:
	btst	#6,2(a5)			; dmaconr - warte auf das Ende des Blitters
	bne.s	wblit1

	move.w	d0,$44(a5)			; BLTAFWM Maskenwert laden
	move.w	d1,$46(a5)			; BLTALWM Maskenwert laden
	move.w	#$09f0,$40(a5)		; BLTCON0 (Kopie A nach D)
	move.w	#$0000,$42(a5)		; BLTCON1 wir erklären es später
	move.w	#0,$64(a5)			; BLTAMOD (=0)
	move.w	#34,$66(a5)			; BLTDMOD (40-6=34)
	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  Adresse Ziel
	move.w	#(64*7)+3,$58(a5)	; BLTSIZE (Blitter starten !)
								; Breite 3 Worte
	rts							; Höhe 7 Zeilen (1 Ebene)

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
	dc.w	$100,$1200			; bplcon0 - 1 bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane

	dc.w	$0180,$000			; color0
	dc.w	$0182,$eee			; color1

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Wir definieren im Binärformat die Zahl, die 3 Wörter breit und 7 Zeilen hoch ist

Figura:
;		    0123456789012345  0123456789012345  0123456789012345
	dc.w	%1111111111000000,%0000001111000000,%0000001111111111
	dc.w	%1111111111000000,%0000111111110000,%0000001111111111
	dc.w	%1111111111000000,%0011111111111100,%0000001111111111
	dc.w	%1111111111111111,%1111111111111111,%1111111111111111
	dc.w	%1111111111000000,%0011111111111100,%0000001111111111
	dc.w	%1111111111000000,%0000111111110000,%0000001111111111
	dc.w	%1111111111000000,%0000001111000000,%0000001111111111

;****************************************************************************

	SECTION	PLANEVUOTO,BSS_C	

BITPLANE:
	ds.b	40*256				; bitplane lowres

	end

;****************************************************************************

In diesem Beispiel zeigen wir, wie die Masken den Blitt beeinflussen. Wir
haben eine Figur (eine Bitebene), die mehrmals auf den Bildschirm an
verschiedenen Positionen kopiert wird. Jede Kopie wird jedoch mit
verschiedenen Masken durchgeführt, wodurch die Effekte auftreten, die Sie
sehen. Wir haben eine Routine verwendet, die die Werte als Parameter für die
Masken und die Zieladresse des Blitts verwendet. Auf diese Weise führen wir
alle Kopien mit einer einzigen Routine aus und ändern nur die Werte der
Parameter. Die Parameter werden über die 68000-Register an die Routine
übergeben. Um die Wirkung der verschiedenen Werte der Masken zu verstehen,
lesen Sie die Kommentare im Listing.

