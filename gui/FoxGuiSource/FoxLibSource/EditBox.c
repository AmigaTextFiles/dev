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

#ifdef __STORM__
	#define AMIGA
#endif

#include <proto/mathieeedoubbas.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <intuition/sghooks.h>
//include <utility/hooks.h>
#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

#define GUIWIN(p) ((GuiWindow*)p->editbox.UserData)

static short Newoutside[] = { 1, 8,  1, 1, 15, 1, 15, 8, 1, 8 };
static short Newarrow[]   = { 5, 3, 11, 3,  8, 6,  5, 3 };

static short Newoutside3D[] = { 1, 9,  1, 0, 16, 0, 16, 9, 1, 9 };
static short Newarrow3D[]   = { 6, 3, 12, 3,  9, 6,  6, 3 };

static BOOL EditStatusStored = FALSE;
static BOOL ListStatusStored = FALSE;

void FOXLIB RefreshEditBox(REGA0 EditBox *p)
	{
	Diagnostic("RefreshEditBox", ENTER, TRUE);
	if (!p)
		{
		Diagnostic("RefreshEditBox", EXIT, FALSE);
		return;
		}
	if (p->hidden == 0)
		RefreshGList(&p->editbox, GUIWIN(p)->Win, NULL, 1);
	Diagnostic("RefreshEditBox", EXIT, TRUE);
	}

BOOL FOXLIB SetEditBoxCols(REGA0 EditBox *p, REGD0 int BorderCol, REGD1 int Bcol, REGD2 int Tcol)
   {
	int GadPos;
   Diagnostic("SetEditBoxCols", ENTER, TRUE);
   if (!p)
      return Diagnostic("SetEditBoxCols", EXIT, FALSE);
	if (p->hidden == 0)
		GadPos = RemoveGList(GUIWIN(p)->Win, &p->editbox, 1);
   p->Bcol = Bcol;
	if (!(p->WidgetData->flags & THREED))
		p->lborder.FrontPen = BorderCol;
   p->Tcol = Tcol;

	if (p->strinfo.Extension)
		{
		p->strinfo.Extension->Pens[0] = Tcol;
		p->strinfo.Extension->ActivePens[0] = Tcol;
		if (!(p->WidgetData->flags & EB_CLEAR))
			{
			p->strinfo.Extension->Pens[1] = Bcol;
			p->strinfo.Extension->ActivePens[1] = Bcol;
			}
		}

	if (p->hidden == 0)
		{
		AddGList(GUIWIN(p)->Win, &p->editbox, GadPos, 1, NULL);
		RefreshEditBox(p);
		}
   return Diagnostic("SetEditBoxCols", EXIT, TRUE);
   }

char* FOXLIB GetEditBoxText(REGA0 EditBox *p)
   {
   Diagnostic("GetEditBoxText", ENTER, TRUE);
   if (!p)
      {
      Diagnostic("GetEditBoxText", EXIT, FALSE);
      return NULL;
      }
   Diagnostic("GetEditBoxText", EXIT, TRUE);
   return p->buffer;
   }

int FOXLIB GetEditBoxInt(REGA0 EditBox *p)
   {
   Diagnostic("GetEditBoxInt", ENTER, TRUE);
   if (!p)
      {
      Diagnostic("GetEditBoxInt", EXIT, FALSE);
      return 0;
      }
   Diagnostic("GetEditBoxInt", EXIT, TRUE);
   return atoi(p->buffer);
   }

BOOL FOXLIB SetEditBoxText(REGA0 EditBox *p, REGA1 char *text)
	{
	int GadPos = -1;
   Diagnostic("SetEditBoxText", ENTER, TRUE);
   if (!p)
      return Diagnostic("SetEditBoxText", EXIT, FALSE);
	if (p->hidden == 0 && !(Gui.LibVersion < A3000 && p->list))
		GadPos = RemoveGList(GUIWIN(p)->Win, &p->editbox, 1);
   if (strlen(text) > p->len)
		{
      strncpy(p->buffer, text, p->len);
		p->buffer[p->len] = '\0';
		}
   else
      strcpy(p->buffer, text);
	// Set the initial cursor position for the editbox to the character
	// beyond the end of the string or to the first character if this is a
	// list box.
	((struct StringInfo *)(p->editbox.SpecialInfo))->BufferPos = (p->list == NULL ? strlen(p->buffer) : 0);
	if (p->hidden == 0)
		{
		AddGList(GUIWIN(p)->Win, &p->editbox, GadPos, 1, NULL);
		RefreshGList(&p->editbox, GUIWIN(p)->Win, NULL, 1);
		if (Gui.LibVersion < A3000 && p->list)
			GadPos = RemoveGList(GUIWIN(p)->Win, &(p->editbox), 1);
		}
	return Diagnostic("SetEditBoxText", EXIT, TRUE);
	}

BOOL FOXLIB SetEditBoxInt(REGA0 EditBox *p, REGD0 int num)
   {
   BOOL retval;
   char str[12];
   Diagnostic("SetEditBoxInt", ENTER, TRUE);
   sprintf(str, "%d", num);
   retval = SetEditBoxText(p, str);
   return Diagnostic("SetEditBoxInt", EXIT, retval);
   }

BOOL FOXLIB SetEditBoxDP(REGA0 EditBox *p, REGD0 int num)
   {
   Diagnostic("SetEditBoxDP", ENTER, TRUE);
   if (!p)
      return Diagnostic("SetEditBoxDP", EXIT, FALSE);
   p->dp = num;
   return Diagnostic("SetEditBoxDP", EXIT, TRUE);
   }

void FOXLIB SortDDListBox(REGA0 DDListBox *p, REGD0 int flags)
   {
   struct ListElement *smallest, *start, *ptr, *smallestprev, *startprev, *ptrprev;
   Diagnostic("SortDDListBox", ENTER, TRUE);
   if ((!p) || !p->list)
      {
      Diagnostic("SortDDListBox", EXIT, FALSE);
      return;
      }
   start = p->list->first;
   startprev = NULL;
   while (start)
      {
      smallest = start;
      smallestprev = startprev;
      ptr = start->Next;
      ptrprev = start;
      while (ptr)
         {
			if (flags & NUM_ASCENDING || flags & NUM_DESCENDING)
				{
				if (atoi(flags & NUM_ASCENDING ? ptr->string : smallest->string)
					< atoi(flags & NUM_ASCENDING ? smallest->string : ptr->string))
					{
         	   smallest = ptr;
            	smallestprev = ptrprev;
					}
				}
			else if (flags & IGNORE_CASE)
				{
				if (stricmp(flags & ASCENDING ? ptr->string : smallest->string, flags & ASCENDING ?
						smallest->string : ptr->string) < 0)
   	  	      {
      	  	   smallest = ptr;
         	  	smallestprev = ptrprev;
            	}
				}
			else if (strcmp(flags & ASCENDING ? ptr->string : smallest->string, flags & ASCENDING ?
					smallest->string : ptr->string) < 0)
     	      {
        	   smallest = ptr;
           	smallestprev = ptrprev;
            }
         ptrprev = ptr;
         ptr = ptr->Next;
         }
      if (smallest != start)
         {
         if (smallestprev)
            smallestprev->Next = smallest->Next;
         else
            p->list->first = smallest->Next;
         if (startprev)
            startprev->Next = smallest;
         else
            p->list->first = smallest;
         smallest->Next = start;
         }
      else
         start = start->Next;
      if (start == p->list->first)
         startprev = NULL;
      else
         for (startprev = p->list->first; startprev->Next != start;)
            startprev = startprev->Next;
      }
   for (flags = 1, ptr = p->list->first; ptr != NULL; ptr = ptr->Next, flags++)
      ptr->Itemnum = flags;
   Diagnostic("SortDDListBox", EXIT, TRUE);
   }

