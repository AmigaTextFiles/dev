*************************************************
*						*
*		 (C)opyright 1993		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	17/07/1993-			*
*	 -0.99ö 05/10/1993			*
*						*
* Version 1.00	06/10/1993			*
*						*
*************************************************

	INCLUDE "JMPLibs.i"
	INCLUDE "exec/memory.i"
	INCLUDE "exec/io.i"
	INCLUDE "exec/tasks.i"
	INCLUDE	"devices/serial.i"
	INCLUDE "libraries/commodities.i"
	INCLUDE "libraries/dosextens.i"
	INCLUDE "libraries/dos.i"
	INCLUDE "libraries/gadtools.i"
	INCLUDE	"libraries/asl.i"
	INCLUDE "workbench/startup.i"
	INCLUDE "dos/dostags.i"
	INCLUDE	"rexx/errors.i"
	INCLUDE	"rexx/storage.i"

	INCLUDE "XREF:2.0.xref"
	INCLUDE "XREF:intuition.xref"
	INCLUDE "XREF:exec.xref"
	INCLUDE "XREF:dos.xref"
	INCLUDE "XREF:icon.xref"

	XREF	_HotKey

	XDEF	_DOSBase
	XDEF	_SysBase
	XDEF	_CxBase

PROGVERSION:	macro
		dc.b	"1.01 (14.10.93)"
		endm

ShellTop:	EQU	2
OptionTop:	EQU	144
ListTop:	EQU	15
InfoTop:	EQU	13
ActionTop:	EQU	ListTop+50
NegativeTop:	EQU	-26

START_PORT:	EQU	0		;Port wanted minus 1

PortAmount:	EQU	48
ListAmount:	EQU	14
NUMGADS:	EQU	8

CMD_LENGTH:	EQU	4

GADLENG1:	EQU	14
GADLENG2:	EQU	32
GADLENG3:	EQU	8
PRINT_BUF_SIZE:	EQU	80

GADWIDTH1:	EQU	120
GADWIDTH2:	EQU	180
GADWIDTH3:	EQU	80

START_LOAD:	EQU	3511462

CCFileVersion:	EQU	'CC02'

TRUE:		EQU	1
FALSE:		EQU	0
do_ToolTypes:	EQU	$36

		section CC,CODE

		push	d2-d7/a2-a6

		sub.l	a1,a1			;Find our task
		lib	Exec,FindTask
		move.l	d0,OurTask
		move.l	d0,a4
		move.l	pr_CLI(a4),d0
		bne	OpenDos

		lea.l	pr_MsgPort(a4),a0
		lib	Exec,WaitPort
		lea.l	pr_MsgPort(a4),a0
		lib	Exec,GetMsg
		move.l	d0,WBMsg

OpenDos:	openlib Dos,NoDos		;Keep at beginning

		tst.l	WBMsg
		beq	CLIStart

		lea.l	NILName,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
		beq	NoNIL
		move.l	NILFile,_stdout

		openlib Icon,NoIcon

		move.l	WBMsg,a0
		move.l	sm_ArgList(a0),a1
		move.l	wa_Lock(a1),d1
		lib	Dos,CurrentDir
		move.l	d0,OldLock

		move.l	WBMsg,a0
		move.l	sm_ArgList(a0),a1
		move.l	wa_Name(a1),a0
		lib	Icon,GetDiskObject
		move.l	d0,DiskObject
		beq	MainStart

		bra	MainStart		;DEBUG

DoToolType1:	move.l	DiskObject,a4
		move.l	do_ToolTypes(a4),a0
		lea.l	ICONIFYText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType2
		move.l	d0,a0
		lea.l	YESText1,a1
		lib	Icon,MatchToolValue
		tst.l	d0
		beq	DoToolType2
		move.l	#1,OptionIconify

DoToolType2:	move.l	do_ToolTypes(a4),a0
		lea.l	FROMText1,a1
		lib	Icon,FindToolType
		move.l	d0,FromFile

DoToolType3:	bra	MainStart

CLIStart:	lib	Dos,Output
		move.l	d0,_stdout

		lea.l	CLTemplate1,a0
		move.l	a0,d1
		lea.l	CLArray1,a0
		move.l	a0,d2
		clr.l	d3
		lib	Dos,ReadArgs
		move.l	d0,RDArgs1
		beq	NoRDArgs

MainStart:	openlib Intuition,NoInt
		openlib	Commodities,NoCommodities
		openlib GadTools,NoGadTools
		openlib	Asl,NoAsl
		openlib	Utility,NoUtility

		move.l	$4,_SysBase
		move.l	_DosBase,_DOSBase
		move.l	_CommoditiesBase,_CxBase

;Init list(s)

		lea.l	PortList,a0
		NEWLIST	a0

;Check to see if a port with our name already exists

		lib	Exec,Forbid
		lea.l	ARexxPortName,a1
		flib	Exec,FindPort
		push	d0
		flib	Exec,Permit

		pull	d0
		tst.l	d0
		bne	NoMsgPort2

;Create AREXX message port

		lib	Exec,CreateMsgPort
		move.l	d0,ARexxPort
		beq	NoMsgPort

		move.l	ARexxPort,a1
		lea.l	ARexxPortName,a0
		move.l	a0,LN_NAME(a1)
		lib	Exec,AddPort

;Create a message port for commodities.library (Exchange)

		lib	Exec,CreateMsgPort
		move.l	d0,CXPort
		beq	NoMsgPort
		lea.l	NewBroker1,a0
		move.l	d0,nb_Port(a0)

		bsr	LockPubScr
		tst.l	PubScreen
		beq	NoPubScreen

;Get visualinfo

		move.l	PubScreen,a0
		sub.l	a1,a1
		lib	GadTools,GetVisualInfoA
		move.l	d0,vi

;Make gadget stuff

		lea.l	glist,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad
		beq	NoContextGad

		move.l	glist,a0
		lea.l	NGSaveGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,SaveGad1

		lea.l	NGQuitGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,QuitGad1
		or.w	#GRELRIGHT,gg_Flags(a0)

		lea.l	NGListGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#LISTVIEW_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	ListGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,ListGad1

		lea.l	NGPortGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	PortGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,PortGad1

		lea.l	NGStatusGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StatusGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,StatusGad1

		lea.l	NGSingleGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,SingleGad1

		lea.l	NGOnGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,OnGad1

		lea.l	NGOffGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,OffGad1

		lea.l	NGToggleGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,ToggleGad1

		lea.l	NGAllGad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,AllGad1

		lea.l	NGOnGad2,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,OnGad2

		lea.l	NGOffGad2,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,OffGad2

		lea.l	NGToggleGad2,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,ToggleGad2

		lea.l	glist2,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad2
		beq	NoContextGad

		move.l	glist2,a0
		lea.l	NGDesc1Gad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	DescGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,Desc1Gad
		move.l	d0,a0

		lea.l	NGDesc2Gad,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#TEXT_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	DescGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0

		lea.l	NGStrGad1,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad1
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf1

		lea.l	NGStrGad2,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad2
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf2

		lea.l	NGStrGad3,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad3
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf3

		lea.l	NGStrGad4,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad4
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf4

		lea.l	NGStrGad5,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad5
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf5

		lea.l	NGStrGad6,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad6
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf6

		lea.l	NGStrGad7,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad7
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf7

		lea.l	NGStrGad8,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	StrGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,StrGad8
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),StrGadBuf8

		lea.l	NGNumGad1,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad1
		move.l	d0,a0

		lea.l	NGNumGad2,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad2
		move.l	d0,a0

		lea.l	NGNumGad3,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad3
		move.l	d0,a0

		lea.l	NGNumGad4,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad4
		move.l	d0,a0

		lea.l	NGNumGad5,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad5
		move.l	d0,a0

		lea.l	NGNumGad6,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad6
		move.l	d0,a0

		lea.l	NGNumGad7,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad7
		move.l	d0,a0

		lea.l	NGNumGad8,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	NumGadTagList1,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,NumGad8

		lea.l	glist3,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad3
		beq	NoContextGad

		move.l	glist3,a0
		lea.l	NGSerGad1,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SerGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SerGad1
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),SerGadBuf1

		lea.l	NGSerGad2,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#INTEGER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SerGadTagList2,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SerGad2
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		add.l	#si_LongInt,a1
		move.l	a1,SerGadInt2

		lea.l	NGSerGad3,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#INTEGER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SerGadTagList3,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SerGad3
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		add.l	#si_LongInt,a1
		move.l	a1,SerGadInt3

		lea.l	NGOKGad1,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,OKGad1
		move.l	d0,a0
		or.w	#GRELBOTTOM,gg_Flags(a0)

		lea.l	NGCancelGad1,a1
		add.w	d5,gng_TopEdge(a1)
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,CancelGad1
		move.l	d0,a0
		or.w	#GRELBOTTOM!GRELRIGHT,gg_Flags(a0)

		move.b	#1,GadMagic		;Make worked OK

;New style menu stuff

		lea.l	MNProjectMenu1,a0
		lea.l	MenuTagList,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist
		beq	NoMenus

		move.l	mlist,a0
		move.l	vi,a1
		lea.l	MenuTagList,a2
		lib	GadTools,LayoutMenusA

		lea.l	MNPageMenu1,a0
		lea.l	MenuTagList2,a1
		lib	GadTools,CreateMenusA
		move.l	d0,mlist2
		beq	NoMenus

		move.l	mlist2,a0
		move.l	vi,a1
		lea.l	MenuTagList2,a2
		lib	GadTools,LayoutMenusA
		move.b	#1,MenuMagic

;Do CX init stuff. Create broker

		tst.l	OptCXPri
		beq	SkipSetCXPri
		move.l	OptCXPri,a0
		move.l	(a0),d0

		tst.l	d0
		bmi	SetCXPri2

		cmp.l	#127,d0
		bhi	BadPriority
		bra	SetCXPri3

SetCXPri2:	cmp.l	#-128,d0
		bcs	BadPriority

SetCXPri3:	move.b	d0,NBPri
SkipSetCXPri:	lea.l	NewBroker1,a0
		clr.l	d0			;No extra error codes wanted
		lib	Commodities,CxBroker
		move.l	d0,CXBroker1
		beq	NoCommodity

;Create Filter object

		move.l	OptCXPopKey,a0
		sub.l	a1,a1
		move.l	#CX_FILTER,d0
		lib	Commodities,CreateCxObj
		move.l	d0,d2
		beq	NoCommodity

;Attach Filter object to Broker

		move.l	CXBroker1,a0
		move.l	d2,a1
		lib	Commodities,AttachCxObj

		move.l	d2,a0			;Check if valid descriptor
		lib	Commodities,CxObjError
		cmp.l	#COERR_BADFILTER,d0
		beq	NoFilter

;Create send object

		move.l	d2,d3
		move.l	CXPort,a0
		sub.l	a1,a1
		move.l	#CX_SEND,d0
		lib	Commodities,CreateCxObj
		move.l	d0,d2
		beq	NoCommodity

;Attach Send object to Filter

		move.l	d3,a0
		move.l	d2,a1
		lib	Commodities,AttachCxObj

;Create translate object

		move.l	d2,d3
		sub.l	a0,a0
		sub.l	a1,a1
		move.l	#CX_TRANSLATE,d0
		lib	Commodities,CreateCxObj
		move.l	d0,d2
		beq	NoCommodity

;Attach Translate object to Send

		move.l	d3,a0
		move.l	d2,a1
		lib	Commodities,AttachCxObj

;Read preferences

		move.l	#START_LOAD,d0
		bsr	Load

;Create reply port for serial.device (or modem0.device etc.)

		lib	Exec,CreateMsgPort
		move.l	d0,SWPort
		beq	NoMsgPort

;Create IOReq for serial.device (or for other device, but size is EXTSER)

		move.l	#IOEXTSER_SIZE,d0
		move.l	SWPort,a0
		clr.b	LN_TYPE(a0)		;Make sure CheckIO doesn't hang
		lib	Exec,CreateIORequest
		move.l	d0,IORequest
		beq	NoIOReq

