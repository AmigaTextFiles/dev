; Barfly2Msg.asm

		INCDIR	devpac:include31

		INCLUDE	exec/libraries.i
		INCLUDE	exec/types.i
		INCLUDE	exec/exec_lib.i
		INCLUDE	dos/dos_lib.i



		SECTION	Kode,CODE

Begin:		movem.l	d1-a6,-(SP)
		move.l	SP,_SYSSP

		bsr.w	OpenDOS

		bsr.b	Parse

ExitToDOS:	move.l	_SYSSP,SP

		bsr.w	CloseDOS

		movem.l	(SP)+,d1-a6
		moveq	#0,d0
		rts


StrCmp:
.next		move.b	(a1)+,d0
		beq.b	.equal
		cmp.b	(a0)+,d0
		beq.b	.next
		moveq	#-1,d0
		rts
.equal		moveq	#0,d0
		rts

Parse:		move.l	_DOSBase,a6

		move.l	_InputHandle,d1
		move.l	#ReadBuffer,d2
		move.l	#256-1,d3
		jsr	_LVOFGets(a6)
		tst.l	d0
		beq.w	.finished

		lea	ReadBuffer,a0
		lea	.t_error(PC),a1
		bsr.b	StrCmp
		beq.b	.error

		lea	ReadBuffer,a0
		lea	.t_warning(PC),a1
		bsr.b	StrCmp
		beq.b	.warning

		lea	ReadBuffer,a0
		lea	.t_error3(PC),a1
		bsr.b	StrCmp
		beq.b	.error

		lea	ReadBuffer,a0
		lea	.t_warning3(PC),a1
		bsr.b	StrCmp
		beq.b	.warning

		bra.b	Parse

.error		move.b	#'E',d7
		bra.b	.common

.warning	move.b	#'W',d7

.common		bsr.w	.copylinenumber
		addq.w	#4,a0		;skip ' in '
		move.l	a0,a2

		lea	.t_file(PC),a1
		bsr	StrCmp
		beq.b	.file

		move.l	a2,a0
		lea	.t_macro(PC),a1
		bsr	StrCmp
		beq.b	.macro

		move.l	a2,a0
		bra.b	.file

.macro		move.l	_InputHandle,d1
		move.l	#ReadBuffer,d2
		move.l	#256-1,d3
		jsr	_LVOFGets(a6)
		tst.l	d0
		beq.w	.finished

		lea	ReadBuffer,a0
		lea	.t_macroerror(PC),a1
		bsr	StrCmp
		bne.w	Parse

		beq.b	.common

.file		move.l	a0,a2
		cmp.b	#"`",(a2)
		bne.b	.find
		addq.w	#1,a2
		move.l	a2,a0

.find		move.b	(a2),d0
		beq.b	.eol
		cmp.b	#10,d0
		beq.b	.eol
		addq.w	#1,a2
		bra.b	.find
.eol		clr.b	(a2)
		clr.b	-(a2)
		cmp.b	#"'",-1(a2)
		bne.b	.sjov
		clr.b	-(a2)
.sjov		move.l	a0,a2


		moveq	#'<',d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		move.l	_OutputHandle,d1
		move.l	a2,d2
		jsr	_LVOFPuts(a6)

		moveq	#'>',d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		move.l	_OutputHandle,d1
		move.l	#Line,d2
		jsr	_LVOFPuts(a6)

		move.l	_InputHandle,d1
		move.l	#Line,d2
		move.l	#256-1,d3
		jsr	_LVOFGets(a6)
		tst.l	d0
		beq.w	.finished

		move.l	_InputHandle,d1
		move.l	#ReadBuffer,d2
		move.l	#256-1,d3
		jsr	_LVOFGets(a6)
		tst.l	d0
		beq.w	.finished

		move.l	d7,d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		moveq	#' ',d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		moveq	#'<',d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		cmp.b	#'W',d7
		beq.b	.add_w
		move.l	#.t_error2,d2
		bra.b	.add_e
.add_w		move.l	#.t_warning2,d2
.add_e		move.l	_OutputHandle,d1
		jsr	_LVOFPuts(a6)

		lea	Line,a0
.find_colon	cmp.b	#':',(a0)+
		bne.b	.find_colon
		addq.w	#1,a0
		move.l	a0,a2
.find_eol	cmp.b	#10,(a2)+
		bne.b	.find_eol
		clr.b	-(a2)

		move.l	a0,d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPuts(a6)

		moveq	#'>',d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		moveq	#10,d2
		move.l	_OutputHandle,d1
		jsr	_LVOFPutC(a6)

		bra.w	Parse

.finished	jsr	_LVOFlush(a6)
		rts

.copylinenumber	lea	Line,a1
		move.b	#' ',(a1)+
.again		cmp.b	#' ',(a0)
		beq.b	.done
		move.b	(a0)+,(a1)+
		bra.b	.again
.done		move.b	#' ',(a1)+
		clr.b	(a1)+
		rts

.t_error2	dc.b	"Error: ",0
.t_warning2	dc.b	"Warning: ",0
.t_error	dc.b	"Error in Line ",0
.t_error3	dc.b	"Error, Line ",0
.t_warning	dc.b	"Warning in Line ",0
.t_warning3	dc.b	"Warning, Line ",0
.t_file		dc.b	"File `",0
.t_macro	dc.b	"Macro `",0
.t_macroerror	dc.b	"Macro is located at Line ",0
.format		dc.b	"%d ",0
		EVEN


OpenDOS:	move.l	4.w,a6
		lea	.dosname(PC),a1
		moveq	#36,d0
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,_DOSBase
		beq.w	ExitToDOS
		move.l	d0,a6

		jsr	_LVOInput(a6)
		move.l	d0,_InputHandle

		jsr	_LVOOutput(a6)
		move.l	d0,_OutputHandle
		rts

.dosname	dc.b	"dos.library",0
		EVEN

CloseDOS:	move.l	4.w,a6
		move.l	_DOSBase,d0
		beq.b	.no_dos
		move.l	d0,a1
		jsr	_LVOCloseLibrary(a6)
.no_dos		rts

.version	dc.b	 "$VER: Barfly2Msg 1.00 (08.11.94)"

		SECTION	DenFedeBuffer,BSS

_SYSSP:		DS.L	1
_DOSBase:	DS.L	1
_InputHandle:	DS.L	1
_OutputHandle:	DS.L	1

ReadBuffer:	DS.B	256
Line:		DS.B	256





		END

