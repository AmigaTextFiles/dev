/***************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993-1997 Stefan Stuntz
**
** Main Header File
**
****************************************************************************
** Class Tree
****************************************************************************
**
** rootclass                    (BOOPSI's base class)
** +--Notify                   (implements notification mechanism)
** !  +--Family                (handles multiple children)
** !  !  +--Menustrip          (describes a complete menu strip)
** !  !  +--Menu               (describes a single menu)
** !  !  \--Menuitem           (describes a single menu item)
** !  +--Application           (main class for all applications)
** !  +--Window                (main class for all windows)
** !  !  \--Aboutmui           (About window of MUI preferences)
** !  +--Area                  (base class for all GUI elements)
** !     +--Rectangle          (spacing object)
** !     +--Balance            (balancing separator bar)
** !     +--Image              (image display)
** !     +--Bitmap             (draws bitmaps)
** !     !  \--Bodychunk       (makes bitmap from ILBM body chunk)
** !     +--Text               (text display)
** !     +--Gadget             (base class for intuition gadgets)
** !     !  +--String          (string gadget)
** !     !  +--Boopsi          (interface to BOOPSI gadgets)
** !     !  \--Prop            (proportional gadget)
** !     +--Gauge              (fule gauge)
** !     +--Scale              (percentage scale)
** !     +--Colorfield         (field with changeable color)
** !     +--List               (line-oriented list)
** !     !  +--Floattext       (special list with floating text)
** !     !  +--Volumelist      (special list with volumes)
** !     !  +--Scrmodelist     (special list with screen modes)
** !     !  \--Dirlist         (special list with files)
** !     +--Numeric            (base class for slider gadgets)
** !     !  +--Knob            (turning knob)
** !     !  +--Levelmeter      (level display)
** !     !  +--Numericbutton   (space saving popup slider)
** !     !  \--Slider          (traditional slider)
** !     +--Framedisplay       (private)
** !     !  \--Popframe        (private)
** !     +--Imagedisplay       (private)
** !     !  \--Popimage        (private)
** !     +--Pendisplay         (displays a pen specification)
** !     !  \--Poppen          (popup button to adjust a pen spec)
** !     +--Group              (groups other GUI elements)
** !        +--Mccprefs        (private)
** !        +--Register        (handles page groups with titles)
** !        !  \--Penadjust    (group to adjust a pen)
** !        +--Settingsgroup   (private)
** !        +--Settings        (private)
** !        +--Frameadjust     (private)
** !        +--Imageadjust     (private)
** !        +--Virtgroup       (handles virtual groups)
** !        +--Scrollgroup     (virtual groups with scrollbars)
** !        +--Scrollbar       (traditional scrollbar)
** !        +--Listview        (listview)
** !        +--Radio           (radio button)
** !        +--Cycle           (cycle gadget)
** !        +--Coloradjust     (several gadgets to adjust a color)
** !        +--Palette         (complete palette gadget)
** !        +--Popstring       (base class for popup objects)
** !           +--Popobject    (popup aynthing in a separate window)
** !           !  +--Poplist   (popup a simple listview)
** !           !  \--Popscreen (popup a list of public screens)
** !           \--Popasl       (popup an asl requester)
** +--Semaphore                (semaphore equipped objects)
**    +--Applist               (private)
**    +--Dataspace             (handles general purpose data spaces)
**       \--Configdata         (private)
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** All macro and structure definitions follow these rules:
**
** Name                       Meaning
**
** MUIC_<class>               Name of a class
** MUIM_<class>_<method>      Method
** MUIP_<class>_<method>      Methods parameter structure
** MUIV_<class>_<method>_<x>  Special method value
** MUIA_<class>_<attrib>      Attribute
** MUIV_<class>_<attrib>_<x>  Special attribute value
** MUIE_<error>               Error return code from MUI_Error()
** MUII_<name>                Standard MUI image
** MUIX_<code>                Control codes for text strings
** MUIO_<name>                Object type for MUI_MakeObject()
**
** MUIA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** Items marked with "Custom Class" are for use in custom classes only!
*/
MODULE	'dos/dos'
MODULE	'intuition/classes'
MODULE	'intuition/screens'
MODULE	'intuition/intuition'
MODULE	'libraries/iffparse'

#define MUI_TRUE 1

/***************************************************************************
** Library specification
***************************************************************************/
#define MUIMASTER_NAME     'muimaster.library'
CONST	MUIMASTER_VMIN=11,
		MUIMASTER_VLATEST=19
/* comment this if you dont want to include obsolete identifiers */
#define MUI_OBSOLETE 
/*************************************************************************
** Config items for MUIM_GetConfigItem
*************************************************************************/
CONST	MUICFG_PublicScreen=36/*************************************************************************
** Black box specification structures for images, pens, frames
*************************************************************************/
OBJECT MUI_PenSpec
	buf[32]:UBYTE
ENDOBJECT
/*************************************************************************
** Public Screen Stuff
*************************************************************************/
/*
** NOTE: This stuff is only included to allow compilation of the supplied
**       public screen manager for educational purposes. Everything
**       here is subject to change without notice and I guarantee to
**       do that just for fun!
**       More info can be found in the screen manager source file.
*/
#define PSD_INITIAL_NAME    '(unnamed)'
#define PSD_INITIAL_TITLE   'MUI Public Screen'
#define PSD_ID_MPUB         MAKE_ID("M","P","U","B")
#define PSD_NAME_FRONTMOST  '«Frontmost»'
#define PSD_FILENAME_SAVE  'envarc:mui/PublicScreens.iff'
#define PSD_FILENAME_USE   'env:mui/PublicScreens.iff'
CONST	PSD_MAXLEN_NAME=32,
		PSD_MAXLEN_TITLE=128,
		PSD_MAXLEN_FONT=48,
		PSD_MAXLEN_BACKGROUND=256,
		PSD_NUMCOLS=8,
		PSD_MAXSYSPENS=20,
		PSD_NUMSYSPENS=12,
		PSD_MAXMUIPENS=10

->CONST PSD_Reserved=7*4+1-PSD_MAXSYSPENS
->CONST PSD_rsvd=PSD_MAXSYSPENS-PSD_NUMCOLS

OBJECT MUI_RGBcolor
	red:ULONG,
	green:ULONG,
	blue:ULONG
ENDOBJECT

OBJECT MUI_PubScreenDesc
	Version:LONG,
	Name[PSD_MAXLEN_NAME]:UBYTE,
	Title[PSD_MAXLEN_TITLE]:UBYTE,
	Font[PSD_MAXLEN_FONT]:UBYTE,
	Background[PSD_MAXLEN_BACKGROUND]:UBYTE,
	DisplayID:ULONG,
	DisplayWidth:UWORD,
	DisplayHeight:UWORD,
	DisplayDepth:UBYTE,
	OverscanType:UBYTE,
	AutoScroll:UBYTE,
	NoDrag:UBYTE,
	Exclusive:UBYTE,
	Interleaved:UBYTE,
	SysDefault:UBYTE,
	Behind:UBYTE,
	AutoClose:UBYTE,
	CloseGadget:UBYTE,
	DummyWasForeign:UBYTE,
	SystemPens[PSD_MAXSYSPENS]:BYTE,
	->Reserved[PSD_Reserved]:UBYTE,
	Reserved[9]:UBYTE,
	Palette[PSD_NUMCOLS]:MUI_RGBcolor,
	rsvd[12]:MUI_RGBcolor,
	->rsvd[PSD_rsvd]:MUI_RGBcolor,
	rsvd2[PSD_MAXMUIPENS]:MUI_PenSpec,
	Changed:LONG,
	UserData:LONG
ENDOBJECT

OBJECT MUIS_InfoClient
	node:MinNode,
	task:PTR TO Task,
	sigbit:ULONG
ENDOBJECT

/***************************************************************************
** Object Types for MUI_MakeObject()
***************************************************************************/
CONST	MUIO_Label          = 1,  	/* STRPTR label, ULONG flags */
		MUIO_Button         = 2,  	/* STRPTR label */
		MUIO_Checkmark      = 3,  	/* STRPTR label */
		MUIO_Cycle          = 4,  	/* STRPTR label, STRPTR *entries */
		MUIO_Radio          = 5,  	/* STRPTR label, STRPTR *entries */
		MUIO_Slider         = 6,  	/* STRPTR label, LONG min, LONG max */
		MUIO_String         = 7,  	/* STRPTR label, LONG maxlen */
		MUIO_PopButton      = 8,  	/* STRPTR imagespec */
		MUIO_HSpace         = 9,  	/* LONG space   */
		MUIO_VSpace         =10,  	/* LONG space   */
		MUIO_HBar           =11,  	/* LONG space   */
		MUIO_VBar           =12,  	/* LONG space   */
		MUIO_MenustripNM    =13,  	/* struct NewMenu *nm, ULONG flags */
		MUIO_Menuitem       =14,  	/* STRPTR label, STRPTR shortcut, ULONG flags, ULONG data  */
		MUIO_BarTitle       =15,  	/* STRPTR label */
		MUIO_NumericButton  =16,  	/* STRPTR label, LONG min, LONG max, STRPTR format */
		MUIO_Menuitem_CopyStrings =1<<30,
		MUIO_Label_SingleFrame    =1<< 8,
		MUIO_Label_DoubleFrame    =1<< 9,
		MUIO_Label_LeftAligned    =1<<10,
		MUIO_Label_Centered       =1<<11,
		MUIO_Label_FreeVert       =1<<12,
		MUIO_MenustripNM_CommandKeyCheck  =1<<0	/* check for "localized" menu items such as "O\0Open" */
/***************************************************************************
** ARexx Interface
***************************************************************************/
OBJECT MUI_Command
	Name:PTR TO UBYTE,
	Template:PTR TO UBYTE,
	Parameters:LONG,
	Hook:PTR TO Hook,
	Reserved[5]:LONG
ENDOBJECT

CONST	MC_TEMPLATE_ID=~0
CONST	MUI_RXERR_BADDEFINITION=-1,
		MUI_RXERR_OUTOFMEMORY=-2,
		MUI_RXERR_UNKNOWNCOMMAND=-3,
		MUI_RXERR_BADSYNTAX=-4
CONST	MUIE_OK=0,
		MUIE_OutOfMemory=1,
		MUIE_OutOfGfxMemory=2,
		MUIE_InvalidWindowObject=3,
		MUIE_MissingLibrary=4,
		MUIE_NoARexx=5,
		MUIE_SingleTask=6
CONST	MUII_WindowBack=0,  		/* These images are configured   */
		MUII_RequesterBack=1,  	/* with the preferences program. */
		MUII_ButtonBack=2,
		MUII_ListBack=3,
		MUII_TextBack=4,
		MUII_PropBack=5,
		MUII_PopupBack=6,
		MUII_SelectedBack=7,
		MUII_ListCursor=8,
		MUII_ListSelect=9,
		MUII_ListSelCur=10,
		MUII_ArrowUp=11,
		MUII_ArrowDown=12,
		MUII_ArrowLeft=13,
		MUII_ArrowRight=14,
		MUII_CheckMark=15,
		MUII_RadioButton=16,
		MUII_Cycle=17,
		MUII_PopUp=18,
		MUII_PopFile=19,
		MUII_PopDrawer=20,
		MUII_PropKnob=21,
		MUII_Drawer=22,
		MUII_HardDisk=23,
		MUII_Disk=24,
		MUII_Chip=25,
		MUII_Volume=26,
		MUII_RegisterBack=27,
		MUII_Network=28,
		MUII_Assign=29,
		MUII_TapePlay=30,
		MUII_TapePlayBack=31,
		MUII_TapePause=32,
		MUII_TapeStop=33,
		MUII_TapeRecord=34,
		MUII_GroupBack=35,
		MUII_SliderBack=36,
		MUII_SliderKnob=37,
		MUII_TapeUp=38,
		MUII_TapeDown=39,
		MUII_PageBack=40,
		MUII_ReadListBack=41,
		MUII_Count=42,
		MUII_BACKGROUND=128,
		MUII_SHADOW=129,			/* combinations and are not  */
		MUII_SHINE=130, 			/* affected by users prefs.  */
		MUII_FILL=131,
		MUII_SHADOWBACK=132,   	/* Generally, you should     */
		MUII_SHADOWFILL=133,   	/* avoid using them. Better  */
		MUII_SHADOWSHINE=134,  	/* use one of the customized */
		MUII_FILLBACK=135,   	/* images above.             */
		MUII_FILLSHINE=136,
		MUII_SHINEBACK=137,
		MUII_FILLBACK2=138,
		MUII_HSHINEBACK=139,
		MUII_HSHADOWBACK=140,
		MUII_HSHINESHINE=141,
		MUII_HSHADOWSHADOW=142,
		MUII_MARKSHINE=143,
		MUII_MARKHALFSHINE=144,
		MUII_MARKBACKGROUND=145,
		MUII_LASTPAT=145
CONST	MUIV_TriggerValue=1233727793,
		MUIV_NotTriggerValue=1233727795,
		MUIV_EveryTime=1233727793,
		MUIV_Notify_Self=1,
		MUIV_Notify_Window=2,
		MUIV_Notify_Application=3,
		MUIV_Notify_Parent=4,
		MUIV_Application_Save_ENVARC=~0,
		MUIV_Application_Load_ENV=0,
		MUIV_Application_Load_ENVARC=~0,
		MUIV_Application_ReturnID_Quit=-1,
		MUIV_List_Insert_Top=0,
		MUIV_List_Insert_Active=-1,
		MUIV_List_Insert_Sorted=-2,
		MUIV_List_Insert_Bottom=-3,
		MUIV_List_Remove_First=0,
		MUIV_List_Remove_Active=-1,
		MUIV_List_Remove_Last=-2,
		MUIV_List_Remove_Selected=-3,
		MUIV_List_Select_Off=0,
		MUIV_List_Select_On=1,
		MUIV_List_Select_Toggle=2,
		MUIV_List_Select_Ask=3,
		MUIV_List_GetEntry_Active=-1,
		MUIV_List_Select_Active=-1,
		MUIV_List_Select_All=-2,
		MUIV_List_Redraw_Active=-1,
		MUIV_List_Redraw_All=-2,
		MUIV_List_Move_Top=0,
		MUIV_List_Move_Active=-1,
		MUIV_List_Move_Bottom=-2,
		MUIV_List_Move_Next=-3,
		MUIV_List_Move_Previous=-4,
		MUIV_List_Exchange_Top=0,
		MUIV_List_Exchange_Active=-1,
		MUIV_List_Exchange_Bottom=-2,
		MUIV_List_Exchange_Next=-3,
		MUIV_List_Exchange_Previous=-4,
		MUIV_List_Jump_Top=0,
		MUIV_List_Jump_Active=-1,
		MUIV_List_Jump_Bottom=-2,
		MUIV_List_Jump_Up=-4,
		MUIV_List_Jump_Down=-3,
		MUIV_List_NextSelected_Start=-1,
		MUIV_List_NextSelected_End=-1,
		MUIV_DragQuery_Refuse=0,
		MUIV_DragQuery_Accept=1,
		MUIV_DragReport_Abort=0,
		MUIV_DragReport_Continue=1,
		MUIV_DragReport_Lock=2,
		MUIV_DragReport_Refresh=3
