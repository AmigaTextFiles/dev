*************************************************
*						*
*		 (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.01	28/05/1992			*
*	 -0.99ö					*
*						*
* Version 1.00	04/08/1992			*
*						*
* BUGS: Lots! No phonebook.			*
*						*
* Version 1.01	05/08/1992			*
*						*
* BUGS: Some. Dialer problems.			*
*						*
* Version 1.02	06/08/1992			*
*						*
* BUGS: Less. Still dialer problems.		*
*						*
* Version 1.03	08/08/1992			*
*						*
* BUGS: 					*
*						*
* Version 1.04	11/08/1992			*
*						*
* Released					*
*						*
* BUGS: Send CTRL-P didn't work			*
*						*
* Version 1.05	15/08/1992			*
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

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


LF:		EQU	10
CR:		EQU	13
CTRL_O:		EQU	$0F
CTRL_P:		EQU	$10

QUIT_KEY:	EQU	CTRL_P
STATS_KEY:	EQU	CTRL_O

FALSE:		EQU	0
TRUE:		EQU	1

BUFLEN:		EQU	1024

		section	ST,CODE

		push	d2-d7/a2-a6
		push	d0/a0

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask

		openlib	Dos,NoDos		;Keep at beginning

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout
		lib	Dos,Input
		move.l	d0,_stdin
		move.l	d0,d1
		lib	Dos,IsInteractive
		tst.l	d0
		beq	NotInteractive
		pull	d0/a0
		clr.b	-1(a0,d0.l)
		cmp.b	#'?',(a0)
		beq	Usage
		cmp.w	#'-?',(a0)
		beq	Usage
		cmp.w	#'-h',(a0)
		beq	Usage

Cont0.2:	bsr	ConvASCII
		tst.w	d0
		beq	Cont1
		move.w	d0,SerUnit
Cont1:		cmp.b	#' ',(a0)
		bne	Cont1.1
		add.l	#1,a0
Cont1.1:	tst.b	(a0)
		beq	Cont1.2
		move.l	a0,SerName
Cont1.2:

;Create read reply port for serial.device (or modem0.device etc.)

MainStart:	lib	Exec,CreateMsgPort
		move.l	d0,SRRPort
		beq	NoMsgPort

;Create read IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SRRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,IORRequest
		beq	NoIOReq

		move.l	IORRequest,a1
		move.w	#CMD_READ,IO_COMMAND(a1)
		or.b	#IOF_QUICK,IO_FLAGS(a1)
		lea.l	Buffer3,a0
		move.l	a0,IO_DATA(a1)
		move.l	#1,IO_LENGTH(a1)

;Create write reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SWRPort
		beq	NoMsgPort

;Create write IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SWRPort,a0
		lib	Exec,CreateIORequest
		move.l	d0,IOWRequest
		beq	NoIOReq

		bsr	WriteDefaults

;open serial.device

		move.l	SerName,a0
		move.l	SerUnit,d0
		move.l	IORRequest,a1
		move.b	#SERF_SHARED,IO_SERFLAGS(a1)
		move.b	DataBits,IO_READLEN(a1)
		move.b	DataBits,IO_WRITELEN(a1)
		move.b	StopBits,IO_STOPBITS(a1)
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
		lea.l	StartText1,a0
		bsr	Printer

		bsr	DoPhoneBook

;Change mode for CLI to RAW:

		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

;Flush extra text

		move.l	_stdin,d1
		lib	Dos,Flush

Looper:		move.l	_stdin,d1
		move.l	#5000,d2
		lib	Dos,WaitForChar
		tst.l	d0
		beq	Looper1
		move.l	_stdin,d1
		lea.l	Buffer1,a0
		move.l	a0,d2
		move.l	#1,d3
		lib	Dos,Read
		cmp.b	#QUIT_KEY,Buffer1
		beq	Menu
		bsr	DoCLIInput
Looper1:	move.l	#BUFLEN,d0
		move.l	#1,d1
		bsr	Read
		tst.l	d0
		beq	Looper

		lea.l	Buffer3,a0
		clr.b	0(a0,d0.l)	;null terminated, please!

		bsr	DoSerialInput

		move.l	_stdout,d1
		lea.l	Buffer4,a1
		bsr	GetLength
		move.l	d0,d3
		lea.l	Buffer4,a0
		move.l	a0,d2
		lib	Dos,Write

		bra	Looper

Menu:		lea.l	MenuText1,a0
		bsr	Printer
Menu1:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	ShutDown
		cmp.l	#'p',d0
		beq	Prefs
		cmp.l	#'P',d0
		beq	Prefs
		cmp.l	#'s',d0
		beq	DoStats
		cmp.l	#'S',d0
		beq	DoStats
		cmp.l	#'c',d0
		beq	ClearBoth
		cmp.l	#'C',d0
		beq	ClearBoth
		cmp.l	#'d',d0
		beq	Dialer
		cmp.l	#'D',d0
		beq	Dialer
		cmp.l	#'o',d0
		beq	DoCTRL_P
		cmp.l	#'O',d0
		beq	DoCTRL_P
		cmp.l	#'f',d0
		beq	ResetFont
		cmp.l	#'F',d0
		beq	ResetFont
		cmp.l	#'x',d0
		beq	ClearScreen
		cmp.l	#'X',d0
		beq	ClearScreen
		cmp.l	#'r',d0
		beq	DoReset
		cmp.l	#'R',d0
		beq	DoReset
		cmp.l	#'h',d0
		beq	DoHangUp
		cmp.l	#'H',d0
		beq	DoHangUp
		cmp.l	#'?',d0
		beq	DoInfo
		cmp.l	#'q',d0
		beq	Quit
		cmp.l	#'Q',d0
		beq	Quit
		cmp.l	#'e',d0
		beq	Exit1
		cmp.l	#'E',d0
		beq	Exit1
		bra	Menu1
Exit1:		lea.l	ExitText1,a0
		bsr	Printer
		bra	Looper1
 
ResetFont:	lea.l	ResetFText1,a0
		bsr	Printer
		lea.l	PlainText1,a0
		bsr	Printer
		bra	Menu

ClearScreen:	lea.l	ClearSText1,a0
		bsr	Printer
		bra	Exit

DoStats:	lea.l	StatsText2,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bsr	GiveStats
		bsr	GetAnyKey
		bra	Menu

ClearBoth:	lea.l	ClearText1,a0
		bsr	Printer
		clr.l	Received
		clr.l	Sent
		bra	Menu

DoCTRL_P:	move.b	#CTRL_P,Buffer1
		bsr	Writer
		lea.l	CTRL_PText1,a0
		bsr	Printer
		add.l	#1,Sent
		bra	Exit

DoReset:	lea.l	ResetText1,a0
		bsr	Printer
		lea.l	ResetText2,a1
		bsr	GetLength
		lea.l	ResetText2,a0
		bsr	Writer2
		bra	Exit

DoHangUp:	lea.l	HangUpText1,a0
		bsr	Printer
		move.l	#3*50,d1
		lib	Dos,Delay
		lea.l	HangUpText2,a1
		bsr	GetLength
		lea.l	HangUpText2,a0
		bsr	Writer2
		move.l	#2*55,d1
		lib	Dos,Delay
		lea.l	HangUpText3,a1
		bsr	GetLength
		lea.l	HangUpText3,a0
		bsr	Writer2
		bra	Exit

DoInfo:		lea.l	InfoText1,a0
		bsr	Printer
		lea.l	AuthorText1,a0
		bsr	Printer
		bsr	GetAnyKey
		bra	Menu

Quit:		lea.l	QuitText1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bsr	GiveStats
		bra	ShutDown

Exit:		lea.l	TerminalText1,a0
		bsr	Printer
		bra	Looper1

Dialer:		lea.l	DialerText1,a0
		bsr	Printer
Dialer0.1:	lea.l	DialerText2,a0
		bsr	Printer
Dialer0.2:	bsr	PrintEntries
Dialer0.3:	bsr	PrintSelect
Dialer0.4:	lea.l	DialerText3,a0
		bsr	Printer
Dialer1:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Menu
		cmp.l	#'0',d0
		beq	DoEntry0
		cmp.l	#'1',d0
		beq	DoEntry1
		cmp.l	#'2',d0
		beq	DoEntry2
		cmp.l	#'3',d0
		beq	DoEntry3
		cmp.l	#'4',d0
		beq	DoEntry4
		cmp.l	#'5',d0
		beq	DoEntry5
		cmp.l	#'6',d0
		beq	DoEntry6
		cmp.l	#'7',d0
		beq	DoEntry7
		cmp.l	#'8',d0
		beq	DoEntry8
		cmp.l	#'9',d0
		beq	DoEntry9
		cmp.l	#'D',d0
		beq	DialList
		cmp.l	#'d',d0
		beq	DialList
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'e',d0
		beq	Exit1
		cmp.l	#'M',d0
		beq	MainMenu
		cmp.l	#'m',d0
		beq	MainMenu
		cmp.l	#'-',d0
		beq	MainMenu
		cmp.l	#'S',d0
		beq	SingleDial
		cmp.l	#'s',d0
		beq	SingleDial
		cmp.l	#'R',d0
		beq	Relist
		cmp.l	#'r',d0
		beq	Relist
		cmp.l	#'C',d0
		beq	ClearList
		cmp.l	#'c',d0
		beq	ClearList
		cmp.l	#'A',d0
		beq	SelectAll
		cmp.l	#'a',d0
		beq	SelectAll
		cmp.l	#'h',d0
		beq	DialerHelp
		cmp.l	#'H',d0
		beq	DialerHelp
		cmp.l	#'?',d0
		beq	DialerHelp
		bra	Dialer1

DialerHelp:	lea.l	HelpText1,a0
		bsr	Printer
		bra	Dialer0.4

ClearList:	lea.l	ClearText2,a0
		bsr	Printer
		clr.l	EntrySelected1
		clr.l	EntrySelected5
		clr.w	EntrySelected9
		bra	DoEntry_OUT1

SelectAll:	lea.l	AllText1,a0
		bsr	Printer
		move.l	#$01010101,EntrySelected1
		move.l	#$01010101,EntrySelected5
		move.w	#$0101,EntrySelected9
		bra	DoEntry_OUT1

DoEntry1:	bchg.b	#0,EntrySelected1
		bra	DoEntry_OUT
DoEntry2:	bchg.b	#0,EntrySelected2
		bra	DoEntry_OUT
DoEntry3:	bchg.b	#0,EntrySelected3
		bra	DoEntry_OUT
DoEntry4:	bchg.b	#0,EntrySelected4
		bra	DoEntry_OUT
DoEntry5:	bchg.b	#0,EntrySelected5
		bra	DoEntry_OUT
DoEntry6:	bchg.b	#0,EntrySelected6
		bra	DoEntry_OUT
DoEntry7:	bchg.b	#0,EntrySelected7
		bra	DoEntry_OUT
DoEntry8:	bchg.b	#0,EntrySelected8
		bra	DoEntry_OUT
DoEntry9:	bchg.b	#0,EntrySelected9
		bra	DoEntry_OUT
DoEntry0:	bchg.b	#0,EntrySelected0
DoEntry_OUT:	lea.l	EntryTextXIV,a0
		bsr	Printer
DoEntry_OUT1:	bsr	PrintSelect
		lea.l	SelectionText1,a0
		bsr	Printer
		bra	Dialer1

MainMenu:	lea.l	MainMenuText1,a0
		bsr	Printer
		bra	Menu

DialList:	lea.l	DialText1,a0
		bsr	Printer
		lea.l	DialText2,a0
		bsr	Printer

DialList1:	lea.l	EntrySelected1,a2
		tst.b	(a2)
		beq	DialList2
		lea.l	Entry1,a0
		tst.b	(a0)
		beq	DialList1.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList2
DialList1.1:	clr.b	(a2)
DialList2:	lea.l	EntrySelected2,a2
		tst.b	(a2)
		beq	DialList3
		lea.l	Entry2,a0
		tst.b	(a0)
		beq	DialList2.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList3
DialList2.1:	clr.b	(a2)
DialList3:	lea.l	EntrySelected3,a2
		tst.b	(a2)
		beq	DialList4
		lea.l	Entry3,a0
		tst.b	(a0)
		beq	DialList3.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList4
DialList3.1:	clr.b	(a2)
DialList4:	lea.l	EntrySelected4,a2
		tst.b	(a2)
		beq	DialList5
		lea.l	Entry4,a0
		tst.b	(a0)
		beq	DialList4.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList5
DialList4.1:	clr.b	(a2)
DialList5:	lea.l	EntrySelected5,a2
		tst.b	(a2)
		beq	DialList6
		lea.l	Entry5,a0
		tst.b	(a0)
		beq	DialList5.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList6
DialList5.1:	clr.b	(a2)
DialList6:	lea.l	EntrySelected6,a2
		tst.b	(a2)
		beq	DialList7
		lea.l	Entry6,a0
		tst.b	(a0)
		beq	DialList6.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList7
DialList6.1:	clr.b	(a2)
DialList7:	lea.l	EntrySelected7,a2
		tst.b	(a2)
		beq	DialList8
		lea.l	Entry7,a0
		tst.b	(a0)
		beq	DialList7.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList8
DialList7.1:	clr.b	(a2)
DialList8:	lea.l	EntrySelected8,a2
		tst.b	(a2)
		beq	DialList9
		lea.l	Entry8,a0
		tst.b	(a0)
		beq	DialList8.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList9
DialList8.1:	clr.b	(a2)
DialList9:	lea.l	EntrySelected9,a2
		tst.b	(a2)
		beq	DialList10
		lea.l	Entry9,a0
		tst.b	(a0)
		beq	DialList9.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList10
DialList9.1:	clr.b	(a2)
DialList10:	lea.l	EntrySelected0,a2
		tst.b	(a2)
		beq	DialList11
		lea.l	Entry10,a0
		tst.b	(a0)
		beq	DialList10.1
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#2,d0		;cancel
		beq	Dialer0.1
		cmp.l	#3,d0		;remove
		bne	DialList11
DialList10.1:	clr.b	(a2)
DialList11:	tst.l	EntrySelected1
		bne	DialList1
		tst.l	EntrySelected5
		bne	DialList1
		tst.w	EntrySelected9
		bne	DialList1
		lea.l	EmptyText1,a0
		bsr	Printer
		bra	Dialer0.1

Relist:		lea.l	RelistText1,a0
		bsr	Printer
		bra	Dialer0.2

SingleDial:	lea.l	SingleText1,a0
		bsr	Printer

		lea.l	SingleText2,a0
		bsr	Printer

		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode

		move.l	_stdin,d1
		lea.l	DialBuffer1,a0
		move.l	a0,d2
		move.l	#16,d3
		lib	Dos,FGets
		tst.l	d0
		beq	Dialer0.1

		lea.l	DialBuffer1,a0
		bsr	GetLLength
		clr.b	-1(a0,d1.l)	;remove LF

		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		lea.l	DialBuffer1,a1
		bsr	GetLength
		tst.l	d0
		beq	Dialer0.1

		lea.l	DialText2,a0
		bsr	Printer

SingleDial1:	lea.l	DialBuffer1,a0
		bsr	DialEntry
		tst.l	d0
		beq	Exit
		cmp.l	#1,d0
		beq	SingleDial1
		cmp.l	#2,d0
		beq	Dialer0.1
		cmp.l	#3,d0
		beq	Dialer0.1
		bra	Dialer0.1

Prefs:		lea.l	PrefsText1,a0
		bsr	Printer
Prefs1:		lea.l	PrefsText2,a0
		bsr	Printer
Prefs2:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Menu
		cmp.l	#'S',d0
		beq	SetSpeed
		cmp.l	#'s',d0
		beq	SetSpeed
		cmp.l	#'L',d0
		beq	SetLocalEcho
		cmp.l	#'l',d0
		beq	SetLocalEcho
		cmp.l	#'R',d0
		beq	ClearSettings
		cmp.l	#'r',d0
		beq	ClearSettings
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'e',d0
		beq	Exit1
		cmp.l	#'V',d0
		beq	DoView
		cmp.l	#'v',d0
		beq	DoView
		cmp.l	#'M',d0
		beq	MainMenu
		cmp.l	#'m',d0
		beq	MainMenu
		cmp.l	#'-',d0
		beq	MainMenu
		cmp.l	#'1',d0
		beq	SetCRTrans
		cmp.l	#'2',d0
		beq	SetLFTrans
		cmp.l	#'3',d0
		beq	SetCRTransIn
		cmp.l	#'4',d0
		beq	SetLFTransIn
		cmp.l	#'5',d0
		beq	SetDataBits
		cmp.l	#'6',d0
		beq	SetStopBits
		bra	Prefs2

DoView:		lea.l	ViewText1,a0
		bsr	Printer
		bsr	GiveSettings
		bsr	GetAnyKey
		bra	Prefs1

ClearSettings:	lea.l	ClearText3,a0
		bsr	Printer
		move.l	#9600,Speed
		move.b	#8,DataBits
		move.b	#1,StopBits
		clr.l	CRTranslate
		bsr	SetSerParams
		tst.l	d0
		beq	Prefs1
		lea.l	SerSetText1,a0
		bsr	Printer
		bra	Prefs1

SetCRTrans:	lea.l	CRTransText1,a0
		bsr	Printer
		lea.l	CRTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Prefs1
		move.b	d0,CRTranslate
		bra	Prefs1

SetLFTrans:	lea.l	LFTransText1,a0
		bsr	Printer
		lea.l	LFTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Prefs1
		move.b	d0,LFTranslate
		bra	Prefs1

SetCRTransIn:	lea.l	CRTransText3,a0
		bsr	Printer
		lea.l	CRTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Prefs1
		move.b	d0,CRTranslateIn
		bra	Prefs1

SetLFTransIn:	lea.l	LFTransText3,a0
		bsr	Printer
		lea.l	LFTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Prefs1
		move.b	d0,LFTranslateIn
		bra	Prefs1

SetLocalEcho:	lea.l	EchoText1,a0
		bsr	Printer
		bchg.b	#0,LocalEcho
		beq	SetLocalEcho1
		lea.l	EchoText3,a0
		bsr	Printer
		bra	Prefs1
SetLocalEcho1:	lea.l	EchoText2,a0
		bsr	Printer
		bra	Prefs1

SetDataBits:	lea.l	DBitsText1,a0
		bsr	Printer
		cmp.b	#7,DataBits
		beq	SetDataBits1
		move.b	#7,DataBits
		lea.l	DBitsText2,a0
		bsr	Printer
		bra	SetDataBits2
SetDataBits1:	move.b	#8,DataBits
		lea.l	DBitsText3,a0
		bsr	Printer
		bra	Prefs1
SetDataBits2:	bsr	SetSerParams
		tst.l	d0
		beq	Prefs1
		lea.l	DBitsText4,a0
		bsr	Printer
		bra	Prefs1

SetStopBits:	lea.l	SBitsText1,a0
		bsr	Printer
		cmp.b	#1,StopBits
		beq	SetStopBits1
		move.b	#1,StopBits
		lea.l	SBitsText2,a0
		bsr	Printer
		bra	SetStopBits2
SetStopBits1:	move.b	#2,StopBits
		lea.l	SBitsText3,a0
		bsr	Printer
		bra	Prefs1
SetStopBits2:	bsr	SetSerParams
		tst.l	d0
		beq	Prefs1
		lea.l	SBitsText4,a0
		bsr	Printer
		bra	Prefs1

SetSpeed:	lea.l	SpeedText11,a0
		bsr	Printer
SetSpeed1:	lea.l	SpeedText1,a0
		bsr	Printer
SetSpeed2:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Menu
		cmp.l	#'0',d0
		beq	DoSpeed0
		cmp.l	#'1',d0
		beq	DoSpeed1
		cmp.l	#'2',d0
		beq	DoSpeed2
		cmp.l	#'3',d0
		beq	DoSpeed3
		cmp.l	#'4',d0
		beq	DoSpeed4
		cmp.l	#'5',d0
		beq	DoSpeed5
		cmp.l	#'6',d0
		beq	DoSpeed6
		cmp.l	#'7',d0
		beq	DoSpeed7
		cmp.l	#'8',d0
		beq	DoSpeed8
		cmp.l	#'9',d0
		beq	DoSpeed9
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'e',d0
		beq	Exit1
		cmp.l	#'M',d0
		beq	MainMenu
		cmp.l	#'m',d0
		beq	MainMenu
		cmp.l	#'-',d0
		beq	Prefs
		bra	SetSpeed2

DoSpeed1:	move.l	#110,Speed
		bra	DoSpeed_OUT
DoSpeed2:	move.l	#300,Speed
		bra	DoSpeed_OUT
DoSpeed3:	move.l	#1200,Speed
		bra	DoSpeed_OUT
DoSpeed4:	move.l	#2400,Speed
		bra	DoSpeed_OUT
DoSpeed5:	move.l	#4800,Speed
		bra	DoSpeed_OUT
DoSpeed6:	move.l	#9600,Speed
		bra	DoSpeed_OUT
DoSpeed7:	move.l	#19200,Speed
		bra	DoSpeed_OUT
DoSpeed8:	move.l	#38400,Speed
		bra	DoSpeed_OUT
DoSpeed9:	move.l	#57600,Speed
		bra	DoSpeed_OUT
DoSpeed0:	move.l	#115200,Speed
DoSpeed_OUT:	lea.l	SpeedText11,a0
		bsr	Printer

		bsr	SetSerParams
		tst.l	d0
		beq	DoSpeed_OUT1

		lea.l	SpeedText12,a0
		bsr	Printer
		bsr	WriteDefaults
		bra	SetSpeed1
DoSpeed_OUT1:	bsr	WriteDefaults
		bra	Prefs1

;Dials one number. Fails for three reasons, because the user decided
;to skip this entry, to cancel dialing or to remove this entry.
;If a busy is found, a value of 1 will be returned.
;
;Inputs a0 = pointer to phonenumber (ASCII text)
;
;Result d0 = Success (0=Connect, 1=Skipped, 2=Cancelled, 3=Remove this entry)
;

DialEntry:	push	d2-d7/a2-a6
		move.l	a0,a4

DialEntry1:	lea.l	DialPrefix,a1
		bsr	GetLength
		lea.l	DialPrefix,a0
		bsr	Writer2
		move.l	a4,a1
		bsr	GetLength
		move.l	a4,a0
		bsr	Writer2
		lea.l	CRLFText1,a1
		bsr	GetLength
		lea.l	CRLFText1,a0
		bsr	Writer2
		lea.l	DialingText1,a0
		bsr	Printer
		move.l	a4,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		move.l	#BUFLEN,d0		;try to read ATDT etc.
		move.l	#1,d1
		bsr	Read

DialEntry2:	move.l	#10,d1
		lib	Dos,Delay
		move.l	#BUFLEN,d0
		move.l	#4,d1
		bsr	Read
		tst.l	d0
		beq	DialEntry3
		lea.l	Buffer3,a0
		clr.b	0(a0,d0.l)	;null terminated, please!
		move.w	#'CO',d0
		lea.l	Buffer3,a0
		bsr	FindWord
		bne	DialEntry_OUT1
		move.w	#'BU',d0
		lea.l	Buffer3,a0
		bsr	FindWord
		bne	DialEntry4
		move.w	#'NO',d0
		lea.l	Buffer3,a0
		bsr	FindWord
		bne	DialEntry_OUT2
DialEntry3:	move.l	_stdin,d1
		move.l	#10000,d2
		lib	Dos,WaitForChar
		tst.l	d0
		beq	DialEntry2
		move.l	_stdin,d1
		lea.l	Buffer2,a0
		move.l	a0,d2
		move.l	#1,d3
		lib	Dos,Read
		cmp.l	#1,d0
		bne	DialEntry2
		cmp.b	#' ',Buffer2	;Space
		beq	DialEntry_OUT2
		cmp.b	#27,Buffer2	;ESC
		beq	DialEntry_OUT3
		cmp.b	#8,Buffer2	;BS
		beq	DialEntry_OUT4
		bra	DialEntry2
DialEntry4:	lea.l	BusyText1,a0
		bsr	Printer
		move.l	#55,d1
		lib	Dos,Delay
		pull	d2-d7/a2-a6
		move.l	#1,d0
		rts
DialEntry_OUT1:	move.l	#BUFLEN,d0		;try to read extra stuff
		move.l	#1,d1
		bsr	Read
		lea.l	ConnectText1,a0
		bsr	Printer
		pull	d2-d7/a2-a6
		clr.l	d0
		rts
DialEntry_OUT2:	lea.l	CRLFText1,a1
		bsr	GetLength
		lea.l	CRLFText1,a0
		bsr	Writer2
		lea.l	SkippedText1,a0
		bsr	Printer
		move.l	#55,d1
		lib	Dos,Delay
		pull	d2-d7/a2-a6
		move.l	#1,d0
		rts
DialEntry_OUT3:	lea.l	CancelledText1,a0
		bsr	Printer
		lea.l	CRLFText1,a1
		bsr	GetLength
		lea.l	CRLFText1,a0
		bsr	Writer2
		move.l	#55,d1
		lib	Dos,Delay
		pull	d2-d7/a2-a6
		move.l	#2,d0
		rts
DialEntry_OUT4:	lea.l	CRLFText1,a1
		bsr	GetLength
		lea.l	CRLFText1,a0
		bsr	Writer2
		move.l	#55,d1
		lib	Dos,Delay
		lea.l	RemoveText1,a0
		bsr	Printer
		pull	d2-d7/a2-a6
		move.l	#3,d0
		rts

Break:		lea.l	BreakText1,a0
		bsr	Printer
		clr.l	d0
		rts

ClearSer:	move.l	IORRequest,a1
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
		rts

;Buffered read from a device
;
;Inputs d0 = Buffer length (maximum amount to read)
;	d1 = Minimum amout to read
;
;Result d0 = Amount actually read
;

Read:		push	d2-d7/a2-a6
		move.l	d0,d4
		move.l	d1,d5

		move.l	IOWRequest,a1			;get amount of bytes
		move.w	#SDCMD_QUERY,IO_COMMAND(a1)	;in buffer
		or.b	#IOF_QUICK,IO_FLAGS(a1)
		lib	Exec,DoIO

		move.l	IOWRequest,a1
		move.l	IO_ACTUAL(a1),d0
		beq	Read_OUT1
		cmp.l	d5,d0
		bmi	Read_OUT1
		cmp.l	d4,d0
		bls	Read1
		move.l	d4,d0			;available > buffer size
Read1:		move.l	IORRequest,a1
		move.l	d0,IO_LENGTH(a1)
		BEGINIO

		bsr	WriteDefaults
		move.l	IORRequest,a1
		move.l	IO_ACTUAL(a1),d0	;even on error we return
		add.l	d0,Received		;correct amount in buffer
		pull	d2-d7/a2-a6
		rts

Read_OUT1:	bsr	WriteDefaults
		clr.l	d0
		pull	d2-d7/a2-a6
		rts

Writer:		add.l	#1,Sent
		move.l	IOWRequest,a1
		lib	Exec,DoIO		;May freeze, too bad
		rts

;Writes string to serial port
;
;D0 = Length
;A0 = String

Writer2:	add.l	d0,Sent
		move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	d0,IO_LENGTH(a1)
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO		;May freeze, too bad
		bsr	WriteDefaults
		rts

;Reset back to default...

WriteDefaults:	move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	#1,IO_LENGTH(a1)		;writes in one byte "chunks"
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)
		rts

