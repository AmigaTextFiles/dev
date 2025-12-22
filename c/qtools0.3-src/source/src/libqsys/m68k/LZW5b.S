/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/* #include "LZW5b.h" */
#define	IDENTIFIER		0x4C5A	/* 'LZ' */

#define	NOERROR			1
#define	ERROR			0
#define	ERROR_NOTCRUNCHED	-1
#define	ERROR_LESSMEM		-2
#define	ERROR_OVERFLOW		-3




	|MACHINE	MC68030


	|INCLUDE	Macros.i
|ComFast	MACRO
|	jsr	_LVO\1(a6)
|	ENDM
	.macro	ComFast	lvo
	jsr	a6@(\lvo)
	.endm
|ComExec	MACRO
|	move.l	4.w,a6
|	ComFast	\1
|	ENDM
	.macro	ComExec func
	movel	4.w,a6
	ComFast	\func
	.endm
	
	|INCLUDE	exec/memory.i
	|INCLUDE	xpk/xpk.i
	
	|INCLUDE	LVOs/exec.i
	.equ	_LVOCreatePool,-696
	.equ	_LVODeletePool,-702
	.equ	_LVOAllocPooled,-708
	.equ	_LVOFreePooled,-714

	.equ	OFFSET_SIZE,16
	.equ	OFFSET_MASK,0b01111111111111111
	.equ	LENGTH_SIZE,8
	.equ	LENGTH_MASK,0b011111111
	.equ	COMP_SIZE,((OFFSET_SIZE+7)/8)+((LENGTH_SIZE+7)/8)	| size of OFFSET+LENGTH in bytes

	.equ	INDEX_LENGTH,4					| in Bytes
	.equ	INDEX_SIZE,(INDEX_LENGTH*8)/2			| in Bits

	.equ	MAX_HISTORY,(1<<OFFSET_SIZE)-1			| in Bytes
	.equ	MIN_LENGTH,COMP_SIZE				| one greater than compressed data
	.equ	MAX_LENGTH,(1<<LENGTH_SIZE)+MIN_LENGTH-1	| in Bytes

	.equ	HistoryEntries,1000
	.equ	ArraySizeCount,4

	| a0 = input
	| a1 = output
	| d0 = inbuflen
	| d1 = outbuflen
	| d2 = maxnodes

| STRUCTURE LZBase,0
	.equ	lzb_InputLength,0
	.equ	lzb_OutputLength,4
	.equ	lzb_Input,8
	.equ	lzb_Output,12

	.equ	lzb_Index,16
	.equ	lzb_Previous,20
	.equ	lzb_PreOffset,20
	.equ	lzb_PreLength,22

	.equ	lzb_NewCount,24
	.equ	lzb_New,26			| the try one byte after
	| ...

	.equ	lzb_MemPool,30
	.equ	lzb_HashSave,34
	.equ	lzb_HashSaveBack,38
	
	.equ	lzb_Space,42
	.equ	lzb_SIZEOF,50
	

|GETOFFS	MACRO	|\1=addr, \2=dst , \3=trash
|		|\1=addr, \2=offs, \3=~
|	moveq	#0,\2
|	move.w	(\1),\2
|	ENDM
	.macro	GETOFFS addr,offs
	moveq	#0,\offs
	movew	\addr@,\offs
	.endm

|GETOFFI	MACRO	|\1,\2=addr, \3=dst , \4=trash
|		|\1,\2=addr, \3=offs, \4=~
|	moveq	#0,\3
|	move.w	(\1,\2),\3
|	ENDM
	.macro	GETOFFI addr,dist,offs
	moveq	#0,\offs
	movew	\addr@(\dist),\offs
	.endm

| *******************************************************************

	| globals
#define	inputlength	d6
#define	indexcounter	d5
#define	indexmask	d7

#define	outputbuffer	a2
#define	lzhash		a5
#define	inputbuffer	a6

#define ASCIICount	256

|extern int LZWSCrunch(register int inlen __asm__ ("d0"),
|		       register int outlen __asm__ ("d1"),
|		       register int maxnodes __asm__ ("d2"),
|		       register char *input __asm__ ("a0"),
|		       register char *output __asm__ ("a1"));
	.text
	.even
	.globl	_LZWSCrunch
_LZWSCrunch:
	moveml	d2-d7/a1-a6,sp@-
	movew	#IDENTIFIER,a1@+				| identifier LZ
	movel	d0,a1@+						| for size

	lea	sp@(-lzb_SIZEOF),sp
	moveml	d0-d1/a0-a1,sp@
	clrl	sp@(lzb_Previous)
	clrw	sp@(lzb_NewCount)
	clrl	sp@(lzb_New)

	movel	d2,d7						| maxnodes

