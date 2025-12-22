 
; Listing7v2.s  -  Sprite im Dual-Playfield-Mode
; In diesem Listing zeigen wir die verschiedenen Prioritätslevel der
; Sprites gegenüber den zwei Playfields. Die Sprites bewegen sich von oben nach
; unten. Jedesmal, wenn sie unten angekommen sind, beginnen sie wieder
; von oben, nur mit einer anderen Priorität.
; Das Ende des Programmes muß abgewartet werden. (muss es nicht mehr...)

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf die übliche Art unsere Pic´s an

	MOVE.L	#PIC1,d0
	LEA	BPLPOINTERS1,A1
	MOVEQ	#3-1,D1
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP

	MOVE.L	#PIC2,d0
	LEA	BPLPOINTERS2,A1
	MOVEQ	#3-1,D1
POINTBP2:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP2

;	Pointen auf die Sprites

	MOVE.L	#MEINSprite0,d0		; Adresse des Sprite in d0
	LEA	SpritePointers,a1		; Pointer in der Copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite1,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite2,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite3,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite4,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite5,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite6,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MEINSprite7,d0		; Adresse des Sprite in d0
	addq.w	#8,a1				; nächsten SpritePOINTERS
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088			; START COP
	move.w	#0,$dff1fc			; NO AGA!
	move.w	#$c00,$dff106		; NO AGA!

	lea	PriList(PC),a0			; a0 pointet auf die Liste mit Prioritätsleveln
	
	move.w	#$0000,$dff104		; BPLCON2
								; mit diesem Wert sind alle Sprites unter
								; beiden Playfields

Warte1:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	bne.s	Warte1

	bsr.s	BewegeSprites		; Bewegt die Sprites nach unten

	btst	#6,$bfe001			; linke Maustaste gedrückt?
	beq.s	Raus

Warte2:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte2

	cmp.w	#250,Hoehe			; Haben die Sprites den unteren Rand erreicht?
	blo.s	Warte1				; nein, dann bewege sie weiter

	move.w	#$2c,Hoehe			; Ja. Setz sie wieder ganz nach oben
	cmp.l	#EndPriList,a0		; Haben wir die Prioritlevel alle durchgemacht?
	beq.s	Raus				; wenn ja, dann steig aus.
	move.w	(a0)+,$dff104		; Wenn nicht, gib den nächsten Wert in BPLCON2
	bra.s	Warte1

Raus:
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

; Diese Routine bewegt die 8 Sprites um einen Pixel pro Durchgang nach unten.
; Alle Sprites haben die selbe Höhe.


BewegeSprites:

; bewegt den Sprite 0

	addq.w	#1,Hoehe
	move.w	Hoehe(PC),d0

	CLR.B	VHBITS0			; Lösche die Bits 8 der horizontalen Position
	MOVE.b	d0,VSTART0		; Kopiere die Bit von 0 bis 7 in VSTART
	BTST.l	#8,D0			; ist die Position größer als 255?
	BEQ.S	NOBIGVSTART		; wenn nicht, dann geh weitde, denn das Bit wurde
							; bereits mit CLR.b VHBITS gelöscht

	BSET.b	#2,VHBITS0		; ansonsten setze Bit 8 der vertikalen Startposition
							; auf 1
NOBIGVSTART:
	ADDQ.W	#8,D0			; Zähle die Länge des Sprite dazu, um die
							; Endposition zu ermitteln (VSTOP)
	move.b	d0,VSTOP0		; Gib die Bit von 0 bis 7 in VSTOP
	BTST.l	#8,D0			; ist die Position größer als 255 ?
	BEQ.S	NOBIGVSTOP		; wenn nicht, dann geh weiter, denn das Bit wurde
							; bereits mit CLR.b VHBITS gelöscht

	BSET.b	#1,VHBITS0		; ansonsten setze Bit 8 der vertikalen Startposition
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

EndeBewegeSprites:
	rts

Hoehe:
	dc.w	$2c

; Das ist die Liste mit dne Prioritätswerten. Ihr könnt sie variieren, wie
; ihr wollt. Nach dem letzten Wert muß aber das Label EndPriList stehen.
; Diese Werte werden in BPLCON2 geschrieben. Bemerkt den Unterschied zu
; Listing7v1.s, hier wird ein Screen im Dual-Playfield verwendet, somit können
; wir für jedes Playfield eigene Prioritätslevel vergeben.
; Ich erinnere euch daran, daß zwischen den Sprites die Prioritäten fix
; verteilt sind, und zwar so: der Sprite 0 hat die höchste Priorität, der
; Sprite 7 die kleinste.

