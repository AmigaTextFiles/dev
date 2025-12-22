	IFND	LIBRARIES_GADUTIL_I
LIBRARIES_GADUTIL_I	SET	1
**------------------------------------------------------------------------**
*
*	$VER: gadutil.i 37.10 (28.09.97)
*
*	Filename:	libraries/gadutil.i
*	Version:	37.10
*	Date:		28-Sep-97
*
*	Gadutil definitions, a dynamic gadget layout system.
*
*	© Copyright 1994-1997 by P-O Yliniemi and Staffan Hämälä.
*
*	All Rights Reserved.
*
**------------------------------------------------------------------------**

	IFND	EXEC_TYPES_I
	INCLUDE	'exec/types.i'
	ENDC

	IFND	EXEC_LIBRARIES_I
	include	"exec/libraries.i"
	ENDC

	IFND	UTILITY_TAGITEM_I
	INCLUDE	'utility/tagitem.i'
	ENDC

	IFND	INTUITION_INTUITION_I
	INCLUDE	'intuition/intuition.i'
	ENDC	

	IFND	LIBRARIES_GADTOOLS_H
	INCLUDE 'libraries/gadtools.h'
	ENDC

**------------------------------------------------------------------------**
*
* Extended gadget types available in GadUtil.library.
*

IMAGE_KIND:	        equ	50
LABEL_KIND:	        equ	51
DRAWER_KIND:		equ	52
FILE_KIND:		equ	53
BEVELBOX_KIND:		equ	54
PROGRESS_KIND:		equ	55

**-------------------- Reserved GadgetID's - don't use! ------------------**
*
* GadgetID's are really word sized, but two of these vaules are used by the
* GU_HelpGadget tag, so don't use -1 (65535), -2 (65534) or -3 (65533) as
* GadgetID!
*

GADID_RESERVED:		equ	$FFFFFFFF
WINTITLE_HELP:		equ	$FFFFFFFE
SCRTITLE_HELP:		equ	$FFFFFFFD

**--------------- Minimum recommended sizes for some gadgets -------------**
FILEKIND_WIDTH:		equ	20
FILEKIND_HEIGHT:	equ	14

DRAWERKIND_WIDTH:	equ	20
DRAWERKIND_HEIGHT:	equ	14

**------------------ Text placement for LABEL_KIND -----------------------**
*
*	___1_____2_____3___
*	|_____|_____|_____| A	Nine different placements of the text is
*	|_____|_____|_____| B	possible if the size of the box allows it.
*	|_____|_____|_____| C	The flags are the same as for BEVELBOX_KIND
*

LB_TEXT_TOP:		equ	0	; Place text on line A of the box

LB_TEXT_MIDDLE:		equ	1	; Place text on line B of the box

LB_TEXT_BOTTOM:		equ	2	; Place text on line C of the box

LB_TEXT_CENTER:		equ	0	; Place text in column 2 of the box

LB_TEXT_LEFT:		equ	4	; Place text in column 1 of the box

LB_TEXT_RIGHT:		equ	8	; Place text in column 3 of the box

**----------------- Alternatives for text placement flags ----------------**
LB_TEXT_TOP_CENTER:	equ	LB_TEXT_TOP!LB_TEXT_CENTER
LB_TEXT_TOP_LEFT:	equ	LB_TEXT_TOP!LB_TEXT_LEFT
LB_TEXT_TOP_RIGHT:	equ	LB_TEXT_TOP!LB_TEXT_RIGHT

LB_TEXT_MIDDLE_CENTER:	equ	LB_TEXT_MIDDLE!LB_TEXT_CENTER
LB_TEXT_MIDDLE_LEFT:	equ	LB_TEXT_MIDDLE!LB_TEXT_LEFT
LB_TEXT_MIDDLE_RIGHT:	equ	LB_TEXT_MIDDLE!LB_TEXT_RIGHT

