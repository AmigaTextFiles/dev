;
; example.asm -- a simple LED flasher
;

;
; example source code for picasm by Timo Rossi
;

;
; define PIC device type
;
	device	pic16c84

;
; define config fuses
;
	config	CP=off,WDT=off,PWRT=off,OSC=hs

;
; include PIC register definitions, and some macros
;
	include "pic16c84.h"
	include "picmac.h"

;
; bit definitions for two LEDs connected to port A bits 0 and 1
; bit masks can be computed from bit numbers with the left shift operator.
;
A_LED1	equ	0
A_LED2	equ	1

;
; define some register file variables
;

	org	0x0c

delay_cnt1	ds	1
delay_cnt2	ds	1

;
; code start
;
	org	0

	movlw	0xff
	movwf	PORTA	;initialize port A so that LEDs are off

	bsf	STATUS,RP0			;register page 1
	movlw	~((1<<A_LED1)|(1<<A_LED2))	;LEDs as outputs,
	movwf	TRISA				;other PORTA pins as inputs
	bcf	STATUS,RP0			;register page 0

main_loop
	movlw	1<<A_LED1
	xorwf	PORTA,F		;toggle led1

	clrw			;maximum delay length (256 counts)
	call	delay

	clrw			;maximum delay length (256 counts)
	call	delay

	movlw	(1<<A_LED1)|(1<<A_LED2)
	xorwf	PORTA,F		;toggle both leds

	clrw			;maximum delay length (256 counts)
	call	delay

	goto	main_loop

;
; delay subroutine
; input: delay count in W
;
; inner loop duration approx:
; 5*256+3 = 1283 cycles ->
; 1.28ms with 4MHz crystal (1MHz instruction time)
;
delay	movwf	delay_cnt1
	clrf	delay_cnt2
delay_a	nop
	nop
	incfsz	delay_cnt2,F
	goto	delay_a
	decfsz	delay_cnt1,F
	goto	delay_a
	return

	end
