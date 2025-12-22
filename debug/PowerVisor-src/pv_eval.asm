*****
****
***			E V A L   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Wed Aug 18 19:16:38 1993
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

			INCLUDE	"pv.eval.i"
			INCLUDE	"pv.debug.i"
			INCLUDE	"pv.list.i"

			INCLUDE	"pv.errors.i"

	XDEF		EvalConstructor,EvalDestructor
	XDEF		RoutCreateFunc,RoutRemVar,RoutVars,CreateFunc,HandleGroup
	XDEF		Upper,MakePrint,CopyCString,CompareCI,LongToHex,LongToDec
	XDEF		Assignment,Evaluate,EvaluateE,GetNextType
	XDEF		GetNextByteE,ScanOptions,SearchWordEx,SearchWord,SkipSpace
	XDEF		GetStringE,GetString,GetStringPer,SkipNSpace
	XDEF		PrepareHexB,PrepareHexW,PrepareHex,ParseDec
	XDEF		ClearString,ByteToHex,VarStorage,NameToItem
	XDEF		InitPrepHex,ParseName,WordToHex,ChangeSPSigSet,ZeroString
	XDEF		GetRestLine,GetRestLinePer,FuncEval,FuncIf,AddressVar
	XDEF		CreateConst,EvalBase,RemVarFunc,SkipObject,SkipString
	XDEF		StoreInput,GetInputVar,GetRegister,Sort

	;screen
	XREF		DefLineLen
	;debug
	XREF		CurrentDebug,DebugRefresh,CheckIfTrace,GetSymbolVal,InDebugTask
	XREF		DebugSP,SkipStackFrame,ChangeSPBreakTV,GetPCForLine
	;main
	XREF		AllocSignal
	XREF		ModeChangeRout,PVCallTable,ExecAlias
	XREF		Storage,DosBase,ExpansLib,FastFPrint,LMult,LMod,LDiv
	XREF		Forbid,Permit,Disable,Enable,LastError
	;list
	XREF		GetNextListI,GotoStartList,GetItem
	XREF		Item,InfoBlocks,SetList
	;general
	XREF		StringToLib,CallLibFunc,CheckStack,PortNameEnd
	;memory
	XREF		ReAllocMem,FreeBlock,RemoveMem,AllocStringInt
	XREF		AllocBlockInt,AddAutoClear,ShrinkBlock,ViewPrintLine
	XREF		AllocMem,FreeMem,ReAlloc

;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

mVERSION13		equ	$143
mVERSION20		equ	$143

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Constructor: initialize everything for evaluate
	;-> d0 = 0 if success (flags) else errorcode
	;***
EvalConstructor:
		lea		(ChangeSPSigNum,pc),a2
		bsr		AllocSignal
	;Allocate memory for variables
		lea		(VarMemBlock,pc),a0
		moveq		#VOFFS_SIZE,d0
		bsr		ReAllocMem
		bne.b		1$
2$		moveq		#ERROR_MEMORY,d0
		rts
	;Mode variable
1$		movea.l	d0,a0
		move.l	#%0101001001,(a0)+
		move.b	#5,(a0)+
		move.b	#2,(a0)+				;Special variable
		move.l	#'mode',(a0)+
		clr.w		(a0)+
		move.l	#ModeChangeRout,(a0)+
	;Version constant
		lea		(StrVersion,pc),a0
 IFND D20
		move.l	#mVERSION13,d0
 ENDC
 IFD D20
		move.l	#mVERSION20,d0
 ENDC
		bsr		CreateConst
		beq.b		2$
	;Error variable
		lea		(StrError,pc),a0
		moveq		#0,d0
		bsr		FillVar
		beq.b		2$
	;Rc variable
		lea		(StrRC,pc),a0
		moveq		#0,d0
		bsr		FillVar
		beq.b		2$
	;Input constant
		lea		(StrInput,pc),a0
		moveq		#0,d0
		bsr		CreateConst
		beq.b		2$
	;Pv constant
		lea		(StrPv,pc),a0
		moveq		#0,d0
		move.b	(1+PortNameEnd),d0
		beq.b		3$
		sub.b		#'0',d0
3$		bsr		CreateConst
		beq.b		2$

		moveq		#0,d0					;Success
		rts

	;***
	;Destructor: remove everything for evaluate
	;***
EvalDestructor:
		move.l	(ChangeSPSigNum,pc),d0
		CALLEXEC	FreeSignal
*		lea		(VarMemBlock,pc),a0
*		moveq		#0,d0
*		bra		ReAllocMem
		rts

	;***
	;Store an integer in the input variable
	;d0 = int
	;***
StoreInput:
		move.l	a1,-(a7)
		movea.l	(VarStorage,pc),a1
		lea		(VOFFS_INPUT,a1),a1
		move.l	d0,(a1)
		movea.l	(a7)+,a1
		rts

	;***
	;Get the input variable
	;-> d0 = value (flags)
	;***
GetInputVar:
		move.l	a1,-(a7)
		movea.l	(VarStorage,pc),a1
		lea		(VOFFS_INPUT,a1),a1
		move.l	(a1),d0
		movea.l	(a7)+,a1				;For flags
		rts

	;***
	;Handle the group operator
	;a0 = cmdline
	;-> d0 = return code
	;-> d1 = 0, flags for error
	;***
HandleGroup:
		moveq		#0,d7
4$		bsr		SkipSpace
		SERReq	CloseCurlyExp,5$
		cmpi.b	#'}',(a0)
		beq.b		3$
		cmpi.b	#';',(a0)
		bne.b		1$
		lea		(1,a0),a0
1$		movea.l	a0,a1					;Remember ptr to command
		bsr		SkipCommand
		beq.b		5$
		move.b	(a0),d0
		clr.b		(a0)					;Overwrite to simulate end of string
		movem.l	d0/a0,-(a7)			;Remember char and ptr
		movea.l	a1,a0					;Restore command pointer
		moveq		#EXEC_GROUP,d0
		bsr		ExecAlias
		move.l	d0,d7
		movem.l	(a7)+,d0/a0			;Restore char and ptr to other commands
		move.b	d0,(a0)				;Restore character
		tst.l		d1
		beq.b		5$						;Test error from command
		bra.b		4$
3$		lea		(1,a0),a0
2$		move.l	d7,d0
		moveq		#1,d1					;Success
		rts

	;Error
5$		moveq		#0,d1					;Error
		rts

	;***
	;Command: create a function
	;***
RoutCreateFunc:
		move.l	a2,-(a7)
		bsr		GetStringE
		movea.l	d0,a2
		EVALE								;Function address
		movea.l	d0,a1
		movea.l	a2,a0
		bsr		CreateFunc
		HERReq
		movea.l	(a7)+,a2
		rts

	;***
	;Function: conditional evaluate
	;***
FuncIf:
		EVALE
		tst.l		d0
		bne.b		1$
		bsr		SkipSpace
		moveq		#0,d0
		bsr		SkipObject
		HERReq
1$		bsr		SkipSpace
		movea.l	a0,a1
		moveq		#0,d0
		bsr		SkipObject
		HERReq
		move.b	(a0),d0
		clr.b		(a0)
		movem.l	d0/a0,-(a7)			;Remember char and ptr
		movea.l	a1,a0
		EVALE
		move.l	d0,d1
		movem.l	(a7)+,d0/a0
		move.b	d0,(a0)				;Restore char
		move.l	d1,d0
		rts

	;***
	;Function: evaluate a string
	;***
FuncEval:
		EVALE
		tst.l		d0
		beq.b		1$
		movea.l	d0,a0
		bsr		GetRestLine
		HERReq
		movea.l	d0,a0
		EVALE
1$		rts

	;***
	;Get address of variable
	;d0 = ptr to string
	;-> d0 = address (flags)
	;***
AddressVar:
		move.l	a5,-(a7)
		movea.l	d0,a0
		movea.l	(VarStorage,pc),a1	;Ptr to list
		lea		(GetNextVar,pc),a5
		bsr		SearchWordEx
		movea.l	(a7)+,a5
		move.l	d1,d0						;Set flags
		rts

	;***
	;Command: remove a variable
	;***
RoutRemVar:
		movea.l	a0,a5
4$		movea.l	a5,a0
		NEXTTYPE
		beq.b		3$
		bsr		GetStringE
		movea.l	a0,a5
		bsr		AddressVar
		move.l	a0,d0
		beq.b		4$
		bsr		2$
		bra.b		4$
3$		rts

2$		lea		(VarMemBlock,pc),a0
		move.l	d1,d0
		movea.l	d1,a1
		tst.b		(5,a1)
		ERRORne	OnlyRemoveVar
		move.l	(VarStorage,pc),d1
		addi.l	#VOFFS_RC,d1
		cmp.l		a1,d1
		ERROReq	CantRemoveRcOrError
		addi.l	#VOFFS_ERROR-VOFFS_RC,d1
		cmp.l		a1,d1
		ERROReq	CantRemoveRcOrError
		moveq		#6,d1
		add.b		(4,a1),d1
		sub.l		(4,a0),d0
		btst		#0,d1
		beq.b		1$
		addq.l	#1,d1					;Str len odd, add pad byte
1$		bra		RemoveMem

	;***
	;Remove a variable, constant, special variable or function
	;***
RemVarFunc:
		NEXTTYPE
		beq.b		3$
		bsr		GetStringE
		bsr		AddressVar
		move.l	a0,d0
		bra.b		2$
3$		rts

2$		lea		(VarMemBlock,pc),a0
		move.l	d1,d0
		movea.l	d1,a1
		moveq		#6,d1
		add.b		(4,a1),d1
		sub.l		(4,a0),d0
		btst		#0,d1
		beq.b		1$
		addq.l	#1,d1					;Str len odd, add pad byte
1$		bra		RemoveMem

	;***
	;Command: list all variables
	;a0 = cmdline
	;***
RoutVars:
		moveq		#0,d7
		tst.l		d0						;End of line
		beq.b		4$
		moveq		#1,d7					;List everything
4$		movea.l	(VarStorage,pc),a5
		move.l	(VarMemBlock,pc),d6
		add.l		a5,d6
1$		cmp.l		a5,d6
		beq.b		2$
		lea		(FormatVars,pc),a0
		move.l	(a5),-(a7)
		move.l	(a5)+,-(a7)
		moveq		#0,d1
		move.b	(1,a5),d1
		move.w	d1,-(a7)
		move.l	a5,d0
		addq.l	#2,d0					;Ptr to string
		move.l	d0,-(a7)
		move.l	(Storage),d0
		movea.l	a7,a1
		bsr		FastFPrint
		lea		(14,a7),a7
		tst.b		d7
		bne.b		5$
		tst.b		(1,a5)
		bne.b		6$
5$		bsr		ViewPrintLine
		NEWLINE
6$		moveq		#0,d0
		move.b	(a5)+,d0
		cmpi.b	#2,(a5)+				;Special variable
		bne.b		3$
		lea		(4,a5),a5				;Skip ptr at end
