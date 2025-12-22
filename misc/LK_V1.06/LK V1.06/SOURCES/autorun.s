;	OPT	O+,OW-,L+,P=68030
;--------------------------------------------------
;	lk V1.01 AutoRun code.
;	$VER: autorun.s 1.00 (10.07.94)
;	Written by Alexis WILKE (c) 1994.
;
;	This code will create a new process and
;	then quit. Making the new process be a
;	background task.
;--------------------------------------------------

	incdir	'include:'
	incdir	'include:include.strip/'
	include	'exec/nodes.i'
	include	'dos/dosextens.i'
	include	'sw.i'

;	IFD	BARFLY
;	MC68030
;	ENDC

YES	=	0
NO	=	1
USE20	=	NO		;Use a 68020?

;	IFND	SYS				;Copy of my SYS
;SYS	MACRO
;	IFNC	'\2',''
;	MoveA.L	\2,A6
;	ENDC
;	Jsr	_\1(A6)
;	ENDM
;	ENDC

 STRUCTURE MCommandLineInterface,0
	LONG	mcli_Result2		;Value of IoErr from last command
	BSTR	mcli_SetName		;Name of current directory
	BPTR	mcli_CommandDir		;Head of the path locklist
	LONG	mcli_ReturnCode		;Return code from last command
	BSTR	mcli_CommandName	;Name of current command
	LONG	mcli_FailLevel		;Fail level (set by FAILAT)
	BSTR	mcli_Prompt		;Current prompt (set by PROMPT)
	BPTR	mcli_StandardInput	;Default (terminal) CLI input
	BPTR	mcli_CurrentInput	;Current CLI input
	BSTR	mcli_CommandFile	;Name of EXECUTE command file
	LONG	mcli_Interactive	;Boolean True if prompts required
	LONG	mcli_Background		;Boolean True if CLI created by RUN
	BPTR	mcli_CurrentOutput	;Current CLI output
	LONG	mcli_DefaultStack	;Stack size to be obtained in long words
	BPTR	mcli_StandardOutput	;Default (terminal) CLI output
	BPTR	mcli_Module		;SegList of currently loaded command
	LABEL	mcli_SIZEOF		;CommandLineInterface


CPYNM	MACRO
	Move.L	\1(A4),D1
	Beq.B	.\@exit
	Pea	$108(A0)
	Move.L	#$108,(A0)+			;Put this buffer size
	IFEQ	USE20
	Lea	(D1.L*4),A1
	ELSEIF
	Lsl.L	#$02,D1
	MoveA.L	D1,A1
	ENDC
	Move.L	A0,D1
	MoveQ	#$00,D0
	Move.B	(A1),D0
.\@cpy
	Move.B	(A1)+,(A0)+			;Copy string
	Dbf	D0,.\@cpy
	Clr.B	(A0)
	MoveA.L	(A7)+,A0
	IFC	'\2','SAVE'
	Lsr.L	#$02,D1
	ENDC
.\@exit
	IFC	'\2','SAVE'
	Move.L	D1,\1(A6)
	ENDC
	ENDM

DUPLOCK	MACRO
	Move.L	\1(A4),D0
	Beq.B	.\@nolock
	Move.L	D0,D1
	Pea	(A6)
	SYS	DupLock,A5
	MoveA.L	(A7)+,A6
.\@nolock
	Move.L	D0,\1(A6)
	ENDM


	XDEF	start

	SECTION	NOMERGE,CODE
start:
	Pea	(A2)
	Lea	start(PC),A2			;Save registers from startup
	MoveM.L	D0-D7/A0-A1,registers-start(A2)
	Move.L	(A7)+,D0
	MoveM.L	D0/A3-A6,registers+(8+2)*4-start(A2)
	SubA.L	A1,A1
	SYS	FindTask,4.W
	MoveA.L	D0,A3
	CmpI.B	#NT_PROCESS,LN_TYPE(A3)		;This should always be a process!
	Bne.B	workbench
	Move.L	pr_CLI(A3),D0			;CLI or Workbench process?
	Bne.B	cli

