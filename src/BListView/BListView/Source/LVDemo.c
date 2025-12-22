/*	$VER: ListViewDemo 1.5 (14.9.97) by Bernardo Innocenti
**
**
**	Introduction
**	============
**
**	This program demonstrates how to use the `boopsi' ListView gadget.
**
**	The source code shows how to create a resizable window with sliders
**	and how to write a custom `boopsi' class on top of the gadgetclass.
**
**
**	Compiling
**	=========
**
**	This project can be compiled with SAS/C 6.58 or better and
**	GeekGadget's GCC 2.7.2.1 or better.
**	You get the smallest executable with SAS/C. GCC will give
**	you quite a lot of warnings with the tag calls. Don't worry about them.
**
**
**	History
**	=======
**
**	0.1 (23.6.96)	First try
**	1.0 (21.1.97)	First alpha release
**	1.1 (24.5.97)	Lotsa bugs fixed, implemented LVA_DoubleClick
**	1.2 (31.8.97)	Lotsa bugs fixed, implemented LVA_Clipped
**					Fixed memory leak with the test list
**	1.3 (5.9.97)	Improved initial sliders notification
**					Added multiple selection (LVA_DoMultiselect)
**					Fixed scrolling problems in some unusual conditions
**	1.4	(8.9.97)	Sets GMORE_SCROLLRASTER in OM_NEW
**					Multiple demo windows showing the features of the class
**	1.5 (14.9.97)	Added LVA_ItemSpacing
**					Finally fixed the LVA_Clipped mode!
**
**	1.6 (2.10.97)	Added StormC support
**					Implemented pixel-wise vertical scrolling for clipped mode
**					Reworked the class istance data and some code
**
**
**	Known Bugs
**	==========
**
**		- This code has never been tested on V37.
**
**		- Middle mouse button scrolling does not work because
**		  of a bug in input.device V40.
**
**
**	Copyright Notice
**	================
**
**	Copyright © 1996,97 by Bernardo Innocenti <bernie@shock.cosmos.it>.
**	Freely Distributable, as long as source code, documentation and
**	executable are kept together.  Permission is granted to release
**	modified versions of this program as long as all existing copyright
**	notices are left intact.
**
*/

#define USE_BUILTIN_MATH
#define INTUI_V36_NAMES_ONLY
#define __USE_SYSBASE
#define  CLIB_ALIB_PROTOS_H	/* Avoid including this header file because of
							 * conflicting definitions in BoopsiStubs.h
							 */
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>

#include <dos/dos.h>

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <devices/timer.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>

#ifdef __STORM__
	#pragma header
#endif


#include "CompilerSpecific.h"
#include "Debug.h"
#include "BoopsiStubs.h"
#include "ListMacros.h"

#include "ListViewClass.h"
#include "ListBoxClass.h"
#include "VectorGlyphIClass.h"


/* OS version */

#ifdef OS30_ONLY
 #define WANTEDLIBVER	39L
#else
 #define WANTEDLIBVER	37L
#endif



/* Local function prototypes */

LONG SAVEDS					 main				(void);
static struct MsgPort		*OpenDemoWindows	(struct List *winlist);
static void					 CloseDemoWindows	(struct List *winlist);
static struct LVHandle		*OpenLVWin			(UBYTE *pubscreen,
	struct MsgPort *winport, STRPTR title, ULONG mode,
	ULONG left, ULONG top, ULONG width, ULONG height, ULONG moreTags, ...);
static void					 CloseLVWin			(struct LVHandle *lvhandle);
static struct Gadget		*CreateGadgets		(struct LVHandle *lvhandle,
	struct TagItem *moreTags);
static void					 DisposeGadgets		(struct LVHandle *lvhandle);
static void					 CreateItems		(struct LVHandle *lvhandle);
static void					 CreateImages		(struct DrawInfo *dri);
static void					 FreeImages			(void);
static Class 				*MakeScrollButtonClass	(void);
static BOOL					 FreeScrollButtonClass	(Class *cl);
static struct ClassLibrary	*OpenClass			(STRPTR name, ULONG version);


/* Gadgets IDs */
enum
{
	GAD_LV, GAD_VSLIDER, GAD_HSLIDER,
	GAD_UPBUTTON, GAD_DOWNBUTTON, GAD_LEFTBUTTON, GAD_RIGHTBUTTON,
	GAD_COUNT
};


/* Images IDs */
enum
{
	IMG_UP, IMG_DOWN, IMG_LEFT, IMG_RIGHT, IMG_COUNT
};




/* This structure describes an open ListView window */
struct LVHandle
{
	struct MinNode	 Link;			/* Link LVHandle in a list of all windows	*/
	struct Window	*Win;			/* Pointer to our window					*/
	struct Screen	*Scr;			/* The screen we are opening our windows on	*/
	struct DrawInfo	*DrawInfo;		/* DrawInfo for this screen 				*/
	ULONG			 Mode;			/* ListView operating mode					*/
	APTR			 Items;			/* Items attached to the ListView			*/
	ULONG			 Total;			/* Number of items or -1 if unknown			*/
	struct Gadget	*Gad[GAD_COUNT];/* All our gadgets							*/
	APTR			 Model;			/* Make boopsi gadgets talk to each other	*/
	struct List		 TestList;		/* Items list for LVA_#?List modes			*/
	ULONG			*SelectArray;	/* Array for storing multiple selections	*/
};



