    IFND	LIBRARIES_BGUI_I
LIBRARIES_BGUI_I	SET	1
**
**	$VER: libraries/bgui.i 39.22 (9.9.95)
**	ASM header for the bgui.library.
**
**	bgui.library structures and constants.
**
**	(C) Copyright 1993-1995 Jaba Development.
**	(C) Copyright 1993-1995 Jan van den Baard.
**	All Rights Reserved.
**

	IFND	__m68

	IFND	EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC

	IFND	INTUITION_CLASSES_I
	INCLUDE "intuition/classes.i"
	ENDC

	IFND	INTUITION_CLASSUSR_I
	INCLUDE "intuition/classusr.i"
	ENDC

	IFND	INTUITION_IMAGECLASS_I
	INCLUDE "intuition/imageclass.i"
	ENDC

	IFND	INTUITION_GADGETCLASS_I
	INCLUDE "intuition/gadgetclass.i"
	ENDC

	IFND	INTUITION_CGHOOKS_I
	INCLUDE "intuition/cghooks.i"
	ENDC

	IFND	LIBRARIES_COMMODITIES_I
	INCLUDE "libraries/commodities.i"
	ENDC

	IFND	LIBRARIES_GADTOOLS_I
	INCLUDE "libraries/gadtools.i"
	ENDC

	IFND UTILITY_TAGITEM_I
	INCLUDE "utility/tagitem.i"
	ENDC

	ENDC	* _m68

*****************************************************************************
**
**	The attribute definitions in this header are all followed by
**	a small comment. This comment can contain the following things:
**
**	I	 - Attribute can be set with OM_NEW
**	S	 - Attribute can be set with OM_SET
**	G	 - Attribute can be read with OM_GET
**	N	 - Setting this attribute triggers a notification.
**	U	 - Attribute can be set with OM_UPDATE.
**	PRIVATE! - Like it says: Private. Do not use this attribute.
**

*****************************************************************************
**
**	Miscellanious library definitions.
**
BGUINAME	MACRO
		DC.B	'bgui.library',0
		ENDM

BGUIVERSION	EQU	37

* Added to avoid problems with multiple defines.

   STRUCTURE	bguiMethodID,0
	ULONG	bmi_MethodID
	LABEL	MethodID_SIZEOF

******************************************************************************
**
**	BGUI_GetClassPtr() and BGUI_NewObjectA() class ID's.
**
BGUI_LABEL_IMAGE	EQU	0
BGUI_FRAME_IMAGE	EQU	1
BGUI_VECTOR_IMAGE	EQU	2
** 3 until 10 reserved. **
BGUI_BASE_GADGET	EQU	11
BGUI_GROUP_GADGET	EQU	12
BGUI_BUTTON_GADGET	EQU	13
BGUI_CYCLE_GADGET	EQU	14
BGUI_CHECKBOX_GADGET	EQU	15
BGUI_INFO_GADGET	EQU	16
BGUI_STRING_GADGET	EQU	17
BGUI_PROP_GADGET	EQU	18
BGUI_INDICATOR_GADGET	EQU	19
** 20 is reserved. **
BGUI_PROGRESS_GADGET	EQU	21
BGUI_SLIDER_GADGET	EQU	22
BGUI_LISTVIEW_GADGET	EQU	23
BGUI_MX_GADGET		EQU	24
BGUI_PAGE_GADGET	EQU	25
BGUI_EXTERNAL_GADGET	EQU	26
BGUI_SEPERATOR_GADGET	EQU	27
** 28 until 39 reserved. **
BGUI_WINDOW_OBJECT	EQU	40
BGUI_FILEREQ_OBJECT	EQU	41
BGUI_COMMODITY_OBJECT	EQU	42

** Typo
BGUI_SEPARATOR_GADGET	EQU	27

******************************************************************************
**
**	BGUI requester definitions.
**
   STRUCTURE	bguiRequest,0
	ULONG	br_Flags	 ; See below.
	APTR	br_Title	 ; Requester title.
	APTR	br_GadgetFormat  ; Gadget labels.
	APTR	br_TextFormat	 ; Body text format.
	UWORD	br_ReqPos	 ; Requester position.
	APTR	br_TextAttr	 ; Requester font.
	UBYTE	br_Underscore	 ; Underscore indicator.
	STRUCT	br_Reserved0,3	 ; Set to 0!
	APTR	br_Screen	 ; Requester screen.
	STRUCT	br_Reserved1,5*4 ; Set to 0!
   LABEL bguiRequest_SIZEOF

BREQF_CENTERWINDOW	EQU	$0001	; Center requester on the window.
BREQF_LOCKWINDOW	EQU	$0002	; Lock the parent window.
BREQF_NO_PATTERN	EQU	$0004	; Don't use back-fill pattern.
BREQF_XEN_BUTTONS	EQU	$0008	; Use XEN style buttons.
BREQF_AUTO_ASPECT	EQU	$0010	; Aspect ratio dependant look.
BREQF_FAST_KEYS         EQU	$0020	; Return/Esc hotkeys.

******************************************************************************
**
**	Tag and method bases.
**
BGUI_TB         EQU	TAG_USER+$000F0000
BGUI_MB         EQU	$000F0000

******************************************************************************
**
**	"frameclass" - BOOPSI framing image.
**
FRM_Type		EQU	BGUI_TB+1	; ISG--
FRM_CustomHook		EQU	BGUI_TB+2	; ISG--
FRM_BackFillHook	EQU	BGUI_TB+3	; ISG--
FRM_Title		EQU	BGUI_TB+4	; ISG--
FRM_TextAttr		EQU	BGUI_TB+5	; ISG--
FRM_Flags		EQU	BGUI_TB+6	; ISG--
FRM_FrameWidth		EQU	BGUI_TB+7	; --G--
FRM_FrameHeight         EQU	BGUI_TB+8	; --G--
FRM_BackFill		EQU	BGUI_TB+9	; ISG--
FRM_EdgesOnly		EQU	BGUI_TB+10	; ISG--
FRM_Recessed		EQU	BGUI_TB+11	; ISG--
FRM_CenterTitle         EQU	BGUI_TB+12	; ISG--
FRM_HighlightTitle	EQU	BGUI_TB+13	; ISG--
FRM_ThinFrame		EQU	BGUI_TB+14	; ISG--
FRM_BackPen		EQU	BGUI_TB+15	; ISG--           V39
FRM_SelectedBackPen	EQU	BGUI_TB+16	; ISG--           V39
FRM_BackDriPen		EQU	BGUI_TB+17	; ISG--           V39
FRM_SelectedBackDriPen	EQU	BGUI_TB+18	; ISG--           V39

** BGUI_TB+19 until BGUI_TB+80 reserved

** Back fill types **
STANDARD_FILL		EQU	0
SHINE_RASTER		EQU	1
SHADOW_RASTER		EQU	2
SHINE_SHADOW_RASTER	EQU	3
FILL_RASTER		EQU	4
SHINE_FILL_RASTER	EQU	5
SHADOW_FILL_RASTER	EQU	6
SHINE_BLOCK		EQU	7
SHADOW_BLOCK		EQU	8

