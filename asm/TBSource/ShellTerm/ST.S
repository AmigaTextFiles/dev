*************************************************
*						*
*	       (C)opyright 1992-93		*
*						*
*		by Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	28/05/1992			*
*	 -0.99v					*
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
* Version 1.06	28/08/1992			*
*						*
* Added prefs file and swap BS & DEL		*
* See docs for more info			*
*						*
* Version 1.07	30/08/1992			*
*						*
* Version 1.08	04/09/1992			*
*						*
* Added cursor remap				*
*						*
* Version 1.09	06/09/1992			*
*						*
* Version 1.10	20/10/1992			*
*						*
* Hopefully fixed bug in FindWord		*
* Added: PublicPorts				*
*						*
* Version 1.11	13/11/1992 <-Friday the 13th	*
*						*
* Version for Mika Henttinen			*
*						*
* Version 1.12	30/12/1992			*
*						*
* Changed parser to Commodore's own ReadArgs	*
*						*
* Version 1.13	02/01/1993			*
*						*
* Added 'Execute Command'			*
*						*
* Version 1.14	06/02/1993			*
*						*
* Fixed bug at start clearing CLI pointer's	*
* last byte					*
*						*
* Version 1.15	10/02/1993			*
*						*
* Made sure that the Modify Mode in the dialer	*
* is turned off when the dialer is quit		*
*						*
* Version 1.16	24/03/1993			*
*						*
* Fixed bug with opening device!		*
*						*
* Version 1.17	25/03/1993			*
*						*
* Added optional port				*
*						*
* Version 1.18	22/05/1993			*
*						*
* Added scripts to archive			*
* 						*
* Fixed bug with opening device and setting	*
* parameters.					*
*						*
* Added XON/XOFF				*
*						*
* Version 1.19	26/05/1993			*
*						*
* Added version to prefs file			*
*						*
* Version 1.20	23/06/1993			*
*						*
* Fixed "Can't open device '"... string.	*
*						*
* Version 1.21	02/07/1993			*
*						*
* Fixed 'Load prefs' bug.			*
*						*
* Version 1.22	04/07/1993			*
*						*
* Made compatible with dnet.device.		*
*						*
* Version 1.23	05/07/1993			*
*						*
* Added CTS/RTS handshaking.			*
* Made a little safer to use.			*
*						*
* Version 1.24	17/07/1993			*
*						*
* Made a little safer to use.			*
*						*
* Version 1.25	31/07/1993			*
*						*
* Fixed a bug with OpenSerial. Didn't open in	*
* shared mode.					*
*						*
* Added Unregistered text.			*
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


PROGVERSION:	macro
		dc.b	"1.25 (31.07.93)"
		endm

STFileVersion:	EQU	'ST01'

CTRL_B:		EQU	2
CTRL_F:		EQU	6
BS:		EQU	8
TAB:		EQU	9
LF:		EQU	10
CR:		EQU	13
CTRL_N:		EQU	$E
CTRL_O:		EQU	$F
CTRL_P:		EQU	$10
DEL:		EQU	127
CSI:		EQU	$9B
Cursor_Up:	EQU	'A'
Cursor_Down:	EQU	'B'
Cursor_Left:	EQU	'D'
Cursor_Right:	EQU	'C'

MENU_KEY:	EQU	CTRL_P
STATS_KEY:	EQU	CTRL_O

FALSE:		EQU	0
TRUE:		EQU	1

BUFLEN:		EQU	1024
ENTRYLENGTH:	EQU	20

		section	ST,CODE

		push	d2-d7/a2-a6
		push	d0/a0

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

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

		move.l	CLArray1,a0
		lea.l	FileNameBuf1,a1
		tst.b	(a0)
		beq	Parse2
CLCopyLoop:	move.b	(a0)+,(a1)+
		tst.b	-1(a1)
		bne	CLCopyLoop

Parse2:		tst.l	OptPortName
		beq	Parse3			;No port specified

		lib	Exec,CreateMsgPort
		move.l	d0,OptPort
		beq	NoMsgPort

;Add port to public lists

		move.l	OptPort,a1
		move.l	OptPortName,a0
		move.l	a0,LN_NAME(a1)
		lib	Exec,AddPort

Parse3:

MainStart:	openlib	Utility,NoUtility		;Keep at beginning

		bsr	LoadPrefsFile

		bsr	OpenSerial

		bsr	SetSerParams
		tst.l	d0
		beq	MainStart1
		bsr	ParamsNotSet

MainStart1:	lea.l	StartText1,a0
		bsr	Printer

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
		cmp.b	#MENU_KEY,Buffer1
		beq	Menu
		move.b	CPAssign,d0
		cmp.b	Buffer1,d0
		beq	DoCTRL_P2
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

		bsr	DoCapture

		bra	Looper

Menu:		bsr	DoANSI
		lea.l	MenuText1,a0
		bsr	Printer
Menu1:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	ShutDown
		cmp.l	#'a',d0
		bcs	Menu2
		cmp.l	#'z',d0
		bhi	Menu2
		sub.l	#32,d0
Menu2:		cmp.l	#'P',d0
		beq	Prefs
		cmp.l	#'S',d0
		beq	DoStats
		cmp.l	#'C',d0
		beq	ClearBoth
		cmp.l	#'D',d0
		beq	Dialer
		cmp.l	#'B',d0
		beq	DoBreak
		cmp.l	#'O',d0
		beq	DoCTRL_P
		cmp.l	#'F',d0
		beq	ResetFont
		cmp.l	#'X',d0
		beq	ClearScreen
		cmp.l	#'R',d0
		beq	DoReset
		cmp.l	#'H',d0
		beq	DoHangUp
		cmp.l	#'L',d0
		beq	DoOpenCapture
		cmp.l	#'K',d0
		beq	DoCloseCapture
		cmp.l	#'+',d0
		beq	DoUpLoad
		cmp.l	#'-',d0
		beq	DoDownLoad
		cmp.l	#'M',d0
		beq	DoExecute
		cmp.l	#'?',d0
		beq	DoInfo
		cmp.l	#'Q',d0
		beq	Quit
		cmp.l	#'E',d0
		beq	Exit1
		bra	Menu1
Exit1:		lea.l	ExitText1,a0
		bsr	Printer

Exit:		bsr	DoANSI
		lea.l	TerminalText1,a0
		bsr	Printer
		bclr.b	#0,ModifyMode			;Clear modify bit

		tst.w	SerOpen
		bne	Exit_OUT
		bsr	NoSerial
Exit_OUT:	bra	Looper1
 
ResetFont:	lea.l	ResetFText1,a0
		bsr	Printer
		lea.l	PlainText1,a0
		bsr	Printer
		bra	Menu

ClearScreen:	lea.l	ClearSText1,a0
		bsr	Printer
		bra	Exit

DoANSI:		tst.b	UseANSI
		beq	DoANSI_OUT
		lea.l	ClearSText1,a0
		bsr	Printer
DoANSI_OUT:	rts

DoStats:	lea.l	StatsText2,a0
		bsr	Printer
		bsr	DoANSI
		bsr	GiveStats
		bsr	GetAnyKey
		bra	Menu

ClearBoth:	lea.l	ClearText1,a0
		bsr	Printer
		clr.l	Received
		clr.l	Sent
		bra	Menu

DoBreak:	bsr	SendBREAK
		lea.l	BreakText2,a0
		bsr	Printer

		bra	Exit

DoCTRL_P:	move.b	#CTRL_P,Buffer1
		bsr	Writer
		lea.l	CTRL_PText1,a0
		bsr	Printer
		add.l	#1,Sent
		bra	Exit

DoCTRL_P2:	move.b	#CTRL_P,Buffer1
		bsr	Writer
		add.l	#1,Sent
		bra	Looper

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

DoOpenCapture:	lea.l	OpenCaptureText1,a0
		bsr	Printer

		tst.l	CaptureFile
		bne	DoOpenCapture_ERR2

		lea.l	FileNameBuf2,a0
		move.l	#128,d3
		bsr	GetString

		tst.b	FileNameBuf2
		beq	DoOpenCapture_OUT

		lea.l	FileNameBuf2,a0
		move.l	a0,d1
		move.l	#MODE_READWRITE,d2
		lib	Dos,Open
		move.l	d0,CaptureFile
		beq	DoOpenCapture_ERR1

DoOpenCapture_OUT: bra	Menu
DoOpenCapture_ERR1: lea.l	CaptureErrorText1,a0
		bsr	Printer
		bra	Menu
DoOpenCapture_ERR2: lea.l	CaptureErrorText2,a0
		bsr	Printer
		bra	Menu

DoCloseCapture:	lea.l	CloseCaptureText1,a0
		bsr	Printer

		move.l	CaptureFile,d1
		beq	DoCloseCapture_OUT
		lib	Dos,Close
		clr.l	CaptureFile