/* Version tag */

UBYTE versiontag[] = "$VER: ListViewDemo 1.5 (24.9.97) by Bernardo Innocenti"
	" (compiled with " _COMPILED_WITH ")";



/* Workaround a bug in StormC header file <proto/utility.h> */

#ifdef __STORM__
	#define UTILITYBASETYPE struct Library
#else
	#define UTILITYBASETYPE struct UtilityBase
#endif

/* Library bases */
struct ExecBase				*SysBase;
UTILITYBASETYPE				*UtilityBase;
struct IntuitionBase		*IntuitionBase;
struct GfxBase				*GfxBase;
struct Library				*LayersBase;
struct Library				*DiskfontBase;


/* Our private `boopsi' classes */
Class						*ListViewClass;
static Class				*ListBoxClass;
static Class				*ScrollButtonClass;
static struct ClassLibrary	*VectorGlyphBase;


/* `boopsi' images for all windows
 *
 * These variables must be NULL at startup time. We are not
 * going to explicitly initialize them because otherwise
 * Storm C 2.0 would generate a C++-style constructor to
 * do it :-).  LoasSeg() will clear the BSS data section
 * for us, so these variables are guaranteed to be NULL anyway.
 */
static struct Image		*Img[IMG_COUNT];
static ULONG			 ImgWidth[IMG_COUNT];
static ULONG			 ImgHeight[IMG_COUNT];
static struct TextFont	*CustomFont;



/* Attribute translations for object interconnections */

static LONG MapLVToHSlider[] =
{
	LVA_PixelLeft,		PGA_Top,
	LVA_PixelWidth,		PGA_Total,
	LVA_PixelHVisible,	PGA_Visible,
	TAG_DONE
};

static LONG MapHSliderToLV[] =
{
	PGA_Top,			LVA_PixelLeft,
	TAG_DONE
};

/*
static LONG MapLVToVSlider[] =
{
	LVA_Top,			PGA_Top,
	LVA_Total,			PGA_Total,
	LVA_Visible,		PGA_Visible,
	TAG_DONE
};
*/

static LONG MapLVToVSlider[] =
{
	LVA_PixelTop,		PGA_Top,
	LVA_PixelHeight,	PGA_Total,
	LVA_PixelVVisible,	PGA_Visible,
	TAG_DONE
};


/*
static LONG MapVSliderToLV[] =
{
	PGA_Top,	LVA_Top,
	TAG_DONE
};
*/

static LONG MapVSliderToLV[] =
{
	PGA_Top,	LVA_PixelTop,
	TAG_DONE
};



static LONG MapUpButtonToLV[] =
{
	GA_ID,		LVA_MoveUp,
	TAG_DONE
};

static LONG MapDownButtonToLV[] =
{
	GA_ID,		LVA_MoveDown,
	TAG_DONE
};

static LONG MapLeftButtonToLV[] =
{
	GA_ID,		LVA_MoveLeft,
	TAG_DONE
};

static LONG MapRightButtonToLV[] =
{
	GA_ID,		LVA_MoveRight,
	TAG_DONE
};



/* Test Strings */

/* StormC does not see that the expression "versiontag + 6" is constant
 * and generates an initializer for it. The following definition
 * works around this problem.
 */
#ifdef __STORM__
	#define VERSIONTAG "ListViewDemo 1.4 by Bernardo Innocenti (compiled with " _COMPILED_WITH ")"
#else
	#define VERSIONTAG versiontag + 6
#endif

static STRPTR TestStrings[] =
{
	VERSIONTAG,
	NULL,
	"This `boopsi' ListView class supports all the features",
	"of the Gadtools LISTVIEW_KIND, plus more stuff:",
	NULL,
	" + Easy to use (almost a drop-in replacement for LISTVIEW_KIND)",
	" + Can be resized and supports GREL_#? flags",
	" + Multiple selection of items",
	" + Notifies your `boopsi' sliders",
	" + Multiple columns (TODO)",
	" + Redraws quickly without clearing (which is good for solid window sizing)",
	" + Horizontal scrolling (TODO)",
	" + Items with `boopsi' images",
	" + Using arrays instead of exec lists",
	" + You can use `boopsi' label images instead of plain text",
	" + You can use your own custom rendering hook",
	" + You can use your own item item-retriving callback hook",
	" + List title (TODO)",
	" + Full Keyboard control (all control, alt and shift key combinations supported)",
	" + Asynchronous scrolling with inertia (TODO)",
	" + OS 3.0 optimized (V39-only version also available)",
	" + RTG friendly and optimized (no planar stuff in chunky bitmaps)",
	" + Small code! (<10K)",
	" + Written in C to be highly portable across compilers and CPUs",
	" + Full commented source code included",
	" + Source code compiles with SAS/C, StormC and GCC",
	" + Subclasses can be easlily derived from the base listview class",
	NULL,
	"Please send comments to <bernie@shock.cosmos.it>."
};