3$		adda.l	d0,a5
		btst		#0,d0
		beq.b		1$
		addq.l	#1,a5					;Str len odd, add pad byte
		bra.b		1$
2$		rts

	;***
	;Create a function (in variable table)
	;a0 = ptr to name
	;a1 = ptr to routine
	;-> d0 = 0, flags if error
	;***
CreateFunc:
		move.l	a1,d0
		bsr		FillVar
		beq.b		1$
		move.b	#3,(5,a1)				;Function
		moveq		#1,d0					;Success
		rts

	;Error
1$		moveq		#0,d0
		rts

	;***
	;Create a constant
	;a0 = ptr to name
	;d0 = value
	;-> d0 = 0, flags if error
	;***
CreateConst:
		bsr		FillVar
		beq.b		1$
		move.b	#1,(5,a1)				;Constant
		moveq		#1,d0					;Success
		rts

	;Error
1$		moveq		#0,d0
		rts

	;***
	;Create a variable and fill it with a value
	;a0 = ptr to variable string
	;d0 = value
	;-> a1 = ptr to newly created element (or 0, flags if error)
	;***
FillVar:
		movem.l	d1/d5-d7/a0/a5,-(a7)
	;Compute length
		movea.l	a0,a5
		move.l	d0,d5
2$		move.b	(a0)+,d0
		bsr		IsNameChar
		beq.b		2$
		move.l	a0,d7
		sub.l		a5,d7					;d7 = length of varname
		move.l	(VarMemBlock,pc),d0;Get current block size
		move.l	d0,d6
		add.l		d7,d0					;Add string
		addq.l	#4+2,d0				;Value, length and type bytes
		btst		#0,d7
		beq.b		1$
		addq.l	#1,d0					;Str len odd, add pad byte
1$		lea		(VarMemBlock,pc),a0
		bsr		ReAllocMem
		beq.b		5$
		movea.l	d0,a1
		adda.l	d6,a1					;a1 points to new variable space
		move.l	a1,-(a7)
		move.l	d5,(a1)+
		move.b	d7,(a1)+
		clr.b		(a1)+					;Normal variable
		move.l	d7,d0
		subq.w	#1,d0

	;Copy var name
3$		move.b	(a5)+,(a1)+
		dbra		d0,3$

		clr.b		(-1,a1)
		moveq		#0,d0
		btst		d0,d7
		beq.b		4$
		move.b	d0,(a1)+				;Str len odd, add pad byte
4$		movea.l	(a7)+,a1
		move.l	a1,d1					;For flags
6$		movem.l	(a7)+,d1/d5-d7/a0/a5
		rts

	;Error handling
5$		moveq		#0,d1					;For flags
		movea.l	d1,a1
		bra.b		6$


	;***
	;Routine to get the next variable (for SearchWord)
	;***
GetNextVar:
		move.l	(VarMemBlock,pc),d0
		add.l		(VarStorage,pc),d0
		cmp.l		a1,d0
		beq.b		3$
		move.l	(a1)+,d7				;Get value    <--- MUNGWALL/ENFORCER HIT
		moveq		#0,d6
		move.b	(a1)+,d6				;Get length
		move.b	(a1)+,d0				;Get type
		movea.l	a1,a3					;Get string address
		cmpi.b	#2,d0					;Special ?
		bne.b		1$
		lea		(4,a1),a1				;Skip ptr at end (special var)
1$		adda.l	d6,a1
		btst		#0,d6
		beq.b		2$
		addq.l	#1,a1					;Str len odd, add pad byte
2$		rts
3$		moveq		#0,d0
		movea.l	d0,a1
		rts

	;String functions

	;***
	;Compare two strings, ignore upper/lower case
	;a0 = Ptr to string 1
	;a1 = Ptr to string 2
	;d0.w = Number of chars to compare
	;-> d0.w = -1 and eq flag set if equal
	;***
CompareCI:
		movem.l	d1-d2,-(a7)
		move.w	d0,d2
		subq.w	#1,d2
1$		move.b	(a0)+,d0
		bsr		Upper
		move.b	d0,d1
		move.b	(a1)+,d0
		bsr		Upper
		cmp.b		d0,d1
		dbne		d2,1$
		move.l	d2,d0
		movem.l	(a7)+,d1-d2
		cmpi.w	#-1,d0
		rts

	;***
	;Copy a string of a specified length
	;If a NULL char is encountered copy the rest with spaces
	;a1 = Source address
	;a0 = Destination
	;d0 = number of bytes (can be 0)
	;-> a1 points to the NULL char in source
	;***
CopyCString:
		bra.b		2$
1$		tst.b		(a1)
		beq.b		LoopCST
		move.b	(a1)+,(a0)+
2$		dbra		d0,1$
		rts

	;***
	;Clear a string with spaces
	;a0 = String ptr
	;d0 = number bytes to clear (can be 0)
	;***
ClearString:
		bra.b		ToDbraCST
LoopCST:
		move.b	#' ',(a0)+
ToDbraCST:
		dbra		d0,LoopCST
		rts

	;***
	;Clear a string with NULL's
	;a0 = String ptr
	;d0 = number bytes to clear (can be 0)
	;***
ZeroString:
		bra.b		2$
1$		clr.b		(a0)+
2$		dbra		d0,1$
		rts

	;***
	;Prepare hex data for printing
	;a1 = Ptr to the start string
	;a0 = Destination
	;d1 = Integer to print after start string
	;d0 = Number of alignment bytes for start string
	;-> (a0 input) contains string (not ending with NULL)
	;-> a0 points after print string
	;***
PrepareHex:
		movem.l	d0,-(a7)
		bsr.b		InitPrepHex
		bsr		LongToHex
		lea		(8,a0),a0
ContPrHex1:
		move.b	#' ',(a0)+
		move.b	#'|',(a0)+
		move.b	#' ',(a0)+
		movem.l	(a7)+,d0
		rts

	;***
	;Same as PrepareHex but now for words
	;***
PrepareHexW:
		movem.l	d0,-(a7)
		bsr.b		InitPrepHex
		bsr		WordToHex
		lea		(4,a0),a0
ContPrHex:
		move.b	#' ',(a0)+
		move.b	#' ',(a0)+
		move.b	#' ',(a0)+
		move.b	#' ',(a0)+
		bra.b		ContPrHex1

	;***
	;Same as PrepareHex but now for bytes
	;***
PrepareHexB:
		movem.l	d0,-(a7)
		bsr.b		InitPrepHex
		bsr		ByteToHex
		lea		(2,a0),a0
		move.b	#' ',(a0)+
		move.b	#' ',(a0)+
		bra.b		ContPrHex

	;*** Little subroutine for PrepareRoutines ***
InitPrepHex:
		bsr		CopyCString
		move.b	#':',(a0)+
		move.b	#' ',(a0)+
		move.l	d1,d0
		rts

	;Conversion routines

	;***
	;Convert the hexadecimal value of a byte to a string
	;d0.b = Byte to convert
	;a0 = Address to put the result in
	;-> (a0) = hex string (NULL-terminated)
	;-> preserves all registers
	;***

LongToHex:
		movem.l	a0-a1/d0-d3,-(a7)
		moveq		#7,d3

CommonBTH:
		moveq		#$f,d2
		lea		(1,a0,d3.w),a0
		lea		(HexTable,pc),a1
		clr.b		(a0)					;NULL-terminate

1$		move.l	d0,d1
		and.w		d2,d1
		lsr.l		#4,d0
		move.b	(a1,d1.w),-(a0)
		dbra		d3,1$
		movem.l	(a7)+,a0-a1/d0-d3
		rts

WordToHex:
		movem.l	a0-a1/d0-d3,-(a7)
		moveq		#3,d3
		bra.b		CommonBTH
ByteToHex:
		movem.l	a0-a1/d0-d3,-(a7)
		moveq		#1,d3
		bra.b		CommonBTH

HexTable:
		dc.b		"0123456789ABCDEF"

	;***
	;Convert one byte to uppercase
	;d0.b = byte to convert
	;-> d0.b is converted byte
	;***
Upper:
		cmpi.b	#'a',d0
		bcs.b		1$
		cmpi.b	#'z'+1,d0
		bcc.b		1$
		subi.b	#32,d0
1$		rts

	;***
	;Convert a character to a printable one
	;d0.b = character to convert
	;-> d0 = original if printable or '.' if not printable
	;***
MakePrint:
		cmpi.b	#31,d0
		ble.b		1$
		cmpi.b	#128,d0
		beq.b		1$
		rts
1$		move.b	#'.',d0
		rts

	;***
	;Convert long to decimal
	;d0 = value to convert
	;a0 = ptr to space to put the decimal (13 bytes)
	;-> (a0) contains decimal
	;***
LongToDec:
		movem.l	a0-a1,-(a7)
		move.l	d0,-(a7)
		move.l	a0,d0
		movea.l	a7,a1
		lea		(FormatStrLTD,pc),a0
		bsr		FastFPrint
		lea		(4,a7),a7
		movem.l	(a7)+,a0-a1
		rts

	;IsSomething routines

	;***
	;Is this a digit ?
	;d0.b = byte to test
	;-> d0 = 0 if a digit (flags)
	;-> d1 = value if a digit
	;***
IsDigit:
		subi.b	#'0',d0
		cmpi.b	#9,d0
		bhi.b		1$
		moveq		#0,d1
		move.b	d0,d1
		moveq		#0,d0
		rts
1$		moveq		#1,d0
		rts

	;***
	;Is this a name char (Underscore, letter or digit)
	;***
IsNameChar:
		cmpi.b	#'_',d0
		beq.b		YesIL
		subi.b	#'0',d0
		blt.b		1$
		cmpi.b	#9,d0
		bls.b		YesIL
		subi.b	#'A'-'0',d0
		blt.b		1$
		cmpi.b	#25,d0
		bls.b		YesIL
		subi.b	#'a'-'A',d0
		blt.b		1$
		cmpi.b	#25,d0
		bls.b		YesIL
1$		moveq		#1,d0
		rts

	;***
	;Is this a letter ?
	;d0.b = byte to test
	;-> d0 = 0 if a letter (flags)
	;***
IsLetter:
		subi.b	#'A',d0
		cmpi.b	#25,d0
		bls.b		YesIL
		subi.b	#'a'-'A',d0
		cmpi.b	#25,d0
		bls.b		YesIL
		moveq		#1,d0
		rts
YesIL:
		moveq		#0,d0
		rts

	;***
	;Is this a hex digit ?
	;d0.b = byte to test
	;-> d0 = 0 if a hex digit (flags)
	;-> d1 = value if a hex digit
	;***
IsHex:
		moveq		#0,d1
		movem.l	d2,-(a7)
		move.b	d0,d2
		bsr		IsDigit
		bne.b		1$
		movem.l	(a7)+,d2
		moveq		#0,d0
		rts
