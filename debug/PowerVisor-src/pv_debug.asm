*****
****
***			D E B U G   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Mon Apr  4 17:01:44 1994
***			© Jorrit Tyberghein
****
*****

 * Part of PowerVisor source   Copyright © 1994   Jorrit Tyberghein
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

			INCLUDE	"pv.debug.i"
			INCLUDE	"pv.general.i"
			INCLUDE	"TileWindows.i"

			INCLUDE	"pv.errors.i"

	XDEF		DebugConstructor,DebugDestructor
	XDEF		RoutSymbol,RoutDebug,RoutTrace,RoutBreak,GetSymbolVal
	XDEF		RoutDMode,RoutDPref,DebugRefresh,RoutDUse,SearchBreakPoint
	XDEF		FuncDebug,DebugList,CheckIfTrace,CurrentDebug,GetSymbolStr
	XDEF		DebugSP,DebugSigSet,InDebugTask,PrintInfoTR,FuncGetSymStr
	XDEF		TraceSigSet,InTaskWait,BackFromSignal,SetAdditional
	XDEF		SkipStackFrame,ChangeSPBreakTV,RoutWith,RoutDScroll
	XDEF		ScrollDebug,RoutDStart,PCScrollDebug,FuncTopPC,FuncBotPC
	XDEF		FuncIsBreak,RoutDRefresh,DebugBase,DebugRegsInfo,ContTrace
	XDEF		m68881,RoutSource,GotoSourceLine,GotoSourceLineNoSBar,GetPCForLine
	XDEF		UpdateDisplay,SymbolVicinity,CheckDirty,RoutDPrevI,RoutDNextI
	XDEF		RoutWatch
	IFD D20
	XDEF		UpdateSourceSBar
	ENDC

	;eval
	XREF		Evaluate,GetNextByteE,ScanOptions,GetStringE
	XREF		GetStringPer,SkipSpace,Upper,ChangeSPSigSet
	XREF		GetRestLinePer,GetRegister,Sort
	;memory
	XREF		DefaultLengthUA,DisasmBreak,SmartUnAsm,CommonUA
	XREF		StoreRC,MakeNodeInt,AllocStringInt,ViewPrintLine
	XREF		FreeBlock,AllocClear,ReAllocMem,AllocBlockInt
	XREF		BinarySearch,AddString,InsertMem,RemoveMem
	XREF		AllocMem,FreeMem,ReAlloc
	XREF		BlockSize,ReAllocMemBlock
	;main
	XREF		AllocSignal,MasterPV,CheckModeBit,ClearModeBit
	XREF		DosBase,ArpBase,Storage,Dummy
	XREF		FastFPrint,GetError,Remind,ErrorHandler
	XREF		ExecAlias,PVBreakSigSet,CheckBreak
	XREF		Forbid,Permit,Disable,Enable,LastError
	XREF		PrintFor,PrintForQ
	;list
	XREF		DbModesString,SetList,ResetList
	;screen
	XREF		PrintAC,SourceLW,LogWin_Attribute
	XREF		MsgPrint,DebugLW,WatchLW,LogWin_Print,LogWin_PrintChar,LogWin_Home
	XREF		LogWin_Locate,LogWin_Clear,CurrentLW
	XREF		LogWin_SetWindowTitle,LogWin_HiLight,LogWin_SetSBarValue
	;general
	XREF		DumpRegsNL,DumpRegs,AddPAddress,ProfDNode
	XREF		Freezed,RealThisTask,SearchCrashedTask,RemoveCrashDirect
	XREF		CommonDR,CheckAddTaskPatch,PatchAddTask
	XREF		p68020
	;mmu
	XREF		FlushCacheSuper,FlushCache,GetVBR
	;file
	XREF		FOpen,FClose,FSeek,FRead,OpenDos,SearchPath

;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	super

	;***
	;Constructor: initialize all debug variables
	;-> flags eq if no success
	;***
DebugConstructor:
		moveq		#0,d0
		lea		(m68881,pc),a2
		move.l	d0,(a2)
		movea.l	(SysBase).w,a6
		move.w	(AttnFlags,a6),d0
		btst		#4,d0					;68881
		beq.b		1$
		moveq		#4,d0
		move.l	d0,(a2)
1$		lea		(DebugList,pc),a0
		NEWLIST	a0
		lea		(TraceSigNum,pc),a2
		bsr		AllocSignal
		lea		(DebugSigNum,pc),a2
		bsr		AllocSignal
		moveq		#1,d0					;Success !
		rts

	;***
	;Destructor: remove all debug things
	;***
DebugDestructor:
		moveq		#mo_Dirty,d0
		bsr		ClearModeBit
		bsr		CheckDirty

	;Remove all debug nodes
		lea		(DebugList,pc),a2
		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		1$
		moveq		#1,d0					;Freeze task
		bsr		RemoveDebugDirect
		bra.b		DebugDestructor

1$		move.l	(TraceSigNum,pc),d0
		CALLEXEC	FreeSignal
		move.l	(DebugSigNum,pc),d0
		CALL		FreeSignal
		rts

	;***
	;Update status line in debug display
	;Used to reflect that we are tracing, executing, ...
	;Called by the 'trace' command
	;***
UpdateStatus:
		movem.l	d0-d7/a0-a6,-(a7)
		bsr		GetDispDebugNode
		bne.b		1$

		move.l	a2,d0
		beq.b		1$

	;Init logical window
		move.l	(DebugLW),d0
		beq.b		1$
		movea.l	d0,a0
		bsr		LogWin_Home
		bsr		DisplayStatus
1$		movem.l	(a7)+,d0-d7/a0-a6
		rts

	;***
	;Print the current PC instruction hilighted
	;All other instructions in the disassembly are ignored
	;The instruction is also disassembled again to correct offsets
	;and fd-file functions
	;PC instruction must be on screen for this subroutine to work
	;d0 = Line number (starting with 1 and relative to start code dump)
	;a0 = Debug logical window
	;a2 = Debug node
	;a4 = StackFrame
	;***
PrintCurrentPC:
		move.w	d0,d7					;Remember linenumber
		moveq		#7,d6
		lea		(DebugPrevInfo,pc),a6
		tst.w		(a6)
		beq.b		1$
	;Yes, we must add two lines
		addq.w	#2,d6

	;Disassemble current instruction
1$		moveq		#0,d0
		move.w	d6,d1
		add.w		d7,d1
		subq.w	#1,d1
		bsr		LogWin_Locate
		move.l	a0,-(a7)
		move.l	(a4),d6				;Get address current instruction
		bsr		CommonUA
		movea.l	a0,a1
		movea.l	(a7)+,a0

		moveq		#100,d0
		bsr		LogWin_Print

		moveq		#1,d0					;Set hilighting
		move.w	(LogWin_row,a0),d1
		bra		LogWin_HiLight

	;***
	;Show the debug display
	;***
RoutDRefresh:
UpdateDisplay:
		bsr		GetDispDebugNode
		beq.b		4$
		rts

4$		move.l	(DebugLW),d0
		beq.b		1$

		movea.l	d0,a0
		bsr		LogWin_Clear

1$		move.l	(SourceLW),d0
		beq.b		2$

		movea.l	d0,a0
		bsr		LogWin_Clear

2$		move.l	(CurrentDebug,pc),d0
		beq.b		3$
		movea.l	d0,a1
		move.b	#DBF_SOURCE+DBF_DEBUG,(db_Dirty,a1)	;Our debug window needs a full refresh
3$
	;Fall through

	;***
	;Command: refresh the full debug screen
	;***
DebugRefresh:
		movem.l	d0-d7/a0-a6,-(a7)

	;First update the source
	;If db_Dirty is true, we update everything
		bsr		GetDispDebugNode
		bne.b		1$

		move.l	a2,d0
		beq.b		7$

		bclr		#DBB_SOURCE,(db_Dirty,a2)
		beq.b		4$
		bsr		GetDebugSource
		beq.b		4$
		clr.l		(srcf_BottomLine,a1)	;Force a refresh
		bsr		UpdateSourceTitle
4$		bsr		ShowSource

	;Update the watch logical window
7$		bsr		UpdateWatchWindow

	;Update the debug logical window
		move.l	(DebugLW),d0
		beq		1$
		movea.l	d0,a0
		move.l	(CurrentDebug,pc),d0
		beq		2$
		move.l	(db_Task,a2),d0
		beq.b		1$
	;Init logical window
		bsr		LogWin_Home
		bsr		DisplayStatus
		bsr		DisplayRegs
		bclr		#DBB_DEBUG,(db_Dirty,a2)
		beq.b		5$

	;Our debug window is very dirty, we must clean it up
		bsr		CheckIfPCOnScreen
		beq.b		6$
		move.l	(db_TopPC,a2),d6
		bra.b		6$

	;Our debug window is rather clean
5$		bsr		CheckIfPCOnScreen
		beq.b		6$
		bsr		PrintCurrentPC
		bra.b		1$

	;No, PC is not on screen
6$		bsr		DisplayCode

1$		movem.l	(a7)+,d0-d7/a0-a6
		rts

	;Show user that no program is loaded
2$		lea		(MesNoTaskLoad,pc),a1
		moveq		#70,d0
		bsr		LogWin_Print
		bra.b		1$

	;***
	;Display status line in debug display
	;a2 = Debug node
	;***
DisplayStatus:
		cmpa.l	(CurDispDebug,pc),a2
		bne.b		1$

		moveq		#0,d0
		move.b	(db_Mode,a2),d0
		mulu.w	#5,d0
		lea		(DbModesString),a1
		lea		(0,a1,d0.w),a1
		moveq		#5,d0
		bsr		LogWin_Print
		moveq		#10,d0
		bra		LogWin_PrintChar

1$		rts

	;***
	;Display the registers in the debug display
	;a0 = DebugLW
	;a2 = Debug node
	;-> a4 = stackframe
	;-> a0 = LogWin
	;***
DisplayRegs:
		cmpa.l	(CurDispDebug,pc),a2
		bne.b		1$

		move.l	(db_Task,a2),d0
		beq.b		1$
		bsr		GetStackFrame
		move.l	(db_SP,a2),d6
		movem.l	a0/a3-a5,-(a7)
		bsr		CommonDR
		movea.l	a0,a1
		movem.l	(a7)+,a0/a3-a5
		move.l	#32000,d0
		bsr		LogWin_Print
		moveq		#10,d0
		bra		LogWin_PrintChar
1$		rts

	;***
	;Function: check if an address contains a breakpoint in the current
	;debug node
	;-> d0 = type of breakpoint+(breakpoint number<<16) or 0
	;***
FuncIsBreak:
		bsr		GetDebugNodeE
		EVALE
		lea		(db_BreakPoints,a2),a3
2$		movea.l	(a3),a3				;Succ
		tst.l		(a3)					;Succ
		beq.b		1$
		cmp.l		(bp_Where,a3),d0
		bne.b		2$
	;Found it !
		moveq		#0,d0
		move.w	(bp_Number,a3),d0
		swap		d0
		move.b	(bp_Type,a3),d0
		rts
	;Not found !
1$		moveq		#0,d0
		rts

	;***
	;Function: get the programcounter at the top of the display
	;***
FuncTopPC:
		bsr		GetDebugNodeE
		move.l	(DebugLW),d0
		beq.b		1$
		move.l	(db_TopPC,a2),d0
1$		rts

	;***
	;Function: get the programcounter at the bottom of the display
	;***
FuncBotPC:
		bsr		GetDebugNodeE
		move.l	(DebugLW),d0
		beq.b		1$
		move.l	(db_BotPC,a2),d0
1$		rts

	;***
	;Get the current debug node
	;This function does not return if the debug node does not exists
	;-> a2 = debug node
	;-> preserves all other registers
	;***
GetDebugNodeE:
		move.l	d0,-(a7)
		move.l	(CurrentDebug,pc),d0
		ERROReq	NoCurrentDebug
		movea.l	d0,a2
		move.l	(a7)+,d0
		rts

	;***
	;Check if we are using the display debug node
	;-> Z flag set if yes (or Z flag set if there is no current debug node)
	;-> a2 = current debug node
	;***
GetDispDebugNode:
		move.l	(CurrentDebug,pc),d0
		beq.b		1$
		cmp.l		(CurDispDebug,pc),d0

1$		movea.l	d0,a2					;Don't disturb flags
		rts

	;***
	;Scroll debug task to PC
	;***
PCScrollDebug:
		move.l	(CurrentDebug,pc),d0
		beq.b		1$
		movea.l	d0,a2
		move.l	(db_Task,a2),d0
		beq.b		1$
		bsr		GetStackFrame
		move.l	(a4),d1
		bra.b		SetScrollDebug
1$		rts

	;***
	;Scroll up to the previous instruction
	;***
RoutDPrevI:
		move.l	(CurrentDebug,pc),d0
		bne.b		3$
		rts
3$		movea.l	d0,a2
		bsr		GetStackFrame

		move.l	(db_TopPC,a2),d2
		move.l	d2,d3					;Remember TopPC
		moveq		#24,d1
		sub.l		d1,d2					;Start 24 bytes earlier

	;Disassemble instructions until we find one that it big enough
2$		movea.l	(Storage),a0
		move.l	d2,d0					;Address
		bsr		DisasmBreak
		add.l		d2,d0
		cmp.l		d3,d0
		beq.b		1$
		addq.l	#2,d2
		cmp.l		d3,d2
		blt.b		2$

	;We didn't find the right instruction, simply scroll 2 bytes back
		moveq		#-2,d1
		bra		ScrollDebug

	;We found an instruction that disassembles until just before our current
	;instruction
1$		move.l	d2,d1
		sub.l		d3,d1
		bra		ScrollDebug

	;***
	;Scroll down to the next instruction
	;***
RoutDNextI:
		move.l	(CurrentDebug,pc),d0
		beq.b		1$
		movea.l	d0,a2
		bsr		GetStackFrame

		move.l	(db_TopPC,a2),d0
		movea.l	(Storage),a0
		bsr		DisasmBreak			;d0=size of current instruction
		move.l	d0,d1
		bra		ScrollDebug
1$		rts

	;***
	;Command: scroll the debug code to an address
	;***
RoutDStart:
		EVALE
		move.l	d0,d1
	;Fall through

	;***
	;Start disassembly on a specific memory location in debug window
	;d1 = address
	;***
SetScrollDebug:
		bclr		#0,d1					;Make address even
		move.l	(CurrentDebug,pc),d0
		beq.b		1$
		movea.l	d0,a2
		move.l	(db_TopPC,a2),d0
		sub.l		d0,d1
		bra.b		ScrollDebug
1$		rts

	;***
	;Command: scroll the debug code
	;***
RoutDScroll:
		EVALE
		move.l	d0,d1
	;Fall through

	;***
	;Scroll the debug code disassembly
	;d1 = number of bytes to advance
	;***
ScrollDebug:
		bclr		#0,d1					;Make number of bytes even
		move.l	(DebugLW),d0
		bne.b		1$
	;No debug logical window or no current debug
2$		rts
1$		movea.l	d0,a0

		bsr		GetDispDebugNode
		bne.b		2$

		move.l	a2,d0
		beq.b		2$

		move.l	(db_TopPC,a2),d6
		add.l		d1,d6
		move.l	(db_Task,a2),d0
		beq.b		2$
		bsr		GetStackFrame
		moveq		#0,d0
		moveq		#7,d1
		bsr		LogWin_Locate
		bsr.b		DisplayCode
		bsr		CheckIfPCOnScreen
		beq.b		2$
	;Yes, PC is on screen
		bra		PrintCurrentPC

	;***
	;Display code in the debug display
	;a0 = DebugLW
	;a2 = Debug node
	;a4 = Stack frame
	;d6 = Instruction to start disassembly with
	;-> a0 = LogWin
	;-> a4 = stackframe
	;***
DisplayCode:
		cmpa.l	(CurDispDebug,pc),a2
		bne.b		3$

		move.l	a4,-(a7)
		lea		(DebugPrevInfo,pc),a6
		tst.w		(a6)
		beq.b		1$
	;Disassemble previous instruction
		move.l	d6,-(a7)
		move.l	(db_Instruction,a2),d6
		move.l	a0,-(a7)

		move.l	a4,-(a7)
		suba.l	a4,a4
		bsr		CommonUA
		movea.l	(a7)+,a4

		movea.l	a0,a1
		movea.l	(a7)+,a0
		move.l	#32000,d0
		bsr		LogWin_Print
		moveq		#10,d0
		bsr		LogWin_PrintChar
		bsr		LogWin_PrintChar
		move.l	(a7)+,d6
	;Disassemble the other instructions
1$		moveq		#0,d7
		move.w	(DebugShowInfo,pc),d7
		movea.l	a4,a5

2$		bsr.b		UnasmForDebug
		movea.l	(a7)+,a4
3$		rts

	;***
	;This routine disassembles instructions for the debug task and sets up
	;the size table and debug node.
	;a2 = pointer to debug node
	;d6 = address
	;d7 = number of instructions
	;a0 = Logical window for output
	;a5 = stackframe
	;-> a0 = LogWin
	;***
UnasmForDebug:
		lea		(db_i1,a2),a3		;Ptr to sizetable
		bclr		#0,d6					;Make address even
		move.l	d6,(db_TopPC,a2)	;Adjust top PC in debug node
		subq.w	#1,d7
		move.l	a0,-(a7)
		moveq		#0,d4					;We have not encountered the programcounter yet

	;Check if this is the program counter, hilight if true
1$		movea.l	(a7),a0				;Logical window
		suba.l	a4,a4					;Assume no stackframe for 'CommonUA'
		cmp.l		(a5),d6
		bne.b		2$

	;Equal to programcounter, we must hilight and set a4 to the real stackframe
		movea.l	a5,a4
		moveq		#1,d0					;Yes there is hilight
		move.w	(LogWin_row,a0),d1
		bsr		LogWin_HiLight
		moveq		#1,d4					;Yes! We have encountered the program counter

2$		bsr		CommonUA
		move.b	d0,(a3)+
		movea.l	a0,a1
		movea.l	(a7),a0
		move.l	#32000,d0
		bsr		LogWin_Print
		moveq		#10,d0
		bsr		LogWin_PrintChar
		dbra		d7,1$

	;End
		move.l	d5,(db_BotPC,a2)	;Adjust bot PC in debug node (d5 = result from 'CommonUA')
		movea.l	(a7)+,a0

		tst.l		d4
		bne.b		3$

	;We have not encountered the program counter, so we must remove the hilighting
		moveq		#0,d0
		moveq		#-1,d1
		bsr		LogWin_HiLight

3$		rts

	;***
	;Check if PC is still on screen
	;a2 = debug node
	;-> d0 = 0 if not on screen or linenumber if on screen (flags)
	;-> d6 = programcounter
	;-> a0 = unchanged
	;***
CheckIfPCOnScreen:
		move.l	(db_Task,a2),d0
		beq.b		1$
		bsr		GetStackFrame
		move.l	(a4),d6				;Get PC
		cmp.l		(db_TopPC,a2),d6
		blt.b		1$
		cmp.l		(db_BotPC,a2),d6
		bgt.b		1$

	;Yes, PC is still on screen, compute linenumber
		lea		(db_i1,a2),a1
		move.w	(DebugShowInfo,pc),d1
		subq.w	#1,d1					;Number of lines - 1
		move.l	(db_TopPC,a2),d2	;Address
		moveq		#1,d0					;Linenumber count
		moveq		#0,d3					;Scratch register

	;For each line on screen
2$		cmp.l		d6,d2
		beq.b		3$
		move.b	(a1)+,d3				;Get number of bytes for current instruction
		add.l		d3,d2					;Advance address
		addq.w	#1,d0					;Next line on screen
		dbra		d1,2$

	;If we come here, the PC is not on the screen. The instructions disassembled
	;are wrong

	;No, PC is not on screen
1$		moveq		#0,d0
		rts

	;We have found the linenumber
3$		tst.l		d0
		rts

	;***
	;Routine used by several debug commands to jump to the right routine
	;according to the commandline option (used by 'RoutSymbol' and 'RoutSource')
	;JMP or BRA to this routine
	;a0 = cmdline
	;a3 = option string
	;a4 = table with routines
	;-> pc = routine
	;-> a0 = cmdline after option character
	;***
JumpOptRout:
		bsr		GetNextByteE
		move.l	a0,-(a7)
		movea.l	a3,a0
		movea.l	a4,a1
		bsr		ScanOptions
		movea.l	(a7)+,a0
		jmp		(a1)

	;***
	;Command: control source for debug node
	;***
RoutSource:
		bsr		GetDebugNodeE
		lea		(OptSourceStr,pc),a3
		lea		(OptSourceRout,pc),a4
		bra.b		JumpOptRout
SourceErrorRSR:
		ERROR		UnknownSourceArg

	;Load the source file information
SourceLoadRSR:
		move.l	(db_Source,a2),d0
		beq.b		4$
	;Source is already loaded, unload it first
		bsr		FreeAllSources

