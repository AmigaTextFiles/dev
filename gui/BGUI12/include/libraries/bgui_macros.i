		IFND	LIBRARIES_BGUI_MACROS_I
LIBRARIES_BGUI_MACROS_I SET	1
**
**	$VER: libraries/bgui_macros.i 38.4 (11.6.95)
**	bgui.library macros.
**
**	(C) Copyright 1993-1995 Jaba Development.
**	(C) Copyright 1993-1995 Jan van den Baard.
**	    All Rights Reserved.
**

		IFND	LIBRARIES_BGUI_I
		include 'libraries/bgui.i'
		ENDC	; LIBARIES_BGUI_I

		IFND	LIBRARIES_BGUI_OFFSETS_I
		include 'libraries/bgui.i'
		ENDC	; LIBRARIES_BGUI_OFFSETS_I

		;
		;	STACK arg
		;
		;	If 'arg' is a valid argument this macro will
		;	put it on the stack increasing the constant
		;	'STACKSIZE' with 4. This macro is used by the
		;	DOMETHOD macro below.
		;
STACK		MACRO
		IFNC	'\1',''
		move.l	\1,-(sp)
STACKSIZE	SET	STACKSIZE+4
		ENDC
		ENDM

		;
		;	DOMETHOD object,methodID[,...]
		;
		;	This macro invokes method 'methodID' on object 'object'.
		;	Upto eight extra arguments may be passed to the macro.
		;	This should be suffiecient for most methods.
		;
DOMETHOD	MACRO
		IFLT	NARG-2
		FAIL	'Need at least TWO parameters in the "DOMETHOD" macro!'
		MEXIT
		ENDC
STACKSIZE	SET	0
		movem.l a0-a2,-(sp)		; save regs
		STACK	\9
		STACK	\8
		STACK	\7
		STACK	\6
		STACK	\5
		STACK	\4
		STACK	\3
		STACK	\2
		move.l	\1,a2			; object in a2
		move.l	sp,a1			; msg in a1
		move.l	-4(a2),a0		; class in a0
		pea	DOMETHOD\@(pc)		; return address class dispatcher
		move.l	8(a0),-(sp)		; stack dispatcher entry
		rts				; call dispatcher
DOMETHOD\@	lea.l	STACKSIZE(sp),sp	; align stack
		movem.l (sp)+,a0-a2		; restore regs
		ENDM

		;
		;	DOGADGETMETHOD object,win,req,methodID[,...]
		;
		;	This macro invokes method 'methodID' on object 'object'.
		;	Upto six extra arguments may be passed to the macro.
		;	This should be suffiecient for most methods. This call
		;	uppon BGUI_DoGadgetMethodA so BGUI must be in a6!
		;
DOGADGETMETHOD	MACRO
		IFLT	NARG-4
		FAIL	'Need at least FOUR parameters in the "DOGADGETMETHOD" macro!'
		MEXIT
		ENDC
STACKSIZE	SET	0
		movem.l a0-a3,-(sp)		; save regs
		STACK	\9
		STACK	\8
		STACK	\7
		STACK	\6
		STACK	\5
		STACK	\4
		move.l	\1,a0			; object in a0
		move.l	\2,a1			; window in a1
		move.l	\3,a2			; requester in a2
		move.l	sp,a3			; msg in a3
		jsr	_LVOBGUI_DoGadgetMethodA(a6)
		lea.l	STACKSIZE(sp),sp	; align stack
		movem.l (sp)+,a0-a3		; restore regs
		ENDM

		;
		;	INIT
		;
		;	This macro sets things up for a object creation
		;	macro.
		;
INIT		MACRO
		movem.l d2/a2,-(sp)
		move.l	sp,a2			; save stack address
		move.l	#TAG_DONE,-(sp)
		ENDM

		;
		;	EXIT
		;
		;	This macro sets things back to their original
		;	state after an object creation.
		;
EXIT		MACRO
		move.l	a2,sp			; put pack stack address
		movem.l (sp)+,d2/a2
		ENDM

		;
		;	SC arg
		;
		;	Put the argument of this macro on the stack
		;	as a constant if it is a valid argument.
		;
SC		MACRO
		IFNC	'\1',''
		IFC	'\1','0'
		clr.l	-(sp)
		ELSEIF
		move.l	#\1,-(sp)
		ENDC
		ENDC
		ENDM

		;
		;	SV arg
		;
		;	Put the argument of this macro on the stack
		;	if it is a valid argument.
		;