;Open serial device

		bsr	OpenSerial
		tst.l	d0
		beq	NoSerial

;Open window

		bsr	OpenWin1
		tst.l	Window1
		beq	NoWindow1

;Unlock PubScreen

		sub.l	a0,a0
		move.l	PubScreen,a1
		lib	Intuition,UnlockPubScreen
		clr.l	PubScreen

;Get Asl_requester

		move.l	Window1,AslReqTags+4
		move.l	#ASL_FileRequest,d0
		lea.l	AslReqTags,a0
		lib	Asl,AllocAslRequest
		move.l	d0,AslReq
		beq	NoAslReq

		bsr	MakePortList

		bsr	SendAllPorts

		bsr	CXEnable	;Turn on commodity

		move.l	#START_PORT,d3
		bra	GetCurrentPort		;jmps to Window1IDCMP

Window1IDCMP:	move.l	Window1,a3
		bsr	C2GetMsg1

		tst.l	d0			;Test for CTRL_C
		beq	ShutDown
		cmp.l	#4,d0
		beq	Window1IDCMP		;Already done ARexx or commodity

		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		cmp.l	#GADGETUP,d2
		beq	DoGads
		cmp.l	#CLOSEWINDOW,d2
		beq	DoDoCXDisappear
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#RAWKEY,d2
		beq	RawKeys
		bra	Window1IDCMP

Refresher:	move.l	Window1,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window1,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window1IDCMP

Win1Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win1Menus1
		cmp.w	#$01,d6
		beq	Win1Menus2
		bra	Window1IDCMP
Win1Menus1:	cmp.w	#$00,d5
		beq	DoLoad
		cmp.w	#$01,d5
		beq	Save
		cmp.w	#$02,d5
		beq	About
		cmp.w	#$04,d5
		beq	Print
		cmp.w	#$06,d5
		beq	Quit
		bra	Window1IDCMP
Win1Menus2:	cmp.w	#$00,d5
		beq	SetSerial
		cmp.w	#$01,d5
		beq	SetPorts
		bra	Window1IDCMP

DoLoad:		bsr	RemGads
		clr.l	d0
		bsr	Load
		bsr	AddGads
		bra	Window1IDCMP

VanillaKeys:	cmp.w	#$1b,d3			;Escape
		beq	Quit

		cmp.l	#'a',d3
		bcs	VanillaKeys2
		cmp.l	#'z',d3
		bhi	VanillaKeys2
		sub.l	#32,d3

VanillaKeys2:	cmp.w	#'S',d3
		beq	Save
		cmp.w	#'Q',d3
		beq	Quit
		cmp.w	#'N',d3
		beq	PortOn
		cmp.w	#'F',d3
		beq	PortOff
		cmp.w	#'G',d3
		beq	TogglePort
		bra	Window1IDCMP

RawKeys:	cmp.w	#$4c,d3			;Arrow up
		beq	SelectPrev
		cmp.w	#$4d,d3			;Arrow down
		beq	SelectNext
		cmp.w	#$4f,d3			;Arrow left
		beq	SelectPrevScr
		cmp.w	#$4e,d3			;Arrow right
		beq	SelectNextScr
		bra	Window1IDCMP

DoGads:		cmp.w	#20,$26(a5)
		beq	PortOn
		cmp.w	#21,$26(a5)
		beq	PortOff
		cmp.w	#22,$26(a5)
		beq	TogglePort
		cmp.w	#30,$26(a5)
		beq	AllPortsOn
		cmp.w	#31,$26(a5)
		beq	AllPortsOff
		cmp.w	#32,$26(a5)
		beq	ToggleAll
		cmp.w	#55,$26(a5)
		beq	GetCurrentPort
		cmp.w	#98,$26(a5)
		beq	Save
		cmp.w	#99,$26(a5)
		beq	Quit
		bra	Window1IDCMP

SetSerial:	move.w	#1,DisActive		;Can't turn on/off
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		bsr	CloseSerial

		bsr	OpenWin3
		tst.l	d0
		beq	NoWindow1

		bsr	SetSerGads

Window3IDCMP:	move.l	Window3,a3
		bsr	C2GetMsg1

		tst.l	d0
		beq	ShutDown

		cmp.l	#4,d0
		beq	Window3IDCMP		;Already done commodity or ARexx

		cmp.l	#REFRESHWINDOW,d2
;		beq	Refresher3
		cmp.l	#GADGETUP,d2
		beq	ActivateGads3
		cmp.l	#CLOSEWINDOW,d2
		beq	SetSerial_OUT
		cmp.l	#VANILLAKEY,d2
		beq	SetSerialKeys
		cmp.l	#ACTIVEWINDOW,d2
		beq	GoActGads3
		bra	Window3IDCMP

Refresher3:	move.l	Window3,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window3,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window3IDCMP

SetSerialKeys:	cmp.w	#$1b,d3
		beq	SetSerial_OUT
		cmp.l	#'a',d3
		bcs	SetSerialKeys2
		cmp.l	#'z',d3
		bhi	SetSerialKeys2
		sub.l	#32,d3

SetSerialKeys2:	cmp.w	#'O',d3
		beq	SetSerialOK
		cmp.w	#'C',d3
		beq	SetSerial_OUT
		bra	Window3IDCMP

GoActGads3:	bsr	ActGad3
		bra	Window3IDCMP

ActivateGads3:	cmp.w	#96,$26(a5)		;OK
		beq	SetSerialOK

		cmp.w	#97,$26(a5)		;Cancel
		beq	SetSerial_OUT

		cmp.w	#2,$26(a5)
		bne	Window3IDCMP

		move.l	(a5),a0			;get next gad into a0
		tst.l	(a5)
		beq	ActivateGads3.02
		move.l	SerGad3,a1
		cmp.l	a5,a1
		bne	ActivateGads3.1
ActivateGads3.02: move.l SerGad1,a0
ActivateGads3.1: move.l Window3,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget

		bra	Window3IDCMP

ActGad3:	move.l	SerGad1,a0
		move.l	Window3,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
		rts

SetSerGads:	bsr	RemGads3

		lea.l	SerDevNBuffer1,a0
		move.l	SerGadBuf1,a1
		move.l	#GADLENG2,d0
		lib	Exec,CopyMem

		bsr	AddGads3

		move.l	SerUnit,GadUnit

		move.l	SerGad2,a0
		move.l	Window3,a1
		sub.l	a2,a2
		lea.l	SerGadTagList4,a3
		lib	GadTools,GT_SetGadgetAttrsA

		move.l	Speed,GadSpeed

		move.l	SerGad3,a0
		move.l	Window3,a1
		sub.l	a2,a2
		lea.l	SerGadTagList5,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

SaveSerGads:	move.l	SerGadBuf1,a0
		lea.l	SerDevNBuffer1,a1
		move.l	#GADLENG2,d0
		lib	Exec,CopyMem

		move.l	SerGadInt2,a0
		move.l	(a0),SerUnit

		move.l	SerGadInt3,a0
		move.l	(a0),Speed
		rts

SetSerialOK:	clr.w	Saved
		bsr	SaveSerGads
;		bra	SetSerial_OUT		;Careful!

SetSerial_OUT:	bsr	CloseWin3
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bsr	OpenSerial
		tst.l	d0
		beq	ShutDown
		clr.w	DisActive
		bra	Window1IDCMP

SetPorts:	clr.w	Saved
		move.w	#1,DisActive		;Can't turn on/off
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		bsr	OpenWin2
		tst.l	d0
		beq	NoWindow1
		bsr	RemGads2
		bsr	SetStrGads
		bsr	AddGads2

Window2IDCMP:	move.l	Window2,a3
		bsr	C2GetMsg1

		tst.l	d0
		beq	ShutDown

		cmp.l	#4,d0
		beq	Window2IDCMP		;Already done commodity or ARexx

		cmp.l	#GADGETUP,d2
		beq	ActivateGads2
		cmp.l	#CLOSEWINDOW,d2
		beq	Prefs_OUT
		cmp.l	#MENUPICK,d2
		beq	Win2Menus
		cmp.l	#VANILLAKEY,d2
		beq	SetPortKeys
		cmp.l	#ACTIVEWINDOW,d2
		beq	GoActGads2
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher2
		bra	Window2IDCMP

Refresher2:	move.l	Window2,a0
		lib	GadTools,GT_BeginRefresh
		move.l	Window2,a0
		move.l	#TRUE,d0
		lib	GadTools,GT_EndRefresh
		bra	Window2IDCMP

Win2Menus:	bsr	MenuNull
		cmp.w	#$00,d6
		beq	Win2Menus1
		bra	Window2IDCMP
Win2Menus1:	cmp.w	#$00,d5
		beq	DoPage1
		cmp.w	#$01,d5
		beq	DoPage2
		cmp.w	#$02,d5
		beq	DoPage3
		cmp.w	#$03,d5
		beq	DoPage4
		cmp.w	#$04,d5
		beq	DoPage5
		cmp.w	#$05,d5
		beq	DoPage6
		cmp.w	#$07,d5
		beq	Prefs_OUT
		bra	Window2IDCMP

DoPage1:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#0,Page
		bsr	SetStrGads
		bsr	AddGads2
		bra	Window2IDCMP

DoPage2:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#1,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage3:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#2,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage4:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#3,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage5:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#4,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

DoPage6:	bsr	SaveStrGads
		bsr	RemGads2
		move.w	#5,Page
		bsr	SetStrGads
		bsr	AddGads2
		bsr	ActGad2
		bra	Window2IDCMP

SaveStrGads:	lea.l	NameList,a2
		move.w	Page,d0
		mulu.w	#NUMGADS*GADLENG1,d0
		add.l	d0,a2			;a2=start of strings

		move.l	StrGadBuf1,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf2,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf3,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf4,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf5,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf6,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf7,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	StrGadBuf8,a0
		move.l	a2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem
		rts

SetStrGads:	move.w	Page,d2
		mulu.w	#8,d2

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad1,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lea.l	NumGadTagList1,a3
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad2,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad3,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad4,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad5,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad6,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad7,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

		add.l	#1,d2
		move.l	d2,NumText

		move.l	NumGad8,a0
		move.l	Window2,a1
		lib	GadTools,GT_SetGadgetAttrsA

;Then put the according text strings

		lea.l	NameList,a2
		move.w	Page,d0
		mulu.w	#NUMGADS*GADLENG1,d0
		add.l	d0,a2			;a2=start of strings

		move.l	a2,a0
		move.l	StrGadBuf1,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf2,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf3,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf4,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf5,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf6,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf7,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem

		move.l	a2,a0
		move.l	StrGadBuf8,a1
		move.l	#GADLENG1,d0
		add.l	d0,a2
		lib	Exec,CopyMem
		rts

GoActGads2:	bsr	ActGad2
		bra	Window2IDCMP

Prefs_OUT:	bsr	SaveStrGads
		bsr	KillMem1
		bsr	MakePortList
		bsr	CloseWin2
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		clr.w	DisActive
		bra	Window1IDCMP

SetPortKeys:	cmp.w	#$1b,d3
		beq	Prefs_OUT
		bra	Window2IDCMP

ToFront:	move.l	Window1,a0
		lib	Intuition,WindowToFront
		rts
ToBack:		move.l	Window1,a0
		lib	Intuition,WindowToBack
		rts
Zoom:		move.l	Window1,a0
		lib	Intuition,ZipWindow
		rts

ActivateGads2:	cmp.w	#2,$26(a5)
		bne	Window2IDCMP

		cmp.l	#$00,(a5)
		beq	ActivateGads2.01
		move.l	(a5),a0
		move.l	StrGad8,a1
		cmp.l	a5,a1
		bne	ActivateGads2.1
ActivateGads2.01: move.l StrGad1,a0
ActivateGads2.1: move.l Window2,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
		bra	Window2IDCMP

ActGad2:	move.l	StrGad1,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
		rts

CX:		cmp.l	#CXM_COMMAND,d2
		beq	DoCXCommand
		cmp.l	#CXM_IEVENT,d2
		beq	DoCXAppear
		move.l	#4,d0
		rts				;Unknown command