| ***** Analyse inputstream *****************************************

AnalyseAndAllocateLZW:
	movel	#0xFFFFFFFF,a4

	|movel	#MEMF_FAST!MEMF_PUBLIC!MEMF_CLEAR,d0
	movel	#0x10005,d0
	movel	#65536,d1
	movel	#32768,d2
	ComExec	_LVOCreatePool
	movel	d0,sp@(lzb_MemPool)
	beqw	NoMem1


	movel	#MAX_LENGTH*4+4,d0
	movel	sp@(lzb_MemPool),a0
	ComFast	_LVOAllocPooled
	movel	d0,sp@(lzb_HashSave)
	beqw	NoMem2
	movel	d0,a0
	clrl	a0@

	movel	#MAX_LENGTH*4+4,d0
	movel	sp@(lzb_MemPool),a0
	ComFast	_LVOAllocPooled
	movel	d0,sp@(lzb_HashSaveBack)
	beqw	NoMem2
	movel	d0,a0
	clrl	a0@


	movel	#(((ASCIICount*ASCIICount)*4)*2),d0
	movel	sp@(lzb_MemPool),a0
	ComFast	_LVOAllocPooled	| 256^2				| max = 65536b*8=512k
	tstl	d0
	beqw	NoMem2
	movel	d0,lzhash


	movel	#(((ASCIICount*ASCIICount)*4)*2),sp@-
	movel	lzhash,sp@-
	bsr	_FILLMEMORY
	addql	#8,sp


	movel	sp@(lzb_Input),a1
	movel	sp@(lzb_InputLength),d1
	moveq	#0,d3						| for addx
	moveq	#0,d4						| count of different symbols
	moveq	#0,d5						| count of all parsed symbols
	moveq	#1,d6						| additional count to -1 if the file is bigger than maxnodes

								| wir schaetzen die ersten xx bytes ab
	cmpl	d7,d1						| um etwas sinnvollere nodes zu bekommen
	blts	skip1
	movel	d7,d1
	addql	#4,d6						| 4*65536=262144
skip1:	movel	d1,d2

.Count:	moveq	#0,d0
	movew	a1@,d0
	addql	#1,a1
	addql	#1,lzhash@(d0:l:8)				| add one newhashsavecheck
	addxl	d3,d4						| add one new hashheader
	addql	#1,d5						| add one new hashentry
	subql	#1,d2
	bges	.Count

	movel	sp@(lzb_InputLength),d1

	cmpl	d7,d1
	blts	skip2
	movel	#((ASCIICount*ASCIICount)*5)/2,d4		| *5 = 1 header + 4 entries /2 = no double
skip2:	addl	d4,d5						| double headers for 4 bytes in back of the hashes
	addl	d4,d5						| for save
	lsll	#2,d5						| all headers+entries multiplies by 4
	movel	d5,d0
	movel	sp@(lzb_MemPool),a0
	ComFast	_LVOAllocPooled					| allocate flowing hash
	movel	d0,a4						| store it

	moveq	#0,d1
	movel	#(ASCIICount*ASCIICount)-1,d3
	movel	lzhash,a3
	
.Alloc2:
	movel	a3@,d0
	addl	d6,d0
	movel	d0,a3@+						| a minimum of 4 nodes if we doesnt parsed the hole file
	bles	skipM2
	lsll	#2,d0						| hopefully good nodes
								| very simple adaptive (static)
	addql	#8,d0						| 4 bytes backsave!!
	addl	d1,a4
	movel	d0,d1
	movel	a4,d0
	clrl	a4@
skipM2:
	movel	d0,a3@+
	dbra	d3,.Alloc2

| *******************************************************************

|AddOneH	MACRO
|	moveq	#1,d0
|	bsrw	AddHash2
|	ENDM
	.macro	AddOneH
	moveq	#1,d0
	bsrw	AddHash2
	.endm

	addql	#4,lzhash

Crunch:	movel	sp@(lzb_InputLength),inputlength		| store length as bytesleft
	movel	sp@(lzb_Output),sp@(lzb_Index)			| store output
	movel	sp@(lzb_Input),inputbuffer			| store input as currentdata
	addl	inputlength,sp@(lzb_Output)			| calculate dataend without xpk_margin

