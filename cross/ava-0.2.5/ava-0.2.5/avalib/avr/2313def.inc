;***************************************************************************
;* A P P L I C A T I O N   N O T E   F O R   T H E   A V R   F A M I L Y
;* 
;* Number		:AVR000
;* File Name		:"2313def.inc"
;* Title		:Register/Bit Definitions for the AT90S2313
;* Date	 		:98.05.22
;* Version		:1.22
;* Target MCU		:AT90S2313
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
#define	TCCR0	 $33
#define	TCNT0	 $32
#define	TCCR1A	 $2f
#define	TCCR1B	 $2e
#define	TCNT1H	 $2d
#define	TCNT1L	 $2c
#define	OCR1AH	 $2b
#define	OCR1AL	 $2a
#define	ICR1H	 $25
#define	ICR1L	 $24
#define	WDTCR	 $21
#define	EEAR	 $1e
#define	EEARL	 $1e
#define	EEDR	 $1d
#define	EECR	 $1c
#define	PORTB	 $18
#define	DDRB	 $17
#define	PINB	 $16
#define	PORTD	 $12
#define	DDRD	 $11
#define	PIND	 $10
#define	UDR	 $0c
#define	USR	 $0b
#define	UCR	 $0a
#define	UBRR	 $09
#define	ACSR	 $08


;***** Bit Definitions
#define	SP7	 7
#define	SP6	 6
#define	SP5	 5
#define	SP4	 4
#define	SP3	 3
#define	SP2	 2
#define	SP1	 1
#define	SP0	 0

#define	INT1	 7
#define	INT0	 6

#define	INTF1	 7
#define	INTF0	 6

#define	TOIE1	 7
#define	OCIE1A	 6
#define	TICIE	 3
#define	TOIE0	 1

#define	TOV1	 7
#define	OCF1A	 6
#define	ICF1	 3
#define	TOV0	 1

#define	SE	 5
#define	SM	 4
#define	ISC11	 3
#define	ISC10	 2
#define	ISC01	 1
#define	ISC00	 0

#define	CS02	 2
#define	CS01	 1
#define	CS00	 0

#define	COM1A1	 7
#define	COM1A0	 6
#define	PWM11	 1
#define	PWM10	 0

#define	ICNC1	 7
#define	ICES1	 6
#define	CTC1	 3
#define	CS12	 2
#define	CS11	 1
#define	CS10	 0

#define	WDTOE	 4
#define	WDE	 3
#define	WDP2	 2
#define	WDP1	 1
#define	WDP0	 0

#define	EEMWE	 2
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

#define	RXC	 7
#define	TXC	 6
#define	UDRE	 5
#define	FE	 4
#define	OR	 3

#define	RXCIE	 7
#define	TXCIE	 6
#define	UDRIE	 5
#define	RXEN	 4
#define	TXEN	 3
#define	CHR9	 2
#define	RXB8	 1
#define	TXB8	 0

#define	ACD	 7
#define	ACO	 5
#define	ACI	 4
#define	ACIE	 3
#define	ACIC	 2
#define	ACIS1	 1
#define	ACIS0	 0

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
#define	INT1addr $002	;External Interrupt1 Vector Address
#define	ICP1addr $003	;Input Capture1 Interrupt Vector Address
#define	OC1addr  $004	;Output Compare1 Interrupt Vector Address
#define	OVF1addr $005	;Overflow1 Interrupt Vector Address
#define	OVF0addr $006	;Overflow0 Interrupt Vector Address
#define	URXCaddr $007	;UART Receive Complete Interrupt Vector Address
#define	UDREaddr $008	;UART Data Register Empty Interrupt Vector Address
#define	UTXCaddr $009	;UART Transmit Complete Interrupt Vector Address
#define	ACIaddr  $00a	;Analog Comparator Interrupt Vector Address

