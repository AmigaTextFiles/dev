/*
**	ListViewHooks.c
**
**	Copyright (C) 1996,97 Bernardo Innocenti
**
**	Use 4 chars wide TABs to read this file
**
**	Internal drawing and browsing hooks the listview class
*/

#define USE_BUILTIN_MATH
#define INTUI_V36_NAMES_ONLY
#define __USE_SYSBASE
#define  CLIB_ALIB_PROTOS_H		/* Avoid dupe defs of boopsi funcs */

#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>

#include <proto/intuition.h>
#include <proto/graphics.h>

#ifdef __STORM__
	#pragma header
#endif

#include "CompilerSpecific.h"
#include "Debug.h"

#define LV_GADTOOLS_STUFF
#include "ListViewClass.h"



/* Definitions for builtin List hook */

APTR HOOKCALL ListGetItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvGetItem	*lvgi));
APTR HOOKCALL ListGetNext (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvGetNext	*lvgn));
APTR HOOKCALL ListGetPrev (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvGetPrev	*lvgp));
ULONG HOOKCALL ListStringDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvDrawItem	*lvdi));
ULONG HOOKCALL ListImageDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvDrawItem	*lvdi));


/* Definitions for builtin Array hook */

APTR HOOKCALL ArrayGetItem (
	REG(a0, struct Hook			*hook),
	REG(a1, STRPTR				*item),
	REG(a2, struct lvGetItem	*lvgi));
ULONG HOOKCALL StringDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, STRPTR				 str),
	REG(a2, struct lvDrawItem	*lvdi));
ULONG HOOKCALL ImageDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Image		*img),
	REG(a2, struct lvDrawItem	*lvdi));



APTR HOOKCALL ListGetItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvGetItem	*lvg))
{
	ULONG i;

	ASSERT_VALIDNO0(lvg)

	node = ((struct List *)(lvg->lvgi_Items))->lh_Head;

	/* Warning: no sanity check is made against
	 * list being shorter than expected!
	 */
	for (i = 0; i < lvg->lvgi_Number; i++)
	{
		ASSERT_VALIDNO0(node)
		node = node->ln_Succ;
	}

	return (APTR)node;
}



APTR HOOKCALL ListGetNext (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvGetItem	*lvg))
{
	ASSERT_VALIDNO0(node)
	ASSERT_VALIDNO0(lvg)

	return (APTR)(node->ln_Succ->ln_Succ ? node->ln_Succ : NULL);
}



APTR HOOKCALL ListGetPrev (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvGetItem	*lvg))
{
	ASSERT_VALIDNO0(node)
	ASSERT_VALIDNO0(lvg)

	return (APTR)(node->ln_Pred->ln_Pred ? node->ln_Pred : NULL);
}



ULONG HOOKCALL ListStringDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvDrawItem	*lvdi))
{
	ASSERT_VALIDNO0(node)
	ASSERT_VALIDNO0(lvdi)

	return StringDrawItem (hook, node->ln_Name, lvdi);
}



ULONG HOOKCALL ListImageDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Node			*node),
	REG(a2, struct lvDrawItem	*lvdi))
{
	ASSERT_VALIDNO0(node)
	ASSERT_VALIDNO0(lvdi)

	return ImageDrawItem (hook, (struct Image *)node->ln_Name, lvdi);
}



APTR HOOKCALL ArrayGetItem (
	REG(a0, struct Hook			*hook),
	REG(a1, STRPTR				*item),
	REG(a2, struct lvGetItem	*lvg))
{
	ASSERT_VALIDNO0(lvg)
	ASSERT_VALIDNO0(lvg->lvgi_Items)

	return (APTR)(((STRPTR *)lvg->lvgi_Items)[lvg->lvgi_Number]);
}



