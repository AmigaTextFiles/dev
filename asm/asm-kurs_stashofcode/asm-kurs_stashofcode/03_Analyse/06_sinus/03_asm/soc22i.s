
; soc22i.s
; die Adresse der aktuellen Spalte des aktuellen Buchstabens (Zeichens) ermitteln
; aus dem anzuzeigenden Text und dem Schriftsatz (Font16) (und entschlüsseln)

TEXT_XOR=$3B

; Get the address of the current character and its current column

start:
	move.w scrollChar,d0		; Zählerstand zu Beginn 0 - mit erstem Charakter anfangen
	lea text,a0					; Beginn Text
	lea (a0,d0.w),a0			; Zeichen im Text anpointen
	clr.w d1
	move.b (a0)+,d1				; das anzuzeigende Zeichen
	eor.b #TEXT_XOR,d1			; verschlüsselten Text entschlüsseln
	subi.b #$20,d1				; Offset zum vorhanden Font abziehen um echtes ASCII Zeichen zu haben
	lsl.w #5,d1					; 32 bytes pro Zeichen in 16x16 Anordnung, d.h. 16Zeilen * 2 Wörter
	
	move.w scrollColumn,d4		; Spalte Zähler	
	move.w d4,d2				; Spalte des Zeichens welches angezeigt werden soll ; aktuelle Spalte wird später noch gebraucht
	lsl.w #1,d2					; *2, da 2 bytes pro Zeile im 16x16 font
	add.w d2,d1					; entspricht Spalte im Charakter
	;move.l font16,a1
	lea font16,a1				; Anfangsadresse font16
	lea (a1,d1.w),a1			; address of the current column in the bitmap of the character to display
		
	rts

scrollChar:				DC.W 0
scrollColumn:			DC.W 0


