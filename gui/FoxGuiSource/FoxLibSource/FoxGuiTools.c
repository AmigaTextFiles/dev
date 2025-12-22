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
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/layers.h>
#include <proto/exec.h>
#include <devices/input.h>
#include <clib/alib_protos.h>
#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

/****************************************************************************************************
 * This module is for functions that are very general in nature and of potential use to more than   *
 * one gui module.                                                                                  *
 ****************************************************************************************************/

/****************************************************************************************************
 * Note that all functions use absolute (far) addressing rather than base relative (near)           *
 * addressing.  This is currently necessary because Characters.c calls the MakeBevel() function     *
 * directly which prevents the linker from moving this module away from Characters.o in memory.     *
 * When Characters.c no-longer calls MakeBevel() it may not be necessary for these to be declared   *
 * far.                                                                                             *
 ****************************************************************************************************/

#define RAWKEY_RETURN 0x0044

typedef struct GuiAllocStruct
	{
	/*	It's important that the header is 4 bytes long.  If it's 3 bytes then the unsigned after the
		header gets word-aligned making it impossible to calculate where the header starts. */
	char header[4];
	unsigned AllocSize[1];
	/* After this comes the actual memory allocation and then the footer.  Since the size is
		unknown we can't define the rest explicitly */
	} GuiAlloc;

static char *FindHeader(void *AllocStart)
	{
	register char *header;
	register unsigned *AllocSize = (unsigned *) AllocStart;
	AllocSize = &(AllocSize[-1]);
	header = (char *) AllocSize;
	return &(header[-4]);
	}

static char *FindFooter(GuiAlloc *p)
	{
	register char *AllocStart = (char *) &(p->AllocSize[1]);
	return &(AllocStart[p->AllocSize[0]]);
	}

void* FOXLIB GuiMalloc(REGD0 unsigned NoOfBytes, REGD1 unsigned long flags)
	{
	register void *retval = NULL;
	register GuiAlloc *p;

	if (FastMallocs)
		{
		if (flags & MEMF_CLEAR)
			return calloc(1, NoOfBytes);
		else
			return malloc(NoOfBytes);
		}

	if (flags & MEMF_CLEAR)
		p = (GuiAlloc *) calloc(1, sizeof(GuiAlloc) + NoOfBytes + (4 * sizeof(char)));
	else
		p = (GuiAlloc *) malloc(sizeof(GuiAlloc) + NoOfBytes + (4 * sizeof(char)));
	if (p)
		{
		register char *footer;
		retval = (void *) &(p->AllocSize[1]); // A pointer to the first byte after the AllocSize.
		p->header[0] = 'F';
		p->header[1] = 'o';
		p->header[2] = 'x';
		p->header[3] = 'y';
		p->AllocSize[0] = NoOfBytes;

		// Find the footer
		footer = FindFooter(p);
		footer[0] = 'G';
		footer[1] = 'u';
		footer[2] = 'i';
		footer[3] = '!';

		Gui.NumAllocs++;
		}
	return retval;
	}

/* This function is publically available (i.e. is currently prototyped in foxgui.h rather than
	guisys.h) but is not currently documented in FoxGui.guide because it would be unwise to let users
	get their hands on this when in FAST_MALLOCS mode it always returns TRUE! */

BOOL FOXLIB WasGuiMallocd(REGA0 void *p)
	{
	if (p)
		{
		register char *footer, *header;

		if (FastMallocs)
			return TRUE;

		header = FindHeader(p);
		if (strncmp(header, "Foxy", 4))
			return FALSE;
		footer = FindFooter((GuiAlloc *) header);
		if (strncmp(footer, "Gui!", 4))
			return FALSE;
		return TRUE;
		}
	return FALSE;
	}

void FOXLIB GuiFreeMem(REGA0 void *p, REGD0 int line, REGA1 char *fname)
	{
	char ErrMsg[255];
	if (p)
		{
		if (FastMallocs)
			{
			free(p);
			return;
			}

		if (WasGuiMallocd(p))
			{
			register GuiAlloc *header = (GuiAlloc *) FindHeader(p);
			/*	Remove the F of Foxy from the header so that multiple attempts to free the same piece of
				memory will fail. */
			header->header[0] = 0;
			free(header);
			Gui.NumAllocs--;
			}
		else
			{
			sprintf(ErrMsg, "Attempt to free an unallocated or currupted pointer at line %d in %s", line, fname);
			SetLastErrAndLine(ErrMsg,line);
			}
		}
	else
		{
		sprintf(ErrMsg, "Attempt to free a NULL pointer at line %d in %s", line, fname);
		SetLastErrAndLine(ErrMsg,line);
		}
	}

