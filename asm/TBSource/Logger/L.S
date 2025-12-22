*************************************************
*						*
*	       (C)opyright 1992-93		*
*						*
*		by Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	??/??/1992			*
*	 -0.99ö					*
*						*
* BUGS:						*
*						*
* Version 1.00	01/08/1992			*
*						*
* BUGS:	Logging problems, grr...		*
*						*
* Version 1.01	08/08/1992			*
*						*
* BUGS:						*
*						*
* Version 1.02	09/08/1992			*
*						*
* Added speeds.					*
*						*
* Version 1.03	14/08/1992			*
*						*
* Added log!					*
*						*
* BUGS:	Didn't give correct device in arguments	*
*						*
* Version 1.04	15/08/1992			*
*						*
* Version 1.05	22/08/1992			*
*						*
* Changed log to be opened/closed before/after	*
* writes.					*
*						*
* Version 1.06	03/10/1992			*
*						*
* Added local option.				*
*						*
* BUGS: Had a bug in the parser, unaligned	*
* reads AGAIN.					*
*						*
* Version 1.07	05/12/1992			*
*						*
* Fixed bug with options given to program to	*
* execute. Serial unit was incorrect.		*
*						*
* BUGS: Parser?					*
*						*
* Version 1.08	24/12/1992			*
*						*
* Parser not intuitive but should work.		*
* Device is now closed before the command is	*
* run. Modified for A2232 Mount and AUXs.	*
*						*
* BUGS: Had a 'bra' instead of a 'bsr' in the	*
*	error output routines.			*
*						*
*	Unalignment bug in MakeCmdString.	*
*						*
*	A bug in OpenSer caused a 'beq' out	*
*	of the whole subroutine.		*
*						*
*	Parser won't accept any device starting	*
*	with a letter of one of the commands.	*
*						*
* Version 1.09	28/12/1992			*
*						*
* Changed directory names to Logger-standard.	*
*						*
* BUGS: Try 'Logger' and press CTRL-C...	*
*						*
* Version 1.10	29/12/1992			*
*						*
* Changed parser to Commodore standard.		*
*						*
* Removed utility.library stuff.		*
*						*
* BUGS:						*
*						*
* Version 1.11	1/1/1993			*
*						*
* Fixed bug in CmpStrings			*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/nodes.i"
	INCLUDE	"exec/lists.i"
	INCLUDE	"exec/ports.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"exec/devices.i"
	INCLUDE	"exec/io.i"
	INCLUDE	"exec/tasks.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"devices/serial.i"
	INCLUDE	"dos/dostags.i"
	INCLUDE	"dos/datetime.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"

	XREF	_LVOCurrentTime
	XREF	_LVOSystemTagList

TRUE:		EQU	1
FALSE:		EQU	0

LF:		EQU	10
CR:		EQU	13

		section	Logger,CODE

		push	d2-d7/a2-a6

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

		openlib	Dos,NoDos		;Keep at beginning

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout

		flib	Dos,Input
		move.l	d0,_stdin

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		tst.l	LLPointer
		beq	DoParsing1
		move.l	LLPointer,a0
		move.l	(a0),LogLevel
DoParsing1:	tst.l	UnitPointer
		beq	DoParsing2
		move.l	UnitPointer,a0
		move.l	(a0),SerUnit
DoParsing2:	tst.l	SpeedPointer
		beq	DoParsing3
		move.l	SpeedPointer,a0
		move.l	(a0),Speed
DoParsing3:	tst.l	Local
		beq	DoParsing4
		move.l	#1,Dumb
		lea.l	SerName3,a0
		move.l	a0,SerName
		move.b	#'c',ASCIIUnit
		clr.b	ASCIIUnit+1
DoParsing4:

MainStart:	openlib	Intuition,NoInt

;Skip opening device stuff if local mode requested

		tst.l	Local
		bne	Logging

		bsr	OpenSer
		tst.l	d0
		beq	ShutDown

		bsr	Reader

;
;Main loop here
;
;0.  Setup device stuff (*2)
;1.  Reset modem (*) (*2)
;2.  Setup read (*) (*2)
;3.  Wait for RING (*) (*2)
;4.  Answer with ATA (*) (*2)
;5.  Wait for CONNECT (*) (*2)
;6.  Delay of 1 SEC
;7.  Display Getty-Header
;8.  Ask login
;9.  Ask for password
;10. Test password with login
;11. Loop if incorrect or null
;12. Execute Login-Start of $username

;(*) only if -d(umb) option is not set
;(*2) only if -l(ocal) option is not set

StartLoop:	tst.l	Local
		bne	Logging

		clr.l	d1
		bset.l	#SIGBREAKB_CTRL_C,d1	;check for CTRL_C
		lib	Dos,CheckSignal
		btst.l	#SIGBREAKB_CTRL_C,d0
		beq	StartLoop0.1		;DEBUG
		bsr	Break
		bra	ShutDown

StartLoop0.1:	tst.l	Dumb
		bne	Logging

StartLoop1:	bsr	Reset

