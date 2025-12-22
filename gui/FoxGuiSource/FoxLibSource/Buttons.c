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
#include <ctype.h>
#include <string.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

#define GUIWIN(b) ((GuiWindow*)b->button.UserData)

static BOOL StatusStored = FALSE;

static PushButton *FindPreviousButton(PushButton **Bptr)
   {
   BOOL Found = FALSE;
   PushButton *p = Gui.GGLfirst, *pp = NULL;
   Diagnostic("FindPreviousButton", ENTER, TRUE);
   while(p)
      {
      if (p == *Bptr)
         {
         Found = TRUE;
         break;
         }
      else
         {
         pp = p;
         p = p->Next;
         }
      }
   if (!Found)
      {
      *Bptr = p = pp = NULL;
      Diagnostic("FindPreviousButton", EXIT, FALSE);
      }
   else
      Diagnostic("FindPreviousButton", EXIT, TRUE);
   return pp;
   }

void DisableButton(PushButton *Bptr)
   {
   Diagnostic("DisableButton", ENTER, TRUE);
	if (Bptr && Bptr->Active && !Bptr->WidgetData->ParentControl) // Don't disable the button if it's part of another control.
		{
		GuiWindow *wptr = (GuiWindow *) Bptr->button.UserData;

		if (Bptr->hidden == 0)
			DisableGadget(&Bptr->button, wptr->Win, TRUE);
		else // The button is hidden
			Bptr->button.Flags |= GFLG_DISABLED;
	   Bptr->Active = FALSE;
	   Diagnostic("DisableButton", EXIT, TRUE);
		}
	else
	   Diagnostic("DisableButton", EXIT, FALSE);
   }

void DisableAllButtons(void)
   {
   PushButton *ggl = Gui.GGLfirst;
   Diagnostic("DisableAllButtons", ENTER, TRUE);
   while (ggl)
      {
      DisableButton(ggl);
      ggl = ggl->Next;
      }
   Diagnostic("DisableAllButtons", EXIT, TRUE);
   }

void DisableWinButtons(GuiWindow *w)
   {
   PushButton *g = Gui.GGLfirst;
   Diagnostic("DisableWinButtons", ENTER, TRUE);
   while (g)
  	   {
     	if (g->button.UserData == (APTR) w)
        	DisableButton(g);
      g = g->Next;
  	   }
   Diagnostic("DisableWinButtons", EXIT, TRUE);
   }

void EnableButton(PushButton *Bptr)
   {
   Diagnostic("EnableButton", ENTER, TRUE);
	if (Bptr && (!Bptr->Active) && !Bptr->WidgetData->ParentControl) // Don't enable the button if it's part of another control.
		{
		/* Only the border will be refreshed, leaving the rest of the button still looking shaded and
			disabled.  Clear it here before refreshing. */
		if (Bptr->hidden == 0)
			{
			GuiWindow *wptr = (GuiWindow *) Bptr->button.UserData;

			AreaColFill(wptr->Win->RPort, Bptr->button.LeftEdge, Bptr->button.TopEdge, Bptr->button.Width,
					Bptr->button.Height, GetBackCol(Bptr->WidgetData->Parent));
			EnableGadget(&(Bptr->button), wptr->Win, TRUE);
			}
		else // The button is hidden
			Bptr->button.Flags ^= GFLG_DISABLED;
	   Bptr->Active = TRUE;
	   Diagnostic("EnableButton", EXIT, TRUE);
		}
	else
		Diagnostic("EnableButton", EXIT, FALSE);
   }

void EnableAllButtons(void)
   {
   PushButton *ggl = Gui.GGLfirst;
   Diagnostic("EnableAllButtons", ENTER, TRUE);
   while (ggl)
      {
      EnableButton(ggl);
      ggl = ggl->Next;
      }
   Diagnostic("EnableAllButtons", EXIT, TRUE);
   }

void EnableWinButtons(GuiWindow *w)
   {
   PushButton *g = Gui.GGLfirst;
   Diagnostic("EnableWinButtons", ENTER, TRUE);
   while (g)
  	   {
      if (g->button.UserData == (APTR) w)
     	   EnableButton(g);
  	   g = g->Next;
      }
   Diagnostic("EnableWinButtons", EXIT, TRUE);
   }

static void UndrawButton(PushButton *Bptr)
	{
	AreaColFill(((GuiWindow *)Bptr->button.UserData)->Win->RPort, Bptr->button.LeftEdge,
			Bptr->button.TopEdge, Bptr->button.Width, Bptr->button.Height, GetBackCol(Bptr->WidgetData->Parent));
	}

BOOL ShowButton(PushButton *Bptr)
	{
	Diagnostic("ShowButton", ENTER, TRUE);
	if (Bptr)
		{
		BOOL InFrame = !ISGUIWINDOW(Bptr->WidgetData->Parent);
		GuiWindow *Wptr = (GuiWindow *) Bptr->button.UserData;

		if (Bptr->hidden == 1) // The button is really hidden
			if (InFrame && ((Frame *) Bptr->WidgetData->Parent)->hidden != 0)
				Bptr->hidden = -1; // The button is in a hidden frame so it remains hidden
			else
				{
				Bptr->hidden = 0;
				AddGadget(Wptr->Win, &Bptr->button, -1);
				}
		if (Bptr->hidden == 0)
			{
			GuiBitMap *gbm = Bptr->bitmap;

			if (!(Bptr->WidgetData->flags & BN_CLEAR))
				AreaColFill(Wptr->Win->RPort, Bptr->button.LeftEdge, Bptr->button.TopEdge,
						Bptr->button.Width, Bptr->button.Height, Bptr->light.BackPen);
			RefreshGList(&Bptr->button, Wptr->Win, NULL, 1);
			while (gbm)
				{
				// Refresh the bitmap instance
				gbm->bmi = ShowBitMap(gbm, Wptr, Bptr->button.LeftEdge + 1, Bptr->button.TopEdge + 1,
						gbm->flags);
				gbm = gbm->next;
				}
			WaitBlit();
			}
		return Diagnostic("ShowButton", EXIT, TRUE);
		}
	return Diagnostic("ShowButton", EXIT, FALSE);
	}

BOOL HideButton(PushButton *Bptr)
	{
	Diagnostic("HideButton", ENTER, TRUE);
	if (Bptr)
		{
		if (Bptr->hidden == 0)
			{
			GuiBitMap *gbm = Bptr->bitmap;

			RemoveGadget(((GuiWindow *) Bptr->button.UserData)->Win, &(Bptr->button));
			while (gbm)
				{
				if (gbm->bmi)
					{
					GuiFree(gbm->bmi);
					gbm->bmi = NULL;
					}
				gbm = gbm->next;
				}
			UndrawButton(Bptr);
			}
		Bptr->hidden = 1;
		return Diagnostic("HideButton", EXIT, TRUE);
		}
	return Diagnostic("HideButton", EXIT, FALSE);
	}

void DestroyButton(PushButton *Bptr, BOOL refresh)
   {
   PushButton *pp, *cBptr = Bptr;
   Diagnostic("DestroyButton", ENTER, TRUE);
   pp = FindPreviousButton(&cBptr);
   if (Bptr)
      {
		Frame *Child; // Could be any type of widget

		if (!Bptr->WidgetData->ParentControl) // Don't destroy the button if it's part of another control.
			{
			GuiBitMap *gbm = Bptr->bitmap;

			if (Bptr->hidden == 0)
				RemoveGadget(((GuiWindow *) Bptr->button.UserData)->Win, &(Bptr->button));
   	   if (Bptr == Gui.GGLfirst)
      	   Gui.GGLfirst = Bptr->Next;
	      else
   	      pp->Next = Bptr->Next;
			if (Bptr->ULfont)
				{
				GuiFree(Bptr->ULfont->ta_Name);
				GuiFree(Bptr->ULfont);
				}
			if (Bptr->text1.ITextFont)
				{
				GuiFree(Bptr->text1.ITextFont->ta_Name);
				GuiFree(Bptr->text1.ITextFont);
				}
			if (Bptr->t1)
				GuiFree(Bptr->t1);
			if (Bptr->t3)
				GuiFree(Bptr->t3);
			if (Bptr->WidgetData->os)
				GuiFree(Bptr->WidgetData->os);
			if (Bptr->cbCopy)
				GuiFree(Bptr->cbCopy);
			while (gbm)
				{
				GuiBitMap *ngbm = gbm->next;
				if (gbm->bmi)
					if (refresh)
						HideBitMap(gbm->bmi);
					else
						GuiFree(gbm->bmi);
				if (gbm->obm)
					FreeGuiBitMap(gbm->obm);
				FreeGuiBitMap(gbm);
				gbm = ngbm;
				}
			Child = Bptr->WidgetData->ChildWidget;
			while (Child)
				{
				void *next = Child->WidgetData->NextWidget;
				Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
				Destroy(Child, refresh);
				Child = next;
				}
			if (refresh && Bptr->hidden == 0)
				UndrawButton(Bptr);
	      GuiFree(Bptr->WidgetData);
	      GuiFree(Bptr);
   	   }
		}
   else
      {
      SetLastErr("Attempt to destroy a non-existing button.");
      Diagnostic("DestroyButton", EXIT, FALSE);
      return;
      }
   Diagnostic("DestroyButton", EXIT, TRUE);
   }

