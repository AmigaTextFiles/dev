
; soc22m.s
; Zur ersten Spalte eines neuen Zeichens oder zur nächsten des gleichen Zeichens gehen

TEXT_XOR=$3B

start:
	bra da_weiter				; folgenden Teil überspringen

	move.w scrollChar,d0		; Zählerstand zu Beginn 0 - mit ersten Zeichen anfangen
	lea text,a0					; Beginn Text
	lea (a0,d0.w),a0			; Zeichen im Text anpointen
	clr.w d1
	move.b (a0)+,d1				; characted to display
	eor.b #TEXT_XOR,d1			; wieder in Ascii umwandeln
	subi.b #$20,d1				; Offset im vorhanden Font abziehen um echtes ASCII Zeichen zu haben
	lsl.w #5,d1					; 32 bytes per character in the 16x16 police
	
	move.w scrollColumn,d4		; Spalte Zähler	
	move.w d4,d2				; column of pixels of the character to display		; aktuelle Spalte wird später noch gebraucht
	lsl.w #1,d2					; 2 bytes per line in the 16x16 font
	add.w d2,d1					; entspricht Spalte im Charakter
	;move.l font16,a1
	lea font16,a1
	lea (a1,d1.w),a1			; address of the current column in the bitmap of the character to display



da_weiter:
	move.w scrollColumn,d4		; Spalte Zähler		; von Charakter zu Zeichnen

; Move to the next column of the character (current, next or first)
next_column:
	addq.b #1,d4				; nächste Spalte
	btst #4,d4					; wenn Bit 4=1 ist wird Z=0 aufgrund 1-1
	beq _writeKeepChar			; bei Z=1 wird dorthin gesprungen (gleiches Charakter nur eine Spalte weiter = 2 Bytes weiter)
	bclr #4,d4					; ansonsten Zähler zurücksetzen = Spalte 1
; index the current column of pixels of the current character
	clr.w d1
	move.b (a0)+,d1				; characted to display	; aktuelles Zeichen aus Text (1 byte) holen
	eor.b #TEXT_XOR,d1			; Zeichen entschlüsseln
	bne _writeNoTextLoop		; bei $3B ist Ergebnis 0
	lea text,a0					; ansonsten, wenn wir am Ende des Textes sind, wieder von vorn
	move.b (a0)+,d1				; characted to display
	eor.b #TEXT_XOR,d1			; Zeichen entschlüsseln
_writeNoTextLoop
	subi.b #$20,d1				; das wahre Ascii-Zeichen
	lsl.w #5,d1					; 32 bytes per character in the 16x16 police
	;move.l font16,a1
	lea font16,a1				; im Font 16x16 das erste Zeichen
	lea (a1,d1.w),a1			; address of the current column in the bitmap of the character to display
	bra _writeKeepColumn		; überspringen
_writeKeepChar:
	lea 2(a1),a1				; gleiche Charakter 2Bytes weiter (16x16 Pixel)
_writeKeepColumn:


	rts

scrollChar:				DC.W 0
scrollColumn:			DC.W 0

