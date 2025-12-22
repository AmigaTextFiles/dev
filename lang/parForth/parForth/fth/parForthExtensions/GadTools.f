include? API.f parForthExtensions/API.f

ANEW GadTools.f

\ GadTools Gadgets ************************************************************
\ this program is relocateable so can be compiled, cloned, or turnkeyed
\ the word MAIN runs the demo
\ AROS structures are extracted from the freeware 'JForth for the Amiga' AmigaDos 2.0 include files (.j)
\ JForth can be downloaded from http://www.softsynth.com/jforth
\ words to parse these structures are defined in parForthExt.f

\ libraries ===================================================================
	\ libraries are defined in API.f
	\ example: " intuition.library" 0 LIBRARY IntuitionBase
		\ this defines IntuitionBase for calling Intuition functions and adds it to the library list
		\ the zero means we'll accept any version of the library
	\ Libraries is a list of parForth library structures
	\ libraries will open themselves when one of their functions is called
	\ -1 IntuitionBase will close the intuition library
	\ libEnd closes all open libraries; it is a part of auto.term on BYE
	\ AROS function names are prefixed with an underscore
	\ : _DisplayBeep 0 16 IntuitionBase CALL1NR ;
		\ DisplayBeep is an intuition function which flashes the display
		\ it is function number 16 of the intuition library
		\ CALL1NR expects one parameter (screen) on the stack and provides no return value
		\ CALL3 expects 3 parameters on the stack and will return a value on the stack
	\ AROS function numbers can be found by library and function name in the AROS/rom directory of the SDK
	\ https://d0.se/docs is an excellent reference for Autodocs and Include files for AmigaDOS
	\ the AROS development site is more specific to AROS, however, as there are some differences that bite
		
\ ports =======================================================================
	\ ports are defined in API.f
	\ example: PORT WindowPort DOES HandleWindows
		\ this creates a named parForth port (pfPort structure) in the dictionary that handles all windows' events
		\ it is added to the ports list
		\ the word WindowPort makes it the active port for further manipulation
	\ Ports is a list of parForth ports
	\ P returns the active parForth port instance
	\ MP returns the AROS message port associated with P
	\ pOpen creates and opens an AROS port for P
	\ pClose closes and deletes MP
	\ pEnd closes all ports; it is part of auto.term on BYE
	\ all ports should be opened before you start listening for messages
	\ LISTEN waits for a message for any port in the Ports list
	\ when a message arrives, it calls the appropriate port handler (HandleWindows for the example port)
	\ LISTENING OFF disables the LISTEN loop

\ fonts =======================================================================
\ fonts are defined in GadTools.f
\ example: " arial.font" 15 FS_NORMAL FONT Arial15
	\ this creates a parForth font structure and adds it to the list called Fonts
	\ Arial15 makes this the current font
	\ Menus and gadgets look at the current font when defined for use when displayed
	\ ScreenFont makes the screen font current (user selected via font preferences)
	\ font styles FS_ITALIC, FS_BOLD, and FS_UNDERLINED are also possible instead of FS_NORMAL

\ windows =====================================================================
	\ windows are defined in GadTools.f
	\ example: " GadTools Gadgets" WINDOW MyWindow
		\ this creates a named parForth window (pfWindow structure) in the dictionary entitled "GadTools Gadgets"
		\ it is added to the windows list
		\ the word MyWindow makes it the active window for further manipulation
	\ Windows is a list of parForth windows
	\ W returns the current parForth window
	\ WD returns the AROS window for W
	\ pfWindow is the parForth window structure
		\ w_Next points to next window in Windows list
		\ w_WD points to open AROS window (null if not open)
		\ w_Events is a switch for IDCMP events and their handlers (Events ... Events.End)
		\ w_Menus is a pointer to an an array of GadTools NewMenu structures (Menus ... Menus.End)
		\ w_MenuFont points to the parForth font to use for menu rendering
		\ w_Gadgets is a list of GadTools NewGadget structures (Gadgets ... Gadgets.End)
		\ w_Title points to the null-terminated window title for the AROS window
		\ w_GList is the context for creating gadgets; points to first of the AROS gadgets for WD
	\ wOpen opens the AROS window on the public screen for W using the DefaultWindow AROS NewWindow structure
		\ with user-defined port (pOpen), menus (mOpen), gadgets (gOpen), and window events (EventsOn)
		\ example: MyWindow Bordered #CENTER #CENTER 50 %scSize wOpen
		\ template: window_flags left top width height wOpen
		\ window_flags Bordered or Backdrop are two predefined window types
		\ can use constants #LEFT, #RIGHT, #CENTER for left
		\ can use constants #TOP, #BOTTOM, #CENTER for top
		\ %scSize can be used to create width and height based upon a percentage of screen size
			\ same for $scWidth or %scHeight
	\ wClose closes/frees WD including menus (mClose) and gadgets (gFree)
	\ wEnd closes all open windows, frees VisualInfo (viFree), and unlocks screen (scFree)
		\ it is part of auto.term on BYE
	\ wChange ( left top width height -- ) changes the position and size of W; position constants can be used
	\ wMove   ( left top -- ) changes the position of W; position constants can be used
	\ w+Move  ( dX dY -- ) changes the position of W by delta amounts
	\ wSize	  ( width height -- ) changes the size of W

\ menus ---------------------------------------------------------------------------------
\ EZMenu definitions compile an array of GadTools NewMenu structures in the dictionary for W
	\ Menus starts then menu definition for W
	\ Menu", Item", and Sub" with CommKey and Bar define layout
	\ DOES (or DO ;DO pair) defines action for that menu item
	\ Menus.End ends menu definition for W
	\ mOpen creates/activates Intuition menu system as called in wOpen
	\ mClose deactivates/frees Intuition menu system as called in wClose

\ gadgets -------------------------------------------------------------------------------
\ EZGadget definitions compile a list of GadTools NewGadget structures in the dictionary for W
	\ Gadgets begins the definition of gadgets for W
	\ Gadgets.End finishes the definition of gadgets for W
	\ Cycle, ListView, and MX (radio) gadgets require a list of choices
		\ Choices begins the compilation of the choice list for the preceding gadget
		\ Choice" defines the name of a choice
		\ Choices.End finishes the compilation of choices for the preceeding gadget
	\ Button, Checkbox, Cycle, Listview, MX, AString, Integer, Slider, and Palette gadgets all end with
		\ DOES (or a DO: ;DO pair) to define the action for when the gadget is clicked
	\ AText, Label, and Number gadgets are read only so have no action to define
	\ all gadget definitions require left, top, width, height, title as the first parameters on the stack
	\ look at the bottom of GadTools.f for the window, menu, and gadget definitions for this GadTools demo
	\ string gadgets are defined with ASTRING (AROS STRING) so as not to conflict with the parForth word STRING
	\ text gadgets are defined with ATEXT (AROS TEXT) so as not to conflict with the parForth word TEXT
	\ the specific syntax for defining each gadget kind follows:
		\ l t w h " title"                 BUTTON   name        DOES|DO:_;DO
		\ l t w h " title"                 CHECKBOX name ON|OFF DOES|DO:_;DO
		\ l t w h " title"                 MX       name        DOES|DO:_;DO Choices Choice" ... Choices.End
		\ l t w h " title"                 CYCLE    name        DOES|DO:_;DO Choices Choice" ... Choices.End
		\ l t w h " title"                 LISTVIEW name        DOES|DO:_;DO Choices Choice" ... Choices.End
		\ l t w h " title" Default" Hello" ASTRING  name        DOES|DO:_;DO
		\ l t w h " title" Default" Hello" ATEXT    name
		\ l t w h " Hello"                 LABEL    name
		\ l t w h " title"               n INTEGER  name        DOES|DO:_;DO
		\ l t w h " title"               n NUMBER   name
		\ l t w h " title" #pens start_pen PALETTE  name        DOES|DO:_;DO
		\ Vertical ON|OFF
		\ l t w h " title" min max level n SLIDER   name        DOES|DO:_;DO
	\ changing gadget actions post-definition
		\ GADGET name DOES|DO:_;DO
	\ getting and setting gadget attributes programmatically
		\ attributes that can be get/set are indicated in the TagList definitions for each gadget kind in GadTools.f
		\ invoking the name of a gadget leaves its AROS gadget address on the stack
		\ if we have a Cycle gadget named CY1
			\ CY1 GTCY_Active gGet will leave the active entry for this cycle gadget on the stack
			\ the major attribute for each kind of gadget is named Choice so you don't need to remember the tag names
			\ so the above example can also be written CY1 Choice gGet; the same for all other gadget kinds
			\ 3 CY1 Choice gSet will change the active entry in the cycle gadget named CY1 to 3
			\ FALSE CB1 Choice gSet will uncheck the checkbox named CB1, TRUE will check the checkbox 
			\ getting/setting other attributes will require that you know the tag name

\ AROS GadTools bugs
\ GT_GetGadgetAttrsA returns wrong number of tags processed in some cases so return value is ignored.
\ String gadget trashes display if string is longer than width of string box and you cursor left to get to start of string

\ todo
\ automate shortcut keys for gadget activation
\ use Zune windows, menus, and gadgets
\ provide JForth include files
\ can't provide until parForth NODE is renamed and Amiga Node is replaced with AROS Node