BOOL OFFSET Diagnostic(char *fn, short enter, BOOL succeed)
   {
#ifdef DIAGNOSTICS
   static int spc = 0;
   int l;
   char string[100];
   strcpy(string, "");
#ifndef DEBUG
	// if we're not in DEBUG mode then only do the following code when a debug file
	// has been specified.
   if (Gui.DebugFile)
      {
#endif
      if (!enter)
         spc -= 3;
      for (l = 0; l < spc; l++)
         strcat(string, " ");
      strcat(string, fn);
      if (enter)
         {
         strcat(string, " started");
         spc += 3;
         }
      else
         {
         strcat(string, " finished ");
         if (succeed)
            strcat(string, "successfully");
         else
            strcat(string, "unsuccessfully");
         }
      strcat(string, ".\n");
      if (spc == 0 && !enter)
         strcat(string, "\n");
#ifndef DEBUG
      }
#endif
   GuiReportError(string, GUI_WARNING);
#endif
   return succeed;
   }

/* This function works out the background colour for a control by looking at the parent window or
	frame.  It may also be necessary to look at the parent's parent etc so this function is recursive. */
BYTE OFFSET GetBackCol(void *Parent)
	{
	if (ISGUIWINDOW(Parent))
		return ((GuiWindow *) Parent)->Win->RPort->BgPen;
	else // The parent is a frame
		if (((Frame *) Parent)->WidgetData->flags & FM_CLEAR)
			return GetBackCol(((Frame *) Parent)->WidgetData->Parent);
		else
			return (BYTE) ((Frame *) Parent)->light.BackPen;
	}

BOOL OFFSET GadInWinList(struct Gadget *gad, struct Window *w)
	{
	struct Gadget *g = w->FirstGadget;

	while (g)
		{
		if (g == gad)
			return TRUE;
		g = g->NextGadget;
		}
	return FALSE;
	}

void OFFSET EnableGadget(struct Gadget *gad, struct Window *win, BOOL redraw)
	{
	// This is an alternative to calling intuitions OnGadget() because
	// OnGadget() will refresh not only the gadget that you enable but also
	// all gadgets that appear after it in the gadget list for that window.
	// If there are lots of gadgets in the window, OnGadget() can be VERY
	// slow.  This only refreshes the gadget that you are enabling.
	UWORD GadPos = RemoveGList(win, gad, 1L);
	// Occasionally, the call to RemoveGList (above) fails.  This only appears to
	// happen during the call to RestoreSysStatus() when GuiMessage() is closing it's
	// window and only for the first three gadgets that it tries to enable.  Since
	// these three gadgets fail to disable in the first place, it doesn't really
	// matter.  I don't know why this happens or which those gadgets are but it
	// doesn't matter as long as we don't add back the gadget that we failed to
	// remove from the gadget list.
	if (GadPos != -1)
		{
		gad->Flags ^= GFLG_DISABLED;
		AddGList(win, gad, (unsigned long) GadPos, 1L, NULL);
		if (redraw)
			RefreshGList(gad, win, NULL, 1L);
		}
	}

void OFFSET DisableGadget(struct Gadget *gad, struct Window *win, BOOL redraw)
	{
	// This is an alternative to calling intuitions OffGadget() because
	// OffGadget() will refresh not only the gadget that you disable but also
	// all gadgets that appear after it in the gadget list for that window.
	// If there are lots of gadgets in the window, OffGadget() can be VERY
	// slow.  This only refreshes the gadget that you are disabling.
	UWORD GadPos = RemoveGList(win, gad, 1L);
	// Occasionally, the call to RemoveGList (above) fails.  This only appears to
	// happen during the call to DisableEverything() when GuiMessage() is opening it's
	// window and only for the last three gadgets that it tries to disable.  The
	// call to EnableGadget fails similarly for the same three gadgets.  I don't
	// know why this happens or which those gadgets are but it doesn't matter as
	// long as we don't add back the gadget that we failed to remove from the gadget
	// list.
	if (GadPos != -1)
		{
		gad->Flags |= GFLG_DISABLED;
		AddGList(win, gad, (unsigned long) GadPos, 1L, NULL);
		if (redraw)
			RefreshGList(gad, win, NULL, 1L);
		}
	}

void OFFSET UnclipGuiWindow(GuiWindow *gw)
	{
	struct Region *OldRegion;

	if (OldRegion = InstallClipRegion(gw->Win->WLayer, NULL))
		DisposeRegion(OldRegion);
	}

