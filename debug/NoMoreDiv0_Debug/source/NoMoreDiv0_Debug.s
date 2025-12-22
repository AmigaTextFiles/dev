;APS00004806000048060000480600004806000048060000480600004806000048060000480600004806
*****************************************************************************
*									    *
*	PROGRAM: NoMoreDiv0_Debug.s					    *
*	VERSION: 1.7							    *
*   SOURCE CODE: 36 (10.01.2021)					    *
*      LANGUAGE: Assembler (AsmPro 1.18)				    *
*	 AUTHOR: Holger Hippenstiel/Hauptstr.38/71229 Leonberg/Germany	    *
*	  EMAIL: Holger.Hippenstiel@gmx.de				    *
*									    *
*      FUNCTION: Catches all common division by zero errors and handle them *
*		 "Enforcer-like", read NoMoreDiv0_Debug.txt		    *
*	   NOTE: "Faulty" register will be filled with 0x7fffffff,	    *
*		 if a remainder was given (like div?l.l dx,dy:dz) it will   *
*		 be filled with 0. (Register can be 0 with DEADLY-switch)   *
*									    *
*****************************************************************************
Version = 'V1.7'
MAXENTRIES = 32

	INCDIR	"A:Include2.0/"
	INCLUDE "lvo/exec_lib.i"
	INCLUDE	"lvo/dos_lib.i"
	INCLUDE "lvo/disassembler_lvo.i"
	INCLUDE	"exec/macros.i"
	INCLUDE	"exec/execbase.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"exec/semaphores.i"
	INCLUDE	"dos/dosextens.i"
	INCLUDE	"dos/dos.i"
	INCLUDE	"dos/datetime.i"
	INCLUDE "libraries/disassembler.i"
	INCLUDE	"M68k_exceptions.s"

;DivisionByZero_Vector = $14
;_LVOTaggedOpenLib = -810
;1=Gfx,2=Layer,3=Int,4=Dos,5=Icon,6=Exp,7=Util,8=Keymap,9=Gadt,10=wb

SYS:	MACRO
	jsr	_LVO\1(a6)
	ENDM

	SECTION	Starter,CODE

_serdatr = $dff018
_serdat  = $dff030
_serper  = $dff032
	
DetachStart
	lea	DetachStart-4(pc),a5
	move.l	(a5),a5
	add.l	a5,a5
	add.l	a5,a5
	addq.l	#4,a5

	lea	Data-DT(a5),a1
	move	#DataLen/4-1,d1
.ClrData
	clr.l	(a1)+			;Clear BSS
	dbf	d1,.ClrData
	
	move.l	4.w,a6
	sub.l	a1,a1
	SYS	FindTask

	move.l	d0,a2
	move.l	pr_CLI(a2),d0
	move.l	d0,FromCLI-DT(a5)
	bne.b	.StartedFromCLI

	lea	(pr_MsgPort,a4),a0
	SYS	WaitPort

	lea	(pr_MsgPort,a4),a0
	SYS	GetMsg

	move.l	d0,-(a7)
	
;Default-Args for WB-Start
	st	ArgAll-DT(a5)
	st	ArgRawIO-DT(a5)	
	st	ArgConsole-DT(a5)

	bsr.b	.StartedFromCLI

	move.l	d0,d7
	move.l	(a7)+,d5
	beq.b	.GotnoWBMsg

	move.l	4.w,a6
	SYS	Forbid

	move.l	d5,a1			;a1= ->wbstartup message
	SYS	ReplyMsg

.GotnoWBMsg:

	move.l	d7,d0
	rts

.StartedFromCLI
	lea	DosName(pc),a1
	move.l	LibList(a6),a0
	SYS	FindName

	move.l	d0,DosBase-DT(a5)
	move.l	d0,a6

	tst.l	FromCLI-DT(a5)
	beq.b	.NoArgs

	lea	Template-DT(a5),a0
	move.l	a0,d1
	lea	Args-DT(a5),a0
	move.l	a0,d2
	moveq	#0,d3
	SYS	ReadArgs

	move.l	d0,d6
	beq.b	.NoArgs

	move.l	d6,d1
	SYS	FreeArgs

