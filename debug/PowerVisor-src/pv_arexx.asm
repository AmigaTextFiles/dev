*****
****
***			A R E X X   routines for   P O W E R V I S O R
**
*				Version 1.40
**				Fri Sep 25 18:43:56 1992
***			© Jorrit Tyberghein
****
*****

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


			INCLUDE	"pv.i"

			INCLUDE	"pv.minrexx.i"
			INCLUDE	"pv.arexx.i"
			INCLUDE	"TileWindows.i"

			INCLUDE	"pv.errors.i"


	XDEF		ARexxConstructor,ARexxDestructor,CheckRexx,RexxBit
	XDEF		RoutRx,RoutSync,RoutASync,Hide,InSync,RoutHide,RoutUnHide,ARexxBase
	XDEF		RoutClip,RoutRemClip,RoutString,FuncARexxPort

	;screen
	XREF		BusyPrompt,PrintPrompt
	XREF		LogWin_StartPage,CurrentLW
	XREF		HideCurrent,UnHideCurrent,RexxLW
	XREF		LogWin_SetFlags,NoIDC
	;main
	XREF		RexxCommandList,ErrorHandler,LastError
	;eval
	XREF		LongToDec,GetRestLine,GetStringE
	;list
	XREF		ResetList
	;memory
	XREF		StoreRC,AllocBlockInt,AddAutoClear,FreeBlock
	;general
	XREF		PortNameEnd

;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Constructor: initialize everything for ARexx
	;-> flags is eq if error
	;***
ARexxConstructor:
		lea		(RexxNameEnd,pc),a0
		lea		(PortNameEnd),a1
		move.b	(a1)+,(a0)+
		move.b	(a1),(a0)

		pea		(RexxDisp,pc)
		pea		(RexxExt,pc)
		pea		(RexxCommandList)
		pea		(RexxName,pc)
		bsr		_upRexxPort
		lea		(RexxBit,pc),a0
		move.l	d0,(a0)
		lea		(16,a7),a7
		moveq		#1,d0
		rts

	;***
	;Destructor: clean everything for ARexx
	;***
ARexxDestructor:
		bra		_dnRexxPort

	;***
	;Function: get name of ARexx port
	;***
FuncARexxPort:
		lea		(RexxName,pc),a0
		move.l	a0,d0
		rts

	;***
	;Command: return a string in ARexx
	;***
RoutString:
		EVALE
		move.l	d0,d2
		NEXTTYPE
		beq.b		1$

	;There is a maximum length specified, copy the string to that place
		EVALE
		move.l	d0,d3
		addq.l	#1,d0
		bsr		AllocBlockInt
		beq.b		2$
		bsr		AddAutoClear
		bne.b		4$
	;Free string
		movea.l	d0,a0
		bsr		FreeBlock
2$		ERROR		NotEnoughMemory
4$		movea.l	d0,a1
		movea.l	d2,a0
		move.l	d0,d2
		subq.l	#1,d3
		blt.b		1$
3$		move.b	(a0)+,(a1)+
		dbeq		d3,3$

1$		move.l	d2,d0
		rts

	;***
	;Command: set a clip
	;***
RoutClip:
		bsr		GetStringE			;Get clip name
		move.l	d0,d2
		NEXTTYPE
		beq.b		1$

	;Set clip
		EVALE								;Get data space
		move.l	d0,d3
		EVALE								;Get length
		move.l	d0,-(a7)				;Length
		move.l	d3,-(a7)				;Data
		move.l	d2,-(a7)				;Clip name
		bsr		_SetClip
		lea		(12,a7),a7
		rts

	;Get clip
1$		subq.l	#4,a7					;Space for pointer to RexxArg
		movea.l	a7,a2					;Pointer to space
		move.l	a2,-(a7)				;Pointer to RexxArg as argument to 'GetClip'
		move.l	d2,-(a7)				;Clip name
		bsr		_GetClip
		tst.l		d0
		beq.b		2$
		move.l	(a2),d0
2$		bsr		StoreRC
		PRINTHEX
		lea		(8+4,a7),a7
		rts

	;***
	;Command: remove a clip
	;***
RoutRemClip:
		bsr		GetStringE			;Get clip name
		move.l	d0,-(a7)				;Clip name
		bsr		_RemClip
		lea		(4,a7),a7
		rts

	;***
	;Command: Hide all ARexx output on screen
	;***
RoutHide:
		lea		(Hide,pc),a0
		move.w	#1,(a0)
		rts

	;***
	;Command: Unhide all ARexx output on screen
	;***
RoutUnHide:
		lea		(Hide,pc),a0
		clr.w		(a0)
		rts

	;***
	;Command: Synchronize ARexx with PowerVisor
	;***
