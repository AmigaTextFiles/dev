
			IFND	WIZARD_WIZARD_I
WIZARD_WIZARD_I		EQU	1

			IFND LIBRARIES_GADTOOLS_I
			INCLUDE	'libraries/gadtools.i'
			ENDC


; Diese Konstanten dürfen überall benutzt werden, wo die
; Library Farbregister erwartet.

WZRD_TEXTPEN		EQU	TEXTPEN+(1<<15)
WZRD_SHINEPEN		EQU	SHINEPEN+(1<<15)
WZRD_SHADOWPEN		EQU	SHADOWPEN+(1<<15)
WZRD_FILLPEN		EQU	FILLPEN+(1<<15)
WZRD_FILLTEXTPEN	EQU	FILLTEXTPEN+(1<<15)
WZRD_BACKGROUNDPEN	EQU	BACKGROUNDPEN+(1<<15)
WZRD_HIGHLIGHTTEXTPEN	EQU	HIGHLIGHTTEXTPEN+(1<<15)
WZRD_BARDETAILPEN	EQU	BARDETAILPEN+(1<<15)	(OS V39)
WZRD_BARBLOCKPEN	EQU	BARBLOCKPEN+(1<<15)	(OS V39)
WZRD_BARTRIMPEN		EQU	BARTRIMPEN+(1<<15)	(OS V39)

;---------------------------------------------------------

; FrameTypes

WZRDFRAME_NONE		EQU	0
WZRDFRAME_ICON		EQU	1
WZRDFRAME_BUTTON	EQU	2
WZRDFRAME_STRING	EQU	3
WZRDFRAME_DOUBLEICON	EQU	4
WZRDFRAME_SICON		EQU	5
WZRDFRAME_SBUTTON	EQU	6
WZRDFRAME_SSTRING	EQU	7
WZRDFRAME_SDOUBLEICON	EQU	8

;---------------------------------------------------------
; Textplazierungen
WZRDPLACE_LEFT		EQU	PLACETEXT_LEFT
WZRDPLACE_RIGHT		EQU	PLACETEXT_RIGHT
WZRDPLACE_CENTER	EQU	PLACETEXT_IN

;---------------------------------------------------------

WARROW_LEFT		EQU	0
WARROW_RIGHT		EQU	1
WARROW_UP		EQU	2
WARROW_DOWN		EQU	3

;---------------------------------------------------------

WGHF_IgnoreOS		EQU	1
WGHF_FullControl	EQU	2

;---------------------------------------------------------
; WizardNode
	STRUCTURE WizardNode,0
	STRUCT	wn_Node,MLN_SIZE
	BYTE	wn_Entrys		;1
	BYTE	wn_Flags		;1
	STRUCT	wn_Intern,38		;38
	LABEL	wn_SIZE			;0

;---------------------------------------------------------
; StandardNode für ListView und Hierarchy
	STRUCTURE WizardDefaultNode,0
	STRUCT	wdn_WizardNode,wn_SIZE
	STRUCT	wdn_Intern,24
	LABEL	wdn_SIZE		;0

;---------------------------------------------------------

	STRUCTURE WizardWindowHandle,0
	STRUCT	wwh_Node,MLN_SIZE
	LONG	wwh_Window		;1
	LONG	wwh_MenuStrip		;1
	LONG	wwh_DrawInfo		;1
	LONG	wwh_VisualInfo		;1
	LONG	wwh_ScreenTitle		;1
	WORD	wwh_SizeImageWidth	;1
	WORD	wwh_SizeImageHeight	;1
	STRUCT	wwh_Objects,MLH_SIZE
	LONG	wwh_RootGadget		;1
	LONG	wwh_RootTopGadget	;1
	LONG	wwh_RootLeftGadget	;1
	LONG	wwh_RootBottomGadget	;1
	LONG	wwh_RootRightGadget	;1
	LONG	wwh_UserStruct		;1
	LABEL	wwh_SIZE		;0

; Der ganze Aufbau der WindowHandle-Struktur ist nicht beschrieben.
; Es sind alle Felder vom Type ReadOnly !
; Sollte das Fenster geschlossen sein, dann ist der Window-Eintrag
; mit NULL besetzt.
; Die MinNode-Struktur dient der Library zur internen Verkettung und
; ist damit für den Programmierer NICHT nutzbar.
; Möchten Sie ihre WindowHandles selbst verketten, dann sollten Sie
; in die private Struktur eine MinNode-Struktur einbauen !
; siehe WZ_AllocWindowHandle()

