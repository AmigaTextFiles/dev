
; soc29e.s
; Programmteil zum Debuggen
; erklärt die d0-Abbruchbedingung, beim Scrollen aufgrund verschiedener Buchstabenbreiten

	section prg,code_c

; *************** KONSTANTEN ***************

SpaceWidth=16						; Wert in Pixel des Zeichens SpaceWidth
DeltaChar=4							; Pixelwert der Freiraum zwischen zwei Buchstaben

start:
; ------ Initialisierung der Parameter ------

	lea Text_adr,a4					; Zeiger auf Scrolltext
	moveq #0,d0						; Startwert für Scrolltext
	move.w d0,-(sp)					; Wert wird in Scrolltext-Routine abgefragt				



; ------ Hauptprogramm ------

	moveq #100,d3
Main_Loop:


; ----- scroll -----

; Scroll über den gesamten Bildschirm - Blitt mit Verschiebung
; ...

; ----- Buchstabenanzeige -----

	move.w (sp)+,d0					; Breite-Wert nach d0
	dbf d0,Scroll_End				; solange wie Breite-Wert >=0 ist, dann zum Ende springen

Scroll_NextChar:					; ansonsten nächstes Zeichen
	move.b (a4)+,d1					; aktuelles Byte (Charakter) lesen
	bne Scroll_CharOK				; wenn Charakter nicht Null, Zeichen lesen
	lea Text_adr,a4					; ansonsten, Anfangsadresse des Scrolltextes wieder von vorn
	bra Scroll_NextChar				; unbedingter Sprung zurück
Scroll_CharOK:

	cmp.b #$20,d1					; $20 ist der ASCII-Abstand (das Leerzeichen)
	bne Scroll_NoSpace				; wenn es kein Leerzeichen ist, dann überspringen	
	moveq #SpaceWidth/2,d0			; /2 wegen scrollspeed=2  (16/2=8)

; dieser Blitt "druckt" das Zeichen (Space) welches reingescrollt wird, löscht also
; ...

	bra Scroll_End
Scroll_NoSpace:						; wenn hier wird ein neues Zeichen gedruckt

	lea AlphaData_adr,a1			; Adresse Feld mit Reihenfolge der Zeichen
	moveq #-6,d2					; d2 mit -6 laden		
Scroll_SearchChar:
	addq.w #6,d2					; d2 ist der Offset um das Zeichen in Alpha_adr zu finden dc.w x,x,x (6 Bytes oder 3 Wörter)
	cmp.b (a1)+,d1					; mit aktuellen Zeichen vergleichen, in d1 ist das aktuelle Zeichen
	bne Scroll_SearchChar			; wenn nicht Null, dann zurückspringen (solange bis das Zeichen gefunden wurde)
	lea Alpha_adr,a1				; ansonsten, Anfangsadresse der Zeichen 
									; (Byte horizontale Position, Zeile, Breite in Bits)
;...

	move.w 4(a1,d2.w),d0			; Anfangsadresse der Zeichen + Offset+4 = Breite in Bits
	add.w #DeltaChar,d0				; Pixelwert der Freiraum zwischen zwei Buchstaben
	lsr.w #1,d0						; Breite/2 wegen Scrollgeschwindigkeit = 2
	subq.w #1,d0					; (Breite/2)-1

; Zeichen reinkopieren
; ...

Scroll_End:
	move.w d0,-(sp)					; neue Breite in d0 auf dem Stack speichern

	dbf d3,Main_Loop

	rts

; *************** VARIABLEN ***************

Text_adr:	incbin "propor.scrl"
		dc.b 0

AlphaData_adr:
	dc.b $41,$42,$43,$44,$45,$46,$47,$48,$49,$4A
	dc.b $4B,$4C,$4D,$4E,$4F,$50,$51,$52,$53,$54
	dc.b $55,$56,$57,$58,$59,$5A,$61,$62,$63,$64
	dc.b $65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E
	dc.b $6F,$70,$71,$72,$73,$74,$75,$76,$77,$78
	dc.b $79,$7A,$31,$32,$33,$34,$35,$36,$37,$38
	dc.b $39,$30,$2C,$2E,$21,$3F,$7E,$28,$29,$27
	even


Alpha_adr:

; Byte horizontale Position, Zeile, Breite in Byte, Komplement in Bits

; A
	dc.w 0,0,37
; B
	dc.w 8,0,30
; C
	dc.w 16,0,27
; D
	dc.w 24,0,34
; E
	dc.w 32,0,28
; F
	dc.w 40,0,26
; G
	dc.w 48,0,33
; H
	dc.w 56,0,36
; I
	dc.w 64,0,14
; J
	dc.w 72,0,18
; K
	dc.w 0,64,33
; L
	dc.w 8,64,26
; M
	dc.w 16,64,41
; N
	dc.w 24,64,35
; O
	dc.w 32,64,34
; P
	dc.w 40,64,28
; Q
	dc.w 48,64,34
; R
	dc.w 56,64,32
; S
	dc.w 64,64,22
; T
	dc.w 72,64,30
; U
	dc.w 0,128,34
; V
	dc.w 8,128,36
; W
	dc.w 16,128,52
; X
	dc.w 24,128,32
; Y
	dc.w 32,128,39
; Z
	dc.w 40,128,24
; a
	dc.w 48,128,23
; b
	dc.w 56,128,25
; c
	dc.w 64,128,18
; d
	dc.w 72,128,26
; e
	dc.w 0,192,21
; f
	dc.w 8,192,17
; g
	dc.w 16,192,27
; h
	dc.w 24,192,30
; i
	dc.w 32,192,14
; j
	dc.w 40,192,14
; k
	dc.w 48,192,30
; l
	dc.w 56,192,14
; m
	dc.w 64,192,45
; n
	dc.w 72,192,29
; o
	dc.w 0,256,22
; p
	dc.w 8,256,25
; q
	dc.w 16,256,26
; r
	dc.w 24,256,20
; s
	dc.w 32,256,16
; t
	dc.w 40,256,16
; u
	dc.w 48,256,25
; v
	dc.w 56,256,24
; w
	dc.w 64,256,35
; x
	dc.w 72,256,24
; y
	dc.w 0,320,30
; z
	dc.w 8,320,21
; 1
	dc.w 16,320,16
; 2
	dc.w 24,320,22
; 3
	dc.w 32,320,21
; 4
	dc.w 40,320,26
; 5
	dc.w 48,320,22
; 6
	dc.w 56,320,23
; 7
	dc.w 64,320,23
; 8
	dc.w 72,320,25
; 9
	dc.w 0,384,23
; 0
	dc.w 8,384,23
; ,
	dc.w 16,384,8
; .
	dc.w 24,384,8
; !
	dc.w 32,384,10
; ?
	dc.w 40,384,18
; ~
	dc.w 48,384,13
; (
	dc.w 56,384,13
; )
	dc.w 64,384,13
; '
	dc.w 72,384,8


	end

