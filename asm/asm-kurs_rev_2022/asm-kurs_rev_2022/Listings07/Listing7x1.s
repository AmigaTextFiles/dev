
; Listing7x1.s	KOLLISIONEN ZWISCHEN SPRITE UND PLAYFIELD
;		In diesem Beispiel durchquert ein Sprite Quadrate mit
;		verschiedenen Farben. Wenn er eine bestimmte Farbe berührt,
;		schaltet sich ein Signal ein.
; WinUAE: Chipset/Collision Level/Sprites and Sprites vs Playfields

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen wie immer auf unser PIC

	MOVE.L	#PIC,d0
	LEA	BPLPOINTERS,A1
	MOVEQ	#3-1,D1
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP

;	Pointen auf den Sprite

	LEA	SpritePointers,a1		; Pointer in der Copperlist
	MOVE.L	#MEINSPRITE0,d0		; Adresse des Sprite in d0
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	add.l	#16,a1

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!

mouse:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	mouse

	bsr.s	BewegeSprite0		; Bewege den Sprite
	bsr.s	CheckColl			; Kontrolliere die Kollisionen und
								; greife eventuell ein

Warte:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; starten die alte COP

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

; Diese Routine bewegt den Sprite um 2 Pixel pro Durchgang nach links

BewegeSprite0:
	subq.b	#1,HSTART0
	rts

; Diese Routine kontrolliert, ob es eine Kollision gegeben hat.
; Wenn ja, dann schaltet sie einen "Signalgeber" ein.
; Dieser Signalgeber ist einfach ein Quadrat, das mit COLOR7 gefüllt ist.
; Durch modifizieren dieser Farbe in der Copperlist, kann man ihn
; "einschalten" (Rot) oder "ausschalten" (Grau).

CheckColl:
	move.w	$dff00e,d0		; liest CLXDAT ($dff00e)
							; das Lesen dieses Registers bewirkt auch
							; seine sofortige Löschung, es ist also besser,
							; man kopiert es sich in d0 und macht dort dann
							; die Tests
	move.w	d0,d7
	btst.l	#1,d0			; das Bit 1 signalisiert die Kollision zwischen
							; Sprite 0 und Playfield
	beq.s	no_coll			; wenn es keine gegeben hat, dann überspringe

ja_coll:
	move.w	#$f00,Kollisions_Sensor ; "anschalten" des Signals (COLOR07),
							; indem wir die Copperlist (Rot) verändern
	bra.s	exitColl		; Raus

no_coll:
	move.w	#$555,Kollisions_Sensor ; "ausschalten" des Signales (COLOR07),
							; indem wir die Copperlist (Grau) verändern
exitColl:
	rts



	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0


; Das ist das Register CLXCON (kontrolliert die Art der Registrierung)

; Die Bit von 0 bis 5 sind die Werte, die von den Planes eingenommen w. müssen
; Die Bit 6 bis 11 zeigen, welche Planes aktiv für Kollisionen sind
; Die Bit 12 bis 15 zeigen, welche ungeraden Sprites aktiviert werden sollen
; (für die Spriteregistrierung)

 				;5432109876543210
	dc.w	$98,%0000000111000011	; CLXCON

; Diese Werte weisen darauf hin, daß die Planes 1,2 und 3 für Kollisionen
; aktiviert wurden, wenn eine Sprite also auf ein Pixel mit folgenden
; Eigenschaften stößt:
;
;		Plane 1 = 1
;		Plane 2 = 1
;		Plane 3 = 0
 

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1

	dc.w	$104,$0024	; BplCon2 - alle Sprites über das Playfield

	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0011001000000000	; 3 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0
	dc.w	$e4,0,$e6,0
	dc.w	$e8,0,$ea,0

; Bitplane-Farben
	dc.w	$180,$000		; COLOR0	; schwarzer Hintergrund
	dc.w	$182,$620
	dc.w	$184,$fff
	dc.w	$186,$e00
	dc.w	$188,$808
	dc.w	$18a,$f4a
	dc.w	$18c,$aaa
	dc.w	$18e			; COLOR07 - Dieser Wert wird danach von der Routine
							; CheckColl als Signal verwendet, wenn eine Kollision
							; eingetreten ist.
Kollisions_Sensor:
	dc.w	0				; AN DIESEM PUNKT schreibt die Routine CheckColl in
							; der Copperlist die richtige Farbe

