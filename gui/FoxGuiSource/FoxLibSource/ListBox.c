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
#include <stdarg.h>
#include <string.h>
#include <math.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

void FOXLIB SetListBoxTopNum(REGA0 ListBox *lb, REGD0 int num, REGD1 BOOL refresh)
	{
	if (lb && num)
		{
		lb->TopShown = num;
		if (refresh)
			ListBoxRefresh(lb);
		else
			lb->modified = TRUE;
		}
	}

ListBoxItem* FOXLIB ItemElem(REGA0 ListBox *lb, REGD0 int target)
	{
	int n = 1;
	ListBoxItem *TargElem = lb->FirstItem;
	while (TargElem && n < target)
		{
		if (TargElem->NextText)
			{
			if (TargElem->TopEdge < TargElem->NextText->TopEdge)
				n++;
			}
		else
			n++;
		TargElem = TargElem->NextText;
		}
	if (n != target)
		return NULL;  // We failed to find the item number specified.
	else
		return TargElem;
	}

int ItemNum(ListBox *lb, ListBoxItem *target)
	{
	ListBoxItem *it = lb->FirstItem;
	int TargNum = 1;

	while (it && it != target)
		{
		if (it->NextText)
			{
			if (it->TopEdge < it->NextText->TopEdge)
				TargNum++;
			}
		else
			TargNum++;
		it = it->NextText;
		}
	if (it != target)
		return 0;  // We failed to find the text specified.
	else
		return TargNum;
	}

static __inline __regargs void ListBoxClipOn(ListBox *lb, int tabnum)
	{
	if (lb && !(lb->WidgetData->flags & LB_CLIPPED))
		{
		struct Region *rg;
		int llborder = lb->WidgetData->left + lb->LBorder + 2;
		int left, right;

		if (tabnum > 0)
		{
			left = lb->WidgetData->left + lb->TabStop[tabnum - 1] + lb->xOffset;
			if (left < llborder)
				left = llborder;
		}
		else
			left = llborder;
		if (tabnum != -1 && lb->TabStop[tabnum] != 0)
			right = lb->WidgetData->left + lb->TabStop[tabnum] - 2 + lb->xOffset;
		else
			right = lb->WidgetData->left + lb->points[0] - lb->LBorder - 2;

		rg = ClipGuiWindow(lb->Win, left, lb->WidgetData->top + lb->TBorder + 1,
				right, lb->WidgetData->top + lb->WidgetData->height - (lb->LR ? SCROLL_BUTTON_HEIGHT : 0) - lb->TBorder);
		if (rg)
			DisposeRegion(rg);
		lb->WidgetData->flags |= LB_CLIPPED;
		}
	}

static __inline __regargs void ListBoxClipOff(ListBox *lb)
	{
	if (lb && lb->WidgetData->flags & LB_CLIPPED)
		{
		UnclipGuiWindow(lb->Win);
		lb->WidgetData->flags &= ~LB_CLIPPED;
		}
	}

__regargs ListBoxItem *PrintTabClippedText(ListBox *lb, ListBoxItem *i, int top)
{
	ListBoxItem *nexttoprint = NULL;

	if (lb && i)
	{
		register int topedge = i->TopEdge;
		register int lxoffset = lb->WidgetData->left + lb->xOffset;

		if (lb->TabStop)
		{
			register int tabnum = 0;
			register ListBoxItem *n;

			while ((tabnum == 0 || (tabnum > 0 && lb->TabStop[tabnum - 1])) && i && i->TopEdge == topedge)
			{
				n = i->NextText;
				ListBoxClipOn(lb, tabnum);
				i->NextText = NULL;
				PrintIText(lb->Win->Win->RPort, i, lxoffset, top);
				i->NextText = n;
				ListBoxClipOff(lb);
				i = n;
				tabnum++;
			}
			nexttoprint = i;
		}
		else
		{
			register ListBoxItem *p = i, *first = i;

			ListBoxClipOn(lb, -1);

			while (i && i->TopEdge == topedge)
			{
				p = i;
				i = i->NextText;
			}

			p->NextText = NULL;
			PrintIText(lb->Win->Win->RPort, first, lxoffset, top);
			p->NextText = i;
			nexttoprint = i;
			ListBoxClipOff(lb);
		}
	}
	return nexttoprint;
}

void ListBoxRehilight(ListBox *lb, int HiNum, ListBoxItem *HiElem, BOOL unhilight,
		BOOL hilight)
	{
//	BOOL unclip = FALSE;
//	ListBoxItem *store;
	ListBoxItem *it; //, *prit;
	int numlines = NumLines(lb), top;

	// If neither the number or the element has been specified then unhilight only.

	if (HiNum && !HiElem)
		/*	The user has specified which item to hilight by number only.  We need to
			know both the number and the element so let's find the element. */
		if (!(HiElem = ItemElem(lb, HiNum)))
			return;  // We failed to find the item number specified.

	if (HiElem && !HiNum)
		/*	The user has specified which item to hilight by element only.  We need
			to know both the number and the element so let's find the number. */
		if (!(HiNum = ItemNum(lb, HiElem)))
			return;  // We failed to find the text specified.

/*	if (!(lb->WidgetData->flags & LB_CLIPPED))
		{
		ListBoxClipOn(lb, -1);
		unclip = TRUE;
		} */

	if (lb->NoTitles)
		top = lb->WidgetData->top + ((lb->NoTitles + 1 - lb->TopShown) * lb->Font->ta_YSize) + (3 * lb->TBorder) + 4;
	else
		top = lb->WidgetData->top + ((1 - lb->TopShown) * lb->Font->ta_YSize) + lb->TBorder + 1;

	// Unhilight previous selection
	if (lb->HiItem)
		{
		it = lb->HiItem;
//		prit = NULL;
		while (it && it->TopEdge == lb->HiItem->TopEdge)
			{
			it->DrawMode = JAM2;
//			prit = it;
			it = it->NextText;
			}
		if (unhilight && lb->HiNum >= lb->TopShown && lb->HiNum <= numlines + lb->TopShown - 1 && lb->hidden == 0)
			{
//			store = prit->NextText;
//			prit->NextText = NULL;
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + lb->HiItem->LeftEdge, top + lb->HiItem->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, GetBackCol(lb->WidgetData->Parent));
			PrintTabClippedText(lb, lb->HiItem, top);
//			PrintIText(lb->Win->Win->RPort, lb->HiItem, lb->WidgetData->left + lb->xOffset, top);
//			prit->NextText = store;
			}
		}

	// Now hilight the new item...
	lb->HiItem = HiElem;
	lb->HiNum = HiNum;

	if (lb->HiItem)
		{
		it = lb->HiItem;
//		prit = NULL;
		while (it && it->TopEdge == lb->HiItem->TopEdge)
			{
			it->DrawMode = JAM2 | INVERSVID;
//			prit = it;
			it = it->NextText;
			}
		if (hilight && HiNum >= lb->TopShown && HiNum <= numlines + lb->TopShown - 1 && lb->hidden == 0)
			{
//			store = prit->NextText;
//			prit->NextText = NULL;
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + HiElem->LeftEdge, top + HiElem->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, lb->FrontPen);
			PrintTabClippedText(lb, HiElem, top);
//			PrintIText(lb->Win->Win->RPort, HiElem, lb->WidgetData->left + lb->xOffset, top);
//			prit->NextText = store;
			}
		}
/*	if (unclip)
		ListBoxClipOff(lb); */
	}

void FOXLIB SetListBoxHiNum(REGA0 ListBox *lb, REGD0 int num, REGD1 BOOL refresh)
	{
	if (lb && num >= 0)
		{
		ListBoxRehilight(lb, num, NULL, refresh && !lb->modified, refresh && !lb->modified);
		if (refresh && lb->modified)
			ListBoxRefresh(lb);
		if (!refresh)
			lb->modified = TRUE;
		}
	}

// This function is called by FoxGui to unhilight an item that the pointer was held over
// when the user was dragging something into this list box, without hilighting another item.
void ClearListBoxDropNum(ListBox *lb, ListBoxItem *OldHiItem)
	{
	ListBoxItem *it;
	int numlines = NumLines(lb), top, itemnum = ItemNum(lb, OldHiItem);

	// Unhilight previous selection
	if (OldHiItem && OldHiItem != lb->HiItem)
		{
		if (lb->NoTitles)
			top = lb->WidgetData->top + ((lb->NoTitles + 1 - lb->TopShown) * lb->Font->ta_YSize) + (3 * lb->TBorder) + 4;
		else
			top = lb->WidgetData->top + ((1 - lb->TopShown) * lb->Font->ta_YSize) + lb->TBorder + 1;

		it = OldHiItem;
		while (it && it->TopEdge == OldHiItem->TopEdge)
			{
			it->DrawMode = JAM2;
			it = it->NextText;
			}
		if (itemnum >= lb->TopShown && itemnum <= numlines + lb->TopShown - 1 && lb->hidden == 0)
			{
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + OldHiItem->LeftEdge, top + OldHiItem->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, GetBackCol(lb->WidgetData->Parent));
			PrintTabClippedText(lb, OldHiItem, top);
			}
		}
	}

// This function is called by FoxGui to hilight the item that the pointer is held over
// when the user is dragging something into this list box.
ListBoxItem *SetListBoxDropNum(ListBox *lb, int HiNum, ListBoxItem *OldHiItem)
	{
	ListBoxItem *it, *HiElem = ItemElem(lb, HiNum);
	int numlines = NumLines(lb), top;

	if (OldHiItem == HiElem)
		return HiElem; // Nothing to do.

	if (lb->NoTitles)
		top = lb->WidgetData->top + ((lb->NoTitles + 1 - lb->TopShown) * lb->Font->ta_YSize) + (3 * lb->TBorder) + 4;
	else
		top = lb->WidgetData->top + ((1 - lb->TopShown) * lb->Font->ta_YSize) + lb->TBorder + 1;

	// Unhilight previous selection
	if (OldHiItem && OldHiItem != lb->HiItem)
		{
		int itemnum = ItemNum(lb, OldHiItem);

		it = OldHiItem;
		while (it && it->TopEdge == OldHiItem->TopEdge)
			{
			it->DrawMode = JAM2;
			it = it->NextText;
			}
		if (itemnum >= lb->TopShown && itemnum <= numlines + lb->TopShown - 1 && lb->hidden == 0)
			{
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + OldHiItem->LeftEdge, top + OldHiItem->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, GetBackCol(lb->WidgetData->Parent));
			PrintTabClippedText(lb, OldHiItem, top);
			}
		}

	// Now hilight the new item...
	// If HiElem == lb->HiItem then the item will already be hilighted - no point in doing it again!
	if (HiElem && HiElem != lb->HiItem)
		{
		it = HiElem;
		while (it && it->TopEdge == HiElem->TopEdge)
			{
			it->DrawMode = JAM2 | INVERSVID;
			it = it->NextText;
			}
		if (HiNum >= lb->TopShown && HiNum <= numlines + lb->TopShown - 1 && lb->hidden == 0)
			{
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + HiElem->LeftEdge, top + HiElem->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, lb->FrontPen);
			PrintTabClippedText(lb, HiElem, top);
			}
		}
	return HiElem;
	}

