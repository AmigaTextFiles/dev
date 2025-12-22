
; Listing11i4.s - originaler Schatten- / ELEKTRONEN-Effekt modifiziert.

; DRÜCKEN SIE DIE RECHTE TASTE, UM VON SCHATTEN ZU SCHATTEN ZU ÄNDERN...

	SECTION	Barrex,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; nur copper DMA

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

range		equ	20
NumeroLinee	equ	257

START:

	bsr.w	initcopbuf			; copperlist vorbereiten

	lea	$dff000,a6
	MOVE.W	#DMASET,$96(a6)		; DMACON - aktivieren copper
	move.l	#COP,$80(a6)		; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2			; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	BNE.S	Waity1
Aspetta:
	MOVE.L	4(A6),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $12c
	BEQ.S	Aspetta

	bsr.w	copmove				; Haupteffekt - Schatten der Farben
	bsr.w	cycle				; scrollt die Farben

	btst.b	#2,$dff016			; rechte Maustaste gedrückt?
	bne.s	NonCambiarMaschera
	move.w	6(a6),MascheraColori	; VHPOSR - setze einen Wert nach dem Zufallsprinzip
	move.b	7(a6),d0				; HPOSR
	and.w	#%011001110011,MascheraColori

NonCambiarMaschera:
	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse

	rts


*****************************************************************
; Diese Routine bewirkt, dass die Farben von der Mitte zu den Rändern "scrollen"
*****************************************************************

;	       ####
;	       :00:
;	       |--|
;	    ___¯||¯___
;	  _/  _¯\/¯_  \_
;	  \___|    |___/
;	 __/ _|    |  \_/_
;	  /\ |______\   \
;	     "|     \
;	      |  V  |
;	      |  |  |
;	      |  |  |
;	     :/__|__|
;	      __| |__
;	*******************

Chiarostep:
	dc.w	10

cycle:
	lea	copbuf+6+8,a0			; erste Farbe oben
	lea	copbuf+6-8+[256*8],a1	; letzte Farbe unten

	moveq 	#128-1,d0			; Anzahl der Zyklen
cycleloop:
	subq.w	#01,count			; jeder "step" hellt die Farbe auf.
	bne.s	gocycle
	add.w	#$101,(a0)			; die Farbe 1 alle 10 aufhellen
	move.w	ChiaroStep(PC),count
gocycle:
	move.w 	(a0),-8(a0)			; Scrolle nach oben
	move.w 	(a0),8(a1)			; Scrolle nach unten
	addq.w	#8,a0
	subq.w	#8,a1
	dbra	d0,cycleloop
	rts

count:
	dc.w	10

***************************************************************
; Diese Routine verwischt die Farben
***************************************************************

copmove:
	lea	copbuf+6+[128*8],a1		; halber Bildschirm
smooth:
	move.w 	ColoreOld(pc),d0
	move.w 	ColoreNewCaso(pc),d1
	cmp.w	d0,d1				; alte Farbe wie neu?
	beq.s	newcol				; dann nimm eine neue Farbe "zufällig"

	subq.w	#01,counter			; counter = 0?
	beq.s	gosmooth			; wenn es "verblasst" ...
	bra.s	draw				; sonst einfach zeichnen

; "Nuance" der Farben - Add und Sub einfach die Komponenten

gosmooth:
	move.w	#range,counter 

	move.w 	d0,d2
	move.w 	d1,d3
	and.w	#$000f,d2			; nur Komponente blau
	and.w	#$000f,d3
	cmp.w	d2,d3
	beq.s	blueready
	bgt.s	addblue
subblue:
	sub.w	#$0001,d0			; - blau
	bra.s	blueready
addblue:
	add.w	#$0001,d0			; + blau
blueready:	
	move.w 	d0,d2
	move.w 	d1,d3
	and.w	#$00f0,d2			; nur Komponente grün
	and.w	#$00f0,d3
	cmp.w	d2,d3
	beq.s	greenready
	bgt.s	addgreen
subgreen:
	sub.w	#$0010,d0			; - grün
	bra.s	greenready
addgreen:
	add.w	#$0010,d0			; + grün
greenready:	
	move.w 	d0,d2
	move.w 	d1,d3
	and.w	#$0f00,d2			; nur Komponente rot
	and.w	#$0f00,d3
	cmp.w	d2,d3
	beq.s	redready
	bgt.s	addred
subred:
	sub.w	#$0100,d0			; - rot
	bra.s	redready
addred:
	add.w	#$0100,d0			; + rot
redready:
	move.w 	d0,ColoreOld
draw:
	move.w 	d0,(a1)
	rts

;-----------------------------------------------------------------------------
; Es nimmt eine zufällige Farbe an, indem es mit der horizontalen Position des
; Elektronenstrahls spielt. Es ist keine große Routine, aber es funktioniert 
; für "pseudo-zufällige" Werte.
;----------------------------------------------------------------------------

newcol:
	move.w 	ColoreNewCaso(pc),ColoreOld		

	move.b 	$05(a6),d1			; $dff006 - Farbe RANDOM...
	muls.w	#$71,d1
	eor.w	#$ed,d1
	muls.w	$06(a6),d1			; $dff006 - Farbe RANDOM
	and.w	MascheraColori(PC),d1	; Wählen Sie nur die Farbbits aus
	move.w 	d1,ColoreNewCaso

	cmp.w 	ColoreOld(pc),d1
	bne.w	smooth
	add.b	#$08,ColoreNewCaso
	bra.w	smooth


MascheraColori:
		dc.w	$012

ColoreOld:		dc.w	0
ColoreNewCaso:	dc.w	0
counter:	dc.w	range

************************************************************* initcopbuf
;	copperlist erstellen
************************************************************* initcopbuf

initcopbuf:
	lea	copbuf,a0
	move.l 	#$29e1fffe,d0		; erste wait Zeile

	move.w 	#NumeroLinee-1,d1
coploop:
	move.l 	d0,(a0)+			; das wait ablegen
	move.l 	#$01800000,(a0)+	; color0
	add.l	#$01000000,d0		; Lass eine Zeile unten warten
	dbra	d1,coploop
	rts

*************************************************************** coplist
;				COPPERLIST
*************************************************************** coplist

	section	gfx,data_C

cop:
		dc.w	$100,$200		; bplcon0 - keine bitplanes
copbuf:
		ds.b	NumeroLinee*8	; Platz für den Coppereffekt 

		dc.w	$ffff,$fffe		; Ende copperlist
	end

