;
; es1.asm  writes a string, a decimal number and the status of a port
; to a simulated serial (RB6). Speed is programmable depending
; on the value of BAUD_CYCLES
;
; example source code for picasm by Timo Rossi
; modified by Luigi Rizzo
;

	device	pic16c84			; define PIC device type

	config	CP=off,WDT=off,PWRT=off,OSC=hs	; define config fuses

TXON	equ	1	; define if you want to drive TxD low.
;--- the delay is D= 1000000/ baud_rate cycles.
;    The number of cycles is (D-15)/3, i.e.
;  n = 333333/baud - 5

BAUD_CYCLES	equ 134;	2400
;BAUD_CYCLES	equ 67;	4800
;BAUD_CYCLES	equ 29;	9600
;BAUD_CYCLES	equ 12;	19200

;
; include PIC register definitions, and some macros
;
	include "picreg.h"
	include "picmac.h"

tstring	macro	; string pos
	if chrval(\1,\2) > 0
	    retlw chrval(\1, \2);
	    tstring \1, \2+1
        else
	    retlw 0
	endif
endm

;
; bit definitions for two LEDs connected to port A bits 0 and 1
; bit masks can be computed from bit numbers with the left shift operator.
;
A_LED1	equ	0
A_LED2	equ	1

B_TxD	equ	6

IR_PWR	equ	4	; power for IR receiver
IR_DATA	equ	5	; data for IR receiver
;
; define some register file variables
;

	org	0x0c

delay_cnt1	ds	1
delay_cnt2	ds	1
txdata		ds	1
save_w		ds	1
ctr		ds	1
number	ds	1
weight	ds	1
digit	ds	1
punta	ds	1
;
; code start
;
	org	0

	clrw
	movwf	PORTA	;initialize port A so that LEDs are off
	movwf	PORTB	;initialize port B so that txD is idle
	movwf	ctr
	movwf	punta

	bsf	STATUS,RP0			;register page 1
if	0
	movlw	~((1<<A_LED1)|(1<<A_LED2))	;LEDs as outputs,
else
	movlw	0xff
endif
	movwf	TRISA				;other PORTA pins as inputs
	; Default: TxD=1,  either HiZ or drive low
if defined(TXON)
	movlw	~( (1<<B_TxD) | (1<<IR_PWR) )		; drive TxD
else
	movlw	~(1<<IR_PWR)			; HiZ TxD
endif
	movwf	TRISB			; other PORTB pins as inputs
	bcf	STATUS,RP0		; register page 0
	bcf	PORTB,B_TxD		; Drive low (idle)
main_loop
	bsf	PORTB,IR_PWR		; Drive high (active)
	btfsc	PORTB, IR_DATA
	goto	main_loop
	bsf	PORTB,IR_PWR		; Drive high (active)
	bsf	PORTA, A_LED2
	movf	ctr,W
	call	dodec
	incf	ctr
	bcf	PORTA,A_LED2
stampa	movf	punta,W
	call	prova
	addlw	0	; test zero
	btfsc	STATUS,Z
	goto	fine
	call	dobyte
	incf	punta
	goto	stampa

	org	reg

bctr	ds	1

	org	code

fine	movlw	8
	movwf	bctr
	movf	PORTB,W
	movwf	punta
bit1
	movlw	'0'
	rlf	punta
	btfsc	STATUS,C
	movlw	'1'
	call	dobyte
	decfsz	bctr
	goto	bit1
	clrw
	movwf	punta

	movlw	13
	call	dobyte
	movlw	10
	call	dobyte
	movlw	100
	call	doflash
	goto	main_loop

flash1	movlw	1
doflash
	bsf	PORTA,A_LED1
	call	delay
	bcf	PORTA,A_LED1
	clrw
	call	delay
	return
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
	nop
	nop
	nop
	nop
	nop
	incfsz	delay_cnt2,F
	goto	delay_a
	decfsz	delay_cnt1,F
	goto	delay_a
	return
delay1	movwf	save_w
delay1a	clrw
	call	delay
	decfsz	save_w,F
	goto	delay1a
	return

; dodec prints the decimal digits corr. to W
dodec	movwf	number
	movlw	100
	movwf	weight
	call	conv
	movlw	10
	movwf	weight
	call	conv
	movlw	1
	movwf	weight
	call	conv
	return

; conv: called with number -> r0, weight ->r1
;	prints digit (in r2)
;
conv	movlw	'0'
	movwf	digit
	movf	weight,W
conv1	incf	digit	; inc digit
	subwf	number,F
	btfsc   STATUS,C	; skip if clear (negative)
	goto	conv1
	decf	digit
	addwf	number,F
	movf	digit,W
	call	dobyte
	return

	org	reg
ctr1	ds	1

	org	code

dobyte	movwf	txdata
	bcf	STATUS,C	; start bit
	call	dobit
	movlw	8
	movwf	ctr1
dobyte1	rrf	txdata
	call	dobit
	decfsz	ctr1
	goto	dobyte1
	bsf	STATUS,C	; stop bit
	call	dobit
	bsf	STATUS,C	; stop bit
	call	dobit
	nop
	return
; dobit emits the carry to the serial port, and
; waits the delay corresponding to 1 bit at 2400, 416us
dobit
	bsf	STATUS,RP0		; register page 1
	btfsc	STATUS,C		; skip if clear
	goto	dobit_1

dobit_0					; 0 = +Vcc = power, always drive high
	bcf	TRISB,B_TxD		; drive
	bcf	STATUS,RP0		; register page 0
	bsf	PORTB,B_TxD		; cy clear: bit active
	goto	dobit_end

dobit_1					; 1 = gnd or HiZ
if defined(TXON)
	bcf	TRISB,B_TxD		; drive
else
	bsf	TRISB,B_TxD		; HiZ
endif
	bcf	STATUS,RP0		; register page 0
	bcf	PORTB,B_TxD		; cy clear: bit active
	nop

dobit_end
	bsf	PORTB,IR_PWR		; Drive high (active)
	movlw	BAUD_CYCLES
	movwf	delay_cnt2
dobit_a	decfsz	delay_cnt2,F
	goto	dobit_a
	return

prova	addwf	PCL,F
	tstring " messaggio di prova - RB= ",0
	end
