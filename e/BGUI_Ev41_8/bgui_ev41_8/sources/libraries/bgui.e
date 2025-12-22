OPT MODULE
OPT EXPORT
OPT PREPROCESS
/*  $VER: libraries/bgui.e 41.8 (01.02.96)
**  E module for the bgui.library
**
**  (C) Copyright 1996-1997 Ian J. Einman.
**  (C) Copyright 1993-1996 Jaba Development.
**  (C) Copyright 1993-1996 Jan van den Baard.
**  (C) Copyright 1996-1997 Dominique Dutoit
**  All Rights Reserved.
**/
MODULE  'exec/types', 'exec/tasks', 'intuition/classes', 'intuition/classusr', 'intuition/imageclass',
		'intuition/gadgetclass', 'intuition/cghooks', 'libraries/commodities', 'libraries/gadtools',
		'libraries/locale', 'utility/tagitem', 'utility/hooks', 'graphics/text', 'graphics/rastport',
		'graphics/gfx', 'intuition/screens', 'intuition/intuition', 'devices/inputevent'

/*****************************************************************************
 *
 *  The attribute definitions in this header are all followed by
 *  a small comment. This comment can contain the following things:
 *
 *  I - Attribute can be set with OM_NEW
 *  S - Attribute can be set with OM_SET
 *  G - Attribute can be read with OM_GET
 *  N - Setting this attribute triggers a notification.
 *  U - Attribute can be set with OM_UPDATE.
 */

/*****************************************************************************
 *
 *  Miscellanious library definitions.
 */
#define BGUINAME              'bgui.library'
CONST   BGUI_MINIMUM          = 37
CONST   BGUIVERSION           = 41             

/*****************************************************************************
 *
 *  BgUI_GetClassPtr() and BgUI_NewObjectA() class ID's.
 */
CONST   BGUI_LABEL_IMAGE            =  0,
		BGUI_FRAME_IMAGE            =  1,
		BGUI_VECTOR_IMAGE           =  2,
		BGUI_SYSTEM_IMAGE           =  3,
/* 3 through 10 reserved. */
		BGUI_BASE_GADGET            =  11,
		BGUI_GROUP_GADGET           =  12,
		BGUI_BUTTON_GADGET          =  13,
		BGUI_CYCLE_GADGET           =  14,
		BGUI_CHECKBOX_GADGET        =  15,
		BGUI_INFO_GADGET            =  16,
		BGUI_STRING_GADGET          =  17,
		BGUI_PROP_GADGET            =  18,
		BGUI_INDICATOR_GADGET       =  19,
		BGUI_VIEW_GADGET            =  20,
		BGUI_PROGRESS_GADGET        =  21,
		BGUI_SLIDER_GADGET          =  22,
		BGUI_LISTVIEW_GADGET        =  23,
		BGUI_MX_GADGET              =  24,
		BGUI_PAGE_GADGET            =  25,
		BGUI_EXTERNAL_GADGET        =  26,
		BGUI_SEPARATOR_GADGET       =  27,
		BGUI_AREA_GADGET            =  28,
		BGUI_RADIOBUTTON_GADGET     =  29,
		BGUI_PALETTE_GADGET         =  30,
		BGUI_POPBUTTON_GADGET       =  31,
/* 32 through 39 reserved. */
		BGUI_WINDOW_OBJECT          =  40,
		BGUI_FILEREQ_OBJECT         =  41,
		BGUI_COMMODITY_OBJECT       =  42,
		BGUI_ASLREQ_OBJECT          =  43,
		BGUI_FONTREQ_OBJECT         =  44,
		BGUI_SCREENREQ_OBJECT       =  45,
		BGUI_AREXX_OBJECT           =  46,
/* 47 through 99 reserved. */
		BGUI_NOTIFY_OBJECT          =  100,
		BGUI_NOTIFYG_OBJECT         =  101

/* Typo */
CONST   BGUI_SEPERATOR_GADGET =  27

/*****************************************************************************
 *
 *  BGUI requester definitions.
 */
OBJECT bguiRequest
	flags:LONG                  -> See below
	title:LONG                  -> Requester title
	gadgetFormat:LONG           -> Gadget labels
	textFormat:LONG             -> Body text format
	reqPos:INT                  -> Requester position
	textAttr:PTR TO textattr    -> Body text format
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

/*****************************************************************************
 *
 *  BGUI localization definitions.
 */
OBJECT  bguiLocale
		locale:PTR TO locale            -> Locale to use.
		catalog:PTR TO catalog          -> Catalog to use.
		localeStrHook:PTR TO hook       -> Localization function.
		catalogStrHook:PTR TO hook      -> Localization function.
		userData:LONG                   -> For application use.
ENDOBJECT

OBJECT  bguiLocaleStr
		id:LONG                 -> ID of locale string.
ENDOBJECT

OBJECT  bguiCatalogStr
		id:LONG                 -> ID of locale string.
		defaultString:LONG      -> Default string for this ID.
ENDOBJECT

/*****************************************************************************
 *
 *  BGUI graphics definitions.
 */
OBJECT bguiPattern
	   flags:LONG               -> flags (see below)
	   left:INT                -> offset into bitmap
	   top:INT
	   width:INT               -> size of cut from bitmap
	   height:INT
	   bitMap:PTR TO bitmap     -> pattern bitmap
	   object:PTR TO object     -> datatype object
ENDOBJECT

CONST   BPF_RELATIVE_ORIGIN             = 1      -> Origin relative to box

/*****************************************************************************
 *
 *  Tag and method bases.
 *
 *  Range $800F0000 - $800FFFFF is reserved for BGUI tags.
 *  Range $80020000 - $8002FFFF is reserved for imageclass tags.
 *  Range $80030000 - $8003FFFF is reserved for gadgetclass tags.
 *  Range $80040000 - $8004FFFF is reserved for icclass tags.
 *  Range $80080000 - $8008FFFF is reserved for gadtools and asl tags.
 *
 *  Range $000F0000 - $000FFFFF is reserved for BGUI methods.
 *  Range $00000001 - $0000FFFF is reserved for BOOPSI methods.
 *
 *  For custom classes, keep away from these ranges.  Values greater than
 *  $80100000 for tags and $00100000 for methods are suggested.
 */
CONST   BGUI_TB                         = $800F0000,
		BGUI_MB                         = $F0000

/*****************************************************************************
 *
 *      Class implementor information.
 */

OBJECT dispatcherFunction
   methodID:LONG
   func:LONG
ENDOBJECT

CONST DF_END = -1

/* For use with the BGUI_MakeClass() call. */

CONST   CLASS_SuperClass                = BGUI_TB+10001,
		CLASS_SuperClassID              = BGUI_TB+10002,
		CLASS_SuperClassBGUI            = BGUI_TB+10003,
		CLASS_ClassID                   = BGUI_TB+10004,
		CLASS_ClassSize                 = BGUI_TB+10005,
		CLASS_ObjectSize                = BGUI_TB+10006,
		CLASS_Flags                     = BGUI_TB+10007,
		CLASS_Dispatcher                = BGUI_TB+10008,
		CLASS_DFTable                   = BGUI_TB+10009

OBJECT bguiClassBase
   library:LONG
   class:PTR TO iclass
ENDOBJECT

/*****************************************************************************
 *
 *  "frameclass" - BOOPSI framing image.
 *
 *  Tags: 1 - 80    Methods: 1 - 40
 */
CONST   FRM_TAGSTART                    = BGUI_TB+1,
		FRM_Type                        = BGUI_TB+1,     /* ISG-- */
		FRM_CustomHook                  = BGUI_TB+2,     /* ISG-- */
		FRM_BackFillHook                = BGUI_TB+3,     /* ISG-- */
		FRM_Title                       = BGUI_TB+4,     /* ISG-- */
		FRM_TextAttr                    = BGUI_TB+5,     /* ISG-- */
		FRM_Flags                       = BGUI_TB+6,     /* ISG-- */
		FRM_FrameWidth                  = BGUI_TB+7,     /* ISG-- */
		FRM_FrameHeight                 = BGUI_TB+8,     /* ISG-- */
		FRM_BackFill                    = BGUI_TB+9,     /* ISG-- */
		FRM_EdgesOnly                   = BGUI_TB+10,    /* ISG-- */
		FRM_Recessed                    = BGUI_TB+11,    /* ISG-- */
		FRM_CenterTitle                 = BGUI_TB+12,    /* ISG-- */
		FRM_HighlightTitle              = BGUI_TB+13,    /* ISG-- */
		FRM_ThinFrame                   = BGUI_TB+14,    /* ISG-- */
		FRM_BackPen                     = BGUI_TB+15,    /* ISG-- */  /* V39 */
		FRM_SelectedBackPen             = BGUI_TB+16,    /* ISG-- */  /* V39 */
		FRM_BackDriPen                  = BGUI_TB+17,    /* ISG-- */  /* V39 */
		FRM_SelectedBackDriPen          = BGUI_TB+18,    /* ISG-- */  /* V39 */
		FRM_TitleLeft                   = BGUI_TB+19,    /* ISG-- */  /* V40 */
		FRM_TitleRight                  = BGUI_TB+20,    /* ISG-- */  /* V40 */
		FRM_BackRasterPen               = BGUI_TB+21,    /* ISG-- */  /* V41 */
		FRM_BackRasterDriPen            = BGUI_TB+22,    /* ISG-- */  /* V41 */
		FRM_SelectedBackRasterPen       = BGUI_TB+23,    /* ISG-- */  /* V41 */
		FRM_SelectedBackRasterDriPen    = BGUI_TB+24,    /* ISG-- */  /* V41 */
		FRM_Template                    = BGUI_TB+25,    /* IS--- */  /* V41 */
		FRM_TitleID                     = BGUI_TB+26,    /* ISG-- */  /* V41 */
		FRM_FillPattern                 = BGUI_TB+27,    /* ISG-- */  /* V41 */
		FRM_SelectedFillPattern         = BGUI_TB+28,    /* ISG-- */  /* V41 */
		FRM_OuterOffsetLeft             = BGUI_TB+31,    /* ISG-- */  /* V41 */
		FRM_OuterOffsetRight            = BGUI_TB+32,    /* ISG-- */  /* V41 */
		FRM_OuterOffsetTop              = BGUI_TB+33,    /* ISG-- */  /* V41 */
		FRM_OuterOffsetBottom           = BGUI_TB+34,    /* ISG-- */  /* V41 */
		FRM_InnerOffsetLeft             = BGUI_TB+35,    /* ISG-- */  /* V41 */
		FRM_InnerOffsetRight            = BGUI_TB+36,    /* ISG-- */  /* V41 */
		FRM_InnerOffsetTop              = BGUI_TB+37,    /* ISG-- */  /* V41 */
		FRM_InnerOffsetBottom           = BGUI_TB+38,    /* ISG-- */  /* V41 */
		FRM_TAGDONE                     = BGUI_TB+80,