void DestroyAllButtons(BOOL refresh)
   {
   PushButton *g = Gui.GGLfirst, *next = NULL;
   Diagnostic("DestroyAllButtons", ENTER, TRUE);
   while (g)
      {
		next = g->Next;
      DestroyButton(g, refresh);
      g = next;
      }
   Diagnostic("DestroyAllButtons", EXIT, TRUE);
   }

void DestroyWinButtons(GuiWindow *w, BOOL refresh)
   {
   PushButton *g = Gui.GGLfirst, *next = NULL;
   BOOL message = FALSE;
   Diagnostic("DestroyWinButtons", ENTER, TRUE);
   while (g)
      {
		next = g->Next;
      if (g->button.UserData == (APTR) w)
         {
         DestroyButton(g, refresh);
         message = TRUE;
         }
		g = next;
      }
   if (Gui.CleanupFlag && message)
      SetLastErr("Window closed before all of its buttons were destroyed.");
   Diagnostic("DestroyWinButtons", EXIT, TRUE);
   }

void ResizeButton(PushButton *Bptr, int x, int y, int width, int height, BOOL eraseold)
	{
	int len1 = 0, len2, len3 = 0, MaxLen;

	/*	If the button is in a coloured frame then no need to blank it because the parent frame will
		blank it's entire contents. */
	if (eraseold && GetBackCol(Bptr->WidgetData->Parent) == GUIWIN(Bptr)->Win->RPort->BgPen)
		UndrawButton(Bptr);

	// The button size is dependant on the caption and the font.  Since the caption and font are not changing, nor is the size!
	if (Bptr->WidgetData->flags & S_FONT_SENSITIVE)
		{
		width = Bptr->button.Width;
		height = Bptr->button.Height;
		}

	Bptr->button.LeftEdge = x;
	Bptr->button.Width = width;
	Bptr->button.TopEdge = y;
	Bptr->button.Height = height;

	/* Outer border (two structures) */
	/* White */
	Bptr->points[0] = Bptr->points[2] = Bptr->points[3] = Bptr->points[5] = 0;
	Bptr->points[1] = height - 1;
	Bptr->points[4] = width - 2;
	/* Black */
	Bptr->points[6] = 1;
	Bptr->points[11] = 0;
	Bptr->points[7] = Bptr->points[9] = height - 1;
	Bptr->points[8] = Bptr->points[10] = width - 1;

	Bptr->text1.TopEdge = ((height - ((GuiWindow *)Bptr->button.UserData)->Win->RPort->TxHeight) / 2) + 1;
	Bptr->text2.TopEdge = Bptr->text3.TopEdge = Bptr->text1.TopEdge;

	MaxLen = width - 2;

	if (Bptr->t1)
		{
		UnTruncateIText(&Bptr->text1, Bptr->t1);
		len1 = IntuiTextLength(&Bptr->text1);

		if (Bptr->t2[0])
			Bptr->text1.NextText = &Bptr->text2; // Reset incase text2 has previously been truncated off.
		}
	len2 = (Bptr->t2[0] ? IntuiTextLength(&(Bptr->text2)) : 0);
	if (Bptr->t3)
		{
		UnTruncateIText(&Bptr->text3, Bptr->t3);
		len3 = IntuiTextLength(&Bptr->text3);
		}

	if (len3)
		{
		TruncateIText(&Bptr->text3, Bptr->t3, MaxLen - len2 - len1, JUSTIFY_LEFT);
		len3 = IntuiTextLength(&Bptr->text3);
		}
	if (len2)
		if (len1 + len2 > MaxLen)
			{
			Bptr->text1.NextText = NULL;
			len2 = 0;
			}
	if (len1)
		{
		TruncateIText(&Bptr->text1, Bptr->t1, MaxLen, JUSTIFY_LEFT);
		len1 = IntuiTextLength(&Bptr->text1);
		}

	Bptr->text1.LeftEdge  = (width - (len1 + len2 + len3)) / 2;
	Bptr->text2.LeftEdge = Bptr->text1.LeftEdge + len1;
	Bptr->text3.LeftEdge = Bptr->text2.LeftEdge + len2;

	Bptr->WidgetData->left = x;
	Bptr->WidgetData->top = y;
	Bptr->WidgetData->width = width;
	Bptr->WidgetData->height = height;
	}

