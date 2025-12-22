
; Listing7s.s	ANZEIGEN VON WIEDERVERWENDETEN SPRITES

;	In diesem Listing wird die Wiederverwendung der Sprite gezeigt.
;	Mit der linken Maustaste ändern wir die Sprites Position.
;	Rechte Taste zum Aussteigen.

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop


	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Pointen auf die Sprite

	MOVE.L	#MEINSPRITE0,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE1,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE2,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE3,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE4,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE5,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE6,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE7,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

; Spritepositionen

	MOVE.B	#$2C+50,VSTART0
	MOVE.B	#$2C+50+8,VSTOP0
	MOVE.B	#$2C+50,VSTART1
	MOVE.B	#$2C+50+8,VSTOP1
	MOVE.B	#$2C+50,VSTART2
	MOVE.B	#$2C+50+8,VSTOP2
	MOVE.B	#$2C+50,VSTART3
	MOVE.B	#$2C+50+8,VSTOP3
	MOVE.B	#$2C+50,VSTART4
	MOVE.B	#$2C+50+8,VSTOP4
	MOVE.B	#$2C+50,VSTART5
	MOVE.B	#$2C+50+8,VSTOP5
	MOVE.B	#$2C+50,VSTART6
	MOVE.B	#$2C+50+8,VSTOP6
	MOVE.B	#$2C+50,VSTART7
	MOVE.B	#$2C+50+8,VSTOP7

; hier beginnen die "wiederverwendeten" Sprites

	MOVE.B	#$2C+90,VSTART8
	MOVE.B	#$2C+90+8,VSTOP8
	MOVE.B	#$2C+90,VSTART9
	MOVE.B	#$2C+90+8,VSTOP9
	MOVE.B	#$2C+90,VSTART10
	MOVE.B	#$2C+90+8,VSTOP10
	MOVE.B	#$2C+90,VSTART11
	MOVE.B	#$2C+90+8,VSTOP11
	MOVE.B	#$2C+90,VSTART12
	MOVE.B	#$2C+90+8,VSTOP12
	MOVE.B	#$2C+90,VSTART13
	MOVE.B	#$2C+90+8,VSTOP13
	MOVE.B	#$2C+90,VSTART14
	MOVE.B	#$2C+90+8,VSTOP14
	MOVE.B	#$2C+90,VSTART15
	MOVE.B	#$2C+90+8,VSTOP15

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!

Mouse1:
	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse1

; gibt neue vertikale Positionen ein

	MOVE.B	#$2C+10,VSTART0
	MOVE.B	#$2C+10+8,VSTOP0
	MOVE.B	#$2C+10+8*1,VSTART1
	MOVE.B	#$2C+10+8*1+8,VSTOP1
	MOVE.B	#$2C+10+8*2,VSTART2
	MOVE.B	#$2C+10+8*2+8,VSTOP2
	MOVE.B	#$2C+10+8*3,VSTART3
	MOVE.B	#$2C+10+8*3+8,VSTOP3
	MOVE.B	#$2C+10+8*4,VSTART4
	MOVE.B	#$2C+10+8*4+8,VSTOP4
	MOVE.B	#$2C+10+8*5,VSTART5
	MOVE.B	#$2C+10+8*5+8,VSTOP5
	MOVE.B	#$2C+10+8*6,VSTART6
	MOVE.B	#$2C+10+8*6+8,VSTOP6
	MOVE.B	#$2C+10+8*7,VSTART7
	MOVE.B	#$2C+10+8*7+8,VSTOP7

; hier beginnen die "wiederverwendeten" Sprites

	MOVE.B	#$2C+10+20,VSTART8
	MOVE.B	#$2C+10+20+8,VSTOP8
	MOVE.B	#$2C+10+20+8*1,VSTART9
	MOVE.B	#$2C+10+20+8*1+8,VSTOP9
	MOVE.B	#$2C+10+20+8*2,VSTART10
	MOVE.B	#$2C+10+20+8*2+8,VSTOP10
	MOVE.B	#$2C+10+20+8*3,VSTART11
	MOVE.B	#$2C+10+20+8*3+8,VSTOP11
	MOVE.B	#$2C+10+20+8*4,VSTART12
	MOVE.B	#$2C+10+20+8*4+8,VSTOP12
	MOVE.B	#$2C+10+20+8*5,VSTART13
	MOVE.B	#$2C+10+20+8*5+8,VSTOP13
	MOVE.B	#$2C+10+20+8*6,VSTART14
	MOVE.B	#$2C+10+20+8*6+8,VSTOP14
	MOVE.B	#$2C+10+20+8*7,VSTART15
	MOVE.B	#$2C+10+20+8*7+8,VSTOP15

