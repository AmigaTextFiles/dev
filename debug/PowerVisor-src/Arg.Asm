_LVOoff	SET	-30
FUNCDEF	macro
_LVO\1	EQU	_LVOoff
_LVOoff	SET	_LVOoff-6
			endm

*
* C initial startup procedure under AmigaDOS
* Adapted by Jorrit Tyberghein
* 
* Use the following command line to make the cli/workbench startup
* asm -iINCLUDE: Arg.asm
*
* Use the following command line to make the resident startup
* asm -dRESIDENT -iINCLUDE: -oArgR.o Arg.asm
*
* Use the following command line to make the cli startup
* asm -dCLI -iINCLUDE: Arg.asm
*
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/alerts.i"
	INCLUDE	"exec/nodes.i"
	INCLUDE	"exec/lists.i"
	INCLUDE	"exec/ports.i"
	INCLUDE	"exec/libraries.i"
	INCLUDE	"exec/tasks.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"exec/execbase.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"workbench/startup.i"
	INCLUDE	"exec/exec_lib.i"
	INCLUDE	"libraries/dos_lib.i"

MEMFLAGS			EQU	MEMF_CLEAR+MEMF_PUBLIC
AbsExecBase		EQU	4

* some usefull macros:

callsys	macro
			CALLLIB _LVO\1
			endm
	
		xdef		_XCEXIT				* exit(code) is standard way to leave C.
		xdef		_@XCEXIT
	
		xref		_LinkerDB			* linker defined base value
		xref		__BSSBAS				* linker defined base of BSS
		xref		__BSSLEN				* linker defined length of BSS
	IFD RESIDENT
		xref		_RESLEN
		xref		_RESBASE
		xref		_NEWDATAL
		xref		__stack
	ENDC
	
*       library references

		section text,code

		xref		_argmain				* Name of C program to start with.
	
start:
		movem.l d1-d6/a0-a6,-(a7)

		move.l	a0,a2					* save command pointer
		move.l	d0,d2					* and command length
		lea		_LinkerDB,a4		* load base register
		move.l	AbsExecBase.W,a6

	IFND RESIDENT
;We do not have to clear BSS because AmigaDOS 2.0 does this for us.
;		lea		__BSSBAS,a3			* get base of BSS
;		moveq		#0,d1
;		move.l	#__BSSLEN,d0		* get length of BSS in longwords
;		bra.s		clr_lp				* and clear for length given
;clr_bss:
;		move.l	d1,(a3)+
;clr_lp:
;		dbf		d0,clr_bss
		move.l	a7,__StackPtr(A4)	* Save stack ptr
		move.l	a6,_SysBase(A4)
	ENDC
	

	IFD RESIDENT
		movem.l	d2,-(a7)
		movem.l	a0-a2,-(a7)

*------ get the size of the stack,	if CLI use cli_DefaultStack
*------										if WB use a7 - TC_SPLOWER
		move.l	ThisTask(a6),A3
		move.l	pr_CLI(A3),d1
	IFND CLI
		beq.s		fromwb
	ENDC
		lsl.l		#2,d1
		move.l	d1,a0
		move.l	cli_DefaultStack(a0),d1
		lsl.l		#2,d1					* # longwords -> # bytes
	IFND CLI
		bra.s		dostack
fromwb:
		move.l	a7,d1		 	
		sub.l		TC_SPLOWER(a3),d1 	
	ENDC
dostack:
		moveq		#0,d2					* use d2 as flag for newstack or not
		move.l	#_RESLEN,d0
		cmp.l		__stack(a4),d1		* This a4 is in the original 
					* set of data
		bcc.s		nochange	
		move.l	__stack(a4),d1
		add.l		d1,d0					* increase size of mem for new stack
		moveq		#1,d2					* set flag
		
nochange:
		move.l	d1,a3					* save stacksize to set up stack checking
		move.l	#MEMFLAGS,d1
		callsys	AllocMem
		tst.l		d0
		bne.s		ok1
		movem.l	(a7)+,d2/a0-a2
		rts

