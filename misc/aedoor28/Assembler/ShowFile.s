	OPT	USER,W-
**
**	$Filename: ShowFile.s $
**	$Release: 0.1 $
**	$Revision: 1.00 $
**	$Date: 92/09/17 $
**
**	Demonstrate how to show a file
**

	INCLUDE	exec/types.i
	INCLUDE	exec/exec_lib.i
	INCLUDE	exec/nodes.i
	INCLUDE	exec/ports.i
	INCLUDE	exec/memory.i
	INCLUDE	amix/amix.i
	INCLUDE	amix/aedoor.i

Start:
	move.b	(a0),d7

	move.l	$4.w,a6
	moveq	#0,d0
	lea	_AEDoorLib(PC),a1
	jsr	_LVOOpenLibrary(a6)
	lea	_AEDBase(PC),a0
	move.l	d0,(a0)


	move.b	d7,d0			;Get Node Numba!
	move.l	_AEDBase(PC),a6
	jsr	_LVOCreateComm(a6)
	lea	_DIF(PC),a0
	move.l	d0,(a0)
	beq	byebye


	;----- Show a text file
	lea	_Text(PC),a0
	move.l	_DIF(PC),a1
	jsr	_LVOShowFile(a6)


	move.l	_DIF(PC),a1
	jsr	_LVODeleteComm(a6)

byebye:	move.l	a6,a1
	move.l	$4.w,a6
	jsr	_LVOCloseLibrary(a6)
	moveq	#0,d0
	rts

_AEDBase:	dc.l	0
_DIF:		dc.l	0

_AEDoorLib:	dc.b	'AEDoor.library',0
_Text:		dc.b	'S:User-Startup',0
