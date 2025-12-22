	;***
	;Macros for errors
	;***
DEFERR	macro
ERR_\1		equ		SOFFSET
SOFFSET		set		SOFFSET+1
			endm

SERR		macro
				move.w	#ERR_\1,(LastError)
			endm

ERROR		macro
				ifge		ERR_\1-128
					move.l	#ERR_\1,d0
				endc
				iflt		ERR_\1-128
					moveq		#ERR_\1,d0
				endc

				trap		#0

;				bra		ErrorRoutine
			endm

ERRCOUNT	set	0

ERROReq	macro
				bne.b		.ERR\@
				ERROR		\1
.ERR\@
			endm

ERRORne	macro
				beq.b		.ERR\@
				ERROR		\1
.ERR\@
			endm

ERRORlt	macro
				bge.b		.ERR\@
				ERROR		\1
.ERR\@
			endm


SERReq	macro
				bne.b		.SERR\@
				SERR		\1
				ifnc		'\2',''
					ifnc 	'\3',''
						bra		\2
					endc
					ifc	'\3',''
						bra.b		\2
					endc
				endc
.SERR\@
			endm

SERRne	macro
				beq.b		.SERR\@
				SERR		\1
				ifnc		'\2',''
					ifnc 	'\3',''
						bra		\2
					endc
					ifc	'\3',''
						bra.b		\2
					endc
				endc
.SERR\@
			endm

SERRlt	macro
				bge.b		.SERR\@
				SERR		\1
				ifnc		'\2',''
					ifnc 	'\3',''
						bra		\2
					endc
					ifc	'\3',''
						bra.b		\2
					endc
				endc
.SERR\@
			endm


HERR		macro
				trap		#1
			endm

HERReq	macro
				bne.b		.HERR\@
				trap		#1
.HERR\@
			endm

HERRne	macro
				beq.b		.HERR\@
				trap		#1
.HERR\@
			endm

EVALE		macro
				trap		#2
			endm

PRINTHEX	macro
				trap		#3
			endm

NEWLINE	macro
				trap		#4
			endm

NEXTTYPE	macro
				trap		#5
			endm

PRINT		macro
				trap		#6
			endm


 STRUCTURE	Errors,-7
 	DEFERR	PrgBERR
 	DEFERR	PrgStackOvf
	DEFERR	PrgCrash
	DEFERR	StackOverflow
	DEFERR	Quit
	DEFERR	Crash
	DEFERR	Break
	DEFERR	NoError
	DEFERR	NotEnoughMemory
	DEFERR	Syntax
	DEFERR	NotAPVDev
	DEFERR	BadListType
	DEFERR	VarIsConstant
	DEFERR	OnlyBWL
	DEFERR	OddAddress
	DEFERR	CouldNotLock
	DEFERR	BracketExp
	DEFERR	ToManyArgs
	DEFERR	MissingOp
	DEFERR	NotASubDir
	DEFERR	OpenDevice
	DEFERR	UnknownListElement
	DEFERR	NotImplementedYet
	DEFERR	UnknownModeArg
	DEFERR	UnknownAddFuncArg
	DEFERR	NotAProcess
	DEFERR	NotATaskProc
	DEFERR	TaskNotFreezed
	DEFERR	TaskIsFreezed
	DEFERR	NodeTypeWrong
	DEFERR	AddressedElNotFound
	DEFERR	NotSizable
	DEFERR	NoSupportedLibFunc
	DEFERR	NoHelpForSubject
	DEFERR	OpenFile
	DEFERR	ReadFile
	DEFERR	NotAResMod
	DEFERR	NotALock
	DEFERR	BadHistoryValue
	DEFERR	OpenTrackDisk
	DEFERR	DoIOError
	DEFERR	NoDebugTask
	DEFERR	UnknownTraceArg
	DEFERR	UnknownDebugArg
	DEFERR	CodeInROM
	DEFERR	NotADebugNode
	DEFERR	BadSpecialArg
	DEFERR	LoadSegError
	DEFERR	BadDbModeArg
	DEFERR	NoCurrentDebug
	DEFERR	UnknownBreakArg
	DEFERR	NoSuchBreakPoint
	DEFERR	NoSymbolHunks
	DEFERR	NoSuchSymbol
	DEFERR	OnlyRemoveVar
	DEFERR	VarIsFunction
	DEFERR	FuncNeedsBrack
	DEFERR	UnknownSymbolArg
	DEFERR	NoSymbols
	DEFERR	Only64KBlocks
	DEFERR	BadBracket
	DEFERR	TaskIsBusy
	DEFERR	TaskIsNotTracing
	DEFERR	BadFileFormat
	DEFERR	NotAStructDef
	DEFERR	BadArgValue
	DEFERR	NoColorsOnWindow
	DEFERR	ErrorInFont
	DEFERR	CantExecScript
	DEFERR	RefreshNotOpen
	DEFERR	UnknownTagType
	DEFERR	NoOutputOnDebug
	DEFERR	WriteFile
	DEFERR	NotATagFile
	DEFERR	BadTagListValue
	DEFERR	BadRegister
	DEFERR	FunctionPatched
	DEFERR	NoFdFileForLibrary
	DEFERR	UnknownLogicalWindow
	DEFERR	AliasOverflow
	DEFERR	MissingBraInFdFile
	DEFERR	MissingKetInFdFile
	DEFERR	BadBiasStatement
	DEFERR	CantCloseMainPW
	DEFERR	CantCloseMainLW
	DEFERR	BadArgForOpenLW
	DEFERR	LogWinMustBeOnPhysWin
	DEFERR	NotMovable
	DEFERR	NoFatherForThisBox
	DEFERR	UnknownPrefsArg
	DEFERR	PleaseCloseVisitors
	DEFERR	DivideByZero
	DEFERR	NoGroupInDebug
	DEFERR	ErrOpenScreen
	DEFERR	CantRemoveRcOrError
	DEFERR	ErrLoadSegFile
	DEFERR	BadVariableName
	DEFERR	ErrOpenPhysWin
	DEFERR	ErrOpenLogWin
	DEFERR	CloseBracketExp
	DEFERR	CloseCurlyExp
	DEFERR	CrBusError
	DEFERR	CrAddressError
	DEFERR	CrIllegal
	DEFERR	CrDivByZero
	DEFERR	CrCHKIns
	DEFERR	CrTRAPVIns
	DEFERR	CrPrivilegeViol
	DEFERR	CrTrace
	DEFERR	CrUnImpl1010
	DEFERR	CrUnImpl1111
	DEFERR	UnknownTrackArg
	DEFERR	AlreadyTracking
	DEFERR	NotTracking
	DEFERR	UnknownSourceArg
	DEFERR	NoDebugHunks
	DEFERR	NoSourceLoaded
	DEFERR	NotInSource
	DEFERR	OnlyOn68030
	DEFERR	YouNeedMMU
	DEFERR	NotAValidExecFile
	DEFERR	NotAllowedForSlave
	DEFERR	FirstInstallWatch
	DEFERR	CantFreezePowerVisor
	DEFERR	CantChangeTagList0
	DEFERR	UnknownStructArg
	DEFERR	BadStructure
	DEFERR	ReadOnlyStruct
	DEFERR	CantFindField
	DEFERR	UnknownProfArg
	DEFERR	NotProfiling
	DEFERR	AlreadyProfiling
	DEFERR	NotALogWin
	DEFERR	UnknownDbSrcArg
	DEFERR	UnknownWatchArg
	DEFERR	OnlyIndexForArrays
