;	Small C for the PIC16x84;
;	Coded 6/11/97
;	Version 0.003
;	By Ian Stedma n. ICStedman@techie.com

	include "16c84.h"

; **************code segment cseg*******************
	device pic16c84
	org 0x04



; Begin Function



main
	movlw primary1
	movwf a1
	movlw primary2
	movwf a2
	movlw a1
	call push
	movlw a2
	call pop
	addf primary, secondary
	movwf a3
 1
	return


; **************data segment dseg*******************
	  org DSEG

a1	ds	1
a2	ds	1
a3	ds	1

;0 error(s) in compilation
;	literal pool:0
;	global pool:84
;	Macro pool:51
	end