void DisableAllDDListBoxes(BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("DisableAllDDListBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      DisableDDListBox(p, redraw);
      p = p->next;
      }
   Diagnostic("DisableAllDDListBoxes", EXIT, TRUE);
   }

void DisableWinDDListBoxes(GuiWindow *c, BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("DisableWinDDListBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      if (GUIWIN(p) == c)
         DisableDDListBox(p, redraw);
      p = p->next;
      }
   Diagnostic("DisableWinDDListBoxes", EXIT, TRUE);
   }

void DisableEditBox(EditBox *p, BOOL redraw)
	{
	if (p && p->enabled && !(p->list))
		{
		if (p->hidden == 0)
			DisableGadget(&p->editbox, GUIWIN(p)->Win, redraw);
		else
			p->editbox.Flags |= GFLG_DISABLED;
		p->enabled = FALSE;
		}
	}

void DisableDDListBox(DDListBox *p, BOOL redraw)
	{
	if (p && p->enabled && p->list)
		{
		if (Gui.LibVersion >= A3000)
			{
			if (p->hidden == 0)
				DisableGadget(&p->editbox, GUIWIN(p)->Win, redraw);
			else
				p->editbox.Flags |= GFLG_DISABLED;
			}
		else
			{
			// For an A500 the gadget isn't in the list so we need to do everything in a different order
			struct Gadget *gad = &(p->editbox);
			struct Window *win = GUIWIN(p)->Win;
			gad->Flags |= GFLG_DISABLED;
			if (redraw && p->hidden == 0)
				{
				AddGadget(win, gad, 0);
				RefreshGList(gad, win, NULL, 1L);
				RemoveGadget(win, gad);
				}
			}
		p->enabled = FALSE;
		}
	}

void DisableAllEditBoxes(BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("DisableAllEditBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      DisableEditBox(p, redraw);
      p = p->next;
      }
   Diagnostic("DisableAllEditBoxes", EXIT, TRUE);
   }

void DisableWinEditBoxes(GuiWindow *c, BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("DisableWinEditBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      if (GUIWIN(p) == c)
         DisableEditBox(p, redraw);
      p = p->next;
      }
   Diagnostic("DisableWinEditBoxes", EXIT, TRUE);
   }

void EnableEditBox(EditBox *p, BOOL redraw)
	{
	if (p && p->enabled == FALSE && !(p->list))
		{
		if (p->hidden == 0)
			EnableGadget(&p->editbox, GUIWIN(p)->Win, redraw);
		else
			p->editbox.Flags ^= GFLG_DISABLED;
		p->enabled = TRUE;
		}
	}

void EnableDDListBox(DDListBox *p, BOOL redraw)
	{
	if (p && p->enabled == FALSE && p->list)
		{
		if (Gui.LibVersion >= A3000)
			{
			if (p->hidden == 0)
				EnableGadget(&p->editbox, GUIWIN(p)->Win, redraw);
			else
				p->editbox.Flags ^= GFLG_DISABLED;
			}
		else
			{
			// For an A500 the gadget isn't in the list so we need to do everything in a different order
			struct Gadget *gad = &(p->editbox);
			struct Window *win = GUIWIN(p)->Win;
			gad->Flags ^= GFLG_DISABLED;
			if (redraw && p->hidden == 0)
				{
				AddGadget(win, gad, 0);
				RefreshGList(gad, win, NULL, 1L);
				RemoveGadget(win, gad);
				}
			}
		p->enabled = TRUE;
		}
	}

void EnableAllEditBoxes(BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("EnableAllEditBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      EnableEditBox(p, redraw);
      p = p->next;
      }
   Diagnostic("EnableAllEditBoxes", EXIT, TRUE);
   }

void EnableWinEditBoxes(GuiWindow *c, BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("EnableWinEditBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      if (GUIWIN(p) == c)
         EnableEditBox(p, redraw);
      p = p->next;
      }
   Diagnostic("EnableWinEditBoxes", EXIT, TRUE);
   }

void EnableAllDDListBoxes(BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("EnableAllDDListBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      EnableDDListBox(p, redraw);
      p = p->next;
      }
   Diagnostic("EnableAllDDListBoxes", EXIT, TRUE);
   }

void EnableWinDDListBoxes(GuiWindow *c, BOOL redraw)
   {
   struct EditBoxStruct *p;
   Diagnostic("EnableWinDDListBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      if (GUIWIN(p) == c)
         EnableDDListBox(p, redraw);
      p = p->next;
      }
   Diagnostic("EnableWinDDListBoxes", EXIT, TRUE);
   }

static BOOL FindPreviousNext(EditBox *p, BOOL *prefound, BOOL *nextfound, UWORD *prepos, UWORD *nextpos)
	{
	struct Window *w = GUIWIN(p)->Win;
	struct Gadget *g = w->FirstGadget;
	UWORD pos = 0;
	BOOL found = FALSE;

	*prefound = *nextfound = FALSE;
	*prepos = *nextpos = 0;
	while (g && !found)
		{
		if (g == &p->editbox)
			found = TRUE;
		else if (p->next && g == &p->next->editbox)
			{
			*nextfound = TRUE;
			*nextpos = pos;
			}
		else if (p->previous && g == &p->previous->editbox)
			{
			*prefound = TRUE;
			*prepos = pos;
			}
		g = g->NextGadget;
		pos++;
		}
	return found;
	}

BOOL ShowEditBox(EditBox *p)
	{
	Diagnostic("ShowEditBox", ENTER, TRUE);
	if (p && !p->list)
		{
		// First check whether the gadget is hidden.  At the same time, we'll look for the previous and
		// next edit boxes in our list so that we can add it back in the same position it was removed from
		// to preserve the tab order.
		struct Window *w = GUIWIN(p)->Win;
		BOOL prefound, nextfound;
		UWORD pos, prepos, nextpos;

		if (p->hidden == 1) // The editbox is really hidden
			if ((!ISGUIWINDOW(p->WidgetData->Parent)) && ((Frame *) p->WidgetData->Parent)->hidden != 0)
				p->hidden = -1; // The editbox is in a hidden frame so it will remain hidden
			else
				{
				FindPreviousNext(p, &prefound, &nextfound, &prepos, &nextpos);
				// We need to add the gadget
				if (nextfound)
					pos = nextpos + 1;
				else if (prefound)
					pos = prepos;
				else
					pos = (unsigned short) ~0; // Add to the end of the list because we couldn't find the right place.
				AddGadget(w, &p->editbox, pos);
				p->hidden = 0;
				}
		if (p->hidden == 0)
			// refresh the gadget
			RefreshGList(&p->editbox, w, NULL, 1);
		return Diagnostic("ShowEditBox", EXIT, TRUE);
		}
	return Diagnostic("ShowEditBox", EXIT, FALSE);
	}

