OPT MODULE
OPT EXPORT
OPT PREPROCESS
/*  $VER: libraries/bguic.e 41.6 (27.7.96)
**  support file for old style typo
**
**  (C) Copyright 1996 Dominique Dutoit
**  All Rights Reserved.
**/

MODULE  'libraries/bgui', 'exec/types', 'exec/tasks', 'intuition/classes', 'intuition/classusr', 'intuition/imageclass',
        'intuition/gadgetclass', 'intuition/cghooks', 'libraries/commodities', 'libraries/gadtools',
        'libraries/locale', 'utility/tagitem', 'utility/hooks', 'graphics/text', 'graphics/rastport',
        'graphics/gfx', 'intuition/screens', 'intuition/intuition', 'devices/inputevent'

CONST   FRM_TYPE                        = FRM_Type,
        FRM_CUSTOMHOOK                  = FRM_CustomHook,
        FRM_BACKFILLHOOK                = FRM_BackFillHook,
        FRM_TITLE                       = FRM_Title,
        FRM_TEXTATTR                    = FRM_TextAttr,
        FRM_FLAGS                       = FRM_Flags,
        FRM_FRAMEWIDTH                  = FRM_FrameWidth,
        FRM_FRAMEHEIGHT                 = FRM_FrameHeight,
        FRM_BACKFILL                    = FRM_BackFill,
        FRM_EDGESONLY                   = FRM_EdgesOnly,
        FRM_RECESSED                    = FRM_Recessed,
        FRM_CENTERTITLE                 = FRM_CenterTitle,
        FRM_HIGHLIGHTTITLE              = FRM_HighlightTitle,
        FRM_THINFRAME                   = FRM_ThinFrame,
        FRM_BACKPEN                     = FRM_BackPen,
        FRM_SELECTEDBACKPEN             = FRM_SelectedBackPen,
        FRM_BACKDRIPEN                  = FRM_BackDriPen,
        FRM_SELECTEDBACKDRIPEN          = FRM_SelectedBackDriPen,
        FRM_TITLELEFT                   = FRM_TitleLeft,
        FRM_TITLERIGHT                  = FRM_TitleRight,
        FRM_BACKRASTERPEN               = FRM_BackRasterPen,
        FRM_BACKRASTERDRIPEN            = FRM_BackRasterDriPen,
        FRM_SELECTEDBACKRASTERPEN       = FRM_SelectedBackRasterPen,
        FRM_SELECTEDBACKRASTERDRIPEN    = FRM_SelectedBackRasterDriPen,
        FRM_TEMPLATE                    = FRM_Template,
        FRM_TITLEID                     = FRM_TitleID,
        FRM_FILLPATTERN                 = FRM_FillPattern,
        FRM_SELECTEDFILLPATTERN         = FRM_SelectedFillPattern,
        FRM_OUTEROFFSETLEFT             = FRM_OuterOffsetLeft,
        FRM_OUTEROFFSETRIGHT            = FRM_OuterOffsetRight,
        FRM_OUTEROFFSETTOP              = FRM_OuterOffsetTop,
        FRM_OUTEROFFSETBOTTOM           = FRM_OuterOffsetBottom,
        FRM_INNEROFFSETLEFT             = FRM_InnerOffsetLeft,
        FRM_INNEROFFSETRIGHT            = FRM_InnerOffsetRight,
        FRM_INNEROFFSETTOP              = FRM_InnerOffsetTop,
        FRM_INNEROFFSETBOTTOM           = FRM_InnerOffsetBottom,

        LAB_TEXTATTR        = LAB_TextAttr,
        LAB_STYLE           = LAB_Style,
        LAB_UNDERSCORE      = LAB_Underscore,
        LAB_PLACE           = LAB_Place,
        LAB_LABEL           = LAB_Label,
        LAB_FLAGS           = LAB_Flags,
        LAB_HIGHLIGHT       = LAB_Highlight,
        LAB_HIGHUSCORE      = LAB_HighUScore,
        LAB_PEN             = LAB_Pen,
        LAB_SELECTEDPEN     = LAB_SelectedPen,
        LAB_DRIPEN          = LAB_DriPen,
        LAB_SELECTEDDRIPEN  = LAB_SelectedDriPen,
        LAB_LABELID         = LAB_LabelID,
        LAB_TEMPLATE        = LAB_Template,

        VIT_VECTORARRAY     = VIT_VectorArray,
        VIT_BUILTIN         = VIT_BuiltIn,
        VIT_PEN             = VIT_Pen,
        VIT_DRIPEN          = VIT_DriPen,
        VIT_SCALEWIDTH      = VIT_ScaleWidth,
        VIT_SCALEHEIGHT     = VIT_ScaleHeight,

        BT_HELPFILE         = BT_HelpFile,
        BT_HELPNODE         = BT_HelpNode,
        BT_HELPLINE         = BT_HelpLine,
        BT_INHIBIT          = BT_Inhibit,
        BT_HITBOX           = BT_HitBox,
        BT_LABELOBJECT      = BT_LabelObject,
        BT_FRAMEOBJECT      = BT_FrameObject,
        BT_TEXTATTR         = BT_TextAttr,
        BT_NORECESSED       = BT_NoRecessed,
        BT_LABELCLICK       = BT_LabelClick,
        BT_HELPTEXT         = BT_HelpText,
        BT_TOOLTIP          = BT_ToolTip,
        BT_DRAGOBJECT       = BT_DragObject,
        BT_DROPOBJECT       = BT_DropObject,
        BT_DRAGTRESHOLD     = BT_DragTreshold,
        BT_DRAGQUALIFIER    = BT_DragQualifier,
        BT_KEY              = BT_Key,
        BT_RAWKEY           = BT_RawKey,
        BT_QUALIFIER        = BT_Qualifier,
        BT_HELPTEXTID       = BT_HelpTextID,
        BT_TOOLTIPID        = BT_ToolTipID,
        BT_MOUSEACTIVATION  = BT_MouseActivation,

        GROUP_STYLE             = GROUP_Style,
        GROUP_SPACING           = GROUP_Spacing,
        GROUP_HORIZOFFSET       = GROUP_HorizOffset,
        GROUP_VERTOFFSET        = GROUP_VertOffset,
        GROUP_LEFTOFFSET        = GROUP_LeftOffset,
        GROUP_TOPOFFSET         = GROUP_TopOffset,
        GROUP_RIGHTOFFSET       = GROUP_RightOffset,
        GROUP_BOTTOMOFFSET      = GROUP_BottomOffset,
        GROUP_MEMBER            = GROUP_Member,
        GROUP_SPACEOBJECT       = GROUP_SpaceObject,
        GROUP_BACKFILL          = GROUP_BackFill,
        GROUP_EQUALWIDTH        = GROUP_EqualWidth,
        GROUP_EQUALHEIGHT       = GROUP_EqualHeight,
        GROUP_INVERTED          = GROUP_Inverted,
        GROUP_BACKPEN           = GROUP_BackPen,
        GROUP_BACKDRIPEN        = GROUP_BackDriPen,
        GROUP_OFFSET            = GROUP_Offset,

        LGO_FIXWIDTH            = LGO_FixWidth,
        LGO_FIXHEIGHT           = LGO_FixHeight,
        LGO_WEIGHT              = LGO_Weight,
        LGO_FIXMINWIDTH         = LGO_FixMinWidth,
        LGO_FIXMINHEIGHT        = LGO_FixMinHeight,
        LGO_ALIGN               = LGO_Align,
        LGO_NOALIGN             = LGO_NoAlign,
        LGO_FIXASPECT           = LGO_FixAspect,

        BUTTON_IMAGE            = BUTTON_Image,
        BUTTON_SELECTEDIMAGE    = BUTTON_SelectedImage,
        BUTTON_ENCLOSEIMAGE     = BUTTON_EncloseImage,
        BUTTON_VECTOR           = BUTTON_Vector,
        BUTTON_SELECTEDVECTOR   = BUTTON_SelectedVector,

        CYC_LABELS              = CYC_Labels,
        CYC_ACTIVE              = CYC_Active,
        CYC_POPUP               = CYC_Popup,
        CYC_POPACTIVE           = CYC_PopActive,

        INFO_TEXTFORMAT         = INFO_TextFormat,
        INFO_ARGS               = INFO_Args,
        INFO_MINLINES           = INFO_MinLines,
        INFO_FIXTEXTWIDTH       = INFO_FixTextWidth,
        INFO_HORIZOFFSET        = INFO_HorizOffset,
        INFO_VERTOFFSET         = INFO_VertOffset,

        LISTV_RESOURCEHOOK          = LISTV_ResourceHook,
        LISTV_DISPLAYHOOK           = LISTV_DisplayHook,
        LISTV_COMPAREHOOK           = LISTV_CompareHook,
        LISTV_TOP                   = LISTV_Top,
        LISTV_LISTFONT              = LISTV_ListFont,
        LISTV_READONLY              = LISTV_ReadOnly,
        LISTV_MULTISELECT           = LISTV_MultiSelect,
        LISTV_ENTRYARRAY            = LISTV_EntryArray,
        LISTV_SELECT                = LISTV_Select,
        LISTV_MAKEVISIBLE           = LISTV_MakeVisible,
        LISTV_ENTRY                 = LISTV_Entry,
        LISTV_SORTENTRYARRAY        = LISTV_SortEntryArray,
        LISTV_ENTRYNUMBER           = LISTV_EntryNumber,
        LISTV_TITLEHOOK             = LISTV_TitleHook,
        LISTV_LASTCLICKED           = LISTV_LastClicked,
        LISTV_THINFRAMES            = LISTV_ThinFrames,
        LISTV_LASTCLICKEDNUM        = LISTV_LastClickedNum,
        LISTV_NEWPOSITION           = LISTV_NewPosition,
        LISTV_NUMENTRIES            = LISTV_NumEntries,
        LISTV_MINENTRIESSHOWN       = LISTV_MinEntriesShown,
        LISTV_SELECTMULTI           = LISTV_SelectMulti,
        LISTV_SELECTNOTVISIBLE      = LISTV_SelectNotVisible,
        LISTV_SELECTMULTINOTVISIBLE = LISTV_SelectMultiNotVisible,
        LISTV_MULTISELECTNOSHIFT    = LISTV_MultiSelectNoShift,
        LISTV_DESELECT              = LISTV_Deselect,
        LISTV_DROPSPOT              = LISTV_DropSpot,
        LISTV_SHOWDROPSPOT          = LISTV_ShowDropSpot,
        LISTV_VIEWBOUNDS            = LISTV_ViewBounds,
        LISTV_CUSTOMDISABLE         = LISTV_CustomDisable,
        LISTV_FILTERHOOK            = LISTV_FilterHook,
        LISTV_COLUMNS               = LISTV_Columns,
        LISTV_COLUMNWEIGHTS         = LISTV_ColumnWeights,
        LISTV_DRAGCOLUMNS           = LISTV_DragColumns,
        LISTV_TITLES                = LISTV_Titles,
        LISTV_PROPOBJECT            = LISTV_PropObject,
        LISTV_PRECLEAR              = LISTV_PreClear,
        LISTV_LASTCOLUMN            = LISTV_LastColumn,

        LISTV_SELECT_FIRST          = LISTV_Select_First,
        LISTV_SELECT_LAST           = LISTV_Select_Last,
        LISTV_SELECT_NEXT           = LISTV_Select_Next,
        LISTV_SELECT_PREVIOUS       = LISTV_Select_Previous,
        LISTV_SELECT_TOP            = LISTV_Select_Top,
        LISTV_SELECT_PAGE_UP        = LISTV_Select_Page_Up,
        LISTV_SELECT_PAGE_DOWN      = LISTV_Select_Page_Down,
        LISTV_SELECT_ALL            = LISTV_Select_All,

        PROGRESS_MIN            = PROGRESS_Min,
        PROGRESS_MAX            = PROGRESS_Max,
        PROGRESS_DONE           = PROGRESS_Done,
        PROGRESS_VERTICAL       = PROGRESS_Vertical,
        PROGRESS_DIVISOR        = PROGRESS_Divisor,
        PROGRESS_FORMATSTRING   = PROGRESS_FormatString,

        PGA_ARROWS              = PGA_Arrows,
        PGA_ARROWSIZE           = PGA_ArrowSize,
        PGA_THINFRAME           = PGA_ThinFrame,
        PGA_XENFRAME            = PGA_XenFrame,
        PGA_NOFRAME             = PGA_NoFrame,

        STRINGA_MINCHARSVISIBLE = STRINGA_MinCharsVisible,
        STRINGA_INTEGERMIN      = STRINGA_IntegerMin,
        STRINGA_INTEGERMAX      = STRINGA_IntegerMax,
        STRINGA_STRINGINFO      = STRINGA_StringInfo,

        VIEW_MINWIDTH           = VIEW_MinWidth,
        VIEW_MINHEIGHT          = VIEW_MinHeight,
        VIEW_OBJECT             = VIEW_Object,
        VIEW_NODISPOSEOBJECT    = VIEW_NoDisposeObject,

        PAGE_ACTIVE             = PAGE_Active,
        PAGE_MEMBER             = PAGE_Member,
        PAGE_NOBUFFERRP         = PAGE_NoBufferRP,
        PAGE_INVERTED           = PAGE_Inverted,

        MX_LABELS               = MX_Labels,
        MX_ACTIVE               = MX_Active,
        MX_LABELPLACE           = MX_LabelPlace,
        MX_DISABLEBUTTON        = MX_DisableButton,
        MX_ENABLEBUTTON         = MX_EnableButton,
        MX_TABSOBJECT           = MX_TabsObject,
        MX_TABSTEXTATTR         = MX_TabsTextAttr,
        MX_TABSUPSIDEDOWN       = MX_TabsUpsideDown,
        MX_TABSBACKFILL         = MX_TabsBackFill,
        MX_TABSBACKPEN          = MX_TabsBackPen,
        MX_TABSBACKDRIPEN       = MX_TabsBackDriPen,
        MX_LABELSID             = MX_LabelsID,
        MX_SPACING              = MX_Spacing,

        SLIDER_MIN              = SLIDER_Min,
        SLIDER_MAX              = SLIDER_Max,
        SLIDER_LEVEL            = SLIDER_Level,
        SLIDER_THINFRAME        = SLIDER_ThinFrame,
        SLIDER_XENFRAME         = SLIDER_XenFrame,
        SLIDER_NOFRAME          = SLIDER_NoFrame,

        INDIC_MIN               = INDIC_Min,
        INDIC_MAX               = INDIC_Max,
        INDIC_LEVEL             = INDIC_Level,
        INDIC_FORMATSTRING      = INDIC_FormatString,
        INDIC_JUSTIFICATION     = INDIC_Justification,

        EXT_CLASS               = EXT_Class,
        EXT_CLASSID             = EXT_ClassID,
        EXT_MINWIDTH            = EXT_MinWidth,
        EXT_MINHEIGHT           = EXT_MinHeight,
        EXT_TRACKATTR           = EXT_TrackAttr,
        EXT_OBJECT              = EXT_Object,
        EXT_NOREBUILD           = EXT_NoRebuild,

        SEP_HORIZ               = SEP_Horiz,
        SEP_TITLE               = SEP_Title,
        SEP_THIN                = SEP_Thin,
        SEP_HIGHLIGHT           = SEP_Highlight,
        SEP_CENTERTITLE         = SEP_CenterTitle,
        SEP_RECESSED            = SEP_Recessed,
        SEP_TITLELEFT           = SEP_TitleLeft,
        SEP_TITLERIGHT          = SEP_TitleRight,

        WINDOW_POSITION         = WINDOW_Position,
        WINDOW_SCALEWIDTH       = WINDOW_ScaleWidth,
        WINDOW_SCALEHEIGHT      = WINDOW_ScaleHeight,
        WINDOW_LOCKWIDTH        = WINDOW_LockWidth,
        WINDOW_LOCKHEIGHT       = WINDOW_LockHeight,
        WINDOW_POSRELBOX        = WINDOW_PosRelBox,
        WINDOW_BOUNDS           = WINDOW_Bounds,
        WINDOW_DRAGBAR          = WINDOW_DragBar,
        WINDOW_SIZEGADGET       = WINDOW_SizeGadget,
        WINDOW_CLOSEGADGET      = WINDOW_CloseGadget,
        WINDOW_DEPTHGADGET      = WINDOW_DepthGadget,
        WINDOW_SIZEBOTTOM       = WINDOW_SizeBottom,
        WINDOW_SIZERIGHT        = WINDOW_SizeRight,
        WINDOW_ACTIVATE         = WINDOW_Activate,
        WINDOW_RMBTRAP          = WINDOW_RMBTrap,
        WINDOW_SMARTREFRESH     = WINDOW_SmartRefresh,
        WINDOW_REPORTMOUSE      = WINDOW_ReportMouse,
        WINDOW_BORDERLESS       = WINDOW_Borderless,
        WINDOW_BACKDROP         = WINDOW_Backdrop,
        WINDOW_SHOWTITLE        = WINDOW_ShowTitle,
        WINDOW_SHAREDPORT       = WINDOW_SharedPort,
        WINDOW_TITLE            = WINDOW_Title,
        WINDOW_SCREENTITLE      = WINDOW_ScreenTitle,
        WINDOW_MENUSTRIP        = WINDOW_MenuStrip,
        WINDOW_MASTERGROUP      = WINDOW_MasterGroup,
        WINDOW_SCREEN           = WINDOW_Screen,
        WINDOW_PUBSCREENNAME    = WINDOW_PubScreenName,
        WINDOW_USERPORT         = WINDOW_UserPort,
        WINDOW_SIGMASK          = WINDOW_SigMask,
        WINDOW_IDCMPHOOK        = WINDOW_IDCMPHook,
        WINDOW_VERIFYHOOK       = WINDOW_VerifyHook,
        WINDOW_IDCMPHOOKBITS    = WINDOW_IDCMPHookBits,
        WINDOW_VERIFYHOOKBITS   = WINDOW_VerifyHookBits,
        WINDOW_FONT             = WINDOW_Font,
        WINDOW_FALLBACKFONT     = WINDOW_FallBackFont,
        WINDOW_HELPFILE         = WINDOW_HelpFile,
        WINDOW_HELPNODE         = WINDOW_HelpNode,
        WINDOW_HELPLINE         = WINDOW_HelpLine,
        WINDOW_APPWINDOW        = WINDOW_AppWindow,
        WINDOW_APPMASK          = WINDOW_AppMask,
        WINDOW_UNIQUEID         = WINDOW_UniqueID,
        WINDOW_WINDOW           = WINDOW_Window,
        WINDOW_HELPTEXT         = WINDOW_HelpText,
        WINDOW_NOBUFFERRP       = WINDOW_NoBufferRP,
        WINDOW_AUTOASPECT       = WINDOW_AutoAspect,
        WINDOW_PUBSCREEN        = WINDOW_PubScreen,
        WINDOW_CLOSEONESC       = WINDOW_CloseOnEsc,
        WINDOW_ACTNEXT          = WINDOW_ActNext,
        WINDOW_ACTPREV          = WINDOW_ActPrev,
        WINDOW_NOVERIFY         = WINDOW_NoVerify,
        WINDOW_MENUFONT         = WINDOW_MenuFont,
        WINDOW_TOOLTICKS        = WINDOW_ToolTicks,
        WINDOW_LBORDERGROUP     = WINDOW_LBorderGroup,
        WINDOW_TBORDERGROUP     = WINDOW_TBorderGroup,
        WINDOW_RBORDERGROUP     = WINDOW_RBorderGroup,
        WINDOW_BBORDERGROUP     = WINDOW_BBorderGroup,
        WINDOW_TITLEZIP         = WINDOW_TitleZip,
        WINDOW_AUTOKEYLABEL     = WINDOW_AutoKeyLabel,
        WINDOW_TITLEID          = WINDOW_TitleID,
        WINDOW_SCREENTITLEID    = WINDOW_ScreenTitleID,
        WINDOW_HELPTEXTID       = WINDOW_HelpTextID,
        WINDOW_LOCALE           = WINDOW_Locale,
        WINDOW_CATALOG          = WINDOW_Catalog,

        COMM_NAME               = COMM_Name,
        COMM_TITLE              = COMM_Title,
        COMM_DESCRIPTION        = COMM_Description,
        COMM_UNIQUE             = COMM_Unique,
        COMM_NOTIFY             = COMM_Notify,
        COMM_SHOWHIDE           = COMM_ShowHide,
        COMM_PRIORITY           = COMM_Priority,
        COMM_SIGMASK            = COMM_SigMask,
        COMM_ERRORCODE          = COMM_ErrorCode,

        FILEREQ_DRAWER          = FILEREQ_Drawer,
        FILEREQ_FILE            = FILEREQ_File,
        FILEREQ_PATTERN         = FILEREQ_Pattern,
        FILEREQ_PATH            = FILEREQ_Path,
        ASLREQ_LEFT             = ASLREQ_Left,
        ASLREQ_TOP              = ASLREQ_Top,
        ASLREQ_WIDTH            = ASLREQ_Width,
        ASLREQ_HEIGHT           = ASLREQ_Height,
        FILEREQ_MULTIHOOK       = FILEREQ_MultiHook,
        ASLREQ_TYPE             = ASLREQ_Type,
        ASLREQ_REQUESTER        = ASLREQ_Requester,
        FONTREQ_TEXTATTR        = FONTREQ_TextAttr,
        FONTREQ_NAME            = FONTREQ_Name,
        FONTREQ_SIZE            = FONTREQ_Size,
        FONTREQ_STYLE           = FONTREQ_Style,
        FONTREQ_FLAGS           = FONTREQ_Flags,
        FONTREQ_FRONTPEN        = FONTREQ_FrontPen,
        FONTREQ_BACKPEN         = FONTREQ_BackPen,
        FONTREQ_DRAWMODE        = FONTREQ_DrawMode,

        FRQ_LEFT                = ASLREQ_Left,
        FRQ_TOP                 = ASLREQ_Top,
        FRQ_WIDTH               = ASLREQ_Width,
        FRQ_HEIGHT              = ASLREQ_Height,
        FRQ_DRAWER              = FILEREQ_Drawer,
        FRQ_FILE                = FILEREQ_File,
        FRQ_PATTERN             = FILEREQ_Pattern,
        FRQ_PATH                = FILEREQ_Path,
        FRQ_MULTIHOOK           = FILEREQ_MultiHook,

        AREA_MINWIDTH           = AREA_MinWidth,
        AREA_MINHEIGHT          = AREA_MinHeight,
        AREA_AREABOX            = AREA_AreaBox

