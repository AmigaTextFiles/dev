
; soc22l2.s
; druckt den Buchstaben G (H=40, G=39; ...)

DISPLAY_DX=320
LINE_DX=15							; That's the number of lines of the line - 1 : LINE_DX=max (abs(15-0),abs(0,0))
LINE_DY=15

	SECTION CiriCop,CODE

Anfang:
	move.l	4.w,a6					; Execbase
	jsr	-$78(a6)					; Disable
	lea	GfxName(PC),a1				; Libname
	jsr	-$198(a6)					; OpenLibrary
	move.l	d0,GfxBase
	move.l	d0,a6
	move.l	$26(a6),OldCop			; speichern die alte COP

;	Pointen auf das "leere" PIC
	MOVE.L	#BITPLANE,d0			; wohin pointen
	LEA	BPLPOINTERS,A1				; COP-Pointer
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	move.l	#COPPERLIST,$dff080		; unsere COP
	move.w	d0,$dff088				; START COP
	move.w	#0,$dff1fc				; NO AGA!
	move.w	#$c00,$dff106

mainloop:
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00010100,d0				; ; auf Ende des-Rasterdurchlaufs warten
	bne.s loop

	move	#40,d0					; H=40, G=39	
	bsr zeichen
	
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	mainloop	

;------------------------
; exit
	move.l	OldCop(PC),$dff080		; Pointen auf die SystemCOP
	move.w	d0,$dff088				; Starten die alte SystemCOP

	move.l	4.w,a6
	jsr	-$7e(a6)					; Enable
	move.l	GfxBase(PC),a1
	jsr	-$19e(a6)					; Closelibrary
	rts

;	Daten
GfxName:
	dc.b	"graphics.library",0,0
GfxBase:
	dc.l	0
OldCop:
	dc.l	0
	
	rts

zeichen:
	lsl.l #5,d0
	move d0,d6
	;move	#39*(32),d6				; Offset Zeichen im Font
	move	#15,d7
	lea font16,a1					; vorher move.l
	lea (a1,d6.w),a1				; Font + offset = das entsprechende Zeichen
	lea bitplane,a4	

	moveq #LINE_DY,d4				; über 16 Zeilen
; CPU: draw the column bit after bit
; es wird eine Spalte bitweise gezeichnet (16Bit) 16 Zeilen
_draw_column:	
	move.w (a1),d1					; vom Zeichen (font16), entsprechende Spalte (Word) einlesen 
	clr.w d2						; das zu testende Bit (wird von Bit0 nach Bit15 erhöht)
	moveq #LINE_DX,d5			    ; Schleifenzähler Anzahl der Zeilen -1 (also 16 Zeilen)
_columnLoop:
	move.w (a4),d3					; Wort in der Bitplane lesen
	btst d2,d1						; Bit testen (Bit0 ist rechts, Bit15 links 90° gedreht)
	beq _pixelEmpty					; wenn 0 dann löschen
	bset d7,d3						; ansonsten setzen
	bra _pixelFilled
_pixelEmpty:
	bclr d7,d3
_pixelFilled:
	move.w d3,(a4)					; Eregbniswort in Bitplane eintragen
	lea DISPLAY_DX>>3(a4),a4		; (320/8)(a4),a4 bedeutet 40(a4),a4 --> die neue Adresse in a4 ist 40 bytes weiter, also eine Zeile tiefer
	addq.b #1,d2					; das zu testente Bit erhöhen
	dbf d5,_columnLoop				; nächster Schleifendurchlauf
; nachdem 1 Spalte fertig ist
;----------------------------
; CPU : it requires the number of the pixel in the word of the screen
	subq.b #1,d7					; von links nach rechts Bit15 bis Bit0
	bge _pixelKeepWord
	addq.w #2,d6
	moveq #15,d7
