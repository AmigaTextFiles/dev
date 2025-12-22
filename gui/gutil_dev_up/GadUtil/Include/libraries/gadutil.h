#ifndef LIBRARIES_GADUTIL_H
#define LIBRARIES_GADUTIL_H
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
**------------------------------------------------------------------------*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

/*------------------------------------------------------------------------**
**
** Extended gadget types available in GadUtil.library.
**
*/

#define IMAGE_KIND	50
#define LABEL_KIND	51
#define DRAWER_KIND	52
#define FILE_KIND	53
#define BEVELBOX_KIND	54
#define PROGRESS_KIND	55

/*-------------------- Reserved GadgetID's - don't use! ------------------**
**
** GadgetID's are really word sized, but two of these vaules are used by the
** GU_HelpGadget tag, so don't use -1 (65535), -2 (65534) or -3 (65533) as
** GadgetID!
**
*/

#define GADID_RESERVED	0xFFFFFFFF
#define WINTITLE_HELP	0xFFFFFFFE
#define SCRTITLE_HELP	0xFFFFFFFD

/*--------------- Minimum recommended sizes for some gadgets -------------*/
#define FILEKIND_WIDTH  20
#define FILEKIND_HEIGHT 14

#define DRAWERKIND_WIDTH  20
#define DRAWERKIND_HEIGHT 14

/*------------------ Text placement for LABEL_KIND -----------------------**
**
**	___1_____2_____3___
**	|_____|_____|_____| A	Nine different placements of the text is
**	|_____|_____|_____| B	possible if the size of the box allows it.
**	|_____|_____|_____| C	The flags are the same as for BEVELBOX_KIND
*/

#define LB_TEXT_TOP	0	/* Place text on line A of the box   */

#define LB_TEXT_MIDDLE	1	/* Place text on line B of the box   */

#define LB_TEXT_BOTTOM	2	/* Place text on line C of the box   */

#define LB_TEXT_CENTER	0	/* Place text in column 2 of the box */

#define LB_TEXT_LEFT	4	/* Place text in column 1 of the box */

#define LB_TEXT_RIGHT	8	/* Place text in column 3 of the box */

/*----------------- Alternatives for text placement flags ----------------*/
#define LB_TEXT_TOP_CENTER	LB_TEXT_TOP|LB_TEXT_CENTER
#define LB_TEXT_TOP_LEFT	LB_TEXT_TOP|LB_TEXT_LEFT
#define LB_TEXT_TOP_RIGHT	LB_TEXT_TOP|LB_TEXT_RIGHT

#define LB_TEXT_MIDDLE_CENTER	LB_TEXT_MIDDLE|LB_TEXT_CENTER
#define LB_TEXT_MIDDLE_LEFT	LB_TEXT_MIDDLE|LB_TEXT_LEFT
#define LB_TEXT_MIDDLE_RIGHT	LB_TEXT_MIDDLE|LB_TEXT_RIGHT

#define LB_TEXT_BOTTOM_CENTER	LB_TEXT_BOTTOM|LB_TEXT_CENTER
#define LB_TEXT_BOTTOM_LEFT	LB_TEXT_BOTTOM|LB_TEXT_LEFT
#define LB_TEXT_BOTTOM_RIGHT	LB_TEXT_BOTTOM|LB_TEXT_RIGHT

/*---------------------- Text shadow placement flags ---------------------*/
#define LB_SHADOW_DR	0	/* Place the shadow at x+1, y+1   */
#define LB_SHADOW_UR	16	/* Place the shadow at x+1, y-1   */
#define LB_SHADOW_DL	32	/* Place the shadow at x-1, y+1   */
#define LB_SHADOW_UL	48	/* Place the shadow at x-1, y-1   */

/*------------ Alternatives for text shadow placement flags --------------*/
#define LB_SUNAT_UL	0	/* Place the shadow at x+1, y+1   */
#define LB_SUNAT_DL	16	/* Place the shadow at x+1, y-1   */
#define LB_SUNAT_UR	32	/* Place the shadow at x-1, y+1   */
#define LB_SUNAT_DR	48	/* Place the shadow at x-1, y-1   */

#define LB_3DTEXT	64	/* Alternative to GULB_3DText, TRUE   */