.NoArgs
	tst.b	ArgAll-DT(a5)
	beq.b	.DontSetAll
	
	st	ArgDateStamp-DT(a5)
	st	ArgSegTracker-DT(a5)
	st	ArgRegs-DT(a5)
	st	ArgDisassemble-DT(a5)

.DontSetAll
	tst.b	ArgDeadly-DT(a5)
	beq.b	.NotDeadly

	clr.l	Div0Value-DT(a5)	;Return 0 instead of Maxvalue
.NotDeadly
	tst.b	ArgConsole-DT(a5)
	bne.b	.NoStdIO
	tst.b	ArgRawIO-DT(a5)
	bne.b	.NoStdIO
	st	ArgStdIO-DT(a5)
.NoStdIO
	
	tst.l	ArgWindow-DT(a5)
	beq.b	.NoOwnWindow
	move.l	ArgWindow-DT(a5),a0
	bra.b	.UseConsole
.NoOwnWindow

	lea	DefaultConsole-DT(a5),a0
	tst.b	ArgConsole-DT(a5)	
	beq.b	.NoConsole

.UseConsole
	move.l	a0,a4
	move.l	a0,d1
	move.l	#MODE_NEWFILE,d2
	SYS	Open

	move.l	d0,OutPut-DT(a5)
	bne.b	.Fine

	SYS	Output
	move.l	d0,OutPut-DT(a5)

	move.l	a4,a0
	jsr	DebugStr-DT(a5)

	bra.b	.Fine

.NoConsole
	tst.b	ArgStdIO-DT(a5)
	beq.b	.Fine

	SYS	Output
	move.l	d0,OutPut-DT(a5)

.Fine
	moveq	#1+2+4+8,d7		;68010+68020+68030+68040
	move.l	4.w,a6
	and	AttnFlags(a6),d7
	beq.b	.TableFound
	move.l	a5,-(a7)
	lea	GetBase(pc),a5
	SYS	Supervisor

	move.l	(a7)+,a5
.TableFound:
	move.l	d7,a4
	move.l	a4,VectorBase-DT(a5)
	move.l	M68k_DivisionByZero(a4),a2
	move.l	Kennung-DT(a5),d0
	cmp.l	Kennung-NewDiv0(a2),d0
	beq.w	RemoveNMD

	move.l	a2,OldDiv0-DT(a5)

******************************************************************************
*** Detach-Code
	move.l	4.w,a6
	move.l	FromCLI-DT(a5),a2
	tst.l	(a2)
	beq.b	.FromCLI

	move.l	d0,a1
	moveq	#100,d0
	SYS	SetTaskPri
	
	move.l	DetachStart-4(pc),a2
	add.l	a2,a2
	add.l	a2,a2
	jmp	4(a2)			; from WorkBench

.FromCLI
	moveq	#RETURN_FAIL,d7
	SYS	Forbid

	move.l	DosBase-DT(a5),d5
	moveq	#ML_SIZE+ME_SIZE,D0
	move.l	#MEMF_PUBLIC|MEMF_CLEAR,D1
	SYS	AllocMem

	move.l	d0,a2
	tst.l	d0
	beq.b	MemAllocFailed

	lea	ProcessName(pc),a0
	move.l	a0,d1
	moveq	#100,d2					; Priority
	move.l	DetachStart-4(pc),d3
	move.l	#MAXENTRIES*16*4+2048,d4		; StackSize
	move.l	d5,a6
	SYS	CreateProc

	move.l	4.w,a6
	tst.l	d0
	beq.b	.CreateProcFailed

	move.l	d0,a0
	lea	-pr_MsgPort(a0),a0	; Now we have process
	not.l	pr_CLI(a0)		; All MY programs will now think they were started from the CLI
	lsl.l	#2,d3
	subq.l	#4,d3
	move.l	d3,a1
	move	#1,ML_NUMENTRIES(a2)	; MemList -> ml_NumEntries	= 1
	move.l	a1,ML_ME+ME_ADDR(a2)	; MemList -> ml_me[0].me_Addr	= Segment
	move.l	(a1),ML_ME+ME_LENGTH(a2); MemList -> ml_me[0].me_Length	= Length
	lea	TC_MEMENTRY(a0),a0
	move.l	a2,a1
	SYS	AddTail			; AddTail(&Process->pr_Task.tc_MemEntry,&MemList->ml_Node);

	lea	DetachStart-4(pc),a0
	clr.l	(a0)			; Split the segments
	moveq	#RETURN_OK,d7
	bra.b	MemAllocFailed

