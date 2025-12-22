	;***
	;The PowerVisor PortPrint library V1.4
	;© J.Tyberghein   Wed Jul 29 13:10:50 1992
	;
	; 11 apr 1990
	;		New PP_PrintNumber function
	;		DumpRegs SR now works
	;  8 Mar 1991
	;		Bug solved with wrong port name
	; 20 Apr 1991
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

		INCLUDE	"pv.lib.i"

Start:
		moveq		#-1,d0
		rts

	;***
	;Romtag structure
	;***
Romtag:
		dc.w		RTC_MATCHWORD
		dc.l		Romtag
		dc.l		EndCode
		dc.b		RTF_AUTOINIT
		dc.b		PV_VERSION
		dc.b		NT_LIBRARY
		dc.b		0						;Pri
		dc.l		pvName
		dc.l		idString
		dc.l		Init

pvName:
		pvLibName
idString:
		dc.b		"PowerVisor PortPrint library (29 Jul 1992)",0

	EVEN

Init:
		dc.l		pvBase_SIZE
		dc.l		FuncTable
		dc.l		DataTable
		dc.l		InitRoutine

FuncTable:
		dc.l		Open
		dc.l		Close
		dc.l		Expunge
		dc.l		Null
		dc.l		PP_InitPortPrint
		dc.l		PP_StopPortPrint
		dc.l		PP_ExecCommand
		dc.l		PP_DumpRegs
		dc.l		PP_Print
		dc.l		PP_PrintNumber
		dc.l		PP_SignalPowerVisor
		dc.l		-1

DataTable:
		INITBYTE	LN_TYPE,NT_LIBRARY
		INITLONG	LN_NAME,pvName
		INITBYTE	LIB_FLAGS,LIBF_SUMUSED|LIBF_CHANGED
		INITWORD	LIB_VERSION,PV_VERSION
		INITWORD	LIB_REVISION,PV_REVISION
		INITLONG	LIB_IDSTRING,idString
		dc.l		0

	;***
	;Initialize library
	;d0=library pointer
	;a0=seglist
	;a6=sysbase
	;-> d0=non zero if the lib must be linked in the system list
	;***
InitRoutine:
		move.l	a5,-(a7)
		move.l	d0,a5
		move.l	a0,pv_SegList(a5)
		move.l	(a7)+,a5
		rts

PortName:
		pvPortName

	EVEN

	;***
	;Open library
	;d0=version
	;a6=ptr to lib
	;-> d0=ptr to lib
	;***
Open:
		addq.w		#1,LIB_OPENCNT(a6)
	;Prevent delayed expunges
		bclr			#LIBB_DELEXP,pv_Flags(a6)
		move.l		a6,d0
		rts

	;***
	;Close library
	;a6=ptr to lib
	;-> d0=return seglist if lib is completely closed and delayed expunge
	;***
Close:
		moveq		#0,d0
		subq.w	#1,LIB_OPENCNT(a6)
		bne.s		EndClose
	;There is no one left
		btst		#LIBB_DELEXP,pv_Flags(a6)
		beq.s		EndClose
		bsr.s		Expunge
EndClose:
		rts

	;***
	;Expunge the library
	;a6=ptr to lib
	;-> d0=seglist if library is not longer open
	;***
Expunge:
		movem.l	d2/a5-a6,-(a7)
		move.l	a6,a5
		move.l	(4).w,a6
		tst.w		LIB_OPENCNT(a5)
		beq.s		NoOneOpen
	;It is still open, set the delayed expunge flag
		bset		#LIBB_DELEXP,pv_Flags(a5)
		moveq		#0,d0
		bra.s		ExpungeEnd
NoOneOpen:
		move.l	pv_SegList(a5),d2
		move.l	a5,a1
		jsr		_LVORemove(a6)
		moveq		#0,d0
		move.l	a5,a1
		move.w	LIB_NEGSIZE(a5),d0
		sub.l		d0,a1
		add.w		LIB_POSSIZE(a5),d0
		jsr		_LVOFreeMem(a6)
		move.l	d2,d0					;Segment
