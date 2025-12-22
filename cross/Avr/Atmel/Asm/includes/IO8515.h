; Analog Comparator Control and Status Register ;
ACSR     	.EQU $08

; UART Baud Rate Register ;
UBRR	.EQU $09

; UART Control Register ;
UCR	.EQU $0A

; UART Status Register ;
USR	.EQU $0B

; UART IO Data Register ;
UDR	.EQU $0C

; SPI Control Register ;
SPCR	.EQU $0D

; SPI Status Register ;
SPSR	.EQU $0E

; SPI IO Data Register ;
SPDR	.EQU $0F

; Input Pins, Port D ;
PIND	.EQU $10

; Data Direction Register, Port D ;
DDRD	.EQU $11

; Data Register, Port D ;
PORTD	.EQU $12

; Input Pins, Port C ;
PINC	.EQU $13

; Data Direction Register, Port C ;
DDRC	.EQU $14

; Data Register, Port C ;
PORTC	.EQU $15

; Input Pins, Port B ;
PINB	.EQU $16

; Data Direction Register, Port B ;
DDRB	.EQU $17

; Data Register, Port B ;
PORTB	.EQU $18

; Input Pins, Port A ;
PINA	.EQU $19

; Data Direction Register, Port A ;
DDRA	.EQU $1A

; Data Register, Port A ;
PORTA	.EQU $1B

; EEPROM Control Register ;
EECR	.EQU $1C

; EEPROM Data Register ;
EEDR	.EQU $1D

; EEPROM Address Register ;
EEAR	.EQU $1E
EEARL	.EQU $1E
EEARH	.EQU $1F

; Watchdog Timer Control Register ;
WDTCR	.EQU $21

; TC 1 Input Capture Register ;
ICR1	.EQU $24
ICR1L	.EQU $24
ICR1H	.EQU $25

; TimerCounter1 Output Compare Register B ;
OCR1B	.EQU $28
OCR1BL	.EQU $28
OCR1BH	.EQU $29

; TimerCounter1 Output Compare Register A ;
OCR1A	.EQU $2A
OCR1AL	.EQU $2A
OCR1AH	.EQU $2B

; TimerCounter 1 ;
TCNT1	.EQU $2C
TCNT1L	.EQU $2C
TCNT1H	.EQU $2D

; TimerCounter 1 Control and Status Register ;
TCCR1B	.EQU $2E

; TimerCounter 1 Control Register ;
TCCR1A	.EQU $2F

; TimerCounter 0 ;
TCNT0	.EQU $32

; TimerCounter 0 Control Register ;
TCCR0	.EQU $33

; MCU general Control Register ;
MCUCR	.EQU $35

; TimerCounter Interrupt Flag register ;
TIFR	.EQU $38

; TimerCounter Interrupt MaSK register ;
TIMSK	.EQU $39

; General Interrupt Flag Register ;
GIFR .EQU $3A

; General Interrupt MaSK register ;
GIMSK	.EQU $3B

; Stack Pointer ;
SP		.EQU $3D
SPL	.EQU $3D
SPH	.EQU $3E

; Status REGister ;
SREG	.EQU $3F


RESET_vect		.EQU   $00
INT0_vect		.EQU   $01
INT1_vect		.EQU   $02
TIMER1_CAPT1_vect	.EQU   $03
TIMER1_COMPA_vect	.EQU   $04
TIMER1_COMPB_vect	.EQU   $05
TIMER1_OVF1_vect	.EQU   $06
TIMER0_OVF0_vect	.EQU   $07
SPI_STC_vect		.EQU   $08
UART_RX_vect		.EQU   $09
UART_UDRE_vect		.EQU   $0A
UART_TX_vect		.EQU   $0B
ANA_COMP_vect		.EQU   $0D

ROMSTART  .EQU  $0E

