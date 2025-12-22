; FILE: Source:SmartCrash.ASM          REV: 184 --- System failure req replacement
; History
;  79     Working.
;  100    Fixed.
;  150    Fixed alert fallback.
;  151    Strange crashes with PPC equipped systems.
;  156    Still trying to fix these crashes.
;  183    LaunchProc bugged.
;  184    Froze 1.3.0 aminet.
;

; Release version 1.3.0

; Total rewrite, removed several hacks & bugs, including:
; - LaunchProc was bugged (would have crashed)
; - Removed usage of fixed signal bits, when possible
; - Removed SegList cutting
; - Now uses FindTask(0) instead of directly accessing ExecBase ThisTask
; - Replaced FindName on ExecBase LibList with OpenLibrary calls
; - Removed several possible race conditions
; - Now always keeps stack pointer longword aligned
; - Now does LoadView(0) & 2 x WaitTOF(0) before ColdReboot()
; - Now if AddTask() fails LaunchTask does FreeEntry() for TCB & stack
; - Now LaunchTask/LaunchProc make sure stacksize is quodword aligned
; - No longer passes invalid TextAttr to rtEZRequestA()
; - Now .ChangeTrapCode checks for SMARTCRASH13_ID from custom TC_TRAPCODE
; - Added support for PatchControl
; - Now .remove tries to restore TC_TRAPCODE for every task/process possible
; - Default task/proc trap handlers are now retrieved properly
; - 'exit & free' renamed to 'remove'
; - 'remove' now closes all windows & screens owned by task
; - Now `skip' handles all 68851/68040/68060/CPU32 f-line emulators and
;   privilege violations
; - Now supports 6888x/68040/68060 FPU vectors 48 to 55 and 68060 vectors 60
;   and 61
; - Fixed crashes with multiple requesters, these were due bad access of
;   global CD_Task. See Trap_UserPart
; - Added support for 68000 bus and address error exception stack frames,
;   failed miserably before. 68000 uses separate exception handler
; - No longer uses TC_TRAPCODE to pass arguments but TC_TRAPDATA (wow!)
; - Now SegTrackerInfo also checks stack at word boundaries
; - Debug button could have trashed rtEZRequestA() call a1 register on .redo_rtreq,
;   default void Debug() only does moveq #0,d0;rts so this bug was hiding... :)
; - New buttons 'rts' (jmp to rts with current stack) and 'jmp...' (jmp to
;   address entered to a number requester).
; - Now forces stack address even before CD_StackFrame copy
; - Can't hang anymore on FindPort/AddPort race condition
; - More information output on argument error
;
; - Currently only hack is to change SS_OWNER to allow different task to
;   ReleaseSemaphore owned semaphore
;
; - Optimized/cleaned up code

; todo (maybe):
; - FORCE/S replace even unknown (non-dos/exec) trap handlers
; - SERIAL/S add serial output of any software error before displaying requester
;   use _LVORawPutChar (-$204)
;   (these two would be for tnt v37.2 compatibility)
;
; - Make use of INSTSIZE ?
;
; - New buttons: 'Modify...' '%sDX|%sAX|%sPC|%sSR|run mon|%sCancel' ??
; - removal of semaphore = use big message to deliver CD ?
; - parallel and serial support, disassembler?
; - fpu f-line skip:
;   o normally fpu instructions are long with fixed pos <ea>
;   o special cases:
;     - FBcc
;     - FDBcc
;     - FMOVECR
;     - FNOP
;     - FTRAPcc .W .L
;     - cpSAVE    word
;     - cpRESTORE word

	OPT	p=68010,ow-,o+

	include	"Devpac:Gen.gs"
;	include	"dos/dosextens.i"
;	include	"intuition/intuition.i"
	include	"dos/dostags.i"
	include	"libraries/intuition_lib.i"
	include	"libraries/diskfont_lib.i"
	include	"libraries/reqtools_lib.i"
	include	"libraries/reqtools.i"

	include	"requestlong.i"

ARG_USEREQTOOLS	EQU	0
ARG_RTFONT	EQU	1
ARG_RTFONTSIZE	EQU	2
ARG_NUMARGS	EQU	3

MAXFONTNAMELEN	EQU	32

	STRUCTURE MyMes,MN_SIZE
	APTR	MyMes_SigTask
	ULONG	MyMes_InitOkSigMask
	ULONG	MyMes_RemovedSigMask
	LABEL	MyMes_SIZEOF
MyMes_Type	EQU	LN_NAME

MMTYPE_REMOVE	EQU	1
MMTYPE_REPORT	EQU	2

NUMSCGADGETS	EQU	7			; reboot doesn't have shortcut!
GADG_SKIP	EQU	1
GADG_REMOVE	EQU	2
GADG_EXIT	EQU	3
GADG_DEBUG	EQU	4
GADG_REBOOT	EQU	5
GADG_Modify	EQU	6
GADG_RTS	EQU	7
GADG_SUSPEND	EQU	0

; 'Modify...'
; '%sDX|%sAX|%sPC|%sSR|run mon|%sCancel'
; 'D%s0|D%s1|D%s2|D%s3|D%s4|D%s5|D%s6|D%s7|%sCancel'
; 'A%s0|A%s1|A%s2|A%s3|A%s4|A%s5|A%s6|A%s7|%sCancel'

ACTION_SKIP	EQU	0			skip instruction
ACTION_EXIT	EQU	2			exit program
ACTION_JMP	EQU	4			jump to address in CD_ProgramCounter

SMARTCRASH13_ID	EQU	'SC13'
SC13IDPOS	EQU	10			_idpos-TrapEntry

WAKE_SIGNAL	EQU	SIGB_SINGLE		4
;FIXED_SKIPPED_SIGNAL	EQU	23
;HACKSEMAPHORE	EQU	1
;FINDTASKBUG	EQU	1
;INSTSIZE	EQU	1

	STRUCTURE CrashDataStruct,0
	STRUCT	CD_MySemaphore,SS_SIZE
	LABEL	CD_CD
	BYTE	CD_TrapNumber
	BYTE	CD_KludgeFill00_1
	UWORD	CD_Action		; Used with WAKE_SIGNAL, see ACTION_* above
	ULONG	CD_sigf_SKIPPED
	APTR	CD_PrevTRAPDATA
	LONG	CD_ExceptionNumber
	APTR	CD_ExceptionStr1
	APTR	CD_ExceptionStr2
	APTR	CD_ExceptionStr3
	APTR	CD_Task
	APTR	CD_ProgramCounter
	WORD	CD_KludgeFill00_2
	WORD	CD_StatusRegister
	APTR	CD_UserStackPtr
	APTR	CD_SuperStackPtr
	STRUCT	CD_DataRegs,8*4
	APTR	CD_AddrReg_0
	STRUCT	CD_AddrRegs_1_6,6*4
	APTR	CD_StackPtr
	STRUCT	CD_StackFrame,16*4
	APTR	CD_TaskType		; CLI/Process/Task
	APTR	CD_TaskName
	APTR	CD_SegTrackerInfo
	LABEL	CD_CD_END
	LABEL	CD_SIZE

	IFGT	(CD_CD_END-CD_CD)&3
	FAIL	"(CD_CD_END-CD_CD) not longword aligned!"
	ENDC

Main	move.l	(4).w,a6
	moveq	#37,d7
	cmp.w	(LIB_VERSION,a6),d7
	bhs	.no37

	moveq	#RETURN_ERROR,d7

	sub.l	a1,a1
	call	FindTask
	move.l	d0,SigThisTask

	; Allocate signals...

	moveq	#-1,d0
	call	AllocSignal
	move.l	d0,sigb_REMOVED
	bmi	.nosig1
	moveq	#1,d1
	lsl.l	d0,d1
	move.l	d1,sigf_REMOVED

	moveq	#-1,d0
	call	AllocSignal
	move.l	d0,sigb_INITOK
	bmi	.nosig2
	moveq	#1,d1
	lsl.l	d0,d1
	move.l	d1,sigf_INITOK

	; Open dos

	lea	(DosName,pc),a1
	bsr	openlib
	move.l	d0,DosBase
	beq	.nodos

	; Get DefTaskTrap and DefProcTrap

	bsr	GetDefTraps

	; Greet

	lea	(AboutMessage,pc),a0
	bsr	Printf

	; Test if already installed

	lea	(PortName,pc),a1
	call	Forbid
	call	FindPort
	tst.l	d0
	beq.b	.install

	; Send quit request to active SmartCrash

	move.l	(sigf_REMOVED,pc),-(sp)	MyMes_RemovedSigMask
	move.l	(sigf_INITOK,pc),-(sp)	MyMes_InitOkSigMask
	move.l	(SigThisTask,pc),-(sp)	MyMes_SigTask
	pea	MyMes_SIZEOF		MN_REPLYPORT:16, MN_LENGTH
	clr.l	-(sp)			LN_NAME:16, MN_REPLYPORT:16
	pea	MMTYPE_REMOVE<<8	LN_TYPE, LN_PRI, LN_NAME:16
	clr.l	-(sp)			LN_PRED
	clr.l	-(sp)			LN_SUCC
	move.l	sp,a1
	move.l	d0,a0			a0=MsgPort!
	call	PutMsg
	call	Permit
	; Wait subtask to exit
	move.l	(sigf_INITOK,pc),d0
	or.l	(sigf_REMOVED,pc),d0
	call	Wait
	lea	(MyMes_SIZEOF,sp),sp

	lea	(sRemoved,pc),a0
	bsr	Printf
	moveq	#RETURN_WARN,d7
	bra	.cantinst

	; Install SmartCrash to memory

.install	call	Permit
	move.l	(DefTaskTrap,pc),d0
	bne.b	.doinstall
	lea	(sTrapUsed,pc),a0
	bsr	Printf
	bra	.cantinst
.doinstall
	lea	(GfxName,pc),a1
	bsr	openlib
	move.l	d0,_GfxBase

	move.l	(DosBase,pc),a6
	move.l	#Template,d1
	move.l	#ArgArray,d2
	moveq	#0,d3
	call	ReadArgs
	move.l	d0,RDArgs
	beq	.noargs

	move.l	(4).w,a6
	move.l	(ArgArray+ARG_USEREQTOOLS*4,pc),d0
	beq	.noreqtools

	lea	(ReqToolsName,pc),a1
	moveq	#38,d0
	call	OpenLibrary
	move.l	d0,RTBase
	beq.b	.noreqtools

	lea	(TAttr,pc),a4
	move.w	#8,(ta_YSize,a4)	Default size
	move.l	(ArgArray+ARG_RTFONTSIZE*4,pc),d0
	beq.b	.nofsize
	move.l	d0,a0
	move.w	(2,a0),(ta_YSize,a4)
.nofsize
	move.l	(ArgArray+ARG_RTFONT*4,pc),d0
	beq.b	.nofname
	move.l	d0,a0
	lea	(FontName,pc),a1
	move.l	a1,(a4)			(ta_Name,a4)
	moveq	#MAXFONTNAMELEN-1-1,d0
.copy_fname	move.b	(a0)+,(a1)+
	dbeq	d0,.copy_fname

	lea	(DiskFontName,pc),a1
	moveq	#37,d0
	call	OpenLibrary
	tst.l	d0
	beq.b	.no_dfb
	move.l	d0,a6
	move.l	a4,a0
	call	OpenDiskFont
	move.l	d0,FontBase
	move.l	a6,a1
	move.l	(4).w,a6
	call	CloseLibrary
.no_dfb
.nofname
.nofont
.noreqtools
	move.l	(SigThisTask,pc),SigTask

	move.l	#COPY_LEN,d0
	moveq	#MEMF_PUBLIC,d1
	call	AllocVec
	move.l	d0,Copy
	beq	.nomem

	lea	(COPY_START,pc),a0
	move.l	(Copy,pc),a1
	move.l	#COPY_LEN,d0
	call	CopyMemQuick

	move.l	(Copy,pc),a4

	; Fix TextAttr
	move.l	(FontBase,pc),d0
	beq.b	.nofix
	lea	(FontName-COPY_START,a4),a0
	move.l	a0,(TAttr+ta_Name-COPY_START,a4)
.nofix
	call	CacheClearU

	move.l	#2048,d0		Might call intuition
	moveq	#100,d1			Priority 100
	lea	(TaskName-COPY_START,a4),a0
	lea	(TaskCode-COPY_START,a4),a1
	; a3=random
	bsr	LaunchTask
	beq.b	.terror

	; Wait subtask status
	move.l	(sigf_INITOK,pc),d0
	or.l	(sigf_REMOVED,pc),d0
	call	Wait
	and.l	(sigf_INITOK,pc),d0
	beq.b	.nortclose		<- Handles RTBase & Copy itself!

	moveq	#RETURN_OK,d7
	lea	(sInstalled,pc),a0
	bsr	Printf
	bra.b	.nortclose

.terror	move.l	(Copy,pc),a1
	call	FreeVec
.nomem	move.l	(RTBase,pc),a1
 	call	CloseLibrary
.nortclose	move.l	(DosBase,pc),a6
	move.l	(RDArgs,pc),d1
	call	FreeArgs
.cantinst	cmp.w	#RETURN_WARN,d7
	bls.b	.ok
	lea	(sCantInstall,pc),a0
	bsr	Printf
.ok
.nodos	move.l	(4).w,a6
	move.l	(sigb_INITOK,pc),d0
	call	FreeSignal
.nosig2
	move.l	(sigb_REMOVED,pc),d0
	call	FreeSignal
.nosig1
.no37	move.l	d7,d0
	rts


.noargs	call	IoErr
	move.l	d0,d1
	lea	(.argerr,pc),a0
	move.l	a0,d2
	call	PrintFault
	bra	.cantinst
.argerr	dc.b	'argument error',0
	CNOP	0,2


Printf	move.l	a6,-(sp)
	move.l	a0,d1
	move.l	(DosBase,pc),a6
	call	PutStr
	move.l	(sp)+,a6
	rts


GetDefTraps	move.l	(TaskTrapCode,a6),d3

	move.l	(SigThisTask,pc),-(sp)
	move.l	(sigf_INITOK,pc),-(sp)
	move.l	sp,a3			Specialdata = {INITOK sigmask,SigThisTask}
	move.l	#256,d0			Stack = 256 bytes
	moveq	#10,d1			Priority = 10
	sub.l	a0,a0			No special name
	lea	(.proc,pc),a1
	bsr	LaunchProc
	move.l	(sigf_INITOK,pc),d0
	call	Wait
	move.l	(sp)+,d4
	addq.l	#4,sp

	; d3=TaskTrapCode
	; d4=ProcTrapCode

	move.l	(LN_NAME,a6),d0
	move.l	#-$80000,d1
	move.l	d1,d2
	and.l	d1,d0
	and.l	d3,d1
	and.l	d4,d2
	cmp.l	d0,d1
	bne.b	.cantinstall
	cmp.l	d0,d2
	bne.b	.cantinstall

	move.l	d3,DefTaskTrap
	move.l	d4,DefProcTrap
.cantinstall	rts

.proc	move.l	(4).w,a6
	sub.l	a1,a1
	call	FindTask
	move.l	d0,a2
	move.l	(TC_Userdata,a2),a0
	movem.l	(a0),d0/a1
	move.l	(TC_TRAPCODE,a2),(a0)
	jmp	(_LVOSignal,a6)
	

	dc.b	'$VER: SmartCrash 1.3.0 (9.3.00)',10,0
	dc.b	'$COPYRIGHT: '
AboutMessage	dc.b	'SmartCrash 1.3.0 Copyright © 1995-2000 Harry "Piru" Sintonen.',10
	dc.b	'All rights reserved. SmartCrash is freeware.',10,0
DosName	dc.b	'dos.library',0
GfxName	dc.b	'graphics.library',0
DiskFontName	dc.b	'diskfont.library',0
ReqToolsName	dc.b	'reqtools.library',0
Template	dc.b	'RT=USEREQTOOLS/S,RTFONTNAME,RTFONTSIZE/N',0
sInstalled	dc.b	'SmartCrash installed.',10,0
sTrapUsed	dc.b	'TaskTrapCode is used by some other (similar) program.',10,0
sCantInstall	dc.b	'Could not install SmartCrash.',10,0
sRemoved	dc.b	'SmartCrash removed.',10,0

	CNOP	0,4
COPY_START

;  IN: d0.l=stacksize
;      d1.b=priority (-128 to 127)
;      a0.l=taskname
;      a1.l=initPC
;      a3.l=optional parameter (put to stack)
; OUT: d0.l=address of the new task or NULL, ccr set
LaunchTask	movem.l	d1-d7/a0-a6,-(sp)
	moveq	#0,d7
	addq.l	#7,d0
	and.w	#-8,d0
	move.l	d0,d6
	move.l	a0,a5
	move.l	a1,a4
	move.l	(4).w,a6
	move.l	d6,-(sp)
	pea	MEMF_PUBLIC|MEMF_CLEAR	Entry #1 (stack)
	pea	(TC_SIZE).w
	pea	MEMF_PUBLIC|MEMF_CLEAR	Entry #0 (TCB)
	pea	(2).w			Number of entries (longword zeropadded)
	lea	(-(LN_SIZE-2),sp),sp	Reserve space for list node (-2 = padding...)
	move.l	sp,a0
	call	AllocEntry
	lea	((LN_SIZE-2)+(5*4),sp),sp
	tst.l	d0
	bmi.b	.exit
	move.l	d0,a0
	move.l	(ML_ME+0*ME_SIZE,a0),a1
	lea	(TC_MEMENTRY,a1),a2
	NEWLIST	a2
	movem.l	a0-a1/d0-d1,-(sp)
	move.l	a0,a1
	move.l	a2,a0
	call	AddHead
	movem.l	(sp)+,a0-a1/d0-d1
	move.l	(ML_ME+1*ME_SIZE,a0),a2
	move.l	a2,(TC_SPLOWER,a1)
	add.l	d6,a2
	move.l	a2,(TC_SPUPPER,a1)
	move.l	a3,-(a2)
	move.l	a2,(TC_SPREG,a1)
	move.b	#NT_TASK,(LN_TYPE,a1)
	move.b	(3,sp),(LN_PRI,a1)	d1 is topmost in stack...
	move.l	a5,(LN_NAME,a1)
	;move.b	#TF_ETASK,(TC_FLAGS,a1)
	move.l	a4,a2
	sub.l	a3,a3
	move.l	a1,d7
	call	AddTask			Can't fail, really.
	cmp.l	d0,d7
	beq.b	.exit

	; So, it DID fail after all. Damn it, now we need to
	; free everything ourself.
	move.l	d7,a0
	move.l	(TC_MEMENTRY,a0),a0
	call	FreeEntry
	moveq	#0,d7

.exit	move.l	d7,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts

;  IN: d0=stacksize
;      d1=priority (-128 to 127)
;      a0=procname (can be NULL)
;      a1=initPC
;      a3=optional parameter (Will be put to TC_Userdata)
; OUT: d0.l=address of the new process or NULL, ccr set
LaunchProc	movem.l	d1-d7/a0-a6,-(sp)
	move.l	sp,a4
	addq.l	#7,d0
	and.w	#-8,d0
	move.l	(DosBase,pc),a5
	move.l	(4).w,a6
	clr.l	-(sp)			TAG_END
	move.l	d0,-(sp)
	pea	NP_StackSize
	move.l	d1,-(sp)
	pea	NP_Priority
	move.l	a0,d0
	beq.b	.noname
	move.l	a0,-(sp)
	pea	NP_Name
.noname	move.l	a1,-(sp)
	pea	NP_Entry
	pea	(-1).w
	pea	NP_CopyVars
	move.l	sp,d1
	call	Forbid
	exg	a5,a6
	call	CreateNewProc
	tst.l	d0
	beq.b	.error
	move.l	d0,a0
	move.l	a3,(TC_Userdata,a0)
.error	exg	a5,a6
	call	Permit
	move.l	a4,sp
	tst.l	d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts


openlib	moveq	#37,d0
	call	OpenLibrary
	move.l	d0,-(sp)
	move.l	d0,a1
	call	CloseLibrary
	move.l	(sp)+,d0
	rts


TaskCode	lea	(DT,pc),a5
	move.l	(4).w,a6
	move.l	a6,(_ExecBase-DT,a5)
	sub.l	a1,a1
	call	FindTask
	move.l	d0,(_ThisTask-DT,a5)

	lea	(CrashData,pc),a0
	IFD	HACKSEMAPHORE
	clr.l	(a0)
	ELSE
	call	InitSemaphore
	ENDC

	moveq	#-1,d0
	call	AllocSignal
	move.l	d0,(sigb_EXITSUB-DT,a5)
	bmi	.nosig1
	moveq	#1,d1
	lsl.l	d0,d1
	move.l	d1,(sigf_EXITSUB-DT,a5)

	lea	(IntuiName,pc),a1
	bsr	openlib
	move.l	d0,(IntuiBase-DT,a5)

	call	CreateMsgPort
	move.l	d0,(MsgPort-DT,a5)
	beq	.noport
	move.l	d0,a1
	lea	(PortName,pc),a0
	move.l	a0,(LN_NAME,a1)
	move.b	#-126,(LN_PRI,a1)

	call	Forbid
	lea	(PortName,pc),a1	check for race condition
	call	FindPort		(if two smartcrashes were initializing
	tst.l	d0			at the same time)
	bne	.race_condition

	move.l	(MsgPort-DT,a5),a1
	call	AddPort
	; PatchControl installed?
	lea	(SetManPortName,pc),a1
	call	FindPort
	call	Permit
	move.l	d0,(HavePatchCtrl-DT,a5)

	moveq	#AllocPatch_SIZEOF,d0
	moveq	#MEMF_PUBLIC,d1
	call	AllocMem
	move.l	d0,(RecMem-DT,a5)
	beq	.no_recmem
	move.l	d0,a1
	moveq	#TrapEntry-AllocPatch,d1
	add.l	d0,d1
	move.l	d1,(TrapEntryPtr-DT,a5)
	move.l	a1,-(sp)
	lea	(AllocPatch,pc),a0
	moveq	#AllocPatch_SIZEOF,d0
	call	CopyMem
	move.l	(sp)+,a0
	lea	(AddTaskCode,pc),a1
	move.l	a1,(JMPADDROFFS,a0)

	; Special handler for 68000
	lea	(NewHandler000,pc),a1
	btst	#AFB_68010,(AttnFlags+1,a6)
	beq.b	.is_68000
	; Have 68010 or better so use simpler handler:
	lea	(NewHandler010,pc),a1
.is_68000	move.l	a1,(TrapProc-AllocPatch,a0)
	move.l	a1,(TrapTask-AllocPatch,a0)

	moveq	#_jmppos-AllocPatch,d0
	add.l	a0,d0
	move.w	#_LVOAddTask,a0
	move.l	a6,a1
	call	Forbid
	call	SetFunction
	move.l	d0,(_ATC_orig-DT,a5)

	; Change execbase TaskTrapCode
	move.l	(TrapEntryPtr,pc),(TaskTrapCode,a6)

	; Change ready/wait task's TrapCode
	move.l	(DefProcTrap,pc),a1	a1=proc trapcode
	move.l	(DefTaskTrap,pc),a2	a2=task trapcode
	move.l	(TrapEntryPtr,pc),d2	d2=our new trap entry (proc)
	move.l	d2,d3			d3=our new trap entry (task)
	move.l	(TaskReady,a6),a0
	bsr	.ChangeTrapCode
	move.l	(TaskWait,a6),a0
	bsr	.ChangeTrapCode

	call	CacheClearU
	call	Permit

	move.l	(sigf_INITOK,pc),d0	Notify about successful
	bsr	NotifySigTask		install.

	; SmartCrash.manager main:

.mainloop	move.l	(MsgPort,pc),a0
	call	WaitPort
.moremsg	move.l	(MsgPort,pc),a0
	call	GetMsg
	tst.l	d0
	beq.b	.mainloop

	move.l	d0,a0
	move.b	(MyMes_Type,a0),d0
	cmp.b	#MMTYPE_REMOVE,d0
	beq	.remove
	cmp.b	#MMTYPE_REPORT,d0
	bne.b	.moremsg

	; Launch new requester task (SubCode)

	move.l	(_ThisTask,pc),a3	Pass parent task
	move.l	#4096+10240,d0		Must have 2k for SegTrackerInfo
	moveq	#3,d1			Priority 3
	lea	(SubName,pc),a0
	lea	(SubCode,pc),a1
	addq.l	#1,(SubTaskCnt-DT,a5)
	bsr	LaunchTask
	bne.b	.moremsg		.taskok

	; If no task could be created,
	; fallback to an alert.
	;
	; This could be a bit bugged.

;;	call	Forbid

	lea	(CrashData,pc),a4
	lea	(-5*4,sp),sp		-1*4 for clr.b (4*4+1,a1)...

	move.l	sp,a1
	move.b	#'"',d2
	move.l	(CD_Task,a4),a0		Copy taskname:
	moveq	#16-1,d0
	move.l	(LN_NAME,a0),d1
	beq.b	.a_dopad
	move.l	d1,a0
.a_strcopy	move.b	(a0)+,(a1)+
	dbeq	d0,.a_strcopy
	tst.b	-(a1)			Pad name with spaces:
	bne.b	.a_notzero
.a_dopad	move.b	d2,(a1)+
.a_pad	move.b	#' ',(a1)+
	subq.w	#1,d0
	bpl.b	.a_pad
.a_notzero	move.b	d2,(a1)+		<- Doesn't matter!
	clr.b	(a1)

	move.l	sp,-(sp)
	move.l	(CD_Task,a4),-(sp)
	move.l	(CD_ProgramCounter,a4),-(sp)
	move.l	(CD_ExceptionNumber,a4),-(sp)
	bset	#7,(sp)
	lea	(Alert01Fmt,pc),a0
	move.l	sp,a1
	lea	(PutChar,pc),a2
	lea	(Alert01Buf,pc),a3
	call	RawDoFmt
	lea	(5*4+4*4,sp),sp

	move.l	a4,a0			Steal & release semaphore
	IFD	HACKSEMAPHORE
	clr.l	(a0)
	ELSE
	move.l	(_ThisTask,pc),(SS_OWNER,a0)	<- HACK
	call	ReleaseSemaphore
	ENDC
;;	call	Permit

	move.l	a6,-(sp)
	move.l	(IntuiBase,pc),a6
	moveq	#-66,d0			deadend
	lea	(Alert01,pc),a0
	moveq	#0,d1
	move.b	(Alert01_len,pc),d1
	cmp.w	#39,(LIB_VERSION,a6)
	blo.b	.old_alert
	move.w	#30*50,a1
	call	TimedDisplayAlert
	bra.b	.skip_old
.old_alert	call	DisplayAlert
.skip_old	move.l	(sp)+,a6
	subq.l	#1,(SubTaskCnt-DT,a5)
	bra	.moremsg

;  IN: a1=DefProcTrap
;      a2=DefTaskTrap
;      d2=proc TrapEntryPtr
;      d3=task TrapEntryPtr
.ChangeTrapCode
.ct_loop	move.l	(a0),d0
	beq.b	.ct_done
	move.l	(TC_TRAPCODE,a0),d1
	cmp.b	#NT_PROCESS,(LN_TYPE,a0)
	bne.b	.ct_task
	cmp.l	a1,d1
	beq.b	.ct_fix

.ct_tryold
	; It's a custom TC_TRAPCODE, so check for old
	; incarnation of ourself...

	move.l	d1,a3
	cmp.l	#SMARTCRASH13_ID,(-SC13IDPOS,a3)
	beq.b	.ct_fix
	bra.b	.ct_skip

.ct_task	cmp.l	a2,d1
	bne.b	.ct_tryold
.ct_fix	move.l	d3,d1			task TrapEntryPtr
	cmp.b	#NT_PROCESS,(LN_TYPE,a0)
	bne.b	.ct_do
	move.l	d2,d1			proc TrapEntryPtr
.ct_do	move.l	d1,(TC_TRAPCODE,a0)
.ct_skip
	move.l	d0,a0
	bra.b	.ct_loop
.ct_done	rts



	; SigTask asked us to quit...

.remove	move.l	(MyMes_SigTask,a0),(SigTask-DT,a5)
	move.l	(MyMes_InitOkSigMask,a0),(sigf_INITOK-DT,a5)
	move.l	(MyMes_RemovedSigMask,a0),(sigf_REMOVED-DT,a5)

	call	Forbid

	; Restore TC_TRAPCODE for every task possible:
	move.l	(TrapEntryPtr,pc),a1	a1=our new trap entry
	move.l	a1,a2
	move.l	(DefProcTrap,pc),d2	d2=proc trapcode
	move.l	(DefTaskTrap,pc),d3	d3=task trapcode
	move.l	(TaskReady,a6),a0
	bsr	.ChangeTrapCode
	move.l	(TaskWait,a6),a0
	bsr	.ChangeTrapCode

	; Restore original execbase TaskTrapCode
	move.l	(DefTaskTrap,pc),(TaskTrapCode,a6)

	; Modify TrapEntry such way it will redirect all
	; traps to original routine.
	move.l	(RecMem,pc),a3
	move.l	(_ATC_orig,pc),(JMPADDROFFS,a3)
	move.l	(DefTaskTrap,pc),(TrapTask-AllocPatch,a3)
	move.l	(DefProcTrap,pc),(TrapProc-AllocPatch,a3)

	; Remove AddTask patch if possible
	move.w	#_LVOAddTask,a0
	; If PatchControl is installed force remove
	tst.l	(HavePatchCtrl-DT,a5)
	bne.b	.force_remove
	move.l	2(a6,a0.l),a1
	subq.l	#_jmppos-AllocPatch,a1
	cmp.l	a3,a1
	bne.b	.cant_remove
.force_remove	move.l	(_ATC_orig,pc),d0
	move.l	a6,a1
	call	SetFunction
.cant_remove	call	CacheClearU
	call	Permit

.no_recmem
	lea	(CrashData,pc),a0
	IFD	HACKSEMAPHORE
.wait	tst.l	(a0)
	bne.b	.wait
	addq.l	#1,(a0)
	ELSE
	call	ObtainSemaphore
	ENDC

.try_exit	tst.l	(SubTaskCnt-DT,a5)	Wait all subtasks to quit.
	beq.b	.no_more_subtasks
	move.l	(sigf_EXITSUB,pc),d0
	call	Wait
	bra.b	.try_exit
.no_more_subtasks

.no_mem	move.l	(MsgPort,pc),a1
	call	Forbid
	call	RemPort
	call	Permit
.cleanloop	move.l	(MsgPort,pc),a0
	call	GetMsg
	tst.l	d0
	bne.b	.cleanloop

.delport	move.l	(MsgPort,pc),a0
	call	DeleteMsgPort

.noport	move.l	(sigb_EXITSUB,pc),d0
	call	FreeSignal

.nosig1	move.l	(_ExecBase,pc),a6
	move.l	(RTBase,pc),a1
	call	CloseLibrary

	move.l	a6,-(sp)
	move.l	(_GfxBase,pc),a6
	lea	(FontBase,pc),a0
	move.l	(a0),d0
	beq.b	.no_rtfont
	clr.l	(a0)
	move.l	d0,a1
	call	CloseFont
.no_rtfont	move.l	(sp)+,a6

	lea	(CrashData,pc),a0
	IFD	HACKSEMAPHORE
	clr.l	(a0)
	ELSE
	call	ReleaseSemaphore
	ENDC

	move.l	(sigf_REMOVED,pc),d0	Signal mask
	call	Forbid			Prevent race conditions
	bsr.b	NotifySigTask

	lea	(COPY_START,pc),a1	FreeVec self
	jmp	(_LVOFreeVec,a6)	& terminate


.race_condition	call	Permit
	bra	.delport


PutChar	move.b	d0,(a3)+
nm_rts	rts



NotifySigTask	lea	(SigTask,pc),a0
	move.l	(a0),a1
	clr.l	(a0)
	move.l	a1,d1
	beq.b	nm_rts
	jmp	(_LVOSignal,a6)


	; If can't get signal just suspend.
sc_nosignal	addq.l	#4,sp
sc_steal	move.l	a5,a0			Steal & release semaphore
	IFD	HACKSEMAPHORE
	clr.l	(a0)
	rts
	ELSE
	move.l	d6,(SS_OWNER,a0)	<- HACK
	jmp	(_LVOReleaseSemaphore,a6)
	ENDC

SubCode	move.l	(_ExecBase,pc),a6
	sub.l	a1,a1
	call	FindTask
	move.l	d0,d6

	; This thing prevents (possible) recursion if SubCode
	; itself should fail for some reason.
	move.l	d0,a0
	move.l	(DefTaskTrap,pc),(TC_TRAPCODE,a0)

	lea	(CrashData,pc),a5

	; Allocate SKIPPED signal that is used to signal
	; when it is ok to quit SubCode after Skip. This signal
	; is ONLY for the local use, ie. even it is stored to
	; global structure only Trap_UserPart may use it.

	moveq	#-1,d0
	call	AllocSignal
	move.l	d0,-(sp)
	bmi.b	sc_nosignal
	moveq	#1,d1
	lsl.l	d0,d1
	move.l	d1,(CD_sigf_SKIPPED,a5)

	move.l	sp,d7

	move.l	(CD_UserStackPtr,a5),d0
	btst	#13-8,(CD_StatusRegister,a5)
	beq.b	.is_user
	move.l	(CD_SuperStackPtr,a5),d0
.is_user	move.l	d0,(CD_StackPtr,a5)

	; force stack even before stackframe copy, prevent problems
	; with 68000 and allow SegTrackerInfo stack scan work.
	and.w	#$FFFE,d0
	move.l	d0,a0
	lea	(CD_StackFrame,a5),a1
	moveq	#16,d0
.copy	move.l	(a0)+,(a1)+
	subq.l	#1,d0
	bne.b	.copy

	lea	(CD_ExceptionNumber,a5),a0
	move.l	(a0)+,d0
	lea	(sKnown,pc),a1
	lea	(ExceptionTable,pc),a2
	move.l	d0,d1
	lea	(CD_TrapNumber,a5),a3
	add.l	d1,d1
	clr.b	(a3)
	move.w	(a2,d1.l),d1
	cmp.w	#$3A,d0
	bhi.b	.str_not_ok
	cmp.w	#$2F,d0
	bhi.b	.not_trapn
	cmp.w	#$1F,d0
	bls.b	.not_trapn
	add.w	#'0'-$20,d0
	cmp.w	#'9',d0
	bls.b	.hex_ok
	addq.w	#'@'-'9',d0
.hex_ok	move.b	d0,(a3)
.not_trapn
	add.w	d1,a2
	not.w	d1
	bne.b	.str_ok
.str_not_ok	addq.l	#NullStr-sKnown,a1
	move.l	a1,a2
.str_ok	move.l	a1,(a0)+		CD_ExceptionStr1
	move.l	a2,(a0)+		CD_ExceptionStr2

	move.l	(CD_Task,a5),a0
	moveq	#sTask-sTask,d0
	moveq	#0,d4			Default pubscreen for tasks!
	cmp.b	#NT_PROCESS,(LN_TYPE,a0)
	bne.b	.task
	move.l	(pr_WindowPtr,a0),d4
	move.l	#$80000001,d1		Some sanity check for window
	and.l	d4,d1
	beq.b	.winok
	moveq	#0,d4
.winok
	move.l	(pr_CLI,a0),d1
	beq.b	.process
	lsl.l	#2,d1
	move.l	d1,a1
	move.l	(cli_CommandName,a1),-(sp)
	move.l	(pr_TaskNum,a0),-(sp)
	lea	(CLIFmt,pc),a0
	move.l	sp,a1
	lea	(-64,sp),sp
	lea	(PutChar,pc),a2
	move.l	sp,a3
	call	RawDoFmt
	move.l	sp,a1
	moveq	#sCommand-sTask,d0
	bra.b	.done

.process	moveq	#sProcess-sTask,d0
.task	move.l	(LN_NAME,a0),a1
.done
	lea	(sTask,pc),a0
	add.l	d0,a0
	lea	(CD_TaskType,a5),a4
	move.l	a0,(a4)+		CD_TaskType
	move.l	a1,(a4)+		CD_TaskName

	; SegTracker info to stack:
	; stack usage varies, but theoritical maximum usage would be:
	; 41 * ( 43 + 28 ) = 2911 bytes
	; ALL possible 41 SegTracker hits,
	; 43 bytes of constant string + max. 26 byte segment name,
	; but in real life this can newer happen, so 2k is enough.
	lea	(-2048,sp),sp
	move.l	sp,(a4)			CD_SegTrackerInfo
	move.l	sp,a3
	bsr	SegTrackerInfo

	; GadgetFmt argarray to stack

	lea	(UnderlStr,pc),a0
	move.l	(RTBase,pc),d0
	bne.b	.is_rt
	addq.l	#1,a0
.is_rt	moveq	#NUMSCGADGETS,d0
.do_under	move.l	a0,-(sp)
	subq.l	#1,d0
	bne.b	.do_under

	; BodyFmt argarray to stack

	lea	(CD_CD_END,a5),a0	Copy semaphore data to *local*
	moveq	#(CD_CD_END-CD_CD)/4,d0	stack area. After this we can
.copy_cd	move.l	-(a0),-(sp)		release the semaphore.
	subq.l	#1,d0
	bne.b	.copy_cd

	bsr	sc_steal		Steal & release semaphore

	;lea	(CD_TrapNumber-CD_CD,sp),a0
	;move.l	a0,(CD_ExceptionStr3-CD_CD,sp)
	move.l	sp,(CD_ExceptionStr3-CD_CD,sp)		'Trap #<n>' string ptr
	lea	(CD_ExceptionNumber-CD_CD,sp),a3	AgrList for requester

	move.l	(RTBase,pc),d0
	bne.b	.use_rtreq

	pea	(GadgetFmt,pc)
	pea	(BodyFmt,pc)
	pea	(WindowTitle,pc)
	clr.l	-(sp)
	pea	(EasyStruct_SIZEOF).w

.redo_easyreq	move.l	d4,a0			Window ptr
	move.l	sp,a1			easyStruct
	sub.l	a2,a2			IDCMP_ptr (may be null)
;		a3			ArgList
	move.l	(IntuiBase,pc),a6
	call	EasyRequestArgs
	bra.b	.handle_result

.use_rtreq	clr.l	-(sp)			TAG_END
	move.l	d4,-(sp)
	pea	RT_Window
	pea	(REQPOS_POINTER).w
	pea	RT_ReqPos
	pea	('_').w
	pea	RT_Underscore
	pea	(WindowTitle,pc)
	pea	RTEZ_ReqTitle
	;pea	(EZREQF_NORETURNKEY|EZREQF_LAMIGAQUAL).w
	pea	(EZREQF_LAMIGAQUAL).w
	pea	RTEZ_Flags
	move.l	(FontBase,pc),d0
	beq.b	.nofont
	pea	(TAttr,pc)
	pea	RT_TextAttr
.nofont
.redo_rtreq	lea	(BodyFmt,pc),a1
	lea	(GadgetFmt,pc),a2
	move.l	a3,a4
	sub.l	a3,a3
	move.l	sp,a0
	move.l	(RTBase,pc),a6
	call	rtEZRequestA
	move.l	a4,a3

.handle_result
	move.l	(_ExecBase,pc),a6
	move.l	(CD_Task-CD_ExceptionNumber,a3),a4	a4=crashed_task
	move.l	d6,(CD_Task-CD_ExceptionNumber,a3)	sigtask (SubCode) to CD_Task

;;	bra	Debug_Reset		If unknown gadget

	add.l	d0,d0
	move.w	.tab(pc,d0.l),d0
	jmp	.tab(pc,d0.w)

.tab	dc.w	.exit_suspend-.tab	0 GADG_SUSPEND
	dc.w	.exit_skip-.tab		1 GADG_SKIP
	dc.w	.exit_remove-.tab	2 GADG_REMOVE
	dc.w	.exit_exit-.tab		3 GADG_EXIT
	dc.w	.exit_debug-.tab	4 GADG_DEBUG
	dc.w	.exit_reboot-.tab	5 GADG_REBOOT
	dc.w	.exit_jmp-.tab		6 GADG_JMP
	dc.w	.exit_rts-.tab		7 GADG_RTS

.exit_debug	moveq	#0,d0
	call	Debug
.redo_req	move.l	a4,(CD_Task-CD_ExceptionNumber,a3)	Restore the orig. CD_Task
	move.l	(RTBase,pc),d0
	beq	.redo_easyreq
	bra.b	.redo_rtreq

.exit_reboot	move.l	(_GfxBase,pc),a6
	sub.l	a1,a1
	call	LoadView
	call	WaitTOF
	call	WaitTOF
	move.l	(_ExecBase,pc),a6
	jmp	(_LVOColdReboot,a6)

.exit_skip	; Wake task to skip failed instruction
	move.w	#ACTION_SKIP,(CD_Action-CD_ExceptionNumber,a3)
.skipkind	move.l	(TC_TRAPDATA,a4),(CD_PrevTRAPDATA-CD_ExceptionNumber,a3)
	move.l	a3,(TC_TRAPDATA,a4)	Pass stack version of CD,
	moveq	#1<<WAKE_SIGNAL,d0	TC_TRAPDATA = ptr to CD_ExceptionNumber
	or.l	d0,(TC_SIGWAIT,a4)
	move.l	a4,a1
	IFD	FIXED_SKIPPED_SIGNAL
	call	Signal
	move.l	#1<<FIXED_SKIPPED_SIGNAL,d0	Wait until task has skipped
	call	Wait
	ELSE
	; *MUST* get it before Signal call!
	move.l	(CD_sigf_SKIPPED-CD_ExceptionNumber,a3),-(sp)
	call	Signal			must not use a3 anymore!
	move.l	(sp)+,d0
	call	Wait
	ENDC
	bra	.exit


.exit_rts	; jump to rts
	lea	(.rts,pc),a0
	move.l	a0,(CD_ProgramCounter-CD_ExceptionNumber,a3)
.actjmp	move.w	#ACTION_JMP,(CD_Action-CD_ExceptionNumber,a3)
	bra.b	.skipkind


.exit_jmp	; Put up number requester to query new program counter.
	; Put result to CD_ProgramCounter.

	IFGT	0
	move.l	(RTBase,pc),d0
	beq.b	.no_rt
	move.l	d0,a6
	move.l	sp,d5
	clr.l	-(sp)
	move.l	d4,-(sp)
	pea	RT_Window
	pea	(REQPOS_POINTER).w
	pea	RT_ReqPos
	move.l	(FontBase,pc),d0
	beq.b	.nofont2
	pea	(TAttr,pc)
	pea	RT_TextAttr
.nofont2	move.l	sp,a0
;;	lea	(CD_ProgramCounter-CD_ExceptionNumber,a3),a1
	lea	(.title,pc),a2
	sub.l	a3,a3
;	call	rtGetStringA
	moveq	#0,d0
	move.l	d5,sp
.no_rt
	ENDC

	lea	(CD_ProgramCounter-CD_ExceptionNumber,a3),a0
	lea	(.title,pc),a1
	moveq	#RLF_ALLOWHEX|RLF_INITHEX|RLF_UNSIGNED|RLF_SHOWDEF|RLF_FOLLOWMOUSE|RLF_ESCISRETURN,d0
	bsr	RequestLong
	tst.l	d0
	beq	.redo_req		User cancelled, redo the requester
	; User entered something so jump in!
	bra.b	.actjmp

.title	dc.b	'Jump to...',0
	CNOP	0,2


.exit_exit	cmp.b	#NT_PROCESS,(LN_TYPE,a4)
	bne.b	.exit_task

	; Wake task for return with orig. stack:
	move.w	#ACTION_EXIT,(CD_Action-CD_ExceptionNumber,a3)
	move.l	(TC_TRAPDATA,a4),(CD_PrevTRAPDATA-CD_ExceptionNumber,a3)
	move.l	a3,(TC_TRAPDATA,a4)	Pass stack version of CD,
	moveq	#1<<WAKE_SIGNAL,d0	TC_TRAPDATA = ptr to CD_ExceptionNumber
	or.l	d0,(TC_SIGWAIT,a4)
	move.l	a4,a1
	call	Signal
	bra.b	.exit


.exit_remove	bsr.b	.closewindows
	;call	Forbid
	cmp.b	#NT_PROCESS,(LN_TYPE,a4)
	bne.b	.exit_task
	or.w	#PRF_FREESEGLIST|PRF_FREECURRDIR|PRF_CLOSEINPUT|PRF_CLOSEOUTPUT|PRF_FREEARGS,(pr_Flags+2,a4)
	move.l	(pr_CLI,a4),d0
	beq.b	.not_cli

	; !!
	; should remove this CLI from dos cli list!

	clr.l	(pr_CLI,a4)
	and.w	#~(PRF_FREESEGLIST|PRF_FREECLI),(pr_Flags+2,a4)
	lsl.l	#2,d0
	move.l	d0,a3			Specialdata=CLI sturucture
	move.l	#4096,d0		Stack=4K
	moveq	#10,d1			Priority=10
	sub.l	a0,a0			No special name
	lea	(_DoSomeDos,pc),a1
	bsr	LaunchProc
.not_cli
.exit_task	move.l	(_ExecBase,pc),a6
;;;	clr.l	(TC_ExitCode,a4)
	move.l	a4,a1
	call	RemTask			Fall thru to .exit!


.exit_suspend
.exit	move.l	(_ExecBase,pc),a6
	move.l	d7,sp
	move.l	(sp)+,d0
	call	FreeSignal
	lea	(SubTaskCnt,pc),a0
	move.l	(4,sp),a1		a1=sigtask (parent task)
	move.l	(sigf_EXITSUB,pc),d0	d0=sigmask
	call	Forbid			Forbid task scheduling
	subq.l	#1,(a0)
	jmp	(_LVOSignal,a6)		Signal & terminate



;  IN: a4=task (or a process)
.closewindows	movem.l	d7/a2-a3/a5-a6,-(sp)
	move.l	(IntuiBase,pc),a6

	clr.l	-(sp)			array terminator

	moveq	#0,d0
	call	LockIBase
	move.l	d0,d7

	move.l	(ib_FirstScreen,a6),a5
.cw_sloop
	move.l	(sc_FirstWindow,a5),a3
.cw_wloop
	move.l	(wd_UserPort,a3),a0
	cmp.l	(MP_SIGTASK,a0),a4
	bne.b	.cw_nomatch

	move.l	a3,-(sp)		add window to array of windows to close
.cw_nomatch
	move.l	(a3),d0
	move.l	d0,a3
	bne.b	.cw_wloop

	move.l	(a5),d0
	move.l	d0,a5
	bne.b	.cw_sloop

	move.l	d7,a0
	call	UnlockIBase

	move.l	sp,a5
.cw_closew	move.l	(a5),d0
	beq.b	.cw_cwdone
	move.l	d0,a3

	move.l	(wd_WScreen,a3),a2

	tst.l	(wd_MenuStrip,a3)
	beq.b	.cw_nomenu
	move.l	a3,a0
	call	ClearMenuStrip
.cw_nomenu	move.l	a3,a0
	call	CloseWindow

	moveq	#-1,d1
	tst.l	(sc_FirstWindow,a2)
	bne.b	.cw_kille
	move.w	(sc_Flags,a2),d0
	and.w	#SCREENTYPE,d0
	cmp.w	#CUSTOMSCREEN,d0
	bne.b	.cw_kille
	move.l	a2,d1
.cw_kille	move.l	d1,(a5)+
	bra.b	.cw_closew
.cw_cwdone

.cw_closes	move.l	(sp)+,d0
	beq.b	.cw_csdone
	bmi.b	.cw_closes
	move.l	d0,a0
	call	CloseScreen
	bra.b	.cw_closes
.cw_csdone
	movem.l	(sp)+,d7/a2-a3/a5-a6
.rts	rts


_DoSomeDos	move.l	(DosBase,pc),a5
	move.l	(_ExecBase,pc),a6
	sub.l	a1,a1
	call	FindTask
	move.l	d0,a0
	move.l	(TC_Userdata,a0),a2	a2=CLI structure
	exg	a5,a6

	move.l	(cli_Module,a2),d1
	call	UnLoadSeg		SegList may be zero.

	move.l	(cli_StandardInput,a2),d2
	move.l	(cli_CurrentInput,a2),d1
	clr.l	(cli_StandardInput,a2)
	clr.l	(cli_CurrentInput,a2)
	cmp.l	d1,d2
	beq.b	.samei
	call	Close
.samei	move.l	d2,d1
	call	Close
	move.l	(cli_StandardOutput,a2),d2
	move.l	(cli_CurrentOutput,a2),d1
	clr.l	(cli_StandardOutput,a2)
	clr.l	(cli_CurrentOutput,a2)
	cmp.l	d1,d2
	beq.b	.sameo
	call	Close
.sameo	move.l	d2,d1
	call	Close

	cmp.w	#39,(LIB_VERSION,a6)
	bhs.b	.no_workaround
	exg	a5,a6
	lea	(cli_SetName,a2),a0
	bsr.b	.freeBSTR
	lea	(cli_CommandName,a2),a0
	bsr.b	.freeBSTR
	lea	(cli_Prompt,a2),a0
	bsr.b	.freeBSTR
	lea	(cli_CommandFile,a2),a0
	bsr.b	.freeBSTR
	exg	a5,a6
.no_workaround
	moveq	#DOS_CLI,d1
	move.l	a2,d2
	lsr.l	#2,d2
	jmp	(_LVOFreeDosObject,a6)

.freeBSTR	move.l	(a0),a1
	add.l	a1,a1
	clr.l	(a0)
	add.l	a1,a1
	jmp	(_LVOFreeVec,a6)


;  IN: a3=ptr to buffer
;      a6=execbase
SegTrackerInfo	movem.l	d0-a6,-(sp)
	clr.b	(a3)+
	lea	(SegTrackerName,pc),a1
	call	FindSemaphore
	tst.l	d0
	beq	.done2
.foundit	move.l	d0,a0
	move.l	(SS_SIZE,a0),d6		Get SegTracker 'find' routine
	lea	(.STTable,pc),a4
	lea	(-5*4,sp),sp
	moveq	#16,d5
	bra.b	.do_more
.do_more2	call	Permit
.do_more	move.l	a4,(sp)
	addq.l	#4,a4
	move.w	(a4)+,d0
	bmi.b	.done
	move.l	(a5,d0.w),a0
	move.l	a0,(4,sp)
	lea	(12,sp),a1
	lea	(16,sp),a2
	call	Forbid
	exg	d6,a6
	jsr	(a6)
	exg	d6,a6
	move.l	d0,(8,sp)
	beq.b	.do_more2

	subq.l	#1,a3
	lea	(.STFmt,pc),a0
	move.l	sp,a1
	lea	(PutChar,pc),a2
	call	RawDoFmt

.goforit	tst.b	(a3)+
	bne.b	.goforit
	call	Permit
	subq.l	#1,d5
	bne.b	.do_more

.done	lea	(5*4,sp),sp
.done2	movem.l	(sp)+,d0-a6
	rts

	;	 0  000000001111111111222222222233333333334444
	;	 1  234567890123456789012345678901234567890123
	;	10,'xxxx=xxxxxxxx points to '', hunk xx:xxxxxx',0
.STFmt	dc.b	10,'%-.4s=%08lx points to ''%-.28s'', hunk %02lx:%06lx',0
	CNOP	0,2

STENTRY	MACRO
	dc.l	\1
	dc.w	\2
	ENDM

.STTable	STENTRY	<'  PC'>,CD_ProgramCounter
	STENTRY	<'  A0'>,CD_AddrReg_0
	STENTRY	<'  A1'>,CD_AddrRegs_1_6
	STENTRY	<'  A2'>,CD_AddrRegs_1_6+4
	STENTRY	<'  A3'>,CD_AddrRegs_1_6+8
	STENTRY	<'  A4'>,CD_AddrRegs_1_6+12
	STENTRY	<'  A5'>,CD_AddrRegs_1_6+16
	STENTRY	<'  A6'>,CD_AddrRegs_1_6+20
	STENTRY	<'  SP'>,CD_StackPtr
	STENTRY	<'S:00'>,CD_StackFrame+0
	STENTRY	<'S:02'>,CD_StackFrame+0+2
	STENTRY	<'S:04'>,CD_StackFrame+4
	STENTRY	<'S:06'>,CD_StackFrame+4+2
	STENTRY	<'S:08'>,CD_StackFrame+8
	STENTRY	<'S:0A'>,CD_StackFrame+8+2
	STENTRY	<'S:0C'>,CD_StackFrame+12
	STENTRY	<'S:0E'>,CD_StackFrame+12+2
	STENTRY	<'S:10'>,CD_StackFrame+16
	STENTRY	<'S:12'>,CD_StackFrame+16+2
	STENTRY	<'S:14'>,CD_StackFrame+20
	STENTRY	<'S:16'>,CD_StackFrame+20+2
	STENTRY	<'S:18'>,CD_StackFrame+24
	STENTRY	<'S:1A'>,CD_StackFrame+24+2
	STENTRY	<'S:1C'>,CD_StackFrame+28
	STENTRY	<'S:1E'>,CD_StackFrame+28+2
	STENTRY	<'S:20'>,CD_StackFrame+32
	STENTRY	<'S:22'>,CD_StackFrame+32+2
	STENTRY	<'S:24'>,CD_StackFrame+36
	STENTRY	<'S:26'>,CD_StackFrame+36+2
	STENTRY	<'S:28'>,CD_StackFrame+40
	STENTRY	<'S:2A'>,CD_StackFrame+40+2
	STENTRY	<'S:2C'>,CD_StackFrame+44
	STENTRY	<'S:2E'>,CD_StackFrame+44+2
	STENTRY	<'S:30'>,CD_StackFrame+48
	STENTRY	<'S:32'>,CD_StackFrame+48+2
	STENTRY	<'S:34'>,CD_StackFrame+52
	STENTRY	<'S:36'>,CD_StackFrame+52+2
	STENTRY	<'S:38'>,CD_StackFrame+56
	STENTRY	<'S:3A'>,CD_StackFrame+56+2
	STENTRY	<'S:3C'>,CD_StackFrame+60
	STENTRY	0,-1


; This is the new patch method, it uses execbase TaskTrapCode for
; NT_TASK and simple compare before adding task for NT_PROCESS.
; Simple and clean, no need for Forbid()/Permit() for example.

	CNOP	0,4
AddTaskCode	cmp.b	#NT_PROCESS,(LN_TYPE,a1)
	bne.b	.addtask
	move.l	(TC_TRAPCODE,a1),d0
	beq.b	.change
	cmp.l	(DefProcTrap,pc),d0
	bne.b	.addtask
.change	move.l	(TrapEntryPtr,pc),(TC_TRAPCODE,a1)
.addtask	jmp	'addt'
_ATC_orig	EQU	*-4



; Exception handler for 68000:
; Stack when TC_TRAPCODE is entered for bus error/address error:
;	LONG	Exception number
;	WORD	Status, 0..2 function code, 3 inst/not inst, 4 read/write
;	LONG	Access address
;	WORD	Status register
;	LONG	Program counter

; Stack when TC_TRAPCODE is entered for other errors:
;	LONG	Exception number
;	WORD	Status register
;	LONG	Program counter

	CNOP	0,4
NUM_SAVE_REGS	EQU	2
NewHandler000	movem.l	d0/a0,-(sp)
	move.l	usp,a0		store to user stack
	move.l	a0,d0
	and.w	#$fffe,d0	force stack even
	exg	d0,a0
	move.l	d0,-(a0)	save old user stack pointer
	move.l	sp,-(a0)	save supervisor stack pointer
	addq.l	#NUM_SAVE_REGS*4,(a0)		fix ssp

	move.l	(NUM_SAVE_REGS*4,sp),d0		exception number
	cmp.w	#2,d0
	beq.b	.isbuserror
	cmp.w	#3,d0
	bne.b	.not_addrerror
.isbuserror
	move.l	(8+NUM_SAVE_REGS*4+8,sp),-(a0)	pclower <<16 | xxxx
	move.l	(8+NUM_SAVE_REGS*4+4,sp),-(a0)	sr <<16 | pcupper
	move.l	d0,-(a0)			exception number
	move.l	a0,usp
	lea	(Trap_UserPart,pc),a0
	move.l	a0,(8+NUM_SAVE_REGS*4+4+2,sp)	change PC
	bra.b	_exithandler2
.not_addrerror
	move.l	(NUM_SAVE_REGS*4+8,sp),-(a0)	pclower <<16 | xxxx
	move.l	(NUM_SAVE_REGS*4+4,sp),-(a0)	sr <<16 | pcupper
	move.l	d0,-(a0)			exception number
	bra.b	_exithandler1


; Exception handler for 68010 and better:
; Stack when TC_TRAPCODE is entered:
;	LONG	Exception number
;	WORD	Status register
;	LONG	Program counter
;	WORD	Frametype & Vector-address (random data for 68000)
;	...	Additional processor state information

	CNOP	0,4
;NUM_SAVE_REGS	EQU	2		MUST BE SAME AS WITH NewHandler000
NewHandler010	movem.l	d0/a0,-(sp)
	move.l	usp,a0		store to user stack
	move.l	a0,d0
	and.w	#$fffc,d0	force stack longword aligned
	exg	d0,a0
	move.l	d0,-(a0)	save old user stack pointer
	move.l	sp,-(a0)	save supervisor stack pointer
	addq.l	#NUM_SAVE_REGS*4,(a0)		fix ssp
	move.l	(NUM_SAVE_REGS*4+8,sp),-(a0)	pclower <<16 | ftype_vecaddr
	move.l	(NUM_SAVE_REGS*4+4,sp),-(a0)	sr <<16 | pcupper
	move.l	(NUM_SAVE_REGS*4,sp),-(a0)	exception number
_exithandler1	move.l	a0,usp
	lea	(Trap_UserPart,pc),a0
	move.l	a0,(NUM_SAVE_REGS*4+4+2,sp)	change PC
_exithandler2	movem.l	(sp)+,d0/a0
	addq.l	#4,sp				skip exception number
	rte					go to userpart

; Stack:	LONG	Exception number
;	WORD	Status register
;	LONG	Program counter
;	WORD	Frametype & Vector-address
;	LONG	Supervisor stack pointer
;	LONG	Old User stack pointer
;	[WORD	if usp wasn't longword aligned, 68010+]
;	[BYTE   if usp wasn't even]
;	... old stack ...

	CNOP	0,4
Trap_UserPart	move.l	a0,-(sp)
	IFD	HACKSEMAPHORE
	lea	(CrashData,pc),a0
.wait	tst.l	(a0)
	bne.b	.wait
	addq.l	#1,(a0)
	ELSE
	move.l	a6,-(sp)	 		save a6
	move.l	(_ExecBase,pc),a6
	lea	(CrashData,pc),a0
	call	ObtainSemaphore			preserves d0-d1/a1
	move.l	(sp)+,a6
	ENDC
	movem.l	d0-d7,(CD_DataRegs,a0)		store all data regs
	movem.l	a1-a6,(CD_AddrRegs_1_6,a0)	store a1-a6
	move.l	(sp)+,(CD_AddrReg_0,a0)		store a0
	move.l	(sp)+,(CD_ExceptionNumber,a0)
	move.w	(sp),(CD_StatusRegister,a0)	store sr
	move.l	(2,sp),(CD_ProgramCounter,a0)	store pc
	addq.l	#8,sp
	move.l	(sp)+,(CD_SuperStackPtr,a0)
	move.l	(sp)+,(CD_UserStackPtr,a0)

	move.l	(_ExecBase,pc),a6
	sub.l	a1,a1
	move.l	a0,-(sp)
	call	FindTask
	move.l	(sp)+,a0
	move.l	d0,(CD_Task,a0)
	move.l	d0,a5

	; Ask SmartCrash.manager to launch SubCode for us
	pea	MN_SIZE			MN_REPLYPORT:16, MN_LENGTH
	clr.l	-(sp)			LN_NAME:16, MN_REPLYPORT:16
	pea	MMTYPE_REPORT<<8	LN_TYPE, LN_PRI, LN_NAME:16
	clr.l	-(sp)			LN_PRED
	clr.l	-(sp)			LN_SUCC
	move.l	sp,a1
	move.l	(MsgPort,pc),a0
	call	PutMsg

	; Go to deep sleep, from which we possibly wake up with WAKE_SIGNAL
	moveq	#0,d0
	call	Wait
	lea	(MN_SIZE,sp),sp

	; Here TC_TRAPDATA is used to pass arguments (CD_CD).
	; Passed stack CD CD_Task points to sigtask to send
	; CD_sigf_SKIPPED signal when skip is done.

	IFD	FINDTASKBUG
	move.l	(CrashData+CD_Task,pc),a5
	ENDC
	move.l	(TC_TRAPDATA,a5),a0
	move.l	(CD_PrevTRAPDATA-CD_ExceptionNumber,a0),(TC_TRAPDATA,a5)

	move.w	(CD_Action-CD_ExceptionNumber,a0),d0
	;add.w	d0,d0
	move.w	.tab(pc,d0.w),d0
	jmp	.tab(pc,d0.w)
.tab	dc.w	.action_skip-.tab	0 ACTION_SKIP
	dc.w	.action_exit-.tab	2 ACTION_EXIT
	dc.w	.action_jmp-.tab	4 ACTION_JMP

.action_skip	; Skip faulty instruction:

	move.l	(CD_ProgramCounter-CD_ExceptionNumber,a0),a1
	move.l	(CD_ExceptionNumber-CD_ExceptionNumber,a0),d0
	moveq	#0,d1
	cmp.w	#4,d0			illegal instruction (advance PC with 2)
	seq	d1
	add.w	d1,d1
	cmp.w	#$A,d0			line-a emulator	(advance PC with 2)
	seq	d1
	add.w	d1,d1
	cmp.w	#$B,d0			line-f emulator (adcanve PC with 2/4/6)
	seq	d1
	bne.b	.not_fline		Test mmu-instructions

	move.w	(a1),d3			read instruction word
	move.w	d3,d2
	cmp.w	#%1111000001111100,d2	PTRAPcc (68851)
	beq.b	.add2
	cmp.w	#%1111000001111010,d2	PTRAPcc.W #<data> (68851)
	beq.b	.add4
	cmp.w	#%1111000001111011,d2	PTRAPcc.L #<data> (68851)
	beq.b	.add6
	and.w	#%1111111111000000,d2
	cmp.w	#%1111000010000000,d2	PBcc.w <disp> (68851)
	beq.b	.add2
	cmp.w	#%1111000011000000,d2	PBcc.L <disp> (68851)
	beq.b	.add4
	cmp.w	#%1111000000000000,d2	PMOVE/PLOAD/PVALID/PFLUSH*/PTEST
	beq.b	.add2
	cmp.w	#%1111100000000000,d2	TBLU*/TBLS*/LPSTOP? (CPU32)
	bne.b	.not_cpu32
	cmp.w	#%0000000111000000,(2,a1) LPSTOP #<data> (CPU32, 68060)
	beq.b	.add4
	bra.b	.add2
.not_cpu32
	move.w	d3,d2
	and.w	#%1111111111111000,d2
	cmp.w	#%1111000001001000,d2	PDBcc Dn,<disp> (68851)
	beq.b	.add4
	cmp.w	#%1111011000100000,d2	MOVE16 (an)+,(an)+ (68040+)
	beq.b	.add2
	and.w	#%1111111111000000,d2
	cmp.w	#%1111000001000000,d2	PScc (68851)
	beq.b	.add2
	move.w	d3,d2
	and.w	#%1111111111100000,d2
	cmp.w	#%1111011000000000,d2	MOVE16 absolute long address src or dst (68040+)
	beq.b	.add4
	bra.b	.not_fline

.add6	addq.l	#2,a1			advance PC with total 8
.add4	addq.l	#2,a1			advance PC with total 6
.add2	addq.l	#2,a1			advance PC with total 4

.not_fline	tst.w	d1			illegal inst/a-line/f-line ?
	beq.b	.no_add
	addq.l	#2,a1			advance PC with 2
.no_add	cmp.w	#8,d0			privilege violation
	bne.b	.no_privilege
	cmp.l	#%11111000000000000000000111000000,(a1) LPSTOP #<data> (CPU32, 68060)
	beq.b	.lpstop
	move.w	(a1)+,d3		read instruction word, advance PC with 2
	lea	(.privtable,pc),a2
.poloop	move.w	(a2)+,d2
	beq.b	.pdone
.piloop	move.w	(a2)+,d1
	beq.b	.poloop
	and.w	d3,d1
	cmp.w	(a2)+,d1
	bne.b	.piloop
	add.w	d2,a1			advance PC (BUG: was add.l)
	;;bra.b	.piloop
.pdone
	bra.b	.no_privilege

.lpstop	addq.l	#4,a1			advance PC with total 6 bytes
.no_privilege


;  IN: a1=PC to jump to
.gotopc	lea	(.SuperCode,pc),a5
	call	Supervisor
.SuperCode	;move.w	#$2700,sr

	; write SR
	move.w	(CD_StatusRegister-CD_ExceptionNumber,a0),(sp)
	; write PC
	move.l	a1,(2,sp)
	; write USP
	move.l	(CD_UserStackPtr-CD_ExceptionNumber,a0),a1
	move.l	a1,usp
	; write D0-D7
	movem.l	(CD_DataRegs-CD_ExceptionNumber,a0),d0-d7
	; write A1-A6
	movem.l	(CD_AddrRegs_1_6-CD_ExceptionNumber,a0),a1-a6
	move.l	(CD_AddrReg_0-CD_ExceptionNumber,a0),-(sp)
	movem.l	d0-d1/a1/a6,-(sp)
	move.l	(_ExecBase,pc),a6
	; Get sigtask
	move.l	(CD_Task-CD_ExceptionNumber,a0),a1
	IFD	FIXED_SKIPPED_SIGNAL
	move.l	#1<<FIXED_SKIPPED_SIGNAL,d0
	ELSE
	; Get sigmask
	move.l	(CD_sigf_SKIPPED-CD_ExceptionNumber,a0),d0
	ENDC
	; Must not use CD pointed by a0 after Signal call!
	call	Signal
	movem.l	(sp)+,d0-d1/a1/a6
	; write A0
	move.l	(sp)+,a0
	rte


.action_jmp	; jump to address (address in CD_ProgramCounter)
	move.l	(CD_ProgramCounter-CD_ExceptionNumber,a0),a1
	bra	.gotopc


.action_exit	; Exit program with RC 0 (only NT_PROCESS will get here):
	move.l	(pr_ReturnAddr,a5),d0
	subq.l	#4,d0
	move.l	d0,sp
	moveq	#RETURN_OK,d0		;-O
	rts

;		 1111111111111111  0000000000000000
;		 fedcba9876543210  fedcba9876543210	instruction
.privtable	dc.w	2	; 2 word instructions
	dc.w	%1111111111111111,%0000001001111100	ANDI #<data>,sr
	dc.w	%1111111111111111,%0000101001111100	EORI #<data>,sr
	dc.w	%1111111111111111,%0000000001111100	ORI  #<data>,sr
	dc.w	%1111111111111110,%0100111001111010	MOVEC xx,xx
	dc.w	%1111111111111111,%0100111001110010	STOP #xx
	dc.w	%1111111111000000,%1111000000000000	mmu-instr (PMOVE/PLOAD/PVALID/PFLUSH*/PTEST)
	dc.w	%1111111111000000,%1111000010000000	PBcc.w <disp> (68851)
	dc.w	%1111111100000000,%0000111000000000	MOVES xx,xx
	dc.w	0

	dc.w	4	; 3 word instructions
	dc.w	%1111111111111111,%1111000001111010	PTRAPcc.W #<data> (68851)
	dc.w	%1111111111111000,%1111000001001000	PDBcc Dn,<disp> (68851)
	dc.w	%1111111111000000,%1111000011000000	PBcc.L <disp> (68851)
	dc.w	%1111111111000000,%1111000001000000	PScc (68851)
	; LPSTOP (CPU32,68060)  handled with special test
	dc.w	0

	dc.w	6	; 4 word instructions
	dc.w	%1111111111111111,%1111000001111011	PTRAPcc.L #<data> (68851)
	dc.w	0

	dc.w	0	; end mark



	IFD	INSTSIZE

;  IN: d0.l=ULONG opcode1 <<16 | opcode2
; OUT: d0.l=ULONG instruction size in bytes
InstSize	movem.l	d1-a6,-(sp)
	move.l	d0,d6

	;int-inst		word1	encoding
	;add/sub/and/or		8,7,6	000=byte 001=word 010=long
	;adda/suba		8,7,6	011=word 111=long
	;btst			8	1=bit number dynamic=byte
	;chk			8,7	11=word 10=long
	;cmp(a)			8,7,6	000=byte 001=word 010=long 011=word 111=long
	;div*.w/mul*.w		-	word
	;div*.l/mul*.l		-	long
	;move SRC!		13,12	01=byte 11=word 10=long
	;movea			13,12	11=word 10=long
	;move to ccr		-	word
	;tst			7,6	00=byte 01=word 10=long

	;move to sr		-	word
	;pflushr		-	word
	;pmove #x,reg	w2: 13,12,11,10	0000=long 0001=quad 0010=quad 0011=quad
	;				0100=byte 0101=byte 0110=byte 0111=word
	;pmove.w #x,psr		-	word

	;fpu-inst	word1	word2		encoding
	;			14,13,12,11,10	10000=long 10001=single-precision
	;					10010=extended-precision
	;					10011=packed decimal real 10100=word
	;					10101=double-precision 10110=byte
	; fmove.l #<xxx>,fpcr			long
	; fmovem.l #<xxx>,<fpcrs>		long
	;
	; exluding:
	; FBcc
	; FDBcc
	; fmove.l fpcr,<ea>
	; fmovem.l <fpcsr>,<ea>
	; fmove.<fmt> fpm,<ea>
	; fmovem.x (fpdr)
	; fnop
	; FScc
	; FTRAPcc

	move.l	d6,d0
	move.w	d0,d1			d1=opcode2
	swap	d0			d0=opcode1
	and.w	#%0111111,d0		bit 7 clear = read <ea>
	bsr.b	handle_ea

	movem.l	(sp)+,d1-a6
	rts


;  IN: d0.w=UWORD ea_bits (bit 7 set if dest <ea>, bits 0-6 encode <ea>)
;      d1.w=UWORD opcode2
;      d2.w=UWORD operation_size (only needed for instruction supporting immed data src)
;	2=byte/word
;	4=long/single-precision
;	8=double-precision
;	12=extended-precision/packed-decimal real
; OUT: d0.l=ULONG ea size
handle_ea	movem.l	d1-d7,-(sp)
	move.l	d0,d5			d0=ea_bits <<16 | opcode2
	move.w	d0,d6			d6=opcode2
	swap	d5			d5=ea_bits

	move.w	d5,d0			??????????xxxyyy
	lsr.w	#2,d0			00??????????xxxy
	and.w	#%01110,d0		000000000000xxx0
	move.w	.ea_jmp(pc,d0.w),d0
	jmp	.ea_jmp(pc,d0.w)

.ea_jmp	dc.w	.ea000-.ea_jmp
	dc.w	.ea001-.ea_jmp
	dc.w	.ea010-.ea_jmp
	dc.w	.ea011-.ea_jmp
	dc.w	.ea100-.ea_jmp
	dc.w	.ea101-.ea_jmp
	dc.w	.ea110-.ea_jmp
	dc.w	.ea111-.ea_jmp

.ea000	; Dn				0
	moveq	#0,d0
	bra	.eadone
.ea001	; An				0
	moveq	#0,d0
	bra	.eadone
.ea010	; (An)				0
	moveq	#0,d0
	bra	.eadone
.ea011	; (An)+				0
	moveq	#0,d0
	bra	.eadone
.ea100	; -(An)				0
	moveq	#0,d0
	bra	.eadone
.ea101	; (d16,An)			1
.ea111_000	; (xxx).w			1
.ea111_010	; (d16,PC)			1
.ea111_110	; illegal
	moveq	#2,d0
	bra	.eadone
.ea111_001	; (xxx).l			2
.ea111_101	; illegal
	moveq	#4,d0
	bra	.eadone

.ea110	; (d8,An,Xn.SIZE*SCALE)		1
	; (bd,An,Xn.SIZE*SCALE)		1,2 or 3
	; ([bd,An],Xn.SIZE*SCALE,od)	1,2,3,4 or 5
	; ([bd,An,Xn.SIZE*SCALE],od)	1,2,3,4 or 5
.ea111_111	; illegal
.ea111_011	; (d8,PC,Xn.SIZE*SCALE)		1
	; (bd,PC,Xn.SIZE*SCALE)		1,2 or 3
	; ([bd,PC],Xn.SIZE*SCALE,od)	1,2,3,4 or 5
	; ([bd,PC,Xn.SIZE*SCALE],od)	1,2,3,4 or 5

	; Now we have an extension word, so lets examine the
	; extension word type (bit 8 0=brief 1=full)
	moveq	#2,d0
	btst	#8,d6
	beq.b	.eadone			brief extension word, always 1 word

	; full extension word, 1 to 5 words follow, lets
	; examine how many exactly:

; single effective address operation word format
; 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
;  x  x  x  x  x  x  x  x  x  x ==mode==  register

; brief extension word format
; 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
; d/a registe w/l scale 0 =====displacement======

; full extension word format
; 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
; d/a registe w/l scale 1  bs is bdsiz 0  ==i/is=
; ======base displacement (0, 1, or 2 words)=====
; =====outer displacement (0, 1, or 2 words)=====

; d/a	index register type
;	0 = dn
;	1 = an
; w/l	word/long-word index size
;	0 = sign-extended word
;	1 = long word
; scale	scale factor
;	00 = 1
;	01 = 2
;	10 = 4
;	11 = 8
; bs	base register suppress
;	0 = base register added
;	1 = base register suppressed
; is	index suppress
;	0 = evaluate and add index operand
;	1 = suppress index operand
; bd siz	base displacement size
;	00 = reserved
;	01 = null displacement
;	10 = word displacement
;	11 = long displacement
; i/is	index/indirect selection
;	indirect and indexing operand determined in
;	conjunction with is
;
; is	i/is	operation
; 0	000	no memory indirect action
; 0	001	indirect preindexed with null outer displacement
; 0	010	indirect preindexed with word outer displacement
; 0	011	indirect preindexed with long outer displacement
; 0	100	reserved
; 0	101	indirect postindexed with null outer displacement
; 0	110	indirect postindexed with word outer displacement
; 0	111	indirect postindexed with long outer displacement
; 1	000	no memory indirect action
; 1	001	memory indirect with null outer displacement
; 1	010	memory indirect with word outer displacement
; 1	011	memory indirect with long outer displacement
; 1	100	reserved
; 1	101	reserved
; 1	110	reserved
; 1	111	reserved

	; `bdsiz' is reserved (%00) ?
	moveq	#0,d0
	move.w	d6,d1
	and.w	#%00110000,d1
	beq	.eadone			illegal
	; mask in `is' and `i/is'
	move.w	d6,d1
	and.w	#%01000111,d1
	cmp.w	#%00000100,d1		`is'=0 `i/is'=100 is reserved, and
	beq.b	.eadone			thus illegal
	btst	#6,d1			`is' clear?
	beq.b	.not_res		clear, rest of the bit patterns ok
	btst	#2,d1			set, rest of the patterns with
	bne.b	.eadone			bit 2 set are illegal
