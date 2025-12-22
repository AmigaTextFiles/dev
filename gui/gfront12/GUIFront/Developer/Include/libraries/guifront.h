#ifndef LIBRARIES_GUIFRONT_H
#define LIBRARIES_GUIFRONT_H
/*
**	$VER: GUIFront.h 38.1 (18.6.95)
**	Includes Release 38.1
**
**	C header file for GUIFront. For use with 32 bit integers only.
**
**	(C) Copyright 1994-1995 Michael Berg
**	    All Rights Reserved
*/

/* View with TAB=4 */

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif /* EXEC_TYPES_H */

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif /* EXEC_UTILITY_H */

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif /* LIBRARIES_GADTOOLS_H */

#define GUIFRONTNAME		"guifront.library"
#define GUIFRONTVERSION		38

/* Tags for CreateGUIAppA() */
enum
{
	GFA_Author = (int)TAG_USER,		/* Author of software (70 chars max) */
	GFA_Date,						/* Date of release (14 chars max) */
	GFA_LongDesc,					/* Longer description (70 chars max) */
	GFA_Version,					/* Version information (20 chars max) */
	GFA_VisualUpdateSigTask,		/* Task to signal when prefs change (defaults to FindTask(0)) */
	GFA_VisualUpdateSigBit,			/* Signal to send task when prefs change */
};

/* Tags for CreateGUIA() */

enum
{
	GUI_InitialOrientation = (int)TAG_USER,
	GUI_InitialSpacing,
	GUI_LocaleFunc,
	GUI_ExtendedError,
	GUI_UserData,
	GUI_OpenGUI,
	GUI_ExtraIDCMP,
	GUI_WindowTitle,
	GUI_Window,			/* Read-only */
	GUI_Backfill,		/* Please backfill this window */
	GUI_NewMenu,
	GUI_NewMenuLoc,
	GUI_MenuStrip,		/* Read-only */
	GUI_ActualFont,		/* Read-only */
	GUI_ScreenTitle,
	GUI_LeftEdge,
	GUI_TopEdge,
	GUI_Help,			/* Not currently implemented */

	/* V38 */
	GUI_GroupMask,		/* Group masking bits */
	GUI_GadgetMask,		/* Gadget masking bits */
	GUI_LockGUI,		/* Like GF_LockGUI() */
};

/* Extended error report from CreateGUIA() (via GUI_ExtendedError) */

typedef struct
{
	enum
	{
		GFERR_UNKNOWN = 100,				/* Unknown error */
		GFERR_NOT_ENOUGH_MEMORY,
		GFERR_MISSING_LOCALIZER,			/* Found GS_LocaleFunc but no GUI_Localizer */
		GFERR_GUI_TOO_WIDE,
		GFERR_GUI_TOO_TALL,
		GFERR_CANT_FIND_SCREEN,				/* Can't find or open required screen */
		GFERR_MISSING_GADGETSPECARRAY,		/* GUIL_GadgetSpecID used but no GUI_GadgetSpecArray supplied */
		GFERR_CANT_FIND_GADGETSPECID,		/* Unable to locate gadget with this ID */
		GFERR_UNKNOWN_LAYOUT_TAG,			/* Layout tag list contains garbage */
		GFERR_CANT_OPEN_WINDOW,				/* Unable to open gui (GUI_OpenGUI) */
		GFERR_CANT_CREATE_MENUS,			/* Unable to create or layout menus */
	} ee_ErrorCode;

	ULONG ee_ErrorData;
} ExtErrorData;

/* Tags for gadget layout lists */

enum
{
	GUIL_VertGroup = 1,
	GUIL_HorizGroup,
	GUIL_GadgetSpec,
	GUIL_GadgetSpecID,
	GUIL_FrameType,			/* See below */
	GUIL_HFrameOffset,
	GUIL_VFrameOffset,
	GUIL_Flags,				/* See below */
	GUIL_FrameHeadline,
	GUIL_FrameHeadlineLoc,	/* Localized - will call your localizer function */
	/* V38 */
	GUIL_GadgetMask,		/* Set current gadget masking value */
	GUIL_GroupMask,			/* Set masking value for current group */
};

