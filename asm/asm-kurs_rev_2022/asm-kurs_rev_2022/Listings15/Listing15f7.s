
; Listing15f7.s		Die AGA-Sprite-Palette wurde mit $dff10c verschoben.
				; Linke Taste zum Zuweisen von 2 verschiedenen Paletten
				; zu geraden und ungeraden Sprites, rechts zum Verlassen.

	SECTION	AgaRulez,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s"	; speichern copperlist etc.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001110100000	; copper, bitplane, sprite DMA

WaitDisk	EQU	30	; 50-150 zur Rettung (je nach Fall)

START:

;	Zeiger auf das leere Bild

	MOVE.L	#BITPLANE,d0	
	LEA	BPLPOINTERS,A1			; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

;	Zeiger auf alle sprites

	MOVE.L	#MIOSPRITE0,d0		; Adresse des Sprites in d0
	LEA	SpritePointers,a1		; Zeiger in copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE1,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)	
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE2,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE3,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE4,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE5,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE6,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	MOVE.L	#MIOSPRITE7,d0		; Adresse des Sprites in d0
	addq.w	#8,a1				; nächster SPRITEPOINTER
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Fmode zurücksetzen, burst normal
	move.w	#$c00,$106(a5)		; BPLCON3 zurücksetzen
	move.w	#$11,$10c(a5)		; BPLCON4 zurücksetzen

	move.w	#%11101110,bplcon4+2	; gleiche Palette für gerade Sprites
									; und ungerade

mouseS:
	btst.b	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mouseS

	move.w	#%11101111,bplcon4+2	; andere Palette für gerade Sprites
									; und ungerade

mouseD:
	btst.b	#2,$dff016				; rechte Maustaste gedrückt?
	bne.s	mouseD

	rts

;*****************************************************************************
;*				COPPERLIST				     *
;*****************************************************************************

	CNOP	0,8	; auf 64 Bit ausrichten

	section	coppera,data_C

COPLIST:
SpritePointers:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop

	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,-8		; Bpl1Mod (burst 64bit, modulo=modulo-8)
	dc.w	$10a,-8		; Bpl2Mod (wie oben)

			    ; 5432109876543210
	dc.w	$100,%0001001000000001	; 1 bitplane LORES 320x256.

	dc.w	$1fc,%0011	; Burst mode 64 bit, sprite Größe 16 pixel


BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste 	bitplane
	dc.w $e4,0,$e6,0	; zweite	   "
	dc.w $e8,0,$ea,0	; dritte	   "
	dc.w $ec,0,$ee,0	; vierte	   "
	dc.w $f0,0,$f2,0	; fünfte	   "
	dc.w $f4,0,$f6,0	; sechste	   "
	dc.w $f8,0,$fA,0	; siebte	   "
	dc.w $fC,0,$fE,0	; achte		   "

; Beachten Sie, dass die Sprite-Farben 24 Bit sind, auch wenn es nur 3 sind.

	DC.W	$106,$c00	; AUSWAHL PALETTE 0 (0-31), NIBBLE HOCH
COLP0:
	dc.w	$180,$000	; color0	; schwarzer Hintergrund
	dc.w	$182,$123	; color1	; Farbe 1 der Bitebene, die
									; in diesem Fall leer ist,
									; so erscheint sie nicht.

	DC.W	$106,$EC00	; AUSWAHL PALETTE 7 (224-255), NIBBLE NIEDRIG

bplcon4:
	dc.w	$10c,%11101111	; BPLCON4 - Palette sprite gerade = 224-240
								; 	    Palette sprite ungerade = 240-256

