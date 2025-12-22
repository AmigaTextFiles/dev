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
#include <math.h>

#include <exec/memory.h>
#include <proto/intuition.h>

#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

BOOL FOXLIB IsMenuChecked(REGA0 struct MenuItem *mi)
{
	if (mi)
		if (mi->Flags & CHECKED)
			return TRUE;
	return FALSE;
}

static BOOL ClearAssocMenuStrip(GuiWindow *win)
	{
	if (win)
		{
		// Clears the menu strip from this window and all associated windows.
		GuiWindow *w = Gui.GWLfirst;

		ClearMenuStrip(win->Win);
		// Clear the menu strips of any other windows that use the same menu strip.
		while (w)
			{
			if (w->FirstMenu == win->FirstMenu && w != win)
				ClearMenuStrip(w->Win);
			w = w->next;
			}
		return TRUE;
		}
	return FALSE;
	}

static BOOL SetAssocMenuStrip(GuiWindow *win)
	{
	if (win)
		{
		// Sets the menu strip for this window and all associated windows.
		GuiWindow *w = Gui.GWLfirst;

		SetMenuStrip(win->Win, win->FirstMenu);
		// Set the menu strips of any other windows that use the same menu strip.
		while (w)
			{
			if (w->FirstMenu == win->FirstMenu && w != win)
				SetMenuStrip(w->Win, win->FirstMenu);
			w = w->next;
			}
		return TRUE;
		}
	return FALSE;
	}

static BOOL FindMenuItemFromItem(struct MenuItem *start, struct MenuItem *item)
	{
	if (start == item)
		return TRUE;
	if (start->SubItem)
		if (FindMenuItemFromItem(start->SubItem, item))
			return TRUE;
	if (start->NextItem)
		return FindMenuItemFromItem(start->NextItem, item);
	return FALSE;
	}

static BOOL FindMenuItem(struct Menu *m, struct MenuItem *item)
	{
	if (item)
		while (m)
			{
			if (m->FirstItem)
				if (FindMenuItemFromItem(m->FirstItem, item))
					return TRUE;
			m = m->NextMenu;
			}
	return FALSE;
	}

static BOOL ChangeMenuItem(GuiWindow *win, struct MenuItem *item, int flag, BOOL enable)
	{
	Diagnostic("ChangeMenuItem", ENTER, TRUE);
	if (!FindMenuItem(win->FirstMenu, item))
		// The menu item isn't in this window!
		return Diagnostic("ChangeMenuItem", EXIT, FALSE);
	else
		{
		ClearAssocMenuStrip(win);

		if (enable)
			item->Flags |= flag; // Set the flag
		else if (item->Flags & flag)
			item->Flags &= ~flag; // Clear the flag

		SetAssocMenuStrip(win); // Reset the menu strip
		}
	return Diagnostic("ChangeMenuItem", EXIT, TRUE);
	}

BOOL FOXLIB SetMenuChecked(REGA0 GuiWindow *win, REGA1 struct MenuItem *item, REGD0 BOOL checked)
	{
	return ChangeMenuItem(win, item, CHECKED, checked);
	}

BOOL FOXLIB DisableMenuItem(REGA0 GuiWindow *win, REGA1 struct MenuItem *item)
	{
	return ChangeMenuItem(win, item, ITEMENABLED, FALSE);
	}

BOOL FOXLIB EnableMenuItem(REGA0 GuiWindow *win, REGA1 struct MenuItem *item)
	{
	return ChangeMenuItem(win, item, ITEMENABLED, TRUE);
	}

static BOOL FindMenu(GuiWindow *win, struct Menu *menu)
	{
	if (win && menu)
		{
		struct Menu *m = win->FirstMenu;
		while (m)
			{
			if (m == menu)
				return TRUE;
			m = m->NextMenu;
			}
		}
	return FALSE;
	}

static BOOL ChangeMenu(GuiWindow *win, struct Menu *menu, BOOL enable, BOOL quick)
	{
	/*	If quick is specified, we're going to bypass all of the checks and we won't reset the menu strip
		either.  This is so that DisableAllMenus() can clear the menu strip, call this function (with
		quick specified) once for each menu and then reset the menu strip. */
	Diagnostic("ChangeMenu", ENTER, TRUE);
	if ((!quick) && !FindMenu(win, menu))
		// The menu isn't in this window!
		return Diagnostic("ChangeMenu", EXIT, FALSE);
	else
		{
		if (!quick)
			ClearAssocMenuStrip(win);

		if (enable)
			menu->Flags |= MENUENABLED; // Enable the menu
		else if (menu->Flags & MENUENABLED)
			menu->Flags ^= MENUENABLED; // Disable the menu

		if (!quick)
			SetAssocMenuStrip(win); // Reset the menu strip
		}
	return Diagnostic("ChangeMenu", EXIT, TRUE);
	}

