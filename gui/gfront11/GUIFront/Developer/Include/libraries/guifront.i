	IFND LIBRARIES_GUIFRONT_I
LIBRARIES_GUIFRONT_I SET 1
*
*	$VER: GUIFront.h 37.3 (29.10.94)
*	Includes Release 37.3
*
*	Assembly header file for GUIFront.
*
*	(C) Copyright 1994 Michael Berg
*	    All Rights Reserved
*
* View with TAB=4

	IFND EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC

	IFND EXEC_LIBRARIES_I
	INCLUDE "exec/libraries.i"
	ENDC

	IFND UTILITY_TAGITEM_I
	INCLUDE "utility/tagitem.i"
	ENDC

	IFND LIBRARIES_GADTOOLS_I
	INCLUDE "libraries/gadtools.i"
	ENDC

GUIFRONTNAME	MACRO
				dc.b	'guifront.library',0
				ENDM
GUIFRONTVERSION	EQU 37

* Tags for CreateGUIAppA()

GFA_Author				EQU	TAG_USER	; Author of software (70 chars max)
GFA_Date				EQU TAG_USER+1	; Date of release (14 chars max)
GFA_LongDesc			EQU TAG_USER+2	; Longer description (70 chars max)
GFA_Version				EQU TAG_USER+2	; Version information (20 chars max)
GFA_VisualUpdateSigTask EQU TAG_USER+3	; Task to signal when prefs change (defaults to FindTask(0))
GFA_VisualUpdateSigBit  EQU TAG_USER+4	; Signal to send task when prefs change

* Tags for CreateGUIA()

GUI_InitialOrientation	EQU TAG_USER
GUI_InitialSpacing		EQU TAG_USER+1
GUI_LocaleFunc			EQU TAG_USER+2
GUI_ExtendedError		EQU TAG_USER+3
GUI_UserData			EQU TAG_USER+4
GUI_OpenGUI				EQU TAG_USER+5
GUI_ExtraIDCMP			EQU TAG_USER+6
GUI_WindowTitle			EQU TAG_USER+7
GUI_Window				EQU TAG_USER+8		; Read-only
GUI_Backfill			EQU TAG_USER+9		; Please backfill this window
GUI_NewMenu				EQU TAG_USER+10
GUI_NewMenuLoc			EQU TAG_USER+11
GUI_MenuStrip			EQU TAG_USER+12		; Read-only
GUI_ActualFont			EQU TAG_USER+13		; Read-only
GUI_ScreenTitle			EQU TAG_USER+14
GUI_LeftEdge			EQU TAG_USER+15
GUI_TopEdge				EQU TAG_USER+16
GUI_Help				EQU TAG_USER+17		; Not currently implemented

* Extended error report codes from CreateGUIA() (via GUI_ExtendedError)

GFERR_UNKNOWN					EQU 100			; Unknown error
GFERR_NOT_ENOUGH_MEMORY			EQU 100+1
GFERR_MISSING_LOCALIZER			EQU 100+2		; Found GS_LocaleFunc but no GUI_Localizer
GFERR_GUI_TOO_WIDE				EQU 100+3
GFERR_GUI_TOO_TALL				EQU 100+4
GFERR_CANT_FIND_SCREEN			EQU 100+5		; Can't find or open required screen
GFERR_MISSING_GADGETSPECARRAY	EQU 100+6		; GUIL_GadgetSpecID used but no GUI_GadgetSpecArray supplied
GFERR_CANT_FIND_GADGETSPECID	EQU 100+7		; Unable to locate gadget with this ID
GFERR_UNKNOWN_LAYOUT_TAG		EQU 100+8		; Layout tag list contains garbage
GFERR_CANT_OPEN_WINDOW			EQU 100+9		; Unable to open gui (GUI_OpenGUI)
GFERR_CANT_CREATE_MENUS			EQU 100+10		; Unable to create or layout menus

	STRUCTURE ExtErrorData,0
		ULONG ee_ErrorCode
		ULONG ee_ErrorData
		LABEL ee_SIZE

* Tags for gadget layout lists

GUIL_VertGroup			EQU 1
GUIL_HorizGroup			EQU 2
GUIL_GadgetSpec			EQU 3
GUIL_GadgetSpecID		EQU 4
GUIL_FrameType			EQU 5			; See below
GUIL_HFrameOffset		EQU 6
GUIL_VFrameOffset		EQU 7
GUIL_Flags				EQU 8			; See below
GUIL_FrameHeadline		EQU 9
GUIL_FrameHeadlineLoc	EQU 10			; Localized - will call your localizer function

* GUIL_Flags

; Extension methods
GUILF_PropShare			EQU (1<<0)	; Members maintain their relative size
GUILF_EqualShare		EQU (1<<1)	; All members forced to equally share all available space
GUILF_EqualSize			EQU (1<<2)	; All members forced to equal size

; Secondary dimension ajustments
GUILF_EqualWidth		EQU (1<<3)
GUILF_EqualHeight		EQU GUILF_EqualWidth

; Special label layout
GUILF_LabelAlign		EQU (1<<4)

* FrameType

GUILFT_Normal		EQU	1
GUILFT_Recess		EQU 2
GUILFT_Ridge		EQU 3	; NeXT style
GUILFT_IconDropBox	EQU 4	; Not implemented

