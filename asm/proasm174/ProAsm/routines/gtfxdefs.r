;---;  gtfxdefs.r  ;------------------------------------------------------------
*
*	****	EXTERNAL DEFINITIONS FOR GTFACE (INSTEAD OF INCLUDES)    ****
*
*	Author		Stefan Walter
*	Version		1.00b
*	Last Revision	08.04.93
*
;------------------------------------------------------------------------------

	incdir	include:
	include	utility/tagitem.i
	include	libraries/gadtools.i
	include	intuition/intuition.i
	include	intuition/gadgetclass.i

	end

;------------------

	IFND	TAG_USER
TAG_USER	equ	$80000000
	ENDC

;------------------------------------------------------------------------------
** $Filename: intuition/gadgetclass.i $


    IFND INTUITION_GADGETCLASS_I
INTUITION_GADGETCLASS_I SET 1


; Gadget Class attributes

GA_Dummy		EQU	(TAG_USER+$30000)
GA_Left			EQU	(GA_Dummy+$0001)
GA_RelRight		EQU	(GA_Dummy+$0002)
GA_Top			EQU	(GA_Dummy+$0003)
GA_RelBottom		EQU	(GA_Dummy+$0004)
GA_Width		EQU	(GA_Dummy+$0005)
GA_RelWidth		EQU	(GA_Dummy+$0006)
GA_Height		EQU	(GA_Dummy+$0007)
GA_RelHeight		EQU	(GA_Dummy+$0008)
GA_Text			EQU	(GA_Dummy+$0009)  ; ti_Data is (UBYTE *)
GA_Image		EQU	(GA_Dummy+$000A)
GA_Border		EQU	(GA_Dummy+$000B)
GA_SelectRender		EQU	(GA_Dummy+$000C)
GA_Highlight		EQU	(GA_Dummy+$000D)
GA_Disabled		EQU	(GA_Dummy+$000E)
GA_GZZGadget		EQU	(GA_Dummy+$000F)
GA_ID			EQU	(GA_Dummy+$0010)
GA_UserData		EQU	(GA_Dummy+$0011)
GA_SpecialInfo		EQU	(GA_Dummy+$0012)
GA_Selected		EQU	(GA_Dummy+$0013)
GA_EndGadget		EQU	(GA_Dummy+$0014)
GA_Immediate		EQU	(GA_Dummy+$0015)
GA_RelVerify		EQU	(GA_Dummy+$0016)
GA_FollowMouse		EQU	(GA_Dummy+$0017)
GA_RightBorder		EQU	(GA_Dummy+$0018)
GA_LeftBorder		EQU	(GA_Dummy+$0019)
GA_TopBorder		EQU	(GA_Dummy+$001A)
GA_BottomBorder		EQU	(GA_Dummy+$001B)
GA_ToggleSelect		EQU	(GA_Dummy+$001C)

* internal use only, until further notice, please
GA_SysGadget		EQU	(GA_Dummy+$001D)
* bool, sets GTYP_SYSGADGET field in type
GA_SysGType		EQU	(GA_Dummy+$001E)
* e.g., GTYP_WUPFRONT, ...

GA_Previous		EQU	(GA_Dummy+$001F)
* previous gadget (or (struct Gadget **)) in linked list
* NOTE: This attribute CANNOT be used to link new gadgets
* into the gadget list of an open window or requester.
* You must use AddGList().

GA_Next			EQU	(GA_Dummy+$0020)
* not implemented

GA_DrawInfo		EQU	(GA_Dummy+$0021)
* some fancy gadgets need to see a DrawInfo
* when created or for layout

* You should use at most ONE of GA_Text, GA_IntuiText, and GA_LabelImage
GA_IntuiText		EQU	(GA_Dummy+$0022)
* ti_Data is (struct IntuiText	*)

GA_LabelImage		EQU	(GA_Dummy+$0023)
* ti_Data is an image (object), used in place of
* GadgetText

GA_TabCycle		EQU	(GA_Dummy+$0024)
* New for V37:
* Boolean indicates that this gadget is to participate in
* cycling activation with Tab or Shift-Tab.

