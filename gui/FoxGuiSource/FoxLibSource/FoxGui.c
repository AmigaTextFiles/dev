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
#include <math.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>
#include <time.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>
#include <proto/console.h>
#include <proto/layers.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <graphics/display.h>
#include <graphics/displayinfo.h>

#define FOXGUI
#define QRead(a,b)   QueueRead((a)->Con,(b))

#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

#define ACTION_BUTTON			1
#define ACTION_TICKBOX			2
#define ACTION_CLOSE				3
#define ACTION_FRAME_LBUT		4
#define ACTION_FRAME_RBUT		5
#define ACTION_RADIO_BUT		6
#define ACTION_LIST_BOX			7
#define ACTION_DRAG_BAR			8
#define ACTION_DROP				9
#define ACTION_RESIZE			10
#define ACTION_WINDOW_DRAG		11
#define ACTION_WINDOW_ACTIVE	12
#define ACTION_EB_RETURN		13
#define ACTION_EB_CLICK_OUT	14
#define ACTION_DISKIN			15
#define ACTION_DISKOUT			16

// To respond to the version command.
const char *version = "$VER: FoxGui version 5.1 {c} FoxySoft 1993-2000";

static void						*ActionPtr;
static GuiWindow				*ActionWin;
static short					Action;
static short					ActionX, ActionY;
static unsigned long			GuiSecs, GuiMicros;
static unsigned short		*ChipMemForPointer = NULL, *ChipMemForDragPointer = NULL;
static EditBox					*editptr = NULL, *lastactiveDDListBox = NULL;
static DDListBox				*NewTopBox = NULL;
static BOOL						ListWinStatusStored = FALSE;
static unsigned long    	MenuNum = MENUNULL;
static GuiWindow				*MenuWinPtr = NULL;
static int						Stop;
struct Library					*ConsoleDevice = NULL;
static struct IOStdReq		ioreq; // For the console device we're going to use for Rawkey conversions.
static struct InputEvent	*RKCevent;
static unsigned char			*RKCbuffer = NULL; // The buffer for raw key conversions.
static unsigned long			RKCbufferSize = 2;
static BOOL						EscapeKey;
static GuiWindow				*stModalWin = NULL;
static BOOL						DragWinFlagsChanged = FALSE;
static ListBoxItem			*SelectedLBHiItem;
static ListBox					*gDDLastListOver = NULL; // A pointer to the current or last list box under the pointer while dragging data
static ListBoxItem			*gDDLastItemOver = NULL; // A pointer to the current or last list box item under the pointer while dragging data
static TreeControl			*gDDLastTreeOver = NULL; // A pointer to the current or last treecontrol under the pointer while dragging data
static TreeItem				*gDDLastLeafOver = NULL; // A pointer to the current or last tree item under the pointer while dragging data

static unsigned long			UserSigMask = 0L;
static void						*UserSigData = NULL;
static int						(* __stdargs UserSigFn)(unsigned long signals, void *UserData) = NULL;

static DDListBox *DDListBoxItemSelect(BOOL NoSelect, struct ListElement *elemfound);
static DDListBox *NewDDListBoxItemSelect(BOOL NoSelect, struct IntuiText *elemfound);
static BOOL EditBoxSelected(struct IntuiMessage *WinMsg);
static GuiWindow *FindDropWindow(GuiWindow *SourceWindow, short ActionX, short ActionY);
static ListBox *FindDropList(GuiWindow *Target, int ScreenX, int ScreenY);
static Frame *FindDropFrame(GuiWindow *Target, int ScreenX, int ScreenY);
void UndrawTreeControl(TreeControl *tc);
void DrawTreeControl(TreeControl *tc);
void ClearListBoxDropNum(ListBox *lb, ListBoxItem *OldHiItem);
ListBoxItem *SetListBoxDropNum(ListBox *lb, int HiNum, ListBoxItem *OldHiItem);
void ClearTreeControlDropNum(TreeControl *tc, TreeItem *OldHiItem);
TreeItem *SetTreeControlDropNum(TreeControl *tc, TreeItem *HiItem, TreeItem *OldHiItem);
static BOOL CloseGuiScreen(GuiScreen *scr);
static void CloseAllGuiScreens(void);

// AutoInitialisation routine.  Called when OpenLibrary is called.  A priority of 4000 means it will happen even
// before global variables are defined (which happens at priority 5000).
// This will cause the IEEE DP Math library to be open for use by all FoxGui functions.
int _STI_4000_InitMath(void)
{
	MathIeeeDoubBasBase = OpenLibrary("mathieeedoubbas.library", 0);
	if (MathIeeeDoubBasBase)
		return 0; //Success
	return -1; //Failure.  OpenLibrary("FoxGui.library", n) will fail.
}

// Auto termination function.  Called when the library closes.
void _STD_4000_TermMath(void)
{
	if (MathIeeeDoubBasBase)
		CloseLibrary(MathIeeeDoubBasBase);
}

void FOXLIB SetDefaultFont(REGA0 char *name, REGD0 int size, REGD1 int style)
{
	if (GuiFont.ta_Name)
		GuiFree(GuiFont.ta_Name);
	GuiFont.ta_Name = GuiMalloc((strlen(name) + 1) * sizeof(char), 0);
	if (GuiFont.ta_Name)
		strcpy(GuiFont.ta_Name, name);
	GuiULFont.ta_Name = GuiFont.ta_Name;
	GuiFont.ta_YSize = size;
	GuiULFont.ta_YSize = size;
	GuiFont.ta_Style = style;
	GuiULFont.ta_Style = style | FSF_UNDERLINED;
}

void FOXLIB GetDefaultFontCopy(REGA0 char *fontname, REGD0 int bufsize, REGA1 int *height, REGA2 int *style)
{
	if (strlen(GuiFont.ta_Name) < bufsize)
		strcpy(fontname, GuiFont.ta_Name);
	else
	{
		strncpy(fontname, GuiFont.ta_Name, bufsize - 1);
		fontname[bufsize - 1] = 0;
	}
	if (height)
		*height = GuiFont.ta_YSize;
	if (style)
		*style = GuiFont.ta_Style;
}

void FOXLIB SetDefaultCols(REGD0 int BorderCol, REGD1 int BackCol, REGD2 int TextCol)
{
	Gui.BorderCol = BorderCol;
	Gui.BackCol = BackCol;
	Gui.TextCol = TextCol;
}

void GuiSetLastErrAndLine(char *error, char *file, int line)
{
	strcpy(LastErr, error);
	strcpy(LastErrFile, file);
	LastErrLine = line;
}

void FOXLIB GuiGetLastErr(REGA0 char *error, REGA1 char *file, REGA2 int *line)
{
	if (LastErrLine > 0)
		strcpy(error, LastErr);
	else
		error[0] = 0;
	if (LastErrLine > 0)
		strcpy(file, LastErrFile);
	else
		file[0] = 0;
	*line = LastErrLine;
	LastErrLine = 0;
}

void SetSignals(unsigned long mask, int (*fn)(unsigned long, void*), void *UserData)
	{
	UserSigMask = mask;
	UserSigFn = fn;
	UserSigData = UserData;
	Gui.Done = TRUE;
	}

void AddSignals(unsigned long mask)
	{
	UserSigMask |= mask;
	Gui.Done = TRUE;
	}

void ClearSignals(unsigned long mask)
	{
	if (mask == 0)
		UserSigMask = 0;
	else
		UserSigMask &= ~mask;
	Gui.Done = TRUE;
	}

long FOXLIB GuiTextLength(REGA0 char *text, REGA1 struct TextAttr *font)
{
	struct IntuiText it;

	if (font)
		it.ITextFont = font;
	else
		it.ITextFont = &GuiFont;
	it.IText = text;
	it.NextText = NULL;

	return IntuiTextLength(&it);
}

GuiWindow* FOXLIB GetWindow(REGA0 void *Control)
	{
	void *Parent = NULL;
	// Pretend the control is a frame.  It makes no diffence what type of control we pretend it is.
	Frame *f = (Frame *) Control;
	if (f)
		if (f->WidgetData->ObjectType == ListBoxObject || f->WidgetData->ObjectType == TreeControlObjectType)
			return ((ListBox*) Control)->Win;
		else if (f->WidgetData->ObjectType == OutputBoxObject)
			return ((OutputBox*) Control)->win;
		else if (f->WidgetData->ObjectType == ProgressBarObject)
			return ((ProgressBar*) Control)->win;
		else if (f->WidgetData->ObjectType == WindowObject)
			return (GuiWindow *) Control;
		else if (f->WidgetData->ObjectType == ButtonObject)
			Parent = ((PushButton*) Control)->WidgetData->Parent;
		else if (f->WidgetData->ObjectType == TabControlObject)
			Parent = ((TabControl*) Control)->WidgetData->Parent;
		else if (f->WidgetData->ObjectType == DDListBoxObject)
			Parent = ((DDListBox*) Control)->WidgetData->Parent;
		else if (f->WidgetData->ObjectType == EditBoxObject)
			Parent = ((EditBox*) Control)->WidgetData->Parent;
		else if (f->WidgetData->ObjectType == TickBoxObject)
			Parent = ((TickBox*) Control)->WidgetData->Parent;
		else if (f->WidgetData->ObjectType == RadioButtonObject)
			Parent = ((RadioButton*) Control)->WidgetData->Parent;
		else if (f->WidgetData->ObjectType == FrameObject)
			Parent = ((Frame*) Control)->WidgetData->Parent;
		if (Parent)
			return GetWindow(Parent);
	return NULL;
	}

BOOL FOXLIB RegisterGadget(REGA0 struct Gadget *gad, REGA1 GuiWindow *gadwin, REGA2 int (* __far __stdargs gadfn)(struct Gadget*, struct IntuiMessage *))
	{
	if (gad && gadfn)
		{
		UserGadget *ug = (UserGadget*) GuiMalloc(sizeof(UserGadget), 0);
		if (!ug)
			return FALSE;
		ug->next = Gui.FirstUserGadget;
		ug->gad = gad;
		ug->fn = gadfn;
		if (gadwin && ISGUIWINDOW(gadwin))
			ug->win = gadwin;
		else
			ug->win = NULL;
		Gui.FirstUserGadget = ug;
		return TRUE;
		}
	return FALSE;
	}

BOOL FOXLIB UnRegisterGadget(REGA0 struct Gadget *gad)
	{
	UserGadget *ug = Gui.FirstUserGadget, *pug = NULL;
	while (ug)
		{
		if (ug->gad == gad)
			{
			if (pug)
				pug->next = ug->next;
			else
				Gui.FirstUserGadget = ug->next;
			GuiFree(ug);
			return TRUE;
			}
		pug = ug;
		ug = ug->next;
		}
	return FALSE;
	}