DoCXCommand:	cmp.l	#CXCMD_APPEAR,d3
		beq	DoCXAppear
		cmp.l	#CXCMD_DISAPPEAR,d3
		beq	DoCXDisappear
		cmp.l	#CXCMD_KILL,d3
		beq	DoCXKill
		cmp.l	#CXCMD_UNIQUE,d3
		beq	DoCXAppear
		cmp.l	#CXCMD_ENABLE,d3
		beq	DoCXEnable
		cmp.l	#CXCMD_DISABLE,d3
		beq	DoCXDisable
		move.l	#4,d0
		rts				;Unknown message

DoCXKill:	clr.l	d0
		rts

DoCXAppear:	tst.l	Window1
		bne	DoCXAppear_OUT
		tst.w	DisActive
		bne	DoCXDisap_OUT
		clr.l	OptionIconify
		bsr	SetModes
		bsr	OpenWin1
		tst.l	d0
		bne	DoCXAppear_OUT
		sub.l	a0,a0
		lib	Intuition,DisplayBeep	;Beep on error
DoCXAppear_OUT:	move.l	#4,d0
		rts

DoDoCXDisappear: bsr	DoCXDisappear
		bra	Window1IDCMP

DoCXDisappear:	tst.l	Window1
		beq	DoCXDisap_OUT
		tst.w	DisActive
		bne	DoCXDisap_OUT
		bsr	CheckModes
		bsr	CloseWin1
DoCXDisap_OUT:	move.l	#4,d0
		rts

DoCXEnable:	tst.w	DisActive
		bne	DoCXEnable1
		bsr	CXEnable
DoCXEnable_OUT:	move.l	#4,d0
		rts
DoCXEnable1:	bsr	CXDisable		;Can't turn on
		bra	DoCXEnable_OUT

DoCXDisable:	tst.w	DisActive
		bne	DoCXDisable1
		bsr	CXDisable
DoCXDis_OUT:	move.l	#4,d0
		rts
DoCXDisable1:	bsr	CXEnable		;Can't turn off
		bra	DoCXDis_OUT

CXEnable:	move.w	#1,OnOff
		move.l	CXBroker1,a0
		move.l	#TRUE,d0
		lib	Commodities,ActivateCxObj
		rts

CXDisable:	clr.w	OnOff
		move.l	CXBroker1,a0
		move.l	#FALSE,d0
		lib	Commodities,ActivateCxObj
		rts

SelectPrev:	cmp.l	#1,CurrentPort
		beq	SelectPrev_OUT
		sub.l	#1,CurrentPort
		bsr	ChangeSelect

SelectPrev_OUT:	move.l	CurrentPort,d3
		sub.l	#1,d3
		bra	GetCurrentPort

SelectNext:	cmp.l	#PortAmount,CurrentPort
		beq	SelectNext_OUT
		add.l	#1,CurrentPort
		bsr	ChangeSelect

SelectNext_OUT:	move.l	CurrentPort,d3
		sub.l	#1,d3
		bra	GetCurrentPort

SelectPrevScr:	cmp.l	#ListAmount+1,CurrentPort
		bcs	SelectPrevScr1
		sub.l	#ListAmount,CurrentPort
		bsr	ChangeSelect
		bra	SelectPScr_OUT
SelectPrevScr1:	move.l	#1,CurrentPort
		bsr	ChangeSelect

SelectPScr_OUT:	move.l	CurrentPort,d3
		sub.l	#1,d3
		bra	GetCurrentPort

SelectNextScr:	cmp.l	#PortAmount-ListAmount,CurrentPort
		bhi	SelectNScr_OUT
		add.l	#ListAmount,CurrentPort
		bsr	ChangeSelect

SelectNScr_OUT:	move.l	CurrentPort,d3
		sub.l	#1,d3
		bra	GetCurrentPort

ChangeSelect:	move.l	CurrentPort,L1SelTagsNum
		sub.l	#1,L1SelTagsNum

		move.l	L1SelTagsNum,L1TopTagNum	;Can we scroll down?
		cmp.l	#PortAmount-ListAmount/2,L1TopTagNum
		bcs	ChangeSelect1
		move.l	#34,L1TopTagNum
		bra	ChangeSelect3

ChangeSelect1:	cmp.l	#ListAmount/2,L1TopTagNum		;Can we scroll up?
		bhi	ChangeSelect2
		clr.l	L1TopTagNum
		bra	ChangeSelect3

ChangeSelect2:	sub.l	#ListAmount/2,L1TopTagNum

ChangeSelect3:	move.l	ListGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	List1SelTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

PortOn:		clr.w	Saved
		move.l	CurrentPort,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	PortError

		bset.b	d0,(a0)		;Turn bit on

		bsr	SendPort

		lea.l	OnText1,a0
		bsr	SetStatus
		bra	Window1IDCMP

PortOff:	clr.w	Saved
		move.l	CurrentPort,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	PortError

		bclr.b	d0,(a0)		;Turn bit on

		bsr	SendPort

		lea.l	OffText1,a0
		bsr	SetStatus
		bra	Window1IDCMP

TogglePort:	clr.w	Saved
		move.l	CurrentPort,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	PortError

		bchg.b	d0,(a0)		;Toggle bit

		push	d0/a0
		bsr	SendPort
		pull	d0/a0

		btst.b	d0,(a0)		;Test current
		beq	TogglePort2
		lea.l	OnText1,a0
		bra	TogglePort3

TogglePort2:	lea.l	OffText1,a0
TogglePort3:	bsr	SetStatus
		bra	Window1IDCMP

AllPortsOn:	clr.w	Saved

		move.l	#$ffffffff,Port1A
		move.w	#$ffff,Port2B

		bsr	SendAllPorts

		lea.l	OnText1,a0		;Send info to user
		bsr	SetStatus

		bra	Window1IDCMP

AllPortsOff:	clr.w	Saved

		clr.l	Port1A
		clr.w	Port2B

		bsr	SendAllPorts

		lea.l	OffText1,a0		;Send info to user
		bsr	SetStatus

		bra	Window1IDCMP

ToggleAll:	clr.w	Saved

		lea.l	Port1A,a0
		clr.l	d0
		clr.l	d1

ToggleAll2:	bchg.b	d0,(a0)
		add.l	#1,d0
		cmp.l	#8,d0
		bne	ToggleAll2

		tst.l	d1
		beq	ToggleAll3

		cmp.l	#1,d1
		beq	ToggleAll4

		cmp.l	#2,d1
		beq	ToggleAll5

		cmp.l	#3,d1
		beq	ToggleAll6

		cmp.l	#4,d1
		beq	ToggleAll7

		bra	ToggleAll8

ToggleAll3:	lea.l	Port1B,a0
		clr.l	d0
		move.l	#1,d1
		bra	ToggleAll2

ToggleAll4:	lea.l	Port1C,a0
		clr.l	d0
		move.l	#2,d1
		bra	ToggleAll2

ToggleAll5:	lea.l	Port2A,a0
		clr.l	d0
		move.l	#3,d1
		bra	ToggleAll2

ToggleAll6:	lea.l	Port2B,a0
		clr.l	d0
		move.l	#4,d1
		bra	ToggleAll2

ToggleAll7:	lea.l	Port2C,a0
		clr.l	d0
		move.l	#5,d1
		bra	ToggleAll2

ToggleAll8:	move.l	CurrentPort,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	PortError

		btst.b	d0,(a0)		;Test current
		beq	ToggleAll9
		lea.l	OnText1,a0
		bsr	SetStatus
		bra	ToggleAll10

ToggleAll9:	lea.l	OffText1,a0
		bsr	SetStatus

ToggleAll10:	bsr	SendAllPorts
		bra	Window1IDCMP

SendAllPorts:	move.b	#1,PortNum
		move.b	AText1,Port
		lea.l	Port1A,a0		;Change all
		bsr	SendPort

		move.b	BText1,Port
		lea.l	Port1B,a0
		bsr	SendPort

		move.b	CText1,Port
		lea.l	Port1C,a0
		bsr	SendPort

		move.b	#2,PortNum
		move.b	AText1,Port
		lea.l	Port2A,a0
		bsr	SendPort

		move.b	BText1,Port
		lea.l	Port2B,a0
		bsr	SendPort

		move.b	CText1,Port
		lea.l	Port2C,a0
		bsr	SendPort
		rts

;Inputs	a0 = Address to port
;
;PortNum & Port must be valid (ConvPort2Addr does this)

;CHANGE: Change this to send the data to the serial port and later on add
;support for checksums

SendPort:	move.b	(a0),Status
		bsr	Writer
		rts

PortError:	sub.l	a0,a0
		lib	Intuition,DisplayBeep
		lea.l	ErrorText1,a0
		bsr	SetStatus
		bra	Window1IDCMP

;Converts port number into address of status and according bit number
;
;Input	d0 = Port number
;
;Output	d0 = Bit number
;	a0 = Status address

ConvPort2Addr:	cmp.l	#0,d0
		bls	ConvPortError
		cmp.l	#9,d0
		bcs	ConvPort2Addr2		;Ports 1-8
		cmp.l	#17,d0
		bcs	ConvPort2Addr3		;Ports 9-16
		cmp.l	#25,d0
		bcs	ConvPort2Addr4		;Ports 17-24
		cmp.l	#33,d0
		bcs	ConvPort2Addr5		;Ports 25-32
		cmp.l	#41,d0
		bcs	ConvPort2Addr6		;Ports 33-40
		cmp.l	#40,d0
		bhi	ConvPort2Addr7		;Ports 41-48
ConvPortError:	move.l	#-1,d0			;Error! (Might add status gad)
		bra	ConvPort2Addr8
ConvPort2Addr2:	sub.w	#1,d0			;Get bit number
		lea.l	Port1A,a0		;Get port status address
		move.b	#1,PortNum
		move.b	AText1,Port
		bra	ConvPort2Addr8
ConvPort2Addr3:	sub.w	#1*8+1,d0		;Get bit number
		lea.l	Port1B,a0
		move.b	#1,PortNum
		move.b	BText1,Port
		bra	ConvPort2Addr8
ConvPort2Addr4:	sub.w	#2*8+1,d0		;Get bit number
		lea.l	Port1C,a0
		move.b	#1,PortNum
		move.b	CText1,Port
		bra	ConvPort2Addr8
ConvPort2Addr5:	sub.w	#3*8+1,d0		;Get bit number
		lea.l	Port2A,a0
		move.b	#2,PortNum
		move.b	AText1,Port
		bra	ConvPort2Addr8
ConvPort2Addr6:	sub.w	#4*8+1,d0		;Get bit number
		lea.l	Port2B,a0
		move.b	#2,PortNum
		move.b	BText1,Port
		bra	ConvPort2Addr8
ConvPort2Addr7:	sub.w	#5*8+1,d0		;Get bit number
		lea.l	Port2C,a0
		move.b	#2,PortNum
		move.b	CText1,Port
;		bra	ConvPort2Addr8		;Careful!
ConvPort2Addr8:	rts

Load:		cmp.l	#START_LOAD,d0
		bne	Load1
		move.l	FromFile,d1		;If set to something else
		bne	Load2
		lea.l	PrefsName,a0
		move.l	a0,d1
		bra	Load2

Load1:		move.l	AslReq,a0
		lea.l	LoadReqTags,a1
		lib	Asl,AslRequest
		tst.l	d0
		beq	Load_OUT0.1

		move.l	AslReq,a2
		move.l	rf_Dir(a2),d1
		move.l	#ACCESS_READ,d2
		lib	Dos,Lock
		move.l	d0,LoadLock
		beq	Load_ERR1

		move.l	LoadLock,d1
		lib	Dos,CurrentDir
		move.l	d0,LoadOldLock

		move.l	AslReq,a2
		move.l	rf_File(a2),d1

