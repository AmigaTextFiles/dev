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

#define WINDOWSC

#include <proto/mathieeedoubbas.h>
#include <stdarg.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <libraries/asl.h>
#include <proto/asl.h>
#include <dos/dosextens.h>

#include "/FoxInclude/foxgui.h"
#include "FoxGuiTools.h"

#define PATH_SIZE 100

static char *DirText = "Drawer";
static char *AssignText = "Assign";
static BOOL VolumeList = FALSE;
static ListBox	*FileList;
static GuiWindow *FileWindow;
static OutputBox *lblFile, *lblPath;
static EditBox *FileNameBox = NULL, *PathBox = NULL;
static PushButton *LoadButton, *SaveButton, *FileDoneButton, *ParentButton, *VolumesButton;
static struct FileRequester *fr = NULL;
static char mask[100], Path[PATH_SIZE];

static struct FileList *CreateVolumeList(void);
static int VolumesFn(PushButton *pb);

void FOXLIB WriteText(REGA0 GuiWindow *gw, REGA1 char *text, REGD0 int x, REGD1 int y)
{
	struct IntuiText it;

	it.FrontPen = Gui.TextCol;
	it.BackPen = 0;
	it.DrawMode = JAM1;
	it.LeftEdge = 0;
	it.TopEdge = 0;
	it.ITextFont = &GuiFont;
	it.IText = text;
	it.NextText = NULL;

	PrintIText(gw->Win->RPort, &it, x, y);
}

void CloseGuiWindow(GuiWindow *w)
   {
   short temp = Gui.CleanupFlag;
   Diagnostic("CloseGuiWindow", ENTER, TRUE);
   AbortAllMessages();
   if (w == Gui.GWLfirst)
      Gui.GWLfirst = w->next;
   else
      w->previous->next = w->next;
   if (w->next)
      w->next->previous = w->previous;
   Gui.CleanupFlag = TRUE;
	ClearMenus(w);
	DestroyWinTickBoxes(w, FALSE);
	DestroyWinListBoxes(w, FALSE);
	DestroyWinButtons(w, FALSE);
	DestroyWinDDListBoxes(w, FALSE);
	DestroyWinEditBoxes(w, FALSE);
	DestroyWinOutputBoxes(w, FALSE);
	DestroyWinTabControls(w, FALSE);
	DestroyWinFrames(w, FALSE);
	DestroyWinRadioButtons(w, FALSE);
	WakePointer(w);
   Gui.CleanupFlag = temp;
	if (w->ConReadSig != 0)
		{
	   CloseConsole(w->Con);
		GuiFree(w->Con);
		}
   CloseWindow(w->Win);
   GuiFree(w->WidgetData);
   GuiFree(w);
   QueueAllMessages();
   Diagnostic("CloseGuiWindow", EXIT, TRUE);
   }

static BOOL ICanOpenWindow(struct Screen *scr)
   {
   int count = 0;
	GuiWindow *w = Gui.GWLfirst;
   Diagnostic("ICanOpenWindow", ENTER, TRUE);

   while (w)
      {
      if (w->ParentScreen == scr && w->ConReadSig != 0)
         count++;
      w = w->next;
      }
	if (count > 4)
      SetLastErr("Cannot open another console.");

   Diagnostic("ICanOpenWindow", EXIT, TRUE);
	return (BOOL) (count < 5 && scr != NULL);
   }

//static short UpDownFillPoints[24] = { 1, 1, 10, 1, 1, 2, 10, 2, 1, 3, 10, 3, 1, 4, 10, 4, 1, 5, 10, 5, 1, 6, 10, 6 };
static short UpDownPoints[12] = { 0, 7, 0, 0, 10, 0, 1, 7, 11, 7, 11, 0 };
static struct Border
//	UDfill	= { (WORD) 0, (WORD) 0, (UBYTE) 0, (UBYTE) 2, (UBYTE) JAM1, (BYTE) 12, (WORD *) UpDownFillPoints, (struct Border *) NULL },
	Udark		= { (WORD) 0, (WORD) 0, (UBYTE) 2, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) &(UpDownPoints[6]), (struct Border *) NULL /* &UDfill */},
	Ulight	= { (WORD) 0, (WORD) 0, (UBYTE) 1, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) UpDownPoints, (struct Border *) &Udark },
	Usdark	= { (WORD) 0, (WORD) 0, (UBYTE) 1, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) &(UpDownPoints[6]), (struct Border *) NULL /* &UDfill */},
	Uslight	= { (WORD) 0, (WORD) 0, (UBYTE) 2, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) UpDownPoints, (struct Border *) &Usdark };
static struct Border
	Ddark		= { (WORD) 0, (WORD) 0, (UBYTE) 2, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) &(UpDownPoints[6]), (struct Border *) NULL /* &UDfill */},
	Dlight	= { (WORD) 0, (WORD) 0, (UBYTE) 1, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) UpDownPoints, (struct Border *) &Ddark },
	Dsdark	= { (WORD) 0, (WORD) 0, (UBYTE) 1, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) &(UpDownPoints[6]), (struct Border *) NULL /* &UDfill */},
	Dslight	= { (WORD) 0, (WORD) 0, (UBYTE) 2, (UBYTE) 2, (UBYTE) JAM1, (BYTE)  3, (WORD *) UpDownPoints, (struct Border *) &Dsdark };


