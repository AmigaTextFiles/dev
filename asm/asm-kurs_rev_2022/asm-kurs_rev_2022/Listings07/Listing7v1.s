
; Listing7v1.s	PRIORITÄT SPRITE-PLAYFIELD
;		In diesem Listing werden die Prioritäten zwischen den Sprite
;		und den Playfield vorgeführt. Die Sprites durchqueren
;		vier Zeilen auf dem Bildschirm. Bei jedem Durchgang werden
;		die Prioritäten mittels Copperlist verändert.

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf die übliche Art unser Pic an

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

;	Pointen auf die Sprites

	MOVE.L	#MEINSPRITE0,d0		; Adresse des Sprite in d0
	LEA	SpritePointers,a1		; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE1,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE2,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE3,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE4,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE5,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE6,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSPRITE7,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SPRITEPOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!


mouse:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	mouse

	bsr.s	BewegeSprites		; Bewege die Sprites nach unten

Warte1:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte1


	btst	#6,$bfe001			; linke Maustaste gedrückt?
	bne.s	mouse


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

; Diese Routine bewegt die 8 Sprites nach unten:
; Die Sprites werden einmal schon und einmal nicht bewegt. Deswegen wird
; die Variable Flag verwendet. Jedesmal, wenn die Routine ausgeführt wird,
; verändert die Variable ihren Zustand, das geschieht mit einem NOT:
; wenn sie auf 0 war, dann wird sie $ffff
; wenn sie auf $ffff war, dann wird sie 0
; wenn die Variabel von 0 auf $ffff übergeht, dann werden die Sprites
; nicht bewegt.
; Alle Sprites haben die selbe Höhe.

BewegeSprites:

	not.w	flag
	bne.w	Raus

; bewegt den Sprite 0

	addq.w	#1,Hoehe
	cmp.w	#300,Hoehe
	blo.s	Nicht_Rand		; am unteren Rand angekommen?
	move.w	#$2c,Hoehe		; wenn ja, setz ihn wieder ganz rauf

Nicht_Rand:
	move.w	Hoehe(PC),d0

	CLR.B	VHBITS0			; Lösche die Bits 8 der horizontalen Position
	MOVE.b	d0,VSTART0		; Kopiere die Bit von 0 bis 7 in VSTART
	BTST.l	#8,D0			; ist die Position größer als 255?
	BEQ.S	NOBIGVSTART		; wenn nicht, dann geh weitde, denn das Bit wurde
							; bereits mit CLR.b VHBITS gelöscht

	BSET.b	#2,VHBITS0		; ansonsten setze Bit 8 der vertikalen Startpos.
							; auf 1
NOBIGVSTART:
	ADDQ.W	#8,D0			; Zähle die Länge des Sprite dazu, um die
							; Endposition zu ermitteln (VSTOP)
	move.b	d0,VSTOP0		; Gib die Bit von 0 bis 7 in VSTOP
	BTST.l	#8,D0			; ist die Position größer als 255 ?
	BEQ.S	NOBIGVSTOP		; wenn nicht, dann geh weiter, denn das Bit
							; wurde bereits mit CLR.b VHBITS gelöscht

	BSET.b	#1,VHBITS0		; ansonsten setze Bit 8 der vertikalen Startp.
							; auf 1
NOBIGVSTOP:

; kopiere die Höhe in die anderen Sprites

	move.b	vstart0,vstart1 ; kopiert VSTART
	move.w	vstop0,vstop1	; kopiert VSTOP und VHBITS

	move.b	vstart0,vstart2 ; kopiert VSTART
	move.w	vstop0,vstop2	; kopiert VSTOP und VHBITS

	move.b	vstart0,vstart3 ; kopiert VSTART
	move.w	vstop0,vstop3	; kopiert VSTOP und VHBITS

	move.b	vstart0,vstart4 ; kopiert VSTART
	move.w	vstop0,vstop4	; kopiert VSTOP und VHBITS

	move.b	vstart0,vstart5 ; kopiert VSTART
	move.w	vstop0,vstop5	; kopiert VSTOP und VHBITS

	move.b	vstart0,vstart6 ; kopiert VSTART
	move.w	vstop0,vstop6	; kopiert VSTOP und VHBITS

	move.b	vstart0,vstart7 ; kopiert VSTART
	move.w	vstop0,vstop7	; kopiert VSTOP und VHBITS

