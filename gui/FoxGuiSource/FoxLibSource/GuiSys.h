/* FoxGUI - The fast, flexible, free Amiga GUI system
	Copyright (C) 2001 Simon Fox (Foxysoft)

This library is free software; you can redistribute it and/ormodify it under the terms of the GNU Lesser General PublicLicense as published by the Free Software Foundation; eitherversion 2.1 of the License, or (at your option) any later version.This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNULesser General Public License for more details.You should have received a copy of the GNU Lesser General PublicLicense along with this library; if not, write to the Free SoftwareFoundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
Foxysoft: www.foxysoft.co.uk      Email:simon@foxysoft.co.uk                */


#define INTUI_V36_NAMES_ONLY

#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <exec/memory.h>
#include <proto/iffparse.h>

#define A500     33
#define A3000    36
#define A500PLUS 37
#define A1200    39

#define ENTER    TRUE
#define EXIT     FALSE

#define GUI_WARNING (short) 0
#define GUI_ERROR   (short) 1

#define MAX_EDIT_BOX_LEN			256
#define DD_LIST_BOX_BUTTON_WIDTH	17

#define SCROLL_BUTTON_WIDTH	16  // It would be nice for this to be narrower but this is the smallest width that will display correctly on an old A500
#define SCROLL_BUTTON_HEIGHT	10

// Prototypes for functions that should be available gui wide but not to the end user...
char *GetFName(void);
char *GetPath(void);
void WinMsgLoop(GuiWindow *ModalWin);
PushButton *MakeFileButton(GuiWindow *Wptr, char *name, int left, int top, int width, int height, int key, struct Border *cb, int (*callfn) (char*, char*));
ListBox *CreateListBox(void *Parent, int left, int top, int width, int height, int lborder,
		int tborder, int frontpen, struct TextAttr *font, int __far __stdargs (*Eventfn) (ListBox*, short, int, void**),
		int flags, char *objecttype);
GuiWindow *CreateGuiWindow(GuiScreen *pgs, struct Screen *Scr, int Left, int Top, int Width, int Height, int Dpen, int Bpen, char *Title, int flags, int (* __far __stdargs eventfn)(struct GWS*, int, int, int, void*));
void SleepFile(void);
void WakeFile(void);
void ListBoxScrollUp(ListBox *nlb, BOOL refreshscroller);
void ListBoxScrollDown(ListBox *nlb, BOOL refreshscroller);
ListBoxItem* FOXLIB ItemElem(REGA1 ListBox *lb, REGA2 int target);
int ItemNum(ListBox *lb, ListBoxItem *target);
void ListBoxRehilight(ListBox *lb, int HiNum, ListBoxItem *HiElem, BOOL unhilight,
		BOOL hilight);
