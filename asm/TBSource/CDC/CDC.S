*************************************************
*						*
*		(C)opyright 1992		*
*						*
*		 Tomi Blinnikka			*
*						*
*	Don't try to understand the code	*
*						*
* Version 0.01	16/10/1992-			*
*	 -0.99ö	20/07/1993			*
*						*
*************************************************

	INCLUDE	"JMPLibs.i"
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/nodes.i"
	INCLUDE	"exec/lists.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"exec/tasks.i"
	INCLUDE	"libraries/asl.i"
	INCLUDE	"libraries/dosextens.i"
	INCLUDE	"libraries/dos.i"
	INCLUDE	"libraries/gadtools.i"
	INCLUDE "workbench/startup.i"

	INCLUDE	"XREF:2.0.xref"
	INCLUDE	"XREF:intuition.xref"
	INCLUDE	"XREF:exec.xref"
	INCLUDE	"XREF:dos.xref"
	INCLUDE	"XREF:icon.xref"

OptionTop:	EQU	37
OptionTop2:	EQU	27
OptionTop3:	EQU	20
ListTop:	EQU	25
StrTop:		EQU	INTERHEIGHT

AlbumSize:	EQU	64+64
TrackSize:	EQU	64+10+10

FALSE:		EQU	0
TRUE:		EQU	1

BREAK_QUIT:	EQU	$DEADBEEF

		STRUCTURE  ALBUM,LN_SIZE
		    STRUCT  AL_Name,64
		    STRUCT  AL_Artist,64
		    LABEL   ALBUM_SIZE

		STRUCTURE  TRACK,LN_SIZE
		    STRUCT  TR_Name,64
		    STRUCT  TR_Minutes,10
		    STRUCT  TR_Seconds,10
		    LABEL   TRACK_SIZE

		section	CDC,CODE

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

OpenDos:	openlib	Dos,NoDos		;Keep at beginning
		openlib	Utility,NoUtility

		tst.l	WBMsg
		beq	CLIStart

		lea.l	NILName,a0
		move.l	a0,d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,NILFile
		beq	ShutDown
		move.l	NILFile,_stdout
		beq	NoNIL

		openlib	Icon,NoIcon

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

		move.l	DiskObject,a4
		move.l	$36(a4),a0		;do_ToolTypes
		lea.l	DEVICEText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType1
;		move.l	d0,SerName

;See VShell(for tooltype)/SimCheat(for args)

DoToolType1:	move.l	$36(a4),a0		;do_ToolTypes
		lea.l	UNITText1,a1
		lib	Icon,FindToolType
		tst.l	d0
		beq	DoToolType2
		move.l	d0,a0
		bsr	ConvASCII
		tst.l	d0
		beq	DoToolType2
;		move.l	d0,SerUnit

DoToolType2:
		bra	MainStart

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

MainStart:	openlib	Intuition,NoInt
		openlib	GadTools,NoGadTools
		openlib	Asl,NoAsl

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
		move.l	d0,ContextGad2
		beq	NoContextGad

		move.l	glist,a0
		move.w	BHeight,d5

		lea.l	NGAddGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,AddGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGRemoveGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,RemoveGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGEditGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,EditGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGTracksGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,TracksGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGListGad,a1
		move.l	#LISTVIEW_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	ListGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,ListGad1

		lea.l	NGTopGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,TopGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGUpGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,UpGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGDownGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,DownGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGBottomGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,BottomGad1
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGSortGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,SortGad1
		add.w	d5,gg_TopEdge(a0)
		or.w	#GADGDISABLED,gg_Flags(a0)

		lea.l	NGTotalGad,a1
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,TotalGad1
		add.w	d5,gg_TopEdge(a0)

		move.b	#1,GadMagic		;1st Make worked OK
		lea.l	NewWindow1,a0
		lea.l	glist,a1
		move.l	a1,nw_FirstGadget(a0)

;Gadgets for Window 2

		lea.l	glist2,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad3
		beq	NoContextGad

		move.l	glist2,a0

		lea.l	NGAddGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,AddGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGRemoveGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,RemoveGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGEditGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,EditGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGListGad,a1
		lea.l	ListGadText2,a3
		move.l	a3,gng_GadgetText(a1)
		move.l	#LISTVIEW_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	ListGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,ListGad2

		lea.l	NGTopGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,TopGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGUpGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,UpGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGDownGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,DownGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGBottomGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,BottomGad2
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGSortGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,SortGad2
		add.w	d5,gg_TopEdge(a0)
		or.w	#GADGDISABLED,gg_Flags(a0)

		lea.l	NGTotalGad,a1
		move.l	#NUMBER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,TotalGad2
		add.w	d5,gg_TopEdge(a0)

		move.b	#1,GadMagic2		;Make worked OK
		lea.l	NewWindow2,a0
		lea.l	glist2,a1
		move.l	a1,nw_FirstGadget(a0)

;Gadgets for window 3

		lea.l	glist3,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad4
		beq	NoContextGad

		move.l	glist3,a0

		lea.l	NGAlbumStrGad1,a1
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	AlbumGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,AlbumGad1
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),AlbumGadBuf1
;		or.w	#GADGIMMEDIATE!RELVERIFY,gg_Activation(a0)
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGArtistGad1,a1
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	ArtistGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,ArtistGad1
		move.l	d0,a0
		move.l	gg_SpecialInfo(a0),a1
		move.l	(a1),ArtistGadBuf1
;		or.w	#GADGIMMEDIATE!RELVERIFY,gg_Activation(a0)
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGOKGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,OKGad1
		add.w	d5,gg_TopEdge(a0)
		or.w	#GRELBOTTOM,gg_Flags(a0)

		lea.l	NGCancelGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,CancelGad1
		add.w	d5,gg_TopEdge(a0)
		or.w	#GRELBOTTOM!GRELRIGHT,gg_Flags(a0)

		move.b	#1,GadMagic3		;Make worked OK
		lea.l	NewWindow3,a0
		lea.l	glist3,a1
		move.l	a1,nw_FirstGadget(a0)

;Gadgets for window 4

		lea.l	glist4,a0
		lib	GadTools,CreateContext
		move.l	d0,ContextGad5
		beq	NoContextGad

		move.l	glist4,a0

		lea.l	NGTrackGad1,a1
		move.l	#STRING_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	TrackGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,TrackGad1
		move.l	d0,a0
		move.l	$22(a0),a1
		move.l	(a1),TrackGadBuf1
;		or.w	#GADGIMMEDIATE!RELVERIFY,gg_Activation(a0)
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGMinutesGad1,a1
		move.l	#INTEGER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	MinutesGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,MinutesGad1
		move.l	d0,a0
		move.l	$22(a0),a1
		move.l	(a1),MinutesGadBuf1
