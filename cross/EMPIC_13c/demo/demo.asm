
;                           \|/
;                           @ @
;-----------------------ooO-(_)-Ooo--------------------------
;
;                     Flash of success.
;                        Gluemaster
;                          970331
;
;------------------------------------------------------------

	device 16c84
	osc rc
	fuse cp_off wdt_off pwrte_on

tmplo	ram 1
tmphi	ram 1

#define interrupt

;If interrupts are used, the vectors must be set.
;Otherwise a simple org 0x000 will suffice
;(remove #define line)

#ifdef interrupt
; Reset vector
	org 0x000
	goto start

;; Interrupt vector
	org 0x004
	retfie
start
#else
	org 0x000
#endif
	clrf PORTA
	movlw 0x1c
	bsf STATUS,RP0
	movwf TRISA
	bcf STATUS,RP0
eever
	bsf PORTA,0
	bsf PORTA,1
	call wait
	bcf PORTA,0
	call wait
	bsf PORTA,0
	bcf PORTA,1
	call wait
	bcf PORTA,0
	call wait
	goto eever

wait
	movlw 0xff
	movwf tmphi
wloophi
	movlw 0xff
	movwf tmplo
wlooplo
	decfsz tmplo,f
	goto wlooplo
	decfsz tmphi,f
	goto wloophi
	return


