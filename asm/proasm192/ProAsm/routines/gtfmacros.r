
;---;  gtfmacros.r  ;----------------------------------------------------------
*
*	****	MACROS FOR GTFACE: GADGETS AND MENUS    ****
*
*	Author		Stefan Walter
*	Version		1.09
*	Last Revision	16.10.95
*	Identifier	gfm_defined
*	Prefix		gfm_	(GTFace Macros)
*				 ¯ ¯    ¯
;------------------------------------------------------------------------------

;------------------
	IFND	gfm_defined
gfm_defined	=1

;------------------
	include	gtfdefs.r
	include	stringmacros.r

;------------------

	IFGT	__PRO,119
	FAILAT	1
	FAIL	*** ProAsm version 0.77 or higher required! ***
	ENDC


;------------------------------------------------------------------------------
*
* BeginGList_	Begin a gadget list.
*
* USAGE:	BeginGList_	name
*
;------------------------------------------------------------------------------

BeginGList_	MACRO
gtf_IDCMP	SET	0
gtf_NUMOF	SET	0
gtf_GOTONE	SET	0
	IFND	gtf_IDCOUNTER
gtf_IDCOUNTER	SET	0
	ENDIF

	dc.l	gtf_NUMOF_\1
	dc.l	gtf_NEEDSIDCMP_\1
	ENDM



;------------------------------------------------------------------------------
*
* SetIDCounter_	Sets the ID counter for gadgets and menus.
*
* USAGE:	SetIDCounter_	firstIDnumber
* 		SetMIDCounter_	firstIDnumber for menu
*
;------------------------------------------------------------------------------

SetIDCounter_	MACRO
gtf_IDCOUNTER	SET	\1
	ENDM


SetMIDCounter_	MACRO
gtf_MENUID	SET	\1
	ENDM



;------------------------------------------------------------------------------
*
* Gadget_	Init for new gadget.
*
* USAGE:	Gadget_ kind,IDsymbol,xpos,ypos,width,heigth
*
;------------------------------------------------------------------------------

Gadget_	MACRO
	EndGadget_
gtf_OBJECT	SET	0
gtf_DEFBITS	SET	0
gtf_TEXTPTR	SETR	0
gtf_TAGFLAGS	SET	0
gtf_FLAGS	SET	0
gtf_GOTONE	SET	1		;we have a gadget to define

gtf_WORDARGS	SET	0
gtf_LONGARGS	SET	0

gtf_KIND	SET	\1_KIND
\2		EQU	gtf_IDCOUNTER
gtf_ID		SET	gtf_IDCOUNTER
gtf_IDCOUNTER	SET	gtf_IDCOUNTER+1
gtf_X		SET	\3
gtf_Y		SET	\4
gtf_WIDTH	SET	\5
gtf_HEIGTH	SET	\6

	IFEQ	gtf_KIND,BUTTON_KIND
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETUP
	ENDIF

	IFEQ	gtf_KIND,CHECKBOX_KIND
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETUP
	ENDIF

	IFEQ	gtf_KIND,INTEGER_KIND
;gtf_X		SET	gtf_X+4	;+(gtf_WIDTH\8)/2
;gtf_Y		SET	gtf_Y+2
;gtf_WIDTH	SET	gtf_WIDTH-8	;-(gtf_WIDTH\8)
;gtf_HEIGTH	SET	gtf_HEIGTH-4
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETUP
	ENDIF

	IFEQ	gtf_KIND,LISTVIEW_KIND
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETUP|IDCMP_GADGETDOWN
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_INTUITICKS|IDCMP_MOUSEBUTTONS
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_MOUSEMOVE
gtf_WIDTH	SET	gtf_WIDTH&$fffffff8
	ENDIF

	IFEQ	gtf_KIND,MX_KIND
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETDOWN
gtf_WIDTH	SET	17
gtf_HEIGTH	SET	9
	ENDIF

	IFEQ	gtf_KIND,SLIDER_KIND
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE|IDCMP_GADGETUP
gtf_LONGARGS	SET	gtf_LONGARGS|1
gtf_ARG1	SET	LORIENT_HORIZ
	ENDIF

	IFEQ	gtf_KIND,CYCLE_KIND
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETUP
	ENDIF

	IFEQ	gtf_KIND,STRING_KIND