SetSerParams:	move.l	IOWRequest,a1
		clr.l	IO_LENGTH(a1)
		clr.l	IO_DATA(a1)
		move.w	#SDCMD_SETPARAMS,IO_COMMAND(a1)
		move.l	Speed,IO_BAUD(a1)
		move.b	DataBits,IO_READLEN(a1)
		move.b	DataBits,IO_WRITELEN(a1)
		move.b	StopBits,IO_STOPBITS(a1)
		lib	Exec,DoIO
		rts

DoCLIInput:	lea.l	Buffer1,a0
		cmp.b	#CR,Buffer1
		beq	DoCLIInput3
		cmp.b	#LF,Buffer1
		beq	DoCLIInput4
DoCLIInput1:	bsr	Writer
		btst.b	#0,LocalEcho
		beq	DoCLIInput2
		lea.l	Buffer1,a0
		bsr	Printer
DoCLIInput2:	rts
DoCLIInput3:	tst.b	CRTranslate
		beq	DoCLIInput1
		cmp.b	#1,CRTranslate
		beq	DoCLIInput2
		cmp.b	#2,CRTranslate
		bne	DoCLIInput2
		bsr	DoCLIInput1
		move.b	#LF,Buffer1
		bra	DoCLIInput1
DoCLIInput4:	tst.b	LFTranslate
		beq	DoCLIInput1
		cmp.b	#1,LFTranslate
		beq	DoCLIInput2
		cmp.b	#2,LFTranslate
		bne	DoCLIInput2
		move.b	#CR,Buffer1
		bsr	DoCLIInput1
		move.b	#LF,Buffer1
		bra	DoCLIInput1