4$		move.l	(db_Task,a2),d0
		beq.b		1$
		movea.l	d0,a4
		cmpi.b	#NT_PROCESS,(LN_TYPE,a4)
		ERRORne	NotAProcess
1$		bsr		GetStringE
		movea.l	d0,a3
		suba.l	a4,a4
		tst.l		(db_Task,a2)
		beq.b		3$
		NEXTTYPE
		beq.b		2$
3$		EVALE								;Get hunk pointer
		movea.l	d0,a4
2$		bsr		LoadDebugHunks
		HERReq
		tst.l		d0
		ERROReq	NoDebugHunks
		bra		DebugRefresh

	;Where in the source is this address ?
SourceWhereRSR:
		move.l	(db_Source,a2),d0
		ERROReq	NoSourceLoaded
		movea.l	d0,a3
		EVALE								;Get address
		bsr		WhereInSource
		ERROReq	NotInSource
		movea.l	(srcf_FileName,a0),a0
		PRINT
		lea		(MesColon,pc),a0
		PRINT
		PRINTHEX
		rts

	;Show all source files
SourceShowRSR:
		move.l	(db_Source,a2),d0
		ERROReq	NoSourceLoaded
1$		movea.l	d0,a3
		movea.l	(srcf_FileName,a3),a0
		PRINT
		NEWLINE
		move.l	(srcf_Next,a3),d0
		bne.b		1$
		rts

	;Goto a source line and file (address is given)
SourceGotoAddressRSR:
		move.l	(db_Source,a2),d0
		ERROReq	NoSourceLoaded
		EVALE								;Get address
		bra		ShowSourceAddress

	;Goto a source line
SourceGotoLineRSR:
		EVALE								;Get linenumber
		move.l	d0,d2
		move.l	(SourceLW),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	d2,d0
		moveq		#1,d1					;Redraw always
		bsr		GotoSourceLine
1$		rts

	;Set the tab size
SourceSetTabSizeRSR:
		EVALE								;Get size
		lea		(TabSize,pc),a0
		move.w	d0,(a0)
		move.l	(db_Source,a2),d0
		bne.b		ForceSourceUpdate
		rts

	;Set hold/unhold source
SourceHoldRSR:
		EVALE
		move.w	d0,(db_HoldSource,a2)
		rts

	;Unload the source
SourceClearRSR:
		move.l	(db_Source,a2),d0
		ERROReq	NoSourceLoaded
		bra		FreeAllSources

	;Show the current source file on the Source logical window
SourceCurrentRSR:
		move.l	(db_Source,a2),d0
		ERROReq	NoSourceLoaded
	;Fall through to ForceSourceUpdate

	;Force an update for the current source
	;a2 = debug node
ForceSourceUpdate:
		bsr		GetDebugSource
		beq.b		1$
		clr.l		(srcf_BottomLine,a1)	;Force a refresh
		bsr		ShowSource
1$		rts

	;***
	;Command: load symbol table and control it
	;***
RoutSymbol:
		bsr		GetDebugNodeE
		lea		(OptSymbolStr,pc),a3
		lea		(OptSymbolRout,pc),a4
		bra		JumpOptRout

	;---
	;Error
	;---
SymbolErrorRS:
		ERROR		UnknownSymbolArg

	;---
	;Remove symbols
	;---
SymbolClearRS:
		bsr		ClearSymbols
		moveq		#0,d1
		bra		ScrollDebug

	;---
	;Clear all temporary symbols (starting with a dot '.' or ending with '$'
	;and containing only digits)
	;---
SymbolRemoveTempRS:
		lea		(db_SymbolSize,a2),a5
		movea.l	(db_SymbolStr,a2),a4
		move.l	(a5),d7				;Size of symbol space
		lsr.l		#3,d7					;Divide by 8 to get number of symbols
		ERROReq	NoSymbols
		subq.w	#1,d7					;For dbra
		movea.l	(4,a5),a5			;Get pointer to first symbol entry

1$		movea.l	(4,a5),a0			;Offset in string space
		adda.l	a4,a0					;Pointer in string space

		cmpi.b	#'.',(a0)			;Temporary symbol starting with a dot?
		beq.b		4$

5$		move.b	(a0)+,d0
		cmpi.b	#'$',d0
		beq.b		6$						;Remove, it is a number followed by a '$'
		subi.b	#'0',d0
		cmpi.b	#9,d0
		bhi.b		2$						;Don't remove, not a digit
		bra.b		5$						;It is a digit

6$		tst.b		(a0)					;But first check if the string stops after the '$'
		bne.b		2$

	;Yes, remove the symbol
4$		movea.l	a5,a1
		bsr		RemoveSymbol
		bra.b		3$						;Don't advance to next symbol

2$		lea		(8,a5),a5			;Next symbol
3$		dbra		d7,1$

		moveq		#0,d1
		bra		ScrollDebug

	;---
	;Add a symbol
	;---
SymbolAddRS:
		bsr		GetStringE
		move.l	d0,d2
		EVALE								;Symbol value
		movea.l	d2,a0
		bsr		AddSymbol
		HERReq
		moveq		#0,d1
		bra		ScrollDebug

	;---
	;Remove a symbol
	;---
SymbolRemRS:
		bsr		GetStringE
		movea.l	d0,a0
		bsr		RemSymbol
		HERReq
		moveq		#0,d1
		bra		ScrollDebug

	;---
	;List all symbols
	;---
SymbolShowRS:
		lea		(db_SymbolSize,a2),a5
		movea.l	(db_SymbolStr,a2),a4
		move.l	(a5),d7
		lsr.l		#3,d7
		ERROReq	NoSymbols
		subq.w	#1,d7
		movea.l	(4,a5),a5

1$		lea		(FormatSymbols,pc),a0
		move.l	(a5),-(a7)
		move.l	(a5)+,-(a7)
		move.l	(a5)+,d0
		lea		(0,a4,d0.l),a3
		move.l	a3,-(a7)
		move.l	(Storage),d0
		movea.l	a7,a1
		bsr		FastFPrint
		lea		(12,a7),a7
		bsr		ViewPrintLine
		dbra		d7,1$
		rts

	;---
	;Simply load the symbols
	;---
SymbolLoadRS:
		move.l	(db_Task,a2),d0
		beq.b		1$
		movea.l	d0,a4
		cmpi.b	#NT_PROCESS,(LN_TYPE,a4)
		ERRORne	NotAProcess
1$		bsr		GetStringE
		movea.l	d0,a3
		suba.l	a4,a4
		tst.l		(db_Task,a2)
		beq.b		3$
		NEXTTYPE
		beq.b		2$
3$		EVALE								;Get hunk pointer
		movea.l	d0,a4
2$		bsr		ClearSymbols
		bsr.b		LoadSymbols
		HERReq
		tst.l		d0
		ERROReq	NoSymbolHunks
		moveq		#0,d1
		bra		ScrollDebug

	;---
	;Subroutine: load debug hunks
	;a3 = filename
	;a2 = debug node
	;a4 = pointer to hunk list or 0
	;d0 = Compiler type (0 = macro68, 1 = SAS/C (-d1)) (not used yet)
	;-> d0 = 1 if success, 0 if no debug hunks
	;-> d1 = 0, flags if error
	;---
LoadDebugHunks:
		movea.l	d0,a5					;Remember compiler type
		moveq		#1,d5					;Load debug hunks
		bra.b		LoadSymDebug

	;---
	;Subroutine: load symbols
	;a3 = filename
	;a2 = debug node
	;a4 = pointer to hunk list or 0
	;-> d0 = 1 if success, 0 if no symbol hunks
	;-> d1 = 0, flags if error
	;---
LoadSymbols:
		moveq		#0,d5					;Load symbols

	;d5 = 0 for symbols, 1 for debug hunks
LoadSymDebug:
		moveq		#0,d6					;No symbols yet
		move.l	a4,d0
		bne.b		12$

	;Pointer to hunk list is 0
		movea.l	(db_Task,a2),a4
		move.l	(pr_CLI,a4),d0
		beq.b		9$

	;It is a cli, so we use the cli_Module instead of the pr_SegList
		lsl.l		#2,d0
		movea.l	d0,a4					;ptr to cli
		move.l	(cli_Module,a4),d0
		bra.b		10$
9$		move.l	(pr_SegList,a4),d0
		lsl.l		#2,d0					;BPTR->APTR
		movea.l	d0,a4
		move.l	(12,a4),d0			;Get ptr first seglist
10$	lsl.l		#2,d0
		movea.l	d0,a4
		lea		(4,a4),a4

	;Entry point if hunks are given (in a4)
12$	move.l	a3,d1					;Filename
		bsr		FOpen
		beq		13$					;Error
		move.l	d0,d7					;Ptr to filehandle

	;Main loop
1$		move.l	#Dummy,d2
		moveq		#8,d3
		move.l	d7,d1
		bsr		FRead					;Read hunk type
		subq.l	#8,d0
		beq.b		8$

	;End of loop (without errors)
14$	bsr		CleanupLoadSym
		move.l	d6,d0
		moveq		#1,d1					;No error, flags
		rts

	;Check the type of the hunk
8$		move.l	(Dummy),d0
;	andi.l	#$00ffffff,d0
		subi.w	#$3e7,d0
		beq.b		2$						;UNIT
		subq.w	#1,d0
		beq.b		2$						;NAME
		subq.w	#1,d0
		beq.b		2$						;CODE
		subq.w	#1,d0
		beq.b		2$						;DATA
		subq.w	#1,d0
		beq.b		1$						;BSS
		subq.w	#1,d0
		beq.b		3$						;RELOC32
		subq.w	#1,d0
		beq.b		3$						;RELOC16
		subq.w	#1,d0
		beq.b		3$						;RELOC8
		subq.w	#1,d0
		beq.b		4$						;EXT
		subq.w	#1,d0
		beq.b		11$					;SYMBOL
		subq.w	#1,d0
		beq.b		15$					;DEBUG
		subq.w	#1,d0
		beq.b		5$						;END
		subq.w	#1,d0
		beq		6$						;HEADER
		bra.b		4$

	;Handle symbol hunk
11$	tst.l		d5
		bne.b		16$
		moveq		#1,d6					;Yes there are symbols
		bsr		SymbolRS
		bne		1$

	;There was an error
17$	bsr		CleanupLoadSym
13$	moveq		#0,d1					;Error (flags)
		rts

16$	bsr		SkipSymbolHunk
		bra		1$

	;Handle debug hunk
15$	tst.l		d5
		beq.b		2$
		moveq		#1,d6					;Yes there are debug hunks
		bsr		DebugRS
		beq.b		17$					;Error
		bra		1$

	;Ext, Overlay, Break
4$		SERR		NotAValidExecFile
		bra.b		17$

	;Normal hunks with size
2$		move.l	(Dummy+4),d2		;Get size
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		bra		1$

	;Reloc32,16,8
3$		move.l	(Dummy+4),d2
		beq		1$
		addq.l	#1,d2
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		move.l	#Dummy+4,d2
		moveq		#4,d3
		bsr		FRead
		bra.b		3$

	;End
5$		moveq		#-4,d2				;HUNK_END is only 4 bytes, not 8
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek

	;Go to next hunk
		move.l	(-4,a4),d0
		beq		14$
		lsl.l		#2,d0
		movea.l	d0,a4
		lea		(4,a4),a4
		bra		1$

	;Header
6$		move.l	(Dummy+4),d2
		beq.b		7$
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		move.l	#Dummy+4,d2
		moveq		#4,d3
		bsr		FRead
		bra.b		6$
7$		move.l	#Dummy,d2
		moveq		#12,d3
		bsr		FRead
		move.l	(Dummy+8),d2
		sub.l		(Dummy+4),d2
		addq.l	#1,d2
		lsl.l		#2,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		bra		1$

	;Close file handle and sort symbol table (if needed)
CleanupLoadSym:
		move.l	d7,d1
		bsr		FClose
		tst.l		d5
		bne.b		1$
	;Symbols
		bsr		SortSymbolTable
1$		rts

	;Skip symbol hunk
SkipSymbolHunk:
		moveq		#-4,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
1$		moveq		#4,d3
		move.l	(Storage),d2
		move.l	d7,d1
		bsr		FRead
		movea.l	(Storage),a0
		move.l	(a0),d2
		beq.b		2$
		addq.l	#1,d2
		lsl.l		#2,d2					;Length of string+4 (extra value)
		move.l	d7,d1
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek					;Skip this string
		bra.b		1$
2$		rts								;Return to caller of 'LoadSymbols'

	;Symbol
	;-> flags eq if error
SymbolRS:
		moveq		#-4,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
1$		moveq		#4,d3
		move.l	(Storage),d2
		move.l	d7,d1
		bsr		FRead
		movea.l	(Storage),a0
		move.l	(a0),d3
		beq.b		2$
		addq.l	#1,d3
		lsl.l		#2,d3
		move.l	d3,d4
		move.l	(Storage),d2
		addq.l	#4,d2
		bsr		FRead
		movea.l	(Storage),a0
		addq.w	#4,a0
		move.l	(-4,a0,d4.l),d0
		add.l		a4,d0
		bsr		AppendSymbol
		bne.b		1$

	;Error
		moveq		#0,d1					;Error (flags)
		rts

	;No error
2$		moveq		#1,d1					;Flags
		rts

	;Debug hunk
	;a5 = compiler type
	;-> flags eq if error
DebugRS:
		move.l	a5,-(a7)
		move.l	(Dummy+4),d4		;Get size in longwords
		lsl.l		#2,d4
		moveq		#4,d3
		move.l	(Storage),d2
		move.l	d7,d1
		bsr		FRead					;Get offset in current hunk to add with
											;other following offsets
		subq.l	#4,d4					;Decrement remaining size in debug hunk
		movea.l	(Storage),a0
		movea.l	(a0),a5				;a5 = offset
		move.l	a5,d0
		bne.b		5$
	;If offset = 0 we must ignore it (this is the case for SAS/C). We
	;will add one to the offset so that it will become 0 again later
		lea		(1,a5),a5

5$		moveq		#8,d3
		move.l	(Storage),d2
		move.l	d7,d1
		bsr		FRead					;Read 'LINE' <len>
		subq.l	#8,d4					;Decrement remaining size in debug hunk
		movea.l	(Storage),a0
		move.l	(a0),d0
		cmp.l		#'LINE',d0
		bne		3$

	;Read the name of the source file
		move.l	(4,a0),d3
		lsl.l		#2,d3					;Length of string to read
		clr.l		(0,a0,d3.l)			;NULL-terminate the string
		sub.l		d3,d4					;Decrement remaining size in debug hunk
		move.l	d7,d1
		move.l	(Storage),d2
		bsr		FRead
		movea.l	(Storage),a0
		bsr		AddSourceFile
		beq.b		4$

	;Success!
	;The remaining debug hunk is the list of <line numbers> and
	;<offsets>
		movea.l	d0,a3					;Remember pointer to source structure
		move.l	d4,(srcf_LinesSize,a3)
		move.l	d4,d0
		bsr		AllocClear
		beq.b		4$

	;Success!
		move.l	d0,(srcf_Lines,a3)
		move.l	d0,d2
		move.l	d4,d3
		move.l	d7,d1
		bsr		FRead

	;All things have been allocated and loaded, we must now relocate the
	;offsets in the 'Lines' block to the correct addresses

		subq.l	#1,a5					;Make offset one smaller
		lsr.l		#3,d4					;Number of lines in set
		movea.l	(srcf_Lines,a3),a0
	;We assume there is at least one line
1$		lea		(4,a0),a0
		move.l	(a0),d0
		add.l		a5,d0					;Add global offset
		add.l		a4,d0					;Hunk start
		move.l	d0,(a0)+
		subq.l	#1,d4
		bgt.b		1$

		movea.l	(a7)+,a5				;Restore compilertype
		moveq		#1,d1					;No error (flags)
		rts

	;Error
4$		movea.l	(a7)+,a5				;Restore compilertype
		moveq		#0,d1					;Error (flags)
		rts

	;This debug hunk does not contain line number information, skip it
3$		move.l	d4,d2					;Remaining size to skip
		move.l	d7,d1
		moveq		#OFFSET_CURRENT,d3
		movea.l	(a7)+,a5				;Restore compilertype
		bra		FSeek					;Skip it

	;***
	;Add a source file to a debug node
	;a0 = ptr to file name
	;a2 = ptr to debug node
	;-> d0 = pointer to source file structure or 0 (flags) if error
	;***
AddSourceFile:
		bsr		AllocStringInt
		beq.b		1$
		move.l	d0,-(a7)
		moveq		#srcf_SIZE,d0
		bsr		AllocClear
		bne.b		2$
	;Error allocating structure, free string first
		movea.l	(a7)+,a0				;Get pointer to string
		bsr		FreeBlock
		moveq		#0,d0					;Indicate there is an error
		bra.b		1$
	;No error
2$		movea.l	d0,a0					;Ptr to structure
		move.l	(a7)+,d0
		move.l	d0,(srcf_FileName,a0)
		movea.l	(db_Source,a2),a1
		move.l	a1,(srcf_Next,a0)
		move.l	a1,d0
		beq.b		3$
	;There is already another source file
		move.l	a0,(srcf_Prev,a1)
	;There is no other source file
3$		move.l	a0,(db_Source,a2)
		move.l	a0,d0					;Ptr to structure
1$		rts

	;***
	;Remove a source file from a debug node
	;a0 = ptr to the source file structure
	;a2 = ptr to debug node
	;***
RemSourceFile:
		bsr		UnloadSource
		move.l	a0,-(a7)
		movea.l	(srcf_FileName,a0),a0
		bsr		FreeBlock

		movea.l	(a7),a0
		move.l	(srcf_LineBuf,a0),d0
		beq.b		6$
	;Free the linebuffer information
		movea.l	d0,a1
		move.l	(srcf_NumLines,a0),d0
		lsl.l		#2,d0
		bsr		FreeMem

6$		movea.l	(a7)+,a0

		move.l	(srcf_Next,a0),d0
		beq.b		1$
	;There is a next
		movea.l	d0,a1
		move.l	(srcf_Prev,a0),(srcf_Prev,a1)
	;There is no next
1$		move.l	(srcf_Prev,a0),d0
		beq.b		2$
	;There is a prev
		movea.l	d0,a1
		move.l	(srcf_Next,a0),(srcf_Next,a1)
		bra.b		3$
	;There is no prev
2$		move.l	(srcf_Next,a0),(db_Source,a2)

	;Remove the lines information and the loaded source
3$		move.l	a0,-(a7)
		move.l	(srcf_LinesSize,a0),d0
		move.l	(srcf_Lines,a0),d1
		beq.b		4$
		movea.l	d1,a1
		bsr		FreeMem
4$		movea.l	(a7),a0
		move.l	(srcf_FileSize,a0),d0
		move.l	(srcf_File,a0),d1
		beq.b		5$
		movea.l	d1,a1
		bsr		FreeMem
5$		movea.l	(a7)+,a1
		moveq		#srcf_SIZE,d0
		bra		FreeMem

	;***
	;Unload the text for a source file structure
	;a0 = pointer to source file structure
	;-> a0 = preserved
	;***
UnloadSource:
		move.l	a0,-(a7)
		move.l	(srcf_FileSize,a0),d0
		move.l	(srcf_File,a0),d1
		beq.b		1$
		movea.l	d1,a1
		bsr		FreeMem
1$		movea.l	(a7)+,a0
		clr.l		(srcf_File,a0)
		rts

	;***
	;Scan source for line buffer information if this information is
	;not already present
	;a0 = pointer to the source file structure (source must be loaded)
	;***
ScanSource:
		move.l	(srcf_LineBuf,a0),d0
		bne.b		1$
	;The linenumber table has not been computed yet
	;First scan the file to count the number of lines
		movem.l	a2/d2,-(a7)
		moveq		#1,d2							;Counter for the number of lines
		movea.l	a0,a2							;Remember pointer to source structure
		movea.l	(srcf_File,a2),a1			;Pointer to source buffer
		move.l	(srcf_FileSize,a2),d1	;Size of source buffer
2$		move.b	(a1)+,d0
		subq.l	#1,d1
		beq.b		3$
		cmp.b		#10,d0						;LineFeed
		bne.b		2$
		addq.l	#1,d2							;One line extra
		bra.b		2$

	;d2 contains the number of lines in the file
3$		move.l	d2,d0
		lsl.l		#2,d0							;*4
		bsr		AllocClear
		beq.b		4$								;Error ?

		move.l	d0,(srcf_LineBuf,a2)
		move.l	d2,(srcf_NumLines,a2)

		movea.l	(srcf_File,a2),a1			;Pointer to source buffer
		move.l	(srcf_FileSize,a2),d1	;Size of source buffer
		moveq		#0,d2							;Init position in buffer
		movea.l	d0,a2							;a2 = pointer to linebuffer

		move.l	d2,(a2)+						;Fill in first offset in table

	;Fill in the table
