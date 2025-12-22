/*	ListViewClass.c
**
**	Copyright (C) 1996,97 Bernardo Innocenti
**
**	Use 4 chars wide TABs to read this file
**
**	GadTools-like `boopsi' ListView gadget class
*/

#define USE_BUILTIN_MATH
#define INTUI_V36_NAMES_ONLY
#define __USE_SYSBASE
#define  CLIB_ALIB_PROTOS_H		/* Avoid dupe defs of boopsi funcs */

#include <exec/types.h>
#include <exec/libraries.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/layers.h>
#include <proto/utility.h>

#ifdef __STORM__
	#pragma header
#endif

#include "CompilerSpecific.h"
#include "Debug.h"
#include "BoopsiStubs.h"

#define LV_GADTOOLS_STUFF
#include "ListViewClass.h"



/* ListView private instance data */


/* Type of a listview hook function */
typedef	ASMCALL APTR	LVHook(
	REG(a0, struct Hook	*hook), REG(a1, APTR item), REG(a2, struct lvGetItem *lvg));
typedef	ASMCALL APTR	LVDrawHook(
	REG(a0, struct Hook	*hook), REG(a1, APTR item), REG(a2, struct lvDrawItem *lvdi));

struct LVData
{
	APTR			 Items;				/* The list/array of items				*/
	LONG			 Top;				/* Ordinal nr. of the top visible item	*/
	APTR			 TopPtr;			/* Pointer to the top visible item		*/
	LONG			 Total;				/* Total nr. of items in the list		*/
	LONG			 Visible;			/* Number of items visible in the list	*/
	LONG			 PixelTop;			/* Pixel-wise offset from the top		*/
	LONG			 Selected;			/* Ordinal nr. of the selected item		*/
	APTR			 SelectedPtr;		/* Pointer to the selected item			*/
	ULONG			 SelectCount;		/* Number of items currently selected	*/
	ULONG			 MaxSelect;			/* Maximum nr. of selections to allow	*/

	/* Old values used to track scrolling amount in GM_RENDER */
	LONG			 OldTop;
	LONG			 OldPixelTop;
	LONG			 OldSelected;
	APTR			 OldSelectedPtr;

	ULONG			 DragSelect;		/* Status of drag selection				*/
	LONG			 ItemHeight;		/* Height of one item in pixels			*/
	LONG			 Spacing;			/* Spacing between items in pixels		*/
	LONG			 MaxScroll;			/* Redraw all when scrolling too much	*/
	LONG			 ScrollRatio;		/* max visible/scrolled ratio			*/
	ULONG			*SelectArray;		/* Array of selected items. May be NULL	*/
	LONG			 BackupSelected;	/* Used by RMB undo 					*/
	LONG			 BackupPixelTop;	/* Used by RMB undo						*/
	WORD			 MiddleMouseY;		/* Initial Y position for MMB scrolling	*/
	ULONG			 Flags;				/* See <listviewclass.h>				*/
	ULONG			 MaxPen;			/* Highest pen number used				*/
	ULONG			 DoubleClickSecs, DoubleClickMicros;

	/* User or internal hooks */
	LVHook			*GetItemFunc;
	LVHook			*GetNextFunc;
	LVHook			*GetPrevFunc;
	LVHook			*DrawBeginFunc;
	LVHook			*DrawEndFunc;
	LVDrawHook		*DrawItemFunc;
	struct Hook		*CallBack;			/* Callback hook provided by user	*/

	struct TextFont	*Font;				/* Font used to render text labels	*/
	struct Region	*ClipRegion;		/* Used in LVA_Clipped mode			*/

	/* These two have the same meaning, but we keep both updated
	 * because the Rectangle structure (MinX, MinY, MaxX, MaxY)
	 * is more handy in some cases, while the IBox structure
	 * (Left/Top/Width/Height) is best for other cases.
	 */
	struct IBox		 GBox;
	struct Rectangle GRect;
};



/* Local function prototypes */

static void		LV_GMRender		(Class *cl, struct Gadget *g, struct gpRender *msg);
static ULONG	LV_GMGoActive	(Class *cl, struct Gadget *g, struct gpInput *msg);
static ULONG	LV_GMHandleInput(Class *cl, struct Gadget *g, struct gpInput *msg);
static void		LV_GMGoInactive	(Class *cl, struct Gadget *g, struct gpGoInactive *msg);
static void		LV_GMLayout		(Class *cl, struct Gadget *g, struct gpLayout *msg);
static ULONG	LV_OMSet		(Class *cl, struct Gadget *g, struct opUpdate *msg);
static ULONG	LV_OMGet		(Class *cl, struct Gadget *g, struct opGet *msg);
static ULONG	LV_OMNew		(Class *cl, struct Gadget *g, struct opSet *msg);
static void		LV_OMDispose	(Class *cl, struct Gadget *g, Msg msg);

static void		RedrawItems		(struct LVData *lv, struct gpRender *msg, ULONG first, ULONG last, APTR item);
INLINE LONG		ItemHit			(struct LVData *lv, WORD x, WORD y);
INLINE void		GetGadgetBox	(struct GadgetInfo *ginfo, struct ExtGadget *g, struct IBox *box, struct Rectangle *rect);
INLINE	APTR	GetItem			(struct LVData *lv, ULONG num);
INLINE	APTR	GetNext			(struct LVData *lv, APTR item, ULONG num);
INLINE	APTR	GetPrev			(struct LVData *lv, APTR item, ULONG num);
INLINE ULONG	CountNodes		(struct List *list);
static ULONG	CountSelections	(struct LVData *lv);
INLINE ULONG	IsItemSelected	(struct LVData *lv, APTR item, ULONG num);

/* Definitions for the builtin List hooks */
LVHook		ListGetItem;
LVHook		ListGetNext;
LVHook		ListGetPrev;
LVDrawHook	ListStringDrawItem;
LVDrawHook	ListImageDrawItem;

/* Definitions for the builtin Array hooks */
LVHook		ArrayGetItem;
LVDrawHook	StringDrawItem;
LVDrawHook	ImageDrawItem;



static ULONG HOOKCALL LVDispatcher (
	REG(a0, Class *cl),
	REG(a2, struct Gadget *g),
	REG(a1, Msg msg))

/* ListView class dispatcher - Handles all supported methods */
{
	ASSERT_VALIDNO0(cl)
	ASSERT_VALIDNO0(g)
	ASSERT_VALIDNO0(msg)

	switch (msg->MethodID)
	{
		case GM_RENDER:
			LV_GMRender (cl, g, (struct gpRender *)msg);
			return TRUE;

		case GM_GOACTIVE:
			return LV_GMGoActive (cl, g, (struct gpInput *)msg);

		case GM_HANDLEINPUT:
			return LV_GMHandleInput (cl, g, (struct gpInput *)msg);

		case GM_GOINACTIVE:
			LV_GMGoInactive (cl, g, (struct gpGoInactive *)msg);
			return TRUE;

		case GM_LAYOUT:
			/* This method is only supported on V39 and above */
			LV_GMLayout (cl, g, (struct gpLayout *)msg);
			return TRUE;

		case OM_SET:
		case OM_UPDATE:
			return LV_OMSet (cl, g, (struct opUpdate *)msg);

		case OM_GET:
			return LV_OMGet (cl, g, (struct opGet *)msg);

		case OM_NEW:
			return LV_OMNew (cl, g, (struct opSet *)msg);

		case OM_DISPOSE:
			LV_OMDispose (cl, g, msg);
			return TRUE;

		default:
			/* Unsupported method: let our superclass's
			 * dispatcher take a look at it.
			 */
			return DoSuperMethodA (cl, (Object *)g, msg);
	}
}



INLINE void GetItemBounds (struct LVData *lv, struct Rectangle *rect, LONG item)

/* Compute the bounding box to render the given item and store it in the passed
 * Rectangle structure.
 */
{
	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(rect)
	ASSERT(item < lv->Total)
	ASSERT(item >= 0)

	rect->MinX = lv->GRect.MinX;
	rect->MaxX = lv->GRect.MaxX;
	rect->MinY = lv->ClipRegion ?
		(lv->GRect.MinY + item * (lv->ItemHeight + lv->Spacing) - lv->PixelTop) :
		(lv->GRect.MinY + (item - lv->Top) * (lv->ItemHeight + lv->Spacing));
	rect->MaxY = rect->MinY + lv->ItemHeight - 1;
}



static void RedrawItems (struct LVData *lv, struct gpRender *msg, ULONG first, ULONG last, APTR item)

