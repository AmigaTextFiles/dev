 .include "io2313.inc"

 ldi R16,$0F
 out DDRB,R16
 swap R16
 out PORTB,R16      ;Pull inputs high.

 ser R16
 out DDRD,R16

SSCAN:
 ldi R17,254         ;11111110 walking zero
CSCAN: 
 out PORTB,R17
 in R18,PINB
 clc
 clr R19
 ori R18,$0F
 com R18
 breq NOKEY
FA:
 rol R18
 inc R19
 brcc FA       ;Find a 1, count the positions.
 mov R16,R17
 ror R16
FB:
 ror R16       ;Already know its more than 0
 brcc GOTKEY
 subi R19,-3   ;Add 3 to key count to move to next row.
 rjmp FB
GOTKEY:        ;R19 now contains the number of the key pressed.
 out PORTD,R19
 
NOKEY:
 ldi R23,30

 sec
 rol R17
 cpi R17,$EF   ; Reset keyboard walker when its done all.
 brne CSCAN
 rjmp SSCAN

