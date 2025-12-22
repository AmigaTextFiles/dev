OPT NATIVE, PREPROCESS, POINTER
PUBLIC MODULE 'target/intuition'  ->so that this is the same as AmigaOS4's corresponding module (which needs it)
MODULE 'target/exec/types', 'target/dos/dos', 'target/intuition/classes', 'target/intuition/screens', 'target/intuition'
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/exec/nodes', 'target/exec/tasks', 'target/utility/hooks', 'target/graphics/rastport', 'target/graphics/text', 'target/intuition/intuition', 'target/intuition/screens', 'target/intuition/classes', 'target/libraries/iffparse', 'target/utility/tagitem'
{#include <libraries/mui.h>}
NATIVE {LIBRARIES_MUI_H} CONST

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


/***************************************************************************
** Library specification
***************************************************************************/

NATIVE {MUIMASTER_NAME}    CONST
#define MUIMASTER_NAME muimaster_name
STATIC muimaster_name    = 'muimaster.library'

NATIVE {MUIMASTER_VMIN}    CONST MUIMASTER_VMIN    = 11
NATIVE {MUIMASTER_VLATEST} CONST MUIMASTER_VLATEST = 19
CONST MUI_TRUE = 1

/*
** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
** Warning, some of the macros in this header file work only with
** muimaster.library V11 and above. If you recompile your programs,
** be sure to open muimaster.library with MUIMASTER_VMIN as version number.
** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/


/* comment this if you dont want to include obsolete identifiers */

NATIVE {MUI_OBSOLETE} CONST
#define MUI_OBSOLETE /* include obsolete identifiers */



/*************************************************************************
** Config items for MUIM_GetConfigItem
*************************************************************************/


NATIVE {MUICFG_PublicScreen}            CONST MUICFG_PublicScreen            = 36




/*************************************************************************
** Black box specification structures for images, pens, frames
*************************************************************************/

NATIVE {MUI_PenSpec} OBJECT mui_penspec
	{buf}	buf[32]	:ARRAY OF CHAR
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

NATIVE {PSD_INITIAL_NAME}   CONST
#define PSD_INITIAL_NAME '(unnamed)'

NATIVE {PSD_INITIAL_TITLE}  CONST
#define PSD_INITIAL_TITLE 'MUI Public Screen'

NATIVE {PSD_ID_MPUB}        CONST PSD_ID_MPUB        = "MPUB"

NATIVE {PSD_NAME_FRONTMOST} CONST
#define PSD_NAME_FRONTMOST '<<Frontmost>>'		->#or '«Frontmost»' in C

NATIVE {PSD_FILENAME_SAVE} CONST
#define PSD_FILENAME_SAVE 'envarc:mui/PublicScreens.iff'

NATIVE {PSD_FILENAME_USE}  CONST
#define PSD_FILENAME_USE 'env:mui/PublicScreens.iff'

NATIVE {PSD_MAXLEN_NAME}         CONST PSD_MAXLEN_NAME         = 32
NATIVE {PSD_MAXLEN_TITLE}       CONST PSD_MAXLEN_TITLE       = 128
NATIVE {PSD_MAXLEN_FONT}         CONST PSD_MAXLEN_FONT         = 48
NATIVE {PSD_MAXLEN_BACKGROUND}  CONST PSD_MAXLEN_BACKGROUND  = 256
NATIVE {PSD_NUMCOLS}              CONST PSD_NUMCOLS              = 8
NATIVE {PSD_MAXSYSPENS}          CONST PSD_MAXSYSPENS          = 20
NATIVE {PSD_NUMSYSPENS}          CONST PSD_NUMSYSPENS          = 12
NATIVE {PSD_MAXMUIPENS}          CONST PSD_MAXMUIPENS          = 10
NATIVE {PSD_NUMMUIPENS}  CONST PSD_NUMMUIPENS  = 8	->MPEN_COUNT

NATIVE {MUI_RGBcolor} OBJECT mui_rgbcolor
	{red}	red	:ULONG
	{green}	green	:ULONG
	{blue}	blue	:ULONG
ENDOBJECT

NATIVE {MUI_PubScreenDesc} OBJECT mui_pubscreendesc
	{Version}	version	:VALUE

	{Name}	name[PSD_MAXLEN_NAME]	:ARRAY OF CHAR
	{Title}	title[PSD_MAXLEN_TITLE]	:ARRAY OF CHAR
	{Font}	font[PSD_MAXLEN_FONT]	:ARRAY OF CHAR
	{Background}	background[PSD_MAXLEN_BACKGROUND]	:ARRAY OF CHAR

	{DisplayID}	displayid	:ULONG

	{DisplayWidth}	displaywidth	:UINT
	{DisplayHeight}	displayheight	:UINT

	{DisplayDepth}	displaydepth	:UBYTE
	{OverscanType}	overscantype	:UBYTE
	{AutoScroll}	autoscroll	:UBYTE
	{NoDrag}	nodrag	:UBYTE
	{Exclusive}	exclusive	:UBYTE
	{Interleaved}	interleaved	:UBYTE
	{SysDefault}	sysdefault	:UBYTE
	{Behind}	behind	:UBYTE
	{AutoClose}	autoclose	:UBYTE
	{CloseGadget}	closegadget	:UBYTE
	{DummyWasForeign}	dummywasforeign	:UBYTE

	{SystemPens}	systempens[PSD_MAXSYSPENS]	:ARRAY OF BYTE
	{Reserved}	reserved[1+7*4-PSD_MAXSYSPENS]	:ARRAY OF UBYTE

	{Palette}	palette[PSD_NUMCOLS]	:ARRAY OF mui_rgbcolor
	{rsvd}	rsvd[PSD_MAXSYSPENS-PSD_NUMCOLS]	:ARRAY OF mui_rgbcolor

	{rsvd2}	rsvd2[PSD_MAXMUIPENS]	:ARRAY OF mui_penspec

	{Changed}	changed	:VALUE
	{UserData}	userdata	:APTR
ENDOBJECT

NATIVE {MUIS_InfoClient} OBJECT muis_infoclient
	{node}	node	:mln
	{task}	task	:PTR TO tc
	{sigbit}	sigbit	:ULONG
ENDOBJECT


/***************************************************************************
** Object Types for MUI_MakeObject()
***************************************************************************/

NATIVE {MUIO_Label}          CONST MUIO_Label          = 1   /* STRPTR label, ULONG flags */
NATIVE {MUIO_Button}         CONST MUIO_Button         = 2   /* STRPTR label */
NATIVE {MUIO_Checkmark}      CONST MUIO_Checkmark      = 3   /* STRPTR label */
NATIVE {MUIO_Cycle}          CONST MUIO_Cycle          = 4   /* STRPTR label, STRPTR *entries */
NATIVE {MUIO_Radio}          CONST MUIO_Radio          = 5   /* STRPTR label, STRPTR *entries */
NATIVE {MUIO_Slider}         CONST MUIO_Slider         = 6   /* STRPTR label, LONG min, LONG max */
NATIVE {MUIO_String}         CONST MUIO_String         = 7   /* STRPTR label, LONG maxlen */
NATIVE {MUIO_PopButton}      CONST MUIO_PopButton      = 8   /* STRPTR imagespec */
NATIVE {MUIO_HSpace}         CONST MUIO_HSpace         = 9   /* LONG space   */
NATIVE {MUIO_VSpace}        CONST MUIO_VSpace        = 10   /* LONG space   */
NATIVE {MUIO_HBar}          CONST MUIO_HBar          = 11   /* LONG space   */
NATIVE {MUIO_VBar}          CONST MUIO_VBar          = 12   /* LONG space   */
NATIVE {MUIO_MenustripNM}   CONST MUIO_MenustripNM   = 13   /* struct NewMenu *nm, ULONG flags */
NATIVE {MUIO_Menuitem}      CONST MUIO_Menuitem      = 14   /* STRPTR label, STRPTR shortcut, ULONG flags, ULONG data  */
NATIVE {MUIO_BarTitle}      CONST MUIO_BarTitle      = 15   /* STRPTR label */
NATIVE {MUIO_NumericButton} CONST MUIO_NumericButton = 16   /* STRPTR label, LONG min, LONG max, STRPTR format */

NATIVE {MUIO_Menuitem_CopyStrings} CONST MUIO_Menuitem_CopyStrings = 1 SHL 30

NATIVE {MUIO_Label_SingleFrame}   CONST MUIO_Label_SingleFrame   = 1 SHL 8
NATIVE {MUIO_Label_DoubleFrame}   CONST MUIO_Label_DoubleFrame   = 1 SHL 9
NATIVE {MUIO_Label_LeftAligned}   CONST MUIO_Label_LeftAligned   = 1 SHL 10
NATIVE {MUIO_Label_Centered}      CONST MUIO_Label_Centered      = 1 SHL 11
NATIVE {MUIO_Label_FreeVert}      CONST MUIO_Label_FreeVert      = 1 SHL 12

NATIVE {MUIO_MenustripNM_CommandKeyCheck} CONST MUIO_MenustripNM_CommandKeyCheck = 1 SHL 0 /* check for "localized" menu items such as "O\0Open" */



/***************************************************************************
** ARexx Interface
***************************************************************************/

NATIVE {MUI_Command} OBJECT mui_command
	{mc_Name}	mc_name	:ARRAY OF CHAR
	{mc_Template}	mc_template	:ARRAY OF CHAR
	{mc_Parameters}	mc_parameters	:VALUE
	{mc_Hook}	mc_hook	:PTR TO hook
	{mc_Reserved}	mc_reserved[5]	:ARRAY OF VALUE
ENDOBJECT

NATIVE {MC_TEMPLATE_ID} CONST MC_TEMPLATE_ID = (NOT 0)!!VALUE!!STRPTR

NATIVE {MUI_RXERR_BADDEFINITION}  CONST MUI_RXERR_BADDEFINITION  = -1
NATIVE {MUI_RXERR_OUTOFMEMORY}    CONST MUI_RXERR_OUTOFMEMORY    = -2
NATIVE {MUI_RXERR_UNKNOWNCOMMAND} CONST MUI_RXERR_UNKNOWNCOMMAND = -3
NATIVE {MUI_RXERR_BADSYNTAX}      CONST MUI_RXERR_BADSYNTAX      = -4


/***************************************************************************
** Return values for MUI_Error()
***************************************************************************/

NATIVE {MUIE_OK}                  CONST MUIE_OK                  = 0
NATIVE {MUIE_OutOfMemory}         CONST MUIE_OutOfMemory         = 1
NATIVE {MUIE_OutOfGfxMemory}      CONST MUIE_OutOfGfxMemory      = 2
NATIVE {MUIE_InvalidWindowObject} CONST MUIE_InvalidWindowObject = 3
NATIVE {MUIE_MissingLibrary}      CONST MUIE_MissingLibrary      = 4
NATIVE {MUIE_NoARexx}             CONST MUIE_NoARexx             = 5
NATIVE {MUIE_SingleTask}          CONST MUIE_SingleTask          = 6



/***************************************************************************
** Standard MUI Images & Backgrounds
***************************************************************************/

NATIVE {MUII_WindowBack}      CONST MUII_WindowBack      = 0   /* These images are configured   */
NATIVE {MUII_RequesterBack}   CONST MUII_RequesterBack   = 1   /* with the preferences program. */
NATIVE {MUII_ButtonBack}      CONST MUII_ButtonBack      = 2
NATIVE {MUII_ListBack}        CONST MUII_ListBack        = 3
NATIVE {MUII_TextBack}        CONST MUII_TextBack        = 4
NATIVE {MUII_PropBack}        CONST MUII_PropBack        = 5
NATIVE {MUII_PopupBack}       CONST MUII_PopupBack       = 6
NATIVE {MUII_SelectedBack}    CONST MUII_SelectedBack    = 7
NATIVE {MUII_ListCursor}      CONST MUII_ListCursor      = 8
NATIVE {MUII_ListSelect}      CONST MUII_ListSelect      = 9
NATIVE {MUII_ListSelCur}     CONST MUII_ListSelCur     = 10
NATIVE {MUII_ArrowUp}        CONST MUII_ArrowUp        = 11
NATIVE {MUII_ArrowDown}      CONST MUII_ArrowDown      = 12
NATIVE {MUII_ArrowLeft}      CONST MUII_ArrowLeft      = 13
NATIVE {MUII_ArrowRight}     CONST MUII_ArrowRight     = 14
NATIVE {MUII_CheckMark}      CONST MUII_CheckMark      = 15
NATIVE {MUII_RadioButton}    CONST MUII_RadioButton    = 16
NATIVE {MUII_Cycle}          CONST MUII_Cycle          = 17
NATIVE {MUII_PopUp}          CONST MUII_PopUp          = 18
NATIVE {MUII_PopFile}        CONST MUII_PopFile        = 19
NATIVE {MUII_PopDrawer}      CONST MUII_PopDrawer      = 20
NATIVE {MUII_PropKnob}       CONST MUII_PropKnob       = 21
NATIVE {MUII_Drawer}         CONST MUII_Drawer         = 22
NATIVE {MUII_HardDisk}       CONST MUII_HardDisk       = 23
NATIVE {MUII_Disk}           CONST MUII_Disk           = 24
NATIVE {MUII_Chip}           CONST MUII_Chip           = 25
NATIVE {MUII_Volume}         CONST MUII_Volume         = 26
NATIVE {MUII_RegisterBack}   CONST MUII_RegisterBack   = 27
NATIVE {MUII_Network}        CONST MUII_Network        = 28
NATIVE {MUII_Assign}         CONST MUII_Assign         = 29
NATIVE {MUII_TapePlay}       CONST MUII_TapePlay       = 30
NATIVE {MUII_TapePlayBack}   CONST MUII_TapePlayBack   = 31
NATIVE {MUII_TapePause}      CONST MUII_TapePause      = 32
NATIVE {MUII_TapeStop}       CONST MUII_TapeStop       = 33
NATIVE {MUII_TapeRecord}     CONST MUII_TapeRecord     = 34
NATIVE {MUII_GroupBack}      CONST MUII_GroupBack      = 35
NATIVE {MUII_SliderBack}     CONST MUII_SliderBack     = 36
NATIVE {MUII_SliderKnob}     CONST MUII_SliderKnob     = 37
NATIVE {MUII_TapeUp}         CONST MUII_TapeUp         = 38
NATIVE {MUII_TapeDown}       CONST MUII_TapeDown       = 39
NATIVE {MUII_PageBack}       CONST MUII_PageBack       = 40
NATIVE {MUII_ReadListBack}   CONST MUII_ReadListBack   = 41
NATIVE {MUII_Count}          CONST MUII_Count          = 42

NATIVE {MUII_BACKGROUND}     CONST MUII_BACKGROUND     = 128    /* These are direct color    */
NATIVE {MUII_SHADOW}         CONST MUII_SHADOW         = 129    /* combinations and are not  */
NATIVE {MUII_SHINE}          CONST MUII_SHINE          = 130    /* affected by users prefs.  */
NATIVE {MUII_FILL}           CONST MUII_FILL           = 131
NATIVE {MUII_SHADOWBACK}     CONST MUII_SHADOWBACK     = 132    /* Generally, you should     */
NATIVE {MUII_SHADOWFILL}     CONST MUII_SHADOWFILL     = 133    /* avoid using them. Better  */
NATIVE {MUII_SHADOWSHINE}    CONST MUII_SHADOWSHINE    = 134    /* use one of the customized */
NATIVE {MUII_FILLBACK}       CONST MUII_FILLBACK       = 135    /* images above.             */
NATIVE {MUII_FILLSHINE}      CONST MUII_FILLSHINE      = 136
NATIVE {MUII_SHINEBACK}      CONST MUII_SHINEBACK      = 137
NATIVE {MUII_FILLBACK2}      CONST MUII_FILLBACK2      = 138
NATIVE {MUII_HSHINEBACK}     CONST MUII_HSHINEBACK     = 139
NATIVE {MUII_HSHADOWBACK}    CONST MUII_HSHADOWBACK    = 140
NATIVE {MUII_HSHINESHINE}    CONST MUII_HSHINESHINE    = 141
NATIVE {MUII_HSHADOWSHADOW}  CONST MUII_HSHADOWSHADOW  = 142
NATIVE {MUII_MARKSHINE}      CONST MUII_MARKSHINE      = 143
NATIVE {MUII_MARKHALFSHINE}  CONST MUII_MARKHALFSHINE  = 144
NATIVE {MUII_MARKBACKGROUND} CONST MUII_MARKBACKGROUND = 145
NATIVE {MUII_LASTPAT}        CONST MUII_LASTPAT        = 145



/***************************************************************************
** Special values for some methods
***************************************************************************/

NATIVE {MUIV_TriggerValue}    CONST MUIV_TriggerValue    = $49893131
NATIVE {MUIV_NotTriggerValue} CONST MUIV_NotTriggerValue = $49893133
NATIVE {MUIV_EveryTime}       CONST MUIV_EveryTime       = $49893131

NATIVE {MUIV_Notify_Self}        CONST MUIV_Notify_Self        = 1
NATIVE {MUIV_Notify_Window}      CONST MUIV_Notify_Window      = 2
NATIVE {MUIV_Notify_Application} CONST MUIV_Notify_Application = 3
NATIVE {MUIV_Notify_Parent}      CONST MUIV_Notify_Parent      = 4

NATIVE {MUIV_Application_Save_ENV}     CONST MUIV_Application_Save_ENV     =      0 !!VALUE!!STRPTR
NATIVE {MUIV_Application_Save_ENVARC}  CONST MUIV_Application_Save_ENVARC  = (NOT 0)!!VALUE!!STRPTR
NATIVE {MUIV_Application_Load_ENV}     CONST MUIV_Application_Load_ENV     = (NOT 0)!!VALUE!!STRPTR
NATIVE {MUIV_Application_Load_ENVARC}  CONST MUIV_Application_Load_ENVARC  = (NOT 0)!!VALUE!!STRPTR

NATIVE {MUIV_Application_ReturnID_Quit} CONST MUIV_Application_ReturnID_Quit = -1

NATIVE {MUIV_List_Insert_Top}             CONST MUIV_List_Insert_Top             = 0
NATIVE {MUIV_List_Insert_Active}         CONST MUIV_List_Insert_Active         = -1
NATIVE {MUIV_List_Insert_Sorted}         CONST MUIV_List_Insert_Sorted         = -2
NATIVE {MUIV_List_Insert_Bottom}         CONST MUIV_List_Insert_Bottom         = -3

NATIVE {MUIV_List_Remove_First}           CONST MUIV_List_Remove_First           = 0
NATIVE {MUIV_List_Remove_Active}         CONST MUIV_List_Remove_Active         = -1
NATIVE {MUIV_List_Remove_Last}           CONST MUIV_List_Remove_Last           = -2
NATIVE {MUIV_List_Remove_Selected}       CONST MUIV_List_Remove_Selected       = -3

NATIVE {MUIV_List_Select_Off}             CONST MUIV_List_Select_Off             = 0
NATIVE {MUIV_List_Select_On}              CONST MUIV_List_Select_On              = 1
NATIVE {MUIV_List_Select_Toggle}          CONST MUIV_List_Select_Toggle          = 2
NATIVE {MUIV_List_Select_Ask}             CONST MUIV_List_Select_Ask             = 3

NATIVE {MUIV_List_GetEntry_Active}       CONST MUIV_List_GetEntry_Active       = -1
NATIVE {MUIV_List_Select_Active}         CONST MUIV_List_Select_Active         = -1
NATIVE {MUIV_List_Select_All}            CONST MUIV_List_Select_All            = -2

NATIVE {MUIV_List_Redraw_Active}         CONST MUIV_List_Redraw_Active         = -1
NATIVE {MUIV_List_Redraw_All}            CONST MUIV_List_Redraw_All            = -2

NATIVE {MUIV_List_Move_Top}               CONST MUIV_List_Move_Top               = 0
NATIVE {MUIV_List_Move_Active}           CONST MUIV_List_Move_Active           = -1
NATIVE {MUIV_List_Move_Bottom}           CONST MUIV_List_Move_Bottom           = -2
NATIVE {MUIV_List_Move_Next}             CONST MUIV_List_Move_Next             = -3 /* only valid for second parameter */
NATIVE {MUIV_List_Move_Previous}         CONST MUIV_List_Move_Previous         = -4 /* only valid for second parameter */

NATIVE {MUIV_List_Exchange_Top}           CONST MUIV_List_Exchange_Top           = 0
NATIVE {MUIV_List_Exchange_Active}       CONST MUIV_List_Exchange_Active       = -1
NATIVE {MUIV_List_Exchange_Bottom}       CONST MUIV_List_Exchange_Bottom       = -2
NATIVE {MUIV_List_Exchange_Next}         CONST MUIV_List_Exchange_Next         = -3 /* only valid for second parameter */
NATIVE {MUIV_List_Exchange_Previous}     CONST MUIV_List_Exchange_Previous     = -4 /* only valid for second parameter */

NATIVE {MUIV_List_Jump_Top}               CONST MUIV_List_Jump_Top               = 0
NATIVE {MUIV_List_Jump_Active}           CONST MUIV_List_Jump_Active           = -1
NATIVE {MUIV_List_Jump_Bottom}           CONST MUIV_List_Jump_Bottom           = -2
NATIVE {MUIV_List_Jump_Up}               CONST MUIV_List_Jump_Up               = -4
NATIVE {MUIV_List_Jump_Down}             CONST MUIV_List_Jump_Down             = -3

NATIVE {MUIV_List_NextSelected_Start}    CONST MUIV_List_NextSelected_Start    = -1
NATIVE {MUIV_List_NextSelected_End}      CONST MUIV_List_NextSelected_End      = -1

NATIVE {MUIV_DragQuery_Refuse} CONST MUIV_DragQuery_Refuse = 0
NATIVE {MUIV_DragQuery_Accept} CONST MUIV_DragQuery_Accept = 1

NATIVE {MUIV_DragReport_Abort}    CONST MUIV_DragReport_Abort    = 0
NATIVE {MUIV_DragReport_Continue} CONST MUIV_DragReport_Continue = 1
NATIVE {MUIV_DragReport_Lock}     CONST MUIV_DragReport_Lock     = 2
NATIVE {MUIV_DragReport_Refresh}  CONST MUIV_DragReport_Refresh  = 3




/***************************************************************************
** Control codes for text strings
***************************************************************************/

NATIVE {MUIX_R} CONST
#define MUIX_R '\er'    /* right justified */

NATIVE {MUIX_C} CONST
#define MUIX_C '\ec'    /* centered        */

NATIVE {MUIX_L} CONST
#define MUIX_L '\el'    /* left justified  */


NATIVE {MUIX_N} CONST
#define MUIX_N '\en'    /* normal     */

NATIVE {MUIX_B} CONST
#define MUIX_B '\eb'    /* bold       */

NATIVE {MUIX_I} CONST
#define MUIX_I '\ei'    /* italic     */

NATIVE {MUIX_U} CONST
#define MUIX_U '\eu'    /* underlined */


NATIVE {MUIX_PT} CONST
#define MUIX_PT '\e2'   /* text pen           */

NATIVE {MUIX_PH} CONST
#define MUIX_PH '\e8'   /* highlight text pen */



/***************************************************************************
** Parameter structures for some classes
***************************************************************************/

NATIVE {MUI_Palette_Entry} OBJECT mui_palette_entry
	{mpe_ID}	mpe_id	:VALUE
	{mpe_Red}	mpe_red	:ULONG
	{mpe_Green}	mpe_green	:ULONG
	{mpe_Blue}	mpe_blue	:ULONG
	{mpe_Group}	mpe_group	:VALUE
ENDOBJECT

NATIVE {MUIV_Palette_Entry_End} CONST MUIV_Palette_Entry_End = -1


/*****************************/
/* Application Input Handler */
/*****************************/

NATIVE {MUI_InputHandlerNode} OBJECT mui_inputhandlernode
	{ihn_Node}	ihn_node	:mln
	{ihn_Object}	ihn_object	:PTR TO INTUIOBJECT

	{ihn_stuff.ihn_sigs}	ihn_signals	:ULONG
	{ihn_stuff.ihn_timer.ihn_millis}	ihn_millis	:UINT
	{ihn_stuff.ihn_timer.ihn_current}	ihn_current	:UINT

	{ihn_Flags}	ihn_flags	:ULONG /* see below */
	{ihn_Method}	ihn_method	:ULONG
ENDOBJECT

->#slight hack to emulate AmigaE module
OBJECT mui_inputhandlernode_timer OF mui_inputhandlernode
ENDOBJECT

NATIVE {ihn_Signals} CONST
NATIVE {ihn_Millis}  CONST
NATIVE {ihn_Current} CONST

/* Flags for ihn_Flags */
NATIVE {MUIIHNF_TIMER} CONST MUIIHNF_TIMER = 1 SHL 0 /* set ihn_Ticks to number of 1/100 sec ticks you want to be triggered */


/************************/
/* Window Event Handler */
/************************/

NATIVE {MUI_EventHandlerNode} OBJECT mui_eventhandlernode
	{ehn_Node}	ehn_node	:mln
	{ehn_Reserved}	ehn_reserved	:BYTE /* don't touch! */
	{ehn_Priority}	ehn_priority	:BYTE /* event handlers are inserted according to their priority. */
	{ehn_Flags}	ehn_flags	:UINT    /* certain flags, see below for definitions. */
	{ehn_Object}	ehn_object	:PTR TO INTUIOBJECT   /* object which should receive MUIM_HandleEvent. */
	{ehn_Class}	ehn_class	:PTR TO iclass    /* if !=NULL, MUIM_HandleEvent is invoked on exactly this class with CoerceMethod(). */
	{ehn_Events}	ehn_events	:ULONG   /* one or more IDCMP flags this handler should react on. */
ENDOBJECT

/* flags for ehn_Flags */
NATIVE {MUI_EHF_ALWAYSKEYS} CONST MUI_EHF_ALWAYSKEYS = 1 SHL 0

/* other values reserved for future use */

/* return values for MUIM_HandleEvent (bit-masked, all other bits must be 0) */
NATIVE {MUI_EventHandlerRC_Eat} CONST MUI_EventHandlerRC_Eat = 1 SHL 0 /* stop MUI from calling other handlers */


/**********************/
/* List Position Test */
/**********************/

NATIVE {MUI_List_TestPos_Result} OBJECT mui_list_testpos_result
	{entry}	entry	:VALUE   /* number of entry, -1 if mouse not over valid entry */
	{column}	column	:INT  /* numer of column, -1 if no valid column */
	{flags}	flags	:UINT   /* see below */
	{xoffset}	xoffset	:INT /* x offset of mouse click relative to column start */
	{yoffset}	yoffset	:INT /* y offset of mouse click from center of line
	                  (negative values mean click was above center,
	                   positive values mean click was below center) */
ENDOBJECT

NATIVE {MUI_LPR_ABOVE}  CONST MUI_LPR_ABOVE  = 1 SHL 0
NATIVE {MUI_LPR_BELOW}  CONST MUI_LPR_BELOW  = 1 SHL 1
NATIVE {MUI_LPR_LEFT}   CONST MUI_LPR_LEFT   = 1 SHL 2
NATIVE {MUI_LPR_RIGHT}  CONST MUI_LPR_RIGHT  = 1 SHL 3


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

NATIVE {MenustripObject}     CONST ->MenustripObject     = MUI_NewObject(MUIC_Menustrip
NATIVE {MenuObject}          CONST ->MenuObject          = MUI_NewObject(MUIC_Menu
NATIVE {MenuObjectT} PROC	->MenuObjectT(name)   MUI_NewObject(MUIC_Menu,MUIA_Menu_Title,name
NATIVE {MenuitemObject}      CONST ->MenuitemObject      = MUI_NewObject(MUIC_Menuitem
NATIVE {WindowObject}        CONST ->WindowObject        = MUI_NewObject(MUIC_Window
NATIVE {ImageObject}         CONST ->ImageObject         = MUI_NewObject(MUIC_Image
NATIVE {BitmapObject}        CONST ->BitmapObject        = MUI_NewObject(MUIC_Bitmap
NATIVE {BodychunkObject}     CONST ->BodychunkObject     = MUI_NewObject(MUIC_Bodychunk
NATIVE {NotifyObject}        CONST ->NotifyObject        = MUI_NewObject(MUIC_Notify
NATIVE {ApplicationObject}   CONST ->ApplicationObject   = MUI_NewObject(MUIC_Application
NATIVE {TextObject}          CONST ->TextObject          = MUI_NewObject(MUIC_Text
NATIVE {RectangleObject}     CONST ->RectangleObject     = MUI_NewObject(MUIC_Rectangle
NATIVE {BalanceObject}       CONST ->BalanceObject       = MUI_NewObject(MUIC_Balance
NATIVE {ListObject}          CONST ->ListObject          = MUI_NewObject(MUIC_List
NATIVE {PropObject}          CONST ->PropObject          = MUI_NewObject(MUIC_Prop
NATIVE {StringObject}        CONST ->StringObject        = MUI_NewObject(MUIC_String
NATIVE {ScrollbarObject}     CONST ->ScrollbarObject     = MUI_NewObject(MUIC_Scrollbar
NATIVE {ListviewObject}      CONST ->ListviewObject      = MUI_NewObject(MUIC_Listview
NATIVE {RadioObject}         CONST ->RadioObject         = MUI_NewObject(MUIC_Radio
NATIVE {VolumelistObject}    CONST ->VolumelistObject    = MUI_NewObject(MUIC_Volumelist
NATIVE {FloattextObject}     CONST ->FloattextObject     = MUI_NewObject(MUIC_Floattext
NATIVE {DirlistObject}       CONST ->DirlistObject       = MUI_NewObject(MUIC_Dirlist
NATIVE {CycleObject}         CONST ->CycleObject         = MUI_NewObject(MUIC_Cycle
NATIVE {GaugeObject}         CONST ->GaugeObject         = MUI_NewObject(MUIC_Gauge
NATIVE {ScaleObject}         CONST ->ScaleObject         = MUI_NewObject(MUIC_Scale
NATIVE {NumericObject}       CONST ->NumericObject       = MUI_NewObject(MUIC_Numeric
NATIVE {SliderObject}        CONST ->SliderObject        = MUI_NewObject(MUIC_Slider
NATIVE {NumericbuttonObject} CONST ->NumericbuttonObject = MUI_NewObject(MUIC_Numericbutton
NATIVE {KnobObject}          CONST ->KnobObject          = MUI_NewObject(MUIC_Knob
NATIVE {LevelmeterObject}    CONST ->LevelmeterObject    = MUI_NewObject(MUIC_Levelmeter
NATIVE {BoopsiObject}        CONST ->BoopsiObject        = MUI_NewObject(MUIC_Boopsi
NATIVE {ColorfieldObject}    CONST ->ColorfieldObject    = MUI_NewObject(MUIC_Colorfield
NATIVE {PenadjustObject}     CONST ->PenadjustObject     = MUI_NewObject(MUIC_Penadjust
NATIVE {ColoradjustObject}   CONST ->ColoradjustObject   = MUI_NewObject(MUIC_Coloradjust
NATIVE {PaletteObject}       CONST ->PaletteObject       = MUI_NewObject(MUIC_Palette
NATIVE {GroupObject}         CONST ->GroupObject         = MUI_NewObject(MUIC_Group
NATIVE {RegisterObject}      CONST ->RegisterObject      = MUI_NewObject(MUIC_Register
NATIVE {VirtgroupObject}     CONST ->VirtgroupObject     = MUI_NewObject(MUIC_Virtgroup
NATIVE {ScrollgroupObject}   CONST ->ScrollgroupObject   = MUI_NewObject(MUIC_Scrollgroup
NATIVE {PopstringObject}     CONST ->PopstringObject     = MUI_NewObject(MUIC_Popstring
NATIVE {PopobjectObject}     CONST ->PopobjectObject     = MUI_NewObject(MUIC_Popobject
NATIVE {PoplistObject}       CONST ->PoplistObject       = MUI_NewObject(MUIC_Poplist
NATIVE {PopaslObject}        CONST ->PopaslObject        = MUI_NewObject(MUIC_Popasl
NATIVE {PendisplayObject}    CONST ->PendisplayObject    = MUI_NewObject(MUIC_Pendisplay
NATIVE {PoppenObject}        CONST ->PoppenObject        = MUI_NewObject(MUIC_Poppen
NATIVE {AboutmuiObject}      CONST ->AboutmuiObject      = MUI_NewObject(MUIC_Aboutmui
NATIVE {ScrmodelistObject}   CONST ->ScrmodelistObject   = MUI_NewObject(MUIC_Scrmodelist
NATIVE {KeyentryObject}      CONST ->KeyentryObject      = MUI_NewObject(MUIC_Keyentry
NATIVE {VGroup}              CONST ->VGroup              = MUI_NewObject(MUIC_Group
NATIVE {HGroup}              CONST ->HGroup              = MUI_NewObject(MUIC_Group,MUIA_Group_Horiz,TRUE
NATIVE {ColGroup} PROC	->ColGroup(cols)      MUI_NewObject(MUIC_Group,MUIA_Group_Columns,(cols)
NATIVE {RowGroup} PROC	->RowGroup(rows)      MUI_NewObject(MUIC_Group,MUIA_Group_Rows   ,(rows)
NATIVE {PageGroup}           CONST ->PageGroup           = MUI_NewObject(MUIC_Group,MUIA_Group_PageMode,TRUE
NATIVE {VGroupV}             CONST ->VGroupV             = MUI_NewObject(MUIC_Virtgroup
NATIVE {HGroupV}             CONST ->HGroupV             = MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Horiz,TRUE
NATIVE {ColGroupV} PROC	->ColGroupV(cols)     MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Columns,(cols)
NATIVE {RowGroupV} PROC	->RowGroupV(rows)     MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Rows   ,(rows)
NATIVE {PageGroupV}          CONST ->PageGroupV          = MUI_NewObject(MUIC_Virtgroup,MUIA_Group_PageMode,TRUE
NATIVE {RegisterGroup} PROC	->RegisterGroup(t)    MUI_NewObject(MUIC_Register,MUIA_Register_Titles,(t)
->NATIVE {End}                 CONST ->End                 = TAG_DONE)

NATIVE {Child}             CONST ->Child             = MUIA_Group_Child
NATIVE {SubWindow}         CONST ->SubWindow         = MUIA_Application_Window
NATIVE {WindowContents}    CONST ->WindowContents    = MUIA_Window_RootObject

#define MenustripObject      Mui_NewObject(MUIC_Menustrip
#define MenuObject           Mui_NewObject(MUIC_Menu
#define MenuObjectT(name)    Mui_NewObject(MUIC_Menu,MUIA_Menu_Title,name
#define MenuitemObject       Mui_NewObject(MUIC_Menuitem
#define WindowObject         Mui_NewObject(MUIC_Window
#define ImageObject          Mui_NewObject(MUIC_Image
#define BitmapObject         Mui_NewObject(MUIC_Bitmap
#define BodychunkObject      Mui_NewObject(MUIC_Bodychunk
#define NotifyObject         Mui_NewObject(MUIC_Notify
#define ApplicationObject    Mui_NewObject(MUIC_Application
#define TextObject           Mui_NewObject(MUIC_Text
#define RectangleObject      Mui_NewObject(MUIC_Rectangle
#define BalanceObject        Mui_NewObject(MUIC_Balance
#define ListObject           Mui_NewObject(MUIC_List
#define PropObject           Mui_NewObject(MUIC_Prop
#define StringObject         Mui_NewObject(MUIC_String
#define ScrollbarObject      Mui_NewObject(MUIC_Scrollbar
#define ListviewObject       Mui_NewObject(MUIC_Listview
#define RadioObject          Mui_NewObject(MUIC_Radio
#define VolumelistObject     Mui_NewObject(MUIC_Volumelist
#define FloattextObject      Mui_NewObject(MUIC_Floattext
#define DirlistObject        Mui_NewObject(MUIC_Dirlist
#define SliderObject         Mui_NewObject(MUIC_Slider
#define CycleObject          Mui_NewObject(MUIC_Cycle
#define GaugeObject          Mui_NewObject(MUIC_Gauge
#define ScaleObject          Mui_NewObject(MUIC_Scale
#define NumericObject        Mui_NewObject(MUIC_Numeric
#define NumericbuttonObject  Mui_NewObject(MUIC_Numericbutton
#define KnobObject           Mui_NewObject(MUIC_Knob
#define LevelmeterObject     Mui_NewObject(MUIC_Levelmeter
#define BoopsiObject         Mui_NewObject(MUIC_Boopsi
#define ColorfieldObject     Mui_NewObject(MUIC_Colorfield
#define PenadjustObject      Mui_NewObject(MUIC_Penadjust
#define ColoradjustObject    Mui_NewObject(MUIC_Coloradjust
#define PaletteObject        Mui_NewObject(MUIC_Palette
#define GroupObject          Mui_NewObject(MUIC_Group
#define RegisterObject       Mui_NewObject(MUIC_Register
#define VirtgroupObject      Mui_NewObject(MUIC_Virtgroup
#define ScrollgroupObject    Mui_NewObject(MUIC_Scrollgroup
#define PopstringObject      Mui_NewObject(MUIC_Popstring
#define PopobjectObject      Mui_NewObject(MUIC_Popobject
#define PoplistObject        Mui_NewObject(MUIC_Poplist
#define PopaslObject         Mui_NewObject(MUIC_Popasl
#define PendisplayObject     Mui_NewObject(MUIC_Pendisplay
#define PoppenObject         Mui_NewObject(MUIC_Poppen
#define AboutmuiObject       Mui_NewObject(MUIC_Aboutmui
#define ScrmodelistObject    Mui_NewObject(MUIC_Scrmodelist
#define KeyentryObject       Mui_NewObject(MUIC_Keyentry
#define VGroup               Mui_NewObject(MUIC_Group
#define HGroup               Mui_NewObject(MUIC_Group,MUIA_Group_Horiz,MUI_TRUE
#define ColGroup(cols)       Mui_NewObject(MUIC_Group,MUIA_Group_Columns,(cols)
#define RowGroup(rows)       Mui_NewObject(MUIC_Group,MUIA_Group_Rows   ,(rows)
#define PageGroup            Mui_NewObject(MUIC_Group,MUIA_Group_PageMode,MUI_TRUE
#define VGroupV              Mui_NewObject(MUIC_Virtgroup
#define HGroupV              Mui_NewObject(MUIC_Virtgroup,MUIA_Group_Horiz,MUI_TRUE
#define ColGroupV(cols)      Mui_NewObject(MUIC_Virtgroup,MUIA_Group_Columns,(cols)
#define RowGroupV(rows)      Mui_NewObject(MUIC_Virtgroup,MUIA_Group_Rows   ,(rows)
#define PageGroupV           Mui_NewObject(MUIC_Virtgroup,MUIA_Group_PageMode,MUI_TRUE
#define RegisterGroup(t)     Mui_NewObject(MUIC_Register,MUIA_Register_Titles,(t)
#ifndef End
#define End                  TAG_DONE)
#endif
#define EndA                 TAG_DONE]:tagitem)

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
** HGroup, GroupFrameT("Horiz Groups"),
**    Child, RectangleObject, TextFrame  , End,
**    Child, RectangleObject, StringFrame, End,
**    Child, RectangleObject, ButtonFrame, End,
**    Child, RectangleObject, ListFrame  , End,
**    End,
**
***************************************************************************/

NATIVE {NoFrame}          CONST ->NoFrame          = MUIA_Frame, MUIV_Frame_None
NATIVE {ButtonFrame}      CONST ->ButtonFrame      = MUIA_Frame, MUIV_Frame_Button
NATIVE {ImageButtonFrame} CONST ->ImageButtonFrame = MUIA_Frame, MUIV_Frame_ImageButton
NATIVE {TextFrame}        CONST ->TextFrame        = MUIA_Frame, MUIV_Frame_Text
NATIVE {StringFrame}      CONST ->StringFrame      = MUIA_Frame, MUIV_Frame_String
NATIVE {ReadListFrame}    CONST ->ReadListFrame    = MUIA_Frame, MUIV_Frame_ReadList
NATIVE {InputListFrame}   CONST ->InputListFrame   = MUIA_Frame, MUIV_Frame_InputList
NATIVE {PropFrame}        CONST ->PropFrame        = MUIA_Frame, MUIV_Frame_Prop
NATIVE {SliderFrame}      CONST ->SliderFrame      = MUIA_Frame, MUIV_Frame_Slider
NATIVE {GaugeFrame}       CONST ->GaugeFrame       = MUIA_Frame, MUIV_Frame_Gauge
NATIVE {VirtualFrame}     CONST ->VirtualFrame     = MUIA_Frame, MUIV_Frame_Virtual
NATIVE {GroupFrame}       CONST ->GroupFrame       = MUIA_Frame, MUIV_Frame_Group
NATIVE {GroupFrameT} PROC	->GroupFrameT(s)   MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s, MUIA_Background, MUII_GroupBack

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

NATIVE {HVSpace}           CONST ->HVSpace           = MUI_NewObject(MUIC_Rectangle,TAG_DONE)
NATIVE {HSpace} CONST	->HSpace(x)         MUI_MakeObject(MUIO_HSpace,x)
NATIVE {VSpace} CONST	->VSpace(x)         MUI_MakeObject(MUIO_VSpace,x)
NATIVE {HCenter} CONST	->HCenter(obj)      (HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End)
NATIVE {VCenter} CONST	->VCenter(obj)      (VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End)
NATIVE {InnerSpacing} PROC	->InnerSpacing(h,v) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
NATIVE {GroupSpacing} PROC	->GroupSpacing(x)   MUIA_Group_Spacing,x

#define HVSpace           Mui_NewObject(MUIC_Rectangle,TAG_DONE)
#define HSpace(x)         Mui_MakeObject(MUIO_HSpace,x)
#define VSpace(x)         Mui_MakeObject(MUIO_VSpace,x)
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

NATIVE {String} PROC	->String(contents,maxlen)\

NATIVE {KeyString} PROC	->KeyString(contents,maxlen,controlchar)\

#define StringMUI(contents,maxlen) StringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#define KeyString(contents,maxlen,controlchar) StringObject,\
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

NATIVE {CheckMark} PROC	->CheckMark(selected)\

NATIVE {KeyCheckMark} PROC	->KeyCheckMark(selected,control)\

#define CheckMark(selected) ImageObject,\
                ImageButtonFrame,\
                MUIA_InputMode        , MUIV_InputMode_Toggle,\
                MUIA_Image_Spec       , MUII_CheckMark,\
                MUIA_Image_FreeVert   , MUI_TRUE,\
                MUIA_Selected         , selected,\
                MUIA_Background       , MUII_ButtonBack,\
                MUIA_ShowSelState     , FALSE,\
                End

#define KeyCheckMark(selected,control) ImageObject,\
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

NATIVE {SimpleButton} PROC	->SimpleButton(label) MUI_MakeObject(MUIO_Button,label)

#define SimpleButton(label) Mui_MakeObject(MUIO_Button,label)

#ifdef MUI_OBSOLETE

NATIVE {KeyButton} PROC	->KeyButton(name,key)\

#define KeyButton(name,key) TextObject,\
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

NATIVE {Cycle} PROC	->Cycle(entries)        CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End
NATIVE {KeyCycle} PROC	->KeyCycle(entries,key) CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End

#define Cycle(entries)        CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End
#define KeyCycle(entries,key) CycleObject, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End



/***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************/

NATIVE {Radio} PROC	->Radio(name,array)\

NATIVE {KeyRadio} PROC	->KeyRadio(name,array,key)\

#define Radio(name,array) RadioObject,\
                GroupFrameT(name),\
                MUIA_Radio_Entries,array,\
                End

#define KeyRadio(name,array,key) RadioObject,\
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


NATIVE {Slider} PROC	->Slider(min,max,level)\

NATIVE {KeySlider} PROC	->KeySlider(min,max,level,key)\

#define Slider(min,max,level) SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                End

#define KeySlider(min,max,level,key) SliderObject,\
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

NATIVE {PopButton} PROC	->PopButton(img) MUI_MakeObject(MUIO_PopButton,img)

#define PopButton(img) Mui_MakeObject(MUIO_PopButton,img)



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

NATIVE {Label} PROC	->Label(label)   MUI_MakeObject(MUIO_Label,label,0)
NATIVE {Label1} PROC	->Label1(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame)
NATIVE {Label2} PROC	->Label2(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame)
NATIVE {LLabel} CONST	->LLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned)
NATIVE {LLabel1} CONST	->LLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame)
NATIVE {LLabel2} CONST	->LLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame)
NATIVE {CLabel} CONST	->CLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered)
NATIVE {CLabel1} CONST	->CLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_SingleFrame)
NATIVE {CLabel2} CONST	->CLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_DoubleFrame)

NATIVE {FreeLabel} PROC	->FreeLabel(label)   MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert)
NATIVE {FreeLabel1} PROC	->FreeLabel1(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_SingleFrame)
NATIVE {FreeLabel2} PROC	->FreeLabel2(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame)
NATIVE {FreeLLabel} PROC	->FreeLLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned)
NATIVE {FreeLLabel1} PROC	->FreeLLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame)
NATIVE {FreeLLabel2} PROC	->FreeLLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame)
NATIVE {FreeCLabel} PROC	->FreeCLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered)
NATIVE {FreeCLabel1} PROC	->FreeCLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame)
NATIVE {FreeCLabel2} PROC	->FreeCLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame)

NATIVE {KeyLabel} PROC	->KeyLabel(label,key)   MUI_MakeObject(MUIO_Label,label,key)
NATIVE {KeyLabel1} PROC	->KeyLabel1(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame|(key))
NATIVE {KeyLabel2} PROC	->KeyLabel2(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame|(key))
NATIVE {KeyLLabel} PROC	->KeyLLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|(key))
NATIVE {KeyLLabel1} PROC	->KeyLLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key))
NATIVE {KeyLLabel2} PROC	->KeyLLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key))
NATIVE {KeyCLabel} PROC	->KeyCLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|(key))
NATIVE {KeyCLabel1} PROC	->KeyCLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_SingleFrame|(key))
NATIVE {KeyCLabel2} PROC	->KeyCLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key))

NATIVE {FreeKeyLabel} PROC	->FreeKeyLabel(label,key)   MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|(key))
NATIVE {FreeKeyLabel1} PROC	->FreeKeyLabel1(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_SingleFrame|(key))
NATIVE {FreeKeyLabel2} PROC	->FreeKeyLabel2(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame|(key))
NATIVE {FreeKeyLLabel} PROC	->FreeKeyLLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|(key))
NATIVE {FreeKeyLLabel1} PROC	->FreeKeyLLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key))
NATIVE {FreeKeyLLabel2} PROC	->FreeKeyLLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key))
NATIVE {FreeKeyCLabel} PROC	->FreeKeyCLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|(key))
NATIVE {FreeKeyCLabel1} PROC	->FreeKeyCLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame|(key))
NATIVE {FreeKeyCLabel2} PROC	->FreeKeyCLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key))

#define Label(label)   Mui_MakeObject(MUIO_Label,label,0)
#define Label1(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame)
#define Label2(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame)
#define LLabel(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned)
#define LLabel1(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned + MUIO_Label_SingleFrame)
#define LLabel2(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame)
#define CLabel(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_Centered)
#define CLabel1(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_Centered + MUIO_Label_SingleFrame)
#define CLabel2(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_Centered + MUIO_Label_DoubleFrame)

#define FreeLabel(label)   Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert)
#define FreeLabel1(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_SingleFrame)
#define FreeLabel2(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_DoubleFrame)
#define FreeLLabel(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_LeftAligned)
#define FreeLLabel1(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_SingleFrame)
#define FreeLLabel2(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame)
#define FreeCLabel(label)  Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_Centered)
#define FreeCLabel1(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_SingleFrame)
#define FreeCLabel2(label) Mui_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_DoubleFrame)

#define KeyLabel(label,key)   Mui_MakeObject(MUIO_Label,label,key)
#define KeyLabel1(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_SingleFrame,key))
#define KeyLabel2(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_DoubleFrame,key))
#define KeyLLabel(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_LeftAligned,key))
#define KeyLLabel1(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key))
#define KeyLLabel2(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key))
#define KeyCLabel(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_Centered,key))
#define KeyCLabel1(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_Centered + MUIO_Label_SingleFrame,key))
#define KeyCLabel2(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_Centered + MUIO_Label_DoubleFrame,key))

#define FreeKeyLabel(label,key)   Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert,key))
#define FreeKeyLabel1(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_SingleFrame,key))
#define FreeKeyLabel2(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_DoubleFrame,key))
#define FreeKeyLLabel(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned,key))
#define FreeKeyLLabel1(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key))
#define FreeKeyLLabel2(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key))
#define FreeKeyCLabel(label,key)  Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered,key))
#define FreeKeyCLabel1(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_SingleFrame,key))
#define FreeKeyCLabel2(label,key) Mui_MakeObject(MUIO_Label,label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_DoubleFrame,key))



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

->#ifndef __cplusplus

NATIVE {get} PROC	->get(obj,attr,store) GetAttr(attr,obj,(ULONG *)store)
NATIVE {set} PROC	->set(obj,attr,value) SetAttrs(obj,attr,value,TAG_DONE)
NATIVE {nnset} PROC	->nnset(obj,attr,value) SetAttrs(obj,MUIA_NoNotify,TRUE,attr,value,TAG_DONE)

NATIVE {setmutex} PROC	->setmutex(obj,n)     set(obj,MUIA_Radio_Active,n)
NATIVE {setcycle} PROC	->setcycle(obj,n)     set(obj,MUIA_Cycle_Active,n)
NATIVE {setstring} PROC	->setstring(obj,s)    set(obj,MUIA_String_Contents,s)
NATIVE {setcheckmark} PROC	->setcheckmark(obj,b) set(obj,MUIA_Selected,b)
NATIVE {setslider} PROC	->setslider(obj,l)    set(obj,MUIA_Numeric_Value,l)

PROC get(obj:ARRAY,attr,store:ARRAY) IS GetAttr(attr,obj,store)
PROC set(obj:ARRAY,attr,value) IS SetAttrs(obj,attr,value,0)
PROC nnset(obj:ARRAY,attr,value) IS SetAttrs(obj,$804237f9,MUI_TRUE,attr,value,0)

#define setmutex(obj,n)     set(obj,MUIA_Radio_Active,n)
#define setcycle(obj,n)     set(obj,MUIA_Cycle_Active,n)
#define setstring(obj,s)    set(obj,MUIA_String_Contents,s)
#define setcheckmark(obj,b) set(obj,MUIA_Selected,b)
#define setslider(obj,l)    set(obj,MUIA_Numeric_Value,l)

->#endif


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

NATIVE {MUIM_BoopsiQuery} CONST MUIM_BoopsiQuery = $80427157 /* this is send to the boopsi and */
                                    /* must be used as return value   */

NATIVE {MUI_BoopsiQuery} OBJECT mui_boopsiquery
	{mbq_MethodID}	mbq_methodid	:ULONG              /* always MUIM_BoopsiQuery */

	{mbq_Screen}	mbq_screen	:PTR TO screen       /* obsolete, use mbq_RenderInfo */
	{mbq_Flags}	mbq_flags	:ULONG                 /* read only, see below */

	 {mbq_MinWidth}	mbq_minwidth	:VALUE              /* write only, fill in min width  */
	{mbq_MinHeight}	mbq_minheight	:VALUE              /* write only, fill in min height */
	 {mbq_MaxWidth}	mbq_maxwidth	:VALUE              /* write only, fill in max width  */
	{mbq_MaxHeight}	mbq_maxheight	:VALUE              /* write only, fill in max height */
	 {mbq_DefWidth}	mbq_defwidth	:VALUE              /* write only, fill in def width  */
	{mbq_DefHeight}	mbq_defheight	:VALUE              /* write only, fill in def height */

	{mbq_RenderInfo}	mbq_renderinfo	:PTR TO mui_renderinfo  /* read only, display context */

	/* may grow in future ... */
ENDOBJECT

NATIVE {MUIP_BoopsiQuery} CONST  /* old structure name */

NATIVE {MBQF_HORIZ} CONST MBQF_HORIZ = 1 SHL 0           /* object used in a horizontal */
                                    /* context (else vertical)     */

NATIVE {MBQ_MUI_MAXMAX} CONST MBQ_MUI_MAXMAX = (10000)          /* use this for unlimited MaxWidth/Height */


/*******************************************/
/* Begin of automatic header file creation */
/*******************************************/




/****************************************************************************/
/** Notify                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Notify} CONST
#define MUIC_Notify 'Notify.mui'

/* Methods */

NATIVE {MUIM_CallHook}                       CONST MUIM_CallHook                       = $8042b96b /* V4  */
NATIVE {MUIM_Export}                         CONST MUIM_Export                         = $80420f1c /* V12 */
NATIVE {MUIM_FindUData}                      CONST MUIM_FindUData                      = $8042c196 /* V8  */
NATIVE {MUIM_GetConfigItem}                  CONST MUIM_GetConfigItem                  = $80423edb /* V11 */
NATIVE {MUIM_GetUData}                       CONST MUIM_GetUData                       = $8042ed0c /* V8  */
NATIVE {MUIM_Import}                         CONST MUIM_Import                         = $8042d012 /* V12 */
NATIVE {MUIM_KillNotify}                     CONST MUIM_KillNotify                     = $8042d240 /* V4  */
NATIVE {MUIM_KillNotifyObj}                  CONST MUIM_KillNotifyObj                  = $8042b145 /* V16 */
NATIVE {MUIM_MultiSet}                       CONST MUIM_MultiSet                       = $8042d356 /* V7  */
NATIVE {MUIM_NoNotifySet}                    CONST MUIM_NoNotifySet                    = $8042216f /* V9  */
NATIVE {MUIM_Notify}                         CONST MUIM_Notify                         = $8042c9cb /* V4  */
NATIVE {MUIM_Set}                            CONST MUIM_Set                            = $8042549a /* V4  */
NATIVE {MUIM_SetAsString}                    CONST MUIM_SetAsString                    = $80422590 /* V4  */
NATIVE {MUIM_SetUData}                       CONST MUIM_SetUData                       = $8042c920 /* V8  */
NATIVE {MUIM_SetUDataOnce}                   CONST MUIM_SetUDataOnce                   = $8042ca19 /* V11 */
NATIVE {MUIM_WriteLong}                      CONST MUIM_WriteLong                      = $80428d86 /* V6  */
NATIVE {MUIM_WriteString}                    CONST MUIM_WriteString                    = $80424bf4 /* V6  */
NATIVE {MUIP_CallHook} OBJECT muip_callhook
	{MethodID}	methodid	:ULONG
	{Hook}	hook	:PTR TO hook
	{param1}	param1	:ULONG /* ... */
ENDOBJECT
NATIVE {MUIP_Export} OBJECT muip_export
	{MethodID}	methodid	:ULONG
	{dataspace}	dataspace	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_FindUData} OBJECT muip_findudata
	{MethodID}	methodid	:ULONG
	{udata}	udata	:ULONG
ENDOBJECT
NATIVE {MUIP_GetConfigItem} OBJECT muip_getconfigitem
	{MethodID}	methodid	:ULONG
	{id}	id	:ULONG
	{storage}	storage	:PTR TO ULONG
ENDOBJECT
NATIVE {MUIP_GetUData} OBJECT muip_getudata
	{MethodID}	methodid	:ULONG
	{udata}	udata	:ULONG
	{attr}	attr	:ULONG
	{storage}	storage	:PTR TO ULONG
ENDOBJECT
NATIVE {MUIP_Import} OBJECT muip_import
	{MethodID}	methodid	:ULONG
	{dataspace}	dataspace	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_KillNotify} OBJECT muip_killnotify
	{MethodID}	methodid	:ULONG
	{TrigAttr}	trigattr	:ULONG
ENDOBJECT
NATIVE {MUIP_KillNotifyObj} OBJECT muip_killnotifyobj
	{MethodID}	methodid	:ULONG
	{TrigAttr}	trigattr	:ULONG
	{dest}	dest	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_MultiSet} OBJECT muip_multiset
	{MethodID}	methodid	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
	{obj}	obj	:APTR /* ... */
ENDOBJECT
NATIVE {MUIP_NoNotifySet} OBJECT muip_nonotifyset
	{MethodID}	methodid	:ULONG
	{attr}	attr	:ULONG
	{format}	format	:ARRAY OF CHAR
	{val}	val	:ULONG /* ... */
ENDOBJECT
NATIVE {MUIP_Notify} OBJECT muip_notify
	{MethodID}	methodid	:ULONG
	{TrigAttr}	trigattr	:ULONG
	{TrigVal}	trigval	:ULONG
	{DestObj}	destobj	:APTR
	{FollowParams}	followparams	:ULONG /* ... */
ENDOBJECT
NATIVE {MUIP_Set} OBJECT muip_set
	{MethodID}	methodid	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
ENDOBJECT
NATIVE {MUIP_SetAsString} OBJECT muip_setasstring
	{MethodID}	methodid	:ULONG
	{attr}	attr	:ULONG
	{format}	format	:ARRAY OF CHAR
	{val}	val	:ULONG /* ... */
ENDOBJECT
NATIVE {MUIP_SetUData} OBJECT muip_setudata
	{MethodID}	methodid	:ULONG
	{udata}	udata	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
ENDOBJECT
NATIVE {MUIP_SetUDataOnce} OBJECT muip_setudataonce
	{MethodID}	methodid	:ULONG
	{udata}	udata	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
ENDOBJECT
NATIVE {MUIP_WriteLong} OBJECT muip_writelong
	{MethodID}	methodid	:ULONG
	{val}	val	:ULONG
	{memory}	memory	:PTR TO ULONG
ENDOBJECT
NATIVE {MUIP_WriteString} OBJECT muip_writestring
	{MethodID}	methodid	:ULONG
	{str}	str	:ARRAY OF CHAR
	{memory}	memory	:ARRAY OF CHAR
ENDOBJECT

/* Attributes */

NATIVE {MUIA_ApplicationObject}              CONST MUIA_ApplicationObject              = $8042d3ee /* V4  ..g Object *          */
NATIVE {MUIA_AppMessage}                     CONST MUIA_AppMessage                     = $80421955 /* V5  ..g struct AppMessage * */
NATIVE {MUIA_HelpLine}                       CONST MUIA_HelpLine                       = $8042a825 /* V4  isg LONG              */
NATIVE {MUIA_HelpNode}                       CONST MUIA_HelpNode                       = $80420b85 /* V4  isg STRPTR            */
NATIVE {MUIA_NoNotify}                       CONST MUIA_NoNotify                       = $804237f9 /* V7  .s. BOOL              */
NATIVE {MUIA_ObjectID}                       CONST MUIA_ObjectID                       = $8042d76e /* V11 isg ULONG             */
NATIVE {MUIA_Parent}                         CONST MUIA_Parent                         = $8042e35f /* V11 ..g Object *          */
NATIVE {MUIA_Revision}                       CONST MUIA_Revision                       = $80427eaa /* V4  ..g LONG              */
NATIVE {MUIA_UserData}                       CONST MUIA_UserData                       = $80420313 /* V4  isg ULONG             */
NATIVE {MUIA_Version}                        CONST MUIA_Version                        = $80422301 /* V4  ..g LONG              */



/****************************************************************************/
/** Family                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Family} CONST
#define MUIC_Family 'Family.mui'

/* Methods */

NATIVE {MUIM_Family_AddHead}                 CONST MUIM_Family_AddHead                 = $8042e200 /* V8  */
NATIVE {MUIM_Family_AddTail}                 CONST MUIM_Family_AddTail                 = $8042d752 /* V8  */
NATIVE {MUIM_Family_Insert}                  CONST MUIM_Family_Insert                  = $80424d34 /* V8  */
NATIVE {MUIM_Family_Remove}                  CONST MUIM_Family_Remove                  = $8042f8a9 /* V8  */
NATIVE {MUIM_Family_Sort}                    CONST MUIM_Family_Sort                    = $80421c49 /* V8  */
NATIVE {MUIM_Family_Transfer}                CONST MUIM_Family_Transfer                = $8042c14a /* V8  */
NATIVE {MUIP_Family_AddHead} OBJECT muip_family_addhead
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Family_AddTail} OBJECT muip_family_addtail
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Family_Insert} OBJECT muip_family_insert
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{pred}	pred	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Family_Remove} OBJECT muip_family_remove
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Family_Sort} OBJECT muip_family_sort
	{MethodID}	methodid	:ULONG
	{obj}	obj	:ARRAY OF PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Family_Transfer} OBJECT muip_family_transfer
	{MethodID}	methodid	:ULONG
	{family}	family	:PTR TO INTUIOBJECT
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Family_Child}                   CONST MUIA_Family_Child                   = $8042c696 /* V8  i.. Object *          */
NATIVE {MUIA_Family_List}                    CONST MUIA_Family_List                    = $80424b9e /* V8  ..g struct MinList *  */



/****************************************************************************/
/** Menustrip                                                              **/
/****************************************************************************/

NATIVE {MUIC_Menustrip} CONST
#define MUIC_Menustrip 'Menustrip.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Menustrip_Enabled}              CONST MUIA_Menustrip_Enabled              = $8042815b /* V8  isg BOOL              */



/****************************************************************************/
/** Menu                                                                   **/
/****************************************************************************/

NATIVE {MUIC_Menu} CONST
#define MUIC_Menu 'Menu.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Menu_Enabled}                   CONST MUIA_Menu_Enabled                   = $8042ed48 /* V8  isg BOOL              */
NATIVE {MUIA_Menu_Title}                     CONST MUIA_Menu_Title                     = $8042a0e3 /* V8  isg STRPTR            */



/****************************************************************************/
/** Menuitem                                                               **/
/****************************************************************************/

NATIVE {MUIC_Menuitem} CONST
#define MUIC_Menuitem 'Menuitem.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Menuitem_Checked}               CONST MUIA_Menuitem_Checked               = $8042562a /* V8  isg BOOL              */
NATIVE {MUIA_Menuitem_Checkit}               CONST MUIA_Menuitem_Checkit               = $80425ace /* V8  isg BOOL              */
NATIVE {MUIA_Menuitem_CommandString}         CONST MUIA_Menuitem_CommandString         = $8042b9cc /* V16 isg BOOL              */
NATIVE {MUIA_Menuitem_Enabled}               CONST MUIA_Menuitem_Enabled               = $8042ae0f /* V8  isg BOOL              */
NATIVE {MUIA_Menuitem_Exclude}               CONST MUIA_Menuitem_Exclude               = $80420bc6 /* V8  isg LONG              */
NATIVE {MUIA_Menuitem_Shortcut}              CONST MUIA_Menuitem_Shortcut              = $80422030 /* V8  isg STRPTR            */
NATIVE {MUIA_Menuitem_Title}                 CONST MUIA_Menuitem_Title                 = $804218be /* V8  isg STRPTR            */
NATIVE {MUIA_Menuitem_Toggle}                CONST MUIA_Menuitem_Toggle                = $80424d5c /* V8  isg BOOL              */
NATIVE {MUIA_Menuitem_Trigger}               CONST MUIA_Menuitem_Trigger               = $80426f32 /* V8  ..g struct MenuItem * */

NATIVE {MUIV_Menuitem_Shortcut_Check} CONST MUIV_Menuitem_Shortcut_Check = -1


/****************************************************************************/
/** Application                                                            **/
/****************************************************************************/

NATIVE {MUIC_Application} CONST
#define MUIC_Application 'Application.mui'

/* Methods */

NATIVE {MUIM_Application_AboutMUI}           CONST MUIM_Application_AboutMUI           = $8042d21d /* V14 */
NATIVE {MUIM_Application_AddInputHandler}    CONST MUIM_Application_AddInputHandler    = $8042f099 /* V11 */
NATIVE {MUIM_Application_CheckRefresh}       CONST MUIM_Application_CheckRefresh       = $80424d68 /* V11 */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Application_GetMenuCheck}       CONST MUIM_Application_GetMenuCheck       = $8042c0a7 /* V4  */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Application_GetMenuState}       CONST MUIM_Application_GetMenuState       = $8042a58f /* V4  */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Application_Input}              CONST MUIM_Application_Input              = $8042d0f5 /* V4  */
#endif /* MUI_OBSOLETE */
NATIVE {MUIM_Application_InputBuffered}      CONST MUIM_Application_InputBuffered      = $80427e59 /* V4  */
NATIVE {MUIM_Application_Load}               CONST MUIM_Application_Load               = $8042f90d /* V4  */
NATIVE {MUIM_Application_NewInput}           CONST MUIM_Application_NewInput           = $80423ba6 /* V11 */
NATIVE {MUIM_Application_OpenConfigWindow}   CONST MUIM_Application_OpenConfigWindow   = $804299ba /* V11 */
NATIVE {MUIM_Application_PushMethod}         CONST MUIM_Application_PushMethod         = $80429ef8 /* V4  */
NATIVE {MUIM_Application_RemInputHandler}    CONST MUIM_Application_RemInputHandler    = $8042e7af /* V11 */
NATIVE {MUIM_Application_ReturnID}           CONST MUIM_Application_ReturnID           = $804276ef /* V4  */
NATIVE {MUIM_Application_Save}               CONST MUIM_Application_Save               = $804227ef /* V4  */
NATIVE {MUIM_Application_SetConfigItem}      CONST MUIM_Application_SetConfigItem      = $80424a80 /* V11 */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Application_SetMenuCheck}       CONST MUIM_Application_SetMenuCheck       = $8042a707 /* V4  */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Application_SetMenuState}       CONST MUIM_Application_SetMenuState       = $80428bef /* V4  */
#endif /* MUI_OBSOLETE */
NATIVE {MUIM_Application_ShowHelp}           CONST MUIM_Application_ShowHelp           = $80426479 /* V4  */
NATIVE {MUIP_Application_AboutMUI} OBJECT muip_application_aboutmui
	{MethodID}	methodid	:ULONG
	{refwindow}	refwindow	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Application_AddInputHandler} OBJECT muip_application_addinputhandler
	{MethodID}	methodid	:ULONG
	{ihnode}	ihnode	:PTR TO mui_inputhandlernode
ENDOBJECT
NATIVE {MUIP_Application_CheckRefresh} OBJECT muip_application_checkrefresh
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Application_GetMenuCheck} OBJECT muip_application_getmenucheck
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
ENDOBJECT
NATIVE {MUIP_Application_GetMenuState} OBJECT muip_application_getmenustate
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
ENDOBJECT
NATIVE {MUIP_Application_Input} OBJECT muip_application_input
	{MethodID}	methodid	:ULONG
	{signal}	signal	:PTR TO LONGBITS
ENDOBJECT
NATIVE {MUIP_Application_InputBuffered} OBJECT muip_application_inputbuffered
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Application_Load} OBJECT muip_application_load
	{MethodID}	methodid	:ULONG
	{name}	name	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT
NATIVE {MUIP_Application_NewInput} OBJECT muip_application_newinput
	{MethodID}	methodid	:ULONG
	{signal}	signal	:PTR TO LONGBITS
ENDOBJECT
NATIVE {MUIP_Application_OpenConfigWindow} OBJECT muip_application_openconfigwindow
	{MethodID}	methodid	:ULONG
	{flags}	flags	:ULONG
ENDOBJECT
NATIVE {MUIP_Application_PushMethod} OBJECT muip_application_pushmethod
	{MethodID}	methodid	:ULONG
	{dest}	dest	:PTR TO INTUIOBJECT
	{count}	count	:VALUE /* ... */
ENDOBJECT
NATIVE {MUIP_Application_RemInputHandler} OBJECT muip_application_reminputhandler
	{MethodID}	methodid	:ULONG
	{ihnode}	ihnode	:PTR TO mui_inputhandlernode
ENDOBJECT
NATIVE {MUIP_Application_ReturnID} OBJECT muip_application_returnid
	{MethodID}	methodid	:ULONG
	{retid}	retid	:ULONG
ENDOBJECT
NATIVE {MUIP_Application_Save} OBJECT muip_application_save
	{MethodID}	methodid	:ULONG
	{name}	name	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT
NATIVE {MUIP_Application_SetConfigItem} OBJECT muip_application_setconfigitem
	{MethodID}	methodid	:ULONG
	{item}	item	:ULONG
	{data}	data	:APTR
ENDOBJECT
NATIVE {MUIP_Application_SetMenuCheck} OBJECT muip_application_setmenucheck
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {MUIP_Application_SetMenuState} OBJECT muip_application_setmenustate
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {MUIP_Application_ShowHelp} OBJECT muip_application_showhelp
	{MethodID}	methodid	:ULONG
	{window}	window	:PTR TO INTUIOBJECT
	{name}	name	:ARRAY OF CHAR
	{node}	node	:ARRAY OF CHAR
	{line}	line	:VALUE
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Application_Active}             CONST MUIA_Application_Active             = $804260ab /* V4  isg BOOL              */
NATIVE {MUIA_Application_Author}             CONST MUIA_Application_Author             = $80424842 /* V4  i.g STRPTR            */
NATIVE {MUIA_Application_Base}               CONST MUIA_Application_Base               = $8042e07a /* V4  i.g STRPTR            */
NATIVE {MUIA_Application_Broker}             CONST MUIA_Application_Broker             = $8042dbce /* V4  ..g Broker *          */
NATIVE {MUIA_Application_BrokerHook}         CONST MUIA_Application_BrokerHook         = $80428f4b /* V4  isg struct Hook *     */
NATIVE {MUIA_Application_BrokerPort}         CONST MUIA_Application_BrokerPort         = $8042e0ad /* V6  ..g struct MsgPort *  */
NATIVE {MUIA_Application_BrokerPri}          CONST MUIA_Application_BrokerPri          = $8042c8d0 /* V6  i.g LONG              */
NATIVE {MUIA_Application_Commands}           CONST MUIA_Application_Commands           = $80428648 /* V4  isg struct MUI_Command * */
NATIVE {MUIA_Application_Copyright}          CONST MUIA_Application_Copyright          = $8042ef4d /* V4  i.g STRPTR            */
NATIVE {MUIA_Application_Description}        CONST MUIA_Application_Description        = $80421fc6 /* V4  i.g STRPTR            */
NATIVE {MUIA_Application_DiskObject}         CONST MUIA_Application_DiskObject         = $804235cb /* V4  isg struct DiskObject * */
NATIVE {MUIA_Application_DoubleStart}        CONST MUIA_Application_DoubleStart        = $80423bc6 /* V4  ..g BOOL              */
NATIVE {MUIA_Application_DropObject}         CONST MUIA_Application_DropObject         = $80421266 /* V5  is. Object *          */
NATIVE {MUIA_Application_ForceQuit}          CONST MUIA_Application_ForceQuit          = $804257df /* V8  ..g BOOL              */
NATIVE {MUIA_Application_HelpFile}           CONST MUIA_Application_HelpFile           = $804293f4 /* V8  isg STRPTR            */
NATIVE {MUIA_Application_Iconified}          CONST MUIA_Application_Iconified          = $8042a07f /* V4  .sg BOOL              */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_Application_Menu}               CONST MUIA_Application_Menu               = $80420e1f /* V4  i.g struct NewMenu *  */
#endif /* MUI_OBSOLETE */
NATIVE {MUIA_Application_MenuAction}         CONST MUIA_Application_MenuAction         = $80428961 /* V4  ..g ULONG             */
NATIVE {MUIA_Application_MenuHelp}           CONST MUIA_Application_MenuHelp           = $8042540b /* V4  ..g ULONG             */
NATIVE {MUIA_Application_Menustrip}          CONST MUIA_Application_Menustrip          = $804252d9 /* V8  i.. Object *          */
NATIVE {MUIA_Application_RexxHook}           CONST MUIA_Application_RexxHook           = $80427c42 /* V7  isg struct Hook *     */
NATIVE {MUIA_Application_RexxMsg}            CONST MUIA_Application_RexxMsg            = $8042fd88 /* V4  ..g struct RxMsg *    */
NATIVE {MUIA_Application_RexxString}         CONST MUIA_Application_RexxString         = $8042d711 /* V4  .s. STRPTR            */
NATIVE {MUIA_Application_SingleTask}         CONST MUIA_Application_SingleTask         = $8042a2c8 /* V4  i.. BOOL              */
NATIVE {MUIA_Application_Sleep}              CONST MUIA_Application_Sleep              = $80425711 /* V4  .s. BOOL              */
NATIVE {MUIA_Application_Title}              CONST MUIA_Application_Title              = $804281b8 /* V4  i.g STRPTR            */
NATIVE {MUIA_Application_UseCommodities}     CONST MUIA_Application_UseCommodities     = $80425ee5 /* V10 i.. BOOL              */
NATIVE {MUIA_Application_UseRexx}            CONST MUIA_Application_UseRexx            = $80422387 /* V10 i.. BOOL              */
NATIVE {MUIA_Application_Version}            CONST MUIA_Application_Version            = $8042b33f /* V4  i.g STRPTR            */
NATIVE {MUIA_Application_Window}             CONST MUIA_Application_Window             = $8042bfe0 /* V4  i.. Object *          */
NATIVE {MUIA_Application_WindowList}         CONST MUIA_Application_WindowList         = $80429abe /* V13 ..g struct List *     */
NATIVE {MUIA_Application_UsedClasses}        CONST MUIA_Application_UsedClasses        = $8042e9a7

NATIVE {MUIV_Application_Package_NetConnect} CONST MUIV_Application_Package_NetConnect = $a3ff7b49


/****************************************************************************/
/** Window                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Window} CONST
#define MUIC_Window 'Window.mui'

/* Methods */

NATIVE {MUIM_Window_AddEventHandler}         CONST MUIM_Window_AddEventHandler         = $804203b7 /* V16 */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Window_GetMenuCheck}            CONST MUIM_Window_GetMenuCheck            = $80420414 /* V4  */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Window_GetMenuState}            CONST MUIM_Window_GetMenuState            = $80420d2f /* V4  */
#endif /* MUI_OBSOLETE */
NATIVE {MUIM_Window_RemEventHandler}         CONST MUIM_Window_RemEventHandler         = $8042679e /* V16 */
NATIVE {MUIM_Window_ScreenToBack}            CONST MUIM_Window_ScreenToBack            = $8042913d /* V4  */
NATIVE {MUIM_Window_ScreenToFront}           CONST MUIM_Window_ScreenToFront           = $804227a4 /* V4  */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Window_SetCycleChain}           CONST MUIM_Window_SetCycleChain           = $80426510 /* V4  */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Window_SetMenuCheck}            CONST MUIM_Window_SetMenuCheck            = $80422243 /* V4  */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIM_Window_SetMenuState}            CONST MUIM_Window_SetMenuState            = $80422b5e /* V4  */
#endif /* MUI_OBSOLETE */
NATIVE {MUIM_Window_Snapshot}                CONST MUIM_Window_Snapshot                = $8042945e /* V11 */
NATIVE {MUIM_Window_ToBack}                  CONST MUIM_Window_ToBack                  = $8042152e /* V4  */
NATIVE {MUIM_Window_ToFront}                 CONST MUIM_Window_ToFront                 = $8042554f /* V4  */
NATIVE {MUIP_Window_AddEventHandler} OBJECT muip_window_addeventhandler
	{MethodID}	methodid	:ULONG
	{ehnode}	ehnode	:PTR TO mui_eventhandlernode
