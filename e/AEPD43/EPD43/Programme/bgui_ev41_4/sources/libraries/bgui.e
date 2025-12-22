OPT MODULE
OPT EXPORT
OPT PREPROCESS
/*  $VER: libraries/bgui.m 41.4 (29.5.96)
**
**  bgui.library objects and constants - by Dominique Dutoit
**
**  (C) Copyright 1996 Ian J. Einman.
**  (C) Copyright 1993-1996 Jaba Development.
**  (C) Copyright 1993-1996 Jan van den Baard.
**  All Rights Reserved.
**/
MODULE  'exec/types',
        'exec/tasks',
        'intuition/classes',
        'intuition/classusr',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'intuition/cghooks',
        'libraries/commodities',
        'libraries/gadtools',
        'libraries/locale',
        'utility/tagitem',
        'utility/hooks',
        'graphics/text',
        'graphics/rastport',
        'graphics/gfx',
        'intuition/screens',
        'intuition/intuition',
        'devices/inputevent'

#define BGUINAME              'bgui.library'
CONST   BGUI_MINIMUM          = 37
CONST   BGUIVERSION           = 41
/*
OBJECT  bguimethodid
    methodid:LONG
ENDOBJECT
*/
CONST   BGUI_LABEL_IMAGE      =  0,
        BGUI_FRAME_IMAGE      =  1,
        BGUI_VECTOR_IMAGE     =  2,
        BGUI_BASE_GADGET      =  11,
        BGUI_GROUP_GADGET     =  12,
        BGUI_BUTTON_GADGET    =  13,
        BGUI_CYCLE_GADGET     =  14,
        BGUI_CHECKBOX_GADGET  =  15,
        BGUI_INFO_GADGET      =  16,
        BGUI_STRING_GADGET    =  17,
        BGUI_PROP_GADGET      =  18,
        BGUI_INDICATOR_GADGET =  19,
        BGUI_PROGRESS_GADGET  =  21,
        BGUI_SLIDER_GADGET    =  22,
        BGUI_LISTVIEW_GADGET  =  23,
        BGUI_MX_GADGET        =  24,
        BGUI_PAGE_GADGET      =  25,
        BGUI_EXTERNAL_GADGET  =  26,
        BGUI_SEPARATOR_GADGET =  27,
        BGUI_AREA_GADGET      =  28,
        BGUI_WINDOW_OBJECT    =  40,
        BGUI_FILEREQ_OBJECT   =  41,
        BGUI_COMMODITY_OBJECT =  42
CONST   BGUI_SEPERATOR_GADGET =  27
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
CONST   BREQF_CENTERWINDOW              = 1,   -> Center requester on the window
        BREQF_LOCKWINDOW                = 2,   -> Lock the parent window
        BREQF_NO_PATTERN                = 4,   -> Don't use back-fill pattern
        BREQF_XEN_BUTTONS               = 8,   -> Use XEN style buttons
        BREQF_AUTO_ASPECT               = 16,  -> Aspect-ratio dependant look
        BREQF_FAST_KEYS                 = 32,  -> Return/Esc hotkeys
        BREQF_FUZZ_BUTTONS              = 64   -> Use fuzz style buttons

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
       left:LONG                -> offset into bitmap
       top:LONG
       width:LONG               -> size of cut from bitmap
       height:LONG
       bitmap:PTR TO bitmap     -> pattern bitmap
       object:PTR TO object     -> datatype object
ENDOBJECT
CONST   BPF_RELATIVE_ORIGINE            = 1      -> Origin relative to box

CONST   BGUI_TB                         = $800F0000,
        BGUI_MB                         = $F0000
CONST   FRM_TYPE                        = BGUI_TB+1,     /* ISG-- */
        FRM_CUSTOMHOOK                  = BGUI_TB+2,     /* ISG-- */
        FRM_BACKFILLHOOK                = BGUI_TB+3,     /* ISG-- */
        FRM_TITLE                       = BGUI_TB+4,     /* ISG-- */
        FRM_TEXTATTR                    = BGUI_TB+5,     /* ISG-- */
        FRM_FLAGS                       = BGUI_TB+6,     /* ISG-- */
        FRM_FRAMEWIDTH                  = BGUI_TB+7,     /* ISG-- */
        FRM_FRAMEHEIGHT                 = BGUI_TB+8,     /* ISG-- */
        FRM_BACKFILL                    = BGUI_TB+9,     /* ISG-- */
        FRM_EDGESONLY                   = BGUI_TB+10,    /* ISG-- */
        FRM_RECESSED                    = BGUI_TB+11,    /* ISG-- */
        FRM_CENTERTITLE                 = BGUI_TB+12,    /* ISG-- */
        FRM_HIGHLIGHTTITLE              = BGUI_TB+13,    /* ISG-- */
        FRM_THINFRAME                   = BGUI_TB+14,    /* ISG-- */
        FRM_BACKPEN                     = BGUI_TB+15,    /* ISG-- */  /* V39 */
        FRM_SELECTEDBACKPEN             = BGUI_TB+16,    /* ISG-- */  /* V39 */
        FRM_BACKDRIPEN                  = BGUI_TB+17,    /* ISG-- */  /* V39 */
        FRM_SELECTEDBACKDRIPEN          = BGUI_TB+18,    /* ISG-- */  /* V39 */
        FRM_TITLELEFT                   = BGUI_TB+19,    /* ISG-- */  /* V40 */
        FRM_TITLERIGHT                  = BGUI_TB+20,    /* ISG-- */  /* V40 */
        FRM_BACKRASTERPEN               = BGUI_TB+21,    /* ISG-- */  /* V41 */
        FRM_BACKRASTERDRIPEN            = BGUI_TB+22,    /* ISG-- */  /* V41 */
        FRM_SELECTEDBACKRASTERPEN       = BGUI_TB+23,    /* ISG-- */  /* V41 */
        FRM_SELECTEDBACKRASTERDRIPEN    = BGUI_TB+24,    /* ISG-- */  /* V41 */
        FRM_TEMPLATE                    = BGUI_TB+25,    /* IS--- */  /* V41 */
        FRM_TITLEID                     = BGUI_TB+26,    /* ISG-- */  /* V41 */
        FRM_FILLPATTERN                 = BGUI_TB+27,    /* ISG-- */  /* V41 */
        FRM_SELECTEDFILLPATTERN         = BGUI_TB+28,    /* ISG-- */  /* V41 */
        FRM_RESERVED0                   = BGUI_TB+80,
        FRM_TAGDONE                     = BGUI_TB+80,
        STANDARD_FILL                   = 0,
        SHINE_RASTER                    = 1,
        SHADOW_RASTER                   = 2,
        SHINE_SHADOW_RASTER             = 3,
        FILL_RASTER                     = 4,
        SHINE_FILL_RASTER               = 5,
        SHADOW_FILL_RASTER              = 6,
        SHINE_BLOCK                     = 7,
        SHADOW_BLOCK                    = 8,
        CUSTOM_FILL                     = 9,        /* V41 */
        FRF_EDGES_ONLY                  = 1,
        FRF_RECESSED                    = 2,
        FRF_CENTER_TITLE                = 4,
        FRF_HIGHLIGHT_TITLE             = 8,
        FRF_THIN_FRAME                  = 16,
        FRF_TITLE_LEFT                  = 32,         /* V40 */
        FRF_TITLE_RIGHT                 = 64,         /* V40 */
        FRTYPE_CUSTOM                   = 0,
        FRTYPE_BUTTON                   = 1,
        FRTYPE_RIDGE                    = 2,
        FRTYPE_DROPBOX                  = 3,
        FRTYPE_NEXT                     = 4,
        FRTYPE_RADIOBUTTON              = 5,
        FRTYPE_XEN_BUTTON               = 6,
        FRTYPE_TAB_ABOVE                = 7,    /* V40 */
        FRTYPE_TAB_BELOW                = 8,    /* V40 */
        FRTYPE_BORDER                   = 9,    /* V40 */
        FRTYPE_NONE                     = 10,   /* V40 */
        FRTYPE_FUZZ_BUTTON              = 11,   /* V41 */
        FRTYPE_FUZZ_RIDGE               = 12,   /* V41 */

        FRDEF                           = $80000000, /* V41 */
        FRDEF_BUTTON                    = $80000000, /* V41 */
        FRDEF_CYCLE                     = $80000001, /* V41 */
        FRDEF_CHECKBOX                  = $80000002, /* V41 */
        FRDEF_LISTVIEW                  = $80000100, /* V41 */
        FRDEF_PROP                      = $80000200, /* V41 */
        FRDEF_SCROLLER                  = $80000201, /* V41 */
        FRDEF_STRING                    = $80010000, /* V41 */
        FRDEF_INFO                      = $80020000, /* V41 */
        FRDEF_DROPBOX                   = $80020100, /* V41 */
        FRDEF_GROUP                     = $80030000, /* V41 */
        FRM_RENDER                      = 1 /* Render yourself           */