.CreateProcFailed
	move.l	a2,a1			; CreateProc failed. Can't do anything then
	moveq	#ML_SIZE+ME_SIZE,d0
	SYS	FreeMem

MemAllocFailed
	SYS	Permit

	move.l	d7,d0			; Set return code
	rts

******************************************************************************

RemoveNMD:
	moveq	#RETURN_WARN,d7

	move.l	VectorBase-DT(a5),a4
	move.l	M68k_DivisionByZero(a4),a2
	move.l	OldDiv0-NewDiv0(a2),d6

	lea	ProcessName(pc),a1
	move.l	4.w,a6
	SYS	FindTask

	move.l	d0,a1
	tst.l	d0
	beq.b	.TaskNotFound
	
	moveq	#0,d0
	bset	#12,d0		;Ctrl-C
	SYS	Signal

	moveq	#5,d1		;Wait a while
	move.l	DosBase-DT(a5),a6
	SYS	Delay

	lea	ProcessName(pc),a1
	move.l	4.w,a6
	SYS	FindTask

	move.l	d0,a1
	tst.l	d0		;Is it still there?
	beq.b	.JustExit
	SYS	RemTask		;Kill it

	tst.b	ArgQuiet-DT(a5)
	bne.b	.NoExitMessage

	lea	NoMoreDiv0Removed-DT(a5),a0
	jsr	Print-DT(a5)

.NoExitMessage
	moveq	#RETURN_ERROR,d7
	
.TaskNotFound:
	;Maybe Non-Debugversion running, then just restore the Div0-Vector
	move.l	d6,M68k_DivisionByZero(a4)
	SYS	CacheClearU
.JustExit
	move.l	d7,d0			; Set return code
	rts

GetBase:movec	vbr,d7
	rte

DosName: dc.b "dos.library",0
ProcessName	dc.b "« NoMoreDiv0 »",0			; CreateProc makes a copy of this name

	SECTION		ProcessCode,CODE

******************************************************************************

DT:	lea	DT(pc),a5
	move.l	4.w,a6
	sub.l	a1,a1
	SYS	FindTask

	move.l	d0,OwnTask-DT(a5)

	move.l	d0,a0
	move.l	TC_SPLOWER(a0),a0
	lea	32(a0),a0
	move.l	a0,StackLower-DT(a5)
	lea	MAXENTRIES*16*4(a0),a0
	move.l	a0,StackPtrExc-DT(a5)
	move.l	a0,StackPtrMain-DT(a5)
	move.l	a0,StackPtrOrg-DT(a5)
	
	moveq	#40,d0
	lea	DisAsmName(pc),a1
	SYS	OpenLibrary

	move.l	d0,DisAsmBase-DT(a5)

	lea	SegTracker(pc),a1
	SYS	FindSemaphore

	tst.l	d0
	beq.b	.SegTrackerNotFound

	move.l	d0,a0
	move.l	SS_SIZE(a0),a0
	move.l	a0,SegBase-DT(a5)
.SegTrackerNotFound:

	lea	Div0Buffer-DT(a5),a0
	move.l	a0,Div0PtrExc-DT(a5)
	move.l	a0,Div0PtrMain-DT(a5)

	lea	NewDiv0-DT(a5),a0
	move.l	VectorBase-DT(a5),a1
	move.l	a0,M68k_DivisionByZero(a1)	;Enter new Div0

	move.l	4.w,a6
	SYS	CacheClearU