LB_TEXT_BOTTOM_CENTER:	equ	LB_TEXT_BOTTOM!LB_TEXT_CENTER
LB_TEXT_BOTTOM_LEFT:	equ	LB_TEXT_BOTTOM!LB_TEXT_LEFT
LB_TEXT_BOTTOM_RIGHT:	equ	LB_TEXT_BOTTOM!LB_TEXT_RIGHT

**---------------------- Text shadow placement flags ---------------------**
LB_SHADOW_DR:		equ	0	; Place the shadow at x+1, y+1
LB_SHADOW_UR:		equ	16	; Place the shadow at x+1, y-1
LB_SHADOW_DL:		equ	32	; Place the shadow at x-1, y+1
LB_SHADOW_UL:		equ	48	; Place the shadow at x-1, y-1

**------------ Alternatives for text shadow placement flags --------------**
LB_SUNAT_UL:		equ	0	; Place the shadow at x+1, y+1
LB_SUNAT_DL:		equ	16	; Place the shadow at x+1, y-1
LB_SUNAT_UR:		equ	32	; Place the shadow at x-1, y+1
LB_SUNAT_DR:		equ	48	; Place the shadow at x-1, y-1

LB_3DTEXT:		equ	64	; Alternative to GULB_3DText, TRUE

**----------------------- Bevel box frame types  -------------------------**
BFT_BUTTON:		equ	0	; Normal button bevel box border
BFT_RIDGE:		equ	1	; STRING_KIND bevel box border
BFT_DROPBOX:		equ	2	; Icon dropbox type border

BFT_HORIZBAR:		equ	10	; Horizontal shadowed line
BFT_VERTBAR:		equ	11	; Vertical shadowed line

**------------------ Text placement for BEVELBOX_KIND --------------------**
BB_TEXT_ABOVE:		equ	0	; Place bevel box text above the
					;  upper border     ___ Example ___

BB_TEXT_IN:		equ	1	; Place bevel box text centered at
					;  the upper border --- Example ---

BB_TEXT_BELOW:		equ	2	; Place bevel box text below the
					;  upper border     ___         ___
					;                       Example

BB_TEXT_CENTER:		equ	0	; Place the text centered at the
					;  upper border (default)

BB_TEXT_LEFT:		equ	4	; Place the text left adjusted

BB_TEXT_RIGHT:		equ	8	; Place the text right adjusted

**----------------- Alternatives for text placement flags ----------------**
BB_TEXT_ABOVE_CENTER:	equ	BB_TEXT_ABOVE!BB_TEXT_CENTER
BB_TEXT_ABOVE_LEFT:	equ	BB_TEXT_ABOVE!BB_TEXT_LEFT
BB_TEXT_ABOVE_RIGHT:	equ	BB_TEXT_ABOVE!BB_TEXT_RIGHT

BB_TEXT_IN_CENTER:	equ	BB_TEXT_IN!BB_TEXT_CENTER
BB_TEXT_IN_LEFT:	equ	BB_TEXT_IN!BB_TEXT_LEFT
BB_TEXT_IN_RIGHT:	equ	BB_TEXT_IN!BB_TEXT_RIGHT

BB_TEXT_BELOW_CENTER:	equ	BB_TEXT_BELOW!BB_TEXT_CENTER
BB_TEXT_BELOW_LEFT:	equ	BB_TEXT_BELOW!BB_TEXT_LEFT
BB_TEXT_BELOW_RIGHT:	equ	BB_TEXT_BELOW!BB_TEXT_RIGHT

**---------------------- Text shadow placement flags ---------------------**
BB_SHADOW_DR:		equ	0	; Place the shadow at x+1, y+1
BB_SHADOW_UR:		equ	16	; Place the shadow at x+1, y-1
BB_SHADOW_DL:		equ	32	; Place the shadow at x-1, y+1
BB_SHADOW_UL:		equ	48	; Place the shadow at x-1, y-1

