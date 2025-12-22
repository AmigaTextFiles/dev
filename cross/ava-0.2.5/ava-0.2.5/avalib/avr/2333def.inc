;***************************************************************************
;* A P P L I C A T I O N   N O T E   F O R   T H E   A V R   F A M I L Y
;* 
;* Number		:AVR000
;* File Name		:"2333def.inc"
;* Title		:Register/Bit Definitions for the AT90S2333
;* Date                 :96.10.30
;* Version              :1.23
;* Target MCU		:AT90S2333
;*
;* DESCRIPTION
;* When including this file in the assembly program file, all I/O register	
;* names and I/O register bit names appearing in the data book can be used.
;* In addition, the six registers forming the three data pointers X, Y and
;* Z have been assigned names XL - ZH. Highest RAM address for Internal 
;* SRAM is also defined 
;*
;* The Register names are represented by their hexadecimal address.
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

;***** I/O Register Definitions
#define	SREG	 $3f
#define	SP	 $3d
#define	SPL	 $3d
#define	GIMSK	 $3b
#define	GIFR	 $3a
#define	TIMSK	 $39
#define	TIFR	 $38
#define MCUCR    $35
#define MCUSR    $34
#define	TCCR0	 $33
#define	TCNT0	 $32
#define	TCCR1A	 $2f
#define	TCCR1B	 $2e
#define	TCNT1H	 $2d
#define	TCNT1L	 $2c
#define	OCR1H	 $2b
#define	OCR1L	 $2a
#define	ICR1H	 $27
#define	ICR1L	 $26
#define	WDTCR	 $21
#define	EEAR	 $1e
#define	EEDR	 $1d
#define	EECR	 $1c
#define	PORTB	 $18
#define	DDRB	 $17
#define	PINB	 $16
#define	PORTC	 $15
#define	DDRC	 $14
#define	PINC	 $13
#define	PORTD	 $12
#define	DDRD	 $11
#define	PIND	 $10
#define	SPDR	 $0f
#define	SPSR	 $0e
#define	SPCR	 $0d
#define	UDR	 $0c
#define	USR	 $0b
#define	UCR	 $0a
#define	UBRR	 $09
#define	UBRRL	 $09
#define	ACSR	 $08
#define ADMUX    $07
#define ADCSR    $06
#define ADCH     $05
#define ADCL     $04
#define	UBRRH	 $03


;***** Bit Definitions

#define	WDRF	 3
#define	BORF	 2
#define	EXTRF	 1
#define	PORF	 0

#define	INT1	 7
#define	INT0	 6

#define	INTF1	 7
#define	INTF0	 6


#define TOIE1    7
#define OCIE1    6
#define TICIE1   3
#define TOIE0    1

#define TOV1     7
#define OCF1     6
#define ICF1     3
#define TOV0     1

#define SE       5
#define SM       4
#define ISC11    3
#define ISC10    2
#define ISC01    1
#define ISC00    0

#define	CS02	 2
#define	CS01	 1
#define	CS00	 0

#define	COM11	 7
#define	COM10	 6
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

#define EERIE    3
#define	EEMWE	 2
#define	EEWE	 1
#define	EERE	 0

#define	SPIE	 7
#define	SPE	 6
#define	DORD	 5
#define	MSTR	 4
#define	CPOL	 3
#define	CPHA	 2
#define	SPR1	 1
#define	SPR0	 0

#define	SPIF	 7
#define	WCOL	 6

#define	RXC	 7
#define	TXC	 6
#define	UDRE	 5
#define	FE	 4
#define	OR	 3
#define MPCM     0

#define	RXCIE	 7
#define	TXCIE	 6
#define	UDRIE	 5
#define	RXEN	 4
#define	TXEN	 3
#define	CHR9	 2
#define	RXB8	 1
#define	TXB8	 0

#define	ACD	 7
#define	AINBG 	 6
#define	ACO	 5
#define	ACI	 4
#define	ACIE	 3
#define	ACIC	 2
#define	ACIS1	 1
#define	ACIS0	 0

#define	ADCBG	 6
#define MUX2     2
#define MUX1     1
#define MUX0     0

#define ADEN     7
#define ADSC     6
#define ADFR     5
#define ADIF     4
#define ADIE     3
#define ADPS2    2
#define ADPS1    1
#define ADPS0    0

#define	PB5	 5
#define	PB4	 4
#define	PB3	 3
#define	PB2	 2
#define	PB1	 1
#define	PB0	 0

#define	DDB5	 5
#define	DDB4	 4
#define	DDB3	 3
#define	DDB2	 2
#define	DDB1	 1
#define	DDB0	 0

#define	PINB5	 5
#define	PINB4	 4
#define	PINB3	 3
#define	PINB2	 2
#define	PINB1	 1
#define	PINB0	 0

#define	PC5	 5
#define	PC4	 4
#define	PC3	 3
#define	PC2	 2
#define	PC1	 1
#define	PC0	 0

#define	DDC5	 5
#define	DDC4	 4
#define	DDC3	 3
#define	DDC2	 2
#define	DDC1	 1
#define	DDC0	 0

#define	PINC5	 5
#define	PINC4	 4
#define	PINC3	 3
#define	PINC2	 2
#define	PINC1	 1
#define	PINC0	 0

#define	PD7	 7
#define	PD6	 6
#define	PD5	 5
#define	PD4	 4
#define	PD3	 3
#define	PD2	 2
#define	PD1	 1
#define	PD0	 0

#define	DDD7	 7
#define	DDD6	 6
#define	DDD5	 5
#define	DDD4	 4
#define	DDD3	 3
#define	DDD2	 2
#define	DDD1	 1
#define	DDD0	 0

#define	PIND7	 7
#define	PIND6	 6
#define	PIND5	 5
#define	PIND4	 4
#define	PIND3	 3
#define	PIND2	 2
#define	PIND1	 1
#define	PIND0	 0


#define	XL	 r26
#define	XH	 r27
#define	YL	 r28
#define	YH	 r29
#define	ZL	 r30
#define	ZH	 r31

#define RAMEND   $DF	;Last On-Chip SRAM Location
#define	XRAMEND  $DF
#define	E2END	 $7F
#define	FLASHEND $3FF

#define	INT0addr $001	;External Interrupt0 Vector Address
#define	INT1addr $002	;External Interrupt1 Vector Address
#define	ICP1addr $003	;Input Capture1 Interrupt Vector Address
#define	OC1Aaddr $004	;Output Compare1A Interrupt Vector Address
#define	OVF1addr $005	;Overflow1 Interrupt Vector Address
#define	OVF0addr $006	;Overflow0 Interrupt Vector Address
#define	SPIaddr  $007	;SPI Interrupt Vector Address
#define	URXCaddr $008	;UART Receive Complete Interrupt Vector Address
#define	UDREaddr $009	;UART Data Register Empty Interrupt Vector Address
#define	UTXCaddr $00a	;UART Transmit Complete Interrupt Vector Address
#define	ADCCaddr $00b	;ADC Interrupt Vector Address
#define	ERDYaddr $00c	;EEPROM Interrupt Vector Address
#define	ACIaddr  $00d	;Analog Comparator Interrupt Vector Address

