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

#include <proto/graphics.h>
#include <proto/intuition.h>
#include <graphics/display.h>
#include <graphics/displayinfo.h>

#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

struct Modes
{
	char *ModeName;
	unsigned long key;
	long width, height;
};

int nA500Modes = 4;
struct Modes A500Modes[] = { NULL, INVALID_ID, 0, 0, 
									"Low Res", LORES_KEY, 320, 200, 
									"High Res", HIRES_KEY, 640, 200, 
									"Low Res Laced", LORES_KEY | INTERLACE, 320, 400,
									"High Res Laced", HIRES_KEY | INTERLACE, 640, 400,
									NULL, INVALID_ID, 0, 0 };

unsigned long FOXLIB GetNextAvailableDisplayMode(REGD0 unsigned long previous)
{
	if (Gui.LibVersion >= 36)
	{
		unsigned long error, retval = INVALID_ID;

		do
		{
			retval = NextDisplayInfo(previous);
			previous = retval;
			error = ModeNotAvailable(retval);
		}	while (error != 0 && retval != INVALID_ID);
		return retval;
	}
	else
	{
		int i = 0;

		while (A500Modes[i].key != previous && i < nA500Modes + 2)
			i++;
		if (i == nA500Modes + 2)
			return INVALID_ID;
		return A500Modes[i + 1].key;
	}
}

static GuiWindow *gwDisplayList;
static unsigned long *DisplayModeList;
static PushButton *pbOkay;
static ListBox *lbDisplay;
static unsigned long modeselected;
static BOOL retval;

static int __far __stdargs CloseFn(GuiWindow *gw, int event, int x, int y, void *data)
{
	if (event == GW_CLOSE)
	{
		retval = FALSE;
		if (DisplayModeList)
			GuiFree(DisplayModeList);
		DisplayModeList = NULL;
		DestroyWinButtons(gw, FALSE);
		DestroyWinListBoxes(gw, FALSE);
		CloseGuiWindow(gw);
		return GUI_CANCEL | GUI_MODAL_END;
	}
	return GUI_MODAL_END;
}

static int __far __stdargs CancelFn(PushButton *pb)
{
	CloseFn(gwDisplayList, GW_CLOSE, 0, 0, NULL);
	return GUI_MODAL_END;
}

static int __far __stdargs OkayFn(PushButton *pb)
{
	if (Gui.LibVersion >= 36)
		modeselected = DisplayModeList[HiNum(lbDisplay) - 1];
	else
		modeselected = A500Modes[HiNum(lbDisplay)].key;
	CloseFn(gwDisplayList, GW_CLOSE, 0, 0, NULL);
	retval = TRUE;
	return GUI_MODAL_END;
}

static int __far __stdargs lbEventFn(ListBox *lb, short event, int itemno, void **data)
{
	if (event == LB_DBLCLICK)
		return OkayFn(pbOkay);
	else if (event == LB_SELECT || event == LB_CURSOR)
		EnableButton(pbOkay);
	return GUI_CONTINUE;
}

BOOL FOXLIB GetModeSize(REGD0 unsigned long displaymode, REGA0 long *width, REGA1 long *height)
{
	unsigned long result;
	struct DimensionInfo dim;

	if (Gui.LibVersion >= 36)
	{
		result = GetDisplayInfoData(NULL, (UBYTE *) &dim, sizeof(dim), DTAG_DIMS, displaymode);
		if (result)
		{
			if (width)
				*width = dim.Nominal.MaxX;
			if (height)
				*height = dim.Nominal.MaxY;
			return TRUE;
		}
	}
	else
	{
		int i = 1;
		while (A500Modes[i].key != displaymode && A500Modes[i].key != INVALID_ID)
			i++;
		if (width)
			*width = A500Modes[i].width;
		if (height)
			*height = A500Modes[i].height;
		return TRUE;
	}
	return FALSE;
}

int FOXLIB GetModeName(REGD0 unsigned long displaymode, REGA0 char *buffer, REGD1 int buflen)
{
	struct NameInfo nInfo;
	char *name;

	if (Gui.LibVersion >= 36)
	{
		if (GetDisplayInfoData(NULL, (UBYTE *) &nInfo, sizeof(nInfo), DTAG_NAME, displaymode))
			name = nInfo.Name;
		else
			name = NULL;
	}
	else
	{
		int i = 1;
		while (A500Modes[i].key != displaymode && A500Modes[i].key != INVALID_ID)
			i++;
		name = A500Modes[i].ModeName;
	}

	if (!name)
		buffer[0] = '\0';
	else
	{
		if (strlen(name) >= buflen)
		{
			strncpy(buffer, name, buflen - 1);
			buffer[buflen - 1] = '\0';
		}
		else
			strcpy(buffer, name);
		return (int) (strlen(name) + 1);
	}
	return 0;
}