OBJECT framedrawmsg
    methodid:LONG       -> FRM_RENDER
    rport:PTR TO rastport       -> RastPort ready for rendering
    drawinfo:PTR TO drawinfo    -> All you need to render
    bounds:PTR TO rectangle     -> Rendering bounds
    state:INT                   -> See "intuition/imageclass.h"
    -> The following fields are only defined under V41.
    horizontal:CHAR             -> Horizontal thickness
    vertical:CHAR               -> Vertical thickness
ENDOBJECT
CONST   FRM_THICKNESS   = 2 /* Give the default frame thickness. */
OBJECT thicknessmsg
    methodid:LONG               -> FRM_THICKNESS
    thicknesshorizontal:PTR TO CHAR     -> Storage for horizontal
    thicknessvertical:PTR TO CHAR       -> Storage for vertical
    thin:INT                            -> Added in V38!
ENDOBJECT
CONST   FRC_OK              = 0, /* OK        */
        FRC_UNKNOWN         = 1, /* Unknow method */
        LAB_TEXTATTR        = BGUI_TB+81,    /* ISG-- */
        LAB_STYLE           = BGUI_TB+82,    /* ISG-- */
        LAB_UNDERSCORE      = BGUI_TB+83,    /* ISG-- */
        LAB_PLACE           = BGUI_TB+84,    /* ISG-- */
        LAB_LABEL           = BGUI_TB+85,    /* ISG-- */
        LAB_FLAGS           = BGUI_TB+86,    /* ISG-- */
        LAB_HIGHLIGHT       = BGUI_TB+87,    /* ISG-- */
        LAB_HIGHUSCORE      = BGUI_TB+88,    /* ISG-- */
        LAB_PEN             = BGUI_TB+89,    /* ISG-- */
        LAB_SELECTEDPEN     = BGUI_TB+90,    /* ISG-- */
        LAB_DRIPEN          = BGUI_TB+91,    /* ISG-- */
        LAB_SELECTEDDRIPEN  = BGUI_TB+92,    /* ISG-- */
        LAB_LABELID         = BGUI_TB+93,    /* ISG-- */ /* V41 */
        LAB_TEMPLATE        = BGUI_TB+94,    /* IS--- */ /* V41 */
        LAB_RESERVED2       = BGUI_TB+158,   /* PRIVATE */
        LAB_RESERVED1       = BGUI_TB+159,   /* PRIVATE */
        LAB_RESERVED0       = BGUI_TB+160,   /* PRIVATE */
        LAB_TAGDONE         = BGUI_TB+160,
        LABF_HIGHLIGHT      = 1, /* Highlight label    */
        LABF_HIGH_USCORE    = 2, /* Highlight underscoring */
        PLACE_IN            = 0,
        PLACE_LEFT          = 1,
        PLACE_RIGHT         = 2,
        PLACE_ABOVE         = 3,
        PLACE_BELOW         = 4,
        IM_EXTENT           = BGUI_MB+1
OBJECT impextent
    methodid:LONG           /* IM_EXTENT            */
    rport:PTR TO rastport           /* RastPort         */
    extent:PTR TO ibox              /* Storage for extentions.  */
    labelsizewidth:PTR TO INT       /* Storage width in pixels  */
    labelsizeheight:PTR TO INT      /* Storage height in pixels */
    flags:INT                       /* See below.           */
ENDOBJECT
CONST   EXTF_MAXIMUM        = 1, /* Request maximum extensions. */
        VIT_VECTORARRAY     = BGUI_TB+161,   /* ISG-- */
        VIT_BUILTIN         = BGUI_TB+162,   /* ISG-- */
        VIT_PEN             = BGUI_TB+163,   /* ISG-- */
        VIT_DRIPEN          = BGUI_TB+164,   /* ISG-- */
        VIT_SCALEWIDTH      = BGUI_TB+165,   /* --G-- */ /* V41 */
        VIT_SCALEHEIGHT     = BGUI_TB+166    /* --G-- */ /* V41 */

OBJECT vectoritem
    x:INT        /* X coordinate or data */
    y:INT        /* Y coordinate         */
    flags:LONG   /* See below        */
ENDOBJECT
SET     VIF_MOVE,           /* Move to x, y           */
        VIF_DRAW,           /* Draw to x, y           */
        VIF_AREASTART,      /* Start AreaFill at x, y     */
        VIF_AREAEND,        /* End AreaFill at x, y       */
        VIF_XRELRIGHT,      /* x relative to right edge      */
        VIF_YRELBOTTOM,     /* y relative to bottom edge     */
        VIF_SHADOWPEN,      /* switch to SHADOWPEN, Move/Draw   */
        VIF_SHINEPEN,       /* switch to SHINEPEN, Move/Draw    */
        VIF_FILLPEN,        /* switch to FILLPEN, Move/Draw     */
        VIF_TEXTPEN,        /* switch to TEXTPEN, Move/Draw     */
        VIF_COLOR,          /* switch to color in x      */
        VIF_LASTITEM,       /* last element of the element list */
        VIF_SCALE,          /* X & Y are design width & height  */
        VIF_DRIPEN,         /* switch to dripen x        */
        VIF_AOLPEN,         /* set area outline pen x        */
        VIF_AOLDRIPEN,      /* set area outline dripen x     */
        VIF_ENDOPEN         /* end area outline pen             */
ENUM    BUILTIN_GETPATH = 1,
        BUILTIN_GETFILE,
        BUILTIN_CHECKMARK,
        BUILTIN_POPUP,
        BUILTIN_ARROW_UP,
        BUILTIN_ARROW_DOWN,
        BUILTIN_ARROW_LEFT,
        BUILTIN_ARROW_RIGHT,
        BUILTIN_CYCLE,
        BUILTIN_CYCLE2