ENDOBJECT
NATIVE {MUIP_Window_GetMenuCheck} OBJECT muip_window_getmenucheck
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
ENDOBJECT
NATIVE {MUIP_Window_GetMenuState} OBJECT muip_window_getmenustate
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
ENDOBJECT
NATIVE {MUIP_Window_RemEventHandler} OBJECT muip_window_remeventhandler
	{MethodID}	methodid	:ULONG
	{ehnode}	ehnode	:PTR TO mui_eventhandlernode
ENDOBJECT
NATIVE {MUIP_Window_ScreenToBack} OBJECT muip_window_screentoback
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Window_ScreenToFront} OBJECT muip_window_screentofront
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Window_SetCycleChain} OBJECT muip_window_setcyclechain
	{MethodID}	methodid	:ULONG
	{obj}	obj	:ARRAY OF PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Window_SetMenuCheck} OBJECT muip_window_setmenucheck
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {MUIP_Window_SetMenuState} OBJECT muip_window_setmenustate
	{MethodID}	methodid	:ULONG
	{MenuID}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {MUIP_Window_Snapshot} OBJECT muip_window_snapshot
	{MethodID}	methodid	:ULONG
	{flags}	flags	:VALUE
ENDOBJECT
NATIVE {MUIP_Window_ToBack} OBJECT muip_window_toback
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Window_ToFront} OBJECT muip_window_tofront
	{MethodID}	methodid	:ULONG
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Window_Activate}                CONST MUIA_Window_Activate                = $80428d2f /* V4  isg BOOL              */
NATIVE {MUIA_Window_ActiveObject}            CONST MUIA_Window_ActiveObject            = $80427925 /* V4  .sg Object *          */
NATIVE {MUIA_Window_AltHeight}               CONST MUIA_Window_AltHeight               = $8042cce3 /* V4  i.g LONG              */
NATIVE {MUIA_Window_AltLeftEdge}             CONST MUIA_Window_AltLeftEdge             = $80422d65 /* V4  i.g LONG              */
NATIVE {MUIA_Window_AltTopEdge}              CONST MUIA_Window_AltTopEdge              = $8042e99b /* V4  i.g LONG              */
NATIVE {MUIA_Window_AltWidth}                CONST MUIA_Window_AltWidth                = $804260f4 /* V4  i.g LONG              */
NATIVE {MUIA_Window_AppWindow}               CONST MUIA_Window_AppWindow               = $804280cf /* V5  i.. BOOL              */
NATIVE {MUIA_Window_Backdrop}                CONST MUIA_Window_Backdrop                = $8042c0bb /* V4  i.. BOOL              */
NATIVE {MUIA_Window_Borderless}              CONST MUIA_Window_Borderless              = $80429b79 /* V4  i.. BOOL              */
NATIVE {MUIA_Window_CloseGadget}             CONST MUIA_Window_CloseGadget             = $8042a110 /* V4  i.. BOOL              */
NATIVE {MUIA_Window_CloseRequest}            CONST MUIA_Window_CloseRequest            = $8042e86e /* V4  ..g BOOL              */
NATIVE {MUIA_Window_DefaultObject}           CONST MUIA_Window_DefaultObject           = $804294d7 /* V4  isg Object *          */
NATIVE {MUIA_Window_DepthGadget}             CONST MUIA_Window_DepthGadget             = $80421923 /* V4  i.. BOOL              */
NATIVE {MUIA_Window_DragBar}                 CONST MUIA_Window_DragBar                 = $8042045d /* V4  i.. BOOL              */
NATIVE {MUIA_Window_FancyDrawing}            CONST MUIA_Window_FancyDrawing            = $8042bd0e /* V8  isg BOOL              */
NATIVE {MUIA_Window_Height}                  CONST MUIA_Window_Height                  = $80425846 /* V4  i.g LONG              */
NATIVE {MUIA_Window_ID}                      CONST MUIA_Window_ID                      = $804201bd /* V4  isg ULONG             */
NATIVE {MUIA_Window_InputEvent}              CONST MUIA_Window_InputEvent              = $804247d8 /* V4  ..g struct InputEvent * */
NATIVE {MUIA_Window_IsSubWindow}             CONST MUIA_Window_IsSubWindow             = $8042b5aa /* V4  isg BOOL              */
NATIVE {MUIA_Window_LeftEdge}                CONST MUIA_Window_LeftEdge                = $80426c65 /* V4  i.g LONG              */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_Window_Menu}                    CONST MUIA_Window_Menu                    = $8042db94 /* V4  i.. struct NewMenu *  */
#endif /* MUI_OBSOLETE */
NATIVE {MUIA_Window_MenuAction}              CONST MUIA_Window_MenuAction              = $80427521 /* V8  isg ULONG             */
NATIVE {MUIA_Window_Menustrip}               CONST MUIA_Window_Menustrip               = $8042855e /* V8  i.g Object *          */
NATIVE {MUIA_Window_MouseObject}             CONST MUIA_Window_MouseObject             = $8042bf9b /* V10 ..g Object *          */
NATIVE {MUIA_Window_NeedsMouseObject}        CONST MUIA_Window_NeedsMouseObject        = $8042372a /* V10 i.. BOOL              */
NATIVE {MUIA_Window_NoMenus}                 CONST MUIA_Window_NoMenus                 = $80429df5 /* V4  is. BOOL              */
NATIVE {MUIA_Window_Open}                    CONST MUIA_Window_Open                    = $80428aa0 /* V4  .sg BOOL              */
NATIVE {MUIA_Window_PublicScreen}            CONST MUIA_Window_PublicScreen            = $804278e4 /* V6  isg STRPTR            */
NATIVE {MUIA_Window_RefWindow}               CONST MUIA_Window_RefWindow               = $804201f4 /* V4  is. Object *          */
NATIVE {MUIA_Window_RootObject}              CONST MUIA_Window_RootObject              = $8042cba5 /* V4  isg Object *          */
NATIVE {MUIA_Window_Screen}                  CONST MUIA_Window_Screen                  = $8042df4f /* V4  isg struct Screen *   */
NATIVE {MUIA_Window_ScreenTitle}             CONST MUIA_Window_ScreenTitle             = $804234b0 /* V5  isg STRPTR            */
NATIVE {MUIA_Window_SizeGadget}              CONST MUIA_Window_SizeGadget              = $8042e33d /* V4  i.. BOOL              */
NATIVE {MUIA_Window_SizeRight}               CONST MUIA_Window_SizeRight               = $80424780 /* V4  i.. BOOL              */
NATIVE {MUIA_Window_Sleep}                   CONST MUIA_Window_Sleep                   = $8042e7db /* V4  .sg BOOL              */
NATIVE {MUIA_Window_Title}                   CONST MUIA_Window_Title                   = $8042ad3d /* V4  isg STRPTR            */
NATIVE {MUIA_Window_TopEdge}                 CONST MUIA_Window_TopEdge                 = $80427c66 /* V4  i.g LONG              */
NATIVE {MUIA_Window_UseBottomBorderScroller} CONST MUIA_Window_UseBottomBorderScroller = $80424e79 /* V13 isg BOOL              */
NATIVE {MUIA_Window_UseLeftBorderScroller}   CONST MUIA_Window_UseLeftBorderScroller   = $8042433e /* V13 isg BOOL              */
NATIVE {MUIA_Window_UseRightBorderScroller}  CONST MUIA_Window_UseRightBorderScroller  = $8042c05e /* V13 isg BOOL              */
NATIVE {MUIA_Window_Width}                   CONST MUIA_Window_Width                   = $8042dcae /* V4  i.g LONG              */
NATIVE {MUIA_Window_Window}                  CONST MUIA_Window_Window                  = $80426a42 /* V4  ..g struct Window *   */

