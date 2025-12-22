************************************************************
*
** DropHunk
*
** Version 1.0
*
** November, 29th 1998
*
** Author: Joerg van de Loo (ONIX)
**	   Hoevel 15
**	   47559 Kranenburg
**	   Germany
*
*
** DropHunk is a CLI only tool to drop the important settings
** of an AmigaDOS load or linker file.   Not  all  hunk-types
** are currently supported, anyhow, it works well.
*
*
** Written with HiSoft's Devpac Amiga 3
*


	OUTPUT	RAM:DropHunk


	include	dos/doshunks.i			Not in my 'system.gs' file...

	include	RAD:include/CLIStartup.asm



    STRUCTURE	Table,108

	ALIGNLONG
	STRUCT	_FIB,fib_SIZEOF
	ALIGNLONG

	ULONG	_SPSave

	BPTR	_LockSave

	ULONG	_SPBufCnt
	STRUCT	_SPBuffer,80

	STRUCT	_HunkNameBuf,128

	ULONG	_NumHunk
	ULONG	_HunkSize
	ULONG	_HunkType
	ULONG	_FileHandle

	ULONG	_HunkNo

	APTR	_StrCache
	ULONG	_CacheFlag
	ULONG	_CachedSize

	ULONG	_ByteSize
	ULONG	_Relocs
	ULONG	_FileType

    LABEL	_TableSize


CacheSize	EQU	31*1024
FlushSize	EQU	30*1024


	opt	p+				Ensure pc-relative code

_main
	move.l	A7,_SPSave(A5)

	tst.l	arg_1(A5)			Any argument?
	beq.w	_return

	move.l	arg_1(A5),D1
	moveq	#ACCESS_READ,D2
	movea.l	_DOSBase(A5),A6
	jsr	_LVOLock(A6)			Attempt to get access to the file
	move.l	D0,_LockSave(A5)
	move.l	D0,D2

	jsr	_LVOIoErr(A6)
	move.l	D0,_errno(A5)

	tst.l	D2
	beq.w	_return

	move.l	D2,D1
	lea	_FIB(A5),A2
	move.l	A2,D2
	jsr	_LVOExamine(A6)

	move.l	#212,D0
	move.l	D0,_errno(A5)

	move.l	_LockSave(A5),D1
	jsr	_LVOUnLock(A6)

	tst.l	fib_DirEntryType(A2)
	bpl.w	_return	

	move.l	arg_1(A5),D1
	move.l	#MODE_OLDFILE,D2
	movea.l	_DOSBase(A5),A6
	jsr	_LVOOpen(A6)			Attempt to get access to the file
	move.l	D0,_FileHandle(A5)
	move.l	D0,D2

	jsr	_LVOIoErr(A6)
	move.l	D0,_errno(A5)

	tst.l	D2
	beq.s	_return

	move.l	_stdout(A5),D1
	jsr	_LVOIsInteractive(A6)		Output to an interactive terminal?
	tst.l	D0
	bne.s	2$				No, seems to be standard console window

	moveq	#1,D0
	move.l	D0,_CacheFlag(A5)		Set 'Cache' flag

	move.l	#CacheSize,D0
	move.l	#MEMF_CLEAR,D1
	movea.l	_SysBase(A5),A6
	jsr	_LVOAllocMem(A6)		Memory demand
	move.l	D0,_StrCache(A5)
	bne.s	2$
1$
	clr.l	_CacheFlag(A5)
2$
	movea.l	_DOSBase(A5),A6
	bsr.s	_HunkSearch			Fire up parsing

_close
	move.l	_FileHandle(A5),D1
	movea.l	_DOSBase(A5),A6
	jsr	_LVOClose(A6)			Close the file

	tst.l	_CacheFlag(A5)
	beq.s	_return

	bsr.w	_FlushCache			Print characters of buffer

	movea.l	_StrCache(A5),A1
	move.l	#CacheSize,D0
	movea.l	_SysBase(A5),A6
	jsr	_LVOFreeMem(A6)			Free the 'Cache'

_return
	move.l	_SPSave(A5),A7
	rts


_HunkSearch
	bsr.w	_GetCurrentHunk			Get first longword of file
	cmpi.l	#HUNK_HEADER,D0			HunkHeader indicates a load file
	beq.s	.exeFile
	cmpi.l	#HUNK_UNIT,D0
	beq.s	.lnkFile			else a linker file
	bra.w	.error

.exeFile
	lea	_FIB(A5),A0
	move.l	fib_Size(A0),-(sp)
	pea	fib_FileName(A0)