******************************************************************************

MainLoop:
	move.l	#$f000,d0	;CtrlC/D/E/F
	move.l	4.w,a6
	SYS	Wait

	btst	#12,d0		;Ctrl-C
	bne.w	CtrlC
	;btst	#13,d0		;Ctrl-D
	;bne.s	CtrlD
	;btst	#14,d0		;Ctrl-E
	;bne.s	CtrlE

;Div0 occured
	lea	DT(pc),a5		;PutChProcDis() calls here, so restore Dataptr  

	SYS	Forbid

	tst.b	ArgQuiet-DT(a5)
	bne.w	NoOutputsAtAll

******************************************************************************
	tst.b	CursorIsOff-DT(a5)
	bne.b	.AlreadySwitchedOff

	move.l	ArgRawIO-DT(a5),d7	;Cursor OFF only in Stdio/Console
	clr.l	ArgRawIO-DT(a5)

	st.b	CursorIsOff-DT(a5)
	lea	CursorOff-DT(a5),a0
	bsr.w	Print

	move.l	d7,ArgRawIO-DT(a5)
	
.AlreadySwitchedOff:
******************************************************************************

	lea	DateString(pc),a0
	clr.b	(a0)
	lea	TimeString(pc),a0
	clr.b	(a0)

	tst.b	ArgDateStamp-DT(a5)
	beq.b	OutputAllDiv0

	bsr.w	GetTheTime
	
******************************************************************************
OutputAllDiv0:
	lea	RawDoFmtData(pc),a3
	lea	DateString(pc),a0
	move.l	a0,(a3)+
	lea	TimeString(pc),a0
	move.l	a0,(a3)+

;Addr from Div-Stack
	move.l	Div0PtrMain-DT(a5),a1
	move.l	(a1),a0

	move.l	a0,(a3)+

	lea	Div0Occured(pc),a0
	lea	RawDoFmtData(pc),a1
	bsr.w	PrintFmt

******************************************************************************

	tst.b	ArgSegTracker-DT(a5)
	beq.b	.NoSegTrackerInfo

	move.l	SegBase-DT(a5),d0
	beq.b	.NoSegTrackerInfo

	move.l	d0,a4

;Addr from Div-Stack
	move.l	Div0PtrMain-DT(a5),a1
	move.l	(a1),a0

	lea	RawDoFmtData+4(pc),a1	;SegNum
	lea	RawDoFmtData+8(pc),a2	;Offset
	jsr	(a4)

	;Returns d0/a0 Name of Owner
	tst.l	d0
	beq.b	.NoSegTrackerInfo

	lea	RawDoFmtData(pc),a1
	move.l	d0,(a1)
	lea	SegTrackerInfo(pc),a0
	bsr.w	PrintFmt
.NoSegTrackerInfo:

******************************************************************************
	tst.b	ArgRegs-DT(a5)
	beq.b	.NoRegDisplay

	move.l	StackPtrMain-DT(a5),a3
	lea	-8*4(a3),a3
	move.l	a3,a1
	lea	AddrRegs(pc),a0
	bsr.w	PrintFmt

	lea	-8*4(a3),a3
	move.l	a3,a1
	move.l	a3,StackPtrMain-DT(a5)
	lea	DataRegs(pc),a0
	bsr.w	PrintFmt

.NoRegDisplay
******************************************************************************

	tst.b	ArgDisassemble-DT(a5)
	beq.w	.NoDisAsm

	lea	DisAsmBase(pc),a6
	tst.l	(a6)
	beq.w	.NoDisAsm

	move.l	(a6),a6

	lea	OutBuffer(pc),a1
	moveq	#32/4-1,d0
