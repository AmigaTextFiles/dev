;ShowNeededFiles V1.0
;(C) 1993 Stefan Fuchs


	include ASMMacros.i
	include dos/dosextens.i

ExecBase	=	4
Wait		=	-318		;Exec
FindTask	=	-294

LoadSeg		=	-150		;Dos
Open		=	-30
OutPut		=	-60
Lock		=	-84
IOErr		=	-132

InstallPatch	=	-30		;Patch
WaitRemovePatch	=	-36

Main:
	OPENLIB DosName,0,NoDosExit		;Open Dos Library
	move.l d0,a5

	CALL OutPut,a5				;Get Outputhandle
	move.l d0,OutPutHandle
	beq NoOutPutExit

	OPENLIB PatchName,0,FailedToOpenPatch	;Open Patch Library
	move.l d0,a4


; Install patches

	lea.l NPatchStructPreLoadSeg(pc),a0
	CALL InstallPatch,a4
	move.l a5,a6
	lea.l PreLoadSegFailed(pc),a0
	move.l d0,PreLoadSegPatch
	BSREQ TextOutput

	lea.l NPatchStructPreOpen(pc),a0
	CALL InstallPatch,a4
	move.l a5,a6
	lea.l PreOpenFailed(pc),a0
	move.l d0,PreOpenPatch
	BSREQ TextOutput

	lea.l NPatchStructPreLock(pc),a0
	CALL InstallPatch,a4
	move.l a5,a6
	lea.l PreLockFailed(pc),a0
	move.l d0,PreLockPatch
	BSREQ TextOutput

	lea.l NPatchStructAfterLoadSeg(pc),a0
	CALL InstallPatch,a4
	move.l a5,a6
	lea.l AfterLoadSegFailed(pc),a0
	move.l d0,AfterLoadSegPatch
	BSREQ TextOutput

	lea.l NPatchStructAfterOpen(pc),a0
	CALL InstallPatch,a4
	move.l a5,a6
	lea.l AfterOpenFailed(pc),a0
	move.l d0,AfterOpenPatch
	BSREQ TextOutput

	lea.l NPatchStructAfterLock(pc),a0
	CALL InstallPatch,a4
	move.l a5,a6
	lea.l AfterLockFailed(pc),a0
	move.l d0,AfterLockPatch
	BSREQ TextOutput


MainLoop:				;Wait for CTRL-C
	moveq.l #0,d0
	bset.l #12,d0
	CALL Wait,ExecBase


;Patches entfernen
	move.l PreLoadSegPatch,a0
	CALL WaitRemovePatch,a4
	move.l a5,a6
	lea.l PreLoadSegRemFailed(pc),a0
	tst.l d0
	BSRNE TextOutput,MainLoop
	move.l d0,PreLoadSegPatch

	move.l PreOpenPatch,a0
	CALL WaitRemovePatch,a4
	move.l a5,a6
	lea.l PreOpenRemFailed(pc),a0
	tst.l d0
	BSRNE TextOutput,MainLoop
	move.l d0,PreOpenPatch

	move.l PreLockPatch,a0
	CALL WaitRemovePatch,a4
	move.l a5,a6
	lea.l PreLockRemFailed(pc),a0
	tst.l d0
	BSRNE TextOutput,MainLoop
	move.l d0,PreLockPatch

	move.l AfterLoadSegPatch,a0
	CALL WaitRemovePatch,a4
	move.l a5,a6
	lea.l AfterLoadSegRemFailed(pc),a0
	tst.l d0
	BSRNE TextOutput,MainLoop
	move.l d0,AfterLoadSegPatch

	move.l AfterOpenPatch,a0
	CALL WaitRemovePatch,a4
	move.l a5,a6
	lea.l AfterOpenRemFailed(pc),a0
	tst.l d0
	BSRNE TextOutput,MainLoop
	move.l d0,AfterOpenPatch

	move.l AfterLockPatch,a0
	CALL WaitRemovePatch,a4
	move.l a5,a6
	lea.l AfterLockRemFailed(pc),a0
	tst.l d0
	BSRNE TextOutput,MainLoop
	move.l d0,AfterLockPatch


	move.l a4,d1		;Close Patch Library
	CLOSELIB d1
	bra CloseDosSkip

FailedToOpenPatch:
	move.l a5,a6		;No Patch Library warning
	lea.l NoPatchText(pc),a0
	bsr TextOutput

CloseDosSkip:
NoOutPutExit:
	move.l a5,d1		;Close Dos Libray
	CLOSELIB d1
NoDosExit:

	rts
;----------------------------
PreLoadSeg:			;Patch routines
	movem.l a0,-(sp)
	lea.l LoadSegText(pc),a0
	bsr TextOutput
	move.l d1,a0
	bsr TextOutput
	move.l (sp)+,a0
	rts
;------
AfterLoadSeg:
AfterOpen:
AfterLock:
	movem.l a0/d7,-(sp)
	lea.l SuccessfulText(pc),a0
	tst.l d0
	bne.s AfterLoadsegSkip
	lea.l FailedText(pc),a0
AfterLoadsegSkip:
	bsr GetIOErr
	bsr TextOutput
	lea.l ReturnText(pc),a0
	bsr TextOutput
	bsr SetIOErr
	movem.l (sp)+,a0/d7
	rts