BOOL HideEditBox(EditBox *p)
	{
	Diagnostic("HideEditBox", ENTER, TRUE);
	if (p && !p->list)
		{
		if (p->hidden == 0)
			{
			int fontheight;
			struct TextAttr *font = GUIWIN(p)->ParentScreen->Font;

			RemoveGadget(GUIWIN(p)->Win, &(p->editbox));
			if (font)
				fontheight = font->ta_YSize;
			else
				fontheight = GuiFont.ta_YSize;
			AreaColFill(GUIWIN(p)->Win->RPort, p->WidgetData->left, p->WidgetData->top, p->WidgetData->width, fontheight + 2,
					GetBackCol(p->WidgetData->Parent));
			}
		p->hidden = 1;
		return Diagnostic("HideEditBox", EXIT, TRUE);
		}
	return Diagnostic("HideEditBox", EXIT, FALSE);
	}

void DestroyEditBox(EditBox *p, BOOL refresh)
   {
   Diagnostic("DestroyEditBox", ENTER, TRUE);
   if (p && !(p->list))
      {
		Frame *Child; // Could be any type of control
		struct EditBoxStruct *n = p->next;

		if (p == Gui.FirstEditBox)
			Gui.FirstEditBox = n;
		if (n)
			n->previous = p->previous;
		if (p->previous)
			p->previous->next = n;

		if (p->hidden == 0)
			{
			if (refresh)
				HideEditBox(p);
			else
				RemoveGadget(GUIWIN(p)->Win, &(p->editbox));
			}
		if (p->strinfo.Extension)
			{
			if (p->strinfo.Extension->EditHook)
				{
				GuiFree(p->strinfo.Extension->EditHook);
		      GuiFree(p->strinfo.Extension->WorkBuffer);
				}
			GuiFree(p->strinfo.Extension);
			}
      if (p->buffer)
         GuiFree(p->buffer);
      if (p->undobuffer)
         GuiFree(p->undobuffer);

		if (p->WidgetData->os)
			GuiFree(p->WidgetData->os);
		Child = p->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
      GuiFree(p->WidgetData);
      GuiFree(p);
      }
   Diagnostic("DestroyEditBox", EXIT, TRUE);
   }

void DestroyAllEditBoxes(BOOL refresh)
   {
   struct EditBoxStruct *p;
   Diagnostic("DestroyAllEditBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
		if (!p->list)
			{
	      DestroyEditBox((EditBox *) p, refresh);
			p = Gui.FirstEditBox;
			}
		else
	      p = p->next;
      }
   Diagnostic("DestroyAllEditBoxes", EXIT, TRUE);
   }

void DestroyWinEditBoxes(GuiWindow *c, BOOL refresh)
   {
	BOOL message = FALSE;
   struct EditBoxStruct *p;
   Diagnostic("DestroyWinEditBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      if (GUIWIN(p) == c && (!p->list))
			{
         DestroyEditBox((EditBox *) p, refresh);
			message = TRUE;
			p = Gui.FirstEditBox;
			}
		else
			p = p->next;
      }
	if (Gui.CleanupFlag && message)
		SetLastErr("Window closed before all of its edit boxes were destroyed.");
   Diagnostic("DestroyWinEditBoxes", EXIT, TRUE);
   }

ULONG hook_EditFloat(struct Hook *hook, struct SGWork *sgw, ULONG *msg)
	{
	if (*msg == SGH_KEY)
		{
		if (sgw->EditOp == EO_REPLACECHAR || sgw->EditOp == EO_INSERTCHAR)
			{
			int ok = FALSE, l;
			if (sgw->Code >= '0' && sgw->Code <= '9')
				ok = TRUE;
			else
				switch (sgw->Code)
					{
					case '+':
					case '-':
						if (sgw->BufferPos == 1)
							ok = TRUE;
						break;
					case '.':
						ok = TRUE;
						for (l = 0; l < sgw->NumChars; l++)
							if (sgw->WorkBuffer[l] == '.' && l != sgw->BufferPos - 1)
								ok = FALSE;
					default:
						break;
					};
			if (!ok)
				{
				sgw->Actions |= SGA_BEEP;
				sgw->Actions &= ~SGA_USE;
				}
			}
		return ~0L;
		}
	else
		return 0;
	}

ULONG hook_ListBox(struct Hook *hook, struct SGWork *sgw, ULONG *msg)
	{
	if (*msg == SGH_KEY)
		{
		if (sgw->EditOp == EO_REPLACECHAR || sgw->EditOp == EO_INSERTCHAR)
			ListBoxKeyPress = sgw->Code;
		sgw->Actions &= ~SGA_USE;
		return ~0L;
		}
	else
		return 0;
	}

/*	Don't ask me what this does - it's to save having to write a bit of
	machine code to do the same thing (whatever that is!).  For a brief
	description see p.165 of RKRM: Libraries.
	Note also that this bit of code creates a warning 154 which I have only
	managed to get rid of by adding a -j154 option to the compile string for
	this file in the Makefile. */

#ifdef AMIGA
unsigned long __saveds __asm hookEntry(register __a0 struct Hook *hookptr, register __a2 void *object, register __a1 void *message)
	{
	return ((*hookptr->h_SubEntry) (hookptr, object, message));
	}
#endif

static void resizeeditbox(EditBox *eb, int x, int y, int len, BOOL eraseold, BOOL ForList, BOOL ForSubList)
	{
	unsigned short fontheight;

	if (GUIWIN(eb)->ParentScreen->Font)
		fontheight = GUIWIN(eb)->ParentScreen->Font->ta_YSize;
	else
		fontheight = GuiFont.ta_YSize;

	/*	If the edit box is in a coloured frame then no need to blank it because the parent frame will
		blank it's entire contents. */
	if (eraseold && GetBackCol(eb->WidgetData->Parent) == GUIWIN(eb)->Win->RPort->BgPen)
		{
		AreaBlank(GUIWIN(eb)->Win->RPort, eb->WidgetData->left, eb->WidgetData->top, eb->WidgetData->width +
				((ForList && !ForSubList) ? DD_LIST_BOX_BUTTON_WIDTH : 0), fontheight + 2);
		if (eb->editbox.GadgetText)
			{
			int penhold;

			penhold = eb->editbox.GadgetText->FrontPen;
			eb->editbox.GadgetText->FrontPen = GUIWIN(eb)->Win->RPort->BgPen;
			PrintIText(GUIWIN(eb)->Win->RPort, eb->editbox.GadgetText, eb->editbox.LeftEdge,
					eb->editbox.TopEdge);
			eb->editbox.GadgetText->FrontPen = penhold;
			}
		}

	eb->WidgetData->left = x;
	eb->WidgetData->top = y;
	eb->WidgetData->width = len;
	eb->WidgetData->height = fontheight + 2;
	eb->editbox.Width = len - (eb->WidgetData->flags & THREED ? 4 : 2);
	eb->editbox.LeftEdge = x + (eb->WidgetData->flags & THREED ? 2 : 1);
	eb->editbox.TopEdge = y + 1;

	if (eb->WidgetData->flags & THREED)
		{
		MakeBevel(&eb->lborder, &eb->dborder, eb->points, -2, -1, len, fontheight + 2, FALSE);
		if (ForList && !ForSubList)
			eb->dborder.NextBorder = &(eb->bb1);
		}
	else
		{
		eb->points[2] = eb->points[4] = eb->points[1] = eb->points[3] = eb->points[9] = eb->points[11] = 0;
		// 0 to fontheight+1 makes a height of fontheight+2
		eb->points[5]  = eb->points[7]  = eb->points[13] = eb->points[15] = fontheight + 1;
		eb->points[0]  = eb->points[6]  = eb->points[8]  = eb->points[14] = len - 1;
		eb->points[10] = eb->points[12] = len + DD_LIST_BOX_BUTTON_WIDTH - 1;
		}
	eb->arrow.LeftEdge = eb->bb1.LeftEdge = eb->bb2.LeftEdge = len - (eb->WidgetData->flags & THREED ? 2 : 1);
	}

