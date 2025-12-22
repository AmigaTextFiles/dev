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
#include <math.h>
#include <string.h>

#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

#include <proto/exec.h>
#include <proto/intuition.h>

static void TruncateOBText(OutputBox *ob)
	{
	int MaxLen = ob->WidgetData->flags & THREED ? ob->points[0] - 2 : ob->points[2] - 1;
	TruncateIText(&ob->IText, ob->text, MaxLen, ob->WidgetData->flags);
	}

static void RefreshOutputBox(OutputBox *p)
	{
	if (p->hidden == 0)
		{
		// Print the text
		PrintIText(p->win->Win->RPort, &(p->IText), 0, 0);

		// Refresh the border incase the text has trashed it.
		DrawBorder(p->win->Win->RPort, &(p->lborder), 0, 0);
		}
	}

void FOXLIB SetOutputBoxText(REGA0 OutputBox *p, REGA1 char *text)
   {
   Diagnostic("SetOutputBoxText", ENTER, TRUE);

	if (p && text)
		{
		int PixLen = p->WidgetData->flags & THREED ? p->points[0] + 2 : p->points[2] + 1;

		if (p->hidden == 0)
			{
			// Un-print the old text
			int penhold = p->IText.FrontPen;
			p->IText.FrontPen = p->win->Win->RPort->BgPen;
			PrintIText(p->win->Win->RPort, &p->IText, 0, 0);
			p->IText.FrontPen = penhold;
			}

		// Prepare the new text.
		if (strlen(text) > p->len)
			{ // p->text[0] is used for storing the trunc char.
			strncpy(&p->text[1], text, p->len);
			p->text[p->len + 1] = 0;
			/*	The text has been truncated but we're not storing the trunc char because the text is too
				long for the buffer.  We store the trunc char if the text fits in the buffer but not in
				the screen space available. */
			}
		else
			strcpy(&p->text[1], text);
		p->text[0] = 0;

		TruncateOBText(p);

		if (p->WidgetData->flags & JUSTIFY_LEFT)
			p->IText.LeftEdge = p->lborder.LeftEdge + (p->WidgetData->flags & THREED ? 2 : 1);
		else if (p->WidgetData->flags & JUSTIFY_RIGHT)
			p->IText.LeftEdge = p->lborder.LeftEdge + PixLen - (p->WidgetData->flags & THREED ? 3 : 2) - IntuiTextLength(&p->IText);
		else // JUSTIFY_CENTRE
			p->IText.LeftEdge = ((PixLen - IntuiTextLength(&p->IText)) / 2) + p->lborder.LeftEdge - 1;

		// Print the new text
		RefreshOutputBox(p);

   	Diagnostic("SetOutputBoxText", EXIT, TRUE);
		return;
		}
  	Diagnostic("SetOutputBoxText", EXIT, FALSE);
   }

BOOL ShowOutputBox(OutputBox *p)
	{
	Diagnostic("ShowOutputBox", ENTER, TRUE);
	if (p)
		{
		if (p->hidden == 1) // The output box is really hidden
			{
			if ((!ISGUIWINDOW(p->WidgetData->Parent)) && ((Frame *) p->WidgetData->Parent)->hidden != 0)
				p->hidden = -1; // The output box is in a hidden frame and will remain hidden
			else
				p->hidden = 0;
			}
		if (p->hidden == 0)
			RefreshOutputBox(p);
		return Diagnostic("ShowOutputBox", EXIT, TRUE);
		}
	return Diagnostic("ShowOutputBox", EXIT, FALSE);
	}

void FOXLIB SetOutputBoxCols(REGA0 OutputBox *ob, REGD0 int Bcol, REGD1 int Tcol, REGD2 BOOL refresh)
	{
	if (ob)
		{
		ob->Bcol = Bcol;
		ob->Tcol = Tcol;
		ob->IText.FrontPen = ob->Tcol;
		if (!(ob->WidgetData->flags & THREED))
			ob->lborder.FrontPen = Bcol;
		if (refresh)
			RefreshOutputBox(ob);
		}
	}