* GadgetSpec

	STRUCTURE GadgetSpec,0
		ULONG   gs_Kind
		UWORD   gs_MinWidth
		UWORD   gs_MinHeight
		STRUCT  gs_ng,gng_SIZEOF
		APTR    gs_Tags
		UWORD   gs_Flags			; See below
		STRUCT  gs_private,5*4		; Hands off!
		APTR    gs_Gadget			; Valid when gadget has been created - Read only!
		LABEL   gs_SIZE

* gs_Flags

GS_NoWidthExtend	EQU (1<<0)		; Lock hitbox width
GS_NoHeightExtend	EQU (1<<1)		; Lock hitbox height
GS_Localized		EQU (1<<2)		; Call localizer with this gadget
GS_BoldLabel		EQU (1<<3)		; Render label in bold-face
GS_DefaultTags		EQU (1<<4)		; Supply reasonable default tags

* Hook message (GS_LocaleFunc hook)

	STRUCTURE LocaleHookMsg,0
		UWORD lhm_Kind				; What are we trying to localize here?
		; Your hook should look at the following union (named lhm_Data in the
		; C include file), localize the item in question (lhm_Kind tells you
		; which), and return the localized string.
		ULONG lhmd_StringID			; Fetch this catalog ID, please */
		LABEL lhmd_GadgetSpec		; Localize this GadgetSpec */
		LABEL lhmd_NewMenu			; Localize this NewMenu */
		LABEL lhm_SIZE

* lhm_Kind

LHMK_StringID		EQU 0		; Obtain generic catalog string
LHMK_GadgetSpec		EQU 1		; Return localized GadgetSpec string
LHMK_NewMenu		EQU 2		; Return localized NewMenu string

* GUIFront bonus kinds

GETALT_KIND			EQU $8000

* Gadget creation tags for GETALT_KIND

ALT_Image			EQU TAG_USER		; See below
ALT_AslTags			EQU TAG_USER+1		; (struct TagItem *) Tag items for ASL requester
ALT_AslRequester	EQU	TAG_USER+2		; (BOOL) Enable automatic ASL requester
ALT_XenMode			EQU TAG_USER+3		; Do not use
ALT_FrameColor		EQU TAG_USER+4		; Do not use

* Image types (ALT_Image)

ALTI_GetMisc		EQU 0 	; Arrow down with line (get anything)
ALTI_GetDir			EQU 1	; Folder image (get directory or volume)
ALTI_GetFile		EQU 2	; Paper image (get a file)
ALTI_GetFont		EQU 3	; Copy of arrow down image
ALTI_GetScreenMode	EQU 4	; Copy of arrow down image (not implemented)

*** Preferences related stuff ***

* Tags for GetPrefAttrA() and SetPrefAttrA()

; Flags */
PRF_GadgetScreenFont		EQU TAG_USER		; (BOOL)
PRF_FrameScreenFont			EQU TAG_USER+1		; (BOOL)

; Backfill control magic
PRF_AllowBackfill			EQU TAG_USER+2		; (BOOL)
PRF_BackfillFGPen			EQU TAG_USER+3		; (UWORD)
PRF_BackfillBGPen			EQU TAG_USER+4		; (UWORD)

; Frametype preferences (per supported gadgetkind)
PRF_FrameStyleQuery			EQU TAG_USER+5 		; (FrameStyleQuery *) - see below

PRF_XenFrameColor			EQU TAG_USER+6 		; (UWORD)
PRF_GadgetFontYSize			EQU TAG_USER+7 		; (UWORD)
PRF_GadgetFontName			EQU TAG_USER+8 		; (char *) (max 50 chars)
PRF_FrameFontName			EQU TAG_USER+9 		; (char *) (max 50 chars)
PRF_FrameFontYSize			EQU TAG_USER+10 	; (UWORD)
PRF_FrameFontBold			EQU TAG_USER+11 	; (BOOL)
PRF_FrameFontItalics		EQU TAG_USER+12 	; (BOOL)
PRF_FrameFont3D				EQU TAG_USER+13 	; (BOOL)
PRF_FrameFontFGPen			EQU TAG_USER+14 	; (UWORD)
PRF_FrameFontCenter			EQU TAG_USER+15 	; (BOOL)
PRF_FrameFontCentering		EQU TAG_USER+16 	; (see PRFFC_* below)

; Miscellaneous
PRF_SimpleRefresh			EQU TAG_USER+17 	; (BOOL)

; Application Info (READ ONLY!)
PRF_Author					EQU TAG_USER+18 	; (char *) (max 70 chars)
PRF_Date					EQU TAG_USER+19 	; (char *) (max 14 chars)
PRF_LongDesc				EQU TAG_USER+20 	; (char *) (max 70 chars)
PRF_Version					EQU TAG_USER+21 	; (char *) (max 20 chars)

* Frame headline centering

PRFFC_Left		EQU 0			; Left aligned
PRFFC_Center	EQU 1			; Centered
PRFFC_Right		EQU 2			; Right aligned

	STRUCTURE FrameStyleQuery,0
		ULONG fsq_GadgetKind			; As passed to CreateGadgetA()
		BOOL  fsq_Xen					; TRUE: Xen, FALSE: Normal
		LABEL fsq_SIZE

* Tags for GF_GetGUIAppAttrA()/GF_SetGUIAppAttrA()

GUIA_WindowPort		EQU TAG_USER		; Read only
GUIA_UserData		EQU TAG_USER+1		; Free for application use

	ENDC