StartLoop2:	clr.w	BufCount
		bsr	WaitForRing
		tst.l	d0
		beq	ShutDown

		bsr	Answer
		clr.w	BufCount
		bsr	WaitForConnect
		tst.l	d0
		beq	ShutDown
		cmp.l	#1111111,d0
		beq	StartLoop2

		clr.l	d0
		bsr	WaitUntilLF	;clears connect speed + CR
		clr.l	d0
		bsr	WaitUntilLF	;should clear LF

;Login part starts here

Logging:	lea.l	LoginSeconds,a0
		lea.l	MicrosTemp,a1
		lib	Intuition,CurrentTime

		clr.w	LogFailCount
		tst.l	Dumb
		bne	Logging0.11111
		bsr	Delay11SECS

Logging0.11111:	bsr	Welcome
Logging1:	bsr	AskLogin
		tst.l	d0
		beq	ShutDown
		tst.b	Buffer3
		beq	Logging1
		bsr	AskPassword
		tst.l	d0
		beq	ShutDown

		lea.l	PassWdFileN,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PassWdFile
		bne	Logging1.1

		lea.l	PassWdFileN,a3
		bsr	FileError1
		bra	Logging2.9

Logging1.1:	bsr	ReadUser
		tst.l	d0
		bne	Logging2.9
		lea.l	TempBuf1,a0
		lea.l	UserName,a1
		bsr	CmpStrings
		tst.l	d0
		beq	Logging1.1

Logging2:	lea.l	PassWord,a0
		lea.l	Buffer4,a1
		bsr	Decrypt
		lea.l	Buffer4,a0
		lea.l	Buffer3,a1
		bsr	CmpStrings
		tst.l	d0
		bne	LoggedOn
Logging2.9:	add.w	#1,LogFailCount
		bsr	IncorrectLogin
		cmp.w	#5,LogFailCount
		beq	LoginFailure
		bra	Logging1

LoggedOn:	move.l	PassWdFile,d1
		beq	LoggedOn1
		lib	Dos,Close
		clr.l	PassWdFile

LoggedOn1:	lea.l	LoginSeconds,a0
		lea.l	MicrosTemp,a1
		lib	Intuition,CurrentTime

		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer

;Do log stuff

		cmp.l	#2,LogLevel
		beq	LoggedOn2
		cmp.l	#3,LogLevel
		bne	LoggedOn3
LoggedOn2:	lea.l	CorrectText1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	TempBuf1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	LogFailIncText1,a0
		bsr	GetLength
		bsr	Writer2
		bsr	PutDate
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer2

LoggedOn3:	bsr	OpenNIL
		tst.l	NILFile
		beq	ShutDown

		bsr	ClearSer

		bsr	MakeCmdString


		bsr	CloseSer

		lea.l	CmdString1,a0
		move.l	a0,d1
		tst.l	Local
		beq	LoggedOn4
		move.l	_stdin,d2
		move.l	_stdout,d3
		bra	LoggedOn5
LoggedOn4:	clr.l	d2
		move.l	NILFile,d3
LoggedOn5:	lib	Dos,Execute


		tst.l	Local
		bne	LoggedOn6

;		move.l	#4*50,d1	;DEBUG
;		lib	Dos,Delay	;DEBUG

		bsr	OpenSer
		tst.l	d0
		beq	ShutDown

		bsr	Reader

LoggedOn6:	bsr	CloseNIL

LogOut:		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer
		bsr	OnTime

		tst.l	Dumb
		bne	LogOut1
		bsr	HangUp
LogOut1:	cmp.w	#5,LogFailCount		;don't wait for character
		beq	LogOut2
		bsr	CheckEvent
		tst.l	d0
		bne	LogOut1.1
		bsr	EndCLI
		bra	ShutDown
LogOut1.1:	bsr	Reader
LogOut2:	bra	StartLoop

EndCLI:		tst.l	Local
		beq	EndCLI2
		lea.l	CmdString2,a0
		move.l	a0,d1
		clr.l	d2
		clr.l	d3
		lib	Dos,Execute
EndCLI2:	rts

OnTime:		lea.l	LogoutSeconds,a0
		lea.l	MicrosTemp,a1
		lib	Intuition,CurrentTime

		move.l	LoginSeconds,d0
		move.l	LogoutSeconds,d1
		sub.l	d0,d1
		divu.w	#60,d1			;Minutes
		clr.l	d0
		move.w	d1,d0			;test moving it straight to mins...
		move.w	d0,OnTimeMins

		lea.l	fstrl,a0		;HEX->ASCII
		lea.l	OnTimeMins,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	OnTimeText2,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	OnTimeText1,a0
		bsr	GetLength
		bsr	Writer

		cmp.l	#2,LogLevel
		beq	OnTime2
		cmp.l	#3,LogLevel
		bne	OnTime3
OnTime2:	lea.l	LogOutText1,a0
		bsr	GetLength
		bsr	Writer2
		bsr	PutDate
		lea.l	CRLFText2,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	OnTimeText1,a0
		bsr	GetLength
		bsr	Writer2

OnTime3:	lea.l	ConnectionText1,a0
		bsr	GetLength
		bsr	Writer
		rts

