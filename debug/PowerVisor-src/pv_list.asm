*****
****
***			L I S T   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Wed Jul 27 09:03:26 1994
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

			INCLUDE	"pv.list.i"
			INCLUDE	"pv.debug.i"
			INCLUDE	"pv.general.i"
			INCLUDE	"pv.main.i"
			INCLUDE	"TileWindows.i"

			INCLUDE	"pv.errors.i"

	XDEF		ListConstructor,ListDestructor
	XDEF		RoutLWin,RoutPWin
	XDEF		RoutExec,RoutIntb,RoutTask,RoutLibs,RoutDevs,RoutReso,RoutMemr
	XDEF		RoutIntr,RoutPort,RoutWins,RoutScrs,RoutFont,RoutDosd,RoutFunc
	XDEF		RoutSema,RoutResm,RoutFils,RoutLock,RoutIHan,RoutFDFi,RoutAtta
	XDEF		RoutCrsh,RoutGraf,RoutDbug,RoutConf,RoutList,RoutInfo,FuncBase
	XDEF		GotoStartList,Prompt,Print1MsgPort,Print1Crashed,ListCurrent
	XDEF		GetItem,HeaderCrash,DbModesString,HeaderMsgPort,Print1Task
	XDEF		ListItem,Item,IOReqInfoList,GetNextListI,InfoBlocks
	XDEF		RoutGadgets,RoutLList,RoutAddStruct,RoutRemStruct
	XDEF		RoutInterprete,RoutStru,FuncPeek,FuncAPeek,SetList,ResetList
	XDEF		FuncCurList,RoutOwner,FuncStSize,StructDefs
	XDEF		RoutFor,RoutClearStructs,ListBase,FormatMemoryL
	XDEF		ApplyCommandOnList,PrintBitField,RoutStruct
 IFD	D20
	XDEF		RoutPubS,RoutMoni
 ENDC

	;screen
	XREF		PrintLine,PrintAC,Line
	XREF		SoftNewLine,myGlobal
	;main
	XREF		Dummy,Storage,ArpBase,ExpBase,DosBase,CheckModeBit
	XREF		HandlerStuff,IntBase,Gfxbase,KeyAttach
	XREF		ExecAlias,ErrorHandler,ScriptPath,PrintFor,PrintForQ
	XREF		Forbid,Permit,Disable,Enable,LastError,FastFPrint
	;eval
	XREF		GetStringE,GetString,SearchWord
	XREF		InitPrepHex,CopyCString,PrepareHex,PrepareHexW,PrepareHexB
	XREF		CompareCI,NameToItem,GetRestLinePer,GetNextByteE,ScanOptions
	XREF		Sort,LongToHex,WordToHex,ByteToHex
	;general
	XREF		Freezed,RealThisTask,OldSwitch,SizeLock,ConstructPath
	XREF		FunctionsMon,FDFiles,Crashes,AccountBlock
	;memory
	XREF		ClearVirtual,VPrint,PrintVirtualBuf,MakeNodeInt
	XREF		AllocBlockInt,FreeBlock,StoreRC,AppendMem,ReAllocMem
	XREF		ViewPrintLine,BlockSize,ReAllocMemBlock,ShrinkBlock
	XREF		AllocMem,FreeMem,ReAlloc
	;debug
	XREF		DebugList
	;file
	XREF		SearchPath,FOpen,FRead,FClose,OpenDos

;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Constructor: init everything for list
	;-> flags is eq if error
	;***
ListConstructor:
		lea		(StructDefs,pc),a0
		NEWLIST	a0

		bsr.b		AddStandardStructs

		moveq		#1,d0
		rts

	;***
	;Add all standard structures
	;***
AddStandardStructs:
		lea		(InfoBlocks,pc),a2
1$		movea.l	a2,a0
		bsr		GetStructDef
		beq.b		2$
		lea		(in_Arg,a0),a1
		movea.l	d0,a0
		bsr		MakeStruct
2$		lea		(in_SIZE,a2),a2
		lea		(InfoSent,pc),a3
		cmpa.l	a2,a3
		bne.b		1$

		lea		(NodeList,pc),a0
		lea		(NodeString,pc),a1
		bsr		MakeStruct
		lea		(WinInfoList,pc),a0
		lea		(WindowString,pc),a1
		bsr		MakeStruct
		lea		(ScrInfoList,pc),a0
		lea		(ScreenString,pc),a1
		bsr		MakeStruct
		lea		(ProcInfoList,pc),a0
		lea		(ProcString,pc),a1
		bsr		MakeStruct
		lea		(CliInfoList,pc),a0
		lea		(CliString,pc),a1
		bsr		MakeStruct
		lea		(TaskInfoList,pc),a0
		lea		(TasksString,pc),a1
		bsr		MakeStruct
		lea		(IOReqInfoList,pc),a0
		lea		(IOReqString,pc),a1
		bsr		MakeStruct
		lea		(ConfInfoList,pc),a0
		lea		(ConfigString,pc),a1
		bra		MakeStruct

	;***
	;Destructor: remove everything for list
	;***
ListDestructor:
*		bra.b		ClearAllStructs
		rts

	;***
	;Command: clear all structure definitions
	;***
RoutClearStructs:
		bsr.b		ClearAllStructs
		bra		AddStandardStructs

	;***
	;Clear all structure definitions
	;***
ClearAllStructs:
		lea		(StructDefs,pc),a2
		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		1$
		move.l	a2,d0
		bsr		RemStructDirect
		bra.b		ClearAllStructs
1$		rts

RoutExec:	subq.w	#1,d6
RoutIntb:	subq.w	#1,d6
RoutTask:	subq.w	#1,d6
RoutLibs:	subq.w	#1,d6
RoutDevs:	subq.w	#1,d6
RoutReso:	subq.w	#1,d6
RoutMemr:	subq.w	#1,d6
RoutIntr:	subq.w	#1,d6
RoutPort:	subq.w	#1,d6
RoutWins:	subq.w	#1,d6
RoutScrs:	subq.w	#1,d6
RoutFont:	subq.w	#1,d6
RoutDosd:	subq.w	#1,d6
RoutFunc:	subq.w	#1,d6
RoutSema:	subq.w	#1,d6
RoutResm:	subq.w	#1,d6
RoutFils:	subq.w	#1,d6
RoutLock:	subq.w	#1,d6
RoutIHan:	subq.w	#1,d6
RoutFDFi:	subq.w	#1,d6
RoutAtta:	subq.w	#1,d6
RoutCrsh:	subq.w	#1,d6
RoutGraf:	subq.w	#1,d6
RoutDbug:	subq.w	#1,d6
RoutStru:	subq.w	#1,d6
 IFD	D20
RoutPubS:	subq.w	#1,d6
RoutMoni:	subq.w	#1,d6
 ENDC
RoutConf:	subq.w	#1,d6
RoutLWin:	subq.w	#1,d6
RoutPWin:
		lea		(TItem,pc),a0
		clr.w		(a0)
		lea		(Item,pc),a0
		move.w	d6,(a0)
		subq.w	#2,d6
		mulu.w	#in_SIZE,d6
		lea		(InfoBlocks,pc),a0
		lea		(Prompt,pc),a1
		move.l	(in_Prompt,a0,d6.w),(a1)
		moveq		#mo_List,d0
		bsr		CheckModeBit
		bne		ListCurrent
		rts

	;***
	;Function: get ptr to current list string
	;***
FuncCurList:
		move.w	(Item,pc),d0
		subq.w	#2,d0
		mulu.w	#in_SIZE,d0
		lea		(InfoBlocks,pc),a0
		lea		(in_Arg,a0,d0.w),a0
		move.l	a0,d0
		rts

	;***
	;Command: Manage the fields of a structure
	;***
RoutStruct:
		bsr		GetNextByteE
		move.l	a0,-(a7)
		lea		(OptStructStr,pc),a0
		lea		(OptStructRout,pc),a1
		bsr		ScanOptions
		movea.l	(a7)+,a0
		jmp		(a1)

StructErrorST:
		ERROR		UnknownStructArg

	;***
	;Create a new empty structure
	;***
StructNewST:
		bsr		GetStringE			;Get name of structure
		movea.l	d0,a2
		EVALE								;Get size of structure
		move.l	d0,d2

		movea.l	a2,a0
		moveq		#str_SIZE,d0
		bsr		MakeNodeInt
		HERReq

		movea.l	a0,a3					;Remember ptr to node
		move.b	#NT_STRUCT,(LN_TYPE,a3)
		move.l	#'PVSD',(str_MatchWord,a3)
		movea.l	a2,a0
3$		tst.b		(a0)+
		bne.b		3$
		move.l	a2,d0
		sub.l		a0,d0
		move.b	d0,(LN_PRI,a3)

	;Allocate empty string pool
		moveq		#1,d0
		bsr		AllocBlockInt
		bne.b		1$

	;Error!
2$		suba.l	a4,a4
		bsr		CleanUpAddStruct
		ERROR		NotEnoughMemory

	;Success
1$		move.l	d0,(str_Strings,a3)
		movea.l	d0,a0
		clr.b		(a0)

	;Allocate empty entry pool
		moveq		#8,d0
		bsr		AllocBlockInt
		beq.b		2$

	;Success
		move.l	d0,(str_InfoBlock,a3)
		movea.l	d0,a0
		clr.l		(a0)+
		clr.l		(a0)

		move.w	d2,(str_Length,a3)

		movea.l	a3,a1
		lea		(StructDefs,pc),a0
		CALLEXEC	Enqueue
		rts

	;***
	;Add a new structure field to a structure
	;***
StructAddST:
		bsr		GetStructE
		EVALE								;Get new offset in structure
		move.l	d0,d2
		;@@@ Maybe a general system (like the structure system) to get
		;integers but support named constants
		EVALE								;Get type of offset
		move.l	d0,d5
	;Test for optional extra size
		moveq		#0,d6					;Assume no extra size needed
		cmp.b		#SEN_INLINESTR,d0
		beq.b		1$
		btst		#SENB_ARRAY,d5		;Test for array type
		beq.b		2$
	;Array or inline string: get extra size
1$		EVALE								;Get extra array or inline string size
		move.l	d0,d6

2$		bsr		GetStringE			;Get name of offset
		movea.l	d0,a2

	;a3 = StructInter
	;d2 = New offset
	;d5 = Type of offset
	;d6 = extra size (or 0 if not needed)
	;a2 = Name of offset

	;Reallocate the InfoBlock
ReallyAddSST:
		move.l	(str_Strings,a3),d0
		ERROReq	ReadOnlyStruct
		move.l	(str_InfoBlock,a3),d0
		ERROReq	BadStructure
		movea.l	d0,a4					;Remember pointer to block
		bsr		BlockSize			;Get size of this block
		move.l	d0,d4					;Remember this size
		subq.l	#sen_SIZE,d4		;Before 0 entry
		addq.l	#sen_SIZE,d0		;Add entry
		movea.l	a4,a1
		move.l	d0,d1
		bsr		ReAllocMemBlock
		move.l	d0,(str_InfoBlock,a3)

	;Check if the string already exists
	;WARNING! If two entries with the same name are created and one of
	;them is deleted later we can't remove the name. This does not matter
	;at the moment since we don't remove the name anyway
		movea.l	a3,a0					;Structure
		movea.l	a2,a1					;String
		bsr		SearchFieldName
		beq.b		5$
	;Yes, the string already exists
		movea.l	(str_Strings,a3),a4
		movea.l	d0,a1
		movea.l	(a1),a1				;Pointer to string
		bra.b		6$						;Skip reallocation and copying of string

	;Reallocate the strings
5$		move.l	(str_Strings,a3),d0
		movea.l	d0,a4					;Remember pointer to block
		bsr		BlockSize			;Get size of this block
		move.l	d0,d3					;Remember this size
		movea.l	a2,a0
1$		tst.b		(a0)+
		bne.b		1$
		move.l	a0,d1
		sub.l		a2,d1					;d1 = length+1
		add.l		d0,d1
		movea.l	a4,a1
		bsr		ReAllocMemBlock
		move.l	d0,(str_Strings,a3)

	;a3 = struct
	;a2 = name of offset
	;d2 = offset
	;d3 = offset in str_Strings space for new string
	;d4 = offset in str_InfoBlock for new entry
	;d5 = type of offset
	;d6 = size of array or inline string (if needed)
	;a4 = pointer to old str_Strings. We need this to relocate all strings
	;		in str_InfoBlock

	;Copy string
		movea.l	(str_Strings,a3),a0
		adda.l	d3,a0
		movea.l	a0,a1
2$		move.b	(a2)+,(a0)+
		bne.b		2$
	;Copy entry
6$		movea.l	(str_InfoBlock,a3),a0
		adda.l	d4,a0
		move.l	a1,(a0)+				;Pointer to string

		move.b	d5,(a0)+				;Type
		move.b	d6,(a0)+				;Extra size
		move.w	d2,(a0)+				;Offset
		clr.l		(a0)+					;NULL entry (last entry)
		clr.l		(a0)+

	;Relocate all stringpointers in str_InfoBlock
		move.l	(str_Strings,a3),d0
		sub.l		a4,d0					;d0 = offset to add to all stringpointers
		movea.l	(str_InfoBlock,a3),a0
		move.l	a0,d1
		add.l		d4,d1					;Pointer to new entry
3$		cmp.l		a0,d1
		ble.b		4$
		add.l		d0,(a0)+				;Adjust string pointer
		lea		(4,a0),a0
		bra.b		3$

4$		rts

	;***
	;Remove a structure field from a structure
	;***
StructRemST:
		bsr		GetStructE
		bsr		GetStringE			;Get name of offset
		movea.l	d0,a2

	;Search the offset
		move.l	(str_Strings,a3),d0
		ERROReq	ReadOnlyStruct
		move.l	(str_InfoBlock,a3),d0
		ERROReq	BadStructure
		movea.l	d0,a4

		movea.l	a3,a0
		movea.l	a2,a1
		bsr		SearchFieldName
		ERROReq	CantFindField

	;Move all other entries
		movea.l	d0,a0
3$		move.l	(8,a0),(a0)
		move.l	(12,a0),(4,a0)
		lea		(8,a0),a0
		tst.l		(a0)
		bne.b		3$

	;Shrink the block
		move.l	a4,d0
		bsr		BlockSize
		subq.l	#sen_SIZE,d0
		move.l	d0,d1
		movea.l	a4,a1
		bra		ShrinkBlock

	;***
	;Change the size for a structure
	;***
StructChangeSizeST:
		bsr		GetStructE
		EVALE								;Get new size of structure

		move.l	(str_Strings,a3),d1
		ERROReq	ReadOnlyStruct
		move.w	d0,(str_Length,a3)
		rts

	;***
	;Sort all fields in the structure
	;***
StructSortST:
		bsr		GetStructE
		move.l	(str_Strings,a3),d1
		ERROReq	ReadOnlyStruct

		movea.l	(str_InfoBlock,a3),a0
		movea.l	a0,a1
		moveq		#-1,d0
	;Count the number of infoblock entries
1$		addq.l	#1,d0
		lea		(sen_SIZE,a1),a1
		move.l	(-sen_SIZE,a1),d1
		bne.b		1$

		lea		(CmpInfoBlk,pc),a1
		moveq		#sen_SIZE,d1
		bra		Sort

	;Subroutine: compare two infoblock entries according to offset
	;a0 = ptr to first entry
	;a1 = ptr to second entry
	;-> d0 = -1, 0 or 1
CmpInfoBlk:
		move.w	(sen_Offset,a0),d0
		cmp.w		(sen_Offset,a1),d0
		blt.b		1$
		bgt.b		2$
		moveq		#0,d0
		rts

1$		moveq		#-1,d0
		rts

2$		moveq		#1,d0
		rts

	;***
	;List all fields in the structure
	;***
StructListST:
		bsr		GetStructE
		lea		(HeaderSField,pc),a0
		PRINT
		bsr		PrintLine

		movea.l	(str_InfoBlock,a3),a2
1$		tst.l		(a2)
		beq.b		2$

		lea		(FormatSField,pc),a0
		movea.l	a2,a1
		bsr		PrintFor
		PFBYTE	sen_Size
		PFBYTE	sen_Type
		PFWORD	sen_Offset
		PFLONG	sen_Name
		PFEND

		lea		(sen_SIZE,a2),a2
		bra.b		1$

2$		rts

	;***
	;Write a structure to a file
	;***
StructWriteST:
		bsr		GetStructE
		bsr		GetStringE			;Get filename
		move.l	d0,d1
		moveq		#MODE_NEWFILE-1000,d2
		moveq		#0,d4					;Don't seek one byte back
		bra.b		WriteStructST

	;***
	;Append a structure to a file
	;***
StructAppendST:
		bsr		GetStructE
		bsr		GetStringE			;Get filename
		move.l	d0,d1
		moveq		#MODE_OLDFILE-1000,d2
		moveq		#-1,d4				;Seek one byte back because we must overwrite
											;the 0 sentinel at the end of the file
WriteStructST:
		bsr		OpenDos
		movea.l	d0,a5
		ERROReq	OpenFile
		move.l	a5,d1
		move.l	d4,d2
		moveq		#OFFSET_END,d3
		CALL		Seek
		move.l	#'PVSD',-(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#4,d3
		CALL		Write					;Write PVSD header
		movea.l	(LN_NAME,a3),a0
		move.l	a0,d0
