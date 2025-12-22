
; Listing7y3.s	ZWEI VERWENDUNGEN EINES SPRITE AUF DER GLEICHEN ZEILE

;	Dieses Beispiel zeigt, wie es möglich ist, einen Sprite 2 Mal
;	auf der selben Zeile anzuzeigen, indem man direkt auf die Register
;	zugreift.

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
	btst	#6,$bfe001		; linke Maustaste gedrückt?
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

	dc.w	$1A2,$FF0		; COLOR17, also COLOR1 des Sprite0 - GELB
	dc.w	$1A4,$a00		; COLOR18, also COLOR2 des Sprite0 - ROT
	dc.w	$1A6,$F70		; COLOR19, also COLOR3 des Sprite0 - ORANGE

; ---> fügt hier das Stück Copperlist ein, das am Ende des Kommentars steht

	dc.w	$4007,$fffe		; Warte auf Zeile $40, horizontale Pos. 7
	dc.w	$140,$0060		; SPR0POS - horizontale Position
	dc.w	$142,$0000		; SPR0CTL
	dc.w	$146,$0e70		; SPR0DATB
	dc.w	$144,$03c0		; SPR0DATA - aktiviert den Sprite

	dc.w	$4087,$fffe		; Warte auf Zeile $40, horizontale Pos. 87
	dc.w	$140,$00a0		; SPR0POS - horizontale Position

; Das gleiche für Zeile $41

	dc.w	$4107,$fffe		; wait horiz. Position 07
	dc.w	$140,$0060		; spr0pos

	dc.w	$4187,$fffe		; wait horiz. Position 87
	dc.w	$140,$00a0		; spr0pos

; Das gleiche für Zeile $42

	dc.w	$4207,$fffe		; wait
	dc.w	$140,$0060		; spr0pos

	dc.w	$4287,$fffe		; wait... und so weiter
	dc.w	$140,$00a0

; Das gleiche für Zeile $43

	dc.w	$4307,$fffe
	dc.w	$140,$0060

	dc.w	$4387,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $44

	dc.w	$4407,$fffe
	dc.w	$140,$0060

	dc.w	$4487,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $45

	dc.w	$4507,$fffe
	dc.w	$140,$0060

	dc.w	$4587,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $46

	dc.w	$4607,$fffe
	dc.w	$140,$0060

	dc.w	$4687,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $47

	dc.w	$4707,$fffe
	dc.w	$140,$0060

	dc.w	$4787,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $48

	dc.w	$4807,$fffe
	dc.w	$140,$0060

	dc.w	$4887,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $49

	dc.w	$4907,$fffe
	dc.w	$140,$0060

	dc.w	$4987,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $4a

	dc.w	$4a07,$fffe
	dc.w	$140,$0060

	dc.w	$4a87,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $4b

	dc.w	$4b07,$fffe
	dc.w	$140,$0060

	dc.w	$4b87,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $4c

	dc.w	$4c07,$fffe
	dc.w	$140,$0060

	dc.w	$4c87,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $4d

	dc.w	$4d07,$fffe
	dc.w	$140,$0060

	dc.w	$4d87,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $4e

	dc.w	$4e07,$fffe
	dc.w	$140,$0060

	dc.w	$4e87,$fffe
	dc.w	$140,$00a0

; Das gleiche für Zeile $4f

	dc.w	$4f07,$fffe
	dc.w	$140,$0060

	dc.w	$4f87,$fffe
	dc.w	$140,$00a0

	dc.w	$5007,$fffe		; Warte auf Zeile $50
	dc.w	$142,$0000		; SPR0CTL - deaktiviert den Sprite

	dc.w	$FFFF,$FFFE		; Ende der Copperlist


	SECTION LEERESPLANE,BSS_C	; Wir brauchen ein leeres Bitplane,
							; denn ohne Bitplanes können wir
							; keine Sprites anzeigen.

BITPLANE:
	ds.b	40*256			; leeres Bitplane Lowres

	end

Direktes Manipulieren der Spriteregister macht es auch möglich, einen Sprite
zwei Mal suf der selben Zeile zu malen, ihn also auf verschiedenen horizontalen
Positionen zu setzen. Der Trick besteht in der Möglichkeit des Copper, eine
bestimmte Position am Bildschirm abzuwarten.  Am Anfang wartet man die erste
Zeile des Bildschirmes ab, an der der Sprite beginnen soll. Im Beispiel nehmen
wir Zeile $40, in der Copperlist:

	dc.w	$4007,$fffe		; Warte auf Zeile $40, horizontale Pos. 7

 Dann werden die Register SPR0CTL, SPRDATB und SPRDAT geladen:

	dc.w	$142,$0000		; SPR0CTL
	dc.w	$146,$0e70		; SPR0DATB
	dc.w	$144,$03c0		; SPR0DATA - aktiviert den Sprite

Dann gibt man den ersten Wert der horizontale Position des Sprite in SPRxPOS:

	dc.w	$140,$0060		; SPR0POS - horizontale Position

Nun wartet man, bis der Elektronenstrahl an dieser Position vorbeigegangen ist:

	dc.w	$4087,$fffe		; Warte auf Zeile $40, horizontale Pos. 87

Im Beispiel ist die horizontale Position des Sprite $60. Wenn wir also auf
Position $87 warten, dann sind wir sicher, daß der Sprite schon gezeichnet
wurde. Wenn der Elektronenstrahl diese Position überflogen hat, dann wurde
der Sprite auch gemalt.