BOOL FOXLIB Destroy(REGA0 void *Control, REGD0 BOOL refresh)
	{
	// Pretend the control is a frame.  It makes no diffence what type of control we pretend it is.
	Frame *f = (Frame *) Control;
	if (f)
		{
		if (f->WidgetData->ObjectType == FrameObject)
			DestroyFrame(f, refresh);
		else if (f->WidgetData->ObjectType == ButtonObject)
			DestroyButton((PushButton*) Control, refresh);
		else if (f->WidgetData->ObjectType == TabControlObject)
			DestroyTabControl((TabControl*) Control, refresh);
		else if (f->WidgetData->ObjectType == ListBoxObject || f->WidgetData->ObjectType == TreeControlObjectType)
			return DestroyListBox((ListBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == DDListBoxObject)
			DestroyDDListBox((DDListBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == EditBoxObject)
			DestroyEditBox((EditBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == OutputBoxObject)
			DestroyOutputBox((OutputBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == ProgressBarObject)
			DestroyProgressBar((ProgressBar*) Control, refresh);
		else if (f->WidgetData->ObjectType == TickBoxObject)
			DestroyTickBox((TickBox *) Control, refresh);
		else if (f->WidgetData->ObjectType == RadioButtonObject)
			DestroyRadioButton((RadioButton*) Control, refresh);
		else if (f->WidgetData->ObjectType == WindowObject)
			CloseGuiWindow((GuiWindow*) Control);
		else if (f->WidgetData->ObjectType == ScreenObject)
			return CloseGuiScreen((GuiScreen *) Control);
		else if (f->WidgetData->ObjectType == TimerObject)
			return DestroyTimer((Timer*) Control);
		}
		else
			return FALSE;
	return TRUE;
	}

void FOXLIB DestroyM(REGD0 int ObjectType, REGA0 void *Parent, REGD1 BOOL refresh)
{
	GuiWindow *parent = (GuiWindow *) Parent;

	if (parent)
	{
		if ((ObjectType == WindowTypeID || ObjectType == 0) && parent->WidgetData->ObjectType == ScreenObject)
			CloseScrWindows((GuiScreen *) Parent);
		if (parent->WidgetData->ObjectType != WindowObject) // Invalid
			return;
		if (ObjectType == FrameTypeID || ObjectType == 0)
			DestroyWinFrames(parent, refresh);
		if (ObjectType == ListBoxTypeID || ObjectType == TreeControlTypeID || ObjectType == 0)
			DestroyWinListBoxes(parent, refresh);
		if (ObjectType == DDListBoxTypeID || ObjectType == 0)
			DestroyWinDDListBoxes(parent, refresh);
		if (ObjectType == EditBoxTypeID || ObjectType == 0)
			DestroyWinEditBoxes(parent, refresh);
		if (ObjectType == ButtonTypeID || ObjectType == 0)
			DestroyWinButtons(parent, refresh);
		if (ObjectType == OutputBoxTypeID || ObjectType == 0)
			DestroyWinOutputBoxes(parent, refresh);
		if (ObjectType == RadioButtonTypeID || ObjectType == 0)
			DestroyWinRadioButtons(parent, refresh);
		if (ObjectType == TickBoxTypeID || ObjectType == 0)
			DestroyWinTickBoxes(parent, refresh);
		if (ObjectType == TabControlTypeID || ObjectType == 0)
			DestroyWinTabControls(parent, refresh);
		if (ObjectType == ProgressBarTypeID || ObjectType == 0)
		{
			ProgressBar *pb = Gui.FirstProgressBar;
			while (pb)
			{
				ProgressBar *pbn = pb->Next;
				if (pb->WidgetData->Parent == (Widget*) parent)
					Destroy(pb, refresh);
				pb = pbn;
			}
		}
	}
	else
	{
		if (ObjectType == FrameTypeID || ObjectType == 0)
			DestroyAllFrames(refresh);
		if (ObjectType == ListBoxTypeID || ObjectType == TreeControlTypeID || ObjectType == 0)
			DestroyAllListBoxes(refresh);
		if (ObjectType == DDListBoxTypeID || ObjectType == 0)
			DestroyAllDDListBoxes(refresh);
		if (ObjectType == EditBoxTypeID || ObjectType == 0)
			DestroyAllEditBoxes(refresh);
		if (ObjectType == ButtonTypeID || ObjectType == 0)
			DestroyAllButtons(refresh);
		if (ObjectType == OutputBoxTypeID || ObjectType == 0)
			DestroyAllOutputBoxes(refresh);
		if (ObjectType == RadioButtonTypeID || ObjectType == 0)
			DestroyAllRadioButtons(refresh);
		if (ObjectType == TickBoxTypeID || ObjectType == 0)
			DestroyAllTickBoxes(refresh);
		if (ObjectType == TabControlTypeID || ObjectType == 0)
			DestroyAllTabControls(refresh);
		if (ObjectType == ProgressBarTypeID || ObjectType == 0)
		{
			ProgressBar *pb = Gui.FirstProgressBar;
			while (pb)
			{
				Destroy(pb, refresh);
				pb = Gui.FirstProgressBar;
			}
		}
		if (ObjectType == TimerTypeID || ObjectType == 0)
			DestroyAllTimers();
		if (ObjectType == WindowTypeID || ObjectType == 0)
			CloseAllWindows();
		if (ObjectType == ScreenTypeID || ObjectType == 0)
			CloseAllGuiScreens();
	}
}

void FOXLIB EnableM(REGD0 int ObjectType, REGA0 void *Parent, REGD1 BOOL refresh)
{
	GuiWindow *parent = (GuiWindow *) Parent;

	if (parent)
	{
		if (parent->WidgetData->ObjectType != WindowObject) // Invalid
			return;
		if (ObjectType == FrameTypeID || ObjectType == 0)
			EnableWinFrames(parent);
		if (ObjectType == ListBoxTypeID || ObjectType == TreeControlTypeID || ObjectType == 0)
			EnableWinListBoxes(parent);
		if (ObjectType == DDListBoxTypeID || ObjectType == 0)
			EnableWinDDListBoxes(parent, refresh);
		if (ObjectType == EditBoxTypeID || ObjectType == 0)
			EnableWinEditBoxes(parent, refresh);
		if (ObjectType == ButtonTypeID || ObjectType == 0)
			EnableWinButtons(parent);
		if (ObjectType == RadioButtonTypeID || ObjectType == 0)
		{
			RadioButton *rb = Gui.FirstRadioButton;
			while (rb)
			{
				if (rb->WidgetData->Parent == (Widget*) parent)
					EnableControl(rb, refresh);
				rb = rb->Next;
			}
		}
		if (ObjectType == TickBoxTypeID || ObjectType == 0)
		{
			TickBox *tb = Gui.FirstTickBox;
			while (tb)
			{
				if (tb->WidgetData->Parent == (Widget*) parent)
					EnableControl(tb, refresh);
				tb = tb->Next;
			}
		}
		if (ObjectType == TabControlTypeID || ObjectType == 0)
		{
			TabControl *tc = Gui.FirstTabControl;
			while (tc)
			{
				if (tc->WidgetData->Parent == (Widget*) parent)
					EnableControl(tc, refresh);
				tc = tc->next;
			}
		}
		if (ObjectType == ProgressBarTypeID || ObjectType == 0)
		{
			ProgressBar *pb = Gui.FirstProgressBar;
			while (pb)
			{
				if (pb->WidgetData->Parent == (Widget*) parent)
					EnableControl(pb, refresh);
				pb = pb->Next;
			}
		}
	}
	else
	{
		if (ObjectType == FrameTypeID || ObjectType == 0)
			EnableAllFrames();
		if (ObjectType == ListBoxTypeID || ObjectType == TreeControlTypeID || ObjectType == 0)
			EnableAllListBoxes();
		if (ObjectType == DDListBoxTypeID || ObjectType == 0)
			EnableAllDDListBoxes(refresh);
		if (ObjectType == EditBoxTypeID || ObjectType == 0)
			EnableAllEditBoxes(refresh);
		if (ObjectType == ButtonTypeID || ObjectType == 0)
			EnableAllButtons();
		if (ObjectType == RadioButtonTypeID || ObjectType == 0)
		{
			RadioButton *rb = Gui.FirstRadioButton;
			while (rb)
			{
				EnableControl(rb, refresh);
				rb = rb->Next;
			}
		}
		if (ObjectType == TickBoxTypeID || ObjectType == 0)
		{
			TickBox *tb = Gui.FirstTickBox;
			while (tb)
			{
				EnableControl(tb, refresh);
				tb = tb->Next;
			}
		}
		if (ObjectType == TabControlTypeID || ObjectType == 0)
		{
			TabControl *tc = Gui.FirstTabControl;
			while (tc)
			{
				EnableControl(tc, refresh);
				tc = tc->next;
			}
		}
		if (ObjectType == ProgressBarTypeID || ObjectType == 0)
		{
			ProgressBar *pb = Gui.FirstProgressBar;
			while (pb)
			{
				EnableControl(pb, refresh);
				pb = pb->Next;
			}
		}
		if (ObjectType == TimerTypeID || ObjectType == 0)
		{
			Timer *t = Gui.FirstTimer;
			while (t)
			{
				UnpauseTimer(t);
				t = t->NextTimer;
			}
		}
		if (ObjectType == WindowTypeID || ObjectType == 0)
		{
			GuiWindow *gw = Gui.GWLfirst;
			while (gw)
			{
				WakePointer(gw);
				gw = gw->next;
			}
		}
	}
}

void FOXLIB DisableM(REGD0 int ObjectType, REGA0 void *Parent, REGD1 BOOL refresh)
{
	GuiWindow *parent = (GuiWindow *) Parent;

	if (parent)
	{
		if (parent->WidgetData->ObjectType != WindowObject) // Invalid
			return;
		if (ObjectType == FrameTypeID || ObjectType == 0)
			DisableWinFrames(parent);
		if (ObjectType == ListBoxTypeID || ObjectType == TreeControlTypeID || ObjectType == 0)
			DisableWinListBoxes(parent);
		if (ObjectType == DDListBoxTypeID || ObjectType == 0)
			DisableWinDDListBoxes(parent, refresh);
		if (ObjectType == EditBoxTypeID || ObjectType == 0)
			DisableWinEditBoxes(parent, refresh);
		if (ObjectType == ButtonTypeID || ObjectType == 0)
			DisableWinButtons(parent);
		if (ObjectType == RadioButtonTypeID || ObjectType == 0)
		{
			RadioButton *rb = Gui.FirstRadioButton;
			while (rb)
			{
				if (rb->WidgetData->Parent == (Widget*) parent)
					DisableControl(rb, refresh);
				rb = rb->Next;
			}
		}
		if (ObjectType == TickBoxTypeID || ObjectType == 0)
		{
			TickBox *tb = Gui.FirstTickBox;
			while (tb)
			{
				if (tb->WidgetData->Parent == (Widget*) parent)
					DisableControl(tb, refresh);
				tb = tb->Next;
			}
		}
		if (ObjectType == TabControlTypeID || ObjectType == 0)
		{
			TabControl *tc = Gui.FirstTabControl;
			while (tc)
			{
				if (tc->WidgetData->Parent == (Widget*) parent)
					DisableControl(tc, refresh);
				tc = tc->next;
			}
		}
		if (ObjectType == ProgressBarTypeID || ObjectType == 0)
		{
			ProgressBar *pb = Gui.FirstProgressBar;
			while (pb)
			{
				if (pb->WidgetData->Parent == (Widget*) parent)
					DisableControl(pb, refresh);
				pb = pb->Next;
			}
		}
	}
	else
	{
		if (ObjectType == FrameTypeID || ObjectType == 0)
			DisableAllFrames();
		if (ObjectType == ListBoxTypeID || ObjectType == TreeControlTypeID || ObjectType == 0)
			DisableAllListBoxes();
		if (ObjectType == DDListBoxTypeID || ObjectType == 0)
			DisableAllDDListBoxes(refresh);
		if (ObjectType == EditBoxTypeID || ObjectType == 0)
			DisableAllEditBoxes(refresh);
		if (ObjectType == ButtonTypeID || ObjectType == 0)
			DisableAllButtons();
		if (ObjectType == RadioButtonTypeID || ObjectType == 0)
		{
			RadioButton *rb = Gui.FirstRadioButton;
			while (rb)
			{
				DisableControl(rb, refresh);
				rb = rb->Next;
			}
		}
		if (ObjectType == TickBoxTypeID || ObjectType == 0)
		{
			TickBox *tb = Gui.FirstTickBox;
			while (tb)
			{
				DisableControl(tb, refresh);
				tb = tb->Next;
			}
		}
		if (ObjectType == TabControlTypeID || ObjectType == 0)
		{
			TabControl *tc = Gui.FirstTabControl;
			while (tc)
			{
				DisableControl(tc, refresh);
				tc = tc->next;
			}
		}
		if (ObjectType == ProgressBarTypeID || ObjectType == 0)
		{
			ProgressBar *pb = Gui.FirstProgressBar;
			while (pb)
			{
				DisableControl(pb, refresh);
				pb = pb->Next;
			}
		}
		if (ObjectType == TimerTypeID || ObjectType == 0)
		{
			Timer *t = Gui.FirstTimer;
			while (t)
			{
				PauseTimer(t);
				t = t->NextTimer;
			}
		}
		if (ObjectType == WindowTypeID || ObjectType == 0)
		{
			GuiWindow *gw = Gui.GWLfirst;
			while (gw)
			{
				SleepPointer(gw);
				gw = gw->next;
			}
		}
	}
}

void FOXLIB EnableControl(REGA0 void *Control, REGD0 BOOL refresh)
	{
	// Pretend the control is a frame.  It makes no diffence what type of control we pretend it is.
	Frame *f = (Frame *) Control;
	if (f)
		if (f->WidgetData->ObjectType == ButtonObject)
			EnableButton((PushButton*) Control);
		else if (f->WidgetData->ObjectType == FrameObject)
			EnableFrame(f);
		else if (f->WidgetData->ObjectType == TabControlObject)
			EnableTabControl((TabControl*) Control);
		else if (f->WidgetData->ObjectType == ListBoxObject)
			EnableListBox((ListBox*) Control);
		else if (f->WidgetData->ObjectType == DDListBoxObject)
			EnableDDListBox((DDListBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == EditBoxObject)
			EnableEditBox((EditBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == TickBoxObject)
			EnableTickBox((TickBox*) Control);
		else if (f->WidgetData->ObjectType == RadioButtonObject)
			EnableRadioButton((RadioButton*) Control);
		else if (f->WidgetData->ObjectType == WindowObject)
			WakePointer((GuiWindow*) Control);
		else if (f->WidgetData->ObjectType == TimerObject)
			UnpauseTimer((Timer*) Control);
		else if (f->WidgetData->ObjectType == OutputBoxObject || f->WidgetData->ObjectType == ProgressBarObject ||
				f->WidgetData->ObjectType == ScreenObject)
			{}
	}

void FOXLIB DisableControl(REGA0 void *Control, REGD0 BOOL refresh)
	{
	// Pretend the control is a frame.  It makes no diffence what type of control we pretend it is.
	Frame *f = (Frame *) Control;
	if (f)
		if (f->WidgetData->ObjectType == ButtonObject)
			DisableButton((PushButton*) Control);
		else if (f->WidgetData->ObjectType == FrameObject)
			DisableFrame(f);
		else if (f->WidgetData->ObjectType == TabControlObject)
			DisableTabControl((TabControl*) Control);
		else if (f->WidgetData->ObjectType == ListBoxObject)
			DisableListBox((ListBox*) Control);
		else if (f->WidgetData->ObjectType == DDListBoxObject)
			DisableDDListBox((DDListBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == EditBoxObject)
			DisableEditBox((EditBox*) Control, refresh);
		else if (f->WidgetData->ObjectType == TickBoxObject)
			DisableTickBox((TickBox*) Control);
		else if (f->WidgetData->ObjectType == RadioButtonObject)
			DisableRadioButton((RadioButton*) Control);
		else if (f->WidgetData->ObjectType == WindowObject)
			SleepPointer((GuiWindow*) Control);
		else if (f->WidgetData->ObjectType == TimerObject)
			PauseTimer((Timer*) Control);
		else if (f->WidgetData->ObjectType == OutputBoxObject || f->WidgetData->ObjectType == ProgressBarObject ||
				f->WidgetData->ObjectType == ScreenObject)
			{}
	}

BOOL FOXLIB Hide(REGA0 void *Control)
	{
	// Pretend the control is a frame.  It makes no diffence what type of control we pretend it is.
	BOOL retval = FALSE;
	Frame *f = (Frame *) Control;
	if (f)
		{
		Frame *child = f->WidgetData->ChildWidget;

		if (f->WidgetData->ObjectType == FrameObject)
			retval = HideFrame(f);
		else if (f->WidgetData->ObjectType == ButtonObject)
			retval = HideButton((PushButton*) Control);
		else if (f->WidgetData->ObjectType == TabControlObject)
			retval = HideTabControl((TabControl*) Control);
		else if (f->WidgetData->ObjectType == ListBoxObject)
			retval = HideListBox((ListBox*) Control);
		else if (f->WidgetData->ObjectType == DDListBoxObject)
			retval = HideDDListBox((DDListBox*) Control);
		else if (f->WidgetData->ObjectType == EditBoxObject)
			retval = HideEditBox((EditBox*) Control);
		else if (f->WidgetData->ObjectType == OutputBoxObject)
			retval = HideOutputBox((OutputBox*) Control);
		else if (f->WidgetData->ObjectType == ProgressBarObject)
			retval = HideProgressBar((ProgressBar*) Control);
		else if (f->WidgetData->ObjectType == TickBoxObject)
			retval = HideTickBox((TickBox*) Control);
		else if (f->WidgetData->ObjectType == RadioButtonObject)
			retval = HideRadioButton((RadioButton*) Control);
		else if (f->WidgetData->ObjectType == WindowObject || f->WidgetData->ObjectType == ScreenObject || f->WidgetData->ObjectType == TimerObject)
			{}
		// Now we've hidden it, see if there are any other controls that form part of the
		// same control and, if so, hide them (e.g. pre/post text).
		while (child)
			{
			if (child->WidgetData->ParentControl == f)
				retval = retval && Hide(child);
			child = child->WidgetData->NextWidget;
			}
		}
	return retval;
	}

BOOL FOXLIB Show(REGA0 void *Control)
	{
	// Pretend the control is a frame.  It makes no diffence what type of control we pretend it is.
	Frame *f = (Frame *) Control;
	BOOL retval = FALSE;
	if (f)
		{
		Frame *child = f->WidgetData->ChildWidget;

		if (f->WidgetData->ObjectType == FrameObject)
			retval = ShowFrame(f);
		else if (f->WidgetData->ObjectType == ButtonObject)
			retval = ShowButton((PushButton*) Control);
		else if (f->WidgetData->ObjectType == TabControlObject)
			retval = ShowTabControl((TabControl*) Control);
		else if (f->WidgetData->ObjectType == ListBoxObject)
			retval = ShowListBox((ListBox*) Control);
		else if (f->WidgetData->ObjectType == DDListBoxObject)
			retval = ShowDDListBox((DDListBox*) Control);
		else if (f->WidgetData->ObjectType == EditBoxObject)
			retval = ShowEditBox((EditBox*) Control);
		else if (f->WidgetData->ObjectType == OutputBoxObject)
			retval = ShowOutputBox((OutputBox*) Control);
		else if (f->WidgetData->ObjectType == ProgressBarObject)
			retval = ShowProgressBar((ProgressBar*) Control);
		else if (f->WidgetData->ObjectType == TickBoxObject)
			retval = ShowTickBox((TickBox*) Control);
		else if (f->WidgetData->ObjectType == RadioButtonObject)
			retval = ShowRadioButton((RadioButton*) Control);
		else if (f->WidgetData->ObjectType == WindowObject || f->WidgetData->ObjectType == ScreenObject || f->WidgetData->ObjectType == TimerObject)
			{}
		// Now we've shown it, see if there are any other controls that form part of the
		// same control and, if so, show them (e.g. pre/post text).
		while (child)
			{
			if (child->WidgetData->ParentControl == f)
				retval = retval && Show(child);
			child = child->WidgetData->NextWidget;
			}
		}
	return retval;
	}

/*	This function deactivates a string gadget in the only way that works properly on an A500.  It fakes
	a return key press in the gadget (DeActivateStrGad()) and then clears the window's message port so
	that the GadgetUp message for the gadget is never seen by our message loop. */
void DeactivateUnknownEditBox(void)
	{
	unsigned long signals;

	struct Gadget *g;
	GuiWindow *w = Gui.GWLfirst;

	while (w)
		{
		g = w->Win->FirstGadget;
		while (g)
			{
			if (g->GadgetType == GTYP_STRGADGET && g->Flags & GFLG_SELECTED)
				{
				DeActivateStrGad(); // Will cause a gadgetup message
				signals = Wait(w->WindowSig);

				if (signals & w->WindowSig)
					{
					struct IntuiMessage *WinMsg;
					while (WinMsg = (struct IntuiMessage *) GetMsg(w->Win->UserPort))
						ReplyMsg((struct Message *) WinMsg);
					}
				}
			g = g->NextGadget;
			}
		w = w->next;
		}
	}

BOOL FOXLIB SetEditBoxFocus(REGA0 EditBox *p)
   {
	if (p && p->enabled && p->hidden == 0)
		{
		BOOL retval;

		DeactivateUnknownEditBox();
		retval = ActivateGadget(&p->editbox, ((GuiWindow *) p->editbox.UserData)->Win, NULL);
		/*	Set editptr so that the EditBoxSelected() function (which was probably where the user's validation
			function which called this was called from) knows that the user's already put the focus where they
			want it. */
		editptr = p;
		return Diagnostic("SetEditBoxFocus", EXIT, retval);
		}
	return Diagnostic("SetEditBoxFocus", EXIT, FALSE);
	}

/*	Convert RAWKEYs into VANILLAKEYs, also shows special keys like HELP, Cursor Keys, FKeys, etc.  It
	returns -1 if not enough room in the buffer, try again with a bigger buffer otherwise, returns the
	number of characters placed in the buffer. */
static long deadKeyConvert(struct IntuiMessage *msg, unsigned char *kbuffer, long kbsize,
		struct KeyMap *kmap, struct InputEvent *ievent)
	{
	ievent->ie_Class = IECLASS_RAWKEY;
	ievent->ie_Code = msg->Code;
	ievent->ie_Qualifier = msg->Qualifier;
	ievent->ie_position.ie_addr = *((APTR*)msg->IAddress);

	return(RawKeyConvert(ievent, kbuffer, kbsize, kmap));
	}

// doKeys() - Show what keys were pressed.
static BOOL GetConvertedKeys(struct IntuiMessage *msg, unsigned short *numchars)
	{
	BOOL ret_code = TRUE;

/* deadKeyConvert() returns -1 if there was not enough space in the buffer to convert the string. Here,
	the routine increases the size of the buffer on the fly...Set the return code to FALSE on failure. */

	*numchars = deadKeyConvert(msg, RKCbuffer, RKCbufferSize - 1, NULL, RKCevent);
	while (*numchars == -1 && RKCbuffer)
		{
		// Conversion failed, buffer too small. try to double the size of the buffer.
		GuiFree(RKCbuffer);
		RKCbufferSize = RKCbufferSize << 1;

		if (NULL == (RKCbuffer = (unsigned char*) GuiMalloc(RKCbufferSize, MEMF_CLEAR)))
			ret_code = FALSE;
		else
			*numchars = deadKeyConvert(msg, RKCbuffer, RKCbufferSize - 1, NULL, RKCevent);
		}

/* numchars contains the number of characters placed within the buffer.  Key up events and   
	key sequences that do not generate any data for the program (like deadkeys) will return   
	zero.  Special keys (like HELP, the cursor keys, FKeys, etc.) return multiple characters  
	that have to then be parsed by the application.  Allocation failed above if buffer is NULL */

/*	if (RKCbuffer)
		{
		unsigned char realc, c;
		unsigned short char_pos;

		// if high bit set, then this is a key up otherwise this is a key down
		if (msg->Code & 0x80)
			fprintf(stderr, "Key Up:   ");
		else
			fprintf(stderr, "Key Down: ");

		fprintf(stderr, " rawkey #%d maps to %d ASCII character(s)\n", 0x7F & msg->Code, *numchars);

		for (char_pos = 0; char_pos < *numchars; char_pos++)
			{
			realc = c = RKCbuffer[char_pos];
			if (c <= 0x1F || (c >= 0x80 && c < 0xa0))
				c = 0x7f;
			fprintf(stderr, "  %3d ($%02x) = %c\n", realc, realc, c);
			}
		} */
	return(ret_code);
	}

#ifdef NEVER
struct IntuiMessage ActivateMessage;
static void SendActivateMessage(EditBox *e)
	{
	fprintf(stderr, "Sending message...\n");
	ActivateMessage.ExecMessage.mn_Node.ln_Type = 5;
	ActivateMessage.ExecMessage.mn_Node.ln_Pri = 0;
	ActivateMessage.ExecMessage.mn_Node.ln_Name = "Simon woz ere";
	ActivateMessage.ExecMessage.mn_ReplyPort = e->win->Win->WindowPort;
	ActivateMessage.ExecMessage.mn_Length = 32;
	ActivateMessage.Class = GADGETDOWN;
	ActivateMessage.Code = 0;
	ActivateMessage.Qualifier = 49152;
	ActivateMessage.IAddress = &(e->editbox);
	ActivateMessage.MouseX = e->x + 1;
	ActivateMessage.MouseY = e->y + 1;
	ActivateMessage.IDCMPWindow = e->win->Win;
	ActivateMessage.SpecialLink = NULL;
	CurrentTime(&(ActivateMessage.Seconds), &(ActivateMessage.Micros));
	Forbid();
	PutMsg(e->win->Win->UserPort, &(ActivateMessage.ExecMessage));
	Permit();
	}

static void DisplayMessage(struct IntuiMessage *ActivateMessage)
	{
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_Node.ln_Succ = %ld\n", ActivateMessage->ExecMessage.mn_Node.ln_Succ);
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_Node.ln_Pred = %ld\n", ActivateMessage->ExecMessage.mn_Node.ln_Pred);
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_Node.ln_Type = %d\n",  ActivateMessage->ExecMessage.mn_Node.ln_Type);
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_Node.ln_Pri  = %d\n",  ActivateMessage->ExecMessage.mn_Node.ln_Pri);
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_Node.ln_Name = %s\n",  ActivateMessage->ExecMessage.mn_Node.ln_Name);
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_ReplyPort    = %ld\n", ActivateMessage->ExecMessage.mn_ReplyPort);
	fprintf(stderr, "ActivateMessage->ExecMessage.mn_Length       = %ld\n", ActivateMessage->ExecMessage.mn_Length);
	fprintf(stderr, "ActivateMessage->Class                       = %ld\n", ActivateMessage->Class);
	fprintf(stderr, "ActivateMessage->Code                        = %d\n",  ActivateMessage->Code);
	fprintf(stderr, "ActivateMessage->Qualifier                   = %d\n",  ActivateMessage->Qualifier);
	fprintf(stderr, "ActivateMessage->IAddress                    = %ld\n", ActivateMessage->IAddress);
	fprintf(stderr, "ActivateMessage->MouseX                      = %d\n",  ActivateMessage->MouseX);
	fprintf(stderr, "ActivateMessage->MouseY                      = %d\n",  ActivateMessage->MouseY);
	fprintf(stderr, "ActivateMessage->Seconds                     = %ld\n", ActivateMessage->Seconds);
	fprintf(stderr, "ActivateMessage->Micros                      = %ld\n", ActivateMessage->Micros);
	fprintf(stderr, "ActivateMessage->IDCMPWindow                 = %ld\n", ActivateMessage->IDCMPWindow);
	fprintf(stderr, "ActivateMessage->SpecialLink                 = %ld\n", ActivateMessage->SpecialLink);
//	fprintf(stderr, "sizeof(struct IntuiMessage)                  = %ld\n", sizeof(struct IntuiMessage));
//	fprintf(stderr, "sizeof(ActivateMessage->ExecMessage)         = %ld\n", sizeof(ActivateMessage->ExecMessage));
//	fprintf(stderr, "sizeof(ActivateMessage->ExecMessage.mn_Node) = %ld\n", sizeof(ActivateMessage->ExecMessage.mn_Node));
	}
#endif

short FOXLIB LibVersion(void)
	{
	return Gui.LibVersion;
	}

void GetWorkbenchSettings(void)
	{
	struct Screen *PubScreen;
	Gui.WBPen[0] = (unsigned short) ~0;
	if (Gui.LibVersion >= A500PLUS)
		{
		PubScreen = LockPubScreen("Workbench");
		if (PubScreen)
			{
			struct DrawInfo *wbinfo = GetScreenDrawInfo(PubScreen);
			if (wbinfo)
				{
				int l;
				Gui.WBMode = GetVPModeID(&(PubScreen->ViewPort));
				Gui.WBDepth = wbinfo->dri_Depth;
				for (l = 0; l <= NUM_WB_PENS - 1; l++)
					Gui.WBPen[l] = wbinfo->dri_Pens[l];
				Gui.WBPen[NUM_WB_PENS] = (unsigned short) ~0;
				FreeScreenDrawInfo(PubScreen, wbinfo);
				}
			UnlockPubScreen("Workbench", PubScreen);
			}
		else
			return;
		}
	}

#ifdef DIAGNOSTICS
void GuiReportError(char *error, short type)
   {
   if (Gui.DebugFile)
      fprintf(Gui.DebugFile, error);
   if (type == GUI_ERROR)
      fprintf(stderr, error);
#ifdef DEBUG
	// DEBUG is automatically defined by lc if -d1, -d2, -d3 or -d4 is
	// passed to lc.
	kprintf(error);
#endif
   }
#endif

unsigned short GuiDragPointer[] =
	{
	0x0000, 0x0000,

	0x0100, 0x0000,
	0x0380, 0x0000,
	0x07c0, 0x0000,
	0x0100, 0x0000,
	0x0100, 0x0000,
	0x2108, 0x0000,
	0x610c, 0x0000,
	0xfffe, 0x0000,
	0x610c, 0x0000,
	0x2108, 0x0000,
	0x0100, 0x0000,
	0x0100, 0x0000,
	0x07c0, 0x0000,
	0x0380, 0x0000,
	0x0100, 0x0000,
	0x0000, 0x0000,

	0xffff, 0xffff
	};

unsigned short waitPointer[] =
	{
	0x0000, 0x0000,

	0x0400, 0x07C0,
	0x0000, 0x07C0,
	0x0100, 0x0380,
	0x0000, 0x07E0,
	0x07C0, 0x1FF8,
	0x1FF0, 0x3FEC,
	0x3FF8, 0x7FDE,
	0x3FF8, 0x7FBE,
	0x7FFC, 0xFF7F,
	0x7EFC, 0xFFFF,
	0x7FFC, 0xFFFF,
	0x3FF8, 0x7FFE,
	0x3FF8, 0x7FFE,
	0x1FF0, 0x3FFC,
	0x07C0, 0x1FF8,
	0x0000, 0x07E0,

	0x0000, 0x0000,
	};

BOOL FOXLIB SleepPointer(REGA0 GuiWindow *win)
	{
	Diagnostic("SleepPointer", ENTER, TRUE);
	if (!win->Sleep)
		{
		InitRequester(&(win->Request));
		/* Putting a NULL requester in the window on an A500 (v34) succeeds but
			returns FALSE anyway!  So, if its an A500, assume success.  This may be
			a little dangerous but what do you expect from a bugged OS? */
		if (Request(&(win->Request), win->Win) || Gui.LibVersion < A3000)
			win->Sleep = TRUE;
		}
	if (win->Sleep && ChipMemForPointer)
		SetPointer(win->Win, ChipMemForPointer, 16, 16, -6, 0);
	Diagnostic("SleepPointer", EXIT, win->Sleep);
	return win->Sleep;
	}

void FOXLIB WakePointer(REGA0 GuiWindow *win)
	{
	int retval = win->Sleep;

	Diagnostic("WakePointer", ENTER, TRUE);
	if (win->Sleep)
		{
		EndRequest(&(win->Request), win->Win);
		if (ChipMemForPointer)
			ClearPointer(win->Win);
		win->Sleep = FALSE;
		}
	Diagnostic("WakePointer", EXIT, retval);
	}

void FOXLIB UseSafeMallocs(void)
{
	FastMallocs = FALSE;
}

// Priority 5001 - just after initialisation of auto variables.
int _STI_5001_InitGui(void)
   {
   Diagnostic("InitGui", ENTER, TRUE);
   Gui.DebugFile = NULL; // no-longer supported
	Gui.Proc = (struct Process *) FindTask(NULL);
   Gui.NumAllocs = 0;
   Gui.CleanupFlag = Gui.DroppingList = Gui.ListFocusOnly = FALSE;
   Gui.GGLfirst = NULL;
   Gui.GWLfirst = NULL;
   Gui.FirstEditBox = NULL;
	Gui.FirstListBox = NULL;
   Gui.FirstOutputBox = NULL;
	Gui.FirstTickBox = NULL;
	Gui.FirstRadioButton = NULL;
	Gui.FirstFrame = NULL;
	Gui.FirstTimer = NULL;
	Gui.FirstProgressBar = NULL;
	Gui.FirstTabControl = NULL;
	Gui.FirstUserGadget = NULL;
   memset(&(Gui.Message1), 0, sizeof(struct IntuiText));
   memset(&(Gui.Message2), 0, sizeof(struct IntuiText));
   memset(&(Gui.Message3), 0, sizeof(struct IntuiText));
   Gui.Message1.TopEdge =  0;
   Gui.Message2.TopEdge = 12;
   Gui.Message3.TopEdge = 24;
   Gui.Message1.ITextFont = Gui.Message2.ITextFont = Gui.Message3.ITextFont = &GuiFont;
   Gui.MessageNWin.IDCMPFlags  = 0;
   Gui.MessageNWin.FirstGadget = NULL;
   Gui.MessageNWin.CheckMark   = NULL;
   Gui.MessageNWin.BitMap      = NULL;
   Gui.MessageNWin.Title       = NULL;
   Gui.MessageNWin.Type        = CUSTOMSCREEN;
   Gui.MessageNWin.Flags       = SMART_REFRESH | NOCAREREFRESH;
   Gui.MessageDisplayed = FALSE;
   Gui.consig = Gui.winsig = Gui.scrsig = 0;
	Gui.HiPen = 1;
	Gui.LoPen = 2;
	Gui.BorderCol = Gui.TextCol = 1;
	Gui.BackCol = 0;
	FastMallocs = TRUE;
	GuiFont.ta_Name = GuiMalloc(11 * sizeof(char), 0);
	if (GuiFont.ta_Name)
		strcpy(GuiFont.ta_Name, "topaz.font");
	GuiFont.ta_YSize = 8;
	GuiFont.ta_Style = 0;
	GuiFont.ta_Flags = NULL;
	GuiULFont.ta_Name = GuiFont.ta_Name;
	GuiULFont.ta_YSize = 8;
	GuiULFont.ta_Style = 0;
	GuiULFont.ta_Flags = NULL;

	IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library", 33);
	if (!IntuitionBase)
		{
		SetLastErr("FoxGUI requires Intuition version 33 or above.");
		Diagnostic("InitGui", EXIT, FALSE);
		return 1;
		}
	Gui.LibVersion = ((struct Library *) IntuitionBase)->lib_Version;
	SetPeriod(24);
	SetDelay(240);

	// Open the console device just to do keymapping. (unit -1 means any unit)
	if (0 == OpenDevice("console.device", -1, (struct IORequest *) &ioreq, 0))
		{
		ConsoleDevice = (struct Library *)ioreq.io_Device;
		if (!(RKCbuffer = (unsigned char*) calloc(1, RKCbufferSize)))
			{
			CloseDevice((struct IORequest *) &ioreq);
			ConsoleDevice = NULL;
			}
		if (!(RKCevent = (struct InputEvent*) calloc(1, sizeof(struct InputEvent))))
			{
			free(RKCbuffer);
			CloseDevice((struct IORequest *) &ioreq);
			ConsoleDevice = NULL;
			}
		}
	if (!ConsoleDevice)
		SetLastErr("Failed to open console for raw key conversions");

   GfxBase = (struct GfxBase *) OpenLibrary("graphics.library", Gui.LibVersion);
   if (!GfxBase)
		{
		Diagnostic("InitGui", EXIT, FALSE);
		return 1;
		}
	if (!(LayersBase = OpenLibrary("layers.library", 0L)))
		{
		Diagnostic("InitGui", EXIT, FALSE);
		return 1;
		}

	IFFParseBase = /*(struct IFFParseBase *)*/ OpenLibrary("iffparse.library", 0L);

	if (!(ChipMemForPointer = (unsigned short *) AllocMem(sizeof(waitPointer), MEMF_CHIP)))
		{
		Diagnostic("InitGui", EXIT, FALSE);
		return 1;
		}
	else
		memcpy(ChipMemForPointer, waitPointer, sizeof(waitPointer));

	if (!(ChipMemForDragPointer = (unsigned short *) AllocMem(sizeof(GuiDragPointer), MEMF_CHIP)))
		{
		Diagnostic("InitGui", EXIT, FALSE);
		return 1;
		}
	else
		memcpy(ChipMemForDragPointer, GuiDragPointer, sizeof(GuiDragPointer));

	GetWorkbenchSettings();

	Diagnostic("InitGui", EXIT, TRUE);
	return 0;
   }

BOOL FOXLIB SetGuiPensFromPubScreen(REGA0 char *pub_screen_name)
{
	BOOL retval = FALSE;
	struct Screen *pub_screen = NULL;
	struct DrawInfo *screen_drawinfo = NULL;

	if (pub_screen_name)
		pub_screen = LockPubScreen(pub_screen_name);

	if (pub_screen != NULL)
	{
		// Get the DrawInfo structure from the locked screen.  This returns pen, depth and font info.
		screen_drawinfo = GetScreenDrawInfo(pub_screen);
		if (screen_drawinfo != NULL)
		{
			SetGuiPens(screen_drawinfo->dri_Pens[SHINEPEN], screen_drawinfo->dri_Pens[SHADOWPEN]);
			retval = TRUE;
			FreeScreenDrawInfo(pub_screen, screen_drawinfo);
		}
		UnlockPubScreen(pub_screen_name, pub_screen);
	}

	return retval;
}

void FOXLIB SetGuiPens(REGD0 short hipen, REGD1 short lopen)
	{
	Gui.HiPen = hipen;
	Gui.LoPen = lopen;
	}

/*	Documentation for this function and DestroyMessage() have been excluded from FoxGui.guide
	because the functions themselves are in such poor shape.  They need completely re-thinking. */

BOOL FOXLIB ShowMessage(REGA0 GuiScreen *scr, REGA1 char *a, REGA2 char *b, REGA3 char *c, REGD0 int col)
   {
	int lena = a ? strlen(a) : 0, lenb = b ? strlen(b) : 0, lenc = c ? strlen(c) : 0;

   Diagnostic("ShowMessage", ENTER, TRUE);
   if (Gui.MessageDisplayed)
      return Diagnostic("ShowMessage", EXIT, FALSE);
   Gui.MessageDisplayed = TRUE;
   Gui.Message1.FrontPen = Gui.Message2.FrontPen = Gui.Message3.FrontPen = col;
   Gui.Message1.IText = a;
   Gui.Message2.IText = b;
   Gui.Message3.IText = c;
   if (b)
      Gui.Message1.NextText = &(Gui.Message2);
   if (c)
      Gui.Message2.NextText = &(Gui.Message3);
   Gui.MessageNWin.Width    = 8 * (max(lena, max(lenb, lenc)) + 6);
   Gui.MessageNWin.Height   = (12 * (1 + ((a) ? 1 : 0) + ((b) ? 1 : 0) + ((c) ? 1 : 0)));
   Gui.MessageNWin.LeftEdge = (640 - Gui.MessageNWin.Width) / 2;
   Gui.MessageNWin.TopEdge  = (256 - Gui.MessageNWin.Height) / 2;
   Gui.MessageNWin.BlockPen = Gui.MessageNWin.DetailPen = col;
   Gui.MessageNWin.Screen   = scr->scr;
   Gui.Message1.LeftEdge = (Gui.MessageNWin.Width - (lena * 8)) /2;
   Gui.Message2.LeftEdge = (Gui.MessageNWin.Width - (lenb * 8)) /2;
   Gui.Message3.LeftEdge = (Gui.MessageNWin.Width - (lenc * 8)) /2;
   Gui.MessageWin = (struct Window *) OpenWindow(&(Gui.MessageNWin));
   if (!(Gui.MessageWin))
      {
      Gui.Message1.IText = Gui.Message2.IText = Gui.Message3.IText = NULL;
      Gui.Message1.NextText = Gui.Message2.NextText = NULL;
      Gui.MessageDisplayed = FALSE;
      return Diagnostic("ShowMessage", EXIT, FALSE);
      }
   PrintIText(Gui.MessageWin->RPort, &(Gui.Message1), 0, 8);
   return Diagnostic("ShowMessage", EXIT, TRUE);
   }

BOOL FOXLIB DestroyMessage(void)
   {
   Diagnostic("DestroyMessage", ENTER, TRUE);
   if (!Gui.MessageDisplayed)
      return Diagnostic("DestroyMessage", EXIT, FALSE);
   CloseWindow(Gui.MessageWin);
   Gui.MessageDisplayed = FALSE;
   Gui.Message1.IText = Gui.Message2.IText = Gui.Message3.IText = NULL;
   Gui.Message1.NextText = Gui.Message2.NextText = NULL;
   return Diagnostic("DestroyMessage", EXIT, TRUE);
   }

void FOXLIB SetPeriod(REGD0 int time)
   {
   Diagnostic("SetPeriod", ENTER, TRUE);
   Gui.ARperiod = time;
   Diagnostic("SetPeriod", EXIT, TRUE);
   }

void FOXLIB SetDelay(REGD0 int time)
   {
   Diagnostic("SetDelay", ENTER, TRUE);
   Gui.ARdelay = time;
   Diagnostic("SetDelay", EXIT, TRUE);
   }

static void RefreshProgressBar(ProgressBar *pb)
	{
	if (pb && pb->hidden == 0)
		{
		int width, height, BevelHeight = pb->BevelPoints[7], BevelWidth = pb->BevelPoints[0] - 2,
				backcol = GetBackCol(pb->WidgetData->Parent);

		if (pb->WidgetData->flags & PB_FILL_BT)
			{
			height = pb->iprogress * BevelHeight / pb->max;
			width = BevelWidth;
			AreaColFill(pb->win->Win->RPort, pb->light.LeftEdge + 2, pb->light.TopEdge + 1, width,
					BevelHeight - height, backcol);
			}
		else
			{
			height = BevelHeight;
			width = pb->iprogress * BevelWidth / pb->max;
			AreaColFill(pb->win->Win->RPort, pb->light.LeftEdge + 2 + width, pb->light.TopEdge + 1,
					BevelWidth - width, BevelHeight, backcol);
			}
		AreaColFill(pb->win->Win->RPort, pb->light.LeftEdge + 2, (pb->WidgetData->flags & PB_FILL_BT ?
				BevelHeight - height : 0) + pb->light.TopEdge + 1, width, height, pb->fillcol);
		PrintIText(pb->win->Win->RPort, &pb->progress, 0, 0);
		DrawBorder(pb->win->Win->RPort, &pb->light, 0, 0);
		}
	}

static void setprogress(ProgressBar *pb, int progress, BOOL oldtext)
	{
	if (pb)
		{
		int penhold = pb->progress.FrontPen;

		// Blank out the previous text
		if (oldtext && pb->hidden == 0)
			{
			pb->progress.FrontPen = GetBackCol(pb->WidgetData->Parent);
			PrintIText(pb->win->Win->RPort, &(pb->progress), 0, 0);
			pb->progress.FrontPen = penhold;
			}

		pb->iprogress = min(progress, pb->max);
		pb->iprogress = max(pb->iprogress, 0);

		// Update the text
		if (pb->max == 100)
			sprintf(pb->progress.IText, "%-d%%", pb->iprogress);
		else
			sprintf(pb->progress.IText, "%-d", pb->iprogress);
		if ((pb->WidgetData->flags & PB_CAPTION_TOP_LEFT) || pb->WidgetData->flags & PB_CAPTION_BOTTOM_LEFT)
			{
			// Leave LeftEdge unchanged.  Unfortunately we need this IF statement here because the ELSE
			// part has to include TOP_RIGHT because that has a flag value of 0 so we can't check for it
			// directly!
			}
		else if (pb->WidgetData->flags & PB_CAPTION_CENTRE)
			pb->progress.LeftEdge = pb->light.LeftEdge - 1 +
					((pb->BevelPoints[12] + 1 - IntuiTextLength(&(pb->progress)))/2);
		else
			pb->progress.LeftEdge = pb->light.LeftEdge + pb->BevelPoints[12] - IntuiTextLength(&(pb->progress));
		RefreshProgressBar(pb);
		}
	}

void FOXLIB SetProgress(REGA0 ProgressBar *pb, REGD0 int progress)
	{
	setprogress(pb, progress, TRUE);
	}

void FOXLIB SetProgressMax(REGA0 ProgressBar *pb, REGD0 int progressmax)
	{
	if (pb && progressmax)
		{
		char *newtext, progtext[100]; // Excessive!

		sprintf(progtext, "%-d", progressmax);
		newtext = (char *) GuiMalloc((strlen(progtext) + 1) * sizeof(char), 0);
		if (newtext)
			{
			if (pb->hidden == 0)
				{
				int penhold = pb->progress.FrontPen;
				pb->progress.FrontPen = pb->win->Win->RPort->BgPen;
				PrintIText(pb->win->Win->RPort, &(pb->progress), 0, 0);
				pb->progress.FrontPen = penhold;
				}
			GuiFree(pb->progress.IText);
			pb->progress.IText = newtext;
			pb->max = progressmax;
			setprogress(pb, pb->iprogress, FALSE);
			}
		}
	}

static void UndrawProgressBar(ProgressBar *pb)
	{
	if (pb)
		{
		int penhold = pb->progress.FrontPen;
		BYTE BackCol = GetBackCol(pb->WidgetData->Parent);

		AreaColFill(pb->win->Win->RPort, pb->light.LeftEdge, pb->light.TopEdge, pb->BevelPoints[12]+1,
				pb->BevelPoints[5]+1, BackCol);
		// Blank out the text
		pb->progress.FrontPen = BackCol;
		PrintIText(pb->win->Win->RPort, &(pb->progress), 0, 0);
		pb->progress.FrontPen = penhold;
		}
	}

BOOL ShowProgressBar(ProgressBar *pb)
	{
	if (pb)
		{
		if (pb->hidden == 1) // The progress bar is really hidden
			if ((!ISGUIWINDOW(pb->WidgetData->Parent)) && ((Frame *) pb->WidgetData->Parent)->hidden != 0)
				pb->hidden = -1; // The progress bar is in a hidden frame so it will remain hidden
			else
				pb->hidden = 0;
		if (pb->hidden == 0)
			RefreshProgressBar(pb);
		return TRUE;
		}
	return FALSE;
	}

BOOL HideProgressBar(ProgressBar *pb)
	{
	if (pb)
		{
		if (pb->hidden == 0)
			UndrawProgressBar(pb);
		pb->hidden = 1;
		return TRUE;
		}
	return FALSE;
	}

void DestroyProgressBar(ProgressBar *pb, BOOL refresh)
	{
	if (pb)
		{
		Frame *Child; // Could be any type of object
		if (refresh)
			HideProgressBar(pb);

		if (pb->progress.ITextFont)
			{
			if (pb->progress.ITextFont->ta_Name)
				GuiFree(pb->progress.ITextFont->ta_Name);
			GuiFree(pb->progress.ITextFont);
			}

		GuiFree(pb->progress.IText);
		if (pb->WidgetData->os)
			GuiFree(pb->WidgetData->os);
		if (pb == Gui.FirstProgressBar)
			Gui.FirstProgressBar = pb->Next;
		else
			{
			ProgressBar *n = Gui.FirstProgressBar;
			while (n->Next && n->Next != pb)
				n = n->Next;
			if (n->Next == pb)
				n->Next = pb->Next;
			}
		Child = pb->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, refresh);
			Child = next;
			}
		GuiFree(pb->WidgetData);
		GuiFree(pb);
		}
	}

void ResizeProgressBar(ProgressBar *pb, int x, int y, int width, int height, BOOL eraseold)
	{
	unsigned short FontHeight = GetFontHeight(pb->win);

	if (eraseold && GetBackCol(pb->WidgetData->Parent) == pb->win->Win->RPort->BgPen)
		UndrawProgressBar(pb);

	MakeBevel(&(pb->light), &(pb->dark), pb->BevelPoints, x, y, width, height, pb->WidgetData->flags & PB_INSET ?
			FALSE : TRUE);

	if (pb->WidgetData->flags & PB_CAPTION_TOP_LEFT || pb->WidgetData->flags & PB_CAPTION_BOTTOM_LEFT)
		pb->progress.LeftEdge = x;
	/*	No need to set the LeftEdge if the caption is on the right or in the centre.  It will get done
		in SetProgress(). */
	if (pb->WidgetData->flags & PB_CAPTION_CENTRE)
		pb->progress.TopEdge = y + ((height - FontHeight)/2);
	else if (pb->WidgetData->flags & PB_CAPTION_BOTTOM_LEFT || pb->WidgetData->flags & PB_CAPTION_BOTTOM_RIGHT)
		pb->progress.TopEdge = y + height + 2;
	else
		pb->progress.TopEdge = y - FontHeight - 2;
	pb->WidgetData->left = x;
	pb->WidgetData->top = y;
	pb->WidgetData->width = width;
	pb->WidgetData->height = height;
	}

ProgressBar* FOXLIB MakeProgressBar(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width,
		REGD3 int height, REGD4 short fillcol, REGD5 short flags, REGA1 void *extension)
	{
	if (Parent && width && height)
		{
		ProgressBar *pb;
		GuiWindow *win;
		Frame *ParentFrame = NULL;

		if (!(pb = (ProgressBar *) GuiMalloc(sizeof(ProgressBar), 0)))
			return NULL;
		if (!(pb->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)))
		{
			GuiFree(pb);
			return NULL;
		}
		pb->WidgetData->ObjectType = ProgressBarObject;
		pb->WidgetData->Parent = Parent;
		pb->WidgetData->NextWidget = NULL;
		pb->WidgetData->ChildWidget = NULL;
		// Assume progress % - "100%" is longest text.
		if (!(pb->progress.IText = (char *) GuiMalloc(5 * sizeof(char), 0)))
			{
			GuiFree(pb->WidgetData);
			GuiFree(pb);
			return NULL;
			}

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
			if (!(pb->WidgetData->os = (OriginalSize *) GuiMalloc(sizeof(OriginalSize), 0)))
				{
				GuiFree(pb->progress.IText);
				GuiFree(pb->WidgetData);
				GuiFree(pb);
				return NULL;
				}
			pb->WidgetData->os->left = left;
			pb->WidgetData->os->top = top;
			pb->WidgetData->os->width = width;
			pb->WidgetData->os->height = height;
			}
		else
			pb->WidgetData->os = NULL;

		pb->win = win;
		pb->WidgetData->flags = flags;
		pb->fillcol = fillcol;
		pb->max = 100;
		if (ParentFrame && ParentFrame->hidden != 0)
			pb->hidden = -1;
		else
			pb->hidden = 0;

		pb->progress.DrawMode = JAM1;
		pb->progress.FrontPen = Gui.TextCol;
		pb->progress.ITextFont = CopyFont(&GuiFont);
		pb->progress.NextText = NULL;

		ResizeProgressBar(pb, left, top, width, height, FALSE);

		pb->Next = Gui.FirstProgressBar;
		Gui.FirstProgressBar = pb;
		setprogress(pb, 0, FALSE);
		return pb;
		}
	return NULL;
	}

BOOL DestroyTimer(Timer *t)
	{
	if (t)
		{
		Frame *Child; // Could be any type of control
		Timer *n = Gui.FirstTimer, *np = NULL;
		while (n && n != t)
			{
			np = n;
			n = n->NextTimer;
			}
		if (!n)
			return FALSE;
		if (np)
			np->NextTimer = n->NextTimer;
		else
			Gui.FirstTimer = n->NextTimer;
		Child = n->WidgetData->ChildWidget;
		while (Child)
			{
			void *next = Child->WidgetData->NextWidget;
			Child->WidgetData->ParentControl = NULL; // Otherwise destroy will fail.
			Destroy(Child, TRUE);
			Child = next;
			}
		GuiFree(n->WidgetData);
		GuiFree(n);
		return TRUE;
		}
	return FALSE;
	}

void DestroyAllTimers(void)
	{
	while (Gui.FirstTimer)
		DestroyTimer(Gui.FirstTimer);
	}

Timer* FOXLIB MakeTimer(REGD0 short flags, REGA0 int (* __far __stdargs CallFn) (Timer *, long), REGA1 void *extension)
	{
	Timer *t = (Timer*) GuiMalloc(sizeof(Timer), 0);

	if (t)
		{
		if (!(t->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)))
			{
			GuiFree(t);
			return NULL;
			}
		t->WidgetData->ObjectType = TimerObject;
		t->WidgetData->flags = flags;
		t->WidgetData->left = 0;
		t->WidgetData->top = 0;
		t->WidgetData->width = 0;
		t->WidgetData->height = 0;
		t->WidgetData->NextWidget = NULL;
		t->WidgetData->ChildWidget = NULL;
		t->running = FALSE;
		t->Callfn = CallFn;
		t->NextTimer = Gui.FirstTimer;
		Gui.FirstTimer = t;
		}
	return t;
	}

void FOXLIB StartTimer(REGA0 Timer *t)
	{
	if (t)
		{
		t->lasttrigger = t->starttimesecs = t->timesecs = time(NULL);
		t->running = TRUE;
		t->paused = FALSE;
		}
	}

void FOXLIB StopTimer(REGA0 Timer *t)
	{
	if (t)
		{
		t->timesecs = time(NULL);
		t->running = FALSE;
		}
	}

void FOXLIB PauseTimer(REGA0 Timer *t)
	{
	if (t)
		if (!t->paused)
			{
			t->pausetimesecs = time(NULL);
			t->running = FALSE;
			t->paused = TRUE;
			}
	}

void FOXLIB UnpauseTimer(REGA0 Timer *t)
	{
	if (t)
		if (t->paused)
			{
			t->starttimesecs += time(NULL) - t->pausetimesecs;
			t->running = TRUE;
			t->paused = FALSE;
			}
	}

void FOXLIB AddTime(REGA0 Timer *t, REGD0 long secs)
	{
	if (t && secs)
		t->starttimesecs -= secs;
	}

void FOXLIB SetTime(REGA0 Timer *t, REGD0 long secs)
	{
	if (t && secs)
		{
		t->starttimesecs = time(NULL) - secs;
		if (t->paused)
			t->pausetimesecs = t->starttimesecs + secs;
		}
	}

static void WinPrintReverse(GuiWindow *win, char *text, int width)
	{
	int i;
	WinPrint(win, "\033[7m");
	WinPrint(win, text);
	for (i = strlen(text) + 1; i <= width; i++)
		WinPrint(win, " ");
	WinPrint(win, "\033[0m");
	}

static void WinPrintWidth(GuiWindow *win, char *text, int width)
	{
	int i;
	WinPrint(win, text);
	for (i = strlen(text) + 1; i <= width; i++)
		WinPrint(win, " ");
	}

void DrawRPLines(struct RastPort *rp, short *points, int count, int col, BYTE mode, int xoffset, int yoffset)
	{
   struct Border border;
   memset(&border, 0, sizeof(struct Border));
   border.FrontPen = col;
   border.DrawMode = mode;
   border.Count = count;
   border.XY = points;
   DrawBorder(rp, &border, xoffset, yoffset);
   }

void FOXLIB DrawLines(REGA0 GuiWindow *win, REGA1 short *points, REGD0 int count, REGD1 int col)
   {
	DrawRPLines(win->Win->RPort, points, count, col, JAM1, 0, 0);
	}

static BOOL CloseGuiScreen(GuiScreen *scr)
   {
	GuiScreen *ps = NULL, *s = Gui.FirstScr;
   short temp = Gui.CleanupFlag;
	BOOL success = TRUE;
   Diagnostic("CloseGuiScreen", ENTER, TRUE);
	if (!scr)
		return Diagnostic("CloseGuiScreen", EXIT, FALSE);
   Gui.CleanupFlag = TRUE;
	/*	Close any windows on the screen that are owned by this app.  If the screen is public then there
		may still be windows from other apps that we don't know about. */
   CloseScrWindows(scr);
   Gui.CleanupFlag = temp;

	/* Before V36, CloseScreen() had no return value but there was no such thing as a public screen and
		CloseScreen() never failed.  From V36 onwards, CloseScreen() returns a boolean and will fail if
		there are any windows open on the screen, whether owned by this app or any other! */
	if (Gui.LibVersion < 36)
	   CloseScreen(scr->scr);
	else
		success = CloseScreen(scr->scr);
	if (success)
		{
		while (s && s != scr)
			{
			ps = s;
			s = s->NextScr;
			}
		if (s)
			{
			if (ps)
				ps->NextScr = s->NextScr;
			else
				Gui.FirstScr = s->NextScr;
			}

		if (scr->nsc->Font)
		{
			if (scr->nsc->Font->ta_Name)
				GuiFree(scr->nsc->Font->ta_Name);
			GuiFree(scr->nsc->Font);
		}

	   GuiFree(scr->nsc);
		if (scr->PubName)
			GuiFree(scr->PubName);
		if (scr->LastWinSig)
			FreeSignal(scr->LastWinSig);
		GuiFree(scr->Screen_Tags);
	   GuiFree(scr->WidgetData);
	   GuiFree(scr);
		}
   return Diagnostic("CloseGuiScreen", EXIT, success);
   }

static void CloseAllGuiScreens(void)
	{
	GuiScreen *ns, *s = Gui.FirstScr;

	while (s)
		{
		ns = s->NextScr;
		CloseGuiScreen(s);
		s = ns;
		}
	}

GuiScreen* FOXLIB OpenGuiScreen(REGD0 int Depth, REGD1 int DPen, REGD2 int BPen, REGA0 char *Title,
		REGA1 int (* __far __stdargs LastWinFn)(GuiScreen *), REGD3 int flags, REGA2 char *PubName, REGD4 unsigned long DisplayID,
		REGD5 int OverscanType, REGD6 UWORD *pens, REGA3 void *extension)
   {
   GuiScreen *gs;
   struct ExtNewScreen *ns;
	int NumTags, l;
	unsigned short *pa = NULL;
   Diagnostic("OpenGuiScreen", ENTER, TRUE);

   if (!(ns = (struct ExtNewScreen *) GuiMalloc(sizeof(struct ExtNewScreen), 0)))
      {
      Diagnostic("OpenGuiScreen", EXIT, FALSE);
      return NULL;
      }
   if (!(gs = (GuiScreen *) GuiMalloc(sizeof(GuiScreen), 0)))
      {
      GuiFree(ns);
      Diagnostic("OpenGuiScreen", EXIT, FALSE);
      return NULL;
      }
   if (!(gs->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)))
      {
      GuiFree(gs);
      GuiFree(ns);
      Diagnostic("OpenGuiScreen", EXIT, FALSE);
      return NULL;
      }
	gs->WidgetData->ObjectType = ScreenObject;
	gs->WidgetData->NextWidget = NULL;
	gs->WidgetData->ChildWidget = NULL;
	if (PubName)
		{
		if (strcmp(PubName, "") && Gui.LibVersion >= 36)
			{
			if (!(gs->PubName = (char *) GuiMalloc((strlen(PubName) + 1) * sizeof(char), 0)))
				{
				GuiFree(gs->WidgetData);
				GuiFree(gs);
	      	GuiFree(ns);
   		   Diagnostic("OpenGuiScreen", EXIT, FALSE);
      		return NULL;
				}
			strcpy(gs->PubName, PubName);
			}
		else
			gs->PubName = NULL;
		}
	else
		gs->PubName = NULL;
   gs->nsc = ns;
	for (l = 0; l <= NUM_WB_PENS - 1; l++)
		gs->Pens[l] = Gui.WBPen[l];  /* For now... */
	gs->Pens[NUM_WB_PENS] = (unsigned short) ~0;
	ns->LeftEdge = 0;
   ns->TopEdge = 0;
	ns->Width = (Gui.LibVersion >= 36 ? STDSCREENWIDTH : GfxBase->NormalDisplayColumns);
	ns->Height = STDSCREENHEIGHT;
   ns->Depth = Depth;
   ns->DetailPen = DPen;
   ns->BlockPen = BPen;
	ns->ViewModes = HIRES;
   ns->Type = CUSTOMSCREEN | NS_EXTENDED;
	ns->Font = CopyFont(&GuiFont);
   ns->DefaultTitle = Title;
   ns->Gadgets = NULL;
   ns->CustomBitMap = NULL;

	//	Work out how many tags we need.  Start with 2 (one for pens, one for the TAG_DONE).
	NumTags = 2 + (gs->PubName ? 1 : 0) + (gs->PubName && LastWinFn ? 1 : 0) + (flags & GS_OVERSCAN ? 1 :
			0) + (flags & GS_AUTOSCROLL ? 1 : 0) + (flags & GS_DISPLAY_ID ? 1 : 0);

	if (!(gs->Screen_Tags = (struct TagItem*) GuiMalloc(NumTags * sizeof(struct TagItem), 0)))
		{
		if (gs->PubName)
			GuiFree(gs->PubName);
		GuiFree(gs->WidgetData);
		GuiFree(gs);
  	   GuiFree(ns);
		Diagnostic("OpenGuiScreen", EXIT, FALSE);
     	return NULL;
		}

	ns->Extension = gs->Screen_Tags;
	gs->Screen_Tags[0].ti_Tag = SA_Pens;
	gs->Screen_Tags[0].ti_Data = (unsigned long) gs->Pens;
	gs->LastWinFn = LastWinFn;
	gs->LastWinSig = 0;
	if (gs->PubName)
		{
		/*	Open the screen as a public screen.  Even public screens start off private so we will still
			have to send it public after it has opened. */
		gs->Screen_Tags[1].ti_Tag = SA_PubName;
		gs->Screen_Tags[1].ti_Data = (unsigned long) gs->PubName;
		l = 2;
		if (LastWinFn)
			{
			/*	Set up the screen so that this task will be signalled when the last window closes on this
				public screen. */
			BYTE signal = AllocSignal(-1);
			if (signal == -1)
				{
				GuiFree(gs->PubName);
				GuiFree(gs->WidgetData);
				GuiFree(gs);
	   	   GuiFree(ns);
   	   	Diagnostic("OpenGuiScreen", EXIT, FALSE);
	      	return NULL;
				}
			gs->LastWinSig = signal;
			gs->Screen_Tags[2].ti_Tag = SA_PubSig;
			gs->Screen_Tags[2].ti_Data = (unsigned long) signal;
			l = 3;
			}
		}
	else
		l = 1;
	if (flags & GS_AUTOSCROLL)
		{
		gs->Screen_Tags[l].ti_Tag = SA_AutoScroll;
		gs->Screen_Tags[l++].ti_Data = TRUE;
		}
	if (flags & GS_DISPLAY_ID)
		{
		gs->Screen_Tags[l].ti_Tag = SA_DisplayID;
		gs->Screen_Tags[l].ti_Data = DisplayID;
		ns->ViewModes = gs->Screen_Tags[l++].ti_Data;
		}
	if (flags & GS_INTERLACE)
		ns->ViewModes |= INTERLACE;
	if (flags & GS_OVERSCAN)
		{
		gs->Screen_Tags[l].ti_Tag = SA_Overscan;
		gs->Screen_Tags[l++].ti_Data = OverscanType;
		}
	if (flags & GS_PENS)
	{
		gs->Screen_Tags[0].ti_Data = (unsigned long) pens;
		pa = (unsigned short *) gs->Screen_Tags[0].ti_Data;
	}
	gs->Screen_Tags[l].ti_Tag = TAG_DONE;
	/* Open the screen using the 3D look but in a backwards compatible way
		rather than using OpenScreenTags() or OpenScreenTagList() which are
		simpler but not backwards compatible */
	gs->scr = (struct Screen *) OpenScreen((struct NewScreen *) ns);
   if (!(gs->scr))
      {
		if (gs->PubName)
			GuiFree(gs->PubName);
      GuiFree(ns);
      GuiFree(gs->WidgetData);
      GuiFree(gs);
      Diagnostic("OpenGuiScreen", EXIT, FALSE);
      return NULL;
      }

	gs->NextScr = Gui.FirstScr;
	Gui.FirstScr = gs;

	if (gs->PubName) // Send the screen public!
		PubScreenStatus(gs->scr, 0);

   Diagnostic("OpenGuiScreen", EXIT, TRUE);
   return gs;
   }

struct Screen* FOXLIB GetScreenDetails(REGA0 void *scr, REGA1 unsigned long *mode, REGA2 int *depth, REGA3 char *fontname, REGD0 int bufsize,
		REGD1 int *reqbufsize, REGD2 int *fontheight, REGD3 int *fontstyle, REGD4 UWORD *pens, REGD5 int pensarraysize)
{
	struct Screen *screen = NULL;

	if (ISGUISCREEN(scr))
		screen = ((GuiScreen *) scr)->scr;
	else
		screen = LockPubScreen((UBYTE *) scr);

	if (screen != NULL)
	{
		// Get the DrawInfo structure from the screen.  This returns pen, depth and font info.
		struct DrawInfo *screen_drawinfo = GetScreenDrawInfo(screen);

		if (screen_drawinfo != NULL)
		{
			int reqsize;

			reqsize = strlen(screen_drawinfo->dri_Font->tf_Message.mn_Node.ln_Name) + 1;
			if (reqbufsize)
				*reqbufsize = reqsize;
			if (fontname && bufsize >= reqsize)
				strcpy(fontname, screen_drawinfo->dri_Font->tf_Message.mn_Node.ln_Name);
			else if (fontname)
			{
				strncpy(fontname, screen_drawinfo->dri_Font->tf_Message.mn_Node.ln_Name, bufsize - 1);
				fontname[bufsize - 1] = 0;
			}
			if (fontheight)
				*fontheight = screen_drawinfo->dri_Font->tf_YSize;
			if (fontstyle)
				*fontstyle = screen_drawinfo->dri_Font->tf_Style;

			if (depth)
				*depth = screen_drawinfo->dri_Depth;

			if (pens)
			{
				int i;

				for (i = 0; i < NUMDRIPENS && pensarraysize > i; i++)
					pens[i] = screen_drawinfo->dri_Pens[i];
			}

			FreeScreenDrawInfo(screen, screen_drawinfo);
		}

		if (mode)
			*mode = GetVPModeID(&(screen->ViewPort));

		if (!(ISGUISCREEN(scr)))
			UnlockPubScreen((UBYTE *) scr, screen);
	}
	return screen;
}

GuiScreen* FOXLIB ClonePublicScreen(REGD0 int mindepth, REGA3 UBYTE *pub_screen_name, REGA0 char *sScreenTitle,
		REGA1 int (* __far __stdargs LastWinFn)(GuiScreen *), REGD1 int flags, REGA2 char *new_pub_name, REGD5 int OverscanType,
		REGD2 void *extension)
{
	unsigned long mode;
	int depth, reqfontnamesize, fontheight, fontstyle;
	char fontname[100];
	UWORD pens[NUMDRIPENS];

	GetScreenDetails(pub_screen_name, &mode, &depth, fontname, 100, &reqfontnamesize, &fontheight, &fontstyle, pens, NUMDRIPENS);

	if (flags & GS_CLONEFONT)
		SetDefaultFont(fontname, fontheight, fontstyle);

	if (flags & GS_CLONEPENS)
		SetGuiPens(pens[SHINEPEN], pens[SHADOWPEN]);

	return OpenGuiScreen(max(depth, mindepth), pens[DETAILPEN], pens[BLOCKPEN], sScreenTitle, LastWinFn, GS_AUTOSCROLL | GS_DISPLAY_ID |
			(OverscanType ? GS_OVERSCAN : 0) | GS_PENS, new_pub_name, mode, OverscanType, pens, NULL);
}

void QueueAllMessages(void)
   {
   GuiWindow *gwl = Gui.GWLfirst;
	GuiScreen *gs = Gui.FirstScr;
   Gui.consig = Gui.winsig = Gui.scrsig = 0;
   while (gwl)
      {
		if (gwl->ConReadSig != 0)
	      QRead(gwl, &(Gui.ibuf));
      Gui.winsig |= gwl->WindowSig;
      Gui.consig |= gwl->ConReadSig;
      gwl = gwl->next;
      }
	while (gs)
		{
		Gui.scrsig |= (1L << gs->LastWinSig);
		gs = gs->NextScr;
		}
   }

void AbortAllMessages(void)
   {
   GuiWindow *gwl = Gui.GWLfirst;
   while (gwl)
      {
		if (gwl->ConReadSig != 0)
			{
	      if (!(CheckIO((struct IORequest*) gwl->Con->ConIn)))
   	      AbortIO((struct IORequest*) gwl->Con->ConIn);
	      WaitIO((struct IORequest*) gwl->Con->ConIn);
			}
      gwl = gwl->next;
      }
   }

// Pauses for the specified number of milliseconds or until the button is released.
static struct IntuiMessage *pause(int time, GuiWindow *winptr)
   {
   struct IntuiMessage *ReleaseMessage = NULL;
   unsigned int clock[2], startclock[2];
	register unsigned long elapsed;

	timer(startclock); // Get the seconds and micro seconds of the system clock into the startclock array.
	do
      {
      ReleaseMessage = (struct IntuiMessage *) GetMsg(winptr->Win->UserPort);
      if (ReleaseMessage)
         {
         if (!(ReleaseMessage->Class == GADGETUP || (ReleaseMessage->Class == MOUSEBUTTONS && ReleaseMessage->Code ==
            SELECTUP)))
            {
            ReplyMsg((struct Message *) ReleaseMessage);
            ReleaseMessage = NULL;
            }
         }
		timer(clock);
		// Work out how much time has passed since the start of the loop
		elapsed = ((clock[0] - startclock[0]) * 1000000) + (clock[1] - startclock[1]);
		elapsed /= 1000;
      } while (elapsed < time && !ReleaseMessage);
   return ReleaseMessage;
   }

static PushButton *FindButtonByMsg(struct IntuiMessage *WinMsg)
   {
   PushButton *ggl = Gui.GGLfirst, *RetVal = NULL;
   while (ggl)
      {
      if (&(ggl->button) == (struct Gadget *) WinMsg->IAddress)
         {
         RetVal = ggl;
         break;
         }
      ggl = ggl->Next;
      }
   return RetVal;
   }

static Frame *CheckForChildren(Frame *f, int x, int y)
	{
	/* This function checks to see whether any children of the specified frame are also at this
		position.  If so, the child frame is selected instead. */

	Frame *c = Gui.FirstFrame;

	while (c)
		{
		BOOL rounded = ((c->WidgetData->flags & SYS_FM_ROUNDED) && c->points[1] + 1 >= 6 && !(c->WidgetData->flags & FM_BORDERLESS));
		if (c->WidgetData->Parent == f && x >= c->button.LeftEdge && x <= c->button.LeftEdge + (rounded ? c->points[24]
				: c->points[8]) && y >= c->button.TopEdge && y <= c->button.TopEdge + c->points[1] &&
				c->hidden == 0 && c->Active)
			{
			f = c;
			c = Gui.FirstFrame;
			}
		else
			c = c->next;
		}
	return f;
	}

static Frame *FindFrameByMsg(struct IntuiMessage *WinMsg)
	{
	Frame *f = Gui.FirstFrame, *RetVal = NULL;
	while (f)
		{
		if (&(f->button) == (struct Gadget *) WinMsg->IAddress && f->hidden == 0)
			{
			RetVal = CheckForChildren(f, WinMsg->MouseX, WinMsg->MouseY);
			break;
			}
		f = f->next;
		}
	return RetVal;
	}

static EditBox *FindEditBoxByWin(struct IntuiMessage *WinMsg)
   {
   EditBox *nebl = (WinMsg ? Gui.FirstEditBox : NULL), *RetVal = NULL;
   while (nebl)
      {
      if (&(nebl->editbox) == (struct Gadget *) WinMsg->IAddress)
         {
         RetVal = nebl;
         break;
         }
      nebl = nebl->next;
      }
   return RetVal;
   }

#ifdef NO_LONGER_REQUIRED
static void StoreSysStatus(void)
   {
   PushButton *pb = Gui.GGLfirst;
   EditBox *eb = Gui.FirstEditBox;
	GuiWindow *gw = Gui.GWLfirst;
   while (pb)
      {
      pb->SysStatus = pb->Active;
      pb = pb->Next;
      }
   while (eb)
      {
      eb->SysStatus = eb->enabled;
      eb = eb->next;
      }
	while (gw)
		{
		gw->SysStatus = gw->Enabled;
		gw = gw->next;
		}
   }

static void RestoreSysStatus(BOOL redraw)
   {
   PushButton *pb = Gui.GGLfirst;
   EditBox *eb = Gui.FirstEditBox;
	GuiWindow *gw = Gui.GWLfirst;
   while (pb)
      {
      pb->Active = pb->SysStatus;
      pb = pb->Next;
      }
   while (eb)
      {
      if (eb->list)
         {
         if (eb->SysStatus)
            EnableDDListBox(eb, redraw);
         else
            DisableDDListBox(eb, redraw);
         }
		else
         {
         if (eb->SysStatus)
            EnableEditBox(eb, redraw);
         else
            DisableEditBox(eb, redraw);
         }
      eb = eb->next;
      }
	while (gw)
		{
		gw->Enabled = gw->SysStatus;
		gw = gw->next;
		}
   }
#endif

static void ReplyAllMessages(void)
	{
   struct IntuiMessage *WinMsg;
   GuiWindow *TempWindow = Gui.GWLfirst;
   while (TempWindow)
      {
      while ((WinMsg = (struct IntuiMessage *) GetMsg(TempWindow->Win->UserPort)) != NULL)
         ReplyMsg((struct Message *) WinMsg);
      TempWindow = TempWindow->next;
      }
	}

static short gm_result;
static PushButton *YesButton, *NoButton, *CancelButton;

int EndGuiMessage(PushButton *pb)
	{
	if (pb == NoButton)
		gm_result = GM_NO;
	else if (pb == CancelButton)
		gm_result = GM_CANCEL;
	else if (pb == YesButton)
		gm_result = GM_YES;
	else
		gm_result = 0;
	return GUI_MODAL_END;
	}

//short ExclamationDataWhite1[] = { 17,0, 9,0, 8,1, 7,1, 6,2, 5,2, 2,5, 2,6, 1,7, 1,8, 0,9, 0,14, 1,15, 1,16, 2,17, 2,18, 5,21, 6,21, 7,22,
//											16,22, 17,21, 18,21, 19,20, 20,20, 22,18, 22,17, 23,16, 23,15, 24,14, 24,9, 23,8, 23,7, 22,6, 22,5, 20,3, 19,3, 18,2 };
//short ExclamationDataBlack1[] = { 8,23, 16,23, 17,22, 18,22, 19,21, 20,21, 23,18, 23,17, 24,16, 24,15, 25,14, 25,9, 24,8, 24,7, 23,6, 23,5, 20,2, 19,2,
//											18,1, 9,1, 8,2, 7,2, 6,3, 5,3, 3,5, 3,6, 2,7, 2,8, 1,9, 1,14, 2,15, 2,16, 3,17, 3,18, 5,20, 6,20, 7,21 };

short ExclamationDataWhite2[] = { 12,3, 12,4, 11,5, 11,6, 10,7, 10,8, 9,9, 9,10, 11,12, 11,13, 12,14 };
short ExclamationDataBlack2[] = { 13,3, 13,4, 14,5, 14,6, 15,7, 15,8, 16,9, 16,10, 14,12, 14,13, 13,14 };
short ExclamationDataWhite3[] = { 13,17, 12,17, 11,18, 11,19 };
short ExclamationDataBlack3[] = { 12,20, 13,20, 14,19, 14,18 };

//short StopDataWhite1[] = { 18,0, 9,0, 8,1, 7,1, 6,2, 5,2, 2,5, 2,6, 1,7, 1,8, 0,9, 0,14, 1,15, 1,16, 2,17, 2,18, 5,21, 6,21, 7,22,
//									17,22, 18,21, 19,21, 20,20, 21,20, 23,18, 23,17, 24,16, 24,15, 25,14, 25,9, 24,8, 24,7, 23,6, 23,5, 21,3, 20,3, 19,2 };
//short StopDataBlack1[] = { 8,23, 17,23, 18,22, 19,22, 20,21, 21,21, 24,18, 24,17, 25,16, 25,15, 26,14, 26,9, 25,8, 25,7, 24,6, 24,5, 21,2, 20,2,
//									19,1, 9,1, 8,2, 7,2, 6,3, 5,3, 3,5, 3,6, 2,7, 2,8, 1,9, 1,14, 2,15, 2,16, 3,17, 3,18, 5,20, 6,20, 7,21 };

// White Stop Data must be drawn before black stop data.
short StopDataWhite2[] = { 5,8, 3,8, 3,11, 6,11, 5,11, 5,14, 3,14, 3,15 };
short StopDataWhite3[] = { 10,8, 8,8, 8,9, 9,9, 9,14 };
short StopDataWhite4[] = { 16,8, 13,8, 13,14, 16,14, 16,10 };
short StopDataWhite5[] = { 21,11, 22,11, 22,8, 19,8, 19,14 };
short StopDataBlack2[] = { 6,9, 4,9, 4,12, 6,12, 6,15, 4,15 };
short StopDataBlack3[] = { 9,9, 11,9, 10,9, 10,15 };
short StopDataBlack4[] = { 14,9, 17,9, 17,15, 14,15, 14,9 };
short StopDataBlack5[] = { 20,15, 20,9, 23,9, 23,12, 20,12 };

short XDataWhite1[] = { 6,5, 12,11, 18,5 };
short XDataWhite2[] = { 6,18, 12,12, 18,18 };
short XDataBlack1[] = { 7,5, 13,11, 19,5 };
short XDataBlack2[] = { 7,18, 13,12, 19,18 };

short QuestionDataWhite1[] = { 13,3, 10,3, 9,4, 9,5, 10,6, 12,6, 14,8, 14,10, 11,13, 11,14 };
short QuestionDataBlack1[] = { 14,4, 17,7, 17,10, 14,13, 14,14, 13,15, 12,15 };
short QuestionDataWhite2[] = { 13,17, 12,17, 11,18, 11,19 };
short QuestionDataBlack2[] = { 12,20, 13,20, 14,19, 14,18 };

short XBonesDataWhite1[] = { 15,3, 10,3, 8,5, 8,6, 7,7, 7,8, 8,9, 8,10, 9,11, 9,12, 10,13 };
short XBonesDataWhite2[] = { 10,9, 11,8 };
short XBonesDataWhite3[] = { 15,9, 16,8 };
short XBonesDataWhite4[] = { 12,12, 13,12 };
short XBonesDataWhite5[] = { 17,19, 16,19, 15,18, 14,18 };
short XBonesDataWhite6[] = { 8,19, 9,19, 10,18, 11,18, 14,15, 15,15, 16,14, 17,14 };
short XBonesDataWhite7[] = { 8,14, 9,14, 10,15, 11,15, 12,16 };
short XBonesDataBlack1[] = { 16,4, 17,5, 17,6, 18,7, 18,8, 17,9, 17,10, 16,11, 16,12, 14,14, 11,14 };
short XBonesDataBlack2[] = { 9,8, 10,7 };
short XBonesDataBlack3[] = { 14,8, 15,7 };
short XBonesDataBlack4[] = { 11,12, 11,11, 13,11 };
short XBonesDataBlack5[] = { 8,15, 9,15, 10,16, 11,16 };
short XBonesDataBlack6[] = { 8,20, 9,20, 10,19, 11,19, 14,16, 15,16, 16,15, 17,15 };
short XBonesDataBlack7[] = { 17,20, 16,20, 15,19, 14,19, 13,18 };

// Points for information icon
short InfoDataWhite1[] = { 12,5, 12,4, 13,3, 14,3 };short InfoDataBlack1[] = { 13,6, 14,6, 15,5, 15,4 };
short InfoDataWhite2[] = { 9,18, 9,16, 10,15, 10,12, 11,11, 11,9, 12,8, 13,8 };
short InfoDataBlack2[] = { 14,9, 14,11, 13,12, 13,15, 12,16, 12,18, 11,19, 10,19 };

short SingleOutlineDataWhite[] = { 16,0, 9,0, 8,1, 7,1, 6,2, 5,2, 2,5, 2,6, 1,7, 1,8, 0,9, 0,14, 1,15, 1,16, 2,17, 2,18, 5,21, 6,21, 7,22, 8,22 };
short SingleOutlineDataBlack[] = { 9,23, 16,23, 17,22, 18,22, 19,21, 20,21, 23,18, 23,17, 24,16, 24,15, 25,14, 25,9, 24,8, 24,7, 23,6, 23,5, 20,2, 19,2, 18,1, 17,1 };

short WideSingleOutlineDataWhite[] = { 17,0, 9,0, 8,1, 7,1, 6,2, 5,2, 2,5, 2,6, 1,7, 1,8, 0,9, 0,14, 1,15, 1,16, 2,17, 2,18, 5,21, 6,21, 7,22, 8,22 };
short WideSingleOutlineDataBlack[] = { 9,23, 17,23, 18,22, 19,22, 20,21, 21,21, 24,18, 24,17, 25,16, 25,15, 26,14, 26,9, 25,8, 25,7, 24,6, 24,5, 21,2, 20,2, 19,1, 18,1 };

short FOXLIB GuiMessage(REGA0 void *Scr, REGA1 char *text, REGA2 char *title, REGD0 int detail, REGD1 int block,
		REGD2 int flags)
   {
	int l, lines = 1, height, fontheight, itextlen;
   GuiWindow *TempWindow;
	long width, scrwidth, scrheight, minwidth = 200;
	struct IntuiText ErrorMessage;
	char *buffer, *c;
	BOOL bIcon = ((flags & GM_EXCLAMATION) || (flags & GM_QUESTION) || (flags & GM_STOP) || (flags & GM_X) || (flags & GM_CROSSBONES) || (flags & GM_INFORMATION));

	Diagnostic("GuiMessage", ENTER, TRUE);

	ErrorMessage.FrontPen = detail;
	ErrorMessage.DrawMode = JAM1;
	if (!Scr)
		{
		Diagnostic("GuiMessage", EXIT, FALSE);
		return -1;
		}
	else if (ISGUISCREEN(Scr))
		{
		scrwidth = ((GuiScreen *) Scr)->scr->Width;
		scrheight = ((GuiScreen *) Scr)->scr->Height;
		ErrorMessage.ITextFont = ((GuiScreen *) Scr)->nsc->Font;
		}
	else
		{
		// Scr must be the name of a public screen.
		struct Screen *sc = LockPubScreen((char *) Scr);
		if (sc)
			{
			scrwidth = sc->Width;
			scrheight = sc->Height;
			ErrorMessage.ITextFont = sc->Font;
			UnlockPubScreen((char *) Scr, sc);
			}
		else
			{
			Diagnostic("GuiMessage", EXIT, FALSE);
			return -1;
			}
		}
	fontheight = ErrorMessage.ITextFont->ta_YSize;
	ErrorMessage.TopEdge = (2 * fontheight) + 4;

	buffer = (char*) GuiMalloc((strlen(text) + 1) * sizeof(char), 0);
	if (!buffer)
		{
		Diagnostic("GuiMessage", EXIT, FALSE);
		return -1;
		}

	// strlen returns an unsigned int so strlen("") - 1 is huge (not -1).
	//	casting to an int solves the problem.
	for (l = 0; l < ((int) strlen(text)) - 1; l++)
		if (text[l] == '\n')
			lines++;
	height = ((lines + 3) * fontheight) + 25;
	height = max(height, 55 + fontheight);
	height = min(height, scrheight);
	strcpy(buffer, text);
	c = buffer;
	width = 0;
	while (c)
		{
		ErrorMessage.IText = c;
		c = strchr(c, '\n');
		if (c)
			*c = 0;
		itextlen = IntuiTextLength(&ErrorMessage);
		width = max(width, itextlen);
		if (c)
			{
			*c = '\n';
			c = &c[1];
			}
		}
	ErrorMessage.NextText = NULL;
	if ((flags & GM_YES) && (flags & GM_NO) && (flags & GM_CANCEL))
		minwidth = 280;
	if (bIcon)
		width += 72;
	width = max(width + 20, minwidth);
	width = min(width, scrwidth);

   if ((TempWindow = OpenGuiWindow(Scr, (scrwidth - width) /2, (scrheight - height) /2, width, height, detail, block, title, GW_DRAG, NULL, NULL)) != NULL)
      {
		int l1 = 10, l2 = (width / 2) - 40, l3 = width - 90, buttons = 0;

		c = buffer;
		while (c && ErrorMessage.TopEdge < height - 21 - fontheight) // Leave room for the button.
			{
			ErrorMessage.IText = c;
			c = strchr(c, '\n');
			if (c)
				*c = 0;
			ErrorMessage.LeftEdge = (width - IntuiTextLength(&ErrorMessage)) / 2;
			PrintIText(TempWindow->Win->RPort, &ErrorMessage, 0, 0);
			ErrorMessage.TopEdge += fontheight;
			if (c)
				{
				*c = '\n';
				c = &c[1];
				}
			}

		if (flags & GM_YES)
			buttons ++;
		if (flags & GM_NO)
			buttons ++;
		if (flags & GM_CANCEL)
			buttons ++;

		if (buttons < 2)
			l1 = l2;
		else if (buttons < 3)
			l2 = l3;

		if (flags & GM_YES)
			if (!(YesButton = MakeButton(TempWindow, (flags & GM_NO ? "_Yes" : "_Okay"), l1, -fontheight - 13, 80, fontheight + 8, (flags & GM_NO ? 'y' : 'o'), NULL, EndGuiMessage, BN_CLEAR | BN_STD | BN_OKAY, NULL)))
				{
				CloseGuiWindow(TempWindow);
				return Diagnostic("GuiMessage", EXIT, FALSE);
				}
		if (flags & GM_NO)
			if (!(NoButton = MakeButton(TempWindow, "_No", l2, -fontheight - 13, 80, fontheight + 8, 'n', NULL, EndGuiMessage, BN_CLEAR | BN_STD | (flags & GM_CANCEL ? 0 : BN_CANCEL), NULL)))
				{
				DestroyWinButtons(TempWindow, FALSE);
				CloseGuiWindow(TempWindow);
				return Diagnostic("GuiMessage", EXIT, FALSE);
				}
		if (flags & GM_CANCEL)
			if (!(CancelButton = MakeButton(TempWindow, "_Cancel", l3, -fontheight - 13, 80, fontheight + 8, 'c', NULL, EndGuiMessage, BN_CLEAR | BN_STD | BN_CANCEL, NULL)))
				{
				DestroyWinButtons(TempWindow, FALSE);
				CloseGuiWindow(TempWindow);
				return Diagnostic("GuiMessage", EXIT, FALSE);
				}

		if (flags & GM_EXCLAMATION)
		{
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataWhite, 20, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataBlack, 20, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, ExclamationDataWhite2, 11, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, ExclamationDataWhite3, 4, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, ExclamationDataBlack2, 11, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, ExclamationDataBlack3, 4, Gui.LoPen, JAM1, 8, 16);
		}
		else if (flags & GM_STOP)
		{
			DrawRPLines(TempWindow->Win->RPort, WideSingleOutlineDataWhite, 20, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, WideSingleOutlineDataBlack, 20, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataWhite2, 8, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataWhite3, 5, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataWhite4, 5, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataWhite5, 5, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataBlack2, 6, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataBlack3, 4, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataBlack4, 5, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, StopDataBlack5, 5, Gui.LoPen, JAM1, 8, 16);
		}
		else if (flags & GM_X)
		{
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataWhite, 20, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataBlack, 20, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XDataWhite1, 3, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XDataBlack1, 3, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XDataWhite2, 3, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XDataBlack2, 3, Gui.LoPen, JAM1, 8, 16);
		}
		else if (flags & GM_QUESTION)
		{
			DrawRPLines(TempWindow->Win->RPort, WideSingleOutlineDataWhite, 20, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, WideSingleOutlineDataBlack, 20, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, QuestionDataWhite1, 10, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, QuestionDataBlack1, 7, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, QuestionDataWhite2, 4, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, QuestionDataBlack2, 4, Gui.LoPen, JAM1, 8, 16);
		}
		else if (flags & GM_CROSSBONES)
		{
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataWhite, 20, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataBlack, 20, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite1, 11, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack1, 11, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite2, 2, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack2, 2, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite3, 2, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack3, 2, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite4, 2, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack4, 3, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite5, 4, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack5, 4, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite6, 8, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack6, 8, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataWhite7, 5, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, XBonesDataBlack7, 5, Gui.LoPen, JAM1, 8, 16);
		}
		else if (flags & GM_INFORMATION)
		{
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataWhite, 20, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, SingleOutlineDataBlack, 20, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, InfoDataWhite1, 4, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, InfoDataBlack1, 4, Gui.LoPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, InfoDataWhite2, 8, Gui.HiPen, JAM1, 8, 16);
			DrawRPLines(TempWindow->Win->RPort, InfoDataBlack2, 8, Gui.LoPen, JAM1, 8, 16);
		}

		gm_result = 0;
		WinMsgLoop(TempWindow);

		DestroyWinButtons(TempWindow, FALSE);
      CloseGuiWindow(TempWindow);
		GuiFree(buffer);
	   Diagnostic("GuiMessage", EXIT, TRUE);
		return gm_result;
      }
	return Diagnostic("GuiMessage", EXIT, FALSE);
   }

