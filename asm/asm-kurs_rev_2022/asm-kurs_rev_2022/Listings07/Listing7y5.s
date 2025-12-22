
; Listing7y5.s	- Landschaft aus 2 Sprites, die scrollt.

;	Dieses Beispiel ist das gleiche wie das Vorige, nur scrollen
;	wir es hier auch noch.

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
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

;	Wir pointen NICHT auf den Sprite !!!!!!!!!!!!!!!!!!!!

	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse:
	cmpi.b	#$aa,$dff006	; Zeile $aa?
	bne.s	mouse

	bsr.w	BewegeBerge		; Läßt die Landschaft scrollen

Warte:
	cmpi.b	#$aa,$dff006	; Zeile $aa?
	beq.s	Warte

	btst	#6,$bfe001		; Mouse gedrückt?
	bne.s	mouse


	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; starten die alte SystemCOP

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


; Diese Routine bringt die Daten der Sprites zum scrollen, die die Berge
; bilden.

BewegeBerge:
	moveq	#14-1,d0		; Anzahl der Zeilen
	lea	SpriteForm,a0		; Adresse ersten Daten des Sprite
LandLoop:

; Läßt das Plane A der Sprites scrollen

	move.w	(a0),d1			; liest Wert von spr6data
	swap	d1				; gibt ihn in das hochw. Word des Registers
	move.w	8(a0),d1		; liest Wert von spr7data

	ror.l	#1,d1			; Läßt die Bit der Form des Sprites scrollen
	move.w	d1,8(a0)		; schreibt Wert	spr7data
	swap	d1				; vertauscht die Word des Registers
	move.w	d1,(a0)			; schreibt Wert	spr6data

; Läßt das Plane B der Sprites scrollen

	move.w	4(a0),d1		; liest Wert von spr6datb
	swap	d1				; gibt ihn in das hochw. Word des Registers
	move.w	12(a0),d1		; liest Wert von spr7datb

	ror.l	#1,d1			; Läßt die Bit der Form des Sprites scrollen
	move.w	d1,12(a0)		; schreibt Wert	spr7datb
	swap	d1				; vertauscht die Word des Registers
	move.w	d1,4(a0)		; schreibt Wert	spr6datb

	add.w	#140,a0			; nächste Zeile der Landschaft
	dbra	d0,LandLoop

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
	dc.w	$100,%0001001000000000	; Bit 12 an: 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

	dc.w	$180,$000		; COLOR0	; schwarzer Hintergrund
	dc.w	$182,$123		; COLOR1	; COLOR1 des Bitplane, das
							; in diesem Fall leer ist, und
							; deswegen nicht erscheint.


	dc.w	$01ba,$0fff		; COLOR29
	dc.w	$01bc,$0aaa		; COLOR30
	dc.w	$01be,$0753		; COLOR31

; Aus Bequemlichkeit verwenden wir Symbole. Ich erinnere euch, daß man ein
; Symbol (oder EQUATE) auf zwei Arten definieren kann: wie in diesem Fall,
; wo wir einfach ein = setzen, gefolgt vom Wert, den das Symbol haben soll,
; oder mit dem Schlüsselword EQU anstelle des =.

spr6pos		= $170
spr6data	= $174
spr6datb	= $176
spr7pos		= $178
spr7data	= $17c
spr7datb	= $17e


; Zeile $50 - (Die Copperanweisungen für eine Zeile sind 140 Byte lang)

	dc.w	$5025,$fffe		; Wait
	dc.w	spr6data
SpriteForm:					; Ab dieser Label machen wir alle Offsets
	dc.w	$0				; um die anderen SPRxDATx zu erreichen
	dc.w	spr6datb
	dc.w	$0
	dc.w	spr7data
	dc.w	$f000
	dc.w	spr7datb
	dc.w	$0
	dc.w	spr6pos,$40,spr7pos,$48,$504b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$505b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$506b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$507b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$508b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$509b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$50ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$50bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$50cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$50db,$fffe

