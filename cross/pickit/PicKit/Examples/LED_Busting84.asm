;DEVICE 16C84
;*********************************
;*          LED Busting          *
;*   source code for p84 cpu's   *
;* (C) Tommy 23.01.1996, 10:51am *
;*      With new directives      *
;*********************************

FREGS   EQU     0x0C

TMP0    EQU     FREGS+0x00
TMP1    EQU     FREGS+0x01

        DEBUG

        Include "16C84.DEF"                 ;change this path to your
                                            ;current directory
        ID      0x00FF

        FUSE    PWRTE|CPOFF|XT
        OUTPUT  INHX16

;*********************************
;*            Main code          *
;*********************************

start   ORG     0x0000

        movlw   0xC8
        movwf   TMP1

        clrf    PORTA
        clrf    PORTB

        clrw
        tris    PORTB
        tris    PORTA


loop    comf    PORTA,f
        comf    PORTB
        call    wait

        goto    loop

wait    movlw   0xFA
        movwf   TMP0

wait2   nop
        nop
        nop
        nop
        nop
        decfsz  TMP0,f
        goto    wait2

        decfsz  TMP1,f
        goto    wait

        movlw   0xC8
        movwf   TMP1
        return
