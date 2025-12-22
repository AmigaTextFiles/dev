
; Listing13b.s	; Bitverschiebung
; Zeile 431

start:
;-----------------------------------------------------
; 9 Bit Links-Verschiebung
	moveq	#1,d0
	lsl.l	#8,d0			
	add.l	d0,d0
;-----------------------------------------------------
; 16 Bit Links-Verschiebung
	moveq	#$1,d0
	swap	d0
	clr.w	d0
;-----------------------------------------------------
; 24 Bit Links-Verschiebung
	moveq	#$1,d0
	swap	d0
	clr.w	d0
	lsl.l	#8,d0
;-----------------------------------------------------
; 16 Bit Rechts-Verschiebung
	move.l	#$10000000,d0
	clr.w	d0
	swap	d0
;-----------------------------------------------------
; 24 Bit Rechts-Verschiebung
	move.l	#$10000000,d0
	clr.w	d0
	swap	d0
	lsr.l	#8,d0
;-----------------------------------------------------
	
	rts
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13b.s
>a
Pass1
Pass2
No Errors
>ad			; asmone Debugger

; start the programm
; discover the programm with asmone Debugger