Mouse2:
	btst	#2,$dff016
	bne.s	Mouse2


	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte COP

	move.l	4.w,a6
	jsr	-$7e(a6)				; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)				; Closelibrary
	rts

;	Daten

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

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
	dc.w	$100,%0001001000000000

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	Bitplane

	dc.w	$180,$000		; color0	; schwarzer Hintergrund
	dc.w	$182,$123		; color1	; Color 1 des Bitplane, das
							; in diesem Fall leer ist,
	dc.w	$1A2,$F00		; Color17, - Color1 der Sprite0/1 -ROT
	dc.w	$1A4,$0F0		; Color18, - Color2 der Sprite0/1 -GRÜN
	dc.w	$1A6,$FF0		; Color19, - Color3 der Sprite0/1 -GELB

	dc.w	$1AA,$FFF		; Color21, - Color1 der Sprite2/3 -WEIß
	dc.w	$1AC,$0BD		; Color22, - Color2 der Sprite2/3 -WASSER
	dc.w	$1AE,$D50		; Color23, - Color3 der Sprite2/3 -ORANGE

	dc.w	$1B2,$00F		; Color25, - Color1 der Sprite4/5 -BLAU
	dc.w	$1B4,$F0F		; Color26, - Color2 der Sprite4/5 -VIOLETT
	dc.w	$1B6,$BBB		; Color27, - Color3 der Sprite4/5 -GRAU

	dc.w	$1BA,$8E0		; Color29, - Color1 der Sprite6/7 -HELLGRÜN
	dc.w	$1BC,$a70		; Color30, - Color2 der Sprite6/7 -BRAUN
	dc.w	$1BE,$d00		; Color31, - Color3 der Sprite6/7 -DUNKELROT

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier die Sprite: KLARERWEISE in CHIP RAM! ************

 ; Referenztabelle zur Definition der Farben:


 ; für Sprites 0 und 1
 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 ; BINÄR 10=COLOR 1 (ROT)
 ; BINÄR 01=COLOR 2 (GRÜN)
 ; BINÄR 11=COLOR 3 (GELB)

MEINSPRITE0:		; Länge 8 Zeilen
VSTART0:
	dc.b 0
HSTART0:
	dc.b $40+12+0*20
VSTOP0:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
VSTART8:
	dc.b $0
HSTART8:
	dc.b $40+20+0*12
VSTOP8:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000001110000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite


MEINSPRITE1:		; Länge 8 Zeilen
VSTART1:
	dc.b $0
HSTART1:
	dc.b $40+12+1*20
VSTOP1:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000010001111
 dc.w	%0011111111111100,%1100000110000011
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0011111111111100,%1100000010000011
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0000001111000000,%0111110000111110
VSTART9:
	dc.b $0
HSTART9:
	dc.b $40+20+1*12
VSTOP9:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000001110000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

 ; für Sprites 2 und 3
 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 ; BINÄR 10=COLOR 1 (WEISS)
 ; BINÄR 01=COLOR 2 (WASSER)
 ; BINÄR 11=COLOR 3 (ORANGE)

MEINSPRITE2:		; Länge 8 Zeilen
VSTART2:
	dc.b $0
HSTART2:
	dc.b $40+12+2*20
VSTOP2:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0011111111111100,%1100001000100011
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0111111111111110,%1000000111000001
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
VSTART10:
	dc.b $0
HSTART10:
	dc.b $40+20+2*12
VSTOP10:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0011111111111100,%1100010011100011
 dc.w	%0111111111111110,%1000110010100001
 dc.w	%0111111111111110,%1000010010100001
 dc.w	%0011111111111100,%1100111011100011
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende sprite

MEINSPRITE3:		; Länge 8 Zeilen
VSTART3:
	dc.b $0
HSTART3:
	dc.b $40+12+3*20
VSTOP3:
	dc.b 0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0111111111111110,%1000000111100001
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
VSTART11:
	dc.b $0
HSTART11:
	dc.b $40+20+3*12
VSTOP11:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000110011000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100111011100011
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende sprite

 ; für Sprites 4 und 5
 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 ; BINÄR 10=COLOR 1 (BLAU)
 ; BINÄR 01=COLOR 2 (VIOLETT)
 ; BINÄR 11=COLOR 3 (GRAU)

MEINSPRITE4:		; Länge 8 Zeilen
VSTART4:
	dc.b $0
HSTART4:
	dc.b $40+12+4*20
VSTOP4:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001001001111
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
VSTART12:
	dc.b $0
HSTART12:
	dc.b $40+20+4*12
VSTOP12:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0011111111111100,%1100010011000011
 dc.w	%0111111111111110,%1000110001000001
 dc.w	%0111111111111110,%1000010010000001
 dc.w	%0011111111111100,%1100111011100011
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende sprite