; Zeile $51
	dc.w	$5125,$fffe
	dc.w	spr6data,$0001,spr6datb,$0000,spr7data,$b800,spr7datb,$4000
	dc.w	spr6pos,$40,spr7pos,$48,$514b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$515b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$516b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$517b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$518b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$519b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$51ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$51bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$51cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$51db,$fffe

; Zeile $52
	dc.w	$5225,$fffe
	dc.w	spr6data,$0003,spr6datb,$0000,spr7data,$bc00,spr7datb,$4000
	dc.w	spr6pos,$40,spr7pos,$48,$524b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$525b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$526b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$527b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$528b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$529b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$52ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$52bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$52cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$52db,$fffe

; Zeile $53
	dc.w	$5325,$fffe
	dc.w	spr6data,$0002,spr6datb,$0001,spr7data,$ec00,spr7datb,$1200
	dc.w	spr6pos,$40,spr7pos,$48,$534b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$535b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$536b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$537b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$538b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$539b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$53ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$53bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$53cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$53db,$fffe

; Zeile $54
	dc.w	$5425,$fffe
	dc.w	spr6data,$0007,spr6datb,$0000,spr7data,$2b00,spr7datb,$d400
	dc.w	spr6pos,$40,spr7pos,$48,$544b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$545b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$546b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$547b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$548b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$549b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$54ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$54bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$54cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$54db,$fffe

; Zeile $55
	dc.w	$5525,$fffe
	dc.w	spr6data,$001c,spr6datb,$0003,spr7data,$e780,spr7datb,$1800
	dc.w	spr6pos,$40,spr7pos,$48,$554b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$555b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$556b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$557b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$558b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$559b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$55ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$55bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$55cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$55db,$fffe

; Zeile $56
	dc.w	$5625,$fffe
	dc.w	spr6data,$803e,spr6datb,$0001,spr7data,$9ac1,spr7datb,$6500
	dc.w	spr6pos,$40,spr7pos,$48,$564b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$565b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$566b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$567b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$568b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$569b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$56ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$56bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$56cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$56db,$fffe

; Zeile $57
	dc.w	$5725,$fffe
	dc.w	spr6data,$c079,spr6datb,$0006,spr7data,$b6e7,spr7datb,$4910
	dc.w	spr6pos,$40,spr7pos,$48,$574b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$575b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$576b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$577b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$578b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$579b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$57ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$57bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$57cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$57db,$fffe

; Zeile $58
	dc.w	$5825,$fffe
	dc.w	spr6data,$c07f,spr6datb,$0048,spr7data,$fff6,spr7datb,$2009
	dc.w	spr6pos,$40,spr7pos,$48,$584b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$585b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$586b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$587b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$588b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$589b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$58ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$58bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$58cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$58db,$fffe

; Zeile $59
	dc.w	$5925,$fffe
	dc.w	spr6data,$e06f,spr6datb,$0096,spr7data,$7eaf,spr7datb,$a150
	dc.w	spr6pos,$40,spr7pos,$48,$594b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$595b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$596b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$597b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$598b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$599b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$59ab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$59bb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$59cb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$59db,$fffe

; Zeile $5a
	dc.w	$5a25,$fffe
	dc.w	spr6data,$61ed,spr6datb,$9013,spr7data,$dfff,spr7datb,$6cab
	dc.w	spr6pos,$40,spr7pos,$48,$5a4b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$5a5b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$5a6b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$5a7b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$5a8b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$5a9b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$5aab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$5abb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$5acb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$5adb,$fffe

; Zeile $5b
	dc.w	$5b25,$fffe
	dc.w	spr6data,$db9f,spr6datb,$72ed,spr7data,$ffff,spr7datb,$dbee
	dc.w	spr6pos,$40,spr7pos,$48,$5b4b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$5b5b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$5b6b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$5b7b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$5b8b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$5b9b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$5bab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$5bbb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$5bcb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$5bdb,$fffe

