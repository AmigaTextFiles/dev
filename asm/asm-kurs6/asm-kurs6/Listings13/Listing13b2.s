
; Listing13b2.s	; Multiplikation - Zerlegung in Primfaktoren
; Zeile 472

start:
	;move.w #$4000,$dff09a	; Interrupts disable
waitmouse:  
	;btst	#6,$bfe001		; left mousebutton?
	;bne.s	Waitmouse	

; Zeile 472
;------------------------------------------------------------------------------
; n=3, 3*x				z.B. 15*3
	moveq	#15,d0
	move.l	d0,d1
	add.l	d0,d0		; d0=d0*2
	add.l	d1,d0		; d0=(d0*2)+d0		; d0=$2d=45

;------------------------------------------------------------------------------
; Betrachten wir einen anderen Fall zum Beispiel für n=5, dann haben wir 5*x,
; das heißt 4*x+x: Als Code haben wir das:
; n=5, 5*x				z.B. 15*5

	moveq	#15,d0
	move.l	d0,d1
	asl.l	#2,d0		; d0=d0*4
	add.l	d1,d0		; d0=(d0*4)+d0		; d0=$4b=75

;------------------------------------------------------------------------------
; Betrachten Sie schließlich einen anderen Fall, in dem n=20 ist, dann haben
; wir 20*x, aber 20*x=4*(5*x)=4*(4*x+x)
; n=20, 20*x			z.B. 15*20

	moveq	#15,d0
	move.l	d0,d1
	asl.l	#2,d0		; d0=d0*4
	add.l	d1,d0		; d0=(d0*4)+d0
	asl.l	#2,d0		; d0=4*((d0*4)+d0)	; d0=$12c

;------------------------------------------------------------------------------
	nop	
	;move.w #$C000,$dff09a	; Interrupts enable
	rts
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13b2.s
>a
Pass1
Pass2
No Errors
>ad		; asmone Debugger

; start the programm
; discover the programm with asmone Debugger