#define MUIX_R  '\033r'   	/* right justified */
#define MUIX_C  '\033c'   	/* centered        */
#define MUIX_L  '\033l'   	/* left justified  */
#define MUIX_N  '\033n'   	/* normal     */
#define MUIX_B  '\033b'   	/* bold       */
#define MUIX_I  '\033i'   	/* italic     */
#define MUIX_U  '\033u'   	/* underlined */
#define MUIX_PT  '\0332'  	/* text pen           */
#define MUIX_PH  '\0338'  	/* highlight text pen */
/***************************************************************************
** Parameter structures for some classes
***************************************************************************/
OBJECT MUI_Palette_Entry
	ID:LONG,
	Red:ULONG,
	Green:ULONG,
	Blue:ULONG,
	Group:LONG
ENDOBJECT

CONST	MUIV_Palette_Entry_End=-1
/*****************************/
/* Application Input Handler */
/*****************************/
OBJECT MUI_InputHandlerNode
	Node:MinNode,
	Object:PTR TO _Object,
	Signals:ULONG,
->RELOFS -4,
	Millis:UWORD,
	Current:UWORD,
	Flags:ULONG,		/* see below */
	Method:ULONG
ENDOBJECT

/* Flags for ihn_Flags */
CONST	MUIIHNF_TIMER=1<<0	/* set ihn_Ticks to number of 1/100 sec ticks you want to be triggered */
/************************/
/* Window Event Handler */
/************************/
OBJECT MUI_EventHandlerNode
	Node:MinNode,
	Reserved:BYTE,           /* don't touch! */
	Priority:BYTE,           /* event handlers are inserted according to their priority. */
	Flags:UWORD,             /* certain flags, see below for definitions. */
	Object:PTR TO _Object,    /* object which should receive MUIM_HandleEvent. */
	Class:PTR TO IClass,     /* if !=NULL, MUIM_HandleEvent is invoked on exactly this class with CoerceMethod(). */
	Events:ULONG             /* one or more IDCMP flags this handler should react on. */
ENDOBJECT

/* flags for ehn_Flags */
CONST	MUI_EHF_ALWAYSKEYS=1<<0
/* other values reserved for future use */
/* return values for MUIM_HandleEvent (bit-masked, all other bits must be 0) */
CONST	MUI_EventHandlerRC_Eat=1<<0	/* stop MUI from calling other handlers */
/**********************/
/* List Position Test */
/**********************/
OBJECT MUI_List_TestPos_Result
	entry:LONG,      /* number of entry, -1 if mouse not over valid entry */
	column:WORD,     /* numer of column, -1 if no valid column */
	flags:UWORD,     /* see below */
	xoffset:WORD,    /* x offset of mouse click relative to column start */
	yoffset:WORD     /* y offset of mouse click from center of line
	                  (negative values mean click was above center,
	                   positive values mean click was below center) */
ENDOBJECT

CONST	MUI_LPR_ABOVE=1<<0,
		MUI_LPR_BELOW=1<<1,
		MUI_LPR_LEFT =1<<2,
		MUI_LPR_RIGHT=1<<3
/***************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below. If you dont want, just define MUI_NOSHORTCUTS to disable
** them.
**
** These macros are available to C programmers only.
**
***************************************************************************/
#ifndef MUI_NOSHORTCUTS
/***************************************************************************
**
** Object Generation
** -----------------
**
** The xxxObject (and xChilds) macros generate new instances of MUI classes.
** Every xxxObject can be followed by tagitems specifying initial create
** time attributes for the new object and must be terminated with the
** End macro:
**
** obj = StringObject,
**          MUIA_String_Contents, "foo",
**          MUIA_String_MaxLen  , 40,
**          End;
**
** With the Child, SubWindow and WindowContents shortcuts you can
** construct a complete GUI within one command:
**
** app = ApplicationObject,
**
**          ...
**
**          SubWindow, WindowObject,
**             WindowContents, VGroup,
**                Child, String("foo",40),
**                Child, String("bar",50),
**                Child, HGroup,
**                   Child, CheckMark(TRUE),
**                   Child, CheckMark(FALSE),
**                   End,
**                End,
**             End,
**
**          SubWindow, WindowObject,
**             WindowContents, HGroup,
**                Child, ...,
**                Child, ...,
**                End,
**             End,
**
**          ...
**
**          End;
**
***************************************************************************/
#define MenustripObject      MUI_NewObject(MUIC_Menustrip
#define MenuObject           MUI_NewObject(MUIC_Menu
#define MenuObjectT(name )   MUI_NewObject(MUIC_Menu,MUIA_Menu_Title,name
#define MenuitemObject       MUI_NewObject(MUIC_Menuitem
#define WindowObject         MUI_NewObject(MUIC_Window
#define ImageObject          MUI_NewObject(MUIC_Image
#define BitmapObject         MUI_NewObject(MUIC_Bitmap
#define BodychunkObject      MUI_NewObject(MUIC_Bodychunk
#define NotifyObject         MUI_NewObject(MUIC_Notify
#define ApplicationObject    MUI_NewObject(MUIC_Application
#define TextObject           MUI_NewObject(MUIC_Text
#define RectangleObject      MUI_NewObject(MUIC_Rectangle
#define BalanceObject        MUI_NewObject(MUIC_Balance
#define ListObject           MUI_NewObject(MUIC_List
#define PropObject           MUI_NewObject(MUIC_Prop
#define StringObject         MUI_NewObject(MUIC_String
#define ScrollbarObject      MUI_NewObject(MUIC_Scrollbar
#define ListviewObject       MUI_NewObject(MUIC_Listview
#define RadioObject          MUI_NewObject(MUIC_Radio
#define VolumelistObject     MUI_NewObject(MUIC_Volumelist
#define FloattextObject      MUI_NewObject(MUIC_Floattext
#define DirlistObject        MUI_NewObject(MUIC_Dirlist
#define CycleObject          MUI_NewObject(MUIC_Cycle
#define GaugeObject          MUI_NewObject(MUIC_Gauge
#define ScaleObject          MUI_NewObject(MUIC_Scale
#define NumericObject        MUI_NewObject(MUIC_Numeric
#define SliderObject         MUI_NewObject(MUIC_Slider
#define NumericbuttonObject  MUI_NewObject(MUIC_Numericbutton
#define KnobObject           MUI_NewObject(MUIC_Knob
#define LevelmeterObject     MUI_NewObject(MUIC_Levelmeter
#define BoopsiObject         MUI_NewObject(MUIC_Boopsi
#define ColorfieldObject     MUI_NewObject(MUIC_Colorfield
#define PenadjustObject      MUI_NewObject(MUIC_Penadjust
#define ColoradjustObject    MUI_NewObject(MUIC_Coloradjust
#define PaletteObject        MUI_NewObject(MUIC_Palette
#define GroupObject          MUI_NewObject(MUIC_Group
#define RegisterObject       MUI_NewObject(MUIC_Register
#define VirtgroupObject      MUI_NewObject(MUIC_Virtgroup
#define ScrollgroupObject    MUI_NewObject(MUIC_Scrollgroup
#define PopstringObject      MUI_NewObject(MUIC_Popstring
#define PopobjectObject      MUI_NewObject(MUIC_Popobject
#define PoplistObject        MUI_NewObject(MUIC_Poplist
#define PopaslObject         MUI_NewObject(MUIC_Popasl
#define PendisplayObject     MUI_NewObject(MUIC_Pendisplay
#define PoppenObject         MUI_NewObject(MUIC_Poppen
#define AboutmuiObject       MUI_NewObject(MUIC_Aboutmui
#define ScrmodelistObject    MUI_NewObject(MUIC_Scrmodelist
#define KeyentryObject       MUI_NewObject(MUIC_Keyentry
#define VGroup               MUI_NewObject(MUIC_Group
#define HGroup               MUI_NewObject(MUIC_Group,MUIA_Group_Horiz,TRUE
#define ColGroup(cols )      MUI_NewObject(MUIC_Group,MUIA_Group_Columns,(cols)
#define RowGroup(rows )      MUI_NewObject(MUIC_Group,MUIA_Group_Rows   ,(rows)
#define PageGroup            MUI_NewObject(MUIC_Group,MUIA_Group_PageMode,TRUE
#define VGroupV              MUI_NewObject(MUIC_Virtgroup
#define HGroupV              MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Horiz,TRUE
#define ColGroupV(cols )     MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Columns,(cols)
#define RowGroupV(rows )     MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Rows   ,(rows)
#define PageGroupV           MUI_NewObject(MUIC_Virtgroup,MUIA_Group_PageMode,TRUE
#define RegisterGroup(t )    MUI_NewObject(MUIC_Register,MUIA_Register_Titles,(t)
#define End                  TAG_DONE)
#define Child              MUIA_Group_Child
#define SubWindow          MUIA_Application_Window
#define WindowContents     MUIA_Window_RootObject
/***************************************************************************
**
** Frame Types
** -----------
**
** These macros may be used to specify one of MUI's different frame types.
** Note that every macro consists of one { ti_Tag, ti_Data } pair.
**
** GroupFrameT() is a special kind of frame that contains a centered
** title text.
**
** HGroup, GroupFrameT("Horiz Groups"),
**    Child, RectangleObject, TextFrame  , End,
**    Child, RectangleObject, StringFrame, End,
**    Child, RectangleObject, ButtonFrame, End,
**    Child, RectangleObject, ListFrame  , End,
**    End,
**
***************************************************************************/
#define NoFrame           MUIA_Frame, MUIV_Frame_None
#define ButtonFrame       MUIA_Frame, MUIV_Frame_Button
#define ImageButtonFrame  MUIA_Frame, MUIV_Frame_ImageButton
#define TextFrame         MUIA_Frame, MUIV_Frame_Text
#define StringFrame       MUIA_Frame, MUIV_Frame_String
#define ReadListFrame     MUIA_Frame, MUIV_Frame_ReadList
#define InputListFrame    MUIA_Frame, MUIV_Frame_InputList
#define PropFrame         MUIA_Frame, MUIV_Frame_Prop
#define SliderFrame       MUIA_Frame, MUIV_Frame_Slider
#define GaugeFrame        MUIA_Frame, MUIV_Frame_Gauge
#define VirtualFrame      MUIA_Frame, MUIV_Frame_Virtual
#define GroupFrame        MUIA_Frame, MUIV_Frame_Group
#define GroupFrameT(s )   MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s, MUIA_Background, MUII_GroupBack
/***************************************************************************
**
** Spacing Macros
** --------------
**
***************************************************************************/
#define HVSpace            MUI_NewObject(MUIC_Rectangle,TAG_DONE)
#define HSpace(x )         MUI_MakeObject(MUIO_HSpace,x)
#define VSpace(x )         MUI_MakeObject(MUIO_VSpace,x)
#define HCenter(obj )      (HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End)
#define VCenter(obj )      (VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End)
#define InnerSpacing(h,v ) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x )   MUIA_Group_Spacing,x
#ifdef MUI_OBSOLETE
#define String(contents,maxlen )\
 StringObject,\
 StringFrame,\
 MUIA_String_MaxLen  , maxlen,\
 MUIA_String_Contents, contents,\
 End
#define KeyString(contents,maxlen,controlchar )\
 StringObject,\
 StringFrame,\
 MUIA_ControlChar    , controlchar,\
 MUIA_String_MaxLen  , maxlen,\
 MUIA_String_Contents, contents,\
 End
#endif
#ifdef MUI_OBSOLETE
#define CheckMark(selected )\
 ImageObject,\
 ImageButtonFrame,\
 MUIA_InputMode        , MUIV_InputMode_Toggle,\
 MUIA_Image_Spec       , MUII_CheckMark,\
 MUIA_Image_FreeVert   , TRUE,\
 MUIA_Selected         , selected,\
 MUIA_Background       , MUII_ButtonBack,\
 MUIA_ShowSelState     , FALSE,\
 End
#define KeyCheckMark(selected,control )\
 ImageObject,\
 ImageButtonFrame,\
 MUIA_InputMode        , MUIV_InputMode_Toggle,\
 MUIA_Image_Spec       , MUII_CheckMark,\
 MUIA_Image_FreeVert   , TRUE,\
 MUIA_Selected         , selected,\
 MUIA_Background       , MUII_ButtonBack,\
 MUIA_ShowSelState     , FALSE,\
 MUIA_ControlChar      , control,\
 End
#endif
/***************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**       KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
***************************************************************************/
#define SimpleButton(label ) MUI_MakeObject(MUIO_Button,label)
#ifdef MUI_OBSOLETE
#define KeyButton(name,key )\
 TextObject,\
 ButtonFrame,\
 MUIA_Font, MUIV_Font_Button,\
 MUIA_Text_Contents, name,\
 MUIA_Text_PreParse, '\33c',\
 MUIA_Text_HiChar  , key,\
 MUIA_ControlChar  , key,\
 MUIA_InputMode    , MUIV_InputMode_RelVerify,\
 MUIA_Background   , MUII_ButtonBack,\
 End
#endif
#ifdef MUI_OBSOLETE
#define Cycle(entries )        CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End
#define KeyCycle(entries,key ) CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End
/***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************/
#define Radio(name,array )\
 RadioObject,\
 GroupFrameT(name),\
 MUIA_Radio_Entries,array,\
 End
#define KeyRadio(name,array,key )\
 RadioObject,\
 GroupFrameT(name),\
 MUIA_Radio_Entries,array,\
 MUIA_ControlChar, key,\
 End
/***************************************************************************
**
** Slider-Object
** -------------
**
***************************************************************************/
#define Slider(min,max,level )\
 SliderObject,\
 MUIA_Numeric_Min  , min,\
 MUIA_Numeric_Max  , max,\
 MUIA_Numeric_Value, level,\
 End
#define KeySlider(min,max,level,key )\
 SliderObject,\
 MUIA_Numeric_Min  , min,\
 MUIA_Numeric_Max  , max,\
 MUIA_Numeric_Value, level,\
 MUIA_ControlChar , key,\
 End