*	move.l	arg_1(A5),-(sp)
	pea	_ExeObjStr(pc)
	bsr.w	_SPrintF
	lea	12(sp),sp

	pea	_StartHunkStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

	move.l	_HunkType(A5),D0
	move.l	D0,_FileType(A5)
	bsr.w	_HunkAnalyse			Start analysing the file...
	tst.l	D0
	beq.s	.done
	pea	_ErrorStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp
	rts

.lnkFile
	lea	_FIB(A5),A0
	move.l	fib_Size(A0),-(sp)
	pea	fib_FileName(A0)
*	move.l	arg_1(A5),-(sp)
	pea	_LnkObjStr(pc)
	bsr.w	_SPrintF
	lea	12(sp),sp

	pea	_StartHunkStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

	move.l	_HunkType(A5),D0
	bsr.w	_HunkAnalyse			Start analysing the file...

	tst.l	D0
	beq.s	.done
	pea	_ErrorStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp
	rts
.done
	pea	_OkStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_PrintResult

	rts

.error
	moveq	#-1,D0
	rts

_PrintOneTab	;				Drop the ASCII character TAB
	movem.l	D0-D3/A0-A1,-(sp)		but don't trash any registers

	tst.l	_CacheFlag(A5)			Where to place the character?
	beq.s	.console

	movea.l	_StrCache(A5),A0
	move.l	_CachedSize(A5),D0
	move.b	#9,0(A0,D0.w)
	addq.w	#1,D0
	move.l	D0,_CachedSize(A5)
	cmpi.w	#FlushSize,D0
	bls.s	1$

	bsr.s	_FlushCache
	bra.s	1$

.console

	clr.l	-(sp)
	movea.l	sp,A0
	move.b	#9,(A0)

	move.l	_stdout(A5),D1
	move.l	A0,D2
	moveq	#1,D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVOWrite(A6)

	addq.l	#4,sp
1$
	movem.l	(sp)+,D0-D3/A0-A1
	rts

_PrintLF	;				Drop the ASCII character LF
	movem.l	D0-D3/A0-A1,-(sp)		but don't trash any registers

	tst.l	_CacheFlag(A5)			Where to place the character?
	beq.s	.console

	movea.l	_StrCache(A5),A0
	move.l	_CachedSize(A5),D0
	move.b	#10,0(A0,D0.w)
	addq.w	#1,D0
	move.l	D0,_CachedSize(A5)
	cmpi.w	#FlushSize,D0
	bls.s	1$

	bsr.s	_FlushCache
	bra.s	1$

.console

	clr.l	-(sp)
	movea.l	sp,A0
	move.b	#10,(A0)

	move.l	_stdout(A5),D1
	move.l	A0,D2
	moveq	#1,D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVOWrite(A6)

	addq.l	#4,sp
1$
	movem.l	(sp)+,D0-D3/A0-A1
	rts

_FlushCache	;				As it tells...
	movem.l	D2-D3/A6,-(sp)
	move.l	_stdout(A5),D1
	move.l	_StrCache(A5),D2
	move.l	_CachedSize(A5),D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVOWrite(A6)
	clr.l	_CachedSize(A5)
	movem.l	(sp)+,D2-D3/A6
	rts


_GetHunkLength		;			Read a single longword into 'HunkSize' var
	move.l	_FileHandle(A5),D1
	lea	_HunkSize(A5),A0
	move.l	A0,D2
	moveq	#4,D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVORead(A6)
	tst.l	D0
	bmi.s	.error

	move.l	_HunkSize(A5),D0
	rts

.error
	moveq	#-1,D0
	move.l	D0,_HunkType(A5)
	rts

_GetCurrentHunk		;			Read a single longword into 'HunkType' var
	move.l	_FileHandle(A5),D1
	lea	_HunkType(A5),A0
	move.l	A0,D2
	moveq	#4,D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVORead(A6)
	tst.l	D0
	bmi.s	.error
	beq.s	.error

	move.l	_HunkType(A5),D0
	rts

.error
	moveq	#-1,D0
	move.l	D0,_HunkType(A5)
	rts

_GetHunkName		;			Read name of hunk into 'HunkNameBuf'
	move.l	_FileHandle(A5),D1		Size in longwords of name in register D0
	lea	_HunkNameBuf(A5),A0
	move.l	A0,D2
	move.l	D0,D3
	lsl.l	#2,D3
	movem.l	D3/A0,-(sp)
	movea.l	_DOSBase(A5),A6
	jsr	_LVORead(A6)
	tst.l	D0
	bmi.s	.error

	movem.l	(sp)+,D1/A0
	clr.b	0(A0,D1.w)

	lea	_HunkNameBuf(A5),A0
	moveq	#-1,D0
.tst
	tst.b	(A0)+
	dbeq	D0,.tst
	not.l	D0				Return length of name in bytes
	rts