DoCloseCapture_OUT: bra	Menu

DoUpLoad:	lea.l	ULText2,a0
		bsr	Printer
		lea.l	ULProgram,a0
		tst.b	(a0)
		beq	DoUpLoad9

		lea.l	FileNameBuf2,a0
		move.l	#128,d3
		bsr	GetString

		bsr	MakeCmdString

		tst.b	ULDir
		beq	DoUpLoad1
		lea.l	ULDir,a0
		move.l	a0,d1
		move.l	#ACCESS_READ,d2
		lib	Dos,Lock
		move.l	d0,ULLock
		bne	DoUpLoad2

DoUpLoad1:	lea.l	NoULDirText1,a0
		bsr	Printer
		bra	DoUpLoad5

DoUpLoad2:	move.l	ULLock,d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock

DoUpLoad5:	lea.l	ULText3,a0
		bsr	Printer

		lea.l	FileNameBuf3,a0
		move.l	a0,d1
		clr.l	d2
		clr.l	d3
		lib	Dos,Execute

;change back to dir where we started from

		move.l	OldLock,d1
		beq	DoUpLoad7
		lib	Dos,CurrentDir
		clr.l	OldLock

DoUpLoad7:	move.l	ULLock,d1
		beq	DoUpLoad8
		lib	Dos,UnLock
		clr.l	ULLock
DoUpLoad8:
		bra	Exit
DoUpLoad9:	lea.l	NoULDLProgText1,a0
		bsr	Printer
		bra	Exit

DoDownLoad:	lea.l	DLText2,a0
		bsr	Printer
		tst.b	DLProgram
		beq	DoDownLoad9

;change to the dl dir

		tst.b	DLDir
		beq	DoDownLoad1
		lea.l	DLDir,a0
		move.l	a0,d1
		move.l	#ACCESS_READ,d2
		lib	Dos,Lock
		move.l	d0,DLLock
		bne	DoDownLoad2

DoDownLoad1:	lea.l	NoDLDirText1,a0
		bsr	Printer
		bra	DoDownLoad5

DoDownLoad2:	move.l	DLLock,d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock

DoDownLoad5:	lea.l	DLProgram,a0
		move.l	a0,d1
		clr.l	d2
		clr.l	d3
		lib	Dos,Execute

;change back to dir where we started from

		move.l	OldLock,d1
		beq	DoDownLoad7
		lib	Dos,CurrentDir
		clr.l	OldLock

DoDownLoad7:	move.l	DLLock,d1
		beq	DoDownLoad8
		lib	Dos,UnLock
		clr.l	DLLock
DoDownLoad8:	bra	Exit

DoDownLoad9:	lea.l	NoULDLProgText1,a0
		bsr	Printer
		bra	Exit

DoExecute:	lea.l	ExecuteText1,a0
		bsr	Printer

		lea.l	FileNameBuf2,a0
		move.l	#128,d3
		bsr	GetString

		lea.l	FileNameBuf2,a0
		tst.b	(a0)
		beq	DoExecute_OUT
		move.l	a0,d1
		clr.l	d2
		clr.l	d3
		lib	Dos,Execute

		bsr	GetAnyKey

DoExecute_OUT:	bra	Menu

DoInfo:		lea.l	InfoText1,a0
		bsr	Printer
		bsr	DoANSI
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

;If you add another way to get out of the dialer, please remember to clear
;the ModifyMode (just in case), so the user can't accidentally erase an
;entry!

Dialer:		lea.l	DialerText1,a0
		bsr	Printer
Dialer0.1:	bsr	DoANSI
		lea.l	DialerText2,a0
		bsr	Printer
Dialer0.2:	bsr	PrintEntries
Dialer0.3:	bsr	PrintSelect
Dialer0.4:	lea.l	DialerText3,a0
		bsr	Printer
Dialer1:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Menu
		cmp.l	#'a',d0
		bcs	Dialer2
		cmp.l	#'z',d0
		bhi	Dialer
		sub.l	#32,d0
Dialer2:	cmp.l	#'0',d0
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
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'M',d0
		beq	MainMenu
		cmp.l	#'-',d0
		beq	MainMenu
		cmp.l	#'S',d0
		beq	SingleDial
		cmp.l	#'R',d0
		beq	Relist
		cmp.l	#'C',d0
		beq	ClearList
		cmp.l	#'A',d0
		beq	SelectAll
		cmp.l	#'I',d0
		beq	SetModifyMode
		cmp.l	#'P',d0
		beq	EditPrefix
		cmp.l	#'H',d0
		beq	DialerHelp
		cmp.l	#'?',d0
		beq	DialerHelp
		bra	Dialer1

SetModifyMode:	bchg.b	#0,ModifyMode
		beq	SetModifyMode1
		lea.l	ModifyText2,a0
		bsr	Printer
		bra	Dialer0.4
SetModifyMode1:	lea.l	ModifyText1,a0
		bsr	Printer
		bra	Dialer0.4

DialerHelp:	lea.l	HelpText1,a0
		bsr	Printer
		bsr	DoANSI
		bra	Dialer0.4

ClearList:	lea.l	ClearText2,a0
		bsr	Printer
		bsr	DoANSI
		clr.l	EntrySelected1
		clr.l	EntrySelected5
		clr.w	EntrySelected9
		bra	DoEntry_OUT1

SelectAll:	lea.l	AllText1,a0
		bsr	Printer
		bsr	DoANSI
		move.l	#$01010101,EntrySelected1
		move.l	#$01010101,EntrySelected5
		move.w	#$0101,EntrySelected9
		bra	DoEntry_OUT1

DoEntry1:	lea.l	Entry1,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected1
		bra	DoEntry_OUT
DoEntry2:	lea.l	Entry2,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected2
		bra	DoEntry_OUT
DoEntry3:	lea.l	Entry3,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected3
		bra	DoEntry_OUT
DoEntry4:	lea.l	Entry4,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected4
		bra	DoEntry_OUT
DoEntry5:	lea.l	Entry5,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected5
		bra	DoEntry_OUT
DoEntry6:	lea.l	Entry6,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected6
		bra	DoEntry_OUT
DoEntry7:	lea.l	Entry7,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected7
		bra	DoEntry_OUT
DoEntry8:	lea.l	Entry8,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected8
		bra	DoEntry_OUT
DoEntry9:	lea.l	Entry9,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected9
		bra	DoEntry_OUT
DoEntry0:	lea.l	Entry10,a0
		tst.w	ModifyMode
		bne	EditEntry
		bchg.b	#0,EntrySelected0
DoEntry_OUT:	lea.l	EntryTextXIV,a0
		bsr	Printer
		bsr	DoANSI
DoEntry_OUT1:	bsr	PrintSelect
		lea.l	SelectionText1,a0
		bsr	Printer
		bra	Dialer1

EditEntry:	push	a0
		lea.l	EditEntryText1,a0
		bsr	Printer
		lea.l	EditEntryText2,a0
		bsr	Printer
		pull	a0
		move.l	#ENTRYLENGTH,d3
		bsr	GetString
		bsr	PrintEntries
		bra	DoEntry_OUT1

EditPrefix:	lea.l	EditEntryText3,a0
		bsr	Printer
		lea.l	EditEntryText4,a0
		bsr	Printer
		lea.l	DialPrefix,a0
		move.l	#16,d3
		bsr	GetString
		bra	Dialer0.1

MainMenu:	bclr.b	#0,ModifyMode			;Clear modify bit
		lea.l	MainMenuText1,a0
		bsr	Printer
		bra	Menu

DialList:	lea.l	DialText1,a0
		bsr	Printer
		bsr	DoANSI
		lea.l	DialText2,a0
		bsr	Printer

DialList1:	lea.l	EntrySelected1,a2
		tst.b	(a2)
		beq	DialList2
		lea.l	Entry1,a0
		tst.b	(a0)
		beq	DialList1.1
		bsr	DialEntry
		tst.l	d0		;connect
		bne	DialList1.01
DialLCONNECT:	clr.b	(a2)
		beq	Exit
DialList1.01:	cmp.l	#2,d0		;cancel
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		beq	DialLCONNECT	;Connect
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
		bsr	DoANSI
		bra	Dialer0.2

SingleDial:	lea.l	SingleText1,a0
		bsr	Printer

		bsr	DoANSI

		lea.l	SingleText2,a0
		bsr	Printer

		lea.l	DialBuffer1,a0
		move.l	#ENTRYLENGTH,d3
		bsr	GetString
		tst.l	d0
		bne	Dialer0.1

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
Prefs1:		bsr	DoANSI
		lea.l	PrefsText2,a0
		bsr	Printer
Prefs2:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Menu
		cmp.l	#'a',d0
		bcs	Prefs3
		cmp.l	#'z',d0
		bhi	Prefs3
		sub.l	#32,d0
