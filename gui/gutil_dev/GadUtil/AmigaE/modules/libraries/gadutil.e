OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*------------------------------------------------------------------------**
**
**	$VER: gadutil.h 37.10 (28.09.97)
**
**	Filename:	libraries/gadutil.h
**	Version:	37.10
**	Date:		28-Sep-97
**
**	GadUtil definitions, a dynamic gadget layout system.
**
**	© Copyright 1994-1997 by P-O Yliniemi and Staffan Hämälä.
**
**	All Rights Reserved.
**
**
** Amiga E module source written by Terje Pedersen
** Reformatted and updated for GadUtil 37.10 by P-O Yliniemi
**
**------------------------------------------------------------------------*/

MODULE 'exec/types','exec/libraries','utility/tagitem','intuition/intuition',
		'graphics/gfxbase','graphics/text','intuition/intuitionbase'

/*------------------------------------------------------------------------**
**
** Extended gadget types available in GadUtil.library.
**
*/

ENUM 	IMAGE_KIND=50,
	LABEL_KIND,
	DRAWER_KIND,
	FILE_KIND,
	BEVELBOX_KIND,
	PROGRESS_KIND

/*-------------------- Reserved GadgetID's - don't use! ------------------**
**
** GadgetID's are really word sized, but two of these vaules are used by the
** GU_HelpGadget tag, so don't use -1 (65535), -2 (65534) or -3 (65533) as
** GadgetID!
**
*/

CONST 	GADID_RESERVED=$FFFFFFFF,
	WINTITLE_HELP=$FFFFFFFE,
	SCRTITLE_HELP=$FFFFFFFD

/*--------------- Minimum recommended sizes for some gadgets -------------*/
CONST 	FILEKIND_WIDTH=20,
	FILEKIND_HEIGHT=14,

	DRAWERKIND_WIDTH=20,
	DRAWERKIND_HEIGHT=14

/*------------------ Text placement for LABEL_KIND -----------------------**
**
**	___1_____2_____3___
**	|_____|_____|_____| A	Nine different placements of the text is
**	|_____|_____|_____| B	possible if the size of the box allows it.
**	|_____|_____|_____| C	The flags are the same as for BEVELBOX_KIND
*/

CONST  	LB_TEXT_TOP=0		/* Place text on line A of the box   */
SET	LB_TEXT_MIDDLE,		/* Place text on line B of the box   */
	LB_TEXT_BOTTOM,		/* Place text on line C of the box   */
	LB_TEXT_LEFT,		/* Place text in column 1 of the box */
	LB_TEXT_RIGHT		/* Place text in column 3 of the box */
CONST	LB_TEXT_CENTER=0	/* Place text in column 2 of the box */

/*----------------- Alternatives for text placement flags ----------------*/
CONST	LB_TEXT_TOP_CENTER=LB_TEXT_TOP OR LB_TEXT_CENTER,
	LB_TEXT_TOP_LEFT=LB_TEXT_TOP OR LB_TEXT_LEFT,
	LB_TEXT_TOP_RIGHT=LB_TEXT_TOP OR LB_TEXT_RIGHT,

	LB_TEXT_MIDDLE_CENTER=LB_TEXT_MIDDLE OR LB_TEXT_CENTER,
	LB_TEXT_MIDDLE_LEFT=LB_TEXT_MIDDLE OR LB_TEXT_LEFT,
	LB_TEXT_MIDDLE_RIGHT=LB_TEXT_MIDDLE OR LB_TEXT_RIGHT,

	LB_TEXT_BOTTOM_CENTER=LB_TEXT_BOTTOM OR LB_TEXT_CENTER,
	LB_TEXT_BOTTOM_LEFT=LB_TEXT_BOTTOM OR LB_TEXT_LEFT,
	LB_TEXT_BOTTOM_RIGHT=LB_TEXT_BOTTOM OR LB_TEXT_RIGHT

/*---------------------- Text shadow placement flags ---------------------*/
CONST	LB_SHADOW_DR=0,		/* Place the shadow at x+1, y+1   */
 	LB_SHADOW_UR=16,	/* Place the shadow at x+1, y-1   */
	LB_SHADOW_DL=32,	/* Place the shadow at x-1, y+1   */
	LB_SHADOW_UL=48		/* Place the shadow at x-1, y-1   */