;gtf_X		SET	gtf_X+4	;+(gtf_WIDTH\\8)/2
;gtf_Y		SET	gtf_Y+2
;gtf_WIDTH	SET	gtf_WIDTH-8	;-(gtf_WIDTH\\8)
;gtf_HEIGTH	SET	gtf_HEIGTH-4
gtf_IDCMP	SET	gtf_IDCMP|IDCMP_GADGETUP
	ENDIF

	ENDM



;------------------------------------------------------------------------------
*
* Text*_	Give text pointer and specify where to put it.
*
* USAGE:	Text*_ "text"|label|0
*
;------------------------------------------------------------------------------

TextIn_	MACRO
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_TEXTPTR
	ELSE
gtf_TEXTPTR	SETR	\1
	ENDIF
gtf_FLAGS	SET	gtf_FLAGS|$10
	ENDM

TextLeft_	MACRO
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_TEXTPTR
	ELSE
gtf_TEXTPTR	SETR	\1
	ENDIF
gtf_FLAGS	SET	gtf_FLAGS|$1
	ENDM

TextRight_	MACRO
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_TEXTPTR
	ELSE
gtf_TEXTPTR	SETR	\1
	ENDIF
gtf_FLAGS	SET	gtf_FLAGS|$2
	ENDM

TextAbove_	MACRO
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_TEXTPTR
	ELSE
gtf_TEXTPTR	SETR	\1
	ENDIF
gtf_FLAGS	SET	gtf_FLAGS|$4
	ENDM

TextBelow_	MACRO
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_TEXTPTR
	ELSE
gtf_TEXTPTR	SETR	\1
	ENDIF
gtf_FLAGS	SET	gtf_FLAGS|$8
	ENDM



;------------------------------------------------------------------------------
*
* EndGadget_	Create the gadget data.
*
* USAGE:	EndGadget_
*
;------------------------------------------------------------------------------

EndGadget_	MACRO
	IFNE	gtf_GOTONE

;------------------

	IFEQ	gtf_OBJECT

	dc.w	gtf_KIND
	dc.w	gtf_X
	dc.w	gtf_Y
	dc.w	gtf_WIDTH
	dc.w	gtf_HEIGTH
	dc.l	gtf_TEXTPTR
	dc.w	gtf_ID
	dc.w	gtf_FLAGS
	dc.w	gtf_TAGFLAGS

	IFNE	gtf_WORDARGS&1
	dc.w	gtf_ARG1
	ENDIF
	IFNE	gtf_LONGARGS&1
	dc.l	gtf_ARG1
	ENDIF

	IFNE	gtf_WORDARGS&2
	dc.w	gtf_ARG2
	ENDIF
	IFNE	gtf_LONGARGS&2
	dc.l	gtf_ARG2
	ENDIF

	IFNE	gtf_WORDARGS&4
	dc.w	gtf_ARG3
	ENDIF
	IFNE	gtf_LONGARGS&4
	dc.l	gtf_ARG3
	ENDIF

	IFNE	gtf_WORDARGS&8
	dc.w	gtf_ARG4
	ENDIF
	IFNE	gtf_LONGARGS&8
	dc.l	gtf_ARG4
	ENDIF

	IFNE	gtf_WORDARGS&16
	dc.w	gtf_ARG5
	ENDIF
	IFNE	gtf_LONGARGS&16
	dc.l	gtf_ARG5
	ENDIF

	IFNE	gtf_WORDARGS&32
	dc.w	gtf_ARG6
	ENDIF
	IFNE	gtf_LONGARGS&32
	dc.l	gtf_ARG6
	ENDIF

	IFNE	gtf_WORDARGS&64
	dc.w	gtf_ARG7
	ENDIF
	IFNE	gtf_LONGARGS&64
	dc.l	gtf_ARG7
	ENDIF

	IFNE	gtf_WORDARGS&128
	dc.w	gtf_ARG8
	ENDIF
	IFNE	gtf_LONGARGS&128
	dc.l	gtf_ARG8
	ENDIF

	IFNE	gtf_WORDARGS&256
	dc.w	gtf_ARG9
	ENDIF
	IFNE	gtf_LONGARGS&256
	dc.l	gtf_ARG9
	ENDIF

	IFNE	gtf_WORDARGS&512
	dc.w	gtf_ARG10
	ENDIF
	IFNE	gtf_LONGARGS&512
	dc.l	gtf_ARG10
	ENDIF

	ENDIF