.error
	moveq	#-1,D0
	move.l	D0,_HunkType(A5)
	rts

_SkipHunk	;				Overread datas of file
	move.l	_FileHandle(A5),D1		Number of longwords to ignore in register D0
	move.l	D0,D2
	lsl.l	#2,D2
	andi.l	#$7FFFFFFF,D2
	moveq	#OFFSET_CURRENT,D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVOSeek(A6)
	tst.l	D0
	bmi.s	.error

	moveq	#0,D0
	rts

.error
	moveq	#-1,D0
	rts


_HunkAnalyse		;			D0 = Hunk type
	move.l	D0,D1				HUNK
	andi.w	#$3FF,D1			Without extensions
	subi.l	#$3E7,D1			Convert it into index
	bmi.s	.error
	cmpi.w	#24,D1
	bhi.s	.error
	
	move.l	D1,D2				Index
	move.l	D2,D3				Index
	add.w	D3,D3				Index² * 2
	moveq	#4,D4
	lsl.w	D4,D2				Index¹ * 4
	add.w	D3,D2				Index  * 18

	lea	_HunkNames(pc),A0
	lea	0(A0,D2.w),A0			String

	move.w	D1,D2				Index
	add.w	D2,D2				* 2
	lea	_HunkActions(pc),A1
	move.w	0(A1,D2.w),D2
	jmp	0(A1,D2.w)			Jump to appropriate sub-routine

.error
	moveq	#-1,D0
	rts

DEFAC	MACRO
	dc.w	_\1-_HunkActions
	ENDM

_HunkActions		;			Jump-table
	DEFAC	HunkUnit
	DEFAC	HunkName
	DEFAC	HunkCode
	DEFAC	HunkData
	DEFAC	HunkBSS
	DEFAC	HunkReloc32
	DEFAC	HunkReloc16
	DEFAC	HunkReloc8
	DEFAC	HunkExtern
	DEFAC	HunkSymbol
	DEFAC	HunkDebug
	DEFAC	HunkEnd
	DEFAC	HunkHeader
	DEFAC	HunkUnknown
	DEFAC	HunkOverlay
	DEFAC	HunkBreak
	DEFAC	HunkDRel32
	DEFAC	HunkDRel16
	DEFAC	HunkDRel8
	DEFAC	HunkLib
	DEFAC	HunkIndex
	DEFAC	HunkReloc32Short
	DEFAC	HunkRelReloc32
	DEFAC	HunkRelReloc16

* ################################################################

_HunkUnit	; A0 -string
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_GetHunkLength			Length name of defintition
	cmpi.l	#-1,D0
	beq.s	.error
	tst.l	D0
	beq.s	.done

	bsr.w	_GetHunkName			Get the name of this definition
	cmpi.l	#-1,D0
	beq.s	.error

	pea	_HunkNameBuf(A5)
	pea	_NameStr(pc)
	bsr.w	_SPrintF			Write down the name
	addq.l	#8,sp

.done
	bsr.w	_PrintLF
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run
.error
	rts


_HunkName
	bra.s	_HunkUnit			Same as HunkUnit...

* ################################################################

_HunkCode
	move.l	D0,D6				Original hunk with memory-flags set
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_GetHunkLength			Amount longwords of this segment (pure datas)
	cmpi.l	#-1,D0
	beq.s	.error
	tst.l	D0
	beq.s	.done

	lsl.l	#2,D0
	add.l	D0,_ByteSize(A5)
	move.l	D0,-(sp)
	pea	_CodeStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp	

.testFast		;			Check the set memory-flags...
	btst	#31,D6
	beq.s	.testChip

	pea	_HunkFastStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testChip
	btst	#30,D6
	beq.s	.testAdvi
	
	pea	_HunkChipStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testAdvi
	btst	#29,D6
	beq.s	.done

	pea	_HunkAdviStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.done
	bsr.w	_PrintLF
	move.l	_HunkSize(A5),D0		Amount longwords of segment
	bsr.w	_SkipHunk			Overread them
	bsr.w	_GetCurrentHunk			Get current hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts
* ################################################################

_HunkData
	bra.s	_HunkCode			Same as HunkCode

* ################################################################

_HunkBSS
	move.l	D0,D6				Original hunk with memory-flags set
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_GetHunkLength			Get amount longwords of empty data words
	cmpi.l	#-1,D0
	beq.s	.error
	tst.l	D0
	beq.s	.done

	lsl.l	#2,D0
	add.l	D0,_ByteSize(A5)
	move.l	D0,-(sp)
	pea	_CodeStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp	

