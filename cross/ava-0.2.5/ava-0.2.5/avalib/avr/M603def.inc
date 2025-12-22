;***************************************************************************
;* A P P L I C A T I O N   N O T E   F O R   T H E   A V R   F A M I L Y
;* 
;* Number		:AVR000
;* File Name		:"M603def.inc"
;* Title		:Register/Bit Definitions for the ATM603
;* Date                 :98.05.22
;* Version              :1.22
;* Target MCU		:ATM603
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
;***************************************************************************

;***** I/O Register Definitions
#define	SREG	 $3f
#define	SPH	 $3e
#define	SPL	 $3d
#define    XDIV	 $3c
#define    RAMPZ    $3b
#define    EICR     $3a
#define	EIMSK	 $39
#define	EIFR	 $38
#define	TIMSK	 $37
#define	TIFR	 $36
#define	MCUCR	 $35
#define    MCUSR    $34

#define	TCCR0	 $33
#define	TCNT0	 $32
#define	OCR0	 $31
#define    ASSR0    $30

#define	TCCR1A	 $2f
#define	TCCR1B	 $2e
#define	TCNT1H	 $2d
#define	TCNT1L	 $2c
#define	OCR1AH	 $2b
#define	OCR1AL	 $2a
#define	OCR1BH	 $29
#define	OCR1BL	 $28
#define	ICR1H	 $27
#define	ICR1L	 $26

#define    TCCR2    $25
#define    TCNT2    $24
#define    OCR2     $23
#define	WDTCR	 $21

#define	EEARH	 $1f
#define	EEARL	 $1e
#define	EEDR	 $1d
#define	EECR	 $1c

#define	PORTA	 $1b
#define	DDRA	 $1a
#define	PINA	 $19
#define	PORTB	 $18
#define	DDRB	 $17
#define	PINB	 $16
#define	PORTC	 $15
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
#define	ACSR	 $08
#define    ADMUX    $07
#define    ADCSR    $06
#define    ADCH     $05
#define    ADCL     $04
#define    PORTE    $03
#define    DDRE     $02
#define    PINE     $01
#define    PINF     $00

;***** Bit Definitions

#define 	RAMPZ0	 0

#define	SRE	 7
#define	SRW	 6
#define	SE	 5
#define	SM1	 4
#define	SM0	 3

#define	XDIVEN	 7
#define	XDIV6	 6
#define	XDIV5	 5
#define	XDIV4	 4
#define	XDIV3	 3
#define	XDIV2	 2
#define	XDIV1	 1
#define	XDIV0	 0

#define	EXTRF	 1
#define	PORF	 0

#define	INT7	 7
#define	INT6	 6
#define	INT5	 5
#define	INT4	 4
#define	INT3	 3
#define	INT2	 2
#define	INT1	 1
#define	INT0	 0

#define	INTF7	 7
#define	INTF6	 6
#define	INTF5	 5
#define	INTF4	 4

#define	ISC71	 7
#define	ISC70	 6
#define	ISC61	 5
#define	ISC60	 4
#define	ISC51	 3
#define	ISC50	 2
#define	ISC41	 1
#define	ISC40	 0

#define	OCIE2	 7
#define	TOIE2	 6
#define	TICIE1	 5
#define	OCIE1A	 4
#define	OCIE1B	 3
#define	TOIE1	 2
#define	OCIE0	 1
#define	TOIE0	 0

#define	OCF2	 7
#define	TOV2	 6
#define	ICF1	 5
#define	OCF1A	 4
#define	OCF1B	 3
#define	TOV1	 2
#define	OCF0	 1
#define	TOV0	 0

#define    PWM0     6
#define	COM01	 5
#define	COM00	 4
#define	CTC0	 3
#define	CS02	 2
#define	CS01	 1
#define	CS00	 0

#define    PWM2     6
#define	COM21	 5
#define	COM20	 4
#define	CTC2	 3
#define	CS22	 2
#define	CS21	 1
#define	CS20	 0

#define	AS0	 3
#define	TCN0UB	 2
#define	OCR0UB	 1
#define	TCR0UB	 0

#define	COM1A1	 7
#define	COM1A0	 6
#define	COM1B1	 5
#define	COM1B0	 4
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