Init:	lea	sp@(lzb_Index)@(INDEX_LENGTH),outputbuffer	| get&skip indexaddress
	moveq	#0,d7						| delete indexmask, no compression
	moveq	#INDEX_SIZE-1-1,indexcounter			| delete indexcounter, one uncompresses bytes at the beginning

	AddOneH							| param of AddHash
	moveb	inputbuffer@+,outputbuffer@+			| store first three bytes, they will never be compressed

	subql	#1,inputlength

	| a2 = output
	| a4 = unused -> $FFFFFFFF
	| a5 = basehashaddress
	| a6 = input
	| a7 = relative base
	| d3 = address of longest match
	| d4 = actual matchlength
	| d5 = indexcount
	| d6 = processlength
	| d7 = indexbits

| *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	| d0 = hashcounter
	| d1 = scratch -> #0
	| d2 = scratch -> #0
	| a0 = matchaddress
	| a1 = compareaddress
	| a3 = hashaddress

	| find match loop
#define	lzhashcount	d0

#define	matchlencheck	d1
#define	maxcompare	matchlencheck
#define	maxcomparestart	d2
#define	matchoffset	d3
#define	matchlength	d4

#define	lzhashaddress	a0
#define	actualaddress	a1
#define	lzhashsymbol	a3
#define	temporaryhash	a4

InitEndian:
	moveq	#MIN_LENGTH-2,matchlength			| set first lastmatchlen, the next match must be _greater_ than 2
SkipEndian:							| -2 cause of two bytes must get (VariableLength)
	moveq	#0,d1
	movew	inputbuffer@,d1
	movel	lzhash@(d1:l:8),lzhashsymbol
	movel	lzhashsymbol@+,lzhashcount
.InAnyCaseNotLonger:
	dbra	lzhashcount,bigEndian
	braw	BrutalBreak

| *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

bigEndian:
	movel	lzhashsymbol@(lzhashcount:l:4),lzhashaddress	| get next hashpointer
	movel	inputbuffer,actualaddress			| get currentdata

	movew	actualaddress@(-1,matchlength:w),matchlencheck
	cmpw	lzhashaddress@(-1,matchlength:w),matchlencheck
	bnes	.InAnyCaseNotLonger

	addql	#MIN_LENGTH-1,lzhashaddress
	addql	#MIN_LENGTH-1,actualaddress

	| d1 = longest matchlength to beat
.MatchHit:
	movel	matchlength,matchlencheck			| get the next _higher_ lastmatchlen
	subql	#MIN_LENGTH-2,matchlencheck			| eleminate the first four bytes
	beqs	.InitCompare

#ifdef UNROLL
	movel	matchlencheck,maxcomparestart
	lsrl	#2,matchlencheck
	andw	#0b000000011,maxcomparestart
	negw	maxcomparestart
	.equ	CMPSIZE,4
	jmp	pc@(.Compp,maxcomparestart:w:CMPSIZE)
.Comp:	cmpb	lzhashaddress@+,actualaddress@+
	bnes	.InAnyCaseNotLonger
|CMPSIZE	EQU	(*-.Comp)
	cmpb	lzhashaddress@+,actualaddress@+
	bnes	.InAnyCaseNotLonger
	cmpb	lzhashaddress@+,actualaddress@+
	bnes	.InAnyCaseNotLonger
.Compp	bras	.EndLoop
.IntLoop:
	cmpl	lzhashaddress@+,actualaddress@+			| chance that in some data are
	bnes	.InAnyCaseNotLonger				| more than 8 equal byte is less
.EndLoop:
	dbra	matchlencheck,.IntLoop
#else
.IsByte:
	lsrl	#1,matchlencheck				| lsr puts last bit in carry
	bccs	.IsWord				
	cmpb	lzhashaddress@+,actualaddress@+
	bnes	.InAnyCaseNotLonger		
.IsWord:
	lsrl	#1,matchlencheck			
	bccs	.IsLong				
	cmpw	lzhashaddress@+,actualaddress@+
	bnes	.InAnyCaseNotLonger		
.IsLong:
	lsrl	#1,matchlencheck			
	bccs	.EndLoop			
	cmpl	lzhashaddress@+,actualaddress@+
	bnes	.InAnyCaseNotLonger		
.IsQuad:
	bras	.EndLoop					| length-correction for dbra
.IntLoop:
	cmpl	lzhashaddress@+,actualaddress@+			| I think quad is enough, that
	bnes	.InAnyCaseNotLonger				| means 8 equal bytes, and the
.NullCse:
	cmpl	lzhashaddress@+,actualaddress@+			| chance that in some data are
	bnes	.InAnyCaseNotLonger				| more than 8 equal byte is less
.EndLoop:
	dbra	matchlencheck,.IntLoop
#endif