/* Redraw items from <min> to <max>.  No sanity checks are performed
 * to ensure that all items between <min> and <max> are really visible.
 */
{
	struct lvDrawItem lvdi;
	LONG selected;


	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(msg)
	ASSERT(first <= last)
	ASSERT(last < lv->Total)

	DB (kprintf ("  RedrawItems (first = %ld, last = %ld)\n", first, last);)


	lvdi.lvdi_Current	= first;
	lvdi.lvdi_Items		= lv->Items;
	lvdi.lvdi_RastPort	= msg->gpr_RPort;
	lvdi.lvdi_DrawInfo	= msg->gpr_GInfo->gi_DrInfo;
	lvdi.lvdi_Flags		= lv->Flags;

	GetItemBounds (lv, &lvdi.lvdi_Bounds, first);

	if (!item)
	{
		lvdi.lvdi_MethodID = LV_GETITEM;
		item = lv->GetItemFunc (lv->CallBack, NULL, (struct lvGetItem *)&lvdi);
	}

	if (lv->DrawBeginFunc)
	{
		lvdi.lvdi_MethodID	= LV_DRAWBEGIN;
		lv->DrawBeginFunc (lv->CallBack, item, (struct lvDrawBegin *)&lvdi);
	}

	for (;;)
	{
		if (lv->Flags & LVF_DOMULTISELECT)
		{
			if (lv->SelectArray)
				/* Array selection */
				selected = lv->SelectArray[lvdi.lvdi_Current];
			else
				if (lv->Flags & LVF_LIST)
					/* Node selection */
					selected = (((struct Node *)item)->ln_Type);
				else
					selected = 0;
		}
		else
			/* Single selection */
			selected = (lvdi.lvdi_Current == lv->Selected);

		lvdi.lvdi_State = selected ? LVR_SELECTED : LVR_NORMAL;

		lvdi.lvdi_MethodID	= LV_DRAW;
		lv->DrawItemFunc (lv->CallBack, item, &lvdi);

		if (++lvdi.lvdi_Current > last)
			break;

		lvdi.lvdi_MethodID	= LV_GETNEXT;
		item = lv->GetNextFunc (lv->CallBack, item, (struct lvGetNext *)&lvdi);

		lvdi.lvdi_Bounds.MinY += lv->ItemHeight + lv->Spacing;
		lvdi.lvdi_Bounds.MaxY += lv->ItemHeight + lv->Spacing;
	}

	if (lv->DrawEndFunc)
	{
		lvdi.lvdi_MethodID	= LV_DRAWEND;
		lv->DrawEndFunc (lv->CallBack, item, (struct lvDrawEnd *)&lvdi);
	}
}



static void LV_GMRender (Class *cl, struct Gadget *g, struct gpRender *msg)
{
	struct LVData		*lv = INST_DATA (cl, g);
	struct RastPort		*rp = msg->gpr_RPort;

	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(rp)

	DB (kprintf ("GM_RENDER: msg->gpr_Redraw = %s\n",
		(msg->gpr_Redraw == GREDRAW_TOGGLE) ? "GREDRAW_TOGGLE" :
		((msg->gpr_Redraw == GREDRAW_REDRAW) ? "GREDRAW_REDRAW" :
		((msg->gpr_Redraw == GREDRAW_UPDATE) ? "GREDRAW_UPDATE" :
		"*** Unknown ***")) );)


#ifndef OS30_ONLY
	/* Pre-V39 Intuition won't call our GM_LAYOUT method, so we must
	 * always call it before redrawing the gadget.
	 */
	if ((IntuitionBase->LibNode.lib_Version < 39) &&
		(msg->gpr_Redraw == GREDRAW_REDRAW))
		LV_GMLayout (cl, g, (struct gpLayout *)msg);
#endif /* !OS30_ONLY */

	if (lv->Flags & LVF_DONTDRAW)
		return;

	if (lv->Items && lv->Visible)
	{
		struct TextFont *oldfont = NULL;
		struct Region *oldregion = NULL;

		if (rp->Font != lv->Font)
		{
			oldfont = rp->Font;
			SetFont (rp, lv->Font);
		}

		if (lv->ClipRegion)
		{
			ASSERT_VALIDNO0(lv->ClipRegion)
			oldregion = InstallClipRegion (rp->Layer, lv->ClipRegion);
		}

		switch (msg->gpr_Redraw)
		{
			case GREDRAW_TOGGLE:	/* Toggle selected item */
			{
				BOOL	drawnew = (lv->Selected >= lv->Top) && (lv->Selected < lv->Top + lv->Visible),
						drawold = (lv->OldSelected >= lv->Top) && (lv->OldSelected < lv->Top + lv->Visible);

				if (drawold || drawnew)
				{
					struct lvDrawItem	 lvdi;
					lvdi.lvdi_Items		= lv->Items;
					lvdi.lvdi_RastPort	= rp;
					lvdi.lvdi_DrawInfo	= msg->gpr_GInfo->gi_DrInfo;
					lvdi.lvdi_Flags		= lv->Flags;


					if (lv->DrawBeginFunc)
					{
						lvdi.lvdi_MethodID	= LV_DRAWBEGIN;
						lv->DrawBeginFunc (lv->CallBack, NULL, (struct lvDrawBegin *)&lvdi);
					}

					lvdi.lvdi_MethodID	= LV_DRAW;

					if (drawnew)
					{
						GetItemBounds (lv, &lvdi.lvdi_Bounds, lv->Selected);
						lvdi.lvdi_State = IsItemSelected (lv, lv->SelectedPtr, lv->Selected) ?
							LVR_SELECTED : LVR_NORMAL;
						lvdi.lvdi_Current = lv->Selected;

						lv->DrawItemFunc (lv->CallBack, lv->SelectedPtr, &lvdi);
					}

					if (drawold)
					{
						GetItemBounds (lv, &lvdi.lvdi_Bounds, lv->OldSelected);
						lvdi.lvdi_State = IsItemSelected (lv, lv->OldSelectedPtr, lv->OldSelected) ?
							LVR_SELECTED : LVR_NORMAL;
						lvdi.lvdi_Current = lv->OldSelected;

						lv->DrawItemFunc (lv->CallBack, lv->OldSelectedPtr, &lvdi);
					}

					if (lv->DrawEndFunc)
					{
						lvdi.lvdi_MethodID	= LV_DRAWEND;
						lv->DrawEndFunc (lv->CallBack, NULL, (struct lvDrawEnd *)&lvdi);
					}
				}

				lv->OldSelected = lv->Selected;
				lv->OldSelectedPtr = lv->SelectedPtr;

				break;
			}

			case GREDRAW_REDRAW:	/* Redraw everything */
			{
				LONG	ycoord;

				/* Set the background pen */
				SetAPen (rp, msg->gpr_GInfo->gi_DrInfo->dri_Pens[BACKGROUNDPEN]);
				/* SetAPen (rp, -1); Used to debug clearing code */

				/* Now clear the spacing between the items */
				if (lv->Spacing && lv->Items && lv->Visible)
				{
					LONG i, lastitem;

					ycoord = lv->GRect.MinY + lv->ItemHeight;
					lastitem = min (lv->Visible, lv->Total - lv->Top) - 1;

					for (i = 0 ; i < lastitem; i++)
					{
						RectFill (rp, lv->GRect.MinX, ycoord,
							lv->GRect.MaxX, ycoord + lv->Spacing - 1);

						ycoord += lv->ItemHeight + lv->Spacing;
					}
				}
				else
					ycoord = lv->GRect.MinY + min (lv->Visible, lv->Total - lv->Top)
						* lv->ItemHeight;

				/* Now let's clear bottom part of gadget */
				RectFill (rp, lv->GRect.MinX, ycoord,
					lv->GRect.MaxX, lv->GRect.MaxY);

				/* Finally, draw the items */
				RedrawItems (lv, msg, lv->Top,
					min (lv->Top + lv->Visible, lv->Total) - 1, lv->TopPtr);

				break;
			}

			case GREDRAW_UPDATE:	/* Scroll ListView */
			{
				LONG scroll_dy, scroll_height;

				if (lv->ClipRegion)
				{
					/* Calculate scrolling amount in pixels */
					if (!(scroll_dy = lv->PixelTop - lv->OldPixelTop))
						/* Do nothing if called improperly */
						break;

					/* Scroll everything */
					scroll_height = lv->GBox.Height;
				}
				else
				{
					if (!(lv->Top - lv->OldTop))
						/* Do nothing if called improperly */
						break;

					/* Calculate scrolling amount in pixels */
					scroll_dy = (lv->Top - lv->OldTop) * (lv->ItemHeight + lv->Spacing);

					/* Only scroll upto last visible item */
					scroll_height = lv->Visible * (lv->ItemHeight + lv->Spacing) - lv->Spacing;
				}

				if (abs(scroll_dy) > lv->MaxScroll)
				{
					/* Redraw everything when listview has been scrolled too much */
					RedrawItems (lv, msg, lv->Top,
						min (lv->Top + lv->Visible, lv->Total) - 1, lv->TopPtr);
				}
				else
				{
					/* Optimize scrolling on planar displays if possible */
#ifndef OS30_ONLY
					if (GfxBase->LibNode.lib_Version >= 39)
#endif /* OS30_ONLY */
						SetMaxPen (rp, lv->MaxPen);

					/* We use ClipBlit() to scroll the listview because it doesn't clear
					 * the scrolled region like ScrollRaster() would do.  Unfortunately,
					 * ClipBlit() does not scroll along the damage regions, so we also
					 * call ScrollRaster() with the mask set to 0, which will scroll the
					 * layer damage regions without actually modifying the display.
					 */

					if (scroll_dy > 0)	/* Scroll Down */
					{
						ClipBlit (rp, lv->GBox.Left, lv->GBox.Top + scroll_dy,
							rp, lv->GBox.Left, lv->GBox.Top,
							lv->GBox.Width, scroll_height - scroll_dy,
							0x0C0);

							if (lv->ClipRegion)
							{
								/* NOTE: We subtract 1 pixel to avoid an exact division which would
								 *       render one item beyond the end when the slider is dragged
								 *       all the way down.
								 */
								RedrawItems (lv, msg,
									(lv->OldPixelTop + lv->GBox.Height) / (lv->ItemHeight + lv->Spacing),
									(lv->PixelTop + lv->GBox.Height - 1) / (lv->ItemHeight + lv->Spacing),
									NULL);
							}
							else
								RedrawItems (lv, msg,
									lv->Visible + lv->OldTop,
									lv->Visible + lv->Top - 1,
									NULL);
					}
					else				/* Scroll Up */
					{
						ClipBlit (rp, lv->GBox.Left, lv->GBox.Top,
							rp, lv->GBox.Left, lv->GBox.Top - scroll_dy,
							lv->GBox.Width, scroll_height + scroll_dy,
							0x0C0);


							if (lv->ClipRegion)
								RedrawItems (lv, msg,
									lv->PixelTop / (lv->ItemHeight + lv->Spacing),
									lv->OldPixelTop / (lv->ItemHeight + lv->Spacing),
									NULL);
							else
								RedrawItems (lv, msg,
									lv->Top,
									lv->OldTop - 1,
									lv->TopPtr);
					}


					/* Some layers magic adapded from "MUI.undoc",
					 * by Alessandro Zummo <azummo@ita.flashnet.it>
					 */
					#define LayerCovered(l) \
						((!(l)->ClipRect) || memcmp (&(l)->ClipRect->bounds, \
						&(l)->bounds, sizeof (struct Rectangle)))
					#define LayerDamaged(l) \
						((l)->DamageList && (l)->DamageList->RegionRectangle)
					#define NeedZeroScrollRaster(l) (LayerCovered(l) || LayerDamaged(l))


					/* This will scroll the layer damage regions without actually
					 * scrolling the display, but only if our layer really needs it.
					 */
					if ((rp->Layer->Flags & LAYERSIMPLE) && NeedZeroScrollRaster (rp->Layer))
					{
						UBYTE oldmask = rp->Mask; /* Using GetRPAttr() would be better? */

						DB (kprintf ("  Calling ScrollRaster()\n");)
#ifdef OS30_ONLY
						SetWriteMask (rp, 0);
#else
						SafeSetWriteMask (rp, 0);
#endif	/* OS30_ONLY */
						ScrollRaster (rp, 0, scroll_dy,
							lv->GRect.MinX, lv->GRect.MinY,
							lv->GRect.MaxX,
							lv->GRect.MaxY);

#ifdef OS30_ONLY
						SetWriteMask (rp, oldmask);
#else
						SafeSetWriteMask (rp, oldmask);
#endif	/* OS30_ONLY */
					}

#ifndef OS30_ONLY
					/* Restore MaxPen in our RastPort */
					if (GfxBase->LibNode.lib_Version >= 39)
						SetMaxPen (rp, -1);
#endif /* OS30_ONLY */
				}

				/* Update OldTop to the current Top item and
				 * OldPixelTop to the current PixelTop position.
				 */
				lv->OldTop = lv->Top;
				lv->OldPixelTop = lv->PixelTop;

				break;
			}

			default:
				break;
		}

		if (lv->ClipRegion)
			/* Restore old clipping region in our layer */
			InstallClipRegion (rp->Layer, oldregion);

		if (oldfont)
			SetFont (rp, oldfont);
	}
	else if (msg->gpr_Redraw == GREDRAW_REDRAW)
	{
		/* Clear all gadget contents */
		SetAPen (rp, msg->gpr_GInfo->gi_DrInfo->dri_Pens[BACKGROUNDPEN]);
		RectFill (rp, lv->GRect.MinX, lv->GRect.MinY, lv->GRect.MaxX, lv->GRect.MaxY);
	}
}



