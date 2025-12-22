
; soc22l.s

; Beschreibung: hier wird vom Font die 1 Zeile (16Bit) (die Pixelspalte) 
; bitweise geprüft und dann wird das Bit in der Bitplane
; entsprechend gesetzt oder gelöscht
; nur debuggen - keine Anzeige

DISPLAY_DX=320
LINE_DX=15							; That's the number of lines of the line - 1 : LINE_DX=max (abs(15-0),abs(0,0))

start:
	move	#15,d7					; das zu bearbeitende Bit in dem Wort
	lea font16,a1					; Anfangsadresse des Fonts (vorher move.l)
	lea bitplane,a4					; Anfangsadresse der Bitplane

; CPU: draw the column bit after bit
; es wird eine Spalte bitweise gezeichnet (16Bit) 16 Zeilen
	
draw_column:	
	move.w (a1),d1					; vom Zeichen (font16), entsprechende Spalte (Word) einlesen 
	clr.w d2						; das zu testende Bit (wird von Bit0 nach Bit15 erhöht)
	moveq #LINE_DX,d5			    ; Schleifenzähler Anzahl der Zeilen -1 (also 16 Zeilen)
_columnLoop:
	move.w (a4),d3					; Wort aus der Bitplane holen
	btst d2,d1						; Bit testen (Bit0 ist rechts, Bit15 links)
	beq _pixelEmpty					; wenn 0 dann löschen
	bset d7,d3						; ansonsten setzen
	bra _pixelFilled				; wenn hier, überspringen
_pixelEmpty:
	bclr d7,d3						; löscht das Bit in dem Wort
_pixelFilled:
	move.w d3,(a4)					; Ergebniswort in Bitplane eintragen
	lea DISPLAY_DX>>3(a4),a4		; (320/8)(a4),a4 bedeutet 40(a4),a4 --> die neue Adresse in a4 ist 40 bytes weiter, also eine Zeile tiefer
	addq.b #1,d2					; das zu testende Bit erhöhen
	dbf d5,_columnLoop				; nächster Schleifendurchlauf

	nop
	rts

	
bitplane:
	blk.b 10240,$00
	
font16:
	dc.w $FFFF, $0000, $0000, $0000, $0000, $0000, $0000, $0000			; erstes Wort wurde angepasst normalerweise $0000
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

;------------------------------------------------------------------------------
>r
Filename:soc22l.s
>a
Pass1
Pass2
No Errors
>ad

Programmbeschreibung:

In d1 ist die aktuelle Spalte also der 16Bit Wert des Zeichens aus dem Font16.
Dann wird der Startwert in d2 zum Testen der Bits auf Bit 0 zurückgesetzt.
In einer Schleife über 16 Zeilen wird jetzt jeweils ein Word aus der
Bitebene geholt und nach Bearbeitung wird der neue Wert zurückgeschrieben.
Dann wird in der Schleife eine Zeile tiefer gegangen und der Vorgang 
wiederholt. 
Das Wort welches aus dem Speicher geholt wird, wird bitweise bearbeitet.
Zunächst wird das aktuelle Bit des 16Bit-Wertes des Zeichens kontrolliert
beginnend bei Bit0 und in der Schleife dann aufsteigend bis Bit15 und
dann das Bit15 (bzw. Wert in d7) in der Bitebene gesetzt oder gelöscht.

Es ist also eine 90° Linksdrehung.
1. Wort -> Bit15
2. Wort -> Bit14
15. Wort -> Bit0