EXTC PushButton* FOXLIB MakeButton(REGA0 void *Parent, REGA1 char *name, REGD0 int left, REGD1 int top, REGD2 int
   width, REGD3 int height, REGD4 int key, REGA2 struct Border *cb, REGA3 int
   (* __far __stdargs callfn) (PushButton*), REGD5 short flags, REGD6 void *extension)
   {
	GuiWindow *Wptr;
	int realleft, realtop;
   PushButton *Bptr;
	Frame *ParentFrame = NULL;

   Diagnostic("MakeButton", ENTER, TRUE);

	if (!Parent)
		{
		Diagnostic("MakeButton", EXIT, FALSE);
		return NULL;
		}
   if ((Bptr = (PushButton *) GuiMalloc(sizeof(PushButton), 0)) == NULL)
		{
		Diagnostic("MakeButton", EXIT, FALSE);
		return NULL;
		}
   if ((Bptr->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)) == NULL)
		{
		GuiFree(Bptr);
		Diagnostic("MakeButton", EXIT, FALSE);
		return NULL;
		}
	if (cb)
		{
		int l;
		if ((Bptr->cbCopy = (short *) GuiMalloc(cb->Count * 2 * sizeof(short), 0)) == NULL)
			{
			GuiFree(Bptr->WidgetData);
			GuiFree(Bptr);
			Diagnostic("MakeButton", EXIT, FALSE);
			return NULL;
			}
		for (l = 0; l < 2 * cb->Count; l++)
			Bptr->cbCopy[l] = cb->XY[l];
		}
	else
		Bptr->cbCopy = NULL;

	if (flags & S_FONT_SENSITIVE)
		{
		width = GuiTextLength(name, &GuiFont) - (strchr(name, '_') ? GuiTextLength("_", &GuiFont) : 0) + 8;
		height = GuiFont.ta_YSize + 8;
		}

	if (!ISGUIWINDOW(Parent))
		{
		ParentFrame = (Frame *) Parent;
		realleft = left + ParentFrame->button.LeftEdge;
		if (left < 0)
			realleft += ParentFrame->points[8] + 1;
		realtop = top + ParentFrame->button.TopEdge;
		if (top < 0)
			realtop += ParentFrame->points[1] + 1;
		Wptr = (GuiWindow *) ParentFrame->button.UserData;
		}
	else
		{
		Wptr = (GuiWindow *) Parent;
		realleft = (left < 0 ? Wptr->Win->Width + left : left);
		realtop = (top < 0 ? Wptr->Win->Height + top : top);
		}

	Bptr->WidgetData->ObjectType = ButtonObject;
	Bptr->WidgetData->Parent = Parent;
	Bptr->WidgetData->NextWidget = NULL;
	Bptr->WidgetData->ChildWidget = NULL;

	if (flags & SYS_BN_HIDDEN)
		{
		Bptr->hidden = 1;
		flags &= ~SYS_BN_HIDDEN;
		}
	else if (ParentFrame && ParentFrame->hidden != 0)
		Bptr->hidden = -1;
	else
		Bptr->hidden = 0;
	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	if (flags & S_AUTO_SIZE)
		{
		if (!(Bptr->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
			if (Bptr->cbCopy)
				GuiFree(Bptr->cbCopy);
			GuiFree(Bptr->WidgetData);
			GuiFree(Bptr);
	      Diagnostic("MakeButton", EXIT, FALSE);
   	   return NULL;
      	}
		Bptr->WidgetData->os->left = realleft;
		Bptr->WidgetData->os->top = realtop;
		Bptr->WidgetData->os->width = width;
		Bptr->WidgetData->os->height = height;
		}
	else
		Bptr->WidgetData->os = NULL;

	Bptr->WidgetData->flags = flags;
	Bptr->t2[0] = Bptr->t2[1] = 0;
	Bptr->t1 = Bptr->t3 = NULL;
	Bptr->ULfont = CopyFont(&GuiULFont);

	if (name && strlen(name))
		{
		char *us = strchr(name, '_');
		if (us && us[1] == 0) // If the user is stupid enough to pass _ as the last character then ignore it.
			us = NULL;
		if (us)
			// Replace the underscore (us) with NULL to find the length of the first string.
			*us = 0;

		if (us != name) // If the underscore is not the first character
			if (Bptr->t1 = (char *) GuiMalloc((strlen(name) + 2) * sizeof(char), 0))
				{
				Bptr->t1[0] = 0;
				strcpy(&Bptr->t1[1], name);
				}
			else
				{
				if (us)
					*us = '_';
				GuiFree(Bptr->WidgetData->os);
				if (Bptr->cbCopy)
					GuiFree(Bptr->cbCopy);
				GuiFree(Bptr->WidgetData);
	  	   	GuiFree(Bptr);
		     	Diagnostic("MakeButton", EXIT, FALSE);
   		   return NULL;
				}

		if (us)
			{
			*us = '_';
			Bptr->t2[0] = us[1];
			if (us[2])
				{
				if (Bptr->t3 = (char *) GuiMalloc((strlen(&us[2]) + 2) * sizeof(char), 0))
					{
					Bptr->t3[0] = 0;
					strcpy(&Bptr->t3[1], &us[2]);
					}
				else
					{
					if (Bptr->t1)
						GuiFree(Bptr->t1);
	   		   GuiFree(Bptr->WidgetData->os);
					if (Bptr->cbCopy)
						GuiFree(Bptr->cbCopy);
					GuiFree(Bptr->WidgetData);
	   		   GuiFree(Bptr);
   	   		Diagnostic("MakeButton", EXIT, FALSE);
			      return NULL;
					}
				}
			}
		}

	Bptr->light.Count = Bptr->dark.Count = Bptr->sdark.Count = Bptr->slight.Count = 3;
	Bptr->dark.XY = Bptr->sdark.XY = &(Bptr->points[6]);
	Bptr->light.XY = Bptr->slight.XY = Bptr->points;
   Bptr->light.LeftEdge   = Bptr->light.TopEdge = 0;
   Bptr->light.NextBorder = &(Bptr->dark);
   Bptr->light.FrontPen   = Gui.HiPen;
	Bptr->light.BackPen    = Gui.BackCol; // Ignored by intuition - just used for storage.
   Bptr->light.DrawMode   = JAM1;
   Bptr->dark.LeftEdge    = Bptr->dark.TopEdge = 0;
   Bptr->dark.NextBorder  = cb;
   Bptr->dark.FrontPen    = Gui.LoPen;
   Bptr->dark.DrawMode    = JAM1;

   Bptr->slight.LeftEdge   = Bptr->slight.TopEdge = 0;
   Bptr->slight.NextBorder = &(Bptr->sdark);
	Bptr->slight.FrontPen   = Gui.LoPen;
   Bptr->slight.DrawMode   = JAM1;
   Bptr->sdark.LeftEdge    = Bptr->sdark.TopEdge = 0;
   Bptr->sdark.NextBorder  = cb;
   Bptr->sdark.FrontPen    = Gui.HiPen;
   Bptr->sdark.DrawMode    = JAM1;

   Bptr->button.NextGadget = NULL;
	Bptr->button.Flags      = GFLG_GADGHIMAGE;
   Bptr->button.Activation = RELVERIFY;
	if (flags & BN_AR)
      Bptr->button.Activation |= GADGIMMEDIATE;
   Bptr->button.GadgetType   = BOOLGADGET;
   Bptr->button.GadgetRender = (APTR) &(Bptr->light);
	Bptr->button.SelectRender = (APTR) &(Bptr->slight);
	if (name && strlen(name))
		{
		Bptr->button.GadgetText = (Bptr->t1 ? &(Bptr->text1) : &(Bptr->text2));
		/*	The Parent screen's font is the font that would be used by default if we set this to NULL but
			then IntuiTextLength might return incorrect values because it doesn't know which screen we're
			going to draw the text in!  To be on the safe side, set this explicitly. */
		Bptr->text1.ITextFont = CopyFont(&GuiFont);
		Bptr->text3.ITextFont = Bptr->text1.ITextFont;
		if (Bptr->t2[0])
			{
#ifdef OLD
			Bptr->text2.ITextFont = NULL;
			if (Wptr->WidgetData->Parent->Font == &GuiFont)
#endif
				Bptr->text2.ITextFont = Bptr->ULfont;
#ifdef OLD
			else
				{
				/*	Just because it's not pointing to GuiFont, doesn't mean it's not the same font!  Let's
					check. */
				if (Wptr->WidgetData->Parent->Font)
					if (Wptr->WidgetData->Parent->Font->ta_YSize == GuiFont.ta_YSize &&
							Wptr->WidgetData->Parent->Font->ta_Style == GuiFont.ta_Style &&
							Wptr->WidgetData->Parent->Font->ta_Flags == GuiFont.ta_Flags &&
							strcmp(Wptr->WidgetData->Parent->Font->ta_Name, GuiFont.ta_Name) == 0)
						// It's the same font!
						Bptr->text2.ITextFont = &GuiULFont;
				if (Wptr->WidgetData->Parent->Font && !Bptr->text2.ITextFont)
					// Make a copy of the font and add underline
					if (Bptr->ULfont = (struct TextAttr *) GuiMalloc(sizeof(struct TextAttr), 0))
						{
						memcpy(Bptr->ULfont, Wptr->WidgetData->Parent->Font, sizeof(struct TextAttr));
						/*	Now allocate and copy the name seperately because if we just point to the name
							in the screen font, we might lose it if the user changes it! */
						if (Bptr->ULfont->ta_Name = (char*) GuiMalloc((strlen(Wptr->WidgetData->Parent->Font->ta_Name) + 1) *
								sizeof(char), 0))
							{
							strcpy(Bptr->ULfont->ta_Name, Wptr->WidgetData->Parent->Font->ta_Name);
							Bptr->ULfont->ta_Style |= FSF_UNDERLINED;
							Bptr->text2.ITextFont = Bptr->ULfont;
							}
						else
							{
							GuiFree(Bptr->ULfont);
							Bptr->ULfont = NULL;
							}
						}
				if (!Bptr->text2.ITextFont)
					// Well, it's not right but we have to use a font so we'd best use this one.
					{
					Bptr->text2.ITextFont = &GuiULFont;
					SetLastErr("Failed to find correct underlined font.  Default used.");
					}
				}
#endif
			}
   	Bptr->text1.FrontPen  = Bptr->text2.FrontPen = Bptr->text3.FrontPen = Gui.TextCol;
	   Bptr->text1.DrawMode  = Bptr->text2.DrawMode = Bptr->text3.DrawMode = JAM1;
   	Bptr->text1.IText = Bptr->t1 ? &Bptr->t1[1] : NULL;
	   Bptr->text2.IText = Bptr->t2;
   	Bptr->text3.IText = Bptr->t3 ? &Bptr->t3[1] : NULL;
	   Bptr->text1.NextText = (Bptr->t2[0] ? &(Bptr->text2) : NULL);
   	Bptr->text2.NextText = (Bptr->t3 ? &(Bptr->text3) : NULL);
	   Bptr->text3.NextText = NULL;
		}
	else
		{
		Bptr->button.GadgetText = NULL;
		Bptr->text1.ITextFont = NULL;
		}
   Bptr->button.GadgetID = 0;
   Bptr->button.UserData = (APTR) Wptr;

	// Set the width and height before calling resize because if the button is font sensitive, resize won't change teh width and height.
	Bptr->button.Width = width;
	Bptr->button.Height = height;
	ResizeButton(Bptr, realleft, realtop, width, height, FALSE);

   Bptr->Callfn = callfn;
   Bptr->Active = Bptr->OldStatus = TRUE;
   Bptr->Key1 = key;
   if (isupper(key))
      Bptr->Key2 = tolower(key);
   else if (islower(key))
      Bptr->Key2 = toupper(key);
   else
      {
      switch (key)
         {
         case  ',' : Bptr->Key2 =  '<'; break;
         case  '<' : Bptr->Key2 =  ','; break;
         case  '.' : Bptr->Key2 =  '>'; break;
         case  '>' : Bptr->Key2 =  '.'; break;
         case  '/' : Bptr->Key2 =  '?'; break;
         case  '?' : Bptr->Key2 =  '/'; break;
         case  ';' : Bptr->Key2 =  ':'; break;
         case  ':' : Bptr->Key2 =  ';'; break;
         case  '@' : Bptr->Key2 =  '#'; break;
         case  '#' : Bptr->Key2 =  '@'; break;
         case  '[' : Bptr->Key2 =  '{'; break;
         case  '{' : Bptr->Key2 =  '['; break;
         case  '}' : Bptr->Key2 =  ']'; break;
         case  ']' : Bptr->Key2 =  '}'; break;
         case '\\' : Bptr->Key2 =  '|'; break;
         case  '|' : Bptr->Key2 = '\\'; break;
         case  '=' : Bptr->Key2 =  '+'; break;
         case  '+' : Bptr->Key2 =  '='; break;
         case  '_' : Bptr->Key2 =  '-'; break;
         case  '-' : Bptr->Key2 =  '_'; break;
         case  '1' : Bptr->Key2 =  '!'; break;
         case  '!' : Bptr->Key2 =  '1'; break;
         case '\"' : Bptr->Key2 =  '2'; break;
         case  '2' : Bptr->Key2 = '\"'; break;
         case  '3' : Bptr->Key2 =  '£'; break;
         case  '£' : Bptr->Key2 =  '3'; break;
         case  '$' : Bptr->Key2 =  '4'; break;
         case  '4' : Bptr->Key2 =  '$'; break;
         case  '5' : Bptr->Key2 =  '%'; break;
         case  '%' : Bptr->Key2 =  '5'; break;
         case  '^' : Bptr->Key2 =  '6'; break;
         case  '6' : Bptr->Key2 =  '^'; break;
         case  '7' : Bptr->Key2 =  '&'; break;
         case  '&' : Bptr->Key2 =  '7'; break;
         case  '*' : Bptr->Key2 =  '8'; break;
         case  '8' : Bptr->Key2 =  '*'; break;
         case  '9' : Bptr->Key2 =  '('; break;
         case  '(' : Bptr->Key2 =  '9'; break;
         case  ')' : Bptr->Key2 =  '0'; break;
         case  '0' : Bptr->Key2 =  ')'; break;
         case '\'' : Bptr->Key2 =  '~'; break;
         case  '~' : Bptr->Key2 = '\''; break;
         default   : Bptr->Key2 =    0; break;
         }
      }
	Bptr->WidgetData->ParentControl = NULL;
	Bptr->Filefn = NULL;
	Bptr->bitmap = NULL;
   Bptr->Next = Gui.GGLfirst;
   Gui.GGLfirst = Bptr;
	if (Bptr->hidden == 0)
		{
		if (!(flags & BN_CLEAR))
			AreaColFill(Wptr->Win->RPort, realleft, realtop, width, height, Gui.BackCol);
		AddGadget(Wptr->Win, &(Bptr->button), -1);
		RefreshGadgets(&(Bptr->button), Wptr->Win, NULL);
		}
   Diagnostic("MakeButton", EXIT, TRUE);
   return Bptr;
   }

