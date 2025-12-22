*****
****
***			G E N E R A L   routines for   P O W E R V I S O R
**
*				Version 1.42
**				Wed Dec 23 17:21:00 1992
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

			INCLUDE	"pv.general.i"
			INCLUDE	"pv.eval.i"
			INCLUDE	"pv.debug.i"
			INCLUDE	"pv.screen.i"

			INCLUDE	"pv.errors.i"

	XDEF		GeneralConstructor,GeneralDestructor
	XDEF		RoutRemHand,RoutOpenDev,RoutCloseDev,RoutDevCmd,RoutRBlock
	XDEF		RoutWBlock,RoutRegs,RoutLoad,RoutSave,RoutRemRes
	XDEF		RoutRemove,RoutCurDir,RoutPathName,RoutUnLock,RoutCloseWindow
	XDEF		RoutCloseScreen,RoutTaskPri,RoutHunks,RoutDevInfo
	XDEF		RoutAddFunc,RoutRemFunc,RoutAccount,ProfDNode
	XDEF		RoutLoadFd,RoutUnLoadFd,RoutRemCrash,RoutLibInfo
	XDEF		RoutFreeze,RoutUnFreeze,RoutKill,RoutGo,StringToLib
	XDEF		OldSwitch,DumpRegs,CrashSigBit,InstallDevice
	XDEF		AllocSignal,SizeLock,Port,RemoveDevice,Crashes,FunctionsMon
	XDEF		DumpRegsNL,RealThisTask,ConstructPath,CallLibFunc
	XDEF		FDFiles,Freezed,CrashSignal,CheckAddTaskPatch
	XDEF		SearchCrashedTask,RemoveCrashDirect
	XDEF		CommonDR,PlaySound,MMUType,RoutLibFunc,PortName,PortNameEnd
	XDEF		AccountBlock,GeneralBase,PatchAddTask,UnpatchAddTask
	XDEF		StackFailL,RoutSPrint,CheckStack,AddPAddress
	XDEF		RoutResident,RoutUnResident,RoutStack,TimerSignal,CheckTimer
	XDEF		FuncGetStack,RoutFRegs,TrackAlloc,TrackFree,RoutTrack
	XDEF		RemoveException,RoutCrash,RoutFloat,GetTaskE,RoutProf
	XDEF		p68020,FuncCheckSum

	;main
	XREF		IntBase,InputRequestB,ErrorRoutine,Storage,PVCallTable
	XREF		DosBase,ArpBase,RoutGo2,Dummy,CheckModeBit
	XREF		FastFPrint,CreatePort,DeletePort,DOS2,RefreshNum
	XREF		PVBase,LastError,HandleError,GetError,Gfxbase
	XREF		Forbid,Permit,Disable,Enable,FrontSigSet
	XREF		BreakTaskPtr,MasterPV
	;eval
	XREF		Evaluate,EvaluateE,GetNextType,GetStringE,GetString,LongToDec,SkipSpace
	XREF		CompareCI,SearchWord,ParseDec,Upper,VarStorage,ParseName
	XREF		SearchWordEx,GetRestLinePer,GetNextByteE,ScanOptions
	;memory
	XREF		AllocClear,StoreRC,FreeBlock,MemoryPointer,AddString
	XREF		ReAllocMem,FlashRed,MakeNodeInt,AllocBlockInt,AppendMem
	XREF		AddPointerAlloc,RemPointerResident,AddPointerResident,ResidentPtr
	XREF		ViewPrintLine,BinarySearch,InsertMem,RemPointerAlloc
	XREF		AllocMem,FreeMem,ReAlloc,AddAutoClear
	;screen
	XREF		PrintHex,PrintLine,PrintAC,NewLine,FuncKey,PrintCold,MyScreen
	XREF		Print,SpecialPrint
	;list
	XREF		Print1Task,HeaderMsgPort,Print1MsgPort,IOReqInfoList,ListItem
	XREF		GetNextList,HeaderCrash,Print1Crashed,SetList,ResetList
	XREF		ApplyCommandOnList
	;debug
	XREF		InTaskWait,m68881,SymbolVicinity,GetSymbolStr
	XREF		BackFromSignal,DebugSigSet,SkipStackFrame
	;file
	XREF		FOpen,FReadLine,FClose,OpenDos
	;mmu
	XREF		GetMMUType,OriginalPC,FlushCache,FExt2Asc,FAsc2Ext


;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

; For software delay loops - Try 0 for 68000, 2 for 68020, 3 for 68030
PROSPEED		equ	0
SDELAY		equ	(64<<PROSPEED)

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	super

	;***
	;Constructor: init everything for general
	;-> flags is eq if error
	;***
GeneralConstructor:
		lea		(Crashes,pc),a0
		NEWLIST	a0
		lea		(FDFiles,pc),a0
		NEWLIST	a0
		lea		(Freezed,pc),a0
		NEWLIST	a0
		lea		(FunctionsMon,pc),a0
		NEWLIST	a0
		clr.l		(LN_NAME,a0)
		lea		(CrashSBNum,pc),a2
		bsr		AllocSignal
	;Compute this task
		movea.l	(SysBase).w,a6
		lea		(RealThisTask,pc),a0
		move.l	(ThisTask,a6),(a0)
		movea.l	(a0),a1
		moveq		#4,d0
		CALL		SetTaskPri
		lea		(OldPri,pc),a0
		move.b	d0,(a0)
		bsr		InstallException
	;Compute stack bound for PowerVisor
		movea.l	(RealThisTask,pc),a0
		move.l	(TC_SPLOWER,a0),d0
		addi.l	#512,d0				;We don't allow less than 512 bytes on stack
		lea		(StackBound,pc),a0
		move.l	d0,(a0)

		movea.l	(SysBase).w,a6
		move.w	(AttnFlags,a6),d0
		btst		#AFB_68020,d0
		beq.b		1$
	;68020, 68030 or 68040 processor
		moveq		#1,d0
		move.w	d0,(p68020)
	;MMU present ?
1$		bsr		GetMMUType
		lea		(MMUType,pc),a0
		move.l	d0,(a0)
		bsr		InitPort
		bsr		CheckAddTaskPatch
		moveq		#1,d0
		rts

	;***
	;Destructor: remove everything for general
	;***
GeneralDestructor:
		move.l	(TrackTask,pc),d0
		beq.b		3$
		bsr		TrackUnPatch
		bsr		TrackAllFree

3$		move.b	(OldPri,pc),d0
		movea.l	(RealThisTask,pc),a1
		CALLEXEC	SetTaskPri
		lea		(STimerRequest,pc),a2
		bsr		RemoveTimer
		lea		(PTimerRequest,pc),a2
		bsr		RemoveTimer
		bsr		RemoveException
		bsr		RemovePort
*		bsr		RemoveFDFiles
		bsr		RemoveFuncMons
*		bsr		RemoveCrashes
*		bsr		ClearProfilingTables
		bsr		Forbid
		movea.l	(SysBase).w,a6
		lea		(OldSwitch,pc),a0
		tst.l		(a0)
		beq.b		1$
		movea.l	a6,a1
		movea.l	#_LVOSwitch,a0
		move.l	(OldSwitch,pc),d0
		CALL		SetFunction
1$		bsr		Permit
		move.l	(CrashSBNum,pc),d0
		CALL		FreeSignal
*	;Free account block
*		move.l	(AccountBlock,pc),d0
*		beq.b		2$
*		movea.l	d0,a0
*		bsr		FreeBlock
2$		rts

	;***
	;Check stack
	;This routine preserves all registers
	;-> if flags equal to 'lt' then the stack overflow is close
	;***
CheckStack:
		move.l	a0,-(a7)
		movea.l	(SysBase).w,a0
		movea.l	(ThisTask,a0),a0
		cmpa.l	(RealThisTask,pc),a0
		movea.l	(a7)+,a0				;For flags
		bne.b		1$

	;Yes, we are PowerVisor
		cmpa.l	(StackBound,pc),a7
		rts

	;No, we are not PowerVisor
1$		moveq		#1,d0					;Reset lt flag
		rts

	;***
	;Init our port
	;***
InitPort:
		lea		(Port,pc),a1
		move.l	(RefreshNum),d0
		move.b	d0,(MP_SIGBIT,a1)
		clr.b		(LN_PRI,a1)
		move.b	#NT_MSGPORT,(LN_TYPE,a1)
		lea		(PortName,pc),a0
		move.l	a0,(LN_NAME,a1)
		move.l	(RealThisTask,pc),(MP_SIGTASK,a1)
		move.b	#PA_SIGNAL,(MP_FLAGS,a1)
		CALLEXEC	AddPort
		lea		(Port,pc),a1
		clr.w		(mp_BreakWanted,a1)	;There is no break
		move.l	#PVCallTable,(mp_CallTable,a1)
		rts

	;***
	;Remove our port
	;***
RemovePort:
		lea		(Port,pc),a1
		moveq		#0,d0
		move.b	(MP_SIGBIT,a1),d0
		CALLEXEC	FreeSignal
		lea		(Port,pc),a1
		CALL		RemPort
		rts

*	;***
*	;Remove all FDFile nodes
*	;***
*RemoveFDFiles:
*		lea		(FDFiles,pc),a2
*		movea.l	(a2),a2				;Succ
*		tst.l		(a2)					;Succ
*		beq.b		1$
*		move.l	a2,d0
*		bsr		UnLoadFdDirect
*		bra.b		RemoveFDFiles
*1$		rts

	;***
	;Remove all FuncMon nodes
	;***
RemoveFuncMons:
		lea		(FunctionsMon,pc),a2
		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		1$
		move.l	a2,d0
		bsr		RemFuncDirect
		bra.b		RemoveFuncMons
1$		rts

*	;***
*	;Remove all crashed tasks
*	;***
*RemoveCrashes:
*		lea		(Crashes,pc),a2
*		movea.l	(a2),a2				;Succ
*		tst.l		(a2)					;Succ
*		beq.b		1$
*		move.l	a2,d0
*		bsr		RemoveCrashDirect
*		bra.b		RemoveCrashes
*1$		rts

	;***
	;Install exception handler
	;***
InstallException:
		movea.l	(RealThisTask,pc),a0
		lea		(PVTrapCode,pc),a1
		move.l	a1,(TC_TRAPCODE,a0)

		move.b	(MasterPV),d0
		bne.b		1$
		rts

1$		movea.l	(SysBase).w,a6
		lea		(ExecTrapCode,pc),a0
		move.l	(TaskTrapCode,a6),(a0)
		lea		(TrapCode,pc),a1
		move.l	a1,(TaskTrapCode,a6)
	;Patch Alert and AutoRequest function
		bsr		Forbid
		movea.l	a6,a1
		lea		(AlertRoutine,pc),a0
		move.l	a0,d0
		movea.l	#_LVOAlert,a0
		CALL		SetFunction
		lea		(OldAlert,pc),a0
		move.l	d0,(a0)
		movea.l	(IntBase),a1
		lea		(AutoRequestPatch,pc),a0
		move.l	a0,d0
		movea.l	#_LVOAutoRequest,a0
		CALL		SetFunction
		lea		(OldAutoRequest,pc),a0
		move.l	d0,(a0)
		lea		(AutoRequestPatch,pc),a0
		move.l	d0,(ToAutoRequestJmp+2,a0)
		bra		Permit

	;***
	;Get a task
	;a0 = cmdline
	;-> d0 = pointer to task (with flags)
	;***
GetTaskE:
		moveq		#I_TASK,d6
		bsr		SetList
		EVALE
		bsr		ResetList
		tst.l		d0
		rts

	;***
	;Patch addtask function according to mode bit
	;***
CheckAddTaskPatch:
		moveq		#mo_Patch,d0
		bsr		CheckModeBit
		beq.b		UnpatchAddTask
	;Fall through

	;***
	;Patch addtask function
	;***
PatchAddTask:
		move.b	(MasterPV),d0
		beq.b		1$

		movea.l	(SysBase).w,a6
		move.l	(OldAddTask,pc),d0
		bne.b		1$
		bsr		Forbid
		movea.l	a6,a1
		lea		(AddTaskRoutine,pc),a0
		move.l	a0,d0
		movea.l	#_LVOAddTask,a0
		CALL		SetFunction
		lea		(OldAddTask,pc),a0
		move.l	d0,(a0)
		lea		(JumpAddTask+2,pc),a0
		move.l	d0,(a0)
		bsr		Permit
1$		rts

	;***
	;Patch all tasks to the correct trapcode
	;***
RoutCrash:
		move.b	(MasterPV),d0
		ERROReq	NotAllowedForSlave

		bsr		GetTaskE
		beq.b		1$

	;A task is given
		movea.l	d0,a2
		bra.b		SetCrashRout

	;0 is given for all tasks
1$		bsr		Disable
		lea		(SetCrashRout,pc),a0
		moveq		#I_TASK,d0
		bsr		ApplyCommandOnList
		bra		Enable

	;Routine to patch one task
	;a2 = task
SetCrashRout:
		cmpa.l	(RealThisTask,pc),a2
		beq.b		1$
		movea.l	(SysBase).w,a6
		move.l	(TaskTrapCode,a6),(TC_TRAPCODE,a2)
1$		moveq		#1,d1
		rts

	;***
	;Unpatch addtask function
	;***
UnpatchAddTask:
		move.b	(MasterPV),d0
		beq.b		2$

		bsr		Forbid
		movea.l	(SysBase).w,a6
		move.l	(OldAddTask,pc),d0
		beq.b		1$
		movea.l	a6,a1
		movea.l	#_LVOAddTask,a0
		CALL		SetFunction
		lea		(OldAddTask,pc),a0
		clr.l		(a0)
1$		bsr		Permit
2$		rts

	;***
	;Remove exception handler
	;***
RemoveException:
		move.b	(MasterPV),d0
		bne.b		3$
		rts

3$		movea.l	(RealThisTask,pc),a0
		clr.l		(TC_TRAPCODE,a0)

		movea.l	(SysBase).w,a6
		bsr		Forbid
		move.l	(ExecTrapCode,pc),(TaskTrapCode,a6)
	;Remove Alert and AutoRequest patch
		move.l	(OldAlert,pc),d0
		beq.b		1$
		movea.l	a6,a1
		movea.l	#_LVOAlert,a0
		CALL		SetFunction
1$		move.l	(OldAutoRequest,pc),d0
		beq.b		2$
		movea.l	(IntBase),a1
		movea.l	#_LVOAutoRequest,a0
		CALL		SetFunction
2$		bsr		Permit
		bra		UnpatchAddTask

	;***
	;Play a sound. Routine from C. Scheppner
	;d0 = period
	;d1 = delay
	;
	; DebTones.asm and Sample calling program by C. Scheppner 
	; A debugging routine and macro - hits the audio hardware to make a tone
	; Can be useful when debugging drivers, devices, etc. without a terminal    
	; For debugging use only - does not arbitrate for audio channel
	;
	;***
PlaySound:
		lea		($dff000),a0
		move.w	d0,(aud0+ac_per,a0)

		moveq		#4,d0
		move.l	d0,(aud0+ac_ptr,a0)
		move.w	#8,(aud0+ac_len,a0)
		move.w	#16,(aud0+ac_vol,a0)
		move.w	#(DMAF_SETCLR+DMAF_AUD0+DMAF_MASTER),(dmacon,a0)

1$		move.l	#3200,d0

2$		subq.l	#1,d0
		bne.b		2$

		subq.l	#1,d1
		bne.b		1$

		clr.w		(aud0+ac_vol,a0)
		move.w	#DMAF_AUD0,(dmacon,a0)   ;turn off sound
		rts

	;***
	;Function: compute the checksum for a region of memory
	;***
FuncCheckSum:
		bsr		EvaluateE			;Get address
		bclr		#0,d0
		bclr		#1,d0					;Make longword alligned
		movea.l	d0,a2
		bsr		EvaluateE			;Get number of bytes
		addq.w	#3,d0
		lsr.w		#2,d0					;Make number of longwords
		moveq		#0,d1
1$		add.l		(a2)+,d1
		dbra		d0,1$
		move.l	d1,d0
		rts

	;***
	;Control the resource tracker
	;***
RoutTrack:
		move.b	(MasterPV),d0
		ERROReq	NotAllowedForSlave

		bsr		GetNextByteE
		move.l	a0,-(a7)
		lea		(OptTrackStr,pc),a0
		lea		(OptTrackRout,pc),a1
		bsr		ScanOptions
		movea.l	(a7)+,a0
		jmp		(a1)
ErrorTRK:
		ERROR		UnknownTrackArg

	;Take a task or process and start tracking for that task
TakeTRK:
		move.l	(TrackTask,pc),d0
		ERRORne	AlreadyTracking
		bsr		GetTaskE
		lea		(TrackTask,pc),a0
		move.l	d0,(a0)
		bra		TrackPatch

	;Stop the tracker, no memory is freed
StopTRK:
		move.l	(TrackTask,pc),d0
		ERROReq	NotTracking
		bsr		TrackUnPatch
		bsr		TrackAllFree
		lea		(TrackTask,pc),a0
		clr.l		(a0)
		rts

	;Stop the tracker and free all memory that was not freed by the
	;task
CleanupTRK:
		move.l	(TrackTask,pc),d0
		ERROReq	NotTracking