/*	Although for private Gui windows, the second parameter can be derived from the first (pgs->scr), if
	the screen is public, the first parameter can be NULL because this function now gets all of the screen
	info it needs (apart from a pointer to the parent GuiScreen structure to copy into the GuiWindow
	structure) from the second parameter. */
GuiWindow *CreateGuiWindow(GuiScreen *pgs, struct Screen *Scr, int Left, int Top, int Width, int Height, int Dpen, int Bpen, char *Title, int flags, int (* __far __stdargs eventfn)(struct GWS*, int event, int x, int y, void*))
   {
   static long Number = 0L;
   GuiWindow *c;
   char name[5];
   Diagnostic("CreateGuiWindow", ENTER, TRUE);
	if (!Scr)
      {
      Diagnostic("CreateGuiWindow", EXIT, FALSE);
      return NULL;
      }
   if ((flags & GW_CONSOLE) && !ICanOpenWindow(Scr))
      {
      Diagnostic("CreateGuiWindow", EXIT, FALSE);
      return NULL;
      }
   sprintf(name, "%ld\0", ++Number);
   if (!(c = (GuiWindow *) GuiMalloc(sizeof(GuiWindow), 0)))
      {
      Diagnostic("CreateGuiWindow", EXIT, FALSE);
      return NULL;
      }
   if (!(c->WidgetData = (Widget *) GuiMalloc(sizeof(Widget), 0)))
      {
		GuiFree(c);
      Diagnostic("CreateGuiWindow", EXIT, FALSE);
      return NULL;
      }
	c->WidgetData->ObjectType = WindowObject;
	c->EventFn = eventfn;
	c->WidgetData->flags = flags;
	c->WidgetData->NextWidget = NULL;
	c->WidgetData->ChildWidget = NULL;

   c->NewWin.FirstGadget = NULL;

	c->NewWin.Screen = Scr;
   c->NewWin.LeftEdge = Left;
   c->NewWin.TopEdge = Top;
   c->NewWin.Width = Width;
   c->NewWin.Height = Height;
   c->NewWin.DetailPen = Dpen;
   c->NewWin.BlockPen = Bpen;
   c->NewWin.Title = Title;
	c->NewWin.MinWidth = Width;
	c->NewWin.MinHeight = Height;
	c->NewWin.MaxWidth = (unsigned short) ~0; // Allows a window as wide as the screen
	c->NewWin.MaxHeight = (unsigned short) ~0; // Allows a window as high as the screen
   c->NewWin.Flags = WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_NOCAREREFRESH;
	/* The IDCMP_MOUSEMOVE flag in the IDCMPFlags below does not cause mousemove messages to be generated
		for this window (WFLG_FOLLOWMOUSE in the Flags section above would do that).  IDCMP_MOUSEMOVE
		merely causes any MOUSEMOVE events sent to this window to be sent as IDCMP messages.  These
		MOUSEMOVE events may be sent by any gadget in the window which has GACT_FOLLOWMOUSE set in it's
		activation flags - causing MOUSEMOVE events to be sent only when the gadget is active. */
   c->NewWin.IDCMPFlags = GADGETUP | GADGETDOWN | MOUSEBUTTONS | INTUITICKS | MENUPICK | IDCMP_MOUSEMOVE
									| IDCMP_RAWKEY;
   if (flags & GW_DRAG)
      c->NewWin.Flags |= WFLG_DRAGBAR;
	if (flags & GW_BORDERLESS)
		c->NewWin.Flags |= WFLG_BORDERLESS;
	if (flags & GW_BACKDROP)
		c->NewWin.Flags |= WFLG_BACKDROP;
	if (flags & GW_DEPTH)
		c->NewWin.Flags |= WFLG_DEPTHGADGET;
	if (flags & GW_ACTIVE)
		c->NewWin.IDCMPFlags |= IDCMP_ACTIVEWINDOW;
	if (flags & GW_SIZE)
		c->NewWin.Flags |= WFLG_SIZEGADGET;
	if (flags & GW_SIZE || Gui.DroppingList)
		c->NewWin.IDCMPFlags |= IDCMP_NEWSIZE;
	if (flags & GW_DISKIN)
		c->NewWin.IDCMPFlags |= IDCMP_DISKINSERTED;
	if (flags & GW_DISKOUT)
		c->NewWin.IDCMPFlags |= IDCMP_DISKREMOVED;
	if (flags & GW_CLOSE)
		{
		c->NewWin.Flags |= WFLG_CLOSEGADGET;
		c->NewWin.IDCMPFlags |= IDCMP_CLOSEWINDOW;
		}
   c->NewWin.Type = (pgs ? CUSTOMSCREEN : PUBLICSCREEN);
   c->NewWin.CheckMark = NULL;
   c->NewWin.BitMap = NULL;
	/* Open the window using the 3D look but in a backwards compatible way
		rather than using OpenWindowTags() or OpenWindowTagList() which are
		simpler but not backwards compatible */
	if (!(c->Win = (struct Window *) OpenWindow((struct NewWindow *) &(c->NewWin))))
      {
      GuiFree(c->WidgetData);
      GuiFree(c);
      Diagnostic("CreateGuiWindow", EXIT, FALSE);
      return NULL;
      }
	if (flags & GW_CONSOLE)
		{
		if (!(c->Con = (struct Console *) GuiMalloc(sizeof(struct Console), 0)))
			{
      	CloseWindow(c->Win);
	      GuiFree(c->WidgetData);
	      GuiFree(c);
   	   Diagnostic("CreateGuiWindow", EXIT, FALSE);
      	return NULL;
			}
		if (!OpenConsole(c->Con, c->Win, name))
   	   {
			GuiFree(c->Con);
      	CloseWindow(c->Win);
	      GuiFree(c->WidgetData);
	      GuiFree(c);
   	   Diagnostic("CreateGuiWindow", EXIT, FALSE);
      	return NULL;
	      }
		}
   AbortAllMessages();
   c->WidgetData->Parent = pgs;
	c->ParentScreen = Scr;
	c->Enabled = c->OldStatus = TRUE;
	c->Sleep = FALSE;
	c->FirstMenu = NULL;
	c->MenuFn = NULL;
	if (flags & GW_CONSOLE)
	   c->ConReadSig = 1L << c->Con->RePort->mp_SigBit;
	else
		c->ConReadSig = 0;
   c->WindowSig  = 1L << c->Win->UserPort->mp_SigBit;
   c->previous = NULL;
   c->next = Gui.GWLfirst;
   if (Gui.GWLfirst)
      Gui.GWLfirst->previous = c;
   Gui.GWLfirst = c; 
   QueueAllMessages();
   Diagnostic("CreateGuiWindow", EXIT, TRUE);
   return c;
   }