OBJECT bguirequest
    flags:LONG                  -> See below
    title:LONG                  -> Requester title
    gadgetformat:LONG           -> Gadget labels
    textformat:LONG             -> Body text format
    reqpos:INT                  -> Requester position
    textattr:PTR TO textattr    -> Body text format
    underscore:CHAR             -> Requester font
    reserved0:LONG              -> Set to 0
    screen:PTR TO screen        -> Optional screen pointer
    reserved1:LONG              -> Set to 0
ENDOBJECT

OBJECT  bguilocale
        locale:PTR TO locale            -> Locale to use.
        catalog:PTR TO catalog          -> Catalog to use.
        localestrhook:PTR TO hook       -> Localization function.
        catalogstrhook:PTR TO hook      -> Localization function.
        userdata:LONG                   -> For application use.
ENDOBJECT

OBJECT  bguilocalestr
        id:LONG                 -> ID of locale string.
ENDOBJECT

OBJECT  bguicatalogstr
        id:LONG                 -> ID of locale string.
        defaultstring:LONG      -> Default string for this ID.
ENDOBJECT

OBJECT bguipattern
       flags:LONG               -> flags (see below)
       left:INT                -> offset into bitmap
       top:INT
       width:INT               -> size of cut from bitmap
       height:INT
       bitmap:PTR TO bitmap     -> pattern bitmap
       object:PTR TO object     -> datatype object
