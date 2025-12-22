*****
****
***			S C R E E N   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Thu Mar 24 21:06:39 1994
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

			INCLUDE	"pv.screen.i"
			INCLUDE	"pv.debug.i"
			INCLUDE	"pv.eval.i"
			INCLUDE	"TileWindows.i"

			INCLUDE	"pv.lib.i"
			INCLUDE	"pv.errors.i"

	XDEF		ScreenConstructor,ScreenDestructor
	XDEF		RoutSize,RoutScreen,RoutCls,CloseScreen
	XDEF		RoutLocate,RoutPrint,RoutDisp,FuncGetX,FuncGetY,FuncGetChar,FuncKey
	XDEF		FuncLines,FuncCols,PrintPrompt,BusyPrompt,Scan,PrintLine
	XDEF		Line,MyScreen,NewLine,PrintCold
	XDEF		RefreshGadget
	XDEF		PrintAC,NoIDC
	XDEF		Print,PrintHex,DoFeedBack,MsgPrint
	XDEF		RoutColor,FuncQual,MainPW,MainLW,RefreshLW,CurrentLW
	XDEF		RoutSetFont,ReOpenScreen,FuncPubScreen
	XDEF		SetLogWinFlags,LogWin_HiLight
	XDEF		RoutColRow,FuncGetCol,FuncGetRow
	XDEF		OpenDebugWindow,CloseDebugWindow
	XDEF		RoutCurrent,FuncCurrent
	XDEF		SourceLW,DebugLW,ClosePW,WatchLW
	XDEF		RoutRWin,RoutXWin,RoutDWin,RoutSWin
	XDEF		RoutFit,PrintChar,RequestIt
	XDEF		PrintRealHex,PrintRealHexNL
	XDEF		HideCurrent,UnHideCurrent
	XDEF		RoutOn,RoutScan,PVScreen
	XDEF		RoutHome,SpecialPrint
	XDEF		RoutLWPrefs,MainEntry,DefLineLen
	XDEF		DontClearLine,GadCursorPos,SetCursor,mStringInfo,SnapBuffer
	XDEF		SnapCommand,ScreenBase,mStringGad
	XDEF		WindowGadgetPort,SoftNewLine,myGlobal
	XDEF		RoutOpenLW,RoutCloseLW,RoutOpenPW,RoutClosePW
	XDEF		RoutAWin,RoutOWin,RexxLW,RoutSetFlags,RoutWWin
	XDEF		UpdateSBottom,RoutMove,RoutActive,FuncGetActive,ExtraShare
	XDEF		SpecialFlags,StartupX,ScreenW,NoFancyPens,FancyPens,RoutScroll
	XDEF		LockWin,LockState,TopazName,TextAttrib
	XDEF		RoutGetString,RoutRequest,RoutReqLoad,RoutReqSave
	XDEF		LogWin_SetWindowTitle,ScanStanLogWin
	XDEF		UpdatePrefs,FuncGetLine
	XDEF		ActivateGadget,SBarMode
	IFD D20
	XDEF		LogWin_SetSBarValue
	ENDC

	XDEF		PhysWin_ActivateWindow

	XDEF		LogWin_StartPage,LogWin_Print,LogWin_PrintChar,LogWin_Reprint
	XDEF		LogWin_Locate,LogWin_Home,LogWin_Clear,LogWin_SetFlags
	XDEF		LogWin_AttachFile
	XDEF		LogWin_Refresh,LogWin_GetWord,LogWin_Attribute
 IFD D20
	XDEF		TestForClose,Global_CleanBoxes
 ENDC

	;memory
	XREF		FreeBlock,AllocClear,VPrint,VirtualPrint
	XREF		StoreRC,AllocStringInt,ViewPrintLine
	XREF		ClearAutoClear,AddString,ReAllocMem,AllocBlockInt
	XREF		AllocMem,FreeMem,ReAlloc
	;main
	XREF		Gfxbase,IntBase,RoutHold2,AddHistory,InHold
	XREF		RefreshSet,SpeedRefresh,CountRefresh,RefreshCmd,ExecAlias
	XREF		CheckPause,CheckBreak,DosBase,PVBase,LMult,LDiv,DFBase
	XREF		Remind,IDevSigSet,EndProg,PVBreakSigSet,ClearBreakSig
	XREF		InputDevCmd,InputDevArg,ErrorHandler,ClearBreak,HoldSigSet
	XREF		Forbid,Permit,Disable,Enable,LastError,CheckModeBit
	XREF		GetError,SetError,ResetHistory,SPrintf,Storage
	XREF		InputRequestB,CopyFileName,LayersBase,CreatePort,DeletePort
	;general
	XREF		CrashSigBit,Port,CrashSignal,DumpRegsNL
	XREF		TimerSignal,CheckTimer,TrackAlloc,TrackFree,PortNameEnd
	;eval
	XREF		GetStringE,GetString,LongToHex,LongToDec,SkipSpace
	XREF		RedirHappen,RedirAddress,GetRestLinePer,CompareCI,Upper
	XREF		StoreInput,GetInputVar,VarStorage
	;list
	XREF		Prompt,ListCurrent,SetList,ResetList
	;file
	XREF		FOpen,FClose,FReadLine
	;debug
	XREF		TraceSigSet,DebugList,PrintInfoTR,SkipStackFrame,CurrentDebug
	XREF		ScrollDebug,PCScrollDebug,GotoSourceLine,RoutDNextI,RoutDPrevI
	XREF		GotoSourceLineNoSBar,UpdateDisplay,SetAdditional
	IFD D20
	XREF		UpdateSourceSBar
	ENDC
	;arexx
	XREF		CheckRexx,RexxBit,InSync
	;mmu
	XREF		DumpBERRs



;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

	;IDCMPflags for the window
 IFD D20
IDCMPFLAGS		equ	MOUSEMOVE+MOUSEBUTTONS+CHANGEWINDOW+VANILLAKEY+INTUITICKS+GADGETDOWN+GADGETUP+MENUPICK
IDCMPFLAGS2		equ	MOUSEMOVE+MOUSEBUTTONS+CHANGEWINDOW+VANILLAKEY+INTUITICKS+GADGETDOWN+GADGETUP+MENUPICK
DEFAULTFLAGS	equ	NOCAREREFRESH+BACKDROP+BORDERLESS+ACTIVATE
DEFAULTFLAGS2	equ	NOCAREREFRESH+WINDOWDRAG+WINDOWDEPTH+WINDOWSIZING
 ENDC
 IFND D20
IDCMPFLAGS		equ	MOUSEMOVE+MOUSEBUTTONS+NEWSIZE+VANILLAKEY+INTUITICKS+GADGETDOWN+GADGETUP
IDCMPFLAGS2		equ	MOUSEMOVE+MOUSEBUTTONS+NEWSIZE+VANILLAKEY+INTUITICKS
DEFAULTFLAGS	equ	NOCAREREFRESH+RMBTRAP+BACKDROP+BORDERLESS+ACTIVATE
DEFAULTFLAGS2	equ	NOCAREREFRESH+RMBTRAP+WINDOWDRAG+WINDOWDEPTH+WINDOWSIZING
 ENDC

	;Dimensions for stringgadget
LEFTSTRGAD		equ	8
	;Right for stringgadget
RIGHTSTRGAD		equ	0

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Constructor: initialize everything for screen input/output
	;-> d0 = 0 if no error (flags)
	;			ErrorCode if error (ERROR_xxx)
	;***
ScreenConstructor:
	IFD	D20
		lea		(PubScreenTEnd,pc),a0
		lea		(PortNameEnd),a1
		move.b	(a1)+,d0
		move.b	d0,(a0)+
		move.b	(a1),(a0)
	ENDC
	IFND	D20
		lea		(PortNameEnd),a1
		move.b	(a1)+,d0
	ENDC
		cmp.b		#'.',d0
		bne.b		10$
		lea		(ScreenTitleS,pc),a0
		move.b	#'[',(a0)+
		move.b	(a1),(a0)+
		move.b	#']',(a0)

	;Remember old window pointer
10$	movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0
		lea		(OldWinPtr,pc),a1
		move.l	(pr_WindowPtr,a0),(a1)

	;Allocate port
		bsr		CreatePort
		tst.l		d0
		bne.b		11$
		moveq		#ERROR_MEMORY,d0
		rts
	;Success
11$	lea		(WinPort,pc),a0
		move.l	d0,(a0)

	;Open Reqtools.library
		lea		(ReqToolsLib,pc),a1
		moveq		#37,d0
		CALLEXEC	OpenLibrary
		lea		(ReqBase,pc),a0
		move.l	d0,(a0)
		beq.b		2$
	;Allocate a filerequest
		moveq		#0,d0					;RT_FILEREQ
		suba.l	a0,a0					;Tags
		CALLREQ	rtAllocRequestA
		lea		(ReqStruct,pc),a0
		move.l	d0,(a0)
		bne.b		2$
	;Error
3$		moveq		#ERROR_MEMORY,d0
		rts
2$
 IFD D20
		lea		(GadToolsLib,pc),a1
		CALLEXEC	OldOpenLibrary
		lea		(GTBase,pc),a0
		move.l	d0,(a0)
 ENDC

 IFD D20
	;Allocate WorkBuffer for hook function
		moveq		#0,d0
		move.w	(DefLineLen,pc),d0
		bsr		AllocClear
		beq.b		3$
		lea		(SExtend+sex_WorkBuffer,pc),a0
		move.l	d0,(a0)
 ENDC

	;Allocate snap buffer
		moveq		#120,d0
		bsr		AllocClear
		beq.b		3$
		lea		(SnapBuffer,pc),a0
		move.l	d0,(a0)

	;Allocate stringgadget buffer
		moveq		#0,d0
		move.w	(DefLineLen,pc),d0
		addq.l	#8,d0					;Space for two spaces and -1
		bsr		AllocClear
		beq.b		3$
		movea.l	d0,a0
		move.w	#'  ',(a0)+			;Dummy two spaces
		lea		(Line,pc),a1
		move.l	a0,(a1)
		moveq		#0,d0
		move.w	(DefLineLen,pc),d0
		adda.l	d0,a0
		moveq		#-1,d0
		move.b	d0,(a0)+
		move.b	d0,(a0)+
		move.b	d0,(a0)+
		move.b	d0,(a0)+

	;Make global
		bsr		Global_Constructor
		beq.b		3$
		lea		(myGlobal,pc),a0
		move.l	d0,(a0)
	;Compute Global signal
		movea.l	d0,a0
		movea.l	(WinPort,pc),a1
		moveq		#0,d1
		move.b	(MP_SIGBIT,a1),d1
		moveq		#1,d0
		lsl.l		d1,d0
		move.l	d0,(Global_SigSet,a0)

		lea		(TextAttrib,pc),a0
		bsr		OpenFont
		lea		(TopazFont,pc),a0
		move.l	d0,(a0)
		bne.b		4$
		moveq		#ERROR_FONT,d0
		rts

	;Font success, adjust some variables in the system to the font size
4$		movea.l	d0,a0
		move.w	(tf_YSize,a0),d0
		lea		(FontHeight,pc),a0
		move.w	d0,(a0)
		addq.w	#3,d0
		lea		(TopBorder,pc),a0
		move.w	d0,(a0)
	;Adjust ScrollBoxes
		lea		(ScrollBoxes,pc),a0
		subq.w	#4,d0					;YSize-1
		moveq		#63,d1				;Loop 64 times

8$		moveq		#0,d2
		move.b	(a0),d2				;x or y
		mulu.w	d0,d2
		divu.w	#7,d2
		move.b	d2,(a0)+
		dbra		d1,8$

	;Adjust tolerancy figures
		move.w	(FontHeight,pc),d0
		addq.w	#7,d0
		lea		(SizeTolX,pc),a0
		move.w	d0,(a0)
		addq.w	#5,d0
		lea		(SizeTolY,pc),a0
		move.w	d0,(a0)
		subi.w	#11,d0
		lea		(DragTolY2,pc),a0
		move.w	d0,(a0)
 IFD D20
 		lea		(SExtend,pc),a0
		move.l	(TopazFont,pc),(a0)
 ENDC

 IFND D20
		lea		(MyNScreen,pc),a0
		move.w	#$000f,(ns_Type,a0)
 ENDC

		bsr		FirstOpenScreen
		bne.b		6$
9$		moveq		#ERROR_SCREEN,d0
		rts

6$
 IFD D20
 		move.l	d0,-(a7)
		bsr		InstallMenus
		movea.l	(a7)+,a1
		tst.l		d0
		bne.b		5$
		moveq		#ERROR_MENU,d0
		rts
 ENDC
 IFND D20
		movea.l	d0,a1
 ENDC

5$		bsr		FirstOpenWindow
		beq.b		9$

	;Success
7$		moveq		#0,d0
		rts

	;***
	;Destructor: clean everything for screen
	;***
ScreenDestructor:
*		bsr		FreeInput

	;Restore window pointer
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0
		move.l	(OldWinPtr,pc),(pr_WindowPtr,a0)

*	;Free snap command
*		move.l	(SnapCommand,pc),d0
*		beq.b		4$
*		movea.l	d0,a0
*		bsr		FreeBlock

*	;Free line
*4$		move.l	(Line,pc),d0
*		beq.b		3$
*		subq.l	#2,d0					;Go back to two spaces in front of line
*		movea.l	d0,a1
*		moveq		#0,d0
*		move.w	(DefLineLen,pc),d0
*		addq.l	#8,d0					;Space for two spaces and -1
*		bsr		FreeMem

*	;Free snapbuffer
*3$		move.l	(SnapBuffer,pc),d0
*		beq.b		7$
*		movea.l	d0,a1
*		moveq		#120,d0
*		bsr		FreeMem

	;Close font
7$		move.l	(TopazFont,pc),d0
		beq.b		2$
		movea.l	d0,a1
		CALLGRAF	CloseFont
2$		movea.l	(myGlobal,pc),a0
		bsr		Global_Destructor
 IFD D20
		bsr		FreeMenus
 ENDC
		bsr		CloseScreen

		move.l	(ReqBase,pc),d0
		beq.b		5$
	;Free filerequester first
		movea.l	(ReqStruct,pc),a1
		CALLREQ	rtFreeRequest

		movea.l	a6,a1
		CALLEXEC	CloseLibrary
5$
 IFD D20
		move.l	(GTBase,pc),d0
		beq.b		6$
		movea.l	d0,a1
		CALLEXEC	CloseLibrary

6$
*		move.l	(SExtend+sex_WorkBuffer,pc),d0
*		beq.b		1$
*		movea.l	d0,a1
*		moveq		#0,d0
*		move.w	(DefLineLen,pc),d0
*		bsr		FreeMem

 ENDC

	;Free port
1$		move.l	(WinPort,pc),d0
		beq.b		8$
		movea.l	d0,a1
		bsr		DeletePort

8$		rts

	;***
	;Close all PW's
	;***
ClosePW:
		movea.l	(myGlobal,pc),a0
		bra		Global_Close

	;***
	;ReOpen all PW's
	;***
OpenPW:
		movea.l	(myGlobal,pc),a0
		bsr		GetScreen
		movea.l	d0,a1					;Screen
		bsr		Global_Open
		beq.b		1$

	;Set window pointer
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0
		movea.l	(MainPW,pc),a1
		move.l	(PhysWin_Window,a1),(pr_WindowPtr,a0)
		moveq		#1,d0					;Success

1$		rts

 IFD D20
	;***
	;Get visual info
	;***
GetVisualInfo:
		move.l	d0,-(a7)
		bsr		FreeVisualInfo
		bsr		GetScreen
		movea.l	d0,a0					;Screen
		suba.l	a1,a1					;Tags

		CALLGT	GetVisualInfoA
		lea		(VisualInfo,pc),a0
		move.l	d0,(a0)
		move.l	(a7)+,d0
		rts

	;***
	;Free visual info
	;***
FreeVisualInfo:
		move.l	(VisualInfo,pc),d0
		beq.b		1$
		movea.l	d0,a0
		CALLGT	FreeVisualInfo
		lea		(VisualInfo,pc),a0
		clr.l		(a0)
1$		rts
 ENDC

	;***
	;Get the pointer to the screen PowerVisor uses
	;This function returns 0 if PowerVisor is in hold mode
	;-> d0 = screen
	;***
GetScreen:
		move.b	(InHold),d0
		beq.b		2$
		moveq		#0,d0
		rts

2$		move.l	(MyScreen,pc),d0
		bne.b		1$
		move.l	(PVScreen,pc),d0
1$		rts

	;***
	;First open screen
	;-> flags is eq if error
	;-> d0 = screen
	;***
FirstOpenScreen:
 IFD D20
		bsr.b		4$
		beq.b		5$
	;No error
		bsr		GetVisualInfo
		tst.l		d0

5$		rts
 ENDC
4$		move.l	(SpecialFlags,pc),d0
		btst		#0,d0
		beq.b		OpenScreen
	;Open on workbench screen
		moveq		#0,d0
		CALLINT	LockIBase
		move.l	d0,-(a7)
	;Scan list
		move.l	(ib_FirstScreen,a6),d0
1$		movea.l	d0,a0
		move.w	(sc_Flags,a0),d0
		andi.w	#SCREENTYPE,d0
		cmpi.w	#WBENCHSCREEN,d0
		beq.b		2$
		move.l	(sc_NextScreen,a0),d0
		bne.b		1$
	;We have not found the workbench !
	;Simply open our own screen
3$		movea.l	(a7)+,a0
		CALL		UnlockIBase
		bra.b		OpenScreen
	;We have found the workbench
	;a0 = screen
2$		lea		(PVScreen,pc),a1
		move.l	a0,(a1)
		bra.b		3$

	;***
	;Open screen
	;-> flags is eq if error
	;-> d0 = screen
	;***
OpenScreen:
		move.l	(PVScreen,pc),d0
		beq.b		OwnScreenOW
	;We open PowerVisor on other screen
		lea		(FancyPens,pc),a0
		lea		(Pens,pc),a1
		move.l	a0,(a1)
		lea		(MyScreen,pc),a0
		clr.l		(a0)
		move.l	(PVScreen,pc),d0	;Sets flags
		rts

 IFD D20
OwnScreenOW:
		lea		(MyNScreen,pc),a0
		bsr		RightID
		move.w	(ScreenW,pc),(ns_Width,a0)
		move.w	(ScreenH,pc),(ns_Height,a0)
		move.w	#1,(ns_Depth,a0)
		lea		(NoFancyPens,pc),a1
		lea		(Pens,pc),a6
		move.l	a1,(a6)
		moveq		#mo_Fancy,d0
		bsr		CheckModeBit
		beq.b		1$
		move.w	#2,(ns_Depth,a0)
		lea		(FancyPens,pc),a1
		move.l	a1,(a6)
1$		CALLINT	OpenScreen
		lea		(MyScreen,pc),a0
		move.l	d0,(a0)
		beq.b		2$
	;Register our screen as a public screen
		move.l	d0,-(a7)
		movea.l	d0,a0
		moveq		#0,d0
		CALLINT	PubScreenStatus
		move.l	(a7)+,d0
2$		rts
 ENDC

 IFND	D20
OwnScreenOW:
		movea.l	(Gfxbase),a6
		move.w	(ScreenW,pc),d0
		cmpi.w	#-1,d0
		bne.b		1$
		move.w	(gb_NormalDisplayColumns,a6),d0
1$		lea		(MyNScreen,pc),a0
		move.w	d0,(ns_Width,a0)
		bsr		RightID
		movea.l	(Gfxbase),a6
		move.w	(ScreenH,pc),(ns_Height,a0)
		cmpi.w	#-1,(ns_Height,a0)
		bne.b		2$
		move.w	(gb_NormalDisplayRows,a6),(ns_Height,a0)
2$		moveq		#mo_Lace,d0
		bsr		CheckModeBit
		beq.b		NoLaceOW
	;Lace
		move.w	(gb_NormalDisplayRows,a6),d0
		lsl.w		#1,d0					;Double height for interlace
		move.w	d0,(ns_Height,a0)
NoLaceOW:
		move.w	#1,(ns_Depth,a0)
		lea		(NoFancyPens,pc),a1
		lea		(Pens,pc),a6
		move.l	a1,(a6)
		moveq		#mo_Fancy,d0
		bsr		CheckModeBit
		beq.b		1$
		move.w	#2,(ns_Depth,a0)
		lea		(FancyPens,pc),a1
		move.l	a1,(a6)
1$		CALLINT	OpenScreen
		lea		(MyScreen,pc),a0
		move.l	d0,(a0)
		rts
 ENDC

	;***
	;First open window
	;a1 = screen
	;-> flags is eq if error
	;-> flags if error
	;***
FirstOpenWindow:
		move.l	(PVScreen,pc),d0
		bne.b		1$

		move.l	#DEFAULTFLAGS,d4
		move.l	(SpecialFlags,pc),d0
		btst		#1,d0
		beq.b		OpenWindow
	;Open on seperate window with size 640 200
1$		move.l	#DEFAULTFLAGS2|ACTIVATE,d4

	;***
	;Open main window
	;d4 = flags for window
	;a1 = screen
	;-> flags if error
	;***
OpenWindow:
		move.l	a1,-(a7)				;Remember screen
		move.w	(StartupX,pc),d0
		move.w	(StartupY,pc),d1
		move.w	(StartupW,pc),d2
		move.w	(StartupH,pc),d3
		move.l	#IDCMPFLAGS,d5
		movea.l	(myGlobal,pc),a0
		lea		(MainName,pc),a2
		bsr		TestSBottom
		beq.b		3$
		ori.l		#SIZEBBOTTOM,d4
3$		bsr		PhysWin_Constructor
		movea.l	(a7)+,a1				;Restore screen
		lea		(MainPW,pc),a0
		move.l	d0,(a0)
		beq.b		5$
		movea.l	d0,a0
		bsr		PhysWin_Open		;Open on screen 'a1'
		bne.b		2$

	;No success
1$		movea.l	(MainPW,pc),a0
		bsr		PhysWin_Destructor
		lea		(MainPW,pc),a0
		clr.l		(a0)
5$		rts

	;Success
2$		bsr		ComputeGadgetSizes
		movea.l	(PhysWin_Box,a0),a2
		moveq		#0,d0
		move.l	d0,d1
		move.l	d0,d2
		move.w	(FontHeight,pc),d3
		addq.w	#1,d3
		bsr		PhysWin_SetBoxOffsets
		movea.l	a2,a0
		bsr		Box_FullSize
		movea.l	(MainPW,pc),a0
		moveq		#-1,d0
		move.l	d0,d1
		lea		(MainName,pc),a1
		bsr		LogWin_Constructor
		beq.b		1$
		lea		(MainLW,pc),a0
		move.l	d0,(a0)

		movea.l	(MainPW,pc),a0
	IFD D20
		bsr		PhysWin_InitScrollBars
	ENDC
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets

	;DEBUG!
		lea		(MainEntry,pc),a1
		movea.l	(MainLW,pc),a0
		move.l	a1,(LogWin_UserData,a0)
		bsr		UseEntrySize
		beq.b		1$

		bsr		SetLogWinFlags
		lea		(CurrentLW,pc),a0
		move.l	(MainLW,pc),(a0)

;		bsr		WindowGadgetPort
;		beq.b		4$

		movea.l	(myGlobal,pc),a0
		movea.l	(MainLW,pc),a1
		bsr		Global_ActivateLogWin

	;Set window pointer
		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0
		movea.l	(MainPW,pc),a1
		move.l	(PhysWin_Window,a1),(pr_WindowPtr,a0)

		moveq		#1,d0					;Success
4$		rts

	;***
	;Test the SBottomMode flag
	;-> Z flag is set if SBottomMode not set
	;***
TestSBottom:
		move.l	d0,-(a7)
		moveq		#mo_SBottom,d0
		bsr		CheckModeBit
		movem.l	(a7)+,d0				;For flags
		rts

	;***
	;Attach stringgadget
	;***
WindowGadgetPort:
		bsr		RemoveGadget
		bsr		ComputeGadgetSizes
		bsr		AddGadget
		moveq		#1,d0
		rts

	;***
	;Compute gadget sizes
	;-> preserves a0
	;***
ComputeGadgetSizes:
		movem.l	a0/a2,-(a7)

 IFD D20
		lea		(SExtend+sex_Pens,pc),a0
		GETPEN	SGInActiveTextPen,(a0)+,a2
		GETPEN	SGInActiveBackPen,(a0)+,a2
		GETPEN	SGActiveTextPen,(a0)+,a2
		GETPEN	SGActiveBackPen,(a0)+,a2
 ENDC

	;Attach stringgadget to the window
		move.l	(MainPW,pc),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0

		lea		(mStringInfo,pc),a6
		move.l	(Line,pc),(a6)

		move.w	(FontHeight,pc),d0
		neg.w		d0						;d0 = offset from bottom

	;TopEdge
		lea		(mStringGad,pc),a1
		moveq		#0,d1
		move.b	(wd_BorderBottom,a0),d1
		sub.w		d1,d0					;Compute strgadget offset
		move.w	d0,(gg_TopEdge,a1)

	;LeftEdge
		movea.l	(TopazFont,pc),a2
		moveq		#0,d0
		move.w	(tf_XSize,a2),d0
		mulu.w	#6,d0
		add.w		(LeftStrGad,pc),d0
		move.b	(wd_BorderLeft,a0),d1
		add.w		d1,d0
		move.w	d0,(gg_LeftEdge,a1)

	;Width
		add.w		(RightStrGad,pc),d0
		neg.w		d0
		move.b	(wd_BorderRight,a0),d1
		sub.w		d1,d0					;Compute strgadget width
		move.w	d0,(gg_Width,a1)

	;Height
		move.w	(tf_YSize,a2),d0
		addq.w	#1,d0
		move.w	d0,(gg_Height,a1)

	;The gadget is ready
		clr.l		(gg_UserData,a1)

1$		movem.l	(a7)+,a0/a2
		rts

	;***
	;Set logical window flags according to PowerVisor settings
	;***
SetLogWinFlags:
		movem.l	d0-d1/a0-a1,-(a7)
		move.l	(MainLW,pc),d0
		beq.b		2$
		movea.l	d0,a0
		moveq		#0,d0					;Disable
		move.w	#LWF_MORE,d1
		move.l	d0,-(a7)
		moveq		#mo_More,d0
		bsr		CheckModeBit
		movem.l	(a7)+,d0				;For flags
		beq.b		1$
	;We have ---MORE---
		move.w	d1,d0					;Enable
1$		bsr		LogWin_SetFlags
2$		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Make ID in NewScreen right
	;a0 = ptr to newscreen
	;***
 IFD D20
RightID:
		movem.l	a1-a2/d0,-(a7)
		move.w	#$8000,(ns_ViewModes,a0)

		movea.l	(VarStorage),a1
		move.l	(VOFFS_MODE,a1),d0
		move.b	d0,d1
		lsr.b		#1,d1					;Shift mo_Lace and mo_Super one right
		andi.b	#%00011000,d1		;Remove other bits
		lsr.w		#mo_Screen-8,d0
		lsr.w		#8,d0
		andi.b	#mof_Screen,d0
		add.b		d1,d0
		ext.w		d0
		lsl.w		#2,d0					;d0 = offset in ScreenID table
		lea		(ScreenIDs,pc),a1
		move.l	(0,a1,d0.w),d0
		lea		(ScreenID,pc),a1
		move.l	d0,(a1)

		moveq		#mo_Lace,d0
		bsr		CheckModeBit
		beq.b		4$
	;Lace
		move.w	#$8004,(ns_ViewModes,a0)
4$		movem.l	(a7)+,a1-a2/d0
		rts

ScreenIDs:
	;NoLace NoSuper
		dc.l		DEFAULT_MONITOR_ID|HIRES_KEY
		dc.l		PAL_MONITOR_ID|HIRES_KEY
		dc.l		NTSC_MONITOR_ID|HIRES_KEY
		dc.l		VGA_MONITOR_ID|VGAPRODUCT_KEY
		dc.l		A2024_MONITOR_ID
		dc.l		$00061000|$00008024				;Euro72
		dc.l		$00071000|HIRES_KEY				;Euro36
		dc.l		$00081000|HIRES_KEY				;Super72
	;Lace NoSuper
		dc.l		DEFAULT_MONITOR_ID|HIRESLACE_KEY
		dc.l		PAL_MONITOR_ID|HIRESLACE_KEY
		dc.l		NTSC_MONITOR_ID|HIRESLACE_KEY
		dc.l		VGA_MONITOR_ID|VGAPRODUCTLACE_KEY
		dc.l		A2024_MONITOR_ID|A2024FIFTEENHERTZ_KEY
		dc.l		$00061000|$00008025
		dc.l		$00071000|HIRESLACE_KEY
		dc.l		$00081000|HIRESLACE_KEY
	;NoLace Super
		dc.l		DEFAULT_MONITOR_ID|SUPER_KEY
		dc.l		PAL_MONITOR_ID|SUPER_KEY
		dc.l		NTSC_MONITOR_ID|SUPER_KEY
		dc.l		VGA_MONITOR_ID|VGAPRODUCT_KEY
		dc.l		A2024_MONITOR_ID
		dc.l		$00061000|$00008024
		dc.l		$00071000|SUPER_KEY
		dc.l		$00081000|SUPER_KEY
	;Lace Super
		dc.l		DEFAULT_MONITOR_ID|SUPERLACE_KEY
		dc.l		PAL_MONITOR_ID|SUPERLACE_KEY
		dc.l		NTSC_MONITOR_ID|SUPERLACE_KEY
		dc.l		VGA_MONITOR_ID|VGAPRODUCTLACE_KEY
		dc.l		A2024_MONITOR_ID|A2024FIFTEENHERTZ_KEY
		dc.l		$00061000|$00008025
		dc.l		$00071000|SUPERLACE_KEY
		dc.l		$00081000|SUPERLACE_KEY
 ENDC
 IFND D20
RightID:
		movem.l	d0/a1,-(a7)
		move.w	#$8000,(ns_ViewModes,a0)
		moveq		#mo_Lace,d0
		bsr		CheckModeBit
		beq.b		1$
		move.w	#$8004,(ns_ViewModes,a0)
1$		movem.l	(a7)+,d0/a1
		rts
 ENDC

 IFD D20
	;***
	;Test if screen can be closed and prevent other windows from opening
	;on screen (in other words, test if CloseScreen can be used)
	;(Note, this function will return success if screen is already closed
	;or if PowerVisor is opened on another screen)
	;-> d0 = 0 (flags) if there are still windows
	;***
TestForClose:
		move.l	(MyScreen,pc),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	#PSNF_PRIVATE,d0
		CALLINT	PubScreenStatus
		andi.b	#1,d0
		beq.b		2$
1$		moveq		#1,d0					;Everything fine
		rts
2$		moveq		#0,d0
		rts
 ENDC

	;***
	;Close screen
	;***
CloseScreen:
 IFD D20
		bsr		FreeVisualInfo
 ENDC
		move.l	(MyScreen,pc),d0
		beq.b		1$
		movea.l	d0,a0
		CALLINT	CloseScreen
		lea		(MyScreen,pc),a0
		clr.l		(a0)
1$		rts

	;***
	;Reopen the screen and windows with new parameters
	;This function does nothing if in hold mode (no error)
	;ScreenID, LaceMode and PVScreen are used as parameters
	;-> flags if error
	;***
ReOpenScreen:
		move.b	(InHold),d0
		beq.b		2$
		rts								;Flags are ok

2$		bsr		OpenScreen
		SERReq	ErrOpenScreen,1$
	IFD D20
		bsr		GetVisualInfo
		bsr		SetMenuLayout
		tst.l		d0
		beq.b		1$
	ENDC
		bsr		OpenPW
		beq.b		1$
		bra		WindowGadgetPort	;This routine sets d0 to 1 (and flags)
1$		rts								;d0 is still 0 (and flags are also set)

	;***
	;Update all SBottom flags for all PW's
	;***
UpdateSBottom:
		movem.l	d0-d1/a0-a1,-(a7)
		move.l	(myGlobal,pc),d0
		beq.b		2$
		movea.l	d0,a0
		lea		(Global_PWList,a0),a0
3$		movea.l	(a0),a0				;Succ
1$		tst.l		(a0)					;Succ
		beq.b		5$
		move.l	(nw_Flags+PhysWin_NewWindow,a0),d0
		andi.l	#~SIZEBBOTTOM,d0
		bsr		TestSBottom
		beq.b		4$
		ori.l		#SIZEBBOTTOM,d0
4$		cmp.l		(nw_Flags+PhysWin_NewWindow,a0),d0
		beq.b		3$
		move.l	d0,(nw_Flags+PhysWin_NewWindow,a0)
		tst.l		(PhysWin_Window,a0)
		beq.b		3$
		bsr		PhysWin_Close
		movea.l	(nw_Screen+PhysWin_NewWindow,a0),a1
		bsr		PhysWin_Open
		bra.b		3$
5$		bsr		WindowGadgetPort
2$		movem.l	(a7)+,d0-d1/a0-a1
		rts

;==================================================================================
;
; Everything for menus
;
;==================================================================================

 IFD D20

	;***
	;Init one menu entry
	;a4 = pointer to NewMenu
	;d0 = type (NM_TITLE, NM_ITEM, NM_SUB, NM_END)
	;d1 = flags
	;a0 = pointer to label (or NM_BARLABEL)
	;a1 = pointer to command key
	;a2 = pointer to command (userdata)
	;-> a4 = pointer to next NewMenu
	;***
InitNewMenu:
		move.b	d0,(gnm_Type,a4)
		move.w	d1,(gnm_Flags,a4)
		move.l	a0,(gnm_Label,a4)
		move.l	a1,(gnm_CommKey,a4)
		move.l	a2,(gnm_UserData,a4)
		lea		(gnm_SIZEOF,a4),a4
		rts

	;***
	;Relocate all strings in the Menu string pool
	;a3 = pointer to NewMenus
	;***
RelocMenuPool:
		move.l	(MenuStr,pc),d1
		subq.l	#1,d1
		movea.l	a3,a4
1$		cmpi.b	#NM_END,(gnm_Type,a4)
		beq.b		2$
	;Test label
		move.l	(gnm_Label,a4),d0
		beq.b		3$
		cmpi.l	#-1,d0
		beq.b		3$
		add.l		d1,d0
		move.l	d0,(gnm_Label,a4)
	;Test CommKey
3$		move.l	(gnm_CommKey,a4),d0
		beq.b		4$
		add.l		d1,d0
		move.l	d0,(gnm_CommKey,a4)
	;Test UserData
4$		move.l	(gnm_UserData,a4),d0
		beq.b		5$
		add.l		d1,d0
		move.l	d0,(gnm_UserData,a4)
	;Next menu entry
5$		lea		(gnm_SIZEOF,a4),a4
		bra.b		1$
	;The end
2$		rts

	;***
	;Get and add a string to the Menu string pool
	;a0 = pointer to commandline
	;-> a2 = pointer to commandline after string
	;-> a0 = pointer to commandline after string
	;-> d0 = offset+1 in string pool (or 0 if no string)
	;***
