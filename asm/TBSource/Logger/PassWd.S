*************************************************
*						*
*		(C)opyright 1992-93		*
*						*
*		 by Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 1.00	01/08/1992			*
*						*
* BUGS:	Didn't check for UNUSED			*
*						*
* Version 1.01	08/08/1992			*
*						*
* Added -l option				*
*						*
* BUGS:	RemUser	jumped to AddUser_OUT		*
*						*
* Version 1.02	10/08/1992			*
*						*
* Added -e option				*
*						*
* Version 1.03	14/08/1992			*
*						*
* Added command to start			*
*						*
* Version 1.04	03/02/1993			*
*						*
* Changed parser to CBM ReadArgs		*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"libraries/dos.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"


	XREF	_LVOSetMode

	BITDEF  GV,LOCAL_ONLY,9

TRUE:		EQU	1
FALSE:		EQU	0

		section	PassWd,CODE

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

		move.l	UserPointer,a4
		tst.b	(a4)
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
		beq	ArgMissing
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
		bne	DoCommands

		lib	Dos,IoErr
		cmp.l	#ERROR_OBJECT_NOT_FOUND,d0
		beq	CreatePWFile
		bsr	FileError1
		bra	ShutDown

CreatePWFile:	lea.l	CreatingText1,a0
		bsr	Printer

		lea.l	PassWdFileN,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,PassWdFile
		bne	CreatePWFile2
		bsr	FileError4
		bra	ShutDown
CreatePWFile2:	move.l	#'root',Buffer1
		lea.l	Buffer1,a0
		lea.l	PassWord,a1
		bsr	Encrypt

		bsr	WriteUser
		bsr	SeekStart

DoCommands:	tst.l	OptionAdd
		beq	DoCommands1
		bsr	AddUser
DoCommands1:	tst.l	OptionRemove
		beq	DoCommands2
		bsr	RemUser
DoCommands2:	tst.l	OptionList
		beq	DoCommands3
		bsr	ListUsers
DoCommands3:	tst.l	OptionEdit
		beq	DoCommands4
		bsr	EditUser
DoCommands4:	tst.w	SomethingDone
		bne	DoCommands5
		bsr	ChangePW
DoCommands5:	bra	ShutDown

ChangePW:	bsr	FindUser
		tst.l	d0
		bne	ChangePW_OUT

		lea.l	UNUSEDText1,a0
		lea.l	UserName,a1
		bsr	CmpStrings
		tst.l	d0
		beq	ChangePW0.1
		lea.l	InvalidText1,a0	
		bsr	Printer
		bra	ChangePW_OUT

ChangePW0.1:	lea.l	PasswordText3,a0
		bsr	Printer
		lea.l	Buffer1,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	ChangePW1
		lea.l	BreakText1,a0
		bsr	Printer
		bra	ChangePW_OUT
ChangePW1:	lea.l	PassWord,a0
		lea.l	Buffer2,a1
		bsr	Decrypt

		lea.l	Buffer1,a1
		lea.l	Buffer2,a0
		bsr	CmpStrings
		tst.l	d0
		bne	ChangePW2
		lea.l	MismatchText2,a0
		bsr	Printer
		bra	ChangePW_OUT
ChangePW2:	lea.l	CRLFText1,a0
		bsr	Printer
		bsr	GetPW
		tst.l	d0
		bne	ChangePW_OUT

ChangePW6:	lea.l	CRLFText1,a0
		bsr	Printer

		lea.l	Buffer1,a0
		lea.l	PassWord,a1
		bsr	Encrypt

		bsr	SeekBack
		bsr	WriteUser

ChangePW_OUT:	rts

AddUser:	move.w	#1,SomethingDone
		bsr	CheckClone
		tst.l	d0
		bne	AddUser0.01
		lea.l	DoubleNameText1,a0
		bsr	Printer
		bra	AddUser_OUT

AddUser0.01:	bsr	CheckRoot
		tst.l	d0
		bne	AddUser_OUT

		bsr	FindFree

		bsr	ClearUser
		bsr	CopyUN1

AddUser0.1:	bsr	GetRealN
		tst.l	d0
		bne	AddUser_OUT

AddUser1.1:	lea.l	PasswordText1,a0
		bsr	Printer

		lea.l	Buffer1,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	AddUser2
		lea.l	BreakText1,a0
		bsr	Printer
		bra	AddUser_OUT