SV		MACRO
		IFNC	'\1',''
		IFC	'\1','#0'
		clr.l	-(sp)
		ELSEIF
		move.l	\1,-(sp)
		ENDC
		ENDC
		ENDM

		;
		;	PUTC arg1[,...,arg15]
		;
		;	Put upto 15 arguments as constants on the stack.
		;
PUTC		MACRO
		SC	\F
		SC	\E
		SC	\D
		SC	\C
		SC	\B
		SC	\A
		SC	\9
		SC	\8
		SC	\7
		SC	\6
		SC	\5
		SC	\4
		SC	\3
		SC	\2
		SC	\1
		ENDM

		;
		;	PUTV arg1[,...,arg15]
		;
		;	Put upto 15 arguments on the stack.
		;
PUTV		MACRO
		SV	\F
		SV	\E
		SV	\D
		SV	\C
		SV	\B
		SV	\A
		SV	\9
		SV	\8
		SV	\7
		SV	\6
		SV	\5
		SV	\4
		SV	\3
		SV	\2
		SV	\1
		ENDM

******************************************************************************
*	General object creation macros.
******************************************************************************

INITOBJ         MACRO	; type
		INIT
		moveq.l #\1,d2
		ENDM

HGroupObject	MACRO
		INITOBJ BGUI_GROUP_GADGET
		PUTC	GROUP_Inverted,1
		ENDM

VGroupObject	MACRO
		INITOBJ BGUI_GROUP_GADGET
		PUTC	GROUP_Style,GRSTYLE_VERTICAL,GROUP_Inverted,1
		ENDM

ButtonObject	MACRO
		INITOBJ BGUI_BUTTON_GADGET
		ENDM

ToggleObject	MACRO
		INITOBJ BGUI_BUTTON_GADGET
		PUTC	GA_ToggleSelect,1
		ENDM

CycleObject	MACRO
		INITOBJ BGUI_CYCLE_GADGET
		ENDM

CheckBoxObject	MACRO
		INITOBJ BGUI_CHECKBOX_GADGET
		ENDM

InfoObject	MACRO
		INITOBJ BGUI_INFO_GADGET
		ENDM

StringObject	MACRO
		INITOBJ BGUI_STRING_GADGET
		ENDM

PropObject	MACRO
		INITOBJ BGUI_PROP_GADGET
		ENDM

IndicatorObject MACRO
		INITOBJ BGUI_INDICATOR_GADGET
		ENDM

ProgressObject	MACRO
		INITOBJ BGUI_PROGRESS_GADGET
		ENDM

SliderObject	MACRO
		INITOBJ BGUI_SLIDER_GADGET
		ENDM

PageObject	MACRO
		INITOBJ BGUI_PAGE_GADGET
		PUTC	PAGE_Inverted,1
		ENDM

MxObject	MACRO
		INITOBJ BGUI_MX_GADGET
		ENDM

ListviewObject	MACRO
		INITOBJ BGUI_LISTVIEW_GADGET
		ENDM

ExternalObject	MACRO
		INITOBJ BGUI_EXTERNAL_GADGET
		PUTC	GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0
		ENDM

SeperatorObject MACRO
		INITOBJ BGUI_SEPERATOR_GADGET
		ENDM

WindowObject	MACRO
		INITOBJ BGUI_WINDOW_OBJECT
		ENDM

FileReqObject	MACRO
		INITOBJ BGUI_FILEREQ_OBJECT
		ENDM

CommodityObject MACRO
		INITOBJ BGUI_COMMODITY_OBJECT
		ENDM

EndObject	MACRO
		move.l	sp,a0
		move.l	d2,d0
		jsr	_LVOBGUI_NewObjectA(a6)
		EXIT
		ENDM

** Typo
SeparatorObject MACRO
		INITOBJ BGUI_SEPARATOR_GADGET
		ENDM

******************************************************************************
*	Label creation.
******************************************************************************

xLabel		MACRO	; label
		PUTC	LAB_Label,\1
		ENDM

UScoreLabel	MACRO	; label,uchar
		PUTC	LAB_Underscore,\2
		PUTC	LAB_Label,\1
		ENDM

Style		MACRO	; style
		PUTC	LAB_Style,\1
		ENDM

Place		MACRO	; place
		PUTC	LAB_Place,\1
		ENDM

******************************************************************************
*	Frames.
******************************************************************************
ButtonFrame	MACRO
		PUTC	FRM_Type,FRTYPE_BUTTON
		ENDM

RidgeFrame	MACRO
		PUTC	FRM_Type,FRTYPE_RIDGE
		ENDM

