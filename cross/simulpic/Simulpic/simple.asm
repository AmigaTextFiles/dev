;this is a simple source
;
;this little program toggles the PortA bit 3,
;Port B counts every change on bit RA.3
;



	list	p=PIC16C84, r=dec, s=off


	org	0x000
	goto	start
	org	0x004



count1	equ	0x0B			 ;this assigns the symbol to the register

RA	equ	5			;PortA is register 5
RB	equ	6			;PortB is register 6

start	movlw	0x07
	movwf	RA			;bit 0 to bit 2 are inputs

	movlw	0			;portb is output
	movwf	RB

	clrf	RB		      ;clear PortB

main	movlw	0x08
	xorwf	RA			;toggle bit 3 from PortA

	incf	RB,f			;increase PortB

	call	delay

	goto	main			;do the main loop




delay	movlw	20
	movwf	count1			;mov 20 to count1

loop   decfsz  count1
       goto    loop		      ;decrement count1 and jump to local symbol until
					;loop is > 0
	retlw	0
