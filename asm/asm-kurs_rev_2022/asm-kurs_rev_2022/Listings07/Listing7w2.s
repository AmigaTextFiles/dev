
; Listing7w2.s	KOLLISIONEN ZWISCHEN UNGERADEN SPRITES
;
; In diesem Beispiel sehen wir, wie wir die Kollisionen zwischen ungeraden
; Sprites registrieren können. Diesmal sind zwei Raketen auf der Jagd nach
; dem Flugzeug, und einer der beiden ist ein ungerader Sprite.
; Wenn ihr das Programm startet, werdet ihr aber sehen, daß die Rakete
; ganz rechts nicht funktioniert.
; Ihr wollt sie reparieren? Dann lest den Kommentar am Ende des Listings.

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen das PIC auf die übliche Art

	MOVE.L	#PIC,d0
	LEA	BPLPOINTERS,A1
	MOVEQ	#2-1,D1
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP

;	Pointen auf die Sprites

	LEA	SpritePointers,a1		; Pointer in der Copperlist
	MOVE.L	#MEINSPRITE0,d0		; Adresse des Sprite in d0
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	add.l	#16,a1				; Spritepointer 2
	MOVE.L	#MEINSPRITE2,d0		; Adresse des Sprite in d0
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	add.l	#8,a1				; Spritepointer 3
	MOVE.L	#MEINSPRITE3,d0		; Adresse des Sprite in d0
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

	bsr.s	BewegeSprite0		; Bewege das Flugzeug
	bsr.s	BewegeSprite2		; Bewege Rakete 1 gegen das Flugzeug
	bsr.s	BewegeSprite3		; Bewege Rakete 2 gegen das Flugzeug
	bsr.w	CheckColl			; Kontrolliert Kollisionen und greift ein

Warte:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001			; Mouse gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte COP

	move.l	4.w,a6
	jsr	-$7e(a6)				 ; Enable
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

; Diese Routine bewegt das Flugzeug um 2 Pixel pro Durchgang nach links

BewegeSprite0:
	subq.b	#1,HSTART0
	rts


; Diese Routine steuert die Rakete. Sie tut es nur, wenn das Flugzeug nah
; genug dran ist, um getroffen zu werden.


BewegeSprite2:
	cmp.b	#$b0,HSTART0
	bhi.s	nicht_in_Schusslinie2	; nicht starten, wenn das Flugzeug
	subq.b	#1,VSTART2				; zu weit rechts ist
	subq.b	#1,VSTOP2
nicht_in_Schusslinie2:
	rts

; Diese Routine steuert die Rakete. Sie tut es nur, wenn das Flugzeug nah
; genug dran ist, um getroffen zu werden.

BewegeSprite3:
	cmp.b	#$d0,HSTART0
	bhi.s	nicht_in_Schusslinie3	; nicht starten, wenn das Flugzeug
	subq.b	#1,VSTART3				; zu weit rechts ist
	subq.b	#1,VSTOP3
nicht_in_Schusslinie3:
	rts

; Diese Routine kontrolliert, ob es eine Kollision gab. Wenn ja, löscht sie
; die beiden Sprites, die zusammengestoßen sind, indem sie die jeweiligen
; Spritepointer in der Copperlist löscht. Um unterscheiden zu können, welche
; der beiden Raketen ins Ziel gegangen ist, werden die Positionen abgefragt.
; In diesem Fall können die Raketen das Flugzeug nur von unten treffen; wenn
; sich eine Rakete also höher befindet als dieses, dann kann sie es nicht
; getroffen haben. Durch diese Methode können wir herausfinden, welche
; Rakete nun getroffen hat.

CheckColl:
	move.w	$dff00e,d0		; liest CLXDAT ($dff00e)
							; ein Lesevorgang dieses Register bewirkt
							; auch dessen komplette Löschung, es ist deshalb
							; ratsam, es sich in d0 zu kopieren, und dann
							; dort die Tests durchzuführen
	btst.l	#9,d0
	beq.s	no_coll	 		; wenn keine Kollision, überspringe

	MOVEQ	#0,d0			; ansonsten lösche die Sprites
	LEA	SpritePointers,a1	; Pointer Sprite 0
	move.w	d0,6(a1)		; Lösche Spritepointer 0 in der Copperlist
	move.w	d0,2(a1)