workbench:
	MoveA.L	start-4,A0
	IFEQ	USE20
	Pea	(4.W,A0.L*4)
	ELSEIF
	AddA.L	A0,A0
	AddA.L	A0,A0
	Pea	4(A0)
	ENDC
	MoveM.L	registers(PC),D0-D7/A0-A6	;Restore correct registers.
	Rts


cli:
	MoveQ	#$00,D7
	IFEQ	USE20
	Lea	(D0.L*4),A4
	ELSEIF
	Lsl.L	#$02,D0
	MoveA.L	D0,A4
	ENDC
	Lea	dosname-start(A2),A1
	SYS	OldOpenLibrary			;Get dos library pointer
	Tst.L	D0
	Beq	.error
	Move.L	D0,dosbase-start(A2)		;Save DOSBase for later
	MoveA.L	D0,A5
	Move.L	#$108*5+8+endcopy-startup+mcli_SIZEOF,D0
						;+8 for segment list link
						;+108 for name +108 for command
	Move.L	mcli_CommandDir(A4),D1		;Some PATH lock?
	Beq	.nocmddir
.sizecmddir
	AddQ.L	#$08,D0				;Linked list of 8 bytes
	IFEQ	USE20
	Move.L	(D1.L*4),D1
	ELSEIF
	Lsl.L	#$02,D1
	MoveA.L	D1,A0
	Move.L	(A0),D1
	ENDC
	Bne.B	.sizecmddir
.nocmddir



.usenewproc
	Move.L	D0,D4				;Keep segment size
	MoveQ	#$00,D1				;No flag requirement
	SYS	AllocMem,4.W			;Allocates the fake segment
	Move.L	D0,D5				;Not Enough memory?
	Beq	.exit
	MoveA.L	D5,A0				;fake segment is in D4 and A0 now
	Move.L	D4,(A0)+			;Save segment size
	Move.L	A0,D3


	MoveA.L	A5,A6
	Move.L	pr_CurrentDir(A3),D1
	Beq.B	.nocurdir
	SYS	DupLock
	Move.L	D0,curdir-start(A2)
.nocurdir
	Lea	window-start(A2),A0
	Move.L	A0,D1
	Move.L	#MODE_OLDFILE,D2
	SYS	Open
	Move.L	D0,input-start(A2)

	Lea	window-start(A2),A0
	Move.L	A0,D1
	Move.L	#MODE_NEWFILE,D2
	SYS	Open
	Move.L	D0,output-start(A2)

	CmpI.W	#36,LIB_VERSION(A6)
	Bcs.B	.noextra
	Move.L	pr_HomeDir(A3),D1
	Beq.B	.nohomedir
	SYS	DupLock
	Move.L	D0,homedir-start(A2)
.nohomedir


.noextra

	MoveA.L	D3,A0
	Lsr.L	#$02,D3				;We have the segment list in D3!
	Move.L	-4(A2),(A0)+			;Link with next segment
	Lea	startup-start(A2),A1		;Copy startup program
	Move.W	#(endcopy-startup)>>1-1,D0
.copystartup
	Move.W	(A1)+,(A0)+
	Dbf	D0,.copystartup


	MoveA.L	A0,A6
	Move.L	#mcli_SIZEOF,D4			;Next pointer
	Add.L	A6,D4
						;Clear some variables
	Clr.L	mcli_Result2(A6)
	Clr.L	mcli_ReturnCode(A6)
	Clr.L	mcli_StandardInput(A6)
	Clr.L	mcli_CurrentInput(A6)
	Clr.L	mcli_CurrentOutput(A6)
	Clr.L	mcli_StandardOutput(A6)
	Clr.L	mcli_CommandDir(A6)			;Defaulted to none
						;Copy some variables
	Move.L	mcli_FailLevel(A4),mcli_FailLevel(A6)
	Move.L	mcli_Interactive(A4),mcli_Interactive(A6)
	Move.L	mcli_Background(A4),mcli_Background(A6)
	Move.L	mcli_DefaultStack(A4),mcli_DefaultStack(A6)

	Move.L	D3,mcli_Module(A6)


	Move.L	mcli_CommandDir(A4),D2
	Beq.B	.reallynocmddir
	Pea	(A6)
	Lsr.L	#$02,D4
	Move.L	D4,D7
	Move.L	D4,mcli_CommandDir(A6)
	IFNE	USE20
	Lsl.L	#$02,D4
	ENDC
	MoveA.L	A5,A6
