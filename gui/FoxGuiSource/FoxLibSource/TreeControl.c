/* FoxGUI - The fast, flexible, free Amiga GUI system
	Copyright (C) 2001 Simon Fox (Foxysoft)

This library is free software; you can redistribute it and/ormodify it under the terms of the GNU Lesser General PublicLicense as published by the Free Software Foundation; eitherversion 2.1 of the License, or (at your option) any later version.This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNULesser General Public License for more details.You should have received a copy of the GNU Lesser General PublicLicense along with this library; if not, write to the Free SoftwareFoundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
Foxysoft: www.foxysoft.co.uk      Email:simon@foxysoft.co.uk                */

/******************************************************************************
 * Shared library code.  Cannot call functions which use exit() such as:
 * printf(), fprintf()
 *
 * Otherwise:
 * The linker returns "__XCEXIT undefined" and the program will fail.
 * This is because you must not exit() a library!
 *
 * Also:
 * proto/exec.h must be included instead of clib/exec_protos.h and
 * __USE_SYSBASE must be defined.
 *
 * Otherwise:
 * The linker returns "Absolute reference to symbol _SysBase" and the
 * library crashes.  Presumably the same is true for the other protos.
 ******************************************************************************/

#define __USE_SYSBASE

#include <proto/mathieeedoubbas.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>

#include <proto/graphics.h>
#include <proto/intuition.h>
#include "/FoxInclude/FoxGui.h"

#include "FoxGuiTools.h"

#define XOFFSET 10
#define PLUSMINUSBUTTONWIDTH	11
#define SCROLL_BUTTON_WIDTH		16
#define SCROLL_BUTTON_HEIGHT	10

__far __stdargs int PlusMinusButtonFn(PushButton *pb);

static __inline __regargs void TreeControlClipOn(TreeControl *tc)
{
	if (tc && !(tc->WidgetData->flags & LB_CLIPPED))
	{
		struct Region *rg;
		int llborder = tc->WidgetData->left + tc->LBorder + 2;
		int left = llborder, right = tc->WidgetData->left + tc->points[0] - tc->LBorder - 2;

		rg = ClipGuiWindow(tc->Win, left, tc->WidgetData->top + tc->TBorder + 2,
				right, tc->WidgetData->top + tc->WidgetData->height - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0) - tc->TBorder - 3);
		if (rg)
			DisposeRegion(rg);
		tc->WidgetData->flags |= LB_CLIPPED;
	}
}

static __inline __regargs void TreeControlClipOff(TreeControl *tc)
{
	if (tc && tc->WidgetData->flags & LB_CLIPPED)
	{
		UnclipGuiWindow(tc->Win);
		tc->WidgetData->flags &= ~LB_CLIPPED;
	}
}

static int DrawTreeItem(TreeItem *ti, int top, BOOL recurse, BOOL undraw)
{
	if (ti)
	{
		// Draw line to parent.  Even if the item itself is outside
		// the current view, the line may still pass through it.
		if (ti->parent)
		{
			if (undraw)
				ti->LineToParent.FrontPen = ti->treecontrol->Win->Win->RPort->BgPen;
			else
			{
				ti->LineToParent.FrontPen = ti->treecontrol->FrontPen;
				ti->points[0] = ti->points[2] = ti->parent->it.LeftEdge + (short) floor(PLUSMINUSBUTTONWIDTH / 2.0) + 1;
				ti->points[1] = CalcItemTop(ti->parent) + ti->it.ITextFont->ta_YSize;
				ti->points[3] = ti->points[5] = top + (ti->it.ITextFont->ta_YSize / 2);
				ti->points[4] = ti->it.LeftEdge;
			}
			DrawBorder(ti->treecontrol->Win->Win->RPort, &ti->LineToParent, ti->treecontrol->WidgetData->left + ti->treecontrol->xOffset, ti->treecontrol->WidgetData->top);
		}

		// Only draw the item if it is in the visible area of the tree
		// control even though the area is clipped (it will reduce time).
		if (top + ti->it.ITextFont->ta_YSize < ti->treecontrol->WidgetData->height - 4 - (2 * ti->treecontrol->TBorder)
				- (ti->treecontrol->LR ? SCROLL_BUTTON_HEIGHT : 0) && top >= 0)
		{
			int PenStore;
			if (undraw)
			{
				PenStore = ti->it.FrontPen;
				ti->it.FrontPen = ti->treecontrol->Win->Win->RPort->BgPen;
				if (ti->plusminus)
				{
					ti->plusminus->WidgetData->ParentControl = NULL;
					Destroy(ti->plusminus, TRUE);
					ti->plusminus = NULL;
				}
				if (ti == ti->treecontrol->hiitem)
					AreaColFill(ti->treecontrol->Win->Win->RPort, ti->treecontrol->WidgetData->left + 2 +
							ti->treecontrol->LBorder + (ti->bmi ? ti->bm->width : 0) +
							(ti->firstchild ? PLUSMINUSBUTTONWIDTH + 2 : 0) + ti->treecontrol->xOffset +
							ti->it.LeftEdge, top + ti->treecontrol->WidgetData->top + 2 + ti->treecontrol->TBorder +
							ti->it.TopEdge, IntuiTextLength(&ti->it), ti->treecontrol->Font->ta_YSize,
							GetBackCol(ti->treecontrol->WidgetData->Parent));
				if (ti->bmi)
				{
					HideBitMap(ti->bmi);
					ti->bmi = NULL;
				}
			}
			else
			{
				if (ti->firstchild)
				{
					if (ti->plusminus && ti->plusminus->button.LeftEdge == ti->treecontrol->WidgetData->left + 2 +
							ti->treecontrol->LBorder + ti->it.LeftEdge && ti->plusminus->button.TopEdge ==
							top + ti->treecontrol->WidgetData->top + 2 + ti->treecontrol->TBorder)
						RefreshGList(&ti->plusminus->button, ti->treecontrol->Win->Win, NULL, 1L);
					else if (ti->plusminus)
					{
						ti->plusminus->WidgetData->ParentControl = NULL;
						DestroyButton(ti->plusminus, FALSE);
						ti->plusminus = NULL;
					}
					if (ti->treecontrol->xOffset + ti->it.LeftEdge >= 0 && !ti->plusminus)
					{
						ti->plusminus = MakeButton(ti->treecontrol->Win, "", ti->treecontrol->xOffset +
							ti->treecontrol->WidgetData->left + 2 + ti->treecontrol->LBorder + ti->it.LeftEdge,
							top + ti->treecontrol->WidgetData->top + 2 + ti->treecontrol->TBorder,
							PLUSMINUSBUTTONWIDTH, ti->it.ITextFont->ta_YSize,
							((ti->flags & TI_OPEN) ? '-' : '+'),
							((ti->flags & TI_OPEN) ? &ti->treecontrol->minus : &ti->treecontrol->plus),
							PlusMinusButtonFn, BN_STD | BN_CLEAR | THREED, NULL);
						if (ti->plusminus)
							ti->plusminus->WidgetData->ParentControl = (Widget *) ti;
					}
				}
				if (ti->bm && !ti->bmi)
					ti->bmi = ShowBitMap(ti->bm, ti->treecontrol->Win, (unsigned short)
						(ti->treecontrol->xOffset + ti->treecontrol->WidgetData->left + 2 + ti->treecontrol->LBorder +
						ti->it.LeftEdge + (ti->firstchild ? PLUSMINUSBUTTONWIDTH + 2 : 0)),
						(unsigned short) (top + ti->treecontrol->WidgetData->top + 2 + ti->treecontrol->TBorder),
						ti->bm->flags);
				if (ti == ti->treecontrol->hiitem)
					AreaColFill(ti->treecontrol->Win->Win->RPort, ti->treecontrol->WidgetData->left + 2 +
							ti->treecontrol->LBorder + (ti->bm ? ti->bm->width : 0) +
							(ti->firstchild ? PLUSMINUSBUTTONWIDTH + 2 : 0) + ti->treecontrol->xOffset +
							ti->it.LeftEdge, top + ti->treecontrol->WidgetData->top + 2 + ti->treecontrol->TBorder +
							ti->it.TopEdge, IntuiTextLength(&ti->it), ti->treecontrol->Font->ta_YSize,
							ti->treecontrol->FrontPen);
			}
			PrintIText(ti->treecontrol->Win->Win->RPort, &ti->it, ti->treecontrol->WidgetData->left + 2 +
				ti->treecontrol->LBorder + (ti->bm ? ti->bm->width : 0) +
				(ti->firstchild ? PLUSMINUSBUTTONWIDTH + 2 : 0) + ti->treecontrol->xOffset,
				top + ti->treecontrol->WidgetData->top + 2 + ti->treecontrol->TBorder);
			if (undraw)
				ti->it.FrontPen = PenStore;
		}
		if (ti->firstchild && (ti->flags & TI_OPEN) && recurse)
			top = DrawTreeItem(ti->firstchild, top + ti->it.ITextFont->ta_YSize, recurse, undraw);
		if (ti->next && recurse)
			top = DrawTreeItem(ti->next, top + ti->it.ITextFont->ta_YSize, recurse, undraw);
	}
	return top;
}

