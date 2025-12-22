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
#include <string.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

#define RBWIN(r)	((struct Window *) r->RBGad.UserData)
#define TBWIN(t)	((struct Window *) t->TickBoxGad.UserData)

void EnableRadioButton(RadioButton *rb)
   {
   Diagnostic("EnableRadioButton", ENTER, TRUE);
	if (rb && !rb->Active)
		{
		struct Window *wptr = (struct Window *) rb->RBGad.UserData;

		/*	If the button is clear, only the border will be refreshed, leaving the rest of the button
			still looking shaded and disabled.  Clear it here before refreshing. */
		if (rb->hidden == 0)
			{
			AreaBlank(wptr->RPort, rb->RBGad.LeftEdge, rb->RBGad.TopEdge, rb->RBGad.Width, rb->RBGad.Height);
			EnableGadget(&rb->RBGad, wptr, TRUE);
			DrawRBCentre(rb);
			}
		else // Radiobutton is hidden.
			rb->RBGad.Flags ^= GFLG_DISABLED;
		rb->Active = TRUE;
		Diagnostic("EnableRadioButton", EXIT, TRUE);
		}
	else
		Diagnostic("EnableRadioButton", EXIT, FALSE);
   }

void DisableRadioButton(RadioButton *rb)
   {
   Diagnostic("DisableRadioButton", ENTER, TRUE);
	if (rb && rb->Active)
		{
		struct Window *wptr = (struct Window *) rb->RBGad.UserData;

		if (rb->hidden == 0)
			DisableGadget(&rb->RBGad, wptr, TRUE);
		else // Radiobutton is hidden.
			rb->RBGad.Flags |= GFLG_DISABLED;
		rb->Active = FALSE;
		Diagnostic("DisableRadioButton", EXIT, TRUE);
		}
	else
		Diagnostic("DisableRadioButton", EXIT, FALSE);
   }

void EnableTickBox(TickBox *tb)
   {
   Diagnostic("EnableTickBox", ENTER, TRUE);
	if (tb && !tb->Active)
		{
		struct Window *wptr = (struct Window *) tb->TickBoxGad.UserData;

		if (tb->hidden == 0)
			{
			/* Only the border will be refreshed, leaving the rest of the tick box still looking shaded and
				disabled.  Clear it here before refreshing. */
			AreaColFill(wptr->RPort, tb->TickBoxGad.LeftEdge, tb->TickBoxGad.TopEdge, tb->TickBoxGad.Width,
					tb->TickBoxGad.Height, tb->WidgetData->flags & BG_CLEAR ? wptr->RPort->BgPen : tb->nsTick.FrontPen);
			EnableGadget(&(tb->TickBoxGad), wptr, TRUE);
			}
		else
			tb->TickBoxGad.Flags ^= GFLG_DISABLED;
		tb->Active = TRUE;
		Diagnostic("EnableTickBox", EXIT, TRUE);
		}
	else
		Diagnostic("EnableTickBox", EXIT, FALSE);
   }

void DisableTickBox(TickBox *tb)
   {
   Diagnostic("DisableTickBox", ENTER, TRUE);
	if (tb && tb->Active)
		{
		struct Window *wptr = (struct Window *) tb->TickBoxGad.UserData;

		if (tb->hidden == 0)
			DisableGadget(&tb->TickBoxGad, wptr, TRUE);
		else // Tickbox is hidden
			tb->TickBoxGad.Flags |= GFLG_DISABLED;
		tb->Active = FALSE;
		Diagnostic("DisableTickBox", EXIT, TRUE);
		}
	else
		Diagnostic("DisableTickBox", EXIT, FALSE);
   }

BOOL FOXLIB SetTickBoxValue(REGA0 TickBox *tb, REGD0 BOOL value)
	{
	UWORD GadPos = RemoveGList((struct Window *) tb->TickBoxGad.UserData, &tb->TickBoxGad, 1L);
	if (GadPos != -1)
		{
		tb->Ticked = value;
		tb->TickBoxGad.GadgetRender = (APTR) (tb->Ticked ? &tb->sTick : &tb->nsTick);
		AddGList((struct Window *) tb->TickBoxGad.UserData, &tb->TickBoxGad, (unsigned long)
				GadPos, 1L, NULL);
		RefreshGList(&tb->TickBoxGad, (struct Window *) tb->TickBoxGad.UserData, NULL, 1);
		return TRUE;
		}
	return FALSE;
	}