ok1:	move.l	d0,a0
		move.l	d0,a2

;a2 now has difference
		move.l	d0,a1
		move.l	#_NEWDATAL,d0
		sub.l		#_RESBASE,a4
;copy data over
cpy:
		move.l	(a4)+,(a0)+
		subq.l	#1,d0
		bne.s		cpy
;a4 now points at number of relocs
		move.l	(a4)+,d0
reloc:
		beq.s		nreloc
		move.l	a1,a0
		add.l		(a4)+,a0				* a0 now has add of reloc
		add.l		(a0),a2
		move.l	a2,(a0) 
		move.l	a1,a2					* restore offset
		subq.l	#1,d0
		bra.s		reloc

nreloc:
		move.l	a1,a4					* set up new base register
		add.l		#_RESBASE,a4

		move.l	#_RESLEN,realdatasize(a4)
		movem.l	(a7)+,a0-a2

		move.l	a6,_SysBase(A4)
		tst.b		d2
		movem.l	(a7)+,d2				* restore d2 
		movem.l	a7,__StackPtr(A4)	* Save stack ptr (movem doesn't
											* change flags)
		beq.s		nochg2

*------ set up new stack
		move.l	a4,d0
		sub.l		#_RESBASE,d0
		add.l		#_RESLEN,d0
		add.l		__stack(a4),d0		* here a4 will be pointing at the
											* new data, but _stack will be the
											* same if all goes well

		sub.l		#128,d0				* 128 down for good measure
		move.l	d0,a7
		move.l	__stack(a4),d0
		move.l	d0,4(a7)				* fill in size of new stack	
		add.l		d0,realdatasize(a4)* need to know how much to free later

nochg2:

	ENDC

clrwb:
	IFND CLI
		clr.l		_WBenchMsg(A4)
	ENDC

*-----  clear any pending signals
		moveq		#0,d0
		move.l	#$00003000,d1
		callsys	SetSignal
	
*------ attempt to open DOS library:
		lea		DOSName(PC),A1
		moveq.l	#0,D0
		callsys	OpenLibrary
		move.l	D0,_DOSBase(A4)
		bne.s		ok2
		moveq.l	#100,d0
		bra.w		exit2

ok2:
*------ are we running as a son of Workbench?
		move.l	ThisTask(a6),A3
	IFND CLI
		tst.l		pr_CLI(A3)
		beq.s		fromWorkbench
	ENDC
	
*=======================================================================
*====== CLI Startup Code ===============================================
*=======================================================================
*
* Entry: D2 = command length
*			A2 = Command pointer
fromCLI:
	
*------ find command name:
		move.l	pr_CLI(a3),a0
		add.l		a0,a0					* bcpl pointer conversion
		add.l		a0,a0
		move.l	cli_CommandName(a0),a1
		add.l		a1,a1					* bcpl pointer conversion
		add.l		a1,a1

*------ collect parameters:
		move.l	d2,d0					* get command line length
		moveq.l	#0,d1
		move.b	(a1)+,d1
		move.l	a1,_ProgramName(A4)
		add.l		d1,d0					* add length of command name
		addq.l	#1,d0					* allow for space after command 

		clr.w		-(A7)					* set null terminator for command line
		addq.l	#3,D0					* force to longword alligned number of bytes
		andi.w	#$fffc,D0			* (round up)
		addq.l	#2,d0					* one extra word
		sub.l		D0,A7					* make room on stack for command line
		subq.l	#6,D0
		clr.l		0(A7,D0)

*------ copy command line onto stack
		move.l	d2,d0					* get command line length
		subq.l	#1,d0
		add.l		d1,d2

copy_line:
		move.b	0(A2,D0.W),0(A7,D2.W)	* copy command line to stack
		subq.l	#1,d2
		dbf		d0,copy_line
		move.b	#' ',0(a7,d2.w)	* add space between command and parms
		subq.l	#1,d2