BOOL FOXLIB SetWindowLimits(REGA0 GuiWindow *gw, REGD0 long minwidth, REGD1 long minheight, REGD2 unsigned long maxwidth, REGD3 unsigned long maxheight)
{
	return WindowLimits(gw->Win, minwidth, minheight, maxwidth, maxheight);
}

GuiWindow* FOXLIB OpenGuiWindow(REGA0 void *Scr, REGD0 int Left, REGD1 int Top, REGD2 int Width, REGD3 int Height,
		REGD4 int Dpen, REGD5 int Bpen, REGA1 char *Title, REGD6 int flags,
		REGA2 int (* __far __stdargs eventfn)(GuiWindow*, int, int, int, void*), REGA3 void *extension)
	{
	struct Screen *PubScr;
	GuiWindow *retval;

	if (!Scr)
		return NULL;

	if (ISGUISCREEN(Scr))
		{
		GuiScreen *sc = (GuiScreen *) Scr;
		return CreateGuiWindow(sc, sc->scr, Left, Top, Width, Height, Dpen, Bpen, Title, flags, eventfn);
		}

	// Scr is not a FoxGui screen so it must be the name of a public screen to open on.
	if (Gui.LibVersion < 36) // Public screens weren't available before release 36
		return NULL;

	PubScr = LockPubScreen((char *) Scr);
	if (!PubScr)
		return NULL;

	retval = CreateGuiWindow(NULL, PubScr, Left, Top, Width, Height, Dpen, Bpen, Title, flags, eventfn);
	/*	We can unlock the public screen now because if CreateGuiWindow() succeeded the new window will act
		as a lock on the public screen and if it failed then we don't need the lock anymore anyway! */
	UnlockPubScreen((char *) Scr, PubScr);
	return retval;
	}

void CloseAllWindows(void)
   {
   GuiWindow *w;
   Diagnostic("CloseAllWindows", ENTER, TRUE);
   while (w = Gui.GWLfirst)
		CloseGuiWindow(w);
   Diagnostic("CloseAllWindows", EXIT, TRUE);
   }

void CloseScrWindows(GuiScreen *sc)
   {
   GuiWindow *w = Gui.GWLfirst, *n;
   BOOL message = FALSE;
   Diagnostic("CloseScrWindows", ENTER, TRUE);
   while (w && sc)
      {
      n = w->next;
      if (w->ParentScreen == sc->scr)
         {
         CloseGuiWindow(w);
         message = TRUE;
         }
      w = n;
      }
      if (Gui.CleanupFlag && message)
         SetLastErr("Screen closed with windows still open.");
   Diagnostic("CloseScrWindows", EXIT, TRUE);
   }

#define FNAME_LEN 40
#define FS_SIZE	20
#define DT_LEN		14

struct FileList
	{
	long type, size;
	char FileName[FNAME_LEN + DT_LEN + 1];
	struct DateStamp Date;
	char sizestr[FS_SIZE + 1], *fns;
	struct FileList *Next;
	};

static int DaysInMonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

static char *SizeToString(long size, char *str)
	{
	/*	On return, str contains the size right aligned within FS_SIZE spaces.  The return value is the
		first non-space character in the string. */
	if (str)
		{
		sprintf(str, "%-d", size);
		return RightAlignString(str, FS_SIZE + 1, TRUE);
		}
	return NULL;
	}

static void DateStampToString(struct DateStamp *ds, char *str)
	{
	if (str && ds)
		{
		int Day = 1, Month = 0, Year = 1978;
		long days = ds->ds_Days;
		int hours = ds->ds_Minute / 60;
		int minutes = ds->ds_Minute % 60;
		char ctemplate[24 + 1];
		char tempstr[DT_LEN + 1];
		str[0] = 0;
		// Create the date bit
		// Dates start at Jan 1st 1978
		while (days > 0)
			{
			days--;
			if (++Day > DaysInMonth[Month])
				{
				Day = 1;
				if (++Month > 11)
					{
					Month = 0;
					Year++;
					}
				if (Month == 1) // Feb (months from 0-11)
					{
					// Check for a leap year.
					if (Year % 400 == 0)
						DaysInMonth[1] = 29;
					else if (Year % 4 == 0 && Year % 40 != 0)
						DaysInMonth[1] = 29;
					else
						DaysInMonth[1] = 28;
					}
				}
			}
		Month++; // Now in range 1-12.
		Year %= 100; // Strip off the century.
		sprintf(ctemplate, "%s%%-d/%s%%-d/%s%%-d", Day < 10 ? "0" : "", Month < 10 ? "0" : "",
				Year < 10 ? "0" : "");
		sprintf(tempstr, ctemplate, Day, Month, Year);
		strcat(str, tempstr);
		// Create the time bit
		sprintf(ctemplate, " %s%%-d:%s%%-d", hours < 10 ? "0" : "", minutes < 10 ? "0" : "");
		sprintf(tempstr, ctemplate, hours, minutes);
		strcat(str, tempstr);
		}
	}