PushButton *MakeFileButton(GuiWindow *Wptr, char *name, int left, int top, int width, int height, int key, struct Border *cb, int (*callfn) (char*, char*))
	{
	PushButton *FileButton = MakeButton(Wptr, name, left, top, width, height, key, cb, NULL, BN_CLEAR | BN_STD | S_AUTO_SIZE, NULL);
	if (!FileButton)
		return NULL;
	FileButton->Filefn = callfn;
	return FileButton;
	}

typedef enum {SHOW, HIDE, DESTROY} Action;

static void EveryControl(Frame *f, Action action, BOOL refresh)
	{
	EditBox *e = Gui.FirstEditBox, *en;
	OutputBox *o = Gui.FirstOutputBox, *on;
	ListBox *l = Gui.FirstListBox, *ln;
	PushButton *b = Gui.GGLfirst, *bn;
	ProgressBar *p = Gui.FirstProgressBar, *pn;
	TickBox *t = Gui.FirstTickBox, *tn;
	RadioButton *r = Gui.FirstRadioButton, *rn;
	Frame *fr = Gui.FirstFrame, *fn;

	Diagnostic("EveryControl", ENTER, TRUE);

	while (e)
		{
		en = e->next;
		if ((Frame *) e->WidgetData->Parent == f)
			if (e->list)
				{
				if (action == DESTROY)
					{
					/*	Destroying a drop-down list box may cause child dd list boxes to be destroyed so
						after calling DestroyDDListBox() we can't guarantee that en is still valid. */
					DestroyDDListBox(e, refresh);
					en = Gui.FirstEditBox;
					}
				else if (action == SHOW && e->hidden == -1)
					{
					e->hidden = 1; // Pretend it's really hidden so that the Show function will work
					ShowDDListBox(e);
					}
				else if (action == HIDE && e->hidden == 0)
					{
					HideDDListBox(e);
					e->hidden = -1;
					}
				}
			else
				{
				if (action == DESTROY)
					DestroyEditBox(e, refresh);
				else if (action == SHOW && e->hidden == -1)
					{
					e->hidden = 1; // Pretend it's really hidden so that the Show function will work
					ShowEditBox(e);
					}
				else if (action == HIDE && e->hidden == 0)
					{
					HideEditBox(e);
					e->hidden = -1;
					}
				}
		e = en;
		}
	while (o)
		{
		on = o->next;
		if ((Frame *) o->WidgetData->Parent == f)
			{
			if (action == DESTROY)
				DestroyOutputBox(o, refresh);
			else if (action == SHOW && o->hidden == -1)
				{
				o->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowOutputBox(o);
				}
			else if (action == HIDE && o->hidden == 0)
				{
				HideOutputBox(o);
				o->hidden = -1;
				}
			}
		o = on;
		}
	while (l)
		{
		ln = l->NextListBox;
		if ((Frame *) l->WidgetData->Parent == f)
			{
			if (action == DESTROY)
				DestroyListBox(l, refresh);
			else if (action == SHOW && l->hidden == -1)
				{
				l->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowListBox(l);
				}
			else if (action == HIDE && l->hidden == 0)
				{
				HideListBox(l);
				l->hidden = -1;
				}
			}
		l = ln;
		}
	while (p)
		{
		pn = p->Next;
		if ((Frame *) p->WidgetData->Parent == f)
			{
			if (action == DESTROY)
				DestroyProgressBar(p, refresh);
			else if (action == SHOW && p->hidden == -1)
				{
				p->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowProgressBar(p);
				}
			else if (action == HIDE && p->hidden == 0)
				{
				HideProgressBar(p);
				p->hidden = -1;
				}
			}
		p = pn;
		}
	while (t)
		{
		tn = t->Next;
		if ((Frame *) t->WidgetData->Parent == f)
			{
			if (action == DESTROY)
				DestroyTickBox(t, refresh);
			else if (action == SHOW && t->hidden == -1)
				{
				t->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowTickBox(t);
				}
			else if (action == HIDE && t->hidden == 0)
				{
				HideTickBox(t);
				t->hidden = -1;
				}
			}
		t = tn;
		}
	while (r)
		{
		rn = r->Next;
		if ((Frame *) r->WidgetData->Parent == f)
			{
			if (action == DESTROY)
				DestroyRadioButton(r, refresh);
			else if (action == SHOW && r->hidden == -1)
				{
				r->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowRadioButton(r);
				}
			else if (action == HIDE && r->hidden == 0)
				{
				HideRadioButton(r);
				r->hidden = -1;
				}
			}
		r = rn;
		}
	while (b)
		{
		bn = b->Next;
		if ((Frame *) b->WidgetData->Parent == f)
			{
			if (action == DESTROY)
				DestroyButton(b, refresh);
			else if (action == SHOW && b->hidden == -1)
				{
				b->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowButton(b);
				}
			else if (action == HIDE && b->hidden == 0)
				{
				HideButton(b);
				b->hidden = -1;
				}
			}
		b = bn;
		}
	while (fr)
		{
		fn = fr->next;
		if ((Frame *) fr->WidgetData->Parent == f)
			{
			// Recursion here we come!
			if (action == DESTROY)
				{
				/* Destroying a frame will cause any frames within it to be destroyed so, after destroying
					a frame, we can't guarantee that fn is still valid. */
				DestroyFrame(fr, refresh);
				fn = Gui.FirstFrame;
				}
			else if (action == SHOW && fr->hidden == -1)
				{
				fr->hidden = 1; // Pretend it's really hidden so that the Show function will work
				ShowFrame(fr);
				}
			else if (action == HIDE && fr->hidden == 0)
				{
				HideFrame(fr);
				fr->hidden = -1;
				}
			}
		fr = fn;
		}
	Diagnostic("EveryControl", EXIT, TRUE);
	}

static Frame *FindPreviousFrame(Frame **Fptr)
   {
   BOOL Found = FALSE;
   Frame *p = Gui.FirstFrame, *pp = NULL;
   Diagnostic("FindPreviousFrame", ENTER, TRUE);
   while(p)
      {
      if (p == *Fptr)
         {
         Found = TRUE;
         break;
         }
      else
         {
         pp = p;
         p = p->next;
         }
      }
   if (!Found)
      {
      *Fptr = p = pp = NULL;
      Diagnostic("FindPreviousFrame", EXIT, FALSE);
      }
   else
      Diagnostic("FindPreviousFrame", EXIT, TRUE);
   return pp;
   }