text:					DC.B $3b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $1b, $62, $69, $7a, $7c, $7a, $7e, $77, $1b, $59, $49, $52, $55, $5c, $41, $1b, $42, $5a, $1b, $5a, $1b, $54, $55, $5e, $1b, $4b, $52, $43, $5e, $57, $1b, $48, $52, $55, $5e, $1b, $48, $58, $49, $54, $57, $57, $1a, $1b, $68, $54, $49, $49, $42, $17, $1b, $55, $54, $1b, $a, $d, $43, $a, $d, $1b, $5d, $54, $55, $4f, $1b, $5a, $4d, $5a, $52, $57, $5a, $59, $57, $5e, $15, $1b, $72, $1b, $53, $5a, $5f, $1b, $4f, $54, $1b, $48, $4f, $49, $5e, $4f, $58, $53, $1b, $5a, $1b, $3, $43, $3, $1b, $54, $55, $5e, $17, $1b, $53, $5e, $55, $58, $5e, $1b, $52, $4f, $48, $1b, $4b, $52, $43, $5e, $57, $5e, $5f, $1b, $57, $54, $54, $50, $15, $15, $15, $1b, $7c, $49, $5e, $5e, $4f, $52, $55, $5c, $48, $1b, $5d, $54, $57, $57, $54, $4c, $15, $15, $15, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $68, $6f, $74, $69, $76, $6f, $69, $74, $74, $6b, $7e, $69, $1, $1b, $73, $54, $4c, $1b, $52, $48, $1b, $6b, $5a, $55, $41, $5e, $49, $1b, $79, $57, $52, $4f, $41, $1b, $5c, $54, $52, $55, $5c, $4, $1b, $78, $5a, $55, $1c, $4f, $1b, $4c, $5a, $52, $4f, $1b, $4f, $54, $1b, $4b, $57, $5a, $42, $1b, $4f, $53, $5e, $1b, $5c, $5a, $56, $5e, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $7f, $7a, $69, $70, $1b, $7e, $75, $6f, $69, $72, $7e, $68, $1, $1b, $7f, $54, $1b, $42, $54, $4e, $1b, $48, $4f, $52, $57, $57, $1b, $54, $4c, $55, $1b, $42, $54, $4e, $49, $1b, $7a, $56, $52, $5c, $5a, $1b, $a, $b, $b, $b, $4, $1b, $77, $54, $54, $50, $1b, $4e, $55, $5f, $5e, $49, $48, $52, $5f, $5e, $1b, $4f, $53, $5e, $1b, $57, $52, $5f, $1, $1b, $4f, $53, $5e, $49, $5e, $1b, $56, $5a, $42, $1b, $59, $5e, $1b, $4d, $5a, $57, $4e, $5a, $59, $57, $5e, $1b, $48, $52, $5c, $55, $5a, $4f, $4e, $49, $5e, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $71, $6e, $75, $70, $72, $7e, $1, $1b, $75, $52, $58, $5e, $1b, $4f, $5e, $5a, $56, $1b, $4c, $54, $49, $50, $1b, $5f, $5e, $58, $54, $5f, $52, $55, $5c, $1b, $4f, $53, $5e, $1b, $7a, $7c, $7a, $1b, $49, $5e, $5c, $52, $48, $4f, $5e, $49, $48, $1a, $1b, $6f, $53, $54, $48, $5e, $1b, $5c, $4e, $42, $48, $1b, $5a, $4f, $1b, $78, $54, $56, $56, $54, $5f, $54, $49, $5e, $1b, $49, $5e, $5a, $57, $57, $42, $1b, $59, $5e, $57, $52, $5e, $4d, $5e, $5f, $1b, $55, $54, $59, $54, $5f, $42, $1b, $4c, $54, $4e, $57, $5f, $1b, $4f, $49, $42, $1b, $4f, $54, $1b, $56, $5e, $4f, $5a, $57, $1b, $59, $5a, $48, $53, $1b, $4f, $53, $5e, $1b, $58, $53, $52, $4b, $48, $5e, $4f, $4, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $78, $74, $69, $7e, $75, $6f, $72, $75, $1, $1b, $69, $5e, $56, $5e, $56, $59, $5e, $49, $52, $55, $5c, $1b, $4f, $53, $5e, $1b, $5d, $52, $49, $48, $4f, $1b, $4f, $52, $56, $5e, $1b, $72, $1b, $48, $5a, $4c, $1b, $5a, $55, $1b, $7a, $56, $52, $5c, $5a, $1b, $5c, $5a, $56, $5e, $15, $15, $15, $1b, $72, $4f, $1b, $4c, $5a, $48, $1b, $74, $59, $57, $52, $4f, $5e, $49, $5a, $4f, $54, $49, $1b, $49, $4e, $55, $55, $52, $55, $5c, $1b, $54, $55, $1b, $42, $54, $4e, $49, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $73, $7e, $7a, $7f, $73, $6e, $75, $6f, $7e, $69, $1, $1b, $6f, $53, $5a, $55, $43, $1b, $5a, $5c, $5a, $52, $55, $1b, $5d, $54, $49, $1b, $4f, $53, $5e, $1b, $5f, $52, $48, $5a, $59, $57, $5e, $5f, $1b, $5a, $58, $58, $5e, $48, $48, $1a, $1b, $78, $54, $55, $5f, $5e, $56, $55, $5e, $5f, $1b, $78, $5e, $57, $57, $4, $1b, $79, $5e, $48, $4f, $1b, $5c, $5e, $49, $56, $5a, $55, $1b, $79, $79, $68, $1b, $5e, $4d, $5e, $49, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $76, $74, $75, $6f, $62, $1, $1b, $68, $54, $1b, $5c, $49, $5e, $5a, $4f, $1b, $4f, $4e, $55, $5e, $48, $1b, $5d, $54, $49, $1b, $4f, $53, $5e, $1b, $58, $49, $5a, $58, $50, $4f, $49, $54, $48, $1a, $1b, $6c, $53, $5a, $4f, $1b, $5a, $1b, $4f, $5e, $5a, $56, $1b, $4c, $5e, $1b, $56, $5a, $5f, $5e, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $73, $7e, $7a, $6f, $73, $7e, $75, $1, $1b, $77, $54, $54, $50, $1b, $5a, $4f, $1b, $42, $54, $4e, $1a, $1b, $6c, $53, $5a, $4f, $1b, $5a, $1b, $4b, $5a, $52, $55, $4f, $59, $5a, $57, $57, $1b, $58, $53, $5a, $56, $4b, $52, $54, $55, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $76, $7a, $63, $72, $76, $72, $77, $72, $7e, $75, $1, $1b, $72, $1b, $5f, $54, $4e, $59, $4f, $1b, $42, $54, $4e, $1b, $4c, $52, $57, $57, $1b, $49, $5e, $5a, $5f, $1b, $4f, $53, $52, $48, $1b, $54, $55, $5e, $17, $1b, $59, $4e, $4f, $1b, $4c, $53, $5a, $4f, $5e, $4d, $5e, $49, $15, $15, $15, $1b, $72, $4f, $1b, $4c, $5a, $48, $1b, $5d, $4e, $55, $1b, $4f, $54, $1b, $58, $54, $5f, $5e, $1b, $4f, $53, $54, $48, $5e, $1b, $58, $49, $5a, $58, $50, $4f, $49, $54, $48, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $6f, $69, $72, $68, $6f, $7a, $75, $1, $1b, $62, $54, $4e, $1b, $4c, $5e, $49, $5e, $1b, $49, $52, $5c, $53, $4f, $1, $1b, $7a, $76, $74, $68, $1b, $52, $48, $1b, $77, $7a, $76, $74, $68, $1a, $1b, $7a, $68, $76, $1b, $49, $4e, $57, $5e, $41, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $7d, $72, $69, $7e, $78, $69, $7a, $78, $70, $7e, $69, $1, $1b, $73, $52, $17, $1b, $56, $5a, $55, $1a, $1b, $73, $54, $4b, $5e, $1b, $42, $54, $4e, $1c, $49, $5e, $1b, $55, $54, $4f, $1b, $59, $54, $49, $52, $55, $5c, $1b, $4f, $54, $1b, $5f, $5e, $5a, $4f, $53, $1b, $52, $55, $1b, $42, $54, $4e, $49, $1b, $59, $5a, $55, $50, $1a, $1b, $1b, $15, $54, $74, $54, $15, $1b, $1b, $3b
	EVEN
