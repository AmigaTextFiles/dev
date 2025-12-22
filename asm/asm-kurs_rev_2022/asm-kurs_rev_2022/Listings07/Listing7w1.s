
; Listing7w1.s	KOLLISIONEN ZWISCHEN SPRITES

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
	MOVEQ	#2-1,D1
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

	MOVE.L	#MEINSPRITE2,d0		; Adresse des Sprite in d0
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
	bsr.s	BewegeSprite1		; Bewege die Rakete gegen das Flugzeug
	bsr.s	CheckColl			; Kontrolliere die Kollisionen und
								; greife eventuell ein

Warte:
	cmpi.b	#$ff,$dff006		; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001			; Mouse gedrückt?
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

; Diese Routine bewegt den Sprite, der das Flugzeug darstellt, gradlinig
; um jeweils 2 Pixel nach links. Sie greift auf das Byte HSTART zu

BewegeSprite0:
	subq.b	#1,HSTART0
	rts

;	-		-		-		-

; Dieses Routine bewegt die Rakete. Sie tut das nur, wenn das Flugzeug nah
; genug ist, um getroffen zu werden. Es ist soweit, wenn dessen HSTART $b0
; erreicht hat. Wenn ihr das Flugzeug retten wollt, versucht die Rakete bei
; $AA abzuschießen, also zu früh, oder bei Position $c1, wo es schon zu
; spät ist.

BewegeSprite1:
	cmp.b	#$b0,HSTART0			; Ist das Flugzeug in Schußweite?
	bhi.s	nicht_in_Schussweite	; noch nicht schießen, wenn es zu weit
									; weg ist
	subq.b	#1,VSTART2				; laß die Rakete steigen, indem auf das VSTART
	subq.b	#1,VSTOP2				; wie das VSTOP eingewirkt wird
nicht_in_Schussweite:
	rts

;	-		-		-		-

; Diese Routine kontrolliert, ob es eine Kollision gab. Wenn ja, löscht
; sie die beiden Sprites, indem sie deren Pointer in der Copperlist auf


CheckColl:
	move.w	$dff00e,d0		; liest CLXDAT ($dff00e)
							; ein Lesevorgang dieses Register bewirkt
							; auch dessen komplette Löschung, es ist deshalb
							; ratsam, es sich in d0 zu kopieren, und dann
							; dort die Tests durchzuführen
	btst.l	#9,d0
	beq.s	no_coll			; wenn keine Kollision, überspringe

	MOVEQ	#0,d0			 ; ansonsten lösche die Sprites
	LEA	SpritePointers,a1	; Pointer Sprite 0
	move.w	d0,6(a1)		; Lösche Spritepointer 0 in der Copperlist
	move.w	d0,2(a1)
	add.w	#16,a1			; Pointer Sprite 2
	move.w	d0,6(a1)		; Lösche Pointer auf Sprite 2 in der Copperlist
	move.w	d0,2(a1)
no_coll:
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
	dc.w	$104,$0024		; BplCon2 - Sprites über den Bitplanes
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0010001000000000	; Bit 13 an 2 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane
	dc.w	$e4,0,$e6,0		; zweite Bitplane

	dc.w	$180,$000		; COLOR0	; schwarzer Hintergrund
	dc.w	$182,$005		; COLOR1	; COLOR 1 des Bitplane
	dc.w	$184,$a40		; COLOR1	; COLOR 2 des Bitplane
	dc.w	$186,$f80		; COLOR1	; COLOR 3 des Bitplane

	dc.w	$1A2,$06f		; COLOR17, also COLOR1 des Sprite0
	dc.w	$1A4,$0c0		; COLOR18, also COLOR2 des Sprite0
	dc.w	$1A6,$0c0		; COLOR19, also COLOR3 des Sprite0

	dc.w	$1AA,$444		; COLOR21, also COLOR1 des Sprite2
	dc.w	$1AC,$888		; COLOR22, also COLOR2 des Sprite2
	dc.w	$1AE,$0c0		; COLOR23, also COLOR3 des Sprite2

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