;------------------

	ifmi	gtf_OBJECT

	dc.w	-1
	dc.b	-1
	dc.b	gtf_RECESSED
	dc.w	gtf_X
	dc.w	gtf_Y
	dc.w	gtf_WIDTH
	dc.w	gtf_HEIGTH
	dc.w	gtf_FILLED

	ENDIF

;------------------

	ifgt	gtf_OBJECT

	dc.w	-1
	dc.b	0
	dc.b	gtf_ISPOINTER
	dc.w	gtf_X
	dc.w	gtf_Y
	dc.w	gtf_STYLE
	dc.l	gtf_TEXTPTR

	ENDIF

;------------------

gtf_GOTONE	SET	0

	IFPL	gtf_KIND		; do not count special wishes...
gtf_NUMOF	SET	gtf_NUMOF+1
	ENDC

	ENDIF
	ENDM



;------------------------------------------------------------------------------
*
* BevelBox_	Create a BevelBox.
*
* USAGE:	BevelBox_ left, top, width, height
*
;------------------------------------------------------------------------------

BevelBox_	MACRO
	EndGadget_

gtf_OBJECT	SET	-1

gtf_X		SET	\1
gtf_Y		SET	\2
gtf_WIDTH	SET	\3
gtf_HEIGTH	SET	\4

gtf_RECESSED	SET	0
gtf_FILLED	SET	-1
gtf_GOTONE	SET	1
gtf_NUMOF	SET	gtf_NUMOF-1	;no gadget!!!
	ENDM



;------------------------------------------------------------------------------
*
* WindowText_	Print a one-line text.
*
* USAGE:	WindowText_	left, top, APen, BPen, text
*
;------------------------------------------------------------------------------

WindowText_	MACRO
	EndGadget_

gtf_OBJECT	SET	1
gtf_X		SET	\1
gtf_Y		SET	\2
gtf_STYLE	SET	\4*256+\3

	IFC	'\*L(\5,1)','"'
	AddString_	\5,gtf_gadgets,gtf_TEXTPTR
	ELSE
gtf_TEXTPTR	SETR	\5
	ENDIF

gtf_GOTONE	SET	1
gtf_NUMOF	SET	gtf_NUMOF-1	;no gadget!!!
gtf_ISPOINTER	SET	0

	ENDM



;------------------------------------------------------------------------------
*
* Patchable variations of the tag MACROS below:
*
* USAGE:	Number_ number,lab	;Initial number for Integer
*		LVSelectedP_ number,lab	;Selected entry for ListView (WORD)
*		Labels_ label,lab	;Labels for Cycle/MX (LONG)
*		Active_ number,lab	;Number of active text for Cycle/MX (WORD)
*		Text_ label,lab		;Text for Text (LONG)
*		CheckItPatch_ lab	;Checked menu (set bit 0!!)
*
;------------------------------------------------------------------------------

NumberPatch_		MACRO
	Number_		\1
\2	EQU	*+20
	ENDM


LVSelectedPatch_	MACRO
	LVSelected_	\1
	IFNE	gtf_TAGFLAGS&(1<<gtf_b_Labels)
\2	EQU	*+26
	ELSE
\2	EQU	*+22
	ENDC
	ENDM


LabelsPatch_		MACRO
	Labels_		\1
\2	EQU	*+20
	ENDM


ActivePatch_		MACRO
	Active_		\1
\2	EQU	*+26
	ENDM


TextPatch_		MACRO
	Text_		\1
\2	EQU	*+20
	ENDM