DoSerialInput:	push	d0-d7/a2-a6
		lea.l	Buffer3,a0
		lea.l	Buffer4,a1
DoSerialInput1:	tst.b	(a0)
		beq	DoSerialInput3.1
		cmp.b	#CR,(a0)
		beq	DoSerialInput4
		cmp.b	#LF,(a0)
		beq	DoSerialInput6
DoSerialInput2:	move.b	(a0)+,(a1)+
		bra	DoSerialInput1
DoSerialInput3:	pull	d0-d7/a2-a6
		rts
DoSerialInput3.1: clr.b	(a1)
		pull	d0-d7/a2-a6
		rts
DoSerialInput4:	tst.b	CRTranslateIn
		beq	DoSerialInput2
		cmp.b	#1,CRTranslateIn
		bne	DoSerialInput5
		add.l	#1,a0
		bra	DoSerialInput1
DoSerialInput5:	cmp.b	#2,CRTranslateIn
		bne	DoSerialInput2
		move.b	#CR,(a1)+
		move.b	#LF,(a1)+
		add.l	#1,a0
		bra	DoSerialInput1
DoSerialInput6:	tst.b	LFTranslateIn
		beq	DoSerialInput2
		cmp.b	#1,LFTranslateIn
		bne	DoSerialInput7
		add.l	#1,a0
		bra	DoSerialInput1