#endif
/***************************************************************************
**
** Button to be used for popup objects
**
***************************************************************************/
#define PopButton(img ) MUI_MakeObject(MUIO_PopButton,img)
/***************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**   Small: |foo   |
**  Normal: |bar   |
**     Big: |foobar|
**    Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2),
** 	Child, Label2("Small:" ),
**    Child, StringObject, End,
** 	Child, Label2("Normal:"),
**    Child, StringObject, End,
** 	Child, Label2("Big:"   ),
**    Child, StringObject, End,
** 	Child, Label2("Huge:"  ),
**    Child, StringObject, End,
**    End,
**
** Note that we have three versions of the label macro, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These macros ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
***************************************************************************/
#define Label(label )   MUI_MakeObject(MUIO_Label,label,0)
#define Label1(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame)
#define Label2(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame)
#define LLabel(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned)
#define LLabel1(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame)
#define LLabel2(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame)
#define CLabel(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered)
#define CLabel1(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_SingleFrame)
#define CLabel2(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_DoubleFrame)
#define FreeLabel(label )   MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert)
#define FreeLabel1(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_SingleFrame)
#define FreeLabel2(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame)
#define FreeLLabel(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned)
#define FreeLLabel1(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame)
#define FreeLLabel2(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame)
#define FreeCLabel(label )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered)
#define FreeCLabel1(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame)
#define FreeCLabel2(label ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame)
#define KeyLabel(label,key )   MUI_MakeObject(MUIO_Label,label,key)
#define KeyLabel1(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame|(key))
#define KeyLabel2(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame|(key))
#define KeyLLabel(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|(key))
#define KeyLLabel1(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key))
#define KeyLLabel2(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key))
#define KeyCLabel(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|(key))
#define KeyCLabel1(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_SingleFrame|(key))
#define KeyCLabel2(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key))
#define FreeKeyLabel(label,key )   MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|(key))
#define FreeKeyLabel1(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_SingleFrame|(key))
#define FreeKeyLabel2(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame|(key))
#define FreeKeyLLabel(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|(key))
#define FreeKeyLLabel1(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key))
#define FreeKeyLLabel2(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key))
#define FreeKeyCLabel(label,key )  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|(key))
#define FreeKeyCLabel1(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame|(key))
#define FreeKeyCLabel2(label,key ) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key))
/***************************************************************************
**
** Controlling Objects
** -------------------
**
** set() and get() are two short stubs for BOOPSI GetAttr() and SetAttrs()
** calls:
**
** {
**    char *x;
**
**    set(obj,MUIA_String_Contents,"foobar");
**    get(obj,MUIA_String_Contents,&x);
**
**    printf("gadget contains '%s'\n",x);
** }
**
** nnset() sets an attribute without triggering a possible notification.
**
***************************************************************************/
#ifndef __cplusplus
#define get(obj,attr,store ) GetAttr(attr,obj,store)
#define set(obj,attr,value ) SetAttrs(obj,attr,value,TAG_DONE)
#define nnset(obj,attr,value ) SetAttrs(obj,MUIA_NoNotify,TRUE,attr,value,TAG_DONE)
#define setmutex(obj,n )     set(obj,MUIA_Radio_Active,n)
#define setcycle(obj,n )     set(obj,MUIA_Cycle_Active,n)
#define setstring(obj,s )    set(obj,MUIA_String_Contents,s)
#define setcheckmark(obj,b ) set(obj,MUIA_Selected,b)
#define setslider(obj,l )    set(obj,MUIA_Numeric_Value,l)
#endif
#endif
/* MUI_NOSHORTCUTS */
/***************************************************************************
**
** For Boopsi Image Implementors Only:
**
** If MUI is using a boopsi image object, it will send a special method
** immediately after object creation. This method has a parameter structure
** where the boopsi can fill in its minimum and maximum size and learn if
** its used in a horizontal or vertical context.
**
** The boopsi image must use the method id (MUIM_BoopsiQuery) as return
** value. That's how MUI sees that the method is implemented.
**
** Note: MUI does not depend on this method. If the boopsi image doesn't
**       implement it, minimum size will be 0 and maximum size unlimited.
**
***************************************************************************/
CONST	MUIM_BoopsiQuery=$80427157 	/* this is send to the boopsi and */
/* must be used as return value   */
OBJECT MUI_BoopsiQuery                             /* parameter structure */
	MethodID:ULONG,                      /* always MUIM_BoopsiQuery */
	Screen:PTR TO Screen,                /* obsolete, use mbq_RenderInfo */
	Flags:ULONG,                         /* read only, see below */
	MinWidth:LONG,                       /* write only, fill in min width  */
	MinHeight:LONG,                      /* write only, fill in min height */
	MaxWidth:LONG,                       /* write only, fill in max width  */
	MaxHeight:LONG,                      /* write only, fill in max height */
	DefWidth:LONG,                       /* write only, fill in def width  */
	DefHeight:LONG,                      /* write only, fill in def height */
	RenderInfo:PTR TO MUI_RenderInfo     /* read only, display context */
ENDOBJECT

#define MUIP_BoopsiQuery  MUI_BoopsiQuery 	/* old structure name */
CONST	MBQF_HORIZ=1<<0          	/* object used in a horizontal */
/* context (else vertical)     */
CONST	MBQ_MUI_MAXMAX=10000         	/* use this for unlimited MaxWidth/Height */
/*******************************************/
/* Begin of automatic header file creation */
/*******************************************/
/****************************************************************************/
/** Notify                                                                 **/
/****************************************************************************/
#define MUIC_Notify  'Notify.mui'
/* Methods */
CONST	MUIM_CallHook                        =$8042b96b, 	/* V4  */
		MUIM_Export                          =$80420f1c, 	/* V12 */
		MUIM_FindUData                       =$8042c196, 	/* V8  */
		MUIM_GetConfigItem                   =$80423edb, 	/* V11 */
		MUIM_GetUData                        =$8042ed0c, 	/* V8  */
		MUIM_Import                          =$8042d012, 	/* V12 */
		MUIM_KillNotify                      =$8042d240, 	/* V4  */
		MUIM_KillNotifyObj                   =$8042b145, 	/* V16 */
		MUIM_MultiSet                        =$8042d356, 	/* V7  */
		MUIM_NoNotifySet                     =$8042216f, 	/* V9  */
		MUIM_Notify                          =$8042c9cb, 	/* V4  */
		MUIM_Set                             =$8042549a, 	/* V4  */
		MUIM_SetAsString                     =$80422590, 	/* V4  */
		MUIM_SetUData                        =$8042c920, 	/* V8  */
		MUIM_SetUDataOnce                    =$8042ca19, 	/* V11 */
		MUIM_WriteLong                       =$80428d86, 	/* V6  */
		MUIM_WriteString                     =$80424bf4 	/* V6  */

OBJECT MUIP_CallHook
	MethodID:ULONG,
	Hook:PTR TO Hook,
	param1:ULONG         /* ... */
ENDOBJECT

OBJECT MUIP_Export
	MethodID:ULONG,
	dataspace:PTR TO _Object
ENDOBJECT

OBJECT MUIP_FindUData
	MethodID:ULONG,
	udata:ULONG
ENDOBJECT

OBJECT MUIP_GetConfigItem
	MethodID:ULONG,
	id:ULONG,
	storage:PTR TO ULONG
ENDOBJECT

OBJECT MUIP_GetUData
	MethodID:ULONG,
	udata:ULONG,
	attr:ULONG,
	storage:PTR TO ULONG
ENDOBJECT

OBJECT MUIP_Import
	MethodID:ULONG,
	dataspace:PTR TO _Object
ENDOBJECT

OBJECT MUIP_KillNotify
	MethodID:ULONG,
	TrigAttr:ULONG
ENDOBJECT

OBJECT MUIP_KillNotifyObj
	MethodID:ULONG,
	TrigAttr:ULONG,
	dest:PTR TO _Object
ENDOBJECT

OBJECT MUIP_MultiSet
	MethodID:ULONG,
	attr:ULONG,
	val:ULONG,
	obj:LONG            /* ... */
ENDOBJECT

OBJECT MUIP_NoNotifySet
	MethodID:ULONG,
	attr:ULONG,
	format:PTR TO UBYTE,
	val:ULONG               /* ... */
ENDOBJECT

OBJECT MUIP_Notify
	MethodID:ULONG,
	TrigAttr:ULONG,
	TrigVal:ULONG,
	DestObj:LONG,
	FollowParams:ULONG     /* ... */
ENDOBJECT

OBJECT MUIP_Set
	MethodID:ULONG,
	attr:ULONG,
	val:ULONG
ENDOBJECT

OBJECT MUIP_SetAsString
	MethodID:ULONG,
	attr:ULONG,
	format:PTR TO UBYTE,
	val:ULONG               /* ... */
ENDOBJECT

OBJECT MUIP_SetUData
	MethodID:ULONG,
	udata:ULONG,
	attr:ULONG,
	val:ULONG
ENDOBJECT

OBJECT MUIP_SetUDataOnce
	MethodID:ULONG,
	udata:ULONG,
	attr:ULONG,
	val:ULONG
ENDOBJECT

OBJECT MUIP_WriteLong
	MethodID:ULONG,
	val:ULONG,
	memory:PTR TO ULONG
ENDOBJECT

OBJECT MUIP_WriteString
	MethodID:ULONG,
	str:PTR TO UBYTE,
	memory:PTR TO UBYTE
ENDOBJECT

/* Attributes */
CONST	MUIA_ApplicationObject               =$8042d3ee, 	/* V4  ..g Object *          */
		MUIA_AppMessage                      =$80421955, 	/* V5  ..g struct AppMessage * */
		MUIA_HelpLine                        =$8042a825, 	/* V4  isg LONG              */
		MUIA_HelpNode                        =$80420b85, 	/* V4  isg STRPTR            */
		MUIA_NoNotify                        =$804237f9, 	/* V7  .s. BOOL              */
		MUIA_ObjectID                        =$8042d76e, 	/* V11 isg ULONG             */
		MUIA_Parent                          =$8042e35f, 	/* V11 ..g Object *          */
		MUIA_Revision                        =$80427eaa, 	/* V4  ..g LONG              */
		MUIA_UserData                        =$80420313, 	/* V4  isg ULONG             */
		MUIA_Version                         =$80422301 	/* V4  ..g LONG              */
/****************************************************************************/
/** Family                                                                 **/
/****************************************************************************/
#define MUIC_Family  'Family.mui'
/* Methods */
CONST	MUIM_Family_AddHead                  =$8042e200, 	/* V8  */
		MUIM_Family_AddTail                  =$8042d752, 	/* V8  */
		MUIM_Family_Insert                   =$80424d34, 	/* V8  */
		MUIM_Family_Remove                   =$8042f8a9, 	/* V8  */
		MUIM_Family_Sort                     =$80421c49, 	/* V8  */
		MUIM_Family_Transfer                 =$8042c14a 	/* V8  */

OBJECT MUIP_Family_AddHead
	MethodID:ULONG,
	obj:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Family_AddTail
	MethodID:ULONG,
	obj:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Family_Insert
	MethodID:ULONG,
	obj:PTR TO _Object,
	pred:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Family_Remove
	MethodID:ULONG,
	obj:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Family_Sort
	MethodID:ULONG,
	obj[1]:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Family_Transfer
	MethodID:ULONG,
	family:PTR TO _Object
ENDOBJECT

/* Attributes */
CONST	MUIA_Family_Child                    =$8042c696, 	/* V8  i.. Object *          */
		MUIA_Family_List                     =$80424b9e 	/* V8  ..g struct MinList *  */
/****************************************************************************/
/** Menustrip                                                              **/
/****************************************************************************/
#define MUIC_Menustrip  'Menustrip.mui'
/* Methods */
/* Attributes */
CONST	MUIA_Menustrip_Enabled               =$8042815b 	/* V8  isg BOOL              */
/****************************************************************************/
/** Menu                                                                   **/
/****************************************************************************/
#define MUIC_Menu  'Menu.mui'
/* Methods */
/* Attributes */
CONST	MUIA_Menu_Enabled                    =$8042ed48, 	/* V8  isg BOOL              */
		MUIA_Menu_Title                      =$8042a0e3 	/* V8  isg STRPTR            */
/****************************************************************************/
/** Menuitem                                                               **/
/****************************************************************************/
#define MUIC_Menuitem  'Menuitem.mui'
/* Methods */
/* Attributes */
CONST	MUIA_Menuitem_Checked                =$8042562a, 	/* V8  isg BOOL              */
		MUIA_Menuitem_Checkit                =$80425ace, 	/* V8  isg BOOL              */
		MUIA_Menuitem_CommandString          =$8042b9cc, 	/* V16 isg BOOL              */
		MUIA_Menuitem_Enabled                =$8042ae0f, 	/* V8  isg BOOL              */
		MUIA_Menuitem_Exclude                =$80420bc6, 	/* V8  isg LONG              */
		MUIA_Menuitem_Shortcut               =$80422030, 	/* V8  isg STRPTR            */
		MUIA_Menuitem_Title                  =$804218be, 	/* V8  isg STRPTR            */
		MUIA_Menuitem_Toggle                 =$80424d5c, 	/* V8  isg BOOL              */
		MUIA_Menuitem_Trigger                =$80426f32 	/* V8  ..g struct MenuItem * */
CONST	MUIV_Menuitem_Shortcut_Check=-1
/****************************************************************************/
/** Application                                                            **/
/****************************************************************************/
#define MUIC_Application  'Application.mui'
/* Methods */
#define MUIM_Application_AboutMUI            $8042d21d 	/* V14 */
#define MUIM_Application_AddInputHandler     $8042f099 	/* V11 */
#define MUIM_Application_CheckRefresh        $80424d68 	/* V11 */
#ifdef MUI_OBSOLETE
#define MUIM_Application_GetMenuCheck        $8042c0a7 	/* V4  */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIM_Application_GetMenuState        $8042a58f 	/* V4  */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIM_Application_Input               $8042d0f5 	/* V4  */
#endif
/* MUI_OBSOLETE */
#define MUIM_Application_InputBuffered       $80427e59 	/* V4  */
#define MUIM_Application_Load                $8042f90d 	/* V4  */
#define MUIM_Application_NewInput            $80423ba6 	/* V11 */
#define MUIM_Application_OpenConfigWindow    $804299ba 	/* V11 */
#define MUIM_Application_PushMethod          $80429ef8 	/* V4  */
#define MUIM_Application_RemInputHandler     $8042e7af 	/* V11 */
#define MUIM_Application_ReturnID            $804276ef 	/* V4  */
#define MUIM_Application_Save                $804227ef 	/* V4  */
#define MUIM_Application_SetConfigItem       $80424a80 	/* V11 */
#ifdef MUI_OBSOLETE
#define MUIM_Application_SetMenuCheck        $8042a707 	/* V4  */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIM_Application_SetMenuState        $80428bef 	/* V4  */
#endif
/* MUI_OBSOLETE */
#define MUIM_Application_ShowHelp            $80426479 	/* V4  */
OBJECT MUIP_Application_AboutMUI
	MethodID:ULONG,
	refwindow:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Application_AddInputHandler
	MethodID:ULONG,
	ihnode:PTR TO MUI_InputHandlerNode
ENDOBJECT

OBJECT MUIP_Application_CheckRefresh
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Application_GetMenuCheck
	MethodID:ULONG,
	MenuID:ULONG
ENDOBJECT

OBJECT MUIP_Application_GetMenuState
	MethodID:ULONG,
	MenuID:ULONG
ENDOBJECT

OBJECT MUIP_Application_Input
	MethodID:ULONG,
	signal:PTR TO ULONG
ENDOBJECT

OBJECT MUIP_Application_InputBuffered
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Application_Load
	MethodID:ULONG,
	name:PTR TO UBYTE
ENDOBJECT

OBJECT MUIP_Application_NewInput
	MethodID:ULONG,
	signal:PTR TO ULONG
ENDOBJECT

OBJECT MUIP_Application_OpenConfigWindow
	MethodID:ULONG,
	flags:ULONG
ENDOBJECT

OBJECT MUIP_Application_PushMethod
	MethodID:ULONG,
	dest:PTR TO _Object,
	count:LONG             /* ... */
ENDOBJECT

OBJECT MUIP_Application_RemInputHandler
	MethodID:ULONG,
	ihnode:PTR TO MUI_InputHandlerNode
ENDOBJECT

OBJECT MUIP_Application_ReturnID
	MethodID:ULONG,
	retid:ULONG
