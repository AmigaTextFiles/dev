/*****************************************************************************

 Layout routines

 *****************************************************************************/
OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE '*locale', 'exec/ports', 'exec/nodes', 'exec/lists', 'graphics/text', 'graphics/rastport',
       'intuition/intuition', 'intuition/screens', 'intuition/cghooks', 'utility/tagitem',
       'libraries/asl', 'libraries/gadtools', 'dopus'

CONST POS_CENTER          = -1          -> Center position
CONST POS_RIGHT_JUSTIFY   = -2          -> Right-justified

CONST POS_MOUSE_CENTER    = -3          -> Center over mouse
CONST POS_MOUSE_REL       = -4          -> Relative to mouse

CONST POS_PROPORTION      = 1024        -> Proportion of space left
CONST POS_SQUARE          = 1124
CONST POS_REL_RIGHT       = $4000       -> Relative to another

CONST FPOS_TEXT_OFFSET    = 16384

CONST SIZE_MAXIMUM        = -1
CONST SIZE_MAX_LESS       = -101

-> Defines a window
OBJECT configWindow
    charDims:ibox
    fineDims:ibox
ENDOBJECT

-> Opens a window
OBJECT newConfigWindow
    parent:PTR TO LONG          -> Parent to open on
    dims:PTR TO configWindow    -> Window dimensions
    title:PTR TO CHAR           -> Window title
    locale:PTR TO dOpusLocale   -> Locale to use
    port:PTR TO mp              -> Message port to use
    flags:LONG                  -> Flags
    font:PTR TO textfont        -> Alternative font to use
ENDOBJECT

-> Set by the user
SET WINDOW_SCREEN_PARENT,       -> Parent is a screen
    WINDOW_NO_CLOSE,            -> No close gadget
    WINDOW_NO_BORDER,           -> No border
    WINDOW_LAYOUT_ADJUST,       -> Adjust window size to fit objects
    WINDOW_SIMPLE,              -> Simple refresh
    WINDOW_AUTO_REFRESH,        -> Refresh window automatically
    WINDOW_AUTO_KEYS,           -> Handle keys automatically
    WINDOW_OBJECT_PARENT,       -> Parent is an existing object
    WINDOW_REQ_FILL,            -> Backfill as a requester
    WINDOW_NO_ACTIVATE,         -> Don't activate
    WINDOW_VISITOR,             -> Open as visitor window
    WINDOW_SIZE_RIGHT,          -> Size gadget, in right border
    WINDOW_SIZE_BOTTOM,         -> Size gadget, in bottom border
    WINDOW_ICONIFY              -> Iconify gadget

-> Set by the system
CONST OPEN_USED_DEFAULT   = $10000     -> To open had to use default font
CONST OPEN_USED_TOPAZ     = $20000     -> To open had to use topaz
CONST OPEN_SHRUNK_VERT    = $40000     -> Window is not full vertical size requested
CONST OPEN_SHRUNK_HORIZ   = $80000     -> Window is not full horizontal size requested
CONST OPEN_SHRUNK         = $C0000


-> ID of the iconify gadget
CONST GAD_ID_ICONIFY      = $FFA0

-> Defines an object
OBJECT objectDef
    type:CHAR
    objectKind:CHAR
    charDims:ibox
    fineDims:ibox
    gadgetText:LONG
    flags:LONG
    id:INT
    tagList:PTR TO tagitem
ENDOBJECT

CONST TEXTFLAG_TEXT_STRING        = $20000     -> Text is a string, not a Locale ID
CONST TEXTFLAG_NO_USCORE          = $40000     -> No underscore in text
CONST BUTTONFLAG_OKAY_BUTTON      = $40000     -> Button is an "ok" button
CONST BUTTONFLAG_CANCEL_BUTTON    = $80000     -> Button is a "cancel" button
CONST BUTTONFLAG_TOGGLE_SELECT    = $100000    -> Button is toggle-select
CONST LISTVIEWFLAG_CURSOR_KEYS    = $200000    -> Lister responds to cursor
CONST BUTTONFLAG_THIN_BORDERS     = $400000    -> Button has thin borders
CONST FILEBUTFLAG_SAVE            = $200000    -> Save mode