.testFast		;			Check the set memory-flags...
	btst	#31,D6
	beq.s	.testChip

	pea	_HunkFastStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testChip
	btst	#30,D6
	beq.s	.testAdvi
	
	pea	_HunkChipStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testAdvi
	btst	#29,D6
	beq.s	.done

	pea	_HunkAdviStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.done
	bsr.w	_PrintLF
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts

* ################################################################

_HunkReloc32
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_PrintLF
.loop
	bsr.w	_GetHunkLength
	cmpi.l	#-1,D0
	beq.s	.error
	tst.l	D0
	beq.s	.done

	move.l	D0,D4				Number of relocations
	add.l	D0,_Relocs(A5)
	bsr.w	_GetHunkLength
	cmpi.l	#-1,D0
	beq.s	.error

	move.l	D0,D5				Related to hunk 'n'

	move.l	D5,-(sp)
	move.l	D4,-(sp)
	pea	_Reloc32Str(pc)
	bsr.w	_SPrintF
	lea	12(sp),sp

	move.l	D4,D0
	bsr.w	_SkipHunk			Overread relocation datas

	bra.s	.loop

.done
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts

* ################################################################

_HunkReloc16
	bra.s	_HunkReloc32

* ################################################################

_HunkReloc8
	bra.s	_HunkReloc32

* ################################################################

_HunkExtern
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_PrintLF
.loop
	bsr.w	_GetHunkLength			Get EXT_xxx type
	tst.l	D0
	beq.w	.done

	cmpi.l	#-1,D0
	beq.w	.error

	move.l	D0,D1				Remember it in D1
	andi.l	#$FFFFFF,D0			Amount of longwords
	move.l	D0,_HunkSize(A5)

	clr.w	D1
	swap	D1
	lsr.w	#8,D1
	andi.l	#$FF,D1				EXT_xxx type (in D0.b)
	lea	_ExtNames(pc),A0
	cmpi.b	#3,D1
	bls.w	.symref				sym/def/abs/res

	cmpi.w	#130,D1
	beq.w	.common				com (not really supported !!!!)
.
	subi.w	#125,D1				Create index to strings
	bmi.w	.error
	cmpi.w	#15,D0
	bhi.w	.error

	move.l	D1,D2
	move.l	D1,D3
	lsl.w	#2,D2
	lsl.w	#3,D1
	add.w	D2,D1
	add.w	D3,D1				Result equal to: D1 * 13

.comref
	bsr.w	_PrintOneTab

	pea	0(A0,D1.w)
	pea	_NameStr(pc)			ref32/ref16/ref8 etc.
	bsr.w	_SPrintF
	addq.l	#8,sp

	move.l	_HunkSize(A5),D0		Get the name of this
	bsr.w	_GetHunkName
	cmpi.l	#-1,D0
	beq.w	.error
	move.l	D0,D2

	pea	_HunkNameBuf(A5)
	pea	_NameStr(pc)
	bsr.w	_SPrintF			Write down name
	addq.l	#8,sp

	cmpi.b	#7,D2
	bhi.s	.nameok0

	bsr.w	_PrintOneTab

.nameok0
	bsr.w	_GetHunkLength			Amount entries for references
	cmpi.l	#-1,D0
	beq.w	.error

	move.l	D0,D4				Number of references
	move.l	D0,-(sp)
	pea	_RefStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp
	bra.s	.refloopcheck

.refloop
	bsr.w	_GetHunkLength			Absolute value of reference
	cmpi.l	#-1,D0
	beq.w	.error

	move.l	D0,-(sp)
	pea	_CorrectStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp

.refloopcheck
	subq.w	#1,D4
	bcc.s	.refloop

	bsr.w	_PrintLF
	bra.w	.loop

.symref			;			sym/def/abs/res
	move.l	D1,D4

	bsr.w	_PrintOneTab

	move.l	D1,D2
	move.l	D1,D3
	lsl.w	#2,D2
	lsl.w	#3,D1
	add.w	D2,D1
	add.w	D3,D1

	pea	0(A0,D1.w)
	pea	_NameStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp

	tst.b	D4
	beq.s	.sym_tab			Only a EXT_sym(bol)

.goon
	move.l	_HunkSize(A5),D0		Name of this
	bsr.w	_GetHunkName
	cmpi.l	#-1,D0
	beq.w	.error
	move.l	D0,D2

 	pea	_HunkNameBuf(A5)
	pea	_NameStr(pc)
	bsr.w	_SPrintF			Give out name
	addq.l	#8,sp

	cmpi.b	#7,D2
	bhi.s	.nameok

	bsr.w	_PrintOneTab