RoutSync:
		move.w	(InSync,pc),d0
		bne.b		1$
		lea		(InSync,pc),a0
		move.w	#1,(a0)
		bsr		BusyPrompt
1$		rts

	;***
	;Command: Remove Sync
	;***
RoutASync:
		move.w	(InSync,pc),d0
		beq.b		1$
		lea		(InSync,pc),a0
		clr.w		(a0)
		bsr		PrintPrompt
1$		rts

	;***
	;Command: start an ARexx script
	;***
RoutRx:
		move.l	a0,-(a7)
		bsr		_asyncRexxCmd
		lea		(4,a7),a7
		rts

	;***
	;Check for a rexx command
	;***
CheckRexx:
		movem.l	a0-a1/d0-d1,-(a7)
		bsr		_dispRexxPort
		movem.l	(a7)+,a0-a1/d0-d1
		rts

	;***
	;ARexx dispatcher.
	;Arguments on stack
	;***
RexxDisp:
		movem.l	d2-d7/a2-a6,-(a7)
		movea.l	(4+11*4,a7),a4		;Ptr to rexx message
		movea.l	(8+11*4,a7),a3		;Ptr to rexx command list
		movea.l	(12+11*4,a7),a2	;Remember ptr to arg

	;Skip all spaces in argument
1$		tst.b		(a2)
		beq.b		2$
		cmpi.b	#' ',(a2)+
		ble.b		1$
		subq.l	#1,a2

	;Make sure we always return here (even if error in routine)
2$		move.l	(CurrentLW),d5		;Remember old current logwin
		move.l	(RexxLW),d0
		beq.b		3$
		move.l	d0,(CurrentLW)

3$		movea.l	(CurrentLW),a0
		move.w	#LWF_NOBREAK,d0
		move.w	d0,d1
		bsr		LogWin_SetFlags
		move.w	d0,d6					;Remember old flags
		lea		(NoIDC),a1
		move.b	#1,(a1)				;Don't allow IDC commands
		lea		(ExecRoutine,pc),a5
		movem.l	d2/d5-d6/a2-a4,-(a7)
		bsr		ErrorHandler
		movem.l	(a7)+,d2/d5-d6/a2-a4
		beq.b		4$
	;No error
		move.l	d0,-(a7)
		bsr		CleanUpRD
		move.l	(a7)+,d0
		cmpi.l	#USER_RETURNSTR,(rcl_usertype,a3)
		bne.b		6$
	;Return string
		move.l	d0,-(a7)
		bra.b		7$
	;Return number in string
6$		lea		(ResultStr,pc),a0
		bsr		LongToDec
		move.l	a0,-(a7)
7$		moveq		#0,d0
		pea		(0).w
8$		move.l	d0,-(a7)				;Error code
		move.l	a4,-(a7)
		bsr		_replyRexxCmd		;This function always returns 1
		lea		(16,a7),a7			;	so we return 1
		movem.l	(a7)+,d2-d7/a2-a6
		rts

	;Cleanup after error
4$		bsr		CleanUpRD
		pea		(0).w						;No return string
		pea		(0).w						;No secondary rc
		moveq		#0,d0
		move.w	(LastError),d0
		bra.b		8$

	;***
	;This routine is called by error handler
	;a0 = current logical window
	;***
ExecRoutine:
	;Exec command
		bsr		LogWin_StartPage

		move.w	(Hide,pc),d0
		beq.b		1$
		bsr		HideCurrent

1$		movea.l	a2,a0
		NEXTTYPE
		moveq		#I_LAST,d6
		movea.l	(rcl_userdata,a3),a1
		jmp		(a1)

	;Subroutine: clean up
	;d5 = Old currentLW
	;d6.w = Old flags
CleanUpRD:
		move.w	d6,d0
		move.w	#LWF_NOBREAK,d1
		movea.l	(CurrentLW),a0
		bsr		LogWin_SetFlags

		move.l	#LWF_SCREEN,d0
		bsr		UnHideCurrent
		bsr		ResetList
		move.l	d5,(CurrentLW)

		lea		(NoIDC),a1
		clr.b		(a1)					;Allow IDC commands
		rts

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;***
	;Start of ARexxBase
	;***
ARexxBase:

RexxBit:		dc.l	0
InSync:		dc.w	0
Hide:			dc.w	0
	;***
	;End of ARexxBase
	;***

ResultStr:	ds.b	14

RexxName:	dc.b	"REXX_POWERVISOR"
RexxNameEnd:dc.b	0,0,0
RexxExt:		dc.b	"pv",0

	END
