/* FoxGUI - The fast, flexible, free Amiga GUI system
	Copyright (C) 2001 Simon Fox (Foxysoft)

This library is free software; you can redistribute it and/ormodify it under the terms of the GNU Lesser General PublicLicense as published by the Free Software Foundation; eitherversion 2.1 of the License, or (at your option) any later version.This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNULesser General Public License for more details.You should have received a copy of the GNU Lesser General PublicLicense along with this library; if not, write to the Free SoftwareFoundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
Foxysoft: www.foxysoft.co.uk      Email:simon@foxysoft.co.uk                */


#include "guisys.h"

/****************************************************************************************************
 * This module is for functions that are very general in nature and of potential use to more than   *
 * one gui module.                                                                                  *
 ****************************************************************************************************/

#ifdef AMIGA
	#define OFFSET __far
#else
	#define OFFSET
#endif

BOOL OFFSET Diagnostic(char *fn, short enter, BOOL succeed);

BYTE OFFSET GetBackCol(void *Parent);

BOOL OFFSET GadInWinList(struct Gadget *gad, struct Window *w);

void OFFSET EnableGadget(struct Gadget *gad, struct Window *win, BOOL redraw);
void OFFSET DisableGadget(struct Gadget *gad, struct Window *win, BOOL redraw);

struct IntuiText OFFSET *SetLast(struct IntuiText *it);

void OFFSET UnclipGuiWindow(GuiWindow *gw);
struct Region OFFSET *ClipGuiWindow(GuiWindow *gw, long minx, long miny, long maxx, long maxy);

TreeItem *FindPreviousItem(TreeItem *ti);
void FreeItemTree(TreeItem *ti, TreeItem *masterparent, BOOL refresh);
int OFFSET CalcItemTop(TreeItem *ti);
void OFFSET FindMaxSizes(TreeItem *root, int *maxlen, int *maxtop, int *top);
void OFFSET ResizeHorizontalScroller(ListBox *lb, int x, int y, int width, int height, double xfactor, double yfactor, BOOL eraseold);
void OFFSET DestroyVerticalScroller(ListBox *lb, BOOL refresh);
void OFFSET DestroyHorizontalScroller(ListBox *lb, BOOL refresh);
void OFFSET MakeVerticalScroller(ListBox *lb, int (*ScrollUpFn)(PushButton*), int (*ScrollDownFn)(PushButton*));
void OFFSET DisableScroller(Scroller *sc);
void OFFSET MakeHorizontalScroller(ListBox *lb, int (*ScrollLeftFn)(PushButton*), int (*ScrollRightFn)(PushButton*));

void OFFSET SortITextList(struct IntuiText **FirstItem, int flags);

unsigned short OFFSET GetFontHeight(GuiWindow *win);

void OFFSET FakeInputEvent(LONG eventclass, LONG Code, LONG Qualifier, LONG x, LONG y, struct Window *Window);
void OFFSET DeActivateStrGad(void);

int OFFSET TopWindowPixel(struct Screen *Screen, GuiWindow *Window);

void OFFSET MakeBevel(struct Border *light, struct Border *dark, short *points, int left,
		int top, int width, int height, BOOL raised);

void OFFSET MakeDownArrow(struct Border *arrow, int col);
void OFFSET MakeUpArrow(struct Border *arrow, int col);

void OFFSET FindScrollerValues(unsigned short total, unsigned short displayable,
		unsigned short top, short overlap, unsigned short *body, unsigned short *pot);
unsigned short OFFSET FindScrollerTop(unsigned short total, unsigned short displayable, unsigned short pot);

void OFFSET AreaColFill(struct RastPort *rp, int left, int top, int width, int height, int col);
void OFFSET AreaBlank(struct RastPort *rp, int left, int top, int width, int height);

void OFFSET UnTruncateIText(struct IntuiText *IText, char *Original);
void OFFSET TruncateIText(struct IntuiText *IText, char *Original, int MaxLen, int flags);

struct TextAttr OFFSET *CopyFont(struct TextAttr *font);