/*------------ Alternatives for text shadow placement flags --------------*/
CONST 	LB_SUNAT_UL=0		/* Place the shadow at x+1, y+1   */
CONST 	LB_SUNAT_DL=16,		/* Place the shadow at x+1, y-1   */
	LB_SUNAT_UR=32,		/* Place the shadow at x-1, y+1   */
	LB_SUNAT_DR=48,		/* Place the shadow at x-1, y-1   */

	LB_3DTEXT=64	/* Alternative to GULB_3DText, TRUE   */

/*-------------------------- Bevel box frame types -----------------------*/
ENUM	BFT_BUTTON=0,		/* Normal button bevel box border */
	BFT_RIDGE,		/* STRING_KIND bevel box border   */
	BFT_DROPBOX		/* Icon dropbox type border	  */

CONST 	BFT_HORIZBAR=10		/* Horizontal shadowed line       */
CONST	BFT_VERTBAR=11		/* Vertical shadowed line         */

/*------------------ Text placement for BEVELBOX_KIND --------------------*/
ENUM 	BB_TEXT_ABOVE=0,	/* Place bevel box text above the
				 * upper border   ___ Example ___ */

	BB_TEXT_IN,		/* Place bevel box text centered at
				 * the upper border --- Example --- */

	BB_TEXT_BELOW		/* Place bevel box text below the
				 * upper border   ___        ___
				 *                    Example	  */

CONST 	BB_TEXT_CENTER=0,	/* Place the text centered at the
				 * upper border (default)         */

	BB_TEXT_LEFT=4,		/* Place the text left adjusted   */

	BB_TEXT_RIGHT=8		/* Place the text right adjusted  */

/*--------------- Alternatives to text placement flags -------------------*/
CONST	BB_TEXT_ABOVE_CENTER=BB_TEXT_ABOVE OR BB_TEXT_CENTER,
	BB_TEXT_ABOVE_LEFT=BB_TEXT_ABOVE OR BB_TEXT_LEFT,
	BB_TEXT_ABOVE_RIGHT=BB_TEXT_ABOVE OR BB_TEXT_RIGHT,

	BB_TEXT_IN_CENTER=BB_TEXT_IN OR BB_TEXT_CENTER,
	BB_TEXT_IN_LEFT=BB_TEXT_IN OR BB_TEXT_LEFT,
	BB_TEXT_IN_RIGHT=BB_TEXT_IN OR BB_TEXT_RIGHT,

	BB_TEXT_BELOW_CENTER=BB_TEXT_BELOW OR BB_TEXT_CENTER,
	BB_TEXT_BELOW_LEFT=BB_TEXT_BELOW OR BB_TEXT_LEFT,
	BB_TEXT_BELOW_RIGHT=BB_TEXT_BELOW OR BB_TEXT_RIGHT

/*-----------------------Text Shadow placement ---------------------------*/
CONST	BB_SHADOW_DR=0,		/* Place the shadow at x+1, y+1   */
	BB_SHADOW_UR=16,	/* Place the shadow at x+1, y-1   */
	BB_SHADOW_DL=32,	/* Place the shadow at x-1, y+1   */
	BB_SHADOW_UL=48		/* Place the shadow at x-1, y-1   */

/*------------------ Alternatives for shadow placement -------------------*/
CONST 	BB_SUNAT_UL=0,		/* Place the shadow at x+1, y+1   */
	BB_SUNAT_DL=16,		/* Place the shadow at x+1, y-1   */
	BB_SUNAT_UR=32,		/* Place the shadow at x-1, y+1   */
	BB_SUNAT_DR=48,		/* Place the shadow at x-1, y-1   */

	BB_3DTEXT=64		/* Alternative to GUBB_3DText, TRUE */

/*------------------------------------------------------------------------**
**
** This is the structure that actually holds the definition of a single
** gadget.  It contains the new layout tags defined below, as well as the
** normal GadTools tags.  You setup all the gadgets in a window by
** making an array of this structure and passing it to GU_LayoutGadgetsA().
**
*/
OBJECT layoutgadget
	lg_GadgetID:INT
	lg_LayoutTags:PTR TO tagitem
	lg_GadToolsTags:PTR TO tagitem
	lg_Gadget:PTR TO gadget
ENDOBJECT

/*------------------------------------------------------------------------**
**
** Structure used to hold the built in strings of a localized program. These
** strings will be used if we couldn't get a string from the catalog.
**
*/
OBJECT appstring
	as_ID				/* String ID			  */
	as_Str				/* String pointer		  */
ENDOBJECT

