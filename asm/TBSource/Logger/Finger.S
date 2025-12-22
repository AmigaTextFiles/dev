*************************************************
*						*
*	       (C)opyright 1992-93		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 1.00	03/08/1992			*
*						*
* BUGS:	No plan or login texts			*
*						*
* I have been up for 38 hours now. It must be	*
* time to start writing this program :)		*
*						*
* Version 1.01	08/08/1992			*
*						*
* BUGS:	Didn't check for UNUSED in username	*
*						*
* Version 1.02	10/08/1992			*
*						*
* BUGS:						*
*						*
* Version 1.03	14/08/1992			*
*						*
* BUGS:						*
*						*
* Version 1.04	28/12/1992			*
*						*
* BUGS:						*
*						*
* Version 1.05	30/12/1992			*
*						*
* CBM parser guidelines.			*
*						*
* BUGS:	Won't find user if '?' was used first	*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

	XREF	_LVOSetMode

	BITDEF  GV,LOCAL_ONLY,9

TRUE:		EQU	1
FALSE:		EQU	0

		section	Finger,CODE

		move.l	a0,a4
		clr.b	-1(a0,d0.l)
		openlib	Dos,NoDos

		lib	Dos,Input
		move.l	d0,_stdin

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

DoCmdLine:	tst.l	UNPointer
		bne	CopyLoop

		lea.l	UserVarText1,a0
		move.l	a0,d1
		lea.l	Buffer3,a0
		move.l	a0,d2
		move.l	#10,d3
		clr.l	d4			;LV_VAR actually
		or.l	#GVF_LOCAL_ONLY,d4
		lib	Dos,GetVar
		cmp.l	#-1,d0
		beq	NoLocVars
		bra	CopyLoop_OUT

CopyLoop:	lea.l	Buffer3,a0
		move.l	a4,a5
		add.l	#10,a5
CopyLoop1:	move.b	(a4)+,(a0)+
		tst.b	(a4)
		beq	CopyLoop_OUT
		cmp.l	a4,a5
		beq	CopyLoop_OUT
		cmp.b	#' ',(a4)
		bne	CopyLoop1
CopyLoop_OUT:

		lea.l	PassWdFileN,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PassWdFile
		bne	StartMain

		bsr	FileError1
		bra	ShutDown

StartMain:	lea.l	UNUSEDText1,a0
		lea.l	Buffer3,a1
		bsr	CmpStrings
		tst.l	d0
		beq	StartMain1
		lea.l	InvalidText1,a0	
		bsr	Printer
		bra	ShutDown

StartMain1:	bsr	FindUser
		tst.l	d0
		bne	ShutDown

		lea.l	UserNText1,a0
		bsr	Printer
		lea.l	UserName,a0
		bsr	Printer
		lea.l	SpacesText1,a0
		bsr	Printer
		lea.l	RealNText1,a0
		bsr	Printer
		lea.l	RealName,a0
		bsr	Printer
		lea.l	UserHomeText2,a0
		bsr	Printer
		lea.l	UserHome,a0
		bsr	Printer
		lea.l	OfficeText2,a0
		bsr	Printer
		lea.l	Office,a0
		bsr	Printer

		lea.l	LoginText1,a0
		bsr	Printer

		lea.l	UserHome,a0
		move.l	a0,d1
		move.l	#ACCESS_READ,D2
		lib	Dos,Lock
		move.l	d0,NewLock
		beq	FileError3

		move.l	NewLock,d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock

		lea.l	LastLoginN,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,LoginFile
		beq	GivePlan

		move.l	LoginFile,d1
		bsr	TypeFile

GivePlan:	lea.l	PlanName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PlanFile
		beq	GivePlan2

		lea.l	PlanText1,a0
		bsr	Printer

		move.l	PlanFile,d1
		bsr	TypeFile

		lea.l	CRLFText1,a0
		bsr	Printer
		bra	ShutDown

GivePlan2:	lea.l	PlanText2,a0
		bsr	Printer