Prefs3:		cmp.l	#'S',d0
		beq	SetSpeed
		cmp.l	#'T',d0
		beq	Terminal
		cmp.l	#'R',d0
		beq	ClearSettings
		cmp.l	#'L',d0
		beq	DoLoad
		cmp.l	#'W',d0
		beq	DoSave
		cmp.l	#'N',d0
		beq	NameFile
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'V',d0
		beq	DoView
		cmp.l	#'U',d0
		beq	SetULDir
		cmp.l	#'D',d0
		beq	SetDLDir
		cmp.l	#'+',d0
		beq	SetULProg
		cmp.l	#'-',d0
		beq	SetDLProg
		cmp.l	#'A',d0
		beq	AssignCTRL_P
		cmp.l	#'M',d0
		beq	MainMenu
		bra	Prefs2

SetULDir:	lea.l	ULText5,a0
		bsr	Printer
		lea.l	ULDir,a0
		move.l	#128,d3
		bsr	GetString
		bra	Prefs1

SetDLDir:	lea.l	DLText5,a0
		bsr	Printer
		lea.l	DLDir,a0
		move.l	#128,d3
		bsr	GetString
		bra	Prefs1

SetULProg:	lea.l	ULText1,a0
		bsr	Printer
		lea.l	ULProgram,a0
		move.l	#128,d3
		bsr	GetString
		bra	Prefs1

SetDLProg:	lea.l	DLText1,a0
		bsr	Printer
		lea.l	DLProgram,a0
		move.l	#128,d3
		bsr	GetString
		bra	Prefs1

AssignCTRL_P:	lea.l	AssignText1,a0
		bsr	Printer

		move.l	_stdin,d1
		lib	Dos,Flush

		lea.l	AssignText2,a0
		bsr	Printer

		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Prefs1
		move.b	d0,CPAssign

		lea.l	CRLFText1,a0
		bsr	Printer
		bra	Prefs1

NameFile:	lea.l	EnterNText1,a0
		bsr	Printer

		lea.l	EnterNText2,a0
		bsr	Printer

		lea.l	FileNameBuf1,a0
		move.l	#128,d3
		bsr	GetString
		tst.l	d0
		bne	Prefs1

		bra	Prefs1

DoLoad:		lea.l	LoadText1,a0
		bsr	Printer
		bsr	CloseSerial
		bsr	LoadPrefsFile
		bsr	OpenSerial

		bsr	SetSerParams
		tst.l	d0
		beq	DoLoad1
		bsr	ParamsNotSet
DoLoad1:	bra	Prefs1
DoSave:		lea.l	SaveText1,a0
		bsr	Printer
		bsr	SavePrefsFile
		bra	Prefs1

DoView:		lea.l	ViewText1,a0
		bsr	Printer
		bsr	DoANSI
		bsr	GiveSettings
		bsr	GetAnyKey
		bra	Prefs1

ClearSettings:	lea.l	ClearText3,a0
		bsr	Printer
		move.l	#9600,Speed
		move.b	#8,DataBits
		move.b	#1,StopBits
		clr.l	CRTranslate	;All translating (long)
		clr.l	SwapBSDEL	;SwapBSDEL+UseANSI+CPAssign+CursorRemap
		bsr	SetSerParams
		tst.l	d0
		beq	ClearSettings1
		bsr	ParamsNotSet
ClearSettings1:	bra	Prefs1

Terminal:	lea.l	STerminalText1,a0
		bsr	Printer
Terminal1:	bsr	DoANSI
		lea.l	STerminalText2,a0
		bsr	Printer
Terminal2:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Prefs1
		cmp.l	#'a',d0
		bcs	Terminal3
		cmp.l	#'z',d0
		bhi	Terminal3
		sub.l	#32,d0
Terminal3:	cmp.l	#'L',d0
		beq	SetLocalEcho
		cmp.l	#'S',d0
		beq	SetSwapBSDEL
		cmp.l	#'1',d0
		beq	SetCRTrans
		cmp.l	#'2',d0
		beq	SetLFTrans
		cmp.l	#'3',d0
		beq	SetCRTransIn
		cmp.l	#'4',d0
		beq	SetLFTransIn
		cmp.l	#'A',d0
		beq	SetANSIMode
		cmp.l	#'C',d0
		beq	SetCRemapMode
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'M',d0
		beq	MainMenu
		cmp.l	#'-',d0
		beq	Prefs
		bra	Terminal2

SetCRemapMode:	bchg.b	#0,CursorRemap
		beq	SetCRemapMode1
		lea.l	CRemapText2,a0
		bsr	Printer
		bra	Terminal1
SetCRemapMode1:	lea.l	CRemapText1,a0
		bsr	Printer
		bra	Terminal1

SetANSIMode:	bchg.b	#0,UseANSI
		beq	SetANSIMode1
		lea.l	ANSIText2,a0
		bsr	Printer
		bra	Terminal1
SetANSIMode1:	lea.l	ANSIText1,a0
		bsr	Printer
		bra	Terminal1

SetSwapBSDEL:	bchg.b	#0,SwapBSDEL
		beq	SetSwapBSDEL1
		lea.l	SwapText2,a0
		bsr	Printer
		bra	Terminal1
SetSwapBSDEL1:	lea.l	SwapText1,a0
		bsr	Printer
		bra	Terminal1

SetCRTrans:	lea.l	CRTransText1,a0
		bsr	Printer
		lea.l	CRTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Terminal1
		move.b	d0,CRTranslate
		bra	Terminal1

SetLFTrans:	lea.l	LFTransText1,a0
		bsr	Printer
		lea.l	LFTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Terminal1
		move.b	d0,LFTranslate
		bra	Terminal1

SetCRTransIn:	lea.l	CRTransText3,a0
		bsr	Printer
		lea.l	CRTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Terminal1
		move.b	d0,CRTranslateIn
		bra	Terminal1

SetLFTransIn:	lea.l	LFTransText3,a0
		bsr	Printer
		lea.l	LFTransText2,a0
		bsr	Printer
		bsr	GetNSA
		cmp.l	#-1,d0
		beq	Terminal1
		move.b	d0,LFTranslateIn
		bra	Terminal1

SetLocalEcho:	bchg.b	#0,LocalEcho
		beq	SetLocalEcho1
		lea.l	EchoText2,a0
		bsr	Printer
		bra	Terminal1
SetLocalEcho1:	lea.l	EchoText1,a0
		bsr	Printer
		bra	Terminal1

SetSpeed:	lea.l	SpeedText11,a0
		bsr	Printer
SetSpeed1:	bsr	DoANSI
		lea.l	SpeedText1,a0
		bsr	Printer
SetSpeed2:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	Prefs1
		cmp.l	#'a',d0
		bcs	SetSpeed3
		cmp.l	#'z',d0
		bhi	SetSpeed3
		sub.l	#32,d0
SetSpeed3:	move.l	Speed,d7	;get real speed if fail later
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
		cmp.l	#'D',d0
		beq	SetDataBits
		cmp.l	#'S',d0
		beq	SetStopBits
		cmp.l	#'N',d0
		beq	SetDevice
		cmp.l	#'R',d0
		beq	ReOpenDevice
		cmp.l	#'X',d0
		beq	SetXONXOFF
		cmp.l	#'C',d0
		beq	SetCTSRTS
		cmp.l	#'E',d0
		beq	Exit1
		cmp.l	#'M',d0
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
DoSpeed_OUT:	lea.l	SpeedText13,a0
		bsr	Printer

		bsr	SetSerParams
		tst.l	d0
		beq	DoSpeed_OUT1

		lea.l	SpeedText12,a0
		bsr	Printer
		move.l	d7,Speed
DoSpeed_OUT1:	bra	SetSpeed1		;OPTI

SetDevice:	lea.l	NameText1,a0
		bsr	Printer

		lea.l	NameText2,a0
		bsr	Printer

		lea.l	SerDevNBuffer1,a0
		move.l	#32,d3
		bsr	GetString
		tst.l	d0
		bne	SetSpeed1

		lea.l	NameText3,a0
		bsr	Printer

		lea.l	DialBuffer1,a0
		move.l	#12,d3
		bsr	GetString
		tst.l	d0
		bne	SetSpeed1

		lea.l	DialBuffer1,a0
		bsr	ConvASCII
		move.l	d0,SerUnit

		lea.l	CRLFText1,a0
		bsr	Printer

		bsr	CloseSerial
		bsr	OpenSerial

		bsr	SetSerParams
		tst.l	d0
		beq	SetDevice1
		bsr	ParamsNotSet

SetDevice1:	bra	SetSpeed1

ReOpenDevice:	lea.l	ReOpenText1,a0
		bsr	Printer
		bsr	CloseSerial
		bsr	OpenSerial
		bsr	SetSerParams
		tst.l	d0
		beq	ReOpenDevice1
		bsr	ParamsNotSet