/* Back fill types */
		STANDARD_FILL                   = 0,
		SHINE_RASTER                    = 1,
		SHADOW_RASTER                   = 2,
		SHINE_SHADOW_RASTER             = 3,
		FILL_RASTER                     = 4,
		SHINE_FILL_RASTER               = 5,
		SHADOW_FILL_RASTER              = 6,
		SHINE_BLOCK                     = 7,
		SHADOW_BLOCK                    = 8,
		FILL_BLOCK                      = 9,        /* V41 */

/* Flags */
		FRF_EDGES_ONLY                  = 1,
		FRF_RECESSED                    = 2,
		FRF_CENTER_TITLE                = 4,
		FRF_HIGHLIGHT_TITLE             = 8,
		FRF_THIN_FRAME                  = 16,
		FRF_TITLE_LEFT                  = 32,         /* V40 */
		FRF_TITLE_RIGHT                 = 64          /* V40 */

ENUM    FRB_EDGES_ONLY,
		FRB_RECESSED,
		FRB_CENTER_TITLE,
		FRB_HIGHLIGHT_TITLE,
		FRB_THIN_FRAME,
		FRB_TITLE_LEFT,         /* V40 */
		FRB_TITLE_RIGHT         /* V40 */

/* Frame types */
CONST   FRTYPE_CUSTOM                   = 0,
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
		FRTYPE_TAB_TOP                  = 13,   /* V41.8 */
		FRTYPE_TAB_BOTTOM               = 14,
		FRTYPE_TAB_LEFT                 = 15,
		FRTYPE_TAB_RIGHT                = 16,

		FRTYPE_DEFAULT                  = -1,   /* 41.8 */

		FRAMEM_BACKFILL                 = BGUI_MB+21

/* Backfill a specific rectangle with the backfill hook. */
OBJECT fmBackfill
		methodID:LONG             /* FRM_RENDER                     */
		rPort:PTR TO rastport     /* RastPort ready for rendering   */
		drawInfo:PTR TO drawinfo  /* All you need to render         */
		bounds:PTR TO rectangle   /* Rendering bounds.              */
		state:LONG                /* See "intuition/imageclass.h"   */
ENDOBJECT

/*
 *  FRM_RENDER:
 *
 *  The message packet sent to both the FRM_CustomHook
 *  and FRM_BackFillHook routines. Note that this
 *  structure is READ-ONLY!
 *
 */
CONST   FRM_RENDER                      = 1 /* Render yourself           */

OBJECT frameDrawMsg
	methodID:LONG               -> FRM_RENDER
	rPort:PTR TO rastport       -> RastPort ready for rendering
	drawInfo:PTR TO drawinfo    -> All you need to render
	bounds:PTR TO rectangle     -> Rendering bounds
	state:INT                   -> See "intuition/imageclass.h"
	horizontal:CHAR             -> Horizontal thickness
	vertical:CHAR               -> Vertical thickness
ENDOBJECT

/*
 *  FRM_THICKNESS:
 *
 *  The message packet sent to the FRM_Custom hook.
 */
CONST   FRM_THICKNESS   = 2 /* Give the default frame thickness. */

OBJECT thicknessMsg
	methodID:LONG                       -> FRM_THICKNESS
	thicknessHorizontal:PTR TO CHAR     -> Storage for horizontal
	thicknessVertical:PTR TO CHAR       -> Storage for vertical
	thin:INT                            -> Added in V38!
ENDOBJECT

/* Possible hook return codes. */
CONST   FRC_OK              = 0,             /* OK        */
		FRC_UNKNOWN         = 1,             /* Unknow method */

/*****************************************************************************
 *
 *  "labelclass" - BOOPSI labeling image.
 *
 *  Tags: 81 - 160      Methods: 1 - 40
 */
		LAB_TAGSTART        = BGUI_TB+81,
		LAB_TextAttr        = BGUI_TB+81,    /* ISG-- */
		LAB_Style           = BGUI_TB+82,    /* ISG-- */
		LAB_Underscore      = BGUI_TB+83,    /* ISG-- */
		LAB_Place           = BGUI_TB+84,    /* ISG-- */
		LAB_Label           = BGUI_TB+85,    /* ISG-- */
		LAB_Flags           = BGUI_TB+86,    /* ISG-- */
		LAB_Highlight       = BGUI_TB+87,    /* ISG-- */
		LAB_HighUScore      = BGUI_TB+88,    /* ISG-- */
		LAB_Pen             = BGUI_TB+89,    /* ISG-- */
		LAB_SelectedPen     = BGUI_TB+90,    /* ISG-- */
		LAB_DriPen          = BGUI_TB+91,    /* ISG-- */
		LAB_SelectedDriPen  = BGUI_TB+92,    /* ISG-- */
		LAB_LabelID         = BGUI_TB+93,    /* ISG-- */ /* V41 */
		LAB_Template        = BGUI_TB+94,    /* IS--- */ /* V41 */
		LAB_NoPlaceIn       = BGUI_TB+95,    /* ISG-- */     /* V41.7 */
		LAB_SelectedStyle   = BGUI_TB+96,    /* ISG-- */     /* V41.7 */
		LAB_FlipX           = BGUI_TB+97,    /* ISG-- */     /* V41.7 */
		LAB_FlipY           = BGUI_TB+98,    /* ISG-- */     /* V41.7 */
		LAB_FlipXY          = BGUI_TB+99,    /* ISG-- */     /* V41.7 */
		LAB_TAGDONE         = BGUI_TB+160,

/* Flags */
		LABF_HIGHLIGHT      = 1, /* Highlight label    */
		LABF_HIGH_USCORE    = 2, /* Highlight underscoring */
		LABF_FLIP_X         = 4, /* Flip across x axis     */
		LABF_FLIP_Y         = 8, /* Flip across y axis     */
		LABF_FLIP_XY        = 16,/* Flip across x = y      */

		LABB_HIGHTLIGHT     = 0, /* Highlight label    */
		LABB_HIGH_USCORE    = 1, /* Highlight underscoring */
		LABB_FLIP_X         = 2, /* Flip across x axis     */
		LABB_FLIP_Y         = 3, /* Flip across y axis     */
		LABB_FLIP_XY        = 4, /* Flip across x = y      */

/* Label placement */
		PLACE_IN            = 0,
		PLACE_LEFT          = 1,
		PLACE_RIGHT         = 2,
		PLACE_ABOVE         = 3,
		PLACE_BELOW         = 4,

/* New methods */
/*
 *  The IM_EXTENT method is used to find out how many
 *  pixels the label extents the relative hitbox in
 *  either direction. Normally this method is called
 *  by the baseclass.
 */
		IM_EXTENT           = BGUI_MB+1

OBJECT impExtent
	methodID:LONG           /* IM_EXTENT            */
	rPort:PTR TO rastport           /* RastPort         */
	extent:PTR TO ibox              /* Storage for extentions.  */
	labelSizeWidth:PTR TO INT       /* Storage width in pixels  */
	labelSizeHeight:PTR TO INT      /* Storage height in pixels */
	flags:INT                       /* See below.           */
ENDOBJECT

CONST   EXTF_MAXIMUM        = 1, /* Request maximum extensions. */

/*****************************************************************************
 *
 *  "vectorclass" - BOOPSI scalable vector image.
 *
 *  Tags: 161 - 240
 *
 *  Based on an idea found in the ObjectiveGadTools.library
 *  by Davide Massarenti.
 */
		VIT_TAGSTART        = BGUI_TB+161,
		VIT_VectorArray     = BGUI_TB+161,   /* ISG-- */
		VIT_BuiltIn         = BGUI_TB+162,   /* ISG-- */
		VIT_Pen             = BGUI_TB+163,   /* ISG-- */
		VIT_DriPen          = BGUI_TB+164,   /* ISG-- */
		VIT_ScaleWidth      = BGUI_TB+165,   /* --G-- */ /* V41 */
		VIT_ScaleHeight     = BGUI_TB+166,   /* --G-- */ /* V41 */
		VIT_TAGDONE         = BGUI_TB+240

/*
 *  Command structure which can contain
 *  coordinates, data and command flags.
 */
OBJECT vectorItem
	x:INT        /* X coordinate or data */
	y:INT        /* Y coordinate         */
	flags:LONG   /* See below        */
ENDOBJECT

/* Flags */
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
		VIF_ENDOPEN,        /* end area outline pen             */
		VIF_MINSIZE,        /* X & Y are minimum size            */  /* V41.8 */
		VIF_LINEPATTERN,    /* Use line pattern in vc_x          */
		VIF_BPEN,           /* Interpret vc_y as bpen            */
		VIF_DRAWMODE        /* Draw mode                         */


/* Built-in images. */
ENUM    BUILTIN_GETPATH = 1,
		BUILTIN_GETFILE,
		BUILTIN_CHECKMARK,
		BUILTIN_POPUP,
		BUILTIN_ARROW_UP,
		BUILTIN_ARROW_DOWN,
		BUILTIN_ARROW_LEFT,
		BUILTIN_ARROW_RIGHT,
		BUILTIN_CYCLE,          /* V41 */
		BUILTIN_CYCLE2,         /* V41 */
		BUILTIN_RADIOBUTTON     /* V41 */

/* Design width and heights of the built-in images. */
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