;---------------------------------------------------------

	STRUCTURE WizardNewImage,0
	WORD	wni_Flags		;1
	WORD	wni_Name		;1
	WORD	wni_Width		;1
	WORD	wni_Height		;1
	WORD	wni_Depth		;1	Anzahl der Farben = 2^x
	WORD	wni_Compression		;1
	LONG	wni_Reserved		;1
	LONG	wni_ColorLength		;1	Größe der Farbtabelle
	LONG	wni_ImageLength		;1
	LABEL	wni_SIZE		;0
; ab hier folgen die Grafikdaten
			
			BITDEF	WI,Interleaved,2
			BITDEF	WI,Standard,3

;---------------------------------------------------------

	STRUCTURE WizardVImage,0
	WORD	wvi_Flags		;1
	WORD	wvi_Counter		;1
	WORD	wvi_MinWidth		;1
	WORD	wvi_MinHeight		;1
	LONG	wvi_RelCoords		;1
	LABEL	wvi_SIZE		;0

; ab hier folgen weitere Zeiger auf die Image-Beschreibung

			BITDEF	WVI,MinWidth,0
			BITDEF	WVI,MinHeight,1
			BITDEF	WVI,AreaInit,2
			BITDEF	WVI,Recursion,3

;-----------------------------------------------------------

			ENUM
			EITEM	WVICMD_END
			EITEM	WVICMD_COLOR
			EITEM	WVICMD_COLOR2
			EITEM	WVICMD_MOVE	
			EITEM	WVICMD_DRAW
			EITEM	WVICMD_RECTFILL
			EITEM	WVICMD_WRITEPIXEL
			EITEM	WVICMD_IMAGE
			EITEM	WVICMD_TEXT
			EITEM	WVICMD_SETDRMD
			EITEM	WVICMD_TEXTIMAGE
			EITEM	WVICMD_TEXTMOVE
			EITEM	WVICMD_TAGCOLOR
			EITEM	WVICMD_TEXTPLACE
			EITEM	WVICMD_SETAFPT
			EITEM	WVICMD_SNAPCURSOR
			EITEM	WVICMD_SNAPX
			EITEM	WVICMD_SNAPY
			EITEM	WVICMD_TAGMOVE
			EITEM	WVICMD_TAGIMAGE
			EITEM	WVICMD_BITMAP_TO_RP
			EITEM	WVICMD_FILLBORDER
			EITEM	WVICMD_BEEP
			EITEM	WVICMD_AREAINIT
			EITEM	WVICMD_AREAMOVE
			EITEM	WVICMD_AREADRAW
			EITEM	WVICMD_AREAEND


; GadgetArten
			ENUM
			EITEM	WCLASS_LAYOUT
			EITEM	WCLASS_HGROUP
			EITEM	WCLASS_VGROUP
			EITEM	WCLASS_BUTTON
			EITEM	WCLASS_STRING
			EITEM	WCLASS_LABEL
			EITEM	WCLASS_CHECKBOX
			EITEM	WCLASS_MX
			EITEM	WCLASS_INTEGER
			EITEM	WCLASS_HSCROLLER
			EITEM	WCLASS_VSCROLLER
			EITEM	WCLASS_ARROW
			EITEM	WCLASS_LISTVIEW
			EITEM	WCLASS_MULTILISTVIEW
			EITEM	WCLASS_TOGGLE
			EITEM	WCLASS_LINE
			EITEM	WCLASS_COLORFIELD
			EITEM	WCLASS_ARGS
			EITEM	WCLASS_GAUGE
			EITEM	WCLASS_CYCLE
			EITEM	WCLASS_VECTORBUTTON
			EITEM	WCLASS_DATE
			EITEM	WCLASS_SPACE
			EITEM	WCLASS_IMAGE
			EITEM	WCLASS_IMAGEBUTTON
			EITEM	WCLASS_IMAGETOGGLE
			EITEM	WCLASS_IMAGEPOPUP
			EITEM	WCLASS_TEXTPOPUP
			EITEM	WCLASS_PALETTE
			EITEM	WCLASS_VECTORPOPUP
			EITEM	WCLASS_HIERARCHY
			EITEM	WCLASS_HSLIDER
			EITEM	WCLASS_VSLIDER
			EITEM	WCLASS_LAST

