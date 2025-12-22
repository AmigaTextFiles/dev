
; Listing6q.s	BRINGT EINIGE VERSCHIEDENE SCHACHMUSTER AUF DEN
;				BILDSCHIRM - LINKE - RECHTE - LINKE MAUSTASTE
;				ABWECHSELND, UM DIE MUSTER ZU SEHEN

	SECTION	CIPundCOP,CODE

Anfang:
	move.l	4.w,a6			; Execbase
	jsr	-$78(a6)			; Disable
	lea	GfxName(PC),a1		; Namen der Lib
	jsr	-$198(a6)			; OpenLibrary
	move.l	d0,GfxBase		;
	move.l	d0,a6
	move.l	$26(a6),OldCop	; speichern die alte COP

;	POINTEN AUF UNSERE BITPLANES
 
	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1		; COP - Pointer
	move.w	d0,6(a1)
	swap	d0		
	move.w	d0,2(a1)	

	move.l	#COPPERLIST,$dff080	; COP1LC - unsere COP
	move.w	d0,$dff088		; COPJMP1 - Starten unsere COP
	move.w	#0,$dff1fc		; FMODE - Deaktiviert das AGA
	move.w	#$c00,$dff106	; BPLCON3 - Deaktiviert das AGA

	bsr.s	MATRIX1

mouse:
	btst	#6,$bfe001		; Linke Maustaste?
	bne.s	mouse

	bsr.w	MATRIX2

mouse2:
	btst	#2,$dff016		; Rechte Maustaste?
	bne.s	mouse2

	bsr.w	MATRIX3

mouse3:
	btst	#6,$bfe001		; Linke Maustaste?
	bne.s	mouse3

	bsr.w	MATRIX4
mouse4:
	btst	#2,$dff016		; Rechte Maustaste?
	bne.s	mouse4

	move.l	OldCop(PC),$dff080	; Pointen auf die System-Cop
	move.w	d0,$dff088		; Starten die alte Cop

	move.l	4.w,a6
	jsr	-$7e(a6)			; Enable
	move.l	gfxbase(PC),a1
	jsr	-$19e(a6)			; Closelibrary
	rts


; DATEN

GfxName:
	dc.b	"graphics.library",0,0

GfxBase:
	dc.l	0

OldCop:
	dc.l	0

; diese Routine erzeugt ein Schachbrett mit 8x8 Pixel großen Quadraten

MATRIX1:
	LEA	BITPLANE,a0			; Adresse Ziel-Bitplane

	MOVEQ	#16-1,d0		; 16 Paare von 8 Pixel hohen Quadraten
							; 16*2*8=256 totales Ausfüllen des Bildschirmes
MachPaar:
	move.l	#(20*8)-1,d1	; 20 Words um eine Zeile zu füllen
							; 8 Zeilen zu füllen
MachEins:
	move.w	#%1111111100000000,(a0)+ ; Länge eines Quadrates auf 1=8 Pixel
							; Quadrate auf NULL = 8 Pixel
	dbra	d1,MachEins		; mach 8 Zeilen #.#.#.#.#.#.#.#.#.#

	move.l	#(20*8)-1,d1	; 20 Words um 1 Zeile zu füllen
							; 8 Zeilen zu füllen
MachAndres:
	move.w	#%0000000011111111,(a0)+ ; Länge von auf NULL gesetzten Quad= 8
							; Quadrat auf 1 = 8 Pixel
	dbra	d1,MachAndres	; mach 8 Zeilen #.#.#.#.#.#.#.#.#.

	DBRA	d0,MachPaar		; Mach 16 Paare Quadrate
							; #.#.#.#.#.#.#.#.#.#
	rts						; .#.#.#.#.#.#.#.#.#.

; Diese Routine erzeugt ein Schachbrett mit 4 Pixel Seitenkante pro Quadrat

MATRIX2:
	LEA	BITPLANE,a0			; Adresse Ziel-Bitplane

	MOVEQ	#32-1,d0		; 32 Paare von 4 Pixel hohen Quadraten
							; 32*2*4=256 totales Ausfüllen des Bildschirmes
MachPaar2:
	move.l	#(40*4)-1,d1	; 40 Bytes um eine Zeile zu füllen
							; 4 Zeilen zu füllen
MachEins2:
	move.b	#%11110000,(a0)+	; Länge eines Quadrates auf 1 = 4 Pixel
							; Quadrate auf NULL = 4 Pixel
	dbra	d1,MachEins2	; mach 4 Zeilen #.#.#.#.#.#.#.#.#.#

	move.l	#(40*4)-1,d1	; 40 Bytes um eine Zeile zu füllen
							; 4 Zeilen zu füllen