DoSerialInput7:	cmp.b	#2,LFTranslateIn
		bne	DoSerialInput2
		move.b	#CR,(a1)+
		move.b	#LF,(a1)+
		add.l	#1,a0
		bra	DoSerialInput1

;gets anykey from user
;
;Results d0 = -1 for error, otherwise d0 = key pressed

GetAnyKey:	lea.l	AnyKeyText1,a0
		bsr	Printer
		move.l	_stdin,d1
		lib	Dos,Flush
		move.l	_stdin,d1
		lib	Dos,FGetC
		lea.l	CRLFText1,a0
		bsr	Printer
		rts

;gets input from user
;
;Results d0 = 0 for N, 1 for S, 2 for A, -1 for error

GetNSA:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	GetNSA_ERR1
		cmp.l	#'n',d0
		beq	GetNSA1
		cmp.l	#'N',d0
		beq	GetNSA1
		cmp.l	#'s',d0
		beq	GetNSA2
		cmp.l	#'S',d0
		beq	GetNSA2
		cmp.l	#'a',d0
		beq	GetNSA3
		cmp.l	#'A',d0
		beq	GetNSA3
		cmp.l	#CR,d0
		beq	GetNSA_ERR1
		cmp.l	#LF,d0
		beq	GetNSA_ERR1
		bra	GetNSA