Wenn das einmal vorbei ist, schreiben wir die zweite Position in das Regiter
SPRxPOS.

	dc.w	$140,$00a0		; SPR0POS - horizontale Position

Somit wird der Sprite nochmal auf der gleichen Zeile gezeichnet. Um nun auch
auf den folgenden Zeilen die Sprites zu verdoppeln, muß dieser Schritt nur
immer wiederholt werden. Für die Zeile $41 schreiben wir z.B.:

; Das gleiche für Zeile $41

	dc.w	$4107,$fffe
	dc.w	$140,$0060

	dc.w	$4187,$fffe
	dc.w	$140,$00a0

Es ist das Selbe wie bei Zeile $40, wir behalten die Register SPR0DATA,
SPR0DATB und SPR0CTL konstant, um auch die Form des Sprite konstant zu
halten. Wenn man möchte, kann man natürlich diese Werte verändern, und somit
auch das Aussehen des Sprite.

Um den Sprite zu deaktivieren muß einfach irgend etwas in das Register SPR0CLT
geschrieben werden, etwa so:

	dc.w	$5007,$fffe		; Warte auf Zeile $50
	dc.w	$142,$0000		; SPR0CTL - deaktiviert den Sprite

Wenn ihr wirklich übertreiben wollt, dann könnt ihr auch noch zwischen
einem Balken und dem anderen Palette ändern, um so auch noch eine
Wiederverwendung der Farben zu haben.
Versucht dieses Stück an dieser markierten Stelle einzufügen:

; ---> fügt hier das Stück Copperlist ein, das am Ende des Kommentars steht

Wir ersetzen das letzte Stück, das sich mit dem Anzeigen des Sprites befasst.
(Amiga+b+c+i, um ein Stück Text zu kopieren).

	dc.w	$4007,$fffe		; Warte auf Zeile $40, horizontale Pos. 7
	dc.w	$140,$0060		; SPR0POS - horizontale Position
	dc.w	$142,$0000		; SPR0CTL
	dc.w	$146,$0e70		; SPR0DATB
	dc.w	$144,$03c0		; SPR0DATA - aktiviert den Sprite

	dc.w	$4087,$fffe		; Warte auf Zeile $40, horizontale Pos. 87
	dc.w	$1A2,$aFa		; COLOR17	; Grünton
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$140,$00a0		; SPR0POS - horizontale Position

; Zeile $41
	dc.w	$4107,$fffe		; wait horiz. Position 07
	dc.w	$1A2,$FF0		; COLOR17	; Orange
	dc.w	$1A4,$a00		; COLOR18
	dc.w	$1A6,$F70		; COLOR19
	dc.w	$140,$0060		; spr0pos
	dc.w	$4187,$fffe		; wait horiz. Position 87
	dc.w	$1A2,$aFa		; COLOR17	; Grünton
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$140,$00a0		; spr0pos
; Zeile $42
	dc.w	$4207,$fffe		; wait horiz. Position 07
	dc.w	$1A2,$FF0		; COLOR17	; Orange
	dc.w	$1A4,$a00		; COLOR18
	dc.w	$1A6,$F70		; COLOR19
	dc.w	$140,$0060		; spr0pos
	dc.w	$4287,$fffe		; wait horiz. Position 87
	dc.w	$1A2,$aFa		; COLOR17	; Grünton
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$140,$00a0		; spr0pos
; Zeile $43
	dc.w	$4307,$fffe		; wait horiz. Position 07
	dc.w	$1A2,$FF0		; COLOR17	; Orange
	dc.w	$1A4,$a00		; COLOR18
	dc.w	$1A6,$F70		; COLOR19
	dc.w	$140,$0060		; spr0pos
	dc.w	$4387,$fffe		; wait horiz. Position 87
	dc.w	$1A2,$aFa		; COLOR17	; Grünton
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$140,$00a0		; spr0pos
; Zeile $44
	dc.w	$4407,$fffe		; wait horiz. Position 07
	dc.w	$1A2,$FF0		; COLOR17	; Orange
	dc.w	$1A4,$a00		; COLOR18
	dc.w	$1A6,$F70		; COLOR19
	dc.w	$140,$0060		; spr0pos
	dc.w	$4487,$fffe		; wait horiz. Position 87
	dc.w	$1A2,$aFa		; COLOR17	; Grünton
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$140,$00a0		; spr0pos
; Zeile $45
	dc.w	$4507,$fffe		; wait horiz. Position 07
	dc.w	$1A2,$FF0		; COLOR17	; Orange
	dc.w	$1A4,$a00		; COLOR18
	dc.w	$1A6,$F70		; COLOR19
	dc.w	$140,$0060		; spr0pos
	dc.w	$4587,$fffe		; wait horiz. Position 87
	dc.w	$1A2,$aFa		; COLOR17	; Grünton
	dc.w	$1A4,$050		; COLOR18
	dc.w	$1A6,$0a0		; COLOR19
	dc.w	$140,$00a0		; spr0pos

	dc.w	$4607,$fffe		; Warte auf Zeile $46
	dc.w	$142,$0000		; SPR0CTL - deaktiviert den Sprite
	dc.w	$FFFF,$FFFE		; Ende der Copperlist

