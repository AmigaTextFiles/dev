*-----------------------*
*	MungFriend
*	version 3.4 (rev 14)
*	© 1995-97 Szymon Pura
*	KickStart 2.0 required
*-----------------------*

***************************** VERSION HISTORY ******************************
**                                                                        **
**  V2.0    28.02.96	Initial release                                   **
**  V2.1    04.03.96	TYPE & WRITE fixed                                **
**          06.03.96	REMOVE fixed                                      **
**          27.03.96    WRITE fixed                                       **
**          09.04.96    Minor fixes                                       **
**          27.05.96    Memory allocation fixed                           **
**  V2.2    26.06.96    NOBELL option added                               **
**  V2.3    17.11.96    FindResNode fixed                                 **
**                      Priority set to 120                               **
**                      KickMemList replaces AllocAbs()'es in InitProc    **
**  V3.0    19.11.96    Totally redone memory allocation                  **
**                      Priority set to 0                                 **
**                      INFO improved                                     **
**  V3.1    24.01.97    TYPE & WRITE improved                             **
**                      Cache cleared                                     **
**                      ROMTag fixed                                      **
**  V3.1a   22.02.97    Should work correctly under -OS3.0                **
**						'BufferSize' error fixed  **
**  V3.2    01.09.97    Another bug(/strange behaviour) fixed             **
**  V3.3    02.10.97                                                      **
**  V3.4    18.10.97    Oops, WRITE didn't check the buffer               **
**                                                                        **
****************************************************************************


	include	EInclude.m

	EInclude	DOS,DOS
	EInclude	DOS,DOSEXTENS
	EInclude	DOS,DOS_LIB
	EInclude	EXEC,EXECBASE
	EInclude	EXEC,EXEC_LIB
	EInclude	EXEC,LIBRARIES
	EInclude	EXEC,MEMORY
	EInclude	EXEC,RESIDENT
	EInclude	EXEC,STRINGS
	EInclude	EXEC,TYPES
	EInclude	HARDWARE,CUSTOM

MYVERSION	equ	3
MYREVISION	equ	4
custombase	equ	$dff000

	ifnd	_LVORawPutChar      * not defined in exec_lib.i
_LVORawPutChar	equ	-516
	endc

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

	STRUCTURE	MFResidentNode,0
	APTR	mfrn_MyResident
	APTR	mfrn_Succ
	ULONG	mfrn_null	; end of the array

	UWORD	mfrn_Version
	UWORD	mfrn_Revision
	UBYTE	mfrn_Flags
	UBYTE	pad	; unused at the moment...

; start of Resident structure

	STRUCT	mfrn_Resident,RT_SIZE
	STRUCT	mfrn_IDString,60
	STRUCT	mfrn_NameString,12
	STRUCT	mfrn_Reserved,20	; unused at the moment...

; start of the MemList structure

	LABEL	mfrn_MemList
	STRUCT	mfrn_Node,LN_SIZE
	UWORD	mfrn_NumEntries	; just one entry...
	APTR	mfrn_NodePtr
	ULONG	mfrn_NodeSize

	ULONG	mfrn_CharsInBuff
	ULONG	mfrn_BufferSize

; special procs

	STRUCT	mfrn_InitProc,50	* only about 30 bytes needed...
	STRUCT	mfrn_PatchProc,200	* only about 130 bytes needed...
	APTR	mfrn_OldVector	* original _LVORawPutChar value

; buffer starts here

	LABEL	mfrn_Buffer
	LABEL	mfrn_SIZEOF

; defs for mfrn_Flags

	BITDEF	MFRN,FLASH,0
	BITDEF	MFRN,SERIAL,1
	BITDEF	MFRN,TRACE,2
	BITDEF	MFRN,PATCHED,3
	BITDEF	MFRN,OVERFLOW,4
	BITDEF	MFRN,NOBELLS,5

****************************************************************************

Start	lea	DosLibName(pc),a1
	moveq	#0,d0
	CALLEXEC	OpenLibrary
	move.l	d0,_DOSBase
	move.l	d0,a6
	JSRL	Input
	move.l	d0,MyInput
	JSRL	Output
	move.l	d0,MyOutput
	move.w	LIB_VERSION(a6),d0
	cmpi.w	#35,d0
	bhi	strt_0
	move.l	a6,a1
	CALLEXEC	CloseLibrary
	moveq	#RETURN_FAIL,d0
	rts