5$		move.l	(TrackFirst,pc),d0
2$		beq		1$
		movea.l	d0,a0
		move.b	(trk_Type,a0),d0
		cmp.b		#TRK_ALLOCMEM,d0
		beq.b		3$
		cmp.b		#TRK_ALLOCRAST,d0
		beq		10$
	IFD D20
		cmp.b		#TRK_ALLOCVEC,d0
		beq.b		4$
		cmp.b		#TRK_CREATEMP,d0
		beq.b		6$
		cmp.b		#TRK_CREATEIO,d0
		beq.b		7$
		cmp.b		#TRK_LOCK,d0
		beq.b		8$
		cmp.b		#TRK_OPEN,d0
		beq.b		9$
	ENDC
		move.l	(trk_Next,a0),d0
		bra.b		2$

	;Free AllocMem
3$		movea.l	(trk_Ptr,a0),a1
		move.l	(trk_Size,a0),d0
		CALLEXEC	FreeMem
		bra.b		5$

	IFD D20
	;Free AllocVec
4$		movea.l	(trk_Ptr,a0),a1
		CALLEXEC	FreeVec
		bra.b		5$
	;DeleteMsgPort
6$		movea.l	(trk_Ptr,a0),a0
		CALLEXEC	DeleteMsgPort
		bra.b		5$
	;DeleteMsgPort
7$		movea.l	(trk_Ptr,a0),a0
		CALLEXEC	DeleteIORequest
		bra.b		5$
	;UnLock
8$		move.l	(trk_Ptr,a0),d1
		CALLDOS	UnLock
		bra		5$
	;Close
9$		move.l	(trk_Ptr,a0),d1
		CALLDOS	Close
		bra		5$
	ENDC
	;AllocRast
10$	move.l	(trk_Size,a0),-(a7)
		movem.w	(a7)+,d0-d1
		movea.l	(trk_Ptr,a0),a0
		CALLGRAF	FreeRaster
		bra		5$

1$		bsr		TrackUnPatch
		bsr		TrackAllFree
		lea		(TrackTask,pc),a0
		clr.l		(a0)
		rts

	;List all memory allocated by the task
ListTRK:
		move.l	(TrackTask,pc),d0
		ERROReq	NotTracking
		bra		TrackShow

	;***
	;Patch AllocMem,FreeMem,OpenLibrary,CloseLibrary,AllocVec,FreeVec,
	;OldOpenLibrary,AllocSignal,FreeSignal
	;to use the track routines
	;***
TrackPatch:
		bsr		Disable
		movea.l	(SysBase).w,a6

	;Patch all library functions
		lea		(PatchRoutines,pc),a2

1$		move.l	(a2)+,d0				;Get offset
		beq		Enable				;Stop 'TrackPatch'
		movea.l	d0,a0
		move.l	(a2)+,d0				;Routine
		movea.l	(a2)+,a1				;Pointer to pointer to library
		movea.l	(a1),a1				;Library
		CALL		SetFunction
		movea.l	(a2)+,a0
		move.l	d0,(2,a0)
		bra.b		1$

	;***
	;Unpatch AllocMem,FreeMem,OpenLibrary,CloseLibrary,AllocVec,FreeVec,
	;OldOpenLibrary,AllocSignal,FreeSignal
	;***
TrackUnPatch:
		bsr		Disable
		movea.l	(SysBase).w,a6

	;First check if the patches are removable
		lea		(PatchRoutines,pc),a2

1$		move.l	(a2)+,d0				;Get offset
		beq.b		2$
		move.l	(a2)+,d1				;Get routine
		movea.l	(a2)+,a1				;Get pointer to pointer to library
		movea.l	(a1),a1				;Library
		cmp.l		(2,a1,d0.l),d1
		bne.b		5$						;There is some routine patched
		lea		(4,a2),a2
		bra.b		1$

	;Ok, all patches are removable
2$		lea		(PatchRoutines,pc),a2

3$		move.l	(a2)+,d0				;Get offset
		beq.b		4$
		movea.l	d0,a0
		lea		(4,a2),a2			;Skip routine
		movea.l	(a2)+,a1				;Get pointer to pointer to library
		move.l	(a1),-(a7)			;Library
		movea.l	(a2)+,a1
		move.l	(2,a1),d0			;Old routine
		movea.l	(a7)+,a1				;Restore library
		CALL		SetFunction
		bra.b		3$

4$		bra		Enable

5$		bsr		Enable
		ERROR		FunctionPatched


	;***
	;Table with all routines to patch
	;<LVO offset>, <Patch routine>, <pointer to pointer to lib>, <Jump in patch>
	;***
PatchRoutines:
	;Exec
		dc.l		_LVOAllocMem,TrackAllocPatch,4,JumpAPatch
		dc.l		_LVOFreeMem,TrackFreePatch,4,JumpFPatch
		dc.l		_LVOOpenLibrary,TrackOpenLibPatch,4,JumpOLPatch
		dc.l		_LVOOldOpenLibrary,TrackOldOpenLibPatch,4,JumpOOLPatch
		dc.l		_LVOCloseLibrary,TrackCloseLibPatch,4,JumpCLPatch
		dc.l		_LVOAllocSignal,TrackAllocSigPatch,4,JumpASPatch
		dc.l		_LVOFreeSignal,TrackFreeSigPatch,4,JumpFSPatch
	IFD D20
		dc.l		_LVOAllocVec,TrackAllocVecPatch,4,JumpAVPatch
		dc.l		_LVOFreeVec,TrackFreeVecPatch,4,JumpFVPatch
		dc.l		_LVOCreateMsgPort,TrackCreateMPPatch,4,JumpCMPatch
		dc.l		_LVODeleteMsgPort,TrackDeleteMPPatch,4,JumpDMPatch
		dc.l		_LVOCreateIORequest,TrackCreateIOPatch,4,JumpCIPatch
		dc.l		_LVODeleteIORequest,TrackDeleteIOPatch,4,JumpDIPatch
	ENDC

	;Dos
	IFD D20
		dc.l		_LVOLock,TrackLockPatch,DosBase,JumpDLOPatch
		dc.l		_LVOUnLock,TrackUnLockPatch,DosBase,JumpDULPatch
		dc.l		_LVOOpen,TrackOpenPatch,DosBase,JumpDOPPatch
		dc.l		_LVOClose,TrackClosePatch,DosBase,JumpDCLPatch
		dc.l		_LVOOpenFromLock,TrackOpenFLPatch,DosBase,JumpDOLPatch
		dc.l		_LVODupLock,TrackDupLockPatch,DosBase,JumpDDLPatch
		dc.l		_LVODupLockFromFH,TrackDupLockFPatch,DosBase,JumpDDFPatch
	ENDC

	;Graphics
		dc.l		_LVOAllocRaster,TrackAllocRPatch,Gfxbase,JumpGARPatch
		dc.l		_LVOFreeRaster,TrackFreeRPatch,Gfxbase,JumpGFRPatch

		dc.l		0

	;***
	;Patch routine for AllocRaster
	;***
TrackAllocRPatch:
		movem.w	d0-d1,-(a7)
JumpGARPatch:
		jsr		($00000000).l
		move.l	(a7)+,d1

		pea		(TRK_ALLOCRAST).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for FreeRaster
	;***
TrackFreeRPatch:
		move.l	a0,-(a7)
JumpGFRPatch:
		jsr		($00000000).l
		moveq		#TRK_ALLOCRAST,d1
		bra		UnregAlloc

	IFD D20

	;***
	;Patch routine for DupLockFromFH
	;***
TrackDupLockFPatch:
JumpDDFPatch:
		jsr		($00000000).l
		bra.b		RegNewLock

	;***
	;Patch routine for DupLock
	;***
TrackDupLockPatch:
JumpDDLPatch:
		jsr		($00000000).l

RegNewLock:
	;Register new Lock
		pea		(TRK_LOCK).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for Lock
	;***
TrackLockPatch:
JumpDLOPatch:
		jsr		($00000000).l
		bra.b		RegNewLock

	;***
	;Patch routine for OpenFromLock
	;***
TrackOpenFLPatch:
		move.l	d1,-(a7)
JumpDOLPatch:
		jsr		($00000000).l

	;Register Open
		move.l	(a7)+,d1				;We do this, because otherwise the PC
											;will not be correctly registers
		pea		(TRK_OPEN).w
		bsr		AllocPRout			;Must be 'bsr'!
		move.l	d1,-(a7)

	;Unregister Lock
		tst.l		d0
		beq.b		1$

		moveq		#TRK_LOCK,d1
		bra		UnregAlloc

1$		move.l	(a7)+,d1
		rts

	;***
	;Patch routine for UnLock
	;***
TrackUnLockPatch:
		move.l	d1,-(a7)
JumpDULPatch:
		jsr		($00000000).l
		moveq		#TRK_LOCK,d1
		bra		UnregAlloc

	;***
	;Patch routine for Open
	;***
TrackOpenPatch:
JumpDOPPatch:
		jsr		($00000000).l
		pea		(TRK_OPEN).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for Close
	;***
TrackClosePatch:
		move.l	d1,-(a7)
JumpDCLPatch:
		jsr		($00000000).l
		moveq		#TRK_OPEN,d1
		bra		UnregAlloc
	ENDC

	;***
	;Patch routine for CreateMsgPort
	;***
TrackCreateMPPatch:
JumpCMPatch:
		jsr		($00000000).l
		moveq		#0,d1					;No extra argument
		pea		(TRK_CREATEMP).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for DeleteMsgPort
	;***
TrackDeleteMPPatch:
		move.l	a0,-(a7)
JumpDMPatch:
		jsr		($00000000).l
		moveq		#TRK_CREATEMP,d1
		bra		UnregAlloc

	;***
	;Patch routine for CreateIORequest
	;***
TrackCreateIOPatch:
		move.l	d0,-(a7)
JumpCIPatch:
		jsr		($00000000).l
		move.l	(a7)+,d1
		pea		(TRK_CREATEIO).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for DeleteIORequest
	;***
TrackDeleteIOPatch:
		move.l	a0,-(a7)
JumpDIPatch:
		jsr		($00000000).l
		moveq		#TRK_CREATEIO,d1
		bra		UnregAlloc

	;***
	;Patch routine for FreeSignal
	;***
TrackFreeSigPatch:
		move.l	d0,-(a7)
JumpFSPatch:
		jsr		($00000000).l
		movea.l	(a7)+,a1

		cmpa.l	#-1,a1				;From V37 on, freeing -1 is harmless
		beq.b		1$

	;Unregister signal
		movem.l	d1/a0/a6,-(a7)
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0	;Task
		cmpa.l	(TrackTask,pc),a0
		bne.b		2$
	;Ok, we are the right task
		moveq		#TRK_ALLOCSIG,d1
		bsr		TrackFree
2$		movem.l	(a7)+,d1/a0/a6

1$		rts

	;***
	;Patch routine for AllocSignal
	;***
TrackAllocSigPatch:
		move.l	d0,-(a7)
JumpASPatch:
		jsr		($00000000).l
		move.l	(a7)+,d1

		cmp.l		#-1,d0				;Test for failure
		beq.b		1$
		pea		(TRK_ALLOCSIG).w
		bsr.b		AllocPRoutNoTest	;Must be 'bsr'!
1$		rts

	;***
	;Patch routine for AllocMem
	;***
TrackAllocPatch:
		move.l	d0,-(a7)
JumpAPatch:
		jsr		($00000000).l
		move.l	(a7)+,d1

		pea		(TRK_ALLOCMEM).w
		bsr.b		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Subroutine for 'TrackAllocPatch', 'TrackAllocVecPatch' and 'TrackOpenLibPatch'
	;d0 = address (or 0 if previous allocation had no success, or signal number)
	;d1 = size of region (or version for OpenLibrary, signal for AllocSignal)
	;Stack points to type of allocation (TRK_xxx) (after return, this
	;value will no longer be on the stack)
	;(this routine MUST be called with 'bsr' or 'jsr')
	;This routine preserves all registers
	;***
AllocPRout:
		tst.l		d0
		beq.b		TheEndAPR

AllocPRoutNoTest:
		movem.l	d0-d1/a0-a1/a6,-(a7)

		movea.l	d0,a1					;Pointer (to memory or library) or signal number
		move.l	d1,d0					;Size (or version) or requested signal number
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0	;Task
		move.l	(8+5*4,a7),d1		;PC
		bsr		TrackAlloc
		movea.l	d0,a0
		beq.b		1$

		move.l	(4+5*4,a7),d0		;return address and four registers
		move.b	d0,(trk_Type,a0)

1$		movem.l	(a7)+,d0-d1/a0-a1/a6

TheEndAPR:
		move.l	(a7),(4,a7)			;Move return address
		lea		(4,a7),a7
		rts

	;***
	;Patch routine for FreeMem
	;***
TrackFreePatch:
		move.l	a1,-(a7)
JumpFPatch:
		jsr		($00000000).l
		moveq		#TRK_ALLOCMEM,d1

	;This label is also called by the patch routine for FreeVec and DeleteMsgPort
	;This routine preserves d0
	;Must be called with 'bra' or 'jmp'!
UnregAlloc:
		movea.l	(a7)+,a1
		cmpa.l	#0,a1
		beq.b		1$

	;Unregister allocation
		movem.l	a0/a6,-(a7)
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0	;Task
		bsr		TrackFree
		movem.l	(a7)+,a0/a6

1$		rts

 IFD D20
	;***
	;Patch routine for AllocVec
	;***
TrackAllocVecPatch:
		move.l	d0,-(a7)
JumpAVPatch:
		jsr		($00000000).l
		move.l	(a7)+,d1

		pea		(TRK_ALLOCVEC).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for FreeVec
	;***
TrackFreeVecPatch:
		move.l	a1,-(a7)
JumpFVPatch:
		jsr		($00000000).l
		moveq		#TRK_ALLOCVEC,d1
		bra.b		UnregAlloc
 ENDC

	;***
	;Patch routine for OpenLibrary
	;***
TrackOpenLibPatch:
		move.l	d0,-(a7)
JumpOLPatch:
		jsr		($00000000).l
		move.l	(a7)+,d1

		pea		(TRK_OPENLIB).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for OldOpenLibrary
	;***
TrackOldOpenLibPatch:
JumpOOLPatch:
		jsr		($00000000).l
		moveq		#0,d1					;Version is 0

		pea		(TRK_OPENLIB).w
		bsr		AllocPRout			;Must be 'bsr'!
		rts

	;***
	;Patch routine for CloseLibrary
	;***
TrackCloseLibPatch:
		move.l	a1,-(a7)
JumpCLPatch:
		jsr		($00000000).l
		movea.l	(a7)+,a1
		cmpa.l	#0,a1
		beq.b		1$

	;Unregister opening
		movem.l	d1/a0/a6,-(a7)
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0	;Task
		cmpa.l	(TrackTask,pc),a0
		bne.b		2$
	;Ok, we are the right task
		moveq		#TRK_OPENLIB,d1
		bsr		TrackFree
2$		movem.l	(a7)+,d1/a0/a6

1$		rts

	;***
	;Track an allocation (This routine preserves ALL registers except d0)
	;a0 = pointer to task
	;a1 = pointer to memory
	;d0 = size
	;d1 = PC
	;-> d0 = pointer to new track structure (or 0) (flags)
	;***
TrackAlloc:
		movem.l	d0-d1/a0-a1/a6,-(a7)
		moveq		#0,d0
		cmpa.l	(TrackTask,pc),a0
		bne.b		1$
	;Ok, we are the right task
		moveq		#trk_SIZE,d0
		move.l	#MEMF_CLEAR,d1
		movea.l	(SysBase).w,a6
		movea.l	(JumpAPatch+2,pc),a0
		jsr		(a0)					;Should be equivalent to AllocMem (we bypass
											;our patch)
		tst.l		d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(12,a7),(trk_Ptr,a0)
		move.l	(a7),(trk_Size,a0)
		move.l	(4,a7),(trk_PC,a0)
		lea		(TrackFirst,pc),a1
		move.l	(a1),(trk_Next,a0)
		move.l	a0,(a1)
		move.l	(trk_Next,a0),d1
		beq.b		1$
		movea.l	d1,a1
		move.l	a0,(trk_Prev,a1)
1$		move.l	d0,(a7)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		tst.l		d0
		rts

	;***
	;Track a free (This routine preserves ALL registers)
	;a0 = pointer to task
	;a1 = pointer to memory (or library, or signal number)
	;d1 = track type (TRK_???)
	;***
TrackFree:
		movem.l	d0-d1/a0-a1/a6,-(a7)
		move.l	(TrackFirst,pc),d0
		beq.b		1$
2$		movea.l	d0,a0
		cmp.b		(trk_Type,a0),d1
		bne.b		3$						;Not the right type
		cmpa.l	(trk_Ptr,a0),a1
		bne.b		3$						;Not the right value

	;Found !
		move.l	(trk_Next,a0),d0
		beq.b		4$
	;There is a next element
		movea.l	d0,a1
		move.l	(trk_Prev,a0),(trk_Prev,a1)
4$		move.l	(trk_Prev,a0),d0
		beq.b		5$
	;There is a prev element
		movea.l	d0,a1
		move.l	(trk_Next,a0),(trk_Next,a1)
		bra.b		6$
	;There is no prev element
5$		lea		(TrackFirst,pc),a1
		move.l	(trk_Next,a0),(a1)
6$		movea.l	a0,a1
		moveq		#trk_SIZE,d0
		movea.l	(SysBase).w,a6
		movea.l	(JumpFPatch+2,pc),a0
		jsr		(a0)					;Should be equivalent to FreeMem (we bypass
											;our patch)
		bra.b		1$

	;Not yet