.Stars	move.l	#'****',(a1)+
	dbf	d0,.Stars
	move.l	#' DIS',(a1)+
	move.l	#'ASSE',(a1)+
	move.l	#'MBLE',(a1)+
	move	#'D ',(a1)+
	moveq	#32/4-1,d0
.Stars2	move.l	#'****',(a1)+
	dbf	d0,.Stars2

	move.b	#10,(a1)+
	clr.b	(a1)

	lea	OutBuffer(pc),a0
	bsr.w	Print
.NoStars

;Addr from Div-Stack
	move.l	Div0PtrMain-DT(a5),a1
	move.l	(a1),a0
	move.l	4(a1),d0		;Cmd-Len

	lea	DisAsmData(pc),a3
	move.l	a0,ds_PC(a3)		;the disassembler prints a "*" here 
	add.l	a0,d0
	addq.l	#4,d0
	move.l	d0,ds_UpTo(a3)		;where to stop the disassembly
	moveq	#6,d0
	moveq	#12,d1
	SYS	FindStartPosition	;d0 = min d1 = max Rückwärtssuche

	lea	DisAsmData(pc),a0
	move.l	d0,ds_From(a0)		;base to start disassembly from
	lea	PutChProcDis(pc),a1
	move.l	a1,ds_PutProc(a0)
	lea	OutBuffer(pc),a1
	move.l	a1,ds_UserData(a0)	;PutProc will get this in a1 & a3
	move.l	a1,ds_UserBase(a0)	;PutProc will get this in a4
	SYS	Disassemble
.NoDisAsm
******************************************************************************

NoOutputsAtAll:
	move.l	Div0PtrMain-DT(a5),a1
	clr.l	(a1)+
	clr.l	(a1)+
	move.l	a1,Div0PtrMain-DT(a5)
	tst.l	(a1)
	bne.w	OutputAllDiv0
	
	lea	Div0Buffer-DT(a5),a0
	move.l	a0,Div0PtrExc-DT(a5)
	move.l	a0,Div0PtrMain-DT(a5)

	tst.b	ArgQuiet-DT(a5)
	bne.b	.BufferWasOk

	tst.b	BufferOverrun-DT(a5)
	beq.b	.BufferWasOk

	lea	BufferWasOverflow(pc),a0
	bsr.b	Print

	clr.l	BufferOverrun-DT(a5)

.BufferWasOk:
	move.l	StackPtrOrg-DT(a5),d0
	move.l	d0,StackPtrMain-DT(a5)
	move.l	d0,StackPtrExc-DT(a5)

	move.l	4.w,a6
	SYS	Permit

	bra.w	MainLoop

******************************************************************************
*** Restore old Division by Zero to VBR and Exit
CtrlC:
	move.l	VectorBase-DT(a5),a4
	move.l	M68k_DivisionByZero(a4),a2
	move.l	OldDiv0-NewDiv0(a2),M68k_DivisionByZero(a4)
	SYS	CacheClearU

	tst.b	ArgQuiet-DT(a5)
	bne.b	.QuietTillTheEnd

	lea	NoMoreDiv0Removed(pc),a0
	bsr.b	Print

.QuietTillTheEnd	
	moveq	#0,d0
	rts

******************************************************************************

DebugStr:
	movem.l	d0-d7/a0-a6,-(a7)
	lea	RawDoFmtData(pc),a1
	move.l	a0,(a1)
	lea	DebugOutStrTxt(pc),a0
	lea	PutChProc(pc),a2
	lea	OutBuffer(pc),a3
	move.l	4.w,a6
	SYS	RawDoFmt

	lea	OutBuffer(pc),a0
	bra.b	PrintIt

******************************************************************************
;a0 = Text
;a1 = Datafield
PrintFmt:
	movem.l	d0-d7/a0-a6,-(a7)
PrintDebugFmt:
	lea	PutChProc(pc),a2
	lea	OutBuffer(pc),a3
	move.l	4.w,a6
	SYS	RawDoFmt

	lea	OutBuffer(pc),a0
	bra.b	PrintIt
	
