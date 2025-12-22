
; Listing7f.s	ANZEIGEN ALLER 8 SPRITE DES AMIGA

;	In diesem Listing wird gezeigt, daß alle 8 Sprites ihre Palette
;	in Paaren gemeinsam haben, also Sprite 0 die gleiche wie Sprite1
;	hat, Sprite 2 die gleichen Farben wie Sprite 3 und so weiter.
;	Es wird auch gezeigt, wie die Prioritäten bei Überlagerungen
;	verteilt sind, also daß der mit der kleineren Nummer über dem
;	mit einer größeren Vorrang hat, also über diesem angezeigt wird.
;	Sprite 0 wird also über allen anderen angezeigt, Sprite 7 hingegen
;	kann von allen anderen überdeckt werden. Sprite 3 z.B. überdeckt
;	die Sprites 4,5,6,7, wird aber selbst von 0,1 und 2 überdeckt.
;	Durch Drücken der linken Maustaste Überlappen sich die Sprites
;	und die Prioritäten sind gut erkennbar. Rechte Maustaste zum
;	Aussteigen.

	SECTION CipundCop,CODE
	
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

;	Pointen auf die Sprite

	MOVE.L	#MEINSPRITE0,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE1,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE2,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE3,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE4,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE5,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE6,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE7,d0	; Adresse des Sprite in d0
	addq.w	#8,a1			; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	MOVEQ	#$60,d0			; Anfangskoordinate HSTART
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
						    ; (zu Bemerken, daß das Byte HSTART immer 2 Pixel
						    ; nimmt, wenn wir uns also um 10 Pixel verstellen
						    ; wollen müssen wir nur 5 zu HSTART dazuzählen!)
	MOVE.B	d0,HSTART1
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
	MOVE.B	d0,HSTART2
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
	MOVE.B	d0,HSTART3
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
	MOVE.B	d0,HSTART4
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
	MOVE.B	d0,HSTART5
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
	MOVE.B	d0,HSTART6
	ADDQ.B	#(10/2),d0		; Abstand zum nächsten Sprite
	MOVE.B	d0,HSTART7

MouseRechts:
	btst	#2,$dff016
	bne.s	MouseRechts

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; Starten die alte Cop

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
	dc.w	$100,%0001001000000000  ; bit 12 an!! 1 bitplane lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	bitplane

	dc.w	$180,$000		; Color0	; schwarzer Hintergrund
	dc.w	$182,$123		; Color1	; Color1 des Bitplane, das
							; hier leer ist, es erscheint
							; also nicht.

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


; für die Sprite 0 und 1
; BINÄR 00=COLOR 0 (TRANSPARENT)
; BINÄR 10=COLOR 1 (ROT)
; BINÄR 01=COLOR 2 (GRÜN)
; BINÄR 11=COLOR 3 (GELB)

MEINSPRITE0:				; Länge: 8 Zeilen
VSTART0:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART0:
	dc.b $60				; Horizontale Pos. (von $40 bis $d8)
VSTOP0:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite


MEINSPRITE1:				; Länge: 8 Zeilen
VSTART1:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART1:
	dc.b $60+14				; Horizontale Pos. (von $40 bis $d8)
VSTOP1:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000010001111
 dc.w	%0011111111111100,%1100000110000011
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0011111111111100,%1100000010000011
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite

 ; für die Sprite 2 und 3
 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 ; BINÄR 10=COLOR 1 (WEIß)
 ; BINÄR 01=COLOR 2 (WASSER)
 ; BINÄR 11=COLOR 3 (ORANGE)

MEINSPRITE2:				; Länge: 8 Zeilen
VSTART2:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART2:
	dc.b $60+(14*2)			; Horizontale Pos. (von $40 bis $d8)
VSTOP2:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0011111111111100,%1100001000100011
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0111111111111110,%1000000111000001
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite

MEINSPRITE3:				; Länge: 8 Zeilen
VSTART3:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART3:
	dc.b $60+(14*3)			; Horizontale Pos. (von $40 bis $d8)
VSTOP3:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0111111111111110,%1000000111100001
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0				; Ende des Sprite

 ; für die Sprite 4 und 5
 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 ; BINÄR 10=COLOR 1 (BLAU)
 ; BINÄR 01=COLOR 2 (VIOLETT)
 ; BINÄR 11=COLOR 3 (GRAU)

MEINSPRITE4:				; Länge: 8 Zeilen
VSTART4:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART4:
	dc.b $60+(14*4)			; Horizontale Pos. (von $40 bis $d8)
VSTOP4:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001001001111
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite

MEINSPRITE5:				; Länge: 8 Zeilen
VSTART5:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART5:
	dc.b $60+(14*5)			; Horizontale Pos. (von $40 bis $d8)
VSTOP5:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite

 ; für die Sprite 6 und 7
 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 ; BINÄR 10=COLOR 1 (HELLGRÜN)
 ; BINÄR 01=COLOR 2 (BRAUN)
 ; BINÄR 11=COLOR 3 (DUNKELROT)

MEINSPRITE6:				; Länge: 8 Zeilen
VSTART6:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART6:
	dc.b $60+(14*6)			; Horizontale Pos. (von $40 bis $d8)
VSTOP6:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000001001000001
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite

MEINSPRITE7:				; Länge: 8 Zeilen
VSTART7:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART7:
	dc.b $60+(14*7)			; Horizontale Pos. (von $40 bis $d8)
VSTOP7:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0					; Ende des Sprite

		SECTION LEERESPLANE,BSS_C
							; Ein auf 0 gesetztes Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end


In  diesem  Listing werden alle 8 Sprites "gepointet", jeder von ihnen hat
die Nummer gezeichnet. Wie schon  in  der  Theorie  erklärt  haben  die  8
Sprites 4 separate Paletten, deswegen teilen sich immer zwei nebenstehende
Sprites eine Palette:

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


Zu Bemerken ist, daß die Farben 16, 20, 24 und 28 nicht  von  den  Sprites
verwendet  werden,  sie  werden übersprungen, da sie dem Color0 des Sprite
entsprechen würden, also  dem  TRANSPARENT,  das  eben  keine  Farbe  ist,
sondern  eher  als  "LOCH"  aufgefasst werden kann. Er nimmt die Farbe des
darunterliegenden Bitplane (oder Sprite) an. Jeder Sprite hat sein VSTART,
VSTOP und HSTART, sehen wir z.B. Sprite2:


MEINSPRITE2:				; Länge: 8 Zeilen
VSTART2:
	dc.b $60				; Vertikale Pos. (von $2c bis $f2)
HSTART2:
	dc.b $60+(14*2)			; Horizontale Pos. (von $40 bis $d8)
VSTOP2:
	dc.b $68				; $60+8=$68	; Ende Vertikal
	dc.b $00


Jeder  Sprite  ist  von  den  anderen distanziert, indem wir zu HSTART ein
(14*x) dazugezählt haben. Nach dem linken  Mausdruck  werden  alle  HSTART
außer  dem ersten geändert, um sie alle zu überlagern. Das Veranschaulicht
dann die Priotitäten.

