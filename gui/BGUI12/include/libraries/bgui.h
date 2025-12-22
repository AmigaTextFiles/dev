#ifndef LIBRARIES_BGUI_H
#define LIBRARIES_BGUI_H
/*
**	$VER: libraries/bgui.h 39.22 (9.9.95)
**	C header for the bgui.library.
**
**	bgui.library structures and constants.
**
**	(C) Copyright 1993-1995 Jaba Development.
**	(C) Copyright 1993-1995 Jan van den Baard.
**	All Rights Reserved.
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif /* EXEC_TYPES_H */

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif /* INTUITION_CLASSES_H */

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif /* INTUITION_CLASSUSR_H */

#ifndef INTUITION_IMAGECLASS_H
#include <intuition/imageclass.h>
#endif /* INTUITION_IMAGECLASS_H */

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif /* INTUITION_GADGETCLASS_H */

#ifndef INTUITION_CGHOOKS_H
#include <intuition/cghooks.h>
#endif /* INTUITION_CGHOOKS_H */

#ifndef LIBRARIES_COMMODITIES_H
#include <libraries/commodities.h>
#endif /* LIBRARIES_COMMODITIES_H */

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif /* LIBRARIES_GADTOOLS_H */

/*****************************************************************************
 *
 *	The attribute definitions in this header are all followed by
 *	a small comment. This comment can contain the following things:
 *
 *	I	 - Attribute can be set with OM_NEW
 *	S	 - Attribute can be set with OM_SET
 *	G	 - Attribute can be read with OM_GET
 *	N	 - Setting this attribute triggers a notification.
 *	U	 - Attribute can be set with OM_UPDATE.
 *	PRIVATE! - Like it says: Private. Do not use this attribute.
 */

/*****************************************************************************
 *
 *	Miscellanious library definitions.
 */
#define BGUINAME			"bgui.library"
#define BGUIVERSION			37

/*****************************************************************************
 *
 *	BGUI_GetClassPtr() and BGUI_NewObjectA() class ID's.
 */
#define BGUI_LABEL_IMAGE		(0L)
#define BGUI_FRAME_IMAGE		(1L)
#define BGUI_VECTOR_IMAGE		(2L)
/* 3 through 10 reserved. */
#define BGUI_BASE_GADGET		(11L)
#define BGUI_GROUP_GADGET		(12L)
#define BGUI_BUTTON_GADGET		(13L)
#define BGUI_CYCLE_GADGET		(14L)
#define BGUI_CHECKBOX_GADGET		(15L)
#define BGUI_INFO_GADGET		(16L)
#define BGUI_STRING_GADGET		(17L)
#define BGUI_PROP_GADGET		(18L)
#define BGUI_INDICATOR_GADGET		(19L)

/* 20 is reserved. */

#define BGUI_PROGRESS_GADGET		(21L)
#define BGUI_SLIDER_GADGET		(22L)
#define BGUI_LISTVIEW_GADGET		(23L)
#define BGUI_MX_GADGET			(24L)
#define BGUI_PAGE_GADGET		(25L)
#define BGUI_EXTERNAL_GADGET		(26L)
#define BGUI_SEPERATOR_GADGET		(27L)

/* 27 through 39 reserved. */
#define BGUI_WINDOW_OBJECT		(40L)
#define BGUI_FILEREQ_OBJECT		(41L)
#define BGUI_COMMODITY_OBJECT		(42L)

/* Typo */
#define BGUI_SEPARATOR_GADGET		BGUI_SEPERATOR_GADGET

/*****************************************************************************
 *
 *	BGUI requester definitions.
 */
struct bguiRequest {
	ULONG		 br_Flags;		/* See below.		    */
	STRPTR		 br_Title;		/* Requester title.	    */
	STRPTR		 br_GadgetFormat;	/* Gadget labels.	    */
	STRPTR		 br_TextFormat;         /* Body text format.	    */
	UWORD		 br_ReqPos;		/* Requester position.	    */
	struct TextAttr *br_TextAttr;		/* Requester font.	    */
	UBYTE		 br_Underscore;         /* Underscore indicator.    */
	UBYTE		 br_Reserved0[ 3 ];	/* Set to 0!		    */
	struct Screen	*br_Screen;		/* Optional screen pointer. */
	ULONG		 br_Reserved1[ 4 ];	/* Set to 0!		    */
};

#define BREQF_CENTERWINDOW	(1<<0) /* Center requester on the window.   */
#define BREQF_LOCKWINDOW	(1<<1) /* Lock the parent window.	    */
#define BREQF_NO_PATTERN	(1<<2) /* Don't use back-fill pattern.      */
#define BREQF_XEN_BUTTONS	(1<<3) /* Use XEN style buttons.	    */
#define BREQF_AUTO_ASPECT	(1<<4) /* Aspect-ratio dependant look.	    */
#define BREQF_FAST_KEYS         (1<<5) /* Return/Esc hotkeys.		    */

/*****************************************************************************
 *
 *	Tag and method bases.
 */
#define BGUI_TB                         (TAG_USER+0xF0000)
#define BGUI_MB                         (0xF0000)

/*****************************************************************************
 *
 *	"frameclass" - BOOPSI framing image.
 */
#define FRM_Type			(BGUI_TB+1)	/* ISG-- */
#define FRM_CustomHook			(BGUI_TB+2)	/* ISG-- */
#define FRM_BackFillHook		(BGUI_TB+3)	/* ISG-- */
#define FRM_Title			(BGUI_TB+4)	/* ISG-- */
#define FRM_TextAttr			(BGUI_TB+5)	/* ISG-- */
#define FRM_Flags			(BGUI_TB+6)	/* ISG-- */
#define FRM_FrameWidth			(BGUI_TB+7)	/* --G-- */
#define FRM_FrameHeight                 (BGUI_TB+8)	/* --G-- */
#define FRM_BackFill			(BGUI_TB+9)	/* ISG-- */
#define FRM_EdgesOnly			(BGUI_TB+10)	/* ISG-- */
#define FRM_Recessed			(BGUI_TB+11)	/* ISG-- */
#define FRM_CenterTitle                 (BGUI_TB+12)	/* ISG-- */
#define FRM_HighlightTitle		(BGUI_TB+13)	/* ISG-- */
#define FRM_ThinFrame			(BGUI_TB+14)	/* ISG-- */
#define FRM_BackPen			(BGUI_TB+15)	/* ISG-- */  /* V39 */
#define FRM_SelectedBackPen		(BGUI_TB+16)	/* ISG-- */  /* V39 */
#define FRM_BackDriPen			(BGUI_TB+17)	/* ISG-- */  /* V39 */
#define FRM_SelectedBackDriPen		(BGUI_TB+18)	/* ISG-- */  /* V39 */

/* BGUI_TB+19 through BGUI_TB+80 reserved */

/* Back fill types */
#define STANDARD_FILL			(0L)
#define SHINE_RASTER			(1L)
#define SHADOW_RASTER			(2L)
#define SHINE_SHADOW_RASTER		(3L)
#define FILL_RASTER			(4L)
#define SHINE_FILL_RASTER		(5L)
#define SHADOW_FILL_RASTER		(6L)
#define SHINE_BLOCK			(7L)
#define SHADOW_BLOCK			(8L)

/* Flags */
#define FRF_EDGES_ONLY		(1<<0)
#define FRF_RECESSED		(1<<1)
#define FRF_CENTER_TITLE	(1<<2)
#define FRF_HIGHLIGHT_TITLE	(1<<3)
#define FRF_THIN_FRAME		(1<<4)

