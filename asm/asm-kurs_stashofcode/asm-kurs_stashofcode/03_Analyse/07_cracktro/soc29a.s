
; soc29a.s
; erklärt den Programmteil - credits -
; zeigt nichts an, nur zum Debuggen

; *************** PARAMETER DES SCREENS 1 ***************

NbPlane1=1				; 1
SizeX1=640+64			; 704
SizeY1=64+12+8*2		; 92

start:
	lea Credits_adr,a1							; lädt die Adresse des Labels (nicht dessen Wert)
	movea.l Screen1_adr,a0						; lädt den Wert an der Adresse des Labels
	add.w #(SizeY1-8)*NbPlane1*SizeX1/8,a0		; (92-8)*1*(704/8)=7392 = $1CE0 (Offset addieren) zur Bitplaneadresse
Credits_Loop:
	moveq #0,d1							; d1 zurücksetzen
	move.b (a1)+,d1						; nächstes Textzeichen 
	cmp.b #$1B,d1						; wenn Endemarkierung
	beq Credits_End						; dann springe zum Ende
	subi.b #$20,d1						; -$20, wegen ASCII Zeichen im Font
	lsl.w #3,d1							; *8, weil das Zeichen 8 Bytes groß ist
	movea.l a0,a2						; Adresse wo der Text gedruckt werden soll
	lea Font8_adr,a3					; Anfangsadresse des Fonts
	add.w d1,a3							; den Offset des Zeichens dazu addieren
	rept 8								; 8 * wiederholen, weil ein Zeichen 8 Zeilen hat
	move.b (a3)+,(a2)					; die einzelnen Zeilen des Zeichens drucken
	lea NbPlane1*SizeX1/8(a2),a2		; Adresse um 1*(704/8)=88 Bytes erhöhen
	endr
	addq.w #1,a0						; nächstes Zeichen
	jmp Credits_Loop					; in der Schleife bleiben, bis Ende Zeichen erkannt wird
Credits_End:

	rts
	

Screen1_adr:	
	dc.l 0								; hierfür wurde zuvor Speicherplatz angefordert

Credits_adr:	
	incbin "credits.txt"
	even

Font8_adr:	
	incbin "logo.fnt"

	end