CONST   GETPATH_WIDTH       = 20,
        GETPATH_HEIGHT      = 14,
        GETFILE_WIDTH       = 20,
        GETFILE_HEIGHT      = 14,
        CHECKMARK_WIDTH     = 24,
        CHECKMARK_HEIGHT    = 11,
        POPUP_WIDTH         = 15,
        POPUP_HEIGHT        = 13,
        ARROW_UP_WIDTH      = 16,
        ARROW_UP_HEIGHT     = 9,
        ARROW_DOWN_WIDTH    = 16,
        ARROW_DOWN_HEIGHT   = 9,
        ARROW_LEFT_WIDTH    = 10,
        ARROW_LEFT_HEIGHT   = 12,
        ARROW_RIGHT_WIDTH   = 10,
        ARROW_RIGHT_HEIGHT  = 12,
        BT_HELPFILE         = BGUI_TB+241,   /* IS--- */
        BT_HELPNODE         = BGUI_TB+242,   /* IS--- */
        BT_HELPLINE         = BGUI_TB+243,   /* IS--- */
        BT_INHIBIT          = BGUI_TB+244,   /* --G-- */
        BT_HITBOX           = BGUI_TB+245,   /* --G-- */
        BT_LABELOBJECT      = BGUI_TB+246,   /* -SG-- */
        BT_FRAMEOBJECT      = BGUI_TB+247,   /* -SG-- */
        BT_TEXTATTR         = BGUI_TB+248,   /* ISG-- */
        BT_NORECESSED       = BGUI_TB+249,   /* -S--- */
        BT_LABELCLICK       = BGUI_TB+250,   /* IS--- */
        BT_HELPTEXT         = BGUI_TB+251,   /* IS--- */
        BT_TOOLTIP          = BGUI_TB+252,   /* ISG-- */  /* V40 */
        BT_DRAGOBJECT       = BGUI_TB+253,   /* IS--- */  /* V40 */
        BT_DROPOBJECT       = BGUI_TB+254,   /* IS--- */  /* V40 */
        BT_DRAGTRESHOLD     = BGUI_TB+255,   /* IS--- */  /* V40 */
        BT_DRAGQUALIFIER    = BGUI_TB+256,   /* IS--- */  /* V40 */
        BT_KEY              = BGUI_TB+257,   /* IS--- */  /* V41 */
        BT_RAWKEY           = BGUI_TB+258,   /* ISG-- */  /* V41 */
        BT_QUALIFIER        = BGUI_TB+259,   /* ISG-- */  /* V41 */
        BT_HELPTEXTID       = BGUI_TB+260,   /* ISG-- */  /* V41 */
        BT_TOOLTIPID        = BGUI_TB+261,   /* ISG-- */  /* V41 */
        BT_RESERVED2        = BGUI_TB+318,   /* PRIVATE */
        BT_RESERVED1        = BGUI_TB+319,   /* PRIVATE */
        BT_RESERVED0        = BGUI_TB+320,   /* PRIVATE */
        BT_TAGDONE          = BGUI_TB+320,
        BASE_ADDMAP         = BGUI_MB+41
OBJECT bmaddmap
    methodid:LONG
    object:PTR TO object
    maplist:PTR TO tagitem
ENDOBJECT
CONST   BASE_ADDCONDITIONAL     = BGUI_MB+42
OBJECT bmaddconditional
    methodid:LONG
    object:PTR TO object
    condition:tagitem
    true:tagitem
    false:tagitem
ENDOBJECT
CONST   BASE_ADDMETHOD          = BGUI_MB+43
OBJECT bmaddmethod
    methodid:LONG
    object:PTR TO object
    flags:LONG
    size:LONG
    methodid:LONG
ENDOBJECT
SET     BAMF_NO_GINFO,  /* Do not send GadgetInfo. */
        BAMF_NO_INTERIM /* Skip interim messages.  */
CONST   BASE_REMMAP             = BGUI_MB+44,
        BASE_REMCONDITIONAL     = BGUI_MB+45,
        BASE_REMMETHOD          = BGUI_MB+46
OBJECT bmremove
    methodid:LONG
    object:PTR TO object
ENDOBJECT
CONST   BASE_SHOWHELP           = BGUI_MB+47
OBJECT bmshowhelp
    methodid:LONG
    window:PTR TO  window
    requester:PTR TO requester
    mousex:INT
    mousey:INT
ENDOBJECT
ENUM    BMHELP_OK,        /* OK, no problems.       */
        BMHELP_NOT_ME,    /* Mouse not over the object. */
        BMHELP_FAILURE    /* Showing failed.        */
CONST   BASE_SETLOOP            = BGUI_MB+48,
        BASE_CLEARLOOP          = BGUI_MB+49,
        BASE_CHECKLOOP          = BGUI_MB+50,
        BASE_LEFTEXT            = BGUI_MB+51
OBJECT bmleftext
    methodid:LONG
    rport:PTR TO rastport
    extention:PTR TO INT
ENDOBJECT
CONST   BASE_ADDHOOK            = BGUI_MB+52
OBJECT bmaddhook
    methodid:LONG
    hook:PTR TO hook
ENDOBJECT
CONST   BASE_REMHOOK            = BGUI_MB+53,
        BASE_DRAGGING           = BGUI_MB+54 /* V40 */
ENUM    BDR_NONE,               /* Handle input yourself.   */
        BDR_DRAGPREPARE,        /* Prepare for dragging.    */
        BDR_DRAGGING,           /* Don't handle events.     */
        BDR_DROP,               /* Image dropped.       */
        BDR_CANCEL              /* Drag canceled.       */
CONST   BASE_DRAGQUERY          = BGUI_MB+55 /* V40 */
OBJECT bmdragpoint
    methodid:LONG       -> BASE_DRAGQUERY
    ginfo:PTR TO gadgetinfo     -> GadgetInfo
    source:PTR TO object        -> Object querying.
    mousex:INT                  -> Mouse coords.
    mousey:INT                  -> Mouse coords.
ENDOBJECT
ENUM    BQR_REJECT,  /* Object will not accept drop. */
        BQR_ACCEPT   /* Object will accept drop. */
CONST   BASE_DRAGUPDATE         = BGUI_MB+56 /* V40 */
ENUM    BUR_CONTINUE, /* Continue drag. */
        BUR_ABORT     /* Abort drag.    */
CONST   BASE_DROPPED            = BGUI_MB+57 /* V40 */
OBJECT bmdropped
    methodid:LONG
    ginfo:PTR TO gadgetinfo         -> GadgetInfo structure
    source:PTR TO object            -> Object dropped
    sourcewin:PTR TO window         -> Source obj window
    sourcereq:PTR TO requester      -> Source onj requester
ENDOBJECT
CONST   BASE_DRAGACTIVE         = BGUI_MB+58, /* V40 */
        BASE_DRAGINACTIVE       = BGUI_MB+59 /* V40 */
OBJECT bmdragmsg
    methodid:LONG
    ginfo:PTR TO gadgetinfo        -> GadgetInfo structure
    source:PTR TO object           -> Object being dragged
ENDOBJECT
CONST   BASE_GETDRAGOBJECT      = BGUI_MB+60 /* V40 */
OBJECT bmgetdragobject
    methodid:LONG       -> BASE_GETDRAGOBJECT
    ginfo:PTR TO gadgetinfo     -> GadgetInfo
    bounds:PTR TO ibox          -> Bounds to buffer
ENDOBJECT
CONST   BASE_FREEDRAGOBJECT     = BGUI_MB+61 /* V40 */
OBJECT bmfreedragobject
    methodid:LONG                   -> BASE_FREEDRAGOBJECT
    ginfo:PTR TO gadgetinfo         -> GadgetInfo
    objbitmap:PTR TO bitmap         -> BitMap to free
ENDOBJECT
CONST   BASE_RESERVED0          = BGUI_MB+62,
        BASE_FINDKEY            = BGUI_MB+63     /* V41 */
OBJECT  bmfindkey
    methodid:LONG           -> BASE_FINDKEY
    rawkey:LONG             -> Key to find
    qual:INT
    key:INT
ENDOBJECT
CONST   BASE_KEYLABEL           = BGUI_MB+64     /* V41 */
OBJECT  bmkeylabel
    methodid:LONG   -> BASE_KEYLABEL
