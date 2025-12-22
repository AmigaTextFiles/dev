;Include File for Pic12c508
;for use with PicASM from the Apic package
;It sets the processor to PIC16C54 which is code-compatible
;(12-bit CORE)


W EQU     H'0000'
F EQU     H'0001'

INDF        equ     0x00
TMR0        equ     0x01
PCL         equ     0x02
STATUS      equ     0x03
FSR         equ     0x04
OSCCAL      equ     0x05
GPIO        equ     0x06

;STATUS bits

C           equ     0
DC          equ     1
Z           equ     2
NOT_PD      equ     3
NOT_TO      equ     4
PA0         equ     5

GPWUF       equ     7

;OPTION bits

PSO         equ     0
PS1         equ     1
PS2         equ     2
PSA         equ     3
T0SE        equ     4
T0CS        equ     5
NOT_GPPU    equ     6
NOT_GPWU    equ     7

        PROCESSOR   pic16c54

       