static ULONG LV_GMGoActive (Class *cl, struct Gadget *g, struct gpInput *msg)
{
	struct LVData		*lv = INST_DATA (cl, g);

	ASSERT_VALIDNO0(lv)
	DB (kprintf ("GM_GOACTIVE: gpi_IEvent = $%lx\n", msg->gpi_IEvent);)


	if (!lv->Items)
		return GMR_NOREUSE;

	g->Flags |= GFLG_SELECTED;

	/* Do not process InputEvent when the gadget has been
	 * activated by ActivateGadget().
	 */
	if (!msg->gpi_IEvent)
		return GMR_MEACTIVE;

	/* Note: The input event that triggered the gadget
	 * activation (usually a mouse click) should be passed
	 * to the GM_HANDLEINPUT method, so we fall down to it.
	 */
	return LV_GMHandleInput (cl, g, msg);
}



INLINE LONG ItemHit (struct LVData *lv, WORD x, WORD y)

/* Determine which item has been hit with gadget relative
 * coordinates x and y.
 */
{
	return ((y + lv->PixelTop) / (lv->ItemHeight + lv->Spacing));
}



static ULONG LV_GMHandleInput (Class *cl, struct Gadget *g, struct gpInput *msg)
{
	struct LVData		*lv = INST_DATA (cl, g);
	struct InputEvent	*ie = msg->gpi_IEvent;
	ULONG				 result = GMR_MEACTIVE;

	ASSERT_VALIDNO0(lv)
/*	DB (kprintf ("GM_HANDLEINPUT: ie_Class = $%lx, ie->ie_Code = $%lx, "
		"gpi_Mouse.X = %ld, gpi_Mouse.Y = %ld\n",
		ie->ie_Class, ie->ie_Code, msg->gpi_Mouse.X, msg->gpi_Mouse.Y);)
*/
	switch (ie->ie_Class)
	{
		case IECLASS_RAWKEY:
		{
			LONG tags[5];
			LONG pos;

			switch (ie->ie_Code)
			{
				case CURSORUP:
					if ((lv->Flags & LVF_READONLY) || (ie->ie_Qualifier & IEQUALIFIER_CONTROL))
					{
						if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
							pos = lv->Top - lv->Visible / 2;
						else
							pos = lv->Top - 1;

						if (pos < 0) pos = 0;

						tags[0] = LVA_Top;
						tags[1] = pos;
						tags[2] = TAG_DONE;
					}
					else
					{
						if (ie->ie_Qualifier & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
							pos = 0;
						else if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
							pos = lv->Selected - lv->Visible + 1;
						else
							pos = lv->Selected - 1;

						if (pos < 0) pos = 0;

						tags[0] = LVA_Selected;
						tags[1] = pos;
						tags[2] = LVA_MakeVisible;
						tags[3] = pos;
						tags[4] = TAG_DONE;
					}
					break;

				case CURSORDOWN:
					if ((lv->Flags & LVF_READONLY) || (ie->ie_Qualifier & IEQUALIFIER_CONTROL))
					{
						if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
							pos = lv->Top + lv->Visible / 2;
						else
							pos = lv->Top + 1;

						tags[0] = LVA_Top;
						tags[1] = pos;
						tags[2] = TAG_DONE;
					}
					else
					{
						if (ie->ie_Qualifier & (IEQUALIFIER_LALT | IEQUALIFIER_RALT))
							pos = lv->Total - 1;
						else if (ie->ie_Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))
							pos = lv->Selected + lv->Visible - 1;
						else
							pos = lv->Selected + 1;

						tags[0] = LVA_Selected;
						tags[1] = pos;
						tags[2] = LVA_MakeVisible;
						tags[3] = pos;
						tags[4] = TAG_DONE;
					}
					break;

				default:
					tags[0] = TAG_DONE;

			} /* End switch (ie->ie_Code) */

			if (tags[0] != TAG_DONE)
				DoMethod ((Object *)g, OM_UPDATE, tags, msg->gpi_GInfo,
					(ie->ie_Qualifier & IEQUALIFIERB_REPEAT) ? OPUF_INTERIM : 0);

			break;
		}

		case IECLASS_RAWMOUSE:
		{
			LONG selected;

			switch (ie->ie_Code)
			{
				case SELECTDOWN:

					/* Check for click outside gadget box */

					if ((msg->gpi_Mouse.X < 0) ||
						(msg->gpi_Mouse.X >= lv->GBox.Width) ||
						(msg->gpi_Mouse.Y < 0) ||
						(msg->gpi_Mouse.Y >= lv->GBox.Height))
					{
						result = GMR_REUSE;
						break;
					}

					/* Start dragging mode */
					lv->Flags |= LVF_DRAGGING;

					if (lv->Flags & LVF_READONLY)
						break;

					/* Select an item */
					selected = ItemHit (lv, msg->gpi_Mouse.X, msg->gpi_Mouse.Y);

					/* No action when selecting over blank space in the bottom */
					if ((selected < 0) || (selected >= lv->Total))
						break;

					/* Backup current selection for RMB undo */
					lv->BackupSelected = lv->Selected;
					lv->BackupPixelTop = lv->PixelTop;

					if (selected == lv->Selected)
					{
						/* Check for double click */
						if (DoubleClick (lv->DoubleClickSecs, lv->DoubleClickMicros,
							ie->ie_TimeStamp.tv_secs, ie->ie_TimeStamp.tv_micro))
							UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
								LVA_DoubleClick, selected,
								TAG_DONE);
					}

					if (lv->Flags & LVF_DOMULTISELECT)
						/* Setup for multiple items drag selection */
						lv->DragSelect = IsItemSelected (lv, NULL, selected) ?
							LVA_DeselectItem : LVA_SelectItem;
					else if (g->Activation & GACT_TOGGLESELECT)
					{
						/* Setup for single item toggle */
						lv->DragSelect = LVA_Selected;
						if (selected == lv->Selected)
							selected = ~0;
					}
					else /* Single selection */
						/* Setup for single item drag selection */
						lv->DragSelect = LVA_Selected;

					UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
						lv->DragSelect, selected,
						TAG_DONE);

					/* Save double click info */
					lv->DoubleClickSecs = ie->ie_TimeStamp.tv_secs;
					lv->DoubleClickMicros = ie->ie_TimeStamp.tv_micro;
					break;

				case MENUDOWN:
					/* Undo selection & position when RMB is pressed */
					if (lv->Flags & (LVF_DRAGGING | LVF_SCROLLING))
					{
						/* Stop dragging and scrolling modes */
						lv->Flags &= ~(LVF_DRAGGING | LVF_SCROLLING);

						if ((lv->BackupSelected != lv->Selected) ||
							(lv->BackupPixelTop != lv->PixelTop))
						{
							UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
								(lv->Flags & LVF_READONLY) ?
									TAG_IGNORE : LVA_Selected, lv->BackupSelected,
								LVA_PixelTop, lv->BackupPixelTop,
								TAG_DONE);
						}
					}
					else
						/* Deactivate gadget on menu button press */
						result = GMR_REUSE;

					break;

				case MIDDLEDOWN:
					/* Argh, input.device never sends this event in V40! */
					DB (kprintf ("scrolling on\n");)

					/* Start MMB scrolling */
					lv->BackupPixelTop = lv->PixelTop;
					lv->BackupSelected = lv->Selected;
					lv->MiddleMouseY = msg->gpi_Mouse.Y;
					lv->Flags |= LVF_DRAGGING;
					break;

				case SELECTUP:

					/* Stop dragging mode */
					lv->Flags &= ~LVF_DRAGGING;

					if (g->Activation & GACT_RELVERIFY)
					{
						/* Send IDCMP_GADGETUP message to our parent window */
						msg->gpi_Termination = &lv->Selected;
						result = GMR_NOREUSE | GMR_VERIFY;
					}
					break;

				case MIDDLEUP:
					/* Argh, input.device never sends this event in V40! */
					DB (kprintf ("scrolling off\n");)

					/* Stop MMB scrolling */
					lv->Flags &= ~LVF_SCROLLING;
					break;

				default: /* Mouse moved */

					/* Holding LMB? */
					if (lv->Flags & LVF_DRAGGING)
					{
						/* Select an item */
						selected = ItemHit (lv, msg->gpi_Mouse.X, msg->gpi_Mouse.Y);

						/* Moved over another item inside the currently displayed list? */
						if ((selected != lv->Selected) && !(lv->Flags & LVF_READONLY)
							&& (selected >= lv->Top) && (selected < lv->Top + lv->Visible))
						{
							/* Single selection */

							/* Call our OM_UPDATE method to change the attributes.
							 * This will also send notification to targets and
							 * update the contents of the gadget.
							 */
							UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
								lv->DragSelect, selected,
								TAG_DONE);
						}
					}

					/* Holding MMB? */
					if (lv->Flags & LVF_SCROLLING)
					{
						DB (kprintf ("  scrolling\n");)
						selected = (msg->gpi_Mouse.Y - lv->MiddleMouseY)
							+ lv->BackupPixelTop;

						UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
							LVA_PixelTop, selected < 0 ? 0 : selected,
							TAG_DONE);
					}

			} /* End switch (ie->ie_Code) */

			break;
		}

		case IECLASS_TIMER:

			/* Holding LMB? */
			if (lv->Flags & LVF_DRAGGING)
			{
				/* Mouse above the upper item? */
				if ((msg->gpi_Mouse.Y < 0) && lv->Top)
				{
					/* Scroll up */
					UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
						LVA_MoveUp,	1,
						(lv->Flags & LVF_READONLY) ? TAG_IGNORE : LVA_Selected, lv->Top - 1,
						TAG_DONE);
				}
				/* Mouse below the bottom item? */
				else if (msg->gpi_Mouse.Y / (lv->ItemHeight + lv->Spacing) >= lv->Visible)
				{
					/* Scroll down */
					UpdateAttrs ((Object *)g, msg->gpi_GInfo, 0,
						LVA_MoveDown,		1,
						(lv->Flags & LVF_READONLY) ? TAG_IGNORE : LVA_Selected, lv->Top + lv->Visible,
						TAG_DONE);
				}
			}
			break;

		default:
			;

	} /* End switch (ie->ie_Class) */

	return result;
}