/* GUIL_Flags */

/* Extension methods */
#define GUILF_PropShare		(1 << 0)	/* Members maintain their relative size */
#define GUILF_EqualShare	(1 << 1)	/* All members forced to equally share all available space */
#define GUILF_EqualSize		(1 << 2)	/* All members forced to equal size */

/* Secondary dimension ajustments */
#define GUILF_EqualWidth	(1 << 3)
#define GUILF_EqualHeight	GUILF_EqualWidth

/* Special label layout */
#define GUILF_LabelAlign	(1 << 4)

/* FrameType */

#define GUILFT_Normal		1
#define GUILFT_Recess		2
#define GUILFT_Ridge		3	/* NeXT style */
#define GUILFT_IconDropBox	4	/* Not implemented */

/* GadgetSpec */

typedef struct
{
	int gs_Kind;
	UWORD gs_MinWidth, gs_MinHeight;
	struct NewGadget gs_ng;
	struct TagItem *gs_Tags;
	UWORD gs_Flags;		/* See below */

	ULONG private[5];	/* Hands off! :-) */

	struct Gadget *gs_Gadget;	/* Valid when gadget has been created - Read-only! */
} GadgetSpec;

/* gs_Flags */

#define GS_NoWidthExtend	(1 << 0)	/* Lock hitbox width */
#define GS_NoHeightExtend	(1 << 1)	/* Lock hitbox height */
#define GS_Localized		(1 << 2)	/* Call localizer with this gadget */
#define GS_BoldLabel		(1 << 3)	/* Render label in bold-face */
#define GS_DefaultTags		(1 << 4)	/* Supply reasonable default tags */

/* Hook message (GS_LocaleFunc hook) */

typedef struct
{
    UWORD lhm_Kind;					/* What are we trying to localize here? */

	/* Your hook should look at the following union, localize the item in
	 * question (lhm_Kind tells you which), and return the localized
	 * string.
	 */

	union
	{
		ULONG lhmd_StringID;			/* Fetch this catalog ID, please */
		GadgetSpec *lhmd_GadgetSpec;	/* Localize this GadgetSpec */
		struct NewMenu *lhmd_NewMenu;	/* Localize this NewMenu */
	} lhm_Data;

} LocaleHookMsg;

/* lhm.lhm_Kind */
enum
{
	LHMK_StringID = 0,		/* Obtain generic catalog string */
	LHMK_GadgetSpec,		/* Return localized GadgetSpec string */
	LHMK_NewMenu,			/* Return localized NewMenu string */
};

/* Black-box access to private structures */

typedef void GUIFront;		/* Per-gui anchor structure */
typedef void GUIFrontApp;	/* Per-application anchor structure */

/* GUIFront bonus kinds */

#define GETALT_KIND		0x8000

/* Gadget creation tags for GETALT_KIND */

enum
{
	ALT_Image = (int)TAG_USER,		/* See enum below */
	ALT_AslTags,					/* (struct TagItem *) Tag items for ASL requester */
	ALT_AslRequester,				/* (BOOL) Enable automatic ASL requester */
	ALT_XenMode,					/* Do not use */
	ALT_FrameColor,					/* Do not use */
};

/* Image types (ALT_Image) */

enum
{
	ALTI_GetMisc,		/* Arrow down with line (get anything) */
	ALTI_GetDir,		/* Folder image (get directory or volume) */
	ALTI_GetFile,		/* Paper image (get a file) */
	ALTI_GetFont,		/* Character image */
	ALTI_GetScreenMode	/* Monitor image (well, kinda looks like a monitor :-) */
};

/*** Preferences related stuff ***/

/* Black-box access to preferences nodes (all fields are private) */

typedef void PrefsHandle;

/* Tags for GetPrefAttrA() and SetPrefAttrA() */

enum
{
	/* Flags */
	PRF_GadgetScreenFont = (int)TAG_USER,	/* (BOOL)		*/
	PRF_FrameScreenFont,					/* (BOOL)		*/