/*****************************************************************************
 *
 *  "baseclass" - BOOPSI base gadget.
 *
 *  Tags: 241 - 320         Methods: 41 - 80
 *
 *  This is a very important BGUI gadget class. All other gadget classes
 *  are sub-classed from this class. It will handle stuff like online
 *  help, notification, labels and frames etc. If you want to write a
 *  gadget class for BGUI be sure to subclass it from this class. That
 *  way your class will automatically inherit the same features.
 */
		BT_TAGSTART                 = BGUI_TB+241,
		BT_HelpFile                 = BGUI_TB+241,   /* IS--- */
		BT_HelpNode                 = BGUI_TB+242,   /* IS--- */
		BT_HelpLine                 = BGUI_TB+243,   /* IS--- */
		BT_Inhibit                  = BGUI_TB+244,   /* --G-- */
		BT_HitBox                   = BGUI_TB+245,   /* --G-- */
		BT_LabelObject              = BGUI_TB+246,   /* -SG-- */
		BT_FrameObject              = BGUI_TB+247,   /* -SG-- */
		BT_TextAttr                 = BGUI_TB+248,   /* ISG-- */
		BT_NoRecessed               = BGUI_TB+249,   /* -S--- */
		BT_LabelClick               = BGUI_TB+250,   /* IS--- */
		BT_HelpText                 = BGUI_TB+251,   /* IS--- */
		BT_ToolTip                  = BGUI_TB+252,   /* ISG-- */  /* V40 */
		BT_DragObject               = BGUI_TB+253,   /* ISG-- */  /* V40 */
		BT_DropObject               = BGUI_TB+254,   /* ISG-- */  /* V40 */
		BT_DragTreshold             = BGUI_TB+255,   /* ISG-- */  /* V40 */
		BT_DragQualifier            = BGUI_TB+256,   /* ISG-- */  /* V40 */
		BT_Key                      = BGUI_TB+257,   /* ISG-- */  /* V41.2 */
		BT_RawKey                   = BGUI_TB+258,   /* ISG-- */  /* V41.2 */
		BT_Qualifier                = BGUI_TB+259,   /* ISG-- */  /* V41.2 */
		BT_HelpTextID               = BGUI_TB+260,   /* ISG-- */  /* V41.3 */
		BT_ToolTipID                = BGUI_TB+261,   /* ISG-- */  /* V41.3 */
		BT_MouseActivation          = BGUI_TB+262,   /* ISG-- */  /* V41.5 */
		BT_Reserved1                = BGUI_TB+263,   /* ISG-- */  /* V41.6 */
		BT_Reserved2                = BGUI_TB+264,   /* ISG-- */  /* V41.6 */
		BT_Buffer                   = BGUI_TB+265,   /* ISG-- */  /* V41.6 */
		BT_LeftOffset               = BGUI_TB+266,   /* ISG-- */  /* V41.6 */
		BT_RightOffset              = BGUI_TB+267,   /* ISG-- */  /* V41.6 */
		BT_TopOffset                = BGUI_TB+268,   /* ISG-- */  /* V41.6 */
		BT_BottomOffset             = BGUI_TB+269,   /* ISG-- */  /* V41.6 */
		BT_HelpHook                 = BGUI_TB+270,   /* ISG-- */  /* V41.7 */
		BT_OuterBox                 = BGUI_TB+271,   /* --G-- */  /* V41.8 */
		BT_InnerBox                 = BGUI_TB+272,   /* --G-- */
		BT_PostRenderHighestClass   = BGUI_TB+273,   /* --G-- */
		BT_TAGDONE                  = BGUI_TB+320,

		MOUSEACT_RMB_ACTIVE = 1,
		MOUSEACT_RMB_REPORT = 2,
		MOUSEACT_MMB_ACTIVE = 4,
		MOUSEACT_MMB_REPORT = 8,

/* New methods */
		BASE_ADDMAP         = BGUI_MB+41

/* Add an object to the maplist notification list. */
OBJECT bmAddMap
	methodID:LONG
	object:PTR TO object
	mapList:PTR TO tagitem
ENDOBJECT

CONST   BASE_ADDCONDITIONAL     = BGUI_MB+42

/* Add an object to the conditional notification list. */
OBJECT bmAddConditional
	methodID:LONG
	object:PTR TO object
	condition:tagitem
	true:tagitem
	false:tagitem
ENDOBJECT

CONST   BASE_ADDMETHOD          = BGUI_MB+43

/* Add an object to the method notification list. */
OBJECT bmAddMethod
	methodID:LONG
	object:PTR TO object
	flags:LONG
	size:LONG
	amethodID:LONG
ENDOBJECT

SET     BAMF_NO_GINFO,  /* Do not send GadgetInfo. */
		BAMF_NO_INTERIM /* Skip interim messages.  */

CONST   BASE_REMMAP             = BGUI_MB+44,
		BASE_REMCONDITIONAL     = BGUI_MB+45,
		BASE_REMMETHOD          = BGUI_MB+46

/* Remove an object from a notification list. */
OBJECT bmRemove
	methodID:LONG
	object:PTR TO object
ENDOBJECT

CONST   BASE_SHOWHELP           = BGUI_MB+47

/* Show attached online-help. */
OBJECT bmShowHelp
	methodID:LONG
	window:PTR TO  window
	requester:PTR TO requester
	mouseX:INT
	mouseY:INT
ENDOBJECT

ENUM    BMHELP_OK,        /* OK, no problems.       */
		BMHELP_NOT_ME,    /* Mouse not over the object. */
		BMHELP_FAILURE    /* Showing failed.        */

CONST   BASE_UNUSED1            = BGUI_MB+48,
		BASE_UNUSED2            = BGUI_MB+49,
		BASE_UNUSED3            = BGUI_MB+50,
		BASE_UNUSED4            = BGUI_MB+51

CONST   BASE_ADDHOOK            = BGUI_MB+52

/* Add a hook to the hook-notification list. */
OBJECT bmAddHook
	methodID:LONG
	hook:PTR TO hook
ENDOBJECT

/* Remove a hook from the hook-notification list. */
CONST   BASE_REMHOOK            = BGUI_MB+53,
		BASE_DRAGGING           = BGUI_MB+54 /* V40 */

/* Return codes for the BASE_DRAGGING method. */
CONST   BDR_NONE            = 0, /* Handle input yourself.   */
		BDR_DRAGPREPARE     = 1, /* Prepare for dragging.    */
		BDR_DRAGGING        = 2, /* Don't handle events.     */
		BDR_DROP            = 3, /* Image dropped.       */
		BDR_CANCEL          = 4  /* Drag canceled.       */

CONST   BASE_DRAGQUERY          = BGUI_MB+55 /* V40 */

/* For both BASE_DRAGQUERY and BASE_DRAGUPDATE. */
OBJECT bmDragPoint
	methodID:LONG               -> BASE_DRAGQUERY
	gInfo:PTR TO gadgetinfo     -> GadgetInfo
	source:PTR TO object        -> Object querying.
	mouseX:INT                  -> Mouse coords.
	mouseY:INT                  -> Mouse coords.
ENDOBJECT

/* Return codes for BASE_DRAGQUERY. */
CONST   BQR_REJECT = 0,  /* Object will not accept drop. */
		BQR_ACCEPT = 1  /* Object will accept drop. */

CONST   BASE_DRAGUPDATE         = BGUI_MB+56 /* V40 */

/* Return codes for BASE_DRAGUPDATE. */
CONST   BUR_CONTINUE= 0, /* Continue drag. */
		BUR_ABORT   = 1  /* Abort drag.    */

CONST   BASE_DROPPED            = BGUI_MB+57 /* V40 */

/* Source object is dropped. */
OBJECT bmDropped
	methodID:LONG
	gInfo:PTR TO gadgetinfo         -> GadgetInfo structure
	source:PTR TO object            -> Object dropped
	sourceWin:PTR TO window         -> Source obj window
	sourceReq:PTR TO requester      -> Source onj requester
ENDOBJECT

CONST   BASE_DRAGACTIVE         = BGUI_MB+58, /* V40 */
		BASE_DRAGINACTIVE       = BGUI_MB+59 /* V40 */

/* Used by both methods defined above. */
OBJECT bmDragMsg
	methodID:LONG
	gInfo:PTR TO gadgetinfo        -> GadgetInfo structure
	source:PTR TO object           -> Object being dragged
ENDOBJECT

CONST   BASE_GETDRAGOBJECT      = BGUI_MB+60 /* V40 */

/* Obtain BitMap image to drag. */
OBJECT bmGetDragObject
	methodID:LONG               -> BASE_GETDRAGOBJECT
	gInfo:PTR TO gadgetinfo     -> GadgetInfo
	bounds:PTR TO ibox          -> Bounds to buffer
ENDOBJECT

CONST   BASE_FREEDRAGOBJECT     = BGUI_MB+61 /* V40 */

/* Free BitMap image being dragged. */
OBJECT bmFreeDragObject
	methodID:LONG                   -> BASE_FREEDRAGOBJECT
	gInfo:PTR TO gadgetinfo         -> GadgetInfo
	objBitMap:PTR TO bitmap         -> BitMap to free
ENDOBJECT

CONST   BASE_INHIBIT            = BGUI_MB+62

/* Inhibit/uninhibit this object.       */
OBJECT bmInhibit
	methodID:LONG                   -> BASE_INHIBIT
	inhibit:LONG                    -> Inhinit on/off
ENDOBJECT

CONST   BASE_FINDKEY            = BGUI_MB+63     /* V41 */

/* Locate object with this rawkey.  */
OBJECT  bmFindKey
	methodID:LONG           -> BASE_FINDKEY
	qual:INT                -> Key to find
	key:INT
ENDOBJECT

CONST   BASE_KEYLABEL           = BGUI_MB+64     /* V41 */

/* Attach key in this label to the object.  */
OBJECT  bmKeyLabel
	methodID:LONG   -> BASE_KEYLABEL
ENDOBJECT

CONST   BASE_LOCALIZE           = BGUI_MB+65     /* V41 */

/* Localize this object.            */
OBJECT bmLocalize
	methodID:LONG
	locale:PTR TO bguiLocale
ENDOBJECT

/*****************************************************************************
 *
 *  "groupclass" - BOOPSI group gadget.
 *
 *  Tags: 321 - 400         Methods: 81 - 120
 *
 *  This class is the actual bgui.library layout engine. It will layout
 *  all members in a specific area. Two group types are available,
 *  horizontal and vertical groups.
 */
CONST   GROUP_Style             = BGUI_TB+321,   /* I---- */
		GROUP_Spacing           = BGUI_TB+322,   /* I---- */
		GROUP_HorizOffset       = BGUI_TB+323,   /* I---- */
		GROUP_VertOffset        = BGUI_TB+324,   /* I---- */
		GROUP_LeftOffset        = BGUI_TB+325,   /* I---- */
		GROUP_TopOffset         = BGUI_TB+326,   /* I---- */
		GROUP_RightOffset       = BGUI_TB+327,   /* I---- */
		GROUP_BottomOffset      = BGUI_TB+328,   /* I---- */
		GROUP_Member            = BGUI_TB+329,   /* I---- */
		GROUP_SpaceObject       = BGUI_TB+330,   /* I---- */
		GROUP_BackFill          = BGUI_TB+331,   /* I---- */
		GROUP_EqualWidth        = BGUI_TB+332,   /* I---- */
		GROUP_EqualHeight       = BGUI_TB+333,   /* I---- */
		GROUP_Inverted          = BGUI_TB+334,   /* I---- */
		GROUP_BackPen           = BGUI_TB+335,   /* I---- */  /* V40 */
		GROUP_BackDriPen        = BGUI_TB+336,   /* I---- */  /* V40 */
		GROUP_Offset            = BGUI_TB+337,   /* I---- */  /* V41 */
		GROUP_HorizSpacing      = BGUI_TB+338,   /* IS--- */  /* V41.7 */
		GROUP_VertSpacing       = BGUI_TB+339,   /* IS--- */  /* V41.7 */
		GROUP_LayoutHook        = BGUI_TB+340,   /* I---- */  /* V41.7 */