1$		tst.b		(a0)+
		bne.b		1$
		sub.l		a0,d0
		neg.l		d0
		move.b	d0,(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#1,d3
		CALL		Write					;Write length of string (name of struct) (1 byte)
		move.l	a5,d1
		move.l	(LN_NAME,a3),d2
		moveq		#0,d3
		move.b	(a7),d3
		CALL		Write					;Write name of struct
		move.l	(str_InfoBlock,a3),d0
		bsr		BlockSize
		move.l	d0,(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#4,d3
		CALLDOS	Write					;Write size of infoblock

	;Write the infoblock
	;Reallocate all pointers to strings first (change into offset)
		subq.l	#4,a7
		movea.l	(str_InfoBlock,a3),a2
		move.l	(str_Strings,a3),d4
		subq.l	#1,d4					;Offsets+1
2$		tst.l		(a2)
		beq.b		3$
		move.l	(a2)+,(a7)
		sub.l		d4,(a7)
		move.l	(a2)+,(4,a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#8,d3
		CALL		Write					;Write field from infoblock
		bra.b		2$

	;Write sentinel
3$		move.l	a5,d1
		move.l	a2,d2
		moveq		#8,d3
		CALL		Write					;Write sentinel

		move.w	(str_Length,a3),(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#2,d3
		CALL		Write					;Write length of structure
		move.l	(str_Strings,a3),d0
		bsr		BlockSize
		move.l	d0,(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#4,d3
		CALLDOS	Write					;Write size of stringblock
		move.l	a5,d1
		move.l	(str_Strings,a3),d2
		move.l	(a7),d3
		CALL		Write					;Write strings
		clr.b		(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#1,d3
		CALL		Write					;Write 0 sentinel for end of file
		move.l	a5,d1
		CALL		Close
		lea		(8,a7),a7
		rts

	;***
	;Get a structure from the commandline
	;This function does not return if error
	;a0 = cmdline
	;-> d0 = structure
	;-> a3 = structure
	;***
GetStructE:
		moveq		#I_STRUCT,d6
		bsr		SetList
		EVALE								;Get ptr to structure definition
		movea.l	d0,a3
		cmpi.l	#'PVSD',(str_MatchWord,a3)
		ERRORne	NotAStructDef
		bra		ResetList

	;***
	;Search a fieldname in a structure
	;Note! This subroutine does not support the []
	;notation for arrays (nor does it need to). It only
	;searches for the named StructEntry structure
	;a0 = pointer to structure
	;a1 = pointer to string
	;-> d0 = pointer to found entry or null (flags)
	;***
SearchFieldName:
		movem.l	a2-a3,-(a7)
		movea.l	(str_InfoBlock,a0),a0

1$		lea		(8,a0),a0
		move.l	(-8,a0),d0
		beq.b		3$
		movea.l	d0,a2
		movea.l	a1,a3
	;Compare the two strings
2$		move.b	(a2),d0
		cmp.b		(a3)+,d0
		bne.b		1$
		lea		(1,a2),a2
		tst.b		d0
		bne.b		2$
	;Found
		subq.l	#8,a0
		move.l	a0,d0
		bra.b		4$

	;Not found
3$		moveq		#0,d0
4$		movem.l	(a7)+,a2-a3
		rts

	;***
	;Command: Add a structure definition
	;***
RoutAddStruct:
		subq.l	#8,a7					;Room on stack
		suba.l	a3,a3
		suba.l	a4,a4
		bsr		GetStringE			;Get filename
		movea.l	d0,a0
		lea		(ScriptPath),a1
		bsr		SearchPath
		ERROReq	OpenFile
		move.l	d0,d1
		movea.l	d0,a3					;Remember filename
		bsr		FOpen
		movea.l	d0,a4					;Remember file ptr
		movea.l	a3,a0
		bsr		FreeBlock
		move.l	a4,d0
		ERROReq	OpenFile
	;Read next structure
7$		move.l	a7,d2					;Stack room
		bsr		ReadRAS4
		subq.l	#4,d0
		bne		6$						;End of file
		cmpi.l	#'PVSD',(a7)
		beq.b		1$
	;!!! Not a structure definition file
		bsr		CleanUpAddStruct
		ERROR		BadFileFormat
	;Allright
1$		clr.l		(4,a7)
		move.l	a7,d2
		addq.l	#7,d2
		moveq		#1,d3
		bsr		ReadRAS				;Read string length (including NULL)
		move.l	(Storage),d2
		move.l	(4,a7),d3
		bsr		ReadRAS				;Read NULL-terminated string
		move.l	a7,d2
		bsr		ReadRAS4				;Read length of InfoBlock
		moveq		#str_SIZE,d0
		movea.l	(Storage),a0
		bsr		MakeNodeInt
		bne.b		2$
	;!!! Not enough memory for node
3$		bsr		CleanUpAddStruct
		HERR
	;Allright
2$		movea.l	a0,a3					;Remember ptr to node
		move.b	#NT_STRUCT,(LN_TYPE,a3)
		move.l	#'PVSD',(str_MatchWord,a3)
		move.l	(4,a7),d0			;Get string size
		neg.l		d0
		move.b	d0,(LN_PRI,a3)
		move.l	(a7),d0				;Get size of InfoBlock
		bsr		AllocBlockInt
		beq.b		3$
		move.l	d0,(str_InfoBlock,a3)
		move.l	d0,d2
		move.l	(a7),d3
		bsr		ReadRAS				;Read InfoBlock
		move.l	a7,d2
		moveq		#2,d3
		bsr		ReadRAS				;Read length of structure
		move.w	(a7),(str_Length,a3)
		move.l	a7,d2
		bsr		ReadRAS4				;Read Strings length
		move.l	(a7),d0
		bsr		AllocBlockInt
		beq.b		3$
		move.l	d0,(str_Strings,a3)
		move.l	d0,d2
		move.l	(a7),d3
		bsr		ReadRAS				;Read strings
	;Start interpretation of strings
		movea.l	(str_InfoBlock,a3),a0
		movea.l	(str_Strings,a3),a1
4$		tst.l		(a0)
		beq.b		5$
		move.l	(a0),d0
		lea		(-1,a1,d0.l),a2
		move.l	a2,(a0)
		lea		(8,a0),a0
		bra.b		4$
5$		movea.l	a3,a1
		lea		(StructDefs,pc),a0
		CALLEXEC	Enqueue
		movea.l	(LN_NAME,a3),a0
		bsr		PrintAC
		NEWLINE
		suba.l	a3,a3
		bra		7$						;Load next structure
6$		lea		(8,a7),a7			;Fall through to CleanUpAddStruct

	;Subroutine: Clear the Struct Node
	;a3=node
	;a4=file
CleanUpAddStruct:
		move.l	a4,d1
		bsr		FClose
		move.l	a3,d0
		beq.b		2$
		move.l	(LN_NAME,a3),d0
		beq.b		3$
		movea.l	d0,a0
		bsr		FreeBlock
3$		move.b	(LN_TYPE,a3),d0
		cmp.b		#NT_STRUCT2,d0		;Don't free special infoblock structure
		beq.b		5$
		move.l	(str_InfoBlock,a3),d0
		beq.b		4$
		movea.l	d0,a0
		bsr		FreeBlock
4$		move.l	(str_Strings,a3),d0
		beq.b		5$
		movea.l	d0,a0
		bsr		FreeBlock
5$		moveq		#str_SIZE,d0
		movea.l	a3,a1
		bsr		FreeMem
2$		rts

	;Read something
	;a4 = filehandle
	;d2 = buffer
	;d3 = len
	;-> d0 = read len
ReadRAS4:
		moveq		#4,d3
ReadRAS:
		move.l	a4,d1
		bra		FRead

	;***
	;Command: Remove a structure definition
	;***
RoutRemStruct:
		bsr		GetStructE
RemStructDirect:
		movea.l	d0,a3
		suba.l	a4,a4					;Clear file ptr
		movea.l	a3,a1
		CALLEXEC	Remove
		bra.b		CleanUpAddStruct

	;***
	;Get the structure definition from an info block (like 'Exec', 'LWin', ...)
	;a0 = pointer to info block
	;-> d0 = pointer to structure definition (or 0, flags if not available)
	;-> a0 remained the same
	;***
GetStructDef:
	;Get the pointer to the info list
		move.b	(in_Control,a0),d0
		cmp.b		#-2,d0
		bne.b		2$
	;'Exec', 'Intb', 'Graf', ...
		move.l	(in_InfoList,a0),d0
		bra.b		1$
2$		moveq		#0,d0
		move.b	(in_IsList,a0),d0
		beq.b		1$
	;There could be an info list for this list type
		move.l	(in_Info,a0),d0
1$		rts

	;***
	;Make a structure definition node from a structure definition
	;a0 = pointer to structure definition. This routine asumes that
	;		this is a pointer AFTER the size of the structure
	;a1 = pointer to name ('_' is added)
	;-> d0 = structure definition node or 0 if error (flags)
	;***
MakeStruct:
		movem.l	a2-a3/d2,-(a7)
		movea.l	a0,a2					;Remember pointer to structure definition
		suba.l	a3,a3

		moveq		#str_SIZE,d0
		movea.l	(Storage),a0
		move.b	#'_',(a0)+
		moveq		#1,d2
2$		addq.w	#1,d2
		move.b	(a1)+,(a0)+
		bne.b		2$
		movea.l	(Storage),a0
		bsr		MakeNodeInt
		beq.b		1$						;Not enough memory!
		movea.l	a0,a3					;Remember ptr to node
		move.b	#NT_STRUCT2,(LN_TYPE,a3)
		move.l	#'PVSD',(str_MatchWord,a3)
		neg.l		d2						;Negative of stringsize (for Enqueue)
		move.b	d2,(LN_PRI,a3)
		move.l	a2,(str_InfoBlock,a3)
		move.l	(-4,a2),d0
		move.w	d0,(str_Length,a3)

		movea.l	a3,a1
		lea		(StructDefs,pc),a0
		CALLEXEC	Enqueue

1$		move.l	a3,d0					;For flags and result
		movem.l	(a7)+,a2-a3/d2
		rts

	;***
	;Command: Interprete a memory block using an structure definition
	;***
RoutInterprete:
		EVALE								;Get ptr to memory block
		movea.l	d0,a2
		bsr		GetStructE
		movea.l	(str_InfoBlock,a3),a0
		bra		ListItem

	;***
	;Command: list all gadgets for a window
	;a0 = cmdline
	;d0 = next arg type
	;***
RoutGadgets:
		moveq		#I_WINDOW,d6
		bsr		SetList
		EVALE								;Get window
		movea.l	d0,a2
		lea		(HeaderGadget,pc),a0
		PRINT
		movea.l	(wd_FirstGadget,a2),a3
		bra		2$
1$		NEWLINE

		lea		(FormatGadget,pc),a0
		movea.l	a3,a1
		bsr		PrintFor
		PFWORD	gg_GadgetID
		PFLONG	gg_SpecialInfo
		PFLONG	gg_GadgetText
		PFLONG	gg_GadgetRender
		PFWORD	gg_Height
		PFWORD	gg_Width
		PFWORD	gg_TopEdge
		PFWORD	gg_LeftEdge
		PFSTRUCT
		PFEND

		lea		(Hgg_Flags2,pc),a0
		PRINT
		lea		(bfGadgetFlags,pc),a0
		move.w	(gg_Flags,a3),d0
		bsr		PrintBitField
		lea		(Hgg_Activation2,pc),a0
		PRINT
		lea		(bfGadgetActiv,pc),a0
		move.w	(gg_Activation,a3),d0
		bsr		PrintBitField
		lea		(Hgg_GadgetType2,pc),a0
		PRINT
		lea		(bfGadgetType,pc),a0
		move.w	(gg_GadgetType,a3),d0
		bsr		PrintBitField
		movea.l	(a3),a3
2$		move.l	a3,d0
		bne		1$
		rts

	;***
	;Command: list the current or specified list
	;a0 = cmdline
	;d0 = next arg type
	;***
RoutList:
		tst.l		d0						;End of line
		bne		ListItems
		bra		ListCurrent

	;***
	;Command: follow the given list
	;***
RoutLList:
		EVALE								;Get ptr to list
		movea.l	d0,a2
		NEXTTYPE
		beq.b		1$
	;Goto start list first
2$		tst.l		(LN_PRED,a2)
		beq.b		1$
		movea.l	(LN_PRED,a2),a2
		bra.b		2$
1$		lea		(InfoNode,pc),a3
		move.l	a2,(in_Base,a3)
		bra		ContListIT

	;***
	;Command: give information for a node or system structure
	;a0 = cmdline
	;***
RoutInfo:
		EVALE								;Get ptr
		movea.l	d0,a2
		NEXTTYPE
		bne.b		2$
	;Interprete as current item
		move.w	(Item,pc),d0
		subq.w	#2,d0
		mulu.w	#in_SIZE,d0
		lea		(InfoBlocks,pc),a1
		lea		(0,a1,d0.w),a1
		move.l	(in_Info,a1),d0
		bra.b		1$
	;The user forced an interpretation
2$		bsr		GetStringE
		lea		(InfoBlocks,pc),a1
		movea.l	d0,a0
		lea		(GetNextListI,pc),a5
		bsr		SearchWord			;Get ptr to list element in d1
		tst.l		d1
		ERROReq	UnknownListElement
		movea.l	d1,a1
		move.l	(in_Info,a1),d0
1$		bne.b		4$
	;in_Info = 0
		tst.b		(in_IsList,a1)
		ERROReq	BadListType
		bra.b		PrintHeader
	;in_Info <> 0
4$		movea.l	d0,a0
		bsr.b		PrintHeader
		tst.b		(in_IsList,a1)
		beq.b		3$
		NEWLINE
		bra		ListItem
3$		jmp		(a0)

	;***
	;Print header and one line of information
	;a1 = ptr to listelement
	;a2 = ptr to structure
	;***
PrintHeader:
		movem.l	a0-a1,-(a7)
		movea.l	(in_Header,a1),a0
		PRINT
		bsr		PrintLine
		movea.l	(in_PrintLine,a1),a0
		jsr		(a0)
		movem.l	(a7)+,a0-a1
		rts

	;***
	;Function: Get length of a structure
	;-> d0 = value
	;***
FuncStSize:
		bsr		GetStructE
		moveq		#0,d0
		move.w	(str_Length,a3),d0
		rts

	;***
	;Function: Look at a specific value in a structure
	;-> d0 = value
	;***
FuncPeek:
		EVALE								;Get ptr to memory block
		movea.l	d0,a2
		bsr		GetStructE
		bsr		GetStringE			;Get ptr to field string
		movea.l	d0,a1
		movea.l	(str_InfoBlock,a3),a0
		bsr		GetItem
		ERROReq	UnknownListElement
		rts

	;***
	;Function: Get address
	;-> d0 = address
	;***
FuncAPeek:
		EVALE								;Get ptr to memory block
		movea.l	d0,a2
		bsr		GetStructE
		bsr		GetStringE			;Get ptr to field string
		movea.l	d0,a1
		movea.l	(str_InfoBlock,a3),a0
		bsr		GetItem
		ERROReq	UnknownListElement
		move.l	a0,d0
		rts

	;***
	;Function: get the base of the current list
	;-> d0 = base
	;***
FuncBase:
		move.w	(Item,pc),d0
		subq.w	#2,d0
		mulu.w	#in_SIZE,d0
		lea		(InfoBlocks,pc),a3
		lea		(0,a3,d0.w),a3
		cmpi.b	#-2,(in_Control,a3)
		beq.b		2$
		bsr		GotoStartList
		move.l	(in_Next,a3),d0
		beq.b		1$
		movea.l	d0,a0
		moveq		#0,d7					;Var free to use
		jsr		(a0)
1$		move.l	a2,d0
		rts
2$		move.l	(in_Base,a3),d0
		rts

	;***
	;GetNext routine for info block
	;***
GetNextListI:
		moveq		#1,d6
		lea		(in_Arg,a1),a3
		tst.l		(a1)
		beq.b		1$
		lea		(in_SIZE,a1),a1
		rts
1$		suba.l	a1,a1
		rts

	;***
	;Command: search the owner of an address
	;***
RoutOwner:
		EVALE								;Get address
		move.l	d0,d6
		bsr		ClearVirtual
		bsr		Disable
		lea		(InfoTask,pc),a3
		bsr		GotoStartList
		moveq		#0,d7

		move.b	#1,(VPrint)

		bsr		InfNextTask
		beq		22$

	;Check TCB
1$		cmp.l		a2,d6
		blt.b		2$
		lea		(TC_SIZE,a2),a0
		cmp.l		a0,d6
		bge.b		2$
	;Found in TCB !
		lea		(MsgFoundInTCB,pc),a0
		bra		20$

	;Check extended task structure
2$		move.b	(TC_FLAGS,a2),d0
		andi.b	#TF_ETASK,d0
		beq.b		3$
		movea.l	(tc_ETask,a2),a0
		cmp.l		a0,d6
		blt.b		3$
		lea		(ETask_SIZEOF,a0),a0
		cmp.l		a0,d6
		bge.b		3$
	;Found in ETCB !
		lea		(MsgFoundInETCB,pc),a0
		bra		20$

	;Check stack
3$		movea.l	(TC_SPLOWER,a2),a0
		cmp.l		a0,d6
		blt.b		4$
		movea.l	(TC_SPUPPER,a2),a0
		cmp.l		a0,d6
		bge.b		4$
	;Found in stack !
		lea		(MsgFoundInStack,pc),a0
		bra		20$

	;Check mementries
4$		movea.l	(TC_MEMENTRY,a2),a3
5$		tst.l		(a3)					;Succ
		beq.b		9$
		cmp.l		a3,d6
		blt.b		6$
		move.w	(ML_NUMENTRIES,a3),d0
		lsl.w		#3,d0
		addi.w	#LN_SIZE+2,d0
		lea		(0,a3,d0.w),a0
		cmp.l		a0,d6
		bge.b		6$
	;Found in mementry structure !
		lea		(MsgFoundInMemEStruct,pc),a0
		bra		20$
	;Check if in mementry memory
6$		lea		(ML_ME,a3),a1
		move.w	(ML_NUMENTRIES,a3),d0
		bra.b		8$						;If d0=0 loop will end

7$		movea.l	(a1)+,a0				;Address
		move.l	(a1)+,d1				;Size
		cmp.l		a0,d6
		blt.b		8$
		lea		(0,a0,d1.l),a0
		cmp.l		a0,d6
		bge.b		8$
	;Found in mementry memory !
		lea		(MsgFoundInMemEMem,pc),a0
		bra		20$
8$		dbra		d0,7$

	;Next mementry structure
		movea.l	(a3),a3				;Succ
		bra.b		5$

	;Process ?
9$		cmpi.b	#NT_PROCESS,(LN_TYPE,a2)
		bne		17$

	;Check if pointer is in process
		cmp.l		a2,d6
		blt.b		10$
 IFD	D20
		lea		(pr_SIZEOF,a2),a0
 ENDC
 IFND	D20
		lea		(pr_HomeDir,a2),a0
 ENDC
		cmp.l		a0,d6
		bge.b		10$
	;Found in process !
		lea		(MsgFoundInProcess,pc),a0
		bra		20$

	;Check seglist
10$	movea.l	(pr_SegList,a2),a3
		adda.l	a3,a3
		adda.l	a3,a3
		move.l	(12,a3),d0
11$	lsl.l		#2,d0					;BPTR->APTR
		beq.b		13$
		cmpi.l	#$00d00000,d0		;Bad memory
		blt.b		23$
		cmpi.l	#$00ffffff,d0
		ble.b		13$
	;Allright
23$	movea.l	d0,a3
		lea		(-4,a3),a0
		cmp.l		a0,d6
		blt.b		12$
		move.l	(a0),d0				;Get size of seglist
		lea		(0,a0,d0.l),a0
		cmp.l		a0,d6
		bge.b		12$
	;Found in seglist !
		lea		(MsgFoundInSegList,pc),a0
		bra.b		20$
12$	move.l	(a3),d0
		bra.b		11$

	;Check cli
13$	move.l	(pr_CLI,a2),d0
		beq.b		17$
		lsl.l		#2,d0
		movea.l	d0,a3
		cmp.l		a3,d6
		blt.b		14$
		lea		(cli_SIZEOF,a3),a0
		cmp.l		a0,d6
		bge.b		14$
	;Found in cli !
		lea		(MsgFoundInCli,pc),a0
		bra.b		20$

	;Check if in cli_Module
14$	move.l	(cli_Module,a3),d0
		beq.b		17$
15$	lsl.l		#2,d0					;BPTR->APTR
		beq.b		17$
		movea.l	d0,a3
		lea		(-4,a3),a0
		cmp.l		a0,d6
		blt.b		16$
		move.l	(a0),d0				;Get size of seglist
		lea		(0,a0,d0.l),a0
		cmp.l		a0,d6
		bge.b		16$
	;Found in seglist !
		lea		(MsgFoundInModule,pc),a0
		bra.b		20$
16$	move.l	(a3),d0
		bra.b		15$

	;End check
17$	bra.b		21$

	;Found it !
20$	PRINT
		NEWLINE
		bsr		Print1Task
		NEWLINE
	;Not found
21$	bsr		InfNextTask
		bne		1$
22$	clr.b		(VPrint)
		bsr		Enable
		bsr		PrintVirtualBuf
		bra		ClearVirtual

	;All following routines are needed to go to a next listelement
	;They must preserve a0 and a1
	;d7 is free to use and will not change outside this functions
	;a2 = ptr to current list element
	;-> a2 = ptr to next (flags)

	;***
	;Go to next task, d7 (free var) is used to determine in which list
	;we are
	;***
InfNextTask:
		cmpi.b	#3,d7
		beq.b		5$
		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		bne.b		1$
	;Goto a new list
		tst.l		d7
		beq.b		2$
		cmpi.b	#1,d7
		beq.b		3$
		cmpi.b	#2,d7
		beq.b		4$
	;End list
5$		suba.l	a2,a2
1$		move.l	a2,d0					;Set flags
		rts
	;Goto waitlist
2$		moveq		#1,d7
		movea.l	(SysBase).w,a2
		lea		(TaskWait,a2),a2
		bra.b		InfNextTask
	;Goto frozen list
3$		moveq		#2,d7
		lea		(Freezed),a2
		bra.b		InfNextTask
	;Show running task
4$		moveq		#3,d7
		movea.l	(SysBase).w,a2
		movea.l	(ThisTask,a2),a2
		bra.b		1$

	;***
	;Go to the next node
	;***
InfNextNode:
		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		bne.b		1$
		suba.l	a2,a2
1$		move.l	a2,d0
		rts

	;***
	;Go to the next LW
	;***
InfNextLW:
		tst.l		d7
		beq.b		1$
	;Get next LW
		move.l	a0,-(a7)
		movea.l	(a2),a0				;Succ
		move.l	a0,d0
		tst.l		(a0)					;Succ
		movea.l	(a7)+,a0				;For flags
		beq.b		3$
		movea.l	d0,a2
2$		rts
	;Get next PW
1$		moveq		#1,d7
		bsr		InfNextNode
		beq.b		2$
		move.l	a0,-(a7)
		movea.l	(PhysWin_LWList,a2),a0
		move.l	a0,d0
		tst.l		(a0)					;Succ
		movea.l	(a7)+,a0				;For flags
		beq.b		1$
		movea.l	d0,a2
		rts
3$		movea.l	(LogWin_PhysWin,a2),a2
		bra.b		1$

	;***
	;Go to the next screen
	;***
InfNextScreen:
		movea.l	(sc_NextScreen,a2),a2
		move.l	a2,d0
		rts

	;***
	;Go to the next window
	;***
InfNextWindow:
		tst.l		d7
		beq.b		1$
	;Get next window
		move.l	(wd_NextWindow,a2),d0
		beq.b		3$
		movea.l	d0,a2
2$		rts
	;Get next screen
1$		moveq		#1,d7
		movea.l	(sc_NextScreen,a2),a2
		move.l	a2,d0
		beq.b		2$
		move.l	(sc_FirstWindow,a2),d0
		beq.b		1$
		movea.l	d0,a2
		rts
3$		movea.l	(wd_WScreen,a2),a2
		bra.b		1$

	;***
	;Go to the next resident module
	;***
InfNextResm:
		tst.l		d7
		beq.b		1$
2$		movea.l	d7,a6
		addq.l	#4,d7
		movea.l	(a6),a2
		move.l	a2,d0
		rts
1$		move.l	a2,d7
		bra.b		2$

	;***
	;Go to the next dos device
	;***
InfNextDosd:
		movea.l	(dl_Next,a2),a2
		adda.l	a2,a2
		adda.l	a2,a2
		move.l	a2,d0
		rts

	;***
	;Go to the next autoconfig
	;***
InfNextConfig:
		movem.l	a0-a1,-(a7)
		moveq		#-1,d0
		move.l	d0,d1
		movea.l	a2,a0
		movea.l	(ExpBase),a6
		jsr		(_LVOFindConfigDev,a6)
		movea.l	d0,a2
		tst.l		d0
		movem.l	(a7)+,a0-a1
		rts

	;All following routines are needed to go to the base of a list
	;They return a value in a2 (and d7 if needed)

 IFD	D20
	;***
	;Go to start public screens
	;***
InfRoutPubScr:
		CALLINT	LockPubScreenList
		movea.l	d0,a2
		CALL		UnlockPubScreenList
		rts
 ENDC

	;***
	;Go to start dos devices
	;***
InfRoutDosd:
		movea.l	(DosBase),a2
		movea.l	(dl_Root,a2),a2
		movea.l	(rn_Info,a2),a2
		adda.l	a2,a2
		adda.l	a2,a2
		lea		(di_DevInfo,a2),a2
		rts

	;***
	;Go to start input handlers
	;***
InfRoutInputH:
		lea		(HandlerStuff),a2
1$		tst.l		(LN_PRED,a2)
		beq.b		2$
		movea.l	(LN_PRED,a2),a2
		bra.b		1$
2$		rts

	;***
	;Go to start files/locks
	;and continue the listing
	;***
InfRoutFile:
		lea		(Print1File,pc),a5
		bra.b		ContRoutALocks

InfRoutLock:
		lea		(Print1Lock,pc),a5

ContRoutALocks:
		movea.l	(RealThisTask),a0
		lea		(WindowPtr,pc),a1
		move.l	(pr_WindowPtr,a0),(a1)
		moveq		#-1,d0
		move.l	d0,(pr_WindowPtr,a0)
		movea.l	(DosBase),a6
		movea.l	(dl_Root,a6),a0
		movea.l	(rn_Info,a0),a0
		adda.l	a0,a0
		adda.l	a0,a0					;BPTR->APTR
		movea.l	(di_DevInfo,a0),a0
		adda.l	a0,a0
		adda.l	a0,a0					;Ptr to DevList
		moveq		#0,d7

LoopListFIL:
		move.l	a0,d0
		beq		EndLoopFIL
		move.l	(dl_Type,a0),d0
		subq.l	#DLT_VOLUME,d0
		bne		NextLoopFIL
		move.l	(dl_Name,a0),d0
		lsl.l		#2,d0					;BPTR->APTR
		movea.l	d0,a1
		moveq		#0,d0
		move.b	(a1)+,d0				;Get length in d0
		subq.l	#1,d0
		move.l	a1,(Dummy)			;Remember position for name
		movea.l	(Storage),a2

	;Copy name so we can make a lock
1$		move.b	(a1)+,(a2)+
		dbra		d0,1$

		move.b	#':',(a2)+
		clr.b		(a2)+
		move.l	a0,-(a7)
		move.l	(Storage),d1
		moveq		#-2,d2				;Access mode
		CALLDOS	Lock
		movea.l	d0,a2
		adda.l	a2,a2
		adda.l	a2,a2
		movea.l	(fl_Link,a2),a2		;Skip this lock because we made it ourselves
		adda.l	a2,a2
		adda.l	a2,a2
		tst.l		d0
		bne.b		SuccessFIL			;The lock succeeded

	;Say the device is not mounted
		lea		(FormatNotMnt,pc),a0
		move.l	(Dummy),-(a7)
		bsr		SPrintIt
		lea		(4,a7),a7
		bra.b		EndLoop2FIL

	;Scan all locks for this volume
SuccessFIL:
		move.l	d0,d1
		CALLDOS	UnLock
1$		cmpa.l	#50,a2
		ble.b		EndLoop2FIL
		lea		(LockListBlock,pc),a0
		moveq		#4,d1
		bsr		AppendMem
		bne.b		2$

	;Out of memory, stop listing
		movea.l	(a7)+,a0
		bra.b		EndLoopFIL

	;Everything is fine
2$		movea.l	(LockListPtr,pc),a0
		adda.l	(LockListBlock,pc),a0
		move.l	a2,(-4,a0)
		movea.l	(fl_Link,a2),a2
		adda.l	a2,a2
		adda.l	a2,a2
		bra.b		1$

EndLoop2FIL:
		movea.l	(a7)+,a0

NextLoopFIL:
		movea.l	(dl_Next,a0),a0
		adda.l	a0,a0
		adda.l	a0,a0
		bra		LoopListFIL

	;Now we really start the listing
	;Until now we only collected all the locks in the devicelists
	;These locks are now present in a memory list (ReAllocMem format)
	;We must do everything in this manner because the RAM disk moves
	;all the locks that are used to the front of the list. Therefor
	;we can not rely on the links to be valid when we do things like
	;'Examine' with the lock.
EndLoopFIL:
		move.l	(LockListBlock,pc),d4
		lsr.l		#2,d4					;d3 = nr of locks in list
		movea.l	(LockListPtr,pc),a4
1$		tst.l		d4
		beq.b		2$
		movea.l	(a4)+,a2
		bsr		ErrorHandler
		beq.b		3$

	;No interruption
		subq.l	#1,d4
		bra.b		1$

	;No interruption, end of the list
2$		lea		(LockListBlock,pc),a0
		moveq		#0,d0
		bsr		ReAllocMem
		movea.l	(RealThisTask),a0
		move.l	(WindowPtr,pc),(pr_WindowPtr,a0)
		rts

	;Interruption
3$		bsr.b		2$
		HERR

	;All the following Print1... functions get in a2 the pointer
	;to the structure or node

	;***
	;Print, MUST be called with 'bsr' !
	;parameters for FastFPrint on stack
	;a0 = format string
	;***
SPrintIt:
		move.l	(Storage),d0
SPrintIt2:
		lea		(4,a7),a1
		bsr		FastFPrint
PrintIt:
	;Delete all returns, linefeeds and special characters
		movea.l	(Storage),a0
		moveq		#79,d0
1$		move.b	(a0)+,d1
		beq.b		3$
		cmpi.b	#10,d1
		beq.b		2$
		cmpi.b	#4,d1
		bls.b		2$
		cmpi.b	#13,d1
		bne.b		3$
2$		move.b	#' ',(-1,a0)
3$		dbra		d0,1$
		bsr		ViewPrintLine
		NEWLINE
		rts

	;***
	;Show one line of node information
	;***
Print1Node:
		bsr		PrintNNP
		bra.b		PrintIt

	;***
	;Show one line of task node information (same for process)
	;***
Print1Process:
Print1Task:
		bsr		PrintNNP
		lea		(-24,a7),a7
		movea.l	a7,a1
		move.l	a0,-(a7)
		move.l	(TC_SPUPPER,a2),d0
		sub.l		(TC_SPREG,a2),d0
		move.l	d0,(a1)				;Stack usage
		move.l	(TC_SPUPPER,a2),d0
		sub.l		(TC_SPLOWER,a2),d0
		move.l	d0,(4,a1)			;Stack size
		moveq		#0,d0
		move.b	(TC_STATE,a2),d0
		lsl.l		#2,d0
		lea		(TaskStates,pc),a0
		add.l		a0,d0
		move.l	d0,(8,a1)
		clr.l		(12,a1)
		lea		(TaskString,pc),a0
		move.l	a0,(16,a1)
		cmpi.b	#NT_TASK,(LN_TYPE,a2)
		beq.b		1$
		lea		(ProcessString,pc),a0
		move.l	a0,(16,a1)
		move.l	(pr_CLI,a2),d0
		beq.b		1$
		lsl.l		#2,d0					;BPTR->CPTR
		movea.l	d0,a0
		movea.l	(cli_CommandName,a0),a0
		adda.l	a0,a0
		adda.l	a0,a0
		lea		(1,a0),a0			;Skip length
		move.l	a0,(12,a1)
;	move.l	(cli_CommandName,a0),(12,a1)
		move.l	#Dummy,(16,a1)
		move.l	(pr_TaskNum,a2),d0
		lea		(Dummy+1),a0
		move.b	#'(',(Dummy)
		bsr		ByteToHex
		move.b	#')',(Dummy+3)
1$		lea		(FormatTask2,pc),a0
		move.b	#'-',(a0)+
		clr.b		(a0)
		tst.l		(OldSwitch)
		beq.b		2$
	;Get percentage
		move.l	a0,-(a7)
		movea.l	(AccountBlock),a0
		moveq		#63,d0				;64 tasks maximum
3$		cmpa.l	(a0)+,a2
		beq.b		4$
		lea		(4,a0),a0
		dbra		d0,3$
	;Not found !
		movea.l	(a7)+,a0
		bra.b		2$
	;Found !
4$		move.l	(a0),(20,a1)			;Get percentage
		movea.l	(a7)+,a0
		move.b	#'%',(-1,a0)
		move.b	#'f',(a0)+
		move.b	#5,(a0)
2$		lea		(FormatTask,pc),a0
		move.l	(a7)+,d0
		bsr		SPrintIt2
		lea		(24,a7),a7
		rts

	;***
	;Show one line of interrupt node information
	;***
Print1Interrupt:
		bsr		PrintNNP
		lea		(FormatInterr,pc),a0
		bsr		PrintForQ
		PFLONG	IS_CODE
		PFLONG	IS_DATA
		PFEND
		bra		PrintIt

	;***
	;Show one line of configdev information
	;***
Print1Config:
		bsr		PrintNNP
		lea		(FormatConfig,pc),a0
		bsr		PrintForQ
		PFLONG	cd_Driver
		PFLONG	cd_BoardSize
		PFLONG	cd_BoardAddr
		PFBYTE	cd_Flags
		PFEND
		bra		PrintIt

	;***
	;Show one line of device node information (same for Resource and Library)
	;***
Print1Resource:
Print1Library:
Print1Device:
		bsr		PrintNNP
		lea		(FormatDevice,pc),a0
		bsr		PrintForQ
		PFWORD	LIB_OPENCNT
		PFLONG	LIB_SUM
		PFWORD	LIB_POSSIZE
		PFWORD	LIB_NEGSIZE
		PFEND
		bra		PrintIt

	;***
	;Show one line of MsgPort node information
	;***
Print1MsgPort:
		bsr		PrintNNP
		lea		(FormatMsgPort,pc),a0
		bsr		PrintForQ
		PFLONG	MP_SIGTASK
		PFBYTE	MP_SIGBIT
		PFEND
		bra		PrintIt

	;***
	;Show one line of memory node information
	;***
Print1Memory:
		bsr		PrintNNP
		lea		(FormatMemory,pc),a0
		bsr		PrintForQ
		PFLONG	MH_FREE
		PFLONG	MH_UPPER
		PFLONG	MH_LOWER
		PFLONG	MH_FIRST
		PFWORD	MH_ATTRIBUTES
		PFEND
		bra		PrintIt

	;***
	;Show one line of Font node information
	;***
Print1Font:
		bsr		PrintNNP
		lea		(FormatFont,pc),a0
		bsr		PrintForQ
		PFBYTE	tf_HiChar
		PFBYTE	tf_LoChar
		PFBYTE	tf_Style
		PFWORD	tf_XSize
		PFWORD	tf_YSize
		PFEND
		bra		PrintIt

	;***
	;Show one line of semaphore node information
	;***
Print1Semaphore:
		bsr		PrintNNP
		lea		(FormatSemaph,pc),a0
		bsr		PrintForQ
		PFLONG	SS_OWNER
		PFWORD	SS_QUEUECOUNT
		PFWORD	SS_NESTCOUNT
		PFEND
		bra		PrintIt

	;***
	;Crash node info
	;***
Print1Crashed:
		move.l	(Storage),d0
		lea		(FormatCrash,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
		PFBYTE	cn_Guru
		PFLONG	cn_2ndInfo
		PFLONG	cn_TrapNumber
		PFLONG	cn_Task
		PFSTRUCT
		PFEND
		bra		PrintIt

	;***
	;Attach node information
	;***
Print1Attach:
		move.l	(Storage),d0
		lea		(FormatAttach,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
		PFSTRING	ka_CommandString
		PFWORD	ka_Qualifier
		PFWORD	ka_Code
		PFSTRUCT
		PFEND
		bra		PrintIt

	;***
	;Show one line of FDFile node information
	;***
Print1FDFile:
		move.l	(Storage),d0
		lea		(FormatFDFiles,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
		PFWORD	fd_NumFuncs
		PFLONG	fd_Library
		PFSTRUCT
		PFSTRING	LN_NAME
		PFEND
		bra		PrintIt

	;***
	;Show one line of debug node information
	;***
Print1Debug:
		moveq		#0,d0
		move.b	(db_TMode,a2),d0
		move.w	d0,d1
		lsl.b		#2,d1
		add.b		d0,d1
		lea		(DbTModesString,pc),a0
		lea		(a0,d1.w),a0
		move.l	a0,-(a7)

		move.b	(db_SMode,a2),d0
		move.w	d0,d1
		lsl.b		#2,d1
		add.b		d0,d1
		lea		(DbSModesString,pc),a0
		lea		(a0,d1.w),a0
		move.l	a0,-(a7)

		move.b	(db_Mode,a2),d0
		move.w	d0,d1
		lsl.b		#2,d1
		add.b		d0,d1
		lea		(DbModesString,pc),a0
		lea		(a0,d1.w),a0
		move.l	a0,-(a7)

		move.b	(db_IDNestCnt,a2),d0
		move.w	d0,-(a7)
		move.b	(db_TDNestCnt,a2),d0
		move.w	d0,-(a7)
		move.l	(db_InitPC,a2),-(a7)
		move.l	(db_Task,a2),-(a7)
		move.l	a2,-(a7)
		move.l	(LN_NAME,a2),-(a7)
		lea		(FormatDebug,pc),a0
		bsr		SPrintIt
		lea		(32,a7),a7
		rts

	;***
	;Show one line of function monitor node information
	;***
Print1FuncMon:
		move.w	(fm_Type,a2),d0
		lsl.w		#2,d0
		lea		(FuncMonStrings,pc),a0
		lea		(0,a0,d0.w),a0
		lea		(1$+2,pc),a1
		move.l	a0,(a1)

		move.l	(Storage),d0
		lea		(FormatFuncMon,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
1$		PFSIMM	0
		PFLONG	fm_Count
		PFLONG	fm_Task
		PFWORD	fm_Offset
		PFLONG	fm_Library
		PFSTRUCT
		PFSTRING	LN_NAME
		PFEND
		bra		PrintIt

	;***
	;Show one line of lwin node information
	;***
Print1LWin:
		move.l	(Storage),d0
		lea		(FormatLWin,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
		PFWORD	LogWin_visrow
		PFWORD	LogWin_viscol
		PFWORD	LogWin_row
		PFWORD	LogWin_col
		PFWORD	LogWin_height
		PFWORD	LogWin_width
		PFLONG	LogWin_PhysWin
		PFSTRUCT
		PFSTRING	LN_NAME
		PFEND
		bra		PrintIt

	;***
	;Show one line of pwin node information
	;***
Print1PWin:
		move.l	(Storage),d0
		lea		(FormatPWin,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
		PFWORD	PhysWin_LastQualifier
		PFWORD	PhysWin_LastCode
		PFLONG	PhysWin_Window
		PFSTRUCT
		PFSTRING	LN_NAME
		PFEND
		bra		PrintIt

	;***
	;Subroutine in Print1... to print name, node address and priority
	;a2 = node
	;-> a0 = pointer to continue printing
	;-> d0 = the same
	;-> a1 = node (a2)
	;***
PrintNNP:
		lea		(FormatPNNP,pc),a0
		move.l	(Storage),d0
		movea.l	a2,a1
		bsr		PrintForQ
		PFBYTE	LN_PRI
		PFSTRUCT
		PFSTRING	LN_NAME
		PFEND
		movea.l	(Storage),a0
		lea		(20+8+2+5,a0),a0
		move.l	a0,d0
		rts

	;***
	;Show one line of window structure information
	;***
Print1Window:
		lea		(FormatP1FM,pc),a0
		move.l	(Storage),d0
		movea.l	a2,a1
		bsr		PrintForQ
		PFSTRUCT
		PFSTRING	wd_Title
		PFEND

		add.l		#20+8+3,d0
		lea		(FormatWindow,pc),a0
		bsr		PrintForQ
		PFLONG	wd_WScreen
		PFWORD	wd_Height
		PFWORD	wd_Width
		PFWORD	wd_TopEdge
		PFWORD	wd_LeftEdge
		PFEND
		bra		PrintIt

	;***
	;Show one line of screen structure information
	;***
Print1Screen:
		lea		(FormatP1FM,pc),a0
		move.l	(Storage),d0
		movea.l	a2,a1
		bsr		PrintForQ
		PFSTRUCT
		PFSTRING	sc_Title
		PFEND

		add.l		#20+8+3,d0
		lea		(FormatScreen,pc),a0
		bsr		PrintForQ
		PFLONG	sc_FirstWindow
		PFWORD	sc_Height
		PFWORD	sc_Width
		PFWORD	sc_TopEdge
		PFWORD	sc_LeftEdge
		PFEND
		bra		PrintIt

	;***
	;Show one line of lock or file information
	;***
Print1File:
		move.l	a2,d0
		lsr.l		#2,d0
		bsr		SizeLock
		tst.l		d0
		bne.b		Print1Lock
		rts
Print1Lock:
		move.l	a2,d0
		lsr.l		#2,d0					;APTR->BPTR
		movea.l	a7,a0					;Pointer to end of pathname
		lea		(-256,a7),a7		;Reserve space
		bsr		ConstructPath
		move.l	(fl_Key,a2),-(a7)
		move.l	a2,d0
		lsr.l		#2,d0					;APTR->BPTR
		bsr		SizeLock
		move.l	d0,-(a7)
		move.l	(fl_Access,a2),d0
		lea		(WriteLString,pc),a1
		addq.l	#1,d0					;ACCESS_WRITE
		beq.b		1$
		lea		(ReadLString,pc),a1
1$		move.l	a1,-(a7)				;Access string
		move.l	a2,-(a7)
		move.l	a0,-(a7)
		lea		(FormatLocks,pc),a0
		bsr		SPrintIt
		lea		(256+20,a7),a7
		rts

	;***
	;Show one line of resident module structure information
	;***
Print1ResMod:
		move.l	(Storage),d0
		lea		(FormatResMod,pc),a0
		movea.l	a2,a1
		bsr		PrintForQ
		PFSTRING	RT_IDSTRING
		PFBYTE	RT_FLAGS
		PFBYTE	RT_VERSION
		PFBYTE	RT_PRI
		PFSTRUCT
		PFSTRING	RT_NAME
		PFEND
		bra		PrintIt

 IFD	D20
	;***
	;Show one line of public screen
	;***
Print1PubScr:
		bsr		PrintNNP
		lea		(FormatPubScr,pc),a0
		bsr		PrintForQ
		PFBYTE	psn_SigBit
		PFLONG	psn_SigTask
		PFWORD	psn_VisitorCount
		PFLONG	psn_Screen
		PFEND
		bra		PrintIt

	;***
	;Show one line of monitor information
	;***
Print1Moni:
		bsr		PrintNNP
		lea		(FormatMoni,pc),a0
		bsr		PrintForQ
		PFLONG	XLN_INIT
		PFLONG	XLN_LIBRARY
		PFBYTE	XLN_SUBTYPE
		PFBYTE	XLN_SUBSYSTEM
		PFEND
		bra		PrintIt
 ENDC

	;***
	;Show one line of structure definition information
	;***
Print1Struct:
		bsr		PrintNNP
		lea		(FormatStruct,pc),a0
		bsr		PrintForQ
		PFWORD	str_Length
		PFLONG	str_Strings
		PFLONG	str_InfoBlock
		PFEND
		bra		PrintIt

	;***
	;Show one line of input handler information
	;***
Print1InputH:
		bsr		PrintNNP
		lea		(FormatInputH,pc),a0
		bsr		PrintForQ
		PFLONG	IS_CODE
		PFLONG	IS_DATA
		PFEND
		bra		PrintIt

	;***
	;Show one line of dosdevice structure information
	;***
Print1DosDev:
		lea		(FormatDosDev,pc),a0
		move.l	(dl_DiskType,a2),-(a7)
		move.l	(dl_LockList,a2),d0
		lsl.l		#2,d0
		move.l	d0,-(a7)
		move.l	(dl_Lock,a2),d0
		lsl.l		#2,d0
		move.l	d0,-(a7)
		move.l	(dl_Task,a2),-(a7)
		move.l	(dl_Type,a2),-(a7)
		move.l	a2,-(a7)
		move.l	(dl_Name,a2),d0
		lsl.l		#2,d0
		addq.l	#1,d0					;BCPL string, skip length
		move.l	d0,-(a7)
		bsr		SPrintIt
		lea		(28,a7),a7
		rts

	;***
	;Set temporary default list
	;d6 = list
	;***
SetList:
		movem.l	a0-a1,-(a7)
		lea		(TItem,pc),a0
		lea		(Item,pc),a1
		tst.w		(a0)
		bne.b		1$						;Already set
	;Really set
		move.w	(a1),(a0)			;Remember old Item
1$		move.w	d6,(a1)				;New Item
		movem.l	(a7)+,a0-a1
		rts

	;***
	;Restore default list
	;This routine preserves all registers
	;***
ResetList:
		movem.l	d0/a0-a1,-(a7)
		lea		(TItem,pc),a0
		tst.w		(a0)
		beq.b		1$
	;Really restore
		lea		(Item,pc),a1
		move.w	(a0),(a1)
		clr.w		(a0)					;Reset TItem
1$		movem.l	(a7)+,d0/a0-a1
		rts

	;***
	;Command: execute a routine for each element in a list
	;***
RoutFor:
		bsr		GetStringE			;Get list
		move.l	a0,d6					;d6 = ptr to argline to execute
		movea.l	d0,a0
		bsr		NameToItem			;d0 = list
		HERReq
		move.l	d0,-(a7)
		movea.l	d6,a0
		bsr		GetRestLinePer		;Store string in memory
		HERReq
		move.l	d0,d6
		bsr		ClearVirtual
		move.b	#1,(VPrint)
		move.l	(a7)+,d0
		lea		(ForRoutine,pc),a0
		bsr		ApplyCommandOnList
		beq.b		1$
		bra		CleanUpRF
	;Error
1$		bsr		CleanUpRF
		ERROR		BadListType

CleanUpRF:
		movea.l	d6,a0
		bsr		FreeBlock
		clr.b		(VPrint)
		bsr		PrintVirtualBuf
		bra		ClearVirtual

	;***
	;For each list element execute command
	;a2 = address of list
	;a3 = infoblock
	;d6 = copy of argline to execute
	;-> d1 = 0, flags if error
	;***
ForRoutine:
		movem.l	d2-d7/a2-a5,-(a7)
		move.l	a2,d0
		bsr		StoreRC
		movea.l	d6,a1
		movea.l	(Line),a0
1$		move.b	(a1)+,(a0)+
		bne.b		1$
		movea.l	(Line),a0
		moveq		#EXEC_FOR,d0
		bsr		ExecAlias
		moveq		#1,d1					;We ignore errors from command
		movem.l	(a7)+,d2-d7/a2-a5
		rts

	;***
	;Scan a list and execute a specific command for each element in the list
	;a0 = routine to apply on list
	;			;***
	;			;Routine for each element in list
	;			;a2 = address of listelement
	;			;a3 = ptr to InfoBlock
	;			;d4, d5 and d6 are arguments from caller
	;			;-> d1 = 0, flags if error
	;			;Routine must preserve all regs except a0-a1/d0-d1/a6
	;			;***
	;d0 = number of list
	;d4, d5 and d6 are free and are given to the routine
	;-> d0 = 0 if no success (flags)
	;***
ApplyCommandOnList:
		movem.l	a2-a5/d7,-(a7)
		movea.l	a0,a4
		subq.w	#2,d0
		mulu.w	#in_SIZE,d0
		lea		(InfoBlocks,pc),a3
		lea		(0,a3,d0.w),a3
	;Start scanning
		cmpi.b	#-2,(in_Control,a3)
		bne.b		1$
	;Lists like this (with ListItem) are not supported
		moveq		#0,d0
		bra.b		10$
1$		cmpi.b	#-3,(in_Control,a3)
		bne.b		4$
	;Lists like this (that are totally independent) are not supported
		moveq		#0,d0
		bra.b		10$
4$		bsr		GotoStartList
		cmpi.b	#I_TASK,(in_Item,a3)
		bne.b		5$
		bsr		Disable
5$		bsr		Forbid
		movea.l	(in_Next,a3),a5
		moveq		#0,d7					;Variable, free to use
2$		jsr		(a5)
		beq.b		3$
		jsr		(a4)
		bne.b		2$						;If error, we stop listing
3$		bsr		Permit
		cmpi.b	#I_TASK,(in_Item,a3)
		bne.b		6$
		bsr		Enable
	;Success
6$		moveq		#1,d0
10$	movem.l	(a7)+,a2-a5/d7
		rts

	;***
	;List the current item
	;***
ListCurrent:
		move.w	(Item,pc),d0
		subq.w	#2,d0
		mulu.w	#in_SIZE,d0
		lea		(InfoBlocks,pc),a3
		lea		(0,a3,d0.w),a3
		bra.b		ContListIT

	;***
	;Get the argument and list the item
	;a0 = cmdline
	;***
ListItems:
		bsr		GetStringE
		lea		(InfoBlocks,pc),a1
		movea.l	d0,a0
		lea		(GetNextListI,pc),a5
		bsr		SearchWord			;d1=ptr to list element
		tst.l		d1
		ERROReq	UnknownListElement
		movea.l	d1,a3
ContListIT:
		cmpi.b	#-2,(in_Control,a3)
		bne.b		1$
		movea.l	(in_InfoList,a3),a0
		movea.l	(in_Base,a3),a2
		movea.l	(a2),a2
		bra		ListItem
1$		cmpi.b	#-3,(in_Control,a3)
		bne.b		4$
		bsr		Forbid
		movea.l	(in_Header,a3),a0
		PRINT
		bsr		PrintLine
		movea.l	(in_Routine,a3),a0
		jsr		(a0)
		bra		Permit
4$		bsr		GotoStartList
		movea.l	(in_Header,a3),a0
		PRINT
		bsr		PrintLine
		bsr		ClearVirtual
		cmpi.b	#I_TASK,(in_Item,a3)
		bne.b		5$
		bsr		Disable
5$		bsr		Forbid
		move.b	#1,(VPrint)
		movea.l	(in_Next,a3),a0
		movea.l	(in_PrintLine,a3),a1
		moveq		#0,d7					;Variable, free to use
2$		jsr		(a0)
		beq.b		3$
		movem.l	d7/a0-a1,-(a7)
		jsr		(a1)
		movem.l	(a7)+,d7/a0-a1
		bra.b		2$
3$		clr.b		(VPrint)
		bsr		Permit
		cmpi.b	#I_TASK,(in_Item,a3)
		bne.b		6$
		bsr		Enable
6$		bsr		PrintVirtualBuf
		bra		ClearVirtual

	;***
	;Goto the start of the list
	;a3 = ptr to list
	;-> a3 = ptr to list
	;-> a2 = ptr to base of list
	;***
GotoStartList:
		move.b	(in_Control,a3),d0
		cmpi.b	#-1,d0
		beq.b		1$
		movea.l	(in_Base,a3),a2
		move.b	d0,d1
		andi.b	#$f0,d1
		cmpi.b	#$10,d1				;Contents op
		beq.b		2$
		cmpi.b	#$20,d1				;BPTR Cont op
		bne.b		3$
	;BPTR contents
		adda.l	a2,a2
		adda.l	a2,a2
2$		movea.l	(a2),a2
3$		adda.w	(in_Offset,a3),a2
		andi.b	#$f,d0
		cmpi.b	#1,d0
		beq.b		4$
		cmpi.b	#2,d0
		bne.b		5$
	;BPTR contents
		adda.l	a2,a2
		adda.l	a2,a2
4$		movea.l	(a2),a2
5$		rts
	;Execute routine (rout must preserve a3)
1$		movea.l	(in_Routine,a3),a2
		jmp		(a2)

	;***
	;List an item:
	;		Bytes, words, longs and objects are just put after each other
	;		(three on each line). Strings are always put on a seperate line
	;		Arrays are shown with only one line of items
	;Format:
	;	-	First long in item element points to string (see StructEntry
	;		structure)
	;	-	The following byte contains 0 (SEN_BYTE) if byte, 1 (SEN_WORD) if
	;		word, 2 (SEN_LONG) if long, 3 (SEN_STRING) if string, 4 (SEN_OBJECT)
	;		if object in object (like ViewPort in screen), 5 (SEN_INLINESTR) if
	;		object is an inline string
	;		If BPTR to APTR conversion must be done, add SENF_BPTR to this byte
	;		If it is an array of these elements, add SENF_ARRAY to this byte
	;	-	The following byte contains the size of the inline string or the
	;		array (only if type is equal to SEN_INLINESTR or is a SENF_ARRAY)
	;	-	The last word contains the offset
	;a0 = Ptr to list
	;a2 = Ptr to element to list (Node or structure,...)
	;***
ListItem:
		movem.l	a2-a5/d2-d7,-(a7)
		movea.l	a0,a5
LoopNewLIT:
		movea.l	(Storage),a0
		moveq		#3,d7					;Counter for newline
LoopLIT:
		move.l	(a5)+,d0				;Get string address
		beq		.end					;The end
		movea.l	d0,a1
		moveq		#14,d0				;Number of alignment bytes for start string
		moveq		#0,d5
		move.b	(a5)+,d5				;Get type: SEN_BYTE, SEN_WORD, ...
		moveq		#0,d4
		move.b	(a5)+,d4				;Get size (only for SEN_INLINESTR and SENF_ARRAY)
		move.w	(a5)+,d1				;Get offset
		lea		(a2,d1.w),a3		;Pointer to (first) element

	;Test for BPTR and array
		moveq		#0,d6					;BPTR conversion off
		bclr		#SENB_BPTR,d5		;Test and clear
		beq.b		1$
		moveq		#1,d6					;SENB_BPTR
1$		moveq		#0,d3					;No array
		bclr		#SENB_ARRAY,d5		;Test and clear
		beq.b		2$
		moveq		#1,d3					;SENB_ARRAY

	;d5 = type (SEN_xxx)
	;d4 = size (if SEN_INLINESTR or SENF_ARRAY)
	;d1 = offset
	;d6 = 1 if BPTR
	;d3 = 1 if ARRAY
	;a2 = ptr to element or list
	;a3 = ptr to (first) element in a2
	;a5 = ptr to next field in structure
	;d7 = newline counter
	;d0 = number of alignment bytes for start string
	;a0 = ptr to output storage

2$		tst.w		d5
		beq		.byte					;SEN_BYTE
		subq.w	#1,d5
		beq		.word					;SEN_WORD
		subq.w	#1,d5
		beq.b		.long					;SEN_LONG
		subq.w	#1,d5
		beq.b		.str					;SEN_STRING
		subq.w	#1,d5
		beq.b		.obj					;SEN_OBJECT

	;Inline string (SEN_INLINESTR) (no support for BPTR, ARRAY)
.inls	move.l	a3,d1					;d1 points to inline string
		moveq		#64,d5				;String length
		cmp.w		d5,d4
		bge.b		4$						;Continue with string
		move.w	d4,d5
		bra.b		4$						;Continue with string

	;Object in object (SEN_OBJECT) (no support for BPTR)
.obj	move.l	a3,d1					;d1 points to object in object
		bra.b		8$						;Continue with long

	;String (SEN_STRING) (no support for ARRAY)
.str	move.l	(a3),d1				;Get ptr to string
		bne.b		3$						;Test if str is 0
		moveq		#0,d5					;Length is zero
		bra.b		4$						;Skip BPTR testing
3$		moveq		#64,d5				;String length
		tst.l		d6
		beq.b		4$
		lsl.l		#2,d1
		movea.l	d1,a6
		move.b	(a6)+,d5				;Get length
		addq.l	#1,d1					;Skip first byte
4$		bsr		.flush				;Flush output if needed
		moveq		#14,d0
		bsr		InitPrepHex			;Print header
		movea.l	d1,a1
		move.l	d5,d0					;Length
		beq.b		6$						;String was NULL
		bsr		CopyCString
6$		bsr		.clreol				;Clear end of line
		bsr		PrintIt
		bra		LoopNewLIT

	;Long (SEN_LONG)
.long	move.l	(a3),d1
		tst.l		d6
		beq.b		8$
		lsl.l		#2,d1					;BPTR
8$		tst.l		d3
		beq.b		9$
	;Array of long
		moveq		#6,d2					;Print 6 array elements
		lea		(.longel,pc),a4
		bsr		.printa
		bra		LoopNewLIT
9$		bsr		PrepareHex
		bra.b		.next

	;Word (SEN_WORD)
.word	move.w	(a3),d1
		tst.l		d6
		beq.b		10$
		lsl.w		#2,d1					;BPTR
10$	tst.l		d3
		beq.b		11$
	;Array of word
		moveq		#11,d2				;Print 11 array elements
		lea		(.wordel,pc),a4
		bsr		.printa
		bra		LoopNewLIT
11$	bsr		PrepareHexW
		bra.b		.next

	;Byte (SEN_BYTE)
.byte	move.b	(a3),d1
		tst.l		d6
		beq.b		12$
		lsl.b		#2,d1					;BPTR
12$	tst.l		d3
		beq.b		13$
	;Array of byte
		moveq		#20,d2				;Print 20 array elements
		lea		(.byteel,pc),a4
		bsr		.printa
		bra		LoopNewLIT
13$	bsr		PrepareHexB

	;Continue with the listing
.next	subq.b	#1,d7
		beq.b		.nl
		bra		LoopLIT

	;Subroutine
	;Clear the end of the line (remove the last space)
	;a0 = pointer to end of line
.clreol
		cmpi.b	#' ',(-1,a0)
		bne.b		15$
		clr.b		(-1,a0)
15$	clr.b		(a0)+
		rts

	;The end!
.end	cmpi.b	#3,d7
		beq.b		17$
		bsr.b		.clreol				;Clear end of line
		bsr		ViewPrintLine
17$	bsr		SoftNewLine
		movem.l	(a7)+,a2-a5/d2-d7
		rts

	;NewLine
.nl	bsr.b		.clreol
		bsr		ViewPrintLine
		tst.l		(a5)
		beq.b		19$
		bsr		SoftNewLine
19$	bra		LoopNewLIT

	;Subroutine
	;Flush output if needed
.flush
		cmpi.b	#3,d7					;Newline counter
		beq.b		5$
		bsr.b		.clreol				;Clear end of line
		movem.l	a1/d1,-(a7)
		bsr		ViewPrintLine
		bsr		SoftNewLine
		movem.l	(a7)+,a1/d1
		moveq		#3,d7
		movea.l	(Storage),a0
5$		rts

	;Subroutine
	;Print array
	;d2 = number of elements to print
	;a0 = output buffer
	;a3 = pointer to first element
	;d4 = max number of elements in array
	;a4 = routine to call for each element (.xxxxel)
.printa
		bsr		.flush				;Flush output if needed
		moveq		#14,d0
		bsr		InitPrepHex			;Print header
		move.l	d2,-(a7)				;Remember original number of elements to print
		cmp.w		d4,d2
		ble.b		7$
		move.w	d4,d2

7$		jsr		(a4)
		move.b	#' ',(a0)+
		subq.w	#1,d2
		bgt.b		7$

	;Add '...' if the array continues
		move.l	(a7)+,d2
		cmp.w		d4,d2
		bge.b		14$
		move.b	#'.',(a0)+
		move.b	#'.',(a0)+
		move.b	#'.',(a0)+
		clr.b		(a0)

14$	moveq		#0,d7
		bra		.flush

	;Subroutine
	;Get long element (for array printing)
.longel
		move.l	(a3)+,d0
		bsr		LongToHex
		lea		(8,a0),a0
		rts

	;Subroutine
	;Get word element (for array printing)
.wordel
		move.w	(a3)+,d0
		bsr		WordToHex
		lea		(4,a0),a0
		rts

	;Subroutine
	;Get byte element (for array printing)
.byteel
		move.b	(a3)+,d0
		bsr		ByteToHex
		lea		(2,a0),a0
		rts

	;***
	;Print a bit field
	;d0 = integer
	;a0 = ptr to string array (BitMask.l BitValue.l strptr)
	;***
PrintBitField:
		movea.l	(Storage),a1
		bsr		ConvertBitField
		movea.l	(Storage),a0
		PRINT
		NEWLINE
		rts

	;***
	;Convert an bit field integer to a string
	;d0 = integer
	;a0 = ptr to string array (BitMask.l BitValue.l strptr)
	;a1 = ptr to result string
	;-> a1 = ptr after string
	;***
ConvertBitField:
		movem.l	a2/d2,-(a7)
		bra.b		2$
1$		move.l	d0,d2
		and.l		d1,d2
		move.l	(a0)+,d1				;Get BitValue
		cmp.l		d1,d2
		bne.b		3$
	;Bits are set, copy string
		movea.l	(a0)+,a2				;Get strptr
4$		move.b	(a2)+,(a1)+
		bne.b		4$
		move.b	#' ',(-1,a1)
		bra.b		2$
	;Bits are not set, skip strptr
3$		lea		(4,a0),a0
	;Goto next entry
2$		move.l	(a0)+,d1				;Get BitMask
		bne.b		1$
		clr.b		(a1)+
		movem.l	(a7)+,a2/d2
		rts

	;***
	;Get a value from a list (see ListItem for format)
	;a0 = Ptr to list
	;a1 = String to search
	;d1 = Str len
	;a2 = Ptr to element to list (Node or structure,...)
	;-> d0 = value
	;-> d1 = 1 if found (or 0,flags)
	;-> a0 = address
	;***
GetItem:
		movem.l	a2/a5/d3-d7,-(a7)
		movea.l	a0,a5
		bsr		GetArrayIndex		;-> d0 = index value (or negative if no index)
		move.l	d0,d7

1$		move.l	(a5),d0				;Get string address
		beq		.notfound
		movea.l	d0,a0
		move.l	a1,-(a7)
		move.l	d1,d0
		bsr		CompareCI
		movea.l	(a7)+,a1				;Must be this way for flags
		beq.b		2$
		lea		(8,a5),a5
		bra.b		1$

	;We have found it
2$		lea		(4,a5),a5
		moveq		#0,d5
		move.b	(a5)+,d5				;Type (SEN_xxxx)
		moveq		#0,d4
		move.b	(a5)+,d4				;Size (if SENF_ARRAY or SEN_INLINESTR)
		move.w	(a5)+,d1				;Offset
		lea		(a2,d1.w),a0

	;Test for BPTR and array
		moveq		#0,d6					;BPTR conversion off
		bclr		#SENB_BPTR,d5		;Test and clear
		beq.b		5$
		moveq		#1,d6					;SENB_BPTR
5$		moveq		#0,d3					;No array
		bclr		#SENB_ARRAY,d5		;Test and clear
		beq.b		7$
		moveq		#1,d3					;SENB_ARRAY

	;Test if there is an index without an array
7$		tst.l		d7
		blt.b		11$
		tst.w		d3
		ERROReq	OnlyIndexForArrays

	;We have an array and an index, add the appropriate amount to the address
		moveq		#1,d0					;Assume byte array
		cmpi.b	#SEN_LONG,d5
		bne.b		12$
		moveq		#4,d0
		bra.b		13$
12$	cmpi.b	#SEN_WORD,d5
		bne.b		13$
		moveq		#2,d0
13$	mulu.w	d7,d0					;Get long offset
		adda.l	d0,a0					;Get new address

	;Test if inline string, object or array without index (no address in that case)
11$	move.l	a0,d0
		cmpi.b	#SEN_INLINESTR,d5
		beq.b		3$
		cmpi.b	#SEN_OBJECT,d5
		beq.b		3$
		tst.w		d3
		beq.b		4$
	;Yes, array
;Test for index later
		tst.l		d7
		bge.b		4$						;There is an index

	;Structure in structure, inline string or array with no index
3$		suba.l	a0,a0
		bra.b		.ok

4$		moveq		#0,d0
		cmp.w		#SEN_BYTE,d5
		beq.b		6$
		cmpi.w	#SEN_WORD,d5
		beq.b		8$

	;Long or string
		move.l	(a0),d0
	;Check if BPTR
		tst.w		d6						;BPTR?
		beq.b		.ok
		lsl.l		#2,d0
		bra.b		.ok

	;Byte
6$		move.b	(a0),d0
		bra.b		.ok

	;Word
8$		move.w	(a0),d0

.ok	moveq		#1,d1
		bra.b		.end

	;Not found
.notfound
		moveq		#0,d1

.end	movem.l	(a7)+,a2/a5/d3-d7
		rts

	;---
	;Subroutine
	;Check if a string contains an array index.
	;If yes returns the value of the index
	;a1 = string
	;-> d0 = value of index (or negative if no index)
	;-> d1 = new number of chars to compare (unchanged if no index)
	;-> Preserves all other registers
	;---
GetArrayIndex:
		movem.l	a0-a2,-(a7)
		movea.l	a1,a2					;Remember start
1$		move.b	(a1)+,d0
		beq.b		2$
		cmpi.b	#'[',d0
		bne.b		1$

	;Index!
		move.l	a1,d1
		sub.l		a2,d1					;Compute new number of chars
		subq.l	#1,d1
		movea.l	a1,a0
		move.l	d1,-(a7)
		EVALE								;Get index
		move.l	(a7)+,d1
		tst.l		d0
		bge.b		3$
		moveq		#0,d0					;No negative indeces allowed
		bra.b		3$

	;No index
2$		moveq		#-1,d0
3$		movem.l	(a7)+,a0-a2
		rts

	;***
	;Node specific More-Information routines
	;***
NodeTask:
		bsr		Forbid
		cmpi.b	#NT_PROCESS,(LN_TYPE,a2)
		bne.b		1$
		move.l	(pr_TaskNum,a2),d0
		beq.b		2$
		move.l	(pr_CLI,a2),d0
		beq.b		2$
	;Print all information for cli structure
		NEWLINE
		move.l	a2,-(a7)
		lsl.l		#2,d0
		movea.l	d0,a2					;a2=ptr to cli
		lea		(CliInfoList,pc),a0
		bsr		ListItem
		movea.l	(a7)+,a2
2$		NEWLINE
		lea		(ProcInfoList,pc),a0
		bsr		ListItem
1$		NEWLINE
		lea		(TaskInfoList,pc),a0
		bsr		ListItem
		bra		Permit
NotNodeScreen:
		NEWLINE
		lea		(ScrInfoList,pc),a0
		bsr		ListItem
		NEWLINE
		lea		(Hsc_Flags2,pc),a0
		PRINT
		lea		(bfScrFlags,pc),a0
		move.w	(sc_Flags,a2),d0
		bra		PrintBitField
NotNodeWindow:
		NEWLINE
		lea		(WinInfoList,pc),a0
		bsr		ListItem
		NEWLINE
		lea		(Hwd_Flags2,pc),a0
		PRINT
		lea		(bfWinFlags,pc),a0
		move.l	(wd_Flags,a2),d0
		bsr		PrintBitField
		lea		(Hwd_IDCMP2,pc),a0
		PRINT
		lea		(bfIDCMP,pc),a0
		move.l	(wd_IDCMPFlags,a2),d0
		bra		PrintBitField
NodeFDFiles:
		NEWLINE
		move.w	(fd_NumFuncs,a2),d2
		movea.l	(fd_Block,a2),a3
		movea.l	(fd_String,a2),a4
		addq.w	#1,d2
1$		move.l	(a3),d0
		addq.l	#1,d0
		beq.b		2$
		lea		(-1,a4,d0.l),a0
		PRINT
		NEWLINE
		lea		(12,a3),a3
		dbra		d2,1$
2$		rts
NodeDebug:
		NEWLINE
		lea		(HeaderBreakP,pc),a0
		PRINT
		bsr		PrintLine
		lea		(db_BreakPoints,a2),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		3$

		lea		(4$+2,pc),a0
		clr.l		(a0)
		move.b	(bp_Type,a2),d0
		cmpi.b	#'C',d0
		bne.b		2$
	;We have a condition string
		move.l	(bp_Additional,a2),(a0)

2$		lea		(FormatBreakP,pc),a0
		movea.l	a2,a1
		bsr		PrintFor
4$		PFSIMM	0
		PFBYTE	bp_Type
		PFLONG	bp_UsageCnt
		PFLONG	bp_Where
		PFWORD	bp_Number
		PFSTRUCT
		PFEND

		bra.b		1$
3$		rts

NodeFuncMon:
		NEWLINE
		movem.l	d2-d7/a2-a5,-(a7)
		bsr		Disable
		lea		(-8*4-8*14*4,a7),a7	;Reserve space

		movem.l	(fm_LastTask,a2),d0-d3/a3-a6
		movem.l	d0-d3/a3-a6,(a7)
		lea		(fm_Registers,a2),a0
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+0*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+1*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+2*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+3*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+4*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+5*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+6*4*14,a7)
		movem.l	(a0)+,d0-d7/a1-a6
		movem.l	d0-d7/a1-a6,(8*4+7*4*14,a7)
		bsr		Enable

		movem.l	(8*4+8*14*4,a7),d2-d7/a2-a5

		moveq.l	#7,d2					;Loop 8 times
		move.w	(fm_LastTaskNr,a2),d0
		movea.l	a7,a3					;TaskTable
		lea		(8*4,a7),a4			;RegTable

2$		move.l	(0,a3,d0.w),d1
		beq.b		3$
		movem.l	d0/d2/a2-a3,-(a7)
		movea.l	d1,a2
		bsr		Print1Task
		movem.l	(a7)+,d0/d2/a2-a3
	;Show all registers if type is FULL
		move.w	(fm_Type,a2),d1
		andi.w	#FM_FULL,d1
		beq.b		3$
	;Show all registers
		move.l	d0,-(a7)
		movea.l	a4,a1
		lea		(4*14,a4),a4
		lea		(FormatAFRegs,pc),a0
		move.l	(Storage),d0
		bsr		FastFPrint
		movea.l	(Storage),a0
		PRINT
		move.l	(a7)+,d0
	;Next task
3$		addq.w	#4,d0
		andi.b	#31,d0
		dbra		d2,2$

		lea		(8*4+8*14*4,a7),a7	;Remove reserved space
		movem.l	(a7)+,d2-d7/a2-a5
		rts

NodeMemory:
		NEWLINE
		movea.l	(MH_FIRST,a2),a3
1$		move.l	a3,d0
		beq.b		2$

		lea		(FormatMemoryL,pc),a0
		movea.l	a3,a1
		bsr		PrintFor
		PFLONG	4
		PFSTRUCT
		PFEND

		movea.l	(a3),a3
		bra.b		1$
2$		rts


NodeConfig:
		NEWLINE
		lea		(ConfInfoList,pc),a0
		bra		ListItem

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	EVEN

	;***
	;Start of ListBase
	;***
ListBase:

WindowPtr:	dc.l	0					;pr_WindowPtr save
Prompt:		dc.l	"Task"			;Current current prompt
Item:			dc.w	I_TASK			;Itemnumber we are in
TItem:		dc.w	0					;Temporary item number

StructDefs:	ds.b	LH_SIZE			;List for structure definitions

InfoBlocks:
InfoExec:
	dc.l	'Exec'
	dc.b	I_EXECBASE,-2
	dc.l	SysBase
	dc.w	0
	dc.l	ExecBaseList,0,0
	dc.l	'exec'
	dc.b	0,0
	dc.l	0,0
	dc.w	0
InfoIntb:
	dc.l	'Intb'
	dc.b	I_INTBASE,-2
	dc.l	IntBase
	dc.w	0
	dc.l	IntuiBaseList,0,0
	dc.l	'intb'
	dc.b	0,0
	dc.l	0,0
	dc.w	0
InfoTask:
	dc.l	'Task'
	dc.b	I_TASK,$10
	dc.l	SysBase
	dc.w	TaskReady
	dc.l	InfNextTask,HeaderTask,FormatTask
	dc.l	'task'
	dc.b	0,0
	dc.l	NodeTask,Print1Task
	dc.w	LN_NAME
InfoLibs:
	dc.l	'Libs'
	dc.b	I_LIBS,$10
	dc.l	SysBase
	dc.w	LibList
	dc.l	InfNextNode,HeaderLibrary,FormatLibrary
	dc.l	'libs'
	dc.b	0,1
	dc.l	DevsInfoList,Print1Library
	dc.w	LN_NAME
InfoDevs:
	dc.l	'Devs'
	dc.b	I_DEVS,$10
	dc.l	SysBase
	dc.w	DeviceList
	dc.l	InfNextNode,HeaderDevice,FormatDevice
	dc.l	'devs'
	dc.b	0,1
	dc.l	DevsInfoList,Print1Device
	dc.w	LN_NAME
InfoReso:
	dc.l	'Reso'
	dc.b	I_RESO,$10
	dc.l	SysBase
	dc.w	ResourceList
	dc.l	InfNextNode,HeaderResource,FormatResource
	dc.l	'reso'
	dc.b	0,1
	dc.l	DevsInfoList,Print1Resource
	dc.w	LN_NAME
InfoMemr:
	dc.l	'Memr'
	dc.b	I_MEMORY,$10
	dc.l	SysBase
	dc.w	MemList
	dc.l	InfNextNode,HeaderMemory,FormatMemory
	dc.l	'memr'
	dc.b	0,0
	dc.l	NodeMemory,Print1Memory
	dc.w	LN_NAME
InfoIntr:
	dc.l	'Intr'
	dc.b	I_INTERR,$10
	dc.l	SysBase
	dc.w	IntrList
	dc.l	InfNextNode,HeaderInterr,FormatInterr
	dc.l	'intr'
	dc.b	0,1
	dc.l	0,Print1Interrupt
	dc.w	LN_NAME
InfoPort:
	dc.l	'Port'
	dc.b	I_PORT,$10
	dc.l	SysBase
	dc.w	PortList
	dc.l	InfNextNode,HeaderMsgPort,FormatMsgPort
	dc.l	'port'
	dc.b	0,1
	dc.l	0,Print1MsgPort
	dc.w	LN_NAME
InfoWins:
	dc.l	'Wins'
	dc.b	I_WINDOW,$10
	dc.l	IntBase
	dc.w	ib_ActiveScreen
	dc.l	InfNextWindow,HeaderWindow,FormatWindow
	dc.l	'wins'
	dc.b	0,0
	dc.l	NotNodeWindow,Print1Window
	dc.w	wd_Title
InfoScrs:
	dc.l	'Scrs'
	dc.b	I_SCREEN,$10
	dc.l	IntBase
	dc.w	ib_ActiveScreen
	dc.l	InfNextScreen,HeaderScreen,FormatScreen
	dc.l	'scrs'
	dc.b	0,0
	dc.l	NotNodeScreen,Print1Screen
	dc.w	sc_Title
InfoFont:
	dc.l	'Font'
	dc.b	I_FONT,$10
	dc.l	Gfxbase
	dc.w	gb_TextFonts
	dc.l	InfNextNode,HeaderFont,FormatFont
	dc.l	'font'
	dc.b	0,1
	dc.l	FontInfoList,Print1Font
	dc.w	LN_NAME
InfoDosd:
	dc.l	'Dosd'
	dc.b	I_DOSDEV,-1
	dc.l	InfRoutDosd
	dc.w	0
	dc.l	InfNextDosd,HeaderDosDev,FormatDosDev
	dc.l	'dosd'
	dc.b	0,1
	dc.l	0,Print1DosDev
	dc.w	$8000+dl_Name
InfoFunc:
	dc.l	'Func'
	dc.b	I_FUNCMON,$00
	dc.l	FunctionsMon
	dc.w	0
	dc.l	InfNextNode,HeaderFuncMon,FormatFuncMon
	dc.l	'func'
	dc.b	0,0
	dc.l	NodeFuncMon,Print1FuncMon
	dc.w	LN_NAME
InfoSema:
	dc.l	'Sema'
	dc.b	I_SEMAPH,$10
	dc.l	SysBase
	dc.w	SemaphoreList
	dc.l	InfNextNode,HeaderSemaph,FormatSemaph
	dc.l	'sema'
	dc.b	0,1
	dc.l	0,Print1Semaphore
	dc.w	LN_NAME
InfoResm:
	dc.l	'Resm'
	dc.b	I_RESMOD,$11
	dc.l	SysBase
	dc.w	ResModules
	dc.l	InfNextResm,HeaderResMod,FormatResMod
	dc.l	'resm'
	dc.b	0,1
	dc.l	0,Print1ResMod
	dc.w	RT_NAME
InfoFils:
	dc.l	'Fils'
	dc.b	I_FILES,-3
	dc.l	InfRoutFile
	dc.w	0
	dc.l	0,HeaderFiles,FormatFiles
	dc.l	'fils'
	dc.b	0,1
	dc.l	0,Print1File
	dc.w	0
InfoLock:
	dc.l	'Lock'
	dc.b	I_LOCKS,-3
	dc.l	InfRoutLock
	dc.w	0
	dc.l	0,HeaderLocks,FormatLocks
	dc.l	'lock'
	dc.b	0,1
	dc.l	0,Print1Lock
	dc.w	0
InfoIHan:
	dc.l	'IHan'
	dc.b	I_INPUTH,-1
	dc.l	InfRoutInputH
	dc.w	0
	dc.l	InfNextNode,HeaderInputH,FormatInputH
	dc.l	'ihan'
	dc.b	0,1
	dc.l	0,Print1InputH
	dc.w	LN_NAME
InfoFDFi:
	dc.l	'FDFi'
	dc.b	I_FDFILES,$00
	dc.l	FDFiles
	dc.w	0
	dc.l	InfNextNode,HeaderFDFiles,FormatFDFiles
	dc.l	'fdfi'
	dc.b	0,0
	dc.l	NodeFDFiles,Print1FDFile
	dc.w	LN_NAME
InfoAtta:
	dc.l	'Attc'
	dc.b	I_ATTACH,$00
	dc.l	KeyAttach
	dc.w	0
	dc.l	InfNextNode,HeaderAttach,FormatAttach
	dc.l	'attc'
	dc.b	0,1
	dc.l	0,Print1Attach
	dc.w	LN_NAME
InfoCrsh:
	dc.l	'Crsh'
	dc.b	I_CRASH,$00
	dc.l	Crashes
	dc.w	0
	dc.l	InfNextNode,HeaderCrash,FormatCrash
	dc.l	'crsh'
	dc.b	0,1
	dc.l	0,Print1Crashed
	dc.w	LN_NAME
InfoGraf:
	dc.l	'Graf'
	dc.b	I_GRAFBASE,-2
	dc.l	Gfxbase
	dc.w	0
	dc.l	GraphicsBaseList,0,0
	dc.l	'graf'
	dc.b	0,0
	dc.l	0,0
	dc.w	0
InfoDbug:
	dc.l	'Dbug'
	dc.b	I_DEBUG,$00
	dc.l	DebugList
	dc.w	0
	dc.l	InfNextNode,HeaderDebug,FormatDebug
	dc.l	'dbug'
	dc.b	0,0
	dc.l	NodeDebug,Print1Debug
	dc.w	LN_NAME
InfoStru:
	dc.l	'Stru'
	dc.b	I_STRUCT,$00
	dc.l	StructDefs
	dc.w	0
	dc.l	InfNextNode,HeaderStruct,FormatStruct
	dc.l	'stru'
	dc.b	0,1
	dc.l	0,Print1Struct
	dc.w	LN_NAME
 IFD	D20
InfoPubS:
	dc.l	'PubS'
	dc.b	I_PUBSCR,-1
	dc.l	InfRoutPubScr
	dc.w	0
	dc.l	InfNextNode,HeaderPubScr,FormatPubScr
	dc.l	'pubs'
	dc.b	0,1
	dc.l	PubScrInfoList,Print1PubScr
	dc.w	LN_NAME
InfoMoni:
	dc.l	'Moni'
	dc.b	I_MONITOR,$10
	dc.l	Gfxbase
	dc.w	gb_MonitorList
	dc.l	InfNextNode,HeaderMoni,FormatMoni
	dc.l	'moni'
	dc.b	0,1
	dc.l	MoniInfoList,Print1Moni
	dc.w	XLN_NAME
 ENDC
InfoConf:
	dc.l	'Conf'
	dc.b	I_CONFIG,$00
	dc.l	0
	dc.w	0
	dc.l	InfNextConfig,HeaderConfig,FormatConfig
	dc.l	'conf'
	dc.b	0,0
	dc.l	NodeConfig,Print1Config
	dc.w	LN_NAME
InfoLWin:
	dc.l	'LWin'
	dc.b	I_LWIN,$10
	dc.l	myGlobal
	dc.w	Global_PWList
	dc.l	InfNextLW,HeaderLWin,FormatLWin
	dc.l	'lwin'
	dc.b	0,1
	dc.l	LWinInfoList,Print1LWin
	dc.w	LN_NAME
InfoPWin:
	dc.l	'PWin'
	dc.b	I_PWIN,$10
	dc.l	myGlobal
	dc.w	Global_PWList
	dc.l	InfNextNode,HeaderPWin,FormatPWin
	dc.l	'pwin'
	dc.b	0,1
	dc.l	PWinInfoList,Print1PWin
	dc.w	LN_NAME

	;***
	;End of ListBase
	;***

InfoSent:
	dc.l	0

InfoNode:
	dc.l	'????'
	dc.b	0,$00
	dc.l	0
	dc.w	0
	dc.l	InfNextNode,HeaderNode,FormatNode
	dc.l	'????'
	dc.b	0,0
	dc.l	0,Print1Node
	dc.w	LN_NAME

	;ReAllocMem block for List lock (patch to make it work for AmigaDOS 2.04
	;and later)
LockListBlock:	dc.l	0
LockListPtr:	dc.l	0

	;Format string for PrintNNP
FormatPNNP:
		FF		ls,20,str_,":",X_,0
		FF		bx,0,spc,2,end,0

FormatP1FM:
		FF		ls,20,str_,":",X_,0,end,0

ProcessString:	dc.b	"PROC",0
TaskString:		dc.b	"TASK",0
ReadLString:	dc.b	"READ",0
WriteLString:	dc.b	"WRITE",0

	;Strings for the functionmonitor
FuncMonStrings:dc.b	"NORMLED FULLFLEDCOLD????????????"
					dc.b	"EXEC????????????????????????????"
					dc.b	"SCRA",0
	;Modes
DbModesString:	dc.b	"NONE TRACEEXEC FLOWTROUT "
DbSModesString:dc.b	"NORM TTRACCRASHBREAKTBRK WAIT ERROR"
DbTModesString:dc.b	"NORM AFTERSTEP UNTILREG  COND BRNCHFORCE"

FormatAFRegs:
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
		FF		str_,"A5:",X,0,nlend,0

	;Commandline options for 'struct'
OptStructStr:	dc.b	"NARLCSWP",0
		EVEN
OptStructRout:	dc.l	StructNewST,StructAddST,StructRemST,StructListST
					dc.l	StructChangeSizeST,StructSortST,StructWriteST
					dc.l	StructAppendST,StructErrorST

HeaderSField:	dc.b	"Structure field name: Offset Type Size",10,0
FormatSField:
		FF		ls,20,str_,":",d_,6
		FF		d_,4,d,4,nlend,0

	;Header lines for nodes and other structures
 IFD	D20
HeaderPubScr:	dc.b	"PubScreen node name : Node     Pri Screen   Visitors SigTask  SigBit",10,0
FormatPubScr:
		FF		X_,0,d,5,spc,4,X_,0
		FF		d,5,end,0

HeaderMoni:		dc.b	"Monitor node name   : Node     Pri SubSys SubType Library  Init",10,0
FormatMoni:
		FF		d,3,spc,4,d,3,spc,5
		FF		X_,0,X,0,end,0
 ENDC

HeaderStruct:	dc.b	"Struct node name    : Node     Pri InfoBlock Strings  Length",10,0
FormatStruct:
		FF		X,0,spc,2,X_,0,d,6
		FF		end,0

HeaderNode:		dc.b	"Node name           : Node     Pri",10,0
FormatNode:		dc.b	0

HeaderTask:		dc.b	"Task node name      : Node     Pri   StackU   StackS Stat Command         Acc",10,0
FormatTask:
		FF		D_,8,D_,8,s_,4,ls,11
		FF		s_,4
FormatTask2:
		FF		lD,5,end,0

HeaderInterr:	dc.b	"Interrupt node name : Node     Pri Data     Code",10,0
FormatInterr:
		FF		X_,0,X,0,end,0

HeaderDevice:	dc.b	"Device node name    : Node     Pri NegSize PosSize Sum      OpenCnt",10,0
FormatDevice:
		FF		d_,7,d_,7,X_,8,d,7
		FF		end,0

HeaderMsgPort:	dc.b	"MsgPort node name   : Node     Pri SigBit SigTask",10,0
FormatMsgPort:
		FF		d_,6,X,0,end,0

HeaderResource:dc.b	"Resource node name  : Node     Pri NegSize PosSize Sum      OpenCnt",10,0
FormatResource	equ	FormatDevice

HeaderLibrary:	dc.b	"Library node name   : Node     Pri NegSize PosSize Sum      OpenCnt",10,0
FormatLibrary	equ	FormatDevice

HeaderMemory:	dc.b	"Memory node name    : Node     Pri  Attr First    Lower    Upper    Free",10,0
FormatMemoryL:
		FF		spc,2,X_,0,D,10,nlend,0
FormatMemory:
		FF		d_,5,X_,0,X_,0,X_,0
		FF		lD,9,end,0

HeaderFont:		dc.b	"Font node name      : Node     Pri YSize XSize Style LoChar HiChar",10,0
FormatFont:
		FF		d_,5,d_,5,d_,5,d_,6
		FF		d,6,end,0

HeaderSemaph:	dc.b	"Semaphore node name : Node     Pri NestCount QueueCount Owner",10,0
FormatSemaph:
		FF		d_,9,d_,10,X,0,end,0

HeaderWindow:	dc.b	"Window name         : Address  Left  Top Width Height WScreen",10,0
FormatWindow:
		FF		d_,4,d_,4,d_,5,d_,6
		FF		X,0,end,0

HeaderScreen:	dc.b	"Screen name         : Address  Left  Top Width Height FirstWindow",10,0
FormatScreen	equ	FormatWindow

HeaderDosDev:	dc.b	"Dos device name     : Address  Type     Task     Lock     LockList DiskType",10,0
FormatDosDev:
		FF		ls,20,str_,":",X_,0
		FF		X_,0,X_,0,X_,0,X_,0
		FF		X,0,end,0

HeaderFuncMon:	dc.b	"Function monitor    : Node     Library  Offset Traptask    Count Type",10,0
FormatFuncMon:
		FF		ls,20,str_,":",X_,0
		FF		X_,0,d_,6,X,0,spc,2
		FF		D_,7,s,4,end,0

HeaderDebug:	dc.b	"Debug task          : Node     Task     InitPC   TD ID Mode  SMode TMode",10,0
FormatDebug:
		FF		ls,20,str_,":",X_,0
		FF		X_,0,X_,0,bx_,0,bx_,0
		FF		s_,5,s_,5,s,5,end,0

HeaderBreakP:	dc.b	"Node     Number Where    UsageCnt Type Condition",10,0
FormatBreakP:
		FF		X_,0,d,5,spc,2,X_,0
		FF		D,8,spc,3,c,0,spc,2
		FF		ls,36,nlend,0

HeaderFDFiles:	dc.b	"Library name        : Node     Library   Funcs",10,0
FormatFDFiles:
		FF		ls,20,str_,":",X_,0,X_,0
		FF		d,6,end,0

HeaderAttach:	dc.b	"Node     Code Qualifier Command",10,0
FormatAttach:
		FF		X_,0,d,4,spc,5,d_,5
		FF		str,"'",ls,52,str,"'",end,0

HeaderCrash:	dc.b	"Node     Task     TrapNr   2ndInfo  Guru",10,0
FormatCrash:
		FF		X_,0,X_,0,X_,0,X,0
		FF		spc,2,d,3,end,0

HeaderResMod:	dc.b	"Resident name       : Address  Pri Version Flags IDString",10,0
FormatResMod:
		FF		ls,20,str_,":",X_,0,bx,0
		FF		spc,2,d_,7,bx,0,spc,4
		FF		s,29,end,0

HeaderFiles:	dc.b	"FileName                                : Lock     Access     Size      Key",10,0
FormatFiles:
		FF		ls,40,str_,":",X_,0,s_,6
		FF		D_,8,D,8,end,0
FormatNotMnt:
		FF		ls,40,str_,":",str_,"not",str,"mounted!"
		FF		end,0

HeaderLocks		equ	HeaderFiles
FormatLocks		equ	FormatFiles

HeaderInputH:	dc.b	"InputHandler Name   : Node     Pri Data     Code",10,0
FormatInputH:
		FF		X_,0,X,0,end,0

HeaderConfig:	dc.b	"Config Name         : Node     Pri Flags BAddr    BSize    Driver",10,0
FormatConfig:
		FF		spc,1,x_,0,X_,0,X_,0
		FF		X_,0,end,0

HeaderGadget:	dc.b	"Gadget ptr : left right width height Render   Text     SpecInfo ID",10,0
FormatGadget:
		FF		X,0,spc,3,str_,":",d_,4
		FF		d_,5,d_,5,d_,6,X_,0
		FF		X_,0,X_,0,d,5,nlend,0

HeaderLWin:		dc.b	"Logical Window      : Node     PWin     width height  col  row viscol visrow",10,0
FormatLWin:
		FF		ls,20,str_,":",X_,0,X_,0
		FF		d_,5,d_,6,d_,4,d_,4
		FF		d_,6,d,6,end,0

HeaderPWin:		dc.b	"Physical Window     : Node     Window   Code Qualifier",10,0
FormatPWin:
		FF		ls,20,str_,":",X_,0,X_,0
		FF		x_,0,x,0,end,0

	;Messages for 'Owner' command
MsgFoundInTCB:				dc.b	"Found in TCB",0
MsgFoundInETCB:			dc.b	"Found in Extended TCB",0
MsgFoundInStack:			dc.b	"Found in stack",0
MsgFoundInMemEStruct:	dc.b	"Found in TC_MEMENTRY structures",0
MsgFoundInMemEMem:		dc.b	"Found in TC_MEMENTRY memory",0
MsgFoundInProcess:		dc.b	"Found in process structure",0
MsgFoundInSegList:		dc.b	"Found in SegList",0
MsgFoundInCli:				dc.b	"Found in Cli structure",0
MsgFoundInModule:			dc.b	"Found in Module segment list",0

	;Bit Field strings
	;bfGadgetType
bfgt_SYSGADGET:	dc.b	"SYSGADGET",0
bfgt_SCRGADGET:	dc.b	"SCRGADGET",0
bfgt_GZZGADGET:	dc.b	"GZZGADGET",0
bfgt_REQGADGET:	dc.b	"REQGADGET",0
bfgt_SIZING:		dc.b	"SIZING",0
bfgt_WDRAGGING:	dc.b	"WDRAGGING",0
bfgt_SDRAGGING:	dc.b	"SDRAGGING",0
bfgt_WUPFRONT:		dc.b	"WUPFRONT",0
bfgt_SUPFRONT:		dc.b	"SUPFRONT",0
bfgt_WDOWNBACK:	dc.b	"WDOWNBACK",0
bfgt_SDOWNBACK:	dc.b	"SDOWNBACK",0
bfgt_CLOSE:			dc.b	"CLOSE",0
bfgt_BOOLGADGET:	dc.b	"BOOLGADGET",0
bfgt_GADGET0002:	dc.b	"GADGET0002",0
bfgt_PROPGADGET:	dc.b	"PROPGADGET",0
bfgt_STRGADGET:	dc.b	"STRGADGET",0
 IFD	D20
bfgt_CUSTOMGADGET:dc.b	"CUSTOMGADGET",0
 ENDC
	;bfGadgetFlags
bfgf_GADGHCOMP:	dc.b	"GADGHCOMP",0
bfgf_GADGHBOX:		dc.b	"GADGHBOX",0
bfgf_GADGHIMAGE:	dc.b	"GADGHIMAGE",0
bfgf_GADGHNONE:	dc.b	"GADGHNONE",0
bfgf_GADGIMAGE:	dc.b	"GADGIMAGE",0
bfgf_GRELBOTTOM:	dc.b	"GRELBOTTOM",0
bfgf_GRELRIGHT:	dc.b	"GRELRIGHT",0
bfgf_GRELWIDTH:	dc.b	"GRELWIDTH",0
bfgf_GRELHEIGHT:	dc.b	"GRELHEIGHT",0
bfgf_SELECTED:		dc.b	"SELECTED",0
bfgf_DISABLED:		dc.b	"DISABLED",0
 IFD	D20
bfgf_LABELITEXT:	dc.b	"LABELITEXT",0
bfgf_LABELSTRING:	dc.b	"LABELSTRING",0
bfgf_LABELIMAGE:	dc.b	"LABELIMAGE",0
bfgf_TABCYCLE:		dc.b	"TABCYCLE",0
bfgf_STRINGEXT:	dc.b	"STRINGEXT",0
 ENDC
	;bfGadgetActiv
bfga_RELVERIFY:	dc.b	"RELVERIFY",0
bfga_IMMEDIATE:	dc.b	"IMMEDIATE",0
bfga_ENDGADGET:	dc.b	"ENDGADGET",0
bfga_FOLLOWMOUSE:	dc.b	"FOLLOWMOUSE",0
bfga_RIGHTBORDER:	dc.b	"RIGHTBORDER",0
bfga_LEFTBORDER:	dc.b	"LEFTBORDER",0
bfga_TOPBORDER:	dc.b	"TOPBORDER",0
bfga_BOTTOMBORDER:dc.b	"BOTTOMBORDER",0
bfga_TOGGLESELECT:dc.b	"TOGGLESELECT",0
bfga_STRINGCENTER:dc.b	"STRINGCENTER",0
bfga_STRINGRIGHT:	dc.b	"STRINGRIGHT",0
bfga_LONGINT:		dc.b	"LONGINT",0
bfga_ALTKEYMAP:	dc.b	"ALTKEYMAP",0
bfga_BOOLEXTEND:	dc.b	"BOOLEXTEND",0
 IFD	D20
bfga_BORDERSNIFF:	dc.b	"BORDERSNIFF",0
bfga_ACTIVEGADGET:dc.b	"ACTIVEGADGET",0
bfga_STRINGEXT		equ	bfgf_STRINGEXT
 ENDC
	;bfIDCMP:
bfid_SIZEVERIFY:		dc.b	"SIZEVERIFY",0
bfid_NEWSIZE:			dc.b	"NEWSIZE",0
bfid_REFRESHWINDOW:	dc.b	"REFRESHWINDOW",0
bfid_MOUSEBUTTONS:	dc.b	"MOUSEBUTTONS",0
bfid_MOUSEMOVE:		dc.b	"MOUSEMOVE",0
bfid_GADGETDOWN:		dc.b	"GADGETDOWN",0
bfid_GADGETUP:			dc.b	"GADGETUP",0
bfid_REQSET:			dc.b	"REQSET",0
bfid_MENUPICK:			dc.b	"MENUPICK",0
bfid_CLOSEWINDOW:		dc.b	"CLOSEWINDOW",0
bfid_RAWKEY:			dc.b	"RAWKEY",0
bfid_REQVERIFY:		dc.b	"REQVERIFY",0
bfid_REQCLEAR:			dc.b	"REQCLEAR",0
bfid_MENUVERIFY:		dc.b	"MENUVERIFY",0
bfid_NEWPREFS:			dc.b	"NEWPREFS",0
bfid_DISKINSERTED:	dc.b	"DISKINSERTED",0
bfid_DISKREMOVED:		dc.b	"DISKREMOVED",0
bfid_WBENCHMESSAGE:	dc.b	"WBENCHMESSAGE",0
bfid_ACTIVEWINDOW:	dc.b	"ACTIVEWINDOW",0
bfid_INACTIVEWINDOW:	dc.b	"INACTIVEWINDOW",0
bfid_DELTAMOVE:		dc.b	"DELTAMOVE",0
bfid_VANILLAKEY:		dc.b	"VANILLAKEY",0
bfid_INTUITICKS:		dc.b	"INTUITICKS",0
bfid_LONELYMESSAGE:	dc.b	"LONELYMESSAGE",0
 IFD	D20
bfid_IDCMPUPDATE:		dc.b	"IDCMPUPDATE",0
bfid_MENUHELP:			dc.b	"MENUHELP",0
bfid_CHANGEWINDOW:	dc.b	"CHANGEWINDOW",0
 ENDC
	;bfWinFlags:
bfwf_WINDOWSIZING:	dc.b	"WINDOWSIZING",0
bfwf_WINDOWDRAG:		dc.b	"WINDOWDRAG",0
bfwf_WINDOWDEPTH:		dc.b	"WINDOWDEPTH",0
bfwf_WINDOWCLOSE:		dc.b	"WINDOWCLOSE",0
bfwf_SIZEBRIGHT:		dc.b	"SIZEBRIGHT",0
bfwf_SIZEBBOTTOM:		dc.b	"SIZEBBOTTOM",0
bfwf_SMARTREFRESH:	dc.b	"SMARTREFRESH",0
bfwf_SIMPLEREFRESH:	dc.b	"SIMPLEREFRESH",0
bfwf_OTHER_REFRESH:	dc.b	"OTHER_REFRESH",0
bfwf_BACKDROP:			dc.b	"BACKDROP",0
bfwf_REPORTMOUSE:		dc.b	"REPORTMOUSE",0
bfwf_GIMMEZEROZERO:	dc.b	"GIMMEZEROZERO",0
bfwf_BORDERLESS:		dc.b	"BORDERLESS",0
bfwf_ACTIVATE:			dc.b	"ACTIVATE",0
bfwf_WINDOWACTIVE:	dc.b	"WINDOWACTIVE",0
bfwf_INREQUEST:		dc.b	"INREQUEST",0
bfwf_MENUSTATE:		dc.b	"MENUSTATE",0
bfwf_RMBTRAP:			dc.b	"RMBTRAP",0
bfwf_NOCAREREFRESH:	dc.b	"NOCAREREFRESH",0
bfwf_WINDOWREFRESH:	dc.b	"WINDOWREFRESH",0
bfwf_WBENCHWINDOW:	dc.b	"WBENCHWINDOW",0
bfwf_WINDOWTICKED:	dc.b	"WINDOWTICKED",0
 IFD	D20
bfwf_VISITOR:			dc.b	"VISITOR",0
bfwf_ZOOMED:			dc.b	"ZOOMED",0
bfwf_HASZOOM:			dc.b	"HASZOOM",0
 ENDC
	;bfScrFlags:
bfsf_WBENCHSCREEN:	dc.b	"WBENCHSCREEN",0
bfsf_CUSTOMSCREEN:	dc.b	"CUSTOMSCREEN",0
bfsf_SHOWTITLE:		dc.b	"SHOWTITLE",0
bfsf_BEEPING:			dc.b	"BEEPING",0
bfsf_CUSTOMBITMAP:	dc.b	"CUSTOMBITMAP",0
bfsf_SCREENBEHIND:	dc.b	"SCREENBEHIND",0
bfsf_SCREENQUIET:		dc.b	"SCREENQUIET",0
 IFD	D20
bfsf_SCREENHIRES:		dc.b	"SCREENHIRES",0
bfsf_AUTOSCROLL:		dc.b	"AUTOSCROLL",0
 ENDC

	EVEN
	;Bit fields
bfGadgetType:	dc.l	$8000,$8000,bfgt_SYSGADGET,$4000,$4000,bfgt_SCRGADGET
					dc.l	$2000,$2000,bfgt_GZZGADGET,$1000,$1000,bfgt_REQGADGET
					dc.l	$00f0,$0010,bfgt_SIZING,$00f0,$0020,bfgt_WDRAGGING
					dc.l	$00f0,$0030,bfgt_SDRAGGING,$00f0,$0040,bfgt_WUPFRONT
					dc.l	$00f0,$0050,bfgt_SUPFRONT,$00f0,$0060,bfgt_WDOWNBACK
					dc.l	$00f0,$0070,bfgt_SDOWNBACK,$00f0,$0080,bfgt_CLOSE
					dc.l	$0007,$0001,bfgt_BOOLGADGET,$0007,$0002,bfgt_GADGET0002
					dc.l	$0007,$0003,bfgt_PROPGADGET,$0007,$0004,bfgt_STRGADGET
 IFD	D20
					dc.l	$0007,$0005,bfgt_CUSTOMGADGET
 ENDC
					dc.l	0
bfGadgetFlags:	dc.l	$0003,$0000,bfgf_GADGHCOMP,$0003,$0001,bfgf_GADGHBOX
					dc.l	$0003,$0002,bfgf_GADGHIMAGE,$0003,$0003,bfgf_GADGHNONE
					dc.l	$0004,$0004,bfgf_GADGIMAGE,$0008,$0008,bfgf_GRELBOTTOM
					dc.l	$0010,$0010,bfgf_GRELRIGHT,$0020,$0020,bfgf_GRELWIDTH
					dc.l	$0040,$0040,bfgf_GRELHEIGHT,$0080,$0080,bfgf_SELECTED
					dc.l	$0100,$0100,bfgf_DISABLED
 IFD	D20
					dc.l	$3000,$0000,bfgf_LABELITEXT,$3000,$1000,bfgf_LABELSTRING
					dc.l	$3000,$2000,bfgf_LABELIMAGE,$0200,$0200,bfgf_TABCYCLE
					dc.l	$0400,$0400,bfgf_STRINGEXT
 ENDC
					dc.l	0
bfGadgetActiv:	dc.l	$0001,$0001,bfga_RELVERIFY,$0002,$0002,bfga_IMMEDIATE
					dc.l	$0004,$0004,bfga_ENDGADGET,$0008,$0008,bfga_FOLLOWMOUSE
					dc.l	$0010,$0010,bfga_RIGHTBORDER,$0020,$0020,bfga_LEFTBORDER
					dc.l	$0040,$0040,bfga_TOPBORDER,$0080,$0080,bfga_BOTTOMBORDER
					dc.l	$0100,$0100,bfga_TOGGLESELECT,$0200,$0200,bfga_STRINGCENTER
					dc.l	$0400,$0400,bfga_STRINGRIGHT,$0800,$0800,bfga_LONGINT
					dc.l	$1000,$1000,bfga_ALTKEYMAP,$2000,$2000,bfga_BOOLEXTEND
 IFD	D20
					dc.l	$8000,$8000,bfga_BORDERSNIFF,$4000,$4000,bfga_ACTIVEGADGET
					dc.l	$4000,$4000,bfga_STRINGEXT
 ENDC
					dc.l	0
bfIDCMP:			dc.l	$0001,$0001,bfid_SIZEVERIFY,$0002,$0002,bfid_NEWSIZE
					dc.l	$0004,$0004,bfid_REFRESHWINDOW,$0008,$0008,bfid_MOUSEBUTTONS
					dc.l	$0010,$0010,bfid_MOUSEMOVE,$0020,$0020,bfid_GADGETDOWN
					dc.l	$0040,$0040,bfid_GADGETUP,$0080,$0080,bfid_REQSET
					dc.l	$0100,$0100,bfid_MENUPICK,$0200,$0200,bfid_CLOSEWINDOW
					dc.l	$0400,$0400,bfid_RAWKEY,$0800,$0800,bfid_REQVERIFY
					dc.l	$1000,$1000,bfid_REQCLEAR,$2000,$2000,bfid_MENUVERIFY
					dc.l	$4000,$4000,bfid_NEWPREFS,$8000,$8000,bfid_DISKINSERTED
					dc.l	$00010000,$00010000,bfid_DISKREMOVED,$00020000,$00020000,bfid_WBENCHMESSAGE
					dc.l	$00040000,$00040000,bfid_ACTIVEWINDOW,$00080000,$00080000,bfid_INACTIVEWINDOW
					dc.l	$00100000,$00100000,bfid_DELTAMOVE,$00200000,$00200000,bfid_VANILLAKEY
					dc.l	$00400000,$00400000,bfid_INTUITICKS,$80000000,$80000000,bfid_LONELYMESSAGE
 IFD	D20
					dc.l	$00800000,$00800000,bfid_IDCMPUPDATE,$01000000,$01000000,bfid_MENUHELP
					dc.l	$02000000,$02000000,bfid_CHANGEWINDOW
 ENDC
					dc.l	0
bfWinFlags:		dc.l	$0001,$0001,bfwf_WINDOWSIZING,$0002,$0002,bfwf_WINDOWDRAG
					dc.l	$0004,$0004,bfwf_WINDOWDEPTH,$0008,$0008,bfwf_WINDOWCLOSE
					dc.l	$0010,$0010,bfwf_SIZEBRIGHT,$0020,$0020,bfwf_SIZEBBOTTOM
					dc.l	$00c0,$0000,bfwf_SMARTREFRESH,$00c0,$0040,bfwf_SIMPLEREFRESH
					dc.l	$00c0,$0080,bfwf_OTHER_REFRESH
					dc.l	$0100,$0100,bfwf_BACKDROP,$0200,$0200,bfwf_REPORTMOUSE
					dc.l	$0400,$0400,bfwf_GIMMEZEROZERO,$0800,$0800,bfwf_BORDERLESS
					dc.l	$1000,$1000,bfwf_ACTIVATE,$2000,$2000,bfwf_WINDOWACTIVE
					dc.l	$4000,$4000,bfwf_INREQUEST,$8000,$8000,bfwf_MENUSTATE
					dc.l	$00010000,$00010000,bfwf_RMBTRAP,$00020000,$00020000,bfwf_NOCAREREFRESH
					dc.l	$01000000,$01000000,bfwf_WINDOWREFRESH,$02000000,$02000000,bfwf_WBENCHWINDOW
					dc.l	$04000000,$04000000,bfwf_WINDOWTICKED
 IFD	D20
					dc.l	$08000000,$08000000,bfwf_VISITOR,$10000000,$10000000,bfwf_ZOOMED
					dc.l	$20000000,$20000000,bfwf_HASZOOM
 ENDC
					dc.l	0
bfScrFlags:		dc.l	$000f,$0001,bfsf_WBENCHSCREEN,$000f,$000f,bfsf_CUSTOMSCREEN
					dc.l	$0010,$0010,bfsf_SHOWTITLE,$0020,$0020,bfsf_BEEPING
					dc.l	$0040,$0040,bfsf_CUSTOMBITMAP,$0080,$0080,bfsf_SCREENBEHIND
					dc.l	$0100,$0100,bfsf_SCREENQUIET
 IFD	D20
					dc.l	$0200,$0200,bfsf_SCREENHIRES,$4000,$4000,bfsf_AUTOSCROLL
 ENDC
					dc.l	0

	;Strings for default structures in 'stru' list
WindowString:	dc.b	"wins",0
ScreenString:	dc.b	"scrs",0
ProcString:		dc.b	"proc",0
CliString:		dc.b	"cli",0
TasksString:	dc.b	"task",0
IOReqString:	dc.b	"ioreq",0
ConfigString:	dc.b	"conf",0
NodeString:		dc.b	"node",0

	;Headers for info command (Task node)
HTC_SIGALLOC:	dc.b	"SigAlloc",0
HTC_SIGWAIT:	dc.b	"SigWait",0
HTC_SIGRECVD:	dc.b	"SigRecvd",0
HTC_SIGEXCEPT:	dc.b	"SigExcept",0
HTC_TRAPALLOC:	dc.b	"TrapAlloc",0
HTC_TRAPABLE:	dc.b	"TrapAble",0
HTC_EXCEPTDATA:dc.b	"ExceptData",0
HTC_EXCEPTCODE:dc.b	"ExceptCode",0
HTC_TRAPDATA:	dc.b	"TrapData",0
HTC_TRAPCODE:	dc.b	"TrapCode",0
HTC_SPLOWER:	dc.b	"SpLower",0
HTC_SPUPPER:	dc.b	"SpUpper",0
HTC_SPREG:		dc.b	"SpReg",0
HTC_IDNESTCNT:	dc.b	"IDNestCnt",0
HTC_TDNESTCNT:	dc.b	"TDNestCnt",0
HTC_MEMENTRY:	dc.b	"MemEntry",0
HTC_SWITCH:		dc.b	"Switch",0
HTC_LAUNCH:		dc.b	"Launch",0
HTC_FLAGS		dc.b	"Flags",0
HTC_Userdata:	dc.b	"UserData",0
	;Library node
HLIB_VERSION:	dc.b	"Vers",0
HLIB_REVISION:	dc.b	"Rev",0
HLIB_IDSTRING:	dc.b	"IDString",0
	;Font node
Htf_Flags		equ	HTC_FLAGS
Htf_Baseline:	dc.b	"Baseline",0
Htf_BoldSmear:	dc.b	"BoldSmear",0
Htf_Accessors:	dc.b	"Accessors",0
Htf_CharData:	dc.b	"CharData",0
Htf_Modulo:		dc.b	"Modulo",0
Htf_CharLoc:	dc.b	"CharLoc",0
Htf_CharSpace:	dc.b	"CharSpace",0
Htf_CharKern:	dc.b	"CharKern",0
	;Cli structure
Hcli_Result2:			dc.b	"rc2",0
Hcli_ReturnCode:		dc.b	"rc",0
Hcli_CommandDir:		dc.b	"CmdDir",0
Hcli_StandardInput:	dc.b	"StdIn",0
Hcli_StandardOutput:	dc.b	"StdOut",0
Hcli_Background:		dc.b	"Backgrnd",0
Hcli_Interactive:		dc.b	"Interactive",0
Hcli_SetName:			dc.b	"SetName",0
Hcli_Prompt:			dc.b	"Prompt",0
Hcli_Module:			dc.b	"Module",0
Hcli_CurrentInput:	dc.b	"CurIn",0
Hcli_CurrentOutput:	dc.b	"CurOut",0
Hcli_DefaultStack:	dc.b	"DefStack",0
Hcli_CommandFile:		dc.b	"CmdFile",0
Hcli_FailLevel:		dc.b	"FailLevel",0
	;Process node
Hpr_SegList:			dc.b	"SegList",0
Hpr_StackSize:			dc.b	"StackSize",0
Hpr_TaskNum:			dc.b	"TaskNum",0
Hpr_StackBase:			dc.b	"StackBase",0
Hpr_Result2				equ	Hcli_Result2
Hpr_CurrentDir:		dc.b	"CurDir",0
Hpr_CIS:					dc.b	"CIS",0
Hpr_COS:					dc.b	"COS",0
Hpr_ConsoleTask:		dc.b	"ConsoleTask",0
Hpr_FileSystemTask:	dc.b	"FileSystemTask",0
Hpr_CLI:					dc.b	"CLI",0
Hpr_ReturnAddr:		dc.b	"ReturnAddr",0
Hpr_PktWait:			dc.b	"PktWait",0
Hpr_WindowPtr:			dc.b	"WindowPtr",0
 IFD	D20
Hpr_HomeDir:			dc.b	"HomeDir",0
Hpr_Flags				equ	HTC_FLAGS
Hpr_ExitCode:			dc.b	"ExitCode",0
Hpr_ExitData:			dc.b	"ExitData",0
Hpr_Arguments:			dc.b	"Arguments",0
Hpr_LocalVars:			dc.b	"LocalVars",0
Hpr_ShellPrivate:		dc.b	"ShellPrivate",0
Hpr_CES:					dc.b	"CES",0
 ENDC
	;Window structure
Hwd_MinWidth:		dc.b	"MinWidth",0
Hwd_MinHeight:		dc.b	"MinHeight",0
Hwd_MaxWidth:		dc.b	"MaxWidth",0
Hwd_MaxHeight:		dc.b	"MaxHeight",0
Hwd_Flags			equ	Htf_Flags
Hwd_MenuStrip:		dc.b	"MenuStrip",0
Hwd_FirstRequest:	dc.b	"FirstReques",0
Hwd_DMRequest:		dc.b	"DMRequest",0
Hwd_ReqCount:		dc.b	"ReqCount",0
Hwd_RPort:			dc.b	"RPort",0
Hwd_FirstGadget:	dc.b	"FirstGadget",0
Hwd_Pointer:		dc.b	"Pointer",0
Hwd_IDCMPFlags:	dc.b	"IDCMPFlags",0
Hwd_UserPort:		dc.b	"UserPort",0
Hwd_WindowPort:	dc.b	"WindowPort",0
Hwd_MessageKey:	dc.b	"MessageKey",0
Hwd_DetailPen:		dc.b	"DetailPen",0
Hwd_BlockPen:		dc.b	"BlockPen",0
Hwd_CheckMark:		dc.b	"CheckMark",0
Hwd_ExtData:		dc.b	"ExtData",0
Hwd_UserData		equ	HTC_Userdata
Hwd_Flags2:			dc.b	"Flags: ",0
Hwd_IDCMP2:			dc.b	"IDCMP: ",0
Hwd_ScreenTitle:	dc.b	"ScreenTitle",0
Hwd_PtrHeight:		dc.b	"PtrHeight",0
Hwd_PtrWidth:		dc.b	"PtrWidth",0
Hwd_XOffset:		dc.b	"XOffset",0
Hwd_YOffset:		dc.b	"YOffset",0
Hwd_BorderLeft:	dc.b	"BorderLeft",0
Hwd_BorderTop:		dc.b	"BorderTop",0
Hwd_BorderRight:	dc.b	"BorderRight",0
Hwd_BorderBottom:	dc.b	"BorderBottom",0
Hwd_BorderRPort:	dc.b	"BorderRPort",0
Hwd_Parent:			dc.b	"Parent",0
Hwd_Descendant:	dc.b	"Descendant",0
Hwd_GZZMouseX:		dc.b	"GZZMouseX",0
Hwd_GZZMouseY:		dc.b	"GZZMouseY",0
Hwd_GZZWidth:		dc.b	"GZZWidth",0
Hwd_GZZHeight:		dc.b	"GZZHeight",0
Hwd_IFont:			dc.b	"IFont",0
 IFD	D20
Hwd_MoreFlags:		dc.b	"MoreFlags",0
 ENDC
	;Screen structure
Hsc_Flags			equ	Htf_Flags
Hsc_Font:			dc.b	"Font",0
Hsc_ViewPort:		dc.b	"ViewPort",0
Hsc_RastPort:		dc.b	"RastPort",0
Hsc_BitMap:			dc.b	"BitMap",0
Hsc_FirstGadget	equ	Hwd_FirstGadget
Hsc_DetailPen		equ	Hwd_DetailPen
Hsc_BlockPen		equ	Hwd_BlockPen
Hsc_ExtData			equ	Hwd_ExtData
Hsc_UserData		equ	Hwd_UserData
Hsc_Flags2			equ	Hwd_Flags2
Hsc_DefaultTitle:	dc.b	"DefaultTitle",0
Hsc_BarHeight:		dc.b	"BarHeight",0
Hsc_BarVBorder:	dc.b	"BarVBorder",0
Hsc_BarHBorder:	dc.b	"BarHBorder",0
Hsc_MenuVBorder:	dc.b	"MenuVBorder",0
Hsc_MenuHBorder:	dc.b	"MenuHBorder",0
Hsc_WBorTop:		dc.b	"WBorTop",0
Hsc_WBorLeft:		dc.b	"WBorLeft",0
Hsc_WBorRight:		dc.b	"WBorRight",0
Hsc_WBorBottom:	dc.b	"WBorBottom",0
Hsc_LayerInfo:		dc.b	"LayerInfo",0
Hsc_BarLayer:		dc.b	"BarLayer",0
	;Gadget structure
Hgg_Flags2			dc.b	"Flags      : ",0
Hgg_Activation2:	dc.b	"Activation : ",0
Hgg_GadgetType2:	dc.b	"Type       : ",0
	;For IORequest
HIORequest:		dc.b	"IORequest",0
HLN_SUCC:		dc.b	"Succ",0
HLN_PRED:		dc.b	"Pred",0
HLN_TYPE:		dc.b	"Type",0
HLN_PRI:			dc.b	"Pri",0
HLN_NAME:		dc.b	"Name",0
HMN_REPLYPORT:	dc.b	"ReplyPort",0
HMN_LENGTH:		dc.b	"MN_Length",0
HIO_DEVICE:		dc.b	"Device",0
HIO_UNIT:		dc.b	"Unit",0
HIO_COMMAND:	dc.b	"Command",0
HIO_FLAGS		equ	HTC_FLAGS
HIO_ERROR:		dc.b	"Error",0
HIO_ACTUAL:		dc.b	"Actual",0
HIO_LENGTH		dc.b	"Length",0
HIO_DATA:		dc.b	"Data",0
HIO_OFFSET:		dc.b	"Offset",0
	;For ConfigDev structure
Hcd_SlotAddr:		dc.b	"SlotAddr",0
Hcd_SlotSize:		dc.b	"SlotSize",0
Hcd_NextCD:			dc.b	"NextCD",0
Her_Type:			dc.b	"er_Type",0
Her_Product:		dc.b	"er_Product",0
Her_Flags:			dc.b	"er_Flags",0
Her_Manufacturer:	dc.b	"er_Manufacturer",0
Her_SerialNumber:	dc.b	"er_SerialNumber",0
Her_InitDiagVec:	dc.b	"er_InitDiagVec",0
 IFD	D20
	;For public screen structure
Hpsn_Flags:			equ	Htf_Flags
Hpsn_Size:			dc.b	"Size",0
	;For monitor structure
Hms_Flags:			equ	Htf_Flags
Hms_ratioh:			dc.b	"ratioh",0
Hms_ratiov:			dc.b	"ratiov",0
Hms_total_rows:	dc.b	"tot_rows",0
Hms_total_colorclocks:			dc.b	"tot_colorclocks",0
Hms_DeniseMaxDisplayColumn:	dc.b	"DeniseMaxDispC",0
Hms_BeamCon0:		dc.b	"BeamCon0",0
Hms_min_row:		dc.b	"min_row",0
Hms_Special:		dc.b	"Special",0
Hms_OpenCount:		dc.b	"OpenCount",0
Hms_transform:		dc.b	"transform",0
Hms_translate:		dc.b	"translate",0
Hms_scale:			dc.b	"scale",0
Hms_xoffset:		dc.b	"xoffset",0
Hms_yoffset:		dc.b	"yoffset",0
Hms_LegalView:		dc.b	"LegalView",0
Hms_maxoscan:		dc.b	"maxoscan",0
Hms_videoscan:		dc.b	"videoscan",0
Hms_DeniseMinDisplayColumn:	dc.b	"DeniseMinDispC",0
Hms_DisplayCompatible:			dc.b	"DispCompatible",0
Hms_DisplayInfoDataBase:		dc.b	"DispInfoDBase",0
Hms_DIDBSemaphore:				dc.b	"DIDBSemaphore",0
 ENDC
;	;For RastPort structure
;Hrp_Layer:			dc.b	"Layer",0
;Hrp_BitMap:			dc.b	"BitMap",0
;Hrp_AreaPtrn:		dc.b	"AreaPtrn",0
;Hrp_TmpRas:			dc.b	"TmpRas",0
;Hrp_AreaInfo:		dc.b	"AreaInfo",0
;Hrp_GelsInfo:		dc.b	"GelsInfo",0
;Hrp_Mask:			dc.b	"Mask",0
;Hrp_FgPen:			dc.b	"FgPen",0
;Hrp_BgPen:			dc.b	"BgPen",0
;Hrp_AOLPen:			dc.b	"AOLPen",0
;Hrp_DrawMode:		dc.b	"DrawMode",0
;Hrp_AreaPtSz:		dc.b	"AreaPtSz",0
;Hrp_linpatcnt:		dc.b	"linpatcnt",0
;Hrp_Dummy:			dc.b	"Dummy",0
;Hrp_Flags			equ	HTC_FLAGS
;Hrp_LinePtrn:		dc.b	"LinePtrn",0
;Hrp_cp_x:			dc.b	"cp_x",0
;Hrp_cp_y:			dc.b	"cp_y",0
;Hrp_minterms:		dc.b	"minterms",0
;Hrp_PenWidth:		dc.b	"PenWidth",0
;Hrp_PenHeight:		dc.b	"PenHeight",0
;Hrp_Font			equ	Hsc_Font
;Hrp_AlgoStyle:		dc.b	"AlgoStyle",0
;Hrp_TxFlags:		dc.b	"TxFlags",0
;Hrp_TxHeight:		dc.b	"TxHeight",0
;Hrp_TxWidth:		dc.b	"TxWidth",0
;Hrp_TxBaseline:	dc.b	"TxBaseline",0
;Hrp_TxSpacing:		dc.b	"TxSpacing",0
;Hrp_RP_User:		dc.b	"RP_User",0
	;For logical window structure
HLogWin_Box:				dc.b	"Box",0
HLogWin_rx:					dc.b	"rx",0
HLogWin_ry:					dc.b	"ry",0
HLogWin_rw:					dc.b	"rw",0
HLogWin_rh:					dc.b	"rh",0
HLogWin_Flags				equ	HTC_FLAGS
HLogWin_TA:					dc.b	"TA",0
HLogWin_Font				equ	Hsc_Font
HLogWin_ocol:				dc.b	"ocol",0
HLogWin_orow:				dc.b	"orow",0
HLogWin_NumLines:			dc.b	"NumLines",0
HLogWin_NumColumns:		dc.b	"NumColumns",0
HLogWin_Buffer:			dc.b	"Buffer",0
HLogWin_File:				dc.b	"File",0
HLogWin_LinesPassed:		dc.b	"LinesPassed",0
HLogWin_Active:			dc.b	"Active",0
HLogWin_TopBorder:		dc.b	"TopBorder",0
HLogWin_rtop:				dc.b	"rtop",0
HLogWin_HiLine:			dc.b	"HiLine",0
HLogWin_SnapHandler:		dc.b	"SnapH",0
HLogWin_ScrollHandler:	dc.b	"ScrollH",0
HLogWin_RefreshHandler:	dc.b	"RefreshH",0
HLogWin_CreateSBHandler:dc.b	"CreateSBH",0
	;For physical window structure
HPhysWin_NewWindow:		dc.b	"NewWindow",0
HPhysWin_BorderLeft		equ	Hwd_BorderLeft
HPhysWin_BorderTop		equ	Hwd_BorderTop
HPhysWin_BorderRight		equ	Hwd_BorderRight
HPhysWin_BorderBottom	equ	Hwd_BorderBottom
HPhysWin_Box:				dc.b	"Box",0
HPhysWin_Global:			dc.b	"Global",0
HPhysWin_LWList:			dc.b	"LWList",0

	EVEN
	;More info lists
	dc.l	LN_SIZE
NodeList:
	DEFLI	LN_SUCC
	DEFLI	LN_PRED
	DEFBI	LN_TYPE
	DEFBI	LN_PRI
	DEFSI	LN_NAME
	dc.l	0,0
	dc.l	IOSTD_SIZE
IOReqInfoList:
	DEFII	IORequest,0
	DEFLI	LN_SUCC
	DEFLI	LN_PRED
	DEFBI	LN_TYPE
	DEFBI	LN_PRI
	DEFSI	LN_NAME
	DEFLI	MN_REPLYPORT
	DEFWI	MN_LENGTH
	DEFLI	IO_DEVICE
	DEFLI	IO_UNIT
	DEFWI	IO_COMMAND
	DEFBI	IO_FLAGS
	DEFBI	IO_ERROR
	DEFLI	IO_ACTUAL
	DEFLI	IO_LENGTH
	DEFLI	IO_DATA
	DEFLI	IO_OFFSET
	dc.l	0,0
 IFD	D20
	dc.l	psn_SIZEOF
PubScrInfoList:
	DEFWI	psn_Flags
	DEFWI	psn_Size
	dc.l	0,0
	dc.l	ms_SIZEOF
MoniInfoList:
	DEFWI	ms_Flags
	DEFLI	ms_ratioh
	DEFLI	ms_ratiov
	DEFWI	ms_total_rows
	DEFWI	ms_total_colorclocks
	DEFWI	ms_DeniseMaxDisplayColumn
	DEFWI	ms_BeamCon0
	DEFWI	ms_min_row
	DEFLI	ms_Special
	DEFWI	ms_OpenCount
	DEFLI	ms_transform
	DEFLI	ms_translate
	DEFLI	ms_scale
	DEFWI	ms_xoffset
	DEFWI	ms_yoffset
	DEFII	ms_LegalView
	DEFLI	ms_maxoscan
	DEFLI	ms_videoscan
	DEFWI	ms_DeniseMinDisplayColumn
	DEFWI	ms_DisplayCompatible
	DEFII	ms_DisplayInfoDataBase
	DEFII	ms_DIDBSemaphore
	dc.l	0,0
 ENDC
	dc.l	TC_SIZE
TaskInfoList:
	DEFBI	TC_IDNESTCNT
	DEFBI	TC_TDNESTCNT
	DEFLI	TC_SIGALLOC
	DEFLI	TC_SIGWAIT
	DEFLI	TC_SIGRECVD
	DEFLI	TC_SIGEXCEPT
	DEFWI	TC_TRAPALLOC
	DEFWI	TC_TRAPABLE
	DEFLI	TC_EXCEPTDATA
	DEFLI	TC_EXCEPTCODE
	DEFLI	TC_TRAPDATA
	DEFLI	TC_TRAPCODE
	DEFLI	TC_SPLOWER
	DEFLI	TC_SPUPPER
	DEFLI	TC_SPREG
	DEFII	TC_MEMENTRY
	DEFLI	TC_SWITCH
	DEFLI	TC_LAUNCH
	DEFBI	TC_FLAGS
	DEFLI	TC_Userdata
	dc.l	0,0
	dc.l	LogWin_SIZE
LWinInfoList:
	DEFLI	LogWin_Box
	DEFWI	LogWin_rx
	DEFWI	LogWin_ry
	DEFWI	LogWin_rw
	DEFWI	LogWin_rh
	DEFLI	LogWin_Flags
	DEFII	LogWin_TA
	DEFLI	LogWin_Font
	DEFWI	LogWin_ocol
	DEFWI	LogWin_orow
	DEFWI	LogWin_NumLines
	DEFWI	LogWin_NumColumns
	DEFLI	LogWin_Buffer
	DEFlI	LogWin_File
	DEFWI	LogWin_LinesPassed
	DEFBI	LogWin_Active
	DEFBI	LogWin_TopBorder
	DEFWI	LogWin_rtop
	DEFWI	LogWin_HiLine
	DEFLI	LogWin_SnapHandler
	DEFLI	LogWin_ScrollHandler
	DEFLI	LogWin_RefreshHandler
	DEFLI	LogWin_CreateSBHandler
	dc.l	0,0
	dc.l	PhysWin_SIZE
PWinInfoList:
	DEFII	PhysWin_NewWindow
	DEFBI	PhysWin_BorderLeft
	DEFBI	PhysWin_BorderTop
	DEFBI	PhysWin_BorderRight
	DEFBI	PhysWin_BorderBottom
	DEFLI	PhysWin_Box
	DEFLI	PhysWin_Global
	DEFII	PhysWin_LWList
	dc.l	0,0
	dc.l	LIB_SIZE
DevsInfoList:
	DEFSI	LIB_IDSTRING
	DEFWI	LIB_VERSION
	DEFWI	LIB_REVISION
	dc.l	0,0
	dc.l	tf_SIZEOF
FontInfoList:
	DEFBI	tf_Flags
	DEFWI	tf_Baseline
	DEFWI	tf_BoldSmear
	DEFWI	tf_Accessors
	DEFLI	tf_CharData
	DEFWI	tf_Modulo
	DEFLI	tf_CharLoc
	DEFLI	tf_CharSpace
	DEFLI	tf_CharKern
	dc.l	0,0
	dc.l	cli_SIZEOF
CliInfoList:
	DEFLI	cli_Result2
	DEFLI	cli_ReturnCode
	DEFlI	cli_CommandDir
	DEFlI	cli_StandardInput
	DEFlI	cli_StandardOutput
	DEFlI	cli_CurrentInput
	DEFlI	cli_CurrentOutput
	DEFLI	cli_Background
	DEFLI cli_Interactive
	DEFLI cli_DefaultStack
	DEFLI cli_FailLevel
	DEFlI	cli_Module
	DEFsI	cli_SetName
	DEFsI	cli_Prompt
	DEFsI cli_CommandFile
	dc.l	0,0
 IFD	D20
	dc.l	pr_SIZEOF
 ENDC
 IFND	D20
	dc.l	pr_HomeDir
 ENDC
ProcInfoList:
	DEFlI	pr_SegList
	DEFLI	pr_StackSize
	DEFLI	pr_TaskNum
	DEFlI	pr_StackBase
	DEFLI	pr_Result2
	DEFlI	pr_CurrentDir
	DEFlI	pr_CIS
	DEFlI	pr_COS
	DEFLI	pr_ConsoleTask
	DEFLI	pr_FileSystemTask
	DEFlI	pr_CLI
	DEFLI	pr_ReturnAddr
	DEFLI	pr_PktWait
	DEFLI	pr_WindowPtr
 IFD	D20
	DEFlI	pr_HomeDir
	DEFLI	pr_Flags
	DEFLI	pr_ExitCode
	DEFLI	pr_ExitData
	DEFII	pr_LocalVars
	DEFLI	pr_ShellPrivate
	DEFlI	pr_CES
	DEFSI	pr_Arguments
 ENDC
	dc.l	0,0
	dc.l	sc_SIZEOF
ScrInfoList:
	DEFWI	sc_Flags
	DEFLI	sc_Font
	DEFII	sc_ViewPort
	DEFII	sc_RastPort
	DEFII	sc_BitMap
	DEFLI	sc_FirstGadget
	DEFSI	sc_DefaultTitle
	DEFBI	sc_DetailPen
	DEFBI	sc_BlockPen
	DEFLI	sc_ExtData
	DEFLI	sc_UserData
	DEFBI	sc_BarHeight
	DEFBI	sc_BarVBorder
	DEFBI	sc_BarHBorder
	DEFBI	sc_MenuVBorder
	DEFBI	sc_MenuHBorder
	DEFBI	sc_WBorTop
	DEFBI	sc_WBorLeft
	DEFBI	sc_WBorRight
	DEFBI	sc_WBorBottom
	DEFII	sc_LayerInfo
	DEFLI	sc_BarLayer
	dc.l	0,0
	dc.l	wd_SIZEOF
WinInfoList:
	DEFWI	wd_MinWidth
	DEFWI	wd_MinHeight
	DEFWI	wd_MaxWidth
	DEFWI	wd_MaxHeight
	DEFLI	wd_Flags
	DEFLI	wd_MenuStrip
	DEFSI	wd_ScreenTitle
	DEFLI	wd_FirstRequest
	DEFLI	wd_DMRequest
	DEFWI	wd_ReqCount
	DEFLI	wd_RPort
	DEFLI	wd_Pointer
	DEFBI	wd_PtrHeight
	DEFBI	wd_PtrWidth
	DEFBI	wd_XOffset
	DEFBI	wd_YOffset
	DEFLI	wd_IDCMPFlags
	DEFLI	wd_UserPort
	DEFLI	wd_WindowPort
	DEFLI	wd_MessageKey
	DEFBI	wd_DetailPen
	DEFBI	wd_BlockPen
	DEFLI	wd_CheckMark
	DEFLI	wd_ExtData
	DEFLI	wd_UserData
	DEFBI	wd_BorderLeft
	DEFBI	wd_BorderTop
	DEFBI	wd_BorderRight
	DEFBI	wd_BorderBottom
	DEFLI	wd_BorderRPort
	DEFLI	wd_Parent
	DEFLI	wd_Descendant
	DEFWI	wd_GZZMouseX
	DEFWI	wd_GZZMouseY
	DEFWI	wd_GZZWidth
	DEFWI	wd_GZZHeight
	DEFLI	wd_IFont
 IFD	D20
	DEFLI	wd_MoreFlags
 ENDC
	dc.l	0,0
	dc.l	ConfigDev_SIZEOF
ConfInfoList:
	DEFWI	cd_SlotAddr
	DEFWI	cd_SlotSize
	DEFLI	cd_NextCD
	DEFBI	er_Type,cd_Rom+er_Type
	DEFBI	er_Product,cd_Rom+er_Product
	DEFBI	er_Flags,cd_Rom+er_Flags
	DEFWI	er_Manufacturer,cd_Rom+er_Manufacturer
	DEFLI	er_SerialNumber,cd_Rom+er_SerialNumber
	DEFWI	er_InitDiagVec,cd_Rom+er_InitDiagVec
	dc.l	0,0

	;Task states
TaskStates:
	dc.b	"Inv Add Run Rdy WaitExecRem "
	dc.b	"ColdColdColdColdColdColdCold"

	EVEN

;TaskTable:		ds.l	8				;Table with tasks
;RegTable:		ds.l	8*14			;Table with registers

BL	equ	0*65536*256
WL	equ	1*65536*256
LL	equ	2*65536*256
bL	equ	4*65536*256

	;ExecBase structure
SLE01:	dc.b	"SoftVer",0
SLE02:	dc.b	"LowMemChkSum",0
SLE03:	dc.b	"ChkBase",0
SLE04:	dc.b	"ColdCapt",0
SLE05:	dc.b	"CoolCapt",0
SLE06:	dc.b	"WarmCapt",0
SLE07:	dc.b	"SysStkUp",0
SLE08:	dc.b	"SysStkLow",0
SLE09:	dc.b	"MaxLocMem",0
SLE10:	dc.b	"DebugEntry",0
SLE11:	dc.b	"DebugData",0
SLE12:	dc.b	"AlertData",0
SLE13:	dc.b	"MaxExtMem",0
SLE14:	dc.b	"ChkSum",0
SLE15:	dc.b	"ThisTask",0
SLE16:	dc.b	"IdleCnt",0
SLE17:	dc.b	"DispCnt",0
SLE18:	dc.b	"Quantum",0
SLE19:	dc.b	"Elapsed",0
SLE20:	dc.b	"SysFlags",0
SLE21:	dc.b	"IDNestCnt",0
SLE22:	dc.b	"TDNestCnt",0
SLE23:	dc.b	"AttnFlags",0
SLE24:	dc.b	"AttnResched",0
SLE25:	dc.b	"ResModules",0
SLE26:	dc.b	"TaskTrapCode",0
SLE27:	dc.b	"TaskExceptCode",0
SLE28:	dc.b	"TaskExitCode",0
SLE29:	dc.b	"TaskSigAlloc",0
SLE30:	dc.b	"TaskTrapAlloc",0
SLE31:	dc.b	"VBlankFreq",0
SLE32:	dc.b	"PowerSupFreq",0
SLE33:	dc.b	"KickTagPtr",0
SLE34:	dc.b	"KickCheckSum",0
 IFD	D20
SLE35:	dc.b	"RamLibPrivate",0
SLE36:	dc.b	"EClockFreq",0
SLE37:	dc.b	"CacheCtrl",0
SLE38:	dc.b	"TaskID",0
SLE39:	dc.b	"PuddleSize",0
SLE40:	dc.b	"MMULock",0
 ENDC

	;List with offsets in ExecBase
	EVEN
	dc.l	0								;No size
ExecBaseList:
	dc.l	SLE01,WL+SoftVer
	dc.l	SLE02,WL+LowMemChkSum
	dc.l	SLE03,LL+ChkBase
	dc.l	SLE04,LL+ColdCapture
	dc.l	SLE05,LL+CoolCapture
	dc.l	SLE06,LL+WarmCapture
	dc.l	SLE07,LL+SysStkUpper
	dc.l	SLE08,LL+SysStkLower
	dc.l	SLE09,LL+MaxLocMem
	dc.l	SLE10,LL+DebugEntry
	dc.l	SLE11,LL+DebugData
	dc.l	SLE12,LL+AlertData
	dc.l	SLE13,LL+MaxExtMem
	dc.l	SLE14,WL+ChkSum
	dc.l	SLE15,LL+ThisTask
	dc.l	SLE16,LL+IdleCount
	dc.l	SLE17,LL+DispCount
	dc.l	SLE18,WL+Quantum
	dc.l	SLE19,WL+Elapsed
	dc.l	SLE20,WL+SysFlags
	dc.l	SLE21,BL+IDNestCnt
	dc.l	SLE22,BL+TDNestCnt
	dc.l	SLE23,WL+AttnFlags
	dc.l	SLE24,WL+AttnResched
	dc.l	SLE25,LL+ResModules
	dc.l	SLE26,LL+TaskTrapCode
	dc.l	SLE27,LL+TaskExceptCode
	dc.l	SLE28,LL+TaskExitCode
	dc.l	SLE29,LL+TaskSigAlloc
	dc.l	SLE30,WL+TaskTrapAlloc
	dc.l	SLE31,BL+VBlankFrequency
	dc.l	SLE32,BL+PowerSupplyFrequency
	dc.l	SLE33,LL+KickTagPtr
	dc.l	SLE34,LL+KickCheckSum
 IFD	D20
	dc.l	SLE35,LL+ex_RamLibPrivate
	dc.l	SLE36,LL+ex_EClockFrequency
	dc.l	SLE37,LL+ex_CacheControl
	dc.l	SLE38,LL+ex_TaskID
	dc.l	SLE39,LL+ex_PuddleSize
	dc.l	SLE40,LL+ex_MMULock
 ENDC
	dc.l	0,0

	;IntuitionBase structure
SLI01:	dc.b	"ActiveWindow",0
SLI02:	dc.b	"ActiveScreen",0
SLI03:	dc.b	"FirstScreen",0
SLI04		equ	HTC_FLAGS
SLI05:	dc.b	"MouseY",0
SLI06:	dc.b	"MouseX",0
SLI07:	dc.b	"Seconds",0
SLI08:	dc.b	"Micros",0

	EVEN
	dc.l	0								;No size
IntuiBaseList:
	dc.l	SLI01,LL+ib_ActiveWindow
	dc.l	SLI02,LL+ib_ActiveScreen
	dc.l	SLI03,LL+ib_FirstScreen
	dc.l	SLI04,LL+ib_Flags
	dc.l	SLI05,WL+ib_MouseY
	dc.l	SLI06,WL+ib_MouseX
	dc.l	SLI07,LL+ib_Seconds
	dc.l	SLI08,LL+ib_Micros
	dc.l	0,0

	;GraphicsBase structure
SLG01:	dc.b	"ActiView",0
SLG02:	dc.b	"copinit",0
SLG03:	dc.b	"cia",0
SLG04:	dc.b	"blitter",0
SLG05:	dc.b	"LOFlist",0
SLG06:	dc.b	"SHFlist",0
SLG07:	dc.b	"blthd",0
SLG08:	dc.b	"blttl",0
SLG09:	dc.b	"bsblthd",0
SLG10:	dc.b	"bsblttl",0
SLG11:	dc.b	"vbsrv",0
SLG12:	dc.b	"timsrv",0
SLG13:	dc.b	"bltsrv",0
SLG14:	dc.b	"TextFonts",0
SLG15:	dc.b	"DefaultFont",0
SLG16:	dc.b	"Modes",0
SLG17:	dc.b	"VBlank",0
SLG18:	dc.b	"gb_Debug",0
SLG19:	dc.b	"BeamSync",0
SLG20:	dc.b	"sys_bplcon",0
SLG21:	dc.b	"SpriteReserved",0
SLG22:	dc.b	"bytereserved",0
SLG23		equ	HTC_FLAGS
SLG24:	dc.b	"BlitLock",0
SLG25:	dc.b	"BlitNest",0
SLG26:	dc.b	"BlitWaitQ",0
SLG27:	dc.b	"BlitOwner",0
SLG28:	dc.b	"TOF_WaitQ",0
SLG29:	dc.b	"DisplayFlags",0
SLG30:	dc.b	"SimpleSprite",0
SLG31:	dc.b	"MaxDispRow",0
SLG32:	dc.b	"MaxDispCol",0
SLG33:	dc.b	"NormalDispRows",0
SLG34:	dc.b	"NormalDispCols",0
SLG35:	dc.b	"NormalDPMX",0
SLG36:	dc.b	"NormalDPMY",0
SLG37:	dc.b	"LastChanceMem",0
SLG38:	dc.b	"LCMptr",0
SLG39:	dc.b	"MicrosPLine",0
 IFD	D20
SLG40:	dc.b	"MinDispCol",0
SLG41:	dc.b	"ChipRevBits",0
SLG42:	dc.b	"MonitorId",0
SLG43:	dc.b	"HedleyCount",0
SLG44:	dc.b	"HedleyFlags",0
SLG45:	dc.b	"HedleyTmp",0
SLG46:	dc.b	"HashTable",0
SLG47:	dc.b	"CurTotRows",0
SLG48:	dc.b	"CurTotCclks",0
SLG49:	dc.b	"hedley",0
SLG50:	dc.b	"HedleySprites",0
SLG51:	dc.b	"HedleySprites1",0
SLG52:	dc.b	"HedleyHint",0
SLG53:	dc.b	"HedleyHint2",0
SLG54:	dc.b	"MonitorList",0
SLG55:	dc.b	"a2024SyncRast",0
SLG56:	dc.b	"CtrlDeltaPal",0
SLG57:	dc.b	"CtrlDeltaNtsc",0
SLG58:	dc.b	"CurrentMonitor",0
SLG59:	dc.b	"DefaultMonitor",0
SLG60:	dc.b	"MonListSemaph",0
SLG61:	dc.b	"DispInfoDBase",0
SLG62:	dc.b	"ActiViewCprSem",0
 ENDC

	EVEN
	dc.l	0								;No size
GraphicsBaseList:
	dc.l	SLG01,LL+gb_ActiView
	dc.l	SLG02,LL+gb_copinit
	dc.l	SLG03,LL+gb_cia
	dc.l	SLG04,LL+gb_blitter
	dc.l	SLG05,LL+gb_LOFlist
	dc.l	SLG06,LL+gb_SHFlist
	dc.l	SLG07,LL+gb_blthd
	dc.l	SLG08,LL+gb_blttl
	dc.l	SLG09,LL+gb_bsblthd
	dc.l	SLG10,LL+gb_bsblttl
	dc.l	SLG11,bL+gb_vbsrv
	dc.l	SLG12,bL+gb_timsrv
	dc.l	SLG13,bL+gb_bltsrv
	dc.l	SLG14,bL+gb_TextFonts
	dc.l	SLG15,LL+gb_DefaultFont
	dc.l	SLG16,WL+gb_Modes
	dc.l	SLG17,BL+gb_VBlank
	dc.l	SLG18,BL+gb_Debug
	dc.l	SLG19,WL+gb_BeamSync
	dc.l	SLG20,WL+gb_system_bplcon0
	dc.l	SLG21,BL+gb_SpriteReserved
	dc.l	SLG22,BL+gb_bytereserved
	dc.l	SLG23,WL+gb_Flags
	dc.l	SLG24,WL+gb_BlitLock
	dc.l	SLG25,WL+gb_BlitNest
	dc.l	SLG26,bL+gb_BlitWaitQ
	dc.l	SLG27,LL+gb_BlitOwner
	dc.l	SLG28,bL+gb_TOF_WaitQ
	dc.l	SLG29,WL+gb_DisplayFlags
	dc.l	SLG30,LL+gb_SimpleSprites
	dc.l	SLG31,WL+gb_MaxDisplayRow
	dc.l	SLG32,WL+gb_MaxDisplayColumn
	dc.l	SLG33,WL+gb_NormalDisplayRows
	dc.l	SLG34,WL+gb_NormalDisplayColumns
	dc.l	SLG35,WL+gb_NormalDPMX
	dc.l	SLG36,WL+gb_NormalDPMY
	dc.l	SLG37,LL+gb_LastChanceMemory
	dc.l	SLG38,LL+gb_LCMptr
	dc.l	SLG39,WL+gb_MicrosPerLine
 IFD	D20
	dc.l	SLG40,WL+gb_MinDisplayColumn
	dc.l	SLG41,BL+gb_ChipRevBits0
	dc.l	SLG42,WL+gb_monitor_id
	dc.l	SLG43,WL+gb_hedley_count
	dc.l	SLG44,WL+gb_hedley_flags
	dc.l	SLG45,WL+gb_hedley_tmp
	dc.l	SLG46,LL+gb_hash_table
	dc.l	SLG47,WL+gb_current_tot_rows
	dc.l	SLG48,WL+gb_current_tot_cclks
	dc.l	SLG49,bL+gb_hedley
	dc.l	SLG50,bL+gb_hedley_sprites
	dc.l	SLG51,bL+gb_hedley_sprites1
	dc.l	SLG52,BL+gb_hedley_hint
	dc.l	SLG53,BL+gb_hedley_hint2
	dc.l	SLG54,bL+gb_MonitorList
	dc.l	SLG55,WL+gb_a2024_sync_raster
	dc.l	SLG56,WL+gb_control_delta_pal
	dc.l	SLG57,WL+gb_control_delta_ntsc
	dc.l	SLG58,LL+gb_current_monitor
	dc.l	SLG59,LL+gb_default_monitor
	dc.l	SLG60,LL+gb_MonitorListSemaphore
	dc.l	SLG61,LL+gb_DisplayInfoDataBase
	dc.l	SLG62,LL+gb_ActiViewCprSemaphore
 ENDC
	dc.l	0,0

	END
