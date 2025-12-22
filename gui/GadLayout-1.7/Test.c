
/**
 **  Test.c -- An example of using the GadLayout dynamic gadget layout system.
 **
 **  By Timothy Aston, public domain.
 **
 **    A "do nothing" example that simpy creates a bunch of gadgets in a
 **    window and waits for the user to close the window.  The purpose is
 **    to demonstrate many of the features available in GadLayout for laying
 **    out gadgets.
 **
 **    I wanted to write a slightly more extensive demonstration of what
 **    GadLayout can do, this doesn't show a lot of what can be done.
 **
 **    Compiled using DICE 2.07.54: dcc Test.c gadlayout.o -o Test -r
 **
 **/

#include <exec/types.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>
#include <libraries/locale.h>
#include <utility/tagitem.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/locale_protos.h>
#include "gadlayout.h"
#include "gadlayout_protos.h"

#ifndef GTCB_Scaled
#define GTCB_Scaled GT_TagBase + 68
#endif

#define LEFT_OFFSET 6
#define TOP_OFFSET 4

struct Library *LocaleBase = NULL;	/* LocaleBase MUST be defined, even if
                                     * you don't use it!!! */
struct Screen *screen = NULL;
struct Window *win = NULL;
APTR gi = NULL;

UBYTE test_str[100];				/* Buffer for the string gadget */


/* Image data for an image button we will be defining.
 */
__chip UWORD image_data[64] =
{
	/* Plane 0 */
	0x0000,0x0000,
	0x0000,0x0000,
	0x001E,0x0000,
	0x0021,0x0000,
	0x0040,0x8000,
	0x0040,0x8000,
	0x0040,0x8000,
	0x0021,0x0000,
	0x007E,0x0000,
	0x00E0,0x0000,
	0x01C0,0x0000,
	0x0380,0x0000,
	0x0700,0x0000,
	0x0600,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	/* Plane 1 */
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0018,0x0000,
	0x0010,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000,
	0x0000,0x0000
};

struct Image image =
{
	0, 0, 22, 16, 2, &image_data[0], 0xff, 0x0, NULL
};


/* Here are the tag lists that define each gadget.  Note that a gadget
 * consists of a GadLayout tag list as well as a GadTools tag list (except
 * for the GadLayout extended gadget kinds).
 */

enum { GAD_BUTTON1, GAD_BUTTON2, GAD_BUTTON3, GAD_DRAWER, GAD_STRING,
		GAD_CHECKBOX };

struct TagItem button1_layout_tags[] =
{
	{ GL_GadgetKind, BUTTON_KIND },
	{ GL_GadgetText, "Button _1" },
	{ GL_Left, LEFT_OFFSET },
	{ GL_Top, TOP_OFFSET },
	{ GL_AutoHeight, 4 },
	{ GL_DupeWidth, GAD_BUTTON2 },
	{ GL_Flags, PLACETEXT_IN },
	{ TAG_DONE, NULL }
};

struct TagItem button1_gadtools_tags[] =
{
	{ GT_Underscore, '_' },
	{ TAG_DONE, NULL }
};

struct TagItem button2_layout_tags[] =
{
	{ GL_GadgetKind, BUTTON_KIND },
	{ GL_GadgetText, "And Button _2" },
	{ GL_AutoWidth, 10 },
	{ GL_AutoHeight, 4 },
	{ GL_TopRel, GAD_BUTTON1 },
	{ GL_AddTop, INTERHEIGHT },
	{ TAG_DONE, NULL }
};

struct TagItem button2_gadtools_tags[] =
{
	{ GT_Underscore, '_' },
	{ TAG_DONE, NULL }
};

struct TagItem button3_layout_tags[] =
{
	{ GL_GadgetKind, IMAGEBUTTON_KIND },
	{ GL_GadgetText, "Button _3" },
	{ GL_Width, 26 },
	{ GL_Height, 18 },
	{ GL_TopRel, GAD_BUTTON2 },
	{ GL_AddTop, INTERHEIGHT },
	{ GL_Flags, PLACETEXT_RIGHT },
	{ GLIM_Image, &image },
	{ TAG_DONE, NULL }
};

struct TagItem drawer_layout_tags[] =
{
	{ GL_GadgetKind, DRAWER_KIND },
	{ GL_GadgetText, "_Filename" },
	{ GL_Top, TOP_OFFSET },
	{ GL_LeftRel, GAD_BUTTON1 },
	{ GL_AdjustLeft, INTERWIDTH * 2},
	{ GL_Width, 20 },
	{ GL_AutoHeight, 4 },
	{ GL_Flags, PLACETEXT_LEFT },
	{ TAG_DONE, NULL }
};

