*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 1.00	11/08/1992			*
*						*
* BUGS: 					*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

	XREF	_LVOSetMode


TRUE:		EQU	1
FALSE:		EQU	0

		section	Lock,CODE

		move.l	a0,a4
		clr.b	-1(a0,d0.l)
		openlib	Dos,ShutDown_Out

		lib	Dos,Input
		move.l	d0,_stdin

		cmp.b	#"?",(a4)
		beq	CmdLineHelp
		cmp.w	#'-?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-h',(a4)
		beq	CmdLineHelp
		cmp.b	#'h',(a4)

		bsr	GetPW
		cmp.l	#-1,d0
		beq	ShutDown

Cont1:		bsr	Lock

		lea.l	PasswordText1,a0
		bsr	Printer
		lea.l	Buffer1,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	Cont2
		bra	Cont1

Cont2:		lea.l	Buffer1,a1
		lea.l	Buffer2,a0
		bsr	CmpStrings
		tst.l	d0
		bne	Cont3
		lea.l	MismatchText2,a0
		bsr	Printer
		bra	Cont1

Cont3:		lea.l	LockedText2,a0
		bsr	Printer

		bra	ShutDown

Lock:		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		lea.l	LockedText1,a0
		bsr	Printer

		move.l	_stdin,d1
		lib	Dos,FGetC

		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		rts

ShutDown:
ShutDown1000:	closlib	Dos

ShutDown_Out:	move.l	#RETURN_OK,d0
		rts

CmdLineHelp:	lea.l	AuthorText1,a0
		bsr	Printer
		bra	ShutDown

Printer:	printa	a0
		rts

;Gets password from user
;
;Result	d0 = -1 if failed (break etc)
;

GetPW:		lea.l	PasswordText1,a0
		bsr	Printer

		lea.l	Buffer1,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	GetPW2
		lea.l	BreakText1,a0
		bsr	Printer
		bra	GetPW_OUT1

GetPW2:		cmp.l	#4,d0
		bhi	GetPW2.1
		lea.l	ShortText1,a0
		bsr	Printer
		bra	GetPW

GetPW2.1:	lea.l	PasswordText2,a0
		bsr	Printer

		lea.l	Buffer2,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	GetPW3
		lea.l	BreakText1,a0
		bsr	Printer
		bra	GetPW_OUT1

GetPW3:		lea.l	Buffer2,a0
		lea.l	Buffer1,a1
		bsr	CmpStrings
		tst.l	d0
		bne	GetPW_OUT
		lea.l	MismatchText1,a0
		bsr	Printer
		bra	GetPW
GetPW_OUT:	clr.l	d0
		rts
GetPW_OUT1:	move.l	#-1,d0
		rts

;Gets a string one letter at a time from the CLI. Handles BS correctly
;
;Input a0 = Buffer
;      d0 = Max. length
;
;Result d0 = Length (without NULL)
;

GetString2:	move.l	d0,d3
		move.l	a0,a2
		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode
		move.l	_stdin,d1
		lib	Dos,Flush
		clr.l	d4
GetString2.1:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	GetString2_OUT
		cmp.l	#8,d0			;BS
		bne	GetString2.2
		beq	DoBS
GetString2.2:	cmp.l	#3,d0			;CTRL_C
		beq	GetString2_OUT
GetString2.3:	cmp.l	#13,d0			;CR
		beq	GetString2.4
		add.l	#1,d4
		move.b	d0,(a2)+
		cmp.l	d3,d4
		bne	GetString2.1
		lea.l	MaxText1,a0
		bsr	Printer
GetString2.4:	clr.b	(a2)+
		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		move.l	d4,d0
		rts
GetString2_OUT:	move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		move.l	#-1,d0
		rts

DoBS:		tst.l	d4
		beq	DoBS_OUT
		sub.l	#1,d4
		sub.l	#1,a2
DoBS_OUT:	bra	GetString2.1

;Compares two strings.
;
;INPUT
;
;A0 String 1 (original password f.ex(?))
;A1 String 2
;
;OUTPUT
;
;D0 = 0 if not same
;    -1 if same
;
;BUGS
;

CmpStrings:	bsr	GetLength
		move.l	d3,d4		;length of string1 to d4
		push	a0
		move.l	a1,a0
		bsr	GetLength
		pull	a0
		cmp.l	d4,d3		;length of string2 in d3
		bne	CmpStrings1.1
CmpStrings1:	tst.b	(a0)
		beq	CmpStrings2
		cmp.b	(a0)+,(a1)+
		beq	CmpStrings1
CmpStrings1.1:	clr.l	d0
		rts
CmpStrings2:	move.l	#-1,d0
		rts

;Get length of text in given address
;
;Input a0 = Address of null terminated text string
;
;Result d3 = Length

GetLength:	push	a0
		clr.l	d3
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d3
		tst.b	(a0)+
		bne	GetLength2
		sub.l	#1,d3		;don't include NULL
GetLength_OUT:	pull	a0
		rts

;Checks for CTRL_C
;
;Result d0 = -1 if CTRL_C was pressed
;

CheckBreak:	clr.l	d1
		bset.l	#SIGBREAKB_CTRL_C,d1	;check for CTRL_C
		lib	Dos,CheckSignal
		btst.l	#SIGBREAKB_CTRL_C,d0
		bne	CheckBreak1
		clr.l	d0
		rts
CheckBreak1:	lea.l	BreakText1,a0
		bsr	Printer
		move.l	#-1,d0
		rts

;Structures and reservations

;Files

_stdin:		dc.l	0

;Texts to output

		dc.b	"$VER: "
AuthorText1:	dc.b	"Lock 1.01 (1.1.93) (C)opyright Tomi Blinnikka 1993",13,10,13,10

UsageText1:	dc.b	"USAGE: Lock",13,10,13,10
		dc.b	"Lock your TTY temporarily.",13,10
		dc.b	"See docs for more information.",13,10,0

BreakText1:	dc.b	"***Break",13,10,0
CRLFText1:	dc.b	13,10,0
PasswordText1:	dc.b	"Enter password: ",0
PasswordText2:	dc.b	13,10,"Re-enter password: ",0
MismatchText1:	dc.b	13,10,"Password mismatch! Please retry.",13,10,0
MismatchText2:	dc.b	13,10,"Incorrect password.",13,10,0
ShortText1:	dc.b	13,10,"Please enter a longer password. Minimum of 5 characters required.",13,10,0
MaxText1:	dc.b	13,10,"Maximum length reached (10 characters)!",13,10,0
LockedText1:	dc.b	13,10,"Your TTY is now locked.",13,10,13,10,0
LockedText2:	dc.b	13,10,"Your TTY is now unlocked",13,10,13,10,0
		ds.l	0

;library stuff

		libnames

;buffers

Buffer1:	dcb.b	12,0		;Temporary buffer for password
Buffer2:	dcb.b	12,0		;Temporary buffer for password

		END