GetNSA1:	lea.l	NoneText1,a0
		bsr	Printer
		move.l	#0,d0
		rts
GetNSA2:	lea.l	StripText1,a0
		bsr	Printer
		move.l	#1,d0
		rts
GetNSA3:	lea.l	AddText1,a0
		bsr	Printer
		move.l	#2,d0
		rts
GetNSA_ERR1:	move.l	#-1,d0
		rts

;Give NSA
;
;Inputs d0 = NSA qualifier(?)
;

GiveNSA:	tst.b	d0
		beq	GiveNSA1
		cmp.b	#1,d0
		beq	GiveNSA2
		cmp.b	#2,d0
		beq	GiveNSA3
		lea.l	NAText1,a0
		bsr	Printer
		rts
GiveNSA1:	lea.l	NText1,a0
		bsr	Printer
		rts
GiveNSA2:	lea.l	SText1,a0
		bsr	Printer
		rts
GiveNSA3:	lea.l	AText1,a0
		bsr	Printer
		rts

Nope:		lea.l	SpaceText1,a0
		bsr	Printer
		rts
Yep:		lea.l	StarText1,a0
		bsr	Printer
		rts

GiveSettings:	lea.l	fstrl3,a0		;HEX->ASCII
		lea.l	Speed,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	SpeedText90,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	CurrentText1,a0
		bsr	Printer

		tst.l	Speed
		beq	GiveSettings0.1
		lea.l	SpeedText90,a0
		bsr	Printer
		bra	GiveSettings0.2

GiveSettings0.1: lea.l	DefText1,a0
		bsr	Printer

GiveSettings0.2: lea.l	CurrentText2,a0
		bsr	Printer

		tst.w	LocalEcho
		bne	GiveSettings1
		bsr	Nope
		bra	GiveSettings2
GiveSettings1:	bsr	Yep

GiveSettings2:	lea.l	CurrentText7,a0
		bsr	Printer

		lea.l	CurrentText3,a0
		bsr	Printer

		move.b	CRTranslate,d0
		bsr	GiveNSA

		lea.l	CurrentText4,a0
		bsr	Printer

		move.b	LFTranslate,d0
		bsr	GiveNSA

		lea.l	CurrentText7,a0
		bsr	Printer

		lea.l	CurrentText5,a0
		bsr	Printer

		move.b	CRTranslateIn,d0
		bsr	GiveNSA

		lea.l	CurrentText6,a0
		bsr	Printer

		move.b	LFTranslateIn,d0
		bsr	GiveNSA

		lea.l	CurrentText7,a0
		bsr	Printer

		lea.l	CurrentText8,a0
		bsr	Printer

		cmp.b	#7,DataBits
		bne	GiveSettings3
		lea.l	SevenText1,a0
		bsr	Printer
		bra	GiveSettings4
GiveSettings3:	cmp.b	#8,DataBits
		bne	GiveSettings3.1
		lea.l	EightText1,a0
		bsr	Printer
		bra	GiveSettings4
GiveSettings3.1: lea.l	DefText1,a0
		bsr	Printer

GiveSettings4:	lea.l	CurrentText9,a0
		bsr	Printer

		cmp.b	#1,StopBits
		bne	GiveSettings5
		lea.l	OneText1,a0
		bsr	Printer
		bra	GiveSettings6
GiveSettings5:	cmp.b	#2,StopBits
		bne	GiveSettings5.1
		lea.l	TwoText1,a0
		bsr	Printer
		bra	GiveSettings6
GiveSettings5.1: lea.l	DefText1,a0
		bsr	Printer

GiveSettings6:	lea.l	CurrentText7,a0
		bsr	Printer

		rts

GiveStats:	lea.l	fstrl1,a0		;HEX->ASCII
		lea.l	Received,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	ReceivedText1,a3	;Destination
		lib	Exec,RawDoFmt

		lea.l	fstrl2,a0		;HEX->ASCII
		lea.l	Sent,a1			;Number2Print
		lea.l	PutChProc,a2
		lea.l	SentText1,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	StatsText1,a0
		bsr	Printer
		lea.l	ReceivedText1,a0
		bsr	Printer
		lea.l	SentText1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		rts

PrintEntries:	tst.b	DialPrefix
		beq	PrintEntries1
		lea.l	PrefixText1,a0
		bsr	Printer
		lea.l	DialPrefix,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries1:	tst.b	Entry1
		beq	PrintEntries2
		lea.l	EntryText1,a0
		bsr	Printer
		lea.l	Entry1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries2:	tst.b	Entry2
		beq	PrintEntries3
		lea.l	EntryText2,a0
		bsr	Printer
		lea.l	Entry2,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries3:	tst.b	Entry3
		beq	PrintEntries4
		lea.l	EntryText3,a0
		bsr	Printer
		lea.l	Entry3,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries4:	tst.b	Entry4
		beq	PrintEntries5
		lea.l	EntryText4,a0
		bsr	Printer
		lea.l	Entry4,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries5:	tst.b	Entry5
		beq	PrintEntries6
		lea.l	EntryText5,a0
		bsr	Printer
		lea.l	Entry5,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries6:	tst.b	Entry6
		beq	PrintEntries7
		lea.l	EntryText6,a0
		bsr	Printer
		lea.l	Entry6,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries7:	tst.b	Entry7
		beq	PrintEntries8
		lea.l	EntryText7,a0
		bsr	Printer
		lea.l	Entry7,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries8:	tst.b	Entry8
		beq	PrintEntries9
		lea.l	EntryText8,a0
		bsr	Printer
		lea.l	Entry8,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries9:	tst.b	Entry9
		beq	PrintEntries10
		lea.l	EntryText9,a0
		bsr	Printer
		lea.l	Entry9,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries10:	tst.b	Entry10
		beq	PrintEntries11
		lea.l	EntryText10,a0
		bsr	Printer
		lea.l	Entry10,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
PrintEntries11:	rts

PrintSelect:	lea.l	SelectedText1,a0
		bsr	Printer
		lea.l	SelectText1,a0
		bsr	Printer
		tst.b	EntrySelected1
		beq	PrintSelect1
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect2
PrintSelect1:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect2:	lea.l	SelectText2,a0
		bsr	Printer
		tst.b	EntrySelected2
		beq	PrintSelect3
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect4
PrintSelect3:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect4:	lea.l	SelectText3,a0
		bsr	Printer
		tst.b	EntrySelected3
		beq	PrintSelect5
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect6
PrintSelect5:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect6:	lea.l	SelectText4,a0
		bsr	Printer
		tst.b	EntrySelected4
		beq	PrintSelect7
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect8
PrintSelect7:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect8:	lea.l	SelectText5,a0
		bsr	Printer
		tst.b	EntrySelected5
		beq	PrintSelect9
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect10
PrintSelect9:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect10:	lea.l	SelectText6,a0
		bsr	Printer
		tst.b	EntrySelected6
		beq	PrintSelect11
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect12
PrintSelect11:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect12:	lea.l	SelectText7,a0
		bsr	Printer
		tst.b	EntrySelected7
		beq	PrintSelect13
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect14
PrintSelect13:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect14:	lea.l	SelectText8,a0
		bsr	Printer
		tst.b	EntrySelected8
		beq	PrintSelect15
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect16
PrintSelect15:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect16:	lea.l	SelectText9,a0
		bsr	Printer
		tst.b	EntrySelected9
		beq	PrintSelect17
		lea.l	SelectText11,a0
		bsr	Printer
		bra	PrintSelect18
