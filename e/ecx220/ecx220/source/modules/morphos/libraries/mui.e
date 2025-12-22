/***************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993-1997 Stefan Stuntz
**
** Main Header File
**
** AmigaE Interface by Jan Hendrik Schulz
**
** The comments are mostly taken unchanged from the original C mui.h file.
** Special comments made by me are with ->. See the guide for more infos
** about this file
**
***************************************************************************/

-> MUI4 additions by Leif Salomonsson 2008
-> Jan 2009: added missed MUIV_List_Redraw_Entry.

OPT MODULE
OPT EXPORT
OPT PREPROCESS, MORPHOS

MODULE 'exec/libraries', 'exec/lists', 'exec/nodes', 'exec/tasks',
       'utility/hooks',
       'graphics/rastport', 'graphics/text',
       'intuition/intuition', 'intuition/screens', 'intuition/classes'


/***************************************************************************
** Class Tree
****************************************************************************
**
** rootclass                   (BOOPSI's base class)
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


/***************************************************************************
** Library specification
***************************************************************************/

#define MUIMASTER_NAME 'muimaster.library'
CONST MUIMASTER_VMIN = 20
CONST MUIMASTER_VLATEST = 20
CONST MUI_TRUE = 1

/*
** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
** Warning, some of the macros in this header file work only with
** up to date versions of muimaster.library. If you recompile your programs,
** be sure to open muimaster.library with MUIMASTER_VMIN as version number.
** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

#define MUI_OBSOLETE /* include obsolete identifiers */



/*************************************************************************
** Config items for MUIM_GetConfigItem
*************************************************************************/


CONST MUICFG_PublicScreen          = 36




/*************************************************************************
** Black box specification structures for images, pens, frames
*************************************************************************/

OBJECT mui_penspec
    buf[32]:ARRAY OF CHAR
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

-> NOTE: The following may be useless in E, because I didn't translated the
->       above mentioned source to E, but to get a complete translation of
->       the original mui.h file, I didn't removed it...

#define PSD_INITIAL_NAME   '(unnamed)'
#define PSD_INITIAL_TITLE  'MUI Public Screen'
#define PSD_ID_MPUB        "MPUB"

#define PSD_NAME_FRONTMOST '<<Frontmost>>'

#define PSD_FILENAME_SAVE 'envarc:mui/PublicScreens.iff'
#define PSD_FILENAME_USE  'env:mui/PublicScreens.iff'

CONST PSD_MAXLEN_NAME       =  32
CONST PSD_MAXLEN_TITLE      = 128
CONST PSD_MAXLEN_FONT       =  48
CONST PSD_MAXLEN_BACKGROUND = 256
CONST PSD_NUMCOLS           =   8
CONST PSD_MAXSYSPENS        =  20
CONST PSD_NUMSYSPENS        =  12
CONST PSD_MAXMUIPENS        =  10
CONST PSD_NUMMUIPENS        =   8 -> 8=MPEN_COUNT

OBJECT mui_rgbcolor
    red   :LONG
    green :LONG
    blue  :LONG
ENDOBJECT

OBJECT mui_pubscreendesc
    version:LONG

    name[PSD_MAXLEN_NAME]            :ARRAY OF CHAR
    title[PSD_MAXLEN_TITLE]          :ARRAY OF CHAR
    font[PSD_MAXLEN_FONT]            :ARRAY OF CHAR
    background[PSD_MAXLEN_BACKGROUND]:ARRAY OF CHAR

    displayid:LONG

    displaywidth :INT
    displayheight:INT

    displaydepth   :CHAR
    overscantype   :CHAR
    autoscroll     :CHAR
    nodrag         :CHAR
    exclusive      :CHAR
    interleaved    :CHAR
    sysdefault     :CHAR
    behind         :CHAR
    autoclose      :CHAR
    closegadget    :CHAR
    dummywasforeign:CHAR

    systempens[PSD_MAXSYSPENS]:ARRAY OF CHAR
    reserved[9]:ARRAY OF CHAR

    palette[PSD_NUMCOLS]:ARRAY OF mui_rgbcolor
    rsvd[12]:ARRAY OF mui_rgbcolor

    rsvd2[PSD_MAXMUIPENS]:ARRAY OF mui_penspec

    changed :LONG
    userdata:LONG
ENDOBJECT

OBJECT muis_infoclient
    node  :mln
    task  :PTR TO tc
    sigbit:LONG
ENDOBJECT


/***************************************************************************
** Object Types for MUI_MakeObject()
***************************************************************************/

CONST MUIO_Label         =  1   /* STRPTR label, ULONG flags */
CONST MUIO_Button        =  2   /* STRPTR label */
CONST MUIO_Checkmark     =  3   /* STRPTR label */
CONST MUIO_Cycle         =  4   /* STRPTR label, STRPTR *entries */
CONST MUIO_Radio         =  5   /* STRPTR label, STRPTR *entries */
CONST MUIO_Slider        =  6   /* STRPTR label, LONG min, LONG max */
CONST MUIO_String        =  7   /* STRPTR label, LONG maxlen */
CONST MUIO_PopButton     =  8   /* STRPTR imagespec */
CONST MUIO_HSpace        =  9   /* LONG space   */
CONST MUIO_VSpace        = 10   /* LONG space   */
CONST MUIO_HBar          = 11   /* LONG space   */
CONST MUIO_VBar          = 12   /* LONG space   */
CONST MUIO_MenustripNM   = 13   /* struct NewMenu *nm, ULONG flags */
CONST MUIO_Menuitem      = 14   /* STRPTR label, STRPTR shortcut, ULONG flags, ULONG data  */
CONST MUIO_BarTitle      = 15   /* STRPTR label */
CONST MUIO_NumericButton = 16   /* STRPTR label, LONG min, LONG max, STRPTR format */

CONST MUIO_Menuitem_CopyStrings = $40000000

CONST MUIO_Label_SingleFrame  =  256
CONST MUIO_Label_DoubleFrame  =  512
CONST MUIO_Label_LeftAligned  = 1024
CONST MUIO_Label_Centered     = 2048
CONST MUIO_Label_FreeVert     = 4096

CONST MUIO_MenustripNM_CommandKeyCheck = 1 /* check for "localized" menu items such as "O\0Open" */

/***************************************************************************
** ARexx Interface
***************************************************************************/

OBJECT mui_command
    mc_name       :PTR TO CHAR
    mc_template   :PTR TO CHAR
    mc_parameters :LONG
    mc_hook       :PTR TO hook
    mc_reserved[5]:ARRAY OF LONG
ENDOBJECT

CONST MC_TEMPLATE_ID = -1

CONST MUI_RXERR_BADDEFINITION  = -1
CONST MUI_RXERR_OUTOFMEMORY    = -2
CONST MUI_RXERR_UNKNOWNCOMMAND = -3
CONST MUI_RXERR_BADSYNTAX      = -4


/***************************************************************************
** Return values for MUI_Error()
***************************************************************************/

CONST MUIE_OK                  = 0
CONST MUIE_OutOfMemory         = 1
CONST MUIE_OutOfGfxMemory      = 2
CONST MUIE_InvalidWindowObject = 3
CONST MUIE_MissingLibrary      = 4
CONST MUIE_NoARexx             = 5
CONST MUIE_SingleTask          = 6



/***************************************************************************
** Standard MUI Images & Backgrounds
***************************************************************************/

CONST MUII_WindowBack    =  0   /* These images are configured   */
CONST MUII_RequesterBack =  1   /* with the preferences program. */
CONST MUII_ButtonBack    =  2
CONST MUII_ListBack      =  3
CONST MUII_TextBack      =  4
CONST MUII_PropBack      =  5
CONST MUII_PopupBack     =  6
CONST MUII_SelectedBack  =  7
CONST MUII_ListCursor    =  8
CONST MUII_ListSelect    =  9
CONST MUII_ListSelCur    = 10
CONST MUII_ArrowUp       = 11
CONST MUII_ArrowDown     = 12
CONST MUII_ArrowLeft     = 13
CONST MUII_ArrowRight    = 14
CONST MUII_CheckMark     = 15
CONST MUII_RadioButton   = 16
CONST MUII_Cycle         = 17
CONST MUII_PopUp         = 18
CONST MUII_PopFile       = 19
CONST MUII_PopDrawer     = 20
CONST MUII_PropKnob      = 21
CONST MUII_Drawer        = 22
CONST MUII_HardDisk      = 23
CONST MUII_Disk          = 24
CONST MUII_Chip          = 25
CONST MUII_Volume        = 26
CONST MUII_RegisterBack  = 27
CONST MUII_Network       = 28
CONST MUII_Assign        = 29
CONST MUII_TapePlay      = 30
CONST MUII_TapePlayBack  = 31
CONST MUII_TapePause     = 32
CONST MUII_TapeStop      = 33
CONST MUII_TapeRecord    = 34
CONST MUII_GroupBack     = 35
CONST MUII_SliderBack    = 36
CONST MUII_SliderKnob    = 37
CONST MUII_TapeUp        = 38
CONST MUII_TapeDown      = 39
CONST MUII_PageBack      = 40
CONST MUII_ReadListBack  = 41

-> this block new in 4.0
CONST MUII_PopFont           = 42
CONST MUII_ImageButtonBack   = 43
CONST MUII_ImageSelectedBack = 44
CONST MUII_GaugeFull         = 45
CONST MUII_GaugeEmpty        = 46
CONST MUII_Menudisplay       = 47
CONST MUII_PullOpen          = 48
CONST MUII_StringBack        = 49
CONST MUII_StringActiveBack  = 50
CONST MUII_ListTitle         = 51

CONST MUII_Count             = 52

CONST MUII_BACKGROUND     = 128    /* These are direct color    */
CONST MUII_SHADOW         = 129    /* combinations and are not  */
CONST MUII_SHINE          = 130    /* affected by users prefs.  */
CONST MUII_FILL           = 131
CONST MUII_SHADOWBACK     = 132    /* Generally, you should     */
CONST MUII_SHADOWFILL     = 133    /* avoid using them. Better  */
CONST MUII_SHADOWSHINE    = 134    /* use one of the customized */
CONST MUII_FILLBACK       = 135    /* images above.             */
CONST MUII_FILLSHINE      = 136
CONST MUII_SHINEBACK      = 137
CONST MUII_FILLBACK2      = 138
CONST MUII_HSHINEBACK     = 139
CONST MUII_HSHADOWBACK    = 140
CONST MUII_HSHINESHINE    = 141
CONST MUII_HSHADOWSHADOW  = 142
CONST MUII_MARKSHINE      = 143
CONST MUII_MARKHALFSHINE  = 144
CONST MUII_MARKBACKGROUND = 145

-> these two new in 4.0
CONST MUII_BARBLOCK       = 146
CONST MUII_BARDETAIL      = 147

CONST MUII_LASTPAT        = 147


/***************************************************************************
** Special values for some methods
***************************************************************************/

CONST MUIV_TriggerValue    = $49893131
CONST MUIV_NotTriggerValue = $49893133
CONST MUIV_EveryTime       = $49893131

CONST MUIV_Notify_Self        = 1
CONST MUIV_Notify_Window      = 2
CONST MUIV_Notify_Application = 3
CONST MUIV_Notify_Parent      = 4

CONST MUIV_Application_Save_ENV     =  0
CONST MUIV_Application_Save_ENVARC  = -1
CONST MUIV_Application_Load_ENV     =  0
CONST MUIV_Application_Load_ENVARC  = -1

CONST MUIV_Application_ReturnID_Quit = -1

CONST MUIV_List_Insert_Top           =  0
CONST MUIV_List_Insert_Active        = -1
CONST MUIV_List_Insert_Sorted        = -2
CONST MUIV_List_Insert_Bottom        = -3

CONST MUIV_List_Remove_First         =  0
CONST MUIV_List_Remove_Active        = -1
CONST MUIV_List_Remove_Last          = -2
CONST MUIV_List_Remove_Selected      = -3

CONST MUIV_List_Select_Off           =  0
CONST MUIV_List_Select_On            =  1
CONST MUIV_List_Select_Toggle        =  2
CONST MUIV_List_Select_Ask           =  3

CONST MUIV_List_GetEntry_Active      = -1
CONST MUIV_List_Select_Active        = -1
CONST MUIV_List_Select_All           = -2

CONST MUIV_List_Redraw_Active        = -1
CONST MUIV_List_Redraw_All           = -2
CONST MUIV_List_Redraw_Entry         = -3

CONST MUIV_List_Move_Top             =  0
CONST MUIV_List_Move_Active          = -1
CONST MUIV_List_Move_Bottom          = -2
CONST MUIV_List_Move_Next            = -3 /* only valid for second parameter */
CONST MUIV_List_Move_Previous        = -4 /* only valid for second parameter */

CONST MUIV_List_Exchange_Top         =  0
CONST MUIV_List_Exchange_Active      = -1
CONST MUIV_List_Exchange_Bottom      = -2
CONST MUIV_List_Exchange_Next        = -3 /* only valid for second parameter */
CONST MUIV_List_Exchange_Previous    = -4 /* only valid for second parameter */

CONST MUIV_List_Jump_Top             =  0
CONST MUIV_List_Jump_Active          = -1
CONST MUIV_List_Jump_Bottom          = -2
CONST MUIV_List_Jump_Up              = -4
CONST MUIV_List_Jump_Down            = -3

CONST MUIV_List_NextSelected_Start   = -1
CONST MUIV_List_NextSelected_End     = -1

CONST MUIV_DragQuery_Refuse = 0
CONST MUIV_DragQuery_Accept = 1

CONST MUIV_DragReport_Abort    = 0
CONST MUIV_DragReport_Continue = 1
CONST MUIV_DragReport_Lock     = 2
CONST MUIV_DragReport_Refresh  = 3

-> this block new in 4.0
CONST MUIV_CreateBubble_DontHidePointer = 1
CONST MUIV_Application_OCW_ScreenPage = 2 /* show just the screen page of the config window */
CONST MUIV_ContextMenuBuild_Default = $ffffffff
#define MUIV_PushMethod_Delay(millis) Min($0ffffff0,((millis) SHL 8))
CONST MUIV_Family_GetChild_First     = 0
CONST MUIV_Family_GetChild_Last     = -1
CONST MUIV_Family_GetChild_Next     = -2
CONST MUIV_Family_GetChild_Previous = -3
CONST MUIV_Family_GetChild_Iterate  = -4
CONST MUIV_Group_GetChild_First     = MUIV_Family_GetChild_First
CONST MUIV_Group_GetChild_Last      = MUIV_Family_GetChild_Last
CONST MUIV_Group_GetChild_Next      = MUIV_Family_GetChild_Next
CONST MUIV_Group_GetChild_Previous  = MUIV_Family_GetChild_Previous
CONST MUIV_Group_GetChild_Iterate   = MUIV_Family_GetChild_Iterate