ENDOBJECT

OBJECT framedrawmsg
    methodid:LONG               -> FRM_RENDER
    rport:PTR TO rastport       -> RastPort ready for rendering
    drawinfo:PTR TO drawinfo    -> All you need to render
    bounds:PTR TO rectangle     -> Rendering bounds
    state:INT                   -> See "intuition/imageclass.h"
    horizontal:CHAR             -> Horizontal thickness
    vertical:CHAR               -> Vertical thickness
ENDOBJECT

OBJECT thicknessmsg
    methodid:LONG                       -> FRM_THICKNESS
    thicknesshorizontal:PTR TO CHAR     -> Storage for horizontal
    thicknessvertical:PTR TO CHAR       -> Storage for vertical
    thin:INT                            -> Added in V38!
ENDOBJECT

OBJECT impextent
    methodid:LONG           /* IM_EXTENT            */
    rport:PTR TO rastport           /* RastPort         */
    extent:PTR TO ibox              /* Storage for extentions.  */
    labelsizewidth:PTR TO INT       /* Storage width in pixels  */
    labelsizeheight:PTR TO INT      /* Storage height in pixels */
    flags:INT                       /* See below.           */
ENDOBJECT

OBJECT vectoritem
    x:INT        /* X coordinate or data */
    y:INT        /* Y coordinate         */
    flags:LONG   /* See below        */