DropBoxFrame	MACRO
		PUTC	FRM_Type,FRTYPE_DROPBOX
		ENDM

NeXTFrame	MACRO
		PUTC	FRM_Type,FRTYPE_NEXT
		ENDM

RadioFrame	MACRO
		PUTC	FRM_Type,FRTYPE_RADIOBUTTON
		ENDM

XenFrame	MACRO
		PUTC	FRM_Type,FRTYPE_XEN_BUTTON
		ENDM

FrameTitle	MACRO	; title
		PUTC	FRM_Title,\1
		ENDM

ShineRaster	MACRO
		PUTC	FRM_BackFill,SHINE_RASTER
		ENDM

ShadowRaster	MACRO
		PUTC	FRM_BackFill,SHADOW_RASTER
		ENDM

ShineShadowRaster MACRO
		PUTC	FRM_BackFill,SHINE_SHADOW_RASTER
		ENDM

FillRaster	MACRO
		PUTC	FRM_BackFill,FILL_RASTER
		ENDM

ShineFillRaster MACRO
		PUTC	FRM_BackFill,SHINE_FILL_RASTER
		ENDM

ShadowFillRaster MACRO
		PUTC	FRM_BackFill,SHADOW_FILL_RASTER
		ENDM

ShineBlock	MACRO
		PUTC	FRM_BackFill,SHINE_BLOCK
		ENDM

ShadowBlock	MACRO
		PUTC	FRM_BackFill,SHADOW_BLOCK
		ENDM

******************************************************************************
*      Vector images.
******************************************************************************

GetPath         MACRO
		PUTC	VIT_BuiltIn,BUILTIN_GETPATH
		ENDM

GetFile         MACRO
		PUTC	VIT_BuiltIn,BUILTIN_GETFILE
		ENDM

CheckMark	MACRO
		PUTC	VIT_BuiltIn,BUILTIN_CHECKMARK
		ENDM

PopUp		MACRO
		PUTC	VIT_BuiltIn,BUILTIN_POPUP
		ENDM

ArrowUp         MACRO
		PUTC	VIT_BuiltIn,BUILTIN_ARROW_UP
		ENDM

ArrowDown	MACRO
		PUTC	VIT_BuiltIn,BUILTIN_ARROW_DOWN
		ENDM

ArrowLeft	MACRO
		PUTC	VIT_BuiltIn,BUILTIN_ARROW_LEFT
		ENDM

ArrowRight	MACRO
		PUTC	VIT_BuiltIn,BUILTIN_ARROW_RIGHT
		ENDM

******************************************************************************
*      Group class macros.
******************************************************************************

StartMember	MACRO
		ENDM

EndMember	MACRO	; [macro1,arg1,macro2,arg2,macro3,...]
		clr.l	-(sp)
		clr.l	-(sp)
		\1	\2
		\3	\4
		\5	\6
		\7	\8
		\9	\A
		\B	\C
		\D	\E
		PUTV	#GROUP_Member,d0
		ENDM

Spacing         MACRO	; spacing
		PUTC	GROUP_Spacing,\1
		ENDM

HOffset         MACRO	; offset
		PUTC	GROUP_HorizOffset,\1
		ENDM

VOffset         MACRO	; offset
		PUTC	GROUP_VertOffset,\1
		ENDM

LOffset         MACRO	; offset
		PUTC	GROUP_LeftOffset,\1
		ENDM

ROffset         MACRO	; offset
		PUTC	GROUP_RightOffset,\1
		ENDM

TOffset         MACRO	; offset
		PUTC	GROUP_TopOffset,\1
		ENDM

BOffset         MACRO	; offset
		PUTC	GROUP_BottomOffset,\1
		ENDM

VarSpace	MACRO	; weight
		PUTC	GROUP_SpaceObject,\1
		ENDM

EqualWidth	MACRO
		PUTC	GROUP_EqualWidth,1
		ENDM

EqualHeight	MACRO
		PUTC	GROUP_EqualHeight,1
		ENDM

******************************************************************************
*      Layout macros.
******************************************************************************

FixMinWidth	MACRO
		PUTC	LGO_FixMinWidth,1
		ENDM

FixMinHeight	MACRO
		PUTC	LGO_FixMinHeight,1
		ENDM

Weight		MACRO	; weight
		PUTC	LGO_Weight,\1
		ENDM

FixWidth	MACRO	; width
		PUTC	LGO_FixWidth,\1
		ENDM

FixHeight	MACRO	; height
		PUTC	LGO_FixHeight,\1
		ENDM

Align		MACRO
		PUTC	LGO_Align,1
		ENDM