3$		move.l	(trk_Next,a0),d0
		bne.b		2$

1$		movem.l	(a7)+,d0-d1/a0-a1/a6
		rts

	;***
	;Free all resource tracking information
	;***
TrackAllFree:
		move.l	(TrackFirst,pc),d0
		beq.b		1$
		movea.l	d0,a1
		move.b	(trk_Type,a1),d1
		movea.l	(trk_Ptr,a1),a1
		movea.l	(TrackTask,pc),a0
		bsr		TrackFree
		bra.b		TrackAllFree
1$		rts

	;***
	;Show all resource tracking information
	;***
TrackShow:
		move.l	(TrackFirst,pc),d0
		bne.b		2$
		rts
	;Scan the track list to the last element
	;We do this because we want to print the list in reverse (to
	;preserve the chronological order of allocation)
2$		movea.l	d0,a1
		move.l	(trk_Next,a1),d0
		bne.b		2$
	;a1 points to last track structure

3$		move.b	(trk_Type,a1),d0
		cmpi.b	#TRK_ALLOCSIG,d0
		beq.b		7$
		cmpi.b	#TRK_ALLOCMEM,d0
		beq.b		4$
		cmpi.b	#TRK_ALLOCRAST,d0
		beq.b		12$
 IFD D20
		cmpi.b	#TRK_ALLOCVEC,d0
		beq.b		6$
		cmpi.b	#TRK_CREATEMP,d0
		beq.b		8$
		cmpi.b	#TRK_CREATEIO,d0
		beq.b		9$
		cmpi.b	#TRK_LOCK,d0
		beq.b		10$
		cmpi.b	#TRK_OPEN,d0
		beq.b		11$
 ENDC

		movea.l	(trk_Ptr,a1),a0		;OpenLib
		movea.l	(LN_NAME,a0),a0
		bra.b		21$

	IFD D20
10$	movea.l	#_LVONameFromLock,a2	;Lock
		bsr.b		NameFromXXX
		lea		(MesLock,pc),a0
		moveq		#TRK_LOCK,d0
		FMTSTR	08lx,col,08lx,sep,s,spc,s,nl
		bra.b		22$

11$	movea.l	#_LVONameFromFH,a2	;Open
		bsr.b		NameFromXXX
		lea		(MesOpen,pc),a0
		moveq		#TRK_OPEN,d0
		FMTSTR	08lx,col,08lx,sep,s,spc,s,nl
		bra.b		22$

8$		lea		(MesCreateMP,pc),a0	;CreateMsgPort
		bra.b		21$

6$		lea		(MesAllocVec,pc),a0	;AllocVec
		bra.b		21$

9$		lea		(MesCreateIO,pc),a0	;CreateIORequest
		bra.b		21$
	ENDC

4$		lea		(MesAllocMem,pc),a0	;AllocMem
		bra.b		21$

7$		lea		(MesAllocSig,pc),a0	;AllocSignal
		bra.b		21$

12$	lea		(MesAllocR,pc),a0		;AllocRast

	;Show normal three hex format
	;a0 = string
	;d0 = type
	;a1 = trk structure
21$	FMTSTR	08lx,col,08lx,sep,08lx,spc,s,nl
	;Show two hex and one string format
22$	GETFMT	l,trk_PC,l,trk_Ptr,l,trk_Size,l,trk_Type
		move.l	a0,(trk_Type,a1)
		bsr		SpecialPrint
		move.b	d0,(trk_Type,a1)

	;Go to next track structure
5$		movea.l	(trk_Prev,a1),a1
		move.l	a1,d0
		bne		3$
		rts

	IFD D20
	;Subroutine:
	;get the name for a lock or a filehandle
	;a1 = track structure
	;a2 = offset NameFromLock or NameFromFH
NameFromXXX:
		move.l	a1,-(a7)
		move.l	(trk_Ptr,a1),d1
		move.l	(Storage),d2
		add.l		#100,d2				;Because SpecialPrint also uses 'Storage'
		move.l	d2,(trk_Size,a1)
		moveq		#60,d3
		movea.l	(DosBase),a6
		jsr		(a6,a2.l)
		movea.l	(a7)+,a1
		rts
	ENDC

	;***
	;Command: remove an input handler
	;***
RoutRemHand:
		moveq		#I_INPUTH,d6
		bsr		SetList
		EVALE								;Get interrupt structure
		movea.l	d0,a5
		moveq		#IOSTD_SIZE,d0
		suba.l	d0,a7
		movea.l	a7,a1
		movea.l	(InputRequestB),a0
		CALLEXEC	CopyMem
		movea.l	a7,a1
		move.w	#IND_REMHANDLER,(IO_COMMAND,a1)
		move.l	a5,(IO_DATA,a1)
		CALLEXEC	DoIO
		lea		(IOSTD_SIZE,a7),a7
		moveq		#0,d0
		rts

	;***
	;Command: print to the serial device
	;***
RoutSPrint:
		bsr		GetStringE
		movea.l	d0,a0
		bra		KPutStr

	;***
	;Command: install a profiler for a debug node
	;***
RoutProf:
		bsr		GetNextByteE
		move.l	a0,-(a7)
		lea		(OptProfStr,pc),a0
		lea		(OptProfRout,pc),a1
		bsr		ScanOptions
		movea.l	(a7)+,a0
		jmp		(a1)
ErrorPRF:
		ERROR		UnknownProfArg

	;Clear all profiling information
ClearPRF:
		lea		(ProfWait,pc),a0
		clr.l		(a0)+
		clr.l		(a0)
		bra		ClearProfilingTables

	;List all profiling information
ListPRF:
		lea		(MesWait,pc),a0
		PRINT
		move.l	(ProfWait,pc),d0
		PRINTHEX
		lea		(MesReady,pc),a0
		PRINT
		move.l	(ProfReady,pc),d0
		PRINTHEX
		NEWLINE

		lea		(ProfTableSize,pc),a5
		movea.l	(ProfTablePtr,pc),a4
		move.l	(a5),d7
		lsr.l		#3,d7
		beq.b		2$

		subq.l	#1,d7
		movea.l	(4,a5),a5

		movea.l	(ProfDNode,pc),a2
		cmpi.l	#'DBUG',(db_MatchWord,a2)
		beq.b		1$
		suba.l	a2,a2					;The corresponding debug node is gone

1$		move.l	(4,a5),-(a7)
		move.l	(a5),-(a7)
		lea		(DNodeGoneMsg,pc),a3
		move.l	a2,d0
		beq.b		3$

	;The debug node still exists
		move.l	(a5),d0
		bsr		GetSymbolStr
		beq.b		3$
		movea.l	a0,a3

3$		move.l	a3,-(a7)
		lea		(8,a5),a5
		move.l	(Storage),d0
		movea.l	a7,a1
		lea		(FormatProfile,pc),a0
		bsr		FastFPrint
		lea		(12,a7),a7
		bsr		ViewPrintLine
		NEWLINE
		dbra		d7,1$

2$		rts

	;Stop profiling
StopPRF:
		lea		(PTimerRequest,pc),a2
		move.l	(a2),d0
		ERROReq	NotProfiling
		bsr		AbortTimer
		bra		RemoveTimer

	;Start profiling
TakePRF:
		lea		(PTimerRequest,pc),a2
		move.l	(a2),d0
		ERRORne	AlreadyProfiling

		moveq		#I_DEBUG,d6
		bsr		SetList
		EVALE
		bsr		ResetList
		movea.l	d0,a3					;Debug node
		EVALE								;Get number of microseconds
		move.l	d0,d3

		bsr		InstallTimer
		ERROReq	OpenDevice

	;Set up profiler for task
	;a3 = task
	;d3 = timer value
		movea.l	(PTimerRequest,pc),a0
		clr.b		(LN_TYPE,a0)		;To prevent hang for CheckIO
		lea		(ProfDNode,pc),a1
		move.l	a3,(a1)
		lea		(ProfMicros,pc),a1
		move.l	d3,(a1)
		move.l	d3,d0
		bra		StartTimer

	;***
	;Clear the profiling tables
	;***
ClearProfilingTables:
		lea		(ProfTableSize,pc),a0
		moveq		#0,d0
		bra		ReAllocMem

	;***
	;Command: install a stackchecker for one task or process
	;***
RoutStack:
		move.l	a0,-(a7)
		lea		(STimerRequest,pc),a2
		move.l	(a2),d0
		beq.b		2$
		bsr		AbortTimer
		bsr		RemoveTimer
2$		movea.l	(a7)+,a0
		NEXTTYPE
		bne.b		1$

	;We remove everything, set StackTask to zero
		lea		(StackTask,pc),a0
		clr.l		(a0)
		rts

1$		bsr		GetTaskE
		movea.l	d0,a3					;Task
		EVALE								;Get number of microseconds
		move.l	d0,d3

	;First fill the stack with garbage
		bsr		Forbid
		movea.l	(TC_SPLOWER,a3),a0
		move.l	(TC_SPREG,a3),d0
		sub.l		a0,d0
		subq.l	#4,d0
		blt.b		4$
		move.l	#$62951413,d1

3$		move.l	d1,(a0)+
		subq.l	#4,d0
		bge.b		3$

4$		bsr		Permit

		bsr		InstallTimer
		ERROReq	OpenDevice

	;Set up stack monitor for task
	;a3 = task
	;d3 = timer value
		clr.l		(StackMax)
		movea.l	(STimerRequest,pc),a0
		clr.b		(LN_TYPE,a0)		;To prevent hang for CheckIO
		lea		(StackTask,pc),a1
		move.l	a3,(a1)
		lea		(StackMicros,pc),a1
		move.l	d3,(a1)
		move.l	d3,d0
		bra		StartTimer

	;***
	;Compute timer signals
	;-> d0 = signal bit mask (or 0 if no timer)
	;-> All registers except d0 are preserved
	;***
TimerSignal:
		movem.l	d1/a2,-(a7)
		lea		(STimerRequest,pc),a2
		bsr.b		OneTimerSignal
		move.l	d0,d1
		lea		(PTimerRequest,pc),a2
		bsr.b		OneTimerSignal
		or.l		d1,d0
		movem.l	(a7)+,d1/a2
		rts

	;a2 = pointer to pointer to timer request
OneTimerSignal:
		movem.l	d1/a0,-(a7)
		move.l	(4,a2),d0
		beq.b		1$
		movea.l	d0,a0
		moveq		#0,d1
		move.b	(MP_SIGBIT,a0),d1
		moveq		#1,d0
		lsl.l		d1,d0
1$		movem.l	(a7)+,d1/a0
		rts

	;***
	;Abort IO
	;a2 = pointer to pointer to timer request
	;-> a2 = unchanged
	;***
AbortTimer:
		movea.l	(a2),a1
		CALLEXEC	CheckIO
		tst.l		d0
		bne.b		1$
		movea.l	(a2),a1
		CALL		AbortIO
		movea.l	(a2),a1
		CALL		WaitIO
1$		rts

	;***
	;Restart the timer
	;d0 = microseconds for next signal
	;a2 = pointer to pointer to timer request
	;-> a2 = unchanged
	;***
StartTimer:
		movea.l	(a2),a1
		move.l	d0,(IOTV_TIME+TV_MICRO,a1)
		clr.l		(IOTV_TIME+TV_SECS,a1)

		move.w	#TR_ADDREQUEST,(IO_COMMAND,a1)
		CALLEXEC	SendIO
		rts

	;***
	;Check if one of the two timers has returned
	;This routine preserves all registers except a6
	;***
CheckTimer:
		movem.l	d0-d1/a0-a1,-(a7)

	;Check stack check timer
		move.l	(STimerRequest,pc),d0
		beq.b		2$
		movea.l	d0,a1
		CALLEXEC	CheckIO
		tst.l		d0
		beq.b		2$

		bsr.b		HandleSTimer

	;Check profile timer
2$		move.l	(PTimerRequest,pc),d0
		beq.b		1$
		movea.l	d0,a1
		CALLEXEC	CheckIO
		tst.l		d0
		beq.b		1$

		bsr		HandlePTimer

1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;There is a message from the stack check timer
	;***
HandleSTimer:
	;There is a message
		movea.l	(STimerRequest,pc),a1
		CALLEXEC	WaitIO

	;Perform checking
		movea.l	(StackTask,pc),a0
		move.l	(TC_SPLOWER,a0),d0
		add.l		(StackFailL,pc),d0	;We don't allow less than StackFailL bytes on stack
		move.l	(TC_SPREG,a0),d1
		cmp.l		d0,d1
		bge.b		2$
	;Stack overflow is close
		move.l	a0,-(a7)
		move.l	a0,d0
		move.l	a2,-(a7)
		bsr		FreezeTaskDirect
		movea.l	(a7)+,a2
		moveq		#ERR_PrgStackOvf,d0
		bsr		GetError
		bsr		PrintAC
		NEWLINE
		bsr		PrintLine
		movea.l	(a7)+,a0
		movem.l	a2/d2-d3,-(a7)
		movea.l	a0,a2
		bsr		Print1Task
		lea		(STimerRequest,pc),a2
		bsr		AbortTimer
		bsr		RemoveTimer
		movem.l	(a7)+,a2/d2-d3
		bra.b		1$

	;Nothing to worry about
2$		move.l	(TC_SPUPPER,a0),d0
		sub.l		d1,d0					;d0 = current stack usage
		move.l	(StackMax,pc),d1
		cmp.l		d0,d1
		bge.b		3$
	;New maximum
		lea		(StackMax,pc),a0
		move.l	d0,(a0)

	;Start a new timer
3$		move.l	a2,-(a7)
		lea		(STimerRequest,pc),a2
		bsr		AbortTimer
		move.l	(StackMicros,pc),d0
		bsr		StartTimer
		movea.l	(a7)+,a2

1$		rts

	;***
	;There is a message from the profile timer
	;***
HandlePTimer:
	;There is a message
		movea.l	(PTimerRequest,pc),a1
		CALLEXEC	WaitIO

	;Perform profiling
		movem.l	a2/a4,-(a7)

		movea.l	(ProfDNode,pc),a2
	;Check if we are executing. If the task is suspended by PowerVisor
	;we should not perform any profiling actions
		move.b	(db_Mode,a2),d0
		cmp.b		#DB_EXEC,d0
		bne.b		1$

		bsr		Disable
		movea.l	(db_Task,a2),a4
		move.b	(TC_STATE,a4),d0
		cmp.b		#TS_WAIT,d0
		bne.b		2$

	;Task is waiting (we don't check for symbol vicinity in this case, since
	;the task is doing nothing anyway)
		bsr		Enable
		lea		(ProfWait,pc),a0
		addq.l	#1,(a0)
		bra.b		1$

	;Task is ready
2$		lea		(ProfReady,pc),a0
		addq.l	#1,(a0)

		movea.l	(TC_SPREG,a4),a4
		bsr		SkipStackFrame
		move.l	(a4),d0
		bsr		Enable
		move.l	#10000,d1
		bsr		SymbolVicinity
		bsr		AddPAddress

1$		movem.l	(a7)+,a2/a4

	;Start a new timer
		move.l	a2,-(a7)
		lea		(PTimerRequest,pc),a2
		bsr		AbortTimer
		move.l	(ProfMicros,pc),d0
		bsr		StartTimer
		movea.l	(a7)+,a2

		rts

	;***
	;Add an address to the profiling table (sorted)
	;If the address already exists in the table, a counter is
	;incremented
	;d0 = address
	;-> d0 = 0 if error (flags)
	;***
AddPAddress:
		movem.l	a4/d2,-(a7)
		move.l	d0,d2					;Remember address
		lea		(ProfTableSize,pc),a0
		movea.l	#-8,a4
		tst.l		(a0)
		beq.b		8$

	;Yes there are already some entries in the table
		bsr		SearchPAddress
		bne.b		1$
		movea.l	a0,a4					;a4 = pointer to entry in table
		lea		(ProfTableSize,pc),a0
		suba.l	(4,a0),a4			;a4 now is pos in symboltable

8$		lea		(8,a4),a4
		move.l	a4,d0					;Offset to insert our new element
		moveq		#8,d1
		bsr		InsertMem
		beq.b		5$

	;Success, fill new entry
		movea.l	(ProfTablePtr,pc),a0
		lea		(0,a0,a4.l),a4		;Ptr to new entry place
		move.l	d2,(a4)+
		moveq		#1,d0
		move.l	d0,(a4)

5$		movem.l	(a7)+,a4/d2
		rts

	;There was already an entry for this address
	;Incremented the usage counter
	;a0 = pointer to entry in table
1$		addq.l	#1,(4,a0)
		moveq		#1,d0
		bra.b		5$

	;***
	;Search an address in the profiling table
	;d0 = address
	;-> d0 = number of times the address exists in the table (0 if not
	;			in the table) (flags)
	;-> a0 = pointer to entry in table after which we must include (if d0 == 0)
	;			or pointer to entry for address (if d0 > 0)
	;***
SearchPAddress:
		move.l	d0,-(a7)
		movea.l	d0,a0					;Value
		lea		(ProfTableSize,pc),a1
		move.l	(a1)+,d0				;Size
		movea.l	(a1),a1				;Ptr to start block
		moveq		#8,d1
		bsr		BinarySearch

		movea.l	d0,a0					;Pointer to entry in table
		move.l	(a7)+,d0				;Restore address

		cmpa.l	(ProfTablePtr,pc),a0
		blt.b		1$

		cmp.l		(a0),d0				;Compare with address we must have
		bne.b		1$

	;We have found an entry
		move.l	(4,a0),d0			;Get number of times
		rts