void FOXLIB SetListBoxHiElem(REGA0 ListBox *lb, REGA1 ListBoxItem *item, REGD0 BOOL refresh)
	{
	if (lb && item)
		{
		ListBoxRehilight(lb, 0, item, refresh && !lb->modified, refresh && !lb->modified);
		if (refresh && lb->modified)
			ListBoxRefresh(lb);
		if (!refresh)
			lb->modified = TRUE;
		}
	}

ListBoxItem *GetTopElem(ListBox *lb, int *topnum)
	{
	ListBoxItem *start = lb->FirstItem;
	int num = 1;
	while (start && num < lb->TopShown)
		{
		if (start->NextText)
			{
			if (start->TopEdge < start->NextText->TopEdge)
				num++;
			}
		else
			num++;
		start = start->NextText;
		}
	if (topnum)
		*topnum = num;
	return start;
	}

int ListBoxItemFromXY(ListBox *lb, long x, long y, ListBoxItem **Item, int *ItemNum)
	{
	int ItemLine = 0;
	if (Item)
		*Item = NULL;
	if (ItemNum)
		*ItemNum = 0;

	if (lb)
		{
		int titleheight = lb->NoTitles ? (lb->NoTitles * lb->Font->ta_YSize) + (2 * lb->TBorder) + 3 : 0;

		// Convert the coordinates into offsets from the corner of the list box
		x -= lb->WidgetData->left;
		y -= (lb->WidgetData->top + titleheight);
		if (x >= 0 && x < lb->points[12] && y >= 0 && y <= lb->WidgetData->height - 1 - (lb->LR ? SCROLL_BUTTON_HEIGHT : 0))
			{
			// The user clicked an item not a title
			int line = ((y - lb->TBorder) / lb->Font->ta_YSize) + 1;
			int n, ItemClicked;
			ListBoxItem *SelectedElem = GetTopElem(lb, &n);

			/* If the user clicked in the top border, pretend he clicked on the first
				line */
			line = max(line, 1);
			ItemClicked = line + lb->TopShown - 1;

			while (n < ItemClicked && SelectedElem)
				{
				if (SelectedElem->NextText)
					{
					if (SelectedElem->TopEdge < SelectedElem->NextText->TopEdge)
						n++;
					}
				else
					n++;
				SelectedElem = SelectedElem->NextText;
				}
			if (n <= lb->NoItems) // User did not click in the blank space below the last item
				*ItemNum = n;
			if (Item)
				*Item = SelectedElem;
			ItemLine = line;
			}
		}
	return ItemLine;
	}

int Select(ListBox *lb, long x, long y, unsigned long seconds, unsigned long micros, Frame **FrameDownPtr)
	{
	static unsigned long last_seconds = 0;
	static unsigned long last_micros = 0;
	static int last_selected = -1;

	if (lb)
		{
		ListBoxItem *SelectedElem;
		int line, n;

		line = ListBoxItemFromXY(lb, x, y, &SelectedElem, &n);

		if (SelectedElem)
			{
			ListBoxRehilight(lb, n, SelectedElem, TRUE, TRUE);

			/*	Is this the second click of a double-click?  (If it is but the list-box has no
				double-click function then treat this as a second single-click). */
			if ((lb->WidgetData->flags & LB_DBLCLICK) && lb->Eventfn &&
						DoubleClick(last_seconds, last_micros, seconds, micros) &&
						line == last_selected)
				{
				// This is the second click of a double click.
				int Stop;
				last_selected = -1;
				*FrameDownPtr = NULL;
				Stop = (*(lb->Eventfn))(lb, LB_DBLCLICK, lb->HiNum, NULL);
				return Stop;
				}
			else // This is a single click.
				{
				last_seconds = seconds;
				last_micros = micros;
				last_selected = line;
				if ((lb->WidgetData->flags & LB_SELECT) && lb->Eventfn)
					{
					int Stop;
// Taken out the line below so that a list box can have a select and a drag event.  Not sure whether
// there will be any side effects of removing it.
					// *FrameDownPtr = NULL;
					Stop = (*(lb->Eventfn))(lb, LB_SELECT, lb->HiNum, NULL);
					return Stop;
					}
				}
			}
		}
	return GUI_CONTINUE;
	}

static void UpdateHorizScroller(ListBox *nlb)
	{
	unsigned short body, pot;

	FindScrollerValues(nlb->LongestIntuiLen, nlb->MaxIntuiLen, 0 - nlb->xOffset, nlb->Font->ta_YSize, &body, &pot);
	NewModifyProp(&nlb->LR->ScrollGad, nlb->Win->Win, NULL, AUTOKNOB | FREEHORIZ | PROPNEWLOOK, pot, 0, body, 0, 1);
	}

static void RefreshVertScroller(ListBox *lb)
	{
	if (lb->UD)
		{
		RefreshGList(&lb->UD->ScrollGad, lb->Win->Win, NULL, 1);
		if (lb->UD->ScrollUp)
			RefreshGList(&lb->UD->ScrollUp->button, lb->Win->Win, NULL, 1);
		if (lb->UD->ScrollDown)
			RefreshGList(&lb->UD->ScrollDown->button, lb->Win->Win, NULL, 1);
		}
	}

static void RefreshHorizScroller(ListBox *lb)
	{
	if (lb->LR)
		{
		RefreshGList(&lb->LR->ScrollGad, lb->Win->Win, NULL, 1);
		if (lb->LR->ScrollUp)
			RefreshGList(&lb->LR->ScrollUp->button, lb->Win->Win, NULL, 1);
		if (lb->LR->ScrollDown)
			RefreshGList(&lb->LR->ScrollDown->button, lb->Win->Win, NULL, 1);
		}
	}

void FOXLIB ListBoxRefresh(REGA0 ListBox *lb)
	{
	if (lb && lb->hidden == 0)
		{
//		BOOL unclip = FALSE;
		unsigned short body, pot;
		ListBoxItem *text, *store, *firstitem, *i;
		int n, numlines = NumLines(lb), top;

		if (lb->NoTitles)
		{
			MakeBevel(&lb->LightBorder, &lb->DarkBorder, lb->points, lb->WidgetData->left, lb->WidgetData->top +
					(lb->NoTitles * lb->Font->ta_YSize) + (2 * lb->TBorder) + 3, lb->WidgetData->width - (lb->UD ?
					SCROLL_BUTTON_WIDTH : 0), lb->WidgetData->height - (lb->LR ? SCROLL_BUTTON_HEIGHT + 1 : 0) - (3 + (2 *
					lb->TBorder) + (lb->NoTitles * lb->Font->ta_YSize)), TRUE);
			MakeBevel(&lb->TitleLightBorder, &lb->TitleDarkBorder, lb->titlebevelpoints, lb->WidgetData->left, lb->WidgetData->top,
					lb->WidgetData->width - (lb->UD ? SCROLL_BUTTON_WIDTH : 0), 2 + (2 * lb->TBorder) + (lb->NoTitles *
					lb->Font->ta_YSize), TRUE);
			lb->DarkBorder.NextBorder = &lb->TitleLightBorder;
			if (lb->UD)
				lb->TitleDarkBorder.NextBorder = &lb->UD->LightBorder;
			else if (lb->LR)
				lb->TitleDarkBorder.NextBorder = &lb->LR->LightBorder;
			else
				lb->TitleDarkBorder.NextBorder = NULL;
		}
		else
		{
			MakeBevel(&lb->LightBorder, &lb->DarkBorder, lb->points, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width -
					(lb->UD ? SCROLL_BUTTON_WIDTH : 0), lb->WidgetData->height - (lb->LR ? SCROLL_BUTTON_HEIGHT + 1 : 0),
					TRUE);
			if (lb->UD)
				lb->DarkBorder.NextBorder = &lb->UD->LightBorder;
			else if (lb->LR)
				lb->DarkBorder.NextBorder = &lb->LR->LightBorder;
			else
				lb->DarkBorder.NextBorder = NULL;
		}

		AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + 2, lb->WidgetData->top + 1,
				lb->WidgetData->width - (lb->UD ? SCROLL_BUTTON_WIDTH : 0) - 4, lb->WidgetData->height - (lb->LR ? SCROLL_BUTTON_HEIGHT : 0) - 2, GetBackCol(lb->WidgetData->Parent));
		DrawBorder(lb->Win->Win->RPort, &lb->LightBorder, 0, 0);

/*		if (!(lb->WidgetData->flags & LB_CLIPPED))
			{
			ListBoxClipOn(lb, -1);
			unclip = TRUE;
			} */

		// Print the titles
		if (lb->FirstTitle)
			{
			ListBoxItem *i = lb->FirstTitle;
			while (i)
				i = PrintTabClippedText(lb, i, lb->WidgetData->top + 1 + lb->TBorder);
//			PrintIText(lb->Win->Win->RPort, lb->FirstTitle, lb->WidgetData->left + lb->xOffset, lb->WidgetData->top + 1 + lb->TBorder);
			}

		// Now print as many items as possible in the remaining space
		if (lb->NoItems <= numlines)
			{
			firstitem = lb->FirstItem;
			lb->TopShown = 1;
			}
		else
			{
			if (!lb->TopShown)
				{
				firstitem = lb->FirstItem;
				lb->TopShown = 1;
				}
			else
				{
				ListBoxItem *fi;
				int top = lb->TopShown;
				while (lb->NoItems - top + 1 < numlines)
					top--;
				lb->TopShown = max(top, 1);
				fi = ItemElem(lb, lb->TopShown);
				if (fi)
					firstitem = fi;
				else
					firstitem = NULL;
				}
			}

		text = firstitem;
		n = 1;
		while (n < numlines && text)
			{
			if (text->NextText)
				{
				if (text->TopEdge < text->NextText->TopEdge)
					n++;
				}
			else
				n++;
			text = text->NextText;
			}
		while (text && text->NextText)
			if (text->NextText->TopEdge == text->TopEdge)
				text = text->NextText;
			else
				break;
		if (text)
			{
			store = text->NextText;
			text->NextText = NULL;
			}

		if (lb->NoTitles)
			top = lb->WidgetData->top + ((lb->NoTitles + 1 - lb->TopShown) * lb->Font->ta_YSize) + (3 * lb->TBorder) + 4;
		else
			top = lb->WidgetData->top + ((1 - lb->TopShown) * lb->Font->ta_YSize) + lb->TBorder + 1;
		if (lb->HiNum >= lb->TopShown && lb->HiNum <= lb->TopShown + numlines - 1)
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + lb->HiItem->LeftEdge, top + lb->HiItem->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, lb->FrontPen);
		i = firstitem;
		while (i)
			i = PrintTabClippedText(lb, i, top);