CONST TEXTFLAG_ADJUST_TEXT        = $800000    -> Adjust for text
CONST POSFLAG_ADJUST_POS_X        = $1000000   -> Position adjustor
CONST POSFLAG_ADJUST_POS_Y        = $2000000   -> Position adjustor
CONST POSFLAG_ALIGN_POS_X         = $4000000   -> Align
CONST POSFLAG_ALIGN_POS_Y         = $8000000   -> Align

CONST TEXTFLAG_RIGHT_JUSTIFY      = 2      -> Right-justify text
CONST TEXTFLAG_CENTER             = 4      -> Center text

CONST AREAFLAG_RAISED         = $100      -> Raised rectangle
CONST AREAFLAG_RECESSED       = $200      -> Recessed rectangle
CONST AREAFLAG_THIN           = $400      -> Thin borders
CONST AREAFLAG_ICON           = $800      -> Icon drop box
CONST AREAFLAG_ERASE          = $1000     -> Erase interior
CONST AREAFLAG_LINE           = $2000     -> Line (separator)
CONST AREAFLAG_OPTIM          = $8000     -> Optimised refreshing
CONST AREAFLAG_TITLE          = $10000     -> Box with a title
CONST AREAFLAG_NOFILL         = $40000    -> No fill

CONST OBJECTFLAG_DRAWN        = $80000000 -> Object has been drawn

CONST OD_END      = 0       -> End of a list
CONST OD_GADGET   = 1       -> A gadget
CONST OD_TEXT     = 2       -> Some text
CONST OD_AREA     = 3       -> A rectangular area
CONST OD_IMAGE    = 4       -> An image
CONST OD_SKIP     = -1      -> Skip this entry

OBJECT gl_gadget
    context:PTR TO gadget   -> Context data for the gadget
    gadget:PTR TO gadget    -> The gadget itself
    components:INT          -> Number of component gadgets
    data:LONG               -> Some data for the gadget
    choice_max:INT          -> Number of choices
    choice_min:INT          -> Minimum choice
    image:PTR TO image      -> Gadget image
ENDOBJECT

OBJECT gl_text
    text_pos:ibox    -> Text position
    base_pos:INT     -> Baseline position
    uscore_pos:INT   -> Underscore position
ENDOBJECT

OBJECT gl_area
    text_pos:ibox       -> Text position within area
    area_pos:ibox       -> Area position
    frametype:INT       -> Frame type
ENDOBJECT

OBJECT gl_image
    image_pos:ibox          -> Image position
    image:PTR TO image      -> Image
ENDOBJECT

OBJECT gl_info
    gl_gadget:gl_gadget
    gl_text:gl_text
    gl_area:gl_area
    gl_image:gl_image
ENDOBJECT

OBJECT gl_object
    next:PTR TO gl_object       -> Next object
    type:INT                    -> Type of object
    key:CHAR                    -> Key equivalent

    flags2:CHAR                 -> Additional flags

    id:INT                      -> Object ID
    control_id:INT              -> Object that this controls
    dims:ibox                   -> Object dimensions
    flags:LONG                  -> Object flags
    text:PTR TO CHAR            -> Text
    object_kind:INT             -> Object kind

    gl_info:gl_info

    memory:PTR TO LONG                  -> Any other memory

    original_text:PTR TO CHAR           -> Original text string
    fg:CHAR
    bg:CHAR                             -> Current pen colours

    data_ptr:LONG                       -> Pointer to other data

    tags:PTR TO tagitem                 -> Copy of tags

    char_dims:ibox                      -> Original dimensions
    fine_dims:ibox
ENDOBJECT

OBJECT objectList
    firstobject:PTR TO gl_object    -> First object
    attr:textattr                   -> Font used
    window:PTR TO window            -> Window used
    next_list:PTR TO objectList     -> Next list
ENDOBJECT

CONST OBJECTF_NO_SELECT_NEXT  = 1      -> Don't select next field
CONST OBJECTF_PATH_FILTER     = 2      -> Filter path characters
CONST OBJECTF_SECURE          = 4      -> Hide string
CONST OBJECTF_INTEGER         = 8      -> Integer gadget
CONST OBJECTF_READ_ONLY       = 16     -> Read-only
CONST OBJECTF_HOTKEY          = 32     -> Hotkey string