******************************************************************************
;a0 = Text
Print:
	movem.l	d0-d7/a0-a6,-(a7)
PrintIt:
	lea	DT(pc),a5		;PutChProcDis() calls here, so restore Dataptr
	tst.b	ArgRawIO-DT(a5)
	beq.b	.NoSerialPrint

	bsr.b	SerialPrint

.NoSerialPrint
	move.l	a0,d2
.FindLen:
	tst.b	(a0)+
	bne.b	.FindLen

	move.l	a0,d3
	sub.l	d2,d3
	subq.l	#1,d3

	move.l	OutPut(pc),d1
	beq.b	NoOutput

	move.l	DosBase(pc),a6
	SYS	Write
NoOutput:
	movem.l	(a7)+,d0-d7/a0-a6
	rts

******************************************************************************

SerialPrint:
	move.l	a0,-(a7)
;	move	#372,_serper	;9600 baud ...
.NextSerChar:
	move	#$100,d0
	move.b	(a0)+,d0
	beq.b	.NoMoreChars

	cmp.b	#10,d0		; Check for a LF...
	bne.b	.NoLF		; If not one, skip...

	move.l	d0,-(sp)	; Save output character...
	moveq	#13,d0		; If an LF, output a CR...
	bsr.b	.Wait4Serial	; (call self...)

	move.l	(sp)+,d0	; Restore output character...
.NoLF:
	bsr.b	.Wait4Serial

	bra.b	.NextSerChar

.NoMoreChars:
	move.l	(a7)+,a0
	rts

.Wait4Serial:
	move	_serdatr,d1
	btst	#13,d1
	beq.b	.Wait4Serial

	and.b	#$7F,d1		; Mask it...
	cmp.b	#$18,d1		; Check for ^X
	beq.b	.ExitSerial	; If ^X, exit output...

	cmp.b	#$13,d1		; Check for ^S
	beq.b	.Wait4Serial	; Keep on waiting...

	or	#$100,d0
	move	d0,_serdat
.ExitSerial
	rts

******************************************************************************

GetTheTime:
	movem.l	a4-a6,-(sp)

	move.l	DosBase(pc),a6
	lea	CurrentDateStamp(pc),a4
	move.l	a4,d1
	SYS	DateStamp

	lea	datestr(pc),a1
	lea	DateString(pc),a0
	move.l	a0,(a1)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)
	lea	TimeString(pc),a0
	move.l	a0,(a1)
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)
	move.l	a4,d1
	SYS	DateToStr

	movem.l	(sp)+,a4-a6
	rts

******************************************************************************

;Put one char for RawDoFmt() in Buffer
PutChProc:
	move.b	d0,(a3)+
NoOutYet:
	rts

;Put one char for Disassemble() in Buffer
PutChProcDis:
	move.b	d0,(a3)+
	cmp.b	#10,d0		;Print Buffer when Return reached
	bne.b	NoOutYet

	clr.b	(a3)
	
	lea	OutBuffer(pc),a3
	move.l	a3,a0
	bra.w	Print

******************************************************************************

	odd
	dc.b	"$VER: NoMoreDiv0_Debug "
VEA:	dc.l	Version
	dc.b	" ("
	%getdate 3
	dc.b	") by Holger 'Lynxx' Hippenstiel",0
Div0Occured:
	dc.b	"%s%s *** Div0 occured at Addr: 0x%lx ***",10,0
SegTrackerInfo:
	dc.b	'SegTracker-> Name: "%s" Hunk #%ld Offset $%lx',10,0
BufferWasOverflow:
	dc.b	"*** More Div0 occured but Buffer was full !!! ***",10,0
NoMoreDiv0Removed:
	dc.b	"*** NoMoreDiv0 removed",10,0
Template:	dc.b 'DS=DATA=DATESTAMP/S,SEG=SEGTRACKER/S,REGS=REGISTER/S,DIS=DISASSEM=DISASSEMBLE/S,ALL/S,DEADLY/S,STDIO/S,CON=CONSOLE/S,WIN=WINDOW/K,SER=RAW=RAWIO/S,QUIET/S',0
	odd
