
; Listing13g3.s			Fallunterscheidung wenn positiv, negativ, null
; Zeile 1329

start:
	moveq	#0,d0		; -2, -1, 0 	

	add.w	#1,d0		; die CCs sind in irgendeiner Weise eingestellt
	beq.s	Zero		; das Ergebnis ist Null
	blt.s	Negativo	; das Ergebnis ist kleiner als Null
	;...				; ansonsten ist das Ergebnis positiv...

Positiv:
	nop

Zero:
	nop

Negativo:
	nop


	rts

	end



Wir haben den Sprung zu Routinen bereits mit Subq.b #1,d0 implementiert gefolgt
von den BEQs, ohne CMP oder TST. Wir wollen uns mit deren Verwendung verbunden
mit den Condition Codes befassen. (Überprüfen Sie es gut in 68000-2.txt)
Wir Assemblerprogrammierer können den Luxus genießen, drei Bedingungen zu einem
Zeitpunkt zu testen. In der Tat betrachten wir das Beispiel:

	Add.w	#x,d0		; die CCs sind in irgendeiner Weise eingestellt
	Beq.s	Zero		; das Ergebnis ist Null
	Blt.s	Negativo	; das Ergebnis ist kleiner als Null
	...					; ansonsten ist das Ergebnis positiv...


;------------------------------------------------------------------------------
r
Filename: Listing13g3.s
>a
Pass1
Pass2
No Errors
>ad			; asmone Debugger

; start the programm
; discover the programm with asmone Debugger