BOOL ShowFrame(Frame *Fptr)
	{
	if (!Fptr)
		return FALSE;
	else
		if (Fptr->hidden == 1) // The frame is really hidden
			if ((!ISGUIWINDOW(Fptr->WidgetData->Parent)) && ((Frame *) Fptr->WidgetData->Parent)->hidden != 0)
				Fptr->hidden = -1; // The frame is in a hidden frame so it will remain hidden
			else
				{
				GuiBitMap *gbm = Fptr->bitmap;

				// Refresh the background.
				if (!(Fptr->WidgetData->flags & FM_CLEAR))
					AreaColFill(((GuiWindow *) Fptr->button.UserData)->Win->RPort, Fptr->button.LeftEdge,
							Fptr->button.TopEdge, Fptr->points[8] + 1, Fptr->points[1] + 1, Fptr->light.BackPen);
				AddGadget(((GuiWindow *) Fptr->button.UserData)->Win, &(Fptr->button), -1);
				RefreshGadgets(&(Fptr->button), ((GuiWindow *) Fptr->button.UserData)->Win, NULL);
				while (gbm)
					{
					// Refresh the bitmap instance
					gbm->bmi = ShowBitMap(gbm, (GuiWindow *) Fptr->button.UserData, Fptr->button.LeftEdge + 1,
							Fptr->button.TopEdge + 1, gbm->flags);
					gbm = gbm->next;
					}
				WaitBlit();
				Fptr->hidden = 0;
				EveryControl(Fptr, SHOW, TRUE);
				}
	return TRUE;
	}

static void UndrawFrame(Frame *Fptr)
	{
	int width;

	if ((Fptr->WidgetData->flags & SYS_FM_ROUNDED) && Fptr->points[1] + 1 >= 6 && !(Fptr->WidgetData->flags & FM_BORDERLESS)) // Rounded corners
		width = Fptr->points[24];
	else
		width = Fptr->points[8];

	AreaColFill(((GuiWindow *) Fptr->button.UserData)->Win->RPort, Fptr->button.LeftEdge,
			Fptr->button.TopEdge, width + 1, Fptr->points[1] + 1, GetBackCol(Fptr->WidgetData->Parent));
	}

BOOL HideFrame(Frame *Fptr)
	{
	if (!Fptr)
		return FALSE;
	else
		{
		if (Fptr->hidden == 0)
			{
			GuiBitMap *gbm = Fptr->bitmap;

			RemoveGadget(((GuiWindow *) Fptr->button.UserData)->Win, &(Fptr->button));
			while (gbm)
				{
				if (gbm->bmi)
					{
					GuiFree(gbm->bmi);
					gbm->bmi = NULL;
					}
				gbm = gbm->next;
				}
			UndrawFrame(Fptr);
			EveryControl(Fptr, HIDE, TRUE);
			}
		Fptr->hidden = 1;
		}
	return TRUE;
	}

void DestroyFrame(Frame *Fptr, BOOL refresh)
   {
   Diagnostic("DestroyFrame", ENTER, TRUE);
   if (Fptr)
      {
		Frame *Child; // Could be any type of widget
		if (Fptr->WidgetData->ParentControl == NULL)
			{
			Frame *cFptr = Fptr, *pp = FindPreviousFrame(&cFptr);
			GuiBitMap *gbm = Fptr->bitmap;

			EveryControl(Fptr, DESTROY, refresh);
			if (Fptr->hidden == 0)
	   	   RemoveGadget(((GuiWindow *) Fptr->button.UserData)->Win, &(Fptr->button));
	  	   if (Fptr == Gui.FirstFrame)
   	  	   Gui.FirstFrame = Fptr->next;
      	else
  	      	pp->next = Fptr->next;
			if (Fptr->t)
				GuiFree(Fptr->t);
			while (gbm)
				{
				GuiBitMap *ngbm = gbm->next;
				if (gbm->bmi)
					if (refresh)
						HideBitMap(gbm->bmi);
					else
						GuiFree(gbm->bmi);
				if (gbm->obm)
					FreeGuiBitMap(gbm->obm);
				FreeGuiBitMap(gbm);
				gbm = ngbm;
				}
			if (refresh && Fptr->hidden == 0)
				UndrawFrame(Fptr);
			if (Fptr->WidgetData->os)
				GuiFree(Fptr->WidgetData->os);
			if (Fptr->cbCopy)
				GuiFree(Fptr->cbCopy);
			if (Fptr->text.ITextFont)
				{
				if (Fptr->text.ITextFont->ta_Name)
					GuiFree(Fptr->text.ITextFont->ta_Name);
				GuiFree(Fptr->text.ITextFont);
				}
			Child = Fptr->WidgetData->ChildWidget;
			while (Child)
				{
				void *next = Child->WidgetData->NextWidget;
				Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
				Destroy(Child, refresh);
				Child = next;
				}
      	GuiFree(Fptr->WidgetData);
      	GuiFree(Fptr);
			}
		}
   else
      {
      SetLastErr("Attempt to destroy a non-existing frame.");
      Diagnostic("DestroyFrame", EXIT, FALSE);
      return;
      }
   Diagnostic("DestroyFrame", EXIT, TRUE);
   }

void DestroyAllFrames(BOOL refresh)
   {
   Frame *g = Gui.FirstFrame;
   Diagnostic("DestroyAllFrames", ENTER, TRUE);
   while (g)
      {
		if (g->WidgetData->ParentControl == NULL)
			{
			DestroyFrame(g, refresh);
			/*	Destroying a frame will destroy any subframes inside it so it's not safe to assume that the
				next frame in the list still exists. */
			g = Gui.FirstFrame;
			}
		else
			g = g->next;
      }
   Diagnostic("DestroyAllFrames", EXIT, TRUE);
   }

void DestroyWinFrames(GuiWindow *w, BOOL refresh)
   {
   Frame *g = Gui.FirstFrame;
   BOOL message = FALSE;
   Diagnostic("DestroyWinFrames", ENTER, TRUE);
   while (g)
      {
      if (g->button.UserData == (APTR) w && g->WidgetData->ParentControl == NULL)
         {
         DestroyFrame(g, refresh);
         message = TRUE;
			/*	Destroying a frame will destroy any sub-frames inside it so it's not safe to just continue
				from the next frame here. */
			g = Gui.FirstFrame;
         }
		else
			g = g->next;
      }
   if (Gui.CleanupFlag && message)
      SetLastErr("Window closed before all of its frames were destroyed.");
   Diagnostic("DestroyWinFrames", EXIT, TRUE);
   }

void ResizeFrame(Frame *frame, int x, int y, int width, int height, BOOL eraseold)
	{
	BOOL rounded = ((frame->WidgetData->flags & SYS_FM_ROUNDED) && height >= 6 && !(frame->WidgetData->flags & FM_BORDERLESS));
	/*	If the frame is in a coloured frame then no need to blank it because the parent frame will
		blank it's entire contents. */
	if (eraseold && GetBackCol(frame->WidgetData->Parent) == GUIWIN(frame)->Win->RPort->BgPen)
		UndrawFrame(frame);

   /* Outer border (two structures) */
	if (rounded) // Rounded corners
		{
		/* White */
		frame->points[0] = frame->points[2] = frame->points[13] = frame->points[15] = 0;
		frame->points[1] = height - 1;
		frame->points[3] = frame->points[12] = 5;
		frame->points[4] = frame->points[6] = frame->points[9] = frame->points[11] = 1;
		frame->points[5] = frame->points[10] = 4;
		frame->points[7] = frame->points[8] = 3;
		frame->points[14] = width - 6;

		/* Black */
		frame->points[16] = width - 5;
		frame->points[17] = frame->points[19] = 1;
		frame->points[18] = width - 4;
		frame->points[20] = frame->points[22] = width - 2;
		frame->points[21] = 3;
		frame->points[23] = 4;
		frame->points[24] = frame->points[26] = width - 1;
		frame->points[25] = 5;
		frame->points[27] = height - 1;
		}
	else
		{
		/* White */
		frame->points[0] = frame->points[2] = frame->points[3] = frame->points[5] = 0;
		frame->points[1] = height - 1;
		frame->points[4] = width - 2;

		/* Black */
		frame->points[6] = 1;
		frame->points[7] = frame->points[9] = height - 1;
		frame->points[8] = frame->points[10] = width - 1;
		frame->points[11] = 0;
		}
	frame->light.Count = frame->WidgetData->flags & FM_BORDERLESS ? 0 : (rounded ? 8 : 3);
	frame->dark.Count = frame->WidgetData->flags & FM_BORDERLESS ? 0 : (rounded ? 6 : 3);
	frame->dark.XY = (rounded ? &(frame->points[16]) : &(frame->points[6]));

	frame->button.LeftEdge = x;
	frame->button.TopEdge  = y;
	if ((frame->WidgetData->flags & FM_LBUT) || (frame->WidgetData->flags & FM_RBUT) || (frame->WidgetData->flags & FM_DRAG))
		{
		frame->button.Width    = width;
		frame->button.Height   = height;
		}
	else
		{
		/* The frame is just being used as a holder for other controls so the gadget needs to be small
			and out of the way. */
		frame->button.Width    = 1;
		frame->button.Height   = 1;
		}

	if (frame->t)
		{
		TruncateIText(&frame->text, frame->t, width - 2, JUSTIFY_LEFT);
		frame->text.TopEdge  = ((height - ((GuiWindow *) frame->button.UserData)->Win->RPort->TxHeight) / 2) + 1;
		frame->text.LeftEdge = (width - IntuiTextLength(&(frame->text))) / 2;
		}
	frame->WidgetData->left = x;
	frame->WidgetData->top = y;
	frame->WidgetData->width = width;
	frame->WidgetData->height = height;
	}

