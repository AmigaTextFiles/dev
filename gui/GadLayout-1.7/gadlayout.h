#ifndef GADLAYOUT_GADLAYOUT_H
#define GADLAYOUT_GADLAYOUT_H
/*
**	$Filename: gadlayout/gadlayout.h $
**	$Release: 1.6 $
**	$Revision: 36.9 $
**	$Date: 93/05/06 $
**
**	GadLayout definitions, a dynamic gadget layout system.
**
**	(C) Copyright 1992, 1993 by Timothy J. Aston
**	All Rights Reserved
*/

/*------------------------------------------------------------------------*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

/*------------------------------------------------------------------------*/

/* Extended gadget types available in GadLayout.
 */
#define IMAGEBUTTON_KIND 50
#define BORDERBUTTON_KIND 51				/* Not implemented */
#define DRAWER_KIND 52
#define FILE_KIND 53

#define IMAGE_KIND IMAGEBUTTON_KIND			/* Obsolete! */
#define BORDER_KIND BORDERBUTTON_KIND		/* Obsolete! */

/*------------------------------------------------------------------------*/

/* This is the structure that actually holds the definition of a single
 * gadget.  It contains the new layout tags defined below, as well as the
 * normal GadTools tags.  You setup all the gadgets in a window by
 * making an array of this structure and passing it to LayoutGadgets().
 */
struct LayoutGadget
{
	WORD lg_GadgetID;
	struct TagItem *lg_LayoutTags;
	struct TagItem *lg_GadToolsTags;
	struct Gadget *lg_Gadget;
};

/*------------------------------------------------------------------------*/

/* GadLayout is basically an extension to the GadTools gadget toolbox.
 * It adds to GadTools the ability to dynamically layout gadgets according
 * to the positions of other gadgets, font size, locale, etc.  The goal in
 * designing this was to create a system so that programmers could easily
 * create a GUI that automatically adjusted to a user's environment.
 *
 * Every gadget is now defined as a TagList, there is no more need to
 * make use of the NewGadget structure as this taglist allows you to
 * access all fields used in that structure.  An array of the TagLists for
 * all your window's gadgets is then passed to LayoutGadgets() and your
 * gadget list is created.
 */

#define GL_TagBase	     TAG_USER + 0x50000

/* Define which kind of gadget we are going to have.
 */
#define GL_GadgetKind	GL_TagBase+1	/* Which kind of gadget to make. */

/* Gadget width control.
 */
#define GL_Width		GL_TagBase+3	/* Absolute gadget width. */
#define GL_DupeWidth	GL_TagBase+4	/* Duplicate the width of another
										 * gadget.
										 */
#define GL_AutoWidth	GL_TagBase+5	/* Set width according to length of
										 * text label + ti_Data.
										 */
#define GL_Columns		GL_TagBase+38	/* Set width so that approximately
										 * ti_Data columns will fit.
										 */
#define GL_AddWidth		GL_TagBase+6	/* Add some value to the total width
										 * calculation.
										 */
#define GL_MinWidth		GL_TagBase+34	/* Make sure width is at least this */
#define GL_MaxWidth		GL_TagBase+35	/* Make sure width is at most this */

/* Gadget height control.
 */
#define GL_Height		GL_TagBase+7	/* Absolute gadget height. */
#define GL_DupeHeight	GL_TagBase+39	/* Duplicate the height of another
										 * gadget.
										 */
#define GL_HeightFactor	GL_TagBase+33	/* Make the gadget height a multiple
										 * of the font height.
										 */
#define GL_AutoHeight	GL_TagBase+8	/* Set height according to height of
										 * text font + ti_Data.
										 */
#define GL_AddHeight	GL_TagBase+9	/* Add some value to the total height
										 * calculation.
										 */
#define GL_MinHeight	GL_TagBase+36	/* Make sure height is at least this */
#define GL_MaxHeight	GL_TagBase+37	/* Make sure height is at most this */

/* Gadget top edge control.
 */
#define GL_Top			GL_TagBase+10	/* Absolute top edge. */
#define GL_TopRel		GL_TagBase+11	/* Top edge relative to bottom edge of
										 * another gadget.
										 */