Load2:		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,PrefsFile
		beq	Load_ERR1

		move.l	PrefsFile,d1
		lea.l	Prefs,a0
		move.l	a0,d2
		move.l	#4,d3
		lib	Dos,Read
		cmp.l	#4,d0
		bne	Load_ERR2

		cmp.l	#CCFileVersion,Prefs
		bne	Load_ERR3

		move.l	PrefsFile,d1
		add.l	#4,d2
		move.l	#PrefsSize-4,d3
		lib	Dos,Read
		cmp.l	#PrefsSize-4,d0
		bne	Load_ERR2

Load3:		bsr	SetModes		;fixes startup datafile bug

		move.w	#1,Saved

;Close file

Load_OUT0.1:	move.l	PrefsFile,d1
		beq	Load_OUT0.2
		lib	Dos,Close
		clr.l	PrefsFile

;change back to dir where we started from and cleanup locks

Load_OUT0.2:	move.l	LoadOldLock,d1
		beq	Load_OUT0.3
		lib	Dos,CurrentDir
		clr.l	LoadOldLock
Load_OUT0.3:	move.l	LoadLock,d1
		beq	Load_OUT0.4
		lib	Dos,UnLock
		clr.l	LoadLock
Load_OUT0.4:

Load_OUT:	rts

Load_ERR1:	lea.l	File_ERRTxt1,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load3

Load_ERR2:	lea.l	File_ERRTxt2,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load3

Load_ERR3:	lea.l	File_ERRTxt3,a1
		sub.l	a2,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Load3

Save:		bsr	CheckModes

		move.l	AslReq,a0
		lea.l	SaveReqTags,a1
		lib	Asl,AslRequest
		tst.l	d0
		beq	Save_OUT

		move.l	AslReq,a2
		move.l	rf_Dir(a2),d1
		move.l	#ACCESS_READ,d2
		lib	Dos,Lock
		move.l	d0,LoadLock
		beq	Save_ERR1

		move.l	LoadLock,d1
		lib	Dos,CurrentDir
		move.l	d0,LoadOldLock

		move.l	AslReq,a2
		move.l	rf_File(a2),d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,PrefsFile
		beq	Save_ERR1

		move.l	#CCFileVersion,Prefs

		move.l	PrefsFile,d1
		lea.l	Prefs,a0
		move.l	a0,d2
		move.l	#PrefsSize,d3
		lib	Dos,Write
		cmp.l	#PrefsSize,d0
		bne	Save_ERR2

Save2:		move.w	#1,Saved

;change back to dir where we started from and cleanup locks

Save_OUT0.2:	move.l	LoadOldLock,d1
		beq	Save_OUT0.3
		lib	Dos,CurrentDir
		clr.l	LoadOldLock
Save_OUT0.3:	move.l	LoadLock,d1
		beq	Save_OUT0.4
		lib	Dos,UnLock
		clr.l	LoadLock
Save_OUT0.4:

Save_OUT:	move.l	PrefsFile,d1
		beq	Save_OUT1
		lib	Dos,Close
		clr.l	PrefsFile
Save_OUT1:	bra	Window1IDCMP

Save_ERR1:	lea.l	File_ERRTxt1,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		clr.w	Saved
		bra	Save_OUT0.2

Save_ERR2:	lea.l	File_ERRTxt2,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		clr.w	Saved
		bra	Save_OUT0.2

Print:		move.l	AslReq,a0
		lea.l	PrintReqTags,a1
		lib	Asl,AslRequest
		tst.l	d0
		beq	Print_OUT

		move.l	AslReq,a2
		move.l	rf_Dir(a2),d1
		beq	Print1
		move.l	#ACCESS_READ,d2
		lib	Dos,Lock
		move.l	d0,LoadLock
		beq	Print_ERR1

		move.l	LoadLock,d1
		lib	Dos,CurrentDir
		move.l	d0,LoadOldLock

Print1:		move.l	AslReq,a2
		move.l	rf_File(a2),d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,PrintFile
		beq	Print_ERR1

		lea.l	PrintHeader1,a0
		bsr	DoPrint

		lea.l	NameList,a2
		move.l	#1,d3

Print2:		move.l	d3,PrintBuffer1		;Port number

		move.l	a2,PrintBuffer2		;Name for port
		tst.b	(a2)
		bne	Print3
		lea.l	EmptyText1,a0
		move.l	a0,PrintBuffer2

Print3:		bsr	FormatPrint		;Format current line

		lea.l	PrintBuffer3,a0
		bsr	DoPrint			;Print current line
		tst.l	d0
		bne	Print_ERR2		;An error occured

		lea.l	CRLFText1,a0
		bsr	DoPrint

		add.l	#GADLENG1,a2		;Get start of next port

		add.l	#1,d3			;Increase port number
		cmp.l	#PortAmount+1,d3	;Was that the last one?
		bcs	Print2

		bra	Print_OUT

FormatPrint:	push	d3/a0-a4

		lea.l	PrintBuffer3,a0
		move.l	#PRINT_BUF_SIZE,d0
FormatPrint1:	clr.b	(a0)+
		dbf	d0,FormatPrint1

		lea.l	fstrl1,a0		;HEX->ASCII
		lea.l	PrintBuffer1,a1		;Stuff to print
		lea.l	PutChProc,a2
		lea.l	PrintBuffer3,a3		;Destination
		lib	Exec,RawDoFmt

		pull	d3/a0-a4
		rts

;Give this the pointer to text to print in a0

DoPrint:	push	d3/a0-a4
		move.l	PrintFile,d1
		move.l	a0,d2
		bsr	GetLength
		move.l	d0,d3
		lib	Dos,Write
		cmp.l	d3,d0
		bne	Print_ERR2
		clr.l	d0
		pull	d3/a0-a4
		rts

DoPrint2:	move.l	#-1,d0
		rts

Print_OUT:	move.l	LoadOldLock,d1
		beq	Print_OUT0.3
		lib	Dos,CurrentDir
		clr.l	LoadOldLock

Print_OUT0.3:	move.l	LoadLock,d1
		beq	Print_OUT0.4
		lib	Dos,UnLock
		clr.l	LoadLock

Print_OUT0.4:	move.l	PrintFile,d1
		beq	Print_OUT1
		lib	Dos,Close
		clr.l	PrintFile
Print_OUT1:	bra	Window1IDCMP

Print_ERR1:	lea.l	Print_ERRTxt1,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Print_OUT

Print_ERR2:	lea.l	Print_ERRTxt2,a1
		move.l	#$00,a2
		lea.l	OKTxt,a3
		bsr	DoAutoRequest
		bra	Print_OUT

About:		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		move.l	Window1,a0
		lea.l	AboutTxt1,a1
		sub.l	a2,a2		;positive text
		lea.l	OKTxt,a3	;a bit the wrong way around but...
		clr.l	d0
		clr.l	d1
		move.l	#320,d2
		move.l	#$50,d3
		lib	Intuition,AutoRequest
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

;This is emergency exit, that's why it changes the Saved-flag

Break:		lea.l	BreakText1,a0
		bsr	Printer
		move.l	#CLOSEWINDOW,d2		;fake closewindow...
		move.l	#-1,d0
		move.w	#1,Saved
		rts

RemGads:	move.l	Window1,a0
		lea.l	glist,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RemoveGList
		rts

AddGads:	move.l	Window1,a0
		lea.l	glist,a1
		sub.l	a2,a2
		move.l	#-1,d0
		move.l	#-1,d1
		lib	Intuition,AddGList

		lea.l	glist,a0
		move.l	Window1,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	Window1,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		rts

List1Off:	push	a3
		move.l	ListGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	ListOffTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		pull	a3
		rts

List1On:	push	a3
		move.l	CurrentPort,L1SelTagsNum
		sub.l	#1,L1SelTagsNum
		move.l	L1SelTagsNum,L1TopTagNum
		move.l	ListGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	List1OnTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		pull	a3
		rts

RemGads2:	move.l	Window2,a0
		lea.l	glist2,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RemoveGList
		rts

AddGads2:	move.l	Window2,a0
		lea.l	glist2,a1
		sub.l	a2,a2
		move.l	#-1,d0
		move.l	#-1,d1
		lib	Intuition,AddGList

		lea.l	glist2,a0
		move.l	Window2,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	Window2,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		rts

RemGads3:	move.l	Window3,a0
		lea.l	glist3,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RemoveGList
		rts

AddGads3:	move.l	Window3,a0
		lea.l	glist3,a1
		sub.l	a2,a2
		move.l	#-1,d0
		move.l	#-1,d1
		lib	Intuition,AddGList

		lea.l	glist3,a0
		move.l	Window3,a1
		sub.l	a2,a2
		move.l	#-1,d0
		lib	Intuition,RefreshGList

		move.l	Window3,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		rts

GetCurrentPort:	move.l	d3,CurrentPort
		add.l	#1,CurrentPort
		move.l	d3,PortPointer
		add.l	#1,PortPointer
		move.l	PortGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	PortGadTagList,a3
		lib	GadTools,GT_SetGadgetAttrsA
		move.l	CurrentPort,d0
		bsr	ConvPort2Addr

		btst.b	d0,(a0)
		beq	GetCurPort2
		lea.l	OnText1,a0
		bsr	SetStatus
		bra	GetCurPort_OUT

GetCurPort2:	lea.l	OffText1,a0
		bsr	SetStatus

GetCurPort_OUT:	bra	Window1IDCMP

;Inputs	a0 = Pointer to info text, or NULL to clear.

SetStatus:	move.l	a0,StatusPointer
		move.l	StatusGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	StatusGadTagList,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

SetModes:	tst.l	Window1
		beq	SetModes_OUT
		move.l	Window1,a0
		move.w	Alt1XPos,d0
		move.w	Alt1YPos,d1
		move.w	wd_Width(a0),d2
		move.w	wd_Height(a0),d3
		lib	Intuition,ChangeWindowBox
		rts
SetModes_OUT:	move.l	Alt1XPos,NewWindow1
		rts

CheckModes:	move.l	Window1,a0
		move.l	wd_LeftEdge(a0),Alt1XY
		rts

;Add all #PortAmount nodes to the portlist

MakePortList:	lea.l	NameList,a3
		clr.l	d3
		bsr	List1Off

MakePortList2:	bsr	Add
		add.l	#GADLENG1,a3
		add.l	#1,d3
		cmp.l	#PortAmount,d3
		bcs	MakePortList2
		bsr	List1On
		rts

;This adds an entry to the portlist
;
;Input	a3 = Name of this node

Add:		push	d3/a3
		move.l	#LN_SIZE,d0		;reserve memory for node
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
		lib	Exec,AllocMem
		tst.l	d0
		bne	Add1.1
		bsr	NoMem1
		rts
Add1.1:		move.l	d0,a2			;Memory to a2
		lea.l	PortList,a0		;Get list
		move.l	a2,a1			;a0=list, a1=node
		ADDTAIL				;Add node to list

		move.l	a3,a1			;Get name address
		tst.b	(a3)			;If no name
		bne	Add1.2			;then use '<Empty>'
		lea.l	EmptyText1,a1		;as a default string
Add1.2:		move.l	a1,LN_NAME(a2)		;Put name in LN_NAME
		pull	d3/a3
		rts

KillMem1:	lea.l	PortList,a3		;Get list
		IFEMPTY	a3,KillMem1_OUT		;See if empty

		TSTNODE	a3,a2			;Test and get next node
		beq	KillMem1_OUT		;(We are at end of list)
		move.l	a2,a1			;Get node
		REMOVE				;Remove from list

		move.l	a2,a1			;Get address of node
		move.l	#LN_SIZE,d0		;Get size
		lib	Exec,FreeMem		;Free memory used
		bra	KillMem1		;Do rest
KillMem1_OUT:	rts

ClearSer:	move.l	IORequest,a1
		lib	Exec,CheckIO
		tst.l	d0
		bne	ClearSer_OUT
		move.l	IORequest,a1
		lib	Exec,WaitIO
		move.l	IORequest,a1
		ABORTIO
ClearSer_OUT:	rts

Writer:		move.l	IORequest,a1
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		move.l	#CMD_LENGTH,IO_LENGTH(a1)
		lea.l	SerBuffer1,a0
		move.l	a0,IO_DATA(a1)
		lib	Exec,DoIO
		rts