/* Returns TRUE if an item is visibly open (i.e. it's parent
and it's parents parent etc must also be open) */
BOOL FOXLIB ItemIsOpen(REGA0 TreeItem *it)
{
	if (!(it->flags & TI_OPEN))
		return FALSE;
	else if (it->parent)
		return ItemIsOpen(it->parent);
	else
		return TRUE;
}

int TCScrollUpButtFn(PushButton *pb);
int TCScrollDownButtFn(PushButton *pb);
int TCScrollLeftButtFn(PushButton *pb);
int TCScrollRightButtFn(PushButton *pb);

static void CheckCreateScrollers(TreeControl *tc)
{
	int top = 0, maxtop = 0, maxlen = 0;
	BOOL created = FALSE;
	FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &top);

	if (maxtop + tc->Font->ta_YSize > tc->WidgetData->height - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0) - 4 -
			(2 * tc->TBorder) && !tc->UD)
	{
		TreeControlClipOn(tc);
		DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, TRUE); // Undraw
		TreeControlClipOff(tc);
		MakeVerticalScroller(tc, TCScrollUpButtFn, TCScrollDownButtFn);
		created = TRUE;
		if (tc->UD)
		{
			tc->WidgetData->flags |= SYS_LB_VSCROLL;
			ResizeListBox(tc, tc->WidgetData->left, tc->WidgetData->top, tc->WidgetData->width, tc->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
			if (tc->hidden == 0)
			{
				AddGadget(tc->Win->Win, &tc->UD->ScrollGad, ~0);
				RefreshGList(&tc->UD->ScrollGad, tc->Win->Win, NULL, 1);
			}
			if (!tc->Enabled)
				DisableScroller(tc->UD);
		}
	}
	if (maxlen > tc->WidgetData->width - (tc->UD ? SCROLL_BUTTON_WIDTH : 0) - 4 - (2 * tc->LBorder) && !tc->LR)
	{
		tc->WidgetData->flags |= SYS_LB_HSCROLL;
		if (!created)
		{
			TreeControlClipOn(tc);
			DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, TRUE); // Undraw
			TreeControlClipOff(tc);
		}
		MakeHorizontalScroller(tc, TCScrollLeftButtFn, TCScrollRightButtFn);
		created = TRUE;
		ResizeListBox(tc, tc->WidgetData->left, tc->WidgetData->top, tc->WidgetData->width, tc->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
		if (maxtop + tc->Font->ta_YSize > tc->WidgetData->height - SCROLL_BUTTON_HEIGHT - 4 -
				(2 * tc->TBorder) && !tc->UD)
		{
			MakeVerticalScroller(tc, TCScrollUpButtFn, TCScrollDownButtFn);
			if (tc->UD)
			{
				tc->WidgetData->flags |= SYS_LB_VSCROLL;
				ResizeListBox(tc, tc->WidgetData->left, tc->WidgetData->top, tc->WidgetData->width, tc->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
				if (tc->hidden == 0)
				{
					AddGadget(tc->Win->Win, &tc->UD->ScrollGad, ~0);
					RefreshGList(&tc->UD->ScrollGad, tc->Win->Win, NULL, 1);
				}
				if (!tc->Enabled)
					DisableScroller(tc->UD);
			}
		}
	}
	if (created)
	{
		ListBoxRefresh(tc);
		TreeControlClipOn(tc);
		DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, FALSE);
		TreeControlClipOff(tc);
	}
	if (tc->UD)
	{
		unsigned short body, pot;

		FindScrollerValues((maxtop + tc->Font->ta_YSize) / tc->Font->ta_YSize, (tc->WidgetData->height - 4 - (2 * tc->TBorder) - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0)) / tc->Font->ta_YSize, (0 - CalcItemTop(tc->itemlist)) / tc->Font->ta_YSize, 1, &body, &pot);
		NewModifyProp(&tc->UD->ScrollGad, tc->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
	}
	if (tc->LR)
	{
		unsigned short body, pot;

		FindScrollerValues(maxlen, tc->WidgetData->width - 4 - (2 * tc->LBorder) - (tc->UD ? SCROLL_BUTTON_WIDTH : 0), 0 - tc->xOffset, tc->Font->ta_YSize, &body, &pot);
		NewModifyProp(&tc->LR->ScrollGad, tc->Win->Win, NULL, AUTOKNOB | FREEHORIZ | PROPNEWLOOK, pot, 0, body, 0, 1);
	}
}