static void CloseNewDDListBox(struct DDListBoxStruct *lbs)
	{
	if (lbs)
		if (lbs->win && lbs->nlb)
			{
			DestroyListBox(lbs->nlb, FALSE);
			lbs->nlb = NULL;
			CloseGuiWindow(lbs->win);
			lbs->win = NULL;
			}
	}

static ListBox *NewDDListSelect = NULL;

int NewDDListTrigger(ListBox *lb, short Event, int HiNum, void **Data)
	{
	NewDDListSelect = lb;
	EscapeKey = FALSE;
	return GUI_CONTINUE;
	}

int NewDDListBoxSelFn(ListBox *lb)
	{
	Diagnostic("NewDDListBoxSelFn", ENTER, TRUE);

	NewDDListSelect = NULL;
	editptr = NewDDListBoxItemSelect(EscapeKey, NULL);
	if (!editptr)
		{
		// This call to ActivateGadget sometimes fails even though it claims
		// to succeed!
		if (Gui.LibVersion >= A3000)
			if (!ActivateGadget(&NewTopBox->editbox, ((GuiWindow *) NewTopBox->editbox.UserData)->Win, NULL))
				SetLastErr("ActivateGadget failed");
		}

	Diagnostic("NewDDListBoxSelFn", EXIT, TRUE);
	return GUI_CONTINUE;
	}