OBJECT menuData
    type:CHAR             -> Menu type
    id:LONG              -> Menu ID
    name:LONG            -> Menu name
    flags:LONG           -> Menu flags
ENDOBJECT

CONST MENUFLAG_TEXT_STRING    = $10000     -> Menu name is a real string
CONST MENUFLAG_COMM_SEQ       = $20000     -> Give menu a command sequence
CONST MENUFLAG_AUTO_MUTEX     = $40000     -> Automatic mutual exclusion
CONST MENUFLAG_USE_SEQ        = $80000     -> Use command sequence supplied

#define MENUFLAG_MAKE_SEQ(c)    (Shl(c,24))
#define MENUFLAG_GET_SEQ(fl)    (Shr(fl,24))

CONST NM_NEXT         = 10
CONST NM_BAR_LABEL    = NM_BARLABEL

#define IS_GADTOOLS(obj)      (obj.info.gadget.context)

OBJECT windowID
    magic:LONG                  -> Magic ID
    window:PTR TO window        -> Pointer back to window
    window_id:LONG              -> User window ID
    app_port:PTR TO mp          -> "Window's" application port
ENDOBJECT

CONST WINDOW_MAGIC        = $83224948
CONST WINDOW_UNKNOWN      = -1
CONST WINDOW_UNDEFINED    = 0

#define SET_WINDOW_ID(w,id) (w.userData.window_id:=id)

-> Window types
CONST WINDOW_BACKDROP         = $4000001
CONST WINDOW_LISTER           = $4000002
CONST WINDOW_BUTTONS          = $4000004
CONST WINDOW_GROUP            = $4000008
CONST WINDOW_LISTER_ICONS     = $4000010
CONST WINDOW_FUNCTION         = $4000020   -> not really a window
CONST WINDOW_START            = $4000040

CONST WINDOW_POPUP_MENU       = $0001200
CONST WINDOW_TEXT_VIEWER      = $0001300

CONST WINDOW_USER             = $2000000

-> This structure is pointed to by Window->UserData
OBJECT windowData
    id:windowID                         -> Window ID information
    list:PTR TO objectList              -> Window object list
    request:PTR TO filerequester        -> Window's file requester
    visinfo:PTR TO LONG                 -> Visual info
    drawinfo:PTR TO drawinfo            -> Draw info
    locale:PTR TO dOpusLocale           -> Locale info
    window_port:PTR TO mp               -> Window message port (if supplied)
    new_menu:PTR TO newmenu             -> NewMenu structure allocated
    menu_strip:PTR TO menu              -> Menu strip allocated
    busy_req:PTR TO requester           -> Window busy requester
    data:LONG                           -> Window-specific data
    flags:LONG                          -> Flags
    memory:PTR TO LONG                  -> User memory pool, freed when window closes
    hook_magic:PTR TO LONG              -> Magic for backfill hooks
    font_request:PTR TO fontrequester   -> Window's font requester
    userdata:LONG
    user_tags:PTR TO tagitem
    boopsi_list:lh                      -> BOOPSI list
ENDOBJECT

CONST FILE_GLASS_KIND = 1000
CONST DIR_GLASS_KIND  = 1001

CONST GM_RESIZE   = 20

OBJECT gpResize
    methodID:LONG
    gInfo:gadgetinfo
    rPort:PTR TO rastport
    size:ibox
    redraw:LONG
    window:PTR TO window
    requester:PTR TO requester
ENDOBJECT

