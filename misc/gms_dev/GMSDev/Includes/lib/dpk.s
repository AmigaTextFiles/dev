;=======T=======T========================T==========================================;
;Name:      DPKernel start-up file.
;Author:    Paul Manias.
;Date:      February 1998
;Copyright: DreamWorld Productions (c) 1996-1998.  All rights reserved.

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"
	INCLUDE	"system/tasks.i"

	xref	_main
	xref	_ProgVersion
	xref	_ProgRevision
	xref	_ProgAuthor
	xref	_ProgCopyright
	xref	_ProgDate
	xref	_ProgName
	xref	_ProgShort

	xdef	_Args
	xdef	_BLTBase
	xdef	_DPKBase
	xdef	_FILBase
	xdef	_GVBase
	xdef	_SCRBase
	xdef	_SNDBase
	xdef	_BLTModule
	xdef	_FILModule
	xdef	_SCRModule
	xdef	_SNDModule
	xdef	_SysBase
	xdef	_Table
	xdef	__XCEXIT

	SECTION	"DPKStart",CODE

;===================================================================================;
;                            SPECIAL STARTUP CODE
;===================================================================================;

Start:	bra.s	StartAmigaDOS

_Table:	dc.l	"PRGM"	;ID Header.
	dc.w	1	;Version number.
	dc.w	JMP_LVO	;Type of jump table to get from DPK.
	dc.l	StartDPKernel	;Start of program.
	dc.l	_ProgName	;Name of the program.
	dc.l	_ProgAuthor	;Who wrote the program.
	dc.l	_ProgDate	;Date of compilation.
	dc.l	_ProgCopyright	;Copyright details.
	dc.l	_ProgShort	;Short description of program.
	dc.w	DPKVersion	;Minimum required DPKernel version.
	dc.w	DPKRevision	;Minimum required DPKernel revision.

StartDPKernel:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	move.l	($4).w,_SysBase
	move.l	GT_DPKBase(a0),_DPKBase
	move.l	GT_DPKBase(a0),_GVBase
	bra.s	Launch

StartAmigaDOS
	MOVEM.L	D0-D7/A0-A6,-(SP)
	move.l	($4).w,_SysBase

.Check	move.l	_SysBase(pc),a6
	sub.l	a1,a1
	jsr	-294(a6)	;>> = FindTask
	move.l	d0,a4
	tst.l	172(a4)	;a4 = pr_CLI
	bne.s	.DOS

.WBench	lea	92(a4),a0	;a0 = pr_MsgPort
	jsr	-384(a6)	;>> = WaitPort()

	lea	92(a4),a0	;a0 = pr_MsgPort
	jsr	-372(a6)	;>> = GetMsg()
	move.l	d0,ReturnMsg	;ma = Store message.

.DOS	move.l	_SysBase(pc),a6	;a6 = ExecBase
	lea	DPKName(pc),a1	;a1 = Library name.
	moveq	#$00,d0	;d0 = Any version.
	jsr	-552(a6)	;>> = OpenLibrary()
	move.l	d0,_GVBase	;ma = Save global variable base.
	move.l	d0,_DPKBase	;ma = Save base.
	beq.s	ErrDPK	;>> = Error, exit.
	move.w	#1,DOS

	move.l	d0,a6	;a6 = DPKBase.
	lea	Exit(pc),a0	;a0 = Pointer to SelfDestruct() cleanup.
	move.l	a7,a1	;a1 = Stack pointer.
	CALL	InitDestruct	;>> = Initialise the call.

Launch:	move.l	_DPKBase(pc),a6
	moveq	#MOD_SCREENS,d0
	sub.l	a0,a0
	CALL	OpenModule
	move.l	d0,_SCRModule
	beq.s	Exit
	move.l	d0,a5
	move.l	MOD_ModBase(a5),_SCRBase

	moveq	#MOD_SOUND,d0
	sub.l	a0,a0
	CALL	OpenModule
	move.l	d0,_SNDModule
	beq.s	Exit
	move.l	d0,a5
	move.l	MOD_ModBase(a5),_SNDBase

	moveq	#MOD_BLITTER,d0
	sub.l	a0,a0
	CALL	OpenModule
	move.l	d0,_BLTModule
	beq.s	Exit
	move.l	d0,a5
	move.l	MOD_ModBase(a5),_BLTBase

	moveq	#MOD_FILES,d0
	sub.l	a0,a0
	CALL	OpenModule
	move.l	d0,_FILModule
	beq.s	Exit
	move.l	d0,a5
	move.l	MOD_ModBase(a5),_FILBase

	move.l	_DPKBase(pc),a6
	jsr	_main

__XCEXIT:
Exit:	move.l	_DPKBase(pc),a6	;a6 = DPKBase
	move.l	_FILModule(pc),a0
	CALL	Free
	move.l	_SCRModule(pc),a0
	CALL	Free
	move.l	_BLTModule(pc),a0
	CALL	Free
	move.l	_SNDModule(pc),a0
	CALL	Free

	tst.w	DOS
	beq.s	ProgEnd
	CALL	CloseDPK

	move.l	ReturnMsg(pc),d0
	beq.s	ProgEnd
	move.l	_SysBase(pc),a6
	jsr	-378(a6)

ProgEnd:
ErrDPK:	MOVEM.L	(SP)+,D0-D7/A0-A6
	moveq	#$00,d0
	rts

DOS:		dc.w  0
ReturnMsg:	dc.l  0

_BLTBase:	dc.l  0
_FILBase:	dc.l  0
_SCRBase:	dc.l  0
_SNDBase:	dc.l  0
_SysBase:	dc.l  0

_BLTModule:	dc.l  0
_FILModule:	dc.l  0
_SCRModule:	dc.l  0
_SNDModule:	dc.l  0

_DPKBase:	dc.l  0	;DPKBase.
_GVBase:	dc.l  0 	;Global variable base.
_Args:		dc.l  0	;Pointer to argument string.

DPKName:	dc.b  "GMS:libs/dpkernel.library",0
		even