* PROPGCLASS attributes

PGA_Dummy		EQU	(TAG_USER+$31000)
PGA_Freedom		EQU	(PGA_Dummy+$0001)
* either or both of FREEVERT and FREEHORIZ
PGA_Borderless		EQU	(PGA_Dummy+$0002)
PGA_HorizPot		EQU	(PGA_Dummy+$0003)
PGA_HorizBody		EQU	(PGA_Dummy+$0004)
PGA_VertPot		EQU	(PGA_Dummy+$0005)
PGA_VertBody		EQU	(PGA_Dummy+$0006)
PGA_Total		EQU	(PGA_Dummy+$0007)
PGA_Visible		EQU	(PGA_Dummy+$0008)
PGA_Top			EQU	(PGA_Dummy+$0009)
; New for V37:
PGA_NewLook		EQU	(PGA_Dummy+$000A)

* STRGCLASS attributes

STRINGA_Dummy			EQU	(TAG_USER+$32000)
STRINGA_MaxChars	EQU	(STRINGA_Dummy+$0001)
STRINGA_Buffer		EQU	(STRINGA_Dummy+$0002)
STRINGA_UndoBuffer	EQU	(STRINGA_Dummy+$0003)
STRINGA_WorkBuffer	EQU	(STRINGA_Dummy+$0004)
STRINGA_BufferPos	EQU	(STRINGA_Dummy+$0005)
STRINGA_DispPos		EQU	(STRINGA_Dummy+$0006)
STRINGA_AltKeyMap	EQU	(STRINGA_Dummy+$0007)
STRINGA_Font		EQU	(STRINGA_Dummy+$0008)
STRINGA_Pens		EQU	(STRINGA_Dummy+$0009)
STRINGA_ActivePens	EQU	(STRINGA_Dummy+$000A)
STRINGA_EditHook	EQU	(STRINGA_Dummy+$000B)
STRINGA_EditModes	EQU	(STRINGA_Dummy+$000C)

* booleans
STRINGA_ReplaceMode	EQU	(STRINGA_Dummy+$000D)
STRINGA_FixedFieldMode	EQU	(STRINGA_Dummy+$000E)
STRINGA_NoFilterMode	EQU	(STRINGA_Dummy+$000F)

STRINGA_Justification	EQU	(STRINGA_Dummy+$0010)
* GACT_STRINGCENTER, GACT_STRINGLEFT, GACT_STRINGRIGHT
STRINGA_LongVal		EQU	(STRINGA_Dummy+$0011)
STRINGA_TextVal		EQU	(STRINGA_Dummy+$0012)

STRINGA_ExitHelp	EQU	(STRINGA_Dummy+$0013)
* STRINGA_ExitHelp is new for V37, and ignored by V36.
* Set this if you want the gadget to exit when Help is
* pressed.  Look for a code of 0x5F, the rawkey code for Help

SG_DEFAULTMAXCHARS	EQU	(128)

* Gadget Layout related attributes

LAYOUTA_Dummy		EQU	(TAG_USER+$38000)
LAYOUTA_LayoutObj	EQU	(LAYOUTA_Dummy+$0001)
LAYOUTA_Spacing		EQU	(LAYOUTA_Dummy+$0002)
LAYOUTA_Orientation	EQU	(LAYOUTA_Dummy+$0003)

* orientation values
LORIENT_NONE		EQU	0
LORIENT_HORIZ		EQU	1
LORIENT_VERT		EQU	2