ENDOBJECT
CONST   BASE_LOCALIZE           = BGUI_MB+65     /* V41 */
OBJECT bmlocalize
    methodid:LONG
    locale:PTR TO bguilocale
ENDOBJECT
CONST   GROUP_STYLE             = BGUI_TB+321,   /* I---- */
        GROUP_SPACING           = BGUI_TB+322,   /* I---- */
        GROUP_HORIZOFFSET       = BGUI_TB+323,   /* I---- */
        GROUP_VERTOFFSET        = BGUI_TB+324,   /* I---- */
        GROUP_LEFTOFFSET        = BGUI_TB+325,   /* I---- */
        GROUP_TOPOFFSET         = BGUI_TB+326,   /* I---- */
        GROUP_RIGHTOFFSET       = BGUI_TB+327,   /* I---- */
        GROUP_BOTTOMOFFSET      = BGUI_TB+328,   /* I---- */
        GROUP_MEMBER            = BGUI_TB+329,   /* I---- */
        GROUP_SPACEOBJECT       = BGUI_TB+330,   /* I---- */
        GROUP_BACKFILL          = BGUI_TB+331,   /* I---- */
        GROUP_EQUALWIDTH        = BGUI_TB+332,   /* I---- */
        GROUP_EQUALHEIGHT       = BGUI_TB+333,   /* I---- */
        GROUP_INVERTED          = BGUI_TB+334,   /* I---- */
        GROUP_BACKPEN           = BGUI_TB+335,   /* I---- */  /* V40 */
        GROUP_BACKDRIPEN        = BGUI_TB+336,   /* I---- */  /* V40 */
        GROUP_RESERVED0         = BGUI_TB+337,
        GROUP_RESERVED1         = BGUI_TB+338,
        GROUP_RESERVED2         = BGUI_TB+339,
        GROUP_RESERVED3         = BGUI_TB+340,
        LGO_FIXWIDTH            = BGUI_TB+381,
        LGO_FIXHEIGHT           = BGUI_TB+382,
        LGO_WEIGHT              = BGUI_TB+383,
        LGO_FIXMINWIDTH         = BGUI_TB+384,
        LGO_FIXMINHEIGHT        = BGUI_TB+385,
        LGO_ALIGN               = BGUI_TB+386,
        LGO_NOALIGN             = BGUI_TB+387,                /* V38 */
        DEFAULT_WEIGHT          = 50,
        GRSTYLE_HORIZONTAL      = 0,
        GRSTYLE_VERTICAL        = 1,
        GRSPACE_NARROW          = -1,                          /* V41 */
        GRSPACE_NORMAL          = -2,                         /* V41 */
        GRSPACE_WIDE            = -3,                         /* V41 */
        GRM_ADDMEMBER           = BGUI_MB+81
OBJECT grmaddmember
    methodid:LONG           -> GRM_ADDMEMBER
    member:PTR TO object    -> Object to add
    attr:LONG               -> First of LGO attributes
ENDOBJECT
CONST   GRM_REMMEMBER           = BGUI_MB+82
OBJECT grmremmember
    methodid:LONG    -> GRM_REMMEMBER
    member:PTR TO object     -> Object to remove
ENDOBJECT
CONST   GRM_DIMENSIONS          = BGUI_MB+83
OBJECT grmdimensions
    methodid:LONG       -> GRM_DIMENSIONS
    ginfo:PTR TO gadgetinfo     -> Can be NIL!
    rport:PTR TO rastport       -> Ready for calculations
    minsizewidth:PTR TO INT
    minsizeheight:PTR TO INT
    flags:LONG                  -> See below
ENDOBJECT
CONST   GDIMF_NO_FRAME          = 1,  -> Don't take frame width/height into consideration
        GRM_ADDSPACEMEMBER      = BGUI_MB+84
OBJECT grmaddspacemember
    methodid:LONG       -> GRM_ADDSPACEMEMBER
    weight:LONG         -> Object weight
ENDOBJECT
CONST   GRM_INSERTMEMBER        = BGUI_MB+85
OBJECT grminsertmember
    methodid:LONG   -> GRM_INSERTMEMBER
    member:PTR TO object    -> Member to insert
    pred:PTR TO object      -> Insert after this member
    attr:LONG               -> First of LGO attributes
ENDOBJECT
CONST   GRM_REPLACEMEMBER       = BGUI_MB+86    /* V40 */
OBJECT grmreplacemember
    methodid:LONG   -> GRM_REPLACEMEMBER
    membera:PTR TO object   -> Object to replace
    memberb:PTR TO object   -> Object which replaces
    attr:LONG               -> First of LGO attributes
ENDOBJECT
CONST   GRM_WHICHOBJECT         = BGUI_MB+87    /* V40 */
OBJECT grmwhichobject
    methodid:LONG   -> GRM_WHICHOBJECT
    coordsx:INT
    coordsy:INT
ENDOBJECT
CONST   BUTTON_SCALEMINWIDTH    = BGUI_TB+401,   /* PRIVATE! */
        BUTTON_SCALEMINHEIGHT   = BGUI_TB+402,   /* PRIVATE! */
        BUTTON_IMAGE            = BGUI_TB+403,   /* IS--U */
        BUTTON_SELECTEDIMAGE    = BGUI_TB+404,   /* IS--U */
        BUTTON_ENCLOSEIMAGE     = BGUI_TB+405,   /* I---- */  /* V39 */
        BUTTON_VECTOR           = BGUI_TB+406,   /* IS--U */  /* V41 */
        BUTTON_SELECTEDVECTOR   = BGUI_TB+407,   /* IS--U */  /* V41 */
        BUTTON_RESERVED0        = BGUI_TB+480,
        CYC_LABELS              = BGUI_TB+561,   /* I---- */
        CYC_ACTIVE              = BGUI_TB+562,   /* ISGNU */
        CYC_POPUP               = BGUI_TB+563,   /* I---- */
        CYC_POPACTIVE           = BGUI_TB+564,   /* I---- */  /* V40 */
        INFO_TEXTFORMAT         = BGUI_TB+641,   /* IS--U */
        INFO_ARGS               = BGUI_TB+642,   /* IS--U */
        INFO_MINLINES           = BGUI_TB+643,   /* I---- */
        INFO_FIXTEXTWIDTH       = BGUI_TB+644,   /* I---- */
        INFO_HORIZOFFSET        = BGUI_TB+645,   /* I---- */
        INFO_VERTOFFSET         = BGUI_TB+646   /* I---- */