ENDOBJECT

OBJECT MUIP_Application_Save
	MethodID:ULONG,
	name:PTR TO UBYTE
ENDOBJECT

OBJECT MUIP_Application_SetConfigItem
	MethodID:ULONG,
	item:ULONG,
	data:LONG
ENDOBJECT

OBJECT MUIP_Application_SetMenuCheck
	MethodID:ULONG,
	MenuID:ULONG,
	stat:LONG
ENDOBJECT

OBJECT MUIP_Application_SetMenuState
	MethodID:ULONG,
	MenuID:ULONG,
	stat:LONG
ENDOBJECT

OBJECT MUIP_Application_ShowHelp
	MethodID:ULONG,
	window:PTR TO _Object,
	name:PTR TO UBYTE,
	node:PTR TO UBYTE,
	line:LONG
ENDOBJECT

/* Attributes */
#define MUIA_Application_Active              $804260ab 	/* V4  isg BOOL              */
#define MUIA_Application_Author              $80424842 	/* V4  i.g STRPTR            */
#define MUIA_Application_Base                $8042e07a 	/* V4  i.g STRPTR            */
#define MUIA_Application_Broker              $8042dbce 	/* V4  ..g Broker *          */
#define MUIA_Application_BrokerHook          $80428f4b 	/* V4  isg struct Hook *     */
#define MUIA_Application_BrokerPort          $8042e0ad 	/* V6  ..g struct MsgPort *  */
#define MUIA_Application_BrokerPri           $8042c8d0 	/* V6  i.g LONG              */
#define MUIA_Application_Commands            $80428648 	/* V4  isg struct MUI_Command * */
#define MUIA_Application_Copyright           $8042ef4d 	/* V4  i.g STRPTR            */
#define MUIA_Application_Description         $80421fc6 	/* V4  i.g STRPTR            */
#define MUIA_Application_DiskObject          $804235cb 	/* V4  isg struct DiskObject * */
#define MUIA_Application_DoubleStart         $80423bc6 	/* V4  ..g BOOL              */
#define MUIA_Application_DropObject          $80421266 	/* V5  is. Object *          */
#define MUIA_Application_ForceQuit           $804257df 	/* V8  ..g BOOL              */
#define MUIA_Application_HelpFile            $804293f4 	/* V8  isg STRPTR            */
#define MUIA_Application_Iconified           $8042a07f 	/* V4  .sg BOOL              */
#ifdef MUI_OBSOLETE
#define MUIA_Application_Menu                $80420e1f 	/* V4  i.g struct NewMenu *  */
#endif
/* MUI_OBSOLETE */
#define MUIA_Application_MenuAction          $80428961 	/* V4  ..g ULONG             */
#define MUIA_Application_MenuHelp            $8042540b 	/* V4  ..g ULONG             */
#define MUIA_Application_Menustrip           $804252d9 	/* V8  i.. Object *          */
#define MUIA_Application_RexxHook            $80427c42 	/* V7  isg struct Hook *     */
#define MUIA_Application_RexxMsg             $8042fd88 	/* V4  ..g struct RxMsg *    */
#define MUIA_Application_RexxString          $8042d711 	/* V4  .s. STRPTR            */
#define MUIA_Application_SingleTask          $8042a2c8 	/* V4  i.. BOOL              */
#define MUIA_Application_Sleep               $80425711 	/* V4  .s. BOOL              */
#define MUIA_Application_Title               $804281b8 	/* V4  i.g STRPTR            */
#define MUIA_Application_UseCommodities      $80425ee5 	/* V10 i.. BOOL              */
#define MUIA_Application_UseRexx             $80422387 	/* V10 i.. BOOL              */
#define MUIA_Application_Version             $8042b33f 	/* V4  i.g STRPTR            */
#define MUIA_Application_Window              $8042bfe0 	/* V4  i.. Object *          */
#define MUIA_Application_WindowList          $80429abe 	/* V13 ..g struct List *     */
CONST	MUIV_Application_Package_NetConnect=-1543537847
/****************************************************************************/
/** Window                                                                 **/
/****************************************************************************/
#define MUIC_Window  'Window.mui'
/* Methods */
#define MUIM_Window_AddEventHandler          $804203b7 	/* V16 */
#ifdef MUI_OBSOLETE
#define MUIM_Window_GetMenuCheck             $80420414 	/* V4  */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIM_Window_GetMenuState             $80420d2f 	/* V4  */
#endif
/* MUI_OBSOLETE */
#define MUIM_Window_RemEventHandler          $8042679e 	/* V16 */
#define MUIM_Window_ScreenToBack             $8042913d 	/* V4  */
#define MUIM_Window_ScreenToFront            $804227a4 	/* V4  */
#ifdef MUI_OBSOLETE
#define MUIM_Window_SetCycleChain            $80426510 	/* V4  */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIM_Window_SetMenuCheck             $80422243 	/* V4  */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIM_Window_SetMenuState             $80422b5e 	/* V4  */
#endif
/* MUI_OBSOLETE */
#define MUIM_Window_Snapshot                 $8042945e 	/* V11 */
#define MUIM_Window_ToBack                   $8042152e 	/* V4  */
#define MUIM_Window_ToFront                  $8042554f 	/* V4  */
OBJECT MUIP_Window_AddEventHandler
	MethodID:ULONG,
	ehnode:PTR TO MUI_EventHandlerNode
ENDOBJECT

OBJECT MUIP_Window_GetMenuCheck
	MethodID:ULONG,
	MenuID:ULONG
ENDOBJECT

OBJECT MUIP_Window_GetMenuState
	MethodID:ULONG,
	MenuID:ULONG
ENDOBJECT

OBJECT MUIP_Window_RemEventHandler
	MethodID:ULONG,
	ehnode:PTR TO MUI_EventHandlerNode
ENDOBJECT

OBJECT MUIP_Window_ScreenToBack
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Window_ScreenToFront
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Window_SetCycleChain
	MethodID:ULONG,
	obj[1]:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Window_SetMenuCheck
	MethodID:ULONG,
	MenuID:ULONG,
	stat:LONG
ENDOBJECT

OBJECT MUIP_Window_SetMenuState
	MethodID:ULONG,
	MenuID:ULONG,
	stat:LONG
ENDOBJECT

OBJECT MUIP_Window_Snapshot
	MethodID:ULONG,
	flags:LONG
ENDOBJECT

OBJECT MUIP_Window_ToBack
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Window_ToFront
	MethodID:ULONG
ENDOBJECT

/* Attributes */
#define MUIA_Window_Activate                 $80428d2f 	/* V4  isg BOOL              */
#define MUIA_Window_ActiveObject             $80427925 	/* V4  .sg Object *          */
#define MUIA_Window_AltHeight                $8042cce3 	/* V4  i.g LONG              */
#define MUIA_Window_AltLeftEdge              $80422d65 	/* V4  i.g LONG              */
#define MUIA_Window_AltTopEdge               $8042e99b 	/* V4  i.g LONG              */
#define MUIA_Window_AltWidth                 $804260f4 	/* V4  i.g LONG              */
#define MUIA_Window_AppWindow                $804280cf 	/* V5  i.. BOOL              */
#define MUIA_Window_Backdrop                 $8042c0bb 	/* V4  i.. BOOL              */
#define MUIA_Window_Borderless               $80429b79 	/* V4  i.. BOOL              */
#define MUIA_Window_CloseGadget              $8042a110 	/* V4  i.. BOOL              */
#define MUIA_Window_CloseRequest             $8042e86e 	/* V4  ..g BOOL              */
#define MUIA_Window_DefaultObject            $804294d7 	/* V4  isg Object *          */
#define MUIA_Window_DepthGadget              $80421923 	/* V4  i.. BOOL              */
#define MUIA_Window_DragBar                  $8042045d 	/* V4  i.. BOOL              */
#define MUIA_Window_FancyDrawing             $8042bd0e 	/* V8  isg BOOL              */
#define MUIA_Window_Height                   $80425846 	/* V4  i.g LONG              */
#define MUIA_Window_ID                       $804201bd 	/* V4  isg ULONG             */
#define MUIA_Window_InputEvent               $804247d8 	/* V4  ..g struct InputEvent * */
#define MUIA_Window_IsSubWindow              $8042b5aa 	/* V4  isg BOOL              */
#define MUIA_Window_LeftEdge                 $80426c65 	/* V4  i.g LONG              */
#ifdef MUI_OBSOLETE
#define MUIA_Window_Menu                     $8042db94 	/* V4  i.. struct NewMenu *  */
#endif
/* MUI_OBSOLETE */
#define MUIA_Window_MenuAction               $80427521 	/* V8  isg ULONG             */
#define MUIA_Window_Menustrip                $8042855e 	/* V8  i.g Object *          */
#define MUIA_Window_MouseObject              $8042bf9b 	/* V10 ..g Object *          */
#define MUIA_Window_NeedsMouseObject         $8042372a 	/* V10 i.. BOOL              */
#define MUIA_Window_NoMenus                  $80429df5 	/* V4  is. BOOL              */
#define MUIA_Window_Open                     $80428aa0 	/* V4  .sg BOOL              */
#define MUIA_Window_PublicScreen             $804278e4 	/* V6  isg STRPTR            */
#define MUIA_Window_RefWindow                $804201f4 	/* V4  is. Object *          */
#define MUIA_Window_RootObject               $8042cba5 	/* V4  isg Object *          */
#define MUIA_Window_Screen                   $8042df4f 	/* V4  isg struct Screen *   */
#define MUIA_Window_ScreenTitle              $804234b0 	/* V5  isg STRPTR            */
#define MUIA_Window_SizeGadget               $8042e33d 	/* V4  i.. BOOL              */
#define MUIA_Window_SizeRight                $80424780 	/* V4  i.. BOOL              */
#define MUIA_Window_Sleep                    $8042e7db 	/* V4  .sg BOOL              */
#define MUIA_Window_Title                    $8042ad3d 	/* V4  isg STRPTR            */
#define MUIA_Window_TopEdge                  $80427c66 	/* V4  i.g LONG              */
#define MUIA_Window_UseBottomBorderScroller  $80424e79 	/* V13 isg BOOL              */
#define MUIA_Window_UseLeftBorderScroller    $8042433e 	/* V13 isg BOOL              */
#define MUIA_Window_UseRightBorderScroller   $8042c05e 	/* V13 isg BOOL              */
#define MUIA_Window_Width                    $8042dcae 	/* V4  i.g LONG              */
#define MUIA_Window_Window                   $80426a42 	/* V4  ..g struct Window *   */
CONST	MUIV_Window_ActiveObject_None=0,
		MUIV_Window_ActiveObject_Next=-1,
		MUIV_Window_ActiveObject_Prev=-2
#define MUIV_Window_AltHeight_Visible(p ) (-100-(p))
#define MUIV_Window_AltHeight_Screen(p ) (-200-(p))
CONST	MUIV_Window_AltHeight_Scaled=-1000,
		MUIV_Window_AltLeftEdge_Centered=-1,
		MUIV_Window_AltLeftEdge_Moused=-2,
		MUIV_Window_AltLeftEdge_NoChange=-1000,
		MUIV_Window_AltTopEdge_Centered=-1,
		MUIV_Window_AltTopEdge_Moused=-2
CONST	MUIV_Window_AltTopEdge_NoChange=-1000
#define MUIV_Window_AltWidth_MinMax(p ) (0-(p))
#define MUIV_Window_AltWidth_Visible(p ) (-100-(p))
#define MUIV_Window_AltWidth_Screen(p ) (-200-(p))
CONST	MUIV_Window_AltWidth_Scaled=-1000
#define MUIV_Window_Height_MinMax(p ) (0-(p))
#define MUIV_Window_Height_Visible(p ) (-100-(p))
#define MUIV_Window_Height_Screen(p ) (-200-(p))
CONST	MUIV_Window_Height_Scaled=-1000,
		MUIV_Window_Height_Default=-1001,
		MUIV_Window_LeftEdge_Centered=-1,
		MUIV_Window_LeftEdge_Moused=-2
CONST	MUIV_Window_Menu_NoMenu=-1
->#endif
/* MUI_OBSOLETE */
CONST	MUIV_Window_TopEdge_Centered=-1,
		MUIV_Window_TopEdge_Moused=-2
#define MUIV_Window_Width_MinMax(p ) (0-(p))
#define MUIV_Window_Width_Visible(p ) (-100-(p))
#define MUIV_Window_Width_Screen(p ) (-200-(p))
CONST	MUIV_Window_Width_Scaled=-1000,
		MUIV_Window_Width_Default=-1001
/** Aboutmui                                                               **/
/****************************************************************************/
#define MUIC_Aboutmui  'Aboutmui.mui'
/* Methods */
/* Attributes */
#define MUIA_Aboutmui_Application            $80422523 	/* V11 i.. Object *          */
/****************************************************************************/
/** Area                                                                   **/
/****************************************************************************/
#define MUIC_Area  'Area.mui'
/* Methods */
#define MUIM_AskMinMax                       $80423874 	/* Custom Class */
/* V4  */
#define MUIM_Cleanup                         $8042d985 	/* Custom Class */
/* V4  */
#define MUIM_ContextMenuBuild                $80429d2e 	/* V11 */
#define MUIM_ContextMenuChoice               $80420f0e 	/* V11 */
#define MUIM_CreateBubble                    $80421c41 	/* V18 */
#define MUIM_CreateShortHelp                 $80428e93 	/* V11 */
#define MUIM_DeleteBubble                    $804211af 	/* V18 */
#define MUIM_DeleteShortHelp                 $8042d35a 	/* V11 */
#define MUIM_DragBegin                       $8042c03a 	/* V11 */
#define MUIM_DragDrop                        $8042c555 	/* V11 */
#define MUIM_DragFinish                      $804251f0 	/* V11 */
#define MUIM_DragQuery                       $80420261 	/* V11 */
#define MUIM_DragReport                      $8042edad 	/* V11 */
#define MUIM_Draw                            $80426f3f 	/* Custom Class */
/* V4  */
#define MUIM_DrawBackground                  $804238ca 	/* V11 */
#define MUIM_HandleEvent                     $80426d66 	/* Custom Class */
/* V16 */
#define MUIM_HandleInput                     $80422a1a 	/* Custom Class */
/* V4  */
#define MUIM_Hide                            $8042f20f 	/* Custom Class */
/* V4  */
#define MUIM_Setup                           $80428354 	/* Custom Class */
/* V4  */
#define MUIM_Show                            $8042cc84 	/* Custom Class */
/* V4  */
OBJECT MUIP_AskMinMax
	MethodID:ULONG,
	MinMaxInfo:PTR TO MUI_MinMax
ENDOBJECT

/* Custom Class */
OBJECT MUIP_Cleanup
	MethodID:ULONG
ENDOBJECT

/* Custom Class */
OBJECT MUIP_ContextMenuBuild
	MethodID:ULONG,
	mx:LONG,
	my:LONG
ENDOBJECT

OBJECT MUIP_ContextMenuChoice
	MethodID:ULONG,
	item:PTR TO _Object
ENDOBJECT

OBJECT MUIP_CreateBubble
	MethodID:ULONG,
	x:LONG,
	y:LONG,
	txt:PTR TO UBYTE,
	flags:ULONG
ENDOBJECT