/***************************************************************************
** Control codes for text strings
***************************************************************************/

#define MUIX_R '\er'    /* right justified */
#define MUIX_C '\ec'    /* centered        */
#define MUIX_L '\el'    /* left justified  */

#define MUIX_N '\en'    /* normal     */
#define MUIX_B '\eb'    /* bold       */
#define MUIX_I '\ei'    /* italic     */
#define MUIX_U '\eu'    /* underlined */

#define MUIX_PT '\e2'   /* text pen           */
#define MUIX_PH '\e8'   /* highlight text pen */



/***************************************************************************
** Parameter structures for some classes
***************************************************************************/

OBJECT mui_palette_entry
    mpe_id    :LONG
    mpe_red   :LONG
    mpe_green :LONG
    mpe_blue  :LONG
    mpe_group :LONG
ENDOBJECT

CONST MUIV_Palette_Entry_End = -1


-> The next 2 OBJECTs are in C only one struct, but the struct uses a
-> union which isn't available in E. So I created 2 OBJECTs.

OBJECT mui_inputhandlernode
    ihn_node    :mln
    ihn_object  :LONG
    ihn_signals :LONG  -> In C this is ihn_stuff.ihn_sigs
    ihn_flags   :LONG  /* see below */
    ihn_method  :LONG
ENDOBJECT

OBJECT mui_inputhandlernode_timer
    ihn_node    :mln
    ihn_object  :LONG
    ihn_millis  :INT  -> In C this is ihn_stuff.ihn_timer.ihn_millis
    ihn_current :INT  -> In C this is ihn_stuff.ihn_timer.ihn_current
    ihn_flags   :LONG  /* see below */
    ihn_method  :LONG
ENDOBJECT

/* Flags for ihn_flags */

CONST MUIIHNF_TIMER =1 /* set ihn_Ticks to number of 1/100 sec ticks you want to be triggered */

-> these two new in 4.0
CONST MUIIHNF_TIMER_SCALE10   = 2 /* ihn_Millis is in 1/100 seconds instead */
CONST MUIIHNF_TIMER_SCALE100  = 4 /* ihn_Millis is in 1/10 seconds instead */
                                       /* setting both SCALE10|SCALE100 makes ihn_Millis 1/1 seconds */


/************************/
/* Window Event Handler */
/************************/

OBJECT mui_eventhandlernode
    ehn_node     :mln
    ehn_reserved :CHAR           /* don't touch! */
    ehn_priority :CHAR           /* event handlers are inserted according to their priority. */
    ehn_flags    :INT            /* certain flags, see below for definitions. */
    ehn_object   :LONG           /* object which should receive MUIM_HandleEvent. */
    ehn_class    :PTR TO iclass  /* if !=NULL, MUIM_HandleEvent is invoked on exactly this class with CoerceMethod(). */
    ehn_events   :LONG           /* one or more IDCMP flags this handler should react on. */
ENDOBJECT

/* flags for ehn_flags */
CONST MUI_EHF_ALWAYSKEYS = 1

-> these new in 4.0
CONST MUI_EHF_GUIMODE     = 2  /* set this if you dont want your handler to be called */
                           /* when your object is disabled or invisible */
CONST MUI_EHF_ISACTIVEGRP = 4 /* not for public use */
CONST MUI_EHF_ISACTIVE    = 8192 /* this flag is maintained by MUI and READ-ONLY: */
                           /* set when ehn_Object is a window's active or default object. */
CONST MUI_EHF_ISCALLING   = 16384 /* not for public use */
CONST MUI_EHF_ISENABLED   = 32768 /* this flag is maintained by MUI and READ-ONLY: */
                           /* it is set when the handler is added (after MUIM_Window_AddEventHandler) */
                           /* and cleared when the handler is removed (after MUIM_Window_RemEventHandler). */
                           /* you may not change the state of this flag yourself, but you may read it */
                           /* to find out whether your handler is currently added to a window or not. */

/* other values reserved for future use */

/* return values for MUIM_HandleEvent (bit-masked, all other bits must be 0) */
CONST MUI_EventHandlerRC_Eat = 1  /* stop MUI from calling other handlers */


/**********************/
/* List Position Test */
/**********************/

OBJECT mui_list_testpos_result
    entry   :LONG  /* number of entry, -1 if mouse not over valid entry */
    column  :INT   /* numer of column, -1 if no valid column */
    flags   :INT   /* see below */
    xoffset :INT   /* x offset of mouse click relative to column start */
    yoffset :INT   /* y offset of mouse click from center of line
                     (negative values mean click was above center,
                      positive values mean click was below center) */
ENDOBJECT

CONST MUI_LPR_ABOVE  = 1
CONST MUI_LPR_BELOW  = 2
CONST MUI_LPR_LEFT   = 4
CONST MUI_LPR_RIGHT  = 8

/***************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below. If you dont want, just define MUI_NOSHORTCUTS to disable
** them.
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
**          MUIA_String_Contents, 'foo',
**          MUIA_String_MaxLen  , 40,
**          End
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
**                Child, String('foo',40),
**                Child, String('bar',50),
**                Child, HGroup,
**                   Child, CheckMark(MUI_TRUE),
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
**          End
**
***************************************************************************/


#define MenustripObject      Mui_NewObjectA(MUIC_Menustrip,[TAG_IGNORE,0
#define MenuObject           Mui_NewObjectA(MUIC_Menu,[TAG_IGNORE,0
#define MenuObjectT(name)    Mui_NewObjectA(MUIC_Menu,[MUIA_Menu_Title,name
#define MenuitemObject       Mui_NewObjectA(MUIC_Menuitem,[TAG_IGNORE,0
#define WindowObject         Mui_NewObjectA(MUIC_Window,[TAG_IGNORE,0
#define ImageObject          Mui_NewObjectA(MUIC_Image,[TAG_IGNORE,0
#define BitmapObject         Mui_NewObjectA(MUIC_Bitmap,[TAG_IGNORE,0
#define BodychunkObject      Mui_NewObjectA(MUIC_Bodychunk,[TAG_IGNORE,0
#define NotifyObject         Mui_NewObjectA(MUIC_Notify,[TAG_IGNORE,0
#define ApplicationObject    Mui_NewObjectA(MUIC_Application,[TAG_IGNORE,0
#define TextObject           Mui_NewObjectA(MUIC_Text,[TAG_IGNORE,0
#define RectangleObject      Mui_NewObjectA(MUIC_Rectangle,[TAG_IGNORE,0
#define BalanceObject        Mui_NewObjectA(MUIC_Balance,[TAG_IGNORE,0
#define ListObject           Mui_NewObjectA(MUIC_List,[TAG_IGNORE,0
#define PropObject           Mui_NewObjectA(MUIC_Prop,[TAG_IGNORE,0
#define StringObject         Mui_NewObjectA(MUIC_String,[TAG_IGNORE,0
#define ScrollbarObject      Mui_NewObjectA(MUIC_Scrollbar,[TAG_IGNORE,0
#define ListviewObject       Mui_NewObjectA(MUIC_Listview,[TAG_IGNORE,0
#define RadioObject          Mui_NewObjectA(MUIC_Radio,[TAG_IGNORE,0
#define VolumelistObject     Mui_NewObjectA(MUIC_Volumelist,[TAG_IGNORE,0
#define FloattextObject      Mui_NewObjectA(MUIC_Floattext,[TAG_IGNORE,0
#define DirlistObject        Mui_NewObjectA(MUIC_Dirlist,[TAG_IGNORE,0
#define SliderObject         Mui_NewObjectA(MUIC_Slider,[TAG_IGNORE,0
#define CycleObject          Mui_NewObjectA(MUIC_Cycle,[TAG_IGNORE,0
#define GaugeObject          Mui_NewObjectA(MUIC_Gauge,[TAG_IGNORE,0
#define ScaleObject          Mui_NewObjectA(MUIC_Scale,[TAG_IGNORE,0
#define NumericObject        Mui_NewObjectA(MUIC_Numeric,[TAG_IGNORE,0
#define NumericbuttonObject  Mui_NewObjectA(MUIC_Numericbutton,[TAG_IGNORE,0
#define KnobObject           Mui_NewObjectA(MUIC_Knob,[TAG_IGNORE,0
#define LevelmeterObject     Mui_NewObjectA(MUIC_Levelmeter,[TAG_IGNORE,0
#define BoopsiObject         Mui_NewObjectA(MUIC_Boopsi,[TAG_IGNORE,0
#define ColorfieldObject     Mui_NewObjectA(MUIC_Colorfield,[TAG_IGNORE,0
#define PenadjustObject      Mui_NewObjectA(MUIC_Penadjust,[TAG_IGNORE,0
#define ColoradjustObject    Mui_NewObjectA(MUIC_Coloradjust,[TAG_IGNORE,0
#define PaletteObject        Mui_NewObjectA(MUIC_Palette,[TAG_IGNORE,0
#define GroupObject          Mui_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define RegisterObject       Mui_NewObjectA(MUIC_Register,[TAG_IGNORE,0
#define VirtgroupObject      Mui_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define ScrollgroupObject    Mui_NewObjectA(MUIC_Scrollgroup,[TAG_IGNORE,0
#define PopstringObject      Mui_NewObjectA(MUIC_Popstring,[TAG_IGNORE,0
#define PopobjectObject      Mui_NewObjectA(MUIC_Popobject,[TAG_IGNORE,0
#define PoplistObject        Mui_NewObjectA(MUIC_Poplist,[TAG_IGNORE,0
#define PopaslObject         Mui_NewObjectA(MUIC_Popasl,[TAG_IGNORE,0
#define PendisplayObject     Mui_NewObjectA(MUIC_Pendisplay,[TAG_IGNORE,0
#define PoppenObject         Mui_NewObjectA(MUIC_Poppen,[TAG_IGNORE,0
#define AboutmuiObject       Mui_NewObjectA(MUIC_Aboutmui,[TAG_IGNORE,0
#define ScrmodelistObject    Mui_NewObjectA(MUIC_Scrmodelist,[TAG_IGNORE,0
#define KeyentryObject       Mui_NewObjectA(MUIC_Keyentry,[TAG_IGNORE,0
#define VGroup               Mui_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define HGroup               Mui_NewObjectA(MUIC_Group,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroup(cols)       Mui_NewObjectA(MUIC_Group,[MUIA_Group_Columns,(cols)
#define RowGroup(rows)       Mui_NewObjectA(MUIC_Group,[MUIA_Group_Rows   ,(rows)
#define PageGroup            Mui_NewObjectA(MUIC_Group,[MUIA_Group_PageMode,MUI_TRUE
#define VGroupV              Mui_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define HGroupV              Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroupV(cols)      Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Columns,(cols)
#define RowGroupV(rows)      Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Rows   ,(rows)
#define PageGroupV           Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_PageMode,MUI_TRUE
#define RegisterGroup(t)     Mui_NewObjectA(MUIC_Register,[MUIA_Register_Titles,(t)
#define End                  TAG_DONE])

#define Child             MUIA_Group_Child
#define SubWindow         MUIA_Application_Window
#define WindowContents    MUIA_Window_RootObject



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
** HGroup, GroupFrameT('Horiz Groups'),
**    Child, RectangleObject, TextFrame  , End,
**    Child, RectangleObject, StringFrame, End,
**    Child, RectangleObject, ButtonFrame, End,
**    Child, RectangleObject, ListFrame  , End,
**    End,
**
***************************************************************************/

#define NoFrame          MUIA_Frame, MUIV_Frame_None
#define ButtonFrame      MUIA_Frame, MUIV_Frame_Button
#define ImageButtonFrame MUIA_Frame, MUIV_Frame_ImageButton
#define TextFrame        MUIA_Frame, MUIV_Frame_Text
#define StringFrame      MUIA_Frame, MUIV_Frame_String
#define ReadListFrame    MUIA_Frame, MUIV_Frame_ReadList
#define InputListFrame   MUIA_Frame, MUIV_Frame_InputList
#define PropFrame        MUIA_Frame, MUIV_Frame_Prop
#define SliderFrame      MUIA_Frame, MUIV_Frame_Slider
#define GaugeFrame       MUIA_Frame, MUIV_Frame_Gauge
#define VirtualFrame     MUIA_Frame, MUIV_Frame_Virtual
#define GroupFrame       MUIA_Frame, MUIV_Frame_Group
#define GroupFrameT(s)   MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s



/***************************************************************************
**
** Spacing Macros
** --------------
**
***************************************************************************/

#define HVSpace           Mui_NewObjectA(MUIC_Rectangle,[TAG_DONE])
#define HSpace(x)         Mui_MakeObjectA(MUIO_HSpace,[x])
#define VSpace(x)         Mui_MakeObjectA(MUIO_VSpace,[x])
#define HCenter(obj)      HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End
#define VCenter(obj)      VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End
#define InnerSpacing(h,v) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x)   MUIA_Group_Spacing,x



#ifdef MUI_OBSOLETE

/***************************************************************************
**
** String-Object
** -------------
**
** The following macro creates a simple string gadget.
**
***************************************************************************/

#define StringMUI(contents,maxlen)\
        StringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#define KeyString(contents,maxlen,controlchar)\
        StringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#endif



#ifdef MUI_OBSOLETE

/***************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following macro creates a checkmark gadget.
**
***************************************************************************/

#define CheckMark(selected)\
        ImageObject,\
                ImageButtonFrame,\
                MUIA_InputMode        , MUIV_InputMode_Toggle,\
                MUIA_Image_Spec       , MUII_CheckMark,\
                MUIA_Image_FreeVert   , MUI_TRUE,\
                MUIA_Selected         , selected,\
                MUIA_Background       , MUII_ButtonBack,\
                MUIA_ShowSelState     , FALSE,\
                End

#define KeyCheckMark(selected,control)\
        ImageObject,\
                ImageButtonFrame,\
                MUIA_InputMode        , MUIV_InputMode_Toggle,\
                MUIA_Image_Spec       , MUII_CheckMark,\
                MUIA_Image_FreeVert   , MUI_TRUE,\
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

#define SimpleButton(label) Mui_MakeObjectA(MUIO_Button,[label])

#ifdef MUI_OBSOLETE

