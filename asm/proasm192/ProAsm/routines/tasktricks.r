
;---;  tasktricks.r  ;-------------------------------------------------------------
*
*	****	SOME NIFTY LITTLE ROUTINES FOR TASKS    ****
*
*	Author		Stefan Walter
*	Add. Code	Daniel Weber
*	Version		1.16
*	Last Revision	13.06.93
*	Identifier	ttr_defined
*	Prefix		ttr_	(task tricks)
*				 ¯    ¯¯
*	Macros		GetTaskPCPtr_, Forbid_, Permit_, Disable_, Enable_
*			Supervisor_, GetCCR_, GetSR_, FindTask_, FindName_
*			GetVBR_, User_, ClearCaches_, PrevState_
*			DoRaw_, DoRawCnt_, InitList_, RestoreTDID_, SpaceKiller_,
*			NoReq_, SetReq_, RestoreReq_
*
;------------------------------------------------------------------------------

;------------------
	ifnd	ttr_defined
ttr_defined	=1

;------------------
ttr_oldbase	equ __base
	base	ttr_base
ttr_base:

;------------------

;------------------------------------------------------------------------------
*
* GetTaskPCPtr_	Get address of PC in the stack of a task which is
*		ready or waiting, concidering FPU frames on stack.
*		If attempted on thistask, 0 is returned.
*
* INPUT:	a0	Task address
*
* RESULT:	a0	Pointer to address where PC is stored or 0.
*
* NOTE:		a0+0.l		=PC		a0+4.w		=SR
*		a0+6+n*4.l	=Dn		a0+38+n*4.l	=An (exc. a7)
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
GetTaskPCPtr_	macro
	ifd	ttr_GetTaskPCPtr
		bsr	ttr_GetTaskPCPtr
	else
		pea	.ttr_end1(pc)

;------------------
; Check for presence of FPU.
;
ttr_GetTaskPCPtr	=	*
	movem.l	d0/a6,-(sp)
	move.l	4.w,a6
	cmp.l	$114(a6),a0
	beq.s	.ttr_task1
	move.l	54(a0),a0	;SP
	btst	#4,297(a6)	;FPU 81/82?
	beq.s	.ttr_exit1


;------------------
; FPU present, check frame size.
;
.ttr_fpu1:
	move.b	(a0),d0
	beq.s	.ttr_nos1

	lea	(2+4*3+12*8)(a0),a0
	cmp.b	#$90,d0
	bne.s	.ttr_nos1
	lea	4*3+2(a0),a0

.ttr_nos1:
	moveq	#4,d0			;frame size for NULL frame
	tst.b	(a0)
	beq.s	.ttr_gotit1
	move.b	1(a0),d0		;fpu frame size

.ttr_gotit1:
	add.w	d0,a0



;------------------
; Got pointer and go.
;
.ttr_exit1:
	movem.l	(sp)+,d0/a6
	rts

.ttr_task1:
	suba.l	a0,a0
	bra.s	.ttr_exit1

;------------------
; End of macro.
;
.ttr_end1:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* Forbid_	Call Forbid(). No registers changed.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
Forbid_		macro
	ifd	ttr_Forbid
		bsr	ttr_Forbid
	else
		pea	.ttr_end2(pc)

;------------------
; Forbid().
;
ttr_Forbid	=	*
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	-132(a6)		;Forbid()
	move.l	(sp)+,a6
	rts

;------------------
; End of macro.
;
.ttr_end2:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* Permit_	Call Permit(). No registers changed.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
Permit_		macro
	ifd	ttr_Permit
		bsr	ttr_Permit
	else
		pea	.ttr_end3(pc)

;------------------
; Permit().
;
ttr_Permit	=	*
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	-138(a6)		;Permit()
	move.l	(sp)+,a6
	rts

;------------------
; End of macro.
;
.ttr_end3:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* Disable_	Call Disable(). No registers changed.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
Disable_	macro
	ifd	ttr_Disable
		bsr	ttr_Disable
	else
		pea	.ttr_end4(pc)

;------------------
; Disable().
;
ttr_Disable	=	*
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	-120(a6)		;Disable()
	move.l	(sp)+,a6
	rts

;------------------
; End of macro.
;
.ttr_end4:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* Enable_	Call Enable(). No registers changed.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
Enable_		macro
	ifd	ttr_Enable
		bsr	ttr_Enable
	else
		pea	.ttr_end5(pc)

;------------------
; Enable().
;
ttr_Enable	=	*
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	-126(a6)		;Enable()
	move.l	(sp)+,a6
	rts