ENDOBJECT

OBJECT bmAddMap
    methodid:LONG
    object:PTR TO object
    maplist:PTR TO tagitem
ENDOBJECT

OBJECT bmaddconditional
    methodid:LONG
    object:PTR TO object
    condition:tagitem
    true:tagitem
    false:tagitem
ENDOBJECT

OBJECT bmaddmethod
    methodid:LONG
    object:PTR TO object
    flags:LONG
    size:LONG
    amethodid:LONG
ENDOBJECT

OBJECT bmremove
    methodid:LONG
    object:PTR TO object
ENDOBJECT

OBJECT bmshowhelp
    methodid:LONG
    window:PTR TO  window
    requester:PTR TO requester
    mousex:INT
    mousey:INT
ENDOBJECT

OBJECT bmaddhook
    methodid:LONG
    hook:PTR TO hook
ENDOBJECT

OBJECT bmdragpoint
    methodid:LONG               -> BASE_DRAGQUERY
    ginfo:PTR TO gadgetinfo     -> GadgetInfo
    source:PTR TO object        -> Object querying.
    mousex:INT                  -> Mouse coords.
    mousey:INT                  -> Mouse coords.
ENDOBJECT

OBJECT bmdropped
    methodid:LONG
    ginfo:PTR TO gadgetinfo         -> GadgetInfo structure
    source:PTR TO object            -> Object dropped
    sourcewin:PTR TO window         -> Source obj window
    sourcereq:PTR TO requester      -> Source onj requester