void ResizeEditBox(EditBox *eb, int x, int y, int len, BOOL eraseold)
	{
	BOOL forsublist = FALSE;
	if (eb->list)
		if (eb->list->Parent)
			forsublist = TRUE;
	resizeeditbox(eb, x, y, len, eraseold, (eb->list != NULL), forsublist);
	}


/*	The top, left hand corner of the editbox border will be at the EXACT
	position specified in the x and y parameters passed to this function.

	The coordinates of the border, the pre-text and the post-text for a
	new edit box are identical to those of an output box which is created
	with the same parameters.  This has been THOROUGHLY tested and works
	whether or not the window has a title bar and independantly of whether
	or not the output box has a border.

	DO NOT CHANGE ONE WITHOUT CHANGING THE OTHER - PREFERABLY DON'T CHANGE! */

static EditBox* CreateEditBox(void *Parent, int x, int y, int len, int buflen, int BorderCol, int Bcol, int Tcol, int type, int id, BOOL (* __far __stdargs callfn)(EditBox*), BOOL ForList, BOOL ForSubList, long flags)
   {
   EditBox *p;
	GuiWindow *win;
	struct TextAttr *font;
	unsigned short fontheight;
	Frame *ParentFrame = NULL;

   Diagnostic("CreateEditBox", ENTER, TRUE);

	if (!Parent)
		{
	   Diagnostic("CreateEditBox", EXIT, FALSE);
		return NULL;
		}

	if (!ISGUIWINDOW(Parent))
		{
		ParentFrame = (Frame *) Parent;
		x += ParentFrame->button.LeftEdge;
		y += ParentFrame->button.TopEdge;
		win = (GuiWindow *) ParentFrame->button.UserData;
		}
	else
		win = (GuiWindow *) Parent;
	font = win->ParentScreen->Font;
	if (font)
		fontheight = font->ta_YSize;
	else
		fontheight = GuiFont.ta_YSize;

   p = (EditBox *) GuiMalloc(sizeof(struct EditBoxStruct), 0);
   if (!p)
      {
      Diagnostic("CreateEditBox", EXIT, FALSE);
      return NULL;
      }
   p->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0);
   if (!p->WidgetData)
      {
		GuiFree(p);
      Diagnostic("CreateEditBox", EXIT, FALSE);
      return NULL;
      }
	if (ForList)
		p->WidgetData->ObjectType = DDListBoxObject;
	else
		p->WidgetData->ObjectType = EditBoxObject;
	memset(&(p->strinfo), 0, sizeof(struct StringInfo));
	if (ParentFrame && ParentFrame->hidden != 0)
		p->hidden = -1;
	else
		p->hidden = 0;
	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	p->WidgetData->flags = flags;
	p->WidgetData->Parent = Parent;
	p->WidgetData->NextWidget = NULL;
	p->WidgetData->ChildWidget = NULL;
	p->id = id;
   p->enabled = p->OldStatus = TRUE;
   p->NextAssociated = p->PreviousAssociated = NULL;
   p->len = min(buflen, MAX_EDIT_BOX_LEN);
	if (flags & S_AUTO_SIZE)
		{
		if (!(p->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
			GuiFree(p->WidgetData);
			GuiFree(p);
			Diagnostic("CreateEditBox", EXIT, FALSE);
			return NULL;
			}
		p->WidgetData->os->left = x;
		p->WidgetData->os->top = y;
		p->WidgetData->os->width = len;
		p->WidgetData->os->height = fontheight + 2; // This one will never change for edit boxes.
		}
	else
		p->WidgetData->os = NULL;
   if (ForSubList)
		{
      p->buffer = p->undobuffer = NULL;
		}
   else
      {
      p->buffer = (char *) GuiMalloc((p->len + 1) * sizeof(char), MEMF_CLEAR);
      if (!(p->buffer))
         {
			if (p->WidgetData->os)
				GuiFree(p->WidgetData->os);
         GuiFree(p->WidgetData);
         GuiFree(p);
         Diagnostic("CreateEditBox", EXIT, FALSE);
         return NULL;
         }
      p->undobuffer = (char *) GuiMalloc((p->len + 1) * sizeof(char), MEMF_CLEAR);
      if (!(p->undobuffer))
         {
         GuiFree(p->buffer);
			if (p->WidgetData->os)
				GuiFree(p->WidgetData->os);
         GuiFree(p->WidgetData);
         GuiFree(p);
         Diagnostic("CreateEditBox", EXIT, FALSE);
         return NULL;
         }
		// Only allocate memory for the StringExtend structure if the machine
		// is capable of using it!
		if (Gui.LibVersion >= A3000)
			{
			p->strinfo.Extension = (struct StringExtend *) GuiMalloc(sizeof(struct StringExtend), MEMF_CLEAR);
			if (!(p->strinfo.Extension))
				{
  	   	   GuiFree(p->undobuffer);
  	      	GuiFree(p->buffer);
				if (p->WidgetData->os)
					GuiFree(p->WidgetData->os);
	         GuiFree(p->WidgetData);
	     	   GuiFree(p);
   	     	Diagnostic("CreateEditBox", EXIT, FALSE);
      	   return NULL;
				}
			if (type == FLOAT_EDIT || type == NO_EDIT)
				{
				p->strinfo.Extension->EditHook = (struct Hook *) GuiMalloc(sizeof(struct Hook), 0);
				if (!(p->strinfo.Extension->EditHook))
					{
					GuiFree(p->strinfo.Extension);
   		      GuiFree(p->undobuffer);
   	   	   GuiFree(p->buffer);
					if (p->WidgetData->os)
						GuiFree(p->WidgetData->os);
		         GuiFree(p->WidgetData);
      	   	GuiFree(p);
	         	Diagnostic("CreateEditBox", EXIT, FALSE);
		         return NULL;
					}
	      	p->strinfo.Extension->WorkBuffer = (char *) GuiMalloc((p->len + 1) * sizeof(char), 0);
		      if (!(p->strinfo.Extension->WorkBuffer))
   		      {
					GuiFree(p->strinfo.Extension->EditHook);
					GuiFree(p->strinfo.Extension);
   		      GuiFree(p->undobuffer);
   	   	   GuiFree(p->buffer);
					if (p->WidgetData->os)
						GuiFree(p->WidgetData->os);
		         GuiFree(p->WidgetData);
      	   	GuiFree(p);
	         	Diagnostic("CreateEditBox", EXIT, FALSE);
		         return NULL;
      		   }
				}
			}
      }

	p->lborder.FrontPen = BorderCol;
	p->lborder.DrawMode = JAM1;
	/* The leftedge and topedge of the border are relative to the leftedge and top edge of the string
		gadget.  For a 2D editbox, the string gadget is at x+1, y+1 so the border needs to be at -1,-1
		to put the top left corner of the border at x, y. */
   p->lborder.LeftEdge = p->lborder.TopEdge = -1;
   p->lborder.XY = p->points;

	p->editbox.UserData = (APTR) win;
	p->editbox.GadgetText = NULL;
	resizeeditbox(p, x, y, len, FALSE, ForList, ForSubList);

   if (ForList && !ForSubList)
      {
		if (!(flags & THREED))
			{
	      p->lborder.Count = 8;
   	   p->lborder.NextBorder = &(p->bb1);
			}
		if (Gui.LibVersion >= A3000)
			p->strinfo.Extension->InitialModes = SGM_REPLACE;
      }
   else if (ForSubList)
		{
      p->lborder.Count = 0;
      p->lborder.NextBorder = NULL;
		}
   else if (!(flags & THREED))
		{
		p->lborder.Count = 5;
		p->lborder.NextBorder = NULL;
		}

   p->list      = NULL;
   p->valifn    = callfn;
   p->type      = type;
   p->Bcol      = Bcol;
   p->Tcol      = Tcol;
   p->dp        = 2;
   p->previous  = NULL;
   p->next      = Gui.FirstEditBox;
   p->arrow.Count      = 4;
   p->bb1.Count        = p->bb2.Count = 3;
   p->bb1.NextBorder   = &(p->bb2);
   p->bb2.NextBorder   = &(p->arrow);
   p->arrow.NextBorder = NULL;
   p->bb1.FrontPen     = Gui.HiPen;
   p->bb2.FrontPen     = p->arrow.FrontPen = Gui.LoPen;
   p->arrow.DrawMode   = p->bb1.DrawMode = p->bb2.DrawMode = JAM1;
   p->arrow.TopEdge    = p->bb1.TopEdge  = p->bb2.TopEdge  = -1;
   p->bb1.XY           = (flags & THREED ? Newoutside3D : Newoutside);
   p->bb2.XY           = (flags & THREED ? &(Newoutside3D[4]) : &(Newoutside[4]));
   p->arrow.XY         = (flags & THREED ? Newarrow3D : Newarrow);

	p->editbox.NextGadget = NULL;
	p->editbox.Height = fontheight;
	p->editbox.Flags = GFLG_GADGHCOMP | GFLG_TABCYCLE | (Gui.LibVersion == A3000 ? 0 : GFLG_STRINGEXTEND);
	p->editbox.Activation = GACT_RELVERIFY | GACT_IMMEDIATE | (type == INT_EDIT ? GACT_LONGINT : 0) | (Gui.LibVersion >= A3000 ? GACT_STRINGEXTEND : 0);
	p->editbox.GadgetType = GTYP_STRGADGET;
	p->editbox.GadgetRender = &(p->lborder);
	p->editbox.SelectRender = NULL;
	p->editbox.MutualExclude = 0;
	p->editbox.SpecialInfo = &(p->strinfo);
	p->editbox.GadgetID = 0;
	p->strinfo.Buffer = p->buffer;
	p->strinfo.UndoBuffer = p->undobuffer;
	/*	A500's require 1 extra unused character otherwise any text written to the last character will
		not get cleared if shorter text is written into the box. */
	p->strinfo.MaxChars = p->len + (Gui.LibVersion < A3000 ? 1 : 0);

   if (Gui.LibVersion >= A3000 && !ForSubList)
		{
		p->strinfo.Extension->Pens[0] = Tcol;
		p->strinfo.Extension->Pens[1] = (flags & EB_CLEAR ? GetBackCol(Parent) : Bcol);
		p->strinfo.Extension->ActivePens[0] = Tcol;
		p->strinfo.Extension->ActivePens[1] = p->strinfo.Extension->Pens[1];
		}

	if (Gui.LibVersion >= A3000 && (type == FLOAT_EDIT || type == NO_EDIT) && !ForSubList)
		{
		memset(p->strinfo.Extension->WorkBuffer, 0, (p->len + 1) * sizeof(char));
		p->strinfo.Extension->EditHook->h_Entry = hookEntry;
		p->strinfo.Extension->EditHook->h_SubEntry = (type == FLOAT_EDIT ? hook_EditFloat : hook_ListBox);
		p->strinfo.Extension->EditHook->h_Data = 0;
		}

   if (Gui.FirstEditBox)
      Gui.FirstEditBox->previous = p;
   Gui.FirstEditBox = p;

	if (p->hidden == 0 && !ForSubList)
		{
	   AddGadget(win->Win, &p->editbox, -1);
		RefreshGList(&p->editbox, win->Win, NULL, 1);
		}

   Diagnostic("CreateEditBox", EXIT, TRUE);
   return p;
   }