MEINSPRITE5:		; Länge 8 Zeilen
VSTART5:
	dc.b $0
HSTART5:
	dc.b $40+12+5*20
VSTOP5:
	dc.b $0
	dc.b $0
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
VSTART13:
	dc.b $0
HSTART13:
	dc.b $40+20+5*12
VSTOP13:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0011111111111100,%1100010011100011
 dc.w	%0111111111111110,%1000110001100001
 dc.w	%0111111111111110,%1000010000100001
 dc.w	%0011111111111100,%1100111011000011
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende sprite

 ; für Sprites 6 und 7
 ; BINÄR 00=COLOR 0 (DURCHSICHTIG)
 ; BINÄR 10=COLOR 1 (HELLGRÜN)
 ; BINÄR 01=COLOR 2 (BRAUN)
 ; BINÄR 11=COLOR 3 (DUNKELROT)

MEINSPRITE6:		; Länge 8 Zeilen
VSTART6:
	dc.b $0
HSTART6:
	dc.b $40+12+6*20
VSTOP6:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000001001000001
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
VSTART14:
	dc.b $0
HSTART14:
	dc.b $40+20+6*12
VSTOP14:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0011111111111100,%1100010000100011
 dc.w	%0111111111111110,%1000110010100001
 dc.w	%0111111111111110,%1000010011100001
 dc.w	%0011111111111100,%1100111001000011
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

MEINSPRITE7:		; Länge 8 Zeilen
VSTART7:
	dc.b 0
HSTART7:
	dc.b $40+12+7*20
VSTOP7:
	dc.b $0
	dc.b $0
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
VSTART15:
	dc.b $0
HSTART15:
	dc.b $40+20+7*12
VSTOP15:
	dc.b $0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0011111111111100,%1100010011100011
 dc.w	%0111111111111110,%1000110011000001
 dc.w	%0111111111111110,%1000010000100001
 dc.w	%0011111111111100,%1100111011100011
 dc.w	%0000111111110000,%1111000000001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende Sprite

		SECTION LEERESPLANE,BSS_C	; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end


In  diesem  Listing  wird  gezeigt,  wie  man die Sprites mehrmals auf dem
gleichen Screen wiederverwenden kann. Im Beispiel wird jeder  Sprite  zwei
Mal wiederverwendet.

Der Sprite 0 wird wiederverwendet um  Sprite 8 zu zeichnen.
Der Sprite 1 wird wiederverwendet um  Sprite 9 zu zeichnen.
Der Sprite 2 wird wiederverwendet um  Sprite 10 zu zeichnen.
Der Sprite 3 wird wiederverwendet um  Sprite 11 zu zeichnen.
Der Sprite 4 wird wiederverwendet um  Sprite 12 zu zeichnen.
Der Sprite 5 wird wiederverwendet um  Sprite 13 zu zeichnen.
Der Sprite 6 wird wiederverwendet um  Sprite 14 zu zeichnen.
Der Sprite 7 wird wiederverwendet um  Sprite 15 zu zeichnen.

Bemerkt ihr,  daß  bei  der  Wiederverwendung  eines  Sprites,  dieser  am
Bildschrim  TIEFER  dargestellt  wird,  als es die letzte Zeile bei seiner
ersten Anzeige war? Das ist einem bestimmten Hardwarelimit  zuzuschreiben.
Zwischen  einer  Verwendung  und  der  nächtsten muß MINDESTENS eine leere
Zeile dazwischenliegen.


Das Byte VSTART des Sprite 8 muß GRÖßER sein als VSTOP des Sprite 0
Das Byte VSTART des Sprite 9 muß GRÖßER sein als VSTOP des Sprite 1
Das Byte VSTART des Sprite 10 muß GRÖßER sein als VSTOP des Sprite 2
Das Byte VSTART des Sprite 11 muß GRÖßER sein als VSTOP des Sprite 3
Das Byte VSTART des Sprite 12 muß GRÖßER sein als VSTOP des Sprite 4
Das Byte VSTART des Sprite 13 muß GRÖßER sein als VSTOP des Sprite 5
Das Byte VSTART des Sprite 14 muß GRÖßER sein als VSTOP des Sprite 6
Das Byte VSTART des Sprite 15 muß GRÖßER sein als VSTOP des Sprite 7

Die  Wiederverwendung  eines Sprite ändert die Farbregister nicht, die ihm
zugeteilt sind.
Ihr bemerkt sicher, daß die Farben eines "wiederverwendeten"  Sprites  die
gleichen  sind  wie  die  des  "Orginals".  Da  die  Sprites  aber  auf
verschiedenen Höhen liegen hindert uns nichts daran, deren Farben mit  dem
Copper  zu  verändern, während wir uns z.B in der "leeren" Zeile befinden.
Ihr könnt es als Übung mal versuchen.