#define    EERIE	 3
#define	EEMWE	 2
#define	EEWE	 1
#define	EERE	 0

#define	PA7	 7
#define	PA6	 6
#define	PA5	 5
#define	PA4	 4
#define	PA3	 3
#define	PA2	 2
#define	PA1	 1
#define	PA0	 0

#define	PINA7	 7
#define	PINA6	 6
#define	PINA5	 5
#define	PINA4	 4
#define	PINA3	 3
#define	PINA2	 2
#define	PINA1	 1
#define	PINA0	 0

#define	DDA7	 7
#define	DDA6	 6
#define	DDA5	 5
#define	DDA4	 4
#define	DDA3	 3
#define	DDA2	 2
#define	DDA1	 1
#define	DDA0	 0

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

#define	PC7	 7
#define	PC6	 6
#define	PC5	 5
#define	PC4	 4
#define	PC3	 3
#define	PC2	 2
#define	PC1	 1
#define	PC0	 0

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

#define	PE7	 7
#define	PE6	 6
#define	PE5	 5
#define	PE4	 4
#define	PE3	 3
#define	PE2	 2
#define	PE1	 1
#define	PE0	 0

#define	DDE7	 7
#define	DDE6	 6
#define	DDE5	 5
#define	DDE4	 4
#define	DDE3	 3
#define	DDE2	 2
#define	DDE1	 1
#define	DDE0	 0

#define	PINE7	 7
#define	PINE6	 6
#define	PINE5	 5
#define	PINE4	 4
#define	PINE3	 3
#define	PINE2	 2
#define	PINE1	 1
#define	PINE0	 0

#define	PINF7	 7
#define	PINF6	 6
#define	PINF5	 5
#define	PINF4	 4
#define	PINF3	 3
#define	PINF2	 2
#define	PINF1	 1
#define	PINF0	 0

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

#define	ADEN	 7
#define	ADSC	 6
#define	ADFR	 5
#define	ADIF	 4
#define	ADIE	 3
#define	ADPS2	 2
#define	ADPS1	 1
#define	ADPS0	 0

#define	MUX2	 2
#define	MUX1	 1
#define	MUX0	 0

#define	XL	 r26
#define	XH	 r27
#define	YL	 r28
#define	YH	 r29
#define	ZL	 r30
#define	ZH	 r31

#define 	RAMEND 	 $0FFF	;Last On-Chip SRAM Location
#define	XRAMEND  $FFFF
#define	E2END	 $07FF
#define	FLASHEND $7FFF

#define	INT0addr $002	;External Interrupt0 Vector Address
#define	INT1addr $004	;External Interrupt1 Vector Address
#define	INT2addr $006	;External Interrupt2 Vector Address
#define	INT3addr $008	;External Interrupt3 Vector Address
#define	INT4addr $00a	;External Interrupt4 Vector Address
#define	INT5addr $00c	;External Interrupt5 Vector Address
#define	INT6addr $00e	;External Interrupt6 Vector Address
#define	INT7addr $010	;External Interrupt7 Vector Address
#define	OC2addr  $012	;Output Compare2 Interrupt Vector Address
#define	OVF2addr $014	;Overflow2 Interrupt Vector Address
#define	ICP1addr $016	;Input Capture1 Interrupt Vector Address
#define	OC1Aaddr $018	;Output Compare1A Interrupt Vector Address
#define	OC1Baddr $01a	;Output Compare1B Interrupt Vector Address
#define	OVF1addr $01c	;Overflow1 Interrupt Vector Address
#define	OC0addr  $01e	;Output Compare0 Interrupt Vector Address
#define	OVF0addr $020	;Overflow0 Interrupt Vector Address
#define	SPIaddr  $022	;SPI Interrupt Vector Address
#define	URXCaddr $024	;UART Receive Complete Interrupt Vector Address
#define	UDREaddr $026	;UART Data Register Empty Interrupt Vector Address
#define	UTXCaddr $028	;UART Transmit Complete Interrupt Vector Address
#define    ADCCaddr $02a   ;ADC Conversion Complete Handle
#define    EEWRaddr $02c   ;EEPROM Write Complete Handle
#define	ACIaddr  $02e	;Analog Comparator Interrupt Vector Address

