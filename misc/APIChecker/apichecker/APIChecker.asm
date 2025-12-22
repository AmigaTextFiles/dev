;!CPY LCP:APIChecker
;;!OPT -m

;1996 Copyright by Stefan Fuchs

	include "ASMMacros.i"
	incdir "Include:"
	include dos/dosextens.i
	include exec/nodes.i
	include exec/memory.i
	include exec/io.i
	include exec/execbase.i
	include exec/tasks.i
	include "patchtags.i"

execbase	equ	4
_DOSBase	equr	A5
_PATCHBase	equr	A4



_LVOSupervisor                set  -30	;exec.library
;_LVOInitCode                  set  -72
_LVOInitStruct                set  -78
_LVOMakeLibrary               set  -84
_LVOMakeFunctions             set  -90
_LVOFindResident              set  -96
_LVOInitResident              set -102
_LVOAlert                     set -108
_LVODebug                     set -114
_LVODisable                   set -120
_LVOEnable                    set -126
_LVOForbid                    set -132
_LVOPermit                    set -138
_LVOSetSR                     set -144
_LVOSuperState                set -150
_LVOUserState                 set -156
_LVOSetIntVector              set -162
_LVOAddIntServer              set -168
_LVORemIntServer              set -174
_LVOCause                     set -180
_LVOAllocate                  set -186
_LVODeallocate                set -192
_LVOAllocMem                  set -198
_LVOAllocAbs                  set -204
_LVOFreeMem                   set -210
_LVOAvailMem                  set -216
_LVOAllocEntry                set -222
_LVOFreeEntry                 set -228
_LVOInsert                    set -234
_LVOAddHead                   set -240
_LVOAddTail                   set -246
_LVORemove                    set -252
_LVORemHead                   set -258
_LVORemTail                   set -264
_LVOEnqueue                   set -270
_LVOFindName                  set -276
_LVOAddTask                   set -282
_LVORemTask                   set -288
_LVOFindTask                  set -294
_LVOSetTaskPri                set -300
_LVOSetSignal                 set -306
_LVOSetExcept                 set -312
_LVOWait                      set -318
_LVOSignal                    set -324
_LVOAllocSignal               set -330
_LVOFreeSignal                set -336
_LVOAllocTrap                 set -342
_LVOFreeTrap                  set -348
_LVOAddPort                   set -354
_LVORemPort                   set -360
_LVOPutMsg                    set -366
_LVOGetMsg                    set -372
_LVOReplyMsg                  set -378
_LVOWaitPort                  set -384
_LVOFindPort                  set -390
_LVOAddLibrary                set -396
_LVORemLibrary                set -402
_LVOOldOpenLibrary            set -408
_LVOCloseLibrary              set -414
_LVOSetFunction               set -420
_LVOSumLibrary                set -426
_LVOAddDevice                 set -432
_LVORemDevice                 set -438
_LVOOpenDevice                set -444
_LVOCloseDevice               set -450
_LVODoIO                      set -456
_LVOSendIO                    set -462
_LVOCheckIO                   set -468
_LVOWaitIO                    set -474
_LVOAbortIO                   set -480
_LVOAddResource               set -486
_LVORemResource               set -492
_LVOOpenResource              set -498
_LVOexecPrivate7              set -504
_LVOexecPrivate8              set -510
_LVOexecPrivate9              set -516
_LVORawDoFmt                  set -522
_LVOGetCC                     set -528
_LVOTypeOfMem                 set -534
_LVOProcure                   set -540
_LVOVacate                    set -546
_LVOOpenLibrary               set -552
_LVOInitSemaphore             set -558
_LVOObtainSemaphore           set -564
_LVOReleaseSemaphore          set -570
_LVOAttemptSemaphore          set -576
_LVOObtainSemaphoreList       set -582
_LVOReleaseSemaphoreList      set -588
_LVOFindSemaphore             set -594
_LVOAddSemaphore              set -600
_LVORemSemaphore              set -606
_LVOSumKickData               set -612
_LVOAddMemList                set -618
_LVOCopyMem                   set -624
_LVOCopyMemQuick              set -630
_LVOCacheClearU               set -636
_LVOCacheClearE               set -642
_LVOCacheControl              set -648
_LVOCreateIORequest           set -654
_LVODeleteIORequest           set -660
_LVOCreateMsgPort             set -666
_LVODeleteMsgPort             set -672
_LVOObtainSemaphoreShared     set -678
_LVOAllocVec                  set -684
_LVOFreeVec                   set -690
_LVOCreatePool                set -696
_LVODeletePool                set -702
_LVOAllocPooled               set -708
_LVOFreePooled                set -714
_LVOAttemptSemaphoreShared    set -720
_LVOColdReboot                set -726
_LVOStackSwap                 set -732
_LVOChildFree                 set -738
_LVOChildOrphan               set -744
_LVOChildStatus               set -750
_LVOChildWait                 set -756
_LVOCachePreDMA               set -762
_LVOCachePostDMA              set -768
_LVOAddMemHandler             set -774
_LVORemMemHandler             set -780


_LVOOpen		=	-30	;dos.library
_LVOOutPut		=	-60

_LVOInstallPatchTagsA	=	-54	;patch.library
_LVORemovePatchTagsA	=	-60
_LVORemovePatchProjectA	=	-90
_LVOSetPatchA		=	-72
_LVOCreatePatchProjectA	=	-96

API_Ok		set 0		;Everything ok here
API_Warning     set 1		;This one works with the current OS, may fail in the future
API_Kludge	set 2		;there is a kludge in the OS to fix this
API_Bug		set 3		;this is a bug that may crash the machine

StartUp:
	sub.l a1,a1
	CALL _LVOFindTask,execbase
	move.l d0,a4
	tst.l pr_CLI(a4)
	bne Main
	lea pr_MsgPort(a4),a0
	CALL _LVOWaitPort
	lea pr_MsgPort(a4),a0
	CALL _LVOGetMsg
	move.l d0,-(sp)
	bsr Main
	move.l (sp)+,a1
	move.l d0,d5
	CALL _LVOForbid,execbase
	CALL _LVOReplyMsg
	move.l d5,d0
	rts

Main:
	sub.l	_DOSBase,_DOSBase
	sub.l	_PATCHBase,_PATCHBase
	move.l	execbase,a6

	OPENLIB dosname,0,DosFailed	;Open Dos Library
	move.l	d0,_DOSBase

	lea.l	Header(pc),a0		;Print Title Text
	bsr	TextOutput

	OPENLIB patchname,4,PatchFailed	;Open Patch Library Version 4
	move.l	d0,_PATCHBase
	move.l d0,patchbase


	move.l	_PATCHBase,a6
	lea.l ProjectName(pc),a0
	sub.l a1,a1
	jsr _LVOCreatePatchProjectA(a6)
	lea.l PatchInstallFailed(pc),a0
	move.l d0,d7
	BSREQ TextOutput,InstallFailed0

	lea.l	InstallTags(pc),a1
	move.l	execbase,4(a1)		;Pointer to Library
	lea.l	IDString(pc),a0		;ID for PatchList
	move.l	a0,12(a1)
	move.l	#20,20(a1)		;Priority 20
	move.l	d7,28(a1)