strt_0	lea	MyTemplate(pc),a1
	move.l	a1,d1
	lea	MyArgTable,a2
	move.l	a2,d2
	moveq	#0,d3
	JSRL	ReadArgs
	move.l	d0,ArgPtr
	bne	strt_1
	JSRL	IoErr
	moveq	#0,d2
	JSRL	PrintFault
	movea.l	a6,a1
	CALLEXEC	CloseLibrary
	moveq	#RETURN_FAIL,d0
	rts
strt_1	moveq	#-1,d0
	moveq	#6,d1
	move.l	a2,a0
strt_c	tst.l	(a0)+
	sne	d2
	andi.b	#1,d2
	add.b	d2,d0
	dbf	d1,strt_c
	tst.b	d0
	beq	strt_2
	addq.b	#1,d0
	beq	strt_2
	lea	TooManyCommands(pc),a0
QuitStrErr
	bsr	PrintString
QuitErr	bsr	Quit
	moveq	#RETURN_FAIL,d0
	rts
Quit	move.l	ArgPtr(pc),d1
	CALLDOS	FreeArgs
	move.l	a6,a1
	CALLEXEC	CloseLibrary
	rts
FlagError
	lea	FlagErrorTxt(pc),a0
	bra	QuitStrErr
strt_2	bsr	FindResNode
	move.l	d0,MFNode
	move.l	d0,a3
	move.l	a2,a0
	tst.l	36(a0)
	beq	strt_3
	tst.l	40(a0)
	bne	FlagError
strt_3	tst.l	44(a0)
	beq	strt_4
	tst.l	48(a0)
	bne	FlagError
strt_4	tst.l	52(a0)
	beq	strt_5
	tst.l	56(a0)
	bne	FlagError
strt_5	tst.l	60(a0)
	beq	strt_f
	tst.l	64(a0)
	bne	FlagError
strt_f	tst.l	MFNode
	beq	strt_b
	tst.l	36(a0)
	beq	strt_6
	bset	#MFRNB_FLASH,mfrn_Flags(a3)
strt_6	tst.l	40(a0)
	beq	strt_7
	bclr	#MFRNB_FLASH,mfrn_Flags(a3)
strt_7	tst.l	52(a0)
	beq	strt_8
	bset	#MFRNB_TRACE,mfrn_Flags(a3)
	bset	#MFRNB_PATCHED,mfrn_Flags(a3)
	bne	strt_8
	movem.l	a0/a1/a6,-(sp)
	movea.l	4.w,a6
	lea	mfrn_PatchProc(a3),a0
	move.l	a0,d0
	lea	_LVORawPutChar,a0
	move.l	a6,a1
	JSRL	Disable
	JSRL	SetFunction
	JSRL	Enable
	move.l	d0,mfrn_OldVector(a3)
	movem.l	(sp)+,a0/a1/a6
strt_8	tst.l	56(a0)
	beq	strt_9
	bclr	#MFRNB_TRACE,mfrn_Flags(a3)
strt_9	tst.l	44(a0)
	beq	strt_a
	bset	#MFRNB_SERIAL,mfrn_Flags(a3)
strt_a	tst.l	48(a0)
	beq	strt_d
	bclr	#MFRNB_SERIAL,mfrn_Flags(a3)
strt_d	tst.l	60(a0)
	beq	strt_e
	bset	#MFRNB_NOBELLS,mfrn_Flags(a3)
strt_e	tst.l	64(a0)
	beq	strt_b
	bclr	#MFRNB_NOBELLS,mfrn_Flags(a3)
strt_b	tst.l	(a0)+
	bne	f_Info
	tst.l	(a0)+
	bne	f_Install
	tst.l	(a0)+
	bne	f_Clear
	tst.l	(a0)+
	bne	f_Remove
	tst.l	(a0)+
	bne	f_Type
	tst.l	(a0)+
	bne	f_Write
	tst.l	(a0)
	bne	QuitOk
	lea	NoCommand(pc),a0
	bra	QuitStrErr
f_Info	tst.l	MFNode
	beq	NotInstalled
	move.l	MFNode(pc),a2
	lea	InfoFormat(pc),a0
	move.l	a0,d2
	move.l	MyOutput(pc),d1
	lea	InfoFormatArgs(pc),a0
	move.l	a0,d3
	move.l	mfrn_BufferSize(a2),d0
	subq.l	#4,d0
	move.l	d0,(a0)+
	lea	NoTraceT(pc),a1
	move.l	a1,(a0)+
	btst	#MFRNB_TRACE,mfrn_Flags(a2)
	beq	finf_0
	addq.l	#2,-4(a0)