ULONG HOOKCALL StringDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, STRPTR				 str),
	REG(a2, struct lvDrawItem	*lvdi))
{
	struct RastPort *rp;
	ULONG len;

	ASSERT_VALIDNO0(lvdi)
	rp = lvdi->lvdi_RastPort;
	ASSERT_VALIDNO0(rp)
	ASSERT_VALID(str)

	if (!str)
		/* Move to the leftmost pixel of the rectangle
		 * to have the following RectFill() clear all the line
		 */
		Move (rp, lvdi->lvdi_Bounds.MinX, 0);
	else
	{
		struct TextExtent textent;

		if (lvdi->lvdi_State == LVR_NORMAL)
		{
#ifndef OS30_ONLY
			if (GfxBase->LibNode.lib_Version < 39)
			{
				SetAPen (rp, lvdi->lvdi_DrawInfo->dri_Pens[TEXTPEN]);
				SetBPen (rp, lvdi->lvdi_DrawInfo->dri_Pens[BACKGROUNDPEN]);
				SetDrMd (rp, JAM2);
			}
			else
#endif /* !OS30_ONLY */
			SetABPenDrMd (rp, lvdi->lvdi_DrawInfo->dri_Pens[TEXTPEN],
				lvdi->lvdi_DrawInfo->dri_Pens[BACKGROUNDPEN],
				JAM2);
		}
		else
		{
#ifndef OS30_ONLY
			if (GfxBase->LibNode.lib_Version < 39)
			{
				SetAPen (rp, lvdi->lvdi_DrawInfo->dri_Pens[FILLTEXTPEN]);
				SetBPen (rp, lvdi->lvdi_DrawInfo->dri_Pens[FILLPEN]);
				SetDrMd (rp, JAM2);
			}
			else
#endif /* !OS30_ONLY */
				SetABPenDrMd (rp, lvdi->lvdi_DrawInfo->dri_Pens[FILLTEXTPEN],
					lvdi->lvdi_DrawInfo->dri_Pens[FILLPEN],
					JAM2);
		}

		Move (rp, lvdi->lvdi_Bounds.MinX, lvdi->lvdi_Bounds.MinY + rp->Font->tf_Baseline);

		len = strlen (str);

		if (!(lvdi->lvdi_Flags & LVF_CLIPPED))
		{
			/* Calculate how much text will fit in the listview width */
			len = TextFit (rp, str, len, &textent, NULL, 1,
				lvdi->lvdi_Bounds.MaxX - lvdi->lvdi_Bounds.MinX + 1,
				lvdi->lvdi_Bounds.MaxY - lvdi->lvdi_Bounds.MinY + 1);
		}

		Text (rp, str, len);

		/* Text() will move the pen X position to
		 * lvdi->lvdi_Bounds.MinX + textent.te_Width.
		 */
	}

	/* Now clear the rest of the row. rp->cp_x is updated by Text() to the
	 * next character to print.
	 */
	SetAPen (rp, lvdi->lvdi_DrawInfo->dri_Pens[(lvdi->lvdi_State == LVR_NORMAL) ?
		BACKGROUNDPEN : FILLPEN]);
	RectFill (rp, rp->cp_x,
		lvdi->lvdi_Bounds.MinY,
		lvdi->lvdi_Bounds.MaxX,
		lvdi->lvdi_Bounds.MaxY);


	return LVCB_OK;
}



ULONG HOOKCALL ImageDrawItem (
	REG(a0, struct Hook			*hook),
	REG(a1, struct Image		*img),
	REG(a2, struct lvDrawItem	*lvdi))
{
	struct RastPort *rp;
	UWORD left;

	ASSERT_VALID(img)
	ASSERT_VALIDNO0(lvdi)
	rp = lvdi->lvdi_RastPort;
	ASSERT_VALIDNO0(rp)

	if (!img)
		/* Move to the leftmost pixel of the item rectangle
		 * to have the following RectFill() clear all the line
		 */
		left = lvdi->lvdi_Bounds.MinX;
	else
	{
		DrawImageState (rp, img,
			lvdi->lvdi_Bounds.MinX, lvdi->lvdi_Bounds.MinY,
			lvdi->lvdi_State, lvdi->lvdi_DrawInfo);

		left = lvdi->lvdi_Bounds.MinX + img->Width;
	}

	/* Now clear the rest of the row. rp->cp_x is updated by Text() to the
	 * next character to print.
	 */
	SetAPen (rp, lvdi->lvdi_DrawInfo->dri_Pens[(lvdi->lvdi_State == LVR_NORMAL) ?
		BACKGROUNDPEN : FILLPEN]);
	RectFill (rp, left,
		lvdi->lvdi_Bounds.MinY,
		lvdi->lvdi_Bounds.MaxX,
		lvdi->lvdi_Bounds.MaxY);

	return LVCB_OK;
}