#define KeyButton(name,key)\
        TextObject,\
                ButtonFrame,\
            MUIA_Font,          MUIV_Font_Button,\
                MUIA_Text_Contents, name,\
                MUIA_Text_PreParse, '\ec',\
                MUIA_Text_HiChar  , key,\
                MUIA_ControlChar  , key,\
                MUIA_InputMode    , MUIV_InputMode_RelVerify,\
                MUIA_Background   , MUII_ButtonBack,\
                End

#endif


#ifdef MUI_OBSOLETE

/***************************************************************************
**
** Cycle-Object
** ------------
**
***************************************************************************/

#define Cycle(entries)        CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End
#define KeyCycle(entries,key) CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End



/***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************/

#define Radio(name,array)\
        RadioObject,\
                GroupFrameT(name),\
                MUIA_Radio_Entries,array,\
                End

#define KeyRadio(name,array,key)\
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


#define Slider(min,max,level)\
        SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                End

#define KeySlider(min,max,level,key)\
        SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                MUIA_ControlChar , key,\
                End

#endif



/***************************************************************************
**
** Button to be used for popup objects
**
***************************************************************************/

#define PopButton(img) Mui_MakeObjectA(MUIO_PopButton,[img])



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
**      Child, Label2('Small:' ),
**    Child, StringObject, End,
**      Child, Label2('Normal:'),
**    Child, StringObject, End,
**      Child, Label2('Big:'   ),
**    Child, StringObject, End,
**      Child, Label2('Huge:'  ),
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

#define Label(label)   Mui_MakeObjectA(MUIO_Label,[label,0])
#define Label1(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_SingleFrame])
#define Label2(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_DoubleFrame])
#define LLabel(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned])
#define LLabel1(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned + MUIO_Label_SingleFrame])
#define LLabel2(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame])
#define CLabel(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_Centered])
#define CLabel1(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_Centered + MUIO_Label_SingleFrame])
#define CLabel2(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_Centered + MUIO_Label_DoubleFrame])

#define FreeLabel(label)   Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert])
#define FreeLabel1(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_SingleFrame])
#define FreeLabel2(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_DoubleFrame])
#define FreeLLabel(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_LeftAligned])
#define FreeLLabel1(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_SingleFrame])
#define FreeLLabel2(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame])
#define FreeCLabel(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_Centered])
#define FreeCLabel1(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_SingleFrame])
#define FreeCLabel2(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_DoubleFrame])

#define KeyLabel(label,key)   Mui_MakeObjectA(MUIO_Label,[label,key])
#define KeyLabel1(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_SingleFrame,key)])
#define KeyLabel2(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_DoubleFrame,key)])
#define KeyLLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned,key)])
#define KeyLLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key)])
#define KeyLLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key)])
#define KeyCLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_Centered,key)])
#define KeyCLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_Centered + MUIO_Label_SingleFrame,key)])
#define KeyCLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_Centered + MUIO_Label_DoubleFrame,key)])

#define FreeKeyLabel(label,key)   Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert,key)])
#define FreeKeyLabel1(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_SingleFrame,key)])
#define FreeKeyLabel2(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_DoubleFrame,key)])
#define FreeKeyLLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned,key)])
#define FreeKeyLLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key)])
#define FreeKeyLLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key)])
#define FreeKeyCLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered,key)])
#define FreeKeyCLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_SingleFrame,key)])
#define FreeKeyCLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_DoubleFrame,key)])



/***************************************************************************
**
** Controlling Objects
** -------------------
**
** set() and get() are two short stubs for BOOPSI GetAttr() and SetAttrsA()
** calls:
**
**    set(obj,MUIA_String_Contents,'foobar')
**    get(obj,MUIA_String_Contents,{x})
**    PrintF('gadget contains "\s"\n',x)
**
** nnset() sets an attribute without triggering a possible notification.
**
***************************************************************************/

#define get(obj,attr,store) GetAttr(attr,obj,store)
#ifdef ECX_VERSION
   #define set(obj,attr,value) SetAttrsA(obj,[0 BUT attr,0 BUT value,0])
   #define nnset(obj,attr,value) SetAttrsA(obj,[0 BUT $804237f9,0 BUT MUI_TRUE,0 BUT attr,0 BUT value,0])
#endif
#ifndef ECX_VERSION
   #define set(obj,attr,value) SetAttrsA(obj,[(attr),(value),0])
   #define nnset(obj,attr,value) SetAttrsA(obj,[($804237f9),(MUI_TRUE),(attr),(value),0])
#endif


#define setmutex(obj,n)     set(obj,MUIA_Radio_Active,n)
#define setcycle(obj,n)     set(obj,MUIA_Cycle_Active,n)
#define setstring(obj,s)    set(obj,MUIA_String_Contents,s)
#define setcheckmark(obj,b) set(obj,MUIA_Selected,b)
#define setslider(obj,l)    set(obj,MUIA_Numeric_Value,l)


#endif /* MUI_NOSHORTCUTS */


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

CONST MUIM_BoopsiQuery = $80427157 /* this is send to the boopsi and */
                                   /* must be used as return value   */

OBJECT mui_boopsiquery              /* parameter structure */
    mbq_methodid   :LONG                   /* always MUIM_BoopsiQuery */

    mbq_screen     :PTR TO screen          /* obsolete, use mbq_RenderInfo */
    mbq_flags      :LONG                   /* read only, see below */

    mbq_minwidth   :LONG                   /* write only, fill in min width  */
    mbq_minheight  :LONG                   /* write only, fill in min height */
    mbq_maxwidth   :LONG                   /* write only, fill in max width  */
    mbq_maxheight  :LONG                   /* write only, fill in max height */
    mbq_defwidth   :LONG                   /* write only, fill in def width  */
    mbq_defheight  :LONG                   /* write only, fill in def height */

    mbq_renderinfo :PTR TO mui_renderinfo  /* read only, display context */

    /* may grow in future ... */
ENDOBJECT

#define MUIP_BoopsiQuery MUI_BoopsiQuery  /* old structure name */

CONST MBQF_HORIZ = 1           /* object used in a horizontal */
                               /* context (else vertical)     */

CONST MBQ_MUI_MAXMAX = 10000   /* use this for unlimited MaxWidth/Height */

-> new with 4.0
CONST IDCMP_MOUSEOBJECT = $40000000 /* special idcmp message created by MUI */


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

OBJECT mui_globalinfo
   priv0                 :LONG
   mgi_applicationobject :PTR TO LONG
   /* ... private data follows ... */
ENDOBJECT


/* Instance data of notify class */

OBJECT mui_notifydata
   mnd_globalinfo :PTR TO mui_globalinfo
   mnd_userdata   :LONG
   mnd_objectid   :LONG
   priv1 :LONG
   priv2 :LONG
   priv3 :LONG
   priv4 :LONG
ENDOBJECT


/* MUI_MinMax structure holds information about minimum, maximum
   and default dimensions of an object. */

OBJECT mui_minmax
   minwidth  :INT
   minheight :INT
   maxwidth  :INT
   maxheight :INT
   defwidth  :INT
   defheight :INT
ENDOBJECT

CONST MUI_MAXMAX = 10000 /* use this if a dimension is not limited. */


/* Hook message for custom layout */

OBJECT mui_layoutmsg_size  -> NOTE: In the original C mui.h this structure is
   width :LONG             -> defined directly inside the following structure,
   height:LONG             -> without a name! (see mui.h) But in E that isn't
   priv5 :LONG             -> possible, so I had to do it this way.
   priv6 :LONG
ENDOBJECT

OBJECT mui_layoutmsg
   lm_type     :LONG                /* type of message (see CONSTs below) */
   lm_children :PTR TO mlh          /* list of this groups children,
                                       traverse with NextObject()         */
   lm_minmax   :mui_minmax          /* results for MUILM_MINMAX           */
   lm_layout   :mui_layoutmsg_size  /* size (and result) for MUILM_LAYOUT */
ENDOBJECT

CONST MUILM_MINMAX  =   1  /* MUI wants you to calc your min & max sizes */
CONST MUILM_LAYOUT  =   2  /* MUI wants you to layout your children      */

CONST MUILM_UNKNOWN =  -1  /* return this if your hook doesn't implement lm_Type */


/* (partial) instance data of area class */

OBJECT mui_areadata
   mad_renderinfo :PTR TO mui_renderinfo   /* RenderInfo for this object */
   priv7          :LONG
   mad_font       :PTR TO textfont         /* Font */
   mad_minmax     :mui_minmax              /* min/max/default sizes */
   mad_box        :ibox                    /* position and dimension */
   mad_addleft    :CHAR                    /* frame & innerspacing left offset */
   mad_addtop     :CHAR                    /* frame & innerspacing top offset  */
   mad_subwidth   :CHAR                    /* frame & innerspacing add. width  */
   mad_subheight  :CHAR                    /* frame & innerspacing add. height */
   mad_flags      :LONG                    /* see definitions below */

   /* ... private data follows ... */
ENDOBJECT

/* Definitions for mad_Flags, other flags are private */

CONST MADF_DRAWOBJECT = 1 /* completely redraw yourself */
CONST MADF_DRAWUPDATE = 2 /* only update yourself */




/* MUI's draw pens */

CONST MPEN_SHINE      = 0
CONST MPEN_HALFSHINE  = 1
CONST MPEN_BACKGROUND = 2
CONST MPEN_HALFSHADOW = 3
CONST MPEN_SHADOW     = 4
CONST MPEN_TEXT       = 5
CONST MPEN_FILL       = 6
CONST MPEN_MARK       = 7
CONST MPEN_COUNT      = 8


/* Mask for pens from MUI_ObtainPen() */

CONST MUIPEN_MASK = $0000ffff
#define MUIPEN(pen) ((pen) AND MUIPEN_MASK)


/* Information on display environment */

OBJECT mui_renderinfo
   mri_windowobject :PTR TO LONG      /* valid between MUIM_Setup/MUIM_Cleanup */

   mri_screen       :PTR TO screen    /* valid between MUIM_Setup/MUIM_Cleanup */
   mri_drawinfo     :PTR TO drawinfo  /* valid between MUIM_Setup/MUIM_Cleanup */
   mri_pens         :PTR TO INT       /* valid between MUIM_Setup/MUIM_Cleanup */
   mri_window       :PTR TO window    /* valid between MUIM_Show/MUIM_Hide */
   mri_rastport     :PTR TO rastport  /* valid between MUIM_Show/MUIM_Hide */
   mri_flags        :LONG             /* valid between MUIM_Setup/MUIM_Cleanup */
   /* ... private data follows ... */
ENDOBJECT

/*
** If mri_Flags & MUIMRI_RECTFILL, RectFill() is quicker
** than Move()/Draw() for horizontal or vertical lines.
** on the current display.
*/
CONST MUIMRI_RECTFILL = 1

/*
** If mri_Flags & MUIMRI_TRUECOLOR, display environment is a
** cybergraphics emulated hicolor or true color display with
** an unlimited number of pens available. Obtain/ReleasePen()s
** as many as you want... :-)
*/
CONST MUIMRI_TRUECOLOR = 2

/*
** If mri_Flags & MUIMRI_THINFRAMES, MUI uses thin frames
** (1:1) apsect ratio instead of standard 2:1 frames.
*/
CONST MUIMRI_THINFRAMES = 4

/*
** If mri_Flags & MUIMRI_REFRESHMODE, MUI is currently
** refreshing a WFLG_SIMPLEREFRESH window and is between
** a BeginRefresh()/EndRefresh() pair.
*/
CONST MUIMRI_REFRESHMODE = 8


-> new in 4.0
/*
** If mri_Flags & MUIMRI_PLANAR, display environment is an
** old-style planar display.
*/
CONST MUIMRI_PLANAR = 16


/* the following macros can be used to get pointers to an objects
   GlobalInfo and RenderInfo structures. */

OBJECT __dummyxfc2__
   mnd :mui_notifydata
   mad :mui_areadata
ENDOBJECT

-> *********************** ATTENTION **************************
->  To use the following macros, obj MUST be a <var> (not a
->  <varexp> or <exp>) and it  MUST be defined like:
->
->  DEF obj:PTR TO <object>    or    DEF obj:<object>
->
->  with <object> any possible OBJECT (e.g. __dummyxfc2__ )
-> ************************************************************
-> To use the macros
->
->   _left(), _top(), _width(), _height(), _right(), _bottom,
->  _mleft(),_mtop(),_mwidth(),_mheight(),_mright(),_mbottom
->
-> you have to include the module 'intuition/intuition' into
-> your source (with MODULE 'intuition/intuition')!
-> ************************************************************

#define muiNotifyData(obj) obj::__dummyxfc2__.mnd
#define muiAreaData(obj)   obj::__dummyxfc2__.mad

#define muiGlobalInfo(obj) obj::__dummyxfc2__.mnd.mnd_globalinfo
#define muiUserData(obj)   obj::__dummyxfc2__.mnd.mnd_userdata
#define muiRenderInfo(obj) obj::__dummyxfc2__.mad.mad_renderinfo

/* Some useful shortcuts. define MUI_NOSHORTCUTS to get rid of them */
/* NOTE: These macros may only be used in custom classes and are    */
/* only valid if your class is inbetween the specified methods!     */

#ifndef MUI_NOSHORTCUTS