-> Custom tags
CONST GTCustom_LocaleLabels     = TAG_USER + 0    -> Points to list of Locale IDs
CONST GTCustom_Image            = TAG_USER + 1    -> Image for gadget
CONST GTCustom_CallBack         = TAG_USER + 2    -> Tag ID and data filled in by callback
CONST GTCustom_LayoutRel        = TAG_USER + 3    -> Layout relative to this object ID
CONST GTCustom_Control          = TAG_USER + 4    -> Controls another gadget
CONST GTCustom_TextAttr         = TAG_USER + 6    -> TextAttr to use
CONST GTCustom_MinMax           = TAG_USER + 24   -> Minimum and maximum bounds
CONST GTCustom_ThinBorders      = TAG_USER + 27   -> Gadget has thin borders
CONST GTCustom_LocaleKey        = TAG_USER + 29   -> Key from locale string
CONST GTCustom_NoSelectNext     = TAG_USER + 31   -> Don't select next field
CONST GTCustom_PathFilter       = TAG_USER + 32   -> Filter path characters
CONST GTCustom_History          = TAG_USER + 33   -> History
CONST GTCustom_CopyTags         = TAG_USER + 34   -> Copy tags
CONST GTCustom_FontPens         = TAG_USER + 35   -> Place to store pens and style
CONST GTCustom_FontPenCount     = TAG_USER + 36   -> Number of pens for font requester
CONST GTCustom_FontPenTable     = TAG_USER + 37   -> Table of pens for font requester
CONST GTCustom_Bold             = TAG_USER + 38   -> Bold pen
CONST GTCustom_Secure           = TAG_USER + 39   -> Secure string field
CONST GTCustom_Integer          = TAG_USER + 40   -> Integer gadget
CONST GTCustom_TextPlacement    = TAG_USER + 41   -> Position of text
CONST GTCustom_NoGhost          = TAG_USER + 42   -> Disable without ghosting
CONST GTCustom_Style            = TAG_USER + 44   -> Pen styles
CONST GTCustom_FrameFlags       = TAG_USER + 45   -> Frame flags
CONST GTCustom_ChangeSigTask    = TAG_USER + 46   -> Task to signal on change
CONST GTCustom_ChangeSigBit     = TAG_USER + 47   -> Signal bit to use
CONST GTCustom_LayoutPos        = TAG_USER + 49   -> Use with the POSFLAGs
CONST GTCustom_Borderless       = TAG_USER + 50   -> Borderless
CONST GTCustom_Justify          = TAG_USER + 51   -> Justification

CONST LAYOUTF_SAME_HEIGHT       = 1
CONST LAYOUTF_SAME_WIDTH        = 2
CONST LAYOUTF_TOP_ALIGN         = 4
CONST LAYOUTF_BOTTOM_ALIGN      = 8
CONST LAYOUTF_LEFT_ALIGN        = 16
CONST LAYOUTF_RIGHT_ALIGN       = 32

CONST JUSTIFY_LEFT        = 0
CONST JUSTIFY_RIGHT       = 1
CONST JUSTIFY_CENTER      = 2

CONST DIA_Type        = TAG_USER + 5    -> Image type
CONST DIA_FrontPen    = TAG_USER + 7    -> Image front pen

CONST IM_ARROW_UP   = 0
CONST IM_ARROW_DOWN = 1
CONST IM_CHECK      = 2
CONST IM_DRAWER     = 3
CONST IM_BORDER_BOX = 4
CONST IM_BBOX       = 5
CONST IM_ICONIFY    = 6
CONST IM_CROSS      = 7
CONST IM_LOCK       = 8

CONST OPUS_LISTVIEW_KIND = 127     -> Custom listview gadget
CONST FILE_BUTTON_KIND   = 126     -> File button gadget
CONST DIR_BUTTON_KIND    = 125     -> Directory button gadget
CONST FONT_BUTTON_KIND   = 124     -> Font button gadget
CONST FIELD_KIND         = 123     -> Text field (no editing)
CONST FRAME_KIND         = 122     -> Frame
CONST HOTKEY_KIND        = 121     -> Hotkey field