static void FreeFileList(struct FileList *fl)
	{
	struct FileList *nf;

	while (fl)
		{
		nf = fl->Next;
		GuiFree(fl);
		fl = nf;
		}
	}

static struct FileList *CreateFileList(char *dir)
	{
	/* Given a directory path, creates a filelist containing the names, sizes and types of all the
		entries (files & directories) in that directory that match the current mask (if there is one) */

	struct FileList *FirstFile = NULL, *LastFile = NULL;
	struct FileInfoBlock *Fptr = (struct FileInfoBlock *) GuiMalloc(sizeof(struct FileInfoBlock), 0);
	BPTR LockPtr = Lock(dir, ACCESS_READ);

	if (LockPtr && Fptr)
		{
		BOOL ok;

		VolumeList = FALSE;
		if (!strcmp(dir, ":"))
			{
			BPTR ParentPtr = ParentDir(LockPtr);
			while (ParentPtr)
				{
				UnLock(LockPtr);
				LockPtr = DupLock(ParentPtr);
				UnLock(ParentPtr);
				ParentPtr = ParentDir(LockPtr);
				}
			}
		ok = Examine(LockPtr, Fptr);
		while (ok)
			{
			ok = ExNext(LockPtr, Fptr);
			if (ok)
				{
				BOOL addit = FALSE;

				if (Fptr->fib_DirEntryType > 0) // Add it because it's a directory
					// It's a directory so add it to the list.
					addit = TRUE;
				else if (strcmp(mask, ""))
					{
					int ptr = strlen(Fptr->fib_FileName) - strlen(mask);
					if (ptr >= 0)
						if (!stricmp(&Fptr->fib_FileName[ptr], mask))
							addit = TRUE; // Add it because it matches the mask
					}
				else // Add it because there is no mask
					addit = TRUE;

				if (addit)
					{
					struct FileList *fl = (struct FileList *) GuiMalloc(sizeof(struct FileList), MEMF_CLEAR);
					if (fl)
						{
						strncpy(fl->FileName, Fptr->fib_FileName, FNAME_LEN);
						memcpy(&fl->Date, &Fptr->fib_Date, sizeof(struct DateStamp));
						fl->type = Fptr->fib_DirEntryType;
						fl->size = Fptr->fib_Size;
						if (!LastFile)
							FirstFile = LastFile = fl;
						else
							{
							LastFile->Next = fl;
							LastFile = fl;
							}
						}
					} // if (addit)
				} // if (ok)
			} // while (ok)
		} // if (LockPtr && Fptr)
	else
		{
		/*	The user has supplied a bad directory/device name.  Give them a DisplayBeep and a list of
			volumes! */
		DisplayBeep(FileWindow->ParentScreen);

		FirstFile = CreateVolumeList();
		}
	if (LockPtr)
		UnLock(LockPtr);
	if (Fptr)
		GuiFree(Fptr);

	return FirstFile;
	}

static BOOL DirectoryList(ListBox *lb, struct FileList *FirstFile)
	{
	int files = 0;
	long longestfname = 0, longestsize = 0, Tab2, DigitLen;
	struct IntuiText temptext;
	struct FileList *cfl;

	if (!lb)
		return FALSE;

	// First work out the length of an intuitext digit in this font (we'll need this later).
	temptext.ITextFont = lb->Font;
	temptext.NextText = NULL;
	temptext.IText = "8";
	DigitLen = IntuiTextLength(&temptext);

	ClearListBoxItems(lb, FALSE);

	// First loop through and find the longest
	cfl = FirstFile;
	while (cfl)
		{
		long len;

		temptext.IText = cfl->FileName;
		len = IntuiTextLength(&temptext);
		if (len > longestfname)
			longestfname = len;
		if (VolumeList && cfl->type == DLT_VOLUME)
			{
			files++;
			cfl->sizestr[0] = 0;
			temptext.IText = cfl->fns = RightAlignString(cfl->sizestr, FS_SIZE + 1, FALSE);
			}
		else if (cfl->type > 0)
			{
			strcpy(cfl->sizestr, VolumeList ? AssignText : DirText);
			temptext.IText = cfl->fns = RightAlignString(cfl->sizestr, FS_SIZE + 1, FALSE);
			}
		else
			{
			files++;
			temptext.IText = cfl->fns = SizeToString(cfl->size, cfl->sizestr);
			}
		len = IntuiTextLength(&temptext);
		if (len > longestsize)
			longestsize = len;
		cfl = cfl->Next;
		}

	// Allow room for at least 7 digits (including commas) if files are present. 6 otherwise.
	longestsize = max(longestsize, (files > 0 ? 7 : 6) * DigitLen);

	longestfname += 2 * DigitLen;
	Tab2 = longestfname + longestsize + 2 * DigitLen;
	SetListBoxTabStops(lb, FALSE, 2, longestfname, Tab2);

	/*	Now put the whole string together and add the files to the list box (we'll add directories at
		the end. */
	cfl = FirstFile;
	while (cfl)
		{
		char *size = cfl->sizestr, *fc = cfl->fns;

		strcat(cfl->FileName, "\t");
		do
			{
			temptext.IText = fc;
			fc = &fc[-1];
			} while (fc >= size && IntuiTextLength(&temptext) < longestsize);
		strcat(cfl->FileName, temptext.IText);
		if (!VolumeList)
			{
			char DateStr[DT_LEN + 1];

			DateStampToString(&cfl->Date, DateStr);
			if (DateStr)
				{
				strcat(cfl->FileName, "\t");
				strcat(cfl->FileName, DateStr);
				}
			}
		if ((cfl->type <= 0 && !VolumeList) || (VolumeList && cfl->type == DLT_VOLUME))
			AddListBoxItem(lb, cfl->FileName, FALSE);
		cfl = cfl->Next;
		}
	// Put the files in alphabetical order
	if (files > 1)
		SortListBox(lb, ASCENDING | IGNORE_CASE, 1, FALSE);

	// Now add the directories at the end and free the list
	cfl = FirstFile;
	while (cfl)
		{
		if ((cfl->type > 0 && !VolumeList) || (VolumeList && cfl->type == DLT_DIRECTORY))
			AddListBoxItem(lb, cfl->FileName, FALSE);
		cfl = cfl->Next;
		}

	/*	If we've added more than one directory then sort them now by starting the sort at the first
		directory. */
	if (files + 1 < lb->NoItems)
		SortListBox(lb, ASCENDING | IGNORE_CASE, files + 1, TRUE);
	else
		ListBoxRefresh(lb);

	return TRUE;
	}