#define TESTSTRINGS_CNT (sizeof (TestStrings) / sizeof (STRPTR))



LONG SAVEDS _main (void)

/* Main program entry point.  When linking without startup code, this
 * must be the first function in the first object module listed on the
 * linker command line.  We also need to initialize SysBase and open
 * all needed libraries manually.
 */
{
	struct MinList	 winlist;
	struct MsgPort	*winport;
	LONG			 sigwait, sigrcvd;
	LONG			 retval	= RETURN_FAIL;	/* = RETURN_FAIL */
	BOOL			 quit	= FALSE;


	/* Initialize SysBase */
	SysBase = *((struct ExecBase **)4UL);

	/* Open system libraries */

	if ((UtilityBase = (UTILITYBASETYPE *) OpenLibrary ("utility.library", 37L)) &&
		(IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library", WANTEDLIBVER)) &&
		(GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library", WANTEDLIBVER)) &&
		(LayersBase = OpenLibrary ("layers.library", WANTEDLIBVER)))
	{
		if ((ListViewClass = MakeListViewClass ()) &&
			(ListBoxClass = MakeListBoxClass ()) &&
			(ScrollButtonClass = MakeScrollButtonClass ()) &&
			(VectorGlyphBase = OpenClass ("vectorglyph.image", 0)))
		{
			NEWLIST ((struct List *)&winlist);

			if (winport = OpenDemoWindows ((struct List *)&winlist))
			{
				/* Pre-calculate the signal mask for Wait() */
				sigwait = (1 << winport->mp_SigBit) |
					SIGBREAKF_CTRL_C;

				/* Now for the main loop.  As you can see, it is really
				 * very compact.  That's the magic of boopsi! :-)
				 */
				while (!quit)
				{
					/* Sleep until something interesting occurs */
					sigrcvd = Wait (sigwait);

					/* Now handle received signals */

					/* Break signal? */
					if (sigrcvd & SIGBREAKF_CTRL_C)
						quit = TRUE;

					/* IDCMP message? */
					if (sigrcvd & (1 << winport->mp_SigBit))
					{
						struct IntuiMessage	*msg;

						while (msg = (struct IntuiMessage *) GetMsg (winport))
						{
							switch (msg->Class)
							{
								case IDCMP_CLOSEWINDOW:
									quit = TRUE;
									break;

								default:
									break;
							}
							ReplyMsg ((struct Message *) msg);
						}
					}
				} /* End while (!quit) */

				retval = 0;	/* RETURN_OK */

				CloseDemoWindows ((struct List *)&winlist);
			}

			FreeImages ();
		}

		/* These cannot fail. Passing NULL is ok. */
		CloseLibrary ((struct Library *)VectorGlyphBase);
		FreeScrollButtonClass (ScrollButtonClass);
		FreeListBoxClass (ListBoxClass);
		FreeListViewClass (ListViewClass);
	}

	/* Passing NULL to CloseLibrary() was illegal in pre-V37 Exec.
	 * To avoid crashing when someone attempts to run this program
	 * on an old OS, we need to test the first library base we tried
	 * to open.
	 */
	if (UtilityBase)
	{
		CloseLibrary ((struct Library *)LayersBase);
		CloseLibrary ((struct Library *)GfxBase);
		CloseLibrary ((struct Library *)IntuitionBase);
		CloseLibrary ((struct Library *)UtilityBase);
	}

	return retval;
}



static struct MsgPort *OpenDemoWindows (struct List *winlist)
{
	struct LVHandle	*lvhandle;
	struct MsgPort	*winport;

	if (DiskfontBase = OpenLibrary ("diskfont.library", 0L))
	{
		static struct TextAttr attr =
		{
			"times.font",
			24,
			FSB_ITALIC,
			0
		};

		CustomFont = OpenDiskFont (&attr);
		CloseLibrary (DiskfontBase);
	}

	/* Setup windows shared Message Port */
	if (winport = CreateMsgPort())
	{
		if (lvhandle = OpenLVWin (NULL, winport,
			"LVA_TextFont = times/24/italic, LVA_Clipped = TRUE", LVA_StringList,
			320, 320, 320, 64,
			LVA_TextFont,		CustomFont,
			LVA_Clipped,		TRUE,
			TAG_DONE))
			ADDTAIL (winlist, (struct Node *)lvhandle);

		if (lvhandle = OpenLVWin (NULL, winport,
			"LAYOUTA_Spacing = 4", LVA_StringList,
			256, 256, 320, 64,
			LAYOUTA_Spacing,	4,
			TAG_DONE))
			ADDTAIL (winlist, (struct Node *)lvhandle);

		if (lvhandle = OpenLVWin (NULL, winport,
			"GA_ReadOnly = TRUE; LVA_Selected = 3", LVA_StringList,
			192, 192, 320, 64,
			GA_ReadOnly,		TRUE,
			LVA_Selected,		3,
			TAG_DONE))
			ADDTAIL (winlist, (struct Node *)lvhandle);

		if (lvhandle = OpenLVWin (NULL, winport,
			"Single selection image list, LVA_Clipped = TRUE", LVA_ImageList,
			128, 128, 320, 128,
			LVA_ItemHeight,		32,
			LVA_Clipped,		TRUE,
			TAG_DONE))
			ADDTAIL (winlist, (struct Node *)lvhandle);

		if (lvhandle = OpenLVWin (NULL, winport,
			"LVA_DoMultiSelect = TRUE; LVA_StringArray", LVA_StringArray,
			64, 64, 320, 128,
			LVA_DoMultiSelect,	TRUE,
			TAG_DONE))
			ADDTAIL (winlist, (struct Node *)lvhandle);

		if (lvhandle = OpenLVWin (NULL, winport,
			"Plain, single selection string list", LVA_StringList,
			0, 20, 320, 128,
			TAG_DONE))
			ADDTAIL (winlist, (struct Node *)lvhandle);

		/* Abort only if no windows could be opened */
		if (IsListEmpty (winlist))
		{
			DeleteMsgPort (winport);
			CloseFont (CustomFont);
			return NULL;
		}
	}

	return winport;
}



static void CloseDemoWindows (struct List *winlist)
{
	struct MsgPort	*winport = NULL;
	struct LVHandle	*lvhandle;

	while (lvhandle = (struct LVHandle *) REMHEAD (winlist))
	{
		/* Safe way to close a shared IDCMP port window */

		Forbid();
		{
			struct Node *succ;
			struct Message *msg;

			winport = lvhandle->Win->UserPort;
			msg = (struct Message *) winport->mp_MsgList.lh_Head;

			/* Now remove any pending message from the shared IDCMP port */
			while (succ = msg->mn_Node.ln_Succ)
			{
				/* Since we are closing all our windows at once,
				 * we don't need to check to which window this
				 * message was addressed.
				 */
				REMOVE ((struct Node *)msg);
				ReplyMsg (msg);
				msg = (struct Message *) succ;
			}

			/* Keep intuition from freeing our port... */
			lvhandle->Win->UserPort = NULL;

			/* ...and from sending us any more messages. */
			ModifyIDCMP (lvhandle->Win, 0L);
		}
		Permit();

		CloseLVWin (lvhandle);
	}

	DeleteMsgPort (winport); /* NULL is ok */

	if (CustomFont)
		CloseFont (CustomFont);
}



/* No-op backfilling hook.  Since we are going to redraw the whole window
 * anyway, we can disable backfilling.  This avoids ugly flashing while
 * resizing or revealing the window.
 *
 * This function does not need the __saveds attribute because it makes no
 * references to external data.
 */

#ifndef OS30_ONLY

static ULONG BFHookFunc (void)
{
	return 1;	/* Do nothing */
}

static struct Hook BFHook =
{
	NULL, NULL,
	(ULONG(*)())BFHookFunc,
};

#endif /* !OS30_ONLY */



static struct LVHandle *OpenLVWin (UBYTE *pubscreen,
	struct MsgPort *winport, STRPTR title, ULONG mode,
	ULONG left, ULONG top, ULONG width, ULONG height, ULONG moreTags, ...)
{
	struct LVHandle	*lvhandle;
	struct Gadget	*glist;

	if (lvhandle = AllocMem (sizeof (struct LVHandle), MEMF_ANY | MEMF_CLEAR))
	{
		if (lvhandle->Scr = LockPubScreen (pubscreen))
		{
			/* GetScreenDrawInfo() never fails */
			lvhandle->DrawInfo = GetScreenDrawInfo (lvhandle->Scr);

			/* Set listview operating mode */
			lvhandle->Mode = mode;

			CreateItems (lvhandle);

			if (glist = CreateGadgets (lvhandle, (struct TagItem *)&moreTags))
			{

/* I'm using this define because GCC does not support putting
 * preprocessor directives (#ifdef/#endif) inside macro arguments.
 */
#ifndef OS30_ONLY
 #define BACKFILL_TAG_VALUE	(IntuitionBase->LibNode.lib_Version < 39) ? &BFHook : LAYERS_NOBACKFILL
#else
 #define BACKFILL_TAG_VALUE	LAYERS_NOBACKFILL
#endif /* !OS30_ONLY */

				if (lvhandle->Win = OpenWindowTags (NULL,
					WA_Top,				top,
					WA_Left,			left,
					WA_InnerWidth,		width,
					WA_InnerHeight,		height,
					WA_PubScreen,		lvhandle->Scr,
					WA_Gadgets,			glist,
					WA_Title,			title,
					WA_BackFill,		BACKFILL_TAG_VALUE,
					WA_ScreenTitle,		versiontag + 6,
					WA_Flags,			WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SIZEGADGET | WFLG_SIZEBRIGHT | WFLG_SIZEBBOTTOM |
										WFLG_CLOSEGADGET | WFLG_SIMPLE_REFRESH | WFLG_NOCAREREFRESH,
					WA_PubScreenFallBack, TRUE,
					WA_AutoAdjust,		TRUE,
					WA_MinWidth,		64,
					WA_MinHeight,		64,
					WA_MaxWidth,		-1,
					WA_MaxHeight,		-1,
					TAG_DONE))
#undef BACKFILL_TAG_VALUE
				{
					lvhandle->Win->UserPort = winport;
					ModifyIDCMP (lvhandle->Win, IDCMP_CLOSEWINDOW);

					/* We need to keep our screen locked all the time
					 * because we want to free the associated DrawInfo
					 * *after* the window has been closed and
					 * FreeScreenDrawInfo() wants a pointer to a *valid*
					 * Screen.
					 */
					return lvhandle;
				}

				DisposeGadgets (lvhandle);
			}

			FreeScreenDrawInfo (lvhandle->Scr, lvhandle->DrawInfo);
			/* lvhandle->DrawInfo = NULL */

			UnlockPubScreen (NULL, lvhandle->Scr);
		}
		FreeMem (lvhandle, sizeof (struct LVHandle));
	}
	return NULL;
}



static void CloseLVWin (struct LVHandle *lvhandle)
{
	/* Close our window. No need to reply queued messages,
	 * Intuition is clever enough to care about this for us.
	 */
	CloseWindow (lvhandle->Win);
	DisposeGadgets (lvhandle);
	UnlockPubScreen (NULL, lvhandle->Scr);

	FreeVec (lvhandle->SelectArray); /* NULL is ok */

	if ((lvhandle->Mode == LVA_StringList) || (lvhandle->Mode == LVA_ImageList))
	{
		struct Node *node;

		/* Free the test list */
		while (node = REMHEAD (&lvhandle->TestList))
		{
			if (lvhandle->Mode == LVA_ImageList)
				DisposeObject ((Object *)node->ln_Name);
			FreeMem (node, sizeof (struct Node));
		}
	}

	FreeMem (lvhandle, sizeof (struct LVHandle));
}



/*	Diagram of object interconnections
 *	==================================
 *
 *	           ScrollButtonClass objects
 *	+----------+ +------------+ +------------+ +-------------+
 *	| UpButton | | DownButton | | LeftButton | | RightButton |
 *	+----------+ +------------+ +------------+ +-------------+
 *	 | GA_ID =     | GA_ID =       | GA_ID =       | GA_ID =
 *	 | LVA_MoveUp  | LVA_MoveDown  | LVA_MoveLeft  | LVA_MoveRight
 *	 |             |               |               |
 *	 |  +----------+               |               |
 *	 |  |  +-----------------------+               |
 *	 |  |  |  +------------------------------------+
 *	 |  |  |  |        propgclass object     icclass object
 *	 |  |  |  |          +-----------+      +--------------+
 *	 |  |  |  |          |  HSlider  |<-----| PIPToHSlider |
 *	 |  |  |  |          +-----------+      +--------------+
 *	 |  |  |  |     PGA_Top =  |                 ^ LVA_Top  = PGA_Top
 *	 |  |  |  |     LVA_Left   |                 | LVA_Visible = PGA_Visible
 *	 |  |  |  |                |                 |
 *	 V  V  V  V                V                 |
 *	+-----------+         ***********            |
 *	|           |-------->*         *------------+
 *	| ListView  |         *  Model  *
 *	|           |<--------*         *------------+
 *	+-----------+         ***********            |
 *	                           ^                 |
 *	               PGA_Top =   |                 |
 *	               LVA_Top     |                 V  icclass object
 *	                     +-----------+      +--------------+
 *	                     |  VSlider  |<-----| PIPToVSlider |
 *	                     +-----------+      +--------------+
 *	                   propgclass object     LVA_Top     = PGA_Top
 *	                                         LVA_Visible = PGA_Visible
 */

static struct Gadget *CreateGadgets (struct LVHandle *lvhandle,
	struct TagItem *moreTags)
{
	struct DrawInfo	*dri = lvhandle->DrawInfo;
	struct Screen	*scr = lvhandle->Scr;
	ULONG SizeWidth = 18, SizeHeight = 11;	/* Default size */
	struct Image	*SizeImage;

	/* Create a new size image to get its size */
	if (SizeImage = NewObject (NULL, SYSICLASS,
		SYSIA_Which,	SIZEIMAGE,
		SYSIA_DrawInfo,	dri,
		TAG_DONE))
	{
		/* Get size gadget geometry */
		GetAttr (IA_Width, SizeImage, &SizeWidth);
		GetAttr (IA_Height, SizeImage, &SizeHeight);

		/* And then get rid of it... */
		DisposeObject (SizeImage);
	}

	/* No need to check this: in case of failure we would just
	 * get no images in the scroll buttons, but we can still try
	 * to open our window.
	 */
	CreateImages (dri);

	if (lvhandle->Model = NewObjectA (NULL, MODELCLASS, NULL))
		if (lvhandle->Gad[GAD_LV] = NewObject (ListViewClass, NULL,
			GA_ID,				GAD_LV,
			GA_Left,			scr->WBorLeft,
			GA_Top,				scr->WBorTop + scr->Font->ta_YSize + 1,
			GA_RelWidth,		- SizeWidth - scr->WBorLeft,
			GA_RelHeight,		- (scr->WBorTop + scr->Font->ta_YSize + SizeHeight + 1),
			GA_DrawInfo,		dri,
			ICA_TARGET,			lvhandle->Model,
			lvhandle->Mode,		lvhandle->Items,
			LVA_Total,			lvhandle->Total,
			LVA_SelectArray,	lvhandle->SelectArray,
			TAG_MORE,			moreTags))
			if (lvhandle->Gad[GAD_VSLIDER] = NewObject (NULL, PROPGCLASS,
				GA_ID,			GAD_VSLIDER,
				GA_Previous,	lvhandle->Gad[GAD_LV],
				GA_RelRight,	- SizeWidth + 5,
				GA_Top,			scr->WBorTop + scr->Font->ta_YSize + 2,
				GA_Width,		SizeWidth - 8,
				GA_RelHeight,	- (scr->WBorTop + scr->Font->ta_YSize +
								SizeHeight + ImgHeight[IMG_DOWN] + ImgHeight[IMG_UP] + 4),
				GA_RightBorder,	TRUE,
				GA_DrawInfo,	dri,
				PGA_Freedom,	FREEVERT,
				PGA_Borderless,	((dri->dri_Flags & DRIF_NEWLOOK) && (dri->dri_Depth != 1)),
				PGA_NewLook,	TRUE,
				ICA_TARGET,		lvhandle->Model,
				ICA_MAP,		MapVSliderToLV,
				TAG_DONE))
				if (lvhandle->Gad[GAD_HSLIDER] = NewObject (NULL, PROPGCLASS,
					GA_ID,			GAD_HSLIDER,
					GA_Previous,	lvhandle->Gad[GAD_VSLIDER],
					GA_RelBottom,	- SizeHeight + ((SizeHeight > 15) ? 4 : 3),
					GA_Left,		scr->WBorLeft,
					GA_Height,		SizeHeight - ((SizeHeight > 15)  ? 6 : 4),
					GA_RelWidth,	- (SizeWidth + ImgWidth[IMG_RIGHT] + ImgWidth[IMG_LEFT] + scr->WBorLeft + 2),
					GA_BottomBorder,TRUE,
					GA_DrawInfo,	dri,
					PGA_Freedom,	FREEHORIZ,
					PGA_Borderless,	((dri->dri_Flags & DRIF_NEWLOOK) && (dri->dri_Depth != 1)),
					PGA_NewLook,	TRUE,
					ICA_TARGET,		lvhandle->Model,
					ICA_MAP,		MapHSliderToLV,
					TAG_DONE))
					if (lvhandle->Gad[GAD_UPBUTTON] = NewObject (ScrollButtonClass, NULL,
						GA_ID,			GAD_UPBUTTON,
						GA_Previous,	lvhandle->Gad[GAD_HSLIDER],
						GA_RelBottom,	- SizeHeight - ImgHeight[IMG_DOWN] - ImgHeight[IMG_UP] + 1,
						GA_RelRight,	- ImgWidth[IMG_DOWN] + 1,
						GA_RightBorder,	TRUE,
						GA_DrawInfo,	dri,
						GA_Image,		Img[IMG_UP],
						ICA_TARGET,		lvhandle->Gad[GAD_LV],
						ICA_MAP,		MapUpButtonToLV,
						TAG_DONE))
						if (lvhandle->Gad[GAD_DOWNBUTTON] = NewObject (ScrollButtonClass, NULL,
							GA_ID,			GAD_DOWNBUTTON,
							GA_Previous,	lvhandle->Gad[GAD_UPBUTTON],
							GA_RelBottom,	- SizeHeight - ImgHeight[IMG_DOWN] + 1,
							GA_RelRight,	- ImgWidth[IMG_DOWN] + 1,
							GA_RightBorder,	TRUE,
							GA_DrawInfo,	dri,
							GA_Image,		Img[IMG_DOWN],
							ICA_TARGET,		lvhandle->Gad[GAD_LV],
							ICA_MAP,		MapDownButtonToLV,
							TAG_DONE))
							if (lvhandle->Gad[GAD_LEFTBUTTON] = NewObject (ScrollButtonClass, NULL,
								GA_ID,			GAD_LEFTBUTTON,
								GA_Previous,	lvhandle->Gad[GAD_DOWNBUTTON],
								GA_RelBottom,	- ImgHeight[IMG_LEFT] + 1,
								GA_RelRight,	- SizeWidth - ImgWidth[IMG_RIGHT] - ImgWidth[IMG_LEFT] + 1,
								GA_BottomBorder,TRUE,
								GA_DrawInfo,	dri,
								GA_Image,		Img[IMG_LEFT],
								ICA_TARGET,		lvhandle->Gad[GAD_LV],
								ICA_MAP,		MapLeftButtonToLV,
								TAG_DONE))
								if (lvhandle->Gad[GAD_RIGHTBUTTON] = NewObject (ScrollButtonClass, NULL,
									GA_ID,			GAD_RIGHTBUTTON,
									GA_Previous,	lvhandle->Gad[GAD_LEFTBUTTON],
									GA_RelBottom,	- ImgHeight[IMG_RIGHT] + 1,
									GA_RelRight,	- SizeWidth - ImgWidth[IMG_RIGHT] + 1,
									GA_BottomBorder,TRUE,
									GA_DrawInfo,	dri,
									GA_Image,		Img[IMG_RIGHT],
									ICA_TARGET,		lvhandle->Gad[GAD_LV],
									ICA_MAP,		MapRightButtonToLV,
									TAG_DONE))
									{
										APTR icobject;

										/* Connect VSlider to Model */

										if (icobject = NewObject (NULL, ICCLASS,
											ICA_TARGET,	lvhandle->Gad[GAD_VSLIDER],
											ICA_MAP,	MapLVToVSlider,
											TAG_DONE))
											if (!DoMethod (lvhandle->Model, OM_ADDMEMBER, icobject))
												DisposeObject (icobject);

										/* Connect HSlider to Model */

										if (icobject = NewObject (NULL, ICCLASS,
											ICA_TARGET,	lvhandle->Gad[GAD_HSLIDER],
											ICA_MAP,	MapLVToHSlider,
											TAG_DONE))
											if (!DoMethod (lvhandle->Model, OM_ADDMEMBER, icobject))
												DisposeObject (icobject);

										/* Connect Model to ListView */

										SetAttrs (lvhandle->Model,
											ICA_TARGET, lvhandle->Gad[GAD_LV],
											TAG_DONE);

										return lvhandle->Gad[GAD_LV];
									}
	DisposeGadgets (lvhandle);

	return NULL;
}



static void DisposeGadgets (struct LVHandle *lvhandle)
{
	ULONG i;

	for (i = 0; i < GAD_COUNT; i++)
	{
		DisposeObject (lvhandle->Gad[i]);
		/* lvhandle->Gad[i] = NULL; */
	}

	/* Freeing the Model will also free its two targets */
	DisposeObject (lvhandle->Model);
	/* lvhandle->Model = NULL */
}



static void CreateItems (struct LVHandle *lvhandle)
{
	if ((lvhandle->Mode == LVA_StringList) || (lvhandle->Mode == LVA_ImageList))
	{
		struct Node		*node;
		ULONG			 i, cnt;


		if (lvhandle->Mode == LVA_StringList)
			cnt = TESTSTRINGS_CNT;
		else /* LVA_ImageList */
			cnt = VG_IMGCOUNT * 8;


		/* Build a list of nodes to test the list */

		NEWLIST (&lvhandle->TestList);

		for (i = 0; i < cnt; i++)
		{
			if (node = AllocMem (sizeof (struct Node), MEMF_PUBLIC))
			{
				if (lvhandle->Mode == LVA_StringList)
					node->ln_Name = TestStrings[i];
				else
					node->ln_Name = (STRPTR) NewObject (NULL, VECTORGLYPHCLASS,
						SYSIA_Which,	i % VG_IMGCOUNT,
						SYSIA_DrawInfo,	lvhandle->DrawInfo,
						IA_Width,		48,
						IA_Height,		32,
						TAG_DONE);

				/* Unselect all items */
				node->ln_Type = 0;

				ADDTAIL (&lvhandle->TestList, node);

				lvhandle->Total++;
			}
		}

		lvhandle->Items = &lvhandle->TestList;
	}
	else if (lvhandle->Mode == LVA_StringArray)
	{
		lvhandle->Items = TestStrings;
		lvhandle->Total = TESTSTRINGS_CNT;
		lvhandle->SelectArray = AllocVec (TESTSTRINGS_CNT * sizeof (ULONG),
			MEMF_CLEAR | MEMF_PUBLIC);
	}
	else /* (lvhandle->Mode == LVA_ImageArray) */
	{
		lvhandle->Items = NULL;	/* No items	*/
		lvhandle->Total = -1;	/* Unknown	*/
	}
}



static void CreateImages (struct DrawInfo *dri)

/* Create 4 arrow images for the window scrolling buttons.
 *
 * Why bother checking for failure? The arrow images are not
 * life critical in our program...
 */
{
	static ULONG imagetypes[IMG_COUNT] = { UPIMAGE, DOWNIMAGE, LEFTIMAGE, RIGHTIMAGE };
	ULONG i;

	for (i = 0; i < IMG_COUNT; i++)
		if (!Img[i])
			if (Img[i] = (struct Image *)NewObject (NULL, SYSICLASS,
				SYSIA_Which,	imagetypes[i],
				SYSIA_DrawInfo,	dri,
				TAG_DONE))
			{
				/* Ask image width and height */
				GetAttr (IA_Width, Img[i], &ImgWidth[i]);
				GetAttr (IA_Height, Img[i], &ImgHeight[i]);
			}
}



static void FreeImages (void)
{
	ULONG i;

	for (i = 0; i < IMG_COUNT; i++)
		DisposeObject ((APTR)Img[i]);	/* DisposeObject(NULL) is safe */
}



/*	ScrollButtonClass
**
**	This code is inspierd from ScrollerWindow 0.3
**	Copyright © 1994 Christoph Feck, TowerSystems.
**
**	Subclass of buttongclass.  The ROM class has two problems, which make
**	it not quite usable for scrollarrows.  The first problem is the missing
**	delay.  Once the next INTUITICK gets send by input.device, the ROM
**	class already sends a notification.  The other problem is that it also
**	notifies us, when the button finally gets released (which is necessary
**	for command buttons).
**
**	We define a new class with the GM_GOACTIVE and GM_HANDLEINPUT method
**	overloaded to work around these problems.
*/

/* Function prototypes */

static ULONG HOOKCALL ScrollButtonDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, struct gpInput *gpi));