; Jetzt die Palettenbank für gerade sprites

	dc.w	$182,$F00	; color225, - COLOR1 von sprite0 -ROT
	dc.w	$184,$0F0	; color226, - COLOR2 von sprite0 -GRÜN
	dc.w	$186,$FF0	; color227, - COLOR3 von sprite0 -GELB

	dc.w	$18A,$FFF	; color229, - COLOR1 von sprite2 -WEISS
	dc.w	$18C,$0BD	; color230, - COLOR2 von sprite2 -BLAU
	dc.w	$18E,$D50	; color231, - COLOR3 von sprite2 -ORANGE

	dc.w	$192,$00F	; color233, - COLOR1 von sprite4 -BLAU
	dc.w	$194,$F0F	; color234, - COLOR2 von sprite4 -VIOLET
	dc.w	$196,$BBB	; color235, - COLOR3 von sprite4 -GRAU

	dc.w	$19A,$8E0	; color237, - COLOR1 von sprite6 -HELLGRÜN
	dc.w	$19C,$a70	; color238, - COLOR2 von sprite6 -BRAUN
	dc.w	$19E,$d00	; color239, - COLOR3 von sprite6 -DUNKELROT

; Jetzt die Palettenbank für ungerade sprites

	dc.w	$1A2,$555	; color241, - COLOR1 von sprite1 -grau
	dc.w	$1A4,$aa0	; color242, - COLOR2 von sprite1 -gelb
	dc.w	$1A6,$0af	; color243, - COLOR3 von sprite1 -hellblau

	dc.w	$1AA,$a0a	; color245, - COLOR1 von sprite3 -...
	dc.w	$1AC,$3fa	; color246, - COLOR2 von sprite3 -...
	dc.w	$1AE,$faf	; color247, - COLOR3 von sprite3 -...

	dc.w	$1B2,$254	; color249, - COLOR1 von sprite5 -...
	dc.w	$1B4,$5a3	; color250, - COLOR2 von sprite5 -...
	dc.w	$1B6,$4ee	; color251, - COLOR3 von sprite5 -...

	dc.w	$1BA,$22c	; color253, - COLOR1 von sprite7 -...
	dc.w	$1BC,$381	; color354, - COLOR2 von sprite7 -...
	dc.w	$1BE,$fe9	; color255, - COLOR3 von sprite7 -...

	dc.w	$FFFF,$FFFE	; Ende copperlist


;*****************************************************************************
; Hier sind die Sprites: Offensichtlich müssen sie sich im CHIP-RAM befinden!
;*****************************************************************************

MIOSPRITE0:		; Länge 13 Zeilen
VSTART0:
	dc.b $60	; Pos. vertikal (von $2c bis $f2)
HSTART0:
	dc.b $60	; Pos. horizontal (von $40 bis $d8)
VSTOP0:
	dc.b $68	; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0111111111111110,%1000010001000001
 dc.w	%0011111111111100,%1100010001000011
 dc.w	%0000111111110000,%1111001110001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite


MIOSPRITE1:		; Länge 13 Zeilen
VSTART1:
	dc.b $60	; Pos. vertikal (von $2c bis $f2)
HSTART1:
	dc.b $60+14	; Pos. horizontal (von $40 bis $d8)
VSTOP1:
	dc.b $68	; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000010001111
 dc.w	%0011111111111100,%1100000110000011
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0111111111111110,%1000000010000001
 dc.w	%0011111111111100,%1100000010000011
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

 ; für die sprite 2 und 3
 ;BINÄR 00=COLOR 0 (TRANSPARENT)
 ;BINÄR 10=COLOR 1 (WEISS)
 ;BINÄR 01=COLOR 2 (BLAU)
 ;BINÄR 11=COLOR 3 (ORANGE)

MIOSPRITE2:			; Länge 13 Zeilen
VSTART2:
	dc.b $60		; Pos. vertikal (von $2c bis $2f2)
HSTART2:
	dc.b $60+(14*2)	; Pos. horizontal (von $40 bis $d8)
VSTOP2:
	dc.b $68		; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111000111001111
 dc.w	%0011111111111100,%1100001000100011
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0111111111111110,%1000000111000001
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

MIOSPRITE3:			; Länge 13 Zeilen
VSTART3:
	dc.b $60		; Pos. vertikal (von $2c bis $f2)