AddUser2:	cmp.l	#4,d0
		bhi	AddUser2.1
		lea.l	ShortText1,a0
		bsr	Printer
		bra	AddUser1.1

AddUser2.1:	lea.l	PasswordText2,a0
		bsr	Printer

		lea.l	Buffer2,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	AddUser3
		lea.l	BreakText1,a0
		bsr	Printer
		bra	AddUser_OUT

AddUser3:	lea.l	Buffer2,a0
		lea.l	Buffer1,a1
		bsr	CmpStrings
		tst.l	d0
		bne	AddUser4
		lea.l	MismatchText1,a0
		bsr	Printer
		bra	AddUser1.1

AddUser4:	bsr	GetHome
		tst.l	d0
		bne	AddUser_OUT

AddUser5:	bsr	GetOffice
		tst.l	d0
		bne	AddUser_OUT

AddUser6:	bsr	GetCommand
		tst.l	d0
		bne	AddUser_OUT

AddUser7:	bsr	GiveUserInfo

		lea.l	AddUserText1,a0
		bsr	Printer
		bsr	GetAnswer
		tst.l	d0
		bne	AddUser_OUT

		lea.l	Buffer1,a0
		lea.l	PassWord,a1
		bsr	Encrypt

		bsr	WriteUser
AddUser_OUT:	rts

RemUser:	move.w	#1,SomethingDone
		bsr	CheckRoot
		tst.l	d0
		bne	RemUser_OUT
		bsr	FindUser
		tst.l	d0
		bne	RemUser_OUT

		cmp.l	#'root',UserName
		bne	RemUser1
		lea.l	RemUserText2,a0
		bsr	Printer
		bra	RemUser_OUT

RemUser1:	bsr	GiveUserInfo

		lea.l	RemUserText1,a0
		bsr	Printer

		bsr	GetAnswer
		tst.l	d0
		bne	RemUser_OUT

		bsr	SeekBack
		bsr	ClearUser
		move.l	#'UNUS',UserName
		move.w	#'ED',UserName+4
		bsr	WriteUser

RemUser_OUT:	rts

ListUsers:	move.w	#1,SomethingDone
		lea.l	AllUsersText1,a0
		bsr	Printer

ListUsers1:	clr.w	Quiet
		bsr	ReadUser
		tst.l	d0
		bne	ListUsers_OUT

		move.w	#1,Quiet
		lea.l	UNUSEDText1,a0
		lea.l	UserName,a1
		bsr	CmpStrings
		tst.l	d0
		bne	ListUsers1

		bsr	GiveUserInfo

		bsr	CheckBreak
		tst.l	d0
		beq	ListUsers1

ListUsers_OUT:	move.w	#1,Quiet
		rts

EditUser:	move.w	#1,SomethingDone
		bsr	CheckRoot
		tst.l	d0
		bne	EditUser_OUT
		bsr	FindUser
		tst.l	d0
		bne	EditUser_OUT

EditUser0.1:	bsr	GiveUserInfo
		bsr	GetOption
		cmp.l	#-1,d0
		beq	EditUser_OUT
		tst.l	d0
		beq	EditUser1
		cmp.l	#1,d0
		beq	EditUser2
		cmp.l	#2,d0
		beq	EditUser3
		cmp.l	#3,d0
		beq	EditUser4
		cmp.l	#4,d0
		beq	EditUser5
		cmp.l	#5,d0
		beq	EditUser6
		cmp.l	#6,d0
		beq	EditUser7
EditUser_OUT	rts
EditUser1:	bsr	GetUserN
		tst.l	d0
		bne	EditUser_OUT
		bra	EditUser0.1
EditUser2:	bsr	GetPW
		tst.l	d0
		bne	EditUser_OUT
		lea.l	Buffer1,a0
		lea.l	PassWord,a1
		bsr	Encrypt
		bra	EditUser0.1
EditUser3:	bsr	GetRealN
		tst.l	d0
		bne	EditUser_OUT
		bra	EditUser0.1
EditUser4:	bsr	GetHome
		tst.l	d0
		bne	EditUser_OUT
		bra	EditUser0.1
EditUser5:	bsr	GetOffice
		tst.l	d0
		bne	EditUser_OUT
		bra	EditUser0.1
EditUser6:	bsr	SeekBack
		bsr	WriteUser
		bra	EditUser_OUT