OBJECT MUIP_CreateShortHelp
	MethodID:ULONG,
	mx:LONG,
	my:LONG
ENDOBJECT

OBJECT MUIP_DeleteBubble
	MethodID:ULONG,
	bubble:LONG
ENDOBJECT

OBJECT MUIP_DeleteShortHelp
	MethodID:ULONG,
	help:PTR TO UBYTE
ENDOBJECT

OBJECT MUIP_DragBegin
	MethodID:ULONG,
	obj:PTR TO _Object
ENDOBJECT

OBJECT MUIP_DragDrop
	MethodID:ULONG,
	obj:PTR TO _Object,
	x:LONG,
	y:LONG
ENDOBJECT

OBJECT MUIP_DragFinish
	MethodID:ULONG,
	obj:PTR TO _Object
ENDOBJECT

OBJECT MUIP_DragQuery
	MethodID:ULONG,
	obj:PTR TO _Object
ENDOBJECT

OBJECT MUIP_DragReport
	MethodID:ULONG,
	obj:PTR TO _Object,
	x:LONG,
	y:LONG,
	update:LONG
ENDOBJECT

OBJECT MUIP_Draw
	MethodID:ULONG,
	flags:ULONG
ENDOBJECT

/* Custom Class */
OBJECT MUIP_DrawBackground
	MethodID:ULONG,
	left:LONG,
	top:LONG,
	width:LONG,
	height:LONG,
	xoffset:LONG,
	yoffset:LONG,
	flags:LONG
ENDOBJECT

OBJECT MUIP_HandleEvent
	MethodID:ULONG,
	imsg:PTR TO IntuiMessage,
	muikey:LONG
ENDOBJECT

/* Custom Class */
OBJECT MUIP_HandleInput
	MethodID:ULONG,
	imsg:PTR TO IntuiMessage,
	muikey:LONG
ENDOBJECT

/* Custom Class */
OBJECT MUIP_Hide
	MethodID:ULONG
ENDOBJECT

/* Custom Class */
OBJECT MUIP_Setup
	MethodID:ULONG,
	RenderInfo:PTR TO MUI_RenderInfo
ENDOBJECT

/* Custom Class */
OBJECT MUIP_Show
	MethodID:ULONG
ENDOBJECT

/* Custom Class */
/* Attributes */
#define MUIA_Background                      $8042545b 	/* V4  is. LONG              */
#define MUIA_BottomEdge                      $8042e552 	/* V4  ..g LONG              */
#define MUIA_ContextMenu                     $8042b704 	/* V11 isg Object *          */
#define MUIA_ContextMenuTrigger              $8042a2c1 	/* V11 ..g Object *          */
#define MUIA_ControlChar                     $8042120b 	/* V4  isg char              */
#define MUIA_CycleChain                      $80421ce7 	/* V11 isg LONG              */
#define MUIA_Disabled                        $80423661 	/* V4  isg BOOL              */
#define MUIA_Draggable                       $80420b6e 	/* V11 isg BOOL              */
#define MUIA_Dropable                        $8042fbce 	/* V11 isg BOOL              */
#ifdef MUI_OBSOLETE
#define MUIA_ExportID                        $8042d76e 	/* V4  isg ULONG             */
#endif
/* MUI_OBSOLETE */
#define MUIA_FillArea                        $804294a3 	/* V4  is. BOOL              */
#define MUIA_FixHeight                       $8042a92b 	/* V4  i.. LONG              */
#define MUIA_FixHeightTxt                    $804276f2 	/* V4  i.. STRPTR            */
#define MUIA_FixWidth                        $8042a3f1 	/* V4  i.. LONG              */
#define MUIA_FixWidthTxt                     $8042d044 	/* V4  i.. STRPTR            */
#define MUIA_Font                            $8042be50 	/* V4  i.g struct TextFont * */
#define MUIA_Frame                           $8042ac64 	/* V4  i.. LONG              */
#define MUIA_FramePhantomHoriz               $8042ed76 	/* V4  i.. BOOL              */
#define MUIA_FrameTitle                      $8042d1c7 	/* V4  i.. STRPTR            */
#define MUIA_Height                          $80423237 	/* V4  ..g LONG              */
#define MUIA_HorizDisappear                  $80429615 	/* V11 isg LONG              */
#define MUIA_HorizWeight                     $80426db9 	/* V4  isg WORD              */
#define MUIA_InnerBottom                     $8042f2c0 	/* V4  i.g LONG              */
#define MUIA_InnerLeft                       $804228f8 	/* V4  i.g LONG              */
#define MUIA_InnerRight                      $804297ff 	/* V4  i.g LONG              */
#define MUIA_InnerTop                        $80421eb6 	/* V4  i.g LONG              */
#define MUIA_InputMode                       $8042fb04 	/* V4  i.. LONG              */
#define MUIA_LeftEdge                        $8042bec6 	/* V4  ..g LONG              */
#define MUIA_MaxHeight                       $804293e4 	/* V11 i.. LONG              */
#define MUIA_MaxWidth                        $8042f112 	/* V11 i.. LONG              */
#define MUIA_Pressed                         $80423535 	/* V4  ..g BOOL              */
#define MUIA_RightEdge                       $8042ba82 	/* V4  ..g LONG              */
#define MUIA_Selected                        $8042654b 	/* V4  isg BOOL              */
#define MUIA_ShortHelp                       $80428fe3 	/* V11 isg STRPTR            */
#define MUIA_ShowMe                          $80429ba8 	/* V4  isg BOOL              */
#define MUIA_ShowSelState                    $8042caac 	/* V4  i.. BOOL              */
#define MUIA_Timer                           $80426435 	/* V4  ..g LONG              */
#define MUIA_TopEdge                         $8042509b 	/* V4  ..g LONG              */
#define MUIA_VertDisappear                   $8042d12f 	/* V11 isg LONG              */
#define MUIA_VertWeight                      $804298d0 	/* V4  isg WORD              */
#define MUIA_Weight                          $80421d1f 	/* V4  i.. WORD              */
#define MUIA_Width                           $8042b59c 	/* V4  ..g LONG              */
#define MUIA_Window                          $80421591 	/* V4  ..g struct Window *   */
#define MUIA_WindowObject                    $8042669e 	/* V4  ..g Object *          */
CONST	MUIV_Font_Inherit=0,
		MUIV_Font_Normal=-1,
		MUIV_Font_List=-2,
		MUIV_Font_Tiny=-3,
		MUIV_Font_Fixed=-4,
		MUIV_Font_Title=-5,
		MUIV_Font_Big=-6,
		MUIV_Font_Button=-7,
		MUIV_Frame_None=0,
		MUIV_Frame_Button=1,
		MUIV_Frame_ImageButton=2,
		MUIV_Frame_Text=3,
		MUIV_Frame_String=4,
		MUIV_Frame_ReadList=5,
		MUIV_Frame_InputList=6,
		MUIV_Frame_Prop=7,
		MUIV_Frame_Gauge=8,
		MUIV_Frame_Group=9,
		MUIV_Frame_PopUp=10,
		MUIV_Frame_Virtual=11,
		MUIV_Frame_Slider=12,
		MUIV_Frame_Count=13,
		MUIV_InputMode_None=0,
		MUIV_InputMode_RelVerify=1,
		MUIV_InputMode_Immediate=2,
		MUIV_InputMode_Toggle=3
/** Rectangle                                                              **/
/****************************************************************************/
#define MUIC_Rectangle  'Rectangle.mui'
/* Attributes */
#define MUIA_Rectangle_BarTitle              $80426689 	/* V11 i.g STRPTR            */
#define MUIA_Rectangle_HBar                  $8042c943 	/* V7  i.g BOOL              */
#define MUIA_Rectangle_VBar                  $80422204 	/* V7  i.g BOOL              */
/****************************************************************************/
/** Balance                                                                **/
/****************************************************************************/
#define MUIC_Balance  'Balance.mui'
/****************************************************************************/
/** Image                                                                  **/
/****************************************************************************/
#define MUIC_Image  'Image.mui'
/* Attributes */
#define MUIA_Image_FontMatch                 $8042815d 	/* V4  i.. BOOL              */
#define MUIA_Image_FontMatchHeight           $80429f26 	/* V4  i.. BOOL              */
#define MUIA_Image_FontMatchWidth            $804239bf 	/* V4  i.. BOOL              */
#define MUIA_Image_FreeHoriz                 $8042da84 	/* V4  i.. BOOL              */
#define MUIA_Image_FreeVert                  $8042ea28 	/* V4  i.. BOOL              */
#define MUIA_Image_OldImage                  $80424f3d 	/* V4  i.. struct Image *    */
#define MUIA_Image_Spec                      $804233d5 	/* V4  i.. char *            */
#define MUIA_Image_State                     $8042a3ad 	/* V4  is. LONG              */
/****************************************************************************/
/** Bitmap                                                                 **/
/****************************************************************************/
#define MUIC_Bitmap  'Bitmap.mui'
/* Attributes */
#define MUIA_Bitmap_Bitmap                   $804279bd 	/* V8  isg struct BitMap *   */
#define MUIA_Bitmap_Height                   $80421560 	/* V8  isg LONG              */
#define MUIA_Bitmap_MappingTable             $8042e23d 	/* V8  isg UBYTE *           */
#define MUIA_Bitmap_Precision                $80420c74 	/* V11 isg LONG              */
#define MUIA_Bitmap_RemappedBitmap           $80423a47 	/* V11 ..g struct BitMap *   */
#define MUIA_Bitmap_SourceColors             $80425360 	/* V8  isg ULONG *           */
#define MUIA_Bitmap_Transparent              $80422805 	/* V8  isg LONG              */
#define MUIA_Bitmap_UseFriend                $804239d8 	/* V11 i.. BOOL              */
#define MUIA_Bitmap_Width                    $8042eb3a 	/* V8  isg LONG              */
/****************************************************************************/
/** Bodychunk                                                              **/
/****************************************************************************/
#define MUIC_Bodychunk  'Bodychunk.mui'
/* Attributes */
#define MUIA_Bodychunk_Body                  $8042ca67 	/* V8  isg UBYTE *           */
#define MUIA_Bodychunk_Compression           $8042de5f 	/* V8  isg UBYTE             */
#define MUIA_Bodychunk_Depth                 $8042c392 	/* V8  isg LONG              */
#define MUIA_Bodychunk_Masking               $80423b0e 	/* V8  isg UBYTE             */
/****************************************************************************/
/** Text                                                                   **/
/****************************************************************************/
#define MUIC_Text  'Text.mui'
/* Attributes */
#define MUIA_Text_Contents                   $8042f8dc 	/* V4  isg STRPTR            */
#define MUIA_Text_HiChar                     $804218ff 	/* V4  i.. char              */
#define MUIA_Text_PreParse                   $8042566d 	/* V4  isg STRPTR            */
#define MUIA_Text_SetMax                     $80424d0a 	/* V4  i.. BOOL              */
#define MUIA_Text_SetMin                     $80424e10 	/* V4  i.. BOOL              */
#define MUIA_Text_SetVMax                    $80420d8b 	/* V11 i.. BOOL              */
/****************************************************************************/
/** Gadget                                                                 **/
/****************************************************************************/
#define MUIC_Gadget  'Gadget.mui'
/* Attributes */
#define MUIA_Gadget_Gadget                   $8042ec1a 	/* V11 ..g struct Gadget *   */
/****************************************************************************/
/** String                                                                 **/
/****************************************************************************/
#define MUIC_String  'String.mui'
/* Methods */
/* Attributes */
#define MUIA_String_Accept                   $8042e3e1 	/* V4  isg STRPTR            */
#define MUIA_String_Acknowledge              $8042026c 	/* V4  ..g STRPTR            */
#define MUIA_String_AdvanceOnCR              $804226de 	/* V11 isg BOOL              */
#define MUIA_String_AttachedList             $80420fd2 	/* V4  isg Object *          */
#define MUIA_String_BufferPos                $80428b6c 	/* V4  .sg LONG              */
#define MUIA_String_Contents                 $80428ffd 	/* V4  isg STRPTR            */
#define MUIA_String_DisplayPos               $8042ccbf 	/* V4  .sg LONG              */
#define MUIA_String_EditHook                 $80424c33 	/* V7  isg struct Hook *     */
#define MUIA_String_Format                   $80427484 	/* V4  i.g LONG              */
#define MUIA_String_Integer                  $80426e8a 	/* V4  isg ULONG             */
#define MUIA_String_LonelyEditHook           $80421569 	/* V11 isg BOOL              */
#define MUIA_String_MaxLen                   $80424984 	/* V4  i.g LONG              */
#define MUIA_String_Reject                   $8042179c 	/* V4  isg STRPTR            */
#define MUIA_String_Secret                   $80428769 	/* V4  i.g BOOL              */
CONST	MUIV_String_Format_Left=0,
		MUIV_String_Format_Center=1,
		MUIV_String_Format_Right=2
/** Boopsi                                                                 **/
/****************************************************************************/
#define MUIC_Boopsi  'Boopsi.mui'
/* Attributes */
#define MUIA_Boopsi_Class                    $80426999 	/* V4  isg struct IClass *   */
#define MUIA_Boopsi_ClassID                  $8042bfa3 	/* V4  isg char *            */
#define MUIA_Boopsi_MaxHeight                $8042757f 	/* V4  isg ULONG             */
#define MUIA_Boopsi_MaxWidth                 $8042bcb1 	/* V4  isg ULONG             */
#define MUIA_Boopsi_MinHeight                $80422c93 	/* V4  isg ULONG             */
#define MUIA_Boopsi_MinWidth                 $80428fb2 	/* V4  isg ULONG             */
#define MUIA_Boopsi_Object                   $80420178 	/* V4  ..g Object *          */
#define MUIA_Boopsi_Remember                 $8042f4bd 	/* V4  i.. ULONG             */
#define MUIA_Boopsi_Smart                    $8042b8d7 	/* V9  i.. BOOL              */
#define MUIA_Boopsi_TagDrawInfo              $8042bae7 	/* V4  isg ULONG             */
#define MUIA_Boopsi_TagScreen                $8042bc71 	/* V4  isg ULONG             */
#define MUIA_Boopsi_TagWindow                $8042e11d 	/* V4  isg ULONG             */
/****************************************************************************/
/** Prop                                                                   **/
/****************************************************************************/
#define MUIC_Prop  'Prop.mui'
/* Methods */
#define MUIM_Prop_Decrease                   $80420dd1 	/* V16 */
#define MUIM_Prop_Increase                   $8042cac0 	/* V16 */
OBJECT MUIP_Prop_Decrease
	MethodID:ULONG,
	amount:LONG
ENDOBJECT

OBJECT MUIP_Prop_Increase
	MethodID:ULONG,
	amount:LONG
ENDOBJECT

/* Attributes */
#define MUIA_Prop_Entries                    $8042fbdb 	/* V4  isg LONG              */
#define MUIA_Prop_First                      $8042d4b2 	/* V4  isg LONG              */
#define MUIA_Prop_Horiz                      $8042f4f3 	/* V4  i.g BOOL              */
#define MUIA_Prop_Slider                     $80429c3a 	/* V4  isg BOOL              */
#define MUIA_Prop_UseWinBorder               $8042deee 	/* V13 i.. LONG              */
#define MUIA_Prop_Visible                    $8042fea6 	/* V4  isg LONG              */
CONST	MUIV_Prop_UseWinBorder_None=0,
		MUIV_Prop_UseWinBorder_Left=1,
		MUIV_Prop_UseWinBorder_Right=2,
		MUIV_Prop_UseWinBorder_Bottom=3
