 include "io2313.h"

ECLK   def PORTD,5
RS     def PORTD,3
RW     def PORTD,4
CS     def PORTD,6

 org RESET_vect
 rjmp start

 org ROMSTART

start:

 ldi R16,$DF
 out SP,R16         ;load stack pointer.

 ldi R16,255
 out DDRB,R16       ; Port B, data lines.  All outputs.

 ldi R16,$78           ;0111 1000
 out DDRD,R16

 rcall SetupLCD
 
 ldi R17,63
loop:
 rcall WaitLCD
 ldi R16,$0C
 rcall WriteCMD
 mov R16,R17
 rcall WriteDAT
 inc R17

 ldi R20,10
l1:
 dec R18
 brne l1
 dec R19
 brne l1
 dec R20
 brne l1

 rjmp loop

;/\/\/\/\/\/\/\
;| Subroutines|
;\/\/\/\/\/\/\/

;--------------------------
;SetupLCD
; Sets up the lcd
;--------------------------
SetupLCD:
 ldi    R30,(SetupInfo * 2) & 255
 ldi    R31,(SetupInfo * 2) >> 8
moresetup:
 rcall  WaitLCD
 lpm
 adiw   R30,1    ;Inc Z
 mov    R16,R0
 cpi    R16,$FF
 brne   isok
 ret
isok:
 rcall  WriteCMD
 lpm
 adiw   R30,1
 mov    R16,R0
 rcall  WriteDAT
 rjmp   moresetup
 ;SetupInfo is in byte pairs: CMD-DATA. Terminate with a CMD of 0xFF
SetupInfo:
 .db 0,$38    ;Mode
 .db 8,0      ;Disp addr. Lo
 .db 9,0      ;Disp addr. Hi
 .db 1,$77    ;Char pitch
 .db 3,5      ;Duty ratio
 .db 2,20     ;Disp width in chars
 .db 10,0     ;Cursor addr Lo
 .db 11,0     ;Cursor addr Hi
 .db $FF,$FF

;--------------------------
; EClock
; Does an LCD E clock
;--------------------------
EClock:
 sbi ECLK
 ldi R16,4
dl1:
 dec R16
 brne dl1
 cbi ECLK
 ret

;-------------------------
; WriteCMD
; Write Command R16 to lcd
;-------------------------
WriteCMD:
 sbi RS
 cbi RW
 cbi CS
 out PORTB,R16
 rcall EClock
 sbi CS
 ret

;------------------------
; WriteDAT
; Writes Data R16 to lcd
;------------------------
WriteDAT:
 cbi RS
 cbi RW
 cbi CS
 out PORTB,R16
 rcall EClock
 sbi CS
 ret

;-------------------------
; WaitLCD
; Waits for LCD
;-------------------------
WaitLCD:
 clr R16
 out DDRB,R16   ;All input.
 sbi RS
 sbi RW
 cbi CS
 sbi ECLK
w1:
 sbic PINB,7      ;wait for pin low (busy flag)
 rjmp w1
 sbi CS
 cbi RS
 cbi RW
 cbi ECLK
 ser R16
 out DDRB,R16     ;Back to all outputs 
 ret