.morecmddir
	IFEQ	USE20
	Move.L	(4.W,D2.L*4),D1
	ELSEIF
	Lsl.L	#$02,D2
	MoveA.L	D2,A0
	Move.L	4(A0),D1
	ENDC
	SYS	DupLock
	IFEQ	USE20
	AddQ.L	#$08>>2,D4
	Move.L	D0,((4-8).W,D4.L*4)
	Bne.B	.cmddirok
	Clr.L	((0-8).W,D4.L*4)		;No next...
	AddQ.L	#$04,A7
	Bra	.free
.cmddirok
	Move.L	D4,((0-8).W,D4.L*4)
	Move.L	(D2.L*4),D2
	ELSEIF
	MoveA.L	D4,A0
	AddQ.L	#$08,D4
	Move.L	D4,D1
	Lsr.L	#$02,D1
	Move.L	D1,(A0)+
	Move.L	D0,(A0)+
	Bne.B	.cmddirok
	Clr.L	-8(A0)			;No next...
	AddQ.L	#$04,A7
	Bra	.free
.cmddirok
	MoveA.L	D2,A0
	Move.L	(A0),D2
	ENDC
	Bne.B	.morecmddir
	MoveA.L	(A7)+,A6
	IFEQ	USE20
	Lsl.L	#$02,D4
	Clr.L	(-8.W,D4.L)
	ELSEIF
	MoveA.L	D4,A0
	Clr.L	-8(A0)
	ENDC
.reallynocmddir

	MoveA.L	D4,A0				;Reach next data...
	CPYNM	mcli_SetName,SAVE
	CPYNM	mcli_Prompt,SAVE
	CPYNM	mcli_CommandFile,SAVE
	CPYNM	mcli_CommandName,SAVE
	Lsl.L	#$02,D1
	AddQ.L	#$01,D1
	Move.L	#$108,(A0)+
	Move.L	registers-start(A2),D0
	Move.B	D0,(A0)+
	MoveA.L	registers+4*8-start(A2),A1
	Move.L	A0,registers+4*8-start(A2)
	Tst.L	D0
	Beq.B	.nocmd
	SubQ.W	#$01,D0
.copycommandline
	Move.B	(A1)+,(A0)+			;Copy command line
	Dbf	D0,.copycommandline
.nocmd
	Clr.B	(A0)+

	MoveQ	#$00,D2
	Move.B	LN_PRI(A3),D2
	Move.L	pr_StackSize(A3),D4
	SYS	CreateProc,A5
	Tst.L	D0
	Bne.B	.done
.free
	Tst.L	D7				;It didn't work...
	Beq.B	.nodup
	MoveA.L	A5,A6
.freedup
	IFEQ	USE20
	Move.L	(4.W,D7.L*4),D1
	ELSEIF
	Lsl.L	#$02,D7
	MoveA.L	D7,A0
	Move.L	4(A0),D1
	ENDC
	Beq.B	.nodup				;<- branch on the one which made
	SYS	UnLock				;   the error...
	IFEQ	USE20
	Move.L	(D7.L*4),D7
	ELSEIF
	MoveA.L	D7,A0
	Move.L	(A0),D7
	ENDC
	Bne.B	.freedup
.nodup
	MoveA.L	D5,A1
	Move.L	(A1),D0
	SYS	FreeMem,(4).W			;Free the fake segment
