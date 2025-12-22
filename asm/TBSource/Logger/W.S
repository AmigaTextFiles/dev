*************************************************
*						*
*		(C)opyright 1992-93		*
*						*
*		 by Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	05/07/1992			*
*						*
* BUGS:	UpDays should've been long not word	*
*						*
* Version 1.00	10/08/1992			*
*						*
* BUGS:	Gave things like '0 day'		*
*						*
* Version 1.01	13/08/1992			*
*						*
* BUGS:	Version text was incorrect, length of	*
*	TTY_X and console reads/writes were	*
*	one byte too short. Pointers to lists	*
*	were incorrect.				*
*						*
* Version 1.02	22/08/1992			*
*						*
* BUGS:	Didn't clear whole ActionBuf.		*
*						*
* Version 1.03	14/02/1993			*
*						*
* BUGS:	Didn't add NULL after command.		*
*						*
* Version 1.04	28/02/1993			*
*						*
* Version 1.05	04/04/1993			*
*						*
* Fixed bug with command length (InfoOutText1)	*
* at last...					*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/dosextens.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	W,CODE

		move.l	a0,a4
		clr.b	-1(a0,d0.l)
		openlib	Dos,ShutDown_Out

		cmp.b	#'?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-?',(a4)
		beq	CmdLineHelp
		cmp.w	#'-h',(a4)
		beq	CmdLineHelp
		cmp.b	#'h',(a4)
		beq	CmdLineHelp
Skip1:

;Get system time
;Uptime equals (System time - NUT_timeval)
;Try to read ENV:NUT_console + ENV:NUT_TTYX
;Loop 0 - 9
;try reading ENV:UT_loadavg

Information:	bsr	GetSysTime
		bsr	GetUpTime
		bsr	DoTTYTest
		bsr	GetLoadAvg

		cmp.w	#1,Users
		bne	CheckUsrNum1
		lea.l	SingleString1,a0
		move.l	a0,UsersString
CheckUsrNum1:	bsr	Format
		lea.l	UpTimeText1,a0
		bsr	Printer

		lea.l	LoadAvgBuf,a0
		bsr	Printer

		lea.l	EndText1,a0
		bsr	Printer

		lea.l	InfoText1,a0
		bsr	Printer

		bsr	Do2TTYTest

		bra	ShutDown

CheckUpTime:	lea.l	UpTimeName,a3
		move.l	a3,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	CheckUpTime2
		move.l	d0,d4
		move.l	d0,d1
		lea.l	UpTimeBuf,a0
		move.l	a0,d2
		move.l	#3*4,d3
		lib	Dos,Read
		move.l	d4,d1
		lib	Dos,Close
		rts
CheckUpTime2:	move.l	a3,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	CheckUpTime3
		move.l	d0,d4
		move.l	d0,d1
		lea.l	DateTime1,a0
		move.l	a0,d2
		move.l	#3*4,d3
		lib	Dos,Write
		move.l	d4,d1
		lib	Dos,Close
		move.l	DateTime1,UpTimeBuf
		move.l	DateTime1+4,UpTimeBuf+4
		move.l	DateTime1+4,UpTimeBuf+4
CheckUpTime3:	rts

GetSysTime:	lea.l	DateTime1,a0
		move.l	a0,d1
		lib	Dos,DateStamp

		move.l	DateTime1+4,d0
		divu.w	#60,d0
		move.w	d0,Hours
		swap	d0
		move.w	d0,Minutes
		rts

GetUpTime:	lea.l	UpTimeName,a3
		move.l	a3,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	GetUpTime2
		move.l	d0,d4
		move.l	d0,d1
		lea.l	UpTimeBuf,a0
		move.l	a0,d2
		move.l	#3*4,d3
		lib	Dos,Read
		move.l	d4,d1
		lib	Dos,Close
		move.l	UpTimeBuf,d0
		move.l	DateTime1,d1
		sub.l	d0,d1
		move.l	d1,UpDays
		move.l	UpTimeBuf+4,d0
		move.l	DateTime1+4,d1
		sub.l	d0,d1
		bmi	GetUpTime3
GetUpTime1:	divu.w	#60,d1
		move.w	d1,UpHours
		swap	d1
		move.w	d1,UpMinutes
GetUpTime2:	rts
GetUpTime3:	move.l	UpTimeBuf+4,d0
		move.l	DateTime1+4,d1
		add.l	#1440,d1
		sub.l	d0,d1
		sub.l	#1,UpDays
		cmp.l	#1,UpDays
		bne	GetUpTime1
		lea.l	SingleString1,a0
		move.l	a0,DaysString
		bra	GetUpTime1

DoTTYTest:	lea.l	UpTimeConsole,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	DoTTYTest1
		move.l	d0,d1
		add.w	#1,Users
		lib	Dos,Close

DoTTYTest1:	move.b	#'0',TTY