1$		move.b	d2,d0
		bsr		Upper
		movem.l	(a7)+,d2
		cmpi.b	#'A',d0
		bcs.b		NoNotRightIS
		cmpi.b	#'F'+1,d0
		bcc.b		NoNotRightIS
		move.b	d0,d1
		subi.b	#'A'-10,d1
		moveq		#0,d0
		rts

	;***
	;Is this a string byte ?
	;d1.b = end of string byte (' or ")
	;d0.b = byte to test
	;-> d0 = 0 if string byte (flags)
	;***
IsString:
		cmpi.b	#0,d0
		beq.b		NoNotRightIS
		cmp.b		d1,d0
		beq.b		NoNotRightIS
		cmpi.b	#10,d0
		beq.b		NoNotRightIS
		cmpi.b	#13,d0
		beq.b		NoNotRightIS
		cmpi.b	#' ',d1
		bne.b		1$
		cmpi.b	#9,d0
		beq.b		NoNotRightIS
		cmpi.b	#',',d0
		beq.b		NoNotRightIS
1$		moveq		#0,d0
		rts
NoNotRightIS:
		moveq		#1,d0
		rts

	;***
	;Heapsort a buffer with a generic compare function.
	;This code is the output code from the GNU C compiler adapted
	;to fit my purposes. The real source code for the heapsort function
	;can be found in 'heapsort.c'
	;a0 = pointer to start of buffer
	;d0 = number of elements in buffer
	;d1 = size of each element in buffer
	;a1 = compare routine to use
	;			;***
	;			;a0 = pointer to first element
	;			;a1 = pointer to second element
	;			;-> d0 = -1 for <, 0 for == and 1 for >
	;			;***
	;***
Sort:
		movem.l	d2-d7/a2-a5,-(a7)
		move.l	a0,d6					;Start of buffer
		move.l	d0,d4					;Number of elements
		move.l	d1,d5					;Size
		movea.l	a1,a4					;Compare routine
		moveq		#1,d7
		cmp.l		d4,d7
		bcc		TheEndSort
		tst.l		d5
		bne.b		1$
		moveq		#-1,d0
		bra		TheEndSort2

1$		sub.l		d5,d6
		move.l	d4,d7
		lsr.l		#1,d7
		movea.l	d7,a5
		cmpa.w	#0,a5
		beq.b		2$

8$		move.l	a5,d3
		move.l	d3,d2
		bra.b		3$

7$		move.l	d5,d0
		move.l	d2,d1
		bsr		LMult
		movea.l	d6,a3
		adda.l	d0,a3
		cmp.l		d2,d4
		bls.b		4$
		lea		(0,a3,d5.l),a2
		movea.l	a2,a1
		movea.l	a3,a0
		jsr		(a4)
		tst.l		d0
		bge.b		4$
		movea.l	a2,a3
		addq.l	#1,d2

4$		move.l	d5,d0
		move.l	d3,d1
		bsr		LMult
		movea.l	d6,a2
		adda.l	d0,a2
		movea.l	a2,a1
		movea.l	a3,a0
		jsr		(a4)
		tst.l		d0
		ble.b		5$
		move.l	d5,d1

6$		move.b	(a2),d0
		move.b	(a3),(a2)+
		move.b	d0,(a3)+
		subq.l	#1,d1
		bne.b		6$
		move.l	d2,d3

3$		add.l		d2,d2
		cmp.l		d2,d4
		bcc.b		7$

5$		subq.w	#1,a5
		cmpa.w	#0,a5
		bne.b		8$

2$		moveq		#1,d7
		cmp.l		d4,d7
		bcc.b		TheEndSort
		move.l	d5,d0
		move.l	d4,d1
		bsr		LMult
		movea.l	d0,a5

14$	movea.l	d6,a3
		adda.l	d5,a3
		lea		(0,a5,d6.l),a2
		move.l	d5,d1

9$		move.b	(a3),d0
		move.b	(a2),(a3)+
		move.b	d0,(a2)+
		subq.l	#1,d1
		bne.b		9$
		suba.l	d5,a5
		subq.l	#1,d4
		moveq		#1,d3
		moveq		#2,d2
		cmp.l		d2,d4
		bcs.b		10$

13$	move.l	d5,d0
		move.l	d2,d1
		bsr		LMult
		movea.l	d6,a3
		adda.l	d0,a3
		cmp.l		d2,d4
		bls.b		11$
		lea		(0,a3,d5.l),a2
		movea.l	a2,a1
		movea.l	a3,a0
		jsr		(a4)
		tst.l		d0
		bge.b		11$
		movea.l	a2,a3
		addq.l	#1,d2

11$	move.l	d5,d0
		move.l	d3,d1
		bsr		LMult
		movea.l	d6,a2
		adda.l	d0,a2
		movea.l	a2,a1
		movea.l	a3,a0
		jsr		(a4)
		tst.l		d0
		ble.b		10$
		move.l	d5,d1

12$	move.b	(a2),d0
		move.b	(a3),(a2)+
		move.b	d0,(a3)+
		subq.l	#1,d1
		bne.b		12$
		move.l	d2,d3
		add.l		d2,d2
		cmp.l		d2,d4
		bcc.b		13$

10$	moveq		#1,d7
		cmp.l		d4,d7
		bcs.b		14$
TheEndSort:
		moveq		#0,d0
TheEndSort2:
		movem.l	(a7)+,d2-d7/a2-a5
		rts

	;The big Command Line Parser

	;***
	;Get the following type
	;a0 = ptr to string
	;-> d0 = 0 for end of line (flags)
	;-> a0 = ptr to first non space
	;***
GetNextType:
		bsr		SkipSpace
		moveq		#0,d0
		move.b	(a0),d0
		rts

	;***
	;Get next byte converted to upper in cmdline (with error handling)
	;a0 = cmdline
	;-> d0 = byte or 0 if none
	;-> a0 = ptr after string containing this char (or 0, flags if error)
	;-> a1 = ptr after first byte
	;***
GetNextByteE:
		bsr.b		GetNextByte
		ERROReq	MissingOp
		rts

	;***
	;Get next byte converted to upper in cmdline
	;a0 = cmdline
	;-> d0 = byte or 0 if none
	;-> a0 = ptr after string containing this char (or 0, flags if error)
	;-> a1 = ptr after first byte
	;***
GetNextByte:
		bsr		SkipSpace
		move.l	a0,-(a7)
		bsr		GetString
		movea.l	(a7)+,a1				;For flags
		beq.b		1$
		moveq		#0,d0
		move.b	(a1)+,d0
		bsr		Upper
2$		move.l	a0,d1					;For flags
		rts
1$		suba.l	a0,a0
		bra.b		2$

	;***
	;Scan an option table for possible options
	;a0 = ptr to optionstr
	;a1 = ptr to routine table (last routine is 'not-found' routine)
	;d0 = byte to search
	;-> a1 = ptr to routine
	;***
ScanOptions:
		move.b	(a0)+,d1
		beq.b		1$
		cmp.b		d0,d1
		beq.b		1$
		lea		(4,a1),a1
		bra.b		ScanOptions
1$		movea.l	(a1),a1
		rts

	;***
	;Get the next register and return a register code (REG_xxx)
	;a0 = ptr to register string
	;-> d0 = register code (or REG_NONE, flags if no register)
	;-> d1 = offset in Exec stack frame (-1 if not in stack frame)
	;-> a0 = points after register (if success)
	;-> a1 = points to original string
	;***
GetRegister:
		movea.l	a0,a1
		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'D',d0
		beq.b		1$
		cmpi.b	#'A',d0
		beq.b		2$
		cmpi.b	#'S',d0
		beq.b		3$
		cmpi.b	#'P',d0
		beq.b		4$

	;Not recognized
5$		movea.l	a1,a0					;Restore pointer to string
		moveq		#REG_NONE,d0
		rts

	;Data register
1$		move.b	(a0)+,d0
		subi.b	#'0',d0
		blt.b		5$
		cmpi.b	#7,d0
		bgt.b		5$
		addq.b	#REG_D0,d0
	;Compute offset in Exec stack frame for data and address register
7$		moveq		#2,d1					;Skip PC+SR (-4 because REG_D0 == 1)
		add.b		d0,d1
		add.b		d0,d1
		add.b		d0,d1
		add.b		d0,d1
		tst.l		d0
		rts

	;Address register
2$		move.b	(a0)+,d0
		subi.b	#'0',d0
		blt.b		5$
		cmpi.b	#7,d0
		beq.b		6$
		bgt.b		5$
		addi.b	#REG_A0,d0
		bra.b		7$

	;Stack pointer
6$		moveq		#-1,d1
		moveq		#REG_SP,d0
		rts

	;Stack pointer and status register
3$		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'P',d0
		beq.b		6$
		cmpi.b	#'R',d0
		bne.b		5$
		moveq		#4,d1
		moveq		#REG_SR,d0
		rts

	;Program counter
4$		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'C',d0
		bne.b		5$
		moveq		#0,d1
		moveq		#REG_PC,d0
		rts

	;***
	;Search a word in a specified list
	;a0 = ptr to the word (Only letters are allowed)
	;a1 = ptr to list
	;a5 = ptr to GetNext routine
	;a6 = optional parameter for routine
	;-> a0 = result from GetNext in d6 if found
	;-> d0 = second extra information (d7 from GetNext) if found
	;-> a1 = ptr after word if found
	;-> d1 = null if not found or ptr to listelement if found
	;-> Zero flag is set if the element was exact
	;Args to GetNext:
	;a1 = ptr to list
	;a6 = optional, may be used by routine
	;-> a3 = ptr to object string
	;-> a1 = ptr to next object in list (null if end of list)
	;-> d6 = extra info (optional)
	;-> d7 = extra info (optional)
	;GetNext must preserve a0 and a5
	;***
SearchWordEx:
		move.b	#1,(ExactSearch)
		bra.b		ContSW
SearchWord:
		clr.b		(ExactSearch)
ContSW:
		movem.l	d2-d3/d5-d7/a2-a4,-(a7)

		move.b	(a0),d0
		bsr		IsNameChar
		bne.b		NotFoundSW			;Word has no length, so it doesn't occur

NextWordSW:
		move.l	a1,d5
		jsr		(a5)					;Get word in list
		move.l	a1,d0
		beq.b		NotFoundSW			;The end of the list
	;Now compare this word
		movea.l	a0,a4					;Now a3=ptr to listobject, a4=ptr to word
LoopSW:
		move.b	(a4)+,d0
		move.b	d0,d1
		bsr		IsNameChar
		bne.b		LoopSWEnd
		move.b	d1,d0
		bsr		Upper
		move.b	d0,d1
		move.b	(a3)+,d0
		bsr		Upper
		cmp.b		d0,d1
		beq.b		LoopSW
	;They are not equal, so search the next word
		bra.b		NextWordSW
	;They are equal
LoopSWEnd:
		tst.b		(ExactSearch)		;If in exact search, it must be completely equal
		beq.b		1$
		tst.b		(a3)
		bne.b		NextWordSW			;No, not realy equal
1$		movea.l	d6,a0
		move.l	d7,d0
		movea.l	a4,a1
		subq.l	#1,a1
TheEndSW:
		move.l	d5,d1
		tst.b		(a3)					;Set flag if completely equal
		movem.l	(a7)+,d2-d3/d5-d7/a2-a4
		rts
NotFoundSW:
		suba.l	a0,a0
		suba.l	a1,a1
		moveq		#0,d5					;Not found
		lea		(ExpansLib),a3		;Dummy, ExpansLib is completely arbitrarily
		bra.b		TheEndSW

	;***
	;Evaluate a linenumber operator ('#'line) for the current debug task
	;a0 = ptr to linenumber operator in string
	;-> d0 = value (PC)
	;-> a0 points after operand (or 0, flags if error)
	;***
EvalLineNr:
		movem.l	d1/a1-a2,-(a7)
		move.l	(CurrentDebug),d0
		SERReq	NoCurrentDebug,ErrorEL
		movea.l	d0,a2
		lea		(1,a0),a0			;Skip #
		bsr		EvalElem				;d0 = linenumber
		beq.b		ErrorEL
		move.l	a0,-(a7)
		bsr		GetPCForLine
		movea.l	(a7)+,a0

TheEndEL:
		move.l	a0,d1					;For flags
		movem.l	(a7)+,d1/a1-a2
		rts

ErrorEL:
		suba.l	a0,a0
		bra.b		TheEndEL

	;***
	;Evaluate the address operator
	;a0 = ptr to address operator in string
	;-> d0 = value
	;-> a0 points after operand (or 0, flags if error)
	;***
EvalAddress:
		movem.l	d1/a1,-(a7)
		lea		(1,a0),a0			;Skip *
		bsr		EvalElem
		beq.b		ErrorEA
		move.l	d0,d1					;Address
		movea.l	d0,a1
		moveq		#'L',d0
		cmpi.b	#'.',(a0)
		bne.b		1$						;No '.' so default to '.L'
		lea		(1,a0),a0			;Skip .
		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'B',d0
		beq.b		ByteMAType

1$		btst.l	#0,d1
		SERRne	OddAddress,ErrorEA
		cmpi.b	#'W',d0
		beq.b		WordMAType
		cmpi.b	#'L',d0
		SERRne	OnlyBWL,ErrorEA
		move.l	(a1),d0

TheEndEA:
		move.l	a0,d1					;For flags
		movem.l	(a7)+,d1/a1
		rts
WordMAType:
		move.w	(a1),d0
		bra.b		TheEndEA
ByteMAType:
		move.b	(a1),d0
		bra.b		TheEndEA

ErrorEA:
		suba.l	a0,a0
		bra.b		TheEndEA

	;***
	;Convert a name to an item number
	;a0 = ptr to name
	;-> a0 = ptr after name (or 0, flags if error)
	;-> d0 = item number
	;-> d1 = prompt
	;***
NameToItem:
		movem.l	a1/a5/d2,-(a7)
		lea		(InfoBlocks),a1
		lea		(GetNextListI),a5
		bsr		SearchWord
		tst.l		d1
		SERReq	UnknownListElement,1$
		movea.l	a1,a0
		movea.l	d1,a1
		move.l	(in_Prompt,a1),d1
		moveq		#0,d0
		move.b	(in_Item,a1),d0
2$		move.l	a0,d2					;For flags
		movem.l	(a7)+,a1/a5/d2
		rts
1$		suba.l	a0,a0
		bra.b		2$

	;***
	;Interprete a string or name as a node or structure entity
	;a0 = ptr to string (is assumed to be a name or string)
	;d0 = item number
	;-> d0 = value
	;-> d1 = address (only for list)
	;-> a0 points after string or name (or 0, flags if error)
	;***
InterpreteString:
		movem.l	d2-d7/a1-a5,-(a7)
		move.w	d0,d7					;Remember item number
		cmpi.b	#'''',(a0)
		beq.b		1$
		bsr		ParseName
		beq		15$
		bra.b		2$
1$		bsr		ParseString
		bne		2$

	;Error !
15$	suba.l	a0,a0
		bra		12$

	;Now d0=ptr to string, d1=length, d7=item
2$		move.l	a0,-(a7)
		move.l	d0,d5
		move.l	d1,d6
		subq.w	#2,d7
		mulu.w	#in_SIZE,d7
		lea		(InfoBlocks),a3
		lea		(0,a3,d7.w),a3
		cmpi.b	#-2,(in_Control,a3)
		bne.b		6$
	;The list is an info list (execbase,...)
		movem.l	d0-d1,-(a7)
		bsr		GotoStartList
		movem.l	(a7)+,d0-d1
		movea.l	(a2),a2
		movea.l	(in_InfoList,a3),a0
		movea.l	d0,a1
		bsr		GetItem
		SERReq	AddressedElNotFound,14$
		move.l	a0,d1
		movea.l	d0,a2
		bra		8$
	;Normal list
6$		tst.w		(in_Name,a3)
		bne.b		5$
		SERR		BadListType
14$	movea.l	d5,a0
		bsr		FreeBlock
		moveq		#0,d0
		clr.l		(a7)					;Set a0 on stack to 0 (error)
		bra.b		13$

5$		bsr		GotoStartList
		CALLEXEC	Disable				;We can't use sub Disable because other tasks
											;may call this routine indirectly using
											;'trace c'
		movea.l	(in_Next,a3),a0
		moveq		#0,d0
		move.w	(in_Name,a3),d0
		movea.l	d0,a1
		moveq		#0,d4
		move.l	d4,d7					;Var, free to use
		cmpi.l	#$8000,d0
		blt.b		3$
	;BCPL string
		moveq		#1,d4
		suba.w	#$8000,a1
3$		jsr		(a0)
		SERReq	AddressedElNotFound,4$
		movem.l	a0-a1,-(a7)
		move.l	d6,d0
		movea.l	(0,a2,a1.w),a1
	;Test if string is non-null
		move.l	a1,d1
		beq.b		11$
		tst.w		d4
		beq.b		7$
	;BCPL string
		adda.l	a1,a1
		adda.l	a1,a1
		lea		(1,a1),a1
7$		movea.l	d5,a0
		bsr		CompareCI
		beq.b		10$
	;No string
11$	movem.l	(a7)+,a0-a1
		bra.b		3$
	;Found !
10$	movem.l	(a7)+,a0-a1
		CALLEXEC	Enable
		moveq		#0,d1
8$		movea.l	d5,a0
		move.l	d1,-(a7)
		bsr		FreeBlock
		move.l	(a7)+,d1
		move.l	a2,d0

	;The End
13$	movea.l	(a7)+,a0

	;The End
12$	move.l	a0,d2				;For flags
		movem.l	(a7)+,d2-d7/a1-a5
		rts

4$		CALLEXEC	Enable
		bra		14$

	;***
	;Search for a assignment operator in a string ('...=...')
	;a0 = ptr to string
	;This function will do the assignment
	;-> d0 = value assigned
	;-> flags = Z if no assignment was done and if no error
	;-> d1 = 0 if error (no flags !!!) (only valid if assignment happened)
	;***
Assignment:
		movem.l	a0-a5/d2-d5,-(a7)
		bsr		SkipSpace
		movea.l	a0,a1
1$		moveq		#'=',d0
		bsr		SkipObject
		beq		ErrorEndAS
		bsr		SkipSpace
		cmpi.b	#'=',(a0)
		bne		NoEndAS				;No assignment
	;It could be an assignment but maybe it is a <= >= == or != operator
		cmpi.b	#'<',(-1,a0)
		beq.b		1$
		cmpi.b	#'>',(-1,a0)
		beq.b		1$
		cmpi.b	#'!',(-1,a0)
		beq.b		1$
		lea		(1,a0),a0
		cmpi.b	#'=',(a0)
		beq.b		1$
	;It is an assignment, a0 = ptr after '=', a1 = ptr to object
		move.b	(a1),d0
		bsr		IsLetter
		beq.b		2$
		move.b	(a1),d0
		cmpi.b	#'_',d0
		beq.b		2$
		cmpi.b	#'*',d0
		beq.b		2$
		cmpi.b	#'@',d0
		SERRne	BadVariableName,ErrorEndAS,far
2$		exg		a0,a1
		movem.l	a0-a1,-(a7)
		cmpi.b	#'*',(a0)
		beq		MemTypeAS
		cmpi.b	#'@',(a0)
		beq		SpecArgAS
	;We must assign a variable
		movea.l	(VarStorage,pc),a1	;Ptr to list
		lea		(GetNextVar,pc),a5
		bsr		SearchWordEx			;Search variable
		tst.l		d1
		bne.b		NoNewVarAS
		movem.l	(a7),a0-a1
		moveq		#0,d0
		bsr		FillVar					;d0=0
		bne.b		NoErrAS

	;Error !
ErrAS:
		movem.l	(a7)+,a0-a1			;Clean stack
		bra		ErrorEndAS

	;Everything is fine
NoErrAS:
		movea.l	a1,a2
ContNewVarAS:
		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate
		beq		ErrorEndAS
		move.l	d0,(a2)
		bra		TheEndAS
NoNewVarAS:
		movea.l	d1,a2
		cmpi.b	#2,(5,a2)			;Special var ?
		beq.b		1$
		cmpi.b	#1,(5,a2)			;Constant ?
		SERReq	VarIsConstant,ErrAS
		cmpi.b	#3,(5,a2)
		SERReq	VarIsFunction,ErrAS
		bra.b		ContNewVarAS
	;Variable is a special variable (with a corresponding routine)
1$		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate
		beq		ErrorEndAS
		move.l	(a2),d1				;Get old var
		move.l	d0,(a2)				;Store new var
	;Get ptr to special routine
		moveq		#0,d2
		move.b	(4,a2),d2			;Get str len
		btst		#0,d2
		beq.b		2$
		addq.w	#1,d2					;Str len odd, add pad byte
2$		movea.l	(6,a2,d2.w),a1
		move.l	d0,-(a7)
		jsr		(a1)
		move.l	(a7)+,d0
		bra		TheEndAS
	;Assign to special argument
SpecArgAS:
		move.l	(CurrentDebug),d0
		SERReq	NoDebugTask,ErrAS,far
		movea.l	d0,a2
		moveq		#0,d7
		lea		(1,a0),a0			;Skip @

		bsr		GetRegister
		bne.b		1$

	;Error (unknown register)
		SERR		BadSpecialArg
		bra		ErrAS

1$		cmpi.b	#REG_SP,d0
		beq.b		SPRegAS
		cmpi.b	#REG_SR,d0
		beq.b		SRRegAS
	;Assign to a normal register or the program counter
		movea.l	(db_Task,a2),a2
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a2
		movea.l	(a7)+,a4
		adda.l	d1,a2

	;Assign register and refresh debug display if any
AssignReg:
		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate
		beq		ErrorEndAS
		move.l	d0,(a2)
		bsr		DebugRefresh
		bra		TheEndAS

	;Assign to SR
SRRegAS:
		movea.l	(db_Task,a2),a2
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a2
		movea.l	(a7)+,a4
		adda.l	d1,a2

		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate
		beq		ErrorEndAS
		move.w	d0,(a2)
		bsr		DebugRefresh
		bra		TheEndAS

	;Assign to SP
SPRegAS:
		movea.l	a2,a3					;Debug node ptr
		bsr		CheckIfTrace
		beq		ErrAS
		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate				;d0=new stack value
		beq		ErrorEndAS
		lea		(TheStack,pc),a0
		move.l	d0,(a0)
	;Get the pointer to the task and let the task execute the one
	;instruction to change the stack pointer
		movea.l	(db_Task,a2),a2
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a0					;a0=ptr to exec stackframe (after FFP)
		movea.l	(a7)+,a4
		move.l	(a0),d0				;Get PC
		move.l	d0,-(a7)				;Remember old PC
		move.l	#ChangeStack,(a0)+	;Force new PC
		ori.w		#$8000,(a0)			;Enable trace mode for task
		bsr		Disable
		movea.l	a2,a1
		CALLEXEC	Remove
		move.b	#TS_READY,(TC_STATE,a2)
		lea		(TaskReady,a6),a0
		movea.l	a2,a1
		CALL		AddHead				;Add to ready list
		move.l	#ChangeSPBreakTV,(db_TRoutine,a3)
		bsr		Enable
	;Wait for completion
		move.l	(ChangeSPSigSet),d0
		CALL		Wait
1$		moveq		#5,d1
		CALLDOS	Delay
		tst.b		(db_SpecialBit,a3)
		beq.b		1$
		bsr		Disable
	;Restore registers
		move.l	a4,-(a7)
		lea		(db_PC,a3),a0
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a1
		moveq		#15,d0				;Loop 16 times

2$		move.l	(a0)+,(a1)+
		dbra		d0,2$

		move.w	(a0),(a1)
	;Register are restored
		andi.w	#$3fff,(4,a4)		;Disable trace mode
		movea.l	a4,a0					;a0=ptr to exec stackframe (after FFP)
		movea.l	(a7)+,a4
		move.l	(a7)+,(a0)			;Restore PC
		clr.l		(TC_SIGWAIT,a2)
		move.b	#TS_WAIT,(TC_STATE,a2)
		movea.l	a2,a1
		CALLEXEC	Remove
		movea.l	a2,a1
		lea		(TaskWait,a6),a0
		CALL		AddHead
		bsr		Enable
		bsr		DebugRefresh
		bra		TheEndAS
	;This little routine is executed by the debug task
ChangeStack:
		movea.l	(TheStack,pc),a7
TheStack:		dc.l	0

	;Assign to memory type
MemTypeAS:
		lea		(1,a0),a0				;Skip *
		bsr		EvalElem
		beq		ErrAS
		movea.l	d0,a2
		move.l	d0,d1
		moveq		#'L',d0
		cmpi.b	#'.',(a0)
		bne.b		ContinueAS			;No '.' so default to '.L'
		lea		(1,a0),a0				;Skip .
		move.b	(a0)+,d0
		bsr		Upper
		cmpi.b	#'B',d0
		beq.b		ByteMType
ContinueAS:
		btst.l	#0,d1
		SERRne	OddAddress,ErrAS,far
		cmpi.b	#'W',d0
		beq.b		WordMType
		cmpi.b	#'L',d0
		SERRne	OnlyBWL,ErrAS,far
		bra		ContNewVarAS
WordMType:
		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate
		beq.b		ErrorEndAS
		move.w	d0,(a2)
		bra.b		TheEndAS
ByteMType:
		movem.l	(a7)+,a0-a1
		movea.l	a1,a0
		bsr		Evaluate
		beq.b		ErrorEndAS
		move.b	d0,(a2)
		bra.b		TheEndAS
NoEndAS:
		moveq		#1,d1					;No error
		moveq		#0,d2					;For flags (assignment)
		movem.l	(a7)+,a0-a5/d2-d5
		rts
TheEndAS:
		moveq		#1,d1					;No error
		moveq		#1,d2					;For flags (no assignment)
		movem.l	(a7)+,a0-a5/d2-d5
		rts
ErrorEndAS:
		moveq		#0,d1					;Error
		moveq		#1,d2					;For flags (no assignment)
		movem.l	(a7)+,a0-a5/d2-d5
		rts


	;***
	;Interprete an hexadecimal value
	;a0 = string to interprete
	;-> Value in d0
	;-> a0 points to first non hex value
	;***
ParseHex:
		move.l	d2,-(a7)
		moveq		#0,d2					;Parsed value (zero for starting)
1$		move.b	(a0),d0
		bsr		IsHex
		bne.b		2$
		addq.l	#1,a0
		lsl.l		#4,d2
		add.l		d1,d2
		bra.b		1$
2$		move.l	d2,d0
		move.l	(a7)+,d2
		rts

	;***
	;Interprete a decimal value
	;a0 = string to interprete
	;-> Value in d0
	;-> a0 points to first non dec value
	;***
ParseDec:
		movem.l	d2-d3,-(a7)
		moveq		#0,d2					;Parsed value (zero for starting)
1$		move.b	(a0),d0
		bsr		IsDigit
		bne.b		2$
		adda.l	#1,a0
		lsl.l		#1,d2
		move.l	d2,d3
		lsl.l		#2,d2
		add.l		d3,d2					;Multiply d2 by 10
		add.l		d1,d2
		bra.b		1$
2$		move.l	d2,d0
		movem.l	(a7)+,d2-d3
		rts

	;***
	;Parse a name
	;a0 = string to interprete
	;-> See ParseString
	;***
ParseName:
		movem.l	a2-a3/d2-d4,-(a7)
		move.l	a0,-(a7)				;Remember string
		moveq		#0,d0
		move.w	(DefLineLen),d0
		bsr		AllocBlockInt
		movea.l	(a7)+,a0				;For flags
		beq.b		3$

	;Success
		movea.l	d0,a2
		movea.l	d0,a3
1$		move.b	(a0),d0
		bsr		IsNameChar
		bne		EndParseStr
		move.b	(a0),(a2)+
		lea		(1,a0),a0
		bra.b		1$

	;Error
3$		moveq		#0,d0
		movem.l	(a7)+,a2-a3/d2-d4
		rts

	;***
	;Interprete a string
	;a0 = string to interprete
	;-> String is copied in memory
	;-> Ptr to the string in d0 (or 0, flags if error)
	;-> a0 points to first non string byte
	;-> d1 is length of string
	;***
ParseString:
		movem.l	a2-a3/d2-d4,-(a7)
		move.b	(a0),d1
		cmpi.b	#'''',d1
		beq.b		5$
		cmpi.b	#'"',d1
		beq.b		5$
		moveq		#' ',d1
		subq.l	#1,a0
5$		lea		(1,a0),a0
		movem.l	a0/d1,-(a7)			;Remember string and char
		moveq		#0,d0
		move.w	(DefLineLen),d0
		bsr		AllocBlockInt
		movem.l	(a7)+,a0/d3			;Store char in d3 instead of d1
		beq.b		9$
	;Success
		movea.l	d0,a2
		movea.l	d0,a3

	;Parse loop
1$		move.b	(a0),d0
		move.l	d3,d1
		bsr		IsString
		bne.b		2$
		cmpi.b	#'·',(a0)			;Test if strong quote (alt-8)
		bne.b		10$

	;Yes, a strong quote
		lea		(1,a0),a0
		move.b	(a0)+,d0				;End char
11$	tst.b		(a0)
		beq.b		1$
		cmp.b		(a0),d0
		bne.b		12$
		lea		(1,a0),a0
		bra.b		1$
12$	move.b	(a0)+,(a2)+
		bra.b		11$

10$	cmpi.b	#'\',(a0)			;Test if special char
		bne.b		3$
	;Escape char
	;If escape char is a left bracket we interprete it as an expression
	;and put the result in the string
		lea		(1,a0),a0
		move.b	(a0),d0
		cmpi.b	#'(',d0
		bne.b		6$

		bsr		ParseIntInString
		bne.b		1$

	;Error
8$		movea.l	a3,a0
		bsr		FreeBlock			;Free string
		moveq		#0,d0					;a0 = 0 from 'Evaluate'
9$		movem.l	(a7)+,a2-a3/d2-d4
		rts

	;It is not a '(', it could be a hexadecimal integer
6$		move.b	(a0),d0
		cmp.b		#'n',d0
		bne.b		13$
	;It is a \n (newline)
		move.b	#10,(a2)+
		lea		(1,a0),a0
		bra.b		1$
13$	bsr		IsHex
		bne.b		3$
		move.b	d1,d4
		lsl.b		#4,d4
		lea		(1,a0),a0
		move.b	(a0),d0
		bsr		IsHex
		bne.b		3$
		add.b		d1,d4
		lea		(1,a0),a0
		move.b	d4,(a2)+
		bra.b		1$
3$		move.b	(a0)+,(a2)+
		bra		1$
2$		cmp.b		(a0),d3
		bne.b		EndParseStr
		lea		(1,a0),a0				;Skip string delimiter
EndParseStr:
		clr.b		(a2)+
		move.l	a0,-(a7)
		movea.l	a3,a1
		move.l	a2,d1
		sub.l		a3,d1					;Length of string (including 0)
		bsr		ShrinkBlock
		moveq		#0,d1
		move.w	(-2,a3),d1			;Get length
		subq.w	#1,d1					;Length without 0
		move.l	a3,d0
		movea.l	(a7)+,a0
		movem.l	(a7)+,a2-a3/d2-d4
		tst.l		d0						;For flags
		rts

	;***
	;Parse an integer in a string
	;a0 = pointer to string '('
	;a2 = destination string
	;-> a0,a2 updated
	;-> d0,flags = 0 if error
	;***
ParseIntInString:
	;Yes, it is a left bracket
		lea		(1,a0),a0				;Point after left bracket
		bsr		Evaluate
		bne.b		7$

	;Error
8$		moveq		#0,d0
		rts

	;Success
7$		bsr		SkipSpace			;Skip ',' or ' '
		movem.l	d2/a0/a2-a5,-(a7)
		move.l	d0,d2					;Remember number
		cmpi.b	#')',(a0)			;Check if this is the end of the expression
		bne.b		10$

12$	lea		(FormatStrLTDold,pc),a4
		suba.l	a5,a5
		bra.b		11$

	;No, we must format 'd2' in a specific manner
10$	movea.l	a0,a3
		moveq		#30,d0
		bsr		AllocBlockInt
		beq.b		12$					;If error, we take the standard format
		movea.l	d0,a4
		movea.l	d0,a5

	;Copy to new format
		moveq		#28,d0
		movea.l	a4,a1

13$	move.b	(a3)+,d1
		beq.b		15$
		cmpi.b	#')',d1
		beq.b		15$
		move.b	d1,(a1)+
		dbra		d0,13$

15$	clr.b		(a1)+

	;a4 = format string
	;a5 = format string or 0 if not allocated
	;d2 = data
11$	movea.l	a4,a0					;Format string
		move.l	d2,-(a7)
		movea.l	a7,a1					;Data stream
		movea.l	a2,a3					;PutChData
		lea		(PutProc,pc),a2	;PutChProc
		CALLEXEC	RawDoFmt
		lea		(4,a7),a7			;Skip number on stack
		move.l	a5,d0
		beq.b		14$
	;Free block
		movea.l	a5,a0
		bsr		FreeBlock
14$	movem.l	(a7)+,d2/a0/a2-a5

	;Search end of string or ')'
16$	move.b	(a0)+,d0
		beq.b		17$
		cmpi.b	#')',d0
		beq.b		18$
		bra.b		16$
17$	subq.l	#1,a0

	;Search end of destination string
18$	move.b	(a2)+,d0
		bne.b		18$
		subq.l	#1,a2
		moveq		#1,d0
		rts

PutProc:
		move.b	d0,(a3)+
		rts

	;***
	;Skip spaces
	;a0 = string to skip
	;-> a0 is a ptr to the first non white space byte
	;-> flags if end of string is reached
	;***
SkipSpace:
		cmpi.b	#' ',(a0)+
		beq.b		SkipSpace
		cmpi.b	#',',(-1,a0)
		beq.b		SkipSpace
		cmpi.b	#9,(-1,a0)
		beq.b		SkipSpace
		subq.l	#1,a0
		tst.b		(a0)
		rts

	;***
	;Skip non spaces
	;a0 = string to skip
	;-> a0 is a ptr to the first white space byte
	;***
SkipNSpace:
		cmpi.b	#0,(a0)
		beq.b		1$
		cmpi.b	#' ',(a0)
		beq.b		1$
		cmpi.b	#',',(a0)
		beq.b		1$
		cmpi.b	#9,(a0)+
		bne.b		SkipNSpace
	;We have found the end
		subq.l	#1,a0
1$		rts

	;***
	;Determine the type of the next object
	;a0 = string to interprete
	;-> d0 contains type (flags)
	;		0 : error, unknown type
	;		1 : Hex integer					$54fe20 or 03d4 (start with zero)
	;		2 : Decimal integer				213005
	;		3 : String "						"This 'is' a string"
	;		4 : OBSOLETE
	;		5 : Memory operator				*(4+6).l
	;		6 : Unary operator				-5
	;		7 : Expression						(5+6)
	;		8 : List type						libs:'exec.library'
	;		9 : Name								OpenWindow
	;		10: String '						'input.device'
	;		11: End of line
	;		12: Special argument				@d1
	;		13: Address list					&exec:VBlank
	;		14: Group operator				{list,m}
	;		15: Linenumber operator			#expression
	;***
FindNextType:
		movem.l	a0-a1/d1-d2,-(a7)
		move.b	(a0),d0
		moveq		#14,d1				;Loop 15 times
		lea		(TypeTable,pc),a1
1$		lea		(1,a1),a1
		cmp.b		(a1)+,d0
		dbeq		d1,1$
		cmpi.w	#-1,d1
		beq.b		NotFoundFNT
		moveq		#0,d0
		move.b	(-2,a1),d0
		beq.b		ErrorSyntax
EndFNT:
		movem.l	(a7)+,a0-a1/d1-d2
		tst.l		d0						;For flags
		rts
NotFoundFNT:
		move.l	d0,d2
		bsr		IsDigit
		beq.b		DecIntFNT
		move.l	d2,d0
		bsr		IsLetter
		beq.b		NameFNT
		cmpi.b	#'_',d2
		bne.b		ErrorSyntax
NameFNT:
		movea.l	a0,a1
1$		move.b	(a1)+,d0
		bsr		IsNameChar
		beq.b		1$
		moveq		#T_LISTELEM,d0
		cmpi.b	#':',-(a1)
		beq.b		EndFNT
		moveq		#T_NAME,d0
		bra.b		EndFNT
DecIntFNT:
		moveq		#T_DEC,d0
		bra.b		EndFNT

ErrorSyntax:
		SERR		Syntax
		moveq		#0,d0
		bra.b		EndFNT

	;***
	;Evaluate a single expression element (including unary operators)
	;a0 = ptr to element to evaluate
	;-> a0 points after the element (or 0, flags if error)
	;-> d0 is value of element
	;***
EvalElem:
		movem.l	a1-a5/d2-d7,-(a7)
		movea.l	a7,a3					;Remember stackpointer so that
											;we can clean everything up if an
											;error occurs
		bsr		FindNextType
		beq		ErrorEvalElem
		movea.l	a0,a2
		lea		(RoutParseEE,pc),a1
		lsl.l		#2,d0
		movea.l	(0,a1,d0.l),a6
		move.l	(Item),-(a7)			;Save Item and TItem
		jsr		(a6)
		move.l	(a7)+,(Item)			;Restore Item and TItem
		move.l	a0,d2					;For flags
		movem.l	(a7)+,a1-a5/d2-d7
		rts
RP2HexInt:
		lea		(1,a0),a0				;Skip $
		bra		ParseHex
RP2DecInt		equ	ParseDec
RP2String1:
		bsr		ParseString
		beq		ErrorEvalElem
		bsr		AddAutoClear
		bne.b		1$
	;Error, we must free the other string, otherwise it is lost forever
		movea.l	d0,a0
		bsr		FreeBlock
		bra		ErrorEvalElem
	;Success
1$		rts
RP2ListElem:
		move.w	(Item),d0
		cmpi.b	#':',(a0)
		beq.b		1$
		bsr		NameToItem
		beq		ErrorEvalElem
1$		lea		(1,a0),a0				;Skip :
		bsr		InterpreteString
		beq		ErrorEvalElem
		rts
RP2ListAddr:
		move.w	(Item),d0
		lea		(1,a0),a0				;Skip & operator
		cmpi.b	#':',(a0)
		beq.b		1$
		bsr		NameToItem
		beq		ErrorEvalElem
1$		cmpi.b	#':',(a0)+
		SERRne	Syntax,ErrorEvalElem,far
		bsr		InterpreteString
		beq		ErrorEvalElem
		move.l	d1,d0
		SERReq	BadListType,ErrorEvalElem,far
		rts
RP2Name:
	;Check if it is a variable
		movea.l	a0,a2
		move.l	a1,-(a7)
		movea.l	(VarStorage,pc),a1	;Ptr to list
		lea		(GetNextVar,pc),a5
		bsr		SearchWordEx
		movea.l	a1,a6
		movea.l	d1,a5					;Ptr to varelem
		movea.l	(a7)+,a1
		tst.l		d1
		beq.b		RP2String2
	;d0 contains variable value (or func address)
		movea.l	a6,a0
		cmpi.b	#3,(5,a5)			;Function ?
		bne.b		1$
		cmpi.b	#'(',(a0)+
		SERRne	FuncNeedsBrack,ErrorEvalElem,far
		movea.l	a0,a5
	;Search the end of the function parameter list
		move.l	d0,-(a7)				;Save func address
2$		moveq		#0,d0
		bsr		SkipObject
		beq		ErrorEvalElem
		tst.b		(a0)
		SERReq	CloseBracketExp,ErrorEvalElem,far
		cmpi.b	#')',(a0)
		beq.b		4$
	;We are not at the end of the function parameter list yet
		lea		(1,a0),a0				;Skip blank char
		bra.b		2$
4$		clr.b		(a0)+					;Skip ')' and overwrite it
		movea.l	(a7)+,a1
		movem.l	a0/a2-a3,-(a7)
		movea.l	a5,a0
		lea		(PVCallTable),a2
		jsr		(a1)
		movem.l	(a7)+,a0/a2-a3
		move.b	#')',(-1,a0)		;Restore ')'
1$		rts
RP2String2:
	;The string is no variable
	;Now we try if is a library function
		movea.l	a2,a0
		move.l	a2,-(a7)
		bsr		StringToLib
		movea.l	(a7)+,a2				;For flags
		bne.b		1$

	;Error, we clear the error flag because we want to try other interpretations
	;of the string too
		clr.w		(LastError)
		bra.b		RP2IntString

	;It is a library function
1$		cmpi.b	#'(',(a0)
		bne.b		RP2IntString		;There are no arguments, interprete as integer
		bsr		CallLibFunc
		beq		ErrorEvalElem
		rts
RP2IntString:
	;It was no library function
	;See if it is a symbol in the current debugtask
		move.l	(CurrentDebug),d0
		beq.b		1$
		move.l	a2,-(a7)
		movea.l	a2,a0
		movea.l	d0,a2
		cmpi.b	#'''',(a0)
		beq.b		3$
		bsr		ParseName
		beq		ErrorEvalElem
		bra.b		4$
3$		bsr		ParseString
		beq		ErrorEvalElem
4$		movea.l	a0,a4
		move.l	d0,-(a7)				;*1
		movea.l	d0,a0					;d1=len
		bsr		GetSymbolVal
		move.l	d0,-(a7)
		movea.l	(4,a7),a0
		bsr		FreeBlock
		movea.l	a4,a0
		move.l	(a7)+,d0
		lea		(4,a7),a7				;Skip *1
		movea.l	(a7)+,a2
		cmpi.l	#-1,d0
		bne.b		2$						;Yes !
	;See if it is a list member of the current list
1$		movea.l	a2,a0
		moveq		#0,d0
		move.w	(Item),d0
		bsr		InterpreteString
		beq		ErrorEvalElem
2$		rts
RP2Exp:
		lea		(1,a0),a0				;Skip '('
		bsr		Evaluate
		beq		ErrorEvalElem
		cmpi.b	#')',(a0)
		bne.b		1$
		lea		(1,a0),a0				;Skip ')'
1$		rts
RP2Eol:
		SERR		MissingOp
		bra		ErrorEvalElem

	;Handle the line number operator '#'
RP2LineNr:
		bsr		EvalLineNr
		beq		ErrorEvalElem
		rts

	;Handle the memory operator '*'
RP2MemType:
		bsr		EvalAddress
		beq		ErrorEvalElem
		rts

	;Handle the unary operators
RP2Unary:
		move.b	(a0)+,d2				;Skip -,! or ~
		movem.l	d2,-(a7)
		bsr		EvalElem
		movem.l	(a7)+,d2				;For flags
		beq		ErrorEvalElem
		cmpi.b	#'-',d2
		beq.b		3$
		cmpi.b	#'!',d2
		beq.b		1$
		not.l		d0						;Unary operator was ~
		rts
	;Logical not
1$		tst.l		d0
		beq.b		2$
		moveq		#0,d0
		rts
2$		moveq		#1,d0
		rts
	;Unary minus:
3$		neg.l		d0						;Unary operator was -
		rts
	;Group operator
RP2Group:
		move.l	(InDebugTask),d0
	;Generate an error if groups are used in a debug expression
		SERRne	NoGroupInDebug,ErrorEvalElem,far
		lea		(1,a0),a0				;Skip {
		movem.l	a1-a5/d1-d7,-(a7)
		bsr		HandleGroup
		movem.l	(a7)+,a1-a5/d1-d7
		beq		ErrorEvalElem
		rts
	;Special argument (for debug, ...)
RP2SpecArg:
		lea		(1,a0),a0				;Skip @
		move.l	(InDebugTask),d0
		bne		FromConditional
		move.l	(CurrentDebug),d0
		SERReq	NoDebugTask,ErrorEvalElem,far
		movea.l	d0,a2

		bsr		GetRegister
		bne.b		1$

	;Error (unknown register)
		SERR		BadSpecialArg
		bra		ErrorEvalElem

1$		cmpi.b	#REG_SP,d0
		beq.b		SPRegEE
		cmpi.b	#REG_SR,d0
		beq.b		SRRegEE

	;Get a register or PC
		movea.l	(db_Task,a2),a2
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a2
		movea.l	(a7)+,a4
		adda.l	d1,a2
		move.l	(a2),d0
		rts

SPRegEE:
		move.l	(db_SP,a2),d0
		rts

SRRegEE:
		movea.l	(db_Task,a2),a2
		move.l	a4,-(a7)
		movea.l	(TC_SPREG,a2),a4
		bsr		SkipStackFrame
		movea.l	a4,a2
		movea.l	(a7)+,a4
		adda.l	d1,a2
		moveq		#0,d0
		move.w	(a2),d0
		rts

	;Same as the above code but now for use in a debug task
FromConditional:
		movea.l	d0,a2

		bsr		GetRegister
		bne.b		1$

	;Error (unknown register)
		SERR		BadSpecialArg
		bra		ErrorEvalElem

1$		cmpi.b	#REG_SP,d0
		beq.b		SPRegFC
		cmpi.b	#REG_SR,d0
		beq.b		SRRegFC
		cmpi.b	#REG_PC,d0
		beq.b		PCRegFC

	;Get register
		lea		(db_Registers,a2),a2
		move.l	(-6,a2,d1.w),d0
		rts

SPRegFC:
		move.l	(DebugSP),d0
		rts

PCRegFC:
		move.l	(db_PC,a2),d0
		rts

SRRegFC:
		moveq		#0,d0
		move.w	(db_SR,a2),d0
		rts

RP2Error:
		SERR		Syntax
ErrorEvalElem:
		movea.l	a3,a7					;Restore stack
		suba.l	a0,a0
		move.l	a0,d2					;For flags
		movem.l	(a7)+,a1-a5/d2-d7
		rts

	;***
	;Evaluate expression and generate error if error
	;***
EvaluateE:
		bsr.b		Evaluate
		HERReq
		rts

	;***
	;Evaluate an expression
	;An expression may contain decimal integers, hex integers, string 1 types,
	;list ptr types, memory types, variables and type variables
	;The following operators are permitted:
	;	+		-		*		/		% (mod)		& (and)		| (or)		^ (xor)
	;	<<		>>		<		>		>=				<=				!=				==
	;	&&		||
	;	~ (not)  - (neg)  ! (logical not)
	;a0 = ptr to expression to evaluate
	;-> a0 points directly after the expression (or 0, flags if error)
	;-> d0 is the result of the expression
	;***
Evaluate:
		bsr		SkipSpace
		moveq		#1,d1					;Init level counter
EvaluateR:
		bsr		CheckStack
		SERRlt	StackOverflow,2$
		bra.b		3$
	;Stack overflow
2$		suba.l	a0,a0
		move.l	a0,d0					;For flags
		rts

3$		movem.l	d2-d7/a1-a5,-(a7)
		lea		(-10*4,a7),a7		;Reserve space for value table
		movea.l	a7,a2
		lea		(-10,a7),a7			;Reserve space for operator table
		movea.l	a7,a3
		move.l	d1,-(a7)				;Level counter
	;Clear operator and value table
		movem.l	a2-a3,-(a7)
		moveq		#0,d6					;New op level
		moveq		#9,d0					;Loop 10 times

1$		clr.b		(a3)+					;Init operator
		clr.l		(a2)+					;Init value
		dbra		d0,1$

		movem.l	(a7)+,a2-a3
		moveq		#1,d7					;Current operator level is the sum level
		move.b	#'+',(a3)			;Init plus as start operator
LoopEVAL:
		cmpi.b	#'(',(a0)
		bne.b		1$
		lea		(1,a0),a0
		move.l	(a7),d1				;Get level counter
		addq.l	#1,d1
		bsr		EvaluateR
		beq		ErrorEVAL
		bra.b		2$
1$		bsr		EvalElem
		beq		ErrorEVAL

	;Success
2$		move.l	d0,d5					;Preserve value
		move.b	(a0)+,d4				;Get operator
		cmpi.b	#')',d4
		beq		EndExpEVAL
	;&&, ||, <<, >>, ==
		cmp.b		(a0),d4
		bne.b		4$
		addi.b	#128,d4
		bra.b		5$
	;>=, <=, !=
4$		cmpi.b	#'=',(a0)
		bne.b		6$
		addi.b	#172,d4
5$		lea		(1,a0),a0
6$		moveq		#17,d1				;Loop 18 times
		lea		(HeightTable,pc),a4;Operators and levels
		lea		(HeightTableL,pc),a5
3$		lea		(1,a5),a5
		cmp.b		(a4)+,d4
		dbeq		d1,3$
		cmpi.w	#-1,d1
		beq		EndExpEVAL2			;Operator not recognised, so end of expression
		move.b	(-1,a5),d6
		cmp.b		d6,d7
		bcs.b		OpGTCurEVAL
		bne.b		OpLTCurEVAL
	;The operator levels are equal
		move.l	d7,d2
		subq.l	#1,d2
		lsl.l		#2,d2
		move.l	(0,a2,d2.l),d0		;Get value for current operator
		move.l	d5,d1
		bsr		ComputeEVAL
		move.l	d0,(0,a2,d2.l)		;New computed value
		move.b	d4,(-1,a3,d7.l)		;Operator
		bra		LoopEVAL
	;The new operator has a higher level than the current
OpGTCurEVAL:
		move.l	d6,d7					;Current level is new operator level
		move.b	d4,(-1,a3,d7.l)		;Operator
		move.l	d7,d2
		subq.l	#1,d2
		lsl.l		#2,d2
		move.l	d5,(0,a2,d2.l)		;First value in this level
		bra		LoopEVAL
	;The new operator has a lower level than the current
OpLTCurEVAL:
		move.l	d7,d2
		subq.l	#1,d2
		lsl.l		#2,d2
		move.l	(0,a2,d2.l),d0		;Get value for current operator
		move.l	d5,d1
		bsr		ComputeEVAL
		move.l	d0,d5					;Preserve value
		clr.b		(-1,a3,d7.l)		;Operator field is empty
	;Search the next lower level in use
LoopSEVAL:
		subq.l	#1,d7
		tst.b		(-1,a3,d7.l)
		beq.b		LoopSEVAL
		move.l	d7,d2
		subq.l	#1,d2
		lsl.l		#2,d2
		move.l	(0,a2,d2.l),d0		;Get value for current operator
		move.l	d5,d1
		bsr		ComputeEVAL
		move.l	d0,(0,a2,d2.l)		;New computed value
		move.b	d4,(-1,a3,d7.l)		;Operator field
		bra		LoopEVAL

	;End of the expression because there is something we don't understand
	;Check if all brackets are closed
EndExpEVAL2:
		cmpi.l	#1,(a7)
		SERRne	CloseBracketExp,ErrorEVAL
		bra.b		EndExpEVAL3

	;There is a closebracket, check if the expression is done
EndExpEVAL:
	;Check if the closebracket is permitted
		cmpi.l	#1,(a7)
		bne.b		LoopEndEVAL
EndExpEVAL3:
		subq.l	#1,a0
LoopEndEVAL:
		tst.b		(-1,a3,d7.l)
		bne.b		DoComputeEVAL
BackEVAL:
		subq.l	#1,d7
		bne.b		LoopEndEVAL
		bra.b		TheEndEVAL
DoComputeEVAL:
		move.l	d7,d2
		subq.l	#1,d2
		lsl.l		#2,d2
		move.l	(0,a2,d2.l),d0		;Get value for current operator
		move.l	d5,d1
		bsr		ComputeEVAL
		move.l	d0,d5
		bra.b		BackEVAL
TheEndEVAL:
		move.l	d5,d0
		lea		(10*4+10+4,a7),a7	;Free space
		move.l	a0,d2					;For flags
		movem.l	(a7)+,d2-d7/a1-a5
		rts
	;Error
ErrorEVAL:
		suba.l	a0,a0
		bra.b		TheEndEVAL

	;Subroutine: compute d0 and d1 using the current operator
	;-> d0 = result
ComputeEVAL:
		move.b	(-1,a3,d7.l),d3		;Current operator
		lea		(HeightTable,pc),a4;Operators and routines
		lea		(ComputeTableR,pc),a5
Loop3EVAL:
		lea		(4,a5),a5
		cmp.b		(a4)+,d3
		bne.b		Loop3EVAL
		movea.l	(-4,a5),a5
		jmp		(a5)

	;Error routine for ComputeEVAL
ErrorCEVAL:
		SERR		DivideByZero
		lea		(4,a7),a7				;Pop return address from stack
		bra.b		ErrorEVAL

	;Compute routines
XorEVAL:
		eor.l		d1,d0
		rts
AndEVAL:
		and.l		d1,d0
		rts
OrEVAL:
		or.l		d1,d0
		rts
MulEVAL:
		bra		LMult
DivEVAL:
		tst.l		d1
		beq.b		ErrorCEVAL
		bra		LDiv
ModEVAL:
		tst.l		d1
		beq.b		ErrorCEVAL
		bra		LMod
PlusEVAL:
		add.l		d1,d0
		rts
MinEVAL:
		sub.l		d1,d0
		rts
AndlEVAL:
		tst.l		d0
		bne.b		OkAl2EVAL
		rts
OkAl2EVAL:
		tst.l		d1
		bne.b		GoodEVAL
BadEVAL:
		moveq		#0,d0
		rts
GoodEVAL:
		moveq		#1,d0
		rts
OrlEVAL:
		tst.l		d0
		beq.b		OkAl2EVAL
		bra.b		GoodEVAL
EqualEVAL:
		cmp.l		d0,d1
		beq.b		GoodEVAL
		bra.b		BadEVAL
NotEqualEVAL:
		cmp.l		d0,d1
		bne.b		GoodEVAL
		bra.b		BadEVAL
GTEVAL:
		cmp.l		d1,d0
		bgt.b		GoodEVAL
		bra.b		BadEVAL
LTEVAL:
		cmp.l		d1,d0
		blt.b		GoodEVAL
		bra.b		BadEVAL
RShiftEVAL:
		lsr.l		d1,d0
		rts
LShiftEVAL:
		lsl.l		d1,d0
		rts
LEEVAL:
		cmp.l		d1,d0
		ble.b		GoodEVAL
		bra.b		BadEVAL
GEEVAL:
		cmp.l		d1,d0
		bge.b		GoodEVAL
		bra.b		BadEVAL

	;***
	;Get the rest of the commandline
	;a0 = cmdline
	;-> d0 = ptr to string (or 0, flags if error)
	;-> d1 = length
	;***
GetRestLine:
		bsr		GetRestLinePer
		beq.b		1$
		bsr		AddAutoClear
		bne.b		1$
	;Out of memory error, clear string
		movea.l	d0,a0
		bsr		FreeBlock
		moveq		#0,d0					;Indicate error
1$		rts
GetRestLinePer:
		NEXTTYPE
		SERReq	MissingOp,ErrorGRL
		bsr		SkipSpace
		bsr		AllocStringInt
		beq.b		ErrorGRL
		rts

	;Handle error
ErrorGRL:
		moveq		#0,d0
		rts

	;***
	;GetString with error handling
	;***
GetStringE:
		bsr.b		GetString
		HERReq
		rts

	;***
	;Get a string (T_STRING2) or name (T_NAME) from the argument line
	;a0 = ptr to string (input line)
	;-> d0 = ptr to string (or 0, flags if error)
	;-> d1 = length
	;***
GetString:
		bsr		GetStringPer
		beq.b		1$
		bsr		AddAutoClear
		bne.b		1$
	;Out of memory error, clear string
		movea.l	d0,a0
		bsr		FreeBlock
		moveq		#0,d0					;Indicate error
1$		rts
GetStringPer:
		NEXTTYPE
		SERReq	MissingOp,ErrorGST
		bsr		SkipSpace
		bsr		ParseString
		beq.b		ErrorGST
		rts

	;Handle error
ErrorGST:
		moveq		#0,d0
		rts

	;***
	;Skip the next command (no skipspace)
	;a0 = ptr to command
	;-> a0 = ptr after command (or 0, flags if error)
	;***
SkipCommand:
1$		move.b	(a0)+,d0
		beq.b		2$
		cmpi.b	#'}',d0
		beq.b		2$
		cmpi.b	#';',d0
		beq.b		2$
		cmpi.b	#'''',d0
		beq.b		3$
		cmpi.b	#'"',d0
		beq.b		3$
		cmpi.b	#'{',d0
		beq.b		5$
		cmpi.b	#'\',d0
		bne.b		1$
		move.b	(a0)+,d0
		beq.b		2$
		cmpi.b	#'(',d0
		bne.b		1$

	;A pair of brackets
5$		subq.l	#1,a0
		bsr		SkipBrackets
		beq.b		4$
		bra.b		1$

	;The end
2$		subq.l	#1,a0
4$		move.l	a0,d0					;For flags
		rts

	;A string
3$		subq.l	#1,a0
		bsr		SkipString
		bra.b		1$

	;***
	;Get the next command (no skipspace)
	;a0 = ptr to command
	;-> a0 = ptr after command
	;-> d0 = ptr to command (0, flags if error)
	;***
;GetCommand:
;		movem.l	d1/d7/a1-a2,-(a7)
;		move.l	a0,d7
;		bsr		SkipCommand
;		bra		MakeStringGO

	;***
	;Skip the next object (no skipspace done)
	;d0 = optional extra character to stop parsing
	;a0 = ptr to object
	;-> a0 = ptr after object (or 0, flags if error)
	;***
SkipObject:
		move.b	d0,d1
1$		move.b	(a0)+,d0
		beq.b		2$
		cmpi.b	#' ',d0				;Check for end of object
		beq.b		2$
		cmpi.b	#',',d0
		beq.b		2$
		cmp.b		d1,d0					;Skip optional extra char
		beq.b		2$
		cmpi.b	#'(',d0
		beq.b		5$
		cmpi.b	#'[',d0
		beq.b		5$
		cmpi.b	#'{',d0
		beq.b		5$
		cmpi.b	#')',d0
		beq.b		2$
		cmpi.b	#'''',d0
		beq.b		3$
		cmpi.b	#'"',d0
		beq.b		3$
		cmpi.b	#'·',d0
		beq.b		3$
		cmpi.b	#'\',d0
		bne.b		1$
	;Quote char
		move.b	(a0)+,d0
		beq.b		2$
		cmpi.b	#'(',d0
		bne.b		1$

	;A pair of brackets
5$		subq.l	#1,a0
		bsr		SkipBrackets
		beq.b		4$
		bra.b		1$

	;The end of the object
2$		subq.l	#1,a0
4$		move.l	a0,d0					;For flags
		rts

	;A string
3$		subq.l	#1,a0
		bsr		SkipString
		bra.b		1$

	;***
	;Get the next object (no skipspace done)
	;a0 = ptr to object
	;-> a0 = ptr after object
	;-> d0 = ptr to object (0, flags if error)
	;***
;GetObject:
;		movem.l	d1/d7/a1-a2,-(a7)
;		move.l	a0,d7
;		moveq		#0,d0
;		bsr		SkipObject
;MakeStringGO:
;		move.l	a0,d0
;		move.l	a0,a2
;		sub.l		d7,d0
;		addq.l	#1,d0
;		bsr		AllocBlockInt
;		beq.s		3$
;		move.l	d0,a1
;		move.l	d7,a0
;1$		cmp.l		a0,a2
;		beq.s		2$
;		move.b	(a0)+,(a1)+
;		bra.s		1$
;2$		move.l	a2,a0
;		movem.l	(a7)+,d1/d7/a1-a2
;		tst.l		d0
;		rts
;
;	;Handle error
;3$		moveq		#0,d0
;		bra.s		2$

	;***
	;Skip brackets
	;a0 = ptr to string '(','{','['
	;-> a0 = ptr after brackets (or 0, flags if error)
	;***
SkipBrackets:
		movem.l	d0-d1,-(a7)
		move.b	(a0)+,d1
		cmpi.b	#'(',d1
		beq.b		1$
		addq.b	#1,d1
1$		addq.b	#1,d1					;Make closing bracket
3$		move.b	(a0)+,d0
		beq.b		10$
		cmp.b		d0,d1
		beq.b		4$
		cmpi.b	#'(',d0
		beq.b		5$
		cmpi.b	#'{',d0
		beq.b		5$
		cmpi.b	#'[',d0
		beq.b		5$
		cmpi.b	#')',d0
		beq.b		6$
		cmpi.b	#'}',d0
		beq.b		6$
		cmpi.b	#']',d0
		beq.b		6$
		cmpi.b	#'\',d0
		bne.b		7$
		move.b	(a0)+,d0
		beq.b		10$
		bra.b		3$
7$		cmpi.b	#'''',d0
		beq.b		8$
		cmpi.b	#'"',d0
		beq.b		8$
		bra.b		3$
10$	subq.l	#1,a0
4$		move.l	a0,d0					;For flags
		movem.l	(a7)+,d0-d1
		rts
6$		SERR		BadBracket
		suba.l	a0,a0
		bra.b		4$
5$		subq.l	#1,a0
		bsr		SkipBrackets
		beq.b		4$						;Error ?
		bra.b		3$
8$		subq.l	#1,a0
		bsr		SkipString
		bra.b		3$

	;***
	;Goto end string
	;a0 = ptr to string
	;-> a0 = ptr after string
	;***
SkipString:
		movem.l	d0-d2,-(a7)
		move.b	(a0)+,d1
1$		move.b	(a0)+,d0
		beq.b		2$
		cmp.b		d0,d1
		beq.b		3$
		cmpi.b	#'·',d0
		bne.b		4$
	;Strong quote
		move.b	(a0)+,d0
5$		move.b	(a0)+,d2
		beq.b		2$
		cmp.b		d0,d2
		bne.b		5$
		bra.b		1$

4$		cmpi.b	#'\',d0
		bne.b		1$
		move.b	(a0)+,d0
		beq.b		2$
	;Check if it is a '('
		cmpi.b	#'(',d0
		bne.b		1$
		subq.l	#1,a0
		bsr		SkipBrackets
		bra.b		1$
2$		subq.l	#1,a0
3$		movem.l	(a7)+,d0-d2
		rts

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;Data for LongToDec
FormatStrLTDold:	dc.b	"%ld",0
FormatStrLTD:
		FF		lD,0,end,0

	;Variable names
StrVersion:		dc.b	"version",0
StrError:		dc.b	"error",0
StrRC:			dc.b	"rc",0
StrInput:		dc.b	"input",0
StrPv:			dc.b	"pv",0

	EVEN
	;***
	;Start of defined EvalBase
	;***
EvalBase:

ChangeSPSigNum:	dc.l	0
ChangeSPSigSet:	dc.l	0
VarMemBlock:	dc.l	0				;Ptr and length for variables
VarStorage:		dc.l	0
	;Format for variables in VarStorage:
	;	<Value or ptr>.L <Name Length>.B <Type>.B <Name> [<pad>.B] [<spec>.L]
	;Thus each entry is 6+<length>+[<pad>] bytes long
	;Type is 0 if variable, 1 if constant, 2 if special
	;if Type is 2 (special) there is a longword after the variable block
	;which points to a routine to call when this variable is changed

	;Table with levels for each operator (Evaluate)
HeightTableL:	dc.b	4,5,3,10,10,10,9,9,7,7,7,7,6,6,8,8,2,1
	;***
	;End of defined EvalBase
	;***

HeightTable:	dc.b	"^&|*/%+-><",'>'+172,'<'+172,'!'+172
					dc.b	'='+128,'<'+128,'>'+128,'&'+128,'|'+128

	EVEN
	;Routine list to jump at, depending on the type of the object
RoutParseEE:	dc.l	RP2Error,RP2HexInt,RP2DecInt,RP2String1,RP2Error
					dc.l	RP2MemType,RP2Unary,RP2Exp,RP2ListElem,RP2Name,RP2String2
					dc.l	RP2Eol,RP2SpecArg,RP2ListAddr,RP2Group,RP2LineNr

;FormatVars:		dc.b	"%-40.40s : %02x  %08lx , %-15.ld",0
FormatVars:
		FF		ls_,40,str_,":",bx,0,spc,2
		FF		X_,0
		dc.b	",",32
		FF		lD,15,end,0

	;Table to search for the type of an object
TypeTable:		dc.b	T_EOL,0,T_HEX,'$',T_HEX,'0'
					dc.b	T_STRING1,'"',T_STRING2,''''
					dc.b	T_MEMTYPE,'*',T_EXP,'(',T_UNARY,'-'
					dc.b	T_UNARY,'~',T_UNARY,'!',T_LINENR,'#',T_SPECARG,'@'
					dc.b	T_LISTELEM,':',T_LISTADDR,'&',T_GROUP,'{'

	EVEN
ComputeTableR:	dc.l	XorEVAL,AndEVAL,OrEVAL,MulEVAL,DivEVAL
					dc.l	ModEVAL,PlusEVAL,MinEVAL,GTEVAL,LTEVAL
					dc.l	GEEVAL,LEEVAL,NotEqualEVAL,EqualEVAL
					dc.l	LShiftEVAL,RShiftEVAL,AndlEVAL,OrlEVAL

ExactSearch:	dc.b	0				;If true then SearchWord will check everything

	END
