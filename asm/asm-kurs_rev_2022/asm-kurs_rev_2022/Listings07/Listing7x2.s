
; Listing7x2.s	- Kollision Sprite-Dual Playfield-Mode
; In diesem Beispiel zeigen wir die Kollision zwischen einem Sprite und
; den zwei Playfields. Der Sprite bewegt sich von oben nach unten. Wenn eine
; Kollision auftritt, verändert sich die Hintergrundfarbe (Rot oder Grün,
; je nach Art der Kollision).
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

; wir verwenden 2 planes für jedes playfield

;	Pointen wie immer auf unser PIC

	MOVE.L	#PIC1,d0
	LEA	BPLPOINTERS1,A1
	MOVEQ	#2-1,D1
POINTBP:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP


	MOVE.L	#PIC2,d0		; point playfield 2
	LEA	BPLPOINTERS2,A1
	MOVEQ	#2-1,D1
POINTBP2:
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	ADD.L	#40*256,d0
	addq.w	#8,a1
	dbra	d1,POINTBP2

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


	move.w	#$0024,$dff104		; BPLCON2	%0100100
								; mit diesem Wert sind alle Sprites über
								; den Bitplanes

Warte1:
	cmp.b	#$ff,$dff006		; Zeile 255?
	bne.s	Warte1
Warte11:
	cmp.b	#$ff,$dff006		; immer noch Zeile 255?
	beq.s	Warte11

	btst	#6,$bfe001
	beq.s	Raus

	bsr.s	BewegeSprite		; Bewege den Sprite nach unten
	bsr.w	CheckColl			; Kontrolliert Kollision und greift ein

	bra.s	Warte1

Raus	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088			; Starten die alte SystemCOP

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

; Diese Routine bewegt den Sprite 0 nach unten, jeweils um 1 Pixel pro
; Frame. Es wird ein Flag verwendet.

BewegeSprite:
	not.w	flag
	beq.s	EndeBewegeSprite

	addq.w	#1,Hoehe
	cmp.w	#300,Hoehe			; ist er am unteren Rand angekommen?
	blo.s	kein_Rand
	move.w	#$2c,Hoehe			; wenn ja, setz ihn wieder rauf
kein_Rand:
	move.w	Hoehe(PC),d0
	CLR.B	VHBITS0	 			; lösche Bit 8 der vertikalen Position
	MOVE.b	d0,VSTART0			; Kopiert die Bit von 0 bis 7 von VSTART
	BTST.l	#8,D0				; ist die Position größer als 255 ?
	BEQ.S	NOBIGVSTART			; wenn nicht, geh weiter, das Bit wurde schon
								; vom CLR.b VHBITS gelöscht
	BSET.b	#2,VHBITS0			; ansonsten setze Bit 8 auf 1 (Vertikale Start-
								; position)
NOBIGVSTART:
	ADDQ.w	#8,D0				; Zähle die Länge des Sprite dazu, um die
								; Endposition (VSTOP) zu ermitteln
	move.b	d0,VSTOP0			; Gib die Bit von 0 bis 7 in VSTOP
	BTST.l	#8,D0				; ist die Position größer als 255 ?
	BEQ.S	NOBIGVSTOP			; wenn nicht, geh weiter, denn das Bit wurde
								; schon mit dem CLR.b VHBITS auf NULL gesetzt
	BSET.b	#1,VHBITS0			; ansonsten setze Bit 8 auf 1 (Vertikale Start-
								; position)
NOBIGVSTOP:
EndeBewegeSprite:
	rts


; Diese Routine kontrolliert, ob es eine Kollision gibt.
; Wenn ja, verändert sie die Farbe des Hintergrundes, in dem sie in der
; Copperlist das Register COLOR0 verändert.

CheckColl:
	move.w	$dff00e,d0			; liest CLXDAT ($dff00e)
								; das Lesen dieses Registers bewirkt auch
								; seine sofortige Löschung, es ist also besser,
								; man kopiert es sich in d0 und macht dort dann
								; die Tests
	btst.l	#1,d0				; das Bit 1 meldet eine Kollision zwischen
								; Sprite 0 und Playfield 1
	beq.s	no_coll1			; wenn´s keine Kollision gab, überspringe

	move.w	#$f00,Kollisions_Sensor ; "anschalten" des Signales (COLOR0)
								; verändert die Copperlist (Rot)
	bra.s	exitColl			; Raus

no_coll1:
	btst.l	#5,d0				; Das Bit 5 meldet eine Kollision zwischen
								; Sprite 0 und Playfield 2
	beq.s	no_coll2			; wenn´s keine Kollision gab, überspringe
	move.w	#$0f0,Kollisions_Sensor ; "anschalten" des Signales (COLOR0)
								; verändert die Copperlist (Grün)
	bra.s	exitColl			; Raus