Quit:		tst.w	Saved
		bne	ShutDown
		bsr	SleepPointer
		bsr	MenusOff
		bsr	RemGads

		lea.l	QuitTxt1,a1
		lea.l	OKTxt,a2
		lea.l	CancelTxt,a3
		bsr	DoAutoRequest
		tst.l	d0
		bne	Quit2
		bsr	AddGads
		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

Quit2:		bsr	MenusOn
		bsr	NormalPointer
		bsr	AddGads
		bra	ShutDown

ShutDown:	tst.w	SerOpen
		beq	ShutDown9900
		bsr	CloseSerial

ShutDown9900:	move.l	IORequest,a0
		lib	Exec,DeleteIORequest

		move.l	SWPort,a0
		lib	Exec,DeleteMsgPort

		tst.l	PubScreen
		beq	ShutDown9000
		sub.l	a0,a0
		move.l	PubScreen,a1
		lib	Intuition,UnlockPubScreen

ShutDown9000:	tst.l	CXBroker1
		beq	ShutDown8800

		lib	Exec,Forbid			;Remove all
		move.l	CXPort,a2			;pending messages
ClearCX1:	move.l	a2,a0
		flib	Exec,GetMsg
		tst.l	d0
		beq	ClearCX2
		move.l	d0,a1
		flib	Exec,ReplyMsg
		bra	ClearCX1
ClearCX2:	move.l	CXBroker1,a0
		lib	Commodities,DeleteCxObjAll
		lib	Exec,Permit

		bsr	KillMem1
		bsr	CloseWin1
		bsr	CloseWin2
		bsr	CloseWin3
		bsr	Clean2.0Magic

ShutDown8800:	move.l	PrefsFile,d1
		beq	ShutDown7900
		lib	Dos,Close

ShutDown7900:	move.l	PrintFile,d1
		beq	ShutDown7000
		lib	Dos,Close

ShutDown7000:	move.l	NILFile,d1
		beq	ShutDown6000
		lib	Dos,Close

ShutDown6000:	tst.l	DiskObject
		beq	ShutDown5000
		move.l	DiskObject,a0
		lib	Icon,FreeDiskObject

ShutDown5000:	move.l	LoadOldLock,d1
		beq	ShutDown4900
		lib	Dos,CurrentDir

ShutDown4900:	move.l	LoadLock,d1
		beq	ShutDown4800
		lib	Dos,UnLock

ShutDown4800:	move.l	OldLock,d1
		beq	ShutDown4050
		lib	Dos,CurrentDir

ShutDown4050:	move.l	WBMsg,d2
		beq	ShutDown3000
		lib	Exec,Forbid
		move.l	d2,a1
		flib	Exec,ReplyMsg
		flib	Exec,Permit		;Added, not checked

ShutDown3000:	move.l	RDArgs1,d1
		beq	ShutDown2500
		lib	Dos,FreeArgs

ShutDown2500:	tst.l	AslReq
		beq	ShutDown2000
		move.l	AslReq,a0
		lib	Asl,FreeFileRequest

ShutDown2000:	move.l	ARexxPort,a1			;Remove possible
		cmp.l	#$00,a1				;ports from lists
		beq	ShutDown1500			;and then delete
		lib	Exec,RemPort			;the ports

		flib	Exec,Forbid			;Remove all
		move.l	ARexxPort,a2			;pending messages

ClearARexx1:	move.l	a2,a0
		flib	Exec,GetMsg
		tst.l	d0
		beq	ClearARexx2
		move.l	d0,a1
		move.l	#RC_FATAL,RESULT1(a1)		;Fail all requests
		flib	Exec,ReplyMsg
		bra	ClearARexx1
ClearARexx2:	move.l	ARexxPort,a0
		flib	Exec,DeleteMsgPort
		flib	Exec,Permit

ShutDown1500:	move.l	CXPort,a0		;Messages cleared earlier
		lib	Exec,DeleteMsgPort

ShutDown1000:	closlib Icon
		closlib Intuition
		closlib	Commodities
		closlib GadTools
		closlib Asl
		closlib Dos

		pull	d2-d7/a2-a6
		clr.l	d0
		rts

;CheckIDCMP gets messages from keyboard (CTRL_C), ARexx, Intuition
;and commodities


CheckIDCMP:	clr.l	d0
		clr.l	d1
		cmp.l	#0,a3			;Window open?
		beq	CheckIDCMP1		;Nope ->
		move.l	$56(a3),a2		;Get window's port
		move.b	MP_SIGBIT(a2),d1	;IntuiMessages signals
		bset.l	d1,d0
		clr.l	d1			;Set signals for
CheckIDCMP1:	move.l	CXPort,a0		;commodities.library
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		clr.l	d1
		move.l	ARexxPort,a0		;ARexx
		move.b	MP_SIGBIT(a0),d1
		bset.l	d1,d0
		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break

		move.l	CXPort,a0		;If commodities.library
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0
		bne	C4GetMsg1

		move.l	ARexxPort,a0		;If ARexx
		move.b	MP_SIGBIT(a0),d1
		btst	d1,d0
		beq	CheckIDCMP_OUT

		bsr	DoARexx			;Go do ARexx magic
		rts
CheckIDCMP_OUT:	move.l	#-1,d0
		rts

C2GetMsg1:	cmp.l	#0,a3
		beq	CheckIDCMP
		clr.l	d2
		clr.l	d3
		sub.l	a4,a4
		sub.l	a5,a5
		move.l	$56(a3),a0		;Get window's port
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	CheckIDCMP
	
		move.l	d0,a1 
		move.l	im_Class(a1),d2		;answers with Class in d2,
		move.w	im_Code(a1),d3		;Code in d3 and
		move.w	im_Qualifier(a1),a4	;Qualifier in a4
		move.l	im_IAddress(a1),a5	;IAddress in a5
		lib	GadTools,GT_ReplyIMsg
C2GetMsg2:	move.l	#-1,d0
		rts

C4GetMsg1:	move.l	CXPort,a0
		lib	Exec,GetMsg
		tst.l	d0
		beq	C4GetMsg_OUT

		move.l	d0,a2			;Message in a2

		move.l	a2,a0
		lib	Commodities,CxMsgType
		move.l	d0,d2			;Type in d2

		move.l	a2,a0
		lib	Commodities,CxMsgID
		move.l	d0,d3			;ID in d3

		move.l	a2,a1
		lib	Exec,ReplyMsg

		bsr	CX			;Go do magic stuff
		tst.l	d0
		bne	C4GetMsg1		;Loop all messages
		rts

C4GetMsg_OUT:	move.l	#4,d0			;Return as CX
		rts

;Newer MenuNull subroutine

MenuNull:	move.w	d3,d0
		and.w	#$1f,d0
		move.w	d0,d6
		move.w	d3,d0
		lsr.w	#5,d0
		move.w	d0,d1
		and.w	#$3f,d0
		move.w	d0,d5
		lsr.w	#6,d1
		move.w	d1,d4
		rts

;open serial.device

OpenSerial:	cmp.w	#1,SerOpen
		beq	SkipSetParams
		lea.l	SerDevNBuffer1,a0
		move.l	SerUnit,d0
		move.l	IORequest,a1
		move.b	#SERF_SHARED,IO_SERFLAGS(a1)
		clr.l	d1				;no flags
		lib	Exec,OpenDevice
		tst.l	d0
		bne	OpenSerial_ERR
		move.w	#$1,SerOpen		;just to tell if open

		tst.l	Speed
		beq	SkipSetParams
		move.l	IORequest,a1
		clr.l	IO_LENGTH(a1)
		clr.l	IO_DATA(a1)
		move.w	#SDCMD_SETPARAMS,IO_COMMAND(a1)
		move.l	Speed,IO_BAUD(a1)
		lib	Exec,DoIO
		tst.l	d0
		beq	SkipSetParams
		bsr	NoSetSer
	
SkipSetParams:	move.l	#-1,d0
		rts
OpenSerial_ERR:	clr.l	d0
		rts

CloseSerial:	tst.w	SerOpen
		beq	CloseSer_OUT
		bsr	ClearSer
		move.l	IORequest,a1
		lib	Exec,CloseDevice
		clr.w	SerOpen
CloseSer_OUT:	rts

;ARexx interface

DoARexx:	move.l	ARexxPort,a0
		lib	Exec,GetMsg

		move.l	#4,d2			;answer to Window1IDCMP
		tst.l	d0
		beq	DoARexx_OUT

		move.l	d0,a5
		cmp.l	#RXCOMM,ACTION(a5)
		bne	DoARexxReply

		tst.l	ARG0(a5)		;No magic enforcer hits
		beq	DoARexxFail

		tst.w	OnOff			;We are off!
		beq	DoARexxFail

		lea.l	RexxFront,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxFront

		lea.l	RexxBack,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxBack

		lea.l	RexxZoom,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxZoom

		lea.l	RexxHide,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxHide

		lea.l	RexxShow,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxShow

		lea.l	RexxQuit,a0
		move.l	ARG0(a5),a1
		bsr	CmpStrings
		bne	DoRexxQuit

;Check to see if a port name was sent

		clr.l	d5

DoARexx2:	lea.l	NameList,a0
		move.l	d5,d2		;Get name port to do
		mulu.w	#GADLENG1,d2
		add.l	d2,a0
		move.l	ARG0(a5),a1
		bsr	GetLength
		move.l	d0,d3
		lib	Utility,Strnicmp
		tst.l	d0
		beq	DoARexxPort
		add.l	#1,d5
		cmp.l	#PortAmount,d5
		bcs	DoARexx2

DoARexxFail:	move.l	#RC_FATAL,RESULT1(a5)
		move.l	#4,d2
		bra	DoARexxReply

DoARexxOK:	move.l	#RC_OK,RESULT1(a5)
DoARexxReply:	move.l	a5,a1
		lib	Exec,ReplyMsg
DoARexx_OUT:	move.l	d2,d0
		rts

DoRexxFront:	bsr	ToFront
		move.l	#4,d2
		bra	DoARexxOK

DoRexxBack:	bsr	ToBack
		move.l	#4,d2
		bra	DoARexxOK

DoRexxZoom:	bsr	Zoom
		move.l	#4,d2
		bra	DoARexxOK

DoRexxHide:	bsr	DoCXDisappear
		move.l	#4,d2
		bra	DoARexxOK

DoRexxShow:	bsr	DoCXAppear
		move.l	#4,d2
		bra	DoARexxOK

DoRexxQuit:	clr.l	d2
		bra	DoARexxOK

;Inputs	d3 = Length of port name
;	d5 = Port number

DoARexxPort:	move.l	ARG0(a5),a2
		add.l	d3,a2

DoARexxPort2:	cmp.b	#' ',(a2)		;Skip possible spaces
		bne	DoARexxPort3
		add.l	#1,a2
		bra	DoARexxPort2

DoARexxPort3:	cmp.b	#'~',(a2)		;Find control character
		bne	DoARexxFail
		add.l	#1,a2
DoARexxPort4:	cmp.b	#' ',(a2)		;Skip possible spaces
		bne	DoARexxPort5
		add.l	#1,a2
		bra	DoARexxPort4

DoARexxPort5:	tst.b	(a2)
		beq	DoARexxFail
		move.l	a2,a1
		lea.l	ONText1,a0
		bsr	GetLength
		lib	Utility,Strnicmp

		tst.l	d0
		beq	DoARexxPort6		;Turn port on

		move.l	a2,a1
		lea.l	OFFText1,a0
		bsr	GetLength
		lib	Utility,Strnicmp

		tst.l	d0
		beq	DoARexxPort7		;Turn port off

		move.l	a2,a0
		lea.l	TOGText1,a1
		lib	Utility,Strnicmp

		tst.l	d0
		beq	DoARexxPort8		;Toggle port status

		bra	DoARexxFail		;Unknown command

DoARexxPort6:	clr.w	Saved
		move.l	d5,d0
		add.l	#1,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	DoARexxFail

		bset.b	d0,(a0)		;Turn bit on
		bsr	SendPort
		bra	DoARxPort_OUT