EditUser7:	bsr	GetCommand
		tst.l	d0
		bne	EditUser_OUT
		bra	EditUser0.1

ShutDown:	move.l	PassWdFile,d1
		beq	ShutDown9000
		lib	Dos,Close

ShutDown9000:	move.l	RDArgs1,d1
		beq	ShutDown8000
		lib	Dos,FreeArgs

ShutDown8000:
ShutDown1000:	closlib	Dos

		move.l	#RETURN_OK,d0
		rts

ArgMissing:	move.l	#ERROR_REQUIRED_ARG_MISSING,d1
		lib	Dos,SetIoErr
		bra	NoRDArgs

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

NoDos:		move.l	#RETURN_FAIL,d0
		rts

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

Printer:	tst.w	Quiet
		beq	Printer1
		printa	a0
Printer1:	rts

CheckRoot:	bsr	SeekStart
		bsr	ReadUser
		tst.l	d0
		bne	CheckRoot_OUT
		lea.l	PasswordText1,a0
		bsr	Printer
		lea.l	Buffer1,a0
		move.l	#10,d0
		bsr	GetString2
		cmp.l	#-1,d0
		bne	CheckRoot1
		lea.l	BreakText1,a0
		bsr	Printer
		bra	CheckRoot_OUT
CheckRoot1:	lea.l	CRLFText1,a0
		bsr	Printer
		lea.l	PassWord,a0
		lea.l	Buffer2,a1
		bsr	Decrypt

		bsr	SeekStart

		lea.l	Buffer2,a0
		lea.l	Buffer1,a1
		bsr	CmpStrings
		tst.l	d0
		bne	CheckRoot2
		lea.l	MismatchText2,a0
		bsr	Printer
CheckRoot_OUT:	move.l	#-1,d0
		rts
CheckRoot2:	clr.l	d0
		rts

;Seek to end of PassWdFile
;
;Results d0 = length
;

SeekEnd:	push	d2-d3
		move.l	PassWdFile,d1
		move.l	d1,d6
		move.l	#00,d2
		move.l	#01,d3
		lib	Dos,Seek
		move.l	d6,d1
		lib	Dos,Seek
		pull	d2-d3
		rts

SeekStart:	push	d2-d3
		move.l	PassWdFile,d1
		move.l	#0,d2
		move.l	#-1,d3
		lib	Dos,Seek
		pull	d2-d3
		rts

SeekBack:	push	d2-d3
		move.l	PassWdFile,d1
		move.l	#-DataSize,d2
		move.l	#0,d3
		lib	Dos,Seek
		pull	d2-d3
		rts

CopyUN1:	move.l	Buffer3,UserName
		move.l	Buffer3+4,UserName+4
		move.l	Buffer3+8,UserName+8
		rts

ClearUser:	clr.l	UserName
		clr.l	UserName+4
		clr.l	UserName+8
		clr.l	PassWord
		clr.l	PassWord+4
		clr.l	PassWord+8
		clr.l	RealName
		clr.l	RealName+4
		clr.l	RealName+8
		clr.l	RealName+12
		clr.l	RealName+16
		clr.l	RealName+20
		clr.l	RealName+24
		clr.l	RealName+28
		clr.l	UserHome
		clr.l	Office
		clr.l	UserCommand
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

FindFree:	clr.w	Quiet
		bsr	ReadUser
		tst.l	d0
		bne	FindFree_ERR1
		lea.l	UNUSEDText1,a0
		lea.l	UserName,a1
		bsr	CmpStrings
		tst.l	d0
		beq	FindFree
		bsr	SeekBack
FindFree_ERR1:	move.w	#1,Quiet
		rts

CheckClone:	clr.w	Quiet
		bsr	ReadUser
		tst.l	d0
		bne	CheckClone_ERR1
		lea.l	Buffer3,a0
		lea.l	UserName,a1
		bsr	CmpStrings
		tst.l	d0
		beq	CheckClone
		move.w	#1,Quiet
		clr.l	d0
		rts
CheckClone_ERR1: move.w	#1,Quiet
		move.l	#-1,d0
		rts

WriteUser:	move.l	PassWdFile,d1
		lea.l	UserName,a0
		move.l	a0,d2
		move.l	#DataSize,d3
		lib	Dos,Write
		cmp.l	#DataSize,d0
		beq	WriteUser1
		bsr	FileError3
		move.l	#-1,d0
		rts