void ResizeOutputBox(OutputBox *ob, int x, int y, int len, BOOL eraseold)
	{
	int fontheight = ob->font ? ob->font->ta_YSize : ob->win->Win->RPort->TxHeight;

	/*	If the output box is in a coloured frame then no need to blank it because the parent frame will
		blank it's entire contents. */
	if (eraseold && GetBackCol(ob->WidgetData->Parent) == ob->win->Win->RPort->BgPen)
		{
		int penhold;

		AreaBlank(ob->win->Win->RPort, ob->lborder.LeftEdge, ob->lborder.TopEdge, (ob->WidgetData->flags & THREED ?
				ob->points[12] : ob->points[2]) + 1, fontheight + 2);
		/*	Incase the text in the output box (which doesn't necessarily get clipped) extends beyond the
			box itself, we'd better blank it. */
		penhold = ob->IText.FrontPen;
		ob->IText.FrontPen = ob->win->Win->RPort->BgPen;
		PrintIText(ob->win->Win->RPort, &ob->IText, 0, 0);
		ob->IText.FrontPen = penhold;
		}

	if (ob->WidgetData->flags & THREED)
		MakeBevel(&ob->lborder, &ob->dborder, ob->points, x, y, len, fontheight + 2, TRUE);
	else
		{
		ob->points[2] = ob->points[4] = len - 1; /* 0 to len-1 makes len pixels */
		ob->lborder.LeftEdge = x;
		ob->lborder.TopEdge = y;
		}
	ob->IText.TopEdge = y + 1;
	// Must truncate before setting the left edge so that IntuiTextLength returns the correct result.
	TruncateOBText(ob);
	if (ob->WidgetData->flags & JUSTIFY_LEFT)
		ob->IText.LeftEdge = x + (ob->WidgetData->flags & THREED ? 2 : 1);
	else if (ob->WidgetData->flags & JUSTIFY_RIGHT)
		ob->IText.LeftEdge = x + len - (ob->WidgetData->flags & THREED ? 3 : 2) - IntuiTextLength(&ob->IText);
	else // JUSTIFY_CENTRE
		ob->IText.LeftEdge = ((len - IntuiTextLength(&ob->IText)) / 2) + x - 1;

	ob->WidgetData->left = x;
	ob->WidgetData->top = y;
	ob->WidgetData->width = len;
	ob->WidgetData->height = fontheight + 2;
	}

/*	The top, left hand corner of the outputbox border will be at the EXACT
	position specified in the x and y parameters passed to this function.

	The coordinates of the border, the pre-text and the post-text for a
	new edit box are identical to those of an output box which is created
	with the same parameters.  This has been THOROUGHLY tested and works
	whether or not the window has a title bar and independantly of whether
	or not the output box has a border.

	DO NOT CHANGE ONE WITHOUT CHANGING THE OTHER - PREFERABLY DON'T CHANGE! */