WCLASS_GROUPEND		EQU	WCLASS_LAYOUT

;---------------------------------------------------------

WZRD_TagDummy		EQU	TAG_USER+$180000

;---------------------------------------------------------

			ENUM	WZRD_TagDummy+100
			
			EITEM	WVIA_Text
			EITEM	WVIA_TextFont
			EITEM	WVIA_TextPlace
			EITEM	WVIA_TextPen
			EITEM	WVIA_TextStyles
			EITEM	WVIA_TextHighlights
			EITEM	WVIA_TextImages
			
			EITEM	WVIA_TagImage
			EITEM	WVIA_TagImageCode
			
			EITEM	WVIA_ImageCode
			
			EITEM	WVIA_Color0
			EITEM	WVIA_Color1
			EITEM	WVIA_Color2
			EITEM	WVIA_Color3
			EITEM	WVIA_Color4
			EITEM	WVIA_Color5
			EITEM	WVIA_Color6
			EITEM	WVIA_Color7

			EITEM	WVIA_TPoint0
			EITEM	WVIA_TPoint1
			EITEM	WVIA_TPoint2
			EITEM	WVIA_TPoint3
			EITEM	WVIA_TPoint4
			EITEM	WVIA_TPoint5
			EITEM	WVIA_TPoint6
			EITEM	WVIA_TPoint7
			
			EITEM	WVIA_AreaPtrn

			EITEM	WVIA_TmpRas
			
			EITEM	WVIA_BitMapWidth
			EITEM	WVIA_BitMapHeight
			EITEM	WVIA_BitMap0
			EITEM	WVIA_BitMap1
			EITEM	WVIA_BitMap2
			EITEM	WVIA_BitMap3
			EITEM	WVIA_BitMap4
			EITEM	WVIA_BitMap5
			EITEM	WVIA_BitMap6
			EITEM	WVIA_BitMap7
			
			EITEM	WVIA_PureText	(def FALSE)
			
;---------------------------------------------------------

			ENUM	WZRD_TagDummy+200
			
			EITEM	SFH_Locale
			EITEM	SFH_Catalog
			EITEM	SFH_AutoInit

;---------------------------------------------------------

			ENUM	WZRD_TagDummy+300

			EITEM	WWH_GadgetArray
			EITEM	WWH_GadgetArraySize
			EITEM	WWH_PreviousGadget
			EITEM	WWH_StringHook
			EITEM	WWH_StackSize

;---------------------------------------------------------
; Flags in WGA_Flags

			BITDEF	WG,GadgetHelp,1
			BITDEF	WG,Immediate,2
			BITDEF	WG,Disabled,8
			BITDEF	WG,KeyControl,9
			BITDEF	WGRP,EqualSize,15
			BITDEF	WGRP,DockMode,14
			BITDEF	WSPC,Transparent,15
			BITDEF	WTG,SimpleMode,15
			BITDEF	WLV,ReadOnly,15
			BITDEF	WLV,DoubleClicks,14
			BITDEF	WSC,NewLook,15
			BITDEF	WIT,SimpleMode,15
			BITDEF	WIP,NewLook,15
			BITDEF	WTP,NewLook,15
			BITDEF	WVP,NewLook,15
			BITDEF	WHR,DoubleClicks,14
			BITDEF	WSL,NewLook,15

;---------------------------------------------------------

			ENUM	WZRD_TagDummy+400
; alle folgenden Tags sind Universal-Tags

			EITEM	WGA_Label
			EITEM	WGA_Label2
			EITEM	WGA_TextFont
			EITEM	WGA_Flags
			EITEM	WGA_Priority
			EITEM	WGA_RelHeight
			EITEM	WGA_MinWidth
			EITEM	WGA_MinHeight
			EITEM	WGA_Link
			EITEM	WGA_LinkData
			EITEM	WGA_HelpText
			EITEM	WGA_Config
			EITEM	WGA_NewImage
			EITEM	WGA_SelNewImage
			EITEM	WGA_Group
			EITEM	WGA_GroupPage
			EITEM	WGA_Locale
			EITEM	WGA_Screen
			EITEM	WGA_Bounds
			