.InitCompare:
	addql	#1,matchlength
	movel	lzhashaddress,matchoffset			| get matchdist from current hashdist
	subl	actualaddress,matchoffset

	movel	#MAX_LENGTH-1,maxcompare			| put MAX_LENGTH (255+4) as maximum comparisson
	subl	matchlength,maxcompare				| not longer than this
	movel	maxcompare,maxcomparestart			| get 33-2 as differencelen
.Compare:
	cmpb	lzhashaddress@+,actualaddress@+			| calculate the additional matchlength
	dbne	maxcompare,.Compare				| break if its not longer equal

	beqs	break					
	subql	#1,actualaddress				| correction of (a1)+ from compare-loop
break:
	subw	maxcompare,maxcomparestart			| added equal bytes to differencelen
	addl	maxcomparestart,matchlength			| results in new matchlen

	movel	sp@(lzb_HashSave),temporaryhash		
	addql	#1,temporaryhash@			
	movel	temporaryhash@,d1			
	movel	actualaddress,temporaryhash@(d1:l:4)		| build an temporary hashbuffer

	cmpw	#MAX_LENGTH,matchlength
	dbge	lzhashcount,bigEndian				| some speedup

| *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

|ExChng	MACRO
|	movel	lzb_HashSave(sp),d2				| exchange temp hash
|	movel	sp@(lzb_HashSaveBack),lzb_HashSave(sp)
|	movel	d2,sp@(lzb_HashSaveBack)
|	ENDM
	.macro	ExChng
	movel	sp@(lzb_HashSave),d2				| exchange temp hash
	movel	sp@(lzb_HashSaveBack),sp@(lzb_HashSave)
	movel	d2,sp@(lzb_HashSaveBack)
	.endm

|TstVal	MACRO
|	cmpw	#MIN_LENGTH-1,lzb_Previous+2(sp)
|	bgew	\1
|	ENDM	
	.macro	TstVal equal
	cmpw	#MIN_LENGTH-1,sp@(lzb_Previous+2)
	bgew	\equal
	.endm
|CmpVal	MACRO
|	cmpw	lzb_Previous+2(sp),\2				| 
|	bles	\1
|	ENDM	
	.macro	CmpVal equal,val
	cmpw	sp@(lzb_Previous+2),\val			| 
	bles	\equal
	.endm
|PutVal	MACRO
|	movemw	matchoffset/matchlength,lzb_Previous+\1(sp)	| store actual match
|	ENDM
	.macro	PutVal offs
	movemw	matchoffset/matchlength,sp@(lzb_Previous+\offs)	| store actual match
	.endm
|GetVal	MACRO
|	movemw	lzb_Previous+\1(sp),matchoffset/matchlength	| restore actual match
|	ENDM
	.macro	GetVal offs
	movemw	sp@(lzb_Previous+\offs),matchoffset/matchlength	| restore actual match
	.endm
|GetOff	MACRO
|	movew	lzb_PreOffset+\1(sp),matchoffset		| restore actual offset
|	moveq	#\2,matchlength
|	ENDM
	.macro	GetOff offs,val
	movew	sp@(lzb_PreOffset+\offs),matchoffset		| restore actual offset
	moveq	#\val,matchlength
	.endm
|DelVal	MACRO
|	clrl	lzb_Previous(sp)
|	clrw	lzb_NewCount(sp)
|	clrl	lzb_New(sp)
|	ENDM
	.macro	DelVal
	clrl	sp@(lzb_Previous)
	clrw	sp@(lzb_NewCount)
	clrl	sp@(lzb_New)
	.endm

|BakVal	MACRO
|	movemw	matchoffset/matchlength,lzb_Space(sp)
|	ENDM
	.macro	BakVal
	movemw	matchoffset/matchlength,sp@(lzb_Space)
	.endm
|ResVal	MACRO
|	movemw	lzb_Space(sp),matchoffset/matchlength
|	ENDM
	.macro	ResVal
	movemw	sp@(lzb_Space),matchoffset/matchlength
	.endm

| *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

#define	matchlencode	d1

BrutalBreak:
	cmpw	#MIN_LENGTH-1,matchlength			| check if the match is optimal
	bltw	NoMatch						| if not, do not compress
	cmpl	inputlength,matchlength
	bgtw	TstEnd

	TstVal	CheckP

| begin:
|	previous->0
|	1stnew	->0
|	2ndnew	->0
|
| abcd
| ^
| actual
|
| 1.	setp	-> previous=actual
| 2.	checkp
|
|	 abcd
|	 ^^
|	  actual
|	 previous
|
|  a.>	newp	-> 1stnew=previous
|
|	 abcd
|	 ^^^
|	   actual
|	  previous
|	 1stnew
|
|  b.<	oldp