/* Object layout attributes. */
		LGO_TAGSTART            = BGUI_TB+381,
		LGO_FixWidth            = BGUI_TB+381,
		LGO_FixHeight           = BGUI_TB+382,
		LGO_Weight              = BGUI_TB+383,
		LGO_FixMinWidth         = BGUI_TB+384,
		LGO_FixMinHeight        = BGUI_TB+385,
		LGO_Align               = BGUI_TB+386,
		LGO_NoAlign             = BGUI_TB+387,                  /* V38 */
		LGO_FixAspect           = BGUI_TB+388,                  /* V41 */
		LGO_Visible             = BGUI_TB+389,   /* IS--- */  /* V41 */
		LGO_Custom              = BGUI_TB+400,   /* IS--- */  /* V41.7 */
		LGO_TAGDONE             = BGUI_TB+400,

/* Default object weight. */
		DEFAULT_WEIGHT          = 50,

/* Group styles. */
		GRSTYLE_HORIZONTAL      = 0,
		GRSTYLE_VERTICAL        = 1,
		GRSPACE_NARROW          = -1,                          /* V41 */
		GRSPACE_NORMAL          = -2,                         /* V41 */
		GRSPACE_WIDE            = -3,                         /* V41 */

/* New methods. */
		GRM_ADDMEMBER           = BGUI_MB+81

/* Add a member to the group. */
OBJECT grmAddMember
	methodID:LONG           -> GRM_ADDMEMBER
	member:PTR TO object    -> Object to add
	attr:LONG               -> First of LGO attributes
ENDOBJECT

CONST   GRM_REMMEMBER           = BGUI_MB+82

/* Remove a member from the group. */
OBJECT grmRemMember
	methodID:LONG    -> GRM_REMMEMBER
	member:PTR TO object     -> Object to remove
ENDOBJECT

CONST   GRM_DIMENSIONS          = BGUI_MB+83

/* Ask an object it's dimensions information. */
OBJECT grmDimensions
	methodID:LONG               -> GRM_DIMENSIONS
	gInfo:PTR TO gadgetinfo     -> Can be NIL!
	rPort:PTR TO rastport       -> Ready for calculations
	minSizeWidth:PTR TO INT
	minSizeHeight:PTR TO INT
	flags:LONG                  -> See below
ENDOBJECT

/* Flags */
CONST   GDIMF_NO_FRAME          = 1,  -> Don't take frame width/height into consideration
		GDIMF_NO_OFFSET         = 2, -> No inner offset from frame
		GDIMF_MAXIMUMS          = 4,  /* The grmd_MaxSize is requested.       */

		GRM_ADDSPACEMEMBER      = BGUI_MB+84

/* Add a weight controlled spacing member. */
OBJECT grmAddSpaceMember
	methodID:LONG       -> GRM_ADDSPACEMEMBER
	weight:LONG         -> Object weight
ENDOBJECT

CONST   GRM_INSERTMEMBER        = BGUI_MB+85

/* Insert a member in the group. */
OBJECT grmInsertMember
	methodID:LONG           -> GRM_INSERTMEMBER
	member:PTR TO object    -> Member to insert
	pred:PTR TO object      -> Insert after this member
	attr:LONG               -> First of LGO attributes
ENDOBJECT

CONST   GRM_REPLACEMEMBER       = BGUI_MB+86    /* V40 */

/* Replace a member in the group. */
OBJECT grmReplaceMember
	methodID:LONG           -> GRM_REPLACEMEMBER
	memberA:PTR TO object   -> Object to replace
	memberB:PTR TO object   -> Object which replaces
	attr:LONG               -> First of LGO attributes
ENDOBJECT

CONST   GRM_WHICHOBJECT         = BGUI_MB+87    /* V40 */

/* Locate object under these coords. */
OBJECT grmWhichObject
	methodID:LONG   -> GRM_WHICHOBJECT
	coordsX:INT
	coordsY:INT
ENDOBJECT

CONST   GRM_MAXDIMENSIONS       = BGUI_MB+88    /* 41 */

/* Ask an object it's maximum dimensions. */
OBJECT grmMaxDimensions
	methodID:LONG
	gInfo:PTR TO gadgetinfo -> Can be NIL
	rPort:PTR TO rastport
	maxSizeWidth:PTR TO LONG
	maxSizeHeight:PTR TO LONG
	flags:LONG
ENDOBJECT
/* No flags defined yet. */

/*****************************************************************************
 *
 *  "buttonclass" - BOOPSI button gadget.
 *
 *  Tags: 401 - 480         Methods: 121 - 160
 *
 *  GadTools style button gadget.
 *
 *  GA_Selected has been made gettable (OM_GET) for toggle-select
 *  buttons. (ISGNU)
 */
CONST   BUTTON_UNUSED1          = BGUI_TB+401,   /* PRIVATE! */
		BUTTON_UNUSED0          = BGUI_TB+402,   /* PRIVATE! */
		BUTTON_Image            = BGUI_TB+403,   /* IS--U */
		BUTTON_SelectedImage    = BGUI_TB+404,   /* IS--U */
		BUTTON_EncloseImage     = BGUI_TB+405,   /* I---- */  /* V39 */
		BUTTON_Vector           = BGUI_TB+406,   /* IS--U */  /* V41 */
		BUTTON_SelectedVector   = BGUI_TB+407,   /* IS--U */  /* V41 */
		BUTTON_SelectOnly       = BGUI_TB+408,   /* I---- */  /* V41.6 */

/*****************************************************************************
 *
 *  "checkboxclass" - BOOPSI checkbox gadget.
 *
 *  Tags: 481 - 560         Methods: 161 - 200
 *
 *  GadTools style checkbox gadget.
 *
 *  GA_Selected has been made gettable (OM_GET). (ISGNU)
 */

/*****************************************************************************
 *
 *  "cycleclass" - BOOPSI cycle gadget.
 *
 *  Tags: 561 - 640         Methods: 201 - 240
 *
 *  GadTools style cycle gadget.
 */
		CYC_Labels              = BGUI_TB+561,   /* I---- */
		CYC_Active              = BGUI_TB+562,   /* ISGNU */
		CYC_Popup               = BGUI_TB+563,   /* I---- */
		CYC_PopActive           = BGUI_TB+564,   /* I---- */  /* V40 */

/*****************************************************************************
 *
 *  "infoclass" - BOOPSI information gadget.
 *
 *  Tags: 641 - 720         Methods: 241 - 280
 *
 *  Text gadget which supports different colors, text styles and
 *  text positioning.
 */
		INFO_TextFormat         = BGUI_TB+641,   /* IS--U */
		INFO_Args               = BGUI_TB+642,   /* IS--U */
		INFO_MinLines           = BGUI_TB+643,   /* I---- */
		INFO_FixTextWidth       = BGUI_TB+644,   /* I---- */
		INFO_HorizOffset        = BGUI_TB+645,   /* I---- */
		INFO_VertOffset         = BGUI_TB+646    /* I---- */

/* Command sequences. */
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
#define ISEQ_FONT               '\21f\z\h[8]\22' /* Set Font */
#define ISEQ_IMAGE              '\21i\z\h[8]\22' /* Draw Image */

/*****************************************************************************
 *
 *  "listviewclass" - BOOPSI listview gadget.
 *
 *  Tags: 721 - 800         Methods: 281 - 320
 *
 *  GadTools style listview gadget.
 */
CONST   LISTV_TAGSTART              = BGUI_TB+721,
		LISTV_ResourceHook          = BGUI_TB+721,   /* IS--- */
		LISTV_DisplayHook           = BGUI_TB+722,   /* IS--- */
		LISTV_CompareHook           = BGUI_TB+723,   /* IS--- */
		LISTV_Top                   = BGUI_TB+724,   /* ISG-U */
		LISTV_ListFont              = BGUI_TB+725,   /* I-G-- */
		LISTV_ReadOnly              = BGUI_TB+726,   /* I---- */
		LISTV_MultiSelect           = BGUI_TB+727,   /* IS--U */
		LISTV_EntryArray            = BGUI_TB+728,   /* I---- */
		LISTV_Select                = BGUI_TB+729,   /* -S--U */
		LISTV_MakeVisible           = BGUI_TB+730,   /* -S--U */
		LISTV_Entry                 = BGUI_TB+731,   /* ---N- */
		LISTV_SortEntryArray        = BGUI_TB+732,   /* I---- */
		LISTV_EntryNumber           = BGUI_TB+733,   /* ---N- */
		LISTV_TitleHook             = BGUI_TB+734,   /* I---- */
		LISTV_LastClicked           = BGUI_TB+735,   /* --G-- */
		LISTV_ThinFrames            = BGUI_TB+736,   /* I---- */
		LISTV_LastClickedNum        = BGUI_TB+737,   /* --G-- */  /* V38 */
		LISTV_NewPosition           = BGUI_TB+738,   /* ---N- */  /* V38 */
		LISTV_NumEntries            = BGUI_TB+739,   /* --G-- */  /* V38 */
		LISTV_MinEntriesShown       = BGUI_TB+740,   /* I---- */  /* V38 */
		LISTV_SelectMulti           = BGUI_TB+741,   /* -S--U */  /* V39 */
		LISTV_SelectNotVisible      = BGUI_TB+742,   /* -S--U */  /* V39 */
		LISTV_SelectMultiNotVisible = BGUI_TB+743,   /* -S--U */  /* V39 */
		LISTV_MultiSelectNoShift    = BGUI_TB+744,   /* IS--U */  /* V39 */
		LISTV_Deselect              = BGUI_TB+745,   /* -S--U */  /* V39 */
		LISTV_DropSpot              = BGUI_TB+746,   /* --G-- */  /* V40 */
		LISTV_ShowDropSpot          = BGUI_TB+747,   /* IS--- */  /* V40 */
		LISTV_ViewBounds            = BGUI_TB+748,   /* --G-- */  /* V40 */
		LISTV_CustomDisable         = BGUI_TB+749,   /* ISG-- */  /* V40 */
		LISTV_FilterHook            = BGUI_TB+750,   /* ISG-- */  /* V41 */
		LISTV_Columns               = BGUI_TB+751,   /* I-G-U */  /* V41 */
		LISTV_ColumnWeights         = BGUI_TB+752,   /* ISG-U */  /* V41 */
		LISTV_DragColumns           = BGUI_TB+753,   /* ISG-U */  /* V41 */
		LISTV_Titles                = BGUI_TB+754,   /* ISG-U */  /* V41 */
		LISTV_PropObject            = BGUI_TB+755,   /* ISG-- */  /* V41 */
		LISTV_PreClear              = BGUI_TB+756,   /* ISG-- */  /* V41 */
		LISTV_LastColumn            = BGUI_TB+757,   /* --G-- */  /* V41 */
		LISTV_LayoutHook            = BGUI_TB+758,   /* IS--U */  /* V41 */

