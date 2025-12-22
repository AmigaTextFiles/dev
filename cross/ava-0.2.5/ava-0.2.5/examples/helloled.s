/* helloled.s 

   Example from the Chapter 5.1.2
   
   Uros Platise (c) 1999 
*/

/* set target device; see arch.inc for other models. */
#arch AT90S1200

/* Load include file of predefined port definitions.
   This file should not be included unitl device is selected. 
   See inside of the avr.inc for details.
*/
#include "avr.inc"

/* general declarations */
#define LED1        PB0
    
/* calculate port B direction */
#define PORTB_DIR   BV(LED1)

/* register naming */
#define Tmp	        r16

/* AVR AT90S1200 vectors start at address 0 */
	seg abs=0 flash.code
        
        rjmp __reset_   /* this vector is executed on every reset */
        reti
        reti
        reti
    
/* Initialize hardware ports */    
__reset_:
        ldi Tmp, PORTB_DIR  /* set port B direction */
        out DDRB, Tmp
        
        clr Tmp             /* clear outputs and disable pull-ups */
        out PORTB, Tmp
        
loop:   rjmp loop           /* loop for ever */