PriList:
	dc.w	$0008			; %001000 - mit disem Wert sind die Prioritäten:
							; Playfield 1 (über allem)
							; Sprite 0 und 1
							; Playfield 2
							; Sprite 2,3,4,5,6,7 (unter allem)

	dc.w	$0010			; %010000 - mit diesem Wert sind die Prioritäten:
							; Playfield 1 (über allem)
							; Sprite 0,1,2,3
							; Playfield 2
							; Sprite 4,5,6,7 (unter allem)

	dc.w	$0018			; %011000 - mit diesem Wert sind die Prioritäten:
							; Playfield 1 (über allem)
							; Sprite 0,1,2,3,4,5
							; Playfield 2
							; Sprite 6,7 (unter allem)
			
	dc.w	$0020			; %100000 - mit diesem Wert sind die Prioritäten:
							; Playfield 1 (über allem)
							; Sprite 0,1,2,3,4,5,6,7
							; Playfield 2
			
	dc.w	$0021			; %100001 - mit diesem Wert sind die Prioritäten:
							; Sprite 0 und 1 (über allem)
							; Playfield 1
							; Sprite 2,3,4,5,6,7
							; Playfield 2 (unter allem)
			
	dc.w	$0022			; %100010 - mit diesem Wert sind die Prioritäten:
							; Sprite 0,1,2,3 (über allem)
							; Playfield 1
							; Sprite 4,5,6,7
							; Playfield 2 (unter allem)
		
	dc.w	$0023			; %100011 - mit diesem Wert sind die Prioritäten:
							; Sprite 0,1,2,3,4,5 (über allem)
							; Playfield 1
							; Sprite 6,7
							; Playfield 2 (unter allem)

	dc.w	$0024			; %100100 - mit diesem Wert sind die Prioritäten:
							; Sprite 0,1,2,3,4,5,6,7 (über allem)
							; Playfield 1
							; Playfield 2 (unter allem)
EndPriList:


	SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; Sprite
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0


	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38	 		; DdfStart
	dc.w	$94,$d0	 		; DdfStop

;	wir haben das BPLCON2 aus der Copperlist entfernt, da wie es
;	"manuell" mit dem Prozessor manipulieren.

	dc.w	$102,0			; BplCon1
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0110011000000000	; Bit 10 an = Dual Playfield
									; verwende 6 Planes = 8 Farben pro
									; Playfield
BPLPOINTERS1:
	dc.w	$e0,0,$e2,0		; erste	Bitplane Playfield 1 (BPLPT1)
	dc.w	$e8,0,$ea,0		; zweite Bitplane Playfield 1 (BPLPT3)
	dc.w	$f0,0,$f2,0		; dritte Bitplane Playfield 1 (BPLPT5)


BPLPOINTERS2:
	dc.w	$e4,0,$e6,0		; erste	Bitplane Playfield 2 (BPLPT2)
	dc.w	$ec,0,$ee,0		; zweite Bitplane Playfield 2 (BPLPT4)
	dc.w	$f4,0,$f6,0		; dritte Bitplane Playfield 2 (BPLPT6)

	dc.w	$180,$110		; Palette Playfield 1
	dc.w	$182,$005		; Farben von 0 bis 7
	dc.w	$184,$a40
	dc.w	$186,$f80 
	dc.w	$188,$f00 
	dc.w	$18a,$0f0 
	dc.w	$18c,$00f
	dc.w	$18e,$080

							; Palette Playfield 2
	dc.w	$192,$367		; Farben von 9 bis 15
	dc.w	$194,$0cc		; COLOR8 ist durchsichtig, er wird nicht gesetzt
	dc.w	$196,$a0a 
	dc.w	$198,$242 
	dc.w	$19a,$282 
	dc.w	$19c,$861
	dc.w	$19e,$ff0


	dc.w	$1A2,$F00		; Palette der Sprites
	dc.w	$1A4,$0F0
	dc.w	$1A6,$FF0

	dc.w	$1AA,$FFF
	dc.w	$1AC,$0BD
	dc.w	$1AE,$D50

	dc.w	$1B2,$00F
	dc.w	$1B4,$F0F
	dc.w	$1B6,$BBB

	dc.w	$1BA,$8E0
	dc.w	$1BC,$a70
	dc.w	$1BE,$d00

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


;	Die zwei Playfields