GetAndAddStr:
		bsr		GetString			;Test for error DEBUG DEBUG DEBUG !!!
		movea.l	a0,a2
		movea.l	d0,a0
		tst.l		d0
		beq.b		1$
		lea		(MenuStrSize,pc),a1
		bsr		AddString			;Test for error DEBUG DEBUG DEBUG !!!
1$		movea.l	a2,a0
		rts

	;***
	;Add End menu entry
	;***
AddEndMenu:
		moveq		#NM_END,d0
		moveq		#0,d1
		suba.l	a0,a0
		suba.l	a1,a1
		suba.l	a2,a2
		bra		InitNewMenu

	;***
	;Add Title menu entry
	;a0 = pointer to rest of line
	;***
AddTitleMenu:
		bsr		GetAndAddStr		;Label
		movea.l	d0,a0					;Store offset in stringpool, we relocate
											;the strings later
		suba.l	a1,a1
		suba.l	a2,a2
		moveq		#NM_TITLE,d0
		moveq		#0,d1
		bra		InitNewMenu

	;***
	;Add Sub menu entry
	;a0 = pointer to rest of line
	;***
AddSubMenu:
		moveq		#NM_SUB,d5

AddSubItemMenu:
		bsr		GetAndAddStr		;Label
		movea.l	d0,a5					;Remember offset in stringpool, we
											;relocate the strings later
		bsr		GetAndAddStr		;Command
		move.l	d0,-(a7)				;Offset in stringpool (command)

		bsr		GetAndAddStr		;Command key
		movea.l	d0,a1
		movea.l	(a7)+,a2

		movea.l	a5,a0
		move.l	d5,d0
		moveq		#0,d1
		bra		InitNewMenu

	;***
	;Add Item menu entry
	;a0 = pointer to rest of line
	;***
AddItemMenu:
		moveq		#NM_ITEM,d5
		bra.b		AddSubItemMenu

	;***
	;Add Item Bar menu entry
	;***
AddIBarMenu:
		moveq		#NM_ITEM,d0
AddISBarMenu:
		movea.l	#NM_BARLABEL,a0
		suba.l	a1,a1
		suba.l	a2,a2
		moveq		#0,d1
		bra		InitNewMenu

	;***
	;Add Sub Bar menu entry
	;***
AddSBarMenu:
		moveq		#NM_SUB,d0
		bra.b		AddISBarMenu

	;***
	;Read the menu file, and attach the menus to the main physical window
	;-> d0 = 0 if error (flags)
	;***
InstallMenus:
		moveq		#0,d6					;Set return to error

	;Allocate all NewMenu structures for 300 possible menus
		move.l	#300*gnm_SIZEOF,d0
		bsr		AllocBlockInt
		beq		1$

		movea.l	d0,a3					;Pointer to NewMenus
		movea.l	d0,a4					;First NewMenu

		moveq		#1,d6					;If FOpen fails we have no real error
											;since it is legal to have no menu file
											;for PowerVisor

		lea		(MenuName,pc),a0
		bsr		CopyFileName
		beq		2$

		bsr		FOpen
		beq		2$
		move.l	d0,d7					;Buffered file node
		moveq		#0,d6					;Back to error

	;Loop for all menus
4$		move.l	d7,d1					;File node
		move.l	(Storage),d2			;Buffer
		move.l	#299,d3				;Maximum length (DEBUG ! Should be bigger)
		bsr		FReadLine
		beq.b		8$						;EOF
		addq.l	#1,d0
		beq.b		8$						;Error

		movea.l	(Storage),a0
		bsr		GetString			;Get command (title,item,end,bar)
		beq.b		4$						;Other string
		movea.l	d0,a1					;Pointer to string
		move.l	(a1),d0
		cmpi.l	#'titl',d0
		beq.b		6$
		cmpi.l	#'item',d0
		beq.b		7$
		cmpi.l	#'end'<<8,d0
		beq.b		8$
		cmpi.l	#'sub'<<8,d0
		beq.b		9$
		cmpi.l	#'sbar',d0
		beq.b		10$
		cmpi.l	#'ibar',d0
		bne.b		4$
	;ITEM BAR
		bsr		AddIBarMenu
		bra.b		4$
	;SUB BAR
10$	bsr		AddSBarMenu
		bra.b		4$
	;SUB
9$		bsr		AddSubMenu
		bra.b		4$
	;ITEM
7$		bsr		AddItemMenu
		bra.b		4$
	;TITLE
6$		bsr		AddTitleMenu
		bra.b		4$

	;END the menus with an 'end' MenuItem
8$		bsr		AddEndMenu

		bsr		RelocMenuPool

	;Really install the menus
		movea.l	a3,a0					;All NewMenus
		suba.l	a1,a1					;Tags
		CALLGT	CreateMenusA
		lea		(AllMenus,pc),a0
		move.l	d0,(a0)				;Pointer to menus
		beq.b		3$
		movea.l	d0,a0					;Menus
		movea.l	(VisualInfo,pc),a1
		lea		(LayoutTags,pc),a2
		CALL		LayoutMenusA

	;Success
		moveq		#1,d6					;No error

	;Exit, but close file and clear memory first
3$		move.l	d7,d1
		bsr		FClose

	;Exit, but clear memory first
2$		movea.l	a3,a0
		bsr		FreeBlock

	;Exit
1$		move.l	d6,d0					;Returncode
		rts

	;***
	;Set the layout for all menus
	;***
SetMenuLayout:
		movem.l	d0-d1/a0-a2,-(a7)
		move.l	(AllMenus,pc),d0
		beq.b		1$
		movea.l	d0,a0
		movea.l	(VisualInfo,pc),a1
		lea		(LayoutTags,pc),a2
		CALLGT	LayoutMenusA
1$		movem.l	(a7)+,d0-d1/a0-a2
		rts

	;***
	;Remove all menus
	;a0 = PW
	;***
RemoveMenus:
		movem.l	d0-d1/a0-a1,-(a7)
		move.l	(AllMenus,pc),d0
		beq.b		1$
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0
		CALLINT	ClearMenuStrip
1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Add all menus
	;a0 = PW
	;***
AddMenus:
		movem.l	d0-d1/a0-a1,-(a7)
		move.l	(AllMenus,pc),d0
		beq.b		1$
		movea.l	(PhysWin_Window,a0),a0
		movea.l	d0,a1
		CALLINT	SetMenuStrip
1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Free all menus
	;***
FreeMenus:
		movea.l	(AllMenus,pc),a0
		CALLGT	FreeMenus
		lea		(MenuStrSize,pc),a0
		moveq		#0,d0
		bsr		ReAllocMem
		lea		(AllMenus,pc),a0
		clr.l		(a0)
		rts

 ENDC

;==================================================================================
;
; End menus
;
;==================================================================================

;==================================================================================
;
; Global object
;
;==================================================================================

	;***
	;Create a Global
	;-> d0 = ptr to Global (or null,flags if error)
	;-> a0 = d0 (if success)
	;***
Global_Constructor:
		moveq		#Global_SIZE,d0
		bsr		AllocClear
		beq.b		1$
		move.l	d0,-(a7)
		movea.l	d0,a0
		lea		(Global_PWList,a0),a0
		NEWLIST	a0
		move.l	(a7)+,d0
		movea.l	d0,a0
1$		rts

	;***
	;Remove a Global
	;All Physical windows, logical windows and boxes will be removed
	;a0 = Global, may be NULL
	;***
Global_Destructor:
		move.l	a0,d0
		beq.b		3$
		move.l	a0,-(a7)
		lea		(Global_PWList,a0),a0
		movea.l	(a0),a0				;Succ
1$		tst.l		(a0)					;Succ
		beq.b		2$
		move.l	(a0),-(a7)			;Succ
		bsr		PhysWin_Destructor
		movea.l	(a7)+,a0
		bra.b		1$
2$		moveq		#Global_SIZE,d0
		movea.l	(a7)+,a1
		bsr		FreeMem
3$		rts

	;***
	;Close all PW in this global
	;a0 = Global
	;***
Global_Close:
		move.l	a0,-(a7)
		lea		(Global_PWList,a0),a0
3$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq.b		2$
		bsr		PhysWin_Close
		bra.b		3$
2$		movea.l	(a7)+,a0
		rts

	;***
	;Open all PW in this global
	;a0 = Global
	;a1 = Screen
	;-> d0 = success or NULL (flags)
	;***
Global_Open:
		move.l	a0,-(a7)
		lea		(Global_PWList,a0),a0
3$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq.b		2$
		bsr		PhysWin_Open
		bne.b		3$
4$		movea.l	(a7)+,a0
		moveq		#0,d0					;Failure for one
		rts
2$		movea.l	(a7)+,a0
		moveq		#1,d0					;Success for all
		rts

	IFD D20
	;***
	;Recompute all boxes for all PW in this global
	;This function is mainly used to update all the scrollbars after
	;changing the global preferences setting for scrollbars
	;a0 = Global
	;-> d0 = success or NULL (flags)
	;***
Global_CleanBoxes:
		move.l	a0,-(a7)
		lea		(Global_PWList,a0),a0
3$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq.b		2$
		bsr		PhysWin_InitScrollBars
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets
		bne.b		3$
4$		movea.l	(a7)+,a0
		moveq		#0,d0					;Failure for one
		rts
2$		movea.l	(a7)+,a0
		moveq		#1,d0					;Success for all
		rts
	ENDC

	;***
	;Check if there are any messages on the PW's of this Global
	;a0 = Global
	;-> d0 = Message or NULL (flags)
	;-> a1 = pointer to PW
	;***
Global_CheckMsg:
		move.l	a0,-(a7)
		movea.l	(WinPort,pc),a0
 IFD D20
		CALLGT	GT_GetIMsg
 ENDC
 IFND D20
		CALLEXEC	GetMsg
 ENDC
		tst.l		d0
		beq.b		1$

	;There is a message
		movea.l	d0,a1
		movea.l	(im_IDCMPWindow,a1),a1
		movea.l	(wd_UserData,a1),a1

		tst.l		d0						;Message

1$		movea.l	(a7)+,a0				;For flags
		rts

	;***
	;Check if the signal is for the physical windows
	;a0 = Global
	;d0 = signal
	;-> flags eq if not
	;***
Global_CheckSignal:
		and.l		(Global_SigSet,a0),d0
		rts

	;***
	;Activate a LogWin
	;a0 = Global
	;a1 = LogWin
	;***
Global_ActivateLogWin:
		movem.l	a2-a3,-(a7)
		movea.l	a0,a2
		movea.l	a1,a3
		move.l	(Global_ActiveLW,a2),d0
		beq.b		1$
	;First desactivate the previous
		movea.l	d0,a0
		bsr		_LogWin_Desactivate
1$		move.l	a3,(Global_ActiveLW,a2)
		movea.l	a3,a0
		bsr		_LogWin_Activate
		movea.l	a2,a0
		movem.l	(a7)+,a2-a3
		rts

	;***
	;Activate the next LogWin
	;a0 = Global
	;***
Global_CycleActive:
		move.l	(Global_ActiveLW,a0),d0
		beq.b		1$
		movea.l	d0,a1
		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		bne.b		Global_ActivateLogWin

	;Go to next PW
		movea.l	d0,a1
		movea.l	(LogWin_PhysWin,a1),a1
4$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		bne.b		3$

	;There is no active LogWin yet
1$		movea.l	(Global_PWList,a0),a1
		tst.l		(a1)					;Succ
		beq.b		2$
3$		move.l	a1,d1
		movea.l	(PhysWin_LWList,a1),a1
		tst.l		(a1)					;Succ
		bne.b		Global_ActivateLogWin
		movea.l	d1,a1
		bra.b		4$

2$		rts

;==================================================================================
;
; End Global object
;
;==================================================================================

;==================================================================================
;
; Box object
;
;==================================================================================

	;***
	;Create a box
	;-> d0 = ptr to box (or null,flags if error)
	;-> a0 = d0 (if success)
	;***
Box_Constructor:
		moveq		#Box_SIZE,d0
		bsr		AllocClear
		beq.b		1$
		movea.l	d0,a0
		move.b	#1,(Box_Dirty,a0)
		move.b	#ATOMIC,(Box_Type,a0)
		tst.l		d0
1$		rts

	;***
	;Remove a box
	;Note that the children will NOT automatically be removed with
	;this function. The box will NOT be unlinked from the box list
	;a0 = box
	;***
Box_Destructor:
	IFD D20
		bsr.b		Box_FreeNewGadget
	ENDC
		moveq		#Box_SIZE,d0
		movea.l	a0,a1
		bra		FreeMem

	IFD D20

	;***
	;Add a scrollbar to this box
	;a0 = box
	;a1 = physical window
	;***
Box_AddScrollBar:
		move.b	#18,(Box_BorderRight,a0)
		moveq		#0,d0					;ID
		move.l	a1,-(a7)
		bsr		Box_MakeNewGadget

_Box_UpdatePW:
		movea.l	(a7),a1
		move.l	a0,(a7)
		movea.l	(PhysWin_Box,a1),a0
		bsr		Box_FullSize
		movea.l	(a7)+,a0
		rts

	;***
	;Remove the scrollbar from this box
	;a0 = box
	;a1 = physical window
	;***
Box_RemoveScrollBar:
		move.b	#0,(Box_BorderRight,a0)
		move.l	a1,-(a7)
		bsr.b		Box_FreeNewGadget

		bra.b		_Box_UpdatePW

	;***
	;Free the NewGadget structure
	;a0 = box
	;***
Box_FreeNewGadget:
		move.l	(Box_NewGadget,a0),d0
		beq.b		1$
		move.l	a0,-(a7)
		movea.l	d0,a1
		moveq		#gng_SIZEOF,d0
		bsr		FreeMem
		movea.l	(a7)+,a0
1$		clr.l		(Box_NewGadget,a0)
		clr.l		(Box_Gadget,a0)
		rts

	;***
	;Make a NewGadget structure and attach it to this box
	;d0 = ID
	;a0 = box
	;-> d0 = pointer to newgadget (or NULL, flags if no success)
	;***
Box_MakeNewGadget:
		movem.l	d0/a0,-(a7)
		bsr.b		Box_FreeNewGadget

	;Allocate a new one
		moveq		#gng_SIZEOF,d0
		bsr		AllocClear
		movea.l	d0,a1
		movem.l	(a7)+,d0/a0
		beq.b		1$

		move.w	d0,(gng_GadgetID,a1)

		move.l	a1,d0
1$		move.l	d0,(Box_NewGadget,a0)
		rts

	;***
	;Make a gadget from a NewGadget
	;This function does nothing if there is no screen (hold mode)
	;In this case VisualInfo will be 0
	;d1 = kind
	;a0 = Box
	;a2 = tags
	;a3 = pointer to PhysWin_CurGadget
	;-> d0 = pointer to gadget (or NULL, flags if no success) (or 1 if no NewGadget)
	;***
_Box_MakeGadget:
		move.l	a0,-(a7)
		move.l	(Box_NewGadget,a0),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	(VisualInfo,pc),(gng_VisualInfo,a1)
		beq.b		1$
		move.l	d1,d0						;Kind
		movea.l	(a3),a0					;Previous gadget
		CALLGT	CreateGadgetA
		move.l	d0,(a3)
		movea.l	(a7)+,a0
		move.l	d0,(Box_Gadget,a0)	;Also set flags
		rts
1$		movea.l	(a7)+,a0
		moveq		#1,d0						;Not really an error, but there
												;is no NewGadget or no VisualInfo
		rts

	ENDC

	;***
	;Init x y w and h when the outer box size is given
	;a0 = box
	;d0 = x
	;d1 = y
	;d2 = w
	;d3 = h
	;***
Box_SetOuterBox:
		move.l	d4,-(a7)
		move.b	#1,(Box_Dirty,a0)
		moveq		#0,d4
	;x
		move.b	(Box_BorderLeft,a0),d4
		add.w		d4,d0
		move.w	d0,(Box_x,a0)
	;y
		move.b	(Box_BorderTop,a0),d4
		add.w		d4,d1
		move.w	d1,(Box_y,a0)
	;w
		move.b	(Box_BorderLeft,a0),d4
		sub.w		d4,d2
		move.b	(Box_BorderRight,a0),d4
		sub.w		d4,d2
		move.w	d2,(Box_w,a0)
	;h
		move.b	(Box_BorderTop,a0),d4
		sub.w		d4,d3
		move.b	(Box_BorderBottom,a0),d4
		sub.w		d4,d3
		move.w	d3,(Box_h,a0)

		move.l	(a7)+,d4
		rts

	;***
	;Clear the outer box
	;a0 = box
	;d0 = colour
	;***
Box_ClearOuterBox:
		move.l	(Box_PhysWin,a0),d1
		beq.b		1$
		movea.l	d1,a1
		move.l	(PhysWin_Window,a1),d1
		beq.b		1$
		movea.l	d1,a1
		movea.l	(wd_RPort,a1),a1
		movem.l	d2-d4/a2,-(a7)
		move.l	a0,-(a7)
		movea.l	a1,a2
		CALLGRAF	SetAPen
		movea.l	(a7),a0
		moveq		#0,d4

		move.w	(Box_x,a0),d0
		move.w	d0,d2
		move.b	(Box_BorderLeft,a0),d4
		sub.w		d4,d0

		move.w	(Box_y,a0),d1
		move.w	d1,d3
		move.b	(Box_BorderTop,a0),d4
		sub.w		d4,d1

		add.w		(Box_w,a0),d2
		move.b	(Box_BorderRight,a0),d4
		add.w		d4,d2

		add.w		(Box_h,a0),d3
		move.b	(Box_BorderBottom,a0),d4
		add.w		d4,d3

		subq.w	#1,d2
		subq.w	#1,d3
		movea.l	a2,a1
		CALL		RectFill
		movea.l	(a7)+,a0
		movem.l	(a7)+,d2-d4/a2
1$		rts

	;***
	;Make a box full size
	;This function does nothing if box is not yet linked to a PW
	;or if window does not yet exist for PW
	;a0 = box
	;***
Box_FullSize:
		move.l	a2,-(a7)
		move.l	(Box_PhysWin,a0),d0
		beq		1$
		move.l	a0,-(a7)
		movea.l	d0,a0
		bsr		PhysWin_UpdateNewWindow
		movea.l	(a7)+,a1				;For flags
		beq		1$
		movea.l	d0,a2
		exg		a0,a1

	;a0 = Box, a1 = PW, a2 = Window
		moveq		#0,d1
	;x
		moveq		#0,d0
		move.b	(wd_BorderLeft,a2),d1
		add.w		d1,d0
		move.b	(Box_BorderLeft,a0),d1
		add.w		d1,d0
		move.b	(PhysWin_BorderLeft,a1),d1
		add.w		d1,d0
		move.w	d0,(Box_x,a0)
	;y
		moveq		#0,d0
		move.b	(wd_BorderTop,a2),d1
		add.w		d1,d0
		move.b	(Box_BorderTop,a0),d1
		add.w		d1,d0
		move.b	(PhysWin_BorderTop,a1),d1
		add.w		d1,d0
		move.w	d0,(Box_y,a0)
	;w
		move.w	(nw_Width+PhysWin_NewWindow,a1),d0
		move.b	(wd_BorderLeft,a2),d1
		sub.w		d1,d0
		move.b	(wd_BorderRight,a2),d1
		sub.w		d1,d0
		move.b	(Box_BorderLeft,a0),d1
		sub.w		d1,d0
		move.b	(Box_BorderRight,a0),d1
		sub.w		d1,d0
		move.b	(PhysWin_BorderLeft,a1),d1
		sub.w		d1,d0
		move.b	(PhysWin_BorderRight,a1),d1
		sub.w		d1,d0
		move.w	d0,(Box_w,a0)
	;h
		move.w	(nw_Height+PhysWin_NewWindow,a1),d0
		move.b	(wd_BorderTop,a2),d1
		sub.w		d1,d0
		move.b	(wd_BorderBottom,a2),d1
		sub.w		d1,d0
		move.b	(Box_BorderTop,a0),d1
		sub.w		d1,d0
		move.b	(Box_BorderBottom,a0),d1
		sub.w		d1,d0
		move.b	(PhysWin_BorderTop,a1),d1
		sub.w		d1,d0
		move.b	(PhysWin_BorderBottom,a1),d1
		sub.w		d1,d0
		move.w	d0,(Box_h,a0)

		move.b	#1,(Box_Dirty,a0)
1$		movea.l	(a7)+,a2
		rts

;==================================================================================
;
; End Box object
;
;==================================================================================

;==================================================================================
;
; PhysWindow object
;
;==================================================================================

	;***
	;Create a physical window, window is put in physical window list
	;window is not opened (use PhysWin_Open to do this).
	;a0 = Global
	;a2 = name
	;d0 = left x
	;d1 = top y
	;d2 = width
	;d3 = height
	;d4 = flags
	;d5 = IDCMP
	;-> d0 = ptr to physical window (or null,flags if error)
	;***
PhysWin_Constructor:
		movem.l	a3-a4,-(a7)
		suba.l	a3,a3
		movem.l	d0-d1/a0-a1,-(a7)
		moveq		#PhysWin_SIZE,d0
		bsr		AllocClear
		movea.l	d0,a3
		movem.l	(a7)+,d0-d1/a0-a1
		beq		1$
	;Success
		movem.l	d0-d1/a0-a1,-(a7)
		moveq		#0,d0
		movea.l	a2,a0
	;Compute length of string + 1
5$		addq.w	#1,d0
		tst.b		(a0)+
		bne.b		5$
		bsr		AllocClear
		movea.l	d0,a4
		movem.l	(a7)+,d0-d1/a0-a1
		beq		1$
	;Everything is fine
		move.l	a4,(LN_NAME,a3)
	;Copy string
6$		move.b	(a2)+,(a4)+
		bne.b		6$

;		move.l	a1,(nw_Screen+PhysWin_NewWindow,a3)
		move.l	a0,(PhysWin_Global,a3)
		move.w	d0,(nw_LeftEdge+PhysWin_NewWindow,a3)
		move.w	d1,(nw_TopEdge+PhysWin_NewWindow,a3)
		move.w	d2,(nw_Width+PhysWin_NewWindow,a3)
		move.w	d3,(nw_Height+PhysWin_NewWindow,a3)
		move.l	d4,(nw_Flags+PhysWin_NewWindow,a3)
		move.l	d5,(nw_IDCMPFlags+PhysWin_NewWindow,a3)

	IFND D20
		move.b	#1,(nw_BlockPen+PhysWin_NewWindow,a3)
	ENDC
	IFD D20
		move.b	#-1,(nw_BlockPen+PhysWin_NewWindow,a3)
		move.b	#-1,(nw_DetailPen+PhysWin_NewWindow,a3)
	ENDC

		move.w	#WBENCHSCREEN,(nw_Type+PhysWin_NewWindow,a3)
		move.l	a1,d0
		beq.b		3$
		move.w	#CUSTOMSCREEN,(nw_Type+PhysWin_NewWindow,a3)
3$		move.l	#$00640064,(nw_MinWidth+PhysWin_NewWindow,a3)
		moveq		#-1,d0
		move.l	d0,(nw_MaxWidth+PhysWin_NewWindow,a3)

	;Init first box
		bsr		Box_Constructor
		beq.b		1$
		move.l	d0,(PhysWin_Box,a3)
		move.l	a3,(Box_PhysWin,a0)

	;Add this new physical window node to the physical window list
		movea.l	(PhysWin_Global,a3),a0
		lea		(Global_PWList,a0),a0
		movea.l	a3,a1
		CALLEXEC	AddHead
		lea		(PhysWin_LWList,a3),a0
		NEWLIST	a0
		move.l	a3,d0

	;The end
2$		movem.l	(a7)+,a3-a4
		rts

	;Error allocating memory
1$		movea.l	a3,a0
		bsr		PhysWin_Destructor
		moveq		#0,d0
		bra		2$

	;***
	;Remove a physical window, if the window is already open it is closed.
	;This function closes all logical windows on this physical window.
	;The physical window is also removed from the list.
	;a0 = ptr to PhysWin, may be equal to NULL
	;***
PhysWin_Destructor:
	IFD D20
		bsr		_PhysWin_RemoveGadgets
	ENDC

		move.l	a0,d0
		beq.b		3$
		move.l	a0,-(a7)
		movea.l	a0,a1
		CALLEXEC	Remove

	;Remove all logical windows on this physical window
		movea.l	(a7),a0
		lea		(PhysWin_LWList,a0),a0
		movea.l	(a0),a0				;Succ
2$		tst.l		(a0)					;Succ
		beq.b		1$
		move.l	(a0),-(a7)			;Succ
		move.l	(4,a7),d0
		cmp.l		(LogWin_PhysWin,a0),d0	;Compare with this physical window
		bne.b		4$
		bsr		LogWin_Destructor
4$		movea.l	(a7)+,a0
		bra.b		2$

	;Free Box
1$		movea.l	(a7),a0
		bsr		_PhysWin_FreeBoxes

		bsr		PhysWin_Close

	;Free memory
		movea.l	(a7),a1
		movea.l	(LN_NAME,a1),a1
		movea.l	a1,a0
		moveq		#0,d0
6$		addq.w	#1,d0
		tst.b		(a0)+
		bne.b		6$
		bsr		FreeMem
		movea.l	(a7)+,a1
		moveq		#PhysWin_SIZE,d0
		bsr		FreeMem
3$		rts

	IFD D20

	;***
	;Create the context for all the gadgets in this physical window
	;Also sets 'CurGadget' to point to the context gadget
	;a0 = PW
	;-> d0 = NULL if failure (flags)
	;***
_PhysWin_CreateContext:
		move.l	a0,-(a7)

		lea		(PhysWin_CurGList,a0),a0
		CALLGT	CreateContext
		movea.l	(a7)+,a0				;Restore PW
		move.l	(PhysWin_CurGList,a0),(PhysWin_CurGadget,a0)

		tst.l		d0
		rts

	;***
	;Remove all gadgets used in this physical window
	;a0 = PW
	;-> preserves a0 and a1
	;***
_PhysWin_RemoveGadgets:
		movem.l	a0-a1,-(a7)
		cmpa.l	(MainPW,pc),a0
		bne.b		1$
		bsr		RemoveGadget

1$		bsr		_PhysWin_RemoveGList
		bsr		_PhysWin_FreeGadgets
		movem.l	(a7)+,a0-a1
		rts

	;***
	;Free gadgets
	;a0 = PW
	;***
_PhysWin_FreeGadgets:
		move.l	a0,-(a7)
		lea		(PhysWin_CurGList,a0),a1
		movea.l	(a1),a0				;Parameter for 'FreeGadgets'
		clr.l		(a1)
		CALLGT	FreeGadgets			;This function is safe with a NULL par
		movea.l	(a7)+,a0
	;Fall through

	;***
	;Set all gadget pointers for all boxes in this physical window to NULL
	;a0 = PW
	;***
_PhysWin_ClearGadgetPointers:
		move.l	a0,-(a7)

		lea		(PhysWin_LWList,a0),a0
1$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq.b		2$

		movea.l	(LogWin_Box,a0),a1
		clr.l		(Box_Gadget,a1)
		bra.b		1$

2$		movea.l	(a7)+,a0
		rts

	;***
	;Remove gadgets from list
	;a0 = PW
	;***
_PhysWin_RemoveGList:
		move.l	a0,-(a7)

		move.l	(PhysWin_Window,a0),d1
		beq.b		1$

		move.l	(PhysWin_CurGList,a0),d0
		beq.b		1$

		movea.l	d1,a0					;Get window
		movea.l	d0,a1					;Pointer to first gadget to remove
		moveq		#-1,d0				;Remove all gadgets
		CALLINT	RemoveGList

1$		movea.l	(a7)+,a0
		rts

	;***
	;Update all scrollbars for all logical windows in this physical window
	;a0 = PW
	;***
_PhysWin_UpdateScrollBar:
		movem.l	a0/a2,-(a7)

		lea		(PhysWin_LWList,a0),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$

		movea.l	a2,a0
		movea.l	(LogWin_CreateSBHandler,a0),a1
		jsr		(a1)
		bra.b		1$

2$		movem.l	(a7)+,a0/a2
		rts

	;***
	;Prepare gadgets for use
	;a0 = PW
	;***
_PhysWin_PrepareGadgets:
		movem.l	d2/a0/a2-a3,-(a7)
		movea.l	a0,a3					;Remember PW

		move.l	(PhysWin_Window,a3),d0
		beq.b		1$

		move.l	d0,-(a7)				;Remember window
		movea.l	d0,a0					;Parameter for 'AddGList'
		movea.l	(PhysWin_CurGList,a3),a1
		moveq		#-1,d0				;First position
		moveq		#-1,d1				;Number of gadgets
		moveq		#0,d2					;No requester
		CALLINT	AddGList

		movea.l	(PhysWin_CurGList,a3),a0
		movea.l	(a7),a1				;Restore window
		suba.l	a2,a2					;No requester
		moveq		#-1,d0				;Number of gadgets
		CALL		RefreshGList

		movea.l	(a7)+,a0				;Restore window
		suba.l	a1,a1					;No requester
		CALLGT	GT_RefreshWindow

1$		movem.l	(a7)+,d2/a0/a2-a3
		rts

	;***
	;Initialize all gadgets used in this box and scan recursively
	;to the other boxes
	;a0 = PW
	;a1 = Box
	;-> d0 = NULL if failure (flags)
	;***
_PhysWin_InitBoxGadgets:
		move.l	a1,-(a7)
		move.l	(Box_ChildA,a1),d0
		beq.b		1$

	;Scan child box A
		movea.l	d0,a1
		bsr		_PhysWin_InitBoxGadgets
		beq.b		3$
		movea.l	(a7),a1

1$		move.l	(Box_ChildB,a1),d0
		beq.b		2$

	;Scan child box B
		movea.l	d0,a1
		bsr		_PhysWin_InitBoxGadgets
		beq.b		3$

2$		movem.l	a0/a2-a3,-(a7)
		lea		(PhysWin_CurGadget,a0),a3
		movea.l	(12,a7),a0			;Get pointer to box
		move.l	(Box_NewGadget,a0),d0
		beq.b		4$						;If NULL we have nothing to init (_Box_MakeGadget
											;will do nothing)
		movea.l	d0,a1					;Pointer to NewGadget
		move.w	(Box_x,a0),d0
		add.w		(Box_w,a0),d0
		move.w	d0,(gng_LeftEdge,a1)
		move.w	(Box_y,a0),(gng_TopEdge,a1)
		moveq		#0,d0
		move.b	(Box_BorderRight,a0),d0
		move.w	d0,(gng_Width,a1)
		move.b	(Box_BorderTop,a0),d0
		add.b		(Box_BorderBottom,a0),d0
		add.w		(Box_h,a0),d0
		move.w	d0,(gng_Height,a1)
		move.l	a0,(gng_UserData,a1)

4$		moveq		#SCROLLER_KIND,d1
		lea		(ScrollerTags,pc),a2
		bsr		_Box_MakeGadget
		movem.l	(a7)+,a0/a2-a3

3$		movea.l	(a7)+,a1				;For flags
		rts

	;***
	;Initialize all gadgets used in this physical window
	;Gadgets are associated with Box objects. This function scans all
	;boxes and initializes the gadgets for each box
	;a0 = PW
	;-> d0 = NULL if failure (flags)
	;***
_PhysWin_InitGadgets:
		bsr		_PhysWin_RemoveGadgets

		bsr		_PhysWin_CreateContext
		beq.b		1$

		move.l	(PhysWin_Box,a0),d0
		beq.b		2$
		movea.l	d0,a1
		bsr		_PhysWin_InitBoxGadgets
		beq.b		1$

	;Success
		bsr		_PhysWin_PrepareGadgets
		bsr		_PhysWin_UpdateScrollBar

		cmpa.l	(MainPW,pc),a0
		bne.b		2$
		bsr		SetGadgetState

2$		moveq		#1,d0
1$		rts

	;***
	;Remove or add all scrollbars for all logical windows in this
	;physical window according to the local logical window flags
	;or the global SBarMode flag
	;a0 = PW
	;***
PhysWin_InitScrollBars:
		move.l	a0,-(a7)

		lea		(PhysWin_LWList,a0),a0
1$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq.b		2$

		bsr		LogWin_InitScrollBar
		bra.b		1$

2$		movea.l	(a7)+,a0
		rts

	ENDC

	;***
	;Set the inner box used by master box
	;a0 = PW
	;d0 = left
	;d1 = top
	;d2 = right
	;d3 = bottom
	;***
PhysWin_SetBoxOffsets:
		move.b	d0,(PhysWin_BorderLeft,a0)
		move.b	d1,(PhysWin_BorderTop,a0)
		move.b	d2,(PhysWin_BorderRight,a0)
		move.b	d3,(PhysWin_BorderBottom,a0)
		rts

	;***
	;Where is a certain point located ?
	;a0 = PW
	;a1 = start box
	;d0 = x (relative to total left of window)
	;d1 = y
	;-> d0 = box or NULL (flags) if location not in any box
	;			if box is not ATOMIC, we have a hit on the dragbar for the
	;			UPDOWN or LEFTRIGHT box
	;***
PhysWin_WhereIs:
		cmpi.b	#ATOMIC,(Box_Type,a1)
		bne.b		1$
	;An ATOMIC box
		move.l	d2,-(a7)
	;horizontal
		move.w	(Box_x,a1),d2
		cmp.w		d0,d2
		bgt.b		2$
		add.w		(Box_w,a1),d2
		cmp.w		d0,d2
		ble.b		2$
	;vertical
		move.w	(Box_y,a1),d2
		cmp.w		d1,d2
		bgt.b		2$
		add.w		(Box_h,a1),d2
		cmp.w		d1,d2
		ble.b		2$
	;YES !!! SNAP
		move.l	a1,d0
		move.l	d0,d1					;For recursion
		bra.b		3$
2$		moveq		#0,d0
3$		movem.l	(a7)+,d2				;For flags
		rts

	;An UPDOWN or LEFTRIGHT box
1$		move.l	d2,-(a7)
	;horizontal
		move.w	(Box_sx1,a1),d2
		sub.w		(DragTolX1,pc),d2
		cmp.w		d0,d2
		bgt.b		5$
		move.w	(Box_sx2,a1),d2
		add.w		(DragTolX1,pc),d2
		add.w		(DragTolX2,pc),d2
		cmp.w		d0,d2
		blt.b		5$
	;vertical
		move.w	(Box_sy1,a1),d2
		sub.w		(DragTolY1,pc),d2
		cmp.w		d1,d2
		bgt.b		5$
		move.w	(Box_sy2,a1),d2
		add.w		(DragTolY1,pc),d2
		add.w		(DragTolY2,pc),d2
		cmp.w		d1,d2
		blt.b		5$
	;YES !!! Drag Bar
		move.l	(a7)+,d2
		move.l	a1,d0
		move.l	d0,d1					;For recursion
		rts

	;Check children