ENDOBJECT

OBJECT bmdragmsg
    methodid:LONG
    ginfo:PTR TO gadgetinfo        -> GadgetInfo structure
    source:PTR TO object           -> Object being dragged
ENDOBJECT

OBJECT bmgetdragobject
    methodid:LONG       -> BASE_GETDRAGOBJECT
    ginfo:PTR TO gadgetinfo     -> GadgetInfo
    bounds:PTR TO ibox          -> Bounds to buffer
ENDOBJECT

OBJECT bmfreedragobject
    methodid:LONG                   -> BASE_FREEDRAGOBJECT
    ginfo:PTR TO gadgetinfo         -> GadgetInfo
    objbitmap:PTR TO bitmap         -> BitMap to free
ENDOBJECT

OBJECT bminhibit
    methodid:LONG                   -> BASE_INHIBIT
    inhibit:LONG                    -> Inhinit on/off
ENDOBJECT

OBJECT  bmfindkey
    methodid:LONG           -> BASE_FINDKEY
    qual:INT                -> Key to find
    key:INT
ENDOBJECT

OBJECT  bmkeylabel
    methodid:LONG   -> BASE_KEYLABEL
ENDOBJECT

OBJECT bmlocalize
    methodid:LONG
    locale:PTR TO bguilocale