#define _app(obj)         muiGlobalInfo(obj).mgi_applicationobject  /* valid between MUIM_Setup/Cleanup */
#define _win(obj)         muiRenderInfo(obj).mri_windowobject       /* valid between MUIM_Setup/Cleanup */
#define _dri(obj)         muiRenderInfo(obj).mri_drawinfo           /* valid between MUIM_Setup/Cleanup */
#define _screen(obj)      muiRenderInfo(obj).mri_screen             /* valid between MUIM_Setup/Cleanup */
#define _pens(obj)        muiRenderInfo(obj).mri_pens               /* valid between MUIM_Setup/Cleanup */
#define _window(obj)      muiRenderInfo(obj).mri_window             /* valid between MUIM_Show/Hide */
#define _rp(obj)          muiRenderInfo(obj).mri_rastport           /* valid between MUIM_Show/Hide */
#define _left(obj)        muiAreaData(obj).mad_box.left             /* valid during MUIM_Draw */
#define _top(obj)         muiAreaData(obj).mad_box.top              /* valid during MUIM_Draw */
#define _width(obj)       muiAreaData(obj).mad_box.width            /* valid during MUIM_Draw */
#define _height(obj)      muiAreaData(obj).mad_box.height           /* valid during MUIM_Draw */
#define _right(obj)       (_left(obj)+_width(obj)-1)                /* valid during MUIM_Draw */
#define _bottom(obj)      (_top(obj)+_height(obj)-1)                /* valid during MUIM_Draw */
#define _addleft(obj)     muiAreaData(obj).mad_addleft              /* valid during MUIM_Draw */
#define _addtop(obj)      muiAreaData(obj).mad_addtop               /* valid during MUIM_Draw */
#define _subwidth(obj)    muiAreaData(obj).mad_subwidth             /* valid during MUIM_Draw */
#define _subheight(obj)   muiAreaData(obj).mad_subheight            /* valid during MUIM_Draw */
#define _mleft(obj)       (_left(obj)+_addleft(obj))                /* valid during MUIM_Draw */
#define _mtop(obj)        (_top(obj)+_addtop(obj))                  /* valid during MUIM_Draw */
#define _mwidth(obj)      (_width(obj)-_subwidth(obj))              /* valid during MUIM_Draw */
#define _mheight(obj)     (_height(obj)-_subheight(obj))            /* valid during MUIM_Draw */
#define _mright(obj)      (_mleft(obj)+_mwidth(obj)-1)              /* valid during MUIM_Draw */
#define _mbottom(obj)     (_mtop(obj)+_mheight(obj)-1)              /* valid during MUIM_Draw */
#define _font(obj)        muiAreaData(obj).mad_font                 /* valid between MUIM_Setup/Cleanup */
#define _minwidth(obj)    muiAreaData(obj).mad_minmax.minwidth      /* valid between MUIM_Show/Hide */
#define _minheight(obj)   muiAreaData(obj).mad_minmax.minheight     /* valid between MUIM_Show/Hide */
#define _maxwidth(obj)    muiAreaData(obj).mad_minmax.maxwidth      /* valid between MUIM_Show/Hide */
#define _maxheight(obj)   muiAreaData(obj).mad_minmax.maxheight     /* valid between MUIM_Show/Hide */
#define _defwidth(obj)    muiAreaData(obj).mad_minmax.defwidth      /* valid between MUIM_Show/Hide */
#define _defheight(obj)   muiAreaData(obj).mad_minmax.defheight     /* valid between MUIM_Show/Hide */
#define _flags(obj)       muiAreaData(obj).mad_flags

#endif


/* User configurable keyboard events coming with MUIM_HandleInput */

CONST MUIKEY_RELEASE        = -2 /* not a real key, faked when MUIKEY_PRESS is released */
CONST MUIKEY_NONE           = -1
ENUM  MUIKEY_PRESS,
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
      -> 4.0
      MUIKEY_CUT,
      MUIKEY_COPY,
      MUIKEY_PASTE,
      MUIKEY_UNDO,
      MUIKEY_REDO,
      MUIKEY_DELETE,
      MUIKEY_BACKSPACE,

      MUIKEY_COUNT   /* counter */

-> MUI_OBSOLETE /* keys are never used in bitmasks */
#ifdef NOTDEFINED
SET MUIKEYF_PRESS,
    MUIKEYF_TOGGLE,
    MUIKEYF_UP,
    MUIKEYF_DOWN,
    MUIKEYF_PAGEUP,
    MUIKEYF_PAGEDOWN,
    MUIKEYF_TOP,
    MUIKEYF_BOTTOM,
    MUIKEYF_LEFT,
    MUIKEYF_RIGHT,
    MUIKEYF_WORDLEFT,
    MUIKEYF_WORDRIGHT,
    MUIKEYF_LINESTART,
    MUIKEYF_LINEEND,
    MUIKEYF_GADGET_NEXT,
    MUIKEYF_GADGET_PREV,
    MUIKEYF_GADGET_OFF,
    MUIKEYF_WINDOW_CLOSE,
    MUIKEYF_WINDOW_NEXT,
    MUIKEYF_WINDOW_PREV,
    MUIKEYF_HELP,
    MUIKEYF_POPUP
#endif

/* MUI_CustomClass returned by MUI_CreateCustomClass() */

OBJECT mui_customclass
   mcc_userdata      :LONG            /* use for whatever you want */

   mcc_utilitybase   :PTR TO lib      /* MUI has opened these libraries */
   mcc_dosbase       :PTR TO lib      /* for you automatically. You can */
   mcc_gfxbase       :PTR TO lib      /* use them or decide to open     */
   mcc_intuitionbase :PTR TO lib      /* your libraries yourself.       */

   mcc_super         :PTR TO iclass   /* pointer to super class   */
   mcc_class         :PTR TO iclass   /* pointer to the new class */
   /* ... private data follows ... */
ENDOBJECT



/****************************************************************************/
/** Notify                                                                 **/
/****************************************************************************/

#define MUIC_Notify 'Notify.mui'

/* Methods */

CONST MUIM_CallHook                  = $8042b96b /* V4  */
CONST MUIM_Export                    = $80420f1c /* V12 */
CONST MUIM_FindUData                 = $8042c196 /* V8  */
CONST MUIM_GetConfigItem             = $80423edb /* V11 */
CONST MUIM_GetUData                  = $8042ed0c /* V8  */
CONST MUIM_Import                    = $8042d012 /* V12 */
CONST MUIM_KillNotify                = $8042d240 /* V4  */
CONST MUIM_KillNotifyObj             = $8042b145 /* V16 */
CONST MUIA_NoNotifyMethod            = $80420a74 /* V20 */
CONST MUIM_MultiSet                  = $8042d356 /* V7  */
CONST MUIM_NoNotifySet               = $8042216f /* V9  */
CONST MUIM_Notify                    = $8042c9cb /* V4  */
CONST MUIM_Set                       = $8042549a /* V4  */
CONST MUIM_SetAsString               = $80422590 /* V4  */
CONST MUIM_SetUData                  = $8042c920 /* V8  */
CONST MUIM_SetUDataOnce              = $8042ca19 /* V11 */
CONST MUIM_WriteLong                 = $80428d86 /* V6  */
CONST MUIM_WriteString               = $80424bf4 /* V6  */

/* Attributes */

CONST MUIA_ApplicationObject              = $8042d3ee /* V4  ..g Object *          */
CONST MUIA_AppMessage                     = $80421955 /* V5  ..g struct AppMessage * */
CONST MUIA_HelpLine                       = $8042a825 /* V4  isg LONG              */
CONST MUIA_HelpNode                       = $80420b85 /* V4  isg STRPTR            */
CONST MUIA_NoNotify                       = $804237f9 /* V7  .s. BOOL              */
CONST MUIA_Parent                         = $8042e35f /* V11 ..g Object *          */
CONST MUIA_Revision                       = $80427eaa /* V4  ..g LONG              */
CONST MUIA_UserData                       = $80420313 /* V4  isg ULONG             */
CONST MUIA_Version                        = $80422301 /* V4  ..g LONG              */



/****************************************************************************/
/** Family                                                                 **/
/****************************************************************************/

#define MUIC_Family 'Family.mui'

/* Methods */

CONST MUIM_Family_AddHead            = $8042e200 /* V8  */
CONST MUIM_Family_AddTail            = $8042d752 /* V8  */
CONST MUIM_Family_Insert             = $80424d34 /* V8  */
CONST MUIM_Family_Remove             = $8042f8a9 /* V8  */
CONST MUIM_Family_Sort               = $80421c49 /* V8  */
CONST MUIM_Family_Transfer           = $8042c14a /* V8  */

/* Attributes */

CONST MUIA_Family_Child                   = $8042c696 /* V8  i.. Object *          */
CONST MUIA_Family_List                    = $80424b9e /* V8  ..g struct MinList *  */



/****************************************************************************/
/** Menustrip                                                              **/
/****************************************************************************/

#define MUIC_Menustrip 'Menustrip.mui'

/* Methods */
CONST MUIM_Menustrip_ExitChange           = $8042ce4d /* V20 */
CONST MUIM_Menustrip_InitChange           = $8042dcd9 /* V20 */
CONST MUIM_Menustrip_Popup                = $80420e76 /* V20 */

/* Attributes */

CONST MUIA_Menustrip_Enabled              = $8042815b /* V8  isg BOOL              */



/****************************************************************************/
/** Menu                                                                   **/
/****************************************************************************/

#define MUIC_Menu 'Menu.mui'

/* Methods */


/* Attributes */

CONST MUIA_Menu_Enabled                   = $8042ed48 /* V8  isg BOOL              */
CONST MUIA_Menu_Title                     = $8042a0e3 /* V8  isg STRPTR            */



/****************************************************************************/
/** Menuitem                                                               **/
/****************************************************************************/

#define MUIC_Menuitem 'Menuitem.mui'

/* Methods */


/* Attributes */

CONST MUIA_Menuitem_Checked               = $8042562a /* V8  isg BOOL              */
CONST MUIA_Menuitem_Checkit               = $80425ace /* V8  isg BOOL              */
CONST MUIA_Menuitem_CommandString         = $8042b9cc /* V16 isg BOOL              */
CONST MUIA_Menuitem_CopyStrings           = $8042dc1b /* V16 i.. BOOL              */
CONST MUIA_Menuitem_Enabled               = $8042ae0f /* V8  isg BOOL              */
CONST MUIA_Menuitem_Exclude               = $80420bc6 /* V8  isg LONG              */
CONST MUIA_Menuitem_Shortcut              = $80422030 /* V8  isg STRPTR            */
CONST MUIA_Menuitem_Title                 = $804218be /* V8  isg STRPTR            */
CONST MUIA_Menuitem_Toggle                = $80424d5c /* V8  isg BOOL              */
CONST MUIA_Menuitem_Trigger               = $80426f32 /* V8  ..g struct MenuItem * */

CONST MUIV_Menuitem_Shortcut_Check = -1


/****************************************************************************/
/** Application                                                            **/
/****************************************************************************/

#define MUIC_Application 'Application.mui'

/* Methods */

CONST MUIM_Application_AboutMUI         = $8042d21d /* V14 */
CONST MUIM_Application_AddInputHandler  = $8042f099 /* V11 */
CONST MUIM_Application_DefaultConfigItem= $8042d934 /* V20 */
CONST MUIM_Application_CheckRefresh     = $80424d68 /* V11 */
CONST MUIM_Application_GetMenuCheck     = $8042c0a7 /* V4  */
CONST MUIM_Application_GetMenuState     = $8042a58f /* V4  */
CONST MUIM_Application_Input            = $8042d0f5 /* V4  */
CONST MUIM_Application_InputBuffered    = $80427e59 /* V4  */
CONST MUIM_Application_Load             = $8042f90d /* V4  */
CONST MUIM_Application_NewInput         = $80423ba6 /* V11 */
CONST MUIM_Application_OpenConfigWindow = $804299ba /* V11 */
CONST MUIM_Application_PushMethod       = $80429ef8 /* V4  */
CONST MUIM_Application_RemInputHandler  = $8042e7af /* V11 */
CONST MUIM_Application_ReturnID         = $804276ef /* V4  */
CONST MUIM_Application_Save             = $804227ef /* V4  */
CONST MUIM_Application_SetConfigItem    = $80424a80 /* V11 */
CONST MUIM_Application_SetMenuCheck     = $8042a707 /* V4  */
CONST MUIM_Application_SetMenuState     = $80428bef /* V4  */
CONST MUIM_Application_ShowHelp         = $80426479 /* V4  */

/* Attributes */

CONST MUIA_Application_Active             = $804260ab /* V4  isg BOOL              */
CONST MUIA_Application_Author             = $80424842 /* V4  i.g STRPTR            */
CONST MUIA_Application_Base               = $8042e07a /* V4  i.g STRPTR            */
CONST MUIA_Application_Broker             = $8042dbce /* V4  ..g Broker *          */
CONST MUIA_Application_BrokerHook         = $80428f4b /* V4  isg struct Hook *     */
CONST MUIA_Application_BrokerPort         = $8042e0ad /* V6  ..g struct MsgPort *  */
CONST MUIA_Application_BrokerPri          = $8042c8d0 /* V6  i.g LONG              */
CONST MUIA_Application_Commands           = $80428648 /* V4  isg struct MUI_Command * */
CONST MUIA_Application_Copyright          = $8042ef4d /* V4  i.g STRPTR            */
CONST MUIA_Application_Description        = $80421fc6 /* V4  i.g STRPTR            */
CONST MUIA_Application_DiskObject         = $804235cb /* V4  isg struct DiskObject * */
CONST MUIA_Application_DoubleStart        = $80423bc6 /* V4  ..g BOOL              */
CONST MUIA_Application_DropObject         = $80421266 /* V5  is. Object *          */
CONST MUIA_Application_ForceQuit          = $804257df /* V8  ..g BOOL              */
CONST MUIA_Application_HelpFile           = $804293f4 /* V8  isg STRPTR            */
CONST MUIA_Application_Iconified          = $8042a07f /* V4  .sg BOOL              */
CONST MUIA_Application_Menu               = $80420e1f /* V4  i.g struct NewMenu *  */
CONST MUIA_Application_MenuAction         = $80428961 /* V4  ..g ULONG             */
CONST MUIA_Application_MenuHelp           = $8042540b /* V4  ..g ULONG             */
CONST MUIA_Application_Menustrip          = $804252d9 /* V8  i.. Object *          */
CONST MUIA_Application_RexxHook           = $80427c42 /* V7  isg struct Hook *     */
CONST MUIA_Application_RexxMsg            = $8042fd88 /* V4  ..g struct RxMsg *    */
CONST MUIA_Application_RexxString         = $8042d711 /* V4  .s. STRPTR            */
CONST MUIA_Application_SingleTask         = $8042a2c8 /* V4  i.. BOOL              */
CONST MUIA_Application_Sleep              = $80425711 /* V4  .s. BOOL              */
CONST MUIA_Application_Title              = $804281b8 /* V4  i.g STRPTR            */
CONST MUIA_Application_UseCommodities     = $80425ee5 /* V10 i.. BOOL              */
CONST MUIA_Application_UsedClasses        = $8042e9a7 /* V20 isg STRPTR *          */
CONST MUIA_Application_UseRexx            = $80422387 /* V10 i.. BOOL              */
CONST MUIA_Application_Version            = $8042b33f /* V4  i.g STRPTR            */
CONST MUIA_Application_Window             = $8042bfe0 /* V4  i.. Object *          */
CONST MUIA_Application_WindowList         = $80429abe /* V13 ..g struct List *     */

CONST MUIV_Application_Package_NetConnect = $a3ff7b49


/****************************************************************************/
/** Window                                                                 **/
/****************************************************************************/