static void LV_GMGoInactive (Class *cl, struct Gadget *g, struct gpGoInactive *msg)
{
	struct LVData		*lv = INST_DATA (cl, g);
	ASSERT_VALIDNO0(lv)

	DB (kprintf ("GM_GOINACTIVE\n");)

	/* Stop dragging and scrolling modes */
	lv->Flags &= ~(LVF_DRAGGING | LVF_SCROLLING);

	/* Mark gadget inactive */
	g->Flags &= ~GFLG_SELECTED;
}



INLINE void GetGadgetBox (struct GadgetInfo *ginfo, struct ExtGadget *g, struct IBox *box, struct Rectangle *rect)

/* This function gets the actual IBox where a gadget exists
 * in a window.  The special cases it handles are all the REL#?
 * (relative positioning flags).
 *
 * The function takes a struct GadgetInfo pointer, a struct Gadget
 * pointer, a struct IBox pointer and a struct Rectangle pointer.
 * It uses the window and gadget to fill in the IBox and Rectangle
 * with the real gadget box size.
 */
{
	ASSERT_VALIDNO0(g)
	ASSERT_VALIDNO0(ginfo)
	ASSERT_VALIDNO0(box)
	ASSERT_VALIDNO0(rect)

	DB (if ((g->Flags & GFLG_EXTENDED) && (g->MoreFlags & GMORE_BOUNDS))
		kprintf ("  Gadget has valid bounds\n");)

	box->Left = g->LeftEdge;
	if (g->Flags & GFLG_RELRIGHT)
		box->Left += ginfo->gi_Domain.Width - 1;

	box->Top = g->TopEdge;
	if (g->Flags & GFLG_RELBOTTOM)
		box->Top += ginfo->gi_Domain.Height - 1;

	box->Width = g->Width;
	if (g->Flags & GFLG_RELWIDTH)
		box->Width += ginfo->gi_Domain.Width;

	box->Height = g->Height;
	if (g->Flags & GFLG_RELHEIGHT)
		box->Height += ginfo->gi_Domain.Height;

	/* Convert IBox to Rectangle coordinates system */
	rect->MinX = box->Left;
	rect->MinY = box->Top;
	rect->MaxX = box->Left + box->Width - 1;
	rect->MaxY = box->Top + box->Height - 1;
}



static void LV_GMLayout (Class *cl, struct Gadget *g, struct gpLayout *msg)
{
	struct LVData *lv = INST_DATA (cl, g);
	LONG visible;

	DB (kprintf ("GM_LAYOUT\n");)
	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(msg->gpl_GInfo)
	ASSERT_VALIDNO0(msg->gpl_GInfo->gi_DrInfo)
	ASSERT_VALIDNO0(msg->gpl_GInfo->gi_DrInfo->dri_Font)


	/* We shouldn't draw inside the GM_LAYOUT method: the
	 * GM_REDRAW method will be called by Intuition shortly after.
	 */
	lv->Flags |= LVF_DONTDRAW;

	GetGadgetBox (msg->gpl_GInfo, (struct ExtGadget *)g, &lv->GBox, &lv->GRect);

	/* Calculate clipping region for gadget LVA_Clipped mode */
	if (lv->ClipRegion)
	{
		/* Remove previous clipping rectangle, if any */
		ClearRegion (lv->ClipRegion);

		/* Install a clipping rectangle around the gadget box.
		 * We don't check for failure because we couldn't do
		 * anything to recover.
		 */
		OrRectRegion (lv->ClipRegion, &lv->GRect);
	}

	/* Setup Font if not yet done */
	if (!lv->Font)
	{
		lv->Font = msg->gpl_GInfo->gi_DrInfo->dri_Font;
		if (!lv->ItemHeight)
			lv->ItemHeight = lv->Font->tf_YSize;
	}

	if (lv->ItemHeight)
	{
		if (lv->ClipRegion)
			/* Allow displaying an incomplete item at the bottom of the listview,
			 * plus one incomplete item at the top.
			 */
			visible = (lv->GBox.Height + lv->ItemHeight + lv->Spacing - 1) /
				(lv->ItemHeight + lv->Spacing);
		else
			/* get maximum number of items fitting in the listview height.
			 * Ignore spacing for the last visible item.
			 */
			visible = (lv->GBox.Height + lv->Spacing) / (lv->ItemHeight + lv->Spacing);
	}
	else
		visible = 0;

	lv->MaxScroll = lv->GBox.Height / lv->ScrollRatio;


	/* Send initial notification to our sliders, or update them to
	 * the new values. The slieders will get the correct size also
	 * in the special case where the list is attached at creation
	 * time and the sliders are attached later using a model object.
	 *
	 * The private class attribute LVA_Visible will handle everything for us.
	 */
	UpdateAttrs ((Object *)g, msg->gpl_GInfo, 0,
		LVA_Visible,	visible,
		TAG_DONE);

	/* Re-enable drawing */
	lv->Flags &= ~LVF_DONTDRAW;
}