DefaultConsole:	dc.b 'CON:0/0/640/256/« NoMoreDiv0 '
VEA2:		dc.l Version
		dc.b ' »/AUTO/CLOSE/WAIT/INACTIVE',0
DebugOutStrTxt:	dc.b "Can't open '%s' for output."
Return:	dc.b	10,0
CursorOff:	dc.b $9b,'0 p',0
SegTracker:	dc.b "SegTracker",0
DisAsmName:	dc.b "disassembler.library",0
AddrRegs:	dc.b 'Addr: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx',10,0
DataRegs:	dc.b 'Data: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx',10,0
;SingleReg:	dc.b 'Debug: %08lx',10,0

******************************************************************************

	CNOP	0,4

HandleRelative:
	move	d6,d0
HandleLongAbsolut:
	bra.w	MaskDReg

	CNOP	0,4

Div0Value:
	dc.l	$7fffffff
OldDiv0:dc.l	0
Kennung:dc.l	'*NMD'

NewDiv0:move	sr,-(a7)
	movem.l	d0-d7/a0-a6,-(a7)
	lea	DT(pc),a5

	tst.b	ArgQuiet-DT(a5)
	bne.b	.NoRegStorage

	tst.b	ArgRegs-DT(a5)
	beq.b	.NoRegStorage

	move.l	StackPtrExc-DT(a5),a0
	cmp.l	StackLower-DT(a5),a0
	ble.b	.NoRegStorage
	
	lea	-16*4(a0),a2
	movem.l	d0-d7,(a2)
	lea	15*4+2(a7),a1
	move.l	a1,-4(a0)	 
	movem.l	-7*4-2(a1),d0-d6
	movem.l	d0-d6,-8*4(a0)
	movem.l	(a2),d0-d7
	move.l	a2,StackPtrExc-DT(a5)

.NoRegStorage
	move.l	2+(4*15)+2(a7),a0
	movem	-8(a0),d1/d5-d7
	moveq	#8,d4		;pc-distance
	move	d5,d0
	cmp	#$4c79,d1	;div?l.l LongAddr.l,dx
	beq.b	HandleLongAbsolut

	cmp	#$4c7c,d1	;div?l.l #n,dx
	beq.b	HandleLongAbsolut

	moveq	#6,d4		;pc-distance
	cmp	#$4c78,d5	;div?l.l Addr.w,dx
	beq.b	HandleRelative

	cmp	#$4c7a,d5	;div?l.l Addr(pc),dx
	beq.b	HandleRelative

	cmp	#$4c7b,d5	;div?l.l Addr(pc,dx*z),dy
	beq.w	HandleRelative

	and	#$fff8,d0
	cmp	#$4c68,d0	;div?l.l -x(ax),dx
	beq.w	HandleRelative

	cmp	#$4c70,d0	;div?l.l -x(ax,dx.z*x),dy
	beq.w	HandleRelative

	move	d5,d1
	move	d5,d0
	and	#$f0ff,d1
	cmp	#$80f9,d1	;div? LongAddr.l,dx
	beq.b	HandleDiv

	moveq	#4,d4		;pc-distance
	move	d7,d0
	move	d6,d1
	and	#$fff0,d1
	cmp	#$4c40,d1	;div?l.l dx,dy:dz
	beq.b	MaskDReg

	cmp	#$4c50,d1	;div?l.l (ax),dx and (ax)+,dx but it was xxx8
	beq.b	MaskDReg

	cmp	#$4c60,d1	;div?l.l -(ax),dx
	beq.b	MaskDReg

	move	d6,d1
	move	d6,d0
	and	#$f0ff,d1
	cmp	#$80f8,d1	;div? Addr.w,dx
	beq.b	HandleDiv

	cmp	#$80fa,d1	;div? Addr(pc),dx
	beq.b	HandleDiv

	cmp	#$80fb,d1	;div? Addr(pc,dx*z),dx
	beq.b	HandleDiv

	cmp	#$80fc,d1	;div? #n,dx
	beq.b	HandleDiv

	and	#$f0f8,d1
	cmp	#$80e8,d1	;div? -x(ax),dx
	beq.b	HandleDiv

	cmp	#$80f0,d1	;div? -x(ax,dx*z),dx
	beq.b	HandleDiv
	
	moveq	#2,d4		;pc-distance
	move	d7,d1
	move	d7,d0
	and	#$f0f0,d1
	cmp	#$80c0,d1	;div? dx,dy
	beq.b	HandleDiv

	cmp	#$80d0,d1	;div? (ax),dx and (ax)+,dx but it was xxx8
	beq.b	HandleDiv

	cmp	#$80e0,d1	;div? -(ax),dx
	bne.b	EndDiv0