#define MUIC_Window 'Window.mui'

/* Methods */

CONST MUIM_Window_AddEventHandler    = $804203b7 /* V16 */
CONST MUIM_Window_GetMenuCheck       = $80420414 /* V4  */
CONST MUIM_Window_GetMenuState       = $80420d2f /* V4  */
CONST MUIM_Window_RemEventHandler    = $8042679e /* V16 */
CONST MUIM_Window_ScreenToBack       = $8042913d /* V4  */
CONST MUIM_Window_ScreenToFront      = $804227a4 /* V4  */
CONST MUIM_Window_SetCycleChain      = $80426510 /* V4  */
CONST MUIM_Window_SetMenuCheck       = $80422243 /* V4  */
CONST MUIM_Window_SetMenuState       = $80422b5e /* V4  */
CONST MUIM_Window_Snapshot           = $8042945e /* V11 */
CONST MUIM_Window_ToBack             = $8042152e /* V4  */
CONST MUIM_Window_ToFront            = $8042554f /* V4  */

/* Attributes */

CONST MUIA_Window_Activate                = $80428d2f /* V4  isg BOOL              */
CONST MUIA_Window_ActiveObject            = $80427925 /* V4  .sg Object *          */
CONST MUIA_Window_AltHeight               = $8042cce3 /* V4  i.g LONG              */
CONST MUIA_Window_AltLeftEdge             = $80422d65 /* V4  i.g LONG              */
CONST MUIA_Window_AltTopEdge              = $8042e99b /* V4  i.g LONG              */
CONST MUIA_Window_AltWidth                = $804260f4 /* V4  i.g LONG              */
CONST MUIA_Window_AppWindow               = $804280cf /* V5  i.. BOOL              */
CONST MUIA_Window_Backdrop                = $8042c0bb /* V4  i.. BOOL              */
CONST MUIA_Window_Borderless              = $80429b79 /* V4  i.. BOOL              */
CONST MUIA_Window_CloseGadget             = $8042a110 /* V4  i.. BOOL              */
CONST MUIA_Window_CloseRequest            = $8042e86e /* V4  ..g BOOL              */
CONST MUIA_Window_DefaultObject           = $804294d7 /* V4  isg Object *          */
CONST MUIA_Window_DepthGadget             = $80421923 /* V4  i.. BOOL              */
CONST MUIA_Window_DragBar                 = $8042045d /* V4  i.. BOOL              */
CONST MUIA_Window_FancyDrawing            = $8042bd0e /* V8  isg BOOL              */
CONST MUIA_Window_Height                  = $80425846 /* V4  i.g LONG              */
CONST MUIA_Window_ID                      = $804201bd /* V4  isg ULONG             */
CONST MUIA_Window_InputEvent              = $804247d8 /* V4  ..g struct InputEvent * */
CONST MUIA_Window_IsSubWindow             = $8042b5aa /* V4  isg BOOL              */
CONST MUIA_Window_LeftEdge                = $80426c65 /* V4  i.g LONG              */
CONST MUIA_Window_Menu                    = $8042db94 /* V4  i.. struct NewMenu *  */
CONST MUIA_Window_MenuAction              = $80427521 /* V8  isg ULONG             */
CONST MUIA_Window_Menustrip               = $8042855e /* V8  i.g Object *          */
CONST MUIA_Window_MouseObject             = $8042bf9b /* V10 ..g Object *          */
CONST MUIA_Window_NeedsMouseObject        = $8042372a /* V10 i.. BOOL              */
CONST MUIA_Window_NoMenus                 = $80429df5 /* V4  is. BOOL              */
CONST MUIA_Window_Open                    = $80428aa0 /* V4  .sg BOOL              */
CONST MUIA_Window_PublicScreen            = $804278e4 /* V6  isg STRPTR            */
CONST MUIA_Window_RefWindow               = $804201f4 /* V4  is. Object *          */
CONST MUIA_Window_RootObject              = $8042cba5 /* V4  isg Object *          */
CONST MUIA_Window_Screen                  = $8042df4f /* V4  isg struct Screen *   */
CONST MUIA_Window_ScreenTitle             = $804234b0 /* V5  isg STRPTR            */
CONST MUIA_Window_SizeGadget              = $8042e33d /* V4  i.. BOOL              */
CONST MUIA_Window_SizeRight               = $80424780 /* V4  i.. BOOL              */
CONST MUIA_Window_Sleep                   = $8042e7db /* V4  .sg BOOL              */
CONST MUIA_Window_Title                   = $8042ad3d /* V4  isg STRPTR            */
CONST MUIA_Window_TopEdge                 = $80427c66 /* V4  i.g LONG              */
CONST MUIA_Window_UseBottomBorderScroller = $80424e79 /* V13 is. BOOL              */
CONST MUIA_Window_UseLeftBorderScroller   = $8042433e /* V13 is. BOOL              */
CONST MUIA_Window_UseRightBorderScroller  = $8042c05e /* V13 is. BOOL              */
CONST MUIA_Window_Width                   = $8042dcae /* V4  i.g LONG              */
CONST MUIA_Window_Window                  = $80426a42 /* V4  ..g struct Window *   */

CONST MUIV_Window_ActiveObject_None = 0
CONST MUIV_Window_ActiveObject_Next = -1
CONST MUIV_Window_ActiveObject_Prev = -2
#define MUIV_Window_AltHeight_MinMax(p) (0-(p))
#define MUIV_Window_AltHeight_Visible(p) (-100-(p))
#define MUIV_Window_AltHeight_Screen(p) (-200-(p))
CONST MUIV_Window_AltHeight_Scaled = -1000
CONST MUIV_Window_AltLeftEdge_Centered = -1
CONST MUIV_Window_AltLeftEdge_Moused = -2
CONST MUIV_Window_AltLeftEdge_NoChange = -1000
CONST MUIV_Window_AltTopEdge_Centered = -1
CONST MUIV_Window_AltTopEdge_Moused = -2
#define MUIV_Window_AltTopEdge_Delta(p) (-3-(p))
CONST MUIV_Window_AltTopEdge_NoChange = -1000
#define MUIV_Window_AltWidth_MinMax(p) (0-(p))
#define MUIV_Window_AltWidth_Visible(p) (-100-(p))
#define MUIV_Window_AltWidth_Screen(p) (-200-(p))
CONST MUIV_Window_AltWidth_Scaled = -1000
#define MUIV_Window_Height_MinMax(p) (0-(p))
#define MUIV_Window_Height_Visible(p) (-100-(p))
#define MUIV_Window_Height_Screen(p) (-200-(p))
CONST MUIV_Window_Height_Scaled = -1000
CONST MUIV_Window_Height_Default = -1001
CONST MUIV_Window_LeftEdge_Centered = -1
CONST MUIV_Window_LeftEdge_Moused = -2
#ifdef MUI_OBSOLETE
CONST MUIV_Window_Menu_NoMenu = -1
#endif /* MUI_OBSOLETE */
CONST MUIV_Window_TopEdge_Centered = -1
CONST MUIV_Window_TopEdge_Moused = -2
#define MUIV_Window_TopEdge_Delta(p) (-3-(p))
#define MUIV_Window_Width_MinMax(p) (0-(p))
#define MUIV_Window_Width_Visible(p) (-100-(p))
#define MUIV_Window_Width_Screen(p) (-200-(p))
CONST MUIV_Window_Width_Scaled = -1000
CONST MUIV_Window_Width_Default = -1001


/****************************************************************************/
/** Aboutmui                                                               **/
/****************************************************************************/

#define MUIC_Aboutmui 'Aboutmui.mui'

/* Methods */


/* Attributes */

CONST MUIA_Aboutmui_Application           = $80422523 /* V11 i.. Object *          */



/****************************************************************************/
/** Area                                                                   **/
/****************************************************************************/

#define MUIC_Area 'Area.mui'

/* Methods */

CONST MUIM_AskMinMax                 = $80423874 /* Custom Class */ /* V4  */
CONST MUIM_Cleanup                   = $8042d985 /* Custom Class */ /* V4  */
CONST MUIM_ContextMenuAdd            = $8042df9e /* V20 */
CONST MUIM_ContextMenuBuild          = $80429d2e /* V11 */
CONST MUIM_ContextMenuChoice         = $80420f0e /* V11 */
CONST MUIM_CreateBubble              = $80421c41 /* V18 */
CONST MUIM_CreateShortHelp           = $80428e93 /* V11 */
CONST MUIM_DeleteBubble              = $804211af /* V18 */
CONST MUIM_DeleteShortHelp           = $8042d35a /* V11 */
CONST MUIM_DoDrag                    = $804216bb /* V20 */
CONST MUIM_DragBegin                 = $8042c03a /* V11 */
CONST MUIM_DragDrop                  = $8042c555 /* V11 */
CONST MUIM_DragFinish                = $804251f0 /* V11 */
CONST MUIM_DragQuery                 = $80420261 /* V11 */
CONST MUIM_DragReport                = $8042edad /* V11 */
CONST MUIM_Draw                      = $80426f3f /* Custom Class */ /* V4  */
CONST MUIM_DrawBackground            = $804238ca /* V11 */
CONST MUIM_HandleEvent               = $80426d66 /* Custom Class */ /* V16 */
CONST MUIM_HandleInput               = $80422a1a /* Custom Class */ /* V4  */
CONST MUIM_Hide                      = $8042f20f /* Custom Class */ /* V4  */
CONST MUIM_Setup                     = $80428354 /* Custom Class */ /* V4  */
CONST MUIM_Show                      = $8042cc84 /* Custom Class */ /* V4  */
CONST MUIM_UpdateConfig              = $8042b0a9 /* V20 */

/* Attributes */

CONST MUIA_Background                     = $8042545b /* V4  is. LONG              */
CONST MUIA_BottomEdge                     = $8042e552 /* V4  ..g LONG              */
CONST MUIA_ContextMenu                    = $8042b704 /* V11 isg Object *          */
CONST MUIA_ContextMenuTrigger             = $8042a2c1 /* V11 ..g Object *          */
CONST MUIA_ControlChar                    = $8042120b /* V4  isg char              */
CONST MUIA_CycleChain                     = $80421ce7 /* V11 isg LONG              */
CONST MUIA_Disabled                       = $80423661 /* V4  isg BOOL              */
CONST MUIA_DoubleBuffer                   = $8042a9c7 /* V20 isg BOOL              */
CONST MUIA_Draggable                      = $80420b6e /* V11 isg BOOL              */
CONST MUIA_Dropable                       = $8042fbce /* V11 isg BOOL              */
CONST MUIA_ExportID                       = $8042d76e /* V4  isg ULONG             */
CONST MUIA_FillArea                       = $804294a3 /* V4  is. BOOL              */
CONST MUIA_FixHeight                      = $8042a92b /* V4  i.. LONG              */
CONST MUIA_FixHeightTxt                   = $804276f2 /* V4  i.. STRPTR            */
CONST MUIA_FixWidth                       = $8042a3f1 /* V4  i.. LONG              */
CONST MUIA_FixWidthTxt                    = $8042d044 /* V4  i.. STRPTR            */
CONST MUIA_Font                           = $8042be50 /* V4  i.g struct TextFont * */
CONST MUIA_Frame                          = $8042ac64 /* V4  i.. LONG              */
CONST MUIA_FrameDynamic                   = $804223c9 /* V20 isg BOOL              */
CONST MUIA_FramePhantomHoriz              = $8042ed76 /* V4  i.. BOOL              */
CONST MUIA_FrameTitle                     = $8042d1c7 /* V4  i.. STRPTR            */
CONST MUIA_FrameVisible                   = $80426498 /* V20 isg BOOL              */
CONST MUIA_Height                         = $80423237 /* V4  ..g LONG              */
CONST MUIA_HorizDisappear                 = $80429615 /* V11 isg LONG              */
CONST MUIA_HorizWeight                    = $80426db9 /* V4  i.. WORD              */
CONST MUIA_InnerBottom                    = $8042f2c0 /* V4  i.. LONG              */
CONST MUIA_InnerLeft                      = $804228f8 /* V4  i.. LONG              */
CONST MUIA_InnerRight                     = $804297ff /* V4  i.. LONG              */
CONST MUIA_InnerTop                       = $80421eb6 /* V4  i.. LONG              */
CONST MUIA_InputMode                      = $8042fb04 /* V4  i.. LONG              */
CONST MUIA_LeftEdge                       = $8042bec6 /* V4  ..g LONG              */
CONST MUIA_MaxHeight                      = $804293e4 /* V11 i.. LONG              */
CONST MUIA_MaxWidth                       = $8042f112 /* V11 i.. LONG              */
CONST MUIA_ObjectID                       = $8042d76e /* V11 isg ULONG             */
CONST MUIA_Pressed                        = $80423535 /* V4  ..g BOOL              */
CONST MUIA_RightEdge                      = $8042ba82 /* V4  ..g LONG              */
CONST MUIA_Selected                       = $8042654b /* V4  isg BOOL              */
CONST MUIA_ShortHelp                      = $80428fe3 /* V11 isg STRPTR            */
CONST MUIA_ShowMe                         = $80429ba8 /* V4  isg BOOL              */
CONST MUIA_ShowSelState                   = $8042caac /* V4  i.. BOOL              */
CONST MUIA_Timer                          = $80426435 /* V4  ..g LONG              */
CONST MUIA_TopEdge                        = $8042509b /* V4  ..g LONG              */
CONST MUIA_VertDisappear                  = $8042d12f /* V11 isg LONG              */
CONST MUIA_VertWeight                     = $804298d0 /* V4  i.. WORD              */
CONST MUIA_Weight                         = $80421d1f /* V4  i.. WORD              */
CONST MUIA_Width                          = $8042b59c /* V4  ..g LONG              */
CONST MUIA_Window                         = $80421591 /* V4  ..g struct Window *   */
CONST MUIA_WindowObject                   = $8042669e /* V4  ..g Object *          */