HSTART3:
	dc.b $60+(14*3)	; Pos. horizontal (von $40 bis $d8)
VSTOP3:
	dc.b $68		; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0111111111111110,%1000000111100001
 dc.w	%0111111111111110,%1000000000100001
 dc.w	%0011111111111100,%1100000000100011
 dc.w	%0000111111110000,%1111001111101111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

 ; für die sprite 4 und 5
 ;BINÄR 00=COLOR 0 (TRANSPARENT)
 ;BINÄR 10=COLOR 1 (BLAU)
 ;BINÄR 01=COLOR 2 (VIOLET)
 ;BINÄR 11=COLOR 3 (GRAU)

MIOSPRITE4:			; Länge 13 Zeilen
VSTART4:
	dc.b $60		; Pos. vertikal (von $2c bis $f2)
HSTART4:
	dc.b $60+(14*4)	; Pos. horizontal (von $40 bis $d8)
VSTOP4:
	dc.b $68		; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001001001111
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

MIOSPRITE5:			; Länge 13 Zeilen
VSTART5:
	dc.b $60		; Pos. vertikal (von $2c bis $f2)
HSTART5:
	dc.b $60+(14*5)	; Pos. horizontal (von $40 bis $d8)
VSTOP5:
	dc.b $68		; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

 ; für die sprite 6 und 7
 ;BINÄR 00=COLOR 0 (TRANSPARENT)
 ;BINÄR 10=COLOR 1 (HELLGRÜN)
 ;BINÄR 01=COLOR 2 (BRAUN)
 ;BINÄR 11=COLOR 3 (DUNKELROT)

MIOSPRITE6:			; Länge 13 Zeilen
VSTART6:
	dc.b $60		; Pos. vertikal (von $2c bis $f2)
HSTART6:
	dc.b $60+(14*6)	; Pos. horizontal (von $40 bis $d8)
VSTOP6:
	dc.b $68		; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100001000000011
 dc.w	%0111111111111110,%1000001111000001
 dc.w	%0111111111111110,%1000001001000001
 dc.w	%0011111111111100,%1100001001000011
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

MIOSPRITE7:			; Länge 13 Zeilen
VSTART7:
	dc.b $60		; Pos. vertikal (von $2c bis $f2)
HSTART7:
	dc.b $60+(14*7)	; Pos. horizontal (von $40 bis $d8)
VSTOP7:
	dc.b $68		; $60+13=$6d	; Ende vertikal.
	dc.b $00
 dc.w	%0000001111000000,%0111110000111110
 dc.w	%0000111111110000,%1111001111001111
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0111111111111110,%1000000001000001
 dc.w	%0011111111111100,%1100000001000011
 dc.w	%0000111111110000,%1111000001001111
 dc.w	%0000001111000000,%0111110000111110
 dc.w	0,0	; Ende sprite

	SECTION	PLANEVUOTO,BSS_C	; Die von uns verwendete Reset-Bitebene,
								; weil um die Sprites zu sehen
								; muss es aktivierte Bitebenen geben
BITPLANE:
	ds.b	40*256		; bitplane leer lowres

	end

Das gesamte Listing basiert auf diese beiden Register der copperliste:

	DC.W	$106,$EC00		; AUSWAHL 7 (224-255), NIBBLE HOCH

	dc.w	$10c,%11101111	; BPLCON4 - Palette sprite gerade = 224-240
								; 	    Palette sprite ungerade = 240-256

Dann werden die Farben von 225 bis 255 eingestellt (nur die hohen nibble
Ich nicht will auch die niedrigen setzen!).	

Das "Verschieben" der Sprite-Palette an den unteren Rand der Palette kann
hilfreich sein, wenn Sie Figuren mit bis zu 128 Farben sehen. Dann ist die
Palette von unserem Sprite völlig unabhängig. Wenn die Figur in 256 Farben
ist, kann man sich für jede Bank mit 16 Farben entscheiden, die auch für 
Sprites verwendet werden können.