ListBoxItem *GetTopElem(ListBox *lb, int *topnum);
ListBoxItem *NextItem(ListBoxItem *Item);
int ListBoxItemFromXY(ListBox *lb, long x, long y, ListBoxItem **Item, int *ItemNum);
void ResizeButton(PushButton *Bptr, int x, int y, int width, int height, BOOL eraseold);
void ResizeEditBox(EditBox *eb, int x, int y, int len, BOOL eraseold);
void ResizeOutputBox(OutputBox *ob, int x, int y, int len, BOOL eraseold);
void ResizeRadioButton(RadioButton *rb, int x, int y, int width, int height, BOOL eraseold);
void ResizeTickBox(TickBox *tb, int x, int y, int width, int height, BOOL eraseold);
void ResizeProgressBar(ProgressBar *pb, int x, int y, int width, int height, BOOL eraseold);
void ResizeFrame(Frame *frame, int x, int y, int width, int height, BOOL eraseold);
void ResizeListBox(ListBox *lb, int x, int y, int width, int height, double xfactor, double yfactor, BOOL eraseold);
BOOL SetListBoxTabStops(ListBox *nlb, BOOL refresh, short num, ...);
void DrawRBCentre(RadioButton *rb);
BOOL HideProgressBar(ProgressBar *pb);
BOOL ShowProgressBar(ProgressBar *pb);
BOOL ShowFrame(Frame *Fptr);
BOOL HideFrame(Frame *Fptr);
BOOL HideListBox(ListBox *lb);
BOOL ShowListBox(ListBox *lb);
BOOL ShowDDListBox(DDListBox *p);
BOOL HideDDListBox(DDListBox *p);
BOOL ShowEditBox(EditBox *p);
BOOL HideEditBox(EditBox *p);
BOOL ShowButton(PushButton *Bptr);
BOOL HideButton(PushButton *Bptr);
BOOL HideOutputBox(OutputBox *p);
BOOL ShowOutputBox(OutputBox *p);
BOOL HideTickBox(TickBox *tb);
BOOL ShowTickBox(TickBox *tb);
BOOL HideRadioButton(RadioButton *rb);
BOOL ShowRadioButton(RadioButton *rb);
BOOL HideTabControl(TabControl *tc);
BOOL ShowTabControl(TabControl *tc);
void GuiSetLastErrAndLine(char *error, char *file, int line);
void DestroyButton(PushButton *Bptr, BOOL refresh);
void DestroyAllButtons(BOOL refresh);
void DestroyWinButtons(GuiWindow *w, BOOL refresh);
void DestroyTabControl(TabControl *tc, BOOL refresh);
void DestroyWinTabControls(GuiWindow *win, BOOL refresh);
void DestroyAllTabControls(BOOL refresh);
void DestroyFrame(Frame *Fptr, BOOL refresh);
void DestroyAllFrames(BOOL refresh);
void DestroyWinFrames(GuiWindow *w, BOOL refresh);
void DestroyRadioButton(RadioButton *rb, BOOL refresh);
void DestroyAllRadioButtons(BOOL refresh);
void DestroyWinRadioButtons(GuiWindow *gw, BOOL refresh);
void DestroyWinTickBoxes(GuiWindow *gw, BOOL refresh);
void DestroyAllTickBoxes(BOOL refresh);
void DestroyTickBox(TickBox *tb, BOOL refresh);
void DestroyDDListBox(DDListBox *p, BOOL refresh);
void DestroyAllDDListBoxes(BOOL refresh);
void DestroyWinDDListBoxes(GuiWindow *c, BOOL refresh);
void DestroyEditBox(EditBox *p, BOOL refresh);
void DestroyAllEditBoxes(BOOL refresh);
void DestroyWinEditBoxes(GuiWindow *c, BOOL refresh);
void DestroyOutputBox(OutputBox *p, BOOL refresh);
void DestroyAllOutputBoxes(BOOL refresh);
void DestroyWinOutputBoxes(GuiWindow *c, BOOL refresh);
BOOL DestroyListBox(ListBox *lb, BOOL refresh);
void DestroyAllListBoxes(BOOL refresh);
void DestroyWinListBoxes(GuiWindow *w, BOOL refresh);
void DestroyProgressBar(ProgressBar *pb, BOOL refresh);
BOOL DestroyTimer(Timer *t);
void DestroyAllTimers(void);
void EnableRadioButton(RadioButton *rb);
void DisableRadioButton(RadioButton *rb);
void EnableTickBox(TickBox *tb);
void DisableTickBox(TickBox *tb);
void DisableButton(PushButton *Bptr);
void DisableAllButtons(void);
void DisableWinButtons(GuiWindow *w);
void EnableButton(PushButton *Bptr);
void EnableAllButtons(void);
void EnableWinButtons(GuiWindow *w);
void DisableFrame(Frame *Fptr);
void DisableAllFrames(void);
void DisableWinFrames(GuiWindow *w);
void EnableFrame(Frame *Fptr);
void EnableAllFrames(void);
void EnableWinFrames(GuiWindow *w);
void DisableTabControl(TabControl *tc);
void EnableTabControl(TabControl *tc);
void DisableAllDDListBoxes(BOOL redraw);
void DisableWinDDListBoxes(GuiWindow *c, BOOL redraw);
void DisableEditBox(EditBox *p, BOOL redraw);
void DisableDDListBox(DDListBox *p, BOOL redraw);
void DisableAllEditBoxes(BOOL redraw);
void DisableWinEditBoxes(GuiWindow *c, BOOL redraw);
void EnableEditBox(EditBox *p, BOOL redraw);
void EnableDDListBox(DDListBox *p, BOOL redraw);
void EnableAllEditBoxes(BOOL redraw);
void EnableWinEditBoxes(GuiWindow *c, BOOL redraw);
void EnableAllDDListBoxes(BOOL redraw);
void EnableWinDDListBoxes(GuiWindow *c, BOOL redraw);
BOOL DisableListBox(ListBox *lb);
void DisableAllListBoxes(void);
void DisableWinListBoxes(GuiWindow *w);
BOOL EnableListBox(ListBox *lb);
void EnableAllListBoxes(void);
void EnableWinListBoxes(GuiWindow *w);
void CloseGuiWindow(GuiWindow *w);
void CloseAllWindows(void);
void CloseScrWindows(GuiScreen *sc);

