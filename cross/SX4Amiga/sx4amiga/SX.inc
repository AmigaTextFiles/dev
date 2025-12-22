;Include File for the SX chips form Scenix
;for use with PicASM from the Apic package
;It sets the processor to PIC16C57 which is (almost) code-compatible

;W and F contstants

W EQU     H'0000'
F EQU     H'0001'

;Special Function Registers (SX18/SX28)

INDF        equ     0x00
RTCC        equ     0x01
PC          equ     0x02
STATUS      equ     0x03
FSR         equ     0x04
RA          equ     0x05
RB          equ     0x06
RC          equ     0x07

;STATUS bits

C           equ     0
DC          equ     1
Z           equ     2
NOT_PD      equ     3
NOT_TO      equ     4
PA0         equ     5
PA1         equ     6
PA2         equ     7

;OPTION bits

PSO         equ     0
PS1         equ     1
PS2         equ     2
PSA         equ     3
RTE_ES      equ     4
RTS         equ     5
RTE_IE      equ     6
RTW         equ     7



;bank switch macro's

            macro   BANK0
            bcf     STATUS,PA0
            bcf     STATUS,PA1
            endm

            macro   BANK1
            bsf     STATUS,PA0
            bcf     STATUS,PA1
            endm

            macro   BANK2
            bcf     STATUS,PA0
            bsf     STATUS,PA1
            endm

            macro   BANK3
            bsf     STATUS,PA0
            bsf     STATUS,PA1
            endm

;tris macro's for SX specific opcodes

            macro   mode
            bcf     0x02,1  ;MODE
            endm

            macro   ret
            bcf     0x02,2  ;RET
            endm

            macro   reti
            bcf     0x02,3  ;RETI
            endm

;set assembler to SX-compatible type

            PROCESSOR   pic16c57