struct Region OFFSET *ClipGuiWindow(GuiWindow *gw, long minx, long miny, long maxx, long maxy)
	{
	struct Region *NewReg;
	struct Rectangle rect;

	rect.MinX = minx;
	rect.MinY = miny;
	rect.MaxX = maxx;
	rect.MaxY = maxy;

	if (NewReg = NewRegion())
		if (!OrRectRegion(NewReg, &rect))
			{
			DisposeRegion(NewReg);
			NewReg = NULL;
			}
	return InstallClipRegion(gw->Win->WLayer, NewReg);
	}

TreeItem* FindPreviousItem(TreeItem *ti)
{
	TreeItem *p;

	// Traverse the list until we find the previous item.
	if (ti->parent)
	{
		p = ti->parent;
		if (p->firstchild != ti)
		{
			p = p->firstchild;
			while (p->next != ti)
				p = p->next;
			while ((p->firstchild && (p->flags & TI_OPEN)) || (p->next && p->next != ti))
				if (p->next && p->next != ti)
					p = p->next;
				else
					p = p->firstchild;
		}
	}
	else if (ti == ti->treecontrol->itemlist)
		return NULL;
	else
	{
		if (p = ti->treecontrol->itemlist)
		{
			while (p->next != ti)
				p = p->next;
			while ((p->firstchild && (p->flags & TI_OPEN)) || (p->next && p->next != ti))
				if (p->next && p->next != ti)
					p = p->next;
				else
					p = p->firstchild;
		}
	}
	return p;
}

void FreeItemTree(TreeItem *ti, TreeItem *masterparent, BOOL refresh)
{
	if (ti->firstchild)
		FreeItemTree(ti->firstchild, masterparent, refresh);
	if (ti->next)
		FreeItemTree(ti->next, masterparent, refresh);
	if (ti->treecontrol->topshown == ti)
		if (masterparent)
			ti->treecontrol->topshown = FindPreviousItem(masterparent);
		else
			ti->treecontrol->topshown = NULL;
	if (ti->bmi)
		GuiFree(ti->bmi);
	// Don't free the bitmap unless we allocated a copy - otherwise the user allocated it and should free
	//	it.  In this way, the user can use the same bitmap for many items in the list.
	if (ti->bm && (ti->flags & TI_BITMAPISSCALED))
		FreeGuiBitMap(ti->bm);
	if (ti->it.IText)
		GuiFree(ti->it.IText);
	if (ti->plusminus)
	{
		ti->plusminus->WidgetData->ParentControl = NULL;
		DestroyButton(ti->plusminus, refresh);
	}
	if (ti == ti->treecontrol->hiitem)
		ti->treecontrol->hiitem = NULL;
	GuiFree(ti);
}

static int FindTop(TreeItem *root, TreeItem *SearchFor, int CurTop, BOOL *found)
{
	if (root != SearchFor)
	{
		if (root->firstchild && (root->flags & TI_OPEN))
			CurTop = FindTop(root->firstchild, SearchFor, CurTop + root->it.ITextFont->ta_YSize, found);
		if (root->next && !*found)
			CurTop = FindTop(root->next, SearchFor, CurTop + root->it.ITextFont->ta_YSize, found);
	}
	else
		*found = TRUE;
	return CurTop;
}

int OFFSET CalcItemTop(TreeItem *ti)
{
	BOOL found1 = FALSE, found2 = FALSE;
	if (ti)
		return FindTop(ti->treecontrol->itemlist, ti, 0, &found1) - FindTop(ti->treecontrol->itemlist, ti->treecontrol->topshown, 0, &found2);
	else
		return 0;
}

void OFFSET FindMaxSizes(TreeItem *root, int *maxlen, int *maxtop, int *top)
{
	int length;

	if (!root)
		return;

	length = IntuiTextLength(&root->it) + root->it.LeftEdge;

	if (length > *maxlen)
		*maxlen = length;
	if (*top > *maxtop)
		*maxtop = *top;

	if (root->firstchild && (root->flags & TI_OPEN))
	{
		*top += root->it.ITextFont->ta_YSize;
		FindMaxSizes(root->firstchild, maxlen, maxtop, top);
	}
	if (root->next)
	{
		*top += root->it.ITextFont->ta_YSize;
		FindMaxSizes(root->next, maxlen, maxtop, top);
	}
}