BOOL FOXLIB TickBoxValue(REGA0 TickBox *tb)
	{
	Diagnostic("TickBoxValue", ENTER, TRUE);
	if (tb)
		{
		Diagnostic("TickBoxValue", EXIT, TRUE);
		return tb->Ticked;
		}
	return Diagnostic("TickBoxValue", EXIT, FALSE);
	}

BOOL ShowTickBox(TickBox *tb)
	{
	Diagnostic("ShowTickBox", ENTER, TRUE);
	if (tb)
		{
		BOOL InFrame = !ISGUIWINDOW(tb->WidgetData->Parent);

		if (tb->hidden == 1) // The tick box is really hidden
			if (InFrame && ((Frame *) tb->WidgetData->Parent)->hidden != 0) // The tick box is in a hidden frame so it remains hidden
				tb->hidden = -1;
			else
				{
				struct Window *w = (struct Window *) tb->TickBoxGad.UserData;

				AddGadget(w, &tb->TickBoxGad, -1);
				if (!(tb->WidgetData->flags & BG_CLEAR))
					AreaColFill(w->RPort, tb->TickBoxGad.LeftEdge, tb->TickBoxGad.TopEdge, tb->TickBoxGad.Width,
							tb->TickBoxGad.Height, tb->nsTick.FrontPen);
				RefreshGList(&tb->TickBoxGad, w, NULL, 1);
				tb->hidden = 0;
				}
		return Diagnostic("ShowTickBox", EXIT, TRUE);
		}
	return Diagnostic("ShowTickBox", EXIT, FALSE);
	}

BOOL HideTickBox(TickBox *tb)
	{
	Diagnostic("HideTickBox", ENTER, TRUE);
	if (tb)
		{
		if (tb->hidden == 0)
			{
			BYTE BackCol = GetBackCol(tb->WidgetData->Parent);
			struct Window *w = (struct Window *) tb->TickBoxGad.UserData;

			RemoveGadget(w, &(tb->TickBoxGad));
			AreaColFill(w->RPort, tb->TickBoxGad.LeftEdge, tb->TickBoxGad.TopEdge, tb->TickBoxGad.Width,
					tb->TickBoxGad.Height, BackCol);
			}
		tb->hidden = 1;
		return Diagnostic("HideTickBox", EXIT, TRUE);
		}
	return Diagnostic("HideTickBox", EXIT, FALSE);
	}

void DestroyTickBox(TickBox *tb, BOOL refresh)
	{
	Frame *Child; // Couild be any object type.

	Diagnostic("DestroyTickBox", ENTER, TRUE);
	if (!tb)
		{
		Diagnostic("DestroyTickBox", EXIT, FALSE);
		return;
		}
	if (tb->hidden == 0)
		{
		if (refresh)
			HideTickBox(tb);
		else
			RemoveGadget((struct Window *) tb->TickBoxGad.UserData, &(tb->TickBoxGad));
		}
	if (tb == Gui.FirstTickBox)
		Gui.FirstTickBox = tb->Next;
	else
		{
		TickBox *prev = Gui.FirstTickBox;
		while (prev->Next != tb)
			prev = prev->Next;
		prev->Next = tb->Next;
		}
	if (tb->WidgetData->os)
		GuiFree(tb->WidgetData->os);
	Child = tb->WidgetData->ChildWidget;
	while (Child)
		{
		void *next = Child->WidgetData->NextWidget;
		Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
		Destroy(Child, refresh);
		Child = next;
		}
	GuiFree(tb->WidgetData);
	GuiFree(tb);
	Diagnostic("DestroyTickBox", EXIT, TRUE);
	}

/* Given a pointer to any radio button, this function returns a pointer to the active member of the
	group.  If no member of the group is active or an error occurs, NULL is returned. */
RadioButton* FOXLIB ActiveRadioButton(REGA0 RadioButton *rb)
	{
	if (rb)
		{
		struct MutexList *ml = rb->MList;

		while (ml)
			{
			if (ml->Mutex->RBGad.Flags & GFLG_SELECTED)
				return ml->Mutex;
			ml = ml->Next;
			}
		}
	return NULL;
	}