/* Frame types */
#define FRTYPE_CUSTOM		(0L)
#define FRTYPE_BUTTON		(1L)
#define FRTYPE_RIDGE		(2L)
#define FRTYPE_DROPBOX		(3L)
#define FRTYPE_NEXT		(4L)
#define FRTYPE_RADIOBUTTON	(5L)
#define FRTYPE_XEN_BUTTON	(6L)

/*
 *	FRM_RENDER:
 *
 *	The message packet sent to both the FRM_CustomHook
 *	and FRM_BackFillHook routines. Note that this
 *	structure is READ-ONLY!
 *
 *	The hook is called as follows:
 *
 *		rc = hookFunc( REG(A0) struct Hook	   *hook,
 *			       REG(A2) Object		   *image_object,
 *			       REG(A1) struct FrameDrawMsg *fdraw );
 */
#define FRM_RENDER		(1L) /* Render yourself           */

struct FrameDrawMsg {
	ULONG		  fdm_MethodID;   /* FRM_RENDER                   */
	struct RastPort  *fdm_RPort;	  /* RastPort ready for rendering */
	struct DrawInfo  *fdm_DrawInfo;   /* All you need to render	  */
	struct Rectangle *fdm_Bounds;	  /* Rendering bounds.		  */
	UWORD		  fdm_State;	  /* See "intuition/imageclass.h" */
};

/*
 *	FRM_THICKNESS:
 *
 *	The message packet sent to the FRM_Custom hook.
 *
 *	The hook is called as follows:
 *
 *	rc = hookFunc( REG(A0) struct Hook		*hook,
 *		       REG(A2) Object			*image_object,
 *		       REG(A1) struct ThicknessMsg	*thick );
 */
#define FRM_THICKNESS		(2L) /* Give the frame thickness. */

struct ThicknessMsg {
	ULONG		 tm_MethodID;	  /* FRM_THICKNESS		  */
	struct {
		UBYTE	*Horizontal;	  /* Storage for horizontal	  */
		UBYTE	*Vertical;	  /* Storage for vertical	  */
	}		 tm_Thickness;
	BOOL		 tm_Thin;	  /* Added in V38!		  */
};

/* Possible hook return codes. */
#define FRC_OK			(0L) /* OK	      */
#define FRC_UNKNOWN		(1L) /* Unknow method */

/*****************************************************************************
 *
 *	"labelclass" - BOOPSI labeling image.
 */
#define LAB_TextAttr			(BGUI_TB+81)	/* ISG-- */
#define LAB_Style			(BGUI_TB+82)	/* ISG-- */
#define LAB_Underscore			(BGUI_TB+83)	/* ISG-- */
#define LAB_Place			(BGUI_TB+84)	/* ISG-- */
#define LAB_Label			(BGUI_TB+85)	/* ISG-- */
#define LAB_Flags			(BGUI_TB+86)	/* ISG-- */
#define LAB_Highlight			(BGUI_TB+87)	/* ISG-- */
#define LAB_HighUScore			(BGUI_TB+88)	/* ISG-- */
#define LAB_Pen                         (BGUI_TB+89)	/* ISG-- */
#define LAB_SelectedPen                 (BGUI_TB+90)	/* ISG-- */
#define LAB_DriPen			(BGUI_TB+91)	/* ISG-- */
#define LAB_SelectedDriPen		(BGUI_TB+92)	/* ISG-- */

/* BGUI_TB+93 through BGUI_TB+160 reserved */

/* Flags */
#define LABF_HIGHLIGHT		(1<<0) /* Highlight label	 */
#define LABF_HIGH_USCORE	(1<<1) /* Highlight underscoring */

/* Label placement */
#define PLACE_IN		(0L)
#define PLACE_LEFT		(1L)
#define PLACE_RIGHT		(2L)
#define PLACE_ABOVE		(3L)
#define PLACE_BELOW		(4L)

/* New methods */
/*
 *	The IM_EXTENT method is used to find out how many
 *	pixels the label extents the releative hitbox in
 *	either direction. Normally this method is called
 *	by the baseclass.
 */
#define IM_EXTENT			(BGUI_MB+1)

struct impExtent {
	ULONG			MethodID;	/* IM_EXTENT		    */
	struct RastPort        *impe_RPort;	/* RastPort		    */
	struct IBox	       *impe_Extent;	/* Storage for extentions.  */
	struct {
		UWORD	       *Width;		/* Storage width in pixels  */
		UWORD	       *Height;         /* Storage height in pixels */
	}			impe_LabelSize;
	UWORD			impe_Flags;	/* See below.		    */
};

#define EXTF_MAXIMUM		(1<<0) /* Request maximum extensions. */

/* BGUI_MB+2 through BGUI_MB+40 reserved */

/*****************************************************************************
 *
 *	"vectorclass" - BOOPSI scalable vector image.
 *
 *	Based on an idea found in the ObjectiveGadTools.library
 *	by Davide Massarenti.
 */
#define VIT_VectorArray                 (BGUI_TB+161)	/* ISG-- */
#define VIT_BuiltIn			(BGUI_TB+162)	/* ISG-- */
#define VIT_Pen                         (BGUI_TB+163)	/* ISG-- */
#define VIT_DriPen			(BGUI_TB+164)	/* ISG-- */

/* BGUI_TB+165 through BGUI_TB+240 reserved. */

/*
 *	Command structure which can contain
 *	coordinates, data and command flags.
 */
struct VectorItem {
	WORD			vi_x;		/* X coordinate or data */
	WORD			vi_y;		/* Y coordinate         */
	ULONG			vi_Flags;	/* See below		*/
};

/* Flags */
#define VIF_MOVE		(1<<0)	/* Move to vc_x, vc_y		    */
#define VIF_DRAW		(1<<1)	/* Draw to vc_x, vc_y		    */
#define VIF_AREASTART		(1<<2)	/* Start AreaFill at vc_x, vc_y     */
#define VIF_AREAEND		(1<<3)	/* End AreaFill at vc_x, vc_y	    */
#define VIF_XRELRIGHT		(1<<4)	/* vc_x relative to right edge	    */
#define VIF_YRELBOTTOM		(1<<5)	/* vc_y relative to bottom edge     */
#define VIF_SHADOWPEN		(1<<6)	/* switch to SHADOWPEN, Move/Draw   */
#define VIF_SHINEPEN		(1<<7)	/* switch to SHINEPEN, Move/Draw    */
#define VIF_FILLPEN		(1<<8)	/* switch to FILLPEN, Move/Draw     */
#define VIF_TEXTPEN		(1<<9)	/* switch to TEXTPEN, Move/Draw     */
#define VIF_COLOR		(1<<10) /* switch to color in vc_x	    */
#define VIF_LASTITEM		(1<<11) /* last element of the element list */
#define VIF_SCALE		(1<<12) /* X & Y are design width & height  */
#define VIF_DRIPEN		(1<<13) /* switch to dripen vc_x	    */
#define VIF_AOLPEN		(1<<14) /* set area outline pen vc_x	    */
#define VIF_AOLDRIPEN		(1<<15) /* set area outline dripen vc_x     */
#define VIF_ENDOPEN		(1<<16) /* end area outline pen             */