; Nun müssen wir noch verstehen, welche der beiden Raketen getroffen hat.
; Wir kontrollieren die Höhe der Rakete, die weiter rechts steht: wenn
; sie höher ist als das Flugzeug, dann KANN sie es NICHT getroffen haben.

	move.b	VSTART0,d1		; liest die Höhe des Flugzeuges
	cmp.b	VSTART3,d1		; vergleicht mit der Höhe der Rakete rechts
	bhi.s	spr2_coll		; wenn das Flugzeug tiefer ist
							; (also VSTART0 größer als VSTART3 ist)
							; dann wurde die Kollision vom Sprite 2
							; ausgelöst

	LEA	SpritePointer3,a1	; ansonsten lösche Sprite 3
	move.w	d0,6(a1)		; Löscht Spritepointer 3 in der Copperlist
	move.w	d0,2(a1)
	bra.s	no_coll
	
spr2_coll:
	LEA	SpritePointer2,a1	; Löscht Sprite 2
	move.w	d0,6(a1)		; löscht Spritepointer 2 in der Copperlist
	move.w	d0,2(a1)
no_coll:
	rts


		SECTION GRAPHIC,DATA_C

COPPERLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0
SpritePointer2:
	dc.w	$128,0,$12a,0
SpritePointer3:
	dc.w	$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

			   ; 5432109876543210
	dc.w	$98,%0000000000000000	; CLXCON	$dff098

	dc.w	$8E,$2c81		; DiwStrt
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$38			; DdfStart
	dc.w	$94,$d0			; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,$0024		; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

		    ; 5432109876543210
	dc.w	$100,%0010001000000000	; 2 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste	Bitplane
	dc.w	$e4,0,$e6,0		; zweite Bitplane

	dc.w	$180,$000		; COLOR0	; schwarzer Hintergrund
	dc.w	$182,$005		; COLOR1	; Farbe 1 del bitplane
	dc.w	$184,$a40		; COLOR1	; Farbe 2 del bitplane
	dc.w	$186,$f80		; COLOR1	; Farbe 3 del bitplane

	dc.w	$1A2,$06f		; COLOR17, also COLOR1 des Sprite0
	dc.w	$1A4,$0c0		; COLOR18, also COLOR2 des Sprite0
	dc.w	$1A6,$0c0		; COLOR19, also COLOR3 des Sprite0

	dc.w	$1AA,$444		; COLOR21, also COLOR1 des Sprite2
	dc.w	$1AC,$888		; COLOR22, also COLOR2 des Sprite2
	dc.w	$1AE,$0c0		; COLOR23, also COLOR3 des Sprite2

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; ************ Hier ist der Sprite: KLARERWEISE in CHIP RAM! ************

MEINSPRITE0:	; Länge 6 Zeilen
VSTART0:
	dc.b 180	; Vertikale Anfangsposition des Sprite (da $2c a $f2)
HSTART0:
	dc.b $d8	; Horizontale Anfangsposition des Sprite (da $40 a $d8)
VSTOP0:
	dc.b 186	; 180+6=186
VHBITS:
	dc.b $00
	dc.w	$0008,$0000
	dc.w	$1818,$0000
	dc.w	$2C28,$1010
	dc.w	$7FF8,$0000
	dc.w	$3FC0,$0000
	dc.w	$01F0,$0000
	dc.w	$0000,$0000

MEINSPRITE2:	; Länge 16 Zeilen
VSTART2:
	dc.b 224	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART2:
	dc.b $86	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP2:
	dc.b 240
	dc.b 0
	dc.w	$0200,$0000
	dc.w	$0200,$0000
	dc.w	$0200,$0000
	dc.w	$0000,$0200
	dc.w	$0000,$0700
	dc.w	$0000,$0700
	dc.w	$0500,$0200
	dc.w	$0200,$0500
	dc.w	$0500,$0200
	dc.w	$0200,$0500
	dc.w	$1540,$0200
	dc.w	$0200,$1DC0
	dc.w	$0000,$1FC0
	dc.w	$0000,$1740
	dc.w	$0500,$0200
	dc.w	$0000,$0000
	dc.w	$0000,$0000

MEINSPRITE3:	; Länge 16 Zeilen
VSTART3:
	dc.b 224	; Vertikale Anfangsposition des Sprite (von $2c bis $f2)