.not_res
	moveq	#2,d0			default 1 word
	; get base displacement size
	move.w	d6,d1			??????????xx????
	lsr.w	#4,d1			0000??????????xx
	and.w	#%011,d1		00000000000000xx
	beq.b	.bd_n
	subq.w	#1,d1			0,1 or 2
	add.w	d1,d0
	add.w	d1,d0			add 0 2 or 4
.bd_n
	; get outer displacement size
	move.w	d6,d1
	and.w	#%011,d1
	beq.b	.od_n
	subq.w	#1,d1			0,1 or 2
	add.w	d1,d0
	add.w	d1,d0			add 0 2 or 4
.od_n
	; result: d0.l = 2, 4, 6, 8 or 10
	bra	.eadone


.ea111_100	; #<xxx>			1,2,4 or 6
	moveq	#2,d0
	add.w	d2,d0
	bra	.eadone

.ea111	move.w	d5,d0			??????????xxxyyy
	lsl.w	#1,d0			?????????xxxyyy0
	and.w	#%01110,d0		000000000000yyy0
	move.w	.ea111_jmp(pc,d0.w),d0
	jmp	.ea111_jmp(pc,d0.w)

.ea111_jmp	dc.w	.ea111_000-.ea111_jmp
	dc.w	.ea111_001-.ea111_jmp
	dc.w	.ea111_010-.ea111_jmp
	dc.w	.ea111_011-.ea111_jmp
	dc.w	.ea111_100-.ea111_jmp
	dc.w	.ea111_101-.ea111_jmp	illegal
	dc.w	.ea111_110-.ea111_jmp	illegal
	dc.w	.ea111_111-.ea111_jmp	illegal


