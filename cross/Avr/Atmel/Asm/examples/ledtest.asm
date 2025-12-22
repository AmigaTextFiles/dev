
 ;***** LED Test
 ; Does a binary count on one of the output ports.
 ; Connect LED's to see count.
 

 include "io4414.h"    

 .org 0
 rjmp RESET      ;Jump to start of code.


 ;***** Initialization

RESET:
        ser     R16
        out     DDRB,R16               ;PORTB = all outputs

 ; **** Data to port.

loop:   out     PORTB,R16              ;output data to PORTD
        dec     R16                    

 ;**** Now wait a while to make LED changes visible.

DLY:    dec     R17      ;Short software delay (doncha just love em)
	brne	DLY
        dec     R18
	brne	DLY

	rjmp	loop			;repeat loop endlessly