#define DD_L_BORDER 2

static void DropList(struct EditBoxStruct *p)
	{
	int width, incrX, incrY, count = 0, winheight;
	struct ListElement *f;
	unsigned short fontheight;
	struct TextAttr *font = &GuiFont; //((GuiWindow *) p->editbox.UserData)->ParentScreen->Font;

	fontheight = GuiFont.ta_YSize; //GetFontHeight((GuiWindow *) p->editbox.UserData);
	winheight = (p->list->MaxHeight * fontheight) + 4;

	f = p->list->first;
	while (f)
		{
		f = f->Next;
		count++;
		}

	if (!p->list->Parent)
		{
		int hipen = p->bb1.FrontPen;

		p->bb1.FrontPen = p->bb2.FrontPen;
		p->bb2.FrontPen = hipen;
		RefreshEditBox(p);
		p->bb2.FrontPen = p->bb1.FrontPen;
		p->bb1.FrontPen = hipen;
		NewTopBox = p;
		}
	if (p->list->PopupWidth)
		{
		Gui.DDListY = p->list->PopupY;
		incrX = incrY = 0;
		if (p->list->PopupWidth == -1)
			{ // Attempt to make the list box wide enough to display the longest item.
			int maxwidth = 0;
			struct ListElement *le = p->list->first;
			struct IntuiText it;

			it.ITextFont = font;
			while (le)
				{
				it.IText = le->string;
				width = IntuiTextLength(&it);
				if (width > maxwidth)
					maxwidth = width;
				le = le->Next;
				}
			/*	The width is calculated below using the reverse of the formula used in ListBox.c to
				calculate the maximum IntuiTextLength from the list box width supplied.  If either
				piece of code changes then the other must change to match. */
			width = maxwidth + (count > p->list->MaxHeight ? SCROLL_BUTTON_WIDTH : 0) + (2 * DD_L_BORDER) + 4;
			if (width > ((GuiWindow *) p->editbox.UserData)->ParentScreen->Width)
				width = ((GuiWindow *) p->editbox.UserData)->ParentScreen->Width;
			Gui.DDListX = (((GuiWindow *) p->editbox.UserData)->ParentScreen->Width - width)/2;
			}
		else
			{
			Gui.DDListX = p->list->PopupX;
			width = p->list->PopupWidth;
			}
		}
	else
		{
		Gui.DDListX = ((GuiWindow *) p->editbox.UserData)->Win->LeftEdge;
		Gui.DDListY = ((GuiWindow *) p->editbox.UserData)->Win->TopEdge;
		incrX = p->WidgetData->left;
		incrY = p->WidgetData->top + fontheight + 2;

		if (Gui.DDListY + incrY + winheight > ((GuiWindow *) p->editbox.UserData)->ParentScreen->Height)
			incrY = p->WidgetData->top - winheight;
		width = p->WidgetData->width + DD_LIST_BOX_BUTTON_WIDTH;
		}
	Gui.DroppingList = TRUE;
	// Remember to change SetDDListBoxPopup() in editbox.c if this changes.
	p->list->win = CreateGuiWindow((GuiScreen *) (((GuiWindow *) p->editbox.UserData)->WidgetData->Parent),
		((GuiWindow *) p->editbox.UserData)->ParentScreen, Gui.DDListX + incrX, Gui.DDListY + incrY,
		width, winheight, p->lborder.FrontPen, p->Bcol, NULL, GW_BORDERLESS, NULL);

	Gui.DroppingList = FALSE;
	if (p->list->win)
		{
		int flags = 0, num = 1, hinum = 1, start = 1, cmplen = p->buffer ? strlen(GetEditBoxText(p)) : 0;

		if (count > p->list->MaxHeight)
			flags = SYS_LB_VSCROLL;
		p->list->nlb = CreateListBox(p->list->win, p->list->win->Win->BorderLeft,
			p->list->win->Win->BorderTop,
			width - p->list->win->Win->BorderRight - p->list->win->Win->BorderLeft,
			winheight - p->list->win->Win->BorderBottom - p->list->win->Win->BorderTop, DD_L_BORDER, 1,
			p->Tcol, font, NewDDListTrigger, flags | S_AUTO_SIZE | LB_SELECT, ListBoxObject);
		Gui.ListFocusOnly = FALSE;
		f = p->list->first;
		while (f)
			{
			AddListBoxItem(p->list->nlb, f->string, FALSE);
			if (cmplen > 0 && !strncmp(GetEditBoxText(p), f->string, cmplen))
				hinum = num;
			f = f->Next;
			num++;
			}
		while (hinum > p->list->MaxHeight + start - 1)
			start++;
		editptr = p;
		SetListBoxTopNum(p->list->nlb, start, FALSE);
		SetListBoxHiNum(p->list->nlb, hinum, TRUE);
		}
	else
		SetLastErr("Unable to open window for drop-down list box.");
}

