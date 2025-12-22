 ;Internal registers of the AT90S2313.

 ;Analog Comparator Control and Status Register 
ACSR    EQU    $08

 ;UART Baud Rate Register  
UBRR	EQU    $09

 ; UART Control Register  
UCR	EQU    $0A

 ; UART Status Register  
USR	EQU    $0B

 ; UART I/O Data Register  
UDR	EQU    $0C

 ; Input Pins, Port D  
PIND	EQU    $10

 ; Data Direction Register, Port D  
DDRD	EQU    $11

 ; Data Register, Port D  
PORTD	EQU    $12

 ; Input Pins, Port B  
PINB	EQU    $16

 ; Data Direction Register, Port B  
DDRB	EQU    $17

 ; Data Register, Port B  
PORTB	EQU    $18

 ; EEPROM Control Register  
EECR	EQU    $1C

 ; EEPROM Data Register  
EEDR	EQU    $1D

 ; EEPROM Address Register  
EEAR	EQU    $1E

 ; Watchdog Timer Control Register  
WDTCR	EQU    $21

 ; T/C 1 Input Capture Register  
ICR1	EQU    $24
ICR1L	EQU    $24
ICR1H	EQU    $25

 ; Output Compare Register 1  
OCR1	EQU    $2A
OCR1AL	EQU    $2A
OCR1AH	EQU    $2B

 ; Timer/Counter 1  
TCNT1	EQU    $2C
TCNT1L	EQU    $2C
TCNT1H	EQU    $2D

 ; Timer/Counter 1 Control and Status Register  
TCCR1B	EQU    $2E

 ; Timer/Counter 1 Control Register  
TCCR1A	EQU    $2F

 ; Timer/Counter 0  
TCNT0	EQU    $32

 ; Timer/Counter 0 Control Register  
TCCR0	EQU    $33

 ; MCU general Control Register  
MCUCR	EQU    $35

 ; Timer/Counter Interrupt Flag register  
TIFR	EQU    $38

 ; Timer/Counter Interrupt MaSK register  
TIMSK	EQU    $39

 ; General Interrupt Flag Register  
GIFR    EQU    $3A

 ; General Interrupt MaSK register  
GIMSK	EQU    $3B

 ; Stack Pointer  
SP      EQU    $3D

 ; Status REGister  
SREG	EQU    $3F


RESET_vect          EQU   $00
INT0_vect           EQU   $01
INT1_vect           EQU   $02
TIMER1_CAPT1_vect   EQU   $03
TIMER1_COMP1_vect   EQU   $04
TIMER1_OVF1_vect    EQU   $05
TIMER0_OVF0_vect    EQU   $06
UART_RX_vect        EQU   $07
UART_UDRE_vect      EQU   $08
UART_TX_vect        EQU   $09
ANA_COMP_vect       EQU   $0A

ROMSTART  EQU $0B