static ULONG LV_OMSet (Class *cl, struct Gadget *g, struct opUpdate *msg)
{
	struct LVData	*lv = INST_DATA (cl, g);
	struct TagItem	*ti,
					*tstate	= msg->opu_AttrList;
	ULONG	result;
	UWORD	action = 0;	/* See flag definitions above */

	ASSERT_VALIDNO0(lv)
	ASSERT_VALID(tstate)

	DB (kprintf ((msg->MethodID == OM_SET) ? "OM_SET:\n" : "OM_UPDATE:\n");)


	/* Definitions for the ations to be taken right after
	 * scanning the attributes list in OM_SET/OM_UPDATE.
	 * For speed reasons we pack them together in a single variable,
	 * so we can set and test multiple flags in once.
	 */
	#define LVF_DO_SUPER_METHOD	(1<<0)
	#define LVF_REDRAW			(1<<1)
	#define LVF_SCROLL			(1<<2)
	#define LVF_TOGGLESELECT	(1<<3)
	#define LVF_NOTIFY			(1<<4)
	#define LVF_NOTIFYALL		(1<<5)


	while (ti = NextTagItem (&tstate))
		switch (ti->ti_Tag)
		{
			case GA_ID:
				DB (kprintf ("  GA_ID, %ld\n", ti->ti_Data);)

				/* Avoid sending all taglists to our superclass because of GA_ID */
				g->GadgetID = ti->ti_Data;
				break;

			case LVA_Selected:
				DB (kprintf ("  LVA_Selected, %ld\n", ti->ti_Data);)

				if (lv->Items)
				{
					LONG newselected = ti->ti_Data;

					if (newselected != ~0)
						newselected = (newselected >= lv->Total) ?
							(lv->Total - 1) : newselected;

					if (lv->Selected != newselected)
					{
						if (((lv->Selected >= lv->Top) &&
							(lv->Selected < lv->Top + lv->Visible)) ||
							((newselected >= lv->Top) &&
							(newselected < lv->Top + lv->Visible)))
							action |= LVF_TOGGLESELECT;

						lv->Selected = newselected;

						if (newselected == ~0)
							lv->SelectedPtr = NULL;
						else
							lv->SelectedPtr = GetItem (lv, newselected);

						action |= LVF_NOTIFY;
					}
				}
				break;

			case LVA_Top:
				DB (kprintf ("  LVA_Top, %ld\n", ti->ti_Data);)

				if ((lv->Top != ti->ti_Data) && lv->Items)
				{
					/* This will scroll the listview contents when needed */

					lv->Top = ((ti->ti_Data + lv->Visible) >= lv->Total) ?
						((lv->Total <= lv->Visible) ? 0 : (lv->Total - lv->Visible))
						: ti->ti_Data;
					lv->PixelTop = lv->Top * (lv->ItemHeight + lv->Spacing);

					/* TODO: optimize for some special cases:
					 * Top == oldtop + 1 and Top == oldtop - 1
					 */
					lv->TopPtr = GetItem (lv, lv->Top);
					action |= LVF_SCROLL | LVF_NOTIFY;
				}
				break;

			case LVA_Total:
				DB (kprintf ("  LVA_Total, %ld\n", ti->ti_Data);)

				/* We don't hhandle LVA_Total except when setting a new
				 * list or array of items.
				 */
				break;

			case LVA_SelectItem:
				DB (kprintf ("  LVA_SelectItem, %ld\n", ti->ti_Data);)

				/* Check LVA_MaxSelect */
				if (lv->SelectCount >= lv->MaxSelect)
					DisplayBeep (msg->opu_GInfo ? msg->opu_GInfo->gi_Screen : NULL);
				else if (lv->Items)
				{
					LONG newselected = (ti->ti_Data >= lv->Total) ?
						(lv->Total - 1) : ti->ti_Data;

					if (((lv->Selected >= lv->Top) &&
						(lv->Selected < lv->Top + lv->Visible)) ||
						((newselected >= lv->Top) &&
						(newselected < lv->Top + lv->Visible)))
						action |= LVF_TOGGLESELECT;

					lv->Selected = newselected;
					lv->SelectedPtr = GetItem (lv, newselected);

					if (!IsItemSelected (lv, lv->SelectedPtr, newselected))
					{
						lv->SelectCount++;

						if (lv->SelectArray)
							lv->SelectArray[newselected] = lv->SelectCount;
						else if (lv->Flags & LVF_LIST)
							((struct Node *)lv->SelectedPtr)->ln_Type = lv->SelectCount;
					}
					action |= LVF_NOTIFY;
				}
				break;

			case LVA_DeselectItem:
				DB (kprintf ("  LVA_DeselectItem, %ld\n", ti->ti_Data);)

				if (lv->Items)
				{
					LONG newselected = (ti->ti_Data >= lv->Total) ?
						(lv->Total - 1) : ti->ti_Data;

					if (((lv->Selected >= lv->Top) &&
						(lv->Selected < lv->Top + lv->Visible)) ||
						((newselected >= lv->Top) &&
						(newselected < lv->Top + lv->Visible)))
						action |= LVF_TOGGLESELECT;

					lv->Selected = newselected;
					lv->SelectedPtr = GetItem (lv, newselected);

					if (IsItemSelected (lv, lv->SelectedPtr, newselected))
					{
						lv->SelectCount--;

						if (lv->SelectArray)
							lv->SelectArray[lv->Selected] = 0;
						else if (lv->Flags & LVF_LIST)
							((struct Node *)lv->SelectedPtr)->ln_Type = 0;

						action |= LVF_NOTIFY;
					}
				}
				break;

			case LVA_ToggleItem:
				DB (kprintf ("  LVA_ToggleItem, %ld\n", ti->ti_Data);)

				if (lv->Items)
				{
					LONG newselected = newselected = (ti->ti_Data >= lv->Total) ?
						(lv->Total - 1) : ti->ti_Data;

					if (((lv->Selected >= lv->Top) &&
						(lv->Selected < lv->Top + lv->Visible)) ||
						((newselected >= lv->Top) &&
						(newselected < lv->Top + lv->Visible)))
						action |= LVF_TOGGLESELECT;

					lv->Selected = newselected;
					lv->SelectedPtr = GetItem (lv, newselected);

					if (IsItemSelected (lv, lv->SelectedPtr, lv->Selected))
					{
						/* Deselect */
						lv->SelectCount--;

						if (lv->SelectArray)
							lv->SelectArray[lv->Selected] = 0;
						else if (lv->Flags & LVF_LIST)
							((struct Node *)lv->SelectedPtr)->ln_Type = 0;
					}
					else
					{
						/* Check LVA_MaxSelect */
						if (lv->SelectCount >= lv->MaxSelect)
							DisplayBeep (msg->opu_GInfo ? msg->opu_GInfo->gi_Screen : NULL);
						else
						{
							/* Select */
							lv->SelectCount++;

							if (lv->SelectArray)
								lv->SelectArray[lv->Selected] = lv->SelectCount;
							else if (lv->Flags & LVF_LIST)
								((struct Node *)lv->SelectedPtr)->ln_Type = lv->SelectCount;
						}
					}

					action |= LVF_NOTIFY;
				}
				break;

			case LVA_ClearSelected:
				DB (kprintf ("  LVA_ClearSelected, %ld\n", ti->ti_Data);)

				if (lv->Items)
				{
					LONG newselected = ti->ti_Data;
					LONG i;

					if (((lv->Selected >= lv->Top) &&
						(lv->Selected < lv->Top + lv->Visible)) ||
						((newselected >= lv->Top) &&
						(newselected < lv->Top + lv->Visible)))
						action |= LVF_TOGGLESELECT;

					lv->Selected = ~0;
					lv->SelectedPtr = NULL;
					lv->SelectCount = 0;


					/* Clear the selections */

					if (lv->SelectArray)
						for (i = 0; i < lv->Total; i++)
							lv->SelectArray[i] = 0;
					else if (lv->Flags & LVF_LIST)
					{
						struct Node *node;

						for (node = ((struct List *)lv->Items)->lh_Head;
							node = node->ln_Succ;
							node->ln_Type = 0)
							ASSERT_VALID(node);
					}

					/* TODO: check if total redraw is really needed */
					action |= LVF_REDRAW | LVF_NOTIFY;
				}
				break;

			case LVA_MakeVisible:
			{
				LONG itemnum = ti->ti_Data;

				DB (kprintf ("  LVA_MakeVisible, %ld\n", ti->ti_Data);)

				if (itemnum < 0)
					itemnum = 0;

				if (itemnum >= lv->Total)
					itemnum = lv->Total - 1;

				if (itemnum < lv->Top)
				{
					/* Scroll up */

					lv->Top = itemnum;
					lv->TopPtr = GetItem (lv, lv->Top);
					action |= LVF_SCROLL | LVF_NOTIFY;
				}
				else if (itemnum >= lv->Top + lv->Visible)
				{
					/* Scroll down */

					lv->Top = itemnum - lv->Visible + 1;
					lv->TopPtr = GetItem (lv, lv->Top);
					action |= LVF_SCROLL | LVF_NOTIFY;
				}
				break;
			}

			case LVA_MoveUp:
				DB (kprintf ("  LVA_MoveUp, %ld\n", ti->ti_Data);)

				if ((lv->Top > 0) && lv->Items)
				{
					lv->Top--;
					lv->TopPtr = GetPrev (lv, lv->TopPtr, lv->Top);
					action |= LVF_SCROLL | LVF_NOTIFY;
				}
				break;

			case LVA_MoveDown:
				DB (kprintf ("  LVA_MoveDown, %ld\n", ti->ti_Data);)

				if ((lv->Top + lv->Visible < lv->Total) && lv->Items)
				{
					lv->Top++;
					lv->TopPtr = GetNext (lv, lv->TopPtr, lv->Top);
					action |= LVF_SCROLL | LVF_NOTIFY;
				}
				break;

			case LVA_MoveLeft:
				DB (kprintf ("  Unimplemented attr: LVA_MoveLeft\n");)
				break;

			case LVA_MoveRight:
				DB (kprintf ("  Unimplemented attr: LVA_MoveRight\n");)
				break;

			case LVA_StringList:
				DB (kprintf ("  LVA_StringList, $%lx\n", ti->ti_Data);)

				if (ti->ti_Data == ~0)
					lv->Items = NULL;
				else
				{
					ASSERT_VALID(ti->ti_Data)

					lv->Items = (void *) ti->ti_Data;
					lv->GetItemFunc		= ListGetItem;
					lv->GetNextFunc		= ListGetNext;
					lv->GetPrevFunc		= ListGetPrev;
					lv->DrawItemFunc	= ListStringDrawItem;
					lv->Flags |= LVF_LIST;

					lv->Total = GetTagData (LVA_Total, ~0, msg->opu_AttrList);
					if (lv->Total == ~0)
						lv->Total = CountNodes (lv->Items);

					lv->SelectCount = CountSelections (lv);

					action |= LVF_REDRAW | LVF_NOTIFYALL;
				}
				break;

			case LVA_StringArray:
				DB (kprintf ("  LVA_StringArray, $%lx\n", ti->ti_Data);)

				if (ti->ti_Data == ~0)
					lv->Items = NULL;
				else
				{
					ASSERT_VALID(ti->ti_Data)

					lv->Items = (void *) ti->ti_Data;
					lv->GetItemFunc		= ArrayGetItem;
					lv->GetNextFunc		= ArrayGetItem;
					lv->GetPrevFunc		= ArrayGetItem;
					lv->DrawItemFunc	= StringDrawItem;
					lv->Flags &= ~LVF_LIST;

					lv->Total = GetTagData (LVA_Total, ~0, msg->opu_AttrList);
					if ((lv->Total == ~0) && lv->Items)
					{
						/* Count items */
						ULONG i = 0;
						while (((APTR *)lv->Items)[i]) i++;
						lv->Total = i;
					}

					lv->SelectCount = CountSelections(lv);

					action |= LVF_REDRAW | LVF_NOTIFYALL;
				}
				break;

			case LVA_ImageList:
				DB (kprintf ("  LVA_ImageList, $%lx\n", ti->ti_Data);)

				if (ti->ti_Data == ~0)
					lv->Items = NULL;
				else
				{
					ASSERT_VALID(ti->ti_Data)

					lv->Items = (void *) ti->ti_Data;
					lv->GetItemFunc		= ListGetItem;
					lv->GetNextFunc		= ListGetNext;
					lv->GetPrevFunc		= ListGetPrev;
					lv->DrawItemFunc	= ListImageDrawItem;
					lv->Flags |= LVF_LIST;

					lv->Total = GetTagData (LVA_Total, ~0, msg->opu_AttrList);
					if (lv->Total == ~0)
						lv->Total = CountNodes (lv->Items);

					lv->SelectCount = CountSelections(lv);

					action |= LVF_REDRAW | LVF_NOTIFYALL;
				}
				break;

			case LVA_ImageArray:
				DB (kprintf ("  LVA_ImageArray, $%lx\n", ti->ti_Data);)

				if (ti->ti_Data == ~0)
					lv->Items = NULL;
				else
				{
					ASSERT_VALID(ti->ti_Data)

					lv->Items = (void *) ti->ti_Data;
					lv->GetItemFunc		= ArrayGetItem;
					lv->GetNextFunc		= ArrayGetItem;
					lv->GetPrevFunc		= ArrayGetItem;
					lv->DrawItemFunc	= ImageDrawItem;
					lv->Flags &= ~LVF_LIST;

					lv->Total = GetTagData (LVA_Total, ~0, msg->opu_AttrList);
					if ((lv->Total == ~0) && lv->Items)
					{
						/* Count items */
						ULONG i = 0;
						while (((APTR *)lv->Items)[i]) i++;
						lv->Total = i;
					}

					action |= LVF_REDRAW | LVF_NOTIFYALL;
				}
				break;

			case LVA_CustomList:
				DB (kprintf ("  LVA_CustomList, $%lx\n", ti->ti_Data);)

				if (ti->ti_Data == ~0)
					lv->Items = NULL;
				else
				{
					ASSERT_VALID(ti->ti_Data)

					lv->Items = (void *) ti->ti_Data;
					lv->SelectCount = CountSelections (lv);

					action |= LVF_REDRAW | LVF_NOTIFYALL;
				}
				break;

			case LVA_Visible:
				DB (kprintf ("  LVA_Visible, %ld\n", ti->ti_Data);)

				/* This attribute can only be set internally, and will
				 * trigger a full slider notification.
				 */
				lv->Visible = ti->ti_Data;
				action |= LVF_NOTIFYALL;


				/* Also scroll the ListView if needed. */
				if (lv->ClipRegion)
				{
					LONG height = lv->Total * (lv->ItemHeight + lv->Spacing);
					LONG newtop;

					if (lv->PixelTop + lv->GBox.Height >= height)
					{
						lv->PixelTop = height - lv->GBox.Height;
						if (lv->PixelTop < 0)
							lv->PixelTop = 0;

						newtop = lv->PixelTop / (lv->ItemHeight + lv->Spacing);
						if (newtop != lv->Top)
						{
							lv->Top = newtop;
							lv->TopPtr = GetItem (lv, newtop);
						}
						action |= LVF_SCROLL;
					}
				}
				else if (lv->Top + lv->Visible >= lv->Total)
				{
					lv->Top = (lv->Total <= lv->Visible) ? 0 : (lv->Total - lv->Visible);
					lv->TopPtr = GetItem (lv, lv->Top);
					lv->PixelTop = lv->Top * (lv->ItemHeight + lv->Spacing);
					action |= LVF_SCROLL;
				}
				break;

			case LVA_SelectArray:
				DB (kprintf ("  LVA_SelectArray, $%lx\n", ti->ti_Data);)
				ASSERT_VALID(ti->ti_Data)

				lv->SelectArray = (ULONG *) ti->ti_Data;
				lv->SelectCount = CountSelections (lv);
				action |= LVF_REDRAW;
				break;

			case LVA_MaxSelect:
				DB (kprintf ("  LVA_MaxSelect, %ld\n", ti->ti_Data);)

				lv->MaxSelect = ti->ti_Data;
				/* NOTE: We are not checking lv->SelectCount */
				break;

			case LVA_PixelTop:	/* Handle pixel-wise scrolling */
				DB (kprintf ("  LVA_PixelTop, %ld\n", ti->ti_Data);)

				if (ti->ti_Data != lv->PixelTop && lv->Items && lv->ItemHeight)
				{
					LONG newtop;

					lv->PixelTop = ti->ti_Data;
					action |= LVF_SCROLL;

					newtop = lv->PixelTop / (lv->ItemHeight + lv->Spacing);
					newtop = ((newtop + lv->Visible) >= lv->Total) ?
						((lv->Total <= lv->Visible) ? 0 : (lv->Total - lv->Visible))
						: newtop;

					if (newtop != lv->Top)
					{
						/* TODO: optimize GetItem for some special cases:
						 * Top = oldtop + 1 and Top = oldtop - 1
						 */
						lv->Top = newtop;
						lv->TopPtr = GetItem (lv, newtop);
						action |= LVF_NOTIFY | LVF_SCROLL;
					}
				}
				break;

			case LVA_ScrollRatio:
				DB (kprintf ("  LVA_ScrollRatio, %ld\n", ti->ti_Data);)
				ASSERT(ti->ti_Data != 0)

				lv->ScrollRatio = ti->ti_Data;
				lv->MaxScroll = lv->GBox.Height / lv->ScrollRatio;
				break;

			default:
				DB (kprintf ("  Passing unknown tag to superclass: $%lx, %ld\n",
					ti->ti_Tag, ti->ti_Data);)

				/* This little optimization avoids forwarding the
				 * OM_SET method to our superclass then there are
				 * no unknown tags.
				 */
				action |= LVF_DO_SUPER_METHOD;
				break;
		}

	DB(kprintf ("  TAG_DONE\n");)

	/* Forward method to our superclass dispatcher, only if needed */

	if (action & LVF_DO_SUPER_METHOD)
		result = (DoSuperMethodA (cl, (Object *)g, (Msg) msg));
	else
		result = TRUE;


	/* Update gadget imagery, only when needed */

	if ((action & (LVF_REDRAW | LVF_SCROLL | LVF_TOGGLESELECT))
		&& msg->opu_GInfo && !(lv->Flags & LVF_DONTDRAW))
	{
		struct RastPort *rp;

		if (rp = ObtainGIRPort (msg->opu_GInfo))
		{
			/* Just redraw everything */
			if (action & LVF_REDRAW)
				DoMethod ((Object *)g, GM_RENDER, msg->opu_GInfo, rp, GREDRAW_REDRAW);
			else
			{
				/* Both these may happen at the same time */

				if (action & LVF_SCROLL)
					DoMethod ((Object *)g, GM_RENDER, msg->opu_GInfo, rp,
						GREDRAW_UPDATE);

				if (action & LVF_TOGGLESELECT)
					DoMethod ((Object *)g, GM_RENDER, msg->opu_GInfo, rp,
						GREDRAW_TOGGLE);
			}

			ReleaseGIRPort (rp);
		}
		DB(else kprintf ("*** ObtainGIRPort() failed!\n");)
	}


	/* Notify our targets about changed attributes */

	if (action & LVF_NOTIFYALL)
	{
		DB(kprintf("OM_NOTIFY: ALL\n");)
		DB(kprintf("  LVA_Top,           %ld\n", lv->Top);)
		DB(kprintf("  LVA_Total,         %ld\n", lv->Total);)
		DB(kprintf("  LVA_Visible,       %ld\n", lv->Visible);)
		DB(kprintf("  LVA_Selected,      %ld\n", lv->Selected);)
		DB(kprintf("  LVA_PixelTop,      %ld\n", lv->PixelTop);)
		DB(kprintf("  LVA_PixelHeight,   %ld\n", lv->Total * (lv->ItemHeight + lv->Spacing));)
		DB(kprintf("  LVA_PixelVVisible, %ld\n", lv->GBox.Height);)
		DB(kprintf("  TAG_DONE\n");)

		NotifyAttrs ((Object *)g, msg->opu_GInfo,
			(msg->MethodID == OM_UPDATE) ? msg->opu_Flags : 0,
			LVA_Top,			lv->Top,
			LVA_Total,			lv->Total,
			LVA_Visible,		lv->Visible,
			LVA_Selected,		lv->Selected,
			LVA_PixelTop,		lv->PixelTop,
			LVA_PixelHeight,	lv->Total * (lv->ItemHeight + lv->Spacing),
			LVA_PixelVVisible,	lv->ClipRegion ?
									lv->GBox.Height :
									lv->Visible * (lv->ItemHeight + lv->Spacing),
			GA_ID,				g->GadgetID,
			TAG_DONE);
	}
	else if (action & LVF_NOTIFY)
	{
		IPTR tags[9];
		int cnt = 0;

		if (action & LVF_SCROLL)
		{
			tags[0] = LVA_Top;			tags[1] = lv->Top;
			tags[2] = LVA_PixelTop;		tags[3] = lv->Top * (lv->ItemHeight + lv->Spacing);
			cnt = 4;
		}

		if (action & LVF_TOGGLESELECT)
		{
			tags[cnt++] = LVA_Selected;	tags[cnt++] = lv->Selected;
		}

		tags[cnt++]	= GA_ID;
		tags[cnt++]	= g->GadgetID;
		tags[cnt]	= TAG_DONE;

		DoMethod ((Object *)g, OM_NOTIFY, tags, msg->opu_GInfo,
			(msg->MethodID == OM_UPDATE) ? msg->opu_Flags : 0);
	}

	return result;
}



