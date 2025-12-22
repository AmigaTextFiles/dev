;APS000000B8000000B8000000B8000000B8000000B8000000B8000000B8000000B8000000B8000000B8
uart_init:
	move.w	#BAUD, serper(a6)
	; Empty RX buffer.
	move.w	#INTF_RBF, intreq(a6)
	; Hardware flow control
	bclr.b	#CIAB_COMRTS, CIAB+ciapra
	bclr.b	#CIAB_COMDTR, CIAB+ciapra
	rts


; Return RX byte
; out
;   - d0 RX byte
uart_get:
	move.w	#$0000, color(a6)
	move.w	serdatr(a6), d0
	btst	#SERDATRB_RBF, d0
	beq.b	uart_get
	move.w	#INTF_RBF, intreq(a6)
	move.w	#$070f, color(a6)
	rts