static BOOL IsDirText(char *text)
	{
	while (text[0] == ' ')
		text = &text[1];
	return (BOOL) (strcmp(text, DirText) == 0);
	}

/* static BOOL IsVolumeText(char *text)
	{
	while (text[0] == ' ')
		text = &text[1];
	if (strcmp(text, VolumeText) == 0)
		return TRUE;
	else if (strcmp(text, AssignText) == 0)
		return TRUE;
	return FALSE;
	} */

int FileListClickFn(ListBox *lb, short Event, int ItemNo, void **Data)
	{
	char *text = HiText(FileList); // HiText only returns the first string, in this case the directory name
	struct IntuiText *HiItem = lb->HiItem;
	int loop;
	struct FileList *fl;

	if (Event == LB_SELECT)
		{
		SleepFile();
		if (HiItem && HiItem->NextText && IsDirText(HiItem->NextText->IText) && HiItem->TopEdge ==
				HiItem->NextText->TopEdge)
			{
			if (strlen(Path) > 0 && !strchr(":/", Path[strlen(Path) - 1]))
				strcat(Path, "/");
			strcat(Path, text);
			// Remove trailing spaces
			for (loop = ((int) strlen(Path)) - 1; loop >= 0 && Path[loop] == ' '; Path[loop--] = 0);
			SetEditBoxText(PathBox, Path);
			SetEditBoxText(FileNameBox, "");
			fl = CreateFileList(Path);
			DirectoryList(FileList, fl);
			FreeFileList(fl);
			}
		else if (HiItem && VolumeList)
			{
			strcpy(Path, text);
			// Remove trailing spaces
			for (loop = ((int) strlen(Path)) - 1; loop >= 0 && Path[loop] == ' '; Path[loop--] = 0);
			if (Path[((int) strlen(Path)) - 1] != ':')
				strcat(Path, ":");
			SetEditBoxText(PathBox, Path);
			SetEditBoxText(FileNameBox, "");
			fl = CreateFileList(Path);
			DirectoryList(FileList, fl);
			FreeFileList(fl);
			}
		else
			SetEditBoxText(FileNameBox, text);
		WakeFile();
		}
	return GUI_CONTINUE;
	}

BOOL PathValidate(EditBox *eb)
	{
	short retval;
	struct FileList *fl;
	char *ptr = GetEditBoxText(eb);
	int pathlen;

	strncpy(Path, ptr, PATH_SIZE - 1);
	pathlen = strlen(Path);
	if (pathlen > 1)
		if (Path[pathlen - 1] == '/' && !strchr("/:", Path[pathlen - 2]))
			{
			// Remove a trailing / from the path name.
			Path[pathlen - 1] = 0;
			SetEditBoxText(eb, Path);
			}

	fl = CreateFileList(Path);
	retval = (short) DirectoryList(FileList, fl);
	FreeFileList(fl);
	SetEditBoxFocus(FileNameBox);

	return retval;
	}

BOOL FileNameValidate(EditBox *eb)
	{
	eb = eb;
	return TRUE;
	}

char *GetFName(void)
	{
	if (fr)
		return fr->rf_File;
	else
		return GetEditBoxText(FileNameBox);
	}

char *GetPath(void)
	{
	if (fr)
		return fr->rf_Dir;
	else
		return GetEditBoxText(PathBox);
	}

void FOXLIB SetFName(REGA0 char *fname)
	{
	if (FileNameBox && fname && !fr)
		SetEditBoxText(FileNameBox, fname);
	}

void FOXLIB SetPath(REGA0 char *path)
	{
	if (PathBox && path && !fr)
		SetEditBoxText(PathBox, path);
	}

void SleepFile(void)
	{
	if (!fr)
		SleepPointer(FileWindow);
	}