/* Built-in images. */
#define BUILTIN_GETPATH         (1L)
#define BUILTIN_GETFILE         (2L)
#define BUILTIN_CHECKMARK	(3L)
#define BUILTIN_POPUP		(4L)
#define BUILTIN_ARROW_UP	(5L)
#define BUILTIN_ARROW_DOWN	(6L)
#define BUILTIN_ARROW_LEFT	(7L)
#define BUILTIN_ARROW_RIGHT	(8L)

/* Design width and heights of the built-in images. */
#define GETPATH_WIDTH		20
#define GETPATH_HEIGHT		14
#define GETFILE_WIDTH		20
#define GETFILE_HEIGHT		14
#define CHECKMARK_WIDTH         26
#define CHECKMARK_HEIGHT	11
#define POPUP_WIDTH		15
#define POPUP_HEIGHT		13
#define ARROW_UP_WIDTH		16
#define ARROW_UP_HEIGHT         9
#define ARROW_DOWN_WIDTH	16
#define ARROW_DOWN_HEIGHT	9
#define ARROW_LEFT_WIDTH	10
#define ARROW_LEFT_HEIGHT	12
#define ARROW_RIGHT_WIDTH	10
#define ARROW_RIGHT_HEIGHT	12

/*****************************************************************************
 *
 *	"baseclass" - BOOPSI base gadget.
 *
 *	This is a very important BGUI gadget class. All other gadget classes
 *	are sub-classed from this class. It will handle stuff like online
 *	help, notification, labels and frames etc. If you want to write a
 *	gadget class for BGUI be sure to subclass it from this class. That
 *	way your class will automatically inherit the same features.
 */
#define BT_HelpFile			(BGUI_TB+241)	/* IS--- */
#define BT_HelpNode			(BGUI_TB+242)	/* IS--- */
#define BT_HelpLine			(BGUI_TB+243)	/* IS--- */
#define BT_Inhibit			(BGUI_TB+244)	/* --G-- */
#define BT_HitBox			(BGUI_TB+245)	/* --G-- */
#define BT_LabelObject			(BGUI_TB+246)	/* -SG-- */
#define BT_FrameObject			(BGUI_TB+247)	/* -SG-- */
#define BT_TextAttr			(BGUI_TB+248)	/* ISG-- */
#define BT_NoRecessed			(BGUI_TB+249)	/* -S--- */
#define BT_LabelClick			(BGUI_TB+250)	/* IS--- */
#define BT_HelpText			(BGUI_TB+251)	/* IS--- */

/* BGUI_TB+252 through BGUI_TB+320 reserved. */

/* New methods */
#define BASE_ADDMAP			(BGUI_MB+41)

/* Add an object to the maplist notification list. */
struct bmAddMap {
	ULONG			MethodID;
	Object		       *bam_Object;
	struct TagItem	       *bam_MapList;
};

#define BASE_ADDCONDITIONAL		(BGUI_MB+42)

/* Add an object to the conditional notification list. */
struct bmAddConditional {
	ULONG			MethodID;
	Object		       *bac_Object;
	struct TagItem		bac_Condition;
	struct TagItem		bac_TRUE;
	struct TagItem		bac_FALSE;
};

#define BASE_ADDMETHOD			(BGUI_MB+43)

/* Add an object to the method notification list. */
struct bmAddMethod {
	ULONG			MethodID;
	Object		       *bam_Object;
	ULONG			bam_Flags;
	ULONG			bam_Size;
	ULONG			bam_MethodID;
};

#define BAMF_NO_GINFO		(1<<0)	/* Do not send GadgetInfo. */
#define BAMF_NO_INTERIM         (1<<1)	/* Skip interim messages.  */

#define BASE_REMMAP			(BGUI_MB+44)
#define BASE_REMCONDITIONAL		(BGUI_MB+45)
#define BASE_REMMETHOD			(BGUI_MB+46)

/* Remove an object from a notification list. */
struct bmRemove {
	ULONG			MethodID;
	Object		       *bar_Object;
};

#define BASE_SHOWHELP			(BGUI_MB+47)

/* Show attached online-help. */
struct bmShowHelp {
	ULONG			MethodID;
	struct Window	       *bsh_Window;
	struct Requester       *bsh_Requester;
	struct {
		WORD		X;
		WORD		Y;
	}			bsh_Mouse;
};

#define BMHELP_OK		(0L)	/* OK, no problems.	      */
#define BMHELP_NOT_ME		(1L)	/* Mouse not over the object. */
#define BMHELP_FAILURE		(2L)	/* Showing failed.	      */

/*
 *	The following three methods are used internally to
 *	perform infinite-loop checking. Do not use them.
 */
#define BASE_SETLOOP			(BGUI_MB+48)
#define BASE_CLEARLOOP			(BGUI_MB+49)
#define BASE_CHECKLOOP			(BGUI_MB+50)

/* PRIVATE! Hands off! */
#define BASE_LEFTEXT			(BGUI_MB+51)

struct bmLeftExt {
	ULONG			MethodID;
	struct RastPort        *bmle_RPort;
	UWORD		       *bmle_Extention;
};

#define BASE_ADDHOOK			(BGUI_MB+52)

/* Add a hook to the hook-notification list. */
struct bmAddHook {
	ULONG			MethodID;
	struct Hook	       *bah_Hook;
};

/* Remove a hook from the hook-notification list. */
#define BASE_REMHOOK			(BGUI_MB+53)

/* BGUI_MB+54 through BGUI_MB+80 reserved. */

/*****************************************************************************
 *
 *	"groupclass" - BOOPSI group gadget.
 *
 *	This class is the actual bgui.library layout engine. It will layout
 *	all members in a specific area. Two group types are available,
 *	horizontal and vertical groups.
 */
#define GROUP_Style			(BGUI_TB+321)	/* I---- */
#define GROUP_Spacing			(BGUI_TB+322)	/* I---- */
#define GROUP_HorizOffset		(BGUI_TB+323)	/* I---- */
#define GROUP_VertOffset		(BGUI_TB+324)	/* I---- */
#define GROUP_LeftOffset		(BGUI_TB+325)	/* I---- */
#define GROUP_TopOffset                 (BGUI_TB+326)	/* I---- */
#define GROUP_RightOffset		(BGUI_TB+327)	/* I---- */
#define GROUP_BottomOffset		(BGUI_TB+328)	/* I---- */
#define GROUP_Member			(BGUI_TB+329)	/* I---- */
#define GROUP_SpaceObject		(BGUI_TB+330)	/* I---- */
#define GROUP_BackFill			(BGUI_TB+331)	/* I---- */
#define GROUP_EqualWidth		(BGUI_TB+332)	/* I---- */
#define GROUP_EqualHeight		(BGUI_TB+333)	/* I---- */
#define GROUP_Inverted			(BGUI_TB+334)	/* I---- */

/* BGUI_TB+335 through BGUI_TB+380 reserved. */

/* Object layout attributes. */
#define LGO_FixWidth			(BGUI_TB+381)
#define LGO_FixHeight			(BGUI_TB+382)
#define LGO_Weight			(BGUI_TB+383)
#define LGO_FixMinWidth                 (BGUI_TB+384)
#define LGO_FixMinHeight		(BGUI_TB+385)
#define LGO_Align			(BGUI_TB+386)
#define LGO_NoAlign			(BGUI_TB+387)		     /* V38 */

/* BGUI_TB+388 through BGUI_TB+400 reserved. */

/* Default object weight. */
#define DEFAULT_WEIGHT			(50L)