/*
**  LISTV_Select magic numbers.
**/
		LISTV_Select_First          = -1,                /* V38 */
		LISTV_Select_Last           = -2,                /* V38 */
		LISTV_Select_Next           = -3,                /* V38 */
		LISTV_Select_Previous       = -4,                /* V38 */
		LISTV_Select_Top            = -5,                /* V38 */
		LISTV_Select_Page_Up        = -6,                /* V38 */
		LISTV_Select_Page_Down      = -7,                /* V38 */
		LISTV_Select_All            = -8                /* V39 */

/*
 *  The LISTV_ResourceHook is called as follows:
 *
 *  rc = hookFunc( REG(A0) struct Hook      *hook,
 *             REG(A2) Object           *lv_object,
 *             REG(A1) struct lvResource    *message );
 */
OBJECT lvResource
	command:INT
	entry:PTR TO LONG
ENDOBJECT

/* LISTV_ResourceHook commands. */
CONST   LVRC_MAKE       = 1   /* Build the entry. */
CONST   LVRC_KILL       = 2   /* Kill the entry.  */

/*
 *  The LISTV_DisplayHook and the LISTV_TitleHook are called as follows:
 *
 *  rc = hookFunc( REG(A0) struct Hook         *hook,
 *             REG(A2) Object              *lv_object,
 *             REG(A1) struct lvRender         *message );
 */
OBJECT lvRender
	rPort:PTR TO rastport       /* RastPort to render in.  */
	drawInfo:PTR TO drawinfo    /* All you need to render. */
	bounds:rectangle            /* Bounds to render in.    */
	entry:PTR TO LONG           /* Entry to render.    */
	state:INT                   /* See below.          */
	flags:INT                   /* None defined yet.       */
	column:INT                  /* column to render         */
ENDOBJECT

/* Rendering states. */
ENUM    LVRS_NORMAL,
		LVRS_SELECTED,
		LVRS_NORMAL_DISABLED,
		LVRS_SELECTED_DISABLED

/*
 *  The LISTV_CompareHook is called as follows:
 *
 *  rc = hookFunc( REG(A0) struct Hook      *hook,
 *             REG(A2) Object           *lv_object,
 *             REG(A1) struct lvCompare         *message );
 */
OBJECT lvCompare
	entryA:PTR TO LONG      /* First entry.  */
	entryB:PTR TO LONG      /* Second entry. */
ENDOBJECT

OBJECT lvLayout
	id:INT                  /* GA_ID of list.        */
	column:INT              /* Column to layout.     */
	listWidth:INT           /* Width of list.        */
	entryHeight:INT         /* Height of entries.    */
	flags:PTR TO LONG       /* Flag storage.         */
	minWidth:PTR TO INT     /* Minimum column width. */
	maxWidth:PTR TO INT     /* Maximum column width. */
ENDOBJECT

CONST   LVLF_PRECLEAR           = 1,
		LVLF_DRAGGABLE          = 2,
		LVLF_HIDDEN             = 4

/* New Methods. */
CONST   LVM_ADDENTRIES          = BGUI_MB+281

/* Add listview entries. */
OBJECT lvmAddEntries
	methodID:LONG               /* LVM_ADDENTRIES  */
	gInfo:PTR TO gadgetinfo     /* GadgetInfo      */
	entries:PTR TO LONG         /* Entries to add. */
	how:LONG                    /* How to add it.  */
ENDOBJECT

/* Where to add the entries. */
ENUM    LVAP_HEAD      = 1,
		LVAP_TAIL,
		LVAP_SORTED

CONST   LVM_ADDSINGLE           = BGUI_MB+282

/* Add a single entry. */
OBJECT lvmAddSingle
	methodID:LONG           /* LVM_ADDSINGLE */
	gInfo:PTR TO gadgetinfo /* GadgetInfo    */
	entry:PTR TO LONG       /* Entry to add. */
	how:LONG                /* See above.    */
	flags:LONG              /* See below.    */
ENDOBJECT

/* Flags. */
SET     LVASF_MAKEVISIBLE,  /* Make entry visible.          */
		LVASF_SELECT,       /* Select entry.            */
		LVASF_MULTISELECT,  /* Multi-select entry.      V40 */
		LVASF_NOT_VISIBLE   /* Do not make visible.         V40 */

/* Clear the entire list. ( Uses a lvmCommand structure as defined below.) */
CONST   LVM_CLEAR               = BGUI_MB+283,

		LVM_FIRSTENTRY          = BGUI_MB+284,
		LVM_LASTENTRY           = BGUI_MB+285,
		LVM_NEXTENTRY           = BGUI_MB+286,
		LVM_PREVENTRY           = BGUI_MB+287

/* Get an entry. */
OBJECT lvmGetEntry
	methodID:LONG           /* Any of the above. */
	previous:PTR TO LONG    /* Previous entry.   */
	flags:LONG              /* See below.        */
ENDOBJECT

SET     LVGEF_SELECTED     /* Get selected entries. */

CONST   LVM_REMENTRY            = BGUI_MB+288

/* Remove an entry. */
OBJECT lvmRemEntry
	methodID:LONG   /* LVM_REMENTRY      */
	gInfo:PTR TO gadgetinfo /* GadgetInfo        */
	entry:PTR TO LONG       /* Entry to remove.  */
ENDOBJECT

CONST   LVM_REFRESH         = BGUI_MB+289,
		LVM_SORT            = BGUI_MB+290,
		LVM_LOCKLIST        = BGUI_MB+291,
		LVM_UNLOCKLIST      = BGUI_MB+292

/* Refresh/Sort list. */
OBJECT lvmCommand
	methodID:LONG           /* LVM_REFRESH       */
	gInfo:PTR TO gadgetinfo /* GadgetInfo        */
ENDOBJECT

CONST   LVM_MOVE            = BGUI_MB+293 /* V38 */

/* Move an entry in the list. */
OBJECT lvmMove
	methodID:LONG           /* LVM_MOVE      */
	gInfo:PTR TO gadgetinfo /* GadgetInfo        */
	entry:PTR TO LONG       /* Entry to move     */
	direction:LONG          /* See below         */
	newPos:LONG             /* New position. V40 */
ENDOBJECT

/* Move directions. */
ENUM    LVMOVE_UP,      /* Move entry up.        */
		LVMOVE_DOWN,    /* Move entry down.      */
		LVMOVE_TOP,     /* Move entry to the top.    */
		LVMOVE_BOTTOM,  /* Move entry to the bottom. */
		LVMOVE_NEWPOS   /* Move to new position. V40 */

CONST   LVM_REPLACE             = BGUI_MB+294 /* V39 */

/* Replace an entry by another. */
OBJECT lvmReplace
	methodID:LONG              /* LVM_REPLACE       */
	gInfo:PTR TO gadgetinfo    /* GadgetInfo        */
	oldEntry:PTR TO LONG       /* Entry to replace. */
	newEntry:PTR TO LONG       /* New entry.        */
ENDOBJECT

CONST   LVM_REDRAW              = BGUI_MB+295, /* V40 */
		LVM_INSERTENTRIES       = BGUI_MB+296 /* V40 */

/* Insert listview entries. */
OBJECT lvmInsertEntries
	methodID:LONG              /* LVM_INSERTENTRIES */
	gInfo:PTR TO gadgetinfo    /* GadgetInfo        */
	pos:LONG                   /* Position.         */
	entries:PTR TO LONG        /* Entries to insert.*/
ENDOBJECT

CONST   LVM_INSERTSINGLE        = BGUI_MB+297 /* V40 */

/* Insert a single entry. */
OBJECT lvmInsertSingle
	methodID:LONG              /* LVM_INSERTSINGLE  */
	gInfo:PTR TO gadgetinfo    /* GadgetInfo        */
	pos:LONG                   /* Position.         */
	entry:PTR TO LONG          /* Entry to insert.  */
	flags:LONG                 /* See LVM_ADDSINGLE */
ENDOBJECT

CONST   LVM_REMSELECTED         = BGUI_MB+298,   /* V40 */
		LVM_REDRAWSINGLE        = BGUI_MB+299    /* V41.7 */

/* Redraw a single entry or column. */
OBJECT lvmRedrawSingle
	methodID:LONG               /* LVM_REDRAWSINGLE  */
	gInfo:PTR TO gadgetinfo     /* GadgetInfo.       */
	entry:PTR TO LONG           /* Entry to redraw.  */
	column:LONG                 /* Column to redraw. */
	flags:LONG                  /* See below.        */
ENDOBJECT

CONST   LVRF_ALL_COLUMNS        = 1,
		LVRF_ALL_ENTRIES        = 2,
		LVM_FILTER              = BGUI_MB+299    /* V41 */

/* Filter the list entries. */
OBJECT lvmFilter
	methodID:LONG
	flags:LONG
ENDOBJECT

CONST   LVFF_ALL                = 1,
		LVFF_NOT                = 2,
		LVFF_SORTED             = 4,
		LVFF_NONE               = 3,

		LVM_FILTERSWAP          = BGUI_MB+300,

/*****************************************************************************
 *
 *  "progressclass" - BOOPSI progression gadget.
 *
 *  Tags: 801 - 880         Methods: 321 - 360
 *
 *  Progression indicator fuel guage.
 */
		PROGRESS_Min            = BGUI_TB+801,   /* IS--- */
		PROGRESS_Max            = BGUI_TB+802,   /* IS--- */
		PROGRESS_Done           = BGUI_TB+803,   /* ISGNU */
		PROGRESS_Vertical       = BGUI_TB+804,   /* I---- */
		PROGRESS_Divisor        = BGUI_TB+805,   /* I---- */
		PROGRESS_FormatString   = BGUI_TB+806,   /* I---- */  /* V40 */