1$		moveq		#0,d0
		rts

	;***
	;Function: get max stack usage
	;***
FuncGetStack:
		move.l	(StackTask,pc),d0
		beq.b		1$
		bsr		Forbid

		movea.l	d0,a2
		movea.l	(TC_SPLOWER,a2),a0
		move.l	#$62951413,d0

2$		cmp.l		(a0)+,d0
		beq.b		2$

	;a0 points to first touch longword
		move.l	(TC_SPUPPER,a2),d0
		sub.l		a0,d0					;d0 = max stack usage

		bsr		Permit
		lea		(StackMax,pc),a0
		move.l	d0,(a0)
		rts

	;Use value stored in 'StackMax' if task has been removed
1$		move.l	(StackMax,pc),d0
		rts

	;***
	;Command: open a PV device
	;***
RoutOpenDev:
		EVALE								;Get ptr to name
		movea.l	d0,a2
		moveq		#0,d3					;Default unit number
		move.l	d3,d4					;Default flags
		NEXTARG	1$
		move.l	d0,d3					;Unit number
		NEXTARG	1$
		move.l	d0,d4					;Flags
1$		move.l	#256,d1
		move.l	d3,d0
		movea.l	a2,a0
		movea.l	d4,a1
		bsr		InstallDevice
		ERROReq	OpenDevice
		move.l	d0,d2					;IOR
		move.l	d1,d3					;Port
		moveq		#14,d0
		bsr		AllocClear
		beq.b		2$
		movea.l	d0,a0
		move.w	#14,(a0)+
		addq.l	#2,d0					;Make it a pv memblock
		move.l	d3,(a0)+				;Port
		move.l	d2,(a0)+				;IORequest
		move.l	#'PVDE',(a0)		;To recognize it
		PRINTHEX
		bra		StoreRC

2$		movea.l	d2,a1
		movea.l	d3,a0
		bsr		RemoveDevice
		HERR

	;***
	;Command: close a PV device
	;a0 = cmdline
	;***
RoutCloseDev:
		EVALE								;Get device block
		movea.l	d0,a1
		cmpi.l	#'PVDE',(8,a1)
		ERRORne	NotAPVDev
		move.l	a1,-(a7)
		movea.l	(a1)+,a0				;Get port
		movea.l	(a1),a1				;Get IORequest
		bsr		RemoveDevice
		movea.l	(a7)+,a0
		bra		FreeBlock

	;***
	;Command: give a PV device command
	;a0 = cmdline
	;***
RoutDevCmd:
		EVALE								;Get device block
		movea.l	d0,a1
		cmpi.l	#'PVDE',(8,a1)
		ERRORne	NotAPVDev
		movea.l	(4,a1),a4			;Get IORequest
		EVALE								;Get device cmd
		move.w	d0,(IO_COMMAND,a4)
		NEXTARG	1$
		move.b	d0,(IO_FLAGS,a4)
		NEXTARG	1$
		move.l	d0,(IO_LENGTH,a4)
		NEXTARG	1$
		move.l	d0,(IO_DATA,a4)
		NEXTARG	1$
		move.l	d0,(IO_OFFSET,a4)
1$		movea.l	a4,a1
		CALLEXEC	DoIO
		PRINTHEX
		bra		StoreRC

	;***
	;Command: read a block from disk
	;a0 = cmdline
	;***
RoutRBlock:
		EVALE								;Get unit number
		move.l	d0,d2
		EVALE								;Get block number
		move.l	d0,d3
		mulu.w	#1024,d3				;Calculate offset
		moveq		#0,d5					;Automatic
		NEXTARG	1$
		move.l	d0,d4					;Load to this position
		moveq		#1,d5					;Non automatic
		bra.b		2$
1$		move.l	#1026,d0
		move.l	#MEMF_CLEAR|MEMF_CHIP,d1
		bsr		AllocMem
		move.l	d0,d4
		ERROReq	NotEnoughMemory
		movea.l	d4,a0
		move.w	#1024,(a0)
		addq.l	#2,d4					;Make it a pv memblock
		move.l	d4,d0
		bsr		AddPointerAlloc
2$		bsr		InstallTrackDisk
		bne.b		3$
		tst.l		d5
		bne.b		4$
		movea.l	d4,a0
		bsr		FreeBlock
		bsr		RemPointerAlloc
4$		ERROR		OpenTrackDisk
3$		movea.l	d0,a1
		movea.l	d0,a2
		move.w	#CMD_READ,(IO_COMMAND,a1)
		clr.b		(IO_FLAGS,a1)
		move.l	#1024,(IO_LENGTH,a1)
		move.l	d4,(IO_DATA,a1)
		move.l	d3,(IO_OFFSET,a1)
		CALLEXEC	DoIO
		tst.l		d0
		beq.b		NoErrorRBL
ErrorRBL:
		bsr		RemoveTrackDisk
		tst.l		d5
		bne.b		1$
		movea.l	d4,a0
		bsr		FreeBlock
		bsr		RemPointerAlloc
1$		ERROR		DoIOError
NoErrorRBL:
		movea.l	a2,a1
		bsr		MotorOffRBL
		bsr		RemoveTrackDisk
		move.l	d4,d0
		PRINTHEX
		bra		StoreRC
MotorOffRBL:
		move.w	#TD_MOTOR,(IO_COMMAND,a1)
		clr.b		(IO_FLAGS,a1)
		clr.l		(IO_LENGTH,a1)
		CALL		DoIO
		rts

	;***
	;Command: write a block to disk
	;a0 = cmdline
	;***
RoutWBlock:
		EVALE								;Get unit number
		move.l	d0,d2
		EVALE								;Get block number
		move.l	d0,d3
		mulu.w	#1024,d3				;Calculate offset
		EVALE								;Get address (in chip ram)
		move.l	d0,d4
		bsr		InstallTrackDisk
		ERROReq	OpenTrackDisk
		movea.l	d0,a1
		movea.l	d0,a2
		move.w	#CMD_WRITE,(IO_COMMAND,a1)
		clr.b		(IO_FLAGS,a1)
		move.l	#1024,(IO_LENGTH,a1)
		move.l	d4,(IO_DATA,a1)
		move.l	d3,(IO_OFFSET,a1)
		moveq		#1,d5
		CALLEXEC	DoIO
		tst.l		d0
		bne		ErrorRBL
		movea.l	a2,a1
		move.w	#CMD_UPDATE,(IO_COMMAND,a1)
		CALL		DoIO
		movea.l	a2,a1
		bsr		MotorOffRBL
		bra		RemoveTrackDisk

	;***
	;Command: show the floatingpoint registers for a task
	;***
RoutFRegs:
		bsr		GetFPStackFrame
		beq.b		2$

	;a1 points to 8 12-byte registers
		GETFMT	_,0,l,0,l,4,l,8
		FMTSTR	_,_,08lx,spc,08lx,spc,08lx,col
		moveq		#7,d4					;Loop 8 times
3$		bsr		SpecialPrint
		bsr		PrintDouble
		lea		(12,a1),a1
		dbra		d4,3$

2$		rts

	;***
	;Command: fill a floatingpoint register with a value
	;***
RoutFloat:
		bsr		GetFPStackFrame
		beq.b		2$

		move.l	a1,-(a7)
		EVALE								;Get the number of the register (0..7)
		movea.l	(a7)+,a1
		cmp.w		#7,d0
		bgt.b		2$
		tst.l		d0
		blt.b		2$

		bsr		SkipSpace			;Skip spaces until floating point value
		mulu.w	#12,d0				;Three longwords for each floating point value
		adda.w	d0,a1					;Only word is significant in d0
		bsr		FAsc2Ext

2$		rts

	;***
	;Get a task or debug node from the commandline and return the
	;pointer to the stackframe
	;a0 = commandline
	;-> a0 = updated commandline
	;-> a1 = pointer to stackframe (or 0 if no fp, flags)
	;***
GetFPStackFrame:
		EVALE								;Get task or debug node
		movea.l	d0,a2
		cmpi.b	#NT_DEBUG,(LN_TYPE,a2)
		bne.b		1$

	;It is a debug node
		movea.l	(db_Task,a2),a2		;Get task

	;It is a task
1$		movea.l	(TC_SPREG,a2),a4

		move.l	(m68881,pc),d0
		beq.b		2$
		move.b	(a4),d0
		beq.b		2$
		addq.l	#2,a4
		lea		(12,a4),a1			;FPCR/FPSR/FPIAR
		move.l	a1,d0
		rts

	;The task has no fp
2$		suba.l	a1,a1
		move.l	a1,d0
		rts

	;***
	;Print the contents of a floating point register (double format)
	;(Uses 'Storage')
	;a1 = pointer to 96 bits (three longwords)
	;***
PrintDouble:
		movem.l	d0-d3/a0-a1,-(a7)

		movea.l	a1,a0
		movea.l	(Storage),a1
		moveq		#17,d0
		bsr		FExt2Asc
		movea.l	(Storage),a0
		PRINT
		NEWLINE

		movem.l	(a7)+,d0-d3/a0-a1
		rts

	;***
	;Command: show registers for task, crash node or debug node
	;***
RoutRegs:
		EVALE								;Get task or crash node
		movea.l	d0,a2
		cmpi.b	#NT_DEBUG,(LN_TYPE,a2)
		bne.b		4$
	;It is a debug node
		movea.l	(db_Task,a2),a4
		movea.l	(TC_SPREG,a4),a4
		bsr		SkipStackFrame
		move.l	(db_SP,a2),d6
		bra.b		DumpRegs
4$		cmpi.b	#NT_CRASH,(LN_TYPE,a2)
		bne.b		1$
	;It is a crash node
		lea		(cn_SP,a2),a4
		move.l	(a4)+,d6				;SP
		bra.b		DumpRegs
1$		cmpi.b	#NT_TASK,(LN_TYPE,a2)
		beq.b		3$
		cmpi.b	#NT_PROCESS,(LN_TYPE,a2)
		ERRORne	NotATaskProc
	;It is a task or process
3$		movea.l	(TC_SPREG,a2),a4	;Ptr to stack
		bsr		SkipStackFrame
		bsr		Print1Task
		moveq		#0,d6
	;Call DumpRegs with a4 a ptr to a stack frame
	;d6=stackpointer or 0 if from stackframe
DumpRegs:
		bsr		PrintLine
DumpRegsNL:
		movem.l	a3-a5,-(a7)
		bsr		CommonDR
		movem.l	(a7)+,a3-a5
		bra		PrintAC
	;Subroutine
	;-> a0 = pointer to data to print
	;-> d6 = stackpointer (or 0 if from stackframe)
CommonDR:
		lea		(-17*4-2,a7),a7
		movea.l	a7,a1
		movea.l	a7,a5
		lea		(FormatRegs,pc),a0
		movea.l	a4,a3
		lea		(6,a4),a4			;Skip PC and SR
		moveq		#14,d0				;Loop 15 times

1$		move.l	(a4)+,(a5)+
		dbra		d0,1$

		move.l	(a3)+,(a5)+			;PC
		move.l	d6,(a5)+
		bne.b		2$
	;Get stackpointer from stackframe
		move.l	a4,(-4,a5)
2$		move.w	(a3),(a5)			;SR
		move.l	(Storage),d0
		bsr		FastFPrint
		lea		(17*4+2,a7),a7
		movea.l	(Storage),a0
		rts

	;***
	;Make a loadable file resident
	;***
RoutResident:
		tst.l		d0						;End of line
		bne.b		3$

	;Show all resident pointers
		movea.l	(ResidentPtr),a4
1$		move.l	(a4)+,d0
		beq.b		2$
		PRINTHEX
		bra.b		1$
2$		rts

	;Install a new resident pointer
3$		bsr		GetStringE
		move.l	d0,d1
		CALLDOS	LoadSeg
		tst.l		d0
		ERROReq	ErrLoadSegFile
		lsl.l		#2,d0
		addq.l	#4,d0					;Point to code in segment
		bsr		AddPointerResident
		bne.b		4$
	;Error, unload segment
		subq.l	#4,d0
		lsr.l		#2,d0
		move.l	d0,d1
		CALLDOS	UnLoadSeg
		HERR

4$		PRINTHEX
		bra		StoreRC

	;***
	;Remove a resident file
	;***
RoutUnResident:
		EVALE								;Get pointer to code
		movea.l	d0,a0
		bsr		RemPointerResident
		move.l	a0,d1
		subq.l	#4,d1
		lsr.l		#2,d1
		CALLDOS	UnLoadSeg
		rts

	;***
	;Command: load a file into memory
	;***
RoutLoad:
		bsr		GetStringE			;Get filename
		movea.l	d0,a5
		EVALE								;Start address
		movea.l	d0,a4
		NEXTTYPE
		bne.b		1$
		move.l	#1<<30,d0			;Get max size
		bra.b		2$
1$		EVALE
2$		move.l	d0,d7
		move.l	a5,d1
		moveq		#MODE_OLDFILE-1000,d2
		bsr		OpenDos
		ERROReq	OpenFile
		move.l	d0,d6
		move.l	d0,d1
		move.l	d7,d3
		move.l	a4,d2
		CALL		Read
		movea.l	d0,a4
		PRINTHEX							;Print how many bytes are loaded
		move.l	d6,d1
		CALLDOS	Close
		move.l	a4,d0
		rts

	;***
	;Command: save memory to a file
	;a0 = cmdline
	;***
RoutSave:
		bsr		GetStringE			;Get filename
		movea.l	d0,a5
		EVALE								;Get start
		movea.l	d0,a4
		EVALE								;Get bytes
		move.l	d0,d7
		move.l	a5,d1
		moveq		#MODE_NEWFILE-1000,d2
		bsr		OpenDos
		ERROReq	OpenFile
		move.l	d0,d6
		move.l	d0,d1
		move.l	a4,d2
		move.l	d7,d3
		CALL		Write
		movea.l	d0,a4
		PRINTHEX							;Bytes saved
		move.l	d6,d1
		CALLDOS	Close
		move.l	a4,d0
		rts

	;***
	;Command: remove a resident module
	;a0 = cmdline
	;***
RoutRemRes:
		moveq		#I_RESMOD,d6
		bsr		SetList
		EVALE								;Get ptr to resident module
		movea.l	d0,a2
		cmpi.w	#RTC_MATCHWORD,(RT_MATCHWORD,a2)
		ERRORne	NotAResMod
		movea.l	(SysBase).w,a6
		movea.l	(ResModules,a6),a0
1$		move.l	(a0)+,d0
		ERROReq	NotAResMod
		bpl.b		2$
		bclr		#31,d0
		movea.l	d0,a0
		bra.b		1$
2$		cmp.l		a2,d0
		bne.b		1$
		movea.l	a0,a1
3$		tst.l		(a1)+
		bgt.b		3$
		clr.w		(a2)
		move.l	a1,d0
		sub.l		a0,d0
		lsr.l		#2,d0
		lea		(-4,a0),a1
		bra.b		5$
4$		move.l	(a0)+,(a1)+
5$		dbra		d0,4$
		rts

	;***
	;Command: remove a node
	;a0 = cmdline
	;***
RoutRemove:
		EVALE								;Get node
		movea.l	d0,a2
		bsr		Forbid
		movea.l	a2,a1
		CALLEXEC	Remove
		bra		Permit

	;***
	;Command: set the current directory for a process
	;a0 = cmdline
	;***
RoutCurDir:
		bsr		GetTaskE
		movea.l	d0,a5
		cmpi.b	#NT_PROCESS,(LN_TYPE,a5)
		ERRORne	NotAProcess
		bsr		GetStringE			;Get pathname
		move.l	d0,d1
		moveq		#ACCESS_READ,d2
		CALLDOS	Lock
		movea.l	d0,a4
		tst.l		d0
		ERROReq	CouldNotLock
		move.l	d0,d1
		bsr		AllocFIB
		move.l	a7,d2
		CALL		Examine
		tst.l		(fib_DirEntryType,a7)
		bpl.b		1$
		move.l	a4,d1
		CALL		UnLock
		ERROR		NotASubDir
1$		move.l	(pr_CurrentDir,a5),d1
		move.l	a4,(pr_CurrentDir,a5)
		CALLDOS	UnLock
		movea.l	a2,a7					;Restore stack
		rts

	;***
	;Alloc fileinfoblock on stack
	;(Must be called with 'bsr')
	;-> a7 points to longword alligned fileinfoblock
	;-> a2 points to previous stackpointer (to restore to)
	;-> preserves d1 and a1
	;***
AllocFIB:
		movea.l	(a7)+,a0				;Get return address
		movea.l	a7,a2
		lea		(-fib_SIZEOF,a7),a7
		move.l	a7,d0
		btst		#1,d0
		beq.b		1$
		lea		(-2,a7),a7			;Make longword alligned
1$		jmp		(a0)

	;***
	;Command: show the pathname for a lock
	;a0 = cmdline
	;-> d0 = ptr to string
	;***
RoutPathName:
		EVALE
		lsr.l		#2,d0					;APTR->BPTR
		bsr		CheckLock
		ERROReq	NotALock
		movea.l	a7,a0					;Pointer to end of pathname
		lea		(-256,a7),a7		;Reserve space
		bsr		ConstructPath
		move.l	a0,d0
		PRINT
		NEWLINE
		lea		(256,a7),a7
		rts

	;***
	;Command: unlock a lock
	;a0 = cmdline
	;***