** Flags **
FRF_EDGES_ONLY		EQU	$0001
FRF_RECESSED		EQU	$0002
FRF_CENTER_TITLE	EQU	$0004
FRF_HIGHLIGHT_TITLE	EQU	$0008
FRF_THIN_FRAME		EQU	$0010

** Frame types **
FRTYPE_CUSTOM		EQU	0
FRTYPE_BUTTON		EQU	1
FRTYPE_RIDGE		EQU	2
FRTYPE_DROPBOX		EQU	3
FRTYPE_NEXT		EQU	4
FRTYPE_RADIOBUTTON	EQU	5
FRTYPE_XEN_BUTTON	EQU	6

**
**	FRM_RENDER:
**
**	The message packet sent to both the FRM_CustomHook
**	and FRM_BackFillHook routines. Note that this
**	structure is READ-ONLY!
**
**	The hook is called as follows:
**
**		lea	hook,a0         * 'STRUCTURE Hook' pointer
**		lea	image_object,a2 * Object pointer
**		lea	fdraw,a1	* FrameDrawMsg pointer
**		jsr	hookFunc	* Call hook function
**		tst.l	d0		* return code in D0
**
FRM_RENDER	EQU	1	; Render yourself

   STRUCTURE	FrameDrawMsg,0
	ULONG	fdm_MethodID	; FRM_RENDER
	APTR	fdm_RPort	; RastPort ready for rendering
	APTR	fdm_DrawInfo	; All you need to render
	APTR	fdm_Bounds	; Rendering bounds.
	UWORD	fdm_State	; See "intuition/imageclass.h"
   LABEL FrameDrawMsg_SIZEOF

**
**	FRM_THICKNESS:
**
**	The message packet sent to the FRM_Custom hook.
**	This structure is READ-ONLY!
**
**	The hook is called as follows:
**
**		lea	hook,a0         * 'STRUCTURE Hook' pointer
**		lea	image_object,a2 * Object pointer
**		lea	thick,a1	* ThicknessMsg pointer
**		jsr	hookFunc	* Call hook function
**		tst.l	d0		* return code in D0
**
FRM_THICKNESS	EQU	2	; Give the frame thickness.

   STRUCTURE	ThicknessMsg,0
	ULONG	tm_MethodID		; FRM_THICKNESS
	UBYTE	tm_ThicknessHorizontal	; Storage for horizontal
	UBYTE	tm_ThicknessVertical	; Storage for vertical
	WORD	tm_Thin                 ; Added in V38!
   LABEL	ThicknessMsg_SIZEOF

** Possible hook return codes. **
FRC_OK		EQU	0	; OK
FRC_UNKNOWN	EQU	1	; Unknow method

******************************************************************************
**
**	"labelclass" - BOOPSI labeling image.
**
LAB_TextAttr		EQU	BGUI_TB+81	; ISG--
LAB_Style		EQU	BGUI_TB+82	; ISG--
LAB_Underscore		EQU	BGUI_TB+83	; ISG--
LAB_Place		EQU	BGUI_TB+84	; ISG--
LAB_Label		EQU	BGUI_TB+85	; ISG--
LAB_Flags		EQU	BGUI_TB+86	; ISG--
LAB_Highlight		EQU	BGUI_TB+87	; ISG--
LAB_HighUScore		EQU	BGUI_TB+88	; ISG--
LAB_Pen                 EQU	BGUI_TB+89	; ISG--           V39
LAB_SelectedPen         EQU	BGUI_TB+90	; ISG--           V39
LAB_DriPen		EQU	BGUI_TB+91	; ISG--           V39
LAB_SelectedDriPen	EQU	BGUI_TB+92	; ISG--           V39

** BGUI_TB+93 until BGUI_TB+160 reserved

** Flags **
LABF_HIGHLIGHT		EQU	$0001	; Highlight label
LABF_HIGH_USCORE	EQU	$0002	; Highlight underscoring

** Label placement **
PLACE_IN	EQU	0
PLACE_LEFT	EQU	1
PLACE_RIGHT	EQU	2
PLACE_ABOVE	EQU	3
PLACE_BELOW	EQU	4

** New methods **
**
**	The IM_EXTENT method is used to find out how many
**	pixels the label extents the relative hitbox in
**	either direction. Normally this method is called
**	by the baseclass.
**
IM_EXTENT	EQU	BGUI_MB+1

   STRUCTURE	impExtent,MethodID_SIZEOF  ; IM_EXTENT
	APTR	impex_RPort		; RastPort
	APTR	impex_Extent		; Storage for extentions.
	UWORD	impex_LabelSizeWidth	; Storage width in pixels
	UWORD	impex_LabelSizeHeight	; Storage height in pixels
	UWORD	impex_Flags		; See below.
   LABEL	impExtent_SIZEOF

EXTF_MAXIMUM	EQU	$0001	; Request maximum extensions.

** BGUI_MB+2 until BGUI_MB+40 reserved

******************************************************************************
**
**	"vectorclass" - BOOPSI scalable vector image.
**
**	Based on an idea found in the ObjectiveGadTools.library
**	by Davide Massarenti.
**
VIT_VectorArray EQU	BGUI_TB+161	; ISG--
VIT_BuiltIn	EQU	BGUI_TB+162	; ISG--
VIT_Pen         EQU	BGUI_TB+163	; ISG--
VIT_DriPen	EQU	BGUI_TB+164	; ISG--

** BGUI_TB+165 until BGUI_TB+240 reserved.

**
**	Command structure which can contain
**	coordinates, data and command flags.
**
   STRUCTURE	VectorItem,0
	WORD	vi_x		; X coordinate or data
	WORD	vi_y		; Y coordinate
	ULONG	vi_Flags	; See below
   LABEL	VectorItem_SIZEOF

** Flags **
VIF_MOVE	EQU	$00000001	; Move to vc_x, vc_y
VIF_DRAW	EQU	$00000002	; Draw to vc_x, vc_y
VIF_AREASTART	EQU	$00000004	; Start AreaFill at vc_x, vc_y
VIF_AREAEND	EQU	$00000008	; End AreaFill at vc_x, vc_y
VIF_XRELRIGHT	EQU	$00000010	; vc_x relative to right edge
VIF_YRELBOTTOM	EQU	$00000020	; vc_y relative to bottom edge
VIF_SHADOWPEN	EQU	$00000040	; switch to SHADOWPEN, Move/Draw
VIF_SHINEPEN	EQU	$00000080	; switch to SHINEPEN, Move/Draw
VIF_FILLPEN	EQU	$00000100	; switch to FILLPEN, Move/Draw
VIF_TEXTPEN	EQU	$00000200	; switch to TEXTPEN, Move/Draw
VIF_COLOR	EQU	$00000400	; switch to color in vc_x
VIF_LASTITEM	EQU	$00000800	; last element of the element list
VIF_SCALE	EQU	$00001000	; X & Y are design width & height
VIF_DRIPEN	EQU	$00002000	; switch to dripen vc_x
VIF_AOLPEN	EQU	$00004000	; set area outline pen vc_x
VIF_AOLDRIPEN	EQU	$00008000	; set area outline dripen vc_x
VIF_ENDOPEN	EQU	$00010000	; end area outline pen