struct TagItem string_layout_tags[] =
{
	{ GL_GadgetKind, STRING_KIND },
	{ GL_GadgetText, NULL },
	{ GL_Width, 100 },
	{ GL_LeftRel, GAD_DRAWER },
	{ TAG_DONE, NULL }
};

struct TagItem string_gadtools_tags[] =
{
	{ GTST_MaxChars, 100 },
	{ GTST_String, test_str },
	{ GT_Underscore, '_' },
	{ TAG_DONE, NULL }
};

struct TagItem checkbox_layout_tags[] =
{
	{ GL_GadgetKind, CHECKBOX_KIND },
	{ GL_GadgetText, "Checkbox" },
	{ GL_Width, 26 },
	{ GL_AutoHeight, 1 },
	{ GL_TopRel, GAD_DRAWER },
	{ GL_AddTop, INTERHEIGHT },
	{ GL_AlignRight, GAD_STRING },
	{ GL_Flags, PLACETEXT_LEFT },
	{ TAG_DONE, NULL }
};

struct TagItem checkbox_gadtools_tags[] =
{
	{ GTCB_Checked, TRUE },
	{ GTCB_Scaled, TRUE },
	{ GT_Underscore, '_' },
	{ TAG_DONE, NULL }
};


/* This structure describes all the gadgets we have just defined, so that
 * they can all be passed at once to the LayoutGadgets() function.
 */
struct LayoutGadget gadgets[] =
{
	{ GAD_BUTTON1,	button1_layout_tags,	button1_gadtools_tags,	NULL },
	{ GAD_BUTTON2,	button2_layout_tags,	button2_gadtools_tags,	NULL },
	{ GAD_BUTTON3,	button3_layout_tags,	NULL,					NULL },
	{ GAD_DRAWER,	drawer_layout_tags,		NULL,					NULL },
	{ GAD_STRING,	string_layout_tags,		string_gadtools_tags,	NULL },
	{ GAD_CHECKBOX,	checkbox_layout_tags,	checkbox_gadtools_tags,	NULL },
	{ -1, NULL, NULL, NULL }
};


main()
{
	struct Gadget *glist;
	WORD farright, farbottom;

	/* We'll just open up on the Workbench screen, and use its screen font.
	 * Try changing the screen font in your Font prefs to all sorts of
	 * ridiculous sizes and see how well this simple example adjust.
	 */
	if (screen = LockPubScreen("Workbench"))
	{
		if (gi = LayoutGadgets(&glist, gadgets, screen,
			GL_RightExtreme, &farright,
			GL_LowerExtreme, &farbottom,
			GL_DefTextAttr, screen->Font,
			TAG_DONE))
		{
			/* Open the window, note how we size the window to perfectly fit
			 * all the gadgets.
			 */
			if (win = OpenWindowTags(NULL,
				WA_Left, 0,
				WA_Top, screen->Font->ta_YSize + 3,
				WA_InnerWidth, farright + LEFT_OFFSET,
				WA_InnerHeight, farbottom + TOP_OFFSET,
				WA_IDCMP, BUTTONIDCMP | STRINGIDCMP | IDCMP_REFRESHWINDOW |
							IDCMP_CLOSEWINDOW,
				WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
							WFLG_ACTIVATE | WFLG_SMART_REFRESH |
							WFLG_GIMMEZEROZERO,
				WA_Gadgets, glist,
				WA_Title, "GadLayout Test",
				TAG_DONE))
			{
				struct IntuiMessage *imsg;
				BOOL ok = TRUE;

				/* printf("Button 1 key command: %c\n", GadgetKeyCmd(gi, GAD_BUTTON1, gadgets));
				printf("Button 2 key command: %c\n", GadgetKeyCmd(gi, GAD_BUTTON2, gadgets));
				printf("Drawer key command: %c\n", GadgetKeyCmd(gi, GAD_DRAWER, gadgets));
				printf("String key command: %c\n", GadgetKeyCmd(gi, GAD_STRING, gadgets));
				printf("Checkbox key command: %c\n", GadgetKeyCmd(gi, GAD_CHECKBOX, gadgets)); */

				/* Just wait around until the close gadget is pressed.
				 */
				while (ok)
				{
					WaitPort(win->UserPort);
					while (imsg = GT_GetIMsg(win->UserPort))
					{
						if (imsg->Class == IDCMP_CLOSEWINDOW)
							ok = FALSE;
						GT_ReplyIMsg(imsg);
					}
				}
				CloseWindow(win);
			}
			else
				PutStr("ERROR: Couldn't open window\n");

			FreeLayoutGadgets(gi);
		}
		else
			PutStr("ERROR: Couldn't layout gadgets\n");

	    UnlockPubScreen(0, screen);
	}
	else
		PutStr("ERROR: Couldn't lock public screen\n");
}