.exit
	MoveA.L	A5,A1
	SYS	CloseLibrary,(4).W		;Close dos.library
	Bra.B	.error
.done
	Clr.L	-4(A2)				;Unlink following segments
.error
	MoveQ	#$00,D0
	Rts



dosname		Dc.B	"dos.library",0
window		Dc.B	"*",0
	EVEN



;--------------------------------------------------	STARTUP FOR TRANSPARENCY
startup:
	SubA.L	A1,A1
	SYS	FindTask,4.W
	MoveA.L	D0,A3
	Lea	startup-4(PC),A2
	Move.L	(A7),returncode-(startup-4)(A2)
	Lea	quit-(startup-4)(A2),A0		;Ask for a quit before to leave
	Move.L	A0,(A7)
	Lea	clistc-(startup-4)(A2),A0
	Move.L	A0,pr_CLI(A3)			;The CLI is here!

	Tst.L	pr_CurrentDir(A3)
	Bne.B	.inputexist
	Move.L	curdir(PC),pr_CurrentDir(A3)
.curdirexist
	Tst.L	pr_CIS(A3)
	Bne.B	.inputexist
	Move.L	input(PC),pr_CIS(A3)
.inputexist
	Tst.L	pr_COS(A3)
	Bne.B	.outputexist
	Move.L	output(PC),pr_COS(A3)
.outputexist
	MoveA.L	dosbase-(startup-4)(A2),A0
	CmpI.W	#36,LIB_VERSION(A0)
	Bcs.B	.lowversion
	Tst.L	pr_HomeDir(A3)
	Bne.B	.homeexist
	Move.L	homedir(PC),pr_HomeDir(A3)
.homeexist
	Tst.L	pr_CES(A3)
	Bne.B	.errexist
	Move.L	output(PC),pr_CES(A3)
.errexist
.lowversion
	MoveA.L	(A2),A2
	IFEQ	USE20
	Pea	(4.W,A2.L*4)
	ELSEIF
	AddA.L	A2,A2
	AddA.L	A2,A2
	Pea	4(A2)
	ENDC

	MoveM.L	registers(PC),D0-D7/A0-A6
	Rts
quit:
	Move.L	returncode(PC),-(A7)		;Save return pointer
	MoveM.L	D0-D7/A0-A6,-(A7)
	MoveA.L	dosbase(PC),A6

	Move.L	curdir(PC),D1
	Beq.B	.nocurdir
	SYS	UnLock
.nocurdir
	Move.L	input(PC),D1
	Beq.B	.noinput
	SYS	Close
.noinput
	Move.L	output(PC),D1
	Beq.B	.nooutput
	SYS	Close
.nooutput
	Move.L	homedir(PC),D1
	Beq.B	.nohome
	SYS	UnLock
.nohome

	Move.L	clistc+cli_CommandDir(PC),D2
	Beq.B	.nodir
.freedir
	IFEQ	USE20
	Move.L	(4.W,D2.L*4),D1
	ELSEIF
	Lsl.L	#$02,D2
	MoveA.L	D2,A2
	Move.L	4(A2),D1
	ENDC
	SYS	UnLock
	IFEQ	USE20
	Move.L	(D2.L*4),D2
	ELSEIF
	Move.L	(A2),D2
	ENDC
	Bne.B	.freedir
.nodir
	Lea	startup-4(PC),A0
	Move.L	A0,D1
	Lsr.L	#$02,D1
	SYS	UnLoadSeg
	MoveA.L	A6,A1
	SYS	CloseLibrary,(4).W
	MoveM.L	(A7)+,D0-D7/A0-A6
	Rts
registers	Ds.L	8+7
returncode	Ds.L	1
dosbase		Ds.L	1
curdir		Ds.L	1
input		Ds.L	1
output		Ds.L	1
homedir		Ds.L	1
	Ds.L	0			;.align
endcopy:
clistc

