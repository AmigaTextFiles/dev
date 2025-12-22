;
; setup for pic 16c84
; can be modified for individual projects
;
; EQUates
;
;
;
CSEG = 40h	   ; code origin
DSEG = 0fh	   ; start of working data registers

; registers needed by code generator

primary = 2fh
secondary = 2eh
temp = 2ch
stackptr = 2bh
FR0	    =	0h
FR1	    =	1h
FR2	    =	2h
FR3	    =	3h

; some standard pic function register

W		   =	 00h
F		   =	 01h

;----- Register Files------------------------------------------------------
INDF		   =	 00h
TMR0		   =	 01h
PCL		   =	 02h
STATUS		   =	 03h
FSR		   =	 04h
PORTA		   =	 05h
PORTB		   =	 06h
EEDATA		   =	 08h
EEADR		   =	 09h
PCLATH		   =	 0Ah
INTCON		   =	 0Bh
OPTREG		   =	 81h
FSR		   =	 84h
TRISA		   =	 85h
TRISB		   =	 86h
EECON1		   =	 88h
EECON2		   =	 89h

;----- STATUS Bits --------------------------------------------------------

IRP			     =	   07h
RP1			     =	   06h
RP0			     =	   05h
NOT_TO			     =	   04h
NOT_PD			     =	   03h
Z			     =	   02h
DC			     =	   01h
C			     =	   00h

;----- INTCON Bits --------------------------------------------------------

GIE			     =	   07h
EEIE			     =	   06h
T0IE			     =	   05h
INTE			     =	   04h
RBIE			     =	   03h
T0IF			     =	   02h
INTF			     =	   01h
RBIF			     =	   00h

;----- OPTION Bits --------------------------------------------------------

NOT_RBPU		     =	   07h
INTEDG			     =	   06h
T0CS			     =	   05h
T0SE			     =	   04h
PSA			     =	   03h
PS2			     =	   02h
PS1			     =	   01h
PS0			     =	   00h

;----- EECON1 Bits --------------------------------------------------------

EEIF			     =	   04h
WRERR			     =	   03h
WREN			     =	   02h
WR			     =	   01h
RD			     =	   00h

;==========================================================================
;
;	RAM Definition
;
;==========================================================================

;	 __MAXRAM H'AF'
;	 __BADRAM H'07', H'30'-H'7F', H'87'

;==========================================================================
;
;	Configuration Bits
;
;==========================================================================

_CP_ON			     =	   3FEFh
_CP_OFF 		     =	   3FFFh
_PWRTE_ON		     =	   3FFFh
_PWRTE_OFF		     =	   3FF7h
_WDT_ON 		     =	   3FFFh
_WDT_OFF		     =	   3FFBh
_LP_OSC 		     =	   3FFCh
_XT_OSC 		     =	   3FFDh
_HS_OSC 		     =	   3FFEh
_RC_OSC 		     =	   3FFFh


;
;  stack mechanism
;
;   low memory
;   ^
;   |  start of registers (DSEG) ----> STATIC VARIABLES
;   |  ....
;   |  stack-------------------------> AUTOMATIC VARIABLES
;   |  code registers: _primary, etc...
;   |
;   high memory
;
;

   device PIC16C84

   org 0

   jmp startup

   org 4

   jmp interrupt

   org 10
/*
startup mov stackptr, #stackptr  ; set up stack pointer
   call main
   jmp $	  ; infinite loop if return from main

interrupt jmp $        ; set to your interrupt routine

; standard stack manipulation code

push  decf  stackptr
    movf fr4, stackptr
    movf fr0, primary
    return


pop movf fr4, stackptr
    movf secondary, fr0
    incf stackptr
    return

putstk movf fr4, secondary
       movf fr0, primary
       return

indr  movf fr4,    primary
      movf primary,fr0
      return

swap  movf temp, primary
      movf primary, secondary
      movf secondary, temp
    return

swaps  movf fr4, stackptr
    movf temp, fr0
    movf fr0, primary
    movf primary, temp
    return
;
*/
; ***********************Start of user code**********************
;
;