PIC1:	incbin	"/Sources/dual1.raw"
PIC2:	incbin	"/Sources/dual2.raw"

 ; ************ Hier die Sprite: KLARERWEISE in CHIP RAM! ************

 ; Referenztabelle zur Definition der Farben:


;  für die Sprite 0 und 1
; BINÄR 00=COLOR 0 (TRANSPARENT)
; BINÄR 10=COLOR 1 (ROT)
; BINÄR 01=COLOR 2 (GRÜN)
; BINÄR 11=COLOR 3 (GELB)

MEINSprite0:	; Länge: 8 Zeilen
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


MEINSprite1:	; Länge: 8 Zeilen
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

;  für die Sprite 2 und 3
; BINÄR 00=COLOR 0 (TRANSPARENT)
; BINÄR 10=COLOR 1 (WEIß)
; BINÄR 01=COLOR 2 (WASSER)
; BINÄR 11=COLOR 3 (ORANGE)

MEINSprite2:	; Länge: 8 Zeilen
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

MEINSprite3:	; Länge: 8 Zeilen
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

;  für die Sprite 4 und 5
; BINÄR 00=COLOR 0 (TRANSPARENT)
; BINÄR 10=COLOR 1 (BLAU)
; BINÄR 01=COLOR 2 (VIOLETT)
; BINÄR 11=COLOR 3 (GRAU)

MEINSprite4:	; Länge: 8 Zeilen
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

MEINSprite5:	; Länge: 8 Zeilen
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

;  für die Sprite 6 und 7
; BINÄR 00=COLOR 0 (TRANSPARENT)
; BINÄR 10=COLOR 1 (HELLGRÜN)
; BINÄR 01=COLOR 2 (BRAUN)
; BINÄR 11=COLOR 3 (DUNKELROT)

MEINSprite6:	; Länge: 8 Zeilen
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

MEINSprite7:	; Länge: 8 Zeilen
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

		end

Dieses Beispiel zeigt, wie die Prioritäten  der  Sprites  gegenüber  einem
Bildschirm  in  Dual-Playfield-Mode funktioniert. Für jedes Playfield kann
ein anderer Prioritätslevel gesetzt werden. Für dieses Beispiel haben  wir
eine  Liste  mit Werten verwendet. Eine Liste ist praktisch eine Reihe von
Werten, wie eine TABELLE. Mit einem Adressregister  (in  diesem  Fall  a0)
pointen wir auf den ersten Wert, und zwar mit der Anweisung:


	lea PriList(PC),a0

Jedesmal  wenn  ein Wert gelesen wird, bewegen wir das Register a0 auf den
darauf folgenden Wert, mittels indirekter Adressierung mit Postinkrement:

	move.w	(a0)+,$dff104	; Geben den Wert in BPLCON2

Wenn wir den letzten Wert erreicht haben, wird a0  dazugebracht,  auf  die
Adresse  im  Speicher  zu pointen, die dem letzten Wert folgt. Das ist die
Adresse des Label EndPriList. Wenn a0 gleich EndPriList wird,  dann  haben
wir das Ende der Liste erreicht, und wir steigen vom Programm aus.

Ihr  könnt  die  Werte  in  der  Liste  austauschen,  und  so  ein bißchen
herumexperimentieren. Versucht z.B. $0011, ihr werdet die Sprite 0  und  1
über  allen  beiden Playfields sehen, die Sprites 2 und 3 über Playfield 2
und unter dem ersten, während der Rest der Sprites unter beiden Playfields
sein wird.

BEMERKUNG:  In  diesem  Beispiel  verändern  wir  die Priorität, indem wir
direkt ins Register $dff104 (BPLCON2) schreiben. Das ist möglich, weil wir
die  Zeile  für  dessen Definition aus der Copperlist entfernt haben, also
die Zeile:


	dc.w	$104,0			; BPLCON2

Wenn ihr versucht, sie wieder einzufügen, dann werdet ihr sehen,  daß  der
Effekt anulliert wird, da die Copperlist ja bei jedem Fotogramm ausgeführt
wird, und damit  BPLCON2  gelöscht  wird.  Es  ist  also  möglich,  einige
Register mit dem Copper zu verändern, und andere direkt mit dem Prozessor,
aber ich rate euch, wann immer es möglich ist, den Copper zu verwenden. Er
ist besser und leichter zu synchronisieren,die richtige Zeile auszuwählen,
um auf ein Register zugreifen zu können.

AdÜ: "BUCO" bedeutet soviel wie "Loch"...  (Hatte  keine  Zeit,  das  Bild
neu zu zeichnen).