static void CheckDestroyScrollers(TreeControl *tc)
{
	int top = 0, maxtop = 0, maxlen = 0;
	BOOL destroyed = FALSE;
	FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &top);

	if (maxlen < tc->WidgetData->width - (tc->UD ? SCROLL_BUTTON_WIDTH : 0) && tc->LR)
	{
		TreeControlClipOn(tc);
		DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, TRUE);
		TreeControlClipOff(tc);
		DestroyHorizontalScroller(tc, TRUE);
		destroyed = TRUE;
	}
	if (maxtop + tc->Font->ta_YSize < tc->WidgetData->height - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0) && tc->UD)
	{
		if (!destroyed)
		{
			TreeControlClipOn(tc);
			DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, TRUE);
			TreeControlClipOff(tc);
		}
		DestroyVerticalScroller(tc, TRUE);
		// We may have just closed a +/- button and therefore no-longer need a scroller BUT that
		// doesn't necessarily mean that topshown is currently itemlist.  It should be now.
		tc->topshown = tc->itemlist;

		if (maxlen < tc->WidgetData->width && tc->LR)
			DestroyHorizontalScroller(tc, TRUE);
		destroyed = TRUE;
	}
	if (destroyed)
	{
		TreeControlClipOn(tc);
		DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, FALSE);
		TreeControlClipOff(tc);
	}
}

static TreeItem *FindTreeItemRecurse(TreeItem *root, char *text)
{
	TreeItem *found = NULL;

	if (strcmp(root->it.IText, text) == 0)
		return root;
	if (root->firstchild)
		found = FindTreeItemRecurse(root->firstchild, text);
	if (root->next && !found)
		found = FindTreeItemRecurse(root->next, text);
	return found;
}

TreeItem* FOXLIB FindTreeItem(REGA0 TreeControl *tc, REGA1 char *text)
{
	return FindTreeItemRecurse(tc->itemlist, text);
}

void FOXLIB RemoveItem(REGA0 TreeItem *ti)
{
	TreeControl *tc = ti->treecontrol;
	TreeItem *pp = ti, *redrawfrom = NULL, *previous = NULL, *oldtopshown = tc->topshown;

	if (ti->parent)
	{
		BOOL parentopen = ItemIsOpen(ti->parent);
		if (parentopen)
		{
			while (pp->parent)
				pp = pp->parent;
			TreeControlClipOn(tc);
			DrawTreeItem(pp, CalcItemTop(pp), TRUE, TRUE);
		}

		if (ti->parent->firstchild == ti)
			ti->parent->firstchild = ti->next;
		else
		{
			TreeItem *t = ti->parent->firstchild, *p = NULL;

			while (t != ti)
			{
				p = t;
				t = t->next;
			}
			previous = p;
		}

		if (ti == tc->hiitem)
			tc->hiitem = NULL;

		if (parentopen)
			redrawfrom = pp;
	}
	else
	{
		TreeControlClipOn(tc);
		DrawTreeItem(ti, CalcItemTop(ti), TRUE, TRUE);

		if (ti != tc->itemlist)
		{
			TreeItem *t = tc->itemlist, *p = NULL;

			while (t != ti)
			{
				p = t;
				t = t->next;
			}
			previous = p;
		}

		if (ti == tc->hiitem)
			tc->hiitem = NULL;

		redrawfrom = ti->next;
	}

	// Now free the item and any children
	if (ti->firstchild)
		FreeItemTree(ti->firstchild, ti, TRUE);
	if (previous)
		previous->next = ti->next;
	if (ti == tc->itemlist)
		tc->itemlist = ti->next;
	if (ti->it.IText)
		GuiFree(ti->it.IText);
	if (ti->bm && (ti->flags & TI_BITMAPISSCALED))
		FreeGuiBitMap(ti->bm);
	if (tc->topshown == ti || tc->topshown == NULL) // FreeItemTree may have set this to NULL
		if (ti->next)
			tc->topshown = ti->next;
		else if (tc->itemlist)
			tc->topshown = FindPreviousItem(ti);
		else
			tc->topshown = NULL;

	CheckDestroyScrollers(tc);

	GuiFree(ti);

	if (redrawfrom)
	{
		if (tc->topshown != oldtopshown)
			redrawfrom = tc->topshown;
		DrawTreeItem(redrawfrom, CalcItemTop(redrawfrom), TRUE, FALSE);
	}
	TreeControlClipOff(tc);
}