FixMinSize	MACRO
		PUTC	LGO_FixMinWidth,1,LGO_FixMinHeight,1
		ENDM

FixSize         MACRO	; width, height
		PUTC	LGO_FixWidth,\1,LGO_FixHeight,\2
		ENDM

NoAlign         MACRO
		PUTC	LGO_NoAlign,1
		ENDM

******************************************************************************
*      Page class macros.
******************************************************************************

PageMember	MACRO
		ENDM

EndPageMember	MACRO
		PUTV	#PAGE_Member,d0
		ENDM

******************************************************************************
*      Window class macros.
******************************************************************************

MasterGroup	MACRO
		ENDM

EndMaster	MACRO
		PUTV	#WINDOW_MasterGroup,d0
		ENDM

******************************************************************************
*	"Quick" button creation macros.
******************************************************************************

Button		MACRO	; label, id
		ButtonObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\2
			PUTC	FRM_Type,FRTYPE_BUTTON
		EndObject
		ENDM

KeyButton	MACRO	; label, id
		ButtonObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\2
			PUTC	FRM_Type,FRTYPE_BUTTON
		EndObject
		ENDM

Toggle		MACRO	; label, state, id
		ToggleObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	GA_Selected,\2
			PUTC	FRM_Type,FRTYPE_BUTTON
		EndObject
		ENDM

KeyToggle	MACRO	; label, state, id
		ToggleObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	GA_Selected,\2
			PUTC	FRM_Type,FRTYPE_BUTTON
		EndObject
		ENDM

XenButton	MACRO	; label, id
		ButtonObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\2
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
		EndObject
		ENDM

XenKeyButton	MACRO	; label, id
		ButtonObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\2
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
		EndObject
		ENDM

XenToggle	MACRO	; label, state, id
		ToggleObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	GA_Selected,\2
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
		EndObject
		ENDM

XenKeyToggle	MACRO	; label, state, id
		ToggleObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	GA_Selected,\2
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
		EndObject
		ENDM

******************************************************************************
*	"Quick" cycle creation macros.
******************************************************************************

Cycle		MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
		EndObject
		ENDM

KeyCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
		EndObject
		ENDM

XenCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
		EndObject
		ENDM

XenKeyCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
		EndObject
		ENDM

PopCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
			PUTC	CYC_Popup,1
		EndObject
		ENDM

KeyPopCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
			PUTC	CYC_Popup,1
		EndObject
		ENDM

XenPopCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
			PUTC	CYC_Popup,1
		EndObject
		ENDM

XenKeyPopCycle	MACRO	; label, labels, active, id
		CycleObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\4
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
			PUTC	CYC_Active,\3
			PUTC	CYC_Labels,\2
			PUTC	CYC_Popup,1
		EndObject
		ENDM

******************************************************************************
*	"Quick" checkbox creation macros.
******************************************************************************

CheckBox	MACRO	; label, state, id
		CheckBoxObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	FRM_EdgesOnly,1
			PUTC	GA_Selected,\2
		EndObject
		ENDM

KeyCheckBox	MACRO	; label, state, id
		CheckBoxObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	FRM_EdgesOnly,1
			PUTC	GA_Selected,\2
		EndObject
		ENDM

XenCheckBox	MACRO	; label, state, id
		CheckBoxObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
			PUTC	FRM_EdgesOnly,1
			PUTC	GA_Selected,\2
		EndObject
		ENDM

XenKeyCheckBox	MACRO	; label, state, id
		CheckBoxObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	FRM_Type,FRTYPE_XEN_BUTTON
			PUTC	FRM_EdgesOnly,1
			PUTC	GA_Selected,\2
		EndObject
		ENDM

******************************************************************************
*	"Quick" info object creation macros.
******************************************************************************

InfoFixed	MACRO	; label, text, args, numlines
		InfoObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	FRM_Recessed,1
			PUTC	INFO_TextFormat,\2
			PUTC	INFO_Args,\3
			PUTC	INFO_MinLines,\4
			PUTC	INFO_FixTextWidth,1
		EndObject
		ENDM

InfoObj         MACRO	; label, text, args, numlines
		InfoObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	FRM_Recessed,1
			PUTC	INFO_TextFormat,\2
			PUTC	INFO_Args,\3
			PUTC	INFO_MinLines,\4
		EndObject
		ENDM

******************************************************************************
*	"Quick" string/integer creation macros.
******************************************************************************

String		MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	STRINGA_TextVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