/*-------------------------- Bevel box frame types -----------------------*/
#define BFT_BUTTON	0	/* Normal button bevel box border */
#define BFT_RIDGE	1	/* STRING_KIND bevel box border   */
#define BFT_DROPBOX	2	/* Icon dropbox type border	  */

#define BFT_HORIZBAR	10	/* Horizontal shadowed line       */
#define BFT_VERTBAR	11	/* Vertical shadowed line         */

/*------------------ Text placement for BEVELBOX_KIND --------------------*/
#define BB_TEXT_ABOVE	0	/* Place bevel box text above the
				 * upper border   ___ Example ___ */

#define BB_TEXT_IN	1	/* Place bevel box text centered at
				 * the upper border --- Example --- */

#define BB_TEXT_BELOW	2	/* Place bevel box text below the
				 * upper border   ___        ___
				 *                    Example	  */

#define BB_TEXT_CENTER	0	/* Place the text centered at the
				 * upper border (default)         */

#define BB_TEXT_LEFT	4	/* Place the text left adjusted   */

#define BB_TEXT_RIGHT	8	/* Place the text right adjusted  */

/*--------------- Alternatives to text placement flags -------------------*/
#define BB_TEXT_ABOVE_CENTER	BB_TEXT_ABOVE|BB_TEXT_CENTER
#define BB_TEXT_ABOVE_LEFT	BB_TEXT_ABOVE|BB_TEXT_LEFT
#define BB_TEXT_ABOVE_RIGHT	BB_TEXT_ABOVE|BB_TEXT_RIGHT

#define BB_TEXT_IN_CENTER	BB_TEXT_IN|BB_TEXT_CENTER
#define BB_TEXT_IN_LEFT		BB_TEXT_IN|BB_TEXT_LEFT
#define BB_TEXT_IN_RIGHT	BB_TEXT_IN|BB_TEXT_RIGHT

#define BB_TEXT_BELOW_CENTER	BB_TEXT_BELOW|BB_TEXT_CENTER
#define BB_TEXT_BELOW_LEFT	BB_TEXT_BELOW|BB_TEXT_LEFT
#define BB_TEXT_BELOW_RIGHT	BB_TEXT_BELOW|BB_TEXT_RIGHT

/*-----------------------Text Shadow placement ---------------------------*/
#define BB_SHADOW_DR	0	/* Place the shadow at x+1, y+1   */
#define BB_SHADOW_UR	16	/* Place the shadow at x+1, y-1   */
#define BB_SHADOW_DL	32	/* Place the shadow at x-1, y+1   */
#define BB_SHADOW_UL	48	/* Place the shadow at x-1, y-1   */

/*------------------ Alternatives for shadow placement -------------------*/
#define BB_SUNAT_UL	0	/* Place the shadow at x+1, y+1   */
#define BB_SUNAT_DL	16	/* Place the shadow at x+1, y-1   */
#define BB_SUNAT_UR	32	/* Place the shadow at x-1, y+1   */
#define BB_SUNAT_DR	48	/* Place the shadow at x-1, y-1   */

#define BB_3DTEXT	64	/* Alternative to GUBB_3DText, TRUE */

/*------------------------------------------------------------------------**
**
** This is the structure that actually holds the definition of a single
** gadget.  It contains the new layout tags defined below, as well as the
** normal GadTools tags.  You setup all the gadgets in a window by
** making an array of this structure and passing it to GU_LayoutGadgetsA().
**
*/
struct LayoutGadget
{
	WORD	lg_GadgetID;
	struct	TagItem *lg_LayoutTags;
	struct	TagItem *lg_GadToolsTags;
	struct	Gadget *lg_Gadget;
};

/*------------------------------------------------------------------------**
**
** Structure used to hold the built in strings of a localized program. These
** strings will be used if we couldn't get a string from the catalog.
**
*/
struct AppString
{
	ULONG	as_ID;			/* String ID			  */
	STRPTR	as_Str;			/* String pointer		  */
};

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

#define GU_TagBase	TAG_USER + 0x60000

/*********** Define which kind of gadget we are going to have. ************/

#define GU_GadgetKind	GU_TagBase+1	/* Which kind of gadget to make.  */


/************************ Gadget width control. ***************************/

#define GU_Width	GU_TagBase+20	/* Absolute gadget width.	  */

