/*
**	$VER: VectorGlyphDemo 1.1 (25.9.97) by Bernardo Innocenti
**
**
**	Introduction
**	============
**
**	This program demonstrates how to use the `boopsi' "vectorglyphiclass"
**	images.
**
**	The source code shows how to create a window with several boopsi
**	button gadgets and how to write a custom `boopsi' class on top
**	of the imageclass.
**
**
**	Compiling
**	=========
**
**	This project can be compiled with SAS/C 6.58 or better and
**	StormC 2.00.23 or better. You get the smaller and faster
**	executable with SAS/C. SAS/C will give you a couple of warnings
**	on the library bases which are defined static. Do not worry about it.
**
**
**	History
**	=======
**
**	1.0 (31.8.97)	First release
**	1.1 (25.9.97)	Added StormC support
**					Removed some dead code
**					Added partial GCC support
**
**
**	Known Bugs
**	==========
**
**		- This code has never been tested on V37.
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

#include <proto/exec.h>
#include <proto/intuition.h>

#include "CompilerSpecific.h"
#include "Debug.h"
#include "BoopsiStubs.h"

#include "VectorGlyphIClass.h"


/* OS version */

#ifdef OS30_ONLY
 #define WANTEDLIBVER	39L
#else
 #define WANTEDLIBVER	37L
#endif


/* Number of images in the vectorglyphiclass */
#define IMG_COUNT 5

/* How many different sizes to show */
#define IMG_SIZES 8

/* Total number of buttons */
#define GAD_COUNT (IMG_COUNT * IMG_SIZES)


/* Local function prototypes */
LONG SAVEDS					 main			(void);
static struct VGDHandle		*OpenVGDWin		(UBYTE *pubscreen, ULONG left, ULONG top,
										ULONG width, ULONG height);
static void					 CloseVGDWin	(struct VGDHandle *vgdhandle);
static struct Gadget		*CreateGadgets	(struct VGDHandle *vgdhandle);
static void					 DisposeGadgets (struct VGDHandle *vgdhandle);
static struct ClassLibrary	*OpenClass		(STRPTR name, ULONG version);



/* This structure describes an open VectorGlyphDemo window */

struct VGDHandle
{
	struct Window	*Win;
	struct Screen	*Scr;
	struct DrawInfo	*DrawInfo;
	APTR			 ButtonFrame;
	struct Image	*Img[GAD_COUNT];
	struct Gadget	*Gad[GAD_COUNT];
};



/* Version tag */

static UBYTE versiontag[] = "$VER: VectorGlyphDemo 1.1 (25.9.97) by Bernardo Innocenti";


/* Library bases
 *
 * We do not need to access the data contained in the base of
 * any of these libraries, so we define all them as simple Library
 * structures to avoid including custom library base headers.
 */
static struct ExecBase		*SysBase;
static struct IntuitionBase	*IntuitionBase;

/* `boopsi' class library base */
static struct ClassLibrary	*VectorGlyphBase;



LONG SAVEDS _main (void)

