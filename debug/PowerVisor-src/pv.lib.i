	;***
	;The PowerVisor PortPrint library include file
	;© J.Tyberghein   Wed Jul 29 13:15:51 1992
	;
	; 11 apr 1990
	;		New command
	; 20 apr 1991
	;		New PP_ExecCommand
	; 29 Jan 1992
	;		New PP_TrackAllocMem and PP_TrackFreeMem (not used yet)
	; 27 Jul 1992
	;		New feature. When you call any of the library functions with
	;			a NULL reply port, the function will not wait for a reply
	; 28 Jul 1992
	; 29 Jul 1992
	;		New PP_SignalPowerVisor routine (at this moment only for the
	;			bus error handler)
	;		Removed obsolete PP_TrackAllocMem and PP_TrackFreeMem
	;***


 * Part of PowerVisor source   Copyright © 1992   Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH


	;***
	;Structure definition for messages to our port
	;***
	STRUCTURE myMsg,MN_SIZE
		UWORD		mn_Command				;Command to execute
		APTR		mn_Data					;Command specific data
		LABEL		mn_SIZE



	STRUCTURE	pvBase,LIB_SIZE
		UBYTE		pv_Flags
		UBYTE		pv_pad
		ULONG		pv_SegList
		STRUCT	pv_Message,mn_SIZE	;Emergency message if replyport is null
		LABEL		pvBase_SIZE

PV_VERSION		equ	$1
PV_REVISION		equ	$4

pvLibName:	macro
				dc.b	"powervisor.library",0
				endm

pvPortName:	macro
				dc.b	"PowerVisor-port",0
				endm


	;Commands
PP_EXEC		equ	1
PP_DUMP		equ	2
PP_PRINT		equ	3
PP_PRINTNUM	equ	4
PP_SIGNAL	equ	5