/* Group styles. */
#define GRSTYLE_HORIZONTAL		(0L)
#define GRSTYLE_VERTICAL		(1L)

/* New methods. */
#define GRM_ADDMEMBER			(BGUI_MB+81)

/* Add a member to the group. */
struct grmAddMember {
	ULONG			MethodID;	/* GRM_ADDMEMBER	    */
	Object		       *grma_Member;	/* Object to add.	    */
	ULONG			grma_Attr;	/* First of LGO attributes. */
};

#define GRM_REMMEMBER			(BGUI_MB+82)

/* Remove a member from the group. */
struct grmRemMember {
	ULONG			MethodID;	/* GRM_REMMEMBER	    */
	Object		       *grmr_Member;	/* Object to remove.	    */
};

#define GRM_DIMENSIONS			(BGUI_MB+83)

/* Ask an object it's dimensions information. */
struct grmDimensions {
	ULONG			MethodID;	/* GRM_DIMENSIONS	    */
	struct GadgetInfo      *grmd_GInfo;	/* Can be NULL!             */
	struct RastPort        *grmd_RPort;	/* Ready for calculations.  */
	struct {
		UWORD	       *Width;
		UWORD	       *Height;
	}			grmd_MinSize;	/* Storage for dimensions.  */
	ULONG			grmd_Flags;	/* See below.		    */
};

/* Flags */
#define GDIMF_NO_FRAME		(1<<0)	/* Don't take frame width/height
					   into consideration.		    */

#define GRM_ADDSPACEMEMBER		(BGUI_MB+84)

/* Add a weight controlled spacing member. */
struct grmAddSpaceMember {
	ULONG			MethodID;	/* GRM_ADDSPACEMEMBER	    */
	ULONG			grms_Weight;	/* Object weight.	    */
};

#define GRM_INSERTMEMBER		(BGUI_MB+85)

/* Insert a member in the group. */
struct grmInsertMember {
	ULONG			MethodID;	/* GRM_INSERTMEMBER	    */
	Object		       *grmi_Member;	/* Member to insert.	    */
	Object		       *grmi_Pred;	/* Insert after this member */
	ULONG			grmi_Attr;	/* First of LGO attributes. */
};

/* BGUI_MB+86 through BGUI_MB+120 reserved. */

/*****************************************************************************
 *
 *	"buttonclass" - BOOPSI button gadget.
 *
 *	GadTools style button gadget.
 *
 *	GA_Selected has been made gettable (OM_GET) for toggle-select
 *	buttons. (ISGNU)
 */
#define BUTTON_ScaleMinWidth		(BGUI_TB+401)	/* PRIVATE! */
#define BUTTON_ScaleMinHeight		(BGUI_TB+402)	/* PRIVATE! */
#define BUTTON_Image			(BGUI_TB+403)	/* IS--U */
#define BUTTON_SelectedImage		(BGUI_TB+404)	/* IS--U */
#define BUTTON_EncloseImage		(BGUI_TB+405)	/* I---- */  /* V39 */

/* BGUI_TB+406 through BGUI_TB+480 reserved. */
/* BGUI_MB+121 through BGUI_MB+160 reserved. */

/*****************************************************************************
 *
 *	"checkboxclass" - BOOPSI checkbox gadget.
 *
 *	GadTools style checkbox gadget.
 *
 *	GA_Selected has been made gettable (OM_GET). (ISGNU)
 */

/* BGUI_TB+481 through BGUI_TB+560 reserved. */
/* BGUI_MB+161 through BGUI_MB+200 reserved. */

/*****************************************************************************
 *
 *	"cycleclass" - BOOPSI cycle gadget.
 *
 *	GadTools style cycle gadget.
 */
#define CYC_Labels			(BGUI_TB+561)	/* I---- */
#define CYC_Active			(BGUI_TB+562)	/* ISGNU */
#define CYC_Popup			(BGUI_TB+563)	/* I---- */

/* BGUI_TB+564 through BGUI_TB+640 reserved. */
/* BGUI_MB+201 through BGUI_MB+240 reserved. */

/*****************************************************************************
 *
 *	"infoclass" - BOOPSI information gadget.
 *
 *	Text gadget which supports different colors, text styles and
 *	text positioning.
 */
#define INFO_TextFormat                 (BGUI_TB+641)	/* IS--U */
#define INFO_Args			(BGUI_TB+642)	/* IS--U */
#define INFO_MinLines			(BGUI_TB+643)	/* I---- */
#define INFO_FixTextWidth		(BGUI_TB+644)	/* I---- */
#define INFO_HorizOffset		(BGUI_TB+645)	/* I---- */
#define INFO_VertOffset                 (BGUI_TB+646)	/* I---- */

/* Command sequences. */
#define ISEQ_B				"\33b"  /* Bold          */
#define ISEQ_I				"\33i"  /* Italics       */
#define ISEQ_U				"\33u"  /* Underlined    */
#define ISEQ_N				"\33n"  /* Normal        */
#define ISEQ_C				"\33c"  /* Centered      */
#define ISEQ_R				"\33r"  /* Right         */
#define ISEQ_L				"\33l"  /* Left          */
#define ISEQ_TEXT			"\33d2" /* TEXTPEN       */
#define ISEQ_SHINE			"\33d3" /* SHINEPEN      */
#define ISEQ_SHADOW			"\33d4" /* SHADOWPEN     */
#define ISEQ_FILL			"\33d5" /* FILLPEN       */
#define ISEQ_FILLTEXT			"\33d6" /* FILLTEXTPEN   */
#define ISEQ_HIGHLIGHT			"\33d8" /* HIGHLIGHTPEN  */

/* BGUI_TB+645 through BGUI_TB+720 reserved. */
/* BGUI_MB+241 through BGUI_MB+280 reserved. */

/*****************************************************************************
 *
 *	"listviewclass" - BOOPSI listview gadget.
 *
 *	GadTools style listview gadget.
 */
#define LISTV_ResourceHook		(BGUI_TB+721)	/* I---- */
#define LISTV_DisplayHook		(BGUI_TB+722)	/* I---- */
#define LISTV_CompareHook		(BGUI_TB+723)	/* I---- */
#define LISTV_Top			(BGUI_TB+724)	/* ISG-U */
#define LISTV_ListFont			(BGUI_TB+725)	/* I-G-- */
#define LISTV_ReadOnly			(BGUI_TB+726)	/* I---- */
#define LISTV_MultiSelect		(BGUI_TB+727)	/* IS--U */
#define LISTV_EntryArray		(BGUI_TB+728)	/* I---- */
#define LISTV_Select			(BGUI_TB+729)	/* -S--U */
#define LISTV_MakeVisible		(BGUI_TB+730)	/* -S--U */
#define LISTV_Entry			(BGUI_TB+731)	/* ---N- */
#define LISTV_SortEntryArray		(BGUI_TB+732)	/* I---- */
#define LISTV_EntryNumber		(BGUI_TB+733)	/* ---N- */
#define LISTV_TitleHook                 (BGUI_TB+734)	/* I---- */
#define LISTV_LastClicked		(BGUI_TB+735)	/* --G-- */
#define LISTV_ThinFrames		(BGUI_TB+736)	/* I---- */
#define LISTV_LastClickedNum		(BGUI_TB+737)	/* --G-- */  /* V38 */
#define LISTV_NewPosition		(BGUI_TB+738)	/* ---N- */  /* V38 */
#define LISTV_NumEntries		(BGUI_TB+739)	/* --G-- */  /* V38 */
#define LISTV_MinEntriesShown		(BGUI_TB+740)	/* I---- */  /* V38 */
#define LISTV_SelectMulti		(BGUI_TB+741)	/* -S--U */  /* V39 */
#define LISTV_SelectNotVisible		(BGUI_TB+742)	/* -S--U */  /* V39 */
#define LISTV_SelectMultiNotVisible	(BGUI_TB+743)	/* -S--U */  /* V39 */
#define LISTV_MultiSelectNoShift	(BGUI_TB+744)	/* IS--U */  /* V39 */
#define LISTV_DeSelect			(BGUI_TB+745)	/* -S--U */  /* V39 */

