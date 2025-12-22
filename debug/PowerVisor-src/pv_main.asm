*****
****
***			P O W E R V I S O R
**
*				Version 1.43
**				Thu Mar 31 19:35:05 1994
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

			INCLUDE	"pv.arexx.i"
			INCLUDE	"pv.main.i"
			INCLUDE	"pv.screen.i"
			INCLUDE	"pv.eval.i"
			INCLUDE	"TileWindows.i"

			INCLUDE	"pv.lib.i"
			INCLUDE	"pv.errors.i"

	XDEF		DosBase,Gfxbase,IntBase,ExpBase
	XDEF		CountRefresh,LastCmd,Storage,Dummy,ModeChangeRout
	XDEF		HandlerStuff,CheckPause,CheckBreak,RefreshCmd,RefreshSet,InputRequestB
	XDEF		SpeedRefresh,ExecAlias,KeyAttach,CheckModeBit,ClearModeBit
	XDEF		ErrorFile,RoutGo2,ErrorRoutine,GetNextList
	XDEF		AddHistory,ScriptPath,FastFPrint,SPrintf
	XDEF		CreatePort,DeletePort,LMult,LMod,LDiv,InHold
	XDEF		PVBase,SetError,GetError,_SysBase,DFBase
	XDEF		RexxCommandList,PVCallTable,RefreshNum
	XDEF		IDevSigSet,InputDevCmd,InputDevArg,ErrorHandler
	XDEF		EndProg,ClearBreak,PVBreakSigSet,Remind,ClearBreakSig
	XDEF		_Print,_PrintNum,__CXM33,__CXD33,_CheckForSymbol,CallDisasm
	XDEF		Disable,Enable,Forbid,Permit,LastError,HandleError
	XDEF		FrontSigSet,BreakTaskPtr,ExpansLib,ResetHistory
	XDEF		CopyFileName,LayersBase,CheckOption
	XDEF		MasterPV,MainPr,Detach,CmdLine,HoldSigSet,PrintFor,PrintForQ

	;screen
	XREF		ScreenConstructor,ScreenDestructor,BusyPrompt
	XREF		DoFeedBack,Line
	XREF		PrintRealHexNL,PrintHex,RefreshGadget,PrintAC
	XREF		FuncGetX,FuncGetY,FuncGetChar,FuncLines,FuncCols
	XREF		FuncKey,RoutDisp,RoutCls,RoutLocate,RoutPrint,RoutScreen,RoutSize
	XREF		Scan,MyScreen,RoutColor,FuncQual,MainPW,MainLW,RefreshLW
	XREF		CurrentLW,RoutCurrent,FuncCurrent
	XREF		CloseScreen,PrintChar,LogWin_PrintChar
	XREF		RoutSetFont,ReOpenScreen
	XREF		SetLogWinFlags,RoutColRow,FuncGetCol,FuncGetRow
	XREF		RoutRWin,RoutXWin,RoutDWin,RoutOn,ClosePW,RoutSWin
	XREF		RoutFit,HideCurrent,UnHideCurrent
	XREF		RoutReqLoad,RoutReqSave,RoutRequest,RoutGetString,RoutScan
	XREF		PVScreen,RoutHome,RequestIt
	XREF		RoutLWPrefs,MainEntry,DefLineLen,DontClearLine,GadCursorPos
	XREF		SetCursor,mStringInfo,SnapBuffer,SnapCommand,ScreenBase
	XREF		mStringGad,WindowGadgetPort
	XREF		RoutOpenLW,RoutOpenPW,RoutCloseLW,RoutClosePW
	XREF		RoutAWin,RoutOWin,RoutSetFlags,UpdateSBottom,RoutMove,RoutWWin
	XREF		RoutActive,FuncGetActive,ExtraShare,SpecialFlags,StartupX,ScreenW
	XREF		PhysWin_ActivateWindow,SpecialPrint
	XREF		LogWin_StartPage,NoFancyPens,FancyPens,RoutScroll,ScanStanLogWin
	XREF		LogWin_Refresh,LogWin_GetWord
	XREF		LockWin,LockState,TextAttrib,TopazName
	XREF		UpdatePrefs,FuncPubScreen,FuncGetLine
	XREF		ActivateGadget,SBarMode
 IFD D20
	XREF		TestForClose,Global_CleanBoxes,myGlobal
 ENDC
	;debug
	XREF		DebugConstructor,DebugDestructor,DebugList,CheckIfTrace
	XREF		FuncDebug,RoutSource,CheckDirty,RoutDPrevI,RoutDNextI
	XREF		RoutBreak,RoutDebug,RoutDPref,RoutDUse,RoutDMode
	XREF		RoutSymbol,RoutTrace,RoutWith,RoutDScroll,RoutDStart
	XREF		FuncTopPC,FuncBotPC,FuncIsBreak,RoutDRefresh,DebugBase
	XREF		DebugRegsInfo,CurrentDebug,GetSymbolStr,FuncGetSymStr
	XREF		RoutWatch
	;eval
	XREF		EvalConstructor,EvalDestructor,LongToHex,WordToHex,ByteToHex
	XREF		Assignment,SearchWord,CreateConst
	XREF		HandleGroup,Evaluate,GetStringE,GetString,GetStringPer,VarStorage
	XREF		SkipSpace,SearchWordEx,CompareCI,SkipNSpace,RemVarFunc
	XREF		RoutCreateFunc,RoutRemVar,RoutVars,CreateFunc,LongToDec
	XREF		GetRestLine,GetRestLinePer,FuncEval,FuncIf,AddressVar,EvalBase
	XREF		SkipObject,Upper
	;file
	XREF		FileConstructor,FileDestructor,PrintCLI,FOpen,FRead,FReadLine,FClose
	XREF		FSeek,OutputHandle,RoutTo,FileBase,GetTemplate,OpenDos
	XREF		RoutHelp,ScriptFile,RoutLog,SearchPath,RoutAppendTo
	;memory
	XREF		MemoryConstructor,MemoryDestructor,ClearAutoClear,FlashRed
	XREF		MakeNodeInt,AllocClear,StoreRC,FreeBlock,AddAutoClear
	XREF		AllocStringInt,ReAllocMem,FuncAlloc
	XREF		FuncFree,FuncGetSize,FuncReAlloc,RoutSearch,FuncLastMem,FuncLastFound
	XREF		RoutCopy,RoutClear,RoutFill,RoutMemory,RoutMemTask,RoutNext
	XREF		RoutCleanup,RoutShowAlloc,FuncIsAlloc
	XREF		RoutView,RoutAddTag,RoutRemTag,RoutTags,RoutCheckTag
	XREF		RoutSaveTags,RoutLoadTags,RoutClearTags,FuncLastLines
	XREF		RoutUseTag,FuncTagList,RoutTg,MemoryPointer,FuncLastBytes
	XREF		MemoryBase,AllocBlockInt,AddPointerAlloc,RemPointerAlloc
	XREF		DisasmSmart,ViewPrintLine,RoutPVMem
	XREF		AllocMem,FreeMem,ReAlloc,CompactRegion
	;general
	XREF		GeneralConstructor,GeneralDestructor,CrashSigBit,CrashSignal
	XREF		AllocSignal,RealThisTask,Port,InstallDevice
	XREF		RemoveDevice,RoutHunks,RoutRemove,RoutFRegs
	XREF		RoutAccount,RoutAddFunc,RoutDevCmd,RoutDevInfo,RoutCloseWindow
	XREF		RoutCloseScreen,RoutCloseDev,RoutCurDir,RoutFreeze,RoutGo
	XREF		RoutKill,RoutLoad,RoutLibInfo,RoutLoadFd,RoutOpenDev,RoutPathName
	XREF		RoutRemFunc,RoutRemCrash,RoutRegs,RoutRemRes,RoutRemHand
	XREF		RoutRBlock,RoutSave,RoutTaskPri,RoutUnAsm,CheckAddTaskPatch
	XREF		RoutUnLoadFd,RoutUnFreeze,RoutUnLock,RoutWBlock
	XREF		RoutLibFunc,PortName,PortNameEnd,PlaySound,GeneralBase
	XREF		StackFailL,RoutSPrint,CheckStack,FuncCheckSum
	XREF		RoutResident,RoutUnResident,RoutStack,FuncGetStack,RoutTrack
	XREF		RemoveException,RoutCrash,RoutFloat,RoutProf
	;list
	XREF		FuncBase,ListConstructor,ListDestructor
	XREF		RoutLWin,RoutPWin,RoutStruct
	XREF		RoutAtta,RoutDevs,RoutDosd,RoutDbug,RoutExec,RoutCrsh,RoutConf
	XREF		RoutFils,RoutFont,RoutFunc,RoutFDFi,RoutGraf,RoutIntb,RoutIntr
	XREF		RoutIHan,RoutLibs,RoutLock,RoutMemr,RoutPort,RoutResm,RoutReso
	XREF		RoutScrs,RoutSema,RoutTask,RoutWins,RoutInfo,RoutList,RoutStru
	XREF		RoutGadgets,RoutLList,ResetList,SetList,ListBase
	XREF		RoutInterprete,RoutAddStruct,RoutRemStruct,FuncPeek,FuncAPeek
	XREF		FuncCurList,RoutOwner,FuncStSize,RoutFor,RoutClearStructs
 IFD	D20
	XREF		RoutPubS,RoutMoni
 ENDC
	;arexx
	XREF		ARexxConstructor,ARexxDestructor,RoutRx,RoutSync,RoutASync
	XREF		RoutHide,RoutUnHide,ARexxBase,RoutClip,RoutRemClip
	XREF		RoutString,RexxBit,CheckRexx,FuncARexxPort
	XREF		InSync,Hide
	;mmu
	XREF		RoutMMUTree,RoutSpecRegs,RoutMMURegs,RoutMMUEntry
	XREF		RoutSPoke,RoutSPeek,RoutMMUReset,MMUConstructor,MMUDestructor
	XREF		RoutMMUWatch,FuncGetMMUEntry,RoutProtect,RoutTagType
	;mondis
	XREF		_disasm,_getstr

	;amiga.lib
 IFND D20
	XREF		_CreatePort,_DeletePort
 ENDC


;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

CHECKERR	macro		*
			lea		(\1,pc),a0
			bsr		StartupError
			endm

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------


	IFD D20
	;This section is needed because this hunk MUST be the second hunk
	;(just after the detach code). If we omit this 'section' command,
	;the hunks may be put anywhere
	section MainCode,code
	ENDC


	;Start main program
MainPr:
		lea		(DosLib,pc),a1
		CALLEXEC	OldOpenLibrary
		lea		(DosBase,pc),a0
		move.l	d0,(a0)

	;Get output handle
		CALLDOS	Output
		lea		(OutputHandle),a0
		move.l	d0,(a0)

	;AmigaDOS 2.0 ?
		lea		(DOS2,pc),a0
		clr.w		(a0)
		movea.l	(DosBase,pc),a6
		move.w	(LIB_VERSION,a6),d0
		cmpi.w	#36,d0
		blt.b		5$

	;Yes
		move.w	#1,(a0)

	;Check if cli or workbench
5$		move.l	(Detach,pc),d0
		bne.b		1$							;If detach, we don't check for CLI or workbench
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a3
		tst.l		(pr_CLI,a3)
		bne.b		1$

	;Workbench
		lea		(pr_MsgPort,a3),a0	;Our process base
		CALLEXEC	WaitPort
		lea		(pr_MsgPort,a3),a0	;Our process base
		CALL		GetMsg
		lea		(WBenchMsg,pc),a0
		move.l	d0,(a0)

	;First check if PowerVisor is already started
1$		lea		(PortName),a1
		CALLEXEC	FindPort
		tst.l		d0
		beq.b		3$

	;PowerVisor is already started
		lea		(MasterPV,pc),a0
		clr.b		(a0)						;This is a slave
		moveq		#'1',d2

	;Search the first free port number
4$		lea		(PortNameEnd),a0
		move.b	#'.',(a0)+
		move.b	d2,(a0)
		addq.b	#1,d2
		lea		(PortName),a1
		CALLEXEC	FindPort
		tst.l		d0
		bne.b		4$

		lea		(PortNameEnd),a1
		lea		(BreakTaskNameEnd,pc),a0
		move.b	(a1),(a0)+
		move.b	(1,a1),(a0)
		lea		(InputNameEnd,pc),a0
		move.b	(a1)+,(a0)+
		move.b	(a1),(a0)

	;Check if correct OS
3$		tst.w		(DOS2)
 IFD D20
		bne.b		2$
 ENDC
 IFND D20
 		beq.b		2$
 ENDC
		moveq		#ERROR_OS,d0
		CHECKERR	ErrLib
2$

	;Normal init
StartPV:
		bsr		OpenLib
		CHECKERR	ErrLib
		bsr		MemoryConstructor
		CHECKERR	ErrMemory
		bsr		InitMain
		CHECKERR	ErrMain
		bsr		EvalConstructor
		CHECKERR	ErrEval

	;First try to open config file
		movea.l	(VarStorage),a0
		lea		(VOFFS_MODE,a0),a0
		move.l	#$0006E149,(a0)

	;Check if we must use the config file
		moveq		#'c',d0
		bsr		CheckOption
		bne		2$
		bsr		ReadConfigFile

	;Rest of init routine
2$		bsr		GeneralConstructor
		bsr		ScreenConstructor
		CHECKERR	ErrScreen
		bsr		FileConstructor
		bsr		ListConstructor
		bsr		DebugConstructor
		bsr		ARexxConstructor
		bsr		MMUConstructor
		bsr		InstallBreakTask
		CHECKERR	ErrBreak
		bsr		InstallInputDevice
		CHECKERR	ErrInput
		bsr		InitScriptLine
		CHECKERR	ErrMem
		bsr		InitFunctions
		CHECKERR	ErrMem
	;Start main routine
		bsr		Main
EndProg:
		bsr		ClearAutoClear
*		bsr		RemoveKeyAttach
		bsr		FreeHistory
ErrMem:
*		bsr		FreeMemory
ErrInput:
		bsr		RemoveInputDevice
ErrBreak:
		bsr		RemoveBreakTask
		bsr		MMUDestructor
		bsr		ARexxDestructor
		bsr		DebugDestructor
		bsr		ListDestructor
		bsr		FileDestructor
ErrScreen:
		bsr		ScreenDestructor	;Order \
		bsr		GeneralDestructor
ErrEval:									;			----- is important
		bsr		EvalDestructor		;Order /
ErrMain:
		bsr		CloseMain
ErrMemory:
		bsr		MemoryDestructor	;MUST BE LAST!!!!
ErrLib:
	;Reply workbench
		move.l	(WBenchMsg,pc),d0
		beq.b		CloseProg
		bsr		Forbid
		movea.l	(WBenchMsg,pc),a1
		CALLEXEC	ReplyMsg
		bsr		Permit
CloseProg:
		bsr		CloseLib
		moveq		#0,d0
		rts

	;***
	;Startup error routine (always call with bsr)
	;d0 = error code (or 0 if no error)
	;a0 = error routine
	;***
StartupError:
		tst.l		d0
		beq.b		1$
		move.l	a0,(a7)				;Replace return address on stack with error routine
		lea		(StartupErrors,pc),a0
		subq.l	#1,d0
		lsl.l		#2,d0
		movea.l	(0,a0,d0.l),a0
		bsr		PrintCLI
1$		rts

;***************************************************************************

	;***
	;Main routine
	;***
Main:
		bsr		PrintName

	;Check if we must start the PowerVisor-startup file
		moveq		#'s',d0
		bsr		CheckOption
		bne.b		BeforeMainLoop

		pea		(ExecScript,pc)
		bsr		RememberItAndJmp

	;If we come here there was an error in the script
	;We ignore this error
		bra.b		BeforeMainLoop

ExecScript:
		bsr		BusyPrompt
		lea		(pvStartupFile,pc),a0
		bsr		CopyFileName
		beq.b		BeforeMainLoop
		movea.l	d1,a0
		bsr		RoutScript

	;Install error handler (mainly for Quit error)
BeforeMainLoop:
		pea		(MainLoop,pc)
		bsr		RememberItAndJmp

	;There was an error, check if the error was a 'Quit' error
MainError:
		cmpi.w	#ERR_Quit,(LastError)
		bne.b		2$
		rts
2$		bsr		PrintError

	;The PowerVisor Main Loop
MainLoop:
		bsr		CompactRegion
		bsr		Scan
		bsr.b		ExecCmdLine
		beq.b		MainError
		bra.b		MainLoop

	;***
	;Execute a given commandline
	;	- Support for everything that 'ExecAlias' supports
	;	- This function calls the Pre- and Post- exec routines
	;	- This function checks for the '~' and '\' prefix operators
	;	- This function clears break checking
	;	- This function starts a new page on the current logical window
	;	- This function performs the feedback
	;	- This function sets the busy prompt
	;Line = ptr to commandline
	;-> d0 = result from command
	;-> d1 = 0, flags if error
	;***
ExecCmdLine:
		movea.l	(CurrentLW),a0
		bsr		LogWin_StartPage
		bsr		ClearBreak
		movea.l	(Line),a0
		bsr		SkipSpace
		move.b	(a0),d0
		cmp.b		(SuppressChar,pc),d0
		bne.b		1$
	;Yes, feedback suppress
		move.b	#' ',(a0)
		bra.b		2$