Set1st:	PutVal	0
	movew	#1,sp@(lzb_NewCount)
	ExChng
	bras	SetP
Set2nd:	|addw	sp@(lzb_NewCount),matchlength
	addqw	#1,matchlength					|
	addqw	#1,sp@(lzb_NewCount)
	clrl	sp@(lzb_HashSave)@(0)				| delete temporary HashBuffer
SetP:	|moveq	#1,d0
	|bsr	AddHash2					| add one
	AddOneH
	addl	d0,inputbuffer
	subl	d0,inputlength
	bles	OldP
	cmpw	#MAX_LENGTH,matchlength
	bltw	SkipEndian

OldP:	cmpw	#1,sp@(lzb_NewCount)
	beqs	Set2nd
	GetVal	0
	ExChng
	subql	#2,inputbuffer
	addql	#2,inputlength
	bras	DoneP

CheckP:	subw	sp@(lzb_NewCount),matchlength
	CmpVal	OldP,matchlength

NewP:	addw	sp@(lzb_NewCount),matchlength
	cmpw	#1,sp@(lzb_NewCount)
	bgts	New2nd
New1st:	moveb	inputbuffer@(-1),outputbuffer@+
	bsr	IncIndx
	cmpw	#MAX_LENGTH,matchlength
	bltw	Set1st
	bras	DoneP
Sma2nd:	moveb	inputbuffer@(-2),outputbuffer@+
	bsr	IncIndx
	moveb	inputbuffer@(-1),outputbuffer@+
	bsr	IncIndx
	bras	Skp2nd
New2nd:	BakVal
	GetOff	0,MIN_LENGTH-1
	movel	#Sma2nd,sp@-
	bsrw	StoreC
Skp2nd:	ResVal
	cmpw	#MAX_LENGTH,matchlength
	bltw	Set1st

DoneP:	movel	#TooSmal,sp@-
	bsrs	StoreC

	movel	sp@(lzb_HashSave),temporaryhash
	movel	temporaryhash@+,d1
	beqs	.EAdd
	clrl	temporaryhash@(d1:l:4)
	movel	temporaryhash@+,inputbuffer
	movel	temporaryhash@,d0
	beqs	.TEnd
.TAdd:	subl	inputbuffer,d0
	bsrw	AddHash2
	movel	temporaryhash@+,inputbuffer
	movel	temporaryhash@,d0
	bnes	.TAdd
.TEnd:	subl	matchlength,inputbuffer

.EAdd:	movel	matchlength,d0
	subql	#3,d0
	blts	.NoAdd1
	addl	d0,inputbuffer

	|moveq	#1,d0
	|bsr	AddHash2
	AddOneH
	addl	d0,inputbuffer
	bsr	AddHash2
	addl	d0,inputbuffer
	bsr	AddHash2
	addl	d0,inputbuffer
	bras	.NoAdd2

.NoAdd1:
	addl	matchlength,inputbuffer	
.NoAdd2:
	clrl	sp@(lzb_HashSave)@(0)				| delete temporary HashBuffer
	clrl	sp@(lzb_HashSaveBack)@(0)			| delete temporary HashBuffer
	DelVal

.EndP:	braw	NextPeriod

| *******************************************************************

#define	indexsymbol	d2
#define	matchsymbol	d2

StoreC:	movew	matchlength,matchlencode		
	subw	#MIN_LENGTH-1,matchlencode			| remove them to make more space
StoreS:	cmpw	#0b01100000000000000,matchoffset			| $FFFF=1 $FFF0=15 $FF00=255 $F000=4096
	blss	set1
	cmpw	#4,matchlencode
	blts	set2
	cmpw	#0b01111000000000000,matchoffset
	blss	set1	
	cmpw	#16,matchlencode
	bges	set1
set3:	movew	matchoffset,matchsymbol
	lslw	#4,matchsymbol
	orw	matchlencode,matchsymbol
	movew	matchsymbol,outputbuffer@+			| store compressed data
	moveq	#0b010,indexsymbol
	bras	.Done
set2:	movew	matchoffset,matchsymbol
	lslw	#2,matchsymbol
	orw	matchlencode,matchsymbol
	movew	matchsymbol,outputbuffer@+			| store compressed data
	moveq	#0b001,indexsymbol
	bras	.Done
set1:	subqw	#1,matchlencode
	blts	AbortC
	moveq	#0b011,indexsymbol
	movew	matchoffset,outputbuffer@+
	moveb	matchlencode,outputbuffer@+			| store compressed data