CONST MUIV_Font_Inherit = 0
CONST MUIV_Font_Normal = -1
CONST MUIV_Font_List = -2
CONST MUIV_Font_Tiny = -3
CONST MUIV_Font_Fixed = -4
CONST MUIV_Font_Title = -5
CONST MUIV_Font_Big = -6
CONST MUIV_Font_Button = -7
CONST MUIV_Frame_None = 0
CONST MUIV_Frame_Button = 1
CONST MUIV_Frame_ImageButton = 2
CONST MUIV_Frame_Text = 3
CONST MUIV_Frame_String = 4
CONST MUIV_Frame_ReadList = 5
CONST MUIV_Frame_InputList = 6
CONST MUIV_Frame_Prop = 7
CONST MUIV_Frame_Gauge = 8
CONST MUIV_Frame_Group = 9
CONST MUIV_Frame_PopUp = 10
CONST MUIV_Frame_Virtual = 11
CONST MUIV_Frame_Slider = 12
CONST MUIV_Frame_Count = 13
CONST MUIV_InputMode_None = 0
CONST MUIV_InputMode_RelVerify = 1
CONST MUIV_InputMode_Immediate = 2
CONST MUIV_InputMode_Toggle = 3


/****************************************************************************/
/** Rectangle                                                              **/
/****************************************************************************/

#define MUIC_Rectangle 'Rectangle.mui'

/* Attributes */

CONST MUIA_Rectangle_BarTitle             = $80426689 /* V11 i.g STRPTR            */
CONST MUIA_Rectangle_HBar                 = $8042c943 /* V7  i.g BOOL              */
CONST MUIA_Rectangle_VBar                 = $80422204 /* V7  i.g BOOL              */



/****************************************************************************/
/** Balance                                                                **/
/****************************************************************************/

#define MUIC_Balance 'Balance.mui'

/* Attributes */
CONST MUIA_Balance_Quiet                  = $80427486 /* V20 i.. LONG              */

/****************************************************************************/
/** Image                                                                  **/
/****************************************************************************/

#define MUIC_Image 'Image.mui'

/* Attributes */

CONST MUIA_Image_FontMatch                = $8042815d /* V4  i.. BOOL              */
CONST MUIA_Image_FontMatchHeight          = $80429f26 /* V4  i.. BOOL              */
CONST MUIA_Image_FontMatchWidth           = $804239bf /* V4  i.. BOOL              */
CONST MUIA_Image_FreeHoriz                = $8042da84 /* V4  i.. BOOL              */
CONST MUIA_Image_FreeVert                 = $8042ea28 /* V4  i.. BOOL              */
CONST MUIA_Image_OldImage                 = $80424f3d /* V4  i.. struct Image *    */
CONST MUIA_Image_Spec                     = $804233d5 /* V4  i.. char *            */
CONST MUIA_Image_State                    = $8042a3ad /* V4  is. LONG              */



/****************************************************************************/
/** Bitmap                                                                 **/
/****************************************************************************/

#define MUIC_Bitmap 'Bitmap.mui'

/* Attributes */

CONST MUIA_Bitmap_Alpha                   = $80423e71 /* V20 isg ULONG             */
CONST MUIA_Bitmap_Bitmap                  = $804279bd /* V8  isg struct BitMap *   */
CONST MUIA_Bitmap_Height                  = $80421560 /* V8  isg LONG              */
CONST MUIA_Bitmap_MappingTable            = $8042e23d /* V8  isg UBYTE *           */
CONST MUIA_Bitmap_Precision               = $80420c74 /* V11 isg LONG              */
CONST MUIA_Bitmap_RemappedBitmap          = $80423a47 /* V11 ..g struct BitMap *   */
CONST MUIA_Bitmap_SourceColors            = $80425360 /* V8  isg ULONG *           */
CONST MUIA_Bitmap_Transparent             = $80422805 /* V8  isg LONG              */
CONST MUIA_Bitmap_UseFriend               = $804239d8 /* V11 i.. BOOL              */
CONST MUIA_Bitmap_Width                   = $8042eb3a /* V8  isg LONG              */



/****************************************************************************/
/** Bodychunk                                                              **/
/****************************************************************************/

#define MUIC_Bodychunk 'Bodychunk.mui'

/* Attributes */

CONST MUIA_Bodychunk_Body                 = $8042ca67 /* V8  isg UBYTE *           */
CONST MUIA_Bodychunk_Compression          = $8042de5f /* V8  isg UBYTE             */
CONST MUIA_Bodychunk_Depth                = $8042c392 /* V8  isg LONG              */
CONST MUIA_Bodychunk_Masking              = $80423b0e /* V8  isg UBYTE             */



/****************************************************************************/
/** Text                                                                   **/
/****************************************************************************/

#define MUIC_Text 'Text.mui'

/* Attributes */

CONST MUIA_Text_Contents                  = $8042f8dc /* V4  isg STRPTR            */
CONST MUIA_Text_HiChar                    = $804218ff /* V4  i.. char              */
CONST MUIA_Text_PreParse                  = $8042566d /* V4  isg STRPTR            */
CONST MUIA_Text_SetMax                    = $80424d0a /* V4  i.. BOOL              */
CONST MUIA_Text_SetMin                    = $80424e10 /* V4  i.. BOOL              */
CONST MUIA_Text_SetVMax                   = $80420d8b /* V11 i.. BOOL              */
CONST MUIA_Text_ControlChar               = $8042e6d0 /* V20 isg char              */
CONST MUIA_Text_Copy                      = $80427727 /* V20 isg BOOL              */
CONST MUIA_Text_Shorten                   = $80428bbd /* V20 isg LONG              */
CONST MUIA_Text_Shortened                 = $80425a86 /* V20 ..g BOOL              */

CONST MUIV_Text_Shorten_Nothing = 0
CONST MUIV_Text_Shorten_Cutoff = 1
CONST MUIV_Text_Shorten_Hide = 2


/****************************************************************************/
/** Gadget                                                                 **/
/****************************************************************************/

#define MUIC_Gadget 'Gadget.mui'

/* Attributes */

CONST MUIA_Gadget_Gadget                  = $8042ec1a /* V11 ..g struct Gadget *   */



/****************************************************************************/
/** String                                                                 **/
/****************************************************************************/

#define MUIC_String 'String.mui'

/* Attributes */

CONST MUIA_String_Accept                  = $8042e3e1 /* V4  isg STRPTR            */
CONST MUIA_String_Acknowledge             = $8042026c /* V4  ..g STRPTR            */
CONST MUIA_String_AdvanceOnCR             = $804226de /* V11 isg BOOL              */
CONST MUIA_String_AttachedList            = $80420fd2 /* V4  i.. Object *          */
CONST MUIA_String_BufferPos               = $80428b6c /* V4  .s. LONG              */
CONST MUIA_String_Contents                = $80428ffd /* V4  isg STRPTR            */
CONST MUIA_String_DisplayPos              = $8042ccbf /* V4  .s. LONG              */
CONST MUIA_String_EditHook                = $80424c33 /* V7  isg struct Hook *     */
CONST MUIA_String_Format                  = $80427484 /* V4  i.g LONG              */
CONST MUIA_String_Integer                 = $80426e8a /* V4  isg ULONG             */
CONST MUIA_String_LonelyEditHook          = $80421569 /* V11 isg BOOL              */
CONST MUIA_String_MaxLen                  = $80424984 /* V4  i.g LONG              */
CONST MUIA_String_Reject                  = $8042179c /* V4  isg STRPTR            */
CONST MUIA_String_Secret                  = $80428769 /* V4  i.g BOOL              */

CONST MUIV_String_Format_Left = 0
CONST MUIV_String_Format_Center = 1
CONST MUIV_String_Format_Right = 2


/****************************************************************************/
/** Boopsi                                                                 **/
/****************************************************************************/

#define MUIC_Boopsi 'Boopsi.mui'

/* Attributes */

CONST MUIA_Boopsi_Class                   = $80426999 /* V4  isg struct IClass *   */
CONST MUIA_Boopsi_ClassID                 = $8042bfa3 /* V4  isg char *            */
CONST MUIA_Boopsi_MaxHeight               = $8042757f /* V4  isg ULONG             */
CONST MUIA_Boopsi_MaxWidth                = $8042bcb1 /* V4  isg ULONG             */
CONST MUIA_Boopsi_MinHeight               = $80422c93 /* V4  isg ULONG             */
CONST MUIA_Boopsi_MinWidth                = $80428fb2 /* V4  isg ULONG             */
CONST MUIA_Boopsi_Object                  = $80420178 /* V4  ..g Object *          */
CONST MUIA_Boopsi_Remember                = $8042f4bd /* V4  i.. ULONG             */
CONST MUIA_Boopsi_Smart                   = $8042b8d7 /* V9  i.. BOOL              */
CONST MUIA_Boopsi_TagDrawInfo             = $8042bae7 /* V4  isg ULONG             */
CONST MUIA_Boopsi_TagScreen               = $8042bc71 /* V4  isg ULONG             */
CONST MUIA_Boopsi_TagWindow               = $8042e11d /* V4  isg ULONG             */



/****************************************************************************/
/** Prop                                                                   **/
/****************************************************************************/

#define MUIC_Prop 'Prop.mui'

/* Methods */

CONST MUIM_Prop_Decrease                  = $80420dd1 /* V16 */
CONST MUIM_Prop_Increase                  = $8042cac0 /* V16 */

/* Attributes */

CONST MUIA_Prop_Entries                   = $8042fbdb /* V4  isg LONG              */
CONST MUIA_Prop_First                     = $8042d4b2 /* V4  isg LONG              */
CONST MUIA_Prop_Horiz                     = $8042f4f3 /* V4  i.g BOOL              */
CONST MUIA_Prop_Slider                    = $80429c3a /* V4  isg BOOL              */
CONST MUIA_Prop_UseWinBorder              = $8042deee /* V13 i.. LONG              */
CONST MUIA_Prop_Visible                   = $8042fea6 /* V4  isg LONG              */

CONST MUIV_Prop_UseWinBorder_None   = 0
CONST MUIV_Prop_UseWinBorder_Left   = 1
CONST MUIV_Prop_UseWinBorder_Right  = 2
CONST MUIV_Prop_UseWinBorder_Bottom = 3


/****************************************************************************/
/** Gauge                                                                  **/
/****************************************************************************/

#define MUIC_Gauge 'Gauge.mui'

/* Attributes */

CONST MUIA_Gauge_Current                  = $8042f0dd /* V4  isg LONG              */
CONST MUIA_Gauge_Divide                   = $8042d8df /* V4  isg BOOL              */
CONST MUIA_Gauge_Horiz                    = $804232dd /* V4  i.. BOOL              */
CONST MUIA_Gauge_InfoText                 = $8042bf15 /* V7  isg STRPTR            */
CONST MUIA_Gauge_Max                      = $8042bcdb /* V4  isg LONG              */



/****************************************************************************/
/** Scale                                                                  **/
/****************************************************************************/

#define MUIC_Scale 'Scale.mui'

/* Attributes */

CONST MUIA_Scale_Horiz                    = $8042919a /* V4  isg BOOL              */



/****************************************************************************/
/** Colorfield                                                             **/
/****************************************************************************/

#define MUIC_Colorfield 'Colorfield.mui'

/* Attributes */

CONST MUIA_Colorfield_Blue                = $8042d3b0 /* V4  isg ULONG             */
CONST MUIA_Colorfield_Green               = $80424466 /* V4  isg ULONG             */
CONST MUIA_Colorfield_Pen                 = $8042713a /* V4  ..g ULONG             */
CONST MUIA_Colorfield_Red                 = $804279f6 /* V4  isg ULONG             */
CONST MUIA_Colorfield_RGB                 = $8042677a /* V4  isg ULONG *           */



/****************************************************************************/
/** List                                                                   **/
/****************************************************************************/

#define MUIC_List 'List.mui'

/* Methods */

CONST MUIM_List_Clear                = $8042ad89 /* V4  */
CONST MUIM_List_CreateImage          = $80429804 /* V11 */
CONST MUIM_List_DeleteImage          = $80420f58 /* V11 */
CONST MUIM_List_Exchange             = $8042468c /* V4  */
CONST MUIM_List_GetEntry             = $804280ec /* V4  */
CONST MUIM_List_Insert               = $80426c87 /* V4  */
CONST MUIM_List_InsertSingle         = $804254d5 /* V7  */
CONST MUIM_List_Jump                 = $8042baab /* V4  */
CONST MUIM_List_Move                 = $804253c2 /* V9  */
CONST MUIM_List_NextSelected         = $80425f17 /* V6  */
CONST MUIM_List_Redraw               = $80427993 /* V4  */
CONST MUIM_List_Remove               = $8042647e /* V4  */
CONST MUIM_List_Select               = $804252d8 /* V4  */
CONST MUIM_List_Sort                 = $80422275 /* V4  */
CONST MUIM_List_TestPos              = $80425f48 /* V11 */
CONST MUIM_List_Compare            = $80421b68 /* V20 */
CONST MUIM_List_Construct          = $8042d662 /* V20 */
CONST MUIM_List_Destruct           = $80427d51 /* V20 */
CONST MUIM_List_Display            = $80425377 /* V20 */

/* Attributes */

CONST MUIA_List_Active                    = $8042391c /* V4  isg LONG              */
CONST MUIA_List_AdjustHeight              = $8042850d /* V4  i.. BOOL              */
CONST MUIA_List_AdjustWidth               = $8042354a /* V4  i.. BOOL              */
CONST MUIA_List_AutoVisible               = $8042a445 /* V11 isg BOOL              */
CONST MUIA_List_CompareHook               = $80425c14 /* V4  is. struct Hook *     */
CONST MUIA_List_ConstructHook             = $8042894f /* V4  is. struct Hook *     */
CONST MUIA_List_DestructHook              = $804297ce /* V4  is. struct Hook *     */
CONST MUIA_List_DisplayHook               = $8042b4d5 /* V4  is. struct Hook *     */
CONST MUIA_List_DragSortable              = $80426099 /* V11 isg BOOL              */
CONST MUIA_List_DropMark                  = $8042aba6 /* V11 ..g LONG              */
CONST MUIA_List_Entries                   = $80421654 /* V4  ..g LONG              */
CONST MUIA_List_First                     = $804238d4 /* V4  ..g LONG              */
CONST MUIA_List_Format                    = $80423c0a /* V4  isg STRPTR            */
CONST MUIA_List_InsertPosition            = $8042d0cd /* V9  ..g LONG              */
CONST MUIA_List_MinLineHeight             = $8042d1c3 /* V4  i.. LONG              */
CONST MUIA_List_MultiTestHook             = $8042c2c6 /* V4  is. struct Hook *     */
CONST MUIA_List_Pool                      = $80423431 /* V13 i.. APTR              */
CONST MUIA_List_PoolPuddleSize            = $8042a4eb /* V13 i.. ULONG             */
CONST MUIA_List_PoolThreshSize            = $8042c48c /* V13 i.. ULONG             */
CONST MUIA_List_Quiet                     = $8042d8c7 /* V4  .s. BOOL              */
CONST MUIA_List_ShowDropMarks             = $8042c6f3 /* V11 isg BOOL              */
CONST MUIA_List_SourceArray               = $8042c0a0 /* V4  i.. APTR              */
CONST MUIA_List_Title                     = $80423e66 /* V6  isg char *            */
CONST MUIA_List_Visible                   = $8042191f /* V4  ..g LONG              */
CONST MUIA_List_AgainClick                = $804214c2 /* V20 i.g BOOL              */
CONST MUIA_List_TitleClick                = $80422fd9 /* V20 ..g LONG              */
CONST MUIA_List_DoubleClick               = $80424635 /* V4  i.g BOOL              */
CONST MUIA_List_DragType                  = $80425cd3 /* V11 isg LONG              */
CONST MUIA_List_MultiSelect               = $80427e08 /* V7  i.. LONG              */