** Built-in images. **
BUILTIN_GETPATH         EQU	1
BUILTIN_GETFILE         EQU	2
BUILTIN_CHECKMARK	EQU	3
BUILTIN_POPUP		EQU	4
BUILTIN_ARROW_UP	EQU	5
BUILTIN_ARROW_DOWN	EQU	6
BUILTIN_ARROW_LEFT	EQU	7
BUILTIN_ARROW_RIGHT	EQU	8

** Design width and heights of the built-in images. **
GETPATH_WIDTH		EQU	20
GETPATH_HEIGHT		EQU	14
GETFILE_WIDTH		EQU	20
GETFILE_HEIGHT		EQU	14
CHECKMARK_WIDTH         EQU	26
CHECKMARK_HEIGHT	EQU	11
POPUP_WIDTH		EQU	15
POPUP_HEIGHT		EQU	13
ARROW_UP_WIDTH		EQU	16
ARROW_UP_HEIGHT         EQU	9
ARROW_DOWN_WIDTH	EQU	16
ARROW_DOWN_HEIGHT	EQU	9
ARROW_LEFT_WIDTH	EQU	10
ARROW_LEFT_HEIGHT	EQU	12
ARROW_RIGHT_WIDTH	EQU	10
ARROW_RIGHT_HEIGHT	EQU	12

******************************************************************************
**
**	"baseclass" - BOOPSI base gadget.
**
**	This is a very important BGUI gadget class. All other gadget classes
**	are sub-classed from this class. It will handle stuff like online
**	help, notification, labels and frames etc. If you want to write a
**	gadget class for BGUI be sure to subclass it from this class. That
**	way your class will automatically inherit the same features.
**
BT_HelpFile	EQU	BGUI_TB+241	; IS---
BT_HelpNode	EQU	BGUI_TB+242	; IS---
BT_HelpLine	EQU	BGUI_TB+243	; IS---
BT_Inhibit	EQU	BGUI_TB+244	; --G--
BT_HitBox	EQU	BGUI_TB+245	; --G--
BT_LabelObject	EQU	BGUI_TB+246	; -SG--
BT_FrameObject	EQU	BGUI_TB+247	; -SG--
BT_TextAttr	EQU	BGUI_TB+248	; -SG--
BT_NoRecessed	EQU	BGUI_TB+249	; -S---
BT_LabelClick	EQU	BGUI_TB+250	; IS---
BT_HelpText	EQU	BGUI_TB+251	; IS---

** BGUI_TB+252 until BGUI_TB+320 reserved.

** New methods **
BASE_ADDMAP	EQU	BGUI_MB+41

** Add an object to the maplist notification list. **
   STRUCTURE	bmAddMap,MethodID_SIZEOF
	APTR	bam_Object
	APTR	bam_MapList
   LABEL	bmAddMap_SIZEOF

BASE_ADDCONDITIONAL	EQU	BGUI_MB+42

** Add an object to the conditional notification list. **
   STRUCTURE	bmAddConditional,MethodID_SIZEOF
	APTR	bac_Object
	STRUCT	bac_Condition,ti_SIZEOF
	STRUCT	bac_TRUE,ti_SIZEOF
	STRUCT	bac_FALSE,ti_SIZEOF
   LABEL	bmAddConditional_SIZEOF

BASE_ADDMETHOD	EQU	BGUI_MB+43

** Add an object to the method notification list. **
   STRUCTURE	bmAddMethod,MethodID_SIZEOF
	APTR	bamtd_Object
	ULONG	bamtd_Flags
	ULONG	bamtd_Size
	ULONG	bamtd_MethodID
   LABEL	bmAddMethod_SIZEOF

BAMF_NO_GINFO		EQU	$0001	; Do not send GadgetInfo.
BAMF_NO_INTERIM         EQU	$0002	; Skip interim messages.

BASE_REMMAP		EQU	BGUI_MB+44
BASE_REMCONDITIONAL	EQU	BGUI_MB+45
BASE_REMMETHOD		EQU	BGUI_MB+46

** Remove an object from a notification list. **
   STRUCTURE	bmRemove,MethodID_SIZEOF
	APTR	bar_Object
   LABEL	bmRemove_SIZEOF

BASE_SHOWHELP		EQU	BGUI_MB+47

** Show attached online-help. **
   STRUCTURE	bmShowHelp,MethodID_SIZEOF
	APTR	bsh_Window
	APTR	bsh_Requester
	WORD	bsh_MouseX
	WORD	bsh_MouseY
   LABEL	bmShowHelp_SIZEOF

BMHELP_OK	EQU	0	; OK, no problems.
BMHELP_NOT_ME	EQU	1	; Mouse not over the object.
BMHELP_FAILURE	EQU	2	; Showing failed.

**
**	The following three methods are used internally to
**	perform infinite-loop checking. Do not use them.
**
BASE_SETLOOP	EQU	BGUI_MB+48
BASE_CLEARLOOP	EQU	BGUI_MB+49
BASE_CHECKLOOP	EQU	BGUI_MB+50

** PRIVATE! Hands off! **
BASE_LEFTEXT	EQU	BGUI_MB+51

   STRUCTURE	bmLeftExt,MethodID_SIZEOF
	APTR	bmle_RPort
	UWORD	bmle_Extention
   LABEL	bmLeftExt_SIZEOF

BASE_ADDHOOK	EQU	BGUI_MB+52

** Add a hook to the hook-notification list. **
   STRUCTURE	bmAddHook,MethodID_SIZEOF
	APTR	bah_Hook
   LABEL	bahAddHook_SIZEOF

** Remove a hook from the hook-notification list.
BASE_REMHOOK	EQU	BGUI_MB+53

** BGUI_MB+54 until BGUI_MB+80 reserved.

******************************************************************************
**
**	"groupclass" - BOOPSI group gadget.
**
**	This class is the actual bgui.library layout engine. It will layout
**	all members in a specific area. Two group types are available,
**	horizontal and vertical groups.
**
GROUP_Style		EQU	BGUI_TB+321	; I----
GROUP_Spacing		EQU	BGUI_TB+322	; I----
GROUP_HorizOffset	EQU	BGUI_TB+323	; I----
GROUP_VertOffset	EQU	BGUI_TB+324	; I----
GROUP_LeftOffset	EQU	BGUI_TB+325	; I----
GROUP_TopOffset         EQU	BGUI_TB+326	; I----
GROUP_RightOffset	EQU	BGUI_TB+327	; I----
GROUP_BottomOffset	EQU	BGUI_TB+328	; I----
GROUP_Member		EQU	BGUI_TB+329	; I----
GROUP_SpaceObject	EQU	BGUI_TB+330	; I----
GROUP_BackFill		EQU	BGUI_TB+331	; I----
GROUP_EqualWidth	EQU	BGUI_TB+332	; I----
GROUP_EqualHeight	EQU	BGUI_TB+333	; I----
GROUP_Inverted		EQU	BGUI_TB+334	; I----

** BGUI_TB+335 until BGUI_TB+380 reserved.

** Object layout attributes. **
LGO_FixWidth		EQU	BGUI_TB+381
LGO_FixHeight		EQU	BGUI_TB+382
LGO_Weight		EQU	BGUI_TB+383
LGO_FixMinWidth         EQU	BGUI_TB+384
LGO_FixMinHeight	EQU	BGUI_TB+385
LGO_Align		EQU	BGUI_TB+386
LGO_NoAlign		EQU	BGUI_TB+387			; V38