Raus:
	rts

Hoehe:
	dc.w	$2c
flag:
	dc.w	0


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
	dc.w	$100,%0011001000000000	; Bit 12 an!! 3 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane
	dc.w	$e4,0,$e6,0
	dc.w	$e8,0,$ea,0

	dc.w	$180,$000		; COLOR0 - schwarzer Hintergrund
	dc.w	$182,$ff0
	dc.w	$184,$800
	dc.w	$186,$0f0
	dc.w	$188,$ff0
	dc.w	$18a,$f00
	dc.w	$18c,$0f0
	dc.w	$18e,$0f0


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

; Ab hier beginnen die Befehle, die die Priorität ändern.
; Ihr könnt sehen, daß die Prioritäten für die geraden wie auch für die
; ungeraden Bitplanes gleich sind, da wir hier mit einem einzigen Playfield
; arbeiten, und nicht einem Dual-Playfield: z.B. ist Wert $0009 der
; erste, der in das Register BPLCON2 geschrieben wird:
;
;		 5432109876543210
; $0009=%0000000000001001	ihr bemerkt daß:
;
; in die Bits von 0 bis 2 kommt %001
; in die Bits von 3 bis 5 kommt %001, wie wir es vorausgesagt haben
;
; Ihr könnt es überprüfen, es ist das selbe für alle Werte, die in
; BPLCON2 geschrieben werden.


	dc.w	$104,$0000		; BPLCON2 - am Anfang alle Sprites darunter

	dc.w	$7007,$fffe		; WAIT - Warte das Ende des Streifens ab
	dc.w	$104,$0009		; BPLCON2 - Sprites 0,1 darüber,
							; Sprites 2,3,4,5,6,7 darunter

	dc.w	$a007,$fffe		; WAIT - Warte das Ende des Streifens ab
	dc.w	$104,$0012		; BPLCON2 - Sprites 0,1,2,3 darüber und
							; Sprites 4,5,6,7 darunter

	dc.w	$d007,$fffe		; WAIT - Warte das Ende des Streifens ab
	dc.w	$104,$001b		; BPLCON2 - Sprites 0,1,2,3,4,5 darüber und
							; Sprites 6,7 darunter

	dc.w	$ff07,$fffe		; WAIT - Warte das Ende des Streifens ab
	dc.w	$104,$0024		; BPLCON2 - alle Sprites darüber

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;			   543210
; ACH-	$0  = %000000 - alle Sprites darunter
; TUNG! $9  = %001001 - Sprites 0,1 darüber	2,3,4,5,6,7 darunter
;	$12 = %010010 - Sprites 0,1,2,3 darüber	4,5,6,7 darunter
;	$1b = %011011 - Sprites 0,1,2,3,4,5 darüber	6,7 darunter
;	$24 = %100100 - alle Sprites darüber



; ************ Hier die Sprite: KLARERWEISE in CHIP RAM! ************

 ; Referenztabelle zur Definition der Farben:


;  für die Sprite 0 und 1
; BINÄR 00=COLOR 0 (TRANSPARENT)
; BINÄR 10=COLOR 1 (ROT)
; BINÄR 01=COLOR 2 (GRÜN)
; BINÄR 11=COLOR 3 (GELB)

MEINSPRITE0:	; Länge: 8 Zeilen
VSTART0:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART0:
	dc.b $60	; Horizontale Pos. (von $40 bis $d8)
VSTOP0:
	dc.b $68	; $60+8=$68	; Ende Vertikal
VHBITS0:
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite


MEINSPRITE1:	; Länge: 8 Zeilen
VSTART1:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART1:
	dc.b $60+14	; Horizontale Pos. (von $40 bis $d8)
VSTOP1:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000010001111
 dc.w	%0011111111111100,%1100000110000011
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0011111111111100,%1100000010000011
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite

 ; für die Sprite 2 und 3
 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 ; BINÄR 10=COLOR 1 (WEIß)
 ; BINÄR 01=COLOR 2 (WASSER)
 ; BINÄR 11=COLOR 3 (ORANGE)

MEINSPRITE2:	; Länge: 8 Zeilen
VSTART2:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART2:
	dc.b $60+(14*2) ; Horizontale Pos. (von $40 bis $d8)
VSTOP2:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0011111111111100,%1100001000100011
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0111111111111110,%1000000111000001
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite

MEINSPRITE3:	; Länge: 8 Zeilen
VSTART3:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART3:
	dc.b $60+(14*3) ; Horizontale Pos. (von $40 bis $d8)
VSTOP3:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0111111111111110,%1000000111100001
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite

 ; für die Sprite 4 und 5
 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 ; BINÄR 10=COLOR 1 (BLAU)
 ; BINÄR 01=COLOR 2 (VIOLETT)
 ; BINÄR 11=COLOR 3 (GRAU)

MEINSPRITE4:	; Länge: 13 Zeilen
VSTART4:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART4:
	dc.b $60+(14*4) ; Horizontale Pos. (von $40 bis $d8)
VSTOP4:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001001001111
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite

MEINSPRITE5:	; Länge: 8 Zeilen
VSTART5:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART5:
	dc.b $60+(14*5) ; Horizontale Pos. (von $40 bis $d8)
VSTOP5:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite

 ; für die Sprite 6 und 7
 ; BINÄR 00=COLOR 0 (TRANSPARENT)
 ; BINÄR 10=COLOR 1 (HELLGRÜN)
 ; BINÄR 01=COLOR 2 (BRAUN)
 ; BINÄR 11=COLOR 3 (DUNKELROT)

MEINSPRITE6:	; Länge: 8 Zeilen
VSTART6:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART6:
	dc.b $60+(14*6) ; Horizontale Pos. (von $40 bis $d8)
VSTOP6:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000001001000001
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite

MEINSPRITE7:	; Länge: 8 Zeilen
VSTART7:
	dc.b $60	; Vertikale Pos. (von $2c bis $f2)
HSTART7:
	dc.b $60+(14*7) ; Horizontale Pos. (von $40 bis $d8)
VSTOP7:
	dc.b $68	; $60+8=$68	; Ende Vertikal
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0		; Ende des Sprite


	SECTION LEERESPLANE,BSS_C

PIC:
	incbin	"/Sources/prioritaet.raw"	; das Bild

	end

In diesem Listing  zeigen  wir,  wie  die  Prioritäten  im  Gegensatz  zum
Playfiled  geändert  werden kann. Als Erstes bemerken wir, daß die Sprites
immer über dem COLOR0 erscheinen.  Für  die  anderen  Farben  ist  in  der
Kontrolle  das Register BPLCON2 zuständig. Es ist möglich, die Prioritäten
für die geraden und die ungeraden Planes separat zu  setzen.  Das  ist  im
Dual-Playfield-Mode  sehr  wichtig.  Wenn  aber  mit "normalen" Playfields
gearbeitet wird, wie etwa in  diesem  Beispiel,  dann  werden  die  selben
Priöritäten  für  die  geraden  und  die ungeraden Playfields verteilt. Um
zu sehen, wie die Prioritäten verteilt sind, lest euch die Lektion durch.

Um die Priorität mehrmals im selben Screen zu  ändern  verwenden  wir  den
Copper,  der es uns erlaubt, sie zu ändern, wenn sich die Sprites zwischen
einem Streifen und dem anderen befinden. Hier die Werte  für  das  BPLCON2
($dff104):

;              543210
; ACH-  $0  = %000000 - alle Sprites darunter
; TUNG! $9  = %001001 - Sprites 0,1 darüber      2,3,4,5,6,7 darunter
;       $12 = %010010 - Sprites 0,1,2,3 darüber      4,5,6,7 darunter
;       $1b = %011011 - Sprites 0,1,2,3,4,5 darüber      6,7 darunter
;       $24 = %100100 - alle Sprites darüber

AdÜ: In der Grafik tauchen  folgende  Texte  auf,  die  ich  leider  nicht
übersetzen  konnte,  weil  sie  in  RAW vorliegen und ich recht wenig Zeit
hatte:

"Questa faccia appare sopra tutti gli Sprite"
           bedeutet soviel wie:
"Dieser Teil erscheint über allen Sprites"


"Questa appare sotto gli Sprite xx e yy e sopra gli Sprites zz"
           bedeutet soviel wir:
"Dieser erscheint unter den Sprites xx und yy und über den Sprites zz"


"Questa appare sotto tutti gli Sprites"
           bedeutet soviel wie:
"Diese erscheint unter allen Sprites"

Tut mit leid...