/*****************************************************************************
 *
 *  "propclass" - BOOPSI proportional gadget.
 *
 *  Tags: 881 - 960         Methods: 361 - 400
 *
 *  GadTools style scroller gadget.
 */
		PGA_Arrows              = BGUI_TB+881,   /* I---- */
		PGA_ArrowSize           = BGUI_TB+882,   /* I---- */
		PGA_Reserved            = BGUI_TB+883,   /* PRIVATE! */
		PGA_ThinFrame           = BGUI_TB+884,   /* I---- */
		PGA_XenFrame            = BGUI_TB+885,   /* I---- */
		PGA_NoFrame             = BGUI_TB+886,   /* I---- */  /* V40 */

/*****************************************************************************
 *
 *  "stringclass" - BOOPSI string gadget.
 *
 *  Tags: 961 - 1040        Methods: 401 - 440
 *
 *  GadTools style string/integer gadget.
 */
		STRINGA_UNUSED1         = BGUI_TB+961,   /* PRIVATE! */
		STRINGA_UNUSED2         = BGUI_TB+962,   /* PRIVATE! */
		STRINGA_MinCharsVisible = BGUI_TB+963,   /* I---- */  /* V39 */
		STRINGA_IntegerMin      = BGUI_TB+964,   /* IS--U */  /* V39 */
		STRINGA_IntegerMax      = BGUI_TB+965,   /* IS--U */  /* V39 */
		STRINGA_StringInfo      = BGUI_TB+966,   /* --G-- */  /* V40 */

		SM_FORMAT_STRING        = BGUI_MB+401    /* V39 */

/* Format the string contents. */
OBJECT smFormatString
	methodID:LONG               /* SM_FORMAT_STRING    */
	gInfo:PTR TO gadgetinfo     /* GadgetInfo          */
	fStr:PTR TO LONG            /* Format string       */
	arg1:LONG                   /* Format arg          */
ENDOBJECT

/*****************************************************************************
 *
 *  "viewclass" - BOOPSI view object.
 *
 *  Tags: 1041 - 1120       Methods: 441 - 480
 *
 *  Gadget to view a clipped portion of another object.
 */
CONST   VIEW_X                  = BGUI_TB+1041,  /* ISG-U */
		VIEW_Y                  = BGUI_TB+1042,  /* ISG-U */
		VIEW_MinWidth           = BGUI_TB+1043,  /* ISG-- */
		VIEW_MinHeight          = BGUI_TB+1044,  /* ISG-- */
		VIEW_ScaleMinWidth      = BGUI_TB+1045,  /* ISG-- */
		VIEW_ScaleMinHeight     = BGUI_TB+1046,  /* ISG-- */
		VIEW_ScaleWidth         = BGUI_TB+1047,  /* ISG-- */
		VIEW_ScaleHeight        = BGUI_TB+1048,  /* ISG-- */
		VIEW_VScroller          = BGUI_TB+1049,  /* IS--- */
		VIEW_HScroller          = BGUI_TB+1050,  /* IS--- */
		VIEW_AbsoluteX          = BGUI_TB+1051,  /* --G-- */
		VIEW_AbsoluteY          = BGUI_TB+1052,  /* --G-- */
		VIEW_Object             = BGUI_TB+1053,  /* ISG-U */
		VIEW_NoDisposeObject    = BGUI_TB+1054   /* ISG-- */

/*****************************************************************************
 *
 *  "pageclass" - BOOPSI paging gadget.
 *
 *  Tags: 1121 - 1200       Methods: 481 - 520
 *
 *  Gadget to handle pages of gadgets.
 */
CONST   PAGE_Active             = BGUI_TB+1121,  /* ISGNU */
		PAGE_Member             = BGUI_TB+1122,  /* I---- */
		PAGE_NoBufferRP         = BGUI_TB+1123,  /* I---- */
		PAGE_Inverted           = BGUI_TB+1124,  /* I---- */

/*****************************************************************************
 *
 *  "mxclass" - BOOPSI mx gadget.
 *
 *  Tags: 1201 - 1280       Methods: 521 - 560
 *
 *  GadTools style mx gadget.
 */
		MX_Labels               = BGUI_TB+1201,  /* I---- */
		MX_Active               = BGUI_TB+1202,  /* ISGNU */
		MX_LabelPlace           = BGUI_TB+1203,  /* I---- */
		MX_DisableButton        = BGUI_TB+1204,  /* IS--U */
		MX_EnableButton         = BGUI_TB+1205,  /* IS--U */
		MX_TabsObject           = BGUI_TB+1206,  /* I---- */
		MX_TabsTextAttr         = BGUI_TB+1207,  /* I---- */
		MX_TabsUpsideDown       = BGUI_TB+1208,  /* I---- */  /* V40 */
		MX_TabsBackFill         = BGUI_TB+1209,  /* I---- */  /* V40 */
		MX_TabsBackPen          = BGUI_TB+1210,  /* I---- */  /* V40 */
		MX_TabsBackDriPen       = BGUI_TB+1211,  /* I---- */  /* V40 */
		MX_LabelsID             = BGUI_TB+1212,  /* I---- */  /* V41 */
		MX_Spacing              = BGUI_TB+1213,  /* I---- */  /* V41 */
		MX_Type                 = BGUI_TB+1214,  /* I---- */  /* V41.8 */
		MX_TabsBackFillHook     = BGUI_TB+1215,  /* I---- */
		MX_TabsFillPattern      = BGUI_TB+1216,  /* i---- */
		MX_RotateLeft           = BGUI_TB+1217,  /* I---- */  /* RESERVED */
		MX_RotateRight          = BGUI_TB+1218,  /* I---- */  /* RESERVED */

		MXTYPE_RADIOBUTTON      = 0,
		MXTYPE_TAB_TOP          = 1,
		MXTYPE_TAB_BOTTOM       = 2,
		MXTYPE_TAB_LEFT         = 3,
		MXTYPE_TAB_RIGHT        = 4,

/*****************************************************************************
 *
 *  "sliderclass" - BOOPSI slider gadget.
 *
 *  Tags: 1281 - 1360       Methods: 561 - 600
 *
 *  GadTools style slider gadget.
 */
		SLIDER_Min              = BGUI_TB+1281,  /* IS--U */
		SLIDER_Max              = BGUI_TB+1282,  /* IS--U */
		SLIDER_Level            = BGUI_TB+1283,  /* ISGNU */
		SLIDER_ThinFrame        = BGUI_TB+1284,  /* I---- */
		SLIDER_XenFrame         = BGUI_TB+1285,  /* I---- */
		SLIDER_NoFrame          = BGUI_TB+1286,  /* I---- */  /* V40 */

/*****************************************************************************
 *
 *  "indicatorclass" - BOOPSI indicator gadget.
 *
 *  Tags: 1361 - 1440       Methods: ??
 *
 *  Textual level indicator gadget.
 */
		INDIC_Min               = BGUI_TB+1361,  /* I---- */
		INDIC_Max               = BGUI_TB+1362,  /* I---- */
		INDIC_Level             = BGUI_TB+1363,  /* IS--U */
		INDIC_FormatString      = BGUI_TB+1364,  /* I---- */
		INDIC_Justification     = BGUI_TB+1365,  /* I---- */

/* Justification */
		IDJ_LEFT                = 0,
		IDJ_CENTER              = 1,
		IDJ_RIGHT               = 2,

/*****************************************************************************
 *
 *  "externalclass" - BGUI external class interface.
 *
 *  Tags: 1441 - 1500       Methods: ??
 */
		EXT_Class               = BGUI_TB+1441,  /* I---- */
		EXT_ClassID             = BGUI_TB+1442,  /* I---- */
		EXT_MinWidth            = BGUI_TB+1443,  /* I---- */
		EXT_MinHeight           = BGUI_TB+1444,  /* I---- */
		EXT_TrackAttr           = BGUI_TB+1445,  /* I---- */
		EXT_Object              = BGUI_TB+1446,  /* --G-- */
		EXT_NoRebuild           = BGUI_TB+1447,  /* I---- */

/*****************************************************************************
 *
 *  "separatorclass" - BOOPSI separator class.
 *
 *  Tags: 1501 - 1580       Methods: ??
 */
		SEP_Horiz               = BGUI_TB+1501,  /* I---- */
		SEP_Title               = BGUI_TB+1502,  /* I---- */
		SEP_Thin                = BGUI_TB+1503,  /* I---- */
		SEP_Highlight           = BGUI_TB+1504,  /* I---- */
		SEP_CenterTitle         = BGUI_TB+1505,  /* I---- */
		SEP_Recessed            = BGUI_TB+1506,  /* I---- */  /* V39 */
		SEP_TitleLeft           = BGUI_TB+1507,  /* I---- */  /* V40 */
		SEP_TitleRight          = BGUI_TB+1508,  /* I---- */  /* V40 */
		SEP_TitleID             = BGUI_TB+1509,  /* IS--- */  /* V41.8 */

/* BGUI_TB+1581 through BGUI_TB+1760 reserved. */