EditBox* FOXLIB MakeEditBox(REGA0 void *Parent, REGD0 int x, REGD1 int y, REGD2 int len, REGD3 int buflen,
		REGD4 int id, REGA1 BOOL (* __far __stdargs callfn) (EditBox*), REGD5 long flags, REGA2 void *extension)       /* Tcol must be between 0 & 7 */
   {
	int type;
   EditBox *p;

   Diagnostic("MakeEditBox", ENTER, TRUE);

	// Extract the edit box type from the flags
	if (flags & NO_EDIT)
		type = NO_EDIT;
	else if (flags & FLOAT_EDIT)
		type = FLOAT_EDIT;
	else if (flags & INT_EDIT)
		type = INT_EDIT;
	else
		type = TEXT_EDIT;

   p = CreateEditBox(Parent, x, y, len, buflen, Gui.BorderCol, Gui.BackCol, Gui.TextCol, type, id, callfn, FALSE, FALSE, flags);
   if (p)
      Diagnostic("MakeEditBox", EXIT, TRUE);
   else
      Diagnostic("MakeEditBox", EXIT, FALSE);
   return p;
   }

BOOL FOXLIB SetDDListBoxPopup(REGA0 DDListBox *l, REGD0 int x, REGD1 int y, REGD2 int width, REGD3 int height)
   {
   Diagnostic("SetDDListBoxPopup", ENTER, TRUE);
	if (l && l->list && height && width)
		{
		int fontheight = GuiFont.ta_YSize; //GetFontHeight(GUIWIN(l));

		if ((height * fontheight) + 3 + y > GUIWIN(l)->ParentScreen->Height || width >
				GUIWIN(l)->ParentScreen->Width)   /* Won't fit on screen when opened */
      	return Diagnostic("SetDDListBoxPopup", EXIT, FALSE);
	   l->list->PopupWidth = width;
   	l->list->MaxHeight = height;
	   l->list->PopupX = x;
   	l->list->PopupY = y;
	   return Diagnostic("SetDDListBoxPopup", EXIT, TRUE);
		}
	else
     	return Diagnostic("SetDDListBoxPopup", EXIT, FALSE);
   }