**------------ Alternatives for text shadow placement flags --------------**
BB_SUNAT_UL:		equ	0	; Place the shadow at x+1, y+1
BB_SUNAT_DL:		equ	16	; Place the shadow at x+1, y-1
BB_SUNAT_UR:		equ	32	; Place the shadow at x-1, y+1
BB_SUNAT_DR:		equ	48	; Place the shadow at x-1, y-1

BB_3DTEXT:		equ	64	; Alternative to GUBB_3DText, TRUE

**------------------------------------------------------------------------**
*
* This is the structure that actually holds the definition of a single
* gadget.  It contains the new layout tags defined below, as well as the
* normal GadTools tags.  You setup all the gadgets in a window by
* making an array of this structure and passing it to GU_LayoutGadgetsA().
*
	STRUCTURE LayoutGadget,0
		WORD lg_GadgetID		; Gadget ID
		APTR lg_LayoutTags		; struct TagItem ptr
		APTR lg_GadToolsTags		; struct TagItem ptr
		APTR lg_Gadget			; struct Gadget ptr
	LABEL lg_SIZEOF

**------------------------------------------------------------------------**
*
* Structure used to hold the built in strings of a localized program. These
* strings will be used if we couldn't get a string from the catalog.
*
*
	STRUCTURE AppString,0
		ULONG	as_ID			; String ID
		APTR	as_Str			; String pointer
	LABEL as_SIZEOF

**------------------------------------------------------------------------**
* A useful macro to fill a LayoutGadget structure.
*
* Usage:        GADGET  GadgetID,  Gad_LayoutTags,  Gad_GadToolsTags
*

GADGET:	MACRO
	dc.w	\1
	dc.l	\2,\3,0
	ENDM

LASTGAD: MACRO
	dc.w	-1
	dc.l	NULL,NULL,NULL
	ENDM

**------------------------------------------------------------------------**
* A macro to define a localized NewMenu structure
*
* Usage:        LOCMENU Type, Label ID, Flags, MutualExclude, UserData
*
* The string format for the label and shortcut key is:
*
*       SHORTCUTKEY, NULL, LABEL
*
* Use space for no shortcut.
*
* Examples:
*
* MNU_Edit_Cut:   dc.b  "X",0,"Cut"             ; Shortcut = Amiga X
* MNU_Edit_Copy:  dc.b  "C",0,"Copy"            ; Shortcut = Amiga C
* MNU_Edit_Paste: dc.b  "V",0,"Paste"           ; Shortcut = Amiga V
* MNU_Edit_Erase: dc.b  " ",0,"Erase"           ; No shortcut
*

LOCMENU: MACRO
         dc.b    \1,0           ; Type, pad
         dc.l    \2,0           ; Catalog string ID for label and cmd key
         dc.w    \3             ; Flags
         dc.l    \4,\5          ; MutualExclude, UserData
         ENDM

**------------------------------------------------------------------------**
*
* Gadutil.library is basically an extension to Gadtools.library.  It adds
* to GadTools the ability to dynamically layout gadgets according to the
* positions of other gadgets, font size, locale, etc.  The goal in designing
* this was to create a system so that programmers could easily create a GUI
* that automatically adjusted to a user's environment.
*
* Every gadget is now defined as a TagList, there is no more need to make use
* of the NewGadget structure as this taglist allows you to access all fields
* used in that structure.  An array of the TagLists for all your window's
* gadgets is then passed to GU_LayoutGadgetsA() and your gadget list is
* created.
*

GU_TagBase:	equ	TAG_USER+$60000

************ Define which kind of gadget we are going to have. *************

GU_GadgetKind:	equ	GU_TagBase+1	; Which kind of gadget to make.


********************** Gadget width control. *******************************

GU_Width:	equ	GU_TagBase+20	; Absolute gadget width.

GU_DupeWidth:	equ	GU_TagBase+21	; Duplicate the width of
					;  another gadget

GU_AutoWidth:	equ	GU_TagBase+22	; Set width according to length
					;  of text label + ti_Data

GU_Columns:	equ	GU_TagBase+23	; Set width so that approximately
					;  ti_Data columns will fit.