#define ISEQ_B                  '\eb'  /* Bold          */
#define ISEQ_I                  '\ei'  /* Italics       */
#define ISEQ_U                  '\eu'  /* Underlined    */
#define ISEQ_N                  '\en'  /* Normal        */
#define ISEQ_C                  '\ec'  /* Centered      */
#define ISEQ_R                  '\er'  /* Right         */
#define ISEQ_L                  '\el'  /* Left          */
#define ISEQ_TEXT               '\ed2' /* TEXTPEN       */
#define ISEQ_SHINE              '\ed3' /* SHINEPEN      */
#define ISEQ_SHADOW             '\ed4' /* SHADOWPEN     */
#define ISEQ_FILL               '\ed5' /* FILLPEN       */
#define ISEQ_FILLTEXT           '\ed6' /* FILLTEXTPEN   */
#define ISEQ_HIGHLIGHT          '\ed8' /* HIGHLIGHTPEN  */
CONST   LISTV_RESOURCEHOOK          = BGUI_TB+721,   /* IS--- */
        LISTV_DISPLAYHOOK           = BGUI_TB+722,   /* IS--- */
        LISTV_COMPAREHOOK           = BGUI_TB+723,   /* IS--- */
        LISTV_TOP                   = BGUI_TB+724,   /* ISG-U */
        LISTV_LISTFONT              = BGUI_TB+725,   /* I-G-- */
        LISTV_READONLY              = BGUI_TB+726,   /* I---- */
        LISTV_MULTISELECT           = BGUI_TB+727,   /* IS--U */
        LISTV_ENTRYARRAY            = BGUI_TB+728,   /* I---- */
        LISTV_SELECT                = BGUI_TB+729,   /* -S--U */
        LISTV_MAKEVISIBLE           = BGUI_TB+730,   /* -S--U */
        LISTV_ENTRY                 = BGUI_TB+731,   /* ---N- */
        LISTV_SORTENTRYARRAY        = BGUI_TB+732,   /* I---- */
        LISTV_ENTRYNUMBER           = BGUI_TB+733,   /* ---N- */
        LISTV_TITLEHOOK             = BGUI_TB+734,   /* I---- */
        LISTV_LASTCLICKED           = BGUI_TB+735,   /* --G-- */
        LISTV_THINFRAMES            = BGUI_TB+736,   /* I---- */
        LISTV_LASTCLICKEDNUM        = BGUI_TB+737,   /* --G-- */  /* V38 */
        LISTV_NEWPOSITION           = BGUI_TB+738,   /* ---N- */  /* V38 */
        LISTV_NUMENTRIES            = BGUI_TB+739,   /* --G-- */  /* V38 */
        LISTV_MINENTRIESSHOWN       = BGUI_TB+740,   /* I---- */  /* V38 */
        LISTV_SELECTMULTI           = BGUI_TB+741,   /* -S--U */  /* V39 */
        LISTV_SELECTNOTVISIBLE      = BGUI_TB+742,   /* -S--U */  /* V39 */
        LISTV_SELECTMULTINOTVISIBLE = BGUI_TB+743,   /* -S--U */  /* V39 */
        LISTV_MULTISELECTNOSHIFT    = BGUI_TB+744,   /* IS--U */  /* V39 */
        LISTV_DESELECT              = BGUI_TB+745,   /* -S--U */  /* V39 */
        LISTV_DROPSPOT              = BGUI_TB+746,   /* --G-- */  /* V40 */
        LISTV_SHOWDROPSPOT          = BGUI_TB+747,   /* IS--- */  /* V40 */
        LISTV_VIEWBOUNDS            = BGUI_TB+748,   /* --G-- */  /* V40 */
        LISTV_CUSTOMDISABLE         = BGUI_TB+749,   /* IS--- */  /* V40 */
        LISTV_SELECT_FIRST          = -1,                /* V38 */
        LISTV_SELECT_LAST           = -2,                /* V38 */
        LISTV_SELECT_NEXT           = -3,                /* V38 */
        LISTV_SELECT_PREVIOUS       = -4,                /* V38 */
        LISTV_SELECT_TOP            = -5,                /* V38 */
        LISTV_SELECT_PAGE_UP        = -6,                /* V38 */
        LISTV_SELECT_PAGE_DOWN      = -7,                /* V38 */
        LISTV_SELECT_ALL            = -8                /* V39 */
OBJECT lvresource
    command:INT
    entry:PTR TO LONG
ENDOBJECT
CONST   LVRC_MAKE       = 1   /* Build the entry. */
CONST   LVRC_KILL       = 2   /* Kill the entry.  */
OBJECT lvrender
    rport:PTR TO rastport       /* RastPort to render in.  */
    drawinfo:PTR TO drawinfo    /* All you need to render. */
    bounds:PTR TO rectangle     /* Bounds to render in.    */
    entry:PTR TO LONG           /* Entry to render.    */
    state:INT                   /* See below.          */
    flags:INT                   /* None defined yet.       */
ENDOBJECT
ENUM    LVRS_NORMAL,
        LVRS_SELECTED,
        LVRS_NORMAL_DISABLED,
        LVRS_SELECTED_DISABLED
OBJECT lvcompare
    entrya:PTR TO LONG      /* First entry.  */
    entryb:PTR TO LONG      /* Second entry. */
ENDOBJECT
CONST   LVM_ADDENTRIES          = BGUI_MB+281
OBJECT lvmaddentries
    methodid:LONG       /* LVM_ADDENTRIES  */
    ginfo:PTR TO gadgetinfo     /* GadgetInfo      */
    entries:PTR TO LONG         /* Entries to add. */
    how:LONG                    /* How to add it.  */
ENDOBJECT
ENUM    LVAP_HEAD      = 1,
        LVAP_TAIL,
        LVAP_SORTED
CONST   LVM_ADDSINGLE           = BGUI_MB+282
OBJECT lvmaddsingle
    methodid:LONG   /* LVM_ADDSINGLE */
    ginfo:PTR TO gadgetinfo /* GadgetInfo    */
    entry:PTR TO LONG       /* Entry to add. */
    how:LONG                /* See above.    */
    flags:LONG              /* See below.    */
ENDOBJECT
SET     LVASF_MAKEVISIBLE,  /* Make entry visible.          */
        LVASF_SELECT,       /* Select entry.            */
        LVASF_MULTISELECT,  /* Multi-select entry.      V40 */
        LVASF_NOT_VISIBLE   /* Do not make visible.         V40 */
CONST   LVM_CLEAR               = BGUI_MB+283,
        LVM_FIRSTENTRY          = BGUI_MB+284,
        LVM_LASTENTRY           = BGUI_MB+285,
        LVM_NEXTENTRY           = BGUI_MB+286,
        LVM_PREVENTRY           = BGUI_MB+287
OBJECT lvmgetentry
    methodid:LONG   /* Any of the above. */
    previous:PTR TO LONG    /* Previous entry.   */
    flags:LONG              /* See below.        */
ENDOBJECT
SET     LVGEF_SELECTED     /* Get selected entries. */
CONST   LVM_REMENTRY            = BGUI_MB+288
OBJECT lvmrementry
    methodid:LONG   /* LVM_REMENTRY      */
    ginfo:PTR TO gadgetinfo /* GadgetInfo        */
    entry:PTR TO LONG       /* Entry to remove.  */
ENDOBJECT
CONST   LVM_REFRESH         = BGUI_MB+289,
        LVM_SORT            = BGUI_MB+290,
        LVM_LOCKLIST        = BGUI_MB+291,
        LVM_UNLOCKLIST      = BGUI_MB+292
OBJECT lvmcommand
    methodid:LONG   /* LVM_REFRESH       */
    ginfo:PTR TO gadgetinfo /* GadgetInfo        */
ENDOBJECT
CONST   LVM_MOVE            = BGUI_MB+293 /* V38 */
OBJECT lvmmove
    methodid:LONG   /* LVM_MOVE      */
    ginfo:PTR TO gadgetinfo /* GadgetInfo        */
    entry:PTR TO LONG       /* Entry to move     */
    direction:LONG          /* See below         */
    newpos:LONG             /* New position. V40 */
ENDOBJECT
ENUM    LVMOVE_UP,      /* Move entry up.        */
        LVMOVE_DOWN,    /* Move entry down.      */
        LVMOVE_TOP,     /* Move entry to the top.    */
        LVMOVE_BOTTOM,  /* Move entry to the bottom. */
        LVMOVE_NEWPOS   /* Move to new position. V40 */
CONST   LVM_REPLACE             = BGUI_MB+294 /* V39 */
OBJECT lvmreplace
    methodid:LONG      /* LVM_REPLACE       */
    ginfo:PTR TO gadgetinfo    /* GadgetInfo        */
    oldentry:PTR TO LONG       /* Entry to replace. */
    newentry:PTR TO LONG       /* New entry.        */