ShutDown:	move.l	RDArgs1,d1
		beq	ShutDown9100
		lib	Dos,FreeArgs

ShutDown9100:	move.l	PassWdFile,d1
		beq	ShutDown9000
		lib	Dos,Close

ShutDown9000:	move.l	LoginFile,d1
		beq	ShutDown8500
		lib	Dos,Close
ShutDown8500:	move.l	PlanFile,d1
		beq	ShutDown8000
		lib	Dos,Close

ShutDown8000:	move.l	NewLock,d1
		beq	ShutDown7500
		lib	Dos,UnLock

ShutDown7500:	move.l	OldLock,d1
		beq	ShutDown6000
		lib	Dos,CurrentDir

ShutDown6000:	tst.l	TypeFileMem
		beq	ShutDown5000
		move.l	TypeFileMem,a1
		move.l	TypeFileLength,d0
		lib	Exec,FreeMem

ShutDown5000:
ShutDown1000:	closlib	Dos

		move.l	#RETURN_OK,d0
		rts

NoDos:		move.l	#RETURN_FAIL,d0
		rts

NoLocVars:	move.l	#ERROR_REQUIRED_ARG_MISSING,d1
		lib	Dos,SetIoErr			;DO NOT SEPARATE!*1
NoRDArgs:	lib	Dos,IoErr			;DO NOT SEPARATE!*1
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

FileError1:	lea.l	FileErrorText1,a0
		bsr	Printer
		rts
FileError2:	lea.l	FileErrorText2,a0
		bsr	Printer
		rts
FileError3:	lea.l	FileErrorText3,a0
		bsr	Printer
		bra	ShutDown
FileError4:	lea.l	FileErrorText4,a0
		bsr	Printer
		bra	ShutDown

WarnLowMem:	lea.l	LowMemText1,a0
		bsr	Printer
		rts

Printer:	printa	a0
		rts

;Inputs Buffer3 = user to find

FindUser:	bsr	ReadUser
		tst.l	d0
		bne	FindUser_ERR1
		lea.l	UserName,a0
		lea.l	Buffer3,a1
		bsr	CmpStrings
		tst.l	d0
		beq	FindUser
		clr.l	d0
		rts
FindUser_ERR1:	move.l	#-1,d0
		rts

ReadUser:	move.l	PassWdFile,d1
		lea.l	UserName,a0
		move.l	a0,d2
		move.l	#DataSize,d3
		lib	Dos,Read
		cmp.l	#DataSize,d0
		beq	ReadUser2
		lib	Dos,IoErr
		tst.l	d0
		beq	ReadUser1
		bsr	FileError2
		move.l	#-1,d0
		rts
ReadUser1:	lea.l	NoUserText1,a0
		bsr	Printer
		move.l	#-1,d0
		rts
ReadUser2:	clr.l	d0
		rts

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
;
;BUGS
;
;String 1 has to have NULL at end!
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

;CmpStrings:	tst.b	(a0)
;		beq	CmpStrings2
;		cmp.b	(a0)+,(a1)+
;		beq	CmpStrings
;		clr.l	d0
;		rts
;CmpStrings2:	move.l	#-1,d0
;		rts

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

;Gets the length of the file given
;
;Input d1 = File
;
;Result d0 = Length of file in bytes
;

GetFileLength:	push	d5-d6
		move.l	d1,d6
		move.l	#00,d2
		move.l	#01,d3
		lib	Dos,Seek
		move.l	d6,d1
		lib	Dos,Seek

		move.l	d0,d5
		move.l	d6,d1
		move.l	#0,d2
		move.l	#-1,d3
		lib	Dos,Seek

		move.l	d5,d0
		pull	d5-d6
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