WriteUser1:	clr.l	d0
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


GiveUserInfo:	lea.l	UserNText1,a0
		bsr	Printer
		lea.l	UserName,a0
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
		lea.l	CommandText2,a0
		bsr	Printer
		lea.l	UserCommand,a0
		bsr	Printer
		lea.l	CRLFText1,a0
		bsr	Printer
		rts

;Asks for username (login name)

GetUserN:	lea.l	GiveNameText2,a0
		bsr	Printer
		lea.l	UserName,a0
		move.l	#64,d0
		bsr	GetString
		tst.l	d0
		beq	GetUserN_OUT1

		bsr	CheckBreak
		tst.l	d0
		bne	GetUserN_OUT1

		cmp.b	#10,UserName
		beq	GetUserN

		lea.l	UserName,a0
		move.l	#64,d0
		bsr	RemoveLF
GetUserN_OUT:	clr.l	d0
		rts
GetUserN_OUT1:	move.l	#-1,d0
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

;Asks for realname for user

GetRealN:	lea.l	GiveNameText1,a0
		bsr	Printer
		lea.l	RealName,a0
		move.l	#64,d0
		bsr	GetString
		tst.l	d0
		beq	GetRealN_OUT1

		bsr	CheckBreak
		tst.l	d0
		bne	GetRealN_OUT1

		cmp.b	#10,RealName
		beq	GetRealN

		lea.l	RealName,a0
		move.l	#64,d0
		bsr	RemoveLF
GetRealN_OUT:	clr.l	d0
		rts
GetRealN_OUT1:	move.l	#-1,d0
		rts

;Ask for home directory

GetHome:	lea.l	UserHomeText1,a0
		bsr	Printer
		lea.l	UserHome,a0
		move.l	#64,d0
		bsr	GetString
		tst.l	d0
		beq	GetHome_OUT1

		bsr	CheckBreak
		tst.l	d0
		bne	GetHome_OUT1

		cmp.b	#10,UserHome
		beq	GetHome

GetHome2:	lea.l	UserHome,a0
		move.l	#64,d0
		bsr	RemoveLF
GetHome_OUT:	clr.l	d0
		rts
GetHome_OUT1:	move.l	#-1,d0
		rts

;Asks for office for user

GetOffice:	lea.l	OfficeText1,a0
		bsr	Printer
		lea.l	Office,a0
		move.l	#64,d0
		bsr	GetString
		tst.l	d0
		beq	GetOffice_OUT1

		bsr	CheckBreak
		tst.l	d0
		bne	GetOffice_OUT1

		cmp.b	#10,Office
		beq	GetOffice

GetOffice1:	lea.l	Office,a0
		move.l	#64,d0
		bsr	RemoveLF
GetOffice_OUT:	clr.l	d0
		rts
GetOffice_OUT1:	move.l	#-1,d0
		rts

;Asks for command for user

GetCommand:	lea.l	CommandText1,a0
		bsr	Printer
		lea.l	UserCommand,a0
		move.l	#64,d0
		bsr	GetString
		tst.l	d0
		beq	GetCommand_OUT1

		bsr	CheckBreak
		tst.l	d0
		bne	GetCommand_OUT1

		cmp.b	#10,UserCommand
		beq	GetCommand

GetCommand1:	lea.l	UserCommand,a0
		move.l	#64,d0
		bsr	RemoveLF
GetCommand_OUT:	clr.l	d0
		rts
GetCommand_OUT1: move.l	#-1,d0
		rts

;Get yes or no answer from CLI

GetAnswer:	move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		lea.l	AskText1,a0
		bsr	Printer
		move.l	_stdin,d1
		lib	Dos,Flush
		move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	GetAnswer_Neg
		cmp.l	#'n',d0
		beq	GetAnswer_Neg
		cmp.l	#'N',d0
		beq	GetAnswer_Neg
		cmp.l	#'y',d0
		beq	GetAnswer_Pos
		cmp.l	#'Y',d0
		beq	GetAnswer_Pos
GetAnswer_Neg:	lea.l	NoText1,a0
		bsr	Printer
		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		move.l	#-1,d0
		rts
GetAnswer_Pos:	lea.l	YesText1,a0
		bsr	Printer
		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		clr.l	d0
		rts

;Get option from user
;
;Result	d0 = Option (0=username, 1=password, 2=realname, 3=home, 4=office,
;		     5=write,6=command)