MachAndres2:
	move.b	#%00001111,(a0)+ ; Länge eine auf NULL gesetzten Quadrat = 4 Pixel
							 ; Quadrat auf 1 = 4 Pixel
	dbra	d1,MachAndres2	 ; mach 8 Zeilen .#.#.#.#.#.#.#.#.#.

	DBRA	d0,MachPaar2	; mach 32 Paare von Quadraten
							; #.#.#.#.#.#.#.#.#.#
	rts						; .#.#.#.#.#.#.#.#.#.

; Diese Routine macht ein Schachbrett mit Quadraten zu 16 Pixel

MATRIX3:
	LEA	BITPLANE,a0			; Adresse Ziel-Bitplane

	MOVEQ	#8-1,d0			; 8 Paare von 16 Pixel hohen Quadraten
							; 8*2*4=256 totales Ausfüllen des Bildschirmes
MachPaar3:
	move.l	#(10*16)-1,d1	; 10 Bytes um eine Zeile zu füllen
							; 16 Zeilen zu füllen
MachEins3:
	move.l	#%11111111111111110000000000000000,(a0)+
							; Länge eines Quadrates auf 1 = 16 Pixel
							; Quadrate auf NULL = 16 Pixel
	dbra	d1,MachEins3	; mach 16 Zeilen #.#.#.#.#.#.#.#.#.#

	move.l	#(10*16)-1,d1	; 10 Bytes um eine Zeile zu füllen
							; 16 Zeilen zu füllen
MachAndres3:

	move.l	#%00000000000000001111111111111111,(a0)+
							; Länge eine auf NULL gesetzten Quadr.=16 Pixel
							; Quadrat auf 1 = 16 Pixel
	dbra	d1,MachAndres3	; mach 8 Zeilen .#.#.#.#.#.#.#.#.#.

	DBRA	d0,MachPaar3	; mach 8 Paare von Quadraten
							; #.#.#.#.#.#.#.#.#.#
	rts						; .#.#.#.#.#.#.#.#.#.


	; MATRIX Modell:"Fantasie"

MATRIX4:
	LEA	BITPLANE,a0			; Adresse Ziel-Bitplane in a0

	MOVEQ	#8-1,d0			; 8 Paare von 16 Pixel hohen Quadraten
							; 8*2*16=256 totales Ausfüllen des Bildschirmes
MachPaar4:
	move.l	#(10*16)-1,d1	; 10 Longwords um eine Zeile zu füllen
							; 16 Zeilen zu füllen
MachEins4:
	move.l	#%11111000000000011111000000000000,(a0)+ 
							; Länge Quadrat auf 1 = 4 Pixel
							; Quadrat auf 0 = 12 Pixel
	dbra	d1,MachEins4	; mach 16 Zeilen #.#.#.#.#.#.#.#.#.#

	move.l	#(10*16)-1,d1	; 10 Longwords um eine Zeile zu füllen
							; 16 Zeilen zu füllen
MachAndres4:
	move.l	#%00000000000011111000000000011111,(a0)+
							; Länge Quadrat auf 0 = 12
							; Quadrat auf 1 = 4 Pixel
	dbra	d1,MachAndres4	; mach	8 Zeilen .#.#.#.#.#.#.#.#.#.

	DBRA	d0,MachPaar4	; Mach 8 Paare von Quadraten
							; #.#.#.#.#.#.#.#.#.#
	rts						; .#.#.#.#.#.#.#.#.#.



	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,$0000,$122,$0000,$124,$0000,$126,$0000,$128,$0000 ; SPRITE
	dc.w	$12a,$0000,$12c,$0000,$12e,$0000,$130,$0000,$132,$0000
	dc.w	$134,$0000,$136,$0000,$138,$0000,$13a,$0000,$13c,$0000
	dc.w	$13e,$0000

	dc.w	$8E,$2c81		; DiwStrt (Register mit Normalwerten)
	dc.w	$90,$2cc1		; DiwStop
	dc.w	$92,$0038		; DdfStart
	dc.w	$94,$00d0		; DdfStop
	dc.w	$102,0			; BplCon1
	dc.w	$104,0			; BplCon2
	dc.w	$108,0			; Bpl1Mod
	dc.w	$10a,0			; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an - 1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste Bitplane

	dc.w	$0180,$000		; Color0 - Hintergrund
	dc.w	$0182,$19a		; Color1 - Schrift

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


	SECTION MEIPLANE,BSS_C	; Die SECTION BSS können nur aus NULLEN
							; bestehen!!! Man verwendet das DS.B um zu
							; definieren, wieviele Nullen die Section
							; enthalten soll

BITPLANE:
	ds.b	40*256			; eine Bitplane, 320x256 LowRes

	end

If you need a geometric background, you can do it with a routine!