/* Main program entry point.  When linking without startup code, this
 * must be the first function in the first object module listed on the
 * linker command line.  We also need to initialize SysBase and open
 * all needed libraries manually.
 */
{
	struct VGDHandle *vgdhandle;
	LONG			 sigwait, sigrcvd;
	LONG			 retval	= RETURN_FAIL;
	BOOL			 quit	= FALSE;

	/* Initialize SysBase */
	SysBase = *((struct ExecBase **)4UL);

	if (IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library", WANTEDLIBVER))
	{
		if (VectorGlyphBase = OpenClass ("vectorglyph.image", 0))
		{
			if (vgdhandle = OpenVGDWin (NULL, 0, 20, 334, 320))
			{
				/* Pre-calculate the signal mask for Wait() */
				sigwait = (1 << vgdhandle->Win->UserPort->mp_SigBit) |
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
					if (sigrcvd & (1 << vgdhandle->Win->UserPort->mp_SigBit))
					{
						struct IntuiMessage	*msg;

						while (msg = (struct IntuiMessage *) GetMsg (vgdhandle->Win->UserPort))
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

				retval = RETURN_OK;

				CloseVGDWin (vgdhandle);
			}

			/* This cannot fail. Passing NULL is ok. */
			CloseLibrary ((struct Library *)VectorGlyphBase);
		}
		CloseLibrary ((struct Library *)IntuitionBase);
	}

	return retval;
}



static struct VGDHandle *OpenVGDWin (UBYTE *pubscreen,
	ULONG left, ULONG top, ULONG width, ULONG height)
{
	struct VGDHandle	*vgdhandle;
	struct Gadget		*glist;

	if (vgdhandle = AllocMem (sizeof (struct VGDHandle), MEMF_ANY | MEMF_CLEAR))
	{
		if (vgdhandle->Scr = LockPubScreen (pubscreen))
		{
			if (glist = CreateGadgets (vgdhandle))
			{
				if (vgdhandle->Win = OpenWindowTags (NULL,
					WA_Top,				top,
					WA_Left,			left,
					WA_InnerWidth,		width,
					WA_InnerHeight,		height,
					WA_PubScreen,		vgdhandle->Scr,
					WA_PubScreenFallBack, TRUE,
					WA_AutoAdjust,		TRUE,
					WA_IDCMP,			IDCMP_CLOSEWINDOW,
					WA_Flags,			WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_CLOSEGADGET |
										WFLG_SIMPLE_REFRESH | WFLG_NOCAREREFRESH,
					WA_Gadgets,			glist,
					WA_Title,			versiontag,
					TAG_DONE))

					/* We need to keep our screen locked all the time
					 * because we want to free the associated DrawInfo
					 * *after* the window has been closed and
					 * FreeScreenDrawInfo() wants a pointer to a *valid*
					 * Screen.
					 */
					return vgdhandle;

				DisposeGadgets (vgdhandle);
			}
			UnlockPubScreen (NULL, vgdhandle->Scr);
		}
		FreeMem (vgdhandle, sizeof (struct VGDHandle));
	}
	return NULL;
}



static void CloseVGDWin (struct VGDHandle *vgdhandle)
{
	/* Close our window. No need to reply queued messages,
	 * Intuition is clever enough to care about this for us.
	 */
	CloseWindow (vgdhandle->Win);
	DisposeGadgets (vgdhandle);
	UnlockPubScreen (NULL, vgdhandle->Scr);
	FreeMem (vgdhandle, sizeof (struct VGDHandle));
}



static struct Gadget *CreateGadgets (struct VGDHandle *vgdhandle)
{
	struct DrawInfo	*dri;
	struct Screen	*scr = vgdhandle->Scr;
	LONG size, type, offx, offy, id;

	static UWORD sizex[IMG_SIZES] = { 8, 12, 16, 24, 24, 36, 36, 48 };
	static UWORD sizey[IMG_SIZES] = { 8, 12, 16, 24, 36, 24, 36, 48 };

	/* GetScreenDrawInfo() never fails */
	dri = vgdhandle->DrawInfo = GetScreenDrawInfo (scr);

	/* Create a frame for our buttons */
	if (vgdhandle->ButtonFrame = NewObject (NULL, FRAMEICLASS,
		IA_FrameType,	FRAME_BUTTON,
		IA_EdgesOnly,	TRUE,
		TAG_DONE))
	{
		offy = scr->WBorTop + scr->Font->ta_YSize + 12;

		for (size = 0; size < IMG_SIZES; offy += sizey[size] + 12, size++)
		{
			offx = scr->WBorLeft + 10;

			for (type = 0; type < IMG_COUNT; offx += sizex[size] + 16, type++)
			{
				id = type + size * IMG_COUNT;

				if (vgdhandle->Img[id] = (struct Image *)
					NewObject (NULL, VECTORGLYPHCLASS,
						SYSIA_Which,	type,
						SYSIA_DrawInfo,	dri,
						IA_Width,		sizex[size],
						IA_Height,		sizey[size],
						TAG_DONE))
				{
					if (!(vgdhandle->Gad[id] = (struct Gadget *)
						NewObject (NULL, FRBUTTONCLASS,
						GA_ID,			id,
						GA_Left,		offx,
						GA_Top,			offy,
						GA_DrawInfo,	dri,
						GA_LabelImage,	vgdhandle->Img[id],
						GA_Image,		vgdhandle->ButtonFrame,
						id ? GA_Previous : TAG_IGNORE, vgdhandle->Gad[id - 1],
						TAG_DONE)))
					{
						DisposeGadgets (vgdhandle);
						return NULL;
					}
				}
				else
				{
					DisposeGadgets (vgdhandle);
					return NULL;
				}
			}
		}
	}
	else
	{
		DisposeGadgets (vgdhandle);
		return NULL;
	}

	return vgdhandle->Gad[0];
}



static void DisposeGadgets (struct VGDHandle *vgdhandle)
{
	int i;

	for (i = 0; i < GAD_COUNT; i++)
	{
		DisposeObject (vgdhandle->Gad[i]);
		DisposeObject (vgdhandle->Img[i]);
	}

	DisposeObject (vgdhandle->ButtonFrame);
	FreeScreenDrawInfo (vgdhandle->Scr, vgdhandle->DrawInfo);
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