finf_0	lea	NoSerialT(pc),a1
	move.l	a1,(a0)+
	btst	#MFRNB_SERIAL,mfrn_Flags(a2)
	beq	finf_1
	addq.l	#2,-4(a0)
finf_1	lea	NoFlashT(pc),a1
	move.l	a1,(a0)+
	btst	#MFRNB_FLASH,mfrn_Flags(a2)
	beq	finf_2
	addq.l	#2,-4(a0)
finf_2	lea	NoBellsT(pc),a1
	move.l	a1,(a0)+
	btst	#MFRNB_NOBELLS,mfrn_Flags(a2)
	bne	finf_3
	lea	BellsT(pc),a1
	move.l	a1,(a0)+
finf_3	move.l	mfrn_CharsInBuff(a2),CharsInBuffSpace
	CALLDOS	VFPrintf
	bra	QuitOk
f_Clear	tst.l	MFNode
	beq	NotInstalled
	move.l	MFNode(pc),a2
	clr.l	mfrn_CharsInBuff(a2)
	bclr	#MFRNB_OVERFLOW,mfrn_Flags(a2)
	bra	QuitOk
f_Remove
	tst.l	MFNode
	beq	NotInstalled
	move.l	MFNode(pc),a2
	movea.l	4.w,a6
	btst	#MFRNB_PATCHED,mfrn_Flags(a2)
	beq	frem_3
	lea	_LVORawPutChar,a0
	move.l	mfrn_OldVector(a2),d0
	move.l	a6,a1
	JSRL	Disable
	JSRL	SetFunction
	lea	mfrn_PatchProc(a2),a0
	cmp.l	a0,d0
	beq	frem_3
	move.l	a6,a1
	lea	_LVORawPutChar,a0
	JSRL	SetFunction
	JSRL	Enable
	lea	CantQuitTxt(pc),a0
	bra	QuitStrErr
frem_3	JSRL	Enable
	move.l	MFNode(pc),a0
	JSRL	Forbid
	lea	KickTagPtr(a6),a2
frem_0	move.l	(a2),a1
	move.l	a1,d0
	beq	frem_1
	cmpa.l	a0,a1
	beq	frem_2
	lea	4(a1),a2
	bra	frem_0
frem_2	move.l	4(a0),(a2)
frem_1	lea	KickMemPtr(a6),a2
	move.l	MFNode(pc),a0
	lea	mfrn_Node(a0),a0
1$	move.l	(a2),a1
	move.l	a1,d0
	beq	2$
	cmpa.l	a0,a1
	beq	3$
	move.l	(a2),a2
	bra	1$
3$	move.l	(a0),(a2)
2$	JSRL	SumKickData
	move.l	d0,KickCheckSum(a6)
	JSRL	CacheClearU
	JSRL	Permit
	move.l	MFNode(pc),a0
	bsr	FreeResNode
	bra	QuitOk
NoMemory
	lea	NoMemoryTxt(pc),a0
	bra	QuitStrErr
NoBuffSize
	lea	NoBuffSizeTxt(pc),a0
	bra	QuitStrErr
f_Install
	tst.l	MFNode
	bne	AlreadyInstalled
	move.l	28(a2),d0
	beq	NoBuffSize
	move.l	28(a2),a0
	move.l	(a0),d0
	cmpi.l	#10239,d0
	bhi	1$
	lea	Using10KBTxt(pc),a0
	bsr	PrintString
	move.l	#10240,d0
1$	bsr	CreateNode
	tst.l	d0
	beq	NoMemory
	move.l	d0,a3
	move.l	d0,MFNode
	tst.l	44(a2)
	beq	finst_0
	bset	#MFRNB_SERIAL,mfrn_Flags(a3)
finst_0	tst.l	36(a2)
	beq	finst_1
	bset	#MFRNB_FLASH,mfrn_Flags(a3)
finst_1	tst.l	52(a2)
	beq	finst_2
	bset	#MFRNB_TRACE,mfrn_Flags(a3)
	bset	#MFRNB_PATCHED,mfrn_Flags(a3)
	movea.l	4.w,a6
	lea	_LVORawPutChar,a0
	lea	mfrn_PatchProc(a3),a1
	move.l	a1,d0
	move.l	a6,a1
	JSRL	SetFunction
	move.l	d0,mfrn_OldVector(a3)
finst_2	tst.l	60(a2)
	beq	finst_3
	bset	#MFRNB_NOBELLS,mfrn_Flags(a3)