GetOption:	move.l	_stdin,d1
		move.l	#TRUE,d2
		lib	Dos,SetMode

		lea.l	EditUserText1,a0
		bsr	Printer

		move.l	_stdin,d1
		lib	Dos,Flush
GetOption1:	move.l	_stdin,d1
		lib	Dos,FGetC
		cmp.l	#-1,d0
		beq	GetOption_OUT
		cmp.l	#'u',d0
		beq	GetOption2
		cmp.l	#'U',d0
		beq	GetOption2
		cmp.l	#'p',d0
		beq	GetOption3
		cmp.l	#'P',d0
		beq	GetOption3
		cmp.l	#'r',d0
		beq	GetOption4
		cmp.l	#'R',d0
		beq	GetOption4
		cmp.l	#'h',d0
		beq	GetOption5
		cmp.l	#'H',d0
		beq	GetOption5
		cmp.l	#'o',d0
		beq	GetOption6
		cmp.l	#'O',d0
		beq	GetOption6
		cmp.l	#'w',d0
		beq	GetOption7
		cmp.l	#'W',d0
		beq	GetOption7
		cmp.l	#'c',d0
		beq	GetOption8
		cmp.l	#'C',d0
		beq	GetOption8
		cmp.l	#13,d0
		beq	GetOption_ERR
		cmp.l	#10,d0
		beq	GetOption_ERR
		bra	GetOption1
GetOption2:	lea.l	OptText1,a0
		bsr	Printer
		move.l	#0,d0
		bra	GetOption_OUT
GetOption3:	lea.l	OptText2,a0
		bsr	Printer
		move.l	#1,d0
		bra	GetOption_OUT
GetOption4:	lea.l	OptText3,a0
		bsr	Printer
		move.l	#2,d0
		bra	GetOption_OUT
GetOption5:	lea.l	OptText4,a0
		bsr	Printer
		move.l	#3,d0
		bra	GetOption_OUT
GetOption6:	lea.l	OptText5,a0
		bsr	Printer
		move.l	#4,d0
		bra	GetOption_OUT
GetOption7:	lea.l	OptText6,a0
		bsr	Printer
		move.l	#5,d0
		bra	GetOption_OUT
GetOption8:	lea.l	OptText7,a0
		bsr	Printer
		move.l	#6,d0
;		bra	GetOption_OUT
GetOption_OUT:	push	d0
		move.l	_stdin,d1
		move.l	#FALSE,d2
		lib	Dos,SetMode
		pull	d0
		rts
GetOption_ERR:	lea.l	CRLFText1,a0
		bsr	Printer
		move.l	#-1,d0
		bra	GetOption_OUT

;Gets a string from the CLI
;
;Input a0 = Buffer
;      d0 = Length
;

GetString:	move.l	d0,d3
		move.l	a0,d2
		move.l	_stdin,d1
		lib	Dos,Flush
		move.l	_stdin,d1
;		move.l	a2,d2
		lib	Dos,FGets
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

;Removes LF from string
;
;Inputs a0 = string to remove LF from
;	d0 = maxlength

RemoveLF:	move.l	a0,a1
		add.l	d0,a1
RemoveLF1:	cmp.b	#10,(a0)+
		beq	RemoveLF2
		cmp.l	a0,a1
		bne	RemoveLF1
		rts
RemoveLF2:	clr.b	-1(a0)
		rts

;Encrypts passwords
;
;Input a0 = pointer to ASCII password
;      a1 = pointer to buffer for encrypted password
;

Encrypt:	clr.l	d1
Encrypt1:	move.l	(a0)+,d0
		rol.l	#2,d0
		add.l	#$DEADBEEF,d0
		ror.l	#7,d0
		swap.l	d0
		move.l	d0,(a1)+
		add.l	#1,d1
		cmp.l	#3,d1
		bne	Encrypt1
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

;Reservations

RDArgs1:	dc.l	0

;Options

CLArray1:
OptionAdd:	dc.l	0
OptionRemove:	dc.l	0
OptionEdit:	dc.l	0
OptionList:	dc.l	0
UserPointer:	dc.l	0

Quiet:		dc.w	1		;0=Quiet, 1=Loud as hell...

SomethingDone:	dc.w	0

;Files

_stdin:		dc.l	0
		dc.l	0
PassWdFile:	dc.l	0

;Texts to output