void WakeFile(void)
	{
	if (!fr)
		{
		WakePointer(FileWindow);
		if (FileNameBox)
			SetEditBoxFocus(FileNameBox);
		}
	}

void FOXLIB UpdateFList(void)
	{
	if (FileWindow && !fr)
		{
		struct FileList *fl = CreateFileList(Path);
		DirectoryList(FileList, fl);
		FreeFileList(fl);
		}
	}

static void ClearFileWindow(void)
	{
   DestroyWinButtons(FileWindow, FALSE);
	DestroyWinEditBoxes(FileWindow, FALSE);
	DestroyWinOutputBoxes(FileWindow, FALSE);
	DestroyWinListBoxes(FileWindow, FALSE);
	PathBox = NULL;
	FileNameBox = NULL;
	FileList = NULL;
	}

int FileDoneButtFn(PushButton *pb)
   {
   pb = pb;
	return GUI_MODAL_END;
   }

int FileWinEventFn(GuiWindow *win, int Event, int x, int y, void *data)
{
	win = win;

	if (Event == GW_CLOSE)
	{
		/*	We have to return GUI_MODAL_END because only GUI_MODAL_END will wake up the other windows.  There's
			no need to close the window, though, because that will be done after the return of winmsgloop() */
		return GUI_CANCEL | GUI_MODAL_END;
	}
	return GUI_CONTINUE;
}

int ParentFn(PushButton *pb)
   {
	int l;
	BOOL done = FALSE, parent = FALSE;
	struct FileList *fl;
	struct FileInfoBlock *Fptr;
	BPTR LockPtr;

	// Can't go any higher than a list of volumes!
	if (VolumeList)
		{
		SetEditBoxFocus(FileNameBox);
		return GUI_CONTINUE;
		}

	SleepFile();

	// Check whether the current path has a parent.
	Fptr = (struct FileInfoBlock *) malloc(sizeof(struct FileInfoBlock));
	LockPtr = Lock(Path, ACCESS_READ);

	if (LockPtr && Fptr)
		{
		BOOL ok = Examine(LockPtr, Fptr);
		if (ok)
			{
			BPTR ParentPtr = ParentDir(LockPtr);
			if (ParentPtr)
				{
				parent = TRUE;
				UnLock(ParentPtr);
				}
			}
		}
	if (LockPtr)
		UnLock(LockPtr);
	if (Fptr)
		free(Fptr);

	if (!parent)
		{
		// The current path has no parent so leave Path unchanged and give a list of volumes.

		fl = CreateVolumeList();
		DirectoryList(FileList, fl);
		FreeFileList(fl);
		WakeFile();

		return GUI_CONTINUE;
		}

	for (l = ((int) strlen(Path)) - 1; l >= 0; l--)
		if (l == ((int) strlen(Path)) - 1 && Path[l] == ':')
			{
			/*	The very last character is a : but we know that this directory has a parent because we
				checked (above) so this must be an assign.  Append a / to get the parent. */
			strcat(Path, "/");
			done = TRUE;
			break;
			}
		else if (Path[l] == ':')
			{ // The path is a device name followed by a : followed by a dir name.  Remove the dir name.
			memset(&Path[l + 1], 0, (PATH_SIZE - l - 1) * sizeof(char));
			done = TRUE;
			break;
			}
		else if (Path[l] == '/')
			{
			BOOL addslash = FALSE;

			/*	The path may be "[[device]:][directory]/[/]directory" or it may be "/" or "//" etc or it may
				be "[device]:[/]" .  If it's the former then we find the parent by removing the last
				specified directory name.  If it's any of the others then we find the parent by adding
				another "/" onto the end. */

			if (l > 0)
				{
				if (strchr(":/", Path[l - 1]))
					if (l == ((int) strlen(Path)) - 1)
						addslash = TRUE;
					else
						l++; // So that the last / or : isn't removed.
				}
			else
				addslash = TRUE;

			if (!addslash)
				// Remove the last dir name
				memset(&Path[l], 0, (PATH_SIZE - l) * sizeof(char));
			else
				strcat(Path, "/");
			done = TRUE;
			break;
			}

	if (!done)
		{
		int l;
		BOOL charfound = FALSE;

		/*	We looked right through the file name without encountering a : or a / so the path must be blank
			or relative to the current directory */

		for (l = ((int) strlen(Path)) - 1; l >= 0; l--)
			if (Path[l] != ' ')
				charfound = TRUE;

		// Blank the path.
		memset(Path, 0, PATH_SIZE * sizeof(char));

		if (charfound)
			{
			// Path is a directory beneath the current.  Blanking it is sufficient to find the parent.
			}
		else
			// Path is blank;
			Path[0] = '/';
		}

	SetEditBoxText(PathBox, Path);
	SetEditBoxText(FileNameBox, "");

	fl = CreateFileList(Path);
	DirectoryList(FileList, fl);
	FreeFileList(fl);

	WakeFile();

	return GUI_CONTINUE;
	}

struct TagItem FRtags[] =
	{
	ASL_Hail,		0L,
	ASL_OKText,		0L,
	ASL_CancelText,0L,
	ASL_Pattern,	0L,
	ASL_Window,		0L,
	ASL_FuncFlags,	0L,
	ASL_Height,		160,
	ASL_Width,		300,
	ASL_LeftEdge,	150,
	ASL_TopEdge,	18,
	ASL_Dir,			0L,
	ASL_File,		0L,
	TAG_DONE
	};

#define DEVICE_NAME_LEN	255