static unsigned int CheckForChars(unsigned long signals, int *lchptr)
   {
   unsigned int SigRec = 0L;
   GuiWindow *gwl = Gui.GWLfirst;
   while (gwl)
      {
      if (signals & gwl->ConReadSig)
         {
         *lchptr = ConMayGetChar(gwl->Con, &(Gui.ibuf));
         SigRec |= gwl->ConReadSig;
         break;
         }
      gwl = gwl->next;
      }
   return SigRec;
   }

static EditBox *endedit(void)
	{
	Diagnostic("endedit", ENTER, TRUE);
	EditBoxSelected(NULL);
	Diagnostic("endedit", EXIT, TRUE);
	return editptr;
	}

static void ProcessKeys(unsigned char *CharStream, GuiWindow *MsgWin, GuiWindow *ModalWin)
	{
	BOOL csi = FALSE;
	int i = 0;

	while (i < strlen((char*) CharStream) && (!Stop & GUI_END))
		{
		unsigned char ch = CharStream[i++];

		if (ch == VAL_CSI)
			{
			csi = TRUE;
			continue;
			}
		if (csi)
			{
			// Process cursor keys et al.
			if ((ch == 'A' || ch == 'B') && (MsgWin == ModalWin || ModalWin == NULL)) // Cursor up/down.
				{
				// Check to see whether there's a list box in this window that we can scroll
				register int h;
				ListBox *lb = Gui.FirstListBox;
				while (lb)
					{
					if (lb->Win == MsgWin)
						if (ch == 'A')
							{
							if ((h = HiNum(lb)) > 1)
								{
								SetListBoxHiNum(lb, h - 1, h - 1 >= lb->TopShown);
								if (h - 1 < lb->TopShown)
									ListBoxScrollUp(lb, TRUE);
								if (lb->WidgetData->flags & LB_CURSOR)
									{
									Stop = (*(lb->Eventfn))(lb, LB_CURSOR, lb->HiNum, NULL);
									Gui.Done = TRUE;
									}
								}
							}
						else
							if ((h = HiNum(lb)) < lb->NoItems)
								{
								register int LastShown = lb->TopShown + NumLines(lb) - 1;
								SetListBoxHiNum(lb, h + 1, h + 1 <= LastShown);
								if (h + 1 > LastShown)
									ListBoxScrollDown(lb, TRUE);
								if (lb->WidgetData->flags & LB_CURSOR)
									{
									Stop = (*(lb->Eventfn))(lb, LB_CURSOR, lb->HiNum, NULL);
									Gui.Done = TRUE;
									}
								}
					lb = lb->NextListBox;
					}
				}
			csi = FALSE;
			}
		else
			{
			// If a drop-down list box is active
			if (editptr && editptr->list && editptr->list->win && editptr->list->nlb)
				{
				if (ch == VAL_ESC)
					{
					// Close the drop-down list without selecting anything.
					EscapeKey = TRUE;
					NewDDListSelect = editptr->list->nlb;
					}
				else if (ch == VAL_SPC || ch == VAL_CR)
					{
					// Select the current item and close the drop-down list.
					EscapeKey = FALSE;
					NewDDListSelect = editptr->list->nlb;
					}
				else
					{
					// Hilight the next item starting with the character typed.
					struct IntuiText *start = HiElem(editptr->list->nlb), *it = start;
					unsigned char altch;

					if (isupper(ch))
						altch = tolower(ch);
					else if (islower(ch))
						altch = toupper(ch);
					else
						altch = ch;

					do
						{
						if (!(it = NextItem(it)))
							it = editptr->list->nlb->FirstItem;
						} while (it != start && it->IText[0] != ch && it->IText[0] != altch);

					if (it != start)
						{
						// found one!
						register int itemnum = ItemNum(editptr->list->nlb, it);
						register int numlines = NumLines(editptr->list->nlb);

						if (itemnum > 0)
							if (itemnum >= editptr->list->nlb->TopShown && itemnum <=
									editptr->list->nlb->TopShown + numlines - 1)
								SetListBoxHiNum(editptr->list->nlb, itemnum, TRUE);
							else
								{
								int newtopnum = 1;
								while (itemnum > newtopnum + numlines - 1)
									newtopnum++;
								SetListBoxHiNum(editptr->list->nlb, itemnum, FALSE);
								SetListBoxTopNum(editptr->list->nlb, newtopnum, TRUE);
								}
						}
					}
				}
			else
				{
				PushButton *ggl = Gui.GGLfirst;

				// Check button hot-keys and default keys (return and escape) for Okay and Cancel buttons.
				while (ggl)
					{
					/*	Don't activate the button if it's not in the modal window (if there is one) or if
						it's in a sleeping window. */
					if (ggl->Active && (ch == ggl->Key1 || (ch == VAL_CR && (ggl->WidgetData->flags & BN_OKAY)) ||
							ch == ggl->Key2 || (ch == VAL_ESC && (ggl->WidgetData->flags & BN_CANCEL))) &&
							(! (((GuiWindow *) ggl->button.UserData)->Sleep)) &&
							(ModalWin == NULL || ggl->button.UserData == (APTR) ModalWin))
						{
						/*	We've found a button that could be activated by this key BUT we may not want to
							activate it yet.  It could be that there is an edit box active (i.e. editptr non
							NULL) even though the key went to the IDCMP not straight to the edit box.  This
							would happen if the user had forced intuition to forget about the edit box by (for
							example) clicking in another application's window.  If he then re-activates this
							application by (for example) clicking on a window's title bar he would then be able
							to activate the button with a keypress, leaving the edit box unvalidated.  If that
							button destroyed the editbox, next time a button were clicked with a mouse, FoxGui
							will try to validate it - result CRASH!  We can prevent all that here if we don't
							let the user select that button without first validating the edit box. */

						// Check whether there is a currently active edit/drop-down list box.
						EditBox *active = editptr ? editptr : lastactiveDDListBox;

						if (active)
							{
							endedit();

							// Check whether the validation succeeded (active will be NULL for success).
							active = editptr ? editptr : lastactiveDDListBox;
							}
						/*	Call the buttons click function if there was no validation to do or if the
							validation succeeded. */
						if (!active)
							{
							Gui.Done = TRUE;
							ActionPtr = ggl;
							Action = ACTION_BUTTON;
							break;
							}
						}
					ggl = ggl->Next;
					}
				}
			}
		}
	}

static GuiWindow *FindWindowBySignal(unsigned long signals, unsigned long *SigRec)
   {
	GuiWindow *winptr = NULL, *gwl = Gui.GWLfirst;
	*SigRec = 0;
	while (gwl)
		{
		if (signals & gwl->WindowSig)
			{
			winptr = gwl;
			*SigRec = gwl->WindowSig;
			break;
			}
		gwl = gwl->next;
		}
	return winptr;
	}

static GuiWindow *FindWindowByConSignal(unsigned long signals)
   {
   GuiWindow *winptr = NULL, *gwl = Gui.GWLfirst;
   while (gwl)
      {
      if (signals & gwl->ConReadSig)
         {
         winptr = gwl;
         break;
         }
      gwl = gwl->next;
      }
   return winptr;
   }

static void ListSelectAndActivate(int NoSelect, struct ListElement *elemfound)
	{
	// Select an item in a drop down list and then re-activate the top-level
	// box.
	Diagnostic("ListSelectAndActivate", ENTER, TRUE);
	editptr = DDListBoxItemSelect(NoSelect, elemfound);
	if (!editptr)
		{
		// This call to ActivateGadget sometimes fails even though it claims
		// to succeed!
		if (Gui.LibVersion >= A3000)
			if (!ActivateGadget(&NewTopBox->editbox, ((GuiWindow *) NewTopBox->editbox.UserData)->Win, NULL))
				SetLastErr("ActivateGadget failed");
		}
	Diagnostic("ListSelectAndActivate", EXIT, TRUE);
	}

static DDListBox *DDListBoxItemSelect(BOOL NoSelect, struct ListElement *elemfound)
	{
	// elemfound will be true if the item was selected by a keypress without
	// the listbox dropped.
	BOOL valid;
	struct ListElement *element = NULL;
	DDListBox *fnbox;

	Diagnostic("DDListBoxItemSelect", ENTER, TRUE);
	if (elemfound)
		element = elemfound;

	if (element && !NoSelect)
		{
		if (!(element->Child))
			SetEditBoxText(NewTopBox, element->string);
		}
	else
		RefreshGList(&NewTopBox->editbox, ((GuiWindow *) NewTopBox->editbox.UserData)->Win, NULL, 1);

	// editptr will be set if the item was clicked on with a mouse OR
	// if the item was selected from a sub DDListBox but will NOT be set if
	// selected by keypress from a top-level list box
	fnbox = editptr ? editptr : NewTopBox;
   if (NoSelect || !(fnbox->valifn))
      valid = TRUE;
   else
      valid = (*(fnbox->valifn))(fnbox);

	if (element && element->Child && !NoSelect)
		{
		DropList((DDListBox *) element->Child);
		Diagnostic("DDListBoxItemSelect", EXIT, TRUE);
		return (DDListBox *) element->Child;
		}
	Diagnostic("DDListBoxItemSelect", EXIT, TRUE);
	return NULL;
	}

static struct EditBoxStruct *nlbHiChild(struct DDListBoxStruct *lbs)
	{
	if (lbs)
		{
		ListBox *lb = lbs->nlb;
		if (lb)
			{
			int itemnum = HiNum(lb);

			if (itemnum == 0)
				return NULL;
			else
				{
				struct ListElement *cle = lbs->first;
				while (cle)
					{
					if (cle->Itemnum == itemnum)
						return cle->Child;
					cle = cle->Next;
					}
				}
			}
		}
	return NULL;
	}

static DDListBox *NewDDListBoxItemSelect(BOOL NoSelect, struct IntuiText *elemfound)
	{
	// elemfound will be true if the item was selected by a keypress without the listbox dropped.
	BOOL valid;
	struct IntuiText *element = NULL;
	DDListBox *fnbox;

	/*	Closing the new list box will clear out all the data refering to it's list.  We could retrieve
		the child (if there is one) from the underlying list structure but since the child itself is not
		destroyed (just our pointer to it) it's far quicker (and easier) to make a note of it's location
		before we close the list that's currently open. */
	DDListBox *Child = NULL;

	Diagnostic("NewDDListBoxItemSelect", ENTER, TRUE);

	if (!(elemfound || editptr))
		{
		Diagnostic("NewDDListBoxItemSelect", EXIT, FALSE);
		return editptr;
		}

	if (elemfound)
		element = elemfound;
	else
		element = HiElem(editptr->list->nlb);

	if (element)
		Child = nlbHiChild(editptr->list);

	if (element && !NoSelect)
		{
		if (!Child)
				SetEditBoxText(NewTopBox, element->IText);
		}
	else
		RefreshGList(&NewTopBox->editbox, ((GuiWindow *) NewTopBox->editbox.UserData)->Win, NULL, 1);

	if (!elemfound)
			CloseNewDDListBox(editptr->list);

	// editptr will be set if the item was clicked on with a mouse OR
	// if the item was selected from a sub DDListBox but will NOT be set if
	// selected by keypress from a top-level list box
		fnbox = editptr ? editptr : NewTopBox;
	   if (NoSelect || !(fnbox->valifn))
   	   valid = TRUE;
	   else
			{
			EditBox *editptrcpy = editptr;

			/*	We need to set editptr to NULL before calling the user's validation function because that
				function might (for example) call GuiMessage() which would then run a modal loop on that
				window.  If the user then clicked (eg) the Okay button on that window, because editptr was
				not NULL it would try to validate this list box before allowing you to click that button.
				In that way you could get into an infinite loop, repeatedly trying to validate the list box
				whenever you tried to respond to the GuiMessage() window! */
			editptr = NULL;
   	   valid = (*(fnbox->valifn))(fnbox);
			editptr = editptrcpy;
			}

	if (element && Child && !NoSelect)
		{
		DropList(Child);
		Diagnostic("NewDDListBoxItemSelect", EXIT, TRUE);
		return Child;
		}
	Diagnostic("NewDDListBoxItemSelect", EXIT, TRUE);
	return NULL;
	}

static TickBox *FindTickBox(struct IntuiMessage *WinMsg)
	{
	TickBox *tb = Gui.FirstTickBox;
	if (WinMsg)
		{
		while (tb)
			if (&(tb->TickBoxGad) == WinMsg->IAddress)
				break;
			else
				tb = tb->Next;
		}
	else
		return NULL;
	return tb;
	}

static ListBox *ListBoxScrollGad(struct IntuiMessage *WinMsg)
	{
	ListBox *lb = Gui.FirstListBox;
	if (WinMsg)
		{
		while (lb)
			if (lb->UD && WinMsg->IAddress == &lb->UD->ScrollGad)
				break;
			else if (lb->LR && WinMsg->IAddress == &lb->LR->ScrollGad)
				break;
			else
				lb = lb->NextListBox;
		}
	else
		return NULL;
	return lb;
	}

static void UpdateLBScrollGadImagery(ListBox *lb)
	{
	int hi = lb->HiNum, showable = NumLines(lb);
	unsigned short top = 1;

	if (lb->UD)
		top = FindScrollerTop(lb->NoItems, showable, lb->UD->ScrollGadInfo.VertPot) + 1;
	if (top != lb->TopShown) // Vertical scroller
		{
		/*	If the list has only been scrolled 1 line either way then use the appropriate scroll function
			instead of doing a complete refresh which would be much slower */
		if (top == lb->TopShown - 1)
			ListBoxScrollUp(lb, FALSE);
		else if (top == lb->TopShown + 1)
			ListBoxScrollDown(lb, FALSE);
		else
			{
			// Do a complete refresh
			if (hi && (lb->WidgetData->flags & LB_REHILIGHT_ON_SCROLL))
				{
				if (hi < top)
					hi = top;
				else if (hi >= top + showable)
					hi = top + showable - 1;
				if (hi != lb->HiNum)
					SetListBoxHiNum(lb, hi, FALSE);
				}
			SetListBoxTopNum(lb, top, TRUE);
			}
		}
	if (lb->LR)
		{
		int left = 0 - FindScrollerTop(lb->LongestIntuiLen, lb->MaxIntuiLen, lb->LR->ScrollGadInfo.HorizPot);
		if (left != lb->xOffset) // Horizontal Scroller
			{
			lb->xOffset = left;
			ListBoxRefresh(lb);
			}
		}
	}

static BOOL CheckTickBox(struct IntuiMessage *WinMsg)
	{
	BOOL retval = FALSE;
	TickBox *tb = FindTickBox(WinMsg);
	if (tb)
		{
		// Check whether there is a currently active edit/drop-down list box.
		EditBox *active = editptr ? editptr : lastactiveDDListBox;
		retval = TRUE;

		if (active)
			{
			EditBoxSelected(WinMsg);

			// Check whether the validation succeeded (active will be NULL for success).
			active = editptr ? editptr : lastactiveDDListBox;
			}
		// Call the tick boxes click function if there was no validation to do or if the validation succeeded.
		if (!active)
			{
			ActionPtr = tb;
			Action = ACTION_TICKBOX;
			Gui.Done = TRUE;
			}
		}
	return retval;
	}

void UpdateTCScrollGadImagery(TreeControl *tc);

static BOOL ListScroll(struct IntuiMessage *WinMsg, GuiWindow *win, ListBox **SelectedLB)
	{
	if (win && WinMsg)
		{
		/* NOTE: The IAddress comparison below is only valid for GADGETUP and
			GADGETDOWN messages.  This comparison should not be performed with (eg)
			MOUSEMOVE messages! */

		ListBox *lb = ListBoxScrollGad(WinMsg);
		if (lb)
			{
			if (lb->itemlist)
				UpdateTCScrollGadImagery(lb);
			else
				UpdateLBScrollGadImagery(lb);
			*SelectedLB = NULL;
			if (lb->WidgetData->flags & LB_CURSOR)
				if (lb->itemlist) // it's a tree control
					{
					if (SelectedLBHiItem != (ListBoxItem *) lb->hiitem)
						Stop = ((TCIntFnPtr) *(lb->Eventfn))(lb, TC_CURSOR, lb->hiitem, NULL);
					}
				else if (SelectedLBHiItem != lb->HiItem)
					Stop = (*(lb->Eventfn))(lb, LB_CURSOR, lb->HiNum, NULL);
			Gui.Done = TRUE;
			return TRUE;
			}
		}
	return FALSE;
	}