KeyString	MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	STRINGA_TextVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

TabString	MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	GA_TabCycle,1
			PUTC	STRINGA_TextVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

TabKeyString	MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	GA_TabCycle,1
			PUTC	STRINGA_TextVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

Integer         MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	STRINGA_LongVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

KeyInteger	MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	STRINGA_LongVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

TabInteger	MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	GA_TabCycle,1
			PUTC	STRINGA_LongVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

TabKeyInteger	MACRO	; label, contents, maxchars, id
		StringObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_RIDGE
			PUTC	GA_ID,\4
			PUTC	GA_TabCycle,1
			PUTC	STRINGA_LongVal,\2
			PUTC	STRINGA_MaxChars,\3
		EndObject
		ENDM

******************************************************************************
*	"Quick" scroller creation macros.
******************************************************************************

HorizScroller	MACRO	; label, top, total, visible, id
		PropObject
			PUTC	LAB_Label,\1
			PUTC	PGA_Top,\2
			PUTC	PGA_Total,\3
			PUTC	PGA_Visible,\4
			PUTC	PGA_Freedom,FREEHORIZ
			PUTC	GA_ID,\5
			PUTC	PGA_Arrows,1
		EndObject
		ENDM

VertScroller	MACRO	; label, top, total, visible, id
		PropObject
			PUTC	LAB_Label,\1
			PUTC	PGA_Top,\2
			PUTC	PGA_Total,\3
			PUTC	PGA_Visible,\4
			PUTC	GA_ID,\5
			PUTC	PGA_Arrows,1
		EndObject
		ENDM

KeyHorizScroller MACRO	 ; label, top, total, visible, id
		PropObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	PGA_Top,\2
			PUTC	PGA_Total,\3
			PUTC	PGA_Visible,\4
			PUTC	PGA_Freedom,FREEHORIZ
			PUTC	GA_ID,\5
			PUTC	PGA_Arrows,1
		EndObject
		ENDM

KeyVertScroller MACRO	; label, top, total, visible, id
		PropObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	PGA_Top,\2
			PUTC	PGA_Total,\3
			PUTC	PGA_Visible,\4
			PUTC	GA_ID,\5
			PUTC	PGA_Arrows,1
		EndObject
		ENDM

******************************************************************************
*	"Quick" indicator creation macros.
******************************************************************************

Indicator	MACRO	; min, max, level, just
		IndicatorObject
			PUTC	INDIC_Min,\1
			PUTC	INDIC_Max,\2
			PUTC	INDIC_Level,\3
			PUTC	INDIC_Justification,\4
		EndObject
		ENDM

IndicatorFormat MACRO	; min, max, level, just, fstring
		IndicatorObject
			PUTC	INDIC_Min,\1
			PUTC	INDIC_Max,\2
			PUTC	INDIC_Level,\3
			PUTC	INDIC_Justification,\4
			PUTC	INDIC_FormatString,\5
		EndObject
		ENDM

******************************************************************************
*	"Quick" progress creation macros.
******************************************************************************

HorizProgress	MACRO	; label, min, max, done
		ProgressObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	FRM_Recessed,1
			PUTC	PROGRESS_Min,\2
			PUTC	PROGRESS_Max,\3
			PUTC	PROGRESS_Done,\4
		EndObject
		ENDM

VertProgress   MACRO   ; label, min, max, done
		ProgressObject
			PUTC	LAB_Label,\1
			PUTC	FRM_Type,FRTYPE_BUTTON
			PUTC	FRM_Recessed,1
			PUTC	PROGRESS_Min,\2
			PUTC	PROGRESS_Max,\3
			PUTC	PROGRESS_Done,\4
			PUTC	PROGRESS_Vertical,1
		EndObject
		ENDM

******************************************************************************
*	"Quick" slider creation macros.
******************************************************************************

HorizSlider	MACRO	; label, min, max, level, id
		SliderObject
			PUTC	LAB_Label,\1
			PUTC	SLIDER_Min,\2
			PUTC	SLIDER_Max,\3
			PUTC	SLIDER_Level,\4
			PUTC	GA_ID,\5
		EndObject
		ENDM

VertSlider	MACRO	; label, min, max, level, id
		SliderObject
			PUTC	LAB_Label,\1
			PUTC	SLIDER_Min,\2
			PUTC	SLIDER_Max,\3
			PUTC	SLIDER_Level,\4
			PUTC	PGA_Freedom,FREEVERT
			PUTC	GA_ID,\5
		EndObject
		ENDM