** BGUI_TB+388 until BGUI_TB+400 reserved.

** Default object weight. **
DEFAULT_WEIGHT	EQU	50

** Group styles. **
GRSTYLE_HORIZONTAL	EQU	0
GRSTYLE_VERTICAL	EQU	1

** New methods. **
GRM_ADDMEMBER	EQU	BGUI_MB+81

** Add a member to the group. **
   STRUCTURE	grmAddMember,MethodID_SIZEOF	   ; GRM_ADDMEMBER
	APTR	grma_Member			; Object to add.
	ULONG	grma_Attr			; First of LGO attributes.
   LABEL	grmAddMember_SIZEOF

GRM_REMMEMBER	EQU	BGUI_MB+82

** Remove a member from the group. **
   STRUCTURE	grmRemMember,MethodID_SIZEOF	   ; GRM_REMMEMBER
	APTR	grmr_Member			; Object to remove.
   LABEL	grmRemMember_SIZEOF

GRM_DIMENSIONS	EQU	BGUI_MB+83

** Ask an object it's dimensions information. **
   STRUCTURE	grmDimensions,MethodID_SIZEOF	   ; GRM_DIMENSIONS
	APTR	grmd_GInfo			; Can be NULL!
	APTR	grmd_RPort			; Ready for calculations.
	APTR	grmd_MinSizeWidth		; Storage for dimensions.
	APTR	grmd_MinSizeHeight		; -
	ULONG	grmd_Flags			; See below.
   LABEL	grmDimensions_SIZEOF

** Flags **
GDIMF_NO_FRAME		EQU	$0001	; Don't take frame width/height
					; into consideration.

GRM_ADDSPACEMEMBER	EQU	BGUI_MB+84

** Add a weight controlled spacing member. **
   STRUCTURE	grmAddSpaceMember,MethodID_SIZEOF  ; GRM_ADDSPACEMEMBER
	ULONG	grms_Weight			; Object weight.
   LABEL	grmAddSpaceMember_SIZEOF

GRM_INSERTMEMBER	EQU	BGUI_MB+85

   STRUCTURE	grmInsertMember,MethodID_SIZEOF    ; GRM_INSERTMEMBER
	APTR	grmi_Member			; Object to insert
	APTR	grmi_Pred			; Insert after this member
	ULONG	grmi_Attr			; First of LGO attributes
   LABEL	grmiInsertMember_SIZEOF

** BGUI_MB+86 until BGUI_MB+120 reserved.

******************************************************************************
**
**	"buttonclass" - BOOPSI button gadget.
**
**	GadTools style button gadget.
**
**	GA_Selected has been made gettable (OM_GET) for toggle-select
**	buttons. (ISGNU)
**
BUTTON_ScaleMinWidth	EQU	BGUI_TB+401	; PRIVATE!
BUTTON_ScaleMinHeight	EQU	BGUI_TB+402	; PRIVATE!
BUTTON_Image		EQU	BGUI_TB+403	; IS--U
BUTTON_SelectedImage	EQU	BGUI_TB+404	; IS--U
BUTTON_EncloseImage	EQU	BGUI_TB+405	; I----           V39

** BGUI_TB+406 until BGUI_TB+480 reserved.
** BGUI_MB+121 until BGUI_MB+160 reserved.

******************************************************************************
**
**	"checkboxclass" - BOOPSI checkbox gadget.
**
**	GadTools style checkbox gadget.
**
**	GA_Selected has been made gettable (OM_GET). (ISGNU)
**

** BGUI_TB+481 until BGUI_TB+560 reserved.
** BGUI_MB+161 until BGUI_MB+200 reserved.

******************************************************************************
**
**	"cycleclass" - BOOPSI cycle gadget.
**
**	GadTools style cycle gadget.
**
CYC_Labels	EQU	BGUI_TB+561	; I----
CYC_Active	EQU	BGUI_TB+562	; ISGNU
CYC_Popup	EQU	BGUI_TB+563	; I----

** BGUI_TB+564 until BGUI_TB+640 reserved.
** BGUI_MB+201 until BGUI_MB+240 reserved.

******************************************************************************
**
**	"infoclass" - BOOPSI information gadget.
**
**	Text gadget which supports different colors, text styles and
**	text positioning.
**
INFO_TextFormat         EQU	BGUI_TB+641	; IS--U
INFO_Args		EQU	BGUI_TB+642	; IS--U
INFO_MinLines		EQU	BGUI_TB+643	; I----
INFO_FixTextWidth	EQU	BGUI_TB+644	; I----
INFO_HorizOffset	EQU	BGUI_TB+645	; I----
INFO_VertOffset         EQU	BGUI_TB+646	; I----

** Command sequences. **
ISEQ_B	MACRO		; Bold
	dc.b	27,"b"
	ENDM
ISEQ_I	MACRO		; Italics
	dc.b	27,"i"
	ENDM
ISEQ_U	MACRO		; Underlined
	dc.b	27,"u"
	ENDM
ISEQ_N	MACRO		; Normal
	dc.b	27,"n"
	ENDM
ISEQ_C	MACRO		; Centered
	dc.b	27,"c"
	ENDM
ISEQ_R	MACRO		; Right
	dc.b	27,"r"
	ENDM
ISEQ_L	MACRO		; Left
	dc.b	27,"l"
	ENDM
ISEQ_TEXT	MACRO		; TEXTPEN
	dc.b	27,"d2"
	ENDM
ISEQ_SHINE	MACRO		; SHINEPEN
	dc.b	27,"d3"
	ENDM
ISEQ_SHADOW	MACRO		; SHADOWPEN
	dc.b	27,"d4"
	ENDM
ISEQ_FILL	MACRO		; FILLPEN
	dc.b	27,"d5"
	ENDM
ISEQ_FILLTEXT	MACRO		; FILLTEXTPEN
	dc.b	27,"d6"
	ENDM
ISEQ_HIGHLIGHT	MACRO		; HIGHLIGHTPEN
	dc.b	27,"d8"
	ENDM

** BGUI_TB+645 until BGUI_TB+720 reserved.
** BGUI_MB+241 until BGUI_MB+280 reserved.

