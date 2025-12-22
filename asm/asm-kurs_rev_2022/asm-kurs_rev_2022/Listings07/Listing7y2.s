
; Listing7y2.s	Vertikale Balken

;	In diesem Beispiel verwenden wir zwei Sprites, um vertikale Balken
;	zu erzeugen.

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
	cmpi.b	#$ff,$dff006	; Zeile 255?
	bne.s	mouse

	bsr.s	BewegeSprite	; Bewegt die Sprite 0 und 1 horizontal, aber
							; indem er auf die MOVE in der COPPERLIST zugreift,
							; da wir ja die Register direkt verwenden

Warte:
	cmpi.b	#$ff,$dff006	; Zeile 255?
	beq.s	Warte

	btst	#6,$bfe001		; linke Maustaste gedrückt?
	bne.s	mouse

	move.l	OldCop(PC),$dff080	; Pointen auf die SystemCOP
	move.w	d0,$dff088		; Starten die alte SystemCOP

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

; Diese Routine bewegt den Sprite, indem sie auf die Copperlist einwirkt,
; durch verändern des Wertes bar1, der in das Register SPRxPOS geladen wird,
; also das Byte der horizontalen Position. Es werden schon vorausberechnete
; Werte aus einer Tabelle eingesetzt, TABX.

BewegeSprite:
	ADDQ.L	#2,TABXPOINT		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT(PC),A0	; Adresse im Long TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-2,A0		; Sind wir beim letzten Longword der TAB?
	BNE.S	NOBSTART			; noch nicht? Dann mach weiter
	MOVE.L	#TABX-2,TABXPOINT	; Starte wieder beim ersten Long
NOBSTART:
	MOVE.w	(A0),d1

	add.w	#128,D1				; 128 - um den Sprite zu zentrieren
	btst.l	#0,D1				; Niederw. Bit der X-Koordinate = 0?
	beq.s	NiederBitNull
	bset.b	#0,bar1_b			; Setzen das niederwertige Bit der bar.
	bra.s	PlaceCoords

NiederBitNull:
	bclr.b	#0,bar1_b			; Löschen das niederwertige Bit der bar.
PlaceCoords:
	lsr.w	#1,D1				; SHIFTEN, bewegen also alles um 1 Bit nach rechts.

	move.b	D1,bar1				; Geben den XX-Wert in die Position des Sprite

	ADDQ.L	#2,TABXPOINT2		; Pointe auf das nächste Byte
	MOVE.L	TABXPOINT2(PC),A0	; Adresse im Long	TABXPOINT
								; wird in a0 kopiert
	CMP.L	#ENDETABX-2,A0		; Sind wir beim letzten Word der TAB?
	BNE.S	NOBSTART2			; noch nicht? Dann mach weiter.
	MOVE.L	#TABX-2,TABXPOINT2	; Starte wieder beim ersten Long
NOBSTART2:
	MOVE.w	(A0),d1
	add.w	#128,D1				; 128 - um den Sprite zu zentrieren.
	btst.l	#0,D1				; niederwertiges Bit der X-Koordinate =0?
	beq.s	NiederBitNull2
	bset.b	#0,bar2_b			; Setzen das niederwertige Bit der bar.
	bra.s	PlaceCoords2

NiederBitNull2:
	bclr.b	#0,bar2_b		; Löschen das niederwertige Bit der bar.
PlaceCoords2:
	lsr.w	#1,D1			; SHIFTEN, bewegen also alles um 1 Bit nach rechts.

	move.b	D1,bar2			; Geben den XX-Wert ind das Byte der Position
	rts

TABXPOINT:
	dc.l	TABX-2
	
TABXPOINT2:					; Der Pointer für die zweite Position ist anders
	dc.l	TABX+40-2
	
; Tabelle mit vorausberechneten X-Koordinaten des Sprite.

TABX:
	incbin	"/Sources/XCOORDINATOK.TAB"

ENDETABX:

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
	dc.w	$100,%0001001000000000	; Bit 12 an:1 Bitplane Lowres

BPLPOINTERS:
	dc.w	$e0,0,$e2,0		; erste Bitplane

	dc.w	$180,$000		; COLOR0	; schwarzer Hintergrund
	dc.w	$182,$123		; COLOR1	; COLOR1 des Bitplane, das in
							; diesem Fall leer ist, es wird
							; also nicht angezeigt.

	dc.w	$1A2,$FF0		; COLOR17, also COLOR1 des Sprite0 - GELB
	dc.w	$1A4,$a00		; COLOR18, also COLOR2 des Sprite0 - ROT
	dc.w	$1A6,$F70		; COLOR19, also COLOR3 des Sprite0 - ORANGE
	
	dc.w	$2c07,$fffe		; WAIT - Warte auf den oberen Rand

	dc.w	$140			; SPR0POS
	dc.b	0				; Vertikale Position (nicht verwenddet)
bar1:	dc.b	0			; Horizontale Position
	dc.w	$142			; SPR0CTL
	dc.b	0				; VSTOP (nicht verwendet)
bar1_b: dc.b	0			; vierte Kontrollbyte: es wird das Bit 0
							; verwendet, es ist das fehlende Bit der
							; horizontalen Position (niederwertigstes)

	dc.w	$146,$0e70		; SPR0DATB
	dc.w	$144,$03c0		; SPR0DATA - aktiviert Sprite

	dc.w	$148			; SPR1POS
	dc.b	0
bar2:	dc.b	0			; horizontale Position
	dc.w	$14a			; SPR1CTL
	dc.b	0
bar2_b: dc.b	0
	dc.w	$14e,$3e7c		; SPR1DATB
	dc.w	$14c,$0ff0		; SPR1DATA - aktiviert Sprite


	dc.w	$FFFF,$FFFE		; Ende der Copperlist



	SECTION LEERESPLANE,BSS_C	; Wir brauchen ein leeres Bitplane,
							; denn ohne Bitplanes können wir
							; keine Sprites anzeigen.

BITPLANE:
	ds.b	40*256			; leeres Bitplane Lowres

	end

Bemerkt,  daß bei den Kolonnen, da sie den ganzen Bildschirm ausfüllen, es
nicht notwendig ist, in das Register SPRxCTL zu schreiben, um  die  Sprite
zu deaktivieren.

Setzt  dieses  Stück  Copperlist  vor der Zeile "dc.w $FFFF,$FFFE" ein, um
einen Schuß Farbe ins Listing zu bringen (Amiga+b+c+i).

	dc.w	$5407,$fffe		; WAIT
	dc.w	$1A2,$FaF		; COLOR17	; Violett
	dc.w	$1A4,$703		; COLOR18
	dc.w	$1A6,$F0a		; COLOR19
	dc.w	$6807,$fffe		; WAIT
	dc.w	$1A2,$aFa		; COLOR17	; Grün
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$7c07,$fffe		; WAIT
	dc.w	$1A2,$0FF		; COLOR17	; Blau
	dc.w	$1A4,$00d		; COLOR18
	dc.w	$1A6,$07F		; COLOR19
	dc.w	$9007,$fffe		; WAIT
	dc.w	$1A2,$eee		; COLOR17	; Grau
	dc.w	$1A4,$444		; COLOR18
	dc.w	$1A6,$888		; COLOR19