;------------------
; End of macro.
;
.ttr_end5:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* RestoreTDID_	Do Enable() and Permit() to go back to initial state.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
RestoreTDID_		macro
	ifd	ttr_RestoreTDID
		bsr	ttr_RestoreTDId
	else
		pea	.ttr_end15(pc)

;------------------
; Enable().
;
ttr_RestoreTDID	=	*
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	-120(a6)		;Disable()
	jsr	-132(a6)		;Forbid()
	clr.w	294(a6)
	jsr	-138(a6)		;Permit()
	jsr	-126(a6)		;Enable()
	move.l	(sp)+,a6
	rts

;------------------
; End of macro.
;
.ttr_end15:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* SupervisorMode_	Enter supervisor mode in the old exec manner
*
* a5:			routine
*
;------------------------------------------------------------------------------
SupervisorMode_	MACRO
		IFD	ttr_SupervisorMode
		bsr	ttr_SupervisorMode
		ELSE
		pea	.ttr_SupervisorModeEnd(pc)
ttr_SupervisorMode	EQU	*
		movem.l	a5/a6,-(a7)
		move.l	4.w,a6
		jsr	-30(a6)
		movem.l	(a7)+,a5/a6
		rts
.ttr_SupervisorModeEnd:
		ENDC
		ENDM


;------------------------------------------------------------------------------
*
* Supervisor_	Enter supervisor mode with supervisor stack. No regs changed.
*		In case of a 68020+, the ISP is used, no matter what the
*		M bit says.
*
* RESULT:	d0	Old SR. CCR is not guaranteed by Exec.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
Supervisor_	macro
	ifd	ttr_Supervisor
		bsr	ttr_Supervisor
	else
		pea	.ttr_end6(pc)

;------------------
; Clean up old stack
;
ttr_Supervisor	=	*
	pea	(a6)			;	v	v
	lea	.ttr_regs6(pc),a6	
	movem.l	a4/a5,(a6)
	movea.l	(sp)+,a4
	movem.l	a4,8(a6)		;ALL THIS DOES NOT CHANGE CCR
	move.l	(sp)+,a4		;where to go
	movea.l	4.w,a6
	lea	.ttr_super6(pc),a5	;	^	^
	jmp	-30(a6)			;Supervisor()

;------------------
; Supervisor routine.
; 
.ttr_super6:
	move.l	a4,2(a7)
	move.w	(a7),d0
	move.w	#$2000,(a7)
	movem.l	.ttr_regs6(pc),a4-a6
	rte

.ttr_regs6:
	dc.l	0,0,0

;------------------
; End of macro.
;
.ttr_end6:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* User_		Return to user state.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
User_	macro
	andi.w	#$dfff,sr
	endm

;------------------

;------------------------------------------------------------------------------
*
* PrevState_	Return to previous state.
*
* INPUT:	d0	Old SR register.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
PrevState_	macro
	move.w	d0,sr
	endm

;------------------

;------------------------------------------------------------------------------
*
* GetSR_	Gets entier SR. If the CCR would be guaranteed for Supervisor()
*		This routine could get a lot easier. No regs changed.
*
* RESULT:	d0	SR
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
GetSR_		macro
	ifd	ttr_GetSR
		bsr	ttr_GetSR
	else
		pea	.ttr_end7(pc)

;------------------
; Get CCR, call supervisor and merge regs.
;
ttr_GetSR	=	*
	GetCCR_
	andi.w	#$ff,d0		;mask out CCR
	move.w	d0,-(sp)	
	Supervisor_
	clr.b	d0		;mask out SR
	move.w	d0,sr
	or.w	(sp)+,d0	;=>SR
	rts

;------------------
; End of macro.
;
.ttr_end7:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* GetCCR_	Gets CCR the right way. No regs changed.
*
* RESULT:	d0	CCR
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
GetCCR_		macro
	ifd	ttr_GetCCR
		bsr	ttr_GetCCR
	else
		pea	.ttr_end8(pc)

;------------------
; Jump to right routine.
;
ttr_GetCCR	=	*
	movem.l	d1-d4,-(sp)
	scs	d1	;C
	svs	d2	;V
	seq	d3	;Z
	smi	d4	;N
	roxl.b	#1,d0	;X
	roxr.b	#1,d4
	roxl.b	#1,d0
	roxr.b	#1,d3
	roxl.b	#1,d0
	roxr.b	#1,d2
	roxl.b	#1,d0
	roxr.b	#1,d1
	roxl.b	#1,d0
	and.w	#$1f,d0
	movem.l	(sp)+,d1-d4
	rts