.eadone	; d0.w=number of bytes in extension word(s)

	movem.l	(sp)+,d1-d7
	rts


	ENDC


	;
	; If you wonder how to generate this following
	; file:
	;
	; Compile RequestLong.ASM and execute it.
	; Included binary saver (bin.saver.ASM) will
	; generate requestlong.bin file.

RequestLong	incbin	"source:requestlong.bin"


AllocPatch
_idpos	dc.l	SMARTCRASH13_ID			4
_jmppos	jmp	'addt'				6
JMPADDROFFS	EQU	*-4-AllocPatch
TrapEntry	move.l	a0,-(sp)			2
	move.l	#'exec',a0			6
_ExecBase	EQU	*-4
	move.l	(ThisTask,a0),a0		4
	cmp.b	#NT_PROCESS,(LN_TYPE,a0)	6
	move.l	(sp)+,a0			2
	bne.b	TTaskCode			2
	jmp	'proc'				6
TrapProc	EQU	*-4
TTaskCode	jmp	'task'				6 =44
TrapTask	EQU	*-4
AllocPatch_SIZEOF	EQU	(*-AllocPatch+3)&-4

SetManPortName	dc.b	'SetMan',0
IntuiName	dc.b	'intuition.library',0
TaskName	dc.b	'SmartCrash.manager',0
SubName	dc.b	'SmartCrash.req',0
PortName	dc.b	'SmartCrash.port',0
WindowTitle	dc.b	'SmartCrash 1.3.0 Copyright © 1995-2000 Harry "Piru" Sintonen',0
SegTrackerName	dc.b	'SegTracker',0