BOOL FOXLIB DisableMenu(REGA0 GuiWindow *win, REGA1 struct Menu *menu)
	{
	return ChangeMenu(win, menu, FALSE, FALSE);
	}

BOOL FOXLIB EnableMenu(REGA0 GuiWindow *win, REGA1 struct Menu *menu)
	{
	return ChangeMenu(win, menu, TRUE, FALSE);
	}

BOOL FOXLIB DisableWinMenus(REGA0 GuiWindow *win)
	{
	if (win)
		{
		if (win->FirstMenu)
			{
			struct Menu *m = win->FirstMenu;
			ClearAssocMenuStrip(win);
			while (m)
				{
				ChangeMenu(win, m, FALSE, TRUE);
				m = m->NextMenu;
				}
			SetAssocMenuStrip(win);
			}
		return TRUE;
		}
	return FALSE;
	}

BOOL FOXLIB EnableWinMenus(REGA0 GuiWindow *win)
	{
	if (win)
		{
		if (win->FirstMenu)
			{
			struct Menu *m = win->FirstMenu;
			ClearAssocMenuStrip(win);
			while (m)
				{
				ChangeMenu(win, m, TRUE, TRUE);
				m = m->NextMenu;
				}
			SetAssocMenuStrip(win);
			}
		return TRUE;
		}
	return FALSE;
	}

void FOXLIB SetWinMenuFn(REGA0 GuiWindow *win, REGA1 int (* __far __stdargs fn) (GuiWindow*, struct MenuItem *))
	{
	Diagnostic("SetWinMenuFn", ENTER, TRUE);
	win->MenuFn = fn;
	Diagnostic("SetWinMenuFn", EXIT, TRUE);
	}

static long findwidth(char *str, struct TextAttr *font)
	{
	struct IntuiText it;
	
	it.NextText = NULL;
	it.ITextFont = font;
	it.IText = str;
	return IntuiTextLength(&it);
	}

static void SetMenuWidth(GuiWindow *win, struct MenuItem *firstitem)
	{
	/* Find the longest menu item */
	struct MenuItem *item = firstitem;
	struct IntuiText *it;
	int width = 0, SubIndicatorWidth = findwidth(";", win->ParentScreen->Font);
	while (item)
		{
		it = (struct IntuiText *) item->ItemFill;
		if (it->NextText)
			width = max(width, it->NextText->LeftEdge + SubIndicatorWidth);
		else
			width = max(width, item->Width);
		item = item->NextItem;
		};
	/* Set every items select bar to the length of the longest */
	item = firstitem;
	while (item)
		{
		it = (struct IntuiText *) item->ItemFill;
		if (it->NextText) /* If there's a sub-menu */
			{
			struct MenuItem *si;
			int leftedge = (3 * width) / 4;

			/* Move the sub menu indicator to the right edge of the menu */
			it->NextText->LeftEdge = width - SubIndicatorWidth;

			/* Set the left edge of the sub menu items */
			si = item->SubItem;
			while (si)
				{
				si->LeftEdge = leftedge;
				si = si->NextItem;
				};
			};
		item->Width = width;
		item = item->NextItem;
		};
	}

static void ClearText(struct IntuiText *text)
	{
	if (text->NextText)
		ClearText(text->NextText);
	/*	When a submenu is added, the ; character is appended by adding a NextText but the string
		holding the ; is not mallocd but static so check for this. */
	if (strcmp(text->IText, ";"))
		GuiFree(text->IText);
	GuiFree(text);
	}

static void ClearMenuItem(struct MenuItem *menuitem)
	{
	if (menuitem->NextItem)
		ClearMenuItem(menuitem->NextItem);
	if (menuitem->SubItem)
		ClearMenuItem(menuitem->SubItem);
	ClearText((struct IntuiText *) menuitem->ItemFill);
	if (menuitem->SelectFill)
		ClearText((struct IntuiText *) menuitem->SelectFill);
	GuiFree(menuitem);
	}