RoutUnLock:
		EVALE
		lsr.l		#2,d0					;APTR->BPTR
		bsr		CheckLock
		ERROReq	NotALock
		move.l	d0,d1
		CALLDOS	UnLock
		rts

	;***
	;Command: close a window
	;a0 = cmdline
	;***
RoutCloseWindow:
		moveq		#I_WINDOW,d6
		bsr		SetList
		EVALE
RoutCloseWindow2:
		movea.l	d0,a2
		movea.l	d0,a0
		moveq		#0,d0
		CALLINT	ModifyIDCMP
		movea.l	a2,a0
		CALL		ClearDMRequest
		movea.l	a2,a0
		CALL		ClearMenuStrip
		movea.l	a2,a0
		CALL		ClearPointer
1$		tst.l		(wd_FirstRequest,a2)
		beq.b		2$
		movea.l	(wd_FirstRequest,a2),a0
		movea.l	a2,a1
		CALL		EndRequest
		bra.b		1$
2$		movea.l	a2,a0
		CALL		CloseWindow
		rts

	;***
	;Command: close a screen
	;a0 = cmdline
	;***
RoutCloseScreen:
		moveq		#I_SCREEN,d6
		bsr		SetList
		EVALE
RoutCloseScreen2:
		movea.l	d0,a3
1$		move.l	(sc_FirstWindow,a3),d0
		beq.b		2$
		bsr.b		RoutCloseWindow2
		bra.b		1$
2$		movea.l	a3,a0
		CALLINT	CloseScreen
		rts

	;***
	;Command: set the priority for a task
	;a0 = cmdline
	;***
RoutTaskPri:
		bsr		GetTaskE
		movea.l	d0,a1
		EVALE								;New priority
		movea.l	d0,a4
		CALLEXEC	SetTaskPri
		move.l	a4,d0
		rts

	;***
	;Command: list the hunks for a process
	;a0 = cmdline
	;***
RoutHunks:
		bsr		GetTaskE
		movea.l	d0,a4
		cmpi.b	#NT_PROCESS,(LN_TYPE,a4)
		ERRORne	NotAProcess
		lea		(HeaderHunk,pc),a0
		PRINT
		bsr		PrintLine
		moveq		#0,d7					;Counter for hunks
		move.l	(pr_CLI,a4),d0
		beq.b		1$
	;It is a cli, so we use the cli_Module instead of the pr_SegList
		lsl.l		#2,d0
		movea.l	d0,a0					;ptr to cli
		move.l	(cli_Module,a0),d0
		bra.b		2$
1$		move.l	(pr_SegList,a4),d0
		lsl.l		#2,d0					;BPTR->APTR
		movea.l	d0,a4
		move.l	(12,a4),d0			;Get ptr first seglist
2$		lsl.l		#2,d0
		movea.l	d0,a4
		beq.b		3$
		lea		(FormatHunk,pc),a0
		move.l	(-4,a4),-(a7)		;Length
		move.l	a4,d0
		addq.l	#4,d0
		move.l	d0,-(a7)				;Ptr to first code or data
		move.l	a4,-(a7)				;Ptr to seglist
		move.w	d7,-(a7)				;Counter for hunks
		addq.w	#1,d7
		move.l	(Storage),d0
		movea.l	a7,a1
		bsr		FastFPrint
		lea		(14,a7),a7
		bsr		ViewPrintLine
		NEWLINE
		move.l	(a4),d0
		bra.b		2$
3$		rts

	;***
	;Command: give PV device information
	;a0 = cmdline
	;***
RoutDevInfo:
		EVALE								;Get device block
		movea.l	d0,a1
		cmpi.l	#'PVDE',(8,a1)
		ERRORne	NotAPVDev
		movea.l	(a1)+,a2				;Get port
		movea.l	(a1),a4				;Get IORequest
		lea		(HeaderMsgPort),a0
		PRINT
		bsr		Print1MsgPort
		NEWLINE
		movea.l	a4,a2
		lea		(IOReqInfoList),a0
		bra		ListItem

	;***
	;Command: add a function to the function monitor
	;a0 = cmdline
	;***
RoutAddFunc:
		move.b	(MasterPV),d0
		ERROReq	NotAllowedForSlave

		bsr		SkipSpace
		movea.l	a0,a5					;Remember ptr to name
		bsr		StringToLib
		HERReq
		move.l	a6,d5					;Library
		move.l	d0,d6					;Offset
	;Check if there is another argument
		moveq		#FM_NORM,d4			;Assume no LED argument
		moveq		#0,d7					;Trap all tasks
		NEXTTYPE
		beq		NormalMonitorAF
		bsr		GetStringE
		movea.l	a0,a4
		movea.l	d0,a0
		movea.l	d0,a2
		lea		(OnlyString,pc),a1
		moveq		#4,d0
		bsr		CompareCI
		bne.b		ContSWordAF
	;There is the keyword 'only'
		movea.l	a4,a0
		move.l	d6,-(a7)
		bsr		GetTaskE
		move.l	(a7)+,d6
		move.l	d0,d7					;Set task
	;Get the next argument
		NEXTTYPE
		beq		NormalMonitorAF
		bsr		GetStringE
		movea.l	a0,a4					;Remember commandline ptr
		movea.l	d0,a2
ContSWordAF:
		lea		(AddFuncModes,pc),a1
		movea.l	a2,a0
		movem.l	a4-a5/d4-d7,-(a7)
		lea		(GetNextList),a5
		bsr		SearchWord
		movem.l	(a7)+,a4-a5/d4-d7
		tst.l		d1
		ERROReq	UnknownAddFuncArg
		jmp		(a0)

	;Make scratch registers dirty
ScratchAF:
		moveq		#FM_SCRATCH,d4
		bra.b		NormalMonitorAF

	;Execute a command
ExecAF:
		movea.l	a4,a0					;Commandline
		bsr		GetRestLinePer
		HERReq
		move.l	d0,-(a7)
		moveq		#FM_EXEC,d4
		bsr		AllocFuncMon
		HERReq
		move.l	(a7)+,d0
		move.l	d0,(fm_IDCCommand,a5)
		bra.b		AfterAF

	;Blink led and remember full information
FullLedAF:
		moveq		#FM_FULL+FM_LED,d4
		bra.b		NormalMonitorAF

	;Remember full information
FullAF:
		moveq		#FM_FULL,d4			;FULL argument
		bra.b		NormalMonitorAF

	;Blink led
LedAF:
		moveq		#FM_LED,d4			;LED argument

	;Handle everything
NormalMonitorAF:
		bsr		AllocFuncMon
		HERReq