; Zeile $5c
	dc.w	$5c25,$fffe
	dc.w	spr6data,$ffff,spr6datb,$cfbf,spr7data,$ffff,spr7datb,$ff3f
	dc.w	spr6pos,$40,spr7pos,$48,$5c4b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$5c5b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$5c6b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$5c7b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$5c8b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$5c9b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$5cab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$5cbb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$5ccb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$5cdb,$fffe

; Zeile $5d
	dc.w	$5d25,$fffe
	dc.w	spr6data,$ffff,spr6datb,$ffff,spr7data,$ffff,spr7datb,$feff
	dc.w	spr6pos,$40,spr7pos,$48,$5d4b,$fffe
	dc.w	spr6pos,$50,spr7pos,$58,$5d5b,$fffe
	dc.w	spr6pos,$60,spr7pos,$68,$5d6b,$fffe
	dc.w	spr6pos,$70,spr7pos,$78,$5d7b,$fffe
	dc.w	spr6pos,$80,spr7pos,$88,$5d8b,$fffe
	dc.w	spr6pos,$90,spr7pos,$98,$5d9b,$fffe
	dc.w	spr6pos,$a0,spr7pos,$a8,$5dab,$fffe
	dc.w	spr6pos,$b0,spr7pos,$b8,$5dbb,$fffe
	dc.w	spr6pos,$c0,spr7pos,$c8,$5dcb,$fffe
	dc.w	spr6pos,$d0,spr7pos,$d8,$5ddb,$fffe

; Copperanweisung, um die Sprites zu deaktivieren

	dc.w	$5e07,$fffe		; Warte Anfang der Zeile ab
	dc.w	$172,0			; spr6ctl
	dc.w	$17a,0			; spr7ctl

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

	SECTION LEERESPLANE,BSS_C	; Wir brauchen ein leeres Bitplane,
							; denn ohne Bitplanes können wir
							; keine Sprites anzeigen.

BITPLANE:
	ds.b	40*256			; leere Bitplane Lowres

	end

In diesem Beispiel bringen wir die Landschaft aus  Sprites  zum  scrollen.
Dazu  ist  die  Verwendung des Registers BPLCON1 nicht möglich, das wir ja
verwendet hatten, um Bitplanes zu scollen, da dieses Register auf  Sprites
keinen  Effekt  hat.  Um  die  Berge zum Rollen zu bringen müssen wir alle
Pixel, aus denen sie bestehen, verstellen. Jetzt kommt es uns zurecht, daß
die Berge alle gleich sind, daß sie sich also in der horizontalen Richtung
wiederholen, und zwar alle 32 Pixel.
Das Panorama besteht nämlich aus zwei Sprites, jeder zu 16 Pixel, die sich
immerzu  wiederholen  und  für  die  gesamte Zeile gleich sind. Um nun die
Landschaft zum Scrollen bringen brauchen wir nun nur die Pixel, aus  denen
die  zwei Sprites bestehen, verschieben. Aber diese Pixel werden bei jeder
Zeile neu in  die  Register  SPR6DATA,  SPR6DATB,  SPR7DATA  und  SPR7DATB
geschrieben.  Also müssen wir den Inhalt dieser Register in der Copperlist
verändern. An der Adresse SpriteForm in  der  Copperlist  finden  wir  den
Wert,  der in SPR6DATA für die erste Zeile kommt. Jeweils 4,8 und 12 Bytes
später die Werte der Register SPR6DATB, SPR7DATA und SPR7DATB,  immer  für
die  erste  Zeile.  Wenn  wir  nun den Inhalt unserer Register in allen 14
Zeilen scrollen lassen, dann haben wir unser Ziel erreicht.

Sehen wir nun, wie wir einen Scroll, z.B. nach Rechts, erzielen.

Wir kennen schon die Anweisung, die es  uns  erlaubt,  die  Bit  in  einer
Speicherzelle  oder  einem Register zu verschieben. Es ist das LSR. Dieser
Befehl läßt die Bit nach Rechts rutschen, und schiebt links  immer  Nullen
nach. Zum Beispiel:

	move.b	#%00100101,d0
	lsr.b	#3,d0

