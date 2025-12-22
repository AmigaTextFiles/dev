;***************************************************************************
;* A P P L I C A T I O N   N O T E   F O R   T H E   A V R   F A M I L Y
;* 
;* Number		:AVR000
;* File Name		:"1200def.inc"
;* Title		:Register/Bit Definitions for the AT90S1200
;* Date	 		:97.12.11
;* Version		:1.22
;* Target MCU		:AT90S1200
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
#define	GIMSK	 $3b
#define	TIMSK	 $39
#define	TIFR	 $38
#define	MCUCR	 $35
#define	TCCR0	 $33
#define	TCNT0	 $32
#define	WDTCR	 $21
#define	EEAR	 $1e
#define	EEDR	 $1d
#define	EECR	 $1c
#define	PORTB	 $18
#define	DDRB	 $17
#define	PINB	 $16
#define	PORTD	 $12
#define	DDRD	 $11
#define	PIND	 $10
#define	ACSR	 $08

;***** Bit Definitions

#define	INT0	 6

#define	TOIE0	 1

#define	TOV0	 1

#define	SE	 5
#define	SM	 4
#define	ISC01	 1
#define	ISC00	 0

#define	CS02	 2
#define	CS01	 1
#define	CS00	 0

#define	WDE	 3
#define	WDP2	 2
#define	WDP1	 1
#define	WDP0	 0

#define	EEWE	 1
#define	EERE	 0

#define	PB7	 7
#define	PB6	 6
#define	PB5	 5
#define	PB4	 4
#define	PB3	 3
#define	PB2	 2
#define	PB1	 1
#define	PB0	 0

#define	DDB7	 7
#define	DDB6	 6
#define	DDB5	 5
#define	DDB4	 4
#define	DDB3	 3
#define	DDB2	 2
#define	DDB1	 1
#define	DDB0	 0

#define	PINB7	 7
#define	PINB6	 6
#define	PINB5	 5
#define	PINB4	 4
#define	PINB3	 3
#define	PINB2	 2
#define	PINB1	 1
#define	PINB0	 0

#define	PD6	 6
#define	PD5	 5
#define	PD4	 4
#define	PD3	 3
#define	PD2	 2
#define	PD1	 1
#define	PD0	 0

#define	DDD6	 6
#define	DDD5	 5
#define	DDD4	 4
#define	DDD3	 3
#define	DDD2	 2
#define	DDD1	 1
#define	DDD0	 0

#define	PIND6	 6
#define	PIND5	 5
#define	PIND4	 4
#define	PIND3	 3
#define	PIND2	 2
#define	PIND1	 1
#define	PIND0	 0

#define	ACD	 7
#define	ACO	 5
#define	ACI	 4
#define	ACIE	 3
#define	ACIS1	 1
#define	ACIS0	 0

#define	XRAMEND  $0
#define	E2END	 $3F
#define	FLASHEND $1FF

#define	INT0addr $001	;External Interrupt0 Vector Address
#define	OVF0addr $002	;Overflow0 Interrupt Vector Address
#define	ACIaddr  $003	;Analog Comparator Interrupt Vector Address

#define	ZL	 r30