static void ClearMenu(struct Menu *menu)
	{
	if (menu->NextMenu)
		ClearMenu(menu->NextMenu);
	if (menu->FirstItem)
		ClearMenuItem(menu->FirstItem);
	GuiFree(menu->MenuName);
	GuiFree(menu);
	}

void FOXLIB ClearMenus(REGA0 GuiWindow *win)
	{
	GuiWindow *w = Gui.GWLfirst;
	int found = FALSE;
	Diagnostic("ClearMenus", ENTER, TRUE);
	if (win->FirstMenu)
		{
		if (Gui.CleanupFlag)
	      SetLastErr("Window closed before its menus were destroyed.");
		ClearMenuStrip(win->Win);
		/* Check whether in use by other windows */
		while (w)
			{
			if (w->FirstMenu == win->FirstMenu && w != win)
				found = TRUE;
			w = w->next;
			};
		/* Only free the structures if not still in use */
		if (!found)
			ClearMenu(win->FirstMenu);
		};
	win->FirstMenu = NULL;
	Diagnostic("ClearMenus", EXIT, TRUE);
	}

void FOXLIB ShareMenus(REGA0 GuiWindow *dest, REGA1 GuiWindow *source)
	{
	Diagnostic("ShareMenus", ENTER, TRUE);
	if (dest->FirstMenu)
		ClearMenus(dest);
	dest->FirstMenu = source->FirstMenu;
	SetMenuStrip(dest->Win, dest->FirstMenu);
	Diagnostic("ShareMenus", EXIT, TRUE);
	}

struct Menu* FOXLIB AddMenu(REGA0 GuiWindow *win, REGA1 char *name, REGD0 int leftedge, REGD1 int enabled)
	{
	struct Menu *NewMenu;
	Diagnostic("AddMenu", ENTER, TRUE);
	if (!(NewMenu = (struct Menu *) GuiMalloc(sizeof(struct Menu), 0)))
		{
		Diagnostic("AddMenu", EXIT, FALSE);
		return NULL;
		};
	if (!(NewMenu->MenuName = (char *) GuiMalloc((strlen(name) + 1) * sizeof(char), 0)))
		{
		GuiFree(NewMenu);
		Diagnostic("AddMenu", EXIT, FALSE);
		return NULL;
		};
	memcpy(NewMenu->MenuName, name, (strlen(name) + 1) * sizeof(char));
	NewMenu->NextMenu = NULL;
	NewMenu->Width = findwidth(name, win->ParentScreen->Font) + 8;
	NewMenu->LeftEdge = leftedge;
	NewMenu->TopEdge = NewMenu->Height = 0;
	NewMenu->FirstItem = NULL;
	NewMenu->Flags = (enabled ? MENUENABLED : 0);
	if (win->FirstMenu)
		{
		struct Menu *mp = win->FirstMenu;
		ClearMenuStrip(win->Win);
		while (mp->NextMenu)
			mp = mp->NextMenu;
		mp->NextMenu = NewMenu;
		}
	else
		win->FirstMenu = NewMenu;
	SetMenuStrip(win->Win, win->FirstMenu);
	Diagnostic("AddMenu", EXIT, TRUE);
	return NewMenu;
	}