/* BGUI_TB+746 through BGUI_TB+800 reserved. */

/*
**	LISTV_Select magic numbers.
**/
#define LISTV_Select_First		(-1L)			     /* V38 */
#define LISTV_Select_Last		(-2L)			     /* V38 */
#define LISTV_Select_Next		(-3L)			     /* V38 */
#define LISTV_Select_Previous		(-4L)			     /* V38 */
#define LISTV_Select_Top		(-5L)			     /* V38 */
#define LISTV_Select_Page_Up		(-6L)			     /* V38 */
#define LISTV_Select_Page_Down		(-7L)			     /* V38 */
#define LISTV_Select_All		(-8L)			     /* V39 */

/*
 *	The LISTV_ResourceHook is called as follows:
 *
 *	rc = hookFunc( REG(A0) struct Hook		*hook,
 *		       REG(A2) Object			*lv_object,
 *		       REG(A1) struct lvResource	*message );
 */
struct lvResource {
	UWORD			lvr_Command;
	APTR			lvr_Entry;
};

/* LISTV_ResourceHook commands. */
#define LVRC_MAKE		1	/* Build the entry. */
#define LVRC_KILL		2	/* Kill the entry.  */

/*
 *	The LISTV_DisplayHook and the LISTV_TitleHook are called as follows:
 *
 *	rc = hookFunc( REG(A0) struct Hook	       *hook,
 *		       REG(A2) Object		       *lv_object,
 *		       REG(A1) struct lvRender	       *message );
 */
struct lvRender {
	struct RastPort        *lvr_RPort;	/* RastPort to render in.  */
	struct DrawInfo        *lvr_DrawInfo;	/* All you need to render. */
	struct Rectangle	lvr_Bounds;	/* Bounds to render in.    */
	APTR			lvr_Entry;	/* Entry to render.	   */
	UWORD			lvr_State;	/* See below.		   */
	UWORD			lvr_Flags;	/* None defined yet.	   */
};

/* Rendering states. */
#define LVRS_NORMAL		0
#define LVRS_SELECTED		1
#define LVRS_NORMAL_DISABLED	2
#define LVRS_SELECTED_DISABLED	3

/*
 *	The LISTV_CompareHook is called as follows:
 *
 *	rc = hookFunc( REG(A0) struct Hook		*hook,
 *		       REG(A2) Object			*lv_object,
 *		       REG(A1) struct lvCompare         *message );
 */
struct lvCompare {
	APTR			lvc_EntryA;	/* First entry.  */
	APTR			lvc_EntryB;	/* Second entry. */
};

/* New Methods. */
#define LVM_ADDENTRIES			(BGUI_MB+281)

/* Add listview entries. */
struct lvmAddEntries {
	ULONG			MethodID;	/* LVM_ADDENTRIES  */
	struct GadgetInfo      *lvma_GInfo;	/* GadgetInfo	   */
	APTR		       *lvma_Entries;	/* Entries to add. */
	ULONG			lvma_How;	/* How to add it.  */
};

/* Where to add the entries. */
#define LVAP_HEAD		1
#define LVAP_TAIL		2
#define LVAP_SORTED		3

#define LVM_ADDSINGLE			(BGUI_MB+282)

/* Add a single entry. */
struct lvmAddSingle {
	ULONG			MethodID;	/* LVM_ADDSINGLE */
	struct GadgetInfo      *lvma_GInfo;	/* GadgetInfo	 */
	APTR			lvma_Entry;	/* Entry to add. */
	ULONG			lvma_How;	/* See above.	 */
	ULONG			lvma_Flags;	/* See below.	 */
};

/* Flags. */
#define LVASF_MAKEVISIBLE	(1<<0)	/* Make entry visible. */
#define LVASF_SELECT		(1<<1)	/* Select entry.       */

/* Clear the entire list. ( Uses a lvmCommand structure as defined below.) */
#define LVM_CLEAR			(BGUI_MB+283)

#define LVM_FIRSTENTRY			(BGUI_MB+284)
#define LVM_LASTENTRY			(BGUI_MB+285)
#define LVM_NEXTENTRY			(BGUI_MB+286)
#define LVM_PREVENTRY			(BGUI_MB+287)

/* Get an entry. */
struct lvmGetEntry {
	ULONG			MethodID;	/* Any of the above. */
	APTR			lvmg_Previous;	/* Previous entry.   */
	ULONG			lvmg_Flags;	/* See below.	     */
};

#define LVGEF_SELECTED		(1<<0)	/* Get selected entries. */

#define LVM_REMENTRY			(BGUI_MB+288)

/* Remove an entry. */
struct lvmRemEntry {
	ULONG			MethodID;	/* LVM_REMENTRY      */
	struct GadgetInfo      *lvmr_GInfo;	/* GadgetInfo	     */
	APTR			lvmr_Entry;	/* Entry to remove.  */
};

#define LVM_REFRESH			(BGUI_MB+289)
#define LVM_SORT			(BGUI_MB+290)
#define LVM_LOCKLIST			(BGUI_MB+291)
#define LVM_UNLOCKLIST			(BGUI_MB+292)

/* Refresh/Sort list. */
struct lvmCommand {
	ULONG			MethodID;	/* LVM_REFRESH	     */
	struct GadgetInfo      *lvmc_GInfo;	/* GadgetInfo	     */
};

#define LVM_MOVE			(BGUI_MB+293) /* V38 */

/* Move an entry in the list. */
struct lvmMove {
	ULONG			MethodID;	/* LVM_MOVE	     */
	struct GadgetInfo      *lvmm_GInfo;	/* GadgetInfo	     */
	APTR			lvmm_Entry;	/* Entry to move     */
	ULONG			lvmm_Direction; /* See below	     */
};

/* Move directions. */
#define LVMOVE_UP		0	/* Move entry up.	     */
#define LVMOVE_DOWN		1	/* Move entry down.	     */
#define LVMOVE_TOP		2	/* Move entry to the top.    */
#define LVMOVE_BOTTOM		3	/* Move entry to the bottom. */

#define LVM_REPLACE			(BGUI_MB+294) /* V39 */

/* Replace an entry by another. */
struct lvmReplace {
	ULONG			MethodID;	/* LVM_REPLACE	     */
	struct GadgetInfo      *lvmr_GInfo;	/* GadgetInfo	     */
	APTR			lvmr_OldEntry;	/* Entry to replace. */
	APTR			lvmr_NewEntry;	/* New entry.	     */
};

/* BGUI_MB+295 through BGUI_MB+320 reserved. */

/*****************************************************************************
 *
 *	"progressclass" - BOOPSI progression gadget.
 *
 *	Progression indicator fuel guage.
 */