CONST MUIV_List_Active_Off = -1
CONST MUIV_List_Active_Top = -2
CONST MUIV_List_Active_Bottom = -3
CONST MUIV_List_Active_Up = -4
CONST MUIV_List_Active_Down = -5
CONST MUIV_List_Active_PageUp = -6
CONST MUIV_List_Active_PageDown = -7
CONST MUIV_List_ConstructHook_String = -1
CONST MUIV_List_DestructHook_String = -1
->CONST MUIV_List_CopyHook_String      = -1
->CONST MUIV_List_CursorType_None      =  0
->CONST MUIV_List_CursorType_Bar       =  1
->CONST MUIV_List_CursorType_Rect      =  2
-> new in 4.0
CONST MUIV_List_DragType_None = 0
CONST MUIV_List_DragType_Immediate = 1
CONST MUIV_List_MultiSelect_None = 0
CONST MUIV_List_MultiSelect_Default = 1
CONST MUIV_List_MultiSelect_Shifted = 2
CONST MUIV_List_MultiSelect_Always = 3
CONST MUIV_List_ScrollerPos_Default = 0
CONST MUIV_List_ScrollerPos_Left = 1
CONST MUIV_List_ScrollerPos_Right = 2
CONST MUIV_List_ScrollerPos_None = 3


/****************************************************************************/
/** Floattext                                                              **/
/****************************************************************************/

#define MUIC_Floattext 'Floattext.mui'

/* Attributes */

CONST MUIA_Floattext_Justify              = $8042dc03 /* V4  isg BOOL              */
CONST MUIA_Floattext_SkipChars            = $80425c7d /* V4  is. STRPTR            */
CONST MUIA_Floattext_TabSize              = $80427d17 /* V4  is. LONG              */
CONST MUIA_Floattext_Text                 = $8042d16a /* V4  isg STRPTR            */



/****************************************************************************/
/** Volumelist                                                             **/
/****************************************************************************/

#define MUIC_Volumelist 'Volumelist.mui'

/* Attributes */
#define MUIA_Volumelist_ExampleMode         0x804246a5 /* V20 i.. BOOL              */

/****************************************************************************/
/** Scrmodelist                                                            **/
/****************************************************************************/

#define MUIC_Scrmodelist 'Scrmodelist.mui'

/* Attributes */




/****************************************************************************/
/** Dirlist                                                                **/
/****************************************************************************/

#define MUIC_Dirlist 'Dirlist.mui'

/* Methods */

CONST MUIM_Dirlist_ReRead            = $80422d71 /* V4  */

/* Attributes */

CONST MUIA_Dirlist_AcceptPattern          = $8042760a /* V4  is. STRPTR            */
CONST MUIA_Dirlist_Directory              = $8042ea41 /* V4  isg STRPTR            */
CONST MUIA_Dirlist_DrawersOnly            = $8042b379 /* V4  is. BOOL              */
CONST MUIA_Dirlist_FilesOnly              = $8042896a /* V4  is. BOOL              */
CONST MUIA_Dirlist_FilterDrawers          = $80424ad2 /* V4  is. BOOL              */
CONST MUIA_Dirlist_FilterHook             = $8042ae19 /* V4  is. struct Hook *     */
CONST MUIA_Dirlist_MultiSelDirs           = $80428653 /* V6  is. BOOL              */
CONST MUIA_Dirlist_NumBytes               = $80429e26 /* V4  ..g LONG              */
CONST MUIA_Dirlist_NumDrawers             = $80429cb8 /* V4  ..g LONG              */
CONST MUIA_Dirlist_NumFiles               = $8042a6f0 /* V4  ..g LONG              */
CONST MUIA_Dirlist_Path                   = $80426176 /* V4  ..g STRPTR            */
CONST MUIA_Dirlist_RejectIcons            = $80424808 /* V4  is. BOOL              */
CONST MUIA_Dirlist_RejectPattern          = $804259c7 /* V4  is. STRPTR            */
CONST MUIA_Dirlist_SortDirs               = $8042bbb9 /* V4  is. LONG              */
CONST MUIA_Dirlist_SortHighLow            = $80421896 /* V4  is. BOOL              */
CONST MUIA_Dirlist_SortType               = $804228bc /* V4  is. LONG              */
CONST MUIA_Dirlist_Status                 = $804240de /* V4  ..g LONG              */
CONST MUIA_Dirlist_ExAllType              = $8042cd7c /* V20 i.g ULONG             */

CONST MUIV_Dirlist_SortDirs_First = 0
CONST MUIV_Dirlist_SortDirs_Last = 1
CONST MUIV_Dirlist_SortDirs_Mix = 2
CONST MUIV_Dirlist_SortType_Name = 0
CONST MUIV_Dirlist_SortType_Date = 1
CONST MUIV_Dirlist_SortType_Size = 2

-> new in 4.0
CONST MUIV_Dirlist_SortType_Comment = 3
CONST MUIV_Dirlist_SortType_Flags = 4
CONST MUIV_Dirlist_SortType_Type = 5
CONST MUIV_Dirlist_SortType_Used = 6
CONST MUIV_Dirlist_SortType_Count = 7

CONST MUIV_Dirlist_Status_Invalid = 0
CONST MUIV_Dirlist_Status_Reading = 1
CONST MUIV_Dirlist_Status_Valid = 2

-> new in 4.0
/****************************************************************************/
/** Selectgroup                                                            **/
/****************************************************************************/

#define MUIC_Selectgroup 'Selectgroup.mui'

-> new in 4.0
/****************************************************************************/
/** Argstring                                                              **/
/****************************************************************************/

#define MUIC_Argstring 'Argstring.mui'

/* Methods */


/* Attributes */

CONST MUIA_Argstring_Contents             = $80429456 /* V20 isg STRPTR            */
CONST MUIA_Argstring_Template             = $80422904 /* V20 isg STRPTR            */


/****************************************************************************/
/** Numeric                                                                **/
/****************************************************************************/

#define MUIC_Numeric 'Numeric.mui'

/* Methods */

CONST MUIM_Numeric_Decrease          = $804243a7 /* V11 */
CONST MUIM_Numeric_Increase          = $80426ecd /* V11 */
CONST MUIM_Numeric_ScaleToValue      = $8042032c /* V11 */
CONST MUIM_Numeric_SetDefault        = $8042ab0a /* V11 */
CONST MUIM_Numeric_Stringify         = $80424891 /* V11 */
CONST MUIM_Numeric_ValueToScale      = $80423e4f /* V11 */

/* Attributes */

CONST MUIA_Numeric_CheckAllSizes          = $80421594 /* V11 isg BOOL              */
CONST MUIA_Numeric_Default                = $804263e8 /* V11 isg LONG              */
CONST MUIA_Numeric_Format                 = $804263e9 /* V11 isg STRPTR            */
CONST MUIA_Numeric_Max                    = $8042d78a /* V11 isg LONG              */
CONST MUIA_Numeric_Min                    = $8042e404 /* V11 isg LONG              */
CONST MUIA_Numeric_Reverse                = $8042f2a0 /* V11 isg BOOL              */
CONST MUIA_Numeric_RevLeftRight           = $804294a7 /* V11 isg BOOL              */
CONST MUIA_Numeric_RevUpDown              = $804252dd /* V11 isg BOOL              */
CONST MUIA_Numeric_Value                  = $8042ae3a /* V11 isg LONG              */



/****************************************************************************/
/** Framedisplay                                                           **/
/****************************************************************************/

#define MUIC_Framedisplay 'Framedisplay.mui'

/* Attributes */




/****************************************************************************/
/** Popframe                                                               **/
/****************************************************************************/

#define MUIC_Popframe 'Popframe.mui'


/****************************************************************************/
/** Imagedisplay                                                           **/
/****************************************************************************/

#define MUIC_Imagedisplay 'Imagedisplay.mui'

/* Attributes */




/****************************************************************************/
/** Popimage                                                               **/
/****************************************************************************/

#define MUIC_Popimage 'Popimage.mui'


/****************************************************************************/
/** Pendisplay                                                             **/
/****************************************************************************/

#define MUIC_Pendisplay 'Pendisplay.mui'

/* Methods */

CONST MUIM_Pendisplay_SetColormap         = $80426c80 /* V13 */
CONST MUIM_Pendisplay_SetMUIPen           = $8042039d /* V13 */
CONST MUIM_Pendisplay_SetRGB              = $8042c131 /* V13 */

/* Attributes */

CONST MUIA_Pendisplay_Pen                 = $8042a748 /* V13 ..g Object *          */
CONST MUIA_Pendisplay_Reference           = $8042dc24 /* V13 isg Object *          */
CONST MUIA_Pendisplay_RGBcolor            = $8042a1a9 /* V11 isg struct MUI_RBBcolor * */
CONST MUIA_Pendisplay_Spec                = $8042a204 /* V11 isg struct MUI_PenSpec  * */



/****************************************************************************/
/** Poppen                                                                 **/
/****************************************************************************/

#define MUIC_Poppen 'Poppen.mui'


/****************************************************************************/
/** Knob                                                                   **/
/****************************************************************************/

#define MUIC_Knob 'Knob.mui'


/****************************************************************************/
/** Levelmeter                                                             **/
/****************************************************************************/

#define MUIC_Levelmeter 'Levelmeter.mui'

/* Attributes */

CONST MUIA_Levelmeter_Label               = $80420dd5 /* V11 isg STRPTR            */



/****************************************************************************/
/** Numericbutton                                                          **/
/****************************************************************************/

#define MUIC_Numericbutton 'Numericbutton.mui'


/****************************************************************************/
/** Slider                                                                 **/
/****************************************************************************/

#define MUIC_Slider 'Slider.mui'

/* Attributes */

CONST MUIA_Slider_Horiz                   = $8042fad1 /* V11 isg BOOL              */
CONST MUIA_Slider_Level                   = $8042ae3a /* V4  isg LONG              */
CONST MUIA_Slider_Max                     = $8042d78a /* V4  isg LONG              */
CONST MUIA_Slider_Min                     = $8042e404 /* V4  isg LONG              */
CONST MUIA_Slider_Quiet                   = $80420b26 /* V6  i.. BOOL              */
CONST MUIA_Slider_Reverse                 = $8042f2a0 /* V4  isg BOOL              */



/****************************************************************************/
/** Group                                                                  **/
/****************************************************************************/

#define MUIC_Group 'Group.mui'

/* Methods */

CONST MUIM_Group_ExitChange          = $8042d1cc /* V11 */
CONST MUIM_Group_InitChange          = $80420887 /* V11 */
CONST MUIM_Group_Sort                = $80427417 /* V4  */
CONST MUIM_Group_MoveMember          = $8042ff4e /* V16 */

/* Attributes */

CONST MUIA_Group_ActivePage               = $80424199 /* V5  isg LONG              */
CONST MUIA_Group_Child                    = $804226e6 /* V4  i.. Object *          */
CONST MUIA_Group_ChildList                = $80424748 /* V4  ..g struct List *     */
CONST MUIA_Group_Columns                  = $8042f416 /* V4  is. LONG              */
CONST MUIA_Group_Horiz                    = $8042536b /* V4  i.. BOOL              */
CONST MUIA_Group_HorizSpacing             = $8042c651 /* V4  is. LONG              */
CONST MUIA_Group_LayoutHook               = $8042c3b2 /* V11 i.. struct Hook *     */
CONST MUIA_Group_PageMode                 = $80421a5f /* V5  i.. BOOL              */
CONST MUIA_Group_Rows                     = $8042b68f /* V4  is. LONG              */
CONST MUIA_Group_SameHeight               = $8042037e /* V4  i.. BOOL              */
CONST MUIA_Group_SameSize                 = $80420860 /* V4  i.. BOOL              */
CONST MUIA_Group_SameWidth                = $8042b3ec /* V4  i.. BOOL              */
CONST MUIA_Group_Spacing                  = $8042866d /* V4  is. LONG              */
CONST MUIA_Group_VertSpacing              = $8042e1bf /* V4  is. LONG              */
CONST MUIA_Group_HorizCenter              = $8042cc64 /* V20 isg LONG              */
CONST MUIA_Group_VertCenter               = $8042c008 /* V20 isg LONG              */

CONST MUIV_Group_ActivePage_First   =  0
CONST MUIV_Group_ActivePage_Last    = -1
CONST MUIV_Group_ActivePage_Prev    = -2
CONST MUIV_Group_ActivePage_Next    = -3
CONST MUIV_Group_ActivePage_Advance = -4

-> new in 4.0
CONST MUIV_Group_Spacing_Default = -100
#define MUIV_Group_Spacing_Percent(p) (-(p))


/****************************************************************************/
/** Mccprefs                                                               **/
/****************************************************************************/

#define MUIC_Mccprefs 'Mccprefs.mui'

/* Attributes */

CONST MUIM_Mccprefs_RegisterGadget        = $80424828 /* V20 */

/****************************************************************************/
/** Register                                                               **/
/****************************************************************************/

#define MUIC_Register 'Register.mui'

/* Attributes */

CONST MUIA_Register_Frame                 = $8042349b /* V7  i.g BOOL              */
CONST MUIA_Register_Titles                = $804297ec /* V7  i.g STRPTR *          */

-> new in 4.0
CONST MUIV_Register_Titles_UData = -1

/****************************************************************************/
/** Settingsgroup                                                          **/
/****************************************************************************/

#define MUIC_Settingsgroup 'Settingsgroup.mui'

/* Methods */

CONST MUIM_Settingsgroup_ConfigToGadgets  = $80427043 /* V11 */
CONST MUIM_Settingsgroup_GadgetsToConfig  = $80425242 /* V11 */

/* Attributes */




