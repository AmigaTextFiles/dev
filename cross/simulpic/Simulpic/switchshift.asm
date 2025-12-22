;  PROGRAM              Switchshift.asm
;  Written by           Ian Stedman
;  Date                 25/11/97
;  For                  PIC 16C84
;  Resonator            1 MHZ Ceramic
;  Instruction time     0.25 uS
;  Watchdog             Enabled
;  Code Protection      Off
;  Function             To read in a code from 4 switches on Port A,
;                  multiply by 2 and display the result on port B.

DEVICE 16c84
XT_OSC
PROTECT_OFF WDT_OFF PUT_OFF
rtcc equ 1
count equ 0x0B
input equ 0x0D
option equ 0x81
PA0 equ 0
PA1 equ 1
PA2 equ 2
PA3 equ 3
PB0 equ 0
PB1 equ 1
PB2 equ 2
PB3 equ 3
PB4 equ 4
PB5 equ 5
PB6 equ 6
PB7 equ 7
; In case of reset
;        org 0
;        goto start
; Interrupt vector
;        org 4
;        retfie
start
        clrf  PORTA  ; clear port
        movlw 0xFF
        bsf   STATUS,RP0
        movwf TRISA  ; Set port A as inputs.
        bcf   STATUS,RP0
        clrf  PORTB  ; Set Port B as outputs.
        clrw
        bsf   STATUS,RP0
        movwf TRISB  ; Port A, input, Port B, output.
        bcf   STATUS,RP0
        movlw 0x00

loopy   movwf PORTB
        addlw 0x01
        call  delay
  goto  loopy

delay   nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        return