INPatch	macro		;Name of function to install patch
	lea.l	\1(pc),a0
	move.l	#_LVO\1,d0
	jsr	_LVOInstallPatchTagsA(a6)
	tst.l	d0
	beq	InstallFailed
	endm


	INPatch	Supervisor
		;InitCode	(nothing to test here)
	INPatch	InitStruct
	INPatch	MakeLibrary
	INPatch	MakeFunctions
	INPatch	FindResident
	INPatch	InitResident
		;Alert		(nothing to test here)
		;Debug		(nothing to test here)
		;Disable	(nothing to test here)
		;Enable		(nothing to test here)(could check nesting count)
		;Forbid		(nothing to test here)
		;Permit		(nothing to test here)(could check nesting count)
		;SetSR		(nothing to test here)
		;SuperState	(nothing to test here)
		;UserState	(nothing to test here)
	INPatch	SetIntVector
	INPatch	AddIntServer
	INPatch	RemIntServer
	INPatch	Cause
	INPatch	Allocate
	INPatch	Deallocate
	INPatch	AllocMem
	INPatch	AllocAbs
	INPatch	FreeMem
	INPatch	AvailMem
	INPatch	AllocEntry
	INPatch	FreeEntry
	INPatch	Insert
	INPatch	AddHead
	INPatch	AddTail
	INPatch	Remove
	INPatch	RemHead
	INPatch	RemTail
	INPatch	Enqueue
	INPatch	FindName
	INPatch	AddTask
	INPatch	RemTask
	INPatch	FindTask
	INPatch	SetTaskPri
		;SetSignal	(nothing to test here)
		;SetExcept	(nothing to test here)
		;Wait		(nothing to test here)
	INPatch	Signal
	INPatch	AllocSignal
	INPatch	FreeSignal
	INPatch	AllocTrap
	INPatch	FreeTrap
	INPatch	AddPort
	INPatch	RemPort
	INPatch	PutMsg
	INPatch	GetMsg
	INPatch	ReplyMsg
	INPatch	WaitPort
	INPatch	FindPort
	INPatch	AddLibrary
	INPatch	RemLibrary
	INPatch	OldOpenLibrary
	INPatch	CloseLibrary
	INPatch	SetFunction
	INPatch	SumLibrary
	INPatch	AddDevice
	INPatch	RemDevice
	INPatch	OpenDevice
	INPatch	CloseDevice
	INPatch	DoIO
	INPatch	SendIO
	INPatch	CheckIO
	INPatch	WaitIO
	INPatch	AbortIO
	INPatch	AddResource
	INPatch	RemResource
	INPatch	OpenResource
	INPatch	RawDoFmt
		;GetCC		(nothing to test here)
		;TypeOfMem	(nothing to test here)
	INPatch	OpenLibrary

	move.l execbase,a6
	cmp.w #33,20(a6)	;Test EXEC Version (V1.2)
	blt InstallPatchesSkip1
	move.l _PATCHBase,a6

	INPatch	InitSemaphore
	INPatch	ObtainSemaphore
	INPatch	ReleaseSemaphore
	INPatch	AttemptSemaphore
	INPatch	ObtainSemaphoreList
	INPatch	ReleaseSemaphoreList
	INPatch	FindSemaphore
	INPatch	AddSemaphore
	INPatch	RemSemaphore
		;SumKickData	(nothing to test here)
	INPatch	AddMemList
	INPatch	CopyMem
	INPatch	CopyMemQuick

	move.l execbase,a6
	cmp.w #36,20(a6)	;Test EXEC Version (V2.0)
	blt InstallPatchesSkip1
	move.l _PATCHBase,a6

	INPatch	CreateIORequest		(V36)
	INPatch	DeleteIORequest		(V36)
		;CreateMsgPort		(V36)	(nothing to test here)
	INPatch	DeleteMsgPort		(V36)
	INPatch	ObtainSemaphoreShared	(V36)
	INPatch	AllocVec		(V36)
	INPatch	FreeVec			(V36)
		;ColdReboot		(V36)	(nothing to test here)

	move.l execbase,a6
	cmp.w #37,20(a6)	;Test EXEC Version (V2.0)
	blt InstallPatchesSkip1
	move.l _PATCHBase,a6

	INPatch	AttemptSemaphoreShared	(V37)
;	INPatch	StackSwap		(V37)	(patch.library has problems with this function, cause still unknown)
		;CacheClearU		(V37)	(nothing to test here)
		;CacheClearE		(V37)	(nothing to test here)
		;CacheControl		(V37)	(nothing to test here)
		;CachePreDMA		(V37)	(nothing to test here)
		;CachePostDMA		(V37)	(nothing to test here)

	move.l execbase,a6
	cmp.w #39,20(a6)	;Test EXEC Version (V3.0)
	blt InstallPatchesSkip1
	move.l _PATCHBase,a6

	INPatch	CreatePool		(V39)
	INPatch	DeletePool		(V39)
	INPatch	AllocPooled		(V39)
	INPatch	FreePooled		(V39)
		;ChildFree	(sorry, no docs about these)
		;ChildOrphan	(sorry, no docs about these)
		;ChildStatus	(sorry, no docs about these)
		;ChildWait	(sorry, no docs about these)
	INPatch	Procure			(V39)
	INPatch	Vacate			(V39)
	INPatch	AddMemHandler		(V39)
	INPatch	RemMemHandler		(V39)
;90 functions

InstallPatchesSkip1:
MainLoop:
	moveq.l #0,d0
	bset.l #12,d0
	CALL _LVOWait,execbase


RemovePatches:
	move.l _PATCHBase,a6
	move.l d7,a0
	lea.l	RemoveTags(pc),a1
	jsr	_LVORemovePatchProjectA(a6)
	lea.l	RemFailed(pc),a0
	tst.l	d0
	BSRNE	TextOutput,MainLoop

AlreadyActive:
InstallFailed0:
	move.l	_PATCHBase,a1
	CALL	_LVOCloseLibrary,execbase	;Close patch Library

PatchFailed:
	cmp.l	#0,_PATCHBase
	bne	PatchFailedSkip
	lea.l	ReqPatchLib(pc),a0
	bsr	TextOutput

PatchFailedSkip:
	move.l	_DOSBase,a1
	CALL	_LVOCloseLibrary,execbase	;Close dos Library

DosFailed:
	moveq.l #0,d0
	rts
InstallFailed:
	lea.l	PatchInstallFailed(pc),a0
	bsr TextOutput
	bra RemovePatches