BOOL ShowRadioButton(RadioButton *rb)
	{
	Diagnostic("ShowRadioButton", ENTER, TRUE);
	if (rb)
		{
		BOOL InFrame = !ISGUIWINDOW(rb->WidgetData->Parent);

		if (rb->hidden == 1) // The radio button is really hidden
			if (InFrame && ((Frame *) rb->WidgetData->Parent)->hidden != 0) // The radio button is in a hidden frame so it remains hidden
				rb->hidden = -1;
			else
				{
				struct Window *w = (struct Window *) rb->RBGad.UserData;

				AddGadget(w, &rb->RBGad, -1);
				DrawRBCentre(rb);
				RefreshGList(&rb->RBGad, w, NULL, 1);
				rb->hidden = 0;
				}
		return Diagnostic("ShowRadioButton", EXIT, TRUE);
		}
	return Diagnostic("ShowRadioButton", EXIT, FALSE);
	}

BOOL HideRadioButton(RadioButton *rb)
	{
	Diagnostic("HideRadioButton", ENTER, TRUE);
	if (rb)
		{
		if (rb->hidden == 0)
			{
			BYTE BackCol = GetBackCol(rb->WidgetData->Parent);
			struct Window *w = (struct Window *) rb->RBGad.UserData;

			RemoveGadget(w, &rb->RBGad);
			AreaColFill(w->RPort, rb->RBGad.LeftEdge, rb->RBGad.TopEdge, rb->RBGad.Width, rb->RBGad.Height,
					BackCol);
			}
		rb->hidden = 1;
		return Diagnostic("HideRadioButton", EXIT, TRUE);
		}
	return Diagnostic("HideRadioButton", EXIT, FALSE);
	}

void DestroyRadioButton(RadioButton *rb, BOOL refresh)
	{
	if (rb && rb->MList) // Radio buttons MUST have a mutex list even if the only member is itself.
		{
		Frame *Child; // Could be any type of control

		if (rb->hidden == 0) // If not hidden
			{
			if (refresh)
				HideRadioButton(rb);
			else
				RemoveGadget((struct Window *) rb->RBGad.UserData, &(rb->RBGad));
			}

		if (rb == Gui.FirstRadioButton)
			Gui.FirstRadioButton = rb->Next;
		else
			{
			RadioButton *prev = Gui.FirstRadioButton;
			while (prev->Next != rb)
				prev = prev->Next;
			prev->Next = rb->Next;
			}

		// Sort out the mutex list (remember other radio buttons may still be using it).
		if (rb->MList->Mutex == rb)
			{
			/*	The first item in the mutex list is ourself so we have to find every radio button using
				this mutex list and reset their mutex pointers to point to the next item. */
			RadioButton *b = Gui.FirstRadioButton;
			while (b)
				{
				if (b->MList == rb->MList)
					b->MList = b->MList->Next;
				b = b->Next;
				}

			/* This radio button has already been removed from the Gui list and so hasn't been affected by
				the loop above so our MList still points to the one we want to free.  It's now safe to free
				it. */
			GuiFree(rb->MList);
			}
		else
			{
			/* Remove this radio button's item from the MList.  Since our item isn't the first in the
				MList, this will also remove it from the MList for all other radio buttons in the list. */
			struct MutexList *ml = rb->MList, *pml = NULL;

			while (ml->Mutex != rb)
				{
				pml = ml;
				ml = ml->Next;
				}
			/*	The if statement below should never fail.  Our own mutex should always be in the list and
				cannot be first because we checked for this above. */
			if (ml && pml)
				{
				pml->Next = ml->Next;
				GuiFree(ml);
				}
			}

		if (rb->WidgetData->os)
			GuiFree(rb->WidgetData->os);
		Child = rb->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
		GuiFree(rb->WidgetData);
		GuiFree(rb);
		}
	}