\ Needed structures (from JForth) *********************************************
:STRUCT ScreenAbrv	\ Intuition/screens.j -------------------------------------
	APTR	sc_NextScreen
    APTR	sc_FirstWindow
    SHORT	sc_LeftEdge
    SHORT	sc_TopEdge
    SHORT	sc_Width
    SHORT	sc_Height
    SHORT	sc_MouseY
    SHORT	sc_MouseX
    USHORT	sc_Flags
    APTR 	sc_Title
    APTR 	sc_DefaultTitle
    BYTE 	sc_BarHeight
    BYTE 	sc_BarVBorder
    BYTE 	sc_BarHBorder
    BYTE 	sc_MenuVBorder
    BYTE 	sc_MenuHBorder
    BYTE 	sc_WBorTop
    BYTE 	sc_WBorLeft
    BYTE 	sc_WBorRight
    BYTE 	sc_WBorBottom
    APTR 	sc_Font
    APTR    sc_ViewPort ( not a ptr but start of a ViewPort structure )
\ and so on
;STRUCT
\ NewWindow types
$ 0001 CONSTANT WBENCHSCREEN
$ 0002 CONSTANT PUBLICSCREEN
$ 000F CONSTANT CUSTOMSCREEN

:STRUCT Window	\ jForth Intuition/intuition.j -----------------------------------------
    APTR	wd_NextWindow
    SHORT 	wd_LeftEdge
    SHORT 	wd_TopEdge
    SHORT 	wd_Width
    SHORT 	wd_Height
    SHORT 	wd_MouseY
    SHORT 	wd_MouseX
    SHORT 	wd_MinWidth
    SHORT 	wd_MinHeight
    USHORT 	wd_MaxWidth
    USHORT 	wd_MaxHeight
    ULONG 	wd_Flags
    APTR 	wd_MenuStrip
    APTR 	wd_Title
    APTR 	wd_FirstRequest
    APTR 	wd_DMRequest
    SHORT 	wd_ReqCount
    APTR 	wd_WScreen
    APTR 	wd_RPort
    BYTE 	wd_BorderLeft
    BYTE 	wd_BorderTop
    BYTE 	wd_BorderRight
    BYTE 	wd_BorderBottom
    APTR 	wd_BorderRPort
    APTR 	wd_FirstGadget
    APTR 	wd_Parent
    APTR 	wd_Descendant
    APTR 	wd_Pointer
    BYTE 	wd_PtrHeight
    BYTE 	wd_PtrWidth
    BYTE 	wd_XOffset
    BYTE 	wd_YOffset
    ULONG 	wd_IDCMPFlags
    APTR 	wd_UserPort
    APTR 	wd_WindowPort
    APTR 	wd_MessageKey
    UBYTE 	wd_DetailPen
    UBYTE 	wd_BlockPen
    APTR 	wd_CheckMark
    APTR 	wd_ScreenTitle
    SHORT 	wd_GZZMouseX
    SHORT 	wd_GZZMouseY
    SHORT 	wd_GZZWidth
    SHORT 	wd_GZZHeight
    APTR 	wd_ExtData
    APTR 	wd_UserData
    APTR 	wd_WLayer
    APTR 	wd_IFont
    ULONG 	wd_MoreFlags
;STRUCT

:STRUCT NewWindow
	SHORT 	nw_LeftEdge
	SHORT 	nw_TopEdge
    SHORT 	nw_Width
    SHORT 	nw_Height
    UBYTE 	nw_DetailPen
    UBYTE 	nw_BlockPen
    ULONG 	nw_IDCMPFlags
    ULONG 	nw_Flags
    APTR 	nw_FirstGadget
    APTR 	nw_CheckMark
    APTR 	nw_Title
    APTR 	nw_Screen
    APTR 	nw_BitMap
    SHORT 	nw_MinWidth
    SHORT 	nw_MinHeight
    USHORT  nw_MaxWidth
    USHORT  nw_MaxHeight
    USHORT  nw_Type
;STRUCT
$ 00000001 CONSTANT WFLG_SIZEGADGET
$ 00000002 CONSTANT WFLG_DRAGBAR
$ 00000004 CONSTANT WFLG_DEPTHGADGET
$ 00000008 CONSTANT WFLG_CLOSEGADGET
$ 00000010 CONSTANT WFLG_SIZEBRIGHT
$ 00000020 CONSTANT WFLG_SIZEBBOTTOM
$ 00000400 CONSTANT WFLG_GIMMEZEROZERO
$ 00000000 CONSTANT WFLG_SMART_REFRESH
$ 00000040 CONSTANT WFLG_SIMPLE_REFRESH
$ 00000080 CONSTANT WFLG_SUPER_BITMAP
$ 000000C0 CONSTANT WFLG_OTHER_REFRESH
$ 00000100 CONSTANT WFLG_BACKDROP
$ 00000800 CONSTANT WFLG_BORDERLESS
$ 00000200 CONSTANT WFLG_REPORTMOUSE
$ 00001000 CONSTANT WFLG_ACTIVATE
$ 00010000 CONSTANT WFLG_RMBTRAP
$ 00020000 CONSTANT WFLG_NOCAREREFRESH
$ 00200000 CONSTANT WFLG_NEWLOOKMENUS

:STRUCT IntuiMessage
    STRUCT Message im_ExecMessage
    ULONG 	im_Class
    USHORT 	im_Code
    USHORT 	im_Qualifier
    APTR 	im_IAddress
    SHORT 	im_MouseX
    SHORT 	im_MouseY
    ULONG 	im_Seconds
    ULONG 	im_Micros
    APTR 	im_IDCMPWindow
    APTR 	im_SpecialLink
;STRUCT
$ 00000001 CONSTANT IDCMP_SIZEVERIFY
$ 00000002 CONSTANT IDCMP_NEWSIZE
$ 00000004 CONSTANT IDCMP_REFRESHWINDOW
$ 00000008 CONSTANT IDCMP_MOUSEBUTTONS
$ 00000010 CONSTANT IDCMP_MOUSEMOVE
$ 00000020 CONSTANT IDCMP_GADGETDOWN
$ 00000040 CONSTANT IDCMP_GADGETUP
$ 00000080 CONSTANT IDCMP_REQSET
$ 00000100 CONSTANT IDCMP_MENUPICK
$ 00000200 CONSTANT IDCMP_CLOSEWINDOW
$ 00000400 CONSTANT IDCMP_RAWKEY
$ 00000800 CONSTANT IDCMP_REQVERIFY
$ 00001000 CONSTANT IDCMP_REQCLEAR
$ 00002000 CONSTANT IDCMP_MENUVERIFY
$ 00004000 CONSTANT IDCMP_NEWPREFS
$ 00008000 CONSTANT IDCMP_DISKINSERTED
$ 00010000 CONSTANT IDCMP_DISKREMOVED
$ 00020000 CONSTANT IDCMP_WBENCHMESSAGE
$ 00040000 CONSTANT IDCMP_ACTIVEWINDOW
$ 00080000 CONSTANT IDCMP_INACTIVEWINDOW
$ 00100000 CONSTANT IDCMP_DELTAMOVE
$ 00200000 CONSTANT IDCMP_VANILLAKEY
$ 00400000 CONSTANT IDCMP_INTUITICKS
$ 00800000 CONSTANT IDCMP_IDCMPUPDATE
$ 01000000 CONSTANT IDCMP_MENUHELP
$ 02000000 CONSTANT IDCMP_CHANGEWINDOW
$ 04000000 CONSTANT IDCMP_GADGETHELP

:STRUCT Menu
	APTR	mu_NextMenu
    SHORT	mu_LeftEdge
    SHORT	mu_TopEdge
    SHORT	mu_Width
    SHORT	mu_Height
	USHORT	mu_Flags
    APTR	mu_MenuName
    APTR	mu_FirstItem
    SHORT	mu_JazzX
    SHORT	mu_JazzY
    SHORT	mu_BeatX
    SHORT	mu_BeatY
;STRUCT
$ 0001   constant MENUENABLED
$ 0100   constant MIDRAWN
$ FFFF   constant MENUNULL

:STRUCT MenuItem
	APTR	mi_NextItem
    SHORT	mi_LeftEdge
    SHORT	mi_TopEdge
    SHORT	mi_Width
    SHORT	mi_Height
    USHORT	mi_Flags
    LONG	mi_MutualExclude
    APTR	mi_ItemFill
    APTR	mi_SelectFill
    BYTE	mi_Command
    APTR	mi_SubItem
    USHORT	mi_NextSelect		\ ndh 11/27/2022 seems off; works if you subtract 2 from offset
;STRUCT
$ 0001   constant CHECKIT
$ 0002   constant ITEMTEXT
$ 0004   constant COMMSEQ
$ 0008   constant MENUTOGGLE
$ 0010   constant ITEMENABLED
$ 0100   constant CHECKED
$ 00C0   constant HIGHFLAGS
$ 0000   constant HIGHIMAGE
$ 0040   constant HIGHCOMP
$ 0080   constant HIGHBOX
$ 00C0   constant HIGHNONE
$ 1000   constant ISDRAWN
$ 2000   constant HIGHITEM
$ 4000   constant MENUTOGGLED

:STRUCT Gadget
	APTR	gg_NextGadget
    SHORT 	gg_LeftEdge
    SHORT 	gg_TopEdge
    SHORT 	gg_Width
    SHORT 	gg_Height
    USHORT 	gg_Flags
    USHORT 	gg_Activation
    USHORT 	gg_GadgetType
    APTR 	gg_GadgetRender
    APTR 	gg_SelectRender
    APTR 	gg_GadgetText
    LONG 	gg_MutualExclude
    APTR 	gg_SpecialInfo		\ pointer to a StringInfo structure (below) for string gadgets (maybe for integer too)
    USHORT 	gg_GadgetID
    APTR 	gg_UserData