BodyFmt	dc.b	'Exception %lx%s%s%s',10
	dc.b	'Task: %08lx  PC: %08lx  SR: %04lx  USP: %08lx  SSP: %08lx',10
	dc.b	'D: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx',10
	dc.b	'A: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx',10
	dc.b	'S: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx',10
	dc.b	'S: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx',10
	dc.b	'%.7s: %-.60s',10
	dc.b	'%s',0

sTask	dc.b	'Task',0
sProcess	dc.b	'Process'		No need to zero terminate
sCommand	dc.b	'Command'

sKnown	dc.b	': ',0
NullStr	EQU	*-1

	CNOP	0,2
ExceptionTable
.s	dc.w	-1,-1,s2-.s,s3-.s,s4-.s,s5-.s,s6-.s,s7-.s
	dc.w	s8-.s,s9-.s,s10-.s,s11-.s,-1,s13-.s,s14-.s,s15-.s
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	s24-.s,-1,-1,-1,-1,-1,-1,-1
	dc.w	s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s
	dc.w	s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s,s2x-.s
	dc.w	s48-.s,s49-.s,s50-.s,s51-.s,s52-.s,s53-.s,s54-.s,s55-.s
	dc.w	s56-.s,s57-.s,s58-.s,-1
	dc.w	s60-.s,s61-.s
	dc.w	-1,-1