void DrawRBCentre(RadioButton *rb)
	{
	if (rb->RBGad.Flags & GFLG_SELECTED)
		{
		char APenCol = ((struct Window *) rb->RBGad.UserData)->RPort->FgPen;
		register int i, j, x1, x2, y, l;

		SetAPen(((struct Window *) rb->RBGad.UserData)->RPort, rb->BLight.BackPen);
		for (l = 0; l < rb->RBGad.Height - 4; l++)
			{
			i = 4 * l;
			if (rb->RBGad.Width > 5 && (l == 0 || l == rb->RBGad.Height - 5))
				j = 1;
			else
				j = 0;
			x1 = 2 + j;
			x2 = rb->RBGad.Width - 3 - j;
			y = l + 2;
			if (l == 0)
				Move(((struct Window *) rb->RBGad.UserData)->RPort, rb->RBGad.LeftEdge + x1, rb->RBGad.TopEdge + y);
			else
				Draw(((struct Window *) rb->RBGad.UserData)->RPort, rb->RBGad.LeftEdge + x1, rb->RBGad.TopEdge + y);
			Draw(((struct Window *) rb->RBGad.UserData)->RPort, rb->RBGad.LeftEdge + x2, rb->RBGad.TopEdge + y);
			}
		SetAPen(((struct Window *) rb->RBGad.UserData)->RPort, APenCol);
		}
	}

void ResizeRadioButton(RadioButton *rb, int x, int y, int width, int height, BOOL eraseold)
	{
	/*	If the radio button is in a coloured frame then no need to blank it because the parent frame will
		blank it's entire contents. */
	if (eraseold && GetBackCol(rb->WidgetData->Parent) == RBWIN(rb)->RPort->BgPen)
		AreaBlank(((struct Window *) rb->RBGad.UserData)->RPort, rb->RBGad.LeftEdge,
				rb->RBGad.TopEdge, rb->RBGad.Width, rb->RBGad.Height);

	rb->BevelPoints[0] = rb->BevelPoints[12] = width - 3;
	rb->BevelPoints[7] = rb->BevelPoints[15] = height - 3;
	rb->BevelPoints[9] = height - 2;
	rb->BevelPoints[11] = rb->BevelPoints[13] = height - 1;
	rb->BevelPoints[14] = rb->BevelPoints[16] = width - 1;
	rb->BevelPoints[18] = width - 2;

	rb->RBGad.LeftEdge = x;
	rb->RBGad.TopEdge  = y;
	rb->RBGad.Width    = width;
	rb->RBGad.Height   = height;

	rb->WidgetData->left = x;
	rb->WidgetData->top = y;
	rb->WidgetData->width = width;
	rb->WidgetData->height = height;
	}