TreeItem* FOXLIB ReplaceTCItem(REGA0 TreeItem *old, REGA1 char *text, REGA2 GuiBitMap *bm, REGA3 void *ItemData)
{
	if (old)
	{
		char *oldIText = old->it.IText;
		int top = CalcItemTop(old);

		TreeControlClipOn(old->treecontrol);
		if ((!(old->parent)) || ItemIsOpen(old->parent))
			DrawTreeItem(old, top, FALSE, TRUE);

		if (old->bmi)
			GuiFree(old->bmi);
		// Don't free the bitmap unless we allocated a copy - otherwise the user allocated it and should free
		//	it.  In this way, the user can use the same bitmap for many items in the list.
		if (old->bm && (old->flags & TI_BITMAPISSCALED))
			FreeGuiBitMap(old->bm);
		if (old->flags & TI_BITMAPISSCALED)
			old->flags &= ~TI_BITMAPISSCALED;

		old->bm = bm;
		if (old->bm && old->bm->height > old->treecontrol->Font->ta_YSize)
		{
			/* The compiler should be clever enough to know that we're using Commodore IEEE DP Maths and insert all of the necessary
				conversions at compile time.  However, it can't manage the conversion from IEEE DP to unsigned short on it's own without
				generating a reference to __XCEXIT which we just can't allow in a shared library so I've helped it along a bit by inserting
				some of the conversions.  See Includes & Autodocs for a description of the IEEE DP conversions in the mathieeedoubbas
				library */
			old->bm = ScaleBitMap(old->bm, (unsigned short) IEEEDPFix((IEEEDPFlt(old->treecontrol->Font->ta_YSize) / old->bm->height) * IEEEDPFlt(old->bm->width)), (unsigned short) old->treecontrol->Font->ta_YSize);
			if (old->bm)
				old->flags |= TI_BITMAPISSCALED;
		}
		old->bmi = NULL;

		old->it.IText = (char *) GuiMalloc((strlen(text) + 1) * sizeof(char), 0);
		if (old->it.IText)
			strcpy(old->it.IText, text);
		if ((!(old->parent)) || ItemIsOpen(old->parent))
			DrawTreeItem(old, top, FALSE, FALSE);
		TreeControlClipOff(old->treecontrol);
		CheckCreateScrollers(old->treecontrol);
		CheckDestroyScrollers(old->treecontrol);
		if (oldIText)
			GuiFree(oldIText);
	}
	return old;
}

TreeItem* FOXLIB AddItem(REGA0 TreeControl *tc, REGA1 TreeItem *InsBefore, REGA2 TreeItem *Parent, REGA3 char *text,
		REGD0 BOOL IsOpen, REGD1 GuiBitMap *bm, REGD2 void *ItemData)
{
	TreeItem *ti = (TreeItem *) GuiMalloc(sizeof(TreeItem), 0), *pp = Parent;

	if (ti)
	{
		BOOL draw = TRUE;

		ti->treecontrol = tc;
		ti->itemdata = ItemData;
		ti->flags = (IsOpen ? TI_OPEN : 0);
		ti->parent = Parent;
		ti->firstchild = NULL;
		ti->plusminus = NULL;
		ti->it.TopEdge = 0;
		ti->it.NextText = NULL;
		ti->it.ITextFont = tc->Font;
		ti->it.FrontPen = tc->FrontPen;
		ti->it.BackPen = GetBackCol(tc->WidgetData->Parent);
		ti->it.DrawMode = JAM1;
		ti->bm = bm;
		if (ti->bm && ti->bm->height > tc->Font->ta_YSize)
		{
			/* The compiler should be clever enough to know that we're using Commodore IEEE DP Maths and insert all of the necessary
				conversions at compile time.  However, it can't manage the conversion from IEEE DP to unsigned short on it's own without
				generating a reference to __XCEXIT which we just can't allow in a shared library so I've helped it along a bit by inserting
				some of the conversions.  See Includes & Autodocs for a description of the IEEE DP conversions in the mathieeedoubbas
				library */
			ti->bm = ScaleBitMap(ti->bm, (unsigned short) IEEEDPFix((IEEEDPFlt(tc->Font->ta_YSize) / ti->bm->height) * IEEEDPFlt(ti->bm->width)), tc->Font->ta_YSize);
			if (ti->bm)
				ti->flags |= TI_BITMAPISSCALED;
		}
		ti->bmi = NULL;
		ti->LineToParent.LeftEdge = /*tc->WidgetData->left +*/ 2 + tc->LBorder;
		ti->LineToParent.TopEdge = /*tc->WidgetData->top +*/ 2 + tc->TBorder;
		ti->LineToParent.DrawMode = JAM1;
		ti->LineToParent.XY = ti->points;
		ti->LineToParent.Count = 3;
		ti->LineToParent.NextBorder = NULL;

		ti->it.IText = (char *) GuiMalloc((strlen(text) + 1) * sizeof(char), 0);
		if (ti->it.IText)
			strcpy(ti->it.IText, text);

		if (Parent)
		{
			// There's no need to redraw anything if the parent is closed UNLESS the parent is visible
			// and this is the first child in which case the parent will need to be redrawn as the +/-
			// button is created.
			if (!ItemIsOpen(Parent) && !(Parent->firstchild == NULL &&
					(Parent->parent == NULL || ItemIsOpen(Parent->parent))))
				draw = FALSE;

			if (draw)
			{
				while (pp->parent)
					pp = pp->parent;

				TreeControlClipOn(tc);
				DrawTreeItem(pp, CalcItemTop(pp), TRUE, TRUE);
			}

			ti->it.LeftEdge = Parent->it.LeftEdge + XOFFSET;
			if (!Parent->firstchild)
			{
				Parent->firstchild = ti;
				ti->next = NULL;
			}
			else // Parent already has a child.
			{
				TreeItem *i = Parent->firstchild, *p = NULL;

				while (i && i != InsBefore)
				{
					p = i;
					i = i->next;
				}
				if (i == Parent->firstchild)
					Parent->firstchild = ti;
				else
					p->next = ti;
				ti->next = i;
			}

			if (draw)
			{
				DrawTreeItem(pp, CalcItemTop(pp), TRUE, FALSE);
				TreeControlClipOff(tc);
			}
		}
		else // No Parent
		{
			TreeItem *i = tc->itemlist, *p = NULL;
			ti->it.LeftEdge = 0;

			if (i) // At least one item already in list
			{
				while (i && i != InsBefore)
				{
					p = i;
					i = i->next;
				}

				TreeControlClipOn(tc);
				DrawTreeItem(i, CalcItemTop(i), TRUE, TRUE);

				ti->next = p->next;
				p->next = ti;
			}
			else // No items in list yet
			{
				tc->itemlist = tc->topshown = ti;
				ti->next = NULL;

				TreeControlClipOn(tc);
			}
			DrawTreeItem(ti, CalcItemTop(ti), TRUE, FALSE);
			TreeControlClipOff(tc);
		}
		CheckCreateScrollers(tc);
	}
	return ti;
}