/** Gauge                                                                  **/
/****************************************************************************/
#define MUIC_Gauge  'Gauge.mui'
/* Attributes */
#define MUIA_Gauge_Current                   $8042f0dd 	/* V4  isg LONG              */
#define MUIA_Gauge_Divide                    $8042d8df 	/* V4  isg BOOL              */
#define MUIA_Gauge_Horiz                     $804232dd 	/* V4  i.. BOOL              */
#define MUIA_Gauge_InfoText                  $8042bf15 	/* V7  isg STRPTR            */
#define MUIA_Gauge_Max                       $8042bcdb 	/* V4  isg LONG              */
/****************************************************************************/
/** Scale                                                                  **/
/****************************************************************************/
#define MUIC_Scale  'Scale.mui'
/* Attributes */
#define MUIA_Scale_Horiz                     $8042919a 	/* V4  isg BOOL              */
/****************************************************************************/
/** Colorfield                                                             **/
/****************************************************************************/
#define MUIC_Colorfield  'Colorfield.mui'
/* Attributes */
#define MUIA_Colorfield_Blue                 $8042d3b0 	/* V4  isg ULONG             */
#define MUIA_Colorfield_Green                $80424466 	/* V4  isg ULONG             */
#define MUIA_Colorfield_Pen                  $8042713a 	/* V4  ..g ULONG             */
#define MUIA_Colorfield_Red                  $804279f6 	/* V4  isg ULONG             */
#define MUIA_Colorfield_RGB                  $8042677a 	/* V4  isg ULONG *           */
/****************************************************************************/
/** List                                                                   **/
/****************************************************************************/
#define MUIC_List  'List.mui'
/* Methods */
#define MUIM_List_Clear                      $8042ad89 	/* V4  */
#define MUIM_List_CreateImage                $80429804 	/* V11 */
#define MUIM_List_DeleteImage                $80420f58 	/* V11 */
#define MUIM_List_Exchange                   $8042468c 	/* V4  */
#define MUIM_List_GetEntry                   $804280ec 	/* V4  */
#define MUIM_List_Insert                     $80426c87 	/* V4  */
#define MUIM_List_InsertSingle               $804254d5 	/* V7  */
#define MUIM_List_Jump                       $8042baab 	/* V4  */
#define MUIM_List_Move                       $804253c2 	/* V9  */
#define MUIM_List_NextSelected               $80425f17 	/* V6  */
#define MUIM_List_Redraw                     $80427993 	/* V4  */
#define MUIM_List_Remove                     $8042647e 	/* V4  */
#define MUIM_List_Select                     $804252d8 	/* V4  */
#define MUIM_List_Sort                       $80422275 	/* V4  */
#define MUIM_List_TestPos                    $80425f48 	/* V11 */
OBJECT MUIP_List_Clear
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_List_CreateImage
	MethodID:ULONG,
	obj:PTR TO _Object,
	flags:ULONG
ENDOBJECT

OBJECT MUIP_List_DeleteImage
	MethodID:ULONG,
	listimg:LONG
ENDOBJECT

OBJECT MUIP_List_Exchange
	MethodID:ULONG,
	pos1:LONG,
	pos2:LONG
ENDOBJECT

OBJECT MUIP_List_GetEntry
	MethodID:ULONG,
	pos:LONG,
	entry:PTR TO LONG
ENDOBJECT

OBJECT MUIP_List_Insert
	MethodID:ULONG,
	entries:PTR TO LONG,
	count:LONG,
	pos:LONG
ENDOBJECT

OBJECT MUIP_List_InsertSingle
	MethodID:ULONG,
	entry:LONG,
	pos:LONG
ENDOBJECT

OBJECT MUIP_List_Jump
	MethodID:ULONG,
	pos:LONG
ENDOBJECT

OBJECT MUIP_List_Move
	MethodID:ULONG,
	from:LONG,
	to:LONG
ENDOBJECT

OBJECT MUIP_List_NextSelected
	MethodID:ULONG,
	pos:PTR TO LONG
ENDOBJECT

OBJECT MUIP_List_Redraw
	MethodID:ULONG,
	pos:LONG
ENDOBJECT

OBJECT MUIP_List_Remove
	MethodID:ULONG,
	pos:LONG
ENDOBJECT

OBJECT MUIP_List_Select
	MethodID:ULONG,
	pos:LONG,
	seltype:LONG,
	state:PTR TO LONG
ENDOBJECT

OBJECT MUIP_List_Sort
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_List_TestPos
	MethodID:ULONG,
	x:LONG,
	y:LONG,
	res:PTR TO MUI_List_TestPos_Result
ENDOBJECT

/* Attributes */
#define MUIA_List_Active                     $8042391c 	/* V4  isg LONG              */
#define MUIA_List_AdjustHeight               $8042850d 	/* V4  i.. BOOL              */
#define MUIA_List_AdjustWidth                $8042354a 	/* V4  i.. BOOL              */
#define MUIA_List_AutoVisible                $8042a445 	/* V11 isg BOOL              */
#define MUIA_List_CompareHook                $80425c14 	/* V4  is. struct Hook *     */
#define MUIA_List_ConstructHook              $8042894f 	/* V4  is. struct Hook *     */
#define MUIA_List_DestructHook               $804297ce 	/* V4  is. struct Hook *     */
#define MUIA_List_DisplayHook                $8042b4d5 	/* V4  is. struct Hook *     */
#define MUIA_List_DragSortable               $80426099 	/* V11 isg BOOL              */
#define MUIA_List_DropMark                   $8042aba6 	/* V11 ..g LONG              */
#define MUIA_List_Entries                    $80421654 	/* V4  ..g LONG              */
#define MUIA_List_First                      $804238d4 	/* V4  ..g LONG              */
#define MUIA_List_Format                     $80423c0a 	/* V4  isg STRPTR            */
#define MUIA_List_InsertPosition             $8042d0cd 	/* V9  ..g LONG              */
#define MUIA_List_MinLineHeight              $8042d1c3 	/* V4  i.. LONG              */
#define MUIA_List_MultiTestHook              $8042c2c6 	/* V4  is. struct Hook *     */
#define MUIA_List_Pool                       $80423431 	/* V13 i.. APTR              */
#define MUIA_List_PoolPuddleSize             $8042a4eb 	/* V13 i.. ULONG             */
#define MUIA_List_PoolThreshSize             $8042c48c 	/* V13 i.. ULONG             */
#define MUIA_List_Quiet                      $8042d8c7 	/* V4  .s. BOOL              */
#define MUIA_List_ShowDropMarks              $8042c6f3 	/* V11 isg BOOL              */
#define MUIA_List_SourceArray                $8042c0a0 	/* V4  i.. APTR              */
#define MUIA_List_Title                      $80423e66 	/* V6  isg char *            */
#define MUIA_List_Visible                    $8042191f 	/* V4  ..g LONG              */
CONST	MUIV_List_Active_Off=-1,
		MUIV_List_Active_Top=-2,
		MUIV_List_Active_Bottom=-3,
		MUIV_List_Active_Up=-4,
		MUIV_List_Active_Down=-5,
		MUIV_List_Active_PageUp=-6,
		MUIV_List_Active_PageDown=-7,
		MUIV_List_ConstructHook_String=-1,
		MUIV_List_CopyHook_String=-1,
		MUIV_List_CursorType_None=0,
		MUIV_List_CursorType_Bar=1,
		MUIV_List_CursorType_Rect=2,
		MUIV_List_DestructHook_String=-1
/** Floattext                                                              **/
/****************************************************************************/
#define MUIC_Floattext  'Floattext.mui'
/* Attributes */
#define MUIA_Floattext_Justify               $8042dc03 	/* V4  isg BOOL              */
#define MUIA_Floattext_SkipChars             $80425c7d 	/* V4  is. STRPTR            */
#define MUIA_Floattext_TabSize               $80427d17 	/* V4  is. LONG              */
#define MUIA_Floattext_Text                  $8042d16a 	/* V4  isg STRPTR            */
/****************************************************************************/
/** Volumelist                                                             **/
/****************************************************************************/
#define MUIC_Volumelist  'Volumelist.mui'
/****************************************************************************/
/** Scrmodelist                                                            **/
/****************************************************************************/
#define MUIC_Scrmodelist  'Scrmodelist.mui'
/* Attributes */
/****************************************************************************/
/** Dirlist                                                                **/
/****************************************************************************/
#define MUIC_Dirlist  'Dirlist.mui'
/* Methods */
#define MUIM_Dirlist_ReRead                  $80422d71 	/* V4  */
OBJECT MUIP_Dirlist_ReRead
	MethodID:ULONG
ENDOBJECT

/* Attributes */
#define MUIA_Dirlist_AcceptPattern           $8042760a 	/* V4  is. STRPTR            */
#define MUIA_Dirlist_Directory               $8042ea41 	/* V4  isg STRPTR            */
#define MUIA_Dirlist_DrawersOnly             $8042b379 	/* V4  is. BOOL              */
#define MUIA_Dirlist_FilesOnly               $8042896a 	/* V4  is. BOOL              */
#define MUIA_Dirlist_FilterDrawers           $80424ad2 	/* V4  is. BOOL              */
#define MUIA_Dirlist_FilterHook              $8042ae19 	/* V4  is. struct Hook *     */
#define MUIA_Dirlist_MultiSelDirs            $80428653 	/* V6  is. BOOL              */
#define MUIA_Dirlist_NumBytes                $80429e26 	/* V4  ..g LONG              */
#define MUIA_Dirlist_NumDrawers              $80429cb8 	/* V4  ..g LONG              */
#define MUIA_Dirlist_NumFiles                $8042a6f0 	/* V4  ..g LONG              */
#define MUIA_Dirlist_Path                    $80426176 	/* V4  ..g STRPTR            */
#define MUIA_Dirlist_RejectIcons             $80424808 	/* V4  is. BOOL              */
#define MUIA_Dirlist_RejectPattern           $804259c7 	/* V4  is. STRPTR            */
#define MUIA_Dirlist_SortDirs                $8042bbb9 	/* V4  is. LONG              */
#define MUIA_Dirlist_SortHighLow             $80421896 	/* V4  is. BOOL              */
#define MUIA_Dirlist_SortType                $804228bc 	/* V4  is. LONG              */
#define MUIA_Dirlist_Status                  $804240de 	/* V4  ..g LONG              */
CONST	MUIV_Dirlist_SortDirs_First=0,
		MUIV_Dirlist_SortDirs_Last=1,
		MUIV_Dirlist_SortDirs_Mix=2,
		MUIV_Dirlist_SortType_Name=0,
		MUIV_Dirlist_SortType_Date=1,
		MUIV_Dirlist_SortType_Size=2,
		MUIV_Dirlist_Status_Invalid=0,
		MUIV_Dirlist_Status_Reading=1,
		MUIV_Dirlist_Status_Valid=2
/** Numeric                                                                **/
/****************************************************************************/
#define MUIC_Numeric  'Numeric.mui'
/* Methods */
#define MUIM_Numeric_Decrease                $804243a7 	/* V11 */
#define MUIM_Numeric_Increase                $80426ecd 	/* V11 */
#define MUIM_Numeric_ScaleToValue            $8042032c 	/* V11 */
#define MUIM_Numeric_SetDefault              $8042ab0a 	/* V11 */
#define MUIM_Numeric_Stringify               $80424891 	/* V11 */
#define MUIM_Numeric_ValueToScale            $80423e4f 	/* V11 */
OBJECT MUIP_Numeric_Decrease
	MethodID:ULONG,
	amount:LONG
ENDOBJECT

OBJECT MUIP_Numeric_Increase
	MethodID:ULONG,
	amount:LONG
ENDOBJECT

OBJECT MUIP_Numeric_ScaleToValue
	MethodID:ULONG,
	scalemin:LONG,
	scalemax:LONG,
	scale:LONG
ENDOBJECT

OBJECT MUIP_Numeric_SetDefault
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Numeric_Stringify
	MethodID:ULONG,
	value:LONG
ENDOBJECT

OBJECT MUIP_Numeric_ValueToScale
	MethodID:ULONG,
	scalemin:LONG,
	scalemax:LONG
ENDOBJECT

/* Attributes */
#define MUIA_Numeric_CheckAllSizes           $80421594 	/* V11 isg BOOL              */
#define MUIA_Numeric_Default                 $804263e8 	/* V11 isg LONG              */
#define MUIA_Numeric_Format                  $804263e9 	/* V11 isg STRPTR            */
#define MUIA_Numeric_Max                     $8042d78a 	/* V11 isg LONG              */
#define MUIA_Numeric_Min                     $8042e404 	/* V11 isg LONG              */
#define MUIA_Numeric_Reverse                 $8042f2a0 	/* V11 isg BOOL              */
#define MUIA_Numeric_RevLeftRight            $804294a7 	/* V11 isg BOOL              */
#define MUIA_Numeric_RevUpDown               $804252dd 	/* V11 isg BOOL              */
#define MUIA_Numeric_Value                   $8042ae3a 	/* V11 isg LONG              */
/****************************************************************************/
/** Knob                                                                   **/
/****************************************************************************/
#define MUIC_Knob  'Knob.mui'
/****************************************************************************/
/** Levelmeter                                                             **/
/****************************************************************************/
#define MUIC_Levelmeter  'Levelmeter.mui'
/* Attributes */
#define MUIA_Levelmeter_Label                $80420dd5 	/* V11 isg STRPTR            */
/****************************************************************************/
/** Numericbutton                                                          **/
/****************************************************************************/
#define MUIC_Numericbutton  'Numericbutton.mui'
/****************************************************************************/
/** Slider                                                                 **/
/****************************************************************************/
#define MUIC_Slider  'Slider.mui'
/* Attributes */
#define MUIA_Slider_Horiz                    $8042fad1 	/* V11 isg BOOL              */
#ifdef MUI_OBSOLETE
#define MUIA_Slider_Level                    $8042ae3a 	/* V4  isg LONG              */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIA_Slider_Max                      $8042d78a 	/* V4  isg LONG              */
#endif
/* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
#define MUIA_Slider_Min                      $8042e404 	/* V4  isg LONG              */
#endif
/* MUI_OBSOLETE */
#define MUIA_Slider_Quiet                    $80420b26 	/* V6  i.. BOOL              */
#ifdef MUI_OBSOLETE
#define MUIA_Slider_Reverse                  $8042f2a0 	/* V4  isg BOOL              */
#endif
/* MUI_OBSOLETE */
/****************************************************************************/
/** Framedisplay                                                           **/
/****************************************************************************/
#define MUIC_Framedisplay  'Framedisplay.mui'
/* Attributes */
/****************************************************************************/
/** Popframe                                                               **/
/****************************************************************************/
#define MUIC_Popframe  'Popframe.mui'
/****************************************************************************/
/** Imagedisplay                                                           **/
/****************************************************************************/
#define MUIC_Imagedisplay  'Imagedisplay.mui'
/* Attributes */
/****************************************************************************/
/** Popimage                                                               **/
/****************************************************************************/
#define MUIC_Popimage  'Popimage.mui'
/****************************************************************************/
/** Pendisplay                                                             **/
/****************************************************************************/
#define MUIC_Pendisplay  'Pendisplay.mui'
/* Methods */
#define MUIM_Pendisplay_SetColormap          $80426c80 	/* V13 */
#define MUIM_Pendisplay_SetMUIPen            $8042039d 	/* V13 */
#define MUIM_Pendisplay_SetRGB               $8042c131 	/* V13 */
OBJECT MUIP_Pendisplay_SetColormap
	MethodID:ULONG,
	colormap:LONG