s2	dc.b	'bus error',0
s3	dc.b	'address error',0
s4	dc.b	'illegal instruction',0
s5	dc.b	'zero divide',0
s6	dc.b	'chk instruction',0
s7	dc.b	'trapcc instruction',0
s8	dc.b	'privilege violation',0
s9	dc.b	'trace',0
s10	dc.b	'line-a emulator',0
s11	dc.b	'line-f emulator',0
s13	dc.b	'coprocessor protocol violation',0	;020/030
s14	dc.b	'format error',0
s15	dc.b	'uninitialized interrupt',0
s24	dc.b	'spurious interrupt',0
s2x	dc.b	'trap instruction #',0
s48	dc.b	'FP bsun',0				;88x/040/060
s49	dc.b	'FP inexact result',0			;88x/040/060
s50	dc.b	'FP zero divide',0			;88x/040/060
s51	dc.b	'FP underflow',0			;88x/040/060
s52	dc.b	'FP operand error',0			;88x/040/060
s53	dc.b	'FP overflow',0				;88x/040/060
s54	dc.b	'FP signaling NAN',0			;88x/040/060
s55	dc.b	'FP unimplemented data type',0		;040/060
s56	dc.b	'MMU configuration',0			;030/851
s57	dc.b	'MMU illegal operation',0		;851
s58	dc.b	'MMU access level violation',0		;851
s60	dc.b	'unimplemented effective address',0	;060
s61	dc.b	'unimplemented integer instruction',0	;060

