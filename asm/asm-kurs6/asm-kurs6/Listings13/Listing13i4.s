
; Listing13i4.s	; Bits als Flags
; Zeile 1865

Opzione1	=	0
VaiDestra	=	1		; gehe nach rechts oder links?
Avvicinamento	=	2	; Annäherung oder Rückzug?
Music		=	3		; Musik ein oder aus?
Candele		=	4		; Kerzen anzünden oder nicht anzünden?
FirePremuto	=	5		; jemand drückte Feuer?
Acqua		=	6		; im Teich unten?
Cavallette	=	7		; gibt es Heuschrecken?

start:
	;move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	moveq	#0,d0				; 4 cy
Controllo:
	move.b	MieiFlags(PC),d0	; 12 cy	
	btst.l	#Opzione1,d0		; 10 cy Die Anweisung TESTET ob das angegebene Bit ZERO ist.
	beq.s	bit_is_not_set		; 8 cy
	; ...

CambiaFlags:					; Flags ändern
	lea	MieiFlags(PC),a0		; 8 cy
	bset.b	#Opzione1,(a0)		; 16 cy  nur .b bei Betrieb an Speicheradressen
	bclr.b	#Opzione1,(a0)		; 16 cy
	bchg.b	#Opzione1,(a0)		; 16 cy
	;or
	move.b	MieiFlags(PC),d0	; 12 cy
	bset.l	#Opzione1,d0		; 10 cy nur .l bei Betrieb mit Datenregister
	bclr.l	#Opzione1,d0		; 12 cy ?
	bchg.l	#Opzione1,d0		; 10 cy
	;or
	move.b	MieiFlags(PC),d0	; 14 cy
	or.b	#1<<Opzione1,d0		; 8 cy
	and.b	#~(1<<Opzione1),d0	; 8 cy
	eor.b	#1<<Opzione1,d0		; 8 cy

Controllo2:
	move.b	MieiFlags(PC),d0	; 12 cy
	btst.l	#Candele,d0			; 10 cy
	beq.s	bit_is_not_set		; 10 cy
	nop
	
;-------------------------------;	
bit_is_not_set:
	nop							; an dieser Stelle ist die Aufgabe erledigt
	;move.w #$C000,$dff09a		; Interrupts enable
	rts



MieiFlags:
	dc.b	%00000001	; only Opzione1
	;dc.b	%00010010	; Vaidestra and Candele

	even
			
	end

Eine andere Sache, die für Sie nützlich sein kann, ist die Verwendung von Bits
als Flags. Beispielsweise, wenn wir in unserem Programm Variablen haben, die
TRUE oder FALSE sein müssen, dh ON oder OFF, ist es sinnlos, für jedes ein Byte
zu verschwenden. Es wird ein bisschen dauern und wir werden Platz sparen.
Beispielsweise:

Opzione1	=	0
VaiDestra	=	1		; gehe nach rechts oder links?
Avvicinamento	=	2	; Annäherung oder Rückzug?
Music		=	3		; Musik ein oder aus?
Candele		=	4		; Kerzen anzünden oder nicht anzünden?
FirePremuto	=	5		; jemand drückte Feuer?
Acqua		=	6		; im Teich unten?
Cavallette	=	7		; gibt es Heuschrecken?

Controllo:
	move.w	MieiFlags(PC),d0
	btst.l	#Opzione1,d0
	...


CambiaFlags:
	lea	MieiFlags(PC),a0
	bclr.b	#Opzione1,(a0)
	...

MieiFlags:
	dc.b	0
	even

Wenn Sie jedoch btst und bclr/bset/bchg nicht mögen, können Sie dies tun:

	bset.l	#Opzione1,d0	->	or.b	#1<<Opzione1,d0

	bclr.l	#Opzione1,d0	->	and.b	#~(1<<Opzione1),d0

	bchg.l	#Opzione1,d0	->	eor.b	#1<<Opzione1,d0

Beachten Sie die Nützlichkeit der asmone Shift--Funktionen ">>" und "<<"
sowie eor "~".

;------------------------------------------------------------------------------
r
Filename: Listing13i3.s
>a
Pass1
Pass2
No Errors
>ad			; asmone Debugger

; start the programm
; discover the programm with asmone Debugger
; 

;------------------------------------------------------------------------------
r
Filename: Listing13i3.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
;...