static BOOL EditBoxSelected(struct IntuiMessage *WinMsg)
	{
	BOOL valid = TRUE, FocusSet = FALSE;
   EditBox *neweb, *ebp;
	Diagnostic("EditBoxSelected", ENTER, TRUE);
	ebp = FindEditBoxByWin(WinMsg);
	neweb = (ebp && ebp->list ? NULL : ebp);
	if (editptr)
		{
		if (editptr->list)
			{
			if (editptr->list->win && WinMsg)
				neweb = editptr;
			else
				DDListBoxItemSelect(FALSE, NULL);
			}
		else
			{
			if (editptr->enabled && editptr->valifn && ebp != editptr)
				{
				EditBox *old = editptr;
				/*	Set editptr to NULL so that if another gadget gets activated by the users validation
					function (such as when a message box appears and the user clicks the Okay button), this
					gadgets validation function won't get fired again. */
				editptr = NULL;
	   	   valid = (*(old->valifn))(old);
				/*	Reset editptr after the call to the users validation function but only if it's NULL.  If
					it's not NULL, the user called SetEditBoxFocus to set it so we should respect the user's
					wishes. */
				if (editptr == NULL)
					editptr = old;
				else
					{
					neweb = editptr;
					FocusSet = TRUE;
					}
				}
			/*	Don't set the focus if we've already done it in SetEditBoxFocus() - it's slow enough once -
				twice would be ridiculous */
			if ((!valid) && !FocusSet)
				{
				neweb = editptr;
				DeactivateUnknownEditBox();
				ActivateGadget(&editptr->editbox, ((GuiWindow *) editptr->editbox.UserData)->Win, NULL);
				}
			}
		}
	editptr = neweb;
	if (valid)
		lastactiveDDListBox = (ebp && ebp->list ? ebp : NULL);
	Diagnostic("EditBoxSelected", EXIT, TRUE);
	return (BOOL) ((ebp != NULL) || !valid);
	}

static Frame *FrameRClick(GuiWindow *winptr, struct IntuiMessage *WinMsg)
	{
	Frame *f = Gui.FirstFrame;
	short MouseX, MouseY;

	if (!WinMsg)
		return NULL;

	MouseX = WinMsg->MouseX + winptr->Win->LeftEdge; // Screen coordinates
	MouseY = WinMsg->MouseY + winptr->Win->TopEdge;

	while (f)
		{
		GuiWindow *frwin = GetWindow(f);
		int WinX = MouseX - frwin->Win->LeftEdge, WinY = MouseY - frwin->Win->TopEdge;

		if ((f->WidgetData->flags & FM_RBUT) && f->hidden == 0 && f->Active && WinX >= f->button.LeftEdge &&
			WinX <= f->button.LeftEdge + f->points[8] + 1 && WinY >= f->button.TopEdge
			&& WinY <= f->button.TopEdge + f->points[1] + 1)
			return f;
		f = f->next;
		}
	return NULL;
	}

// FoxEd manipulates these variables to do some rubber-banding.
static int DragOutlineX = -1;
static int DragOutlineY = -1;
static int DragStartWidth = 0;
static int DragStartHeight = 0;
static int DragMinWidth = 0;
static int DragMinHeight = 0;

void FOXLIB SetupSizeOutlineData(REGD0 int x, REGD1 int y, REGD2 int width, REGD3 int height, REGD4 int minwidth, REGD5 int minheight)
	{
	DragOutlineX = x;
	DragOutlineY = y;
	DragStartWidth = width;
	DragStartHeight = height;
	DragMinWidth = minwidth;
	DragMinHeight = minheight;
	}

void DrawSizeOutline(Frame *fm, GuiWindow *winptr, BOOL undraw, BOOL draw, int x, int y)
	{
	static short points[10];
	static int Left, Top;

	if (draw && !undraw)
		{
		// Only update when starting a new drag!
		if (DragOutlineX == -1)
			Left = winptr->Win->LeftEdge + fm->button.LeftEdge;
		else
			Left = DragOutlineX;
		if (DragOutlineY == -1)
			Top = winptr->Win->TopEdge + fm->button.TopEdge;
		else
			Top = DragOutlineY;
		points[0] = Left;
		points[1] = Top;
		points[3] = Top;
		points[6] = Left;
		points[8] = Left;
		points[9] = Top + 1;
		}

	if (undraw) // Undraw the old border.
		DrawRPLines(&winptr->ParentScreen->RastPort, points, 5, 1, COMPLEMENT, 0, 0);

	points[2] = Left + max(DragStartWidth + x, DragMinWidth);
	points[4] = Left + max(DragStartWidth + x, DragMinWidth);
	points[5] = Top + max(DragStartHeight + y, DragMinHeight);
	points[7] = Top + max(DragStartHeight + y, DragMinHeight);

	if (draw)
		DrawRPLines(&winptr->ParentScreen->RastPort, points, 5, 1, COMPLEMENT, 0, 0);

	if (undraw && !draw)
		{
		DragOutlineX = DragOutlineY = -1;
		DragStartWidth = DragStartHeight = 0;
		}
	}

void DrawDragOutline(Frame *fm, GuiWindow *winptr, BOOL undraw, BOOL draw, int x, int y)
	{
	static short points[10];
	static int Left, Top;

	if (fm->WidgetData->flags & FM_SIZEOUTLINE)
		{
		DrawSizeOutline(fm, winptr, undraw, draw, x, y);
		return;
		}

	if (draw && !undraw)
		{
		// Only update when starting a new drag!
		Left = winptr->Win->LeftEdge + fm->button.LeftEdge;
		Top = winptr->Win->TopEdge + fm->button.TopEdge;
		}

	if (undraw) // Undraw the old border.
		DrawRPLines(&winptr->ParentScreen->RastPort, points, 5, 1, COMPLEMENT, 0, 0);

	points[0] = Left + x;
	points[1] = Top + y;
	points[2] = Left + fm->points[8] + x;
	points[3] = Top + y;
	points[4] = Left + fm->points[8] + x;
	points[5] = Top + fm->points[1] + y;
	points[6] = Left + x;
	points[7] = Top + fm->points[1] + y;
	points[8] = Left + x;
	points[9] = Top + y + 1;

	if (draw)
		DrawRPLines(&winptr->ParentScreen->RastPort, points, 5, 1, COMPLEMENT, 0, 0);
	}

static BOOL NormalButtonFramePress(struct IntuiMessage *WinMsg, Frame **FrameDragPtr, Frame **FrameDownPtr)
   {
	BOOL retval = FALSE;
   PushButton *ButtPtr;
	Frame *FramePtr = NULL;

	Diagnostic("NormalButtonFramePress", ENTER, TRUE);
	ButtPtr = FindButtonByMsg(WinMsg);
	if (!ButtPtr)
		FramePtr = FindFrameByMsg(WinMsg);
	if (FramePtr) // The user has released the frame.
		*FrameDownPtr = NULL;
	if (FramePtr && *FrameDragPtr)
		{
		/*	The user has released a frame that was being dragged while still over the frame itself hence we
			received a gadget up event rather than a mouse buttons select-up which is what we would have
			received if the user had released the frame with the pointer anywhere else. */
		Gui.Done = retval = TRUE;
		Action = ACTION_DROP;
		ActionPtr = *FrameDragPtr;
		ActionX = WinMsg->MouseX;
		ActionY = WinMsg->MouseY;
		if ((*FrameDragPtr)->WidgetData->flags & FM_DRAGOUTLINE)
			DrawDragOutline(*FrameDragPtr, GetWindow(*FrameDragPtr), TRUE,  FALSE, 0, 0);
		*FrameDragPtr = NULL;
		}
	else if ((ButtPtr && ButtPtr->Active) || (FramePtr && FramePtr->Active && (FramePtr->WidgetData->flags & FM_LBUT)))
      {
		// Check whether there is a currently active edit/drop-down list box.
		EditBox *active = editptr ? editptr : lastactiveDDListBox;

		retval = TRUE;
		if (active)
			{
			EditBoxSelected(WinMsg);

			// Check whether the validation succeeded (active will be NULL for success).
			active = editptr ? editptr : lastactiveDDListBox;
			}
		// Call the button or frames click function if there was no validation to do or if the validation succeeded.
      if (!active)
         {
			ActionPtr = ButtPtr ? ButtPtr : (PushButton *) FramePtr;
			ActionX = WinMsg->MouseX;
			ActionY = WinMsg->MouseY;
			Action = ButtPtr ? ACTION_BUTTON : ACTION_FRAME_LBUT;
			Gui.Done = TRUE;
         }
      }
	Diagnostic("NormalButtonFramePress", EXIT, TRUE);
	return retval;
   }

static void RadioButtonClick(RadioButton *rb)
	{
	struct MutexList *ActiveRB = rb->MList;
	unsigned short position;

	if (rb->RBGad.Flags & GFLG_SELECTED)
		return; // This one is already selected.  Nothing to do.

	position = RemoveGadget((struct Window *) rb->RBGad.UserData, &(rb->RBGad));
	if (position == -1) // RemoveGadget failed!
		{
		SetLastErr("RadioButtonClick failed to remove the gadget.");
		return;
		}

	// Find the active member of the group.
	while (ActiveRB && !(ActiveRB->Mutex->RBGad.Flags & GFLG_SELECTED))
		ActiveRB = ActiveRB->Next;
	if (ActiveRB)
		{
		struct Gadget *ActiveGad = &(ActiveRB->Mutex->RBGad);
		// Remove the active gadget
		unsigned short activepos = RemoveGadget((struct Window *) ActiveGad->UserData, ActiveGad);
		if (activepos == -1)
			SetLastErr("RadioButtonClick failed to remove the active gadget.");
		else
			{
			/*	Blank the area (this is to remove the fill points - to save us from having another set
				of fill points in the blank colour */
			AreaBlank(((struct Window *) ActiveGad->UserData)->RPort, ActiveGad->LeftEdge,
					ActiveGad->TopEdge, ActiveGad->Width, ActiveGad->Height);
			// Deactivate it.
			ActiveGad->Flags &= ~GFLG_SELECTED;
			// Add it back.
			if (AddGadget((struct Window *) ActiveGad->UserData, ActiveGad, activepos) == -1)
				SetLastErr("RadioButtonClick failed to replace the old active gadget.");
			else
				RefreshGList(ActiveGad, (struct Window *) ActiveGad->UserData, NULL, 1);
			}
		}

	// Activate the gadget clicked on
	rb->RBGad.Flags |= GFLG_SELECTED;

	// Add back the gadget clicked on.
	if (AddGadget((struct Window *) rb->RBGad.UserData, &(rb->RBGad), position) == -1)
		SetLastErr("RadioButtonClick failed to replace the new active gadget.");
	else
		{
		DrawRBCentre(rb);
		RefreshGList(&(rb->RBGad), (struct Window *) rb->RBGad.UserData, NULL, 1);
		}

	if (rb->Callfn)
		{
		Action = ACTION_RADIO_BUT;
		ActionPtr = rb;
		Gui.Done = TRUE;
		}
	}

static void AutRepButtonPress(PushButton *ButtPtr, GuiWindow *winptr)
   {
	int Special = 0;

   if (ButtPtr || Special)
      {
      struct IntuiMessage *ReleaseMessage;
      BOOL First = TRUE;
      do
         {
			if (ButtPtr->Active)
            {
            int tmp;
            if (ButtPtr->Callfn)
               tmp = (*(ButtPtr->Callfn))(ButtPtr);
				Gui.Done = TRUE;
            }
         ReleaseMessage = (struct IntuiMessage *) GetMsg(winptr->Win->UserPort);
         if (ReleaseMessage)
            {
            if (!(ReleaseMessage->Class == GADGETUP || (ReleaseMessage->Class == MOUSEBUTTONS && ReleaseMessage->Code ==
               SELECTUP)))
               {
               ReplyMsg((struct Message *) ReleaseMessage);
               ReleaseMessage = NULL;
               }
            }
         if (!ReleaseMessage)
            {
            if (First)
               {
               ReleaseMessage = pause(Gui.ARdelay, winptr);
               First = FALSE;
               }
            else
               ReleaseMessage = pause(Gui.ARperiod, winptr);
            }
         } while (!ReleaseMessage);
      ReplyMsg((struct Message *) ReleaseMessage);
      }
   }

static BOOL ListBoxExists(ListBox *lb)
	{
	ListBox *li = Gui.FirstListBox;
	while (li)
		{
		if (li == lb)
			return TRUE;
		li = li->NextListBox;
		}
	return FALSE;
	}

static ListBox *CheckListBox(int x, int y, GuiWindow *winptr)
	{
	Diagnostic("CheckListBox", ENTER, TRUE);
	if (winptr)
		{
		ListBox *FindIt = Gui.FirstListBox;
		while (FindIt)
			if (FindIt->Win == winptr && x >= FindIt->WidgetData->left && x <= FindIt->WidgetData->left + FindIt->points[12] &&
						y >= FindIt->WidgetData->top && y <= FindIt->WidgetData->top + FindIt->points[5] + (FindIt->NoTitles ?
						(FindIt->NoTitles * FindIt->Font->ta_YSize) + (2 * FindIt->TBorder) + 3 : 0) &&
						FindIt->Enabled && FindIt->hidden == 0)
				break;
			else
				FindIt = FindIt->NextListBox;
		return FindIt;
		}
	Diagnostic("CheckListBox", EXIT, TRUE);
	return NULL;
	}

static BOOL DDListBoxSelect(struct IntuiMessage *WinMsg, GuiWindow *winptr)
   {
   int y = WinMsg->MouseY, x = WinMsg->MouseX;
	BOOL Done = FALSE;
	struct EditBoxStruct *np = Gui.FirstEditBox;
	Diagnostic("DDListBoxSelect", ENTER, TRUE);
   while (np)
      {
      if (y > np->WidgetData->top && y < np->WidgetData->top + 9 && (GuiWindow *) np->editbox.UserData == winptr && np->enabled &&
         	x > np->WidgetData->left + np->WidgetData->width && x < np->WidgetData->left + np->WidgetData->width + DD_LIST_BOX_BUTTON_WIDTH && np->list &&
				np->hidden == 0 && !(np->list->Parent))
         {
			if (editptr && editptr->list && editptr->list->win && editptr->list->nlb)
				{
				BOOL SameOne = (editptr == np);
				editptr = NewDDListBoxItemSelect(SameOne || nlbHiChild(editptr->list), NULL);
				if (!(editptr || SameOne))
					DropList(np);
				}
			else
				{
				if (editptr || (lastactiveDDListBox && lastactiveDDListBox != np))
					endedit();
				if (!(editptr || (lastactiveDDListBox && lastactiveDDListBox != np)))
					DropList(np);
				}
         np = NULL;
			Done = TRUE;
         }
      else
         np = np->next;
      }
	Diagnostic("DDListBoxSelect", EXIT, TRUE);
	return Done;
   }

static struct ListElement *FindListBoxItem(char Key, DDListBox *listbox)
	{
	// Search for a list element starting with the character typed.
	struct ListElement *e, *start = listbox->list->first;

	// The list box contains no items.
	if (!start)
		return NULL;

	// Find the element to start at.  If no element is currently selected
	// then start at the first one.  Otherwise, start at the item after the
	// selected one (if the selected one is still in the list).
	if (strcmp(listbox->buffer, ""))
		{
		e = start;
		while (strcmp(e->string, listbox->buffer))
			{
			e = e->Next;
			if (!e)
				break;
			}
		if (e)
			start = e->Next;
		if (!start)
			start = listbox->list->first;
		}

	// Now we know where to start, start looking for an element starting
	// with the typed character.
	e = start;
	while (toupper(e->string[0]) != toupper(Key))
		{
		e = e->Next;
		if (!e)
			e = listbox->list->first;
		if (e == start)
			return NULL;
		}
	return e;
	}

static void UpdateTimers(void)
	{
	Timer *t = Gui.FirstTimer;

	while (t && (Stop & GUI_CONTINUE))
		{
		if (t->running)
			{
			t->timesecs = time(NULL);
			if (t->Callfn && ((t->timesecs > t->lasttrigger && (t->WidgetData->flags & TM_SECOND)) ||
									(t->timesecs > t->lasttrigger + 59 && (t->WidgetData->flags & TM_MINUTE))))
				{
				t->lasttrigger = t->timesecs;
				Stop = (*(t->Callfn))(t, t->timesecs - t->starttimesecs);
				}
			}
		t = t->NextTimer;
		}
	}

RadioButton *FindRadioButtonByMsg(struct IntuiMessage *WinMsg)
	{
	RadioButton *rb = Gui.FirstRadioButton, *RetVal = NULL;
	while (rb)
		{
		if (&(rb->RBGad) == (struct Gadget *) WinMsg->IAddress)
			{
			RetVal = rb;
			break;
			}
		rb = rb->Next;
		}
	return RetVal;
	}