/****************************************************************************/
/** Settings                                                               **/
/****************************************************************************/

#define MUIC_Settings 'Settings.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Frameadjust                                                            **/
/****************************************************************************/

#define MUIC_Frameadjust 'Frameadjust.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Penadjust                                                              **/
/****************************************************************************/

#define MUIC_Penadjust 'Penadjust.mui'

/* Methods */


/* Attributes */

CONST MUIA_Penadjust_PSIMode              = $80421cbb /* V11 i.. BOOL              */



/****************************************************************************/
/** Imageadjust                                                            **/
/****************************************************************************/

#define MUIC_Imageadjust 'Imageadjust.mui'

/* Methods */


/* Attributes */


CONST MUIV_Imageadjust_Type_All = 0
CONST MUIV_Imageadjust_Type_Image = 1
CONST MUIV_Imageadjust_Type_Background = 2
CONST MUIV_Imageadjust_Type_Pen = 3


/****************************************************************************/
/** Virtgroup                                                              **/
/****************************************************************************/

#define MUIC_Virtgroup 'Virtgroup.mui'

/* Methods */


/* Attributes */

CONST MUIA_Virtgroup_Height               = $80423038 /* V6  ..g LONG              */
CONST MUIA_Virtgroup_Input                = $80427f7e /* V11 i.. BOOL              */
CONST MUIA_Virtgroup_Left                 = $80429371 /* V6  isg LONG              */
CONST MUIA_Virtgroup_Top                  = $80425200 /* V6  isg LONG              */
CONST MUIA_Virtgroup_Width                = $80427c49 /* V6  ..g LONG              */



/****************************************************************************/
/** Scrollgroup                                                            **/
/****************************************************************************/

#define MUIC_Scrollgroup 'Scrollgroup.mui'

/* Methods */


/* Attributes */

CONST MUIA_Scrollgroup_Contents           = $80421261 /* V4  i.. Object *          */
CONST MUIA_Scrollgroup_FreeHoriz          = $804292f3 /* V9  i.. BOOL              */
CONST MUIA_Scrollgroup_FreeVert           = $804224f2 /* V9  i.. BOOL              */
CONST MUIA_Scrollgroup_HorizBar           = $8042b63d /* V16 ..g Object *          */
CONST MUIA_Scrollgroup_UseWinBorder       = $804284c1 /* V13 i.. BOOL              */
CONST MUIA_Scrollgroup_VertBar            = $8042cdc0 /* V16 ..g Object *          */
CONST MUIA_Scrollgroup_AutoBars           = $8042f50e /* V20 isg BOOL              */



/****************************************************************************/
/** Scrollbar                                                              **/
/****************************************************************************/

#define MUIC_Scrollbar 'Scrollbar.mui'

/* Attributes */

CONST MUIA_Scrollbar_Type                 = $8042fb6b /* V11 i.. LONG              */

CONST MUIV_Scrollbar_Type_Default = 0
CONST MUIV_Scrollbar_Type_Bottom = 1
CONST MUIV_Scrollbar_Type_Top = 2
CONST MUIV_Scrollbar_Type_Sym = 3


/****************************************************************************/
/** Listview                                                               **/
/****************************************************************************/

#define MUIC_Listview 'Listview.mui'

/* Attributes */

CONST MUIA_Listview_ClickColumn           = $8042d1b3 /* V7  ..g LONG              */
CONST MUIA_Listview_DefClickColumn        = $8042b296 /* V7  isg LONG              */
CONST MUIA_Listview_DoubleClick           = $80424635 /* V4  i.g BOOL              */
CONST MUIA_Listview_DragType              = $80425cd3 /* V11 isg LONG              */
CONST MUIA_Listview_Input                 = $8042682d /* V4  i.. BOOL              */
CONST MUIA_Listview_List                  = $8042bcce /* V4  i.g Object *          */
CONST MUIA_Listview_MultiSelect           = $80427e08 /* V7  i.. LONG              */
CONST MUIA_Listview_ScrollerPos           = $8042b1b4 /* V10 i.. BOOL              */
CONST MUIA_Listview_SelectChange          = $8042178f /* V4  ..g BOOL              */
CONST MUIA_Listview_AgainClick            = $804214c2 /* V20 i.g BOOL              */

CONST MUIV_Listview_DragType_None = 0
CONST MUIV_Listview_DragType_Immediate = 1
CONST MUIV_Listview_MultiSelect_None = 0
CONST MUIV_Listview_MultiSelect_Default = 1
CONST MUIV_Listview_MultiSelect_Shifted = 2
CONST MUIV_Listview_MultiSelect_Always = 3
CONST MUIV_Listview_ScrollerPos_Default = 0
CONST MUIV_Listview_ScrollerPos_Left = 1
CONST MUIV_Listview_ScrollerPos_Right = 2
CONST MUIV_Listview_ScrollerPos_None = 3

-> new in 4.0 ?
/****************************************************************************/
/** Pubscreenlist                                                          **/
/****************************************************************************/

#define MUIC_Pubscreenlist 'Pubscreenlist.mui'

/* Methods */


/* Attributes */

CONST MUIA_Pubscreenlist_Selection        = $8042fe58 /* V20 ..g STRPTR            */



/****************************************************************************/
/** Radio                                                                  **/
/****************************************************************************/

#define MUIC_Radio 'Radio.mui'

/* Attributes */

CONST MUIA_Radio_Active                   = $80429b41 /* V4  isg LONG              */
CONST MUIA_Radio_Entries                  = $8042b6a1 /* V4  i.. STRPTR *          */



/****************************************************************************/
/** Cycle                                                                  **/
/****************************************************************************/

#define MUIC_Cycle 'Cycle.mui'

/* Attributes */

CONST MUIA_Cycle_Active                   = $80421788 /* V4  isg LONG              */
CONST MUIA_Cycle_Entries                  = $80420629 /* V4  i.. STRPTR *          */

CONST MUIV_Cycle_Active_Next = -1
CONST MUIV_Cycle_Active_Prev = -2


/****************************************************************************/
/** Coloradjust                                                            **/
/****************************************************************************/

#define MUIC_Coloradjust 'Coloradjust.mui'

/* Attributes */

CONST MUIA_Coloradjust_Blue               = $8042b8a3 /* V4  isg ULONG             */
CONST MUIA_Coloradjust_Green              = $804285ab /* V4  isg ULONG             */
CONST MUIA_Coloradjust_ModeID             = $8042ec59 /* V4  isg ULONG             */
CONST MUIA_Coloradjust_Red                = $80420eaa /* V4  isg ULONG             */
CONST MUIA_Coloradjust_RGB                = $8042f899 /* V4  isg ULONG *           */



/****************************************************************************/
/** Palette                                                                **/
/****************************************************************************/

#define MUIC_Palette 'Palette.mui'

/* Attributes */

CONST MUIA_Palette_Entries                = $8042a3d8 /* V6  i.g struct MUI_Palette_Entry * */
CONST MUIA_Palette_Groupable              = $80423e67 /* V6  isg BOOL              */
CONST MUIA_Palette_Names                  = $8042c3a2 /* V6  isg char **           */



/****************************************************************************/
/** Popstring                                                              **/
/****************************************************************************/

#define MUIC_Popstring 'Popstring.mui'

/* Methods */

CONST MUIM_Popstring_Close           = $8042dc52 /* V7  */
CONST MUIM_Popstring_Open            = $804258ba /* V7  */

/* Attributes */

CONST MUIA_Popstring_Button               = $8042d0b9 /* V7  i.g Object *          */
CONST MUIA_Popstring_CloseHook            = $804256bf /* V7  isg struct Hook *     */
CONST MUIA_Popstring_OpenHook             = $80429d00 /* V7  isg struct Hook *     */
CONST MUIA_Popstring_String               = $804239ea /* V7  i.g Object *          */
CONST MUIA_Popstring_Toggle               = $80422b7a /* V7  isg BOOL              */



/****************************************************************************/
/** Popobject                                                              **/
/****************************************************************************/

#define MUIC_Popobject 'Popobject.mui'

/* Attributes */

CONST MUIA_Popobject_Follow               = $80424cb5 /* V7  isg BOOL              */
CONST MUIA_Popobject_Light                = $8042a5a3 /* V7  isg BOOL              */
CONST MUIA_Popobject_Object               = $804293e3 /* V7  i.g Object *          */
CONST MUIA_Popobject_ObjStrHook           = $8042db44 /* V7  isg struct Hook *     */
CONST MUIA_Popobject_StrObjHook           = $8042fbe1 /* V7  isg struct Hook *     */
CONST MUIA_Popobject_Volatile             = $804252ec /* V7  isg BOOL              */
CONST MUIA_Popobject_WindowHook           = $8042f194 /* V9  isg struct Hook *     */



/****************************************************************************/
/** Poplist                                                                **/
/****************************************************************************/

#define MUIC_Poplist 'Poplist.mui'

/* Attributes */

CONST MUIA_Poplist_Array                  = $8042084c /* V8  i.. char **           */



/****************************************************************************/
/** Popscreen                                                              **/
/****************************************************************************/

#define MUIC_Popscreen 'Popscreen.mui'

/* Attributes */




/****************************************************************************/
/** Popasl                                                                 **/
/****************************************************************************/

#define MUIC_Popasl 'Popasl.mui'

/* Attributes */

CONST MUIA_Popasl_Active                  = $80421b37 /* V7  ..g BOOL              */
CONST MUIA_Popasl_StartHook               = $8042b703 /* V7  isg struct Hook *     */
CONST MUIA_Popasl_StopHook                = $8042d8d2 /* V7  isg struct Hook *     */
CONST MUIA_Popasl_Type                    = $8042df3d /* V7  i.g ULONG             */



/****************************************************************************/
/** Semaphore                                                              **/
/****************************************************************************/

#define MUIC_Semaphore 'Semaphore.mui'

/* Methods */

CONST MUIM_Semaphore_Attempt         = $80426ce2 /* V11 */
CONST MUIM_Semaphore_AttemptShared   = $80422551 /* V11 */
CONST MUIM_Semaphore_Obtain          = $804276f0 /* V11 */
CONST MUIM_Semaphore_ObtainShared    = $8042ea02 /* V11 */
CONST MUIM_Semaphore_Release         = $80421f2d /* V11 */


/****************************************************************************/
/** Applist                                                                **/
/****************************************************************************/

#define MUIC_Applist 'Applist.mui'

/* Methods */



/****************************************************************************/
/** Cclist                                                                 **/
/****************************************************************************/

#define MUIC_Cclist 'Cclist.mui'

/* Methods */



/****************************************************************************/
/** Dataspace                                                              **/
/****************************************************************************/

#define MUIC_Dataspace 'Dataspace.mui'

/* Methods */

CONST MUIM_Dataspace_Add             = $80423366 /* V11 */
CONST MUIM_Dataspace_Clear           = $8042b6c9 /* V11 */
CONST MUIM_Dataspace_Find            = $8042832c /* V11 */
CONST MUIM_Dataspace_Merge           = $80423e2b /* V11 */
CONST MUIM_Dataspace_ReadIFF         = $80420dfb /* V11 */
CONST MUIM_Dataspace_Remove          = $8042dce1 /* V11 */
CONST MUIM_Dataspace_WriteIFF        = $80425e8e /* V11 */

/* Attributes */

CONST MUIA_Dataspace_Pool                 = $80424cf9 /* V11 i.. APTR              */


/****************************************************************************/
/** Screenspace                                                            **/
/****************************************************************************/

#define MUIC_Screenspace 'Screenspace.mui'

/* Methods */



/****************************************************************************/
/** Rootgrp                                                                **/
/****************************************************************************/

#define MUIC_Rootgrp 'Rootgrp.mui'


/****************************************************************************/
/** Audiocontrols                                                          **/
/****************************************************************************/

#define MUIC_Audiocontrols 'Audiocontrols.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Audiomixer                                                             **/
/****************************************************************************/

#define MUIC_Audiomixer 'Audiomixer.mui'

/* Attributes */


/****************************************************************************/
/** Configdata                                                             **/
/****************************************************************************/

#define MUIC_Configdata 'Configdata.mui'

/* Methods */


/* Attributes */


/****************************************************************************/
/** Panel                                                                  **/
/****************************************************************************/

#define MUIC_Panel 'Panel.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Filepanel                                                              **/
/****************************************************************************/

#define MUIC_Filepanel 'Filepanel.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Fontpanel                                                              **/
/****************************************************************************/

#define MUIC_Fontpanel 'Fontpanel.mui'

/* Methods */



/****************************************************************************/
/** Screenmodepanel                                                        **/
/****************************************************************************/

#define MUIC_Screenmodepanel 'Screenmodepanel.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Dtpic                                                                  **/
/****************************************************************************/

#define MUIC_Dtpic 'Dtpic.mui'

/* Attributes */
CONST MUIA_Dtpic_Name                     = $80423d72 /* V18 isg STRPTR            */


-> 4.0
/****************************************************************************/
/** Keyadjust                                                              **/
/****************************************************************************/

#define MUIC_Keyadjust 'Keyadjust.mui'

/* Methods */


/* Attributes */

CONST MUIA_Keyadjust_AllowMouseEvents     = $8042b61c /* V20 isg BOOL              */
CONST MUIA_Keyadjust_Key                  = $8042e161 /* V20 isg STRPTR            */


-> 4.0
/****************************************************************************/
/** Imagebrowser                                                           **/
/****************************************************************************/

#define MUIC_Imagebrowser 'Imagebrowser.mui'

/* Methods */


/* Attributes */



-> 4.0
/****************************************************************************/
/** Colorring                                                              **/
/****************************************************************************/

#define MUIC_Colorring 'Colorring.mui'

/* Methods */


/* Attributes */


-> 4.0
/****************************************************************************/
/** Process                                                                **/
/****************************************************************************/

#define MUIC_Process 'Process.mui'

/* Methods */

CONST MUIM_Process_Kill                   = $804264cf /* V20 */
CONST MUIM_Process_Process                = $804230aa /* V20 */
CONST MUIM_Process_Signal                 = $8042e791 /* V20 */

/* Attributes */

CONST MUIA_Process_SourceClass            = $8042cf8b /* V20 i.. ULONG             */
CONST MUIA_Process_SourceObject           = $804212a2 /* V20 i.. ULONG             */


-> 4.0
/****************************************************************************/
/** Aboutpage                                                              **/
/****************************************************************************/

#define MUIC_Aboutpage 'Aboutpage.mui'

/* Methods */




/*** End Of File ***/