.nameok
	bsr.w	_GetHunkLength
	cmpi.l	#-1,D0
	beq.w	.error

	move.l	D0,-(sp)			Which EXT_xxx type?
	cmpi.b	#2,D4				EXT_abs(olute)?
	bne.s	.offset

	tst.l	D0
	bmi.s	.dec				Negative value - then give our as decimaL

	cmpi.l	#$400,D0			Greater then 1024?
	bls.s	.dec				If not the give out as decimal

	pea	_DefHexStr(pc)			else as hexadecimal
	bra.s	.textset

.dec
	pea	_DefDecStr(pc)			Here goes the decimal...
	bra.s	.textset

.offset
	pea	_OffsetStr(pc)			else it is an offset related value

.textset
	bsr.w	_SPrintF
	addq.l	#8,sp

	bsr.w	_PrintLF
	bra.w	.loop

.sym_tab
	move.l	_HunkSize(A5),D5		Original length of this hunk

	bsr.w	_GetHunkLength
	cmpi.l	#-1,D0
	beq.s	.error
	tst.l	D0
	beq.s	.ignore

	move.l	_FileHandle(A5),D1
	moveq	#-4,D2
	moveq	#OFFSET_CURRENT,D3
	jsr	_LVOSeek(A6)			We were one longword too far

	move.l	D5,_HunkSize(A5)
	bra.w	.goon

.ignore
	move.l	_FileHandle(A5),D1
	moveq	#-4,D2
	moveq	#OFFSET_CURRENT,D3
	jsr	_LVOSeek(A6)			We were one longword too far

	bsr.w	_PrintLF
	bra.w	.loop

.common
	subi.w	#125,D1				Not supported !!!!
	bmi.s	.error
	bra.w	.comref

.done
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts

* ################################################################

_HunkSymbol
	bra.w	_HunkExtern

* ################################################################

_HunkDebug
	bra.w	_HunkCode

* ################################################################

_HunkEnd
*	bsr.w	_PrintOneTab

*	move.l	A0,-(sp)
*	bsr.w	_SPrintF
*	addq.l	#4,sp

	move.l	_HunkNo(A5),D2			Give out 'end of hunk number n'
	move.l	D2,-(sp)
	pea	_EndHunkStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp
	addq.l	#1,D2
	move.l	D2,_HunkNo(A5)			and increase hunk-number

	move.l	A6,-(sp)
	moveq	#0,D0
	move.l	#SIGBREAKF_CTRL_C,D1
	movea.l	_SysBase(A5),A6
	jsr	_LVOSetSignal(A6)
	andi.l	#SIGBREAKF_CTRL_C,D0
	movea.l	(sp)+,A6
	bne.s	.break

*	bsr.w	_PrintLF

	bsr.w	_GetCurrentHunk
	cmpi.l	#-1,D0
	beq.s	.done
	bra.w	_HunkAnalyse
.done
	moveq	#0,D0
	rts

.break
	pea	_BreakStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp
	bra.w	_close

* ################################################################

_HunkHeader
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_PrintLF

	bsr.w	_GetCurrentHunk			Length name
	cmpi.l	#-1,D0
	beq.w	.error
	tst.l	D0
	beq.s	.nameset

	move.l	_HunkSize(A5),D0
	bsr.w	_GetHunkName
	cmpi.l	#-1,D0
	beq.w	.error

	pea	_HunkNameBuf(A5)
	pea	_NameStr(pc)
	bsr.w	_SPrintF
	addq.l	#8,sp

.nameset
	bsr.w	_GetHunkLength			Number of hunks
	cmpi.l	#-1,D0
	beq.w	.error
	move.l	D0,D4

	bsr.w	_GetHunkLength			First
	cmpi.l	#-1,D0
	beq.w	.error
	move.l	D0,D5

	bsr.w	_GetHunkLength			Last
	cmpi.l	#-1,D0
	beq.w	.error
	move.l	D0,D6

	move.l	D0,-(sp)
	move.l	D5,-(sp)
	move.l	D4,-(sp)
	pea	_ExeHeadStr(pc)
	bsr.w	_SPrintF
	lea	16(sp),sp

	sub.l	D5,D6				Last - first
	move.l	D6,D4

.loop
	bsr.w	_GetHunkLength			Size in bytes of this hunk
	cmpi.l	#-1,D0
	beq.s	.error

	move.l	D0,D6

	lsl.l	#2,D0
	move.l	D0,-(sp)
	move.l	D5,-(sp)
	pea	_HunkHeadStr(pc)		Give out size
	bsr.w	_SPrintF
	lea	 12(sp),sp

