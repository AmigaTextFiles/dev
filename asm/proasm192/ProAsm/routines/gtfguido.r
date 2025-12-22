
;---;  gtfguido.r  ;-----------------------------------------------------------
*
*	****	GUI MACROS FOR GTFACE    ****
*
*	Author		Stefan Walter
*	Version		1.09
*	Last Revision	16.10.95
*	Identifier	gui_defined
*	Prefix		gui_	(GUI)
*				 ¯¯¯
;------------------------------------------------------------------------------

;------------------
	IFND	gui_defined
gui_defined	=1

;------------------
	include	gtfdefs.r

;------------------
gui_xspace	equ	6
gui_yspace	equ	3
gui_xbspace	equ	4+2	;+2 \
gui_ybspace	equ	2+1	;+1 |  Because BevelBoxes are like that
gui_xbox	equ	10-2	;-2 |
gui_ybox	equ	5-1	;-1 /

;------------------

;------------------------------------------------------------------------------
*
* GUINew_	Begin new definitions for a window.
*
* USAGE:	GUINew_
*
;------------------------------------------------------------------------------

;------------------
GUINew_		MACRO
gui_XS		SET	gui_xspace
gui_YS		SET	gui_yspace
gui_XE		SET	gui_xspace
gui_YE		SET	gui_yspace
gui_WX		SET	gui_xspace*2
gui_WY		SET	gui_yspace*2
gui_BOXXE	SET	gui_xbspace
gui_BOXYE	SET	gui_ybspace
		ENDM


;------------------

;------------------------------------------------------------------------------
*
* GUIBoxStart_	Start a new BB for the next gadgets.
* GUIBoxEnd_	End a BB.
*
* GUIBesideBox_		Next BB beside an existing named BB.
* GUIBelowBox_		Next BB below an existing named BB.
*
* GUIRightBox_		Adjust this BB right to another named BB
* GUIBottomBox_		Adjust this BB to bottom of another named BB
*
* GUILeftBox_		Adjust this BB left border to another named BB
* GUIGotoBox_		Goto position of another box
*
* GUIIgnoreBox_		Don't paint box graphics
*
* USAGE:	GUIBoxStart_	name
*		GUIBoxEnd_	name
*
*		GUIBesideBox_	name
*		GUIBelowBox_	name
*
*		GUIRightBox_	name
*		GUIBottomBox_	name
*
*		GUILeftBox_	name
*		GUIGotoBox_	name
*
*		GUIIgnoreBox_
*
;------------------------------------------------------------------------------

;------------------
GUIBoxStart_	MACRO
gui_obj_\1_XS	EQU	gui_XS
gui_obj_\1_YS	EQU	gui_YS
gui_BOXXS	SET	gui_XS	
gui_XS	set	gui_XS+gui_xbspace	
gui_BOXXE	SET	gui_XS	
gui_BOXYS	SET	gui_YS
gui_YS	set	gui_YS+gui_ybspace	
gui_BOXYE	SET	gui_YS

gui_MAKEBOX	set	1
		ENDM


GUIBoxEnd_	MACRO
gui_obj_\1_XE	EQU	gui_BOXXE
gui_obj_\1_YE	EQU	gui_BOXYE

gui_XE		SET	gui_BOXXE+gui_xbspace
gui_YE		SET	gui_BOXYE+gui_ybspace

		IFLT	gui_XE,gui_WX
gui_WX		SET	gui_XE
		ENDC
		IFLT	gui_YE,gui_WY
gui_WY		SET	gui_YE
		ENDC

	IFNE	gui_MAKEBOX
	BevelBox_	gui_BOXXS,gui_BOXYS,gui_XE-gui_BOXXS,gui_YE-gui_BOXYS
		Recessed_
		Filled_	0
	ENDC
	
	ENDM


GUIBesideBox_	MACRO
gui_XS		SET	gui_obj_\1_XE+gui_xspace+gui_xbox
gui_YS		SET	gui_obj_\1_YS
gui_YE		SET	gui_YS
	ENDM


GUIBelowBox_	MACRO
gui_YS		SET	gui_obj_\1_YE+gui_yspace+gui_ybox
gui_XS		SET	gui_obj_\1_XS
gui_XE		SET	gui_XS
	ENDM


GUIRightBox_	MACRO
		IFLT	gui_obj_\1_XE,gui_BOXXE
gui_BOXXE	SET	gui_obj_\1_XE
		ENDC
		ENDM


GUIBottomBox_	MACRO
		IFLT	gui_obj_\1_YE,gui_BOXYE
gui_BOXYE	SET	gui_obj_\1_YE
		ENDC
		ENDM