// Moves any necessary gadgets after a window has been re-sized.
void UpdateGadgets(GuiWindow *winptr)
	{
	BOOL ForSubList;
	UWORD GadPos;
	EditBox *eb = Gui.FirstEditBox;
	OutputBox *ob = Gui.FirstOutputBox;
	PushButton *pb = Gui.GGLfirst;
	TickBox *tb = Gui.FirstTickBox;
	RadioButton *rb = Gui.FirstRadioButton;
	ProgressBar *pi = Gui.FirstProgressBar;
	Frame *fr = Gui.FirstFrame;
	ListBox *lb = Gui.FirstListBox;
	register double HeightFactor = winptr->Win->Height / (double) winptr->NewWin.Height;
	register double WidthFactor = winptr->Win->Width / (double) winptr->NewWin.Width;

	while (tb)
		{
		if ((struct Window *) tb->TickBoxGad.UserData == winptr->Win && (tb->WidgetData->flags & S_AUTO_SIZE))
			{ // We've found a tick box that needs moving.
			if (tb->hidden == 0)
				GadPos = RemoveGList(winptr->Win, &tb->TickBoxGad, 1L);
			if (tb->hidden != 0 || GadPos != -1)
				{
				ResizeTickBox(tb, (int) (tb->WidgetData->os->left * WidthFactor), (int) (tb->WidgetData->os->top * HeightFactor), (int) (tb->WidgetData->os->width * WidthFactor), (int) (tb->WidgetData->os->height * HeightFactor), tb->hidden == 0);
				if (tb->hidden == 0)
					AddGList(winptr->Win, &tb->TickBoxGad, (unsigned long) GadPos, 1L, NULL);
				}
			}
		tb = tb->Next;
		}

	while (rb)
		{
		if ((struct Window *) rb->RBGad.UserData == winptr->Win && (rb->WidgetData->flags & S_AUTO_SIZE))
			{ // We've found a radio button that needs moving.
			if (rb->hidden == 0)
				GadPos = RemoveGList(winptr->Win, &rb->RBGad, 1L);
			if (rb->hidden != 0 || GadPos != -1)
				{
				ResizeRadioButton(rb, (int) (rb->WidgetData->os->left * WidthFactor), (int) (rb->WidgetData->os->top * HeightFactor), (int) (rb->WidgetData->os->width * WidthFactor), (int) (rb->WidgetData->os->height * HeightFactor), rb->hidden == 0);
				if (rb->hidden == 0)
					AddGList(winptr->Win, &rb->RBGad, (unsigned long) GadPos, 1L, NULL);
				}
			}
		rb = rb->Next;
		}

	while (ob)
		{
		if (ob->win == winptr && (ob->WidgetData->flags & S_AUTO_SIZE))
			// We've found an output box that needs moving.
			ResizeOutputBox(ob, (int) (ob->WidgetData->os->left * WidthFactor), (int) (ob->WidgetData->os->top * HeightFactor), (int) (ob->WidgetData->os->width * WidthFactor), ob->hidden == 0);
		ob = ob->next;
		}

	while (eb)
		{
		ForSubList = FALSE;
		if (eb->list)
			if (eb->list->Parent) // It's a sub-list box.  These don't have gadgets and don't need moving!
				ForSubList = TRUE;
		if ((GuiWindow *) eb->editbox.UserData == winptr && (eb->WidgetData->flags & S_AUTO_SIZE) && !ForSubList)
			{ // We've found an edit box or drop-down list box that needs moving.
			double NewWidth;

			/*	On older Amigas, drop-down list boxes won't be in the gadget list so we needn't remove them
				and we mustn't put them in the list afterwards! */
			if (eb->hidden != 0 || (eb->list && Gui.LibVersion < A3000))
				GadPos = 0;
			else
				GadPos = RemoveGList(winptr->Win, &eb->editbox, 1L); // returns -1 for failure.
			if (GadPos != -1)
				{
				/*	If this is a drop-down list box which is currently dropped then we'll need to move the
					window. */
				if (eb->list)
					NewWidth = ((eb->WidgetData->os->width + DD_LIST_BOX_BUTTON_WIDTH) * WidthFactor) - DD_LIST_BOX_BUTTON_WIDTH;
				else
					NewWidth = eb->WidgetData->os->width * WidthFactor;
				if (editptr == eb && eb->list && eb->list->win && !eb->list->PopupWidth)
					{
					/*	Work out how far the window has to move (we can't just use the factors because the
						dd-list box is moving relative to the window but the dd-list box window is moving
						relative to the screen). */
					int dx = (eb->WidgetData->os->left * WidthFactor) - (double) eb->WidgetData->left;
					int dy = (eb->WidgetData->os->top * HeightFactor) - (double) eb->WidgetData->top;
					int dl = NewWidth - (double) eb->WidgetData->width;

					MoveWindow(eb->list->win->Win, dx, dy);
					Gui.DDListX = ((GuiWindow *) editptr->editbox.UserData)->Win->LeftEdge;
					Gui.DDListY = ((GuiWindow *) editptr->editbox.UserData)->Win->TopEdge;
					SizeWindow(eb->list->win->Win, dl, 0);
					}
				ResizeEditBox(eb, (int) (eb->WidgetData->os->left * WidthFactor), (int) (eb->WidgetData->os->top * HeightFactor), (int) NewWidth, eb->hidden == 0);
				/*	Add it back into the gadget list even if we're on an old amiga and it shouldn't be in the
					list. */
				if (eb->hidden == 0)
					AddGList(winptr->Win, &eb->editbox, (unsigned long) (GadPos == 0 ? ~0 : GadPos), 1L, NULL);
				}
			}
		eb = eb->next;
		}

	while (fr)
		{
		if ((GuiWindow *) fr->button.UserData == winptr && (fr->WidgetData->flags & S_AUTO_SIZE))
			{ // We've found a frame that needs moving.
			if (fr->hidden == 0)
				GadPos = RemoveGList(winptr->Win, &fr->button, 1L);
			if (GadPos != -1 || fr->hidden != 0)
				{
				TabControl *tc = NULL;
				double buttontop = fr->WidgetData->os->top * HeightFactor;
				double buttonheight = fr->WidgetData->os->height * HeightFactor;
				int ibuttonheight = (int) buttonheight;
				int ibuttontop = (int) buttontop;

				if (fr->WidgetData->ParentControl && (fr->WidgetData->flags & SYS_FM_ROUNDED) && ((TabControl *) fr->WidgetData->ParentControl)->WidgetData->ObjectType == TabControlObject)
					{
					/*	The frame is the button part of a tab control so when we resize it we need to ensure
						that the bottom edge of the button still touches the top edge of the tab control. */
					tc = (TabControl *) fr->WidgetData->ParentControl;
					ibuttonheight = tc->FirstTab->frame->button.TopEdge - ibuttontop;
					}

				ResizeFrame(fr, (int) (fr->WidgetData->os->left * WidthFactor), ibuttontop, (int) (fr->WidgetData->os->width * WidthFactor), ibuttonheight, fr->hidden == 0);
				if (tc && tc->SelectedTab->pb == fr)
					{
					// The frame is the selected tab of a tab control.
					Tab *t = tc->SelectedTab;

					if (t) // found the correct tab.
						{
						short width = fr->button.Width - (t->next == NULL ? 2 : 1);
						tc->FramePoints[0] = fr->button.LeftEdge - t->frame->button.LeftEdge + 1;
						tc->FramePoints[2] = tc->FramePoints[0] + width - 1;
						}
					}
				else if (fr->dark.NextBorder)
					{
					/*	The frame has a custom border.  I'm sure the user would appreciate it if we were to
						resize it.  Don't resize it if this frame is part of a tab control - it will be dealt
						with at the same place as the button's custom border is resized below. */
					if (!(fr->WidgetData->ParentControl && ((TabControl *) fr->WidgetData->ParentControl)->WidgetData->ObjectType == TabControlObject))
						{
						struct Border *cb = fr->dark.NextBorder;
						int l;

						for (l = 0; l < cb->Count; l++)
							{
							int x = 2 * l;
							cb->XY[x] = fr->cbCopy[x] * WidthFactor;
							cb->XY[x+1] = fr->cbCopy[x+1] * HeightFactor;
							}
						}
					}
				if (fr->hidden == 0)
					AddGList(winptr->Win, &fr->button, (unsigned long) GadPos, 1L, NULL);
				}
			}
		fr = fr->next;
		}

	while (pb)
		{
		if ((GuiWindow *) pb->button.UserData == winptr && (pb->WidgetData->flags & S_AUTO_SIZE))
			{ // We've found a button that needs moving.
			if (pb->hidden == 0)
				GadPos = RemoveGList(winptr->Win, &pb->button, 1L);
			if (pb->hidden != 0 || GadPos != -1)
				{
				/*	If the window has shrunk, this resize may trash the border so we need to refresh it
					later */
				ResizeButton(pb, (int) (pb->WidgetData->os->left * WidthFactor), (int) (pb->WidgetData->os->top * HeightFactor), (int) (pb->WidgetData->os->width * WidthFactor), (int) (pb->WidgetData->os->height * HeightFactor), pb->hidden == 0);
				if (pb->dark.NextBorder)
					{
					/*	The button has a custom border.  I'm sure the user would appreciate it if we were to
						resize it. */
					struct Border *cb = pb->dark.NextBorder;
					int l;

					for (l = 0; l < cb->Count; l++)
						{
						int x = 2 * l;
						cb->XY[x] = pb->cbCopy[x] * WidthFactor;
						cb->XY[x+1] = pb->cbCopy[x+1] * HeightFactor;
						}
					}
				if (pb->hidden == 0)
					AddGList(winptr->Win, &pb->button, (unsigned long) GadPos, 1L, NULL);
				}
			}
		pb = pb->Next;
		}

	while (pi)
		{
		if (pi->win == winptr && (pi->WidgetData->flags & S_AUTO_SIZE))
			// We've found a progress bar that needs moving.
			ResizeProgressBar(pi, (int) (pi->WidgetData->os->left * WidthFactor), (int) (pi->WidgetData->os->top * HeightFactor), (int) (pi->WidgetData->os->width * WidthFactor), (int) (pi->WidgetData->os->height * HeightFactor), pi->hidden == 0);
		pi = pi->Next;
		}

	while (lb)
		{
		if (lb->Win == winptr && (lb->WidgetData->flags & S_AUTO_SIZE))
			{
			ListBoxItem *lbi = lb->FirstTitle;
			// We've found a list box that needs moving.
			if (lb->itemlist)
				UndrawTreeControl(lb);
			ResizeListBox(lb, (int) (lb->WidgetData->os->left * WidthFactor), (int) (lb->WidgetData->os->top * HeightFactor), (int) (lb->WidgetData->os->width * WidthFactor), (int) (lb->WidgetData->os->height * HeightFactor), WidthFactor, HeightFactor, TRUE);
			if (lb->TabStop)
				{
				int i = 0;
				BOOL items = (lbi ? FALSE : TRUE); // Starting with titles or items
				if (!lbi)
					lbi = lb->FirstItem;
				while (lbi)
					{
					int *j = lb->TabStop, *k = lb->WidgetData->os->TabStop;
					for (; *j != 0; j = &j[1], k = &k[1])
						if (lbi->LeftEdge == ListBoxLeftEdge(lb, j[0]))
							lbi->LeftEdge = ListBoxLeftEdge(lb, (int) (((double) k[0]) * WidthFactor));
					lbi = lbi->NextText;
					if (lbi == NULL && !items)
						{
						items = TRUE;
						lbi = lb->FirstItem;
						}
					}
				while (lb->TabStop[i] != 0)
					{
					lb->TabStop[i] = lb->WidgetData->os->TabStop[i] * WidthFactor;
					i++;
					}
				}
			}
		lb = lb->NextListBox;
		}

	/* Draw the backgrounds for filled frames (even if the frame isn't autosizing because it may have
		been draw over by something that is. */
	fr = Gui.FirstFrame;
	while (fr)
		{
		if ((GuiWindow *) fr->button.UserData == winptr && fr->hidden == 0)
			{
			if (!(fr->WidgetData->flags & BN_CLEAR))
				AreaColFill(winptr->Win->RPort, fr->button.LeftEdge, fr->button.TopEdge, fr->points[8] + 1,
						fr->points[1] + 1, fr->light.BackPen);

			if (fr->bitmap)
				{
				GuiBitMap *ngbm, *gbm = fr->bitmap;

				fr->bitmap = NULL;
				while (gbm)
					{
					ngbm = gbm->next;
					if (gbm->obm)
						{
						AttachBitMapToControl(gbm->obm, fr, 0, 0, -1, -1, gbm->flags);
						FreeGuiBitMap(gbm->obm);
						}
					else
						AttachBitMapToControl(gbm, fr, 0, 0, -1, -1, BM_SCALE | (gbm->flags & BM_OVERLAY ? BM_OVERLAY : 0));
					if (gbm->bmi)
						GuiFree(gbm->bmi);
					FreeGuiBitMap(gbm);
					gbm = ngbm;
					}
				}
			}
		fr = fr->next;
		}
	// Draw button backgrounds for filled buttons.
	pb = Gui.GGLfirst;
	while (pb)
		{
		if ((GuiWindow *) pb->button.UserData == winptr && pb->hidden == 0)
			{
			if (!(pb->WidgetData->flags & BN_CLEAR))
				AreaColFill(winptr->Win->RPort, pb->button.LeftEdge, pb->button.TopEdge, pb->button.Width,
						pb->button.Height, pb->light.BackPen);

			if (pb->bitmap)
				{
				GuiBitMap *ngbm, *gbm = pb->bitmap;

				pb->bitmap = NULL;
				while (gbm)
					{
					ngbm = gbm->next;
					if (gbm->obm)
						{
						AttachBitMapToControl(gbm->obm, pb, 0, 0, -1, -1, gbm->flags);
						FreeGuiBitMap(gbm->obm);
						}
					else
						AttachBitMapToControl(gbm, pb, 0, 0, -1, -1, BM_SCALE | (gbm->flags & BM_OVERLAY ? BM_OVERLAY : 0));
					if (gbm->bmi)
						GuiFree(gbm->bmi);
					FreeGuiBitMap(gbm);
					gbm = ngbm;
					}
				}
			}
		pb = pb->Next;
		}
	// Draw backgrounds for filled tick boxes.
	tb = Gui.FirstTickBox;
	while (tb)
		{
		if ((struct Window *) tb->TickBoxGad.UserData == winptr->Win && !(tb->WidgetData->flags & BN_CLEAR))
			AreaColFill(winptr->Win->RPort, tb->TickBoxGad.LeftEdge, tb->TickBoxGad.TopEdge,
					tb->TickBoxGad.Width, tb->TickBoxGad.Height, tb->nsTick.FrontPen);
		tb = tb->Next;
		}
	// Draw the filled bits of currently selected radio buttons unless they are hidden.
	rb = Gui.FirstRadioButton;
	while (rb)
		{
		if ((struct Window *) rb->RBGad.UserData == winptr->Win && (rb->RBGad.Flags & GFLG_SELECTED) &&
				GadInWinList(&rb->RBGad, (struct Window *) rb->RBGad.UserData))
			DrawRBCentre(rb);
		rb = rb->Next;
		}
	// Redraw progress bars.
	pi = Gui.FirstProgressBar;
	while (pi)
		{
		if (pi->win == winptr)
			SetProgress(pi, pi->iprogress);
		pi = pi->Next;
		}
	// Refresh all of the output boxes
	ob = Gui.FirstOutputBox;
	while (ob)
		{
		/*	Refresh all output boxes in the window even if they haven't moved.  Updating other gadgets
			may have trashed them. */
		if (ob->win == winptr && ob->hidden == 0)
			{
			PrintIText(ob->win->Win->RPort, &ob->IText, 0, 0);
			DrawBorder(ob->win->Win->RPort, &ob->lborder, 0, 0);
			}
		ob = ob->next;
		}
	// Refresh all list boxes in the window.
	lb = Gui.FirstListBox;
	while (lb)
		{
		if (lb->Win == winptr)
			if (lb->itemlist)
			{
				DrawTreeControl(lb);

				// Update the vertical scroller
				if (lb->UD)
				{
					int top = 0, maxlen = 0, maxtop = 0;
					unsigned short body, pot;

					FindMaxSizes(lb->itemlist, &maxlen, &maxtop, &top);
					FindScrollerValues((maxtop + lb->Font->ta_YSize) / lb->Font->ta_YSize, (lb->WidgetData->height - 4 - (2 * lb->TBorder) - (lb->LR ? SCROLL_BUTTON_HEIGHT : 0)) / lb->Font->ta_YSize, (0 - CalcItemTop(lb->itemlist)) / lb->Font->ta_YSize, 1, &body, &pot);
					NewModifyProp(&lb->UD->ScrollGad, lb->Win->Win, NULL, AUTOKNOB | FREEVERT | PROPNEWLOOK, 0, pot, 0, body, 1);
				}
			}
			else
				ListBoxRefresh(lb);

		lb = lb->NextListBox;
		}
	// Refreshing a window's frame also refreshes all of the gadgets in the window.
	RefreshWindowFrame(winptr->Win);

	/* Now everything's been refreshed, if we're on an old Amiga, remove the list boxes from the
		gadget list again. */
	if (Gui.LibVersion < A3000)
		{
		eb = Gui.FirstEditBox;
		while (eb)
			{
			if (eb->list)
				if (!(eb->list->Parent))
					RemoveGList(winptr->Win, &eb->editbox, 1L);
			eb = eb->next;
			}
		}
	}

static void ReactivateLastEditBox(void)
	{
	if (editptr || (lastactiveDDListBox && Gui.LibVersion >= A3000))
		{
		EditBox *active = editptr ? editptr : lastactiveDDListBox;
		// We can only activate a gadget in the active window.
		ActivateWindow(((GuiWindow *) active->editbox.UserData)->Win);
		ActivateGadget(&active->editbox, ((GuiWindow *) active->editbox.UserData)->Win, NULL);
		}
	}

struct Window* FOXLIB IntuiWindow(REGA0 GuiWindow *gw)
	{
	if (gw && ISGUIWINDOW(gw))
		return gw->Win;
	return NULL;
	}

static BOOL IsUserGadget(struct IntuiMessage *WinMsg, GuiWindow *ModalWin)
	{
	struct Gadget *gad = WinMsg->IAddress;
	UserGadget *ug = Gui.FirstUserGadget;

	while (ug)
		{
		if (ug->gad == gad)
			{
			if (ug->win)
				{
				if (ug->win->Sleep)
					return TRUE;
				if (ModalWin && ug->win != ModalWin)
					return TRUE;
				}
			Stop = (*(ug->fn))(gad, WinMsg);
			Gui.Done = TRUE;
			return TRUE;
			}
		ug = ug->next;
		}
	return FALSE;
	}

void CheckListBoxKeyPress(void)
	{
	if (ListBoxKeyPress != 0)
		{
		// User pressed a key while in a list box.
		if (lastactiveDDListBox && !lastactiveDDListBox->list->win)
			if (ListBoxKeyPress == ' ')
				DropList(lastactiveDDListBox);
			else
				{
				struct ListElement *e = FindListBoxItem(ListBoxKeyPress, lastactiveDDListBox);
				if (e)
					{
					NewTopBox = lastactiveDDListBox;
					ListSelectAndActivate(FALSE, e);
					}
				}
		ListBoxKeyPress = 0;
		}
	}

TreeItem *FindItemByTop(TreeControl *tc, int top);

BOOL StartDragDrop(Frame *ObjPtr, GuiWindow *winptr, short MouseX, short MouseY)
	{
	BOOL retval = TRUE;

	if (ObjPtr->WidgetData->ObjectType == ListBoxObject || ObjPtr->WidgetData->ObjectType == TreeControlObjectType)
		{
		ListBox *ObjectPtr = (ListBox*) ObjPtr;
		TreeControl *tc = (TreeControl*) ObjPtr;
		int itemnum = 0;
		TreeItem *SelectedElem = NULL;

		if (ObjPtr->WidgetData->ObjectType == ListBoxObject)
			ListBoxItemFromXY(ObjectPtr, MouseX, MouseY, NULL, &itemnum);
		else
			SelectedElem = FindItemByTop(tc, MouseY - CalcItemTop(tc->itemlist) - tc->WidgetData->top - tc->TBorder - 1);

		if (SelectedElem || itemnum)
			{
			if (ObjectPtr->DragPointer)
				SetPointer(winptr->Win, ObjectPtr->DragPointer,
						(long) ObjectPtr->PointerHeight, (long) ObjectPtr->PointerWidth,
						(long) ObjectPtr->PointerXOffset, (long) ObjectPtr->PointerYOffset);
			else
				SetPointer(winptr->Win, ChipMemForDragPointer, 16L, 16L, -8L, -8L);
			if (ObjectPtr->Eventfn)
				{
				/* We're going to throw away the result of this function.  It's imperative
					that this function doesn't close any windows, destroy any controls etc. */
				if (ObjPtr->WidgetData->ObjectType == ListBoxObject)
					(*(ObjectPtr->Eventfn))(ObjectPtr, LB_DRAG, itemnum, &ObjectPtr->DragData);
				else
					{
					TCIntFnPtr tcfn = (TCIntFnPtr) tc->Eventfn;
					(*(tcfn))(tc, LB_DRAG, SelectedElem, &tc->DragData);
					}
				}
			}
		else
			retval = FALSE;
		}
	else if (ObjPtr->WidgetData->ObjectType == FrameObject)
		{
		Frame *ObjectPtr = (Frame*) ObjPtr;

		if (ObjectPtr->DragPointer)
			SetPointer(winptr->Win, ObjectPtr->DragPointer,
					(long) ObjectPtr->PointerHeight, (long) ObjectPtr->PointerWidth,
					(long) ObjectPtr->PointerXOffset, (long) ObjectPtr->PointerYOffset);
		else
			SetPointer(winptr->Win, ChipMemForDragPointer, 16L, 16L, -8L, -8L);
		if (ObjectPtr->Callfn)
			{
			/* We're going to throw away the result of this function.  It's imperative
				that this function doesn't close any windows, destroy any controls etc. */
			(*(ObjectPtr->Callfn))(ObjectPtr, FM_DRAG, MouseX - ObjectPtr->button.LeftEdge,
					MouseY - ObjectPtr->button.TopEdge, &ObjectPtr->DragData);
			}
		if (ObjectPtr->WidgetData->flags & FM_DRAGOUTLINE)
			DrawDragOutline(ObjectPtr, winptr, FALSE, TRUE, 0, 0);
		}
	return retval;
	}

void **GetDropData(Frame *ObjPtr)
	{
	if (ObjPtr->WidgetData->ObjectType == ListBoxObject || ObjPtr->WidgetData->ObjectType == TreeControlObjectType)
		{
		ListBox *ObjectPtr = (ListBox*) ObjPtr;
		return &ObjectPtr->DragData;
		}
	else if (ObjPtr->WidgetData->ObjectType == FrameObject)
		{
		Frame *ObjectPtr = (Frame*) ObjPtr;
		return &ObjectPtr->DragData;
		}
	return NULL;
	}

void DoScreenSignals(unsigned long Signals, BOOL reset)
	{
	// Find the screen that was signalled.
	unsigned long signal = 0;
	GuiScreen *scr = Gui.FirstScr;

	while (scr)
		{
		if (Signals & (1L << scr->LastWinSig))
			{
			signal = (1L << scr->LastWinSig);
			break;
			}
		scr = scr->NextScr;
		}
	if (scr)
		{
		Stop = (*(scr->LastWinFn))(scr);
		Gui.Done = TRUE;
		}
	else
		SetLastErr("Screen not found.");
	if (signal && reset)
		SetSignal(0L, signal); // Reset the signal.
	}

void DoConsoleSignals(unsigned long Signals, BOOL reset)
	{
	int lch;
	GuiWindow *winptr = FindWindowByConSignal(Signals);
	unsigned int SigRec = CheckForChars(Signals, &lch);

	if (SigRec && lch != -1)
		{
		unsigned char stream[2];
		stream[0] = lch;
		stream[1] = 0;
		ProcessKeys(stream, winptr, stModalWin);
		if (reset)
			SetSignal(0L, SigRec);
		}
	}

int Select(ListBox *lb, long x, long y, unsigned long seconds, unsigned long micros, Frame **FrameDownPtr);

#define WinToScreenX(gw,x)	((x)+(gw->Win->LeftEdge))
#define WinToScreenY(gw,y)	((y)+(gw->Win->TopEdge))

#define ScreenToWinX(gw,x) ((x)-(gw->Win->LeftEdge))
#define ScreenToWinY(gw,y) ((y)-(gw->Win->TopEdge))

#define WinToWinX(source,target,x) ScreenToWinX((target),WinToScreenX((source),(x)))
#define WinToWinY(source,target,y) ScreenToWinY((target),WinToScreenY((source),(y)))

void DoWindowSignals(unsigned long Signals, BOOL reset, ListBox **SelectedLB, Frame **FrameDragPtr,
			Frame **FrameDownPtr)
	{
	unsigned long SigRec;
	struct IntuiMessage *WinMsg;
	GuiWindow *winptr = FindWindowBySignal(Signals, &SigRec);

	while (SigRec && (WinMsg = (struct IntuiMessage *) GetMsg(winptr->Win->UserPort)))
		{
		if (!IsUserGadget(WinMsg, stModalWin))
			{
			if (reset)
				SetSignal(0L, SigRec);

			switch (WinMsg->Class)
				{
				ListBox *lb;
				unsigned short numchars;

				case IDCMP_RAWKEY:
					/* We can process key presses no-matter which window they're for as long as we
						don't activate any buttons in a window other than the modal one (if there is
						one). */
					if (GetConvertedKeys(WinMsg, &numchars))
						{
						unsigned char *stream = (unsigned char*) GuiMalloc((numchars+1)*sizeof(unsigned char), MEMF_CLEAR);
						if (stream)
							{
							// RKCbuffer isn't terminated so we need to make a terminated copy.
							strncpy((char*) stream, (char*) RKCbuffer, numchars);
							ProcessKeys(stream, winptr, stModalWin);
							GuiFree(stream);
							}
						}
					break;
				case GADGETUP :
					/*	If a modal window is open then only process the message if it is for the modal
						window */
					if (winptr == stModalWin || !stModalWin)
						{
						EditBox *eb;

						if (Action == ACTION_DRAG_BAR)
							{
							ListBox *lb = *SelectedLB;
							/*	The user has just released a drag-bar.  If there was an edit box active
								when they started dragging the bar we should reset it now. */
							Action = 0;
							*SelectedLB = NULL;
							ReactivateLastEditBox();

							/* Now, if the user has just released the drag-bar of a list box which has the
								LB_CURSOR flag set and during the drag, the hilighted item changed then
								we should call the users event function now. */
							if (lb)
								if (lb->WidgetData->flags & LB_CURSOR)
									if (lb->itemlist) // it's a tree control
										{
										if (SelectedLBHiItem != (ListBoxItem *) lb->hiitem)
											{
											Stop = ((TCIntFnPtr) *(lb->Eventfn))(lb, TC_CURSOR, lb->hiitem, NULL);
											Gui.Done = TRUE;
											}
										}
									else if (SelectedLBHiItem != lb->HiItem)
										{
										Stop = (*(lb->Eventfn))(lb, LB_CURSOR, lb->HiNum, NULL);
										Gui.Done = TRUE;
										}
							}
						else if (!(eb = FindEditBoxByWin(WinMsg)))
							{
							if (!NormalButtonFramePress(WinMsg, FrameDragPtr, FrameDownPtr))
								if (!ListScroll(WinMsg, winptr, SelectedLB))
									CheckTickBox(WinMsg);
							}
						else if (WinMsg->Code == 0) // (0 = return/enter)
							{
							// Return or enter pressed in an edit box.
							Action = ACTION_EB_RETURN;
							ActionPtr = eb;
							Gui.Done = TRUE;
							}
						}
					break;
				case GADGETDOWN :
					/*	If a modal window is open then only process the message if it is for the modal
						window */
					if (winptr == stModalWin || !stModalWin)
						{
						RadioButton *rb;
						PushButton *pb;
						lb = ListBoxScrollGad(WinMsg);
						/*	If the user has selected a list box's scroll gadget then make a note of which one
							and the currently hilighted item for when the user scrolls or releases it. */
						if (lb)
							{
							*SelectedLB = lb;
							SelectedLBHiItem = (lb->itemlist ? (ListBoxItem *) lb->hiitem : lb->HiItem);
							}
						if (!EditBoxSelected(WinMsg))
							{
							Frame *fr;

							if (pb = FindButtonByMsg(WinMsg))
								AutRepButtonPress(pb, winptr);
							else if (rb = FindRadioButtonByMsg(WinMsg))
								RadioButtonClick(rb);
							else if (fr = FindFrameByMsg(WinMsg))
								if ((fr->WidgetData->flags & FM_DRAG) && fr->Active)
									{
									*FrameDownPtr = fr;
									ActionX = WinMsg->MouseX;
									ActionY = WinMsg->MouseY;
									}
							}
//						else
//							DisplayMessage(WinMsg);
						}
					else
						{
						EditBox *ebp = FindEditBoxByWin(WinMsg);
						/*	If there is a modal window open and the user clicks in an editbox in a
							different window then deactivate the editbox immediately in order to prevent
							the user editing it.  We can use a simple call to DeActivateStrGad() rather
							than the more complex DeactivateUnknownEditBox() because the string gadget is
							not in the modal window so the resulting GadgetUp will be ignored anyway. */
						if (ebp)
							DeActivateStrGad();
						}
					break;
				case MENUPICK :
					/*	If a modal window is open then only process the message if it is for the modal
						window */
					if (winptr == stModalWin || !stModalWin)
						{
						Frame *frame;
						MenuNum = WinMsg->Code;

						if (MenuNum == MENUNULL && ((frame = FrameRClick(winptr, WinMsg)) != NULL))
							{
							if (editptr || lastactiveDDListBox)
								endedit();
							if (!(editptr || lastactiveDDListBox))
								{
								GuiWindow *w = GetWindow(frame);
								Action = ACTION_FRAME_RBUT;
								/* The window containing the frame that was clicked on may not be the active
									one when it is a right button click! */
								if (w == winptr)
									{
									ActionX = WinMsg->MouseX;
									ActionY = WinMsg->MouseY;
									}
								else
									{
									ActionX = WinMsg->MouseX + winptr->Win->LeftEdge - w->Win->LeftEdge;
									ActionY = WinMsg->MouseY + winptr->Win->TopEdge - w->Win->TopEdge;
									}
								ActionPtr = frame;
								Gui.Done = TRUE;
								}
							}
						else
							{
							MenuWinPtr = winptr;
							Gui.Done = TRUE;
							}
						}
					break;
				case MOUSEBUTTONS :
					/*	If a modal window is open then only process the message if it is for the modal
						window */
					if (winptr == stModalWin || !stModalWin)
						{
						if (WinMsg->Code == SELECTDOWN)
							{
							ListBox *FindIt = NULL;
							if (!DDListBoxSelect(WinMsg, winptr))
								if (FindIt = CheckListBox(WinMsg->MouseX, WinMsg->MouseY, winptr))
									{
									/* If this is the list box in a drop-down list boxes window then we want to
										perform the function now - since that function was specified by FoxGui we
										know it won't do any harm! */
									if (editptr && editptr->list && editptr->list->nlb == FindIt)
										Stop = Select(FindIt, (long) WinMsg->MouseX, (long) WinMsg->MouseY, WinMsg->Seconds, WinMsg->Micros, FrameDownPtr);
									else
										{
										Gui.Done = TRUE;
										Action = ACTION_LIST_BOX;
										ActionPtr = FindIt;
										ActionWin = winptr;
										ActionX = WinMsg->MouseX;
										ActionY = WinMsg->MouseY;
										GuiSecs = WinMsg->Seconds;
										GuiMicros = WinMsg->Micros;
										}
									}
							}
						else if (WinMsg->Code == SELECTUP && *FrameDragPtr)
							{
							Action = ACTION_DROP;
							ActionPtr = *FrameDragPtr;
							ActionX = WinMsg->MouseX;
							ActionY = WinMsg->MouseY;
							if ((*FrameDragPtr)->WidgetData->flags & FM_DRAGOUTLINE)
								DrawDragOutline(*FrameDragPtr, winptr, TRUE,  FALSE, 0, 0);
							*FrameDragPtr = NULL;
							Gui.Done = TRUE;
							}
						/*
						If the user has just dropped a list box,	that
						SELECTDOWN will be followed by a SELECTUP here which
						we need to filter out in order to prevent
						EditBoxSelected from resetting editptr
						*/
						else if (WinMsg->Code == SELECTUP && !(editptr && editptr->list))
						{
							Action = ACTION_EB_CLICK_OUT;
							ActionPtr = WinMsg->IAddress;
							Gui.Done = TRUE;
						}
						if (WinMsg->Code == SELECTUP)
							*FrameDownPtr = NULL;
						}
					break;
				case IDCMP_CLOSEWINDOW:
					if (winptr == stModalWin || !stModalWin)
						{
						if (editptr || lastactiveDDListBox)
							endedit();
						if (!(editptr || lastactiveDDListBox))
							{
							Action = ACTION_CLOSE;
							ActionPtr = winptr;
							Gui.Done = TRUE;
							}
						}
					break;
				case IDCMP_NEWSIZE:
					// The user has re-sized a window.  We may have to move some gadgets.
					Action = ACTION_RESIZE;
					ActionPtr = winptr;
					Gui.Done = TRUE;
					break;
				case IDCMP_DISKINSERTED:
					if (winptr->EventFn)
					{
						// The user has inserted a disk.
						Action = ACTION_DISKIN;
						ActionPtr = winptr;
						Gui.Done = TRUE;
					}
					break;
				case IDCMP_DISKREMOVED:
					if (winptr->EventFn)
					{
						// The user has removed a disk.
						Action = ACTION_DISKOUT;
						ActionPtr = winptr;
						Gui.Done = TRUE;
					}
					break;
				case IDCMP_ACTIVEWINDOW:
					if (winptr->EventFn)
					{
						Action = ACTION_WINDOW_ACTIVE;
						ActionPtr = winptr;
						Gui.Done = TRUE;
					}
					break;
				case IDCMP_MOUSEMOVE:
					/*	If a modal window is open then only process the message if it is for the modal
						window */
					if (winptr == stModalWin || !stModalWin)
						{
						if (*SelectedLB)
							{
							/*	User is dragging a list box scroll bar so update the imagery.  This won't
								cause a change of focus to occur but it will cause Intuition to remove the
								cursor from the currently active edit box if there is one so we'll have to put
								it back afterwards.  We'll have to do that when the user releases the mouse
								button (i.e. on the gadget up event).  If we try to do it here, the scroll gadget
								will still be active and so it won't work. */
							if ((*SelectedLB)->itemlist) // It's a tree control
								UpdateTCScrollGadImagery(*SelectedLB);
							else
								UpdateLBScrollGadImagery(*SelectedLB);
							// Make a note of the fact that the user is dragging a bar.
							Action = ACTION_DRAG_BAR;
							}
						else if (*FrameDownPtr && (WinMsg->MouseX != ActionX || WinMsg->MouseY != ActionY) &&
								*FrameDragPtr != *FrameDownPtr)
							{
							// The user is dragging a drag-dropable object.
							BOOL success = StartDragDrop(*FrameDownPtr, winptr, ActionX, ActionY);
							if (success)
								*FrameDragPtr = *FrameDownPtr;
							}
						else if (*FrameDragPtr)
							{
							GuiWindow *wOver;

							if ((*FrameDragPtr)->WidgetData->flags & FM_DRAGOUTLINE)
								DrawDragOutline(*FrameDragPtr, winptr, TRUE, TRUE, WinMsg->MouseX - ActionX,
									WinMsg->MouseY - ActionY);

							wOver = FindDropWindow(winptr, WinMsg->MouseX, WinMsg->MouseY);
							if (wOver)
								{
								ListBox *OverList;

								if ((OverList = FindDropList(wOver, WinToScreenX(winptr, WinMsg->MouseX),
										WinToScreenY(winptr, WinMsg->MouseY))) != NULL)
									{ // Over a listbox.
									if (OverList->itemlist) // It's a Tree Control
										{
										TreeItem *ItemOver = FindItemByTop(OverList, WinMsg->MouseY -
												CalcItemTop(OverList->itemlist) - OverList->WidgetData->top - OverList->TBorder - 1);
										if (ItemOver)
											{
											if (gDDLastTreeOver && gDDLastTreeOver != OverList)
												{
												ClearTreeControlDropNum(gDDLastTreeOver, gDDLastLeafOver);
												gDDLastTreeOver = OverList;
												gDDLastLeafOver = SetTreeControlDropNum(OverList, ItemOver, NULL);
												}
											else
												{
												gDDLastTreeOver = OverList;
												gDDLastLeafOver = SetTreeControlDropNum(OverList, ItemOver, gDDLastLeafOver);
												}
											}
										}
									else
										{
										int lbi = -1;
										ListBoxItemFromXY(OverList, WinToWinX(winptr, wOver, WinMsg->MouseX),
												WinToWinY(winptr, wOver, WinMsg->MouseY), NULL, &lbi);


										if (lbi != -1)
											{
											if (gDDLastListOver && gDDLastListOver != OverList)
												{
												ClearListBoxDropNum(gDDLastListOver, gDDLastItemOver);
												gDDLastListOver = OverList;
												gDDLastItemOver = SetListBoxDropNum(OverList, lbi, NULL);
												}
											else
												{
												gDDLastListOver = OverList;
												gDDLastItemOver = SetListBoxDropNum(OverList, lbi, gDDLastItemOver);
												}
											}
										}
									}
								else
									{
									if (gDDLastListOver && gDDLastItemOver)
										{
										ClearListBoxDropNum(gDDLastListOver, gDDLastItemOver);
										gDDLastListOver = NULL;
										gDDLastItemOver = NULL;
										}
									if (gDDLastTreeOver && gDDLastLeafOver)
										{
										ClearTreeControlDropNum(gDDLastTreeOver, gDDLastLeafOver);
										gDDLastTreeOver = NULL;
										gDDLastLeafOver = NULL;
										}
									}
								}
							}
						}
				default :
						// Allow the user to move windows even if there is a modal one above.
						if (editptr && editptr->list)
							{
							// If a drop-down list box is open, move the list.
							int Dx = ((GuiWindow *) editptr->editbox.UserData)->Win->LeftEdge - Gui.DDListX;
							int Dy = ((GuiWindow *) editptr->editbox.UserData)->Win->TopEdge - Gui.DDListY;
							if ((Dx || Dy) && !(editptr->list->PopupWidth))
								{
								MoveWindow(editptr->list->win->Win, Dx, Dy);
								Gui.DDListX = ((GuiWindow *) editptr->editbox.UserData)->Win->LeftEdge;
								Gui.DDListY = ((GuiWindow *) editptr->editbox.UserData)->Win->TopEdge;
								}
							}

					// The user may have just dragged this window across the screen.  Let's check.
					if ((winptr->NewWin.LeftEdge != winptr->Win->LeftEdge || winptr->NewWin.TopEdge !=
							winptr->Win->TopEdge) && winptr->EventFn)
						{
						winptr->NewWin.LeftEdge = winptr->Win->LeftEdge;
						winptr->NewWin.TopEdge = winptr->Win->TopEdge;
						Action = ACTION_WINDOW_DRAG;
						ActionPtr = winptr;
						Gui.Done = TRUE;
						}
					break;
				}
			ReplyMsg((struct Message *) WinMsg);
			}
		UpdateTimers();
		} // while GetMsg()
	if (NewDDListSelect)
		Stop = NewDDListBoxSelFn(NewDDListSelect);
	}