__far __stdargs int PlusMinusButtonFn(PushButton *pb)
{
	TreeItem *ti = (TreeItem *) pb->WidgetData->ParentControl, *pp = ti;
	TreeControl *tc = ti->treecontrol;
	int top, retval = GUI_CONTINUE;

	if ((tc->WidgetData->flags & TC_OPENITEM) && !(ti->flags & TI_OPEN))
		retval = ((TCIntFnPtr) *(tc->Eventfn))(tc, TC_OPENITEM, ti, NULL);
	else if ((tc->WidgetData->flags & TC_CLOSEITEM) && (ti->flags & TI_OPEN))
		retval = ((TCIntFnPtr) *(tc->Eventfn))(tc, TC_CLOSEITEM, ti, NULL);

	if (retval != GUI_END)
	{
		while (pp->parent)
			pp = pp->parent;

		top = CalcItemTop(pp);

		TreeControlClipOn(tc);
		DrawTreeItem(pp, top, TRUE, TRUE); // Will destroy the button.
		if (ti->flags & TI_OPEN)
			ti->flags &= ~TI_OPEN;
		else
			ti->flags |= TI_OPEN;

		DrawTreeItem(pp, top, TRUE, FALSE); // Will create the new button.
		TreeControlClipOff(tc);

		if (ti->flags & TI_OPEN)
			// We've just opened up a node - check whether we now need any scroll bars.
			CheckCreateScrollers(tc);

		if ((tc->UD || tc->LR) && !(ti->flags & TI_OPEN))
			// We've just closed a node - check whether we still need any scroll bars.
			CheckDestroyScrollers(tc);
	}
	return retval;
}

void FOXLIB OpenItem(REGA0 TreeItem *it)
{
	if (it && it->firstchild && !(it->flags & TI_OPEN))
		PlusMinusButtonFn(it->plusminus);
}

void FOXLIB CloseItem(REGA0 TreeItem *it)
{
	if (it && it->firstchild && (it->flags & TI_OPEN))
		PlusMinusButtonFn(it->plusminus);
}

static TreeItem *LV(int *top, TreeItem *ti)
{
	TreeItem *n = ti;

	// Need to multiply the font height by two because we are currently at the top of the
	// previous item and we want to check the position of the bottom of the next item.
	if (ti->firstchild && (ti->flags & TI_OPEN) && *top + (2 * ti->it.ITextFont->ta_YSize) < ti->treecontrol->WidgetData->height - 4 - (2 * ti->treecontrol->TBorder) - (ti->treecontrol->LR ? SCROLL_BUTTON_HEIGHT : 0))
	{
		*top += ti->it.ITextFont->ta_YSize;
		n = LV(top, ti->firstchild);
	}
	if (ti->next && *top + (2 * ti->it.ITextFont->ta_YSize) < ti->treecontrol->WidgetData->height - 4 - (2 * ti->treecontrol->TBorder) - (ti->treecontrol->LR ? SCROLL_BUTTON_HEIGHT : 0))
	{
		*top += ti->it.ITextFont->ta_YSize;
		n = LV(top, ti->next);
	}
	return n;
}

static TreeItem *LowestVisible(TreeControl *tc)
{
	TreeItem *ti = tc->itemlist;
	int top = CalcItemTop(ti);
	return LV(&top, ti);
}

static TreeItem *LastOpen(TreeControl *tc)
{
	TreeItem *t = tc->itemlist;

	if (t)
	{
		while (t->next)
			t = t->next;
		if ((t->flags & TI_OPEN) && t->firstchild)
		{
			t = t->firstchild;
			while (t->next || (t->firstchild && (t->flags & TI_OPEN)))
			{
				if (t->next)
					t = t->next;
				else
					t = t->firstchild;
			}
		}
	}
	return t;
}

void TreeControlScrollDown(TreeControl *tc, BOOL RefreshScroller)
{
	int top = 0, maxlen = 0, maxtop = 0;
	unsigned short body, pot;
	// Find the bottom item shown:
	TreeItem *newtop = NULL, *pp = tc->topshown;
	BOOL ishi = (tc->topshown == tc->hiitem);

	if (LastOpen(tc) == LowestVisible(tc))
		return; // Nothing open to scroll down to.

	if (tc->topshown->firstchild && (tc->topshown->flags & TI_OPEN))
		newtop = tc->topshown->firstchild;
	else if (tc->topshown->next)
		newtop = tc->topshown->next;
	else
	{
		TreeItem *ti = tc->topshown;

		while (ti->parent && !newtop)
		{
			ti = ti->parent;
			if (ti->next)
				newtop = ti->next;
		}

		if (!newtop) // nothing to scroll down to
			return;
	}

	TreeControlClipOn(tc);
	while (pp->parent)
		pp = pp->parent;
	DrawTreeItem(pp, CalcItemTop(pp), TRUE, TRUE);
	if (ishi && (tc->WidgetData->flags & TC_REHILIGHT_ON_SCROLL))
	{
		tc->hiitem->it.DrawMode = JAM1;
		tc->hiitem = newtop;
		tc->hiitem->it.DrawMode = JAM2 | INVERSVID;
	}
	tc->topshown = newtop;
	DrawTreeItem(pp, CalcItemTop(pp), TRUE, FALSE);
	TreeControlClipOff(tc);

	if (RefreshScroller)
	{
		FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &top);
		FindScrollerValues((maxtop + tc->Font->ta_YSize) / tc->Font->ta_YSize, (tc->WidgetData->height - 4 - (2 * tc->TBorder) - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0)) / tc->Font->ta_YSize, (0 - CalcItemTop(tc->itemlist)) / tc->Font->ta_YSize, 1, &body, &pot);
		NewModifyProp(&tc->UD->ScrollGad, tc->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
	}
}