;STRUCT

:STRUCT StringInfo		\ intuition/intuition.j
    APTR si_Buffer		\ can read this buffer if user doesn't press enter on string gadget	
    APTR si_UndoBuffer	
    SHORT si_BufferPos	
    SHORT si_MaxChars	
    SHORT si_DispPos	
    SHORT si_UndoPos	
    SHORT si_NumChars	
    SHORT si_DispCount	
    SHORT si_CLeft
    SHORT si_CTop	
    APTR si_Extension
    LONG si_LongInt
    APTR si_AltKeyMap
;STRUCT

:STRUCT NewMenu \ GadTools ----------------------------------------------------
    UBYTE	nm_Type
    APTR	nm_Label
    APTR	nm_CommKey
    USHORT	nm_Flags
    LONG	nm_MutualExclude
    APTR	nm_UserData
;STRUCT
128	CONSTANT MENU_IMAGE
0   CONSTANT NM_END
1   CONSTANT NM_TITLE
2   CONSTANT NM_ITEM
3   CONSTANT NM_SUB
64  constant NM_IGNORE
MENUENABLED constant NM_MENUDISABLED
ITEMENABLED constant NM_ITEMDISABLED
COMMSEQ		constant NM_COMMANDSTRING
1 31 << 			constant TAG_USER
TAG_USER  $ 80000 + constant GT_TagBase
GT_TagBase  49 +  	constant GTMN_TextAttr
GT_TagBase  50 +  	constant GTMN_FrontPen

:STRUCT NewGadget
    SHORT	ng_LeftEdge
    SHORT	ng_TopEdge
    SHORT	ng_Width
    SHORT	ng_Height
    APTR	ng_GadgetText
    APTR	ng_TextAttr
    USHORT	ng_GadgetID
    ULONG	ng_Flags
    APTR	ng_VisualInfo
    APTR	ng_UserData
;STRUCT
0   constant GENERIC_KIND
1   constant BUTTON_KIND
2   constant CHECKBOX_KIND
3   constant INTEGER_KIND
4   constant LISTVIEW_KIND
5   constant MX_KIND
6   constant NUMBER_KIND
7   constant CYCLE_KIND
8   constant PALETTE_KIND
9   constant SCROLLER_KIND
11  constant SLIDER_KIND
12  constant STRING_KIND
13  constant TEXT_KIND
14  constant NUM_KINDS
IDCMP_INTUITICKS IDCMP_MOUSEBUTTONS |
IDCMP_GADGETUP | IDCMP_GADGETDOWN | constant ARROWIDCMP
IDCMP_GADGETUP   constant BUTTONIDCMP
IDCMP_GADGETUP   constant CHECKBOXIDCMP
IDCMP_GADGETUP   constant INTEGERIDCMP
IDCMP_GADGETUP  IDCMP_GADGETDOWN |
IDCMP_MOUSEMOVE | ARROWIDCMP | constant LISTVIEWIDCMP
IDCMP_GADGETDOWN   constant MXIDCMP
0  constant NUMBERIDCMP
IDCMP_GADGETUP   constant CYCLEIDCMP
IDCMP_GADGETUP   constant PALETTEIDCMP
IDCMP_GADGETUP  IDCMP_GADGETDOWN | IDCMP_MOUSEMOVE |  constant SCROLLERIDCMP
IDCMP_GADGETUP  IDCMP_GADGETDOWN | IDCMP_MOUSEMOVE |  constant SLIDERIDCMP
IDCMP_GADGETUP   constant STRINGIDCMP
0  constant TEXTIDCMP

$ 0001   constant PLACETEXT_LEFT
$ 0002   constant PLACETEXT_RIGHT
$ 0004   constant PLACETEXT_ABOVE
$ 0008   constant PLACETEXT_BELOW
$ 0010   constant PLACETEXT_IN
$ 0020   constant NG_HIGHLABEL

\ gadget attributes for set or get
TAG_USER  $ 30000 +  constant GA_Dummy	\ Intuition/GadgetClass
GA_Dummy  $ 000E +  constant GA_Disabled
GA_Dummy  $ 0015 +  constant GA_Immediate
GA_Dummy  $ 0016 +  constant GA_RelVerify
GA_Dummy  $ 0024 +  constant GA_TabCycle
GT_TagBase  64 +  constant GT_Underscore
GT_TagBase  4 +  constant GTCB_Checked
GT_TagBase  68 +  constant GTCB_Scaled
GT_TagBase  14 +  constant GTCY_Labels
GT_TagBase  15 +  constant GTCY_Active
GT_TagBase  9 +  constant GTMX_Labels
GT_TagBase  10 +  constant GTMX_Active
GT_TagBase  61 +  constant GTMX_Spacing
GT_TagBase  69 +  constant GTMX_Scaled
GT_TagBase  71 +  constant GTMX_TitlePlace
GT_TagBase  5 +  constant GTLV_Top
GT_TagBase  6 +  constant GTLV_Labels
GT_TagBase  7 +  constant GTLV_ReadOnly
GT_TagBase  8 +  constant GTLV_ScrollWidth
GT_TagBase  53 +  constant GTLV_ShowSelected
GT_TagBase  54 +  constant GTLV_Selected
GT_TagBase  78 +  constant GTLV_MakeVisible
GT_TagBase  79 +  constant GTLV_ItemHeight
GT_TagBase  83 +  constant GTLV_CallBack
GT_TagBase  84 +  constant GTLV_MaxPen
GT_TagBase  47 +  constant GTIN_Number
GT_TagBase  48 +  constant GTIN_MaxChars
GT_TagBase  45 +  constant GTST_String
GT_TagBase  46 +  constant GTST_MaxChars
GT_TagBase  11 +  constant GTTX_Text
GT_TagBase  12 +  constant GTTX_CopyText
GT_TagBase  57 +  constant GTTX_Border
GT_TagBase  72 +  constant GTTX_FrontPen
GT_TagBase  73 +  constant GTTX_BackPen
GT_TagBase  74 +  constant GTTX_Justification
GT_TagBase  13 +  constant GTNM_Number
GT_TagBase  58 +  constant GTNM_Border
GT_TagBase  72 +  constant GTNM_FrontPen
GT_TagBase  73 +  constant GTNM_BackPen
GT_TagBase  74 +  constant GTNM_Justification
GT_TagBase  75 +  constant GTNM_Format
GT_TagBase  76 +  constant GTNM_MaxNumberLen
GT_TagBase  85 +  constant GTNM_Clipped
GT_TagBase  38 +  constant GTSL_Min
GT_TagBase  39 +  constant GTSL_Max
GT_TagBase  40 +  constant GTSL_Level
GT_TagBase  41 +  constant GTSL_MaxLevelLen
GT_TagBase  42 +  constant GTSL_LevelFormat
GT_TagBase  43 +  constant GTSL_LevelPlace
GT_TagBase  44 +  constant GTSL_DispFunc
GT_TagBase  80 +  constant GTSL_MaxPixelLen
GT_TagBase  81 +  constant GTSL_Justification
GT_TagBase  16 +  constant GTPA_Depth
GT_TagBase  17 +  constant GTPA_Color
GT_TagBase  18 +  constant GTPA_ColorOffset
GT_TagBase  19 +  constant GTPA_IndicatorWidth
GT_TagBase  20 +  constant GTPA_IndicatorHeight
GT_TagBase  70 +  constant GTPA_NumColors
GT_TagBase  82 +  constant GTPA_ColorTable

0   constant GTJ_LEFT
1   constant GTJ_RIGHT
2   constant GTJ_CENTER

TAG_USER  $ 32000 +  constant STRINGA_Dummy
STRINGA_Dummy  $ 0001 +  constant STRINGA_MaxChars
STRINGA_Dummy  $ 0002 +  constant STRINGA_Buffer
STRINGA_Dummy  $ 0003 +  constant STRINGA_UndoBuffer
STRINGA_Dummy  $ 0004 +  constant STRINGA_WorkBuffer
STRINGA_Dummy  $ 0005 +  constant STRINGA_BufferPos
STRINGA_Dummy  $ 0006 +  constant STRINGA_DispPos
STRINGA_Dummy  $ 0007 +  constant STRINGA_AltKeyMap
STRINGA_Dummy  $ 0008 +  constant STRINGA_Font
STRINGA_Dummy  $ 0009 +  constant STRINGA_Pens
STRINGA_Dummy  $ 000A +  constant STRINGA_ActivePens
STRINGA_Dummy  $ 000B +  constant STRINGA_EditHook
STRINGA_Dummy  $ 000C +  constant STRINGA_EditModes
STRINGA_Dummy  $ 000D +  constant STRINGA_ReplaceMode
STRINGA_Dummy  $ 000E +  constant STRINGA_FixedFieldMode
STRINGA_Dummy  $ 000F +  constant STRINGA_NoFilterMode
STRINGA_Dummy  $ 0010 +  constant STRINGA_Justification	
STRINGA_Dummy  $ 0011 +  constant STRINGA_LongVal
STRINGA_Dummy  $ 0012 +  constant STRINGA_TextVal
STRINGA_Dummy  $ 0013 +  constant STRINGA_ExitHelp