Nach dieser Anweisung wird in d0 der Wert %00000100 stehen. Das  geht  für
uns  aber  nicht recht gut, denn die Nullen, die sich links einschmuggeln,
produzieren dann ein "Loch" im Sprite, das immer größer wird, bis sie dann
total verschwunden sind.

Was  wir  brauchen  ist  ein  Befehl,  der  zwar  die  Bit  nach  links
hinausschubst, aber sie rechts wieder reinläßt. Der die  Bit  im  Register
also  rotieren  läßt.  Diese  Anweisung  gibt´s,  sie  heißt  ROR ("ROtate
Right"). Sehen wir gleich ein Beispiel:


  move.b  #%00100101,d0
  ror.b  #3,d0

Nach diesem Schritt wird in d0 der Wert %10100100 sein. Praktisch sind die
drei  Bits  ganz  rechts  verdrängt  worden  und  dann  von  links  wieder
hineingeschlüpft. Es könnte etwa so aussehen:

Bit:     7 6 5 4 3 2 1 0
        -----------------
        | | | | | | | | |
        -----------------
       ->   -->   -->   -->
      |                     |   Laufrichtung
        <--   <--   <--   <-

Die Routine "BewegeBerge"  verwendet  eine  ROR-Anweisung,  um  die  Pixel
scrollen  zu lassen. Bemerkt, daß die Inhalte von SPR6DATA und SPR7DATA in
das gleiche Register kommen und dann zusammen rotiert  werden,  sodaß  das
Bit, das SPR6DATA von links verläßt, bei SPR7DATA rechts hineinkommen, und
die  Bits,  die  bei  SPR7DATA  links  rausfallen  bei  SPR6DATA  rechts
reinkommen.  Die  gleiche Operation wird auch für die Inhalte der Register
SPR6DATB und SPR7DATB verrichtet, die stellen das zweite Plane des  Sprite
dar.

Um  euch  besser vor Augen zu halten, wie der Unterschied zwischen dem LSR
und ROR ist, versucht, das ROR mit dem LSR in  der  Routine  "BewegeBerge"
auszutauschen.  Ihr  werdet  sehen,  daß  es  nicht genau das ist, was wir
wollten!

Natürlich gibt es zum ROR ein Gegenstück, das alles nach links rollen lät,
das  ROL  ("ROtate Left"). Es ist das gleiche wie das ROR, ihr könnt es in
der Routine austauschen  und  somit  die  Berge  in  die  andere  Richtung
schicken.

In  Theorie  könnte  man  mit  nur  zwei  Sprites  den gesamten Bildschirm
ausfüllen, angefangen ganz oben, mit den Wolken, weiter herunten  mit  den
Bergen,  die  Prärie  und  die  Bäume  im  Vordergrund.  Man  könnte  die
verscheidenen "Levels" auch mit verschiedenen  Geschwindigkeiten  scrollen
lassen, und so einen Parallax-Effekt erzeugen, also die Berge langsam, die
Prärie mittelschnell und die Bäume schnell. Aber  das  würde  eine  enorme
Copperlist  erfordern,  und die Scrollroutine wäre recht langsam, deswegen
werden für solche Operationen  die  Bitplanes  bevorzugt.  Sie  sind  auch
farbiger und eben schneller zu bewegen. Na ja, wenn sich nun jemand traut,
zu sagen, der Amiga hat nur 8 kleine Sprites, dann könntet ihr  ihm  einen
Bildschirm  zeigen,  der  nur aus 2 Sprites besteht, die sich in Parallaxe
bewegen, darübergeblendet ein Bild in 4096 Farben in HAM, dann würden euch
noch  6  Sprites  übrigbleiben,  um Sternchen und Raumschiffe zu zeichnen.
Wenn ihr dann dazwischen noch ein  paar  hundert  BOB´s  mit  dem  Blitter
rumdüsen  läßt...vielleicht  würde man nichts mehr verstehen, aber es wäre
interessant!