KeyHorizSlider	MACRO	; label, min, max, level, id
		SliderObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	SLIDER_Min,\2
			PUTC	SLIDER_Max,\3
			PUTC	SLIDER_Level,\4
			PUTC	GA_ID,\5
		EndObject
		ENDM

KeyVertSlider	MACRO	; label, min, max, level, id
		SliderObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	SLIDER_Min,\2
			PUTC	SLIDER_Max,\3
			PUTC	SLIDER_Level,\4
			PUTC	PGA_Freedom,FREEVERT
			PUTC	GA_ID,\5
		EndObject
		ENDM

******************************************************************************
*	"Quick" mx creation macros.
******************************************************************************

RightMx         MACRO	; label, labels, active, id
		MxObject
			PUTC	GROUP_Style,GRSTYLE_VERTICAL
			PUTC	LAB_Label,\1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	GA_ID,\4
		EndObject
		ENDM

LeftMx		MACRO	; label, labels, active, id
		MxObject
			PUTC	GROUP_Style,GRSTYLE_VERTICAL
			PUTC	LAB_Label,\1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	MX_LabelPlace,PLACE_LEFT
			PUTC	GA_ID,\4
		EndObject
		ENDM

RightMxKey	MACRO	; label, labels, active, id
		MxObject
			PUTC	GROUP_Style,GRSTYLE_VERTICAL
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	GA_ID,\4
		EndObject
		ENDM

LeftMxKey	MACRO	; label, labels, active, id
		MxObject
			PUTC	GROUP_Style,GRSTYLE_VERTICAL
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	MX_LabelPlace,PLACE_LEFT
			PUTC	GA_ID,\4
		EndObject
		ENDM

Tabs		MACRO	; label, labels, active, id
		MxObject
			PUTC	LAB_Label,\1
			PUTC	MX_TabsObject,1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	GA_ID,\4
		EndObject
		ENDM

TabsKey         MACRO	; label, labels, active, id
		MxObject
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	MX_TabsObject,1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	GA_ID,\4
		EndObject
		ENDM

TabsEqual	MACRO	; label, labels, active, id
		MxObject
			PUTC	GROUP_EqualWidth,1
			PUTC	LAB_Label,\1
			PUTC	MX_TabsObject,1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	GA_ID,\4
		EndObject
		ENDM

TabsEqualKey	MACRO	; label, labels, active, id
		MxObject
			PUTC	GROUP_EqualWidth,1
			PUTC	LAB_Underscore,"_"
			PUTC	LAB_Label,\1
			PUTC	MX_TabsObject,1
			PUTC	MX_Labels,\2
			PUTC	MX_Active,\3
			PUTC	GA_ID,\4
		EndObject
		ENDM

******************************************************************************
*	"Quick" listview creation macros.
******************************************************************************

StrListview	MACRO	; label, strings, id
		ListviewObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	LISTV_EntryArray,\2
		EndObject
		ENDM

StrListviewSorted MACRO   ; label, strings, id
		ListviewObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	LISTV_EntryArray,\2
			PUTC	LISTV_SortEntryArray,1
		EndObject
		ENDM

ReadStrListview MACRO	; label, strings
		ListviewObject
			PUTC	LAB_Label,\1
			PUTC	LISTV_EntryArray,\2
			PUTC	LISTV_ReadOnly,1
		EndObject
		ENDM

ReadStrListviewSorted MACRO   ; label, strings
		ListviewObject
			PUTC	LAB_Label,\1
			PUTC	LISTV_EntryArray,\2
			PUTC	LISTV_SortEntryArray,1
			PUTC	LISTV_ReadOnly,1
		EndObject
		ENDM

MultiStrListview MACRO	 ; label, strings, id
		ListviewObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	LISTV_EntryArray,\2
			PUTC	LISTV_MultiSelect,1
		EndObject
		ENDM

MultiStrListviewSorted MACRO   ; label, strings, id
		ListviewObject
			PUTC	LAB_Label,\1
			PUTC	GA_ID,\3
			PUTC	LISTV_EntryArray,\2
			PUTC	LISTV_SortEntryArray,1
			PUTC	LISTV_MultiSelect,1
		EndObject
		ENDM

******************************************************************************
*	"Quick" separator bar creation macros.
******************************************************************************

VertSeparator	MACRO
		SeparatorObject
		EndObject
		ENDM

VertThinSeparator MACRO
		SeparatorObject
			PUTC	SEP_Thin,1
		EndObject
		ENDM

HorizSeparator	MACRO
		SeparatorObject
			PUTC	SEP_Horiz,1
		EndObject
		ENDM

