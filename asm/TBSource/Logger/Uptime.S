*************************************************
*						*
*		(C)opyright 1992-93		*
*						*
*		 by Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
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
* Version 1.02	22/08/1992			*
*						*
* Version 1.03	02/02/1993			*
*						*
* BUGS:	Enforcer hit on logout			*
*						*
* Version 1.04	14/02/1993			*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/dosextens.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

		section	UpTime,CODE

		openlib	Dos,ShutDown_Out

		bsr	GetSysTime
		bsr	CheckUpTime

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		tst.l	ActionLogin
		bne	DoParse
		tst.l	ActionLogout
		beq	Information

DoParse:	move.l	TTYPointer,a2
		cmp.l	#$00,a2
		beq	ArgMissing		;We still need the TTY!

		cmp.b	#'c',(a2)		;Check for console
		bne	DoParse2
		move.b	#'c',CurrentTTY
		bra	DoParse3

DoParse2:	cmp.b	#'0',(a2)		;Check for 'real' TTY
		bcs	BadNumber
		cmp.b	#'9',(a2)
		bhi	BadNumber
		move.b	(a2),CurrentTTY

DoParse3:	move.l	UserPointer,a2
		tst.l	ActionLogout
		bne	DoParse6	;has a bug was 3.1
		cmp.l	#$00,a2
		beq	ArgMissing

DoParse3.1:	lea.l	TTYUser,a0
		move.l	a0,a1
		add.l	#10,a1		;changed! was 20

DoParse4:	cmp.b	#'A',(a2)
		bcs	DoParse5
		cmp.b	#'z',(a2)
		bhi	DoParse5
		move.b	(a2)+,(a0)+
		cmp.l	a0,a1		;copy only 10 characters!
		bne	DoParse4

DoParse5:	clr.b	(a0)+
		tst.l	ActionLogout
		bne	DoParse6

		tst.b	TTYUser
		beq	ArgMissing

;Complete requested action

DoParse6:	tst.l	ActionLogin
		bne	Login
		tst.l	ActionLogout
		bne	Logout


;Get system time
;Uptime equals (System time - NUT_timeval)
;Try to read ENV:NUT_login + ENV:NUT_TTYX
;Loop 0 - 9
;try reading ENV:UT_loadavg

Information:	bsr	GetUpTime
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
		bra	ShutDown

Login:		tst.l	ActionLogout
		bne	TooManyArgs
		sub.l	a1,a1
		lib	Exec,FindTask
		move.l	d0,a0
		move.l	$8c(a0),TTYTaskNum
		cmp.b	#'c',CurrentTTY
		bne	Login1
		lea.l	UpTimeConsole,a0
		bra	Login2
Login1:		move.b	CurrentTTY,TTY
		lea.l	UpTimeTTY,a0
Login2:		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		tst.l	d0
		beq	ShutDown
		move.l	d0,d4
		move.l	d0,d1
		lea.l	DateTime1,a0
		move.l	a0,d2
		move.l	#4*4+20,d3	;info + username
		lib	Dos,Write
		move.l	d4,d1
		lib	Dos,Close
		bra	ShutDown

Logout:		tst.l	ActionLogin
		bne	TooManyArgs
		cmp.b	#'c',CurrentTTY
		bne	Logout1
		lea.l	UpTimeConsole,a0
		bra	Logout2
Logout1:	move.b	CurrentTTY,TTY
		lea.l	UpTimeTTY,a0
Logout2:	move.l	a0,d1
		lib	Dos,DeleteFile
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

;GetSystime has already got the current time for us

GetUpTime:	move.l	UpTimeBuf,d0
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

Format:		lea.l	fstrl1,a0		;HEX->ASCII
		lea.l	Hours,a1		;Start of information
		lea.l	PutChProc,a2
		lea.l	UpTimeText1,a3		;Destination
		lib	Exec,RawDoFmt
		rts

ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown9000
		lib	Dos,FreeArgs
ShutDown9000:
ShutDown1000:	closlib	Dos
ShutDown_Out:	move.l	#RETURN_OK,d0
		rts

ArgMissing:	move.l	#ERROR_REQUIRED_ARG_MISSING,d1
		lib	Dos,SetIoErr
		bra	NoRDArgs

BadNumber:	move.l	#ERROR_BAD_NUMBER,d1
		lib	Dos,SetIoErr
		bra	NoRDArgs

TooManyArgs:	move.l	#ERROR_TOO_MANY_ARGS,d1
		lib	Dos,SetIoErr
;		bra	NoRDArgs	;CAREFUL HERE!!

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

Printer:	printa	a0
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Structures & reservations

		libnames

RDArgs1:	dc.l	0

;Options

CLArray1:
ActionLogin:	dc.l	0
ActionLogout:	dc.l	0
TTYPointer:	dc.l	0
UserPointer:	dc.l	0

;Options, Settings and other stuff

CurrentTTY:	dc.b	0
Kludge_1000:	dc.b	0			;FILL FILL FILL

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

;Filenames

LoadAvgName:	dc.b	"ENV:UT_loadavg",0
UpTimeName:	dc.b	"ENV:NUT_timeval",0
UpTimeConsole:	dc.b	"ENV:NUT_console",0
UpTimeTTY:	dc.b	"ENV:NUT_ttyp"
TTY:		dc.b	0,0

;Error strings etc...


;Information & other strings

		ds.w	0
CLTemplate1:	dc.b	"LOGIN/S,LOGOUT/S,TTY/K,USER/K",0
		dc.b	"$VER: Uptime 1.04 (14.2.93) (C)opyright Tomi Blinnikka 1993",0

fstrl1:		dc.b	"  %02.2d:%02d up %ld day%s %02.2d:%02.2d, %2.2d user%s load average: ",0
UpTimeText1:	dcb.b	100,0
EndText1:	dc.b	13,10,0
		ds.w	0

;Structures

DateTime1:	dc.l	0		;days past 1978
		dc.l	0		;mins past 00:00
		dc.l	0		;ticks past min
TTYTaskNum:	dc.l	0		;pr_TaskNum
TTYUser:	dcb.b	20,0		;user on this tty
TTYReal:	dcb.b	20,0		;users' real name


;Buffers

UpTimeBuf:	dcb.b	3*4,0		;read NUT_timeval here
LoadAvgBuf:	dcb.b	20,0		;read UT_loadavg here
		END