OutputBox* FOXLIB MakeOutputBox(REGA0 void *parent, REGD0 int x, REGD1 int y, REGD2 int width, REGD3 int len,
		REGD4 int id, REGA1 char *InitialValue, REGD5 long flags, REGA2 void *extension)       /* Tcol must be between 0 & 7 */
   {
	GuiWindow *Parent = parent; // May not actually be a guiwindow.
	int fontheight;
   OutputBox *ob;
	GuiWindow *win;
	Frame *ParentFrame = NULL;
   Diagnostic("MakeOutputBox", ENTER, TRUE);

   if (!(Parent && ( (len && width) || (flags & OB_PRE) || (flags & OB_POST) || (flags & S_FONT_SENSITIVE) ) ))
      {
      Diagnostic("MakeOutputBox", EXIT, FALSE);
      return NULL;
      }

   ob = (OutputBox *) GuiMalloc(sizeof(OutputBox), MEMF_CLEAR);
   if (!ob)
      {
      Diagnostic("MakeOutputBox", EXIT, FALSE);
      return NULL;
      }
   ob->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), MEMF_CLEAR);
   if (!ob->WidgetData)
      {
		GuiFree(ob);
      Diagnostic("MakeOutputBox", EXIT, FALSE);
      return NULL;
      }

	if (flags & S_FONT_SENSITIVE)
		width = GuiTextLength(InitialValue, &GuiFont) + (flags & THREED ? 4 : 2);

	if (!ISGUIWINDOW(Parent))
		{
		if (Parent->WidgetData->ObjectType == FrameObject)
			{
			ParentFrame = (Frame *) Parent;
			x += ParentFrame->button.LeftEdge;
			y += ParentFrame->button.TopEdge;
			win = (GuiWindow *) ParentFrame->button.UserData;
			}
		else
			{
			GuiWindow *Holder = Parent, *LastChild;
			ob->WidgetData->ParentControl = Parent;
			// The parent is not a frame or a window so we're creating pre or post text for the parent.

			LastChild = ((Frame *) ob->WidgetData->ParentControl)->WidgetData->ChildWidget;
			if (LastChild == NULL)
				((Frame *) ob->WidgetData->ParentControl)->WidgetData->ChildWidget = ob;
			else
				{
				while (LastChild->WidgetData->NextWidget)
					LastChild = LastChild->WidgetData->NextWidget;
				LastChild->WidgetData->NextWidget = ob;
				}
			// Find out what type of object the parent resides in.
			while (Holder->WidgetData->ObjectType != FrameObject && Holder->WidgetData->ObjectType != WindowObject)
				Holder = Holder->WidgetData->Parent;
			if (Holder->WidgetData->ObjectType == FrameObject)
				{
				ParentFrame = (Frame *) Holder;
				win = (GuiWindow *) ParentFrame->button.UserData;
				}
			else
				win = (GuiWindow *) Holder;
			// Now calculate the x and y coordinates of the label based on the label text and the size and position
			// of the parent object.
			width = GuiTextLength(InitialValue, &GuiFont) + (flags & THREED ? 4 : 2);
			y = Parent->WidgetData->top;
			len = strlen(InitialValue) + 1;
			if (flags & OB_POST)
				{
				x = Parent->WidgetData->left + Parent->WidgetData->width + 4;
				if (Parent->WidgetData->ObjectType == DDListBoxObject)
					x += DD_LIST_BOX_BUTTON_WIDTH;
				}
			else // OB_PRE
				x = Parent->WidgetData->left - width - (flags & THREED ? 3 : 1);
			if (flags & JUSTIFY_RIGHT)
				flags -= JUSTIFY_RIGHT;
			if (flags & JUSTIFY_LEFT)
				flags -= JUSTIFY_LEFT;
			Parent = Holder;	// !!! Temporary - so that outputbox gets refreshed when necessary (e.g. when frame is shown after
									// being hidden).  Can be removed when parents refresh their children.
			}
		}
	else
		win = (GuiWindow *) Parent;

	ob->WidgetData->ObjectType = OutputBoxObject;
	ob->WidgetData->NextWidget = NULL;
	ob->WidgetData->ChildWidget = NULL;
   ob->len = min(len, MAX_EDIT_BOX_LEN);
	/*	Allocate space for two extra chars.  The first is the usual NULL terminator, the second is for
		holding a truncation character. */
	if (!(ob->text = (char *) GuiMalloc((ob->len + 2) * sizeof(char), 0)))
      {
		GuiFree(ob->WidgetData);
		GuiFree(ob);
      Diagnostic("MakeOutputBox", EXIT, FALSE);
      return NULL;
      }
	// trunc char = first char = 0.
	ob->text[0] = ob->text[1] = 0;
	ob->font = CopyFont(&GuiFont);
	if (ob->font == NULL)
   {
  	   GuiFree(ob->text);
		GuiFree(ob->WidgetData);
      GuiFree(ob);
     	Diagnostic("MakeOutputBox", EXIT, FALSE);
      return NULL;
  	}
	fontheight = ob->font->ta_YSize;
	ob->WidgetData->Parent = Parent;
   ob->win = win;
	if (ParentFrame && ParentFrame->hidden != 0)
		ob->hidden = -1;
	else
		ob->hidden = 0;
	SetOutputBoxCols(ob, Gui.BorderCol, Gui.TextCol, FALSE);
   ob->id = id;
	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
   ob->WidgetData->flags = flags;

	if (flags & S_AUTO_SIZE)
		{
		if (!(ob->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
  	      GuiFree(ob->text);
			GuiFree(ob->WidgetData);
     	   GuiFree(ob);
        	Diagnostic("MakeOutputBox", EXIT, FALSE);
         return NULL;
			}
		ob->WidgetData->os->left = x;
		ob->WidgetData->os->top = y;
		ob->WidgetData->os->width = width;
		ob->WidgetData->os->height = fontheight + 2;
		}
	else
		ob->WidgetData->os = NULL;

	if (!(flags & THREED))
		{
   	ob->points[5] = ob->points[7] = fontheight + 1; /* 0 to fontheight+1 makes fontheight+2 */
	   ob->lborder.Count = (flags & NO_BORDER ? 0 : 5);
	   ob->lborder.DrawMode = JAM1;
   	ob->lborder.XY = ob->points;
		}
	ob->IText.DrawMode = JAM1;
	ob->IText.ITextFont = ob->font;
	ob->IText.IText = &ob->text[1]; // (ob->text[0] is used for storing the trunc char)
	ob->IText.NextText = NULL;

	ResizeOutputBox(ob, x, y, width, FALSE);

   ob->next = Gui.FirstOutputBox;
   if (Gui.FirstOutputBox)
      Gui.FirstOutputBox->previous = ob;
   Gui.FirstOutputBox = ob;
	if (InitialValue)
		SetOutputBoxText(ob, InitialValue);
	else
		SetOutputBoxText(ob, "");
   Diagnostic("MakeOutputBox", EXIT, TRUE);
   return ob;
   }

int FOXLIB GetOutputBoxID(REGA0 OutputBox *o)
{
	return o->id;
}

OutputBox* FOXLIB SetPreText(REGA0 void *p, REGA1 char *t)
{
	return MakeOutputBox(p, 0, 0, 0, 0, 0, t, OB_PRE | NO_BORDER, NULL);
}

OutputBox* FOXLIB SetPostText(REGA0 void *p, REGA1 char *t)
{
	return MakeOutputBox(p, 0, 0, 0, 0, 0, t, OB_POST | NO_BORDER, NULL);
}