;---------------------------------------------------------

			ENUM	WZRD_TagDummy+450
			EITEM	WNOTIFYA_Type

;---------------------------------------------------------

			ENUM	WZRD_TagDummy+500
			
			EITEM	WGROUPA_ActivePage
			EITEM	WGROUPA_MaxPage
			EITEM	WGROUPA_HBorder
			EITEM	WGROUPA_VBorder
			EITEM	WGROUPA_BHOffset
			EITEM	WGROUPA_BVOffset
			EITEM	WGROUPA_Space
			EITEM	WGROUPA_VarSpace
			EITEM	WGROUPA_FrameType

			EITEM	WSTRINGA_MaxChars
			EITEM	WSTRINGA_String

			EITEM	WCHECKBOXA_Checked

			EITEM	WMXA_Active
			EITEM	WGROUPA_HighLights
			EITEM	WGROUPA_HighlightPen

			EITEM	WLABELA_FrameType
			EITEM	WLABELA_Space
			EITEM	WLABELA_BGPen
			EITEM	WLABELA_TextPlace
			EITEM	WLABELA_Lines

			EITEM	WINTEGERA_Long
			EITEM	WINTEGERA_MinLong
			EITEM	WINTEGERA_MaxLong
			
			EITEM	WSCROLLERA_Top
			EITEM	WSCROLLERA_Visible
			EITEM	WSCROLLERA_Total

			EITEM	WSTRINGA_Justification
			EITEM	WINTEGERA_Justification

			EITEM	WARROWA_Type
			
			EITEM	WLISTVIEWA_Unused7
			EITEM	WLISTVIEWA_Unused
			EITEM	WLISTVIEWA_Unused2
			EITEM	WLISTVIEWA_Unused3
			EITEM	WLISTVIEWA_Unused4
			EITEM	WLISTVIEWA_Top
			EITEM	WLISTVIEWA_Selected
			EITEM	WLISTVIEWA_List
			EITEM	WLISTVIEWA_Unused6
			EITEM	WLISTVIEWA_Visible
			EITEM	WLISTVIEWA_DoubleClick
			
			EITEM	WTOGGLEA_Checked
			
			EITEM	WLINEA_Type
			EITEM	WLINEA_Label

			EITEM	WCOLORFIELDA_Pen

			EITEM	WARGSA_TextPlace
			EITEM	WARGSA_FrameType
			EITEM	WARGSA_Arg0
			EITEM	WARGSA_Arg1
			EITEM	WARGSA_Arg2
			EITEM	WARGSA_Arg3
			EITEM	WARGSA_Arg4
			EITEM	WARGSA_Arg5
			EITEM	WARGSA_Arg6
			EITEM	WARGSA_Arg7
			EITEM	WARGSA_Arg8
			EITEM	WARGSA_Arg9
			
			EITEM	WGAUGEA_Total
			EITEM	WGAUGEA_Current
			EITEM	WGAUGEA_Format
			
			EITEM	WCYCLEA_Active
			EITEM	WCYCLEA_Labels
			
			EITEM	WARROWA_Step
			EITEM	WVECTORBUTTONA_Type

			EITEM	WDATEA_Day
			EITEM	WDATEA_Month
			EITEM	WDATEA_Year

			EITEM	WARGSA_Format
			EITEM	WLABELA_HighlightPen
			
			EITEM	WBUTTONA_Label

			EITEM	WLABELA_HighLights
			EITEM	WLABELA_Label

			EITEM	WIMAGEA_BGPen
			EITEM	WIMAGEA_FrameType
			EITEM	WIMAGEA_HBorder
			EITEM	WIMAGEA_VBorder
			EITEM	WIMAGEA_NewImage
			
			EITEM	WIMAGEBUTTONA_BGPen
			EITEM	WIMAGEBUTTONA_SelBGPen
			EITEM	WIMAGEBUTTONA_FrameType
			EITEM	WIMAGEBUTTONA_HBorder
			EITEM	WIMAGEBUTTONA_VBorder
			EITEM	WIMAGEBUTTONA_NewImage
			EITEM	WIMAGEBUTTONA_SelNewImage

			EITEM	WIMAGETOGGLEA_BGPen
			EITEM	WIMAGETOGGLEA_SelBGPen
			EITEM	WIMAGETOGGLEA_FrameType
			EITEM	WIMAGETOGGLEA_HBorder
			EITEM	WIMAGETOGGLEA_VBorder
			EITEM	WIMAGETOGGLEA_NewImage
			EITEM	WIMAGETOGGLEA_SelNewImage
			EITEM	WIMAGETOGGLEA_Checked

			EITEM	WSTRINGA_Hook
			
			EITEM	WSPACEA_Unused			Pen
			
			EITEM	WIMAGEPOPUPA_BGPen
			EITEM	WIMAGEPOPUPA_FrameType
			EITEM	WIMAGEPOPUPA_HBorder
			EITEM	WIMAGEPOPUPA_VBorder
			EITEM	WIMAGEPOPUPA_TextPlace
			EITEM	WIMAGEPOPUPA_NewImage
			EITEM	WIMAGEPOPUPA_Labels
			EITEM	WIMAGEPOPUPA_Selected

			EITEM	WTEXTPOPUPA_TextPlace
			EITEM	WTEXTPOPUPA_Labels
			EITEM	WTEXTPOPUPA_Selected
			EITEM	WTEXTPOPUPA_Name
						
			EITEM	WPALETTEA_Colors
			EITEM	WPALETTEA_Selected
			EITEM	WPALETTEA_Offset
			
			EITEM	WGROUPA_BGPen
			EITEM	WGROUPA_DockMinVisible
			EITEM	WGROUPA_Styles
			
			EITEM	WLABELA_Styles
						
			EITEM	WVECTORPOPUPA_Type
			EITEM	WVECTORPOPUPA_Labels
			EITEM	WVECTORPOPUPA_TextPlace
			EITEM	WVECTORPOPUPA_Selected
			
			EITEM	WHIERARCHYA_Unused4
			EITEM	WHIERARCHYA_ImageType
			EITEM	WHIERARCHYA_ImageWidth
			EITEM	WHIERARCHYA_Top
			EITEM	WHIERARCHYA_List
			EITEM	WHIERARCHYA_Selected
			EITEM	WHIERARCHYA_Visible
			EITEM	WHIERARCHYA_DoubleClick
			EITEM	WHIERARCHYA_Unused2
			EITEM	WHIERARCHYA_Unused3
			EITEM	WHIERARCHYA_Unused5

			EITEM	WSLIDERA_Min
			EITEM	WSLIDERA_Max
			EITEM	WSLIDERA_Level

			EITEM	WTOGGLEA_Label

			EITEM	WLAYOUTA_RootGadget
			EITEM	WLAYOUTA_Type
			EITEM	WLAYOUTA_BorderLeft
			EITEM	WLAYOUTA_BorderRight
			EITEM	WLAYOUTA_BorderTop
			EITEM	WLAYOUTA_BorderBottom
			EITEM	WLAYOUTA_StackSwap
			
			EITEM	WARGSA_TextPen
			EITEM	WARGSA_BackgroundPen
			
;---------------------------------------------------------

			ENUM	WZRD_TagDummy+1000
			
			EITEM	WNODEA_Flags

WNF_SELECTED		EQU	1<<0
WNF_TREE		EQU	1<<5
WNF_AUTOMATIC		EQU	1<<6
WNF_VISIBLE		EQU	1<<7

;---------------------------------------------------------

			ENUM	WZRD_TagDummy+1100
			
			EITEM	WENTRYA_Type
			EITEM	WENTRYA_TextPen
			EITEM	WENTRYA_TextSPen
			EITEM	WENTRYA_TextStyle
			EITEM	WENTRYA_TextSStyle
			EITEM	WENTRYA_TextString
			EITEM	WENTRYA_TreeParentNode
			EITEM	WENTRYA_TreeChilds
			EITEM	WENTRYA_TreeString
			EITEM	WENTRYA_TreePen
			EITEM	WENTRYA_TreeSPen

WNE_TEXT		EQU	1
WNE_TREE		EQU	3

			ENDC