void OFFSET DestroyVerticalScroller(ListBox *lb, BOOL refresh)
	{
	if (lb->UD)
		{
		if (lb->UD->ScrollUp)
			{
			// We have to pretend the button is not part of a list box or we can't destroy it!
			lb->UD->ScrollUp->WidgetData->ParentControl = NULL;
			DestroyButton(lb->UD->ScrollUp, FALSE);
			}
		if (lb->UD->ScrollDown)
			{
			// We have to pretend the button is not part of a list box or we can't destroy it!
			lb->UD->ScrollDown->WidgetData->ParentControl = NULL;
			DestroyButton(lb->UD->ScrollDown, FALSE);
			}

		if (lb->Enabled)
			RemoveGadget(lb->Win->Win, &lb->UD->ScrollGad);

		GuiFree(lb->UD);
		lb->UD = NULL;
		lb->WidgetData->flags &= ~SYS_LB_VSCROLL;
		if (lb->LR)
			lb->DarkBorder.NextBorder = &lb->LR->LightBorder;
		else
			lb->DarkBorder.NextBorder = NULL;

		ResizeListBox(lb, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, (double) 1.0, (double) 1.0, refresh);
		if (refresh)
			ListBoxRefresh(lb);
		}
	}

void OFFSET DestroyHorizontalScroller(ListBox *lb, BOOL refresh)
	{
	if (lb->LR)
		{
		if (lb->LR->ScrollUp)
			{
			// We have to pretend the button is not part of a list box or we can't destroy it!
			lb->LR->ScrollUp->WidgetData->ParentControl = NULL;
			DestroyButton(lb->LR->ScrollUp, FALSE);
			}
		if (lb->LR->ScrollDown)
			{
			// We have to pretend the button is not part of a list box or we can't destroy it!
			lb->LR->ScrollDown->WidgetData->ParentControl = NULL;
			DestroyButton(lb->LR->ScrollDown, FALSE);
			}

		if (lb->Enabled)
			RemoveGadget(lb->Win->Win, &lb->LR->ScrollGad);

		GuiFree(lb->LR);
		lb->LR = NULL;
		lb->WidgetData->flags &= ~SYS_LB_HSCROLL;
		lb->xOffset = 0;
		if (lb->UD)
			lb->UD->DarkBorder.NextBorder = NULL;
		else
			lb->DarkBorder.NextBorder = NULL;

		ResizeListBox(lb, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, (double) 1.0, (double) 1.0, refresh);
		if (refresh)
			ListBoxRefresh(lb);
		}
	}

void OFFSET ResizeHorizontalScroller(ListBox *lb, int x, int y, int width, int height, double xfactor, double yfactor, BOOL eraseold)
	{
	short ButtonWidthMult = 1;
	UWORD GadPos = (unsigned short) -1;

	if (lb->WidgetData->flags & SYS_LB_VSCROLL)
		ButtonWidthMult = 2;

	if (eraseold)
		{
		ResizeButton(lb->LR->ScrollDown, x, y + height - SCROLL_BUTTON_HEIGHT - 1, lb->LR->ScrollDown->button.Width, lb->LR->ScrollDown->button.Height, lb->LR->ScrollDown->hidden == 0);
		ResizeButton(lb->LR->ScrollUp, x + width - (ButtonWidthMult * SCROLL_BUTTON_WIDTH), y + height - SCROLL_BUTTON_HEIGHT - 1, lb->LR->ScrollUp->button.Width, lb->LR->ScrollUp->button.Height, lb->LR->ScrollUp->hidden == 0);
		// returns -1 for failure.
		GadPos = RemoveGList(lb->Win->Win, &lb->LR->ScrollGad, 1L);
		}

	/*	Remember when reading the numbers below that the full width of the list box
		is width which means that it goes from left to width-1.  Similarly, it goes
		from top to height-1 */

	MakeBevel(&lb->LR->LightBorder, &lb->LR->DarkBorder, lb->LR->points, x + SCROLL_BUTTON_WIDTH,
			y + height - SCROLL_BUTTON_HEIGHT - 1, width - ((ButtonWidthMult + 1) *
			SCROLL_BUTTON_WIDTH), SCROLL_BUTTON_HEIGHT, TRUE);

	lb->LR->ScrollGad.LeftEdge = x + SCROLL_BUTTON_WIDTH + 3;
	lb->LR->ScrollGad.TopEdge = y + height - SCROLL_BUTTON_HEIGHT + 1;
	lb->LR->ScrollGad.Width = width - ((ButtonWidthMult + 1) * SCROLL_BUTTON_WIDTH) - 6;
	if (GadPos != -1)
		AddGList(lb->Win->Win, &lb->LR->ScrollGad, (unsigned long) GadPos, 1L, NULL);
	}