GadgetFmt	dc.b	'S%skip|%sRemove|E%sxit|%sDebug|Reboot|%sJMP...|R%sTS|%sSuspend',0
UnderlStr	dc.b	'_',0
CLIFmt	dc.b	'CLI[%ld]: %-.54b',0

AT_LOCATE_P	MACRO	; x,y
_AT_X	SET	\1
_AT_Y	SET	\2
	ENDM

AT_LOCATE	MACRO	; xchar,ychar
_AT_X	SET	_AT_INITX+(\1*8)
	IFGT	NARG-1
_AT_Y	SET	_AT_INITY+(\2*_AT_YSPACE)
	ENDC
	ENDM

AT_SETYSPACE	MACRO	; yspacing
_AT_YSPACE	SET	\1
	ENDM

AT_INIT	MACRO	; [inityadd]
_AT_INITX	SET	16
_AT_WIDTH	SET	(640-_AT_INITX*2)/2
	IFGT	NARG
_AT_INITY	SET	12+\1
	ELSE
_AT_INITY	SET	12
	ENDC
_AT_X	SET	_AT_INITX
_AT_Y	SET	_AT_INITY
	AT_SETYSPACE	8
_AT_YMAX	SET	_AT_Y+_AT_YSPACE
_AT_FST	SET	0
	ENDM