PrintSelect17:	lea.l	SelectText12,a0
		bsr	Printer
PrintSelect18:	lea.l	SelectText0,a0
		bsr	Printer
		tst.b	EntrySelected0
		beq	PrintSelect19
		lea.l	SelectText13,a0
		bsr	Printer
		bra	PrintSelect20
PrintSelect19:	lea.l	SelectText14,a0
		bsr	Printer
PrintSelect20:	lea.l	CRLFText1,a0
		bsr	Printer
		rts

DoPhoneBook:	lea.l	PhoneBookName,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PhoneFile
		bne	DoPhoneBook1

		lea.l	FileErrorText1,a0
		bsr	Printer
		bra	DoPBook_ERR1

DoPhoneBook1:	move.l	PhoneFile,d1
		lea.l	LoadBuffer1,a0
		move.l	a0,d2
		move.l	#4,d3
		lib	Dos,Read
		cmp.l	#4,d0
		beq	DoPhoneBook2

		lea.l	FileErrorText2,a0
		bsr	Printer
		bra	DoPBook_ERR1

DoPhoneBook2:	cmp.l	#'#ST#',LoadBuffer1
		beq	DoPhoneBook3

		lea.l	FileErrorText3,a0
		bsr	Printer
		bra	DoPBook_ERR1

DoPhoneBook3:	move.l	PhoneFile,d1
		bsr	GetFileLength
		move.l	d0,PhoneLength
		beq	DoPBook_OUT

		move.l	PhoneLength,d0
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1	;Type of memory wanted
		lib	Exec,AllocMem
		move.l	d0,PhoneMem
		bne	DoPhoneBook4

		lea.l	MemErrorText1,a0
		bsr	Printer
		bra	DoPBook_ERR2

DoPhoneBook4:	move.l	PhoneFile,d1
		move.l	PhoneMem,d2
		move.l	PhoneLength,d3
		lib	Dos,Read
		cmp.l	PhoneLength,d0
		beq	DoPhoneBook5

		lea.l	FileErrorText2,a0
		bsr	Printer
		bra	DoPBook_ERR2