ENDOBJECT

OBJECT grmaddmember
    methodid:LONG           -> GRM_ADDMEMBER
    member:PTR TO object    -> Object to add
    attr:LONG               -> First of LGO attributes
ENDOBJECT

OBJECT grmremmember
    methodid:LONG    -> GRM_REMMEMBER
    member:PTR TO object     -> Object to remove
ENDOBJECT

OBJECT grmdimensions
    methodid:LONG               -> GRM_DIMENSIONS
    ginfo:PTR TO gadgetinfo     -> Can be NIL!
    rport:PTR TO rastport       -> Ready for calculations
    minsizewidth:PTR TO INT
    minsizeheight:PTR TO INT
    flags:LONG                  -> See below
ENDOBJECT

OBJECT grmaddspacemember
    methodid:LONG       -> GRM_ADDSPACEMEMBER
    weight:LONG         -> Object weight
ENDOBJECT

OBJECT grminsertmember
    methodid:LONG           -> GRM_INSERTMEMBER
    member:PTR TO object    -> Member to insert
    pred:PTR TO object      -> Insert after this member
    attr:LONG               -> First of LGO attributes
ENDOBJECT

OBJECT grmreplacemember
    methodid:LONG           -> GRM_REPLACEMEMBER
    membera:PTR TO object   -> Object to replace
    memberb:PTR TO object   -> Object which replaces
    attr:LONG               -> First of LGO attributes
