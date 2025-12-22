;***************************************************************************
;* A P P L I C A T I O N   N O T E   F O R   T H E   A V R   F A M I L Y
;* 
;* Number		:AVR000
;* File Name		:"2323def.inc"
;* Title		:Register/Bit Definitions for the AT90S2323
;* Date	 		:98.05.22
;* Version		:1.22JB
;* Target MCU		:AT90S2323
;*
;* DESCRIPTION
;* When including this file in the assembly program file, all I/O register
;* names and I/O register bit names appearing in the data book can be used.
;* 
;* The Register names are represented by their hexadecimal addresses.
;* 
;* The Register Bit names are represented by their bit number (0-7).
;* 
;* Please observe the difference in using the bit names with instructions
;* such as "sbr"/"cbr" (set/clear bit in register) and "sbrs"/"sbrc" 
;* (skip if bit in register set/cleared). The following example illustrates
;* this:
;* 
;* in	r16,PORTB		;read PORTB latch
;* sbr	r16,(1<<PB6)+(1<<PB5)	;set PB6 and PB5 (use masks, not bit#)
;* out  PORTB,r16		;output to PORTB
;*
;* in	r16,TIFR		;read the Timer Interrupt Flag Register
;* sbrc	r16,TOV0		;test the overflow flag (use bit#)
;* rjmp	TOV0_is_set		;jump if set
;* ...				;otherwise do something else
;***************************************************************************

;***** I/O Register Definitions
#define	SREG	 $3f
#define	SPL	 $3d
#define	GIMSK	 $3b
#define	GIFR	 $3a
#define	TIMSK	 $39
#define	TIFR	 $38
#define	MCUCR	 $35
#define	MCUSR	 $34
#define	TCCR0	 $33
#define	TCNT0	 $32
#define	WDTCR	 $21
#define	EEAR	 $1e
#define	EEARL	 $1e
#define	EEDR	 $1d
#define	EECR	 $1c
#define	PORTB	 $18
#define	DDRB	 $17
#define	PINB	 $16

;***** Bit Definitions

#define	EXTRF	 1
#define	PORF	 0

#define	INT0	 6
#define	INTF0	 6

#define	TOIE0	 1
#define	TOV0	 1

#define	SE	 5
#define	SM	 4
#define	ISC01	 1
#define	ISC00	 0

#define	CS02	 2
#define	CS01	 1
#define	CS00	 0

#define	WDTOE	 4
#define	WDE	 3
#define	WDP2	 2
#define	WDP1	 1
#define	WDP0	 0

#define	EEMWE	 2
#define	EEWE	 1
#define	EERE	 0

#define	PB4	 4
#define	PB3	 3
#define	PB2	 2
#define	PB1	 1
#define	PB0	 0

#define	DDB4	 4
#define	DDB3	 3
#define	DDB2	 2
#define	DDB1	 1
#define	DDB0	 0

#define	PINB4	 4
#define	PINB3	 3
#define	PINB2	 2
#define	PINB1	 1
#define	PINB0	 0

#define	XL	 r26
#define	XH	 r27
#define	YL	 r28
#define	YH	 r29
#define	ZL	 r30
#define	ZH	 r31

#define RAMEND   $DF    ;Last On-Chip SRAM Location
#define	XRAMEND  $DF
#define	E2END	 $7F
#define	FLASHEND $3FF


#define	INT0addr $001	;External Interrupt0 Vector Address
#define	OVF0addr $002	;Overflow0 Interrupt Vector Address