#define PROGRESS_Min			(BGUI_TB+801)	/* IS--- */
#define PROGRESS_Max			(BGUI_TB+802)	/* IS--- */
#define PROGRESS_Done			(BGUI_TB+803)	/* ISGNU */
#define PROGRESS_Vertical		(BGUI_TB+804)	/* I---- */
#define PROGRESS_Divisor		(BGUI_TB+805)	/* I---- */

/* BGUI_TB+806 through BGUI_TB+880 reserved. */
/* BGUI_MB+321 through BGUI_MB+360 reserved. */

/*****************************************************************************
 *
 *	"propclass" - BOOPSI proportional gadget.
 *
 *	GadTools style scroller gadget.
 */
#define PGA_Arrows			(BGUI_TB+881)	/* I---- */
#define PGA_ArrowSize			(BGUI_TB+882)	/* I---- */
#define PGA_DontTarget			(BGUI_TB+883)	/* PRIVATE! */
#define PGA_ThinFrame			(BGUI_TB+884)	/* I---- */
#define PGA_XenFrame			(BGUI_TB+885)	/* I---- */

/* BGUI_TB+886 through BGUI_TB+960 reserved. */
/* BGUI_MB+361 through BGUI_MB+400 reserved. */

/*****************************************************************************
 *
 *	"stringclass" - BOOPSI string gadget.
 *
 *	GadTools style string/integer gadget.
 */
#define STRINGA_Tabbed			(BGUI_TB+961)	/* PRIVATE! */
#define STRINGA_ShiftTabbed		(BGUI_TB+962)	/* PRIVATE! */
#define STRINGA_MinCharsVisible         (BGUI_TB+963)	/* I---- */  /* V39 */
#define STRINGA_IntegerMin		(BGUI_TB+964)	/* IS--U */  /* V39 */
#define STRINGA_IntegerMax		(BGUI_TB+965)	/* IS--U */  /* V39 */

#define SM_FORMAT_STRING		(BGUI_MB+401)	/* V39 */

/* Format the string contents. */
struct smFormatString {
	ULONG		   MethodID;	/* SM_FORMAT_STRING    */
	struct GadgetInfo *smfs_GInfo;	/* GadgetInfo	       */
	UBYTE		  *smfs_FStr;	/* Format string       */
	ULONG		   smfs_Arg1;	/* Format arg	       */
	/* ULONG	   smfs_Arg2; */
	/* ... */
};

/* BGUI_TB+966 through BGUI_TB+1040 reserved. */
/* BGUI_MB+402 through BGUI_MB+440 reserved. */

/*****************************************************************************
 *
 *	RESERVED.
 */

/* BGUI_TB+1041 through BGUI_TB+1120 reserved. */
/* BGUI_MB+441 through BGUI_MB+480 reserved. */

/*****************************************************************************
 *
 *	"pageclass" - BOOPSI paging gadget.
 *
 *	Gadget to handle pages of gadgets.
 */
#define PAGE_Active			(BGUI_TB+1121)	/* ISGNU */
#define PAGE_Member			(BGUI_TB+1122)	/* I---- */
#define PAGE_NoBufferRP                 (BGUI_TB+1123)	/* I---- */
#define PAGE_Inverted			(BGUI_TB+1124)	/* I---- */

/* BGUI_TB+1125 through BGUI_TB+1200 reserved. */
/* BGUI_MB+481 through BGUI_MB+520 reserved. */

/*****************************************************************************
 *
 *	"mxclass" - BOOPSI mx gadget.
 *
 *	GadTools style mx gadget.
 */
#define MX_Labels			(BGUI_TB+1201)	/* I---- */
#define MX_Active			(BGUI_TB+1202)	/* ISGNU */
#define MX_LabelPlace			(BGUI_TB+1203)	/* I---- */
#define MX_DisableButton		(BGUI_TB+1204)	/* IS--U */
#define MX_EnableButton                 (BGUI_TB+1205)	/* IS--U */
#define MX_TabsObject			(BGUI_TB+1206)	/* I---- */
#define MX_TabsTextAttr                 (BGUI_TB+1207)	/* I---- */

/* BGUI_TB+1208 through BGUI_TB+1280 reserved. */
/* BGUI_MB+521 through BGUI_MB+560 reserved. */

/*****************************************************************************
 *
 *	"sliderclass" - BOOPSI slider gadget.
 *
 *	GadTools style slider gadget.
 */
#define SLIDER_Min				(BGUI_TB+1281)	/* IS--U */
#define SLIDER_Max				(BGUI_TB+1282)	/* IS--U */
#define SLIDER_Level				(BGUI_TB+1283)	/* ISGNU */
#define SLIDER_ThinFrame			(BGUI_TB+1284)	/* I---- */
#define SLIDER_XenFrame                         (BGUI_TB+1285)	/* I---- */

/* BGUI_TB+1286 through BGUI_TB+1360 reserved. */
/* BGUI_MB+561 through BGUI_MB+600 reserved. */

/*****************************************************************************
 *
 *	"indicatorclass" - BOOPSI indicator gadget.
 *
 *	Textual level indicator gadget.
 */
#define INDIC_Min			(BGUI_TB+1361)	/* I---- */
#define INDIC_Max			(BGUI_TB+1362)	/* I---- */
#define INDIC_Level			(BGUI_TB+1363)	/* IS--U */
#define INDIC_FormatString		(BGUI_TB+1364)	/* I---- */
#define INDIC_Justification		(BGUI_TB+1365)	/* I---- */

/* Justification */
#define IDJ_LEFT		(0L)
#define IDJ_CENTER		(1L)
#define IDJ_RIGHT		(2L)

/* BGUI_TB+1366 through BGUI_TB+1440 reserved. */

/*****************************************************************************
 *
 *	"externalclass" - BGUI external class interface.
 */
#define EXT_Class			(BGUI_TB+1441)	/* I---- */
#define EXT_ClassID			(BGUI_TB+1442)	/* I---- */
#define EXT_MinWidth			(BGUI_TB+1443)	/* I---- */
#define EXT_MinHeight			(BGUI_TB+1444)	/* I---- */
#define EXT_TrackAttr			(BGUI_TB+1445)	/* I---- */
#define EXT_Object			(BGUI_TB+1446)	/* --G-- */
#define EXT_NoRebuild			(BGUI_TB+1447)	/* I---- */

/* BGUI_TB+1448 through BGUI_TB+1500 reserved. */

/*****************************************************************************
 *
 *	"separatorclass" - BOOPSI separator class.
 */
#define SEP_Horiz			(BGUI_TB+1501)	/* I---- */
#define SEP_Title			(BGUI_TB+1502)	/* I---- */
#define SEP_Thin			(BGUI_TB+1503)	/* I---- */
#define SEP_Highlight			(BGUI_TB+1504)	/* I---- */
#define SEP_CenterTitle                 (BGUI_TB+1505)	/* I---- */
#define SEP_Recessed			(BGUI_TB+1506)	/* I---- */  /* V39 */

/* BGUI_TB+1507 through BGUI_TB+1760 reserved. */

/*****************************************************************************
 *
 *	"windowclass" - BOOPSI window class.
 *
 *	This class creates and maintains an intuition window.
 */