;get the number's pointer too...
;		or.w	#GADGIMMEDIATE!RELVERIFY,gg_Activation(a0)
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGSecondsGad1,a1
		move.l	#INTEGER_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	SecondsGadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,SecondsGad1
		move.l	d0,a0
		move.l	$22(a0),a1
		move.l	(a1),SecondsGadBuf1
;get the number's pointer too...
;		or.w	#GADGIMMEDIATE!RELVERIFY,gg_Activation(a0)
		add.w	d5,gg_TopEdge(a0)

		lea.l	NGOKGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,OKGad2
		add.w	d5,gg_TopEdge(a0)
		or.w	#GRELBOTTOM,gg_Flags(a0)

		lea.l	NGCancelGad,a1
		move.l	#BUTTON_KIND,d0
		move.l	vi,gng_VisualInfo(a1)
		lea.l	GadTagList,a2
		lib	GadTools,CreateGadgetA

		move.l	d0,a0
		move.l	a0,CancelGad2
		add.w	d5,gg_TopEdge(a0)
		or.w	#GRELBOTTOM!GRELRIGHT,gg_Flags(a0)

		move.b	#1,GadMagic4		;Make worked OK
		lea.l	NewWindow4,a0
		lea.l	glist4,a1
		move.l	a1,nw_FirstGadget(a0)


;the above has a bug... It doesn't check for failures :)

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
		move.b	#1,MenuMagic

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

;Init list

		lea.l	AlbumList,a0
		NEWLIST	a0

Window1IDCMP:	bsr	CheckIDCMP
		cmp.l	Window1,a3
		beq	WindowIDCMP2
		cmp.l	Window2,a3
		beq	WindowIDCMP3
		cmp.l	Window3,a3
		beq	WindowIDCMP4
		cmp.l	Window4,a3
		beq	WindowIDCMP5
		bra	Window1IDCMP

;Window1

WindowIDCMP2:	cmp.l	#BREAK_QUIT,d2
		beq	ShutDown
		cmp.l	#CLOSEWINDOW,d2
		beq	ShutDown		;change to quit
		cmp.l	#GADGETUP,d2
		beq	DoGads
		cmp.l	#MENUPICK,d2
		beq	Win1Menus
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		bra	Window1IDCMP

;Window 2

WindowIDCMP3:	cmp.l	#BREAK_QUIT,d2
		beq	ShutDown
		cmp.l	#CLOSEWINDOW,d2
		beq	EndTracks
		cmp.l	#GADGETUP,d2
		beq	DoGads2
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys2
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		bra	Window1IDCMP

;Window 3

WindowIDCMP4:	cmp.l	#BREAK_QUIT,d2
		beq	ShutDown
		cmp.l	#CLOSEWINDOW,d2
		beq	EndEdit
		cmp.l	#GADGETUP,d2
		beq	DoGads3
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys3
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		bra	Window1IDCMP

;Window 4

WindowIDCMP5:	cmp.l	#BREAK_QUIT,d2
		beq	ShutDown
		cmp.l	#CLOSEWINDOW,d2
		beq	EndEdit2
		cmp.l	#GADGETUP,d2
		beq	DoGads4
		cmp.l	#VANILLAKEY,d2
		beq	VanillaKeys4
		cmp.l	#REFRESHWINDOW,d2
		beq	Refresher
		bra	Window1IDCMP

Refresher:	move.l	a3,a0
		lib	GadTools,GT_BeginRefresh
		move.l	a3,a0
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
;		beq	New
		cmp.w	#$01,d5
		beq	DoLoad
		cmp.w	#$02,d5
;		beq	Save
		cmp.w	#$03,d5
;		beq	SaveAs
		cmp.w	#$05,d5
;		beq	Print
		cmp.w	#$07,d5
		beq	About
		cmp.w	#$09,d5
		beq	ShutDown
		bra	Window1IDCMP

Win1Menus2:	cmp.w	#$00,d5
;		beq	Search
		cmp.w	#$01,d5
;		beq	SearchNext
		bra	Window1IDCMP

VanillaKeys:	cmp.w	#$1b,d3
		beq	ShutDown
		cmp.w	#'a',d3		;Lower Case
		beq	Add
		cmp.w	#'r',d3
		beq	Remove
		cmp.w	#'e',d3
		beq	Edit
		cmp.w	#'t',d3
		beq	Tracks
		cmp.w	#'o',d3
		beq	Top
		cmp.w	#'u',d3
		beq	Up
		cmp.w	#'d',d3
		beq	Down
		cmp.w	#'b',d3
		beq	Bottom
		cmp.w	#'A',d3		;Upper Case
		beq	Add
		cmp.w	#'R',d3
		beq	Remove
		cmp.w	#'E',d3
		beq	Edit
		cmp.w	#'T',d3
		beq	Tracks
		cmp.w	#'O',d3
		beq	Top
		cmp.w	#'U',d3
		beq	Up
		cmp.w	#'D',d3
		beq	Down
		cmp.w	#'B',d3
		beq	Bottom
		bra	Window1IDCMP

VanillaKeys2:	cmp.w	#$1b,d3
		beq	EndTracks
		cmp.w	#'a',d3		;Lower Case
		beq	Add2
		cmp.w	#'r',d3
		beq	Remove2
		cmp.w	#'e',d3
		beq	Edit2
		cmp.w	#'o',d3
		beq	Top2
		cmp.w	#'u',d3
		beq	Up2
		cmp.w	#'d',d3
		beq	Down2
		cmp.w	#'b',d3
		beq	Bottom2
		cmp.w	#'A',d3		;Upper Case
		beq	Add2
		cmp.w	#'R',d3
		beq	Remove2
		cmp.w	#'E',d3
		beq	Edit2
		cmp.w	#'O',d3
		beq	Top2
		cmp.w	#'U',d3
		beq	Up2
		cmp.w	#'D',d3
		beq	Down2
		cmp.w	#'B',d3
		beq	Bottom2
		bra	Window1IDCMP

VanillaKeys3:	cmp.w	#$1b,d3
		beq	EndEdit
		cmp.w	#'o',d3		;Lower Case
		beq	EndEdit
		cmp.w	#'c',d3
		beq	EndEdit
		cmp.w	#'O',d3		;Upper Case
		beq	EndEdit
		cmp.w	#'C',d3
		beq	EndEdit
		bra	Window1IDCMP

VanillaKeys4:	cmp.w	#$1b,d3
		beq	EndEdit2
		cmp.w	#'o',d3		;Lower Case
		beq	EndEdit2
		cmp.w	#'c',d3
		beq	EndEdit2
		cmp.w	#'O',d3		;Upper Case
		beq	EndEdit2
		cmp.w	#'C',d3
		beq	EndEdit2
		bra	Window1IDCMP