ENDOBJECT

OBJECT grmwhichobject
    methodid:LONG   -> GRM_WHICHOBJECT
    coordsx:INT
    coordsy:INT
ENDOBJECT

OBJECT grmmaxdimensions
    methodid:LONG
    ginfo:PTR TO gadgetinfo -> Can be NIL
    rport:PTR TO rastport
    maxsizewidth:PTR TO LONG
    maxsizeheight:PTR TO LONG
    flags:LONG
ENDOBJECT

OBJECT lvresource
    command:INT
    entry:PTR TO LONG
ENDOBJECT

OBJECT lvrender
    rport:PTR TO rastport       /* RastPort to render in.  */
    drawinfo:PTR TO drawinfo    /* All you need to render. */
    bounds:rectangle            /* Bounds to render in.    */
    entry:PTR TO LONG           /* Entry to render.    */
    state:INT                   /* See below.          */
    flags:INT                   /* None defined yet.       */
    column:INT                  /* column to render         */
ENDOBJECT

OBJECT lvcompare
    entrya:PTR TO LONG      /* First entry.  */
    entryb:PTR TO LONG      /* Second entry. */
ENDOBJECT

OBJECT lvmaddentries
    methodid:LONG               /* LVM_ADDENTRIES  */
    ginfo:PTR TO gadgetinfo     /* GadgetInfo      */
    entries:PTR TO LONG         /* Entries to add. */
    how:LONG                    /* How to add it.  */
ENDOBJECT

OBJECT lvmaddsingle
    methodid:LONG           /* LVM_ADDSINGLE */
    ginfo:PTR TO gadgetinfo /* GadgetInfo    */
    entry:PTR TO LONG       /* Entry to add. */
    how:LONG                /* See above.    */
    flags:LONG              /* See below.    */
ENDOBJECT

OBJECT lvmgetentry
    methodid:LONG           /* Any of the above. */
    previous:PTR TO LONG    /* Previous entry.   */
    flags:LONG              /* See below.        */
ENDOBJECT

OBJECT lvmrementry
    methodid:LONG   /* LVM_REMENTRY      */
    ginfo:PTR TO gadgetinfo /* GadgetInfo        */
    entry:PTR TO LONG       /* Entry to remove.  */
ENDOBJECT

OBJECT lvmcommand
    methodid:LONG           /* LVM_REFRESH       */
    ginfo:PTR TO gadgetinfo /* GadgetInfo        */
ENDOBJECT