/*****************************************************************************
 *
 *  "windowclass" - BOOPSI window class.
 *
 *  Tags: 1761 - 1860       Methods: 601 - 660
 *
 *  This class creates and maintains an intuition window.
 */
		WINDOW_Position         = BGUI_TB+1761,  /* I---- */
		WINDOW_ScaleWidth       = BGUI_TB+1762,  /* I---- */
		WINDOW_ScaleHeight      = BGUI_TB+1763,  /* I---- */
		WINDOW_LockWidth        = BGUI_TB+1764,  /* I---- */
		WINDOW_LockHeight       = BGUI_TB+1765,  /* I---- */
		WINDOW_PosRelBox        = BGUI_TB+1766,  /* I---- */
		WINDOW_Bounds           = BGUI_TB+1767,  /* ISG-- */
		WINDOW_DragBar          = BGUI_TB+1771,  /* I---- */
		WINDOW_SizeGadget       = BGUI_TB+1772,  /* I---- */
		WINDOW_CloseGadget      = BGUI_TB+1773,  /* I---- */
		WINDOW_DepthGadget      = BGUI_TB+1774,  /* I---- */
		WINDOW_SizeBottom       = BGUI_TB+1775,  /* I---- */
		WINDOW_SizeRight        = BGUI_TB+1776,  /* I---- */
		WINDOW_Activate         = BGUI_TB+1777,  /* I---- */
		WINDOW_RMBTrap          = BGUI_TB+1778,  /* I---- */
		WINDOW_SmartRefresh     = BGUI_TB+1779,  /* I---- */
		WINDOW_ReportMouse      = BGUI_TB+1780,  /* I---- */
		WINDOW_Borderless       = BGUI_TB+1781,  /* I---- */  /* V39 */
		WINDOW_Backdrop         = BGUI_TB+1782,  /* I---- */  /* V39 */
		WINDOW_ShowTitle        = BGUI_TB+1783,  /* I---- */  /* V39 */
		WINDOW_IDCMP            = BGUI_TB+1791,  /* I---- */
		WINDOW_SharedPort       = BGUI_TB+1792,  /* IS--- */
		WINDOW_Title            = BGUI_TB+1793,  /* IS--U */
		WINDOW_ScreenTitle      = BGUI_TB+1794,  /* IS--U */
		WINDOW_MenuStrip        = BGUI_TB+1795,  /* I-G-- */
		WINDOW_MasterGroup      = BGUI_TB+1796,  /* I---- */
		WINDOW_Screen           = BGUI_TB+1797,  /* IS--- */
		WINDOW_PubScreenName    = BGUI_TB+1798,  /* IS--- */
		WINDOW_UserPort         = BGUI_TB+1799,  /* --G-- */
		WINDOW_SigMask          = BGUI_TB+1800,  /* --G-- */
		WINDOW_IDCMPHook        = BGUI_TB+1801,  /* I---- */
		WINDOW_VerifyHook       = BGUI_TB+1802,  /* I---- */
		WINDOW_IDCMPHookBits    = BGUI_TB+1803,  /* I---- */
		WINDOW_VerifyHookBits   = BGUI_TB+1804,  /* I---- */
		WINDOW_Font             = BGUI_TB+1805,  /* I---- */
		WINDOW_FallBackFont     = BGUI_TB+1806,  /* I---- */
		WINDOW_HelpFile         = BGUI_TB+1807,  /* IS--- */
		WINDOW_HelpNode         = BGUI_TB+1808,  /* IS--- */
		WINDOW_HelpLine         = BGUI_TB+1809,  /* IS--- */
		WINDOW_AppWindow        = BGUI_TB+1810,  /* I---- */
		WINDOW_AppMask          = BGUI_TB+1811,  /* --G-- */
		WINDOW_UniqueID         = BGUI_TB+1812,  /* I---- */
		WINDOW_Window           = BGUI_TB+1813,  /* --G-- */
		WINDOW_HelpText         = BGUI_TB+1814,  /* IS--- */
		WINDOW_NoBufferRP       = BGUI_TB+1815,  /* I---- */
		WINDOW_AutoAspect       = BGUI_TB+1816,  /* I---- */
		WINDOW_PubScreen        = BGUI_TB+1817,  /* IS--- */  /* V39 */
		WINDOW_CloseOnEsc       = BGUI_TB+1818,  /* IS--- */  /* V39 */
		WINDOW_ActNext          = BGUI_TB+1819,  /* ----- */  /* V39 */
		WINDOW_ActPrev          = BGUI_TB+1820,  /* ----- */  /* V39 */
		WINDOW_NoVerify         = BGUI_TB+1821,  /* -S--- */  /* V39 */
		WINDOW_MenuFont         = BGUI_TB+1822,  /* IS--- */  /* V40 */
		WINDOW_ToolTicks        = BGUI_TB+1823,  /* ISG-U */  /* V40 */
		WINDOW_LBorderGroup     = BGUI_TB+1824,  /* I---- */  /* V40 */
		WINDOW_TBorderGroup     = BGUI_TB+1825,  /* I---- */  /* V40 */
		WINDOW_RBorderGroup     = BGUI_TB+1826,  /* I---- */  /* V40 */
		WINDOW_BBorderGroup     = BGUI_TB+1827,  /* I---- */  /* V40 */
		WINDOW_TitleZip         = BGUI_TB+1828,  /* I---- */  /* V40 */
		WINDOW_AutoKeyLabel     = BGUI_TB+1829,  /* I---- */  /* V41 */
		WINDOW_TitleID          = BGUI_TB+1830,  /* ISG-- */  /* V41 */
		WINDOW_ScreenTitleID    = BGUI_TB+1831,  /* ISG-- */  /* V41 */
		WINDOW_HelpTextID       = BGUI_TB+1832,  /* ISG-- */  /* V41 */
		WINDOW_Locale           = BGUI_TB+1833,  /* IS--- */  /* V41 */
		WINDOW_Catalog          = BGUI_TB+1834,  /* IS--- */  /* V41 */
		WINDOW_PreBufferRP      = BGUI_TB+1835,  /* IS--- */  /* V41.8 */

/* Possible window positions. */
		POS_CENTERSCREEN        = 0,             /* Center on the screen             */
		POS_CENTERMOUSE         = 1,             /* Center under the mouse       */
		POS_TOPLEFT             = 2,             /* Top-left of the screen       */

/* New methods */
		WM_OPEN                 = BGUI_MB+601,   /* Open the window          */
		WM_CLOSE                = BGUI_MB+602,   /* Close the window         */
		WM_SLEEP                = BGUI_MB+603,   /* Put the window to sleep      */
		WM_WAKEUP               = BGUI_MB+604,   /* Wake the window up           */
		WM_HANDLEIDCMP          = BGUI_MB+605,   /* Call the IDCMP handler       */

/* Pre-defined WM_HANDLEIDCMP return codes. */
		WMHI_CLOSEWINDOW        = $10000,        /* The close gadget was clicked     */
		WMHI_NOMORE             = $20000,        /* No more messages         */
		WMHI_INACTIVE           = $30000,        /* The window was de-activated      */
		WMHI_ACTIVE             = $40000,        /* The window was activated     */
		WMHI_MENUHELP           = $50000,        /* A menuhelp message was sent.     */
		WMHI_IGNORE             = -1,            /* Like it say's: ignore            */
		WMHI_RMB                = $1000000,      /* The object was activated by RMB */
		WMHI_MMB                = $2000000,      /* The object was activated by MMB */

		WM_GADGETKEY            = BGUI_MB+606

/* Add a hotkey to a gadget. */
OBJECT wmGadgetKey
	methodID:LONG                   /* WM_GADGETKEY          */
	requester:PTR TO requester      /* When used in a requester      */
	object:PTR TO object            /* Object to activate        */
	key:PTR TO LONG                 /* Key that triggers activ.      */
ENDOBJECT

CONST   WM_KEYACTIVE            = BGUI_MB+607,
		WM_KEYINPUT             = BGUI_MB+608

/* Send with the WM_KEYACTIVE and WM_KEYINPUT methods. */
OBJECT wmKeyInput
	methodID:LONG               /* WM_KEYACTIVE/WM_KEYINPUT        */
	gInfo:PTR TO gadgetinfo     /* GadgetInfo              */
	iEvent:PTR TO inputevent    /* Input event                     */
	id:PTR TO LONG              /* Storage for the object ID       */
	key:PTR TO CHAR             /* Key that triggered activation.  */
ENDOBJECT

/* Possible WM_KEYACTIVE and WM_KEYINPUT return codes. */
CONST   WMKF_MEACTIVE   = 0          /* Object went active.             */
SET     WMKF_CANCEL,                 /* Key activation canceled.        */
		WMKF_VERIFY,                 /* Key activation confirmed        */
		WMKF_ACTIVATE                /* ActivateGadget() object     */

CONST   WM_KEYINACTIVE          = BGUI_MB+609

/* De-activate a key session. */
OBJECT wmKeyInactive
	methodID:LONG            /* WM_KEYINACTIVE           */
	gInfo:PTR TO gadgetinfo  /* GadgetInfo               */
ENDOBJECT

CONST   WM_DISABLEMENU          = BGUI_MB+610,
		WM_CHECKITEM            = BGUI_MB+611

/* Disable/Enable a menu or Set/Clear a checkit item. */
OBJECT wmMenuAction
	methodID:LONG    /* WM_DISABLEMENU/WM_CHECKITEM      */
	menuID:LONG      /* Menu it's ID                     */
	set:LONG         /* TRUE = set, FALSE = clear        */
ENDOBJECT

CONST   WM_MENUDISABLED         = BGUI_MB+612
CONST   WM_ITEMCHECKED          = BGUI_MB+613

OBJECT wmMenuQuery
	methodID:LONG    /* WM_MENUDISABLED/WM_ITEMCHECKED   */
	menuID:LONG      /* Menu it's ID                     */
ENDOBJECT

CONST   WM_TABCYCLE_ORDER       = BGUI_MB+614

/* Set the tab-cycling order. */
OBJECT wmTabCycleOrder
	methodID:LONG    /* WM_TABCYCLE_ORDER            */
	object1:PTR TO object
ENDOBJECT

/* Obtain the app message. */
CONST   WM_GETAPPMSG            = BGUI_MB+615
CONST   WM_ADDUPDATE            = BGUI_MB+616

/* Add object to the update notification list. */
OBJECT wmAddUpdate
	methodID:LONG                /* WM_ADDUPDATE             */
	sourceID:LONG                /* ID of source object.     */
	target:PTR TO object         /* Target object.       */
	mapList:PTR TO tagitem       /* Attribute map-list.      */
ENDOBJECT

CONST   WM_REPORT_ID            = BGUI_MB+617 /* V38 */

/* Report a return code from a IDCMP/Verify hook. */
OBJECT wmReportID
	methodID:LONG                /* WM_REPORT_ID             */
	id:LONG                      /* ID to report.        */
	flags:LONG                   /* See below.           */
	sigTask:PTR TO etask         /* Task to signal.  V40 */
ENDOBJECT

/* Flags */
SET     WMRIF_DOUBLE_CLICK,  /* Simulate double-click.   */
		WMRIF_TASK           /* Task to signal valid. V40 */

/* Get the window which signalled us. */
CONST   WM_GET_SIGNAL_WINDOW    = BGUI_MB+618 /* V39 */
CONST   WM_REMOVE_OBJECT        = BGUI_MB+619 /* V40 */

/* Remove an object from the window key and/or tabcycle list. */
OBJECT wmRemoveObject
	methodID:LONG        /* WM_REMOVE_OBJECT     */
	object:PTR TO object         /* Object to remove.        */
	flags:LONG                   /* See below.           */
ENDOBJECT

/* Flags */
SET     WMROF_KEY_LIST,  /* Remove from key-list.    */
		WMROF_CYCLE_LIST /* Remove from cycle list.  */


CONST   WM_WHICHOBJECT          = BGUI_MB+620, /* V40 */

/*****************************************************************************
 *
 *  "commodityclass" - BOOPSI commodity class.
 *
 *  Tags: 1861 - 1940       Methods: 661 - 700
 */
		COMM_Name               = BGUI_TB+1861,  /* I---- */
		COMM_Title              = BGUI_TB+1862,  /* I---- */
		COMM_Description        = BGUI_TB+1863,  /* I---- */
		COMM_Unique             = BGUI_TB+1864,  /* I---- */
		COMM_Notify             = BGUI_TB+1865,  /* I---- */
		COMM_ShowHide           = BGUI_TB+1866,  /* I---- */
		COMM_Priority           = BGUI_TB+1867,  /* I---- */
		COMM_SigMask            = BGUI_TB+1868,  /* --G-- */
		COMM_ErrorCode          = BGUI_TB+1869,  /* --G-- */