BOOL FOXLIB AssociateDDListBox(REGA0 DDListBox *l, REGA1 DDListBox *m)
	{
   Diagnostic("AssociateDDListBox", ENTER, TRUE);
	if (!(l->list))
		return Diagnostic("AssociateDDListBox", EXIT, FALSE);
	if (l->NextAssociated || l->PreviousAssociated || l->list->first)
		return Diagnostic("AssociateDDListBox", EXIT, FALSE);

	GuiFree(l->list);
	l->list = m->list;
	l->NextAssociated = m->NextAssociated;
	l->PreviousAssociated = m;
	if (m->NextAssociated)
		m->NextAssociated->PreviousAssociated = l;
	m->NextAssociated = l;
	return Diagnostic("AssociateDDListBox", EXIT, TRUE);
	}

void FOXLIB ClearDDListBox(REGA0 DDListBox *l)
   {
   struct ListElement *p = l->list->first, *n;
   Diagnostic("ClearDDListBox", ENTER, TRUE);
//	if (l->NextAssociated == NULL && l->PreviousAssociated == NULL)
//		{
      while (p)
         {
         n = p->Next;
         GuiFree(p->string);
			if (p->Child)
				{
				/* If there is a child then the call to DestroyDDListBox() for that child will attempt
					to sever the link from the parent (this list) to it's child.  To do that it will have
					to navigate through the list looking for the parent element.  That would cause all sorts
					of problems because we've already started freeing the list so we'd better set the
					child's parent to NULL. */
				if (p->Child->list)
					p->Child->list->Parent = NULL;
				DestroyDDListBox((DDListBox *) p->Child, FALSE);
				}
         GuiFree(p);
         p = n;
         }
      l->list->first = NULL;
      l->list->TotalElems = 0;
//		}
   Diagnostic("ClearDDListBox", EXIT, TRUE);
   }

BOOL FOXLIB RemoveFromDDListBox(REGA0 DDListBox *list, REGA1 char *str)      /* Returns TRUE if successful */
   {
   int i = 1;
   struct ListElement *old, *previous = NULL;
   Diagnostic("RemoveFromDDListBox", ENTER, TRUE);
   if (!list)
      return Diagnostic("RemoveFromDDListBox", EXIT, FALSE);
   if (!(list->list))
      return Diagnostic("RemoveFromDDListBox", EXIT, FALSE);
//	if (list->NextAssociated || list->PreviousAssociated)
//		return Diagnostic("RemoveFromDDListBox", EXIT, FALSE);
   old = list->list->first;
   while (old)
      {
      if (!strcmp(old->string, str))
         break;
      else
         {
         previous = old;
         old = old->Next;
         }
      }
   if (!old)
      return Diagnostic("RemoveFromDDListBox", EXIT, FALSE);
   if (previous)
      previous->Next = old->Next;
   else
      list->list->first = old->Next;
   list->list->TotalElems--;
   GuiFree(old->string);
   if (old->Child)
      DestroyDDListBox((DDListBox *) old->Child, FALSE);
   GuiFree(old);
   old = list->list->first;
   while (old)
      {
      old->Itemnum = i++;
      old = old->Next;
      }
   return Diagnostic("RemoveFromDDListBox", EXIT, TRUE);
   }

BOOL FOXLIB AddToDDListBox(REGA0 DDListBox *list, REGA1 char *str)      /* Returns TRUE if successful */
   {
   struct ListElement *le, *p, *f;
   Diagnostic("AddToDDListBox", ENTER, TRUE);
   if (!list)
      {
      SetLastErr("NULL DDListBox pointer sent to AddToDDListBox().");
      return Diagnostic("AddToDDListBox", EXIT, FALSE);
      }
   if (!(list->list))
      return Diagnostic("AddToDDListBox", EXIT, FALSE);
   if (!(le = (struct ListElement *) GuiMalloc(sizeof(struct ListElement), 0)))
      return Diagnostic("AddToDDListBox", EXIT, FALSE);
   if (!(le->string = (char *) GuiMalloc((strlen(str) + 1) * sizeof(char), 0)))
      {
      GuiFree(le);
      return Diagnostic("AddToDDListBox", EXIT, FALSE);
      }
   strcpy(le->string, str);
   le->Next = NULL;
   le->Child = NULL;
   le->Itemnum = ++(list->list->TotalElems);
   p = list->list->first;
   f = NULL;
   while (p)
      {
      f = p;
      p = p->Next;
      }
   if (!f)
      list->list->first = le;
   else
      f->Next = le;
   return Diagnostic("AddToDDListBox", EXIT, TRUE);
   }

static void UndrawDDListBox(DDListBox *p)
	{
	int fontheight = GetFontHeight(GUIWIN(p));
	AreaColFill(GUIWIN(p)->Win->RPort, p->WidgetData->left, p->WidgetData->top, p->WidgetData->width + DD_LIST_BOX_BUTTON_WIDTH, fontheight + 2,
			GetBackCol(p->WidgetData->Parent));
	}

BOOL ShowDDListBox(DDListBox *p)
	{
	Diagnostic("ShowDDListBox", ENTER, TRUE);
	if (p && p->list)
		{
		struct Window *w = GUIWIN(p)->Win;

		if (p->hidden == 1) // The drop-down list box is really hidden.
			if ((!ISGUIWINDOW(p->WidgetData->Parent)) && ((Frame *) p->WidgetData->Parent)->hidden != 0)
				p->hidden = -1; // The drop-down list box is in a hidden frame so it will remain hidden
			else
				{
				BOOL prefound, nextfound;
				UWORD prepos, nextpos, pos;

				FindPreviousNext(p, &prefound, &nextfound, &prepos, &nextpos);
				// The gadget is not in the list so we need to add it.
				if (nextfound)
					pos = nextpos + 1;
				else if (prefound)
					pos = prepos;
				else
					pos = (unsigned short) ~0; // Add to the end of the list because we couldn't find the right place.
				AddGadget(w, &p->editbox, pos);
				p->hidden = 0;
				}
		if (p->hidden == 0)
			{
			// Refresh the gadget
			RefreshGList(&p->editbox, w, NULL, 1);
			if (Gui.LibVersion < A3000)
				RemoveGadget(w, &p->editbox);
			}
		return Diagnostic("ShowDDListBox", EXIT, TRUE);
		}
	return Diagnostic("ShowDDListBox", EXIT, FALSE);
	}

BOOL HideDDListBox(DDListBox *p)
	{
	Diagnostic("HideDDListBox", ENTER, TRUE);
	if (p && p->list)
		{
		if (p->hidden == 0)
			{
			UndrawDDListBox(p);
			if (Gui.LibVersion >= A3000)
				RemoveGadget(GUIWIN(p)->Win, &(p->editbox));
			}
		p->hidden = 1;
		return Diagnostic("HideDDListBox", EXIT, TRUE);
		}
	return Diagnostic("HideDDListBox", EXIT, FALSE);
	}