ENDOBJECT
CONST   LVM_REDRAW              = BGUI_MB+295, /* V40 */
        LVM_INSERTENTRIES       = BGUI_MB+296 /* V40 */
OBJECT lvminsertentries
    methodid:LONG      /* LVM_INSERTENTRIES */
    ginfo:PTR TO gadgetinfo    /* GadgetInfo        */
    pos:LONG                   /* Position.         */
    entries:PTR TO LONG        /* Entries to insert.*/
ENDOBJECT
CONST   LVM_INSERTSINGLE        = BGUI_MB+297 /* V40 */
OBJECT lvminsertsingle
    methodid:LONG      /* LVM_INSERTSINGLE  */
    ginfo:PTR TO gadgetinfo    /* GadgetInfo        */
    pos:LONG                   /* Position.         */
    entry:PTR TO LONG          /* Entry to insert.  */
    flags:LONG                 /* See LVM_ADDSINGLE */
ENDOBJECT
CONST   LVM_REMSELECTED         = BGUI_MB+298,   /* V40 */
        PROGRESS_MIN            = BGUI_TB+801,   /* IS--- */
        PROGRESS_MAX            = BGUI_TB+802,   /* IS--- */
        PROGRESS_DONE           = BGUI_TB+803,   /* ISGNU */
        PROGRESS_VERTICAL       = BGUI_TB+804,   /* I---- */
        PROGRESS_DIVISOR        = BGUI_TB+805,   /* I---- */
        PROGRESS_FORMATSTRING   = BGUI_TB+806,   /* I---- */  /* V40 */
        PGA_ARROWS              = BGUI_TB+881,   /* I---- */
        PGA_ARROWSIZE           = BGUI_TB+882,   /* I---- */
        PGA_DONTTARGET          = BGUI_TB+883,   /* PRIVATE! */
        PGA_THINFRAME           = BGUI_TB+884,   /* I---- */
        PGA_XENFRAME            = BGUI_TB+885,   /* I---- */
        PGA_NOFRAME             = BGUI_TB+886,   /* I---- */  /* V40 */
        STRINGA_TABBED          = BGUI_TB+961,   /* PRIVATE! */
        STRINGA_SHIFTTABBED     = BGUI_TB+962,   /* PRIVATE! */
        STRINGA_MINCHARSVISIBLE = BGUI_TB+963,   /* I---- */  /* V39 */
        STRINGA_INTEGERMIN      = BGUI_TB+964,   /* IS--U */  /* V39 */
        STRINGA_INTEGERMAX      = BGUI_TB+965,   /* IS--U */  /* V39 */
        STRINGA_STRINGINFO      = BGUI_TB+966,   /* --G-- */  /* V40 */
        SM_FORMAT_STRING        = BGUI_MB+401    /* V39 */
OBJECT smformatstring
    methodid:LONG       /* SM_FORMAT_STRING    */
    ginfo:PTR TO gadgetinfo     /* GadgetInfo          */
    fstr:PTR TO LONG            /* Format string       */
    arg1:LONG                   /* Format arg          */