5$		move.l	(a7)+,d2
		movem.l	a1/d0,-(a7)
		movea.l	(Box_ChildA,a1),a1
		bsr		PhysWin_WhereIs
		movem.l	(a7)+,a1/d0
		beq.b		4$
	;d1 = box
		move.l	d1,d0					;For recursion
		rts

4$		movea.l	(Box_ChildB,a1),a1
		bra		PhysWin_WhereIs

	;***
	;Message handler for MOUSEBUTTONS class IntuiMsg
	;This handler
	;a0 = PW
	;a1 = msg
	;-> d0 = msg if not right mousebutton or snap message or NULL (flags)
	;***
PhysWin_HandleMouseButtons:
		cmpi.w	#SELECTDOWN,(im_Code,a1)
		beq.b		5$
19$	bsr		ActivateGadget		;<------- Activate the window when a mouse button is pressed
		move.l	a1,d0
		rts

5$		movem.l	d2-d6/a2-a4,-(a7)
		movea.l	a0,a2					;PW
		move.w	(im_MouseX,a1),d2
		move.w	(im_MouseY,a1),d3
 IFD D20
 		CALLGT	GT_ReplyIMsg
 ENDC
 IFND D20
		CALLEXEC	ReplyMsg
 ENDC
		move.w	d2,d0
		move.w	d3,d1
		movea.l	a2,a0
		movea.l	(PhysWin_Box,a0),a1
		bsr		PhysWin_WhereIs
		beq.b		3$

	;Snap or Drag
		movea.l	d0,a3					;Box
		cmpi.b	#ATOMIC,(Box_Type,a3)
		bne.b		2$

	;Snap
		moveq		#im_SIZEOF,d0
		moveq		#0,d1
		bsr		AllocMem
		beq.b		1$
		movea.l	d0,a0
		moveq		#-1,d0
		move.l	d0,(im_Class,a0)
		move.l	a3,(im_IAddress,a0)
		move.w	d2,(im_MouseX,a0)
		move.w	d3,(im_MouseY,a0)
		moveq		#PWMSG_SNAP,d0
		move.w	d0,(im_Code,a0)
		move.l	a0,d0
		bra.b		3$

1$		moveq		#0,d0
3$		movea.l	a2,a0
		movem.l	(a7)+,d2-d6/a2-a4
		movea.l	d0,a1
		bra.b		19$

	;--- Drag part ---
	;a2 = PW
	;a3 = box
	;d2 = MouseX
	;d3 = MouseY
	;Drag
2$		movea.l	(PhysWin_Window,a2),a4
		movea.l	(wd_RPort,a4),a1
		moveq		#RP_COMPLEMENT,d0
		CALLGRAF	SetDrMd
		movea.l	a2,a0
		movea.l	a3,a1
		moveq		#0,d1
		bsr		_PhysWin_DrawBoxLine
		move.w	d2,d4
		move.w	d3,d5
		move.w	(Box_sx1,a3),d6
		cmpi.b	#LEFTRIGHT,(Box_Type,a3)
		beq.b		13$
	;UPDOWN
		move.w	(Box_sy1,a3),d6

13$	ori.w		#REPORTMOUSE,(wd_Flags+2,a4)
		bra.b		9$

	;Wait for message
	;a4 = window
4$		movea.l	(WinPort,pc),a0
		CALLEXEC	WaitPort
9$		movea.l	(WinPort,pc),a0
 IFD D20
		CALLGT	GT_GetIMsg
 ENDC
 IFND D20
		CALLEXEC	GetMsg
 ENDC
		tst.l		d0
		beq.b		4$

	;Check if it is a message for the right window
		movea.l	d0,a1
		cmpa.l	(im_IDCMPWindow,a1),a4
		bne.b		4$

		cmpi.l	#MOUSEBUTTONS,(im_Class,a1)
		beq.b		6$
		cmpi.l	#MOUSEMOVE,(im_Class,a1)
		beq		7$
8$
 IFD D20
 		CALLGT	GT_ReplyIMsg
 ENDC
 IFND D20
		CALLEXEC	ReplyMsg
 ENDC
		bra.b		9$

	;MOUSEBUTTONS
6$		cmpi.w	#MENUDOWN,(im_Code,a1)
		beq		12$
		cmpi.w	#SELECTUP,(im_Code,a1)
		bne.b		8$
	;End drag
		bsr		_PhysWin_RelMove

	;Check if we did not drag too far
		cmpi.b	#LEFTRIGHT,(Box_Type,a3)
		beq.b		16$
	;UPDOWN
		move.w	(Box_y,a3),d0
		add.w		(SizeTolY,pc),d0
		cmp.w		(Box_sy1,a3),d0
		bgt		18$					;Cancel
		sub.w		(SizeTolY,pc),d0
		sub.w		(SizeTolY,pc),d0
		add.w		(Box_h,a3),d0
		cmp.w		(Box_sy1,a3),d0
		blt		18$					;Cancel
		bra.b		17$
16$	move.w	(Box_x,a3),d0
		add.w		(SizeTolX,pc),d0
		cmp.w		(Box_sx1,a3),d0
		bgt		18$					;Cancel
		sub.w		(SizeTolX,pc),d0
		sub.w		(SizeTolX,pc),d0
		add.w		(Box_w,a3),d0
		cmp.w		(Box_sx1,a3),d0
		blt.b		18$					;Cancel
17$	moveq		#1,d1					;a1 = still equal to box (_RelMove)
		bsr		_PhysWin_DrawBoxLine
		cmpi.b	#LEFTRIGHT,(Box_Type,a3)
		beq.b		10$

	;UPDOWN box
		move.w	(Box_sy1,a3),d5
		sub.w		(Box_y,a3),d5
		ext.l		d5
		mulu.w	#1000,d5
		divu.w	(Box_h,a3),d5		;d5 = share for child A
		move.w	d5,(Box_ShareA,a3)
		bra.b		11$


	;LEFTRIGHT box
10$	move.w	(Box_sx1,a3),d4
		sub.w		(Box_x,a3),d4
		ext.l		d4
		mulu.w	#1000,d4
		divu.w	(Box_w,a3),d4
		move.w	d4,(Box_ShareA,a3)

11$	move.b	#1,(Box_Dirty,a3)
		movea.l	(wd_RPort,a4),a1
		moveq		#RP_JAM2,d0
		CALLGRAF	SetDrMd
		movea.l	a2,a0
		movea.l	a3,a1
		bsr		PhysWin_CleanBoxesGadgets

		andi.w	#~REPORTMOUSE,(wd_Flags+2,a4)
		bra		1$						;The end

	;MOUSEMOVE
7$		bsr		_PhysWin_RelMove
		moveq		#0,d1
		bsr		_PhysWin_DrawBoxLine
		bra		9$

	;Cancel drag operation
12$	bsr		_PhysWin_RelMove
18$	cmpi.b	#LEFTRIGHT,(Box_Type,a3)
		beq.b		14$
	;UPDOWN
		move.w	d6,(Box_sy1,a3)
		move.w	d6,(Box_sy2,a3)
		bra.b		15$
14$	move.w	d6,(Box_sx1,a3)
		move.w	d6,(Box_sx2,a3)
15$	moveq		#RP_JAM2,d0
		movea.l	(wd_RPort,a4),a1
		CALLGRAF	SetDrMd
		andi.w	#~REPORTMOUSE,(wd_Flags+2,a4)
		bra		1$						;The end

	;a1 = msg
	;-> a0 = PW
	;-> a1 = box
_PhysWin_RelMove:
		move.w	(im_MouseX,a1),d2
		move.w	(im_MouseY,a1),d3
 IFD D20
 		CALLGT	GT_ReplyIMsg
 ENDC
 IFND D20
		CALLEXEC	ReplyMsg
 ENDC
		movea.l	a2,a0
		movea.l	a3,a1
		moveq		#0,d1
		bsr		_PhysWin_DrawBoxLine
		sub.w		d2,d4					;Make delta movements
		sub.w		d3,d5
		cmpi.b	#LEFTRIGHT,(Box_Type,a3)
		beq.b		1$
	;UPDOWN
		moveq		#0,d4
		bra.b		2$
1$		moveq		#0,d5
2$		sub.w		d4,(Box_sx1,a3)
		sub.w		d4,(Box_sx2,a3)
		sub.w		d5,(Box_sy1,a3)
		sub.w		d5,(Box_sy2,a3)
		move.w	d2,d4
		move.w	d3,d5
		movea.l	a2,a0
		movea.l	a3,a1
		rts

	;***
	;Message handler for NEWSIZE or CHANGEWINDOW class IntuiMsg
	;a0 = PW
	;a1 = msg
	;-> d0 = msg if not ok or NULL (flags)
	;***
PhysWin_HandleNewSize:
		move.l	a0,-(a7)
 IFD D20
 		CALLGT	GT_ReplyIMsg
 ENDC
 IFND D20
		CALLEXEC	ReplyMsg
 ENDC
 IFD D20
		movea.l	(a7),a0
		bsr		_PhysWin_RemoveGadgets
 ENDC
		movea.l	(a7),a1
		movea.l	(PhysWin_Window,a1),a1
		movea.l	(wd_RPort,a1),a1
		GETPEN	LWBackgroundPen,d0,a6
		CALLGRAF	SetRast
		movea.l	(a7),a0
		movea.l	(PhysWin_Window,a0),a0
		CALLINT	RefreshWindowFrame
		movea.l	(a7),a0
		movea.l	(PhysWin_Box,a0),a0
		bsr		Box_FullSize
		movea.l	(a7),a0
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets
		movea.l	(a7)+,a0
		bsr		SetGadgetState
		moveq		#0,d0
		rts

	;***
	;Reply an IntuiMsg
	;This function checks if the message is a PhysWin message first
	;a0 = PW
	;a1 = msg (may be NULL)
	;***
PhysWin_ReplyMsg:
		move.l	a1,d0
		beq.b		3$
		move.l	a0,-(a7)
		moveq		#-1,d0
		cmp.l		(im_Class,a1),d0
		beq.b		1$
	;Normal IntuiMsg
 IFD D20
 		CALLGT	GT_ReplyIMsg
 ENDC
 IFND D20
		CALLEXEC	ReplyMsg
 ENDC
		bra.b		2$
	;PhysWin message
1$		moveq		#im_SIZEOF,d0
		bsr		FreeMem
2$		movea.l	(a7)+,a0
3$		rts

	;***
	;Free all boxes in this PW
	;a0 = PW
	;***
_PhysWin_FreeBoxes:
		move.l	(PhysWin_Box,a0),d0
		beq.b		1$
		movem.l	a2-a3,-(a7)
		move.l	a0,-(a7)
		movea.l	(PhysWin_Box,a0),a0
		movea.l	(Box_ChildA,a0),a2
		movea.l	(Box_ChildB,a0),a3
		bsr		Box_Destructor
		movea.l	(a7)+,a0

		move.l	a2,(PhysWin_Box,a0)
		beq.b		2$
		bsr		_PhysWin_FreeBoxes

2$		move.l	a3,(PhysWin_Box,a0)
		beq.b		3$
		bsr		_PhysWin_FreeBoxes

3$		movem.l	(a7)+,a2-a3
1$		rts

	;***
	;Split an existing ATOMIC box
	;This function creates two new boxes. One of these boxes will be made the
	;parent of the existing box. The other will be the new box.
	;The returned box is the new one.
	;If there is an error, everything remains as it was before.
	;This function makes dirty boxes
	;a0 = PW
	;a1 = brother box
	;d0 = where (MAKE_LEFT,MAKE_RIGHT,MAKE_UP,MAKE_DOWN)
	;d1 = share for existing box (only used if d2 == 0)
	;d2 = number of lines or columns (d1 is used if d2 == 0)
	;-> d0 = new box or NULL (flags) if error
	;			possible errors :
	;				not enough memory
	;***
PhysWin_SplitBox:
		movem.l	d2-d5/a0/a2-a6,-(a7)

	;If number of lines or columns is not equal to 0 we have to compute
	;the share variable
		tst.l		d2
		beq.b		8$
		movea.l	(TopazFont,pc),a3
		move.w	(tf_XSize,a3),d4
		moveq		#0,d5
		lea		(Box_w,a1),a2		;Point to width in brother box
		lea		(Box_BorderLeft,a1),a6
		move.b	d0,d3					;Make copy of position
		andi.b	#1,d3
		bne.b		9$
	;Up-Down
		lea		(2,a2),a2			;Point to height in brother box
		lea		(1,a6),a6			;Point to BorderTop/BorderBottom
		move.w	(tf_YSize,a3),d4	;Get YSize instead of XSize
		moveq		#1,d5

	;Left-Right
9$		moveq		#0,d3
		move.b	(a6),d3
		add.b		(2,a6),d3			;Add border values
		add.w		(a2),d3				;Get width or height of brother box
		divu.w	d4,d3					;Divide by width or height of font
		move.w	d3,d4					;Make a copy
		subq.w	#3,d4
		cmp.w		d2,d4					;Compare with the number of lines/columns
		bge.b		10$
	;Too many lines or columns
		move.w	d4,d2					;Adjust number of lines or columns
	;Number of lines/columns is ok
10$	ext.l		d3
		add.w		d5,d2
		mulu.w	#1000,d2
		divu.w	d3,d2					;Percentage
	;Some correction factor
		addq.w	#2,d2
		add.w		d5,d2
		add.w		d5,d2
		add.w		d5,d2
		add.w		d5,d2
		add.w		d5,d2
		add.w		d5,d2

		move.w	d2,d1					;Share

8$		move.w	d0,d2					;where
		move.w	d1,d3					;share
		movea.l	a0,a2					;PW
		movea.l	a1,a3					;Brother box

	;Make parent and brother
		bsr		Box_Constructor
		beq		1$
		movea.l	d0,a4					;Parent box
		bsr		Box_Constructor
		bne.b		3$
		movea.l	a4,a0
		bsr		Box_Destructor
		bra		1$

	;We have successfully created the parent and new box
3$		movea.l	d0,a5					;New box
		move.b	#ATOMIC,(Box_Type,a5)

	;PW in two new boxes
		move.l	a2,(Box_PhysWin,a4)
		move.l	a2,(Box_PhysWin,a5)

	;Set type for parent box (LEFTRIGHT or UPDOWN)
		move.b	d2,d0					;Location for our box
		andi.b	#1,d0					;Orientation for parent box
		move.b	d0,(Box_Type,a4)

	;Set parent for parent box
		move.l	(Box_Parent,a3),(Box_Parent,a4)
		bne.b		4$
		move.l	a4,(PhysWin_Box,a2)	;We are splitting the master box
		bra.b		6$
4$		movea.l	(Box_Parent,a4),a0	;We are splitting a child box
		lea		(Box_ChildA,a0),a1	;Try this
		cmpa.l	(a1),a3
		beq.b		7$
		lea		(Box_ChildB,a0),a1	;It's the other one
7$		move.l	a4,(a1)					;New child for parent of new parent

	;Set parent for brother box and new box
6$		move.l	a4,(Box_Parent,a3)
		move.l	a4,(Box_Parent,a5)

	;Copy size from brother box to new parent box
	;(we copy four values in two)
		move.l	(Box_x,a3),(Box_x,a4)

		moveq		#0,d0
		move.b	(Box_BorderLeft,a3),d0
		add.b		(Box_BorderRight,a3),d0
		add.w		(Box_w,a3),d0
		move.w	d0,(Box_w,a4)

		moveq		#0,d0
		move.b	(Box_BorderTop,a3),d0
		add.b		(Box_BorderBottom,a3),d0
		add.w		(Box_h,a3),d0
		move.w	d0,(Box_h,a4)

	;Our boxes are dirty
		moveq		#1,d0
		move.b	d0,(Box_Dirty,a5)
		move.b	d0,(Box_Dirty,a4)
		move.b	d0,(Box_Dirty,a3)

		move.l	a5,d4					;Remember new box for return code
	;Make a5 point to Child A and a3 to Child B
	;Also make d3 the share for child A
		move.b	d2,d0					;Location for our box
		andi.b	#2,d0					;Index for child
		beq.b		5$
		exg		a3,a5
		subi.w	#1000,d3
		neg.w		d3

	;Fill in in parent box
5$		move.l	a5,(Box_ChildA,a4)
		move.l	a3,(Box_ChildB,a4)
		move.w	d3,(Box_ShareA,a4)

		move.l	d4,d0
		bra.b		2$

1$		moveq		#0,d0					;Error entry
2$		movem.l	(a7)+,d2-d5/a0/a2-a6
		rts

	;***
	;Remove a box from the box list
	;If the box is ATOMIC, the parent box is removed and the brother
	;box takes the place of the parent
	;This function does nothing if the box is LEFTRIGHT or UPDOWN
	;This function does nothing if you try to remove the master box (except
	;that the LW is unlinked)
	;This function makes dirty boxes
	;a0 = PW
	;a1 = Box
	;-> d0 = 0 (flags) if not removed
	;***
PhysWin_RemoveBox:
		clr.l		(Box_LogWin,a1)
		cmpi.b	#ATOMIC,(Box_Type,a1)
		bne		1$
		move.l	(Box_Parent,a1),d0
		beq		1$
		movem.l	a0/a2-a5,-(a7)
		movea.l	a0,a2					;PW
		movea.l	a1,a3					;Box

	;Get parent and brother boxes
		movea.l	d0,a4					;Get parent box
		move.l	(Box_ChildB,a4),d0
		cmp.l		a3,d0
		bne.b		2$
	;Wrong box
		move.l	(Box_ChildA,a4),d0
2$		movea.l	d0,a5					;Brother box

	;Move brother to parent place
		move.l	(Box_Parent,a4),(Box_Parent,a5)
		beq.b		3$
	;Normal child
		movea.l	(Box_Parent,a4),a0
		lea		(Box_ChildA,a0),a1
		cmpa.l	(a1),a4
		beq.b		5$
		lea		(Box_ChildB,a0),a1
5$		move.l	a5,(a1)
		bra.b		4$
	;We are removing a box with the parent equal to the master box
3$		move.l	a5,(PhysWin_Box,a2)

	;Give brother size of parent
4$		move.l	(Box_x,a4),(Box_x,a5)

		move.b	(Box_BorderLeft,a4),d0
		add.b		(Box_BorderRight,a4),d0
		sub.b		(Box_BorderLeft,a5),d0
		sub.b		(Box_BorderRight,a5),d0
		ext.w		d0
		add.w		(Box_w,a4),d0
		move.w	d0,(Box_w,a5)

		move.b	(Box_BorderTop,a4),d0
		add.b		(Box_BorderBottom,a4),d0
		sub.b		(Box_BorderTop,a5),d0
		sub.b		(Box_BorderBottom,a5),d0
		ext.w		d0
		add.w		(Box_h,a4),d0
		move.w	d0,(Box_h,a5)

	;Remove parent
		movea.l	a4,a0
		bsr		Box_Destructor

	;Remove old box
		movea.l	a3,a0
		bsr		Box_Destructor

	;Brother is dirty
		move.b	#1,(Box_Dirty,a5)

		movem.l	(a7)+,a0/a2-a5
		moveq		#1,d0
		rts

1$		moveq		#0,d0
		rts

	;***
	;Clean all boxes and init gadgets
	;a0 = PW
	;a1 = pointer to start box or NULL to start with master box
	;***
PhysWin_CleanBoxesGadgets:
	IFD D20
		bsr		_PhysWin_RemoveGadgets
		bsr.b		PhysWin_CleanBoxes
		bra		_PhysWin_InitGadgets
	ENDC

	;***
	;Clean all boxes starting with box
	;This function does not do anything if there is no window
	;This function computes the size of each box
	;If there are logical windows in the box they will be refreshed too
	;a0 = PW
	;a1 = pointer to start box or NULL to start with master box
	;***
PhysWin_CleanBoxes:
		move.l	(PhysWin_Window,a0),d0
		beq		1$
		movem.l	d2-d6/a2-a4,-(a7)
		move.l	a0,-(a7)
		move.l	a1,d0
		bne.b		2$
		movea.l	(PhysWin_Box,a0),a1

2$		movea.l	a1,a4
		movea.l	a4,a0
		GETPEN	BoxBackgroundPen,d0,-
		bsr		Box_ClearOuterBox
		clr.b		(Box_Dirty,a4)
		cmpi.b	#ATOMIC,(Box_Type,a4)
		beq		3$

	;Box is not ATOMIC
		movea.l	(Box_ChildA,a4),a2
		movea.l	(Box_ChildB,a4),a3
		move.w	(Box_ShareA,a4),d4

		move.w	(Box_x,a4),d0
		move.w	(Box_y,a4),d1
		move.w	(Box_w,a4),d2
		move.w	(Box_h,a4),d3

		move.w	d2,d5
		cmpi.b	#LEFTRIGHT,(Box_Type,a4)
		beq.b		4$
	;UPDOWN
		move.w	d3,d5

	;d5 = width or height
4$		ext.l		d5
		mulu.w	d4,d5
		divu.w	#1000,d5				;d5 = width or height for Child A
		move.w	d5,d6					;Remember for later

		cmpi.b	#LEFTRIGHT,(Box_Type,a4)
		beq.b		5$
		move.w	d5,d3
		bra.b		6$
5$		move.w	d5,d2

6$		movea.l	a2,a0
		bsr		Box_SetOuterBox
		movea.l	a0,a1
		movea.l	(a7),a0
		bsr		PhysWin_CleanBoxes

		move.w	(Box_x,a4),d0
		move.w	(Box_y,a4),d1
		move.w	(Box_w,a4),d2
		move.w	(Box_h,a4),d3

		cmpi.b	#LEFTRIGHT,(Box_Type,a4)
		beq.b		7$
		add.w		d5,d1
		addq.w	#1,d1
		sub.w		d6,d3
		subq.w	#1,d3

		bra.b		8$
7$		add.w		d5,d0
		addq.w	#1,d0
		sub.w		d6,d2
		subq.w	#1,d2

8$		movea.l	a3,a0
		bsr		Box_SetOuterBox
		movea.l	a0,a1
		movea.l	(a7),a0
		bsr		PhysWin_CleanBoxes

	;a4 = pointer to our box
	;a0 = PW
	;draw the line between the two boxes
		move.w	(Box_x,a4),d0
		move.w	(Box_y,a4),d1
		move.w	d0,d2
		move.w	d1,d3
		cmpi.b	#LEFTRIGHT,(Box_Type,a4)
		beq.b		9$
		add.w		d6,d1
		add.w		d6,d3
	;DEBUG
		addq.w	#1,d1
		addq.w	#1,d3
	;DEBUG
		add.w		(Box_w,a4),d2
		subq.w	#1,d2
		bra.b		10$
9$		add.w		d6,d0
		add.w		d6,d2
		add.w		(Box_h,a4),d3
		subq.w	#1,d3

10$	move.w	d0,(Box_sx1,a4)
		move.w	d1,(Box_sy1,a4)
		move.w	d2,(Box_sx2,a4)
		move.w	d3,(Box_sy2,a4)
		movea.l	a4,a1
		moveq		#1,d1
		bsr		_PhysWin_DrawBoxLine
11$	movea.l	(a7)+,a0

		movem.l	(a7)+,d2-d6/a2-a4
1$		rts

	;Box is ATOMIC, we must refresh the logical window
3$		move.l	(Box_LogWin,a4),d0
		beq.b		11$
		movea.l	d0,a0
		bsr		LogWin_AdjustRealWorld
		bsr		LogWin_ShowStatusLine
		bsr		LogWin_DefaultColRow
		bra.b		11$

	;***
	;Draw the line between two boxes
	;a0 = PW
	;a1 = box
	;d1 = 0 if dragging, 1 otherwise
	;***
_PhysWin_DrawBoxLine:
		movem.l	a3-a4,-(a7)
		movea.l	a1,a4
		movea.l	(PhysWin_Window,a0),a3
		GETPEN	BoxLinePen,d0,-
		tst.l		d1
		beq.b		2$
		move.w	(Box_sy2,a4),d1
		cmp.w		(Box_sy1,a4),d1
		beq.b		1$						;We don't draw the horizontal line
2$		movea.l	(wd_RPort,a3),a1
		CALLGRAF	SetAPen
		move.w	(Box_sx1,a4),d0
		move.w	(Box_sy1,a4),d1
		movea.l	(wd_RPort,a3),a1
		CALL		Move
		move.w	(Box_sx2,a4),d0
		move.w	(Box_sy2,a4),d1
		movea.l	(wd_RPort,a3),a1
		CALL		Draw
1$		movem.l	(a7)+,a3-a4
		rts

	;***
	;Get describe box
	;a0 = PW
	;a1 = box to start relative search
	;a2 = ptr to describe string
	;		Example : 0110
	;		scanning of string will stop with first non '0' or '1' char
	;-> d0 = box or NULL (flags) if not found
	;-> a2 = ptr after first non '0' or '1' char
	;***
PhysWin_GetBox:
		move.l	a1,d0					;Could it be this box ?
		move.b	(a2)+,d1
		beq.b		1$
		cmpi.b	#'0',d1
		bne.b		2$
	;Char is '0'
		move.l	(Box_ChildA,a1),d0
		beq.b		1$
		movea.l	d0,a1
		bsr		PhysWin_GetBox
		bra.b		1$

	;Char could be '1'
2$		cmpi.b	#'1',d1
		bne.b		1$
		move.l	(Box_ChildB,a1),d0
		beq.b		1$
		movea.l	d0,a1
		bsr		PhysWin_GetBox

1$		tst.l		d0
		rts

	;***
	;Create new box
	;a0 = PW
	;a2 = ptr to create string
	;		Example : 0110r
	;d1 = share (only used if d2 == 0)
	;d2 = number of columns or lines (if 0, this is ignored)
	;-> d0 = ptr to new box or NULL (flags) if error
	;***
PhysWin_CreateBox:
		move.l	d1,-(a7)
		movea.l	(PhysWin_Box,a0),a1
		bsr		PhysWin_GetBox
		beq.b		1$
		movea.l	d0,a1
		subq.l	#1,a2					;Ptr to create letter
		cmpi.b	#'r',(a2)
		beq.b		2$
		cmpi.b	#'l',(a2)
		beq.b		3$
		cmpi.b	#'d',(a2)
		beq.b		4$
		cmpi.b	#'u',(a2)
		beq.b		5$
		moveq		#0,d0
		bra.b		1$
	;Good
2$		moveq		#MAKE_RIGHT,d0
		bra.b		6$
3$		moveq		#MAKE_LEFT,d0
		bra.b		6$
4$		moveq		#MAKE_DOWN,d0
		bra.b		6$
5$		moveq		#MAKE_UP,d0
	;Continue
6$		move.l	(a7),d1
		bsr		PhysWin_SplitBox
	;The end
1$		movem.l	(a7)+,d1				;for flags
		rts

	;***
	;Update the newwindow structure
	;a0 = PW
	;-> d0 = ptr to window or NULL (flags)
	;***
PhysWin_UpdateNewWindow:
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a1
		move.w	(wd_LeftEdge,a1),(nw_LeftEdge+PhysWin_NewWindow,a0)
		move.w	(wd_TopEdge,a1),(nw_TopEdge+PhysWin_NewWindow,a0)
		move.w	(wd_Width,a1),(nw_Width+PhysWin_NewWindow,a0)
		move.w	(wd_Height,a1),(nw_Height+PhysWin_NewWindow,a0)
		tst.l		d0
1$		rts

	;***
	;Correct the sizes before a window is opened
	;This function makes sure that the window fits on the screen
	;Window should not be open, screen must be open
	;Screen must be initialized in NewWindow
	;NewWindow values must be correct
	;If the window is a backdrop window it is sized to full screen size
	;All registers are preserved
	;a0 = PW
	;a1 = Screen
	;***
_PhysWin_CorrectBeforeOpen:
		movem.l	a0-a2/d0-d4,-(a7)
		lea		(PhysWin_NewWindow,a0),a2
		move.l	a1,(nw_Screen,a2)
		move.w	(sc_Width,a1),d1
		move.w	(sc_Height,a1),d2
		move.l	(nw_Flags,a2),d0
		andi.l	#BACKDROP,d0
		bne.b		1$
	;Normal window
	;Compute bottom right corner
		move.w	(nw_LeftEdge,a2),d3
		add.w		(nw_Width,a2),d3
		move.w	(nw_TopEdge,a2),d4
		add.w		(nw_Height,a2),d4
		cmp.w		d3,d1
		bge.b		3$
	;Window is too wide
		clr.w		(nw_LeftEdge,a2)
		move.w	(nw_Width,a2),d3
		cmp.w		d3,d1
		bge.b		3$
	;Window is still too wide
		move.w	d1,(nw_Width,a2)
3$		cmp.w		d4,d2
		bge.b		4$
	;Window is too tall
		clr.w		(nw_TopEdge,a2)
		move.w	(nw_Height,a2),d4
		cmp.w		d4,d2
		bge.b		4$
	;Window is still too tall
		move.w	d2,(nw_Height,a2)
4$		move.l	(LN_NAME,a0),(nw_Title,a2)
		bra.b		2$

	;BACKDROP window
1$		clr.l		(nw_Title,a2)
		clr.w		(nw_LeftEdge,a2)
		moveq		#0,d4
		move.b	(sc_BarHeight,a1),d4
		move.w	d4,d0
		addq.w	#2,d0
		move.w	d0,(nw_TopEdge,a2)
		move.w	d1,(nw_Width,a2)
		sub.w		d4,d2
		subq.w	#2,d2
		move.w	d2,(nw_Height,a2)
2$		movem.l	(a7)+,a0-a2/d0-d4
		rts

	;***
	;Open a physical window
	;UserData of window will point to PhysWin
	;a0 = PhysWin
	;a1 = Screen (if null, this function will not fail but simply do nothing)
	;-> d0 = 0 if no success (flags)
	;-> a1 = screen
	;***
PhysWin_Open:
		tst.l		(PhysWin_Window,a0)
		beq.b		1$

	;Already open, everything is fine (flags are also fine)
		rts

	;Not open
1$		move.l	a1,d0
		bne.b		3$

	;There is no screen, we simulate success because the window will be
	;opened again later when there is a screen anyway
		moveq		#1,d0
		rts

	;There is a screen
3$		move.l	a1,-(a7)				;Remember screen
		bsr		_PhysWin_CorrectBeforeOpen
		move.l	a0,-(a7)

	;Open the window without a userport
		lea		(PhysWin_NewWindow,a0),a0
		movea.l	(WinPort,pc),a1
		bsr		OpenWindowShared
		movea.l	(a7),a0
		move.l	d0,(PhysWin_Window,a0)
		beq.b		2$

	;Set RastPort
		movea.l	d0,a1
		move.l	a0,(wd_UserData,a1)
		movea.l	(wd_RPort,a1),a1
		move.l	a1,-(a7)
		andi.w	#~RPF_AREAOUTLINE,(rp_Flags,a1)
		GETPEN	NormalTextPen,d0,a6
		CALLGRAF	SetAPen
		GETPEN	LWBackgroundPen,d0,a1
		movea.l	(a7),a1
		CALL		SetBPen
		movea.l	(a7)+,a1
		moveq		#RP_JAM2,d0
		CALL		SetDrMd
		movea.l	(a7),a0
		movea.l	(PhysWin_Box,a0),a0
		bsr		Box_FullSize
		movea.l	(a7),a0
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets

	IFD D20
		bsr		AddMenus
	ENDC

		moveq		#1,d0

2$		movea.l	(a7)+,a0
		movea.l	(a7)+,a1				;Screen
		rts

	;***
	;Close a physical window.
	;a0 = PhysWin
	;***
PhysWin_Close:
 IFD D20
		bsr		RemoveMenus
		bsr		_PhysWin_RemoveGadgets
 ENDC

		bsr		PhysWin_UpdateNewWindow
		beq.b		1$
		move.l	a0,-(a7)
		movea.l	d0,a0
		bsr.b		CloseWindowSafely
		movea.l	(a7)+,a0
		clr.l		(PhysWin_Window,a0)
1$		rts

	;***
	;Close a window safely
	;a0 = window
	;***
CloseWindowSafely:
		bsr.b		StripMessages
		CALLINT	CloseWindow
		rts

	;***
	;Modify IDCMP safely
	;a0 = window
	;d0 = IDCMP
	;***
ModifyIDCMPSafely:
		bsr.b		StripMessages

		tst.l		d0
		beq.b		1$
		move.l	(WinPort,pc),(wd_UserPort,a0)
		CALLINT	ModifyIDCMP

1$		rts

	;***
	;Strip messages
	;Port is removed from window (port is NOT freed)
	;a0 = window
	;-> d0 = unchanged
	;-> a0 = unchanged
	;***
StripMessages:
		movem.l	d0/a0/a2-a3,-(a7)
		movea.l	a0,a3						;Remember window
		move.l	(wd_UserPort,a3),d0
		beq.b		3$
		movea.l	d0,a2						;Remember msgport

		bsr		Forbid

	;Strip all messages
		lea		(MP_MSGLIST+LH_HEAD,a2),a1

1$		movea.l	(a1),a1					;Succ
		tst.l		(a1)						;Succ
		beq.b		2$
		cmpa.l	(im_IDCMPWindow,a1),a3
		bne.b		1$

	;Yes, it is the right window
		move.l	a1,-(a7)
		CALLEXEC	Remove
		movea.l	(a7),a1
		CALL		ReplyMsg
		movea.l	(a7)+,a1
		bra.b		1$

	;Clear userport so Intuition will not free it
2$		movea.l	a3,a0
		clr.l		(wd_UserPort,a0)
		moveq		#0,d0

	;Tell Intuition to stop sending more messages
		CALLINT	ModifyIDCMP

		bsr		Permit

3$		movem.l	(a7)+,d0/a0/a2-a3
		rts

	;***
	;Open a window with a shared port
	;a0 = NewWindow
	;a1 = port
	;-> d0 = pointer to window (or NULL, flags if error)
	;***
OpenWindowShared:
		movem.l	a2-a3/d2-d3,-(a7)
		movea.l	a0,a2					;NewWindow
		movea.l	a1,a3					;Port

	;Open the window without a userport
		move.l	(nw_IDCMPFlags,a2),d2
	;Open without port (share IDCMP port)
		clr.l		(nw_IDCMPFlags,a2)

	IFD D20
		lea		(OpenWinTags,pc),a1
		CALLINT	OpenWindowTagList
	ENDC
	IFND D20
		CALLINT	OpenWindow
	ENDC
		move.l	d0,d3
		beq.b		1$

	;Small delay for safety reasons
		moveq		#10,d1
		CALLDOS	Delay

	;Restore IDCMP flags in newwindow structure (for later)
		move.l	d2,(nw_IDCMPFlags,a2)

	;Compute IDCMP signal set
		movea.l	d3,a1					;Pointer to window
		move.l	a3,(wd_UserPort,a1)

		move.l	d2,d0
		movea.l	a1,a0
		CALLINT	ModifyIDCMP

		move.l	d3,d0

1$		movem.l	(a7)+,a2-a3/d2-d3
		rts

	;***
	;Activate the window.
	;a0 = PhysWin
	;***