//		PrintIText(lb->Win->Win->RPort, firstitem, lb->WidgetData->left + lb->xOffset, top);
		if (text)
			text->NextText = store;

/*		if (unclip)
			ListBoxClipOff(lb); */

		if (lb->UD)
			{
			if (lb->itemlist)
			{
				int top = 0, maxlen = 0, maxtop = 0;

				FindMaxSizes(lb->itemlist, &maxlen, &maxtop, &top);
				FindScrollerValues(maxtop + lb->Font->ta_YSize, lb->WidgetData->height - 4 - (2 * lb->TBorder), CalcItemTop(lb->topshown), lb->Font->ta_YSize, &body, &pot);
			}
			else
				FindScrollerValues(lb->NoItems, numlines, lb->TopShown - 1, 1, &body, &pot);
			NewModifyProp(&lb->UD->ScrollGad, lb->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
			}
		if (lb->LR)
			{
			UpdateHorizScroller(lb);
			RefreshHorizScroller(lb);
			}
		if (lb->UD)
			RefreshVertScroller(lb);

		lb->modified = FALSE;
		}
	}

static void RedisplayList(ListBox *lb, ListBoxItem *OldTop, int NewTopNum,
		ListBoxItem *NewTop, int NumLines, int NewHiNum, ListBoxItem *NewHiElem, BOOL refreshscroller)
	{
	if (lb && OldTop && NewTop)
		{
		unsigned short body, pot;
		register ListBoxItem *o = OldTop, *n = NewTop;
		register ListBoxItem *onext, *nnext;
		register int num = 1, FrontPenStore;
		int oldmult, newmult;
		BYTE BackPenCol = GetBackCol(lb->WidgetData->Parent);

		if (lb->NoTitles)
		{
			oldmult = lb->WidgetData->top + ((lb->NoTitles + 1 - lb->TopShown) * lb->Font->ta_YSize) + (3 * lb->TBorder) + 4;
			newmult = lb->WidgetData->top + ((lb->NoTitles + 1 - NewTopNum) * lb->Font->ta_YSize) + (3 * lb->TBorder) + 4;
		}
		else
		{
			oldmult = lb->WidgetData->top + ((1 - lb->TopShown) * lb->Font->ta_YSize) + lb->TBorder + 1;
			newmult = lb->WidgetData->top + ((1 - NewTopNum) * lb->Font->ta_YSize) + lb->TBorder + 1;
		}

		if (NewHiNum || NewHiElem)
			{
			/*	We're going to rehilight at the same time.  We can do it here (for
				speed) rather than in a seperate call to ListBoxRehilight().  This means
				using as few calls to PrintIText() as possible. */
			if (!NewHiNum)
				NewHiNum = ItemNum(lb, NewHiElem);
			else if (!NewHiElem)
				NewHiElem = ItemElem(lb, NewHiNum);
			if (NewHiNum && NewHiElem)
				{
				register ListBoxItem *it;
				if (lb->HiItem)
					{
					it = lb->HiItem;
					while (it && it->TopEdge == lb->HiItem->TopEdge)
						{
						it->DrawMode = JAM2;
						it = it->NextText;
						}
					}
				it = NewHiElem;
				while (it && it->TopEdge == NewHiElem->TopEdge)
					{
					it->DrawMode = JAM2 | INVERSVID;
					it = it->NextText;
					}
				lb->HiItem = NewHiElem;
				lb->HiNum = NewHiNum;
				}
			}

		/* Line by line we need to delete the line of text that was there previously
			and print the new line.  Each iteration of this loop deals with one line.
			It would be simpler to treat the existing list as one list of IntuiText,
			delete the whole lot in one go and then print the new list in one go too
			but that causes too much flicker. */
		if (lb->hidden == 0)
			while (num <= NumLines && o && n)
				{
				// Store details of the old line of text
				FrontPenStore = o->FrontPen;

				/* Change the colour of the old line of text so that printing it again
					will delete it */
				o->FrontPen = o->BackPen;

				onext = o->NextText;
				while (onext && onext->TopEdge == o->TopEdge)
					{
					onext->FrontPen = onext->BackPen;
					onext = onext->NextText;
					}
				nnext = n->NextText;
				while (nnext && nnext->TopEdge == n->TopEdge)
					nnext = nnext->NextText;

				// Un-print the old text
				PrintTabClippedText(lb, o, oldmult);

				// If we're hilighting or un-hilighting, paint the background.
				if (n == lb->HiItem)
					AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + n->LeftEdge, newmult + n->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, lb->FrontPen);
				else if (o == lb->HiItem)
					AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left + o->LeftEdge, oldmult + o->TopEdge, lb->MaxIntuiLen, lb->Font->ta_YSize, BackPenCol);
				// Print the new text.
				PrintTabClippedText(lb, n, newmult);

				// Restore the details of the old and new lines
				do {
					o->FrontPen = FrontPenStore;
					o = o->NextText;
					} while (o != onext);

				// Now for the next line...
				num++;
				n = nnext;
				}
		lb->TopShown = NewTopNum;

		if (lb->UD && lb->hidden == 0 && refreshscroller)
			{
			FindScrollerValues(lb->NoItems, NumLines, NewTopNum - 1, 1, &body, &pot);
			NewModifyProp(&lb->UD->ScrollGad, lb->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
			}
		lb->modified = FALSE;
		}
	}

void ListBoxScrollUp(ListBox *nlb, BOOL refreshscroller)
	{
	int oldtopnum, numlines = NumLines(nlb);
	ListBoxItem *OldTop = GetTopElem(nlb, &oldtopnum);
	ListBoxItem *NewTop = nlb->FirstItem;

	while (NewTop)
		if (NewTop->TopEdge + nlb->Font->ta_YSize == OldTop->TopEdge)
			break;
		else
			NewTop = NewTop->NextText;

	if (NewTop && nlb->TopShown > 1)
		{
		int NewHiNum = 0;
		if ((nlb->WidgetData->flags & LB_REHILIGHT_ON_SCROLL) && nlb->HiNum > nlb->TopShown + numlines - 2)
			NewHiNum = oldtopnum + numlines - 2;
		RedisplayList(nlb, OldTop, oldtopnum - 1, NewTop, numlines, NewHiNum, NULL, refreshscroller);
		}
	}

ListBoxItem *NextItem(ListBoxItem *Item)
	{
	if (Item)
		{
		ListBoxItem *ni = Item->NextText;

		while (ni && ni->TopEdge == Item->TopEdge)
			ni = ni->NextText;
		return ni;
		}
	return NULL;
	}

void ListBoxScrollDown(ListBox *nlb, BOOL refreshscroller)
	{
	int oldtopnum, numlines = NumLines(nlb);
	ListBoxItem *OldTop = GetTopElem(nlb, &oldtopnum);

	if (OldTop)
		{
		ListBoxItem *NewTop = NextItem(OldTop);
		if (NewTop && numlines + nlb->TopShown - 1 < nlb->NoItems)
			{
			int NewHiNum = 0;
			if ((nlb->WidgetData->flags & LB_REHILIGHT_ON_SCROLL) && nlb->HiNum && nlb->HiNum < nlb->TopShown + 1)
				NewHiNum = oldtopnum + 1;
			RedisplayList(nlb, OldTop, oldtopnum + 1, NewTop, numlines, NewHiNum, NULL, refreshscroller);
			}
		}
	}

void FOXLIB SortListBox(REGA0 ListBox *p, REGD0 int flags, REGD1 int startnum, REGD2 BOOL refresh)
   {
	ListBoxItem *StartItem, *Previous = NULL, *it;

   Diagnostic("SortListBox", ENTER, TRUE);
   if (!p)
      {
      Diagnostic("SortListBox", EXIT, FALSE);
      return;
      }
	if (p->NoItems < 2)
		{
      Diagnostic("SortListBox", EXIT, TRUE);
		return;
		}

	if (StartItem = ItemElem(p, startnum))
		{
		if (startnum > 1)
			{
			if (Previous = ItemElem(p, startnum - 1))
				Previous = SetLast(Previous);
			if (!Previous)
				{
			   Diagnostic("SortListBox", EXIT, FALSE);
				return;
				}
			}

		SortITextList(&StartItem, flags);
		if (Previous)
			Previous->NextText = StartItem;
		else
			p->FirstItem = StartItem;

		// Now reset the topedges of each intuitext item
		if (it = p->FirstItem)
			{
			int top = it->TopEdge, t = 0;

			while (it)
				{
				if (it->TopEdge != top)
					{
					top = it->TopEdge;
					t++;
					}
				it->TopEdge = t * p->Font->ta_YSize;
				it = it->NextText;
				}
			}
		if (p->HiNum) // If an item was hilighted before sorting, reset to the first item.
			SetListBoxHiNum(p, 1, FALSE);
		SetListBoxTopNum(p, 1, refresh);
		}
	else
	   Diagnostic("SortListBox", EXIT, FALSE);
   Diagnostic("SortListBox", EXIT, TRUE);
   }

int FOXLIB NoTitles(REGA0 ListBox *lb)
	{
	if (lb)
		return lb->NoTitles;
	else
		return 0;
	}

int FOXLIB NoLines(REGA0 ListBox *lb)
	{
	if (lb)
		return NumLines(lb);
	else
		return 0;
	}

int FOXLIB TopNum(REGA0 ListBox *lb)
	{
	if (lb)
		return lb->TopShown;
	return 0;
	}