CheckItPatch_		MACRO
	CheckIt_
\1	EQU	*+10
	ENDM



;------------------------------------------------------------------------------
*
* Different MACROs to specify some tags and flags.
*
* USAGE:	Highlight_		;Highlight title
*		Disabled_		;Disable gadget or menu
*		ToggleSelect_		;Button kind is a toggle gadget
*		Selected_		;Gadget initially selected
*		Underscore_		;Use underscore feature
*		Checked_		;CheckBox or menu initially checked
*		Number_ number		;Initial number for Integer
*		MaxChars number		;Maximum chars for Integer/String
*		RightJustified_		;Text in Integer/String right adjusted 
*		NoTabCycle_		;Cycle feature OFF for Integer
*		TabCycle_		;Cycle feature ON for String
*		LVList_ label		;Initial list of texts for ListView
*		LVLabels_ symbol	;Initial list of texts for ListView
*					;The macro assings the address of the
*					;tag data to the symbol. The main
*					;program can then set the list by
*					;performing a 'move.l #list,symbol'.
*		ReadOnly_		;ReadOnly mode for ListView
*		ShowSelected_		;Show selected entry of ListView
*		LVSelected_ number	;Selected entry for ListView
*		Labels_ label		;List of texts for Cycle/MX
*		Active_ number		;Number of active text for Cycle/MX
*		Spacing_ num		;Spacing for MX
*		String_ label		;Default string for String
*		Recessed_		;BB recessed
*		Raised_			;BB raised
*		Filled_ num		;fill BB with pattern and color
*		RelVerify_		;RelVerify for Slider
*		Min_ num		;Minimum level for Slider
*		Max_ num		;Maximum level for Slider
*		Level_ num		;Initial level of Slider
*		MaxLevelLen_ num	;Length of number string for Slider
*		LevelFormat ptr		;RawDoFmt string for Slider
*		LevelPlace_ place	;Place for number string for Slider
*		DispFunc_		;Function for Number conversion
*		IsPointer_		;Text is in fact a pointer
*		Text_ label		;Text for Text
*		CopyText_		;Copy text of Text
*		Border_			;Make a border around Text
*		Toggled_		;A menu item is toggled
*
*		FlagAddress_ label	;Assign address of flags to label
*		MenuFlagAddr_ label	;Assign address of menu flags to label
*
;------------------------------------------------------------------------------

Highlight_	MACRO
gtf_FLAGS	SET	gtf_FLAGS|$20
	ENDM

Disabled_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Disabled
gtf_DISABLED	SET	$10
	ENDM

ToggleSelect_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_ToggleSelect
	ENDM

Selected_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Selected
	ENDM

Underscore_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Underscore
	ENDM

Checked_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Checked
gtf_CHECKED	SET	$100
	ENDM

Number_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Number
gtf_LONGARGS	SET	gtf_LONGARGS|1
gtf_ARG1	SET	\1
	ENDM

MaxChars_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_MaxChars
gtf_LONGARGS	SET	gtf_LONGARGS|2
gtf_ARG2	SET	\1
	ENDM

RightJustified_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_RightJustified
	ENDM

NoTabCycle_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_NoTabCycle
	ENDM

TabCycle_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_TabCycle
	ENDM

LVLabels_		MACRO
	IFNE	gtf_TAGFLAGS&(1<<gtf_b_LVSelected)
	Fail because LVLabels_ must be used before LVSelected_ !!!
	ENDIF
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Labels
gtf_LONGARGS	SET	gtf_LONGARGS|1
\1		EQU	*+20
gtf_ARG1	SET	0
	ENDM

LVList_		MACRO
	IFNE	gtf_TAGFLAGS&(1<<gtf_b_LVSelected)
	Fail because LVList_ must be used before LVSelected_ !!!
	ENDIF
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Labels
gtf_LONGARGS	SET	gtf_LONGARGS|1
gtf_ARG1	SET	\1
	ENDM

ReadOnly_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_ReadOnly
	ENDM

ShowSelected_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_ShowSelected
	ENDM