ExpungeEnd:
		movem.l	(a7)+,d2/a5-a6
		rts

	;***
	;Do nothing function
	;***
Null:
		moveq		#0,d0
		rts

	;***
	;Our functions start here
	;***

	;***
	;Init the replyport
	;all registers are preserved
	;-> d0=pointer to replyport (null if no success)
	;***
PP_InitPortPrint:
		movem.l	d1-d2/a0-a2/a6,-(a7)
		moveq		#-1,d0
		move.l	(4).w,a6
		jsr		_LVOAllocSignal(a6)
		cmp.l		#-1,d0
		beq.s		ErrorIPP
		move.l	d0,d2
		moveq		#MP_SIZE,d0
		move.l	#MEMF_CLEAR|MEMF_PUBLIC,d1
		jsr		_LVOAllocMem(a6)
		tst.l		d0
		beq.s		Error2IPP
		move.l	d0,a2
		moveq		#0,d0
		move.l	d0,LN_NAME(a2)
		move.b	d0,LN_PRI(a2)
		move.b	#NT_MSGPORT,LN_TYPE(a2)
		move.b	#PA_SIGNAL,MP_FLAGS(a2)
		move.b	d2,MP_SIGBIT(a2)
		move.l	ThisTask(a6),MP_SIGTASK(a2)
	;NewList
		lea		MP_MSGLIST(a2),a0
		clr.l		LH_TAIL(a0)
		move.l	a0,LH_TAILPRED(a0)
		addq.l	#LH_TAIL,a0
		move.l	a0,-(a0)
		move.l	a2,d0
EndIPP:
		movem.l	(a7)+,d1-d2/a0-a2/a6
		rts
Error2IPP:
		move.l	d2,d0
		jsr		_LVOFreeSignal(a6)
ErrorIPP:
		moveq		#0,d0
		bra.s		EndIPP

	;***
	;Remove our replyport
	;all registers are preserved
	;a0=pointer to the replyport
	;***
PP_StopPortPrint:
		movem.l	d0-d1/a0-a2/a6,-(a7)
		move.l	a0,a2
		moveq		#0,d0
		move.b	MP_SIGBIT(a2),d0
		move.l	(4).w,a6
		jsr		_LVOFreeSignal(a6)
		move.l	a2,a1
		moveq		#MP_SIZE,d0
		jsr		_LVOFreeMem(a6)
		movem.l	(a7)+,d0-d1/a0-a2/a6
		rts

	;***
	;Execute an IDC command
	;Data will be copied to internal buffer
	;all registers are preserved
	;a0=pointer to the replyport (or null)
	;a1=pointer to data
	;a2=pointer to commandstring
	;d0=size of data
	;-> d0 = resultcode
	;***
PP_ExecCommand:
		movem.l	d1/a0-a3/a6,-(a7)
		lea		-mn_SIZE-3*4(a7),a7	;Place for message
		move.l	(4).w,a6
		lea		mn_SIZE(a7),a3
		move.l	a3,mn_Data(a7)
		move.l	a2,(a3)+					;<command> <data> <size>
		move.l	a1,(a3)+
		move.l	d0,(a3)
		move.w	#PP_EXEC,mn_Command(a7)
		bsr		HandleMessage
		move.l	mn_Data(a7),d0			;Return code
		lea		mn_SIZE+3*4(a7),a7
		movem.l	(a7)+,d1/a0-a3/a6
		rts

	;***
	;Signal PowerVisor. This routine simply causes a signal to
	;PowerVisor
	;a0=pointer to the replyport (or null)
	;d0=special signal number (SIGNAL_xxx)
	;***
PP_SignalPowerVisor
		movem.l	d0-d1/a0-a2/a6,-(a7)
		lea		-mn_SIZE(a7),a7	;Place for message
		move.l	d0,mn_Data(a7)		;Signal number
		move.w	#PP_SIGNAL,mn_Command(a7)
		bsr		HandleMessage
		lea		mn_SIZE(a7),a7
		movem.l	(a7)+,d0-d1/a0-a2/a6
		rts

	;***
	;Register dump
	;all registers are preserved (even SR)
	;a0=pointer to the replyport
	;***