int FOXLIB HiNum(REGA0 ListBox *lb)
	{
	if (lb)
		return lb->HiNum;
	return 0;
	}

ListBoxItem* FOXLIB HiElem(REGA0 ListBox *lb)
	{
	if (lb)
		if (lb->HiItem)
			return lb->HiItem;
	return NULL;
	}

char* FOXLIB HiText(REGA0 ListBox *lb)
	{
	if (lb)
		if (lb->HiItem)
			return lb->HiItem->IText;
	return NULL;
	}

int FOXLIB FindListText(REGA0 ListBox *lb, REGA1 char *text, REGD0 int reqcolumn)
	{
	if (lb && text)
		{
		int line = 1, column = 1;
		struct IntuiText *it = lb->FirstItem;
		while (it)
			{
			if (strcmp(it->IText, text) == 0 && (column == reqcolumn || reqcolumn == 0))
				return line;
			if (it->NextText)
				if (it->NextText->TopEdge > it->TopEdge)
				{
					line++;
					column = 0;
				}
			column++;
			it = it->NextText;
			}
		}
	return 0;
	}

char* FOXLIB ListColumnText(REGA0 ListBox *lb, REGD0 int col)
	{
	if (lb)
		if (lb->HiItem)
			{
			if (col == 0)
				return lb->HiItem->IText;
			else
				{
				struct IntuiText *it = lb->HiItem;
				int top = it->TopEdge, ncol = 0;
				while (ncol < col && it)
					{
					it = it->NextText;
					ncol++;
					}
				if (it)
					if (it->TopEdge == top)
						return it->IText;
				}
			}
	return NULL;
	}

int ScrollUpButtFn(PushButton *pb)
	{
	ListBoxScrollUp((ListBox *) pb->WidgetData->ParentControl, TRUE);
	return GUI_CONTINUE;
	}

int ScrollDownButtFn(PushButton *pb)
	{
	ListBoxScrollDown((ListBox *) pb->WidgetData->ParentControl, TRUE);
	return GUI_CONTINUE;
	}

int ScrollLeftButtFn(PushButton *pb)
	{
	ListBox *lb = (ListBox*) pb->WidgetData->ParentControl;
	if (lb->xOffset < 0)
		{
		lb->xOffset += lb->Font->ta_YSize;
		if (lb->xOffset > 0)
			lb->xOffset = 0;
		UpdateHorizScroller(lb);
		ListBoxRefresh(lb);
		}
	return GUI_CONTINUE;
	}

int ScrollRightButtFn(PushButton *pb)
	{
	ListBox *lb = (ListBox*) pb->WidgetData->ParentControl;
	if (lb->xOffset + lb->LongestIntuiLen > lb->MaxIntuiLen)
		{
		lb->xOffset -= lb->Font->ta_YSize;
		if (lb->xOffset + lb->LongestIntuiLen < lb->MaxIntuiLen)
			lb->xOffset = lb->MaxIntuiLen - lb->LongestIntuiLen;
		UpdateHorizScroller(lb);
		ListBoxRefresh(lb);
		}
	return GUI_CONTINUE;
	}

static ListBoxItem *MakeIntuiTextList(ListBox *nlb, char *title, int frontpen, int backpen,
		int topedge, int drawmode, ListBoxItem **last)
	{
	// Construct a list of IntuiText's suitable for storing a tabbed string.
	short numtabs = 0, tabstops = 0;
	int index = 0, len;
	ListBoxItem *LastTitle = NULL, *it, *FirstTitle = NULL;
	int *ts;
	char *thisstr = title;

	if (nlb && title)
		{
		if (nlb->TabStop)
			while (nlb->TabStop[tabstops] != 0)
				tabstops++;

		// Count the usable tabs in the title string
		len = strlen(title);
		while (index < len)
			if (title[index++] == '\t' && numtabs < tabstops)
					numtabs++;

		ts = NULL;

		// Create numtabs+1 IntuiText's
		for (index = 0; index <= numtabs; index++)
			{
			int numchars;
			char *nextstrstart = strchr(thisstr, '\t');

			if (index < numtabs && nextstrstart)
				{
				char *tmp = thisstr;
				numchars = 0;
				while (tmp < nextstrstart)
					{
					numchars++;
					tmp = &(tmp[1]);
					}
				}
			else
				numchars = strlen(thisstr);

			it = (ListBoxItem *) GuiMalloc(sizeof(ListBoxItem), 0);
			if (!it)
				break; // Leave the loop but keep any we've allocated successfully
			if (last)
				*last = it;
			if (!(it->IText = (char *) GuiMalloc((numchars + 1) * sizeof(char), 0)))
				{
				GuiFree(it);
				break; // Leave the loop but keep any we've allocated successfully
				}

			it->TopEdge = topedge;
			it->ITextFont = nlb->Font;
			it->FrontPen = frontpen;
			it->BackPen = backpen;
			it->DrawMode = drawmode;
			it->NextText = NULL;
			it->LeftEdge = ListBoxLeftEdge(nlb, (ts ? *ts : 0));

			strncpy(it->IText, thisstr, numchars);
			it->IText[numchars] = 0;

			// if it's the last one, get rid of any extra tabs by replacing with spaces.
			if (index == numtabs)
				{
				int loop;
				for (loop = 0; loop < strlen(it->IText); loop++)
					if (it->IText[loop] == '\t')
						it->IText[loop] = ' ';
				}

			if (LastTitle)
				LastTitle->NextText = it;
			else
				FirstTitle = it;
			LastTitle = it;

			thisstr = nextstrstart;
			if (thisstr)
				thisstr = &(thisstr[1]); // jump over the tab.
			if (ts)
				ts = (ts[1] ? &ts[1] : NULL);
			else
				ts = nlb->TabStop;
			}
		}
	return FirstTitle;
	}