static struct MenuItem *MakeMenuItem(GuiWindow *win, char *name, char *selname, unsigned short flags, int key, int enabled, int checkit, int checked, int menutoggle)
	{
	int SelFillLen, ItemFillLen;
	struct MenuItem *m;
	struct IntuiText *ItemFill, *SelectFill;
	Diagnostic("MakeMenuItem", ENTER, TRUE);
	if (!(m = (struct MenuItem *) GuiMalloc(sizeof(struct MenuItem), 0)))
		{
		Diagnostic("MakeMenuItem", EXIT, FALSE);
		return NULL;
		};
	if (!(ItemFill = (struct IntuiText *) GuiMalloc(sizeof(struct IntuiText), 0)))
		{
		GuiFree(m);
		Diagnostic("MakeMenuItem", EXIT, FALSE);
		return NULL;
		};
	if (!(ItemFill->IText = (char *) GuiMalloc((strlen(name) + 1) * sizeof(char), 0)))
		{
		GuiFree(ItemFill);
		GuiFree(m);
		Diagnostic("MakeMenuItem", EXIT, FALSE);
		return NULL;
		};
	if (selname)
		{
		if (!(SelectFill = (struct IntuiText *) GuiMalloc(sizeof(struct IntuiText), 0)))
			{
			GuiFree(ItemFill->IText);
			GuiFree(ItemFill);
			GuiFree(m);
			Diagnostic("MakeMenuItem", EXIT, FALSE);
			return NULL;
			};
		if (!(SelectFill->IText = (char *) GuiMalloc((strlen(selname) + 1) * sizeof(char), 0)))
			{
			GuiFree(SelectFill);
			GuiFree(ItemFill->IText);
			GuiFree(ItemFill);
			GuiFree(m);
			Diagnostic("MakeMenuItem", EXIT, FALSE);
			return NULL;
			};
		memcpy(SelectFill->IText, selname, (strlen(selname) + 1) * sizeof(char));
		SelectFill->FrontPen = win->NewWin.DetailPen;
		SelectFill->BackPen = win->NewWin.BlockPen;
		SelectFill->DrawMode = JAM2;
		SelectFill->LeftEdge = (checkit ? CHECKWIDTH : 2);
		SelectFill->TopEdge = 0;
		SelectFill->ITextFont = win->ParentScreen->Font;
		SelectFill->NextText = NULL;
		}
	else
		SelectFill = NULL;

	memcpy(ItemFill->IText, name, (strlen(name) + 1) * sizeof(char));
	ItemFill->FrontPen = win->NewWin.DetailPen;
	ItemFill->BackPen = win->NewWin.BlockPen;
	ItemFill->DrawMode = JAM2;
	ItemFill->LeftEdge = (checkit ? CHECKWIDTH : 2);
	ItemFill->TopEdge = 0;
	ItemFill->ITextFont = win->ParentScreen->Font;
	ItemFill->NextText = NULL;
	m->ItemFill = (APTR) ItemFill;
	m->SelectFill = (APTR) SelectFill;
	m->NextItem = NULL;
	SelFillLen = SelectFill ? IntuiTextLength(SelectFill) : 0;
	ItemFillLen = IntuiTextLength(ItemFill);
	m->Width = max(SelFillLen, ItemFillLen) + (checkit ? CHECKWIDTH : 0) + (key > 0 ? 40 : 0) + 10;
	m->Height = win->ParentScreen->Font->ta_YSize;
	m->Command = (char) key;
	m->SubItem = NULL;
	m->Flags = ITEMTEXT | (selname ? HIGHIMAGE : HIGHCOMP) | (key > 0 ? COMMSEQ : 0) | (enabled ? ITEMENABLED : 0) | (checkit ? CHECKIT : 0) | (checked ? CHECKED : 0) | (checkit && menutoggle ? MENUTOGGLE : 0);
	m->MutualExclude = 0; /* !!! For now... */

	Diagnostic("MakeMenuItem", EXIT, TRUE);
	return m;
	}

BOOL FOXLIB RemoveMenuItem(REGA0 GuiWindow *win, REGA1 struct MenuItem *item)
	{
	struct Menu *m;
	int itemheight;

	if (!(win && item && win->FirstMenu))
		return FALSE;

	// First check that the item is in the window's menu structure
	m = win->FirstMenu;
	while (m)
		{
		struct MenuItem *mi = m->FirstItem, *pi = NULL;
		while (mi)
			{
			if (mi == item)
				{
				// Found the item, let's remove it.
				struct MenuItem *nmi = mi->NextItem;
				itemheight = mi->Height;
				ClearAssocMenuStrip(win);
				if (pi)
					pi->NextItem = nmi;
				else
					m->FirstItem = nmi;
				if (mi->SubItem)
					ClearMenuItem(mi->SubItem);
				if (mi->ItemFill)
					ClearText((struct IntuiText *) mi->ItemFill);
				if (mi->SelectFill)
					ClearText((struct IntuiText *) mi->SelectFill);
				GuiFree(mi);
				while (nmi)
					{
					nmi->TopEdge -= itemheight;
					nmi = nmi->NextItem;
					}
				SetAssocMenuStrip(win);
				return TRUE;
				}
			pi = mi;
			mi = mi->NextItem;
			}
		m = m->NextMenu;
		}
	return FALSE;
	}