;Waits for RING
;
;INPUT
;
;OUTPUT
;
;D0 = -1 if OK
;D0 =  0 if Break
;
;ACTION
;
;1. Wait for input, serial or CTRL_C
;2. If CTRL_C then break
;3. If serial test for ring
;4. If D0 = -1 then RING -> OUT
;5. If not then loop

WaitForRing:	bsr	CheckEvent
		tst.l	d0
		beq	WaitForRing_OUT

		bsr	TestRing
		tst.l	d0
		beq	WaitForRing		;No RING so get more chars
WaitForRing_OUT: rts

TestRing:	tst.w	BufCount
		bne	TestRing2
		cmp.b	#'R',Buffer1
		bne	TestRing4
TestRing2:	lea.l	Buffer2,a0
		add.w	BufCount,a0
		move.b	Buffer1,(a0)
		add.w	#1,BufCount
		cmp.w	#4,BufCount
		bne	TestRing4
		clr.w	BufCount
		cmp.l	#'RING',Buffer2
		bne	TestRing4
TestRing3:	bsr	ClearSer
		bsr	Reader
		move.l	#-1,d0			;indicate ring
		rts
TestRing4:	bsr	ClearSer		;Abort possible prev. read
		bsr	Reader			;Set up new read
		clr.l	d0
		rts

;Waits for CONNECT
;
;INPUT
;
;OUTPUT
;
;D0 = -1 if OK
;D0 =  0 if Break
;
;ACTION
;
;1. Wait for input, serial or CTRL_C
;2. If CTRL_C then break
;3. If serial test for connect
;4. If D0 = -1 then CONNECT -> OUT
;5. If not then loop

WaitForConnect:	bsr	CheckEvent
		tst.l	d0
		beq	WaitForConnect_OUT

		bsr	TestConnect
		tst.l	d0
		beq	WaitForConnect		;No CONNECT so get more chars
WaitForConnect_OUT: rts

TestConnect:	tst.w	BufCount
		bne	TestConnect2
		cmp.b	#'C',Buffer1
		bne	TestConnect4
TestConnect2:	lea.l	Buffer2,a0
		add.w	BufCount,a0
		move.b	Buffer1,(a0)
		add.w	#1,BufCount
		cmp.w	#7,BufCount
		bne	TestConnect4
		clr.w	BufCount
		cmp.l	#'CONN',Buffer2
		bne	TestConnect5
		cmp.w	#'EC',Buffer2+4
		bne	TestConnect5
		cmp.b	#'T',Buffer2+6
		bne	TestConnect5
TestConnect3:	bsr	ClearSer
		bsr	Reader
		move.l	#-1,d0			;indicate CONNECT
		rts
TestConnect4:	bsr	ClearSer		;Abort possible prev. read
		bsr	Reader			;Set up new read
		clr.l	d0
		rts
TestConnect5:	bsr	ClearSer		;Abort possible prev. read
		bsr	Reader			;Set up new read
		move.l	#1111111,d0
		rts

Reset:		lea.l	ResetString,a0
		bsr	GetLength
		bsr	Writer
		rts

Answer:		lea.l	AnswerString,a0
		bsr	GetLength
		bsr	Writer
		rts

Welcome:	lea.l	WelcomeFileN,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,WelcomeFile
		beq	Welcome_ERR1

		move.l	d0,d1
		bsr	GetFileLength
		tst.l	d0
		beq	Welcome2

		move.l	d0,WelcomeLength
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1	;Type of memory wanted
		lib	Exec,AllocMem
		move.l	d0,WelcomeMem
		beq	Welcome_ERR2

		move.l	WelcomeFile,d1
		move.l	WelcomeMem,d2
		move.l	WelcomeLength,d3
		lib	Dos,Read
		cmp.l	WelcomeLength,d0
		bne	Welcome_ERR3

		clr.l	d4
		move.l	WelcomeMem,a3
Welcome1:	move.l	a3,a0
		bsr	GetLLength
		add.l	d0,d4
		add.l	d0,a3
		sub.l	#1,d0
		bsr	Writer
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer

		cmp.l	WelcomeLength,d4
		bcs	Welcome1

Welcome2:	move.l	WelcomeFile,d1
		lib	Dos,Close
		clr.l	WelcomeFile

		tst.l	WelcomeMem
		beq	Welcome_OUT
		move.l	WelcomeMem,a1
		move.l	WelcomeLength,d0
		lib	Exec,FreeMem
		clr.l	WelcomeMem
		clr.l	WelcomeLength

Welcome_OUT:	rts

Welcome_ERR1:	lea.l	WelcomeFileN,a3
		bsr	FileError1
		bra	Welcome_OUT

Welcome_ERR2:	bsr	WarnLowMem
		bra	Welcome2

Welcome_ERR3:	lea.l	WelcomeFileN,a3
		bsr	FileError2
		bra	Welcome_OUT

AskLogin:	lea.l	LoginText1,a0
		bsr	GetLength
		bsr	Writer

		clr.w	BufCount
		move.l	#1,d0
		bsr	WaitUntilLF
		tst.l	d0
		beq	AskLogin_OUT

		lea.l	Buffer3,a0
		lea.l	TempBuf1,a1
		move.l	#32,d0
		lib	Exec,CopyMem
		move.l	#-1,d0
		rts
