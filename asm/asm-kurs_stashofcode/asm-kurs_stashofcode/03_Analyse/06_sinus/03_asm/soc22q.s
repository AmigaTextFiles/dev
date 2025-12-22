
; soc22q.s
; "Text scroller" nächstes Zeichen für Scrolltext

SCROLL_SPEED=2					; Scrollgeschwindigkeit
TEXT_XOR=$3B					; Endemarke


; Scroll the text
	move.w	#32,d5				; zum Test
scroll_the_text:
	move.w scrollColumn,d0		; Zählerstand der aktuellen Spalte in dem Zeichen nach d0
	addq.w #SCROLL_SPEED,d0		; Scrollgeschwindigkeit
	cmp.b #15,d0				; Is the new column after the last of the character?
	ble _scrollNextColumn		; If not, nothing happens
	;blt _scrollNextColumn
	sub.b #15,d0				; If yes, get the new column in the next character...
	
	move.w scrollChar,d1		; Zählerstand des aktuellen Zeichens nach d1
	addq.w #1,d1				; ..and move to the next character
	lea text,a0					; Anfangsadresse auf Text	
	move.b (a0,d1.w),d2			; Is the new character after the last one?			also $1b, $1b, $1b, usw. bis $3B
	eor.b #TEXT_XOR,d2			; wenn Ende erreicht ist $3B; Zähler d1 löschen
	bne _scrollNextChar			; ansonsten nächstes Zeichen
	clr.w d1					; If yes, loop on the first character
_scrollNextChar:
	move.w d1,scrollChar		; Zählerstand des aktuellen Zeichens speichern
_scrollNextColumn:
	move.w d0,scrollColumn		; Zählerstand der aktuellen Spalte speichern
	
	dbf d5,scroll_the_text

	rts

; Daten

text:							; the same text
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

scrollColumn:			DC.W 0 ; $B		; Zählerstand der aktuellen Spalte in dem Zeichen
scrollChar:				DC.W 0			; Zählerstand des aktuellen Zeichens

	end

Programmerklärung:

Wir haben einen Text der gescrollt werden soll. Der Text besteht aus Bytewerten.
Normalerweise Ascii-Werte. In diesem Fall sind die Ascii-werte mit XOR verschlüsselt
und müssen zuerst zurück entschlüsselt werden.

Es gibt zwei Zähler. 
- für aktuelles Zeichen im Text.						; scrollChar
- ein weiterer für die aktuelle Spalte in dem Zeichen.	; scrollColumn

Die Zeichen sind 16x16 Pixel groß, d.h. 16 Spalten.
Zu Beginn sind beide Zähler auf 0. Wir zeigen auf die erste Spalte des ersten Zeichens.
Spalte 0 ist die erste und Spalte 15 die letzte Spalte.

Wir holen uns den Zählerwert 'der aktuellen Spalte in dem Zeichen' und addieren die 
Scrollgeschwindigkeit '2'. Anschließend vergleichen wir mit 15.
ble - wertet folgende Flags aus: kleiner, gleich 15 -- heißt zeichnen
Wenn die Bedingung erfüllt ist werden 15 subtrahiert. Der neue Wert wird am Ende 
gespeichert.

Aufgrund Scroll Speed '2' werden nur alle zwei Spalten angezeigt:
0,2,4,6,8,10,12,14,16 als hex 0,2,4,6,8,A,C,E,$10  (1Byte bis $FF)
Wenn $10 (16) erreicht ist werden 15 abgezogen:
1,3,...,$F,$11,2,4,...,$10

(mit blt _scrollNextColumn 1,3,...,$F,0,2,4,...,$10)

Wenn die Spalte ermittelt ist, wird das Zeichen geholt und das Charakter in diesem 
Fall um 1 erhöht, also auf das nächste Zeichen gezeigt.
Jetzt Anfang von Text + Offset und das Zeichen holen. Zeichen entschlüsseln und
prüfen auf Ende Textmarke. 