NATIVE {MUIV_Window_ActiveObject_None} CONST MUIV_Window_ActiveObject_None = 0
NATIVE {MUIV_Window_ActiveObject_Next} CONST MUIV_Window_ActiveObject_Next = -1
NATIVE {MUIV_Window_ActiveObject_Prev} CONST MUIV_Window_ActiveObject_Prev = -2
NATIVE {MUIV_Window_AltHeight_MinMax} CONST	->MUIV_Window_AltHeight_MinMax(p) (0-(p))
NATIVE {MUIV_Window_AltHeight_Visible} CONST	->MUIV_Window_AltHeight_Visible(p) (-100-(p))
NATIVE {MUIV_Window_AltHeight_Screen} CONST	->MUIV_Window_AltHeight_Screen(p) (-200-(p))
#define MUIV_Window_AltHeight_MinMax(p) (0-(p))
#define MUIV_Window_AltHeight_Visible(p) (-100-(p))
#define MUIV_Window_AltHeight_Screen(p) (-200-(p))
NATIVE {MUIV_Window_AltHeight_Scaled} CONST MUIV_Window_AltHeight_Scaled = -1000
NATIVE {MUIV_Window_AltLeftEdge_Centered} CONST MUIV_Window_AltLeftEdge_Centered = -1
NATIVE {MUIV_Window_AltLeftEdge_Moused} CONST MUIV_Window_AltLeftEdge_Moused = -2
NATIVE {MUIV_Window_AltLeftEdge_NoChange} CONST MUIV_Window_AltLeftEdge_NoChange = -1000
NATIVE {MUIV_Window_AltTopEdge_Centered} CONST MUIV_Window_AltTopEdge_Centered = -1
NATIVE {MUIV_Window_AltTopEdge_Moused} CONST MUIV_Window_AltTopEdge_Moused = -2
NATIVE {MUIV_Window_AltTopEdge_Delta} CONST	->MUIV_Window_AltTopEdge_Delta(p) (-3-(p))
#define MUIV_Window_AltTopEdge_Delta(p) (-3-(p))
NATIVE {MUIV_Window_AltTopEdge_NoChange} CONST MUIV_Window_AltTopEdge_NoChange = -1000
NATIVE {MUIV_Window_AltWidth_MinMax} CONST	->MUIV_Window_AltWidth_MinMax(p) (0-(p))
NATIVE {MUIV_Window_AltWidth_Visible} CONST	->MUIV_Window_AltWidth_Visible(p) (-100-(p))
NATIVE {MUIV_Window_AltWidth_Screen} CONST	->MUIV_Window_AltWidth_Screen(p) (-200-(p))
#define MUIV_Window_AltWidth_MinMax(p) (0-(p))
#define MUIV_Window_AltWidth_Visible(p) (-100-(p))
#define MUIV_Window_AltWidth_Screen(p) (-200-(p))
NATIVE {MUIV_Window_AltWidth_Scaled} CONST MUIV_Window_AltWidth_Scaled = -1000
NATIVE {MUIV_Window_Height_MinMax} CONST	->MUIV_Window_Height_MinMax(p) (0-(p))
NATIVE {MUIV_Window_Height_Visible} CONST	->MUIV_Window_Height_Visible(p) (-100-(p))
NATIVE {MUIV_Window_Height_Screen} CONST	->MUIV_Window_Height_Screen(p) (-200-(p))
#define MUIV_Window_Height_MinMax(p) (0-(p))
#define MUIV_Window_Height_Visible(p) (-100-(p))
#define MUIV_Window_Height_Screen(p) (-200-(p))
NATIVE {MUIV_Window_Height_Scaled} CONST MUIV_Window_Height_Scaled = -1000
NATIVE {MUIV_Window_Height_Default} CONST MUIV_Window_Height_Default = -1001
NATIVE {MUIV_Window_LeftEdge_Centered} CONST MUIV_Window_LeftEdge_Centered = -1
NATIVE {MUIV_Window_LeftEdge_Moused} CONST MUIV_Window_LeftEdge_Moused = -2
#ifdef MUI_OBSOLETE
NATIVE {MUIV_Window_Menu_NoMenu} CONST MUIV_Window_Menu_NoMenu = -1
#endif /* MUI_OBSOLETE */
NATIVE {MUIV_Window_TopEdge_Centered} CONST MUIV_Window_TopEdge_Centered = -1
NATIVE {MUIV_Window_TopEdge_Moused} CONST MUIV_Window_TopEdge_Moused = -2
NATIVE {MUIV_Window_TopEdge_Delta} CONST	->MUIV_Window_TopEdge_Delta(p) (-3-(p))
NATIVE {MUIV_Window_Width_MinMax} CONST	->MUIV_Window_Width_MinMax(p) (0-(p))
NATIVE {MUIV_Window_Width_Visible} CONST	->MUIV_Window_Width_Visible(p) (-100-(p))
NATIVE {MUIV_Window_Width_Screen} CONST	->MUIV_Window_Width_Screen(p) (-200-(p))
#define MUIV_Window_TopEdge_Delta(p) (-3-(p))
#define MUIV_Window_Width_MinMax(p) (0-(p))
#define MUIV_Window_Width_Visible(p) (-100-(p))
#define MUIV_Window_Width_Screen(p) (-200-(p))
NATIVE {MUIV_Window_Width_Scaled} CONST MUIV_Window_Width_Scaled = -1000
NATIVE {MUIV_Window_Width_Default} CONST MUIV_Window_Width_Default = -1001