RadioButton* FOXLIB MakeRadioButton(REGA0 void *Parent, REGA1 RadioButton *MutEx, REGD0 int left, REGD1 int top, REGD2 int width,
		REGD3 int height, REGD4 int fillcol, REGA2 int (* __far __stdargs callfn) (RadioButton*), REGD5 int flags, REGA3 void *extension)
	{
	RadioButton *rb;
	struct MutexList *mlist;
	GuiWindow *Wptr;
	Frame *ParentFrame = NULL;

	Diagnostic("MakeRadioButton", ENTER, TRUE);
	if ((MutEx && !MutEx->MList) || width < 5 || height < 5 || !Parent)
		{
		Diagnostic("MakeRadioButton", EXIT, FALSE);
		return NULL;
		}
	if (!(rb = (RadioButton *) GuiMalloc(sizeof(RadioButton), 0)))
		{
		Diagnostic("MakeRadioButton", EXIT, FALSE);
		return NULL;
		}
	if (!(rb->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)))
		{
		GuiFree(rb);
		Diagnostic("MakeRadioButton", EXIT, FALSE);
		return NULL;
		}
	rb->WidgetData->ObjectType = RadioButtonObject;
	rb->WidgetData->Parent = Parent;
	rb->WidgetData->NextWidget = NULL;
	rb->WidgetData->ChildWidget = NULL;

	if (!ISGUIWINDOW(Parent))
		{
		ParentFrame = (Frame *) Parent;
		left += ParentFrame->button.LeftEdge;
		top += ParentFrame->button.TopEdge;
		Wptr = (GuiWindow *) ParentFrame->button.UserData;
		}
	else
		Wptr = (GuiWindow *) Parent;
	if (ParentFrame && ParentFrame->hidden != 0)
		rb->hidden = -1;
	else
		rb->hidden = 0;

	if (!(mlist = (struct MutexList *) GuiMalloc(sizeof(struct MutexList), 0)))
		{
		GuiFree(rb->WidgetData);
		GuiFree(rb);
		Diagnostic("MakeRadioButton", EXIT, FALSE);
		return NULL;
		}
	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	if (flags & S_AUTO_SIZE)
		{
		if (!(rb->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
			GuiFree(mlist);
			GuiFree(rb->WidgetData);
			GuiFree(rb);
			Diagnostic("MakeRadioButton", EXIT, FALSE);
			return NULL;
			}
		rb->WidgetData->os->left = left;
		rb->WidgetData->os->top = top;
		rb->WidgetData->os->width = width;
		rb->WidgetData->os->height = height;
		}
	else
		rb->WidgetData->os = NULL;
	rb->WidgetData->flags = flags;
	rb->RBGad.GadgetText = NULL;

	rb->Active = TRUE;
	rb->Callfn = callfn;

	// Make the bevel.  Because it's octagonal we can't use the makebevel fn.
	rb->BevelPoints[1] = rb->BevelPoints[3] = rb->BevelPoints[4] = rb->BevelPoints[6] = 0;
	rb->BevelPoints[2] = rb->BevelPoints[10] = 2;
	rb->BevelPoints[5] = rb->BevelPoints[17] = 2;
	rb->BevelPoints[8] = rb->BevelPoints[19] = 1;
	rb->BLight.TopEdge = rb->BLight.LeftEdge = rb->BDark.TopEdge = rb->BDark.LeftEdge = 0;
	rb->BLight.DrawMode = rb->BDark.DrawMode = JAM1;
	rb->BLight.Count = rb->BDark.Count = 5;
	rb->BLight.FrontPen = Gui.HiPen;
	rb->BLight.BackPen = fillcol; // Ignored by Intuition - just used for storage.
	rb->BLight.NextBorder = &(rb->BDark);
	rb->BLight.XY = rb->BevelPoints;
	rb->BDark.FrontPen = Gui.LoPen;
	rb->BDark.NextBorder = NULL;
	rb->BDark.XY = &(rb->BevelPoints[10]);

	memcpy(&(rb->sBLight), &(rb->BLight), sizeof(struct Border));
	memcpy(&(rb->sBDark), &(rb->BDark), sizeof(struct Border));
	rb->sBLight.FrontPen = Gui.LoPen;
	rb->sBLight.NextBorder = &(rb->sBDark);
	rb->sBDark.FrontPen = Gui.HiPen;
	rb->sBDark.NextBorder = NULL;

   rb->RBGad.NextGadget   = NULL;
   rb->RBGad.GadgetType   = GTYP_BOOLGADGET;
   rb->RBGad.Activation   = GACT_IMMEDIATE;
   rb->RBGad.Flags        = GFLG_GADGHIMAGE | (flags & BG_SELECTED ? GFLG_SELECTED : 0);
   rb->RBGad.GadgetRender = (APTR) &(rb->BLight);
   rb->RBGad.SelectRender = (APTR) &(rb->sBLight);
   rb->RBGad.GadgetID     = 0;
   rb->RBGad.UserData     = (APTR) Wptr->Win;

	mlist->Next = NULL;
	mlist->Mutex = rb;
	if (MutEx)
		{
		struct MutexList *ml = rb->MList = MutEx->MList;

		while (ml->Next)
			ml = ml->Next;
		ml->Next = mlist;
		}
	else
		rb->MList = mlist;

	ResizeRadioButton(rb, left, top, width, height, FALSE);
	DrawRBCentre(rb);

	rb->Next = Gui.FirstRadioButton;
	Gui.FirstRadioButton = rb;

	if (rb->hidden == 0)
		{
	   AddGadget(Wptr->Win, &(rb->RBGad), -1);
   	RefreshGadgets(&(rb->RBGad), Wptr->Win, NULL);
		}

	Diagnostic("MakeRadioButton", EXIT, TRUE);
	return rb;
	}