void DestroyDDListBox(DDListBox *p, BOOL refresh)
   {
   Diagnostic("DestroyDDListBox", ENTER, TRUE);
   if (p && p->list)
      {
		Frame *Child; // Could be any control type

		if (p->NextAssociated == NULL && p->PreviousAssociated == NULL)
			{
			ClearDDListBox(p);
			if (p->list->Parent)
				{
				struct ListElement *e = p->list->Parent->list->first;
				while (e)
					{
					if (e->Child == p)
						break;
					e = e->Next;
					}
				if (e)
					e->Child = NULL;
				}
			GuiFree(p->list);
			}
		else
			{
			// Remove this drop-down list from the association list.
			if (p->PreviousAssociated)
				p->PreviousAssociated->NextAssociated = p->NextAssociated;
			if (p->NextAssociated)
				p->NextAssociated->PreviousAssociated = p->PreviousAssociated;
			}
		p->list = NULL;

		/* On an A500, the gadget won't be in the list but DestroyEditBox() will attempt to remove it
			from the list, so add it back here. */
		if (Gui.LibVersion < A3000)
			AddGadget(GUIWIN(p)->Win, &(p->editbox), -1);

		if (refresh && p->hidden == 0)
			UndrawDDListBox(p);
		Child = p->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
      DestroyEditBox(p, FALSE);
      }
   Diagnostic("DestroyDDListBox", EXIT, TRUE);
   }

void DestroyAllDDListBoxes(BOOL refresh)
   {
   struct EditBoxStruct *p;
   Diagnostic("DestroyAllDDListBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
		if (p->list)
			{
	      DestroyDDListBox(p, refresh);
			p = Gui.FirstEditBox;
			}
		else
			p = p->next;
      }
   Diagnostic("DestroyAllDDListBoxes", EXIT, TRUE);
   }

void DestroyWinDDListBoxes(GuiWindow *c, BOOL refresh)
   {
	BOOL message = FALSE;
   struct EditBoxStruct *p;
   Diagnostic("DestroyWinDDListBoxes", ENTER, TRUE);
   p = Gui.FirstEditBox;
   while (p)
      {
      if (GUIWIN(p) == c && p->list)
			{
         DestroyDDListBox((DDListBox *) p, refresh);
			message = TRUE;
			p = Gui.FirstEditBox;
			}
		else
			p = p->next;
      }
	if (Gui.CleanupFlag && message)
		SetLastErr("Window closed before all of its list boxes were destroyed.");
   Diagnostic("DestroyWinDDListBoxes", EXIT, TRUE);
   }

static DDListBox *CreateDDListBox(void *Parent, int x, int y, int len, int buflen, int maxheight, int BorderCol, int Bcol, int Tcol, int id, BOOL (*callfn) (DDListBox*), BOOL ForSubListBox, long flags)
   {
   DDListBox *p;
   struct DDListBoxStruct *l;
	int winheight, fontheight, xoffset = 0, yoffset = 0;
	GuiWindow *win;

   Diagnostic("CreateDDListBox", ENTER, TRUE);

   if (x < 0 || y < 0 || !Parent)
		{
	   Diagnostic("CreateDDListBox", EXIT, FALSE);
		return NULL;
		}

	if (!ISGUIWINDOW(Parent))
		{
		xoffset = ((Frame *) Parent)->button.LeftEdge;
		yoffset = ((Frame *) Parent)->button.TopEdge;
		win = (GuiWindow *) ((Frame *) Parent)->button.UserData;
		}
	else
		win = (GuiWindow *) Parent;

	fontheight = GetFontHeight(win);
	winheight = (maxheight * fontheight) + 3;
   if (!ForSubListBox)
      {
      if (y + yoffset + win->Win->TopEdge + fontheight + 2 > win->ParentScreen->Height || /* Box is too low down */
			x + xoffset + win->Win->LeftEdge + len + DD_LIST_BOX_BUTTON_WIDTH - 1 > win->ParentScreen->Width) /* Box is too wide or too far right */
         {
         Diagnostic("CreateDDListBox", EXIT, FALSE);
         return NULL;
         }
      if (win->Win->TopEdge + y + yoffset + fontheight + 2 + winheight > win->ParentScreen->Height) /* Box cannot drop below - try above */
         if (win->Win->TopEdge + y + yoffset - winheight < 0) /* Box Can't drop above */
            {
            Diagnostic("CreateDDListBox", EXIT, FALSE);
            return NULL;
            }
      }
   l = (struct DDListBoxStruct *) GuiMalloc(sizeof(struct DDListBoxStruct), MEMF_CLEAR);
   if (!l)
      {
      Diagnostic("CreateDDListBox", EXIT, FALSE);
      return NULL;
      }
   p = (DDListBox *) CreateEditBox(Parent, x, y, len, buflen, BorderCol, Bcol, Tcol, NO_EDIT, id, callfn, TRUE, ForSubListBox, flags);
   if (!p)
      {
      GuiFree(l);
      Diagnostic("CreateDDListBox", EXIT, FALSE);
      return NULL;
      }
   p->list = l;
   l->MaxHeight = maxheight;
   l->TotalElems = 0;

	/* On an A500, we mustn't allow the user to edit the contents of the list box (since edit hooks
		aren't supported) so we need to remove the gadget to prevent the user from editing it. */
	if (Gui.LibVersion < A3000)
		RemoveGList(GUIWIN(p)->Win, &p->editbox, 1);

   Diagnostic("CreateDDListBox", EXIT, TRUE);
   return p;
   }

DDListBox* FOXLIB MakeDDListBox(REGA0 void *Parent, REGD0 int x, REGD1 int y, REGD2 int len, REGD3 int buflen,
	REGD4 int MaxHeight, REGD5 int id, REGA1 BOOL (* __far __stdargs callfn) (DDListBox*), REGD6 long flags, REGA2 void *extension)       /* Tcol must be between 0 & 7 */
   {
   DDListBox *p;
   Diagnostic("MakeDDListBox", ENTER, TRUE);

	p = CreateDDListBox(Parent, x, y, len, buflen, MaxHeight, Gui.BorderCol, Gui.BackCol, Gui.TextCol, id, callfn, FALSE, flags);
   if (p)
      Diagnostic("MakeDDListBox", EXIT, TRUE);
   else
      Diagnostic("MakeDDListBox", EXIT, FALSE);
   return p;
   }

DDListBox* FOXLIB MakeSubDDListBox(REGA0 DDListBox *lb, REGA1 char *string, REGD0 int left, REGD1 int top, REGD2 int width,
		REGD3 int height, REGD4 int id, REGA2 BOOL (* __far __stdargs callfn)(DDListBox*), REGA3 void *extension)
   {
   DDListBox *l;
   struct ListElement *i;
   int TextHeight = max((height / 8) - 1, 1);
   Diagnostic("MakeSubDDListBox", ENTER, TRUE);
   if ((!lb) || (!lb->list) || !string)
      {
      Diagnostic("MakeSubDDListBox", EXIT, FALSE);
      return NULL;
      }
   i = lb->list->first;
   while (i)
      {
      if (!strcmp(i->string, string))
         break;
      else
         i = i->Next;
      }
   if (!i)
      {
      AddToDDListBox(lb, string);
      i = lb->list->first;
      while (i)
         {
         if (!strcmp(i->string, string))
            break;
         else
            i = i->Next;
         }
      }
   if (!i)   /* AddToDDListBox must have failed */
      {
      Diagnostic("MakeSubDDListBox", EXIT, FALSE);
      return NULL;
      }
   if (i->Child)
      {
      Diagnostic("MakeSubDDListBox", EXIT, FALSE);
      return NULL;
      }
	l = CreateDDListBox(GUIWIN(lb), 1, 0, 0, 0, TextHeight, lb->lborder.FrontPen, lb->Bcol, lb->Tcol, id, callfn, TRUE, 0);
   if (!l)
      {
      Diagnostic("MakeSubDDListBox", EXIT, FALSE);
      return NULL;
      }
   if (!SetDDListBoxPopup(l, left, top, width, height))
      {
      DestroyDDListBox(l, FALSE);
      Diagnostic("MakeSubDDListBox", EXIT, FALSE);
      return NULL;
      }
   i->Child = l;
   l->list->Parent = lb;
   Diagnostic("MakeSubDDListBox", EXIT, TRUE);
   return l;
   }

