
; Listing10e1r.s	Blitt interleaved mit coppermonitor
			; Linke Taste zum Beenden.

	SECTION	CiriCop,CODE

;	Include	"DaWorkBench.s"	; entferne das ; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001111000000	; bitplane, copper, blitter DMA


START:
	MOVE.L	#BITPLANE,d0		; Zeiger auf die "leere" Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer
	MOVEQ	#3-1,D1				; Anzahl der Bitplanes (hier sind es 3)
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40,d0				; + LÄNGE EINER REIHE !!!!!
	addq.w	#8,a1
	dbra	d1,POINTBP

	lea	$dff000,a5				; CUSTOM REGISTER in a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - einschalten bitplane, copper, blitter
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	move.w	#0,ogg_x
	move.w	#0,ogg_y

mouse:
	addq.w	#1,ogg_y
	cmp.w	#130,ogg_y
	beq.s	fine

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$0f400,d2			; Warte auf Zeile $F4 
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos. 
	CMPI.L	D2,D0				; Warte auf Zeile $F4
	BNE.S	Waity1

;	   \\\|||///
;	 .  =======
;	/ \| O   O |
;	\ / \`___'/
;	 #   _| |_
;	(#) (     )
;	 #\//|* *|\\
;	 #\/(  *  )/
;	 #   =====
;	 #   ( U )
;	 #   || ||
;	.#---'| |`----.
;	`#----' `-----'

	move.w	#$f00,$180(a5)		; Ändern der Hintergrundfarbe in rot
	bsr.s	DisegnaOggetto		; zeichne den Bob

	btst	#6,2(a5)
WBlit_coppermonitor:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit_coppermonitor

	move.w	#$000,$180(a5)		; schwarzen Hintergrund zurücksetzen

	bra.s	mouse

fine:
	rts


;****************************************************************************
; Diese Routine zeichnet den BOB an die in den Variablen X_OGG und Y_OGG
; angegebenen Koordinaten.
;****************************************************************************

DisegnaOggetto:
	lea	bitplane,a0				; Zeile in a0
	move.w	ogg_y(pc),d0		; Koordinate Y
	mulu.w	#3*40,d0			; Adresse berechnen: Jede Zeile besteht aus
								; 3 Ebenen von jeweils 40 Bytes
	add.w	d0,a0				; zur Anfangsadresse hinzufügen

	move.w	ogg_x(pc),d0		; Koordinate X
	move.w	d0,d1				; Kopie
	and.w	#$000f,d0			; wir wählen die ersten 4 Bits, weil sie 
								; in den Shifter von Kanal A eingefügt werden
	lsl.w	#8,d0				; Die 4 Bits werden zum High-Nibble 
	lsl.w	#4,d0				; des Wortes bewegt...
	or.w	#$09f0,d0			; ... rechts, in das BLTCON0-Register einzugeben
	lsr.w	#3,d1				; (entspricht einer Division durch 8)
								; Runden auf ein Vielfaches von 8 für den Zeiger
								; auf den Bildschirm, also auch auf ungerade Adressen
								; (also zu Bytes)
								; zB: eine 16 als Koordinate wird zu Byte 2
	and.w	#$fffe,d1			; Ich schließe Bit 0 aus
	add.w	d1,a0				; addieren zur Adresse der Bitebene, 
								; um die richtige Zieladresse zu finden
	btst	#6,2(a5)
WBlit2:
	btst	#6,2(a5)			; warte auf das Ende des Blitters
	bne.s	wblit2

	move.l	#$ffffffff,$44(a5)	; BLTAFWM = $ffff Es passiert alles
								; BLTALWM = $0000 setzt das letzte Wort zurück

	move.w	d0,$40(a5)			; BLTCON0 (A+D)
	move.w	#$0000,$42(a5)		; BLTCON1 (ohne Spezialmodi)
	move.l	#$00000004,$64(a5)	; BLTAMOD=0
								; BLTDMOD=40-36=4 wie immer

	move.l	#figura,$50(a5)		; BLTAPT  (an der Quellfigur fixiert)
	move.l	a0,$54(a5)			; BLTDPT  (Bildschirm)
	move.w	#(3*64*45)+18,$58(a5)	; BLTSIZE (Blitter starten!)

	rts

OGG_Y:		dc.w	0			; hier wird das Y des Objektes gespeichert
OGG_X:		dc.w	0			; hier wird das X des Objektes gespeichert
;MOUSE_Y:	dc.b	0			; hier wird das Y der Maus gespeichert
;MOUSE_X:	dc.b	0			; hier wird das X der Maus gespeichert

;****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$38				; DdfStart
	dc.w	$94,$d0				; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,0				; BplCon2
	dc.w	$108,80				; WERT MODULO 80
	dc.w	$10a,80				; BEIDE MODULO MIT GLEICHEN WERT.

	dc.w	$100,$3200			; bplcon0 - 3 bitplanes lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste bitplane
	dc.w	$e4,$0000,$e6,$0000
	dc.w	$e8,$0000,$ea,$0000

	dc.w	$0180,$000			; color0
	dc.w	$0182,$475			; color1
	dc.w	$0184,$fff			; color2
	dc.w	$0186,$ccc			; color3
	dc.w	$0188,$999			; color4
	dc.w	$018a,$232			; color5
	dc.w	$018c,$777			; color6
	dc.w	$018e,$444			; color7

	dc.w	$FFFF,$FFFE			; Ende copperlist

;****************************************************************************

; Dies sind die Daten, aus denen die Figur des Bobs besteht.
; Der Bob ist im interleaved Format, 288 Pixel breit (18 Wörter)
; 45 Zeilen hoch, 3 Bitebenen

Figura:
	incbin	"/Sources/copmon.rawblit"

;****************************************************************************

	section	gnippi,bss_C

BITPLANE:
		ds.b	40*256			; 3 bitplanes
		ds.b	40*256
		ds.b	40*256

	end

;****************************************************************************

Dieses Programm ist die Rawblitversion von Listing10e1.s.
Die Maßnahme berücksichtigt nur die vom Blitter benötigte Zeit und hebt 
nicht die Vorteile von rawblit hervor.