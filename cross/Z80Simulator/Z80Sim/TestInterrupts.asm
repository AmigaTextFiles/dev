;
; /\/\/\/\/\/\/\/\ TestInterrupts.asm: /\/\/\/\/\/\/\/
;

            ORG 0
            JP      START

            ORG 8
            LD  A,8
            RETI
            
            ORG 10H
            LD  A,10H
            RETI

            ORG 18H
            LD  A,18H
            RETI

            ORG 20H
            LD  A,20H
            RETI

            ORG 28H
            LD  A,28H
            RETI

            ORG 30H
            LD  A,30H
            RETI

            ORG 38H
            LD  A,38H
            RETI

            ORG 66H
            LD  A,66H
            RETN

            ORG   400H
START       DI                   ; Let's see if the simulator can
            LD    A,66H          ; process IM mode 2 interrupts 
            LD    I,A            ; correctly.
            LD    SP,0FFFFH      ; Needed for return values.
            EI
            IM    2
            HALT

            ORG     1FF0H
            JP      START        ; In case something goes wrong!

; The I-Register is set to 66H by the START code, then the user has to
; input 0, 10, 20, 30, or 40H in order to jump to the proper locations 
; given below.  The Z80 will then jump to the proper code starting at
; 0AA00H:

            ORG     6600H
            DB  00
            DB  0AAH

            ORG     6610H
            DB  10H
            DB  0AAH
            
            ORG     6620H
            DB  20H
            DB  0AAH
            
            ORG     6630H
            DB  30H
            DB  0AAH
            
            ORG     6640H
            DB  40H
            DB  0AAH
;
;           IM 2 Interrupt routines:
;
            ORG     0AA00H            
            LD  B,A
            IM  0
            XOR A
            RETI

            ORG     0AA10H
            LD  B,A
            IM  1
            LD  A,1
            RETI

            ORG     0AA20H
            LD  B,A
            XOR A
            RETI

            ORG     0AA30H
            LD  B,A
            XOR A
            RETI

            ORG     0AA40H
            JP 38H
            
            END
