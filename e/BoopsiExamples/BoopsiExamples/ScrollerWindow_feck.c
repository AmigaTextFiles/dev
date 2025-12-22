/*
****************************************************************************
**
**  $VER: scrollerwindow.c 0.2 (5.6.94)
**
**  Example code which shows how to correctly create a screen resolution
**  sensitive window with scrollbars and arrows.
**
**  Write *ADPAPTIVE* software!  Get *RID* of hard coded values!
**
****************************************************************************
**
**  Copyright © 1994 Christoph Feck, TowerSystems.  You may use methods
**  and code provided in this example in executables for Commodore-Amiga
**  computers.  All other rights reserved.
**
**  For questions and suggestions contact me via email at:
**  feck@informatik.uni-kl.de
**
**  NOTE:  This file is provided "AS-IS" and subject to change without
**  prior notice; no warranties are made.  All use is at your own risk.
**  No liability or responsibility is assumed.
**
****************************************************************************
**
**  Compilation notes:
**
**  - Needs V39 or newer includes and amiga.lib (Fred Fish CD or CATS NDK).
**
****************************************************************************
**
**  Changes:
**  - oops!  forgot ReplyMsg()
**  - added input processing
**  - visible based on window size
**  - scrolls the screen in the window :)
**
**  Todo:
**  - drag scrolling
**  - keyboard control
**  - GM_LAYOUT for scrollbars (V39)
**  - make it a model
**  - your suggestions/questions
**
****************************************************************************
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <intuition/gadgetclass.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>


/***************************************************************************
 *
 *  Pepo's peculiarities.
 *
 ***************************************************************************
 */

#define NEW(type) ((type *) AllocMem(sizeof(type), MEMF_CLEAR | MEMF_PUBLIC))
#define DISPOSE(stuff) (FreeMem(stuff, sizeof(*stuff)))

#ifndef IM
#define IM(o) ((struct Image *) o)
#endif

#ifndef MAX
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#endif
#ifndef MIN
#define MIN(x,y) ((x) < (y) ? (x) : (y))
#endif


/***************************************************************************
 *
 *  Global variables.
 *
 ***************************************************************************
 */

struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct Library *UtilityBase;
struct Screen *screen;
struct DrawInfo *dri;
BOOL V39;

/* The bitmap we want to display */
struct BitMap *bitmap;


/***************************************************************************
 *
 *  V37 compatible BitMap functions.
 *
 ***************************************************************************
 */

struct BitMap *CreateBitMap(LONG width, LONG height, LONG depth, ULONG flags, struct BitMap *friend)
{
	struct BitMap *bm;

	if (V39)
	{
		bm = AllocBitMap(width, height, depth, flags, friend);
	}
	else
	{
		LONG memflags = MEMF_CHIP;

		if (bm = NEW(struct BitMap))
		{
			InitBitMap(bm, depth, width, height);
			if (flags & BMF_CLEAR) memflags |= MEMF_CLEAR;
			/* For simplicity, we allocate all planes in one big chunk */
			if (bm->Planes[0] = (PLANEPTR) AllocVec(depth * RASSIZE(width, height), memflags))
			{
				LONG i;

				for (i = 1; i < depth; i++)
				{
					bm->Planes[i] = bm->Planes[i - 1] + RASSIZE(width, height);
				}
			}
			else
			{
				DISPOSE(bm);
				bm = NULL;
			}
		}
	}
	return (bm);
}


VOID DeleteBitMap(struct BitMap *bm)
{
	if (bm)
	{
		if (V39)
		{
			FreeBitMap(bm);
		}
		else
		{
			FreeVec(bm->Planes[0]);
			DISPOSE(bm);
		}
	}
}


ULONG BitMapDepth(struct BitMap *bm)
{
	if (V39)
	{
		return (GetBitMapAttr(bm, BMA_DEPTH));
	}
	else
	{
		return (bm->Depth);
	}
}


/***************************************************************************
 *
 *  Calculates the basic size of the resolution.
 *
 ***************************************************************************
 */

int SysISize(VOID)
{
	return (screen->Flags & SCREENHIRES ? SYSISIZE_MEDRES : SYSISIZE_LOWRES);
/* NB: SYSISIZE_HIRES not yet supported. */
}


/***************************************************************************
 *
 *  Object creation stubs.
 *
 ***************************************************************************
 */