5$		move.b	(a1)+,d0
		addq.l	#1,d2							;Increment position
		subq.l	#1,d1
		beq.b		4$
		cmp.b		#10,d0
		bne.b		5$
	;Extra line
		move.l	d2,(a2)+
		bra.b		5$

4$		movem.l	(a7)+,a2/d2
1$		rts

	;***
	;Load the text for a source file structure
	;If this routine fails (because the source file does not exist for
	;example) srcf_File will be set to NULL
	;a0 = pointer to source file structure
	;a1 = pointer to source path
	;-> a0 = preserved
	;***
LoadSource:
		movem.l	a0/a2/d2-d3/d6-d7,-(a7)
		movea.l	a0,a2
		move.l	(srcf_File,a2),d1
		bne.b		1$

	;Source file is not loaded yet
		movea.l	(srcf_FileName,a2),a0
		bsr		SearchPath
		beq.b		1$						;File not found

		move.l	d0,d1					;d0 = found filename
		move.l	d0,d6					;Rememer so that we can free it
		moveq		#MODE_OLDFILE-1000,d2
		bsr		OpenDos
		movea.l	d6,a0					;First free filename
		bsr		FreeBlock
		move.l	d0,d7					;Remember filehandle
		beq.b		1$

		move.l	d7,d1
		moveq		#0,d2
		moveq		#OFFSET_END,d3
		CALL		Seek
		move.l	d7,d1
		moveq		#0,d2
		moveq		#OFFSET_BEGINNING,d3
		CALL		Seek					;-> d0 = filesize
		move.l	d0,(srcf_FileSize,a2)
		bsr		AllocClear
		beq.b		2$						;Not enough memory
		move.l	d0,(srcf_File,a2)
		move.l	d7,d1
		move.l	d0,d2
		move.l	(srcf_FileSize,a2),d3
		CALLDOS	Read					;Read file
		clr.l		(srcf_TopLine,a2)
		clr.l		(srcf_BottomLine,a2)

		movea.l	a2,a0
		bsr		ScanSource

2$		move.l	d7,d1
		CALLDOS	Close

	;Source file is already loaded or success
1$		movem.l	(a7)+,a0/a2/d2-d3/d6-d7
		rts

	;***
	;Copy a line in a source file to the destination while converting
	;tabs to spaces
	;a0 = ptr to source structure
	;d0 = line number
	;-> a0 = pointer to line
	;***
GotoLineInSource:
		movea.l	(srcf_LineBuf,a0),a1
		subq.l	#1,d0
		lsl.l		#2,d0
		move.l	(0,a1,d0.l),d0
		add.l		(srcf_File,a0),d0
		movea.l	d0,a0
		rts

	;***
	;Copy a line in a source file to the destination while converting
	;tabs to spaces, this function does not use the linetable and can
	;be used to go some number of lines further
	;a0 = ptr in source
	;a1 = ptr to destination
	;d0 = line number (or next line if 2)
	;-> a0 = pointer to line
	;-> d0 = length of line (tabs converted)
	;-> d1 = length of line in file (tabs not converted)
	;***
GetLineInSource:
		move.l	d2,-(a7)

	;Search the line
6$		subq.l	#1,d0
		beq.b		2$

1$		move.b	(a0)+,d2
		cmpi.b	#10,d2
		bne.b		1$

		bra.b		6$

	;Found line
2$		moveq		#0,d0					;Init length
		move.l	d0,d1					;Init length in file
		move.l	a0,-(a7)
3$		addq.l	#1,d1					;Add 1 to length in file
		move.b	(a0)+,d2
		beq.b		4$
		cmpi.b	#10,d2
		beq.b		4$
		cmpi.b	#9,d2
		beq.b		5$
		move.b	d2,(a1)+
		addq.l	#1,d0					;Add 1 to length
		bra.b		3$

4$		movea.l	(a7)+,a0
		clr.b		(a1)+
		move.l	(a7)+,d2
		rts

	;Handle tabs
5$		move.l	d0,d2
		divu.w	(TabSize,pc),d2
		swap		d2						;d2.w = 0..(TabSize-1)
		sub.w		(TabSize,pc),d2
		neg.w		d2						;d2.w = number of spaces to add
		bra.b		8$

7$		move.b	#' ',(a1)+			;Add space
		addq.l	#1,d0					;Add 1 to length
8$		dbra		d2,7$

		bra.b		3$

	;***
	;Show source line for program counter for the current debug task
	;If the source logical window is not locked, it will jump to the
	;programcounter
	;a2 = pointer to debug node
	;***
ShowSource:
		tst.l		(db_Task,a2)
		bne.b		1$
		rts

1$		bsr		GetStackFrame
		move.l	(a4),d0				;PC
		move.w	(db_HoldSource,a2),d5
		bra.b		InShowSourceAddress

	;d0 = address to show source for
ShowSourceAddress:
		moveq		#0,d5					;Scroll if needed
InShowSourceAddress:
		move.l	(SourceLW),d1
		beq.b		3$
		movea.l	d1,a0

		move.l	(db_Source,a2),d1
		bne.b		5$
3$		rts

5$		move.l	a0,-(a7)
		move.l	d0,d2					;Remember address
		move.w	d5,d1
		bsr		GetSource
		beq.b		1$
		bsr		GetStackFrame
		movea.l	(db_CurrentSource,a2),a3
		tst.l		(srcf_File,a3)
		beq		ErrLoadingSource

		tst.w		d5
		bne.b		2$						;Only hilighting
		move.l	d0,(srcf_LineNumber,a3)	;d0 = result from 'GetSource'

	;If the address is equal to the programcounter we must reinitialize
	;the db_PCLineNumber field in the debug node
	;This field determines the hilighted line
2$		cmp.l		(a4),d2
		bne.b		7$
		move.l	a3,(db_PCSourceFile,a2)
		move.l	d0,(db_PCLineNumber,a2)

7$		movea.l	(a7),a0
		move.l	(srcf_LineNumber,a3),d0
		moveq		#0,d1					;Do not redraw if not needed
		bsr		GotoSourceLine

1$		movea.l	(a7)+,a0
		rts

	;***
	;Show source line for the current debug task
	;and update scrollbar if possible
	;a0 = logwin
	;d0 = line in source
	;d1 = 0 for normal operation (only redraw if needed)
	;		1 if screen should be redrawn (to scroll for example)
	;***
GotoSourceLine:
	IFD D20
		bsr.b		GotoSourceLineNoSBar

	;***
	;Update the scrollbar for the 'Source' logical window
	;a0 = logwin
	;a2 = pointer to debug node
	;-> preserves all registers (except a6)
	;***
UpdateSourceSBar:
		movem.l	d0-d2/a0-a1,-(a7)
		moveq		#0,d1
		move.l	d1,d2
		move.l	a2,d0
		beq.b		1$

		bsr		GetDebugSource
		beq.b		1$

		move.l	(srcf_TopLine,a1),d0
		subq.l	#1,d0
		move.l	(srcf_NumLines,a1),d1
		subq.l	#1,d1
		move.l	(srcf_BottomLine,a1),d2
		sub.l		d0,d2
1$		bsr		LogWin_SetSBarValue

		movem.l	(a7)+,d0-d2/a0-a1
		rts
	ENDC

	;***
	;Show source line for the current debug task
	;but don't update scrollbar
	;a0 = logwin
	;d0 = line in source
	;d1 = 0 for normal operation (only redraw if needed)
	;		1 if screen should be redrawn (to scroll for example)
	;-> a0 = logwin
	;-> a2 = current debug node
	;***
GotoSourceLineNoSBar:
		move.l	a0,-(a7)
		movea.l	(CurrentDebug,pc),a2
		move.l	(db_Source,a2),d2
		bne.b		5$
4$		movea.l	(a7)+,a0
		rts

5$		move.l	d1,d4					;Remember redraw-bool
		move.l	d0,d2					;Remember linenumber
		bgt.b		3$
		moveq		#1,d2					;Linenumber was negative or 0

3$		move.l	(db_CurrentSource,a2),d0
		beq.b		4$
		movea.l	d0,a3
		tst.l		(srcf_File,a3)
		beq.b		4$

	;Erase previous program counter (not really needed, but it looks
	;cleaner (less flashing))
		movea.l	(a7),a0
		moveq		#0,d0
		moveq		#-1,d1
		bsr		LogWin_HiLight

	;Check if linenumber is visible
	;If d4 == true we redraw anyway
12$	tst.l		d4
		bne.b		11$
		move.l	(srcf_LineNumber,a3),d0
		cmp.l		(srcf_TopLine,a3),d0
		blt.b		11$
		cmp.l		(srcf_BottomLine,a3),d0
		ble		8$

	;Line is not visible
	;or d4 == true
11$	cmp.l		(srcf_NumLines,a3),d2
		ble.b		9$
		move.l	(srcf_NumLines,a3),d2

	;Start printing lines
9$		move.l	d2,(srcf_TopLine,a3)
		movea.l	(a7),a0
		bsr		LogWin_Home
		moveq		#0,d3
		move.w	(LogWin_NumLines,a0),d3
		subq.w	#2,d3
		ble		1$
		move.l	d2,d0					;Get linenumber
		move.l	d0,d1
		add.w		d3,d1
		subq.w	#1,d1
		move.l	d1,(srcf_BottomLine,a3)
		move.l	(srcf_File,a3),d1
		beq		ErrLoadingSource

	;Go to the first line
		movea.l	a3,a0
		bsr		GotoLineInSource

		moveq		#1,d0					;Goto this line (pointed to by a0)

	;d0 = linenumber to start with
	;a0 = pointer to source file buffer
2$		movea.l	(Storage),a1
		bsr		GetLineInSource
		movem.l	d0-d1/a0,-(a7)
		movea.l	(Storage),a1
		movea.l	(12,a7),a0
		moveq		#0,d0
		move.w	(LogWin_NumColumns,a0),d0
		subq.w	#3,d0
		bsr		LogWin_Print
		moveq		#10,d0
		bsr		LogWin_PrintChar
		movem.l	(a7)+,d0-d1/a0		;Restore pointer to line and length of line
		move.l	d1,d0					;Get length of line in file
		move.l	(srcf_File,a3),d1	;Begin of file
		add.l		(srcf_FileSize,a3),d1
		sub.l		d0,d1
		subq.l	#2,d1
		moveq		#2,d0					;Get the next line
		cmp.l		a0,d1
		dblt		d3,2$

		subq.w	#1,d3
		ble.b		8$

		movea.l	(a7),a0

7$		moveq		#10,d0
		bsr		LogWin_PrintChar
		dbra		d3,7$

	;Show where the program counter is
8$		moveq		#-1,d1
		move.l	d1,(srcf_HiLine,a3)
		cmpa.l	(db_PCSourceFile,a2),a3
		bne.b		13$
		move.l	(db_PCLineNumber,a2),d1
		sub.l		(srcf_TopLine,a3),d1
		blt.b		13$
		cmp.l		(srcf_BottomLine,a3),d1
		bgt.b		13$

	;Hilight
		move.l	d1,(srcf_HiLine,a3)

13$	move.l	(srcf_HiLine,a3),d1
		movea.l	(a7),a0
		moveq		#1,d0
		bsr		LogWin_HiLight

1$		movea.l	(a7)+,a0
		rts

	;The loading of the source seems to have failed, we print a message
	;stating this simple fact
	;LogWin is on stack
	;This routine also returns to caller
	;Call this routine will 'bra' or 'jmp'!
	;a3 = source structure
ErrLoadingSource:
		clr.l		(srcf_TopLine,a3)
		move.l	#2000000000,d0
		move.l	d0,(srcf_BottomLine,a3)
		movea.l	(a7),a0
		bsr		LogWin_Clear
		moveq		#70,d0
		lea		(MesNoSource,pc),a1
		bsr		LogWin_Print
		movea.l	(a7)+,a0
		rts

	;***
	;Get the source and line number for an address. If the address is not
	;in the current source file, the current source file is unloaded and
	;a new current source file is made
	;d0 = address
	;d1 = if 1 don't load another other source (simply return 0 in that case)
	;a2 = pointer to debug node
	;-> d0 = linenumber or 0 if not found in source (flags)
	;***
GetSource:
		movem.l	d2-d3,-(a7)

		move.l	d1,d3					;Remember flag

		moveq		#0,d2

		bsr		WhereInSource
		beq.b		1$
		move.l	d0,d2

		cmpa.l	(db_CurrentSource,a2),a0
		beq.b		1$

	;Current source is not equal to this new source
	;Test if we should load the other source
		moveq		#0,d0
		tst.w		d3
		bne.b		2$						;Don't load other source

	;Yes, load it
		move.l	a0,-(a7)
		move.l	(db_CurrentSource,a2),d0
		beq.b		3$
	;Unload current source
		movea.l	d0,a0
		bsr		UnloadSource
3$		movea.l	(a7)+,a0
		move.l	a0,(db_CurrentSource,a2)
		movea.l	(db_SourcePath,a2),a1
		bsr		LoadSource
	;Update window title bar
		bsr		UpdateSourceTitle

1$		move.l	d2,d0
2$		movem.l	(a7)+,d2-d3
		tst.l		d0
		rts

	;***
	;Update source window title bar
	;a2 = debug node
	;***
UpdateSourceTitle:
		move.l	(SourceLW),d0
		beq.b		1$
		movea.l	d0,a0
		bsr		GetDebugSource
		beq.b		2$
		movea.l	(srcf_FileName,a1),a1
2$		bsr		LogWin_SetWindowTitle
1$		rts

	;***
	;This function returns the closest PC for a line number
	;d0 = line number
	;-> d0 = PC or 0 if no source loaded or line number not in source file
	;***
GetPCForLine:
		movem.l	d2/a1-a2,-(a7)

		move.l	(CurrentDebug,pc),d1
		beq.b		1$
		movea.l	d1,a2

		move.l	(db_CurrentSource,a2),d1
		beq.b		1$
		movea.l	d1,a1

		movea.l	d0,a0					;Value to search

		move.l	(srcf_LinesSize,a1),d0
		move.l	(srcf_Lines,a1),d1
		beq.b		1$
		movea.l	d1,a1

		moveq		#8,d1
		bsr		BinarySearch
		movea.l	d0,a0					;a0 points to <line number> <offset>
		move.l	(4,a0),d0			;Get offset
		bra.b		2$

1$		moveq		#0,d0
2$		movem.l	(a7)+,d2/a1-a2
		rts

	;***
	;See where in the source the address is located
	;d0 = address
	;a2 = ptr to debug node
	;-> a0 = ptr to source structure
	;-> d0 = linenumber (or 0, flags if not in source)
	;***
WhereInSource:
		movem.l	d2/a3,-(a7)
		move.l	d0,d2

	;First look at the current source
		move.l	(db_CurrentSource,a2),d0
		beq.b		3$
		movea.l	d0,a3
		movea.l	a3,a0
		move.l	d2,d0
		bsr		WhereInThisSource
		bne.b		2$

	;Look at the other sources
3$		move.l	(db_Source,a2),d0
1$		movea.l	d0,a3
		movea.l	a3,a0
		move.l	d2,d0
		bsr		WhereInThisSource
		bne.b		2$
		move.l	(srcf_Next,a3),d0
		bne.b		1$

	;Not found!
		moveq		#0,d0

	;Found !
2$		movea.l	a3,a0
		movem.l	(a7)+,d2/a3
		tst.l		d0
		rts

	;***
	;See where in this specific source structure the address is located
	;d0 = address
	;a0 = pointer to source structure
	;a2 = debug node
	;-> d0 = linenumber (or 0, flags if not in source)
	;***
WhereInThisSource:
		movem.l	d2/a3,-(a7)
		movea.l	a0,a3
		move.l	d0,d2

	;Load source if this was not already done
		tst.l		(srcf_File,a0)
		bne.b		1$
		movea.l	(db_SourcePath,a2),a1
		bsr		LoadSource

1$		movea.l	d2,a0
		move.l	(srcf_LinesSize,a3),d0
		movea.l	(srcf_Lines,a3),a1
		lea		(4,a1),a1			;Let a1 point to the <offset>
		moveq		#8,d1
		bsr		BinarySearch
		movea.l	d0,a0					;a0 points to <line number>  ^  <offset>   (to ^)
		move.l	(-4,a0),d0			;Get line number
		cmp.l		(a0),d2				;Compare offset
		beq.b		4$

	;Offset is not equal, not found
		moveq		#0,d0