void OFFSET MakeVerticalScroller(ListBox *lb, int (*ScrollUpFn)(PushButton*), int (*ScrollDownFn)(PushButton*))
	{
	int InitialLeft, InitialTop;
	int ButtonFlags = BN_CLEAR | BN_AR;

	if (!lb)
		return;
	if (lb->UD)
		return;
	if ((lb->UD = (Scroller*) GuiMalloc(sizeof(Scroller), MEMF_CLEAR)) == NULL)
		return;

	if (!ISGUIWINDOW(lb->WidgetData->Parent))
		{
		Frame *ParentFrame = (Frame *) lb->WidgetData->Parent;
		InitialLeft = lb->WidgetData->left - ParentFrame->button.LeftEdge;
		InitialTop = lb->WidgetData->top - ParentFrame->button.TopEdge;
		}
	else
		{
		InitialLeft = lb->WidgetData->left;
		InitialTop = lb->WidgetData->top;
		}

	if (lb->hidden == 1)
		ButtonFlags |= SYS_BN_HIDDEN;
	lb->UD->ScrollDown = MakeButton(lb->WidgetData->Parent, "", InitialLeft + lb->WidgetData->width - SCROLL_BUTTON_WIDTH, InitialTop + lb->WidgetData->height - SCROLL_BUTTON_HEIGHT, SCROLL_BUTTON_WIDTH, SCROLL_BUTTON_HEIGHT, 0, &(lb->DownArrow), ScrollDownFn, ButtonFlags, NULL);
	lb->UD->ScrollDown->WidgetData->ParentControl = lb;

	lb->UD->ScrollUp = MakeButton(lb->WidgetData->Parent, "", InitialLeft + lb->WidgetData->width - SCROLL_BUTTON_WIDTH, InitialTop, SCROLL_BUTTON_WIDTH, SCROLL_BUTTON_HEIGHT, 0, &(lb->UpArrow), ScrollUpFn, ButtonFlags, NULL);
	lb->UD->ScrollUp->WidgetData->ParentControl = lb;

	lb->UD->ScrollGadInfo.Flags = AUTOKNOB | FREEVERT | PROPNEWLOOK;
	lb->UD->ScrollGadInfo.HorizBody = (unsigned short) -1;
	lb->UD->ScrollGadInfo.VertBody = (unsigned short) -1;
	lb->UD->ScrollGad.Width = SCROLL_BUTTON_WIDTH - 6;
	lb->UD->ScrollGad.Activation = GACT_RELVERIFY | GACT_IMMEDIATE | GACT_FOLLOWMOUSE;
	lb->UD->ScrollGad.GadgetType = GTYP_PROPGADGET;
	lb->UD->ScrollGad.GadgetRender = &lb->UD->ScrollGadImage;
	lb->UD->ScrollGad.SpecialInfo = &lb->UD->ScrollGadInfo;
	lb->UD->ScrollGad.GadgetID = 1;
	}

void OFFSET DisableScroller(Scroller *sc)
	{
	if (sc)
		{
		ListBox *lb = (ListBox*) sc->ScrollUp->WidgetData->ParentControl;
		struct Window *win = lb->Win->Win;

		sc->ScrollUp->WidgetData->ParentControl = NULL;
		sc->ScrollDown->WidgetData->ParentControl = NULL;
		DisableButton(sc->ScrollUp);
		DisableButton(sc->ScrollDown);
		sc->ScrollUp->WidgetData->ParentControl = lb;
		sc->ScrollDown->WidgetData->ParentControl = lb;

		if (GadInWinList(&sc->ScrollGad, win))
			RemoveGadget(win, &sc->ScrollGad);
		}
	}