; Sprite-Farben
	dc.w	$1A2,$00f		; COLOR17, also COLOR1 des Sprite0
	dc.w	$1A4,$0c0		; COLOR18, also COLOR2 des Sprite0
	dc.w	$1A6,$0c0		; COLOR19, also COLOR3 des Sprite0

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier ist der Sprite: KLARERWEISE in CHIP RAM! ************

MEINSPRITE0:	; Länge 6 Zeilen
VSTART0:
	dc.b 200	; Vertikale Anfangsposition des Sprite (da $2c a $f2)
HSTART0:
	dc.b $d8	; Horizontale Anfangsposition des Sprite (da $40 a $d8)
VSTOP0:
	dc.b 206	; 200+6=206
VHBITS:
	dc.b $00
	dc.w	$0008,$0000
	dc.w	$1818,$0000
	dc.w	$2C28,$1010
	dc.w	$7FF8,$0000
	dc.w	$3FC0,$0000
	dc.w	$01F0,$0000
	dc.w	$0000,$0000

PIC:
	incbin	"/Sources/collpic.raw"

	end

In diesem Beispiel zeigen wir, wie man  Kollisionen  zwischen  Sprite  und
Playfield  erkennen  kann.  Wie  wir  schon  in der Lektion gesehen haben,
verwenden wir dazu die Register CLXDAT und CLXCON. CLXDAT dient nur  dazu,
zu  wissen, obe eine Kollision stattgefunden hat (genau gleich wie bei
zwei Sprites, nur werden andere Bits verwendet). Die Verwendung von CLXCON
hingegen  ist  etwas  komplexer.  Sehen  wir  es uns gut an, indem wir das
Listing studieren. Wir haben in der Copperlist folgendes geschrieben:

				;5432109876543210
	dc.w	$98,%0000000111000011  ; CLXCON

Die Bit von 6  bis  11  dienen  zur  Bestimmung,  welche  Planes  für  die
Kollisionen  aktiviert  werden sollen. In unserem Beispiel sind die Planes
1,2 und 3 aktiviert (die Planes, die angezeigt werden). Die Bit von 0  bis
5  hingegen  dienen  dazu,  zu  bestimmen,  welchen  Wert  von  den Planes
angenommen werden muß,  damit  eine  Kollision  stattfindet.  Bei  unserem
Beispiel  tritt  eine  Kollision  auf,  wenn die drei Planes die folgenden
Werte aufweisen: Plane3 = 0, Plane2 = 1 und Plane1 = 1, also  die  Sequenz
%011=3.  Es  wird  also  eine  Kollision  zwischen  dem  Sprite und COLOR3
erkannt. Bemerkt, daß es uninteressant ist, welchen Wert  die  Planes  4,5
und 6 annehmen, da sie deaktiviert sind.

Verändert die Copperlist so:

				;5432109876543210
	dc.w	$98,%0000000111000010  ; CLXCON

Nun sind die aktivierten Planes immer noch 1,2 und 3, aber der  Wert,  der
angenommen  werden  muß  ist  %010,  also COLOR2. Ihr könnt es überprüfen,
indem ihr das Programm nochmal startet. Es funktioniert  mit  den  anderen
Farben genau gleich.

Und  wenn wir eine Kollision mit mehr als einer Farbe erkennen möchten? In
einigen Fällen ist es möglich, indem man  nicht  alle  angezeigten  Planes
aktiviert. Verändert die Copperlist auf diese Art:

				;5432109876543210
	dc.w	$98,%0000000110000010  ; CLXCON

Nun haben wir zum  registrieren von Kollisionen nur die  Planes  2  und  3
freigegeben.  Das bedeutet, daß Plane 1 keinen Einfluß auf die Kollisionen
mehr hat. Es ist nur notwendig, daß : Plane3 = 0 und Plane2 = 1. Da dieser
Zustand  sowohl  bei  der  Situation  %010  wie auch bei %011 gegeben ist,
werden beide Farben eine Kollision verursachen. Nun werden  COLOR2  (%010)
und COLOR3 (%011) eine auslösen.

Sehen wir ein anderes Beispiel. Modifiziert die Copperlist:

				;5432109876543210
	dc.w	$98,%0000000001000001  ; CLXCON

Nun ist nur Plane 1 aktiviert, und die Kollision kann erkannt werden, wenn
Plane1 = 1 ist. Das passiert bei allen ungeraden Farben. Man hat:

  %001  COLOR 1
  %011  COLOR 3
  %101  COLOR 5
  %111  COLOR 7

In all diesen Kombinationen ist Plane1 auf 1.

Das ist natürlich auch alles gültig, wenn die Planeanzahl verschieden  von
3 ist...