******************************************************************************
**
**	"listviewclass" - BOOPSI listview gadget.
**
**	GadTools style listview gadget.
**
LISTV_ResourceHook	EQU	BGUI_TB+721	; I----
LISTV_DisplayHook	EQU	BGUI_TB+722	; I----
LISTV_CompareHook	EQU	BGUI_TB+723	; I----
LISTV_Top		EQU	BGUI_TB+724	; IS--U
LISTV_ListFont		EQU	BGUI_TB+725	; I-G--
LISTV_ReadOnly		EQU	BGUI_TB+726	; I----
LISTV_MultiSelect	EQU	BGUI_TB+727	; IS--U
LISTV_EntryArray	EQU	BGUI_TB+728	; I----
LISTV_Select		EQU	BGUI_TB+729	; -S--U
LISTV_MakeVisible	EQU	BGUI_TB+730	; -S--U
LISTV_Entry		EQU	BGUI_TB+731	; ---N-
LISTV_SortEntryArray	EQU	BGUI_TB+732	; I----
LISTV_EntryNumber	EQU	BGUI_TB+733	; ---N-
LISTV_TitleHook         EQU	BGUI_TB+734	; I----
LISTV_LastClicked	EQU	BGUI_TB+735	; --G--
LISTV_ThinFrames	EQU	BGUI_TB+736	; I----
LISTV_LastClickedNum	EQU	BGUI_TB+737	; I----           V38
LISTV_NewPosition	EQU	BGUI_TB+738	; ---N-           V38
LISTV_NumEntries	EQU	BGUI_TB+739	; --G--           V38
LISTV_MinEntriesShown	EQU	BGUI_TB+740	; I----           V38
LISTV_SelectMulti	EQU	BGUI_TB+741	; -S--U           V39
LISTV_SelectNotVisible	EQU	BGUI_TB+742	; -S--U           V39
LISTV_SelectMultiNotVisible EQU BGUI_TB+743	; -S--U           V39
LISTV_MultiSelectNoShift EQU	BGUI_TB+744	; IS--U           V39
LISTV_DeSelect		EQU	BGUI_TB+745	; -S--U           V39

** BGUI_TB+746 until BGUI_TB+800 reserved.

**
**	LISTV_Select magic numbers.
**
LISTV_Select_First	EQU	-1				; V38
LISTV_Select_Last	EQU	-2				; V38
LISTV_Select_Next	EQU	-3				; V38
LISTV_Select_Previous	EQU	-4				; V38
LISTV_Select_Top	EQU	-5				; V38
LISTV_Select_Page_Up	EQU	-6				; V38
LISTV_Select_Page_Down	EQU	-7				; V38
LISTV_Select_All	EQU	-8				; V39

**
**	The LISTV_ResourceHook is called as follows:
**
**		lea	hook,a0                 * 'STRUCTURE Hook' pointer
**		lea	lv_object,a2		* Object pointer
**		lea	lvResource,a1		* lvResource pointer
**		jsr	hookFunc		* Call hook function
**		tst.l	d0			* return code in D0
**
   STRUCTURE	lvResource,0
	UWORD	lvr_Command
	APTR	lvr_Entry
   LABEL	lvResource_SIZEOF

** LISTV_ResourceHook commands. **
LVRC_MAKE	EQU	1	; Built the entry.
LVRC_KILL	EQU	2	; Kill the entry.

**
**	The LISTV_DisplayHook and the LISTV_TitleHook are called as follows:
**
**		lea	hook,a0                 * 'STRUCTURE Hook' pointer
**		lea	lv_object,a2		* Object pointer
**		lea	lvRender,a1		* lvRender pointer
**		jsr	hookFunc		* Call hook function
**		tst.l	d0			* return code in D0
**
   STRUCTURE	lvRender,0
	APTR	lvren_RPort		; RastPort to render in.
	APTR	lvren_DrawInfo		; All you need to render.
	STRUCT	lvren_Bounds,ra_SIZEOF	; Bounds to render in.
	APTR	lvren_Entry		; Entry to render.
	UWORD	lvren_State		; See below.
	UWORD	lvren_Flags		; None defined yet.
   LABEL	lvRender_SIZEOF

** Rendering states. **
LVRS_NORMAL		EQU	0
LVRS_SELECTED		EQU	1
LVRS_NORMAL_DISABLED	EQU	2
LVRS_SELECTED_DISABLED	EQU	3

**
**	The LISTV_CompareHook is called as follows:
**
**		lea	hook,a0                 * 'STRUCTURE Hook' pointer
**		lea	lv_object,a2		* Object pointer
**		lea	lvCompare,a1		* lvCompare pointer
**		jsr	hookFunc		* Call hook function
**		tst.l	d0			* return code in D0
**
   STRUCTURE	lvCompare,0
	APTR	lvc_EntryA	; First entry.
	APTR	lvc_EntryB	; Second entry.
   LABEL	lvCompare_SIZEOF

** New Methods. **
LVM_ADDENTRIES	EQU	BGUI_MB+281

** Add listview entries. **
   STRUCTURE	lvmAddEntries,MethodID_SIZEOF	   ; LVM_ADDENTRIES
	APTR	lvma_GInfo			; GadgetInfo
	APTR	lvma_Entries			; Entries to add.
	ULONG	lvma_How			; How to add it.
   LABEL	lvmAddEntries_SIZEOF

** Where to add the entries. **
LVAP_HEAD	EQU	1
LVAP_TAIL	EQU	2
LVAP_SORTED	EQU	3

LVM_ADDSINGLE	EQU	BGUI_MB+282

** Add a single entry. **
   STRUCTURE	lvmAddSingle,MethodID_SIZEOF	   ; LVM_ADDSINGLE
	APTR	lvms_GInfo			; GadgetInfo
	APTR	lvms_Entry			; Entry to add.
	ULONG	lvms_How			; See above.
	ULONG	lvms_Flags			; See below.
   LABEL	lvmAddSingle_SIZEOF

** Flags. **
LVASF_MAKEVISIBLE	EQU	$0001	; Make entry visible.
LVASF_SELECT		EQU	$0002	; Select entry.

** Clear the entire list. (Uses a lvmCommand structure as defined below.) **
LVM_CLEAR	EQU	BGUI_MB+283

LVM_FIRSTENTRY	EQU	BGUI_MB+284
LVM_LASTENTRY	EQU	BGUI_MB+285
LVM_NEXTENTRY	EQU	BGUI_MB+286
LVM_PREVENTRY	EQU	BGUI_MB+287

** Get an entry. **
   STRUCTURE	lvmGetEntry,MethodID_SIZEOF	   ; Any of the above.
	APTR	lvmg_Previous			; Previous entry.
	ULONG	lvmg_Flags			; See below.
   LABEL	lvmGetEntry_SIZEOF

LVGEF_SELECTED	EQU	$0001	; Get selected entries.

LVM_REMENTRY	EQU	BGUI_MB+288

** Remove an entry. **
   STRUCTURE	lvmRemEntry,MethodID_SIZEOF	   ; LVM_REMENTRY
	APTR	lvmr_GInfo			; GadgetInfo
	APTR	lvmr_Entry			; Entry to remove.
   LABEL	lvmRemEntry_SIZEOF

LVM_REFRESH	EQU	BGUI_MB+289
LVM_SORT	EQU	BGUI_MB+290
LVM_LOCKLIST	EQU	BGUI_MB+291
LVM_UNLOCKLIST	EQU	BGUI_MB+292

** Refresh/Sort list. **
   STRUCTURE	lvmCommand,MethodID_SIZEOF ; See above
	APTR	lvmc_GInfo		; GadgetInfo
   LABEL	lvmCommand_SIZEOF

LVM_MOVE	EQU	BGUI_MB+293	; V38

** Move an entry in the list. **
   STRUCTURE	lvmMove,MethodID_SIZEOF ; See above
	APTR	lvmm_GInfo		; GadgetInfo
	APTR	lvmm_Entry		; Entry to move or 0
	ULONG	lvmm_Direction		; Move direction
   LABEL	lvmMove_SIZEOF