GU_AddWidth:	equ	GU_TagBase+24	; Add some value to the total
					;  width calculation.

GU_MinWidth:	equ	GU_TagBase+25	; Make sure width is at least this

GU_MaxWidth:	equ	GU_TagBase+26	; Make sure width is at most this

GU_AddWidChar:	equ	GU_TagBase+27	; Add length of ti_Data characters
					;  to the gadget width

GU_FractWidth:	equ	GU_TagBase+28	; Divide / multiply gadget width
					;  with ti_Data

********************** Gadget height control. ******************************

GU_Height:	equ	GU_TagBase+40	; Absolute gadget height.

GU_DupeHeight:	equ     GU_TagBase+41	; Duplicate the height of another
					;  gadget.

GU_AutoHeight:	equ	GU_TagBase+42	; Set height according to height
					;  of text font + ti_Data.

GU_HeightFactor: equ	GU_TagBase+43	; Make the gadget height a
					;  multiple of the font height.

GU_AddHeight:	equ	GU_TagBase+44	; Add some value to the total
					;  height calculation

GU_MinHeight:	equ	GU_TagBase+45	; Make sure height is at least this

GU_MaxHeight:	equ	GU_TagBase+46	; Make sure height is at most this

GU_AddHeiLines:	equ	GU_TagBase+47	; Add the height of ti_Data lines
					;  to the gadget height

GU_FractHeight:	equ	GU_TagBase+48	; Divide / multiply gadget height
					;  with ti_Data

******************** Gadget top edge control. ******************************

GU_Top:		equ	GU_TagBase+60	; Absolute top edge.

GU_TopRel:	equ	GU_TagBase+61	; Top edge relative to bottom
					;  edge of another gadget.

GU_AddTop:	equ	GU_TagBase+62	; Add some value to the final
				 	;  top edge calculation.

GU_AlignTop:	equ	GU_TagBase+63	; Align top edge of gadget with
					;  top edge of another gadget.

GU_AdjustTop:	equ	GU_TagBase+64	; Add the height of the text
					;  font + ti_Data to the top edge.

GU_AddTopLines: equ	GU_TagBase+65	; Add the height of ti_Data lines
					;  to the top edge

******************** Gadget bottom edge control. ***************************

GU_Bottom:	equ	GU_TagBase+80	; Absolute bottom edge.

GU_BottomRel:	equ	GU_TagBase+81	; Bottom edge relative to top
					;  edge of another gadget.

GU_AddBottom:	equ	GU_TagBase+82	; Add some value to the final
					;  bottom edge calculation.

GU_AlignBottom:	equ	GU_TagBase+83	; Align bottom edge of gadget with
					;  bottom edge of another gadget.

GU_AdjustBottom: equ    GU_TagBase+84   ; Subtract the height of the text
                                        ;  font + ti_Data from the top edge.

************************ Gadget left edge control. *************************

GU_Left:	equ	GU_TagBase+100	; Absolute left edge.

GU_LeftRel:	equ	GU_TagBase+101	; Left edge relative to right
					;  edge of another gadget.

GU_AddLeft:	equ	GU_TagBase+102	; Add some value to the final
					;  left edge calculation.

GU_AlignLeft:	equ	GU_TagBase+103	; Align left edge of gadget with
					;  left edge of another gadget.

GU_AdjustLeft:	equ	GU_TagBase+104	; Add the width of the text
					;  label + ti_Data to the left edge.

GU_AddLeftChar: equ	GU_TagBase+105	; Add length of ti_Data characters
					;  to the left edge.

*********************** Gadget right edge control. *************************

GU_Right:	equ	GU_TagBase+120	; Absolute right edge.

GU_RightRel:	equ	GU_TagBase+121	; Right edge relative to left
					;  edge of another gadget.

GU_AddRight:	equ	GU_TagBase+122	; Add some value to the final
					;  right edge calculation.