void ResizeTickBox(TickBox *tb, int x, int y, int width, int height, BOOL eraseold)
	{
	/*	If the tick box is in a coloured frame then no need to blank it because the parent frame will
		blank it's entire contents. */
	if (eraseold && GetBackCol(tb->WidgetData->Parent) == TBWIN(tb)->RPort->BgPen)
		AreaBlank(((struct Window *) tb->TickBoxGad.UserData)->RPort, tb->TickBoxGad.LeftEdge,
				tb->TickBoxGad.TopEdge, tb->TickBoxGad.Width, tb->TickBoxGad.Height);

	MakeBevel(&tb->BLight, &tb->BDark, tb->BevelPoints, 0, 0, width, height, TRUE);

	tb->TickPoints[0] = (width > 10 ? 3 : 2);
	tb->TickPoints[11] = tb->TickPoints[1] = ((height - 2) / 2) + 2;
	tb->TickPoints[8] = tb->TickPoints[2] = (width / 2) - 1;
	tb->TickPoints[3] = height - (height > 8 ? 3 : 2);
	tb->TickPoints[4] = width - (width > 10 ? 4 : 3);
	tb->TickPoints[7] = tb->TickPoints[5] = (height > 8 ? 2 : 1);
	tb->TickPoints[6] = tb->TickPoints[4] - 1;
	tb->TickPoints[9] = tb->TickPoints[3] - 1;
	tb->TickPoints[10] = tb->TickPoints[0] + 1;

   tb->TickBoxGad.LeftEdge = x;
   tb->TickBoxGad.TopEdge  = y;
   tb->TickBoxGad.Width    = width;
   tb->TickBoxGad.Height   = height;

	tb->WidgetData->left = x;
	tb->WidgetData->top = y;
	tb->WidgetData->width = width;
	tb->WidgetData->height = height;
	}

TickBox* FOXLIB MakeTickBox(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGA1 int (* __far __stdargs callfn) (TickBox*), REGD4 int flags, REGA2 void *extension)
	{
	TickBox *tb;
	GuiWindow *Wptr;
	Frame *ParentFrame = NULL;

	Diagnostic("MakeTickBox", ENTER, TRUE);
	if (!Parent)
		{
		Diagnostic("MakeTickBox", EXIT, FALSE);
		return NULL;
		}
	if (!(tb = (TickBox *) GuiMalloc(sizeof(TickBox), 0)))
		{
		Diagnostic("MakeTickBox", EXIT, FALSE);
		return NULL;
		}
	if (!(tb->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)))
		{
		GuiFree(tb);
		Diagnostic("MakeTickBox", EXIT, FALSE);
		return NULL;
		}
	tb->WidgetData->ObjectType = TickBoxObject;
	tb->WidgetData->Parent = Parent;
	tb->WidgetData->NextWidget = NULL;
	tb->WidgetData->ChildWidget = NULL;

	if (!ISGUIWINDOW(Parent))
		{
		ParentFrame = (Frame *) Parent;
		left += ParentFrame->button.LeftEdge;
		top += ParentFrame->button.TopEdge;
		Wptr = (GuiWindow *) ParentFrame->button.UserData;
		}
	else
		Wptr = (GuiWindow *) Parent;
	if (ParentFrame && ParentFrame->hidden != 0)
		tb->hidden = -1;
	else
		tb->hidden = 0;

	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	if (flags & S_AUTO_SIZE)
		{
		if (!(tb->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
			GuiFree(tb->WidgetData);
			GuiFree(tb);
			Diagnostic("MakeTickBox", EXIT, FALSE);
			return NULL;
			}
		tb->WidgetData->os->left = left;
		tb->WidgetData->os->top = top;
		tb->WidgetData->os->width = width;
		tb->WidgetData->os->height = height;
		}
	else
		tb->WidgetData->os = NULL;
	tb->TickBoxGad.GadgetText = NULL;

	tb->WidgetData->flags = flags;
	tb->Active = TRUE;
	tb->Callfn = callfn;
	tb->BLight.TopEdge = tb->BLight.LeftEdge = tb->BDark.TopEdge = tb->BDark.LeftEdge = 0;


	/* The unselected version of the tick is just the same as the tick but in the fill pen colour so
		that drawing the unselected version will remove the tick from the previously drawn selected
		version.

		unselected : nstick -> light -> dark.
		selected   : stick  -> light -> dark.

		This way we can re-use the light and dark borders and the only one that has to be duplicated is
		the tick. */

   tb->sTick.LeftEdge    = tb->sTick.TopEdge = 0;
   tb->sTick.Count       = 6;
   tb->sTick.XY          = tb->TickPoints;
   tb->sTick.NextBorder  = &tb->BLight;
	tb->sTick.FrontPen    = Gui.TextCol;
   tb->sTick.DrawMode    = JAM1;
	memcpy(&tb->nsTick, &tb->sTick, sizeof(struct Border));
	tb->nsTick.FrontPen = (flags & BG_CLEAR ? GetBackCol(Parent) : Gui.BackCol);

	/*	We're going to create the gadget in such a way that Intuition doesn't do anything to it when it
		is clicked on - i.e. the imagery doesn't change, the state of flags doesn't change etc.  This
		is so that we can cancel the user's action - i.e.  if an edit box is active and invalid and the
		user clicks on the tick box it would be easy to prevent the callback function from being called
		but if we made the gadget in the normal way, Intuition would still tick it or untick it for us. */
   tb->TickBoxGad.NextGadget   = NULL;
   tb->TickBoxGad.GadgetType   = GTYP_BOOLGADGET;
   tb->TickBoxGad.Activation   = GACT_RELVERIFY;
   tb->TickBoxGad.Flags        = GFLG_GADGHIMAGE;
	tb->TickBoxGad.GadgetRender = (APTR) (flags & BG_SELECTED ? &tb->sTick : &tb->nsTick);
	tb->TickBoxGad.SelectRender = NULL;
   tb->TickBoxGad.GadgetID     = 0;
   tb->TickBoxGad.UserData     = (APTR) Wptr->Win;

	tb->Ticked = flags & BG_SELECTED ? TRUE : FALSE;

	ResizeTickBox(tb, left, top, width, height, FALSE);

	tb->Next = Gui.FirstTickBox;
	Gui.FirstTickBox = tb;

	if (tb->hidden == 0)
		{
		AddGadget(Wptr->Win, &tb->TickBoxGad, -1);
		if (!(flags & BG_CLEAR))
			AreaColFill(Wptr->Win->RPort, left, top, width, height, Gui.BackCol);
		RefreshGadgets(&tb->TickBoxGad, Wptr->Win, NULL);
		}
	Diagnostic("MakeTickBox", EXIT, TRUE);
	return tb;
	}