ReOpenDevice1:	bra	SetSpeed1

SetDataBits:	move.b	DataBits,d7
SetDataBits0.1:	cmp.b	#7,DataBits
		beq	SetDataBits1
		move.b	#7,DataBits
		lea.l	DBitsText1,a0
		bsr	Printer
		bra	SetDataBits2
SetDataBits1:	move.b	#8,DataBits
		lea.l	DBitsText2,a0
		bsr	Printer
		bra	SetSpeed1
SetDataBits2:	bsr	SetSerParams
		tst.l	d0
		beq	SetSpeed1
		move.b	d7,DataBits
		lea.l	DBitsText3,a0
		bsr	Printer
		bra	SetSpeed1

SetStopBits:	move.b	StopBits,d7
SetStopBits0.1:	cmp.b	#1,StopBits
		beq	SetStopBits1
		move.b	#1,StopBits
		lea.l	SBitsText1,a0
		bsr	Printer
		bra	SetStopBits2
SetStopBits1:	move.b	#2,StopBits
		lea.l	SBitsText2,a0
		bsr	Printer
		bra	SetSpeed1
SetStopBits2:	bsr	SetSerParams
		tst.l	d0
		beq	SetSpeed1
		move.b	d7,StopBits
		lea.l	SBitsText3,a0
		bsr	Printer
		bra	SetSpeed1

SetXONXOFF:	bchg.b	#0,XONXOFF
		beq	SetXONXOFF1
		lea.l	XXText2,a0
		bsr	Printer
		bsr	SetSerParams
		tst.l	d0
		bne	SetXONXOFF2
		bra	SetSpeed1
SetXONXOFF1:	lea.l	XXText1,a0
		bsr	Printer
		bsr	SetSerParams
		tst.l	d0
		beq	SetSpeed1
SetXONXOFF2:	lea.l	XXText3,a0
		bsr	Printer
		bra	SetSpeed1

SetCTSRTS:	bchg.b	#0,CTSRTS
		beq	SetCTSRTS1
		lea.l	CTSRTSText2,a0			;Off
		bsr	Printer
		bra	SetCTSRTS2
SetCTSRTS1:	lea.l	CTSRTSText1,a0			;On
		bsr	Printer
SetCTSRTS2:	bsr	CloseSerial
		bsr	OpenSerial
		bsr	SetSerParams
		tst.l	d0
		beq	SetCTSRTS3
		lea.l	CTSRTSText3,a0
		bsr	Printer
SetCTSRTS3:	bra	SetSpeed1



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
		move.b	#'C',d0
		move.b	#'O',d1
		lea.l	Buffer3,a0
		bsr	FindWord
		bne	DialEntry_OUT1
		move.b	#'B',d0
		move.b	#'U',d1
		lea.l	Buffer3,a0
		bsr	FindWord
		bne	DialEntry4
		move.b	#'N',d1
		move.b	#'O',d1
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
		move.l	#50+25,d1
		lib	Dos,Delay
		pull	d2-d7/a2-a6
		move.l	#1,d0
		rts
DialEntry_OUT1:	move.l	#BUFLEN,d0		;try to read extra stuff
		move.l	#1,d1
		bsr	Read
;		lea.l	ConnectText1,a0
;		bsr	Printer
		pull	d2-d7/a2-a6
		clr.l	d0
		rts
DialEntry_OUT2:	lea.l	CRLFText1,a1
		bsr	GetLength
		lea.l	CRLFText1,a0
		bsr	Writer2
		lea.l	SkippedText1,a0
		bsr	Printer
		move.l	#50+25,d1
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
		move.l	#50+25,d1
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

ClearSer:	tst.w	SerOpen
		beq	ClearSer_OUT
		move.l	IORRequest,a1
		ABORTIO
		move.l	IORRequest,a1
		lib	Exec,WaitIO
ClearSer_OUT:	rts

;Buffered read from a device
;
;Inputs d0 = Buffer length (maximum amount to read)
;	d1 = Minimum amout to read
;
;Result d0 = Amount actually read
;

Read:		push	d2-d7/a2-a6

		tst.w	SerOpen
		beq	Read_OUT1

		move.l	d0,d4
		move.l	d1,d5

                move.l  IOQRequest,a1                   ;get amount of bytes
		move.w	#SDCMD_QUERY,IO_COMMAND(a1)	;in buffer
;		or.b	#IOF_QUICK,IO_FLAGS(a1)
		lib	Exec,DoIO

                move.l  IOQRequest,a1
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

		move.l	IORRequest,a1
		move.l	IO_ACTUAL(a1),d0	;even on an error we return
		add.l	d0,Received		;correct amount in buffer
		pull	d2-d7/a2-a6
		rts

Read_OUT1:	clr.l	d0
		pull	d2-d7/a2-a6
		rts

Writer:		tst.w	SerOpen
		beq	Writer1.1
		add.l	#1,Sent
		move.l	IOWRequest,a1
		move.l	#1,IO_LENGTH(a1)		;writes in one byte "chunks"
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		lea.l	Buffer1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO		;May freeze, too bad
Writer1.1:	rts

;Writes string to serial port
;
;D0 = Length
;A0 = String

Writer2:	tst.w	SerOpen
		beq	Writer2.1
		add.l	d0,Sent
		move.l	IOWRequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	d0,IO_LENGTH(a1)
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO		;May freeze, too bad
Writer2.1:	rts

DoCapture:	move.l	CaptureFile,d1
		beq	DoCapture_OUT
		lea.l	Buffer4,a1
		bsr	GetLength
		move.l	d0,d3
		lea.l	Buffer4,a0
		move.l	a0,d2
		lib	Dos,Write
DoCapture_OUT:	rts

SetSerParams:	tst.w	SerOpen
		beq	SSerParams_OUT

		move.l	IOSRequest,a1
		move.w	#SDCMD_SETPARAMS,IO_COMMAND(a1)
		clr.l	IO_EXTFLAGS(a1)
		clr.l	d4
		clr.l	d5
		and.b	#~SERF_XDISABLED,IO_SERFLAGS(a1)
		tst.b	XONXOFF
		bne	SetSerParams1			;Is this wrong?
		or.b	#SERF_XDISABLED,IO_SERFLAGS(a1)
		move.l	#$DEADBEEF,d4
SetSerParams1:	move.l	Speed,IO_BAUD(a1)
		move.b	DataBits,IO_READLEN(a1)
		move.b	DataBits,IO_WRITELEN(a1)
		move.b	StopBits,IO_STOPBITS(a1)
		lib	Exec,DoIO
		move.l	IOSRequest,a1
		clr.l	d0
		move.b	IO_ERROR(a1),d0
		cmp.l	#SerErr_DevBusy,d0
		beq	SetSerParams2
		rts
SetSerParams2:	cmp.l	#$DEADBEEF,d4		;If we set XON/XOFF and
		beq	SSerParams_OUT		;got error then clear it
		rts
SSerParams_OUT:	clr.l	d0
		rts

SendBREAK:	tst.w	SerOpen
		beq	SendBreak_OUT
		move.l	IOWRequest,a1
		move.w	#SDCMD_BREAK,IO_COMMAND(a1)
		or.b	#IOF_QUICK,IO_FLAGS(a1)
		lib	Exec,DoIO
SendBreak_OUT:	rts

DoCLIInput:	lea.l	Buffer1,a0
		cmp.b	#CR,Buffer1
		beq	DoCLIInput3
		cmp.b	#LF,Buffer1
		beq	DoCLIInput4
		cmp.b	#BS,Buffer1
		beq	DoCLIInput5
		cmp.b	#DEL,Buffer1
		beq	DoCLIInput6
		cmp.b	#CSI,Buffer1
		beq	DoCSI
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
DoCLIInput5:	tst.b	SwapBSDEL
		beq	DoCLIInput1
		move.b	#DEL,Buffer1
		bra	DoCLIInput1
DoCLIInput6:	tst.b	SwapBSDEL
		beq	DoCLIInput1
		move.b	#BS,Buffer1
		bra	DoCLIInput1

DoCSI:		tst.b	CursorRemap
		beq	DoCSI_OUT
		move.l	_stdin,d1
		lea.l	Buffer1,a0
		move.l	a0,d2
		move.l	#1,d3
		lib	Dos,Read
		cmp.b	#Cursor_Up,Buffer1
		beq	DoCSI1
		cmp.b	#Cursor_Down,Buffer1
		beq	DoCSI2
		cmp.b	#Cursor_Left,Buffer1
		beq	DoCSI3
		cmp.b	#Cursor_Right,Buffer1
		beq	DoCSI4
		bra	DoCLIInput1
DoCSI1:		move.b	#CTRL_P,Buffer1
		bra	DoCLIInput1