void OFFSET MakeHorizontalScroller(ListBox *lb, int (*ScrollLeftFn)(PushButton*), int (*ScrollRightFn)(PushButton*))
	{
	short ButtonWidthMult = 1, ButtonFlags = BN_CLEAR | BN_AR;
	int InitialLeft, InitialTop;

	if (!lb)
		return;
	if (lb->LR)
		return;
	if ((lb->LR = (Scroller*) GuiMalloc(sizeof(Scroller), MEMF_CLEAR)) == NULL)
		return;

	if (!ISGUIWINDOW(lb->WidgetData->Parent))
		{
		Frame *ParentFrame = (Frame *) lb->WidgetData->Parent;
		InitialLeft = lb->WidgetData->left - ParentFrame->button.LeftEdge;
		InitialTop = lb->WidgetData->top - ParentFrame->button.TopEdge;
		}
	else
		{
		InitialLeft = lb->WidgetData->left;
		InitialTop = lb->WidgetData->top;
		}

	if (lb->WidgetData->flags & SYS_LB_VSCROLL)
		ButtonWidthMult = 2;
	ResizeHorizontalScroller(lb, lb->WidgetData->left, lb->WidgetData->top, lb->WidgetData->width, lb->WidgetData->height, (double) 1.0, (double) 1.0, FALSE);
	if (lb->UD)
		lb->UD->DarkBorder.NextBorder = &lb->LR->LightBorder;
	else
		lb->DarkBorder.NextBorder = &lb->LR->LightBorder;
	if (lb->hidden == 1)
		ButtonFlags |= SYS_BN_HIDDEN;
	lb->LR->ScrollDown = MakeButton(lb->WidgetData->Parent, "<", InitialLeft, InitialTop + lb->WidgetData->height - SCROLL_BUTTON_HEIGHT - 1, SCROLL_BUTTON_WIDTH, SCROLL_BUTTON_HEIGHT, 0, NULL, ScrollLeftFn, ButtonFlags, NULL);
	lb->LR->ScrollDown->WidgetData->ParentControl = lb;

	lb->LR->ScrollUp = MakeButton(lb->WidgetData->Parent, ">", InitialLeft + lb->WidgetData->width - (ButtonWidthMult * SCROLL_BUTTON_WIDTH), InitialTop + lb->WidgetData->height - SCROLL_BUTTON_HEIGHT - 1, SCROLL_BUTTON_WIDTH, SCROLL_BUTTON_HEIGHT, 0, NULL, ScrollRightFn, ButtonFlags, NULL);
	lb->LR->ScrollUp->WidgetData->ParentControl = lb;

	lb->LR->ScrollGadInfo.Flags = AUTOKNOB | FREEHORIZ | PROPNEWLOOK;
	lb->LR->ScrollGadInfo.HorizBody = MAXBODY;
	lb->LR->ScrollGadInfo.VertBody = MAXBODY;
	lb->LR->ScrollGad.Height = SCROLL_BUTTON_HEIGHT - 4;
	lb->LR->ScrollGad.Activation = GACT_RELVERIFY | GACT_IMMEDIATE | GACT_FOLLOWMOUSE;
	lb->LR->ScrollGad.GadgetType = GTYP_PROPGADGET;
	lb->LR->ScrollGad.GadgetRender = &lb->LR->ScrollGadImage;
	lb->LR->ScrollGad.SpecialInfo = &lb->LR->ScrollGadInfo;
	lb->LR->ScrollGad.GadgetID = 2;

	if (lb->hidden == 0)
		{
		AddGadget(lb->Win->Win, &lb->LR->ScrollGad, ~0);
		RefreshGList(&lb->LR->ScrollGad, lb->Win->Win, NULL, 1);
		DrawBorder(lb->Win->Win->RPort, &lb->LightBorder, 0, 0);
		}
	if (!lb->Enabled)
		DisableScroller(lb->LR);
	}

struct IntuiText OFFSET *SetLast(struct IntuiText *it)
	{
	if (it && it->NextText)
		{
		int top = it->TopEdge;
		while (it->NextText && it->NextText->TopEdge == top)
			it = it->NextText;
		}
	return it;
	}

static struct IntuiText *NextEntry(struct IntuiText *it)
	{
	if (it)
		{
		int top = it->TopEdge;
		while (it && it->TopEdge == top)
			it = it->NextText;
		}
	return it;
	}