DoGads:		cmp.w	#10,$26(a5)
		beq	Add
		cmp.w	#11,$26(a5)
		beq	Remove
		cmp.w	#12,$26(a5)
		beq	Edit
		cmp.w	#13,$26(a5)
		beq	Tracks
		cmp.w	#14,$26(a5)
		beq	Top
		cmp.w	#15,$26(a5)
		beq	Up
		cmp.w	#16,$26(a5)
		beq	Down
		cmp.w	#17,$26(a5)
		beq	Bottom
		cmp.w	#18,$26(a5)
		beq	Sort
		cmp.w	#55,$26(a5)
		beq	GetAlbum
		bra	Window1IDCMP

DoGads2:	cmp.w	#10,$26(a5)
		beq	Add2
		cmp.w	#11,$26(a5)
		beq	Remove2
		cmp.w	#12,$26(a5)
		beq	Edit2
		cmp.w	#14,$26(a5)
		beq	Top2
		cmp.w	#15,$26(a5)
		beq	Up2
		cmp.w	#16,$26(a5)
		beq	Down2
		cmp.w	#17,$26(a5)
		beq	Bottom2
		cmp.w	#18,$26(a5)
		beq	Sort2
		cmp.w	#55,$26(a5)
		beq	GetTrack
		bra	Window1IDCMP

;Gadget stuff for window 3

DoGads3:	cmp.w	#81,$26(a5)
		beq	UpdateAlbum
		cmp.w	#82,$26(a5)
		beq	UpdateArtist
		cmp.w	#90,$26(a5)
		beq	EndEdit
		cmp.w	#91,$26(a5)
		beq	EndEdit
		bra	Window1IDCMP

;Gadget stuff for window 4

DoGads4:	cmp.w	#81,$26(a5)
;		beq	DoTrackStuff
		cmp.w	#82,$26(a5)
;		beq	DoMinutesStuff
		cmp.w	#83,$26(a5)
;		beq	DoSecondsStuff
		cmp.w	#90,$26(a5)
		beq	EndEdit2
		cmp.w	#91,$26(a5)
		beq	EndEdit2
		bra	Window1IDCMP

ActivateGads:	move.l	(a5),a0
		cmp.l	OKGad1,a0
		beq	ActivateGads1.1
		move.l	Window3,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
ActivateGads1.1: bra	Window1IDCMP

ActivateGads2:	move.l	(a5),a0
		cmp.l	OKGad2,a0
		beq	ActivateGads2.1
		move.l	Window4,a1
		sub.l	a2,a2
		lib	Intuition,ActivateGadget
ActivateGads2.1: bra	Window1IDCMP

;Move these elsewhere...

GetAlbum:	;move.l	d3,CurrentAlbum		;Have to search the address
		bra	Window1IDCMP

GetTrack:	;move.l	d3,CurrentTrack		;Have to search the address
		bra	Window1IDCMP

;'Update*' copies the text from the string gadget just completed

UpdateAlbum:	push	a5
		bsr	List1Off

		move.l	CurrentAlbum,a2
		move.l	AlbumGadBuf1,a0
		lea.l	AL_Name(a2),a1
		bsr	GetLength
		lib	Exec,CopyMem

		bsr	List1On
		pull	a5
		bra	ActivateGads

UpdateArtist:	push	a5
		bsr	List1Off
		move.l	CurrentAlbum,a2
		move.l	ArtistGadBuf1,a0
		lea.l	AL_Artist(a2),a1
		bsr	GetLength
		lib	Exec,CopyMem
		bsr	List1On
		pull	a5
		bra	ActivateGads

;'Add' adds a node to the album/track list

Add:		bsr	List1Off
		move.l	#ALBUM_SIZE,d0		;reserve memory for node
		move.l	#MEMF_CLEAR!MEMF_PUBLIC,d1
		lib	Exec,AllocMem
		tst.l	d0
		bne	Add1.1
		bsr	NoMem1
		bra	Window1IDCMP
Add1.1:		move.l	d0,a2			;Memory to a2
		lea.l	AlbumList,a0		;Get list
		move.l	a2,a1			;a0=list, a1=node
		ADDTAIL				;Add node to list

		lea.l	AL_Name(a2),a1		;Get name address
		move.l	a1,LN_NAME(a2)		;Put name in LN_NAME
		lea.l	NewText1,a0		;Give 'New' as name
		bsr	GetLength
		lib	Exec,CopyMem
		move.l	a2,CurrentAlbum		;Set current albumnode
		bsr	List1On
		bra	Edit

Remove:
		bra	Window1IDCMP

Add2:
		bra	Window1IDCMP

Remove2:
		bra	Window1IDCMP

;'Edit' edits a album/track node

Edit:		tst.l	CurrentAlbum
		beq	NoCurrAlbum
		tst.l	Window3
		beq	Edit1.1
		move.l	Window3,a0
		lib	Intuition,ActivateWindow
		move.l	Window3,a0
		lib	Intuition,WindowToFront
		bra	Edit1.2
Edit1.1:	bsr	OpenWin3
		tst.l	d0
		beq	Window1IDCMP
Edit1.2:	move.l	glist3,a5
		bra	ActivateGads

EndEdit:	bsr	List1On
		bsr	CloseWin3
		bra	Window1IDCMP

Edit2:		tst.l	Window4
		beq	Edit2.1
		move.l	Window4,a0
		lib	Intuition,ActivateWindow
		move.l	Window4,a0
		lib	Intuition,WindowToFront
		bra	Edit2.2
Edit2.1:	bsr	OpenWin4
		tst.l	d0
		beq	Window1IDCMP
Edit2.2:	move.l	glist4,a5
		bra	ActivateGads2

EndEdit2:	;bsr	OnList2
		bsr	CloseWin4
		bra	Window1IDCMP

;'Tracks' goes to the track list view etc. window

Tracks:		tst.l	Window2
		beq	Tracks1.1
		move.l	Window2,a0
		lib	Intuition,ActivateWindow
		move.l	Window2,a0
		lib	Intuition,WindowToFront
		bra	Tracks1.2
Tracks1.1:	bsr	OpenWin2
;		tst.l	d0
;		beq	Window1IDCMP
Tracks1.2:	bra	Window1IDCMP

EndTracks:	bsr	CloseWin2
		bra	Window1IDCMP

Top:
		bra	Window1IDCMP
Up:
		bra	Window1IDCMP
Down:
		bra	Window1IDCMP
Bottom:
		bra	Window1IDCMP
Sort:
		bra	Window1IDCMP
Top2:
		bra	Window1IDCMP