void FOXLIB SetOutputBoxDP(REGA0 OutputBox *p, REGD0 int dp)
   {
   Diagnostic("SetOutputBoxDP", ENTER, TRUE);
   p->dp = dp;
   Diagnostic("SetOutputBoxDP", EXIT, TRUE);
   }

void FOXLIB SetOutputBoxInt(REGA0 OutputBox *p, REGD0 int num)
   {
   char str[MAX_EDIT_BOX_LEN + 1];
   Diagnostic("SetOutputBoxInt", ENTER, TRUE);
   sprintf(str, "%d", num);
   SetOutputBoxText(p, str);
   Diagnostic("SetOutputBoxInt", EXIT, TRUE);
   }

BOOL HideOutputBox(OutputBox *p)
	{
	Diagnostic("HideOutputBox", ENTER, TRUE);
	if (p)
		{
		if (p->hidden == 0)
			{
			int width;
			BYTE BackCol = GetBackCol(p->WidgetData->Parent);

			// Work out the width of the output box.
			if (p->dborder.Count == 0)			// The output box has a 2d border or no border at all.
				width = p->points[2] + 1;
			else										// The output box has a 3d border.
				width = p->points[12] + 1;
			AreaColFill(p->win->Win->RPort, p->lborder.LeftEdge, p->lborder.TopEdge, width,
					p->font->ta_YSize + 2, BackCol);
			}
		p->hidden = 1;
		return Diagnostic("HideOutputBox", EXIT, TRUE);
		}
	return Diagnostic("HideOutputBox", EXIT, FALSE);
	}

void DestroyOutputBox(OutputBox *p, BOOL refresh)
   {
   Diagnostic("DestroyOutputBox", ENTER, TRUE);
   if (p && p->WidgetData->ParentControl == NULL)
      {
		Frame *Child; // Could be any control type
      OutputBox *n = p->next;
      if (p == Gui.FirstOutputBox)
         Gui.FirstOutputBox = n;
      if (n)
         n->previous = p->previous;
      if (p->previous)
         p->previous->next = n;
		GuiFree(p->text);

		if (refresh)
			HideOutputBox(p);

		if (p->WidgetData->os)
			GuiFree(p->WidgetData->os);
		if (p->font)
			{
			if (p->font->ta_Name)
				GuiFree(p->font->ta_Name);
			GuiFree(p->font);
			}
		Child = p->WidgetData->ChildWidget;
		while (Child)
			{
			Widget *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
      GuiFree(p->WidgetData);
      GuiFree(p);
      }
   Diagnostic("DestroyOutputBox", EXIT, TRUE);
   }

void DestroyAllOutputBoxes(BOOL refresh)
   {
   OutputBox *p;
   Diagnostic("DestroyAllOutputBoxes", ENTER, TRUE);
   p = Gui.FirstOutputBox;
   while (p)
      {
		OutputBox *next = p->next;
      DestroyOutputBox(p, refresh);
      p = next;
      }
   Diagnostic("DestroyAllOutputBoxes", EXIT, TRUE);
   }

void DestroyWinOutputBoxes(GuiWindow *c, BOOL refresh)
   {
	BOOL message = FALSE;
   OutputBox *p;
   Diagnostic("DestroyWinOutputBoxes", ENTER, TRUE);
   p = Gui.FirstOutputBox;
   while (p)
      {
		OutputBox *next = p->next;
      if (p->win == c)
         {
         DestroyOutputBox(p, refresh);
			message = TRUE;
         }
      p = next;
      }
	if (Gui.CleanupFlag && message)
		SetLastErr("Window closed before all of its output boxes were destroyed.");
   Diagnostic("DestroyWinOutputBoxes", EXIT, TRUE);
   }

void DoubleToString(char *str, double dbl, int dp)
{
	double whole = floor(dbl);
	double remain = dbl - whole, dec;
	int n;

	for (n = 0; n < dp; n++)
		remain *= 10;

	dec = floor(remain);
	sprintf(str, "%d.%d", (int) whole, (int) dec);
}

void FOXLIB SetOutputBoxDouble(REGA0 OutputBox *p, REGD0 double num)
   {
   char str[MAX_EDIT_BOX_LEN + 1];
   Diagnostic("SetOutputBoxDouble", ENTER, TRUE);
	// We can't use sprintf because we have to link with sc.lib before scmieee.lib and
	// the version of sprintf in sc.lib doesn't support floats or doubles.
	DoubleToString(str, num, p->dp);
   SetOutputBoxText(p, str);
   Diagnostic("SetOutputBoxDouble", EXIT, TRUE);
   }

double GetDoubleFromStr(char *str)
   {
   double num = 0.0, pnum = 1;
   int neg = 1, ptr;
   for (ptr = 0; ptr < strlen(str) && str[ptr] != '.'; ptr++)
      if (str[ptr] == '-')
         neg = -1;
      else
         num = (num * 10.0) + str[ptr] - '0';
   if (str[ptr++] == '.')
      for (; ptr < strlen(str); ptr++)
         num += (pnum /= 10.0) * (str[ptr] - '0');
   num *= neg;
   return num;
   }

double FOXLIB GetEditBoxDouble(REGA0 EditBox *p)
   {
   Diagnostic("GetEditBoxDouble", ENTER, TRUE);
   if (!p)
      {
      Diagnostic("GetEditBoxDouble", EXIT, FALSE);
      return 0.0;
      }
   Diagnostic("GetEditBoxDouble", EXIT, TRUE);
   return GetDoubleFromStr(p->buffer);
   }

BOOL FOXLIB SetEditBoxDouble(REGA0 EditBox *p, REGD0 double num)
   {
   BOOL retval;
   char str[30];
   Diagnostic("SetEditBoxDouble", ENTER, TRUE);
   if (!p)
      return Diagnostic("SetEditBoxDouble", EXIT, FALSE);
	// We can't use sprintf because we have to link with sc.lib before scmieee.lib and
	// the version of sprintf in sc.lib doesn't support floats or doubles.
	DoubleToString(str, num, p->dp);
   retval = SetEditBoxText(p, str);
   return Diagnostic("SetEditBoxDouble", EXIT, retval);
   }

BOOL FOXLIB SetDDListBoxText(REGA0 DDListBox *l, REGA1 char *c)
{
	return SetEditBoxText((EditBox *) l, c);
}

char* FOXLIB GetDDListBoxText(REGA0 DDListBox *l)
{
	return GetEditBoxText((EditBox*) l);
}

int FOXLIB GetEditBoxID(REGA0 EditBox *p)
{
	return p->id;
}

int FOXLIB GetDDListBoxID(REGA0 DDListBox *l)
{
	return l->id;
}