PhysWin_ActivateWindow:
		move.l	a0,-(a7)
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0
		CALLINT	ActivateWindow
1$		movea.l	(a7)+,a0
		rts

	;***
	;Move a physical window. This function works if the window is open or
	;closed.
	;a0 = PhysWin
	;d0 = x
	;d1 = y
	;***
PhysWin_Move:
		move.w	d0,(nw_LeftEdge+PhysWin_NewWindow,a0)
		move.w	d1,(nw_TopEdge+PhysWin_NewWindow,a0)
		tst.l		(PhysWin_Window,a0)
		beq.b		1$
		move.l	a0,-(a7)
		movea.l	(PhysWin_Window,a0),a0
		sub.w		(wd_LeftEdge,a0),d0
		sub.w		(wd_TopEdge,a0),d1
		CALLINT	MoveWindow
		movea.l	(a7)+,a0
1$		rts

	;***
	;Size a physical window. This function works if the window is open or
	;closed.
	;a0 = PhysWin
	;d0 = w
	;d1 = h
	;***
PhysWin_Size:
		move.w	d0,(nw_Width+PhysWin_NewWindow,a0)
		move.w	d1,(nw_Height+PhysWin_NewWindow,a0)
		tst.l		(PhysWin_Window,a0)
		beq.b		1$
		move.l	a0,-(a7)
		movea.l	(PhysWin_Window,a0),a0
		sub.w		(wd_Width,a0),d0
		sub.w		(wd_Height,a0),d1
		CALLINT	SizeWindow
		movea.l	(a7)+,a0
1$		rts

;	;***
;	;Modify IDCMP for a physical window. This function works if the window
;	;is open or closed.
;	;a0 = PhysWin
;	;d0 = IDCMP
;	;***
;PhysWin_ModifyIDCMP:
;		move.l	d0,(nw_IDCMPFlags+PhysWin_NewWindow,a0)
;		tst.l		(PhysWin_Window,a0)
;		beq.b		1$
;		move.l	a0,-(a7)
;		movea.l	(PhysWin_Window,a0),a0
;		bsr		ModifyIDCMPSafely
;		movea.l	(a7)+,a0
;1$		rts

	;***
	;Modify Flags for a physical window. To make the changes effective you
	;must close and open the window.
	;is open or closed.
	;a0 = PhysWin
	;d0 = Flags
	;***
PhysWin_ModifyFlags:
		move.l	d0,(nw_Flags+PhysWin_NewWindow,a0)
		rts

	;***
	;Move a window to another screen. This function works if the window
	;is open or closed. Note that the contents of the window is probably
	;lost when the window was open. Except for logical windows, their
	;contents remains correct.
	;a0 = PhysWin
	;d0 = Screen
	;-> d0 = 0 if no success (flags)
	;***
PhysWin_ChangeScreen:
		move.l	d0,-(a7)
		move.w	#CUSTOMSCREEN,(nw_Type+PhysWin_NewWindow,a0)
		bsr		PhysWin_Close
		movea.l	(a7)+,a1
		bra		PhysWin_Open

	;***
	;Get rastport for a window.
	;a0 = PhysWin
	;-> d0 = RastPort or 0 (flags)
	;***
PhysWin_GetRastPort:
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	(wd_RPort,a1),d0
1$		rts

	;***
	;Get qualifier for the last character.
	;a0 = PhysWin
	;-> d0 = qualifier
	;***
PhysWin_GetQual:
		moveq		#0,d0
		move.w	(PhysWin_LastQualifier,a0),d0
		rts

	;***
	;Get a character.
	;This function will do nothing if PowerVisor is in hold mode (returns 0)
	;a0 = PhysWin
	;-> d0 = char
	;***
PhysWin_GetKey:
		movem.l	a2-a4,-(a7)
		movea.l	a0,a2					;PhysWin
		move.l	(PhysWin_Window,a2),d0
		bne.b		1$
		movem.l	(a7)+,a2-a4
		rts
1$		movea.l	d0,a3					;Window
		move.w	#-1,(PhysWin_LastCode,a2)

2$		cmpi.w	#-1,(PhysWin_LastCode,a2)
		bne.b		9$
		bsr		AllSignals
		or.l		(PVBreakSigSet),d0
		CALLEXEC	Wait
		move.l	d0,d1
		bsr		HandleSignals

	;Check break
		move.l	d1,d0
		and.l		(PVBreakSigSet),d0
		beq.b		2$
		bsr		FuncGetActive
		cmp.l		(LockWin,pc),d0
		bne.b		3$
		clr.w		(PhysWin_LastCode,a2)
		bra.b		2$

	;The break was for another logical window, we must clear it
	;since it is to be ignored
3$		bsr		ClearBreakSig
		bra.b		2$

	;The end !
9$		moveq		#0,d0
		movea.l	a2,a0
		move.w	(PhysWin_LastCode,a2),d0
		movem.l	(a7)+,a2-a4
		rts

	;***
	;Handle a message for this physical window, if the message is not
	;understood it is returned
	;a0 = PW
	;d0 = Message
	;-> d0 = 0 if correctly handled otherwise pointer to message (flags)
	;***
PhysWin_HandleMsg:
		movem.l	a0/d1,-(a7)
		movea.l	d0,a1
		bsr.b		1$

		tst.l		d0
		movem.l	(a7)+,a0/d1
		rts

	;This must be a subroutine!
1$
	IFD D20
		cmpi.l	#CHANGEWINDOW,(im_Class,a1)
	ENDC
	IFND D20
		cmpi.l	#NEWSIZE,(im_Class,a1)
	ENDC
		beq		PhysWin_HandleNewSize
		cmpi.l	#MOUSEBUTTONS,(im_Class,a1)
		beq		PhysWin_HandleMouseButtons
	;It is not a CHANGEWINDOW, NEWSIZE or MOUSEBUTTONS
	;d0 = still equal to pointer to message
		rts

;==================================================================================
;
; END PhysWindow object
;
;==================================================================================

;==================================================================================
;
; LogWindow object
;
;==================================================================================

	;LogWin_Buffer is a pointer to a block of pointers to lines.
	;The strings are NULL terminated. Each line is LogWin_NumColumns+2 bytes
	;long. The first char in each line is an attribute for the current line
	;The last pointer to the lines is NULL.
	;The size of the block of screen buffer lines is thus
	;(LogWin_NumLines+1)*4 bytes.

	;--- Relative coordinates for scroll boxes
	;the index in this table can be computed as follows :
	;	3210 <= nibble (4 bits) describing index in this table
	;	bit 3 : true if box touches Left side
	;	bit 2 : true if box touches Right side
	;	bit 1 : true if box touches Upper side
	;	bit 0 : true if box touches Down side
	;one element in this table contains <x1> <y1> <x2> <y2>
ScrollBoxes:
		dc.b	2,2,5,5			;lrud
		dc.b	2,4,5,7			;lruD
		dc.b	2,0,5,3			;lrUd
		dc.b	2,0,5,7			;lrUD

		dc.b	4,2,7,5			;lRud
		dc.b	4,4,7,7			;lRuD
		dc.b	4,0,7,3			;lRUd
		dc.b	4,0,7,7			;lRUD

		dc.b	0,2,3,5			;Lrud
		dc.b	0,4,3,7			;LruD
		dc.b	0,0,3,3			;LrUd
		dc.b	0,0,3,7			;LrUD

		dc.b	0,2,7,5			;LRud
		dc.b	0,4,7,7			;LRuD
		dc.b	0,0,7,3			;LRUd
		dc.b	0,0,7,7			;LRUD

	;***
	;Create a logical window.
	;a0 = PhysWin
	;a1 = Name
	;a2 = Box
	;d0 = col (-1 for autoscale)
	;d1 = row (-1 for autoscale)
	;-> d0 = ptr to logical window (or null,flags if error)
	;***
LogWin_Constructor:
		movem.l	a3/d4-d5,-(a7)
		move.l	d0,d4
		move.l	d1,d5
		movem.l	a0-a1,-(a7)
		suba.l	a3,a3
		moveq		#LogWin_SIZE,d0
		bsr		AllocClear
		beq		1$
		movea.l	d0,a3
		movem.l	(a7),a0-a1
		moveq		#0,d0
	;Compute length of string + 1
3$		addq.w	#1,d0
		tst.b		(a1)+
		bne.b		3$
		bsr		AllocClear
		beq		1$
	;Everything is fine
		movem.l	(a7),a0-a1
		movea.l	d0,a0
4$		move.b	(a1)+,(a0)+
		bne.b		4$
		movem.l	(a7)+,a0-a1
		move.l	d0,(LN_NAME,a3)		;Copy of name
		move.w	#LWF_SCREEN|LWF_DIRTY,(LogWin_Flags+2,a3)
		move.l	a0,(LogWin_PhysWin,a3)
		move.l	a2,(LogWin_Box,a3)
		lea		(DefaultSnapHandler,pc),a1
		move.l	a1,(LogWin_SnapHandler,a3)
		lea		(DefaultRefreshHandler,pc),a1
		move.l	a1,(LogWin_RefreshHandler,a3)
	IFD D20
		lea		(DefaultScrollHandler,pc),a1
		move.l	a1,(LogWin_ScrollHandler,a3)
		lea		(LogWin_UpdateScrollBar,pc),a1
		move.l	a1,(LogWin_CreateSBHandler,a3)
	ENDC
		move.l	a3,(Box_LogWin,a2)
		clr.l		(Box_BorderLeft,a2)	;Four values in one!
		moveq		#-1,d0
		move.w	d0,(LogWin_HiLine,a3)
		move.w	(TopBorder,pc),d0
		move.b	d0,(LogWin_TopBorder,a3)
		movea.l	a3,a1
		lea		(PhysWin_LWList,a0),a0
		CALLEXEC	AddHead
		movea.l	a3,a0
		lea		(TextAttrib,pc),a1
		move.w	(ta_YSize,a1),d0
		move.b	(ta_Style,a1),d1
		move.b	(ta_Flags,a1),d2
		ori.b		#FPF_DESIGNED,d2
		lea		(TopazName,pc),a1
		bsr		LogWin_SetFont
		bsr		LogWin_AdjustRealWorld
		move.l	d4,d0
		move.l	d5,d1
		bsr		LogWin_SetColRow
		beq.b		1$
		move.l	a0,d0
	;The end
2$		movem.l	(a7)+,a3/d4-d5
		rts

	;Error allocating memory
1$		movea.l	a3,a0
		bsr		LogWin_Destructor
		movem.l	(a7)+,a0-a1
		moveq		#0,d0
		bra.b		2$

	;***
	;Activate a logical window
	;a0 = LW
	;***
_LogWin_Activate:
		move.b	#1,(LogWin_Active,a0)
		bsr		SetGadgetState
		bra		LogWin_ShowStatusLine

	;***
	;Desactivate a logical window
	;a0 = LW
	;***
_LogWin_Desactivate:
		clr.b		(LogWin_Active,a0)
		bra		LogWin_ShowStatusLine

	;***
	;Set default col/row.
	;a0 = LW
	;***
LogWin_DefaultColRow:
		move.w	(LogWin_ocol,a0),d0
		move.w	(LogWin_orow,a0),d1

	;***
	;Set the number of columns and rows in the logical window.
	;This function checks if containing box is dirty and acts accordingly
	;If d0 or d1 == 0 this function will recompute the window dimensions
	;and replace d0 and d1 by the maximum visible number of columns
	;and rows (this feature is mainly for hold mode)
	;a0 = LW
	;d0 = col (-1 for autoscaling) (0 for maximum number)
	;d1 = row (-1 for autoscaling) (0 for maximum number)
	;-> d0 = 0 if no success (flags)
	;***
LogWin_SetColRow:
		move.w	d0,(LogWin_ocol,a0)
		move.w	d1,(LogWin_orow,a0)

		bsr		LogWin_CalcVisible
		bne.b		12$

	;There is no window, set NumColumns and NumLines to dummy values
		moveq		#40,d0
		move.w	d0,(LogWin_NumColumns,a0)
		move.w	d0,(LogWin_NumLines,a0)
		rts								;Flags are still ok

12$	tst.l		d0
		bne.b		10$
		move.w	(LogWin_VisWidth,a0),d0

10$	tst.l		d1
		bne.b		11$
		move.w	(LogWin_VisHeight,a0),d0

	;Normal SetColRow
	;d0 = number of columns (!= 0)
	;d1 = number of rows (!= 0)
11$	movem.l	d2-d4,-(a7)
		move.w	(LogWin_height,a0),d4	;Remember for later
		move.w	d0,(LogWin_ocol,a0)
		move.w	d1,(LogWin_orow,a0)
		movea.l	(LogWin_Box,a0),a1
		tst.b		(Box_Dirty,a1)
		bne		5$
		cmpi.w	#-1,d0
		bne.b		1$

	;Autoscaling for columns
		move.w	(LogWin_rw,a0),d0
		ext.l		d0
		divu.w	(LogWin_FontX,a0),d0

	;No autoscaling
1$		move.w	d0,d2					;Remember NumColumns
		cmpi.w	#-1,d1
		bne.b		2$

	;Autoscaling for rows
		move.w	(LogWin_rh,a0),d1
		ext.l		d1
		divu.w	(LogWin_FontY,a0),d1

	;No autoscaling
2$		move.w	d1,d3					;Remember NumLines
		cmp.w		(LogWin_NumColumns,a0),d2
		bne.b		3$
		cmp.w		(LogWin_NumLines,a0),d3
		bne.b		3$
	;The number of rows and columns is the same
		bsr		_LogWin_Recalc
		move.w	(LogWin_NumLines,a0),d1
		sub.w		(LogWin_height,a0),d1
		move.w	(LogWin_Flags+2,a0),d0
	;We are now going to compute the y scroll positions in d2 (which is free
	;at this moment)
		btst		#LWB_TOTALHOME0,d0
		beq.b		8$

	;Total home is above
	;Try to keep the top visible line visible
		move.w	(LogWin_visrow,a0),d0
		move.w	d0,d2					;We assume this is right
		add.w		(LogWin_height,a0),d0
		subq.w	#1,d0					;d0 = number of last visible row
		cmp.w		d0,d3					;Compare with actual number of rows
		bge.b		5$
	;Not OK, see if we can scroll the visible window up a bit
		sub.w		d0,d3					;d3 = number of faulty rows
		move.w	d2,d0					;Top visible line
		sub.w		d3,d0					;New top visible line
		bge.b		7$
		moveq		#0,d0
7$		move.w	d0,d2					;New top visible line
		bra.b		5$

	;Total home is below
	;Try to keep the bottom visible line visible
8$		move.w	(LogWin_visrow,a0),d0
		move.w	d0,d2					;We assume this is right
		add.w		d4,d0
		subq.w	#1,d0					;d0 = number of old last visible row
		move.w	d2,d1
		add.w		(LogWin_height,a0),d1
		subq.w	#1,d1					;d1 = number of new last visible row
		cmp.w		d0,d1
		beq.b		5$
		bgt.b		9$
	;Old last visible row is not visible anymore in current scroll position
		sub.w		d0,d1					;d1 = -number of extra lines
		sub.w		d1,d2
		bra.b		5$

	;There are too many lines visible below
9$		sub.w		d0,d1					;d1 = lines too many
		sub.w		d1,d2
		bge.b		5$
		moveq		#0,d2

5$		moveq		#0,d0
		move.l	d2,d1
		bsr		LogWin_Scroll
		bra.b		6$

	;The number of rows and columns is different
3$		bsr		_LogWin_ClearBuffer
		move.w	d2,(LogWin_NumColumns,a0)
		move.w	d3,(LogWin_NumLines,a0)
		bsr		_LogWin_Recalc
		bsr		_LogWin_AllocBuffer
		beq.b		4$
		bsr		LogWin_TotalHome
6$		moveq		#1,d0
4$		movem.l	(a7)+,d2-d4
		rts

	;***
	;Remove a logical window.
	;It is removed from the logical window list in the physical window
	;It is safe to call this function with a0 == 0
	;a0 = ptr to LW
	;***
LogWin_Destructor:
		move.l	a0,d0
		beq.b		2$

		move.l	a0,-(a7)
	IFD D20
		movea.l	(LogWin_Box,a0),a0
		bsr		Box_FreeNewGadget
		clr.b		(Box_BorderRight,a0)
		movea.l	(a7),a0
	ENDC

		bsr		_LogWin_ClearBuffer
		movea.l	a0,a1
		movea.l	(LogWin_PhysWin,a1),a0
		CALLEXEC	Remove
		movea.l	(a7),a1
		move.l	(LogWin_Font,a1),d0
		beq.b		1$
		movea.l	d0,a1
		CALLGRAF	CloseFont
1$		movea.l	(a7),a1
		movea.l	(LN_NAME,a1),a1
		movea.l	a1,a0
		moveq		#0,d0
3$		addq.w	#1,d0
		tst.b		(a0)+
		bne.b		3$
		bsr		FreeMem
		movea.l	(a7),a0
		tst.b		(LogWin_Active,a0)
		beq.b		4$
	;This window was active, cycle first
		movea.l	(LogWin_PhysWin,a0),a0
		movea.l	(PhysWin_Global,a0),a0
		bsr		Global_CycleActive
4$		movea.l	(a7)+,a1
		moveq		#LogWin_SIZE,d0
		bsr		FreeMem
2$		rts

	IFD D20

	;***
	;Update scrollbar if any (scrollbar is attached to Box)
	;Note that this function does nothing if there is a scrollbar, but
	;the scrollbar is not for scrolling in the logical window (but for
	;scrolling in the source for example)
	;a0 = LW
	;***
LogWin_UpdateScrollBar:
		move.l	d2,-(a7)

		move.w	(LogWin_Flags+2,a0),d0
		btst		#LWB_PRIVATESB,d0
		bne.b		1$

	;The scrollbar must be updated according to the visible vertical
	;size of the logical window
		moveq		#0,d0
		move.w	(LogWin_visrow,a0),d0	;Top
		moveq		#0,d1
		move.w	(LogWin_NumLines,a0),d1	;Total
		moveq		#0,d2
		move.w	(LogWin_height,a0),d2	;Visible
		bsr.b		LogWin_SetSBarValue

1$		move.l	(a7)+,d2
		rts

	;***
	;Update scrollbar to a specific value (if there is a scrollbar)
	;This function also works if the logical window is LWB_PRIVATESB
	;(this is not the case for the previous function)
	;a0 = LW
	;d0 = top
	;d1 = total
	;d2 = visible
	;***
LogWin_SetSBarValue:
		movea.l	(LogWin_Box,a0),a1
		tst.l		(Box_Gadget,a1)
		beq.b		1$

		movem.l	a0/a2-a3,-(a7)
		lea		(ScrollerTags2,pc),a3
		move.l	d0,(4,a3)			;GTSC_Top
		move.l	d1,(12,a3)			;GTSC_Total
		move.l	d2,(20,a3)			;GTSC_Visible

		move.l	(Box_Gadget,a1),d0
		movea.l	(LogWin_PhysWin,a0),a1
		movea.l	(PhysWin_Window,a1),a1
		movea.l	d0,a0
		suba.l	a2,a2					;Requester
		CALLGT	GT_SetGadgetAttrsA
		movem.l	(a7)+,a0/a2-a3

1$		rts

	ENDC

	;***
	;Show scroll position in statusline
	;a0 = LW
	;***
LogWin_ShowPosition:
		move.w	(LogWin_Flags+2,a0),d0
		btst		#LWB_NOSTATUS,d0
		beq.b		4$
		rts
4$		movem.l	a0/a2-a3/d2-d6,-(a7)
		movea.l	a0,a3					;LW
		movea.l	(LogWin_PhysWin,a3),a2
		move.l	(PhysWin_Window,a2),d0
		beq		1$
		movea.l	d0,a2
		movea.l	(wd_RPort,a2),a2
		movea.l	(rp_BitMap,a2),a1
		move.b	(bm_Depth,a1),d4
	;Draw empty box, routine is the same regardless of number of bitplanes
		GETPEN	EmptyBoxPen,d0,a6
		movea.l	a2,a1
		CALLGRAF	SetAPen
		move.w	(LogWin_rx,a3),d5
		add.w		(LogWin_rw,a3),d5
		sub.w		(FontHeight,pc),d5		;#8
		subq.w	#1,d5
		move.w	d5,d0
		subq.w	#1,d5
		move.w	(LogWin_rtop,a3),d6
		move.w	d6,d1
		addq.w	#1,d1
		move.w	d0,d2
		add.w		(FontHeight,pc),d2		;#8
		move.w	(TopBorder,pc),d3
		subq.w	#4,d3
		add.w		d1,d3
		movea.l	a2,a1
		CALL		RectFill
	;Draw border round empty box
		cmpi.b	#1,d4
		beq.b		2$
	;More than one bitplane, use 3D design
		GETPEN	LeftBoxPen,d0,a1
		movea.l	a2,a1
		bsr		SetAPen
		move.w	d5,d0
		move.w	(TopBorder,pc),d1
		subq.w	#3,d1
		add.w		d6,d1
		bsr		Move
		move.w	d6,d1
		bsr		Draw
		add.w		(FontHeight,pc),d0		;#8
		addq.w	#1,d0
		bsr		Draw
		GETPEN	RightBoxPen,d0,a0
		bsr		SetAPen
		move.w	d5,d0
		add.w		(FontHeight,pc),d0		;#8
		addq.w	#1,d0
		move.w	(TopBorder,pc),d1
		subq.w	#2,d1
		add.w		d6,d1
		bsr		Draw
		move.w	d5,d0
		bsr		Draw
		bra		3$

	;Only 1 bitplane, use dithered design
2$		move.w	#%1010101010101010,(rp_LinePtrn,a2)
		GETPEN	LeftBoxPen,d0,a1
		movea.l	a2,a1
		bsr		SetAPen
		move.w	d5,d0
		move.w	(TopBorder,pc),d1
		subq.w	#3,d1
		add.w		d6,d1
		bsr		Move
		move.w	d6,d1
		bsr		Draw
		add.w		(FontHeight,pc),d0		;#8
		addq.w	#1,d0
		bsr		Draw
		GETPEN	RightBoxPen,d0,a0
		bsr		SetAPen
		move.w	d5,d0
		add.w		(FontHeight,pc),d0		;#8
		addq.w	#1,d0
		move.w	(TopBorder,pc),d1
		subq.w	#2,d1
		add.w		d6,d1
		bsr		Draw
		move.w	d5,d0
		bsr		Draw
		move.w	#%1111111111111111,(rp_LinePtrn,a2)

	;Show position in empty box (box has a scalable size)
3$		GETPEN	ShowPos3DPen,d0,a0
		CALL		SetAPen
	;Compute offset in table
		moveq		#0,d4
	;Bit 3 (Left side)
		tst.w		(LogWin_viscol,a3)
		seq		d1
		neg.b		d1
		lsl.b		#3,d1
		or.b		d1,d4
	;Bit 2 (Right side)
		move.w	(LogWin_viscol,a3),d1
		add.w		(LogWin_width,a3),d1
		cmp.w		(LogWin_NumColumns,a3),d1
		seq		d1
		neg.b		d1
		lsl.b		#2,d1
		or.b		d1,d4
	;Bit 1 (Upper side)
		tst.w		(LogWin_visrow,a3)
		seq		d1
		neg.b		d1
		lsl.b		#1,d1
		or.b		d1,d4
	;Bit 0 (Down side)
		move.w	(LogWin_visrow,a3),d1
		add.w		(LogWin_height,a3),d1
		cmp.w		(LogWin_NumLines,a3),d1
		seq		d1
		neg.b		d1
		or.b		d1,d4
	;d4 = number of box coordinates
		lsl.w		#2,d4					;d4 = offset in ScrollBoxes
		lea		(ScrollBoxes,pc),a0
		lea		(0,a0,d4.w),a0		;a0 = ptr to (<x1> <y1> <x2> <y2>).L
		addq.w	#1,d5
		addq.w	#1,d6
		move.w	d5,d0
		move.w	d6,d1
		move.w	d5,d2
		move.w	d6,d3
		moveq		#0,d4
		move.b	(a0)+,d4
		add.w		d4,d0
		move.b	(a0)+,d4
		add.w		d4,d1
		move.b	(a0)+,d4
		add.w		d4,d2
		move.b	(a0)+,d4
		add.w		d4,d3
		movea.l	a2,a1
		CALL		RectFill
		GETPEN	NormalTextPen,d0,a1
		movea.l	a2,a1
		CALL		SetAPen

	;The end
1$		movem.l	(a7)+,a0/a2-a3/d2-d6
		rts

	;***
	;Draw on the rastport and preserve registers
	;d0 = x
	;d1 = y
	;a6 = graph
	;a1 = rp
	;***
Draw:
		movem.l	d0-d1/a1,-(a7)
		CALL		Draw
		movem.l	(a7)+,d0-d1/a1
		rts

	;***
	;Move on the rastport and preserve registers
	;d0 = x
	;d1 = y
	;a6 = graph
	;a1 = rp
	;***
Move:
		movem.l	d0-d1/a1,-(a7)
		CALL		Move
		movem.l	(a7)+,d0-d1/a1
		rts

	;***
	;Move on the rastport and preserve registers
	;d0 = pen
	;a6 = graph
	;a1 = rp
	;***
SetAPen:
		movem.l	d0-d1/a1,-(a7)
		CALL		SetAPen
		movem.l	(a7)+,d0-d1/a1
		rts

	;***
	;Set window title
	;a0 = LW
	;a1 = pointer to title
	;***
LogWin_SetWindowTitle:
		move.l	a1,(LogWin_Title,a0)

	;***
	;Show statusline for logical window
	;a0 = LW
	;***
LogWin_ShowStatusLine:
		move.w	(LogWin_Flags+2,a0),d0
		btst		#LWB_NOSTATUS,d0
		bne.b		7$
		movea.l	(LogWin_Box,a0),a1
		tst.b		(Box_Dirty,a1)
		beq.b		6$
7$		rts
6$		movem.l	a0/a2-a3/d2-d4,-(a7)
		movea.l	a0,a3					;LW
		movea.l	(LogWin_PhysWin,a3),a2
		move.l	(PhysWin_Window,a2),d0
		beq		1$
		movea.l	d0,a2
		movea.l	(wd_RPort,a2),a2
		movea.l	(rp_BitMap,a2),a1
		move.b	(bm_Depth,a1),d4

	;Draw bar, routine is the same regardless of number of bitplanes
		GETPEN	InActivePen,d0,a1
		movea.l	a2,a1
		tst.b		(LogWin_Active,a3)
		beq.b		3$
	;active
		GETPEN	ActivePen,d0,a6
	;not active
3$		CALLGRAF	SetAPen
		move.w	(LogWin_rx,a3),d0
		move.w	(LogWin_rtop,a3),d1
		move.w	d0,d2
		add.w		(LogWin_rw,a3),d2
		subq.w	#1,d2
		move.w	(TopBorder,pc),d3
		subq.w	#3,d3
		add.w		d1,d3
		addq.w	#1,d0
		addq.w	#1,d1
		movea.l	a2,a1
		CALL		RectFill

	;Draw 3D lines round bar
	;black
		GETPEN	BottomRight3DPen,d0,a1
		movea.l	a2,a1
		bsr		SetAPen
		move.w	(LogWin_rx,a3),d0
		move.w	(TopBorder,pc),d1
		subq.w	#2,d1
		add.w		(LogWin_rtop,a3),d1
		bsr		Move
		add.w		(LogWin_rw,a3),d0
		subq.w	#1,d0
		bsr		Draw
	;white
		GETPEN	TopLeft3DPen,d0,a0
		bsr		SetAPen
		move.w	(LogWin_rx,a3),d0
		bsr		Move
		move.w	(LogWin_rtop,a3),d1
		bsr		Draw
		add.w		(LogWin_rw,a3),d0
		subq.w	#1,d0
		bsr		Draw

	;Draw text
		GETPEN	StatusTextInActivePen,d0,a0

		tst.b		(LogWin_Active,a3)
		beq.b		8$
	;active
		GETPEN	StatusTextActivePen,d0,-
	;non active
8$		bsr		SetAPen
		moveq		#RP_JAM1,d0
		CALL		SetDrMd

	;Prepare region and print the window title
	;Rectangle = MinX, MinY, MaxX, MaxY
		move.l	a4,-(a7)
		lea		(-8,a7),a7

		CALL		NewRegion
		tst.l		d0
		beq		9$
		movea.l	d0,a4

		movea.l	(TopazFont,pc),a0
		movea.l	a2,a1
		CALL		SetFont
		move.w	(LogWin_rx,a3),d0
		addq.w	#6,d0
		move.w	d0,(a7)					;Init MinX in Rectangle
		move.w	(LogWin_rtop,a3),d1
		move.w	d1,(2,a7)				;Init MinY in Rectangle
		movea.l	(TopazFont,pc),a0
		add.w		(tf_Baseline,a0),d1
		addq.w	#1,d1
		movea.l	a2,a1
		CALL		Move

		move.w	(LogWin_rx,a3),d0
		add.w		(LogWin_rw,a3),d0
		sub.w		(FontHeight,pc),d0		;#8
		subq.w	#1,d0
		move.w	d0,(4,a7)				;Init MaxX in Rectangle
		move.w	(TopBorder,pc),d0
		subq.w	#3,d0
		add.w		(LogWin_rtop,a3),d0
		move.w	d0,(6,a7)				;Init MaxY in Rectangle

		movea.l	a4,a0						;Region
		movea.l	a7,a1						;Rectangle
		CALL		OrRectRegion

		movea.l	(rp_Layer,a2),a0		;Layer
		movea.l	a4,a1						;Region
		CALLLAY	InstallClipRegion

	;Really print the title
	;Compute the length of the line
		movea.l	(LN_NAME,a3),a0
		moveq		#-1,d0
4$		addq.w	#1,d0
		tst.b		(a0)+
		bne.b		4$

		movea.l	(LN_NAME,a3),a0
		movea.l	a2,a1
		CALLGRAF	Text

	;Print the extra title if there is one
		move.l	(LogWin_Title,a3),d0
		beq.b		10$
	;Yes, print colon first
		lea		(MesColon,pc),a0
		movea.l	a2,a1
		moveq		#3,d0
		CALL		Text

		movea.l	(LogWin_Title,a3),a0
		moveq		#-1,d0
11$	addq.w	#1,d0
		tst.b		(a0)+
		bne.b		11$

		movea.l	(LogWin_Title,a3),a0
		movea.l	a2,a1
		CALL		Text

10$	movea.l	(rp_Layer,a2),a0		;Layer
		suba.l	a1,a1						;Region
		CALLLAY	InstallClipRegion

		movea.l	a4,a0
		CALLGRAF	DisposeRegion

9$		lea		(8,a7),a7
		movea.l	(a7)+,a4
		moveq		#RP_JAM2,d0
		movea.l	a2,a1
		CALL		SetDrMd

	;The end
1$		movem.l	(a7)+,a0/a2-a3/d2-d4

	IFD D20
		bsr		LogWin_UpdateScrollBar
	ENDC
		bra		LogWin_ShowPosition

	;***
	;Clear the logical window
	;a0 = LW
	;***
LogWin_ClearWindow:
		movem.l	a0/a2-a3,-(a7)
		movea.l	a0,a3
		movea.l	(LogWin_PhysWin,a3),a0
		bsr		PhysWin_GetRastPort
		beq.b		1$
		movea.l	d0,a2
		GETPEN	LWBackgroundPen,d0,a1
		movea.l	a2,a1
		CALLGRAF	SetAPen

		move.w	(LogWin_rx,a3),d0
		move.w	(LogWin_ry,a3),d1
		move.w	(LogWin_rw,a3),d2
		add.w		d0,d2
		subq.w	#1,d2
		move.w	(LogWin_rh,a3),d3
		add.w		d1,d3
		subq.w	#1,d3

		movea.l	a2,a1							;RPort
		CALL		RectFill
		GETPEN	NormalTextPen,d0,a1
		movea.l	a2,a1
		CALL		SetAPen
1$		movem.l	(a7)+,a0/a2-a3
		rts

	;***
	;Set an attribute for a logical window
	;All registers are preserved
	;a2 = rastport (may be 0)
	;d0 = attribute (byte)
	;***
_LogWin_SetAttribute:
		movem.l	a0-a1/d0-d3/a6,-(a7)
		move.l	a2,d1
		beq.b		3$
		move.b	d0,d1
		GETPEN	LWBackgroundPen,d2,a0
		GETPEN	NormalTextPen,d3,a0

	;Check hilight
		move.b	d1,d0
		and.b		#1,d0
		beq.b		1$
		GETPEN	HilightBackPen,d2,a0
		GETPEN	HilightPen,d3,a0

	;Check inverse video
1$		move.b	d1,d0
		and.b		#2,d0
		beq.b		2$
		exg		d2,d3

	;Set colours
2$		movea.l	a2,a1
		move.l	d2,d0
		CALLGRAF	SetBPen
		movea.l	a2,a1
		move.l	d3,d0
		CALL		SetAPen
3$		movem.l	(a7)+,a0-a1/d0-d3/a6
		rts

	;***
	;Default refresh handler
	;a0 = logwin
	;-> preserves all registers
	;***
DefaultRefreshHandler:
		rts

	;***
	;Refresh a logical window. This function does nothing if the physical
	;window has not opened it's intuition window yet.
	;a0 = LW
	;***
LogWin_Refresh:
		bsr.b		LogWin_RefreshNoH
		movea.l	(LogWin_RefreshHandler,a0),a1
		jmp		(a1)

LogWin_RefreshNoH:
		movem.l	a2-a5/d2-d7,-(a7)
		move.l	a0,-(a7)
		movea.l	(LogWin_PhysWin,a0),a0
		bsr		PhysWin_GetRastPort
		beq		1$
		movea.l	d0,a2							;RPort
		CALLEXEC	Forbid
		movea.l	(a7),a0
	;Set the font on the rastport
		movea.l	a2,a1
		movea.l	(LogWin_Font,a0),a0
		CALLGRAF	SetFont
	;Clear the window
		moveq		#0,d0							;No attributes (default)
		bsr		_LogWin_SetAttribute
	;Draw the window line below
		movea.l	(a7),a0
	;Reprint all the lines in the window
		move.w	(LogWin_height,a0),d3	;Number of rows to update
		beq.b		3$								;do nothing (no lines)
		move.w	(LogWin_rx,a0),d6			;Starting x coordinate
		move.w	(LogWin_ry,a0),d7			;Starting y coordinate
		move.w	(LogWin_viscol,a0),d4	;Starting column position
		move.w	(LogWin_visrow,a0),d5	;Starting row position
		movea.l	(LogWin_Buffer,a0),a5
		move.w	d5,d0
		lsl.w		#2,d0							;*4
		lea		(0,a5,d0.w),a5				;Ptr to first line to update
	;For each row...
		bra.b		6$

2$		movea.l	(a5),a4

	;Set attribute info if needed
		move.b	(a4),d0
		beq.b		4$
		bsr		_LogWin_SetAttribute