int TCScrollDownButtFn(PushButton *pb)
{
	TreeControlScrollDown((TreeControl*) pb->WidgetData->ParentControl, TRUE);
	return GUI_CONTINUE;
}

void TreeControlScrollUp(TreeControl *tc, BOOL RefreshScroller)
{
	BOOL ishi = (LowestVisible(tc) == tc->hiitem);

	if (tc->itemlist != tc->topshown) // Already at the top?
	{
		int top = 0, maxlen = 0, maxtop = 0;
		unsigned short body, pot;
		TreeItem *p = FindPreviousItem(tc->topshown), *pp = tc->topshown;

		TreeControlClipOn(tc);
		while (pp->parent)
			pp = pp->parent;
		DrawTreeItem(pp, CalcItemTop(pp), TRUE, TRUE);
		tc->topshown = p;
		if (ishi && (tc->WidgetData->flags & TC_REHILIGHT_ON_SCROLL))
		{
			tc->hiitem->it.DrawMode = JAM1;
			tc->hiitem = LowestVisible(tc);
			tc->hiitem->it.DrawMode = JAM2 | INVERSVID;
		}
		pp = p;
		while (pp->parent)
			pp = pp->parent;
		DrawTreeItem(pp, CalcItemTop(pp), TRUE, FALSE);
		TreeControlClipOff(tc);

		if (RefreshScroller)
		{
			FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &top);
			FindScrollerValues((maxtop + tc->Font->ta_YSize) / tc->Font->ta_YSize, (tc->WidgetData->height - 4 - (2 * tc->TBorder) - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0)) / tc->Font->ta_YSize, (0 - CalcItemTop(tc->itemlist)) / tc->Font->ta_YSize, 1, &body, &pot);
			NewModifyProp(&tc->UD->ScrollGad, tc->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
		}
	}
}

int TCScrollUpButtFn(PushButton *pb)
{
	TreeControlScrollUp((TreeControl*) pb->WidgetData->ParentControl, TRUE);
	return GUI_CONTINUE;
}

TreeItem *FindItemByTop(TreeControl *tc, int top);

int TCScrollLeftButtFn(PushButton *pb)
{
	TreeControl *tc = (TreeControl *) pb->WidgetData->ParentControl;
	int i;

	if (tc->xOffset < 0)
	{
		int top = 0, maxlen = 0, maxtop = 0, pptop;
		unsigned short body, pot;
		TreeItem *pp = tc->topshown;

		while (pp->parent)
			pp = pp->parent;
		pptop = CalcItemTop(pp);

		TreeControlClipOn(tc);
		DrawTreeItem(pp, pptop, TRUE, TRUE);
		tc->xOffset += tc->Font->ta_YSize;
		if (tc->xOffset > 0)
			tc->xOffset = 0;
		FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &top);
		FindScrollerValues(maxlen, tc->WidgetData->width - 4 - (2 * tc->LBorder) - (tc->UD ? SCROLL_BUTTON_WIDTH : 0), 0 - tc->xOffset, tc->Font->ta_YSize, &body, &pot);
		NewModifyProp(&tc->LR->ScrollGad, tc->Win->Win, NULL, AUTOKNOB | FREEHORIZ | PROPNEWLOOK, pot, 0, body, 0, 1);
		DrawTreeItem(pp, pptop, TRUE, FALSE);
		TreeControlClipOff(tc);
	}
	for (i = 0; i < 30; i++)
		FindItemByTop(tc, i);
	return GUI_CONTINUE;
}

int TCScrollRightButtFn(PushButton *pb)
{
	int top = 0, maxlen = 0, maxtop = 0, pptop;
	TreeControl *tc = (TreeControl *) pb->WidgetData->ParentControl;

	FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &top);
	if (tc->xOffset > tc->WidgetData->width - 4 - (2 * tc->LBorder) - (tc->UD ? SCROLL_BUTTON_WIDTH : 0) - maxlen)
	{
		unsigned short body, pot;
		TreeItem *pp = tc->topshown;

		while (pp->parent)
			pp = pp->parent;
		pptop = CalcItemTop(pp);

		TreeControlClipOn(tc);
		DrawTreeItem(pp, pptop, TRUE, TRUE);
		tc->xOffset -= tc->Font->ta_YSize;
		if (tc->xOffset < tc->WidgetData->width - 4 - (2 * tc->LBorder) - (tc->UD ? SCROLL_BUTTON_WIDTH : 0) - maxlen)
			tc->xOffset = tc->WidgetData->width - 4 - (2 * tc->LBorder) - (tc->UD ? SCROLL_BUTTON_WIDTH : 0) - maxlen;
		FindScrollerValues(maxlen, tc->WidgetData->width - 4 - (2 * tc->LBorder) - (tc->UD ? SCROLL_BUTTON_WIDTH : 0), 0 - tc->xOffset, tc->Font->ta_YSize, &body, &pot);
		NewModifyProp(&tc->LR->ScrollGad, tc->Win->Win, NULL, AUTOKNOB | FREEHORIZ | PROPNEWLOOK, pot, 0, body, 0, 1);
		DrawTreeItem(pp, pptop, TRUE, FALSE);
		TreeControlClipOff(tc);
	}
	return GUI_CONTINUE;
}

TreeItem* FOXLIB TCHiItem(REGA0 TreeControl *tc)
{
	if (tc)
		if (tc->hiitem)
			return tc->hiitem;
	return NULL;
}

char* FOXLIB TCHiText(REGA0 TreeControl *tc)
{
	if (tc)
		if (tc->hiitem)
			return tc->hiitem->it.IText;
	return NULL;
}

char* FOXLIB TCItemText(REGA0 TreeItem *ti)
{
	if (ti)
		return ti->it.IText;
	return NULL;
}

TreeControl* FOXLIB MakeTreeControl(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGD4 int lborder, REGD5 int tborder, REGD6 int flags,
		REGA1 int (* __far __stdargs Eventfn) (TreeControl*, short, TreeItem*, void**), REGA2 void *extension)
{
	TreeControl *tc;

	Diagnostic("MakeTreeControl", ENTER, TRUE);

	tc = (TreeControl *) CreateListBox(Parent, left, top, width, height, lborder, tborder,
		Gui.TextCol, &GuiFont, (LBIntFnPtr) Eventfn, flags, TreeControlObjectType);

	Diagnostic("MakeTreeControl", EXIT, (tc != NULL));
	return tc;
}