AskLogin_OUT:	clr.l	d0
		rts

AskPassword:	lea.l	PasswordText1,a0
		bsr	GetLength
		bsr	Writer
		clr.w	BufCount
		clr.l	d0
		bsr	WaitUntilLF
		rts

IncorrectLogin:	lea.l	IncorrectText1,a0
		bsr	GetLength
		bsr	Writer
		cmp.l	#1,LogLevel
		beq	IncorrectLogin1
		cmp.l	#3,LogLevel
		bne	IncorrectLogin_OUT
IncorrectLogin1: lea.l	IncorrectText2,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	TempBuf1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	LogFailIncText2,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	Buffer3,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	LogFailIncText1,a0
		bsr	GetLength
		bsr	Writer2
		bsr	PutDate
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer2

IncorrectLogin_OUT: rts

LoginFailure:	lea.l	LogFailureText1,a0
		bsr	GetLength
		bsr	Writer
		cmp.l	#1,LogLevel
		beq	LoginFailure1
		cmp.l	#3,LogLevel
		bne	LoginFailure_OUT
LoginFailure1:	lea.l	LogFailureText2,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer2
LoginFailure_OUT: bra	LogOut

Echo:		lea.l	Buffer1,a0
		move.l	#1,d0
		bsr	Writer
		rts

HangUp:		bsr	Delay3SECS
		lea.l	HangUpString1,a0
		bsr	GetLength
		bsr	Writer
		bsr	Delay3SECS
		lea.l	HangUpString2,a0
		bsr	GetLength
		bsr	Writer
		bsr	Delay1SEC
		rts

Delay1SEC:	move.l	#51,d1
		lib	Dos,Delay
		rts
Delay3SECS:	move.l	#3*51,d1
		lib	Dos,Delay
		rts
Delay11SECS:	move.l	#11*51,d1
		lib	Dos,Delay
		rts

Break:		lea.l	BreakText1,a0
		bsr	Printer
		clr.l	d0
		rts			;careful!

OpenNIL:	tst.l	NILFile
		bne	OpenNIL_OUT
		lea.l	NILName,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
OpenNIL_OUT:	rts

CloseNIL:	move.l	NILFile,d1
		beq	CloseNIL1
		lib	Dos,Close
		clr.l	NILFile
CloseNIL1:	rts

MakeCmdString:	tst.l	Local
		bne	MakeCmdString2
		lea.l	fstrl2,a0		;HEX->ASCII
		lea.l	SerUnit,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	ASCIIUnit,a3		;Destination
		lib	Exec,RawDoFmt

MakeCmdString2:	lea.l	CmdString1,a0
		lea.l	UserCommand,a4
		move.l	a4,a5
		add.l	#64,a5
		bsr	MCS1

		move.b	#' ',(a0)+

		lea.l	UserName,a4
		move.l	a4,a5
		add.l	#10,a5
		bsr	MCS1

		move.b	#' ',(a0)+
		move.b	#'"',(a0)+

		lea.l	RealName,a4
		move.l	a4,a5
		add.l	#64,a5
		bsr	MCS1

		move.b	#'"',(a0)+
		move.b	#' ',(a0)+
		move.b	#'"',(a0)+

		lea.l	UserHome,a4
		move.l	a4,a5
		add.l	#64,a5
		bsr	MCS1

		move.b	#'"',(a0)+
		move.b	#' ',(a0)+
		move.b	#'"',(a0)+

		lea.l	Office,a4
		move.l	a4,a5
		add.l	#64,a5
		bsr	MCS1

		move.b	#'"',(a0)+
		move.b	#' ',(a0)+

		move.l	SerName,a4
		move.l	a4,a5
		add.l	#20,a5
		bsr	MCS1

		move.b	#' ',(a0)+

;;;;;		move.l	ASCIIUnit,(a0)+		;BUGGY, DO NOT USE!!!
;;;;;		move.w	ASCIIUnit+4,(a0)+	;See new below.

		move.b	ASCIIUnit,(a0)+		;Keep last!
		move.b	ASCIIUnit+1,(a0)+
		move.b	ASCIIUnit+2,(a0)+
		move.b	ASCIIUnit+3,(a0)+

		move.b	ASCIIUnit+4,(a0)+
		move.b	ASCIIUnit+5,(a0)+

		clr.b	(a0)+

;		lea.l	CmdString1,a0		;DEBUG
;		bsr	Printer			;DEBUG

		rts

MCS1:		move.b	(a4)+,(a0)+
		tst.b	(a4)
		beq	MCS2
		cmp.l	a4,a5
		bne	MCS1
MCS2:		rts

WarnLowMem:	lea.l	LowMemText1,a0
		bsr	GetLength
		bsr	Writer
		rts

;Outputs error message
;
;Inputs a3 = Filename

FileError1:	lea.l	FileErrorText1,a0
		bsr	GetLength
		bsr	Writer
		move.l	a3,a0
		bsr	GetLength
		bsr	Writer
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer
		lea.l	FileErrorText1,a0
		bsr	GetLength
		bsr	Writer2			;log them
		move.l	a3,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer2
		rts