_pixelKeepWord:
	lea bitplane,a4					; zurücksetzen
	lea 2(a1),a1					; nächste Zeile	(bzw. nächstes Word vom Font)
	dbf d4,_draw_column				; nächster Schleifendurchlauf
	
	rts
	

	SECTION GRAPHIC,DATA_C

COPPERLIST:
	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0 ; SPRITE
	dc.w	$12a,0,$12c,0,$12e,0,$130,0,$132,0
	dc.w	$134,0,$136,0,$138,0,$13a,0,$13c,0
	dc.w	$13e,0

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$38		; DdfStart
	dc.w	$94,$d0		; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,0		; BplCon2
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod

				; 5432109876543210
	dc.w	$100,%0001001000000000  ; Bit 12 an!! 1 Bitplane Lowres	

BPLPOINTERS:
	dc.w	$e0,0,$e2,0	; erste Bitplane

	dc.w	$180,$000	; Color0	; Hintergrund Schwarz
	dc.w	$182,$0F0	; Color1	; Farbe 1 der Bitplane

	dc.w	$ffff,$fffe	; Ende der Copperlist


bitplane:
	blk.b 10240,$00

font16:
	dc.w $FFFF, $FFFF, $0000, $0000, $FFFF, $FFFF, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $33FF, $33FF, $33FF, $33FF
	dc.w $33FF, $33FF, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $0C30, $0C30, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $0C30, $0C30, $FFFC, $FFFC, $FFFC, $FFFC, $0C30, $0C30
	dc.w $0C30, $0C30, $0CCC, $0CCC, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $3FFF, $3FFF, $0CCC, $0CCC, $0300, $0300, $0000, $0000
	dc.w $3C3F, $3C3F, $3F3F, $3F3F, $3F00, $3F00, $03C0, $03C0
	dc.w $00FC, $00FC, $FCFC, $FCFC, $FC3C, $FC3C, $0000, $0000
	dc.w $0F30, $0F30, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $0FFC, $0FFC, $FF30, $FF30, $FCC0, $FCC0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $00CF, $00CF, $00FF, $00FF
	dc.w $003F, $003F, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0FF0, $0FF0
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C, $0000, $0000
	dc.w $300C, $300C, $3FFC, $3FFC, $3FFC, $3FFC, $0FF0, $0FF0
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0300, $0300, $3330, $3330, $3FF0, $3FF0, $0FC0, $0FC0
	dc.w $3FF0, $3FF0, $3330, $3330, $0300, $0300, $0000, $0000
	dc.w $0300, $0300, $0300, $0300, $3FF0, $3FF0, $3FF0, $3FF0
	dc.w $3FF0, $3FF0, $0300, $0300, $0300, $0300, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $CC00, $CC00, $FC00, $FC00
	dc.w $3C00, $3C00, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0300, $0300, $0300, $0300, $0300, $0300, $0300, $0300
	dc.w $0300, $0300, $0300, $0300, $0300, $0300, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3C00, $3C00, $3C00, $3C00
	dc.w $3C00, $3C00, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $FC00, $FC00, $FF00, $FF00, $FF00, $FF00, $03C0, $03C0
	dc.w $00FF, $00FF, $00FF, $00FF, $003F, $003F, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $330C, $330C
	dc.w $30CC, $30CC, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $300C, $300C, $300C, $300C, $3FFC, $3FFC, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $3000, $3000, $3000, $3000, $0000, $0000
	dc.w $3F00, $3F00, $3FCC, $3FCC, $3FCC, $3FCC, $30CC, $30CC
	dc.w $30FC, $30FC, $3CFC, $3CFC, $3C30, $3C30, $0000, $0000
	dc.w $3C3C, $3C3C, $3C3C, $3C3C, $30CC, $30CC, $30CC, $30CC
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $0F30, $0F30, $0000, $0000
	dc.w $0C00, $0C00, $0F00, $0F00, $0FC0, $0FC0, $0CF0, $0CF0
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $0000, $0000
	dc.w $3CFC, $3CFC, $3CFC, $3CFC, $30FC, $30FC, $30CC, $30CC
	dc.w $3FCC, $3FCC, $3FCC, $3FCC, $0F00, $0F00, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3FCC, $3FCC, $0F00, $0F00, $0000, $0000
	dc.w $003C, $003C, $003C, $003C, $FF0C, $FF0C, $FFCC, $FFCC
	dc.w $FFFC, $FFFC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $0F30, $0F30, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3FFC, $3FFC, $0F30, $0F30, $0000, $0000
	dc.w $00F0, $00F0, $33FC, $33FC, $330C, $330C, $330C, $330C
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3CF0, $3CF0, $3CF0, $3CF0
	dc.w $3CF0, $3CF0, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $CCF0, $CCF0, $FCF0, $FCF0
	dc.w $3CF0, $3CF0, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $00C0, $00C0, $03F0, $03F0, $0FFC, $0FFC
	dc.w $3F3F, $3F3F, $3C0F, $3C0F, $3003, $3003, $0000, $0000
	dc.w $0000, $0000, $0CC0, $0CC0, $0CC0, $0CC0, $0CC0, $0CC0
	dc.w $0CC0, $0CC0, $0CC0, $0CC0, $0CC0, $0CC0, $0000, $0000
	dc.w $0000, $0000, $C00C, $C00C, $F03C, $F03C, $FCFC, $FCFC
	dc.w $3FF0, $3FF0, $0FC0, $0FC0, $0300, $0300, $0000, $0000
	dc.w $0030, $0030, $003C, $003C, $330C, $330C, $330C, $330C
	dc.w $33FC, $33FC, $03FC, $03FC, $00F0, $00F0, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $300C, $300C, $33FC, $33FC
	dc.w $33FC, $33FC, $33FC, $33FC, $03F0, $03F0, $0000, $0000
	dc.w $3FF0, $3FF0, $3FFC, $3FFC, $3FFC, $3FFC, $030C, $030C
	dc.w $030C, $030C, $FFFC, $FFFC, $FFF0, $FFF0, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3FFC, $3FFC, $0F30, $0F30, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $300C, $300C, $3C3C, $3C3C, $3C3C, $3C3C, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $300C, $300C, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC
	dc.w $30CC, $30CC, $3C3C, $3C3C, $3C3C, $3C3C, $0000, $0000
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $00CC, $00CC
	dc.w $00CC, $00CC, $003C, $003C, $003C, $003C, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $30CC, $30CC, $3FCC, $3FCC, $3FC0, $3FC0, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $00C0, $00C0
	dc.w $00C0, $00C0, $FFFC, $FFFC, $FFFC, $FFFC, $0000, $0000
	dc.w $300C, $300C, $300C, $300C, $3FFC, $3FFC, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $300C, $300C, $300C, $300C, $0000, $0000
	dc.w $0C00, $0C00, $3C00, $3C00, $3000, $3000, $3000, $3000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $0FFF, $0FFF, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $03F0, $03F0
	dc.w $0FFC, $0FFC, $FF3C, $FF3C, $FC0C, $FC0C, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3000, $3000
	dc.w $3000, $3000, $3C00, $3C00, $3C00, $3C00, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FF0, $3FF0, $03C0, $03C0
	dc.w $00F0, $00F0, $FFFC, $FFFC, $FFFC, $FFFC, $0000, $0000
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFF0, $FFF0, $03C0, $03C0
	dc.w $0F00, $0F00, $3FFF, $3FFF, $3FFF, $3FFF, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $300C, $300C
	dc.w $300C, $300C, $3FFC, $3FFC, $0FF0, $0FF0, $0000, $0000
	dc.w $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $FFFC, $030C, $030C
	dc.w $030C, $030C, $03FC, $03FC, $00F0, $00F0, $0000, $0000
	dc.w $0FF0, $0FF0, $3FFC, $3FFC, $3FFC, $3FFC, $330C, $330C
	dc.w $0F0C, $0F0C, $FCFC, $FCFC, $F3F0, $F3F0, $0000, $0000
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $030C, $030C
	dc.w $030C, $030C, $FFFC, $FFFC, $FCF0, $FCF0, $0000, $0000
	dc.w $3C00, $3C00, $3C30, $3C30, $30FC, $30FC, $30FC, $30FC
	dc.w $3FCC, $3FCC, $3FCC, $3FCC, $0F00, $0F00, $0000, $0000
	dc.w $000C, $000C, $000C, $000C, $FFFC, $FFFC, $FFFC, $FFFC
	dc.w $FFFC, $FFFC, $000C, $000C, $000C, $000C, $0000, $0000
	dc.w $0FFF, $0FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3000, $3000
	dc.w $3000, $3000, $3FFC, $3FFC, $0FFC, $0FFC, $0000, $0000
	dc.w $00FF, $00FF, $03FF, $03FF, $0FFF, $0FFF, $3C00, $3C00
	dc.w $0F00, $0F00, $03FC, $03FC, $00FC, $00FC, $0000, $0000
	dc.w $0FFF, $0FFF, $3FFF, $3FFF, $0FFF, $0FFF, $03C0, $03C0
	dc.w $0F00, $0F00, $3FFC, $3FFC, $0FFC, $0FFC, $0000, $0000
	dc.w $3C0F, $3C0F, $3F3F, $3F3F, $3FFC, $3FFC, $03F0, $03F0
	dc.w $03FC, $03FC, $FF3C, $FF3C, $FC0C, $FC0C, $0000, $0000
	dc.w $003F, $003F, $00FF, $00FF, $FFFF, $FFFF, $FFC0, $FFC0
	dc.w $FFC0, $FFC0, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $3C3C, $3C3C, $3F3C, $3F3C, $3F0C, $3F0C, $33CC, $33CC
	dc.w $30FC, $30FC, $3CFC, $3CFC, $3C3C, $3C3C, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3FFC, $3FFC, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $300C, $300C, $300C, $300C, $0000, $0000
	dc.w $0000, $0000, $003F, $003F, $00FF, $00FF, $00FF, $00FF
	dc.w $03C0, $03C0, $FF00, $FF00, $FF00, $FF00, $FC00, $FC00
	dc.w $0000, $0000, $300C, $300C, $300C, $300C, $3FFC, $3FFC
	dc.w $3FFC, $3FFC, $3FFC, $3FFC, $0000, $0000, $0000, $0000
	dc.w $00C0, $00C0, $0030, $0030, $FFFC, $FFFC, $FFFF, $FFFF
	dc.w $FFFC, $FFFC, $0030, $0030, $00C0, $00C0, $0000, $0000
	dc.w $F000, $F000, $F000, $F000, $F000, $F000, $F000, $F000
	dc.w $F000, $F000, $F000, $F000, $F000, $F000, $F000, $F000
	dc.w $0000, $0000, $0000, $0000, $000F, $000F, $003F, $003F
	dc.w $0033, $0033, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $3FC0, $3FC0, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $0F00, $0F00, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $30C0, $30C0, $30C0, $30C0, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FFF, $3FFF, $3FFF, $3FFF, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $3CC0, $3CC0, $3FC0, $3FC0, $33C0, $33C0, $0000, $0000
	dc.w $0000, $0000, $00C0, $00C0, $FFF0, $FFF0, $FFFC, $FFFC
	dc.w $FFFC, $FFFC, $00CC, $00CC, $000C, $000C, $0000, $0000
	dc.w $0300, $0300, $0FC0, $0FC0, $CFC0, $CFC0, $CCC0, $CCC0
	dc.w $CCC0, $CCC0, $FFC0, $FFC0, $3FC0, $3FC0, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $00C0, $00C0
	dc.w $00C0, $00C0, $3FC0, $3FC0, $3F00, $3F00, $0000, $0000
	dc.w $0000, $0000, $30C0, $30C0, $3FCC, $3FCC, $3FCC, $3FCC
	dc.w $3FCC, $3FCC, $3000, $3000, $0000, $0000, $0000, $0000
	dc.w $3000, $3000, $F000, $F000, $C000, $C000, $C0C0, $C0C0
	dc.w $FFCC, $FFCC, $FFCC, $FFCC, $3FCC, $3FCC, $0000, $0000
	dc.w $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $0300, $0300
	dc.w $0FC0, $0FC0, $FFC0, $FFC0, $FCC0, $FCC0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $3FFF, $3FFF, $3000, $3000, $0000, $0000, $0000, $0000
	dc.w $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $0F00, $0F00
	dc.w $03C0, $03C0, $3FC0, $3FC0, $3F00, $3F00, $0000, $0000
	dc.w $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3FC0, $00C0, $00C0
	dc.w $00C0, $00C0, $3FC0, $3FC0, $3F00, $3F00, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $3FC0, $3FC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $0F00, $0F00, $0000, $0000
	dc.w $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $30C0, $30C0
	dc.w $30C0, $30C0, $3FC0, $3FC0, $0F00, $0F00, $0000, $0000
	dc.w $0F00, $0F00, $3FC0, $3FC0, $30C0, $30C0, $30C0, $30C0
	dc.w $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $FFC0, $0000, $0000
	dc.w $3FC0, $3FC0, $3FC0, $3FC0, $3F00, $3F00, $03C0, $03C0
	dc.w $00C0, $00C0, $03C0, $03C0, $03C0, $03C0, $0000, $0000
	dc.w $3000, $3000, $3300, $3300, $33C0, $33C0, $3FC0, $3FC0
	dc.w $3FC0, $3FC0, $3CC0, $3CC0, $0CC0, $0CC0, $0000, $0000
	dc.w $0000, $0000, $0030, $0030, $0FFF, $0FFF, $3FFF, $3FFF
	dc.w $3FFF, $3FFF, $3030, $3030, $3000, $3000, $0000, $0000
	dc.w $0FC0, $0FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3000, $3000
	dc.w $3000, $3000, $3FC0, $3FC0, $3FC0, $3FC0, $0000, $0000
	dc.w $03C0, $03C0, $0FC0, $0FC0, $3FC0, $3FC0, $3C00, $3C00
	dc.w $3C00, $3C00, $0FC0, $0FC0, $03C0, $03C0, $0000, $0000
	dc.w $0FC0, $0FC0, $3FC0, $3FC0, $3FC0, $3FC0, $3C00, $3C00
	dc.w $0F00, $0F00, $3FC0, $3FC0, $0FC0, $0FC0, $0000, $0000
	dc.w $30C0, $30C0, $3FC0, $3FC0, $3FC0, $3FC0, $0F00, $0F00
	dc.w $0F00, $0F00, $3FC0, $3FC0, $30C0, $30C0, $0000, $0000
	dc.w $03C0, $03C0, $CFC0, $CFC0, $CC00, $CC00, $CC00, $CC00
	dc.w $FFC0, $FFC0, $FFC0, $FFC0, $3FC0, $3FC0, $0000, $0000
	dc.w $30C0, $30C0, $3CC0, $3CC0, $3FC0, $3FC0, $3FC0, $3FC0
	dc.w $3FC0, $3FC0, $33C0, $33C0, $30C0, $30C0, $0000, $0000
	dc.w $0000, $0000, $00C0, $00C0, $0FFC, $0FFC, $3FFF, $3FFF
	dc.w $3F3F, $3F3F, $3003, $3003, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $C00C, $C00C, $FCFC, $FCFC
	dc.w $FFFC, $FFFC, $3FF0, $3FF0, $0300, $0300, $0000, $0000
	dc.w $0000, $0000, $FCFF, $FCFF, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $0FC0, $0FC0
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

	end



