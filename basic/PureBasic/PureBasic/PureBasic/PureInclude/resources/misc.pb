;
; ** $VER: misc.h 36.13 (6.5.90)
; ** Includes Release 40.15
; **
; ** Unit number definitions for "misc.resource"
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/libraries.pb"

;
;  * Unit number definitions.  Ownership of a resource grants low-level
;  * bit access to the hardware registers.  You are still obligated to follow
;  * the rules for shared access of the interrupt system (see
;  * exec.library/SetIntVector or cia.resource as appropriate).
;
#MR_SERIALPORT = 0 ;  Amiga custom chip serial port registers
;         (SERDAT,SERDATR,SERPER,ADKCON, and interrupts)
#MR_SERIALBITS = 1 ;  Serial control bits (DTR,CTS, etc.)
#MR_PARALLELPORT = 2 ;  The 8 bit parallel data port
;         (CIAAPRA & CIAADDRA only!)
#MR_PARALLELBITS = 3 ;  All other parallel bits & interrupts
;         (BUSY,ACK,etc.)

;
;  * Library vector offset definitions
;
#MR_ALLOCMISCRESOURCE = (#LIB_BASE)  ;  -6
#MR_FREEMISCRESOURCE = (#LIB_BASE-#LIB_VECTSIZE) ;  -12

;#MISCNAME = "misc\resource"