AfterAF:
		move.l	#SizeMonitorCode,d3
		move.l	d3,d0
		moveq		#0,d1
		bsr		AllocMem				;Get place for task (DEBUG we don't check for success)
		move.l	d0,(fm_CodePtr,a5)
		move.l	d3,(fm_CodeSize,a5)
		move.l	d5,(fm_Library,a5)
		neg.l		d6
		move.w	d6,(fm_Offset,a5)
		clr.l		(fm_Count,a5)
		move.w	d4,(fm_Type,a5)
		clr.w		(fm_LastTaskNr,a5)
		lea		(fm_LastTask,a5),a0
		moveq		#7,d1					;Loop 8 times

1$		clr.l		(a0)+
		dbra		d1,1$

		bsr		Disable
		movea.l	d5,a1
		neg.l		d6
		movea.l	d6,a0
		move.l	(fm_CodePtr,a5),d0
		CALLEXEC	SetFunction
		move.l	d0,(fm_OldFunction,a5)
		move.l	d0,(MonitorCodeJmp+2)
		move.l	a5,(MonitorCodeAddr+2)
		movea.l	(fm_CodePtr,a5),a1
		lea		(MonitorCode,pc),a2
		move.w	#SizeMonitorCode-1,d0

2$		move.b	(a2)+,(a1)+
		dbra		d0,2$

		movea.l	(fm_CodePtr,a5),a1
		andi.w	#FM_LED,d4
		bne.b		4$
		move.w	#$4e71,d0			;nop
		move.w	d0,(MonitorLedAddr,a1)
		move.w	d0,(MonitorLedAddr+2,a1)
		move.w	d0,(MonitorLedAddr+4,a1)
		move.w	d0,(MonitorLedAddr+6,a1)
4$		move.l	d7,(MonitorCodeTask+2,a1)
		move.b	#$66,(MonitorCodeTask+6,a1)	;bne.b
		move.l	d7,(fm_Task,a5)
		tst.l		d7
		bne.b		Only1Task
	;We trap all tasks
		move.l	(RealThisTask,pc),(MonitorCodeTask+2,a1)
		move.b	#$67,(MonitorCodeTask+6,a1)	;beq.b
Only1Task:
		bsr		Enable
		move.l	a5,d0
		rts

	;***
	;Allocate a funcmon node
	;a5 = ptr to name
	;-> a5 = ptr to node (or 0, flags if error)
	;***
AllocFuncMon:
		movea.l	a5,a0
		bsr		GetString
		beq.b		1$
		movea.l	d0,a0
		move.l	#FM_SIZE,d0
		bsr		MakeNodeInt
		beq.b		1$
		move.b	#NT_FUNCMON,(LN_TYPE,a0)
		movea.l	a0,a1
		movea.l	a0,a5
		lea		(FunctionsMon,pc),a0
		CALLEXEC	AddHead
		move.l	a5,d0
		bsr		StoreRC
		tst.l		d0
		rts
1$		suba.l	a5,a5
		move.l	a5,d0
		rts

	;***
	;Command: remove a function from the function monitor
	;a0 = cmdline
	;***
RoutRemFunc:
		moveq		#I_FUNCMON,d6
		bsr		SetList
		EVALE								;Ptr to node
		movea.l	d0,a0
		cmpi.b	#NT_FUNCMON,(LN_TYPE,a0)
		ERRORne	NodeTypeWrong
RemFuncDirect:
		movea.l	d0,a5
		movea.l	(fm_Library,a5),a1
		moveq		#0,d0
		move.w	(fm_Offset,a5),d0
		neg.l		d0
		movea.l	d0,a0
		move.l	(2,a1,d0.l),d1
		cmp.l		(fm_CodePtr,a5),d1
		ERRORne	FunctionPatched
		move.l	(fm_OldFunction,a5),d0
		bsr		Disable
		CALLEXEC	SetFunction
		bsr		Enable
		moveq.l	#3,d1					;Wait a bit to make sure there are no
		CALLDOS	Delay					;programs executing the code we are going
											;to remove
											;There will be no new programs in our code
											;because we have already restored the patch
		move.l	(fm_CodeSize,a5),d0
		movea.l	(fm_CodePtr,a5),a1
		bsr		FreeMem
		movea.l	(LN_NAME,a5),a1
		movea.l	a1,a0
		move.l	a1,d0
1$		tst.b		(a0)+
		bne.b		1$
		sub.l		a0,d0
		neg.l		d0
		bsr		FreeMem
		movea.l	(fm_IDCCommand,a5),a0
		bsr		FreeBlock
		movea.l	a5,a1
		CALLEXEC	Remove
		move.l	#FM_SIZE,d0
		movea.l	a5,a1
		bra		FreeMem

	;***
	;Command: enable or disable task accounting and stack checking
	;***
RoutAccount:
		move.b	(MasterPV),d0
		ERROReq	NotAllowedForSlave

		bsr		Forbid
		movea.l	(SysBase).w,a6
		movea.l	a6,a1
		movea.l	#_LVOSwitch,a0
		lea		(OldSwitch,pc),a2
		tst.l		(a2)
		bne.b		1$
	;First allocate block for accounting
		movem.l	a0-a1,-(a7)
		move.l	#8*64,d0				;64 tasks maximum
		bsr		AllocBlockInt
		HERReq
	;Block is allocated
3$		move.l	d0,(AccountBlock)
		movem.l	(a7)+,a0-a1
	;Patch function
		lea		(PercentUsed,pc),a6
		move.l	a6,d0
		movea.l	(SysBase).w,a6
		CALL		SetFunction
		move.l	d0,(a2)
		move.l	d0,(JumpPercentUsed+2)
		bsr		Permit
		lea		(MesAccountOn,pc),a0
2$		PRINT
		rts
	;Account off
1$		move.l	(a2),d0
		CALL		SetFunction
		clr.l		(a2)
		bsr		Permit
	;Free account block
		movea.l	(AccountBlock,pc),a0
		bsr		FreeBlock
		lea		(AccountBlock,pc),a0
		clr.l		(a0)
		lea		(MesAccountOff,pc),a0
		bra.b		2$

	;***
	;Command: load an fd-file
	;a0 = cmdline
	;***
RoutLoadFd:
		moveq		#I_LIBS,d6
		bsr		SetList
		EVALE								;Get library ptr
		bsr		ResetList

		movea.l	d0,a4					;a4 = library
		lea		(FDFiles,pc),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$
		cmpa.l	(fd_Library,a2),a4
		bne.b		1$

	;Library already exists, ignore loadfd command
		moveq		#-1,d0
		bra		StoreRC

	;Load
2$		bsr		GetStringE			;Get fd filename
		movea.l	d0,a5

	;Make fd-file node
		moveq		#fd_SIZE,d0
		suba.l	a0,a0
		bsr		MakeNodeInt
		HERReq
		movea.l	a0,a2					;Ptr to node

	;Init node
		move.l	a4,(fd_Library,a2)
		move.b	#NT_FDFILE,(LN_TYPE,a2)
		move.l	(LN_NAME,a4),(LN_NAME,a2)
		clr.l		(fd_Block,a2)
		clr.l		(fd_String,a2)
		clr.l		(fd_BlockSize,a2)
		clr.l		(fd_StringSize,a2)
		clr.w		(fd_Bias,a2)

	;Open file
		move.l	a5,d1
		bsr		FOpen
		movea.l	d0,a5
		bne.b		5$
		bsr		CleanUpLFD
		HERR

	;Success, try to load library functions
5$		moveq		#0,d7					;Library function counter
		moveq		#0,d5					;Offset counter
LoopLFD:
		move.l	a5,d1
		move.l	(Storage),d2
		move.l	#198,d3
		move.l	a2,-(a7)
		bsr		FReadLine
		movea.l	(a7)+,a2				;For flags
		beq		EndOfFileLFD
		subq.l	#1,d0					;Test for 1
		beq.b		LoopLFD
		addq.l	#2,d0					;Test for -1
		HERReq
	;Test if the line is a comment line or a '##' command line
		movea.l	(Storage),a0
		tst.b		(a0)
		beq.b		LoopLFD
		cmpi.b	#'*',(a0)
		beq.b		LoopLFD
		cmpi.w	#'##',(a0)
		bne.b		2$
		cmpi.l	#'bias',(2,a0)
		bne.b		1$

	;##bias
		lea		(6,a0),a0				;Skip bias command
		bsr		SkipSpace
		bsr		ParseDec				;Get bias factor
		tst.w		(fd_Bias,a2)
		beq.b		3$

	;This is not the first bias statement, skip a few instructions
		move.w	d0,d1					;Remember bias value
		sub.w		d5,d0					;Subtract current offset
		bge.b		4$
	;Error, fd-file is not consistant
		bsr		CleanUpLFD
		ERROR		BadBiasStatement

	;Good bias statement
4$		ext.l		d0
		move.w	d1,d5					;New offset
		move.l	d0,d4
		divu.w	#6,d4					;d0 = number of instructions to skip
5$		tst.w		d4
		beq.b		LoopLFD
		lea		(StrDummyFunc,pc),a0
		addq.w	#1,d7					;New (dummy) function
		bsr		AppendFuncToFd
		beq		CleanUpLFD
		subq.w	#1,d4
		bra.b		5$

	;This is the first bias statement
3$		move.w	d0,(fd_Bias,a2)
		move.w	d0,d5
		bra		LoopLFD

	;##end
1$		cmpi.w	#'en',(2,a0)
		beq.b		EndOfFileLFD
		bra		LoopLFD

	;A normal line
2$		addq.w	#1,d7					;New function
		addq.w	#6,d5					;New offset for next function
		bsr		AppendFuncToFd
		bne		LoopLFD
		bra		CleanUpLFD
EndOfFileLFD:
		lea		(fd_BlockSize,a2),a0
		move.l	(a0),d0
		addq.l	#4,d0					;Make place for endmarker
		bsr		ReAllocMem			;We should test for success !!!
		movea.l	d0,a0
		adda.l	(fd_BlockSize,a2),a0
		moveq		#-1,d0
		move.l	d0,(-4,a0)			;End marker
		move.w	d7,(fd_NumFuncs,a2)
		move.l	a5,d1
		bsr		FClose
		lea		(FDFiles,pc),a0		;Add our node to the list
		movea.l	a2,a1
		CALLEXEC	AddHead
		move.l	a2,d0
		bsr		StoreRC
		lea		(MesFuncLoaded,pc),a0
		PRINT
		move.l	d7,d0
		PRINTHEX
		rts

	;Subroutine to clean everything up
	;a2 = ptr to fd-node
CleanUpLFD:
		move.l	a5,d1
		beq.b		1$
		bsr		FClose
1$		move.l	a2,d0
		beq.b		2$
		lea		(fd_BlockSize,a2),a0
		moveq		#0,d0
		bsr		ReAllocMem
		lea		(fd_StringSize,a2),a0
		moveq		#0,d0
		bsr		ReAllocMem
		movea.l	a2,a1
		moveq		#fd_SIZE,d0
		bsr		FreeMem
2$		rts

	;***
	;Append a fd-file entry to a fd-file node
	;a2 = ptr to fd-file node
	;a0 = ptr to string
	;-> flags if error
	;***
AppendFuncToFd:
		movem.l	a2/a5,-(a7)
	;Add string to stringspace
		movea.l	a0,a3
1$		tst.b		(a3)
		SERReq	MissingBraInFdFile,ErrorLFD,far
		cmpi.b	#'(',(a3)+
		bne.b		1$
		clr.b		(-1,a3)				;Set end of string here
		lea		(fd_StringSize,a2),a1
		bsr		AddString
		move.b	#'(',(-1,a3)		;Restore string
		move.l	d0,d2					;Position relative to start pool + 1
		beq		ErrorLFD
		subq.l	#1,d2					;Pos relative to start pool
		lea		(fd_BlockSize,a2),a0
		moveq		#12,d1
		bsr		AppendMem
		beq		ErrorLFD
		movea.l	(fd_Block,a2),a0	;Ptr to memoryblock
		move.l	(fd_BlockSize,a2),d0
		adda.l	d0,a0
		lea		(-12,a0),a0			;Ptr to new block
		move.l	d2,(a0)+				;Offset to string
		movea.l	a0,a4					;a4 = ptr to register arguments
		cmpi.b	#')',(a3)			;Test if this function has arguments
		bne.b		2$
		moveq		#-1,d0
		move.l	d0,(a4)+				;Init register usage to unused
		move.l	d0,(a4)+
		moveq		#1,d0					;No errors
		movem.l	(a7)+,a2/a5
		rts
	;There are arguments, skip first (...)
2$		tst.b		(a3)
		SERReq	MissingKetInFdFile,ErrorLFD
		cmpi.b	#')',(a3)+
		bne.b		2$
	;a3 points to second (...)
		clr.l		(a4)
		clr.l		(4,a4)
		moveq		#0,d2
	;Scan all registers
Loop2LFD:
		move.l	d2,d3
		lsr.l		#1,d3					;Offset in reg usage registers
		cmpi.b	#')',(a3)+
		beq.b		EndLoop2LFD
		moveq		#0,d1
		cmpi.b	#'D',(a3)+
		beq.b		1$
		cmpi.b	#'d',(-1,a3)
		beq.b		1$
		addq.w	#8,d1
1$		move.b	(a3)+,d0
		subi.b	#'0',d0
		add.l		d0,d1					;d1 is 0 through 15 for d0 through a7
		btst		#0,d2					;Test if even
		bne.b		2$
		lsl.b		#4,d1					;Even
		bra.b		3$
2$		or.b		(0,a4,d3.w),d1
3$		move.b	d1,(0,a4,d3.w)
		addq.w	#1,d2
		bra.b		Loop2LFD
EndLoop2LFD:
		moveq		#-1,d1
		btst		#0,d2
		beq.b		1$
		move.b	(0,a4,d3.w),d1		;Odd
		ori.b		#%00001111,d1
1$		move.b	d1,(0,a4,d3.w)
		moveq		#1,d0					;No error
		movem.l	(a7)+,a2/a5
		rts

	;Error
ErrorLFD:
		moveq		#0,d0					;Error
		movem.l	(a7)+,a2/a5
		rts

	;***
	;Command: unload an fd-file
	;a0 = cmdline
	;***
RoutUnLoadFd:
		moveq		#I_FDFILES,d6
		bsr		SetList
		EVALE								;Get ptr to FDFile node
		movea.l	d0,a0
		cmpi.b	#NT_FDFILE,(LN_TYPE,a0)
		ERRORne	NodeTypeWrong
UnLoadFdDirect:
		movea.l	d0,a2
		suba.l	a5,a5
		movea.l	d0,a1
		CALLEXEC	Remove
		bra		CleanUpLFD

	;***
	;Command: remove a crash node
	;a0 = cmdline
	;***
RoutRemCrash:
		moveq		#I_CRASH,d6
		bsr		SetList
		EVALE								;Get ptr to crash node
		movea.l	d0,a0
		cmpi.b	#NT_CRASH,(LN_TYPE,a0)
		ERRORne	NodeTypeWrong
RemoveCrashDirect:
		movea.l	d0,a1
		movea.l	d0,a2
		CALLEXEC	Remove
		movea.l	a2,a1
		moveq		#cn_SIZE,d0
		bra		FreeMem

	;***
	;Command: show library function corresponding to offset
	;***
RoutLibFunc:
		moveq		#I_LIBS,d6
		bsr		SetList
		EVALE								;Get library
		bsr		ResetList
		movea.l	d0,a5
		EVALE								;Get offset
	;See if we have an fd-file for this library
		ext.l		d0						;Extend long this offset
		neg.l		d0
		lea		(FDFiles,pc),a1
3$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		ERROReq	NoFdFileForLibrary
		cmpa.l	(fd_Library,a1),a5
		bne.b		3$
	;We have found the library !
4$		sub.w		(fd_Bias,a1),d0
		ext.l		d0
		divu.w	#6,d0					;d0 is number of function
		cmp.w		(fd_NumFuncs,a1),d0
		ble.b		1$						;Function goes to far
		ERROR		NoSupportedLibFunc
1$		ext.l		d0
		mulu.w	#12,d0				;Offset in fd_Block
		move.l	a1,-(a7)
		movea.l	(fd_Block,a1),a1
		adda.l	d0,a1
		move.l	(a1),d0				;Offset for string
		movea.l	(a7)+,a1				;Ptr to fd-node
		movea.l	(fd_String,a1),a1
		adda.l	d0,a1					;Ptr to string
		movea.l	(Storage),a0
8$		move.b	(a1)+,(a0)+
		bne.b		8$
		move.b	#10,(-1,a0)
		clr.b		(a0)
		bra		ViewPrintLine

	;***
	;Command: give library function information
	;a0 = cmdline
	;***
RoutLibInfo:
		bsr		SkipSpace
		bsr		StringToLib
		HERReq
		movem.l	d1-d2,-(a7)			;Push on stack for calculations below
		lea		(FormatLibFunc,pc),a0
		move.w	d0,-(a7)
		move.l	a6,-(a7)
		move.l	d0,d5
		move.l	(Storage),d0
		movea.l	a7,a1
		bsr		FastFPrint
		lea		(6,a7),a7
		movea.l	(Storage),a0
		lea		(8+6+3,a0),a0
		moveq		#0,d7
2$		move.w	d7,d0
		lsr.w		#1,d0
		move.b	(0,a7,d0.w),d0
		btst		#0,d7
		bne.b		1$
		lsr.b		#4,d0					;Even
1$		andi.b	#$f,d0
		addq.w	#1,d7					;Next argument
		cmpi.b	#$f,d0
		beq.b		3$
		moveq		#0,d6
		move.b	d0,d6
		lsl.w		#1,d6					;Offset in RegsLibFunc
		lea		(RegsLibFunc,pc),a1
		move.b	(0,a1,d6.w),(a0)+
		move.b	(1,a1,d6.w),(a0)+
		move.b	#',',(a0)+
		bra.b		2$
	;End loop
3$		cmpi.b	#'(',-(a0)
		bne.b		4$
		lea		(1,a0),a0
4$		move.b	#')',(a0)+
		clr.b		(a0)+
		bsr		ViewPrintLine
		NEWLINE
		lea		(8,a7),a7				;Pop d1 and d2 from stack
		move.l	d5,d0					;Offset
		rts

	;***
	;Command: freeze a task or process
	;a0 = cmdline
	;***
RoutFreeze:
		bsr		GetTaskE
FreezeTaskDirect:
		bsr		Disable
		bsr		FreezeATask
		bsr		Enable
		tst.b		d0
		beq.b		1$
		subq.b	#1,d0
		ERROReq	TaskIsFreezed
		subq.b	#1,d0
		ERROReq	NotATaskProc
		ERROR		CantFreezePowerVisor
1$		rts

	;***
	;Subroutine to freeze a task if possible
	;This routine will check if you are to freeze PowerVisor
	;This routine will NOT disable. Do this yourselves if you need it
	;d0 = task
	;-> d0 = 0 no error (flags)
	;			1 already freezed
	;			2 not a task or process
	;			3 equal to PowerVisor
	;***
FreezeATask:
		cmp.l		(RealThisTask,pc),d0
		bne.b		3$
		moveq		#3,d0					;Equal to PowerVisor
		rts

3$		movea.l	d0,a1
		move.b	(LN_TYPE,a1),d0
		cmpi.b	#1,d0
		beq.b		1$
		cmpi.b	#13,d0
		beq.b		1$

		moveq		#2,d0					;Not a task or process
		rts

1$		cmpi.b	#7,(TC_STATE,a1)
		blt.b		2$

		moveq		#1,d0					;Task is already freezed
		rts

2$		move.l	a1,-(a7)
		CALLEXEC	Remove
		lea		(Freezed,pc),a0
		movea.l	(a7),a1
		CALL		AddHead
		movea.l	(a7)+,a1
		addi.b	#7,(TC_STATE,a1)	;Task state is freezed
		moveq		#0,d0					;No error
		rts

	;***
	;Command: unfreeze a task or process
	;a0 = cmdline
	;***
RoutUnFreeze:
		bsr		GetTaskE
		movea.l	d0,a2
		move.b	(LN_TYPE,a2),d0
		cmpi.b	#1,d0
		beq.b		1$
		cmpi.b	#13,d0
		ERRORne	NotATaskProc
1$		cmpi.b	#7,(TC_STATE,a2)
		bge.b		2$
		ERROR		TaskNotFreezed
2$		movea.l	a2,a1
		CALLEXEC	Remove
		lea		(TaskReady,a6),a3
		cmpi.b	#7+3,(TC_STATE,a2)
		beq.b		3$
		lea		(TaskWait,a6),a3
3$		bsr		Disable
		movea.l	a2,a1
		movea.l	a3,a0
		CALL		AddTail
		subi.b	#7,(TC_STATE,a2)
		bra		Enable

	;***
	;Command: kill a task, process or crash node
	;a0 = cmdline
	;***
RoutKill:
		bsr		GetTaskE
CancelTaskDirect:
		movea.l	d0,a0
		cmpi.b	#NT_CRASH,(LN_TYPE,a0)
		bne.b		1$
	;It is a ptr to a crash node, delete crash node
2$		movea.l	(cn_Task,a0),a3
		move.l	a0,d0
		bsr		RemoveCrashDirect
		move.l	a3,d0					;d0 = task
		bra.b		StartKill
	;See if there is a corresponding crash node
1$		bsr		SearchCrashedTask
		move.l	a0,d1
		bne.b		2$						;d0=still a ptr to a task
StartKill:
		movea.l	d0,a3
		move.b	(LN_TYPE,a3),d0
		cmpi.b	#NT_PROCESS,d0
		beq.b		1$
		cmpi.b	#NT_TASK,d0
		ERRORne	NotATaskProc
	;It is a task, put it on the waiting list and remove (we do this to
	;make sure freezed tasks are removed correctly)
		bsr		Disable
		movea.l	a3,a1
		move.b	#TS_WAIT,(TC_STATE,a1)
		CALLEXEC	Remove
		movea.l	a3,a1
		lea		(TaskWait,a6),a0
		CALL		AddHead
		movea.l	a3,a1
		CALL		RemTask
		bra		Enable
	;a3 = ptr to process
	;Put on waiting list
1$		bsr		Disable
		movea.l	a3,a1
		move.b	#TS_WAIT,(TC_STATE,a1)
		CALLEXEC	Remove
		movea.l	a3,a1
		lea		(TaskWait,a6),a0
		CALL		AddHead
	;Put process back on active list
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a3),a4
		bsr		SkipStackFrame
		movea.l	a4,a1
		movea.l	(a7)+,a4
		lea		(EndTask,pc),a0
		move.l	a0,(a1)
		move.b	#TS_READY,(TC_STATE,a3)
		movea.l	a3,a1
		CALL		Remove
		movea.l	a3,a1
		lea		(TaskReady,a6),a0	;Activate task
		CALL		AddHead
		bra		Enable
EndTask:
		suba.l	a1,a1
		CALLEXEC	FindTask
		bsr		Closetskwin
		CALLDOS	Exit
		rts
	;Close all task windows and screens
	;d0=ptr to task
Closetskwin:
		movem.l	d1-d7/a0-a6,-(a7)
		move.l	d0,d7
		movea.l	(IntBase),a2
		movea.l	(ib_FirstScreen,a2),a2
LoopCSW:
		move.l	a2,d0
		beq.b		EndLoopCSW
		moveq		#0,d6
		movea.l	(sc_FirstWindow,a2),a3
Loop2CSW:
		move.l	a3,d0
		beq.b		EndLoop2CSW
		movea.l	(wd_UserPort,a3),a0
		move.l	(MP_SIGTASK,a0),d1
		cmp.l		d7,d1
		bne.b		NextLoop2CSW
	;Close this window
		move.l	a2,-(a7)
		move.l	a3,d0
		bsr		RoutCloseWindow2
		movea.l	(a7)+,a2
	;Start in the beginning for this screen
		moveq		#1,d6					;Indicate we must cancel this screen
		movea.l	(sc_FirstWindow,a2),a3
		bra.b		Loop2CSW
NextLoop2CSW:
		movea.l	(wd_NextWindow,a3),a3
		bra.b		Loop2CSW
EndLoop2CSW:
		movea.l	(sc_NextScreen,a2),a4
		tst.w		d6
		beq.b		NoCloseCSW
	;Close this screen if it is not the workbench
		move.w	(sc_Flags,a2),d0
		andi.w	#SCREENTYPE,d0
		cmpi.w	#CUSTOMSCREEN,d0
		bne.b		NoCloseCSW			;If it is not a custom screen, we close nothing
		move.l	a4,-(a7)
		move.l	a2,d0
		bsr		RoutCloseScreen2
		movea.l	(a7)+,a4
NoCloseCSW:
		movea.l	a4,a2
		bra.b		LoopCSW
EndLoopCSW:
		movem.l	(a7)+,d1-d7/a0-a6
		rts

	;***
	;Command: jump to a fixed place in memory
	;a0 = cmdline
	;***
