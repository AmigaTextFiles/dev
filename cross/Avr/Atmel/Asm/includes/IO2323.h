
; Input Pins, Port B 
 PINB    EQU  $16;

; Data Direction Register, Port B 
 DDRB    EQU  $17;

; Data Register, Port B 
 PORTB    EQU  $18;

; EEPROM Control Register 
 EECR    EQU  $1C;

; EEPROM Data Register 
 EEDR    EQU  $1D;

; EEPROM Address Register Low 
 EEARL   EQU  $1E;          
 EEAR    EQU  $1E;

; Watchdog Timer Control Register 
 WDTCR    EQU  $21;

; Timer/Counter 0 
 TCNT0    EQU  $32;

; Timer/Counter 0 Control Register 
 TCCR0    EQU  $33;

; MCU Status Register 
 MCUSR    EQU  $34;

; MCU general Control Register 
 MCUCR    EQU  $35;

; Timer/Counter Interrupt Flag register 
 TIFR    EQU  $38;

; Timer/Counter Interrupt MaSK register 
 TIMSK    EQU  $39;

; General Interrupt Flag register 
 GIFR    EQU  $3A;

; General Interrupt MaSK register 
 GIMSK    EQU  $3B;

; Stack Pointer 
sfrw SP     EQU  $3D;
 SPL    EQU  $3D;

; Status REGister 
 SREG   EQU  $3F;



RESET_vect  EQU         $00
INT0_vect   EQU         $01
TIMER0_OVF0_vect  EQU   $02

ROMSTART  EQU $03