;----------------------------M A C R O S ------------------------
TESTNULL macro		;Register (in Grosschreibung)
	cmp.l #0,\1
	bne .\@
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .\1(pc),a1
	lea.l NullString(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0
.\@
	endm

TESTOBJ	macro		;Register (in Grosschreibung),Subroutine
	move.l d0,-(sp)
	move.l \1,d0
	bsr \2
	beq .\@
	movem.l a0-a2,-(sp)
	move.l d0,a2
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .\1(pc),a1
	bsr PrintMsg
	movem.l (sp)+,a0-a2
.\@	move.l (sp)+,d0
	endm
;--------------------------------------------------------

Supervisor:			;Finished
	TESTNULL A5
;	TESTOBJ A5,IsPointer	;This caused a crash

	rts
.Text:	dc.b "Supervisor",0
.A5:	dc.b "a5",0
	even
;------------------------------------------------------
InitStruct:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsInitTable

	TESTNULL A2
	TESTOBJ A2,IsPointer

	tst.l d0
	beq 2$

	movem.l d0,-(sp)
	move.l a2,d0
	btst.b #0,d0
	beq 1$

	movem.l a0-a2,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .A2(pc),a1
	lea.l .NoAlign(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2
1$	move.l (sp)+,d0

	btst.b #0,d0
	beq 2$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .SizeNotEven(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

2$

	rts
.Text:	dc.b "InitStruct",0
.A1:	dc.b "a1 (initTable)",0
.A2:	dc.b "a2 (memory)",0
.D0:	dc.b "d0 (size)",0
.SizeNotEven:	dc.b " is not even",0
.NoAlign:	dc.b " must be even, if d0 (size) is > 0",0
	even
;------------------------------------------------------
MakeLibrary:				;Finished
	TESTNULL A0
	TESTOBJ A0,IsPointer

	TESTOBJ A1,IsPointer

	TESTOBJ A2,IsInitTable

	cmp.l #LIB_SIZE,d0
	bge 5$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .LibSize(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

5$
	TESTOBJ D1,IsSegList

	rts
.Text:		dc.b "MakeLibrary",0
.LibSize:	dc.b "< sizeof(struct Library)",0
.A0:	dc.b "a0 (vectors)",0
.A1:	dc.b "a1 (structure)",0
.A2:	dc.b "a2 (init)",0
.D0:	dc.b "d0 (dSize)",0
.D1:	dc.b "d1 (segList)",0
	even
;------------------------------------------------------
MakeFunctions:
	TESTNULL A0
	TESTOBJ A0,IsPointer

	TESTNULL A1
	TESTOBJ A1,IsPointer		;Could test (if a2 was 0), if all pointers go to valid mem

	TESTOBJ A2,IsPointer

	rts
.Text:	dc.b "MakeFunctions",0
.A0:	dc.b "a0 (target)",0
.A1:	dc.b "a1 (functionArray)",0
.A2:	dc.b "a2 (funcDispbase)",0
	even
;------------------------------------------------------
FindResident:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsString

	rts
.Text:	dc.b "FindResident",0
.A1:	dc.b "a1 (name)",0
	even
;------------------------------------------------------
InitResident:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsResident

	TESTOBJ D1,IsSegList

	rts
.Text:	dc.b "InitResident",0
.A1:	dc.b "a1 (resident)",0
.D1:	dc.b "d1 (segList)",0
	even
;------------------------------------------------------
SetIntVector:			;Finished
	cmp.l #14,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalIntNum(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	TESTOBJ A1,IsInterrupt

	rts
.Text:		dc.b "SetIntVector",0
.IllegalIntNum:	dc.b " > 14",0
.D0:	dc.b "d0 (intNumber)",0
.A1:	dc.b "a1 (interrupt)",0
	even
;------------------------------------------------------
AddIntServer:			;Finished
	cmp.l #15,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalIntNum(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	TESTOBJ A1,IsInterrupt

	rts
.Text:		dc.b "AddIntServer",0
.IllegalIntNum:	dc.b " > 14",0
.D0:	dc.b "d0 (intNum)",0
.A1:	dc.b "a1 (interrupt)",0
	even
;------------------------------------------------------
RemIntServer:			;Finished
; May test, if last one in chain on pre-V36 versions (not very likely)
	cmp.l #14,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalIntNum(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	TESTNULL A1
	TESTOBJ A1,IsInterrupt

	rts
.Text:		dc.b "RemIntServer",0
.IllegalIntNum:	dc.b " > 15",0
.D0:	dc.b "d0 (intNumber)",0
.A1:	dc.b "a1 (interrupt)",0
	even
;------------------------------------------------------
Cause:				;Finished
	TESTNULL A1
	TESTOBJ A1,IsInterrupt

	cmp.l #0,a1
	beq 1$
	cmp.b #-32,LN_PRI(a1)
	beq 1$
	cmp.b #-16,LN_PRI(a1)
	beq 1$
	tst.b LN_PRI(a1)
	beq 1$
	cmp.b #16,LN_PRI(a1)
	beq 1$
	cmp.b #32,LN_PRI(a1)
	beq 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .A1(pc),a1
	lea.l .IllegalPri(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$

	rts
.Text:		dc.b "Cause",0
.A1:		dc.b "a1 (interrupt)",0
.IllegalPri:	dc.b "Illegal priority used",0
	even
;------------------------------------------------------
Allocate:			;Finished
	TESTNULL A0
	TESTOBJ A0,IsMemHeader

	tst.l d0
	bne 3$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

3$
	rts
.Text:	dc.b "Allocate",0
.A0:	dc.b "a0 (memHeader)",0
.D0:	dc.b "d0 (byteSize)",0
.SizeNull:	dc.b "= 0!",0
	even
;------------------------------------------------------
Deallocate:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsMemHeader

	TESTNULL A1
	TESTOBJ A1,IsPointer

	rts
.Text:	dc.b "Deallocate",0
.A0:	dc.b "a0 (memHeader)",0
.A1:	dc.b "a1 (memoryBlock)",0
	even
;------------------------------------------------------
AllocMem:		;Test MEMF_LARGEST
	tst.l d0
	bne 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	TESTOBJ D1,IsAttribute

	rts
.Text:		dc.b "AllocMem",0
.SizeNull:	dc.b " = 0!",0
.D0:	dc.b "d0 (byteSize)",0
.D1:	dc.b "d1 (attributes)",0
	even
;------------------------------------------------------
AllocAbs:			;Finished
	tst.l d0
	bne 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	TESTOBJ A1,IsAdress

	rts
.Text:	dc.b "AllocAbs",0
.SizeNull:	dc.b " = 0!",0
.D0:	dc.b "d0 (byteSize)",0
.A1:	dc.b "a1 (location)",0
	even
;------------------------------------------------------
FreeMem:		;Finished
	TESTNULL A1
	TESTOBJ	A1,IsPointer

	tst.l d0
	bne 2$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

2$

	rts
.Text:	dc.b "FreeMem",0
.A1:	dc.b "a1 (memoryBlock)",0
.D0:	dc.b "d0 (byteSize)",0
.SizeNull:	dc.b " = 0!",0
	even
;------------------------------------------------------
AvailMem:	;Test MEMF_LARGEST
	TESTOBJ D1,IsAttribute

	rts
.Text:	dc.b "AvailMem",0
.D1:	dc.b "d1 (attributes)",0
	even
;------------------------------------------------------
AllocEntry:	;Finished
	TESTNULL A0
	TESTOBJ A0,IsMemList

	rts
.Text:	dc.b "AllocEntry",0
.A0:	dc.b "a0 (memList)",0
	even
;------------------------------------------------------
FreeEntry:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsMemList_Active

	rts
.Text:	dc.b "FreeEntry",0
.A0:	dc.b "a0 (memList)",0
	even
;------------------------------------------------------
Insert:			;Finished
	TESTNULL A0
	TESTOBJ A0,IsHeader
	TESTNULL A1
	TESTOBJ A1,IsNode
	TESTOBJ A2,IsNode
;	TESTOBJ A2,IsNode_Active		;*** input.device and trackdisk.device seem to Insert() before nodes that are not part of the header list

	rts
.Text:	dc.b "Insert",0
.A0:	dc.b "a0 (list)",0
.A1:	dc.b "a1 (node)",0
.A2:	dc.b "a2 (listNode)",0
	even
;------------------------------------------------------
AddHead:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsHeader
	TESTNULL A1
	TESTOBJ A1,IsNode

	rts
.Text:	dc.b "AddHead",0
.A0:	dc.b "a0 (list)",0
.A1:	dc.b "a1 (node)",0
	even
;------------------------------------------------------
AddTail:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsHeader
	TESTNULL A1
	TESTOBJ A1,IsNode

	rts
.Text:	dc.b "AddTail",0
.A0:	dc.b "a0 (list)",0
.A1:	dc.b "a1 (node)",0
	even
;------------------------------------------------------
Remove:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsNode_Active

	rts
.Text:	dc.b "Remove",0
.A1:	dc.b "a1 (node)",0
	even
;------------------------------------------------------
RemHead:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsHeader
	rts
.Text:	dc.b "RemHead",0
.A0:	dc.b "a0 (list)",0
	even
;------------------------------------------------------
RemTail:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsHeader

	rts
.Text:	dc.b "RemTail",0
.A0:	dc.b "a0 (list)",0
	even
;------------------------------------------------------
Enqueue:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsHeader
	TESTNULL A1
	TESTOBJ A1,IsNode

	rts
.Text:	dc.b "Enqueue",0
.A0:	dc.b "a0 (list)",0
.A1:	dc.b "a1 (node)",0
	even
;------------------------------------------------------
FindName:
	TESTNULL A0
	TESTOBJ A0,IsPointer		;Maybe Header or Node
	TESTNULL A1
	TESTOBJ A1,IsString

	rts
.Text:	dc.b "FindName",0
.A0:	dc.b "a0 (start)",0
.A1:	dc.b "a1 (name)",0
	even
;------------------------------------------------------
AddTask:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsTask
	TESTNULL A2
	TESTOBJ A2,IsPointer
	TESTOBJ A3,IsPointer

	rts
.Text:	dc.b "AddTask",0
.A1:	dc.b "a1 (task)",0
.A2:	dc.b "a2 (initialPC)",0
.A3:	dc.b "a3 (finalPC)",0
	even
;------------------------------------------------------
RemTask:		;Finished
	TESTOBJ A1,IsTask_Active
	rts
.Text:	dc.b "RemTask",0
.A1:	dc.b "a1 (task)",0
	even
;------------------------------------------------------
FindTask:		;Finished
	TESTOBJ A1,IsString
	rts
.Text:	dc.b "FindTask",0
.A1:	dc.b "a1 (name)",0
	even
;------------------------------------------------------
SetTaskPri:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsTask_Active

	movem.l d0,-(sp)
	and.l #$ffffff00,d0
	beq 1$

	movem.l a0-a2,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .IllegalPri(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2
1$	move.l (sp)+,d0

	rts
.Text:	dc.b "SetTaskPri",0
.A1:	dc.b "a1 (task)",0
.IllegalPri:	dc.b " Value out of range",0
.D0:	dc.b "d0 (priority)",0
	even
;------------------------------------------------------
Signal:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsTask_Active

	rts
.Text:	dc.b "Signal",0
.A1:	dc.b "a1 (task)",0
	even
;------------------------------------------------------
AllocSignal:		;finished
	cmp.b #-1,d0
	beq 1$
	cmp.b #31,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalSignal(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	rts
.Text:	dc.b "AllocSignal",0
.D0:	dc.b "d0 (signalNum)",0
.IllegalSignal:	dc.b " Illegal value",0
	even
;------------------------------------------------------
FreeSignal:	;For pre V37 systems -1 is an illegal Signal number
	cmp.b #-1,d0
	beq 1$
	cmp.b #31,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalSignal(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	rts
.Text:	dc.b "FreeSignal",0
.D0:	dc.b "d0 (signalNum)",0
.IllegalSignal:	dc.b " Illegal value",0
	even
;------------------------------------------------------
AllocTrap:		;finished
	cmp.b #-1,d0
	beq 1$
	cmp.b #15,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalTrap(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	rts
.Text:	dc.b "AllocTrap",0
.D0:	dc.b "d0 (trapNum)",0
.IllegalTrap:	dc.b " Illegal value",0
	even
;------------------------------------------------------
FreeTrap:			;Finished
	cmp.b #15,d0
	ble 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Bug,d0
	lea.l .D0(pc),a1
	lea.l .IllegalTrap(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	rts
.Text:	dc.b "FreeTrap",0
.D0:	dc.b "d0 (trapNum)",0
.IllegalTrap:	dc.b " Illegal value",0
	even
;------------------------------------------------------
AddPort:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsPort_Simple

	rts
.Text:	dc.b "AddPort",0
.A1:	dc.b "a1 (port)",0
	even
;------------------------------------------------------
RemPort:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsPort_Active

	rts
.Text:	dc.b "RemPort",0
.A1:	dc.b "a1 (port)",0
	even
;------------------------------------------------------
PutMsg:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsPort
	TESTNULL A1
	TESTOBJ A1,IsMessage

	rts
.Text:	dc.b "PutMsg",0
.A0:	dc.b "a0 (port)",0
.A1:	dc.b "a1 (message)",0
	even
;------------------------------------------------------
GetMsg:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsPort

	rts
.Text:	dc.b "GetMsg",0
.A0:	dc.b "a0 (port)",0
	even
;------------------------------------------------------
ReplyMsg:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsMessage

	rts
.Text:	dc.b "ReplyMsg",0
.A1:	dc.b "a1 (message)",0
	even
;------------------------------------------------------
WaitPort:	;Finished
	TESTNULL A0
	TESTOBJ A0,IsPort
	rts
.Text:	dc.b "WaitPort",0
.A0:	dc.b "a0 (port)",0
	even
;------------------------------------------------------
FindPort:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsString

	rts
.Text:	dc.b "FindPort",0
.A1:	dc.b "a1 (name)",0
	even
;------------------------------------------------------
AddLibrary:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsLibrary

	rts
.Text:	dc.b "AddLibrary",0
.A1:	dc.b "a1 (library)",0
	even
;------------------------------------------------------
RemLibrary:
	TESTNULL A1
	TESTOBJ A1,IsLibrary_Active

	rts
.Text:	dc.b "RemLibrary",0
.A1:	dc.b "a1 (library)",0
	even
;------------------------------------------------------
OldOpenLibrary:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsString

	tst.b OpenLibWarning
	bne 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .Obs1(pc),a1
	lea.l .Obs(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	rts
.Text:	dc.b "OldOpenLibrary",0
.Obs1:	dc.b "OldOpenLibrary",0
.Obs:	dc.b " is an obsolete function since kick 1.1",0
.A1:	dc.b "a1 (libName)",0
	even
;------------------------------------------------------
CloseLibrary:		;In pre-V36 a1 may not be null
	TESTOBJ A1,IsLibrary_Active

	rts
.Text:	dc.b "CloseLibrary",0
.A1:	dc.b "a1 (library)",0
	even
;------------------------------------------------------
SetFunction:
	TESTNULL A1
	TESTOBJ A1,IsLibrary	;or Device or Resource?	_Active

	TESTNULL D0
	TESTOBJ D0,IsPointer


	rts
.Text:	dc.b "SetFunction",0
.A1:	dc.b "a1 (library)",0
.D0:	dc.b "d0 (funcEntry)",0
	even
;------------------------------------------------------
SumLibrary:
	TESTNULL A1
	TESTOBJ A1,IsLibrary	;or Device or Resource

	rts
.Text:	dc.b "SumLibrary",0
.A1:	dc.b "a1 (library)",0
	even
;------------------------------------------------------
AddDevice:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsDevice

	rts
.Text:	dc.b "AddDevice",0
.A1:	dc.b "a1 (device)",0
	even
;------------------------------------------------------
RemDevice:			;Finished
	TESTNULL A1
	TESTOBJ A1,IsDevice_Active

	rts
.Text:	dc.b "RemDevice",0
.A1:	dc.b "a1 (device)",0
	even
;------------------------------------------------------
OpenDevice:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsString

	TESTNULL A1
	TESTOBJ A1,IsIORequest

	rts
.Text:	dc.b "OpenDevice",0
.A0:	dc.b "a0 (devName)",0
.A1:	dc.b "a1 (iORequest)",0
	even
;------------------------------------------------------
CloseDevice:	;v36 allows a cleared IOrequest
	TESTNULL A1
	TESTOBJ A1,IsIORequest

	rts
.Text:	dc.b "CloseDevice",0
.A1:	dc.b "a1 (iORequest)",0
	even
;------------------------------------------------------
DoIO:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsIORequest_Active

	rts
.Text:	dc.b "DoIO",0
.A1:	dc.b "a1 (iORequest)",0
	even
;------------------------------------------------------
SendIO:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsIORequest_Active

	rts
.Text:	dc.b "SendIO",0
.A1:	dc.b "a1 (iORequest)",0
	even
;------------------------------------------------------
CheckIO:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsIORequest_Active

	rts
.Text:	dc.b "CheckIO",0
.A1:	dc.b "a1 (IORequest)",0
	even
;------------------------------------------------------
WaitIO:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsIORequest_Active

	rts
.Text:	dc.b "WaitIO",0
.A1:	dc.b "a1 (iORequest)",0
	even
;------------------------------------------------------
AbortIO:	;Finished
	TESTNULL A1
	TESTOBJ A1,IsIORequest_Active

	rts
.Text:	dc.b "AbortIO",0
.A1:	dc.b "a1 (iORequest)",0
	even
;------------------------------------------------------
AddResource:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsResource

	rts
.Text:	dc.b "AddResource",0
.A1:	dc.b "a1 (resource)",0
	even
;------------------------------------------------------
RemResource:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsResource_Active

	rts
.Text:	dc.b "RemResource",0
.A1:	dc.b "a1 (resource)",0
	even
;------------------------------------------------------
OpenResource:		;Finished
	TESTNULL A1
	TESTOBJ A1,IsString

	rts
.Text:	dc.b "OpenResource",0
.A1:	dc.b "a1 (resName)",0
	even
;------------------------------------------------------
RawDoFmt:
	TESTNULL A0
	TESTOBJ A0,IsString

;	TESTNULL A1	;Perhaps set a warning here as zero is not mentioned in the autodocs
	TESTOBJ A1,IsPointer

	TESTNULL A2
	TESTOBJ A2,IsPointer

	rts
.Text:	dc.b "RawDoFmt",0
.A0:	dc.b "a0 (FormatString)",0
.A1:	dc.b "a1 (DataStream)",0
.A2:	dc.b "a2 (PutChProc)",0
	even
;------------------------------------------------------
Procure:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsSemaphore
	TESTNULL A1
	TESTOBJ A1,IsBidMessage

	rts
.Text:	dc.b "Procure",0
.A0:	dc.b "a0 (semaphore)",0
.A1:	dc.b "a1 (bidMessage)",0
	even
;------------------------------------------------------
Vacate:		;Finished
	TESTNULL A0
	TESTOBJ A0,IsSemaphore
	TESTNULL A1
	TESTOBJ A1,IsBidMessage

	rts
.Text:	dc.b "Procure",0
.A0:	dc.b "a0 (semaphore)",0
.A1:	dc.b "a1 (bidMessage)",0
	even
;------------------------------------------------------
OpenLibrary:	;version is limited to a byte
	TESTNULL A1
	TESTOBJ A1,IsString

	rts
.Text:	dc.b "OpenLibrary",0
.A1:	dc.b "a1 (libName)",0
	even
;------------------------------------------------------
InitSemaphore:
	TESTNULL A0
	TESTOBJ A0,IsEmptySemaphore

	rts
.Text:	dc.b "InitSemaphore",0
.A0:	dc.b "a0 (signalSemaphore)",0
	even
;------------------------------------------------------
ObtainSemaphore:
	TESTNULL A0
	TESTOBJ A0,IsSemaphore

	rts
.Text:	dc.b "ObtainSemaphore",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
ReleaseSemaphore:
	TESTNULL A0
	TESTOBJ A0,IsSemaphore

	rts
.Text:	dc.b "ReleaseSemaphore",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
AttemptSemaphore:
	TESTNULL A0
	TESTOBJ A0,IsSemaphore

	rts
.Text:	dc.b "AttemptSemaphore",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
ObtainSemaphoreList:
	TESTNULL A0
	TESTOBJ A0,IsSemaphoreList

	rts
.Text:	dc.b "ObtainSemaphoreList",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
ReleaseSemaphoreList:
	TESTNULL A0
	TESTOBJ A0,IsSemaphoreList

	rts
.Text:	dc.b "ReleaseSemaphoreList",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
FindSemaphore:
	TESTNULL A1
	TESTOBJ A1,IsString

	rts
.Text:	dc.b "FindSemaphore",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
AddSemaphore:
	TESTNULL A1
	TESTOBJ A1,IsSemaphore

	rts
.Text:	dc.b "AddSemaphore",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
RemSemaphore:
	TESTNULL A1
	TESTOBJ A1,IsSemaphore_Active

	rts
.Text:	dc.b "RemSemaphore",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
AddMemList:
	TESTNULL D0

	TESTOBJ A1,IsString
	rts
.Text:	dc.b "AddMemList",0
.A1:	dc.b "a1",0
.D0:	dc.b "d0",0
	even
;------------------------------------------------------
CopyMem:
	TESTNULL A0
	TESTOBJ A0,IsPointer
	TESTNULL A1
	TESTOBJ A1,IsPointer

	rts
.Text:	dc.b "CopyMem",0
.A0:	dc.b "a0",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
CopyMemQuick:
	TESTNULL A0
	TESTOBJ A0,IsPointer
	TESTNULL A1
	TESTOBJ A1,IsPointer

	rts
.Text:	dc.b "CopyMemQuick",0
.A0:	dc.b "a0",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
CreateIORequest:
	TESTOBJ A0,IsPort
	rts
.Text:	dc.b "CreateIORequest",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
DeleteIORequest:
	TESTOBJ A0,IsIORequest
	rts
.Text:	dc.b "DeleteIORequest",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
DeleteMsgPort:
	TESTOBJ A0,IsPort

	rts
.Text:	dc.b "DeleteMsgPort",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
ObtainSemaphoreShared:
	TESTNULL A0
	TESTOBJ A0,IsSemaphore

	rts
.Text:	dc.b "ObtainSemaphoreShared",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
AllocVec:
	tst.l d0
	bne 1$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

1$
	rts
.Text:		dc.b "AllocVec",0
.SizeNull:	dc.b "Zero bytes allocation",0
.D0:		dc.b "d0",0
	even
;------------------------------------------------------
FreeVec:
	TESTOBJ A1,IsPointer

	rts
.Text:	dc.b "FreeVec",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
CreatePool:
	TESTNULL D1
	TESTNULL D2

2$
	rts
.Text:	dc.b "CreatePool",0
.D1:	dc.b "d1",0
.D2:	dc.b "d2",0
	even
;------------------------------------------------------
DeletePool:
	TESTNULL A0
	TESTOBJ A0,IsPoolHeader

	rts
.Text:	dc.b "DeletePool",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
AllocPooled:
	TESTNULL A0
	TESTOBJ A0,IsPoolHeader

	tst.l d0
	bne 2$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

2$
	rts
.Text:	dc.b "AllocPooled",0
.A0:	dc.b "a0",0
.D0:	dc.b "d0",0
.SizeNull:	dc.b "Zero bytes allocation",0
	even
;------------------------------------------------------
FreePooled:
	TESTNULL A0
	TESTOBJ A0,IsPoolHeader
	TESTNULL A1
	TESTOBJ A1,IsPointer

	tst.l d0
	bne 3$
	movem.l a0-a2/d0,-(sp)
	lea.l .Text(pc),a0
        moveq.l #API_Warning,d0
	lea.l .D0(pc),a1
	lea.l .SizeNull(pc),a2
	bsr PrintMsg
	movem.l (sp)+,a0-a2/d0

3$

	rts
.Text:	dc.b "FreePooled",0
.A0:	dc.b "a0",0
.A1:	dc.b "a1",0
.D0:	dc.b "d0",0
.SizeNull:	dc.b "Freeing zero bytes",0
	even
;------------------------------------------------------
AttemptSemaphoreShared:
	TESTNULL A0
	TESTOBJ A0,IsSemaphore

	rts
.Text:	dc.b "AttemptSemaphoreShared",0
.A0:	dc.b "a0",0
	even
;------------------------------------------------------
;StackSwap:
;	rts
;.Text:		dc.b "StackSwap",0
;	even
;------------------------------------------------------
;ChildFree:
;	rts
;.Text:		dc.b "ChildFree",0
;	even
;------------------------------------------------------
;ChildOrphan:
;	rts
;.Text:		dc.b "ChildOrphan",0
;	even
;------------------------------------------------------
;ChildStatus:
;	rts
;.Text:		dc.b "ChildStatus",0
;	even
;------------------------------------------------------
;ChildWait:
;	rts
;.Text:		dc.b "ChildWait",0
;	even
;------------------------------------------------------
;CachePreDMA:
;	rts
;.Text:		dc.b "CachePreDMA",0
;	even
;------------------------------------------------------
;CachePostDMA:
;	rts
;.Text:		dc.b "CachePostDMA",0
;	even
;------------------------------------------------------
AddMemHandler:
	TESTNULL A1
	TESTOBJ A1,IsInterrupt

	rts
.Text:	dc.b "AddMemHandler",0
.A1:	dc.b "a1",0
	even
;------------------------------------------------------
RemMemHandler:
	TESTNULL A1
	TESTOBJ A1,IsInterrupt

	rts
.Text:	dc.b "RemMemHandler",0
.A1:	dc.b "a1",0
	even
;----------------------------------------------------------------------
IsMemHeader:
IsResident:
IsInitTable:
IsInterrupt:
IsPoolHeader:
IsSemaphoreList:
IsSemaphore:
IsSemaphore_Active:
IsEmptySemaphore:
IsResource:
IsResource_Active:
IsIORequest:
IsIORequest_Active:
IsDevice:
IsDevice_Active:
IsLibrary:
IsLibrary_Active:
IsMessage:
IsBidMessage:
IsPort:
IsPort_Active:
IsPort_Simple:
;IsTask:
IsTask_Active:
IsMemList:
IsMemList_Active:
IsString:
IsPointer:
;Input:  d0= pointer
;Result: d0= Pointer to Errorstring or NULL, if memory is allocated
;	the zero flag is set accordingly
	movem.l d1-d2/a0-a1/a6,-(sp)

	move.l 4.w,a6
	jsr _LVOForbid(a6)
	move.l MemList(a6),a0

	move.l d0,d2
	beq IsPointerValid

IsPointerLoop:
	bsr IsFreemem
	beq IsPointerValid
	cmp.l #PToFreemem,d0
	beq PointerToFreemem

	move.l (a0),a0
	tst.l (a0)
	bne IsPointerLoop


	cmp.l #$00FFFFFF,d2
	bhi IsPointerNotValid
	move.l #$00FFFFFF,d0
	sub.l $00FFFFEC,d0
	cmp.l d0,d2
	bhi IsPointerValid

	bra IsPointerNotValid

IsPointerNotValid:
	jsr _LVOPermit(a6)
	movem.l (sp)+,d1-d2/a0-a1/a6
	move.l #IllegalPointer,d0
	rts
IsPointerValid:
	jsr _LVOPermit(a6)
	movem.l (sp)+,d1-d2/a0-a1/a6
	moveq.l #0,d0
	rts
PointerToFreemem:
;	move.l d2,d0
;	bsr PrintHexNumber
	jsr _LVOPermit(a6)
	movem.l (sp)+,d1-d2/a0-a1/a6
	tst.l d0
	rts
IllegalPointer:	dc.b "Pointer to illegal address",0
PToFreemem:	dc.b "Pointer to free memory",0
	even
;---------------------------------------
IsFreemem:
;a0= pointer to memory region
;d2= pointer
;Result: d0= Pointer to Errorstring or NULL, if memory is allocated
	movem.l a0/d1,-(sp)
	cmp.l MH_LOWER(a0),d2
	blo IsFreememIllegal
	cmp.l MH_UPPER(a0),d2
	bhi IsFreememIllegal

	bra IsFreememOk

	move.l MH_FIRST(a0),a0
IsFreememLoop:
	move.l a0,d1
	cmp.l d1,d2
	blo 1$
	add.l MC_BYTES(a0),d1
	cmp.l d1,d2
	blo IsFreememToFree

1$
	tst.l (a0)
	beq IsFreememOk
	move.l (a0),a0
	bra IsFreememLoop

IsFreememOk:
	movem.l (sp)+,a0/d1
	moveq.l #0,d0
	rts
IsFreememToFree:
	movem.l (sp)+,a0/d1
	move.l #PToFreemem,d0
	rts
IsFreememIllegal:
	movem.l (sp)+,a0/d1
	move.l #IllegalPointer,d0
	rts
;----------------------------------------
IsAdress:
	movem.l d1-d2/a0-a1/a6,-(sp)
	move.l d0,d2
	beq IsAdressValid
	move.l d0,a1
	move.l 4.w,a6
	jsr _LVOTypeOfMem(a6)
	tst.l d0
	beq IsAdressNotValid

IsAdressValid:
	movem.l (sp)+,d1-d2/a0-a1/a6
	moveq.l #0,d0
	rts
IsAdressNotValid:
	movem.l (sp)+,d1-d2/a0-a1/a6
	move.l #IllegalAdress,d0
	rts
IllegalAdress:	dc.b "Pointer to illegal address",0
	even
;--------------------------------------------------
IsSegList:
	lsl.l #2,d0
	bra IsPointer
;---------------------------------------
IsAttribute:
	moveq.l #0,d0
	rts
;---------------------------------------
IsHeader:
	movem.l d2/a0,-(sp)
	move.l d0,d2
	beq IsHeaderExit

	bsr IsPointer
	bne IsHeaderExit

	move.l d2,a0
	tst.l (a0)
	beq IsHeaderNotInit
	tst.l 8(a0)
	beq IsHeaderNotInit

IsHeaderLoop1:
	move.l (a0),a0
	move.l a0,d0
	bsr IsPointer
	bne IsHeaderExit

	tst.l (a0)
	bne IsHeaderLoop1

	sub.l #4,a0
	cmp.l a0,d2
	bne IsHeaderNoLink

	move.l d2,a0
	move.l 8(a0),a0
	tst.l 4(a0)
	beq IsHeaderSkip1
IsHeaderLoop2:
	move.l a0,d0
	bsr IsPointer
	bne IsHeaderExit

	move.l 4(a0),a0
	tst.l 4(a0)
	bne IsHeaderLoop2

IsHeaderSkip1:
	cmp.l a0,d2
	bne IsHeaderNoLink

	movem.l (sp)+,d2/a0
	moveq.l #0,d0
	rts
IsHeaderNoLink:
	movem.l (sp)+,d2/a0
	move.l #NoLink,d0
	rts
IsHeaderExit:
	movem.l (sp)+,d2/a0
	tst.l d0
	rts
IsHeaderNotInit:
	movem.l (sp)+,d2/a0
	move.l #NotInit,d0
	rts
NoLink:		dc.b "No double linked list",0
NotInit:	dc.b "Listheader not initialized via NEWLIST",0
	even
;----------------------------------------------------
IsNode:	bra IsPointer
;----------------------------------------------------
IsNode_Active:
;Perhaps should only check a fixed number of nodes, in order not to enter
;an endless loop.

	movem.l d2/a0,-(sp)
	move.l d0,d2
	beq IsNode_ActiveExit

	bsr IsNode
	bne IsNode_ActiveExit

	move.l d2,a0

IsNode_ActiveLoop1a:
	move.l (a0),a0
	move.l a0,d0
	bsr IsPointer
	bne IsNode_ActiveExit

	tst.l (a0)
	bne IsNode_ActiveLoop1a

	subq.l #4,a0

IsNode_ActiveLoop1b:
	move.l (a0),a0
	cmp.l a0,d2
	beq IsNode_ActiveLoop2a

	move.l a0,d0
	bsr IsPointer
	bne IsNode_ActiveExit

	tst.l (a0)
	bne IsNode_ActiveLoop1b

	bra IsNode_ActiveNoLink


IsNode_ActiveLoop2a:
	move.l 4(a0),a0

	move.l a0,d0
	bsr IsPointer
	bne IsNode_ActiveExit
	tst.l 4(a0)
	bne IsNode_ActiveLoop2a


	add.l #4,a0
IsNode_ActiveLoop2b:
	move.l 4(a0),a0
	cmp.l d2,a0
	beq IsNode_ActiveSkip

	move.l a0,d0
	bsr IsPointer
	bne IsNode_ActiveExit

	tst.l 4(a0)
	bne IsNode_ActiveLoop2b

	bra IsNode_ActiveNoLink


IsNode_ActiveSkip:
	movem.l (sp)+,d2/a0
	moveq.l #0,d0
	rts
IsNode_ActiveNoLink:
	movem.l (sp)+,d2/a0
	move.l #NoLink,d0
	rts
IsNode_ActiveExit:
	movem.l (sp)+,d2/a0
	tst.l d0
	rts
;--------------------------------------------------------------
IsTask:
	movem.l d2/a0,-(sp)
	move.l d0,d2
	beq IsTaskExit

	bsr IsPointer
	bne IsTaskExit

	move.l d2,a0
	move.l LN_NAME(a0),d0
	bsr IsString
	bne IsTaskNoName

	cmp.b #NT_TASK,LN_TYPE(a0)
	beq 1$
	cmp.b #NT_PROCESS,LN_TYPE(a0)
	bne IsTaskIllegalNode

1$
	movem.l (sp)+,d2/a0
	moveq.l #0,d0
	rts

IsTaskNoName:
	movem.l (sp)+,d2/a0
	move.l #NoName,d0
	rts
IsTaskIllegalNode:
	movem.l (sp)+,d2/a0
	move.l #IllegalNode,d0
	rts
IsTaskExit:
	movem.l (sp)+,d2/a0
	tst.l d0
	rts
NoName:		dc.b "Tasks must be named",0
IllegalNode:	dc.b "Type must be either NT_TASK or NT_PROCESS",0
	even
******************************************************************V1.5*
* Name:		GetTaskString
* Function:	Returns the name of the current task or
*		the filename of the current process
* Version:	V1.0	()
* Creation Date:25.12.1995
* Last Change:	25.12.1995
* Assembler:	OMA V3.00
* Assem. opts:	
* Linker opts:	no Linker required
* Files needed:	ASMMacros.i
* Copyright:	1995 Stefan Fuchs
*
* Inputs:	
* Assumptions:	exec/tasks.i, dos/dosextens.i
* Results:	d0= pointer to name or filename identifying this task
* Destroyed registers: d0/d1/a0/a1
* Code:		NOT reentrant/pc-relative
* Routine type:	universal
* Known bugs:	
* See also:	
* Notes:	As this function uses a static buffer it is not reentrant
*		If you us this code in an library Environment, you must
*		execute the code in forbid (or use a semaphore protection)
*		until you are done with the result.
***********************************************************************
GetTaskString:
	movem.l a2/a6,-(sp)

	sub.l a1,a1
	move.l execbase,a6
	move.l ThisTask(a6),a2


	move.b 8(a2),d0
	and.l #$f,d0
	cmp.b #NT_PROCESS,d0
	bne GetTaskStringKeepTask

	move.l pr_CLI(a2),d0
	beq GetTaskStringKeepTask
	lsl.l #2,d0
	move.l d0,a0
	tst.l cli_Module(a0)
	beq GetTaskStringKeepTask
	move.l cli_CommandName(a0),d0
	beq GetTaskStringKeepTask
	lsl.l #2,d0
	move.l d0,a0

	moveq.l #0,d0
	move.b (a0)+,d0
	beq GetTaskStringKeepTask
	move.l d0,d1
	lea.l GetTaskStringBuffer(pc),a1

	subq.l #1,d0
GetTaskStringCopyLoop:
	move.b (a0)+,(a1)+
	dbra d0,GetTaskStringCopyLoop
	move.b #0,(a1)

	lea.l GetTaskStringBuffer(pc),a0
	move.l a0,d1
	bsr FilePart
	tst.l d0
	beq GetTaskStringKeepTask
	move.l d0,a1

	tst.b (a1)
	beq GetTaskStringKeepTask

	movem.l (sp)+,a2/a6
	rts


GetTaskStringKeepTask:
	move.l 10(a2),d0
	movem.l (sp)+,a2/a6
	rts
GetTaskStringBuffer:	ds.b 256
;-------------------------------------------------------------
FilePart:
;d1= Pointer to C-String
;Result: d0= Pointer to Filename
	move.l	a3,-(sp)
	move.l	d1,a3
	moveq.l	#'/',d0
	move.l	a3,a0
	bsr	SearchLastByte
	move.l	d0,a0
	tst.l	d0
	bne	FilePartLashFound
	moveq.l	#':',d0
	move.l	a3,a0
	bsr	SearchByte
	move.l	d0,a0
	tst.l	d0
	bne	FilePartDPointFound
	move.l	a3,d0
	bra	FilePartExit

FilePartDPointFound:
FilePartLashFound:
	addq.l	#1,a0
	move.l	a0,d0
FilePartExit:
	move.l	(sp)+,a3
	rts

SearchByte:
;a0= C-String
;d0= Byte to Search
;Result: d0= Pointer to Byte found or zero (not found)
	move.b	(a0)+,d1
	beq	SearchByteNotFound
	cmp.b	d1,d0
	bne	SearchByte
	subq.l	#1,a0
	move.l	a0,d0
	rts
SearchByteNotFound:
	moveq.l	#0,d0
	rts

SearchLastByte:
;a0= C-String
;d0= Byte to Search
;Result: d0= Pointer to last byte found or zero (not found)
	sub.l	a1,a1
SearchLastByteLoop:
	move.b	(a0)+,d1
	beq	SearchLastByteExit
	cmp.b	d1,d0
	bne	SearchLastByteLoop
	lea.l	-1(a0),a1
	bra	SearchLastByteLoop
SearchLastByteExit:
	move.l	a1,d0
	rts
******************************************************************V1.5*
* Name:		AAllocmem
* Function:	Allocates memory and remembers size
* Version:	V1.0	()
* Creation Date:01.04.1993
* Last Change:	01.04.1993
* Assembler:	OMA V2.00
* Assem. opts:
* Linker opts:	no Linker required
* Files needed:	
* Copyright:	1993 Stefan Fuchs
*
* Inputs:	d0 = ByteSize or Null for no action
*		d1 = Attributes
* Assumptions:	
* Results:	d0 = pointer to memory or Null on error
* Destroyed registers: 
* Code:		reentrant/pc-relative
* Routine type:	low-level
* Known bugs:	
* See also:	Allocmem(), AllocVec()
* Notes:	
***********************************************************************
AAllocmem:
	movem.l d1/d2/a0-a1/a6,-(sp)
	tst.l d0
	beq AAllocmemExit
	add.l #8,d0
	move.l d0,d2
	move.l 4.w,a6
	jsr -198(a6)
	tst.l d0
	beq AAllocmemExit
	move.l d0,a0
	move.l d2,(a0)+
	move.l a0,d0
AAllocmemExit:
	movem.l (sp)+,d1/d2/a0-a1/a6
	rts
******************************************************************V1.5*
* Name:		AFreemem
* Function:	Frees memory allocated with AAllocmem
* Version:	V1.0	()
* Creation Date:01.04.1993
* Last Change:	01.04.1993
* Assembler:	OMA V2.00
* Assem. opts:	
* Linker opts:	no Linker required
* Files needed:	
* Copyright:	1993 Stefan Fuchs
*
* Inputs:	a0= pointer to memory or null for no action
* Assumptions:	
* Results:	
* Destroyed registers: 
* Code:		reentrant/pc-relative
* Routine type:	low-level
* Known bugs:	
* See also:	
* Notes:	
***********************************************************************
AFreemem:
	movem.l d0-d1/a0-a1/a6,-(sp)
	cmp.l #0,a0
	beq AFreememExit
	move.l a0,a1
	move.l -(a1),d0
	move.l 4.w,a6
	jsr -210(a6)
AFreememExit:
	movem.l (sp)+,d0-d1/a0-a1/a6
	rts
*************************************************************
* Name:		Compare_C_Strings
* Function:	Compares two C-Strings
* Version:	V1.15	(not tested)
* Assembler:	MasterSeka V1.75 & OMA V1.81
* Copyright:	1991 Stefanb Fuchs
*
* Inputs:	a0= C-String	a1= C-String
* Assumptions:	
* Results:	d0= 0:Strings are equal  -1: Strings are not equal
* Destroyed registers:	a0,a1,d0
* Code:		pc-relative
* Known bugs:	
* See also:	
* Notes:	Warning this version has new results
*************************************************************
Compare_C_Strings:
	cmpm.b (a0)+,(a1)+
	bne.s Compare_C_Strings_NotEqual
	tst.b -1(a0)
	bne.s Compare_C_Strings
	moveq.l #0,d0
	rts
Compare_C_Strings_NotEqual:
	moveq.l #-1,d0
	rts
******************************************************************V1.3*
* Name:		TextOutput
* Function:	Writes a C-string to std output (CLI,PRT,...)
* Version:	V1.2	(works)
* Assembler:	MasterSeka V1.75 & OMA V1.81
* Copyright:	1991 Stefan Fuchs
*
* Inputs:	a0 = Pointer to a C-string
* Assumptions:	DosBase
* Results:	
* Destroyed registers:
* Code:		pc-relative
* Known bugs:	
* See also:	
* Notes:	Exits without any output,
*		if the Outputhandle or a0 is null
***********************************************************************
TextOutput:
	movem.l d0-d3/a0/a1/a6,-(sp)
	moveq.l #0,d3
	move.l a0,d2
	beq.s TextOutputExit
TextOutputLoop:
	addq.l #1,d3
	tst.b (a0)+
	bne.S TextOutputLoop
	move.l _DOSBase,a6
	jsr -60(a6)	;OutPut
	move.l d0,d1
	beq.s TextOutputExit
	jsr -48(a6)	;Write
TextOutputExit:
	movem.l (sp)+,d0-d3/a0/a1/a6
	rts
;--------------------------------------
RemFailed:		dc.b "Can't remove patches - CTRL-C to retry",10,0
AlreadyActiveText:	dc.b "APIChecker already active !",10,0
PatchInstallFailed:	dc.b "Failed to install patches!",10,0
ProjectName:		dc.b "APIChecker",0

	even

InstallTags:	dc.l PATT_LibraryBase,0
		dc.l PATT_PatchName,0
		dc.l PATT_Priority,0
		dc.l PATT_ProjectID,0
		dc.l 0
RemoveTags:	dc.l PATT_TimeOut,50
		dc.l 0
FindPatchTags:	dc.l PATT_ProjectID,ProjectName
		dc.l 0
patchbase	dc.l 0

dosname		dc.b "dos.library",0
patchname	dc.b "patch.library",0
		dc.b "$VER: APIChecker 0.1 (10.02.96) by Stefan Fuchs",0
Header		dc.b $9B,"1;33",$6D,"APIChecker V0.1",$9B,$6D," (C) 1996 by Stefan Fuchs",10,0
ReqPatchLib:	dc.b "*** Requires patch.library V4+ in libs:",10,0
IDString:	dc.b "APIChecker",0

;ConfigurationSpace
OpenLibWarning:	dc.b 1


NullString:	dc.b " = 0!",0


	CNOP 0,4
;---------------------------------------- DEBUG ONLY ------------------------
;exec Private Functions:
InitSerial	= -504
WriteSerial	= -516

PrintMsg:
;d0 = ErrorLevel
;a0 = LvoText
;a1 = Text (Object of error)
;a2 = Text (Cause of error)
	move.l a6,-(sp)
	move.l 4.w,a6
	jsr _LVODisable(a6)
	jsr InitSerial(a6)

	bsr PrintFirstLine
	bsr PrintInfo
	jsr _LVOEnable(a6)
	move.l (sp)+,a6
	rts
;---------------------------------
PrintFirstLine:
;d0 = ErrorLevel
;a0 = LvoText
;a6 = Execbase
	movem.l d0-d1/a0-a1,-(sp)

	move.l a0,a1

        tst.l d0
	beq PrintFirstLineExit

        lea.l WarningText(pc),a0
	cmp.b #API_Warning,d0
	beq PrintFirstLineSkip
        lea.l KludgeText(pc),a0
	cmp.b #API_Kludge,d0
	beq PrintFirstLineSkip
        lea.l BugText(pc),a0

PrintFirstLineSkip:
	bsr PrintTextSerial

	move.l a1,a0
	bsr PrintTextSerial

	lea.l Text1(pc),a0
	bsr PrintTextSerial

	bsr GetTaskString
	move.l d0,a0
	bsr PrintTextSerial

	lea.l Text2(pc),a0
	bsr PrintTextSerial

	move.l ThisTask(a6),d0
	bsr PrintHexNumber

	moveq.l #$A,d0
	jsr WriteSerial(a6)

PrintFirstLineExit:
	movem.l (sp)+,d0-d1/a0-a1
	rts
WarningText:	dc.b "Warning ",0
KludgeText:	dc.b "KLUDGE  ",0
BugText:	dc.b "**BUG** ",0
Text1:		dc.b "()  Task: ",0
Text2:		dc.b "  at: ",0
Text3:		dc.b "   ",0
	even
;-----------------
PrintInfo:
;a1 = Text
;a2 = secondaryText
	movem.l d0/a0-a1,-(sp)

	lea.l Text3(pc),a0
	bsr PrintTextSerial

	move.l a1,a0
	bsr PrintTextSerial

	moveq.l #' ',d0
	jsr WriteSerial(a6)

	move.l a2,a0
	bsr PrintTextSerial

	moveq.l #$A,d0
	jsr WriteSerial(a6)

	movem.l (sp)+,d0/a0-a1
	rts
;---------------------------------------------
PrintHexNumber:
;d0= number
;a6= Execbase
	movem.l a0/a1/d1/d2,-(sp)

	move.l d0,-(sp)
	jsr InitSerial(a6)
	moveq.l #'$',d0
	jsr WriteSerial(a6)
	move.l (sp)+,d0

	sub.l #10,a7
	move.l a7,a0
	move.l #9,d1
	moveq.l #'0',d2
	bsr MakeHexString

	bsr PrintTextSerial
	add.l #10,a7
	movem.l (sp)+,a0/a1/d1/d2

	rts
;-------------------------------------
PrintTextSerial:
;a0= Pointer to C-String
;a6= Execbase
;zerstoert a0,d0

PrintTextSerialLoop:
	moveq.l #0,d0
	move.b (a0)+,d0
	beq PrintTextSerialExit
	jsr WriteSerial(a6)
	bra PrintTextSerialLoop

PrintTextSerialExit:
	rts
******************************************************************V1.5*
* Name:		MakeHexString
* Function:	Converts a number to a C-String containing HexChars
* Version:	V1.0	()
* Creation Date:06.08.1992
* Last Change:	07.08.1992
* Assembler:	MasterSeka V1.75 & OMA V2.00
* Assem. opts:
* Linker opts:	no Linker required
* Files needed:	
* Copyright:	1992 Stefan Fuchs
*
* Inputs:	a0= Pointer to Stringbuffer
*		d0= Number
*		d1= Length of Stringbuffer	(Mind. 2Bytes)
*		d2= fill char preceeding Number (right alignment)
*		    or Null for left alignment
* Assumptions:	
* Results:	d0= 0: Ok	-1: Number doesn't fit in Stringbuffer
* Destroyed registers: d0
* Code:		reentrant/pc-relative
* Routine type:	low-level
* Known bugs:	
* See also:	
* Notes:	
***********************************************************************
MakeHexString:
	movem.l d1-d4/d7/a0/a1,-(sp)
	move.l d0,d4
	moveq.l #0,d3
MakeHexStringCountLoop:
	addq.l #1,d3
	lsr.l #4,d4
	tst.l d4
	bne MakeHexStringCountLoop
;d3= now: number of characters

	cmp.l d3,d1
	ble MakeHexStringError

	tst.b d2
	beq MakeHexStringSkip1	;align right

	move.l d1,d7
	sub.l d3,d7
	subq.l #2,d7
	cmp.l #-1,d7		;String just fits
	beq MakeHexStringSkip1
MakeHexStringFillLoop:
	move.b d2,(a0)+
	dbra d7,MakeHexStringFillLoop

;d2 => can now be reused

MakeHexStringSkip1:
	move.b #0,(a0,d3)
	subq.l #1,d3
	move.b #'0',(a0,d3)

	move.l	d0,d2
	lea HexChars(pc),a1
MakeHexStringLoop:
	move.l	d2,d0
	and.l	#$000f,d0
	move.b	0(a1,d0.w),(a0,d3)
	lsr.l	#4,d2
	dbra d3,MakeHexStringLoop

	movem.l (sp)+,d1-d4/d7/a0/a1
	moveq.l #0,d0
	rts
MakeHexStringError:
	movem.l (sp)+,d1-d4/d7/a0/a1
	moveq.l #-1,d0
	rts
HexChars:	dc.b	'0123456789abcdef'
	EVEN

		END