LVSelected_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_LVSelected
gtf_LONGARGS	SET	gtf_LONGARGS|2
gtf_ARG2	SET	\1
	ENDM

Labels_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Labels
gtf_LONGARGS	SET	gtf_LONGARGS|1
gtf_ARG1	SET	\1
	ENDM

Spacing_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Spacing
gtf_LONGARGS	SET	gtf_LONGARGS|4
gtf_ARG3	SET	\1
	ENDM

Active_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Active
gtf_LONGARGS	SET	gtf_LONGARGS|2
gtf_ARG2	SET	\1
	ENDM

String_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_String
gtf_LONGARGS	SET	gtf_LONGARGS|1
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_ARG1
	ELSE
gtf_ARG1	SETR	\1
	ENDIF
	ENDM

EditHook_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_EditHook
gtf_LONGARGS	SET	gtf_LONGARGS|4
gtf_ARG3	SET	\1
	ENDM

Recessed_	MACRO
gtf_RECESSED	SET	255
	ENDM

Raised_		MACRO
gtf_RECESSED	SET	0
	ENDM

Filled_		MACRO
gtf_FILLED	SET	\1
	ENDM

IsPointer_	MACRO
gtf_ISPOINTER	SET	255
	ENDM

RelVerify_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_RelVerify
	ENDM

Min_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Min
gtf_WORDARGS	SET	gtf_WORDARGS|2
gtf_ARG2	SET	\1
	ENDM

Max_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Max
gtf_WORDARGS	SET	gtf_WORDARGS|4
gtf_ARG3	SET	\1
	ENDM

Level_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Level
gtf_WORDARGS	SET	gtf_WORDARGS|8
gtf_ARG4	SET	\1
	ENDM

MaxLevelLen_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_MaxLevelLen
gtf_WORDARGS	SET	gtf_WORDARGS|16
gtf_ARG5	SET	\1
	ENDM

LevelFormat_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_LevelFormat
gtf_LONGARGS	SET	gtf_LONGARGS|32
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_ARG6
	ELSE
gtf_ARG6	SETR	\1
	ENDIF
	ENDM

LevelPlace_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_LevelPlace
gtf_WORDARGS	SET	gtf_WORDARGS|64
gtf_ARG7	SET	\1
	ENDM

DispFunc_	MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_DispFunc
gtf_LONGARGS	SET	gtf_LONGARGS|128
gtf_ARG8	SET	\1
	ENDM

Text_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Text
gtf_LONGARGS	SET	gtf_LONGARGS|1
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_ARG1
	ELSE
gtf_ARG1	SETR	\1
	ENDIF
;gtf_ARG1	SET	\1
	ENDM

CopyText_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_CopyText
	ENDM

Border_		MACRO
gtf_TAGFLAGS	SET	gtf_TAGFLAGS|1<<gtf_b_Border
	ENDM

Toggled_		MACRO
gtf_TOGGLED	SET	$8
	ENDM

CheckIt_	MACRO
gtf_CHECKIT	SET	$1
	ENDM

FlagAddress_	MACRO
\1	EQU	*+18
	ENDM

MenuFlagAddr_	MACRO
\1	EQU	*+10
	ENDM




;------------------------------------------------------------------------------
*
* EndGList_	End a list.
*
* USAGE:	EndGList_ name
*
;------------------------------------------------------------------------------

EndGList_	MACRO
	EndGadget_
gtf_NUMOF_\1		EQU	gtf_NUMOF
gtf_NEEDSIDCMP_\1	EQU	gtf_IDCMP
	dc.w	0
	ENDM



;------------------------------------------------------------------------------
*
* GadgetsDone_	Generate strings.
*
* USAGE:	GadgetsDone_
*
;------------------------------------------------------------------------------

GadgetsDone_	MACRO
	GenStringList_	gtf_gadgets
	ENDM



;------------------------------------------------------------------------------
*
* MenuStart_	Start generation of a menu.
*
* USAGE:	MenuStart_
*
;------------------------------------------------------------------------------

MenuStart_	MACRO
gtf_MENUID	SET	1
gtf_GOTONE	SET	0
gtf_MENUTITNUM	SET	-1
gtf_TAGFLAGS	SET	0
	ENDM