Up2:
		bra	Window1IDCMP
Down2:
		bra	Window1IDCMP
Bottom2:
		bra	Window1IDCMP
Sort2:
		bra	Window1IDCMP

;ADD! Check if not saved etc.

DoLoad:		bsr	Load
		move.l	#5,d1
		lib	Dos,Delay
		bra	Window1IDCMP

Load:		move.l	AslReq,a0
		lea.l	LoadReqTags,a1
		lib	Asl,AslRequest
		tst.l	d0
		beq	Load_OUT

		move.l	AslReq,a2
		move.l	rf_Dir(a2),d1
		move.l	#ACCESS_READ,d2
		lib	Dos,Lock
		move.l	d0,LoadLock
		beq	Load_ERR1

		move.l	LoadLock,d1
		lib	Dos,CurrentDir
		move.l	d0,LoadOldLock

		bra	Load_OUT0.1		;DEBUG (remove)

		move.l	AslReq,a2
		move.l	rf_File(a2),d1
		move.l	#MODE_OLDFILE,d2
		lib	Dos,Open
		move.l	d0,File1
		beq	Load_ERR1

		move.l	File1,d1
		lea.l	Buffer1,a0
		move.l	a0,d2
		move.l	#2,d3
		lib	Dos,Read
		cmp.l	#2,d0
		bne	Load_ERR2

		cmp.l	#'CDC1',Buffer1
		bne	Load_ERR3

;Close file

Load_OUT0.1:	move.l	File1,d1
		beq	Load_OUT0.2
		lib	Dos,Close
		clr.l	File1

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
		bsr	DoAutoRequest
		bra	Load_OUT0.1

Load_ERR2:	lea.l	File_ERRTxt2,a1
		bsr	DoAutoRequest
		bra	Load_OUT0.1

Load_ERR3:	lea.l	File_ERRTxt3,a1
		bsr	DoAutoRequest
		bra	Load_OUT0.1

;ADD! Add check if file already exists!

SaveAs:		move.l	AslReq,a0
		lea.l	SaveReqTags,a1
		lib	Asl,AslRequest
		tst.l	d0
		beq	Save_OUT

;Don't forget to add CDing to correct directory!

Save:		move.l	AslReq,a2
		move.l	rf_File(a2),d1
		move.l	#MODE_NEWFILE,d2
		lib	Dos,Open
		move.l	d0,File1
		beq	Save_ERR1

		move.l	#'CDC1',Buffer1

Save_OUT:	move.l	File1,d1
		beq	Save_OUT1
		lib	Dos,Close
		clr.l	File1
Save_OUT1:	bra	Window1IDCMP

Save_ERR1:	lea.l	File_ERRTxt1,a1
		bsr	DoAutoRequest
		bra	Save_OUT1

Save_ERR2:	lea.l	File_ERRTxt2,a1
		bsr	DoAutoRequest
		bra	Save_OUT

About:		bsr	SleepPointer
		bsr	MenusOff

		lea.l	AboutTxt1,a1
		bsr	DoAutoRequest

		bsr	MenusOn
		bsr	NormalPointer
		bra	Window1IDCMP

NoMem1:		bsr	SleepPointer
		bsr	MenusOff

		lea.l	NoMemTxt1,a1
		bsr	DoAutoRequest

		bsr	MenusOn
		bsr	NormalPointer
		rts

NoCurrAlbum:	lea.l	NoCurrAlbumTxt1,a1
		bsr	DoAutoRequest
		bra	Window1IDCMP

Break:		lea.l	BreakText1,a0
		bsr	Printer
		move.l	#BREAK_QUIT,d2
		move.l	#-1,d0
		rts

PutChProc:	tst.b	d0
		beq	PutChProc_OUT
		move.b	d0,(a3)+
PutChProc_OUT:	rts

ShutDown:	bsr	KillMem1		;Kill AlbumList

ShutDown7000:	tst.l	PubScreen
		beq	ShutDown6000
		sub.l	a0,a0
		move.l	PubScreen,a1
		lib	Intuition,UnlockPubScreen

ShutDown6000:	bsr	CloseWin4
		bsr	CloseWin2
		bsr	CloseWin3
		bsr	CloseWin1
		bsr	Clean2.0Magic

ShutDown5000:	move.l	RDArgs1,d1
		beq	ShutDown4600
		lib	Dos,FreeArgs

ShutDown4600:	tst.l	AslReq
		beq	ShutDown4500
		move.l	AslReq,a0
		lib	Asl,FreeFileRequest

ShutDown4500:	move.l	File1,d1
		beq	ShutDown4000
		lib	Dos,Close

ShutDown4000:	tst.l	NILFile
		beq	ShutDown3000
		move.l	NILFile,d1
		lib	Dos,Close

ShutDown3000:	tst.l	DiskObject
		beq	ShutDown2000
		move.l	DiskObject,a0
		lib	Icon,FreeDiskObject

ShutDown2000:	move.l	OldLock,d1
		beq	ShutDown1050
		lib	Dos,CurrentDir

ShutDown1050:	move.l	WBMsg,d2
		beq	ShutDown1000
		lib	Exec,Forbid
		move.l	d2,a1
		flib	Exec,ReplyMsg

ShutDown1000:	closlib	Icon
		closlib	Asl
		closlib	Utility
		closlib	Intuition
		closlib	GadTools
		closlib	Dos
		pull	d2-d7/a2-a6
		clr.l	d0
		rts

KillMem1:	clr.l	CurrentAlbum
		lea.l	AlbumList,a3		;Get list
		IFEMPTY	a3,KillMem1_OUT		;See if empty

;ADD!!! bsr	KillMem2, which kills the tracklist for this album

		TSTNODE	a3,a2			;Test and get next node
		beq	KillMem1_OUT		;(We are at end of list)
		move.l	a2,a1			;Get node
		REMOVE				;Remove from list

		move.l	a2,a1			;Get address of node
		move.l	#ALBUM_SIZE,d0		;Get size
		lib	Exec,FreeMem		;Free memory used
		bra	KillMem1		;Do rest
KillMem1_OUT:	rts

;CheckIDCMP gets messages from the keyboard (CTRL_C) and Intuition.

CheckIDCMP:	clr.l	d1			;Set signals
		clr.l	d0
		move.l	WinPort,a2
		move.b	$0f(a2),d1
		bset.l	d1,d0

		bset.l	#SIGBREAKB_CTRL_C,d0	;and CTRL_C
		lib	Exec,Wait

		cmp.l	#SIGBREAKF_CTRL_C,d0	;If CTRL_C
		beq	Break			;go break