GUILeftBox_	MACRO
gui_BOXXS	SET	gui_obj_\1_XS
		ENDM


GUIGotoBox_	MACRO
gui_XS		SET	gui_obj_\1_XS
gui_YS		SET	gui_obj_\1_YS
		ENDM


GUIIgnoreBox_	MACRO
gui_MAKEBOX	set	0
		ENDM



;------------------

;------------------------------------------------------------------------------
*
* GUIGadget_	Create a GUI gadget.
* GUIText_	Add autorefreshing GUI text.
*
* USAGE:	GUIGadget_	kind,name
*		GUIText_	FGPen,BGPen,text|textptr
*
;------------------------------------------------------------------------------

;------------------
GUIGadget_	MACRO
	Gadget_	\1,\2,gui_XS,gui_YS,gui_XE-gui_XS,gui_YE-gui_YS
gui_obj_\2_XS	EQU	gui_XS
gui_obj_\2_YS	EQU	gui_YS
gui_obj_\2_XE	EQU	gui_XE
gui_obj_\2_YE	EQU	gui_YE
	GUICoords_
		ENDM


GUIText_	MACRO
	WindowText_	gui_XS,gui_YS,\1,\2,\3
gui_YS	set	gui_YS+8
	ENDM


GUICoords_	MACRO
	IFLT	gui_XE,gui_BOXXE
gui_BOXXE	set	gui_XE
	ENDC
	IFLT	gui_YE,gui_BOXYE
gui_BOXYE	set	gui_YE
	ENDC
	ENDM


;------------------

;------------------------------------------------------------------------------
*
* GUISize_	Declare size of next gadget.
* GUISizeFR_	Declare size of next gadget which has already set right side.
* GUIBelow_	Position next gadget below last or named gadget.
* GUIBeside_	Position next gadget beside last or named gadget.
* GUILeft_	Align left border of next gadget with named gadget.
* GUIRight_	Align right border of next gadget with named gadget.
* GUITop_	Align top border of next gadget with named gadget.
* GUIBottom_	Align bottom border of next gadget with named gadget.
*
* USAGE:	GUISize_	(width),(heigth)
*		GUISizeFR_	(width),(heigth)
*		GUIBelow_	(name)
*		GUIBeside_	(name)
*		GUILeft_	name
*		GUIRight_	name
*		GUITop_		name
*		GUIBottom_	name
*
;------------------------------------------------------------------------------

;------------------
GUISize_	MACRO			;width,heigth
	IFNC	'\1',''
gui_XE		SET	gui_XS+\1
	ENDC
	IFNC	'\2',''
gui_YE		SET	gui_YS+\2
	ENDC
	GUICoords_
		ENDM


GUISizeFR_	MACRO			;width,heigth
	IFNC	'\1',''
gui_XS		SET	gui_XE-\1
	ENDC
	IFNC	'\2',''
gui_YE		SET	gui_YS+\2
	ENDC
	GUICoords_
		ENDM


GUIBeside_	MACRO			;name|<nothing>
	IFC	'\1',''
gui_XS		SET	gui_XE+gui_xspace
	ELSE
gui_XS		SET	gui_obj_\1_XE+gui_xspace
gui_YS		SET	gui_obj_\1_YS
	GUICoords_
	ENDC
	ENDM

GUIBelow_	MACRO			;name|<nothing>
	IFC	'\1',''
gui_YS		SET	gui_YE+gui_yspace
	ELSE
gui_YS		SET	gui_obj_\1_YE+gui_yspace
gui_XS		SET	gui_obj_\1_XS
	GUICoords_
	ENDC
	ENDM

GUILeft_	MACRO			;name
gui_XS		SET	gui_obj_\1_XS
	GUICoords_
		ENDM

GUIRight_	MACRO			;name
gui_XE		SET	gui_obj_\1_XE
	GUICoords_
		ENDM

GUITop_		MACRO			;name
gui_YS		SET	gui_obj_\1_YS
	GUICoords_
		ENDM

GUIBottom_	MACRO			;name
gui_YE		SET	gui_obj_\1_YE
	GUICoords_
		ENDM


;------------------

;------------------------------------------------------------------------------
*
* GUIAdjust_		Adjust start coordinates of next gadget.
* GUIAdjustEnd_		Adjust end coordinates after size defined.
* GUIRemember_		Assign current start position to symbols.
* GUISpace_		Declare empty space.
* GUIWindowSize_	Assign required window size to symbols.
* GUIAbsPos_		Go to absolute position.
* GUIGoto_		Go to start coords of an object.
* GUIPosInfo_		Evaluate and reserve (fontsensitive) space (coordinates).
*
* USAGE:	GUIAdjust	(x),(y)
*		GUIAdjustEnd_	(x),(y)
*		GUIRemember_	(xlab),(ylab)
*		GUISpace_	name
*		GUIWindowSize_	xlab,ylab
*		GUIAbsPos_	(x),(y)
*		GUIGoto_	name
*
;------------------------------------------------------------------------------