TypeFile:	move.l	d1,d4
		bsr	GetFileLength
		tst.l	d0
		beq	TypeFile_OUT

		move.l	d0,TypeFileLength
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1	;Type of memory wanted
		lib	Exec,AllocMem
		move.l	d0,TypeFileMem
		beq	TypeFile_ERR2

		move.l	d4,d1
		move.l	TypeFileMem,d2
		move.l	TypeFileLength,d3
		lib	Dos,Read
		cmp.l	TypeFileLength,d0
		bne	TypeFile_ERR3

		move.l	TypeFileMem,a0
		bsr	Printer

TypeFile2:	tst.l	TypeFileMem
		beq	TypeFile_OUT
		move.l	TypeFileMem,a1
		move.l	TypeFileLength,d0
		lib	Exec,FreeMem
		clr.l	TypeFileMem
		clr.l	TypeFileLength
TypeFile_OUT:	rts

TypeFile_ERR2:	bsr	WarnLowMem
		bra	TypeFile2

TypeFile_ERR3:	bsr	FileError4
		bra	TypeFile_OUT


;Structures and reservations

;Files

_stdin:		dc.l	0
PassWdFile:	dc.l	0
LoginFile:	dc.l	0
PlanFile:	dc.l	0
OldLock:	dc.l	0
NewLock:	dc.l	0
TypeFileLength:	dc.l	0
TypeFileMem:	dc.l	0
RDArgs1:	dc.l	0

;Options

CLArray1:
UNPointer:	dc.l	0

;Texts to output

CLTemplate1:	dc.b	"USERNAME/F",0

		dc.b	"$VER: Finger 1.05 (1.1.93) (C)opyright Tomi Blinnikka 1993",0

BreakText1:	dc.b	"***Break",13,10,0
CRLFText1:	dc.b	13,10,0
SpacesText1:	dc.b	"                   ",0
CreatingText1:	dc.b	"Password file doesn't exist! Creating new PassWd-file...",13,10,0
NoUserText1:	dc.b	"No user with that name!",13,10,0

UserNText1:	dc.b	"Login name: ",0
RealNText1:	dc.b	"In real life: ",0
OfficeText2:	dc.b	13,10,"Office: ",0
UserHomeText2:	dc.b	13,10,"Directory: ",0
LoginText1:	dc.b	13,10,"Last login ",0
PlanText1:	dc.b	"Plan:",13,10,0
PlanText2:	dc.b	"No Plan.",13,10,0

UserVarText1:	dc.b	"username",0
PassWdFileN:	dc.b	"LOGGER:PassWd.LOGGER",0
LastLoginN:	dc.b	".lastlogin",0
PlanName:	dc.b	".plan",0
UNUSEDText1:	dc.b	"UNUSED",0

;Error texts

FileErrorText1:	dc.b	"Couldn't open file 'LOGGER:PassWd.LOGGER'",13,10,0
FileErrorText2:	dc.b	"Read error with file 'LOGGER:PassWd.LOGGER'",13,10,0
FileErrorText3:	dc.b	13,10,"Error with user's home directory!",13,10,0
FileErrorText4:	dc.b	13,10,"Read error!",13,10,0
InvalidText1:	dc.b	"Invalid username!",13,10,0

LowMemText1:	dc.b	13,10,"WARNING: System is low on memory!",13,10,0

		ds.l	0

;library stuff

		libnames

;buffers

Buffer3:	dcb.b	12,0		;Temporary buffer for username

;User template. Has template for user "root". This way it's easier to
;create the new PassWd-file and new users

DATA_START:
UserName:	dc.b	"root"
		dcb.b	12-4,0				;username
PassWord:	dcb.b	12,0				;passwd (default is 'root')
RealName:	dc.b	"System Administraitor"		;note the 'i' :)
		dcb.b	64-21,0				;realname of user
UserHome:	dc.b	"USERS:root"
		dcb.b	64-10,0				;user home directory
Office:		dc.b	"Admin"
		dcb.b	64-5,0				;Office for finger etc.
UserCommand:	dc.b	"C:Execute Rem:Login-Start"	;command to start
		dcb.b	64-25,0
DATA_END:	dc.l	0,0

DataSize:	EQU	(DATA_END-DATA_START)

		END