DoCSI2:		move.b	#CTRL_N,Buffer1
		bra	DoCLIInput1
DoCSI3:		move.b	#CTRL_B,Buffer1
		bra	DoCLIInput1
DoCSI4:		move.b	#CTRL_F,Buffer1
DoCSI_OUT:	bra	DoCLIInput1

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

;Gets a string from the user, null terminated
;
;Inputs	a0 = pointer to buffer
;	d3 = length of buffer
;
;Result	d0 = -1 if failed
;

GetString:	push	a0
		push	a0
		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode

		move.l	_stdin,d1
		lib	Dos,Flush

		move.l	_stdin,d1
		pull	d2
		lib	Dos,FGets
		tst.l	d0
		beq	GetString_OUT2

		pull	a0
		bsr	GetLLength
		clr.b	-1(a0,d1.l)	;remove LF

		move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		move.l	_stdin,d1
		lib	Dos,Flush

		clr.l	d0
		rts

GetString_OUT2:	move.l	#-1,d0
		rts

;Gets input from user
;
;Results d0 = 0 for N, 1 for S, 2 for A, -1 for error

GetNSA:		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	GetNSA_ERR1
		cmp.l	#'a',d0
		bcs	GetNSA0.1
		cmp.l	#'z',d0
		bhi	GetNSA0.1
		sub.l	#32,d0
GetNSA0.1:	cmp.l	#'N',d0
		beq	GetNSA1
		cmp.l	#'S',d0
		beq	GetNSA2
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

GiveSettings:	clr.l	SpeedText90
		clr.l	SpeedText90+4
		clr.l	SpeedText90+8
		lea.l	fstrl3,a0		;HEX->ASCII
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

		lea.l	CurrentText9.01,a0
		bsr	Printer

		tst.b	XONXOFF
		bne	GiveSettings6.1
		bsr	Nope
		bra	GiveSettings6.2
GiveSettings6.1: bsr	Yep

GiveSettings6.2: lea.l	CurrentText9.02,a0
		bsr	Printer

		tst.b	CTSRTS
		bne	GiveSettings6.3
		bsr	Nope
		bra	GiveSettings6.4
GiveSettings6.3: bsr	Yep

GiveSettings6.4: lea.l	CurrentText7,a0
		bsr	Printer

		lea.l	CurrentText9.1,a0
		bsr	Printer

		tst.b	SwapBSDEL
		bne	GiveSettings7
		bsr	Nope
		bra	GiveSettings8
GiveSettings7:	bsr	Yep

GiveSettings8:	lea.l	CurrentText9.11,a0
		bsr	Printer

		tst.b	UseANSI
		bne	GiveSettings9
		bsr	Nope
		bra	GiveSettings10
GiveSettings9:	bsr	Yep

GiveSettings10:	lea.l	CurrentText7,a0
		bsr	Printer

		lea.l	CurrentText9.12,a0
		bsr	Printer

		tst.b	CursorRemap
		bne	GiveSettings11
		bsr	Nope
		bra	GiveSettings12
GiveSettings11:	bsr	Yep

GiveSettings12:	lea.l	CurrentText7,a0
		bsr	Printer

		lea.l	CurrentText9.2,a0
		bsr	Printer

		clr.w	CPAssignText
		clr.l	CTRLPASCII
		move.b	CPAssign,CPAssignText+1
		lea.l	fstrl4,a0		;HEX->ASCII
		lea.l	CPAssignText,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	CTRLPASCII,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	CTRLPASCII,a0
		bsr	Printer

		lea.l	CRLFText1,a0
		bsr	Printer

		lea.l	CurrentText9.3,a0
		bsr	Printer

		lea.l	ULProgram,a0
		bsr	Printer

		lea.l	CurrentText9.4,a0
		bsr	Printer

		lea.l	DLProgram,a0
		bsr	Printer

		lea.l	CurrentText9.5,a0
		bsr	Printer

		lea.l	ULDir,a0
		bsr	Printer

		lea.l	CurrentText9.6,a0
		bsr	Printer

		lea.l	DLDir,a0
		bsr	Printer

		lea.l	CRLFText1,a0
		bsr	Printer

		lea.l	CurrentText10,a0
		bsr	Printer

		lea.l	SerDevNBuffer1,a0
		bsr	Printer

		lea.l	CurrentText11,a0
		bsr	Printer

		lea.l	fstrl3,a0		;HEX->ASCII
		lea.l	SerUnit,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	CurrentText12,a3	;Destination
		lib	Exec,RawDoFmt

		lea.l	CurrentText12,a0
		bsr	Printer

		lea.l	CurrentText13,a0
		bsr	Printer

		lea.l	FileNameBuf1,a0
		bsr	Printer

		lea.l	CRLFText1,a0
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

LoadPrefsFile:	move.l	CLArray1,d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PrefsFile
		bne	LoadPrefsFile1

		lea.l	FileErrorText1,a0
		bsr	Printer
		move.l	CLArray1,a0
;		lea.l	FileNameBuf1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bra	LoadPF_ERR1

LoadPrefsFile1:	move.l	PrefsFile,d1
		lea.l	PrefsStart,a0
		move.l	a0,d2
		move.l	#4,d3
		lib	Dos,Read
		cmp.l	#4,d0
		beq	LoadPrefsFile2

		lea.l	FileErrorText2,a0
		bsr	Printer
		bra	LoadPF_ERR1

LoadPrefsFile2: cmp.l	#STFileVersion,PrefsStart
		beq	LoadPrefsFile3

		lea.l	FileErrorText3,a0
		bsr	Printer
		bra	LoadPF_ERR1

LoadPrefsFile3:	move.l	PrefsFile,d1
		lea.l	SerDevNBuffer1,a0
		move.l	a0,d2
		move.l	#PrefsSize-4,d3
		lib	Dos,Read
		cmp.l	#PrefsSize-4,d0
		beq	LoadPrefsFile4

		lea.l	FileErrorText2,a0
		bsr	Printer
		bra	LoadPF_ERR2

LoadPrefsFile4:
LoadPF_OUT:	bsr	KillPFile
		move.l	#-1,d0
		rts
LoadPF_ERR1:	bsr	KillPFile
		clr.l	d0
		rts
LoadPF_ERR2:	bsr	KillPFile
		clr.l	d0
		rts

SavePrefsFile:	lea.l	FileNameBuf1,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,PrefsFile
		bne	SavePrefsFile1

		lea.l	FileErrorText1,a0
		bsr	Printer
		lea.l	FileNameBuf1,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		bra	SavePF_ERR1

SavePrefsFile1:	move.l	#STFileVersion,PrefsStart

		move.l	PrefsFile,d1
		lea.l	PrefsStart,a0
		move.l	a0,d2
		move.l	#PrefsSize,d3
		lib	Dos,Write
		cmp.l	#PrefsSize,d0
		beq	SavePF_OUT

		lea.l	FileErrorText4,a0
		bsr	Printer
		bra	SavePF_ERR2

SavePF_OUT:	bsr	KillPFile
		move.l	#-1,d0
		rts
SavePF_ERR1:	clr.l	d0
		rts
SavePF_ERR2:	bsr	KillPFile
		clr.l	d0
		rts

;Create MsgPorts & IOReqs for serial.device (or for other device)

CreateReqs:	tst.w	SerOpen
		bne	CreateReqs_OUT		;If open!!
		lib	Exec,CreateMsgPort
		move.l	d0,SRRPort
		beq	NoMsgPort2

;Add port to public lists

		move.l	SRRPort,a1
		lea.l	RPortText1,a0
		move.l	a0,LN_NAME(a1)
		lib	Exec,AddPort

;Create write reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SWRPort
		beq	NoMsgPort2

;Add port to public lists

		move.l	SWRPort,a1
		lea.l	WPortText1,a0
		move.l	a0,LN_NAME(a1)
		lib	Exec,AddPort

;Create SetSerParams reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SSRPort
		beq	NoMsgPort2

;Create requester for QUERY

                lib     Exec,CreateMsgPort
                move.l  d0,SQRPort
                beq     NoMsgPort2

;Create the requests themselves

		move.l	#IOEXTSER_SIZE,d0	;Read IOReq
		move.l	SRRPort,a0
		clr.b	LN_TYPE(a0)		;Make sure CheckIO doesn't hang
		lib	Exec,CreateIORequest
		move.l	d0,IORRequest
		beq	NoIOReq

		move.l	#IOEXTSER_SIZE,d0	;Write IOReq
		move.l	SWRPort,a0
		clr.b	LN_TYPE(a0)		;Make sure CheckIO doesn't hang
		lib	Exec,CreateIORequest
		move.l	d0,IOWRequest
		beq	NoIOReq

		move.l	#IOEXTSER_SIZE,d0	;SetParams IOReq
		move.l	SSRPort,a0
		clr.b	LN_TYPE(a0)		;Make sure CheckIO doesn't hang
		lib	Exec,CreateIORequest
		move.l	d0,IOSRequest
		beq	NoIOReq

                move.l  #IOEXTSER_SIZE,d0       ;QUERY IOReq
                move.l  SQRPort,a0
		clr.b	LN_TYPE(a0)		;Make sure CheckIO doesn't hang
                lib     Exec,CreateIORequest
                move.l  d0,IOQRequest
                beq     NoIOReq

		move.l	#1,d0			;No error
		rts