ENDOBJECT

OBJECT MUIP_Pendisplay_SetMUIPen
	MethodID:ULONG,
	muipen:LONG
ENDOBJECT

OBJECT MUIP_Pendisplay_SetRGB
	MethodID:ULONG,
	red:ULONG,
	green:ULONG,
	blue:ULONG
ENDOBJECT

/* Attributes */
#define MUIA_Pendisplay_Pen                  $8042a748 	/* V13 ..g Object *          */
#define MUIA_Pendisplay_Reference            $8042dc24 	/* V13 isg Object *          */
#define MUIA_Pendisplay_RGBcolor             $8042a1a9 	/* V11 isg struct MUI_RGBcolor * */
#define MUIA_Pendisplay_Spec                 $8042a204 	/* V11 isg struct MUI_PenSpec  * */
/****************************************************************************/
/** Poppen                                                                 **/
/****************************************************************************/
#define MUIC_Poppen  'Poppen.mui'
/****************************************************************************/
/** Group                                                                  **/
/****************************************************************************/
#define MUIC_Group  'Group.mui'
/* Methods */
#define MUIM_Group_ExitChange                $8042d1cc 	/* V11 */
#define MUIM_Group_InitChange                $80420887 	/* V11 */
#define MUIM_Group_Sort                      $80427417 	/* V4  */
OBJECT MUIP_Group_ExitChange
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Group_InitChange
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Group_Sort
	MethodID:ULONG,
	obj[1]:PTR TO _Object
ENDOBJECT

/* Attributes */
#define MUIA_Group_ActivePage                $80424199 	/* V5  isg LONG              */
#define MUIA_Group_Child                     $804226e6 	/* V4  i.. Object *          */
#define MUIA_Group_ChildList                 $80424748 	/* V4  ..g struct List *     */
#define MUIA_Group_Columns                   $8042f416 	/* V4  is. LONG              */
#define MUIA_Group_Horiz                     $8042536b 	/* V4  i.. BOOL              */
#define MUIA_Group_HorizSpacing              $8042c651 	/* V4  isg LONG              */
#define MUIA_Group_LayoutHook                $8042c3b2 	/* V11 i.. struct Hook *     */
#define MUIA_Group_PageMode                  $80421a5f 	/* V5  i.. BOOL              */
#define MUIA_Group_Rows                      $8042b68f 	/* V4  is. LONG              */
#define MUIA_Group_SameHeight                $8042037e 	/* V4  i.. BOOL              */
#define MUIA_Group_SameSize                  $80420860 	/* V4  i.. BOOL              */
#define MUIA_Group_SameWidth                 $8042b3ec 	/* V4  i.. BOOL              */
#define MUIA_Group_Spacing                   $8042866d 	/* V4  is. LONG              */
#define MUIA_Group_VertSpacing               $8042e1bf 	/* V4  isg LONG              */
CONST	MUIV_Group_ActivePage_First=0,
		MUIV_Group_ActivePage_Last=-1,
		MUIV_Group_ActivePage_Prev=-2,
		MUIV_Group_ActivePage_Next=-3,
		MUIV_Group_ActivePage_Advance=-4
/** Mccprefs                                                               **/
/****************************************************************************/
#define MUIC_Mccprefs  'Mccprefs.mui'
/****************************************************************************/
/** Register                                                               **/
/****************************************************************************/
#define MUIC_Register  'Register.mui'
/* Attributes */
#define MUIA_Register_Frame                  $8042349b 	/* V7  i.g BOOL              */
#define MUIA_Register_Titles                 $804297ec 	/* V7  i.g STRPTR *          */
/****************************************************************************/
/** Penadjust                                                              **/
/****************************************************************************/
#define MUIC_Penadjust  'Penadjust.mui'
/* Methods */
/* Attributes */
#define MUIA_Penadjust_PSIMode               $80421cbb 	/* V11 i.. BOOL              */
/****************************************************************************/
/** Settingsgroup                                                          **/
/****************************************************************************/
#define MUIC_Settingsgroup  'Settingsgroup.mui'
/* Methods */
#define MUIM_Settingsgroup_ConfigToGadgets   $80427043 	/* V11 */
#define MUIM_Settingsgroup_GadgetsToConfig   $80425242 	/* V11 */
OBJECT MUIP_Settingsgroup_ConfigToGadgets
	MethodID:ULONG,
	configdata:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Settingsgroup_GadgetsToConfig
	MethodID:ULONG,
	configdata:PTR TO _Object
ENDOBJECT

/* Attributes */
/****************************************************************************/
/** Settings                                                               **/
/****************************************************************************/
#define MUIC_Settings  'Settings.mui'
/* Methods */
/* Attributes */
/****************************************************************************/
/** Frameadjust                                                            **/
/****************************************************************************/
#define MUIC_Frameadjust  'Frameadjust.mui'
/* Methods */
/* Attributes */
/****************************************************************************/
/** Imageadjust                                                            **/
/****************************************************************************/
#define MUIC_Imageadjust  'Imageadjust.mui'
/* Methods */
/* Attributes */
CONST	MUIV_Imageadjust_Type_All=0,
		MUIV_Imageadjust_Type_Image=1,
		MUIV_Imageadjust_Type_Background=2,
		MUIV_Imageadjust_Type_Pen=3
/** Virtgroup                                                              **/
/****************************************************************************/
#define MUIC_Virtgroup  'Virtgroup.mui'
/* Methods */
/* Attributes */
#define MUIA_Virtgroup_Height                $80423038 	/* V6  ..g LONG              */
#define MUIA_Virtgroup_Input                 $80427f7e 	/* V11 i.. BOOL              */
#define MUIA_Virtgroup_Left                  $80429371 	/* V6  isg LONG              */
#define MUIA_Virtgroup_Top                   $80425200 	/* V6  isg LONG              */
#define MUIA_Virtgroup_Width                 $80427c49 	/* V6  ..g LONG              */
/****************************************************************************/
/** Scrollgroup                                                            **/
/****************************************************************************/
#define MUIC_Scrollgroup  'Scrollgroup.mui'
/* Methods */
/* Attributes */
#define MUIA_Scrollgroup_Contents            $80421261 	/* V4  i.g Object *          */
#define MUIA_Scrollgroup_FreeHoriz           $804292f3 	/* V9  i.. BOOL              */
#define MUIA_Scrollgroup_FreeVert            $804224f2 	/* V9  i.. BOOL              */
#define MUIA_Scrollgroup_HorizBar            $8042b63d 	/* V16 ..g Object *          */
#define MUIA_Scrollgroup_UseWinBorder        $804284c1 	/* V13 i.. BOOL              */
#define MUIA_Scrollgroup_VertBar             $8042cdc0 	/* V16 ..g Object *          */
/****************************************************************************/
/** Scrollbar                                                              **/
/****************************************************************************/
#define MUIC_Scrollbar  'Scrollbar.mui'
/* Attributes */
#define MUIA_Scrollbar_Type                  $8042fb6b 	/* V11 i.. LONG              */
CONST	MUIV_Scrollbar_Type_Default=0,
		MUIV_Scrollbar_Type_Bottom=1,
		MUIV_Scrollbar_Type_Top=2,
		MUIV_Scrollbar_Type_Sym=3
/** Listview                                                               **/
/****************************************************************************/
#define MUIC_Listview  'Listview.mui'
/* Attributes */
#define MUIA_Listview_ClickColumn            $8042d1b3 	/* V7  ..g LONG              */
#define MUIA_Listview_DefClickColumn         $8042b296 	/* V7  isg LONG              */
#define MUIA_Listview_DoubleClick            $80424635 	/* V4  i.g BOOL              */
#define MUIA_Listview_DragType               $80425cd3 	/* V11 isg LONG              */
#define MUIA_Listview_Input                  $8042682d 	/* V4  i.. BOOL              */
#define MUIA_Listview_List                   $8042bcce 	/* V4  i.g Object *          */
#define MUIA_Listview_MultiSelect            $80427e08 	/* V7  i.. LONG              */
#define MUIA_Listview_ScrollerPos            $8042b1b4 	/* V10 i.. BOOL              */
#define MUIA_Listview_SelectChange           $8042178f 	/* V4  ..g BOOL              */
CONST	MUIV_Listview_DragType_None=0,
		MUIV_Listview_DragType_Immediate=1,
		MUIV_Listview_MultiSelect_None=0,
		MUIV_Listview_MultiSelect_Default=1,
		MUIV_Listview_MultiSelect_Shifted=2,
		MUIV_Listview_MultiSelect_Always=3,
		MUIV_Listview_ScrollerPos_Default=0,
		MUIV_Listview_ScrollerPos_Left=1,
		MUIV_Listview_ScrollerPos_Right=2,
		MUIV_Listview_ScrollerPos_None=3
/** Radio                                                                  **/
/****************************************************************************/
#define MUIC_Radio  'Radio.mui'
/* Attributes */
#define MUIA_Radio_Active                    $80429b41 	/* V4  isg LONG              */
#define MUIA_Radio_Entries                   $8042b6a1 	/* V4  i.. STRPTR *          */
/****************************************************************************/
/** Cycle                                                                  **/
/****************************************************************************/
#define MUIC_Cycle  'Cycle.mui'
/* Attributes */
#define MUIA_Cycle_Active                    $80421788 	/* V4  isg LONG              */
#define MUIA_Cycle_Entries                   $80420629 	/* V4  i.. STRPTR *          */
CONST	MUIV_Cycle_Active_Next=-1,
		MUIV_Cycle_Active_Prev=-2
/** Coloradjust                                                            **/
/****************************************************************************/
#define MUIC_Coloradjust  'Coloradjust.mui'
/* Methods */
/* Attributes */
#define MUIA_Coloradjust_Blue                $8042b8a3 	/* V4  isg ULONG             */
#define MUIA_Coloradjust_Green               $804285ab 	/* V4  isg ULONG             */
#define MUIA_Coloradjust_ModeID              $8042ec59 	/* V4  isg ULONG             */
#define MUIA_Coloradjust_Red                 $80420eaa 	/* V4  isg ULONG             */
#define MUIA_Coloradjust_RGB                 $8042f899 	/* V4  isg ULONG *           */
/****************************************************************************/
/** Palette                                                                **/
/****************************************************************************/
#define MUIC_Palette  'Palette.mui'
/* Attributes */
#define MUIA_Palette_Entries                 $8042a3d8 	/* V6  i.g struct MUI_Palette_Entry * */
#define MUIA_Palette_Groupable               $80423e67 	/* V6  isg BOOL              */
#define MUIA_Palette_Names                   $8042c3a2 	/* V6  isg char **           */
/****************************************************************************/
/** Popstring                                                              **/
/****************************************************************************/
#define MUIC_Popstring  'Popstring.mui'
/* Methods */
#define MUIM_Popstring_Close                 $8042dc52 	/* V7  */
#define MUIM_Popstring_Open                  $804258ba 	/* V7  */
OBJECT MUIP_Popstring_Close
	MethodID:ULONG,
	result:LONG
ENDOBJECT

OBJECT MUIP_Popstring_Open
	MethodID:ULONG
ENDOBJECT

/* Attributes */
#define MUIA_Popstring_Button                $8042d0b9 	/* V7  i.g Object *          */
#define MUIA_Popstring_CloseHook             $804256bf 	/* V7  isg struct Hook *     */
#define MUIA_Popstring_OpenHook              $80429d00 	/* V7  isg struct Hook *     */
#define MUIA_Popstring_String                $804239ea 	/* V7  i.g Object *          */
#define MUIA_Popstring_Toggle                $80422b7a 	/* V7  isg BOOL              */
/****************************************************************************/
/** Popobject                                                              **/
/****************************************************************************/
#define MUIC_Popobject  'Popobject.mui'
/* Attributes */
#define MUIA_Popobject_Follow                $80424cb5 	/* V7  isg BOOL              */
#define MUIA_Popobject_Light                 $8042a5a3 	/* V7  isg BOOL              */
#define MUIA_Popobject_Object                $804293e3 	/* V7  i.g Object *          */
#define MUIA_Popobject_ObjStrHook            $8042db44 	/* V7  isg struct Hook *     */
#define MUIA_Popobject_StrObjHook            $8042fbe1 	/* V7  isg struct Hook *     */
#define MUIA_Popobject_Volatile              $804252ec 	/* V7  isg BOOL              */
#define MUIA_Popobject_WindowHook            $8042f194 	/* V9  isg struct Hook *     */
/****************************************************************************/
/** Poplist                                                                **/
/****************************************************************************/
#define MUIC_Poplist  'Poplist.mui'
/* Attributes */
#define MUIA_Poplist_Array                   $8042084c 	/* V8  i.. char **           */
/****************************************************************************/
/** Popscreen                                                              **/
/****************************************************************************/
#define MUIC_Popscreen  'Popscreen.mui'
/* Attributes */
/****************************************************************************/
/** Popasl                                                                 **/
/****************************************************************************/
#define MUIC_Popasl  'Popasl.mui'
/* Attributes */
#define MUIA_Popasl_Active                   $80421b37 	/* V7  ..g BOOL              */
#define MUIA_Popasl_StartHook                $8042b703 	/* V7  isg struct Hook *     */
#define MUIA_Popasl_StopHook                 $8042d8d2 	/* V7  isg struct Hook *     */
#define MUIA_Popasl_Type                     $8042df3d 	/* V7  i.g ULONG             */
/****************************************************************************/
/** Semaphore                                                              **/
/****************************************************************************/
#define MUIC_Semaphore  'Semaphore.mui'
/* Methods */
#define MUIM_Semaphore_Attempt               $80426ce2 	/* V11 */
#define MUIM_Semaphore_AttemptShared         $80422551 	/* V11 */
#define MUIM_Semaphore_Obtain                $804276f0 	/* V11 */
#define MUIM_Semaphore_ObtainShared          $8042ea02 	/* V11 */
#define MUIM_Semaphore_Release               $80421f2d 	/* V11 */
OBJECT MUIP_Semaphore_Attempt
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Semaphore_AttemptShared
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Semaphore_Obtain
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Semaphore_ObtainShared
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Semaphore_Release
	MethodID:ULONG
ENDOBJECT