/*------------------------------------------------------------------------**
**
** GadUtil.library is basically an extension to Gadtools.library.  It adds
** to GadTools the ability to dynamically layout gadgets according to the
** positions of other gadgets, font size, locale, etc. The goal in designing
** this was to create a system so that programmers could easily create a GUI
** that automatically adjusted to a user's environment.
**
** Every gadget is now defined as a TagList, there is no more need to make
** use of the NewGadget structure as this taglist allows you to access all
** fields used in that structure. An array of the TagLists for all your
** window's gadgets is then passed to GU_LayoutGadgetsA() and your gadget
** list is created.
*/

CONST	GU_TagBase=TAG_USER + $60000

/*********** Define which kind of gadget we are going to have. ************/

CONST 	GU_GadgetKind=GU_TagBase+1	/* Which kind of gadget to make.  */


/************************ Gadget width control. ***************************/

CONST	GU_Width=GU_TagBase+20,		/* Absolute gadget width.	  */

	GU_DupeWidth=GU_TagBase+21,	/* Duplicate the width of another
					 * gadget.			  */

	GU_AutoWidth=GU_TagBase+22,	/* Set width according to length
					 * of text label + ti_Data.       */

	GU_Columns=GU_TagBase+23,	/* Set width so that approximately
					 * ti_Data columns will fit.	  */

	GU_AddWidth=GU_TagBase+24,	/* Add some value to the total
					 * width calculation.		  */

	GU_MinWidth=GU_TagBase+25,	/* Make sure width is at least this */

	GU_MaxWidth=GU_TagBase+26,	/* Make sure width is at most this */

	GU_AddWidChar=GU_TagBase+27,	/* Add the width of ti_Data chars
					 *  to the gadget width		  */

	GU_FractWidth=GU_TagBase+28	/* Divide / multiply gadget width
					 *  with ti_Data		  */

/************************* Gadget height control. *************************/

CONST	GU_Height=GU_TagBase+40,	/* Absolute gadget height. 	  */

	GU_DupeHeight=GU_TagBase+41,	/* Duplicate the height of another
					 * gadget.			  */

	GU_AutoHeight=GU_TagBase+42,	/* Set height according to height
					 * of text font + ti_Data.	  */

	GU_HeightFactor=GU_TagBase+43,	/* Make the gadget height a
					 * multiple of the font height.	  */

	GU_AddHeight=GU_TagBase+44,	/* Add some value to the total
					 * height calculation.		  */

	GU_MinHeight=GU_TagBase+45,	/* Make sure height is at least this */

	GU_MaxHeight=GU_TagBase+46,	/* Make sure height is at most this */

	GU_AddHeiLines=GU_TagBase+47,	/* Add the height of ti_Data lines
					 *  to the gadget height	  */

	GU_FractHeight=GU_TagBase+48	/* Divide / multiply gadget height
					 *  with ti_Data		  */

/************************* Gadget top edge control. ***********************/

CONST 	GU_Top=GU_TagBase+60,		/* Absolute top edge.		  */

	GU_TopRel=GU_TagBase+61,	/* Top edge relative to bottom
					 * edge of another gadget.	  */

	GU_AddTop=GU_TagBase+62,	/* Add some value to the final
					 * top edge calculation.	  */

	GU_AlignTop=GU_TagBase+63,	/* Align top edge of gadget with
					 * top edge of another gadget.	  */

	GU_AdjustTop=GU_TagBase+64,	/* Add the height of the text font
					 * + ti_Data to the top edge.	  */

	GU_AddTopLines=GU_TagBase+65	/* Add the height of ti_Data lines
					 * to the top edge.		  */

/*********************** Gadget bottom edge control. **********************/

CONST	GU_Bottom=GU_TagBase+80,	/* Absolute bottom edge.	  */

	GU_BottomRel=GU_TagBase+81,	/* Bottom edge relative to top
					 * edge of another gadget.	  */

	GU_AddBottom=GU_TagBase+82,	/* Add some value to the final
					 * bottom edge calculation.	  */

	GU_AlignBottom=GU_TagBase+83,	/* Align bottom edge of gadget with
					 * bottom edge of another gadget. */

	GU_AdjustBottom=GU_TagBase+84	/* Subtract the height of the text
					 * font + ti_Data from the top edge */

/********************** Gadget left edge control. *************************/

CONST 	GU_Left=GU_TagBase+100,		/* Absolute left edge.		  */

	GU_LeftRel=GU_TagBase+101,	/* Left edge relative to right
					 * edge of another gadget.	  */

	GU_AddLeft=GU_TagBase+102,	/* Add some value to the final
					 * left edge calculation.	  */

	GU_AlignLeft=GU_TagBase+103,	/* Align left edge of gadget with
					 * left edge of another gadget.	  */

	GU_AdjustLeft=GU_TagBase+104,	/* Add the width of the text label
					 * + ti_Data to the left edge.	  */

	GU_AddLeftChar=GU_TagBase+105	/* Add length of ti_Data characters
					 * to the left edge.		  */