BOOL FOXLIB AddListBoxTitle(REGA0 ListBox *nlb, REGA1 char *title, REGD0 BOOL refresh)
	{
	unsigned short body, pot;
	int numlines, i;
	ListBoxItem *NewTitle, *last = NULL;
	Diagnostic("AddListBoxTitle", ENTER, TRUE);

	if (!(nlb && title))
		return Diagnostic("AddListBoxTitle", EXIT, FALSE);

	numlines = NumLines(nlb);

	// Check whether there's room for another title (must leave room for at least
	// one item and a horizontal scroll bar if there isn't one already)
	if (((nlb->NoTitles + 2) * nlb->Font->ta_YSize) + (4 * nlb->TBorder) + SCROLL_BUTTON_HEIGHT + 5 > nlb->WidgetData->height)
		return Diagnostic("AddListBoxTitle", EXIT, FALSE);

	if (!(NewTitle = MakeIntuiTextList(nlb, title, Gui.TextCol, 0, nlb->NoTitles * nlb->Font->ta_YSize, JAM1,
			&last)))
		return Diagnostic("AddListBoxTitle", EXIT, FALSE);

	if (nlb->FirstTitle == NULL)
		nlb->FirstTitle = NewTitle;
	else
		{
		ListBoxItem *next = nlb->FirstTitle;
		while (next->NextText)
			next = next->NextText;
		next->NextText = NewTitle;
		}

	(nlb->NoTitles)++;
	if (refresh && nlb->hidden == 0)
		{
		ListBoxRefresh(nlb);

		if (nlb->UD)
			{
			FindScrollerValues(nlb->NoItems, numlines, nlb->TopShown - 1, 1, &body, &pot);
			NewModifyProp(&nlb->UD->ScrollGad, nlb->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
			}
		}
	else
		nlb->modified = TRUE;

	if (last)
		{
		int Length = IntuiTextLength(last);
		int Tab = last->LeftEdge - nlb->LBorder - 2;
		if (Length + Tab > nlb->LongestIntuiLen)
			{
			nlb->LongestIntuiLen = Length + Tab;
			if (nlb->LR)
				UpdateHorizScroller(nlb);
			}
		}

	/* We need a loop here because we may have to make a horizontal scroller but not a vertical scroller
		so we make the horizontal one but doing that might then make us need a vertical scroller so we
		need to come back around the loop to create it! */
	for (i = 0; i < 2; i++)
		{
		if (nlb->NoItems > NumLines(nlb) && !nlb->UD)
			{
			MakeVerticalScroller(nlb, ScrollUpButtFn, ScrollDownButtFn);
			if (nlb->UD)
				{
				nlb->WidgetData->flags |= SYS_LB_VSCROLL;
				ResizeListBox(nlb, nlb->WidgetData->left, nlb->WidgetData->top, nlb->WidgetData->width, nlb->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
				if (nlb->hidden == 0)
					{
					AddGadget(nlb->Win->Win, &nlb->UD->ScrollGad, ~0);
					RefreshGList(&nlb->UD->ScrollGad, nlb->Win->Win, NULL, 1);
					}
				if (!nlb->Enabled)
					DisableScroller(nlb->UD);
				if (refresh)
					ListBoxRefresh(nlb);
				}
			}

		if (nlb->LongestIntuiLen > nlb->MaxIntuiLen && !nlb->LR)
			{
			nlb->WidgetData->flags |= SYS_LB_HSCROLL;
			ResizeListBox(nlb, nlb->WidgetData->left, nlb->WidgetData->top, nlb->WidgetData->width, nlb->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
			MakeHorizontalScroller(nlb, ScrollLeftButtFn, ScrollRightButtFn);
			if (refresh)
				ListBoxRefresh(nlb);
			}
		}
	return Diagnostic("AddListBoxTitle", EXIT, TRUE);
	}

static void FreeITextList(ListBoxItem *it)
	{
	ListBoxItem *next;
	while (it)
		{
		next = it->NextText;
		if (it->IText)
			GuiFree(it->IText);
		GuiFree(it);
		it = next;
		}
	}

static void CheckDestroyScrollers(ListBox *lb, BOOL refresh)
	{
	int i;

	// Check both twice because destroying the second could remove the need for the first.
	for (i = 0; i < 2; i++)
		{
		if (lb->LR)
			{
			int MaxAvailableLen = lb->MaxIntuiLen + SCROLL_BUTTON_WIDTH;

			if (lb->LongestIntuiLen <= MaxAvailableLen)
				DestroyHorizontalScroller(lb, refresh);
			}
		if (lb->UD)
			{
			// Recalc NumLines each time because destroying the LR scroller will change it.
			if (lb->NoItems <= NumLines(lb))
				DestroyVerticalScroller(lb, refresh);
			}
		}
	}

static int ItemLength(ListBox *lb, ListBoxItem *last)
	{
	// last is the last item in the IntuiTextList being added.
	if (last && lb)
		{
		int Tab = last->LeftEdge - lb->LBorder - 2;
		return Tab + IntuiTextLength(last);
		}
	return 0;
	}

static void SetLongestIntuiLen(ListBox *lb, int flags, BOOL refresh)
	{
	// flags: 1 = titles, 2 = items, 3 = both
	ListBoxItem *lbi = (flags == 2 ? lb->FirstItem : lb->FirstTitle);
	int il;

	lb->LongestIntuiLen = 0;
	while (flags > 0)
		{
		while (lbi)
			{
			if (lbi->NextText == NULL || lbi->NextText->TopEdge > lbi->TopEdge)
				if ((il = ItemLength(lb, lbi)) > lb->LongestIntuiLen)
					lb->LongestIntuiLen = il;
			lbi = lbi->NextText;
			}
		flags -= 2;
		lbi = lb->FirstItem;
		}
	CheckDestroyScrollers(lb, refresh);
	if (lb->LR && refresh)
		UpdateHorizScroller(lb);
	}

static void CheckMakeScrollers(ListBox *lb, BOOL refresh)
	{
	int i;

	/* We need a loop here because we may have to make a horizontal scroller but not a vertical scroller
		so we make the horizontal one but doing that might then make us need a vertical scroller so we
		need to come back around the loop to create it! */
	for (i = 0; i < 2; i++)
		{
		if (lb->NoItems > NumLines(lb) && !lb->UD)
			{
			MakeVerticalScroller(lb, ScrollUpButtFn, ScrollDownButtFn);
			if (lb->UD)
				{
				lb->WidgetData->flags |= SYS_LB_VSCROLL;
				ResizeListBox(lb, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
				if (lb->hidden == 0)
					{
					AddGadget(lb->Win->Win, &lb->UD->ScrollGad, ~0);
					RefreshGList(&lb->UD->ScrollGad, lb->Win->Win, NULL, 1);
					}
				if (!lb->Enabled)
					DisableScroller(lb->UD);
				if (refresh)
					ListBoxRefresh(lb);
				}
			}

		if (lb->LongestIntuiLen > lb->MaxIntuiLen && !lb->LR)
			{
			lb->WidgetData->flags |= SYS_LB_HSCROLL;
			ResizeListBox(lb, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, (double) 1.0, (double) 1.0, TRUE);
			MakeHorizontalScroller(lb, ScrollLeftButtFn, ScrollRightButtFn);
			if (refresh)
				ListBoxRefresh(lb);
			}
		}
	}

static void CheckLongestIntuiLen(ListBox *lb, ListBoxItem *last)
	{
	// last is the last item in the IntuiTextList being added.
	if (last && lb)
		{
		int Length = ItemLength(lb, last);
		if (Length > lb->LongestIntuiLen)
			{
			lb->LongestIntuiLen = Length;
			if (lb->LR)
				UpdateHorizScroller(lb);
			}
		}
	}

ListBoxItem* FOXLIB ReplaceListBoxItem(REGA0 ListBox *nlb, REGA1 char *item, REGA2 ListBoxItem *OldItem, REGD0 BOOL refresh)
	{
	int Itemnum, OldLength;
	ListBoxItem *NewItem, *OldItemPointer = nlb->FirstItem, *OldItemLast, *last = NULL, *NextText;
	Diagnostic("ReplaceListBoxItem", ENTER, TRUE);

	// ListBox item numbers start at 1 not 0.

	if (!(nlb && item && OldItem))
		{
		Diagnostic("ReplaceListBoxItem", EXIT, FALSE);
		return NULL;
		}
	OldItemLast = OldItem;
	Itemnum = ItemNum(nlb, OldItem);
	if (!Itemnum)
		{
		Diagnostic("ReplaceListBoxItem", EXIT, FALSE);
		return NULL;
		}

	/* By copying all of the colours from the old item, the new one will be shown correctly if it
		happens to be the currently hilighted one. */
	if (!(NewItem = MakeIntuiTextList(nlb, item, OldItem->FrontPen, OldItem->BackPen,
			OldItem->TopEdge, OldItem->DrawMode, &last)))
		{
		Diagnostic("ReplaceListBoxItem", EXIT, FALSE);
		return NULL;
		}

	while (OldItemLast && OldItemLast->NextText && OldItemLast->NextText->TopEdge == OldItemLast->TopEdge)
		OldItemLast = OldItemLast->NextText;

	NextText = OldItemLast->NextText;
	OldItemLast->NextText = NULL;
	OldLength = ItemLength(nlb, OldItemLast);
	if (OldItemPointer == OldItem)
		nlb->FirstItem = NewItem;
	else
		{
		while (OldItemPointer->NextText != OldItem)
			OldItemPointer = OldItemPointer->NextText;
		OldItemPointer->NextText = NewItem;
		}

	if (refresh && nlb->hidden == 0)
		{
		if (!nlb->modified)
			{
			if (Itemnum >= nlb->TopShown && Itemnum < nlb->TopShown + NumLines(nlb))
				{
				int top;
//				BOOL unclip = FALSE;

/*				if (!(nlb->WidgetData->flags & LB_CLIPPED))
					{
					ListBoxClipOn(nlb, -1);
					unclip = TRUE;
					} */
				if (nlb->NoTitles)
					top = nlb->WidgetData->top + ((nlb->NoTitles + 1 - nlb->TopShown) * nlb->Font->ta_YSize) + (3 * nlb->TBorder) + 4;
				else
					top = nlb->WidgetData->top + ((1 - nlb->TopShown) * nlb->Font->ta_YSize) + nlb->TBorder + 1;
				// Unprint the old text
				AreaColFill(nlb->Win->Win->RPort, nlb->WidgetData->left + OldItem->LeftEdge, top + OldItem->TopEdge, nlb->MaxIntuiLen, nlb->Font->ta_YSize, (nlb->HiItem == OldItem ? OldItem->FrontPen : GetBackCol(nlb->WidgetData->Parent)));
				// Print the new text
				PrintTabClippedText(nlb, NewItem, top);
//				PrintIText(nlb->Win->Win->RPort, NewItem, nlb->WidgetData->left + nlb->xOffset, top);

/*				if (unclip)
					ListBoxClipOff(nlb); */
				CheckLongestIntuiLen(nlb, last);
				}
			}
		else
			{
			last->NextText = NextText;
			ListBoxRefresh(nlb);
			}
		}
	else
		nlb->modified = TRUE;

	last->NextText = NextText;
	if (nlb->HiItem == OldItem)
		nlb->HiItem = NewItem;
	FreeITextList(OldItem);
	if (OldLength == nlb->LongestIntuiLen)
		SetLongestIntuiLen(nlb, 3, refresh);
	else if (ItemLength(nlb, last) == nlb->LongestIntuiLen)
		CheckMakeScrollers(nlb, refresh);
	return NewItem;
	}

ListBoxItem* FOXLIB AddListBoxItem(REGA0 ListBox *nlb, REGA1 char *item, REGD0 BOOL refresh)
	{
	ListBoxItem *NewItem, *last = NULL;
	unsigned short body, pot;
	int numlines;
	Diagnostic("AddListBoxItem", ENTER, TRUE);

	if (!(nlb && item))
		{
		Diagnostic("AddListBoxItem", EXIT, FALSE);
		return NULL;
		}

	numlines = NumLines(nlb);

	if (!(NewItem = MakeIntuiTextList(nlb, item, nlb->FrontPen, GetBackCol(nlb->WidgetData->Parent),
			nlb->NoItems * nlb->Font->ta_YSize, JAM2, &last)))
		{
		Diagnostic("AddListBoxItem", EXIT, FALSE);
		return NULL;
		}

	if (nlb->FirstItem == NULL)
		nlb->FirstItem = NewItem;
	else
		{
		ListBoxItem *next = nlb->FirstItem;
		while (next->NextText)
			next = next->NextText;
		next->NextText = NewItem;
		}

	(nlb->NoItems)++;
	if (refresh && nlb->hidden == 0)
		{
		if (!nlb->modified)
			{
/*			BOOL unclip = FALSE;

			if (!(nlb->WidgetData->flags & LB_CLIPPED))
				{
				ListBoxClipOn(nlb, -1);
				unclip = TRUE;
				} */
			/*	Nothing else has been changed since the last refresh so we just need
				to draw the new item */
			if (nlb->NoItems == 1)
				{
				int top;
				if (nlb->NoTitles)
					top = nlb->WidgetData->top + (nlb->NoTitles * nlb->Font->ta_YSize) + (3 * nlb->TBorder) + 4;
				else
					top = nlb->WidgetData->top + nlb->TBorder + 1;
				nlb->TopShown = 1;
				PrintTabClippedText(nlb, NewItem, top);
//				PrintIText(nlb->Win->Win->RPort, NewItem, nlb->WidgetData->left + nlb->xOffset, top);
				}
			else if (numlines > nlb->NoItems - nlb->TopShown)
				{
				int top;
				if (nlb->NoTitles)
					top = nlb->WidgetData->top + ((nlb->NoTitles + 1 - nlb->TopShown) * nlb->Font->ta_YSize) + (3 * nlb->TBorder) + 4;
				else
					top = nlb->WidgetData->top + ((1 - nlb->TopShown) * nlb->Font->ta_YSize) + nlb->TBorder + 1;
				PrintTabClippedText(nlb, NewItem, top);
//				PrintIText(nlb->Win->Win->RPort, NewItem, nlb->WidgetData->left + nlb->xOffset, top);
				}
//			if (unclip)
//				ListBoxClipOff(nlb);
			}
		else
			ListBoxRefresh(nlb);

		if (nlb->UD)
			{
			FindScrollerValues(nlb->NoItems, numlines, nlb->TopShown - 1, 1, &body, &pot);
			NewModifyProp(&nlb->UD->ScrollGad, nlb->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
			}
		}
	else
		nlb->modified = TRUE;

	CheckLongestIntuiLen(nlb, last);
	CheckMakeScrollers(nlb, refresh);

	Diagnostic("AddListBoxItem", EXIT, TRUE);
	return NewItem;
	}

ListBoxItem* FOXLIB InsertListBoxItem(REGA0 ListBox *nlb, REGA1 char *item, REGA2 ListBoxItem *after, REGD0 BOOL refresh)
	{
	ListBoxItem *NewItem, *i, *last = NULL;
	unsigned short body, pot;
	int numlines, numbefore = after ? 1 : 0;
	Diagnostic("InsertListBoxItem", ENTER, TRUE);

	if (!(nlb && item))
		{
		Diagnostic("InsertListBoxItem", EXIT, FALSE);
		return NULL;
		}

	numlines = NumLines(nlb);

	i = after ? nlb->FirstItem : NULL;
	while (i && after && i != after)
	{
		while (i->NextText && i->NextText->TopEdge == i->TopEdge)
			i = i->NextText;
		i = i->NextText;
		numbefore++;
	}
	if (i != after)
		{
		Diagnostic("InsertListBoxItem", EXIT, FALSE);
		return NULL;
		}

	if (!(NewItem = MakeIntuiTextList(nlb, item, nlb->FrontPen, GetBackCol(nlb->WidgetData->Parent),
			numbefore * nlb->Font->ta_YSize, JAM2, &last)))
		{
		Diagnostic("InsertListBoxItem", EXIT, FALSE);
		return NULL;
		}

	if (!after)
		{
		last->NextText = nlb->FirstItem;
		nlb->FirstItem = NewItem;
		}
	else
		{
		i = nlb->FirstItem;
		while (i && i != after)
			i = i->NextText;
		while (i->NextText && i->NextText->TopEdge == i->TopEdge)
			i = i->NextText;
		last->NextText = i->NextText;
		i->NextText = NewItem;
		}

	i = last->NextText;
	while (i)
	{
		i->TopEdge = i->TopEdge + nlb->Font->ta_YSize;
		if (i == nlb->HiItem) // We've inserted our new item before the hilighted one.
			nlb->HiNum++;
		i = i->NextText;
	}

	(nlb->NoItems)++;
	if (refresh && nlb->hidden == 0)
		{
		ListBoxRefresh(nlb);

		if (nlb->UD)
			{
			FindScrollerValues(nlb->NoItems, numlines, nlb->TopShown - 1, 1, &body, &pot);
			NewModifyProp(&nlb->UD->ScrollGad, nlb->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
			}
		}
	else
		nlb->modified = TRUE;

	CheckLongestIntuiLen(nlb, last);
	CheckMakeScrollers(nlb, refresh);

	Diagnostic("InsertListBoxItem", EXIT, TRUE);
	return NewItem;
	}

void FOXLIB ClearListBoxTitles(REGA0 ListBox *lb, REGD0 BOOL refresh)
	{
	if (lb)
		{
		FreeITextList(lb->FirstTitle);
		lb->FirstTitle = NULL;
		lb->NoTitles = 0;
		if (lb->UD && lb->NoItems < NumLines(lb))
			DestroyVerticalScroller(lb, refresh);
		SetLongestIntuiLen(lb, 2, refresh);
		if (refresh)
			ListBoxRefresh(lb);
		else
			lb->modified = TRUE;
		}
	}

void FOXLIB ClearListBoxItems(REGA0 ListBox *lb, REGD0 BOOL refresh)
	{
	if (lb)
		{
		FreeITextList(lb->FirstItem);
		lb->FirstItem = lb->HiItem = NULL;
		lb->NoItems = 0;
		lb->HiNum = 0;
		if (lb->UD && NumLines(lb) > 0)
			DestroyVerticalScroller(lb, refresh);
		SetLongestIntuiLen(lb, 1, refresh);
		if (refresh)
			ListBoxRefresh(lb);
		else
			lb->modified = TRUE;
		}
	}

BOOL DisableListBox(ListBox *lb)
	{
	Diagnostic("DisableListBox", ENTER, TRUE);
	if (lb)
		{
		if (lb->Enabled)
			{
			if (lb->UD)
				DisableScroller(lb->UD);

			if (lb->LR)
				DisableScroller(lb->LR);
			}
		lb->Enabled = FALSE;
		}
	return Diagnostic("DisableListBox", EXIT, lb != NULL);
	}

void DisableAllListBoxes(void)
	{
	ListBox *lb = Gui.FirstListBox;
	Diagnostic("DisableAllListBoxes", ENTER, TRUE);
	while (lb)
		{
		DisableListBox(lb);
		lb = lb->NextListBox;
		}
	Diagnostic("DisableAllListBoxes", EXIT, TRUE);
	}

void DisableWinListBoxes(GuiWindow *w)
	{
	ListBox *lb = Gui.FirstListBox;
	Diagnostic("DisableWinListBoxes", ENTER, TRUE);
	while (lb)
		{
		if (lb->Win == w)
			DisableListBox(lb);
		lb = lb->NextListBox;
		}
	Diagnostic("DisableWinListBoxes", EXIT, TRUE);
	}

BOOL EnableListBox(ListBox *lb)
	{
	Diagnostic("EnableListBox", ENTER, TRUE);
	if (lb)
		{
		if (lb->UD && !lb->Enabled)
			{
			// We have to pretend the button is not part of a list box or we can't enable it!
			lb->UD->ScrollUp->WidgetData->ParentControl = NULL;
			lb->UD->ScrollDown->WidgetData->ParentControl = NULL;
			EnableButton(lb->UD->ScrollUp);
			EnableButton(lb->UD->ScrollDown);
			lb->UD->ScrollUp->WidgetData->ParentControl = lb;
			lb->UD->ScrollDown->WidgetData->ParentControl = lb;

			if (lb->hidden == 0)
				// Add the scroll gadget to the window's gadget list
				AddGadget(lb->Win->Win, &lb->UD->ScrollGad, ~0);
			}

		if (lb->LR && !lb->Enabled)
			{
			lb->LR->ScrollUp->WidgetData->ParentControl = NULL;
			lb->LR->ScrollDown->WidgetData->ParentControl = NULL;
			EnableButton(lb->LR->ScrollUp);
			EnableButton(lb->LR->ScrollDown);
			lb->LR->ScrollUp->WidgetData->ParentControl = lb;
			lb->LR->ScrollDown->WidgetData->ParentControl = lb;

			if (lb->hidden == 0)
				AddGadget(lb->Win->Win, &lb->LR->ScrollGad, ~0);
			}

		lb->Enabled = TRUE;
		}
	return Diagnostic("EnableListBox", EXIT, lb != NULL);
	}

void EnableAllListBoxes(void)
	{
	ListBox *lb = Gui.FirstListBox;
	Diagnostic("EnableAllListBoxes", ENTER, TRUE);
	while (lb)
		{
		EnableListBox(lb);
		lb = lb->NextListBox;
		}
	Diagnostic("EnableAllListBoxes", EXIT, TRUE);
	}

void EnableWinListBoxes(GuiWindow *w)
	{
	ListBox *lb = Gui.FirstListBox;
	Diagnostic("EnableWinListBoxes", ENTER, TRUE);
	while (lb)
		{
		if (lb->Win == w)
			EnableListBox(lb);
		lb = lb->NextListBox;
		}
	Diagnostic("EnableWinListBoxes", EXIT, TRUE);
	}

void FOXLIB ClearListBoxTabStops(REGA0 ListBox *nlb, REGD0 BOOL refresh)
	{
	if (nlb)
		{
		if (nlb->TabStop)
			{
			GuiFree(nlb->TabStop);
			nlb->TabStop = NULL;
			}
		if (nlb->WidgetData->os)
			if (nlb->WidgetData->os->TabStop)
				{
				GuiFree(nlb->WidgetData->os->TabStop);
				nlb->WidgetData->os->TabStop = NULL;
				}
		if (refresh)
			ListBoxRefresh(nlb);
		else
			nlb->modified = TRUE;
		}
	}

BOOL FOXLIB SetListBoxTabStopsArray(REGA0 ListBox *nlb, REGD0 BOOL refresh, REGD1 short num, REGA1 int *tabs)
	{
	if (nlb && num > 0)
		{
		ClearListBoxTabStops(nlb, FALSE); // Don't refresh because if refresh is TRUE it will happen later anyway.

		if (nlb->TabStop = (int *) GuiMalloc((num + 1) * sizeof(int), 0))
			{
			if (nlb->WidgetData->os)
				{
				int i;
				if (nlb->WidgetData->os->TabStop = (int *) GuiMalloc((num + 1) * sizeof(int), 0))
					{
					memcpy(nlb->WidgetData->os->TabStop, tabs, num * sizeof(int));
					nlb->WidgetData->os->TabStop[num] = 0;
					}
				else
					{
					GuiFree(nlb->TabStop);
					nlb->TabStop = NULL;
					return FALSE;
					}
				for (i = 0; i < num; i++)
					nlb->TabStop[i] = (nlb->WidgetData->os->TabStop[i] * nlb->WidgetData->width) / nlb->WidgetData->os->width;
				}
			else
				memcpy(nlb->TabStop, tabs, num * sizeof(int));
			nlb->TabStop[num] = 0;
			}
		else
			return FALSE;
		if (refresh)
			ListBoxRefresh(nlb);
		else
			nlb->modified = TRUE;
		return TRUE;
		}
	return FALSE;
	}

BOOL SetListBoxTabStops(ListBox *nlb, BOOL refresh, short num, ...)
	{
	va_list argptr;

	if (nlb && num > 0)
		{
		int i;

		ClearListBoxTabStops(nlb, FALSE); // Don't refresh because if refresh is TRUE it will happen later anyway.
		va_start(argptr, num);

		if (nlb->WidgetData->os)
			{
			nlb->WidgetData->os->TabStop = (int *) GuiMalloc((num + 1) * sizeof(int), 0);
			if (!nlb->WidgetData->os->TabStop)
				return FALSE;
			}

		nlb->TabStop = (int *) GuiMalloc((num + 1) * sizeof(int), 0);
		if (!nlb->TabStop)
		{
			if (nlb->WidgetData->os)
				{
				GuiFree(nlb->WidgetData->os->TabStop);
				nlb->WidgetData->os->TabStop = NULL;
				}
			return FALSE;
		}

		for (i = 0; i < num; i++)
			{
			if (nlb->WidgetData->os)
				{
				nlb->WidgetData->os->TabStop[i] = va_arg(argptr, int);
				nlb->TabStop[i] = (nlb->WidgetData->os->TabStop[i] * nlb->WidgetData->width) / nlb->WidgetData->os->width;
				}
			else
				nlb->TabStop[i] = va_arg(argptr, int);
			}
		nlb->TabStop[num] = 0;

		va_end(argptr);
		if (refresh)
			ListBoxRefresh(nlb);
		else
			nlb->modified = TRUE;
		return TRUE;
		}
	return FALSE;
	}

BOOL ShowListBox(ListBox *lb)
	{
	Diagnostic("ShowListBox", ENTER, TRUE);
	if (lb)
		{
		if (lb->hidden == 1)
			{
			if (lb->UD)
				{
				ShowButton(lb->UD->ScrollUp);
				ShowButton(lb->UD->ScrollDown);
				}
			if (lb->LR)
				{
				ShowButton(lb->LR->ScrollUp);
				ShowButton(lb->LR->ScrollDown);
				}
			if ((!ISGUIWINDOW(lb->WidgetData->Parent)) && ((Frame *) lb->WidgetData->Parent)->hidden != 0)
				lb->hidden = -1;
			else
				{
				if (lb->UD)
					{
					AddGadget(lb->Win->Win, &lb->UD->ScrollGad, ~0);
					RefreshGList(&lb->UD->ScrollGad, lb->Win->Win, NULL, 1);
					if (!lb->Enabled)
						RemoveGadget(lb->Win->Win, &lb->UD->ScrollGad);
					}
				if (lb->LR)
					{
					AddGadget(lb->Win->Win, &lb->LR->ScrollGad, ~0);
					RefreshGList(&lb->LR->ScrollGad, lb->Win->Win, NULL, 1);
					if (!lb->Enabled)
						RemoveGadget(lb->Win->Win, &lb->LR->ScrollGad);
					}
				lb->hidden = 0;
				}
			}
		ListBoxRefresh(lb);
		return Diagnostic("ShowListBox", EXIT, TRUE);
		}
	return Diagnostic("ShowListBox", EXIT, FALSE);
	}

BOOL HideListBox(ListBox *lb)
	{
	Diagnostic("HideListBox", ENTER, TRUE);
	if (lb)
		{
		if (lb->UD)
			{
			HideButton(lb->UD->ScrollUp);
			HideButton(lb->UD->ScrollDown);
			}
		if (lb->LR)
			{
			HideButton(lb->LR->ScrollUp);
			HideButton(lb->LR->ScrollDown);
			}
		if (lb->hidden == 0)
			{
			if (lb->Enabled)
				{
				if (lb->UD)
					RemoveGadget(lb->Win->Win, &lb->UD->ScrollGad);
				if (lb->LR)
					RemoveGadget(lb->Win->Win, &lb->LR->ScrollGad);
				}
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, GetBackCol(lb->WidgetData->Parent));
			}
		lb->hidden = 1;
		return Diagnostic("HideListBox", EXIT, TRUE);
		}
	return Diagnostic("HideListBox", EXIT, FALSE);
	}

BOOL DestroyListBox(ListBox *lb, BOOL refresh)
	{
	Diagnostic("DestroyListBox", ENTER, TRUE);
	if (lb)
		{
		Frame *Child; // Could be any type of control
		ListBox *FindIt = Gui.FirstListBox, *FIprevious = NULL;

		if (refresh)
			HideListBox(lb);

		if (lb->itemlist) // Really a tree control
			FreeItemTree(lb->itemlist, NULL, refresh);
		ClearListBoxTitles(lb, FALSE);
		ClearListBoxItems(lb, FALSE);
		ClearListBoxTabStops(lb, FALSE);

		if (lb->LR)
			DestroyHorizontalScroller(lb, FALSE);

		if (lb->UD)
			DestroyVerticalScroller(lb, FALSE);

		while (FindIt && FindIt != lb)
			{
			FIprevious = FindIt;
			FindIt = FindIt->NextListBox;
			}
		if (FindIt)
			{
			if (FIprevious)
				FIprevious->NextListBox = lb->NextListBox;
			else
				Gui.FirstListBox = lb->NextListBox;
			}

		if (lb->WidgetData->os)
			GuiFree(lb->WidgetData->os);
		if (lb->Font)
			{
			if (lb->Font->ta_Name)
				GuiFree(lb->Font->ta_Name);
			GuiFree(lb->Font);
			}
		Child = lb->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
		GuiFree(lb->WidgetData);
		GuiFree(lb);
		return Diagnostic("DestroyListBox", EXIT, TRUE);
		}
	else
		return Diagnostic("DestroyListBox", EXIT, FALSE);
	}

void DestroyAllListBoxes(BOOL refresh)
	{
	ListBox *lb = Gui.FirstListBox, *nlb;
	Diagnostic("DestroyAllListBoxes", ENTER, TRUE);
	while (lb)
		{
		nlb = lb->NextListBox;
		DestroyListBox(lb, refresh);
		lb = nlb;
		}
	Diagnostic("DestroyAllListBoxes", EXIT, TRUE);
	}

void DestroyWinListBoxes(GuiWindow *w, BOOL refresh)
	{
	BOOL message = FALSE;
	ListBox *lb = Gui.FirstListBox, *nlb;
	Diagnostic("DestroyWinListBoxes", ENTER, TRUE);
	while (lb)
		{
		nlb = lb->NextListBox;
		if (lb->Win == w)
			{
			DestroyListBox(lb, refresh);
			message = TRUE;
			}
		lb = nlb;
		}
	if (Gui.CleanupFlag && message)
		SetLastErr("Window closed before all of its list boxes were destroyed.");
	Diagnostic("DestroyWinListBoxes", EXIT, TRUE);
	}

void ResizeListBox(ListBox *lb, int x, int y, int width, int height, double xfactor, double yfactor, BOOL eraseold)
	{
	UWORD GadPos = (unsigned short) -1;
	int newheight = height;

	if (lb->WidgetData->flags & SYS_LB_HSCROLL)
		newheight = height - SCROLL_BUTTON_HEIGHT - 1;

	if (eraseold)
		{
		/*	If the list box is in a coloured frame then no need to blank it because the parent frame will
			blank it's entire contents. */
		if (lb->hidden == 0 && GetBackCol(lb->WidgetData->Parent) == lb->Win->Win->RPort->BgPen)
			AreaColFill(lb->Win->Win->RPort, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, GetBackCol(lb->WidgetData->Parent));

		if (lb->UD)
			{
			// returns -1 for failure.
			GadPos = RemoveGList(lb->Win->Win, &lb->UD->ScrollGad, 1L);

			ResizeButton(lb->UD->ScrollDown, x + width - SCROLL_BUTTON_WIDTH, y + newheight - SCROLL_BUTTON_HEIGHT, lb->UD->ScrollDown->button.Width, lb->UD->ScrollDown->button.Height, FALSE);
			ResizeButton(lb->UD->ScrollUp, x + width - SCROLL_BUTTON_WIDTH, y, lb->UD->ScrollUp->button.Width, lb->UD->ScrollUp->button.Height, FALSE);
			}
		}

	/*	Remember when reading the numbers below that the full width of the list box
		is width which means that it goes from left to width-1.  Similarly, it goes
		from top to height-1 */

	if (lb->UD)
		{
		MakeBevel(&lb->UD->LightBorder, &lb->UD->DarkBorder, lb->UD->points, x + width -
				SCROLL_BUTTON_WIDTH, y + SCROLL_BUTTON_HEIGHT, SCROLL_BUTTON_WIDTH, newheight -
				(2 * SCROLL_BUTTON_HEIGHT), TRUE);
		if (!lb->NoTitles)
			{
			MakeBevel(&lb->LightBorder, &lb->DarkBorder, lb->points, x, y, width - SCROLL_BUTTON_WIDTH, newheight,
					TRUE);
			lb->DarkBorder.NextBorder = &lb->UD->LightBorder;
			}
		else
			{
			MakeBevel(&lb->LightBorder, &lb->DarkBorder, lb->points, x, y + (lb->NoTitles * lb->Font->ta_YSize)
					+ (2 * lb->TBorder) + 3, width - SCROLL_BUTTON_WIDTH, newheight - (3 + (2 * lb->TBorder) +
					(lb->NoTitles * lb->Font->ta_YSize)), TRUE);
			MakeBevel(&lb->TitleLightBorder, &lb->TitleDarkBorder, lb->titlebevelpoints, x, y, width -
					SCROLL_BUTTON_WIDTH, 2 + (2 * lb->TBorder) + (lb->NoTitles * lb->Font->ta_YSize), TRUE);
			lb->DarkBorder.NextBorder = &lb->TitleLightBorder;
			lb->TitleDarkBorder.NextBorder = &lb->UD->LightBorder;
			}
		if (lb->LR)
			lb->UD->DarkBorder.NextBorder = &lb->LR->LightBorder;
		/* If this definition of MaxIntuiLen (or the other below) is modified, the code in foxgui.c
			which decides how wide a pop-up list box should be must also be modified - it uses the
			reverse of the same formula to decide how wide to create the list box from the maximum
			IntuiTextLength required. */
		lb->MaxIntuiLen = width - SCROLL_BUTTON_WIDTH - 4 - (2 * lb->LBorder);

		lb->UD->ScrollGad.LeftEdge = x + width - SCROLL_BUTTON_WIDTH + 3;
		lb->UD->ScrollGad.TopEdge = y + SCROLL_BUTTON_HEIGHT + 3;
		lb->UD->ScrollGad.Height = newheight - (2 * SCROLL_BUTTON_HEIGHT) - 6;
		if (GadPos != -1)
			AddGList(lb->Win->Win, &lb->UD->ScrollGad, (unsigned long) GadPos, 1L, NULL);
		}
	else
		{
		if (!lb->NoTitles)
			{
			MakeBevel(&lb->LightBorder, &lb->DarkBorder, lb->points, x, y, width, newheight, TRUE);
			if (lb->LR)
				lb->DarkBorder.NextBorder = &lb->LR->LightBorder;
			}
		else
			{
			MakeBevel(&lb->LightBorder, &lb->DarkBorder, lb->points, x, y + (lb->NoTitles *
					lb->Font->ta_YSize) + (2 * lb->TBorder) + 3, width, newheight - (3 + (2 * lb->TBorder) +
					(lb->NoTitles * lb->Font->ta_YSize)), TRUE);
			MakeBevel(&lb->TitleLightBorder, &lb->TitleDarkBorder, lb->titlebevelpoints, x, y, width,
					2 + (2 * lb->TBorder) + (lb->NoTitles * lb->Font->ta_YSize), TRUE);
			lb->DarkBorder.NextBorder = &lb->TitleLightBorder;
			if (lb->LR)
				lb->TitleDarkBorder.NextBorder = &lb->LR->LightBorder;
			}
		/* If this definition of MaxIntuiLen (or the other above) is modified, the code in foxgui.c
			which decides how wide a pop-up list box should be must also be modified - it uses the
			reverse of the same formula to decide how wide to create the list box from the maximum
			IntuiTextLength required. */
		lb->MaxIntuiLen = width - 4 - (2 * lb->LBorder);
		}

	lb->WidgetData->left = x;
	lb->WidgetData->top = y;
	lb->WidgetData->width = width;
	lb->WidgetData->height = height;

	if (lb->LR)
		ResizeHorizontalScroller(lb, x, y, width, height, xfactor, yfactor, eraseold);
	}

short minuspoints[] = {0, 2, 4, 2};
short pluspoints[] = {2, 0, 2, 4};

ListBox *CreateListBox(void *Parent, int left, int top, int width, int height, int lborder,
		int tborder, int frontpen, struct TextAttr *font, int (* __far __stdargs Eventfn) (ListBox*, short, int, void**),
		int flags, char *objecttype)
{
	ListBox *lb;
	GuiWindow *win;
	Frame *ParentFrame = NULL;
	Diagnostic("CreateListBox", ENTER, TRUE);

	if (!Parent)
	{
		Diagnostic("CreateListBox", EXIT, FALSE);
		return NULL;
	}
	if (!(lb = (ListBox *) GuiMalloc(sizeof(ListBox), MEMF_CLEAR)))
	{
		Diagnostic("CreateListBox", EXIT, FALSE);
		return NULL;
	}
	if (!(lb->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), MEMF_CLEAR)))
	{
		GuiFree(lb);
		Diagnostic("CreateListBox", EXIT, FALSE);
		return NULL;
	}
	lb->WidgetData->Parent = Parent;
	lb->WidgetData->ObjectType = objecttype;
	lb->WidgetData->NextWidget = NULL;
	lb->WidgetData->ChildWidget = NULL;

	if (!ISGUIWINDOW(Parent))
	{
		ParentFrame = (Frame *) Parent;
		left += ParentFrame->button.LeftEdge;
		top += ParentFrame->button.TopEdge;
		win = (GuiWindow *) ParentFrame->button.UserData;
	}
	else
		win = (GuiWindow *) Parent;

	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	if (flags & S_AUTO_SIZE)
	{
		if (!(lb->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
		{
			GuiFree(lb->WidgetData);
			GuiFree(lb);
			Diagnostic("CreateListBox", EXIT, FALSE);
			return NULL;
		}
		lb->WidgetData->os->left = left;
		lb->WidgetData->os->top = top;
		lb->WidgetData->os->width = width;
		lb->WidgetData->os->height = height;
		lb->WidgetData->os->TabStop = NULL;
	}
	else
		lb->WidgetData->os = NULL;

	lb->Eventfn = Eventfn;
	lb->WidgetData->flags = flags;

	MakeDownArrow(&(lb->DownArrow), frontpen);
	MakeUpArrow(&(lb->UpArrow), frontpen);

	if (ParentFrame && ParentFrame->hidden != 0)
		lb->hidden = -1;
	else
		lb->hidden = 0;
	lb->Enabled = TRUE;
	lb->NoItems = lb->NoTitles = lb->TopShown = 0;
	lb->Win = win;
	lb->FrontPen = frontpen;
	if (font)
		lb->Font = CopyFont(font);
	else
		lb->Font = CopyFont(&GuiFont);

	if (objecttype == TreeControlObjectType)
	{
		lb->plus.LeftEdge = lb->minus.LeftEdge = 3;
		lb->plus.TopEdge = lb->minus.TopEdge = (lb->Font->ta_YSize - 5) / 2;
		lb->plus.BackPen = lb->minus.BackPen = 0;
		lb->plus.FrontPen = lb->minus.FrontPen = frontpen;
		lb->plus.DrawMode = lb->minus.DrawMode = JAM1;
		lb->plus.Count = lb->minus.Count = 2;
		lb->plus.XY = pluspoints;
		lb->minus.XY = minuspoints;
		lb->plus.NextBorder = &lb->minus;
		lb->minus.NextBorder = NULL;
	}

	lb->LBorder = lborder;
	lb->TBorder = tborder;
	lb->HiNum = 0; // Nothing selected initially.
	lb->FirstTitle = NULL;
	lb->FirstItem = lb->HiItem = NULL;
	lb->itemlist = lb->topshown = lb->hiitem = NULL;
	lb->TabStop = NULL;

	/* These are set up in ResizeListBox but we have to set them up now anyway because
		MakeVerticalScroller needs them. */
	lb->WidgetData->left = left;
	lb->WidgetData->top = top;
	lb->WidgetData->width = width;
	lb->WidgetData->height = height;

	if (flags & SYS_LB_VSCROLL)
		MakeVerticalScroller(lb, ScrollUpButtFn, ScrollDownButtFn);

	ResizeListBox(lb, left, top, width, height, (double) 1.0, (double) 1.0, FALSE);

	if (lb->hidden == 0 && lb->UD)
	{
		AddGadget(lb->Win->Win, &lb->UD->ScrollGad, ~0);
		RefreshGList(&lb->UD->ScrollGad, lb->Win->Win, NULL, 1);
	}

	lb->NextListBox = Gui.FirstListBox;
	Gui.FirstListBox = lb;

	if (lb->hidden == 0)
		DrawBorder(win->Win->RPort, &lb->LightBorder, 0, 0);
	Diagnostic("CreateListBox", EXIT, TRUE);
	return lb;
}

#ifdef OLDWAY
ListBox *CreateListBox(void *Parent, int left, int top, int width, int height, int lborder,
		int tborder, int frontpen, struct TextAttr *font, int (* __far __stdargs Eventfn) (ListBox*, short, int, void**),
		int flags)
	{
	ListBox *lb;
	GuiWindow *win;
	Frame *ParentFrame = NULL;
	Diagnostic("CreateListBox", ENTER, TRUE);

	if (!Parent)
		{
		Diagnostic("CreateListBox", EXIT, FALSE);
		return NULL;
		}
	if (!(lb = (ListBox *) GuiMalloc(sizeof(ListBox), MEMF_CLEAR)))
		{
		Diagnostic("CreateListBox", EXIT, FALSE);
		return NULL;
		}
	lb->WidgetData->Parent = Parent;
	lb->WidgetData->ObjectType = ListBoxObject;

	if (!ISGUIWINDOW(Parent))
		{
		ParentFrame = (Frame *) Parent;
		left += ParentFrame->button.LeftEdge;
		top += ParentFrame->button.TopEdge;
		win = (GuiWindow *) ParentFrame->button.UserData;
		}
	else
		win = (GuiWindow *) Parent;

	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	if (flags & S_AUTO_SIZE)
		{
		if (!(lb->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
			GuiFree(lb);
			Diagnostic("CreateListBox", EXIT, FALSE);
			return NULL;
			}
		lb->WidgetData->os->left = left;
		lb->WidgetData->os->top = top;
		lb->WidgetData->os->width = width;
		lb->WidgetData->os->height = height;
		lb->WidgetData->os->TabStop = NULL;
		}
	else
		lb->WidgetData->os = NULL;

	lb->Eventfn = Eventfn;
	lb->WidgetData->flags = flags;

	MakeDownArrow(&(lb->DownArrow), frontpen);
	MakeUpArrow(&(lb->UpArrow), frontpen);

	if (ParentFrame && ParentFrame->hidden != 0)
		lb->hidden = -1;
	else
		lb->hidden = 0;
	lb->Enabled = TRUE;
	lb->NoItems = lb->NoTitles = lb->TopShown = 0;
	lb->Win = win;
	lb->FrontPen = frontpen;
	if (font)
		lb->Font = font;
	else if (win->ParentScreen->Font)
		lb->Font = win->ParentScreen->Font;
	else
		lb->Font = &GuiFont;
	lb->LBorder = lborder;
	lb->TBorder = tborder;
	lb->HiNum = 0; // Nothing selected initially.
	lb->FirstTitle = NULL;
	lb->FirstItem = lb->HiItem = NULL;
	lb->TabStop = NULL;

	/* These are set up in ResizeListBox but we have to set them up now anyway because
		MakeVerticalScroller needs them. */
	lb->WidgetData->left = left;
	lb->WidgetData->top = top;
	lb->WidgetData->width = width;
	lb->WidgetData->height = height;

	if (flags & SYS_LB_VSCROLL)
		MakeVerticalScroller(lb, ScrollUpButtFn, ScrollDownButtFn);

	ResizeListBox(lb, left, top, width, height, (double) 1.0, (double) 1.0, FALSE);

	if (lb->hidden == 0 && lb->UD)
		{
		AddGadget(lb->Win->Win, &lb->UD->ScrollGad, ~0);
		RefreshGList(&lb->UD->ScrollGad, lb->Win->Win, NULL, 1);
		}

	lb->NextListBox = Gui.FirstListBox;
	Gui.FirstListBox = lb;

	if (lb->hidden == 0)
		DrawBorder(win->Win->RPort, &lb->LightBorder, 0, 0);
	Diagnostic("CreateListBox", EXIT, TRUE);
	return lb;
	}
#endif

ListBox* FOXLIB MakeListBox(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height, REGD4 int lborder,
		REGD5 int tborder, REGD6 int flags, REGA1 int (* __far __stdargs Eventfn) (ListBox*, short, int, void**), REGA2 void *extension)
	{
	ListBox *lb;

	Diagnostic("MakeListBox", ENTER, TRUE);

	lb = CreateListBox(Parent, left, top, width, height, lborder, tborder, Gui.TextCol, &GuiFont, Eventfn,
			flags, ListBoxObject);

	Diagnostic("MakeListBox", EXIT, (lb != NULL));
	return lb;
	}

void FOXLIB SetListBoxDragPointer(REGA0 ListBox *lb, REGA1 unsigned short *DragPointer, REGD0 int width, REGD1 int height,
		REGD2 int xoffset, REGD3 int yoffset)
{
	if (lb)
	{
		lb->DragPointer = DragPointer;
		lb->PointerWidth = width;
		lb->PointerHeight = height;
		lb->PointerXOffset = xoffset;
		lb->PointerYOffset = yoffset;
	}
}