#define GU_DupeWidth	GU_TagBase+21	/* Duplicate the width of another
					 * gadget.			  */

#define GU_AutoWidth	GU_TagBase+22	/* Set width according to length
					 * of text label + ti_Data.       */

#define GU_Columns	GU_TagBase+23	/* Set width so that approximately
					 * ti_Data columns will fit.	  */

#define GU_AddWidth	GU_TagBase+24	/* Add some value to the total
					 * width calculation.		  */

#define GU_MinWidth	GU_TagBase+25	/* Make sure width is at least this */

#define GU_MaxWidth	GU_TagBase+26	/* Make sure width is at most this */

#define GU_AddWidChar	GU_TagBase+27	/* Add the width of ti_Data chars
					 *  to the gadget width		  */

#define GU_FractWidth	GU_TagBase+28	/* Divide / multiply gadget width
					 *  with ti_Data		  */

/************************* Gadget height control. *************************/

#define GU_Height	GU_TagBase+40	/* Absolute gadget height. 	  */

#define GU_DupeHeight	GU_TagBase+41	/* Duplicate the height of another
					 * gadget.			  */

#define GU_AutoHeight	GU_TagBase+42	/* Set height according to height
					 * of text font + ti_Data.	  */

#define GU_HeightFactor	GU_TagBase+43	/* Make the gadget height a
					 * multiple of the font height.	  */

#define GU_AddHeight	GU_TagBase+44	/* Add some value to the total
					 * height calculation.		  */

#define GU_MinHeight	GU_TagBase+45	/* Make sure height is at least this */

#define GU_MaxHeight	GU_TagBase+46	/* Make sure height is at most this */

#define GU_AddHeiLines	GU_TagBase+47	/* Add the height of ti_Data lines
					 *  to the gadget height	  */

#define GU_FractHeight	GU_TagBase+48	/* Divide / multiply gadget height
					 *  with ti_Data		  */

/************************* Gadget top edge control. ***********************/

#define GU_Top		GU_TagBase+60	/* Absolute top edge.		  */

#define GU_TopRel	GU_TagBase+61	/* Top edge relative to bottom
					 * edge of another gadget.	  */

#define GU_AddTop	GU_TagBase+62	/* Add some value to the final
					 * top edge calculation.	  */

#define GU_AlignTop	GU_TagBase+63	/* Align top edge of gadget with
					 * top edge of another gadget.	  */

#define GU_AdjustTop	GU_TagBase+64	/* Add the height of the text font
					 * + ti_Data to the top edge.	  */

#define GU_AddTopLines	GU_TagBase+65	/* Add the height of ti_Data lines
					 * to the top edge.		  */

/*********************** Gadget bottom edge control. **********************/

#define GU_Bottom	GU_TagBase+80	/* Absolute bottom edge.	  */

#define GU_BottomRel	GU_TagBase+81	/* Bottom edge relative to top
					 * edge of another gadget.	  */

#define GU_AddBottom	GU_TagBase+82	/* Add some value to the final
					 * bottom edge calculation.	  */

#define GU_AlignBottom	GU_TagBase+83	/* Align bottom edge of gadget with
					 * bottom edge of another gadget. */

#define GU_AdjustBottom	GU_TagBase+84	/* Subtract the height of the text
					 * font + ti_Data from the top edge */

/********************** Gadget left edge control. *************************/

#define GU_Left		GU_TagBase+100	/* Absolute left edge.		  */

#define GU_LeftRel	GU_TagBase+101	/* Left edge relative to right
					 * edge of another gadget.	  */

#define GU_AddLeft	GU_TagBase+102	/* Add some value to the final
					 * left edge calculation.	  */

#define GU_AlignLeft	GU_TagBase+103	/* Align left edge of gadget with
					 * left edge of another gadget.	  */

#define GU_AdjustLeft	GU_TagBase+104	/* Add the width of the text label
					 * + ti_Data to the left edge.	  */

#define GU_AddLeftChar	GU_TagBase+105	/* Add length of ti_Data characters
					 * to the left edge.		  */

/********************** Gadget right edge control. ************************/

#define GU_Right	GU_TagBase+120	/* Absolute right edge.		  */

#define GU_RightRel	GU_TagBase+121	/* Right edge relative to left
					 * edge of another gadget.	  */