** Move directions **
LVMOVE_UP	EQU	0	; Move entry up
LVMOVE_DOWN	EQU	1	; Move entry down
LVMOVE_TOP	EQU	2	; Move entry to the top
LVMOVE_BOTTOM	EQU	3	; Move entry to the bottom

LVM_REPLACE	EQU	BGUI_MB+294	; V39

** Replace an entry by another. **
    STRUCTURE lvmReplace,MethodID_SIZEOF
	APTR  lvmre_GInfo	; GadgetInfo
	APTR  lvmre_OldEntry	; Entry to replace.
	APTR  lvmre_NewEntry	; New entry data.
    LABEL     lvmReplace_SIZEOF

** BGUI_MB+295 until BGUI_MB+320 reserved.

******************************************************************************
**
**	"progressclass" - BOOPSI progression gadget.
**
**	Progression indicator fuel guage.
**
PROGRESS_Min		EQU	BGUI_TB+801	; IS---
PROGRESS_Max		EQU	BGUI_TB+802	; IS---
PROGRESS_Done		EQU	BGUI_TB+803	; ISGNU
PROGRESS_Vertical	EQU	BGUI_TB+804	; I----
PROGRESS_Divisor	EQU	BGUI_TB+805	; I----

** BGUI_TB+806 until BGUI_TB+880 reserved.
** BGUI_MB+321 until BGUI_MB+360 reserved.

******************************************************************************
**
**	"propclass" - BOOPSI proportional gadget.
**
**	GadTools style scroller gadget.
**
PGA_Arrows		EQU	BGUI_TB+881	; I----
PGA_ArrowSize		EQU	BGUI_TB+882	; I----
PGA_DontTarget		EQU	BGUI_TB+883	; PRIVATE!
PGA_ThinFrame		EQU	BGUI_TB+884	; I----
PGA_XenFrame		EQU	BGUI_TB+885	; I----

** BGUI_TB+886 until BGUI_TB+960 reserved.
** BGUI_MB+361 until BGUI_MB+400 reserved.

******************************************************************************
**
**	"stringclass" - BOOPSI string gadget.
**
**	GadTools style string/integer gadget.
**
STRINGA_Tabbed		EQU	BGUI_TB+961	; PRIVATE!
STRINGA_ShiftTabbed	EQU	BGUI_TB+962	; PRIVATE!
STRINGA_MinCharsVisible EQU	BGUI_TB+963	; I----           V39
STRINGA_IntegerMin	EQU	BGUI_TB+964	; IS--U           V39
STRINGA_IntegerMax	EQU	BGUI_TB+965	; IS--U           V39

SM_FORMAT_STRING	EQU	BGUI_MB+401	; V39

** Format the string contents. **
   STRUCTURE	smFormatString,MethodID_SIZEOF	; SM_FORMAT_STRING
	APTR	smfs_GInfo			; GadgetInfo
	APTR	smfs_FStr			; Format string
	ULONG	smfs_Arg1			; Format arg
	; ULONG smfs_Arg2
	; ...
   LABEL	smFormatString_SIZEOF

** BGUI_TB+966 until BGUI_TB+1040 reserved.
** BGUI_MB+402 until BGUI_MB+440 reserved.

******************************************************************************
**
**	RESERVED.
**
** BGUI_TB+1041 until BGUI_TB+1120 reserved.
** BGUI_MB+441 until BGUI_MB+480 reserved.

******************************************************************************
**
**	"pageclass" - BOOPSI paging gadget.
**
**	Gadget to handle pages of gadgets.
**
PAGE_Active		EQU	BGUI_TB+1121	; ISGNU
PAGE_Member		EQU	BGUI_TB+1122	; I----
PAGE_NoBufferRP         EQU	BGUI_TB+1123	; I----
PAGE_Inverted		EQU	BGUI_TB+1124	; I----

** BGUI_TB+1125 until BGUI_TB+1200 reserved.
** BGUI_MB+481 until BGUI_MB+520 reserved.

******************************************************************************
**
**	"mxclass" - BOOPSI mx gadget.
**
**	GadTools style mx gadget.
**
MX_Labels		EQU	BGUI_TB+1201	; I----
MX_Active		EQU	BGUI_TB+1202	; ISGNU
MX_LabelPlace		EQU	BGUI_TB+1203	; I----
MX_DisableButton	EQU	BGUI_TB+1204	; IS--U
MX_EnableButton         EQU	BGUI_TB+1205	; IS--U
MX_TabsObject		EQU	BGUI_TB+1206	; I----
MX_TabsTextAttr         EQU	BGUI_TB+1207	; I----

** BGUI_TB+1208 until BGUI_TB+1280 reserved.
** BGUI_MB+521 until BGUI_MB+560 reserved.

******************************************************************************
**
**	"sliderclass" - BOOPSI slider gadget.
**
**	GadTools style slider gadget.
**
SLIDER_Min		EQU	BGUI_TB+1281	; IS--U
SLIDER_Max		EQU	BGUI_TB+1282	; IS--U
SLIDER_Level		EQU	BGUI_TB+1283	; ISGNU
SLIDER_ThinFrame	EQU	BGUI_TB+1284	; I----
SLIDER_XenFrame         EQU	BGUI_TB+1285	; I----

** BGUI_TB+1286 until BGUI_TB+1360 reserved.
** BGUI_MB+561 until BGUI_MB+600 reserved.

******************************************************************************
**
**	"indicatorclass" - BOOPSI indicator gadget.
**
**	Textual level indicator gadget.
**
INDIC_Min		EQU	BGUI_TB+1361	; I----
INDIC_Max		EQU	BGUI_TB+1362	; I----
INDIC_Level		EQU	BGUI_TB+1363	; IS--U
INDIC_FormatString	EQU	BGUI_TB+1364	; I----
INDIC_Justification	EQU	BGUI_TB+1365	; I----

** Justification **
IDJ_LEFT		EQU	0
IDJ_CENTER		EQU	1
IDJ_RIGHT		EQU	2

** BGUI_TB+1366 until BGUI_TB+1440 reserved.

******************************************************************************
**
**	"externalclass" - BGUI external class interface.
**
EXT_Class		EQU	BGUI_TB+1441	; I----
EXT_ClassID		EQU	BGUI_TB+1442	; I----
EXT_MinWidth		EQU	BGUI_TB+1443	; I----
EXT_MinHeight		EQU	BGUI_TB+1444	; I----
EXT_TrackAttr		EQU	BGUI_TB+1445	; I----
EXT_Object		EQU	BGUI_TB+1446	; --G--
EXT_NoRebuild		EQU	BGUI_TB+1447	; I----

** BGUI_TB+1448 until BGUI_TB+1500 reserved.

*****************************************************************************
**
**	"separatorclass" - BOOPSI separator class.
**
SEP_Horiz		EQU	BGUI_TB+1501	* I----
SEP_Title		EQU	BGUI_TB+1502	* I----
SEP_Thin		EQU	BGUI_TB+1503	* I----
SEP_Highlight		EQU	BGUI_TB+1504	* I----
SEP_CenterTitle         EQU	BGUI_TB+1505	* I----
SEP_Recessed		EQU	BGUI_TB+1506	* I----           V39