.Done:	lsll	indexcounter,indexsymbol
	lsll	indexcounter,indexsymbol
	orl	indexsymbol,d7
	movel	sp@+,sp@
IncIndx:							| if it not reached 32 bits in index
	dbra	indexcounter,.NextBt				| continue
	movel	indexmask,sp@(lzb_Index+4)@(0)			| save indexmask
	movel	outputbuffer,sp@(lzb_Index+4)			| get indexaddress
	addql	#INDEX_LENGTH,outputbuffer			| skip indexaddress
	moveq	#INDEX_SIZE-1,indexcounter			| delete indexcounter
	moveq	#0,indexmask					| delete indexmask
.NextBt:
	rts
AbortC:	addql	#4,sp
	rts

| *******************************************************************

	| add hash loop
#define	distance	d0
|lzhashaddress	EQUR	a0
#define	lzhashnew	a1
|lzhashsymbol	EQUR	a3
#define	newhashaddress	inputbuffer

	| a5 = hash
	| d0 = next value distance
	| d1/d4 -> do not!!! scratch
AddHash2:

#define	newsymbol	d2
#define	newsymbolcount	d3

	moveq	#0,newsymbol
	movew	inputbuffer@,newsymbol
	movel	lzhash@(newsymbol:l:8),lzhashsymbol
	movel	lzhashsymbol@,newsymbolcount
	lea	lzhashsymbol@(-4,newsymbolcount:l:4),lzhashnew
	cmpl	lzhashnew@+,newhashaddress
	beqs	.UpdHsh
	cmpl	lzhashnew@+,newhashaddress
	beqs	.UpdHsh
	addql	#1,lzhashsymbol@
	movel	newhashaddress,lzhashnew@

#define	nextsymbol	newsymbol
#define	nextsymbolcount	newsymbolcount

.UpdHsh:
	moveq	#0,nextsymbol
	movew	newhashaddress@(distance:w),nextsymbol
	lea	lzhash@(-4,nextsymbol:l:8),lzhashaddress
	movel	lzhashaddress@(4),lzhashsymbol
	movel	lzhashsymbol@,nextsymbolcount
	beqs	.NoUpd

	lea	lzhashsymbol@(4),lzhashnew

#define	nextnewcount	nextsymbol

.CutIt:	cmpl	lzhashaddress@,nextsymbolcount			| compare with maximum entries, which are defineable
	blts	.DelOld
	movel	lzhashaddress@,nextnewcount
	subl	nextsymbolcount,nextnewcount
	negl	nextnewcount
	addql	#1,nextnewcount
	subl	nextnewcount,nextsymbolcount
	lea	lzhashnew@(nextnewcount:l:4),lzhashnew		| delete some entries!

#define	nextoffset	nextsymbol

.DelOld:
	movel	newhashaddress,nextoffset
	addl	distance,nextoffset
	subl	lzhashnew@+,nextoffset
	subl	#MAX_HISTORY,nextoffset				| calculate next max offset
	dblt	nextsymbolcount,.DelOld
	extl	nextsymbolcount
	bles	.DelAll

	cmpl	lzhashsymbol@,nextsymbolcount
	bnes	.UpdCpy
.NoUpd:	rts

.UpdCpy:
	movel	nextsymbolcount,lzhashsymbol@+
	subql	#4,lzhashnew
	subql	#1,nextsymbolcount
.Copy:	movel	lzhashnew@+,lzhashsymbol@+
	dbra	nextsymbolcount,.Copy
	rts

.DelAll:
	clrl	lzhashsymbol@
	rts

| *******************************************************************

TooSmal:
	cmpw	#MIN_LENGTH-1,sp@(lzb_Previous+2)
	blts	SkipMatch1
	bgtw	OldP
	| dieser Fall tritt nur auf, wenn:
	| abcd
	| ^^ im PreviousBuffer steht mehr als 16k entfernt ist, und:
	| abcd
	|   ^^ der naechste Versuch NICHT! laenger als 2 ist
	| Begruendung:
	|  -zwei strings werden in den hash geschickt
	|  -gibt es einen laengeren string?
	|  -nein
	|  -der restore wird geholt
	|  -der wb bricht ab, da zu kurz, der w bricht ab, da zu weit entfernt
	|  -ZWEI! strings stehen nun im hash
	|  -wir updaten den hash nicht, sondern geben nur die unkomprimierten
	|   bytes aus (stehen schon im hash)
	DelVal
	moveb	inputbuffer@+,outputbuffer@+			| skip uncompressed data and store it at the same time
	bsr	IncIndx
	moveq	#2,matchlength					| set fake-matchlen
	bras	SkipMatch2
TstEnd:	movel	inputlength,matchlength		
	TstVal	CheckP
	cmpl	#MIN_LENGTH-1,matchlength			| check if the match is optimal
	bgew	DoneP						| if not, do not compress
	bras	SkipMatch1
NoMatch:
	TstVal	OldP
SkipMatch1:
	moveq	#1,matchlength					| set fake-matchlen
	AddOneH
SkipMatch2:
	moveb	inputbuffer@+,outputbuffer@+			| skip uncompressed data and store it at the same time
	bsr	IncIndx
NextPeriod:
	cmpl	sp@(lzb_Output),outputbuffer
	bgts	OverFlow
	subl	matchlength,inputlength				| reduce bytesleft with matchlen
	bgtw	InitEndian					| start BigEndian

| *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

EndFle:	addl	indexcounter,indexcounter
	bset	indexcounter,d7
	movel	d7,sp@(lzb_Index)@(0)				| save indexmask
	clrw	outputbuffer@+

	movel	sp@(lzb_MemPool),a0
	ComExec	_LVODeletePool

	lea	sp@(lzb_SIZEOF),sp
	movel	a2,d0						| end of data
	moveml	sp@+,d2-d7/a1-a6
	subl	a1,d0						| begin of data
	rts

OverFlow:
	movel	sp@(lzb_MemPool),a0
	ComExec	_LVODeletePool

	lea	sp@(lzb_SIZEOF),sp
	moveml	sp@+,d2-d7/a1-a6
	moveq	#ERROR_OVERFLOW,d0
	rts
NoMem1:
	lea	sp@(lzb_SIZEOF),sp
	moveml	sp@+,d2-d7/a1-a6
	moveq	#ERROR_LESSMEM,d0
	rts
NoMem2:
	movel	sp@(lzb_MemPool),a0
	ComExec	_LVODeletePool

	lea	sp@(lzb_SIZEOF),sp
	moveml	sp@+,d2-d7/a1-a6
	moveq	#ERROR_LESSMEM,d0
	rts

|	LIST
|LZWCrunchLength	EQU	(*-LZWSCrunch)
|	NOLIST

|********************************************************************
|FillMemory by Niels Fröhling
|  00  UBYTE* buffer
|  04  ULONG  size in bytes
_FILLMEMORY:
	moveml	d0-a6,a7@-		|60+4=64
	movel	a7@(64+00),a6
	movel	a7@(64+04),d0
	addl	d0,a6			|end of buffer
	moveq	#-1,d6

	movew	a6,d1
	moveq	#3,d7
	andl	d7,d1			|3
	beqs	.is_quad
	subl	d1,d0			| max 0b011
	negw	d1
#define	FILLSIZE	2
	jmp	pc@(.is_quad,d1:w:FILLSIZE)
	moveb	d6,a6@-
.Fill:	moveb	d6,a6@-
|FILLSIZE	EQU	(*-.Fill)
	moveb	d6,a6@-	|quad align
.is_quad:
	movew	d0,d1
	andw	d7,d1			|3
	movew	d1,a7@-	|push number of single bytes (upto 3)

	moveb	d0,d1
	lsrb	#2,d1			|0b011111100
	beqs	.clr256
	subqw	#1,d1
loop4:	movel	d6,a6@-			|clear upto 256/4-1=63 longwords
	dbra	d1,loop4

.clr256:
	lsrl	#8,d0			|does set Z-flag if result is zero, doesnt it?
	beqs	.not256
	moveq	#-1,d1
	moveq	#-1,d2
	moveq	#-1,d3
	moveq	#-1,d4
	moveq	#-1,d5
	moveq	#-1,d7
	movel	d1,a0
	movel	d2,a1
	movel	d3,a2
	movel	d4,a3
	movel	d5,a4
	movel	d6,a5
	subqw	#1,d0
loop256:
	moveml	d1-a5,a6@-		|+52  52
	moveml	d1-a5,a6@-		|+52 104
	moveml	d1-a5,a6@-		|+52 156
	moveml	d1-a5,a6@-		|+52 208
	moveml	d1-a4,a6@-		|+48 256
	dbra	d0,loop256
	subl	#0x00010000,d0
	bgts	.clr256

.not256:
	movew	a7@+,d0			|pop number of single bytes (upto 3)
	negw	d0
	jmp	pc@(loop1e,d0:w:FILLSIZE)
	moveb	d6,a6@-			| max 0b011
	moveb	d6,a6@-			|quad align
	moveb	d6,a6@-
loop1e:
	moveml	a7@+,d0-a6
	rts

| *******************************************************************

|extern void LZWSDecrunch(register char *outLen __asm__ ("d0"),
|			  register char *input __asm__ ("a0"),
|			  register char *output __asm__ ("a1"));
	.text
	.even
	.globl	_LZWSDecrunch
_LZWSDecrunch:
	moveml	d2-d7/a0/a2,sp@-
	cmpw	#IDENTIFIER,a0@+	| identifier LZ
	bnew	.NotCrunched
	cmpl	a0@+,d0			| size
	bltw	.LessMem

	moveq	#-1,d1			| clean up for negative offsets
	moveq	#-1,d4			| clean up for negative offsets
	movew	#0b011,d5
	movew	#0b0111,d6
	movew	#0b01111,d7

.DLoop:	movel	a0@+,d2			| bits
	beqs	.RawAll
	moveq	#INDEX_SIZE-1,d3	| indexsize b/w/l
.NextD:	addl	d2,d2
	bcss	.CmpData23
	addl	d2,d2
	bcss	.CmpData1
.RawData:
	moveb	a0@+,a1@+		| b/w/l		-------------->
	dbra	d3,.NextD
	bras	.DLoop
.RawAll:
	movel	a0@+,a1@+		| and here 8* b/w/l  -------------->
	movel	a0@+,a1@+
	movel	a0@+,a1@+
	movel	a0@+,a1@+
	bras	.DLoop

	| case: 01
.CmpData1:
	movew	a0@+,d1			| $FFFF + (a0)w
	beqs	.Endin
	movew	d1,d4
	asrl	#2,d1
	andw	d5,d4
	lea	a1@(d1:l),a2
	negw	d4			| 0=MIN_LENGTH-1, 1=+1, 2=+2, 3=+3
#define	MOVESIZE	2
	jmp	pc@(.Null,d4:w:MOVESIZE)
	moveb	a2@+,a1@+
	moveb	a2@+,a1@+
	moveb	a2@+,a1@+
.Null:	moveb	a2@+,a1@+
	moveb	a2@+,a1@+
	dbra	d3,.NextD
	braw	.DLoop
.Endin:	braw	.End
	| case: 10
.CmpData23:
	movew	a0@+,d1			| $FFFF + (a0)w
	beqs	.Endin
	addl	d2,d2
	bcss	.CmpData3
.CmpData2:
	movew	d1,d4
	asrl	#4,d1
	andw	d7,d4
	bgts	.DoIt
	lea	a1@(d1:l),a2		| d1 - offset, d4 - length
	bras	.Null
	| case: 11
.CmpData3:
	clrw	d4			| $FFFF00 + d4b must be there
	moveb	a0@+,d4
	addqw	#1,d4
.DoIt:	lea	a1@(d1:l),a2		| d1 - offset, d4 - length
	movew	d4,d1
	lsrw	#3,d1
	andw	d6,d4
	negw	d4
	jmp	pc@(.FastC5,d4:w:MOVESIZE)
	moveb	a2@+,a1@+
.CopyLoopLong2:
	moveb	a2@+,a1@+
	moveb	a2@+,a1@+
.FastC1:
	moveb	a2@+,a1@+
.FastC2:
	moveb	a2@+,a1@+
.FastC3:
	moveb	a2@+,a1@+
.FastC4:
	moveb	a2@+,a1@+
.FastC5:
	moveb	a2@+,a1@+
.FastC6:
	moveb	a2@+,a1@+
|MOVESIZE	EQU	(*-.FastC6)
.Fast:	dbra	d1,.CopyLoopLong2
.DoneSec2:
	dbra	d3,.NextD
	braw	.DLoop
.End:	moveml	sp@+,d2-d7/a0/a2
	movel	a0@(2),d0
	rts
.NotCrunched:
	moveml	sp@+,d2-d7/a0/a2
	moveq	#ERROR_NOTCRUNCHED,d0
	rts
.LessMem:
	moveml	sp@+,d2-d7/a0/a2
	moveq	#ERROR_LESSMEM,d0
	rts

| *******************************************************************

|extern int LZWSSize(register char *input __asm__ ("a0"));
	.text
	.even
	.globl	_LZWSSize
_LZWSSize:
	cmpw	#IDENTIFIER,a0@+	| identifier LZ
	bnew	.NotC
	movel	a0@+,d0			| size
	rts
.NotC:	moveq	#ERROR_NOTCRUNCHED,d0
	rts
