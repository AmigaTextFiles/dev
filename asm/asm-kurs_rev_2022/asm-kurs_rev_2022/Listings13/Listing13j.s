
; Listing13j.s	; 68000 Basis zu 68020
; Zeile 1920
; nur Programmfragment

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
Routine1:
	move.w	#(2048/16)-1,d7
loop1:
	rept	16
	;< Block mit Anweisungen >
	moveq	#0,d0
	endr

	dbra	d7,loop1

;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	end



Routine1:
	move.w	#2048-1,d7
loop1:
	< Block mit Anweisungen >
	dbra	d7,loop1

Wir können es optimieren in:

Routine1:
	rept	2048
	< Block mit Anweisungen >
	endr	

Auf einer 68000 Basis ist es viel schneller, aber auf einer 68020 ist es
langsamer! So optimieren Sie in allen Fällen so schnell wie möglich:

Routine1:
	move.w	#(2048/16)-1,d7
loop1:
	rept	16
	< Block mit Anweisungen >
	endr

	dbra	d7,loop1

