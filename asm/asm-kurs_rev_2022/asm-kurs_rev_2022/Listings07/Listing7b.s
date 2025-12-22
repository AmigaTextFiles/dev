
; Listing7b.s	ANZEIGEN EINES SPRITES - RECHTE MAUSTASTE UM IHN ZU BEWEGEN

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Libname
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf das "leere" PIC

	MOVE.L	#BITPLANE,d0	; wohin pointen
	LEA	BPLPOINTERS,A1		; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Pointen auf den Sprite

	MOVE.L	#MEINSPRITE,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106

mouse:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	mouse

	btst	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	Warte

	bsr.s	BewegeSprite	; Bewege Sprite 0 nach rechts

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse


	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)			; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; Diese Routine bewegt den Sprite nach rechts, indem es auf das Byte HSTART
; also seiner X-Position, zugreift. Zu Bemerken, daß es jeweils um 2 Pixel
; bewegt wird.

BewegeSprite:
	addq.b	#1,HSTART		; (wie addq.b #1,MEINSPRITE+1)
	ADDQ.B	#1,VSTART		; \ Bewegt den Sprite nach unten
	ADDQ.B	#1,VSTOP		; / (sowohl auf VSTART wie auch auf VSTOP!)
	rts


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38			; DdfStart
	dc.w	$94,$d0			; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erstes  Bitplane

	dc.w	$180,$000		; color0	; Hintergrund Schwarz
	dc.w	$182,$123		; color1	; Farbe 1 des Bitplane, die
							; in diesem Fall leer ist,
							; und deswegen nicht erscheint

	dc.w	$1A2,$F00		; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$0F0		; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$FF0		; Color19, oder COLOR3 des Sprite0 - GELB

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier ist der Sprite: NATÜRLICH muß er in CHIP RAM sein! ************

MEINSPRITE:		; Länge 13 Zeilen
VSTART:
	dc.b $30	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP:
	dc.b $3d	; $30+13=$3d	- Vertikale Endposition des Sprite
	dc.b $00
 dc.w	%0000000000000000,%0000110000110000 ; Binäres Format für ev. Änderungen
 dc.w	%0000000000000000,%0000011001100000
 dc.w	%0000000000000000,%0000001001000000
 dc.w	%0000000110000000,%0011000110001100 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 dc.w	%0000011111100000,%0110011111100110 ; BINÄR 10=COLOR 1 (ROT)
 dc.w	%0000011111100000,%1100100110010011 ; BINÄR 01=COLOR 2 (GRÜN)
 dc.w	%0000110110110000,%1111100110011111 ; BINÄR 11=COLOR 3 (GELB)
 dc.w	%0000011111100000,%0000011111100000
 dc.w	%0000011111100000,%0001111001111000
 dc.w	%0000001111000000,%0011101111011100
 dc.w	%0000000110000000,%0011000110001100
 dc.w	%0000000000000000,%1111000000001111
 dc.w	%0000000000000000,%1111000000001111
 dc.w	0,0		; 2 word auf NULL definieren das Ende des Sprite.


	SECTION LEERESPLANE,BSS_C	; Eine auf 0 gesetzte Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end


Es ist einfach, den Sprite zu bewegen, versucht es mal mit dieser Modifizierung
der Routine BewegeSprite:


	subq.b	#1,HSTART		; Linksbewegung des Sprite

*

	ADDQ.B	#1,VSTART		; \ bewegt den Sprite nach unten
	ADDQ.B	#1,VSTOP		; / (sowohl auf VSTART wie auch auf VSTOP!)

*
	SUBQ.B	#1,VSTART		; \ bewegt den Sprite nach oben
	SUBQ.B	#1,VSTOP		; / (sowohl auf VSTART wie auch auf VSTOP!)
		
*

	ADDQ.B	#1,HSTART		;\
	ADDQ.B	#1,VSTART		; \ bewegt den Sprite diagonal nach unten-rechts
	ADDQ.B	#1,VSTOP		; /

*

	SUBQ.B	#1,HSTART		;\
	ADDQ.B	#1,VSTART		; \ bewegt den Sprite diagonal nach unten-links
	ADDQ.B	#1,VSTOP		; /

*

	ADDQ.B	#1,HSTART		;\
	SUBQ.B	#1,VSTART		; \ bewegt den Sprite diagonal nach oben-rechts
	SUBQ.B	#1,VSTOP		; /

*

	SUBQ.B	#1,HSTART		;\
	SUBQ.B	#1,VSTART		; \ bewegt den Sprite diagonal nach oben-links
	SUBQ.B  #1,VSTOP		; /

*

Probiert dann, den Wert, der dazu/weggezählt wird, zu verändern, und schafft
neue, interessante "Schußlinien":

	SUBQ.B	#3,HSTART		;\
	SUBQ.B	#1,VSTART		; \ bewegt den Sprite diagonal oben-seht links
	SUBQ.B	#1,VSTOP		; /

Und so weiter, und so weiter....