4$		movem.l	(a7)+,d2/a3
		tst.l		d0
		rts

	;***
	;Append a symbol to the symboltable (don't sort)
	;You have to call 'SortSymbolTable' after calling this
	;function one or more times
	;a2 = ptr to debug node
	;a0 = ptr to symbol string
	;d0 = value
	;-> flags eq if error
	;***
AppendSymbol:
		movem.l	a3-a4/d2,-(a7)
		move.l	d0,d2
		lea		(db_SymbolStrSize,a2),a1
		bsr		AddString
		beq.b		1$
		subq.l	#1,d0
		movea.l	d0,a3

		lea		(db_SymbolSize,a2),a0
		move.l	(a0),d0
		moveq		#8,d1
		bsr		InsertMem
		beq.b		1$
		movea.l	(db_Symbol,a2),a0
		adda.l	d0,a0

		move.l	d2,(a0)+				;Value
		move.l	a3,(a0)				;Pointer to string
		moveq		#1,d0

1$		movem.l	(a7)+,a3-a4/d2
		rts

	;***
	;Sort the symbol table (useful after calling 'AppendSymbol' one or more
	;times)
	;a2 = ptr to debug node
	;***
SortSymbolTable:
		movea.l	(db_Symbol,a2),a0	;Buffer to sort
		move.l	(db_SymbolSize,a2),d0
		lsr.l		#3,d0					;Number of symbols
		moveq		#8,d1					;Size of each symbol
		lea		(CmpSymbol,pc),a1	;Compare routine
		bra		Sort

	;Subroutine: compare two symbols according to address
	;a0 = ptr to first entry
	;a1 = ptr to second entry
	;-> d0 = -1, 0 or 1
CmpSymbol:
		move.l	(a0),d0
		cmp.l		(a1),d0
		blt.b		1$
		bgt.b		2$
		moveq		#0,d0
		rts

1$		moveq		#-1,d0
		rts

2$		moveq		#1,d0
		rts

	;***
	;Add a symbol to the symboltable (sorted)
	;a2 = ptr to debug node
	;a0 = ptr to symbol string
	;d0 = value
	;-> d0 = 0 if error (flags)
	;***
AddSymbol:
		movem.l	a3-a4/d2,-(a7)
		move.l	d0,d2
		lea		(db_SymbolStrSize,a2),a1
		bsr		AddString
		beq.b		5$
		subq.l	#1,d0
		movea.l	d0,a3
		lea		(db_SymbolSize,a2),a0
		movea.l	#-8,a4
		tst.l		(a0)
		beq.b		8$
	;Yes there are already some symbols
		move.l	d2,d0
		bsr		SearchSymbol
		movea.l	d0,a4
		lea		(db_SymbolSize,a2),a0
		suba.l	(4,a0),a4			;a4 now is pos in symboltable
8$		lea		(8,a4),a4
		move.l	a4,d0					;Offset to insert our new element
		moveq		#8,d1
		bsr		InsertMem
		beq.b		5$
		movea.l	(db_Symbol,a2),a0
		lea		(0,a0,a4.l),a4		;Ptr to new symbol place
		move.l	d2,(a4)+
		move.l	a3,(a4)
		moveq		#1,d0
5$		movem.l	(a7)+,a3-a4/d2
		rts

	;***
	;Remove a symbol from a symbol table (does not remove string)
	;a2 = ptr to debug node
	;a0 = ptr to symbol string
	;-> d0 = 0, flags if error
	;***
RemSymbol:
		movea.l	a0,a1					;Ptr to symbol str

	;StrLen
1$		tst.b		(a1)+
		bne.b		1$

		move.l	a1,d1
		sub.l		a0,d1
		subq.l	#1,d1					;Length of string

		bsr		GetSymbolVal
		addq.l	#1,d0					;== -1 ?
		SERReq	NoSuchSymbol,2$

		bsr.b		RemoveSymbol
		moveq		#1,d0					;No error
		rts

2$		moveq		#0,d0					;Error
		rts

	;***
	;Remove a symbol entry (does not remove string)
	;a2 = ptr to debug node
	;a1 = ptr to symbol entry
	;***
RemoveSymbol:
		lea		(db_SymbolSize,a2),a0
		move.l	a1,d0					;Pointer to symbol entry
		sub.l		(4,a0),d0			;Offset in symbol space
		moveq		#8,d1
		bra		RemoveMem

	;***
	;Check if an address is in the vicinity of a symbol and return the
	;address of the symbol
	;a2 = debug node
	;d0 = address
	;d1 = range
	;-> d0 = address of closest symbol or 0 (flags) if not close to a
	;			symbol
	;***
SymbolVicinity:
		movem.l	d0-d1,-(a7)
		bsr.b		SearchSymbol
		movea.l	d0,a0
		movem.l	(a7)+,d0-d1
		cmpa.l	(db_Symbol,a2),a0
		blt.b		1$

		sub.l		d1,d0
		cmp.l		(a0),d0
		bgt.b		1$

		move.l	(a0),d0
		rts

	;Not close to a symbol
1$		moveq		#0,d0
		rts

	;***
	;Search a value in a symbol table
	;a2 = ptr to debug node
	;d0 = value
	;-> d0 = ptr to symbol in symbol table or position just where symbol
	;			should be added (note check if this position is before the first
	;			symbol)
	;***
SearchSymbol:
		movea.l	d0,a0					;Value
		lea		(db_SymbolSize,a2),a1
		move.l	(a1)+,d0				;Size
		movea.l	(a1),a1				;Ptr to start block
		moveq		#8,d1
		bra		BinarySearch

	;***
	;Clear symbol table for a debug task
	;a2 = ptr to debug node
	;***
ClearSymbols:
		move.l	a0,-(a7)
		lea		(db_SymbolSize,a2),a0
		moveq		#0,d0
		bsr		ReAllocMem
		lea		(db_SymbolStrSize,a2),a0
		moveq		#0,d0
		bsr		ReAllocMem
		movea.l	(a7)+,a0
		rts

	;***
	;Get symbol value
	;a2 = ptr to debug node
	;a0 = ptr to symbol string
	;d1 = len
	;-> d0 = symbol value (-1 if no symbols or not found)
	;-> a1 = ptr to symbol stub
	;***
GetSymbolVal:
		move.l	(db_Symbol,a2),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	(db_SymbolSize,a2),d0
		lsr.l		#3,d0
4$		tst.l		d0
		beq.b		1$
		movem.l	a0-a1/d0-d1,-(a7)
		movea.l	(4,a1),a1				;Ptr to string
		adda.l	(db_SymbolStr,a2),a1
2$		cmpm.b	(a0)+,(a1)+
		dbne		d1,2$
		move.b	(-1,a0),d0
		cmp.b		(-1,a1),d0
		movem.l	(a7)+,a0-a1/d0-d1
		beq.b		3$
		lea		(8,a1),a1
		subq.l	#1,d0
		bra.b		4$
	;Not found !
1$		moveq		#-1,d0
		rts
	;Found !
3$		move.l	(a1),d0
		rts

	;***
	;Function: return the pointer to the name for a symbol
	;or 0 if no symbol
	;***
FuncGetSymStr:
		bsr		GetDebugNodeE
		EVALE								;Get symbol address
	;Fall through

	;***
	;Get symbol string
	;a2 = ptr to debug node
	;d0 = symbol value
	;-> d0 = ptr to symbol string (or 0 if not found) (flags)
	;-> a0 = d0
	;-> a1 = pointer to symbol entry (if d0 != 0), otherwise undefined
	;***
GetSymbolStr:
		move.l	(db_Symbol,a2),d1
		beq.b		1$
		move.l	d0,-(a7)
		bsr		SearchSymbol
		movea.l	d0,a1
		move.l	(a7)+,d0

		cmpa.l	(db_Symbol,a2),a1
		blt.b		1$						;Not found!

		cmp.l		(a1),d0				;Not equal!
		bne.b		1$

		movea.l	(4,a1),a0			;Offset in stringtable
		adda.l	(db_SymbolStr,a2),a0

2$		move.l	a0,d0
		rts

	;No symbol string
1$		suba.l	a0,a0
		bra.b		2$

	;***
	;Command: execute a command with another debug task
	;***
RoutWith:
		bsr		GetDebugE
		movea.l	d0,a1

	;Get our command
		move.l	a1,-(a7)
		bsr		GetRestLinePer
		HERReq
		movea.l	d0,a0
		movea.l	(a7)+,a1

	;Establish an error routine to restore the current debug later on
		move.l	a0,-(a7)
		lea		(CurrentDebug,pc),a2
		move.l	(a2),-(a7)
		move.l	a1,(a2)
		moveq		#EXEC_WITH,d0
		bsr		ExecAlias
		move.l	d0,d2					;Save result
		move.l	d1,d3					;Error result

	;Clean up
		lea		(CurrentDebug,pc),a0
		move.l	(a7)+,(a0)
		movea.l	(a7)+,a0				;Get command line
		bsr		FreeBlock

	;Quit
		tst.l		d3
		HERReq
		move.l	d2,d0					;Command result
		rts

	;***
	;Command: set the current debugtask
	;a0 = cmdline
	;***
RoutDUse:
		bsr		GetDebugE
		lea		(CurrentDebug,pc),a0
		move.l	d0,(a0)
		lea		(CurDispDebug,pc),a0
		move.l	d0,(a0)
		bra		UpdateDisplay

	;***
	;Command: set the current debug preferences or display them
	;a0 = cmdline
	;***
RoutDPref:
		NEXTARG	2$
		tst.w		d0
		ERROReq	BadArgValue
		cmpi.w	#32,d0
		ble.b		3$
		ERROR		BadArgValue
3$		lea		(DebugShowInfo,pc),a6
		move.w	d0,(a6)
		NEXTARG	1$
		lea		(DebugPrevInfo,pc),a6
		move.w	d0,(a6)
	;Update debug mode display
1$		move.l	(CurrentDebug,pc),d0
		beq.b		4$
		movea.l	d0,a0
		clr.l		(db_TopPC,a0)
		clr.l		(db_BotPC,a0)
4$		bra		UpdateDisplay
	;Show preferences
2$		move.l	(DebugShowInfo,pc),d0
		PRINTHEX
		rts

	;***
	;Command: some debug preferences
	;a0 = cmdline
	;***
RoutDMode:
		lea		(DebugRegsInfo,pc),a2
		lea		(DebugCodeInfo,pc),a3
		bsr		SkipSpace
		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'R',d0
		beq.b		1$
		cmpi.b	#'F',d0
		beq.b		2$
		cmpi.b	#'N',d0
		beq.b		3$
		cmpi.b	#'C',d0
		beq.b		4$
		ERROR		BadDbModeArg
	;Install: display registers only after trace
1$		move.b	#1,(a2)
		clr.b		(a3)
		rts
	;Install: display registers and code after trace
2$		move.b	#1,(a2)
		move.b	#1,(a3)
		rts
	;Install: display nothing after trace
3$		clr.b		(a2)
		clr.b		(a3)
		rts
	;Install: display only code after trace
4$		clr.b		(a2)
		move.b	#1,(a3)
		rts

	;***
	;Get a debug node
	;a0 = cmdline
	;-> d0 = debug node
	;-> a2 = debug node
	;-> a0 = rest of cmdline
	;***
GetDebugE:
		moveq		#I_DEBUG,d6
		bsr		SetList
		EVALE
		bsr		ResetList
		movea.l	d0,a2
		cmpi.l	#'DBUG',(db_MatchWord,a2)
		ERRORne	NotADebugNode
		rts

	;***
	;Command: load and control debugtasks
	;a0 = cmdline
	;***
RoutDebug:
		move.b	(MasterPV),d0
		ERROReq	NotAllowedForSlave
		lea		(OptDebugStr,pc),a3
		lea		(OptDebugRout,pc),a4
		bra		JumpOptRout

	;---
	;Error
	;---
DebugErrorRDB:
		ERROR		UnknownDebugArg

	;---
	;Create dummy debug node for symbols
	;---
CreateDummyRDB:
		bsr		GetStringE			;Get name for dummy debug node
		movea.l	d0,a3
		movea.l	d0,a0
		bsr		MakeDebugNodeE
		lea		(DebugList,pc),a0	;Add our node to the list
		movea.l	a2,a1
		CALLEXEC	AddHead
		move.b	#DB_NONE,(db_Mode,a2)
		move.b	#%00000000,(db_TraceBits,a2)
		move.b	#DBS_WAIT,(db_SMode,a2)
		rts

	;---
	;Prevent a program from quiting
	;---
QuitCodeRDB:
		bsr		GetDebugNodeE
		EVALE
		tst.l		d0
		beq.b		1$

	;Prevent
		lea		(BeforeQuitCode,pc),a0
		bra.b		2$

	;Don't prevent, use PowerVisor quitcode routine (default)
1$		lea		(QuitCode,pc),a0
2$		movea.l	(db_PtrToQuitCode,a2),a1
		move.l	a0,(a1)
		rts

	;---
	;Catch the next task
	;---
CatchTaskRDB:
		moveq		#1,d2
		NEXTTYPE
		beq.b		3$
	;There is an optional parameter with the number of the task to
	;trap
		EVALE
		move.l	d0,d2

3$		lea		(PatchCounter,pc),a0
		move.w	d2,(a0)
		suba.l	a0,a0
		bsr		MakeDebugNodeE
		bsr		Forbid

	;Patch the 'AddTask' function
		movea.l	(SysBase).w,a6
		movea.l	a6,a1
		lea		(AddTaskIllegal,pc),a0
		move.l	a0,d0
		movea.l	#_LVOAddTask,a0
		CALL		SetFunction
		move.l	d0,-(a7)				;Remember old routine
		lea		(JmpAddTask+2,pc),a0
		move.l	d0,(a0)

	;Indicate that we do want to get a signal
		lea		(InTaskWait,pc),a6
		move.b	#1,(a6)

		bsr		Permit

	;Say we are waiting for the next task
		lea		(MesTaskWait,pc),a0
		bsr		PrintAC
	;Clear break signal
		moveq		#0,d0
		move.l	(PVBreakSigSet),d1
		CALLEXEC	SetSignal
	;Wait for break or debug signal
		move.l	(DebugSigSet,pc),d0
		or.l		(PVBreakSigSet),d0
		CALL		Wait
		move.l	d0,-(a7)

	;Unpatch the 'AddTask' function
		movea.l	(SysBase).w,a6
		movea.l	a6,a1
		movea.l	#_LVOAddTask,a0
		move.l	(4,a7),d0			;Get pointer to old routine
		CALL		SetFunction
		move.l	(a7)+,d0				;Restore signal
		lea		(4,a7),a7			;Clean up stack (ptr to old routine)

		and.l		(DebugSigSet,pc),d0
		bne.b		1$
	;It was not a signal from our debug task
	;I assume here that it is highly unlikely that someone breaks
	;and at the same time a program started, so I assume that no task has
	;fallen in our 'AddTask' patch trap.
		bsr		FreeDebugNode
		bra		CheckBreak

	;A signal from our debug task
1$		move.l	(Dummy+8),(Dummy)	;Change PC to the right PC
		movea.l	(Dummy+4),a3		;Task
		move.l	(Dummy+12),(db_SP,a2)
		moveq		#0,d7
		bsr		NoErrorRDB
		bra		UpdateDisplay

	;---
	;Simply load the task
	;---
LoadTaskRDB:
		bsr		GetStringE
		movea.l	d0,a3
		movea.l	d0,a0
		bsr		MakeDebugNodeE
		move.l	a3,d1
		CALLDOS	LoadSeg
		tst.l		d0
		bne.b		4$
	;Error
		bsr		FreeDebugNode
		ERROR		LoadSegError

	;No error
4$		move.l	d0,-(a7)
		bsr		PatchAddTask
		move.l	(a7)+,d0
		move.l	d0,(db_Segment,a2)
		movea.l	d0,a4
		adda.l	a4,a4
		adda.l	a4,a4					;BPTR->APTR
		lea		(4,a4),a4			;Skip segment info
		move.w	(a4),d7				;First word
		move.w	#$4afc,(a4)			;ILLEGAL
		bsr		FlushCache

	IFD	D20
		lea		(CNProcTags,pc),a0
		move.l	d0,(4,a0)			;NP_Seglist
		move.l	a3,(12,a0)			;NP_Name
		move.l	a0,d1
		lea		(InTaskWait,pc),a6
		move.b	#1,(a6)
		CALLDOS	CreateNewProc
		clr.l		(db_Segment,a2)	;The system will unload our segments
	ENDC
	IFND	D20
		move.l	(LN_NAME,a2),d1
		moveq		#0,d2
		move.l	d0,d3					;Segment
		move.l	#20000,d4			;StackSize
		lea		(InTaskWait,pc),a6
		move.b	#1,(a6)
		CALLDOS	CreateProc
	ENDC

		move.l	(DebugSigSet,pc),d0
		CALLEXEC	Wait
		bsr		CheckAddTaskPatch
		move.l	a3,-(a7)
		move.w	d7,(a4)				;Restore instruction
		bsr		FlushCache
		movea.l	(Dummy+4),a3		;Task
	IFD	D20
	;Tell AmigaDOS 2.0 to unload the segment and cli when the process quits
;		or.l		#PRF_FREESEGLIST,pr_Flags(a3)
;		or.l		#PRF_FREECLI,pr_Flags(a3)
	ENDC
		move.l	(Dummy+12),(db_SP,a2)
		moveq		#0,d7
		bsr		NoErrorRDB
		movea.l	(a7)+,a3
		suba.l	a4,a4
		bsr		LoadSymbols
		bne.b		3$
	;Error in loading, print error and clear error flag
		move.w	(LastError),d0
		bsr		GetError
		movea.l	d2,a0
		PRINT
		NEWLINE
		clr.w		(LastError)
		bra.b		1$
	;No error
3$		tst.l		d0
		bne.b		1$
	;There are no symbol hunks
		moveq		#ERR_NoSymbolHunks,d0
		bsr		GetError
		movea.l	d2,a0
		PRINT
		NEWLINE
1$		bra		UpdateDisplay

	;---
	;Trap the next process
	;---
NextTaskRDB:
		moveq		#1,d2
		NEXTTYPE
		beq.b		3$
	;There is an optional parameter with the number of the process to
	;trap
		EVALE
		move.l	d0,d2

3$		lea		(PatchCounter,pc),a0
		move.w	d2,(a0)
		suba.l	a0,a0
		bsr		MakeDebugNodeE
		bsr		Forbid
		lea		(LoadSegPatch,pc),a0
		move.l	a0,d0
		movea.l	#_LVOLoadSeg,a0
		bsr		DosSetFunction
		lea		(LoadSegPatch,pc),a1
		move.w	d0,(ToLoadSegJmp,a1)
		move.l	a0,(ToLoadSegJmp+4,a1)
		move.l	d0,(AfterLSeg,a1)
		move.l	d1,(AfterLSeg+4,a1)
		bsr		PatchAddTask
		bsr		Permit
		lea		(MesProcWait,pc),a0
		bsr		PrintAC
	;Clear break signal
		moveq		#0,d0
		move.l	(PVBreakSigSet),d1
		CALLEXEC	SetSignal
	;Wait for break or debug signal
		move.l	(DebugSigSet,pc),d0
		or.l		(PVBreakSigSet),d0
		CALL		Wait
		move.l	d0,-(a7)
		bsr		CheckAddTaskPatch
		move.l	(a7)+,d0
		and.l		(DebugSigSet,pc),d0
		bne.b		1$
	;It was not a signal from our debug task
	;I assume here that it is highly unlikely that someone breaks
	;and at the same time a program started, so I assume that no task has
	;fallen in our LoadSeg patch trap.
	;We have to restore the LoadSeg patch.
		bsr		FreeDebugNode
		bsr		RestoreLoadSegPatch
		bra		CheckBreak
	;A signal from our debug task
1$		movea.l	(Dummy),a3			;PC
		move.w	(Dummy+8),(a3)		;Restore ILLEGAL
		movea.l	(Dummy+4),a3		;Task
		move.l	(Dummy+12),(db_SP,a2)
		moveq		#0,d7
		bsr		NoErrorRDB
		bra		UpdateDisplay

	;---
	;Stop a running task or a crash node
	;---
StopTaskRDB:
		EVALE								;Get task or crash node to debug
		movea.l	d0,a0
		cmpi.b	#NT_CRASH,(LN_TYPE,a0)
		bne		3$
	;We have a crash node in a0
4$		movea.l	a0,a4
		movea.l	(cn_Task,a4),a0
		movea.l	(LN_NAME,a0),a0
		bsr		MakeDebugNodeE
		movea.l	(cn_Task,a4),a3
		moveq		#1,d0
		move.l	d0,(TC_SIGWAIT,a3)
		movea.l	a3,a1
		CALLEXEC	Signal
	;Wait for the completion of the signal
7$		moveq		#5,d1
		CALLDOS	Delay
		lea		(BackFromSignal,pc),a0
		tst.b		(a0)
		beq.b		7$
		bsr		Forbid
		move.l	(cn_SP,a4),(db_SP,a2)
		move.l	(cn_PC,a4),(Dummy)
	;A crashed task is always ready when it crashes
		move.b	#TS_READY,(TC_STATE,a3)
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a3),a4
		bsr		SkipStackFrame
		movea.l	a4,a0
		movea.l	(a7)+,a4
		lea		(4,a0),a0				;Skip PC
		move.w	(cn_SR,a4),(a0)+
		lea		(cn_Registers,a4),a1
		moveq		#14,d0				;15 regs

6$		move.l	(a1)+,(a0)+
		dbra		d0,6$

		move.l	a4,d0
		move.l	a2,-(a7)
		bsr		RemoveCrashDirect
		movea.l	(a7)+,a2
		bsr		Permit
		moveq		#1,d7
		bra		NoError2RDB
	;It is a normal task
3$		movea.l	a0,a3
		bsr		SearchCrashedTask
		move.l	a0,d0
		bne		4$
		movea.l	(LN_NAME,a3),a0
5$		bsr		MakeDebugNodeE
		move.b	(LN_TYPE,a3),d0
		cmpi.b	#NT_TASK,d0
		beq.b		1$
		cmpi.b	#NT_PROCESS,d0
		beq.b		1$
	;Error
		bsr		FreeDebugNode
		ERROR		NotATaskProc
1$		cmpi.b	#7,(TC_STATE,a3)
		blt.b		2$
	;DEBUG: we should be able to debug freezed tasks
		bsr		FreeDebugNode
		ERROR		TaskIsFreezed
2$		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a3),a4
		bsr		SkipStackFrame
		movea.l	a4,a0
		movea.l	(a7)+,a4
		move.l	(a0),(Dummy)
		clr.l		(db_SP,a2)
		moveq		#1,d7
		bsr.b		NoError2RDB
		bra		UpdateDisplay

	;d7 = 1 if from 'debug t' else 0
NoErrorRDB:
	;Wait for the completion of the signal
1$		moveq		#5,d1
		CALLDOS	Delay
		lea		(BackFromSignal,pc),a0
		tst.b		(a0)
		beq.b		1$
NoError2RDB:
		move.l	a3,(db_Task,a2)
		tst.l		(LN_NAME,a2)
		bne.b		1$
	;Name is not yet ready
		movea.l	(LN_NAME,a3),a0
		bsr		AllocStringInt
		beq.b		1$
		move.l	d0,(LN_NAME,a2)
1$		clr.w		(LastError)			;Clear error because we simply ignore it
		move.l	(Dummy),(db_InitPC,a2)
		bsr		Disable				;Prevent further execution
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a3),a4
		bsr		SkipStackFrame
		movea.l	a4,a0
		movea.l	(a7)+,a4
	;Put task to waiting
		move.l	(TC_SIGWAIT,a3),(db_SigWait,a2)
		move.b	(TC_STATE,a3),(db_TaskState,a2)

	;Set programcounter to original place where the ILLEGAL instruction was put
		move.l	(Dummy),(a0)		;PC

	;Install QuitCode routine
		tst.b		d7
		beq.b		2$
	;'debug t'. We must check if we have a process or a cli
	;I'm not so sure about the position for quitcode for tasks
	;I think that :
	;	tasks have their quitcode position on SPUpper-4
	;	processes have their qc pos on SPUpper-8
	;	cli's have their qc pos on SPUpper-12
	;But for process and cli's it doesn't really matter since we can
	;use pr_ReturnAddr-4
		movea.l	(pr_ReturnAddr,a3),a4
		cmpi.b	#NT_TASK,(LN_TYPE,a3)
		bne.b		3$
	;We have a task
		movea.l	(TC_SPUPPER,a3),a4
	;We have a proces or cli
3$		subq.l	#4,a4
		bra.b		4$

	;Not 'debug t', QuitCode on stack can be found very easy
2$		movea.l	(TC_SPREG,a3),a4
		bsr		SkipStackFrame
		lea		(16*4+2,a4),a4