C2GetMsg1:	move.l	WinPort,a0	
		lib	GadTools,GT_GetIMsg
		tst.l	d0
		beq	C2GetMsg2
	
		move.l	d0,a1 
		move.l	im_Class(a1),d2		;answers with Class in d2,
		move.w	im_Code(a1),d3		;Code in d3 and
		move.l	im_IDCMPWindow(a1),a3	;IDCMPWindow in a3
		move.w	im_Qualifier(a1),a4	;Qualifier in a4
		move.l	im_IAddress(a1),a5	;IAddress in a5
		lib	GadTools,GT_ReplyIMsg
		bra	C2GetMsg1
C2GetMsg2:	move.l	#-1,d0
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

List1Off:	move.l	ListGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	ListOffTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

List1On:	move.l	ListGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		lea.l	List1OnTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

List2Off:	move.l	ListGad2,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lea.l	ListOffTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

List2On:	move.l	ListGad2,a0
		move.l	Window2,a1
		sub.l	a2,a2
		lea.l	List2OnTags,a3
		lib	GadTools,GT_SetGadgetAttrsA
		rts

RefreshList1:	move.l	ListGad1,a0
		move.l	Window1,a1
		sub.l	a2,a2
		move.l	#1,d0
		lib	Intuition,RefreshGList
		rts

RefreshList2:	move.l	ListGad2,a0
		move.l	Window2,a1
		sub.l	a2,a2
		move.l	#1,d0
		lib	Intuition,RefreshGList
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
		add.w	d5,WinYSize
		add.w	d5,WinYSize2
		add.w	d5,WinYSize3
		add.w	d5,WinYSize4
LockPubScr_OUT:	rts

;Open Windows

OpenWin1:	lea.l	NewWindow1,a0
		lea.l	Win1TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window1
		beq	OpenWin1_ERR1
		move.l	Window1,a0
		move.l	wd_UserPort(a0),WinPort	;Get window1's port
		move.l	mlist,a1
		lib	Intuition,SetMenuStrip
		move.l	Window1,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		move.l	#-1,d0
		rts
OpenWin1_ERR1:	clr.l	d0
		rts

OpenWin2:	lea.l	NewWindow2,a0
		lea.l	Win2TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window2
		beq	OpenWin2_ERR1
		move.l	d0,a0
		move.l	Window1,a1
		move.l	wd_UserPort(a1),wd_UserPort(a0)
		move.l	#CLOSEWINDOW!VANILLAKEY!GADGETUP,d0
		lib	Intuition,ModifyIDCMP
		move.l	Window2,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		move.l	#-1,d0
		rts
OpenWin2_ERR1:	clr.l	d0
		rts

OpenWin3:	lea.l	NewWindow3,a0
		lea.l	Win3TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window3
		beq	OpenWin2_ERR1
		move.l	d0,a0
		move.l	Window1,a1
		move.l	wd_UserPort(a1),wd_UserPort(a0)
		move.l	#CLOSEWINDOW!VANILLAKEY!GADGETUP,d0
		lib	Intuition,ModifyIDCMP
		move.l	Window3,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		move.l	#-1,d0
		rts
OpenWin3_ERR1:	clr.l	d0
		rts

OpenWin4:	lea.l	NewWindow4,a0
		lea.l	Win2TagList,a1
		lib	Intuition,OpenWindowTagList
		move.l	d0,Window4
		beq	OpenWin2_ERR1
		move.l	d0,a0
		move.l	Window1,a1
		move.l	wd_UserPort(a1),wd_UserPort(a0)
		move.l	#CLOSEWINDOW!VANILLAKEY!GADGETUP,d0
		lib	Intuition,ModifyIDCMP
		move.l	Window4,a0
		sub.l	a1,a1
		lib	GadTools,GT_RefreshWindow
		move.l	#-1,d0
		rts
OpenWin4_ERR1:	clr.l	d0
		rts

;Window closers

CloseWin1:	tst.l	Window1
		beq	CloseWin1_OUT
		move.l	Window1,a0
		lib	Intuition,ClearMenuStrip
		move.l	Window1,a3
		clr.l	d5
		bsr	ClearMSGs
CloseWin1_OUT:	clr.l	Window1
		clr.l	WinPort
		rts

CloseWin2:	tst.l	Window2
		beq	CloseWin2_OUT
		move.l	Window2,a3
		move.l	#-1,d5
		bsr	ClearMSGs
CloseWin2_OUT:	clr.l	Window2
		rts

CloseWin3:	tst.l	Window3
		beq	CloseWin3_OUT
		move.l	Window3,a3
		move.l	#-1,d5
		bsr	ClearMSGs
CloseWin3_OUT:	clr.l	Window3
		rts

CloseWin4:	tst.l	Window4
		beq	CloseWin4_OUT
		move.l	Window4,a3
		move.l	#-1,d5
		bsr	ClearMSGs
CloseWin4_OUT:	clr.l	Window4
		rts

;ClearMsgs subroutine

;a3 = window structure

ClearMSGs:	push	a2-a6
		lib	Exec,Forbid
		move.l	wd_UserPort(a3),a2

ClearMsgs1:	move.l	a2,a0
		lib	Exec,GetMsg
		tst.l	d0
		beq	ClearMsgs2

		move.l	d0,a1
		lib	Exec,ReplyMsg
		bra	ClearMsgs1

ClearMsgs2:	tst.l	d5
		beq	ClearMsgs3
		clr.l	wd_UserPort(a3)

ClearMsgs3:	move.l	a3,a0
		clr.l	d0
		lib	Intuition,ModifyIDCMP
		lib	Exec,Permit

		move.l	a3,a0
		lib	Intuition,CloseWindow
		pull	a2-a6
		rts

;Get length of text in given address
;
;Input a0 = Address of null terminated text string
;	    Includes NULL.
;
;Result d0 = Length

GetLength:	push	a0
		clr.l	d0
		cmp.l	#$00,a0		;fixes enforcer hit
		beq	GetLength_OUT
GetLength2:	add.l	#1,d0
		tst.b	(a0)+
		bne	GetLength2
GetLength_OUT:	pull	a0
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
		push	d1/a0
		move.l	#10,d1
		lib	Utility,UMult32
		pull	d1/a0
		add.l	d1,d0
		add.l	#1,a0
		bra	ConvASCII2
ConvASCII_OUT:	rts

Clean2.0Magic:	tst.b	GadMagic
		beq	Clean2.0M1
		move.l	glist,a0
		lib	GadTools,FreeGadgets

Clean2.0M1:	tst.b	GadMagic2
		beq	Clean2.0M1.1
		move.l	glist2,a0
		lib	GadTools,FreeGadgets

Clean2.0M1.1:	tst.b	GadMagic3
		beq	Clean2.0M1.2
		move.l	glist3,a0
		lib	GadTools,FreeGadgets

