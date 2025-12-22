	OPT	USER,W-

**
**	$Filename: Example.s $
**	$Lib Revision: 2.2 $
**	$Date: 94/02/23 $
**
**	Simple example showing how to use the library
**
** HISTORY
**	94/02/23 - Adapted to V2+ library
**

	INCLUDE	exec/types.i
	INCLUDE	exec/exec_lib.i
	INCLUDE	exec/nodes.i
	INCLUDE	exec/ports.i
	INCLUDE	exec/memory.i
	INCLUDE	amix/amix.i
	INCLUDE	amix/aedoor.i

Start:
	;move.b	(a0),d7			>> Not needed anymore in V2!

	move.l	$4.w,a6
	moveq	#2,d0
	lea	_AEDoorLib(PC),a1
	jsr	_LVOOpenLibrary(a6)
	lea	_AEDBase(PC),a0
	move.l	d0,(a0)			* You SHOULD test if this fails!!!


	;move.b	d7,d0			;Get Node Numba!
	;				>> Not needed anymore in V2!

	move.l	_AEDBase(PC),a6
	jsr	_LVOCreateComm(a6)
	lea	_DIF(PC),a0
	move.l	d0,(a0)
	beq	byebye			; /X not running?


	lea	MyString(PC),a0
	moveq	#0,d1			;NO special flags
	move.l	_DIF(PC),a1
	jsr	_LVOWriteStr(a6)

	move.l	#JH_SYSOP,d0		;Get SYSOP name
	jsr	_LVOSendCmd(a6)		;JHM_String will contain the name

	move.l	#JH_WRITE,d0		;Don't overwrite string so that we can
	jsr	_LVOSendCmd(a6)		;use SendCmd() instead of WriteStr()


	lea	Done(PC),a0
	moveq	#WSF_LF,d1		;LF Flag
	move.l	_DIF(PC),a1
	jsr	_LVOWriteStr(a6)

	move.l	_DIF(PC),a1
	jsr	_LVODeleteComm(a6)

byebye:	move.l	a6,a1
	move.l	$4.w,a6
	jsr	_LVOCloseLibrary(a6)
	moveq	#0,d0
	rts

_AEDoorLib:	dc.b	'AEDoor.library',0
_AEDBase:	dc.l	0
_DIF:		dc.l	0

MyString:	dc.b	"Sysop name is ",0
Done:		dc.b	10,13,"Done.",0