/********************** Gadget right edge control. ************************/

CONST	GU_Right=GU_TagBase+120,	/* Absolute right edge.		  */

	GU_RightRel=GU_TagBase+121,	/* Right edge relative to left
					 * edge of another gadget.	  */

	GU_AddRight=GU_TagBase+122,	/* Add some value to the final
					 * right edge calculation.	  */

	GU_AlignRight=GU_TagBase+123,	/* Align right edge of gadget with
					 * right edge of another gadget.  */

	GU_AdjustRight=GU_TagBase+124	/* Subtract the width of the text
					 * label + ti_Data from the left edge */

/******************************* Other tags *******************************/

CONST 	GU_ToggleSelect=GU_TagBase+150,	/* Create a toggle-select gadget -
					 * only BUTTON_KIND & IMAGE_KIND  */

	GU_Selected=GU_TagBase+151,	/* Set default state of toggle-
					 * select gadget		  */

	GU_HelpGadget=GU_TagBase+152,	/* Gadget ID of a TEXT_KIND gadget that
					 * will show a short help text */

	GU_HelpText=GU_TagBase+153,	/* Pointer to the text to be shown in
					 * the help gadget		  */

	GU_LocaleHelp=GU_TagBase+154	/* Localized version of GU_HelpText
 					 * ti_Data of this tag is the string ID */

/********* Access to the other fields of the NewGadget structure **********/

CONST 	GU_GadgetText=GU_TagBase+160,	/* Gadget label.		  */

	GU_TextAttr=GU_TagBase+161,	/* Desired font for gadget label. */

	GU_Flags=GU_TagBase+162,	/* Gadget flags.		  */

	GU_UserData=GU_TagBase+163,	/* Gadget UserData.		  */

	GU_LocaleText=GU_TagBase+164	/* Gadget label taken from a locale. */

/************* Tags to store some of the calculated values *****************/

CONST	GU_StoreLeft=GU_TagBase+170,	/* Store the gadget's left position */
	GU_StoreTop=GU_TagBase+171,	/* Store the gadget's top position */
	GU_StoreWidth=GU_TagBase+172,	/* Store the gadget's width        */
	GU_StoreHeight=GU_TagBase+173,	/* Store the gadget's height       */
	GU_StoreRight=GU_TagBase+174,	/* Store the gadget's right position */
	GU_StoreBottom=GU_TagBase+175	/* Store the gadget's bottom position */

/*************** Tags for GadUtil's extended gadget kinds. *****************/

/*---------------------------- IMAGE_KIND tags ---------------------------*/
CONST	GUIM_Image=GU_TagBase+200,	/* Image structure for an image
					 * gadget.			  */

	GUIM_ReadOnly=GU_TagBase+201,	/* TRUE if read-only.		  */

	GUIM_SelectImg=GU_TagBase+202,	/* Selected image for IMAGE_KIND
	 				 * gadgets			  */

	GUIM_BOOPSILook=GU_TagBase+203	/* Render selected image background
					 * with the fillpen (default = TRUE) */
					 
/*------------------------- BEVELBOX_KIND tags ---------------------------*/
CONST	GUBB_Recessed=GU_TagBase+220,	/* TRUE for a recessed bevel box  */

	GUBB_FrameType=GU_TagBase+221,	/* Frame type for bevel box	  */

	GUBB_TextColor=GU_TagBase+222,	/* Color of the title text	  */

	GUBB_TextPen=GU_TagBase+223,	/* Pen to print title text with -
					 *  overrides GUBB_TextColor	  */

	GUBB_Flags=GU_TagBase+224,	/* Text placement flags		  */

	GUBB_3DText=GU_TagBase+225,	/* Tag to enable 3D text (shadow)
					 *  Not needed if GUBB_ShadowColor
					 *  or GUBB_ShadowPen is used	  */

	GUBB_ShadowColor=GU_TagBase+226,/* Color of the title text's shadow */

	GUBB_ShadowPen=GU_TagBase+227	/* Pen to print the text's shadow
					 *  with - overrides GUBB_ShadowColor */

