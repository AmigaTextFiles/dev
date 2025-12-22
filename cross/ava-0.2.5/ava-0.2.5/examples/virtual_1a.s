
        seg     abs=0 flash.code 

        rjmp __spi_
	clr r0
	tst r0
	nop 	; these instructions are only used to see segment
		; increase

extern virtual __spi_:
        reti