finst_3	movea.l	4.w,a6
	JSRL	Forbid
	JSRL	Disable
	move.l	KickTagPtr(a6),mfrn_Succ(a3)
	move.l	a3,KickTagPtr(a6)
	move.l	KickMemPtr(a6),mfrn_Node(a3)
	lea	mfrn_MemList(a3),a0
	move.l	a0,KickMemPtr(a6)
	JSRL	Enable
	JSRL	SumKickData
	move.l	d0,KickCheckSum(a6)
	JSRL	Permit
	bra	QuitOk
AlreadyInstalled
	lea	AlreadyInstalledTxt(pc),a0
	bsr	PrintString
	bra	QuitOk
NotInstalled
	lea	NotInstalledTxt(pc),a0
	bsr	PrintString
QuitOk	bsr	Quit
	moveq	#RETURN_OK,d0
	rts
PrintString	* (string)(a0)
	move.l	a6,-(sp)
	move.l	a0,d1
	CALLDOS	PutStr
	move.l	(sp)+,a6
	rts
FindResNode	* () -> resnode/NULL
	movem.l	a2/a6,-(sp)
	CALLEXEC	Forbid
	move.l	KickTagPtr(a6),a0
frn_3	move.l	a0,d0
	beq	frn_ex
frn_0	move.l	(a0),a1
	move.l	RT_NAME(a1),a1
	lea	MyNameString(pc),a2
frn_1	move.b	(a1)+,d0
	cmp.b	(a2)+,d0
	bne	frn_2
	tst.b	d0
	bne	frn_1
	move.l	a0,d0
	JSRL	Permit
	movem.l	(sp)+,a2/a6
	rts
frn_ex	JSRL	Permit
	moveq	#0,d0
	movem.l	(sp)+,a2/a6
	rts
frn_2	move.l	4(a0),a0
	bra	frn_3
FreeResNode	* (node)(a0)
	move.l	a6,-(sp)
	move.l	mfrn_NodeSize(a0),d0
	move.l	a0,a1
	CALLEXEC	FreeMem
	move.l	(sp)+,a6
	rts
crn_failed
	movem.l	(sp)+,d2/a2/a3/a6
	rts
CreateNode	* (buffsize)(d0) -> node
	movem.l	d2/a2/a3/a6,-(sp)
	addq.l	#4,d0
	move.l	d0,d2
	move.l	#MEMF_KICK!MEMF_PUBLIC!MEMF_CLEAR!MEMF_LOCAL,d1
	add.l	#mfrn_SIZEOF,d0
	movea.l	4.w,a6
	cmpi.w	#38,LIB_VERSION(a6)
	bhi	5$
	bclr	#MEMB_KICK,d1
5$	move.l	d0,-(sp)
	JSRL	AllocMem
	move.l	(sp)+,d1
	tst.l	d0
	beq	crn_failed
	move.l	d0,a2
	move.l	d0,mfrn_NodePtr(a2)
	move.l	d1,mfrn_NodeSize(a2)
	move.l	d2,mfrn_BufferSize(a2)
	lea	mfrn_Resident(a2),a1
	move.l	a1,mfrn_MyResident(a2)
	move.w	#RTC_MATCHWORD,RT_MATCHWORD(a1)
	move.b	#0,RT_PRI(a1)
	move.l	a1,RT_MATCHTAG(a1)
	move.b	#RTF_COLDSTART,RT_FLAGS(a1)
	move.b	#MYVERSION,RT_VERSION(a1)
	lea	MyNameString(pc),a0
	lea	mfrn_NameString(a2),a3
	move.l	a3,RT_NAME(a1)
1$	move.b	(a0)+,(a3)+
	bne	1$
	lea	MyIDString(pc),a0
	lea	mfrn_IDString(a2),a3
	move.l	a3,RT_IDSTRING(a1)
2$	move.b	(a0)+,(a3)+
	bne	2$
	lea	MyPatchProc(pc),a0
	lea	mfrn_PatchProc(a2),a3
	move.l	#MyPatchProcE-MyPatchProc-1,d0
3$	move.b	(a0)+,(a3)+
	dbf	d0,3$
	lea	MyInitProc(pc),a0
	lea	mfrn_InitProc(a2),a3
	move.l	a3,RT_INIT(a1)
	move.l	#MyInitProcE-MyInitProc-1,d0