HandleDiv:
	rol	#7,d0
	bra.b	WriteAndEnd

MaskDReg:
	move	d0,d1
	rol	#4,d0
	and	#7,d1
	clr.l	(a7,d1.w*4)			;Rest 0
WriteAndEnd:
	and	#7,d0
	move.l	Div0Value(pc),(a7,d0.w*4)	;Dest D-Reg

EndDiv0:
	tst.b	ArgQuiet-DT(a5)
	bne.b	.StayQuiet

	move.l	Div0PtrExc-DT(a5),a1
	sub.l	d4,a0
	move.l	a0,(a1)+
	move.l	d4,(a1)+
	cmp.l	#Div0BufferEnd,a1
	beq.b	.BufferOverRun

	move.l	a1,Div0PtrExc-DT(a5)
	bra.b	.NormalDiv0Code

.BufferOverRun
	st	BufferOverrun-DT(a5)
.NormalDiv0Code

	move.l	4.w,a6
	move.l	OwnTask-DT(a5),a1
	moveq	#0,d0
	bset	#15,d0		;Ctrl-F
	SYS	Signal

.StayQuiet:
	movem.l	(a7)+,d0-d7/a0-a6
	move	(a7)+,sr
	rte

	CNOP	0,4

Data:
******************************************************************************
*** All Zero from here ***
******************************************************************************

CurrentDateStamp:
	ds.l	1
	ds.l	1
	ds.l	1
dateformat:
	ds.b	1	;format
	ds.b	1	;flags
	ds.l	1	;day
datestr:
	ds.l	1	;date
timestr:
	ds.l	1	;time
******************************************************************************
DateString:
	ds.b	LEN_DATSTRING
TimeString:
	ds.b	LEN_DATSTRING
******************************************************************************
VectorBase:
	ds.l	1
Div0PtrExc:
	ds.l	1
Div0PtrMain:
	ds.l	1
Div0Buffer:
	ds.l	MAXENTRIES*2	;Addr + Cmd-Len
Div0BufferEnd:
	ds.l	1
BufferOverrun:
	ds.l	1
OutPut:	ds.l	1
OwnTask:	ds.l 1
StackLower:	ds.l 1
StackPtrExc:	ds.l 1
StackPtrMain:	ds.l 1
StackPtrOrg:	ds.l 1
SegBase:	ds.l 1
DosBase:	ds.l 1
DisAsmBase:	ds.l 1
DisAsmData:	ds.b ds_SIZE
RawDoFmtData:	ds.l 4
OutBuffer:	ds.b 84
OutBufferEnd:
FromCLI:	ds.l 1
Args:
ArgDateStamp:	ds.l 1
ArgSegTracker:	ds.l 1
ArgRegs:	ds.l 1
ArgDisassemble:	ds.l 1
ArgAll:		ds.l 1
ArgDeadly:	ds.l 1
ArgStdIO:	ds.l 1
ArgConsole:	ds.l 1
ArgWindow:	ds.l 1
ArgRawIO:	ds.l 1
ArgQuiet:	ds.l 1
CursorIsOff	ds.w 1
	CNOP	0,4
DataLen=*-Data