void DisableFrame(Frame *Fptr)
   {
   Diagnostic("DisableFrame", ENTER, TRUE);
	if (Fptr && Fptr->Active && !Fptr->WidgetData->ParentControl) // Don't disable the frame if it's part of another control.
		{
		GuiWindow *wptr = (GuiWindow *) Fptr->button.UserData;

		if (Fptr->hidden == 0)
			DisableGadget(&Fptr->button, wptr->Win, TRUE);
		else // The button is hidden
			Fptr->button.Flags |= GFLG_DISABLED;
	   Fptr->Active = FALSE;
	   Diagnostic("DisableFrame", EXIT, TRUE);
		}
	else
	   Diagnostic("DisableFrame", EXIT, FALSE);
   }

void DisableAllFrames(void)
   {
   Frame *ggl = Gui.FirstFrame;
   Diagnostic("DisableAllFrames", ENTER, TRUE);
   while (ggl)
      {
      DisableFrame(ggl);
      ggl = ggl->next;
      }
   Diagnostic("DisableAllFrames", EXIT, TRUE);
   }

void DisableWinFrames(GuiWindow *w)
   {
   Frame *f = Gui.FirstFrame;
   Diagnostic("DisableWinFrames", ENTER, TRUE);
   while (f)
  	   {
     	if (f->button.UserData == (APTR) w)
        	DisableFrame(f);
      f = f->next;
  	   }
   Diagnostic("DisableWinFrames", EXIT, TRUE);
   }

void EnableFrame(Frame *Fptr)
   {
   Diagnostic("EnableFrame", ENTER, TRUE);
	if (Fptr && (!Fptr->Active) && !Fptr->WidgetData->ParentControl) // Don't enable the frame if it's part of another control.
		{
		/* Only the border will be refreshed, leaving the rest of the frame still looking shaded and
			disabled.  Clear it here before refreshing. */
		if (Fptr->hidden == 0)
			{
			GuiWindow *wptr = (GuiWindow *) Fptr->button.UserData;

			AreaColFill(wptr->Win->RPort, Fptr->button.LeftEdge, Fptr->button.TopEdge, Fptr->points[8] + 1,
					Fptr->points[1] + 1, GetBackCol(Fptr->WidgetData->Parent));
			EnableGadget(&(Fptr->button), wptr->Win, TRUE);
			}
		else // The button is hidden
			Fptr->button.Flags ^= GFLG_DISABLED;
	   Fptr->Active = TRUE;
	   Diagnostic("EnableFrame", EXIT, TRUE);
		}
	else
		Diagnostic("EnableFrame", EXIT, FALSE);
   }

void EnableAllFrames(void)
   {
   Frame *ggl = Gui.FirstFrame;
   Diagnostic("EnableAllFrames", ENTER, TRUE);
   while (ggl)
      {
      EnableFrame(ggl);
      ggl = ggl->next;
      }
   Diagnostic("EnableAllFrames", EXIT, TRUE);
   }

void EnableWinFrames(GuiWindow *w)
   {
   Frame *f = Gui.FirstFrame;
   Diagnostic("EnableWinFrames", ENTER, TRUE);
   while (f)
  	   {
      if (f->button.UserData == (APTR) w)
     	   EnableFrame(f);
  	   f = f->next;
      }
   Diagnostic("EnableWinFrames", EXIT, TRUE);
   }

void FOXLIB SetFrameDragPointer(REGA0 Frame *Fptr, REGA1 unsigned short *DragPointer, REGD0 int width, REGD1 int height, REGD2 int xoffset, REGD3 int yoffset)
{
	Fptr->DragPointer = DragPointer;
	Fptr->PointerWidth = width;
	Fptr->PointerHeight = height;
	Fptr->PointerXOffset = xoffset;
	Fptr->PointerYOffset = yoffset;
}