DoARexxPort7:	clr.w	Saved
		move.l	d5,d0
		add.l	#1,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	DoARexxFail

		bclr.b	d0,(a0)		;Turn bit off
		bsr	SendPort
		bra	DoARxPort_OUT

DoARexxPort8:	clr.w	Saved
		move.l	d5,d0
		add.l	#1,d0
		bsr	ConvPort2Addr
		tst.l	d0
		bmi	DoARexxFail

		bchg.b	d0,(a0)		;Toggle bit
		bsr	SendPort
;		bra	DoARxPort_OUT	;CAREFUL!!!

DoARxPort_OUT:	move.l	#4,d2
		bra	DoARexxOK

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

SleepPointer:	move.l	Window1,a0
		lea.l	ClockPointer1,a1
		move.l	#16,d0
		move.l	#16,d1			;WHAT-THE-HECK IS THIS FOR?
		move.l	#-6,d2
		move.l	#0,d3
		lib	Intuition,SetPointer
		rts

NormalPointer:	move.l	Window1,a0
		lib	Intuition,ClearPointer
		rts

MenusOn:	move.l	Window1,a0
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
		rts

MenusOff:	move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		rts

;Lock PublicScreen

LockPubScr:	sub.l	a0,a0
		lib	Intuition,LockPubScreen
		move.l	d0,PubScreen
		beq	LockPubScr_OUT

;Get some sizes

		move.l	PubScreen,a0
		move.b	sc_BarHeight(a0),d0
		add.b	#1,d0
		move.b	d0,BHeight+1
		move.w	BHeight,d5
		add.w	d5,SmallYSize
		add.w	d5,Win1YSize
		add.w	d5,Win2YSize
		add.w	d5,Win3YSize
LockPubScr_OUT: rts

;Open Window 1

OpenWin1:	tst.l	Window1
		bne	OpenWin1_OUT
		tst.l	OptionIconify
		beq	OpenWin1.01
		lea.l	NewWindow1,a0
		and.l	#~ACTIVATE,nw_Flags(a0)
		move.l	NewWindow1,ZoomXY
		move.l	NewWindow1+4,ZoomXY+4
		move.l	Alt1XY,nw_LeftEdge(a0)
		move.w	#160,nw_Width(a0)
		move.w	BHeight,nw_Height(a0)
OpenWin1.01:	lea.l	NewWindow1,a0
		lea.l	Win1TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window1
		beq	OpenWin1_ERR1
		bsr	AddGads			;Window refreshed here
		move.l	Window1,a0
		move.l	$32(a0),RP
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
OpenWin1_OUT:	move.l	#-1,d0
		rts
OpenWin1_ERR1:	clr.l	d0
		rts		

CloseWin1:	tst.l	Window1
		beq	CloseWin1_OUT
CloseWin1.1:	move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1,a3
		bsr	ClearMSGs
CloseWin1_OUT:	clr.l	Window1
		rts

;Open Window 2 (Port assignments)

OpenWin2:	lea.l	NewWindow2,a0
		lea.l	Win2TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window2
		beq	OpenWin2_ERR1
		move.l	Window2,a0
		move.l	mlist2,a1
		lib	Intuition,SetMenuStrip
		bsr	AddGads2		;Window refreshed here
		move.l	#-1,d0
		rts
OpenWin2_ERR1:	clr.l	d0
		rts		

CloseWin2:	tst.l	Window2
		beq	CloseWin2_OUT
		move.l	Window2,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window2,a3
		bsr	ClearMSGs
CloseWin2_OUT:	clr.l	Window2
		rts

;Open Window 3 (Serial settings)

OpenWin3:	lea.l	NewWindow3,a0
		lea.l	Win2TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window3
		beq	OpenWin3_ERR1
		bsr	AddGads3		;Window refreshed here
		move.l	#-1,d0
		rts
OpenWin3_ERR1:	clr.l	d0
		rts		

CloseWin3:	tst.l	Window3
		beq	CloseWin3_OUT
		move.l	Window3,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window3,a3
		bsr	ClearMSGs
CloseWin3_OUT:	clr.l	Window3
		rts

;ClearMsgs subroutine
;a3 = window structure

ClearMSGs:	lib	Exec,Forbid
		move.l	$56(a3),a2
ClearMsg1:	move.l	a2,a0	
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	ClearMsg2
		move.l	d0,a1
		flib	GadTools,GT_ReplyIMsg
		bra	ClearMsg1
ClearMsg2:	move.l	a3,a0
		lib	Intuition,CloseWindow
		lib	Exec,Permit
ClearMsg3:	rts

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
;		mulu.w	#10,d0
		move.l	#10,d1
		lib	Utility,UMult32
		pull	d1/a0
		add.l	d1,d0
		add.l	#1,a0
		bra	ConvASCII2
ConvASCII_OUT:	rts

Clean2.0Magic:	tst.b	GadMagic
		beq	Clean2.0M2
		move.l	glist,a0
		lib	GadTools,FreeGadgets
		move.l	glist2,a0
		lib	GadTools,FreeGadgets
		move.l	glist3,a0
		lib	GadTools,FreeGadgets

Clean2.0M2:	tst.b	MenuMagic
		beq	Clean2.0M3
		move.l	mlist,a0
		lib	GadTools,FreeMenus
		move.l	mlist2,a0
		lib	GadTools,FreeMenus

Clean2.0M3:	tst.l	vi
		beq	Clean2.0_OUT
		move.l	vi,a0
		lib	GadTools,FreeVisualInfo

Clean2.0_OUT:	rts

;Error etc. messages

NoMem1:		bsr	SleepPointer
		bsr	MenusOff

		lea.l	NoMemTxt1,a1
		bsr	DoAutoRequest

		bsr	MenusOn
		bsr	NormalPointer
		rts

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

NoMsgPort:	lea.l	NoMsgPortText1,a0
		bsr	Printer
		bra	ShutDown

NoMsgPort2:	lea.l	NoMsgPortText2,a0
		bsr	Printer
		bra	ShutDown

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoInt:		lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

NoGadTools:	lea.l	NoGTText1,a0
		bsr	Printer
		bra	ShutDown

NoAsl:		lea.l	NoAslText1,a0
		bsr	Printer
		bra	ShutDown

NoAslReq:	lea.l	NoAslReqText1,a0
		bsr	Printer
		bra	ShutDown

NoCommodities:	lea.l	NoCommoText1,a0
		bsr	Printer
		bra	ShutDown

NoUtility:	lea.l	NoUtilityText1,a0
		bsr	Printer
		bra	ShutDown

NoNIL:		lea.l	NoNILText1,a0
		bsr	Printer
		bra	ShutDown

NoNIL2:		lea.l	NoNILText1,a0
		bsr	Printer
		rts

NoIcon:		lea.l	NoIconText1,a0
		bsr	Printer
		bra	ShutDown

NoPubScreen:	lea.l	NoPubScrText1,a0
		bsr	Printer
		bra	ShutDown

NoWindow1:	lea.l	NoWindowText1,a0
		bsr	Printer
		bra	ShutDown

NoContextGad:	lea.l	NoContextText1,a0
		bsr	Printer
		bra	ShutDown

NoMenus:	lea.l	NoMenusText1,a0
		bsr	Printer
		bra	ShutDown

NoCommodity:	lea.l	NoCommodityText1,a0
		bsr	Printer
		bra	ShutDown

NoFilter:	lea.l	BadPopKeyText1,a0
		bsr	Printer
		bra	NoCommodity

BadPriority:	lea.l	BadPriorityText1,a0
		bsr	Printer
		bra	NoCommodity

NoIOReq:	lea.l	NoIOReqText1,a0
		bsr	Printer
		bra	ShutDown

NoSerial:	lea.l	NoSerialText1,a0
		bsr	Printer
		lea.l	SerDevNBuffer1,a0
		bsr	Printer
		lea.l	NoSerialText2,a0
		bsr	Printer
		bra	ShutDown

NoSetSer:	lea.l	NoSetSerText1,a0
		bsr	Printer
		rts

Printer:	printa	a0,_stdout
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

;Does a normal AutoRequest
;
;INPUT
;
;a1 = Main text body
;a2 = Pos text
;a3 = Neg text

DoAutoRequest:	clr.l	d0
		clr.l	d1
		clr.l	d2
		clr.l	d3
		sub.l	a0,a0		;No win, cos' might be here b4 anything open
		lib	Intuition,AutoRequest
		rts

;Reservations

		libnames

_SysBase:	dc.l	0
_DOSBase:	dc.l	0
_CxBase:	dc.l	0

;Options

RDArgs1:	dc.l	0

CLArray1:
FromFile:	dc.l	0		;A pointer to filename of PREFS!
OptionIconify:	dc.l	0
OptPubScreen:	dc.l	0		;A pointer to pubscreen name
OptCXPri:	dc.l	0
OptCXPopKey:	dc.l	DefaultPopKey	;A pointer to popkey string
OptCXPopUp:	dc.l	0		;A pointer to 'Yes'/'No'

;Serial device stuff

IORequest:	dc.l	0
SWPort:		dc.l	0
SerOpen:	dc.w	0

;GadTools stuff

vi:		dc.l	0		;Visual Info
mlist:		dc.l	0
mlist2:		dc.l	0
ContextGad:	dc.l	0
ContextGad2:	dc.l	0
ContextGad3:	dc.l	0
GadMagic:	dc.b	0
MenuMagic:	dc.b	0

;Gadgets

SaveGad1:	dc.l	0
QuitGad1:	dc.l	0

ListGad1:	dc.l	0

PortGad1:	dc.l	0
StatusGad1:	dc.l	0

SingleGad1:	dc.l	0		;Only a text string
OnGad1:		dc.l	0
OffGad1:	dc.l	0
ToggleGad1:	dc.l	0

AllGad1:	dc.l	0		;Only a text string
OnGad2:		dc.l	0
OffGad2:	dc.l	0
ToggleGad2:	dc.l	0

;Window 3 gadgets

SerGad1:	dc.l	0
SerGadBuf1:	dc.l	0		;Only a pointer!
SerGad2:	dc.l	0
SerGadInt2:	dc.l	0		;Only a pointer!
SerGad3:	dc.l	0
SerGadInt3:	dc.l	0		;Only a pointer!

OKGad1:		dc.l	0
CancelGad1:	dc.l	0

;Window 2 gadgets

Desc1Gad:	dc.l	0
StrGad1:	dc.l	0
StrGadBuf1:	dc.l	0		;Only a pointer!
StrGad2:	dc.l	0
StrGadBuf2:	dc.l	0		;Only a pointer!
StrGad3:	dc.l	0
StrGadBuf3:	dc.l	0		;Only a pointer!
StrGad4:	dc.l	0
StrGadBuf4:	dc.l	0		;Only a pointer!
StrGad5:	dc.l	0
StrGadBuf5:	dc.l	0		;Only a pointer!
StrGad6:	dc.l	0
StrGadBuf6:	dc.l	0		;Only a pointer!
StrGad7:	dc.l	0
StrGadBuf7:	dc.l	0		;Only a pointer!
StrGad8:	dc.l	0
StrGadBuf8:	dc.l	0		;Only a pointer!
NumGad1:	dc.l	0
NumGad2:	dc.l	0
NumGad3:	dc.l	0
NumGad4:	dc.l	0
NumGad5:	dc.l	0
NumGad6:	dc.l	0
NumGad7:	dc.l	0
NumGad8:	dc.l	0

;ASL Stuff

AslReq:		dc.l	0

;display stuff

PubScreen:	dc.l	0
Window1:	dc.l	0
Window2:	dc.l	0
Window3:	dc.l	0
BHeight:	dc.w	0
RP:		dc.l	0

		ds.w	0

;Other stuff, part I

OurTask:	dc.l	0
Page:		dc.w	0		;What page are we on ?
Saved:		dc.w	1		;0=No, 1=Yes
ARexxPort:	dc.l	0		;Our ARexx port
CurrentPort:	dc.l	1		;Number of last selection
CXPort:		dc.l	0		;Message port for commodities
CXBroker1:	dc.l	0		;Our commodities broker list
OnOff:		dc.w	0		;Are we on? 0 = Off, 1 = On
DisActive:	dc.w	0		;Can we be turned on/off?