* BGUI_TB+1507 through BGUI_TB+1760 reserved.

******************************************************************************
**
**	"windowclass" - BOOPSI window class.
**
**	This class creates and maintains an intuition window.
**
WINDOW_Position         EQU	BGUI_TB+1761	; I----
WINDOW_ScaleWidth	EQU	BGUI_TB+1762	; I----
WINDOW_ScaleHeight	EQU	BGUI_TB+1763	; I----
WINDOW_LockWidth	EQU	BGUI_TB+1764	; I----
WINDOW_LockHeight	EQU	BGUI_TB+1765	; I----
WINDOW_PosRelBox	EQU	BGUI_TB+1766	; I----
WINDOW_Bounds		EQU	BGUI_TB+1767	; ISG--
** BGUI_TB+1768 until BGUI_TB+1770 reserved.
WINDOW_DragBar		EQU	BGUI_TB+1771	; I----
WINDOW_SizeGadget	EQU	BGUI_TB+1772	; I----
WINDOW_CloseGadget	EQU	BGUI_TB+1773	; I----
WINDOW_DepthGadget	EQU	BGUI_TB+1774	; I----
WINDOW_SizeBottom	EQU	BGUI_TB+1775	; I----
WINDOW_SizeRight	EQU	BGUI_TB+1776	; I----
WINDOW_Activate         EQU	BGUI_TB+1777	; I----
WINDOW_RMBTrap		EQU	BGUI_TB+1778	; I----
WINDOW_SmartRefresh	EQU	BGUI_TB+1779	; I----
WINDOW_ReportMouse	EQU	BGUI_TB+1780	; I----
WINDOW_Borderless	EQU	BGUI_TB+1781	; I----           V39
WINDOW_Backdrop         EQU	BGUI_TB+1782	; I----           V39
WINDOW_ShowTitle	EQU	BGUI_TB+1783	; I----           V39
** BGUI_TB+1784 until BGUI_TB+1790 reserved.
WINDOW_IDCMP		EQU	BGUI_TB+1791	; I----
WINDOW_SharedPort	EQU	BGUI_TB+1792	; I----
WINDOW_Title		EQU	BGUI_TB+1793	; IS--U
WINDOW_ScreenTitle	EQU	BGUI_TB+1794	; IS--U
WINDOW_MenuStrip	EQU	BGUI_TB+1795	; I-G--
WINDOW_MasterGroup	EQU	BGUI_TB+1796	; I----
WINDOW_Screen		EQU	BGUI_TB+1797	; I----
WINDOW_PubScreenName	EQU	BGUI_TB+1798	; I----
WINDOW_UserPort         EQU	BGUI_TB+1799	; --G--
WINDOW_SigMask		EQU	BGUI_TB+1800	; --G--
WINDOW_IDCMPHook	EQU	BGUI_TB+1801	; I----
WINDOW_VerifyHook	EQU	BGUI_TB+1802	; I----
WINDOW_IDCMPHookBits	EQU	BGUI_TB+1803	; I----
WINDOW_VerifyHookBits	EQU	BGUI_TB+1804	; I----
WINDOW_Font		EQU	BGUI_TB+1805	; I----
WINDOW_FallBackFont	EQU	BGUI_TB+1806	; I----
WINDOW_HelpFile         EQU	BGUI_TB+1807	; IS---
WINDOW_HelpNode         EQU	BGUI_TB+1808	; IS---
WINDOW_HelpLine         EQU	BGUI_TB+1809	; IS---
WINDOW_AppWindow	EQU	BGUI_TB+1810	; I----
WINDOW_AppMask		EQU	BGUI_TB+1811	; --G--
WINDOW_UniqueID         EQU	BGUI_TB+1812	; I----
WINDOW_Window		EQU	BGUI_TB+1813	; --G--
WINDOW_HelpText         EQU	BGUI_TB+1814	; IS---
WINDOW_NoBufferRP	EQU	BGUI_TB+1815	; I----
WINDOW_AutoAspect	EQU	BGUI_TB+1816	; I----
WINDOW_PubScreen	EQU	BGUI_TB+1817	; IS---           V39
WINDOW_CloseOnEsc	EQU	BGUI_TB+1818	; IS---           V39
WINDOW_ActNext		EQU	BGUI_TB+1819	; -----           V39
WINDOW_ActPrev		EQU	BGUI_TB+1820	; -----           V39
WINDOW_NoVerify         EQU	BGUI_TB+1821	; -S---           V39

** BGUI_TB+1822 until BGUI_TB+1860 reserved.

** Possible window positions. **
POS_CENTERSCREEN	EQU	0	; Center on the screen
POS_CENTERMOUSE         EQU	1	; Center under the mouse
POS_TOPLEFT		EQU	2	; Top-left of the screen

** New methods **

WM_OPEN         EQU	BGUI_MB+601	; Open the window
WM_CLOSE	EQU	BGUI_MB+602	; Close the window
WM_SLEEP	EQU	BGUI_MB+603	; Put the window to sleep
WM_WAKEUP	EQU	BGUI_MB+604	; Wake the window up
WM_HANDLEIDCMP	EQU	BGUI_MB+605	; Call the IDCMP handler

** Pre-defined WM_HANDLEIDCMP return codes. **
WMHI_CLOSEWINDOW	EQU	$00010000	; The close gadget was clicked
WMHI_NOMORE		EQU	$00020000	; No more messages
WMHI_INACTIVE		EQU	$00030000	; The window was de-activated
WMHI_ACTIVE		EQU	$00040000	; The window was activated
WMHI_IGNORE		EQU	$FFFFFFFF	; Like it say's: ignore

WM_GADGETKEY		EQU	BGUI_MB+606

** Add a hotkey to a gadget. **
   STRUCTURE	wmGadgetKey,MethodID_SIZEOF	   ; WM_GADGETKEY
	APTR	wmgk_Requester			; When used in a requester
	APTR	wmgk_Object			; Object to activate
	APTR	wmgk_Key			; Key that triggers activ.
   LABEL	wmGadgetKey_SIZEOF

WM_KEYACTIVE		EQU	BGUI_MB+607
WM_KEYINPUT		EQU	BGUI_MB+608

** Send with the WM_KEYACTIVE and WM_KEYINPUT methods. **
   STRUCTURE	wmKeyInput,MethodID_SIZEOF ; WM_KEYACTIVE/WM_KEYINPUT
	APTR	wmki_GInfo		; GadgetInfo
	APTR	wmki_IEvent		; Input event
	ULONG	wmki_ID                 ; Storage for the object ID
	APTR	wmki_Key		; Key that triggered activation.
   LABEL	wmKeyInput_SIZEOF

** Possible WM_KEYACTIVE and WM_KEYINPUT return codes. **
WMKF_MEACTIVE		EQU	0	; Object went active.
WMKF_CANCEL		EQU	$0001	; Key activation canceled.
WMKF_VERIFY		EQU	$0002	; Key activation confirmed
WMKF_ACTIVATE		EQU	$0004	; ActivateGadget() object

WM_KEYINACTIVE		EQU	BGUI_MB+609

** De-activate a key session. **
   STRUCTURE	wmKeyInActive,MethodID_SIZEOF	   ; WM_KEYINACTIVE
	APTR	wmkia_GInfo			; GadgetInfo
   LABEL	wmKeyInActive_SIZEOF