static Frame *FindDropFrame(GuiWindow *Target, int ScreenX, int ScreenY)
	{
	Frame *fr = Gui.FirstFrame;
	int x = ScreenX - Target->Win->LeftEdge;
	int y = ScreenY - Target->Win->TopEdge;

	while (fr)
		{
		if (GetWindow(fr) == Target)
			{
			BOOL rounded = ((fr->WidgetData->flags & SYS_FM_ROUNDED) && fr->points[1] + 1 >= 6 && !(fr->WidgetData->flags & FM_BORDERLESS));
			if (fr->Active && x >= fr->button.LeftEdge && x <= fr->button.LeftEdge + (rounded ?
					fr->points[24] : fr->points[8]) && y >= fr->button.TopEdge && y <= fr->button.TopEdge +
					fr->points[1] && (fr->WidgetData->flags & FM_DROP) && fr->hidden == 0)
				{
				fr = CheckForChildren(fr, x, y);
				break;
				}
			}
		fr = fr->next;
		}
	return fr;
	}

static ListBox *FindDropList(GuiWindow *Target, int ScreenX, int ScreenY)
	{
	ListBox *lb = Gui.FirstListBox;
	int x = ScreenX - Target->Win->LeftEdge;
	int y = ScreenY - Target->Win->TopEdge;

	while (lb)
		{
		if (GetWindow(lb) == Target)
			{
			if (x >= lb->WidgetData->left && x <= lb->WidgetData->left + lb->WidgetData->width && y >= lb->WidgetData->top && y <= lb->WidgetData->top + lb->WidgetData->height &&
					(lb->WidgetData->flags & LB_DROP) && lb->hidden == 0)
				break;
			}
		lb = lb->NextListBox;
		}
	return lb;
	}

static GuiWindow *FindDropWindow(GuiWindow *SourceWindow, short ActionX, short ActionY)
	{
	GuiWindow *DropWindow = NULL;

	if (SourceWindow)
		{
		struct Screen *sc = SourceWindow->Win->WScreen;
		if (sc)
			{
			struct Layer *la = WhichLayer(&(sc->LayerInfo), (long) ActionX + SourceWindow->Win->LeftEdge,
					(long) ActionY + SourceWindow->Win->TopEdge);
			if (la)
				{
				DropWindow = Gui.GWLfirst;
				while (DropWindow)
					{
					if (DropWindow->Win->WLayer == la)
						break;
					DropWindow = DropWindow->next;
					}
				}
			}
		}
	return DropWindow;
	}

extern int TCSelect(TreeControl *tc, long x, long y, unsigned long seconds, unsigned long micros, Frame **FrameDownPtr);

void DoActions(Frame **FrameDownPtr)
	{
	if (ActionPtr || MenuWinPtr)
		{
		GuiWindow *MWP = MenuWinPtr;
		void *AP = ActionPtr;
		ActionPtr = NULL; // Stop CheckMessages() from triggering this same function again.
		MenuWinPtr = NULL;

		if (AP)
			{
			switch (Action)
				{
				TickBox *tb;
				RadioButton *rb;
				PushButton *pb;
				Frame *f;
				GuiWindow *gw, *Target;
				ListBox *lb;
				EditBox *eb;
				struct IntuiMessage im;

				case ACTION_EB_CLICK_OUT:
					im.IAddress = (struct Gadget*) ActionPtr;
					EditBoxSelected(&im);
					break;

				case ACTION_EB_RETURN:
					eb = (EditBox *) AP;
					/*	The user has pressed return or enter, so call the validation function now
						because there won't be a GADGETDOWN message to follow, BUT don't call the
						validation function if the gadget up message isn't for the currently active
						editbox (i.e. this gadget up may have been caused by a call to
						SetEditBoxFocus or by a validation function returning FALSE after a tab). */
					if (eb == editptr)
						EditBoxSelected(NULL);
					lastactiveDDListBox = editptr = NULL;
					break;

				case ACTION_DISKIN:
					gw = (GuiWindow *) AP;
					// We know the window has an EventFn because we checked before we set ActionPtr
					Stop = (*(gw->EventFn))(gw, GW_DISKIN, 0, 0, NULL);
					break;
				case ACTION_DISKOUT:
					gw = (GuiWindow *) AP;
					// We know the window has an EventFn because we checked before we set ActionPtr
					Stop = (*(gw->EventFn))(gw, GW_DISKOUT, 0, 0, NULL);
					break;
				case ACTION_WINDOW_ACTIVE:
					gw = (GuiWindow *) AP;
					// We know the window has an EventFn because we checked before we set ActionPtr
					Stop = (*(gw->EventFn))(gw, GW_ACTIVE, 0, 0, NULL);
					break;
				case ACTION_WINDOW_DRAG:
					gw = (GuiWindow *) AP;
					// We know the window has an EventFn because we checked before we set ActionPtr
					Stop = (*(gw->EventFn))(gw, GW_DRAG, gw->Win->LeftEdge, gw->Win->TopEdge, NULL);
					break;
				case ACTION_RESIZE:
					gw = (GuiWindow *) AP;
					UpdateGadgets(gw);

					if (editptr || lastactiveDDListBox)
						endedit();
					if (gw->EventFn)
						Stop = (*(gw->EventFn))(gw, GW_SIZE, gw->Win->Width, gw->Win->Height, NULL);
					break;
				case ACTION_LIST_BOX:
					lb = (ListBox *) AP;
					if (editptr || lastactiveDDListBox)
						endedit();
					/*	endedit() could cause destruction of the list box (depending on what the user has
						in the event function) so let's check it still exists! */
					if (ListBoxExists(lb) && !(editptr || lastactiveDDListBox))
						{
						if (lb->WidgetData->flags & LB_DRAG)
							{
							*FrameDownPtr = (Frame*) lb;
							if (!(ActionWin->Win->Flags & WFLG_REPORTMOUSE))
								{
								Forbid();
								ActionWin->Win->Flags |= WFLG_REPORTMOUSE;
								Permit();
								DragWinFlagsChanged = TRUE;
								}
							}
						if (lb->itemlist) // It's a Tree Control really
							Stop = TCSelect((TreeControl *) lb, (long) ActionX, (long) ActionY, GuiSecs, GuiMicros, FrameDownPtr);
						else
							Stop = Select(lb, (long) ActionX, (long) ActionY, GuiSecs, GuiMicros, FrameDownPtr);
						}
					break;
				case ACTION_CLOSE:
					gw = (GuiWindow *) AP;
					if (gw->EventFn)
						Stop = (*(gw->EventFn))(gw, GW_CLOSE, 0, 0, NULL);
					if (!(Stop & GUI_CANCEL))
						CloseGuiWindow(gw);
					else
						Stop = Stop - GUI_CANCEL;
					break;
				case ACTION_TICKBOX:
					tb = (TickBox *) AP;
					if (SetTickBoxValue(tb, !tb->Ticked))
						if (tb->Callfn)
				         Stop = (*(tb->Callfn))(tb);
					break;
				case ACTION_BUTTON:
					pb = (PushButton *) AP;
					if (pb->Filefn)
						{
						SleepFile();
						Stop = (*(pb->Filefn))(GetFName(), GetPath());
						WakeFile();
						}
					else if (pb->Callfn)
						Stop = (*(pb->Callfn))(pb);
					break;
				case ACTION_FRAME_LBUT:
				case ACTION_FRAME_RBUT:
					f = (Frame *) AP;
					gw = GetWindow(f);
					if (f->Callfn)
						Stop = (*(f->Callfn))(f, Action == ACTION_FRAME_LBUT ? FM_LBUT : FM_RBUT, ActionX -
								f->button.LeftEdge, ActionY - f->button.TopEdge, NULL);
					break;
				case ACTION_RADIO_BUT:
					rb = (RadioButton *) AP;
					Stop = (*(rb->Callfn))(rb);
					break;
				case ACTION_DROP:
					Target = NULL; /* Initialising this in the declarations above DOES NOT WORK!  Compiler
											bug? */
					f = (Frame *) AP;
					gw = GetWindow(f);
					if (DragWinFlagsChanged)
						{
						Forbid();
						gw->Win->Flags &= ~WFLG_REPORTMOUSE;
						Permit();
						DragWinFlagsChanged = FALSE;
						}
					Target = FindDropWindow(gw, ActionX, ActionY);
					if (gw)
						ClearPointer(gw->Win);
					if (Target)
						{
						// Check whether the object was dropped onto another frame or a list box
						ListBox *DropList;
						Frame *dropFrame;
						void **DropData = GetDropData(f);

						if ((DropList = FindDropList(Target, WinToScreenX(gw, ActionX),
								WinToScreenY(gw, ActionY))) != NULL)
							{	// It was dropped in a listbox.
							if (gDDLastListOver && gDDLastItemOver)
								{
								ClearListBoxDropNum(gDDLastListOver, gDDLastItemOver);
								gDDLastListOver = NULL;
								gDDLastItemOver = NULL;
								}
							if (gDDLastTreeOver && gDDLastLeafOver)
								{
								ClearTreeControlDropNum(gDDLastTreeOver, gDDLastLeafOver);
								gDDLastTreeOver = NULL;
								gDDLastLeafOver = NULL;
								}
							if (DropList->Eventfn)
								if (DropList->itemlist) // It's a Tree Control
									{
									TreeItem *DroppedOver = FindItemByTop(DropList, ActionY -
											CalcItemTop(DropList->itemlist) - DropList->WidgetData->top - DropList->TBorder - 1);
									Stop = ((TCIntFnPtr) *(DropList->Eventfn))(DropList, TC_DROP, DroppedOver, DropData);
									}
								else
									{
									int lbi;
									ListBoxItemFromXY(DropList, WinToWinX(gw, Target, ActionX),
											WinToWinY(gw, Target, ActionY), NULL, &lbi);
									Stop = (*(DropList->Eventfn))(DropList, LB_DROP, lbi, DropData);
									}
							}
						else if ((dropFrame = FindDropFrame(Target, WinToScreenX(gw, ActionX),
								WinToScreenY(gw, ActionY))) != NULL)
							{	// It was dropped in a frame.
							if (dropFrame->Callfn)
								Stop = (*(dropFrame->Callfn))(dropFrame, FM_DROP, WinToWinX(gw, Target, ActionX)
										- dropFrame->button.LeftEdge, WinToWinY(gw, Target, ActionY)
										- dropFrame->button.TopEdge, DropData);
							}
						else // it was dropped in a window.
							{
							if ((Target->WidgetData->flags & GW_DROP) && Target->EventFn)
								Stop = (*(Target->EventFn))(Target, GW_DROP, WinToWinX(gw, Target, ActionX),
										WinToWinY(gw, Target, ActionY), *DropData);
							}
						}
				default:
					break;
				}
			AP = NULL;
			Action = 0;
			}
		else
			{ /* Process menu selections */
			struct MenuItem *item = NULL;
			if (MWP->FirstMenu && MWP->MenuFn)
				if (MenuNum != MENUNULL)
					{
					if (editptr || lastactiveDDListBox)
						endedit();
					if (!(editptr || lastactiveDDListBox))
						while (MenuNum != MENUNULL)
							{
							item = (struct MenuItem *) ItemAddress(MWP->FirstMenu, MenuNum);
							MenuNum = item->NextSelect;
							Stop = (*(MWP->MenuFn))(MWP, item);
							}
					}
			MWP = NULL;
			MenuNum = MENUNULL;
			if (!item)
				if (editptr)
					ActivateGadget(&editptr->editbox, ((GuiWindow *) editptr->editbox.UserData)->Win, NULL);
				else if (lastactiveDDListBox)
					ActivateGadget(&lastactiveDDListBox->editbox, ((GuiWindow *) lastactiveDDListBox->editbox.UserData)->Win, NULL);
			}
		}
	}

void FOXLIB CheckMessages(void)
	{
	GuiWindow *gwl;
	GuiScreen *gs;
	unsigned long WinSignals, ScrSignals, ConSignals, Signals;
	BOOL SomeSignals = TRUE;
	static ListBox *SelectedLB = NULL;
	static Frame *FrameDragPtr = NULL;
	static Frame *FrameDownPtr = NULL;

	/* If this doesn't work too well the alternative is to make SelectedLB non-static and change the line
		below to "while (SomeSignals || SelectedLB)" so that the loop won't end until the user stops
		dragging the scroll bar.  That may be a better way anyway!
		The same may also be true of FrameDragPtr & FrameDownPtr which point to a frame being dragged. */
	while (SomeSignals)
		{
		WinSignals = ScrSignals = ConSignals = 0L;
		SomeSignals = FALSE;
		gwl = Gui.GWLfirst;
		gs = Gui.FirstScr;

		// Create our signal masks
		while (gwl)
			{
			WinSignals |= gwl->WindowSig;
			ConSignals |= gwl->ConReadSig;
			gwl = gwl->next;
			}
		while (gs)
			{
			ScrSignals |= (1L << gs->LastWinSig);
			gs = gs->NextScr;
			}

		CheckListBoxKeyPress();

		// Check for signals
		Signals = SetSignal(0L, 0L);

		if (Signals & ScrSignals)
			{
			SomeSignals = TRUE;
			DoScreenSignals(Signals, TRUE);
			}
		if (Signals & ConSignals)
			{
			SomeSignals = TRUE;
			DoConsoleSignals(Signals, TRUE);
			}
		if (Signals & WinSignals)
			{
			SomeSignals = TRUE;
			DoWindowSignals(Signals, TRUE, &SelectedLB, &FrameDragPtr, &FrameDownPtr);
			}
		//	Maybe DoActions() should only be called if Gui.Done == TRUE ?
		DoActions(&FrameDownPtr);
		}
	}

void WinMsgLoop(GuiWindow *ModalWin)
	{
   unsigned long signals;
	ListBox *SelectedLB = NULL;
	Frame *FrameDragPtr = NULL;
	Frame *FrameDownPtr = NULL;

	stModalWin = ModalWin;

	if (ModalWin)
		{
		/*	On an A500 (unlike newer Amigas) if a new window is opened when a string gadget is active,
			the string gadget will remain active and the new window won't get activated.  This code solves
			that problem and although it is unnecessary on newer Amigas it doesn't do any harm. */
		DeactivateUnknownEditBox();
		ActivateWindow(ModalWin->Win);
		}

   AbortAllMessages();                 /* Abort IO for windows opened before GuiLoop started */
	ListBoxKeyPress = 0;
   Stop = GUI_CONTINUE;
   while (Stop & GUI_CONTINUE) //The user will return GUI_END or GUI_MODAL_END to exit this loop.  GUI_END will also end the program.
		{
      QueueAllMessages();
      Gui.Done = FALSE;
      ActionPtr = NULL;
		Action = 0;
      while (!Gui.Done)
         {
			CheckListBoxKeyPress();
         signals = Wait(Gui.consig | Gui.winsig | Gui.scrsig | UserSigMask);

			if (signals & Gui.scrsig)
				DoScreenSignals(signals, FALSE);

	      if (signals & Gui.consig)
				DoConsoleSignals(signals, FALSE);

         if (signals & Gui.winsig)
				DoWindowSignals(signals, FALSE, &SelectedLB, &FrameDragPtr, &FrameDownPtr);

			if ((signals & UserSigMask) && UserSigFn)
				{
				Stop = UserSigFn(signals & UserSigMask, UserSigData);
				Gui.Done = TRUE;
				}
			} // While (!Gui.Done)
		DoActions(&FrameDownPtr);
      AbortAllMessages();
      } // while (Stop == GUI_CONTINUE)
	/*	Set Stop back to GUI_CONTINUE so that if this is a modal window exiting, other windows will
		continue */
	Stop = GUI_CONTINUE;
	stModalWin = NULL;
	}

void FOXLIB GuiLoop(void)
   {
	WinMsgLoop(NULL);
   }

void _STD_5001_EndGui(void)
   {
   char errortext[100];
   Diagnostic("EndGui", ENTER, TRUE);
	while (Gui.FirstUserGadget)
		UnRegisterGadget(Gui.FirstUserGadget->gad);
	if (Gui.FirstProgressBar)
		{
		while (Gui.FirstProgressBar)
			DestroyProgressBar(Gui.FirstProgressBar, FALSE);
		}
	if (Gui.FirstTimer)
		DestroyAllTimers();
	if (Gui.FirstTickBox)
      DestroyAllTickBoxes(FALSE);
	if (Gui.FirstRadioButton)
      DestroyAllRadioButtons(FALSE);
	if (Gui.FirstListBox)
      DestroyAllListBoxes(FALSE);
   if (Gui.GGLfirst)
      DestroyAllButtons(FALSE);
   if (Gui.FirstEditBox)
      {
      DestroyAllEditBoxes(FALSE);
      DestroyAllDDListBoxes(FALSE);
      }
   if (Gui.FirstOutputBox)
      DestroyAllOutputBoxes(FALSE);
	if (Gui.FirstFrame)
		DestroyAllFrames(FALSE);
   if (Gui.GWLfirst)
      CloseAllWindows();
	if (Gui.FirstScr)
      {
      CloseAllGuiScreens();
		if (Gui.FirstScr) // Failed to close them all.
			SetLastErr("Failed to close FoxGui Screen(s).");
      }
	if (RKCevent)
		free(RKCevent);
	if (RKCbuffer)
		free(RKCbuffer);
   if (Gui.NumAllocs != 0)
      {
      sprintf(errortext, "%d Memory allocations not freed.", Gui.NumAllocs);
      SetLastErr(errortext);
      }
	if (ChipMemForPointer) FreeMem(ChipMemForPointer, sizeof(waitPointer));
	if (ChipMemForDragPointer) FreeMem(ChipMemForDragPointer, sizeof(GuiDragPointer));
	if (GuiFont.ta_Name)
		GuiFree(GuiFont.ta_Name);
	if (IFFParseBase)
		CloseLibrary((struct Library *) IFFParseBase);
	CloseLibrary(LayersBase);
	CloseLibrary((struct Library *) GfxBase);
	if (ConsoleDevice)
		{
		CloseDevice((struct IORequest *) &ioreq);
		ConsoleDevice = NULL;
		}
	CloseLibrary((struct Library *) IntuitionBase);
   Diagnostic("EndGui", EXIT, TRUE);
   }