CreateReqs_OUT:	clr.l	d0			;Error
		rts

DeleteReqs:	move.l	IORRequest,a0
		lib	Exec,DeleteIORequest		;Delete RReq
		clr.l	IORRequest

		move.l	IOWRequest,a0
                lib     Exec,DeleteIORequest            ;Delete WRReq
		clr.l	IOWRequest

		move.l	IOSRequest,a0
                lib     Exec,DeleteIORequest            ;Delete SRReq
		clr.l	IOSRequest

                move.l  IOQRequest,a0
                lib     Exec,DeleteIORequest            ;Delete QRReq
                clr.l   IOQRequest

		move.l	SRRPort,a1			;Remove possible
		cmp.l	#$00,a1				;ports from lists
		beq	DeleteReqs2			;and then delete
		lib	Exec,RemPort			;the ports

		move.l	SRRPort,a0
		lib	Exec,DeleteMsgPort
		clr.l	SRRPort

DeleteReqs2:	move.l	SWRPort,a1
		cmp.l	#$00,a1
		beq	DeleteReqs3
		lib	Exec,RemPort

		move.l	SWRPort,a0
		lib	Exec,DeleteMsgPort
		clr.l	SWRPort

		move.l	SSRPort,a0
		lib	Exec,DeleteMsgPort
		clr.l	SSRPort

                move.l  SQRPort,a0
                lib     Exec,DeleteMsgPort
                clr.l   SQRPort

DeleteReqs3:	rts

KillPFile:	move.l	PrefsFile,d1
		beq	KillPFile1
		lib	Dos,Close
		clr.l	PrefsFile
KillPFile1:	rts

ShutDown:	bsr	CloseSerial

ShutDown9000:

ShutDown8900:	bsr	DeleteReqs

ShutDown8800:
		move.l	_stdin,d1
		beq	ShutDown8700
		move.l	#FALSE,d2
		lib	Dos,SetMode

ShutDown8700:	move.l	OptPort,a1
		cmp.l	#$00,a1
		beq	ShutDown8600
		lib	Exec,RemPort

ShutDown8600:	move.l	OptPort,a0
		lib	Exec,DeleteMsgPort

ShutDown8000:	bsr	KillPFile

		move.l	CaptureFile,d1
		beq	ShutDown7000
		lib	Dos,Close
ShutDown7000:	move.l	RDArgs1,d1
		beq	ShutDown6900
		lib	Dos,FreeArgs
ShutDown6900:

ShutDown1000:	closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;open serial.device

OpenSerial:	bsr	DeleteReqs
		bsr	CreateReqs
		tst.w	SerOpen
		bne	OpenSerial_OUT
		lea.l	SerDevNBuffer1,a0
		move.l	SerUnit,d0
		move.l	IORRequest,a1
		or.b	#SERF_SHARED,IO_SERFLAGS(a1)	;used to be move
		or.b	#SERF_7WIRE,IO_SERFLAGS(a1)
		tst.b	CTSRTS
		beq	OpenSerial2
		or.b	#SERF_7WIRE,IO_SERFLAGS(a1)
OpenSerial2:	clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	NoSerial
		move.w	#$1,SerOpen		;just to tell if open

;Copy info from one req to the other

		move.l	IORRequest,a0

		move.l	IOWRequest,a1			;for Write request
		move.l	IO_DEVICE(a0),IO_DEVICE(a1)
		move.l	IO_UNIT(a0),IO_UNIT(a1)

		add.l	#48,a0			;get start of ioser
		add.l	#48,a1
		move.l	#34,d0
		lib	Exec,CopyMem

		move.l	IORRequest,a0
		move.l	IOSRequest,a1			;for SetParams request
		move.l	IO_DEVICE(a0),IO_DEVICE(a1)
		move.l	IO_UNIT(a0),IO_UNIT(a1)

		add.l	#48,a0			;get start of ioser
		add.l	#48,a1
		move.l	#34,d0
		lib	Exec,CopyMem

                move.l  IORRequest,a0
                move.l  IOQRequest,a1                   ;for QUERY request
                move.l  IO_DEVICE(a0),IO_DEVICE(a1)
                move.l  IO_UNIT(a0),IO_UNIT(a1)

;		add.l   #48,a0                  ;get start of ioser
;		add.l   #48,a1
;		move.l  #34,d0
;		lib     Exec,CopyMem

                move.l  IORRequest,a1
		move.w	#CMD_READ,IO_COMMAND(a1)
		or.b	#IOF_QUICK,IO_FLAGS(a1)
		lea.l	Buffer3,a0
		move.l	a0,IO_DATA(a1)
		move.l	#1,IO_LENGTH(a1)

		move.l	#BUFLEN,d0	;just so the request is used
		move.l	#0,d1		;TRY: #1
		bsr	Read

		clr.l	d0
		rts
OpenSerial_OUT:	move.l	#-1,d0
		rts

CloseSerial:	tst.w	SerOpen
		beq	CloseSerial1
		bsr	ClearSer
		move.l	IORRequest,a1
		lib	Exec,CloseDevice

		bsr	DeleteReqs

		clr.w	SerOpen
CloseSerial1:	rts

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

;Finds a string in another string
;
;Inputs	a0 = Pointer to string1 (from what to find)
;	d0 = Lower byte ('C' out of 'CO') (what to search for)
;	d1 = Higher byte ('O' out of 'CO')
;
;Result	d0 = 0 if not found
;
;BUGS

FindWord:	tst.b	(a0)
		beq	FindWord1
		cmp.b	(a0),d0
		beq	FindWord2
		add.l	#1,a0
		bra	FindWord
FindWord1:	clr.l	d0		;keep right before rts
		rts
FindWord2:	add.l	#1,a0
		tst.b	(a0)
		beq	FindWord1
		cmp.b	(a0),d1
		bne	FindWord2
		move.l	#-1,d0		;keep right before rts
		rts

;Input a0 = Address of text string
;
;Result d0 = Length

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
		push	d1/a0
		move.l	#10,d1
		lib	Utility,UMult32
		pull	d1/a0
		add.l	d1,d0
		add.l	#1,a0
		bra	ConvASCII2
ConvASCII_OUT:	rts

MakeCmdString:	lea.l	FileNameBuf3,a0
		lea.l	ULProgram,a4
		move.l	a4,a5
		add.l	#128,a5
		bsr	MCS1

		move.b	#' ',(a0)+

		lea.l	FileNameBuf2,a4
		move.l	a4,a5
		add.l	#128,a5
		bsr	MCS1

;		lea.l	FileNameBuf3,a0		;DEBUG
;		bsr	Printer			;DEBUG
		rts

MCS1:		move.b	(a4)+,(a0)+
		tst.b	(a4)
		beq	MCS2
		cmp.l	a4,a5
		bne	MCS1
MCS2:		rts

;Error etc. messages

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

NoUtility:	lea.l	NoUtiText1,a0
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

NoMsgPort2:	lea.l	NoMsgPortText1,a0
		bsr	Printer
		clr.l	d0
		rts

NoIOReq:	lea.l	NoIOReqText1,a0		;WARNING: DIFFERENT!
		bsr	Printer
		clr.l	d0
		rts

NoSerial:	lea.l	NoSerialText1,a0
		bsr	Printer
		lea.l	SerDevNBuffer1,a0
		bsr	Printer
		lea.l	NoSerialText2,a0
		bsr	Printer
		move.l	IORRequest,a1
		move.b	IO_ERROR(a1),d0
		move.b	d0,ErrorNum+1
		bsr	PrintErrorNum
		lea.l	CRLFText1,a0
		bsr	Printer
		move.l	#-1,d0
		rts

ParamsNotSet:	lea.l	SerSetText1,a0
		bsr	Printer
		rts

Printer:	printa	a0,_stdout
		rts

PrintErrorNum:	clr.l	ErrorNumText2
		clr.w	ErrorNumText2+4
		lea.l	fstrl5,a0		;HEX->ASCII
		lea.l	ErrorNum,a1		;Number2Print
		lea.l	PutChProc,a2
		lea.l	ErrorNumText2,a3		;Destination
		lib	Exec,RawDoFmt

		lea.l	ErrorNumText,a0
		bsr	Printer
		lea.l	ErrorNumText2,a0
		bsr	Printer
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Structures

;lib stuff

		libnames

;Other stuff, part I