FileError2:	lea.l	FileErrorText2,a0
		bsr	GetLength
		bsr	Writer
		move.l	a3,a0
		bsr	GetLength
		bsr	Writer
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer
		lea.l	FileErrorText2,a0
		bsr	GetLength
		bsr	Writer2
		move.l	a3,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	CRLFText1,a0
		bsr	GetLength
		bsr	Writer2
		rts

;Outputs error message
;
;Inputs a3 = Filename

FileError3:	lea.l	FileErrorText1,a0
		bsr	Printer
		move.l	a3,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		rts

ClearSer:	tst.l	Local
		bne	ClearSer_OUT
		clr.w	Requested
		move.l	IORRequest,a1
		lib	Exec,CheckIO
		tst.l	d0
		beq	ClearSer1
		move.l	IORRequest,a1
		lib	Exec,WaitIO
		rts
ClearSer1:	move.l	IORRequest,a1
		ABORTIO
		move.l	IORRequest,a1
		lib	Exec,WaitIO
ClearSer_OUT:	rts

Reader:		tst.l	Local
		bne	Reader_OUT
		move.w	#1,Requested
		move.l	IORRequest,a1
		move.w	#CMD_READ,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,SendIO
Reader_OUT:	rts

;Writes string to serial port
;
;D0 = Length
;A0 = String

Writer:		tst.l	Local
		bne	LocalWriter
		move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	d0,IO_LENGTH(a1)
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO		;May freeze, too bad
		rts

;Writes string to _stdout
;
;D0 = Length
;A0 = String

LocalWriter:	move.l	_stdout,d1
		move.l	a0,d2
		move.l	d0,d3
		lib	Dos,Write
		rts

;Tries to write string to logfile
;
;D0 = Length
;A0 = String

Writer2:	push	a0/d0
		bsr	OpenLog
		tst.l	d0
		beq	Writer2_OUT2
		pull	a0/d0
		move.l	LogFile,d1
		beq	Writer2_OUT
		move.l	a0,d2
		move.l	d0,d3
		lib	Dos,Write
		bsr	CloseLog
Writer2_OUT:	rts
Writer2_OUT2:	add.l	#8,sp
		rts

;Try to open logfile

OpenLog:	lea.l	LogFileN,a0
		move.l	a0,d1
		move.l	#MODE_READWRITE,d2
		lib	Dos,Open
		move.l	d0,LogFile
		bne	OpenLog1

		lea.l	LogFileN,a3
		bsr	FileError3
		bra	OpenLog2

OpenLog1:	bsr	SeekEnd
		move.l	#-1,d0
		rts
OpenLog2:	clr.l	d0
		rts

CloseLog:	move.l	LogFile,d1
		beq	CloseLog1
		lib	Dos,Close
		clr.l	LogFile
CloseLog1:	rts

PutDate:	lea.l	DateTime1,a0
		move.l	a0,d1
		lib	Dos,DateStamp
		lea.l	DateTime1,a0
		move.l	a0,d1
		lib	Dos,DateToStr
		tst.l	d0
		beq	PutDate_OUT
		lea.l	StrTime1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	SpaceText1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	StrDay1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	SpaceText1,a0
		bsr	GetLength
		bsr	Writer2
		lea.l	StrDate1,a0
		bsr	GetLength
		bsr	Writer2
PutDate_OUT:	rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

ShutDown:	bsr	CloseSer

ShutDown9000:	;print	<"debug serial_closed",13,10>		;DEBUG
ShutDown5000:	move.l	RDArgs1,d1
		beq	ShutDown4600
		lib	Dos,FreeArgs
ShutDown4600:	move.l	WelcomeFile,d1
		beq	ShutDown4500
		lib	Dos,Close
ShutDown4500:	;print	<"debug_welcome_file_closed",13,10>	;DEBUG
		move.l	PassWdFile,d1
		beq	ShutDown4400
		lib	Dos,Close
ShutDown4400:	;print	<"debug_NIL_closing",13,10>		;DEBUG
		move.l	NILFile,d1
		beq	ShutDown4300
		lib	Dos,Close
ShutDown4300:	;print	<"debug_log_closing",13,10>		;DEBUG
		move.l	LogFile,d1
		beq	ShutDown4000
		lib	Dos,Close

ShutDown4000:	;print	<"freeing memory",13,10>		;DEBUG
		tst.l	WelcomeMem
		beq	ShutDown3000
		move.l	WelcomeMem,a1
		move.l	WelcomeLength,d0
		lib	Exec,FreeMem

ShutDown3000:	;print	<"closing libraries"13,10>		;DEBUG
ShutDown1000:	closlib	Intuition
		;print	<"About to close dos.library",13,10>	;DEBUG
		closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;open serial.device

OpenSer:	tst.w	SerOpen
		bne	OpenSer_OUT

;Create read reply port for serial.device (or modem0.device etc.)
;ADD: Add port to public list, and remove the port!

		lib	Exec,CreateMsgPort
		move.l	d0,SRRPort
		beq	NoMsgPort