1$		bsr		DoFeedBack
2$		bsr		BusyPrompt
	;Check if there is a pre-command to execute
		movea.l	(Line),a0
		bsr		SkipSpace
		move.b	(a0),d0
		cmp.b		(QuickExecChar,pc),d0
		bne.b		3$
	;Yes, remove the quick-exec-char ('\')
		move.b	#' ',(a0)
		moveq		#1,d7					;Remember that there should be no 'enter' commands
		bra.b		4$

	;We don't suppress the 'enter' commands, check here if there are any
3$		moveq		#0,d7					;There could be 'enter' commands
		move.l	(EnterCommand,pc),d1
		beq.b		4$
		movea.l	d1,a0
		moveq		#EXEC_ENTER,d0
		move.l	d7,-(a7)
		bsr		ExecAlias
		movem.l	(a7)+,d7				;For flags
		bne.b		4$
	;There was an error in the 'enter' command. If that is the case we
	;clear the error state and ignore the command
		lea		(LastError,pc),a0
		clr.w		(a0)
		moveq		#0,d0
		moveq		#1,d1					;Success
		rts

4$		movea.l	(Line),a0
		moveq		#EXEC_CMDLINE,d0
		move.l	d7,-(a7)
		bsr		ExecAlias
		move.l	(a7)+,d7
		tst.l		d7
		bne.b		5$

	;We don't suppress 'enter' commands, check here if there are any
		movem.l	d0-d1,-(a7)
		move.l	(AfterCommand,pc),d1
		beq.b		6$
		movea.l	d1,a0
		moveq		#EXEC_AFTER,d0
		bsr		ExecAlias
6$		movem.l	(a7)+,d0-d1

5$		tst.l		d1						;For flags
		rts

	;***
	;Execute a given commandline
	;	- Support for everything that 'ExecPrefix' supports
	;	- Checks for aliases
	;	- Double support for prefix operators (';', '-')
	;	- This function does not call the Pre- and Post- exec routines
	;a0 = ptr to cmdline
	;d0 = EXEC_ type
	;-> d0 = result from command
	;-> d1 = 0, flags if error
	;***
ExecAlias:
		lea		(ExecLevel,pc),a1
		move.w	d0,(a1)
		bsr		SkipSpace
		move.b	(a0),d0
		cmp.b		(CommentChar,pc),d0
		bne.b		1$

	;Comment
		moveq		#0,d0					;Return code 0 for comments
		moveq		#1,d1					;Success, flags
		rts

1$		moveq		#0,d1					;No, we have not hidden output
		cmp.b		(NoOutputChar,pc),d0
		bne.b		2$
		bsr		HideCurrent
		moveq		#1,d1					;Yes, we have hidden output
		lea		(1,a0),a0			;Skip '-'

2$		movem.l	d0-d1,-(a7)			;Remember old state and output-hidden-flag
		bsr		SkipSpace
		bsr		AliasToCmd
		bne.b		4$

	;Error
		moveq		#0,d1					;For error
		bra.b		5$

4$		move.l	a0,-(a7)				;Remember copy of commandline made by 'AliasToCmd'
		bsr		ExecPrefix			;'ExecPrefix' has the appropriate return codes
		movea.l	(a7)+,a0
		bsr		FreeBlock			;Free cmdline

5$		movem.l	(a7)+,d2-d3			;Get old state and output-hidden-flag
		movem.l	d0-d1,-(a7)			;Remember return code and error flag

		tst.l		d3						;Have we hidden output ?
		beq.b		3$

	;Yes, we have hidden output
		move.l	d2,d0
		bsr		UnHideCurrent

	;No, we have not hidden output
3$		movem.l	(a7)+,d0-d1			;Restore them
		tst.l		d1						;For flags
		rts

	;***
	;Execute a given commandline
	;	- Support for everything that 'ExecCommon' supports
	;	- Support for prefix operators (';', '-')
	;	- This function does not call the Pre- and Post- exec routines
	;a0 = ptr to cmdline
	;-> d0 = result from command
	;-> d1 = 0, flags if error
	;***
ExecPrefix:

		tst.b		(PVDebugMode)
		beq.b		4$
		movem.l	a0-a6/d0-d7,-(a7)
		moveq		#'>',d0
		bsr		PrintChar
		bsr		PrintChar
		bsr		PrintChar
		moveq		#' ',d0
		bsr		PrintChar
		PRINT
		NEWLINE
		movem.l	(a7)+,a0-a6/d0-d7

4$		bsr		SkipSpace
		move.b	(a0),d0
		cmp.b		(CommentChar,pc),d0
		bne.b		1$

	;Comment
		moveq		#0,d0					;Return code 0 for comments
		moveq		#1,d1					;Success, flags
		rts

1$		moveq		#0,d1					;No, we have not hidden output
		cmp.b		(NoOutputChar,pc),d0
		bne.b		2$
		bsr		HideCurrent
		moveq		#1,d1					;Yes, we have hidden output
		lea		(1,a0),a0			;Skip '-'

2$		movem.l	d0-d1,-(a7)			;Remember old state and output-hidden-flag
		bsr		ExecCommon			;'ExecCommon' has the appropriate return codes
		movem.l	(a7)+,d2-d3			;Get old state and output-hidden-flag
		movem.l	d0-d1,-(a7)			;Remember return code and error flag

		tst.l		d3						;Have we hidden output ?
		beq.b		3$

	;Yes, we have hidden output
		move.l	d2,d0
		bsr		UnHideCurrent

	;No, we have not hidden output
3$		movem.l	(a7)+,d0-d1			;Restore them

		tst.b		(PVDebugMode)
		beq.b		5$
		movem.l	a0-a6/d0-d7,-(a7)
		move.l	d0,-(a7)
		moveq		#'<',d0
		bsr		PrintChar
		bsr		PrintChar
		bsr		PrintChar
		moveq		#' ',d0
		bsr		PrintChar
		move.l	(a7)+,d0
		PRINTHEX
		movem.l	(a7)+,a0-a6/d0-d7

5$		tst.l		d1						;For flags
		rts

	;***
	;Execute a given commandline
	;	- Support for everything that 'ExecLine' supports
	;	- Support for assignment operator
	;	- Support for group operator
	;	- No support for prefix operators (';', '-', ...)
	;	- This function does not call the Pre- and Post- exec routines
	;	- This function checks the stack
	;a0 = commandline
	;-> d0 = return value from routine
	;-> d1 = 0, flags if error (LastError contains number of error)
	;***
ExecCommon:
		bsr		CheckStack
		SERRlt	StackOverflow,2$
		bsr		SkipSpace
		cmpi.b	#'{',(a0)			;Group ?
		beq.b		1$
		bsr		Assignment
		beq		ExecLine				;'ExecLine' has the appropriate return codes

	;Assignment
		tst.l		d1
		rts

	;Group operator
1$		lea		(1,a0),a0			;Skip '{'
		bra		HandleGroup			;'HandleGroup' has the appropriate return codes

	;Stack overflow
2$		moveq		#0,d1
		rts

	;***
	;Execute a given commandline
	;	- No alias expansion is done
	;	- Assignments are not supported
	;	- Command grouping (the group operator) is not supported
	;	- Prefix commandline operators (like '~' and '-') are not supported
	;	- Comments are not supported
	;	- The template argument '?' is supported
	;	- An empty commandline is supported (for display routines)
	;	- d6 is correctly initialized for the current list commands
	;	- This function does not call the Pre- and Post- exec routines
	;	- This function does a 'ResetList' after executing the command
	;	- This function sets the error variable to 0
	;a0 = pointer to commandline
	;-> d0 = return value from routine
	;-> d1 = 0, flags if error (LastError contains number of error)
	;***
ExecLine:
		lea		(LastError,pc),a1
		clr.w		(a1)
		bsr		SkipSpace
		tst.b		(a0)
		bne.b		3$
		lea		(RoutDummy,pc),a5
		bra.b		2$

3$		lea		(RealCommands,pc),a1
		lea		(GetNextListCmd,pc),a5
		bsr		SearchWord
		move.l	d1,d2					;Remember pointer to list element for this routine
		SERReq	Syntax,1$

	;We found the routine
		movea.l	a0,a5
		movea.l	a1,a0					;Pointer after command
		NEXTTYPE
		cmpi.b	#'?',(a0)			;Template ?
		bne.b		2$

	;Show template
		movea.l	d2,a0					;Pointer to list element
		movea.l	(a0),a0				;Pointer to command string
		lea		(GetTemplate),a5
		bsr		ErrorHandler		;'ErrorHandler' returns appropriate registers
		bra.b		1$

	;Normal execution
2$		moveq		#I_LAST,d6			;For the current list functions
		cmpa.l	#RoutDummy,a5
		beq.b		4$
		lea		(LastCmd,pc),a1
		clr.b		(a1)
	;Execute command
4$		bsr		ErrorHandler		;'ErrorHandler' returns appropriate registers

	;The end
1$		bsr		ResetList
		tst.l		d1						;For flags
		rts

	;***
	;Command: (ARexx) assignment
	;***
RoutAssign:
		bsr		GetRestLine
		HERReq
		movea.l	d0,a0
		bra		Assignment

	;***
	;Remember this stack position and program counter and jump to
	;the address on stack. This routine must be called with 'bsr'
	;This routine automatically removes this address from the stack
	;
	;Before 'RememberItAndJmp' :
	;	stack
	;			<rest of stack>
	;			<routine1>			<- top of stack
	;	pc
	;			<routine2>
	;
	;After 'RememberItAndJmp' :
	;	stack
	;			<rest of stack>	<- top of stack
	;	pc
	;			<routine1>
	;
	;Before 'Remind' :
	;	stack
	;			<rest of stack>
	;			???					<- top of stack
	;	pc
	;			???
	;
	;After 'Remind' :
	;	stack
	;			<rest of stack>	<- top of stack
	;	pc
	;			<routine2>
	;
	;***
Remind:
		movea.l	(StackPointer,pc),a7
		move.l	(ProgramCounter,pc),(a7)
		rts

RememberItAndJmp:
		move.l	(a7)+,(ProgramCounter)
		move.l	a7,(StackPointer)
		rts

	;***
	;Search for a one-letter-option in the commandline and return the
	;pointer to the characters after the option (or NULL)
	;d0 = char
	;-> a0 = pointer to characters after the option (or NULL, flags)
	;***
CheckOption:
		move.l	(CmdLine,pc),d1	;CmdLine will be 0 if we started from Workbench
		beq.b		2$
		movea.l	d1,a0
1$		move.b	(a0)+,d1
		beq.b		2$
		cmp.b		#'-',d1
		bne.b		1$

		move.b	(a0)+,d1
		beq.b		2$
		cmp.b		d0,d1
		bne.b		1$

	;Found!
		move.l	a0,d0
		rts

2$		moveq		#0,d0
		movea.l	d0,a0
		rts

	;***
	;Convert alias commands to cmdline.
	;This function also makes a copy of the cmdline so that we can
	;safely change it to anything we want.
	;a0 = cmdline typed in by user
	;-> a0 new cmdline (or 0, flags if error)
	;***
AliasToCmd:
		movem.l	a1-a5/d0-d4,-(a7)
		movea.l	a0,a4
		bsr		FindAlias
		bne.b		6$

	;It is not an alias, but we must first make a copy before we quit
		movea.l	a4,a0
		bsr		AllocStringInt
		beq		ErrorATC

		movea.l	d0,a4
		bra		1$

	;We have found it, d0 = pointer to alias structure
	;Reserve space for commandline
6$		movea.l	d0,a1					;Store alias structure
		movea.l	a4,a0					;Pointer to old commandline
		bsr		SkipNSpace
		exg		a0,a1					;a1 = ptr after cmdline, a0 = alias structure
		movem.l	a0-a1,-(a7)
		moveq		#0,d0
		move.w	(DefLineLen),d0
		addq.w	#2,d0
		bsr		AllocBlockInt
		bne.b		9$

	;Error
11$	movem.l	(a7)+,a0-a1
		bra		ErrorATC

9$		movea.l	d0,a4					;Pointer to new cmdline
		move.w	(DefLineLen),d0
		move.b	#-1,(0,a4,d0.w)	;Sentinel to detect buffer overflow
		movem.l	(a7)+,a0-a1			;a1 = ptr after cmdline, a0 = alias structure
		move.l	a0,-(a7)
		movea.l	a1,a0
		bsr		AllocStringInt		;Store arguments somewhere else
		bne.b		12$

	;Error
		movea.l	(a7)+,a0
		bra		ErrorATC

12$	movea.l	d0,a2					;Pointer to arguments
		movea.l	(a7)+,a0				;Restore alias structure
		movea.l	a4,a1					;Get ptr to new cmdline
		movea.l	(12,a0),a0			;Ptr to new cmdline
	;a0 = ptr to alias cmdline, a1 = ptr to new cmdline, a2 = ptr to arguments
	;Copy from new cmdline
2$		cmpi.b	#'[',(a0)
		bne.b		4$
		cmpi.b	#']',(1,a0)			;Check if the complete cmdline should be copied
		beq.b		5$
		cmpi.b	#']',(2,a0)			;Only part of the cmdline should be copied ?
		beq.b		8$

4$		cmpi.b	#-1,(a1)				;Test if we don't overflow the buffer
		beq.b		7$
		move.b	(a0)+,(a1)+
		bne.b		2$
	;End of cmdline
		movea.l	a2,a0
		bsr		FreeBlock			;Free arguments
1$		movea.l	a4,a0
		move.l	a0,d0					;For flags
		movem.l	(a7)+,a1-a5/d0-d4
		rts

	;Copy arguments
5$		movea.l	a2,a3
		tst.b		(a3)
		beq.b		3$
		lea		(1,a3),a3			;Skip first space for argument
3$		cmpi.b	#-1,(a1)
		beq.b		7$
		move.b	(a3)+,(a1)+
		bne.b		3$
		lea		(2,a0),a0			;Skip []
		lea		(-1,a1),a1
	;Continue copying new cmdline
		bra.b		2$
	;Error overflow
7$		movea.l	a2,a0
		bsr		FreeBlock			;Free arguments
		SERR		AliasOverflow		;Fall through

	;Copy one argument only (if digit in between)
8$		move.b	(1,a0),d0
		cmpi.b	#'1',d0
		blt.b		4$
		cmpi.b	#'9',d0
		bgt.b		4$
		movem.l	a0-a1/d2,-(a7)		;Remember
		move.b	(1,a0),d2			;Get argument number
		subi.b	#'1',d2				;1 = first argument
		movea.l	a2,a0
13$	bsr		SkipSpace
		tst.b		d2
		beq.b		14$
		moveq		#0,d0
		bsr		SkipObject
		subq.b	#1,d2
		bra.b		13$

	;Copy argument
14$	movea.l	a0,a3					;Pointer to this argument
		moveq		#0,d0
		bsr		SkipObject
		move.l	a0,d1					;Pointer after this argument
		movem.l	(a7)+,a0-a1/d2

15$	cmpi.b	#-1,(a1)
		beq.b		7$
		move.b	(a3)+,(a1)+
		cmp.l		a3,d1
		bge.b		15$
		lea		(3,a0),a0			;Skip [x]
		lea		(-1,a1),a1
	;Continue copying new cmdline
		bra		2$

	;Handle error
ErrorATC:
		suba.l	a0,a0
		move.l	a0,d0					;For flags
		movem.l	(a7)+,a1-a5/d0-d4
		rts


	;User callable routines

	;***
	;PowerVisor internal call routine
	;0  = Create a new PowerVisor function
	;1  = Generate an error
	;2  = Advance history buffer
	;3  = Lower history buffer
	;4  = Get current history line and copy to 'Line'
	;5  = Refresh the stringgadget
	;6  = Install a command on the 'ExecCmdLine' function
	;7  = Evaluate
	;8  = Remove variable, constant or function
	;9  = GetString
	;10 = Copy line to 'Line'
	;11 = Add line to history buffer
	;12 = Get address of 'Line'
	;13 = Append string to 'Line'
	;14 = Skip spaces from string
	;15 = Set cursor position in stringgadget
	;16 = Install a command after the 'ExecCmdLine' function
	;17 = Set debug mode for PowerVisor
	;18 = Get execution level
	;19 = Get pointer to global (NEW)
	;20 = Get mStringInfo
	;21 = Get Snap Buffer
	;22 = Install command before 'snap'
	;23 = Get current logical window (NEW)
	;24 = Beep
	;25 = Get address of variable or function
	;26 = Get the pointer to the array of share variables (NEW)
	;27 = Create constant
	;28 = Compare two strings
	;29 = Call machinelanguage script
	;30 = OBSOLETE
	;31 = OBSOLETE
	;32 = OBSOLETE
	;33 = OBSOLETE
	;34 = OBSOLETE
	;35 = OBSOLETE
	;36 = OBSOLETE
	;37 = Routines
	;38 = ModeRoutines
	;39 = RexxList
	;40 = OBSOLETE
	;41 = OBSOLETE
	;42 = Get pointer to last history line in buffer (NEW)
	;43 = Get pointer to stringgadget
	;44 = Get pointer to history buffer (NEW)
	;45 = Get number of lines in history (NEW)
	;46 = ErrorHandler (only usable from machinelanguage, a5 = routine)
	;47 = Install quit routine
	;48 = Alias to command
	;49 = AddAutoClear
	;50 = AllocBlockInt
	;51 = FreeBlock
	;52 = WindowGadgetPort
	;53 = Print
	;54 = PrintHex
	;55 = AddPointerAlloc
	;56 = RemPointerAlloc
	;57 = FClose
	;58 = ReAllocMem
	;59 = ReAllocMem OBSOLETE
	;60 = Get pointer to aliases (NEW)
	;61 = Refresh a logical window
	;62 = Get a word from a logical window
	;63 = Disassemble memory in string
	;64 = Disassemble memory in string (cmdline version)
	;65 = Special put character OBSOLETE
	;66 = AllocMem
	;67 = FreeMem
	;68 = ReAlloc
	;69 = Are we in hold? (NEW)
	;70 = Pointer to current history line we are scanning (NEW)
	;71 = Are we in synch? (NEW)
	;72 = Are we hidden (ARexx)? (NEW)
	;73 = Get pointer to start of variable storage (NEW)
	;***
RoutPVCall:
		EVALE
		lea		(PVCallTable,pc),a1
		lsl.l		#2,d0
		movea.l	(0,a1,d0.l),a1
		jmp		(a1)

PVCallTable:
		dc.l		RoutCreateFunc			;0
		dc.l		GenerateError
		dc.l		UpHistory
		dc.l		DownHistory
		dc.l		PVHistToLine
		dc.l		RefreshGadget
		dc.l		PVInstallEnter
		dc.l		Evaluate
		dc.l		RemVarFunc
		dc.l		GetString
		dc.l		PVCopyToLine			;10
		dc.l		PVAddLineToHist
		dc.l		PVGetLineAddr
		dc.l		PVAppendToLine
		dc.l		PVSkipSpaces
		dc.l		PVSetCursorInGadget
		dc.l		PVInstallAfter
		dc.l		PVSetDebug
		dc.l		PVGetExecLevel
		dc.l		PVGetGlobal
		dc.l		PVGetStrInfo			;20
		dc.l		PVGetSnapBuf
		dc.l		PVInstallSnap
		dc.l		PVGetCurrentLW
		dc.l		PVBeep
		dc.l		PVGetAddress
		dc.l		PVGetStdWinInfo
		dc.l		PVCreateConstant
		dc.l		PVCompareStrings
		dc.l		PVCallMLScript
		dc.l		0							;30
		dc.l		0
		dc.l		0
		dc.l		0
		dc.l		0
		dc.l		0
		dc.l		0
		dc.l		PVGetRoutines
		dc.l		PVGetModeRoutines
		dc.l		PVGetRexxList
		dc.l		0							;40
		dc.l		0
		dc.l		PVGetLastHistory
		dc.l		PVGetStringGad
		dc.l		PVGetHistoryBuf
		dc.l		PVGetHistoryLines
		dc.l		ErrorHandler
		dc.l		PVInstallQuit
		dc.l		PVAliasToCmd
		dc.l		AddAutoClear
		dc.l		AllocBlockInt			;50
		dc.l		FreeBlock
		dc.l		WindowGadgetPort
		dc.l		PrintAC
		dc.l		PrintHex
		dc.l		AddPointerAlloc
		dc.l		RemPointerAlloc
		dc.l		FClose
		dc.l		ReAllocMem
		dc.l		ReAllocMem	;OBSOLETE
		dc.l		PVGetAliases			;60
		dc.l		LogWin_Refresh
		dc.l		LogWin_GetWord
		dc.l		DisasmSmart
		dc.l		PVDisasmSmart
		dc.l		PVPutChar
		dc.l		AllocMem
		dc.l		FreeMem
		dc.l		ReAlloc
		dc.l		PVInHold
		dc.l		PVGetHistoryScan		;70
		dc.l		PVInSync
		dc.l		PVHidden
		dc.l		PVStartVarStorage
		dc.l		PVSetHistoryScan

	;***
	;Get values
	;***
PVGetRoutines:
		lea		(RealCommands,pc),a0
		move.l	a0,d0
		rts
PVGetModeRoutines:
		lea		(ModeRoutines,pc),a0
		move.l	a0,d0
		rts
PVGetRexxList:
		lea		(RexxCommandList,pc),a0
		move.l	a0,d0
		rts
PVGetGlobal:
		move.l	(myGlobal),d0
		rts
PVGetCurrentLW:
		move.l	(CurrentLW),d0
		rts
PVGetStdWinInfo:
		lea		(ExtraShare),a0
		move.l	a0,d0
		rts
PVGetLastHistory:
		move.l	(LastHistory,pc),d0
		rts
PVGetHistoryBuf:
		move.l	(History,pc),d0
		rts
PVGetHistoryLines:
		move.l	(HistoryLines,pc),d0
		rts
PVGetAliases:
		move.l	(AliasRoutines,pc),d0
		rts
PVInHold:
		moveq		#0,d0
		move.b	(InHold,pc),d0
		rts
PVGetHistoryScan:
		move.l	(ScanHistory,pc),d0
		rts
PVSetHistoryScan:
		move.l	d0,(ScanHistory)
		rts
PVInSync:
		move.w	(InSync),d0
		ext.l		d0
		rts
PVHidden:
		move.w	(Hide),d0
		ext.l		d0
		rts
PVStartVarStorage:
		move.l	(VarStorage),d0
		rts

PVSetDebug:
		bsr		Evaluate
		move.b	d0,(PVDebugMode)
		rts

	;***
	;Special put character
	;***
PVPutChar:
		bsr		Evaluate
		movea.l	(CurrentLW),a0
		bra		LogWin_PrintChar

	;***
	;Alias to command
	;***
PVAliasToCmd:
		bsr		GetString			;Failure ?
		movea.l	d0,a0
		bsr		AliasToCmd
		move.l	a0,d0
		rts

	;***
	;Call machinelanguage script
	;***
PVCallMLScript:
		movem.l	d2-d7/a0-a5,-(a7)
		bsr		Evaluate
		movea.l	d0,a6
		suba.l	a5,a5
		bsr		RoutGo2
		movem.l	d2-d7/a0-a5,-(a7)
		rts

	;***
	;Disassemble
	;***
PVDisasmSmart:
		movem.l	a2/d2,-(a7)
		bsr		Evaluate				;Pointer to string
		movea.l	d0,a2
		bsr		Evaluate				;Address
		move.l	d0,d2
		bsr		Evaluate
		movea.l	d0,a6					;A6 value
		move.l	d2,d0
		movea.l	a2,a0
		suba.l	a4,a4					;No stackframe
		bsr		DisasmSmart
		movem.l	(a7)+,a2/d2
		rts

	;***
	;Compare two strings
	;***
PVCompareStrings:
		movem.l	a2-a3,-(a7)
		bsr		Evaluate
		movea.l	d0,a2
		bsr		Evaluate
		movea.l	d0,a3
		bsr		Evaluate
		movea.l	a2,a0
		movea.l	a3,a1
		bsr		CompareCI
		movem.l	(a7)+,a2-a3
		rts

	;***
	;Create a constant
	;***
PVCreateConstant:
		move.l	a2,-(a7)
		bsr		GetString
		movea.l	d0,a2
		bsr		Evaluate
		movea.l	a2,a0
		bsr		CreateConst
		movea.l	(a7)+,a2
		rts

	;***
	;Get address of variable
	;***
PVGetAddress:
		bsr		GetString
		bra		AddressVar

	;***
	;Play sound
	;***
PVBeep:
		move.l	d2,-(a7)
		bsr		Evaluate
		move.l	d0,d2
		bsr		Evaluate
		move.l	d0,d1
		move.l	d2,d0
		bsr		PlaySound
		move.l	(a7)+,d2
		rts

	;***
	;Get ptr to string info
	;***
PVGetStrInfo:
		move.l	#mStringInfo,d0
		rts

	;***
	;Get ptr to gadget
	;***
PVGetStringGad:
		move.l	#mStringGad,d0
		rts

	;***
	;Get ptr to snap buffer
	;***
PVGetSnapBuf:
		move.l	(SnapBuffer),d0
		rts

	;***
	;Get execution level
	;***
PVGetExecLevel:
		moveq		#0,d0
		move.w	(ExecLevel,pc),d0
		rts

	;***
	;Set cursor position in stringgadget
	;***
PVSetCursorInGadget:
		bsr		Evaluate
		move.w	d0,(GadCursorPos)
		bra		SetCursor

	;***
	;Return pointer to first non-space char in string pointer
	;***
PVSkipSpaces:
		bsr		Evaluate
		movea.l	d0,a0
		bsr		SkipSpace
		move.l	a0,d0
		rts

	;***
	;Get address of 'Line'
	;***
PVGetLineAddr:
		move.l	(Line),d0
		rts

	;***
	;Add line to history buffer
	;***
PVAddLineToHist:
		bsr		GetString
		movea.l	d0,a0
		bra		AddHistory

	;***
	;Copy history to stringgadget
	;***
PVHistToLine:
		bsr		GetHistoryLine
		move.b	#1,(DontClearLine)
		rts

	;***
	;Copy argument to stringgadget
	;***
PVCopyToLine:
		bsr		GetString
		movea.l	d0,a0
		movea.l	(Line),a1
		move.w	(DefLineLen),d0
		subq.w	#2,d0
1$		move.b	(a0)+,(a1)+
		dbeq		d0,1$
		move.b	#1,(DontClearLine)
		rts

	;***
	;Append argument to stringgadget
	;***
PVAppendToLine:
		bsr		GetString
		movea.l	d0,a0
		movea.l	(Line),a1
	;Go to end of 'Line'
2$		move.b	(a1)+,d0
		beq.b		3$
		addq.b	#1,d0
		beq.b		4$
		bra.b		2$
	;Copy rest
3$		subq.l	#1,a1
1$		cmpi.b	#-1,(a1)
		beq.b		5$
		move.b	(a0)+,(a1)+
		bne.b		1$
	;The end
4$		move.b	#1,(DontClearLine)
		rts

	;Set previous char to 0
5$		clr.b		(-1,a1)
		bra.b		4$

	;***
	;Install commands
	;***
PVInstallQuit:
		lea		(QuitCommand,pc),a2
		bra.b		PVInstallGenCmd

PVInstallEnter:
		lea		(EnterCommand,pc),a2
		bra.b		PVInstallGenCmd

PVInstallAfter:
		lea		(AfterCommand,pc),a2
		bra.b		PVInstallGenCmd

PVInstallSnap:
		lea		(SnapCommand),a2

	;***
	;Install generic command
	;a2 = ptr to variable for command
	;***
PVInstallGenCmd:
		move.l	(a2),d0
		beq.b		1$
		move.l	a0,-(a7)
		movea.l	d0,a0
		bsr		FreeBlock
		movea.l	(a7)+,a0
		clr.l		(a2)
	;Install new
1$		NEXTTYPE
		beq.b		2$
		bsr		GetStringPer		;Get string
		HERReq
		move.l	d0,(a2)
2$		rts

	;***
	;Command: while command do
	;***
RoutWhile:
		bsr		GetRestLinePer
		HERReq
		move.l	d0,-(a7)

	;Establish an error routine to restore the current debug later on
2$		bsr		CheckBreak
		movea.l	(a7),a0
		moveq		#EXEC_WHILE,d0
		bsr		ExecAlias
		move.l	d1,d3					;Error result
		beq.b		1$
		move.l	d0,d2					;Save result
		bne.b		2$

	;Clean up
1$		movea.l	(a7)+,a0				;Get command line
		bsr		FreeBlock

	;Quit
		tst.l		d3
		HERReq
		rts

	;***
	;Command: save config file
	;***
RoutSaveConfig:
		bsr		UpdatePrefs
		bsr		ScanStanLogWin		;Update the sizes of all logical windows

		lea		(pvConfigFile,pc),a0
		move.l	a0,d1
		moveq		#MODE_NEWFILE-1000,d2
		bsr		OpenDos
		ERROReq	OpenFile
		move.l	d0,d5

		movea.l	(Storage,pc),a0
		move.l	#EYE_START,(a0)		;Storage has the correct alignment for 68000
		move.w	#1,(4,a0)				;Version number 1
		moveq		#6,d3
		bsr.b		SVCFWriteIt

	;First long: eye
	;Second word: the expected size of the entry
	;Third word: if 0 the last long is an address of a memory region
	;				 if 1 the last long is an address of a routine to call
	;						routine returns address in a0
	;						routine should preserve d1 and d3
	;Fourth long: the address
		lea		(ConfigAddresses,pc),a2
1$		move.l	(a2)+,d0
		beq.b		2$							;The end

	;Write header (eye + size)
		movea.l	(Storage,pc),a0
		move.l	d0,(a0)					;Eye
		move.w	(a2)+,d4					;Remember expected size
		move.w	d4,(4,a0)				;Write expected size
		moveq		#6,d3
		bsr.b		SVCFWriteIt

	;Write entry
		move.w	d4,d3
		ext.l		d3
		move.w	(a2)+,d0					;If 1 the address is a routine
		movea.l	(a2)+,a0					;This doesn't change the flags
		beq.b		3$
	;A routine
		jsr		(a0)						;Routine should return with correct address in a0
3$		bsr.b		SVCFWriteIt
		bra.b		1$

	;Close the file
2$		move.l	d5,d1
		CALL		Close
		rts

	;---
	;Write entry
	;a0 = pointer to entry
	;d5 = file
	;d3 = size of entry
	;---
SVCFWriteIt:
		move.l	d5,d1
		move.l	a0,d2
		CALL		Write
		rts

	;***
	;Read the config file
	;***
ReadConfigFile:
		lea		(pvConfigFile,pc),a0
		move.l	a0,d1
		bsr		FOpen
		beq		1$
		move.l	(Storage,pc),d2
		moveq		#4,d3
		bsr		FRead
		movea.l	(Storage,pc),a0
		move.l	(a0),d0
		cmp.l		#EYE_START,d0			;Storage has the correct alignment for 68000
		beq		2$

	;Read the older PowerVisor format
	;Format:
	;	LONG	Mode variable
	;	LONG	MainEntry[2]
	;	LONG	ExtraEntry[2]
	;	LONG	RefreshEntry[2]
	;	LONG	DebugEntry[2]
	;	LONG	PPrintEntry[2]
	;	LONG	RexxEntry[2]
	;	LONG	SourceEntry[2]
	;	WORD	DefLineLen
	;	LONG	KeyCodesQuals[6]
	;	BYTE	ExtraShare[18*6]
	;	LONG	SpecialFlags
	;	WORD	StartupCoords[4]
	;	WORD	ScreenSize[2]
	;	BYTE	FancyPens[24]
	;	BYTE	NoFancyPens[24]
	;	LONG	StackFailL
	;	BYTE	DebugPrefs[6]
	;	LONG	HistoryMax
	;	BYTE	TopazName[34]
	;	LONG	TextAttrib

		moveq		#0,d2
		moveq		#OFFSET_BEGINNING,d3
		bsr		FSeek						;Go back to start

		movea.l	(VarStorage),a0
		lea		(VOFFS_MODE,a0),a0
		move.l	a0,d2
		moveq		#4,d3
		bsr		FRead
		move.l	#MainEntry,d2
		moveq		#7*8,d3
		bsr		FRead
		move.l	#DefLineLen,d2
		moveq		#2,d3
		bsr		FRead
		lea		(BreakKey,pc),a0
		move.l	a0,d2
		moveq		#6*4,d3
		bsr		FRead
		move.l	#ExtraShare,d2
		move.l	#18*6,d3
		bsr		FRead
		move.l	#SpecialFlags,d2
		move.l	#4+2*4+2*2+24+24,d3
		bsr		FRead
		move.l	#StackFailL,d2
		moveq		#4,d3
		bsr		FRead
		move.l	#DebugRegsInfo,d2
		moveq		#6,d3
		bsr		FRead
		move.l	#HistoryMax,d2
		moveq		#4,d3
		bsr		FRead
		move.l	#TopazName,d2
		moveq		#34,d3
		bsr		FRead
		move.l	#TextAttrib+4,d2
		moveq		#4,d3
		bsr		FRead
		bra		FClose
1$		rts

	;Read the newer format
	;Format:
	;	LONG	eye						: 'PVcf'
	;	WORD	version					: version number
	;	<entries>
	;
	;<entry>:
	;	LONG	eye						: one of EYE_xxx
	;	WORD	size						: size of following data
	;
	;There are entries for:
	;	mode (4 bytes)									: EYE_MODE
	;	entries (Main, ...) (7*(4+4) bytes)		: EYE_ENTRIES
	;	default line length (2 bytes)				: EYE_DEFLEN
	;	key codes and qualifiers (6*4 bytes)	: EYE_KEYS
	;	share structures (18*6 bytes)				: EYE_SHARES
	;	special flags (4 bytes)						: EYE_SCRFLAGS
	;	startup coordinates (4*2 bytes)			: EYE_COORDS
	;	screen size (2*2 bytes)						: EYE_SCRSIZE
	;	fancy pens (24 bytes)						: EYE_FANPENS
	;	no fancy pens (24 bytes)					: EYE_PENS
	;	stack fail level (4 bytes)					: EYE_STACKFAIL
	;	debug preferences (6 bytes)				: EYE_DEBUGPREF
	;	max history (4 bytes)						: EYE_HISTMAX
	;	font name (34 bytes)							: EYE_FONT
	;	text attribute (4 bytes)					: EYE_TATTRIB

2$		move.l	(Storage,pc),d2
		moveq		#2,d3
		bsr		FRead						;Read version number
		moveq		#0,d4						;Clear d4

3$		move.l	(Storage,pc),d2
		moveq		#6,d3
		bsr		FRead						;Read eye and size
		tst.l		d0
		beq.b		7$							;The end
		movea.l	(Storage,pc),a0
		move.l	(a0),d0					;Get eye
		moveq		#0,d3
		move.w	(4,a0),d3				;Get size
		lea		(ConfigAddresses,pc),a0
4$		move.l	(a0)+,d2
		beq.b		6$							;Unknown header, just ignore it!
		cmp.l		d2,d0
		beq.b		5$
		lea		(8,a0),a0
		bra.b		4$

	;Found entry!
5$		move.w	(a0)+,d4					;The expected size of the structure
		move.w	(a0)+,d2					;If 1 the address is a routine
		movea.l	(a0),a0					;This doesn't change the flags
		beq.b		8$
	;A routine
		jsr		(a0)						;Routine should return with correct address in a0
8$		move.l	a0,d2
		cmp.w		d3,d4
		bge.b		9$
	;Expected size is smaller than size in config
		exg		d3,d4
		sub.w		d3,d4						;d4 contains difference in size
		bsr		FRead						;Read entry
		move.l	d4,d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek						;Skip unrecognized bytes
		bra.b		3$

9$		bsr		FRead						;Read entry (d3:size is already correct)
		bra.b		3$

	;Unknown header (show a warning to the user)
6$		lea		(UnknownEntryInConfigMes,pc),a0
		movem.l	d1/d3,-(a7)
		bsr		PrintCLI
		movem.l	(a7)+,d1/d2
		moveq		#OFFSET_CURRENT,d3
		bsr		FSeek
		bra.b		3$

	;End of file
7$		bra		FClose

	;---
	;Get mode
	;---
CfgGetMode:
		movea.l	(VarStorage),a0
		lea		(VOFFS_MODE,a0),a0
		rts

	;---
	;All addresses for config entries
	;First long: eye
	;Second word: the expected size of the entry
	;Third word: if 0 the last long is an address of a memory region
	;				 if 1 the last long is an address of a routine to call
	;						routine returns address in a0
	;						routine should preserve d1 and d3
	;Fourth long: the address
	;---
ConfigAddresses:
		EYEENTRY	MODE,ROUT,4,CfgGetMode
		EYEENTRY	ENTRIES,ADDRESS,8*8,MainEntry
		EYEENTRY	DEFLEN,ADDRESS,2,DefLineLen
		EYEENTRY	KEYS,ADDRESS,6*4,BreakKey
		EYEENTRY	SHARES,ADDRESS,7*18,ExtraShare
		EYEENTRY	SCRFLAGS,ADDRESS,4,SpecialFlags
		EYEENTRY	COORDS,ADDRESS,4*2,StartupX
		EYEENTRY	SCRSIZE,ADDRESS,2*2,ScreenW
		EYEENTRY	FANPENS,ADDRESS,24,FancyPens
		EYEENTRY	PENS,ADDRESS,24,NoFancyPens
		EYEENTRY	STACKFAIL,ADDRESS,4,StackFailL
		EYEENTRY	DEBUGPREF,ADDRESS,6,DebugRegsInfo
		EYEENTRY	HISTMAX,ADDRESS,4,HistoryMax
		EYEENTRY	FONT,ADDRESS,34,TopazName
		EYEENTRY	TATTRIB,ADDRESS,4,TextAttrib+4
		dc.l	0

	;***
	;Command: add an alias to the alias list
	;***
RoutAlias:
		tst.l		d0						;End of line
		bne.b		1$
	;Show all aliasses
		movea.l	(AliasRoutines,pc),a5
2$		move.l	a5,d0
		beq.b		3$

		lea		(FormatAlias,pc),a0
		movea.l	a5,a1
		bsr		PrintFor
		PFLONG	12
		PFLONG	8
		PFEND

		movea.l	(a5),a5				;Next alias line
		bra.b		2$
3$		rts

	;Make a new alias
1$		bsr		GetStringPer		;Get ptr alias string
		HERReq
		move.l	d0,d2

	;Check if the alias already exists
		move.l	a0,-(a7)
		movea.l	d2,a0
		bsr		FindAlias
		beq.b		7$
		movea.l	d0,a0
		bsr		RemoveAlias
7$		movea.l	(a7)+,a0

		bsr		GetStringPer		;Get ptr alias line
		bne.b		4$

	;Error
		movea.l	d2,a0
		bsr		FreeBlock
		HERR

4$		move.l	d0,d3
		moveq		#16,d0
		bsr		AllocClear
		bne.b		5$

	;Error
		movea.l	d2,a0
		bsr		FreeBlock
		movea.l	d3,a0
		bsr		FreeBlock
		HERR

5$		movea.l	d0,a0
	;Init alias structure
		move.l	d2,(8,a0)
		move.l	d3,(12,a0)
		move.l	(AliasRoutines,pc),(a0)
		clr.l		(4,a0)
		tst.l		(a0)
		beq.b		6$
	;There is another alias string
		movea.l	(a0),a1
		move.l	a0,(4,a1)

6$		lea		(AliasRoutines,pc),a1
		move.l	a0,(a1)
		rts

	;***
	;Command: remove an alias from the alias list
	;***
RoutUnAlias:
		bsr		GetStringE			;Get alias string
		movea.l	d0,a0
		bsr		FindAlias
		beq.b		1$
		movea.l	d0,a0
		bsr		RemoveAlias
1$		rts

	;***
	;Remove an alias
	;a0 = pointer to alias structure
	;***
RemoveAlias:
		movea.l	a0,a2
		movea.l	(8,a2),a0
		bsr		FreeBlock
		movea.l	(12,a2),a0
		bsr		FreeBlock
		move.l	(a2),d0
		beq.b		1$

	;There is a following alias structure
		movea.l	d0,a1
		move.l	(4,a2),(4,a1)		;self->Next->Prev = self->Prev

1$		move.l	(4,a2),d0
		beq.b		2$

	;There is a previous alias structure
		movea.l	d0,a1
		move.l	(a2),(a1)			;self->Prev->Next = self->Next
		bra.b		3$

	;There is no previous alias structure, change 'AliasRoutines'
2$		lea		(AliasRoutines,pc),a0
		move.l	(a2),(a0)

3$		movea.l	a2,a1
		moveq		#16,d0
		bra		FreeMem

	;***
	;Find an alias
	;a0 = command string to find
	;-> d0 = alias structure or 0, flags if not found
	;***
FindAlias:
		lea		(AliasRoutines,pc),a1
		lea		(GetNextListOL,pc),a5
		bsr		SearchWordEx
		move.l	a0,d0					;d0 = ptr to alias structure
		tst.l		d1
		rts

	;***
	;GetNext routine for alias lists
	;List format: <Next>,<Previous>,<Command string>,<Alias string>
	;***
GetNextListOL:
		movea.l	(a1),a1
		move.l	a1,d0
		beq.b		1$
		movea.l	(8,a1),a3
		move.l	a1,d6
1$		rts

	;***
	;Command: quit
	;***
RoutQuit:
 IFD D20
		bsr		TestForClose
		ERROReq	PleaseCloseVisitors
 ENDC

		movea.l	(DebugList),a3
		tst.l		(a3)
		beq.b		1$
	;There are debug tasks, ask if the user wants to continue
		lea		(RequestQuitBody,pc),a5
		lea		(RequestQuitGadg,pc),a2
		moveq		#0,d0
		bsr		RequestIt
		tst.l		d0
		bne.b		1$
		rts

1$		move.l	(ScriptFile),d1
		beq.b		2$
	;We are in a script, simply quit script by closing scriptfile
		bra		CloseScriptFile

	;We must perform a normal quit, first test if we can quit
2$		move.w	(ExecLevel,pc),d0
		beq.b		3$
		cmpi.w	#EXEC_GROUP,d0
		beq.b		3$
		cmpi.w	#EXEC_MENU,d0
		bne.b		4$

	;test if there is a 'quit' command.
3$		move.l	(QuitCommand,pc),d0
		beq.b		ReallyQuit
		movea.l	d0,a0
		bsr		ExecAlias
		HERReq
		tst.l		d0
		bne.b		ReallyQuit

	;Ignore quit
4$		rts

	;Start quit
ReallyQuit:
		lea		(DebugList),a3
1$		movea.l	(a3),a3				;Succ
		tst.l		(a3)					;Succ
		ERROReq	Quit
		bsr		CheckIfTrace
		HERReq							;DEBUG!!!
		bra.b		1$

	;***
	;Command: hold
	;***
RoutHold:
		move.b	(InHold,pc),d0
		bne.b		7$

 IFD D20
		bsr		TestForClose
		ERROReq	PleaseCloseVisitors
 ENDC
		bsr		ClosePW
		bsr		CloseScreen

4$		lea		(InHold,pc),a0
		move.b	#1,(a0)
		moveq		#0,d0
		move.l	(HoldSigSet,pc),d1
		CALLEXEC	SetSignal
		move.l	(HoldSigSet,pc),d0
		or.l		(CrashSigBit),d0
		or.l		(RexxBit),d0
		CALL		Wait
		move.l	d0,d7

		and.l		(CrashSigBit),d0
		beq.b		1$
	;There was a crash
		bsr		ReOpenScreen
		beq.b		4$
		bra		CrashSignal

1$		move.l	d7,d0
		and.l		(HoldSigSet,pc),d0
		beq.b		2$
	;Unhold
		bsr		ReOpenScreen
		beq.b		4$
7$		rts

2$		move.l	d7,d0
		and.l		(RexxBit),d0
		beq.b		4$
	;ARexx
		bsr		CheckRexx
		move.b	(InHold,pc),d0
		bne.b		4$						;Still in hold, do nothing
		bsr		ReOpenScreen
		beq.b		4$

		rts

	;***
	;Command: get an error message
	;***
RoutError:
		bsr		Evaluate
		bsr		GetError
		move.l	a0,d0
		rts

	;***
	;Command: simulate an error
	;a0 = cmdline
	;***
GenerateError:
		EVALE
		trap		#0

	;***
	;Function: get an error for an expression
	;***
FuncGetError:
		moveq		#0,d0
		bsr		SetError
		lea		(LastError,pc),a1
		move.w	d0,(a1)
		bsr		GetStringE
		movea.l	d0,a0
		bsr		Evaluate
		moveq		#0,d0
		move.w	(LastError,pc),d0
		rts

	;***
	;Error handler
	;a5 = ptr to routine to execute
	;all other registers are preserved for routine
	;-> d1 = 0 (flags) if error
	;-> d0 = returnvalue
	;***
ErrorHandler:
		move.l	(StackPointer),-(a7)
		move.l	(ProgramCounter),-(a7)
		pea		(2$,pc)
		bsr		RememberItAndJmp

	;If we come here there was an error
		moveq		#0,d1					;Error
		bra.b		1$

	;Try to execute it
2$		jsr		(a5)
	;We come here if no error
		moveq		#1,d1					;No error

	;Common routine
1$		move.l	(a7)+,(ProgramCounter)
		move.l	(a7)+,(StackPointer)
		tst.l		d1
		rts

	;***
	;Command: toggle the powerled
	;***
RoutLed:
		bchg.b	#1,($bfe001)
		rts

	;***
	;Command: evaluate arguments
	;a0 = cmdline
	;***
RoutVoid:
		tst.l		d0						;End of line
		beq.b		1$
		EVALE
		move.l	d0,d7
		NEXTTYPE
		bra.b		RoutVoid
1$		move.l	d7,d0
		rts

	;***
	;Command: attach a command to a key
	;a0 = cmdline
	;***
RoutAttach:
		bsr		GetStringE			;Get command string
		addq.w	#1,d1					;Inc length
		movea.l	d0,a5					;Remember ptr
		move.l	d1,d7					;Remember length
		EVALE								;Get keycode
		move.l	d0,d6
		EVALE								;Get keyqualifier
		move.l	d0,d5
		moveq		#0,d4					;Assume normal attachement (not invisible)
		NEXTTYPE
		beq.b		3$
		bsr		SkipSpace
		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'E',d0
		beq.b		4$
		cmpi.b	#'A',d0
		beq.b		6$
		cmpi.b	#'C',d0
		bne.b		3$

	;It is a snap attachement
		moveq		#KAF_SNAP,d4
		bra.b		5$

	;It is an invisible 'always' attachement
6$		moveq		#KAF_ALWAYS,d4
		bra.b		5$

	;It is an invisible attachement
4$		moveq		#KAF_INVISIBLE,d4

	;Check if we must hold the key
5$		bsr		SkipSpace
		move.b	(a0)+,d0
		cmpi.b	#'+',d0
		bne.b		3$
		ori.w		#KAF_HOLDKEY,d4

	;It is a normal attachement
3$		moveq		#ka_SIZE,d0
		suba.l	a0,a0
		bsr		MakeNodeInt
		HERReq
		movea.l	a0,a4					;Remember ptr to node
		move.l	d7,d0
		bsr		AllocClear
		bne.b		1$
		moveq		#ka_SIZE,d0
		movea.l	a4,a1
		bsr		FreeMem				;Free node
		HERR
1$		clr.l		(LN_NAME,a4)
		move.b	#NT_KEYATT,(LN_TYPE,a4)
		andi.w	#255,d6
		move.w	d6,(ka_Code,a4)
		move.w	d5,(ka_Qualifier,a4)
		move.l	d0,(ka_CommandString,a4)
		move.w	d7,(ka_CommandLen,a4)
		move.w	d4,(ka_Flags,a4)
		movea.l	d0,a0
2$		move.b	(a5)+,(a0)+
		bne.b		2$
		move.l	d6,d0
		andi.b	#7,d0					;Get bit number
		move.l	d6,d1
		lsr.w		#3,d1					;Get byte number
		lea		(Attachings,pc),a0
		bset		d0,(0,a0,d1.w)
		lea		(KeyAttach,pc),a0	;Add our node to the list
		movea.l	a4,a1
		CALLEXEC	AddHead
		move.l	a4,d0
		bra		StoreRC

	;***
	;Command: remove a keyattachment
	;a0 = cmdline
	;***
RoutRemAttach:
		moveq		#I_ATTACH,d6
		bsr		SetList
		EVALE								;Get ptr to KeyAttach node
		movea.l	d0,a0
		cmpi.b	#NT_KEYATT,(LN_TYPE,a0)
		ERRORne	NodeTypeWrong
RemKeyAttachDirect:
		movea.l	d0,a1
		movea.l	d0,a2
		CALLEXEC	Remove
		movea.l	(ka_CommandString,a2),a1
		moveq		#0,d0
		move.w	(ka_CommandLen,a2),d0
		bsr		FreeMem
		movea.l	a2,a1
		moveq		#ka_SIZE,d0
		bsr		FreeMem
	;Update attach bits (fall through)

	;***
	;Test if all attach bits are correct
	;***
UpdateAttachBits:
		lea		(Attachings,pc),a0
		moveq		#7,d1					;Loop 8 times
1$		clr.l		(a0)+
		dbra		d1,1$
	;All bits are cleared, scan list and add bit for each code
		lea		(Attachings,pc),a0
		lea		(KeyAttach,pc),a1
2$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		beq.b		3$						;End
		move.w	(ka_Code,a1),d0
		andi.b	#7,d0					;Get bit number
		move.w	(ka_Code,a1),d1
		lsr.w		#3,d1					;Get byte number
		bset		d0,(0,a0,d1.w)
		bra.b		2$
	;The end
3$		rts

	;***
	;Command: control refresh rate and command
	;a0 = cmdline
	;***
RoutRefresh:
	;Free previous refreshcmd if any
		lea		(RefreshCmd,pc),a2
		move.l	(a2),d0
		beq.b		2$
		move.l	a0,-(a7)
		movea.l	d0,a0
		bsr		FreeBlock
		movea.l	(a7)+,a0
		clr.l		(a2)
	;Get refresh rate
2$		NEXTTYPE
		beq.b		1$
		EVALE								;Get the first integer
		move.w	d0,d2					;Remember refresh rate
		bsr		GetRestLinePer
		HERReq
		move.l	d0,(a2)
	;Install refresh
		lea		(CountRefresh,pc),a2
		move.w	#1,(a2)
		lea		(SpeedRefresh,pc),a2
		move.w	d2,(a2)
1$		rts

	;***
	;Function: get current refresh rate
	;***
FuncRfRate:
		moveq		#0,d0
		move.w	(SpeedRefresh,pc),d0
		rts

	;***
	;Function: get current refresh command
	;***
FuncRfCmd:
		move.l	(RefreshCmd,pc),d0
		rts

	;***
	;Preferences command
	;***
RoutPrefs:
		tst.l		d0
		ERROReq	MissingOp
		bsr		SkipSpace			;Get command string
		lea		(PrefsRoutines,pc),a1
		lea		(GetNextList,pc),a5
		bsr		SearchWord
		tst.l		d1
		ERROReq	UnknownPrefsArg
	;We are going to execute the command
		movea.l	a0,a5
		movea.l	a1,a0
		NEXTTYPE
	;Execute command
		jmp		(a5)

	;***
	;Prefs: set/get default font
	;***
PRoutFont:
		bne.b		1$

	;Get
		lea		(TextAttrib),a1
		GETFMT	l,0,w,4,b,6,b,7
		FMTSTR	s,col,d,spc,d,spc,d,nl
		bra		SpecialPrint

	;Set
1$		bsr		GetStringE			;Font name
		movea.l	d0,a2
		EVALE								;Size
		move.l	d0,d2
		EVALE								;Style
		move.l	d0,d3
		EVALE								;Flags
		move.l	d0,d4
		lea		(TextAttrib+4),a0
		move.w	d2,(a0)
		move.b	d3,(2,a0)
		move.b	d4,(3,a0)
		lea		(TopazName),a0
		moveq		#32,d0
2$		move.b	(a2)+,(a0)+
		dbeq		d0,2$
		rts

	;***
	;Prefs: set/get pens
	;***
PRoutPens:
		bne.b		1$

	;Get
		moveq		#1,d6
		lea		(FancyPens),a1
		GETFMT	b,0,b,1,b,2,b,3
		FMTSTR	d,spc,d,spc,d,spc,d,spc
3$		moveq		#5,d5					;Loop 6 times
2$		bsr		SpecialPrint
		lea		(4,a1),a1
		dbra		d5,2$
		NEWLINE
		dbra		d6,3$
		rts

	;Set
1$		EVALE								;Get index
		move.l	d0,d2
		EVALE								;Get value

		tst.l		d2
		bge.b		4$
	;Negative, not allowed
		ERROR		BadArgValue
4$		moveq		#48,d1
		cmp.l		d1,d2
		blt.b		5$
	;Too big
		ERROR		BadArgValue

	;Good
5$		lea		(FancyPens),a5
		move.b	d0,(0,a5,d2.w)		;Fill in value
		rts

	;***
	;Prefs: set/get history
	;***
PRoutHistory:
		bne.b		2$
	;Get
		move.l	(HistoryMax,pc),d0
		PRINTHEX
		rts
	;Set
2$		EVALE
		moveq		#1,d1
		cmp.l		d1,d0
		ble.b		1$
		cmpi.l	#1000,d0
		bgt.b		1$
		move.l	d0,-(a7)
		bsr		FreeHistory
		lea		(HistoryMax,pc),a0
		move.l	(a7)+,(a0)
		rts
1$		ERROR		BadHistoryValue

	;***
	;Prefs: set/get key definitions
	;***
PRoutKey:
		EVALE								;Get key number
		move.w	d0,d2
		lea		(BreakKey,pc),a2
		lsl.w		#2,d2					;*4
		lea		(0,a2,d2.w),a2		;Ptr to key definition
		NEXTTYPE
		bne.b		6$
	;Get
		movea.l	a2,a1
		GETFMT	_,0,_,0,w,0,w,2
		FMTSTR	_,_,_,_,04x,spc,04x,nl
		bra		SpecialPrint

	;Set
6$		EVALE
		move.w	d0,(a2)+
		EVALE
		move.w	d0,(a2)+
		rts

	;***
	;Prefs: set/get screen width and height
	;***
PRoutScreen:
		beq.b		1$
	;Set
		lea		(ScreenW),a2
		EVALE
		move.w	d0,(a2)+
		EVALE
		move.w	d0,(a2)+
		rts
	;Get
1$		lea		(ScreenW),a1
		GETFMT	_,0,_,0,w,0,w,2
		FMTSTR	_,_,_,_,d,spc,d,nl
		bra		SpecialPrint

	;***
	;Prefs: set/get stackfail
	;***
PRoutStack:
		bne.b		1$
	;Get
		move.l	(StackFailL),d0
		PRINTHEX
		rts
	;Set
1$		EVALE
		lea		(StackFailL),a0
		move.l	d0,(a0)
		rts

	;***
	;Prefs: set/get logwin preferences
	;***
PRoutLogWin:
		bra		RoutLWPrefs

	;***
	;Prefs: set/get default linelength
	;***
PRoutLineLen:
		beq.b		1$
	;Set
		EVALE
		move.w	d0,(DefLineLen)
		rts
	;Get
1$		moveq		#0,d0
		move.w	(DefLineLen),d0
		PRINTHEX
		rts

	;***
	;Prefs: set/get debug prefs
	;***
PRoutDebug:
		bra		RoutDPref

	;***
	;Prefs: set/get debug mode
	;***
PRoutDMode:
		bra		RoutDMode

	;***
	;Command: control various PowerVisor settings
	;a0 = cmdline
	;***
RoutMode:
		movea.l	(VarStorage),a3
		lea		(VOFFS_MODE,a3),a3
		move.l	(a3),d3				;Old mode

1$		bsr.b		Rout1Mode
		bgt.b		1$
		bne.b		2$

		move.l	d3,(a3)				;Restore old mode variable
		ERROR		UnknownModeArg

	;No errors
2$		move.l	(a3),d0				;Get new mode value
		move.l	d3,d1					;Old mode value
		bra		ModeChangeRout

	;Subroutine in RoutMode to extract one argument and consume it
	;a0 = commandline
	;a3 = pointer to mode variable
	;-> d1 = -1 if end, 0 if error, 1 otherwise (flags)
	;-> a0 = updated commandline
	;-> a3 = pointer to mode variable
Rout1Mode:
		NEXTTYPE
		bne.b		1$
		moveq		#-1,d1
		rts

1$		moveq		#-1,d4				;No negation

		bsr		SkipSpace
		move.b	(a0),d0
		bsr		Upper
		cmpi.b	#'N',d0
		bne.b		3$
		move.b	(1,a0),d0
		bsr		Upper
		cmpi.b	#'O',d0
		bne.b		3$

	;Yes, there is a 'no' in front of the argument
		lea		(2,a0),a0
		moveq		#0,d4					;Negate

3$		bsr		GetStringE
		movea.l	a0,a4

		lea		(ModeRoutines,pc),a1
		movea.l	d0,a0
		lea		(GetNextListCmd,pc),a5
		bsr		SearchWord			;-> d0 = mask, a0 = value
		tst.l		d1
		beq.b		2$

		move.l	a0,d1					;Value
		and.l		d4,d1					;For negation
		not.l		d0
		and.l		d0,(a3)
		or.l		d1,(a3)

		movea.l	a4,a0
		moveq		#1,d1					;Success
		rts

2$		movea.l	a4,a0
		moveq		#0,d1					;Error
		rts

	;***
	;Check a bit from the 'mode' variable
	;d0 = bit number
	;-> Z flag set if bit is zero
	;-> all registers are preserved
	;***
CheckModeBit:
		movem.l	a0/d1,-(a7)
		movea.l	(VarStorage),a0
		move.l	(VOFFS_MODE,a0),d1
		btst		d0,d1
		movem.l	(a7)+,a0/d1
		rts

	;***
	;Clear a bit from the 'mode' variable
	;d0 = bit number
	;-> all registers are preserved
	;***
ClearModeBit:
		movem.l	a0/d1,-(a7)
		movea.l	(VarStorage),a0
		move.l	(VOFFS_MODE,a0),d1
		bclr		d0,d1
		move.l	d0,(VOFFS_MODE,a0)
		movem.l	(a7)+,a0/d1
		rts

	;***
	;Set a new mode variable and change all PowerVisor settings if
	;needed
	;d2 = new mode
	;d3 = old mode
	;-> d0 = 0 if error (flags) (LastError is set, so use HERR)
	;***
UpdateMode:
		movea.l	(VarStorage),a0
		move.l	d2,(VOFFS_MODE,a0)

		move.l	#moF_Dirty,d0
		bsr		MaskCompare
		beq.b		1$
		bsr		CheckDirty

1$		move.l	#moF_Patch,d0
		bsr		MaskCompare
		beq.b		2$
		bsr		CheckAddTaskPatch

2$		move.l	#moF_SBottom,d0
		bsr		MaskCompare
		beq.b		3$
		bsr		UpdateSBottom

3$		move.l	#moF_Fancy|moF_Screen|moF_Lace|moF_Super,d0
		bsr		MaskCompare
		beq.b		4$
		bsr		ReOpenScreenThings
		beq.b		20$					;Error

4$		move.l	#moF_SBar,d0
		bsr		MaskCompare
	IFD D20
		beq.b		5$
		movea.l	(myGlobal),a0
		bsr		Global_CleanBoxes
	ENDC

5$		move.l	#moF_More,d0
		bsr		MaskCompare
		beq.b		6$
		bsr		SetLogWinFlags

6$		moveq		#1,d0					;Success
		rts

20$	moveq		#0,d0					;Failure
		rts

	;***
	;Check if two numbers differ in a mask
	;d0 = mask to check for difference
	;d2 = number 1
	;d3 = number 2
	;-> Z flag is set if equal
	;-> d2 = unchanged
	;-> d3 = unchanged
	;***
MaskCompare:
		move.l	d0,d1
		and.l		d2,d0
		and.l		d3,d1
		cmp.l		d0,d1
		rts

	;---
	;Reopen screen things
	;-> d0 = 0 if failure (flags)
	;---
ReOpenScreenThings:
		move.l	(PVScreen),d0
		bne.b		3$
		movem.l	d1-d7/a0-a5,-(a7)

 IFD D20
		bsr		TestForClose
		bne.b		1$
	;There are visitor windows
		SERR		PleaseCloseVisitors
		moveq		#0,d0
		bra.b		2$
 ENDC
1$		bsr		ClosePW
		bsr		CloseScreen
		bsr		ReOpenScreen

2$		movem.l	(a7)+,d1-d7/a0-a5
3$		rts

	;***
	;This routine is called if the mode variable is changed
	;d0 = new var
	;d1 = old var
	;***
ModeChangeRout:
		move.l	d0,d2
		move.l	d1,d3

		bsr		UpdateMode
		beq.b		3$
		rts

	;'UpdateMode' failed, restore everything to the old values
3$		move.l	d3,d2					;Back to old mode variable
		not.l		d3						;Force an update for everything
		bsr		UpdateMode
		HERRne

	;'UpdateMode' failed again. This time we try again with a minimal mode
	;setting
		move.l	#%0000001110000101001001,d2
		move.l	d2,d3
		not.l		d3						;Force an update for everything
		bsr		UpdateMode
		HERRne

	;If we fail again, there is nothing we can do about it. Quit PowerVisor!
		bra		EndProg

	;***
	;Command: execute a script file
	;a0 = cmdline
	;***
RoutScript:
		bsr		GetStringE
		movea.l	a0,a4
		movea.l	d0,a0
		lea		(ScriptPath,pc),a1
		bsr		SearchPath
		ERROReq	OpenFile
		move.l	d0,d7
		move.l	d0,d1
		bsr		FOpen
		bne.b		1$

	;Error, free filename
		movea.l	d7,a0
		bsr		FreeBlock
		ERROR		OpenFile

	;No error
1$		lea		(Dummy,pc),a2
		move.l	a2,d2
		moveq		#4,d3
		bsr		FRead

		cmpi.l	#$000003f3,(a2)
		bne		NotMLScript
	;The script is a machinelanguage script
		bsr		FClose

		move.l	d7,d1
		CALLDOS	LoadSeg
		movea.l	d7,a0					;Get ptr to filename
		move.l	d0,d7					;Seglist
		bsr		FreeBlock
		tst.l		d7
		ERROReq	ErrLoadSegFile
		movea.l	d7,a6
		adda.l	a6,a6
		adda.l	a6,a6					;BPTR->APTR
		lea		(4,a6),a6				;Pointer to code
		movea.l	a4,a0					;Ptr to cmdline
		movea.l	d7,a5					;Ptr to seglist

	;Interface:
	;	d2..d5 are optional arguments
	;	a1 is pointer to RC variable
	;	a2 is pointer to PVCallTable
	;
	;	a0 = rest of cmdline
	;	a6 = ptr to routine
	;	a5 = ptr to seglist to unload (if not null)
	;-> d0 = result from routine
RoutGo2:
		move.l	a5,-(a7)
		lea		(PVCallTable,pc),a2
		movea.l	(VarStorage),a1		;Ptr to varstorage
		lea		(VOFFS_RC,a1),a1	;Ptr to rc variable
		jsr		(a6)
		movea.l	d0,a4
		move.l	(a7)+,d1
		beq.b		1$
		CALLDOS	UnLoadSeg
1$		move.l	a4,d0					;Result from routine
		rts

	;d1 = filehandle
NotMLScript:
		bsr		FClose
		move.l	(ScriptFile),d0
		beq.b		2$
	;Error, we can't recursivelly execute scripts
		movea.l	d7,a0
		bsr		FreeBlock
		ERROR		CantExecScript
2$		move.l	d7,d1
		bsr		FOpen
		move.l	d0,d6
		movea.l	d7,a0
		bsr		FreeBlock
		move.l	d6,(ScriptFile)
		HERReq
		bsr		ClearBreak

		lea		(LoopRB,pc),a5
		bsr		ErrorHandler
		bne.b		1$
	;Error
		bsr		CloseScriptFile
		HERR
	;No error
1$		bra		CloseScriptFile

	;***
	;This routine is called from error handler
	;***
LoopRB:
		bsr		CheckBreak
		move.l	(ScriptFile),d1	;Quit sets ScriptFile to NULL
		beq.b		1$						;Quit
		move.l	(ScriptLine,pc),d2
		moveq		#0,d3
		move.w	(DefLineLen),d3
		subq.w	#2,d3
		bsr		FReadLine
		beq.b		1$						;EOF
		cmpi.l	#-1,d0
		HERReq
		movea.l	(ScriptLine,pc),a0
		lea		(LastCmd,pc),a1
		clr.b		(a1)
		move.l	d6,-(a7)
		moveq		#EXEC_SCRIPT,d0
		bsr		ExecAlias
		HERReq
		move.l	(a7)+,d6
		bra.b		LoopRB

	;If we come here, the script executed with no errors
1$		rts

CloseScriptFile:
		move.l	(ScriptFile),d1
		beq.b		1$
		bsr		FClose
		clr.l		(ScriptFile)
1$		rts

	;***
	;Repeat last command if 'memory', 'unasm' or 'view'
	;***
RoutDummy:
		moveq		#0,d0					;End of line
		move.b	(LastCmd,pc),d1
		beq.b		1$
		cmpi.b	#1,d1					;Memory
		beq		RoutMemory
		cmpi.b	#2,d1
		beq		RoutUnAsm
		bra		RoutView
1$		rts

	;***
	;Show owner name on screen (copyright message)
	;***
PrintName:
		lea		(OwnerName,pc),a0
		PRINT
		rts

	;***
	;GetNext routine for standard lists
	;List format: <Ptr to string>,<info>	(both long)
	;<0>,<...> to end
	;***
GetNextList:
		movea.l	(a1),a3
		move.l	(4,a1),d6
		addq.l	#8,a1
		move.l	a3,d0
		beq.b		1$
		rts
1$		movea.l	d0,a1
		rts

	;***
	;GetNext routine for ARexx command list
	;and for mode table
	;List format: <Ptr to string>,USER_FUNCTION,<Routine>
	;for mode   : <Ptr to string>,<mask>,<value>
	;0,0,0 to end
	;***
GetNextListCmd:
		movea.l	(a1),a3
		move.l	(4,a1),d7
		move.l	(8,a1),d6
		lea		(12,a1),a1
		move.l	a3,d0
		beq.b		1$
		rts
1$		movea.l	d0,a1
		rts

	;***
	;Add a line to the history buffer
	;Format for one history structure : <next>.L <prev>.L <Size>.W <string>
	;If the line is already in the buffer the line is moved to the front
	;An empty lines is not added
	;a0 = ptr to line
	;-> d0 = 0, flags if error
	;***
AddHistory:
		movem.l	a2-a3,-(a7)
		movea.l	a0,a2					;Remember pointer to the line to add
		tst.b		(a2)
		beq.b		7$						;Empty, so don't do anything

		move.l	(History,pc),d0
		beq.b		1$

	;First test if the first line in the history buffer is equal to this
	;line
		movea.l	d0,a1
		lea		(10,a1),a1			;Pointer to first string

	;Compare strings
2$		move.b	(a0)+,d0
		cmp.b		(a1)+,d0
		bne.b		3$
		tst.b		d0
		bne.b		2$

	;They are equal, so the history line must not be added to the history
	;buffer
7$		movem.l	(a7)+,a2-a3
		moveq		#1,d0					;No error
		rts

	;They are different, so we must add the new line to the history buffer
	;First test if the last line of the history must be removed
3$		move.l	(HistoryLines,pc),d0
		cmp.l		(HistoryMax,pc),d0
		blt.b		4$

	;Free last line
		movea.l	(LastHistory,pc),a1
		moveq		#0,d0
		move.w	(8,a1),d0
		movea.l	(4,a1),a3			;Pointer to previous history buffer
		bsr		FreeMem				;Free last history buffer
		lea		(HistoryLines,pc),a0
		subq.l	#1,(a0)
	;a3 is the pointer to the new last history line, we know it is not 0
	;because there are at least 2 lines in the history buffer
		clr.l		(a3)					;There is no next line for the last
		lea		(LastHistory,pc),a0
		move.l	a3,(a0)				;New last history line

	;We can now add the line to the history buffer
4$		bsr.b		8$
		move.l	(a3),d0				;Pointer to next
		beq.b		7$
		movea.l	d0,a0
		move.l	a3,(4,a0)				;Self-Next->Prev = Self
		bra.b		7$

	;Special case, the history buffer is still empty
1$		bsr.b		8$
		lea		(LastHistory,pc),a2
		move.l	a3,(a2)				;New last history line
		bra.b		7$

	;Error !
6$		movem.l	(a7)+,a2-a3
		moveq		#0,d0					;Error
		rts

	;Subroutine: Allocate a new history line
	;a2 = pointer to string
	;-> a3 = pointer to new history structure
8$		movea.l	a2,a0					;Pointer to new line
5$		tst.b		(a0)+
		bne.b		5$
		move.l	a0,d0
		sub.l		a2,d0					;d0 = length of string + 1
		addq.l	#8,d0					;Add size of two pointers
		addq.l	#2,d0					;Add size of one size field
		move.l	d0,d1					;Remember this size (AllocClear preserves d1)
		bsr		AllocClear
		beq.b		9$
		movea.l	d0,a3					;Pointer to new history structure
		move.w	d1,(8,a3)			;Fill in size
		clr.l		(4,a3)				;No previous history structure
		move.l	(History,pc),d0
		move.l	d0,(a3)				;The next history structure
		lea		(History,pc),a0
		move.l	a3,(a0)				;New first history line
		lea		(HistoryLines,pc),a0
		addq.l	#1,(a0)
		lea		(10,a3),a0			;Pointer to string place
	;Copy line to history structure
10$	move.b	(a2)+,(a0)+
		bne.b		10$
		rts

	;Error in subroutine
9$		lea		(4,a7),a7				;Skip returnaddress
		bra.b		6$

	;***
	;Get the current history line in Line
	;***
GetHistoryLine
		movea.l	(Line),a0
	;Fall through

	;***
	;Get the current history line
	;a0 = ptr to put the line in
	;***
GetHistory:
		move.l	(ScanHistory,pc),d0
		beq.b		2$
		movea.l	d0,a1
		lea		(10,a1),a1
1$		move.b	(a1)+,(a0)+
		bne.b		1$
		rts
	;We are at the start of the history buffer, so we clear the line
2$		move.b	d0,(a0)+
		rts

	;***
	;Go one line up or down
	;***
UpHistory:
		move.l	a0,-(a7)
		move.l	(ScanHistory,pc),d0
		beq.b		1$

	;Take next line
		movea.l	d0,a0
		move.l	(a0),d0
		beq.b		2$
		lea		(ScanHistory,pc),a0
		move.l	d0,(a0)
		bra.b		2$

	;Take first line
1$		lea		(ScanHistory,pc),a0
		move.l	(History,pc),(a0)
2$		movea.l	(a7)+,a0
		rts
DownHistory:
		movem.l	a0-a1,-(a7)
		move.l	(ScanHistory,pc),d0
		beq.b		1$

	;Take previous line
		movea.l	d0,a0
		lea		(ScanHistory,pc),a1
		move.l	(4,a0),(a1)

1$		movem.l	(a7)+,a0-a1
		rts
ResetHistory:
		lea		(ScanHistory,pc),a0
		clr.l		(a0)
		rts

	;***
	;The break task
	;This tasks waits for a signal from the input device
	;***
BreakTask:
		lea		(RefreshSigNum,pc),a2
		bsr		AllocSignal
		lea		(FrontSigNum,pc),a2
		bsr		AllocSignal
LoopBT:
		move.l	(FrontSigSet,pc),d0
		or.l		(RefreshSigSet,pc),d0
		CALLEXEC	Wait
		cmp.l		(FrontSigSet,pc),d0
		beq.b		PowerVisorToFrontBT
		bra.b		RefreshBT
PowerVisorToFrontBT:
		movea.l	(MainPW),a0
		bsr		PhysWin_ActivateWindow
		bsr		RoutFront
		bsr		ActivateGadget
		bra.b		InHoldBT
	;For history
RefreshBT:
		bsr		RefreshGadget
 IFND D20
		bsr		ActivateGadget
 ENDC
		bra.b		LoopBT
InHoldBT:
		movea.l	(RealThisTask),a1
		move.l	(HoldSigSet,pc),d0
		CALLEXEC	Signal
		bra.b		LoopBT

	;***
	;Command: add an event
	;***
RoutEvent:
		EVALE								;Class
		move.l	d0,d2
		EVALE								;SubClass
		move.l	d0,d3
		EVALE								;Code
		move.l	d0,d6
		EVALE								;Qualifier
		move.l	d0,d7
		EVALE								;x
		move.l	d0,d4
		EVALE								;y
		move.l	d0,d5
		move.l	d7,d1
		move.l	d6,d0
		bra		AddEvent

	;***
	;ARexx command: PowerVisor to front
	;***
RoutFront:
		lea		(InHold,pc),a0
		clr.b		(a0)

		move.l	(MyScreen),d0
		beq.b		2$
		movea.l	d0,a0
		CALLINT	ScreenToFront
		rts

	;PV is on other screen
2$		move.l	(PVScreen),d0
		beq.b		1$
		movea.l	d0,a0
		CALLINT	ScreenToFront
1$		rts

	;***
	;Clear break signal
	;***
ClearBreakSig:
		movem.l	d0-d1/a0-a1,-(a7)
	;Clear break signal
		moveq		#0,d0
		move.l	(PVBreakSigSet,pc),d1
		CALLEXEC	SetSignal
		movem.l	(a7)+,d0-d1/a0-a1
	;Fall through

	;***
	;Clear the break ptr
	;***
ClearBreak:
		move.l	a0,-(a7)
		lea		(Port),a0
		clr.w		(mp_BreakWanted,a0)
		movea.l	(a7)+,a0
		rts

	;***
	;Check if we must break
	;This function will even check for ESC if Forbid
	;***
CheckBreak:
		movem.l	d0-d1/a0-a1,-(a7)
		lea		(Port),a0
		move.w	(mp_BreakWanted,a0),d0

		bsr		ClearBreakSig
		subq.w	#1,d0
		beq.b		YesCB
		movem.l	(a7)+,d0-d1/a0-a1
		rts
YesCB:
		bsr		EnableAll
		bsr		PermitAll
		ERROR		Break

	;***
	;Check if we must pause
	;***
CheckPause:
		movem.l	d0-d1/a0-a1,-(a7)
		lea		(Port),a0
		cmpi.w	#2,(mp_BreakWanted,a0)
		beq.b		YesPauseCB
		movem.l	(a7)+,d0-d1/a0-a1
		rts
	;Pause
YesPauseCB:
		bsr		ClearBreakSig
		move.b	(ForbidNest,pc),d0
		bne.b		1$
		move.b	(DisableNest,pc),d0
		bne.b		1$
		bsr		FuncKey
1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Input device handler
	;a0 = ptr to first input event
	;a1 = ptr to global data
	;-> d0 = ptr to new input event list
	;***
InputHandler:
		movem.l	a0-a3/a6/d1-d4,-(a7)
		movea.l	a0,a2
		move.l	a0,-(a7)				;Remember
		movea.l	a7,a3					;Pointer to this stack position in a3
LoopIH:
		move.l	a2,d0
		beq.b		EndIH
		cmpi.b	#IECLASS_RAWKEY,(ie_Class,a2)
		beq.b		RawKeyIH
NextIH:
		lea		(ie_NextEvent,a2),a3
		movea.l	(a3),a2				;Go to next in a2
		bra.b		LoopIH
EndIH:
		move.l	(a7)+,d0
		movem.l	(a7)+,a0-a3/a6/d1-d4
		rts

	;Handle key
RawKeyIH:
	;Compute d3=code, d4=code+qualifier, a3=pointer to previous NextEvent link
		move.w	(ie_Code,a2),d3
		move.w	d3,d4
		swap		d4
		move.w	(ie_Qualifier,a2),d4
		andi.w	#$00fb,d4

	;Front key
		cmp.l		(HotKey,pc),d4
		bne.b		1$
		bsr		FrontKeyIH

	;It is not the PowerVisor-to-front key
1$		move.b	(InHold,pc),d0
		bne.b		NextIH				;We are in hold, ignore rest

	;Check if PowerVisor window is active
		movea.l	(MainPW),a0
		move.l	(PhysWin_Window,a0),d0
		beq.b		NextIH				;Window does not exist, next event
		movea.l	d0,a0
		move.l	(wd_Flags,a0),d0
		andi.l	#WINDOWACTIVE,d0
		beq.b		NextIH				;Not active, do nothing

	;Check if it is one of the logical window scroll keys
		cmpi.w	#IEQUALIFIER_LALT,d4
		bne.b		2$
		bsr		CheckLeftAltIH

	;Check if it is one of the debug scroll keys
2$		cmpi.w	#IEQUALIFIER_CONTROL,d4
		bne.b		3$
		bsr		CheckCtrlIH

	;Check if it is the 'next window' key
3$		cmp.l		(NextWinKey,pc),d4
		bne.b		4$
		bsr		NextWindowIH

	;Check the history keys
4$		cmp.l		(HistUpKey,pc),d4
		bne.b		5$
		bsr		UpKeyIH
5$		cmp.l		(HistDoKey,pc),d4
		bne.b		6$
		bsr		DownKeyIH

	;Check break key
6$		cmp.l		(BreakKey,pc),d4
		bne.b		7$
	;Break key
		move.l	(ie_NextEvent,a2),(a3)	;Unlink
		lea		(Port),a0
		move.w	#1,(mp_BreakWanted,a0)
		movea.l	(RealThisTask),a1
		move.l	(PVBreakSigSet,pc),d0
		CALLEXEC	Signal

	;Check pause key
7$		cmp.l		(PauseKey,pc),d4
		bne.b		8$
	;Pause key
		move.l	(ie_NextEvent,a2),(a3)	;Unlink
		lea		(Port),a0
		move.w	#2,(mp_BreakWanted,a0)
		movea.l	(RealThisTask),a1
		move.l	(PVBreakSigSet,pc),d0
		CALLEXEC	Signal

8$		bra.b		CheckAttachIH

	;PowerVisor-to-front key
FrontKeyIH:
		move.l	(ie_NextEvent,a2),(a3)	;Unlink
		move.l	(FrontSigSet,pc),d0
		bra		SignalBreak

	;Down key
DownKeyIH:
		lea		(DownHistory,pc),a1
		bra.b		HandleHistoryIH

	;Up key
UpKeyIH:
		lea		(UpHistory,pc),a1

	;Handle history movement, only on active logical window or if not locked
HandleHistoryIH:
		move.l	(LockWin),d1
		beq.b		1$
		bsr		FuncGetActive
		cmp.l		d0,d1
		bne.b		2$
		move.b	(LockState),d0		;Is stringgadget active ?
		beq.b		1$
2$		rts
1$		jsr		(a1)
		bsr		GetHistoryLine
		move.l	(ie_NextEvent,a2),(a3)	;Unlink
		move.l	(RefreshSigSet,pc),d0
		bra		SignalBreak

	;Check if the key is an attached key
CheckAttachIH:
		move.w	d3,d0
		andi.w	#255,d0
		move.w	d0,d2
		move.w	d0,d1
		andi.b	#7,d0					;Bit number
		lsr.w		#3,d1					;Byte number
		lea		(Attachings,pc),a0
		btst		d0,(0,a0,d1.w)
		beq		NextIH
	;It could be
		lea		(KeyAttach,pc),a0
2$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq		NextIH				;End
		cmp.w		(ka_Code,a0),d2
		bne.b		2$
		cmp.w		(ka_Qualifier,a0),d4
		bne.b		2$
		move.w	(ka_Flags,a0),d1
		andi.w	#KAF_INVISIBLE,d1
		bne.b		3$
		move.w	(ka_Flags,a0),d1
		andi.w	#KAF_SNAP,d1
		bne.b		4$
		move.w	(ka_Flags,a0),d1
		andi.w	#KAF_ALWAYS,d1
		bne.b		5$
	;It is, simulate a return
		move.w	#ENTERKEY,(ie_Code,a2)
		andi.w	#$ff00,(ie_Qualifier,a2)
		movea.l	(ka_CommandString,a0),a0
		movea.l	(Line),a1
1$		move.b	(a0)+,(a1)+
		bne.b		1$
		bra		NextIH
	;Command must be executed invisible (using IDC command)
3$		move.l	(ka_CommandString,a0),(InputDevArg)
		moveq		#IDC_EXEC,d0
		bsr		SendIDC
		bra		NextIH
	;Command must be snapped to the commandline
4$		move.l	(ka_CommandString,a0),(InputDevArg)
		moveq		#IDC_SNAP,d0
		bsr		SendIDC
		bra		NextIH
	;Command must be executed invisible (using IDC command)
	;and always
5$		move.l	(ka_CommandString,a0),(InputDevArg)
		moveq		#IDC_EXECALWAYS,d0
		bsr		SendIDC
		bra		NextIH

	;Subroutine
SignalBreak:
		movea.l	(BreakTaskPtr,pc),a1
		CALLEXEC	Signal
		rts

IDCKeys1:
		dc.b		NUPKEY,IDC_SCROLL1UP
		dc.b		NDOWNKEY,IDC_SCROLL1DO
		dc.b		NLEFTKEY,IDC_SCROLL1LE
		dc.b		NRIGHTKEY,IDC_SCROLL1RI
		dc.b		PGUPKEY,IDC_SCROLLPGUP
		dc.b		PGDNKEY,IDC_SCROLLPGDO
		dc.b		HOMEKEY,IDC_SCROLLHOME
		dc.b		ENDKEY,IDC_SCROLLEND
		dc.b		NMIDKEY,IDC_SCROLLRIGHT
		dc.b		0,0

IDCKeys2:
		dc.b		NLEFTKEY,IDC_DSCROLL1UP
		dc.b		NRIGHTKEY,IDC_DSCROLL1DO
		dc.b		PGUPKEY,IDC_DSCROLLPGUP
		dc.b		PGDNKEY,IDC_DSCROLLPGDO
		dc.b		NMIDKEY,IDC_DSCROLLPC
		dc.b		NUPKEY,IDC_DSCROLL1IUP
		dc.b		NDOWNKEY,IDC_DSCROLL1IDO
		dc.b		0,0

	;The left ALT is pressed. Check if the key is one of the arrows to
	;scroll through our logical window.
CheckLeftAltIH:
		lea		(IDCKeys1,pc),a0
		bra.b		SearchIDCIH

	;The CTRL key is pressed. Check if the key is one of the arrows
	;to scroll in our debug window.
CheckCtrlIH:
		lea		(IDCKeys2,pc),a0
SearchIDCIH:
		move.b	(a0)+,d1				;Code
		beq.b		2$
		move.b	(a0)+,d0				;IDC
		cmp.b		d3,d1
		bne.b		SearchIDCIH
		bra.b		SendRIDC
2$		rts

NextWindowIH:
		moveq		#IDC_NEXTWIN,d0
		bra.b		SendRIDC

	;Send InputDevice command to PowerVisor
	;d0 = command to send
SendIDC:
		move.w	(ka_Flags,a0),d1
		andi.w	#KAF_HOLDKEY,d1
		bne.b		NoRemSendIDC

	;Remove key from input handler list
SendRIDC:
		move.l	(ie_NextEvent,a2),(a3)	;Unlink
	;Fall through

	;Don't remove key
NoRemSendIDC:
		lea		(InputDevCmd,pc),a0
		move.b	d0,(a0)
		move.l	(IDevSigSet,pc),d0
		movea.l	(RealThisTask),a1
		CALLEXEC	Signal
		rts

	;***
	;Open all libraries
	;-> d0 = 0 if on error or error code if error (flags)
	;***
OpenLib:
	;IntuitionLibrary
		lea		(IntuitionLib,pc),a1
		CALLEXEC	OldOpenLibrary
		lea		(IntBase,pc),a0
		move.l	d0,(a0)
	;Layers library
		lea		(LayersLib,pc),a1
		CALL		OldOpenLibrary
		lea		(LayersBase,pc),a0
		move.l	d0,(a0)
	;ExpansionLibrary
		lea		(ExpansLib,pc),a1
		CALL		OldOpenLibrary
		lea		(ExpBase,pc),a0
		move.l	d0,(a0)
	;UtilityLibrary
 IFD D20
		lea		(UtilLib,pc),a1
		CALL		OldOpenLibrary
		lea		(UtilBase,pc),a0
		move.l	d0,(a0)
		beq.b		3$
 ENDC
	;GraphicsLibrary
		lea		(GraphicsLib,pc),a1
		CALL		OldOpenLibrary
		lea		(Gfxbase,pc),a0
		move.l	d0,(a0)
	;DiskFontBase
		lea		(DFLib,pc),a1
		CALL		OldOpenLibrary
		lea		(DFBase,pc),a0
		move.l	d0,(a0)
	;PowerVisor
		lea		(PVLib,pc),a1
		CALL		OldOpenLibrary
		lea		(PVBase,pc),a0
		move.l	d0,(a0)
		bne.b		1$
3$		bsr		CloseLib
		moveq		#ERROR_LIBRARY,d0
		rts
1$		moveq		#0,d0					;No error
		rts

	;***
	;Close all open libraries
	;***
CloseLib:
		movea.l	(SysBase).w,a6
		move.l	(IntBase,pc),d0
		beq.b		1$
		movea.l	d0,a1
		CALL		CloseLibrary
1$
 IFD D20
		move.l	(UtilBase,pc),d0
		beq.b		2$
		movea.l	d0,a1
		CALL		CloseLibrary
 ENDC
2$		move.l	(Gfxbase,pc),d0
		beq.b		3$
		movea.l	d0,a1
		CALL		CloseLibrary
3$		move.l	(ExpBase,pc),d0
		beq.b		4$
		movea.l	d0,a1
		CALL		CloseLibrary
4$		move.l	(PVBase,pc),d0
		beq.b		5$
		movea.l	d0,a1
		CALL		CloseLibrary
5$		move.l	(DFBase,pc),d0
		beq.b		6$
		movea.l	d0,a1
		CALL		CloseLibrary
6$		move.l	(LayersBase,pc),d0
		beq.b		7$
		movea.l	d0,a1
		CALL		CloseLibrary
7$		move.l	(MathDPBase,pc),d0
		beq.b		8$
		movea.l	d0,a1
		CALL		CloseLibrary
8$		movea.l	(DosBase,pc),a1
		CALL		CloseLibrary
		rts

	;***
	;Close misc things
	;***
CloseMain:
		moveq		#0,d0
		CALLEXEC	FreeTrap
		moveq		#1,d0
		CALL		FreeTrap
		moveq		#2,d0
		CALL		FreeTrap
		moveq		#3,d0
		CALL		FreeTrap
		moveq		#4,d0
		CALL		FreeTrap
		moveq		#5,d0
		CALL		FreeTrap
		moveq		#6,d0
		CALL		FreeTrap

*		move.l	(Storage,pc),d0
*		beq.b		3$
*		movea.l	d0,a1
*		moveq		#75,d0
*		lsl.l		#2,d0					;75*4 = 300
*		bsr		FreeMem

3$		move.l	(HoldSigNum,pc),d0
		CALLEXEC	FreeSignal
		move.l	(PVBreakSigNum,pc),d0
		CALL		FreeSignal
		move.l	(IDevSigNum,pc),d0
		CALL		FreeSignal

*2$		move.l	(AliasRoutines,pc),d0
*		beq.b		1$
*		movea.l	d0,a0
*		bsr		RemoveAlias
*		bra.b		2$
1$		rts

	;***
	;Initialize some misc things
	;-> d0 = 0 if success (flags) else error code
	;***
InitMain:
		moveq		#0,d0
		CALLEXEC	AllocTrap
		moveq		#1,d0
		CALL		AllocTrap
		moveq		#2,d0
		CALL		AllocTrap
		moveq		#3,d0
		CALL		AllocTrap
		moveq		#4,d0
		CALL		AllocTrap
		moveq		#5,d0
		CALL		AllocTrap
		moveq		#6,d0
		CALL		AllocTrap

		moveq		#75,d0
		lsl.l		#2,d0					;75*4 = 300
		bsr		AllocClear
		bne.b		2$
		moveq		#ERROR_MEMORY,d0
		rts
2$		lea		(Storage,pc),a0
		move.l	d0,(a0)

	;Clear all attaching keys
		moveq		#7,d1
		lea		(Attachings,pc),a0
1$		clr.l		(a0)+
		dbra		d1,1$
	;Init lists
		lea		(KeyAttach,pc),a0
		NEWLIST	a0
	;Allocate signals
		lea		(IDevSigNum,pc),a2
		bsr		AllocSignal
		lea		(PVBreakSigNum,pc),a2
		bsr		AllocSignal
		lea		(RefreshNum,pc),a2
		bsr		AllocSignal			;This signal is freed in 'pv_general.asm'
		lea		(HoldSigNum,pc),a2
		bsr		AllocSignal
		moveq		#0,d0					;Success
		rts

	;***
	;Init script line
	;-> d0 = 0 if success (flags) else error code
	;***
InitScriptLine:
		moveq		#0,d0
		move.w	(DefLineLen),d0
		move.l	#MEMF_CLEAR,d1
		bsr		AllocMem
		lea		(ScriptLine,pc),a0
		move.l	d0,(a0)
		bne.b		1$

	;Error
		moveq		#ERROR_MEMORY,d0
		rts

1$		moveq		#0,d0					;Success
		rts

	;***
	;Init all functions
	;-> d0 = 0 if success (flags) else error code
	;***
InitFunctions:
		lea		(RexxCommandList,pc),a4
1$		cmpa.l	#RealCommands,a4
		beq.b		2$
		movea.l	(a4),a0
		lea		(8,a4),a4
		movea.l	(a4)+,a1
		bsr		CreateFunc
		bne.b		1$
	;Error
		moveq		#ERROR_MEMORY,d0
		rts

2$		moveq		#0,d0					;Success
		rts

*	;***
*	;Free all our memory
*	;***
*FreeMemory:
*		move.l	(QuitCommand,pc),d0
*		beq.b		5$
*		movea.l	d0,a0
*		bsr		FreeBlock
*5$		move.l	(AfterCommand,pc),d0
*		beq.b		4$
*		movea.l	d0,a0
*		bsr		FreeBlock
*4$		move.l	(EnterCommand,pc),d0
*		beq.b		3$
*		movea.l	d0,a0
*		bsr		FreeBlock
*3$		move.l	(RefreshCmd,pc),d0
*		beq.b		1$
*		movea.l	d0,a0
*		bsr		FreeBlock
*1$		move.l	(ScriptLine,pc),d0
*		beq.b		2$
*		movea.l	d0,a1
*		moveq		#0,d0
*		move.w	(DefLineLen),d0
*		bsr		FreeMem
*2$		rts

	;***
	;Free the history buffers
	;***
FreeHistory:
		move.l	(History,pc),d0
		beq.b		2$

		movea.l	d0,a1
		lea		(History,pc),a0
		move.l	(a1),(a0)			;Fill in next history line in 'History'
		moveq		#0,d0
		move.w	(8,a1),d0				;Get size
		bsr		FreeMem
		bra.b		FreeHistory

	;Clear fields ('History' is already 0)
2$		lea		(HistoryLines,pc),a0
		move.l	d0,(a0)				;d0 = 0
		lea		(LastHistory,pc),a0
		move.l	d0,(a0)
		rts

*	;***
*	;Remove all key attachments
*	;***
*RemoveKeyAttach:
*		lea		(KeyAttach,pc),a2
*		movea.l	(a2),a2				;Succ
*		tst.l		(a2)					;Succ
*		beq.b		1$
*		move.l	a2,d0
*		bsr		RemKeyAttachDirect
*		bra.b		RemoveKeyAttach
*1$		rts

	;***
	;Install break task
	;-> d0 = 0 if success (flags) else errorcode
	;***
InstallBreakTask:
		lea		(TaskMemTempl,pc),a0
		clr.l		(a0)					;Succ
		CALLEXEC	AllocEntry
		lea		(TaskMemList,pc),a0
		move.l	d0,(a0)
		bne.b		1$
		moveq		#ERROR_MEMORY,d0
		rts
1$		movea.l	d0,a0
	;Get ptr to stack and then the ptr to the task structure
		movea.l	(ML_ME+ME_SIZE+ME_ADDR,a0),a1
		movea.l	(ML_ME+ME_ADDR,a0),a0
		lea		(BreakTaskPtr,pc),a2
		move.l	a0,(a2)
		move.l	a1,(TC_SPLOWER,a0)
		lea		(4096,a1),a1
		move.l	a1,(TC_SPREG,a0)
		move.l	a1,(TC_SPUPPER,a0)
		move.b	#NT_TASK,(LN_TYPE,a0)
		clr.b		(LN_PRI,a0)
		move.l	#BreakTaskName,(LN_NAME,a0)
		lea		(TC_MEMENTRY,a0),a0
		movea.l	a0,a2
		NEWLIST	a0
		movea.l	a2,a0
		movea.l	(TaskMemList,pc),a1
		CALLEXEC	AddHead
		movea.l	(BreakTaskPtr,pc),a1
		lea		(BreakTask,pc),a2
		suba.l	a3,a3
		CALL		AddTask
		moveq		#0,d0					;Success
		rts

	;***
	;Remove break task
	;***
RemoveBreakTask:
		move.l	(BreakTaskPtr,pc),d0
		beq.b		1$
		movea.l	d0,a1
		CALLEXEC	RemTask
1$		rts

	;***
	;Install input device
	;-> d0 = 0 if success (flags) else errorcode
	;***
InstallInputDevice:
		moveq		#0,d0
		movea.l	d0,a1
		moveq		#IOSTD_SIZE,d1
		lea		(InputDevice,pc),a0
		bsr		InstallDevice
		lea		(InputRequestB,pc),a0
		move.l	d0,(a0)
		lea		(InputDevPort,pc),a0
		move.l	d1,(a0)
		bne.b		1$
		moveq		#ERROR_MEMORY,d0
		rts
1$		lea		(HandlerStuff,pc),a0
		clr.l		(IS_DATA,a0)
		lea		(InputHandler,pc),a6
		move.l	a6,(IS_CODE,a0)
		move.b	#53,(LN_PRI,a0)
		lea		(InputName,pc),a6
		move.l	a6,(LN_NAME,a0)
		movea.l	(InputRequestB,pc),a1
		move.w	#IND_ADDHANDLER,(IO_COMMAND,a1)
		move.l	a0,(IO_DATA,a1)
		CALLEXEC	DoIO
		moveq		#0,d0					;Success
		rts

	;***
	;Remove input device
	;***
RemoveInputDevice:
		move.l	(InputRequestB,pc),d0
		beq.b		1$
		movea.l	d0,a1
		move.w	#IND_REMHANDLER,(IO_COMMAND,a1)
		lea		(HandlerStuff,pc),a0
		move.l	a0,(IO_DATA,a1)
		CALLEXEC	DoIO
		movea.l	(InputRequestB,pc),a1
		movea.l	(InputDevPort,pc),a0
		bsr		RemoveDevice
1$		lea		(InputRequestB,pc),a0
		move.l	d0,(a0)
		lea		(InputDevPort,pc),a0
		move.l	d0,(a0)
		rts

	;***
	;Add an event
	;d0 = code
	;d1 = qualifier
	;d2 = class
	;d3 = subclass
	;d4 = x
	;d5 = y
	;***
AddEvent:
		lea		(Event,pc),a0
		move.w	d0,(ie_Code,a0)
		move.w	d1,(ie_Qualifier,a0)
		move.b	d2,(ie_Class,a0)
		move.b	d3,(ie_SubClass,a0)
		move.w	d4,(ie_X,a0)
		move.w	d5,(ie_Y,a0)
		movea.l	(InputRequestB,pc),a1
		move.w	#IND_WRITEEVENT,(IO_COMMAND,a1)
		moveq		#ie_SIZEOF,d0
		move.l	d0,(IO_LENGTH,a1)
		move.l	a0,(IO_DATA,a1)
		CALLEXEC	DoIO
		rts

	;***
	;Check if a file exists in PROGDIR: or else in S:
	;If true copy the right filename to some place and return the pointer
	;to it
	;a0 = pointer to filename (without path)
	;-> d1 = 0 if not found (flags) else pointer to filename
	;-> d0 = d1
	;***
CopyFileName:
		lea		(DefPath,pc),a1
		bsr		SearchPath
		beq.b		2$						;No file
		movea.l	d0,a0
		movea.l	(Storage,pc),a1
1$		move.b	(a0)+,(a1)+
		bne.b		1$
		movea.l	d0,a0
		bsr		FreeBlock
		move.l	(Storage,pc),d0
2$		move.l	d0,d1					;For flags
		rts

	;***
	;Get an error
	;d0 = error number
	;-> a0 = ptr to string
	;***
GetError:
		move.l	d5,-(a7)
		addq.l	#7,d0					;Correct for negative errors
		move.l	d0,d4
		move.l	(ErrorFile,pc),d1
		bne.b		1$
		lea		(pvErrorFile,pc),a0
		bsr		CopyFileName
		beq.b		2$
		bsr		FOpen
2$		lea		(ErrorFile,pc),a0
		move.l	d0,(a0)
		beq.b		3$

	;There is a file
1$		move.l	d4,d2
		mulu.w	#70,d2
		moveq		#OFFSET_BEGINNING,d3
		bsr		FSeek
		move.l	(Storage,pc),d2
		moveq		#69,d3
		bsr		FRead
		movea.l	(Storage,pc),a0
		clr.b		(69,a0)

	;The end
4$		move.l	(a7)+,d5
		rts

	;There is no error file, we give a number instead
3$		movea.l	(Storage,pc),a0
		move.l	#'Erro',(a0)+
		move.l	#'r:  ',(a0)+
		move.l	d4,d0
		bsr		LongToDec
		movea.l	(Storage,pc),a0
		bra.b		4$

	;***
	;Set an error value
	;d0 = value
	;***
SetError:
		move.l	a0,-(a7)
		movea.l	(VarStorage),a0
		lea		(VOFFS_ERROR,a0),a0
		move.l	d0,(a0)
		movea.l	(a7)+,a0
		rts

	;***
	;Set an error and call the error handler
	;d0 = errornumber
	;***
ErrorRoutine:
		lea		(LastError,pc),a0
		move.w	d0,(a0)

	;***
	;Handle the case of an error
	;***
HandleError:
		moveq		#0,d0
		move.w	(LastError,pc),d0

		bsr		PermitAll
		bsr		SetError
		bra		Remind

	;***
	;Print the current error
	;Error in VOFFS_ERROR
	;***
PrintError:
		moveq		#0,d0
		move.w	(LastError,pc),d0
		beq.b		1$
		bsr		SetError
		bsr		GetError
		PRINT
		NEWLINE
1$		rts

	;***
	;Print formated
	;a0 = format string
	;a1 = structure
	;after 'bsr PrintFor' follow the actual data offsets to print
	;MUST be called with 'bsr' or 'jsr'
	;Format for data after 'bsr':
	;		<type byte = 0 (b),1 (w),2 (l),3 (s)> <offset byte> |
	;		-1 (for structure pointer) |
	;		<type byte = 0 (b),1 (w),2 (l),3 (s)> -1 (for immediate value)
	;		...
	;		-2
	;-> a1 = structure
	;-> d0 = pointer where string was put
	;***
PrintFor:
		move.l	(Storage,pc),d0
		bsr.b		PreparePrintPF		;Must be bsr!
		bra		ViewPrintLine

	;Don't print yet, only put in storage
	;extra argument :
	;d0 = pointer to place to put string
PrintForQ:
		bsr.b		PreparePrintPF		;Must be bsr!
		rts

PreparePrintPF:
		movem.l	a1-a5,-(a7)
		movea.l	d0,a4					;Remember pointer to 'Storage'
		movea.l	(4*5+4,a7),a2		;Return address
		movea.l	a7,a3					;Remember stackframe pointer
		movea.l	a1,a5					;Remember pointer to structure

3$		movea.l	a5,a1					;Restore pointer to real structure
		move.w	(a2)+,d0
		cmp.w		#-2,d0				;-2 = the end
		beq.b		2$
		cmp.w		#-1,d0				;-1 = pointer to structure
		bne.b		1$

	;We must push the pointer to the structure on the stack
		move.l	a1,-(a7)
		bra.b		3$

1$		move.b	d0,d1					;d1.b = offset
		ext.w		d1
		cmp.w		#-1,d1
		bne.b		7$
	;We have an immediate value
	;Temporarily set the pointer to the structure to a2
	;and the offset to 0
		movea.l	a2,a1
		moveq		#0,d1
		lea		(4,a2),a2			;Skip immediate value

7$		lsr.w		#8,d0					;d0.b = type (0, 1, 2 or 3)
		tst.b		d0
		beq.b		4$

	;Word, long or string
		subq.b	#1,d0
		beq.b		5$

	;Long or string (difference doesn't matter anymore since
	;'FastFPrint' handles NULL string pointers)
;		subq.b	#1,d0
;		beq.b		6$
;
;	;String
;		move.l	(a1,d1.w),-(a7)
;		bne.b		3$
;		move.l	#EmptyString,(a7)
;		bra.b		3$

	;Long
6$		move.l	(a1,d1.w),-(a7)
		bra.b		3$

	;Word
5$		move.w	(a1,d1.w),-(a7)
		bra.b		3$

	;Byte
4$		moveq		#0,d0
		move.b	(a1,d1.w),d0
		move.w	d0,-(a7)
		bra.b		3$

	;The end
2$		move.l	a4,d0
		movea.l	a7,a1
		bsr.b		FastFPrint
		movea.l	a3,a7					;Restore stackframe

		move.l	a2,(4*5+4,a7)		;Change return address
		move.l	a4,d0

		movem.l	(a7)+,a1-a5
		rts

	;***
	;SPrintf
	;a0 = format string
	;a1 = data stream
	;d0 = string
	;***
SPrintf:
		movem.l	a2-a3,-(a7)
		movea.l	d0,a3
		lea		(PutChar,pc),a2
		CALLEXEC	RawDoFmt
		movem.l	(a7)+,a2-a3
		rts
PutChar:
		move.b	d0,(a3)+
		rts

	;***
	;Faster SPrintf but rather primitive
	;
	;Format specifiers (# is one byte) :
	;
	;		<my format>	: <standard RawDoFmt equivalent>
	;		%a#			: %-#.#s		(ls)
	;		%b#			: %#.#s		(s)
	;		%c				: %04x		(x)
	;		%d				: %08lx		(X)
	;		%e#			: %-#.d		(ld)
	;		%f#			: %-#.ld		(lD)
	;		%g#			: %#.d		(d)
	;		%h#			: %#.ld		(D)
	;		%i				: %%			(per)
	;		%j				: %02x		(bx)	(same as %c but for byte values)
	;		%k				: %c			(c)
	;
	;WARNING! If the format string is not correct a crash will probably
	;occur. There is NO error checking at all!!!
	;
	;a0 = format string
	;a1 = data stream
	;d0 = output string
	;***
FastFPrint:
		movem.l	a2-a3,-(a7)
		movea.l	d0,a2					;Output string

	;Main loop
1$		move.b	(a0)+,d0
		move.b	d0,(a2)+
		beq.b		2$
		cmpi.b	#'%',d0
		bne.b		1$

	;There is a format specifier following
		subq.l	#1,a2					;Go one back in output
		moveq		#0,d0
		move.b	(a0)+,d0				;We do no error correction, the
											;formatstring MUST be correct or strange
											;things will happen!!!
		sub.b		#'a',d0
		add.w		d0,d0
		lea		(3$,pc),a3
		move.w	(0,a3,d0.w),d0
		jsr		(0,a3,d0.w)
		bra.b		1$

3$		dc.w		.a-3$
		dc.w		.b-3$
		dc.w		.c-3$
		dc.w		.d-3$
		dc.w		.e-3$
		dc.w		.f-3$
		dc.w		.g-3$
		dc.w		.h-3$
		dc.w		.i-3$
		dc.w		.j-3$
		dc.w		.k-3$

	;The end
2$		movem.l	(a7)+,a2-a3
		rts

	;Get pointer to string from data stream and compute its length
	;d1.b = total length (if 0, total length will be equal to length of string)
	;d0 = pointer to string (may be NULL)
	;-> a3 = pointer to string
	;-> d0.w = length (length will be smaller than input d1)
	;-> d1.w = remaining length (extended to word)
	;-> d0.w+d1.w = total length (input d1 if this was not 0)
	;-> a0 and a2 are unchanged (a1 is updated)
4$		ext.w		d1

		tst.l		d0						;Test pointer to string
		beq.b		5$

		movea.l	d0,a3
		move.l	d0,-(a7)				;Remember pointer to start of string

6$		tst.b		(a3)+
		bne.b		6$

		suba.l	d0,a3					;a3 = length + 1
		subq.l	#1,a3					;a3 = length
		move.w	a3,d0					;d0 = length
		movea.l	(a7)+,a3				;a3 = pointer to start of string

5$		tst.w		d1
		beq.b		16$					;If d1 == 0, d0 is not constrained

		cmp.w		d0,d1
		bge.b		15$
		move.w	d1,d0

15$	sub.w		d0,d1					;d1 becomes remaining length
16$	rts

	;---
	;%a# (%-#.#s)
	;---
.a		move.l	(a1)+,d0				;Get pointer to string
		move.b	(a0)+,d1				;Get maximum number of characters in string
.a2	bsr.b		4$						;Get string

		bra.b		7$
8$		move.b	(a3)+,(a2)+			;Copy string (without 0 at the end)
7$		dbra		d0,8$

		bra.b		9$
10$	move.b	#' ',(a2)+			;Copy spaces
9$		dbra		d1,10$

		rts

	;---
	;%b# (%#.#s)
	;---
.b		move.l	(a1)+,d0				;Get pointer to string
		move.b	(a0)+,d1				;Get maximum number of characters in string
.b2	bsr.b		4$						;Get string

		bra.b		11$
12$	move.b	#' ',(a2)+			;Copy spaces
11$	dbra		d1,12$

		bra.b		13$
14$	move.b	(a3)+,(a2)+			;Copy string (without 0 at the end)
13$	dbra		d0,14$

		rts

	;---
	;%c (%04x)
	;---
.c		move.w	(a1)+,d0				;Get word
		exg		a2,a0
		bsr		WordToHex
		exg		a2,a0
		lea		(4,a2),a2			;Advance output pointer
		rts

	;---
	;%d (%08lx)
	;---
.d		move.l	(a1)+,d0				;Get long
.d2	exg		a2,a0
		bsr		LongToHex
		exg		a2,a0
		lea		(8,a2),a2			;Advance output pointer
		rts

	;---
	;%e# (%-#.d)
	;---
.e		move.w	(a1)+,d0				;Get word
		ext.l		d0
.e2	lea		(-16,a7),a7			;Reserve space on stack
		movea.l	a7,a3
		bsr		ToDec
		move.b	(a0)+,d1				;Get maximum number of characters
	;d0 = pointer to string containing number
	;d1.b = maximum number of chars
	;This is the same as %a so we can continue there
		bsr.b		.a2
		lea		(16,a7),a7			;Clear stack
		rts

	;---
	;%f# (%-#.ld)
	;---
.f		move.l	(a1)+,d0				;Get long
		bra.b		.e2

	;---
	;%g# (%#.d)
	;---
.g		move.w	(a1)+,d0				;Get word
		ext.l		d0
.g2	lea		(-16,a7),a7			;Reserve space on stack
		movea.l	a7,a3
		bsr		ToDec
		move.b	(a0)+,d1				;Get maximum number of characters
		bsr.b		.b2
		lea		(16,a7),a7			;Clear stack
		rts

	;---
	;%h# (%#.ld)
	;---
.h		move.l	(a1)+,d0				;Get long
		bra.b		.g2

	;---
	;%i (%%)
	;---
.i		move.b	#'%',(a2)+
		rts

	;---
	;%j (%02x for bytes)
	;---
.j		move.w	(a1)+,d0				;Get byte (packed in word)
		exg		a2,a0
		bsr		ByteToHex
		exg		a2,a0
		lea		(2,a2),a2			;Advance output pointer
		rts

	;---
	;%k (%c)
	;---
.k		move.w	(a1)+,d0				;Get byte (packed in word)
		move.b	d0,(a2)+
		rts

	;***
	;Convert a decimal long to some space
	;d0 = long number
	;a3 = pointer to space (must be 16 bytes long)
	;-> d0 = pointer to string (not equal to a3!)
	;-> all other registers are preserved
	;***
ToDec:
		movem.l	a0-a3/d1-d2,-(a7)
		lea		(16,a3),a2			;Point after end
		clr.b		-(a2)					;NULL terminate

		move.l	d0,d2					;Remember real number
		tst.l		d0
		beq.b		1$
		bpl.b		3$
	;The number is negative, make positive
		neg.l		d0
		bmi.b		4$						;If still negative we have -$80000000

	;Fill the number
3$		moveq		#10,d1
		bsr		LDiv
	;d0 = rest of number
	;d1 = modulo (0..9)
		add.b		#'0',d1
		move.b	d1,-(a2)
		tst.l		d0
		bne.b		3$

		tst.l		d2
		bge.b		2$
		move.b	#'-',-(a2)

2$		move.l	a2,d0
		movem.l	(a7)+,a0-a3/d1-d2
		rts

	;Number is 0
1$		move.b	#'0',-(a2)
		bra.b		2$

	;Number is -$80000000
4$		lea		(NegNum,pc),a2
		bra.b		2$

NegNum:	dc.b	"-2147483648",0
		EVEN

	;***
	;Forbid (remember nest count)
	;This routine preserves all registers (even a6)
	;***
Forbid:
		move.l	a6,-(a7)
		CALLEXEC	Forbid
		lea		(ForbidNest,pc),a6
		addq.b	#1,(a6)
		movea.l	(a7)+,a6
		rts

	;***
	;Permit (remember nest count)
	;This routine preserves all registers (even a6)
	;***
Permit:
		move.l	a6,-(a7)
		CALLEXEC	Permit
		lea		(ForbidNest,pc),a6
		subq.b	#1,(a6)
		movea.l	(a7)+,a6
		rts

	;***
	;Disable (remember nest count)
	;This routine preserves all registers (even a6)
	;***
Disable:
		move.l	a6,-(a7)
		CALLEXEC	Disable
		lea		(DisableNest,pc),a6
		addq.b	#1,(a6)
		movea.l	(a7)+,a6
		rts

	;***
	;Enable (remember nest count)
	;This routine preserves all registers (even a6)
	;***
Enable:
		move.l	a6,-(a7)
		CALLEXEC	Enable
		lea		(DisableNest,pc),a6
		subq.b	#1,(a6)
		movea.l	(a7)+,a6
		rts

	;***
	;Permit all
	;***
PermitAll:
		tst.b		(ForbidNest)
		beq.b		1$
		bsr		Permit
		bra.b		PermitAll
1$		rts

	;***
	;Enable all
	;***
EnableAll:
		tst.b		(DisableNest)
		beq.b		1$
		bsr		Enable
		bra.b		EnableAll
1$		rts

	;***
	;CreatePort
	;***
CreatePort:
 IFD D20
		CALLEXEC	CreateMsgPort
 ENDC
 IFND D20
		pea		(0)
		pea		(0)
		bsr		_CreatePort
		lea		(8,a7),a7
 ENDC
		rts

	;***
	;DeletePort
	;a1 = port
	;***
DeletePort:
 IFD D20
		movea.l	a1,a0
		CALLEXEC	DeleteMsgPort
 ENDC
 IFND D20
		move.l	a1,-(a7)
		bsr		_DeletePort
		lea		(4,a7),a7
 ENDC
		rts

	;***
	;LMult
	;-> d0 = result
	;***
__CXM33:
LMult:
 IFD	D20
		CALLUTIL	SMult32
 ENDC
 IFND	D20
		movem.l	d2-d3,-(a7)
		move.l	d0,d2
		move.l	d1,d3
		swap.w	d2
		swap.w	d3
		mulu.w	d1,d2
		mulu.w	d0,d3
		mulu.w	d1,d0
		add.w		d3,d2
		swap.w	d2
		clr.w		d2
		add.l		d2,d0
		movem.l	(a7)+,d2-d3
 ENDC
		rts

	;***
	;LDiv
	;-> d0 = result
	;-> d1 = modulo
	;***
__CXD33:
LDiv:
 IFD	D20
		CALLUTIL	SDivMod32
 ENDC
 IFND	D20
		tst.l		d0
		bpl.b		1$
		neg.l		d0
		tst.l		d1
		bpl.b		2$
		neg.l		d1
		bsr.b		3$
		neg.l		d1
		rts

2$		bsr.b		3$
		neg.l		d0
		neg.l		d1
		rts

1$		tst.l		d1
		bpl.b		3$
		neg.l		d1
		bsr.b		3$
		neg.l		d0
		rts

3$		move.l	d3,-(a7)
		cmpi.l	#$ffff,d1
		bhi.b		4$
		move.l	d1,d3
		swap.w	d0
		move.w	d0,d3
		beq.b		5$
		divu.w	d1,d3
		move.w	d3,d0
5$		swap.w	d0
		move.w	d0,d3
		divu.w	d1,d3
		move.w	d3,d0
		swap.w	d3
		move.w	d3,d1
		move.l	(a7)+,d3
		rts

4$		move.l	d2,-(a7)
		move.l	d1,d3
		move.l	d0,d1
		clr.w		d1
		swap.w	d1
		swap.w	d0
		clr.w		d0
		moveq		#$f,d2
7$		add.l		d0,d0
		addx.l	d1,d1
		cmp.l		d1,d3
		bhi.b		6$
		sub.l		d3,d1
		addq.w	#1,d0
6$		dbra		d2,7$
		movem.l	(a7)+,d2-d3
 ENDC
		rts

	;***
	;LMod
	;***
LMod:
		bsr		LDiv
		move.l	d1,d0
		rts

	;***
	;Entry point for disassembler
	;	a0 = string to disassemble in
	;	d0 = address
	;	a4 = stackframe
	;	-> d0 = bytes disassembled
	;	-> a0 = pointer to end of string
	;***
CallDisasm:
		move.l	a4,-(a7)
		move.l	d0,-(a7)
		move.l	a0,-(a7)
		bsr		_disasm
		lea		(12,a7),a7
		move.l	d0,-(a7)
		bsr		_getstr
		movea.l	d0,a0
		move.l	(a7)+,d0
		rts

	;***
	;Print debug information from within C
	;***
_PrintNum:
		move.l	($0004,a7),d0
		bra		PrintRealHexNL

	;***
	;Print debug information from within C
	;***
_Print:
		movea.l	($0004,a7),a0
		PRINT
		rts

	;***
	;Check for a symbol. This routine is called from C
	;stack = symbol value to check for
	;-> d0 = 0 if no symbol or pointer to symbol string if there is a symbol
	;***
_CheckForSymbol:
		move.l	a2,-(a7)

		moveq		#0,d0
		move.l	(CurrentDebug),d1
		beq.b		1$
		movea.l	d1,a2
		move.l	($0008,a7),d0
		bsr		GetSymbolStr

1$		movea.l	(a7)+,a2
		rts

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;***
	;Start of MainBase
	;***
MainBase:

DOS2:				dc.w	0

	;Library bases
DosBase:			dc.l	0
IntBase:			dc.l	0
Gfxbase:			dc.l	0
UtilBase:		dc.l	0
ExpBase:			dc.l	0
DFBase:			dc.l	0
PVBase:			dc.l	0

CmdLine:			dc.l	0
Detach:			dc.l	0				;If true we have detached

ErrorFile:		dc.l	0
StackPointer:	dc.l	0				;For immediate jump routine
ProgramCounter:dc.l	0

SpeedRefresh:	dc.w	0				;Speed of refreshing
CountRefresh:	dc.w	0
RefreshCmd:		dc.l	0				;Ptr to the optional refresh cmd

	;Codes and qualifiers for some keys
BreakKey:		dc.w	ESCAPEKEY,0
HotKey:			dc.w	FRONTKEY,IEQUALIFIER_RSHIFT+IEQUALIFIER_RALT
PauseKey:		dc.w	HELPKEY,IEQUALIFIER_RALT
NextWinKey:		dc.w	TABKEY,0
HistUpKey:		dc.w	UPKEY,0
HistDoKey:		dc.w	DOWNKEY,0

PVDebugMode:	dc.b	0				;If true we are in PowerVisor debug mode
	;PADDING TO AVOID REWRITING THEWIZARDCORNER
					dc.b	0
					dc.b	0
					dc.b	0
EnterCommand:	dc.l	0				;Command to execute before a command executes
AfterCommand:	dc.l	0				;Command to execute after a command executes
QuitCommand:	dc.l	0				;Command to be called before a quit
LastHistory:	dc.l	0				;Pointer to last history line in buffer
LastError:		dc.w	0				;Last error number
ExecLevel:		dc.w	0				;Execute level

HoldSigNum:		dc.l	0				;Signal to unhold
HoldSigSet:		dc.l	0
RefreshNum:		dc.l	0				;Signal for PortPrint
RefreshSet:		dc.l	0
IDevSigNum:		dc.l	0				;Signal for input device command
IDevSigSet:		dc.l	0
RefreshSigNum:	dc.l	0				;Signal to refresh gadget (history) (break task)
RefreshSigSet:	dc.l	0
FrontSigNum:	dc.l	0				;Signal to throw PowerVisor in front (break task)
FrontSigSet:	dc.l	0
PVBreakSigNum:	dc.l	0				;Signal to interrupt PowerVisor (for PV)
PVBreakSigSet:	dc.l	0
BreakTaskPtr:	dc.l	0				;Ptr to our task
InputRequestB:	dc.l	0				;For input device
InputDevPort:	dc.l	0

	;Everything for history
	;See also 'LastHistory' (above) and 'ScanHistory' (below)
History:			dc.l	0				;Ptr to history buffer
HistoryLines:	dc.l	0				;Number of lines in history
HistoryMax:		dc.l	20				;Max number of lines in history

Attachings:		ds.b	32				;One bit for each code

	;Format for one alias entry
	;	<Next alias>
	;	<Previous alias>
	;	<Pointer to command>
	;	<Pointer to alias string>
AliasRoutines:	dc.l	0

ScriptLine:		dc.l	0				;Ptr to line for script
;OBSOLETE DefaLineLen:	dc.w	LINELEN		;Max LINELEN chars

CommentChar:	dc.b	';'
SuppressChar:	dc.b	'~'
QuickExecChar:	dc.b	'\'
NoOutputChar:	dc.b	'-'

LastCmd:			dc.b	0				;If 1, last cmd is memory, if 2 unasm, if 3 view
					dc.b	0				;OBSOLETE
					dc.b	0				;OBSOLETE
InHold:			dc.b	0				;1 if in hold (screens are closed)
InErrorCmd:		dc.b	0				;1 if executing in error command
InputDevCmd:	dc.b	0				;Input device command
InputDevArg:	dc.l	0				;Argument for input device command
KeyAttach:		ds.b	LH_SIZE		;Key attachings

WBenchMsg:		dc.l	0				;Workbench message
ScanHistory:	dc.l	0				;Pointer to current history line we are
											;scanning with the arrow keys

	;Event for AddEvent
Event:			dc.l	0					;ie_NextEvent
					dc.b	IECLASS_RAWKEY	;ie_Class
					dc.b	0					;ie_SubClass
					dc.w	0					;ie_Code
					dc.w	0					;ie_Qualifier
					dc.w	0					;ie_X
					dc.w	0					;ie_Y
					ds.b	TV_SIZE			;ie_TimeStamp

LayersBase:		dc.l	0
MathDPBase:		dc.l	0

MasterPV:		dc.b	1				;If true this is the master PowerVisor

	;***
	;End of MainBase
	;***

	EVEN

	;All startup errors
StartupErrors:	dc.l	ErrorLib,ErrorScreen,ErrorMemory,ErrorFont
					dc.l	ErrorMenu,ErrorOS

	;Error messages at startup
ErrorLib:		dc.b	"Error opening library!",10,0
ErrorScreen:	dc.b	"Error opening screen/window!",10,0
ErrorMemory:	dc.b	"Not enough memory!",10,0
ErrorFont:		dc.b	"Error opening font!",10,0
ErrorMenu:		dc.b	"Error creating menus!",10,0
 IFD D20
ErrorOS:			dc.b	"This version is for AmigaDOS 2.0 only!",10,0
 ENDC
 IFND D20
ErrorOS:			dc.b	"This version is for AmigaDOS 1.2/1.3 only!",10,0
 ENDC

	;Files
 IFND D20
pvStartupFile:	dc.b	"s:PowerVisor-startup",0
pvErrorFile:	dc.b	"s:PowerVisor-errors",0
 ENDC
 IFD D20
pvStartupFile:	dc.b	"PowerVisor-startup",0
pvErrorFile:	dc.b	"PowerVisor-errors",0
 ENDC
pvConfigFile:	dc.b	"s:PowerVisor-config",0

	;Library names
DosLib:			dc.b	"dos.library",0
IntuitionLib:	dc.b	"intuition.library",0
GraphicsLib:	dc.b	"graphics.library",0
ExpansLib:		dc.b	"expansion.library",0
UtilLib:			dc.b	"utility.library",0
PVLib:			dc.b	"powervisor.library",0
DFLib:			dc.b	"diskfont.library",0
LayersLib:		dc.b	"layers.library",0
;MathDPLib:		dc.b	"mathieeedoubbas.library",0

	;Warning messages
RequestQuitBody:
					dc.b	"Debug tasks will be frozen! Continue?",0
RequestQuitGadg:
					dc.b	"Yes|No",0

	;Function names
StrARexxPort:	dc.b	"arexxport",0
StrGetX:			dc.b	"getx",0
StrGetY:			dc.b	"gety",0
StrGetActive:	dc.b	"getactive",0
StrDebug:		dc.b	"getdebug",0
StrGetChar:		dc.b	"getchar",0
StrGetLine:		dc.b	"getline",0
StrBase:			dc.b	"base",0
StrKey:			dc.b	"key",0
StrLines:		dc.b	"lines",0
StrCols:			dc.b	"cols",0
StrLastLines:	dc.b	"lastlines",0
StrLastBytes:	dc.b	"lastbytes",0
StrLastMem:		dc.b	"lastmem",0
StrLastFound:	dc.b	"lastfound",0
StrAlloc:		dc.b	"alloc",0
StrFree:			dc.b	"free",0
StrGetSize:		dc.b	"getsize",0
StrReAlloc:		dc.b	"realloc",0
StrAPeek:		dc.b	"apeek",0
StrPeek:			dc.b	"peek",0
StrRfRate:		dc.b	"rfrate",0
StrRfCmd:		dc.b	"rfcmd",0
StrIsAlloc:		dc.b	"isalloc",0
StrCurList:		dc.b	"curlist",0
StrQual:			dc.b	"qual",0
StrGetCol:		dc.b	"getcol",0
StrGetRow:		dc.b	"getrow",0
StrCurrent:		dc.b	"getlwin",0
StrStSize:		dc.b	"stsize",0
StrTagList:		dc.b	"taglist",0
StrTopPC:		dc.b	"toppc",0
StrBotPC:		dc.b	"botpc",0
StrEval:			dc.b	"eval",0
StrIf:			dc.b	"if",0
StrIsBreak:		dc.b	"isbreak",0
StrGetError:	dc.b	"geterror",0
StrGetStack:	dc.b	"getstack",0
StrPubScreen:	dc.b	"pubscreen",0
StrGetMMUEntry:dc.b	"getmmuentry",0
StrGetSymStr:	dc.b	"getsymstr",0
StrCheckSum:	dc.b	"checksum",0

	;Name of owner
OwnerName:		dc.b	"PowerVisor V1.43beta (Joe Thomas)  © Jorrit Tyberghein (Oct 94)",10,0

	EVEN
Dummy:			dc.b	"                "

CurDirPath:		dc.b	0
SPVPath:			dc.b	"s:pv/",0
SPath:			dc.b	"s:",0

 IFD D20
ProgDirPath:	dc.b	"PROGDIR:",0
 ENDC

	EVEN
	;Path to search
ScriptPath:		dc.l	CurDirPath,SPVPath,0
 IFD D20
DefPath:			dc.l	ProgDirPath,SPath,CurDirPath,0
 ENDC
 IFND D20
DefPath:			dc.l	SPath,CurDirPath,0
 ENDC

TaskMemTempl:	ds.b	LN_SIZE		;Memory list for our break task
					dc.w	me_NUMENTRIES
					dc.l	MEMF_PUBLIC+MEMF_CLEAR,TC_SIZE
					dc.l	MEMF_CLEAR,4096
TaskMemList:	dc.l	0				;Ptr to our memlist
HandlerStuff:	ds.b	IS_SIZE
InputDevice:	dc.b	"input.device",0
BreakTaskName:	dc.b	"PowerVisor.task"
BreakTaskNameEnd:	dc.b	0,0,0
InputName:		dc.b	"PowerVisor.input"
InputNameEnd:	dc.b	0,0,0

ForbidNest:		dc.b	0				;If 0, no forbid
DisableNest:	dc.b	0				;If 0, no disable

	;Message for config
UnknownEntryInConfigMes:
	dc.b	"Unrecognized entry in config file. I will try to do my best though.",0

	;Preferences
PArgHistory:	dc.b	"history",0
PArgKey:			dc.b	"key",0
PArgStack:		dc.b	"stack",0
PArgLogWin:		dc.b	"logwin",0
PArgLineLen:	dc.b	"linelen",0
PArgDebug:		dc.b	"debug",0
PArgDMode:		dc.b	"dmode",0
PArgScreen:		dc.b	"screen",0
PArgPens:		dc.b	"pens",0
PArgFont:		dc.b	"font",0

	EVEN
	;Corresponding routines
PrefsRoutines:
	DEFP	History
	DEFP	Key
	DEFP	Stack
	DEFP	LogWin
	DEFP	LineLen
	DEFP	Debug
	DEFP	DMode
	DEFP	Screen
	DEFP	Pens
	DEFP	Font
	dc.l	0,0

	;Possible arguments for the mode command
 IFD D20
MArgDefault:	dc.b	"default",0
MArgPal:			dc.b	"pal",0
MArgNtsc:		dc.b	"ntsc",0
MArgVga:			dc.b	"vga",0
MArgViking:		dc.b	"a2024",0
MArgEuro72:		dc.b	"euro72",0
MArgEuro36:		dc.b	"euro36",0
MArgSup72:		dc.b	"sup72",0
MArgSBar:		dc.b	"sbar",0
MArgSuper:		dc.b	"super",0
 ENDC
MArgFancy:		dc.b	"fancy",0
MArgLoneSpc:	dc.b	"lonespc",0
MArgSBottom:	dc.b	"sbottom",0
MArgSpace:		dc.b	"space",0
MArgSHex:		dc.b	"shex",0
MArgDec:			dc.b	"dec",0
MArgHex:			dc.b	"hex",0
MArgHexDec:		dc.b	"hexdec",0
MArgByte:		dc.b	"byte",0
MArgLong:		dc.b	"long",0
MArgWord:		dc.b	"word",0
MArgAscii:		dc.b	"ascii",0
MArgLace:		dc.b	"lace",0
MArgMore:		dc.b	"more",0
MArgAutoList:	dc.b	"auto",0
MArgFb1:			dc.b	"fb",0
MArgPatch:		dc.b	"patch",0
MArgIntui:		dc.b	"intui",0
MArgDirty:		dc.b	"dirty",0

 EVEN
	;Masks and values for each mode argument
ModeRoutines:
 IFD D20
	DEFCM	Default,Screen,0
	DEFCM	Pal,Screen,1
	DEFCM	Ntsc,Screen,2
	DEFCM	Vga,Screen,3
	DEFCM	Viking,Screen,4
	DEFCM	Euro72,Screen,5
	DEFCM	Euro36,Screen,6
	DEFCM	Sup72,Screen,7
	DEFCM	Super,Super,1
 ENDC
	DEFCM	Fancy,Fancy,1
	DEFCM	LoneSpc,LoneSpc,1
	DEFCM	SBottom,SBottom,1
	DEFCM	Space,Space,1
	DEFCM	SHex,SHex,1
	DEFCM	Hex,DispType,0
	DEFCM	Dec,DispType,1
	DEFCM	HexDec,DispType,2
	DEFCM	Lace,Lace,1
	DEFCM	More,More,1
	DEFCM	AutoList,List,1
	DEFCM	Byte,MemorySize,0
	DEFCM	Long,MemorySize,1
	DEFCM	Word,MemorySize,2
	DEFCM	Ascii,MemorySize,3
	DEFCM	Fb1,FeedBack,1
	DEFCM	Patch,Patch,1
	DEFCM	Intui,IntuiWin,1
	DEFCM	Dirty,Dirty,1
 IFD D20
	DEFCM	SBar,SBar,1
 ENDC
	dc.l	0

	;All the commands
ComActive:		dc.b	"active",0
ComAtta:			dc.b	"attc",0
ComAttach:		dc.b	"attach",0
ComAccount:		dc.b	"account",0
ComAddFunc:		dc.b	"addfunc",0
ComAddStruct:	dc.b	"addstruct",0
ComAddTag:		dc.b	"addtag",0
ComAlias:		dc.b	"alias",0
ComAssign:		dc.b	"assign",0
ComASync:		dc.b	"async",0
ComAWin:			dc.b	"awin",0
ComAppendTo:	dc.b	"appendto",0
ComBreak:		dc.b	"break",0
ComCopy:			dc.b	"copy",0
ComCrsh:			dc.b	"crsh",0
ComCls:			dc.b	"cls",0
ComCloseWindow:dc.b	"closewindow",0
ComCloseScreen:dc.b	"closescreen",0
ComCloseDev:	dc.b	"closedev",0
ComCloseLW:		dc.b	"closelw",0
ComClosePW:		dc.b	"closepw",0
ComClear:		dc.b	"clear",0
ComClearTags:	dc.b	"cleartags",0
ComClearStructs:dc.b	"clearstruct",0
ComCleanup:		dc.b	"cleanup",0
ComClip:			dc.b	"clip",0
ComCurDir:		dc.b	"curdir",0
ComConf:			dc.b	"conf",0
ComColor:		dc.b	"color",0
ComColRow:		dc.b	"colrow",0
ComCurrent:		dc.b	"current",0
ComCheckTag:	dc.b	"checktag",0
ComCrash:		dc.b	"crash",0
ComDisp:			dc.b	"disp",0
ComDevs:			dc.b	"devs",0
ComDosd:			dc.b	"dosd",0
ComDebug:		dc.b	"debug",0
ComDevCmd:		dc.b	"devcmd",0
ComDevInfo:		dc.b	"devinfo",0
ComDbug:			dc.b	"dbug",0
ComDUse:			dc.b	"duse",0
ComDRefresh:	dc.b	"drefresh",0
ComDWin:			dc.b	"dwin",0
ComDScroll:		dc.b	"dscroll",0
ComDStart:		dc.b	"dstart",0
ComDPrevI:		dc.b	"dprevi",0
ComDNextI:		dc.b	"dnexti",0
ComExec:			dc.b	"exec",0
ComError:		dc.b	"error",0
ComEvent:		dc.b	"event",0
ComFreeze:		dc.b	"freeze",0
ComFill:			dc.b	"fill",0
ComFont:			dc.b	"font",0
ComFunc:			dc.b	"func",0
ComFils:			dc.b	"fils",0
ComFDFi:			dc.b	"fdfiles",0
ComFront:		dc.b	"front",0
ComFit:			dc.b	"fit",0
ComFor:			dc.b	"for",0
ComFRegs:		dc.b	"fregs",0
ComFloat:		dc.b	"float",0
ComGadgets:		dc.b	"gadgets",0
ComGraf:			dc.b	"graf",0
ComGo:			dc.b	"go",0
ComGetString:	dc.b	"getstring",0
ComHelp:			dc.b	"help",0
ComHunks:		dc.b	"hunks",0
ComHold:			dc.b	"hold",0
ComHide:			dc.b	"hide",0
ComHome:			dc.b	"home",0
ComInfo:			dc.b	"info",0
ComIntb:			dc.b	"intb",0
ComIntr:			dc.b	"intr",0
ComIHan:			dc.b	"ihan",0
ComInterprete:	dc.b	"interprete",0
ComKill:			dc.b	"kill",0
ComLed:			dc.b	"led",0
ComLibInfo:		dc.b	"libinfo",0
ComLibFunc:		dc.b	"libfunc",0
ComList:			dc.b	"list",0
ComLList:		dc.b	"llist",0
ComLibs:			dc.b	"libs",0
ComLocate:		dc.b	"locate",0
ComLock:			dc.b	"lock",0
ComLoad:			dc.b	"load",0
ComLoadFd:		dc.b	"loadfd",0
ComLoadTags:	dc.b	"loadtags",0
ComLog:			dc.b	"log",0
ComLWin:			dc.b	"lwin",0
 IFD	D20
ComMoni:			dc.b	"moni",0
 ENDC
ComMode:			dc.b	"mode",0
ComMove:			dc.b	"move",0
ComMemTask:		dc.b	"memtask",0
ComMemory:		dc.b	"memory",0
ComMemr:			dc.b	"memr",0
ComMMUTree:		dc.b	"mmutree",0
ComMMURegs:		dc.b	"mmuregs",0
ComMMUEntry:	dc.b	"mmuentry",0
ComMMUReset:	dc.b	"mmureset",0
ComMMUWatch:	dc.b	"mmuwatch",0
ComNext:			dc.b	"next",0
ComOpenDev:		dc.b	"opendev",0
ComOpenLW:		dc.b	"openlw",0
ComOpenPW:		dc.b	"openpw",0
ComOWin:			dc.b	"owin",0
ComOwner:		dc.b	"owner",0
ComOn:			dc.b	"on",0
ComRWin:			dc.b	"rwin",0
 IFD	D20
ComPubS:			dc.b	"pubs",0
 ENDC
ComPathName:	dc.b	"pathname",0
ComPort:			dc.b	"port",0
ComPrint:		dc.b	"print",0
ComPVCall:		dc.b	"pvcall",0
ComPVMem:		dc.b	"pvmem",0
ComPWin:			dc.b	"pwin",0
ComPrefs:		dc.b	"prefs",0
ComProtect:		dc.b	"protect",0
ComProf:			dc.b	"prof",0
ComQuit:			dc.b	"quit",0
ComRefresh:		dc.b	"refresh",0
ComRemFunc:		dc.b	"remfunc",0
ComRemAttach:	dc.b	"remattach",0
ComRemCrash:	dc.b	"remcrash",0
ComRemHand:		dc.b	"remhand",0
ComRemRes:		dc.b	"remres",0
ComRemVar:		dc.b	"remvar",0
ComRemStruct:	dc.b	"remstruct",0
ComRemTag:		dc.b	"remtag",0
ComRemClip:		dc.b	"remclip",0
ComReso:			dc.b	"reso",0
ComResm:			dc.b	"resm",0
ComRegs:			dc.b	"regs",0
ComResident:	dc.b	"resident",0
ComRemove:		dc.b	"remove",0
ComRBlock:		dc.b	"rblock",0
ComRx:			dc.b	"rx",0
ComRequest:		dc.b	"request",0
ComReqLoad:		dc.b	"reqload",0
ComReqSave:		dc.b	"reqsave",0
ComSetFlags:	dc.b	"setflags",0
ComSearch:		dc.b	"search",0
ComScript:		dc.b	"script",0
ComSave:			dc.b	"save",0
ComScrs:			dc.b	"scrs",0
ComSema:			dc.b	"sema",0
ComScreen:		dc.b	"screen",0
ComSize:			dc.b	"size",0
ComSymbol:		dc.b	"symbol",0
ComStru:			dc.b	"stru",0
ComShowAlloc:	dc.b	"showalloc",0
ComSetFont:		dc.b	"setfont",0
ComSpecRegs:	dc.b	"specregs",0
ComSPoke:		dc.b	"spoke",0
ComSPeek:		dc.b	"speek",0
ComSPrint:		dc.b	"sprint",0
ComSync:			dc.b	"sync",0
ComSaveTags:	dc.b	"savetags",0
ComSaveConfig:	dc.b	"saveconfig",0
ComScan:			dc.b	"scan",0
ComScroll:		dc.b	"scroll",0
ComStack:		dc.b	"stack",0
ComString:		dc.b	"string",0
ComSource:		dc.b	"source",0
ComSWin:			dc.b	"swin",0
ComStruct:		dc.b	"struct",0
ComTask:			dc.b	"task",0
ComTaskPri:		dc.b	"taskpri",0
ComTrace:		dc.b	"trace",0
ComTags:			dc.b	"tags",0
ComTg:			dc.b	"tg",0
ComTo:			dc.b	"to",0
ComTrack:		dc.b	"track",0
ComTagType:		dc.b	"tagtype",0
ComUnAsm:		dc.b	"unasm",0
ComUnLoadFd:	dc.b	"unloadfd",0
ComUnFreeze:	dc.b	"unfreeze",0
ComUnLock:		dc.b	"unlock",0
ComUnHide:		dc.b	"unhide",0
ComUnAlias:		dc.b	"unalias",0
ComUnResident:	dc.b	"unresident",0
ComUseTag:		dc.b	"usetag",0
ComVoid:			dc.b	"void",0
ComVars:			dc.b	"vars",0
ComView:			dc.b	"view",0
ComWins:			dc.b	"wins",0
ComWBlock:		dc.b	"wblock",0
ComWith:			dc.b	"with",0
ComWhile:		dc.b	"while",0
ComWatch:		dc.b	"watch",0
ComWWin:			dc.b	"wwin",0
ComXWin:			dc.b	"xwin",0
	EVEN

RexxCommandList:
	AFUNS	ARexxPort
	AFUN	If
	AFUN	IsBreak
	AFUN	GetX
	AFUN	GetY
	AFUN	GetActive
	AFUN	Debug
	AFUN	GetChar
	AFUN	GetLine
	AFUN	GetError
	AFUN	Base
	AFUN	Key
	AFUN	Lines
	AFUN	Cols
	AFUN	LastLines
	AFUN	LastBytes
	AFUN	LastMem
	AFUN	LastFound
	AFUN	Alloc
	AFUN	Free
	AFUN	GetSize
	AFUN	ReAlloc
	AFUN	APeek
	AFUN	Peek
	AFUN	RfRate
	AFUNS	RfCmd
	AFUN	IsAlloc
	AFUNS	CurList
	AFUN	Qual
	AFUN	GetCol
	AFUN	GetRow
	AFUN	Current
	AFUN	StSize
	AFUN	TagList
	AFUN	BotPC
	AFUN	TopPC
	AFUN	Eval
	AFUN	GetStack
	AFUNS	PubScreen
	AFUN	GetMMUEntry
	AFUNS	GetSymStr
	AFUN	CheckSum
RealCommands:
	ADEF	Active
	ADEF	Account
	ADEF	AddFunc
	ADEF	AddStruct
	ADEF	AddTag
	ADEF	Alias
	ADEF	Break
	ADEF	Assign
	ADEF	ASync
	ADEF	Atta				;Important order
	ADEF	Attach			;Important order
	ADEF	AWin
	ADEF	AppendTo
	ADEF	Copy
	ADEF	Crsh
	ADEF	Cls
	ADEF	CloseWindow
	ADEF	CloseScreen
	ADEF	CloseDev
	ADEF	CloseLW
	ADEF	ClosePW
	ADEF	Clear				;Important order
	ADEF	ClearStructs	;Important order
	ADEF	ClearTags		;Important order
	ADEF	Cleanup
	ADEF	Clip
	ADEF	CurDir
	ADEF	Conf
	ADEF	Color
	ADEF	ColRow
	ADEF	Current
	ADEF	CheckTag
	ADEF	Crash
	ADEF	Disp
	ADEF	Devs
	ADEF	Dosd
	ADEF	Debug
	ADEF	DevCmd
	ADEF	DevInfo
	ADEF	Dbug
	ADEF	DUse
	ADEF	DRefresh
	ADEF	DWin
	ADEF	DScroll
	ADEF	DStart
	ADEF	DPrevI
	ADEF	DNextI
	ADEF	Exec
	ADEFS	Error
	ADEF	Event
	ADEF	Fill
	ADEF	Fils
	ADEF	Font
	ADEF	For
	ADEF	Func
	ADEF	FDFi
	ADEF	Freeze
	ADEF	Front
	ADEF	Fit
	ADEF	FRegs
	ADEF	Float
	ADEF	Gadgets
	ADEF	Graf
	ADEF	Go
	ADEFS	GetString
	ADEF	Help
	ADEF	Hunks
	ADEF	Hold
	ADEF	Hide
	ADEF	Home
	ADEF	Info
	ADEF	Intb
	ADEF	Intr
	ADEF	IHan
	ADEF	Interprete
	ADEF	Kill
	ADEF	List
	ADEF	LList
	ADEF	Libs
	ADEF	Lock
	ADEF	Locate
	ADEF	LibInfo
	ADEF	Led
	ADEF	Load				;Important order
	ADEF	LoadFd			;Important order
	ADEF	LoadTags			;Important order
	ADEF	Log
	ADEF	LWin
	ADEFS	LibFunc
	ADEF	Memory
	ADEF	Mode
	ADEF	Move
	ADEF	MemTask
	ADEF	Memr
	ADEF	MMUTree
	ADEF	MMURegs
	ADEF	MMUReset
	ADEF	MMUEntry
	ADEF	MMUWatch
 IFD	D20
	ADEF	Moni
 ENDC
	ADEF	Next
	ADEF	OpenDev
	ADEF	OpenLW
	ADEF	OpenPW
	ADEF	OWin
	ADEF	Owner
	ADEF	On
	ADEF	Port
 IFD	D20
	ADEF	PubS
 ENDC
	ADEF	Print
	ADEFS	PathName
	ADEF	PVCall
	ADEF	PVMem
	ADEF	PWin
	ADEF	Prefs
	ADEF	Protect
	ADEF	Prof
	ADEF	Quit
	ADEF	Refresh
	ADEF	RemFunc
	ADEF	RemAttach
	ADEF	RemCrash
	ADEF	RemVar
	ADEF	Resm
	ADEF	Reso
	ADEF	Regs
	ADEF	RemRes
	ADEF	RemHand
	ADEF	RemTag
	ADEF	Remove
	ADEF	RemStruct
	ADEF	RemClip
	ADEF	Resident
	ADEF	Request
	ADEFS	ReqLoad
	ADEFS	ReqSave
	ADEF	RBlock
	ADEF	RWin
	ADEF	Rx
	ADEF	Search
	ADEF	Scrs
	ADEF	Script
	ADEF	Sema
	ADEF	Screen
	ADEF	Size
	ADEF	Save
	ADEF	SaveTags
	ADEF	SaveConfig
	ADEF	Symbol
	ADEF	Stru
	ADEF	ShowAlloc
	ADEF	SetFont
	ADEF	SpecRegs
	ADEF	SPoke
	ADEF	SPeek
	ADEF	SPrint
	ADEF	SetFlags
	ADEFS	Scan
	ADEF	Scroll
	ADEF	Stack
	ADEFS	String
	ADEF	Sync
	ADEF	Source
	ADEF	SWin
	ADEF	Struct
	ADEF	Task
	ADEF	TaskPri
	ADEF	Trace
	ADEF	Tags
	ADEF	Tg
	ADEF	To
	ADEF	Track
	ADEF	TagType
	ADEF	UnAsm
	ADEF	UnLoadFd
	ADEF	UnFreeze
	ADEF	UnLock
	ADEF	UnAlias
	ADEF	UnResident
	ADEF	UseTag
	ADEF	UnHide
	ADEF	Void
	ADEF	Vars
	ADEF	View
	ADEF	Wins
	ADEF	Watch
	ADEF	WBlock
	ADEF	With
	ADEF	While
	ADEF	WWin
	ADEF	XWin

	dc.l	0,0,0

FormatAlias:
		FF		ls_,15,str_,":",ls,60,nlend,0

		EVEN
Storage:			dc.l	0				;Working Storage

	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLongNNLFormat:
					dc.b	"%08lx ",0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	END
