
 org $0004

START:

POST   equ END&255
ONE     equ (1)
TWO     equ (ONE+1)
THREE   equ ONE*3
FOUR    equ TWO*TWO
FIVE    equ TWO+TWO +1
SIX     equ THREE+ TWO + One
SEVEN   equ THREE*2+ONE
EIGHT   equ FOUR<1
SIXTEEN equ FOUR+FOUR+EIGHT
FULL    equ 255
NINE  equ (FOUR<1)+1
TEN   equ   2*(2+1)+FOUR
BITS  equ FULL&255
TWELVE equ EIGHT|FOUR
PRE    equ START+1

  ldi R30,END+1

END:

