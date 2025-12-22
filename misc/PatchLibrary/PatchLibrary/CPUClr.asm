;
; CPUClr - (C) 1993 Stefan Fuchs

;replaces BltClear() with a CPU based function
;compatible to kick V36's "fill" feature 

	include exec/types.i
	include ASMMacros.i


InstallPatch	= -30	;patch
WaitRemovePatch	= -36
FindPatch	= -48

;----------------------------------------
Main:
	OPENLIB DosName,0,DosFailed	;Open Dos Library
	move.l d0,DosBase

	lea.l head(pc),a0		;Print Title Text
	bsr TextOutput

	OPENLIB PatchName,0,PatchFailed	;Open Patch Library
	move.l d0,PatchBase

	lea.l IdString(pc),a0		;Is Patch Installed
	CALL FindPatch,PatchBase
	tst.l d0
	beq install			;No ->install

	move.l d0,a0			;Remove Patch
	CALL WaitRemovePatch
	lea.l RemoveText(pc),a0
	tst.l d0
	beq exit
	lea.l RemoveFailText(pc),a0
	bra exit

install:
	lea.l NewPatch(pc),a0
	CALL InstallPatch
	lea.l InstalledText(pc),a0
	tst.l d0
	bne exit
	lea.l InstallFailText(pc),a0

exit:
	bsr TextOutput
	CLOSELIB PatchBase		;Close patch Library

PatchFailed:
	tst.l PatchBase
	bne PatchFailedSkip
	lea.l ReqPatchLib(pc),a0
	bsr TextOutput

PatchFailedSkip:
	CLOSELIB DosBase		;Close Dos Library
DosFailed:
	rts
******************************************************************V1.3*
* Name:		TextOutput
* Function:	Writes a C-string to std output (CLI,PRT,...)
* Version:	V1.2	(works)
* Assembler:	MasterSeka V1.75 & OMA V1.81
* Copyright:	1991 Stefan Fuchs
*
* Inputs:	a0 = Pointer to a C-string
* Assumptions:	DosBase
* Results:	
* Destroyed registers:
* Code:		pc-relative
* Known bugs:	
* See also:	
* Notes:	Exits without any output,
*		if the Outputhandle or a0 is null
***********************************************************************
TextOutput:
	movem.l d0-d3/a0/a1/a6,-(sp)
	moveq.l #0,d3
	move.l a0,d2
	beq.s TextOutputExit
TextOutputLoop:
	addq.l #1,d3
	tst.b (a0)+
	bne.S TextOutputLoop
	lea DosBase(pc),a0
	move.l (a0),a6
	jsr -60(a6)	;OutPut
	move.l d0,d1
	beq.s TextOutputExit
	jsr -48(a6)	;Write
TextOutputExit:
	movem.l (sp)+,d0-d3/a0/a1/a6
	rts
;-------------------------------------------------
	dc.b	"$VER: CpuClr 2.5 (16.02.1993)",0
GfxName:	dc.b "graphics.library",0
DosName:	dc.b "dos.library",0
PatchName:	dc.b "patch.library",0
IdString:	dc.b "CPUCLR0",0
head:		dc.b $9b,"1mCPUCLR V2.5 ",$9b,"0m (C) 1993 by Stefan Fuchs",10,0
ReqPatchLib:	dc.b "*** Requires patch.library in libs:",10,0
InstalledText:	dc.b "Patch successfully installed",10,0
InstallFailText:dc.b "*** Failed to install patch",10,0
RemoveText:	dc.b "Patch successfully removed",10,0
RemoveFailText:	dc.b "*** Failed to remove patch",10,0

	even
DosBase:	dc.l 0
PatchBase:	dc.l 0

NewPatch:
	dc.l NewBltClr			;pointer to the patch code to be installed
	dc.l NewBltClrEnd-NewBltClr	;optional length of NPAT_NewCode in bytes
	dc.l GfxName			;pointer to the LibraryName
	dc.w 0				;version of Library to open
	dc.w -300			;LVO of function to patch
	dc.w 0				;Priority (-127...+126) of the patch
	dc.w 0				;currently none defined (keep zero)
	dc.l IdString			;optional pointer to an IDString
	dc.l 0				;optional pointer to longword for Result2

;-----------------------------------------------
NewBltClr:
;this is the new bltclear() routine
;must be pc-relative
;A1= &memBlock
;D0= bytecount
;D1= flags

	move.l	d2,a0
	btst	#1,d1
	beq	NewBltClrSkip1	;calc size
	move.l	d0,d2
	swap 	d2
	mulu	d2,d0

NewBltClrSkip1:			;ByteSize now in d0
	moveq	#0,d2
	btst	#2,d1
	beq	NewBltClrSkip2
	move.l  d1,d2
	swap	d1		;d1 is no longer correct
	move.w	d1,d2
	tst.l	d0
	beq	NewBltClrExit	;Copy size is zero ->better exit

NewBltClrSkip2:			;fillpatten now in d2
	btst	#1,d0		;Is Bytesize a multible of 4
	beq NewBltClrSkip3	;Yes than skip this
	move.w	d2,(a1)+
	subq.l	#2,d0
	beq 	NewBltClrExit

NewBltClrSkip3:
	lsr.l	#2,d0
	subq.l	#1,d0

ClearLoop:
	move.l	d2,(a1)+
	dbra d0,ClearLoop

NewBltClrExit:
	move.l	a0,d2
	rts
NewBltClrEnd:

	END