#define GU_AddRight	GU_TagBase+122	/* Add some value to the final
					 * right edge calculation.	  */

#define GU_AlignRight	GU_TagBase+123	/* Align right edge of gadget with
					 * right edge of another gadget.  */

#define GU_AdjustRight	GU_TagBase+124	/* Subtract the width of the text
					 * label + ti_Data from the left edge */

/******************************* Other tags *******************************/

#define GU_ToggleSelect	GU_TagBase+150	/* Create a toggle-select gadget -
					 * only BUTTON_KIND & IMAGE_KIND  */

#define GU_Selected	GU_TagBase+151	/* Set default state of toggle-
					 * select gadget		  */

#define GU_HelpGadget	GU_TagBase+152	/* Gadget ID of a TEXT_KIND gadget that
					 * will show a short help text */

#define GU_HelpText	GU_TagBase+153	/* Pointer to the text to be shown in
					 * the help gadget		  */

#define GU_LocaleHelp	GU_TagBase+154	/* Localized version of GU_HelpText
					 * ti_Data of this tag is the string ID */

/********* Access to the other fields of the NewGadget structure **********/

#define GU_GadgetText	GU_TagBase+160	/* Gadget label.		  */

#define GU_TextAttr	GU_TagBase+161	/* Desired font for gadget label. */

#define GU_Flags	GU_TagBase+162	/* Gadget flags.		  */

#define GU_UserData	GU_TagBase+163	/* Gadget UserData.		  */

#define GU_LocaleText	GU_TagBase+164	/* Gadget label taken from a locale. */

/*************** Tags to store some of the calculated values **************/

#define GU_StoreLeft	GU_TagBase+170	/* Store the gadget's left position */
#define GU_StoreTop	GU_TagBase+171	/* Store the gadget's top position */
#define GU_StoreWidth	GU_TagBase+172	/* Store the gadget's width	  */
#define GU_StoreHeight	GU_TagBase+173	/* Store the gadget's height	  */
#define GU_StoreRight	GU_TagBase+174	/* Store the gadget's right position */
#define GU_StoreBottom	GU_TagBase+175	/* Store the gadget's bottom position */

/*************** Tags for GadUtil's extended gadget kinds. *****************/

/*---------------------------- IMAGE_KIND tags ---------------------------*/
#define GUIM_Image	GU_TagBase+200	/* Image structure for an image
					 * gadget.			  */

#define GUIM_ReadOnly	GU_TagBase+201	/* TRUE if read-only.		  */

#define GUIM_SelectImg	GU_TagBase+202	/* Selected image for IMAGE_KIND
					 * gadgets			  */

#define GUIM_BOOPSILook	GU_TagBase+203	/* Render selected image background
					 * with the fillpen (default = TRUE) */
					 
/*------------------------- BEVELBOX_KIND tags ---------------------------*/
#define GUBB_Recessed	GU_TagBase+220	/* TRUE for a recessed bevel box  */

#define GUBB_FrameType	GU_TagBase+221	/* Frame type for bevel box	  */

#define GUBB_TextColor	GU_TagBase+222	/* Color of the title text	  */

#define GUBB_TextPen	GU_TagBase+223	/* Pen to print title text with -
					 *  overrides GUBB_TextColor	  */

#define GUBB_Flags	GU_TagBase+224	/* Text placement flags		  */

#define GUBB_3DText	GU_TagBase+225	/* Tag to enable 3D text (shadow)
					 *  Not needed if GUBB_ShadowColor
					 *  or GUBB_ShadowPen is used	  */

#define GUBB_ShadowColor GU_TagBase+226 /* Color of the title text's shadow */

#define GUBB_ShadowPen	GU_TagBase+227	/* Pen to print the text's shadow
					 *  with - overrides GUBB_ShadowColor */

/*-------------------------- LABEL_KIND tags -----------------------------*/
#define GULB_TextColor	GU_TagBase+222	/* Color of the text		  */

#define GULB_TextPen	GU_TagBase+223	/* Pen to print text with -
					 *  overrides GULB_TextColor	  */

#define GULB_Flags	GU_TagBase+224	/* Text placement flags		  */