DoTTYTest2:	lea.l	UpTimeTTY,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	DoTTYTest3
		move.l	d0,d1
		add.w	#1,Users
		lib	Dos,Close
DoTTYTest3:	cmp.b	#'9',TTY
		beq	DoTTYTest4
		add.b	#1,TTY
		bra	DoTTYTest2
DoTTYTest4:	rts

GetLoadAvg:	lea.l	LoadAvgName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		bne	GetLoadAvg2
GetLoadAvg1:	move.l	#'N/A,',LoadAvgBuf
		move.l	#'  N/',LoadAvgBuf+4
		move.l	#'A,  ',LoadAvgBuf+8
		move.l	#'N/A ',LoadAvgBuf+12
		move.b	#$00,LoadAvgBuf+16
		rts
GetLoadAvg2:	move.l	d0,d4
		move.l	d0,d1
		lea.l	LoadAvgBuf,a0
		move.l	a0,d2
		move.l	#19,d3
		lib	Dos,Read

		cmp.l	#19,d0
		beq	GetLoadAvg3
		bsr	GetLoadAvg1
GetLoadAvg3:	move.l	d4,d1
		lib	Dos,Close
		rts

Do2TTYTest:	lea.l	UpTimeConsole,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	Do2TTYTest1
		move.l	d0,d5

		move.l	d0,d1
		lea.l	DateTime1,a0
		move.l	a0,d2
		move.l	#4*4+20,d3	;was 3*4 !!!
		lib	Dos,Read

		move.l	d5,d1
		lib	Dos,Close

		bsr	D2TTY

		lea.l	ConsoleText1,a0
		bsr	P2TTY

Do2TTYTest1:	move.b	#'0',TTY
Do2TTYTest2:	lea.l	UpTimeTTY,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	Do2TTYTest3
		move.l	d0,d5
		move.l	d0,d1
		lea.l	DateTime1,a0
		move.l	a0,d2
		move.l	#4*4+20,d3	;was 3*4 !!!
		lib	Dos,Read

		move.l	d5,d1
		lib	Dos,Close

		bsr	D2TTY

		lea.l	UpTimeTTY1,a0
		bsr	P2TTY

Do2TTYTest3:	cmp.b	#'9',TTY
		beq	Do2TTYTest4
		add.b	#1,TTY
		bra	Do2TTYTest2
Do2TTYTest4:	rts

;This puts everything in the right place and prints this TTY's info
;
;INPUTS
;
;a0 = String of tty or console

P2TTY:		move.l	a0,TTYText1
		move.l	DateTime1+4,d0
		divu.w	#60,d0
		move.w	d0,HoursText1
		swap	d0
		move.w	d0,MinutesText1

		bsr	Format2
		lea.l	InfoOutText1,a0
		bsr	Printer
		lea.l	EndText1,a0
		bsr	Printer

		lea.l	ActionBuf,a0		;this should clear 38 chars
		move.l	#9,d0			;but does (4 bytes * 10)
P2TTY1:		clr.l	(a0)+
		dbf	d0,P2TTY1

		lea.l	InfoOutText1,a0		;this should clear 200 bytes
		move.l	#49,d0			;but does (4 bytes * 50)
P2TTY2:		clr.l	(a0)+
		dbf	d0,P2TTY2
		rts

;This goes through the lists and if it finds a cli process with same CLINum,
;it will copy the command name into ActionBuf.

D2TTY:		lib	Exec,Disable
		move.l	$4,a6		;not really needed!
		lea.l	$1a4(a6),a2
		move.l	LH_HEAD(a2),a2

D2TTY1:		bsr	LT_LOOP
		cmp.l	#$00,a2
		beq	D2TTY3

D2TTY2:		move.l	CLINumBuf,d0
		cmp.l	TTYTaskNum,d0
		beq	Do2Console
		bsr	LT_LOOPer
		cmp.l	#$00,a2
		bne	D2TTY2

D2TTY3:		move.l	$4,a6			;not needed ?
		lea.l	$196(a6),a2
		move.l	LH_HEAD(a2),a2
		bsr	LT_LOOP
		cmp.l	#$00,a2
		beq	D2TTY5

D2TTY4:		move.l	CLINumBuf,d0
		cmp.l	TTYTaskNum,d0
		beq	Do2Console
		bsr	LT_LOOPer
		cmp.l	#$00,a2
		bne	D2TTY4

D2TTY5:		sub.l	a1,a1
		lib	Exec,FindTask
		move.l	d0,a2
		move.l	$8c(a2),d0
		cmp.l	TTYTaskNum,d0
		bne	Do2Console4

Do2Console:	bsr	LT_GetName
		lea.l	ActionBuf,a3
		clr.l	d0
		move.b	(a0)+,d0
		bne	Do2Console1
		lea.l	NoCmdText1,a0
		bra	Do2Console2