/* Per object instance data */
struct ScrollButtonData
{
	/* The number of ticks we still have to wait
	 * before sending any notification.
	 */
	ULONG TickCounter;
};



static ULONG HOOKCALL ScrollButtonDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, struct gpInput *gpi))

/* ScrollButton Class Dispatcher entrypoint.
 * Handle boopsi messages.
 */
{
	struct ScrollButtonData *bd = (struct ScrollButtonData *) INST_DATA(cl, g);

	switch (gpi->MethodID)
	{
		case GM_GOACTIVE:
			/* May define an attribute to make delay configurable */
			bd->TickCounter = 3;

			/* Notify our target that we have initially hit. */
			NotifyAttrs ((Object *)g, gpi->gpi_GInfo, 0,
				GA_ID,	g->GadgetID,
				TAG_DONE);

			/* Send more input */
			return GMR_MEACTIVE;

		case GM_HANDLEINPUT:
		{
			struct RastPort *rp;
			ULONG retval = GMR_MEACTIVE;
			UWORD selected = 0;

			/* This also works with classic (non-boopsi) images. */
			if (PointInImage ((gpi->gpi_Mouse.X << 16) + (gpi->gpi_Mouse.Y), g->GadgetRender))
			{
				/* We are hit */
				selected = GFLG_SELECTED;
			}

			if (gpi->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE && gpi->gpi_IEvent->ie_Code == SELECTUP)
			{
				/* Gadgetup, time to go */
				retval = GMR_NOREUSE;
				/* Unselect the gadget on our way out... */
				selected = 0;
			}
			else if (gpi->gpi_IEvent->ie_Class == IECLASS_TIMER)
			{
				/* We got a tick.  Decrement counter, and if 0, send notify. */

				if (bd->TickCounter)
					bd->TickCounter--;
				else if (selected)
					/* Notify our target that we are still being hit */
					NotifyAttrs ((Object *)g, gpi->gpi_GInfo, 0,
						GA_ID,	g->GadgetID,
						TAG_DONE);
			}

			if ((g->Flags & GFLG_SELECTED) != selected)
			{
				/* Update changes in gadget render */
				g->Flags ^= GFLG_SELECTED;
				if (rp = ObtainGIRPort (gpi->gpi_GInfo))
				{
					DoMethod ((Object *) g, GM_RENDER, gpi->gpi_GInfo, rp, GREDRAW_UPDATE);
					ReleaseGIRPort (rp);
				}
			}
			return retval;
		}

		default:
			/* Super class handles everything else */
			return (DoSuperMethodA (cl, (Object *)g, (Msg) gpi));
	}
}



static Class *MakeScrollButtonClass (void)
{
	Class *class;

	if (class = MakeClass (NULL, BUTTONGCLASS, NULL, sizeof(struct ScrollButtonData), 0))
		class->cl_Dispatcher.h_Entry = (ULONG (*)()) ScrollButtonDispatcher;

	return class;
}



static BOOL FreeScrollButtonClass (Class *cl)
{
	return (FreeClass (cl));
}



static struct ClassLibrary *OpenClass (STRPTR name, ULONG version)

/* Open named class. Look both in current and images/ directory
 */
{
	static const char prefix[] = "images/";
	struct ClassLibrary *classbase;
	char buf[256];
	int i;

	if (!(classbase = (struct ClassLibrary *)OpenLibrary (name, version)))
	{
		/* We can't use AddPart() here because we didn't open dos.library */

		/* Copy the prefix in the buffer */
		for (i = 0; buf[i] = prefix[i]; i++);

		/* Append the name */
		while (buf[i++] = *name++);

		/* Try again */
		classbase = (struct ClassLibrary *)OpenLibrary (buf, version);
	}
	return classbase;
}