4$		move.l	a4,(db_PtrToQuitCode,a2)
		move.l	(a4),(db_PrevQuitCode,a2)
		lea		(QuitCode,pc),a0
		move.l	a0,(a4)

		movea.l	a3,a1
		CALLEXEC	Remove
		movea.l	a3,a1
		lea		(TaskWait,a6),a0
		CALL		AddHead
		move.b	#TS_WAIT,(TC_STATE,a3)
		clr.l		(TC_SIGWAIT,a3)	;Make sure task will get no signals
		bsr		Enable
		move.l	(TC_TRAPCODE,a3),(db_TrapCode,a2)
		lea		(db_MOVcode,a2),a0
		move.l	a0,(TC_TRAPCODE,a3)
		move.b	#DB_NONE,(db_Mode,a2)
		move.b	#%00000000,(db_TraceBits,a2)
		move.b	#DBS_WAIT,(db_SMode,a2)
		lea		(DebugList,pc),a0	;Add our node to the list
		movea.l	a2,a1
		CALL		AddHead
		move.l	a2,d0
		lea		(CurrentDebug,pc),a0
		move.l	d0,(a0)
		lea		(CurDispDebug,pc),a0
		move.l	d0,(a0)
		bra		StoreRC

	;---
	;Remove a debugnode, freeze the corresponding task
	;---

;BUG! There are 24 bytes dissapearing everytime we do
;'debug l'
;'debug u' (only AmigaDOS 1.2/1.3)

UnloadRDB:
		bsr		GetDNodeRDBE

		bsr		Forbid
		moveq		#0,d0					;Do not freeze
		bsr		RemoveDebugTask

		move.l	(db_Task,a2),d0
		beq.b		2$

	IFD	D20
		lea		(QuitCode,pc),a0
		move.l	a0,(a4)				;Change programcounter for task
		bra		Permit
	ENDC
	IFND	D20
		movea.l	d0,a1
		CALLEXEC	RemTask
	ENDC

2$		move.l	(db_Segment,a2),d1
		beq.b		1$
		CALLDOS	UnLoadSeg

1$		bsr		RemoveDebug
		bra		Permit


;All these routines should be tested and checked for dummy debug nodes


	;---
	;Control the source path
	;---
SourcePathRDB:
		bsr		GetDebugNodeE
		NEXTTYPE
		beq.b		PathShowDSR
		lea		(OptDbSrcStr,pc),a3
		lea		(OptDbSrcRout,pc),a4
		bra		JumpOptRout

PathErrorDSR:
		ERROR		UnknownDbSrcArg

	;---
	;Show the sourcepath
	;a2 = debug node
	;---
PathShowDSR:
		move.l	(db_SourcePath,a2),d0
		beq.b		2$
		movea.l	d0,a1
1$		move.l	(a1)+,d0
		beq.b		2$
		movea.l	d0,a0
		tst.b		(a0)					;Is it the current directory?
		bne.b		3$
		lea		(MesCurDir,pc),a0
3$		PRINT
		NEWLINE
		bra.b		1$
2$		rts

	;---
	;Add an entry to the source path
	;a0 = rest of cmdline
	;a2 = debug node
	;---
PathAddDSR:
		bsr		GetStringPer		;Get directory name
		HERReq
		movea.l	d0,a3					;Remember name
		move.l	(db_SourcePath,a2),d0
		bne.b		2$						;If no source path, we allocate one first
		bsr.b		PathClearDSR		;Allocate source path if possible
2$		movea.l	d0,a1
		bsr		BlockSize
		move.l	d0,d1
		addq.l	#4,d1					;Add place for new pointer
		bsr		ReAllocMemBlock
		move.l	d0,(db_SourcePath,a2)
		movea.l	d0,a1

1$		move.l	(a1)+,d0				;Look for first free place (null pointer)
		bne.b		1$

		subq.l	#4,a1					;Go one back
		move.l	a3,(a1)+				;Remember new pointer
		clr.l		(a1)					;Make null-terminated
		rts

	;---
	;Clear all entries in the source path
	;a0 = rest of cmdline
	;a2 = debug node
	;-> d0 = ptr to new empty source path
	;---
PathClearDSR:
		bsr.b		RemoveSourcePath
		moveq		#4,d0					;Place for null-termination
		bsr		AllocBlockInt
		ERROReq	NotEnoughMemory
		move.l	d0,(db_SourcePath,a2)
		rts

	;***
	;Remove the sourcepath for a debug node
	;a2 = debug node
	;***
RemoveSourcePath:
		move.l	(db_SourcePath,a2),d1
		beq.b		1$
	;Clear the source path
		movea.l	d1,a1
2$		move.l	(a1)+,d0
		beq.b		3$
		lea		(MesEmpty,pc),a0
		cmp.l		a0,d0
		beq.b		2$
		movea.l	d0,a0
		bsr		FreeBlock
		bra.b		2$
3$		movea.l	d1,a0
		bsr		FreeBlock
		clr.l		(db_SourcePath,a2)
1$		rts

	;---
	;Remove a debugnode, freeze the corresponding task
	;---
RemoveFreezeRDB:
		bsr		GetDNodeRDBE
		moveq		#1,d0					;Freeze the task
		bra.b		RemoveDebugDirect

	;---
	;Remove a debugnode
	;---
RemoveRDB:
		bsr		GetDNodeRDBE
		moveq		#0,d0					;Do not freeze the task

	;---
	;Remove a debug node
	;a2 = pointer to debug node
	;d0 = argument for 'RemoveDebugTask' (1 for freeze)
	;---
RemoveDebugDirect:
		bsr.b		RemoveDebugTask
		bra		RemoveDebug

	;***
	;Halt the tracing of a debug node and put the corresponding task
	;in a list
	;d0 = 0 if simply put back or 1 if the task must be frozen
	;a2 = debug node
	;-> a4 = pointer to stackframe
	;***
RemoveDebugTask:
		move.l	d0,-(a7)
		bsr		Disable
		bsr		HaltDebugTask

		move.l	(db_Task,a2),d0
		beq.b		7$
		movea.l	d0,a1
		movea.l	(db_PtrToQuitCode,a2),a0
		move.l	(db_PrevQuitCode,a2),(a0)
		CALLEXEC	Remove
		movea.l	(db_Task,a2),a1
		move.l	(db_SigWait,a2),(TC_SIGWAIT,a1)
		move.b	(db_TaskState,a2),d0
		move.b	d0,(TC_STATE,a1)
		move.l	(a7),d0
		beq.b		4$

	;Freeze
		addq.b	#7,(TC_STATE,a1)
		lea		(Freezed),a0
		bra.b		5$

	;Put back on correct list
4$		lea		(TaskWait,a6),a0
		cmpi.b	#TS_WAIT,d0
		beq.b		5$
		lea		(TaskReady,a6),a0

	;Really put back
5$		move.l	(db_TrapCode,a2),(TC_TRAPCODE,a1)
		movea.l	(TC_SPREG,a1),a4
		bsr		SkipStackFrame
		andi.b	#$3f,(4,a4)			;Disable trace mode for task
		CALL		AddTail
7$		bsr		Enable
		move.l	(a7)+,d0
		rts

	;***
	;Remove the debug node, clear all breakpoints, all symbols and
	;all source information
	;Note that the debug task must be canceled or frozen before this
	;routine is called
	;a2 = pointer to debug node
	;***
RemoveDebug:
		movea.l	a2,a1
		CALLEXEC	Remove
1$		lea		(db_BreakPoints,a2),a3
		movea.l	(a3),a3				;Succ
		tst.l		(a3)					;Succ
		beq.b		3$
		cmpi.b	#BP_COND,(bp_Type,a3)
		bne.b		2$
		move.l	(bp_Additional,a3),d0
		beq.b		2$
		movea.l	d0,a0
		bsr		FreeBlock
2$		movea.l	(bp_Where,a3),a0
		move.w	(bp_Original,a3),(a0)
		movea.l	a3,a1
		CALLEXEC	Remove
		moveq		#bp_SIZE,d0
		movea.l	a3,a1
		bsr		FreeMem
		bra.b		1$

3$		bsr		ClearSymbols
		bsr		ClearWatches
		bsr		RemoveSourcePath
		bsr		FreeAllSources

	;Fall through to 'FreeDebugNode'

	;***
	;Free debug node
	;a2 = pointer to debug node
	;***
FreeDebugNode:
		move.l	#'????',(db_MatchWord,a2)
		move.l	(LN_NAME,a2),d0
		beq.b		1$
		movea.l	d0,a0
		bsr		FreeBlock
1$		movea.l	a2,a1
		move.l	#db_SIZE,d0
		bra		FreeMem

	;***
	;Free all loaded source files and update window title
	;a2 = pointer to debug node
	;***
FreeAllSources:
		clr.l		(db_CurrentSource,a2)

		bsr		UpdateSourceTitle
		move.l	(SourceLW),d0
		beq.b		1$
		movea.l	d0,a0
		bsr		LogWin_Clear

1$		move.l	(db_Source,a2),d0
		beq.b		2$
		movea.l	d0,a0
		bsr		RemSourceFile
		bra.b		1$
2$		rts

	;***
	;Halt a task for a debug node
	;The task is removed from whatever list it is in and is added to
	;the Exec wait-list
	;This function does nothing if the task is already halted
	;Note that this function should be called in Forbid/Permit pairs
	;a2 = pointer to debug node
	;-> d0 = 0 (flags) if task already halted
	;***
HaltDebugTask:
		movem.l	a3-a4,-(a7)
		cmpi.b	#DB_NONE,(db_Mode,a2)
		beq		1$
		cmpi.b	#DBS_WAIT,(db_SMode,a2)
		beq		1$
		move.l	(db_Task,a2),d0
		beq		1$						;There is no task
		movea.l	d0,a3
		move.b	(TC_TDNESTCNT,a3),(db_TDNestCnt,a2)
		move.b	(TC_IDNESTCNT,a3),(db_IDNestCnt,a2)
		move.l	(TC_SIGWAIT,a3),(db_SigWait,a2)
		move.b	(TC_STATE,a3),(db_TaskState,a2)
		movea.l	a3,a1
		CALLEXEC	Remove
		lea		(TaskWait,a6),a0
		movea.l	a3,a1
		CALL		AddHead
		movea.l	(TC_SPREG,a3),a4
		bsr		SkipStackFrame
		andi.b	#$3f,(4,a4)			;Disable trace mode
		move.b	#TS_WAIT,(TC_STATE,a3)
		clr.l		(TC_SIGWAIT,a3)
		moveq		#-1,d0
		move.b	d0,(TC_TDNESTCNT,a3)
		move.b	d0,(TC_IDNESTCNT,a3)

	;Free condition string or code
		moveq		#0,d0
		movea.l	a2,a3					;a3 must be debug node for SetAdditional
		bsr		SetAdditional

		move.b	#DBS_WAIT,(db_SMode,a2)
		move.b	#DB_NONE,(db_Mode,a2)
		move.b	#%00000000,(db_TraceBits,a2)

	;The end, we did remove the task
		moveq		#1,d0
		bra.b		3$

	;The end, the task was already removed
1$		moveq		#0,d0
3$		movem.l	(a7)+,a3-a4
		rts

	;***
	;AddTask patch to change the first instruction of the task to
	;'ILLEGAL'
	;***
AddTaskIllegal:
		move.l	a2,(Dummy+8)			;Store PC
		lea		(PatchCounter,pc),a2
		subq.w	#1,(a2)
		bgt.b		NoIllegalATI

		lea		(ExecByTask,pc),a2	;New PC
		move.l	a1,-(a7)
		bsr.b		JmpAddTask
		movea.l	(a7)+,a1
		move.l	(TaskTrapCode,a6),(TC_TRAPCODE,a1)
		rts

	;Don't trap yet
NoIllegalATI:
		movea.l	(Dummy+8),a2		;Restore pc

JmpAddTask:
		jsr		($00000000).l
		movea.l	(Dummy+8),a2		;Restore pc
		rts

	;***
	;This routines gets executed by the task
	;***
ExecByTask:
		illegal

	;***
	;Get the stackframe for a debug node
	;a2 = debug node
	;-> a4 = stackframe
	;***
GetStackFrame:
		movea.l	(db_Task,a2),a4
		movea.l	(TC_SPREG,a4),a4

	;***
	;Skip coprocessor stackframe
	;a4 = stackframe
	;-> a4 = ptr to old exec stackframe
	;-> preserves all other registers
	;***
SkipStackFrame:
		movem.l	d0/a6,-(a7)
		move.l	(m68881,pc),d0
		beq.b		EndSkipSF
		move.b	(a4),d0
		beq.b		NoSize
		lea		(2+12,a4),a4		;word and FPCR/FPSR/FPIAR
		lea		(12*8,a4),a4		;FP0..FP7

		cmpi.b	#$90,d0
		bne.b		NoFFP
		lea		(12,a4),a4
NoFFP:
		movea.l	(SysBase).w,a6
		cmpi.w	#37,(LIB_VERSION,a6)
		blo.b		1$						;Since Exec Version 37.132 Commo changed the Stackframe
		bhi.b		2$
	;If equal to 37, we must test the revision number
		cmpi.w	#132,(LIB_REVISION,a6)
		blo.b		1$
2$		lea		(2,a4),a4

1$		moveq		#0,d0
		move.b	(1,a4),d0
		adda.l	d0,a4

NoSize:
		addq.w	#4,a4
EndSkipSF:
		movem.l	(a7)+,d0/a6
		rts

BeforeQuitCode:
		illegal

	;***
	;This code is called whenever a debug task quits
	;d0 = returncode
	;***
QuitCode:
		move.l	d0,-(a7)
		lea		(QuitCodeSuper,pc),a5
		CALLEXEC	Supervisor
		suba.l	a1,a1
		CALL		FindTask
		lea		(DebugList,pc),a2
2$		movea.l	(a2),a2				;Succ
		cmp.l		(db_Task,a2),d0
		bne.b		2$
	;a2 = ptr to debugnode
		movea.l	(db_PrevQuitCode,a2),a3
		movea.l	(db_PtrToQuitCode,a2),a4
		movem.l	a3-a4,-(a7)

		bsr		RemoveDebug
		lea		(CurrentDebug,pc),a0
		cmpa.l	(a0),a2
		bne.b		1$
	;Current debugnode is me
		bsr		ClearDebug
1$		lea		(MesQuitProg,pc),a0
		bsr		MsgPrint
		movem.l	(a7)+,a3-a4
		move.l	(a7)+,d0				;Return value
		lea		(4,a4),a7			;Change stack to original position
		move.l	a3,-(a7)
		rts
QuitCodeSuper:
		andi.b	#$3f,(a7)			;Disable trace mode
		rte

	;***
	;Get debug node and reset the current debug node if it is this one
	;a0 = cmdline
	;-> d0 = ptr to node to remove
	;-> a2 = the same
	;***
GetDNodeRDBE:
		NEXTARG	1$
		movea.l	d0,a0
		cmpi.l	#'DBUG',(db_MatchWord,a0)
		ERRORne	NotADebugNode
		cmpa.l	(CurrentDebug,pc),a0
		beq.b		3$
		movea.l	d0,a2
		rts
1$		move.l	(CurrentDebug,pc),d0
		ERROReq	NoCurrentDebug
3$		bsr		ClearDebug
		movea.l	d0,a2
		rts

	;***
	;Make debug node
	;This function does not return if error
	;a0 = ptr to name
	;-> a2 = debug node
	;***
MakeDebugNodeE:
		move.l	#db_SIZE,d0
		bsr		MakeNodeInt
		HERReq
		movea.l	a0,a2

	;Allocate place for source path
		moveq		#8,d0					;Place for current dir and null-termination
		bsr		AllocBlockInt
		bne.b		1$
		bsr		FreeDebugNode
		ERROR		NotEnoughMemory
1$		move.l	d0,(db_SourcePath,a2)
		movea.l	d0,a0
		lea		(MesEmpty,pc),a1
		move.l	a1,(a0)+				;Current dir
		clr.l		(a0)					;Null-termination

		lea		(db_BreakPoints,a2),a0
		NEWLIST	a0						;Init breakpoint list
		move.l	#'DBUG',(db_MatchWord,a2)
		move.b	#NT_DEBUG,(LN_TYPE,a2)
		move.l	#$48e7c0f2,(db_MOVcode,a2)
		move.w	#$47f9,(db_LEAcode,a2)
		move.l	a2,(db_LEAaddr,a2)
		move.w	#$4ef9,(db_JMPcode,a2)
		lea		(TraceVector,pc),a0
		move.l	a0,(db_JMPaddr,a2)
		moveq		#-1,d0
		move.b	d0,(db_TDNestCnt,a2)
		move.b	d0,(db_IDNestCnt,a2)
		clr.l		(db_TopPC,a2)
		clr.l		(db_BotPC,a2)
		move.l	a2,d0
		rts

	;***
	;Clear debug mode
	;***
ClearDebug:
		movem.l	d0-d1/a0-a1,-(a7)
		lea		(CurrentDebug,pc),a0
		lea		(CurDispDebug,pc),a1
		move.l	(a1),d0
		cmp.l		(a0),d0
		bne.b		1$
		clr.l		(a1)

1$		clr.l		(a0)
		bsr		UpdateDisplay
		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Command: control watches
	;a0 = cmdline
	;***
RoutWatch:
		bsr		GetDebugNodeE
		lea		(OptWatchStr,pc),a3
		lea		(OptWatchRout,pc),a4
		bra		JumpOptRout

	;---
	;Error
	;---
WatchErrorWA:
		ERROR		UnknownWatchArg

	;---
	;Add a watch
	;a0 = rest of cmdline
	;a2 = debugnode
	;---
WatchAddWA:
		EVALE								;Get address to watch
		move.l	d0,d2
		moveq		#wtc_SIZE,d0
		bsr		AllocBlockInt
		HERReq
		movea.l	d0,a0
		move.l	d2,(wtc_Pointer,a0)
		clr.l		(wtc_Prev,a0)
		move.l	(db_Watches,a2),(wtc_Next,a0)
		move.l	a0,(db_Watches,a2)
		rts

	;---
	;Remove a watch
	;a0 = rest of cmdline
	;a2 = debugnode
	;---
WatchRemWA:
		EVALE								;Get address to remove
		move.l	(db_Watches,a2),d1
		beq.b		1$
2$		movea.l	d1,a0
		cmp.l		(wtc_Pointer,a0),d0
		beq.b		3$
		move.l	(wtc_Next,a0),d1
		bne.b		2$
1$		rts
	;We found the watch, remove it!
3$		move.l	(wtc_Next,a0),d0
		beq.b		4$
		movea.l	d0,a1
		move.l	(wtc_Prev,a0),(wtc_Prev,a1)
4$		move.l	(wtc_Prev,a0),d0
		beq.b		5$
		movea.l	d0,a1
		move.l	(wtc_Next,a0),(wtc_Next,a1)
		bra.b		6$
5$		move.l	(wtc_Next,a0),(db_Watches,a2)
6$		bra		FreeBlock

	;---
	;Show all watches
	;a0 = rest of cmdline
	;a2 = debugnode
	;---
WatchShowWA:
		movea.l	(CurrentLW),a3
		bra		ShowWatchesOnWindow

	;---
	;Clear all watches
	;a0 = rest of cmdline
	;a2 = debugnode
	;---
WatchClearWA:
	;FALL THRU

	;***
	;Clear all watches
	;a2 = debug node
	;***
ClearWatches:
		move.l	(db_Watches,a2),d0
		beq.b		1$
2$		movea.l	d0,a0
		move.l	(wtc_Next,a0),d2
		bsr		FreeBlock
		move.l	d2,d0
		bne.b		2$
		clr.l		(db_Watches,a2)
1$		rts

	;***
	;Update the watch logical window if it exists
	;a2 = debug node
	;***
UpdateWatchWindow:
		move.l	(WatchLW),d0
		bne.b		1$
		rts
1$		movea.l	d0,a3
		movea.l	d0,a0
		bsr		LogWin_Home
	;FALL THRU

	;***
	;Show all watches on a window
	;a2 = debugnode
	;a3 = logwin
	;***
ShowWatchesOnWindow:
		move.l	(db_Watches,a2),d0
		beq.b		1$
2$		movea.l	d0,a4
		movea.l	(wtc_Pointer,a4),a0
		move.l	(wtc_PrevValue,a4),d0
		move.l	(a0),(wtc_PrevValue,a4)
		cmp.l		(wtc_PrevValue,a4),d0
		beq.b		3$
	;Different, use hilighting
		moveq		#1,d0
		bra.b		4$
	;The same
3$		moveq		#0,d0
4$		movea.l	a3,a0
		bsr		LogWin_Attribute
		lea		(FormatWatch,pc),a0
		move.l	(Storage),d0
		movea.l	a4,a1
		bsr		PrintForQ
		PFLONG	wtc_PrevValue
		PFLONG	wtc_PrevValue
		PFLONG	wtc_Pointer
		PFEND
		movea.l	d0,a1
		moveq		#70,d0
		movea.l	a3,a0
		bsr		LogWin_Print
		move.l	(wtc_Next,a4),d0
		bne.b		2$
1$		rts

	;***
	;Command: control breakpoints
	;a0 = cmdline
	;***