4$	move.b	(a0)+,(a3)+
	dbf	d0,4$
	move.w	#1,mfrn_NumEntries(a2)
	move.l	a2,d0
	movem.l	(sp)+,d2/a2/a3/a6
	rts
f_Type	tst.l	MFNode
	beq	NotInstalled
	move.l	MyOutput(pc),d2
	bsr	DoType
	moveq	#LF,d2
	move.l	MyOutput(pc),d1
	CALLDOS	FPutC
	move.l	MFNode(pc),a2
	btst	#MFRNB_OVERFLOW,mfrn_Flags(a2)
	beq	QuitOk
	lea	BuffOverflow(pc),a0
	bsr	PrintString
	bra	QuitOk
BadFileName
	lea	BadFileNameTxt(pc),a0
	bra	QuitStrErr
f_Write
	tst.l	MFNode
	beq	NotInstalled
	move.l	32(a2),d0
	beq	BadFileName
	move.l	d0,d1
	move.l	#MODE_NEWFILE,d2
	CALLDOS	Open
	move.l	d0,d7
	bne	fwrt_0
	CALLDOS	IoErr
	move.l	d0,d1
	moveq	#0,d2
	CALLDOS	PrintFault
	bra	QuitErr
fwrt_0	move.l	d7,d2
	bsr	DoType
	tst.l	d0
	bne	fwrt_1
	move.l	MFNode(pc),a2
	btst	#MFRNB_OVERFLOW,mfrn_Flags(a2)
	beq	fwrt_1
	lea	BuffOverflow(pc),a0
	move.l	d7,d1
	move.l	a0,d2
	CALLDOS	FPuts
	tst.l	d0
	beq	fwrt_1
	JSRL	IoErr
	move.l	d0,d1
	moveq	#0,d2
	JSRL	PrintFault
	bra	fwrt_2
fwrt_1	move.l	d7,d1
	CALLDOS	Close
	bra	QuitOk
fwrt_2	move.l	d7,d1
	CALLDOS	Close
	move.l	32+MyArgTable,d1
	JSRL	DeleteFile
	bra	QuitErr
DoType	*	(d2-fh)
	movem.l	d1-d7,-(sp)
	move.l	d2,d7	; fh
	moveq	#20,d6	; 20 bytes a time
	move.l	MFNode(pc),a0
	lea	mfrn_Buffer(a0),a1
	move.l	a1,d5	; buffer
	move.l	mfrn_CharsInBuff(a0),d4	; len
	addq.l	#4,d5	; let's skip some private data...
1$	tst.l	d4
	beq	3$
	cmp.l	d6,d4
	bge	2$
	move.l	d4,d6
2$	move.l	#SIGBREAKF_CTRL_C,d1
	CALLDOS	CheckSignal
	tst.l	d0
	bne	4$
	move.l	d7,d1
	move.l	d5,d2
	move.l	d6,d3
	sub.l	d6,d4
	add.l	d6,d5
	move.l	d4,-(sp)
	moveq	#1,d4
	CALLDOS	FWrite
	move.l	(sp)+,d4
	subq.l	#1,d0
	beq	1$
	JSRL	IoErr
	move.l	d0,d1
	moveq	#0,d2
	JSRL	PrintFault
	moveq	#-1,d0
	movem.l	(sp)+,d1-d7
	rts
3$	moveq	#0,d0
	movem.l	(sp)+,d1-d7
	rts
4$	lea	BreakTxt(pc),a0
	bsr	PrintString
	movem.l	(sp)+,d1-d7
	moveq	#-2,d0
	rts
BreakTxt
	dc.b	LF,'*** Break',LF,0
	even
MyPatchProc
	lea	MyPatchProc-mfrn_PatchProc(pc),a0
	btst	#MFRNB_TRACE,mfrn_Flags(a0)
	beq	mppr_0
	btst	#MFRNB_NOBELLS,mfrn_Flags(a0)
	beq	mppr_5
	cmpi.b	#BELL,d0
	beq	mppr_0
mppr_5	move.l	mfrn_CharsInBuff(a0),d1
	move.l	d2,-(sp)
	move.l	mfrn_BufferSize(a0),d2
	subi.l	#4,d2
	cmp.l	d1,d2
	beq	mppr_4
	addq.l	#1,mfrn_CharsInBuff(a0)
	lea	mfrn_Buffer(a0),a1
	move.b	d0,4(a1,d1.l)
mppr_1	move.l	(sp)+,d2
mppr_0	btst	#MFRNB_FLASH,mfrn_Flags(a0)
	beq	mppr_2
	lea	$dff000,a1
	move.w	vhposr(a1),color(a1)