text:							; the same text
	dc.w $621B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B			; erste Zeichen ersetzt anstatt $1B1B
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B62, $697A, $7C7A, $7E77
	dc.w $1B59, $4952, $555C, $411B, $425A, $1B5A, $1B54, $555E
	dc.w $1B4B, $5243, $5E57, $1B48, $5255, $5E1B, $4858, $4954
	dc.w $5757, $1A1B, $6854, $4949, $4217, $1B55, $541B, $0A0D
	dc.w $430A, $0D1B, $5D54, $554F, $1B5A, $4D5A, $5257, $5A59
	dc.w $575E, $151B, $721B, $535A, $5F1B, $4F54, $1B48, $4F49
	dc.w $5E4F, $5853, $1B5A, $1B03, $4303, $1B54, $555E, $171B
	dc.w $535E, $5558, $5E1B, $524F, $481B, $4B52, $435E, $575E
	dc.w $5F1B, $5754, $5450, $1515, $151B, $7C49, $5E5E, $4F52
	dc.w $555C, $481B, $5D54, $5757, $544C, $1515, $151B, $1B15
	dc.w $5474, $5415, $1B1B, $686F, $7469, $766F, $6974, $746B
	dc.w $7E69, $011B, $7354, $4C1B, $5248, $1B6B, $5A55, $415E
	dc.w $491B, $7957, $524F, $411B, $5C54, $5255, $5C04, $1B78
	dc.w $5A55, $1C4F, $1B4C, $5A52, $4F1B, $4F54, $1B4B, $575A
	dc.w $421B, $4F53, $5E1B, $5C5A, $565E, $1A1B, $1B15, $5474
	dc.w $5415, $1B1B, $7F7A, $6970, $1B7E, $756F, $6972, $7E68
	dc.w $011B, $7F54, $1B42, $544E, $1B48, $4F52, $5757, $1B54
	dc.w $4C55, $1B42, $544E, $491B, $7A56, $525C, $5A1B, $0A0B
	dc.w $0B0B, $041B, $7754, $5450, $1B4E, $555F, $5E49, $4852
	dc.w $5F5E, $1B4F, $535E, $1B57, $525F, $011B, $4F53, $5E49
	dc.w $5E1B, $565A, $421B, $595E, $1B4D, $5A57, $4E5A, $5957
	dc.w $5E1B, $4852, $5C55, $5A4F, $4E49, $5E48, $1A1B, $1B15
	dc.w $5474, $5415, $1B1B, $716E, $7570, $727E, $011B, $7552
	dc.w $585E, $1B4F, $5E5A, $561B, $4C54, $4950, $1B5F, $5E58
	dc.w $545F, $5255, $5C1B, $4F53, $5E1B, $7A7C, $7A1B, $495E
	dc.w $5C52, $484F, $5E49, $481A, $1B6F, $5354, $485E, $1B5C
	dc.w $4E42, $481B, $5A4F, $1B78, $5456, $5654, $5F54, $495E
	dc.w $1B49, $5E5A, $5757, $421B, $595E, $5752, $5E4D, $5E5F
	dc.w $1B55, $5459, $545F, $421B, $4C54, $4E57, $5F1B, $4F49
	dc.w $421B, $4F54, $1B56, $5E4F, $5A57, $1B59, $5A48, $531B
	dc.w $4F53, $5E1B, $5853, $524B, $485E, $4F04, $1B1B, $1554
	dc.w $7454, $151B, $1B78, $7469, $7E75, $6F72, $7501, $1B69
	dc.w $5E56, $5E56, $595E, $4952, $555C, $1B4F, $535E, $1B5D
	dc.w $5249, $484F, $1B4F, $5256, $5E1B, $721B, $485A, $4C1B
	dc.w $5A55, $1B7A, $5652, $5C5A, $1B5C, $5A56, $5E15, $1515
	dc.w $1B72, $4F1B, $4C5A, $481B, $7459, $5752, $4F5E, $495A
	dc.w $4F54, $491B, $494E, $5555, $5255, $5C1B, $5455, $1B42
	dc.w $544E, $4948, $1A1B, $1B15, $5474, $5415, $1B1B, $737E
	dc.w $7A7F, $736E, $756F, $7E69, $011B, $6F53, $5A55, $431B
	dc.w $5A5C, $5A52, $551B, $5D54, $491B, $4F53, $5E1B, $5F52
	dc.w $485A, $5957, $5E5F, $1B5A, $5858, $5E48, $481A, $1B78
	dc.w $5455, $5F5E, $5655, $5E5F, $1B78, $5E57, $5704, $1B79
	dc.w $5E48, $4F1B, $5C5E, $4956, $5A55, $1B79, $7968, $1B5E
	dc.w $4D5E, $491A, $1B1B, $1554, $7454, $151B, $1B76, $7475
	dc.w $6F62, $011B, $6854, $1B5C, $495E, $5A4F, $1B4F, $4E55
	dc.w $5E48, $1B5D, $5449, $1B4F, $535E, $1B58, $495A, $5850
	dc.w $4F49, $5448, $1A1B, $6C53, $5A4F, $1B5A, $1B4F, $5E5A
	dc.w $561B, $4C5E, $1B56, $5A5F, $5E1A, $1B1B, $1554, $7454
	dc.w $151B, $1B73, $7E7A, $6F73, $7E75, $011B, $7754, $5450
	dc.w $1B5A, $4F1B, $4254, $4E1A, $1B6C, $535A, $4F1B, $5A1B
	dc.w $4B5A, $5255, $4F59, $5A57, $571B, $5853, $5A56, $4B52
	dc.w $5455, $1A1B, $1B15, $5474, $5415, $1B1B, $767A, $6372
	dc.w $7672, $7772, $7E75, $011B, $721B, $5F54, $4E59, $4F1B
	dc.w $4254, $4E1B, $4C52, $5757, $1B49, $5E5A, $5F1B, $4F53
	dc.w $5248, $1B54, $555E, $171B, $594E, $4F1B, $4C53, $5A4F
	dc.w $5E4D, $5E49, $1515, $151B, $724F, $1B4C, $5A48, $1B5D
	dc.w $4E55, $1B4F, $541B, $5854, $5F5E, $1B4F, $5354, $485E
	dc.w $1B58, $495A, $5850, $4F49, $5448, $1A1B, $1B15, $5474
	dc.w $5415, $1B1B, $6F69, $7268, $6F7A, $7501, $1B62, $544E
	dc.w $1B4C, $5E49, $5E1B, $4952, $5C53, $4F01, $1B7A, $7674
	dc.w $681B, $5248, $1B77, $7A76, $7468, $1A1B, $7A68, $761B
	dc.w $494E, $575E, $411A, $1B1B, $1554, $7454, $151B, $1B7D
	dc.w $7269, $7E78, $697A, $7870, $7E69, $011B, $7352, $171B
	dc.w $565A, $551A, $1B73, $544B, $5E1B, $4254, $4E1C, $495E
	dc.w $1B55, $544F, $1B59, $5449, $5255, $5C1B, $4F54, $1B5F
	dc.w $5E5A, $4F53, $1B52, $551B, $4254, $4E49, $1B59, $5A55
	dc.w $501A, $1B1B, $1554, $7454, $151B, $1B3B, $0000		
	EVEN