HSTART3:
	dc.b $a6	; Horizontale Anfangsposition des Sprite (von $40 bis $d8)
VSTOP3:
	dc.b 240
	dc.b 0
	dc.w	$0200,$0000
	dc.w	$0200,$0000
	dc.w	$0200,$0000
	dc.w	$0000,$0200
	dc.w	$0000,$0700
	dc.w	$0000,$0700
	dc.w	$0500,$0200
	dc.w	$0200,$0500
	dc.w	$0500,$0200
	dc.w	$0200,$0500
	dc.w	$1540,$0200
	dc.w	$0200,$1DC0
	dc.w	$0000,$1FC0
	dc.w	$0000,$1740
	dc.w	$0500,$0200
	dc.w	$0000,$0000
	dc.w	$0000,$0000

;	Bild der Startrampe der Raketen

PIC:
	incbin	"/Sources/paesaggio.raw"

	end

Wie wir in der Lektion gesehen haben, erlaubt uns das Register CLXDAT  nur
zu  erkennen,  ob  eine Kollision zwischen Spritepaaren stattgefunden hat,
nicht zwischen den einzelnen Sprite. In diesem  Beispiel  sehen  wir,  wie
dieses  Problem  gelöst  werden  kann.  Ich  erinnere  euch daran, daß die
Kollisionen der geraden Sprite (also 0,2,4,6) immer  aktiviert  sind,  die
der  ungeraden  (1,3,5,7)  aber erst aktivert werden müssen. Das geschieht
durch Kontrollbits im Register CLXCON ($dff098). Jeder ungerade Sprite hat
ein  eigenes  Kontrollbit  und  kann demzufolge unabhängig von den anderen
eingeschaltet werden. Wenn ihr versucht,  das  Listing  auszuführen,  dann
bemerkt  ihr,  daß die rechte Rakete nicht funktioniert. Das deshalb, weil
dieser Sprite ein ungerader ist (Sprite 3), und deaktiviert auch noch.  In
der Copperlist findet ihr folgenden Befehl:

			   ; 5432109876543210
	dc.w	$98,%0000000000000000

Er deaktiviert die Kollisionen für alle ungeraden Sprites (für die  genaue
Beschreibung  aller  Bits  seht  euch  die Lektion an). Um den Sprite 3 zu
aktivieren muß Bit 13 auf 1 gesetzt werden. Die Copperanweisung  muß  also
so aussehen:

		       ; 5432109876543210
	dc.w	$98,%0010000000000000

Probiert das Listing nun  aus,  und  ihr  werdet  sehen,  daß  die  Rakete
funktioniert!

Ein  weiteres  Problem  der  Kollisionen  ist, daß das Register CLXDAT nur
Kollisionen unter Spritepaaren aufspürt, nicht aber zwischen den einzelnen
Sprites.  In  unserem  Beispiel gehören die Raketen beide zum selben Paar.
Wenn nun eine Kollision auftritt  können  wir  nicht  wissen,  welche  der
beiden Raketen es gewesen ist, wenn wir nur das  Register CLXDAT lesen. Um
das zu erfahren ist die meistens verwendete Methode das kontrollieren  der
Spritepositionen.  In  diesem  recht  einfachem  Beispiel  braucht  nur
verglichen werden, ob der  Sprite  rechts  mehr  oder  weniger  über  dem
Flugzeug ist, es ist besser im Kommentar der Routine CheckColl erklärt. In
komplexeren Situationen, bei denen sich die Sprites in mehrere  Richtungen
bewegen,  sind  aufwendigere  Kontrollen notwendig, dort muß man sich dann
auf vertikale und horizontale Position berufen. Das Prinzip ist aber immer
das gleiche.

Ihr  könnt  überprüfen,  daß  unsere  Routine  immer  die richtige  Rakete
erwischt, indem ihr die Startpositionen der rechten Rakete verändert.  Der
Anfangswert von HSTART3 ist auf $6a und garantiert der Rakete, daß sie das
Flugzeug treffen wird. Ersetzt $6a durch $6b. Wenn ihr  das  Beispiel  nun
ausführt,  werdet ihr sehen, daß sie nun das Flugzeug verfehlt. Aber keine
Angst! die zweite wird mitten rein dreschen!