text_:							; the same text
	dc.w $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B, $1B1B
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
	dc.w $0000, $0000, $0000, $0000, $33FF, $33FF, $33FF, $33FF
	dc.w $33FF, $33FF, $0000, $0000, $0000, $0000, $0000, $0000
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000 ; Zeichen 2
	dc.w $00CC, $00CC, $00FC, $00FC, $003C, $003C, $0000, $0000
	dc.w $0C30, $0C30, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF, $3FFF
	dc.w $0C30, $0C30, $FFFC, $FFFC, $FFFC, $FFFC, $0C30, $0C30
	dc.w $0C30, $0C30, $0CCC, $0CCC, $3FFF, $3FFF, $3FFF, $3FFF ; Zeichen 3
	dc.w $3FFF, $3FFF, $0CCC, $0CCC, $0300, $0300, $0000, $0000 
	dc.w $3C3F, $3C3F, $3F3F, $3F3F, $3F00, $3F00, $03C0, $03C0
	dc.w $00FC, $00FC, $FCFC, $FCFC, $FC3C, $FC3C, $0000, $0000
	dc.w $0F30, $0F30, $3FFC, $3FFC, $3FFC, $3FFC, $30CC, $30CC ; Zeichen 4
	dc.w $0FFC, $0FFC, $FF30, $FF30, $FCC0, $FCC0, $0000, $0000
	dc.w $0000, $0000, $0000, $0000, $00CF, $00CF, $00FF, $00FF
	dc.w $003F, $003F, $0000, $0000, $0000, $0000, $0000, $0000

	end

Programmbeschreibung:

Dieser Programmausschnitt befindet sich in der _writeLoop-Schleife. Die
Schleife wird #SCROLL_DX-1,d1 also 320 Mal durchlaufen, also die 
gesamte Bildschirmbreite. Im unteren Bereich der Schleife wird der Zeiger
berechnet, der auf die nächste zu druckende Pixelspalte des Zeichens
zeigt. Der Zeiger auf die neue Pixelspalte ist im Ergebnis is a1.

Folgende Fälle werden unterschieden:
- es ist ein neues Zeichen	--> dann zeigt a1 auf die erste Pixelspalte				lea (a1,d1.w),a1
- es ist das gleiche Zeichen 	--> dann wird auf die nächste Pixelspalte gezeigt	lea 2(a1),a1

In jedem Fall besteht ein Zeichen aus 16x16Bit (0 bis 15 oder $0 bis $F)
Wenn also der Zähler auf die Pixelspalte $10=%1.000 zeigt, dann wird der
Zähler d4 zurückgesetzt und ein neues Zeichen gelesen.
Das Zeichen wird geholt und mit der Endemarke verglichen. Wenn es sich
um das Ende handelt wird der Zeiger wieder auf den Anfang des Textes gesetzt.

Nun wird das richtige Ascii-Zeichen ermittelt und mit 32 (2^5) multipliziert.
2x16 Bytes. Der Zeiger zeigt nun auf die erste Pixelspalte des Zeichens. 
