;-------T-------T------------------------T------------------------------------------;

	xdef	_LaunchTask
	xdef	_DPKBase

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"
	INCLUDE	"files/segments.i"
	INCLUDE	"system/tasks.i"

;===================================================================================;
;                                    LAUNCH CODE
;===================================================================================;
;This part had to be written in assembler due to the InitDestruct() code, which
;requires a correct stack pointer.

	SECTION	"LaunchTask",CODE

_LaunchTask:
	MOVEM.L	D0-D7/A0-A6,-(SP)	;SP = Save registers.
	move.l	a0,a5	;a5 = Segment.
	move.l	a1,a4	;a4 = StartUp.

	;Initialise self-destruct sequence.

	move.l	_DPKBase(pc),a6	;a6 = DPKBase.
	lea	.exit(pc),a0	;a0 = Pointer to SelfDestruct() cleanup.
	move.l	a7,a1	;a1 = Stack pointer.
	CALL	InitDestruct	;>> = Initialise the call.

	;Setup parameters here.  Search for
	;"PRGM" header to launch program.

	move.l	SEG_Address(a5),a0	;a0 = Segment start.
	move.l	a0,a1
	lea	64(a1),a1
.loop	cmp.l	a1,a0
	bgt.s	.exit
	cmp.w	#"PR",(a0)+
	bne.s	.loop
	cmp.w	#"GM",(a0)+
	bne.s	.loop
	subq.w	#4,a0

	;Table is now in a0.

	move.l	_DPKBase(pc),a6
	CALL	FindDPKTask
	tst.l	d0
	beq.s	.exit
	move.l	d0,a1	;a1 = DPKTask

	move.l	_DPKBase(pc),GT_DPKBase(a1)
	move.l	_DPKBase(pc),GT_GVBase(a1)
	move.l	#$00,GT_Args(a1)	;No arg support yet.

	move.w	DPK_DPKType(a0),GT_DPKTable(a1)
	move.l	DPK_Start(a0),GT_Code(a1)
	move.l	DPK_Name(a0),GT_Name(a1)
	move.l	DPK_Author(a0),GT_Author(a1)
	move.l	DPK_Date(a0),GT_Date(a1)
	move.l	DPK_Copyright(a0),GT_Copyright(a1)
	move.l	DPK_Short(a0),GT_Short(a1)
	move.w	DPK_MinVersion(a0),GT_MinVersion(a1)
	move.w	DPK_MinRevision(a0),GT_MinRevision(a1)

	move.l	a1,a0	;a0 = DPKTask
	sub.l	a1,a1	;a1 = Null
	sub.l	a2,a2	;a2 = Null
	sub.l	a3,a3	;a3 = Null
	sub.l	a4,a4	;a4 = Null
	move.l	GT_Code(a0),a5	;a5 = Code
	cmp.l	#$00,a5	;a5 = Check for NULL.
	beq.s	.exit	;>> = Error in structure, exit.
	move.l	_DPKBase(pc),a6	;a6 = DPKBase
	move.l	#$00,d0	;d0 = ID
	moveq	#$00,d1	;d1 = Null
	moveq	#$00,d2	;d2 = Null
	moveq	#$00,d3	;d3 = Null
	moveq	#$00,d4	;d4 = Null
	moveq	#$00,d5	;d5 = Null
	moveq	#$00,d6	;d6 = Null
	moveq	#$00,d7	;d7 = Null
	jsr	(a5)	;>> = Start the DPK program.
.exit	MOVEM.L	(SP)+,D0-D7/A0-A6
	rts

_DPKBase:	dc.l  0