-> Listview tags
CONST DLV_TextAttr        = TAG_USER + 6        -> TextAttr to use
CONST DLV_ScrollUp        = TAG_USER + 7        -> Scroll list up
CONST DLV_ScrollDown      = TAG_USER + 8        -> Scroll list down
CONST DLV_SelectPrevious  = TAG_USER + 11       -> Select previous item
CONST DLV_SelectNext      = TAG_USER + 12       -> Select next item
CONST DLV_Labels          = GTLV_LABELS         -> Labels
CONST DLV_Top             = GTLV_TOP            -> Top item
CONST DLV_MakeVisible     = GTLV_MAKEVISIBLE    -> Make visible
CONST DLV_Selected        = GTLV_SELECTED       -> Selected
CONST DLV_ScrollWidth     = GTLV_SCROLLWIDTH    -> Scroller width
CONST DLV_ShowSelected    = GTLV_SHOWSELECTED   -> Show selected
CONST DLV_Check           = TAG_USER + 10       -> Check selection
CONST DLV_Highlight       = TAG_USER + 14       -> Highlight selection
CONST DLV_MultiSelect     = TAG_USER + 9        -> Multi-selection
CONST DLV_ReadOnly        = GTLV_READONLY       -> Read only
CONST DLV_Lines           = TAG_USER + 13       -> Visible lines (get only)
CONST DLV_ShowChecks      = TAG_USER + 15       -> Show checkmarks
CONST DLV_Flags           = TAG_USER + 16       -> Layout flags
CONST DLV_NoScroller      = TAG_USER + 17       -> No scroller necessary
CONST DLV_TopJustify      = TAG_USER + 18       -> Top-justify items
CONST DLV_RightJustify    = TAG_USER + 19       -> Right-justify items
CONST DLV_DragNotify      = TAG_USER + 20       -> Notify of drags
CONST DLV_GetLine         = TAG_USER + 25       -> Get line from coordinate
CONST DLV_DrawLine        = TAG_USER + 26       -> Draw a line from the listview
CONST DLV_Object          = TAG_USER + 27       -> Pointer to object
CONST DLV_DoubleClick     = TAG_USER + 28       -> Indicates double-click
CONST DLV_ShowFilenames   = TAG_USER + 48       -> Show filenames only

OBJECT listViewDraw
    rp:PTR TO rastport
    drawinfo:PTR TO drawinfo
    node:PTR TO ln
    line:INT
    box:ibox
ENDOBJECT

-> Listview node data
-> CONST lve_Flags       = ln_Type         -> Listview entry flags
-> CONST lve_Pen         = ln_Pri          -> Listview entry pen
CONST LVEF_SELECTED   = 1               -> Entry is selected
CONST LVEF_USE_PEN    = 2               -> Use pen to render entry
CONST LVEF_TEMP       = 4               -> Temporary flag for something

-> File button tags
CONST DFB_DefPath     = TAG_USER + 19       -> Default path

-> Palette tags
CONST DPG_Pen               = TAG_USER + 21       -> Ordinal selected pen
CONST DPG_SelectPrevious    = TAG_USER + 22       -> Select previous pen
CONST DPG_SelectNext        = TAG_USER + 23       -> Select next pen

-> Some useful macros
#define GADGET(obj) (obj.info.gl.gadget)
#define AREA(obj) obj.info.area
#define DATA(win) (win.userdata)
#define WINFLAG(win) (win.userdata.flags)
#define WINMEMORY(win) (win.userdata.memory)
#define WINREQUESTER(win) (win.userdata.request)
#define OBJLIST(win) (win.userdata.list)
#define DRAWINFO(win) (win.userdata.drawinfo)
#define VISINFO(win) (win.userdata.visinfo)
#define GADSPECIAL(list,id) (GADGET(L_GetObject(list,id)).specialinfo)
#define GADSTRING(list,id) (GADSPECIAL(list,id).buffer)
#define GADNUMBER(list,id) (GADSPECIAL(list,id).longint)
#define GADSEL(list,id) (GADGET(L_GetObject(list,id)).flags AND GFLG_SELECTED)
#define GADGET_SPECIAL(list,id) (GADGET(GetObject(list,id)).specialinfo)
#define GADGET_STRING(list,id) (GADGET_SPECIAL(list,id)).buffer)
#define GADGET_NUMBER(list,id) (GADGET_SPECIAL(list,id)).longint)
#define GADGET_SEL(list,id) (GADGET(GetObject(list,id)).flags AND GFLG_SELECTED)
#define CFGDATA(win) (win.userdata.data)

#define MENUID(menu) (GTMENUITEM_USERDATA(menu))

#define RECTWIDTH(rect)     (1+(rect.maxx)-(rect.minx))
#define RECTHEIGHT(rect)    (1+(rect.maxy)-(rect.miny))