;		move.l	SRRPort,a1
;		lea.l	RPortText1,a0
;		move.l	a0,LN_NAME(a1)
;		lib	Exec,AddPort

;Create read IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SRRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,IORRequest
		beq	NoIOReq

;Create write reply port for serial.device (or modem0.device etc.)
;ADD: Add port to public list, and remove the port!

		lib	Exec,CreateMsgPort
		move.l	d0,SWRPort
		beq	NoMsgPort

;		move.l	SWRPort,a1
;		lea.l	WPortText1,a0
;		move.l	a0,LN_NAME(a1)
;		lib	Exec,AddPort

;Create write IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SWRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,IOWRequest
		beq	NoIOReq

;open the device

		move.l	SerName,a0
		move.l	SerUnit,d0
		move.l	IORRequest,a1
		move.l	Speed,IO_BAUD(a1)
		move.b	#SERF_SHARED,IO_SERFLAGS(a1)
		clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	NoSerial
		move.w	#$1,SerOpen		;just to tell if open

;Copy info from one req to the other

		move.l	IORRequest,a0
		move.l	IOWRequest,a1
		move.l	IO_DEVICE(a0),IO_DEVICE(a1)
		move.l	IO_UNIT(a0),IO_UNIT(a1)
		add.l	#48,a0			;get start of ioser
		add.l	#48,a1
		move.l	#34,d0
		lib	Exec,CopyMem

;set preferences with IOWReq

		tst.l	Speed
		beq	OpenSer_OUT
		move.l	IOWRequest,a1
		clr.l	IO_LENGTH(a1)
		clr.l	IO_DATA(a1)
		move.w	#SDCMD_SETPARAMS,IO_COMMAND(a1)
		move.l	Speed,IO_BAUD(a1)
		lib	Exec,DoIO
		tst.l	d0
		bne	NoSetSer

OpenSer_OUT:	move.l	#$DEAF,d0
		rts

CloseSer:	tst.w	SerOpen
		beq	CloseSer_OUT
		tst.w	Requested
		beq	CloseSer2
		bsr	ClearSer
CloseSer2:	move.l	IORRequest,a1
		lib	Exec,CloseDevice

		move.l	IORRequest,a0
		lib	Exec,DeleteIORequest

		move.l	SRRPort,a0
		lib	Exec,DeleteMsgPort

		move.l	IOWRequest,a0
		lib	Exec,DeleteIORequest

		move.l	SWRPort,a0
		lib	Exec,DeleteMsgPort

		clr.w	SerOpen
CloseSer_OUT:	rts

;CheckEvent gets messages from serial.device and keyboard (CTRL_C)
;
;Inputs
;
;Result
;
;D0 = -1 if serial returned
;D0 = 0  if CTRL_C given

CheckEvent:	tst.l	Local
		bne	CheckEvent1
		clr.l	d0
		clr.l	d1
		move.l	SRRPort,a1		;serial.device
		move.b	MP_SIGBIT(a1),d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break

		move.l	#-1,d0			;Serial returned
		rts

CheckEvent1:	clr.l	d1
		bset.l	#SIGBREAKB_CTRL_C,d1	;check for CTRL_C
		lib	Dos,CheckSignal
		btst.l	#SIGBREAKB_CTRL_C,d0
		bne	CheckEvent2
		move.l	#-1,d0
		rts
CheckEvent2:	clr.l	d0
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
		lea.l	PassWdFileN,a3
		bsr	FileError2
ReadUser1:	move.l	#-1,d0
		rts
ReadUser2:	clr.l	d0
		rts

;Compares two strings.
;
;INPUT
;
;A0 String 1
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
		move.l	d0,d4		;length of string1 to d4
		push	a0
		move.l	a1,a0
		bsr	GetLength
		pull	a0
		cmp.l	d4,d0		;length of string2 in d3
		bne	CmpStrings1.1
CmpStrings1:	tst.b	(a0)
		beq	CmpStrings2
		cmp.b	(a0)+,(a1)+
		beq	CmpStrings1
CmpStrings1.1:	clr.l	d0
		rts
CmpStrings2:	move.l	#-1,d0
		rts

;Decrypts passwords
;
;Input a0 = pointer to encrypted password
;      a1 = pointer to buffer for decrypted password
;

Decrypt:	clr.l	d1
Decrypt1:	move.l	(a0)+,d0
		swap.l	d0
		rol.l	#7,d0
		sub.l	#$DEADBEEF,d0
		ror.l	#2,d0
		move.l	d0,(a1)+
		add.l	#1,d1
		cmp.l	#3,d1
		bne	Decrypt1
		rts

;Wait until LF, CR received or buffer full from serial. Buffer all
;input with DEL removal
;
;INPUT
;
;D0 = 1 if echoing is desired
;
;OUTPUT
;
;Buffer 3 = Data received.

WaitUntilLF:	tst.l	Local
		bne	GetString2
		move.l	d0,d5

WaitUntilLF1:	bsr	CheckEvent
		tst.l	d0
		beq	WaitUntilLF_OUT

		bsr	BufferInput
		tst.l	d0
		beq	WaitUntilLF1		;No LF so get more chars