mppr_2	btst	#MFRNB_SERIAL,mfrn_Flags(a0)
	beq	mppr_3
	move.l	mfrn_OldVector(a0),a0
	jmp	(a0)
mppr_3	rts
mppr_4	bset	#MFRNB_OVERFLOW,mfrn_Flags(a0)
	bra	mppr_1
MyPatchProcE
MyInitProc
	lea	MyInitProc-mfrn_InitProc(pc),a0
	andi.b	#~(MFRNF_PATCHED!MFRNF_TRACE),mfrn_Flags(a0)
NullExit
	moveq	#0,d0
Exit	rts
MyInitProcE

****************************************************************************

MFNode	dc.l	0
_DOSBase
	dc.l	0
MyInput	dc.l	0
MyOutput
	dc.l	0
ArgPtr	dc.l	0
InfoFormatArgs
	dc.l	0,0,0,0,0
CharsInBuffSpace
	dc.l	0
DosLibName
	DOSNAME
MyNameString
	dc.b	'MungFriend',0
	even
	dc.b	'$VER: '
MyIDString
	dc.b	'MungFriend 3.4  (18.10.97) © 1995-97 Szymon Pura',CR,LF,0
MyTemplate
	dc.b	'INFO=I/S,INSTALL=S/S,CLEAR=C/S,REMOVE=R/S,TYPE=T/S,WRITE=W/S,UPDATE=U/S,SIZE/N/K,TO,FLASH/S,NOFLASH/S,SERIAL/S,NOSERIAL/S,TRACE/S,NOTRACE/S,NOBELLS/S,BELLS/S',0
BuffOverflow
	dc.b	'*** WARNING: BUFFER OVERFLOW ***',LF,0
TooManyCommands
	dc.b	'Bad args - only ONE command allowed',LF,0
FlagErrorTxt
	dc.b	'Bad args - flags are mutual exclusive',LF,0
NoCommand
	dc.b	$1b,'[32mMungFriend 3.4',$1b,'[31m   © 1995-97 Szymon Pura, FREEWARE',LF
	dc.b	'USAGE:',LF
	dc.b	'    MungFriend INFO|INSTALL|CLEAR|REMOVE|TYPE|WRITE|UPDATE [SIZE n]',LF
	dc.b	'               [TO filespec] [FLASH|NOFLASH][TRACE|NOTRACE][SERIAL|NOSERIAL]',LF
	dc.b	'               [BELLS|NOBELLS]',LF,LF
	dc.b	'    MungFriend [<command> [<options>]]',LF,LF
	dc.b	'           Where <command> is one of:',LF
	dc.b	'   - info             - display some general info about current buffer',LF
	dc.b	'   - install size <n> - create a new buffer (size in bytes)',LF
	dc.b	'   - remove           - remove current buffer',LF
	dc.b	'   - type             - type buffer contents',LF
	dc.b	'   - write <filename> - write buffer contents to a file',LF
	dc.b	'   - update           - update options,',LF
	dc.b	'           And <options> are:',LF
	dc.b	'   - serial           - allow serial output',LF
	dc.b	'   - trace            - turn on exec/RawPutChar() tracing',LF
	dc.b	'   - flash            - turn on flash mode',LF
	dc.b	'   - bells            - allow console bells',LF,LF,0
NotInstalledTxt
	dc.b	'MungFriend is not installed !',LF,0
InfoFormat
	dc.b	'BuffSize: %ld  Options: %s  %s  %s  %s',LF
	dc.b	'Characters in buffer: %ld',LF,0
NoTraceT
	dc.b	'NOTRACE',0
NoFlashT
	dc.b	'NOFLASH',0
NoSerialT
	dc.b	'NOSERIAL',0
NoBellsT
	dc.b	'NOBELLS',0
BellsT	dc.b	'BELLS',0
CantQuitTxt
	dc.b	"Can't quit !!  Someone is using RawPutChar() vector !!",LF,0
AlreadyInstalledTxt
	dc.b	'MungFriend is already installed !!',LF,0
NoMemoryTxt
	dc.b	'Not enough memory',LF,0
NoBuffSizeTxt
	dc.b	'Bad args - no buffer size',LF,0
BadFileNameTxt
	dc.b	'Bad args - filespec required',LF,0
Using10KBTxt
	dc.b	'Allocated buffer: 10 KB',LF,0
	section	"args",BSS
MyArgTable
	ds.b	68
