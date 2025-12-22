/*
**	$Filename: gadlayout/gadlayout.c $
**	$Release: 1.7 $
**	$Revision: 36.26 $
**	$Date: 93/11/30 $
**
**	GadLayout functions, a dynamic gadget layout system.
**
**	(C) Copyright 1992, 1993, Timothy J. Aston
**	All Rights Reserved
**
**  GadLayout is copyright, so you can't go ahead and just use it however you
**  want, there are some restrictions.  GadLayout consists of the C source
**  files, all header files, and all documentation included.  You may not
**  modify GadLayout in any way.  GadLayout exists for you, the software
**  developer, to use it; however, certain conditions must be complied with
**  before you do:
**
**  1. Your documentation must clearly state that it is making use of the
**     GadLayout dynamic gadget layout system by Timothy Aston.
**  2. You must provide me with, free of charge, a copy of the software you use
**     GadLayout in, and any subsequent updates to it that use GadLayout, also
**     free of charge.  This means that if the software you use it in is
**     shareware, I must be considered a full-registered user of the software.
**     Similarly for commercial software, you must provide me with a
**     complimentary copy.  And in all cases, as long as your software continues
**     to use GadLayout, you must provide with all publically released updates.
**     See the end of this document to find out how to get the stuff to me. 
**     I hope this isn't being too unreasonable, I basically just want to see
**     all the software that uses GadLayout.
**  3. If you modify the GadLayout source at all, you must send your
**     modifications to me.  You may not under any circumstances use the
**     GadLayout sources to create any kind of runtime-linking module, such
**     as a standard Amiga shared-library.
**  4. You may not distribute modified GadLayout source, or include GadLayout
**     source in a distribution without permission from the author.
**  5. Any modified versions of GadLayout will fall under this same licensing
**     agreement.
**
**
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <utility/tagitem.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <graphics/clip.h>
#include <graphics/layers.h>
#include <libraries/gadtools.h>
#include <libraries/locale.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/layers_protos.h>
#include <clib/locale_protos.h>
#include <clib/utility_protos.h>
#include <string.h>
#include "gadlayout.h"


/* #define GL_DEBUG 1 */

#define MAX(a, b)	(a > b) ? a : b
#define MIN(a, b)	(a < b) ? a : b

#define GADLAYOUT_KIND 0xF001
#define GLFLG_READONLY 0x002
#define GLFLG_TOGGLE 0x004

/* Local structure used to hold the definitions for the gadgets once they
 * have been laid out.
 */
struct LaidOutGadget
{
	BOOL log_IsEvaluated;
	ULONG log_GadgetKind;
	struct NewGadget log_NewGadget;
};

/* Structure used to hold the application strings, used incase we couldn't
 * get a string from the locale catalog.
 */
struct AppString
{
    LONG as_ID;
    STRPTR as_Str;
};

/* Private Local structure used to hold all gadget information that needs to
 * be freed.
 */
struct PrivateInfo
{
	struct Screen *pi_Screen;
	APTR pi_VisualInfo;
	struct DrawInfo *pi_DrawInfo;
	struct Gadget *pi_GadList;
	struct Catalog *pi_Catalog;
	struct AppString *pi_AppStrings;
	struct Remember *pi_Remember;
};

/* Local function prototypes.
 */
VOID evaluate_gadget(struct PrivateInfo *, WORD, struct LayoutGadget *, struct NewGadget *, struct LaidOutGadget *);
LONG text_width(char *, struct TextAttr *);
STRPTR get_locale_string(struct Catalog *, struct AppString *, LONG);
struct Gadget * create_layout_gad(struct PrivateInfo *, WORD, struct Gadget *, struct NewGadget *, struct TagItem *);
struct Image * create_gad_images(WORD, UWORD, UWORD, struct PrivateInfo *, struct Image *, BOOL);

/* Public function prototypes.  These function definitions may differ slightly
 * from what appears in gadlayout_protos.h (the public definitions) since we
 * must hide private structures by using APTRs.
 */
struct PrivateInfo * LayoutGadgets(struct Gadget **, struct LayoutGadget *, struct Screen *, Tag *, ...);
struct PrivateInfo * LayoutGadgetsA(struct Gadget **gad_list, struct LayoutGadget *g, struct Screen *, struct TagItem *);
VOID GL_SetGadgetAttrs(struct PrivateInfo *, struct Gadget *, struct Window *, struct Requester *, Tag *, ...);
VOID GL_SetGadgetAttrsA(struct PrivateInfo *, struct Gadget *, struct Window *, struct Requester *, struct TagItem *taglist);
WORD GadgetArrayIndex(WORD, struct LayoutGadget *);
struct Gadget * GetGadgetInfo(WORD, struct LayoutGadget *);
UBYTE GadgetKeyCmd(struct PrivateInfo *, WORD, struct LayoutGadget *);
VOID FreeLayoutGadgets(struct PrivateInfo *);

extern struct Library *LocaleBase;

/* Data for the drawer image.
 */
__chip static UWORD drawer_data[10] =
{
	0x03C0,
	0x0420,
	0xF810,
	0xFC10,
	0xC3F0,
	0xC010,
	0xC010,
	0xC010,
	0xC010,
	0xFFF0
};

/* Data for the file image.
 */
__chip static UWORD file_data[10] =
{
	0xFF00,
	0xC180,
	0xC140,
	0xC120,
	0xC1F0,
	0xC030,
	0xC030,
	0xC030,
	0xC030,
	0xFFF0
};

struct Image file_image =
{
	0, 0,
	12, 10,
	2,
	file_data,
	0x01, 0x00,
	NULL,
};

/* Data for the drawer image.
 */
struct Image drawer_image =
{
	0, 0,
	12, 10,
	2,
	drawer_data,
	0x01, 0x00,
	NULL,
};