SRRPort:	dc.l	0
IORRequest:	dc.l	0
SWRPort:	dc.l	0
IOWRequest:	dc.l	0
SSRPort:	dc.l	0
IOSRequest:	dc.l	0
SQRPort:	dc.l	0
IOQRequest:	dc.l	0
OptPort:	dc.l	0
_stdout:	dc.l	0
_stdin:		dc.l	0
Sent:		dc.l	0			;Count sent chars
Received:	dc.l	0			;Count reveived chars
PrefsFile:	dc.l	0
RDArgs1:	dc.l	0
CLArray1:	dc.l	FileNameBuf1		;Pointer to filename
OptPortName:	dc.l	0			;Pointer to optional portname

;Other stuff part II

OldLock:	dc.l	0		;dir we started from
ULLock:		dc.l	0		;uload dir
DLLock:		dc.l	0		;dload dir
CaptureFile:	dc.l	0		;Capture everything here..

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
ModifyMode:	dc.w	0	;0=No, 1=Yes
CPAssignText:	dc.w	0

;Serial device stuff

SerOpen:	dc.w	0
ErrorNum:	dc.w	0

;Strings, error

BreakText1:	dc.b	"***Break",13,10,0
NotIntText1:	dc.b	"ERROR: Please don't redirect input!",13,10,0
NoUtiText1:	dc.b	"ERROR: Couldn't open utility.library!",13,10,0
NoMsgPortText1:	dc.b	"ERROR: Couldn't get message port!",13,10,0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSerialText1:	dc.b	"ERROR: Device '",0
NoSerialText2:	dc.b	"' not open!",13,10,0
FileErrorText1:	dc.b	13,10,"ERROR: Couldn't open file: ",0
FileErrorText2:	dc.b	"ERROR: Couldn't read file!",13,10,0
FileErrorText3:	dc.b	"ERROR: Incorrect filetype!",13,10,0
FileErrorText4:	dc.b	"ERROR: Couldn't write to file!",13,10,0
NoULDLProgText1: dc.b	13,10,"ERROR: No transfer program specified!",13,10,0
NoULDirText1:	dc.b	13,10,"ERROR: Couldn't access upload directory!",13,10,0
NoDLDirText1:	dc.b	13,10,"ERROR: Couldn't access download directory!",13,10,0
CaptureErrorText1:	dc.b	13,10,"ERROR: Couldn't open capture!",13,10,0
CaptureErrorText2:	dc.b	13,10,"ERROR: Capture already open!",13,10,0
ErrorNumText:	dc.b	"Error number: ",0
fstrl5:		dc.b	"%d"
		ds.w	0
ErrorNumText2:	dc.b	0,0,0,0,0,0

;Strings

StartText1:	dc.b	"Welcome to ShellTerm. Use CTRL-P to get menu.",13,10,0
		ds.l	0
RPortText1:	dc.b	"ShellTerm_RPort",0
WPortText1:	dc.b	"ShellTerm_WPort",0

;Main menu

MenuText1:	dc.b	13,10,"ShellTerm menu. Please choose item:",13,10
		dc.b	13,10,"(S) Statistics      (C) Clear statistics"
		dc.b	13,10,"(B) Send BREAK      (O) Send CTRL-P"
		dc.b	13,10,"(F) Reset font      (X) Clear screen"
		dc.b	13,10,"(R) Reset modem     (H) Hangup line"
		dc.b	13,10,"(+) Upload          (-) Download"
		dc.b	13,10,"(D) Dialer          (P) Preferences"
		dc.b	13,10,"(L) Open capture    (K) Close capture"
		dc.b	13,10,"(M) Execute command (?) Information",13,10
		dc.b	13,10,"(Q) Quit ShellTerm  (E) Exit menus",13,10
		dc.b	13,10,"Selection: ",0
ExecuteText1:	dc.b	"Execute",13,10
		dc.b	"Command to execute: ",0
InfoText1:	dc.b	"Information",13,10,0
BreakText2:	dc.b	"Break sent",13,10,0
CTRL_PText1:	dc.b	"CTRL-P sent",13,10,0
ExitText1:	dc.b	"Exit",13,10,0
TerminalText1:	dc.b	13,10,"Terminal mode active:",13,10,0
ResetFText1:	dc.b	"Reset font",13,10,0
QuitText1:	dc.b	"Quit",13,10,0
StatsText1:	dc.b	"Statistics:",13,10,0
StatsText2:	dc.b	"Statistics",13,10,13,10,0
DialerText1:	dc.b	"Dialer",13,10,0
PrefsText1:	dc.b	"Preferences",13,10,0
ULText1:	dc.b	"Upload program (SZ)",13,10
		dc.b	"Program name: ",0
ULText2:	dc.b	"Upload file",13,10
		dc.b	"File to upload: ",0
ULText3:	dc.b	"Uploading file, please wait...",13,10,0
ULText5:	dc.b	"Upload dir",13,10
		dc.b	"Directory: ",0
DLText1:	dc.b	"Download program (RZ)",13,10
		dc.b	"Program name: ",0
DLText2:	dc.b	"Downloading file, please wait...",13,10,0
DLText5:	dc.b	"Download dir",13,10
		dc.b	"Directory: ",0
OpenCaptureText1: dc.b	"Open capture",13,10
		dc.b	"Name of file: ",0
CloseCaptureText1: dc.b	"Close capture",13,10,0

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
PlainText1:	dc.b	$9b,$30,$6d,$1b,$63
ClearSText1:	dc.b	$1B,$5B,$30,$3B,$30,$48,$1B,$5B,$4A,0

;Preferences

PrefsText2:	dc.b	13,10,"ShellTerm preferences:",13,10
		dc.b	13,10,"(S)erial settings  (T)erminal settings"
		dc.b	13,10,"(R)eset settings   (V)iew settings"
		dc.b	13,10,"(L)oad prefs       (W)rite prefs"
		dc.b	13,10,"(N)ame prefsfile   (A)ssign CTRL-P"
		dc.b	13,10,"(+) Upload program (-) Download program"
		dc.b	13,10,"(U)pload dir       (D)ownload dir",13,10
		dc.b	13,10,"(M)ain menu        (E)xit menus",13,10
		dc.b	13,10,"Selection: ",0
ViewText1:	dc.b	"View settings",13,10,0
SpeedText11:	dc.b	"Serial settings",13,10,0
SpeedText13:	dc.b	"Speed",13,10,0
STerminalText1:	dc.b	"Terminal settings",13,10,0
LoadText1:	dc.b	"Load prefs",13,10,0
SaveText1:	dc.b	"Write prefs",13,10,0
AssignText1:	dc.b	"Assign CTRL-P",13,10,0
AssignText2:	dc.b	13,10,"Press key to assign CTRL-P to: ",0
EnterNText1:	dc.b	"Enter name",13,10,0
EnterNText2:	dc.b	13,10,"File name: ",0
DBitsText1:	dc.b	"Using 7 databits",13,10,0
DBitsText2:	dc.b	"Using 8 databits",13,10,0
DBitsText3:	dc.b	13,10,"ERROR: Couldn't set databits!",13,10,0
SBitsText1:	dc.b	"Using 1 stopbit",13,10,0
SBitsText2:	dc.b	"Using 2 stopbits",13,10,0
SBitsText3:	dc.b	13,10,"ERROR: Couldn't set stopbits!",13,10,0
XXText1:	dc.b	"XON/XOFF is on",13,10,0
XXText2:	dc.b	"XON/XOFF is off",13,10,0
XXText3:	dc.b	13,10,"ERROR: Couldn't set XON/XOFF!",13,10,0
CTSRTSText1:	dc.b	"CTS/RTS handshaking is on",13,10,0
CTSRTSText2:	dc.b	"CTS/RTS handshaking is off",13,10,0
CTSRTSText3:	dc.b	13,10,"ERROR: Couldn't set CTS/RTS!",13,10,0
CRTransText2:	dc.b	13,10,"(N)one, (S)trip, (A)dd LF: ",0
LFTransText2:	dc.b	13,10,"(N)one, (S)trip, (A)dd CR: ",0
AnyKeyText1:	dc.b	13,10,"Please press any key: ",0
NoneText1:	dc.b	"None",13,10,0
StripText1:	dc.b	"Strip",13,10,0
AddText1:	dc.b	"Add",13,10,0

STerminalText2:	dc.b	13,10,"Terminal settings:",13,10
		dc.b	13,10,"OUT: (1) CR translate   (2) LF translate"
		dc.b	13,10,"IN:  (3) CR translate   (4) LF translate"
		dc.b	13,10,"     (L)ocal echo       (S)wap DEL & BS"
		dc.b	13,10,"     (A)nsi codes       (C)ursor remap",13,10
		dc.b	13,10,"(M)ain menu   (-) Previous menu   (E)xit menus",13,10
		dc.b	13,10,"Selection: ",0