4$		lea		(1,a4,d4.w),a1				;Ptr to first column to update (Skip attribute)
		move.w	(LogWin_width,a0),d0		;Number of cols to update
		move.w	d6,d1
		move.w	d7,d2
		bsr		_LogWin_PrintXY

	;If attribute was set, we must restore it
		move.b	(a4),d0
		beq.b		5$
		moveq		#0,d0
		bsr		_LogWin_SetAttribute

	;Next line in window
5$		add.w		(LogWin_FontY,a0),d7
	;Next row
		lea		(4,a5),a5
6$		dbra		d3,2$

3$		CALLEXEC	Permit
1$		movea.l	(a7)+,a0
		movem.l	(a7)+,a2-a5/d2-d7
		rts

	;***
	;Calculate the visible width and height
	;a0 = LW
	;-> preserves all registers
	;-> Z flag set if no window
	;***
LogWin_CalcVisible:
		movem.l	d0/a1,-(a7)
		movea.l	(LogWin_PhysWin,a0),a1
		move.l	(PhysWin_Window,a1),d0
		beq.b		1$

	;Adjust visible width and height for characters
		move.w	(LogWin_rw,a0),d0
		ext.l		d0
		divu.w	(LogWin_FontX,a0),d0
		move.w	d0,(LogWin_VisWidth,a0)		;Max number of cols visible

		move.w	(LogWin_rh,a0),d0
		ext.l		d0
		divu.w	(LogWin_FontY,a0),d0
		move.w	d0,(LogWin_VisHeight,a0)	;Max number of rows visible

		moveq		#1,d0					;Success

1$		movem.l	(a7)+,d0/a1
		rts

	;***
	;Calculate the visible logical window.
	;a0 = LW
	;-> preserves all registers
	;***
_LogWin_Recalc:
		move.l	d0,-(a7)

		bsr		LogWin_CalcVisible

	;Horizontal
		move.w	(LogWin_VisWidth,a0),d0
		cmp.w		(LogWin_NumColumns,a0),d0
		ble.b		2$
	;width is greater than NumColumns
		move.w	(LogWin_NumColumns,a0),d0
	;width is smaller than NumColumns
2$		move.w	d0,(LogWin_width,a0)		;Number of cols visible

	;Vertical
		move.w	(LogWin_VisHeight,a0),d0
		cmp.w		(LogWin_NumLines,a0),d0
		ble.b		3$
	;height is greater than NumLines
		move.w	(LogWin_NumLines,a0),d0
	;height is smaller than NumLines
3$		move.w	d0,(LogWin_height,a0)		;Number of rows visible

		move.l	(a7)+,d0
		rts

	;***
	;Allocate our buffer (do not forget to clear it first)
	;a0 = LW
	;-> d0 = 0 if no success (flags)
	;***
_LogWin_AllocBuffer:
		movem.l	a2/d2-d3,-(a7)
		bsr		_LogWin_ClearBuffer
	;Allocate our buffer block
		move.w	(LogWin_NumLines,a0),d0
		move.w	d0,d2
		addq.w	#1,d0
		lsl.w		#2,d0							;*4
		ext.l		d0
		movem.l	a0,-(a7)
		bsr		AllocClear
		movea.l	(a7)+,a0
		move.l	d0,(LogWin_Buffer,a0)
		beq.b		1$
		movea.l	d0,a2							;Remember ptr to buffer block
	;Allocate all lines
		move.w	(LogWin_NumColumns,a0),d3
		addq.w	#2,d3							;Place for attribute
		ext.l		d3
	;For each line
		bra.b		5$

2$		movem.l	a0,-(a7)
		move.l	d3,d0
		bsr		AllocClear
		movea.l	(a7)+,a0
		move.l	d0,(a2)+
		beq.b		1$
	;Clear line with spaces (0 attribute first)
		movea.l	d0,a1
		clr.b		(a1)+							;0 attribute
		move.w	d3,d0
		subq.w	#3,d0

3$		move.b	#' ',(a1)+
		dbra		d0,3$

	;Next line
5$		dbra		d2,2$

		moveq		#1,d0
4$		movem.l	(a7)+,a2/d2-d3
		rts
	;Error allocating memory
1$		bsr		_LogWin_ClearBuffer
		moveq		#0,d0
		bra.b		4$

	;***
	;Adjust real world coordinates.
	;a0 = LW
	;***
LogWin_AdjustRealWorld:
		movea.l	(LogWin_Box,a0),a1
		tst.b		(Box_Dirty,a1)
		bne.b		1$
		andi.w	#~LWF_DIRTY,(LogWin_Flags+2,a0)
		movea.l	(LogWin_Box,a0),a1
		move.w	(Box_x,a1),(LogWin_rx,a0)
		move.w	(Box_y,a1),(LogWin_ry,a0)
		move.w	(Box_w,a1),(LogWin_rw,a0)
		move.w	(Box_h,a1),(LogWin_rh,a0)

	;Add the topborder to our y loc and height
		move.w	(LogWin_ry,a0),(LogWin_rtop,a0)
		moveq		#0,d0
		move.b	(LogWin_TopBorder,a0),d0
		add.w		d0,(LogWin_ry,a0)
		sub.w		d0,(LogWin_rh,a0)
		rts

	;The box containing our LW is dirty, make our LW dirty too
1$		ori.w		#LWF_DIRTY,(LogWin_Flags+2,a0)
		rts

	;***
	;Hilight the current line
	;a0 = LW
	;d0 = attribute
	;***
LogWin_Attribute:
		movea.l	(LogWin_Buffer,a0),a1
		move.w	(LogWin_row,a0),d1
		lsl.w		#2,d1
		movea.l	(0,a1,d1.w),a1		;Pointer to the line
		move.b	d0,(a1)
		bra		LogWin_Reprint

	;***
	;Hilight a line (possibly unhilighting another one)
	;a0 = LW
	;d0 = attribute
	;d1 = line number (or -1 for no hilight at all)
	;***
LogWin_HiLight:
		move.l	(LogWin_col,a0),-(a7)	;Remember column AND row!
		movem.l	d0-d1,-(a7)
		move.w	(LogWin_HiLine,a0),d1
		cmp.w		#-1,d1
		beq.b		1$

	;Unhilight the previous line
		moveq		#0,d0
		bsr		LogWin_Locate
		moveq		#0,d0
		bsr		LogWin_Attribute

	;Hilight the new line
1$		movem.l	(a7),d0-d1
		cmp.w		#-1,d1
		beq.b		2$
		moveq		#0,d0
		bsr		LogWin_Locate
		movem.l	(a7),d0-d1
		bsr		LogWin_Attribute

2$		movem.l	(a7)+,d0-d1
		move.w	d1,(LogWin_HiLine,a0)
		move.l	(a7)+,(LogWin_col,a0)	;Restore position
		rts

	;***
	;Get character on a col-row position.
	;a0 = LW
	;d0 = col (in buffer) (-1 gets attribute for current line)
	;d1 = row
	;-> d0 = char
	;***
LogWin_GetChar:
		movea.l	(LogWin_Buffer,a0),a1
		lsl.w		#2,d1
		movea.l	(0,a1,d1.w),a1
		lea		(1,a1,d0.w),a1		;Skip attribute
		moveq		#0,d0
		move.b	(a1),d0
		rts

	;***
	;Set location in buffer.
	;a0 = LW
	;d0 = col
	;d1 = row
	;***
LogWin_Locate:
	;Check for lower limits
		tst.w		d0
		bge.b		1$
		moveq		#0,d0
1$		tst.w		d1
		bge.b		2$
		moveq		#0,d1
	;Check for upper limits
2$		cmp.w		(LogWin_NumColumns,a0),d0
		blt.b		3$
		move.w	(LogWin_NumColumns,a0),d0
		subq.w	#1,d0
3$		cmp.w		(LogWin_NumLines,a0),d1
		blt.b		4$
		move.w	(LogWin_NumLines,a0),d1
		subq.w	#1,d1
	;Fill in
4$		move.w	d0,(LogWin_col,a0)
		move.w	d1,(LogWin_row,a0)
		rts

	;***
	;Go to home position in buffer.
	;a0 = LW
	;***
LogWin_Home:
		clr.w		(LogWin_col,a0)
		clr.w		(LogWin_row,a0)
		rts

	;***
	;Go to home position in buffer and scroll view to correct position.
	;a0 = LW
	;***
LogWin_TotalHome:
		move.w	(LogWin_NumLines,a0),d1
		sub.w		(LogWin_height,a0),d1
		move.w	(LogWin_Flags+2,a0),d0
		btst		#LWB_TOTALHOME0,d0
		beq.b		1$
	;Total home is above
		moveq		#0,d1
1$		moveq		#0,d0
		move.l	d1,-(a7)
		bsr		LogWin_Scroll
		move.l	(a7)+,d1
		moveq		#0,d0
		bra		LogWin_Locate

	;***
	;Clear window.
	;a0 = LW
	;***
LogWin_Clear:
		move.w	#-1,(LogWin_HiLine,a0)
		bsr		_LogWin_AllocBuffer
		bsr		LogWin_ClearWindow
		bra		LogWin_TotalHome

	;***
	;Set font for logical window.
	;a0 = LW
	;a1 = Name
	;d0 = YSize
	;d1 = Style
	;d2 = Flags
	;-> d0 = 0 if no success (flags)
	;***
LogWin_SetFont:
		move.l	a0,-(a7)
		lea		(LogWin_TA,a0),a0
		move.l	a1,(ta_Name,a0)
		move.w	d0,(ta_YSize,a0)
		move.b	d1,(ta_Style,a0)
		move.b	d2,(ta_Flags,a0)
		bsr		OpenFont
		movea.l	(a7)+,a0				;For flags
		beq.b		2$

	;Everything is allright, close the previous font
		movem.l	d0/a0,-(a7)
		move.l	(LogWin_Font,a0),d0
		beq.b		3$
		movea.l	d0,a1
		CALLGRAF	CloseFont
3$		movem.l	(a7)+,d0/a0

		move.l	d0,(LogWin_Font,a0)
		movea.l	d0,a1
		move.w	(tf_XSize,a1),(LogWin_FontX,a0)
		move.w	(tf_YSize,a1),(LogWin_FontY,a0)
		move.w	(tf_Baseline,a1),(LogWin_FontBase,a0)
		moveq		#1,d0						;Success
	;There was an error, we don't close the previous font
2$		rts

	;***
	;Open a font, try first with OpenFont, later with OpenDiskFont
	;a0 = pointer to TextAttr
	;-> d0 = pointer to font or 0, flags if error
	;***
OpenFont:
		move.l	a0,-(a7)
		CALLGRAF	OpenFont
		movea.l	(a7)+,a0
		tst.l		d0
		beq.b		4$
	;Success, first test if the size is correct
		movea.l	d0,a1
		move.w	(tf_YSize,a1),d1
		cmp.w		(ta_YSize,a0),d1
		beq.b		1$
	;Not correct, we close this font and load a disk font
		move.l	a0,-(a7)
		CALLGRAF	CloseFont			;Font is still in a1
		movea.l	(a7)+,a0
	;Check if it is a diskfont
4$		move.l	(DFBase),d0
		beq.b		1$						;No diskfont.library, simply ignore
		movea.l	d0,a6
		CALL		OpenDiskFont		;TextAttr is in a0
1$		tst.l		d0						;For flags
		rts

	;***
	;Print a line on the logical window.
	;a0 = LW
	;a1 = String
	;a2 = RastPort (may be null)
	;d0 = Length
	;d1 = x
	;d2 = y
	;***
_LogWin_PrintXY:
		cmpa.l	#0,a2						;Check rastport
		beq.b		1$
		move.l	a0,-(a7)
		movem.l	d0/a1,-(a7)
		move.l	d1,d0
		move.l	d2,d1
		add.w		(LogWin_FontBase,a0),d1
		movea.l	a2,a1
		CALLGRAF	Move
		movem.l	(a7)+,d0/a1
		movea.l	a1,a0						;String
		movea.l	a2,a1						;RastPort
		CALL		Text
		movea.l	(a7)+,a0
1$		rts

	;***
	;Reprint the current line
	;a0 = LW
	;***
LogWin_Reprint:
		move.w	(LogWin_Flags+2,a0),d0
		btst		#LWB_SCREEN,d0
		beq.b		1$
		movem.l	a2-a3,-(a7)
		movea.l	a0,a3
	;Get rastport
		movea.l	(LogWin_PhysWin,a3),a0
		bsr		PhysWin_GetRastPort
		movea.l	d0,a2						;Remember rastport
		beq.b		2$
	;Set font for rastport
		movea.l	a2,a1
		movea.l	(LogWin_Font,a3),a0
		CALLGRAF	SetFont
		movea.l	a3,a0
		move.w	(LogWin_row,a3),d0
		bsr		_LogWin_PrintLine
2$		movem.l	(a7)+,a2-a3
1$		rts

	;***
	;Internal functions for LogWin_Print.
	;If first char = 13 we print 10 instead (string is unchanged)
	;a0 = LW
	;a1 = String
	;d0 = Len
	;...
	;***

_LogWin_PrintFile:
		move.b	(a1),d1						;Remember first char
		movem.l	a0-a1/d0-d3,-(a7)
		move.l	(LogWin_File,a0),d1
		beq.b		1$

	;Test for char 13
		cmpi.b	#13,(a1)
		bne.b		3$
		move.b	#10,(a1)						;Overwrite

3$		move.l	a1,d2
		moveq		#-1,d3
	;Compute length of string
2$		addq.l	#1,d3
		tst.b		(a1)+
		dbeq		d0,2$
		CALLDOS	Write
1$		movem.l	(a7)+,a0-a1/d0-d3
		move.b	d1,(a1)						;Restore first char
		rts

	;Print one line from the buffer to the window.
	;a0 = LW
	;d0 = line number in buffer
	;a2 = RastPort (may be null)
_LogWin_PrintLine:
		movem.l	d2-d3/a4,-(a7)
		move.w	d0,d3							;Remember line number
		sub.w		(LogWin_visrow,a0),d0
		blt.b		1$								;Line is not visible
		cmp.w		(LogWin_height,a0),d0
		bge.b		1$								;Not visible
	;Line is visible
		move.w	d0,d2
		mulu.w	(LogWin_FontY,a0),d2
		add.w		(LogWin_ry,a0),d2			;y location to print line
		move.w	(LogWin_rx,a0),d1			;x location to print line
		movea.l	(LogWin_Buffer,a0),a1
		lsl.w		#2,d3
		movea.l	(0,a1,d3.w),a4				;Ptr to line

	;Check attribute
		move.b	(a4),d0						;Get attribute
		beq.b		2$
		bsr		_LogWin_SetAttribute

2$		move.w	(LogWin_viscol,a0),d0
		lea		(1,a4,d0.w),a1				;Start pos to print (Skip attribute)
		move.w	(LogWin_width,a0),d0		;Width to print
		bsr		_LogWin_PrintXY

	;Reset attribute
		move.b	(a4),d0
		beq.b		1$
		moveq		#0,d0
		bsr		_LogWin_SetAttribute

1$		movem.l	(a7)+,d2-d3/a4
		rts

	;***
	;Print a string.
	;Note ! If the first char of the string is char 13 we interprete it as
	;a soft newline. This is the same as 10 except when the column position
	;is 0.
	;Warning ! If the first char of the string is 13 it will be changed
	;to 10.
	;This routine also supports the attribute character 1 to 4
	;a0 = LW
	;a1 = String
	;d0 = Len
	;***
LogWin_Print:
		move.w	(LogWin_Flags+2,a0),d1
		btst		#LWB_FILE,d1
		beq.b		6$
		bsr		_LogWin_PrintFile
		move.w	(LogWin_Flags+2,a0),d1

	;Continue with print to buffer and screen
6$		btst		#LWB_SCREEN,d1
		bne.b		7$
		rts

	;Start printing
	;If first char is 13 we interprete it as a softnewline
	;The string is changed
7$		cmpi.b	#13,(a1)
		bne.b		8$
		move.b	#10,(a1)
		move.w	(LogWin_col,a0),d1
		bne.b		8$

	;We are at the first column, so the newline should be ignored
		tst.l		d0							;If we should print nothing, ignore rest
		beq.b		8$
		lea		(1,a1),a1				;Skip newline (we must not print it)
		subq.l	#1,d0
		beq.b		8$
		tst.b		(a1)						;Test if end of string
		bne.b		8$
		addq.l	#1,d0

8$		movem.l	a0/a2-a4/d2-d5,-(a7)
		movea.l	a0,a3						;Remember logical window
		movea.l	a1,a4						;Remember string
		move.w	d0,d5
		beq		3$							;Don't print zero length strings
		subq.w	#1,d5						;Remember length

	;First check if we must snap to the printing position
		move.w	(LogWin_Flags+2,a3),d1
		btst		#LWB_SNAPOUTPUT,d1
		beq.b		9$
	;Yes ! check if current line is visible
		move.w	(LogWin_row,a3),d1
		sub.w		(LogWin_visrow,a3),d1
		blt.b		10$							;Line is not visible
		cmp.w		(LogWin_height,a3),d1
		blt.b		9$								;Visible
	;Line is not visible
10$	move.w	(LogWin_viscol,a3),d0
		move.w	(LogWin_row,a3),d1
		bsr		LogWin_Scroll

	;Get rastport
9$		movea.l	(LogWin_PhysWin,a3),a0
		bsr		PhysWin_GetRastPort
		movea.l	d0,a2						;Remember rastport
		beq.b		14$
	;Set font for rastport
		movea.l	a2,a1
		movea.l	(LogWin_Font,a3),a0
		CALLGRAF	SetFont
		moveq		#0,d0
		bsr		_LogWin_SetAttribute

	;Initialize main loop for character printing
14$	movea.l	(LogWin_Buffer,a3),a1
		move.w	(LogWin_row,a3),d3
		move.w	d3,d1
		lsl.w		#2,d1
		movea.l	(0,a1,d1.w),a1			;a1 points to current line
		move.w	(LogWin_col,a3),d0

	;For each char in string
2$		move.b	(a4)+,d4
		beq		3$							;NULL char, end of string
		cmpi.b	#4,d4						;Special attribute characters
		bls		13$
		cmpi.b	#10,d4					;Line Feed
		bne.b		4$
	;Line Feed (first print the current line)
	;Clear rest of line with spaces
		movea.l	(LogWin_Buffer,a3),a1
		move.w	(LogWin_row,a3),d3
		move.w	d3,d1
		lsl.w		#2,d1
		movea.l	(0,a1,d1.w),a1			;a1 points to current line
		move.w	(LogWin_col,a3),d2

.l1	move.b	#' ',(1,a1,d2.w)		;Skip attribute
		addq.w	#1,d2
		cmp.w		(LogWin_NumColumns,a3),d2
		blt.b		.l1

		move.w	d3,d0						;d3 = row
		movea.l	a3,a0
		bsr		_LogWin_PrintLine
		bsr		LogWin_Down
		clr.w		(LogWin_col,a3)

		dbra		d5,14$
		bra.b		3$

	;Put character in buffer (see PrintChar)
4$		move.b	d4,(1,a1,d0.w)			;Fill current char (skip attribute)

	;Go one to right
		addq.w	#1,d0						;d0 = col
		cmp.w		(LogWin_NumColumns,a3),d0
		blt.b		1$
	;Too far
		move.w	d3,d0						;d3 = row
		movea.l	a3,a0
		bsr		_LogWin_PrintLine
		bsr		LogWin_Down
		clr.w		(LogWin_col,a3)
		dbra		d5,14$
		bra.b		3$

	;AllRight
1$		move.w	d0,(LogWin_col,a3)

	;Continue with next char
5$		dbra		d5,2$
3$		movem.l	(a7)+,a0/a2-a4/d2-d5
		rts

	;Special attribute char
13$	subq.b	#1,d4						;1..4 --> 0..3
		move.b	d4,(a1)					;Fill attribute
		addq.w	#1,d5						;Extra char (dummy)
		bra.b		5$

	;***
	;Print one character on the logical window and in the buffer.
	;a0 = LW
	;d0 = char
	;-> d0 = char
	;***
LogWin_PrintChar:
		move.l	d0,-(a7)
		lea		(3,a7),a1
		moveq		#1,d0
		bsr		LogWin_Print
		move.l	(a7)+,d0
		rts

	IFD D20
	;***
	;Remove or add a scrollbar according to the local logical window
	;flags or the global SBarMode flag
	;a0 = logwin
	;***
LogWin_InitScrollBar:
		move.l	a0,-(a7)

		move.l	(LogWin_PhysWin,a0),d0
		beq.b		1$
		movea.l	d0,a1

		move.w	(LogWin_Flags+2,a0),d0
		movea.l	(LogWin_Box,a0),a0
		btst		#LWB_SCROLLBAR,d0
		bne.b		3$
		btst		#LWB_SBARIFMODE,d0
		bne.b		4$
	;Maybe we must add the scrollbar. This depends on the global 'sbar' flag
		moveq		#mo_SBar,d0
		bsr		CheckModeBit
		beq.b		4$

	;Add the scrollbar
	;a0 = box
	;a1 = PW
3$		bsr		Box_AddScrollBar
		bra.b		1$

	;Remove the scrollbar
	;a0 = box
	;a1 = PW
4$		bsr		Box_RemoveScrollBar

1$		movea.l	(a7)+,a0
		rts
	ENDC

	;***
	;Set and get flags
	;Reset the logical windows and boxes (scrollbars) if necessary
	;a0 = LW
	;d0.w = New flags
	;d1.w = Mask
	;-> d0.w = old flags
	;***
LogWin_SetFlags:
		movem.l	a0/d2/a2,-(a7)
		move.w	(LogWin_Flags+2,a0),d2	;Remember old flags
		and.w		d1,d0							;Clear all flags in d0 that are not in d1
		not.w		d1								;Bit 1 when not changed
		and.w		d1,(LogWin_Flags+2,a0)	;Clear all masked bits
		or.w		d0,(LogWin_Flags+2,a0)	;Or all new bits

	;Test if we must change the topborder for this logical window
		move.w	(TopBorder,pc),d0
		move.b	d0,(LogWin_TopBorder,a0)
		move.w	(LogWin_Flags+2,a0),d0
		btst		#LWB_NOSTATUS,d0
		beq.b		1$
		clr.b		(LogWin_TopBorder,a0)

1$
	IFD D20
	;Test if we must add or remove a scrollbar to the box of this logical window
		move.w	d2,d0
		move.w	#LWF_SCROLLBAR+LWF_SBARIFMODE,d1
		and.w		d1,d0							;d0 = old SCROLLBAR and SBARIFMODE flags
		and.w		(LogWin_Flags+2,a0),d1	;d1 = new SCROLLBAR and SBARIFMODE flags
		cmp.w		d0,d1
		beq.b		2$

	;There was a change in the ScrollBar flags, we must remove or add
	;the scrollbar gadget
		bsr.b		LogWin_InitScrollBar
		movea.l	(LogWin_PhysWin,a0),a0
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets
	ENDC

	;Don't add or remove the scrollbar
2$		move.w	d2,d0						;Get old flags
		movem.l	(a7)+,a0/d2/a2
		rts

	;***
	;Set and get flags
	;a0 = LW
	;d0.w = New flags
	;d1.w = Mask
	;-> d0.w = old flags
	;***
LogWin_SetFlagsNoClean:
		move.w	(LogWin_Flags+2,a0),-(a7)
		and.w		d1,d0							;Clear all flags in d0 that are not in d1
		not.w		d1								;Bit 1 when not changed
		and.w		d1,(LogWin_Flags+2,a0)	;Clear all masked bits
		or.w		d0,(LogWin_Flags+2,a0)	;Or all new bits
		move.w	(a7)+,d0
		rts

	;***
	;Attach a file to a logical window.
	;This function automatically cleares the LWF_FILE flag if the argument
	;for File is NULL. (Note! It is not automatically set in the other case)
	;a0 = LW
	;d0 = File BPTR
	;***
LogWin_AttachFile:
		move.l	d0,(LogWin_File,a0)
		bne.b		1$
		moveq		#0,d0						;Clear flags
		move.w	#LWF_FILE,d1			;Mask
		bsr		LogWin_SetFlagsNoClean
1$		rts

	;***
	;Get a character.
	;This function will do nothing if PowerVisor is in hold mode
	;a0 = LogWin
	;-> d0 = char
	;***
LogWin_GetKey:
		lea		(LockWin,pc),a1
		move.l	a0,(a1)
		lea		(LockState,pc),a1
		move.b	#1,(a1)
		move.b	(InBusy,pc),d1
		lea		(InBusy,pc),a1
		move.b	#2,(a1)
		lea		(WaPrompt,pc),a1
		move.l	a1,(LockPtr)
		bsr.b		SetGadgetState

		movem.l	d1/a0,-(a7)
		movea.l	(LogWin_PhysWin,a0),a0
		bsr		PhysWin_GetKey
		movem.l	(a7)+,d1/a0

		move.l	d0,-(a7)

		lea		(LockWin,pc),a1
		clr.l		(a1)
		lea		(InBusy,pc),a1
		move.b	d1,(a1)
		bsr.b		SetGadgetState

		move.l	(a7)+,d0
		rts

	;***
	;Adapt the state of the stringgadget according to the current prompt
	;for the active logical window
	;This function always works for the active logical window
	;This function is safe to call if PowerVisor is in hold mode
	;***
SetGadgetState:
		movem.l	a0/d1-d2,-(a7)

		bsr		FuncGetActive
		movea.l	d0,a1					;Remember ptr to logical window

	;Print the prompt
		moveq		#0,d2					;Assume we must enable the stringgadget
		lea		(Prompt),a0
		move.b	(InBusy,pc),d0
		beq.b		3$						;Normal input mode

		moveq		#1,d2					;Assume we must disable the stringgadget
		lea		(BuPrompt,pc),a0
		cmpi.b	#1,d0
		beq.b		3$						;We are in busy mode

	;We are in lock mode
		lea		(LoPrompt,pc),a0
		cmpa.l	(LockWin,pc),a1
		bne.b		3$						;If not the lock window, we are locked

	;This is the lock window
		movea.l	(LockPtr,pc),a0
		move.b	(LockState,pc),d2

3$		bsr		IntPrintPrompt

		tst.b		d2
		bne.b		1$
	;The stringgadget can be accessed
		bsr		AddGadget
		bsr		ActivateGadget
		bsr		RefreshGadget
		bra.b		2$
	;The stringgadget cannot be accessed
1$		bsr		RemoveGadget

2$		movem.l	(a7)+,a0/d1-d2
		rts

	;***
	;Cursor down.
	;a0 = LW
	;***
LogWin_Down:
		move.w	(LogWin_Flags+2,a0),d1
		btst		#LWB_MORE,d1
		beq.b		4$
		move.w	(LogWin_LinesPassed,a0),d0
		addq.w	#1,d0
		move.w	d0,(LogWin_LinesPassed,a0)
		cmp.w		(LogWin_NumLines,a0),d0
		blt.b		4$

	;Wait for user input
		bsr		LogWin_StartPage

		move.l	a0,(LockWin)
		move.b	#1,(LockState)
		move.b	(InBusy,pc),d1
		move.b	#2,(InBusy)
		lea		(MoPrompt,pc),a1
		move.l	a1,(LockPtr)
		bsr		SetGadgetState

		movem.l	d1/a0,-(a7)
		movea.l	(LogWin_PhysWin,a0),a0
		bsr		PhysWin_GetKey
		movem.l	(a7)+,d1/a0

		clr.l		(LockWin)
		move.b	d1,(InBusy)
		bsr		SetGadgetState

	;Go down
4$		move.w	(LogWin_row,a0),d0
		addq.w	#1,d0
		cmp.w		(LogWin_NumLines,a0),d0
		blt.b		1$
	;Too far, scroll
		bra		LogWin_ScrollBuffer
	;AllRight
1$		move.w	d0,(LogWin_row,a0)
		rts

	;***
	;Clear the buffer
	;a0 = LW
	;***
_LogWin_ClearBuffer:
		move.l	a2,-(a7)
		move.l	(LogWin_Buffer,a0),d0
		beq.b		1$
		move.l	a0,-(a7)					;LW
		move.l	d0,-(a7)					;Pointer to block
		movea.l	d0,a2
2$		tst.l		(a2)
		beq.b		3$
		movea.l	(a2)+,a1
		movea.l	(4,a7),a0				;Get LW
		move.w	(LogWin_NumColumns,a0),d0
		addq.w	#2,d0						;Place for attribute
		ext.l		d0
		bsr		FreeMem
		bra.b		2$
	;Free block with line pointers
3$		movea.l	(4,a7),a0				;Get LW
		move.w	(LogWin_NumLines,a0),d0
		addq.w	#1,d0
		lsl.w		#2,d0
		ext.l		d0
		movea.l	(a7)+,a1					;Get pointer to block
		bsr		FreeMem
		movea.l	(a7)+,a0
		clr.l		(LogWin_Buffer,a0)
1$		movea.l	(a7)+,a2
		rts

	;***
	;Start a new page here (only useful in LWF_MORE mode).
	;a0 = LW
	;***
LogWin_StartPage:
		clr.w		(LogWin_LinesPassed,a0)
		rts

	;***
	;Scroll the buffer up and insert a new empty line below.
	;a0 = LW
	;***
LogWin_ScrollBuffer:
	;Scroll the buffer
		movea.l	(LogWin_Buffer,a0),a1
		move.l	(a1),d1					;Remember pointer to first line
		move.w	(LogWin_NumLines,a0),d0
		subq.w	#2,d0
		blt.b		6$

1$		move.l	(4,a1),(a1)
		lea		(4,a1),a1
		dbra		d0,1$
		move.l	d1,(a1)					;New empty line

	;Make empty
6$		movea.l	d1,a1
		lea		(1,a1),a1				;Skip attribute
		move.w	(LogWin_NumColumns,a0),d0
		bra.b		7$

2$		move.b	#' ',(a1)+
7$		dbra		d0,2$

	;Scroll the real window
		movem.l	a2-a3,-(a7)
		movea.l	a0,a3						;Remember Logical window
		movea.l	(LogWin_PhysWin,a3),a0
		bsr		PhysWin_GetRastPort
		movea.l	d0,a2
		beq		3$
		movem.l	d2-d5,-(a7)
		moveq		#0,d0						;dx
		move.l	d0,d1
		move.w	(LogWin_FontY,a3),d1	;dy
		move.l	d0,d2
		move.w	(LogWin_rx,a3),d2		;xmin
		move.l	d0,d3
		move.w	(LogWin_ry,a3),d3		;ymin
		move.l	d2,d4
		subq.w	#1,d4
		add.w		(LogWin_rw,a3),d4		;xmax
		move.l	d3,d5
		subq.w	#1,d5
		add.w		(LogWin_rh,a3),d5		;ymax
		movea.l	a2,a1
		CALLGRAF	ScrollRaster
		movem.l	(a7)+,d2-d5

	;Now we must correct the bottom line if it is not empty
		movea.l	(LogWin_Buffer,a3),a1	;Ptr to line block
		move.w	(LogWin_visrow,a3),d0
		tst.w		(LogWin_height,a3)
		beq.b		3$							;If no lines then no print
		add.w		(LogWin_height,a3),d0
		subq.w	#1,d0
		lsl.w		#2,d0
		movea.l	(0,a1,d0.w),a1			;Ptr to line
		move.w	(LogWin_viscol,a3),d0
		lea		(0,a1,d0.w),a1			;Ptr to first char to update
		clr.b		(a1)+						;Clear attribute
		move.w	(LogWin_width,a3),d0
		subq.w	#1,d0
		blt.b		3$
		move.l	a1,-(a7)

4$		cmpi.b	#' ',(a1)+
		bne.b		5$
		dbra		d0,4$

	;All the chars in this line are spaces
		movea.l	(a7)+,a1
		bra.b		3$

	;There is a non-space in this line, print it
5$		movea.l	a2,a1
		movea.l	(LogWin_Font,a3),a0
		CALL		SetFont
		movea.l	(a7)+,a1					;Get ptr to first char to update
		move.l	d2,-(a7)
		move.w	(LogWin_rx,a3),d1
		move.w	(LogWin_ry,a3),d2
		move.w	(LogWin_height,a3),d0
		subq.w	#1,d0
		mulu.w	(LogWin_FontY,a3),d0
		add.w		d0,d2
		move.w	(LogWin_width,a3),d0
		ext.l		d0
		movea.l	a3,a0
		bsr		_LogWin_PrintXY
		move.l	(a7)+,d2
3$		movea.l	a3,a0
		movem.l	(a7)+,a2-a3
		rts

	;***
	;Display another part of the big buffer in the small logical window.
	;a0 = LW
	;d0 = viscol
	;d1 = visrow
	;***
LogWin_Scroll:
	IFD D20
		bsr.b		LogWin_ScrollNoSBar
		bra		LogWin_UpdateScrollBar
	ENDC

	;***
	;Like LogWin_Scroll, except that the scrollbar is not refreshed
	;a0 = LW
	;d0 = viscol
	;d1 = visrow
	;***
LogWin_ScrollNoSBar:
		move.l	d2,-(a7)
		tst.w		d0
		bge.b		5$
		moveq		#0,d0
5$		tst.w		d1
		bge.b		6$
		moveq		#0,d1
6$		move.w	(LogWin_NumColumns,a0),d2
		sub.w		(LogWin_width,a0),d2
		bgt.b		1$
	;We can't scroll horizontally
		moveq		#0,d0
		bra.b		2$
	;We can scroll
1$		cmp.w		d0,d2
		bge.b		2$
	;Too much
		move.w	d2,d0
2$		move.w	(LogWin_NumLines,a0),d2
		sub.w		(LogWin_height,a0),d2
		bgt.b		3$
	;We can't scroll vertically
		moveq		#0,d1
		bra.b		4$
	;We can scroll
3$		cmp.w		d1,d2
		bge.b		4$
	;Too much
		move.w	d2,d1
4$		move.w	d0,(LogWin_viscol,a0)
		move.w	d1,(LogWin_visrow,a0)
		bsr		LogWin_Refresh
		bsr		LogWin_ShowPosition
		move.l	(a7)+,d2
		rts

;	;***
;	;Convert a x coordinate (pixel) to a column
;	;a0 = LogWin
;	;d0 = x
;	;-> d0 = col (or -1 if not in logical window)
;	;***
;LogWin_GetCol:
;		sub.w		(LogWin_rx,a0),d0
;		blt.b		1$
;		cmp.w		(LogWin_rw,a0),d0
;		bge.b		1$
;		ext.l		d0
;		divu.w	(LogWin_FontX,a0),d0
;		add.w		(LogWin_viscol,a0),d0
;		cmp.w		(LogWin_NumColumns,a0),d0
;		bge.b		1$
;		rts
;
;1$		moveq		#-1,d0
;		rts

	;***
	;Convert a y coordinate (pixel) to a row
	;a0 = LogWin
	;d0 = y
	;-> d0 = row (or -1 if not in logical window)
	;***