/* Creates a sysiclass object. */
Object *NewImageObject(ULONG which)
{
	return (NewObject(NULL, SYSICLASS,
	 SYSIA_DrawInfo, dri,
	 SYSIA_Which, which,
	 SYSIA_Size, SysISize(),
	TAG_DONE));
}


/* Creates a propgclass object. */
Object *NewPropObject(ULONG freedom, Tag tag1, ...)
{
	return (NewObject(NULL, PROPGCLASS,
	/* Send update to IDCMP.  If we make it a model, we would send the
	 * notification to our model object. */
	 ICA_TARGET, ICTARGET_IDCMP,
	 PGA_Freedom, freedom,
	 PGA_NewLook, TRUE,
	/* Borderless does only look right with newlook screens */
	 PGA_Borderless, ((dri->dri_Flags & DRIF_NEWLOOK) && dri->dri_Depth != 1),
	TAG_MORE, &tag1));
}


/* Creates a buttongclass object. */
Object *NewButtonObject(Object *image, Tag tag1, ...)
{
	return (NewObject(NULL, BUTTONGCLASS,
	 ICA_TARGET, ICTARGET_IDCMP,
	 GA_Image, image,
	/* No need for GA_Width/Height.  buttongclass is smart :) */
	TAG_MORE, &tag1));
}


/***************************************************************************
 *
 *  Our scroller window.  This is not a boopsi object (yet?).
 *
 ***************************************************************************
 */

/* All gadgets and their IDs. */
Object *horizgadget, *vertgadget;
Object *leftgadget, *rightgadget, *upgadget, *downgadget;

#define HORIZ_GID	1
#define VERT_GID	2
#define LEFT_GID	3
#define RIGHT_GID	4
#define UP_GID		5
#define DOWN_GID	6

struct Window *window;

/* These are the images we adapt our layout to. */
Object *sizeimage, *leftimage, *rightimage, *upimage, *downimage;

/* Cached model info */
LONG htotal;
LONG vtotal;
LONG hvisible;
LONG vvisible;

VOID OpenScrollerWindow(Tag tag1, ...)
{
	int resolution = SysISize();
	WORD topborder = screen->WBorTop + screen->Font->ta_YSize + 1;
	WORD w = IM(sizeimage)->Width;
	WORD h = IM(sizeimage)->Height;
	WORD bw = (resolution == SYSISIZE_LOWRES) ? 1 : 2;
	WORD bh = (resolution == SYSISIZE_HIRES) ? 2 : 1;
	WORD rw = (resolution == SYSISIZE_HIRES) ? 3 : 2;
	WORD rh = (resolution == SYSISIZE_HIRES) ? 2 : 1;
	WORD gw;
	WORD gh;
	WORD gap;

	gh = MAX(IM(leftimage)->Height, h);
	gh = MAX(IM(rightimage)->Height, gh);
	gw = MAX(IM(upimage)->Width, w);
	gw = MAX(IM(downimage)->Width, gw);

	/* If you have gadgets in the left window border, set 'gap' to the
	 * width of these gadgets. */
	gap = 1;

	horizgadget = NewPropObject(FREEHORIZ,
	 GA_Left, rw + gap,
	 GA_RelBottom, bh - gh + 2,
	 GA_RelWidth, -gw - gap - IM(leftimage)->Width - IM(rightimage)->Width - rw - rw,
	 GA_Height, gh - bh - bh - 2,
	 GA_BottomBorder, TRUE,
	 GA_ID, HORIZ_GID,
	 PGA_Total, htotal,
	 PGA_Visible, hvisible,
	TAG_DONE);

	vertgadget = NewPropObject(FREEVERT,
	 GA_RelRight, bw - gw + 3,
	 GA_Top, topborder + rh,
	 GA_Width, gw - bw - bw - 4,
	 GA_RelHeight, -topborder - h - IM(upimage)->Height - IM(downimage)->Height - rh - rh,
	 GA_RightBorder, TRUE,
	 GA_Previous, horizgadget,
	 GA_ID, VERT_GID,
	 PGA_Total, vtotal,
	 PGA_Visible, vvisible,
	TAG_DONE);

	leftgadget = NewButtonObject(leftimage,
	 GA_RelRight, 1 - IM(leftimage)->Width - IM(rightimage)->Width - gw,
	 GA_RelBottom, 1 - IM(leftimage)->Height,
	 GA_BottomBorder, TRUE,
	 GA_Previous, vertgadget,
	 GA_ID, LEFT_GID,
	TAG_DONE);

	rightgadget = NewButtonObject(rightimage,
	 GA_RelRight, 1 - IM(rightimage)->Width - gw,
	 GA_RelBottom, 1 - IM(rightimage)->Height,
	 GA_BottomBorder, TRUE,
	 GA_Previous, leftgadget,
	 GA_ID, RIGHT_GID,
	TAG_DONE);

	upgadget = NewButtonObject(upimage,
	 GA_RelRight, 1 - IM(upimage)->Width,
	 GA_RelBottom, 1 - IM(upimage)->Height - IM(downimage)->Height - h,
	 GA_RightBorder, TRUE,
	 GA_Previous, rightgadget,
	 GA_ID, UP_GID,
	TAG_DONE);

	downgadget = NewButtonObject(downimage,
	 GA_RelRight, 1 - IM(downimage)->Width,
	 GA_RelBottom, 1 - IM(downimage)->Height - h,
	 GA_RightBorder, TRUE,
	 GA_Previous, upgadget,
	 GA_ID, DOWN_GID,
	TAG_DONE);

	/* if downgadget is non-NULL, all gadgets were created OK. */
	if (downgadget)
	{
		window = OpenWindowTags(NULL,
		 WA_Gadgets, horizgadget,
		 WA_MinWidth, MAX(80, gw + gap + IM(leftimage)->Width + IM(rightimage)->Width + rw + rw + KNOBHMIN),
		 WA_MinHeight, MAX(50, topborder + h + IM(upimage)->Height + IM(downimage)->Height + rh + rh + KNOBVMIN),
		TAG_MORE, &tag1);
	}
}