/****************************************************************************/
/** Aboutmui                                                               **/
/****************************************************************************/

NATIVE {MUIC_Aboutmui} CONST
#define MUIC_Aboutmui 'Aboutmui.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Aboutmui_Application}           CONST MUIA_Aboutmui_Application           = $80422523 /* V11 i.. Object *          */



/****************************************************************************/
/** Area                                                                   **/
/****************************************************************************/

NATIVE {MUIC_Area} CONST
#define MUIC_Area 'Area.mui'

/* Methods */

NATIVE {MUIM_AskMinMax}                      CONST MUIM_AskMinMax                      = $80423874 /* Custom Class */ /* V4  */
NATIVE {MUIM_Cleanup}                        CONST MUIM_Cleanup                        = $8042d985 /* Custom Class */ /* V4  */
NATIVE {MUIM_ContextMenuBuild}               CONST MUIM_ContextMenuBuild               = $80429d2e /* V11 */
NATIVE {MUIM_ContextMenuChoice}              CONST MUIM_ContextMenuChoice              = $80420f0e /* V11 */
NATIVE {MUIM_CreateBubble}                   CONST MUIM_CreateBubble                   = $80421c41 /* V18 */
NATIVE {MUIM_CreateShortHelp}                CONST MUIM_CreateShortHelp                = $80428e93 /* V11 */
NATIVE {MUIM_DeleteBubble}                   CONST MUIM_DeleteBubble                   = $804211af /* V18 */
NATIVE {MUIM_DeleteShortHelp}                CONST MUIM_DeleteShortHelp                = $8042d35a /* V11 */
NATIVE {MUIM_DragBegin}                      CONST MUIM_DragBegin                      = $8042c03a /* V11 */
NATIVE {MUIM_DragDrop}                       CONST MUIM_DragDrop                       = $8042c555 /* V11 */
NATIVE {MUIM_DragFinish}                     CONST MUIM_DragFinish                     = $804251f0 /* V11 */
NATIVE {MUIM_DragQuery}                      CONST MUIM_DragQuery                      = $80420261 /* V11 */
NATIVE {MUIM_DragReport}                     CONST MUIM_DragReport                     = $8042edad /* V11 */
NATIVE {MUIM_Draw}                           CONST MUIM_Draw                           = $80426f3f /* Custom Class */ /* V4  */
NATIVE {MUIM_DrawBackground}                 CONST MUIM_DrawBackground                 = $804238ca /* V11 */
NATIVE {MUIM_HandleEvent}                    CONST MUIM_HandleEvent                    = $80426d66 /* Custom Class */ /* V16 */
NATIVE {MUIM_HandleInput}                    CONST MUIM_HandleInput                    = $80422a1a /* Custom Class */ /* V4  */
NATIVE {MUIM_Hide}                           CONST MUIM_Hide                           = $8042f20f /* Custom Class */ /* V4  */
NATIVE {MUIM_Setup}                          CONST MUIM_Setup                          = $80428354 /* Custom Class */ /* V4  */
NATIVE {MUIM_Show}                           CONST MUIM_Show                           = $8042cc84 /* Custom Class */ /* V4  */
NATIVE {MUIP_AskMinMax} OBJECT muip_askminmax
	{MethodID}	methodid	:ULONG
	{MinMaxInfo}	minmaxinfo	:PTR TO mui_minmax
ENDOBJECT /* Custom Class */
NATIVE {MUIP_Cleanup} OBJECT muip_cleanup
	{MethodID}	methodid	:ULONG
ENDOBJECT /* Custom Class */
NATIVE {MUIP_ContextMenuBuild} OBJECT muip_contextmenubuild
	{MethodID}	methodid	:ULONG
	{mx}	mx	:VALUE
	{my}	my	:VALUE
ENDOBJECT
NATIVE {MUIP_ContextMenuChoice} OBJECT muip_contextmenuchoice
	{MethodID}	methodid	:ULONG
	{item}	item	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_CreateBubble} OBJECT muip_createbubble
	{MethodID}	methodid	:ULONG
	{x}	x	:VALUE
	{y}	y	:VALUE
	{txt}	txt	:ARRAY OF CHAR
	{flags}	flags	:ULONG
ENDOBJECT
NATIVE {MUIP_CreateShortHelp} OBJECT muip_createshorthelp
	{MethodID}	methodid	:ULONG
	{mx}	mx	:VALUE
	{my}	my	:VALUE
ENDOBJECT
NATIVE {MUIP_DeleteBubble} OBJECT muip_deletebubble
	{MethodID}	methodid	:ULONG
	{bubble}	bubble	:APTR
ENDOBJECT
NATIVE {MUIP_DeleteShortHelp} OBJECT muip_deleteshorthelp
	{MethodID}	methodid	:ULONG
	{help}	help	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT
NATIVE {MUIP_DragBegin} OBJECT muip_dragbegin
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_DragDrop} OBJECT muip_dragdrop
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{x}	x	:VALUE
	{y}	y	:VALUE
ENDOBJECT
NATIVE {MUIP_DragFinish} OBJECT muip_dragfinish
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_DragQuery} OBJECT muip_dragquery
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_DragReport} OBJECT muip_dragreport
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{x}	x	:VALUE
	{y}	y	:VALUE
	{update}	update	:VALUE
ENDOBJECT
NATIVE {MUIP_Draw} OBJECT muip_draw
	{MethodID}	methodid	:ULONG
	{flags}	flags	:ULONG
ENDOBJECT /* Custom Class */
NATIVE {MUIP_DrawBackground} OBJECT muip_drawbackground
	{MethodID}	methodid	:ULONG
	{left}	left	:VALUE
	{top}	top	:VALUE
	{width}	width	:VALUE
	{height}	height	:VALUE
	{xoffset}	xoffset	:VALUE
	{yoffset}	yoffset	:VALUE
	{flags}	flags	:VALUE