$ 0000   constant GACT_STRINGLEFT
$ 0200   constant GACT_STRINGCENTER
$ 0400   constant GACT_STRINGRIGHT
$ 0800   constant GACT_LONGINT

TAG_USER  $ 31000 +  constant PGA_Dummy
PGA_Dummy  $ 0001 +  constant PGA_Freedom

0   constant LORIENT_NONE
1   constant LORIENT_HORIZ
2   constant LORIENT_VERT

:STRUCT TextAttr \ Graphics/Text -----------------------------------------------
	APTR	ta_Name
	USHORT	ta_YSize
	UBYTE	ta_Style
	UBYTE	ta_Flags
;STRUCT
0	   constant FS_NORMAL
$ 01   constant FSF_UNDERLINED
$ 02   constant FSF_BOLD
$ 04   constant FSF_ITALIC
$ 02   constant FPF_DISKFONT
$ 20   constant FPF_PROPORTIONAL
$ 40   constant FPF_DESIGNED
1 7 << constant FPF_REMOVED

\ parForth Fonts **************************************************************
STRUCTURE pfFont											\ parForth font (o)
	ADDR:	o_Next											\ next pfFont
    	TextAttr
   	STRUCT:	o_TextAttr										\ AROS TextAttr instance
STRUCTURE.END
FPF_DISKFONT FPF_PROPORTIONAL | FPF_DESIGNED | CONSTANT oFLAGS

CREATE Fonts 0 ,											\ font list
CREATE -font 0 ,											\ current pfFont
: oNew    ( mem -- o ) pfFont SWAP MEMORY DUP o_Next Fonts LINK ;
: oFill   ( size style 0$ o -- ) o_TextAttr oFlags OVER S! ta_Flags
	TUCK S! ta_Name TUCK S! ta_Style S! ta_YSize ;
: (FONT)  ( size style 0$ mem -- o ) oNew DUP >R oFill R> ;
: FONT    ( c$ size style -- ) 3 ? ROT $>0$, CREATE DICT (FONT) DROP DOES> ( self -- ) -font R! ;

: ScreenFont ( -- ) -font OFF ;								\ use screen font
" topaz.font" 8 FS_NORMAL FONT Topaz8						\ fallback in ROM on Amiga 68k
" arial.font" 15 FS_NORMAL FONT Arial15						\ std on AROS

\ parForth screens ************************************************************
: _LockPubScreen     ( name -- sc ) 85 IntuitionBase CALL1 ;
: _UnLockPubScreen   ( name, [sc] ) 86 IntuitionBase CALL2NR ;

CREATE -sc 0 ,										\ ptr to public screen to open on
: sc     ( -- sc ) -sc DUP @ 0= IF 0 _LockPubScreen DUP 0= ABORT" No sc" -sc ! THEN @ ;
: scFree ( -- ) -sc @ ?DUP IF 0 SWAP _UnLockPubScreen -sc OFF THEN ;	\ included in wEnd

\ parForth windows ************************************************************
: _ModifyIDCMP     ( wd flags -- f ) 25 IntuitionBase CALL2 ;
: _GT_GetIMsg      ( up -- im ) 12 GadToolsBase CALL1 ;
: _GT_ReplyIMsg    ( im -- ) 13 GadToolsBase CALL1NR ;
: _GT_BeginRefresh ( wd -- ) 15 GadToolsBase CALL1NR ;
: _GT_EndRefresh   ( wd complete -- ) 16 GadToolsBase CALL2NR ;

STRUCTURE pfWindow								\ parForth window
	ADDR: 	w_Next								\ Next pfWindow
	ADDR:  	w_wd								\ AROS window
		2 CELLS									\ switch and ElseXT
	STRUCT:	w_Events							\ window events switch (List & ElseXT)
	ADDR:	w_Menus								\ GadTools NewMenu array (CELL+)
	ADDR:	w_mFont								\ pfFont for menu rendering		\ required because first menu fails so can't cancel -font only this
	ADDR:	w_Gadgets							\ GadTools pfNewGadget list
	ADDR:	w_Title								\ 0$ title
	ADDR:	w_Glist								\ context for creating AROS gadgets; pointer to wd wd_FirstGadget						
STRUCTURE.END

CREATE Windows 0 ,											\ parForth windows list
CREATE -w 0 ,												\ ptr to current parForth window
: w    ( -- w  ) -w @ DUP 0= ABORT" No parForth window" ;	\ current parForth window
: wd   ( -- wd ) w w_wd @ ; 								\ current AROS window
: wd>w ( wd -- w ) [ 0 w_wd ] LITERAL Windows PERUSE -w ! ;

