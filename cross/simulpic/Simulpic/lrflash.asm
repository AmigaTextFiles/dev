;  PROGRAM              Switchshift.asm
;  Written by           Ian Stedman
;  Date                 25/11/97
;  For                  PIC 16C84
;  Resonator            455 KHZ Ceramic
;  Watchdog             Enabled
;  Code Protection      Off
;  Function             To turn on each Port b output in turn

        device 16c84
        osc xt
        fuse cp_off wdt_off pwrte_on
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
tmplo ram 1
tmphi ram 1
; In case of reset
        org 0x000
        goto start
; Interrupt vector
        org 0x004
        retfie
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

loop    bsf PORTB,0
        call delay
        bcf PORTB,0
        bsf PORTB,1
        call delay
        bcf PORTB,1
        bsf PORTB,2
        call delay
        bcf PORTB,2
        bsf PORTB,3
        call delay
        bcf PORTB,3
        bsf PORTB,4
        call delay
        bcf PORTB,4
        bsf PORTB,5
        call delay
        bcf PORTB,5
        bsf PORTB,6
        call delay
        bcf PORTB,6
        bsf PORTB,7
        call delay
        bcf PORTB,7
        bsf PORTB,6
        call delay
        bcf PORTB,6
        bsf PORTB,5
        call delay
        bcf PORTB,5
        bsf PORTB,4
        call delay
        bcf PORTB,4
        bsf PORTB,3
        call delay
        bcf PORTB,3
        bsf PORTB,2
        call delay
        bcf PORTB,2
        bsf PORTB,1
        call delay
        bcf PORTB,1

        goto loop

delay
        movlw 0x2
        movwf tmphi
wloophi
        movlw 0x2
        movwf tmplo
wlooplo
        decfsz tmplo,f
        goto wlooplo
        Decfsz tmphi,f
        goto wloophi
        return