RoutBreak:
		bsr		GetDebugNodeE
		movea.l	a2,a3
		bsr		GetNextByteE
		movem.l	d0/a0,-(a7)
		lea		(OptBreakStr,pc),a0
		lea		(OptBreakRout,pc),a1
		bsr		ScanOptions
		movem.l	(a7)+,d0/a0
		move.l	d0,-(a7)
		EVALE								;Address
		movea.l	d0,a4
		move.l	(a7)+,d0
		jmp		(a1)

	;---
	;Error
	;---
BreakErrorBR:
		ERROR		UnknownBreakArg

	;---
	;Create a brkpt with a condition
	;---
BreakCondBR:
		move.l	d0,d2
		bsr		GetStringPer
		HERReq
		movea.l	d0,a2					;Condition string
		move.l	d2,d0
		bra.b		BreakTempBR

	;---
	;Create a brkpt with timeout
	;---
BreakAfterBR:
		move.l	d0,d2
		EVALE								;Get timeout value
		movea.l	d0,a2
		move.l	d2,d0

	;---
	;Create a normal breakpoint
	;---
BreakNormalBR:

	;---
	;Create a profile breakpoint
	;---
BreakProfileBR:

	;---
	;Create a temporary breakpoint
	;---
BreakTempBR:
		movea.l	a4,a0
		bsr		AddBreakPoint
		HERReq
		bsr		StoreRC
		PRINTHEX
		bra		UpdateDisplay

	;---
	;Remove a breakpoint
	;---
BreakRemoveBR:
		move.l	a4,d0
		bsr		GetBreakPoint
		ERROReq	NoSuchBreakPoint
		movea.l	d0,a1
		bsr		ClearBreakPoint
		bra		UpdateDisplay

	;***
	;Get the current source for a debug node
	;a2 = debug node
	;-> d0 = current source (or 0, flags)
	;-> a1 = d0
	;-> a0 and d1 are preserved
	;***
GetDebugSource:
		move.l	(db_Source,a2),d0
		beq.b		1$
		move.l	(db_CurrentSource,a2),d0

	;There is a current source
1$		movea.l	d0,a1
		rts

	;***
	;Command: trace the program
	;a0 = cmdline
	;***
RoutTrace:
		bsr		GetDebugNodeE
		movea.l	a2,a3
		bsr		Forbid
		move.l	(db_Task,a3),d1
		beq.b		1$
		movea.l	d1,a2					;a2 = pointer to task
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	(a4),a5				;Ptr to next instruction
		tst.l		d0						;End of line par
		bne.b		2$
		bsr		NormalTrace
		bra.b		1$
2$		bsr		GetNextByteE
		movem.l	a0-a1,-(a7)
		lea		(OptTraceStr,pc),a0
		lea		(OptTraceRout,pc),a1
		bsr		ScanOptions
		movea.l	a1,a6
		movem.l	(a7)+,a0-a1
;		bsr		UpdateStatus
		move.b	(a1),d0
		bsr		Upper
		move.l	d0,d2
		jsr		(a6)
1$		bra		Permit

	;---
	;Error
	;---
TraceErrorTR:
		ERROR		UnknownTraceArg

	;All following routines:
	;d2 = first char after one-letter command (uppercase)
	;a0 = rest cmdline
	;a1 = pointer after one-letter command
	;a2 = task
	;a3 = debug node
	;a4 = stackframe

	;---
	;Halt tracing task but wait until it is ready
	;(In other words, force step mode on with immediate return)
	;---
TraceForceStepTR:
		cmpi.b	#DB_NONE,(db_Mode,a3)
		ERROReq	TaskIsNotTracing
		cmpi.b	#DBS_WAIT,(db_SMode,a3)
		ERROReq	TaskIsNotTracing
		lea		(ForceTraceTV,pc),a0
		move.l	a0,(db_TRoutine,a3)
		move.b	#DBT_FORCE,(db_TMode,a3)
		move.b	#DB_TRACING,(db_Mode,a3)
		move.b	#%10000000,(db_TraceBits,a3)
		move.b	#DBS_NORMAL,(db_SMode,a3)
		movea.l	(a4)+,a5				;Next instruction to execute
		ori.b		#$80,(a4)			;Enable trace mode for task
		bra		DebugRefresh

	;---
	;Halt tracing task
	;---
TraceHaltTR:
		movea.l	a3,a2
		bsr		HaltDebugTask
		ERROReq	TaskIsNotTracing
		bra		DebugRefresh

	;---
	;Print trace info
	;---
PrintInfoTR:
		bsr		DebugRefresh
		move.l	(db_SP,a3),d6
		lea		(DebugRegsInfo,pc),a6
		tst.b		(a6)
		beq.b		1$
		bsr		DumpRegs
1$		lea		(DebugCodeInfo,pc),a6
		tst.b		(a6)
		bne.b		3$
		rts
3$		lea		(DebugPrevInfo,pc),a6
		tst.w		(a6)
		beq.b		2$
		move.l	(db_Instruction,a3),d6
		moveq		#1,d7					;Show previous instruction
		move.l	a4,-(a7)
		bsr		DefaultLengthUA
		movea.l	(a7)+,a4
		NEWLINE
2$		move.l	(a4),d6				;Next instructions to execute
		moveq		#0,d7
		move.w	(DebugShowInfo,pc),d7
		bra		SmartUnAsm			;Unassemble

	;---
	;Normal trace (1 instruction)
	;---
NormalTrace:
		bsr		CheckIfTraceE
		moveq		#DBT_NORMAL,d0
		lea		(NormalTraceTV,pc),a0
		bra		ContTrace

	;---
	;Trace more instructions
	;---
TraceMoreTR:
		bsr		CheckIfTraceE
		EVALE								;Number of instructions
		move.l	d0,(db_Additional2,a3)
		moveq		#DBT_AFTER,d0
		lea		(AfterTraceTV,pc),a0
		bra.b		ChooseFlTr

	;---
	;Simply trace until breakpoint
	;---
TraceGoTR:
		bsr		CheckIfTraceE
		moveq		#DBT_STEP,d0
		lea		(StepTraceTV,pc),a0
		cmpi.b	#'R',d2
		beq		ContRTrace
		cmpi.b	#'T',d2
		beq		ContTrace
		cmpi.b	#'F',d2
		beq		ContFTrace
		bra		ContExec

	IFD NotImplementedYet

	;---
	;Trace until an odd address is used (mainly for 68020 processors or
	;higher)
	;---
TraceAddressModesTR:
		bsr		CheckIfTraceE
		moveq		#DBT_AMODE,d0
		lea		(AModeTraceTV,pc),a0
		bra		ContTrace

	ENDC

	;---
	;Profile tracer
	;---
TraceProfileTR:
		bsr		CheckIfTraceE
		move.l	a3,(ProfDNode)
		moveq		#DBT_PROF,d0
		lea		(ProfTraceTV,pc),a0
ChooseFlTr:
		cmpi.b	#'R',d2
		beq		ContRTrace
		cmpi.b	#'F',d2
		beq		ContFTrace
		bra		ContTrace

	;---
	;Trace until a checksum is unvalidated
	;---
TraceCheckSumTR:
		bsr		CheckIfTraceE
		EVALE								;Get address
		bclr		#0,d0
		bclr		#0,d1					;Make longword alligned
		movea.l	d0,a5
		move.l	d0,(db_Additional2,a3)
		EVALE								;Get number of bytes
		addq.w	#3,d0
		lsr.w		#2,d0					;Number of longwords
		move.w	d0,(db_Additional3,a3)
		moveq		#0,d1
1$		add.l		(a5)+,d1
		dbra		d0,1$
		move.l	d1,(db_Additional4,a3)
		moveq		#DBT_CHKSUM,d0
		lea		(CheckSumTraceTV,pc),a0
		bra.b		ChooseFlTr

	;---
	;Trace until address
	;---
TraceUntilTR:
		bsr		CheckIfTraceE
		EVALE								;Get address
		move.l	d0,d7

ContTuTR:
		move.l	d7,(db_Additional2,a3)
		moveq		#DBT_UNTIL,d0
		cmpi.b	#'T',d2
		bne.b		1$
		lea		(UntilTraceTV,pc),a0
		bra		ContTrace

	;Execute instead of trace
1$		movea.l	d7,a0
		moveq		#BP_TEMP2,d0
		move.l	a2,-(a7)
		bsr		AddBreakPoint
		HERReq
		movea.l	(a7)+,a2
		lea		(UntilTraceTV,pc),a0
		moveq		#DBT_UNTIL,d0
		bra		ContExec

	;---
	;Skip the following instruction
	;---
TraceSkipTR:
		bsr		CheckIfTraceE
		move.l	(a4),d0				;PC
		move.l	d0,(db_Instruction,a3)
		movea.l	(Storage),a0
		move.l	d0,d7
		move.l	a4,-(a7)
		bsr		DisasmBreak			;d0=size of current instruction
		movea.l	(a7)+,a4
		add.l		d0,d7
		move.l	d7,(a4)
		bra		PrintInfoTR

	;---
	;Trace over BSR and JSR
	;---
TraceSkipBranchTR:
		bsr		CheckIfTraceE
		movea.l	(a4),a0				;PC

		cmpi.b	#%01100001,(a0)	;BSR
		beq.b		1$

		move.w	(a0),d0
		andi.w	#$ffc0,d0
		cmpi.w	#$4e80,d0			;JSR
		bne		NormalTrace

	;Skip BSR or JSR
1$		moveq		#DBT_SKIP,d0
		lea		(SkipTraceTV,pc),a0
		bra		ContTrace

	;This routine contains our breakpoint
SkipRout:
		illegal

	;---
	;Trace until after instruction
	;---
TraceOverTR:
		bsr		CheckIfTraceE
		move.l	(a4),d0				;PC
		movea.l	(Storage),a0
		move.l	d0,d7
		move.l	a4,-(a7)
		bsr		DisasmBreak			;d0=size of current instruction
		movea.l	(a7)+,a4
		add.l		d0,d7
		bra		ContTuTR				;Trace until address=after instruction

	;---
	;Trace until a register is changed
	;---
TraceRegTR:
		bsr		CheckIfTraceE
		bsr		SkipSpace

		bsr		GetRegister
		bne.b		3$
	;Unsupported register
4$		ERROR		BadRegister

3$		cmpi.b	#REG_SR,d0
		beq.b		4$
		cmpi.b	#REG_PC,d0
		beq.b		4$

		move.l	d0,d3					;Register code
		moveq		#%0110,d4			;NE

		cmpi.b	#REG_SP,d0
		beq.b		1$
		cmpi.b	#REG_A7,d0
		beq.b		1$

	;Normal register
		move.l	(0,a4,d1.w),d5		;Get register
		bra.b		StartQCondTR

	;Stack pointer
1$		move.l	(db_SP,a3),d5
		bra.b		StartQCondTR

	;---
	;Trace until a condition is satisfied
	;Conditionstring is compiled for faster execution
	;---
TraceQuickCondTR:
		bsr		CheckIfTraceE

		bsr		GetStringE			;Get condition string
		movea.l	d0,a0
		move.b	(a0)+,d0
		cmp.b		#'@',d0
		beq.b		1$

	;There is some error in the condition expression
2$		ERROR		BadArgValue
1$		bsr		GetRegister
		beq.b		2$

		move.l	d0,d3					;Remember register code

		move.b	(a0)+,d0
		move.b	(a0),d1
		cmp.b		#'=',d1
		bne.b		3$
	;Yes, there is another '=' symbol
		add.b		#128,d0
		lea		(1,a0),a0

	;Scan, quick condition table
3$		lea		(CondTableQC,pc),a1
4$		move.b	(a1)+,d1
		beq.b		2$
		move.b	(a1)+,d4				;Remember condition bits
		cmp.b		d1,d0
		bne.b		4$

	;Found!
		EVALE
		move.l	d0,d5					;Remember condition value

	;a3 = debug node
	;d2 = upper char after one-letter command
	;d3 = register code
	;d4 = condition bits
	;d5 = condition value
StartQCondTR:
		bsr		CompileExpTR

		move.l	a6,d0
		bsr		SetAdditional

		moveq		#DBT_QCOND,d0
		lea		(QCondTraceTV,pc),a0

		bra		ChooseFlTr

	;---
	;Trace until a condition is satisfied
	;---
TraceCondTR:
		bsr		CheckIfTraceE
		bsr		GetStringPer		;Get condition string
		HERReq
		bsr		SetAdditional
		moveq		#DBT_COND,d0
		lea		(CondTraceTV,pc),a0

		bra		ChooseFlTr

	;---
	;Trace until program tries to use an OS function call (JSR (a6) or JMP (a6))
	;---
TraceOSCallTR:
		bsr		CheckIfTraceE
		moveq		#DBT_OSCALL,d0
		lea		(OSCallTraceTV,pc),a0

		bra		ChooseFlTr

	;---
	;Trace until a change in program flow happens
	;---
TraceBranchTR:
		bsr		CheckIfTraceE
		moveq		#DBT_BRANCH,d0
		lea		(BranchTraceTV,pc),a0
	;Fall through

	;***
	;Continue with the tracing
	;a0 = pointer to trace routine
	;d0 = DBT_type
	;a3 = debug node
	;a4 = stackframe
	;***
ContTrace:
		move.b	#DB_TRACING,(db_Mode,a3)
		move.b	#%10000000,(db_TraceBits,a3)
		bra.b		CommonTraceTR

	;***
	;Like simple tracing but don't trace in subroutines
	;a0 = pointer to trace routine
	;d0 = DBT_type
	;a3 = debug node
	;a4 = stackframe
	;***
ContRTrace:
		move.b	#DB_RTRACING,(db_Mode,a3)
		move.b	#%10000000,(db_TraceBits,a3)
		bra.b		CommonTraceTR

	;***
	;Start flow tracing (68020 or higher only)
	;a0 = pointer to trace routine
	;d0 = DBT_type
	;a3 = debug node
	;a4 = stackframe
	;***
ContFTrace:
		move.b	#DB_FTRACING,(db_Mode,a3)
		move.b	#%01000000,(db_TraceBits,a3)
		bra.b		CommonTraceTR

	;***
	;Continue with the executing
	;a0 = pointer to trace routine
	;d0 = DBT_type
	;a3 = debug node
	;a4 = stackframe
	;***
ContExec:
		move.b	#DB_EXEC,(db_Mode,a3)
		move.b	#%00000000,(db_TraceBits,a3)

CommonTraceTR:
		move.b	d0,(db_TMode,a3)
		move.l	a0,(db_TRoutine,a3)
		move.b	#DBS_NORMAL,(db_SMode,a3)
		movea.l	(a4)+,a5				;Next instruction to execute

	;SetDebugTraceBits
		move.b	(a4),d0
		andi.b	#$3f,d0				;Disable trace mode
		or.b		(db_TraceBits,a3),d0
		move.b	d0,(a4)

		move.l	a5,(db_Instruction,a3)
		cmpi.w	#$4afc,(a5)
		bne.b		1$
		lea		(db_BreakPoints,a3),a1
2$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		beq.b		1$						;Brkpt does not exist, simply ignore
											;we will get a crash later on
		cmpa.l	(bp_Where,a1),a5
		bne.b		2$
	;There is a breakpoint here, restore it temporarily
		move.l	(db_TRoutine,a3),(db_TRoutine2,a3)
		lea		(TempTraceTV,pc),a0
		move.l	a0,(db_TRoutine,a3)
		move.b	#DBS_TTRACE,(db_SMode,a3)
		move.l	a5,(db_TAddress,a3)
		move.w	(bp_Original,a1),(a5)
		ori.b		#$80,(a4)			;Enable trace mode (only temporarily)

1$		bsr		Disable
		movea.l	a2,a1					;Pointer to task
		CALLEXEC	Remove
		move.l	(db_SigWait,a3),(TC_SIGWAIT,a2)
		lea		(TaskWait,a6),a0
		move.b	(db_TaskState,a3),d0
		move.b	d0,(TC_STATE,a2)
		cmpi.b	#TS_WAIT,d0
		beq.b		3$
		lea		(TaskReady,a6),a0
3$		movea.l	a2,a1
		CALL		AddHead
		move.b	(db_TDNestCnt,a3),(TC_TDNESTCNT,a2)
		move.b	(db_IDNestCnt,a3),(TC_IDNESTCNT,a2)
		bsr		FlushCache
		bsr		Enable
		bra		UpdateStatus

	;***
	;Free the db_Additional and set a new one
	;a3 = debug node
	;d0 = new additional argument
	;***
SetAdditional:
		move.l	d0,-(a7)
		bsr		Forbid
		move.l	(db_Additional,a3),d0
		beq.b		1$
		movea.l	d0,a0
		bsr		FreeBlock
1$		move.l	(a7)+,d0
		move.l	d0,(db_Additional,a3)
		bra		Permit

;	;***
;	;Set the correct trace bits for a debug task
;	;a0 = pointer to status register (on stack or somewhere else)
;	;a3 = debug node
;	;***
;SetDebugTraceBits:
;		move.b	(a0),d0
;		andi.b	#$3f,d0				;Disable trace mode
;		or.b		(db_TraceBits,a3),d0
;		move.b	d0,(a0)
;		rts

	;***
	;Start compiling information
	;This function allocates and generates some code
	;Code
	;		MOVE.L	USP,A0			(optional)
	;		CMP.L		#<x>,<reg>		(or cmpa.l)
	;		Bcc.B		1$
	;		MOVEQ		#0,D0
	;		RTS
	;1$	MOVEQ		#1,D0
	;		RTS
	;
	;		MOVE USP	-> $4E6<1rrr>
	;		CMP.L		-> $B<rrr0>BC
	;		CMPA.L	-> $B<rrr1>FC
	;		Bcc.B 1$	-> $6<cccc>04
	;		MOVEQ #0	-> $7000
	;		MOVEQ #1	-> $7001
	;		RTS		-> $4E75
	;
	;		<			-> LT 1101
	;		<=			-> LE 1111
	;		>			-> GT 1110
	;		>=			-> GE 1100
	;		==			-> EQ 0111
	;		!=			-> NE 0110
	;
	;d3 = register code (REG_xxx)
	;d4 = condition bits
	;d5 = condition value
	;-> a6 = pointer to allocated code
	;***
CompileExpTR:
	;Allocate place for code fragment
		moveq		#18,d0
		bsr		AllocBlockInt
		HERReq

	;CMP
		movea.l	d0,a6
		movea.l	a6,a5
		bsr.b		AddCMPinstr

	;Bcc
		lsl.w		#8,d4
		add.w		#$6004,d4
		move.w	d4,(a5)+				;Bcc.B instruction

	;MOVEQ,RTS,MOVEQ,RTS
		move.l	#$70004e75,(a5)+
		move.l	#$70014e75,(a5)+
		rts

	;***
	;Add a CMP instruction to the generated code
	;This function generates extra code if the stack pointer must be compared
	;d3 = register code (REG_xxx)
	;d5 = data to compare with
	;a5 = pointer to code
	;-> a5 = pointer after generated code
	;***
AddCMPinstr:
		cmp.b		#REG_SP,d3
		beq.b		1$
		cmp.b		#REG_A7,d3
		bne.b		2$

	;Yes, stackpointer
1$		move.w	#$4e68,(a5)+		;move.l	usp,a0
		moveq		#REG_A0,d3			;Compare with a0

	;No stackpointer
	;Assume that it is a data register
2$		subq.w	#1,d3
		move.w	d3,d0
		lsl.w		#8,d0
		lsl.w		#1,d0
		add.w		#$b0bc,d0

		cmp.b		#REG_D7,d3
		blt.b		5$

	;It is an address register
		move.w	d3,d0
		subq.w	#8,d0
		lsl.w		#8,d0
		lsl.w		#1,d0
		add.w		#$b1fc,d0

5$		move.w	d0,(a5)+				;CMPa.L instruction
		move.l	d5,(a5)+
		rts

CondTableQC:
		dc.b		"<",%1101,"<"+128,%1111,">",%1110,">"+128,%1100,"="+128,%0111,"!"+128,%0110,0
	EVEN

	;***
	;Check if we can trace with error handling
	;Does not return if error
	;a3 = debug node
	;-> preserves all registers
	;***
CheckIfTraceE:
		bsr.b		CheckIfTrace
		HERReq
		rts

	;***
	;Check if we can trace
	;a3 = debug node
	;-> flags if error
	;-> preserves all registers
	;***
CheckIfTrace:
		move.l	d0,-(a7)
		cmpi.b	#DB_NONE,(db_Mode,a3)
		SERRne	TaskIsBusy,1$
		cmpi.b	#DBS_WAIT,(db_SMode,a3)
		SERRne	TaskIsBusy,1$
		moveq		#1,d0					;No error
2$		movem.l	(a7)+,d0				;For flags
		rts