;------------------
; End of macro.
;
.ttr_end8:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* FindTask_	Find task structure with Forbid()/Permit().
*
* INPUT:	a1	Name
*
* RESULT:	d0	Struct or 0
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
FindTask_		macro
	ifd	ttr_FindTask
		bsr	ttr_FindTask
	else
		pea	.ttr_end9(pc)

;------------------
; Jump to right routine.
;
ttr_FindTask	=	*
	movem.l	d1-a6,-(sp)
	Forbid_
	move.l	4.w,a6
	jsr	-294(a6)		;FindTask()
	Permit_
	movem.l	(sp)+,d1-a6
	rts	

;------------------
; End of macro.
;
.ttr_end9:
	endif
	endm
	
;------------------

;------------------------------------------------------------------------------
*
* FindName_	Find a node in a list, with Forbid()/Permit().
*
* INPUT:	a0	List
*		a1	Name
*
* RESULT:	d0	Struct or 0
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
FindName_	macro
	ifd	ttr_FindName
		bsr	ttr_FindName
	else
		pea	.ttr_end10(pc)

;------------------
; Jump to right routine.
;
ttr_FindName	=	*
	movem.l	d1-a6,-(sp)
	Forbid_
	move.l	4.w,a6
	jsr	-276(a6)		;FindName()
	Permit_
	movem.l	(sp)+,d1-a6
	rts	

;------------------
; End of macro.
;
.ttr_end10:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* GetVBR_	Get the VBR register for 68010+. Returns 0 for 68000.
*
* RESULT:	d0	VBR or 0 for 68000.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
GetVBR_	macro
	ifd	ttr_GetVBR
		bsr	ttr_GetVBR
	else
		pea	.ttr_end11(pc)

;------------------
; Jump to right routine.
;
ttr_GetVBR	=	*
	movem.l	d1/a6,-(sp)
	moveq	#0,d0
	movea.l	4.w,a6
	btst	#0,296+1(a6)		;ATTN flags
	beq.s	.ttr_GetVBRend

	Supervisor_
	dc.w	$4e7a,$1801		;movec	vbr,d1
	PrevState_			;return to previous mode
	move.l	d1,d0

.ttr_GetVBRend:
	movem.l	(sp)+,d1/a6
	rts
	
;------------------
; End of macro.
;
.ttr_end11:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* ClearCaches_	Clear all caches. Does nothing for 68000/10.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
ClearCaches_	macro
	ifd	ttr_ClearCaches
		bsr	ttr_ClearCaches
	else
		pea	.ttr_end12(pc)

;------------------
; Jump to right routine.
;
ttr_ClearCaches	=	*
	movem.l	d0-d2/a0-a1/a6,-(sp)
	movea.l	4.w,a6

	IFND	cws_V36PLUSONLY
	btst	#1,296+1(a6)		;ATTN flags
	beq.s	.ttr_ClearCachesend	;68000/10 => don't do
	cmp.w	#36,20(a6)		;2.0 or better?
	bhs.s	.ttr_ClearCachesExec

	Supervisor_
	dc.w	$4e7a,$1002		;movec	cacr,d1
	move.w	#$8000,d2
	dc.w	$4e7b,$2002		;movec	d2,cacr
	dc.w	$4e7a,$2002		;movec	cacr,d2
	tst.w	d2
	bmi.s	.ttr_CacheClearforty
	or.w	#$808,d1		;data and instruction cache clear
	bra.s	.ttr_ClearCachesdone

.ttr_CacheClearforty:
	dc.w	$f4f8			;cpusha

.ttr_ClearCachesdone:
	dc.w	$4e7b,$1002		;movec	d1,cacr
	PrevState_
	bra.s	.ttr_ClearCachesend	
	ENDIF

.ttr_ClearCachesExec:
	jsr	-636(a6)		;CacheClearU()

.ttr_ClearCachesend:
	movem.l	(sp)+,d0-d2/a0-a1/a6
	rts
	
;------------------
; End of macro.
;
.ttr_end12:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* DoRaw_	Call RawDoFmt.
*
*	a0:	format string
*	a1:	data
*	a3:	buffer
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
DoRaw_	macro
	ifd	ttr_DoRaw
		bsr	ttr_DoRaw
	else
		pea	.ttr_end13(pc)