ENDOBJECT
CONST   PAGE_ACTIVE             = BGUI_TB+1121,  /* ISGNU */
        PAGE_MEMBER             = BGUI_TB+1122,  /* I---- */
        PAGE_NOBUFFERRP         = BGUI_TB+1123,  /* I---- */
        PAGE_INVERTED           = BGUI_TB+1124,  /* I---- */
        MX_LABELS               = BGUI_TB+1201,  /* I---- */
        MX_ACTIVE               = BGUI_TB+1202,  /* ISGNU */
        MX_LABELPLACE           = BGUI_TB+1203,  /* I---- */
        MX_DISABLEBUTTON        = BGUI_TB+1204,  /* IS--U */
        MX_ENABLEBUTTON         = BGUI_TB+1205,  /* IS--U */
        MX_TABSOBJECT           = BGUI_TB+1206,  /* I---- */
        MX_TABSTEXTATTR         = BGUI_TB+1207,  /* I---- */
        MX_TABSUPSIDEDOWN       = BGUI_TB+1208,  /* I---- */  /* V40 */
        MX_TABSBACKFILL         = BGUI_TB+1209,  /* I---- */  /* V40 */
        MX_TABSBACKPEN          = BGUI_TB+1210,  /* I---- */  /* V40 */
        MX_TABSBACKDRIPEN       = BGUI_TB+1211,  /* I---- */  /* V40 */
        MX_LABELSID             = BGUI_TB+1212,  /* I---- */  /* V40 */
        SLIDER_MIN              = BGUI_TB+1281,  /* IS--U */
        SLIDER_MAX              = BGUI_TB+1282,  /* IS--U */
        SLIDER_LEVEL            = BGUI_TB+1283,  /* ISGNU */
        SLIDER_THINFRAME        = BGUI_TB+1284,  /* I---- */
        SLIDER_XENFRAME         = BGUI_TB+1285,  /* I---- */
        SLIDER_NOFRAME          = BGUI_TB+1286,  /* I---- */  /* V40 */
        INDIC_MIN               = BGUI_TB+1361,  /* I---- */
        INDIC_MAX               = BGUI_TB+1362,  /* I---- */
        INDIC_LEVEL             = BGUI_TB+1363,  /* IS--U */
        INDIC_FORMATSTRING      = BGUI_TB+1364,  /* I---- */
        INDIC_JUSTIFICATION     = BGUI_TB+1365,  /* I---- */
        IDJ_LEFT                = 0,
        IDJ_CENTER              = 1,
        IDJ_RIGHT               = 2,
        EXT_CLASS               = BGUI_TB+1441,  /* I---- */
        EXT_CLASSID             = BGUI_TB+1442,  /* I---- */
        EXT_MINWIDTH            = BGUI_TB+1443,  /* I---- */
        EXT_MINHEIGHT           = BGUI_TB+1444,  /* I---- */
        EXT_TRACKATTR           = BGUI_TB+1445,  /* I---- */
        EXT_OBJECT              = BGUI_TB+1446,  /* --G-- */
        EXT_NOREBUILD           = BGUI_TB+1447,  /* I---- */
        SEP_HORIZ               = BGUI_TB+1501,  /* I---- */
        SEP_TITLE               = BGUI_TB+1502,  /* I---- */
        SEP_THIN                = BGUI_TB+1503,  /* I---- */
        SEP_HIGHLIGHT           = BGUI_TB+1504,  /* I---- */
        SEP_CENTERTITLE         = BGUI_TB+1505,  /* I---- */
        SEP_RECESSED            = BGUI_TB+1506,  /* I---- */  /* V39 */
        SEP_TITLELEFT           = BGUI_TB+1507,  /* I---- */  /* V40 */
        SEP_TITLERIGHT          = BGUI_TB+1508,  /* I---- */  /* V40 */
        WINDOW_POSITION         = BGUI_TB+1761,  /* I---- */
        WINDOW_SCALEWIDTH       = BGUI_TB+1762,  /* I---- */
        WINDOW_SCALEHEIGHT      = BGUI_TB+1763,  /* I---- */
        WINDOW_LOCKWIDTH        = BGUI_TB+1764,  /* I---- */
        WINDOW_LOCKHEIGHT       = BGUI_TB+1765,  /* I---- */
        WINDOW_POSRELBOX        = BGUI_TB+1766,  /* I---- */
        WINDOW_BOUNDS           = BGUI_TB+1767,  /* ISG-- */
        WINDOW_DRAGBAR          = BGUI_TB+1771,  /* I---- */
        WINDOW_SIZEGADGET       = BGUI_TB+1772,  /* I---- */
        WINDOW_CLOSEGADGET      = BGUI_TB+1773,  /* I---- */
        WINDOW_DEPTHGADGET      = BGUI_TB+1774,  /* I---- */
        WINDOW_SIZEBOTTOM       = BGUI_TB+1775,  /* I---- */
        WINDOW_SIZERIGHT        = BGUI_TB+1776,  /* I---- */
        WINDOW_ACTIVATE         = BGUI_TB+1777,  /* I---- */
        WINDOW_RMBTRAP          = BGUI_TB+1778,  /* I---- */
        WINDOW_SMARTREFRESH     = BGUI_TB+1779,  /* I---- */
        WINDOW_REPORTMOUSE      = BGUI_TB+1780,  /* I---- */
        WINDOW_BORDERLESS       = BGUI_TB+1781,  /* I---- */  /* V39 */
        WINDOW_BACKDROP         = BGUI_TB+1782,  /* I---- */  /* V39 */
        WINDOW_SHOWTITLE        = BGUI_TB+1783,  /* I---- */  /* V39 */
        WINDOW_IDCMP            = BGUI_TB+1791,  /* I---- */
        WINDOW_SHAREDPORT       = BGUI_TB+1792,  /* IS--- */
        WINDOW_TITLE            = BGUI_TB+1793,  /* IS--U */
        WINDOW_SCREENTITLE      = BGUI_TB+1794,  /* IS--U */
        WINDOW_MENUSTRIP        = BGUI_TB+1795,  /* I-G-- */
        WINDOW_MASTERGROUP      = BGUI_TB+1796,  /* I---- */
        WINDOW_SCREEN           = BGUI_TB+1797,  /* IS--- */
        WINDOW_PUBSCREENNAME    = BGUI_TB+1798,  /* IS--- */
        WINDOW_USERPORT         = BGUI_TB+1799,  /* --G-- */
        WINDOW_SIGMASK          = BGUI_TB+1800,  /* --G-- */
        WINDOW_IDCMPHOOK        = BGUI_TB+1801,  /* I---- */
        WINDOW_VERIFYHOOK       = BGUI_TB+1802,  /* I---- */
        WINDOW_IDCMPHOOKBITS    = BGUI_TB+1803,  /* I---- */
        WINDOW_VERIFYHOOKBITS   = BGUI_TB+1804,  /* I---- */
        WINDOW_FONT             = BGUI_TB+1805,  /* I---- */
        WINDOW_FALLBACKFONT     = BGUI_TB+1806,  /* I---- */
        WINDOW_HELPFILE         = BGUI_TB+1807,  /* IS--- */
        WINDOW_HELPNODE         = BGUI_TB+1808,  /* IS--- */
        WINDOW_HELPLINE         = BGUI_TB+1809,  /* IS--- */
        WINDOW_APPWINDOW        = BGUI_TB+1810,  /* I---- */
        WINDOW_APPMASK          = BGUI_TB+1811,  /* --G-- */
        WINDOW_UNIQUEID         = BGUI_TB+1812,  /* I---- */
        WINDOW_WINDOW           = BGUI_TB+1813,  /* --G-- */
        WINDOW_HELPTEXT         = BGUI_TB+1814,  /* IS--- */
        WINDOW_NOBUFFERRP       = BGUI_TB+1815,  /* I---- */
        WINDOW_AUTOASPECT       = BGUI_TB+1816,  /* I---- */
        WINDOW_PUBSCREEN        = BGUI_TB+1817,  /* IS--- */  /* V39 */
        WINDOW_CLOSEONESC       = BGUI_TB+1818,  /* IS--- */  /* V39 */
        WINDOW_ACTNEXT          = BGUI_TB+1819,  /* ----- */  /* V39 */
        WINDOW_ACTPREV          = BGUI_TB+1820,  /* ----- */  /* V39 */
        WINDOW_NOVERIFY         = BGUI_TB+1821,  /* -S--- */  /* V39 */
        WINDOW_MENUFONT         = BGUI_TB+1822,  /* IS--- */  /* V40 */
        WINDOW_TOOLTICKS        = BGUI_TB+1823,  /* ISG-U */  /* V40 */
        WINDOW_LBORDERGROUP     = BGUI_TB+1824,  /* I---- */  /* V40 */
        WINDOW_TBORDERGROUP     = BGUI_TB+1825,  /* I---- */  /* V40 */
        WINDOW_RBORDERGROUP     = BGUI_TB+1826,  /* I---- */  /* V40 */
        WINDOW_BBORDERGROUP     = BGUI_TB+1827,  /* I---- */  /* V40 */
        WINDOW_TITLEZIP         = BGUI_TB+1828,  /* I---- */  /* V40 */
        WINDOW_AUTOKEYLABEL     = BGUI_TB+1829,  /* I---- */  /* V41 */
        WINDOW_TITLEID          = BGUI_TB+1830,  /* ISG-- */  /* V41 */
        WINDOW_SCREENTITLEID    = BGUI_TB+1831,  /* ISG-- */  /* V41 */
        WINDOW_HELPTEXTID       = BGUI_TB+1832,  /* ISG-- */  /* V41 */
        WINDOW_LOCALE           = BGUI_TB+1833,  /* IS--- */  /* V41 */
        WINDOW_CATALOG          = BGUI_TB+1834,  /* IS--- */  /* V41 */
        WINDOW_RESERVED1        = BGUI_TB+1859,
        WINDOW_RESERVED0        = BGUI_TB+1860,
        POS_CENTERSCREEN        = 0,             /* Center on the screen             */
        POS_CENTERMOUSE         = 1,             /* Center under the mouse       */
        POS_TOPLEFT             = 2,             /* Top-left of the screen       */
        WM_OPEN                 = BGUI_MB+601,   /* Open the window          */
        WM_CLOSE                = BGUI_MB+602,   /* Close the window         */
        WM_SLEEP                = BGUI_MB+603,   /* Put the window to sleep      */
        WM_WAKEUP               = BGUI_MB+604,   /* Wake the window up           */
        WM_HANDLEIDCMP          = BGUI_MB+605,   /* Call the IDCMP handler       */
        WMHI_CLOSEWINDOW        = $10000,        /* The close gadget was clicked     */
        WMHI_NOMORE             = $20000,        /* No more messages         */
        WMHI_INACTIVE           = $30000,        /* The window was de-activated      */
        WMHI_ACTIVE             = $40000,        /* The window was activated     */
        WMHI_IGNORE             = -1,            /* Like it say's: ignore            */
        WM_GADGETKEY            = BGUI_MB+606
OBJECT wmgadgetkey
    methodid:LONG           /* WM_GADGETKEY          */
    requester:PTR TO requester      /* When used in a requester      */
    object:PTR TO object            /* Object to activate        */
    key:PTR TO LONG                 /* Key that triggers activ.      */
ENDOBJECT
CONST   WM_KEYACTIVE            = BGUI_MB+607,
        WM_KEYINPUT             = BGUI_MB+608
OBJECT wmkeyinput
    methodid:LONG       /* WM_KEYACTIVE/WM_KEYINPUT        */
    ginfo:PTR TO gadgetinfo     /* GadgetInfo              */
    ievent:PTR TO inputevent    /* Input event                     */
    id:PTR TO LONG              /* Storage for the object ID       */
    key:PTR TO LONG             /* Key that triggered activation.  */
ENDOBJECT
CONST   WMKF_MEACTIVE   = 0          /* Object went active.             */
SET     WMKF_CANCEL,                 /* Key activation canceled.        */
        WMKF_VERIFY,                 /* Key activation confirmed        */
        WMKF_ACTIVATE                /* ActivateGadget() object     */