WaitUntilLF_OUT: rts

;Gets a string one letter at a time from the CLI. Handles BS correctly
;
;Inputs	D0 = 1 if echoing is desired
;

GetString2:	move.l	d0,d5
		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode
GetString2.01:	lea.l	Buffer3,a2
		move.l	_stdin,d1
		lib	Dos,Flush
		clr.l	d4
GetString2.1:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	GetString2.4
		cmp.l	#8,d0			;BS
		bne	GetString2.2
		beq	DoBS2
GetString2.2:	cmp.l	#CR,d0			;CR
		beq	GetString2.4
		cmp.l	#LF,d0			;LF
		beq	GetString2.4
		add.l	#1,d4
		move.b	d0,(a2)+
		tst.l	d5
		beq	GetString2.3
		bsr	Printer2
GetString2.3:	cmp.l	#32,d4
		bne	GetString2.1
GetString2.4:	clr.b	(a2)+
		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		rts

DoBS2:		tst.l	d4
		beq	DoBS2_OUT
		sub.l	#1,d4
		sub.l	#1,a2
		tst.l	d5
		beq	DoBS2_OUT
		push	a0
		lea.l	EraseText1,a0
		bsr	Printer
		pull	a0
DoBS2_OUT:	bra	GetString2.1

BufferInput:	cmp.b	#8,Buffer1		;Test for BS
		bne	BufferInput2
		bsr	DoBS
		bsr	ClearSer
		bsr	Reader
		clr.l	d0
		rts
BufferInput2:	lea.l	Buffer3,a2
		add.w	BufCount,a2
		move.b	Buffer1,(a2)
		tst.l	d5
		beq	BufferInput2.1
		bsr	Echo

BufferInput2.1:	add.w	#1,BufCount
		cmp.w	#32,BufCount		;Test for full buffer
		beq	BufferInput3		;Buffer is full

		cmp.b	#10,Buffer1
		beq	BufferInput3
		cmp.b	#13,Buffer1
		beq	BufferInput3
		bsr	ClearSer
		bsr	Reader
		clr.l	d0
		rts
BufferInput3:	lea.l	Buffer3,a2
		add.w	BufCount,a2
		clr.b	-1(a2)
		bsr	ClearSer
		bsr	Reader
		move.l	#-1,d0
		rts

DoBS:		tst.w	BufCount
		beq	DoBS_OUT
		tst.l	d5
		beq	DoBS1
		bsr	Echo
		lea.l	SpaceText1,a0
		bsr	GetLength
		bsr	Writer
		bsr	Echo
DoBS1:		sub.w	#1,BufCount
DoBS_OUT:	rts

;Get length of text in given address
;
;Input a0 = Address of null terminated text string
;
;Result d0 = Length

GetLength:	push	a0
		clr.l	d0
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a0)+
		bne	GetLength2
		sub.l	#1,d0		;don't include NULL
GetLength_OUT:	pull	a0
		rts

;Get line length of text in given address, including LF
;
;Input a0 = Address of LF terminated text string
;
;Result d0 = Length

GetLLength:	push	a0
		clr.l	d0
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLLength_OUT
GetLLength2:	add.l	#1,d0
		cmp.b	#10,(a0)+
		bne	GetLLength2
GetLLength_OUT:	pull	a0
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

;Seeks to end of the file given
;
;Input d1 = File
;
;Result d0 = Length of file in bytes
;

SeekEnd:	push	d2-d6
		move.l	d1,d6
		move.l	#00,d2
		move.l	#01,d3
		lib	Dos,Seek
		move.l	d6,d1
		lib	Dos,Seek
		pull	d2-d6
		rts

;Error etc. messages

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	lea.l	ArgErrorText1,a0
		bsr	Printer
		bra	ShutDown

NoInt:		lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

NoMsgPort:	lea.l	NoMsgPortText1,a0
		bsr	Printer
		clr.l	d0
		rts

NoIOReq:	lea.l	NoIOReqText1,a0
		bsr	Printer
		clr.l	d0
		rts

NoSerial:	lea.l	NoSerialText1,a0
		bsr	Printer
		move.l	SerName,a0
		bsr	Printer
		lea.l	NoSerialText2,a0
		bsr	Printer
		clr.l	d0
		rts

NoSetSer:	lea.l	NoSetSerText1,a0
		bsr	Printer
		clr.l	d0
		rts

Printer:	printa	a0,_stdout
		rts

Printer2:	push	d0-d7/a0-a6
		move.l	_stdout,d1
		move.l	a0,d2
		move.l	#1,d3
		lib	Dos,Write
		pull	d0-d7/a0-a6
		rts

;Structures
		ds.l	0

;lib stuff

		libnames

		ds.l	0

;Task stuff

OurTask:	dc.l	0

;Other stuff XIV

RDArgs1:	dc.l	0
LoginSeconds:	dc.l	0
LogoutSeconds:	dc.l	0
OnTimeMins:	dc.l	0
MicrosTemp:	dc.l	0
BufCount:	dc.w	0
LogFailCount:	dc.w	0

;Options, the Command Line Arrays