static ULONG LV_OMGet (Class *cl, struct Gadget *g, struct opGet *msg)
{
	struct LVData *lv = INST_DATA (cl, g);

	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(msg->opg_Storage)

	DB (kprintf ("OM_GET\n");)


	switch (msg->opg_AttrID)
	{
		case LVA_Selected:
			*msg->opg_Storage = (ULONG) lv->Selected;
			return TRUE;

		case LVA_Top:
			*msg->opg_Storage = (ULONG) lv->Top;
			return TRUE;

		case LVA_Total:
			*msg->opg_Storage = (ULONG) lv->Total;
			return TRUE;

		case LVA_StringList:
		case LVA_StringArray:
		case LVA_ImageList:
		case LVA_ImageArray:
		case LVA_CustomList:
			*msg->opg_Storage = (ULONG) lv->Items;
			return TRUE;

		case LVA_Visible:
			*msg->opg_Storage = (ULONG) lv->Visible;
			return TRUE;

		case LVA_SelectedPtr:
			*msg->opg_Storage = (ULONG) lv->SelectedPtr;
			return TRUE;

		case LVA_SelectArray:
			*msg->opg_Storage = (ULONG) lv->SelectArray;
			return TRUE;

		default:
			return DoSuperMethodA (cl, (Object *)g, (Msg) msg);
	}
}