; *********** Hier ist der Sprite: Klarerweise ist er in CHIP RAM! ************

MEINSPRITE0:	; Länge 6 Zeilen
VSTART0:
	dc.b 180	; Vertikale Anfangsposition (von $2c bis $f2)
HSTART0:
	dc.b $d8	; Horizontale Anfangsposition (von $40 bis $d8)
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
	dc.b 224	; Vertikale Anfangsposition (von $2c bis $f2)
HSTART2:
	dc.b $86	; Horizontale Anfangsposition (von $40 bis $d8)
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

;	Bild der Startrampe

PIC:
	incbin	"/Sources/paesaggio.raw"

	end

In  diesem Beispiel sehen wir, wie man die Kollision zwischen zwei Sprites
registrieren kann.
Wir haben zwei Objekte, die sich kreuzen. Achtet darauf, daß wir  für  die
zwei  Objekte  die  Sprites  0 und 2 gewählt haben, also zwei Sprites, die
verschiedenen Paaren angehören. Das erlaubt uns zum Einen  die  Verwendung
von  zwei  verschiedenen Farbpaletten, ist aber andererseits notwendig, um
die Kollisionen überhaupt erkennen zu können. Denn  es  ist  nur  möglich,
Kollisionen  zwischen  Sprites  aus verschiedenen Gruppen zu erkennen, und
nicht zwischen Sprites aus ein und demselben Paar. Um  eine  Kollision  zu
erkennen  muß  nur ein Bit im Register CLXDAT kontrolliert werden, wie wir
schon in der Lektion gehört haben.

Wenn dieses Bit auf  1  steht,  dann  hat  sich  effektiv  eine  Kollision
zugetragen.  In unserem Beispiel beschränken wir uns lediglich darauf, die
beiden Sprites zu löschen, indem wir die Pointer auf 0 zeigen lassen.  Ihr
könnt  es  natürlich  verbessern,  indem  ihr  eine  schöne  Explosion
dazu zeichnet. Es ist sehr einfach. Als erstes  zeichnet  ihr  euch  einen
Sprite,  der  eine  Explosion darstellt, und fügt ihn im Listing ein (Aber
bitte in die SECTION, die in  die  CHIP  kommt!!).  Dann  modifiziert  die
Routine  CheckColl:  wenn  eine  Kollision  auftritt,  dann  ersetzt  die
folgenden Zeilen


	MOVEQ	#0,d0			; ansonsten lösche die Sprites
	LEA	SpritePointers,a1	; Spritepointer 0
	move.w	d0,6(a1)		; lösche Spritepointer0 in der Copperlist
	move.w	d0,2(a1)

durch diese

	MOVE.L	#EXPLOSIONS_SPRITE,d0	; Adresse des Explosionssprite
	LEA	SpritePointers,a1			; Spritepointer 0
	move.w	d0,6(a1)		; verändert Spritepointer 0 in der Copperlist
	swap	d0
	move.w	d0,2(a1)

dadurch wird das Bild des Flugzeuges durch das der Explosion ersetzt.  Ihr
müßt  dann  natürlich  noch  die  Byte,  die  die  Position des Flugzeuges
kontrollieren, in die Kontrollbytes der Explosion kopieren. Das könnt  ihr
nun  aber  schon alleine. Ihr müßt nur bei VSTOP etwas aufpassen: wenn die
Explosion eine andere Höhe hat als das Flugzeug, dann könnt ihr nicht  nur
das  alte  VSTOP  einsetzen,  sondern  ihr  müßt  es  anpassen.  Aber  nix
schwieriges.

In diesem Beispiel haben wir gezielt sehr einfache Bahnen gewählt  (gerade
Linien),  um  den  Mechanismus  der  Kollision besser zu zeigen. Ihr könnt
statt dieser Routinen auch solche mit Tabellen einsetzen, wie wir  sie  in
einigen vorigen Beispielen verwendet haben.