;-------
PreOpen:
	move.l a0,-(sp)
	lea.l OpenText(pc),a0
	bsr TextOutput
	move.l d1,a0
	bsr TextOutput
	move.l (sp)+,a0
	rts
;-------
PreLock:
	move.l a0,-(sp)
	lea.l LockText(pc),a0
	bsr TextOutput
	move.l d1,a0
	bsr TextOutput
	move.l (sp)+,a0
	rts
;------------------------------------
;This routines are needed to preserve the IOErr field
;It gets destroyed, when i do a dos.library/write()
GetIOErr:
;a6 = DosBase
;Result: d7 = errorcode
	movem.l d0/d1/a0/a1,-(sp)
	CALL IOErr
	move.l d0,d7
	movem.l (sp)+,d0/d1/a0/a1
	rts
;--------------
SetIOErr:
;I know i should have used dos.library/SetIOErr(),
;but I care for poor V33 users
;d7 = old errorcode
	movem.l d0/d1/a0/a1/a6,-(sp)
	sub.l a1,a1
	CALL FindTask,ExecBase
	move.l d0,a0
	move.l d7,pr_Result2(a0)
	move.l pr_CLI(a0),d0
	beq SetIOExit
	lsl.l #2,d0
	move.l d0,a0
	move.l d7,cli_Result2(a0)

SetIOExit:
	movem.l (sp)+,d0/d1/a0/a1/a6
	rts
;------------------------------------------------
;a0 = Pointer to a C-string
;a6 = DosBase
TextOutput:
	movem.l d0-d3/a0/a1,-(sp)
	moveq.l #50,d0
	moveq.l #0,d3
	move.l a0,d2
	beq.s TextOutputExit
TextOutputLoop:
	addq.l #1,d3
	tst.b (a0)+
	dbeq d0,TextOutputLoop
	move.l OutPutHandle,d1
	jsr -48(a6)	;Write
TextOutputExit:
	movem.l (sp)+,d0-d3/a0/a1
	rts
;--------------------------------------
OutPutHandle:		dc.l 0
PreLoadSegPatch:	dc.l 0
PreOpenPatch:		dc.l 0
PreLockPatch:		dc.l 0
AfterLoadSegPatch:	dc.l 0
AfterOpenPatch:		dc.l 0
AfterLockPatch:		dc.l 0

		dc.b "SNF is copyright 1993 by Stefan Fuchs"

DosName:	dc.b "dos.library",0
PatchName:	dc.b "patch.library",0
NoPatchText:	dc.b "SNF requires patch.library in LIBS:",10,0
PreLoadSegFailed:	dc.b "Can't install 1. LoadSeg() patch",10,0
PreOpenFailed:		dc.b "Can't install 1. Open() patch",10,0
PreLockFailed:		dc.b "Can't install 1. Lock() patch",10,0
AfterLoadSegFailed:	dc.b "Can't install 2. LoadSeg() patch",10,0
AfterOpenFailed:	dc.b "Can't install 2. Open() patch",10,0
AfterLockFailed:	dc.b "Can't install 2. Lock() patch",10,0
PreLoadSegRemFailed:	dc.b "Can't remove 1. LoadSeg() patch - CTRL-C to retry",10,0
PreOpenRemFailed:	dc.b "Can't remove 1. Open() patch - CTRL-C to retry",10,0
PreLockRemFailed:	dc.b "Can't remove 1. Lock() patch - CTRL-C to retry",10,0
AfterLoadSegRemFailed:	dc.b "Can't remove 2. LoadSeg() patch - CTRL-C to retry",10,0
AfterOpenRemFailed:	dc.b "Can't remove 2. Open() patch - CTRL-C to retry",10,0
AfterLockRemFailed:	dc.b "Can't remove 2. Lock() patch - CTRL-C to retry",10,0
ReturnText:	dc.b 10,0
FailedText:	dc.b "		FAILED",0
SuccessfulText:	dc.b "		OK",0
LoadSegText:	dc.b "Loadseg    : ",0
OpenText:	dc.b "Open       : ",0
LockText:	dc.b "Lock       : ",0

	even

NPatchStructPreLoadSeg:
	dc.l PreLoadSeg
	dc.l 0
	dc.l DosName
	dc.w 0
	dc.w LoadSeg
	dc.w 1
	dc.w 0
	dc.l 0
	dc.l 0

NPatchStructPreOpen:
	dc.l PreOpen
	dc.l 0
	dc.l DosName
	dc.w 0
	dc.w Open
	dc.w 1
	dc.w 0
	dc.l 0
	dc.l 0

NPatchStructPreLock:
	dc.l PreLock
	dc.l 0
	dc.l DosName
	dc.w 0
	dc.w Lock
	dc.w 1
	dc.w 0
	dc.l 0
	dc.l 0


NPatchStructAfterLoadSeg:
	dc.l AfterLoadSeg
	dc.l 0
	dc.l DosName
	dc.w 0
	dc.w LoadSeg
	dc.w -1
	dc.w 0
	dc.l 0
	dc.l 0

NPatchStructAfterOpen:
	dc.l AfterOpen
	dc.l 0
	dc.l DosName
	dc.w 0
	dc.w Open
	dc.w -1
	dc.w 0
	dc.l 0
	dc.l 0

NPatchStructAfterLock:
	dc.l AfterLock
	dc.l 0
	dc.l DosName
	dc.w 0
	dc.w Lock
	dc.w -1
	dc.w 0
	dc.l 0
	dc.l 0
	END
