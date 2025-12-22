*************************************************************************
* samplelib_stubs.asm
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
*
* Stubs that match this .fd file:
*
*	##base _SampleBase
*	##bias 30
*	##public
*	Double(n1)(D0)
*	AddThese(n1,n2)(D0/D1)
*	##end
*
* After assembling,
*   JOIN samplelib_stubs.o samplelib_lvos.o AS sample.lib
*
* LINK with LIBRARY sample.lib when calling sample.library functions
*
* NOTE: If you put all of your stubs in one file, as shown here,
*       then all of the stubs will be pulled into an application
*       that references one stub.  For larger libraries, you should
*       place each stub in a separate assembler file, assemble them
*       each separately, then join all of the .o's together.
*       That will allow each stub to be independently pulled into
*       the application.
*       
*************************************************************************
   INCLUDE  "exec/types.i"
   INCLUDE  "exec/libraries.i"

          section code

*------ Caller declares and initializes SampleBase in their C code

            XREF        _SampleBase

*------ Must externally reference the _LVO labels defined in samplelib_lvos

            XREF        _LVODouble
            XREF        _LVOAddThese

*------ Make C function stubs available to caller

            XDEF        _Double
            XDEF        _AddThese

*------- These stubs move C args from stack to appropriate registers,
*------- call the library function, and return result in d0

_Double:
            MOVE.L      A6,-(SP)           ;Save register(s)
            MOVE.L      8(SP),D0           ;Copy param to register
            MOVE.L      _SampleBase,A6     ;Library base to A6
            JSR         _LVODouble(A6)     ;Go to real routine
            MOVE.L      (SP)+,A6           ;Restore register(s)
            RTS

_AddThese:
            MOVE.L      A6,-(SP)           ;Save register(s)
            MOVEM.L     8(SP),D0/D1        ;Copy params to registers
					   ;8(SP)  goes into D0
					   ;12(SP) goes into D1
            MOVE.L      _SampleBase,A6     ;Library base to A6
            JSR         _LVOAddThese(A6)   ;Go to real routine
            MOVE.L      (SP)+,A6           ;Restore register(s)
            RTS

          END

