	;***
	;Node definition for debugs
	;***
 STRUCTURE Debug,LN_SIZE
	ULONG		db_MatchWord			;Contains 'DBUG'
	UBYTE		db_Mode					;See below
	UBYTE		db_SMode					;See below
	APTR		db_Segment				;Pointer to segment (or 0 if not our segment)
	APTR		db_Instruction			;Address of instruction to execute
	APTR		db_TRoutine2
	APTR		db_TRoutine				;Address of routine to jump to if a
											;trace exception occurs
	APTR		db_TAddress				;Address to restore breakpoint to
											;(if db_SMode==DBS_TTRACE)
	APTR		db_Additional			;Additional info for tracing (free with FreeBlock)
											;(if db_Mode==DB_TRACING)
	UBYTE		db_TMode					;Trace mode (see below)
											;(if db_Mode==DB_TRACING)
	UBYTE		db_SpecialBit			;If SpecialBit==TRUE then we are back to our
											;normal stacklevel
	UBYTE		db_TDNestCnt			;For forbid level
	UBYTE		db_IDNestCnt
	UBYTE		db_TaskState			;Task state (to return to normal)
	UBYTE		db_Dirty					;See DBF_xxx flags
	ULONG		db_SigWait				;Remember SigWait
	ULONG		db_Additional2			;Additional info for tracing (don't free)
	ULONG		db_AdditionalArg		;Extra argument for some trace modes
	APTR		db_Task					;Task to debug
	ULONG		db_TopPC					;PC at top of screen
	ULONG		db_BotPC					;Last PC still on screen
	UBYTE		db_TraceBits			;Trace bits for the current Mode
	UBYTE		db_pad0
	UBYTE		db_i1						;Number of bytes for each instruction on screen
	UBYTE		db_i2
	UBYTE		db_i3
	UBYTE		db_i4
	UBYTE		db_i5
	UBYTE		db_i6
	UBYTE		db_i7
	UBYTE		db_i8
	UBYTE		db_i9
	UBYTE		db_i10
	UBYTE		db_i11
	UBYTE		db_i12
	UBYTE		db_i13
	UBYTE		db_i14
	UBYTE		db_i15
	UBYTE		db_i16
	UBYTE		db_i17
	UBYTE		db_i18
	UBYTE		db_i19
	UBYTE		db_i20
	UBYTE		db_i21
	UBYTE		db_i22
	UBYTE		db_i23
	UBYTE		db_i24
	UBYTE		db_i25
	UBYTE		db_i26
	UBYTE		db_i27
	UBYTE		db_i28
	UBYTE		db_i29
	UBYTE		db_i30
	UBYTE		db_i31
	UBYTE		db_i32
	APTR		db_InitPC				;Initial PC for task
	APTR		db_TrapCode				;Previous trapcode for task

	;Quick Memory block for symbol values
	ULONG		db_SymbolSize			;Size of symbol block
	APTR		db_Symbol				;Symbols
	ULONG		db_PCSourceFile		;Pointer to source structure for PC
	;Quick Memory block for strings in symbol list
	ULONG		db_SymbolStrSize		;Size of symbol string block
	APTR		db_SymbolStr			;All symbol strings
	ULONG		db_PCLineNumber		;Linenumber for PC

	STRUCT	db_BreakPoints,LH_SIZE
	UWORD		db_Crash					;Crash number
	ULONG		db_Dummy
	ULONG		db_DummyBP				;Remember pointer to breakpoint we are handling
	APTR		db_PtrToQuitCode		;Ptr to quit code on stack
	APTR		db_PrevQuitCode		;Original quit code
	ULONG		db_SP						;StackPointer
	ULONG		db_PC						;StackFrame for registers
	UWORD		db_SR
	STRUCT	db_Registers,15*4		;All registers
	LABEL		db_EndRegisters
	ULONG		db_MOVcode				;48E70000 (bits, left to right, d0 to a7)
	UWORD		db_LEAcode				;4xF9 (x=1 for a0, x=3 for a1, ...)
	ULONG		db_LEAaddr
	UWORD		db_JMPcode				;4EF9
	ULONG		db_JMPaddr
	APTR		db_Source				;Pointer to linked list of source structures
	APTR		db_CurrentSource		;Pointer to current source
	UWORD		db_HoldSource			;If TRUE, source logical window is locked
	ULONG		db_OldTRoutine			;Old TRoutine when skipping a BSR or JSR
											;in routine trace mode
	UWORD		db_Additional3			;Extra argument (don't free)
	ULONG		db_Additional4			;Extra argument (don't free)
	APTR		db_SourcePath			;Path to look for source
	APTR		db_Watches				;Pointer to first watch
	LABEL		db_SIZE

DB_NONE		equ	0					;Busy doing nothing
DB_TRACING	equ	1					;We are tracing the program
DB_EXEC		equ	2					;We are simply executing the program
DB_FTRACING	equ	3					;Flow-tracing (68020 or higher only)
DB_RTRACING	equ	4					;Routine tracing (don't go in BSR and JSR)

DBS_NORMAL	equ	0					;Normal debugging
DBS_TTRACE	equ	1					;Temporary trace to restore breakpoint
DBS_CRASH	equ	2					;There was a crash
DBS_BREAK	equ	3					;There was a breakpoint
DBS_TBREAK	equ	4					;Break due to trace
DBS_WAIT		equ	5					;Simply waiting for PowerVisor action
DBS_ERROR	equ	6					;There was an error

DBT_NORMAL	equ	0					;Break after each instruction
DBT_AFTER	equ	1					;Break after <Additional> instructions
DBT_STEP		equ	2					;Never break, simply trace
DBT_UNTIL	equ	3					;Break if pc==<Additional>
DBT_REG		equ	4					;Break if reg changed (OBSOLETE)
DBT_COND		equ	5					;Break if condition is true
DBT_BRANCH	equ	6					;Trace until branch
DBT_FORCE	equ	7					;Force tracing (trace f)
DBT_OSCALL	equ	8					;Trace until OS call used
DBT_SKIP		equ	9					;Trace one instruction and change stack
											;(for 'trace t')
DBT_QCOND	equ	10					;Quick conditional trace
DBT_PROF		equ	11					;Profiler tracing
DBT_AMODE	equ	12					;Address mode tracing
DBT_CHKSUM	equ	13					;Checksum tracing

DBF_DEBUG	equ	1					;Debug logical window is dirty
DBF_SOURCE	equ	2					;Source logical window is dirty

DBB_DEBUG	equ	0
DBB_SOURCE	equ	1

	;***
	;Structure for a source file
	;***
 STRUCTURE SourceFile,0
	APTR		srcf_Next				;Next source
	APTR		srcf_Prev				;Previous source
	APTR		srcf_FileName			;Filename
	ULONG		srcf_LinesSize			;Size of lines block
	APTR		srcf_Lines				;Pointer to lines block (<address>.l <line number>.l)
	ULONG		srcf_FileSize			;Size of the file block
	APTR		srcf_File				;Pointer to loaded file
	ULONG		srcf_NumLines			;Number of lines in the source file
	APTR		srcf_LineBuf			;Pointer to the linebuffer block (NumLines*4 bytes)
	ULONG		srcf_LineNumber		;Current linenumber in file (not always equal to PC)
	ULONG		srcf_TopLine			;Top linenumber (smaller)
	ULONG		srcf_BottomLine		;Bottom linenumber (bigger)
	ULONG		srcf_HiLine				;Current hilighted line
	LABEL		srcf_SIZE

	;***
	;Structure for a watch
	;***
 STRUCTURE Watch,0
	APTR		wtc_Next					;Next watch
	APTR		wtc_Prev					;Previous watch
	APTR		wtc_Pointer				;Pointer to watch
	ULONG		wtc_PrevValue			;Previous value so that we can trap changes
	UWORD		wtc_Size					;Size of the region pointed to by wtc_Pointer
	APTR		wtc_Info					;Extra information to print in the watch window
	LABEL		wtc_SIZE

	;***
	;Node definition for a breakpoint
	;***
 STRUCTURE BreakPoint,LN_SIZE
	UWORD		bp_Number				;Number for this breakpoint
	APTR		bp_Where					;Where is it in memory
	UWORD		bp_Original				;What was the previous contents
	UBYTE		bp_Type					;Breakpoint type
	UBYTE		bp_pad
	ULONG		bp_UsageCnt				;Usage count for this breakpoint
	APTR		bp_Additional			;Additional info (depending on type)
	APTR		bp_BRoutine				;Address of routine to jump to if a
											;break occurs
	LONG		bp_Dummy					;Extra variable
	LABEL		bp_SIZE

BP_TEMP		equ	'T'
BP_TEMP2		equ	't'				;Temporary breakpoint
BP_NORMAL	equ	'N'
BP_PROFILE	equ	'P'
BP_OVER		equ	'O'
BP_COND		equ	'C'
BP_AFTER		equ	'A'

COMP_MACRO68	equ	0
COMP_SASC		equ	1
COMP_DEVPAC		equ	2
COMP_AZTEC		equ	3

