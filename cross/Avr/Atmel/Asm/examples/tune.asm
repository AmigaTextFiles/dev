;Example code which plays a tune on the output compare pin of AT90S
;device, running with an 8MHz crystal.

 .include "/includes/io2313.h"

; Equates for each musical note, eg o2a is octave 2, A

o2a  equ 142
o2b  equ 127
o2c  equ 120
o2d  equ 107
o2e  equ 95
o2f  equ 89
o2fs equ 87      ;F#
o2g  equ 80
o3a  equ 71
o3b  equ 63
o3c  equ 60
o3d  equ 53
o3e  equ 48
o3f  equ 45
o3g  equ 40

                ;Output compare pin, output.
 sbi DDRB,3

 ldi R16,$40
 out TCCR1A,R16     ;Toggle OC pin on compare (Piezo).

 ldi R16,$0B         ;00001100    clear counter on match, clk/8
 out TCCR1B,R16

RESTART:
 ldi R30,(TUNE*2)&255    ;Load the start of the lookup table into Z (R30, R31)
 ldi R31,(TUNE*2)>8

 clr R16
L1:
 out OCR1AH,R16       ;Delay between notes.
 out OCR1AL,R16
 ldi R18,50
L3:                 ;Short software delay.
 dec R18
 brne L3
 dec R19
 brne L3

 lpm                  ;Get note from lookup table, store in R0.
 ld  R1,Z+           ;Just increment Z by 1
 mov R17,R0
 cpi R17,0
 breq RESTART       ;If the note was 0, end of tune.
 lpm               ;Get note duration.
 ld R1,Z+
 mov R20,R0

 clr R18           ;clear the counter
 out TCNT1H,R18
 out TCNT1L,R18

 out OCR1AH,R16   ;Load in new note
 out OCR1AL,R17

L2:            ;note delay
  dec R18
  brne L2
  dec R19
  brne L2
  dec R20
  brne L2

  rjmp L1

; Tune lookup table.

TUNE:               ;Note, Duration
     .db o2d,7
     .db o2c,7
     .db o2b,10
     .db o2d,10
     .db o2d,10
     .db o2d,10
     .db o2e,10
     .db o2d,20
     .db o2c,10
     .db o2b,15
     .db o2d,5
     .db o2g,15
     .db o3a,5
     .db o3b,25
     .db o3b,10
     .db o3b,10
     .db o2d,10
     .db o2d,10
     .db o3b,10
     .db o3b,10
     .db o3a,20
     .db o2g,10
     .db o2fs,15
     .db o2g,7
     .db o3a,15
     .db o3b,7
     .db o3a,20
     .db 0      ;end marker