#define GULB_3DText	GU_TagBase+225	/* Tag to enable 3D text (shadow)
					 *  Not needed if GULB_ShadowColor
					 *  or GULB_ShadowPen is used	  */

#define GULB_ShadowColor GU_TagBase+226	/* Color of the text's shadow	  */

#define GULB_ShadowPen	GU_TagBase+227	/* Pen to print the text's shadow
					 *  with - overrides GULB_ShadowColor */

/*------------------------- PROGRESS_KIND tags ---------------------------*/
#define GUPR_FillColor	GU_TagBase+240	/* Color of filled part of indicator */

#define GUPR_FillPen	GU_TagBase+241	/* Pen to fill the indicator with
					 *  - overrides GUPR_FillColor	  */

#define GUPR_BackColor	GU_TagBase+242	/* Color of the background of the
					 *  indicator			  */

#define GUPR_BackPen	GU_TagBase+243	/* Pen to use for the indocator's
					 *  background - overrides
					 *  GUPR_BackColor		  */

#define GUPR_Current	GU_TagBase+244	/* Current value of the indicator */

#define GUPR_Total	GU_TagBase+245	/* Total value for the indicator  */

/************** Tags passed directly to GU_LayoutGadgetsA(). **************/

#define GU_RightExtreme	GU_TagBase+500	/* ti_Data is a pointer to a LONG
					 * that is used to store the right-
					 * most point that a gadget
					 * will exist in.		  */

#define GU_LowerExtreme	GU_TagBase+501	/* ti_Data is a pointer to a LONG
					 * that is used to store the lower-
					 * most point that a gadget will
					 * exist in.			  */

#define GU_Catalog	GU_TagBase+502	/* Indicates locale for the gadgets. */


#define GU_DefTextAttr	GU_TagBase+503	/* Specifies a default font for use
					 * with all gadgets, can still be
					 * over-ridden with GU_TextAttr.  */

#define GU_AppStrings	GU_TagBase+504	/* Application string table w/IDs. */

#define GU_BorderLeft	GU_TagBase+505	/* Size of window left border.	  */

#define GU_BorderTop	GU_TagBase+506	/* Size of window top border.	  */

#define GU_NoCreate     GU_TagBase+507	/* Don't actually create the gadgets. */

#define GU_MinimumIDCMP GU_TagBase+508	/* Minimum required IDCMP, so that
					 *  all gadgets will work	  */

#define GU_DefWTitle	GU_TagBase+509	/* Text to show in window title when
					 *  pointer is outside a gadget with
					 *  help text			  */

#define GU_DefLocWTitle	GU_TagBase+510	/* Localized default window title */

#define GU_DefSTitle	GU_TagBase+511	/* Text to show in screen title when
					 *  pointer is outside a gadget with
					 *  help text			  */

#define GU_DefLocSTitle	GU_TagBase+512	/* Localized default screen title */

#define GU_DefHelpText	GU_TagBase+513	/* Text to show in any gadget used to
					 *  display help text when pointer is
					 *  outside a gadget with help text */

#define GU_DefLocHelpText GU_TagBase+514 /* Localized default help text	  */

/***************************** Hotkey tags ********************************/

#define GU_Hotkey	GU_TagBase+300	/* Hotkey for gadget (VANILLAKEY) */

/********************* Boolean flags for hotkey code **********************/

#define GU_HotkeyCase	GU_TagBase+301	/* TRUE for a case-sensitive hotkey */
#define GU_LabelHotkey	GU_TagBase+302	/* TRUE = get hotkey code from label */
#define GU_RawKey	GU_TagBase+303	/* TRUE if hotkey is a RAWKEY code */

/*********************** Constants for hotkey support *********************/

#define GADUSERMAGIC	0x1122		/* Identification for structure that
					 * the gadgets UserData points to */

/******************* Public bit numbers for gu_Flags **********************/

#define GU_HOTKEYCASE	0		/* Hoykey is case-sensitive	  */
#define GU_RAWKEY	2		/* gu_Code is a RAWKEY code	  */

#define GU_HOTKEYCASEMASK 1<<GU_HOTKEYCASE /* Mask for GU_HOTKEYCASE bit  */
#define GU_RAWKEYMASK	  1<<GU_RAWKEY	   /* Mask for GU_RAWKEY bit	  */

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