/* New Methods. */
		CM_ADDHOTKEY            = BGUI_MB+661

/* Add a hot-key to the broker. */
OBJECT cmAddHotKey
	methodID:LONG           /* CM_ADDHOTKEY             */
	inputDescription:PTR TO LONG    /* Key input description.   */
	keyID:LONG                      /* Key command ID.      */
	flags:LONG                      /* See below.           */
ENDOBJECT

/* Flags. */
SET     CAHF_DISABLED       /* The key is added but won't work.         */

CONST   CM_REMHOTKEY            = BGUI_MB+662, /* Remove a key.      */
		CM_DISABLEHOTKEY        = BGUI_MB+663, /* Disable a key.     */
		CM_ENABLEHOTKEY         = BGUI_MB+664 /* Enable a key.      */

/* Do a key command. */
OBJECT cmDoKeyCommand
	methodID:LONG   /* See above.               */
	keyID:LONG      /* ID of the key.           */
ENDOBJECT

CONST   CM_ENABLEBROKER         = BGUI_MB+665, /* Enable broker.     */
		CM_DISABLEBROKER        = BGUI_MB+666, /* Disable broker.    */
		CM_MSGINFO              = BGUI_MB+667

/* Obtain info from a CxMsg. */
OBJECT cmMsgInfo
	methodID:LONG           /* CM_MSGINFO               */
	infoType:PTR TO LONG    /* Storage for CxMsgType() result.  */
	infoID:PTR TO LONG      /* Storage for CxMsgID() result.    */
	infoData:PTR TO LONG    /* Storage for CxMsgData() result.  */
ENDOBJECT

/* Possible CM_MSGINFO return codes. */
CONST   CMMI_NOMORE             = -1,   /* No more messages.            */
		CMMI_KILL               = $10000, /* Remove yourself.     V40     */
		CMMI_DISABLE            = $20000, /* You have been disabled.  V40     */
		CMMI_ENABLE             = $30000, /* You have been enabled.   V40     */
		CMMI_UNIQUE             = $40000, /* Unique violation ocured. V40     */
		CMMI_APPEAR             = $50000, /* Show yourself.       V40     */
		CMMI_DISAPPEAR          = $60000 /* Hide yourself.       V40     */

/*
 *  CM_ADDHOTKEY error codes obtainable using
 *  the COMM_ErrorCode attribute.
 */
ENUM    CMERR_OK,               /* OK. No problems.         */
		CMERR_NO_MEMORY,        /* Out of memory.           */
		CMERR_KEYID_IN_USE,     /* Key ID already used.             */
		CMERR_KEY_CREATION,     /* Key creation failure.        */
		CMERR_CXOBJERROR        /* CxObjError() reported failure.   */

/*****************************************************************************
 *
 *  "aslreqclass" - BOOPSI Asl filerequester classes (file, font, screen)
 *
 *  Tags: 1941 - 2020       Methods: 701 - 740
 */
CONST   FILEREQ_Drawer          = BGUI_TB+1941,  /* --G-- */
		FILEREQ_File            = BGUI_TB+1942,  /* --G-- */
		FILEREQ_Pattern         = BGUI_TB+1943,  /* --G-- */
		FILEREQ_Path            = BGUI_TB+1944,  /* --G-- */
		ASLREQ_Left             = BGUI_TB+1945,  /* --G-- */
		ASLREQ_Top              = BGUI_TB+1946,  /* --G-- */
		ASLREQ_Width            = BGUI_TB+1947,  /* --G-- */
		ASLREQ_Height           = BGUI_TB+1948,  /* --G-- */
		FILEREQ_MultiHook       = BGUI_TB+1949,  /* IS--- */  /* V40 */
		ASLREQ_Type             = BGUI_TB+1950,  /* I-G-- */  /* V41 */
		ASLREQ_Requester        = BGUI_TB+1951,  /* --G-- */  /* V41 */
		ASLREQ_Bounds           = BGUI_TB+1952,  /* IS--- */  /* V41.8 */

		FONTREQ_TextAttr        = BGUI_TB+1980,  /* ISG-- */  /* V41 */
		FONTREQ_Name            = BGUI_TB+1981,  /* ISG-- */  /* V41 */
		FONTREQ_Size            = BGUI_TB+1982,  /* ISG-- */  /* V41 */
		FONTREQ_Style           = BGUI_TB+1983,  /* ISG-- */  /* V41 */
		FONTREQ_Flags           = BGUI_TB+1984,  /* ISG-- */  /* V41 */
		FONTREQ_FrontPen        = BGUI_TB+1985,  /* ISG-- */  /* V41 */
		FONTREQ_BackPen         = BGUI_TB+1986,  /* ISG-- */  /* V41 */
		FONTREQ_DrawMode        = BGUI_TB+1987,  /* ISG-- */  /* V41 */

		SCREENREQ_DisplayID     = BGUI_TB+1990,  /* ISG-- */  /* V41 */
		SCREENREQ_DisplayWidth  = BGUI_TB+1991,  /* ISG-- */  /* V41 */
		SCREENREQ_DisplayHeight = BGUI_TB+1992,  /* ISG-- */  /* V41 */
		SCREENREQ_DisplayDepth  = BGUI_TB+1993,  /* ISG-- */  /* V41 */
		SCREENREQ_OverscanType  = BGUI_TB+1994,  /* ISG-- */  /* V41 */
		SCREENREQ_AutoScroll    = BGUI_TB+1995   /* ISG-- */  /* V41 */

/*
 *  In addition to the above defined attributes are all
 *  ASL filerequester attributes ISG-U.
 */

/*
 *  Error codes which the SetAttrs() and DoMethod()
 *  call's can return.
 */
ENUM    ASLREQ_OK,                 /* OK. No problems.         */
		ASLREQ_CANCEL,             /* The requester was cancelled.     */
		ASLREQ_ERROR_NO_MEM,       /* Out of memory.           */
		ASLREQ_ERROR_NO_FREQ       /* Unable to allocate a requester.  */

/* New Methods */
CONST   ASLM_DOREQUEST          = BGUI_MB+701,   /* Show Requester.  */

/*
 * The following three methods are only needed by class implementors.
 */
		ASLM_ALLOCREQUEST       = BGUI_MB+702,   /* AllocRequester() */
		ASLM_REQUEST            = BGUI_MB+703,   /* Request() */
		ASLM_FREEREQUEST        = BGUI_MB+704   /* FreeRequester() */

CONST   FRQ_Left                = ASLREQ_Left,
		FRQ_Top                 = ASLREQ_Top,
		FRQ_Width               = ASLREQ_Width,
		FRQ_Height              = ASLREQ_Height,
		FRQ_Drawer              = FILEREQ_Drawer,
		FRQ_File                = FILEREQ_File,
		FRQ_Pattern             = FILEREQ_Pattern,
		FRQ_Path                = FILEREQ_Path,
		FRQ_MultiHook           = FILEREQ_MultiHook,

		FRQ_OK                  = ASLREQ_OK,
		FRQ_CANCEL              = ASLREQ_CANCEL,
		FRQ_ERROR_NO_FREQ       = ASLREQ_ERROR_NO_FREQ,
		FRQ_ERROR_NO_MEM        = ASLREQ_ERROR_NO_MEM,
		FRM_DOREQUEST           = ASLM_DOREQUEST

/*****************************************************************************
 *
 *  "areaclass" - BOOPSI area gadget.
 *
 *  Tags: 2021 - 2100       Methods: ??
 *
 *      AREA_MinWidth and AREA_MinHeight are required attributes.
 *      Just pass the minimum area size you need here.
 */

CONST   AREA_MinWidth           = BGUI_TB+2021,    /* I---- */
		AREA_MinHeight          = BGUI_TB+2022,    /* I---- */
		AREA_AreaBox            = BGUI_TB+2023     /* --G-- */

/*****************************************************************************
 *
 *      "paletteclass" - BOOPSI palette class.
 *
 *      Tags: 2101 - 2180               Methods: 781-820
 */
CONST   PALETTE_Depth           = BGUI_TB+2101,  /* I---- */  /* V41.7 */
		PALETTE_ColorOffset     = BGUI_TB+2102,  /* I---- */  /* V41.7 */
		PALETTE_PenTable        = BGUI_TB+2103,  /* I---- */  /* V41.7 */
		PALETTE_CurrentColor    = BGUI_TB+2104,  /* ISGNU */  /* V41.7 */

/*****************************************************************************
 *
 *      "popbuttonclass" - BOOPSI popbutton class.
 *
 *      Tags: 2181 - 2260               Methods: 821-860
 */
		PMB_Image               = BGUI_TB+2181,  /* IS--- */  /* V41.7 */
		PMB_MenuEntries         = BGUI_TB+2182,  /* IS--- */  /* V41.7 */
		PMB_MenuNumber          = BGUI_TB+2183,  /* --GN- */  /* V41.7 */
		PMB_PopPosition         = BGUI_TB+2184  /* I---- */  /* V41.7 */
/*
** All labelclass attributes are usable at create time (I).
** The vectorclass attributes are usable at create time and
** with OM_SET (IS).
**/

/*
** An array of these structures define
** the menu labels.
**/
OBJECT popMenu
	label:PTR TO CHAR   /* Menu text, NULL terminates array. */
	flags:INT           /* See below. */
	mutualExclude:LONG  /* Mutual-exclusion. */
ENDOBJECT

/* Flags */
CONST   PMF_CHECKIT     = 1,         /* Checkable (toggle) item. */
		PMF_CHECKED     = 2,         /* The item is checked. */
		PMF_DISABLED    = 4          /* The item is disabled. (NMC:Added) */

/*
** Special menu entry.
**/
CONST   PMB_BARLABEL    = -1

/* New Methods */
CONST   PMBM_CHECK_STATUS               = BGUI_MB+821,
		PMBM_CHECK_MENU                 = BGUI_MB+822,
		PMBM_UNCHECK_MENU               = BGUI_MB+823,
		PMBM_ENABLE_ITEM                = BGUI_MB+824,
		PMBM_DISABLE_ITEM               = BGUI_MB+825,
		PMBM_ENABLE_STATUS              = BGUI_MB+826

OBJECT pmbmCommand
	methodID:LONG
	menuNumber:LONG  /* Menu to perform action on. */
ENDOBJECT