ENDOBJECT
NATIVE {MUIP_HandleEvent} OBJECT muip_handleevent
	{MethodID}	methodid	:ULONG
	{imsg}	imsg	:PTR TO intuimessage
	{muikey}	muikey	:VALUE
ENDOBJECT /* Custom Class */
NATIVE {MUIP_HandleInput} OBJECT muip_handleinput
	{MethodID}	methodid	:ULONG
	{imsg}	imsg	:PTR TO intuimessage
	{muikey}	muikey	:VALUE
ENDOBJECT /* Custom Class */
NATIVE {MUIP_Hide} OBJECT muip_hide
	{MethodID}	methodid	:ULONG
ENDOBJECT /* Custom Class */
NATIVE {MUIP_Setup} OBJECT muip_setup
	{MethodID}	methodid	:ULONG
	{RenderInfo}	renderinfo	:PTR TO mui_renderinfo
ENDOBJECT /* Custom Class */
NATIVE {MUIP_Show} OBJECT muip_show
	{MethodID}	methodid	:ULONG
ENDOBJECT /* Custom Class */

/* Attributes */

NATIVE {MUIA_Background}                     CONST MUIA_Background                     = $8042545b /* V4  is. LONG              */
NATIVE {MUIA_BottomEdge}                     CONST MUIA_BottomEdge                     = $8042e552 /* V4  ..g LONG              */
NATIVE {MUIA_ContextMenu}                    CONST MUIA_ContextMenu                    = $8042b704 /* V11 isg Object *          */
NATIVE {MUIA_ContextMenuTrigger}             CONST MUIA_ContextMenuTrigger             = $8042a2c1 /* V11 ..g Object *          */
NATIVE {MUIA_ControlChar}                    CONST MUIA_ControlChar                    = $8042120b /* V4  isg char              */
NATIVE {MUIA_CycleChain}                     CONST MUIA_CycleChain                     = $80421ce7 /* V11 isg LONG              */
NATIVE {MUIA_Disabled}                       CONST MUIA_Disabled                       = $80423661 /* V4  isg BOOL              */
NATIVE {MUIA_Draggable}                      CONST MUIA_Draggable                      = $80420b6e /* V11 isg BOOL              */
NATIVE {MUIA_Dropable}                       CONST MUIA_Dropable                       = $8042fbce /* V11 isg BOOL              */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_ExportID}                       CONST MUIA_ExportID                       = $8042d76e /* V4  isg ULONG             */
#endif /* MUI_OBSOLETE */
NATIVE {MUIA_FillArea}                       CONST MUIA_FillArea                       = $804294a3 /* V4  is. BOOL              */
NATIVE {MUIA_FixHeight}                      CONST MUIA_FixHeight                      = $8042a92b /* V4  i.. LONG              */
NATIVE {MUIA_FixHeightTxt}                   CONST MUIA_FixHeightTxt                   = $804276f2 /* V4  i.. STRPTR            */
NATIVE {MUIA_FixWidth}                       CONST MUIA_FixWidth                       = $8042a3f1 /* V4  i.. LONG              */
NATIVE {MUIA_FixWidthTxt}                    CONST MUIA_FixWidthTxt                    = $8042d044 /* V4  i.. STRPTR            */
NATIVE {MUIA_Font}                           CONST MUIA_Font                           = $8042be50 /* V4  i.g struct TextFont * */
NATIVE {MUIA_Frame}                          CONST MUIA_Frame                          = $8042ac64 /* V4  i.. LONG              */
NATIVE {MUIA_FramePhantomHoriz}              CONST MUIA_FramePhantomHoriz              = $8042ed76 /* V4  i.. BOOL              */
NATIVE {MUIA_FrameTitle}                     CONST MUIA_FrameTitle                     = $8042d1c7 /* V4  i.. STRPTR            */
NATIVE {MUIA_Height}                         CONST MUIA_Height                         = $80423237 /* V4  ..g LONG              */
NATIVE {MUIA_HorizDisappear}                 CONST MUIA_HorizDisappear                 = $80429615 /* V11 isg LONG              */
NATIVE {MUIA_HorizWeight}                    CONST MUIA_HorizWeight                    = $80426db9 /* V4  isg WORD              */
NATIVE {MUIA_InnerBottom}                    CONST MUIA_InnerBottom                    = $8042f2c0 /* V4  i.g LONG              */
NATIVE {MUIA_InnerLeft}                      CONST MUIA_InnerLeft                      = $804228f8 /* V4  i.g LONG              */
NATIVE {MUIA_InnerRight}                     CONST MUIA_InnerRight                     = $804297ff /* V4  i.g LONG              */
NATIVE {MUIA_InnerTop}                       CONST MUIA_InnerTop                       = $80421eb6 /* V4  i.g LONG              */
NATIVE {MUIA_InputMode}                      CONST MUIA_InputMode                      = $8042fb04 /* V4  i.. LONG              */
NATIVE {MUIA_LeftEdge}                       CONST MUIA_LeftEdge                       = $8042bec6 /* V4  ..g LONG              */
NATIVE {MUIA_MaxHeight}                      CONST MUIA_MaxHeight                      = $804293e4 /* V11 i.. LONG              */
NATIVE {MUIA_MaxWidth}                       CONST MUIA_MaxWidth                       = $8042f112 /* V11 i.. LONG              */
NATIVE {MUIA_Pressed}                        CONST MUIA_Pressed                        = $80423535 /* V4  ..g BOOL              */
NATIVE {MUIA_RightEdge}                      CONST MUIA_RightEdge                      = $8042ba82 /* V4  ..g LONG              */
NATIVE {MUIA_Selected}                       CONST MUIA_Selected                       = $8042654b /* V4  isg BOOL              */
NATIVE {MUIA_ShortHelp}                      CONST MUIA_ShortHelp                      = $80428fe3 /* V11 isg STRPTR            */
NATIVE {MUIA_ShowMe}                         CONST MUIA_ShowMe                         = $80429ba8 /* V4  isg BOOL              */
NATIVE {MUIA_ShowSelState}                   CONST MUIA_ShowSelState                   = $8042caac /* V4  i.. BOOL              */
NATIVE {MUIA_Timer}                          CONST MUIA_Timer                          = $80426435 /* V4  ..g LONG              */
NATIVE {MUIA_TopEdge}                        CONST MUIA_TopEdge                        = $8042509b /* V4  ..g LONG              */
NATIVE {MUIA_VertDisappear}                  CONST MUIA_VertDisappear                  = $8042d12f /* V11 isg LONG              */
NATIVE {MUIA_VertWeight}                     CONST MUIA_VertWeight                     = $804298d0 /* V4  isg WORD              */
NATIVE {MUIA_Weight}                         CONST MUIA_Weight                         = $80421d1f /* V4  i.. WORD              */
NATIVE {MUIA_Width}                          CONST MUIA_Width                          = $8042b59c /* V4  ..g LONG              */
NATIVE {MUIA_Window}                         CONST MUIA_Window                         = $80421591 /* V4  ..g struct Window *   */
NATIVE {MUIA_WindowObject}                   CONST MUIA_WindowObject                   = $8042669e /* V4  ..g Object *          */

NATIVE {MUIV_Font_Inherit} CONST MUIV_Font_Inherit = 0
NATIVE {MUIV_Font_Normal} CONST MUIV_Font_Normal = -1
NATIVE {MUIV_Font_List} CONST MUIV_Font_List = -2
NATIVE {MUIV_Font_Tiny} CONST MUIV_Font_Tiny = -3
NATIVE {MUIV_Font_Fixed} CONST MUIV_Font_Fixed = -4
NATIVE {MUIV_Font_Title} CONST MUIV_Font_Title = -5
NATIVE {MUIV_Font_Big} CONST MUIV_Font_Big = -6
NATIVE {MUIV_Font_Button} CONST MUIV_Font_Button = -7
NATIVE {MUIV_Frame_None} CONST MUIV_Frame_None = 0
NATIVE {MUIV_Frame_Button} CONST MUIV_Frame_Button = 1
NATIVE {MUIV_Frame_ImageButton} CONST MUIV_Frame_ImageButton = 2
NATIVE {MUIV_Frame_Text} CONST MUIV_Frame_Text = 3
NATIVE {MUIV_Frame_String} CONST MUIV_Frame_String = 4
NATIVE {MUIV_Frame_ReadList} CONST MUIV_Frame_ReadList = 5
NATIVE {MUIV_Frame_InputList} CONST MUIV_Frame_InputList = 6
NATIVE {MUIV_Frame_Prop} CONST MUIV_Frame_Prop = 7
NATIVE {MUIV_Frame_Gauge} CONST MUIV_Frame_Gauge = 8
NATIVE {MUIV_Frame_Group} CONST MUIV_Frame_Group = 9
NATIVE {MUIV_Frame_PopUp} CONST MUIV_Frame_PopUp = 10
NATIVE {MUIV_Frame_Virtual} CONST MUIV_Frame_Virtual = 11
NATIVE {MUIV_Frame_Slider} CONST MUIV_Frame_Slider = 12
NATIVE {MUIV_Frame_Count} CONST MUIV_Frame_Count = 13
NATIVE {MUIV_InputMode_None} CONST MUIV_InputMode_None = 0
NATIVE {MUIV_InputMode_RelVerify} CONST MUIV_InputMode_RelVerify = 1
NATIVE {MUIV_InputMode_Immediate} CONST MUIV_InputMode_Immediate = 2
NATIVE {MUIV_InputMode_Toggle} CONST MUIV_InputMode_Toggle = 3


/****************************************************************************/
/** Rectangle                                                              **/
/****************************************************************************/

NATIVE {MUIC_Rectangle} CONST
#define MUIC_Rectangle 'Rectangle.mui'

/* Attributes */

NATIVE {MUIA_Rectangle_BarTitle}             CONST MUIA_Rectangle_BarTitle             = $80426689 /* V11 i.g STRPTR            */
NATIVE {MUIA_Rectangle_HBar}                 CONST MUIA_Rectangle_HBar                 = $8042c943 /* V7  i.g BOOL              */
NATIVE {MUIA_Rectangle_VBar}                 CONST MUIA_Rectangle_VBar                 = $80422204 /* V7  i.g BOOL              */



/****************************************************************************/
/** Balance                                                                **/
/****************************************************************************/

NATIVE {MUIC_Balance} CONST
#define MUIC_Balance 'Balance.mui'


/****************************************************************************/
/** Image                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Image} CONST
#define MUIC_Image 'Image.mui'

/* Attributes */

NATIVE {MUIA_Image_FontMatch}                CONST MUIA_Image_FontMatch                = $8042815d /* V4  i.. BOOL              */
NATIVE {MUIA_Image_FontMatchHeight}          CONST MUIA_Image_FontMatchHeight          = $80429f26 /* V4  i.. BOOL              */
NATIVE {MUIA_Image_FontMatchWidth}           CONST MUIA_Image_FontMatchWidth           = $804239bf /* V4  i.. BOOL              */
NATIVE {MUIA_Image_FreeHoriz}                CONST MUIA_Image_FreeHoriz                = $8042da84 /* V4  i.. BOOL              */
NATIVE {MUIA_Image_FreeVert}                 CONST MUIA_Image_FreeVert                 = $8042ea28 /* V4  i.. BOOL              */
NATIVE {MUIA_Image_OldImage}                 CONST MUIA_Image_OldImage                 = $80424f3d /* V4  i.. struct Image *    */
NATIVE {MUIA_Image_Spec}                     CONST MUIA_Image_Spec                     = $804233d5 /* V4  i.. char *            */
NATIVE {MUIA_Image_State}                    CONST MUIA_Image_State                    = $8042a3ad /* V4  is. LONG              */



/****************************************************************************/
/** Bitmap                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Bitmap} CONST
#define MUIC_Bitmap 'Bitmap.mui'

/* Attributes */

NATIVE {MUIA_Bitmap_Bitmap}                  CONST MUIA_Bitmap_Bitmap                  = $804279bd /* V8  isg struct BitMap *   */
NATIVE {MUIA_Bitmap_Height}                  CONST MUIA_Bitmap_Height                  = $80421560 /* V8  isg LONG              */
NATIVE {MUIA_Bitmap_MappingTable}            CONST MUIA_Bitmap_MappingTable            = $8042e23d /* V8  isg UBYTE *           */
NATIVE {MUIA_Bitmap_Precision}               CONST MUIA_Bitmap_Precision               = $80420c74 /* V11 isg LONG              */
NATIVE {MUIA_Bitmap_RemappedBitmap}          CONST MUIA_Bitmap_RemappedBitmap          = $80423a47 /* V11 ..g struct BitMap *   */
NATIVE {MUIA_Bitmap_SourceColors}            CONST MUIA_Bitmap_SourceColors            = $80425360 /* V8  isg ULONG *           */
NATIVE {MUIA_Bitmap_Transparent}             CONST MUIA_Bitmap_Transparent             = $80422805 /* V8  isg LONG              */
NATIVE {MUIA_Bitmap_UseFriend}               CONST MUIA_Bitmap_UseFriend               = $804239d8 /* V11 i.. BOOL              */
NATIVE {MUIA_Bitmap_Width}                   CONST MUIA_Bitmap_Width                   = $8042eb3a /* V8  isg LONG              */



/****************************************************************************/
/** Bodychunk                                                              **/
/****************************************************************************/

NATIVE {MUIC_Bodychunk} CONST
#define MUIC_Bodychunk 'Bodychunk.mui'

/* Attributes */

NATIVE {MUIA_Bodychunk_Body}                 CONST MUIA_Bodychunk_Body                 = $8042ca67 /* V8  isg UBYTE *           */
NATIVE {MUIA_Bodychunk_Compression}          CONST MUIA_Bodychunk_Compression          = $8042de5f /* V8  isg UBYTE             */
NATIVE {MUIA_Bodychunk_Depth}                CONST MUIA_Bodychunk_Depth                = $8042c392 /* V8  isg LONG              */
NATIVE {MUIA_Bodychunk_Masking}              CONST MUIA_Bodychunk_Masking              = $80423b0e /* V8  isg UBYTE             */



/****************************************************************************/
/** Text                                                                   **/
/****************************************************************************/

NATIVE {MUIC_Text} CONST
#define MUIC_Text 'Text.mui'

/* Attributes */

NATIVE {MUIA_Text_Contents}                  CONST MUIA_Text_Contents                  = $8042f8dc /* V4  isg STRPTR            */
NATIVE {MUIA_Text_HiChar}                    CONST MUIA_Text_HiChar                    = $804218ff /* V4  i.. char              */
NATIVE {MUIA_Text_PreParse}                  CONST MUIA_Text_PreParse                  = $8042566d /* V4  isg STRPTR            */
NATIVE {MUIA_Text_SetMax}                    CONST MUIA_Text_SetMax                    = $80424d0a /* V4  i.. BOOL              */
NATIVE {MUIA_Text_SetMin}                    CONST MUIA_Text_SetMin                    = $80424e10 /* V4  i.. BOOL              */
NATIVE {MUIA_Text_SetVMax}                   CONST MUIA_Text_SetVMax                   = $80420d8b /* V11 i.. BOOL              */



/****************************************************************************/
/** Gadget                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Gadget} CONST
#define MUIC_Gadget 'Gadget.mui'

/* Attributes */

NATIVE {MUIA_Gadget_Gadget}                  CONST MUIA_Gadget_Gadget                  = $8042ec1a /* V11 ..g struct Gadget *   */



/****************************************************************************/
/** String                                                                 **/
/****************************************************************************/

NATIVE {MUIC_String} CONST
#define MUIC_String 'String.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_String_Accept}                  CONST MUIA_String_Accept                  = $8042e3e1 /* V4  isg STRPTR            */
NATIVE {MUIA_String_Acknowledge}             CONST MUIA_String_Acknowledge             = $8042026c /* V4  ..g STRPTR            */
NATIVE {MUIA_String_AdvanceOnCR}             CONST MUIA_String_AdvanceOnCR             = $804226de /* V11 isg BOOL              */
NATIVE {MUIA_String_AttachedList}            CONST MUIA_String_AttachedList            = $80420fd2 /* V4  isg Object *          */
NATIVE {MUIA_String_BufferPos}               CONST MUIA_String_BufferPos               = $80428b6c /* V4  .sg LONG              */
NATIVE {MUIA_String_Contents}                CONST MUIA_String_Contents                = $80428ffd /* V4  isg STRPTR            */
NATIVE {MUIA_String_DisplayPos}              CONST MUIA_String_DisplayPos              = $8042ccbf /* V4  .sg LONG              */
NATIVE {MUIA_String_EditHook}                CONST MUIA_String_EditHook                = $80424c33 /* V7  isg struct Hook *     */
NATIVE {MUIA_String_Format}                  CONST MUIA_String_Format                  = $80427484 /* V4  i.g LONG              */
NATIVE {MUIA_String_Integer}                 CONST MUIA_String_Integer                 = $80426e8a /* V4  isg ULONG             */
NATIVE {MUIA_String_LonelyEditHook}          CONST MUIA_String_LonelyEditHook          = $80421569 /* V11 isg BOOL              */
NATIVE {MUIA_String_MaxLen}                  CONST MUIA_String_MaxLen                  = $80424984 /* V4  i.g LONG              */
NATIVE {MUIA_String_Reject}                  CONST MUIA_String_Reject                  = $8042179c /* V4  isg STRPTR            */
NATIVE {MUIA_String_Secret}                  CONST MUIA_String_Secret                  = $80428769 /* V4  i.g BOOL              */

NATIVE {MUIV_String_Format_Left} CONST MUIV_String_Format_Left = 0
NATIVE {MUIV_String_Format_Center} CONST MUIV_String_Format_Center = 1
NATIVE {MUIV_String_Format_Right} CONST MUIV_String_Format_Right = 2


/****************************************************************************/
/** Boopsi                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Boopsi} CONST
#define MUIC_Boopsi 'Boopsi.mui'

/* Attributes */

NATIVE {MUIA_Boopsi_Class}                   CONST MUIA_Boopsi_Class                   = $80426999 /* V4  isg struct IClass *   */
NATIVE {MUIA_Boopsi_ClassID}                 CONST MUIA_Boopsi_ClassID                 = $8042bfa3 /* V4  isg char *            */
NATIVE {MUIA_Boopsi_MaxHeight}               CONST MUIA_Boopsi_MaxHeight               = $8042757f /* V4  isg ULONG             */
NATIVE {MUIA_Boopsi_MaxWidth}                CONST MUIA_Boopsi_MaxWidth                = $8042bcb1 /* V4  isg ULONG             */
NATIVE {MUIA_Boopsi_MinHeight}               CONST MUIA_Boopsi_MinHeight               = $80422c93 /* V4  isg ULONG             */
NATIVE {MUIA_Boopsi_MinWidth}                CONST MUIA_Boopsi_MinWidth                = $80428fb2 /* V4  isg ULONG             */
NATIVE {MUIA_Boopsi_Object}                  CONST MUIA_Boopsi_Object                  = $80420178 /* V4  ..g Object *          */
NATIVE {MUIA_Boopsi_Remember}                CONST MUIA_Boopsi_Remember                = $8042f4bd /* V4  i.. ULONG             */
NATIVE {MUIA_Boopsi_Smart}                   CONST MUIA_Boopsi_Smart                   = $8042b8d7 /* V9  i.. BOOL              */
NATIVE {MUIA_Boopsi_TagDrawInfo}             CONST MUIA_Boopsi_TagDrawInfo             = $8042bae7 /* V4  isg ULONG             */
NATIVE {MUIA_Boopsi_TagScreen}               CONST MUIA_Boopsi_TagScreen               = $8042bc71 /* V4  isg ULONG             */
NATIVE {MUIA_Boopsi_TagWindow}               CONST MUIA_Boopsi_TagWindow               = $8042e11d /* V4  isg ULONG             */



/****************************************************************************/
/** Prop                                                                   **/
/****************************************************************************/

NATIVE {MUIC_Prop} CONST
#define MUIC_Prop 'Prop.mui'

/* Methods */

NATIVE {MUIM_Prop_Decrease}                  CONST MUIM_Prop_Decrease                  = $80420dd1 /* V16 */
NATIVE {MUIM_Prop_Increase}                  CONST MUIM_Prop_Increase                  = $8042cac0 /* V16 */
NATIVE {MUIP_Prop_Decrease} OBJECT muip_prop_decrease
	{MethodID}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT
NATIVE {MUIP_Prop_Increase} OBJECT muip_prop_increase
	{MethodID}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Prop_Entries}                   CONST MUIA_Prop_Entries                   = $8042fbdb /* V4  isg LONG              */
NATIVE {MUIA_Prop_First}                     CONST MUIA_Prop_First                     = $8042d4b2 /* V4  isg LONG              */
NATIVE {MUIA_Prop_Horiz}                     CONST MUIA_Prop_Horiz                     = $8042f4f3 /* V4  i.g BOOL              */
NATIVE {MUIA_Prop_Slider}                    CONST MUIA_Prop_Slider                    = $80429c3a /* V4  isg BOOL              */
NATIVE {MUIA_Prop_UseWinBorder}              CONST MUIA_Prop_UseWinBorder              = $8042deee /* V13 i.. LONG              */
NATIVE {MUIA_Prop_Visible}                   CONST MUIA_Prop_Visible                   = $8042fea6 /* V4  isg LONG              */

NATIVE {MUIV_Prop_UseWinBorder_None} CONST MUIV_Prop_UseWinBorder_None = 0
NATIVE {MUIV_Prop_UseWinBorder_Left} CONST MUIV_Prop_UseWinBorder_Left = 1
NATIVE {MUIV_Prop_UseWinBorder_Right} CONST MUIV_Prop_UseWinBorder_Right = 2
NATIVE {MUIV_Prop_UseWinBorder_Bottom} CONST MUIV_Prop_UseWinBorder_Bottom = 3


/****************************************************************************/
/** Gauge                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Gauge} CONST
#define MUIC_Gauge 'Gauge.mui'

/* Attributes */

NATIVE {MUIA_Gauge_Current}                  CONST MUIA_Gauge_Current                  = $8042f0dd /* V4  isg LONG              */
NATIVE {MUIA_Gauge_Divide}                   CONST MUIA_Gauge_Divide                   = $8042d8df /* V4  isg BOOL              */
NATIVE {MUIA_Gauge_Horiz}                    CONST MUIA_Gauge_Horiz                    = $804232dd /* V4  i.. BOOL              */
NATIVE {MUIA_Gauge_InfoText}                 CONST MUIA_Gauge_InfoText                 = $8042bf15 /* V7  isg STRPTR            */
NATIVE {MUIA_Gauge_Max}                      CONST MUIA_Gauge_Max                      = $8042bcdb /* V4  isg LONG              */



/****************************************************************************/
/** Scale                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Scale} CONST
#define MUIC_Scale 'Scale.mui'

/* Attributes */

NATIVE {MUIA_Scale_Horiz}                    CONST MUIA_Scale_Horiz                    = $8042919a /* V4  isg BOOL              */



/****************************************************************************/
/** Colorfield                                                             **/
/****************************************************************************/

NATIVE {MUIC_Colorfield} CONST
#define MUIC_Colorfield 'Colorfield.mui'

/* Attributes */