//extern long DOSBase;
static char DeviceName[DEVICE_NAME_LEN + 1];

static char *GetStr(BSTR bstr) // Takes a BSTR and converts it into a normal C str
	{
	int namelen;
	char *stringstart;

	/*	bstr is a BSTR (a BCPL string).  These have the length stored in the first byte
		and then the characters in successive following bytes but no NULL terminator. */

	stringstart = (char *) BADDR(bstr);
	if (!stringstart)
		return NULL;
	namelen = (int) *stringstart;
	stringstart = &(stringstart[1]);
	strncpy(DeviceName, stringstart, min(namelen, 255));
	DeviceName[min(namelen, 255)] = 0;

	return DeviceName;
	}

static struct FileList *CreateVolumeList(void)
	{
	if (DOSBase)
		{
		struct RootNode *rn = ((struct DosLibrary *)DOSBase)->dl_Root;
		struct DosInfo *di = NULL;
		struct DeviceList *dl = NULL;
		if (!rn)
			SetLastErr("No RootNode.");
		else
			di = (struct DosInfo *) BADDR(rn->rn_Info);
		if (!di)
			SetLastErr("No DosInfo.");
		else
			{
			/*	Disable multi-tasking because we're about to get the device list by illegal methods and we
				don't want intuition changing it while we're looking at it! */
			Forbid();
			dl = (struct DeviceList *) BADDR(di->di_DevInfo);
			}
		if (!dl)
			{
			Permit();
			SetLastErr("No DeviceList.");
			}
		else
			{
			struct FileList *FirstDev = NULL, *LastDev = NULL;
			struct DeviceList *Dev = dl;

			/*	Add the volumes and assigns only.  No need to worry about late binding assigns because if
				the OS is new enough to know about late binding assigns then it's new enough to use the
				ASL file requester instead of this one. */
			while (Dev)
				{
				if (Dev->dl_Type == DLT_VOLUME || Dev->dl_Type == DLT_DIRECTORY)
					if (GetStr(Dev->dl_Name))
						{
						struct FileList *f = (struct FileList *) GuiMalloc(sizeof(struct FileList), MEMF_CLEAR);
						if (f)
							{
							int DevNameLen;

							if (LastDev)
								{
								LastDev->Next = f;
								LastDev = f;
								}
							else
								FirstDev = LastDev = f;

							f->type = Dev->dl_Type;
							if (Dev->dl_Type == DLT_DIRECTORY && strlen(DeviceName) < DEVICE_NAME_LEN)
								strcat(DeviceName, ":");
							DevNameLen = strlen(DeviceName);
							strncpy(f->FileName, DeviceName, min(FNAME_LEN, DevNameLen));
							f->FileName[min(FNAME_LEN, DevNameLen)] = 0;
							}
						}
				Dev = (struct DeviceList *) BADDR(Dev->dl_Next);
				}
			Permit();

			VolumeList = TRUE;
			return FirstDev;
			}
		}
	else
		SetLastErr("No DOSBase.");
	return NULL;
	}

static int VolumesFn(PushButton *pb)
	{
	struct FileList *fl;

	pb = pb;
	SleepFile();

	// The Volumes button toggles between a list of volumes and the filelist for the specified path
	if (VolumeList)
		fl = CreateFileList(Path);
	else
		fl = CreateVolumeList();
	DirectoryList(FileList, fl);
	FreeFileList(fl);
	WakeFile();

	return GUI_CONTINUE;
	}