; Custom gadget hook command ID's 
; (gadget class method/message ID's)

GM_HITTEST EQU		0	; return GMR_GADGETHIT if you are clicked
				; (whether or not you are disabled)
GM_RENDER EQU		1	; draw yourself, in the appropriate state
GM_GOACTIVE EQU		2	; you are now going to be fed input
GM_HANDLEINPUT EQU	3	; handle that input
GM_GOINACTIVE EQU	4	; whether or not by choice, you are done


	ENDIF



;------------------------------------------------------------------------------
** $Filename: intuition/intuition.i $


	IFND	INTUITION_INTUITION_I
INTUITION_INTUITION_I	SET	1


IDCMP_SIZEVERIFY	EQU	$00000001
IDCMP_NEWSIZE		EQU	$00000002
IDCMP_REFRESHWINDOW	EQU	$00000004
IDCMP_MOUSEBUTTONS	EQU	$00000008
IDCMP_MOUSEMOVE		EQU	$00000010
IDCMP_GADGETDOWN	EQU	$00000020
IDCMP_GADGETUP		EQU	$00000040
IDCMP_REQSET		EQU	$00000080
IDCMP_MENUPICK		EQU	$00000100
IDCMP_CLOSEWINDOW	EQU	$00000200
IDCMP_RAWKEY		EQU	$00000400
IDCMP_REQVERIFY		EQU	$00000800
IDCMP_REQCLEAR		EQU	$00001000
IDCMP_MENUVERIFY	EQU	$00002000
IDCMP_NEWPREFS		EQU	$00004000
IDCMP_DISKINSERTED	EQU	$00008000
IDCMP_DISKREMOVED	EQU	$00010000
IDCMP_WBENCHMESSAGE	EQU	$00020000	; System use only
IDCMP_ACTIVEWINDOW	EQU	$00040000
IDCMP_INACTIVEWINDOW	EQU	$00080000
IDCMP_DELTAMOVE		EQU	$00100000
IDCMP_VANILLAKEY	EQU	$00200000
IDCMP_INTUITICKS	EQU	$00400000
;  for notifications from "boopsi" gadgets:
IDCMP_IDCMPUPDATE	EQU	$00800000  	; new for V36
; for getting help key report during menu session:
IDCMP_MENUHELP		EQU	$01000000  	; new for V36
; for notification of any move/size/zoom/change window:
IDCMP_CHANGEWINDOW	EQU	$02000000  	; new for V36
; NOTEZ-BIEN:		$80000000 is reserved for internal use by IDCMP

; the IDCMP Flags do not use this special bit, which is cleared when
; Intuition sends its special message to the Task, and set when Intuition
; gets its Message back from the Task.  Therefore, I can check here to
; find out fast whether or not this Message is available for me to send
IDCMP_LONELYMESSAGE	EQU	$80000000


WA_Left			equ	$80000000+100
WA_Top			equ	$80000000+100+1
WA_Width		equ	$80000000+100+2
WA_Height		equ	$80000000+100+3
WA_DetailPen		equ	$80000000+100+4
WA_BlockPen		equ	$80000000+100+5
WA_IDCMP		equ	$80000000+100+6
WA_Flags		equ	$80000000+100+7
WA_Gadgets		equ	$80000000+100+8
WA_Checkmark		equ	$80000000+100+9
WA_Title		equ	$80000000+100+10
WA_ScreenTitle		equ	$80000000+100+11
WA_CustomScreen		equ	$80000000+100+12
WA_SuperBitMap		equ	$80000000+100+13
WA_MinWidth		equ	$80000000+100+14
WA_MinHeight		equ	$80000000+100+15
WA_MaxWidth		equ	$80000000+100+16
WA_MaxHeight		equ	$80000000+100+17
WA_InnerWidth		equ	$80000000+100+18
WA_InnerHeight		equ	$80000000+100+19
WA_PubScreenName	equ	$80000000+100+20
WA_PubScreen		equ	$80000000+100+21
WA_PubScreenFallBack	equ	$80000000+100+22
WA_WindowName		equ	$80000000+100+23
WA_Colors		equ	$80000000+100+24
WA_Zoom			equ	$80000000+100+25
WA_MouseQueue		equ	$80000000+100+26
WA_BackFill		equ	$80000000+100+27
WA_RptQueue		equ	$80000000+100+28
WA_SizeGadget		equ	$80000000+100+29
WA_DragBar		equ	$80000000+100+30
WA_DepthGadget		equ	$80000000+100+31
WA_CloseGadget		equ	$80000000+100+32
WA_Backdrop		equ	$80000000+100+33
WA_ReportMouse		equ	$80000000+100+34
WA_NoCareRefresh	equ	$80000000+100+35
WA_Borderless		equ	$80000000+100+36
WA_Activate		equ	$80000000+100+37
WA_RMBTrap		equ	$80000000+100+38
WA_WBenchWindow		equ	$80000000+100+39
WA_SimpleRefresh	equ	$80000000+100+40
WA_SmartRefresh		equ	$80000000+100+41
WA_SizeBRight		equ	$80000000+100+42
WA_SizeBBottom		equ	$80000000+100+43
WA_AutoAdjust		equ	$80000000+100+44
WA_GimmeZeroZero	equ	$80000000+100+45
WA_MenuHelp		equ	$80000000+100+46


	ENDIF


;------------------------------------------------------------------------------
**	$Filename: libraries/gadtools.i $


	IFND LIBRARIES_GADTOOLS_I
LIBRARIES_GADTOOLS_I	SET	1


GENERIC_KIND	EQU	0
BUTTON_KIND	EQU	1
CHECKBOX_KIND	EQU	2
INTEGER_KIND	EQU	3
LISTVIEW_KIND	EQU	4
MX_KIND		EQU	5
NUMBER_KIND	EQU	6
CYCLE_KIND	EQU	7
PALETTE_KIND	EQU	8
SCROLLER_KIND	EQU	9
* Kind number 10 is reserved
SLIDER_KIND	EQU	11
STRING_KIND	EQU	12
TEXT_KIND	EQU	13

;ARROWIDCMP	EQU	GADGETUP!GADGETDOWN!INTUITICKS!MOUSEBUTTONS
;BUTTONIDCMP	EQU	GADGETUP
;CHECKBOXIDCMP	EQU	GADGETUP
;INTEGERIDCMP	EQU	GADGETUP
;LISTVIEWIDCMP	EQU	GADGETUP!GADGETDOWN!MOUSEMOVE!ARROWIDCMP
;MXIDCMP		EQU	GADGETDOWN
;NUMBERIDCMP	EQU	0
;CYCLEIDCMP	EQU	GADGETUP
;PALETTEIDCMP	EQU	GADGETUP
;*  Use ARROWIDCMP!SCROLLERIDCMP if your scrollers have arrows: *
;SCROLLERIDCMP	EQU	GADGETUP!GADGETDOWN!MOUSEMOVE
;SLIDERIDCMP	EQU	GADGETUP!GADGETDOWN!MOUSEMOVE
;STRINGIDCMP	EQU	GADGETUP
;TEXTIDCMP	EQU	0

GT_TagBase	EQU	TAG_USER+$80000 ; Begin counting tags

GTVI_NewWindow	EQU	GT_TagBase+$01	; NewWindow struct for GetVisualInfo
GTVI_NWTags	EQU	GT_TagBase+$02	; NWTags for GetVisualInfo

GT_Private0	EQU	GT_TagBase+$03	; (private)

GTCB_Checked	EQU	GT_TagBase+$04	; State of checkbox

GTLV_Top	EQU	GT_TagBase+$05	; Top visible one in listview
GTLV_Labels	EQU	GT_TagBase+$06	; List to display in listview
GTLV_ReadOnly	EQU	GT_TagBase+$07	; TRUE if listview is to be read-only
GTLV_ScrollWidth	EQU	GT_TagBase+$08	; Width of scrollbar

GTMX_Labels	EQU	GT_TagBase+$09	; NULL-terminated array of labels
GTMX_Active	EQU	GT_TagBase+$0A	; Active one in mx gadget

GTTX_Text	EQU	GT_TagBase+$0B	; Text to display
GTTX_CopyText	EQU	GT_TagBase+$0C	; Copy text label instead of referencing it

GTNM_Number	EQU	GT_TagBase+$0D	; Number to display

GTCY_Labels	EQU	GT_TagBase+$0E	; NULL-terminated array of labels
GTCY_Active	EQU	GT_TagBase+$0F	; The active one in the cycle gad

GTPA_Depth	EQU	GT_TagBase+$10	; Number of bitplanes in palette
GTPA_Color	EQU	GT_TagBase+$11	; Palette color
GTPA_ColorOffset	EQU	GT_TagBase+$12	; First color to use in palette
GTPA_IndicatorWidth	EQU	GT_TagBase+$13	; Width of current-color indicator
GTPA_IndicatorHeight	EQU	GT_TagBase+$14	; Height of current-color indicator

GTSC_Top	EQU	GT_TagBase+$15	; Top visible in scroller
GTSC_Total	EQU	GT_TagBase+$16	; Total in scroller area
GTSC_Visible	EQU	GT_TagBase+$17	; Number visible in scroller
GTSC_Overlap	EQU	GT_TagBase+$18	; Unused

* GT_TagBase+$19 through GT_TagBase+$25 are reserved

GTSL_Min	EQU	GT_TagBase+$26	; Slider min value
GTSL_Max	EQU	GT_TagBase+$27	; Slider max value
GTSL_Level	EQU	GT_TagBase+$28	; Slider level
GTSL_MaxLevelLen	EQU	GT_TagBase+$29	; Max length of printed level
GTSL_LevelFormat	EQU	GT_TagBase+$2A	; Format string for level
GTSL_LevelPlace	EQU	GT_TagBase+$2B	; Where level should be placed
GTSL_DispFunc	EQU	GT_TagBase+$2C	; Callback for number calculation before display

GTST_String	EQU	GT_TagBase+$2D	; String gadget's displayed string
GTST_MaxChars	EQU	GT_TagBase+$2E	; Max length of string

GTIN_Number	EQU	GT_TagBase+$2F	; Number in integer gadget
GTIN_MaxChars	EQU	GT_TagBase+$30	; Max number of digits

GTMN_TextAttr	EQU	GT_TagBase+$31	; MenuItem font TextAttr
GTMN_FrontPen	EQU	GT_TagBase+$32	; MenuItem text pen color

GTBB_Recessed	EQU	GT_TagBase+$33	; Make BevelBox recessed

GT_VisualInfo	EQU	GT_TagBase+$34	; result of VisualInfo call

GTLV_ShowSelected	EQU	GT_TagBase+$35	; show selected entry beneath listview,
			; set tag data = NULL for display-only, or pointer
			; to a string gadget you've created
GTLV_Selected	EQU	GT_TagBase+$36	; Set ordinal number of selected entry in the list
GT_Reserved1	EQU	GT_TagBase+$38	; Reserved for future use

GTTX_Border	EQU	GT_TagBase+$39	; Put a border around Text-display gadgets
GTNM_Border	EQU	GT_TagBase+$3A	; Put a border around Number-display gadgets

GTSC_Arrows	EQU	GT_TagBase+$3B	; Specify size of arrows for scroller
GTMN_Menu	EQU	GT_TagBase+$3C	; Pointer to Menu for use by
			; LayoutMenuItems()
GTMX_Spacing	EQU	GT_TagBase+$3D	; Added to font height to
			; figure spacing between mx choices.  Use this
			; instead of LAYOUTA_SPACING for mx gadgets.

*  New to V37 GadTools.  Ignored by GadTools V36.
GTMN_FullMenu	EQU	GT_TagBase+$3E  ; Asks CreateMenus() to
		; validate that this is a complete menu structure
GTMN_SecondaryError	EQU	GT_TagBase+$3F  ; ti_Data is a pointer
		; to a ULONG to receive error reports from CreateMenus()
GT_Underscore	EQU	GT_TagBase+$40	; ti_Data points to the symbol
		; that preceeds the character you'd like to underline in a
		; gadget label
GTST_EditHook	EQU	GT_TagBase+$37	; String EditHook

*  Old definition, now obsolete:
GT_Reserved0	EQU	GTST_EditHook

PLACETEXT_LEFT	EQU	$0001	* Right-align text on left side
PLACETEXT_RIGHT	EQU	$0002	* Left-align text on right side
PLACETEXT_ABOVE	EQU	$0004	* Center text above
PLACETEXT_BELOW	EQU	$0008	* Center text below
PLACETEXT_IN	EQU	$0010	* Center text on
	
	ENDIF


;------------------------------------------------------------------------------

	end