NATIVE {MUIA_Colorfield_Blue}                CONST MUIA_Colorfield_Blue                = $8042d3b0 /* V4  isg ULONG             */
NATIVE {MUIA_Colorfield_Green}               CONST MUIA_Colorfield_Green               = $80424466 /* V4  isg ULONG             */
NATIVE {MUIA_Colorfield_Pen}                 CONST MUIA_Colorfield_Pen                 = $8042713a /* V4  ..g ULONG             */
NATIVE {MUIA_Colorfield_Red}                 CONST MUIA_Colorfield_Red                 = $804279f6 /* V4  isg ULONG             */
NATIVE {MUIA_Colorfield_RGB}                 CONST MUIA_Colorfield_RGB                 = $8042677a /* V4  isg ULONG *           */



/****************************************************************************/
/** List                                                                   **/
/****************************************************************************/

NATIVE {MUIC_List} CONST
#define MUIC_List 'List.mui'

/* Methods */

NATIVE {MUIM_List_Clear}                     CONST MUIM_List_Clear                     = $8042ad89 /* V4  */
NATIVE {MUIM_List_CreateImage}               CONST MUIM_List_CreateImage               = $80429804 /* V11 */
NATIVE {MUIM_List_DeleteImage}               CONST MUIM_List_DeleteImage               = $80420f58 /* V11 */
NATIVE {MUIM_List_Exchange}                  CONST MUIM_List_Exchange                  = $8042468c /* V4  */
NATIVE {MUIM_List_GetEntry}                  CONST MUIM_List_GetEntry                  = $804280ec /* V4  */
NATIVE {MUIM_List_Insert}                    CONST MUIM_List_Insert                    = $80426c87 /* V4  */
NATIVE {MUIM_List_InsertSingle}              CONST MUIM_List_InsertSingle              = $804254d5 /* V7  */
NATIVE {MUIM_List_Jump}                      CONST MUIM_List_Jump                      = $8042baab /* V4  */
NATIVE {MUIM_List_Move}                      CONST MUIM_List_Move                      = $804253c2 /* V9  */
NATIVE {MUIM_List_NextSelected}              CONST MUIM_List_NextSelected              = $80425f17 /* V6  */
NATIVE {MUIM_List_Redraw}                    CONST MUIM_List_Redraw                    = $80427993 /* V4  */
NATIVE {MUIM_List_Remove}                    CONST MUIM_List_Remove                    = $8042647e /* V4  */
NATIVE {MUIM_List_Select}                    CONST MUIM_List_Select                    = $804252d8 /* V4  */
NATIVE {MUIM_List_Sort}                      CONST MUIM_List_Sort                      = $80422275 /* V4  */
NATIVE {MUIM_List_TestPos}                   CONST MUIM_List_TestPos                   = $80425f48 /* V11 */
NATIVE {MUIP_List_Clear} OBJECT muip_list_clear
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_List_CreateImage} OBJECT muip_list_createimage
	{MethodID}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{flags}	flags	:ULONG
ENDOBJECT
NATIVE {MUIP_List_DeleteImage} OBJECT muip_list_deleteimage
	{MethodID}	methodid	:ULONG
	{listimg}	listimg	:APTR
ENDOBJECT
NATIVE {MUIP_List_Exchange} OBJECT muip_list_exchange
	{MethodID}	methodid	:ULONG
	{pos1}	pos1	:VALUE
	{pos2}	pos2	:VALUE
ENDOBJECT
NATIVE {MUIP_List_GetEntry} OBJECT muip_list_getentry
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{entry}	entry	:PTR TO APTR
ENDOBJECT
NATIVE {MUIP_List_Insert} OBJECT muip_list_insert
	{MethodID}	methodid	:ULONG
	{entries}	entries	:PTR TO APTR
	{count}	count	:VALUE
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {MUIP_List_InsertSingle} OBJECT muip_list_insertsingle
	{MethodID}	methodid	:ULONG
	{entry}	entry	:APTR
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {MUIP_List_Jump} OBJECT muip_list_jump
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {MUIP_List_Move} OBJECT muip_list_move
	{MethodID}	methodid	:ULONG
	{from}	from	:VALUE
	{to}	to	:VALUE
ENDOBJECT
NATIVE {MUIP_List_NextSelected} OBJECT muip_list_nextselected
	{MethodID}	methodid	:ULONG
	{pos}	pos	:PTR TO VALUE
ENDOBJECT
NATIVE {MUIP_List_Redraw} OBJECT muip_list_redraw
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {MUIP_List_Remove} OBJECT muip_list_remove
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {MUIP_List_Select} OBJECT muip_list_select
	{MethodID}	methodid	:ULONG
	{pos}	pos	:VALUE
	{seltype}	seltype	:VALUE
	{state}	state	:PTR TO VALUE
ENDOBJECT
NATIVE {MUIP_List_Sort} OBJECT muip_list_sort
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_List_TestPos} OBJECT muip_list_testpos
	{MethodID}	methodid	:ULONG
	{x}	x	:VALUE
	{y}	y	:VALUE
	{res}	res	:PTR TO mui_list_testpos_result
ENDOBJECT

/* Attributes */

NATIVE {MUIA_List_Active}                    CONST MUIA_List_Active                    = $8042391c /* V4  isg LONG              */
NATIVE {MUIA_List_AdjustHeight}              CONST MUIA_List_AdjustHeight              = $8042850d /* V4  i.. BOOL              */
NATIVE {MUIA_List_AdjustWidth}               CONST MUIA_List_AdjustWidth               = $8042354a /* V4  i.. BOOL              */
NATIVE {MUIA_List_AutoVisible}               CONST MUIA_List_AutoVisible               = $8042a445 /* V11 isg BOOL              */
NATIVE {MUIA_List_CompareHook}               CONST MUIA_List_CompareHook               = $80425c14 /* V4  is. struct Hook *     */
NATIVE {MUIA_List_ConstructHook}             CONST MUIA_List_ConstructHook             = $8042894f /* V4  is. struct Hook *     */
NATIVE {MUIA_List_DestructHook}              CONST MUIA_List_DestructHook              = $804297ce /* V4  is. struct Hook *     */
NATIVE {MUIA_List_DisplayHook}               CONST MUIA_List_DisplayHook               = $8042b4d5 /* V4  is. struct Hook *     */
NATIVE {MUIA_List_DragSortable}              CONST MUIA_List_DragSortable              = $80426099 /* V11 isg BOOL              */
NATIVE {MUIA_List_DropMark}                  CONST MUIA_List_DropMark                  = $8042aba6 /* V11 ..g LONG              */
NATIVE {MUIA_List_Entries}                   CONST MUIA_List_Entries                   = $80421654 /* V4  ..g LONG              */
NATIVE {MUIA_List_First}                     CONST MUIA_List_First                     = $804238d4 /* V4  ..g LONG              */
NATIVE {MUIA_List_Format}                    CONST MUIA_List_Format                    = $80423c0a /* V4  isg STRPTR            */
NATIVE {MUIA_List_InsertPosition}            CONST MUIA_List_InsertPosition            = $8042d0cd /* V9  ..g LONG              */
NATIVE {MUIA_List_MinLineHeight}             CONST MUIA_List_MinLineHeight             = $8042d1c3 /* V4  i.. LONG              */
NATIVE {MUIA_List_MultiTestHook}             CONST MUIA_List_MultiTestHook             = $8042c2c6 /* V4  is. struct Hook *     */
NATIVE {MUIA_List_Pool}                      CONST MUIA_List_Pool                      = $80423431 /* V13 i.. APTR              */
NATIVE {MUIA_List_PoolPuddleSize}            CONST MUIA_List_PoolPuddleSize            = $8042a4eb /* V13 i.. ULONG             */
NATIVE {MUIA_List_PoolThreshSize}            CONST MUIA_List_PoolThreshSize            = $8042c48c /* V13 i.. ULONG             */
NATIVE {MUIA_List_Quiet}                     CONST MUIA_List_Quiet                     = $8042d8c7 /* V4  .s. BOOL              */
NATIVE {MUIA_List_ShowDropMarks}             CONST MUIA_List_ShowDropMarks             = $8042c6f3 /* V11 isg BOOL              */
NATIVE {MUIA_List_SourceArray}               CONST MUIA_List_SourceArray               = $8042c0a0 /* V4  i.. APTR              */
NATIVE {MUIA_List_Title}                     CONST MUIA_List_Title                     = $80423e66 /* V6  isg char *            */
NATIVE {MUIA_List_Visible}                   CONST MUIA_List_Visible                   = $8042191f /* V4  ..g LONG              */

NATIVE {MUIV_List_Active_Off} CONST MUIV_List_Active_Off = -1
NATIVE {MUIV_List_Active_Top} CONST MUIV_List_Active_Top = -2
NATIVE {MUIV_List_Active_Bottom} CONST MUIV_List_Active_Bottom = -3
NATIVE {MUIV_List_Active_Up} CONST MUIV_List_Active_Up = -4
NATIVE {MUIV_List_Active_Down} CONST MUIV_List_Active_Down = -5
NATIVE {MUIV_List_Active_PageUp} CONST MUIV_List_Active_PageUp = -6
NATIVE {MUIV_List_Active_PageDown} CONST MUIV_List_Active_PageDown = -7
NATIVE {MUIV_List_ConstructHook_String} CONST MUIV_List_ConstructHook_String = -1
NATIVE {MUIV_List_CopyHook_String} CONST MUIV_List_CopyHook_String = -1
NATIVE {MUIV_List_CursorType_None} CONST MUIV_List_CursorType_None = 0
NATIVE {MUIV_List_CursorType_Bar} CONST MUIV_List_CursorType_Bar = 1
NATIVE {MUIV_List_CursorType_Rect} CONST MUIV_List_CursorType_Rect = 2
NATIVE {MUIV_List_DestructHook_String} CONST MUIV_List_DestructHook_String = -1


/****************************************************************************/
/** Floattext                                                              **/
/****************************************************************************/

NATIVE {MUIC_Floattext} CONST
#define MUIC_Floattext 'Floattext.mui'

/* Attributes */

NATIVE {MUIA_Floattext_Justify}              CONST MUIA_Floattext_Justify              = $8042dc03 /* V4  isg BOOL              */
NATIVE {MUIA_Floattext_SkipChars}            CONST MUIA_Floattext_SkipChars            = $80425c7d /* V4  is. STRPTR            */
NATIVE {MUIA_Floattext_TabSize}              CONST MUIA_Floattext_TabSize              = $80427d17 /* V4  is. LONG              */
NATIVE {MUIA_Floattext_Text}                 CONST MUIA_Floattext_Text                 = $8042d16a /* V4  isg STRPTR            */



/****************************************************************************/
/** Volumelist                                                             **/
/****************************************************************************/

NATIVE {MUIC_Volumelist} CONST
#define MUIC_Volumelist 'Volumelist.mui'


/****************************************************************************/
/** Scrmodelist                                                            **/
/****************************************************************************/

NATIVE {MUIC_Scrmodelist} CONST
#define MUIC_Scrmodelist 'Scrmodelist.mui'

/* Attributes */




/****************************************************************************/
/** Dirlist                                                                **/
/****************************************************************************/

NATIVE {MUIC_Dirlist} CONST
#define MUIC_Dirlist 'Dirlist.mui'

/* Methods */

NATIVE {MUIM_Dirlist_ReRead}                 CONST MUIM_Dirlist_ReRead                 = $80422d71 /* V4  */
NATIVE {MUIP_Dirlist_ReRead} OBJECT muip_dirlist_reread
	{MethodID}	methodid	:ULONG
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Dirlist_AcceptPattern}          CONST MUIA_Dirlist_AcceptPattern          = $8042760a /* V4  is. STRPTR            */
NATIVE {MUIA_Dirlist_Directory}              CONST MUIA_Dirlist_Directory              = $8042ea41 /* V4  isg STRPTR            */
NATIVE {MUIA_Dirlist_DrawersOnly}            CONST MUIA_Dirlist_DrawersOnly            = $8042b379 /* V4  is. BOOL              */
NATIVE {MUIA_Dirlist_FilesOnly}              CONST MUIA_Dirlist_FilesOnly              = $8042896a /* V4  is. BOOL              */
NATIVE {MUIA_Dirlist_FilterDrawers}          CONST MUIA_Dirlist_FilterDrawers          = $80424ad2 /* V4  is. BOOL              */
NATIVE {MUIA_Dirlist_FilterHook}             CONST MUIA_Dirlist_FilterHook             = $8042ae19 /* V4  is. struct Hook *     */
NATIVE {MUIA_Dirlist_MultiSelDirs}           CONST MUIA_Dirlist_MultiSelDirs           = $80428653 /* V6  is. BOOL              */
NATIVE {MUIA_Dirlist_NumBytes}               CONST MUIA_Dirlist_NumBytes               = $80429e26 /* V4  ..g LONG              */
NATIVE {MUIA_Dirlist_NumDrawers}             CONST MUIA_Dirlist_NumDrawers             = $80429cb8 /* V4  ..g LONG              */
NATIVE {MUIA_Dirlist_NumFiles}               CONST MUIA_Dirlist_NumFiles               = $8042a6f0 /* V4  ..g LONG              */
NATIVE {MUIA_Dirlist_Path}                   CONST MUIA_Dirlist_Path                   = $80426176 /* V4  ..g STRPTR            */
NATIVE {MUIA_Dirlist_RejectIcons}            CONST MUIA_Dirlist_RejectIcons            = $80424808 /* V4  is. BOOL              */
NATIVE {MUIA_Dirlist_RejectPattern}          CONST MUIA_Dirlist_RejectPattern          = $804259c7 /* V4  is. STRPTR            */
NATIVE {MUIA_Dirlist_SortDirs}               CONST MUIA_Dirlist_SortDirs               = $8042bbb9 /* V4  is. LONG              */
NATIVE {MUIA_Dirlist_SortHighLow}            CONST MUIA_Dirlist_SortHighLow            = $80421896 /* V4  is. BOOL              */
NATIVE {MUIA_Dirlist_SortType}               CONST MUIA_Dirlist_SortType               = $804228bc /* V4  is. LONG              */
NATIVE {MUIA_Dirlist_Status}                 CONST MUIA_Dirlist_Status                 = $804240de /* V4  ..g LONG              */

NATIVE {MUIV_Dirlist_SortDirs_First} CONST MUIV_Dirlist_SortDirs_First = 0
NATIVE {MUIV_Dirlist_SortDirs_Last} CONST MUIV_Dirlist_SortDirs_Last = 1
NATIVE {MUIV_Dirlist_SortDirs_Mix} CONST MUIV_Dirlist_SortDirs_Mix = 2
NATIVE {MUIV_Dirlist_SortType_Name} CONST MUIV_Dirlist_SortType_Name = 0
NATIVE {MUIV_Dirlist_SortType_Date} CONST MUIV_Dirlist_SortType_Date = 1
NATIVE {MUIV_Dirlist_SortType_Size} CONST MUIV_Dirlist_SortType_Size = 2
NATIVE {MUIV_Dirlist_Status_Invalid} CONST MUIV_Dirlist_Status_Invalid = 0
NATIVE {MUIV_Dirlist_Status_Reading} CONST MUIV_Dirlist_Status_Reading = 1
NATIVE {MUIV_Dirlist_Status_Valid} CONST MUIV_Dirlist_Status_Valid = 2


/****************************************************************************/
/** Numeric                                                                **/
/****************************************************************************/

NATIVE {MUIC_Numeric} CONST
#define MUIC_Numeric 'Numeric.mui'

/* Methods */

NATIVE {MUIM_Numeric_Decrease}               CONST MUIM_Numeric_Decrease               = $804243a7 /* V11 */
NATIVE {MUIM_Numeric_Increase}               CONST MUIM_Numeric_Increase               = $80426ecd /* V11 */
NATIVE {MUIM_Numeric_ScaleToValue}           CONST MUIM_Numeric_ScaleToValue           = $8042032c /* V11 */
NATIVE {MUIM_Numeric_SetDefault}             CONST MUIM_Numeric_SetDefault             = $8042ab0a /* V11 */
NATIVE {MUIM_Numeric_Stringify}              CONST MUIM_Numeric_Stringify              = $80424891 /* V11 */
NATIVE {MUIM_Numeric_ValueToScale}           CONST MUIM_Numeric_ValueToScale           = $80423e4f /* V11 */
NATIVE {MUIP_Numeric_Decrease} OBJECT muip_numeric_decrease
	{MethodID}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT
NATIVE {MUIP_Numeric_Increase} OBJECT muip_numeric_increase
	{MethodID}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT
NATIVE {MUIP_Numeric_ScaleToValue} OBJECT muip_numeric_scaletovalue
	{MethodID}	methodid	:ULONG
	{scalemin}	scalemin	:VALUE
	{scalemax}	scalemax	:VALUE
	{scale}	scale	:VALUE
ENDOBJECT
NATIVE {MUIP_Numeric_SetDefault} OBJECT muip_numeric_setdefault
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Numeric_Stringify} OBJECT muip_numeric_stringify
	{MethodID}	methodid	:ULONG
	{value}	value	:VALUE
ENDOBJECT
NATIVE {MUIP_Numeric_ValueToScale} OBJECT muip_numeric_valuetoscale
	{MethodID}	methodid	:ULONG
	{scalemin}	scalemin	:VALUE
	{scalemax}	scalemax	:VALUE
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Numeric_CheckAllSizes}          CONST MUIA_Numeric_CheckAllSizes          = $80421594 /* V11 isg BOOL              */
NATIVE {MUIA_Numeric_Default}                CONST MUIA_Numeric_Default                = $804263e8 /* V11 isg LONG              */
NATIVE {MUIA_Numeric_Format}                 CONST MUIA_Numeric_Format                 = $804263e9 /* V11 isg STRPTR            */
NATIVE {MUIA_Numeric_Max}                    CONST MUIA_Numeric_Max                    = $8042d78a /* V11 isg LONG              */
NATIVE {MUIA_Numeric_Min}                    CONST MUIA_Numeric_Min                    = $8042e404 /* V11 isg LONG              */
NATIVE {MUIA_Numeric_Reverse}                CONST MUIA_Numeric_Reverse                = $8042f2a0 /* V11 isg BOOL              */
NATIVE {MUIA_Numeric_RevLeftRight}           CONST MUIA_Numeric_RevLeftRight           = $804294a7 /* V11 isg BOOL              */
NATIVE {MUIA_Numeric_RevUpDown}              CONST MUIA_Numeric_RevUpDown              = $804252dd /* V11 isg BOOL              */
NATIVE {MUIA_Numeric_Value}                  CONST MUIA_Numeric_Value                  = $8042ae3a /* V11 isg LONG              */



/****************************************************************************/
/** Knob                                                                   **/
/****************************************************************************/

NATIVE {MUIC_Knob} CONST
#define MUIC_Knob 'Knob.mui'


/****************************************************************************/
/** Levelmeter                                                             **/
/****************************************************************************/

NATIVE {MUIC_Levelmeter} CONST
#define MUIC_Levelmeter 'Levelmeter.mui'

/* Attributes */

NATIVE {MUIA_Levelmeter_Label}               CONST MUIA_Levelmeter_Label               = $80420dd5 /* V11 isg STRPTR            */



/****************************************************************************/
/** Numericbutton                                                          **/
/****************************************************************************/

NATIVE {MUIC_Numericbutton} CONST
#define MUIC_Numericbutton 'Numericbutton.mui'


/****************************************************************************/
/** Slider                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Slider} CONST
#define MUIC_Slider 'Slider.mui'

/* Attributes */

NATIVE {MUIA_Slider_Horiz}                   CONST MUIA_Slider_Horiz                   = $8042fad1 /* V11 isg BOOL              */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_Slider_Level}                   CONST MUIA_Slider_Level                   = $8042ae3a /* V4  isg LONG              */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_Slider_Max}                     CONST MUIA_Slider_Max                     = $8042d78a /* V4  isg LONG              */
#endif /* MUI_OBSOLETE */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_Slider_Min}                     CONST MUIA_Slider_Min                     = $8042e404 /* V4  isg LONG              */
#endif /* MUI_OBSOLETE */
NATIVE {MUIA_Slider_Quiet}                   CONST MUIA_Slider_Quiet                   = $80420b26 /* V6  i.. BOOL              */
#ifdef MUI_OBSOLETE
NATIVE {MUIA_Slider_Reverse}                 CONST MUIA_Slider_Reverse                 = $8042f2a0 /* V4  isg BOOL              */
#endif /* MUI_OBSOLETE */



/****************************************************************************/
/** Framedisplay                                                           **/
/****************************************************************************/

NATIVE {MUIC_Framedisplay} CONST
#define MUIC_Framedisplay 'Framedisplay.mui'

/* Attributes */




/****************************************************************************/
/** Popframe                                                               **/
/****************************************************************************/

NATIVE {MUIC_Popframe} CONST
#define MUIC_Popframe 'Popframe.mui'


/****************************************************************************/
/** Imagedisplay                                                           **/
/****************************************************************************/

NATIVE {MUIC_Imagedisplay} CONST
#define MUIC_Imagedisplay 'Imagedisplay.mui'

/* Attributes */




/****************************************************************************/
/** Popimage                                                               **/
/****************************************************************************/

NATIVE {MUIC_Popimage} CONST
#define MUIC_Popimage 'Popimage.mui'


/****************************************************************************/
/** Pendisplay                                                             **/
/****************************************************************************/

NATIVE {MUIC_Pendisplay} CONST
#define MUIC_Pendisplay 'Pendisplay.mui'

/* Methods */

NATIVE {MUIM_Pendisplay_SetColormap}         CONST MUIM_Pendisplay_SetColormap         = $80426c80 /* V13 */
NATIVE {MUIM_Pendisplay_SetMUIPen}           CONST MUIM_Pendisplay_SetMUIPen           = $8042039d /* V13 */
NATIVE {MUIM_Pendisplay_SetRGB}              CONST MUIM_Pendisplay_SetRGB              = $8042c131 /* V13 */
NATIVE {MUIP_Pendisplay_SetColormap} OBJECT muip_pendisplay_setcolormap
	{MethodID}	methodid	:ULONG
	{colormap}	colormap	:VALUE
ENDOBJECT
NATIVE {MUIP_Pendisplay_SetMUIPen} OBJECT muip_pendisplay_setmuipen
	{MethodID}	methodid	:ULONG
	{muipen}	muipen	:VALUE
ENDOBJECT
NATIVE {MUIP_Pendisplay_SetRGB} OBJECT muip_pendisplay_setrgb
	{MethodID}	methodid	:ULONG
	{red}	red	:ULONG
	{green}	green	:ULONG
	{blue}	blue	:ULONG
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Pendisplay_Pen}                 CONST MUIA_Pendisplay_Pen                 = $8042a748 /* V13 ..g Object *          */
NATIVE {MUIA_Pendisplay_Reference}           CONST MUIA_Pendisplay_Reference           = $8042dc24 /* V13 isg Object *          */
NATIVE {MUIA_Pendisplay_RGBcolor}            CONST MUIA_Pendisplay_RGBcolor            = $8042a1a9 /* V11 isg struct MUI_RGBcolor * */
NATIVE {MUIA_Pendisplay_Spec}                CONST MUIA_Pendisplay_Spec                = $8042a204 /* V11 isg struct MUI_PenSpec  * */



/****************************************************************************/
/** Poppen                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Poppen} CONST
#define MUIC_Poppen 'Poppen.mui'


/****************************************************************************/
/** Group                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Group} CONST
#define MUIC_Group 'Group.mui'

/* Methods */