CLTemplate1:	dc.b	"ADD/S,REMOVE/S,EDIT/S,LIST/S,USER",0
		dc.b	"$VER: PassWd 1.04 (3.2.93) Tomi Blinnikka 1993",0

UsageText1:	dc.b	"USAGE: PassWd [a] [r] [l] [e] [Username]",13,10,13,10
		dc.b	"       Where: [a] Add a user",13,10
		dc.b	"              [r] Remove a user",13,10
		dc.b	"              [e] Edit a user",13,10
		dc.b	"              [l] List active users",13,10
		dc.b	"              [Username] is the login name for user",13,10,13,10
		dc.b	"Adds & removes users and changes their passwords. Use with Logger.",13,10
		dc.b	"See docs for more information.",13,10,0

BreakText1:	dc.b	"***Break",13,10,0
CRLFText1:	dc.b	13,10,0
CreatingText1:	dc.b	"Password file doesn't exist! Creating new PassWd-file...",13,10,0
UserNText1:	dc.b	13,10,"Username: ",0
RealNText1:	dc.b	13,10,"Realname: ",0
AddUserText1:	dc.b	13,10,"Add user? ",0
RemUserText1:	dc.b	13,10,"Remove this user? ",0
EditUserText1:	dc.b	13,10,"Please choose item (press <Return> to quit)."
		dc.b	13,10,"(U)sername, (P)assword, (R)ealname, (H)ome, (O)ffice, (C)ommand, (W)rite: ",0
RemUserText2:	dc.b	"ERROR: Cannot remove 'root'!",13,10,0
GiveNameText1:	dc.b	"Enter realname for user: ",0
GiveNameText2:	dc.b	"Enter username for user: ",0
PasswordText1:	dc.b	"Enter password: ",0
PasswordText2:	dc.b	13,10,"Re-enter password: ",0
PasswordText3:	dc.b	"Enter current password: ",0
UserHomeText1:	dc.b	13,10,"Enter home directory for user: ",0
UserHomeText2:	dc.b	13,10,"Home directory: ",0
OfficeText1:	dc.b	13,10,"Enter office for user: ",0
OfficeText2:	dc.b	13,10,"Office: ",0
CommandText1:	dc.b	13,10,"Enter command for user: ",0
CommandText2:	dc.b	13,10,"Command: ",0
MaxText1:	dc.b	13,10,"Maximum length reached (10 characters)!",13,10,0
ShortText1:	dc.b	13,10,"Please enter a longer password. Minimum of 5 characters required.",13,10,0
MismatchText1:	dc.b	13,10,"Password mismatch! Please retry.",13,10,0
MismatchText2:	dc.b	13,10,"Incorrect password!",13,10,0
NoUserText1:	dc.b	"No user with that name!",13,10,0
DoubleNameText1: dc.b	"A user with that name already exists!",13,10,0
AllUsersText1:	dc.b	"List of active users:",13,10,0
InvalidText1:	dc.b	"Invalid username!",13,10,0

AskText1:	dc.b	"(Y/N): ",0
YesText1:	dc.b	"Yes",13,10,0
NoText1:	dc.b	"No",13,10,0
OptText1:	dc.b	"Username",13,10,0
OptText2:	dc.b	"Password",13,10,0
OptText3:	dc.b	"Realname",13,10,0
OptText4:	dc.b	"Home",13,10,0
OptText5:	dc.b	"Office",13,10,0
OptText6:	dc.b	"Write",13,10,0
OptText7:	dc.b	"Command",13,10,0

UserVarText1:	dc.b	"username",0
UNUSEDText1:	dc.b	"UNUSED",0
PassWdFileN:	dc.b	"LOGGER:PassWd.LOGGER",0

;Error texts

FileErrorText1:	dc.b	"Couldn't open file 'GETTY:PassWd.LOGGER'",13,10,0
FileErrorText2:	dc.b	"Read error with file 'GETTY:PassWd.LOGGER'",13,10,0
FileErrorText3:	dc.b	"Write error with file 'GETTY:PassWd.LOGGER'",13,10,0
FileErrorText4:	dc.b	"Couldn't create file 'GETTY:PassWd.LOGGER'",13,10,0

		ds.l	0

;library stuff

		libnames

;buffers

Buffer1:	dcb.b	12,0		;Temporary buffer for password
Buffer2:	dcb.b	12,0		;Temporary buffer for password
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