#define GL_AdjustTop	GL_TagBase+12	/* ADD the height of the text font +
										 * ti_Data to the top edge.
										 */
#define GL_AlignTop		GL_TagBase+41	/* Align the top edge of the gadget
										 * with the top edge of another.
										 */
#define GL_AddTop		GL_TagBase+13	/* Add some value to the final top edge
										 * calculation.
										 */
/* Gadget bottom edge control.
 */
#define GL_Bottom		GL_TagBase+14	/* Absolute bottom edge. */
#define GL_BottomRel	GL_TagBase+15	/* Bottom edge relative to top edge of
										 * another gadget.
										 */
#define GL_AlignBottom	GL_TagBase+40	/* Align the bottom edge of the gadget
										 * with the bottom edge of another.
										 */
#define GL_AddBottom	GL_TagBase+16	/* Add some value to the final bottom
										 * edge calculation.
										 */
/* Gadget left edge control.
 */
#define GL_Left			GL_TagBase+17	/* Absolute left edge. */
#define GL_LeftRel		GL_TagBase+18	/* Left edge relative to right edge of
										 * another gadget.
										 */
#define GL_AdjustLeft	GL_TagBase+19	/* ADD the width of the text label +
										 * ti_Data to the left edge.
										 */
#define GL_AddLeft		GL_TagBase+20	/* Add some value to the final left
										 * edge calculation.
										 */
#define GL_AlignLeft	GL_TagBase+32	/* Align the left edge of the gadget
										 * with the left edge of another.
										 */
/* Gadget right edge control.
 */
#define GL_Right		GL_TagBase+21	/* Absolute right edge. */
#define GL_RightRel		GL_TagBase+22	/* Right edge relative to left edge of
										 * another gadget.
										 */
#define GL_AddRight		GL_TagBase+23	/* Add some value to the final right
										 * edge calculation.
										 */
#define GL_AlignRight	GL_TagBase+31	/* Align the right edge of the gadget
										 * with the right edge of another.
										 */

/* Access to the other fields of the NewGadget structure.
 */
#define GL_GadgetText	GL_TagBase+24	/* Gadget label. */
#define GL_TextAttr		GL_TagBase+25	/* Desired font for gadget label. */
#define GL_Flags		GL_TagBase+27	/* Gadget flags. */
#define GL_UserData		GL_TagBase+29	/* Gadget UserData. */
#define GL_LocaleText	GL_TagBase+30	/* Gadget label taken from a locale. */

/* Tags for GadLayout's extended gadget kinds.
 */
#define GLIM_Image		GL_TagBase+200	/* Image structure for an image
										 * gadget.
										 */
#define GLIM_ReadOnly	GL_TagBase+201	/* TRUE if read-only. */
#define GLIM_Toggle		GL_TagBase+202	/* TRUE if a toggle gadget. */
#define GLBD_Border		GL_TagBase+200	/* Border structure for an border
										 * gadget.
										 */
#define GLBD_ReadOnly	GL_TagBase+201	/* TRUE if read-only. */


/* Tags passed directly to LayoutGadgets.
 */
#define GL_RightExtreme	GL_TagBase+100	/* ti_Data is a pointer to a LONG to
										 * store the right-most point that a
										 * gadget will exist in.
										 */
#define GL_LowerExtreme	GL_TagBase+101	/* ti_Data is a pointer to a LONG to
										 * store the lower-most point that a
										 * a gadget will exist in.
										 */
#define GL_Catalog		GL_TagBase+102	/* Indicates locale for the gadgets. */
#define GL_AppStrings	GL_TagBase+104	/* Application string table w/IDs. */
#define GL_DefTextAttr	GL_TagBase+103	/* Specifies a default font for use
										 * with all gadgets, can still be
										 * over-ridden with GL_TextAttr.
										 */
#define GL_BorderLeft	GL_TagBase+105	/* Size of window left border. */
#define GL_BorderTop	GL_TagBase+106	/* Size of window top border. */
#define GL_NoCreate     GL_TagBase+107	/* Don't actually create the gadgets. */

#endif /* GADLAYOUT_GADLAYOUT_H */