static ULONG LV_OMNew (Class *cl, struct Gadget *g, struct opSet *msg)
{
	struct LVData	*lv;
	struct TagItem	*tag;
	struct DrawInfo	*drawinfo;


	DB (kprintf ("OM_NEW\n");)

	if (g = (struct Gadget *)DoSuperMethodA (cl, (Object *)g, (Msg)msg))
	{
		/* Set the GMORE_SCROLLRASTER flag */
		if (g->Flags & GFLG_EXTENDED)
		{
			DB (kprintf ("  Setting GMORE_SCROLLRASTER\n");)
			((struct ExtGadget *)g)->MoreFlags |= GMORE_SCROLLRASTER;
		}

		lv = (struct LVData *) INST_DATA (cl, (Object *)g);
		ASSERT_VALIDNO0(lv)

		/* Handle creation-time attributes */

		/* Map boolean attributes */
		{
			static IPTR boolMap[] =
			{
				GA_ReadOnly,		LVF_READONLY,
				LVA_Clipped,		LVF_CLIPPED,
				LVA_ShowSelected,	LVF_SHOWSELECTED,
				LVA_DoMultiSelect,	LVF_DOMULTISELECT,
				TAG_DONE
			};

			lv->Flags = PackBoolTags (
				LVF_SHOWSELECTED,
				msg->ops_AttrList,
				(struct TagItem *)boolMap);
		}


		/* Select font to use when drawing the Listview labels */
		{
			/* First, try to get it from our DrawInfo */

			if (drawinfo = (struct DrawInfo *)
				GetTagData (GA_DrawInfo, NULL, msg->ops_AttrList))
			{
				ASSERT_VALID(drawinfo)
				lv->Font = drawinfo->dri_Font;
			}
			else
				lv->Font = NULL;

			/* Override it with LVA_TextFont */

			if (tag = FindTagItem (LVA_TextFont, msg->ops_AttrList))
			{
				if (tag->ti_Data)
				{
					lv->Font = (struct TextFont *)tag->ti_Data;
					ASSERT_VALID(lv->Font)
				}
			}
			else	/* Otherwise, try GA_TextAttr */
			{
				struct TextAttr *attr;
				struct TextFont *font;

				if (attr = (struct TextAttr *)GetTagData (GA_TextAttr,
					NULL, msg->ops_AttrList))
				{
					if (font = OpenFont (attr))
					{
						/* Must remember to close this font later */
						lv->Flags |= LVF_CLOSEFONT;
						lv->Font = font;
					}
				}
			}

			/* Get font Y size */

			if (lv->Font)
				lv->ItemHeight = lv->Font->tf_YSize;
			else
				lv->ItemHeight = 0;
		}

		lv->ItemHeight = GetTagData (LVA_ItemHeight, lv->ItemHeight, msg->ops_AttrList);
		lv->Spacing = GetTagData (LAYOUTA_Spacing, 0, msg->ops_AttrList);

		if (tag = FindTagItem (LVA_MaxPen, msg->ops_AttrList))
			lv->MaxPen = tag->ti_Data;
		else
		{
			if (drawinfo)
				lv->MaxPen = max (
					max (drawinfo->dri_Pens[BACKGROUNDPEN],
						drawinfo->dri_Pens[TEXTPEN]),
					max (drawinfo->dri_Pens[FILLPEN],
						drawinfo->dri_Pens[FILLTEXTPEN]));
			else
				lv->MaxPen = (ULONG)-1;
		}


		lv->Total = GetTagData (LVA_Total, ~0, msg->ops_AttrList);

		if (lv->Items = (APTR) GetTagData (LVA_StringList, NULL, msg->ops_AttrList))
		{
			ASSERT_VALID(lv->Items)
			lv->GetItemFunc = ListGetItem;
			lv->GetNextFunc = ListGetNext;
			lv->GetPrevFunc = ListGetPrev;
			lv->DrawItemFunc = ListStringDrawItem;
			lv->Flags |= LVF_LIST;

			if (lv->Total == ~0)
				lv->Total = CountNodes (lv->Items);
		}
		else if (lv->Items = (APTR) GetTagData (LVA_StringArray, NULL, msg->ops_AttrList))
		{
			ASSERT_VALID(lv->Items)
			lv->GetItemFunc = ArrayGetItem;
			lv->GetNextFunc = ArrayGetItem;
			lv->GetPrevFunc = ArrayGetItem;
			lv->DrawItemFunc = StringDrawItem;

			if (lv->Total == ~0)
			{
				/* Count items */
				ULONG i = 0;
				while (((APTR *)lv->Items)[i]) i++;
				lv->Total = i;
			}
		}
		else if (lv->Items = (APTR) GetTagData (LVA_ImageList, NULL, msg->ops_AttrList))
		{
			ASSERT_VALID(lv->Items)
			lv->GetItemFunc = ListGetItem;
			lv->GetNextFunc = ListGetNext;
			lv->GetPrevFunc = ListGetPrev;
			lv->DrawItemFunc = ListImageDrawItem;
			lv->Flags |= LVF_LIST;

			if (lv->Total == ~0)
				lv->Total = CountNodes (lv->Items);
		}
		else if (lv->Items = (APTR) GetTagData (LVA_ImageArray, NULL, msg->ops_AttrList))
		{
			ASSERT_VALID(lv->Items)
			lv->GetItemFunc = ArrayGetItem;
			lv->GetNextFunc = ArrayGetItem;
			lv->GetPrevFunc = ArrayGetItem;
			lv->DrawItemFunc = ImageDrawItem;

			if (lv->Total == ~0)
			{
				/* Count items */
				ULONG i = 0;
				while (((APTR *)lv->Items)[i]) i++;
				lv->Total = i;
			}
		}

		lv->SelectArray = (ULONG *)GetTagData (LVA_SelectArray, NULL, msg->ops_AttrList);
		lv->MaxSelect = GetTagData (LVA_MaxSelect, -1, msg->ops_AttrList);
		lv->SelectCount = CountSelections(lv);

		if (lv->Visible = GetTagData (LVA_Visible, 0, msg->ops_AttrList))
		{
			SetAttrs (g,
				GA_Height, lv->Visible * (lv->ItemHeight + lv->Spacing),
				TAG_DONE);
		}

		/* Initialize Top and all related values */

		lv->OldTop = lv->Top = GetTagData (LVA_MakeVisible,
			GetTagData (LVA_Top, 0, msg->ops_AttrList), msg->ops_AttrList);
		lv->OldPixelTop = lv->PixelTop = lv->Top * (lv->ItemHeight + lv->Spacing);

		if (lv->Items)
			lv->TopPtr = GetItem (lv, lv->Top);

		lv->ScrollRatio = GetTagData (LVA_ScrollRatio, 2, msg->ops_AttrList);
		ASSERT(lv->ScrollRatio != 0)

		if ((lv->OldSelected =
			lv->Selected = GetTagData (LVA_Selected, ~0, msg->ops_AttrList)) != ~0)
			lv->SelectedPtr = GetItem (lv, lv->Selected);

		if (lv->CallBack = (struct Hook *)GetTagData (LVA_CallBack, NULL,
			msg->ops_AttrList))
		{
			ASSERT_VALID(lv->CallBack->h_Entry)
			lv->DrawItemFunc = (LVDrawHook *) lv->CallBack->h_Entry;
		}

		if (lv->Flags & LVF_CLIPPED)
			lv->ClipRegion = NewRegion ();
	}
	return (ULONG)g;
}