VOID CloseScrollerWindow(VOID)
{
	if (window) CloseWindow(window);
	DisposeObject(horizgadget);
	DisposeObject(vertgadget);
	DisposeObject(leftgadget);
	DisposeObject(rightgadget);
	DisposeObject(upgadget);
	DisposeObject(downgadget);
}


/***************************************************************************
 *
 *  Here we do all the stuff necessary to make it work properly.
 *
 ***************************************************************************
 */

/* Calculate visible region based on window size. */

STATIC LONG RecalcHVisible(VOID)
{
	return (window->Width - window->BorderLeft - window->BorderRight);
}

STATIC LONG RecalcVVisible(VOID)
{
	return (window->Height - window->BorderTop - window->BorderBottom);
}


VOID UpdateProp(Object *gadget, ULONG attr, LONG value)
{
	SetGadgetAttrs((struct Gadget *) gadget, window, NULL, attr, value, TAG_DONE);
}


/* Copy our BitMap into the window */
VOID CopyBitMap(VOID)
{
	ULONG srcx, srcy;

	/* Get right place */
	GetAttr(PGA_Top, horizgadget, &srcx);
	GetAttr(PGA_Top, vertgadget, &srcy);
	BltBitMapRastPort(bitmap, srcx, srcy, window->RPort, window->BorderLeft, window->BorderTop, MIN(htotal, hvisible), MIN(vtotal, vvisible), 0xC0);
}


VOID UpdateScrollerWindow(VOID)
{
	hvisible = RecalcHVisible();
	UpdateProp(horizgadget, PGA_Visible, hvisible);
	vvisible = RecalcVVisible();
	UpdateProp(vertgadget, PGA_Visible, vvisible);
	CopyBitMap();
}


/***************************************************************************
 *
 *  Main program.
 *
 ***************************************************************************
 */