;------------------
; Jump to right routine.
;
ttr_DoRaw	=	*
	movem.l	d0-d3/a0-a3/a6,-(sp)
	movea.l	4.w,a6
	lea	.setin(pc),a2
	jsr	-522(a6)		;RawDOFmt()
	movem.l	(sp)+,d0-d3/a0-a3/a6
	rts

.setin:	move.b	d0,(a3)+
	rts

;------------------
; End of macro.
;
.ttr_end13:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* DoRawCnt_	Count number of bytes used for the result string of DoRaw_.
*
*	a0:	format string
*	a1:	data
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
DoRawCnt_	macro
	ifd	ttr_DoRawCnt
		bsr	ttr_DoRawCnt
	else
		pea	.ttr_end132(pc)

;------------------
; Jump to right routine.
;
ttr_DoRawCnt	=	*
	movem.l	d1-d3/a0-a3/a6,-(sp)
	lea	.counter(pc),a3
	clr.l	(a3)
	movea.l	4.w,a6
	lea	.setin2(pc),a2
	jsr	-522(a6)		;RawDOFmt()
	move.l	.counter(pc),d0
	movem.l	(sp)+,d1-d3/a0-a3/a6
	rts

.setin2:addq.l	#1,(a3)
	rts

.counter:
	dc.l	0

;------------------
; End of macro.
;
.ttr_end132:
	endif
	endm

;------------------

;------------------------------------------------------------------------------
*
* InitList_	Init a list.
*
* USAGE:	InitList_		Init list at a0.
*		InitList_ (MyList)	Init MyList.
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
InitList_	macro
	IFNC	'\1',''
	lea	\1(pc),a0
	ENDIF
	ifd	ttr_InitList
		bsr	ttr_InitList
	else
		pea	.ttr_end14(pc)

;------------------
; Jump to right routine.
;
ttr_InitList	=	*
	pea	4(a0)
	move.l	(sp)+,(a0)
	clr.l	4(a0)
	move.l	a0,8(a0)
	rts

;------------------
; End of macro.
;
.ttr_end14:
	endif
	endm


;------------------

;------------------------------------------------------------------------------
*
* SpaceKiller_	Standard space killer function for A0.
*
* USAGE:	SpaceKiller_
*
;------------------------------------------------------------------------------

;------------------
; Macro
;
SpaceKiller_	macro
	ifd	ttr_SpaceKiller
		bsr	ttr_SpaceKiller
	else
		pea	.ttr_end16(pc)

;------------------
; Jump to right routine.
;
ttr_SpaceKiller	=	*
	cmp.b	#" ",(a0)+
	beq.s	ttr_SpaceKiller
	subq.l	#1,a0
	rts

;------------------
; End of macro.
;
.ttr_end16:
	endif
	endm

;------------------


;------------------------------------------------------------------------------
*
* NoReq_	disable requesters, be 'quietly'
* SetReq_	set pr_WindowPtr field
* ResetReq_	set pr_WindowPtr field (SetReq_ = ResetReq_)
*
* NoReq_ returns old WindowPtr in d0.
*
* SetReq_ and ResetReq_ expect a value (for pr_WindowPtr) in d0.
*
;------------------------------------------------------------------------------

;------------------
*
* NoReq_
*
NoReq_	MACRO
	IFD	ttr_NoReq
		bsr	ttr_NoReq
	ELSE
		pea	.ttr_NoReqEnd(pc)

;------------------
; NoReq().
ttr_NoReq	EQU	*
	movem.l	d1/a1,-(a7)
	move.l	4.w,a1
	move.l	$114(a1),a1		; ThisTask
	move.l	$b8(a1),d0		; pr_WindowPtr
	moveq	#-1,d1
	move.l	d1,$b8(a1)		; pr_WindowPtr
	movem.l	(a7)+,d1/a1
	rts
.ttr_NoReqEnd:
	ENDC
	ENDM





;------------------
*
* SetReq_
*
SetReq_	MACRO
	IFD	ttr_SetReq
		bsr	ttr_SetReq
	ELSE
		pea	.ttr_SetReqEnd(pc)

;------------------
; SetReq().
ttr_SetReq	EQU	*
	move.l	a1,-(a7)
	move.l	4.w,a1
	move.l	$114(a1),a1		; ThisTask
	move.l	d0,$b8(a1)		; pr_WindowPtr
	move.l	(a7)+,a1
	rts
.ttr_SetReqEnd:
	ENDC
	ENDM



;------------------
*
* RestoreReq_
*
RestoreReq_	MACRO
	SetReq_
	ENDM




;--------------------------------------------------------------------

;------------------
	base	ttr_oldbase

;------------------
	endif

	end