1$		moveq		#0,d0					;Error
		bra.b		2$

	;***
	;Add a breakpoint
	;a3 = ptr to debug node
	;a0 = address to add breakpoint
	;d0 = breakpoint type
	;if d0 = BP_AFTER, a2 = timeout value
	;if d0 = BP_COND,  a2 = condition string
	;-> d0 = number
	;-> d1 = 0, flags if error
	;***
AddBreakPoint:
		movem.l	a0/d0,-(a7)
		bsr		FlushCache
		bsr		Forbid
		moveq		#bp_SIZE,d0
		bsr		AllocClear
		bne.b		8$

	;Error
		movem.l	(a7)+,a0/d0
		moveq		#0,d1					;Error
		rts

	;Success
8$		movea.l	d0,a1
		movem.l	(a7)+,a0/d0
		move.l	a0,(bp_Where,a1)
		cmpi.b	#BP_TEMP2,d0
		bne.b		2$
	;First delete previous 0-brkpt if any
		moveq		#0,d0
		bsr		GetBreakPoint
		beq.b		4$
		movem.l	a0-a1/d0-d1,-(a7)
		movea.l	d0,a1
		bsr		ClearBreakPoint
		movem.l	(a7)+,a0-a1/d0-d1
4$		moveq		#BP_TEMP,d0
		move.b	d0,(bp_Type,a1)
		moveq		#0,d0
		bra.b		3$
	;Normal brkpt
2$		move.b	d0,(bp_Type,a1)
		bsr		SearchFreeBreakNr
3$		move.w	(a0),(bp_Original,a1)
		move.w	d0,(bp_Number,a1)
		move.l	d0,-(a7)
		moveq		#0,d1
		cmpi.b	#BP_COND,(bp_Type,a1)
		beq.b		6$
		cmpi.b	#BP_AFTER,(bp_Type,a1)
		bne.b		5$
6$		move.l	a2,d1
5$		move.l	d1,(bp_Additional,a1)
		clr.l		(bp_UsageCnt,a1)
		move.w	#$4afc,d0			;ILLEGAL
		move.w	d0,(a0)
		cmp.w		(a0),d0
		beq.b		1$

	;Error, code is in ROM
		moveq		#bp_SIZE,d0
		bsr		FreeMem
		bsr		Permit
		SERR		CodeInROM
		moveq		#0,d1					;Error (flags)
		bra.b		9$

	;Success
1$		movea.l	a1,a2					;Breakpoint
		lea		(db_BreakPoints,a3),a0
		CALLEXEC	AddHead
		move.b	(bp_Type,a2),d0
		lea		(BrkPtType,pc),a0
		lea		(BrkPtRout-4,pc),a1
7$		lea		(4,a1),a1
		cmp.b		(a0)+,d0
		bne.b		7$
		move.l	(a1),d0
		move.l	d0,(bp_BRoutine,a2)
		bsr		Permit
		bsr		FlushCache
		moveq		#1,d1					;No error (flags)
9$		movem.l	(a7)+,d0				;Get brkpt number (preserve flags)
		rts

	;***
	;Get ptr to breakpoint
	;a3 = ptr to debug node
	;d0 = number
	;-> d0 = breakpoint node (flags)
	;***
GetBreakPoint:
		movem.l	a2,-(a7)				;Must be movem for flags
		lea		(db_BreakPoints,a3),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$
		cmp.w		(bp_Number,a2),d0
		bne.b		1$
	;Found !
		move.l	a2,d0
		bra.b		3$
	;Not found !
2$		moveq		#0,d0
3$		movea.l	(a7)+,a2
		rts

	;***
	;Clear breakpoint
	;a1 = ptr to brkpt node
	;***
ClearBreakPoint:
		move.l	a1,-(a7)
		CALLEXEC	Remove
		movea.l	(a7)+,a1
		movea.l	(bp_Where,a1),a0
		move.w	(bp_Original,a1),(a0)
		moveq		#bp_SIZE,d0
		bra		FreeMem

	;***
	;Search breakpoint in all lists
	;a0 = address of code
	;-> d0 = ptr to breakpoint node if found (flags)
	;***
SearchBreakPoint:
		movem.l	a2-a3,-(a7)
		lea		(DebugList,pc),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$
		lea		(db_BreakPoints,a2),a3
3$		movea.l	(a3),a3				;Succ
		tst.l		(a3)					;Succ
		beq.b		1$
		cmpa.l	(bp_Where,a3),a0
		bne.b		3$
	;Found it !
		move.l	a3,d0
4$		movem.l	(a7)+,a2-a3
		rts
	;Not found !
2$		moveq		#0,d0
		bra.b		4$

	;***
	;Search next free number for breakpoints
	;a3 = ptr to debug node
	;-> d0 = free number
	;***
SearchFreeBreakNr:
		move.l	a2,-(a7)
		moveq		#0,d0					;Max number
		lea		(db_BreakPoints,a3),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$
		cmp.w		(bp_Number,a2),d0
		bge.b		1$
		move.w	(bp_Number,a2),d0
		bra.b		1$
2$		addq.l	#1,d0
		movea.l	(a7)+,a2
		rts

	;***
	;Function: return the current debug node
	;-> d0 = current debug node
	;***
FuncDebug:
		move.l	(CurrentDebug,pc),d0
		rts

	;***
	;Install ILLEGAL and TRACE handlers if 'mode dirty' is true,
	;or remove these handlers if 'mode dirty' is false
	;***
CheckDirty:
		move.b	(MasterPV),d0
		bne.b		6$
		rts

	;We are in Master mode
6$		bsr		GetVBR
		movea.l	d0,a0
		bsr		Disable

		moveq		#mo_Dirty,d0
		bsr		CheckModeBit
		beq.b		1$

	;We are in dirty mode, install patches
	;ILLEGAL
		lea		(IllegalTrapHandler,pc),a1
		cmpa.l	(4*4,a0),a1
		beq.b		4$
		move.l	(4*4,a0),(4,a1)	;Skip bsr.b and jmp
		move.l	a1,(4*4,a0)

	;TRACE
4$		lea		(TraceTrapHandler,pc),a1
		cmpa.l	(9*4,a0),a1
		beq.b		5$
		move.l	(9*4,a0),(4,a1)	;Skip bsr.b and jmp
		move.l	a1,(9*4,a0)

5$		bra		Enable

	;We are not in dirty mode, remove patches if needed and possible
	;ILLEGAL
1$		lea		(IllegalTrapHandler,pc),a1
		cmpa.l	(4*4,a0),a1
		bne.b		2$
		move.l	(NormalIllegalH+2,pc),(4*4,a0)

	;TRACE
2$		lea		(TraceTrapHandler,pc),a1
		cmpa.l	(9*4,a0),a1
		bne.b		3$
		move.l	(NormalTraceH+2,pc),(9*4,a0)

3$		bra		Enable

	;***
	;Exception handler for ILLEGAL
	;This exception handler is only used with 'mode dirty' on
	;'mode dirty' is useful when you want to debug programs that use
	;their own TC_TRAPCODE
	;***
IllegalTrapHandler:
		bsr.b		CheckTrapCode		;MUST BE SHORT BRANCH
											;LENGTH OF ROUTINE MUST REMAIN CONSTANT

NormalIllegalH:
		jmp		($00000000).l

	;***
	;Exception handler for TRACE
	;This exception handler is only used with 'mode dirty' on
	;'mode dirty' is useful when you want to debug programs that use
	;their own TC_TRAPCODE
	;***
TraceTrapHandler:
		bsr.b		CheckTrapCode		;MUST BE SHORT BRANCH
											;LENGTH OF ROUTINE MUST REMAIN CONSTANT

NormalTraceH:
		jmp		($00000000).l

	;***
	;This subroutine is used by the IllegalTrapHandler and the
	;TraceTrapHandler. It checks if the crashes task is a debug task
	;and restores the trapcode
	;-> preserves all registers
	;***
CheckTrapCode:
	;Check if the task is a debug task
		movem.l	d0/a0-a2,-(a7)
		movea.l	(SysBase).w,a1
		movea.l	(ThisTask,a1),a1

		move.l	(DebugList,pc),d0

	;Search debug task
2$		beq.b		1$						;Not a debug task
		movea.l	d0,a2
		cmpa.l	(db_Task,a2),a1
		beq.b		3$

		move.l	(a2),d0				;Succ
		bra.b		2$

	;We have found it!
	;First we check if we traced from SuperVisor mode
	;If that's the case we disable trace mode on the stackframe
	;a1 = pointer to task
	;a2 = pointer to debug node
3$		move.w	(4*4+4,a7),d0		;Get old SR
		btst		#13,d0
		beq.b		4$

	;Yes, it was supervisor mode
	;We must handle the exception ourselves since the AmigaDOS operating
	;system will immediatelly crash ('HELP' crash) when an exception occurs
	;from within supervisor mode
		andi.b	#$3f,(4*4+4,a7)	;Disable trace mode
		movem.l	(a7)+,d0/a0-a2
		lea		(4,a7),a7			;Skip returncode on stack
		rte

	;Now we must remember the task trapcode and restore the PV trapcode
4$		lea		(db_MOVcode,a2),a0
		lea		(TC_TRAPCODE,a1),a1
		cmpa.l	(a1),a0
		beq.b		1$

	;TrapCode has changed
		move.l	(a1),(db_TrapCode,a2)
		move.l	a0,(a1)

1$		movem.l	(a7)+,d0/a0-a2
		rts

	;***
	;Trace vector patch
	;a3 = pointer to debug node
	;stack: <high>, trap stack frame, (trap num).L, (previous d0-d1/a0-a3/a6).L
	;***
TraceVector:
		move.l	(7*4,a7),d0

		cmpi.w	#9,d0					;TRACE
		beq.b		TraceTV
		cmpi.w	#4,d0					;ILLEGAL
		beq		BreakPointTV
		sub.w		#32,d0
		blt.b		HandleCrashTV

	;It is a trap #<num> instruction, propagate this to the old TC_TRAPCODE
	;of the task
		move.l	(db_TrapCode,a3),d0
		beq.b		HandleCrashTV
		movea.l	(6*4,a7),a6			;Restore a6 from stack
		move.l	d0,(6*4,a7)			;Store pointer to TRAPCODE handler on stack
		movem.l	(a7)+,d0-d1/a0-a3	;Restore other registers
		rts								;Return to TRAPCODE handler

	;***
	;There was a crash
	;***
HandleCrashTV:
	;Store high word of trap number (least significant bits)
		move.w	(7*4+2,a7),d0
		move.w	d0,(db_Crash,a3)
		move.b	#DBS_CRASH,(db_SMode,a3)

	;Start of fix for 68000 (J.Harper)
	;Check if the	stack	has to be corrected for	68000
		tst.w		(p68020)
		bne.b		1$
		cmpi.w	#2,d0
		beq.b		2$
		cmpi.w	#3,d0
		bne.b		1$

	;Yes, do the business...
2$		move.l	a3,(3$)
		movem.l	(a7)+,d0-d1/a0-a3/a6
		move.l	(a7)+,(3$+4)
		addq.l	#8,a7
		move.l	(3$+4,pc),-(a7)
		movem.l	d0-d1/a0-a3/a6,-(a7)
		movea.l	(3$,pc),a3

1$		bra		StoreRegsTV

3$		ds.l		2
	;End of fix

	;***
	;Trace break
	;***
TraceTV:
		movea.l	(db_TRoutine,a3),a0
		jmp		(a0)

	;---
	;Special trace to skip a BSR or JSR. This routine changes the return
	;value in the stack and starts to execute the remaining instructions.
	;This trace routine is always called after a BSR or JSR. There is
	;always a longword return address on the stack
	;---
SkipTraceTV:
		move.l	usp,a0				;Remember old return value
		move.l	(a0),(db_AdditionalArg,a3)
		lea		(SkipRout,pc),a1
		move.l	a1,(a0)
		move.b	#DBS_NORMAL,(db_SMode,a3)
		move.b	#DB_EXEC,(db_Mode,a3)
		move.b	#%00000000,(db_TraceBits,a3)
		move.b	#DBT_STEP,(db_TMode,a3)
		andi.b	#$3f,(8*4,a7)		;Disable trace mode
		movem.l	(a7)+,d0-d1/a0-a3/a6
		lea		(4,a7),a7
		rte

	;---
	;Temporary trace, restore breakpoint
	;---
TempTraceTV:
		movea.l	(db_TAddress,a3),a0
		move.w	#$4afc,(a0)
		bsr		FlushCacheSuper
		move.b	#DBS_NORMAL,(db_SMode,a3)
		cmpi.b	#DB_FTRACING,(db_Mode,a3)
		bge.b		2$						;FTRACING and RTRACING
		cmpi.b	#DB_TRACING,(db_Mode,a3)
		bne.b		1$

	;We are tracing, restore routine
2$		movea.l	(db_TRoutine2,a3),a0
		move.l	a0,(db_TRoutine,a3)
		jmp		(a0)

1$		andi.b	#$3f,(8*4,a7)		;Disable trace mode
		movem.l	(a7)+,d0-d1/a0-a3/a6
		lea		(4,a7),a7
		rte

	;---
	;AFTER trace
	;---
AfterTraceTV:
		subq.l	#1,(db_Additional2,a3)
		beq		TraceBreakTV
		bra		TraceNoBreakTV

	;---
	;UNTIL trace
	;---
UntilTraceTV:
		move.l	(8*4+2,a7),d0
		cmp.l		(db_Additional2,a3),d0
		beq		TraceBreakTV
		bra		TraceNoBreakTV

	;---
	;CHECKSUM trace
	;---
CheckSumTraceTV:
		movea.l	(db_Additional2,a3),a0
		move.w	(db_Additional3,a3),d0
		moveq		#0,d1

1$		add.l		(a0)+,d1
		dbra		d0,1$

		cmp.l		(db_Additional4,a3),d1
		beq		TraceNoBreakTV
		bra		TraceBreakTV

	;The following code is not fully implemented
	;Therefore it is excluded
	IFD NotImplementedYet

	;---
	;Address mode trace (mainly for 68020 processors or higher)
	;(trace until an odd address is used)
	;---
AModeTraceTV:
	;We check if an odd address is going to be used by disassembling
	;the instruction. Only 68000 addressing modes need to be supported
	;here since the main purpose of this function is to test if the
	;software is going to run on an 68000 processor.
	;At this moment only (<offset>,<areg>) is supported (both in source
	;and destination) for word and long access.
	;Only the 'move' and 'movea' instructions are supported.
		bsr		PutAllRegs

		movea.l	(a6),a0				;Get program counter
		move.w	(a0)+,d0				;Get first instruction word
		move.w	d0,d1
		and.w		#$e000,d1
		cmp.w		#$2000,d1
		bne.b		1$

0010 000000 010010

	;It is a move.w, move.l, movea.w or movea.l instruction
		move.w	d0,d1
		bsr		CheckModeBitsTV
		bne		TraceBreakTV
		move.w	d0,d1
		lsr.w		#8,d1
		lsr.w		#1,d1					;Go to destination register field <rrr>
		and.b		#%000111,d1
		lsr.w		#3,d0					;Go to destination mode field <mmm>
		and.b		#%111000,d0
		or.b		d0,d1					;d1 = <mmmrrr> for destination
		bsr		CheckModeBitsTV
		bne		TraceBreakTV