Do2Console1:	sub.w	#1,d0
		cmp.w	#38,d0			;Do only 38 characters?
		bls	Do2Console3
Do2Console2:	move.l	#38,d0
Do2Console3:	move.b	(a0)+,(a3)+
		tst.b	(a0)
		beq	DoConsole3.1
		dbeq	d0,Do2Console3
DoConsole3.1:	clr.b	(a3)+			;was missing
Do2Console4:	lib	Exec,Enable
		rts

LT_LOOPer:	move.l	LN_SUCC(a2),a2

LT_LOOP:	tst.l	LN_SUCC(a2)
		beq	LT_END

		move.b	LN_TYPE(a2),d0
		cmp.b	#NT_PROCESS,d0
		bne	LT_LOOPer			;Not even a process

		move.l	$8c(a2),CLINumBuf
		beq	LT_LOOPer			;Not a CLI process
		rts

LT_END:		move.l	#$00,a2
		rts

;Give it the cliprocess pointer in a2 (?)

LT_GetName:	move.l	$ac(a2),a0			;change BPTR-APTR
		add.l	a0,a0
		add.l	a0,a0

		move.l	$10(a0),a0
		add.l	a0,a0
		add.l	a0,a0
		rts


Format:		lea.l	fstrl1,a0		;HEX->ASCII
		lea.l	Hours,a1		;Start of information
		lea.l	PutChProc,a2
		lea.l	UpTimeText1,a3		;Destination
		lib	Exec,RawDoFmt
		rts

Format2:	lea.l	fstrl2,a0		;HEX->ASCII
		lea.l	UserText1,a1		;Start of information
		lea.l	PutChProc,a2
		lea.l	InfoOutText1,a3		;Destination
		lib	Exec,RawDoFmt
		rts

ShutDown:	closlib	Dos
ShutDown_Out:	move.l	#RETURN_OK,d0
		rts

CmdLineHelp:	lea.l	UsageText1,a0
		bsr	Printer	
		bra	ShutDown

Printer:	printa	a0
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Structures & reservations

Hours:		dc.w	0
Minutes:	dc.w	0
UpDays:		dc.l	0
DaysString:	dc.l	PluralString1
UpHours:	dc.w	0
UpMinutes:	dc.w	0
Users:		dc.w	0
UsersString:	dc.l	PluralString1
PluralString1:	dc.b	's,',0
SingleString1:	dc.b	', ',0

UserText1:	dc.l	TTYUser
TTYText1:	dc.l	UpTimeTTY1
HoursText1:	dc.w	0
MinutesText1:	dc.w	0
ActionText1:	dc.l	ActionBuf

;Filenames

LoadAvgName:	dc.b	"ENV:UT_loadavg",0
UpTimeName:	dc.b	"ENV:NUT_timeval",0
UpTimeConsole:	dc.b	"ENV:NUT_console",0
UpTimeTTY:	dc.b	"ENV:NUT_"
UpTimeTTY1:	dc.b	"ttyp"
TTY:		dc.b	0,0

;Error strings etc...


;Information & other strings

		dc.b	"$VER: "
AuthorText1:	dc.b	"W 1.05 (04.04.93) (C)opyright Tomi Blinnikka 1993",13,10,13,10
;		dc.b	13,10,"!!! BETA TESTER VERSION !!!",13,10,13,10,13,10
		dc.b	0

UsageText1:	dc.b	"USAGE: W [?]",13,10,13,10
		dc.b	"       Where: [?] gives this text",13,10,13,10
		dc.b	"Tells how long the system has been up and its CPU usage.",13,10
		dc.b	"It also lists information on the users.",13,10
		dc.b	"See docs for more information.",13,10,0
NoCmdText1:	dc.b	"No command loaded.",0
fstrl1:		dc.b	"  %02.2d:%02d up %ld day%s %02.2d:%02.2d, %2.2d user%s load average: ",0
UpTimeText1:	dcb.b	100,0
EndText1:	dc.b	13,10,0
InfoText1:	dc.b	"User     tty       login@  idle   JCPU   PCPU  what",13,10,0
ConsoleText1:	dc.b	"co",0
fstrl2:		dc.b	"%-9.8s%-10.10s%02.2d:%02d                       %s",0
InfoOutText1:	dcb.b	200,0

		ds.l	0

;Structures

DateTime1:	dc.l	0		;days past 1978
		dc.l	0		;mins past 00:00
		dc.l	0		;ticks past min
TTYTaskNum:	dc.l	0		;pr_TaskNum
TTYUser:	dcb.b	20,0		;user on this tty


;library stuff

		libnames

;Buffers

UpTimeBuf:	dcb.b	3*4,0		;read NUT_timeval here
LoadAvgBuf:	dcb.b	20,0		;read UT_loadavg here
CLINumBuf:	dc.l	0		;move CLINum here
ActionBuf:	dcb.b	40,0		;copy cliprocess name here
		END

