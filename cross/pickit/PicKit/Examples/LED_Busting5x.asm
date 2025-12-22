;DEVICE 16C54
;*********************************
;*          LED Busting          *
;*   source code for p84 cpu's   *
;* (C) Tommy 23.01.1996, 10:51am *
;*      With new directives      *
;*********************************

FREG    EQU     0x08

TMP0    EQU     FREG+0x0
TMP1    EQU     FREG+0x1

        DEBUG

        INCLUDE "16C54.DEF"                 ;change this path to your
                                            ;current directory
        ID      0x00FF
        FUSE    CPOFF|XT
        RESET   0x0000
        OUTPUT  INHX16

;*********************************
;*            Main code          *
;*********************************

start   ORG     0x000

        movlw   0xC8
        movwf   TMP1

        clrf    PORTA
        clrf    PORTB

        clrw
        tris    PORTB
        tris    PORTA

loop    comf    PORTA
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
        retlw   0