1$		bra		TraceNoBreakTV

	;Subroutine: check for <mmmrrr> (<m>ode and <r>egister) bits and compute
	;the address that is going to be used. This function returns 0 if no
	;address is used (immediate value or register). In this case everything
	;is ok, therefore we return 0. 0 is also ok (even)
	;WARNING! At this moment this routine will not always return the correct
	;address. It will return an address that is even if the address used is
	;also even and vice versa. That is all that is guaranteed at this moment
	;a0 = pointer to extension words after instruction
	;d1 = bits
	;a3 = pointer to debug node
	;-> d1 = address (or 0) (flags set according to btst #0,d1)
	;-> d0 = preserved
CheckModeBitsTV:
		move.l	d0,-(a7)
		move.b	d1,d0
		and.b		#%111000,d0
		lsr.b		#3,d0					;Get mode bits
		beq.b		1$						;	Dn
		subq.b	#1,d0
		beq.b		1$						;	An
		subq.b	#1,d0
		beq.b		2$						;	(An)
		subq.b	#1,d0
		beq.b		2$						;	(An)+
		subq.b	#1,d0
		beq.b		2$						;	-(An)
		subq.b	#1,d0
		beq.b		3$						;	(d16,An)

	;Other addressing modes are not supported at this moment
		bra.b		1$

	;We must get the value of An ( for (An), (An)+ or -(An) )
2$		and.w		#%000111,d1			;Get register bits
		lsl.b		#2,d1					;Multiply with 4 to get the offset in the registers
		add.w		#db_Registers+8*4,d1
		move.l	(0,a3,d1.w),d1
		bra.b		10$



Probleem met de a0 pointer na de instruktie die moet upgedate worden


	;We must get the value of An and add an offset ( for (d16,An) )
3$		and.w		#%000111,d1			;Get register bits
		lsl.b		#2,d1					;Multiply with 4 to get the offset in the registers
		add.w		#db_Registers+8*4,d1
		move.w	d1,d0
		move.w	(a0),d1
		ext.l		d1
		add.l		(0,a3,d0.w),d1
		bra.b		10$

	;Everything is ok, the address is even or the addressing mode is not
	;relevant or the address mode is not supported yet
1$		moveq		#0,d1

	;The end
10$	move.l	(a7)+,d0
		btst		#0,d1
		rts

	ENDC


	;---
	;PROF trace (68020 only, flow-trace mode)
	;---
ProfTraceTV:
	;It is a flow trace exception, get the current program counter
		move.l	(8*4+2,a7),d0
		movea.l	a3,a2					;Move debug node
		moveq		#0,d1					;Range 0
		bsr		SymbolVicinity
		bsr		AddPAddress
		bra		TraceNoBreakTV

	;---
	;QUICK COND trace
	;---
QCondTraceTV:
		move.l	a3,(7*4,a7)			;Store pointer to debug node
		pea		(1$,pc)				;Address to return to
		move.l	(db_Additional,a3),-(a7)

		movem.l	(8,a7),d0-d1/a0-a3/a6
		rts								;Return to compiled condition routine

	;After execution, the compiled condition routine returns to this position
1$		movea.l	(7*4,a7),a3			;Condition codes are not affected
		beq		TraceNoBreakTV
		bra		TraceBreakTV

	;---
	;COND trace
	;---
CondTraceTV:
		bsr		PutAllRegs

		lea		(InDebugTask,pc),a0
		move.l	a3,(a0)
	;Save all other registers
		movem.l	d2-d7/a0/a3-a5,-(a7)
		lea		(DebugSP,pc),a0
		move.l	usp,a4
		move.l	a4,(a0)
		movea.l	(db_Additional,a3),a0
		bsr		Evaluate				;Get condition
		beq		ErrorTV
		movem.l	(a7)+,d2-d7/a0/a3-a5
		clr.l		(a0)
		tst.l		d0
		beq		TraceNoBreakTV
		bra		TraceBreakTV

	;---
	;OS call trace
	;---
OSCallTraceTV:
		movea.l	(8*4+2,a7),a0		;Get PC
		cmpi.w	#$4eee,(a0)			;JMP (a6)
		beq		TraceBreakTV
		cmpi.w	#$4eae,(a0)			;JSR (a6)
		beq		TraceBreakTV
		bra		TraceNoBreakTV

	;---
	;BRANCH trace
	;---
BranchTraceTV:
		movea.l	(8*4+2,a7),a0		;Get PC
		move.w	(a0),d0
		andi.w	#$ff80,d0
		cmpi.w	#$4e80,d0			;JMP/JSR
		beq		TraceBreakTV
		move.w	(a0),d0
		andi.w	#$fff0,d0
		cmpi.w	#$4e70,d0			;RTE/RTD/RTS/RTR
		beq		TraceBreakTV
		cmpi.w	#$4e60,d0			;TRAP
		beq		TraceBreakTV
		move.w	(a0),d0
		andi.w	#$fe00,d0
		cmpi.w	#$6000,d0			;BSR/BRA
		beq		TraceBreakTV
		move.w	(a0),d0
		andi.w	#$f000,d0
		cmpi.w	#$6000,d0			;Bcc
		beq.b		1$						;Yes, execute and check result
		move.w	(a0),d0
		andi.w	#$f0f8,d0
		cmpi.w	#$50c8,d0			;DBcc
		bne.b		TraceNoBreakTV		;Execute and check result

	;Instruction is a DBcc
		move.w	(a0),d0
		andi.w	#$fff8,d0			;Make register=d0
		move.w	d0,(3$)
		bsr		FlushCacheSuper
		move.w	(a0),d0
		andi.w	#$0007,d0			;Extract register
		lsl.w		#2,d0					;*4
		lea		(db_EndRegisters,a3),a0
		movem.l	d2-d7,-(a0)
		move.l	(4,a7),-(a0)		;d1
		move.l	(a7),-(a0)			;d0
		move.l	(0,a0,d0.w),d0		;Get value
3$		dbra		d0,TraceBreakTV
		bra.b		TraceNoBreakTV

	;Instruction is a Bcc
	;We must test the condition codes to see if we must branch
1$		move.w	(a0),d0
		andi.w	#$0f00,d0			;Extract condition code
		andi.w	#$f0ff,(2$)
		or.w		d0,(2$)
		bsr		FlushCacheSuper
		move.w	(8*4,a7),ccr		;Get SR
2$		beq.b		TraceBreakTV
	;Condition false, we must not break
	;Fall through

	;---
	;STEP trace
	;---
StepTraceTV:
	;Do not break, simply continue tracing
TraceNoBreakTV:
		movea.l	(8*4+2,a7),a0
		move.l	a0,(db_Instruction,a3)

		cmpi.b	#DB_RTRACING,(db_Mode,a3)
		bne.b		1$

	;We are in routine tracing, check if the instruction is a BSR or JSR
		cmpi.b	#%01100001,(a0)	;BSR
		beq.b		2$

		move.w	(a0),d0
		andi.w	#$ffc0,d0
		cmpi.w	#$4e80,d0			;JSR
		bne.b		1$

	;Yes, it is a subroutine call, skip it
2$		move.l	(db_TRoutine,a3),(db_OldTRoutine,a3)
		lea		(ROUTSkipSubTV,pc),a0
		move.l	a0,(db_TRoutine,a3)

	;SetDebugTraceBits
1$		move.b	(8*4,a7),d0
		andi.b	#$3f,d0				;Disable trace mode
		or.b		(db_TraceBits,a3),d0
		move.b	d0,(8*4,a7)

		movem.l	(a7)+,d0-d1/a0-a3/a6
		lea		(4,a7),a7
		rte

	;---
	;Special trace to skip a BSR or JSR. This version is only for
	;routine tracing
	;---
ROUTSkipSubTV:
		move.l	usp,a0				;Remember old return value
		move.l	(a0),(db_AdditionalArg,a3)
		lea		(ROUTSkipSub,pc),a1
		move.l	a1,(a0)
		move.b	#DB_EXEC,(db_Mode,a3)
		move.b	#%00000000,(db_TraceBits,a3)
		andi.b	#$3f,(8*4,a7)		;Disable trace mode
		movem.l	(a7)+,d0-d1/a0-a3/a6
		lea		(4,a7),a7
		rte

	;Breakpoint for routine tracing
ROUTSkipSub:
		illegal

	;---
	;Force trace, trace until ready
	;---
ForceTraceTV:

	;---
	;NORMAL trace
	;---
NormalTraceTV:

	;---
	;Break
	;---
TraceBreakTV:
		move.b	#DBS_TBREAK,(db_SMode,a3)
		bra		StoreRegsTV

	;---
	;There was an error
	;---
ErrorTV:
		movem.l	(a7)+,d2-d7/a0/a3-a5
		clr.l		(a0)					;a0 still points to 'InDebugTask'
		move.b	#DBS_ERROR,(db_SMode,a3)
		bra		StoreRegsTV

	;***
	;BreakPoint
	;***
BreakPointTV:
		move.l	(8*4+2,a7),d0		;PC

	;First check if we are breaking on the special 'SkipRout' address
	;In this case, we don't have a breakpoint
		lea		(ROUTSkipSub,pc),a0
		cmp.l		a0,d0
		beq.b		ROUTSkipBreakTV

		lea		(SkipRout,pc),a0
		cmp.l		a0,d0
		beq.b		SkipBreakTV

	;It is a normal breakpoint
		lea		(db_BreakPoints,a3),a1
1$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		beq		HandleCrashTV		;Brkpt does not exist
		cmp.l		(bp_Where,a1),d0
		bne.b		1$

	;We have found it
		addq.l	#1,(bp_UsageCnt,a1)
		movea.l	(bp_BRoutine,a1),a0

		jmp		(a0)

	;---
	;SKIP brkpt (to skip a BSR or JSR) (not really a breakpoint)
	;---
SkipBreakTV:
	;First restore PC
		move.l	(db_AdditionalArg,a3),(8*4+2,a7)
		bra		BreakBreakTV

	;---
	;SKIP brkpt (to skip a BSR or JSR) (version for routine tracing)
	;---
ROUTSkipBreakTV:
	;First restore PC
		move.l	(db_AdditionalArg,a3),(8*4+2,a7)
		movea.l	(db_OldTRoutine,a3),a0
		move.l	a0,(db_TRoutine,a3)
		move.b	#DB_RTRACING,(db_Mode,a3)
		move.b	#%10000000,(db_TraceBits,a3)
		jmp		(a0)					;Handle the specific code for the singlestep

	;---
	;AFTER brkpt
	;---
AfterBreakTV:
		subq.l	#1,(bp_Additional,a1)
		beq		TempBreakTV
		bra.b		BreakNoBreakTV

	;---
	;COND brkpt
	;---
CondBreakTV:
		move.l	a1,(db_DummyBP,a3)
		bsr		PutAllRegs

		movea.l	(db_DummyBP,a3),a1	;brkpt

		lea		(InDebugTask,pc),a0
		move.l	a3,(a0)
	;Save all other registers
		movem.l	d2-d7/a0/a3-a5,-(a7)
		lea		(DebugSP,pc),a0
		move.l	usp,a4
		move.l	a4,(a0)
		movea.l	(bp_Additional,a1),a0
		bsr		Evaluate				;Get condition
		beq		ErrorTV
		movem.l	(a7)+,d2-d7/a0/a3-a5
		clr.l		(a0)
		tst.l		d0
		beq.b		BreakNoBreakTV
		bra.b		NormalBreakTV

	;---
	;PROFILE breakpoint
	;---
ProfileBreakTV:
	;The breakpoint does not break for some reason
	;Remember the state of the trace bit
	;set the trace bit
	;restore the breakpoint and restart executing
	;later we will put back the breakpoint
BreakNoBreakTV:
		move.l	(db_TRoutine,a3),(db_TRoutine2,a3)
		lea		(TempTraceTV,pc),a0
		move.l	a0,(db_TRoutine,a3)
		move.b	#DBS_TTRACE,(db_SMode,a3)
		movea.l	(8*4+2,a7),a0		;PC
		move.l	a0,(db_TAddress,a3)
		move.w	(bp_Original,a1),(a0)
		ori.b		#$80,(8*4,a7)		;Enable trace mode
		movem.l	(a7)+,d0-d1/a0-a3/a6
		lea		(4,a7),a7
		rte

	;---
	;TEMP brkpt
	;---
TempBreakTV:
		bsr		ClearBreakPoint

	;---
	;NORMAL brkpt
	;---
NormalBreakTV:

	;---
	;The breakpoint breaks
	;---
BreakBreakTV:
		move.b	#DBS_BREAK,(db_SMode,a3)
StoreRegsTV:
		clr.b		(db_SpecialBit,a3)

		bsr		PutAllRegs
		lea		(4+7*4,a7),a7		;Skip everything on stack

		cmpi.b	#DB_FTRACING,(db_Mode,a3)
		bne.b		3$
	;We are flow-tracing (68020 or higher only)
	;Check if the stackframe is really for a flow-trace exception
		move.w	(6,a7),d0			;Get exception number and vector offset from stackframe
		cmpi.w	#$2000+9*4,d0
		bne.b		3$
	;Yes, it is a trace exception and we are in flow-trace mode
	;Set db_Instruction to the instruction causing the change of flow
		move.l	(8,a7),(db_Instruction,a3)

3$		andi.b	#$3f,(a7)			;Disable trace mode
		lea		(2$,pc),a0
		move.l	a0,(2,a7)
		movea.l	(SysBase).w,a6
		move.b	(TDNestCnt,a6),(db_TDNestCnt,a3)
		move.b	(IDNestCnt,a6),(db_IDNestCnt,a3)
		moveq		#-1,d0
		move.b	d0,(TDNestCnt,a6)
		move.b	d0,(IDNestCnt,a6)
		rte								;rte to 2$

	;Send signal to PowerVisor
	;a6 = execbase
	;a3 = debugnode
2$		move.l	a7,(db_SP,a3)
		movea.l	(RealThisTask),a1
		move.l	(TraceSigSet,pc),d0
		CALL		Signal
		move.b	#1,(db_SpecialBit,a3)
1$		bra.b		1$

	;---
	;CHANGESP brkpt
	;---
ChangeSPBreakTV:
		clr.b		(db_SpecialBit,a3)

		bsr		PutAllRegs
		lea		(4+7*4,a7),a7		;Skip everything on stack

		andi.b	#$3f,(a7)			;Disable trace mode
		lea		(2$,pc),a0
		move.l	a0,(2,a7)
		rte								;rte to 2$

	;Send signal to PowerVisor
	;a3 = debug node
2$		move.l	a7,(db_SP,a3)
		movea.l	(RealThisTask),a1
		move.l	(ChangeSPSigSet,pc),d0
		CALLEXEC	Signal
		move.b	#1,(db_SpecialBit,a3)
1$		bra.b		1$

	;***
	;Subroutine
	;Put all registers on stackframe in debug node structure
	;a3 = pointer to debug node
	;a7 = pointer to stackframe
	;-> a3 = debug node
	;-> a6 = pointer to db_PC in debug node
	;***
PutAllRegs:
		move.l	(a7)+,(db_Dummy,a3)	;Remember returnaddress in debug node
		move.l	a3,(7*4,a7)			;Store ptr to debug node
		lea		(db_EndRegisters,a3),a6
	;Put all registers in the debug structure so that Evaluate can find them
	;a6 = pointer to end of register table in debug node
		move.l	(6*4,a7),-(a6)		;Store a6
		movem.l	(a7),d0-d1/a0-a3	;Restore all registers except a6
		movem.l	d0-d7/a0-a5,-(a6)	;Store these registers
	;Fetch the SR and PC from the processor exception frame
		move.w	(7*4+4,a7),-(a6)	;SR
		move.l	(7*4+6,a7),-(a6)	;PC
		movea.l	(7*4,a7),a3
		move.l	(db_Dummy,a3),-(a7)	;Get returnaddress from debug node
		rts

	IFD D20

	;***
	;Dos library SetFunction routine (2.0 version)
	;a0 = offset
	;d0 = function
	;-> d0(high bits) = first word
	;-> d0(low bits) = instruction to add before address (moveq)
	;-> d1 = second long word
	;-> a0 = address
	;***
DosSetFunction:
		movea.l	(DosBase),a1
		CALLEXEC	SetFunction
		move.l	d0,d1					;Second long word
		movea.l	d1,a0					;Address
		move.l	#$4ef94e71,d0		;$4ef9 = JMP, 4e71 = NOP
		rts

	;***
	;Restore dos library (2.0 version)
	;a0 = offset
	;d0(high bits) = first word
	;d1 = second long word
	;***
DosRestore:
		movea.l	(DosBase),a1
		move.l	d1,d0					;Old function entry
		CALLEXEC	SetFunction
		rts

	ENDC

	IFND D20

	;***
	;Dos library SetFunction routine (1.3 version)
	;a0 = offset
	;d0 = function
	;-> d0(high bits) = first word
	;-> d0(low bits) = instruction to add before address (moveq)
	;-> d1 = second long word
	;-> a0 = address
	;***
DosSetFunction:
		bsr		FlushCache
		movea.l	(DosBase),a1
		bset		#1,(LIB_FLAGS,a1)
		lea		(0,a1,a0.w),a0		;Point in vector table
		move.l	(2,a0),d1			;Remember what was there
		bsr		Disable
		move.l	d0,(2,a0)			;New routine
		move.w	(a0),d0				;Remember
		move.w	#$4ef9,(a0)			;JMP
	;d0 = old first word, d1 = old long after first word
		bsr		Enable
		cmpi.w	#$4ef9,d0			;JMP
		beq.b		1$
	;It is a dos.library branch
		move.l	d1,-(a7)
		adda.w	d1,a0
		addq.w	#4,a0					;Compute real branch address
		move.w	d0,d1
		swap		d0
		move.w	d1,d0
		move.l	(a7)+,d1
	;Compute checksum
2$		movem.l	d0-d1/a0,-(a7)
		CALLEXEC	SumLibrary
		bsr		FlushCache
		movem.l	(a7)+,d0-d1/a0
		rts
	;There was a normal branch
1$		swap		d0
		move.w	#$4e71,d0			;NOP
		movea.l	d1,a0
		bra.b		2$

	;***
	;Restore dos library (1.3 version)
	;a0 = offset
	;d0(high bits) = first word
	;d1 = second long word
	;***
DosRestore:
		movea.l	(DosBase),a1
		bset		#1,(LIB_FLAGS,a1)
		lea		(0,a1,a0.w),a0
		CALLEXEC	Disable				;Don't use sub Disable because other tasks
											;may use this routine
		swap		d0
		move.w	d0,(a0)
		move.l	d1,(2,a0)
		CALL		Enable
		bsr		FlushCache
		CALL		SumLibrary
		rts

	ENDC

	;***
	;LoadSeg patch routine
	;***
LoadSegPatch:
	;Restore patch
		movem.l	d0-d1/a0-a1/a6,-(a7)
		CALLEXEC	Forbid
		lea		(PatchCounter,pc),a0
		subq.w	#1,(a0)
		bgt.b		2$
		bsr		RestoreLoadSegPatch
2$		CALLEXEC	Permit
		movem.l	(a7)+,d0-d1/a0-a1/a6
ToLoadSegJmp	equ	*-LoadSegPatch
		dc.w		0						;Here comes the MOVEQ for dos (or a NOP in ADos 2.0)
		jsr		($00000000).l
		tst.w		(PatchCounter)
		bgt.b		1$
		tst.l		d0
		beq.b		1$						;If no success, we do nothing
											;Note that the user has to cancel the 'debug n'
											;command in order to continue
		movem.l	a0-a1,-(a7)
		movea.l	d0,a0					;Segment
		adda.l	a0,a0
		adda.l	a0,a0					;BPTR->APTR
		lea		(4,a0),a0			;Skip segment info
		move.l	a0,(Dummy)			;Store PC
		move.w	(a0),(Dummy+8)		;Remember old
		move.w	#$4afc,(a0)			;ILLEGAL
		bsr		FlushCache
		lea		(InTaskWait,pc),a0
		move.b	#1,(a0)
	;The following three lines make sure that the crashing of the proces
	;that we are going to debug is detected by our global TrapCode routine.
	;If we do not do this, you have type 'run' in front of the commandline
	;since the shell where you choose to start your program probably has its
	;TC_TRAPCODE not set right.
	;If you type 'run' before the program that you want to debug there is
	;no problem.
		movea.l	(SysBase).w,a1
		movea.l	(ThisTask,a1),a0
		move.l	(TaskTrapCode,a1),(TC_TRAPCODE,a0)
		movem.l	(a7)+,a0-a1
1$		rts
AfterLSeg	equ	*-LoadSegPatch
		dc.l	0,0

	;***
	;Restore loadseg patch
	;***
RestoreLoadSegPatch:
		CALLEXEC	Disable				;Don't use sub Disable because other tasks
											;may use this routine
		lea		(LoadSegPatch,pc),a0
		move.l	(AfterLSeg,a0),d0
		move.l	(AfterLSeg+4,a0),d1
		movea.l	#_LVOLoadSeg,a0
		bsr		DosRestore
		CALLEXEC	Enable
		rts

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;***
	;Start of DebugBase
	;***
DebugBase:

m68881:			dc.l	0				;4 if floatingpoint coprocessor
DebugList:		ds.b	LH_SIZE		;List for debug nodes
CurrentDebug:	dc.l	0				;Current debug node
TraceSigNum:	dc.l	0
TraceSigSet:	dc.l	0
DebugSigNum:	dc.l	0
DebugSigSet:	dc.l	0
InDebugTask:	dc.l	0				;DebugNode if we are executing in a debug task
DebugSP:			dc.l	0				;Stack for debugtask
DebugRegsInfo:	dc.b	1				;Give register info after each trace
DebugCodeInfo:	dc.b	1				;Give disassembly after each trace
DebugShowInfo:	dc.w	5				;Number of lines to disassemble
DebugPrevInfo:	dc.w	1				;Show previous instr after each trace

TabSize:			dc.w	8				;Tab size for source window

PatchCounter:	dc.w	0				;Counter for 'debug n' and 'debug c'
CurDispDebug:	dc.l	0				;Current debug node for fullscreen debugger

	;***
	;End of DebugBase
	;***

InTaskWait:		dc.b	0				;If 1 we are in task wait mode (debug)
BackFromSignal: dc.b	0				;When 1 we are out the signal routine
											;(for RoutDebug)
	;Routines for each breakpointtype (for AddBreakPoint)
BrkPtType:		dc.b	BP_TEMP,BP_COND,BP_AFTER,BP_NORMAL,BP_PROFILE
	EVEN
BrkPtRout:		dc.l	TempBreakTV,CondBreakTV,AfterBreakTV,NormalBreakTV
					dc.l	ProfileBreakTV

	IFD	D20
	;Tags for CreateNewProc
CNProcTags:
		dc.l		NP_Seglist,0
		dc.l		NP_Name,0
		dc.l		NP_Priority,0
		dc.l		NP_FreeSeglist,1
		dc.l		NP_StackSize,20000
		dc.l		NP_Cli,1
		dc.l		NP_Arguments,ProcArgs
;		dc.l		NP_ExitCode,
		dc.l		TAG_DONE

ProcArgs:	dc.b	10,0
	ENDC

	;CommandLine options for 'trace','debug','break' and 'symbol' and the
	;corresponding routines
OptTraceStr:	dc.b	"NUROCBIGSHFJTQPZ",0
OptDebugStr:	dc.b	"TNLRFDUCQS",0
OptBreakStr:	dc.b	"TNRPAC",0
OptWatchStr:	dc.b	"RASC",0
OptSymbolStr:	dc.b	"LRASCT",0
OptSourceStr:	dc.b	"LWSRTCGAH",0
OptDbSrcStr:	dc.b	"ACS",0
		EVEN
OptTraceRout:	dc.l	TraceMoreTR,TraceUntilTR,TraceRegTR,TraceOverTR
					dc.l	TraceCondTR,TraceBranchTR,PrintInfoTR,TraceGoTR
					dc.l	TraceSkipTR,TraceHaltTR,TraceForceStepTR,TraceOSCallTR
					dc.l	TraceSkipBranchTR,TraceQuickCondTR,TraceProfileTR
					dc.l	TraceCheckSumTR,TraceErrorTR
OptDebugRout:	dc.l	StopTaskRDB,NextTaskRDB,LoadTaskRDB,RemoveRDB
					dc.l	RemoveFreezeRDB,CreateDummyRDB,UnloadRDB,CatchTaskRDB
					dc.l	QuitCodeRDB,SourcePathRDB
					dc.l	DebugErrorRDB
OptBreakRout:	dc.l	BreakTempBR,BreakNormalBR,BreakRemoveBR
					dc.l	BreakProfileBR,BreakAfterBR,BreakCondBR,BreakErrorBR
OptWatchRout:	dc.l	WatchRemWA,WatchAddWA,WatchShowWA,WatchClearWA
					dc.l	WatchErrorWA
OptSymbolRout:	dc.l	SymbolLoadRS,SymbolRemRS,SymbolAddRS,SymbolShowRS
					dc.l	SymbolClearRS,SymbolRemoveTempRS,SymbolErrorRS
OptSourceRout:	dc.l	SourceLoadRSR,SourceWhereRSR,SourceShowRSR
					dc.l	SourceCurrentRSR,SourceSetTabSizeRSR
					dc.l	SourceClearRSR,SourceGotoLineRSR
					dc.l	SourceGotoAddressRSR,SourceHoldRSR,SourceErrorRSR
OptDbSrcRout:	dc.l	PathAddDSR,PathClearDSR,PathShowDSR,PathErrorDSR

;FormatSymbols:	dc.b	"%-40.40s : %08lx , %-15.ld",10,0
FormatSymbols:
		FF			ls_,40,str_,":",X_,0
		dc.b		",",32
		FF			lD,15,nlend,0
FormatWatch:
		FF			X,0,str_,":",X,0,spc,1
		FF			lD,15,nlend,0

	;Messages
MesCurDir:		dc.b	"<current dir>",0
MesTaskWait:	dc.b	"Waiting for new task...",10,0
MesProcWait:	dc.b	"Waiting for new process...",10,0
MesQuitProg:	dc.b	"Program quits!",10,0
MesNoTaskLoad:	dc.b	"No task loaded",10,0
MesNoSource:	dc.b	"Source not loaded (file error?)",10,0
MesColon:		dc.b	" : ",0
MesEmpty:		dc.b	0

	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	IFD	SUSPICION
DebugLongFormat:
					dc.b	"%08lx",10,0
	ENDC

	END