VOID HandleScrollerWindow(VOID)
{
	struct IntuiMessage *imsg;
	BOOL quit = FALSE;
	LONG oldtop;

	while (!quit)
	{
		while (!quit && (imsg = (struct IntuiMessage *) GetMsg(window->UserPort)))
		{
			switch (imsg->Class)
			{
			case IDCMP_CLOSEWINDOW:
				quit = TRUE;
				break;
			case IDCMP_NEWSIZE:
				UpdateScrollerWindow();
				break;
			case IDCMP_REFRESHWINDOW:
				BeginRefresh(window);
				CopyBitMap();
				EndRefresh(window, TRUE);
				break;
			case IDCMP_IDCMPUPDATE:
				/* IAddress is a pointer to a taglist with new attributes.
				 * We are only interested in the ID of the involved gadget.
				 */
				switch (GetTagData(GA_ID, 0, (struct TagItem *) imsg->IAddress))
				{
				case HORIZ_GID:
				case VERT_GID:
					CopyBitMap();
					break;
				case LEFT_GID:
					GetAttr(PGA_Top, horizgadget, (ULONG *) &oldtop);
					if (oldtop > 0)
					{
						UpdateProp(horizgadget, PGA_Top, oldtop - 1);
						CopyBitMap();
					}
					break;
				case RIGHT_GID:
					GetAttr(PGA_Top, horizgadget, (ULONG *) &oldtop);
					if (oldtop < htotal - hvisible)
					{
						UpdateProp(horizgadget, PGA_Top, oldtop + 1);
						CopyBitMap();
					}
					break;
				case UP_GID:
					GetAttr(PGA_Top, vertgadget, (ULONG *) &oldtop);
					if (oldtop > 0)
					{
						UpdateProp(vertgadget, PGA_Top, oldtop - 1);
						CopyBitMap();
					}
					break;
				case DOWN_GID:
					GetAttr(PGA_Top, vertgadget, (ULONG *) &oldtop);
					if (oldtop < vtotal - vvisible)
					{
						UpdateProp(vertgadget, PGA_Top, oldtop + 1);
						CopyBitMap();
					}
					break;
				default:
					break;
				}
				break;
			default:
				break;
			}
			ReplyMsg((struct Message *) imsg);
		}
		if (!quit) WaitPort(window->UserPort);
	}
}


VOID DoScrollerWindow(VOID)
{
	if (screen = LockPubScreen(NULL))
	{
		/* We clone the screen bitmap */
		hvisible = htotal = screen->Width;
		vvisible = vtotal = screen->Height;
		if (bitmap = CreateBitMap(htotal, vtotal, BitMapDepth(screen->RastPort.BitMap), 0, screen->RastPort.BitMap))
		{
			/* Copy it over */
			BltBitMap(screen->RastPort.BitMap, 0, 0, bitmap, 0, 0, htotal, vtotal, 0xC0, ~0, NULL);
			if (dri = GetScreenDrawInfo(screen))
			{
				sizeimage = NewImageObject(SIZEIMAGE);
				leftimage = NewImageObject(LEFTIMAGE);
				rightimage = NewImageObject(RIGHTIMAGE);
				upimage = NewImageObject(UPIMAGE);
				downimage = NewImageObject(DOWNIMAGE);
				if (sizeimage && leftimage && rightimage && upimage && downimage)
				{
					OpenScrollerWindow(WA_PubScreen, screen,
					 WA_Title, "$VER: ScrollerWindow 0.2 (5.6.94)",
					 WA_Flags,
					 	WFLG_CLOSEGADGET |
					 	WFLG_SIZEGADGET |
					 	WFLG_DRAGBAR |
					 	WFLG_DEPTHGADGET |
					 	WFLG_SIMPLE_REFRESH |
					 	WFLG_ACTIVATE |
					 	WFLG_NEWLOOKMENUS,
					 WA_IDCMP,
					 	IDCMP_CLOSEWINDOW |
					 	IDCMP_NEWSIZE |
					 	IDCMP_REFRESHWINDOW |
					 	IDCMP_IDCMPUPDATE,
					 WA_InnerWidth, htotal,
					 WA_InnerHeight, vtotal,
					 WA_MaxWidth, -1,
					 WA_MaxHeight, -1,
					TAG_DONE);
					if (window)
					{
						UpdateScrollerWindow();
						HandleScrollerWindow();
					}
					CloseScrollerWindow();
				}
				DisposeObject(sizeimage);
				DisposeObject(leftimage);
				DisposeObject(rightimage);
				DisposeObject(upimage);
				DisposeObject(downimage);
				FreeScreenDrawInfo(screen, dri);
			}
			WaitBlit();
			DeleteBitMap(bitmap);
		}
		UnlockPubScreen(NULL, screen);
	}
}


/***************************************************************************
 *
 *  Startup.
 *
 ***************************************************************************
 */

VOID main(int argc, char *argv[])
{
	if (IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library", 36))
	{
		/* Do we run V39? */
		V39 = ((struct Library *) IntuitionBase)->lib_Version >= 39;
		if (GfxBase = (struct GfxBase *) OpenLibrary("graphics.library", 36))
		{
			if (UtilityBase = OpenLibrary("utility.library", 36))
			{
				DoScrollerWindow();
				CloseLibrary(UtilityBase);
			}
			CloseLibrary((struct Library *) IntuitionBase);
		}
		CloseLibrary((struct Library *) GfxBase);
	}
}