/****** gadlayout/LayoutGadgetsA ********************************************
*
*   NAME
*       LayoutGadgetsA -- Formats an array of GadTools gadgets.
*       LayoutGadgets -- Varargs stub for LayoutGadgetsA().
*
*   SYNOPSIS
*       gad_info = LayoutGadgetsA(gad_list, gadgets, screen, taglist)
*       APTR LayoutGadgetsA(struct Gadget **, struct LayoutGadget *,
*                           struct Screen *, struct TagItem *)
*
*       gad_info = LayoutGadgets(gad_list, gadgets, screen, firsttag, ...)
*       APTR LayoutGadgets(struct Gadget **, struct LayoutGadget *,
*                          struct Screen *, Tag *, ...)
*
*   FUNCTION
*       Creates a laid-out gadget list from a LayoutGadget array, which
*       describes each gadget you want to create.  Gadgets you create
*       can be any of the gadget kinds supported by GadTools, as well
*       as any of the extended gadget kinds provided by GadLayout.
*       Gadgets can easily be defined so that the automatically adjust
*       their sizes and positions to accomodate fonts of any size
*       (including proportional fonts) and also to adapt to different
*       locale strings.  The real power of GadLayout is that allows you
*       to create a gadget layout that dynamically adjusts to different
*       user's environments.
*
*   INPUTS
*       gad_list - Pointer to the gadget list pointer, this will be
*           ready to pass to OpenWindowTags() or AddGList().
*
*       gadgets - An array of LayoutGadget structures.  Each element
*           in the array describes one of the gadgets that you will
*           be creating.  Each LayoutGadget structure in the array
*           should be initialized as follows:
*
*           lg_GadgetID - The ID for this gadget.
*           lg_LayoutTags - A taglist consisting of the following tags:
*               GL_GadgetKind (ULONG) - Which gadget kind to use.  This
*                   may be any of the GadTools gadget kinds (defined in
*                   libraries/gadtools.h), or one of the additional kinds
*                   provided by GadLayout, which are:
*                   IMAGEBUTTON_KIND : A button gadget with that uses an
*                                      Intuition Image structure for its
*                                      contents.  The image will be centred
*                                      automatically.
*                   DRAWER_KIND : A drawer button gadget.  Use this to
*                                 allow the user to use the ASL file
*                                 requester to select a path.
*                   FILE_KIND : A file button gadget.  Use this to allow
*                               the user to use the ASL file requester
*                               to select a file.
*                   Additional kinds may be added in the future.
*               GL_Width (WORD) - Absolute gadget width, in pixels.
*               GL_DupeWidth (UWORD) - Duplicate the width of another
*                   gadget.
*               GL_AutoWidth (WORD) - Set width according to length of
*                   text label + ti_Data.  Note that this function
*                   does not take into account the amount of space any
*                   gadget imagery might take within the gadgets area.
*               GL_Columns (UWORD) - Set width of gadget so that
*                   approximately ti_Data columns of text with the
*                   gadget's font will fit.  This will only be an
*                   approximation, because with proportional fonts the
*                   width of character varies.  Note that this function
*                   does not take into account the amount of space any
*                   gadget imagery might take within the gadgets area.
*               GL_AddWidth (WORD) - Add some value to the total width
*                   calculation.
*               GL_MinWidth (WORD) - Make sure that the final width of
*                   the gadget is at least this.
*               GL_MaxWidth (WORD) - Make sure that the final width of
*                   the gadget is at most this.
*               GL_Height (WORD) - Absolute gadget width.
*               GL_DupeHeight (UWORD) - Duplicate the height of another
*                   gadget.
*               GL_HeightFactor (UWORD) - Make the gadget height a multiple
*                   of the font height (useful for LISTVIEW_KIND gadgets).
*               GL_AutoHeight (WORD) - Set height according to height of
*                   text font + ti_Data.
*               GL_AddHeight (WORD) - Add some value to the total height
*                   calculation.
*               GL_MinHeight (WORD) - Make sure that the final height of
*                   the gadget is at least this.
*               GL_MaxHeight (WORD) - Make sure that the final height of
*                   the gadget is at most this.
*               GL_Top (WORD) - Absolute top edge.
*               GL_TopRel (UWORD)  - Top edge relative to bottom edge of
*                   another gadget (specified by its gadget ID).
*               GL_AdjustTop (WORD) - ADD the height of the text font +
*                   ti_Data to the top edge (often used to to properrly
*                   position gadgets that have their label above).
*               GL_AlignTop (UWORD) - Align the top edge of the gadget
*                   with the top edge of another gadget (specified by its
*                   gadget ID).
*               GL_AddTop (WORD) -  Add some value to the final top edge
*                   calculation.
*               GL_Bottom (WORD) - Absolute bottom edge.
*               GL_BottomRel (UWORD) - Bottom edge relative to top edge of
*                   another gadget (specified by its gadget ID).
*               GL_AlignBottom (UWORD) - Align the bottom edge of the gadget
*                   with the bottom edge of another gadget (specified by its
*                   gadget ID).
*               GL_AddBottom (WORD) - Add some value to the final bottom edge
*                   calculation.
*               GL_Left (WORD) - Absolute left edge.
*               GL_LeftRel (UWORD) - Left edge relative to right edge of
*                   another gadget (specified by its gadget ID).
*               GL_AdjustLeft (WORD) - ADD the width of the text label +
*                   ti_Data to the left edge.
*               GL_AlignLeft (UWORD) - Align the left edge of the gadget
*                   with the left edge of another gadget (specified by its
*                   gadget ID).
*               GL_AddLeft (WORD) - Add some value to the final left edge
*                   calculation.
*               GL_Right (WORD) - Absolute right edge.
*               GL_RightRel (UWORD) - Right edge relative to left edge of
*                   another gadget (specified by its gadget ID).
*               GL_AlignRight (UWORD) - Align the right edge of the gadget
*                   with the right edge of another gadget (specified by its
*                   gadget ID).
*               GL_AddRight (WORD) - Add some value to the final right edge
*                   calculation.
*               GL_GadgetText (STRPTR) - Gadget text label.
*               GL_TextAttr (struct TextAttr *) - Desired font for gadget
*                   label, will override the GL_DefTextAttr if used.
*               GL_Flags - (ULONG) Gadget flags.
*               GL_UserData (VOID *)- Gadget UserData.
*               GL_LocaleText - Gadget label taken from a locale catalog,
*                   you supply the locale string ID.  If you use this tag
*                   you MUST have used GL_AppStrings in your call to
*                   LayoutGadgets().
*
*               If you've specified one of GadLayout's own gadget kinds
*               with GL_GadgetKind, the following tags are available for
*               defining attributes of those gadgets:
*
*               GLIM_Image (struct Image *) - Provide a pointer to the
*                   Image structure to to be used in an IMAGEBUTTON_KIND
*                   structure.  This pointer only need be valid when
*                   LayoutGadgets() is called.
*               GLIM_ReadOnly (BOOL) - Specifies that the gadget is read-
*                   only.  It will get a recessed border and will not be
*                   highlighted when clicked on.
*               GLIM_Toggle (BOOL) - If true, the gadget becomes a toggle
*                   switch gadget that can be clicked on and off.  The
*                   initial state of the gadget will be unselected.
*
*               Generally you need only specify the tags when the data
*               has changed from the previously gadget.  This gets a
*               little tricky when you use the relation tags like
*               GL_TopRel, as this means that gadgets will not be
*               processed in sequential order necessarily.
*
*           lg_GadToolsTags - When defining a GadTools gadgets, you
*               can pass a GadTools taglist to set options for that
*               gadget.  This would be the same set of tags that you
*               might pass to CreateGadgetA() if you were using GadTools
*               directly.
*           lg_Gadget - The pointer to the Gadget structure created for
*               this gadget will be placed here.  You should initialize
*               this field to NULL.  WARNING: The gadget structure
*               created READ-ONLY!
*
*       screen - A pointer to the screen that the gadgets will be
*           created for.  The is required so that the layout routines
*           can get display info about the screen, no rendering will
*           be done.
*
*       taglist - Pointer to a TagItem list (see below for allowed tags)
*
*   TAGS
*       GL_RightExtreme (LONG *) - A pointer to a LONG where GadLayout
*           will put the co-ordinate of the rightmost point where any
*           imagery of the laid-out gadgets will be drawn.  Use this to
*           open a window exactly big enough to hold all your gadgets.
*           Use this value alone with the WA_InnerWidth window tag and
*           NOT WA_Width, since you do not know how big the window
*           border will be.
*       GL_LowerExtreme (LONG *) - A pointer to a LONG where GadLayout
*           will put the co-ordinate of the lowermost point where any
*           imagery of the laid-out gadget will be drawn.  Use this to open
*           a window exactly big enough to hold all your gadgets.
*           Use this value alone with the WA_InnerHeight window tag and
*           NOT WA_Height, since you do not know how big the window
*           border will be.
*       GL_DefTextAttr (struct TextAttr *) - Instead of having to indicate
*           a TextAttr for each gadget, you can specify a font to be used
*           by default for all your gadgets.
*       GL_Catalog (struct Catalog *) - Specify the locale catalog to use
*           to get your strings from.  If you wish to localize your gadget
*           string via GL_LocaleText you MUST use this tag as well as
*           GL_AppStrings.  You must also make certain that locale.library
*           has been opened successfully with LocaleBase pointing to the
*           library base.
*       GL_AppStrings (struct AppString **) - If you wish to make your
*           gadgets localized, you you must pass a list of strings and
*           their IDs.  The format of these strings is an array of
*           structures, with a LONG that contains the ID and a STRPTR
*           pointing to the string, i.e.:
*               struct AppString
*               {
*                   LONG   as_ID;
*                   STRPTR as_Str;
*               };
*           These strings serve as the default language for the gadgets.
*           See locale.library documentation for more information on
*           localizing applications.  You MUST use this tag in addition to
*           GL_Catalog if you wish to use GL_LocaleText to localize your
*           gadgets.
*       GL_NoCreate (BOOL) - Set to TRUE if you don't want the layout
*           routine to actually create any gadgets.  This is used when
*           you want to use the GL_RightExtreme and GL_LowerExtreme tags
*           to find out how much space your gadgets will take, but don't
*           actually want to create the gadgets just yet.
*       GL_BorderTop (UWORD) - The size of the top border of your window.
*           If your window does not have the WFLG_GIMMEZEROZERO flag set,
*           it will be necessary to pass the size of the window borders.
*           This value can be gotten either from the Window structure of
*           your window (if it is already open), or from the Screen
*           structure of your screen (see intuition/screens.h for details
*           about this).  NOTE: This value is NOT added to the value
*           returned by GL_LowerExtreme!
*       GL_BorderLeft (UWORD) - The size of the left border of your window.
*           If your window does not have the WFLG_GIMMEZEROZERO flag set,
*           it will be necessary to pass the size of the window borders.
*           This value can be gotten either from the Window structure of
*           your window (if it is already open), or from the Screen
*           structure of your screen (see intuition/screens.h for details
*           about this).  NOTE: This value is NOT added to the value
*           returned by GL_RightExtreme.
*
*   RESULT
*       gad_info - A pointer to a private structure.  You must keep this
*           value and pass it to FreeLayoutGadgets() later on in order to
*           free up all resources used by your gadgets.
*
*   NOTES
*       You must be careful with the taglist in the lg_LayoutTags field.
*       Tags are processed sequentally in the order you give them in, and
*       if a tag references another gadget (eg. the GL_TopRel tag), then
*       processing of the current gadget halts while the referenced gadget
*       is processed (if it has not already been processed).  Problems can
*       arise if this gadget refers back to the original gadget that
*       referenced it, if it is referring to a field that has not yet been
*       processed in that gadget.  For example, gadget GAD_BUTTON1 may use
*       the GL_TopRel tag to refer to GAD_BUTTON2, which may subsequently
*       make use of GL_LeftRel to refer back to GAD_BUTTON1.  The gadgets
*       left edge must already be defined in GAD_BUTTON1 (i.e. a tag such
*       as GL_Left MUST appear before the GL_TopRel tag) if GAD_BUTTON2 is
*       to get the left edge desired.
*
*   BUGS
*       Doesn't do any checking to make sure gadgets don't overlap.
*       Essentially assumes you know what you're doing with the layout.
*
*       Bad things will happen if you provide an IMAGEBUTTON_KIND gadget
*       with an image too big to fit within the dimensions you've provided
*       for the gadget.
*
*   SEE ALSO
*       FreeLayoutGadgets(), gadlayout/gadlayout.h, libraries/gadtools.h,
*       GadTools documentation.
*
*****************************************************************************
*
*  Have you read the license info?  It tells you that you must send your
*  modifications of GadLayout to me, and that you may not make GadLayout
*  into a shared library.
*
*/
struct PrivateInfo * LayoutGadgets(struct Gadget **gad_list, struct LayoutGadget *gadgets,
				   struct Screen *screen, Tag *firsttag, ...)
{
	return( LayoutGadgetsA(gad_list, gadgets, screen, &firsttag) );
}