Clean2.0M1.2:	tst.b	GadMagic4
		beq	Clean2.0M2
		move.l	glist4,a0
		lib	GadTools,FreeGadgets

Clean2.0M2:	tst.b	MenuMagic
		beq	Clean2.0M3
		move.l	mlist,a0
		lib	GadTools,FreeMenus

Clean2.0M3:	tst.l	vi
		beq	Clean2.0_OUT
		move.l	vi,a0
		lib	GadTools,FreeVisualInfo

Clean2.0_OUT:	rts

;Error etc. messages

NoDos:		pull	d2-d7/a2-a6
		move.l	#RETURN_FAIL,d0
		rts

NoRDArgs:	lib	Dos,IoErr
		move.l	d0,d1
		clr.l	d2
		lib	Dos,PrintFault
		bra	ShutDown

NoInt:		lea.l	NoIntText1,a0
		bsr	Printer
		bra	ShutDown

NoUtility:	add.l	#8,sp
		lea.l	NoUtilityText1,a0
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

NoNIL:		lea.l	NoNILText1,a0
		bsr	Printer
		bra	ShutDown

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

Printer:	printa	a0,_stdout
		rts

DoAutoRequest:	move.l	#$00,a2		;positive text
		lea.l	OKTxt,a3	;a bit the wrong way around but...
		move.l	#$00,d0
		move.l	#$00,d1
		move.l	#$00,d2
		move.l	#$00,d3
		move.l	Window1,a0
		lib	Intuition,AutoRequest
		rts

		ds.l	0

;Reservations

		libnames

;Options

CLArray1:
FromFile:	dc.l	0

;ASL Stuff

AslReq:		dc.l	0

;GadTools stuff

vi:		dc.l	0		;Visual Info
mlist:		dc.l	0
ContextGad2:	dc.l	0
ContextGad3:	dc.l	0
ContextGad4:	dc.l	0
ContextGad5:	dc.l	0
GadMagic:	dc.b	0
GadMagic2:	dc.b	0
GadMagic3:	dc.b	0
GadMagic4:	dc.b	0
MenuMagic:	dc.b	0
KLUDGE:		dc.b	0

;Gadgets

;Window1 Gadgets

AddGad1:	dc.l	0
RemoveGad1:	dc.l	0
EditGad1:	dc.l	0
TracksGad1:	dc.l	0

ListGad1:	dc.l	0

TopGad1:	dc.l	0
UpGad1:		dc.l	0
DownGad1:	dc.l	0
BottomGad1:	dc.l	0
SortGad1:	dc.l	0

TotalGad1:	dc.l	0

;Window2 Gadgets

AddGad2:	dc.l	0
RemoveGad2:	dc.l	0
EditGad2:	dc.l	0

ListGad2:	dc.l	0

TopGad2:	dc.l	0
UpGad2:		dc.l	0
DownGad2:	dc.l	0
BottomGad2:	dc.l	0
SortGad2:	dc.l	0

TotalGad2:	dc.l	0

;Window3 Gadgets

AlbumGad1:	dc.l	0
AlbumGadBuf1:	dc.l	0
ArtistGad1:	dc.l	0
ArtistGadBuf1:	dc.l	0

OKGad1:		dc.l	0
CancelGad1:	dc.l	0

;Window4 Gadgets

TrackGad1:	dc.l	0
TrackGadBuf1:	dc.l	0
MinutesGad1:	dc.l	0
MinutesGadBuf1:	dc.l	0
SecondsGad1:	dc.l	0
SecondsGadBuf1:	dc.l	0

OKGad2:		dc.l	0
CancelGad2:	dc.l	0

;display stuff

PubScreen:	dc.l	0
Window1:	dc.l	0
WinPort:	dc.l	0
Window2:	dc.l	0
Window3:	dc.l	0
Window4:	dc.l	0
BHeight:	dc.w	0

;File stuff

File1:		dc.l	0
NILFile:	dc.l	0
_stdout:	dc.l	0
LoadLock:	dc.l	0
LoadOldLock:	dc.l	0

;Other stuff, part I

OurTask:	dc.l	0
WBMsg:		dc.l	0
DiskObject:	dc.l	0
OldLock:	dc.l	0
RDArgs1:	dc.l	0
CurrentAlbum:	dc.l	0
CurrentTrack:	dc.l	0

;Strings, error

BreakText1:	dc.b	"***Break",13,10,0
NoIntText1:	dc.b	"ERROR: Couldn't open intuition.library!",13,10,0
NoUtilityText1:	dc.b	"ERROR: Couldn't open utility.library!",13,10,0
NoIconText1:	dc.b	"ERROR: Couldn't open icon.library!",13,10,0
NoGTText1:	dc.b	"ERROR: Couldn't open gadtools.library!",13,10,0
NoAslText1:	dc.b	"ERROR: Couldn't open asl.library!",13,10,0
NoAslReqText1:	dc.b	"ERROR: Couldn't allocate ASL requester!",13,10,0
NoNILText1:	dc.b	"ERROR: Couldn't open device NIL:!",13,10,0
NoPubScrText1:	dc.b	"ERROR: Couldn't lock PublicScreen",13,10,0
NoContextText1:	dc.b	"ERROR: Couldn't create context gadget",13,10,0
NoMenusText1:	dc.b	"ERROR: Couldn't allocate menus structure",13,10,0
NoWindowText1:	dc.b	"ERROR: Couldn't open Window",13,10,0
NoMemText1:	dc.b	"ERROR: Out of memory!",0
File_ERRText1:	dc.b	"Couldn't open file!",0
File_ERRText2:	dc.b	"File error!",0
File_ERRText3:	dc.b	"Incorrect file type!",0
NoCurrAlbumText1: dc.b	"Please select album!",0

;Strings, names

CLTemplate1:	dc.b	"FROM",0
		dc.b	"$VER: CD-Catalog (X.X.93) (C)opyright Tomi Blinnikka 1993",0
OKText1:	dc.b	"OK",0
NILName:	dc.b	"NIL:",0
DEVICEText1:	dc.b	"DEVICE",0
UNITText1:	dc.b	"UNIT",0
ICONIFYText1:	dc.b	"ICONIFY",0
YESText1:	dc.b	"YES",0
AboutText1:	dc.b	"Name   : CD-Catalog",0
AboutText2:	dc.b	"Version: 1.00",0
AboutText3:	dc.b	"Author : Tomi Blinnikka",0
AboutText4:	dc.b	"   (C)opyright  1993",0
CDCName1:	dc.b	"CD-Catalog",0
Win2Text1:	dc.b	"Tracks",0
Win3Text1:	dc.b	"Edit Album",0
Win4Text1:	dc.b	"Edit Track",0
LoadText1:	dc.b	"Load CD-Catalog",0
SaveText1:	dc.b	"Save CD-Catalog",0
fstrl:		dc.b	"%10.ld",0
NewText1:	dc.b	"New album",0

		ds.w	0