#define NumLines(n)	((((n)->WidgetData->height - ((n)->LR ? SCROLL_BUTTON_HEIGHT : 0) - ((n)->NoTitles ? 5 : 2) - (((n)->NoTitles ? 4 : 2) * (n)->TBorder)) / (n)->Font->ta_YSize) - (n)->NoTitles)
#define ISGUIWINDOW(w)	(((GuiWindow *) w)->WidgetData->ObjectType == WindowObject)
#define ISGUISCREEN(s)	(((GuiScreen *) s)->WidgetData->ObjectType == ScreenObject)
#define SetLastErrAndLine(a,b)  GuiSetLastErrAndLine(a,__FILE__,b)
#define SetLastErr(a)           GuiSetLastErrAndLine(a,__FILE__,__LINE__)

//	Structure for storing a list of user-defined gadgets
typedef struct UGad
	{
	struct Gadget *gad;
	GuiWindow *win;
	struct UGad *next;
	int (*fn)(struct Gadget*, struct IntuiMessage *);
	} UserGadget;

struct GuiStruct
   {
	struct Process		*Proc; // A pointer to this Exec process
	GuiScreen			*FirstScr;
   OutputBox         *FirstOutputBox;
	EditBox				*FirstEditBox;
	ListBox				*FirstListBox;
	TickBox				*FirstTickBox;
	RadioButton			*FirstRadioButton;
	Frame					*FirstFrame;
   PushButton        *GGLfirst;
	GuiWindow			*GWLfirst;
	Timer					*FirstTimer;
	ProgressBar			*FirstProgressBar;
	TabControl			*FirstTabControl;
	UserGadget			*FirstUserGadget;
   struct IntuiText  Message1, Message2, Message3;
   struct NewWindow  MessageNWin;
   struct Window     *MessageWin;
   short             LibVersion;
   BOOL              CleanupFlag, DroppingList, Done, MessageDisplayed, ListFocusOnly;
   int               ARperiod, ARdelay, DDListX, DDListY;
	unsigned long     NumAllocs;
   FILE              *DebugFile;
   UBYTE             ibuf;
   unsigned long     consig, winsig, scrsig;
	short					HiPen, LoPen;
	ULONG					WBMode;
	UWORD					WBDepth;
	UWORD					WBPen[NUM_WB_PENS + 1];
	int					BorderCol, BackCol, TextCol;
   };

// Typedefs for functions returning an integer
typedef int __far __stdargs (*IntFnPtr)();
typedef int __far __stdargs (*LBIntFnPtr) (ListBox*,short,int,void **);
typedef int __far __stdargs (*TCIntFnPtr) (TreeControl*,short,TreeItem*,void **);


#ifdef FOXGUI
	#define EXT
#else
	#define EXT extern
#endif

EXT void		GuiReportError(char*, short);
EXT float	GetFloatFromStr(char*);
EXT void		QueueAllMessages(void);
EXT void		AbortAllMessages(void);

EXT struct IntuitionBase *IntuitionBase;
EXT struct GfxBase       *GfxBase;
EXT struct Library       *LayersBase;
EXT struct GuiStruct     Gui;
EXT char ListBoxKeyPress;
EXT BOOL FastMallocs;

EXT struct TextAttr GuiFont, GuiULFont;

EXT char *FrameObject
#ifdef FOXGUI
	= "Frame"
#endif
	;

EXT char *ButtonObject
#ifdef FOXGUI
	= "Button"
#endif
	;

EXT char *TabControlObject
#ifdef FOXGUI
	= "TabControl"
#endif
	;

EXT char *ListBoxObject
#ifdef FOXGUI
	= "ListBox"
#endif
	;

EXT char *TreeControlObjectType
#ifdef FOXGUI
	= "TreeControl"
#endif
	;

EXT char *DDListBoxObject
#ifdef FOXGUI
	= "DDListBox"
#endif
	;

EXT char *EditBoxObject
#ifdef FOXGUI
	= "EditBox"
#endif
	;

EXT char *OutputBoxObject
#ifdef FOXGUI
	= "OutputBox"
#endif
	;

EXT char *ProgressBarObject
#ifdef FOXGUI
	= "ProgressBar"
#endif
	;

EXT char *TickBoxObject
#ifdef FOXGUI
	= "TickBox"
#endif
	;

EXT char *RadioButtonObject
#ifdef FOXGUI
	= "RadioButton"
#endif
	;

EXT char *WindowObject
#ifdef FOXGUI
	= "Window"
#endif
	;

EXT char *ScreenObject
#ifdef FOXGUI
	= "Screen"
#endif
	;

EXT char *TimerObject
#ifdef FOXGUI
	= "Timer"
#endif
	;

#ifdef __STORM__
	#define ListBoxLeftEdge(a,b)	(int)((a)->LBorder+2+(b))
#else
	// Returns the LeftEdge of an item which has a tabstop of tabx
	static __inline int ListBoxLeftEdge(ListBox *lb, int tabx)
		{
			return lb->LBorder + 2 + tabx;
		}
#endif