/*-------------------------- LABEL_KIND tags -----------------------------*/
CONST	GULB_TextColor=GU_TagBase+222,	/* Color of the text		  */

	GULB_TextPen=GU_TagBase+223,	/* Pen to print text with -
					 *  overrides GULB_TextColor	  */

	GULB_Flags=GU_TagBase+224,	/* Text placement flags		  */

	GULB_3DText=GU_TagBase+225,	/* Tag to enable 3D text (shadow)
					 *  Not needed if GULB_ShadowColor
					 *  or GULB_ShadowPen is used	  */

	GULB_ShadowColor=GU_TagBase+226,/* Color of the text's shadow	  */

	GULB_ShadowPen=GU_TagBase+227	/* Pen to print the text's shadow
					 *  with - overrides GULB_ShadowColor */

/*------------------------- PROGRESS_KIND tags ---------------------------*/
CONST	GUPR_FillColor=GU_TagBase+240,	/* Color of filled part of indicator */

	GUPR_FillPen=GU_TagBase+241,	/* Pen to fill the indicator with
					 *  - overrides GUPR_FillColor	  */

	GUPR_BackColor=GU_TagBase+242,	/* Color of the background of the
					 *  indicator			  */

	GUPR_BackPen=GU_TagBase+243,	/* Pen to use for the indocator's
					 *  background - overrides
					 *  GUPR_BackColor		  */

	GUPR_Current=GU_TagBase+244,	/* Current value of the indicator */

	GUPR_Total=GU_TagBase+245	/* Total value for the indicator  */

/************** Tags passed directly to GU_LayoutGadgetsA(). **************/

CONST	GU_RightExtreme=GU_TagBase+500,	/* ti_Data is a pointer to a LONG
					 * that is used to store the right-
					 * most point that a gadget
					 * will exist in.		*/

	GU_LowerExtreme=GU_TagBase+501,	/* ti_Data is a pointer to a LONG
					 * that is used to store the lower-
					 * most point that a gadget will
					 * exist in.			  */

	GU_Catalog=GU_TagBase+502,	/* Indicates locale for the gadgets. */


	GU_DefTextAttr=GU_TagBase+503,	/* Specifies a default font for use
					 * with all gadgets, can still be
					 * over-ridden with GU_TextAttr.  */

	GU_AppStrings=GU_TagBase+504,	/* Application string table w/IDs. */

	GU_BorderLeft=GU_TagBase+505,	/* Size of window left border.	  */

	GU_BorderTop=GU_TagBase+506,	/* Size of window top border.	  */

	GU_NoCreate=GU_TagBase+507,	/* Don't actually create the gadgets. */

	GU_MinimumIDCMP=GU_TagBase+508,	/* Minimum required IDCMP, so that
					 *  all gadgets will work	  */

	GU_DefWTitle=GU_TagBase+509,	/* Text to show in window title when
					 *  pointer is outside a gadget with
					 *  help text			  */

	GU_DefLocWTitle=GU_TagBase+510,	/* Localized default window title */

	GU_DefSTitle=GU_TagBase+511,	/* Text to show in screen title when
					 *  pointer is outside a gadget with
					 *  help text			  */

	GU_DefLocSTitle=GU_TagBase+512,	/* Localized default screen title */

	GU_DefHelpText=GU_TagBase+513,	/* Text to show in any gadget used to
					 *  display help text when pointer is
					 *  outside a gadget with help text*/

	GU_DefLocHelpText=GU_TagBase+514 /* Localized default help text	  */

/***************************** Hotkey tags ********************************/

CONST GU_Hotkey=GU_TagBase+300		/* Hotkey for gadget (VANILLAKEY) */

/********************* Boolean flags for hotkey code **********************/

CONST 	GU_HotkeyCase=GU_TagBase+301,	/* TRUE for a case-sensitive hotkey */
	GU_LabelHotkey=GU_TagBase+302,	/* TRUE = get hotkey code from label */
	GU_RawKey=GU_TagBase+303	/* TRUE if hotkey is a RAWKEY code */

/*********************** Constants for hotkey support *********************/

CONST GADUSERMAGIC=$1122		/* Identification for structure that
					 * the gadgets UserData points to */

/******************* Public bit numbers for gu_Flags **********************/

CONST 	GU_HOTKEYCASE=0,		/* Hoykey is case-sensitive	  */
  	GU_RAWKEY=2			/* gu_Code is a RAWKEY code	  */

CONST	GU_HOTKEYCASEMASK=1, 		/* Mask for GU_HOTKEYCASE bit  */
 	GU_RAWKEYMASK=4		    	/* Mask for GU_RAWKEY bit	  */