struct PrivateInfo * LayoutGadgetsA(struct Gadget **gad_list, struct LayoutGadget *gadgets,
					struct Screen *screen, struct TagItem *taglist)
{
	struct PrivateInfo *pi;
	struct Gadget *last_gad;
	struct NewGadget ng;
	struct LaidOutGadget gad_array[100];	/* Cop-out, should be dynamic */
	struct TagItem *tag=NULL;
	struct TextAttr *tattr=NULL;
	UWORD bordertop=0, borderleft=0;
	WORD *rightextreme=NULL, *lowerextreme=NULL;
	BOOL nocreate=FALSE;
	WORD num_gads=0, i;

	/* Allocate and initialize the PrivateInfo structure.
	 */
	if (!(pi = (struct PrivateInfo *)AllocVec(sizeof(struct PrivateInfo), MEMF_CLEAR)))
		return(NULL);

	pi->pi_Screen = screen;
	if (!(pi->pi_VisualInfo = GetVisualInfo(screen, TAG_DONE)))
		return(NULL);
	if (!(pi->pi_DrawInfo = GetScreenDrawInfo(pi->pi_Screen)))
		return(NULL);
	pi->pi_Remember = NULL;

	/* Count the number of gadgets that we have, and allocate space for
	 * NewGadget structures for all of them.
	 */
	while (gadgets[num_gads].lg_GadgetID != -1)
		num_gads++;

	/* if (!(gad_array = (struct LaidOutGadget *)AllocVec(num_gads * sizeof(struct LaidOutGadget), MEMF_ANY | MEMF_CLEAR)))
		return(NULL); */

	/* Evaluate the tag list.  Order does not make any difference with the
	 * tags supported at the moment.  In the case of duplicate tags, only
	 * the first will be recognized.
	 */