BOOL FOXLIB ShowFileRequester(REGA0 GuiWindow *Wnd, REGA1 char *path, REGA2 char *fname, REGA3 char *pattern, REGD0 char
		*title, REGD1 BOOL Save, REGD2 int (* __far __stdargs callfn) (char*, char*))
	{
	/*	The Window parameter is used to work out what screen the file requester should be shown on.  It
		shouldn't matter which window on that screen we use. */
	static BOOL firsttime = TRUE;

	// Store a pointer to the Window whose Screen currently recieves system requesters for this Process
	struct Window *ProcWindow = Gui.Proc->pr_WindowPtr;

	memset(mask, 0, sizeof(mask));
	if (path)
		{
		memset(Path, 0, sizeof(Path));
		strcpy(Path, path);
		}
	else if (firsttime)
		memset(Path, 0, sizeof(Path));
	firsttime = FALSE;
	if (pattern == NULL)
		pattern = "";
	if (fname == NULL)
		fname = "";

	if (AslBase = OpenLibrary("asl.library", 37L))
		{
		BOOL Okay = TRUE;
		strcpy(mask, "#?");
		strcpy(&mask[2], pattern);
		FRtags[0].ti_Data = (unsigned long) title;
		FRtags[1].ti_Data = (unsigned long) (Save ? "Save" : "Load");
		FRtags[2].ti_Data = (unsigned long) "Done";
		FRtags[3].ti_Data = (unsigned long) mask;
		FRtags[4].ti_Data = (unsigned long) Wnd->Win;
		FRtags[5].ti_Data = FILF_NEWIDCMP;	// Must set this every time to prevent the Save setting from
		if (Save)									// being perpetuated.
			FRtags[5].ti_Data |= FILF_SAVE;
		FRtags[10].ti_Data = (unsigned long) Path;
		FRtags[11].ti_Data = (unsigned long) fname;

		if (!(fr = (struct FileRequester *) AllocAslRequest(ASL_FileRequest, FRtags)))
			{
			CloseLibrary(AslBase);
			return FALSE;
			}

		// Make any file error related requesters go to the current applications screen.
		Gui.Proc->pr_WindowPtr = Wnd->Win;

		while (Okay)
			{
			Okay = AslRequest(fr, NULL);
			strncpy(Path, GetPath(), PATH_SIZE - 2);
			Path[PATH_SIZE - 1] = 0;
			if (callfn && Okay)
				{
				int callfnretval = (*callfn) (GetFName(), Path);

				if (callfnretval != GUI_CONTINUE)
					Okay = FALSE;
				}
			}

		// Redirect system requesters back to the screen they were previously sent to.
		Gui.Proc->pr_WindowPtr = ProcWindow;

		FreeAslRequest(fr);
		CloseLibrary(AslBase);
		fr = NULL;
		}
	else
		{
		struct FileList *fl;
		int twp = TopWindowPixel(Wnd->ParentScreen, NULL);
		strcpy(mask, pattern);

		if (!(FileWindow = CreateGuiWindow((GuiScreen*) Wnd->WidgetData->Parent, Wnd->ParentScreen, 144, 18, 312, 127 + twp, Wnd->NewWin.DetailPen, Wnd->NewWin.BlockPen, title, GW_CLOSE | GW_DRAG | GW_DEPTH | GW_SIZE, FileWinEventFn)))
			return FALSE;

		if (!(FileList = MakeListBox(FileWindow, 7, twp + 1, 286, 77, 2, 2, LB_SELECT | S_AUTO_SIZE, FileListClickFn, NULL)))
			{
			CloseGuiWindow(FileWindow);
			FileWindow = NULL;
			return FALSE;
			}

		SleepFile();

		lblPath			= MakeOutputBox(FileWindow, 7, twp + 82, 50, 6, 0, "Drawer", JUSTIFY_RIGHT | NO_BORDER | S_AUTO_SIZE, NULL);
		lblFile			= MakeOutputBox(FileWindow, 7, twp + 94, 50, 6, 0, "File", JUSTIFY_RIGHT | NO_BORDER | S_AUTO_SIZE, NULL);

		PathBox			= MakeEditBox(FileWindow, 60, twp + 82, 230, 34, 0, (void*) PathValidate, THREED | S_AUTO_SIZE | EB_CLEAR, NULL);
		FileNameBox		= MakeEditBox(FileWindow, 60, twp + 94, 230, 34, 0, FileNameValidate, THREED | S_AUTO_SIZE | EB_CLEAR, NULL);
		if (Save)
			SaveButton	= MakeFileButton(FileWindow, "_Save",    7, twp + 108, 68, 14, 's', NULL, callfn);
		else
			LoadButton	= MakeFileButton(FileWindow, "_Load",    7, twp + 108, 68, 14, 'l', NULL, callfn);
		VolumesButton	= MakeButton(FileWindow, "_Volumes", 79, twp + 108, 69, 14, 'p', NULL, VolumesFn, BN_CLEAR | BN_STD | S_AUTO_SIZE, NULL);
		ParentButton	= MakeButton(FileWindow, "_Parent", 152, twp + 108, 69, 14, 'p', NULL, ParentFn, BN_CLEAR | BN_STD | S_AUTO_SIZE, NULL);
		FileDoneButton	= MakeButton(FileWindow, "_Done",   225, twp + 108, 68, 14, 'd', NULL, FileDoneButtFn, BN_CLEAR | BN_STD | S_AUTO_SIZE, NULL);
		SetEditBoxText(PathBox, Path);
		SetEditBoxText(FileNameBox, fname);
		fl = CreateFileList(Path);
		DirectoryList(FileList, fl);
		FreeFileList(fl);
		WakeFile();

		// Make any file error related requesters go to the current applications screen.
		Gui.Proc->pr_WindowPtr = Wnd->Win;

		WinMsgLoop(FileWindow);

		// Redirect system requesters back to the screen they were previously sent to.
		Gui.Proc->pr_WindowPtr = ProcWindow;

		ClearFileWindow();
		CloseGuiWindow(FileWindow);
		}
	return TRUE;
	}

void FOXLIB WinPrint(REGA0 GuiWindow *w, REGA1 char *str)
{
	if (w && str)
		if (w->Con)
			ConPrint(w->Con, str);
}

void FOXLIB WinTab(REGA0 GuiWindow *w, REGD0 int x, REGD1 int y)
{
	if (w)
		if (w->Con)
			ConTab(w->Con, x, y);
}

void FOXLIB WinPrintTab(REGA0 GuiWindow *w, REGD0 int x, REGD1 int y, REGA1 char *str)
{
	if (w && str)
		if (w->Con)
			ConPrintTab(w->Con, x, y, str);
}

void FOXLIB WinPrintCol(REGA0 GuiWindow *w, REGA1 char *str, REGD0 int col)
{
	if (w && str)
		if (w->Con)
			ConPrintHi(w->Con, str, col);
}

void FOXLIB WinShowCursor(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConShowCursor(w->Con);
}

void FOXLIB WinHideCursor(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConHideCursor(w->Con);
}

void FOXLIB WinClear(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConClear(w->Con);
}

void FOXLIB WinHome(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConHome(w->Con);
}

void FOXLIB WinBlankToEOL(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConBlankToEOL(w->Con);
}

void FOXLIB WinWrapOn(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConWrapOn(w->Con);
}

void FOXLIB WinWrapOff(REGA0 GuiWindow *w)
{
	if (w)
		if (w->Con)
			ConWrapOff(w->Con);
}