;File stuff

PrefsFile:	dc.l	0
PrintFile:	dc.l	0
NILFile:	dc.l	0
_stdout:	dc.l	0
LoadLock:	dc.l	0
LoadOldLock:	dc.l	0
WBMsg:		dc.l	0
DiskObject:	dc.l	0
OldLock:	dc.l	0

;Strings, error & other info

BreakText1:	dc.b	"***Break",13,10,0
NoMsgPortText1: dc.b	"ERROR: Couldn't open message port!",13,10,0
NoMsgPortText2: dc.b	"ERROR: An ARexx port with the name 'CCONTROL' already exists!",13,10,0
NoIntText1:	dc.b	"ERROR: Couldn't open intuition.library!",13,10,0
NoCommoText1:	dc.b	"ERROR: Couldn't open commodities.library!",13,10,0
NoGTText1:	dc.b	"ERROR: Couldn't open gadtools.library!",13,10,0
NoAslText1:	dc.b	"ERROR: Couldn't open asl.library!",13,10,0
NoAslReqText1:	dc.b	"ERROR: Couldn't allocate ASL requester!",13,10,0
NoUtilityText1:	dc.b	"ERROR: Couldn't open utility.library!",13,10,0
NoNILText1:	dc.b	"ERROR: Couldn't open device NIL:!",13,10,0
NoIconText1:	dc.b	"ERROR: Couldn't open icon.library!",13,10,0
NoPubScrText1:	dc.b	"ERROR: Couldn't lock PublicScreen!",13,10,0
NoContextText1: dc.b	"ERROR: Couldn't create context gadget!",13,10,0
NoMenusText1:	dc.b	"ERROR: Couldn't allocate menus structure!",13,10,0
NoWindowText1:	dc.b	"ERROR: Couldn't open window!",13,10,0
NoCommodityText1: dc.b	"ERROR: Couldn't create commodity!",13,10,0
BadPopKeyText1:	dc.b	"ERROR: Bad hotkey setting!",13,10,0
BadPriorityText1: dc.b	"ERROR: Bad priority value!",13,10,0
NoMemText1:	dc.b	"ERROR: Out of memory!",0
NoIOReqText1:	dc.b	"ERROR: Couldn't get SerialIOReq!",13,10,0
NoSetSerText1:	dc.b	"ERROR: Couldn't set parameters for device!",13,10,0
NoSerialText1:	dc.b	"ERROR: Couldn't open ",0
SerName2:	dc.b	"serial.device",0
NoSerialText2:	dc.b	13,10,0
File_ERRText1:	dc.b	"Couldn't open preferences file!",0
File_ERRText2:	dc.b	"File error!",0
File_ERRText3:	dc.b	"Incorrect file type or version!",0
Print_ERRText1:	dc.b	"Couldn't open print file!",0
Print_ERRText2:	dc.b	"Error while printing!",0
OnText1:	dc.b	"On",0
OffText1:	dc.b	"Off",0
ErrorText1:	dc.b	"Error",0

;Strings, names

CLTemplate1:	dc.b	"FROM/K,I=ICONIFY/S,PS=PUBSCREEN/K,"	;Cont'd
		dc.b	"PRI=CX_PRIORITY/N/K,PK=CX_POPKEY/K,PU=CX_POPUP/K",0
CCVersion:	dc.b	"$VER: CompleteControl "
		PROGVERSION
		dc.b	" (c) Copyright Tomi Blinnikka 1993",0
OKText1:	dc.b	"OK",0
CancelText1:	dc.b	"Cancel",0
PrefsName:	dc.b	"ENVARC:"
PrefsName2:	dc.b	"CompleteControl.PREFS",0
NormalDir:	dc.b	"ENVARC:",0
PrintFileName:	dc.b	"PRT:",0
NILName:	dc.b	"NIL:",0
ICONIFYText1:	dc.b	"ICONIFY",0
PUBSCREENText1:	dc.b	"PUBSCREEN",0
CXPOPUPText1:	dc.b	"CX_POPUP",0
CXPOPKEYText1:	dc.b	"CX_POPKEY",0
CXPRIText1:	dc.b	"CX_PRIORITY",0
DefaultPopKey:	dc.b	"ctrl alt v",0
YESText1:	dc.b	"YES",0
NOText1:	dc.b	"NO",0
FROMText1:	dc.b	"FROM",0
ONText1:	dc.b	"ON",0
OFFText1:	dc.b	"OFF",0
TOGText1:	dc.b	"TOG",0
AboutText1:	dc.b	"Name   : CompleteControl",0
AboutText2:	dc.b	"Version: "
		PROGVERSION
		dc.b	0
AboutText3:	dc.b	"Author : Tomi Blinnikka",0
AboutText4:	dc.b	"  (c) Copyright  1993",0
QuitText1:	dc.b	"The current preferences and/or",0
QuitText2:	dc.b	"port states have NOT been saved!",0
QuitText3:	dc.b	"Are you sure you want to quit?",0
CCName1:	dc.b	"CompleteControl",0
CCName2:	dc.b	"Port assignments",0
CCName3:	dc.b	"Serial settings",0
LoadText1:	dc.b	"Load preferences",0
SaveText1:	dc.b	"Save preferences",0
PrintText1:	dc.b	"Print port assignments",0

EmptyText1:	dc.b	"<Empty>",0
CRLFText1:	dc.b	13,10,0
AText1:		dc.b	"A",0
BText1:		dc.b	"B",0
CText1:		dc.b	"C",0

PrintHeader1:	dc.b	"Port #		Name",13,10
		dc.b	"=================================",13,10,0
fstrl1:		dc.b	"%ld		%s",0

CCTitle:	dc.b	"Complete Control Panel:",0
CCDesc:		dc.b	"Control devices connected to system",0

;ARexx strings

ARexxPortName:	dc.b	"CCONTROL",0

;Window control

RexxFront:	dc.b	"FRONT",0
RexxBack:	dc.b	"BACK",0
RexxZoom:	dc.b	"ZOOM",0
RexxHide:	dc.b	"HIDE",0
RexxShow:	dc.b	"SHOW",0

;Misc

;RexxLoad:	dc.b	"LOAD",0		;How-da-heck?

RexxOn:		dc.b	"ON",0
RexxOff:	dc.b	"OFF",0
RexxQuit:	dc.b	"QUIT",0

		ds.w	0

;New screen & new window structures

NewWindow1:	dc.w	150,31			;X,Y POS
		dc.w	407			;WIDTH
Win1YSize:	dc.w	160			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!CLOSEWINDOW!RAWKEY!VANILLAKEY!MENUPICK!BUTTONIDCMP!LISTVIEWIDCMP	;IDCMP FLAGS
		dc.l	WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	CCName1			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win1TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	WA_Zoom,ZoomXY
		dc.l	TAG_DONE,0

ZoomXY:
SmallXPos:	dc.w	10
SmallYPos:	dc.w	21
SmallXSize:	dc.w	160
SmallYSize:	dc.w	0

NewWindow2:	dc.w	220,42			;X,Y POS
		dc.w	190			;WIDTH
Win2YSize:	dc.w	12*NUMGADS+7		;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!ACTIVEWINDOW!CLOSEWINDOW!VANILLAKEY!MENUPICK!GADGETUP	;IDCMP FLAGS
		dc.l	WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	CCName2			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win2TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	TAG_DONE,0

NewWindow3:	dc.w	220,42			;X,Y POS
		dc.w	200			;WIDTH
Win3YSize:	dc.w	100			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!ACTIVEWINDOW!CLOSEWINDOW!VANILLAKEY!GADGETUP	;IDCMP FLAGS
		dc.l	WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	CCName3			;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE


;Fonts

Topaz:		dc.l	TopazName
		dc.w	8
		dc.b	0
		dc.b	0
TopazName:	dc.b	"topaz.font",0
		ds.w	0

;ASL stuff

AslReqTags:	dc.l	ASL_Window
		dc.l	0			;Move window pointer here!
		dc.l	TAG_DONE,0
LoadReqTags:	dc.l	ASL_Hail,LoadText1
		dc.l	ASL_Dir,NormalDir
		dc.l	ASL_File,PrefsName2
		dc.l	ASL_FuncFlags,0
		dc.l	TAG_DONE,0
SaveReqTags:	dc.l	ASL_Hail,SaveText1
		dc.l	ASL_Dir,NormalDir
		dc.l	ASL_File,PrefsName2
		dc.l	ASL_FuncFlags,FILF_SAVE
		dc.l	TAG_DONE,0
PrintReqTags:	dc.l	ASL_Hail,PrintText1
		dc.l	ASL_Dir,0
		dc.l	ASL_File,PrintFileName
		dc.l	ASL_FuncFlags,FILF_SAVE
		dc.l	TAG_DONE,0

;ITextStructures

OKTxt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OKText1			;TEXT
		dc.l	0			;NEXTTEXT

CancelTxt:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	CancelText1		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText1		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText2		;TEXT
		dc.l	0			;NEXTTEXT

File_ERRTxt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	File_ERRText3		;TEXT
		dc.l	0			;NEXTTEXT

Print_ERRTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Print_ERRText1		;TEXT
		dc.l	0			;NEXTTEXT

Print_ERRTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	Print_ERRText2		;TEXT
		dc.l	0			;NEXTTEXT

AboutTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText1		;TEXT
		dc.l	AboutTxt2		;NEXTTEXT

AboutTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText2		;TEXT
		dc.l	AboutTxt3		;NEXTTEXT

AboutTxt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,20			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText3		;TEXT
		dc.l	AboutTxt4		;NEXTTEXT

AboutTxt4:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	AboutText4		;TEXT
		dc.l	0 ;AboutTxt5		;NEXTTEXT

QuitTxt1:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,0			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	QuitText1		;TEXT
		dc.l	QuitTxt2		;NEXTTEXT

QuitTxt2:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	QuitText2		;TEXT
		dc.l	QuitTxt3		;NEXTTEXT

QuitTxt3:	dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,30			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	QuitText3		;TEXT
		dc.l	0 ;QuitTxt4		;NEXTTEXT

NoMemTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NoMemText1		;TEXT
		dc.l	0			;NEXTTEXT

;Gadgets

SaveGadText1:	dc.b	"_Save...",0
QuitGadText1:	dc.b	"_Quit",0
ListGadText1:	dc.b	"Ports",0

PortGadText1:	dc.b	"Port:",0
StatusGadText1:	dc.b	"Status:",0

SingleGadText1:	dc.b	"Single:",0
OnGadText1:	dc.b	"O_n",0
OffGadText1:	dc.b	"O_ff",0
ToggleGadText1:	dc.b	"To_ggle",0

AllGadText1:	dc.b	"All:",0
OnGadText2:	dc.b	"On",0
OffGadText2:	dc.b	"Off",0
ToggleGadText2:	dc.b	"Toggle",0

SerGadText1:	dc.b	"Device name",0
SerGadText2:	dc.b	"Unit",0
SerGadText3:	dc.b	"Speed",0

OKGadText1:	dc.b	"_OK",0
CancelGadText1:	dc.b	"_Cancel",0

DescGadText1:	dc.b	"Port",0
DescGadText2:	dc.b	"Description",0
		ds.w	0

glist:		dcb.b	gg_SIZEOF,0
glist2:		dcb.b	gg_SIZEOF,0
glist3:		dcb.b	gg_SIZEOF,0