;------------------------------------------------------------------------------
*
* MenuEnd_	End a menu list.
*
* USAGE:	MenuEnd_
*
;------------------------------------------------------------------------------

MenuEnd_	MACRO
	MakeMenuItem_
gtf_GOTONE	SET	0
	dc.w	0
	ENDM



;------------------------------------------------------------------------------
*
* MakeMenuItem_		Generate the data.
*
* USAGE:	MakeMenuItem_
*
;------------------------------------------------------------------------------

MakeMenuItem_	MACRO
	IFNE	gtf_GOTONE
	dc.b	gtf_MENU
	dc.b	0
	dc.l	gtf_TEXT
	dc.l	gtf_COMSEQ
	IFEQ	gtf_MENU,1
	dc.w	gtf_DISABLED/16|gtf_TOGGLED|gtf_CHECKED|gtf_CHECKIT	;mi_Flags
	else
	dc.w	gtf_DISABLED|gtf_TOGGLED|gtf_CHECKED|gtf_CHECKIT
	ENDIF
	dc.l	gtf_MUTUAL
	dc.w	gtf_MENUID
	dc.w	0
gtf_MENUID	SET	gtf_MENUID+1
	ENDIF
	
gtf_GOTONE	SET	0
	ENDM



;------------------------------------------------------------------------------
*
* MenuTitle_	Title of a menu.
*
* USAGE:	MenuTitle_	"text"|textptr(,IDSymbol)
*
;------------------------------------------------------------------------------

MenuTitle_	MACRO
	MakeMenuItem_
gtf_MENU	SET	1		;title
gtf_DISABLED	SET	0
gtf_CHECKIT	SET	0
gtf_MUTUAL	SET	0
gtf_CHECKED	SET	0
gtf_TOGGLED	SET	0
gtf_MENUNUMBER	SET	-1
gtf_MENUTITNUM	SET	gtf_MENUTITNUM+1

	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_menus,gtf_TEXT
	ELSE
gtf_TEXT	SETR	\1
	ENDIF

	IFNC	'\2',''
\2_mn	EQU	%1111111111100000|(gtf_MENUTITNUM)
	ENDC

gtf_COMSEQ	SETR	0	
gtf_GOTONE	SET	1
	ENDM



;------------------------------------------------------------------------------
*
* MenuItem_	An item.
*
* USAGE:	MenuItem_	textptr|"text"(,comseqptr|"comseq"(,IDsymbol))
*
;------------------------------------------------------------------------------

MenuItem_	MACRO
	MakeMenuItem_
gtf_MENU	SET	2		;item
gtf_DISABLED	SET	0
gtf_MUTUAL	SET	0
gtf_CHECKIT	SET	0
gtf_CHECKED	SET	0
gtf_TOGGLED	SET	0
gtf_COMSEQ	SETR	0
gtf_MENUNUMBER	SET	gtf_MENUNUMBER+1
gtf_MENUSUBNUMBER	SET	-1

	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_menus,gtf_TEXT
	ELSE
gtf_TEXT	SETR	\1
	ENDIF

	IFNC	'\2',''
	IFC	'\*L(\2,1)','"'
	AddString_	\2,gtf_menus,gtf_COMSEQ
	ELSE
gtf_COMSEQ	SETR	\2
	ENDIF
	ENDIF

	IFNC	'\3',''
\3	EQU	gtf_MENUID
\3_mn	EQU	%1111100000000000|(gtf_MENUNUMBER<<5)|(gtf_MENUTITNUM)
gtf_menu_\3	equ	gtf_MENUNUMBER
	ENDC

gtf_GOTONE	SET	1
	ENDM

MenuBar_	MACRO
	MenuItem_	-1
	ENDM




;------------------------------------------------------------------------------
*
* Exclude_	Set Mutual Exclude.
*
* USAGE:	Exclude_	name
*
;------------------------------------------------------------------------------

Exclude_	MACRO
gtf_MUTUAL	set	gtf_MUTUAL|1<<gtf_menu_\1
		ENDM