;New screen & new window structures

;Window 1 Album list etc.

NewWindow1:	dc.w	0,11			;X,Y POS
		dc.w	551			;WIDTH
WinYSize:	dc.w	120			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	REFRESHWINDOW!CLOSEWINDOW!VANILLAKEY!MENUPICK!LISTVIEWIDCMP	;IDCMP FLAGS
		dc.l	WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	CDCName1		;TITLE
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
SmallXSize:	dc.w	222
SmallYSize:	dc.w	0

;Window 2 Track list etc.

NewWindow2:	dc.w	39,33			;X,Y POS
		dc.w	551			;WIDTH
WinYSize2:	dc.w	120			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	0			;IDCMP FLAGS
		dc.l	SMART_REFRESH!WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	Win2Text1		;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win2TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	TAG_DONE,0

;Edit Album window

NewWindow3:	dc.w	19,22			;X,Y POS
		dc.w	495			;WIDTH
WinYSize3:	dc.w	60			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	0			;IDCMP FLAGS
		dc.l	SMART_REFRESH!WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	Win3Text1		;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win3TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	TAG_DONE,0

;Edit Track window

NewWindow4:	dc.w	59,44			;X,Y POS
		dc.w	495			;WIDTH
WinYSize4:	dc.w	60			;HEIGHT
		dc.b	0,1			;PENS
		dc.l	0			;IDCMP FLAGS
		dc.l	SMART_REFRESH!WINDOWDRAG!WINDOWDEPTH!WINDOWCLOSE!ACTIVATE	;FLAGS
		dc.l	0,0			;GADGETS, CHECKMARK
		dc.l	Win4Text1		;TITLE
		dc.l	0			;SCREEN ADDRESS
		dc.l	0			;BITMAP			
		dc.w	0,0,0,0			;MIN/MAX SIZE
		dc.w	PUBLICSCREEN		;TYPE

Win4TagList:	dc.l	WA_AutoAdjust,TRUE
		dc.l	TAG_DONE,0

;Fonts

Topaz:		dc.l	TopazName
		dc.w	8
		dc.b	0
		dc.b	0
TopazName:	dc.b	"topaz.font",0
		ds.l	0

AslReqTags:	dc.l	ASL_Window
		dc.l	0			;Move window pointer here!
		dc.l	TAG_DONE,0
LoadReqTags:	dc.l	ASL_Hail,LoadText1
		dc.l	ASL_FuncFlags,0
		dc.l	TAG_DONE,0
SaveReqTags:	dc.l	ASL_Hail,SaveText1
		dc.l	ASL_FuncFlags,FILF_SAVE
		dc.l	TAG_DONE,0

;ITextStructures

OKTxt:		dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	6,3			;LEFT+TOPEDGE
		dc.l	0			;FONT
		dc.l	OKText1			;TEXT
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

NoCurrAlbumTxt1: dc.b	1,2			;PENS
		dc.w	0			;MODE
		dc.w	0,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NoCurrAlbumText1	;TEXT
		dc.l	0 			;NEXTTEXT

;Gadgets

AddGadText1:	dc.b	"_Add",0
RemoveGadText1:	dc.b	"_Remove",0
EditGadText1:	dc.b	"_Edit",0
TracksGadText1:	dc.b	"_Tracks",0

ListGadText1:	dc.b	"Albums",0
ListGadText2:	dc.b	"Tracks",0

TopGadText1:	dc.b	"T_op",0
UpGadText1:	dc.b	"_Up",0
DownGadText1:	dc.b	"_Down",0
BottomGadText1:	dc.b	"_Bottom",0
SortGadText1:	dc.b	"_Sort",0

TotalGadText1:	dc.b	"Total:",0

		ds.l	0

glist:		dcb.b	gg_SIZEOF,0
glist2:		dcb.b	gg_SIZEOF,0
glist3:		dcb.b	gg_SIZEOF,0
glist4:		dcb.b	gg_SIZEOF,0

NGAddGad:	dc.w	10		;gng_LeftEdge
		dc.w	OptionTop2+0*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	AddGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	10		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGRemoveGad:	dc.w	10		;gng_LeftEdge
		dc.w	OptionTop2+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	RemoveGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	11		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGEditGad:	dc.w	10		;gng_LeftEdge
		dc.w	OptionTop2+2*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	EditGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	12		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGTracksGad:	dc.w	10		;gng_LeftEdge
		dc.w	OptionTop2+3*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	TracksGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	13		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGListGad:	dc.w	76		;gng_LeftEdge
		dc.w	ListTop		;gng_TopEdge
		dc.w	400		;gng_Width
		dc.w	90		;gng_Height
		dc.l	ListGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_ABOVE	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGTopGad:	dc.w	482		;gng_LeftEdge
		dc.w	OptionTop3+0*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	TopGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	14		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGUpGad:	dc.w	482		;gng_LeftEdge
		dc.w	OptionTop3+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	UpGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	15		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGDownGad:	dc.w	482		;gng_LeftEdge
		dc.w	OptionTop3+2*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	DownGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	16		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGBottomGad:	dc.w	482		;gng_LeftEdge
		dc.w	OptionTop3+3*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	BottomGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	17		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSortGad:	dc.w	482		;gng_LeftEdge
		dc.w	OptionTop3+4*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	SortGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	18		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGTotalGad:	dc.w	76		;gng_LeftEdge
		dc.w	ListTop+80	;gng_TopEdge
		dc.w	50		;gng_Width
		dc.w	12		;gng_Height
		dc.l	TotalGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	0		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Window3 (and up) gadgets

AlbumGadText1: dc.b	"Album",0
ArtistGadText1: dc.b	"Artist",0
OKGadText1:	dc.b	"_OK",0
CancelGadText1:	dc.b	"_Cancel",0

		ds.l	0

NGAlbumStrGad1:	dc.w	75		;gng_LeftEdge
		dc.w	StrTop+0*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	400		;gng_Width
		dc.w	12		;gng_Height
		dc.l	AlbumGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	81		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGArtistGad1:	dc.w	75		;gng_LeftEdge
		dc.w	StrTop+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	400		;gng_Width
		dc.w	12		;gng_Height
		dc.l	ArtistGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	82		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGOKGad:	dc.w	INTERWIDTH	;gng_LeftEdge
		dc.w	-28		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	OKGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	90		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGCancelGad:	dc.w	-60-INTERWIDTH	;gng_LeftEdge
		dc.w	-28		;gng_TopEdge
		dc.w	60		;gng_Width
		dc.w	12		;gng_Height
		dc.l	CancelGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	91		;gng_GadgetID
		dc.l	PLACETEXT_IN	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Window 4 gadgets