: evRefresh ( -- ) wd DUP _GT_BeginRefresh TRUE _GT_EndRefresh ;
: wEV		( -- )	\ install default handlers; superceded via Events ... Events.End
	w w_Events IDCMP_RefreshWindow ['] evRefresh +SWITCH
	w w_Events IDCMP_CloseWindow   ['] BYE +SWITCH ;
: wNew      ( mem -- w ) pfWindow SWAP MEMORY DUP w_Next Windows LINK ;
: wFill     ( 0$ w -- ) TUCK S! w_Title ['] ~SWITCH SWAP w_Events CELL+ ! ;
: (WINDOW)  ( 0$ mem -- w ) wNew TUCK wFill DUP -w ! wEV ;
: WINDOW    ( c$ -- ) 1 ? $>0$, CREATE DICT (WINDOW) DROP DOES> ( self -- ) -w ! ;

\ window event handling -------------------------------------------------------
CREATE LastEvent IntuiMessage ALLOT				\ copy of latest event
CREATE LastSelect 0 , 0 ,						\ last LMB time for DblClick calcs
CREATE MouseMoved 0 ,							\ true if MouseMove (MM) event sent

\ the switch (sw) version of DO: ;DO DOES is synonymous with switch words RUN: ;RUN RUNS
: sw>DOES ( -- ) ['] RUNS IS DOES    ['] RUN: IS DO:    ['] ;RUN IS ;DO ; 

: Events	  ( -- Events ) w w_Events sw>DOES ;
: Events.End  ( sw -- ) DROP ;
: EventsOn    ( -- ) w w_Events |SWITCH| ?DUP IF wd SWAP _ModifyIDCMP 0= ABORT" UP err" THEN ;

: CopyEvent   ( im -- ) LastEvent IntuiMessage CMOVE ;
: HandleEvent ( -- ) w LastEvent S@ im_Class w w_Events SWITCH -w ! ;
: HandleMM	  ( -- ) IDCMP_MouseMove LastEvent S! im_Class HandleEvent ;
: HandleWindow ( im.in -- im.out|0 )			\ event stream contiguous to one window
	MouseMoved OFF BEGIN						\ im,	ignore all but final MM coords
	DUP S@ im_IDCMPWindow wd = IF				\ im,	same window?
	DUP CopyEvent _GT_ReplyIMsg					\			yes, copy & reply
	LastEvent S@ im_Class IDCMP_MouseMove = IF	\				MouseMoved?
	MouseMoved ON ELSE HandleEvent THEN			\				flag it else handle event
	mp _GT_GetIMsg DUP 0= ELSE					\ im|0 f,		next event, flag exit if none
	TRUE THEN									\ im f,		no, flag exit
	UNTIL MouseMoved @ IF HandleMM THEN ;		\ im,	?exit and handle MouseMoves
												\ handle all events for all windows
: HandleWindows ( -- ) mp _GT_GetIMsg ?DUP IF	\ GadTools may have handled so skip msg=0
	BEGIN DUP S@ im_IDCMPWindow wd>w HandleWindow ?DUP 0= UNTIL THEN ;

PORT WindowPort DOES HandleWindows				\ IntuiMessage port for all windows

\ GadTools menus and gadgets **************************************************
\ helper words used to define Menu" and Choices" ------------------------------
: TEXT"  ( <xx" -- 0$ ) HERE ," DUP $>0$ ;			\ compile a 0$ at HERE
: TEXTS" ( <xx" qty -- 0$ qty+1 ) TEXT" SWAP 1+ ;	\ compile a 0$ at HERE and increment the cnt

\ save 0$ addresses from stack into memory and leave cnt; the collection of 0$s is terminated by a null
\ this is the way to pass choices for cycle and MX gadgets
: (TEXTS) ( ... qty mem -- ... tl.end qty ) >R 0 SWAP 1+ CELLS R> tlAllocate ;	
: TEXTS   ( <xxx> ... qty -- ) DUP 1+ ? CREATE DICT (TEXTS) tlRFill DROP ( DOES> -- tl ) ;

\ visual info ------------------------------------------------------------------
\ required for GadTools menu and gadget creation
: _GetVisualInfoA ( sc tags -- vi ) 21 GadToolsBase CALL2 ;
: _FreeVisualInfo ( vi -- ) 22 GadToolsBase CALL1NR ;

CREATE -vi 0 ,									\ ptr to GetVisualInfo vi
: vi	 ( -- vi ) -vi DUP @ 0= IF sc 0 _GetVisualInfoA ?DUP 0= ABORT" No vi" OVER ! THEN @ ;
: viFree ( -- ) -vi DUP @ ?DUP IF _FreeVisualInfo THEN OFF ;	\ included in wEnd

\ GadTool Menus ===============================================================
Tags[ GTMN_TextAttr 0 TAG: mt_Font ]Tags (mTags)	\ capability to render in other than the screen font

\ handle menus ----------------------------------------------------------------
: _ItemAddress ( menu menu# -- addr ) 24 IntuitionBase CALL2 ;	\ address of menuitem

: HandleMenu  ( mi -- ) MenuItem + ALIGNED @EXECUTE ;
: HandleMenus ( -- )								\ cycle through all menus (drag) selected
	LastEvent im_Code BEGIN 						\ &Menu#
	W@ DUP MENUNULL = IF DROP 0 THEN ?DUP WHILE		\ Menu#		ndh added menunull check 12/1/2022
	wd S@ wd_MenuStrip SWAP _ItemAddress			\ MenuItem
	DUP HandleMenu mi_NextSelect 2-					\ &Menu#	ndh added "2 -" because MenuItem structure seems off 11/27/2022
	REPEAT ;

\ EZMenu definition -----------------------------------------------------------
4 CONSTANT mParms									\ type 0$ c xt (a set per menu)
CREATE -#Menus 0 ,									\ menu counter
CREATE -bar 0 ,										\ menu type for separator
CREATE -commkey 0 ,									\ command key character
: (#Menus) ( -- 4*#menus ) -commkey OFF -#menus @ mParms * 1 -#Menus +! ;
: #Menus   ( ... -- ... ) (#Menus) mParms 1- + ? ;	\ check that stack has correct number of items
: ?Sub1	   ( -- 0| ) -bar @ NM_ITEM = IF 0 THEN ;
: mEnd	   ( ... -- ... type 0$ 0 0 ) NM_END 0 0 0 (#Menus) mParms + ? ;

: Menu"	   ( <xx" -- type 0$ 0 0 )     NM_ITEM -bar ! NM_TITLE TEXT"          0 #Menus 0 ;
: Item"	   ( <xx" -- type 0$ c )       NM_ITEM -bar ! NM_ITEM  TEXT" -commkey @ #Menus ;
: Sub"	   ( <xx" -- type 0$ c ) ?Sub1 NM_SUB  -bar ! NM_SUB   TEXT" -commkey @ #Menus ;
: Bar	   ( -- type -1 0 0 )                         -bar @   -1             0 #Menus 0 ;
: CommKey  ( -- ) CHAR -commkey ! ;

\ the xt version of DO: ;DO DOES leaves an xt on the stack ( -- xt )
: xt>DOES ( -- ) ['] ' IS DOES    ['] :: IS DO:    ['] ; IS ;DO ;

: mLook  ( -- ) -font @ w S! w_mFont ;
: mEvent ( -- ) w w_Events IDCMP_MENUPICK ['] HandleMenus +SWITCH ;
: Menus	 ( -- ) -#Menus OFF mLook mEvent xt>DOES ;

\ EZMenu instantiation --------------------------------------------------------
CREATE arrCK 0 ,									\ array of CommKeys; 0 delimited
: CommKey>$   ( c xt ck -- 0|ck xt ) ROT DUP IF OVER C! ELSE NIP THEN SWAP ;
: (nmFill)    ( type 0$Name 0|ck xt nm -- ) TUCK S! nm_UserData TUCK S! nm_CommKey
	TUCK S! nm_Label S! nm_Type ;
: nmFill	  ( ... qty -- ) 1- 0 SWAP DO I arrCK @ [] CommKey>$ I w S@ w_Menus [] (nmFill) -1 +LOOP ;
: nmNew		  ( qty mem -- ) NewMenu SWAP (ARRAY) w S! w_Menus ;
: ckNew		  ( qty mem -- ) ( SWAP ) CELL 2/ SWAP (ARRAY) arrCK R! ;	\ ndh 12/7/2022 removed SWAP
: (Menus.End) ( ... qty mem -- ) 2DUP nmNew UNDER ckNew nmFill ;
: Menus.End   ( ... -- ) mEnd -#Menus @ DICT (Menus.End) ;

\ AROS menus from NewMenu array -----------------------------------------------
: _CreateMenusA   ( nm tags -- menu ) 8 GadToolsBase CALL2 ;
: _LayoutMenusA   ( menu vi tags -- f ) 11 GadToolsBase CALL3 ;
: _SetMenuStrip   ( wd menu -- f ) 44 IntuitionBase CALL2 ;
: _ClearMenuStrip ( wd -- ) 9 IntuitionBase CALL1NR ;
: _FreeMenus	  ( menu -- ) 9 GadToolsBase CALL1NR ;

: mMake    ( -- m ) 0 w S@ w_Menus [] 0 _CreateMenusA ?DUP 0= Abort" Bad NewMenus" ;
: mFont    ( -- ) w S@ w_mFont DUP IF o_TextAttr THEN (mTags) S! mt_Font ;
: mTags    ( -- tl ) mFont (mTags) ;
: (mLay)   ( m -- f ) vi mTags _LayoutMenusA ;
: mBadFont ( -- ) w w_mFont OFF ;
: mLay	   ( m -- ) DUP (mLay) 0= IF mBadFont ScreenFont DUP (mLay) 0= ABORT" No menu" THEN DROP ;
: mSet     ( m -- ) wd SWAP _SetMenuStrip 0= ABORT" Can't set menu" ;
: mOpen    ( -- ) w S@ w_Menus IF mMake DUP mLay mSet THEN ;
: mClose   ( -- ) wd S@ wd_MenuStrip ?DUP IF wd _ClearMenuStrip _FreeMenus THEN ;	\ included in wClose

\ EZGadget GadTools Gadgets (all kinds) ================================================
\ parForth gadgets ---------------------------------------------------------------------
STRUCTURE pfGadget									\ parForth gadget (g)
	ADDR:	g_Next									\ Next pfGadget structure
	ADDR:	g_Gad									\ AROS gadget (gad)
	LONG:	g_Kind									\ Gadtools gadget kind
		NewGadget
	STRUCT:	g_ng									\ NewGadget structure
STRUCTURE.END

[SWITCH (gTags) SWITCH]								\ Kind-specific definition taglist switch

DEFER Choices    DEFER Choice"    DEFER Choices.End	\ vectored execution by gadget type for user constancy
0 VALUE Choice										\ vectored execution by gadget type for user constancy
DEFER HandleGadget									\ deferred execution of HandleGadget

\ create a pfGadget structure; fields belonging to a specific gadget kind are not initialized
: gNew     ( size mem -- g ) MEMORY DUP g_Next w w_Gadgets LINK> ;
: gFont    ( g -- ) g_ng -font @ DUP IF o_TextAttr THEN SWAP S! ng_TextAttr ;
: gFill	   ( l t w h 0$ place kind g -- )
	DUP gFont
	TUCK S! g_Kind g_ng
	TUCK S! ng_Flags
	TUCK S! ng_GadgetText
	TUCK S! ng_Height
	TUCK S! ng_Width
	TUCK S! ng_TopEdge
	     S! ng_LeftEdge ;
: (GADGET) ( l t w h 0$title mem size place kind -- g ) 2 ROLL 3 ROLL gNew DUP >R gFill R> ;

: gDo	       ( g attr -- gad ) TO Choice S@ g_Gad ;						\ vector Choice, leave AROS gadget addr
: g>xt         ( g -- &xt ) g_ng ng_UserData ;								\ leave xt addr
: gad>g        ( gad -- g ) [ 0 g_gad ] LITERAL w w_Gadgets PERUSE ;		\ leave pfGadget addr given AROS gadget addr
: gEV          ( IDCMP -- ) w w_Events SWAP ['] HandleGadget +SWITCH ;		\ add switch case to window events switch
: Gadgets	   ( -- ) !>DOES ;												\ begin gadget definition, vector DOES...
: Gadgets.End  ( -- ) w w_Gadgets NODES IF IDCMP_GADGETUP gEV IDCMP_GADGETDOWN gEV THEN ;	\ install gadget event handler
: GADGET       ( <xxx> -- &xt ) OBJ' g>xt !>DOES ;							\ define action post creation

\ EZGadget kinds ====================================================================================
\ EZButtons; left top width height c$title BUTTON <instance name> -----------------------------------

: butSpecs ( g -- &xt ) g>xt ;
: (BUTTON) ( l t w h 0$ mem -- g ) pfGadget PLACETEXT_IN BUTTON_KIND (GADGET) ;
: BUTTON   ( l t w h c$ -- &xt ) 5 ? $>0$, CREATE DICT (BUTTON) butSpecs DOES> FALSE gDo ;

Tags[
	GA_DISABLED 0			TAG: btt_Disabled		\ set
	GT_UNDERSCORE CHAR ^	TAG: btt_Underscore
	GA_IMMEDIATE 0			TAG: btt_Immediate
]TAGS (butTags)
\ todo: Automatic ctrl-char as specified in TEXT" selects gadget

: butTags ( g -- tl ) DROP (butTags) ;				\ but-specific tags
[+SWITCH  (gTags) BUTTON_KIND RUNS butTags SWITCH]

\ EZCheckBoxes; left top width height c$title CHECKBOX <instance name> ON|OFF -----------------------
STRUCTURE pfCheckBox								\ parForth checkbox (cb)
		pfGadget
	STRUCT:	cb_g ( don't use)						\ pfGadget structure (always first)
	LONG:	cb_Checked								\ initial state
STRUCTURE.END
: cbSpecs    ( g -- &xt &on ) DUP g>xt SWAP cb_Checked ;
: (CHECKBOX) ( l t w h 0$ mem -- g ) pfCheckBox PLACETEXT_RIGHT CHECKBOX_KIND (GADGET) ;
: CHECKBOX   ( l t w h c$ -- &xt &on ) 5 ? $>0$, CREATE DICT (checkbox) cbSpecs DOES> GTCB_CHECKED gDo ;

Tags[
	GA_DISABLED 0			TAG: cbt_Disabled		\ set
	GT_UNDERSCORE CHAR ^	TAG: cbt_Underscore
	GTCB_Checked 0			TAG: cbt_Checked		\ set
	GTCB_Scaled -1			TAG: cbt_Scaled
]TAGS (cbTags)

: cbTags ( g -- tl ) S@ cb_Checked (cbTags) TUCK S! cbt_Checked ;	\ cb-specific tags
[+SWITCH (gTags) CHECKBOX_KIND RUNS cbTags SWITCH]

\ EZMX; left top width height c$title MX <instance name>  ----------------------------------------
\ Choices Choice" Entry 1" Choice" Entry 2" Choice" Entry 3" Choices.End
STRUCTURE pfMX									\ parForth MX (mx)
		pfGadget
	STRUCT:	mx_g ( don't use)						\ pfGadget structure (always first)
	ADDR:	mx_Labels								\ null-terminated array of choices
STRUCTURE.END

\ MX Choices leaves a 0 to begin count of choices ( -- 0 )
\ MX Choice" compiles a 0$ and increments count ( <xx"> qty -- 0$ qty+1 )
\ MX Choices.End saves the 0$ addrs into memory and stores the memory's addr in &txt ( &txt ... qty -- )
: MXEnd  ( &txt ... qty -- ) DUP 2+ ? DUP 0= ABORT" No entries" DICT (TEXTS) tlFill SWAP R! ;
: MX>Choice ( -- ) ['] FALSE IS Choices    ['] TEXTS" IS Choice"    ['] MXEnd IS Choices.End ;

: mxSpecs ( g -- &txt &xt ) DUP mx_Labels SWAP g>xt ;
: (MX) ( l t w h 0$ mem -- g ) pfMX PLACETEXT_RIGHT MX_KIND (GADGET) MX>Choice ;
: MX   ( l t w h c$ -- &txt &xt ) 5 ? $>0$, CREATE DICT (MX) mxSpecs DOES> GTMX_ACTIVE gDo ;

Tags[
	GA_DISABLED 0					TAG: mxt_Disabled	\ set
	GT_UNDERSCORE CHAR ^			TAG: mxt_Underscore
	GTMX_LABELS 0					TAG: mxt_Labels		\ set
	GTMX_ACTIVE 0					TAG: mxt_Active		\ set
	GTMX_Spacing 1					TAG: mxt_Spacing
	GTMX_Scaled 0					TAG: mxt_Scaled
	GTMX_TITLEPLACE PLACETEXT_ABOVE TAG: mxt_TitlePlace
]TAGS (mxTags)

: mxTags ( g -- tl ) S@ mx_Labels (mxTags) TUCK S! mxt_Labels ;	\ mx-specific tags
[+SWITCH (gTags) MX_KIND RUNS mxTags SWITCH]

\ EZCYCLE; left top width height c$title CYCLE <instance name> ---------------------------------------
\ Choices Choice" Entry 1" Choice" Entry 2" Choice" Entry 3" Choices.End
\ GetAttributes and SetAttributes for CYCLE are unimplemented in AROS; parForth provides a workaround
STRUCTURE pfCYCLE								\ parForth CYCLE (cy)
		pfGadget
	STRUCT:	cy_g ( don't use)						\ pfGadget structure (always first)
	LONG:	cy_Qty									\ number of choices
	LONG:	cy_Active								\ number of active choice
	ADDR:	cy_Labels								\ null-terminated array of choices
STRUCTURE.END

\ Cycle Choices is same as MX; leaves a 0 to begin count of choices ( -- 0 )
\ Cycle Choice" is same as MX; compiles a 0$ and increments cnt ( <xx"> qty -- 0$ qty+1 )
\ Cycle Choices.End is the same as MX but also stores the qty in &qty ( &qty &txt ... qty -- )
: cyEnd ( &qty &txt ... qty -- ) DUP >R MXEnd R> SWAP ! ;
: CY>Choice ( -- ) ['] FALSE IS Choices    ['] TEXTS" IS Choice"    ['] cyEnd IS Choices.End ;

: cySpecs ( g -- &qty &txt &xt ) DUP cy_Qty OVER cy_Labels ROT g>xt ;
: (CYCLE) ( l t w h 0$ mem -- g ) pfCYCLE PLACETEXT_ABOVE CYCLE_KIND (GADGET) CY>Choice ;
: CYCLE   ( l t w h c$ -- &txt &xt ) 5 ? $>0$, CREATE DICT (CYCLE) cySpecs DOES> GTCY_ACTIVE gDo ;

Tags[
	GA_DISABLED 0			TAG: cyt_Disabled		\ set
	GT_UNDERSCORE CHAR ^	TAG: cyt_Underscore
	GTCY_LABELS 0			TAG: cyt_Labels			\ set
	GTCY_ACTIVE 0			TAG: cyt_Active			\ set
]TAGS (cyTags)

: cyTags ( g -- tl ) S@ cy_Labels (cyTags) TUCK S! cyt_Labels ;		\ cy-specific tags
[+SWITCH (gTags) CYCLE_KIND RUNS cyTags SWITCH]

\ EZListView; left top width height c$title LISTVIEW <instance name> ---------------------------------
\ Choices Choice" Entry 1" Choice" Entry 2" Choice" Entry 3" Choices.End
STRUCTURE pfListView								\ parForth ListView (lv)
		pfGadget
	STRUCT:	lv_g ( don't use)						\ pfGadget structure (always first)
		_List
	STRUCT:	lv_Labels								\ AList of items
STRUCTURE.END

: lvChoices ( &txt -- &txt ) DUP ALInit ;	\ ListView Choices initializes the given AROS list
\ ListView Choice" adds the 0$ to a new AROS node and links it to the list
: lvChoice" ( <xx"> &txt -- &txt ) TEXT" ANODE TUCK S! ln_Name OVER ALINK> ;	
: lvEnd     ( &txt -- ) RelList ;	\ ListView End transforms the AROS list into a list with relocatable addresses
: LV>Choice ( -- ) ['] lvChoices IS Choices    ['] lvChoice" IS Choice"    ['] lvEnd IS Choices.End ;

: lvSpecs    ( g -- &txt &xt ) DUP lv_Labels SWAP g>xt ;
: (LISTVIEW) ( l t w h 0$ mem -- g ) pfListView PLACETEXT_ABOVE LISTVIEW_KIND (GADGET) LV>Choice ;
: LISTVIEW   ( l t w h c$ -- &txt &xt ) 5 ? $>0$, CREATE DICT (LISTVIEW) lvSpecs DOES> GTLV_SELECTED gDo ;

Tags[
	GA_DISABLED 0			TAG: lvt_Disabled		\ set
	GT_UNDERSCORE CHAR ^	TAG: lvt_Underscore
	GTLV_LABELS 0 			TAG: lvt_Labels			\ set
	GTLV_SHOWSELECTED 0 	TAG: lvt_ShowSelected
	GTLV_TOP 0				TAG: lvt_Top			\ set
	GTLV_CALLBACK 0			TAG: lvt_Callback
	GTLV_MAKEVISIBLE 0		TAG: lvt_MakeVisible	\ set
	GTLV_SELECTED 0			TAG: lvt_Selected		\ set
	GTLV_READONLY 0			TAG: lvt_ReadOnly
\	GTLV_SCROLLWIDTH 0		TAG: lvt_ScrollWidth
\	LAYOUTA_SPACING 0		TAG: lvt_LayoutSpacing
\	GTLV_ITEMHEIGHT 0		TAG: lvt_ItemHeight
\	GTLV_CALLBACK 0			TAG: lvt_Callback
\	GTLV_MAXPEN 0			TAG: lvt_MaxPen
]TAGS (lvTags)

: lvTags ( g -- tl ) lv_Labels (lvTags) TUCK S! lvt_Labels ;	\ lv-specific tags
[+SWITCH (gTags) LISTVIEW_KIND RUNS lvTags SWITCH]

\ EZInteger; left top width height c$title n INTEGER <instance name> ------------------------------------
STRUCTURE pfInteger									\ parForth Integer (in)
		pfGadget
	STRUCT:	in_g									\ pfGadget structure
	LONG:	in_Number								\ starting value
STRUCTURE.END

: inSpecs   ( g -- &xt ) g>xt ;
: (INTEGER) ( l t w h 0$ n mem -- g ) SWAP >R pfInteger PLACETEXT_ABOVE INTEGER_KIND (GADGET) R> OVER S! in_Number ;
: INTEGER   ( l t w h c$ n -- &xt ) 6 ? SWAP $>0$, SWAP CREATE DICT (INTEGER) inSpecs DOES> GTIN_NUMBER gDo ;

TAGS[
	GA_DISABLED 0							TAG: int_Disabled		\ set
	GT_UNDERSCORE CHAR ^					TAG: int_Underscore
	GA_TABCYCLE 0							TAG: int_TabCycle
	GTIN_NUMBER 0							TAG: int_Number			\ set
	GTIN_MAXCHARS 10						TAG: int_MaxChars
	STRINGA_JUSTIFICATION GACT_STRINGCENTER	TAG: int_Justification
	STRINGA_REPLACEMODE 0					TAG: int_ReplaceMode
]TAGS (inTags)

: inTags ( g -- tl ) S@ in_Number (intags) TUCK S! int_Number ;
[+SWITCH (gtags) INTEGER_KIND RUNS inTags SWITCH]

\ EZString; left top width height c$title Default" <xx"> ASTRING <instance name> ----------------------------
STRUCTURE pfString									\ parForth String (st)
		pfGadget
	STRUCT:	st_g									\ pfGadget structure
	ADDR:	st_String								\ initial 0$
STRUCTURE.END

: Default" ( -- c$ ) [ CHAR " ] LITERAL PARSE-WORD >STRING ;
: stSpecs  ( g -- &xt ) g>xt ;
: (ASTRING) ( l t w h 0$title 0$init mem -- g ) SWAP >R pfString PLACETEXT_ABOVE STRING_KIND (GADGET) R> OVER S! st_String ;
: ASTRING   ( l t w h c$title c$init -- &xt ) 6 ? SWAP $>0$, SWAP $>0$, CREATE DICT (ASTRING) stSpecs DOES> GTST_STRING gDo ;

TAGS[
	GA_DISABLED 0							TAG: stt_Disabled		\ set
	GT_UNDERSCORE CHAR ^					TAG: stt_Underscore
	GA_TABCYCLE 0							TAG: stt_TabCycle
	GTST_STRING 0							TAG: stt_String			\ set
	GTST_MAXCHARS 255						TAG: stt_MaxChars
\	GTST_EDITHOOK 0							TAG: stt_EditHook
	STRINGA_JUSTIFICATION GACT_STRINGCENTER	TAG: stt_Justification
	STRINGA_REPLACEMODE 0					TAG: stt_ReplaceMode
]TAGS (stTags)

: stTags ( g -- tl ) S@ st_String (stTags) TUCK S! stt_String ;
[+SWITCH (gTags) STRING_KIND RUNS stTags SWITCH]

\ EZText; left top width height c$title c$text ATEXT <instance name> -------------------------------------
STRUCTURE pfText									\ parForth text (tx)
		pfGadget
	STRUCT:	tx_g									\ pfGadget structure
	ADDR:	tx_Text									\ initial 0$
STRUCTURE.END

: txSpecs ( g -- ) DROP ;
: (ATEXT) ( l t w h 0$title 0$text mem -- g ) SWAP >R pfText PLACETEXT_ABOVE TEXT_KIND (GADGET) R> OVER S! tx_Text ;
: ATEXT   ( l t w h c$title c$text -- ) 6 ? SWAP $>0$, SWAP $>0$, CREATE DICT (ATEXT) txSpecs DOES> GTTX_TEXT gDo ;
: LABEL   ( l t w h c$text -- ) 5 ? $>0$, HERE 0 , SWAP CREATE DICT (ATEXT) txSpecs DOES> GTTX_TEXT gDo ;

TAGS[
	GA_DISABLED 0					TAG: txt_Disabled		\ set
	GT_UNDERSCORE CHAR ^			TAG: txt_Underscore
	GTTX_TEXT 0						TAG: txt_Text			\ set
	GTTX_BORDER 0					TAG: txt_Border
	GTTX_JUSTIFICATION GTJ_CENTER	TAG: txt_Justification	\ set
\	GTTX_FRONTPEN 0					TAG: txt_FrontPen		\ set
\	GTTX_BACKPEN 0					TAG: txt_BackPen		\ set
\	GTTX_COPYTEXT 0					TAG: txt_CopyText
\	GTTX_CLIPPED 0					TAG: txt_Clipped
]TAGS (txTags)

: txTags ( g -- tl ) S@ tx_Text (txTags) TUCK S! txt_Text ;
[+SWITCH (gTags) TEXT_KIND RUNS txTags SWITCH]

\ EZNumber; left top width height c$title n NUMBER <instance name> -------------------------------------
STRUCTURE pfNumber									\ parForth number (nm)
		pfGadget
	STRUCT:	nm_g										\ pfGadget structure
	LONG:	nm_Number									\ initial number
STRUCTURE.END

: nmSpecs  ( g -- ) DROP ;
: (NUMBER) ( l t w h 0$title n mem -- g ) SWAP >R pfText PLACETEXT_ABOVE NUMBER_KIND (GADGET) R> OVER S! nm_Number ;
: NUMBER   ( l t w h c$title n -- ) 6 ? SWAP $>0$, SWAP CREATE DICT (NUMBER) nmSpecs DOES> GTNM_NUMBER gDo ;

TAGS[
	GA_DISABLED 0					TAG: nmt_Disabled		\ set
	GT_UNDERSCORE CHAR ^			TAG: nmt_Underscore
	GTNM_Number 0					TAG: nmt_Number			\ set
	GTNM_BORDER 0					TAG: nmt_Border
	GTNM_JUSTIFICATION GTJ_CENTER	TAG: nmt_Justification	\ set
\	GTNM_FrontPen 0					TAG: nmt_FrontPen		\ set
\	GTNM_BackPen 0					TAG: nmt_BackPen		\ set
\	GTNM_Format 0					TAG: nmt_Format
\	GTNM_MaxNumberLen 10			TAG: nmt_MaxNumberLen
\	GTNM_Clipped 0					TAG: nmt_Clipped
]TAGS (nmTags)

: nmTags ( g -- tl ) S@ nm_Number (nmTags) TUCK S! nmt_Number ;
[+SWITCH (gTags) NUMBER_KIND RUNS nmTags SWITCH]

\ EZSlider; VERTICAL ON|OFF left top width height c$title min max level SLIDER <instance name> ---------------
STRUCTURE pfSlider										\ parForth slider (sl)
		pfGadget
	STRUCT: sl_g										\ pfGadget structure
	LONG:	sl_Min										\ min level
	LONG:	sl_Max										\ max level
	LONG:	sl_Level									\ initial level
	LONG:	sl_Orientation								\ horizontal or vertical
STRUCTURE.END
CREATE Vertical 0 ,										\ default horizontal sliders

: slSpecs     ( g -- ) g>xt ;
: Orientation ( -- f ) Vertical @ IF LORIENT_VERT ELSE LORIENT_HORIZ THEN ; 
: (SLIDER)    ( l t w h 0$title min max level mem -- g ) SWAP >R SWAP >R SWAP >R pfSlider PLACETEXT_ABOVE SLIDER_KIND
	(GADGET) R> OVER S! sl_Min R> OVER S! sl_Max R> OVER S! sl_Level Orientation OVER S! sl_Orientation ;
: SLIDER      ( l t w h c$title min max level -- &xt ) 8 ? 3 ROLL $>0$, 3 -ROLL CREATE DICT (SLIDER) slSpecs
	DOES> GTSL_LEVEL gDo ;

TAGS[
	GA_DISABLED 0					TAG: slt_Disabled		\ set
	GA_RelVerify 1					TAG: slt_RelVerify
	GA_Immediate 0					TAG: slt_Immediate
	GT_UNDERSCORE CHAR ^			TAG: slt_Underscore
	GTSL_Min 0						TAG: slt_Min			\ set
	GTSL_Max 15						TAG: slt_Max			\ set
	GTSL_Level 0					TAG: slt_Level			\ set
	GTSL_MaxLevelLen 3				TAG: slt_MaxLevelLen
\	GTSL_LevelFormat 0				TAG: slt_LevelFormat	\ set
	GTSL_LevelPlace PLACETEXT_RIGHT	TAG: slt_LevelPlace
\	GTSL_DispFunc 0					TAG: slt_DispFunc		\ set
\	GTSL_MaxPixelLen 0				TAG: slt_MaxPixelLen
	GTSL_Justification GTJ_CENTER	TAG: slt_Justification
	PGA_FREEDOM LORIENT_HORIZ		TAG: slt_Orientation
]TAGS (slTags)

: slTags ( g -- tl )
	DUP S@ sl_Min         (slTags) S! slt_Min
	DUP S@ sl_Max         (slTags) S! slt_Max
	DUP S@ sl_Level       (slTags) S! slt_Level
	    S@ sl_Orientation (slTags) S! slt_Orientation (slTags) ;
[+SWITCH (gTags) SLIDER_KIND RUNS slTags SWITCH]

\ EZPalette; VERTICAL ON|OFF left top width height c$title #pens startingat PALLETTE <instance name> ---------------
STRUCTURE pfPalette										\ parForth pallette (pa)
		pfGadget
	STRUCT: pa_g										\ pfGadget structure
	LONG:	pa_Colors									\ number of colors/pens to show in palette
	LONG:	pa_ColorOffset								\ offset into pen list/palette to start
STRUCTURE.END

: paSpecs   ( g -- ) g>xt ;
: (PALETTE) ( l t w h 0$title #colors start mem -- g ) SWAP >R SWAP >R pfPalette PLACETEXT_ABOVE PALETTE_KIND
	(GADGET) R> OVER S! pa_Colors R> OVER S! pa_ColorOffset ;
: PALETTE   ( l t w h c$title #colors start -- ) 7 ? ROT $>0$, -ROT CREATE DICT (PALETTE) paSpecs
	DOES> GTPA_Color gDo ;

TAGS[
	GA_DISABLED 0					TAG: pat_Disabled		\ set
\	GTPA_Depth 1					TAG: pat_Depth
	GTPA_Color 0					TAG: pat_Color			\ set
	GTPA_ColorOffset 0				TAG: pat_ColorOffset	\ set
	GTPA_IndicatorWidth 0			TAG: pat_IndicatorWidth
	GTPA_IndicatorHeight 0			TAG: pat_IndicatorHeight
	GTPA_NumColors 0				TAG: pat_NumColors
\	GTPA_ColorTable 0				TAG: pat_ColorTable		\ set
]TAGS (paTags)

: Indicator ( -- ) 0 25 Vertical @ IF SWAP THEN (paTags) pat_IndicatorHeight ! (paTags) pat_IndicatorWidth ! ;
: paTags    ( g -- tl )
	DUP S@ pa_Colors      (paTags) S! pat_NumColors
	    S@ pa_ColorOffset (paTags) S! pat_ColorOffset (paTags) ( Indicator) ;
[+SWITCH (gTags) PALETTE_KIND RUNS paTags SWITCH]

\ AROS gadgets from pfGadget structures -------------------------------------------
: _CreateContext	( glist -- gad )                19 GadToolsBase  CALL1 ;
: _CreateGadgetA	( kind prev ng tl -- gad|0 )     5 GadToolsBase  CALL4 ;
: _AddGList		    ( wd gad pos1 qty req -- pos2 ) 73 IntuitionBase CALL5 ;
: _RefreshGList	    ( gad wd req qty -- )           72 IntuitionBase CALL4NR ;
: _GT_RefreshWindow ( wd req -- )                   14 GadToolsBase  CALL2NR ;
: _FreeGadgets 	    ( glist -- )                     6 GadToolsBase  CALL1NR ;

: gList     ( -- addr ) w w_Glist ;
: gVI       ( g -- ) vi SWAP g_ng S! ng_VisualInfo ;
: gTags     ( g -- tl ) DUP S@ g_Kind ?DUP IF (gTags) ELSE DROP 0 THEN ;
: ((gMake)) ( g -- gad|0 ) DUP S@ g_Kind gList TAIL ROT DUP g_ng SWAP gTags _CreateGadgetA ;
: (gMake)   ( g -- f ) DUP ((gMake)) TUCK SWAP S! g_Gad ;
: gBadFont  ( g -- ) g_ng ng_TextAttr OFF ScreenFont ;
: gMake     ( g -- ) DUP (gMake) 0= IF DUP gBadFont DUP (gMake) 0= ABORT" No gad" THEN DROP ;

: gMakes   ( -- ) w w_Gadgets BEGIN @ ?DUP WHILE DUP gVI DUP gMake REPEAT ;
: gAttach  ( -- ) wd gList @ 0 -1 0 _AddGList DROP ;
: gShow    ( -- ) wd wd_FirstGadget @ wd 0 -1 _RefreshGList wd 0 _GT_RefreshWindow ;
: gContext ( -- ) gList _CreateContext DUP 0= ABORT" No context" gList ! ;
: gOpen    ( -- ) gContext gMakes gAttach gShow ;

: gFree ( gads -- ) ?DUP IF _FreeGadgets THEN ;						\ included in wClose

\ Gadget attributes -----------------------------------------------------------
: _GT_SetGadgetAttrsA ( gad wd req tl -- )      7 GadToolsBase  CALL4NR ;
: _GT_GetGadgetAttrsA ( gad wd req tl -- val ) 29 GadToolsBase  CALL4 ;

CREATE gAttr  0 ,									\ Get-attribute dest, Set-attr val
CREATE gaTags 0 , 0 , 0 ,							\ Gadget attribute taglist request
: >gaTags ( gad attr val -- gad wd req tags ) SWAP gaTags 2! wd 0 gaTags ;
: gSet    ( val gad attr -- ) ROT >gaTags _GT_SetGadgetAttrsA ;
: gGet    ( gad attr -- val ) gAttr >gaTags _GT_GetGadgetAttrsA DROP gAttr @ ;

\ Handle gadgets --------------------------------------------------------------
\ ggUserData should be a switch for gadget IDCMP events; most are just IDCMP_GADGETUP, however todo
: (HandleGadget) ( -- ) LastEvent S@ im_IAddress S@ gg_UserData ?EXECUTE ;

' (HandleGadget) IS HandleGadget			\ deferred HandleGadget filled

\ AROS New Window Structure =============================================================
: _OpenWindowTagList ( nw tags -- wd ) 101 IntuitionBase CALL2 ;
: _ChangeWindowBox   ( wd l t w h -- ) 81 IntuitionBase CALL5NR ;
: _MoveWindow	     ( wd dX dY -- ) 28 IntuitionBase CALL3NR ;
: _SetWindowTitles   ( wd 0$W 0$S -- ) 46 IntuitionBase CALL3NR ;
: _CloseWindow       ( wd -- ) 12 IntuitionBase CALL1NR ;

\ defaults: BORDERED or BACKDROP; both on default public screen
WFLG_BACKDROP WFLG_BORDERLESS | WFLG_SMART_REFRESH | CONSTANT BACKDROP

WFLG_SIZEGADGET WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
	WFLG_SMART_REFRESH | WFLG_GIMMEZEROZERO | WFLG_ACTIVATE | CONSTANT BORDERED

CREATE nwDefault NewWindow 0ALLOT
nwDefault 320 OVER S! nw_Width		         200 OVER S! nw_Height		\ low resolution
	BORDERED OVER S! nw_Flags		PUBLICSCREEN SWAP S! nw_Type

CREATE nw NewWindow 0ALLOT						\ new window scratch area

\ window dimensions that are a percent of screen size
: scWidth   ( -- u ) sc S@ sc_Width ;
: scHeight  ( -- u ) sc S@ sc_Height ;
: %scale    ( % size1 -- size2 ) SWAP 100 MIN 5 MAX 100 */ ; 
: %scWidth  ( % -- width ) scWidth %scale ;
: %scHeight ( % -- h ) scHeight %scale ;
: %scSize   ( % -- width h ) DUP %scWidth SWAP %scHeight ;

\ window positioning constants
-1      CONSTANT #CENTER
 0      CONSTANT #TOP
 0      CONSTANT #LEFT
-2      CONSTANT #BOTTOM
#BOTTOM CONSTANT #RIGHT

: scFar    ( scDim wDim -- wCoord ) - ;			\ right or bottom coord given screen and window dimension
: scCenter ( scDim wDim -- wCoord ) scFar 2/ ;	\ calculate coordinate to center the window
: scPos    ( scDim wDim coord1 -- coord2 )		\ calculate coordinate for positioning constant
	DUP #CENTER =								\ scWidth wWidth left1 f			center?
	IF DROP scCenter							\ left2									yes, calculate left coord
	ELSE #RIGHT =								\ scWidth wWidth f						no, right?
		IF scFar								\ left2										yes, calculate left coord
		ELSE ABORT" Negative coordinate"		\											no, abort
		THEN									\ left2
	THEN ;
: scLeft   ( left1 width -- left2 width ) >R DUP 0< IF scWidth  R@ ROT scPos THEN R> ;
: scTop    ( top1 height -- top2 height ) >R DUP 0< IF scHeight R@ ROT scPos THEN R> ;
: ?Coord   ( left1 top1 width h -- left2 top2 width h )	\ perform special positioning if indicated; could be noop 
	3 ROLL ROT scLeft									\ top1 height left2 width
	2SWAP scTop											\ left2 width top2 height
	ROT SWAP ;											\ left2 top2 width height

\ AROS window functions ------------------------------------------------------------
: wChange ( l t w h -- ) ?Coord 2>R wd -ROT 2R> _ChangeWindowBox ;
: wMove   ( l t -- ) wd S@ wd_Width wd S@ wd_Height wChange ;
: w+Move  ( dX dY -- ) wd -ROT _MoveWindow ;
: wSize	  ( w h -- ) 2>R wd S@ wd_LeftEdge wd S@ wd_TopEdge 2R> wChange ;

\ fill in NewWindow structure nw and open window -----------------------------------
: nwDef    ( -- ) nwDefault nw NewWindow CMOVE ;
: nwBox    ( l t width h -- ) ?Coord nw S! nw_Height nw S! nw_Width nw S! nw_TopEdge nw S! nw_LeftEdge ;
: nwMax	   ( -- ) sc S@ sc_Width nw S! nw_MaxWidth sc S@ sc_Height nw S! nw_MaxHeight ;
: nwFlags  ( nwFlags -- ) ?DUP IF nw S! nw_Flags THEN ;
: nwTitle  ( -- ) w S@ w_Title nw S! nw_Title ;
: nwScreen ( -- ) sc nw S! nw_Screen ;
: (wOpen)  ( flags l t width h -- wd ) nwDef nwBox nwMax nwFlags nwTitle nwScreen nw 0 _OpenWindowTagList
	DUP 0= ABORT" Window open failed" ;
: wOpen    ( flags l t width h -- ) 5 ? wd ABORT" Window open" Relocating OFF (wOpen) w S! w_wd
	WindowPort pOpen mp wd S! wd_UserPort mOpen gOpen EventsOn ;

: (wClose) ( -- ) mClose wd wd_UserPort OFF wd S@ wd_FirstGadget wd _CloseWindow gFree w w_wd OFF glist OFF -w OFF ;
: wClose   ( -- ) wd IF (wClose) THEN ;

: (wEnd)   ( -- ) Windows BEGIN @ ?DUP WHILE DUP -w ! wClose REPEAT ;
: wEnd     ( -- ) (wEnd) viFree scFree ;

: auto.term PROTECT wEnd auto.term ;	\ close all open windows and their resources and unlock screen upon BYE