	/* Backfill control magic */
	PRF_AllowBackfill,						/* (BOOL)		*/
	PRF_BackfillFGPen,					/* (UWORD)		*/
	PRF_BackfillBGPen,					/* (UWORD)		*/

	/* Frametype preferences (per supported gadgetkind) */
	PRF_FrameStyleQuery,				/* (FrameStyleQuery *) - see below */

	PRF_XenFrameColor,					/* (UWORD)					*/
	PRF_GadgetFontYSize,				/* (UWORD)					*/
	PRF_GadgetFontName,					/* (char *) (max 50 chars)	*/
	PRF_FrameFontName,					/* (char *) (max 50 chars)	*/
	PRF_FrameFontYSize,					/* (UWORD)					*/
	PRF_FrameFontBold,					/* (BOOL)					*/
	PRF_FrameFontItalics,				/* (BOOL)					*/
	PRF_FrameFont3D,					/* (BOOL)					*/
	PRF_FrameFontFGPen,					/* (UWORD)					*/
	PRF_FrameFontCenter,				/* (BOOL)					*/
	PRF_FrameFontCentering,				/* (see PRFFC_* below)      */

	/* Miscellaneous */
	PRF_SimpleRefresh,					/* (BOOL)					*/

	/* Application Info (READ ONLY!) */
	PRF_Author,							/* (char *) (max 70 chars)  */
	PRF_Date,							/* (char *) (max 14 chars)  */
	PRF_LongDesc,						/* (char *) (max 70 chars)  */
	PRF_Version,						/* (char *) (max 20 chars)  */

	/* Public Screen tags (V38) */
	PRF_PubScreenType,					/* (UWORD)					*/
	PRF_PubScreenName,					/* (char *)					*/
};

/* Frame headline centering */
enum
{
	PRFFC_Left,				/* Left aligned */
	PRFFC_Center,			/* Centered */
	PRFFC_Right,			/* Right aligned */
};

typedef struct
{
	int fsq_GadgetKind;		/* As passed to CreateGadgetA() */
	BOOL fsq_Xen;			/* True: Xen, false: Normal */
} FrameStyleQuery;

/* PRF_PubScreenType */

enum
{
	PST_Workbench,
	PST_Frontmost,
	PST_Default,
	PST_Public
};

/* Tags for GF_GetGUIAppAttrA()/GF_SetGUIAppAttrA() */

enum
{
	GUIA_WindowPort = (int)TAG_USER,	/* Read only */
	GUIA_UserData,						/* Free for application use */
};

/* Tags for GF_GetPubScreenAttrA()/GF_SetPubScreenAttrA() (V38) */

enum
{
	PSA_DisplayID = (int)TAG_USER,		/* (ULONG)                  */
	PSA_Width,							/* (UWORD)                  */
	PSA_Height,							/* (UWORD)                  */
	PSA_Depth,							/* (UWORD)                  */
	PSA_Overscan,						/* (UWORD)                  */
	PSA_Draggable,						/* (BOOL)                   */
	PSA_Interleaved,					/* (BOOL)                   */
	PSA_AutoScroll,						/* (BOOL)                   */
	PSA_LeaveOpen,						/* (BOOL)                   */
	PSA_ShowTitle,						/* (BOOL)                   */
	PSA_Behind,							/* (BOOL)                   */
	PSA_Quiet,							/* (BOOL)                   */
	PSA_SharePens,						/* (BOOL)                   */
	PSA_Exclusive,						/* (BOOL)                   */
	PSA_MakeDefault,					/* (BOOL)                   */
	PSA_PopPubScreen,					/* (BOOL)                   */
	PSA_Shanghai,						/* (BOOL)                   */
	PSA_ScreenTitle,					/* (char *) (max 139 chars) */
	PSA_ScreenFont,						/* (char *) (max 50 chars)  */
	PSA_ScreenFontSize,					/* (UWORD)					*/
};

#endif /* LIBRARIES_GUIFRONT_H */