AT_PRINT	MACRO
	IFEQ	_AT_FST
_AT_FST	SET	1
	ELSE
	dc.b	0,-1
	ENDC
	dc.b	(_AT_X/256)
	dc.b	(_AT_X&255)
	dc.b	_AT_Y

_AT_Y	SET	_AT_Y+_AT_YSPACE
	IFGT	_AT_Y-_AT_YMAX
_AT_YMAX	SET	_AT_Y
	ENDC
_AT_X	SET	_AT_INITX
	ENDM

AT_END	MACRO	; helabel
	dc.b	0,0
\1	dc.b	_AT_YMAX
	ENDM

AT_CENTRE	MACRO	;nextstringslen
	AT_LOCATE_P	_AT_INITX+_AT_WIDTH-\1*4,_AT_Y
	AT_PRINT
	ENDM


Alert01	AT_INIT		6
	AT_SETYSPACE	13
	AT_CENTRE	22
	dc.b		"Software Failure Alert"
	AT_SETYSPACE	16
	AT_CENTRE	34
	dc.b		"(couln't create failure requester)"
	AT_SETYSPACE	18
	AT_CENTRE	62
Alert01Buf	ds.b		62		'Error 00000000 at PC=00000000 Task=00000000 "NameOfTask"      '
	AT_CENTRE	46
	dc.b		"Press any mouse button to suspend the program."
	AT_END		Alert01_len
