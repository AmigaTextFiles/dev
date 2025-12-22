
; Listing7a.s		ANZEIGEN EINES SPRITE

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

;	Pointen auf den Sprite

	MOVE.L	#MEINSPRITE,d0	; Adresse des Sprite in d0
	LEA	SpritePointers,a1	; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	btst	#6,$bfe001		; Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die alte SystemCopperlist
	move.w	d0,$dff088		; Starten die alte SystemCopperlist

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
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

	dc.w	$180,$000		; color0	; Hintergrund Schwarz
	dc.w	$182,$123		; color1	; Farbe 1 der Bitplane, die
							; in diesem Fall leer ist,
							; und deswegen nicht erscheint

	dc.w	$1A2,$F00		; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$0F0		; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$FF0		; Color19, oder COLOR3 des Sprite0 - GELB

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier ist der Sprite: NATÜRLICH muß er in CHIP RAM sein! ************

MEINSPRITE:		; Länge 13 Zeilen
VSTART:
	dc.b $60	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART:
	dc.b $D0	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP:
	dc.b $6d	; $60+13=$6d - Vertikale Endposition des Sprite
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
 dc.w	0,0	; 2 word auf NULL definieren das Ende des Sprite.


	SECTION LEERESPLANE,BSS_C	; Eine auf 0 gesetzte Bitplane, wir
							; müssen es verwenden, denn ohne Bitplane
							; ist es nicht möglich, die Sprites
							; zu aktivieren
BITPLANE:
	ds.b	40*256			; Bitplane auf 0 Lowres

	end

Das ist der erste Sprite in diesem Kurs, den wir kontrollieren, ihr  könnt
ihn  leicht verändern indem ihr auf die 2 Plane zugreift, die ihn ergeben.
Sie  sind  in  Binärformat  angegeben.	Die  resultierende  Farbe  der
Überlagerungen  kann  leicht herausgefunden werden, wenn ihr den Kommentar
neben dem Sprite lest. Die Farben des Sprite0 sind  in  den  Farbregistern
17,18 und 19 definiert.

	dc.w	$1A2,$F00	; Color17, oder COLOR1 des Sprite0 - ROT
	dc.w	$1A4,$0F0	; Color18, oder COLOR2 des Sprite0 - GRÜN
	dc.w	$1A6,$FF0	; Color19, oder COLOR3 des Sprite0 - GELB

Um die Position des Sprites zu verändern, greift auf die ersten Byte zu:


MEINSPRITE:		; Länge 13 Zeilen
VSTART:
	dc.b $30	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART:
	dc.b $90	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP:
	dc.b $3d	; $30+13=$3d	; Vertikale Endposition des Sprite
	dc.b $00


Einfach folgendes bedenken:

1) Die linke, obere Ecke des Monitors ist nicht die Position $00,$00, denn
im Overscan kann der Bildschirm ja noch größer werden. In einem "normalen"
Screen ist die horizontale Anfangsposition (HSTART) zwischen $40 und  $d8,
ansonsten  wird der Sprite "abgeschnitten" oder er befindet sich überhaupt
außerhalb des  Screens.  Ebenfalls  die  vertikale  Anfangsposition,  also
VSTART,  beginnt  nicht  bei  $00,  sondern bei $2c, also am Anfang des in
DIWSTART definierten Videofensters (hier ist es $2c81). Um in einem Screen
zu 320x256 einen Sprite zu positionieren, z.B. auf Koordinate 160,128, muß
beachtet werden, daß die linke, obere Koordinate $40,$2c  ist,  und  nicht
0,0,  es  muß  also $40 zur X-Koordinate und $2c zur Y-Koordinate summiert
werden. In der Tat entspricht $40+160, $2c+128 den Koordinaten 160,128  in
einem  320x256  Screen  ohne  Overscan.  Da  wir horizontal noch nicht die
Kontrolle Pixel für Pixel haben, sondern noch  in  Schritten  zu  2  Pixel
vorschreiten,  müssen  wir  nicht  160  dazuzählen,  sondern 160/2, um den
Mittelpunkt zu treffen.


HSTART:
	dc.b $40+(160/2)		; Position in der Mitte des Monitors

So auch für alle anderen, horizontalen Koordinaten, z.B. Position 50:

	dc.b $40+(50/2)

Später werden wir sehen, wie wir den Sprite jeweils um 1 Pixel verstellen.

2)  Die  horizontale Position kann für sich alleine verstellt werden, wenn
man den Sprite verschieben möchte. Bei der vertikalen  Positionierung  ist
aber  aufzupassen!  Denn dort muß auf zwei Bytes agiert werden, dem VSTART
und dem VSTOP. Also auf die vertikale Position und die Länge des  Sprites.
Die  Breite  eines  Sprites  ist  immer  16, und somit ist die horizontale
Endposition immer 16 Pixel weiter  rechts  als  die  Anfangsposition.  Die
Länge  hingegen  kann  beliebig  sein,  und  so ist es notwendig, auch die
Endposition des Sprites zu definieren. Wenn wir also den  Sprite  um  eins
nach  Oben  verstellen  wollen, dann müssen wir sowohl bei VSTART wie auch
bei VSTOP 1 subtrahieren,  wenn  wir  ihn  hingegen  um  eins  nach  Unten
verschieben  wollen,  dann  müssen wir bei beiden Bytes 1 dazuzählen. Wenn
wir in VSTART  z.B.  $55  einsetzen  möchten,  dann  müssen  wir  und  die
Endposition  VSTOP  errechnen,  indem wir zu dieser Position die Länge des
Sprites (bei uns 13 Zeilen) dazuzählen, also $55+13=$62. Setzt den  Sprite
auf  die  verschiedensten  Positionen  am Bildschirm, um zu prüfen, ob ihr
alles verstanden habt. Erinnert euch,  daß  HSTART  jedesmal  um  2  Pixel
vorrückt, und nicht um 1, wie es sich leicht vermuten ließe.