void FOXLIB SetTreeControlDragPointer(REGA0 TreeControl *tc, REGA1 unsigned short *DragPointer, REGD0 int width, REGD1 int height,
		REGD2 int xoffset, REGD3 int yoffset)
{
	if (tc)
	{
		tc->DragPointer = DragPointer;
		tc->PointerWidth = width;
		tc->PointerHeight = height;
		tc->PointerXOffset = xoffset;
		tc->PointerYOffset = yoffset;
	}

}

static TreeItem *FindItemByTopRecurse(TreeItem *ti, int top, int *curtop)
{
	TreeItem *t = NULL;

	if (*curtop + ti->it.ITextFont->ta_YSize >= top)
		return ti;

	if (ti->firstchild && (ti->flags & TI_OPEN))
	{
		*curtop += ti->it.ITextFont->ta_YSize;
		t = FindItemByTopRecurse(ti->firstchild, top, curtop);
		if (t)
			return t;
	}
	if (ti->next)
	{
		*curtop += ti->it.ITextFont->ta_YSize;
		t = FindItemByTopRecurse(ti->next, top, curtop);
	}
	return t;
}

TreeItem *FindItemByTop(TreeControl *tc, int top)
{
	int curtop = 0;
	TreeItem *ti;

	ti = FindItemByTopRecurse(tc->itemlist, top, &curtop);
	return ti;
}

void UpdateTCScrollGadImagery(TreeControl *tc)
{
	unsigned short top = 0;
	int maxlen = 0, maxtop = 0, curtop = 0;

	FindMaxSizes(tc->itemlist, &maxlen, &maxtop, &curtop);

	if (tc->UD)
	{
		unsigned short curtop = (0 - CalcItemTop(tc->itemlist)) / tc->Font->ta_YSize;

		top = FindScrollerTop((maxtop + tc->Font->ta_YSize) / tc->Font->ta_YSize, (tc->WidgetData->height - 4 - (2 * tc->TBorder) - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0)) / tc->Font->ta_YSize, tc->UD->ScrollGadInfo.VertPot);
		if (top != curtop)
		{
			if (top == curtop - 1)
				TreeControlScrollUp(tc, FALSE);
			else if (top == curtop + 1)
				TreeControlScrollDown(tc, FALSE);
			else
			{
				TreeItem *newtopitem, *pp = tc->topshown;
				int pixeltop = top * tc->Font->ta_YSize;
				BOOL HilightBottom = FALSE;

				while (pp->parent)
					pp = pp->parent;
				TreeControlClipOn(tc);
				DrawTreeItem(pp, CalcItemTop(pp), TRUE, TRUE);
				newtopitem = FindItemByTop(tc, pixeltop);
				if (tc->hiitem && (tc->WidgetData->flags & TC_REHILIGHT_ON_SCROLL))
				{
					int newtopitemtop = CalcItemTop(newtopitem), hiitemtop = CalcItemTop(tc->hiitem);

					if (top > curtop && hiitemtop >= curtop * tc->Font->ta_YSize && hiitemtop <=
							newtopitemtop)
					{
						tc->hiitem->it.DrawMode = JAM1;
						tc->hiitem = newtopitem;
						tc->hiitem->it.DrawMode = JAM2 | INVERSVID;
					}
					if (top < curtop && hiitemtop + ((curtop - top) * tc->Font->ta_YSize)
							>= (tc->WidgetData->height - 4 - (2 * tc->TBorder) - (tc->LR ? SCROLL_BUTTON_HEIGHT : 0)))
					{
						tc->hiitem->it.DrawMode = JAM1;
						HilightBottom = TRUE;
					}
				}
				pp = tc->topshown = newtopitem;
				if (HilightBottom)
				{
					tc->hiitem = LowestVisible(tc); // New Bottom Item
					tc->hiitem->it.DrawMode = JAM2 | INVERSVID;
				}
				while (pp->parent)
					pp = pp->parent;
				DrawTreeItem(pp, CalcItemTop(pp), TRUE, FALSE);
				TreeControlClipOff(tc);
			}
		}
	}
	if (tc->LR)
	{
		int left = 0 - FindScrollerTop(maxlen, tc->WidgetData->width - 4 - (2 * tc->LBorder), tc->LR->ScrollGadInfo.HorizPot);
		if (left != tc->xOffset) // Horizontal Scroller
		{
			TreeItem *pp = tc->topshown;
			int pptop;

			while (pp->parent)
				pp = pp->parent;
			pptop = CalcItemTop(pp);
			TreeControlClipOn(tc);
			DrawTreeItem(pp, pptop, TRUE, TRUE);
			tc->xOffset = left;
			DrawTreeItem(pp, pptop, TRUE, FALSE);
			TreeControlClipOff(tc);
		}
	}
}

void TreeControlRehilight(TreeControl *tc, TreeItem *HiElem, BOOL unhilight, BOOL hilight)
{
	// If the element has not been specified then unhilight only.

	if (hilight || unhilight)
		TreeControlClipOn(tc);

	// Unhilight previous selection
	if (tc->hiitem)
	{
		BOOL parentisopen = ((tc->hiitem->parent && ItemIsOpen(tc->hiitem->parent)) || !tc->hiitem->parent);
		TreeItem *ti = tc->hiitem;
		int hitop = CalcItemTop(ti);

		if (unhilight && tc->hidden == 0 && parentisopen)
			DrawTreeItem(ti, hitop, FALSE, TRUE);

		tc->hiitem = NULL;
		ti->it.DrawMode = JAM1;
		if (unhilight && tc->hidden == 0 && parentisopen)
			DrawTreeItem(ti, hitop, FALSE, FALSE);
	}

	// Now hilight the new item...
	if (HiElem)
	{
		BOOL parentisopen = ((HiElem->parent && ItemIsOpen(HiElem->parent)) || !HiElem->parent);
		int newhitop = CalcItemTop(HiElem);

		if (hilight && tc->hidden == 0 && parentisopen)
			DrawTreeItem(HiElem, newhitop, FALSE, TRUE);

		tc->hiitem = HiElem;
		tc->hiitem->it.DrawMode = JAM2 | INVERSVID;
		if (hilight && tc->hidden == 0 && parentisopen)
			DrawTreeItem(tc->hiitem, newhitop, FALSE, FALSE);
	}
	if (hilight || unhilight)
		TreeControlClipOff(tc);
}

