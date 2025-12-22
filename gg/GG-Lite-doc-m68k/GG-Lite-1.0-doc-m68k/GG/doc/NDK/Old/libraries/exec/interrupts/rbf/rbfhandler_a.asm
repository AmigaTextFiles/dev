*
* rbfhandler_a.asm - Example interrupt handler - link with rbfhandler_c.o
*
* Copyright (c) 1990 Commodore-Amiga, Inc.
*
* This example is provided in electronic form by Commodore-Amiga, Inc. for
* use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
* The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
* information on the correct usage of the techniques and operating system
* functions presented in this example.  The source and executable code of
* this example may only be distributed in free electronic form, via bulletin
* board or as part of a fully non-commercial and freely redistributable
* diskette.  Both the source and executable code (including comments) must
* be included, without modification, in any copy.  This example may not be
* published in printed form or distributed with any commercial product.
* However, the programming techniques and support routines set forth in
* this example may be used in the development of original executable
* software products for Commodore Amiga computers.
* All other rights reserved.
* This example is provided "as-is" and is subject to change; no warranties
* are made.  All use is at your own risk.  No liability or responsibility
* is assumed.
*

    INCLUDE "exec/types.i"
    INCLUDE "hardware/custom.i"
    INCLUDE "hardware/intbits.i"

        XDEF    _RBFHandler

JSRLIB MACRO
       XREF _LVO\1
       JSR  _LVO\1(A6)
       ENDM

BUFLEN    EQU    256

       STRUCTURE OURDATA,0
        APTR   od_maintask
        ULONG  od_mainsig
        UWORD  od_bufi
        STRUCT od_chbuf,BUFLEN+2
        STRUCT od_flbuf,BUFLEN+2
        STRUCT od_ourname,32
        LABEL OURDATA_SIZEOF


* Entered with:
*  D0 == scratch
*  D1 == INTENAT & INTREQR (scratch)
*  A0 == custom chips (scratch)
*  A1 == is_Data which is OURDATA structure (scratch)
*  A5 == vector to our code (scratch)
*  A6 == pointer to ExecBase (scratch)
*
* Note - This simple handler just receives one buffer full of serial
* input data, signals main, then ignores all subsequent serial data.
*
	section code

_RBFHandler:                            ;entry to our interrupt handler

        MOVE.W  serdatr(A0),D1          ;get the input word (flags and char)

        MOVE.W  od_bufi(A1),D0          ;get our buffer index
        CMPI.W	#BUFLEN,D0              ;no more room in our buffer ? 
        BEQ.S   ExitHandler             ;yes - just exit (ignore new char)
        LEA.L   od_chbuf(A1),A5         ;else get our character buffer address
        MOVE.B  D1,0(A5,D0.W)           ;store character in our chbuf
        LEA.L   od_flbuf(A1),A5         ;get our flag buffer address
        LSR.W   #8,d1                   ;shift flags down
        MOVE.B  D1,0(A5,D0.W)           ;store flags in our flbuf

        ADDQ.W  #1,D0                   ;increment our buffer index
        MOVE.W  D0,od_bufi(A1)          ;   and replace it
        CMPI.W  #BUFLEN,D0              ;did our buffer just become full ?
        BNE.S   ExitHandler             ;no - we can exit
        MOVE.L  A0,-(SP)                ;yes - save custom
        MOVE.L  od_mainsig(A1),D0       ;get signal allocated by main
        MOVE.L  od_maintask(A1),A1      ;and pointer to main task
        JSRLIB  Signal                  ;tell main we are full
        MOVE.L  (SP)+,A0                ;restore custom
                                        ;Note: system call trashed D0-D1/A0-A1
ExitHandler:
        MOVE.W  #INTF_RBF,intreq(A0)    ;clear the interrupt
        RTS                             ;return to exec

        END