static void LV_OMDispose (Class *cl, struct Gadget *g, Msg msg)
{
	struct LVData	*lv;

	lv = (struct LVData *) INST_DATA (cl, (Object *)g);

	ASSERT_VALIDNO0(lv)
	DB (kprintf ("OM_DISPOSE\n");)

	if (lv->ClipRegion)
		DisposeRegion (lv->ClipRegion);

	if (lv->Flags & LVF_CLOSEFONT)
		CloseFont (lv->Font);

	/* Our superclass will cleanup everything else now */
	DoSuperMethodA (cl, (Object *)g, (Msg) msg);

	/* From now on, our instance data is no longer available */
}



/* Misc support functions */

INLINE ULONG CountNodes (struct List *list)

/* Return the number of nodes in a list */
{
	struct Node *node;
	ULONG count = 0;

	if (list)
	{
		ASSERT_VALID(list)

		for (node = list->lh_Head; node = node->ln_Succ; count++)
			ASSERT_VALID(node);
	}

	return count;
}



static ULONG CountSelections (struct LVData *lv)

/* Count the number of selections in a multiselect listview */
{
	ULONG count = 0;

	ASSERT_VALIDNO0(lv)


	if (lv->Flags & LVF_DOMULTISELECT)
	{
		if (lv->SelectArray)
		{
			int i;

			ASSERT_VALID(lv->SelectArray)

			for (i = 0; i < lv->Total; i++)
				if (lv->SelectArray[i])
					count++;
		}
		else if ((lv->Flags & LVF_LIST) && lv->Items)
		{
			struct Node *node;

			ASSERT_VALID(lv->Items)

			for (node = ((struct List *)lv->Items)->lh_Head; node = node->ln_Succ; count++)
				ASSERT_VALID(node);
		}
	}

	return count;
}



INLINE ULONG IsItemSelected (struct LVData *lv, APTR item, ULONG num)

/* Checks if the given item is selected */
{
	ASSERT_VALIDNO0(lv)
	ASSERT_VALID(item)
	ASSERT(num >= 0)
	ASSERT(num < lv->Total)


	if (lv->Flags & LVF_DOMULTISELECT)
	{
		if (lv->SelectArray)
		{
			ASSERT(num < lv->Total)

			return lv->SelectArray[num];
		}
		else if (lv->Flags & LVF_LIST)
		{
			if (!item)
				item = GetItem (lv, num);

			ASSERT_VALIDNO0(item)

			return item ? (ULONG)(((struct Node *)item)->ln_Type) : 0;
		}

		return 0;
	}
	else
		return ((ULONG)(num == lv->Selected));
}



INLINE APTR GetItem (struct LVData *lv, ULONG num)

/* Stub for LV_GETITEM hook method */
{
	struct lvGetItem lvgi;


	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(lv->Items)
	ASSERT_VALIDNO0(lv->GetItemFunc)
	ASSERT(num >= 0)
	ASSERT(num < lv->Total)


	lvgi.lvgi_MethodID	= LV_GETITEM;
	lvgi.lvgi_Number	= num;
	lvgi.lvgi_Items		= lv->Items;

	return (lv->GetItemFunc (lv->CallBack, NULL, &lvgi));
}



INLINE APTR GetNext (struct LVData *lv, APTR item, ULONG num)

/* Stub for LV_GETNEXT hook method */
{
	struct lvGetItem lvgi;


	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(lv->GetNextFunc)
	ASSERT_VALID(item)
	ASSERT(num >= 0)
	ASSERT(num < lv->Total)


	lvgi.lvgi_MethodID	= LV_GETNEXT;
	lvgi.lvgi_Number	= num;
	lvgi.lvgi_Items		= lv->Items;

	return (lv->GetNextFunc (lv->CallBack, item, &lvgi));
}



INLINE APTR GetPrev (struct LVData *lv, APTR item, ULONG num)

/* Stub for LV_GETPREV hook method */
{
	struct lvGetItem lvgi;


	ASSERT_VALIDNO0(lv)
	ASSERT_VALIDNO0(lv->GetPrevFunc)
	ASSERT_VALID(item)
	ASSERT(num >= 0)
	ASSERT(num < lv->Total)


	lvgi.lvgi_MethodID	= LV_GETPREV;
	lvgi.lvgi_Number	= num;
	lvgi.lvgi_Items		= lv->Items;

	return (lv->GetPrevFunc (lv->CallBack, item, &lvgi));
}



Class *MakeListViewClass (void)
{
	Class *LVClass;

	if (LVClass = MakeClass (NULL, GADGETCLASS, NULL, sizeof (struct LVData), 0))
		LVClass->cl_Dispatcher.h_Entry = (ULONG (*)()) LVDispatcher;

	return LVClass;
}



void FreeListViewClass (Class *LVClass)
{
	ASSERT_VALID(LVClass)
	FreeClass (LVClass);
}