struct GU_Public
{
	UWORD	gu_Magic;	/* Identification word for structure	  */
	ULONG	gu_GadFlags;	/* Flags for GENERIC kind GadUtil gadgets */
	UBYTE	gu_Flags;	/* Flags for the hotkey type		  */
	UBYTE	gu_Code;	/* VANILLA or RAWKEY code to react on	  */
	WORD	gu_Active;	/* Active entry for some gadget kinds	  */
	WORD	gu_MaxVal;	/* Maximum value for some gadgets	  */
	WORD	gu_MinVal;	/* Minimum value for some gadgets	  */
	ULONG	gu_GadgetType;	/* Gadget type that was created		  */
	struct	Gadget *gu_HelpGadget;	/* Pointer to gadget for help text*/
	STRPTR	gu_HelpText;	/* The help text for this gadget	  */
};

/*------------------------------------------------------------------------**
**      			Library base				  **
**------------------------------------------------------------------------*/

struct GadUtilBase
{
        struct	Library LibNode;
        UBYTE   gub_Flags;		/* Private!			  */
	UBYTE	gub_Pad;		/* Private!			  */

	struct	Library *GadToolsBase;	/* The following library bases	  */
	struct	GfxBase	*GfxBase;	/* may be read and used by your	  */
	struct	IntuitionBase *IntuitionBase;	/* program		  */
	struct	Library *LocaleBase;	/* LocaleBase may be NULL!	  */
	struct	Library *UtilityBase;
	struct	Library *DiskFontBase;	/* DiskFontBase may be NULL!	  */
	LONG	gub_SegList;		/* Private!			  */
};

#define GADUTILNAME     "gadutil.library"
#define GADUTIL_VER	37
#define	GADUTIL_REV	10

/*------------------------------------------------------------------------**
**      			BevelBox structure			  **
**------------------------------------------------------------------------*/
struct BBoxData
{
	UWORD	bbd_XPos; 		/* X position of box		  */
	UWORD	bbd_YPos; 		/* Y position of box		  */
	UWORD	bbd_Width;		/* Width of box			  */
	UWORD	bbd_Height;		/* Height of box		  */

	UWORD	bbd_LeftEdge;		/* Left edge of text		  */
	UWORD	bbd_TopEdge;		/* Top edge of text		  */
	UWORD	bbd_TextWidth;		/* Pixel width of text		  */

	struct	TextAttr *bbd_TextFont; /* Font to print text with	  */
	STRPTR	bbd_Text;		/* Text to display		  */
		
	UBYTE	bbd_FrontPen;		/* Text color			  */
	UBYTE	bbd_Flags;		/* Text placement flags		  */
	UBYTE	bbd_Recessed;		/* Recessed frame		  */
	UBYTE	bbd_FrameType;		/* Type of box frame		  */
	UBYTE	bbd_ShadowPen; 	        /* Shadow color			  */
	UBYTE	bbd_Reserved1;		/* No use in v36.53 - reserved!	  */
	struct	Gadget *bbd_HelpGadget;	/* Pointer to gadget for help text*/
	STRPTR	bbd_HelpText;		/* The help text for this gadget  */
};

/*------------------------------------------------------------------------**
**      		ProgressIndicator structure			  **
**------------------------------------------------------------------------*/

struct ProgressGad
{
	UWORD	pg_XPos;		/* X pos of box around gadget	  */
	UWORD	pg_YPos;		/* Y pos of box around gadget	  */
	UWORD	pg_Width;		/* Width of box around gadget	  */
	UWORD	pg_Height;		/* Height of box around gadget	  */
	ULONG	pg_Current;		/* Current value of indicator	  */
	ULONG	pg_Total;		/* Total value of indicator	  */
	UBYTE	pg_FillColor;		/* Color of upto current value	  */
	UBYTE	pg_BackColor;		/* Color from current to end	  */
	UBYTE	pg_Flags;		/* Flags			  */
	UBYTE	pg_reserved1;
	UWORD	pg_XFilledTo;		/* Initialized to pg_XPos + 4	  */
	struct	Gadget *pg_HelpGadget;	/* Pointer to gadget for help text*/
	STRPTR	pg_HelpText;		/* The help text for this gadget  */
};

#endif /* LIBRARIES_GADUTIL_H */