.testFast		;			Check the set memory-flags...
	btst	#31,D6
	beq.s	.testChip

	pea	_HunkFastStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testChip
	btst	#30,D6
	beq.s	.testAdvi
	
	pea	_HunkChipStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testAdvi
	btst	#29,D6
	beq.s	.testDone

	pea	_HunkAdviStr(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.testDone
	bsr.w	_PrintLF

	addq.w	#1,D5
	subq.w	#1,D4
	bpl.s	.loop	

	bsr.w	_PrintLF
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts

* ################################################################

_HunkUnknown
	moveq	#-1,D0				Error !!!
	rts

* ################################################################

_HunkOverlay
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_PrintLF

	bsr.w	_GetCurrentHunk
	cmpi.l	#-1,D0
	beq.s	.error
	move.l	D0,D4				Table size

	bsr.w	_GetCurrentHunk
	cmpi.l	#-1,D0
	beq.s	.error
	move.l	D0,D5				Max. level

	bsr.w	_GetCurrentHunk
	cmpi.l	#-1,D0
	beq.s	.error
	move.l	D0,D6				Amount datas

	move.l	D6,-(sp)
	move.l	D5,-(sp)
	move.l	D4,-(sp)
	pea	_OverlayStr(pc)
	bsr.w	_SPrintF
	lea	16(sp),sp

	subq.l	#1,D4				Table size minus 1
	move.l	D4,D0
	bsr.w	_SkipHunk			Overread table

	bsr.w	_PrintLF
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts

* ################################################################

_HunkBreak
*	bsr.w	_PrintOneTab

*	move.l	A0,-(sp)
*	bsr.w	_SPrintF
*	addq.l	#4,sp

*	bsr.w	_PrintLF

	bsr.w	_GetCurrentHunk			Get next hunk
	cmpi.l	#-1,D0
	beq.s	.done				If an error occurred...
	bra.w	_HunkAnalyse			else re-run
.done
	moveq	#0,D0				End of file reached...
	rts

* ################################################################

_HunkDRel32
	bsr.w	_PrintOneTab

	move.l	A0,-(sp)
	bsr.w	_SPrintF
	addq.l	#4,sp

	bsr.w	_PrintLF

	moveq	#0,D5

.relloop
	bsr.w	_GetHunkLength			Amount words in high-word
	cmpi.l	#-1,D0
	beq.w	.error

	swap	D0
	tst.w	D0
	beq.s	.done				No more relocations any more
	swap	D0

	move.l	D0,D1
	swap	D0
	andi.l	#$FFFF,D0			Amount relocations
	add.l	D0,_Relocs(A5)
	andi.l	#$FFFF,D1			Hunk number relocation related to

	move.l	D0,D4

	move.l	D1,-(sp)
	move.l	D4,-(sp)
	pea	_AmountStr(pc)
	bsr.w	_SPrintF
	lea	12(sp),sp

	move.l	_FileHandle(A5),D1
	move.l	D4,D2
	lsl.l	#1,D2				Words into bytes
	add.l	D2,D5				Amount bytes
	moveq	#OFFSET_CURRENT,D3
	jsr	_LVOSeek(A6)			Overread relocations

	bra.s	.relloop

.done
	move.l	D5,D2				Bytes of datas ignored
	addq.l	#3,D2
	andi.l	#-4,D2				Modulo 4
	sub.l	D5,D2				Even or odd amount of datas ignored (longword aligned?)
	beq.s	.realdone

	move.l	_FileHandle(A5),D1
	moveq	#-2,D2
	moveq	#OFFSET_CURRENT,D3
	jsr	_LVOSeek(A6)			Was odd, thus we are one word too far

.realdone
	bsr.w	_GetCurrentHunk			Get next hunk
	bra.w	_HunkAnalyse			and re-run

.error
	moveq	#-1,D0
	rts

* ################################################################

_HunkDRel16
	bra.w	_HunkDRel32

* ################################################################

_HunkDRel8
	bra.w	_HunkDRel32

* ################################################################

_HunkLib
	moveq	#0,D0				Not supported !!!!
	rts

* ################################################################

_HunkIndex
	moveq	#0,D0				Not supported !!!!
	rts

* ################################################################

_HunkReloc32Short
	bra.w	_HunkDRel32

* ################################################################

_HunkRelReloc32
	moveq	#0,D0				Not supported !!!!
	rts

* ################################################################

_HunkRelReloc16
	moveq	#0,D0				Not supported !!!!
	rts

* ################################################################

_SPrintF	; C-printf alike, only different that words can be dropped. Requires reverse arguments on stack.
	move.l	A6,-(sp)
	move.l	D3,-(sp)
	move.l	D2,-(sp)

	moveq	#0,D0
	move.l	D0,_SPBufCnt(A5)		No chars in SPBuffer

	move.l	3*4+4(sp),A0			Text
	lea	3*4+8(sp),A1			Fmt
	lea	_SPHook(pc),A2			Procedure
	movea.l	A5,A3				Table
	movea.l	_SysBase(A5),A6
	jsr	_LVORawDoFmt(A6)		Format them

	tst.l	_CacheFlag(A5)			Did we use the 'Cache'
	beq.s	0$

	move.l	_CachedSize(A5),D0		Amount bytes stored in register D0
	cmpi.w	#FlushSize,D0			'Cache' full
	bls.s	1$

	bsr.w	_FlushCache			As it says...
	bra.s	1$

0$
	move.l	_SPBufCnt(A5),D3
	subq.w	#1,D3
	bmi.s	1$
	beq.s	1$
	move.l	_stdout(A5),D1			Console or file
	lea	_SPBuffer(A5),A0		Address datas
	move.l	A0,D2				to D2
	movea.l	_DOSBase(A5),A6
	jsr	_LVOWrite(A6)			Write 'em
1$
	move.l	(sp)+,D2
	move.l	(sp)+,D3
	movea.l	(sp)+,A6
	rts					Back

_SPHook
	move.l	A5,-(sp)
	movea.l	A3,A5

	tst.l	_CacheFlag(A5)
	bne.s	3$

	move.l	_SPBufCnt(A5),D1
	cmpi.l	#77,D1
	bls.s	1$

	movem.l	D0/D2-D3/A6,-(sp)		Overflow of SPBuffer not very far...

	move.l	_stdout(A5),D1
	lea	_SPBuffer(A5),A0
	move.l	A0,D2
	move.l	_SPBufCnt(A5),D3
	movea.l	_DOSBase(A5),A6
	jsr	_LVOWrite(A6)			Flush SPBuffer

	moveq	#0,D0				No characters in SPBuffer
	move.l	D0,_SPBufCnt(A5)

	movem.l	(sp)+,D0/D2-D3/A6
1$
	lea	_SPBuffer(A5),A0
	move.l	_SPBufCnt(A5),D1
	move.b	D0,0(A0,D1.w)
	addq.b	#1,D1
	move.l	D1,_SPBufCnt(A5)
2$
	movea.l	(sp)+,A5
	rts
3$
	tst.b	D0
	beq.s	2$
	movea.l	_StrCache(A5),A0
	move.l	_CachedSize(A5),D1
	move.b	D0,0(A0,D1.w)
	addq.w	#1,D1
	move.l	D1,_CachedSize(A5)
	bra.s	2$

* ################################################################

_PrintResult
	tst.l	_FileType(A5)
	beq.w	.done

	tst.l	_Relocs(A5)
	beq.w	.PCRelative

	move.l	_Relocs(A5),D1
	move.l	_ByteSize(A5),D0
	divu.w	D1,D0
	cmpi.w	#999,D0
	bhi.s	.bloodygood
	cmpi.w	#250,D0
	bhi.s	.well
	cmpi.w	#125,D0
	bhi.s	.ok
	cmpi.w	#70,D0
	bhi.s	.notgood
.bad
	pea	_R6Str(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp
	bra.s	.done
.notgood
	moveq	#14,D0
	pea	_R5Str(pc)
	move.l	D0,-(sp)
	pea	_R0Str(pc)
	bsr.w	_SPrintF
	lea	16(sp),sp
	bra.s	.done
.ok
	moveq	#8,D0
	pea	_R4Str(pc)
	move.l	D0,-(sp)
	pea	_R0Str(pc)
	bsr.w	_SPrintF
	lea	16(sp),sp
	bra.s	.done
.well
	moveq	#4,D0
	pea	_R3Str(pc)
	move.l	D0,-(sp)
	pea	_R0Str(pc)
	bsr.w	_SPrintF
	lea	16(sp),sp
	bra.s	.done
.bloodygood
	moveq	#1,D0
	pea	_R2Str(pc)
	move.l	D0,-(sp)
	pea	_R0Str(pc)
	bsr.w	_SPrintF
	lea	16(sp),sp
	bra.s	.done
.PCRelative
	pea	_R1Str(pc)
	bsr.w	_SPrintF
	addq.l	#4,sp

.done
	rts


* ################################################################

_HunkNames
	dc.b	'HUNK_UNIT        ',0		; 3E7
	dc.b	'HUNK_NAME        ',0		; 3E8
	dc.b	'HUNK_CODE        ',0		; 3E9
	dc.b	'HUNK_DATA        ',0		; 3EA
	dc.b	'HUNK_BSS         ',0		; 3EB
	dc.b	'HUNK_RELOC32     ',0		; 3EC
	dc.b	'HUNK_RELOC16     ',0		; 3ED
	dc.b	'HUNK_RELOC8      ',0		; 3EE
	dc.b	'HUNK_EXTERN      ',0		; 3EF	*
	dc.b	'HUNK_SYMBOL      ',0		; 3F0
	dc.b	'HUNK_DEBUG       ',0		; 3F1
	dc.b	'HUNK_END         ',0		; 3F2
	dc.b	'HUNK_HEADER      ',0		; 3F3
	dc.b	'-#-#-#-#-#-#-    ',0		; 3F4
	dc.b	'HUNK_OVERLAY     ',0		; 3F5
	dc.b	'HUNK_BREAK       ',0		; 3F6
	dc.b	'HUNK_DREL32      ',0		; 3F7
	dc.b	'HUNK_DREL16      ',0		; 3F8
	dc.b	'HUNK_DREL8       ',0		; 3F9
	dc.b	'HUNK_LIB         ',0		; 3FA
	dc.b	'HUNK_INDEX       ',0		; 3FB
	dc.b	'HUNK_RELOC32SHORT',0		; 3FC
	dc.b	'HUNK_RELRELOC32  ',0		; 3FD	*
	dc.b	'HUNK_RELRELOC16  ',0		; 3FE	*

* ################################################################

_ExtNames
	dc.b	'EXT_SYMBOL  ',0
	dc.b	'EXT_DEFINT  ',0
	dc.b	'EXT_ABSOLUTE',0
	dc.b	'EXT_RESIDENT',0
	dc.b	'EXT_ABSREF32',0
	dc.b	'EXT_COMMON  ',0
	dc.b	'EXT_PC_REF16',0
	dc.b	'EXT_PC_REF8 ',0
	dc.b	'EXT_DATREL32',0
	dc.b	'EXT_DATREL16',0
	dc.b	'EXT_DATREL8 ',0
	dc.b	'EXT_PC_REL32',0
	dc.b	'EXT_RELCOM32',0
	dc.b	'EXT_ABSREF16',0
	dc.b	'EXT_ABSREF8 ',0

* ################################################################

_ExeObjStr
	dc.b	'Hunk layout of AmigaDOS load file "%s" (%ld bytes filesize)',10,0
_LnkObjStr
	dc.b	'Hunk layout of linker object file "%s" (%ld bytes filesize)',10,0
_NameStr
	dc.b	9,'%s',0
_OffsetStr
	dc.b	9,'related to offset 0x%lx',0
_RefStr
	dc.b	9,'%ld reference(s)',0
_DefDecStr
	dc.b	9,'= %ld',0
_DefHexStr
	dc.b	9,'= 0x%lx',0
_CorrectStr
	dc.b	', 0x%lx',0
_CodeStr
	dc.b	'%ld bytes',0
_AmountStr
	dc.b	9,9,'%4ld short relocation(s) for hunk #%ld',10,0
_ErrorStr
	dc.b	'A hunk error encountered! File not valid!',10,0
_OkStr
	dc.b	'Done.',10,0
_ExeHeadStr
	dc.b	9,9,'Number of hunks: %ld. First hunk to load #%ld, last hunk to load #%ld.',10,0
_HunkHeadStr
	dc.b	9,9,'-> Hunk #%ld requires a storage of %ld bytes.',0
_HunkChipStr
	dc.b	9,'» Hunk will be forced to CHIP-memory.',0
_HunkFastStr
	dc.b	9,'» Hunk will be forced to FAST-memory.',0
_HunkAdviStr
	dc.b	9,'» Hunk has got the ADVISORY bit set.',0
_Reloc32Str
	dc.b	9,9,'%4ld long relocation(s) for hunk #%ld',10,0
_StartHunkStr
	dc.b	10,'--- Starting with hunk #0 ----------',10,10,0
_EndHunkStr
	dc.b	10,'--- End of hunk #%ld -----------------',10,10,0
_OverlayStr
	dc.b	9,9,'%ld table entries, %ld overrides with %ld bytes of data',0

* ################################################################

_R0Str
	dc.b	10,'DropHunk''s rating: Less than or equal to %ld relocations per 1000 bytes.',10,'»» %s',10,10,0
_R1Str
	dc.b	10,'DropHunk''s rating: Position-independent code, bloody well done; Assembler used?',10,10,0
_R2Str
	dc.b	'Very well done; Assembler used?',0
_R3Str
	dc.b	'Yes, nothing against it; strong compiler used.',0
_R4Str
	dc.b	'Good average; compiler is ok.',0
_R5Str
	dc.b	'So - so, too many relocations; standard compiler - not too good.',0
_R6Str
	dc.b	10,'DropHunk''s rating: bad code - too many relocations; use an other compiler!',10,10,0

* ################################################################
_BreakStr
	dc.b	10,'*** Break',10,0
_Ver
	dc.b	'$VER: DropHunk 1.0 (29.11.98) Copyright ONIX',0

	END