TitleSeparator	MACRO	; title
		SeparatorObject
			PUTC	SEP_Horiz,1
			PUTC	SEP_Title,\1
		EndObject
		ENDM

HTitleSeparator MACRO	; title
		SeparatorObject
			PUTC	SEP_Horiz,1
			PUTC	SEP_Title,\1
			PUTC	SEP_Highlight,1
		EndObject
		ENDM

CTitleSeparator MACRO	; title
		SeparatorObject
			PUTC	SEP_Horiz,1
			PUTC	SEP_Title,\1
			PUTC	SEP_CenterTitle,1
		EndObject
		ENDM

CHTitleSeparator MACRO	 ; title
		SeparatorObject
			PUTC	SEP_Horiz,1
			PUTC	SEP_Title,\1
			PUTC	SEP_Highlight,1
			PUTC	SEP_CenterTitle,1
		EndObject
		ENDM

** Typos
VertSeperator	MACRO
		VertSeparator
		ENDM

VertThinSeperator MACRO
		VertThinSeparator
		ENDM

HorizSeperator	MACRO
		HorizSeparator
		ENDM

TitleSeperator	MACRO
		TitleSeparator
		ENDM

HTitleSeperator MACRO
		HTitleSeparator
		ENDM

CTitleSeperator MACRO
		CTitleSeparator
		ENDM

CHTitleSeperator MACRO
		CHTitleSeparator
		ENDM

******************************************************************************
*	Base class method macros.
******************************************************************************

AddMap		MACRO	; object, target, map
		DOMETHOD \1,#BASE_ADDMAP,\2,\3
		ENDM

AddCondit	MACRO	; object, target, ttag, tdat, ftag, fdat, stag, sdat
		DOMETHOD \1,#BASE_ADDCONDITIONAL,\2,\3,\4,\5,\6,\7,\8
		ENDM

AddHook         MACRO	; object, hook
		DOMETHOD \1,#BASE_ADDHOOK,\2
		ENDM

RemMap		MACRO	; object, target
		DOMETHOD \1,#BASE_REMMAP,\2
		ENDM

RemCondit	MACRO	; object, target
		DOMETHOD \1,#BASE_REMCONDITIONAL,\2
		ENDM

RemHook         MACRO	; object, hook
		DOMETHOD \1,#BASE_REMHOOK,\2
		ENDM

******************************************************************************
*	Listview class method macros.
******************************************************************************

		** Requires BGUIBase in A6!
AddEntry	MACRO	; window, object, entry, how
		DOGADGETMETHOD \2,\1,0,#LVM_ADDSINGLE,0,\3,\4,0
		ENDM

		** Requires BGUIBase in A6!
AddEntryVisible MACRO	; window, object, entry, how
		DOGADGETMETHOD \2,\1,0,#LVM_ADDSINGLE,0,\3,\4,#LVASF_MAKEVISIBLE
		ENDM

		** Requires BGUIBase in A6!
AddEntrySelect	MACRO	; window, object, entry, how
		DOGADGETMETHOD \2,\1,0,#LVM_ADDSINGLE,0,\3,\4,#LVASF_SELECT
		ENDM

		** Requires BGUIBase in A6!
ClearList	MACRO	; window object
		DOGADGETMETHOD \2,\1,0,#LVM_CLEAR,0
		ENDM

FirstEntry	MACRO	; object
		DOMETHOD \1,#LVM_FIRSTENTRY,0,0
		ENDM

FirstSelected	MACRO	; object
		DOMETHOD \1,#LVM_FIRSTENTRY,0,#LVGEF_SELECTED
		ENDM

LastEntry	MACRO	; object
		DOMETHOD \1,#LVM_LASTENTRY,0,0
		ENDM

LastSelected	MACRO	; object
		DOMETHOD \1,#LVM_LASTENTRY,0,#LVGEF_SELECTED
		ENDM

NextEntry	MACRO	; object, last
		DOMETHOD \1,#LVM_NEXTENTRY,\2,0
		ENDM

NextSelected	MACRO	; object, last
		DOMETHOD \1,#LVM_NEXTENTRY,\2,#LVGEF_SELECTED
		ENDM

PrevEntry	MACRO	; object, last
		DOMETHOD \1,#LVM_PREVENTRY,\2,0
		ENDM

PrevSelected	MACRO	; object, last
		DOMETHOD \1,#LVM_PREVENTRY,\2,#LVGEF_SELECTED
		ENDM