;------------------
GUIAdjust_	MACRO			;x,y adjust
	IFNC	'\1',''
gui_XS		SET	gui_XS+\1
	ENDC
	IFNC	'\2',''
gui_YS		SET	gui_YS+\2
	ENDC
		ENDM


GUIAdjustEnd_	MACRO			;x,y adjust
	IFNC	'\1',''
gui_XE		SET	gui_XE+\1
	ENDC
	IFNC	'\2',''
gui_YE		SET	gui_YE+\2
	ENDC
	GUICoords_
		ENDM


GUIRemember_	MACRO
	IFNC	'\1',''
\1		EQU	gui_XS
	ENDC
	IFNC	'\2',''
\2		EQU	gui_YS
	ENDC
		ENDM


GUISpace_	MACRO			;name
gui_obj_\1_XS	EQU	gui_XS
gui_obj_\1_YS	EQU	gui_YS
gui_obj_\1_XE	EQU	gui_XE
gui_obj_\1_YE	EQU	gui_YE
	GUICoords_
		ENDM


GUIWindowSize_	MACRO
\1		EQU	gui_WX+gui_xspace
\2		EQU	gui_WY+gui_yspace
gui_obj_\1_XS	EQU	0
gui_obj_\1_YS	EQU	0
gui_obj_\1_XE	EQU	gui_WX
gui_obj_\1_YE	EQU	gui_WY
		ENDM


GUIAbsPos_	MACRO
		IFNC	'\1',''
gui_XS		SET	\1
		ENDC
		IFNC	'\2',''
gui_YS		SET	\2
		ENDC
		ENDM


GUIGoto_	MACRO
gui_XS		SET	gui_obj_\1_XS
gui_YS		SET	gui_obj_\1_YS
		ENDM


;------------------

;------------------------------------------------------------------------------
*
* GUISpreadNew_		Start spreading of gadgets.
* GUISpreadAdd_		Add a gadget to spread.
* GUISpread_		Adjust gadget lefzt to last.
* GUICenterX_		Center a gadget horiz. in a box. Call after GUISize_!
* GUICenterY_		Center a gadget vert. in a box. Call after GUISize_!
*
* USAGE:	GUISpreadNew_	boxname
*		GUISpreadAdd_	name
*		GUISpread_
*		GUICenterX_	boxname
*		GUICenterY_	boxname
*
;------------------------------------------------------------------------------

;------------------
GUISpreadNew_	MACRO
gui_spreadval	SET	gui_obj_\1_XE-gui_obj_\1_XS-gui_xbspace
gui_XS		SET	gui_obj_\1_XS+gui_xspace
gui_spreadnum	SET	-1
		ENDM


GUISpreadAdd_	MACRO
gui_spreadval	SET	gui_spreadval-gui_obj_\1_XE+gui_obj_\1_XS
gui_spreadnum	SET	gui_spreadnum+1
		ENDM


GUISpread_	MACRO
		GUIBeside_
		IF2
gui_XS		SET	gui_XS-gui_xspace+(gui_spreadval/gui_spreadnum)
gui_spreadval	SET	gui_spreadval-(gui_spreadval/gui_spreadnum)
gui_spreadnum	SET	gui_spreadnum-1
		ENDC
		ENDM


GUICenterX_	MACRO
		IF2
gui_TEMP1	SET	gui_XE-gui_XS
gui_TEMP3	SET	gui_obj_\1_XE-gui_obj_\1_XS-gui_xbspace

gui_XS		SET	gui_obj_\1_XS+gui_xbspace+(gui_TEMP3-gui_TEMP1)/2
gui_XE		SET	gui_XS+gui_TEMP1
		ELSE
gui_TEMP1	SET	0
gui_TEMP3	SET	0
		ENDC
		ENDM


GUICenterY_	MACRO
		IF2
gui_TEMP2	SET	gui_YE-gui_YS
gui_TEMP4	SET	gui_obj_\1_YE-gui_obj_\1_YS-gui_ybspace

gui_YS		SET	gui_obj_\1_YS+gui_ybspace+(gui_TEMP4-gui_TEMP2)/2
gui_YE		SET	gui_YS+gui_TEMP2
		ELSE
gui_TEMP2	SET	0
gui_TEMP4	SET	0
		ENDC
		ENDM


;------------------

;------------------------------------------------------------------------------

;------------------
	ENDIF
	END