font16:
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000	; Zeichen 1
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $33FF, $33FF, $33FF, $33FF ; Zeichen 2
	dc.w $33FF, $33FF, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000 ; Zeichen 3
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $0C30, $0C30, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF ; Zeichen 4
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
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $0000, $0000, $0000, $0000, $0000, $0000, $FFFF, $FFFF
	dc.w $FFFF, $FFFF, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF
	dc.w $0000, $0000, $FFFC, $FFFC, $FFFC, $FFFC, $FFC3, $FFC3
	dc.w $3FF3, $3FF3, $F300, $F300, $FCCF, $FCCF, $C033, $C033
	dc.w $0000, $0000, $3FFC, $3FFC, $0000, $0000, $CFCF, $CFCF
	dc.w $CC3F, $CC3F, $0F00, $0F00, $C0C3, $C0C3, $F33F, $F33F
	dc.w $0000, $0000, $FCCF, $FCCF, $0000, $0000, $FFFC, $FFFC
	dc.w $C3FC, $C3FC, $FC00, $FC00, $C3FF, $C3FF, $3330, $3330
	dc.w $0000, $0000, $CFFC, $CFFC, $0000, $0000, $3F33, $3F33
	dc.w $F30F, $F30F, $0F00, $0F00, $3FFF, $3FFF, $3CCF, $3CCF
	dc.w $0000, $0000, $FF3F, $FF3F, $0000, $0000, $CCFF, $CCFF
	dc.w $3FF0, $3FF0, $C03C, $C03C, $00F3, $00F3, $30CC, $30CC
	dc.w $0000, $0000, $FF0F, $FF0F, $0300, $0300, $0CFF, $0CFF
	dc.w $F3F0, $F3F0, $0C0F, $0C0F, $00FF, $00FF, $F0CF, $F0CF
	dc.w $0000, $0000, $03C3, $03C3, $0000, $0000, $0FFC, $0FFC
	dc.w $FC30, $FC30, $C3CC, $C3CC, $3C3F, $3C3F, $CCFC, $CCFC
	dc.w $0000, $0000, $FF03, $FF03, $0000, $0000, $3FC0, $3FC0
	dc.w $C3FC, $C3FC, $FF30, $FF30, $C0CF, $C0CF, $F3F3, $F3F3
	dc.w $0000, $0000, $FFFC, $FFFC, $0000, $0000, $FFCF, $FFCF
	dc.w $F0FF, $F0FF, $0C30, $0C30, $3FCF, $3FCF, $CC33, $CC33
	dc.w $0000, $0000, $F30F, $F30F, $0300, $0300, $FFFF, $FFFF
	dc.w $CCCC, $CCCC, $003F, $003F, $FFCF, $FFCF, $3CF3, $3CF3
	dc.w $0000, $0000, $FCF3, $FCF3, $0000, $0000, $03CF, $03CF
	dc.w $FF3F, $FF3F, $30F3, $30F3, $333F, $333F, $F33F, $F33F
	dc.w $0000, $0000, $0CFF, $0CFF, $0000, $0000, $3FF3, $3FF3
	dc.w $3F3F, $3F3F, $000F, $000F, $FFCF, $FFCF, $F3CC, $F3CC
	dc.w $0000, $0000, $0FC3, $0FC3, $0000, $0000, $FFF0, $FFF0
	dc.w $CC30, $CC30, $3FC0, $3FC0, $FC3F, $FC3F, $F33F, $F33F
	dc.w $0000, $0000, $F3FF, $F3FF, $0000, $0000, $3FFF, $3FFF
	dc.w $CFCC, $CFCC, $C33C, $C33C, $FF0F, $FF0F, $CC33, $CC33
	dc.w $0000, $0000, $FFF3, $FFF3, $0000, $0000, $FCCC, $FCCC
	dc.w $CC3F, $CC3F, $FC00, $FC00, $FFFC, $FFFC, $333C, $333C
	dc.w $0000, $0000, $0FF3, $0FF3, $0000, $0000, $FFFF, $FFFF
	dc.w $000F, $000F, $F3F3, $F3F3, $003F, $003F, $F03F, $F03F
	dc.w $0000, $0000, $FFF0, $FFF0, $0030, $0030, $CF3F, $CF3F
	dc.w $3FFC, $3FFC, $3F33, $3F33, $FF0C, $FF0C, $30CF, $30CF
	dc.w $0000, $0000, $FF3F, $FF3F, $0000, $0000, $FFCF, $FFCF
	dc.w $03FC, $03FC, $FF0F, $FF0F, $F0C0, $F0C0, $F3C3, $F3C3
	dc.w $0000, $0000, $000F, $000F, $0000, $0000, $FFF3, $FFF3
	dc.w $3C0C, $3C0C, $C3FF, $C3FF, $3C00, $3C00, $FFF0, $FFF0
	dc.w $0000, $0000, $F03F, $F03F, $F00C, $F00C, $0FFF, $0FFF
	dc.w $FF00, $FF00, $C0FF, $C0FF, $CF00, $CF00, $CFC0, $CFC0
	dc.w $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF, $3C33, $3C33
	dc.w $C3CC, $C3CC, $3CF3, $3CF3, $C0F0, $C0F0, $C3CC, $C3CC
	dc.w $0000, $0000, $3F0F, $3F0F, $030F, $030F, $CFC3, $CFC3
	dc.w $F0CF, $F0CF, $3C03, $3C03, $C3C3, $C3C3, $C3FC, $C3FC
	dc.w $0000, $0000, $FFCF, $FFCF, $00C0, $00C0, $CF33, $CF33
	dc.w $C3FC, $C3FC, $CC00, $CC00, $C3F3, $C3F3, $3CF0, $3CF0
	dc.w $0000, $0000, $3FF3, $3FF3, $0030, $0030, $C3FC, $C3FC
	dc.w $CC3F, $CC3F, $0CC0, $0CC0, $CFCC, $CFCC, $FCFF, $FCFF
	dc.w $0000, $0000, $C3FF, $C3FF, $C000, $C000, $F3FF, $F3FF
	dc.w $F303, $F303, $0FCF, $0FCF, $3030, $3030, $30C0, $30C0
	dc.w $0000, $0000, $FCCF, $FCCF, $0000, $0000, $F33F, $F33F
	dc.w $3FF3, $3FF3, $0CFC, $0CFC, $F3C3, $F3C3, $03CC, $03CC
	dc.w $0000, $0000, $FCF3, $FCF3, $0000, $0000, $F3CC, $F3CC
	dc.w $CF3F, $CF3F, $30F3, $30F3, $FF3F, $FF3F, $3F3F, $3F3F
	dc.w $0000, $0000, $F3F3, $F3F3, $0000, $0000, $FFCC, $FFCC
	dc.w $FF3C, $FF3C, $3330, $3330, $CFFF, $CFFF, $0CFC, $0CFC
	dc.w $0000, $0000, $F00F, $F00F, $C000, $C000, $FFFF, $FFFF
	dc.w $03FC, $03FC, $FC0F, $FC0F, $03FF, $03FF, $0FC0, $0FC0
	