RemoveEntry	MACRO	; object, entry
		DOMETHOD \1,#LVM_REMENTRY,0,\2
		ENDM

		** Requires BGUIBase in A6!
RemoveEntryVisible MACRO ; window, object, entry
		DOGADGETMETHOD \2,\1,0,#LVM_REMENTRY,0,\3
		ENDM

		** Requires BGUIBase in A6!
RefreshList	MACRO	; window, object
		DOGADGETMETHOD \2,\1,0,#LVM_REFRESH,0
		ENDM

		** Requires BGUIBase in A6!
SortList	MACRO	; window, object
		DOGADGETMETHOD \2,\1,0,#LVM_SORT,0
		ENDM

LockList	MACRO	; object
		DOMETHOD \1,#LVM_LOCKLIST,0
		ENDM

		** Requires BGUIBase in A6!
UnlockList	MACRO	; window, object
		DOGADGETMETHOD \2,\1,0,#LVM_UNLOCKLIST,0
		ENDM

		** Requires BGUIBase in A6!
MoveEntry	MACRO	; window, object, entry, dir
		DOGADGETMETHOD \2,\1,0,#LVM_MOVE,0,\3,\4
		ENDM

		** Requires BGUIBase in A6!
MoveSelectedEntry MACRO ; window, object, dir
		DOGADGETMETHOD \2,\1,0,#LVM_MOVE,0,0,\3
		ENDM

		** Requires BGUIBase in A6!
ReplaceEntry	MACRO ; window, object, old, new
		DOGADGETMETHOD \2,\1,0,#LVM_REPLACE,0,\3,\4
		ENDM

******************************************************************************
*	Window class method macros.
******************************************************************************

GadgetKey	MACRO	; wobj, gobj, key
		DOMETHOD \1,#WM_GADGETKEY,0,\2,\3
		ENDM

xWindowOpen	MACRO	; wobj
		DOMETHOD \1,#WM_OPEN
		ENDM

WindowClose	MACRO	; wobj
		DOMETHOD \1,#WM_CLOSE
		ENDM

WindowBusy	MACRO	; wobj
		DOMETHOD \1,#WM_SLEEP
		ENDM

WindowReady	MACRO	; wobj
		DOMETHOD \1,#WM_WAKEUP
		ENDM

HandleEvent	MACRO	; wobj
		DOMETHOD \1,#WM_HANDLEIDCMP
		ENDM

DisableMenu	MACRO	; wobj, id, set
		DOMETHOD \1,#WM_DISABLEMENU,\2,\3
		ENDM

CheckItem	MACRO	; wobj, id, set
		DOMETHOD \1,#WM_CHECKITEM,\2,\3
		ENDM

MenuDisabled	MACRO	; wobj, id
		DOMETHOD \1,#WM_MENUDISABLED,\2
		ENDM

ItemChecked	MACRO	; wobj, id
		DOMETHOD \1,#WM_ITEMCHECED,\2
		ENDM

GetAppMsg	MACRO	; wobj
		DOMETHOD \1,#WM_GETAPPMSG
		ENDM

AddUpdate	MACRO	; wobj, id, target, map
		DOMETHOD \1,#WM_ADDUPDATE,\2,\3,\4
		ENDM

GetSignalWindow MACRO	; wobj
		DOMETHOD \1,#WM_GET_SIGNAL_WINDOW
		ENDM

******************************************************************************
*	Commodity class method macros.
******************************************************************************

AddHotKey	MACRO	; broker, desc, id, flags
		DOMETHOD \1,#CM_ADDHOTKEY,\2,\3,\4
		ENDM

RemHotKey	MACRO	; broker, id
		DOMETHOD \1,#CM_REMHOTKEY,\2
		ENDM

DisableHotKey	MACRO	; broker, id
		DOMETHOD \1,#CM_DISABLEHOTKEY,\2
		ENDM

EnableHotKey	MACRO	; broker, id
		DOMETHOD \1,#CM_ENABLEHOTKEY,\2
		ENDM

EnableBroker	MACRO	; broker
		DOMETHOD \1,#CM_ENABLEBROKER
		ENDM

DisableBroker	MACRO	; broker
		DOMETHOD \1,#CM_DISABLEBROKER
		ENDM

MsgInfo         MACRO	; broker, type, id, data
		DOMETHOD \1,#CM_MSGINFO,\2,\3,\4
		ENDM

******************************************************************************
*	FileReq class method macros.
******************************************************************************

DoRequest	MACRO	; object
		DOMETHOD \1,#FRM_DOREQUEST
		ENDM

		ENDC ; LIBRARIES_BGUI_MACROS_I