/****************************************************************************/
/** Applist                                                                **/
/****************************************************************************/
#define MUIC_Applist  'Applist.mui'
/* Methods */
/****************************************************************************/
/** Cclist                                                                 **/
/****************************************************************************/
#define MUIC_Cclist  'Cclist.mui'
/* Methods */
/****************************************************************************/
/** Dataspace                                                              **/
/****************************************************************************/
#define MUIC_Dataspace  'Dataspace.mui'
/* Methods */
#define MUIM_Dataspace_Add                   $80423366 	/* V11 */
#define MUIM_Dataspace_Clear                 $8042b6c9 	/* V11 */
#define MUIM_Dataspace_Find                  $8042832c 	/* V11 */
#define MUIM_Dataspace_Merge                 $80423e2b 	/* V11 */
#define MUIM_Dataspace_ReadIFF               $80420dfb 	/* V11 */
#define MUIM_Dataspace_Remove                $8042dce1 	/* V11 */
#define MUIM_Dataspace_WriteIFF              $80425e8e 	/* V11 */
OBJECT MUIP_Dataspace_Add
	MethodID:ULONG,
	data:LONG,
	len:LONG,
	id:ULONG
ENDOBJECT

OBJECT MUIP_Dataspace_Clear
	MethodID:ULONG
ENDOBJECT

OBJECT MUIP_Dataspace_Find
	MethodID:ULONG,
	id:ULONG
ENDOBJECT

OBJECT MUIP_Dataspace_Merge
	MethodID:ULONG,
	dataspace:PTR TO _Object
ENDOBJECT

OBJECT MUIP_Dataspace_ReadIFF
	MethodID:ULONG,
	handle:PTR TO IFFHandle
ENDOBJECT

OBJECT MUIP_Dataspace_Remove
	MethodID:ULONG,
	id:ULONG
ENDOBJECT

OBJECT MUIP_Dataspace_WriteIFF
	MethodID:ULONG,
	handle:PTR TO IFFHandle,
	type:ULONG,
	id:ULONG
ENDOBJECT

/* Attributes */
#define MUIA_Dataspace_Pool                  $80424cf9 	/* V11 i.. APTR              */
/****************************************************************************/
/** Configdata                                                             **/
/****************************************************************************/
#define MUIC_Configdata  'Configdata.mui'
/* Methods */
/* Attributes */
/****************************************************************************/
/** Dtpic                                                                  **/
/****************************************************************************/
#define MUIC_Dtpic  'Dtpic.mui'
/* Attributes */
/*****************************************/
/* End of automatic header file creation */
/*****************************************/
/*************************************************************************
** Structures and Macros for creating custom classes.
*************************************************************************/
/*
** GENERAL NOTES:
**
** - Everything described in this header file is only valid within
**   MUI classes. You may never use any of these things out of
**   a class, e.g. in a traditional MUI application.
**
** - Except when otherwise stated, all structures are strictly read only.
*/
/* Global information for every object */
OBJECT MUI_GlobalInfo
	priv0:ULONG,
	ApplicationObj:PTR TO _Object     /* ... private data follows ... */
ENDOBJECT

/* Instance data of notify class */
OBJECT MUI_NotifyData
	GlobalInfo:PTR TO MUI_GlobalInfo,
	UserData:ULONG,
	ObjectID:ULONG,
	priv1:ULONG,
	priv2:ULONG,
	priv3:ULONG,
	priv4:ULONG
ENDOBJECT

/* MUI_MinMax structure holds information about minimum, maximum
   and default dimensions of an object. */
OBJECT MUI_MinMax
	MinWidth:WORD,
	MinHeight:WORD,
	MaxWidth:WORD,
	MaxHeight:WORD,
	DefWidth:WORD,
	DefHeight:WORD
ENDOBJECT

CONST	MUI_MAXMAX=10000			/* Hook message for custom layout */
OBJECT MUI_LayoutMsg
	Type:ULONG,						/* type of message (see defines below)                      */
	Children:PTR TO MinList,	/* list of this groups children, traverse with NextObject() */
	MinMax:MUI_MinMax,			/* results for MUILM_MINMAX                                 */
	UNION Layout
		Width:LONG,
		Height:LONG,
		priv5:ULONG,
		priv6:ULONG
	ENDUNION							/* size (and result) for MUILM_LAYOUT                       */
ENDOBJECT

#define MUILM_MINMAX     1 	/* MUI wants you to calc your min & max sizes */
#define MUILM_LAYOUT     2 	/* MUI wants you to layout your children      */
#define MUILM_UNKNOWN   -1 	/* return this if your hook doesn't implement lm_Type */
/* (partial) instance data of area class */
OBJECT MUI_AreaData
	RenderInfo:PTR TO MUI_RenderInfo,    /* RenderInfo for this object */
	priv7:ULONG,
	Font:PTR TO TextFont,                /* Font */
	MinMax:MUI_MinMax,                   /* min/max/default sizes */
	Box:IBox,                            /* position and dimension */
	addleft:BYTE,                        /* frame & innerspacing left offset */
	addtop:BYTE,                         /* frame & innerspacing top offset  */
	subwidth:BYTE,                       /* frame & innerspacing add. width  */
	subheight:BYTE,                      /* frame & innerspacing add. height */
	Flags:ULONG                          /* see definitions below */
ENDOBJECT

/* Definitions for Flags, other flags are private */
#define MADF_DRAWOBJECT         (1<< 0)	/* completely redraw yourself */
#define MADF_DRAWUPDATE         (1<< 1)	/* only update yourself */
/* MUI's draw pens */
CONST	MPEN_SHINE=0,
		MPEN_HALFSHINE=1,
		MPEN_BACKGROUND=2,
		MPEN_HALFSHADOW=3,
		MPEN_SHADOW=4,
		MPEN_TEXT=5,
		MPEN_FILL=6,
		MPEN_MARK=7,
		MPEN_COUNT=8
CONST	MUIPEN_MASK=65535
#define MUIPEN(pen ) ((pen) & MUIPEN_MASK)
/* Information on display environment */
OBJECT MUI_RenderInfo
	WindowObj:PTR TO _Object,    /* valid between MUIM_Setup/MUIM_Cleanup */
	Screen:PTR TO Screen,          /* valid between MUIM_Setup/MUIM_Cleanup */
	DrawInfo:PTR TO DrawInfo,      /* valid between MUIM_Setup/MUIM_Cleanup */
	Pens:PTR TO UWORD,             /* valid between MUIM_Setup/MUIM_Cleanup */
	Window:PTR TO Window,          /* valid between MUIM_Show/MUIM_Hide */
	RastPort:PTR TO RastPort,      /* valid between MUIM_Show/MUIM_Hide */
	Flags:ULONG                    /* valid between MUIM_Setup/MUIM_Cleanup */
ENDOBJECT

/*
** If Flags & MUIMRI_RECTFILL, RectFill() is quicker
** than Move()/Draw() for horizontal or vertical lines.
** on the current display.
*/
#define MUIMRI_RECTFILL  (1<<0)
/*
** If Flags & MUIMRI_TRUECOLOR, display environment is a
** cybergraphics emulated hicolor or true color display.
*/
#define MUIMRI_TRUECOLOR  (1<<1)
/*
** If Flags & MUIMRI_THINFRAMES, MUI uses thin frames
** (1:1) apsect ratio instead of standard 2:1 frames.
*/
#define MUIMRI_THINFRAMES  (1<<2)
/*
** If Flags & MUIMRI_REFRESHMODE, MUI is currently
** refreshing a WFLG_SIMPLEREFRESH window and is between
** a BeginRefresh()/EndRefresh() pair.
*/
#define MUIMRI_REFRESHMODE  (1<<3)
/* the following macros can be used to get pointers to an objects
   GlobalInfo and RenderInfo structures. */
OBJECT __dummyXFC2__
	mnd:MUI_NotifyData,
	mad:MUI_AreaData
ENDOBJECT

#define muiNotifyData(obj ) obj::__dummyXFC2__.mnd
#define muiAreaData(obj )   obj::__dummyXFC2__.mad
#define muiGlobalInfo(obj ) obj::__dummyXFC2__.mnd.GlobalInfo
#define muiUserData(obj )   obj::__dummyXFC2__.mnd.UserData
#define muiRenderInfo(obj ) obj::__dummyXFC2__.mad.RenderInfo

/* User configurable keyboard events coming with MUIM_HandleInput */
ENUM	MUIKEY_RELEASE=-2,
		MUIKEY_NONE,
		MUIKEY_PRESS,
		MUIKEY_TOGGLE,
		MUIKEY_UP,
		MUIKEY_DOWN,
		MUIKEY_PAGEUP,
		MUIKEY_PAGEDOWN,
		MUIKEY_TOP,
		MUIKEY_BOTTOM,
		MUIKEY_LEFT,
		MUIKEY_RIGHT,
		MUIKEY_WORDLEFT,
		MUIKEY_WORDRIGHT,
		MUIKEY_LINESTART,
		MUIKEY_LINEEND,
		MUIKEY_GADGET_NEXT,
		MUIKEY_GADGET_PREV,
		MUIKEY_GADGET_OFF,
		MUIKEY_WINDOW_CLOSE,
		MUIKEY_WINDOW_NEXT,
		MUIKEY_WINDOW_PREV,
		MUIKEY_HELP,
		MUIKEY_POPUP,
		MUIKEY_COUNT

#define MUIKEYF_PRESS         (1<<MUIKEY_PRESS)
#define MUIKEYF_TOGGLE        (1<<MUIKEY_TOGGLE)
#define MUIKEYF_UP            (1<<MUIKEY_UP)
#define MUIKEYF_DOWN          (1<<MUIKEY_DOWN)
#define MUIKEYF_PAGEUP        (1<<MUIKEY_PAGEUP)
#define MUIKEYF_PAGEDOWN      (1<<MUIKEY_PAGEDOWN)
#define MUIKEYF_TOP           (1<<MUIKEY_TOP)
#define MUIKEYF_BOTTOM        (1<<MUIKEY_BOTTOM)
#define MUIKEYF_LEFT          (1<<MUIKEY_LEFT)
#define MUIKEYF_RIGHT         (1<<MUIKEY_RIGHT)
#define MUIKEYF_WORDLEFT      (1<<MUIKEY_WORDLEFT)
#define MUIKEYF_WORDRIGHT     (1<<MUIKEY_WORDRIGHT)
#define MUIKEYF_LINESTART     (1<<MUIKEY_LINESTART)
#define MUIKEYF_LINEEND       (1<<MUIKEY_LINEEND)
#define MUIKEYF_GADGET_NEXT   (1<<MUIKEY_GADGET_NEXT)
#define MUIKEYF_GADGET_PREV   (1<<MUIKEY_GADGET_PREV)
#define MUIKEYF_GADGET_OFF    (1<<MUIKEY_GADGET_OFF)
#define MUIKEYF_WINDOW_CLOSE  (1<<MUIKEY_WINDOW_CLOSE)
#define MUIKEYF_WINDOW_NEXT   (1<<MUIKEY_WINDOW_NEXT)
#define MUIKEYF_WINDOW_PREV   (1<<MUIKEY_WINDOW_PREV)
#define MUIKEYF_HELP          (1<<MUIKEY_HELP)
#define MUIKEYF_POPUP         (1<<MUIKEY_POPUP)
/* Some useful shortcuts. define MUI_NOSHORTCUTS to get rid of them */
/* NOTE: These macros may only be used in custom classes and are    */
/* only valid if your class is inbetween the specified methods!     */
#ifndef MUI_NOSHORTCUTS
#define _app(obj )         (muiGlobalInfo(obj).ApplicationObj) 	/* valid between MUIM_Setup/Cleanup */
#define _win(obj )         (muiRenderInfo(obj).WindowObj)      	/* valid between MUIM_Setup/Cleanup */
#define _dri(obj )         muiRenderInfo(obj).DrawInfo          	/* valid between MUIM_Setup/Cleanup */
#define _screen(obj )      (muiRenderInfo(obj).Screen)            	/* valid between MUIM_Setup/Cleanup */
#define _pens(obj )        (muiRenderInfo(obj).Pens)              	/* valid between MUIM_Setup/Cleanup */
#define _window(obj )      (muiRenderInfo(obj).Window)            	/* valid between MUIM_Show/Hide */
#define _rp(obj )          (muiRenderInfo(obj).RastPort)          	/* valid between MUIM_Show/Hide */
#define _left(obj )        (muiAreaData(obj).Box.Left)            	/* valid during MUIM_Draw */
#define _top(obj )         (muiAreaData(obj).Box.Top)             	/* valid during MUIM_Draw */
#define _width(obj )       (muiAreaData(obj).Box.Width)           	/* valid during MUIM_Draw */
#define _height(obj )      (muiAreaData(obj).Box.Height)          	/* valid during MUIM_Draw */
#define _right(obj )       (_left(obj)+_width(obj)-1)                 	/* valid during MUIM_Draw */
#define _bottom(obj )      (_top(obj)+_height(obj)-1)                 	/* valid during MUIM_Draw */
#define _addleft(obj )     (muiAreaData(obj).addleft  )           	/* valid during MUIM_Draw */
#define _addtop(obj )      (muiAreaData(obj).addtop   )           	/* valid during MUIM_Draw */
#define _subwidth(obj )    (muiAreaData(obj).subwidth )           	/* valid during MUIM_Draw */
#define _subheight(obj )   (muiAreaData(obj).subheight)           	/* valid during MUIM_Draw */
#define _mleft(obj )       (_left(obj)+_addleft(obj))                 	/* valid during MUIM_Draw */
#define _mtop(obj )        (_top(obj)+_addtop(obj))                   	/* valid during MUIM_Draw */
#define _mwidth(obj )      (_width(obj)-_subwidth(obj))               	/* valid during MUIM_Draw */
#define _mheight(obj )     (_height(obj)-_subheight(obj))             	/* valid during MUIM_Draw */
#define _mright(obj )      (_mleft(obj)+_mwidth(obj)-1)               	/* valid during MUIM_Draw */
#define _mbottom(obj )     (_mtop(obj)+_mheight(obj)-1)               	/* valid during MUIM_Draw */
#define _font(obj )        (muiAreaData(obj).Font)                	/* valid between MUIM_Setup/Cleanup */
#define _minwidth(obj )    (muiAreaData(obj).MinMax.MinWidth)     	/* valid between MUIM_Show/Hide */
#define _minheight(obj )   (muiAreaData(obj).MinMax.MinHeight)    	/* valid between MUIM_Show/Hide */
#define _maxwidth(obj )    (muiAreaData(obj).MinMax.MaxWidth)     	/* valid between MUIM_Show/Hide */
#define _maxheight(obj )   (muiAreaData(obj).MinMax.MaxHeight)    	/* valid between MUIM_Show/Hide */
#define _defwidth(obj )    (muiAreaData(obj).MinMax.DefWidth)     	/* valid between MUIM_Show/Hide */
#define _defheight(obj )   (muiAreaData(obj).MinMax.DefHeight)    	/* valid between MUIM_Show/Hide */
#define _flags(obj )       (muiAreaData(obj).Flags)
#endif
/* MUI_CustomClass returned by MUI_CreateCustomClass() */
OBJECT MUI_CustomClass
	UserData:LONG,                    /* use for whatever you want */
	UtilityBase:PTR TO Library,      /* MUI has opened these libraries */
	DOSBase:PTR TO Library,          /* for you automatically. You can */
	GfxBase:PTR TO Library,          /* use them or decide to open     */
	IntuitionBase:PTR TO Library,    /* your libraries yourself.       */
	Super:PTR TO IClass,             /* pointer to super class   */
	Class:PTR TO IClass              /* pointer to the new class */
ENDOBJECT