CLArray1:
LLPointer:	dc.l	0
Local:		dc.l	0			;0=If through device, 1=if local
Dumb:		dc.l	0
SerName:	dc.l	SerName2		;A pointer!
UnitPointer:	dc.l	0
SpeedPointer:	dc.l	0

LogLevel:	dc.l	0			;0=none, 1=failures, 2=logins, 3=both
SerUnit:	dc.l	0
Speed:		dc.l	0

;Ports/reqs/etc.

SRRPort:	dc.l	0
IORRequest:	dc.l	0
SWRPort:	dc.l	0
IOWRequest:	dc.l	0

;Files

WelcomeFile:	dc.l	0
WelcomeLength:	dc.l	0
PassWdFile:	dc.l	0
LogFile:	dc.l	0
_stdout:	dc.l	0
_stdin:		dc.l	0
NILFile:	dc.l	0

;Memory allocations

WelcomeMem:	dc.l	0

;Serial device stuff

SerOpen:	dc.w	0
Requested:	dc.w	0

;Strings, error

BreakText1:	dc.b	"***Break: Logger",13,10,0
NoIntText1:	dc.b	"ERROR: Couldn't open intuition.library!",13,10,0
ArgErrorText1:	dc.b	"ERROR: Invalid arguments specified.",13,10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",13,10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"serial.device",0
NoSerialText2:	dc.b	13,10,0
SerName3:	dc.b	"console.device",0
NoSetSerText1:	dc.b	"ERROR: Couldn't set parameters for device!",13,10,0
NILName:	dc.b	"NIL:",0
LowMemText1:	dc.b	13,10,"WARNING: System is low on memory!",13,10,0
FileErrorText1:	dc.b	13,10,"ERROR: Couldn't open file: ",0
FileErrorText2:	dc.b	13,10,"ERROR: A read error occured on file: ",0

;Strings, names

CLTemplate1:	dc.b	"LL=LOGLEVEL/N/K,LOCAL/S,DUMB/S,DEV=DEVICE/K,UNIT/N/K,SPEED/N/K",0
STVersion:	dc.b	"$VER: Logger 1.11 (1.1.93) (C)opyright Tomi Blinnikka 1993",0
RPortText1:	dc.b	"Logger read port",0
WPortText1:	dc.b	"Logger write port",0

;Filenames etc.

WelcomeFileN:	dc.b	"LOGGER:Logger-Header",0
PassWdFileN:	dc.b	"LOGGER:PassWd.LOGGER",0
LogFileN:	dc.b	"LOGGER:Logger.LOG",0
ExecuteText1:	dc.b	"C:Execute",0
		ds.l	0
ASCIIUnit:	dc.b	"     ",0

;Modem control strings

ResetString:	dc.b	"ATZ",13,10,0
AnswerString:	dc.b	"ATA",13,10,0
HangUpString1:	dc.b	"+++",0
HangUpString2:	dc.b	"ATH0",13,10,0

;Texts to output

LoginText1:	dc.b	13,10,"login: ",0
PasswordText1:	dc.b	13,10,"Password: ",0
CorrectText1:	dc.b	"*   Login correct:  ",0
IncorrectText1:	dc.b	13,10,"Login incorrect",13,10,0
IncorrectText2:	dc.b	"**  Login incorrect: ",0
LogFailureText1: dc.b	"Login failure",13,10,0
LogFailureText2: dc.b	"*** Login failure",0
LogOutText1:	dc.b	"    Logged out: ",0
LogFailIncText1: dc.b	" - ",0
LogFailIncText2: dc.b	", ",0
SpaceText1:	dc.b	" ",0
CRLFText1:	dc.b	13,10,0
CRLFText2:	dc.b	13,10,"    ",0
EraseText1:	dc.b	8," ",8,0
OnTimeText1:	dc.b	"Minutes used: "
OnTimeText2:	dc.b	"    0"
OnTimeText3:	dc.b	13,10,0
ConnectionText1: dc.b	13,10,"Connection closed.",13,10,0
fstrl:		dc.b	"%5.d",0
fstrl2:		dc.b	"%-5.ld",0

		ds.l	0

;Buffers
;
;Buffers 1 - 2 used by WaitForRing, WaitForConnect WaitUntilLF
;Buffer 3 used by WaitUntilLF

Buffer1:	dcb.b	2,0
Buffer2:	dcb.b	16,0
Buffer3:	dcb.b	34,0
Buffer4:	dcb.b	12,0

TempBuf1:	dcb.b	34,0

CmdString1:	dcb.b	400,0
CmdString2:	dc.b	"EndCLI",0
		ds.l	0

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

		ds.l	0

DateTime1:	dcb.b	12,0		;DateStamp
		dc.b	FORMAT_DOS	;dat_Format
		dc.b	0		;dat_Flags
		dc.l	StrDay1		;dat_StrDay
		dc.l	StrDate1	;dat_StrDate
		dc.l	StrTime1	;dat_StrTime

StrDay1:	dcb.b	LEN_DATSTRING,0
StrDate1:	dcb.b	LEN_DATSTRING,0
StrTime1:	dcb.b	LEN_DATSTRING,0

		end