GU_AlignRight:	equ	GU_TagBase+123	; Align right edge of gadget with
					;  right edge of another gadget.

GU_AdjustRight: equ     GU_TagBase+124  ; Subtract the width of the text
                                        ; label + ti_Data from the left edge

******************************** Other tags ********************************

GU_ToggleSelect: equ    GU_TagBase+150  ; Make the gadget toggleselect

GU_Selected:    equ     GU_TagBase+151  ; Change toggleselect default to
                                        ;  selected.

GU_HelpGadget:	equ	GU_TagBase+152	; Gadget ID of a TEXT_KIND gadget that
					; will show a short help text

GU_HelpText:	equ	GU_TagBase+153	; Pointer to the text to be shown in
					; the help gadget

GU_LocaleHelp:	equ	GU_TagBase+154	; Localized version of GU_HelpText
					; ti_Data of this tag is the string ID

************ Access to the other fields of the NewGadget structure. ********

GU_GadgetText:	equ	GU_TagBase+160	;  Gadget label. 

GU_TextAttr:	equ	GU_TagBase+161	;  Desired font for gadget label.

GU_Flags:	equ	GU_TagBase+162	;  Gadget flags.

GU_UserData:	equ	GU_TagBase+163	;  Gadget UserData.

GU_LocaleText:	equ	GU_TagBase+164	;  Gadget label taken from a locale.

**************** Tags to store some of the calculated values ***************

GU_StoreLeft:	equ	GU_TagBase+170	; Store the gadget's left position
GU_StoreTop:	equ	GU_TagBase+171	; Store the gadget's top position
GU_StoreWidth:	equ	GU_TagBase+172	; Store the gadget's width
GU_StoreHeight:	equ	GU_TagBase+173	; Store the gadget's height
GU_StoreRight:	equ	GU_TagBase+174	; Store the gadget's right position
GU_StoreBottom:	equ	GU_TagBase+175	; Store the gadget's bottom position

***************** Tags for GadUtil's extended gadget kinds. ****************

**---------------------------- IMAGE_KIND tags ---------------------------**
GUIM_Image:	equ	GU_TagBase+200	; Image structure for an image
					;  gadget

GUIM_ReadOnly:	equ	GU_TagBase+201	; TRUE if read-only. 

GUIM_SelectImg: equ     GU_TagBase+202  ; Other image for IMAGE_KIND gadgets.

GUIM_BOOPSILook: equ    GU_TagBase+203  ; Change the look of the selected
                                        ;  image on one-image-buttons.

**------------------------- BEVELBOX_KIND tags ---------------------------**
GUBB_Recessed:	equ	GU_TagBase+220	; TRUE for a recessed bevel box

GUBB_FrameType:	equ	GU_TagBase+221	; Frame type for bevel box

GUBB_TextColor: equ	GU_TagBase+222	; Color of title text above box

GUBB_TextPen:	equ	GU_TagBase+223	; Pen to print title text with -
					;  overrides GUBB_TextColor

GUBB_Flags:	equ	GU_TagBase+224	; Text placement flags

GUBB_3DText:	equ	GU_TagBase+225	; Tag to enable 3D text (shadow)
					;  Not needed if GUBB_ShadowColor
					;  or GUBB_ShadowPen is used

GUBB_ShadowColor: equ	GU_TagBase+226	; Color of the title text's shadow

GUBB_ShadowPen:	equ	GU_TagBase+227	; Pen to print the text's shadow
					;  with - overrides GUBB_ShadowColor

**-------------------------- LABEL_KIND tags -----------------------------**
GULB_TextColor: equ	GU_TagBase+222	; Color of the text

GULB_TextPen:	equ	GU_TagBase+223	; Pen to print text with -
					;  overrides GULB_TextColor

GULB_Flags:	equ	GU_TagBase+224	; Text placement flags

GULB_3DText:	equ	GU_TagBase+225	; Tag to enable 3D text (shadow)
					;  Not needed if GULB_ShadowColor
					;  or GULB_ShadowPen is used