LogWin_GetRow:
		sub.w		(LogWin_ry,a0),d0
		blt.b		1$
		cmp.w		(LogWin_rh,a0),d0
		bge.b		1$
		ext.l		d0
		divu.w	(LogWin_FontY,a0),d0
		add.w		(LogWin_visrow,a0),d0
		cmp.w		(LogWin_NumLines,a0),d0
		bge.b		1$
		rts

1$		moveq		#-1,d0
		rts

	;***
	;Get a word from a position (in pixel absolute coordinates).
	;This function checks if the coordinates are in the logical window
	;a0 = LW
	;d0 = x
	;d1 = y
	;a1 = Buffer
	;d2 = BufLen
	;-> d0 = length in buffer (or null, flags)
	;***
LogWin_GetWord:
		movem.l	d3-d4/a2-a3,-(a7)
		move.l	d0,d3
		move.l	d1,d4
		movea.l	a1,a3
		sub.w		(LogWin_rx,a0),d3
		blt		1$
		cmp.w		(LogWin_rw,a0),d3
		bge		1$
		sub.w		(LogWin_ry,a0),d4
		blt.b		1$
		cmp.w		(LogWin_rh,a0),d4
		bge.b		1$
		ext.l		d3
		ext.l		d4
		divu.w	(LogWin_FontX,a0),d3
		divu.w	(LogWin_FontY,a0),d4
		add.w		(LogWin_viscol,a0),d3
		add.w		(LogWin_visrow,a0),d4
	;Extra check
		cmp.w		(LogWin_NumLines,a0),d4
		bge.b		1$
		cmp.w		(LogWin_NumColumns,a0),d3
		bge.b		1$
		lsl.w		#2,d4
		movea.l	(LogWin_Buffer,a0),a1
		movea.l	(0,a1,d4.w),a1				;a1 = ptr to line
		lea		(1,a1),a1					;Skip attribute
		lea		(0,a1,d3.w),a2				;a2 = ptr to char
		cmpi.b	#' ',(a2)
		beq.b		1$
	;Search to left (check first if d3<>0)
		tst.w		d3
		bne.b		3$
	;d3=0 so we add one to a2
		lea		(1,a2),a2
3$		subq.l	#1,a2
		cmpa.l	a1,a2
		beq.b		4$								;We reached the leftside of the line
		cmpi.b	#' ',(a2)
		bne.b		3$
	;We have a space here, go one right
		lea		(1,a2),a2
	;Now a2 points to the first character from the word we are going to snap
4$		moveq		#0,d0
		subq.w	#1,d2

5$		addq.l	#1,d0
		cmpi.b	#' ',(a2)
		beq.b		6$
		tst.b		(a2)
		beq.b		6$
		move.b	(a2)+,(a3)+
		dbra		d2,5$

6$		clr.b		(a3)
		tst.l		d0
	;Success
2$		movem.l	(a7)+,d3-d4/a2-a3
		rts
	;No success
1$		moveq		#0,d0
		bra.b		2$

;==================================================================================
;
; END LogWindow object
;
;==================================================================================

	;***
	;Command: set logical window preferences
	;***
RoutLWPrefs:
		bsr		GetStringE
		movea.l	d0,a2
		suba.l	a3,a3					;Set prefs
		NEXTTYPE
		bne.b		5$
		lea		(1,a3),a3
		bra.b		6$
5$		EVALE								;x size
		move.l	d0,d2
		EVALE								;y size
		move.l	d0,d3
		EVALE								;mask
		move.l	d0,d4
		EVALE								;flags
		move.l	d0,d5
	;Test string
6$		movea.l	a2,a0
		lea		(MainEntry,pc),a4
		lea		(MainName,pc),a1
		moveq		#4,d0
		bsr		CompareCI
		beq.b		1$

		movea.l	a2,a0
		lea		(ExtraEntry,pc),a4
		lea		(ExtraName,pc),a1
		moveq		#5,d0
		bsr		CompareCI
		beq.b		1$

		movea.l	a2,a0
		lea		(RefreshEntry,pc),a4
		lea		(RefreshName,pc),a1
		moveq		#7,d0
		bsr		CompareCI
		beq.b		1$

		movea.l	a2,a0
		lea		(PPrintEntry,pc),a4
		lea		(PPrintName,pc),a1
		moveq		#6,d0
		bsr		CompareCI
		beq.b		1$

		movea.l	a2,a0
		lea		(RexxEntry,pc),a4
		lea		(RexxName,pc),a1
		moveq		#4,d0
		bsr		CompareCI
		beq.b		1$

		movea.l	a2,a0
		lea		(SourceEntry,pc),a4
		lea		(SourceName,pc),a1
		moveq		#6,d0
		bsr		CompareCI
		beq.b		1$

		movea.l	a2,a0
		lea		(lDebugEntry,pc),a4
		lea		(DebugName,pc),a1
		moveq		#5,d0
		bsr		CompareCI
		ERRORne	UnknownLogicalWindow

1$		movea.l	a4,a1
		move.l	a3,d0
		beq.b		7$
	;Show prefs
		GETFMT	w,0,w,2,w,4,w,6
		FMTSTR	d,spc,d,spc,04x,spc,04x,nl
		bra		SpecialPrint

7$		move.w	d2,(a1)+
		move.w	d3,(a1)+
		move.w	d4,(a1)+
		move.w	d5,(a1)+
		rts

	;***
	;Get a logical window
	;a0 = cmdline
	;-> d0 = logical window
	;***
GetLogWinE:
		moveq		#I_LWIN,d6
		bsr		SetList
		EVALE								;Get LW
		bsr		ResetList
		tst.l		d0
		beq.b		1$

		movea.l	d0,a1
		movea.l	(LogWin_Box,a1),a1
		cmp.l		(Box_LogWin,a1),d0
		bne.b		1$
		rts

1$		ERROR		NotALogWin

	;***
	;Command: set flags for logical windows
	;***
RoutSetFlags:
		bsr		GetLogWinE
		movea.l	d0,a2
		EVALE								;Get mask
		move.w	d0,d2
		EVALE								;Get flags
		move.w	d2,d1
		movea.l	a2,a0
		bsr		LogWin_SetFlags
		PRINTHEX
		bra		StoreRC

	;***
	;Set the size out of a logical window default entry
	;a0 = ptr to logical window
	;-> flags if error
	;-> a0 = logical window
	;***
UseEntrySize:
		movem.l	d0-d3/a0-a2,-(a7)
		movea.l	(LogWin_UserData,a0),a2

	;First get X
		move.w	(a2)+,d0				;Get prefered number of columns
		move.w	d0,d2
		bne.b		2$						;X-scalable or fixed horizontal size

	;Zero, we must compute the max value
		move.w	(LogWin_VisWidth,a0),d2

	;d2 = real parameter for SetColRow
	;Get Y
2$		move.w	(a2)+,d0				;Get prefered number of rows
		move.w	d0,d3
		bne.b		4$						;Y-scalable or fixed vertical size

	;Zero, we must compute the max value
		move.w	(LogWin_VisHeight,a0),d3

	;d3 = real parameter for SetColRow
4$		move.l	d2,d0
		move.l	d3,d1
		bsr		LogWin_SetColRow
		beq.b		8$

		move.w	(a2)+,d1				;Mask
		move.w	(a2)+,d0				;Flags
		bsr		LogWin_SetFlags

		bsr		LogWin_TotalHome

7$		bsr		LogWin_Refresh
		moveq		#1,d0					;For flags
8$		movem.l	(a7)+,d0-d3/a0-a2
		rts

	;***
	;Correct flags for known logical window
	;a0 = LW
	;***
CorrectFlags:
		movem.l	d0-d1/a0-a1,-(a7)
		move.l	(LogWin_UserData,a0),d0
		beq.b		1$
		movea.l	d0,a1
		lea		(4,a1),a1				;Skip position info
		move.w	(a1)+,d1				;Mask
		move.w	(a1)+,d0				;Flags
		bsr		LogWin_SetFlags
1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Compare and fill in in LogWin var
	;a0 = ptr to LogWin var
	;a1 = string
	;a3 = LogWin
	;a4 = Entry
	;d0 = length
	;***
CompareAndSetLogWin:
		move.l	a0,-(a7)
		movea.l	(LN_NAME,a3),a0
		bsr		CompareCI
		movea.l	(a7)+,a0				;For flags
		bne.b		1$
	;Equal
		move.l	a3,(a0)
		movea.l	a3,a0
		move.l	a4,(LogWin_UserData,a0)
		bsr		CorrectFlags
	;Not equal
1$		rts

	;***
	;Scan the logical window list and see if there are no predefined logical
	;windows present
	;-> preserves registers
	;***
ScanLogWinList:
		movem.l	d0-d1/a0-a4,-(a7)
		lea		(MainLW,pc),a0
		moveq		#7-1,d1

4$		clr.l		(a0)+
		dbra		d1,4$

		movea.l	(myGlobal,pc),a0
		lea		(Global_PWList,a0),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq		2$
		lea		(PhysWin_LWList,a2),a3
3$		movea.l	(a3),a3				;Succ
		tst.l		(a3)					;Succ
		beq.b		1$
	;Main
		lea		(MainLW,pc),a0
		lea		(MainName,pc),a1
		lea		(MainEntry,pc),a4
		moveq		#4,d0
		bsr		CompareAndSetLogWin
	;Extra
		lea		(ExtraLW,pc),a0
		lea		(ExtraName,pc),a1
		lea		(ExtraEntry,pc),a4
		moveq		#5,d0
		bsr		CompareAndSetLogWin
	;Refresh
		lea		(RefreshLW,pc),a0
		lea		(RefreshName,pc),a1
		lea		(RefreshEntry,pc),a4
		moveq		#7,d0
		bsr		CompareAndSetLogWin
	;Source
		lea		(SourceLW,pc),a0
		lea		(SourceName,pc),a1
		lea		(SourceEntry,pc),a4
		moveq		#6,d0
		bsr		CompareAndSetLogWin
	;Debug
		lea		(DebugLW,pc),a0
		lea		(DebugName,pc),a1
		lea		(lDebugEntry,pc),a4
		moveq		#5,d0
		bsr		CompareAndSetLogWin
	;PPrint
		lea		(PPrintLW,pc),a0
		lea		(PPrintName,pc),a1
		lea		(PPrintEntry,pc),a4
		moveq		#6,d0
		bsr		CompareAndSetLogWin
	;Watch
		lea		(WatchLW,pc),a0
		lea		(WatchName,pc),a1
		lea		(WatchEntry,pc),a4
		moveq		#5,d0
		bsr		CompareAndSetLogWin
	;Rexx
		lea		(RexxLW,pc),a0
		lea		(RexxName,pc),a1
		lea		(RexxEntry,pc),a4
		moveq		#4,d0
		bsr		CompareAndSetLogWin
		bra		3$

	;The end, check first for other special things
2$		move.l	(SourceLW,pc),d0
		beq.b		5$
	;There is a source logical window, change the default snap handler
	;and the default scrollhandler
		movea.l	d0,a0
		lea		(SourceSnapHandler,pc),a1
		move.l	a1,(LogWin_SnapHandler,a0)
		lea		(SourceRefreshHandler,pc),a1
		move.l	a1,(LogWin_RefreshHandler,a0)
	IFD D20
		lea		(SourceCreateSBHandler,pc),a1
		move.l	a1,(LogWin_CreateSBHandler,a0)
		lea		(SourceScrollHandler,pc),a1
		move.l	a1,(LogWin_ScrollHandler,a0)
		move.w	#LWF_PRIVATESB,d0
		move.w	d0,d1
		bsr		LogWin_SetFlags
	ENDC
		bsr		SourceRefreshHandler

5$		movem.l	(a7)+,d0-d1/a0-a4
		rts

	;***
	;Hide the current window output
	;This routines remember a0
	;-> d0 = old state for HideCurrent
	;d0 = state for UnHideCurrent
	;***
HideCurrent:
		move.l	a0,-(a7)
		moveq		#0,d0
		move.w	#LWF_SCREEN,d1
		movea.l	(CurrentLW,pc),a0
		bsr		LogWin_SetFlagsNoClean
		movea.l	(a7)+,a0
		rts

UnHideCurrent:
		move.l	a0,-(a7)
		move.w	#LWF_SCREEN,d1
		movea.l	(CurrentLW,pc),a0
		bsr		LogWin_SetFlagsNoClean
		movea.l	(a7)+,a0
		rts

	;***
	;Command: file requester for load
	;***
RoutReqSave:
		lea		(ReqTags+4,pc),a1
		move.l	#FREQF_SAVE,(a1)
		bra.b		AfterReqLoad

	;***
	;Command: file requester for load
	;***
RoutReqLoad:
		lea		(ReqTags+4,pc),a1
		clr.l		(a1)

AfterReqLoad:
		bsr		FreeInput

		move.l	(ReqBase,pc),d1
		bne.b		1$

	;Use RoutGetString if reqtools library not open
		bra		RoutGetString

	;Yes, reqtools library is open
1$		bsr		GetStringE			;Title
		movea.l	d0,a3

		moveq		#64,d0
		lsl.l		#2,d0					;Make 256
		bsr		AllocBlockInt
		HERReq
		bsr		StoreInput

		movea.l	d0,a2					;Filename
		movea.l	(ReqStruct,pc),a1	;rtFileRequester
		lea		(ReqTags,pc),a0		;Tags
		CALLREQ	rtFileRequestA
		tst.l		d0
		bne.b		3$

	;Cancel
		bsr		FreeInput
		moveq		#0,d0
		rts

	;No cancel, add pathname in front of name
3$		movea.l	(ReqStruct,pc),a0
		movea.l	(rtfi_Dir,a0),a0	;Pointer to pathname
		movea.l	(Storage),a1

	;Copy pathname to Storage
4$		move.b	(a0)+,(a1)+
		bne.b		4$

		bsr		GetInputVar			;Get pointer to input
		movea.l	d0,a0
		subq.l	#1,a1

		cmpa.l	(Storage),a1
		beq.b		5$						;Don't append if empty pathname

		cmpi.b	#':',(-1,a1)
		beq.b		5$
		cmpi.b	#'/',(-1,a1)
		beq.b		5$
	;Append '/' because this is not done yet
		move.b	#'/',(a1)+

	;Append filename to Storage
5$		move.b	(a0)+,(a1)+
		bne.b		5$

		movea.l	(Storage),a1		;Combination
		movea.l	d0,a0					;Pointer to input
		move.w	#255,d1				;Maximum

	;Copy Storage to path+filename (Input)
6$		move.b	(a1)+,(a0)+
		dbeq		d1,6$

		rts

	;***
	;Command: requester
	;***
RoutRequest:
		bsr		GetStringE			;Body string
		movea.l	d0,a5
		bsr		GetStringE			;Gadgets
		movea.l	d0,a2
		EVALE								;Get argument
	;Fall through

	;***
	;Request
	;a5 = body string
	;a2 = gadgets
	;d0 = argument
	;***
RequestIt:
		move.l	d0,-(a7)

		move.l	(ReqBase,pc),d1
		bne.b		1$

	;Use 'key' if reqtools library not found
		movea.l	a7,a1
		move.l	(Storage),d0
		movea.l	a5,a0
		bsr		SPrintf				;Must be 'SPrintf' because we must be compatible
		bsr		ViewPrintLine
		NEWLINE
		movea.l	a2,a0
		PRINT
		NEWLINE
		bsr		FuncKey
		subi.b	#'0',d0
		lea		(4,a7),a7
		rts

	;Yes, reqtools library is open
1$		movea.l	a5,a1					;Bodyfmt
		movea.l	a7,a4					;Argarray
		suba.l	a0,a0					;Tags
		suba.l	a3,a3					;rtReqInfo *
		CALLREQ	rtEZRequestA
		lea		(4,a7),a7
		rts

	;***
	;Command: string requester
	;***
RoutGetString:
		bsr		FreeInput

		move.l	(ReqBase,pc),d0
		bne.b		1$
	;Use 'scan' if reqtools library not found
		pea		(0)
		movea.l	a7,a0
		bsr		RoutScan
		lea		(4,a7),a7
		rts

	;Yes, reqtools library is open
1$		bsr		GetStringE			;Title
		movea.l	d0,a2
		EVALE								;Max length of buffer
		move.l	d0,d2

		bsr		AllocBlockInt
		HERReq
		bsr		StoreInput

		movea.l	d0,a1					;Buffer
		move.l	d2,d0					;Length
		suba.l	a3,a3					;rtReqInfo *
		suba.l	a0,a0					;Tags
		CALLREQ	rtGetStringA
		tst.l		d0
		bne.b		3$

	;Cancel
		bsr		FreeInput

3$		bra		GetInputVar			;Return pointer to buffer

	;***
	;Command: open a physical window
	;***
RoutOpenPW:
		bsr		GetStringE			;Name
		movea.l	d0,a2
		EVALE								;x
		move.l	d0,d4
		EVALE								;y
		move.l	d0,d5
		EVALE								;w
		move.l	d0,d2
		EVALE								;h
		move.l	d0,d3
		move.l	d4,d0
		move.l	d5,d1
		move.l	#DEFAULTFLAGS2,d4
		bsr		TestSBottom
		beq.b		3$
		addi.l	#SIZEBBOTTOM,d4
3$		move.l	#IDCMPFLAGS2,d5
		movea.l	(myGlobal,pc),a0
		bsr		PhysWin_Constructor
		move.l	d0,-(a7)
		tst.l		d0
		ERROReq	ErrOpenPhysWin
		movea.l	d0,a0
		bsr		GetScreen
		movea.l	d0,a1
		bsr		PhysWin_Open
		beq.b		2$
		move.l	(a7)+,d0
		PRINTHEX
		bra		StoreRC

2$		bsr		PhysWin_Destructor
		ERROR		ErrOpenPhysWin

	;***
	;Command: close a physical window
	;***
RoutClosePW:
		moveq		#I_PWIN,d6
		bsr		SetList
		EVALE								;Get PW
		bsr		ResetList
		cmp.l		(MainPW,pc),d0
		ERROReq	CantCloseMainPW
		movea.l	d0,a0
		bsr		PhysWin_Destructor
		bra		ScanLogWinList

	;***
	;Command: open a logical window
	;***
RoutOpenLW:
		moveq		#I_PWIN,d6
		bsr		SetList
		EVALE								;Get PW
		bsr		ResetList
		movea.l	d0,a2
		bsr		GetStringE			;Name
		movea.l	d0,a3
		EVALE								;col
		move.l	d0,d4
		EVALE								;row
		move.l	d0,d5
	;Check if there is already a logical window on the PW
		movea.l	(PhysWin_Box,a2),a1
		cmpi.b	#ATOMIC,(Box_Type,a1)
		bne.b		1$
		tst.l		(Box_LogWin,a1)
		bne.b		1$

	;There is no logical window on the masterbox and the masterbox is
	;ATOMIC, thus there is no logical window on the PW
		movea.l	a2,a0
		movea.l	a3,a1
		movea.l	(PhysWin_Box,a2),a2
3$		move.l	d4,d0
		move.l	d5,d1
		bsr		LogWin_Constructor
		ERROReq	ErrOpenLogWin
		move.l	d0,-(a7)
		movea.l	d0,a0
		bsr		SetGadgetState

	IFD D20
		bsr		LogWin_InitScrollBar
	ENDC
		movea.l	(LogWin_PhysWin,a0),a0
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets

		move.l	(a7)+,d0
		bsr		ScanLogWinList
		PRINTHEX
		bra		StoreRC

	;There is a logical window on the masterbox or the masterbox is not
	;ATOMIC, we must get two extra arguments
1$		bsr		GetLogWinE
		movea.l	d0,a4
		cmpa.l	(LogWin_PhysWin,a4),a2
		ERRORne	LogWinMustBeOnPhysWin
		movea.l	(LogWin_Box,a4),a4
		bsr		SkipSpace
5$		move.b	(a0)+,d0				;Get char
		ERROReq	MissingOp
		bsr		Upper
		cmpi.b	#'P',d0
		bne.b		4$
	;Go to the parent
		move.l	(Box_Parent,a4),d0
		ERROReq	NoFatherForThisBox
		movea.l	d0,a4
		bra.b		5$

4$		moveq		#MAKE_UP,d1
		cmpi.b	#'U',d0
		beq.b		2$
		moveq		#MAKE_DOWN,d1
		cmpi.b	#'D',d0
		beq.b		2$
		moveq		#MAKE_LEFT,d1
		cmpi.b	#'L',d0
		beq.b		2$
		moveq		#MAKE_RIGHT,d1
		cmpi.b	#'R',d0
		ERRORne	BadArgForOpenLW

	;Get the optional number of lines/columns
2$		move.l	d1,-(a7)
		moveq		#0,d2
		NEXTARG	6$
		move.l	d0,d2
6$		move.l	(a7)+,d0
		moveq		#125,d1
		lsl.l		#2,d1					;125*4 = 500
		movea.l	a4,a1
		movea.l	a2,a0
		bsr		PhysWin_SplitBox
		ERROReq	ErrOpenLogWin
		movea.l	a3,a1
		movea.l	d0,a2
		bra		3$

	;***
	;Command: close a logical window
	;***
RoutCloseLW:
		bsr		GetLogWinE
		cmp.l		(MainLW,pc),d0
		ERROReq	CantCloseMainLW
		movea.l	d0,a0
		movea.l	(LogWin_PhysWin,a0),a3
		movea.l	(LogWin_Box,a0),a2
		bsr		LogWin_Destructor
		movea.l	a2,a1					;Pointer to box to remove
		movea.l	a3,a0
		bsr		PhysWin_RemoveBox
		movea.l	a3,a0
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets
		bra		ScanLogWinList

	;***
	;Update the preferences settings for SpecialFlags and Startup#?
	;to reflect the real values
	;***
UpdatePrefs:
	;Update the first bit of the SpecialFlags variable
		moveq		#0,d0
		move.l	(PVScreen,pc),d1
		sne		d0
		neg.b		d0
		move.l	d0,(SpecialFlags)

		move.l	(MainPW,pc),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(wd_Flags,a0),d0
		andi.l	#BACKDROP,d0
		bne.b		1$

	;We have a window and it is not a backdrop window, so we'll have
	;to update the preferences settings
		moveq		#2,d0
		lea		(SpecialFlags,pc),a1
		or.l		d0,(a1)
		lea		(StartupX,pc),a1
		move.w	(wd_LeftEdge,a0),(a1)+
		move.w	(wd_TopEdge,a0),(a1)+
		move.w	(wd_Width,a0),(a1)+
		move.w	(wd_Height,a0),(a1)+

1$		rts

	;***
	;Scan the logical window list for all standard logical windows
	;on a physical window with a size specification and update the
	;corresponding share variables
	;***
ScanStanLogWin:
		move.l	a0,-(a7)
		moveq		#mo_IntuiWin,d0
		bsr		CheckModeBit
		beq.b		2$

		lea		(ExtraShare,pc),a1
		move.l	(ExtraLW,pc),d0
		bsr.b		3$
		lea		(DebugShare,pc),a1
		move.l	(DebugLW,pc),d0
		bsr.b		3$
		lea		(SourceShare,pc),a1
		move.l	(SourceLW,pc),d0
		bsr.b		3$
		lea		(RefreshShare,pc),a1
		move.l	(RefreshLW,pc),d0
		bsr.b		3$
		lea		(PPrintShare,pc),a1
		move.l	(PPrintLW,pc),d0
		bsr.b		3$
		lea		(WatchShare,pc),a1
		move.l	(WatchLW,pc),d0
		bsr.b		3$
		lea		(RexxShare,pc),a1
		move.l	(RexxLW,pc),d0
		bsr.b		3$
2$		movea.l	(a7)+,a0
		rts

	;Check the physical window size for one window
	;d0 = pointer to the logical window (with flags still set)
	;a1 = Pointer to share
3$		beq.b		1$
		movea.l	d0,a0
		move.l	(LogWin_PhysWin,a0),d0
		beq.b		1$
		cmp.l		(MainPW,pc),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0
	;Ok, it is a standard logical window on a physical window
	;copy the dimensions of the Intuition window to the share variables
		lea		(10,a1),a1
		move.w	(wd_LeftEdge,a0),(a1)+
		move.w	(wd_TopEdge,a0),(a1)+
		move.w	(wd_Width,a0),(a1)+
		move.w	(wd_Height,a0),(a1)+
1$		rts

	;***
	;Open a standard logical window (only for standard logical windows)
	;If IntuiWinMode == TRUE we will open a physical window too (with
	;the same name)
	;a1 = ptr to logical window name
	;a2 = ptr to share structure for logical window
	;a3 = ptr to entry structure for logical window
	;d2 = optional number of lines or columns (can be 0)
	;-> d0 = 1 if success or 0 (flags)
	;-> a0 = logical window
	;***
OpenLogWin:
		move.l	a1,d6					;Name
		movea.l	(MainPW,pc),a0
		moveq		#mo_IntuiWin,d0
		bsr		CheckModeBit
		beq.b		7$

	;Open the physical window if the IntuiWinMode is true
		movem.l	a1-a2/d2-d5,-(a7)
		move.l	#DEFAULTFLAGS2,d4
		bsr		TestSBottom
		beq.b		6$
		addi.l	#SIZEBBOTTOM,d4	;Flags
6$		move.l	#IDCMPFLAGS2,d5	;IDCMP

		movea.l	(myGlobal,pc),a0	;Global
		move.w	(10,a2),d0			;Left x
		move.w	(12,a2),d1			;Top y
		move.w	(14,a2),d2			;Width
		move.w	(16,a2),d3			;Height
		movea.l	d6,a2					;Name

		bsr		PhysWin_Constructor
		movem.l	(a7)+,a1-a2/d2-d5
		tst.l		d0
		beq.b		8$
		movea.l	d0,a0
		bsr		GetScreen
		movea.l	d0,a1					;Screen
		bsr		PhysWin_Open
		beq.b		10$

	;Get the pointer to the masterbox
		move.l	(PhysWin_Box,a0),d0
		bra.b		9$

10$	bsr		PhysWin_Destructor
8$		moveq		#0,d0
		rts

	;Open the logical window on the physical window in a0
	;Make box
7$		move.w	(8,a2),d1
		bsr		PhysWin_CreateBox
		beq.b		1$
	;Make LogWin
9$		movea.l	d0,a2					;Box parameter
		movea.l	d0,a4					;Remember box
		move.l	a0,d5					;Remember physwin
		movea.l	d6,a1
		moveq		#-1,d0
		move.l	d0,d1
		bsr		LogWin_Constructor
		bne.b		2$

	;Error opening LogWin
3$		movea.l	d5,a0					;Get physwin
		moveq		#mo_IntuiWin,d0
		bsr		CheckModeBit
		bne.b		10$					;Remove physical window if error
		movea.l	a4,a1
		bsr		PhysWin_RemoveBox
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets
		moveq		#0,d0
		bra.b		1$

	;OK
2$		movea.l	d0,a5					;Remember logwin
		movea.l	d0,a0
		move.w	(4,a3),d1			;Mask
		move.w	(6,a3),d0			;Flags
		bsr		LogWin_SetFlagsNoClean

	IFD D20
		bsr		LogWin_InitScrollBar
	ENDC
	;Clean everything
		movea.l	d5,a0					;Get physwin
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets

	;Set default size
		movea.l	a5,a0					;Get LogWin
		bsr		SetGadgetState
		move.l	a3,(LogWin_UserData,a0)
		bsr		UseEntrySize
		bne.b		4$
	;Error
		moveq		#mo_IntuiWin,d0
		bsr		CheckModeBit
		bne.b		3$
		bsr		LogWin_Destructor
		bra.b		3$

4$		bsr		ScanLogWinList

		moveq		#1,d0
1$		rts

	;***
	;Close a standard logical window (only standard)
	;The corresponding physical window (if any) is also closed
	;a0 = ptr to logical window var
	;***
CloseLogWin:
		bsr		ScanStanLogWin

		move.l	(a0),d0
		beq.b		1$
		movea.l	d0,a0

		moveq		#mo_IntuiWin,d0
		bsr		CheckModeBit
		beq.b		2$

	;Yes, we must close the corresponding physical window
		move.l	(LogWin_PhysWin,a0),d0
		cmp.l		(MainPW,pc),d0
		beq.b		2$
	;It is not equal to 'Main'
		movea.l	d0,a0
		bsr		PhysWin_Destructor
		bra		ScanLogWinList

2$		movea.l	(LogWin_Box,a0),a2
		bsr		LogWin_Destructor
		movea.l	a2,a1
		movea.l	(Box_PhysWin,a2),a0
		movea.l	a0,a2
		bsr		PhysWin_RemoveBox
		lea		(CurrentLW,pc),a1
		move.l	(MainLW,pc),(a1)

	;Clean everything
		movea.l	a2,a0
		suba.l	a1,a1
		bsr		PhysWin_CleanBoxesGadgets
		bsr		ScanLogWinList

1$		rts

	;***
	;Command: open/close refresh window
	;***
RoutRWin:
		move.l	(RefreshLW,pc),d0
		bne.b		CloseRefreshWindow

	;***
	;Open refresh logical window
	;-> flags if error
	;***
OpenRefreshWindow:
		moveq		#0,d2
		NEXTARG	1$						;Get optional number of lines
		move.l	d0,d2