CRTransText1:	dc.b	"CR translate (OUT)",13,10,0
LFTransText1:	dc.b	"LF translate (OUT)",13,10,0
CRTransText3:	dc.b	"CR translate (IN)",13,10,0
LFTransText3:	dc.b	"LF translate (IN)",13,10,0
EchoText1:	dc.b	"Local echo enabled",13,10,0
EchoText2:	dc.b	"Local echo disabled",13,10,0
SwapText1:	dc.b	"BS & DEL swapping enabled",13,10,0
SwapText2:	dc.b	"BS & DEL swapping disabled",13,10,0
ANSIText1:	dc.b	"ANSI mode on",13,10,0
ANSIText2:	dc.b	"ANSI mode off",13,10,0
CRemapText1:	dc.b	"Cursor remap on",13,10,0
CRemapText2:	dc.b	"Cursor remap off",13,10,0

CurrentText1:	dc.b	13,10,"Current settings: Speed (",0
CurrentText2:	dc.b	"), Local echo (",0
CurrentText3:	dc.b	"                  CR xlate out (",0
CurrentText4:	dc.b	"), LF xlate out (",0
CurrentText5:	dc.b	"                  CR xlate in (",0
CurrentText6:	dc.b	"), LR xlate in (",0
CurrentText7:	dc.b	")",13,10,0
CurrentText8:	dc.b	"                  Databits (",0
CurrentText9:	dc.b	"), Stopbits (",0
CurrentText9.01: dc.b	"                  XON/XOFF (",0
CurrentText9.02: dc.b	"), CTS/RTS (",0
CurrentText9.1:	dc.b	"                  Swap BS & DEL (",0
CurrentText9.11: dc.b	"), ANSI mode (",0
CurrentText9.12: dc.b	"                  Remap cursor keys (",0
CurrentText9.2:	dc.b	13,10,"CTRL-P assigned to ASCII: ",0
CurrentText9.3:	dc.b	13,10,"Upload program  : ",0
CurrentText9.4:	dc.b	13,10,"Download program: ",0
CurrentText9.5:	dc.b	13,10,"Upload dir      : ",0
CurrentText9.6:	dc.b	13,10,"Download dir    : ",0
CurrentText10:	dc.b	13,10,"Device name: ",0
CurrentText11:	dc.b	13,10,"Unit number: ",0
CurrentText12:	dcb.b	14,0
CurrentText13:	dc.b	13,10,"Prefs file : ",0
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
fstrl4:		dc.b	"%d",0

;Speed prefs

SpeedText1:	dc.b	13,10,"Serial settings:",13,10
		dc.b	13,10,"(1) 110 bps     (2) 300 bps"
		dc.b	13,10,"(3) 1200 bps    (4) 2400 bps"
		dc.b	13,10,"(5) 4800 bps    (6) 9600 bps"
		dc.b	13,10,"(7) 19 200 bps  (8) 38 400 bps"
		dc.b	13,10,"(9) 57 600 bps  (0) 115 200 bps"
		dc.b	13,10,"(N)ame & Unit   (R)e-open"
		dc.b	13,10,"(D)atabits      (S)topbits"
		dc.b	13,10,"(X)ON/XOFF      (C)TS/RTS",13,10
		dc.b	13,10,"(M)ain menu   (-) Previous menu   (E)xit menus",13,10
		dc.b	13,10,"Selection: ",0
SpeedText12:	dc.b	13,10,"ERROR: Couldn't set that speed. Please reselect!",13,10,0
SerSetText1:	dc.b	13,10,"ERROR: Couldn't set serial parameters!",13,10,0
fstrl3:		dc.b	"%ld",0
		ds.w	0
CTRLPASCII:	dc.b	0,0,0,0,0,0,0,0
SpeedText90:	dc.b	0,0,0,0,0,0,0,0,0,0,0,0
NameText1:	dc.b	"Set device unit & name",13,10,0
NameText2:	dc.b	13,10,"Device name: ",0
NameText3:	dc.b	13,10,"Unit number: ",0
ReOpenText1:	dc.b	"Re-open device",13,10,0

;Dialer stuff

DialerText2:	dc.b	13,10,"Auto-dialer (phonebook)",13,10
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
DialerText3:	dc.b	13,10,"(0-9) Un/select entry  (R)elist numbers"
		dc.b	13,10,"  (S)ingle dial        (D)ial list"
		dc.b	13,10,"  (C)lear list         (A)ll"
		dc.b	13,10,"Ed(I)t mode            (P)refix",13,10
		dc.b	13,10,"  (M)ain menu          (E)xit menus",13,10
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
ModifyText1:	dc.b	"Edit mode on",13,10,0
ModifyText2:	dc.b	"Edit mode off",13,10,0
EditEntryText1:	dc.b	"Edit entry",13,10,0
EditEntryText2:	dc.b	13,10,"Enter number: ",0
EditEntryText3:	dc.b	"Edit prefix",13,10,0
EditEntryText4:	dc.b	13,10,"Enter prefix: ",0
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

;Strings, names

CLTemplate1:	dc.b	"FROM,PORT/K",0
STVersion:	dc.b	"$VER: ShellTerm "
		PROGVERSION
		dc.b	" (C)opyright Tomi Blinnikka 1993",0
AuthorText1:	dc.b	13,10,"Name          : ShellTerm",13,10
		dc.b	"Version       : "
		PROGVERSION
		dc.b	13,10
		dc.b	"Author        : Tomi Blinnikka",13,10
		dc.b	"NOTICE        : UNREGISTERED VERSION",13,10
;		dc.b	"Registered to : ",13,10
		dc.b	13,10,"(C)opyright Tomi Blinnikka 1993",13,10,0
		ds.l	0

;Buffers

Buffer1:	dcb.b	2,0		;For writes to serial (read from CLI)
Buffer2:	dcb.b	2,0		;For reads
Buffer3:	dcb.b	BUFLEN,0	;For reads from serial
Buffer4:	dcb.b	BUFLEN*2,0	;For writes to CLI

DialBuffer1:	dcb.b	ENTRYLENGTH,0	;for single dial/serial unit number :)

FileNameBuf1:	dc.b	"S:ShellTerm.PREFS"
		dcb.b	128-17,0
FileNameBuf2:	dcb.b	128,0		;File to UL/capture filename
FileNameBuf3:	dcb.b	2*128,0		;CMD string with arguments

PREFS_START:

PrefsStart:	dc.l	STFileVersion
SerDevNBuffer1:	dc.b	"serial.device"
		dcb.b	32-13,0		;device name
SerUnit:	dc.l	0
Speed:		dc.l	9600
LocalEcho:	dc.w	0		;(0=no echo, 1=echo)
CRTranslate:	dc.b	0		;0=none, 1=strip, 2=add LF
LFTranslate:	dc.b	0		;0=none, 1=strip, 2=add CR
CRTranslateIn:	dc.b	0		;0=none, 1=strip, 2=add LF
LFTranslateIn:	dc.b	0		;0=none, 1=strip, 2=add CR
DataBits:	dc.b	8
StopBits:	dc.b	1
XONXOFF:	dc.b	0		;0=No, 1=Yes
CTSRTS:		dc.b	0		;0=No, 1=Yes
Future1:	dc.l	0
Future2:	dc.l	0
Future3:	dc.l	0
Future4:	dc.l	0
SwapBSDEL:	dc.b	0		;1=Yes
UseANSI:	dc.b	0		;1=Yes
CPAssign:	dc.b	0		;key to assign CTRL-P to
CursorRemap:	dc.b	0		;remap cursor keys

ULProgram:	dcb.b	128,0		;SZ
DLProgram:	dcb.b	128,0		;RZ
ULDir:		dcb.b	128,0		;SZ
DLDir:		dcb.b	128,0		;RZ
DialPrefix:	dc.b	"ATDT"		;dial prefix
		dcb.b	16-4,0
Entry1:		dcb.b	ENTRYLENGTH,0	;Entry 1
Entry2:		dcb.b	ENTRYLENGTH,0	;Entry 2
Entry3:		dcb.b	ENTRYLENGTH,0	;Entry 3
Entry4:		dcb.b	ENTRYLENGTH,0	;Entry 4
Entry5:		dcb.b	ENTRYLENGTH,0	;Entry 5
Entry6:		dcb.b	ENTRYLENGTH,0	;Entry 6
Entry7:		dcb.b	ENTRYLENGTH,0	;Entry 7
Entry8:		dcb.b	ENTRYLENGTH,0	;Entry 8
Entry9:		dcb.b	ENTRYLENGTH,0	;Entry 9
Entry10:	dcb.b	ENTRYLENGTH,0	;Entry 10

PREFS_END:	dc.l	0,0

PrefsSize:	EQU	(PREFS_END-PREFS_START)
		end



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