NATIVE {MUIM_Group_ExitChange}               CONST MUIM_Group_ExitChange               = $8042d1cc /* V11 */
NATIVE {MUIM_Group_InitChange}               CONST MUIM_Group_InitChange               = $80420887 /* V11 */
NATIVE {MUIM_Group_Sort}                     CONST MUIM_Group_Sort                     = $80427417 /* V4  */
NATIVE {MUIP_Group_ExitChange} OBJECT muip_group_exitchange
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Group_InitChange} OBJECT muip_group_initchange
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Group_Sort} OBJECT muip_group_sort
	{MethodID}	methodid	:ULONG
	{obj}	obj	:ARRAY OF PTR TO INTUIOBJECT
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Group_ActivePage}               CONST MUIA_Group_ActivePage               = $80424199 /* V5  isg LONG              */
NATIVE {MUIA_Group_Child}                    CONST MUIA_Group_Child                    = $804226e6 /* V4  i.. Object *          */
NATIVE {MUIA_Group_ChildList}                CONST MUIA_Group_ChildList                = $80424748 /* V4  ..g struct List *     */
NATIVE {MUIA_Group_Columns}                  CONST MUIA_Group_Columns                  = $8042f416 /* V4  is. LONG              */
NATIVE {MUIA_Group_Horiz}                    CONST MUIA_Group_Horiz                    = $8042536b /* V4  i.. BOOL              */
NATIVE {MUIA_Group_HorizSpacing}             CONST MUIA_Group_HorizSpacing             = $8042c651 /* V4  isg LONG              */
NATIVE {MUIA_Group_LayoutHook}               CONST MUIA_Group_LayoutHook               = $8042c3b2 /* V11 i.. struct Hook *     */
NATIVE {MUIA_Group_PageMode}                 CONST MUIA_Group_PageMode                 = $80421a5f /* V5  i.. BOOL              */
NATIVE {MUIA_Group_Rows}                     CONST MUIA_Group_Rows                     = $8042b68f /* V4  is. LONG              */
NATIVE {MUIA_Group_SameHeight}               CONST MUIA_Group_SameHeight               = $8042037e /* V4  i.. BOOL              */
NATIVE {MUIA_Group_SameSize}                 CONST MUIA_Group_SameSize                 = $80420860 /* V4  i.. BOOL              */
NATIVE {MUIA_Group_SameWidth}                CONST MUIA_Group_SameWidth                = $8042b3ec /* V4  i.. BOOL              */
NATIVE {MUIA_Group_Spacing}                  CONST MUIA_Group_Spacing                  = $8042866d /* V4  is. LONG              */
NATIVE {MUIA_Group_VertSpacing}              CONST MUIA_Group_VertSpacing              = $8042e1bf /* V4  isg LONG              */

NATIVE {MUIV_Group_ActivePage_First} CONST MUIV_Group_ActivePage_First = 0
NATIVE {MUIV_Group_ActivePage_Last} CONST MUIV_Group_ActivePage_Last = -1
NATIVE {MUIV_Group_ActivePage_Prev} CONST MUIV_Group_ActivePage_Prev = -2
NATIVE {MUIV_Group_ActivePage_Next} CONST MUIV_Group_ActivePage_Next = -3
NATIVE {MUIV_Group_ActivePage_Advance} CONST MUIV_Group_ActivePage_Advance = -4


/****************************************************************************/
/** Mccprefs                                                               **/
/****************************************************************************/

NATIVE {MUIC_Mccprefs} CONST
#define MUIC_Mccprefs 'Mccprefs.mui'


/****************************************************************************/
/** Register                                                               **/
/****************************************************************************/

NATIVE {MUIC_Register} CONST
#define MUIC_Register 'Register.mui'

/* Attributes */

NATIVE {MUIA_Register_Frame}                 CONST MUIA_Register_Frame                 = $8042349b /* V7  i.g BOOL              */
NATIVE {MUIA_Register_Titles}                CONST MUIA_Register_Titles                = $804297ec /* V7  i.g STRPTR *          */



/****************************************************************************/
/** Penadjust                                                              **/
/****************************************************************************/

NATIVE {MUIC_Penadjust} CONST
#define MUIC_Penadjust 'Penadjust.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Penadjust_PSIMode}              CONST MUIA_Penadjust_PSIMode              = $80421cbb /* V11 i.. BOOL              */



/****************************************************************************/
/** Settingsgroup                                                          **/
/****************************************************************************/

NATIVE {MUIC_Settingsgroup} CONST
#define MUIC_Settingsgroup 'Settingsgroup.mui'

/* Methods */

NATIVE {MUIM_Settingsgroup_ConfigToGadgets}  CONST MUIM_Settingsgroup_ConfigToGadgets  = $80427043 /* V11 */
NATIVE {MUIM_Settingsgroup_GadgetsToConfig}  CONST MUIM_Settingsgroup_GadgetsToConfig  = $80425242 /* V11 */
NATIVE {MUIP_Settingsgroup_ConfigToGadgets} OBJECT muip_settingsgroup_configtogadgets
	{MethodID}	methodid	:ULONG
	{configdata}	configdata	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Settingsgroup_GadgetsToConfig} OBJECT muip_settingsgroup_gadgetstoconfig
	{MethodID}	methodid	:ULONG
	{configdata}	configdata	:PTR TO INTUIOBJECT
ENDOBJECT

/* Attributes */




/****************************************************************************/
/** Settings                                                               **/
/****************************************************************************/

NATIVE {MUIC_Settings} CONST
#define MUIC_Settings 'Settings.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Frameadjust                                                            **/
/****************************************************************************/

NATIVE {MUIC_Frameadjust} CONST
#define MUIC_Frameadjust 'Frameadjust.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Imageadjust                                                            **/
/****************************************************************************/

NATIVE {MUIC_Imageadjust} CONST
#define MUIC_Imageadjust 'Imageadjust.mui'

/* Methods */


/* Attributes */


NATIVE {MUIV_Imageadjust_Type_All} CONST MUIV_Imageadjust_Type_All = 0
NATIVE {MUIV_Imageadjust_Type_Image} CONST MUIV_Imageadjust_Type_Image = 1
NATIVE {MUIV_Imageadjust_Type_Background} CONST MUIV_Imageadjust_Type_Background = 2
NATIVE {MUIV_Imageadjust_Type_Pen} CONST MUIV_Imageadjust_Type_Pen = 3


/****************************************************************************/
/** Virtgroup                                                              **/
/****************************************************************************/

NATIVE {MUIC_Virtgroup} CONST
#define MUIC_Virtgroup 'Virtgroup.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Virtgroup_Height}               CONST MUIA_Virtgroup_Height               = $80423038 /* V6  ..g LONG              */
NATIVE {MUIA_Virtgroup_Input}                CONST MUIA_Virtgroup_Input                = $80427f7e /* V11 i.. BOOL              */
NATIVE {MUIA_Virtgroup_Left}                 CONST MUIA_Virtgroup_Left                 = $80429371 /* V6  isg LONG              */
NATIVE {MUIA_Virtgroup_Top}                  CONST MUIA_Virtgroup_Top                  = $80425200 /* V6  isg LONG              */
NATIVE {MUIA_Virtgroup_Width}                CONST MUIA_Virtgroup_Width                = $80427c49 /* V6  ..g LONG              */



/****************************************************************************/
/** Scrollgroup                                                            **/
/****************************************************************************/

NATIVE {MUIC_Scrollgroup} CONST
#define MUIC_Scrollgroup 'Scrollgroup.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Scrollgroup_Contents}           CONST MUIA_Scrollgroup_Contents           = $80421261 /* V4  i.g Object *          */
NATIVE {MUIA_Scrollgroup_FreeHoriz}          CONST MUIA_Scrollgroup_FreeHoriz          = $804292f3 /* V9  i.. BOOL              */
NATIVE {MUIA_Scrollgroup_FreeVert}           CONST MUIA_Scrollgroup_FreeVert           = $804224f2 /* V9  i.. BOOL              */
NATIVE {MUIA_Scrollgroup_HorizBar}           CONST MUIA_Scrollgroup_HorizBar           = $8042b63d /* V16 ..g Object *          */
NATIVE {MUIA_Scrollgroup_UseWinBorder}       CONST MUIA_Scrollgroup_UseWinBorder       = $804284c1 /* V13 i.. BOOL              */
NATIVE {MUIA_Scrollgroup_VertBar}            CONST MUIA_Scrollgroup_VertBar            = $8042cdc0 /* V16 ..g Object *          */



/****************************************************************************/
/** Scrollbar                                                              **/
/****************************************************************************/

NATIVE {MUIC_Scrollbar} CONST
#define MUIC_Scrollbar 'Scrollbar.mui'

/* Attributes */

NATIVE {MUIA_Scrollbar_Type}                 CONST MUIA_Scrollbar_Type                 = $8042fb6b /* V11 i.. LONG              */

NATIVE {MUIV_Scrollbar_Type_Default} CONST MUIV_Scrollbar_Type_Default = 0
NATIVE {MUIV_Scrollbar_Type_Bottom} CONST MUIV_Scrollbar_Type_Bottom = 1
NATIVE {MUIV_Scrollbar_Type_Top} CONST MUIV_Scrollbar_Type_Top = 2
NATIVE {MUIV_Scrollbar_Type_Sym} CONST MUIV_Scrollbar_Type_Sym = 3


/****************************************************************************/
/** Listview                                                               **/
/****************************************************************************/

NATIVE {MUIC_Listview} CONST
#define MUIC_Listview 'Listview.mui'

/* Attributes */

NATIVE {MUIA_Listview_ClickColumn}           CONST MUIA_Listview_ClickColumn           = $8042d1b3 /* V7  ..g LONG              */
NATIVE {MUIA_Listview_DefClickColumn}        CONST MUIA_Listview_DefClickColumn        = $8042b296 /* V7  isg LONG              */
NATIVE {MUIA_Listview_DoubleClick}           CONST MUIA_Listview_DoubleClick           = $80424635 /* V4  i.g BOOL              */
NATIVE {MUIA_Listview_DragType}              CONST MUIA_Listview_DragType              = $80425cd3 /* V11 isg LONG              */
NATIVE {MUIA_Listview_Input}                 CONST MUIA_Listview_Input                 = $8042682d /* V4  i.. BOOL              */
NATIVE {MUIA_Listview_List}                  CONST MUIA_Listview_List                  = $8042bcce /* V4  i.g Object *          */
NATIVE {MUIA_Listview_MultiSelect}           CONST MUIA_Listview_MultiSelect           = $80427e08 /* V7  i.. LONG              */
NATIVE {MUIA_Listview_ScrollerPos}           CONST MUIA_Listview_ScrollerPos           = $8042b1b4 /* V10 i.. BOOL              */
NATIVE {MUIA_Listview_SelectChange}          CONST MUIA_Listview_SelectChange          = $8042178f /* V4  ..g BOOL              */

NATIVE {MUIV_Listview_DragType_None} CONST MUIV_Listview_DragType_None = 0
NATIVE {MUIV_Listview_DragType_Immediate} CONST MUIV_Listview_DragType_Immediate = 1
NATIVE {MUIV_Listview_MultiSelect_None} CONST MUIV_Listview_MultiSelect_None = 0
NATIVE {MUIV_Listview_MultiSelect_Default} CONST MUIV_Listview_MultiSelect_Default = 1
NATIVE {MUIV_Listview_MultiSelect_Shifted} CONST MUIV_Listview_MultiSelect_Shifted = 2
NATIVE {MUIV_Listview_MultiSelect_Always} CONST MUIV_Listview_MultiSelect_Always = 3
NATIVE {MUIV_Listview_ScrollerPos_Default} CONST MUIV_Listview_ScrollerPos_Default = 0
NATIVE {MUIV_Listview_ScrollerPos_Left} CONST MUIV_Listview_ScrollerPos_Left = 1
NATIVE {MUIV_Listview_ScrollerPos_Right} CONST MUIV_Listview_ScrollerPos_Right = 2
NATIVE {MUIV_Listview_ScrollerPos_None} CONST MUIV_Listview_ScrollerPos_None = 3


/****************************************************************************/
/** Radio                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Radio} CONST
#define MUIC_Radio 'Radio.mui'

/* Attributes */

NATIVE {MUIA_Radio_Active}                   CONST MUIA_Radio_Active                   = $80429b41 /* V4  isg LONG              */
NATIVE {MUIA_Radio_Entries}                  CONST MUIA_Radio_Entries                  = $8042b6a1 /* V4  i.. STRPTR *          */



/****************************************************************************/
/** Cycle                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Cycle} CONST
#define MUIC_Cycle 'Cycle.mui'

/* Attributes */

NATIVE {MUIA_Cycle_Active}                   CONST MUIA_Cycle_Active                   = $80421788 /* V4  isg LONG              */
NATIVE {MUIA_Cycle_Entries}                  CONST MUIA_Cycle_Entries                  = $80420629 /* V4  i.. STRPTR *          */

NATIVE {MUIV_Cycle_Active_Next} CONST MUIV_Cycle_Active_Next = -1
NATIVE {MUIV_Cycle_Active_Prev} CONST MUIV_Cycle_Active_Prev = -2


/****************************************************************************/
/** Coloradjust                                                            **/
/****************************************************************************/

NATIVE {MUIC_Coloradjust} CONST
#define MUIC_Coloradjust 'Coloradjust.mui'

/* Methods */


/* Attributes */

NATIVE {MUIA_Coloradjust_Blue}               CONST MUIA_Coloradjust_Blue               = $8042b8a3 /* V4  isg ULONG             */
NATIVE {MUIA_Coloradjust_Green}              CONST MUIA_Coloradjust_Green              = $804285ab /* V4  isg ULONG             */
NATIVE {MUIA_Coloradjust_ModeID}             CONST MUIA_Coloradjust_ModeID             = $8042ec59 /* V4  isg ULONG             */
NATIVE {MUIA_Coloradjust_Red}                CONST MUIA_Coloradjust_Red                = $80420eaa /* V4  isg ULONG             */
NATIVE {MUIA_Coloradjust_RGB}                CONST MUIA_Coloradjust_RGB                = $8042f899 /* V4  isg ULONG *           */



/****************************************************************************/
/** Palette                                                                **/
/****************************************************************************/

NATIVE {MUIC_Palette} CONST
#define MUIC_Palette 'Palette.mui'

/* Attributes */

NATIVE {MUIA_Palette_Entries}                CONST MUIA_Palette_Entries                = $8042a3d8 /* V6  i.g struct MUI_Palette_Entry * */
NATIVE {MUIA_Palette_Groupable}              CONST MUIA_Palette_Groupable              = $80423e67 /* V6  isg BOOL              */
NATIVE {MUIA_Palette_Names}                  CONST MUIA_Palette_Names                  = $8042c3a2 /* V6  isg char **           */



/****************************************************************************/
/** Popstring                                                              **/
/****************************************************************************/

NATIVE {MUIC_Popstring} CONST
#define MUIC_Popstring 'Popstring.mui'

/* Methods */

NATIVE {MUIM_Popstring_Close}                CONST MUIM_Popstring_Close                = $8042dc52 /* V7  */
NATIVE {MUIM_Popstring_Open}                 CONST MUIM_Popstring_Open                 = $804258ba /* V7  */
NATIVE {MUIP_Popstring_Close} OBJECT muip_popstring_close
	{MethodID}	methodid	:ULONG
	{result}	result	:VALUE
ENDOBJECT
NATIVE {MUIP_Popstring_Open} OBJECT muip_popstring_open
	{MethodID}	methodid	:ULONG
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Popstring_Button}               CONST MUIA_Popstring_Button               = $8042d0b9 /* V7  i.g Object *          */
NATIVE {MUIA_Popstring_CloseHook}            CONST MUIA_Popstring_CloseHook            = $804256bf /* V7  isg struct Hook *     */
NATIVE {MUIA_Popstring_OpenHook}             CONST MUIA_Popstring_OpenHook             = $80429d00 /* V7  isg struct Hook *     */
NATIVE {MUIA_Popstring_String}               CONST MUIA_Popstring_String               = $804239ea /* V7  i.g Object *          */
NATIVE {MUIA_Popstring_Toggle}               CONST MUIA_Popstring_Toggle               = $80422b7a /* V7  isg BOOL              */



/****************************************************************************/
/** Popobject                                                              **/
/****************************************************************************/

NATIVE {MUIC_Popobject} CONST
#define MUIC_Popobject 'Popobject.mui'

/* Attributes */

NATIVE {MUIA_Popobject_Follow}               CONST MUIA_Popobject_Follow               = $80424cb5 /* V7  isg BOOL              */
NATIVE {MUIA_Popobject_Light}                CONST MUIA_Popobject_Light                = $8042a5a3 /* V7  isg BOOL              */
NATIVE {MUIA_Popobject_Object}               CONST MUIA_Popobject_Object               = $804293e3 /* V7  i.g Object *          */
NATIVE {MUIA_Popobject_ObjStrHook}           CONST MUIA_Popobject_ObjStrHook           = $8042db44 /* V7  isg struct Hook *     */
NATIVE {MUIA_Popobject_StrObjHook}           CONST MUIA_Popobject_StrObjHook           = $8042fbe1 /* V7  isg struct Hook *     */
NATIVE {MUIA_Popobject_Volatile}             CONST MUIA_Popobject_Volatile             = $804252ec /* V7  isg BOOL              */
NATIVE {MUIA_Popobject_WindowHook}           CONST MUIA_Popobject_WindowHook           = $8042f194 /* V9  isg struct Hook *     */



/****************************************************************************/
/** Poplist                                                                **/
/****************************************************************************/

NATIVE {MUIC_Poplist} CONST
#define MUIC_Poplist 'Poplist.mui'

/* Attributes */

NATIVE {MUIA_Poplist_Array}                  CONST MUIA_Poplist_Array                  = $8042084c /* V8  i.. char **           */



/****************************************************************************/
/** Popscreen                                                              **/
/****************************************************************************/

NATIVE {MUIC_Popscreen} CONST
#define MUIC_Popscreen 'Popscreen.mui'

/* Attributes */




/****************************************************************************/
/** Popasl                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Popasl} CONST
#define MUIC_Popasl 'Popasl.mui'

/* Attributes */

NATIVE {MUIA_Popasl_Active}                  CONST MUIA_Popasl_Active                  = $80421b37 /* V7  ..g BOOL              */
NATIVE {MUIA_Popasl_StartHook}               CONST MUIA_Popasl_StartHook               = $8042b703 /* V7  isg struct Hook *     */
NATIVE {MUIA_Popasl_StopHook}                CONST MUIA_Popasl_StopHook                = $8042d8d2 /* V7  isg struct Hook *     */
NATIVE {MUIA_Popasl_Type}                    CONST MUIA_Popasl_Type                    = $8042df3d /* V7  i.g ULONG             */



/****************************************************************************/
/** Semaphore                                                              **/
/****************************************************************************/

NATIVE {MUIC_Semaphore} CONST
#define MUIC_Semaphore 'Semaphore.mui'

/* Methods */

NATIVE {MUIM_Semaphore_Attempt}              CONST MUIM_Semaphore_Attempt              = $80426ce2 /* V11 */
NATIVE {MUIM_Semaphore_AttemptShared}        CONST MUIM_Semaphore_AttemptShared        = $80422551 /* V11 */
NATIVE {MUIM_Semaphore_Obtain}               CONST MUIM_Semaphore_Obtain               = $804276f0 /* V11 */
NATIVE {MUIM_Semaphore_ObtainShared}         CONST MUIM_Semaphore_ObtainShared         = $8042ea02 /* V11 */
NATIVE {MUIM_Semaphore_Release}              CONST MUIM_Semaphore_Release              = $80421f2d /* V11 */
NATIVE {MUIP_Semaphore_Attempt} OBJECT muip_semaphore_attempt
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Semaphore_AttemptShared} OBJECT muip_semaphore_attemptshared
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Semaphore_Obtain} OBJECT muip_semaphore_obtain
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Semaphore_ObtainShared} OBJECT muip_semaphore_obtainshared
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Semaphore_Release} OBJECT muip_semaphore_release
	{MethodID}	methodid	:ULONG
ENDOBJECT


/****************************************************************************/
/** Applist                                                                **/
/****************************************************************************/

NATIVE {MUIC_Applist} CONST
#define MUIC_Applist 'Applist.mui'

/* Methods */



/****************************************************************************/
/** Cclist                                                                 **/
/****************************************************************************/

NATIVE {MUIC_Cclist} CONST
#define MUIC_Cclist 'Cclist.mui'

/* Methods */



/****************************************************************************/
/** Dataspace                                                              **/
/****************************************************************************/

NATIVE {MUIC_Dataspace} CONST
#define MUIC_Dataspace 'Dataspace.mui'

/* Methods */

NATIVE {MUIM_Dataspace_Add}                  CONST MUIM_Dataspace_Add                  = $80423366 /* V11 */
NATIVE {MUIM_Dataspace_Clear}                CONST MUIM_Dataspace_Clear                = $8042b6c9 /* V11 */
NATIVE {MUIM_Dataspace_Find}                 CONST MUIM_Dataspace_Find                 = $8042832c /* V11 */
NATIVE {MUIM_Dataspace_Merge}                CONST MUIM_Dataspace_Merge                = $80423e2b /* V11 */
NATIVE {MUIM_Dataspace_ReadIFF}              CONST MUIM_Dataspace_ReadIFF              = $80420dfb /* V11 */
NATIVE {MUIM_Dataspace_Remove}               CONST MUIM_Dataspace_Remove               = $8042dce1 /* V11 */
NATIVE {MUIM_Dataspace_WriteIFF}             CONST MUIM_Dataspace_WriteIFF             = $80425e8e /* V11 */
NATIVE {MUIP_Dataspace_Add} OBJECT muip_dataspace_add
	{MethodID}	methodid	:ULONG
	{data}	data	:APTR
	{len}	len	:VALUE
	{id}	id	:ULONG
ENDOBJECT
NATIVE {MUIP_Dataspace_Clear} OBJECT muip_dataspace_clear
	{MethodID}	methodid	:ULONG
ENDOBJECT
NATIVE {MUIP_Dataspace_Find} OBJECT muip_dataspace_find
	{MethodID}	methodid	:ULONG
	{id}	id	:ULONG
ENDOBJECT
NATIVE {MUIP_Dataspace_Merge} OBJECT muip_dataspace_merge
	{MethodID}	methodid	:ULONG
	{dataspace}	dataspace	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {MUIP_Dataspace_ReadIFF} OBJECT muip_dataspace_readiff
	{MethodID}	methodid	:ULONG
	{handle}	handle	:PTR TO iffhandle
ENDOBJECT
NATIVE {MUIP_Dataspace_Remove} OBJECT muip_dataspace_remove
	{MethodID}	methodid	:ULONG
	{id}	id	:ULONG
ENDOBJECT
NATIVE {MUIP_Dataspace_WriteIFF} OBJECT muip_dataspace_writeiff
	{MethodID}	methodid	:ULONG
	{handle}	handle	:PTR TO iffhandle
	{type}	type	:ULONG
	{id}	id	:ULONG
ENDOBJECT

/* Attributes */

NATIVE {MUIA_Dataspace_Pool}                 CONST MUIA_Dataspace_Pool                 = $80424cf9 /* V11 i.. APTR              */



/****************************************************************************/
/** Configdata                                                             **/
/****************************************************************************/

NATIVE {MUIC_Configdata} CONST
#define MUIC_Configdata 'Configdata.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Dtpic                                                                  **/
/****************************************************************************/

NATIVE {MUIC_Dtpic} CONST
#define MUIC_Dtpic 'Dtpic.mui'

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

NATIVE {MUI_GlobalInfo} OBJECT mui_globalinfo
	{priv0}	priv0	:ULONG
	{mgi_ApplicationObject}	mgi_applicationobject	:PTR TO INTUIOBJECT

	/* ... private data follows ... */
ENDOBJECT