BOOL FOXLIB ShowDisplayList(REGA0 void *Scr, REGA1 char *title, REGD0 int DPen, REGD1 int BPen,
		REGA2 unsigned long *displayModeID)
{
	if (Scr)
	{
		int twp;

		modeselected = 0;
		if (ISGUISCREEN(Scr))
		{
			GuiScreen *sc = (GuiScreen *) Scr;
			twp = TopWindowPixel(sc->scr, NULL);
			gwDisplayList = CreateGuiWindow(sc, sc->scr, 144, 18, 312, 100 + twp, DPen, BPen, title, GW_CLOSE | GW_DRAG | GW_DEPTH | GW_SIZE, CloseFn);
		}
		else if (Gui.LibVersion >= 36)
		{
			// Scr is not a FoxGui screen so it must be the name of a public screen to open on.
			struct Screen *PubScr = LockPubScreen((char *) Scr);
			if (!PubScr)
				return FALSE;
			twp = TopWindowPixel(PubScr, NULL);
			gwDisplayList = CreateGuiWindow(NULL, PubScr, 144, 18, 312, 100 + twp, DPen, BPen, title, GW_CLOSE | GW_DRAG | GW_DEPTH | GW_SIZE, CloseFn);
			UnlockPubScreen((char *) Scr, PubScr);
		}
		else
			gwDisplayList = NULL;
		if (gwDisplayList)
		{
			long longest = 0;
			struct NameInfo nInfo;
			PushButton *pbCancel;
			unsigned long DisplayMode = INVALID_ID;
			int buttonwidth;
			struct IntuiText it;
			int items = 0;

			DisplayModeList = NULL;

			it.IText = "Cancel"; // the underlined C shouldn't make it noticably longer
			if (gwDisplayList->ParentScreen->Font)
				it.ITextFont = gwDisplayList->ParentScreen->Font;
			else
				it.ITextFont = &GuiFont;
			buttonwidth = IntuiTextLength(&it) + 10;

			lbDisplay = MakeListBox(gwDisplayList, 7, twp + 1, 280, 77, 2, 2, LB_DBLCLICK | LB_SELECT | LB_CURSOR | S_AUTO_SIZE, lbEventFn, NULL);
			pbCancel = MakeButton(gwDisplayList, "_Cancel", 7, twp + 82, buttonwidth, 14, 'c', NULL, CancelFn, BN_CLEAR | BN_STD | S_AUTO_SIZE, NULL);
			pbOkay = MakeButton(gwDisplayList, "_Okay", 287 - buttonwidth, twp + 82, buttonwidth, 14, 'o', NULL, OkayFn, BN_CLEAR | BN_STD | S_AUTO_SIZE, NULL);
			DisableButton(pbOkay);
			if ((!lbDisplay) || (!pbCancel) || (!pbOkay))
			{
				CloseFn(gwDisplayList, GW_CLOSE, 0, 0, NULL);
				return FALSE;
			}

			if (Gui.LibVersion >= 36)
			{
				// Find the longest mode name
				do
				{
					DisplayMode = GetNextAvailableDisplayMode(DisplayMode);
					if (DisplayMode != INVALID_ID)
					{
						if (GetDisplayInfoData(NULL, (UBYTE *) &nInfo, sizeof(nInfo), DTAG_NAME, DisplayMode))
						{
							long len;
							it.IText = nInfo.Name;
							len = IntuiTextLength(&it);
							if (len > longest)
								longest = len;
						}
					}
				} while (DisplayMode != INVALID_ID);
				SetListBoxTabStops(lbDisplay, FALSE, 1, longest + 4);

				// Populate the list
				do
				{
					DisplayMode = GetNextAvailableDisplayMode(DisplayMode);
					if (DisplayMode != INVALID_ID)
					{
						unsigned long *newdml;
						struct DimensionInfo dInfo;
						char text[500];

						if (GetDisplayInfoData(NULL, (UBYTE *) &dInfo, sizeof(dInfo), DTAG_DIMS, DisplayMode) &&
								GetDisplayInfoData(NULL, (UBYTE *) &nInfo, sizeof(nInfo), DTAG_NAME, DisplayMode))
						{
							long width = dInfo.Nominal.MaxX - dInfo.Nominal.MinX + 1;
							long height = dInfo.Nominal.MaxY - dInfo.Nominal.MinY + 1;

							sprintf(text, "%s\t(%ld, %ld)", nInfo.Name, width, height);
							items++;
							newdml = (unsigned long *) GuiMalloc(items * sizeof(unsigned long), 0);
							if (!newdml)
							{
								CloseFn(gwDisplayList, GW_CLOSE, 0, 0, NULL);
								return FALSE;
							}
							if (DisplayModeList)
							{
								memcpy(newdml, DisplayModeList, (items - 1) * sizeof(unsigned long));
								GuiFree(DisplayModeList);
								DisplayModeList = newdml;
							}
							else
								DisplayModeList = newdml;
							DisplayModeList[items - 1] = DisplayMode;

							AddListBoxItem(lbDisplay, text, FALSE);
						}
					}
				} while (DisplayMode != INVALID_ID);
			}
			else
			{
				int i;
				for (i = 1; A500Modes[i].ModeName != NULL; i++)
					AddListBoxItem(lbDisplay, A500Modes[i].ModeName, FALSE);
			}
			ListBoxRefresh(lbDisplay);
			WinMsgLoop(gwDisplayList);
			*displayModeID = modeselected;
			return retval;
		}
	}
	return FALSE;
}