Alert01Fmt	dc.b		'Error %08lx at PC=%08lx Task=%08lx "%.17s',0


	CNOP	0,4
DT
DosBase	ds.l	1
IntuiBase	ds.l	1
_GfxBase	ds.l	1
RTBase	ds.l	1
MsgPort	ds.l	1
RecMem	ds.l	1
TrapEntryPtr	ds.l	1
SubTaskCnt	ds.l	1
sigb_EXITSUB	ds.l	1
sigf_EXITSUB	ds.l	1
sigf_REMOVED	ds.l	1
sigf_INITOK	ds.l	1
SigTask	ds.l	1
DefProcTrap	ds.l	1
DefTaskTrap	ds.l	1
FontBase	ds.l	1
_ThisTask	ds.l	1
HavePatchCtrl	ds.l	1

CrashData	ds.b	CD_SIZE

	CNOP	0,2
TAttr	ds.b	ta_SIZEOF
FontName	ds.b	MAXFONTNAMELEN


COPY_LEN	EQU	(*-COPY_START+3)&-4

	CNOP	0,4
sigb_REMOVED	ds.l	1
sigb_INITOK	ds.l	1
RDArgs	ds.l	1
ArgArray	ds.l	ARG_NUMARGS
SigThisTask	ds.l	1
Copy	ds.l	1