TrackGadText1:	dc.b	"Track",0
MinutesGadText1: dc.b	"Minutes",0
SecondsGadText1: dc.b	"Seconds",0
		ds.l	0

NGTrackGad1:	dc.w	75		;gng_LeftEdge
		dc.w	StrTop		;gng_TopEdge
		dc.w	400		;gng_Width
		dc.w	12		;gng_Height
		dc.l	TrackGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	81		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGMinutesGad1:	dc.w	75		;gng_LeftEdge
		dc.w	StrTop+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	50		;gng_Width
		dc.w	12		;gng_Height
		dc.l	MinutesGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	82		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

NGSecondsGad1:	dc.w	2*75+1*(50+INTERWIDTH)		;gng_LeftEdge
		dc.w	StrTop+1*(12+INTERHEIGHT)	;gng_TopEdge
		dc.w	50		;gng_Width
		dc.w	12		;gng_Height
		dc.l	SecondsGadText1	;gng_GadgetText
		dc.l	Topaz		;gng_TextAttr
		dc.w	83		;gng_GadgetID
		dc.l	PLACETEXT_LEFT	;gng_Flags
		dc.l	0		;gng_VisualInfo
		dc.l	0		;gng_UserData

;Gadget TagLists

AlbumGadTagList: dc.l	GTST_String,StrBuffer1
		dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,64
		dc.l	TAG_DONE,0

ArtistGadTagList: dc.l	GTST_String,StrBuffer2
		dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,64
		dc.l	TAG_DONE,0

TrackGadTagList: dc.l	GTST_String,StrBuffer3
		dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,64
		dc.l	TAG_DONE,0

MinutesGadTagList: dc.l	GTST_String,StrBuffer4
		dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,10
		dc.l	TAG_DONE,0

SecondsGadTagList: dc.l	GTST_String,StrBuffer5
		dc.l	GT_Underscore,'_'
		dc.l	GTST_MaxChars,10
		dc.l	TAG_DONE,0

ListGadTagList:	dc.l	GTLV_ShowSelected,0
		dc.l	TAG_DONE,0

ListOffTags:	dc.l	GTLV_Labels,0
		dc.l	TAG_DONE,0

List1OnTags:	dc.l	GTLV_Labels,AlbumList
		dc.l	TAG_DONE,0

List2OnTags:	dc.l	GTLV_Labels
SomeListOK:	dc.l	0		;A copy of Current Track list?
		dc.l	TAG_DONE,0

GadTagList:	dc.l	GT_Underscore,'_'
		dc.l	TAG_DONE,0
;Menus

Menu1Name:	dc.b	"Project",0
NewMenuText1:	dc.b	"New",0
NewCommKey:	dc.b	"N",0
LoadMenuText1:	dc.b	"Open...",0
LoadCommKey:	dc.b	"O",0
SaveMenuText1:	dc.b	"Save",0
SaveCommKey:	dc.b	"S",0
SaveAsMenuText1: dc.b	"Save As...",0
SaveAsCommKey:	dc.b	"A",0
PrintMenuText1: dc.b	"Print...",0
PrintCommKey:	dc.b	"P",0
AboutMenuText1:	dc.b	"About...",0
AboutCommKey:	dc.b	"?",0
QuitMenuText1:	dc.b	"Quit",0
QuitCommKey:	dc.b	"Q",0

Menu2Name:	dc.b	"Search",0
SearchMenuText1: dc.b	"Find...",0
SearchCommKey:	dc.b	"F",0
NextMenuText1:	dc.b	"Next",0
NextCommKey:	dc.b	"N",0
		ds.l	0

MNProjectMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu1Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNNew1:		dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NewMenuText1		;gnm_Label
		dc.l	NewCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNLoad1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	LoadMenuText1		;gnm_Label
		dc.l	LoadCommKey		;gnm_CommKey
		dc.w	0 			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSave1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SaveMenuText1		;gnm_Label
		dc.l	SaveCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSaveAs:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SaveAsMenuText1		;gnm_Label
		dc.l	SaveAsCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP1SepMenu1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNPrintAs:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	PrintMenuText1		;gnm_Label
		dc.l	PrintCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNP1SepMenu2:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NM_BARLABEL		;gnm_Label
		dc.l	0			;gnm_CommKey
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

MNP1SepMenu3:	dc.b	NM_ITEM			;gnm_Type
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

MNSearchMenu1:	dc.b	NM_TITLE		;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	Menu2Name		;gnm_Label
		dc.l	0			;gnm_CommKey
		dc.w	0			;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNSearch1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	SearchMenuText1		;gnm_Label
		dc.l	SearchCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData

MNNext1:	dc.b	NM_ITEM			;gnm_Type
		dc.b	0			;gnm_Pad
		dc.l	NextMenuText1		;gnm_Label
		dc.l	NextCommKey		;gnm_CommKey
		dc.w	NM_ITEMDISABLED		;gnm_Flags
		dc.l	0			;gnm_MutualExclude
		dc.l	0			;gnm_UserData
		dc.w	0			;NM_END?

;Menu TagList(s)

MenuTagList:	dc.l	GTMN_Menu,MNProjectMenu1
		dc.l	TAG_DONE,0

NoMemTxt1:	dc.b	3,1			;PENS
		dc.w	4			;MODE
		dc.w	10,10			;LEFT+TOPEDGE
		dc.l	Topaz			;FONT
		dc.l	NoMemText1		;TEXT
		dc.l	0			;NEXTTEXT

		section	CDC,BSS

;Lists

AlbumList:	ds.l	ALBUM_SIZE

;Buffers

Buffer1:	ds.l	1
StrBuffer1:	ds.b	64	;for album name
StrBuffer2:	ds.b	64	;for artist name

StrBuffer3:	ds.b	64	;for track name

StrBuffer4:	ds.b	10	;for track minutes
StrBuffer5:	ds.b	10	;for track seconds

		Section	RD,DATA,CHIP

		ds.w	0

ClockPointer1:	dc.w	$0000,$0000
		dc.w	$0400,$07C0,$0000,$07C0,$0100,$0380,$0000,$07E0
		dc.w	$07C0,$1FF8,$1FF0,$3FEC,$3FF8,$7FDE,$3FF8,$7FBE
		dc.w	$7FFC,$FF7F,$7EFC,$FFFF,$7FFC,$FFFF,$3FF8,$7FFE
		dc.w	$3FF8,$7FFE,$1FF0,$3FFC,$07C0,$1FF8,$0000,$07E0
		dc.w	$0000,$0000

		end