copy_cmd:
		move.b	0(a1,d2.w),0(a7,d2.w)	* copy command name to stack
		dbf		d2,copy_cmd
		move.l	A7,A1
		move.l	A1,-(A7)				* push command line address
	IFND CLI
		bra.s		main					* call C entrypoint

*=======================================================================
*====== Workbench Startup Code =========================================
*=======================================================================

fromWorkbench:

*------ we are now set up.  wait for a message from our starter
		lea		pr_MsgPort(A3),a0	* our process base
		callsys	WaitPort
		lea		pr_MsgPort(A3),a0	* our process base
		callsys	GetMsg
		move.l	d0,_WBenchMsg(a4)
		move.l	d0,-(SP)
*
		move.l	d0,a2					* get first argument
		move.l	sm_ArgList(a2),d0
		beq.s		do_cons
		move.l	_DOSBase(a4),a6
		move.l	d0,a0
		move.l	wa_Lock(a0),d1
		callsys	CurrentDir
do_cons:
		move.l	sm_ToolWindow(a2),d1	* get the window argument
		beq.s		do_main
		move.l	#MODE_OLDFILE,d2
		callsys	Open
		move.l	d0,stdin(a4)
		beq.s		do_main
		lsl.l		#2,d0
		move.l	d0,a0
		move.l	fh_Type(a0),pr_ConsoleTask(A3)
do_main:
		move.l	_WBenchMsg(A4),a0	* get address of workbench message
		move.l	a0,-(a7)				* push argv
		moveq		#0,d0
		move.l	d0,-(a7)				* push argc
		move.l	sm_ArgList(a0),a0	* get address of arguments
		move.l	wa_Name(a0),_ProgramName(A4)	* get name of program
	ENDC

*=============================================
*------ common code --------
*=============================================

main
		jsr		_argmain(PC)		* call C entrypoint
		moveq.l	#0,d0					* set successful status
		bra.s		exit2
*

_XCEXIT:
		move.l	4(SP),d0				* extract return code
_@XCEXIT:
exit2:
		move.l	d0,-(a7)
		move.l	AbsExecBase.W,a6
		move.l	_DOSBase(A4),a1
		callsys	CloseLibrary		* close Dos library

done_1c:
*------ if we ran from CLI, skip workbench cleanup:
	IFND CLI
		tst.l		_WBenchMsg(A4)
		beq.s		exitToDOS
		move.l	stdin(a4),d1
		beq.s		done_4
		callsys	Close
done_4:

*------ return the startup message to our parent
*       we forbid so workbench can't UnLoadSeg() us
*       before we are done:
		move.l	AbsExecBase.W,A6
		callsys	Forbid
		move.l	_WBenchMsg(a4),a1
		callsys	ReplyMsg
	ENDC

*------ this rts sends us back to DOS:
exitToDOS:
	IFD RESIDENT
		move.l	realdatasize(a4),d0
		move.l	a4,a1
		sub.l		#_RESBASE,a1
		move.l	AbsExecBase.W,a6
		move.l	(A7)+,d6
		movea.l	__StackPtr(a4),a5
		callsys	FreeMem
		move.l	d6,d0
		movea.l	a5,sp
	ELSE
		move.l	(A7)+,D0
		movea.l	__StackPtr(a4),SP	* restore stack ptr
	ENDC

		movem.l	(a7)+,d1-d6/a0-a6
		rts


DOSName
		dc.b		'dos.library',0

		section __MERGED,BSS
*
		xdef		_SysBase,_WBenchMsg
		xdef		_ProgramName,__StackPtr,_DOSBase

*
	ifd RESIDENT
realdatasize
		ds.b		4						* size of memory allocated for data +
											* possible stack
	endc

_SysBase			ds.b	4
_WBenchMsg		ds.b	4
__StackPtr		ds.b	4
stdin				ds.b	4
_DOSBase			ds.b	4
_ProgramName	ds.b	4
		END