void DestroyAllRadioButtons(BOOL refresh)
	{
	Diagnostic("DestroyAllRadioButtons", ENTER, TRUE);
	while (Gui.FirstRadioButton)
		DestroyRadioButton(Gui.FirstRadioButton, refresh);
	Diagnostic("DestroyAllRadioButtons", EXIT, TRUE);
	}

void DestroyAllTickBoxes(BOOL refresh)
	{
	Diagnostic("DestroyAllTickBoxes", ENTER, TRUE);
	while (Gui.FirstTickBox)
		DestroyTickBox(Gui.FirstTickBox, refresh);
	Diagnostic("DestroyAllTickBoxes", EXIT, TRUE);
	}

void DestroyWinRadioButtons(GuiWindow *gw, BOOL refresh)
	{
	BOOL message = FALSE;
	RadioButton *rb = Gui.FirstRadioButton, *nrb = NULL;
	Diagnostic("DestroyWinRadioButtons", ENTER, TRUE);
	if (!gw)
		{
		Diagnostic("DestroyWinRadioButtons", EXIT, FALSE);
		return;
		}
	while (rb)
		{
		nrb = rb->Next;
		if ((struct Window *) rb->RBGad.UserData == gw->Win)
			{
			DestroyRadioButton(rb, refresh);
			message = TRUE;
			}
		rb = nrb;
		}
	if (Gui.CleanupFlag && message)
		SetLastErr("Window closed before all of its radio buttons were destroyed.");
	Diagnostic("DestroyWinRadioButtons", EXIT, TRUE);
	}

void DestroyWinTickBoxes(GuiWindow *gw, BOOL refresh)
	{
	BOOL message = FALSE;
	TickBox *tb = Gui.FirstTickBox, *ntb = NULL;
	Diagnostic("DestroyWinTickBoxes", ENTER, TRUE);
	if (!gw)
		{
		Diagnostic("DestroyWinTickBoxes", EXIT, FALSE);
		return;
		}
	while (tb)
		{
		ntb = tb->Next;
		if ((struct Window *) tb->TickBoxGad.UserData == gw->Win)
			{
			DestroyTickBox(tb, refresh);
			message = TRUE;
			}
		tb = ntb;
		}
	if (Gui.CleanupFlag && message)
		SetLastErr("Window closed before all of its tick boxes were destroyed.");
	Diagnostic("DestroyWinTickBoxes", EXIT, TRUE);
	}
