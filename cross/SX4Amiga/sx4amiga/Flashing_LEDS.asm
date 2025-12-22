;FLASHING LEDS
;Example code for SX28 processor
;This code flashes leds on and off on all I/O lines (RA,RB,RC)

;PROCESSOR=SX28AC
;FUSE=0xE0B
;FUSEX=0xFFF


;NOTE1:  The processor,fuse and fusex settings are not taken over by the programmer
;        but must be entered manually on programming time

;NOTE2:  The programmer will ignore bits 11:7 of FUSEX. ITis therefore perfectly
;        possible that a value different from the one you specified will be
;        programmed into the SX chip.




;Variables

countA          equ 0x08
countB          equ 0x09




                include "SX.inc"                ; INCLUDE file for SX processor



                org     0x000

Start           movlw   0x00                    ; set DDR/TRIS register
                tris    RA                      ; (all ports output)
                tris    RB
                tris    RC

Loop            movlw   0x0f                    ; All I/O lines HIGH
                movwf   RA
                movlw   0xff
                movwf   RB
                movlw   0xff
                movwf   RC

                call    Delay

                movlw   0x00                    ; All I/O lines LOW
                movwf   RA
                movwf   RB
                movwf   RC

                call    Delay

                goto    Loop









Delay           nop                             ; Double Delay Loop
                decfsz  countB
                goto    Delay

                decfsz  countA
                goto    Delay

                ret






                org     0x7ff                   ; RESET vector

                goto    Start