void OFFSET SortITextList(struct IntuiText **FirstItem, int flags)
	{
   struct IntuiText *smallest, *start = *FirstItem, *ptr, *smallestprev, *startprev = NULL, *ptrprev;

   while (start)
      {
      smallest = start;
      smallestprev = startprev;
		ptr = NextEntry(start);
      ptrprev = start;
      while (ptr)
         {
			if (flags & NUM_ASCENDING || flags & NUM_DESCENDING)
				{
				if (atoi(flags & NUM_ASCENDING ? ptr->IText : smallest->IText)
					< atoi(flags & NUM_ASCENDING ? smallest->IText : ptr->IText))
					{
         	   smallest = ptr;
            	smallestprev = ptrprev;
					}
				}
			else if (flags & IGNORE_CASE)
				{
				if (stricmp(flags & ASCENDING ? ptr->IText : smallest->IText, flags & ASCENDING ?
						smallest->IText : ptr->IText) < 0)
					{
					smallest = ptr;
					smallestprev = ptrprev;
					}
				}
			else if (strcmp(flags & ASCENDING ? ptr->IText : smallest->IText, flags & ASCENDING ?
					smallest->IText : ptr->IText) < 0)
     	      {
        	   smallest = ptr;
           	smallestprev = ptrprev;
            }
         ptrprev = ptr;
			ptr = NextEntry(ptr);
         }
      if (smallest != start)
         {
			struct IntuiText *lsmallest, *lsmallestprev, *lstartprev;
			lsmallest = SetLast(smallest);
			lsmallestprev = SetLast(smallestprev);
			lstartprev = SetLast(startprev);

         if (lsmallestprev)
            lsmallestprev->NextText = lsmallest->NextText;
         else
            *FirstItem = lsmallest->NextText;
         if (lstartprev)
            lstartprev->NextText = smallest;
         else
            *FirstItem = smallest;
         lsmallest->NextText = start;
         }
      else
			start = NextEntry(start);
      if (start == *FirstItem)
         startprev = NULL;
      else
			{
			int top;
			startprev = *FirstItem;
			while (startprev && startprev->NextText && startprev->NextText != start)
				startprev = startprev->NextText;
			// Found the entry before the start one.  Now find the first one at this height
			top = startprev->TopEdge;
			startprev = *FirstItem;
			while (startprev && startprev->TopEdge != top)
				startprev = startprev->NextText;
			}
      }
	}

unsigned short OFFSET GetFontHeight(GuiWindow *win)
	{
	if (win)
		{
		struct TextAttr *font = win->ParentScreen->Font;

		if (font)
			return font->ta_YSize;
		else
			return GuiFont.ta_YSize;
		}
	return 0;
	}

/* Fakes an Input Event. If Window is Non NULL it will
	clean its MessagePort. (W.D.L 900407) */
void OFFSET FakeInputEvent(LONG eventclass, LONG Code, LONG Qualifier, LONG x, LONG y, struct Window *Window)
	{
	struct MsgPort *ioport;
	struct IOStdReq *ioreq;
	struct InputEvent event;

	memset(&event,0,sizeof (event));

	if (ioport = (struct MsgPort *)CreatePort("AV.TempPort", 0))
		{
		if (ioreq = (struct IOStdReq *)CreateStdIO(ioport))
			{
			if (!OpenDevice("input.device",0,(struct IORequest*) ioreq,0))
				{
				event.ie_Class = eventclass;
				event.ie_Code = Code;
				event.ie_X = x;
				event.ie_Y = y;
				event.ie_Qualifier = Qualifier;
				event.ie_NextEvent = NULL;
				ioreq->io_Command = IND_WRITEEVENT;
				ioreq->io_Length = sizeof(struct InputEvent);
				ioreq->io_Data = (APTR)&event;
				DoIO((struct IORequest*) ioreq);
				CloseDevice((struct IORequest*) ioreq);
				}
			DeleteStdIO(ioreq);
			}
		DeletePort(ioport);
		}

//	if (Window)
//		CleanMsgPort(Window->UserPort);

} /* FakeInputEvent */

// Deactivates a string gadget by faking a Keydown/Keyup pair for the return key.
void OFFSET DeActivateStrGad(void)
	{
	FakeInputEvent(IECLASS_RAWKEY, RAWKEY_RETURN, NULL, 0, 0, NULL);
	FakeInputEvent(IECLASS_RAWKEY, RAWKEY_RETURN | IECODE_UP_PREFIX, NULL, 0, 0, NULL);
	}

/* This function returns the topmost usable pixel in a window which has a title.  You can send a window
	as a parameter or you can send a screen in which case the value returned will be correct for any
	window opened in that screen which has a title. */
int OFFSET TopWindowPixel(struct Screen *Screen, GuiWindow *Window)
	{
	if (Screen || Window)
		{
		struct Screen *sc = Screen;
		if (!sc)
			sc = Window->ParentScreen;
		return sc->WBorTop + sc->Font->ta_YSize + 2;
		}
	return -1;
	}

void OFFSET MakeBevel(struct Border *light, struct Border *dark, short *points, int left,
		int top, int width, int height, BOOL raised)
	{
	int hicol, locol;

	if (raised)
		{
		hicol = Gui.HiPen;
		locol = Gui.LoPen;
		}
	else
		{
		hicol = Gui.LoPen;
		locol = Gui.HiPen;
		}
	light->DrawMode = dark->DrawMode = JAM1;
	light->Count = dark->Count = 5;
	light->LeftEdge = dark->LeftEdge = left;
	light->TopEdge = dark->TopEdge = top;
	light->FrontPen = hicol;
	light->NextBorder = dark;
	light->XY = points;
	dark->FrontPen = locol;
	dark->NextBorder = NULL;
	dark->XY = &(points[10]);

	points[1] = points[2] = points[3] = points[4] = points[15] = 0;
	points[6] = points[8] = points[9] = points[10] = points[17] = 1;
	points[5] = points[11] = points[13] = height - 1;
	points[7] = points[19] = height - 2;
	points[12] = points[14] = width - 1;
	points[0] = points[16] = points[18] = width - 2;
	}