#define WINDOW_Position                 (BGUI_TB+1761)	/* I---- */
#define WINDOW_ScaleWidth		(BGUI_TB+1762)	/* I---- */
#define WINDOW_ScaleHeight		(BGUI_TB+1763)	/* I---- */
#define WINDOW_LockWidth		(BGUI_TB+1764)	/* I---- */
#define WINDOW_LockHeight		(BGUI_TB+1765)	/* I---- */
#define WINDOW_PosRelBox		(BGUI_TB+1766)	/* I---- */
#define WINDOW_Bounds			(BGUI_TB+1767)	/* ISG-- */
/* BGUI_TB+1768 through BGUI_TB+1670 reserved. */
#define WINDOW_DragBar			(BGUI_TB+1771)	/* I---- */
#define WINDOW_SizeGadget		(BGUI_TB+1772)	/* I---- */
#define WINDOW_CloseGadget		(BGUI_TB+1773)	/* I---- */
#define WINDOW_DepthGadget		(BGUI_TB+1774)	/* I---- */
#define WINDOW_SizeBottom		(BGUI_TB+1775)	/* I---- */
#define WINDOW_SizeRight		(BGUI_TB+1776)	/* I---- */
#define WINDOW_Activate                 (BGUI_TB+1777)	/* I---- */
#define WINDOW_RMBTrap			(BGUI_TB+1778)	/* I---- */
#define WINDOW_SmartRefresh		(BGUI_TB+1779)	/* I---- */
#define WINDOW_ReportMouse		(BGUI_TB+1780)	/* I---- */
#define WINDOW_Borderless		(BGUI_TB+1781)	/* I---- */  /* V39 */
#define WINDOW_Backdrop                 (BGUI_TB+1782)	/* I---- */  /* V39 */
#define WINDOW_ShowTitle		(BGUI_TB+1783)	/* I---- */  /* V39 */
/* BGUI_TB+1784 through BGUI_TB+1790 reserved. */
#define WINDOW_IDCMP			(BGUI_TB+1791)	/* I---- */
#define WINDOW_SharedPort		(BGUI_TB+1792)	/* I---- */
#define WINDOW_Title			(BGUI_TB+1793)	/* IS--U */
#define WINDOW_ScreenTitle		(BGUI_TB+1794)	/* IS--U */
#define WINDOW_MenuStrip		(BGUI_TB+1795)	/* I-G-- */
#define WINDOW_MasterGroup		(BGUI_TB+1796)	/* I---- */
#define WINDOW_Screen			(BGUI_TB+1797)	/* IS--- */
#define WINDOW_PubScreenName		(BGUI_TB+1798)	/* IS--- */
#define WINDOW_UserPort                 (BGUI_TB+1799)	/* --G-- */
#define WINDOW_SigMask			(BGUI_TB+1800)	/* --G-- */
#define WINDOW_IDCMPHook		(BGUI_TB+1801)	/* I---- */
#define WINDOW_VerifyHook		(BGUI_TB+1802)	/* I---- */
#define WINDOW_IDCMPHookBits		(BGUI_TB+1803)	/* I---- */
#define WINDOW_VerifyHookBits		(BGUI_TB+1804)	/* I---- */
#define WINDOW_Font			(BGUI_TB+1805)	/* I---- */
#define WINDOW_FallBackFont		(BGUI_TB+1806)	/* I---- */
#define WINDOW_HelpFile                 (BGUI_TB+1807)	/* IS--- */
#define WINDOW_HelpNode                 (BGUI_TB+1808)	/* IS--- */
#define WINDOW_HelpLine                 (BGUI_TB+1809)	/* IS--- */
#define WINDOW_AppWindow		(BGUI_TB+1810)	/* I---- */
#define WINDOW_AppMask			(BGUI_TB+1811)	/* --G-- */
#define WINDOW_UniqueID                 (BGUI_TB+1812)	/* I---- */
#define WINDOW_Window			(BGUI_TB+1813)	/* --G-- */
#define WINDOW_HelpText                 (BGUI_TB+1814)	/* IS--- */
#define WINDOW_NoBufferRP		(BGUI_TB+1815)	/* I---- */
#define WINDOW_AutoAspect		(BGUI_TB+1816)	/* I---- */
#define WINDOW_PubScreen		(BGUI_TB+1817)	/* IS--- */  /* V39 */
#define WINDOW_CloseOnEsc		(BGUI_TB+1818)	/* IS--- */  /* V39 */
#define WINDOW_ActNext			(BGUI_TB+1819)	/* ----- */  /* V39 */
#define WINDOW_ActPrev			(BGUI_TB+1820)	/* ----- */  /* V39 */
#define WINDOW_NoVerify                 (BGUI_TB+1821)	/* -S--- */  /* V39 */

/* BGUI_TB+1822 through BGUI_TB+1860 reserved. */

/* Possible window positions. */
#define POS_CENTERSCREEN	(0L)	/* Center on the screen             */
#define POS_CENTERMOUSE         (1L)	/* Center under the mouse	    */
#define POS_TOPLEFT		(2L)	/* Top-left of the screen	    */

/* New methods */

#define WM_OPEN         (BGUI_MB+601)	/* Open the window		    */
#define WM_CLOSE	(BGUI_MB+602)	/* Close the window		    */
#define WM_SLEEP	(BGUI_MB+603)	/* Put the window to sleep	    */
#define WM_WAKEUP	(BGUI_MB+604)	/* Wake the window up		    */
#define WM_HANDLEIDCMP	(BGUI_MB+605)	/* Call the IDCMP handler	    */

/* Pre-defined WM_HANDLEIDCMP return codes. */
#define WMHI_CLOSEWINDOW	(1<<16) /* The close gadget was clicked     */
#define WMHI_NOMORE		(2<<16) /* No more messages		    */
#define WMHI_INACTIVE		(3<<16) /* The window was de-activated	    */
#define WMHI_ACTIVE		(4<<16) /* The window was activated	    */
#define WMHI_IGNORE		(~0L)	/* Like it say's: ignore            */

#define WM_GADGETKEY			(BGUI_MB+606)

/* Add a hotkey to a gadget. */
struct wmGadgetKey {
	ULONG		   MethodID;	   /* WM_GADGETKEY		    */
	struct Requester  *wmgk_Requester; /* When used in a requester	    */
	Object		  *wmgk_Object;    /* Object to activate	    */
	STRPTR		   wmgk_Key;	   /* Key that triggers activ.	    */
};

#define WM_KEYACTIVE			(BGUI_MB+607)
#define WM_KEYINPUT			(BGUI_MB+608)

/* Send with the WM_KEYACTIVE and WM_KEYINPUT methods. */
struct wmKeyInput {
	ULONG		   MethodID;	 /* WM_KEYACTIVE/WM_KEYINPUT	    */
	struct GadgetInfo *wmki_GInfo;	 /* GadgetInfo			    */
	struct InputEvent *wmki_IEvent;  /* Input event                     */
	ULONG		  *wmki_ID;	 /* Storage for the object ID	    */
	STRPTR		   wmki_Key;	 /* Key that triggered activation.  */
};

/* Possible WM_KEYACTIVE and WM_KEYINPUT return codes. */
#define WMKF_MEACTIVE		(0L)	 /* Object went active.             */
#define WMKF_CANCEL		(1<<0)	 /* Key activation canceled.	    */
#define WMKF_VERIFY		(1<<1)	 /* Key activation confirmed	    */
#define WMKF_ACTIVATE		(1<<2)	 /* ActivateGadget() object	    */

#define WM_KEYINACTIVE			(BGUI_MB+609)