DoPhoneBook5:	move.l	PhoneMem,a0
		bsr	GetLLength
		add.l	d1,a0		;skip identifier (#ST#)
		lea.l	DialPrefix,a1
		bsr	Parse
		lea.l	Entry1,a1
		bsr	Parse
		lea.l	Entry2,a1
		bsr	Parse
		lea.l	Entry3,a1
		bsr	Parse
		lea.l	Entry4,a1
		bsr	Parse
		lea.l	Entry5,a1
		bsr	Parse
		lea.l	Entry6,a1
		bsr	Parse
		lea.l	Entry7,a1
		bsr	Parse
		lea.l	Entry8,a1
		bsr	Parse
		lea.l	Entry9,a1
		bsr	Parse
		lea.l	Entry10,a1
		bsr	Parse

DoPBook_OUT:	bsr	KillPFile
		bsr	KillPMem
		move.l	#-1,d0
		rts
DoPBook_ERR1:	clr.l	d0
		rts
DoPBook_ERR2:	bsr	KillPFile
		bsr	KillPMem
		clr.l	d0
		rts

KillPFile:	move.l	PhoneFile,d1
		beq	KillPFile1
		lib	Dos,Close
		clr.l	PhoneFile
KillPFile1:	rts

KillPMem:	tst.l	PhoneMem
		beq	KillPMem1
		move.l	PhoneMem,a1
		move.l	PhoneLength,d0
		lib	Exec,FreeMem
		clr.l	PhoneMem
		clr.l	PhoneLength
KillPMem1:	rts

ShutDown:	tst.w	SerOpen
		beq	ShutDown9000
		bsr	ClearSer
		move.l	IORRequest,a1
		lib	Exec,CloseDevice

ShutDown9000:	move.l	IORRequest,a0
		lib	Exec,DeleteIORequest

		move.l	SRRPort,a0
		lib	Exec,DeleteMsgPort

		move.l	IOWRequest,a0
		lib	Exec,DeleteIORequest

		move.l	SWRPort,a0
		lib	Exec,DeleteMsgPort

		move.l	_stdin,d1
		beq	ShutDown8000
		move.l	#FALSE,d2
		lib	Dos,SetMode

ShutDown8000:	bsr	KillPFile
		bsr	KillPMem
ShutDown7000:
ShutDown1000:	closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;CheckEvent waits for messages from serial.device

CheckEvent:	clr.l	d0
		clr.l	d1
		move.l	SRRPort,a1		;serial.device
		move.l	a1,a2
		move.b	MP_SIGBIT(a1),d1
		bset.l	d1,d0
		lib	Exec,Wait

C2GetMsg2:	move.l	#-1,d0
		rts

;Get length of text in given address
;
;Input a1 = Address of null terminated text string
;
;Result d0 = Length

GetLength:	clr.l	d0
		cmp.l	#$00,a1		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a1)+
		bne	GetLength2
		sub.l	#1,d0		;don't include NULL
GetLength_OUT:	rts


;Get line length of text in given address, including LF
;
;Input a0 = Address of LF terminated text string
;
;Result d1 = Length

GetLLength:	push	a0
		clr.l	d1
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLLength_OUT
GetLLength2:	add.l	#1,d1
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

;Parses string to given address. Removes spaces, tabs, CRs and comments.
;Quits on LF or NULL.
;
;Inputs a0 = pointer to string to parse (source)
;       a1 = buffer to store parsed data (destination)
;       d0 = maximum length of output
;
;Results a0 = pointer with start of next data to parse
;             i.e. pointer to data after LF or NULL
;

Parse:		tst.b	(a0)		
		beq	Parse_OUT1
		cmp.b	#' ',(a0)	;Space
		beq	ParseSkipC
		cmp.b	#9,(a0)		;TAB
		beq	ParseSkipC
		cmp.b	#';',(a0)	;Comment
		beq	ParseSkipL
		cmp.b	#CR,(a0)	;CR
		beq	ParseSkipC
		cmp.b	#LF,(a0)	;LF
		beq	Parse_OUT1
		move.b	(a0)+,(a1)+	;copy char
		sub.l	#1,d0
		beq	Parse_OUT
		bra	Parse
ParseSkipC:	add.l	#1,a0
		bra	Parse
ParseSkipL:	bsr	GetLLength
		add.l	d1,a0
Parse_OUT:	rts
Parse_OUT1:	add.l	#1,a0
		rts

;Finds a string in another string
;
;Inputs	a0 = Pointer to string1 (from what to find)
;	d0 = Word (what to search for)
;
;Result	d0 = 0 if not found

FindWord:	tst.b	(a0)
		beq	FindWord1
		cmp.w	(a0),d0
		beq	FindWord2
		add.l	#1,a0
		bra	FindWord
FindWord1:	clr.l	d0		;keep right before rts
		rts
FindWord2:	move.l	#-1,d0		;keep right before rts
		rts

ConvASCII:	clr.l	d0
		clr.l	d1
		cmp.b	#' ',(a0)
		bne	ConvASCII2
		add.l	#1,a0
ConvASCII2:	move.b	(a0),d1
		cmp.b	#'0',d1
		bcs	ConvASCII_OUT
		cmp.b	#'9',d1
		bhi	ConvASCII_OUT
		sub.b	#'0',d1
		mulu.w	#10,d0
		add.l	d1,d0
		add.l	#1,a0
		bra	ConvASCII2
ConvASCII_OUT:	rts

;Error etc. messages

Usage:		lea.l	UsageText1,a0
		bsr	Printer
		bra	ShutDown

NoDos:		add.l	#8,sp
		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NotInteractive:	add.l	#8,sp
		lea.l	NotIntText1,a0
		bsr	Printer
		bra	ShutDown

NoMsgPort:	lea.l	NoMsgPortText1,a0
		bsr	Printer
		bra	ShutDown

NoIOReq:	lea.l	NoIOReqText1,a0
		bsr	Printer
		bra	ShutDown

NoSerial:	lea.l	NoSerialText1,a0
		bsr	Printer
		move.l	SerName,a0
		bsr	Printer
		lea.l	NoSerialText2,a0
		bsr	Printer
		bra	ShutDown

Printer:	printa	a0,_stdout
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Structures

;lib stuff

		libnames

;Other stuff, part I

OurTask:	dc.l	0
SRRPort:	dc.l	0
IORRequest:	dc.l	0
SWRPort:	dc.l	0
IOWRequest:	dc.l	0
_stdout:	dc.l	0
_stdin:		dc.l	0
BufCount:	dc.l	0
Sent:		dc.l	0			;Count sent chars
Received:	dc.l	0			;Count reveived chars
PhoneFile:	dc.l	0
PhoneLength:	dc.l	0
PhoneMem:	dc.l	0

;Other stuff part II

EntrySelected1:	dc.b	0
EntrySelected2:	dc.b	0
EntrySelected3:	dc.b	0
EntrySelected4:	dc.b	0
EntrySelected5:	dc.b	0
EntrySelected6:	dc.b	0
EntrySelected7:	dc.b	0
EntrySelected8:	dc.b	0
EntrySelected9:	dc.b	0
EntrySelected0:	dc.b	0
Speed:		dc.l	0
LocalEcho:	dc.w	0		;bit 0 (0=no echo, 1=echo)
CRTranslate:	dc.b	0		;0=none, 1=strip, 2=add LF
LFTranslate:	dc.b	0		;0=none, 1=strip, 2=add CR
CRTranslateIn:	dc.b	0		;0=none, 1=strip, 2=add LF
LFTranslateIn:	dc.b	0		;0=none, 1=strip, 2=add CR
DataBits:	dc.b	8
StopBits:	dc.b	1

;Serial device stuff

SerName:	dc.l	SerName2		;A pointer!
SerUnit:	dc.l	0
SerOpen:	dc.w	0

;Strings, error

BreakText1:	dc.b	"***Break",10,0
NotIntText1:	dc.b	"ERROR: Please don't redirect input!",10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"serial.device",0
NoSerialText2:	dc.b	10,0
FileErrorText1:	dc.b	"ERROR: Couldn't open S:ShellTerm.phone",13,10,0
FileErrorText2:	dc.b	"ERROR: Couldn't read file!",13,10,0
FileErrorText3:	dc.b	"ERROR: Incorrect filetype!",13,10,0
MemErrorText1:	dc.b	"ERROR: Out of memory!",13,10,0

;Strings, Main menu

MenuText1:	dc.b	13,10,"ShellTerm menu. Please choose item:",13,10
		dc.b	13,10,"S) Statistics"
		dc.b	13,10,"C) Clear statistics"
		dc.b	13,10,"D) Dialer"
		dc.b	13,10,"O) Send CTRL-P (ASCII: DLE #16 $10 &020)"
		dc.b	13,10,"F) Reset font"
		dc.b	13,10,"X) Clear screen"
		dc.b	13,10,"R) Reset modem (Using Hayes-commands)"
		dc.b	13,10,"H) Hangup line (Using Hayes-commands)"
		dc.b	13,10,"P) Preferences"
		dc.b	13,10,"?) Program and author information"
		dc.b	13,10,"Q) Quit ShellTerm"
		dc.b	13,10,"E) Exit menus",13,10
		dc.b	13,10,"Selection: ",0
InfoText1:	dc.b	"Information",13,10,0
CTRL_PText1:	dc.b	"CTRL-P sent",13,10,0
ExitText1:	dc.b	"Exit",13,10
TerminalText1:	dc.b	13,10,"Terminal mode active:",13,10,0
StartText1:	dc.b	"Welcome to ShellTerm. Use CTRL-P to get menu.",13,10,0
ResetFText1:	dc.b	"Reset font",13,10,0
QuitText1:	dc.b	"Quit",13,10,0
StatsText1:	dc.b	"Statistics:",13,10,0
StatsText2:	dc.b	"Statistics",13,10,0
DialerText1:	dc.b	"Dialer",13,10,0
PrefsText1:	dc.b	"Preferences",13,10,0
ReceivedText1:	dc.b	"                            ",00,00,0	;max of 4294967295
;			"   4294967295 bytes received",CR,LF
SentText1:	dc.b	"                        ",00,00,0	;max of 4294967295
;			"   4294967295 bytes sent",CR,LF
fstrl1:		dc.b	"   %10.ld bytes received",13,10,0
fstrl2:		dc.b	"   %10.ld bytes sent",0
ClearText1:	dc.b	"Cleared",13,10,0
ClearText3:	dc.b	"Reset",13,10,0
CRLFText1:	dc.b	CR,LF,0
ResetText1:	dc.b	"Reset",13,10,0
ResetText2:	dc.b	"ATZ",13,10,0
HangUpText1:	dc.b	"Hangup",13,10,0
HangUpText2:	dc.b	"+++",0
HangUpText3:	dc.b	"ATH0",13,10,0
PlainText1:	dc.b	$9b,$30,$6d,0
ClearSText1:	dc.b	$1B,$5B,$30,$3B,$30,$48,$1B,$5B,$4A,0

;Preferences

PrefsText2:	dc.b	13,10,"ShellTerm preferences:",13,10
PrefText3:	dc.b	13,10,"Options:   (S)elect speeds      (L)ocal echo"
		dc.b	13,10,"           (R)eset settings     (V)iew settings"
		dc.b	13,10,"      OUT: (1) CR translate     (2) LF translate"
		dc.b	13,10,"       IN: (3) CR translate     (4) LF translate"
		dc.b	13,10,"           (5) Set databits     (6) Set stopbits",13,10
		dc.b	13,10,"           (M)ain menu          (E)xit menus",13,10
		dc.b	13,10,"Selection: ",0
ViewText1:	dc.b	"View settings",13,10,0
SpeedText11:	dc.b	"Speed",13,10,0
EchoText1:	dc.b	"Toggle echo",13,10,0
CRTransText1:	dc.b	"CR translate (OUT)",13,10,0
LFTransText1:	dc.b	"LF translate (OUT)",13,10,0
CRTransText3:	dc.b	"CR translate (IN)",13,10,0
LFTransText3:	dc.b	"LF translate (IN)",13,10,0
EchoText2:	dc.b	13,10,"Local echo is now enabled",13,10,0
EchoText3:	dc.b	13,10,"Local echo is now disabled",13,10,0
DBitsText1:	dc.b	"Toggle databits",13,10,0
DBitsText2:	dc.b	13,10,"Using 7 databits",13,10,0
DBitsText3:	dc.b	13,10,"Using 8 databits",13,10,0
DBitsText4:	dc.b	13,10,"ERROR: Couldn't set databits!",13,10,0
SBitsText1:	dc.b	"Toggle stopbits",13,10,0
SBitsText2:	dc.b	13,10,"Using 1 stopbit",13,10,0
SBitsText3:	dc.b	13,10,"Using 2 stopbits",13,10,0
SBitsText4:	dc.b	13,10,"ERROR: Couldn't set stopbits!",13,10,0
CRTransText2:	dc.b	13,10,"(N)one, (S)trip, (A)dd LF: ",0
LFTransText2:	dc.b	13,10,"(N)one, (S)trip, (A)dd CR: ",0
AnyKeyText1:	dc.b	13,10,"Please press any key: ",0
NoneText1:	dc.b	"None",13,10,0
StripText1:	dc.b	"Strip",13,10,0
AddText1:	dc.b	"Add",13,10,0

CurrentText1:	dc.b	13,10,"Current settings: Speed (",0
CurrentText2:	dc.b	"), Local echo (",0
CurrentText3:	dc.b	"                  CR xlate out (",0
CurrentText4:	dc.b	"), LF xlate out (",0
CurrentText5:	dc.b	"                  CR xlate in (",0
CurrentText6:	dc.b	"), LR xlate in (",0
CurrentText7:	dc.b	")",13,10,0
CurrentText8:	dc.b	"                  Databits (",0
CurrentText9:	dc.b	") Stopbits (",0
NAText1:	dc.b	"N/A",0
DefText1:	dc.b	"Default",0
StarText1:	dc.b	"*",0
SpaceText1:	dc.b	" ",0
NText1:		dc.b	"N",0
SText1:		dc.b	"S",0
AText1:		dc.b	"A",0
OneText1:	dc.b	"1",0
TwoText1:	dc.b	"2",0
SevenText1:	dc.b	"7",0
EightText1:	dc.b	"8",0

;Speed prefs

SpeedText1:	dc.b	13,10,"1) 110 bps",13,10
SpeedText2:	dc.b	"2) 300 bps",13,10
SpeedText3:	dc.b	"3) 1200 bps",13,10
SpeedText4:	dc.b	"4) 2400 bps",13,10
SpeedText5:	dc.b	"5) 4800 bps",13,10
SpeedText6:	dc.b	"6) 9600 bps",13,10
SpeedText7:	dc.b	"7) 19 200 bps",13,10
SpeedText8:	dc.b	"8) 38 400 bps",13,10
SpeedText9:	dc.b	"9) 57 600 bps",13,10
SpeedText10:	dc.b	"0) 115 200 bps",13,10
		dc.b	13,10,"Options: (0-9) Select speed     (-) Previous menu",13,10
		dc.b	13,10,"           (M)ain menu          (E)xit menus",13,10
		dc.b	13,10,"Selection: ",0
SpeedText12:	dc.b	13,10,"ERROR: Couldn't set that speed. Please reselect!",13,10,0
SerSetText1:	dc.b	13,10,"ERROR: Couldn't set serial parameters!",13,10,0
fstrl3:		dc.b	"%ld",0
SpeedText90:	dc.b	0,0,0,0,0,0,0,0

;Dialer stuff

DialerText2:	dc.b	13,10,"ShellTerm auto-dialer (phonebook)",13,10
		dc.b	13,10,"Entries:",13,10,13,10,0
PrefixText1:	dc.b	"Prefix: ",0
EntryText1:	dc.b	"1) ",0
EntryText2:	dc.b	"2) ",0
EntryText3:	dc.b	"3) ",0
EntryText4:	dc.b	"4) ",0
EntryText5:	dc.b	"5) ",0
EntryText6:	dc.b	"6) ",0
EntryText7:	dc.b	"7) ",0
EntryText8:	dc.b	"8) ",0
EntryText9:	dc.b	"9) ",0
EntryText10:	dc.b	"0) ",0
DialerText3:	dc.b	13,10,"Options: (0-9) Un/select entry  (R)elist numbers"
		dc.b	13,10,"           (S)ingle dial        (D)ial list"
		dc.b	13,10,"           (C)lear list         (A)ll",13,10
		dc.b	13,10,"           (M)ain menu          (E)xit menus",13,10
SelectionText1:	dc.b	13,10,"Selection: ",0
DialText1:	dc.b	"Dial list",13,10,0
MainMenuText1:	dc.b	"Main menu",13,10,0
SingleText1:	dc.b	"Dial number",13,10,0
SingleText2:	dc.b	"Number to dial: ",0
RelistText1:	dc.b	"Relist",13,10,13,10,0
EntryTextXIV:	dc.b	"Entry",13,10,0
ClearText2:	dc.b	"Clear",13,10,0
AllText1:	dc.b	"All",13,10,0
HelpText1:	dc.b	"Help",13,10,0
DialingText1:	dc.b	13,10,"Dialing: ",0
DialText2:	dc.b	13,10,"[Space] to skip, [Backspace] to remove this entry, [Escape] to quit",13,10,0
ConnectText1:	dc.b	"Connection established",13,10,0
BusyText1:	dc.b	"Busy",13,10,0
SkippedText1:	dc.b	"Skipping entry",13,10,0
CancelledText1:	dc.b	"Quitting",13,10,0
RemoveText1:	dc.b	"Removing this entry",13,10,0
EmptyText1:	dc.b	13,10,"List is empty",13,10,0
SelectedText1:	dc.b	13,10,"Entries selected:",13,10,0
SelectText1:	dc.b	"1 (",0
SelectText2:	dc.b	"2 (",0
SelectText3:	dc.b	"3 (",0
SelectText4:	dc.b	"4 (",0
SelectText5:	dc.b	"5 (",0
SelectText6:	dc.b	"6 (",0
SelectText7:	dc.b	"7 (",0
SelectText8:	dc.b	"8 (",0
SelectText9:	dc.b	"9 (",0
SelectText0:	dc.b	"0 (",0
SelectText11:	dc.b	"*) ",0
SelectText12:	dc.b	" ) ",0
SelectText13:	dc.b	"*)",0
SelectText14:	dc.b	" )",0
PhoneBookName:	dc.b	"S:ShellTerm.phone",0

;Strings, names

STVersion:	dc.b	"$VER: "
UsageText1:	dc.b	"ShellTerm 1.05 (15.8.92) (C)opyright Tomi Blinnikka 1992",13,10,13,10
;		dc.b	10,"           !!! BETA TESTER VERSION !!!",13,10,13,10,13,10
		dc.b	"USAGE: ShellTerm [Unit] [Device]",13,10,13,10
		dc.b	"       Where: [Unit] is the unit number",13,10
		dc.b	"              [Device] is the device name",13,10,13,10
		dc.b	"       Default [Device] is serial.device",13,10,13,10
		dc.b	"Use current shell as a terminal program.",13,10
		dc.b	"See docs for more information.",13,10,0
AuthorText1:	dc.b	13,10,"Name    : ShellTerm",13,10
		dc.b	"Version : 1.05 (15.8.92)",13,10
		dc.b	"Author  : Tomi Blinnikka",13,10,13,10
		dc.b	"(C)opyright Tomi Blinnikka 1992",13,10,0
		ds.l	0

;Buffers

Buffer1:	dcb.b	2,0		;For writes to serial (read from CLI)
Buffer2:	dcb.b	2,0		;For reads
Buffer3:	dcb.b	BUFLEN,0	;For reads from serial
Buffer4:	dcb.b	BUFLEN*2,0	;For writes to CLI

LoadBuffer1:	dcb.b	4,0		;for header
DialPrefix:	dc.b	"ATDT"		;dial prefix
		dcb.b	18-4,0
Entry1:		dcb.b	18,0		;Entry 1
Entry2:		dcb.b	18,0		;Entry 2
Entry3:		dcb.b	18,0		;Entry 3
Entry4:		dcb.b	18,0		;Entry 4
Entry5:		dcb.b	18,0		;Entry 5
Entry6:		dcb.b	18,0		;Entry 6
Entry7:		dcb.b	18,0		;Entry 7
Entry8:		dcb.b	18,0		;Entry 8
Entry9:		dcb.b	18,0		;Entry 9
Entry10:	dcb.b	18,0		;Entry 10
DialBuffer1:	dcb.b	18,0		;for single dial

		end