;------------------------------------------------------------------------------
*
* MenuSubItem_	Subitem.
*
* USAGE:	MenuSubItem_	textptr|"text"(,comseqptr|"comseq"(,IDlabel))
*
;------------------------------------------------------------------------------

MenuSubItem_	MACRO
	MakeMenuItem_
gtf_MENU	SET	3		;subitem
gtf_DISABLED	SET	0
gtf_MUTUAL	SET	0
gtf_CHECKIT	SET	0
gtf_CHECKED	SET	0
gtf_TOGGLED	SET	0
gtf_COMSEQ	SETR	0
gtf_MENUSUBNUMBER	SET	gtf_MENUSUBNUMBER+1

	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_menus,gtf_TEXT
	ELSE
gtf_TEXT	SETR	\1
	ENDIF

	IFNC	'\2',''
	IFC	'\*L(\2,1)','"'
	AddString_	\2,gtf_menus,gtf_COMSEQ
	ELSE
gtf_COMSEQ	SETR	\2
	ENDIF
	ENDIF

	IFNC	'\3',''
\3	EQU	gtf_MENUID
\3_mn	EQU	(gtf_MENUSUBNUMBER<<11)|(gtf_MENUNUMBER<<5)|(gtf_MENUTITNUM)
gtf_menu_\3	equ	gtf_MENUSUBNUMBER
	ENDC

gtf_GOTONE	SET	1
	ENDM

MenuSubBar_	MACRO
	MenuSubItem_	-1
	ENDM




;------------------------------------------------------------------------------
*
* MenusDone_	Generate strings.
*
* USAGE:	MenusDone_
*
;------------------------------------------------------------------------------

MenusDone_	MACRO
	GenStringList_	gtf_menus
	ENDM



;------------------------------------------------------------------------------
*
* AddHandler_	Add a handler in a gadget or menu handler list.
*
* USAGE:	AddHandler_	IDlabel,routine
*
;------------------------------------------------------------------------------

AddHandler_	MACRO
	dc.w	\1,\2-gtf_base
	ENDM



;------------------------------------------------------------------------------
*
* GenLabel_	Generate MX/CYCLE gadget label list.
* EndLabel_	End a label list.
* GenLVList_	Generate LV list header.
* GenLVLabel_	Generate LV label.
*
* USAGE:	GenLabel_	"text"|label"
*		EndLabel_
*		GenLVList_	first_label,lastlabel
*		GenLVLabel_	next,prev,"string"
*
;------------------------------------------------------------------------------

GenLabel_	MACRO
	IFC	'\*L(\1,1)','"'
	AddString_	\1,gtf_gadgets,gtf_TEXT
	ELSE
gtf_TEXT	SETR	\1
	ENDIF
	dc.l	gtf_TEXT
	ENDM

EndLabel_	MACRO
	dc.l	0
	ENDM

GenLVList_	MACRO
	dc.l	\1
	dc.l	0
	dc.l	\2
	ENDM

GenLVLabel_	MACRO
	dc.l	\1
	dc.l	\2
	dc.w	0
	dc.l	*+4
	dc.b	\3
	dc.b	0
	even
	ENDM




;------------------------------------------------------------------------------
*
* GTFStdTags_	Generate standard tags for use of OpenScaledWindow.
* WindowKey_	Generate a WindowKey.
* GadgetKey_	Generate a GadgetKey.
*
* USAGE:	GTFStdTags_
*		WindowKey_
*		GadgetKey_
*
;------------------------------------------------------------------------------

GTFStdTags_	MACRO
	dc.l	WA_InnerWidth,0
	dc.l	WA_InnerHeight,0
		ENDM


WindowKey_	MACRO
	ds.b	gfw_SIZEOF
		ENDM


GadgetKey_	MACRO
	ds.b	gfg_SIZEOF
		ENDM


GTFStdTagsZoom_	MACRO
	dc.l	WA_InnerWidth,0
	dc.l	WA_InnerHeight,0
	dc.l	WA_Zoom,0
		ENDM



;------------------------------------------------------------------------------

	ENDIF

	end