/* De-activate a key session. */
struct wmKeyInActive {
	ULONG		   MethodID;	/* WM_KEYINACTIVE		    */
	struct GadgetInfo *wmkia_GInfo; /* GadgetInfo			    */
};

#define WM_DISABLEMENU			(BGUI_MB+610)
#define WM_CHECKITEM			(BGUI_MB+611)

/* Disable/Enable a menu or Set/Clear a checkit item. */
struct wmMenuAction {
	ULONG		   MethodID;	/* WM_DISABLEMENU/WM_CHECKITEM	    */
	ULONG		   wmma_MenuID; /* Menu it's ID                     */
	ULONG		   wmma_Set;	/* TRUE = set, FALSE = clear	    */
};

#define WM_MENUDISABLED                 (BGUI_MB+612)
#define WM_ITEMCHECKED			(BGUI_MB+613)

struct wmMenuQuery {
	ULONG		   MethodID;	/* WM_MENUDISABLED/WM_ITEMCHECKED   */
	ULONG		   wmmq_MenuID; /* Menu it's ID                     */
};

#define WM_TABCYCLE_ORDER		(BGUI_MB+614)

/* Set the tab-cycling order. */
struct wmTabCycleOrder {
	ULONG		   MethodID;	/* WM_TABCYCLE_ORDER		    */
	Object		  *wtco_Object1;
	/* Object	  *wtco_Object2; */
	/* ...	*/
	/* NULL */
};

/* Obtain the app message. */
#define WM_GETAPPMSG			(BGUI_MB+615)

#define WM_ADDUPDATE			(BGUI_MB+616)

/* Add object to the update notification list. */
struct wmAddUpdate {
	ULONG		   MethodID;		/* WM_ADDUPDATE             */
	ULONG		   wmau_SourceID;	/* ID of source object.     */
	Object		  *wmau_Target;         /* Target object.	    */
	struct TagItem	  *wmau_MapList;	/* Attribute map-list.	    */
};

#define WM_REPORT_ID			(BGUI_MB+617) /* V38 */

/* Report a return code from a IDCMP/Verify hook. */
struct wmReportID {
	ULONG		   MethodID;		/* WM_REPORT_ID             */
	ULONG		   wmri_ID;		/* ID to report.	    */
	ULONG		   wmri_Flags;		/* See below.		    */
};

/* Flags */
#define WMRIF_DOUBLE_CLICK	(1<<0)		/* Simulate double-click.   */

/* Get the window which signalled us. */
#define WM_GET_SIGNAL_WINDOW		(BGUI_MB+618) /* V39 */

/* BGUI_MB+619 through BGUI_MB+660 reserved. */

/*****************************************************************************
 *
 *	"commodityclass" - BOOPSI commodity class.
 */
#define COMM_Name			(BGUI_TB+1861)	/* I---- */
#define COMM_Title			(BGUI_TB+1862)	/* I---- */
#define COMM_Description		(BGUI_TB+1863)	/* I---- */
#define COMM_Unique			(BGUI_TB+1864)	/* I---- */
#define COMM_Notify			(BGUI_TB+1865)	/* I---- */
#define COMM_ShowHide			(BGUI_TB+1866)	/* I---- */
#define COMM_Priority			(BGUI_TB+1867)	/* I---- */
#define COMM_SigMask			(BGUI_TB+1868)	/* --G-- */
#define COMM_ErrorCode			(BGUI_TB+1869)	/* --G-- */

/* BGUI_TB+1870 through BGUI_TB+1940 reserved. */

/* New Methods. */

#define CM_ADDHOTKEY			(BGUI_MB+661)

/* Add a hot-key to the broker. */
struct cmAddHotkey {
	ULONG		MethodID;		/* CM_ADDHOTKEY             */
	STRPTR		cah_InputDescription;	/* Key input description.   */
	ULONG		cah_KeyID;		/* Key command ID.	    */
	ULONG		cah_Flags;		/* See below.		    */
};

/* Flags. */
#define CAHF_DISABLED	(1<<0)	/* The key is added but won't work.         */

#define CM_REMHOTKEY			(BGUI_MB+662) /* Remove a key.	    */
#define CM_DISABLEHOTKEY		(BGUI_MB+663) /* Disable a key.     */
#define CM_ENABLEHOTKEY                 (BGUI_MB+664) /* Enable a key.	    */

/* Do a key command. */
struct cmDoKeyCommand {
	ULONG		MethodID;	/* See above.			    */
	ULONG		cdkc_KeyID;	/* ID of the key.		    */
};

#define CM_ENABLEBROKER                 (BGUI_MB+665) /* Enable broker.     */
#define CM_DISABLEBROKER		(BGUI_MB+666) /* Disable broker.    */

#define CM_MSGINFO			(BGUI_MB+667)

/* Obtain info from a CxMsg. */
struct cmMsgInfo {
	ULONG		MethodID;	/* CM_MSGINFO			    */
	struct {
		ULONG  *Type;		/* Storage for CxMsgType() result.  */
		ULONG  *ID;		/* Storage for CxMsgID() result.    */
		ULONG  *Data;		/* Storage for CxMsgData() result.  */
	}		cmi_Info;
};

/* Possible CM_MSGINFO return codes. */
#define CMMI_NOMORE		(~0L)	/* No more messages.		    */

/* BGUI_MB+668 through BGUI_MB+700 reserved. */

/*
 *	CM_ADDHOTKEY error codes obtainable using
 *	the COMM_ErrorCode attribute.
 */
#define CMERR_OK		(0L)	/* OK. No problems.		    */
#define CMERR_NO_MEMORY         (1L)	/* Out of memory.		    */
#define CMERR_KEYID_IN_USE	(2L)	/* Key ID already used.             */
#define CMERR_KEY_CREATION	(3L)	/* Key creation failure.	    */
#define CMERR_CXOBJERROR	(4L)	/* CxObjError() reported failure.   */

/*****************************************************************************
 *
 *	"filereqclass.c" - BOOPSI Asl filerequester class.
 */
#define FRQ_Drawer			(BGUI_TB+1941)	/* --G-- */
#define FRQ_File			(BGUI_TB+1942)	/* --G-- */
#define FRQ_Pattern			(BGUI_TB+1943)	/* --G-- */
#define FRQ_Path			(BGUI_TB+1944)	/* --G-- */
#define FRQ_Left			(BGUI_TB+1945)	/* --G-- */
#define FRQ_Top                         (BGUI_TB+1946)	/* --G-- */
#define FRQ_Width			(BGUI_TB+1947)	/* --G-- */
#define FRQ_Height			(BGUI_TB+1948)	/* --G-- */
/*
 *	In addition to the above defined attributes are all
 *	ASL filerequester attributes ISG-U.
 */

/* BGUI_TB+1949 through BGUI_TB+2020 reserved. */

/*
 *	Error codes which the SetAttrs() and DoMethod()
 *	call's can return.
 */
#define FRQ_OK			(0L)	/* OK. No problems.		    */
#define FRQ_CANCEL		(1L)	/* The requester was cancelled.     */
#define FRQ_ERROR_NO_MEM	(2L)	/* Out of memory.		    */
#define FRQ_ERROR_NO_FREQ	(3L)	/* Unable to allocate a requester.  */

/* New Methods */

#define FRM_DOREQUEST			(BGUI_MB+701)	/* Show Requester.  */

/* BGUI_MB+702 through BGUI_MB+740 reserved. */

#endif /* LIBRARIES_BGUI_H */