OBJECT lvmmove
    methodid:LONG           /* LVM_MOVE      */
    ginfo:PTR TO gadgetinfo /* GadgetInfo        */
    entry:PTR TO LONG       /* Entry to move     */
    direction:LONG          /* See below         */
    newpos:LONG             /* New position. V40 */
ENDOBJECT

OBJECT lvmreplace
    methodid:LONG              /* LVM_REPLACE       */
    ginfo:PTR TO gadgetinfo    /* GadgetInfo        */
    oldentry:PTR TO LONG       /* Entry to replace. */
    newentry:PTR TO LONG       /* New entry.        */
ENDOBJECT

OBJECT lvminsertentries
    methodid:LONG              /* LVM_INSERTENTRIES */
    ginfo:PTR TO gadgetinfo    /* GadgetInfo        */
    pos:LONG                   /* Position.         */
    entries:PTR TO LONG        /* Entries to insert.*/
ENDOBJECT

OBJECT lvminsertsingle
    methodid:LONG              /* LVM_INSERTSINGLE  */
    ginfo:PTR TO gadgetinfo    /* GadgetInfo        */
    pos:LONG                   /* Position.         */
    entry:PTR TO LONG          /* Entry to insert.  */
    flags:LONG                 /* See LVM_ADDSINGLE */
ENDOBJECT

OBJECT lvmfilter
    methodid:LONG
    flags:LONG
ENDOBJECT

OBJECT smformatstring
    methodid:LONG               /* SM_FORMAT_STRING    */
    ginfo:PTR TO gadgetinfo     /* GadgetInfo          */
    fstr:PTR TO LONG            /* Format string       */
    arg1:LONG                   /* Format arg          */
ENDOBJECT

OBJECT wmgadgetkey
    methodid:LONG                   /* WM_GADGETKEY          */
    requester:PTR TO requester      /* When used in a requester      */
    object:PTR TO object            /* Object to activate        */
    key:PTR TO LONG                 /* Key that triggers activ.      */
ENDOBJECT

OBJECT wmkeyinput
    methodid:LONG               /* WM_KEYACTIVE/WM_KEYINPUT        */
    ginfo:PTR TO gadgetinfo     /* GadgetInfo              */
    ievent:PTR TO inputevent    /* Input event                     */
    id:PTR TO LONG              /* Storage for the object ID       */
    key:PTR TO CHAR             /* Key that triggered activation.  */
ENDOBJECT

OBJECT wmkeyinactive
    methodid:LONG            /* WM_KEYINACTIVE           */
    ginfo:PTR TO gadgetinfo  /* GadgetInfo               */
ENDOBJECT

OBJECT wmmenuaction
    methodid:LONG    /* WM_DISABLEMENU/WM_CHECKITEM      */
    menuid:LONG      /* Menu it's ID                     */
    set:LONG         /* TRUE = set, FALSE = clear        */
ENDOBJECT

OBJECT wmmenuquery
    methodid:LONG    /* WM_MENUDISABLED/WM_ITEMCHECKED   */
    menuid:LONG      /* Menu it's ID                     */
ENDOBJECT

OBJECT wmtabcycleorder
    methodid:LONG    /* WM_TABCYCLE_ORDER            */
    object1:PTR TO object
ENDOBJECT

OBJECT wmaddupdate
    methodid:LONG                /* WM_ADDUPDATE             */
    sourceid:LONG                /* ID of source object.     */
    target:PTR TO object         /* Target object.       */
    maplist:PTR TO tagitem       /* Attribute map-list.      */
ENDOBJECT

OBJECT wmreportid
    methodid:LONG                /* WM_REPORT_ID             */
    id:LONG                      /* ID to report.        */
    flags:LONG                   /* See below.           */
    sigtask:PTR TO etask         /* Task to signal.  V40 */
ENDOBJECT

OBJECT wmremoveobject
    methodid:LONG        /* WM_REMOVE_OBJECT     */
    object:PTR TO object         /* Object to remove.        */
    flags:LONG                   /* See below.           */
ENDOBJECT

OBJECT cmaddhotkey
    methodid:LONG           /* CM_ADDHOTKEY             */
    inputdescription:PTR TO LONG    /* Key input description.   */
    keyid:LONG                      /* Key command ID.      */
    flags:LONG                      /* See below.           */
ENDOBJECT

OBJECT cmdokeycommand
    methodid:LONG   /* See above.               */
    keyid:LONG      /* ID of the key.           */
ENDOBJECT

OBJECT cmmsginfo
    methodid:LONG           /* CM_MSGINFO               */
    infotype:PTR TO LONG    /* Storage for CxMsgType() result.  */
    infoid:PTR TO LONG      /* Storage for CxMsgID() result.    */
    infodata:PTR TO LONG    /* Storage for CxMsgData() result.  */
ENDOBJECT