no_coll2:
	move.w	#$000,Kollisions_Sensor ; "ausschalten" des Signales (COLOR0)
								; verändert die Copperlist (Schwarz)
exitColl:
	rts

flag:
	dc.w	0
Hoehe:
	dc.w	$2c


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
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0100011000000000	; Bit 10 an = Dual Playfield
							; 4 Planes = 4 Farben pro Playfield

BPLPOINTERS1:
	dc.w	$e0,0,$e2,0		; erste Bitplane Playfield 1 (BPLPT1)
	dc.w	$e8,0,$ea,0		; zweite Bitplane Playfield 1 (BPLPT3)


BPLPOINTERS2:
	dc.w	$e4,0,$e6,0		; erste Bitplane Playfield 2 (BPLPT2)
	dc.w	$ec,0,$ee,0		; zweite Bitplane Playfield 2 (BPLPT4)

; Das ist das Register CLXCON (kontrolliert die Art der Registrierung)

; Die Bit von 0 bis 5 sind die Werte, die von den Planes eingenommen werden
; müssen
; Die Bit 6 bis 11 zeigen, welche Planes aktiv für Kollisionen sind
; Die Bit 12 bis 15 zeigen, welche ungeraden Sprites aktiviert werden sollen
; (für die Spriteregistrierung)

				;5432109876543210
	dc.w	$98,%0000001111001011	; CLXCON

; Diese Werte bedeuten, daß die Planes 1,2,3,4 für die Kollis. aktiviert sind.
; Es wird eine Kollision angezeigt, wenn der Sprite Playfield 1 überlagert, das
; die Pixel so hat:		Plane 1 = 1 (Bit 0)
;						Plane 3 = 0 (Bit 2)
; Also wird Color1 des Playfield 1 eine Kollision verursachen.

; Es wird eine Koll. mit Playf. 2 gemeldet, wenn der Sprite über der folgenden
; Pixelkombination ist: Plane 2 = 1 (Bit 1)
;						Plane 4 = 1 (Bit 3)
; Also Color3 des Playfield 2


	dc.w	$180			; COLOR00
Kollisions_Sensor:
	dc.w	0				; An DIESEM PUNKT schreibt die Routine CheckColl in
							; die Copperlist und verändert die Farben.

							; Palette Playfield 1
	dc.w	$182,$005		; Farben von 0 bis 7
	dc.w	$184,$a40
	dc.w	$186,$f80
	dc.w	$188,$f00
	dc.w	$18a,$0f0
	dc.w	$18c,$00f
	dc.w	$18e,$080


							; Palette Playfield 2
	dc.w	$192,$367		; Farben von 9 bis 15
	dc.w	$194,$0cc		; Die Farbe8 ist durchsichtig, sie wird nicht
	dc.w	$196,$a0a		; gesetzt.
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

PIC1:	incbin	"/Sources/colldual1.raw"
PIC2:	incbin	"/Sources/colldual2.raw"

; ********* Und hier der Sprite: KLARERWEISE in CHIP RAM!! *********

MEINSPRITE0:
VSTART0:
	dc.b $2c
HSTART0:
	dc.b $80
VSTOP0:
	dc.b $2c+8
VHBITS0
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0


	end

Dieses Beispiel  zeigt,  wie  die  Kollisionen  zwischen  Sprite  und  den
Playfields  (im Dual-Playfield-Mode) funktionieren. Die Kollisionen werden
unabhängig voneinander für  die  2  Playfields  kontrolliert,  indem  zwei
verschiedene  Bits  im  Register  CLXDAT  gelesen  werden. In unserem Fall
verwenden wir das Bit 1 für die Kollision mit  dem  Playfield  1  (geraden
Planes)  und  Bit  5  für  das  Playfield 2 (ungerade Planes). Im Reigster
CLXCON funktioniert alles wie im Falle eines normalen Bildschirmes:

Die Bit von 0 bis 5 sind die Werte, die die Planes einnehmen müssen.
Die Bit von 6 bis 11 geben an, welche Planes für die Kollisionen aktiviert sind
Die Bit von 12 bis 15 geben an, welche der ungeraden Sprites für die
Kollision aktiviert sind.

Es bleibt immer noch die Möglichkeit offen, einige Planes  nicht  für  die
Kollisionsdetektion  freizugeben,  sie  also  nicht  zu  aktivieren, um so
mehrere Farben nutzen zu können. Es wurde  in  Listing7w2.s  gezeigt.  Ihr
könnt versuchen, in der Copperlist den Wert des CLXCON zu verändern.