RoutGo:
		EVALE
		movea.l	d0,a6
		suba.l	a5,a5
		bra		RoutGo2

	;***
	;Global trap code
	;This routine is called whenever an exception occurs
	;first longword on stack is trap number (stackframe follows)
	;
	;It is possible that we get a trace exception (memory protection
	;error (see 'pv_mmu.asm'). Therefore we always clear the trace
	;bit before returning to user mode
	;***
TrapCode:
		disable
		tst.b		(InTaskWait)
		bne		CheckIllegal
ContinueTC:
		bchg.b	#1,($bfe001)
		bra.b		NormalTrapCode

	;PowerVisor trapcode
PVTrapCode:
	;First check if we are handling an error message
		movem.l	d1/a6,-(a7)
		move.l	(8,a7),d1			;Get trap number
		sub.w		#32,d1
		blt.b		NormalPVTrapCode

	;We must execute a trap routine
	;Note that this trap handler preserves all registers
		lsl.w		#2,d1					;d1 = offset in 'TrapRoutTable'

		move.l	usp,a6
		move.l	(2+12,a7),-(a6)	;Push correct return address on userstack
		move.l	a6,usp
		lea		(TrapRoutTable,pc),a6
		move.l	(0,a6,d1.w),(2+12,a7)	;Change program counter

		movem.l	(a7)+,d1/a6

		lea		(4,a7),a7			;Skip trap number
		rte

TrapRoutTable:
		dc.l		ErrorRoutine
		dc.l		HandleError
		dc.l		EvaluateE
		dc.l		PrintHex
		dc.l		NewLine
		dc.l		GetNextType
		dc.l		Print

NormalPVTrapCode:
		movem.l	(a7)+,d1/a6

NormalTrapCode:
		clr.l		(TrapParameters)
		move.l	(a7)+,(TrapAlertNum)

	;Start of fix for 68000 (J.Harper)
	;Check for 68000's different addr and bus error frame
		tst.w		(p68020)
		bne.b		3$
		cmpi.w	#2,(TrapAlertNum+2)
		beq.b		4$
		cmpi.w	#3,(TrapAlertNum+2)
		bne.b		3$

	;We got one, so advance the stack over the weirdness
4$		addq.l	#8,sp

	;end of fix

3$		move.l	(2,a7),(TrapReturn)
		move.w	(a7),(TrapSR)
		andi.b	#$3f,(a7)			;Disable trace mode
		move.l	a0,-(a7)

		suba.l	a0,a0
		movea.w	($6+4,a7),a0
		movea.l	($10+4,a7),a0

		movea.l	(SysBase).w,a0
		movea.l	(ThisTask,a0),a0
		move.l	a0,(TrapThisTask)
		cmpa.l	(RealThisTask,pc),a0
		beq		PvCrashed

	;Check if 68020 or higher
		tst.w		(p68020)
		beq.b		1$
	;Yes, test if address error or bus error
		movea.l	(TrapAlertNum,pc),a0
		cmpa.l	#2,a0
		beq.b		2$
		cmpa.l	#3,a0
		bne.b		1$
	;Address or bus error, do not recover
2$		andi.w	#$4fff,sr			;Go to usermode and disable trace mode
		bra		CrashRoutine
	;It is not an address or bus error (or we are in 68000 mode)
1$		movea.l	(a7)+,a0
		move.l	#CrashRoutine,(2,a7)
		clr.b		(IsGuru)
		rte
PvCrashed:
		movea.l	(a7)+,a0
		move.l	#PowerVisorCrashed2,(2,a7)
		enable
		rte
CheckIllegal:
	;Check if it is the new task
		cmpi.l	#4,(a7)				;ILLEGAL
		bne		ContinueTC			;no
	;We assume it is right
		clr.b		(InTaskWait)
		move.l	a0,(a7)				;Put on stack (delete previous)
		movea.l	(SysBase).w,a0
		move.l	(6,a7),(Dummy)		;PC
		move.l	(ThisTask,a0),(Dummy+4)
		movea.l	(a7)+,a0
		move.l	#SignalPVRoutine,(2,a7)
		enable
		rte
	;Give a signal to PowerVisor
SignalPVRoutine:
		move.l	a7,(Dummy+12)
		movem.l	d0-d1/a0-a1/a6,-(a7)
		clr.b		(BackFromSignal)
		movea.l	(RealThisTask,pc),a1
		move.l	(DebugSigSet),d0
		CALLEXEC	Signal
		movem.l	(a7)+,d0-d1/a0-a1/a6
		move.b	#1,(BackFromSignal)
1$		bra.b		1$

	;***
	;Library function monitor task
	;***
MonitorCode:
		movem.l	a0-a1,-(a7)
		movea.l	(SysBase).w,a1
		movea.l	(ThisTask,a1),a1
MonitorCodeTask equ *-MonitorCode
		cmpa.l	#$00000000,a1
		beq		DontMonitor
MonitorCodeAddr:
		movea.l	#$00000000,a0
		movem.l	d0-d1,-(a7)
MonitorLedAddr equ *-MonitorCode
		bchg.b	#1,($bfe001)
		disable							;To assure mutual exclusion
		addi.l	#1,(fm_Count,a0)
		move.w	(fm_LastTaskNr,a0),d0
		move.l	a1,(fm_LastTask,a0,d0.w)
		moveq		#0,d1
		move.w	d0,d1
		addq.w	#4,d0
		andi.b	#31,d0				;Truncate
		move.w	d0,(fm_LastTaskNr,a0)

		move.w	(fm_Type,a0),d0
		andi.w	#FM_EXEC,d0
		beq.b		4$

	;Exec type, we let PowerVisor execute a command and we wait
	;First save registers
		clr.w		(fm_LastTaskNr,a0)
		lea		(fm_Registers,a0),a1
		lea		(14*4,a1),a1
		movem.l	d0-d7/a0-a5,-(a1)
		move.l	(a7),(a1)			;d0
		move.l	(4,a7),(4,a1)			;d1
		move.l	(8,a7),(8*4,a1)		;a0
		move.l	(12,a7),(9*4,a1)		;a1
	;Exec
		movem.l	a2-a4/a6,-(a7)
		movea.l	a0,a3					;Function monitor node
		CALLPV	PP_InitPortPrint
		tst.l		d0
		beq.b		3$
		movea.l	d0,a4					;Reply port
		movea.l	a4,a0
		movea.l	a3,a1
		movea.l	(fm_IDCCommand,a3),a2
		move.l	#FM_SIZE,d0
		CALL		PP_ExecCommand
		movea.l	a4,a0
		CALL		PP_StopPortPrint
3$		movem.l	(a7)+,a2-a4/a6
		bra.b		1$

4$		move.w	(fm_Type,a0),d0
		andi.w	#FM_SCRATCH,d0
		beq.b		5$

	;Scratch type, make scratch registers dirty
		enable
		movem.l	(a7)+,d0-d1
		movem.l	(a7)+,a0-a1
		bsr.b		MonitorCodeJmp
		move.l	#$BADBADD1,d1
		movea.l	#$BADBADA0,a0
		movea.l	#$BADBADA1,a1
		rts

5$		move.w	(fm_Type,a0),d0
		andi.w	#FM_FULL,d0
		beq.b		1$

	;Full type, we must save all registers
		mulu.w	#14,d1
		lea		(fm_Registers,a0),a1
		lea		(14*4,a1,d1.w),a1
		movem.l	d0-d7/a0-a5,-(a1)
		move.l	(a7),(a1)			;d0
		move.l	(4,a7),(4,a1)		;d1
		move.l	(8,a7),(8*4,a1)	;a0
		move.l	(12,a7),(9*4,a1)	;a1

	;The end
1$		enable
		movem.l	(a7)+,d0-d1
DontMonitor:
		movem.l	(a7)+,a0-a1
MonitorCodeJmp:
		jmp		($00000000).l
SizeMonitorCode	equ	*-MonitorCode

	;***
	;Account percent usage for each task (patch for Switch)
	;***
PercentUsed:
		movem.l	d0/a0-a2,-(a7)
		movea.l	(SysBase).w,a0
		movea.l	(ThisTask,a0),a0
		movea.l	(AccountBlock,pc),a1
	;See if this task is already in account block
	;(also search the last free block)
		suba.l	a2,a2
		moveq		#63,d0				;Loop 64 times

1$		tst.l		(a1)
		bne.b		3$
	;This is a possible candidate for a new entry
		movea.l	a1,a2
3$		cmpa.l	(a1)+,a0
		beq.b		2$
		lea		(4,a1),a1				;Go to next entry
		dbra		d0,1$

	;Not found ! , a2 = ptr to last free block (or null if not available)
		cmpa.l	#0,a2
		beq.b		4$						;No free block
	;Make a new entry
		movea.l	a2,a1
		move.l	a0,(a1)+
		clr.l		(a1)
	;Found ! , a1 = ptr to usagecounter
2$		addq.l	#1,(a1)
	;Check stack
4$		move.l	(TC_SPLOWER,a0),d0
		add.l		(StackFailL,pc),d0	;Stack overflow level
		move.l	usp,a1
		cmp.l		a1,d0
		bge.b		StackFailPU
		movem.l	(a7)+,d0/a0-a2
JumpPercentUsed:
		jmp		($00000000).l
StackFailPU:
		moveq		#-1,d0
		move.l	d0,(TrapReturn)	;We will never recover from a stack
											;overflow, so if this variable is -1
											;we have a stack overflow
		movea.l	(TC_SPUPPER,a0),a1
		subq.l	#2,a1
		move.l	#CrashRoutine,-(a1)
		move.l	a1,usp
		move.b	#2,(IsGuru)
		move.l	a0,(TrapThisTask)
		movem.l	(a7)+,d0/a0-a2
		move.l	#CrashRoutine,(2,a7)
		bra.b		JumpPercentUsed

	;***
	;AutoRequest patch routine
	;***
AutoRequestPatch:
		movem.l	d1/a0-a1,-(a7)
		lea		(TaskHeldMsg,pc),a0
		movea.l	(it_IText,a1),a1
		moveq		#TaskHeldMsgLen-1,d1
1$		cmpm.b	(a0)+,(a1)+
		dbne		d1,1$
		cmpi.w	#-1,d1
		movem.l	(a7)+,d1/a0-a1
		bne.b		2$
	;Yes, task held
		moveq		#0,d0
		rts
2$
ToAutoRequestJmp	equ	*-AutoRequestPatch
		jmp		($00000000).l

	;***
	;AddTask patch (for AmigaDOS 2.04) to copy TaskTrapCode from execbase
	;to TrapCode from the task
	;***
AddTaskRoutine:
		move.l	a1,-(a7)
JumpAddTask:
		jsr		($00000000).l
		movea.l	(a7)+,a1
		move.l	(TaskTrapCode,a6),(TC_TRAPCODE,a1)
		rts

	;***
	;Alert patch routine
	;***
AlertRoutine:
		disable
		movem.l	d0-d1/a0-a1/a6,-(a7)
		moveq		#0,d0
		move.l	d0,d1
		CALLEXEC	SetSR					;Get SR (DEBUG, meaningless)
		move.w	d0,(TrapSR)
		movem.l	(a7)+,d0-d1/a0-a1/a6
		move.l	a0,-(a7)
		movea.l	(SysBase).w,a0
		move.l	(ThisTask,a0),(TrapThisTask)
		movea.l	(a7)+,a0
		move.l	d7,(TrapAlertNum)
		move.l	a5,(TrapParameters)
		move.l	(a7),(TrapReturn)
		move.l	d0,-(a7)
		move.l	(TrapThisTask,pc),d0
		cmp.l		(RealThisTask,pc),d0
		beq.b		PowerVisorCrashed
		move.l	(a7)+,d0
		move.l	#CrashRoutine,(a7)
		move.b	#1,(IsGuru)
		rts
	;PowerVisor has crashed
PowerVisorCrashed:
		enable
		lea		(MesPVAlertNum,pc),a0
		bsr		PrintCold
		move.l	(TrapAlertNum,pc),d0
		PRINTHEX
		lea		(MesPVParam,pc),a0
		bsr		PrintCold
		move.l	(TrapParameters,pc),d0
ContPVC:
		PRINTHEX
		ERROR		Crash
	;PowerVisor has crashed (for trap exceptions)
PowerVisorCrashed2:
		lea		(MesPVTrapNum,pc),a0
		bsr		PrintCold
		move.l	(TrapAlertNum,pc),d0
		bra.b		ContPVC

	;***
	;This is the routine where we return to when an exception occurs
	;This routine signals PowerVisor and waits
	;If PowerVisor enables it the routine continues with the
	;program that caused the exception
	;***
CrashRoutine:
		move.l	a7,(StackFrame)
		movem.l	d0-d7/a0-a6,-(a7)	;Remember all registers
		moveq		#cn_SIZE,d0
		suba.l	a0,a0
		bsr		MakeNodeInt			;Make crash node
		beq.b		SignalPV				;Not enough memory for crash node
		move.b	#NT_CRASH,(LN_TYPE,a0)
		move.l	(TrapThisTask,pc),(cn_Task,a0)
		move.l	(StackFrame,pc),(cn_SP,a0)
		move.l	(TrapParameters,pc),(cn_2ndInfo,a0)
		move.l	(TrapAlertNum,pc),(cn_TrapNumber,a0)
		move.b	(IsGuru,pc),(cn_Guru,a0)
		move.w	(TrapSR,pc),(cn_SR,a0)
		move.l	(TrapReturn,pc),(cn_PC,a0)
	;Copy all registers to internal buffer
		movea.l	a7,a1
		lea		(cn_Registers,a0),a2
		moveq		#14,d0				;15 regs

1$		move.l	(a1)+,(a2)+
		dbra		d0,1$

	;Add node to list
		movea.l	a0,a1
		move.l	a0,(NewCrashNode)
		lea		(Crashes,pc),a0
		CALLEXEC	AddHead
SignalPV:
		clr.b		(BackFromSignal)
		movem.l	(a7)+,d0-d7/a0-a6
		enable
		movea.l	(RealThisTask,pc),a1
		move.l	(CrashSigBit,pc),d0
		CALLEXEC	Signal
		moveq		#0,d0
		CALL		Wait
		move.b	#1,(BackFromSignal)
1$		bra.b		1$

	;***
	;This routine is the actual crash-handle routine
	;It is called by FuncKey
	;***
CrashSignal:
		move.l	(FrontSigSet),d0
		movea.l	(BreakTaskPtr),a1
		CALLEXEC	Signal
		NEWLINE

	;It could be a 'freeze' request for a bus error
		movea.l	(NewCrashNode,pc),a2
		move.l	(cn_PC,a2),d0
		cmp.l		(OriginalPC),d0
		bne.b		1$

	;Yes! We must clear the trace bit
		movea.l	(cn_Task,a2),a0
		movea.l	(TC_SPREG,a0),a4
		bsr		SkipStackFrame
		andi.b	#$3f,(4,a4)			;Disable trace mode for task
		move.b	#3,(cn_Guru,a2)	;BERR
		moveq		#ERR_PrgBERR,d0
		bsr		GetError
		bra.b		2$

1$		moveq		#ERR_PrgCrash,d0
		bsr		GetError
		lea		(TrapReturn,pc),a1
		moveq		#-1,d0
		cmp.l		(a1),d0
		bne.b		2$
	;Stack overflow
		moveq		#ERR_PrgStackOvf,d0
		bsr		GetError
2$		bsr		PrintAC
		NEWLINE
		bsr		PrintLine
		movea.l	(NewCrashNode,pc),a2
		bra		Print1Crashed

	;***
	;Search in the crashes list for a task
	;a0 = ptr to task (all other registers are preserved)
	;-> a0 = ptr to crash node if found
	;***
SearchCrashedTask:
		movem.l	a1/d0,-(a7)
		move.l	a0,d0
		suba.l	a0,a0
		lea		(Crashes,pc),a1
1$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		beq.b		2$
		cmp.l		(cn_Task,a1),d0
		bne.b		1$
	;We have found it
		movea.l	a1,a0
2$		movem.l	(a7)+,a1/d0
		rts

	;***
	;Check if a BPTR points to a Lock
	;d0 = BPTR to lock
	;-> d0 = unchanged
	;-> d1 = 1 if lock, 0 if no lock (flags are set)
	;***
CheckLock:
		movea.l	d0,a0
		adda.l	a0,a0
		adda.l	a0,a0

	;Check the access field
		move.l	(fl_Access,a0),d1
		addq.l	#-ACCESS_READ,d1
		beq.b		1$
		subq.l	#ACCESS_WRITE-ACCESS_READ,d1
		bne.b		2$

	;Check device list
1$		move.l	(fl_Volume,a0),d1
		lsl.l		#2,d1
		beq.b		3$
		movea.l	d1,a1
		move.l	(dl_Type,a1),d1
		bge.b		3$						;DLT_DEVICE
		subq.l	#4,d1					;to DLT_NONBINDING
		ble.b		3$

	;No lock
2$		moveq		#0,d1
		rts
	;Yes, a lock
3$		moveq		#1,d1
		rts

	;***
	;Get the size of the file corresponding with the lock
	;d0 = lock (BPTR)
	;-> d0 = size
	;-> preserves all other registers
	;***
SizeLock:
		movem.l	d1-d2/a0-a2,-(a7)
		move.l	d0,d1
		bsr		AllocFIB
		move.l	a7,d2
		CALLDOS	Examine
		move.l	(fib_Size,a7),d0
		movea.l	a2,a7
		movem.l	(a7)+,d1-d2/a0-a2
		rts

	;***
	;Convert a lock into a pathname
	;This function does not do DupLock, so it also works for WRITE locks
	;d0 = lock (BPTR)
	;a0 = ptr after the end of the pathname
	;-> a0 = ptr to the start of the pathname
	;***
ConstructPath:
		movem.l	d1-d4/a1-a4,-(a7)
		movea.l	a0,a3					;Preserve ptr after the pathname
		moveq		#1,d4					;Flag to indicate we are only starting
		clr.b		-(a3)
		movea.l	a3,a4
		subq.l	#1,a4					;a4 = ptr to last /
		move.l	d0,d3					;Preserve lock

		bsr		AllocFIB

NextDirCP:
		move.l	d3,d1
		move.l	a7,d2
		CALLDOS	Examine
		move.l	(fib_DirEntryType,a7),d0
		bmi.b		5$
		move.b	#'/',-(a3)
		movea.l	a3,a4
	;Copy filename to pathname
5$		lea		(fib_FileName,a7),a0
		move.l	a0,d0
1$		tst.b		(a0)+
		bne.b		1$
		sub.l		a0,d0
		neg.l		d0
		subq.l	#1,a0
		subq.l	#2,d0					;d0 = length of filename-1

2$		move.b	-(a0),-(a3)
		dbra		d0,2$

		move.l	d3,d1
		CALLDOS	ParentDir
		move.l	d3,d1
		move.l	d0,d3					;New lock
		tst.l		d4
		bne.b		3$						;Do not unlock if we have just started
		CALL		UnLock
3$		tst.l		d3
		beq.b		4$
		moveq		#0,d4					;From now on we may unlock
		bra.b		NextDirCP

4$		move.b	#':',(a4)
		movea.l	a3,a0
		movea.l	a2,a7					;Restore stack
		movem.l	(a7)+,d1-d4/a1-a4
		rts

	;***
	;Call a library function
	;a0 = ptr to arguments '( ... )'
	;d0 = offset
	;a6 = library ptr
	;d1 = argument information
	;d2 = argument information
	;-> a0 = after arguments (or 0, flags if error)
	;-> d0 = result of library function
	;***
CallLibFunc:
		movem.l	a1-a5/d2-d7,-(a7)
		lea		(-4,a7),a7			;Place where we can remember the rest of
											;the commandline later on (reference with 8(a5) )
		move.l	d2,-(a7)				;Place for 'argument information'
		move.l	d1,-(a7)				;Must be on stack because we must 
											;able to address it using an address register
		movea.l	a7,a5					;Remember pointer to this space

		lea		(-4,a7),a7			;Pointer to routine to return to after the
											;library function is ready (is filled in
											;later)
		adda.l	d0,a6					;Compute address to jump to
		move.l	a6,-(a7)				;Remember this address. We will 'jump' to this
											;address by calling 'rts'

		suba.l	d0,a6					;Restore pointer to library
		move.l	a6,-(a7)				;Remember library pointer (for library function)
		lea		(-14*4,a7),a7		;Place for registers (*1)

		moveq		#0,d7					;Argument number
		cmpi.b	#'(',(a0)+
		SERRne	BracketExp,ErrorCLF

	;Get all arguments and put them in the register stack (see *1)
LoopCLF:
		move.w	d7,d0					;Get argument number
		lsr.w		#1,d0					;Divide by two
		move.b	(0,a5,d0.w),d0		;Get byte containing info for argument #d7
		btst		#0,d7					;Test if argument number is even or odd
		bne.b		1$
		lsr.b		#4,d0					;Even, select left four bits for argument info
1$		andi.b	#$f,d0				;Mask out other bits (four remaining bits are info)
		addq.w	#1,d7					;Next argument
		cmpi.b	#$f,d0				;Register 15 does not exist, so end of args
		beq.b		EndLoopCLF
		moveq		#0,d6
		move.b	d0,d6					;Register number in d6
		lsl.w		#2,d6					;Offset in stack area for register
	;Get argument
		bsr		Evaluate
		beq.b		ErrorCLF
		move.l	d0,(0,a7,d6.w)		;Store value for register in register space on stack
		bra.b		LoopCLF				;Next argument

	;All arguments are parsed
EndLoopCLF:
		cmpi.b	#')',(a0)+
		SERRne	ToManyArgs,ErrorCLF
		move.l	a0,(8,a5)				;Remember pointer to rest of commandline

		movem.l	(a7)+,d0-d7/a0-a6	;Get all registers (all arguments are in here)
		move.l	#BackCLF,(4,a7)		;Return to this address
		rts								;'Jump' to library routine

	;The library function 'returns' to this routine
BackCLF:
		lea		(8,a7),a7				;Remove 'argument information' from stack
		movea.l	(a7)+,a0				;Restore pointer to rest of commandline
EndCLF:
		move.l	a0,d2					;For flags
		movem.l	(a7)+,a1-a5/d2-d7
		rts

	;There was an error in the parsing of the arguments
ErrorCLF:
		movea.l	a5,a7					;Restore stack to a 'known' state
		lea		(12,a7),a7			;Remove rest of stack
		suba.l	a0,a0					;Error
		bra.b		EndCLF


	;***
	;Convert a string to an offset and a library ptr
	;a0 = string (there may be quotes)
	;-> d0 = offset (0, flags if no success)
	;-> d1 = register information
	;-> d2 = register information
	;-> a6 = library ptr
	;***
StringToLib:
		movem.l	a2-a5/d3-d7,-(a7)
		movea.l	a0,a4
		lea		(OffsString,pc),a1
		moveq		#4,d0
		bsr		CompareCI
		bne.b		NoOffsSTL
	;The user gave the keyword 'offs', we interprete the next 2 arguments
	;as the library and the offset
		movea.l	a4,a0
		bsr		GetString			;Skip 'offs'
		beq.b		ErrorSTL
		moveq		#I_LIBS,d6
		bsr		SetList
		bsr		Evaluate				;library ptr
		beq.b		ErrorSTL
		bsr		ResetList
		move.l	d0,d6
		bsr		Evaluate				;Offset
		beq.b		ErrorSTL
		movea.l	d6,a6
		moveq		#0,d1
		moveq		#0,d2

EndSTL:
		tst.l		d0
		SERReq	NoSupportedLibFunc
		tst.l		d0						;For flags
		movem.l	(a7)+,a2-a5/d3-d7
		rts

	;Error
ErrorSTL:
		moveq		#0,d0
		bra.b		EndSTL

NoOffsSTL:
		movea.l	a4,a0

		cmpi.b	#'''',(a0)
		bne.b		5$
		lea		(1,a0),a0

5$		bsr		ParseName			;Get library function name
		beq.b		3$
		bsr		AddAutoClear
		beq.b		4$

		cmpi.b	#'''',(a0)
		bne.b		6$
		lea		(1,a0),a0

	;a0 points to end of string
6$		move.l	a0,-(a7)
		movea.l	d0,a4
	;a4 points to start of new string containing the library function name

		lea		(FDFiles,pc),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$
		movea.l	(fd_Block,a2),a1
		bsr.b		CallLibFuncSTL
		bra.b		1$

2$		movea.l	(a7)+,a0
3$		moveq		#0,d0					;Error
		bra.b		EndSTL

4$		movea.l	d0,a0
		bsr		FreeBlock
		bra.b		3$

CallLibFuncSTL:
		movea.l	a4,a0
		moveq		#0,d4					;Counter to function
		lea		(GetNextListLF,pc),a5
		movea.l	a2,a6					;Ptr to our node (for GetNextListLF)
		bsr		SearchWordEx
		tst.l		d1
		beq.b		1$

		lea		(4,a7),a7			;Skip rts
		movea.l	d1,a0					;Pointer in table
		move.l	(4,a0),d1
		move.l	(8,a0),d2
		movea.l	(fd_Library,a2),a6
		moveq		#0,d0
		move.w	(fd_Bias,a2),d0
		subq.w	#1,d4
		mulu.w	#6,d4
		add.w		d4,d0
		neg.l		d0						;Real offset
		movea.l	(a7)+,a0
		bra		EndSTL
1$		rts

	;***
	;GetNext routine for library funtion lists (fd-files)
	;List format: <Ptr to string>,<reg info>,<reg info>	(all long)
	;<0>,<...> to end
	;***
GetNextListLF:
		moveq		#1,d6					;Dummy
		move.l	(a1),d0
		movea.l	(fd_String,a6),a3
		adda.l	d0,a3
		addq.w	#1,d4					;Counter to functions (for offset)
		lea		(12,a1),a1			;Next function
		cmpi.l	#-1,d0
		beq.b		1$
		rts
1$		moveq		#0,d0
		movea.l	d0,a1
		rts

	;***
	;Allocate a signal
	;a2 = ptr to SigNum
	;-> (a2) = SigNum
	;-> 4(a2) = SigSet
	;***
AllocSignal:
		moveq		#-1,d0
		CALLEXEC	AllocSignal
		move.l	d0,(a2)+
		moveq		#1,d1
		lsl.l		d0,d1
		move.l	d1,(a2)
		rts

	;***
	;Install a device
	;a0 = ptr to name
	;a1 = flags for OpenDevice
	;d0 = unit number
	;d1 = size of IORequest
	;-> d0 = IORequest (or zero if fail) (flags are set)
	;-> d1 = Port (or zero if fail)
	;***
InstallDevice:
		movem.l	d2-d4/a2-a4,-(a7)
		move.l	d0,d2					;Unit nr
		move.l	d1,d3					;IOReq size
		movea.l	a0,a2					;Ptr to dev name
		movea.l	a1,a4					;Flags
		bsr		CreatePort
		move.l	d0,d4					;Remember port
		beq.b		EndRemoveRD
		move.l	d3,d0
		move.l	#MEMF_CLEAR+MEMF_PUBLIC,d1
		bsr		AllocMem
		movea.l	d0,a3					;Remember IORequest
		tst.l		d0
		beq.b		DeletePortRD
		move.b	#NT_MESSAGE,(LN_TYPE,a3)
		move.w	d3,(MN_LENGTH,a3)
		move.l	d4,(MN_REPLYPORT,a3)
		movea.l	a2,a0					;Name
		move.l	a4,d1					;Flags
		movea.l	a3,a1					;IORequest
		move.l	d2,d0					;Unit nr
		CALLEXEC	OpenDevice
		tst.b		(IO_ERROR,a3)
		bne.b		DeleteIOReqRD
		move.l	d4,d1
		move.l	a3,d0
		movem.l	(a7)+,d2-d4/a2-a4
		rts

	;***
	;Remove a device
	;a0 = Port (can be zero)
	;a1 = IORequest (can be zero)
	;-> d0 = 0
	;-> d1 = 0
	;***
RemoveDevice:
		movem.l	d2-d4/a2-a4,-(a7)
		move.l	a0,d4					;Port
		movea.l	a1,a3					;IOReq
		move.l	a1,d0
		beq.b		DeletePortRD
		moveq		#0,d3
		move.w	(MN_LENGTH,a1),d3
		CALLEXEC	CloseDevice
DeleteIOReqRD:
		movea.l	a3,a1
		move.l	d3,d0
		bsr		FreeMem
DeletePortRD:
		move.l	d4,d0
		beq.b		EndRemoveRD
		movea.l	d0,a1
		bsr		DeletePort
EndRemoveRD:
		movem.l	(a7)+,d2-d4/a2-a4
		moveq		#0,d0
		move.l	d0,d1
		rts

	;***
	;Install trackdisk device
	;d2 = unit number
	;-> d0 = DiskRequestB or zero if fail
	;***
InstallTrackDisk:
		move.l	d2,d0
		moveq		#IOTD_SIZE,d1
		suba.l	a1,a1
		lea		(DiskDevice,pc),a0
		bsr		InstallDevice
		lea		(DiskRequestB,pc),a0
		move.l	d0,(a0)
		lea		(DiskPort,pc),a0
		move.l	d1,(a0)
		rts

	;***
	;Remove Trackdisk device
	;-> d0 = 0
	;***
RemoveTrackDisk:
		move.l	(DiskRequestB,pc),d0
		beq.b		1$
		movea.l	d0,a1
		movea.l	(DiskPort,pc),a0
		bsr		RemoveDevice
1$		lea		(DiskRequestB,pc),a0
		move.l	d0,(a0)
		lea		(DiskPort,pc),a0
		move.l	d0,(a0)
		rts

	;***
	;Install timer device
	;a2 = pointer to pointer to timer request
	;-> d0 = TimerRequest or zero if fail (flags)
	;-> a2 = unchanged
	;***
InstallTimer:
		moveq		#UNIT_MICROHZ,d0
		moveq		#IOTV_SIZE,d1
		suba.l	a1,a1
		lea		(TimerDevice,pc),a0
		bsr		InstallDevice
		move.l	d0,(a2)
		move.l	d1,(4,a2)
		rts

	;***
	;Remove timer device
	;a2 = pointer to pointer to timer request
	;-> d0 = 0
	;-> a2 = unchanged
	;***
RemoveTimer:
		move.l	(a2),d0
		beq.b		1$
		movea.l	d0,a1
		movea.l	(4,a2),a0
		bsr		RemoveDevice
		move.l	d0,(a2)
1$		move.l	d0,(4,a2)
		rts


;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

;	CNOP	0,4
;fInfoBlock:		ds.b	fib_SIZEOF

MesFuncLoaded:	dc.b	"New functions: ",0
MesAccountOff:	dc.b	"Account is now off",10,0
MesAccountOn:	dc.b	"Account is now on",10,0
MesPVAlertNum:	dc.b	"AlertNum:   ",0
MesPVParam:		dc.b	"Parameters: ",0
MesPVTrapNum:	dc.b	"TrapNumber: ",0
MesAllocR:		dc.b	"(AllocRast)",0
MesAllocMem:	dc.b	"(AllocMem)",0
MesAllocVec:	dc.b	"(AllocVec)",0
MesAllocSig:	dc.b	"(AllocSig)",0
MesCreateMP:	dc.b	"(CreateMP)",0
MesCreateIO:	dc.b	"(CreateIO)",0
MesLock:			dc.b	"(Lock)",0
MesOpen:			dc.b	"(Open)",0
MesWait:			dc.b	"Wait  : ",0
MesReady:		dc.b	"Ready : ",0

StrDummyFunc:	dc.b	"_DUMMY_()()",0

	EVEN
	;***
	;Start of GeneralBase
	;***
GeneralBase:

RealThisTask:	dc.l	0				;Ptr to this task
StackBound:		dc.l	0				;Bound for stack failure

DiskRequestB:	dc.l	0				;For trackdisk device
DiskPort:		dc.l	0

ExecTrapCode:	dc.l	0				;Remember exec trap code
MMUType:			dc.l	0				;MMU present or not (0,68851,68030,68040)
p68020:			dc.w	0				;1 if 68020 or highter

AccountBlock:	dc.l	0				;Block with account tasks
OldSwitch:		dc.l	0				;Old Switch and Alert
OldAlert:		dc.l	0
OldAddTask:		dc.l	0
OldAutoRequest:dc.l	0
StackFailL:		dc.l	40				;When the stack checker must fail

CrashSBNum:		dc.l	0
CrashSigBit:	dc.l	0				;Signal bit mask for crash trapping

Freezed:			ds.b	LH_SIZE		;List for freezed tasks
Crashes:			ds.b	LH_SIZE		;Crashed tasks
FDFiles:			ds.b	LH_SIZE		;List for loaded fd files
FunctionsMon:	ds.b	LH_SIZE		;Monitored functions

Port:				ds.b	mp_SIZE		;Our public port
					dc.b	0				;OBSOLETE
OldPri:			dc.b	0				;Old priority

STimerRequest:	dc.l	0				;For timer device
STimerPort:		dc.l	0
StackMax:		dc.l	0				;Maximum stack usage
StackTask:		dc.l	0				;Task to monitor
StackMicros:	dc.l	0				;Number of micro seconds to wait

TrackTask:		dc.l	0
TrackFirst:		dc.l	0

ProfDNode:		dc.l	0				;Debug node to profile
ProfMicros:		dc.l	0				;Number of micro seconds to wait
ProfWait:		dc.l	0				;Number of ticks the debug node waited
ProfReady:		dc.l	0				;Number of ticks the debug node was ready
ProfTableSize:	dc.l	0				;Table with all profiling information
ProfTablePtr:	dc.l	0

	;***
	;End of GeneralBase
	;***

PTimerRequest:	dc.l	0				;For timer device
PTimerPort:		dc.l	0

PortName:		dc.b	"PowerVisor-port"
PortNameEnd:	dc.b	0,0,0

DiskDevice:		dc.b	"trackdisk.device",0
TimerDevice:	dc.b	"timer.device",0

;FormatLibFunc:	dc.b	"%08lx %6.d (",0
FormatLibFunc:
		FF		X_,0,d_,6,str,"(",end,0

DNodeGoneMsg:	dc.b	"?",0

;FormatProfile:	dc.b	"%-40.40s (%08lx) : %ld",0
FormatProfile:
		FF		ls_,40,str,"(",X,0,str_,")"
		FF		str_,":",D,0,end,0

HeaderHunk:		dc.b	"Nr    Hunk     Data         Size",10,0
;FormatHunk:		dc.b	"%5.d %08lx %08lx %8.ld",0
FormatHunk:
		FF		d_,5,X_,0,X_,0,D,8
		FF		end,0

;FormatRegs:		dc.b	"D0: %08lx   D1: %08lx   D2: %08lx   D3: %08lx",10
;					dc.b	"D4: %08lx   D5: %08lx   D6: %08lx   D7: %08lx",10
;					dc.b	"A0: %08lx   A1: %08lx   A2: %08lx   A3: %08lx",10
;					dc.b	"A4: %08lx   A5: %08lx   A6: %08lx",10
;					dc.b	"PC: %08lx   SP: %08lx   SR: %04x",10,0
FormatRegs:
		FF		str_,"D0:",X,0,spc,3
		FF		str_,"D1:",X,0,spc,3
		FF		str_,"D2:",X,0,spc,3
		FF		str_,"D3:",X,0,nl,0

		FF		str_,"D4:",X,0,spc,3
		FF		str_,"D5:",X,0,spc,3
		FF		str_,"D6:",X,0,spc,3
		FF		str_,"D7:",X,0,nl,0

		FF		str_,"A0:",X,0,spc,3
		FF		str_,"A1:",X,0,spc,3
		FF		str_,"A2:",X,0,spc,3
		FF		str_,"A3:",X,0,nl,0

		FF		str_,"A4:",X,0,spc,3
		FF		str_,"A5:",X,0,spc,3
		FF		str_,"A6:",X,0,nl,0

		FF		str_,"PC:",X,0,spc,3
		FF		str_,"SP:",X,0,spc,3
		FF		str_,"SR:",x,0,nlend,0

RegsLibFunc:	dc.b	"D0D1D2D3D4D5D6D7A0A1A2A3A4A5A6A7"

	;Possible argument for the StringToLib function
OffsString:		dc.b	"offs",0
	;Possible arguments for the AddFunc command
OnlyString:		dc.b	"only",0
AFArgLed:		dc.b	"led",0
AFArgFull:		dc.b	"full",0
AFArgFullLed:	dc.b	"fullled",0
AFArgExec:		dc.b	"exec",0
AFArgScratch:	dc.b	"scratch",0

	EVEN
	;Corresponding routines for each AddFunc argument
AddFuncModes:	dc.l	AFArgLed,LedAF
					dc.l	AFArgFull,FullAF
					dc.l	AFArgFullLed,FullLedAF
					dc.l	AFArgExec,ExecAF
					dc.l	AFArgScratch,ScratchAF
					dc.l	0,0

NewCrashNode:	dc.l	0
TrapReturn:		dc.l	0
TrapThisTask:	dc.l	0
TrapSR:			dc.w	0
TrapAlertNum:	dc.l	0
TrapParameters:dc.l	0
StackFrame:		dc.l	0
IsGuru:			dc.b	0

OptTrackStr:	dc.b	"TSCL",0
OptProfStr:		dc.b	"TSCL",0
	EVEN
OptTrackRout:	dc.l	TakeTRK,StopTRK,CleanupTRK,ListTRK,ErrorTRK
OptProfRout:	dc.l	TakePRF,StopPRF,ClearPRF,ListPRF,ErrorPRF

TaskHeldMsg:	dc.b	"Software error -",0
TaskHeldMsgLen	equ	*-TaskHeldMsg

	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	END