short downarrow[] = {4,3,7,6,10,3,11,3,8,6,5,3};
short uparrow[] = {4,6,7,3,10,6,11,6,8,3,5,6};

void OFFSET MakeDownArrow(struct Border *arrow, int col)
	{
	arrow->DrawMode = JAM1;
	arrow->Count = 6;
	arrow->LeftEdge = arrow->TopEdge = 0;
	arrow->FrontPen = col;
	arrow->NextBorder = NULL;
	arrow->XY = downarrow;
	}

void OFFSET MakeUpArrow(struct Border *arrow, int col)
	{
	arrow->DrawMode = JAM1;
	arrow->Count = 6;
	arrow->LeftEdge = arrow->TopEdge = 0;
	arrow->FrontPen = col;
	arrow->NextBorder = NULL;
	arrow->XY = uparrow;
	}

void OFFSET FindScrollerValues(unsigned short total, unsigned short displayable,
		unsigned short top, short overlap, unsigned short *body, unsigned short *pot)
	{
	unsigned short hidden = max(total - displayable, 0);

	if (overlap >= displayable)
		overlap = displayable - 1;

	if (top > hidden)
		top = hidden;

	*body = hidden > 0 ? (unsigned short) (((unsigned long) (displayable - overlap) * MAXBODY) / (total - overlap)) : MAXBODY;
	*pot = hidden > 0 ? (unsigned short) (((unsigned long) top * MAXPOT) / hidden) : 0;
	}

unsigned short OFFSET FindScrollerTop(unsigned short total, unsigned short displayable, unsigned short pot)
	{
	unsigned short top, hidden = max(total - displayable, 0);
	top = (((unsigned long) hidden * pot) + (MAXPOT / 2)) >> 16;
	return top;
	}

void OFFSET AreaColFill(struct RastPort *rp, int left, int top, int width, int height, int col)
	{
	if (rp)
		{
		/*	Copy the RastPort's foreground pen and then set it equal to the specified
			colour */
		char FgPen = rp->FgPen;

		SetAPen(rp, (char) col);
		// RectFill() the area and then reset the pens.
		RectFill(rp, left, top, left + width - 1, top + height - 1);
		SetAPen(rp, FgPen);
		}
	}

void OFFSET AreaBlank(struct RastPort *rp, int left, int top, int width, int height)
	{
	if (rp)
		AreaColFill(rp, left, top, width, height, (int) rp->BgPen);
	}

void OFFSET UnTruncateIText(struct IntuiText *IText, char *Original)
	{
	IText->IText = &Original[1]; // Reset the IText pointer (Original[0] is the trunc char)
	if (Original[0])
		{
		Original[strlen(Original)] = Original[0]; // replace the trunc char in the main string
		Original[0] = 0; // Clear the trunc char
		}
	}

void OFFSET TruncateIText(struct IntuiText *IText, char *Original, int MaxLen, int flags)
	{
	int len;

	UnTruncateIText(IText, Original);

	while ((len = strlen(IText->IText)) > 0 && IntuiTextLength(IText) > MaxLen)
		{
		if ((flags & JUSTIFY_RIGHT) || ((flags & JUSTIFY_CENTRE) && len % 2))
			IText->IText = &(IText->IText[1]);
		else
			{
			if (Original[0])
				IText->IText[len] = Original[0];
			Original[0] = IText->IText[len - 1];
			IText->IText[len - 1] = 0;
			}
		}
	}

struct TextAttr OFFSET *CopyFont(struct TextAttr *font)
{
	struct TextAttr *copy = GuiMalloc(sizeof(struct TextAttr), 0);

	if (copy)
	{
		copy->ta_Name = GuiMalloc((strlen(font->ta_Name) + 1) * sizeof(char), 0);
		if (copy->ta_Name)
			strcpy(copy->ta_Name, font->ta_Name);
		else
		{
			GuiFree(copy);
			return NULL;
		}
		copy->ta_YSize = font->ta_YSize;
		copy->ta_Style = font->ta_Style;
		copy->ta_Flags = font->ta_Flags;
	}
	return copy;
}