/************** Structure the gadget's UserData points to ******************
*
* This structure is the public part of the allocated data structure for
* hotkeys and IMAGE_KIND gadgets (including FILE_KIND and DRAWER_KIND).
*
* This structure should be considered READ ONLY. The only fields you may
* change is the gu_Code and gu_Flags fields.
*
* DO NOT WRITE ANYTHING BEYOND THIS STRUCTURE WITHOUT ALLOCATING MEMORY FIRST
*
*/

OBJECT gu_public
	gu_Magic:INT		/* Identification word for structure	  */
	gu_GadFlags:LONG	/* Flags for GENERIC kind GadUtil gadgets */
	gu_Flags:CHAR		/* Flags for the hotkey type		  */
	gu_Code:CHAR		/* VANILLA or RAWKEY code to react on	  */
	gu_Active:INT		/* Active entry for some gadget kinds	  */
	gu_MaxVal:INT		/* Maximum value for some gadgets	  */
	gu_MinVal:INT		/* Minimum value for some gadgets	  */
	gu_GadgetType:LONG	/* Gadget type that was created		  */
	gu_HelpGadget:PTR TO gadget	/* Pointer to gadget for help text*/
	gu_HelpText		/* The help text for this gadget	  */
ENDOBJECT

/*------------------------------------------------------------------------**
**      			Library base				  **
**------------------------------------------------------------------------*/

OBJECT gadutilbase
	libnode:PTR TO lib
	gub_Flags:CHAR		/* Private!			  */
	gub_Pad:CHAR		/* Private!			  */

	gadtoolsbase:PTR TO lib	/* The following library bases	  */
	gfxbase:PTR TO gfxbase	/* may be read and used by your	  */
				/* program			  */
	intuitionbase:PTR TO intuitionbase
	localebase:PTR TO lib	/* LocaleBase may be NULL!	  */
	utilitybase:PTR TO lib	
	diskfontbase:PTR TO lib	/* DiskFontBase may be NULL!	  */
	gub_segList:LONG	/* Private!			  */
ENDOBJECT

#define GADUTILNAME	'gadutil.library'
CONST	GADUTIL_VER=37
CONST	GADUTIL_REV=10

/*------------------------------------------------------------------------**
**      			BevelBox structure			  **
**------------------------------------------------------------------------*/
OBJECT bboxdata
	bbd_XPos:INT	 		/* X position of box		  */
	bbd_YPos:INT 			/* Y position of box		  */
	bbd_Width:INT			/* Width of box			  */
	bbd_Height:INT			/* Height of box		  */

	bbd_LeftEdge:INT		/* Left edge of text		  */
	bbd_TopEdge:INT			/* Top edge of text		  */
	bbd_TextWidth:INT		/* Pixel width of text		  */

	bbd_TextFont:PTR TO textattr	/* Font to print text with	  */
	bbd_Text			/* Text to display		  */
	bbd_FrontPen:CHAR		/* Text color			  */
	bbd_Flags:CHAR			/* Text placement flags		  */
	bbd_Recessed:CHAR		/* Recessed frame		  */
	bbd_FrameType:CHAR		/* Type of box frame		  */
	bbd_ShadowPen:CHAR 	        /* Shadow color			  */
	bbd_Reserved1:CHAR		/* No use in v36.53 - reserved!	  */
	bbd_HelpGadget:PTR TO gadget	/* Pointer to gadget for help text*/
	bbd_HelpText			/* The help text for this gadget  */
ENDOBJECT

/*------------------------------------------------------------------------**
**      		ProgressIndicator structure			  **
**------------------------------------------------------------------------*/

OBJECT progressgad
	pg_XPos:INT			/* X pos of box around gadget	  */
	pg_YPos:INT			/* Y pos of box around gadget	  */
	pg_Width:INT			/* Width of box around gadget	  */
	pg_Height:INT			/* Height of box around gadget	  */
	pg_Current:LONG			/* Current value of indicator	  */
	pg_Total:LONG			/* Total value of indicator	  */
	pg_FillColor:CHAR		/* Color of upto current value	  */
	pg_BackColor:CHAR		/* Color from current to end	  */
	pg_Flags:CHAR			/* Flags			  */
	pg_reserved1:CHAR
	pg_XFilledTo:INT		/* Initialized to pg_XPos + 4	  */
	pg_HelpGadget:PTR TO gadget	/* Pointer to gadget for help text*/
	pg_HelpText			/* The help text for this gadget  */
ENDOBJECT