CONST   WM_KEYINACTIVE          = BGUI_MB+609
OBJECT wmkeyinactive
    methodid:LONG    /* WM_KEYINACTIVE           */
    ginfo:PTR TO gadgetinfo  /* GadgetInfo               */
ENDOBJECT
CONST   WM_DISABLEMENU          = BGUI_MB+610,
        WM_CHECKITEM            = BGUI_MB+611
OBJECT wmmenuaction
    methodid:LONG    /* WM_DISABLEMENU/WM_CHECKITEM      */
    menuid:LONG      /* Menu it's ID                     */
    set:LONG         /* TRUE = set, FALSE = clear        */
ENDOBJECT
CONST   WM_MENUDISABLED         = BGUI_MB+612
CONST   WM_ITEMCHECKED          = BGUI_MB+613
OBJECT wmmenuquery
    methodid:LONG    /* WM_MENUDISABLED/WM_ITEMCHECKED   */
    menuid:LONG      /* Menu it's ID                     */
ENDOBJECT
CONST   WM_TABCYCLE_ORDER       = BGUI_MB+614
OBJECT wmtabcycleorder
    methodid:LONG    /* WM_TABCYCLE_ORDER            */
    object1:PTR TO object
ENDOBJECT
CONST   WM_GETAPPMSG            = BGUI_MB+615
CONST   WM_ADDUPDATE            = BGUI_MB+616
OBJECT wmaddupdate
    methodid:LONG        /* WM_ADDUPDATE             */
    sourceid:LONG                /* ID of source object.     */
    target:PTR TO object         /* Target object.       */
    maplist:PTR TO tagitem       /* Attribute map-list.      */
ENDOBJECT
CONST   WM_REPORT_ID            = BGUI_MB+617 /* V38 */
OBJECT wmreportid
    methodid:LONG        /* WM_REPORT_ID             */
    id:LONG                      /* ID to report.        */
    flags:LONG                   /* See below.           */
    sigtask:PTR TO etask          /* Task to signal.  V40 */
ENDOBJECT
SET     WMRIF_DOUBLE_CLICK,  /* Simulate double-click.   */
        WMRIF_TASK           /* Task to signal valid. V40 */
CONST   WM_GET_SIGNAL_WINDOW    = BGUI_MB+618 /* V39 */
CONST   WM_REMOVE_OBJECT        = BGUI_MB+619 /* V40 */
OBJECT wmremoveobject
    methodid:LONG        /* WM_REMOVE_OBJECT     */
    object:PTR TO object         /* Object to remove.        */
    flags:LONG                   /* See below.           */
ENDOBJECT
SET     WMROF_KEY_LIST,  /* Remove from key-list.    */
        WMROF_CYCLE_LIST /* Remove from cycle list.  */
CONST   WM_WHICHOBJECT          = BGUI_MB+620, /* V40 */
        WM_RESERVED0            = BGUI_MB+621,
        WM_RESERVED1            = BGUI_MB+622,
        WM_RESERVED2            = BGUI_MB+623,
        WM_RESERVED3            = BGUI_MB+624,
        WM_RESERVED4            = BGUI_MB+625,
        COMM_NAME               = BGUI_TB+1861,  /* I---- */
        COMM_TITLE              = BGUI_TB+1862,  /* I---- */
        COMM_DESCRIPTION        = BGUI_TB+1863,  /* I---- */
        COMM_UNIQUE             = BGUI_TB+1864,  /* I---- */
        COMM_NOTIFY             = BGUI_TB+1865,  /* I---- */
        COMM_SHOWHIDE           = BGUI_TB+1866,  /* I---- */
        COMM_PRIORITY           = BGUI_TB+1867,  /* I---- */
        COMM_SIGMASK            = BGUI_TB+1868,  /* --G-- */
        COMM_ERRORCODE          = BGUI_TB+1869,  /* --G-- */
        CM_ADDHOTKEY            = BGUI_MB+661
OBJECT cmaddhotkey
    methodid:LONG           /* CM_ADDHOTKEY             */
    inputdescription:PTR TO LONG    /* Key input description.   */
    keyid:LONG                      /* Key command ID.      */
    flags:LONG                      /* See below.           */
ENDOBJECT
SET     CAHF_DISABLED       /* The key is added but won't work.         */
CONST   CM_REMHOTKEY            = BGUI_MB+662, /* Remove a key.      */
        CM_DISABLEHOTKEY        = BGUI_MB+663, /* Disable a key.     */
        CM_ENABLEHOTKEY         = BGUI_MB+664 /* Enable a key.      */
OBJECT cmdokeycommand
    methodid:LONG   /* See above.               */
    keyid:LONG      /* ID of the key.           */
ENDOBJECT
CONST   CM_ENABLEBROKER         = BGUI_MB+665, /* Enable broker.     */
        CM_DISABLEBROKER        = BGUI_MB+666, /* Disable broker.    */
        CM_MSGINFO              = BGUI_MB+667
OBJECT cmmsginfo
    methodid:LONG   /* CM_MSGINFO               */
    infotype:PTR TO LONG   /* Storage for CxMsgType() result.  */
    infoid:PTR TO LONG     /* Storage for CxMsgID() result.    */
    infodata:PTR TO LONG       /* Storage for CxMsgData() result.  */
ENDOBJECT
CONST   CMMI_NOMORE             = -1,   /* No more messages.            */
        CMMI_KILL               = $10000, /* Remove yourself.     V40     */
        CMMI_DISABLE            = $20000, /* You have been disabled.  V40     */
        CMMI_ENABLE             = $30000, /* You have been enabled.   V40     */
        CMMI_UNIQUE             = $40000, /* Unique violation ocured. V40     */
        CMMI_APPEAR             = $50000, /* Show yourself.       V40     */
        CMMI_DISAPPEAR          = $60000 /* Hide yourself.       V40     */
ENUM    CMERR_OK,               /* OK. No problems.         */
        CMERR_NO_MEMORY,        /* Out of memory.           */
        CMERR_KEYID_IN_USE,     /* Key ID already used.             */
        CMERR_KEY_CREATION,     /* Key creation failure.        */
        CMERR_CXOBJERROR        /* CxObjError() reported failure.   */
CONST   FRQ_DRAWER              = BGUI_TB+1941,  /* --G-- */
        FRQ_FILE                = BGUI_TB+1942,  /* --G-- */
        FRQ_PATTERN             = BGUI_TB+1943,  /* --G-- */
        FRQ_PATH                = BGUI_TB+1944,  /* --G-- */
        FRQ_LEFT                = BGUI_TB+1945,  /* --G-- */
        FRQ_TOP                 = BGUI_TB+1946,  /* --G-- */
        FRQ_WIDTH               = BGUI_TB+1947,  /* --G-- */
        FRQ_HEIGHT              = BGUI_TB+1948,  /* --G-- */
        FRQ_MULTIHOOK           = BGUI_TB+1949   /* IS--- */  /* V40 */
ENUM    FRQ_OK,                 /* OK. No problems.         */
        FRQ_CANCEL,             /* The requester was cancelled.     */
        FRQ_ERROR_NO_MEM,       /* Out of memory.           */
        FRQ_ERROR_NO_FREQ       /* Unable to allocate a requester.  */
CONST   FRM_DOREQUEST           = BGUI_MB+701    /* Show Requester.  */
CONST   AREA_MINWIDTH           = $800+$CDEF,    /* I---- */
        AREA_MINHEIGHT          = $800+$CDF0,    /* I---- */
        AREA_AREABOX            = $800+$CDF1     /* --G-- */