PP_DumpRegs:
		movem.l	d0-d7/a0-a6,-(a7)
		move.l	a0,a2
		moveq		#0,d0
		moveq		#0,d1
		move.l	a6,-(a7)				;Remember powervisor.library
		move.l	(4).w,a6
		jsr		_LVOSetSR(a6)
		move.l	(a7)+,a6
		move.w	d0,-(a7)
		move.l	15*4+2(a7),a1
		move.l	a1,-(a7)				;PC !!! Func must be called with JSR !!!
		move.l	a7,a5
		lea		-mn_SIZE(a7),a7	;Place for message
		move.l	a5,mn_Data(a7)		;Pointer to stack frame
		move.w	#PP_DUMP,mn_Command(a7)
		move.l	a2,a0
		bsr		HandleMessage
		lea		mn_SIZE(a7),a7
		move.l	(a7)+,d0				;Get PC
		move.w	(a7)+,d0				;Restore SR
		moveq		#-1,d1				;Mask for all bits
		jsr		_LVOSetSR(a6)
		movem.l	(a7)+,d0-d7/a0-a6
		rts

	;***
	;Print line
	;all registers are preserved
	;a0=pointer to the replyport (or null)
	;a1=pointer to line
	;***
PP_Print:
		movem.l	d0-d1/a0-a2/a6,-(a7)
		lea		-mn_SIZE(a7),a7	;Place for message
		move.l	a1,mn_Data(a7)		;Ptr to string
		move.w	#PP_PRINT,mn_Command(a7)
		bsr		HandleMessage
		lea		mn_SIZE(a7),a7
		movem.l	(a7)+,d0-d1/a0-a2/a6
		rts

	;***
	;Print number
	;all registers are preserved
	;a0=pointer to the replyport (or null)
	;d0=number to print
	;***
PP_PrintNumber:
		movem.l	d0-d1/a0-a2/a6,-(a7)
		lea		-mn_SIZE(a7),a7	;Place for message
		move.l	d0,mn_Data(a7)		;Number to print
		move.w	#PP_PRINTNUM,mn_Command(a7)
		bsr		HandleMessage
		lea		mn_SIZE(a7),a7
		movem.l	(a7)+,d0-d1/a0-a2/a6
		rts

	;***
	;Subroutine for all library functions to handle the message
	;a0=pointer to replyport (or null)
	;a6=pointer to powervisor.library
	;a7+4 points to message
	;***
HandleMessage:
		move.l	a5,-(a7)
		move.l	a6,a5					;Remember powervisor.library
		move.l	a0,a2
		move.l	(4).w,a6
		lea		PortName,a1
		jsr		_LVOFindPort(a6)
		tst.l		d0
		beq.s		NoPortHM
		move.l	d0,-(a7)

		move.l	a2,d0					;Test if there is a reply port given
		beq.s		1$

	;Yes, first clear all messages
2$		move.l	a2,a0					;Replyport
		jsr		_LVOGetMsg(a6)
		tst.l		d0
		bne.s		2$
		lea		12(a7),a1			;Pointer to message
		bra.b		4$

	;No replyport, copy the message on stack to the PowerVisor base
1$		lea		pv_Message(a5),a0
		lea		12(a7),a1
		moveq		#mn_SIZE-1,d0
3$		move.b	(a1)+,(a0)+
		dbra		d0,3$
		lea		pv_Message(a5),a1

	;Send the message
4$		move.l	(a7)+,a0				;Pointer to pv port
		move.l	a2,MN_REPLYPORT(a1)
		move.w	#mn_SIZE,MN_LENGTH(a1)
		jsr		_LVOPutMsg(a6)
		move.l	a2,d0
		beq.s		NoPortHM
		move.l	a2,a0
		jsr		_LVOWaitPort(a6)
		move.l	a2,a0
		jsr		_LVOGetMsg(a6)
NoPortHM:
		move.l	(a7)+,a5
		rts

EndCode:
		end