GULB_ShadowColor: equ	GU_TagBase+226	; Color of the text's shadow

GULB_ShadowPen:	equ	GU_TagBase+227	; Pen to print the text's shadow
					;  with - overrides GULB_ShadowColor

**------------------------- PROGRESS_KIND tags ---------------------------**
GUPR_FillColor:	equ	GU_TagBase+240	; Color of filled part of indicator

GUPR_FillPen:	equ	GU_TagBase+241	; Pen to fill the indicator with
					;  - overrides GUPR_FillColor

GUPR_BackColor:	equ	GU_TagBase+242	; Color of the background of the
					;  indicator

GUPR_BackPen:	equ	GU_TagBase+243	; Pen to use for the indocator's
					;  background - overrides
					;  GUPR_BackColor

GUPR_Current:	equ	GU_TagBase+244	; Current value of the indicator

GUPR_Total:	equ	GU_TagBase+245	; Total value for the indicator

************** Tags passed directly to GU_LayoutGadgetsA(). ****************

GU_RightExtreme: equ	GU_TagBase+500	; ti_Data is a pointer to a longword
					;  that is used to store the right-
					;  most point that a gadget will
					;  exist in.

GU_LowerExtreme: equ	GU_TagBase+501	; ti_Data is a pointer to a longword
					;  that is used to store the lower-
					;  most point that a gadget will
					;  exist in.

GU_Catalog:	equ	GU_TagBase+502	; Indicates locale for the gadgets. 

GU_DefTextAttr:	equ	GU_TagBase+503	; Specifies a default font for use
					;  with all gadgets, can still be
					;  over-ridden with GU_TextAttr.

GU_AppStrings:	equ	GU_TagBase+504	; Application string table w/IDs. 

GU_BorderLeft:	equ	GU_TagBase+505	; Size of window left border. 

GU_BorderTop:	equ	GU_TagBase+506	; Size of window top border. 

GU_NoCreate:	equ	GU_TagBase+507	; Don't actually create the gadgets. 

GU_MinimumIDCMP: equ	GU_TagBase+508	; Minimum required IDCMP, so that all
					;  gadgets will work

GU_DefWTitle:	equ	GU_TagBase+509	; Text to show in window title when
					;  pointer is outside a gadget with
					;  help text

GU_DefLocWTitle: equ	GU_TagBase+510	; Localized default window title

GU_DefSTitle:	equ	GU_TagBase+511	; Text to show in screen title when
					;  pointer is outside a gadget with
					;  help text

GU_DefLocSTitle: equ	GU_TagBase+512	; Localized default screen title

GU_DefHelpText:	equ	GU_TagBase+513	; Text to show in any gadget used to
					;  display help text when pointer is
					;  outside a gadget with help text

GU_DefLocHelpText: equ	GU_TagBase+514	; Localized default help text

****************************** Hotkey tags ***********************************

GU_Hotkey:	equ	GU_TagBase+300	; Hotkey for gadget (VANILLAKEY)

********************* Boolean flags for hotkey code **************************

GU_HotkeyCase:	equ	GU_TagBase+301	; TRUE for case sensitive hotkey
GU_LabelHotkey:	equ	GU_TagBase+302	; TRUE = get hotkey code from label
GU_RawKey:	equ	GU_TagBase+303	; TRUE if hotkey is a RAWKEY code

*********************** Constants for hotkey support ***********************

GADUSERMAGIC:	equ	$1122		; Identification for structure

******************** Public bit numbers for gu_Flags ***********************

GU_HOTKEYCASE:	equ	0		; Hotkey is case-sensitive
GU_RAWKEY:	equ	2		; Hotkey is a RAWKEY code

