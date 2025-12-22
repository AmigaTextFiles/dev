
 .include "io2313.inc"

 ldi R16,$0F
 out DDRB,R16

 clr R17      ;Timer counter for tone A
 clr R18      ;Timer counter for tone B

 ldi R30,LOW(TONETABLE*2)
 ldi R31,HIGH(TONETABLE*2)

 adiw R30,5          ;Add in offset

 lpm             ;Get tones from table
 mov R19,R0
 ld R1,Z+
 lpm
 mov R20,R0

loop:
 inc R17         ;125ns    This loop should take 6us
 inc R18         ;125ns

 clr R22         ;125ns

 cp R17,R19      ;125ns
 brne nota       ;125/250 ns
 clr R17        ;Do tone A  ;125 ns
 ori R22,$08

nota:
 cp R18,R20       ;125ns
 brne notb        ;125/250ns
 clr R18        ; 125ns   Do tone B
 ori R22,$04
 
notb:

 in R21,PORTB    ;125
 eor R21,R22     ;125
 out PORTB,R21   ;  125 Toggle the pin
 
 ldi R21,11      ;125 waste 4.1us
dlay:
 dec R21    ;125ns \
 brne dlay  ;250ns   \375ns
      
 rjmp loop      ;250 ns

 ;DTMF values:-
 ; 1   - 700/900
 ; 2   - 700/1100
 ; 3   - 900/1100
 ; 4   - 700/1300
 ; 5   - 900/1300
 ; 6   - 1100/1300
 ; 7   - 700/1500
 ; 8   - 900/1500
 ; 9   - 1100/1500
 ; 0   - 1300/1500
 ; KP1 - 1100/1700
 ; KP2 - 1300/1700
 ; ST  - 1500/1700
 ; CLL - 700/1700
 ; CLH - 2400/2600
 ; SZ  - 2400/2400
 ; Periodic times:-
 ; 700  - 1428us  119
 ; 900  - 1111us  93
 ; 1100 - 909us   76
 ; 1300 - 769us   64
 ; 1500 - 667us   56
 ; 1700 - 588us   49
 ; 2400 - 417us   35
 ; 2600 - 385us   32

TONETABLE:
 .db 119,93     ;1
 .db 119,76     ;2
 .db 93,76      ;3
 .db 119,64     ;4
 .db 93,64      ;5
 .db 76,64      ;6
 .db 119,56     ;7
 .db 93,56      ;8
 .db 76,56      ;9
 .db 64,56      ;0 (10)
 .db 76,49      ;KP1 (11)
 .db 64,49      ;KP2 (12)
 .db 56,49      ;ST  (13)
 .db 119,49     ;C11 (14)
 .db 35,32      ;CLH (15)
 .db 35,35      ;SZ  (16)