// This function is called by FoxGui to unhilight an item that the pointer was held over
// when the user was dragging something into this tree control, without hilighting another item.
void ClearTreeControlDropNum(TreeControl *tc, TreeItem *OldHiItem)
{
	TreeControlClipOn(tc);

	// Unhilight previous selection
	if (OldHiItem && OldHiItem != tc->hiitem)
	{
		BOOL parentisopen = ((OldHiItem->parent && ItemIsOpen(OldHiItem->parent)) || !OldHiItem->parent);
		TreeItem *ti = OldHiItem;
		int hitop = CalcItemTop(ti);

		if (tc->hidden == 0 && parentisopen)
			DrawTreeItem(ti, hitop, FALSE, TRUE);

		ti->it.DrawMode = JAM1;
		if (tc->hidden == 0 && parentisopen)
			DrawTreeItem(ti, hitop, FALSE, FALSE);
	}
	TreeControlClipOff(tc);
}

// This function is called by FoxGui to hilight the item that the pointer is held over
// when the user is dragging something into this treecontrol.
TreeItem *SetTreeControlDropNum(TreeControl *tc, TreeItem *HiItem, TreeItem *OldHiItem)
{
	if (HiItem == OldHiItem)
		return HiItem; // Nothing to do.

	TreeControlClipOn(tc);

	// Unhilight previous selection
	if (OldHiItem && OldHiItem != tc->hiitem)
	{
		BOOL parentisopen = ((OldHiItem->parent && ItemIsOpen(OldHiItem->parent)) || !OldHiItem->parent);
		TreeItem *ti = OldHiItem;
		int hitop = CalcItemTop(ti);

		if (tc->hidden == 0 && parentisopen)
			DrawTreeItem(ti, hitop, FALSE, TRUE);

		ti->it.DrawMode = JAM1;
		if (tc->hidden == 0 && parentisopen)
			DrawTreeItem(ti, hitop, FALSE, FALSE);
	}

	// Now hilight the new item...
	if (HiItem && HiItem != tc->hiitem)
	{
		BOOL parentisopen = ((HiItem->parent && ItemIsOpen(HiItem->parent)) || !HiItem->parent);
		int newhitop = CalcItemTop(HiItem);

		if (tc->hidden == 0 && parentisopen)
			DrawTreeItem(HiItem, newhitop, FALSE, TRUE);

		HiItem->it.DrawMode = JAM2 | INVERSVID;
		if (tc->hidden == 0 && parentisopen)
			DrawTreeItem(HiItem, newhitop, FALSE, FALSE);
	}
	TreeControlClipOff(tc);
	return HiItem;
}

void FOXLIB SetTreeControlHiItem(REGA0 TreeControl *tc, REGA1 TreeItem *HiItem, REGD0 BOOL refresh)
{
	TreeControlRehilight(tc, HiItem, refresh, refresh);
}

int TCSelect(TreeControl *tc, long x, long y, unsigned long seconds, unsigned long micros, Frame **FrameDownPtr)
	{
	static unsigned long last_seconds = 0;
	static unsigned long last_micros = 0;
	static TreeItem *last_selected = NULL;

	if (tc)
		{
		TreeItem *SelectedElem;

		y -= tc->WidgetData->top + tc->TBorder + 1;

		SelectedElem = FindItemByTop(tc, y - CalcItemTop(tc->itemlist));
		if (SelectedElem)
			{
			TreeControlRehilight(tc, SelectedElem, TRUE, TRUE);

			/*	Is this the second click of a double-click?  (If it is but the list-box has no
				double-click function then treat this as a second single-click). */
			if ((tc->WidgetData->flags & TC_DBLCLICK) && tc->Eventfn &&
						DoubleClick(last_seconds, last_micros, seconds, micros) &&
						SelectedElem == last_selected)
				{
				// This is the second click of a double click.
				int Stop;
				last_selected = NULL;
				*FrameDownPtr = NULL;
				Stop = ((TCIntFnPtr) *(tc->Eventfn))(tc, TC_DBLCLICK, tc->hiitem, NULL);
				return Stop;
				}
			else // This is a single click.
				{
				last_seconds = seconds;
				last_micros = micros;
				last_selected = SelectedElem;
				if ((tc->WidgetData->flags & TC_SELECT) && tc->Eventfn)
					{
					int Stop;
					*FrameDownPtr = NULL;
					Stop = ((TCIntFnPtr) *(tc->Eventfn))(tc, TC_SELECT, tc->hiitem, NULL);
					return Stop;
					}
				}
			}
		}
	return GUI_CONTINUE;
	}

void FOXLIB ClearTreeControl(REGA0 TreeControl *tc)
{
	if (tc)
	{
		if (tc->itemlist)
			FreeItemTree(tc->itemlist, NULL, TRUE);
		tc->itemlist = tc->topshown = tc->hiitem = NULL;

		if (tc->LR)
			DestroyHorizontalScroller(tc, FALSE);
		if (tc->UD)
			DestroyVerticalScroller(tc, FALSE);
		ListBoxRefresh(tc);
	}
}

void* FOXLIB ItemData(REGA0 TreeItem *ti)
{
	return ti->itemdata;
}

void UndrawTreeControl(TreeControl *tc)
{
	TreeControlClipOn(tc);
	DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, TRUE);
	TreeControlClipOff(tc);
}

void DrawTreeControl(TreeControl *tc)
{
	ListBoxRefresh(tc);
	TreeControlClipOn(tc);
	DrawTreeItem(tc->itemlist, CalcItemTop(tc->itemlist), TRUE, FALSE);
	TreeControlClipOff(tc);
}
