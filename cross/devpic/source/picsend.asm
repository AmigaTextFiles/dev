; This is a sample routine for sending debug info to PicRecv
; Change temp1 and count variables, and TRISB value for your needs

; PIC must have at least 4MHz and interrupts must be disabled
; diring execution of current debugging tool version!

; Sending value should be placed in W

dprint	movwf	temp1
	movlw	b'01100011'
	tris	PORTB
	movlw	9
	movwf	count
dp_a	clrwdt
	btfsc	PORTB,6
	goto	dp_a
	movlw	b'01100011'
	bsf	STATUS,C
	rlf	temp1
	btfsc	STATUS,C
	movlw	b'11100011'
	tris	PORTB
dp_b	clrwdt
	btfss	PORTB,6
	goto	dp_b
	decfsz	count
	goto	dp_a
	return