NGSaveGad:	dc.w	10		;gng_LeftEdge
		dc.w	OptionTop	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	SaveGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	98		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGQuitGad:	dc.w	-80		;gng_LeftEdge
		dc.w	OptionTop	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	QuitGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	99		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGListGad:	dc.w	10		;gng_LeftEdge
		dc.w	ListTop		;gng_TopEdge
		dc.w	200		;gng_Width
		dc.w	120		;gng_Height
		dc.l	ListGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	55		;gng_GadgetID
		dc.l	PLACETEXT_ABOVE	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGPortGad:	dc.w	280		;gng_LeftEdge
		dc.w	InfoTop		;gng_TopEdge
		dc.w	40		;gng_Width
		dc.w	12		;gng_Height
		dc.l	PortGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStatusGad:	dc.w	280		;gng_LeftEdge
		dc.w	InfoTop+1*12	;gng_TopEdge
		dc.w	100		;gng_Width
		dc.w	12		;gng_Height
		dc.l	StatusGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSingleGad:	dc.w	229		;gng_LeftEdge
		dc.w	ActionTop-1*12	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	SingleGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOnGad:	dc.w	229		;gng_LeftEdge
		dc.w	ActionTop+0*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OnGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	20		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOffGad:	dc.w	229		;gng_LeftEdge
		dc.w	ActionTop+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OffGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	21		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGToggleGad:	dc.w	229		;gng_LeftEdge
		dc.w	ActionTop+2*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	ToggleGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	22		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGAllGad:	dc.w	229+1*(70+(2*INTERWIDTH))	;gng_LeftEdge
		dc.w	ActionTop-1*12	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	AllGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOnGad2:	dc.w	229+1*(70+(2*INTERWIDTH))	;gng_LeftEdge
		dc.w	ActionTop+0*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OnGadText2	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	30		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOffGad2:	dc.w	229+1*(70+(2*INTERWIDTH))	;gng_LeftEdge
		dc.w	ActionTop+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OffGadText2	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	31		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGToggleGad2:	dc.w	229+1*(70+(2*INTERWIDTH))	;gng_LeftEdge
		dc.w	ActionTop+2*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	ToggleGadText2	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	32		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Gadget TagLists

GadTagList:	dc.l	GT_Underscore,'_'
		dc.l	TAG_DONE,0

ListGadTagList:	dc.l	GTLV_ShowSelected,0
		dc.l	TAG_DONE,0

ListOffTags:	dc.l	GTLV_Labels,0
		dc.l	TAG_DONE,0

List1OnTags:	dc.l	GTLV_Labels,PortList
List1SelTags:	dc.l	GTLV_Selected
L1SelTagsNum	dc.l	0
		dc.l	GTLV_Top
L1TopTagNum:	dc.l	0
		dc.l	TAG_DONE,0


PortGadTagList:	dc.l	GTNM_Number
PortPointer:	dc.l	0
		dc.l	TAG_DONE,0

StatusGadTagList: dc.l	GTTX_Text
StatusPointer:	dc.l	0
		dc.l	TAG_DONE,0

;Gadgets for serial settings window

NGSerGad1:	dc.w	10		;gng_LeftEdge
		dc.w	ShellTop+5	;gng_TopEdge
		dc.w	GADWIDTH2	;gng_Width
		dc.w	12		;gng_Height
		dc.l	SerGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	PLACETEXT_BELOW	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSerGad2:	dc.w	10		;gng_LeftEdge
		dc.w	ShellTop+25+INTERHEIGHT	;gng_TopEdge
		dc.w	GADWIDTH3	;gng_Width
		dc.w	12		;gng_Height
		dc.l	SerGadText2	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	PLACETEXT_BELOW	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSerGad3:	dc.w	10		;gng_LeftEdge
		dc.w	ShellTop+45+INTERHEIGHT+INTERHEIGHT	;gng_TopEdge
		dc.w	GADWIDTH3	;gng_Width
		dc.w	12		;gng_Height
		dc.l	SerGadText3	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	PLACETEXT_BELOW	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOKGad1:	dc.w	10		;gng_LeftEdge
		dc.w	NegativeTop	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OKGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	96		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGCancelGad1:	dc.w	-80		;gng_LeftEdge
		dc.w	NegativeTop	;gng_TopEdge
		dc.w	70		;gng_Width
		dc.w	12		;gng_Height
		dc.l	CancelGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	97		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Taglists

SerGadTagList:	dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,GADLENG2-2
		dc.l	TAG_DONE,0

SerGadTagList2:	dc.l	GT_Underscore,'_'
		dc.l	GTIN_MaxChars,GADLENG3-2
		dc.l	TAG_DONE,0

SerGadTagList3:	dc.l	GT_Underscore,'_'
		dc.l	GTIN_MaxChars,GADLENG3-2
		dc.l	TAG_DONE,0

SerGadTagList4:	dc.l	GTIN_Number
GadUnit:	dc.l	0
		dc.l	TAG_DONE,0

SerGadTagList5:	dc.l	GTIN_Number
GadSpeed:	dc.l	0
		dc.l	TAG_DONE,0

;Gadgets for SetPorts window

NGDesc1Gad:	dc.w	10		;gng_LeftEdge
		dc.w	ShellTop	;gng_TopEdge
		dc.w	40		;gng_Width
		dc.w	12		;gng_Height
		dc.l	DescGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGDesc2Gad:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	DescGadText2	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad1:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+15	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad2:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+25	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad3:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+35	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad4:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+45	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad5:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+55	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad6:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+65	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad7:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+75	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGStrGad8:	dc.w	60		;gng_LeftEdge
		dc.w	ShellTop+85	;gng_TopEdge
		dc.w	GADWIDTH1	;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	2		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNumGad1:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+15	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData


NGNumGad2:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+25	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNumGad3:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+35	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData


NGNumGad4:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+45	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNumGad5:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+55	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNumGad6:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+65	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNumGad7:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+75	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGNumGad8:	dc.w	26		;gng_LeftEdge
		dc.w	ShellTop+85	;gng_TopEdge
		dc.w	20		;gng_Width
		dc.w	12		;gng_Height
		dc.l	0		;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	1		;gng_GadgetID
		dc.l	0		;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

DescGadTagList: dc.l	GTTX_Border,1
		dc.l	TAG_DONE,0

StrGadTagList1: dc.l	GTST_MaxChars,GADLENG1-2
		dc.l	TAG_DONE,0
NumGadTagList1: dc.l	GTNM_Number
NumText:	dc.l	1
		dc.l	TAG_DONE,0


;Menus

Menu1Name:	dc.b	"Project",0
Menu2Name:	dc.b	"Preferences",0

LoadMenuText1:	dc.b	"Load...",0
LoadCommKey:	dc.b	"L",0
SaveAsMenuText1: dc.b	"Save as...",0
SaveAsCommKey:	dc.b	"A",0
AboutMenuText1: dc.b	"About...",0
AboutCommKey:	dc.b	"?",0
PrintMenuText1:	dc.b	"Print...",0
PrintCommKey:	dc.b	"P",0
QuitMenuText1:	dc.b	"Quit",0
QuitCommKey:	dc.b	"Q",0
SerMenuText1:	dc.b	"Serial...",0
SerCommKey:	dc.b	"E",0
PrefsMenuText1:	dc.b	"Port names...",0
PrefsCommKey:	dc.b	"R",0

Menu1Name2:	dc.b	"Page",0
PrefsMenu1Text1: dc.b	"Ports   1-8",0
Prefs1CommKey:	dc.b	"1",0
PrefsMenu2Text1: dc.b	"Ports  9-16",0
Prefs2CommKey:	dc.b	"2",0
PrefsMenu3Text1: dc.b	"Ports 17-24",0
Prefs3CommKey:	dc.b	"3",0
PrefsMenu4Text1: dc.b	"Ports 25-32",0
Prefs4CommKey:	dc.b	"4",0
PrefsMenu5Text1: dc.b	"Ports 33-40",0
Prefs5CommKey:	dc.b	"5",0
PrefsMenu6Text1: dc.b	"Ports 41-48",0
Prefs6CommKey:	dc.b	"6",0
		ds.l	0

MNProjectMenu1: dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNLoad1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	LoadMenuText1		;gnm_Label
		dc.l	LoadCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSaveAs1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SaveAsMenuText1		;gnm_Label
		dc.l	SaveAsCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNAbout1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	AboutMenuText1		;gnm_Label
		dc.l	AboutCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP1SepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPrint1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrintMenuText1		;gnm_Label
		dc.l	PrintCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP1SepMenu2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNQuit1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	QuitMenuText1		;gnm_Label
		dc.l	QuitCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPrefsMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu2Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSer1:		dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SerMenuText1		;gnm_Label
		dc.l	SerCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPrefs1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenuText1		;gnm_Label
		dc.l	PrefsCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;NM_END?

;Menu TagList(s)

MenuTagList:	dc.l	GTMN_Menu,MNProjectMenu1
		dc.l	TAG_DONE,0

MNPageMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name2		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenu1Text1		;gnm_Label
		dc.l	Prefs1CommKey		;gnm_CommKey
		dc.w	CHECKIT!CHECKED		;gnm_Flags
		dc.l	~1			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenu2Text1		;gnm_Label
		dc.l	Prefs2CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~2			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage3:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenu3Text1		;gnm_Label
		dc.l	Prefs3CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~4			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage4:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenu4Text1		;gnm_Label
		dc.l	Prefs4CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~8			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage5:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenu5Text1		;gnm_Label
		dc.l	Prefs5CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~16			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPage6:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrefsMenu6Text1		;gnm_Label
		dc.l	Prefs6CommKey		;gnm_CommKey
		dc.w	CHECKIT			;gnm_Flags
		dc.l	~32			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP2SepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNQuit2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	QuitMenuText1		;gnm_Label
		dc.l	QuitCommKey		;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

		dc.w	0			;NM_END?

;Menu TagList(s) for Prefs window

MenuTagList2:	dc.l	GTMN_Menu,MNPageMenu1
		dc.l	TAG_DONE,0

;Commodities stuff (Brokers etc..)

NewBroker1:	dc.b NB_VERSION,0		;Version, Reserved 1
		dc.l CCName1,CCTitle,CCDesc	;Name, Title, Description
		dc.w NBU_UNIQUE!NBU_NOTIFY,COF_SHOW_HIDE	;Uniq, Flags
NBPri:		dc.b 0,0			;Priority, Reserved 2
		dc.l 0				;Port
		dc.w 0				;Reserved channel

PREFS_START:

Prefs:		dc.l	CCFileVersion

SerDevNBuffer1:	dc.b	"serial.device"
		dcb.b	32-13,0		;device name
SerUnit:	dc.l	0
Speed:		dc.l	9600

NameList:	dcb.b	(PortAmount*GADLENG1),0

Port1A:		dc.b	0		;Ports 1-8
Port1B:		dc.b	0		;Ports 9-16
Port1C:		dc.b	0		;Ports 17-24

Port2A:		dc.b	0		;Ports 25-32
Port2B:		dc.b	0		;Ports 33-40
Port2C:		dc.b	0		;Ports 41-48

Future1:	dc.l	0
Future2:	dc.l	0
Future3:	dc.l	0
Future4:	dc.l	0

Alt1XY:
Alt1XPos:	dc.w	200
Alt1YPos:	dc.w	31

PREFS_END:	dc.l	0,0

PrefsSize:	EQU	(PREFS_END-PREFS_START)


;Buffers etc.

PrintBuffer1:	dc.l	0
PrintBuffer2:	dc.l	0

SerBuffer1:	dc.b	"*"		;The magic character
PortNum:	dc.b	0
Port:		dc.b	0
Status:		dc.b	0

		Section CC,BSS

PrintBuffer3:	ds.b	PRINT_BUF_SIZE

PortList:	ds.l	LN_SIZE


		Section CC,DATA,CHIP

		ds.w	0

ClockPointer1:	dc.w	$0000,$0000
		dc.w	$0400,$07C0,$0000,$07C0,$0100,$0380,$0000,$07E0
		dc.w	$07C0,$1FF8,$1FF0,$3FEC,$3FF8,$7FDE,$3FF8,$7FBE
		dc.w	$7FFC,$FF7F,$7EFC,$FFFF,$7FFC,$FFFF,$3FF8,$7FFE
		dc.w	$3FF8,$7FFE,$1FF0,$3FFC,$07C0,$1FF8,$0000,$07E0
		dc.w	$0000,$0000

		end
