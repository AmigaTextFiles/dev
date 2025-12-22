; state := led_status()
;   state = boolean := true if LED/sound filter is ON, false if it is OFF
;
; oldstate := set_led(state)
;  state    = boolean : true turns the led ON, state=false turns the led OFF
;  oldstate = boolean : the state before your change.
;
; toggle_led()
;   for fun

	include	hardware/cia.i
_ciaa=$bfe001

	xdef	led_status
led_status
	lea	_ciaa+ciapra,a0
	moveq	#0,d0
	btst.b	#CIAB_LED,(a0)
	bne.s	.done
	moveq	#-1,d0
.done	rts

	xdef	set_led__i
set_led__i
	bsr.s	led_status
	tst.l	4(sp)
	beq.s	.off
	bclr.b	#CIAB_LED,(a0)
	rts
.off	bset.b	#CIAB_LED,(a0)
	rts

	xdef	toggle_led
toggle_led
	bsr.s	led_status
	bchg.b	#CIAB_LED,(a0)
	rts