struct MenuItem* FOXLIB AddMenuItem(REGA0 GuiWindow *win, REGA1 struct Menu *menu, REGA2 char *name, REGA3 char *selname,
		REGD0 unsigned short flags, REGD1 int key, REGD2 int enabled, REGD3 int checkit, REGD4 int checked, REGD5 int menutoggle)
	{
	struct MenuItem *m, *lastitem = NULL, *item = menu->FirstItem;
	Diagnostic("AddMenuItem", ENTER, TRUE);
	if (!(m = MakeMenuItem(win, name, selname, flags, key, enabled, checkit, checked, menutoggle)))
		{
		Diagnostic("AddMenuItem", EXIT, FALSE);
		return NULL;
		};

	m->LeftEdge = 0;
	m->TopEdge = 0;
	while (item)
		{
		m->TopEdge = m->TopEdge + item->Height;
		lastitem = item;
		item = item->NextItem;
		};

	ClearMenuStrip(win->Win);
	if (lastitem)
		lastitem->NextItem = m;
	else
		menu->FirstItem = m;

	SetMenuWidth(win, menu->FirstItem);
	SetMenuStrip(win->Win, win->FirstMenu);
	
	Diagnostic("AddMenuItem", EXIT, TRUE);
	return m;
	}

struct MenuItem* FOXLIB AddSubMenuItem(REGA0 GuiWindow *win,
		REGA1 struct MenuItem *menuitem, REGA2 char *name, REGA3 char *selname, REGD0 unsigned short flags,
		REGD1 int key, REGD2 int enabled, REGD3 int checkit, REGD4 int checked, REGD5 int menutoggle)
	{
	struct Menu *ParentMenu = NULL, *CheckMenu = win->FirstMenu;
	struct MenuItem *m, *lastitem = NULL, *item = menuitem->SubItem, *CheckItem, *CheckSubItem;
	Diagnostic("AddSubMenuItem", ENTER, TRUE);

	/* Check whether the parent is already a subitem.  If so, reject */
	while (CheckMenu)
		{
		CheckItem = CheckMenu->FirstItem;
		while (CheckItem)
			{
			if (CheckItem == menuitem)
				ParentMenu = CheckMenu;
			CheckSubItem = CheckItem->SubItem;
			while (CheckSubItem)
				{
				if (menuitem == CheckSubItem)
					{
					/* The parent is already a subitem so reject */
					Diagnostic("AddSubMenuItem", EXIT, FALSE);
					return NULL;
					};
				CheckSubItem = CheckSubItem->NextItem;
				};
			CheckItem = CheckItem->NextItem;
			};
		CheckMenu = CheckMenu->NextMenu;
		};

	/* If the parent doesn't yet have any sub items, initialise it */
	if (!menuitem->SubItem)
		{
		int SelFillLen, ItemFillLen;
		struct IntuiText *it, *sf;
		/* Remove the hot key if it has one */
		menuitem->Command = (char) 0;
		/* Add the ; character to the parent menu to indicate the sub menu */
		it = (struct IntuiText *) menuitem->ItemFill;
		sf = (struct IntuiText *) menuitem->SelectFill;
		if (!(it->NextText = (struct IntuiText *) GuiMalloc(sizeof(struct IntuiText), 0)))
			{
			Diagnostic("AddSubMenuItem", EXIT, FALSE);
			return NULL;
			};
		it->NextText->IText = ";";
		it->NextText->FrontPen = it->FrontPen;
		it->NextText->BackPen = it->BackPen;
		it->NextText->DrawMode = it->DrawMode;
		SelFillLen = sf ? IntuiTextLength(sf) : 0;
		ItemFillLen = IntuiTextLength(it);
		it->NextText->LeftEdge = max(SelFillLen, ItemFillLen) + findwidth("x", it->ITextFont);
		it->NextText->TopEdge = it->TopEdge;
		it->NextText->ITextFont = it->ITextFont;
		it->NextText->NextText = NULL;
		};

	if (!(m = MakeMenuItem(win, name, selname, flags, key, enabled, checkit, checked, menutoggle)))
		{
		Diagnostic("AddSubMenuItem", EXIT, FALSE);
		return NULL;
		};

	m->TopEdge = 0;
	while (item)
		{
		m->TopEdge = m->TopEdge + item->Height;
		lastitem = item;
		item = item->NextItem;
		};

	ClearMenuStrip(win->Win);
	if (lastitem)
		lastitem->NextItem = m;
	else
		menuitem->SubItem = m;

	if (ParentMenu)
		SetMenuWidth(win, ParentMenu->FirstItem);
	m->LeftEdge = (3 * ParentMenu->FirstItem->Width) / 4;
	SetMenuWidth(win, menuitem->SubItem);
	SetMenuStrip(win->Win, win->FirstMenu);
	
	Diagnostic("AddSubMenuItem", EXIT, TRUE);
	return m;
	}