	/* ti_Data is a pointer to a LONG to store the right-most point that a
	 * gadget will exist in.
	 */
	if (tag = FindTagItem(GL_RightExtreme, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_RightExtreme  Data: %ld\n",tag->ti_Data);
#endif
		rightextreme = (WORD *)tag->ti_Data;
	}
	/* ti_Data is a pointer to a LONG to store the lower-most point that a
	 * a gadget will exist in.
	 */
	if (tag = FindTagItem(GL_LowerExtreme, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_LowerExtreme  Data: %ld\n",tag->ti_Data);
#endif
		lowerextreme = (WORD *)tag->ti_Data;
	}
	/* Indicates locale for the gadgets.
	 */
	if (tag = FindTagItem(GL_Catalog, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_Catalog  Data: %ld\n",tag->ti_Data);
#endif
		pi->pi_Catalog = (struct Catalog *)tag->ti_Data;
	}
	/* Indicates locale for the gadgets.
	 */
	if (tag = FindTagItem(GL_AppStrings, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_AppStrings  Data: %ld\n",tag->ti_Data);
#endif
		pi->pi_AppStrings = (struct AppString *)tag->ti_Data;
	}
	/* Specifies a default font for use with all gadgets, can still be
	 * over-ridden with GL_TextAttr.
	 */
	if (tag = FindTagItem(GL_DefTextAttr, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_DefTextAttr  Data: %ld\n",tag->ti_Data);
#endif
		tattr = (struct TextAttr *)tag->ti_Data;
	}
	/* Specifies the size of the top window border.
	 */
	if (tag = FindTagItem(GL_BorderTop, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_BorderTop  Data: %ld\n",tag->ti_Data);
#endif
		bordertop = (UWORD)tag->ti_Data;
	}
	/* Specifies the size of the left window border.
	 */
	if (tag = FindTagItem(GL_BorderLeft, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_BorderLeft  Data: %ld\n",tag->ti_Data);
#endif
		borderleft = (UWORD)tag->ti_Data;
	}
	/* Specifies that we don't actually want to create the gadgets.
	 */
	if (tag = FindTagItem(GL_NoCreate, taglist))
	{
#ifdef GL_DEBUG
		Printf("Tag: GL_NoCreate  Data: %ld\n",tag->ti_Data);
#endif
		nocreate = (BOOL)tag->ti_Data;
	}

	for (i = 0; i <= num_gads; i++)
		gad_array[i].log_IsEvaluated = FALSE;

	/* Initialize the gadget linked list.
	 */
#ifdef GL_DEBUG
	PutStr("Creating gadget context\n");
#endif
	if (nocreate == FALSE)
	{
		if (!(last_gad = CreateContext(gad_list)))
			return(NULL);
	}

	/* Initialize some suitable defaults for the gadgets.
	 */
	ng.ng_Height = ng.ng_Width = 0;
	ng.ng_LeftEdge = ng.ng_TopEdge = 0;
	ng.ng_GadgetText = NULL;
	ng.ng_TextAttr = tattr;
	ng.ng_GadgetID = 0;
	ng.ng_Flags = 0;
	ng.ng_VisualInfo = pi->pi_VisualInfo;            
	ng.ng_UserData = NULL;

	if (rightextreme)
		*rightextreme = 0;
	if (lowerextreme)
		*lowerextreme = 0;

	/* Read each gadget in the layout array, setting up its NewGadget structure.
	 */
#ifdef GL_DEBUG
	PutStr("Evaluating each gadget\n");
#endif
	for (i = 0; i < num_gads; i++)
		evaluate_gadget(pi, i, gadgets, &ng, gad_array);

	/* OK, the gagdets have all been laid out into NewGadget structures, we
	 * now go ahead and create them all.
	 */
#ifdef GL_DEBUG
	PutStr("Creating each gadget\n");
#endif
	for (i = 0; i < num_gads; i++)
	{
#ifdef GL_DEBUG
		Printf("Creating gadget %ld\n", (WORD)i);
#endif
		if (rightextreme)
			*rightextreme = MAX(*rightextreme, gad_array[i].log_NewGadget.ng_LeftEdge + gad_array[i].log_NewGadget.ng_Width);
		if (lowerextreme)
			*lowerextreme = MAX(*lowerextreme, gad_array[i].log_NewGadget.ng_TopEdge + gad_array[i].log_NewGadget.ng_Height);

		if (nocreate == FALSE)
		{
			gad_array[i].log_NewGadget.ng_LeftEdge += borderleft;
			gad_array[i].log_NewGadget.ng_TopEdge += bordertop;

			switch (gad_array[i].log_GadgetKind)
			{
				case IMAGEBUTTON_KIND:
				case FILE_KIND:
				case DRAWER_KIND:
					gadgets[i].lg_Gadget = last_gad = create_layout_gad(pi,
																		gad_array[i].log_GadgetKind,
																		last_gad,
																		&(gad_array[i].log_NewGadget),
																		gadgets[i].lg_LayoutTags);
					break;

				default:
					gadgets[i].lg_Gadget = last_gad = CreateGadgetA(gad_array[i].log_GadgetKind,
																	last_gad,
																	&(gad_array[i].log_NewGadget),
																	gadgets[i].lg_GadToolsTags);
					break;
			}
		}
#ifdef GL_DEBUG
		if (last_gad == NULL)
			PutStr("Couldn't create gadget\n");
#endif
	}
	/* FreeVec(gad_array); */

#ifdef GL_DEBUG
	PutStr("Done\n");
#endif
	if (nocreate == FALSE)
	{
		if (last_gad != NULL)
		{
			pi->pi_GadList = *gad_list;

			return(pi);
		}
	}
	else
		FreeVec(pi);

	return(NULL);
}


/****** gadlayout/GL_SetGadgetAttrsA ****************************************
*
*   NAME
*       GL_SetGadgetAttrsA -- Change attributes of a GadLayout gadget.
*       GL_SetGadgetAttrs -- Varargs stub for GL_SetGadgetAttrsA.
*
*   SYNOPSIS
*       GL_SetGadgetAttrsA(gad_info, gad, win, req, taglist)
*       VOID GL_SetGadgetAttrsA(APTR, struct Gadget *, struct Window *,
*                               struct Requester *, struct TagItem *)
*
*       GL_SetGadgetAttrs(gad_info, gad, win, req, firsttag, ...)
*       VOID GL_SetGadgetAttrs(APTR, struct Gadget *, struct Window *,
*                              struct Requester *, Tag *, ...)
*
*   FUNCTION
*       Changes attributes for one of the GadLayout gadget kinds according
*       according to the attributes chosen in the tag list.
*
*   INPUTS
*       gad_info - The value returned by LayoutGadgetsA().
*       gad - Pointer to the gadget in question.
*       win - Pointer to the window containing the gadget.
*       req - Pointer to the requester containing the gadget, or NULL if
*           not in a requester. (Not implemented yet, use NULL.)
*       taglist - Pointer to a TagItem list.
*
*   TAGS
*       IMAGEBUTTON_KIND:
*       GLIM_Image (struct Image *) - Changes the image displayed in the
*           gadget.
*       GLIM_Toggle (BOOL) - Makes the gadget a toggle switch gadget (if
*           it is not already) and puts it into either the selected state
*           (ti_Data = TRUE) or deselectd state (ti_Data = FALSE).
*
*   BUGS
*       This function is not compatable with itself in releases 1.5 and
*       lower, because of the new pi parameter!  ALL OLD CODE WILL HAVE TO
*       BE CHANGED!!!
*
*       Attributes not pertaining to a specific gadget kind will not
*       always be ignored, so you will need to be careful that you only
*       try to change attributes that are valid for the gadget's kind.
*
*****************************************************************************
*
*  Have you read the license info?  It tells you that you must send your
*  modifications of GadLayout to me, and that you may not make GadLayout
*  into a shared library.
*
*/
VOID GL_SetGadgetAttrs(struct PrivateInfo *pi, struct Gadget *gad, struct Window *win, struct Requester *req,
						Tag *firsttag, ...)
{
	return( GL_SetGadgetAttrsA(pi, gad, win, req, &firsttag) );
}

VOID GL_SetGadgetAttrsA(struct PrivateInfo *pi, struct Gadget *gad,
						struct Window *win, struct Requester *req,
						struct TagItem *taglist)
{
	struct TagItem *tag;

	if (tag = FindTagItem(GLIM_Image, taglist))
	{
		if ((gad->MutualExclude & GADLAYOUT_KIND) == GADLAYOUT_KIND)
		{
			struct Image *image = (struct Image *)gad->GadgetRender;
			struct Image *new_image = (struct Image *)tag->ti_Data;

			/* Remove the gadget while we work on it.
			 */
			RemoveGadget(win, gad);

			/* Setup the new gadget imagery.
			 */
			gad->GadgetRender = create_gad_images(IMAGEBUTTON_KIND, gad->Width, gad->Height,
												  pi, new_image,
												  gad->MutualExclude & GLFLG_READONLY);

			/* Re-add the gadget and refresh it.
			 */
			AddGadget(win, gad, ~0);
			RefreshGList(gad, win, req, 1);
		}
	}
	else if (tag = FindTagItem(GLIM_Toggle, taglist))
	{
		if ((gad->MutualExclude & GADLAYOUT_KIND) == GADLAYOUT_KIND)
		{
			/* Remove the gadget while we work on it.
			 */
			RemoveGadget(win, gad);

			gad->Activation |= GACT_TOGGLESELECT;

			if (tag->ti_Data)
				gad->Flags |= GFLG_SELECTED;
			else
				gad->Flags &= ~GFLG_SELECTED;

			/* Re-add the gadget and refresh it.
			 */
			AddGadget(win, gad, ~0);
			RefreshGList(gad, win, req, 1);
		}
	}
}


/****** gadlayout/GadgetArrayIndex ******************************************
*
*   NAME
*       GadgetArrayIndex -- Get a gadget's index in the LayoutGadget array.
*
*   SYNOPSIS
*       i = GadgetArrayIndex(gad_id, gadgets)
*       WORD GadgetArrayIndex(WORD, struct LayoutGadget *)
*
*   FUNCTION
*       Given a gadget ID, returns the index of that gadget's definition
*       in the LayoutGadget array.  For example, in cases where you need
*       to know a gadget's Gadget structure (eg. if you wanted to use
*       the Intuition function ActivateGadget() to make a string or an
*       integer gadget active), you would need to lookup the lg_Gadget
*       field in the LayoutGadget array.  You MUST NOT GIVE THE ARRAY
*       INDEX YOURSELF, THIS IS NOT GUARUNTEED TO REMAIN VALID!  Instead,
*       pass the id of the gadget that you want and this function will
*       return the array index for you.
*
*   INPUTS
*       gad_id - The ID of the gadget you want to find.
*       gadgets - The LayoutGadget array that this gadget is defined in.
*
*   RESULT
*       i - The index into the LayoutGadget array of the entry of the
*          gadget ID you asked for.
*
*****************************************************************************
*
*  Have you read the license info?  It tells you that you must send your
*  modifications of GadLayout to me, and that you may not make GadLayout
*  into a shared library.
*
*/
WORD GadgetArrayIndex(WORD gad_id, struct LayoutGadget *gadgets)
{
	WORD i=0;

	while ( (gadgets[i].lg_GadgetID != gad_id) && (gadgets[i].lg_GadgetID != -1) )
		i++;

	return(i);
}


/****** gadlayout/GetGadgetInfo *********************************************
*
*   NAME
*       GetGadgetInfo -- Get a pointer to a gadget's structure.
*
*   SYNOPSIS
*       gadget = GetGadgetInfo(gad_id, gadgets)
*       WORD GetGadgetInfo(WORD, struct LayoutGadget *)
*
*   FUNCTION
*       Given a gadget ID, returns the GadTools Gadget structure of that
*       gadget.
*
*   INPUTS
*       gad_id - The ID of the gadget you want to find.
*       gadgets - The LayoutGadget array that this gadget is defined in.
*
*   RESULT
*       gadget - The GadTools Gadget structure of the gadget ID you asked
*           for.  As per GadTools conventions, the actual contents of this
*           structure are PRIVATE.
*
*   SEE ALSO
*       GadgetArrayIndex()
*
*****************************************************************************
*
*  Have you read the license info?  It tells you that you must send your
*  modifications of GadLayout to me, and that you may not make GadLayout
*  into a shared library.
*
*/
struct Gadget * GetGadgetInfo(WORD gad_id, struct LayoutGadget *gadgets)
{
	WORD i=0;

	while ( (gadgets[i].lg_GadgetID != gad_id) && (gadgets[i].lg_GadgetID != -1) )
		i++;

	return(gadgets[i].lg_Gadget);
}


/****** gadlayout/GadgetKeyCmd **********************************************
*
*   NAME
*       GadgetKeyCmd -- Returns the key equivalent of a gadget.
*
*   SYNOPSIS
*       key = GadgetKeyCmd(gad_info, gad_id, gadgets)
*       UBYTE GadgetKeyCmd(APTR, WORD, struct LayoutGadget *)
*
*   FUNCTION
*       Looks for an underscore (_) character in a gadgets label to determine
*       the key equivalent, if any, for a gadget.  This is particularly
*       useful in localized code where the key equivalent may differ
*       depending on what locale the user is running under.
*
*   INPUTS
*       gad_info - The value returned by LayoutGadgetsA().
*       gad_id - The GadgetID of the gadget whose key equivalent you want.
*       gadgets - The LayoutGadget arrow that your gadget exists in.
*
*   RESULT
*       key - The key equivalent for the gadget, always in lowercase.
*
*   BUGS
*       Only works if GT_Underscore, '_' is used for key equivalents, will
*       not work if another underscore character is used.
*
*****************************************************************************
*
*  Have you read the license info?  It tells you that you must send your
*  modifications of GadLayout to me, and that you may not make GadLayout
*  into a shared library.
*
*/
UBYTE GadgetKeyCmd(struct PrivateInfo *pi, WORD gad_id, struct LayoutGadget *gadgets)
{
	char key = 0;
	WORD i=0;

	while ( (gadgets[i].lg_GadgetID != gad_id) && (gadgets[i].lg_GadgetID != -1) )
		i++;

	if (gadgets[i].lg_GadgetID != -1)
	{
		struct TagItem *tag=NULL;
		char text[100]="", *temp_text;

		if (tag = FindTagItem(GL_GadgetText, gadgets[i].lg_LayoutTags))
			strcpy(text, (char *)tag->ti_Data);
		else if (tag = FindTagItem(GL_LocaleText, gadgets[i].lg_LayoutTags))
			strcpy(text, get_locale_string(pi->pi_Catalog, pi->pi_AppStrings, tag->ti_Data));

		if (temp_text = strpbrk(text, "_"))
			key = ToLower(temp_text[1]);
	}
	return(key);
}


/****** gadlayout/FreeLayoutGadgets *****************************************
*
*   NAME
*       FreeLayoutGadgets -- Frees gadgets laid out with LayoutGadgets().
*
*   SYNOPSIS
*       FreeLayoutGadgets(gad_info);
*       VOID FreeLayoutGadgets(APTR);
*
*   FUNCTION
*       Frees all resources used in creating and laying out gadgets with
*       LayoutGadgets().  This frees all gadgets as well as other
*       resources used.  Generally this will be called after a call to
*       CloseWindow() in Intuition.
*
*   INPUTS
*       gad_info - The pointer returned by LayoutGadgets().
*
*   SEE ALSO
*       LayoutGadgetsA()
*
*****************************************************************************
*
* PrivateInfo is a private data-type, and therefore this function is
* documented as taking APTR.
*
*  Have you read the license info?  It tells you that you must send your
*  modifications of GadLayout to me, and that you may not make GadLayout
*  into a shared library.
*
*/
VOID FreeLayoutGadgets(struct PrivateInfo *pi)
{
	struct Gadget *g;

	if (pi)
	{
		g = pi->pi_GadList;

		/* while (g)
		{
			if ((g->MutualExclude & GADLAYOUT_KIND) == GADLAYOUT_KIND)
			{
				struct Image *image = (struct Image *)g->GadgetRender;
				WORD i;

				for(i = 0 ; i < 2 ; i++)
					FreeVec(image[i].ImageData);

				FreeVec(image);
			}
			g = g->NextGadget;
		} */
		FreeRemember(&(pi->pi_Remember), TRUE);

		if (pi->pi_VisualInfo)
			FreeVisualInfo(pi->pi_VisualInfo);
		 if (pi->pi_DrawInfo)
			FreeScreenDrawInfo(pi->pi_Screen, pi->pi_DrawInfo);
		if (pi->pi_GadList)
			FreeGadgets(pi->pi_GadList);

		FreeVec(pi);
	}
}


/* Local routine that handles the layout tag list.  Each tag is evaluated
 * and the NewGadget structure for the gadget is setup.
 */
VOID evaluate_gadget(struct PrivateInfo *pi, WORD gad_num, struct LayoutGadget *gadgets,
					 struct NewGadget *ng, struct LaidOutGadget *gad_array)
{
	struct TagItem *tag=NULL, *tstate;
	struct NewGadget temp_ng;
	ULONG gad_kind=BUTTON_KIND;
	LONG textwidth;
	WORD found_num=0;
	BOOL extended_kind=FALSE;

	/* If we are already evaluating this gadgeting, then we won't risk a
	 * recursive state by trying to do it again.
	 */
	if (gad_array[gad_num].log_IsEvaluated)
		return;

	gad_array[gad_num].log_IsEvaluated = TRUE;

	ng->ng_GadgetID = gadgets[gad_num].lg_GadgetID;

	/* Look at each tag item sequentially.
	 */
	tstate = gadgets[gad_num].lg_LayoutTags;
	while (tag = NextTagItem(&tstate))
	{
		switch (tag->ti_Tag)
		{
			case GL_GadgetKind:
				/* Use a GadTools gadget, ti_Data indicates which kind (from
				 * libraries/gadtools.h).
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_GadgetKind  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID ,tag->ti_Data);
#endif
				gad_kind = tag->ti_Data;

				switch (tag->ti_Data)
				{
					case IMAGEBUTTON_KIND:
					case BORDERBUTTON_KIND:
					case DRAWER_KIND:
					case FILE_KIND:
						extended_kind = TRUE;
						break;
					default:
						extended_kind = FALSE;
						break;
				}
				break;

			case GL_GadgetText:
				/* Gadget label.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_GadgetText  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID ,tag->ti_Data);
#endif
				ng->ng_GadgetText = (STRPTR)tag->ti_Data;
				break;

			case GL_LocaleText:
				/* Gadget label.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_LocaleText  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID ,tag->ti_Data);
#endif
				ng->ng_GadgetText = get_locale_string(pi->pi_Catalog, pi->pi_AppStrings, tag->ti_Data);
				break;

			case GL_TextAttr:
				/* Desired font for gadget label.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_TextAttr  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_TextAttr = (struct TextAttr *)tag->ti_Data;
				break;

			case GL_Flags:
				/* Gadget flags.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Flags  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Flags = tag->ti_Data;
				break;

			case GL_UserData:
				/* Gadget UserData.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_UserData  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_UserData = (APTR)tag->ti_Data;
				break;

			case GL_Width:
				/* Absolute gadget width.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Width  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Width = tag->ti_Data;
				break;

			case GL_AutoWidth:
				/* Set width according to length of text label + (LONG)ti_Data.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AutoWidth  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				textwidth = text_width(ng->ng_GadgetText, ng->ng_TextAttr);
				ng->ng_Width = textwidth + (LONG)tag->ti_Data;
				break;

			case GL_Columns:
				/* Set width according to approximately fit ti_Data columns.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Columns  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				{
					char tempstr[2] = "X";

					textwidth = text_width(tempstr, ng->ng_TextAttr) * (WORD)tag->ti_Data;
					ng->ng_Width = textwidth;
				}
				break;

			case GL_MinWidth:
				/* Make sure the width is at least a certain value.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_MinWidth  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				if (ng->ng_Width < (LONG)tag->ti_Data)
					ng->ng_Width = (LONG)tag->ti_Data;
				break;

			case GL_MaxWidth:
				/* Make sure the width is at most a certain value.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_MaxWidth  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				if (ng->ng_Width > (LONG)tag->ti_Data)
					ng->ng_Width = (LONG)tag->ti_Data;
				break;

			case GL_Height:
				/* Absolute gadget height.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Height  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Height = tag->ti_Data;
				break;

			case GL_DupeHeight:
				/* Duplicate the height of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_DupeHeight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_Height = gad_array[found_num].log_NewGadget.ng_Height;
				break;

			case GL_HeightFactor:
				/* Make height a multiple of the font height.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_HeightFactor  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Height = tag->ti_Data * ng->ng_TextAttr->ta_YSize;
				break;

			case GL_AutoHeight:
				/* Set height according to height of text font + (LONG)ti_Data.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AutoHeight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Height = ng->ng_TextAttr->ta_YSize + 2 + (LONG)tag->ti_Data;
				break;

			case GL_AddHeight:
				/* Add some value to the total height calculation.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AddHeight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Height += (LONG)tag->ti_Data;
				break;

			case GL_MinHeight:
				/* Make sure the height is at least a certain value.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_MinHeight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				if (ng->ng_Height < (LONG)tag->ti_Data)
					ng->ng_Height = (LONG)tag->ti_Data;
				break;

			case GL_MaxHeight:
				/* Make sure the height is at most a certain value.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_MaxHeight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				if (ng->ng_Height > (LONG)tag->ti_Data)
					ng->ng_Height = (LONG)tag->ti_Data;
				break;

			case GL_Top:
				/* Absolute top edge.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Top  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_TopEdge = tag->ti_Data;
				break;

			case GL_Bottom:
				/* Absolute bottom edge.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Bottom  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_TopEdge = tag->ti_Data - ng->ng_Height;
				break;

			case GL_Left:
				/* Absolute left edge.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Left  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_LeftEdge = tag->ti_Data;
				break;

			case GL_Right:
				/* Absolute right edge.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_Right  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_LeftEdge = tag->ti_Data - ng->ng_Width;
				break;

			case GL_DupeWidth:
				/* Duplicate the width of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_DupeWidth  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_Width = gad_array[found_num].log_NewGadget.ng_Width;
				break;

			case GL_AddWidth:
				/* Add some value to the total width calculation.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AddWidth  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_Width += (LONG)tag->ti_Data;
				break;

			case GL_LeftRel:
				/* Left edge relative to right edge of previous gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_LeftRel  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_LeftEdge = gad_array[found_num].log_NewGadget.ng_LeftEdge + gad_array[tag->ti_Data].log_NewGadget.ng_Width;
				break;

			case GL_AlignLeft:
				/* Align left edge with the left edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AlignLeft  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_LeftEdge = gad_array[found_num].log_NewGadget.ng_LeftEdge;
				break;

			case GL_AdjustLeft:
				/* ADD the width of the text label + ti_Data to the left edge.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AdjustLeft  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				textwidth = text_width(ng->ng_GadgetText, ng->ng_TextAttr);
				ng->ng_LeftEdge += textwidth + (LONG)tag->ti_Data;
				break;

			case GL_AddLeft:
				/* Add some value to the final left edge calculation.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AddLeft  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_LeftEdge += (LONG)tag->ti_Data;
				break;

			case GL_TopRel:
				/* Top edge relative to bottom edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_TopRel  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_TopEdge = gad_array[found_num].log_NewGadget.ng_TopEdge
								 + gad_array[found_num].log_NewGadget.ng_Height;
				break;

			case GL_BottomRel:
				/* Bottom edge relative to top edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_BottomRel  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_TopEdge = gad_array[found_num].log_NewGadget.ng_TopEdge - ng->ng_Height;
				break;

			case GL_AdjustTop:
				/* ADD the height of the text font + ti_Data to the top edge.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AdjustTop  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_TopEdge += ng->ng_TextAttr->ta_YSize + (LONG)tag->ti_Data;
				break;

			case GL_AlignTop:
				/* Align left edge with the left edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AlignTop  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_TopEdge = gad_array[found_num].log_NewGadget.ng_TopEdge;
				break;

			case GL_AddTop:
				/* Add some value to the final top edge calculation.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AddTop  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_TopEdge += (LONG)tag->ti_Data;
				break;

			case GL_AlignBottom:
				/* Align left edge with the left edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AlignBottom  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_TopEdge = gad_array[found_num].log_NewGadget.ng_TopEdge
								  + gad_array[found_num].log_NewGadget.ng_Height
								  - ng->ng_Height;
				break;

			case GL_AddBottom:
				/* Add some value to the final bottom edge calculation.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AddBottom  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_TopEdge += (LONG)tag->ti_Data;
				break;

			case GL_RightRel:
				/* Right edge relative to left edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_RightRel  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_LeftEdge = gad_array[found_num].log_NewGadget.ng_LeftEdge
								  - ng->ng_Width;
				break;

			case GL_AlignRight:
				/* Align right edge with the right edge of another gadget.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AlignRight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				found_num = GadgetArrayIndex(tag->ti_Data, gadgets);
				gad_array[gad_num].log_GadgetKind = gad_kind;
				CopyMem(ng, &(gad_array[gad_num].log_NewGadget),
					sizeof(struct NewGadget));
				CopyMem(ng, &temp_ng, sizeof(struct NewGadget));
				evaluate_gadget(pi, found_num, gadgets, &temp_ng, gad_array);
				ng->ng_LeftEdge = gad_array[found_num].log_NewGadget.ng_LeftEdge
								  + gad_array[found_num].log_NewGadget.ng_Width
								  - ng->ng_Width;
				break;

			case GL_AddRight:
				/* Add some value to the final right edge calculation.
				 */
#ifdef GL_DEBUG
				Printf("Gadget: %ld  Tag: GL_AddRight  Data: %ld\n", (LONG)gadgets[gad_num].lg_GadgetID, tag->ti_Data);
#endif
				ng->ng_LeftEdge += (LONG)tag->ti_Data;
				break;

			default:
				break;
		}
	}

	/* Now copy everything we know into the NewGadget structure.
	 */
	gad_array[gad_num].log_GadgetKind = gad_kind;
	CopyMem(ng, &(gad_array[gad_num].log_NewGadget), sizeof(struct NewGadget));
}


/* Local routine to determine how many pixels wide a string will be with a
 * given font.
 */
LONG text_width(char *str, struct TextAttr *font)
{
	struct IntuiText itext;

	itext.IText=str;
	itext.ITextFont=font;
	itext.FrontPen=1;
	itext.BackPen=0;
	itext.DrawMode=JAM1;
	itext.LeftEdge=0;
	itext.TopEdge=0;
	itext.NextText=NULL;

	return(IntuiTextLength(&itext));
}


/* Local routine to get a localized text string, given its ID.
 */
STRPTR get_locale_string(struct Catalog *catalog, struct AppString *appstrings,
						 LONG id)
{
	UWORD i=0;
	STRPTR local = NULL;

	if (appstrings)
	{
		while (!local)
		{
			if (appstrings[i].as_ID == id)
				local = appstrings[i].as_Str;
			i++;
		}

		if (LocaleBase)
			return(GetCatalogStr(catalog, id, local));
	}

    return(local);
}


/* Locale function to create one of GadLayout's extended gadgets.
 */
struct Gadget * create_layout_gad(struct PrivateInfo *pi, WORD gad_kind,
								  struct Gadget *last_gad, struct NewGadget *ng,
								  struct TagItem *taglist)
{
	struct Gadget *gad=NULL, *textgad=NULL;
	struct TagItem *tag;
	struct Image *image, *temp_image;
	struct NewGadget textng;
	BOOL readonly=FALSE, toggle=FALSE;

	switch (gad_kind)
	{
		case IMAGEBUTTON_KIND:
		case FILE_KIND:
		case DRAWER_KIND:
			if (gad_kind == IMAGEBUTTON_KIND)
			{
				if (tag = FindTagItem(GLIM_Image, taglist))
				{
#ifdef GL_DEBUG
					Printf("Tag: GLIM_Image  Data: %ld\n",tag->ti_Data);
#endif
					temp_image = (struct Image *)tag->ti_Data;
				}
				if (tag = FindTagItem(GLIM_ReadOnly, taglist))
				{
#ifdef GL_DEBUG
					Printf("Tag: GLIM_ReadOnly  Data: %ld\n",tag->ti_Data);
#endif
					readonly = tag->ti_Data;
				}
				if (tag = FindTagItem(GLIM_Toggle, taglist))
				{
#ifdef GL_DEBUG
					Printf("Tag: GLIM_Toggle  Data: %ld\n",tag->ti_Data);
#endif
					toggle = tag->ti_Data;
				}
			}
			else if (gad_kind == DRAWER_KIND)
				temp_image = &drawer_image;
			else if (gad_kind == FILE_KIND)
				temp_image = &file_image;

			/* Since GENERIC_KIND gadgets don't full support the ng_GadgetText
			 * field, we'll get around this by creating a TEXT_KIND gadget
			 * that displays the text for us.
			 */
			if (ng->ng_GadgetText)
			{
				CopyMem(ng, &textng, sizeof(struct NewGadget));
				textng.ng_GadgetID = 1000;

				switch (textng.ng_Flags)
				{
					case PLACETEXT_LEFT:
						textng.ng_Width = 0;
						break;

					case PLACETEXT_RIGHT:
						textng.ng_LeftEdge += textng.ng_Width;
						textng.ng_Width = 0;
						break;

					case PLACETEXT_ABOVE:
						textng.ng_Height = 0;
						break;

					case PLACETEXT_BELOW:
						textng.ng_TopEdge += textng.ng_Height;
						textng.ng_Height = 0;
						break;

					default:
						break;
				}
				textgad = last_gad = CreateGadget(TEXT_KIND, last_gad, &textng,
										GT_Underscore, '_',
										TAG_DONE);
			}

			ng->ng_GadgetText = NULL;

			/* Create the image structure, then make the gadget.
			 */
			if (image = create_gad_images(gad_kind, ng->ng_Width, ng->ng_Height,
						pi, temp_image, readonly))
			{
				if (gad = last_gad = CreateGadget(GENERIC_KIND, last_gad, ng,
										TAG_DONE))
				{
					gad->GadgetType |= GTYP_BOOLGADGET;
					gad->GadgetRender = &image[0];
					gad->SelectRender = &image[1];
					gad->Flags |=  GFLG_GADGIMAGE | ((readonly)? GFLG_GADGHNONE : GFLG_GADGHIMAGE);
					gad->Activation |= GACT_RELVERIFY | ((toggle)? GACT_TOGGLESELECT : 0);
					gad->MutualExclude = GADLAYOUT_KIND | ((readonly)? GLFLG_READONLY : 0) | ((toggle)? GLFLG_TOGGLE : 0);
				}
				else
				{
#ifdef GL_DEBUG
					PutStr("Couldn't create GadLayout gadget\n");
#endif
				}
			}
			else
			{
#ifdef GL_DEBUG
				PutStr("Couldn't create GadLayout imagery\n");
#endif
			}
			ng->ng_GadgetText = textng.ng_GadgetText;

			break;

		default:
			break;
	}
	return(gad);
}


/* Local routine to return image structures for IMAGEBUTTON_KIND, DRAWER_KIND and
 * FILE_KIND gadgets.
 */
struct Image * create_gad_images(WORD gad_kind, UWORD width, UWORD height,
								 struct PrivateInfo *pi, struct Image *image,
								 BOOL readonly)
{
	struct Image *new_image = NULL;
	struct Remember *image_rem = NULL;
	UWORD image_width = 8, image_height = 8;

	/* Minimum size required.
	 */
	if (image)
	{
		image_width = image->Width;
		image_height = image->Height;
	}
	if ((width >= image_width + 4) && (height >= image_height + 2))
	{
		struct RastPort	*rport;

		/* Allocate local dummy rastport.
		 */
		if (rport = (struct RastPort *)AllocRemember(&image_rem, sizeof(struct RastPort), MEMF_ANY))
		{
			struct BitMap *bitmap[2] = { NULL, NULL };
			struct Layer_Info *layer_info[2] = { NULL, NULL };
			struct Layer *layer[2] = { NULL, NULL };
			BYTE success = FALSE;
			WORD depth, i,j;

			/* Determine screen depth.
			 */
			depth = pi->pi_Screen->RastPort.BitMap->Depth;

			/* Set up rastport.
			 */
			InitRastPort(rport);

			/* Allocate bitmaps and bitplane data.
			 */
			success = TRUE;

			for (i = 0 ; success && i < 2 ; i++)
			{
				if (bitmap[i] = (struct BitMap *)AllocRemember(&image_rem, sizeof(struct BitMap), MEMF_ANY))
				{
					InitBitMap(bitmap[i], depth, width, height);

					if (bitmap[i]->Planes[0] = (PLANEPTR)AllocRemember(&(pi->pi_Remember), bitmap[i]->BytesPerRow * bitmap[i]->Rows * bitmap[i]->Depth, MEMF_CHIP | MEMF_CLEAR))
					{
						for (j = 1 ; j < depth ; j++)
							bitmap[i]->Planes[j] = bitmap[i]->Planes[j - 1] + bitmap[i]->BytesPerRow * bitmap[i]->Rows;
					}
					else
						success = FALSE;
				}
				else
					success = FALSE;
			}

			/* Did we get what we wanted?
			 */
			if (success)
			{
				__aligned struct BitMap temp_bitmap;
				WORD left, top;

				/* Centre the image.
				 */
				left = (width - image_width) / 2;
				top	= (height - image_height) / 2;

				/* Set up the drawer bitmap.
				 */
				InitBitMap(&temp_bitmap, depth, image_width, image_height);

				/* Put the mask into all bitplanes.
				 */
				if (image)
					for (i = 0 ; i < depth ; i++)
						temp_bitmap.Planes[i] = (PLANEPTR)image->ImageData;

				/* Manipulate the first bitmap.
				 */
				rport->BitMap = bitmap[0];

				/* Clear the bitmap.
				 */
				SetRast(rport, pi->pi_DrawInfo->dri_Pens[BACKGROUNDPEN]);

				if ((gad_kind == DRAWER_KIND) || (gad_kind == FILE_KIND))
				{
					UBYTE minterm, mask;

					/* Clear the drawer mask.
					 */
					minterm = 0x20;
					mask = (1 << depth) - 1;

					BltBitMap(&temp_bitmap, 0, 0,
							  bitmap[0], left, top,
							  image_width, image_height,
							  minterm, mask, NULL);

					minterm = 0xe0;
					mask = pi->pi_DrawInfo->dri_Pens[TEXTPEN];

					BltBitMap(&temp_bitmap, 0, 0,
							  bitmap[0], left, top,
							  image_width, image_height,
							  minterm, mask, NULL);
				}
				else if (gad_kind == IMAGEBUTTON_KIND)
				{
					if (image)
						DrawImage(rport, image, left, top);
				}
				/* Draw the button box.
				 */
				DrawBevelBox(rport, 0, 0, width, height,
					((readonly)? GTBB_Recessed : TAG_IGNORE), TRUE,
					GT_VisualInfo, pi->pi_VisualInfo,            
					TAG_DONE);

				/* Create the selected imagery.
				 */
				rport->BitMap = bitmap[1];

				if ((gad_kind == DRAWER_KIND) || (gad_kind == FILE_KIND))
				{
					/* Set the bitmap to the selected button colour.
					 */
					SetRast(rport, pi->pi_DrawInfo->dri_Pens[FILLPEN]);

					/* Clear the drawer mask.
					 */
					BltBitMap(&temp_bitmap, 0, 0,
							  bitmap[1], left, top,
							  image_width, image_height,
							  0x20, (1 << depth) - 1, NULL);

					/* Draw the drawer mask.
					 */
					BltBitMap(&temp_bitmap, 0, 0,
							  bitmap[1], left, top,
							  image_width, image_height,
							  0xe0, pi->pi_DrawInfo->dri_Pens[FILLTEXTPEN], NULL);
				}
				else if (gad_kind == IMAGEBUTTON_KIND)
				{
					if (image)
					{
						VOID *buffer=NULL;

						DrawImage(rport, image, left, top);

						/* if (buffer = AllocVec(width * height, MEMF_CHIP|MEMF_CLEAR))
						{
							struct TmpRas tmpras;

							InitTmpRas(&tmpras, buffer, width * height);
							rport->TmpRas = &tmpras;

							SetAPen(rport, pi->pi_DrawInfo->dri_Pens[FILLPEN]);

							Flood(rport, 1, 0, 0);

							FreeVec(buffer);
						} */
					}
				}
				/* Draw the selected button box.
				 */
				DrawBevelBox(rport, 0, 0, width, height,
					((!readonly)? GTBB_Recessed : TAG_IGNORE), TRUE,
					GT_VisualInfo, pi->pi_VisualInfo,            
					TAG_DONE);

				/* Allocate space for standard image and selected image.
				 */
				if (new_image = (struct Image *)AllocRemember(&(pi->pi_Remember), 2 * sizeof(struct Image), MEMF_CHIP | MEMF_CLEAR))
				{
					/* Fill in the standard data.
					 */
					for (i = 0 ; i <= 1 ; i++)
					{
						new_image[i].Width = width;
						new_image[i].Height = height;
						new_image[i].Depth = depth;
						new_image[i].ImageData = (UWORD *)bitmap[i]->Planes[0];
						new_image[i].PlanePick = (1 << depth) - 1;
					}
				}
				/* for (i = 0; i < 2; i++)
					FreeVec(bitmap[i]->Planes[0]); */
			}
		}
	}
	/* Free all memory.
	 */
	FreeRemember(&image_rem, TRUE);

	return(new_image);
}
