
 ; Analog Comparator Control and Status Register 
ACSR:    .EQU $08

 ; UART Baud Rate Register 
UBRR:    .EQU $09

 ; UART Control Register 
UCR:     .EQU $0A

 ; UART Status Register 
USR:     .EQU $0B

 ; UART I/O Data Register 
UDR:     .EQU $0C

 ; SPI Control Register 
SPCR:    .EQU $0D

 ; SPI Status Register 
SPSR:    .EQU $0E

 ; SPI I/O Data Register 
SPDR:    .EQU $0F

 ; Input Pins, Port D 
PIND:    .EQU $10

 ; Data Direction Register, Port D 
DDRD:    .EQU $11

 ; Data Register, Port D 
PORTD:   .EQU $12

 ; Input Pins, Port C 
PINC:    .EQU $13

 ; Data Direction Register, Port C 
DDRC:    .EQU $14

 ; Data Register, Port C 
PORTC:   .EQU $15

 ; Input Pins, Port B 
PINB:    .EQU $16

 ; Data Direction Register, Port B 
DDRB:    .EQU $17

 ; Data Register, Port B 
PORTB:   .EQU $18

 ; Input Pins, Port A 
PINA:    .EQU $19

 ; Data Direction Register, Port A 
DDRA:    .EQU $1A

 ; Data Register, Port A 
PORTA:   .EQU $1B

 ; EEPROM Control Register 
EECR:    .EQU $1C

 ; EEPROM Data Register 
EEDR:    .EQU $1D

 ; EEPROM Address Register 
EEAR:    .EQU $1E

 ; Watchdog Timer Control Register 
WDTCR:   .EQU $21

 ; T/C 1 Input Capture Register 
ICR1:    .EQU $24
ICR1L:   .EQU $24
ICR1H:   .EQU $25

 ; Timer/Counter1 Output Compare Register B 
OCR1B:   .EQU $28
OCR1BL:  .EQU $28
OCR1BH:  .EQU $29

 ; Timer/Counter1 Output Compare Register A 
OCR1A:   .EQU $2A
OCR1AL:  .EQU $2A
OCR1AH:  .EQU $2B

 ; Timer/Counter 1 
TCNT1:   .EQU $2C
TCNT1L:  .EQU $2C
TCNT1H:  .EQU $2D

 ; Timer/Counter 1 Control and Status Register 
TCCR1B:  .EQU $2E

 ; Timer/Counter 1 Control Register 
TCCR1A:  .EQU $2F

 ; Timer/Counter 0 
TCNT0:   .EQU $32

 ; Timer/Counter 0 Control Register 
TCCR0:   .EQU $33

 ; MCU general Control Register 
MCUCR:   .EQU $35

 ; Timer/Counter Interrupt Flag register 
TIFR:    .EQU $38

 ; Timer/Counter Interrupt MaSK register 
TIMSK:   .EQU $39

 ; General Interrupt Flag Register 
GIFR: .EQU $3A

 ; General Interrupt MaSK register 
GIMSK:   .EQU $3B

 ; Stack Pointer 
SP:              .EQU $3D
SPL:     .EQU $3D
SPH:     .EQU $3E

 ; Status REGister 
SREG:    .EQU $3F



RESET_VECT:              .EQU   $00
INT0_VECT:               .EQU   $01
INT1_VECT:               .EQU   $02
TIMER1_CAPT1_VECT:       .EQU   $03
TIMER1_COMPA_VECT:       .EQU   $04
TIMER1_COMPB_VECT:       .EQU   $05
TIMER1_OVF1_VECT:        .EQU   $06
TIMER0_OVF0_VECT:        .EQU   $07
SPI_STC_VECT:            .EQU   $08
UART_RX_VECT:            .EQU   $09
UART_UDRE_VECT:          .EQU   $0A
UART_TX_VECT:            .EQU   $0B
ANA_COMP_VECT:           .EQU   $0C

ROMSTART  .EQU $0D