/* Instance data of notify class */

NATIVE {MUI_NotifyData} OBJECT mui_notifydata
	{mnd_GlobalInfo}	mnd_globalinfo	:PTR TO mui_globalinfo
	{mnd_UserData}	mnd_userdata	:ULONG
	{mnd_ObjectID}	mnd_objectid	:ULONG 
	{priv1}	priv1	:ULONG
	{priv2}	priv2	:ULONG
	{priv3}	priv3	:ULONG
	{priv4}	priv4	:ULONG
ENDOBJECT


/* MUI_MinMax structure holds information about minimum, maximum
   and default dimensions of an object. */

NATIVE {MUI_MinMax} OBJECT mui_minmax
	{MinWidth}	minwidth	:INT
	{MinHeight}	minheight	:INT
	{MaxWidth}	maxwidth	:INT
	{MaxHeight}	maxheight	:INT
	{DefWidth}	defwidth	:INT
	{DefHeight}	defheight	:INT
ENDOBJECT

NATIVE {MUI_MAXMAX} CONST MUI_MAXMAX = 10000 /* use this if a dimension is not limited. */


/* Hook message for custom layout */

->#beware hack!
{struct MUI_LayoutMsg_Size {
	LONG  Width;
	LONG  Height;
	ULONG priv5;
	ULONG priv6;
};}
NATIVE {MUI_LayoutMsg_Size} OBJECT mui_layoutmsg_size   -> NOTE: In the original C mui.h this structure is
   {Width}  width :VALUE             -> defined directly inside the following structure,
   {Height} height:VALUE             -> without a name! (see mui.h) But in E that isn't
   {priv5}  priv5 :ULONG             -> possible, so I had to do it this way.
   {priv6}  priv6 :ULONG
ENDOBJECT
->#end beware hack!

NATIVE {MUI_LayoutMsg} OBJECT mui_layoutmsg
	{lm_Type}	lm_type	:ULONG     /* type of message (see defines below)                      */
	{lm_Children}	lm_children	:PTR TO mlh /* list of this groups children, traverse with NextObject() */
	{lm_MinMax}	lm_minmax	:mui_minmax   /* results for MUILM_MINMAX                                 */
	{lm_Layout} lm_layout:mui_layoutmsg_size
	
	->#alternative mapping onto C struct, if the above doesn't work properly
	/*
	{lm_Layout.Width}	lm_layout_width	:VALUE
	{lm_Layout.Height}	lm_layout_height	:VALUE
	{lm_Layout.priv5}	lm_layout_priv5	:ULONG
	{lm_Layout.priv6}	lm_layout_priv6	:ULONG
	*/
	/* size (and result) for MUILM_LAYOUT                       */
ENDOBJECT

NATIVE {MUILM_MINMAX}    CONST MUILM_MINMAX    = 1  /* MUI wants you to calc your min & max sizes */
NATIVE {MUILM_LAYOUT}    CONST MUILM_LAYOUT    = 2  /* MUI wants you to layout your children      */

NATIVE {MUILM_UNKNOWN}  CONST MUILM_UNKNOWN  = -1  /* return this if your hook doesn't implement lm_Type */


/* (partial) instance data of area class */

NATIVE {MUI_AreaData} OBJECT mui_areadata
	{mad_RenderInfo}	mad_renderinfo	:PTR TO mui_renderinfo     /* RenderInfo for this object */
	{priv7}	priv7	:ULONG
	{mad_Font}	mad_font	:PTR TO textfont           /* Font */
	{mad_MinMax}	mad_minmax	:mui_minmax         /* min/max/default sizes */
	{mad_Box}	mad_box	:ibox            /* position and dimension */
	{mad_addleft}	mad_addleft	:BYTE        /* frame & innerspacing left offset */
	{mad_addtop}	mad_addtop	:BYTE         /* frame & innerspacing top offset  */
	{mad_subwidth}	mad_subwidth	:BYTE       /* frame & innerspacing add. width  */
	{mad_subheight}	mad_subheight	:BYTE      /* frame & innerspacing add. height */
	{mad_Flags}	mad_flags	:ULONG          /* see definitions below */

	/* ... private data follows ... */
ENDOBJECT

/* Definitions for mad_Flags, other flags are private */

NATIVE {MADF_DRAWOBJECT}        CONST MADF_DRAWOBJECT        = 1 SHL 0 /* completely redraw yourself */
NATIVE {MADF_DRAWUPDATE}        CONST MADF_DRAWUPDATE        = 1 SHL 1 /* only update yourself */



/* MUI's draw pens */

NATIVE {MPEN_SHINE}      CONST MPEN_SHINE      = 0
NATIVE {MPEN_HALFSHINE}  CONST MPEN_HALFSHINE  = 1
NATIVE {MPEN_BACKGROUND} CONST MPEN_BACKGROUND = 2
NATIVE {MPEN_HALFSHADOW} CONST MPEN_HALFSHADOW = 3
NATIVE {MPEN_SHADOW}     CONST MPEN_SHADOW     = 4
NATIVE {MPEN_TEXT}       CONST MPEN_TEXT       = 5
NATIVE {MPEN_FILL}       CONST MPEN_FILL       = 6
NATIVE {MPEN_MARK}       CONST MPEN_MARK       = 7
NATIVE {MPEN_COUNT}      CONST MPEN_COUNT      = 8


/* Mask for pens from MUI_ObtainPen() */

NATIVE {MUIPEN_MASK} CONST MUIPEN_MASK = $0000ffff
NATIVE {MUIPEN} CONST	->MUIPEN(pen) ((pen) & MUIPEN_MASK)
#define MUIPEN(pen) ((pen) AND MUIPEN_MASK)


/* Information on display environment */

NATIVE {MUI_RenderInfo} OBJECT mui_renderinfo
	{mri_WindowObject}	mri_windowobject	:PTR TO INTUIOBJECT  /* valid between MUIM_Setup/MUIM_Cleanup */

	{mri_Screen}	mri_screen	:PTR TO screen        /* valid between MUIM_Setup/MUIM_Cleanup */
	{mri_DrawInfo}	mri_drawinfo	:PTR TO drawinfo      /* valid between MUIM_Setup/MUIM_Cleanup */
	{mri_Pens}	mri_pens	:PTR TO UINT          /* valid between MUIM_Setup/MUIM_Cleanup */
	{mri_Window}	mri_window	:PTR TO window        /* valid between MUIM_Show/MUIM_Hide */
	{mri_RastPort}	mri_rastport	:PTR TO rastport      /* valid between MUIM_Show/MUIM_Hide */

	{mri_Flags}	mri_flags	:ULONG         /* valid between MUIM_Setup/MUIM_Cleanup */

	/* ... private data follows ... */
ENDOBJECT

/*
** If mri_Flags & MUIMRI_RECTFILL, RectFill() is quicker
** than Move()/Draw() for horizontal or vertical lines.
** on the current display.
*/
NATIVE {MUIMRI_RECTFILL} CONST MUIMRI_RECTFILL = 1 SHL 0

/*
** If mri_Flags & MUIMRI_TRUECOLOR, display environment is a
** cybergraphics emulated hicolor or true color display.
*/
NATIVE {MUIMRI_TRUECOLOR} CONST MUIMRI_TRUECOLOR = 1 SHL 1

/*
** If mri_Flags & MUIMRI_THINFRAMES, MUI uses thin frames
** (1:1) apsect ratio instead of standard 2:1 frames.
*/
NATIVE {MUIMRI_THINFRAMES} CONST MUIMRI_THINFRAMES = 1 SHL 2

/*
** If mri_Flags & MUIMRI_REFRESHMODE, MUI is currently
** refreshing a WFLG_SIMPLEREFRESH window and is between
** a BeginRefresh()/EndRefresh() pair.
*/
NATIVE {MUIMRI_REFRESHMODE} CONST MUIMRI_REFRESHMODE = 1 SHL 3


/* the following macros can be used to get pointers to an objects
   GlobalInfo and RenderInfo structures. */

NATIVE {__dummyXFC2__} OBJECT __dummyxfc2__
	{mnd}	mnd	:mui_notifydata
	{mad}	mad	:mui_areadata
ENDOBJECT

NATIVE {muiNotifyData} PROC	->muiNotifyData(obj) (&(((struct __dummyXFC2__ *)(obj))->mnd))
NATIVE {muiAreaData} PROC	->muiAreaData(obj)   (&(((struct __dummyXFC2__ *)(obj))->mad))

NATIVE {muiGlobalInfo} PROC	->muiGlobalInfo(obj) (((struct __dummyXFC2__ *)(obj))->mnd.mnd_GlobalInfo)
NATIVE {muiUserData} PROC	->muiUserData(obj)   (((struct __dummyXFC2__ *)(obj))->mnd.mnd_UserData)
NATIVE {muiRenderInfo} PROC	->muiRenderInfo(obj) (((struct __dummyXFC2__ *)(obj))->mad.mad_RenderInfo)

#define muiNotifyData(obj) (obj!!PTR!!PTR TO __dummyxfc2__).mnd
#define muiAreaData(obj)   (obj!!PTR!!PTR TO __dummyxfc2__).mad

#define muiGlobalInfo(obj) (obj!!PTR!!PTR TO __dummyxfc2__).mnd.mnd_globalinfo
#define muiUserData(obj)   (obj!!PTR!!PTR TO __dummyxfc2__).mnd.mnd_userdata
#define muiRenderInfo(obj) (obj!!PTR!!PTR TO __dummyxfc2__).mad.mad_renderinfo



/* User configurable keyboard events coming with MUIM_HandleInput */

NATIVE {MUIKEY_RELEASE} CONST MUIKEY_RELEASE = -2 /* not a real key, faked when MUIKEY_PRESS is released */
NATIVE {MUIKEY_NONE}    CONST MUIKEY_NONE    = -1
NATIVE {MUIKEY_PRESS}	CONST MUIKEY_PRESS = 0
NATIVE {MUIKEY_TOGGLE}	CONST MUIKEY_TOGGLE = 1
NATIVE {MUIKEY_UP}	CONST MUIKEY_UP = 2
NATIVE {MUIKEY_DOWN}	CONST MUIKEY_DOWN = 3
NATIVE {MUIKEY_PAGEUP}	CONST MUIKEY_PAGEUP = 4
NATIVE {MUIKEY_PAGEDOWN}	CONST MUIKEY_PAGEDOWN = 5
NATIVE {MUIKEY_TOP}	CONST MUIKEY_TOP = 6
NATIVE {MUIKEY_BOTTOM}	CONST MUIKEY_BOTTOM = 7
NATIVE {MUIKEY_LEFT}	CONST MUIKEY_LEFT = 8
NATIVE {MUIKEY_RIGHT}	CONST MUIKEY_RIGHT = 9
NATIVE {MUIKEY_WORDLEFT}	CONST MUIKEY_WORDLEFT = 10
NATIVE {MUIKEY_WORDRIGHT}	CONST MUIKEY_WORDRIGHT = 11
NATIVE {MUIKEY_LINESTART}	CONST MUIKEY_LINESTART = 12
NATIVE {MUIKEY_LINEEND}	CONST MUIKEY_LINEEND = 13
NATIVE {MUIKEY_GADGET_NEXT}	CONST MUIKEY_GADGET_NEXT = 14
NATIVE {MUIKEY_GADGET_PREV}	CONST MUIKEY_GADGET_PREV = 15
NATIVE {MUIKEY_GADGET_OFF}	CONST MUIKEY_GADGET_OFF = 16
NATIVE {MUIKEY_WINDOW_CLOSE}	CONST MUIKEY_WINDOW_CLOSE = 17
NATIVE {MUIKEY_WINDOW_NEXT}	CONST MUIKEY_WINDOW_NEXT = 18
NATIVE {MUIKEY_WINDOW_PREV}	CONST MUIKEY_WINDOW_PREV = 19
NATIVE {MUIKEY_HELP}	CONST MUIKEY_HELP = 20
NATIVE {MUIKEY_POPUP}	CONST MUIKEY_POPUP = 21
NATIVE {MUIKEY_COUNT} CONST MUIKEY_COUNT = 22 /* counter */

NATIVE {MUIKEYF_PRESS}        CONST MUIKEYF_PRESS        = (1 SHL MUIKEY_PRESS)
NATIVE {MUIKEYF_TOGGLE}       CONST MUIKEYF_TOGGLE       = (1 SHL MUIKEY_TOGGLE)
NATIVE {MUIKEYF_UP}           CONST MUIKEYF_UP           = (1 SHL MUIKEY_UP)
NATIVE {MUIKEYF_DOWN}         CONST MUIKEYF_DOWN         = (1 SHL MUIKEY_DOWN)
NATIVE {MUIKEYF_PAGEUP}       CONST MUIKEYF_PAGEUP       = (1 SHL MUIKEY_PAGEUP)
NATIVE {MUIKEYF_PAGEDOWN}     CONST MUIKEYF_PAGEDOWN     = (1 SHL MUIKEY_PAGEDOWN)
NATIVE {MUIKEYF_TOP}          CONST MUIKEYF_TOP          = (1 SHL MUIKEY_TOP)
NATIVE {MUIKEYF_BOTTOM}       CONST MUIKEYF_BOTTOM       = (1 SHL MUIKEY_BOTTOM)
NATIVE {MUIKEYF_LEFT}         CONST MUIKEYF_LEFT         = (1 SHL MUIKEY_LEFT)
NATIVE {MUIKEYF_RIGHT}        CONST MUIKEYF_RIGHT        = (1 SHL MUIKEY_RIGHT)
NATIVE {MUIKEYF_WORDLEFT}     CONST MUIKEYF_WORDLEFT     = (1 SHL MUIKEY_WORDLEFT)
NATIVE {MUIKEYF_WORDRIGHT}    CONST MUIKEYF_WORDRIGHT    = (1 SHL MUIKEY_WORDRIGHT)
NATIVE {MUIKEYF_LINESTART}    CONST MUIKEYF_LINESTART    = (1 SHL MUIKEY_LINESTART)
NATIVE {MUIKEYF_LINEEND}      CONST MUIKEYF_LINEEND      = (1 SHL MUIKEY_LINEEND)
NATIVE {MUIKEYF_GADGET_NEXT}  CONST MUIKEYF_GADGET_NEXT  = (1 SHL MUIKEY_GADGET_NEXT)
NATIVE {MUIKEYF_GADGET_PREV}  CONST MUIKEYF_GADGET_PREV  = (1 SHL MUIKEY_GADGET_PREV)
NATIVE {MUIKEYF_GADGET_OFF}   CONST MUIKEYF_GADGET_OFF   = (1 SHL MUIKEY_GADGET_OFF)
NATIVE {MUIKEYF_WINDOW_CLOSE} CONST MUIKEYF_WINDOW_CLOSE = (1 SHL MUIKEY_WINDOW_CLOSE)
NATIVE {MUIKEYF_WINDOW_NEXT}  CONST MUIKEYF_WINDOW_NEXT  = (1 SHL MUIKEY_WINDOW_NEXT)
NATIVE {MUIKEYF_WINDOW_PREV}  CONST MUIKEYF_WINDOW_PREV  = (1 SHL MUIKEY_WINDOW_PREV)
NATIVE {MUIKEYF_HELP}         CONST MUIKEYF_HELP         = (1 SHL MUIKEY_HELP)
NATIVE {MUIKEYF_POPUP}        CONST MUIKEYF_POPUP        = (1 SHL MUIKEY_POPUP)


/* Some useful shortcuts. define MUI_NOSHORTCUTS to get rid of them */
/* NOTE: These macros may only be used in custom classes and are    */
/* only valid if your class is inbetween the specified methods!     */

#ifndef MUI_NOSHORTCUTS

NATIVE {_app} PROC	->_app(obj)         (muiGlobalInfo(obj)->mgi_ApplicationObject) /* valid between MUIM_Setup/Cleanup */
NATIVE {_win} PROC	->_win(obj)         (muiRenderInfo(obj)->mri_WindowObject)      /* valid between MUIM_Setup/Cleanup */
NATIVE {_dri} PROC	->_dri(obj)         (muiRenderInfo(obj)->mri_DrawInfo)          /* valid between MUIM_Setup/Cleanup */
NATIVE {_screen} PROC	->_screen(obj)      (muiRenderInfo(obj)->mri_Screen)            /* valid between MUIM_Setup/Cleanup */
NATIVE {_pens} PROC	->_pens(obj)        (muiRenderInfo(obj)->mri_Pens)              /* valid between MUIM_Setup/Cleanup */
NATIVE {_window} PROC	->_window(obj)      (muiRenderInfo(obj)->mri_Window)            /* valid between MUIM_Show/Hide */
NATIVE {_rp} PROC	->_rp(obj)          (muiRenderInfo(obj)->mri_RastPort)          /* valid between MUIM_Show/Hide */
NATIVE {_left} PROC	->_left(obj)        (muiAreaData(obj)->mad_Box.Left)            /* valid during MUIM_Draw */
NATIVE {_top} PROC	->_top(obj)         (muiAreaData(obj)->mad_Box.Top)             /* valid during MUIM_Draw */
NATIVE {_width} PROC	->_width(obj)       (muiAreaData(obj)->mad_Box.Width)           /* valid during MUIM_Draw */
NATIVE {_height} PROC	->_height(obj)      (muiAreaData(obj)->mad_Box.Height)          /* valid during MUIM_Draw */
NATIVE {_right} PROC	->_right(obj)       (_left(obj)+_width(obj)-1)                  /* valid during MUIM_Draw */
NATIVE {_bottom} PROC	->_bottom(obj)      (_top(obj)+_height(obj)-1)                  /* valid during MUIM_Draw */
NATIVE {_addleft} PROC	->_addleft(obj)     (muiAreaData(obj)->mad_addleft  )           /* valid during MUIM_Draw */
NATIVE {_addtop} PROC	->_addtop(obj)      (muiAreaData(obj)->mad_addtop   )           /* valid during MUIM_Draw */
NATIVE {_subwidth} PROC	->_subwidth(obj)    (muiAreaData(obj)->mad_subwidth )           /* valid during MUIM_Draw */
NATIVE {_subheight} PROC	->_subheight(obj)   (muiAreaData(obj)->mad_subheight)           /* valid during MUIM_Draw */
NATIVE {_mleft} PROC	->_mleft(obj)       (_left(obj)+_addleft(obj))                  /* valid during MUIM_Draw */
NATIVE {_mtop} PROC	->_mtop(obj)        (_top(obj)+_addtop(obj))                    /* valid during MUIM_Draw */
NATIVE {_mwidth} PROC	->_mwidth(obj)      (_width(obj)-_subwidth(obj))                /* valid during MUIM_Draw */
NATIVE {_mheight} PROC	->_mheight(obj)     (_height(obj)-_subheight(obj))              /* valid during MUIM_Draw */
NATIVE {_mright} PROC	->_mright(obj)      (_mleft(obj)+_mwidth(obj)-1)                /* valid during MUIM_Draw */
NATIVE {_mbottom} PROC	->_mbottom(obj)     (_mtop(obj)+_mheight(obj)-1)                /* valid during MUIM_Draw */
NATIVE {_font} PROC	->_font(obj)        (muiAreaData(obj)->mad_Font)                /* valid between MUIM_Setup/Cleanup */
NATIVE {_minwidth} PROC	->_minwidth(obj)    (muiAreaData(obj)->mad_MinMax.MinWidth)     /* valid between MUIM_Show/Hide */
NATIVE {_minheight} PROC	->_minheight(obj)   (muiAreaData(obj)->mad_MinMax.MinHeight)    /* valid between MUIM_Show/Hide */
NATIVE {_maxwidth} PROC	->_maxwidth(obj)    (muiAreaData(obj)->mad_MinMax.MaxWidth)     /* valid between MUIM_Show/Hide */
NATIVE {_maxheight} PROC	->_maxheight(obj)   (muiAreaData(obj)->mad_MinMax.MaxHeight)    /* valid between MUIM_Show/Hide */
NATIVE {_defwidth} PROC	->_defwidth(obj)    (muiAreaData(obj)->mad_MinMax.DefWidth)     /* valid between MUIM_Show/Hide */
NATIVE {_defheight} PROC	->_defheight(obj)   (muiAreaData(obj)->mad_MinMax.DefHeight)    /* valid between MUIM_Show/Hide */
NATIVE {_flags} PROC	->_flags(obj)       (muiAreaData(obj)->mad_Flags)

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
#define _right(obj)       (_left(obj)+_width(obj)-1 !!INT)          /* valid during MUIM_Draw */
#define _bottom(obj)      (_top(obj)+_height(obj)-1 !!INT)          /* valid during MUIM_Draw */
#define _addleft(obj)     muiAreaData(obj).mad_addleft              /* valid during MUIM_Draw */
#define _addtop(obj)      muiAreaData(obj).mad_addtop               /* valid during MUIM_Draw */
#define _subwidth(obj)    muiAreaData(obj).mad_subwidth             /* valid during MUIM_Draw */
#define _subheight(obj)   muiAreaData(obj).mad_subheight            /* valid during MUIM_Draw */
#define _mleft(obj)       (_left(obj)+_addleft(obj) !!INT)          /* valid during MUIM_Draw */
#define _mtop(obj)        (_top(obj)+_addtop(obj) !!INT)            /* valid during MUIM_Draw */
#define _mwidth(obj)      (_width(obj)-_subwidth(obj) !!INT)        /* valid during MUIM_Draw */
#define _mheight(obj)     (_height(obj)-_subheight(obj) !!INT)      /* valid during MUIM_Draw */
#define _mright(obj)      (_mleft(obj)+_mwidth(obj)-1 !!INT)        /* valid during MUIM_Draw */
#define _mbottom(obj)     (_mtop(obj)+_mheight(obj)-1 !!INT)        /* valid during MUIM_Draw */
#define _font(obj)        muiAreaData(obj).mad_font                 /* valid between MUIM_Setup/Cleanup */
#define _minwidth(obj)    muiAreaData(obj).mad_minmax.minwidth      /* valid between MUIM_Show/Hide */
#define _minheight(obj)   muiAreaData(obj).mad_minmax.minheight     /* valid between MUIM_Show/Hide */
#define _maxwidth(obj)    muiAreaData(obj).mad_minmax.maxwidth      /* valid between MUIM_Show/Hide */
#define _maxheight(obj)   muiAreaData(obj).mad_minmax.maxheight     /* valid between MUIM_Show/Hide */
#define _defwidth(obj)    muiAreaData(obj).mad_minmax.defwidth      /* valid between MUIM_Show/Hide */
#define _defheight(obj)   muiAreaData(obj).mad_minmax.defheight     /* valid between MUIM_Show/Hide */
#define _flags(obj)       muiAreaData(obj).mad_flags                

#endif



/* MUI_CustomClass returned by MUI_CreateCustomClass() */

NATIVE {MUI_CustomClass} OBJECT mui_customclass
	{mcc_UserData}	mcc_userdata	:APTR                  /* use for whatever you want */

	{mcc_UtilityBase}	mcc_utilitybase	:PTR TO lib    /* MUI has opened these libraries */
	{mcc_DOSBase}	mcc_dosbase	:PTR TO lib        /* for you automatically. You can */
	{mcc_GfxBase}	mcc_gfxbase	:PTR TO lib        /* use them or decide to open     */
	{mcc_IntuitionBase}	mcc_intuitionbase	:PTR TO lib  /* your libraries yourself.       */

	{mcc_Super}	mcc_super	:PTR TO iclass           /* pointer to super class   */
	{mcc_Class}	mcc_class	:PTR TO iclass           /* pointer to the new class */

	/* ... private data follows ... */
ENDOBJECT
