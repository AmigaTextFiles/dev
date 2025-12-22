
; Listing7u.s  - BEISPIEL EINES DOUBLE PLAYFILED
; Das ist ein einfaches Beispiel für das Dual-Playfield-mode.
; Es werden die zwei Playfield angezeigt. Durch druck auf den rechten
; Mausknopf wird die Priorität der Playfileds vertauscht. Linke Taste
; zum Aussteigen.
; Achtet auf die Copperlist, die größten Unterschiede liegen beim
; Dual-Playfield-Mode bei den BPLPOINTERS und in den Farben.

	SECTION CipundCop,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Name lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	Pointen auf die PIC

	MOVE.L	#PIC1,d0		; pointen das Playfield 1
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

	MOVE.L	#PIC2,d0		; Pointen das playfield 2
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


	move.l	#COPPERLIST,$dff080	; unsere COP
	move.w	d0,$dff088		; START COP
	move.w	#0,$dff1fc		; NO AGA!
	move.w	#$c00,$dff106	; NO AGA!

mouse1:
	btst	#2,$dff016		; rechte Maustaste gedrückt?
	bne.s	mouse2

	bchg.b	#6,BPLCON2		; vertausche die Prioritäten durch Eingriff
							; auf Bit 6 von $dff104

mouse2:
	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse1

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

	dc.w	$104			; BplCon2
	dc.b	0
BPLCON2:
	dc.b	0				; Priorität zwischen den Playfileds:
							; Bit 6

	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0110011000000000	; Bit 10 an = Dual Playfield
							; verwende 6 Planes = 8 Farben
							; pro Playfield

BPLPOINTERS1:
	dc.w	$e0,0,$e2,0		; erste Bitplane Playfield 1 (BPLPT1)
	dc.w	$e8,0,$ea,0		; zweite Bitplane Playfield 1 (BPLPT3)
	dc.w	$f0,0,$f2,0		; dritte Bitplane Playfield 1 (BPLPT5)


BPLPOINTERS2:
	dc.w	$e4,0,$e6,0		; erste Bitplane Playfield 2 (BPLPT2)
	dc.w	$ec,0,$ee,0		; zweite Bitplane Playfield 2 (BPLPT4)
	dc.w	$f4,0,$f6,0		; dritte Bitplane Playfield 2 (BPLPT6)

	dc.w	$180,$0f0		; Palette Playfield 1
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

	dc.w	$FFFF,$FFFE		; Ende der Copperlist

;	Hier die zwei Bilder der beiden Playfields

PIC1:	incbin	"/Sources/dual1.raw"
PIC2:	incbin	"/Sources/dual2.raw"

	end

Das  ist ein einfaches Beispiel der Verwendung des Dual-Playfield-Mode. Um
etwas in diesem Modus anzuzeigen werden in etwa die  gleichen  Operationen
durchgeführt  wie sonst üblich. Nur ist darauf zu achten, daß beim pointen
der Bitplanes nicht vergessen wird, daß  die  geraden  Bitplanes  auf  ein
Playfield zeigen und die ungeraden auf das andere. Normalerweise verwendet
man hier zwei separate Routinen, und auch in  der  Copperlist  werden  die
geraden  Bitplanes  von  den  ungeraden  unterschieden. Bei den Farben hat
jedes Playfield seine Palette. Die Farben 0 und 8 sind die  Transparenten,
sie  lassen  also  durchscheinen,  was  darunter liegt,   gleich  wie  das
Transparente bei den Sprites. COLOR0 ist aber auch  der  Hintergrund,  das
heißt,  daß  dort,  wo  beide  Playfields durchsichtig sind, COLOR0 IMMMER
angezeigt wird, unabhängig von der Priorität der Playfields. Deswegen wird
COLOR0  trotzdem  immer gesetzt, während es bei COLOR8 sinnlos ist, ihn zu
setzen. Die Priorität der  Playfileds  wird  durch  Bit  6  des  Registers
BPLCON2  ($dff104)  bestimmt:  wenn  das  Bit  auf 0 steht, dann erscheint
Playfield 1 über dem Playfield 2, anders herum wenn Bit 6 auf eins steht.