******************** Structure gg_UserData points to ***********************
*
* This structure is the public part of the allocated data structure for
* hotkeys and IMAGE_KIND gadgets (including FILE_KIND and DRAWER_KIND).
*
* This structure should be considered READ ONLY. The only fields you may
* change is the gu_Code and gu_Flags fields.
*
* DO NOT WRITE ANYTHING BEYOND THIS STRUCTURE WITHOUT ALLOCATING MEMORY FIRST

	STRUCTURE	GU_Public,0
		WORD	gu_Magic	; Identification word for structure
		LONG	gu_GadFlags	; Flags for GENERIC kind GadUtil gadgets
		BYTE	gu_Flags	; Flags for the hotkey type
		BYTE	gu_Code		; VANILLA or RAWKEY code to react on
		WORD	gu_Active	; Active entry for some gadget kinds
		WORD	gu_MaxVal	; Maximum value for some gadgets
		WORD	gu_MinVal	; Minimum value for some gadgets
		LONG	gu_GadgetType	; Gadget type that was created
		APTR	gu_HelpGadget	; Pointer to gadget for help text
		APTR	gu_HelpText	; The help text for this gadget
	LABEL	GUPU_SIZEOF

**------------------------------------------------------------------------**
**      			Library base				  **
**------------------------------------------------------------------------**

	STRUCTURE	GadUtilBase,LIB_SIZE
		UBYTE	gub_Flags		; Private!
		UBYTE	gub_pad			; Private!

                APTR    gub_GadToolsBase	; The following library bases
                APTR    gub_GfxBase		;  may be read and used by
                APTR    gub_IntBase		;  your program
                APTR    gub_LocaleBase		; LocaleBase may be NULL!
                APTR    gub_UtilityBase
		APTR	gub_DiskFontBase	; DiskFontBase may be NULL!

		LONG	gub_SegList		; Private!
	LABEL	GadUtilBase_SIZEOF


GADUTILNAME:	MACRO
		dc.b	"gadutil.library",0
		ENDM

GADUTIL_VER:	equ	37
GADUTIL_REV:	equ	10

**------------------------------------------------------------------------**
**      			BevelBox structure			  **
**------------------------------------------------------------------------**
	STRUCTURE BBoxData,0
		WORD	bbd_XPos		; X position of box
		WORD	bbd_YPos		; Y position of box
		WORD	bbd_Width		; Width of box
		WORD	bbd_Height		; Height of box

		WORD	bbd_LeftEdge		; Left edge of text
		WORD	bbd_TopEdge		; Top edge of text
		WORD	bbd_TextWidth		; Pixel width of text

		LONG	bbd_TextFont		; Font to print text with
		LONG	bbd_Text		; Text to display
		
		BYTE	bbd_FrontPen		; Text color
		BYTE	bbd_Flags		; Text placement flags
		BYTE	bbd_Recessed		; Recessed frame
		BYTE	bbd_FrameType		; Type of box frame
		BYTE	bbd_ShadowPen		; Shadow color
		BYTE	bbd_Reserved1		; No use in v36.53 - reserved!
		APTR	bbd_HelpGadget		; Pointer to gadget for help text
		APTR	bbd_HelpText		; The help text for this gadget
	LABEL bbd_SIZEOF

**------------------------------------------------------------------------**
**      		ProgressIndicator structure			  **
**------------------------------------------------------------------------**

	STRUCTURE ProgressGad,0
		WORD	pg_XPos			; X pos of box around gadget
		WORD	pg_YPos			; Y pos of box around gadget
		WORD	pg_Width		; Width of box around gadget
		WORD	pg_Height		; Height of box around gadget
		LONG	pg_Current		; Current value of indicator
		LONG	pg_Total		; Total value of indicator
		BYTE	pg_FillColor		; Color of upto current value
		BYTE	pg_BackColor		; Color from current to end
		BYTE	pg_Flags		; Flags
		BYTE	pg_reserved1
		WORD	pg_XFilledTo		; Initialized to pg_XPos + 4
		APTR	pg_HelpGadget		; Pointer to gadget for help text
		APTR	pg_HelpText		; The help text for this gadget
	LABEL pg_SIZEOF

	ENDC							; gadutil.i