WM_DISABLEMENU		EQU	BGUI_MB+610
WM_CHECKITEM		EQU	BGUI_MB+611

** Disable/Enable a menu or Set/Clear a checkit item. **
   STRUCTURE	wmMenuAction,MethodID_SIZEOF	   ; WM_DISABLEMENU/WM_CHECKITEM
	ULONG	wmma_MenuID			; Menu it's ID
	ULONG	wmma_Set			; TRUE = set, FALSE = clear
   LABEL	wmMenuAction_SIZEOF

WM_MENUDISABLED         EQU	BGUI_MB+612
WM_ITEMCHECKED		EQU	BGUI_MB+613

   STRUCTURE	wmMenuQuery,MethodID_SIZEOF	   ; WM_MENUDISABLED/WM_ITEMCHECKED
	ULONG	wmmq_MenuID			; Menu it's ID
   LABEL	wmMenuQuery_SIZEOF

WM_TABCYCLE_ORDER	EQU	BGUI_MB+614

** Set the tab-cycling order. **
   STRUCTURE	wmTabCycleOrder,MethodID_SIZEOF    ; WM_TABCYCLE_ORDER
	APTR	wtco_Object1
	; APTR	wtco_Object2
	; ...
	; NULL
   LABEL	wmTabCycleOrder_SIZEOF

** Obtain the app message. **
WM_GETAPPMSG		EQU	BGUI_MB+615

WM_ADDUPDATE		EQU	BGUI_MB+616

** Add object to the update notification list. **
   STRUCTURE	wmAddUpdate,MethodID_SIZEOF	   ; WM_ADDUPDATE
	ULONG	wmau_SourceID			; ID of source object.
	APTR	wmau_Target			; Target object.
	APTR	wmau_MapList			; Attribute map-list.
   LABEL	wmAddUpdate_SIZEOF

WM_REPORT_ID		EQU	BGUI_MB+617	; V38

** Report a return code from a IDCMP/Verify hook. **
   STRUCTURE	wmReportID,MethodID_SIZEOF	; WM_REPORT_ID
	ULONG	wmri_ID                         ; ID to report.
	ULONG	wmri_Flags			; See below.
   LABEL	wmReportID_SIZEOF

** Flags. **
WMRIF_DOUBLE_CLICK	EQU	$0001		; Simulate double-click.

** Get the window which signalled us. **
WM_GET_SIGNAL_WINDOW	EQU	BGUI_MB+618	; V39

** BGUI_MB+619 until BGUI_MB+660 reserved.

******************************************************************************
**
**	"commodityclass" - BOOPSI commodity class.
**
COMM_Name		EQU	BGUI_TB+1861	; I----
COMM_Title		EQU	BGUI_TB+1862	; I----
COMM_Description	EQU	BGUI_TB+1863	; I----
COMM_Unique		EQU	BGUI_TB+1864	; I----
COMM_Notify		EQU	BGUI_TB+1865	; I----
COMM_ShowHide		EQU	BGUI_TB+1866	; I----
COMM_Priority		EQU	BGUI_TB+1867	; I----
COMM_SigMask		EQU	BGUI_TB+1868	; --G--
COMM_ErrorCode		EQU	BGUI_TB+1869	; --G--

** BGUI_TB+1870 until BGUI_TB+1940 reserved.

** New Methods. **

CM_ADDHOTKEY		EQU	BGUI_MB+661

** Add a hot-key to the broker. **
   STRUCTURE	cmAddHotkey,MethodID_SIZEOF	   ; CM_ADDHOTKEY
	APTR	cah_InputDescription		; Key input description.
	ULONG	cah_KeyID			; Key command ID.
	ULONG	cah_Flags			; See below.
   LABEL	cmAddHotkey_SIZEOF

** Flags. **
CAHF_DISABLED	EQU	$0001	; The key is added but won't work.

CM_REMHOTKEY		EQU	BGUI_MB+662	; Remove a key.
CM_DISABLEHOTKEY	EQU	BGUI_MB+663	; Disable a key.
CM_ENABLEHOTKEY         EQU	BGUI_MB+664	; Enable a key.

** Do a key command. **
   STRUCTURE	cmDoKeyCommand,MethodID_SIZEOF	   ; See above.
	ULONG	cdkc_KeyID			; ID of the key.
   LABEL	cmDoKeyCommand_SIZEOF

CM_ENABLEBROKER         EQU	BGUI_MB+665	; Enable broker.
CM_DISABLEBROKER	EQU	BGUI_MB+666	; Disable broker.

CM_MSGINFO		EQU	BGUI_MB+667

** Obtain info from a CxMsg. **
   STRUCTURE	cmMsgInfo,MethodID_SIZEOF  ; CM_MSGINFO
	ULONG	cmi_InfoType		; Storage for CxMsgType() result.
	ULONG	cmi_InfoID		; Storage for CxMsgID() result.
	ULONG	cmi_InfoData		; Storage for CxMsgData() result.
   LABEL	cmMsgInfo_SIZEOF

** Possible CM_MSGINFO return codes. **
CMMI_NOMORE	EQU	$FFFFFFFF	; No more messages.

** BGUI_MB+668 until BGUI_MB+700 reserved.

**
**	CM_ADDHOTKEY error codes obtainable using
**	the COMM_ErrorCode attribute.
**
CMERR_OK		EQU	0	; OK. No problems.
CMERR_NO_MEMORY         EQU	1	; Out of memory.
CMERR_KEYID_IN_USE	EQU	2	; Key ID already used.
CMERR_KEY_CREATION	EQU	3	; Key creation failure.
CMERR_CXOBJERROR	EQU	4	; CxObjError() reported failure.

******************************************************************************
**
**	"filereqclass.c" - BOOPSI Asl filerequester class.
**
FRQ_Drawer		EQU	BGUI_TB+1941	; --G--
FRQ_File		EQU	BGUI_TB+1942	; --G--
FRQ_Pattern		EQU	BGUI_TB+1943	; --G--
FRQ_Path		EQU	BGUI_TB+1944	; --G--
FRQ_Left		EQU	BGUI_TB+1945	; --G--
FRQ_Top                 EQU	BGUI_TB+1946	; --G--
FRQ_Width		EQU	BGUI_TB+1947	; --G--
FRQ_Height		EQU	BGUI_TB+1948	; --G--
**
**	In addition to the above defined attributes are all
**	ASL filerequester attributes ISG-U.
**

** BGUI_TB+1949 until BGUI_TB+2020 reserved.

**
**	Error codes which the SetAttrs() and DoMethod()
**	call's can return.
**
FRQ_OK			EQU	0	; OK. No problems.
FRQ_CANCEL		EQU	1	; The requester was cancelled.
FRQ_ERROR_NO_MEM	EQU	2	; Out of memory.
FRQ_ERROR_NO_FREQ	EQU	3	; Unable to allocate a requester.

** New Methods **

FRM_DOREQUEST		EQU	BGUI_MB+701	; Show Requester.

** BGUI_MB+702 until BGUI_MB+740 reserved.

	ENDC	; LIBRARIES_BGUI_I