Frame* FOXLIB MakeFrame(REGA0 void *Parent, REGA1 char *name, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height, REGA2 struct Border *cb, REGA3 int (* __far __stdargs callfn) (Frame*, short, short, short, void**), REGD4 short flags, REGD5 void *extension)
   {
	Frame *Fptr;
	GuiWindow *Wptr;
	Frame *ParentFrame = NULL;
   Diagnostic("MakeFrame", ENTER, TRUE);

	if (!Parent)
		{
      Diagnostic("MakeFrame", EXIT, FALSE);
      return NULL;
		}
   if ((Fptr = (Frame *) GuiMalloc(sizeof(Frame), 0)) == NULL)
      {
      Diagnostic("MakeFrame", EXIT, FALSE);
      return NULL;
      }
   if ((Fptr->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)) == NULL)
      {
		GuiFree(Fptr);
      Diagnostic("MakeFrame", EXIT, FALSE);
      return NULL;
      }
	Fptr->DragPointer = NULL;
	if (cb)
		{
		int l;
		if ((Fptr->cbCopy = (short *) GuiMalloc(cb->Count * 2 * sizeof(short), 0)) == NULL)
			{
			GuiFree(Fptr->WidgetData);
			GuiFree(Fptr);
			Diagnostic("MakeFrame", EXIT, FALSE);
			return NULL;
			}
		for (l = 0; l < 2 * cb->Count; l++)
			Fptr->cbCopy[l] = cb->XY[l];
		}
	else
		Fptr->cbCopy = NULL;

	if (!ISGUIWINDOW(Parent))
		{
		ParentFrame = (Frame *) Parent;
		left += ParentFrame->button.LeftEdge;
		top += ParentFrame->button.TopEdge;
		Wptr = (GuiWindow *) ParentFrame->button.UserData;
		}
	else
		Wptr = (GuiWindow *) Parent;

	Fptr->WidgetData->ObjectType = FrameObject;
	if (ParentFrame && (flags & S_AUTO_SIZE) && !(ParentFrame->WidgetData->flags & S_AUTO_SIZE))
		flags ^= S_AUTO_SIZE;
	Fptr->WidgetData->flags = flags;
	if (ParentFrame && ParentFrame->hidden != 0)
		Fptr->hidden = -1;
	else
		Fptr->hidden = 0;
	Fptr->WidgetData->Parent = Parent;
	Fptr->WidgetData->ParentControl = NULL;
	Fptr->WidgetData->NextWidget = NULL;
	Fptr->WidgetData->ChildWidget = NULL;

	if (flags & S_AUTO_SIZE)
		{
		if (!(Fptr->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
			{
			if (Fptr->cbCopy)
				GuiFree(Fptr->cbCopy);
			GuiFree(Fptr->WidgetData);
			GuiFree(Fptr);
			Diagnostic("MakeFrame", EXIT, FALSE);
			return NULL;
			}
		Fptr->WidgetData->os->left = left;
		Fptr->WidgetData->os->top = top;
		Fptr->WidgetData->os->width = width;
		Fptr->WidgetData->os->height = height;
		}
	else
		Fptr->WidgetData->os = NULL;

	if (name && strlen(name))
		{
		if (!(Fptr->t = (char *) GuiMalloc((strlen(name) + 2) * sizeof(char), 0)))
			{
			if (Fptr->WidgetData->os)
				GuiFree(Fptr->WidgetData->os);
			if (Fptr->cbCopy)
				GuiFree(Fptr->cbCopy);
			GuiFree(Fptr->WidgetData);
			GuiFree(Fptr);
			Diagnostic("MakeFrame", EXIT, FALSE);
			return NULL;
			}
		Fptr->t[0] = 0;
		strcpy(&Fptr->t[1], name);
		Fptr->text.ITextFont = CopyFont(&GuiFont);
		Fptr->text.FrontPen  = Gui.TextCol;
		Fptr->text.DrawMode  = JAM1;
		Fptr->text.IText = &Fptr->t[1];
		Fptr->text.NextText = NULL;
		}
	else
		{
		Fptr->t = NULL;
		Fptr->text.ITextFont = NULL;
		}

   Fptr->light.LeftEdge   = Fptr->light.TopEdge = 0;
   Fptr->light.XY         = Fptr->points;
   Fptr->light.NextBorder = &(Fptr->dark);
   Fptr->light.FrontPen   = Gui.HiPen;
	Fptr->light.BackPen    = Gui.BackCol; // Ignored by Intuition - just for storage.
   Fptr->light.DrawMode   = JAM1;
   Fptr->dark.LeftEdge    = Fptr->dark.TopEdge = 0;
   Fptr->dark.NextBorder  = cb;
   Fptr->dark.FrontPen    = Gui.LoPen;
   Fptr->dark.DrawMode    = JAM1;

   Fptr->button.NextGadget   = NULL;
   Fptr->button.Flags        = GADGHNONE;
	Fptr->button.Activation   = 0;
	if (flags & FM_LBUT)
		Fptr->button.Activation	|= GACT_RELVERIFY;
   if (flags & FM_DRAG)
		Fptr->button.Activation |= GACT_IMMEDIATE | GACT_RELVERIFY | GACT_FOLLOWMOUSE;
   Fptr->button.GadgetType   = BOOLGADGET;
   Fptr->button.GadgetRender = (APTR) &(Fptr->light);
   Fptr->button.SelectRender = (APTR) NULL;
	Fptr->button.GadgetText   = Fptr->t ? &(Fptr->text) : NULL;
   Fptr->button.GadgetID     = 0;
   Fptr->button.UserData     = (APTR) Wptr;
   Fptr->Callfn = callfn;
   Fptr->Active = TRUE;
	Fptr->bitmap = NULL;

	ResizeFrame(Fptr, left, top, width, height, FALSE);

	/* The frame has to be added to the end of the list so that they are
		refreshed in the right order when a window is resized. */
	Fptr->next = NULL;
	if (!Gui.FirstFrame)
		Gui.FirstFrame = Fptr;
	else
		{
		Frame *f = Gui.FirstFrame;
		while (f->next)
			f = f->next;
		f->next = Fptr;
		}
	if (Fptr->hidden == 0)
		{
		if (!(flags & FM_CLEAR))
			AreaColFill(Wptr->Win->RPort, left, top, width, height, Gui.BackCol);
	   AddGadget(Wptr->Win, &(Fptr->button), -1);
		RefreshGadgets(&(Fptr->button), Wptr->Win, NULL);
		}
	Diagnostic("MakeFrame", EXIT, TRUE);
   return Fptr;
   }

void DisableTabControl(TabControl *tc)
	{
	Diagnostic("DisableTabControl", ENTER, TRUE);
	if (tc)
		{
		Tab *t = tc->FirstTab;

		while (t)
			{
			if (t->pb)
				{
				Widget *ParentControl = t->pb->WidgetData->ParentControl;
				// Pretend it's not part of another control or we can't disable it.
				t->pb->WidgetData->ParentControl = NULL;
				DisableFrame(t->pb);
				t->pb->WidgetData->ParentControl = ParentControl;
				}
			t = t->next;
			}
		}
	Diagnostic("DisableTabControl", EXIT, tc != NULL);
	}

void EnableTabControl(TabControl *tc)
	{
	Diagnostic("EnableTabControl", ENTER, TRUE);
	if (tc)
		{
		Tab *t = tc->FirstTab;

		while (t)
			{
			if (t->pb)
				{
				Widget *ParentControl = t->pb->WidgetData->ParentControl;
				// Pretend it's not part of another control or we can't enable it.
				t->pb->WidgetData->ParentControl = NULL;
				EnableFrame(t->pb);
				t->pb->WidgetData->ParentControl = ParentControl;
				}
			t = t->next;
			}
		}
	Diagnostic("EnableTabControl", EXIT, tc != NULL);
	}

BOOL HideTabControl(TabControl *tc)
	{
	Diagnostic("HideTabControl", ENTER, TRUE);
	if (tc)
		{
		Tab *t = tc->FirstTab;
		BOOL retval = TRUE;

		while (t)
			{
			if (t->pb)
				retval = retval && HideFrame(t->pb);
			if (t->frame)
				retval = retval && HideFrame(t->frame);
			t = t->next;
			}
		return retval;
		}
	else
		return FALSE;
	Diagnostic("HideTabControl", EXIT, tc != NULL);
	}

BOOL ShowTabControl(TabControl *tc)
	{
	Diagnostic("ShowTabControl", ENTER, TRUE);
	if (tc)
		{
		Tab *t = tc->FirstTab;
		BOOL retval = TRUE;

		while (t)
			{
			if (t->pb)
				retval = retval && ShowFrame(t->pb);
			if (t->frame && t == tc->SelectedTab) // Only show the frame for the selected button.
				retval = retval && ShowFrame(t->frame);
			t = t->next;
			}
		return retval;
		}
	else
		return FALSE;
	Diagnostic("ShowTabControl", EXIT, tc != NULL);
	}

//int TabButtFn(PushButton *pb)
int TabButtFn(Frame *pb, short Event, short x, short y, void **data)
	{
	if (Event == FM_LBUT)
		{
		GuiWindow *win = (GuiWindow *) pb->button.UserData;
		TabControl *tc = (TabControl *) pb->WidgetData->ParentControl;
		short width;
		Tab *t = tc->SelectedTab;

		if (t->pb == pb) // The button clicked is already the selected tab
			return GUI_CONTINUE;
		HideFrame(t->frame);
		t->frame->dark.NextBorder = NULL;
		RefreshGList(&t->pb->button, win->Win, NULL, 1);

		t = tc->FirstTab;
		while (t)
			{
			if (t->pb == pb)
				break;
			t = t->next;
			}
		tc->SelectedTab = t;
		width = pb->button.Width - (t->next == NULL ? 2 : 1);
		tc->FramePoints[0] = pb->button.LeftEdge - t->frame->button.LeftEdge + 1;
		tc->FramePoints[2] = tc->FramePoints[0] + width - 1;
		t->frame->dark.NextBorder = &tc->CustomFrameBorder;
		ShowFrame(t->frame);
		RefreshGList(&pb->button, win->Win, NULL, 1);
		if (!tc->Callfn)
			return GUI_CONTINUE;
		else
			return (*tc->Callfn)(pb);
		}
		return GUI_CONTINUE;
	}

void DestroyTabControl(TabControl *tc, BOOL refresh)
	{
	Diagnostic("DestroyTabControl", ENTER, TRUE);
	if (tc)
		{
		Frame *Child; // Could be any object type
		Tab *t = tc->FirstTab, *nt;

		while (t)
			{
			nt = t->next;
			if (t->pb)
				{
				// Pretend the button is not part of another control or we can't destroy it.
				t->pb->WidgetData->ParentControl = NULL;
				DestroyFrame(t->pb, refresh);
				}
			if (t->frame)
				{
				// Pretend the frame is not part of another control or we can't destroy it.
				t->frame->WidgetData->ParentControl = NULL;
				DestroyFrame(t->frame, refresh);
				}
			GuiFree(t);
			t = nt;
			}
		if (Gui.FirstTabControl == tc)
			Gui.FirstTabControl = tc->next;
		else
			{
			TabControl *tcp = Gui.FirstTabControl;
			while (tcp->next && tcp->next != tc)
				tcp = tcp->next;
			tcp->next = tc->next;
			}
		Child = tc->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
		GuiFree(tc->WidgetData);
		GuiFree(tc);
		}
	Diagnostic("DestroyTabControl", EXIT, tc != NULL);
	}

void DestroyWinTabControls(GuiWindow *win, BOOL refresh)
	{
	TabControl *tc = Gui.FirstTabControl;
	Diagnostic("DestroyWinTabControls", ENTER, TRUE);
	if (!win)
		{
		Diagnostic("DestroyWinTabControls", EXIT, FALSE);
		return;
		}
	while (tc)
		{
		if (tc->FirstTab && tc->FirstTab->frame && (GuiWindow *) tc->FirstTab->frame->button.UserData == win)
			{
			DestroyTabControl(tc, refresh);
			/*	There could be tab controls within tab controls so it's not safe to assume that the next one
				in the list stll exists. */
			tc = Gui.FirstTabControl;
			}
		else
			tc = tc->next;
		}
	Diagnostic("DestroyWinTabControls", EXIT, TRUE);
	}

void DestroyAllTabControls(BOOL refresh)
	{
	TabControl *tc = Gui.FirstTabControl;
	Diagnostic("DestroyAllTabControls", ENTER, TRUE);
	while (tc)
		{
		DestroyTabControl(tc, refresh);
		/*	There could be tab controls within tab controls so it's not safe to assume that the next one
			in the list stll exists. */
		tc = Gui.FirstTabControl;
		}
	Diagnostic("DestroyAllTabControls", EXIT, TRUE);
	}

/* Returns a pointer to Frame frameno in the TabControl tc, or NULL if tc is NULL or if frameno is too
	high.  Note that frames are numbered starting at zero. */
Frame* FOXLIB TabControlFrame(REGA0 TabControl *tc, REGD0 int frameno)
	{
	Tab *t;
	int n = 0;
	if (!tc)
		return NULL;
	t = tc->FirstTab;
	while (n < frameno && t)
		{
		t = t->next;
		n++;
		}
	if (t)
		return t->frame;
	else
		return NULL;
	}

BOOL SetUpTab(TabControl *tc, Tab *t, void *Parent, int left, int top, int width, int height, int tableft, int tabheight, int tabwidth, char *caption, short flags, struct Border *customborder, BOOL hidden, int (* __far __stdargs framefn) (Frame*, short, short, short, void**))
	{
	/* Make the button before the frame.  Ideally all of the buttons should be made before all of the
		frames because that's the order they end up in once any button has been pressed (because hiding
		a frame removes it from the gadget list and showing a frame adds it to the end). */
	if ((t->pb = MakeFrame(Parent, caption, tableft, top, tabwidth, tabheight, NULL,
			TabButtFn, FM_LBUT | SYS_FM_ROUNDED | flags, NULL)) == NULL)
		{
		DestroyTabControl(tc, TRUE);
		return FALSE;
		}
	t->pb->WidgetData->ParentControl = tc;
	if (customborder)
		{
		tc->FramePoints[0] = tableft - left + 1;
		tc->FramePoints[2] = tc->FramePoints[0] + t->pb->button.Width - (t->next == NULL ? 3 : 2);
		}
	if (flags & TC_FOXED)
		flags |= FM_LBUT | FM_DRAG | FM_DRAGOUTLINE | FM_DROP;
	if ((t->frame = MakeFrame(Parent, NULL, left, top + tabheight, width, height, customborder, framefn,
			flags, NULL)) == NULL)
		{
		DestroyTabControl(tc, TRUE);
		return FALSE;
		}
	if (hidden)
		HideFrame(t->frame);
	t->frame->WidgetData->ParentControl = tc;
	return TRUE;
	}

TabControl* FOXLIB MakeTabControlArray(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGD4 int tabheight, REGD5 short flags, REGA1 int *tabwidth, REGA2 char **caption,
		REGA3 TabControlExtension *ext)
	{
	TabControl *tc;
	short n;
	Tab *last = NULL;
	int tableft = left, seltableft;
	GuiWindow *Wptr;
	int tabno = 0;
	int (* __far __stdargs callfn) (Frame*) = NULL;
	int (* __far __stdargs framefn) (Frame*, short, short, short, void**) = NULL;

	Diagnostic("MakeTabControlArray", ENTER, TRUE);
	if (!Parent)
		{
		Diagnostic("MakeTabControlArray", EXIT, FALSE);
		return NULL;
		}
	if (ext)
		{
		callfn = ext->callfn;
		tabno = ext->tabselected;
		framefn = ext->framefn;
		}
	if (!ISGUIWINDOW(Parent))
		Wptr = (GuiWindow *) ((Frame *) Parent)->button.UserData;
	else
		Wptr = (GuiWindow *) Parent;
	if ((tc = (TabControl*) GuiMalloc(sizeof(TabControl), 0)) == NULL)
		{
		Diagnostic("MakeTabControlArray", EXIT, FALSE);
		return NULL;
		}
	if ((tc->WidgetData = (Widget*) GuiMalloc(sizeof(Widget), 0)) == NULL)
		{
		GuiFree(tc);
		Diagnostic("MakeTabControlArray", EXIT, FALSE);
		return NULL;
		}
	tc->Callfn = callfn;
	tc->WidgetData->Parent = Parent;
	tc->WidgetData->ObjectType = TabControlObject;
	tc->WidgetData->left = left;
	tc->WidgetData->top = top;
	tc->WidgetData->width = width;
	tc->WidgetData->height = height + tabheight;
	tc->WidgetData->NextWidget = NULL;
	tc->WidgetData->ChildWidget = NULL;
	tc->FirstTab = NULL;
	tc->next = NULL;
	if (flags & FM_CLEAR)
		tc->CustomFrameBorder.FrontPen = GetBackCol(Parent);
	else
		tc->CustomFrameBorder.FrontPen = Gui.BackCol;
	tc->CustomFrameBorder.LeftEdge = tc->CustomFrameBorder.TopEdge = 0;
	tc->CustomFrameBorder.DrawMode = JAM1;
	tc->CustomFrameBorder.XY = tc->FramePoints;
	tc->CustomFrameBorder.Count = 2;
	tc->CustomFrameBorder.NextBorder = NULL;
	tc->FramePoints[1] = tc->FramePoints[3] = 0;
	for (n = 0; tabwidth[n] > 0; n++)
		{
		Tab *t = (Tab*) GuiMalloc(sizeof(Tab), 0);
		if (!t)
			{
			DestroyTabControl(tc, TRUE);
			Diagnostic("MakeTabControlArray", EXIT, FALSE);
			return NULL;
			}
		t->next = NULL;
		t->pb = NULL;
		t->frame = NULL;
		if (n != tabno) // Make the displayed frame last so that it doesn't need refreshing.
			{
			if (!SetUpTab(tc, t, Parent, left, top, width, height, tableft, tabheight, tabwidth[n], caption[n], flags, NULL, TRUE, framefn))
				{
				Diagnostic("MakeTabControlArray", EXIT, FALSE);
				return NULL;
				}
			}
		else
			{
			tc->SelectedTab = t;
			seltableft = tableft;
			}
		if (last)
			last->next = t;
		else
			tc->FirstTab = t;
		last = t;
		tableft += tabwidth[n];
		}

	if (!SetUpTab(tc, tc->SelectedTab, Parent, left, top, width, height, seltableft, tabheight, tabwidth[tabno], caption[tabno], flags, &tc->CustomFrameBorder, FALSE, framefn))
		{
		Diagnostic("MakeTabControlArray", EXIT, FALSE);
		return NULL;
		}

	tc->next = Gui.FirstTabControl;
	Gui.FirstTabControl = tc;
	Diagnostic("MakeTabControlArray", EXIT, TRUE);
	return tc;
	}

TabControl*
#ifdef TEMPORARY
FOXLIB
#endif
MakeTabControl(void *Parent, int left, int top, int width, int height, int tabheight, short flags, int numtabs, ...)
	{
	va_list argptr;
	TabControl *tc;
	short n;
	Tab *last = NULL;
	int firstwidth, tableft = left;
	char *firstcaption;
	GuiWindow *Wptr;

	Diagnostic("MakeTabControl", ENTER, TRUE);
	va_start(argptr, numtabs);
	if (!Parent)
		{
		Diagnostic("MakeTabControl", EXIT, FALSE);
		va_end(argptr);
		return NULL;
		}
	if (!ISGUIWINDOW(Parent))
		Wptr = (GuiWindow *) ((Frame *) Parent)->button.UserData;
	else
		Wptr = (GuiWindow *) Parent;
	if ((tc = (TabControl*) GuiMalloc(sizeof(TabControl), 0)) == NULL)
		{
		Diagnostic("MakeTabControl", EXIT, FALSE);
		va_end(argptr);
		return NULL;
		}
	if ((tc->WidgetData = (Widget*) GuiMalloc(sizeof(Widget), 0)) == NULL)
		{
		GuiFree(tc);
		Diagnostic("MakeTabControl", EXIT, FALSE);
		va_end(argptr);
		return NULL;
		}
	tc->Callfn = NULL;
	tc->WidgetData->Parent = Parent;
	tc->WidgetData->ObjectType = TabControlObject;
	tc->FirstTab = NULL;
	tc->next = NULL;
	if (flags & FM_CLEAR)
		tc->CustomFrameBorder.FrontPen = GetBackCol(Parent);
	else
		tc->CustomFrameBorder.FrontPen = Gui.BackCol;
	tc->CustomFrameBorder.LeftEdge = tc->CustomFrameBorder.TopEdge = 0;
	tc->CustomFrameBorder.DrawMode = JAM1;
	tc->CustomFrameBorder.XY = tc->FramePoints;
	tc->CustomFrameBorder.Count = 2;
	tc->CustomFrameBorder.NextBorder = NULL;
	tc->FramePoints[0] = 1;
	tc->FramePoints[1] = tc->FramePoints[3] = 0;
	for (n = 0; n < numtabs; n++)
		{
		int tabwidth = va_arg(argptr, int);
		char *caption = va_arg(argptr, char*);
		Tab *t = (Tab*) GuiMalloc(sizeof(Tab), 0);
		if (!t)
			{
			DestroyTabControl(tc, TRUE);
			Diagnostic("MakeTabControl", EXIT, FALSE);
			va_end(argptr);
			return NULL;
			}
		t->next = NULL;
		t->pb = NULL;
		t->frame = NULL;
		if (n > 0) // Make the first frame last so that it doesn't need refreshing.
			{
			if (!SetUpTab(tc, t, Parent, left, top, width, height, tableft, tabheight, tabwidth, caption, flags, NULL, TRUE, NULL))
				{
				va_end(argptr);
				Diagnostic("MakeTabControl", EXIT, FALSE);
				return NULL;
				}
			}
		else
			{
			tc->FramePoints[2] = tabwidth - 1;
			firstcaption = caption;
			firstwidth = tabwidth;
			}
		if (last)
			last->next = t;
		else
			tc->FirstTab = tc->SelectedTab = t;
		last = t;
		tableft += tabwidth;
		}
	va_end(argptr);

	if (!SetUpTab(tc, tc->FirstTab, Parent, left, top, width, height, left, tabheight, firstwidth, firstcaption, flags, &tc->CustomFrameBorder, FALSE, NULL))
		{
		Diagnostic("MakeTabControl", EXIT, FALSE);
		return NULL;
		}

	tc->next = Gui.FirstTabControl;
	Gui.FirstTabControl = tc;
	Diagnostic("MakeTabControl", EXIT, TRUE);
	return tc;
	}