1$		lea		(RefreshName,pc),a1
		lea		(RefreshShare,pc),a2
		lea		(RefreshEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin
		rts

	;***
	;Close refresh logical window
	;***
CloseRefreshWindow:
		lea		(RefreshLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: open/close source window
	;a0 = cmdline
	;***
RoutSWin:
		move.l	(SourceLW,pc),d0
		bne.b		CloseSourceWindow
	;Fall through

	;***
	;Open source logical window
	;-> flags if error
	;***
OpenSourceWindow:
		moveq		#0,d2
		NEXTARG	2$						;Get optional number of lines
		move.l	d0,d2
2$		lea		(SourceName,pc),a1
		lea		(SourceShare,pc),a2
		lea		(SourceEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin
		bsr		UpdateDisplay
		moveq		#1,d0
		rts

	;***
	;Close source logical window
	;***
CloseSourceWindow:
		lea		(SourceLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: open/close debug window
	;a0 = cmdline
	;***
RoutDWin:
		move.l	(DebugLW,pc),d0
		bne.b		CloseDebugWindow
	;Fall through

	;***
	;Open debug logical window
	;-> flags if error
	;***
OpenDebugWindow:
		moveq		#0,d2
		NEXTARG	2$						;Get optional number of lines
		move.l	d0,d2
2$		lea		(DebugName,pc),a1
		lea		(DebugShare,pc),a2
		lea		(lDebugEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin

		bsr		UpdateDisplay
		moveq		#1,d0
		rts

	;***
	;Close debug logical window
	;***
CloseDebugWindow:
		lea		(DebugLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: open/close extra window
	;a0 = cmdline
	;***
RoutXWin:
		move.l	(ExtraLW,pc),d0
		bne.b		CloseExtraWindow
	;Fall through

	;***
	;Open extra logical window
	;-> flags if error
	;***
OpenExtraWindow:
		moveq		#0,d2
		NEXTARG	1$						;Get optional number of lines
		move.l	d0,d2
1$		lea		(ExtraName,pc),a1
		lea		(ExtraShare,pc),a2
		lea		(ExtraEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin
		rts

	;***
	;Close extra logical window
	;***
CloseExtraWindow:
		lea		(ExtraLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: open/close PPrint window
	;a0 = cmdline
	;***
RoutOWin:
		move.l	(PPrintLW,pc),d0
		bne.b		ClosePPrintWindow
	;Fall through

	;***
	;Open PPrint logical window
	;-> flags if error
	;***
OpenPPrintWindow:
		moveq		#0,d2
		NEXTARG	1$						;Get optional number of lines
		move.l	d0,d2
1$		lea		(PPrintName,pc),a1
		lea		(PPrintShare,pc),a2
		lea		(PPrintEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin
		rts

	;***
	;Close PPrint logical window
	;***
ClosePPrintWindow:
		lea		(PPrintLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: open/close Watch window
	;a0 = cmdline
	;***
RoutWWin:
		move.l	(WatchLW,pc),d0
		bne.b		CloseWatchWindow
	;Fall through

	;***
	;Open Watch logical window
	;-> flags if error
	;***
OpenWatchWindow:
		moveq		#0,d2
		NEXTARG	1$						;Get optional number of lines
		move.l	d0,d2
1$		lea		(WatchName,pc),a1
		lea		(WatchShare,pc),a2
		lea		(WatchEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin
		rts

	;***
	;Close Watch logical window
	;***
CloseWatchWindow:
		lea		(WatchLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: open/close Rexx window
	;a0 = cmdline
	;***
RoutAWin:
		move.l	(RexxLW,pc),d0
		bne.b		CloseRexxWindow
	;Fall through

	;***
	;Open Rexx logical window
	;-> flags if error
	;***
OpenRexxWindow:
		moveq		#0,d2
		NEXTARG	1$						;Get optional number of lines
		move.l	d0,d2
1$		lea		(RexxName,pc),a1
		lea		(RexxShare,pc),a2
		lea		(RexxEntry,pc),a3
		bsr		OpenLogWin
		ERROReq	ErrOpenLogWin
		rts

	;***
	;Close Rexx logical window
	;***
CloseRexxWindow:
		lea		(RexxLW,pc),a0
		bra		CloseLogWin

	;***
	;Command: on logical window do something
	;***
RoutOn:
		bsr		GetLogWinE
		cmp.l		(DebugLW,pc),d0
		ERROReq	NoOutputOnDebug
		cmp.l		(SourceLW,pc),d0
		ERROReq	NoOutputOnDebug
		movea.l	d0,a2
		bsr		GetRestLinePer
		HERReq
		movea.l	d0,a0
	;Establish an error routine to restore the current window later on
		move.l	a0,-(a7)				;Remember pointer to command
		lea		(CurrentLW,pc),a1
		move.l	(a1),-(a7)			;Remember old current logwin
		move.l	a2,(a1)				;Store new current logwin
		moveq		#EXEC_ON,d0
		bsr		ExecAlias
		move.l	d0,d2					;Result
		move.l	d1,d3					;Error status

	;Clean up
		lea		(CurrentLW,pc),a0
		move.l	(a7)+,(a0)
		movea.l	(a7)+,a0
		bsr		FreeBlock

	;Quit
		tst.l		d3
		HERReq
		move.l	d2,d0					;Result
		rts

	;***
	;Command: scroll a logical window
	;***
RoutScroll:
		bsr		GetLogWinE
		movea.l	d0,a2
		EVALE								;Get x
		move.l	d0,d2
		EVALE								;Get y
		move.l	d0,d1
		move.l	d2,d0
		movea.l	a2,a0
		bra		LogWin_Scroll

	;***
	;Command: set active logical window
	;***
RoutActive:
		bsr		GetLogWinE
		movea.l	d0,a1
		movea.l	(myGlobal,pc),a0
		bra		Global_ActivateLogWin

	;***
	;Function: get active logical window
	;***
FuncGetActive:
		movea.l	(myGlobal,pc),a0
		move.l	(Global_ActiveLW,a0),d0
		rts

	;***
	;Command: set current logical window
	;***
RoutCurrent:
		bsr		GetLogWinE
		cmp.l		(MainLW,pc),d0
		beq.b		1$
		cmp.l		(ExtraLW,pc),d0
		bne.b		2$
1$		lea		(CurrentLW,pc),a0
		move.l	d0,(a0)
2$		rts

	;***
	;Function: get current logical window
	;***
FuncCurrent:
		move.l	(CurrentLW,pc),d0
		rts

	;***
	;Function: get name of public screen
	;***
FuncPubScreen:
	IFD	D20
		lea		(PubScreenT,pc),a0
		move.l	a0,d0
	ENDC
	IFND	D20
		moveq		#0,d0
	ENDC
		rts

	;***
	;Command: Fit a logical window
	;***
RoutFit:
		bsr		GetLogWinE
		movea.l	d0,a0

		move.w	(LogWin_ocol,a0),d0
		move.w	(LogWin_orow,a0),d1
		movem.l	d0-d1,-(a7)			;Remember old values

		bsr		LogWin_CalcVisible
		move.w	(LogWin_VisWidth,a0),d0
		move.w	(LogWin_VisHeight,a0),d1
		bsr		LogWin_SetColRow
		beq.b		1$
;		move.w	(LogWin_NumLines,a0),d1
;		move.w	(LogWin_NumColumns,a0),d0
;		bsr		LogWin_SetColRow
;		beq.b		1$

		lea		(8,a7),a7				;Remove old values from stack
		bra		LogWin_Refresh

	;Not enough memory
1$		movem.l	(a7)+,d0-d1			;Restore old values
		bsr		LogWin_SetColRow
		ERROReq	Quit
		bsr		LogWin_Refresh
		ERROR		NotEnoughMemory

	;***
	;Command: set the logical window size
	;***
RoutColRow:
		bsr		GetLogWinE
		movea.l	d0,a5
		EVALE								;Get col
		move.w	d0,d2
		addq.w	#1,d0					;== -1
		beq.b		1$
		subq.w	#4,d0					;>= 3
		bge.b		1$
2$		ERROR		BadArgValue

1$		EVALE								;Get row
		move.w	d0,d1
		addq.w	#1,d0					;== -1
		beq.b		3$
		subq.w	#4,d0					;< 3
		blt.b		2$

	;d1 = row
	;d2 = col
3$		move.w	d2,d0
		movea.l	a5,a0

		move.w	(LogWin_ocol,a0),d2
		move.w	(LogWin_orow,a0),d3
		movem.l	d2-d3,-(a7)			;Remember old values

		bsr		LogWin_SetColRow
		beq.b		4$
		lea		(8,a7),a7			;Remove old values from stack
		bra		RecalcWindow

	;Not enough memory
4$		movem.l	(a7)+,d0-d1			;Restore old values
		bsr		LogWin_SetColRow
		ERROReq	Quit
		bsr		LogWin_Refresh
		ERROR		NotEnoughMemory

	;***
	;Function: get the logical window x size
	;***
FuncGetCol:
		bsr		GetLogWinE
		movea.l	d0,a0
		moveq		#0,d0
		move.w	(LogWin_ocol,a0),d0
		rts

	;***
	;Function: get the logical window x size
	;***
FuncGetRow:
		bsr		GetLogWinE
		movea.l	d0,a0
		moveq		#0,d0
		move.w	(LogWin_orow,a0),d0
		rts

	;***
	;Command: set the font for the main powervisor window
	;***
RoutSetFont:
		bsr		GetLogWinE
		movea.l	d0,a4
		bsr		GetStringE			;Get font name
		movea.l	d0,a5
		EVALE								;Get font height
		moveq		#0,d1
		move.l	d1,d2
		move.b	#FPF_DESIGNED,d2
		movea.l	a5,a1
		movea.l	a4,a0
		bsr		LogWin_SetFont
		ERROReq	ErrorInFont
	;Fall through

	;***
	;Subroutine: recalculate one logical window
	;a0 = ptr to logical window
	;***
RecalcWindow:
		bsr		LogWin_ClearWindow
		bsr		LogWin_DefaultColRow

;		move.l	(LogWin_UserData,a0),d0
;		bne		UseEntrySize
		rts

	;***
	;Command: set powervisor screen colors
	;***
RoutColor:
		lea		(PVScreen,pc),a6
		tst.l		(a6)
		ERRORne	NoColorsOnWindow
		EVALE								;Color number
		move.l	d0,d7
		EVALE								;Red
		move.l	d0,d4
		EVALE								;Green
		move.l	d0,d5
		EVALE								;Blue
		move.l	d0,d6
		movea.l	(MyScreen,pc),a0
		lea		(sc_ViewPort,a0),a0
		move.l	d7,d0
		move.l	d4,d1
		move.l	d5,d2
		move.l	d6,d3
		CALLGRAF	SetRGB4
		rts

	;***
	;Command: set the size of a PowerVisor window
	;a0 = cmdline
	;***
RoutSize:
		moveq		#I_PWIN,d6
		bsr		SetList
		EVALE
		bsr		ResetList
		movea.l	d0,a2
		EVALE								;Width
		move.l	d0,d6
		EVALE								;Height
		move.l	d0,d7
		move.l	(nw_Flags+PhysWin_NewWindow,a2),d0
		andi.l	#WINDOWSIZING,d0
		ERROReq	NotSizable
		move.l	d6,d0
		move.l	d7,d1
		movea.l	a2,a0
		bra		PhysWin_Size

	;***
	;Command: set the location of a PowerVisor window
	;a0 = cmdline
	;***
RoutMove:
		moveq		#I_PWIN,d6
		bsr		SetList
		EVALE
		bsr		ResetList
		movea.l	d0,a2
		EVALE								;Pos X
		move.l	d0,d6
		EVALE								;Pos Y
		move.l	d0,d7
		move.l	(nw_Flags+PhysWin_NewWindow,a2),d0
		andi.l	#WINDOWDRAG,d0
		ERROReq	NotMovable
		move.l	d6,d0
		move.l	d7,d1
		movea.l	a2,a0
		bra		PhysWin_Move

	;***
	;Command: put the PowerVisor window on another screen
	;This command does nothing in hold mode
	;a0 = cmdline
	;d0 = next arg type
	;***
RoutScreen:
		move.b	(InHold),d1
		beq.b		4$
		rts

4$
 IFD D20
		movem.l	d0/a0,-(a7)
		bsr		TestForClose
		ERROReq	PleaseCloseVisitors
		movem.l	(a7)+,d0/a0
 ENDC
		move.l	#DEFAULTFLAGS,d5
		tst.l		d0						;End of line
		beq		1$
		move.l	#DEFAULTFLAGS2|ACTIVATE,d5
		moveq		#I_SCREEN,d6
		bsr		SetList
		EVALE
		tst.l		d0
		beq.b		1$
		lea		(PVScreen,pc),a0
		move.l	d0,(a0)
		move.l	d0,d6
		lea		(MyScreen,pc),a0
		move.l	(a0),d7
		clr.l		(a0)
	;On other screen
		bsr.b		9$
		lea		(FancyPens,pc),a1
		lea		(Pens,pc),a6
		move.l	a1,(a6)
		movea.l	d7,a0
		CALLINT	CloseScreen
		rts

	;Move all windows
	;d5 = flags for MainPW
	;d6 = screen
	;(d7 = old screen)
9$
	IFD D20
		bsr		GetVisualInfo
		bsr		SetMenuLayout
	ENDC

		movea.l	(MainPW,pc),a0
		move.l	d5,d0
		bsr		TestSBottom
		beq.b		7$
		addi.l	#SIZEBBOTTOM,d0
7$		bsr		PhysWin_ModifyFlags
	;Move all physical windows
		movea.l	(myGlobal,pc),a0
		lea		(Global_PWList,a0),a0
2$		movea.l	(a0),a0				;Succ
		tst.l		(a0)					;Succ
		beq.b		3$
		move.l	d6,d0
		bsr		PhysWin_ChangeScreen
		bra.b		2$
	;Init rest
	;Set window pointer
3$		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a0
		movea.l	(MainPW,pc),a1
		move.l	(PhysWin_Window,a1),(pr_WindowPtr,a0)
		bra		WindowGadgetPort

	;Back to own screen
1$		lea		(PVScreen,pc),a0
		clr.l		(a0)
		bsr		ClosePW
		bsr		CloseScreen
		bsr		OpenScreen
		beq		EndProg

		move.l	(MyScreen,pc),d6
		bra.b		9$

	;***
	;Command: clear the screen
	;***
RoutCls:
		movea.l	(CurrentLW,pc),a0
		bra		LogWin_Clear

	;***
	;Command: go to home location
	;***
RoutHome:
		movea.l	(CurrentLW,pc),a0
		bra		LogWin_TotalHome

	;***
	;Command: set a location on the screen
	;a0 = cmdline
	;***
RoutLocate:
	;(0,0) is top
		EVALE								;Get x
		move.l	d0,d7
		NEXTTYPE
		beq.b		3$						;Only x coord
		EVALE								;Get y
		bra.b		4$
	;Same y
3$		movea.l	(CurrentLW,pc),a0
		move.w	(LogWin_row,a0),d0
4$		move.l	d0,d1
		move.l	d7,d0
		movea.l	(CurrentLW,pc),a0
		bra		LogWin_Locate

	;***
	;Command: print a string on the screen
	;a0 = cmdline
	;***
RoutPrint:
		bsr		GetStringE
		movea.l	d0,a0
		PRINT
		movea.l	(CurrentLW,pc),a0
		bra		LogWin_Reprint

	;***
	;Command: display an integer on the screen
	;a0 = cmdline
	;***
RoutDisp:
		EVALE
		PRINTHEX
		rts

	;***
	;Function: get the current x coordinate
	;-> d0 = x coord
	;***
FuncGetX:
		movea.l	(CurrentLW,pc),a0
		moveq		#0,d0
		move.w	(LogWin_col,a0),d0
		rts

	;***
	;Function: get the current y coordinate
	;-> d0 = y coord
	;***
FuncGetY:
		movea.l	(CurrentLW,pc),a0
		moveq		#0,d0
		move.w	(LogWin_row,a0),d0
		rts

	;***
	;Function: get the character on the current position
	;-> d0 = char
	;***
FuncGetChar:
		movea.l	(CurrentLW,pc),a0
		move.w	(LogWin_col,a0),d0
		move.w	(LogWin_row,a0),d1
		bra		LogWin_GetChar

	;***
	;Function: get the pointer to the line on the current position
	;-> d0 = pointer
	;***
FuncGetLine:
		movea.l	(CurrentLW,pc),a0
		move.w	(LogWin_row,a0),d0
		movea.l	(LogWin_Buffer,a0),a0
		lsl.w		#2,d0
		movea.l	(0,a0,d0.w),a0
		lea		(1,a0),a0			;Skip attribute
		move.l	a0,d0
		rts

	;***
	;Function: get the number of lines in the buffer
	;-> d0 = lines
	;***
FuncLines:
		bsr		GetLogWinE
		movea.l	d0,a0
		moveq		#0,d0
		move.w	(LogWin_NumLines,a0),d0
		rts

	;***
	;Function: get the number of columns in the buffer
	;-> d0 = columns
	;***
FuncCols:
		bsr		GetLogWinE
		movea.l	d0,a0
		moveq		#0,d0
		move.w	(LogWin_NumColumns,a0),d0
		rts

	;***
	;Temporary busy prompt
	;***
BusyPrompt:
		lea		(InBusy,pc),a1
		move.b	#1,(a1)
		bra		SetGadgetState

	;***
	;Print current list indicator
	;***
PrintPrompt:
		lea		(InBusy,pc),a1
		clr.b		(a1)
		bra		SetGadgetState

	;***
	;Print prompt
	;This function is safe to call if PowerVisor is in hold mode
	;a0 = ptr to prompt string
	;***
IntPrintPrompt:
		movem.l	a2-a4,-(a7)
		movea.l	a0,a4
		movea.l	(MainPW,pc),a0
		movea.l	(PhysWin_Window,a0),a3
		bsr		PhysWin_GetRastPort
		movea.l	d0,a2					;Remember rastport
		beq.b		2$
		moveq		#0,d0					;Clear d0 and d1 completely
		move.l	d0,d1
		move.w	(wd_Height,a3),d1
		move.b	(wd_BorderBottom,a3),d0
		sub.w		d0,d1
		sub.w		(FontHeight,pc),d1
		movea.l	(TopazFont,pc),a0
		add.w		(tf_Baseline,a0),d1

		subq.w	#1,d1					;Pos to print prompt and stringgadget
		move.b	(wd_BorderLeft,a3),d0
		add.w		(PromptPos,pc),d0	;Pos to start printing prompt
		movea.l	a2,a1
		CALLGRAF	Move
		movea.l	(TopazFont,pc),a0
		movea.l	a2,a1
		CALL		SetFont
		GETPEN	PromptTextPen,d0,a1
		movea.l	a2,a1
		CALL		SetAPen
		movea.l	a4,a0
		moveq		#4,d0
		movea.l	a2,a1
		CALL		Text					;Print prompt (4 chars)
		moveq		#2,d0
		lea		(MesFeedBack,pc),a0
		cmpi.b	#'-',(a4)
		bne.b		1$
		lea		(4,a4),a0
1$		movea.l	a2,a1
		CALL		Text
2$		movem.l	(a7)+,a2-a4
		rts

	;***
	;Do feedback if appropriate
	;***
DoFeedBack:
		moveq		#mo_FeedBack,d0
		bsr		CheckModeBit
		beq.b		1$
		lea		(MesFeedBack,pc),a0
		PRINT
		movea.l	(Line,pc),a0
		PRINT
		NEWLINE
1$		rts

	;***
	;Function: get the qualifer of the previous key
	;-> d0 = qual
	;***
FuncQual:
		movea.l	(MainPW,pc),a0
		bra		PhysWin_GetQual

	;***
	;Function: get the next pressed key
	;-> d0 = key
	;***
FuncKey:
		movea.l	(CurrentLW,pc),a0
		bra		LogWin_GetKey

	;***
	;Handle crash signal
	;***
HandleCrash:
		movem.l	d2-d7/a2-a6,-(a7)
		bsr		CrashSignal
		movem.l	(a7)+,d2-d7/a2-a6
		rts

	;***
	;Handle portprint messages
	;***
HandlePortPrint:
		movem.l	a2-a6/d0-d7,-(a7)
		lea		(CurrentLW,pc),a0
		move.l	(a0),-(a7)
		move.l	(PPrintLW,pc),d0
		beq.b		2$
		move.l	d0,(a0)
2$		lea		(Port),a0
		CALLEXEC	GetMsg
		tst.l		d0
		beq.b		1$
		bsr.b		HandlePPMsgWK
1$		lea		(CurrentLW,pc),a2
		move.l	(a7)+,(a2)
		movem.l	(a7)+,a2-a6/d0-d7
		rts
	;Yes !
HandlePPMsgWK:
		movea.l	d0,a1
		move.l	a1,-(a7)
		move.w	(mn_Command,a1),d0
		subq.w	#1,d0
		beq.b		PPExecWK
		subq.w	#1,d0
		beq.b		PPDumpWK
		subq.w	#1,d0
		beq.b		PPPrintWK
		subq.w	#1,d0
		beq.b		PPPrintNumWK
		subq.w	#1,d0
		beq		PPSignalWK
ContPPWK:
		movea.l	(a7)+,a1
		move.l	(MN_REPLYPORT,a1),d0
		beq.b		1$
		CALLEXEC	ReplyMsg
1$		rts
PPDumpWK:
		movea.l	(mn_Data,a1),a4	;Ptr to stackframe
		moveq		#0,d6
		bsr		DumpRegsNL			;This is guaranteed to be non-interruptable
											;and no IDC commands will happen
		bra.b		ContPPWK
PPPrintWK:
		movea.l	(mn_Data,a1),a0	;Ptr to string
		bsr		PrintAC				;Non-interruptable and no IDC commands
		bra.b		ContPPWK
PPPrintNumWK:
		move.l	(mn_Data,a1),d0	;Number to print
		lea		(NoIDC,pc),a2
		move.b	#1,(a2)				;No IDC commands allowed
		PRINTHEX
		clr.b		(a2)					;Allow IDC commands
		bra.b		ContPPWK
PPExecWK:
		movea.l	(mn_Data,a1),a0	;Ptr to <command> <data> <size>
		movea.l	(a0)+,a5				;Ptr to command
		move.l	(a0)+,d0				;Data
		beq.b		1$
	;There is data
		movea.l	d0,a4
		move.l	(a0)+,d0				;Size
		move.l	d0,d4					;Remember size of data
		beq.b		1$
		moveq		#0,d1
		bsr		AllocMem
		beq.b		1$
		movea.l	a4,a0
		movea.l	d0,a1
		move.l	a1,-(a7)
		move.l	d4,d0
		CALLEXEC	CopyMem
		move.l	(a7)+,d0
	;No data
1$		movea.l	d0,a4					;Ptr to data
		bsr		StoreRC
	;a4=data,d4=size,a5=command
		movea.l	a5,a0
		movem.l	d4/a4,-(a7)
		moveq		#EXEC_PPEXEC,d0

		lea		(NoIDC,pc),a2
		move.b	#1,(a2)				;No IDC commands allowed

		bsr		ExecAlias			;We ignore errors

		lea		(NoIDC,pc),a2
		clr.b		(a2)					;Allow IDC commands

		movem.l	(a7)+,d4/a4
		movea.l	(a7),a1				;Ptr to message
		move.l	d0,(mn_Data,a1)	;Returncode
		move.l	d4,d0
		movea.l	a4,a1
		bsr		FreeMem
		bra		ContPPWK
	;We got a special signal. At this moment only SIGNAL_BUSERR is
	;supported
PPSignalWK:
		move.l	(mn_Data,a1),d0	;Signal number
		lea		(NoIDC,pc),a2
		move.b	#1,(a2)				;No IDC commands allowed
		bsr		DumpBERRs
		clr.b		(a2)					;Allow IDC commands
		bra		ContPPWK

	;***
	;A debug task has send a debug signal
	;***
HandleDebug:
		movem.l	a2-a6/d0-d7,-(a7)
11$	lea		(DebugList),a3
1$		movea.l	(a3),a3				;Succ
		tst.l		(a3)					;Succ
		beq		10$
		move.b	(db_SMode,a3),d7
		cmpi.b	#DBS_ERROR,d7
		beq.b		5$
		cmpi.b	#DBS_CRASH,d7
		beq.b		5$
		cmpi.b	#DBS_BREAK,d7
		beq.b		5$
		cmpi.b	#DBS_TBREAK,d7
		bne.b		1$

	;Clean Additional argument
		moveq		#0,d0
		bsr		SetAdditional

5$		move.b	#DB_NONE,(db_Mode,a3)
		move.b	#DBS_WAIT,(db_SMode,a3)
		movea.l	(db_Task,a3),a2
	;Wait for the completion of the signal
3$		moveq		#1,d1
		CALLDOS	Delay
		tst.b		(db_SpecialBit,a3)
		beq.b		3$
		bsr		Disable
		lea		(db_PC,a3),a0
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a1
		moveq		#15,d0				;Loop 16 times

8$		move.l	(a0)+,(a1)+
		dbra		d0,8$

		move.w	(a0),(a1)
		andi.b	#$3f,(4,a4)			;Disable trace mode
		move.l	(TC_SIGWAIT,a2),(db_SigWait,a3)
		move.b	(TC_STATE,a2),(db_TaskState,a3)
		clr.l		(TC_SIGWAIT,a2)
		move.b	#TS_WAIT,(TC_STATE,a2)
		movea.l	a2,a1
		CALLEXEC	Remove
		movea.l	a2,a1
		lea		(TaskWait,a6),a0
		CALL		AddHead
		bsr		Enable
		movem.l	a3/d7,-(a7)
		bsr		PrintInfoTR
		movem.l	(a7)+,a3/d7
		cmpi.b	#DBS_BREAK,d7
		beq.b		2$
		cmpi.b	#DBS_ERROR,d7
		beq.b		4$
		cmpi.b	#DBS_CRASH,d7
		bne		11$
		moveq		#0,d0
		move.w	(db_Crash,a3),d0
		subq.w	#2,d0
		blt.b		9$
		cmpi.w	#9,d0
		bgt.b		9$
		addi.w	#ERR_CrBusError,d0
		bsr		SetError
		bsr		GetError
		bra.b		6$
9$		lea		(MesDBCrash,pc),a0
6$		bsr		PrintAC
		NEWLINE
		bra		11$
4$		lea		(MesDBError,pc),a0
		bra.b		6$
2$		lea		(MesDBBreak,pc),a0
		bra.b		6$

10$	movem.l	(a7)+,a2-a6/d0-d7
		rts

	;***
	;Return signal mask for all signals (look at sync variable)
	;-> d0 = signal mask
	;***
AllSignals:
		bsr		TimerSignal			;Get signal number for timer
		or.l		(RexxBit),d0
		or.l		(CrashSigBit),d0
		or.l		(TraceSigSet),d0
		or.l		(IDevSigSet),d0
		or.l		(HoldSigSet),d0
		movea.l	(myGlobal,pc),a0
		or.l		(Global_SigSet,a0),d0
		tst.w		(InSync)
		bne.b		1$
		or.l		(RefreshSet),d0
1$		move.b	(InBusy,pc),d1
		cmpi.b	#2,d1
		bne.b		2$
	;We are in lock mode, don't catch Rexx and PortPrint commands
		move.l	(RexxBit),d1
		or.l		(RefreshSet),d1
		not.l		d1
		and.l		d1,d0
2$		rts

	;***
	;Handle signals
	;d0 = signal set that arrived
	;-> d0 = value in d7
	;***
HandleSignals:
		movem.l	d1-d7/a0-a6,-(a7)
		move.l	d0,d1

	;Check timer
		bsr		CheckTimer

	;Check if PW message
		move.l	d1,d0
		movea.l	(myGlobal,pc),a0
		bsr		Global_CheckSignal
		beq.b		6$
		bsr		HandlePhysWinWK

	;Check Hold message
6$		move.l	d1,d0
		and.l		(HoldSigSet),d0
		beq.b		8$
		move.l	d1,-(a7)
		moveq		#10,d1
		CALLDOS	Delay
		move.l	(a7)+,d1
		bsr		ActivateGadget

	;Check Rexx message
8$		move.l	d1,d0
		and.l		(RexxBit),d0
		beq.b		1$
		bsr		CheckRexx
	;Check IDC
1$		move.l	d1,d0
		and.l		(IDevSigSet),d0
		beq.b		3$
		bsr		ExecIDCWK
	;Check PortPrint message
3$		move.l	d1,d0
		and.l		(RefreshSet),d0
		beq.b		5$
		bsr		HandlePortPrint
	;Check debug message
5$		move.l	d1,d0
		and.l		(TraceSigSet),d0
		beq.b		4$
		bsr		HandleDebug
	;Check crash signal
4$		move.l	d1,d0
		and.l		(CrashSigBit),d0
		beq.b		7$
		bsr		HandleCrash
	;The end
7$		move.l	d7,d0
		movem.l	(a7)+,d1-d7/a0-a6
		rts

	;***
	;Free input
	;***
FreeInput:
		movem.l	a0/d0,-(a7)
		bsr		GetInputVar
		beq.b		1$
	;Free previous input
		movea.l	d0,a0
		bsr		FreeBlock
		moveq		#0,d0
		bsr		StoreInput
1$		movem.l	(a7)+,a0/d0
		rts

	;***
	;Command: wait for input
	;This command does nothing if there is no window
	;(PowerVisor is in hold mode)
	;***
RoutScan:
		movea.l	(MainPW,pc),a1
		tst.l		(PhysWin_Window,a1)
		bne.b		1$
		rts

1$		bsr.b		FreeInput

		lea		(ScanPrompt,pc),a2
		move.l	#'????',(a2)
		tst.l		d0						;End of line
		beq.b		4$
		EVALE
		move.l	d0,(a2)

4$		movea.l	(CurrentLW,pc),a0
		lea		(LockWin,pc),a1
		move.l	a0,(a1)
		lea		(LockState,pc),a1
		clr.b		(a1)
		move.b	(InBusy,pc),d1
		lea		(InBusy,pc),a1
		move.b	#2,(a1)
		lea		(LockPtr,pc),a1
		move.l	a2,(a1)
		bsr		SetGadgetState

		move.l	d1,-(a7)
		bsr		InternalScan
		move.l	(a7)+,d1

		lea		(LockWin,pc),a1
		clr.l		(a1)
		lea		(InBusy,pc),a1
		move.b	d1,(a1)
		bsr		SetGadgetState

		movea.l	(Line,pc),a0
		bsr		AllocStringInt
		HERReq
		bsr		StoreInput
		move.l	d0,-(a7)
		bsr		InitCommandLine
		bsr		RefreshGadget
		move.l	(a7)+,d0
		rts

	;***
	;Clear commandline and init stringgadget
	;***
InitCommandLine:
		move.b	(DontClearLine,pc),d0
		bne.b		2$
	;Clear linebuffer
		move.w	(DefLineLen,pc),d0
		subq.w	#1,d0
		movea.l	(Line,pc),a0

1$		clr.b		(a0)+
		dbra		d0,1$

2$		lea		(mStringInfo,pc),a0
		move.w	(GadCursorPos,pc),(si_BufferPos,a0)
		move.w	(GadCursorPos,pc),(si_DispPos,a0)
		lea		(GadCursorPos,pc),a0
		clr.w		(a0)
		lea		(DontClearLine,pc),a0
		clr.b		(a0)
		rts

SetCursor:
		lea		(mStringInfo,pc),a0
		move.w	(GadCursorPos,pc),(si_BufferPos,a0)
		move.w	(GadCursorPos,pc),(si_DispPos,a0)
		rts

	;***
	;Scan: Waits for a line of input
	;InternalScan: the same but the prompt is not set to default
	;-> line in Line
	;***
Scan:
		lea		(InBusy,pc),a0
		clr.b		(a0)

InternalScan:
		move.l	d7,-(a7)
		bsr		InitCommandLine
		bsr		ResetHistory

		moveq		#0,d7					;We must not stop

		bsr		HandlePhysWinWK
		bsr		SetGadgetState

	;Main loop
1$		bsr		AllSignals
		tst.l		d7
		beq.b		7$
		move.l	(a7)+,d7
		rts
7$		CALLEXEC	Wait
		bsr		HandleSignals
		move.l	d0,d7
		bra.b		1$

	;***
	;Handle PhysWin messages
	;Called by : InternalScan and HandleSignals
	;***
HandlePhysWinWK:
		movem.l	d0-d1,-(a7)
2$		movea.l	(myGlobal,pc),a0
		bsr		Global_CheckMsg
		beq.b		1$

		movea.l	a1,a0
		bsr		PhysWin_HandleMsg
		beq.b		2$

	;Message was not understood, we must see what is going on
		movea.l	d0,a1					;Pointer to msg in a1
		bsr.b		HandleWK
		bra.b		2$

	;The end, all messages where succesfully handled and all
	;unknown messages where ignored
1$		movem.l	(a7)+,d0-d1
		rts

	;Handle message
	;a1 = msg
	;a0 = PW
HandleWK:
		movem.l	a0-a2,-(a7)
		movea.l	a0,a2					;Store PW

		lea		(Class,pc),a0
		move.l	(im_Class,a1),(a0)+
		move.w	(im_Code,a1),(a0)+
		move.l	(im_IAddress,a1),(a0)+
		move.w	(im_MouseX,a1),(a0)+
		move.w	(im_MouseY,a1),(a0)+
		move.w	(im_Qualifier,a1),(a0)+
		movea.l	a2,a0
		bsr		PhysWin_ReplyMsg

		bsr.b		2$
		movem.l	(a7)+,a0-a2
		rts

2$		move.l	(Class,pc),d0
		cmpi.l	#INTUITICKS,d0
		beq		IntuiTicksWK

	IFD D20
		cmpi.l	#MOUSEMOVE,d0
		beq		ScrollGadgetWK
	ENDC
		cmpi.l	#GADGETUP,d0
		beq		SGadgetWK

		move.b	(GadgetExists,pc),d1
		beq.b		3$

	;String gadget exists, we can snap, enter, receive menu entries
	IFD D20
		cmpi.l	#MENUPICK,d0
		beq.b		MenuPickWK
	ENDC
		addq.l	#1,d0					;Test for -1
		beq		PossibleSnapWK
		rts

	;String gadget does not exist, process VANILLAKEY
3$		cmpi.l	#VANILLAKEY,d0
		beq.b		VanillaWK
		rts

 IFD D20
	;Menu
	;a2 = PW
MenuPickWK:
		move.w	(Code,pc),d0
1$		cmpi.w	#MENUNULL,d0
		beq		ActivateGadget		;Activate gadget before returning to caller

		movea.l	(AllMenus,pc),a0	;Menu strip
		ext.l		d0						;Code
		CALLINT	ItemAddress
		movea.l	d0,a0
		movem.l	a0-a2/d2/d7,-(a7)	;Remember item address
		GTMENUITEM_USERDATA	a0,d2	;Get pointer to userdata

		move.b	(InBusy,pc),d0
		bne.b		3$

		bsr		ClearBreak
		bsr		BusyPrompt
		movea.l	(CurrentLW,pc),a0
		bsr		LogWin_StartPage
		moveq		#EXEC_MENU,d0
		movea.l	d2,a0
		bsr		ExecAlias
		bne.b		2$

	;Error
		moveq		#0,d0
		move.w	(LastError),d0
		cmpi.w	#ERR_Quit,d0
		HERReq
		bsr		GetError
		bsr		PrintAC
		NEWLINE

2$		bsr		PrintPrompt
3$		movem.l	(a7)+,a0-a2/d2/d7	;Restore item address
		move.w	(mi_NextSelect,a0),d0	;Next code
		bra.b		1$
 ENDC

	;Vanillakey
	;a2 = PW
VanillaWK:
		bsr		FuncGetActive
		cmp.l		(LockWin,pc),d0
		bne.b		1$

	;The active logical window is the locked logical window, send key
		move.w	(Code,pc),(PhysWin_LastCode,a2)
		move.w	(Qualifier,pc),(PhysWin_LastQualifier,a2)
1$		rts

	IFD D20
	;Scroll gadget
ScrollGadgetWK:
		move.l	(IAddress,pc),d0
		beq.b		2$
		movea.l	d0,a0
	;It is not the string gadget, it could be a scrollbar (ID == 0)
		movea.l	(gg_UserData,a0),a1	;Get pointer to Box
		move.l	(Box_LogWin,a1),d0	;Get pointer to LogWin
		beq.b		2$
		movea.l	d0,a0
	;Little sanity check. I do this check because I'm paranoic about
	;the 'IAddress' field in the IntuiMessage structure being used
	;for something else in future. With this check, I'm almost sure
	;that we have a message from one of our scrollbars
		cmpa.l	(LogWin_Box,a0),a1
		bne.b		2$

		move.w	(Code,pc),d1
		movea.l	(LogWin_ScrollHandler,a0),a1
		jmp		(a1)

2$		rts

	;a0 = logical window
	;d1 = position in scrollbar
DefaultScrollHandler:
		move.w	(LogWin_viscol,a0),d0
		bra		LogWin_ScrollNoSBar

	ENDC

	;String gadget return
SGadgetWK:
		movea.l	(IAddress,pc),a0
		cmpi.w	#1,(gg_GadgetID,a0)
	IFD D20
		bne.b		ScrollGadgetWK
	ENDC
	IFND D20
		beq.b		1$
		rts
	ENDC

	;Really do the 'return'
1$		move.b	(GadgetExists,pc),d0
		beq.b		2$						;Gadget doesn't exist, do not 'return'

 IFD D20
		move.w	(Code,pc),d0
		cmpi.w	#$1234,d0
		beq		ActivateGadget		;$1234 code is put there by hook
 ENDC
		movea.l	(Line,pc),a0
		bsr		AddHistory			;We ignore possible errors here
		lea		(mStringInfo,pc),a0
		clr.b		(DontClearLine)
		moveq		#1,d7
2$		rts

IntuiTicksWK:
		move.b	(InBusy,pc),d0
		bne.b		2$						;Only refresh if not busy and not locked
		move.w	(SpeedRefresh),d0
		bne.b		1$
2$		rts
1$		lea		(CountRefresh),a0
		subq.w	#1,(a0)
		bne.b		2$
		move.w	(SpeedRefresh),(a0)

	;Indicate that from now on, IDC commands are not allowed, since we
	;are on another current logical window (this info is for 'Print')
		lea		(NoIDC,pc),a0
		move.b	#1,(a0)

	;Really refresh
		movem.l	d1-d7/a2-a5,-(a7)
		lea		(CurrentLW,pc),a6
		move.l	(a6),-(a7)
		move.l	(RefreshLW,pc),d0
		beq.b		3$
		move.l	d0,(a6)
3$		movea.l	(a6),a0				;Get current logical window
		bsr		LogWin_StartPage
		lea		(RefreshRoutine,pc),a5
		bsr		ErrorHandler

	;Clean up
		lea		(CurrentLW,pc),a6
		move.l	(a7)+,(a6)

	;IDC commands are allowed again
		lea		(NoIDC,pc),a0
		clr.b		(a0)

		movem.l	(a7)+,d1-d7/a2-a5
		rts

	;***
	;This routine gets called from the error handler
	;***
RefreshRoutine:
	;Try to execute it
		move.l	(RefreshCmd),d0
		beq.b		1$
	;We must execute a command
		movea.l	d0,a0
		moveq		#EXEC_REFRESH,d0
		bsr		ExecAlias
;		HERReq
1$		rts

	;We got a snap message, test if it is really a snap
PossibleSnapWK:
		move.w	(Code,pc),d0
		cmpi.w	#PWMSG_SNAP,d0
		beq.b		9$
		rts
	;Yes, there is a SNAP message !
	;Call the correct snap handler
9$		movea.l	(IAddress,pc),a0	;Pointer to box
		move.l	(Box_LogWin,a0),d0
		beq.b		1$						;Empty box
		movea.l	d0,a0
		movea.l	(LogWin_SnapHandler,a0),a1
		movem.l	d2-d7/a2-a5,-(a7)
		jsr		(a1)
		movem.l	(a7)+,d2-d7/a2-a5
1$		rts

	;***
	;This is the default snap handler, this handler simply copies
	;the snapped word to the commandline
	;a0 = pointer to logwin
	;***
DefaultSnapHandler:
		lea		(mStringGad,pc),a1
		move.w	(gg_Flags,a1),d0
		andi.w	#$100,d0
		beq.b		8$
		rts
	;Now comes the 'snap' bit
8$		move.w	(MouseX,pc),d0
		move.w	(MouseY,pc),d1
		moveq		#120,d2
		movea.l	(SnapBuffer,pc),a1
		bsr		LogWin_GetWord
		bne.b		1$

	;Snap a space, we did not catch anything
		movea.l	(SnapBuffer,pc),a1
		moveq		#mo_LoneSpc,d0
		bsr		CheckModeBit
		beq.b		2$
		move.b	#' ',(a1)+
2$		clr.b		(a1)
		bra.b		3$

	;Snap, but first check if we must add a space
1$		move.l	d0,d1
		moveq		#mo_Space,d0
		bsr		CheckModeBit
		beq.b		3$
	;Yes, we must add a space
		movea.l	(SnapBuffer,pc),a1
		move.b	#' ',(-1,a1,d1.w)
		clr.b		(0,a1,d1.w)
	;Snap
3$		lea		(mStringInfo,pc),a0
		move.w	(si_BufferPos,a0),d0
		movea.l	(si_Buffer,a0),a3
		movea.l	(SnapBuffer,pc),a1

	;First call the pre-snap routine
		move.l	(SnapCommand,pc),d1
		beq.b		4$
	;Yes !!!
		movem.l	d0/a0-a3/a5/d7,-(a7)
		movea.l	d1,a0
		moveq		#EXEC_SNAP,d0
		bsr		ExecAlias			;We ignore errors
		tst.l		d0
		movem.l	(a7)+,d0/a0-a3/a5/d7
		bne.b		4$
		rts								;If result from execute is 0 we abort snapping

	;No
4$		move.b	(a1)+,d1
		beq.b		5$
		tst.b		(0,a3,d0.w)
		bne.b		6$						;We overwrite another char
		addi.w	#1,(si_NumChars,a0)
6$		cmpi.b	#-1,(1,a3,d0.w)		;Check if we don't go to far
		beq.b		7$
		move.b	d1,(0,a3,d0.w)
		clr.b		(1,a3,d0.w)
		addq.w	#1,d0
		bra.b		4$
	;Error, displaybeep
7$		move.l	a0,-(a7)
		suba.l	a0,a0
		CALLINT	DisplayBeep
		movea.l	(a7)+,a0
	;End snap
5$		move.w	d0,(si_BufferPos,a0)
		bra		RefreshGadget

	IFD D20
	;***
	;This is the scroll handler for the Source logical window
	;a0 = logical window
	;d1 = position in scrollbar
	;***
SourceScrollHandler:
		move.l	(CurrentDebug),d0
		beq.b		1$
	;Get the current line in the current loaded source
		move.l	d1,d0					;Line in source
		addq.l	#1,d0
		moveq		#1,d1					;Redraw always
		bsr		GotoSourceLineNoSBar
1$		rts

	;***
	;The handler for the creation of a scrollbar for the source
	;logical window
	;a0 = logical window
	;***
SourceCreateSBHandler:
		movem.l	d0-d7/a0-a6,-(a7)
		move.l	(CurrentDebug),d0
		beq.b		1$
		movea.l	d0,a2
		bsr		UpdateSourceSBar
1$		movem.l	(a7)+,d0-d7/a0-a6
		rts
	ENDC

	;***
	;The refresh handler for the source logical window
	;a0 = logical window
	;-> preserves all registers
	;***
SourceRefreshHandler:
		movem.l	d0-d7/a0-a6,-(a7)
		move.l	(CurrentDebug),d0
		beq.b		1$
		movea.l	d0,a2
		move.l	(db_Source,a2),d0
		beq.b		1$
		move.l	(db_CurrentSource,a2),d0
		beq.b		1$
		movea.l	d0,a3
		move.l	(srcf_TopLine,a3),d0
		moveq		#1,d1					;Redraw always
		bsr		GotoSourceLine
1$		movem.l	(a7)+,d0-d7/a0-a6
		rts

	;***
	;This is the snap handler for the Source logical window, it calls the
	;default snap handler if there is anything to snap, otherwise it simply
	;scrolls the source
	;a0 = pointer to logwin
	;***
SourceSnapHandler:
		move.w	(MouseY,pc),d0
		bsr		LogWin_GetRow
		move.l	d0,d1
		blt.b		1$

	;Get the current line in the current loaded source
		move.l	(CurrentDebug),d0
		beq.b		1$
		movea.l	d0,a2
		move.l	(db_Source,a2),d0
		beq.b		1$
		move.l	(db_CurrentSource,a2),d0
		beq.b		1$
		movea.l	d0,a3
		move.l	(srcf_TopLine,a3),d2

	;We have a valid position in the buffer for the logical window
	;Convert this position in the buffer to a position in the
	;logical window, we know for sure that this position is visible
	;because it was just clicked on by the user
		sub.w		(LogWin_visrow,a0),d1
		cmp.w		#2,d1
		blt.b		2$
		move.w	(LogWin_height,a0),d0
		sub.w		d1,d0
		cmp.w		#2,d0
		bgt.b		1$

	;Yes, we must scroll the window down (to higher linenumbers) if we can
		addq.l	#3,d2
		move.l	d2,d0
		moveq		#1,d1					;Redraw always
		bra		GotoSourceLine

	;Yes, we must scroll the window up (to lower linenumbers) if we can
2$		subq.l	#3,d2
		move.l	d2,d0
		moveq		#1,d1					;Redraw always
		bra		GotoSourceLine

1$		bra		DefaultSnapHandler

	;Execute an input device command
ExecIDCWK:
		movem.l	d0-d7/a0-a6,-(a7)
		moveq		#0,d0
		move.b	(InputDevCmd),d0
		lsl.w		#2,d0
		lea		(IDCtable,pc),a0
		movea.l	(-4,a0,d0.w),a0		;a0 = ptr to IDC handling routine
		jsr		(a0)
		movem.l	(a7)+,d0-d7/a0-a6
		rts

	;IDC routines

IDCNextWin:
		movea.l	(myGlobal,pc),a0
		bra		Global_CycleActive

IDCScroll1Up:
		moveq		#0,d0
		moveq		#-1,d1
IDCScrollGeneral:
		movea.l	(myGlobal,pc),a0
		movea.l	(Global_ActiveLW,a0),a0
		add.w		(LogWin_viscol,a0),d0
		add.w		(LogWin_visrow,a0),d1
		bra		LogWin_Scroll

IDCScrollPgUp:
		moveq		#0,d0
		moveq		#-5,d1
		bra.b		IDCScrollGeneral

IDCScrollHome:
		movea.l	(myGlobal,pc),a0
		movea.l	(Global_ActiveLW,a0),a0
		moveq		#0,d0
		move.l	d0,d1
		bra		LogWin_Scroll

IDCScrollEnd:
		movea.l	(myGlobal,pc),a0
		movea.l	(Global_ActiveLW,a0),a0
		moveq		#0,d0
		move.w	#30000,d1
		bra		LogWin_Scroll

IDCScroll1Do:
		moveq		#0,d0
		moveq		#1,d1
		bra.b		IDCScrollGeneral

IDCScrollPgDo:
		moveq		#0,d0
		moveq		#5,d1
		bra.b		IDCScrollGeneral

IDCScrollRight:
		move.w	#30000,d0
		moveq		#0,d1
		bra.b		IDCScrollGeneral

IDCScroll1Ri:
		moveq		#1,d0
		moveq		#0,d1
		bra.b		IDCScrollGeneral

IDCScroll1Le:
		moveq		#-1,d0
		moveq		#0,d1
		bra.b		IDCScrollGeneral

IDCDScroll1IUp:
		bra		RoutDPrevI

IDCDScroll1IDo:
		bra		RoutDNextI

IDCDScroll1Up:
		moveq		#-2,d1
		bra		ScrollDebug

IDCDScrollPgUp:
		moveq		#-20,d1
		bra		ScrollDebug

IDCDScroll1Do:
		moveq		#2,d1
		bra		ScrollDebug

IDCDScrollPgDo:
		moveq		#20,d1
		bra		ScrollDebug

IDCDScrollPC:
		bra		PCScrollDebug

IDCSnap:
		lea		(mStringInfo,pc),a0
		move.w	(si_BufferPos,a0),d0
		movea.l	(si_Buffer,a0),a3
		movea.l	(InputDevArg),a1

4$		move.b	(a1)+,d1
		beq.b		5$
		tst.b		(0,a3,d0.w)
		bne.b		6$						;We overwrite another char
		addi.w	#1,(si_NumChars,a0)
6$		cmpi.b	#-1,(1,a3,d0.w)	;Check if we don't go to far
		beq.b		7$
		move.b	d1,(0,a3,d0.w)
		clr.b		(1,a3,d0.w)
		addq.w	#1,d0
		bra.b		4$
	;Error, displaybeep
7$		move.l	a0,-(a7)
		suba.l	a0,a0
		CALLINT	DisplayBeep
		movea.l	(a7)+,a0
	;End snap
5$		move.w	d0,(si_BufferPos,a0)
		bra		RefreshGadget

IDCExec:
		move.b	(InBusy,pc),d0
		bne.b		1$
		bsr		BusyPrompt
		bsr.b		IDCExecAlways
		bsr		PrintPrompt
1$		rts

IDCExecAlways:
	;Check if allowed
		move.b	(NoIDC,pc),d0
		bne.b		1$

		bsr		ClearBreak
		movea.l	(CurrentLW,pc),a0
		bsr		LogWin_StartPage
		movea.l	(InputDevArg),a0
		bsr		AllocStringInt
		beq.b		1$
		movea.l	d0,a0
		move.l	d0,-(a7)
		move.l	d7,-(a7)
		moveq		#EXEC_ATTACH,d0
		bsr		ExecAlias
		move.l	(a7)+,d7
		movea.l	(a7)+,a0
		bsr		FreeBlock
		tst.l		d1						;FreeBlock preserves d1
		bne.b		1$

	;Error
		moveq		#0,d0
		move.w	(LastError),d0
		bsr		GetError
		bsr		PrintAC
		NEWLINE
1$		rts

	;***
	;String gadget functions
	;These functions are safe to call if PowerVisor is in hold mode
	;***
RemoveGadget:
		movem.l	d0-d1/a0-a1,-(a7)
		move.b	(GadgetExists,pc),d0
		beq.b		1$

		move.l	(MainPW,pc),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0
		lea		(mStringGad,pc),a1
		CALLINT	RemoveGadget
		lea		(GadgetExists,pc),a0
		clr.b		(a0)
1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

AddGadget:
		movem.l	d0-d1/a0-a1,-(a7)
		move.b	(GadgetExists,pc),d0
		bne.b		1$
		move.l	(msgUserData,pc),d0
		bne.b		1$

		move.l	(MainPW,pc),d0
		beq.b		1$
		movea.l	d0,a0
		move.l	(PhysWin_Window,a0),d0
		beq.b		1$
		movea.l	d0,a0
		lea		(mStringGad,pc),a1
		moveq		#-1,d0
		CALLINT	AddGadget
		lea		(GadgetExists,pc),a0
		move.b	#1,(a0)
1$		movem.l	(a7)+,d0-d1/a0-a1
		rts

RefreshGadget:
		movem.l	d0-d1/a0-a2,-(a7)
		move.b	(GadgetExists,pc),d0
		beq.b		1$
		lea		(mStringGad,pc),a0
		move.w	(gg_Flags,a0),d0
		andi.w	#GADGDISABLED,d0
		bne.b		1$
		movea.l	(MainPW,pc),a1
		move.l	(PhysWin_Window,a1),d0
		beq.b		1$
		movea.l	d0,a1
		suba.l	a2,a2
		CALLINT	RefreshGadgets
1$		movem.l	(a7)+,d0-d1/a0-a2
		rts

ActivateGadget:
		movem.l	d0-d1/a0-a2,-(a7)
		move.b	(GadgetExists,pc),d0
		beq.b		1$
		lea		(mStringGad,pc),a0

		move.w	(gg_Flags,a0),d0
		andi.w	#GADGDISABLED,d0
		bne.b		1$

 IFND D20
		andi.w	#~SELECTED,(gg_Flags,a0)
 ENDC

		movea.l	(MainPW,pc),a1
		move.l	(PhysWin_Window,a1),d0
		beq.b		1$
		movea.l	d0,a1
		suba.l	a2,a2
		CALLINT	ActivateGadget
1$		movem.l	(a7)+,d0-d1/a0-a2
		rts

	;***
	;Print a striped line
	;-> preserves a1 and d1
	;***
PrintLine:
		moveq		#6,d0					;Loop 7 times
		lea		(LineLine,pc),a0

1$		PRINT
		dbra		d0,1$

		lea		(LineLine2,pc),a0
		PRINT
		NEWLINE
		rts

	;***
	;Print a char
	;d0 = char
	;-> preserves all registers except a6
	;***
PrintChar:
		movem.l	d0-d1/a0-a1,-(a7)
		pea		(0).w
		move.w	d0,(a7)
		lea		(1,a7),a0			;Pointer to char
		bsr		PrintAC
		lea		(4,a7),a7			;Restore stack
		movem.l	(a7)+,d0-d1/a0-a1
		rts

	;***
	;Format strings for SpecialPrint
	;***
spFmtStr:	dc.b	"d",0,0,0
				dc.b	"ld",0,0
				dc.b	"04x",0
				dc.b	"08lx"
				dc.b	"s",0,0,0

spAftStr:	dc.b	" ",0,0,0
				dc.b	" : ",0
				dc.b	10,0,0,0
				dc.b	",",0,0,0

	;***
	;Special print routine
	;a1 = pointer to structure
	;d2 = structure describer (four bytes, each byte is 6+2 bits, first 6
	;		bits describe offset in structure, last 2 bits describe size of
	;		element in structure (0=nop, 1=B, 2=W, 3=L), four bytes are used
	;		from right to left (right most byte is first byte put on stack, thus
	;		corresponds with first % formatting option))
	;d3 = structure describer (four bytes, each byte is is 4+4 bits, first
	;		four bits describe string after number, second four bits describe
	;		formatstring of number)
	;-> all registers are preserved
	;***
SpecialPrint:
		movem.l	a0-a1/a4/d0-d4,-(a7)
		move.l	d3,d4
		movea.l	a7,a4

		moveq		#3,d0					;Loop 4 times

1$		move.b	d2,d1
		moveq		#0,d3
		move.b	d2,d3
		andi.b	#%11111100,d3		;Offset bits
		lsr.w		#2,d3					;d3 = offset in structure
		andi.w	#%00000011,d1		;Get size bits (0=nop, 1=B, 2=W, 3=L)
		add.w		d1,d1
		jmp		(2,pc,d1.w)

		bra.b		2$						;Must be short !
		bra.b		3$						;Must be short !
		bra.b		4$						;Must be short !
	;L
		move.l	(0,a1,d3.w),-(a7)
		bra.b		5$

	;W
4$		move.w	(0,a1,d3.w),-(a7)
		bra.b		5$

	;B
3$		moveq		#0,d1
		move.b	(0,a1,d3.w),d1
		move.w	d1,-(a7)

	;Print the number
5$		movem.l	a1/d0,-(a7)
		movea.l	(Storage),a0
		addq.l	#1,a0					;Storage+1 is odd so Storage+2 will be even
		move.b	#'%',(a0)+
		move.b	d4,d0
		andi.w	#$f,d0				;Get formatstring number
		lsl.w		#2,d0
		lea		(spFmtStr,pc),a1
		move.l	(0,a1,d0.w),(a0)
		clr.b		(4,a0)
6$		tst.b		(a0)+
		bne.b		6$
		subq.l	#1,a0
		move.b	d4,d0
		andi.w	#$f0,d0				;Get afterstring number
		lsr.w		#2,d0
		lea		(spAftStr,pc),a1
		lea		(0,a1,d0.w),a1
7$		move.b	(a1)+,(a0)+
		bne.b		7$

		movea.l	(Storage),a0
		addq.l	#1,a0					;Format string
		move.l	a0,d0
		addq.l	#8,d0
		addq.l	#8,d0					;Input string
		lea		(8,a7),a1			;Data
		bsr		SPrintf
		movea.l	(Storage),a0
		lea		(17,a0),a0
		bsr.b		Print80
		movem.l	(a7)+,a1/d0

	;Continue
2$		lsr.l		#8,d2					;Get next byte
		lsr.l		#8,d4					;Get next byte
		dbra		d0,1$

		movea.l	a4,a7
		movem.l	(a7)+,a0-a1/a4/d0-d4
		rts

	;Subroutine: this must be in a subroutine because we need a short
	;bra.b
Print80:
		bra		Print

	;***
	;Print an integer on the screen (or file)
	;d0 = integer
	;-> d0 = integer
	;***
PrintHex:
		movem.l	d0-d1,-(a7)
		lea		(-16,a7),a7
		movea.l	a7,a0
		move.l	d0,d1

		moveq		#mo_DispType+1,d0
		bsr		CheckModeBit
		bne.b		2$

		moveq		#mo_DispType,d0
		bsr		CheckModeBit
		bne.b		1$

	;Hex
		move.l	d1,d0
		bsr		LongToHex
		bra.b		3$

	;Both Hex and Dec
2$		move.l	d1,d0
		bsr		LongToHex
		bsr		Print					;For efficiency no trap
		moveq		#' ',d0
		bsr		PrintChar
		moveq		#',',d0
		bsr		PrintChar
		moveq		#' ',d0
		bsr		PrintChar

	;Decimal
1$		move.l	d1,d0
		bsr		LongToDec

	;Print it
3$		bsr		Print					;For efficiency no trap
		lea		(16,a7),a7
		movem.l	(a7)+,d0-d1
		bra.b		NewLine				;For efficiency no trap

	;***
	;Print a hex integer on the screen (or file)
	;d0 = integer
	;PrintRealHexNL 	Without newline
	;***
PrintRealHex:
		bsr.b		PrintRealHexNL
		bra.b		NewLine				;For efficiency no trap

PrintRealHexNL:
		movem.l	d0-d1,-(a7)
		lea		(-16,a7),a7
		movea.l	a7,a0
		bsr		LongToHex
		bsr		Print					;For efficiency no trap
		lea		(16,a7),a7
		movem.l	(a7)+,d0-d1
		rts

	;***
	;Perform a newline
	;-> preserves all registers except a6
	;***
NewLine:
		move.l	d0,-(a7)
		moveq		#10,d0
		bsr		PrintChar
		move.l	(a7)+,d0
		rts

	;***
	;Perform a newline, but only if column position <> 0
	;-> preserves all registers except a6
	;***
SoftNewLine:
		move.l	d0,-(a7)
		moveq		#13,d0
		bsr		PrintChar
		move.l	(a7)+,d0
		rts

	;***
	;Print a string on the powervisor screen using messages
	;This function is provided for other tasks
	;a0 = ptr to str (NULL-terminated)
	;-> d0 = 0 if fail (flags)
	;***
MsgPrint:
		move.l	a0,-(a7)
		CALLPV	PP_InitPortPrint
		movea.l	(a7)+,a1
		tst.l		d0
		beq.b		1$
		movea.l	d0,a0
		move.l	d0,-(a7)
		CALL		PP_Print
		movea.l	(a7)+,a0
		CALL		PP_StopPortPrint
		moveq		#1,d0
1$		rts

	;***
	;Print a message on the backdrop window (or in file if redirection)
	;a0 = ptr to str
	;The printing will stop if the length exceeds d3 or the char is 0
	;	Print			Normal print with break check
	;	PrintAC		Without break check
	;	PrintCold	Print on screen (no redirection, virtual print,
	;					break check, bold)
	;-> Print preserves all registers except a6
	;***
Print:
		movem.l	d0-d1/a0-a1,-(a7)
		bsr.b		2$
		movem.l	(a7)+,d0-d1/a0-a1
		rts

2$		tst.b		(VPrint)
		bne.b		PrintAC				;Don't check break if virtualprint

		move.l	a0,-(a7)

	;Check if there is an IDC command
	;But first, check if we are allowed to perform IDC commands
		move.b	(NoIDC,pc),d0
		bne.b		3$

		moveq		#0,d0
		move.l	d0,d1
		CALLEXEC	SetSignal
		and.l		(IDevSigSet),d0
		beq.b		3$
		bsr		ExecIDCWK
		moveq		#0,d0
		move.l	(IDevSigSet),d1
		CALL		SetSignal

3$		bsr		FuncGetActive
		movea.l	(a7)+,a0				;Restore pointer to string
		movea.l	(CurrentLW,pc),a1
		cmp.l		a1,d0					;If current is equal to active, we can pause or break
		bne.b		1$

		bsr		CheckPause

		move.w	(LogWin_Flags+2,a1),d0
		btst		#LWB_NOBREAK,d0
		bne.b		1$
		bsr		CheckBreak

1$		bsr		ClearBreakSig

PrintAC:
		tst.b		(VPrint)
		bne		VirtualPrint
PrintCold:
		move.l	#32000,d0
		movea.l	a0,a1
		movea.l	(CurrentLW,pc),a0
		bra		LogWin_Print

	IFD D20
	;***
	;String gadget hook
	;a0 = pointer to hook data structure
	;a1 = pointer to parameter structure (message)
	;a2 = hook specific address data (object)
	;***
StringHookFunc:
		move.l	(a1),d0
		cmpi.l	#SGH_KEY,d0
		bne.b		1$

	;SGH_KEY
		move.l	a6,-(a7)
		CALLINP	PeekQualifier

		andi.w	#IEQUALIFIER_RCOMMAND,d0
		beq.b		2$

	;Yes, the user pressed Right Amiga
	;First test if the Right Amiga key was bound to an Intuition
	;defined action
		cmpi.w	#EO_CLEAR,(sgw_EditOp,a2)
		beq.b		2$

	;End stringgadget
		ori.l		#SGA_END+SGA_REUSE,(sgw_Actions,a2)
		andi.l	#~SGA_USE,(sgw_Actions,a2)
		move.w	#$1234,(sgw_Code,a2)

2$		movea.l	(a7)+,a6
		moveq		#1,d0					;Command implemented
		rts

	;Don't know command
1$		moveq		#0,d0
		rts
	ENDC

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;Messages
MesDBCrash:		dc.b	"Unknown error in debug program!",0
MesDBError:		dc.b	"Error in expression!",0
MesDBBreak:		dc.b	"Breakpoint...",0

	EVEN

	;***
	;Start of ScreenBase
	;***
ScreenBase:

TopazFont:		dc.l	0				;Pointer to topaz font (or default font)
NoIDC:			dc.b	0				;If 1, don't allow IDC commands
DontClearLine:	dc.b	0				;If 1 'Scan' will not clear the line
					dc.l	0				;pad
					dc.l	0				;pad
Line:				dc.l	0				;Pointer to line
GadCursorPos:	dc.w	0				;Position of cursor in stringgadget

	;Table with default sizes and parameters for each logical window
	;<columns>.w <rows>.w <mask>.w <flags>.w
	;WARNING! These entries are saved in the config file.
	;
	;If <columns> or <rows> is 0 then autocompute fixed width/height
	;								is -1 then scaling windows
	;								else fixed width/height
	;
FLG				equ	LWF_TOTALHOME0+LWF_NOBREAK
MainEntry:		dc.w	0,0,FLG+LWF_SNAPOUTPUT,LWF_SNAPOUTPUT
ExtraEntry:		dc.w	0,0,FLG+LWF_SNAPOUTPUT,LWF_SNAPOUTPUT
RefreshEntry:	dc.w	0,50,FLG,LWF_TOTALHOME0+LWF_NOBREAK
lDebugEntry:	dc.w	90,42,FLG,LWF_TOTALHOME0+LWF_NOBREAK
PPrintEntry:	dc.w	0,50,FLG,LWF_NOBREAK
RexxEntry:		dc.w	0,50,FLG,LWF_NOBREAK
SourceEntry:	dc.w	-1,-1,FLG+LWF_PRIVATESB+LWF_SCROLLBAR,LWF_TOTALHOME0+LWF_NOBREAK+LWF_PRIVATESB+LWF_SCROLLBAR
WatchEntry:		dc.w	70,30,FLG,LWF_TOTALHOME0+LWF_NOBREAK

SnapCommand:	dc.l	0				;Command to execute before we snap

SBarMode:		dc.b	0				;If 1 add a scrollbar to all logical windows
											;with LWF_SBARIFMODE false
					dc.b	0
					dc.b	0
					dc.b	0

MainPW:		dc.l	0					;Main physical window

MainLW:		dc.l	0					;Main logical window
RefreshLW:	dc.l	0					;Refresh logical window
DebugLW:		dc.l	0					;Debug logical window
ExtraLW:		dc.l	0					;Extra logical window
PPrintLW:	dc.l	0					;PortPrint logical window
RexxLW:		dc.l	0					;Rexx logical window
SourceLW:	dc.l	0					;Source logical window
WatchLW:		dc.l	0					;Watch logical window

CurrentLW:	dc.l	0					;Current logical window (for Print)

PromptPos:	dc.w	1					;Location of prompt (horizontal)
LeftStrGad:	dc.w	LEFTSTRGAD		;Location of stringgadget (horizontal)
RightStrGad:	dc.w	RIGHTSTRGAD	;Right location of stringgadget

	;*** Intuition things ***
PVScreen:	dc.l	0					;Forced PowerVisor screen
MyScreen:	dc.l	0

	;Intuition message
Class:		dc.l	0
Code:			dc.w	0
IAddress:	dc.l	0
MouseX:		dc.w	0
MouseY:		dc.w	0
Qualifier:	dc.w	0

myGlobal:	dc.l	0					;Pointer to our Global

OldWinPtr:	dc.l	0					;Old window pointer
	;PADDING TO AVOID HAVING TO REWRITE THEWIZARDCORNER
				dc.l	0

	;NOTE ! The Share variables, SpecialFlags, StartupX,Y,W,H and the
	;pen arrays must always be in the same order as specified here
	;DON'T EXTEND THESE VARIABLES WITHOUT CHANGING THE SAVECONFIG ROUTINE !

	;Open strings and shares
ExtraShare:		dc.b	"u      ",0
					dc.w	300
					dc.w	10,10,300,140
DebugShare:		dc.b	"u      ",0
					dc.w	300
					dc.w	20,20,300,140
RefreshShare:	dc.b	"u      ",0
					dc.w	300
					dc.w	60,60,300,140
PPrintShare:	dc.b	"u      ",0
					dc.w	300
					dc.w	40,40,300,140
RexxShare:		dc.b	"u      ",0
					dc.w	300
					dc.w	50,50,300,140
SourceShare:	dc.b	"u      ",0
					dc.w	300
					dc.w	30,30,300,140
WatchShare:		dc.b	"u      ",0
					dc.w	300
					dc.w	70,70,300,140

	;Special flags used by startup (saved in config file)
	;bit 0 : if true we open on workbench screen
	;bit 1 : if true we open on pv screen but with window
SpecialFlags:	dc.l	0

	;Startup sizes for window
StartupX:		dc.w	0
StartupY:		dc.w	0
StartupW:		dc.w	640
StartupH:		dc.w	200

	;Startup sizes for screen (-1 means not fixed, but like workbench)
ScreenW:			dc.w	STDSCREENWIDTH
ScreenH:			dc.w	STDSCREENHEIGHT

	;Pens used in PowerVisor for 2 or more bitplane screen (only 19 used)
FancyPens:		dc.b	0,0,1,1,1,2,0,3
					dc.b	2,1,1,0,1,2,3,3
					dc.b	0,1,0,2,0,0,0,0
	;Pens used in PowerVisor for 1 bitplane screen
NoFancyPens:	dc.b	0,0,1,1,1,0,0,1
					dc.b	1,1,1,0,1,1,1,1
					dc.b	0,1,0,0,1,0,0,0

	;Pointer to current pen table
Pens:				dc.l	0

	;Note that these prompts must be even
BuPrompt:		dc.b	"-BUSY-"		;Busy prompt
MoPrompt:		dc.b	"-MORE-"		;More prompt
WaPrompt:		dc.b	"-WAIT-"		;Wait prompt
LoPrompt:		dc.b	"------"		;Lock prompt
ScanPrompt:		dc.b	"????"		;Default scan prompt
MesFeedBack:	dc.b	"> "
LockWin:			dc.l	0				;The logical window that is locked
LockPtr:			dc.l	0				;Pointer to prompt for locked window
LockState:		dc.b	0				;Stringgadget state of the locked window
InBusy:			dc.b	0				;If 1 we are in busy mode, 2 is lock mode
GadgetExists:	dc.b	0				;If true, gadget is added

					dc.b	0				;OBSOLETE

TopazName:		dc.b	"topaz.font",0,"                       "
TextAttrib:		dc.l	TopazName
					dc.w	8
					dc.b	0,0

TopBorder:		dc.w	LW_TOPBORDER	;Size of top border for logical windows
FontHeight:		dc.w	8					;Height of the default font

DragTolX1:		dc.w	DRAG_TOLERANCEX1
DragTolY1:		dc.w	DRAG_TOLERANCEY1
DragTolX2:		dc.w	DRAG_TOLERANCEX2
DragTolY2:		dc.w	DRAG_TOLERANCEY2
SizeTolX:		dc.w	SIZE_TOLERANCEX
SizeTolY:		dc.w	SIZE_TOLERANCEY

ReqStruct:		dc.l	0					;Requester structure
ReqBase:			dc.l	0					;Pointer to reqtoolsbase

WinPort:			dc.l	0					;Pointer to shared IntuitionPort
SnapBuffer:		dc.l	0

	;***
	;End of ScreenBase
	;***

ReqTags:			dc.l	RTFI_Flags,0
					dc.l	TAG_DONE

	;Table with commands for each IDC command
IDCtable:		dc.l	IDCNextWin,IDCScroll1Up,IDCScrollPgUp,IDCScrollHome
					dc.l	IDCScrollEnd,IDCScroll1Do,IDCScrollPgDo,IDCScrollRight
					dc.l	IDCScroll1Ri,IDCScroll1Le,IDCDScroll1Up,IDCDScrollPgUp
					dc.l	IDCDScroll1Do,IDCDScrollPgDo,IDCDScrollPC,IDCExec,IDCSnap
					dc.l	IDCExecAlways,IDCDScroll1IUp,IDCDScroll1IDo



					IFD D20
GTBase:			dc.l	0					;Pointer to gadtoolsbase
AllMenus:		dc.l	0					;Pointer to all menus
VisualInfo:		dc.l	0					;Pointer to visual info
MenuStrSize:	dc.l	0					;String pool for menu strings
MenuStr:			dc.l	0

	;Tags for CreateGadgetA
ScrollerTags:	dc.l	GTSC_Arrows,9
					dc.l	PGA_Freedom,LORIENT_VERT
					dc.l	GA_RelVerify,1
					dc.l	TAG_DONE

	;Tags for GT_SetGadgetAttrsA
ScrollerTags2:	dc.l	GTSC_Top,0
					dc.l	GTSC_Total,0
					dc.l	GTSC_Visible,0
					dc.l	TAG_DONE

					ENDC

LineLine:		dc.b	"---"
LineLine2:		dc.b	"-------",0
MesColon:		dc.b	" : ",0

	;Everything for logical and physical windows
MainName:		dc.b	"Main",0
ExtraName:		dc.b	"Extra",0
DebugName:		dc.b	"Debug",0
RefreshName:	dc.b	"Refresh",0
PPrintName:		dc.b	"PPrint",0
RexxName:		dc.b	"Rexx",0
SourceName:		dc.b	"Source",0
WatchName:		dc.b	"Watch",0

ReqToolsLib:	dc.b	"reqtools.library",0
					IFD D20
MenuName:		dc.b	"PowerVisor-menus",0
GadToolsLib:	dc.b	"gadtools.library",0
ScreenTitle:	dc.b	"PowerVisor (V1.43, AmigaDOS 2.0-3.1)   "
ScreenTitleS:	dc.b	"      © J.Tyberghein",0
					ENDC
					IFND D20
ScreenTitle:	dc.b	"PowerVisor (V1.43, AmigaDOS 1.2/1.3)   "
ScreenTitleS:	dc.b	"      © J.Tyberghein",0
					ENDC

					IFD D20
PubScreenT:		dc.b	"PowerVisorScreen"
PubScreenTEnd:	dc.b	0,0,0
	EVEN
scPens:			dc.w	~0

	;Tags for New Screen
NSExtension:	dc.l	SA_DisplayID
ScreenID:		dc.l	DEFAULT_MONITOR_ID|HIRES_KEY
					dc.l	SA_Overscan,OSCAN_TEXT
					dc.l	SA_Pens,scPens
					dc.l	SA_AutoScroll,1
					dc.l	SA_PubName,PubScreenT
					dc.l	TAG_DONE

	;Tags for New Window
OpenWinTags:	dc.l	WA_MenuHelp+1,1	;WA_NewLookMenus (V39)
					dc.l	TAG_DONE

	;Tags for LayoutMenus
LayoutTags:		dc.l	GT_TagBase+67,1	;GTNM_NewLookMenus (V39)
					dc.l	TAG_DONE
					ENDC

	;New Screen
MyNScreen:		dc.w	0,0,640,256,1	;Dimensions
					dc.b	0,1
					dc.w	$8000				;Hires
					IFD D20
					dc.w	CUSTOMSCREEN+NS_EXTENDED
					ENDC
					IFND D20
					dc.w	CUSTOMSCREEN
					ENDC
					dc.l	TextAttrib,ScreenTitle,0,0
					IFD D20
					dc.l	NSExtension		;Extension
					ENDC

					IFD D20
	;Hook
StringHook:		ds.b	MLN_SIZE			;MinNode
					dc.l	StringHookFunc	;Assembler entry point
					dc.l	0					;HLL entry point
					dc.l	0					;No data

	;String extension
SExtend:			dc.l	0					;Font (filled in later)
					dc.b	3,0				;text/background colours (filled in later)
					dc.b	1,0				;active text/background colours (filled in later)
					dc.l	0					;InitialModes
					dc.l	StringHook		;EditHook
					dc.l	0					;WorkBuffer (filled in later)
					dc.l	0
					dc.l	0
					dc.l	0
					dc.l	0
					ENDC

	;String info
mStringInfo:	dc.l	0					;Buffer (ptr to Line)
					dc.l	0
					dc.w	0					;BufferPos
DefLineLen:		dc.w	LINELEN			;Max LINELEN chars
					dc.w	0,0,0,0
					dc.w	1,2				;Offsets
					IFND D20
					dc.l	0
					ENDC
					IFD D20
					dc.l	SExtend			;Extension
					ENDC
					dc.l	0,0

	;String gadget
mStringGad:		dc.l	0					;No nextgadget
					dc.w	LEFTSTRGAD,-7,-LEFTSTRGAD-2-RIGHTSTRGAD,9
					;Flags
					dc.w	GADGHCOMP+GRELBOTTOM+GRELWIDTH+SELECTED
					;ActivationFlags
					IFD D20
					dc.w	RELVERIFY+STRINGEXTEND
					ENDC
					IFND D20
					dc.w	RELVERIFY
					ENDC
					dc.w	STRGADGET
					dc.l	0,0,0,0
					dc.l	mStringInfo
					dc.w	1					;ID
msgUserData:	dc.l	-1					;If -1, gadget is not yet ready


	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLongNNLFormat:
					dc.b	"%08lx ",0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	END
