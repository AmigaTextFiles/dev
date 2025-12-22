#define FOXCONSOLE

#include <exec/types.h>
#include <stdio.h>
#include <utility/tagitem.h>
#include <intuition/intuition.h>

#ifdef CPPSOURCE
	#define EXTC extern "C"
#else
	#define EXTC
#endif

#ifdef __STORM__
	#define __far
	#define __asm
	#define __stdargs
	#define CALLBACK
	#define I_CALLBACK
	#define STORM_CALLBACK __saveds
#else
	#define STORM_CALLBACK
	#ifdef CPPSOURCE
		#define I_CALLBACK __stdargs
		#define CALLBACK __stdargs __saveds
	#else
		#define I_CALLBACK __far __stdargs
		#define CALLBACK __far __stdargs __saveds
	#endif
#endif


#define VAL_SPC  (char)32             /*   Space character               */
#define VAL_CR   (char)13             /*   Carriage return character     */
#define VAL_LF   (char)10             /*   Line feed character           */
#define VAL_BS   (char)8              /*   Back Space character          */
#define VAL_ESC  (char)27             /*   Escape character              */
#define VAL_DEL  (char)127            /*   Delete key (not del char)     */
#define VAL_CSI   (int)155            /*   Control sequence introducer   */

// Use on function prototypes
#define PROTOFOXLIB __far __asm
// Use on actual functions
#define FOXLIB __far __asm __saveds

#define REGA0	register __a0
#define REGA1	register __a1
#define REGA2	register __a2
#define REGA3	register __a3
#define REGD0  register __d0
#define REGD1  register __d1
#define REGD2  register __d2
#define REGD3  register __d3
#define REGD4  register __d4
#define REGD5  register __d5
#define REGD6  register __d6
#define REGD7  register __d7
#define REGFP0  register __fp0
#define REGFP1  register __fp1
#define REGFP2  register __fp2
#define REGFP3  register __fp3
#define REGFP4  register __fp4
#define REGFP5  register __fp5
#define REGFP6  register __fp6
#define REGFP7  register __fp7

#define FrameTypeID 1
#define ButtonTypeID 2
#define TabControlTypeID 3
#define ListBoxTypeID 4
#define TreeControlTypeID 5
#define DDListBoxTypeID 6
#define EditBoxTypeID 7
#define OutputBoxTypeID 8
#define ProgressBarTypeID 9
#define TickBoxTypeID 10
#define RadioButtonTypeID 11
#define WindowTypeID 12
#define ScreenTypeID 13
#define TimerTypeID 14

#define ET_RAWKEY      1
#define ET_RAWMOUSE    2
#define ET_EVENT       3
#define ET_POINTPOS    4
#define ET_TIMER       6
#define ET_GADGPRESS   7
#define ET_GADGRELEASE 8
#define ET_REQACT      9
#define ET_MENUNUM    10
#define ET_GADGCLOSE  11
#define ET_WINDOWSIZE 12
#define ET_WINDOWREF  13
#define ET_PREFCHANGE 14
#define ET_DISKREMOVE 15
#define ET_DISKINSERT 16

struct Console
   {
   struct MsgPort  *RePort, *WrPort;
   struct IOStdReq *ConIn,  *ConOut;
   };

void PROTOFOXLIB GetConsoleError(REGA1 char *details);
void PROTOFOXLIB CloseConsole(REGA0 struct Console *con);
int PROTOFOXLIB OpenConsole(REGA0 struct Console *con, REGA1 struct Window *win, REGA2 char *name);
void PROTOFOXLIB ConPutChar(REGA0 struct Console *con, REGD0 char ch);
void PROTOFOXLIB QueueRead(REGA0 struct Console *con, REGA1 UBYTE *whereto);
LONG PROTOFOXLIB ConMayGetChar(REGA0 struct Console *con, REGA1 UBYTE *whereto);
char PROTOFOXLIB ConGetChar(REGA0 struct Console *con, REGA1 UBYTE *ibuf);
void PROTOFOXLIB ConPrint(REGA0 struct Console *con, REGA1 char *String);
void PROTOFOXLIB ConClear(REGA0 struct Console *con);
void PROTOFOXLIB ConHome(REGA0 struct Console *con);
void PROTOFOXLIB ConBlankToEOL(REGA0 struct Console *con);
void PROTOFOXLIB ConTab(REGA0 struct Console *con, REGD0 int x, REGD1 int y);
void PROTOFOXLIB ConPrintTab(REGA0 struct Console *con, REGD0 int x, REGD1 int y, REGA1 char *str);
void PROTOFOXLIB ConWrapOff(REGA0 struct Console *con);
void PROTOFOXLIB ConWrapOn(REGA0 struct Console *con);
void PROTOFOXLIB ConHideCursor(REGA0 struct Console *con);
void PROTOFOXLIB ConShowCursor(REGA0 struct Console *con);
void PROTOFOXLIB ConPrintHi(REGA0 struct Console *con, REGA1 char *text, REGD0 int col);

void spc(FILE *outfp, int spaces);
char *RightAlignString(char *str, int lenstr, BOOL commas);
void PROTOFOXLIB SetSeed(REGD0 int Seed);
int PROTOFOXLIB Random(REGD0 int limit);

// Screens
#define GS_AUTOSCROLL		2
#define GS_DISPLAY_ID		4
#define GS_OVERSCAN			8
#define GS_PENS				16
#define GS_INTERLACE			32
#define GS_CLONEFONT			64
#define GS_CLONEPENS			128

// Windows
#define GW_DRAG				1
#ifdef OLD_LISTS
#define LIST_UPDATE_OFF		0
#define LINE_SCROLL			2
#define PAGE_SCROLL			4
#define LIST_UPDATE_ON		8
#endif
#define GW_CONSOLE			16
#define GW_DEPTH				32
#define GW_CLOSE				64
#define GW_BORDERLESS		128
#define GW_SIZE				256
#define GW_DROP				512
#define GW_BACKDROP			1024
#define GW_ACTIVE				2048
#define GW_DISKIN				4096
#define GW_DISKOUT			8192

#define ASCENDING				1
#define DESCENDING			2
#define NUM_ASCENDING		4
#define NUM_DESCENDING		8
#define IGNORE_CASE			16

#define GUI_CANCEL		8
#define GUI_MODAL_END	4
#define GUI_END			2
#define GUI_CONTINUE		1

// For all controls (but not windows)
#define S_AUTO_SIZE			128
#define S_FONT_SENSITIVE	8192

// Edit boxes
#define TEXT_EDIT				0
#define INT_EDIT				1
#define FLOAT_EDIT			2
#define NO_EDIT				4
#define EB_CLEAR				8
#define THREED					64
//      S_AUTO_SIZE			128

// Drop-down list boxes
#define DD_CLEAR				EB_CLEAR


// Output boxes
#define NO_BORDER				1
#define JUSTIFY_LEFT			2
#define JUSTIFY_CENTRE		4
#define JUSTIFY_RIGHT		8
#define OB_POST				16
#define OB_PRE					32
//      THREED					64
//      S_AUTO_SIZE			128
//      S_FONT_SENSITIVE	8192

// List Boxes
#define LB_CLIPPED					1 // Set if ListBoxClipOn() has been called with no matching ListBoxClipOff()
#define SYS_LB_VSCROLL				2
#define LB_DBLCLICK					4
#define LB_DRAG						8
#define LB_DROP						32
#define SYS_LB_HSCROLL				64
//      S_AUTO_SIZE					128
#define LB_CURSOR						256
#define LB_SELECT						512
#define LB_REHILIGHT_ON_SCROLL	1024

// Tree Controls
#define TC_CLIPPED					LB_CLIPPED
#define SYS_TC_VSCROLL				SYS_LB_VSCROLL
#define TC_DBLCLICK					LB_DBLCLICK
#define TC_DRAG						LB_DRAG
#define TC_DRAGIMAGE					LB_DRAGIMAGE
#define TC_DROP						LB_DROP
#define SYS_TC_HSCROLL				SYS_LB_HSCROLL
#define TC_CURSOR						LB_CURSOR
#define TC_SELECT						LB_SELECT
#define TC_REHILIGHT_ON_SCROLL	LB_REHILIGHT_ON_SCROLL
#define TC_CLOSEITEM					2048
#define TC_OPENITEM					4096

// Tree Items
#define TI_OPEN				1
#define TI_BITMAPISSCALED	2

// Tick boxes/Radio buttons
#define BG_CLEAR				1
#define BG_SELECTED			64
//      S_AUTO_SIZE			128

// Buttons
#define BN_STD					0		/* Standard button    */
#define BN_CLEAR				1
#define BN_AR					2		/* Auto repeat button */
#define BN_CANCEL				4		// A Cancel button can be activated by pressing the escape key.
#define BN_OKAY				8		// An Okay button can be activated by pressing the return key.
//      S_AUTO_SIZE			128
#define SYS_BN_HIDDEN		256
//      S_FONT_SENSITIVE	8192

// Images
#define BM_STUPID			0 // Opposite of BM_SMART
#define BM_OVERLAY		1
#define BM_SCALE			2
#define BM_CLIP			4
#define BM_SMART			8

// Frames
#define FM_CLEAR			BN_CLEAR
#define FM_LBUT			2
#define FM_RBUT			4
#define FM_DRAG			8
#define FM_DROP			32
#define FM_BORDERLESS	64
//      S_AUTO_SIZE		128
#define FM_DRAGOUTLINE	256
#define FM_SIZEOUTLINE	512 // For use by FoxEd only.
#define SYS_FM_ROUNDED	1024

// Tab controls
#define TC_CLEAR			FM_CLEAR
#define TC_FOXED			2

// Timers
#define TM_SECOND			1
#define TM_MINUTE			2

// Misc.
#define FAST_MALLOCS		1
#define GM_YES				1
#define GM_OKAY			1
#define GM_NO				2
#define GM_CANCEL			4
#define GM_EXCLAMATION	8
#define GM_QUESTION		16
#define GM_X				32
#define GM_STOP			64
#define GM_CROSSBONES	128
#define GM_INFORMATION	256

// Progress bars
#define PB_RAISED						0
#define PB_INSET						1
#define PB_CAPTION_CENTRE			2
#define PB_CAPTION_TOP_LEFT		4
#define PB_CAPTION_BOTTOM_LEFT	8
#define PB_CAPTION_TOP_RIGHT		0
#define PB_CAPTION_BOTTOM_RIGHT	16
#define PB_FILL_LR					0
#define PB_FILL_BT					32
//      S_AUTO_SIZE					128

/***************************************************************
 *                        Macros                               *
 ***************************************************************/

#define GuiFree(p)              GuiFreeMem(p,__LINE__,__FILE__)

#ifdef FOXGUI
   #define EXT
	char LastErr[256];
	char LastErrFile[256];
	int LastErrLine = 0;
#else
   #define EXT extern
	extern char *LastErr;
	extern char *LastErrFile;
	extern int LastErrLine;
#endif

#define NUM_WB_PENS 12

typedef struct
	{
	int left, top, width, height;
	int *TabStop;
	} OriginalSize;

typedef struct WidgetStruct
{
	char                *ObjectType;		     // Type of control.
	void                *Parent;			     // Container (Window or Frame) (For Windows, this will point to the Screen).
	OriginalSize        *os;				     // Original size data for resizable controls.
	int                 left, top;           // For font sensitive controls, left/top will be a multiple of the font width/height and
	int                 width, height;       // fs_left/fs_top are the remainders so the actual left is (left * font_width) + fs_left
	long                flags;				     // Need to keep a copy of the flags because not everything can be handled directly by the gadget.
	void                *NextWidget;		     // Next child of same Parent.
	void                *ChildWidget;	     // First control that this contains OR pointer to another control which makes up part of
													     // this control.  E.g. pointer to OutputBox used for pre/post text.
	void                *ParentControl;      // If this control is part of another control (e.g. if this is an outputbox used for
													     // pre/post text on another control) then this points to that control.  Otherwise NULL.
//	int                 fs_left, fs_top;     // For font sensitive controls, left/top will be a multiple of the font width/height and
                                            // fs_left/fs_top are the remainders so the actual left is (left * font_width) + fs_left
//	int                 fs_width, fs_height; // As for fs_left/fs_top
} Widget;

typedef struct GuiScrStruct
   {
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
   struct Screen    *scr;
   struct ExtNewScreen *nsc;
	struct TagItem *Screen_Tags;
	char   *PubName;
	UWORD  Pens[NUM_WB_PENS + 1];
	int    I_CALLBACK (* STORM_CALLBACK LastWinFn)(struct GuiScrStruct *);
	BYTE   LastWinSig;
	struct GuiScrStruct *NextScr;
   } GuiScreen;

struct ListElement
   {
   int						Itemnum;
   char						*string;
   struct ListElement	*Next;
   struct EditBoxStruct	*Child;
   };

typedef struct GWS
   {
	Widget            *WidgetData; // Do not move this item!  It must be first to match other controls.
	/*	Normally, we could get to the screen structure via the GuiScreen structure (i.e.
		win->WidgetData->Parent->scr) but in the case of a window opened on another applications public screen,
		the ParentGuiScr will be NULL so we need another handle directly onto the Screen structure, hence
		ParentScreen below. */
	/* Actually we don't need it at all because we can get it from the Window structure
		(gw->Win->WScreen) but never mind! */
	struct Screen		*ParentScreen;
   struct Console		*Con;
   struct Window		*Win;
   struct NewWindow	NewWin;
   unsigned long		ConReadSig, WindowSig;
	int					I_CALLBACK (* STORM_CALLBACK EventFn)(struct GWS*, int, int, int, void*);
	int					I_CALLBACK (* STORM_CALLBACK MenuFn)(struct GWS*, struct MenuItem*);
	BOOL					Enabled, Sleep, OldStatus, SysStatus;
   struct GWS			*next, *previous;
	struct Menu			*FirstMenu;
	struct Requester	Request;
   } GuiWindow;

typedef struct IntuiText ListBoxItem;

typedef struct
	{
	short points[20];
	struct Border DarkBorder, LightBorder;
	struct PB *ScrollUp, *ScrollDown;
	struct Gadget ScrollGad;
	struct PropInfo ScrollGadInfo;
	struct Image ScrollGadImage;
	} Scroller;

typedef struct GBMstruct
	{
	unsigned short width, height, depth;
	short  flags;
	struct BitMap *bm;
	struct BMIstruct *bmi; // Only used when the bitmap is on a control.  Otherwise NULL.
	struct GBMstruct *obm; // Points to the original bitmap when on a resizable control.  Otherwise NULL.
	struct GBMstruct *next;
	} GuiBitMap;

typedef struct BMIstruct
	{
	GuiWindow *win;
	unsigned short left, top;
	GuiBitMap *bm;
	} BitMapInstance;

typedef struct TreeItemS
{
	struct ListBoxStruct *treecontrol;
	struct IntuiText it;
	struct TreeItemS *next, *firstchild, *parent;
	struct PB *plusminus;
	short points[6];
	struct Border LineToParent;
	short flags;
	GuiBitMap *bm;
	BitMapInstance *bmi;
	void *itemdata;
} TreeItem;

typedef struct ListBoxStruct
	{
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
	struct GWS *Win;
	struct Border DarkBorder, LightBorder, UpArrow, DownArrow, TitleLightBorder, TitleDarkBorder;
	struct Border plus, minus; // Tree Control only
	short points[20], titlebevelpoints[20], hidden;
	int FrontPen;
	int xOffset;
	int LBorder, TBorder;
	int NoItems, NoTitles;
	int MaxIntuiLen, LongestIntuiLen, TopShown;
	ListBoxItem *FirstTitle, *FirstItem, *HiItem;	// List Box only
	TreeItem *itemlist, *topshown, *hiitem;			// Tree Control only
	int HiNum;
	struct TextAttr *Font;
	Scroller *LR, *UD;
	int *TabStop;
	BOOL modified; // Has the list box been modified since it was last refreshed?
	BOOL Enabled;
	struct ListBoxStruct *NextListBox;
	int I_CALLBACK (* STORM_CALLBACK Eventfn) (struct ListBoxStruct*, short, int, void**);
	unsigned short *DragPointer;
	short PointerWidth, PointerHeight, PointerXOffset, PointerYOffset;
	void *DragData;
	} ListBox;

typedef struct ListBoxStruct TreeControl;

typedef struct FrameStruct
	{
	// The first three items must not be moved.  They match the first five items in the PushButton struct.
	Widget             *WidgetData;
	struct Gadget      button;
	GuiBitMap          *bitmap;
	// Okay to move anything below this point.
	struct IntuiText   text;
	char               *t;
	struct Border      light, dark;
	short              points[28], *cbCopy, hidden;
	int                I_CALLBACK (* STORM_CALLBACK Callfn) (struct FrameStruct*, short, short, short, void**);
	BOOL               Active;
	unsigned short     *DragPointer;
	short              PointerWidth, PointerHeight, PointerXOffset, PointerYOffset;
	void               *DragData;
	struct FrameStruct *next;
	} Frame;

typedef struct PB
   {
	// The first three items must not be moved.  They match the first five items in the Frame struct.
	Widget           *WidgetData;
   struct Gadget    button;
	GuiBitMap        *bitmap;
	// Okay to move anything below this point.
   struct IntuiText text1, text2, text3;
	char             *t1, t2[2], *t3;
	struct TextAttr  *ULfont;
   struct Border    light, dark;
   struct Border    slight, sdark;
	short            points[12], *cbCopy, hidden;
   int              I_CALLBACK (* STORM_CALLBACK Callfn) (struct PB*);
	int              I_CALLBACK (* STORM_CALLBACK Filefn) (char*, char*);
   char             Key1, Key2;
   BOOL             Active, OldStatus, SysStatus;
   struct PB        *Next;
   } PushButton;

typedef struct TabStruct
	{
	Frame *frame, *pb;
	struct TabStruct *next;
	} Tab;

typedef struct TCStruct
	{
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
	Tab *FirstTab, *SelectedTab;
	struct Border CustomFrameBorder; // The same for every tab except the points
	short FramePoints[4];
	int I_CALLBACK (* STORM_CALLBACK Callfn) (Frame*);
	struct TCStruct *next;
	} TabControl;

typedef struct
{
	int I_CALLBACK (* STORM_CALLBACK callfn) (Frame*);
	int tabselected;
	int I_CALLBACK (* STORM_CALLBACK framefn) (Frame*, short, short, short, void**);
} TabControlExtension; // PRIVATE - only for use by FoxED

struct GuiList
   {
   int						TotalElems, Width, Height;
   BOOL						Update, ListBox;
   char						*Title1, *Title2, *Title3;
   struct ListElement	*First, *Last;
   int						TopShown, HighNum;
   };

struct DDListBoxStruct
   {
	GuiWindow				*win;
	ListBox					*nlb;
   int						MaxHeight, TotalElems;
   struct ListElement	*first;
   int						PopupWidth, PopupX, PopupY;
   struct EditBoxStruct	*Parent;
   };

typedef struct EditBoxStruct
   {
	Widget               *WidgetData; // Do not move this item!  It must be first to match other controls.
   int                  len, Bcol, Tcol, type, dp, id;
   char                 *buffer;
   BOOL                 I_CALLBACK (* STORM_CALLBACK valifn)(struct EditBoxStruct*);
   short                points[26], hidden;
   BOOL                 enabled, OldStatus, SysStatus;
   struct Border        lborder, dborder, arrow, bb1, bb2;
   struct EditBoxStruct *next, *previous;
   struct EditBoxStruct *NextAssociated, *PreviousAssociated;
   struct DDListBoxStruct *list;
	struct Gadget			editbox;
	struct StringInfo    strinfo;
	char						*undobuffer;
   } EditBox;

typedef struct EditBoxStruct DDListBox;

typedef struct OutputBoxStruct
   {
	Widget 						*WidgetData; // Do not move this item!  It must be first to match other controls.
   GuiWindow					*win;
	int							len, Bcol, Tcol, dp, id;
   short							points[20], hidden;
   struct Border				lborder, dborder;
	struct IntuiText			IText;
	char							*text;
	struct TextAttr			*font;
   struct OutputBoxStruct	*next, *previous;
   } OutputBox;

struct MutexList
	{
	struct RBStruct *Mutex;
	struct MutexList *Next;
	};

typedef struct RBStruct
	{
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
	short BevelPoints[20], hidden;
	struct Border BLight, BDark, sBDark, sBLight;
	struct Gadget RBGad;
	BOOL Active;
   int I_CALLBACK (* STORM_CALLBACK Callfn) (struct RBStruct *);
	struct MutexList *MList;
	struct RBStruct *Next;
	} RadioButton;

typedef struct TickBoxStruct
	{
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
	short BevelPoints[20], TickPoints[12], hidden;
	struct Border BLight, BDark, sTick, nsTick;
	struct Gadget TickBoxGad;
	BOOL Active, Ticked;
   int I_CALLBACK (* STORM_CALLBACK Callfn) (struct TickBoxStruct *);
	struct TickBoxStruct *Next;
	} TickBox;

typedef struct TimerStruct
	{
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
	long lasttrigger, timesecs, starttimesecs, pausetimesecs;
	BOOL running, paused;
	int I_CALLBACK (* STORM_CALLBACK Callfn) (struct TimerStruct *, long);
	struct TimerStruct *NextTimer;
	} Timer;

typedef struct PIStruct
	{
	Widget *WidgetData; // Do not move this item!  It must be first to match other controls.
	GuiWindow *win;
	struct Border light, dark;
	short fillcol, BevelPoints[20], hidden;
	int iprogress, max;
	struct IntuiText progress;
	struct PIStruct *Next;
	} ProgressBar;

/******************
	Progress Bars
******************/

EXTC ProgressBar* PROTOFOXLIB MakeProgressBar(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width,
		REGD3 int height, REGD4 short fillcol, REGD5 short flags, REGA1 void *extension);
EXTC void PROTOFOXLIB SetProgress(REGA0 ProgressBar *pb, REGD0 int progress);
EXTC void PROTOFOXLIB SetProgressMax(REGA0 ProgressBar *pb, REGD0 int progressmax);


/***********
	Frames
***********/

EXTC Frame* PROTOFOXLIB MakeFrame(REGA0 void *Parent, REGA1 char *name, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGA2 struct Border *cb, REGA3 int I_CALLBACK (*callfn) (Frame*, short, short, short, void**),
		REGD4 short flags, REGD5 void *extension);
void PROTOFOXLIB SetFrameDragPointer(REGA0 Frame *Fptr, REGA1 unsigned short *DragPointer, REGD0 int width, REGD1 int height, REGD2 int xoffset,
		REGD3 int yoffset);


/************
	BitMaps
************/

EXTC GuiBitMap* PROTOFOXLIB LoadBitMap(REGA0 char *fname);
EXTC BitMapInstance* PROTOFOXLIB ShowBitMap(REGA0 GuiBitMap *bm, REGA1 GuiWindow *w, REGD0 unsigned short x, REGD1 unsigned short y, REGD2 short flags);
EXTC BOOL PROTOFOXLIB HideBitMap(REGA0 BitMapInstance *bmi);
EXTC BOOL PROTOFOXLIB FreeGuiBitMap(REGA0 GuiBitMap *bm);
EXTC GuiBitMap* PROTOFOXLIB ScaleBitMap(REGA0 GuiBitMap *source, REGD0 unsigned short destwidth, REGD1 unsigned short destheight);
EXTC BOOL PROTOFOXLIB RedrawBitMap(REGA0 BitMapInstance *bmi);
EXTC BOOL PROTOFOXLIB AttachBitMapToControl(REGA0 GuiBitMap *bm, REGA1 void *control, REGD0 short left, REGD1 short top, REGD2 short width,
		REGD3 short height, REGD4 int flags);
EXTC BOOL PROTOFOXLIB ScreenColoursFromILBM(REGA0 GuiScreen *sc, REGA1 char *fname);


/***************
	List Boxes
***************/

EXTC void PROTOFOXLIB SortListBox(REGA0 ListBox *p, REGD0 int flags, REGD1 int startnum, REGD2 BOOL refresh);
EXTC void PROTOFOXLIB ClearListBoxTabStops(REGA0 ListBox *nlb, REGD0 BOOL refresh);
EXTC BOOL PROTOFOXLIB SetListBoxTabStopsArray(REGA0 ListBox *nlb, REGD0 BOOL refresh, REGD1 short num, REGA1 int *tabs);
EXTC void PROTOFOXLIB SetListBoxTopNum(REGA0 ListBox *lb, REGD0 int num, REGD1 BOOL refresh);
EXTC void PROTOFOXLIB SetListBoxHiNum(REGA0 ListBox *lb, REGD0 int num, REGD1 BOOL refresh);
EXTC void PROTOFOXLIB SetListBoxHiElem(REGA0 ListBox *lb, REGA1 ListBoxItem *item, REGD0 BOOL refresh);
EXTC int PROTOFOXLIB NoTitles(REGA0 ListBox *lb);
EXTC int PROTOFOXLIB NoLines(REGA0 ListBox *lb);
EXTC int PROTOFOXLIB TopNum(REGA0 ListBox *lb);
EXTC int PROTOFOXLIB HiNum(REGA0 ListBox *lb);
EXTC ListBoxItem* PROTOFOXLIB HiElem(REGA0 ListBox *lb);
EXTC char* PROTOFOXLIB HiText(REGA0 ListBox *lb);
EXTC char* PROTOFOXLIB ListColumnText(REGA0 ListBox *lb, REGD0 int col);
EXTC BOOL PROTOFOXLIB AddListBoxTitle(REGA0 ListBox *nlb, REGA1 char *title, REGD0 BOOL refresh);
EXTC ListBoxItem* PROTOFOXLIB AddListBoxItem(REGA0 ListBox *nlb, REGA1 char *item, REGD0 BOOL refresh);
EXTC ListBoxItem* PROTOFOXLIB ReplaceListBoxItem(REGA0 ListBox *nlb, REGA1 char *item, REGA2 ListBoxItem *OldItem, REGD0 BOOL refresh);
EXTC ListBoxItem* PROTOFOXLIB InsertListBoxItem(REGA0 ListBox *nlb, REGA1 char *item, REGA2 ListBoxItem *after, REGD0 BOOL refresh);
EXTC void PROTOFOXLIB ListBoxRefresh(REGA0 ListBox *lb);
EXTC void PROTOFOXLIB ClearListBoxTitles(REGA0 ListBox *lb, REGD0 BOOL refresh);
EXTC void PROTOFOXLIB ClearListBoxItems(REGA0 ListBox *lb, REGD0 BOOL refresh);
EXTC int PROTOFOXLIB FindListText(REGA0 ListBox *lb, REGA1 char *text, REGD0 int reqcolumn);
EXTC ListBox* PROTOFOXLIB MakeListBox(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height, REGD4 int lborder,
		REGD5 int tborder, REGD6 int flags, REGA1 int I_CALLBACK (*Eventfn) (ListBox*, short, int, void**), REGA2 void *extension);
EXTC void PROTOFOXLIB SetListBoxDragPointer(REGA0 ListBox *lb, REGA1 unsigned short *DragPointer, REGD0 int width, REGD1 int height,
		REGD2 int xoffset, REGD3 int yoffset);
EXTC ListBoxItem* PROTOFOXLIB ItemElem(REGA0 ListBox *lb, REGD0 int target);


/******************
	Tree Controls
******************/

EXTC TreeControl* PROTOFOXLIB MakeTreeControl(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGD4 int lborder, REGD5 int tborder, REGD6 int flags,
		REGA1 int I_CALLBACK (*Eventfn) (TreeControl*, short, TreeItem*, void**), REGA2 void *extension);
EXTC void PROTOFOXLIB SetTreeControlDragPointer(REGA0 TreeControl *tc, REGA1 unsigned short *DragPointer, REGD0 int width, REGD1 int height,
		REGD2 int xoffset, REGD3 int yoffset);
EXTC TreeItem* PROTOFOXLIB AddItem(REGA0 TreeControl *tc, REGA1 TreeItem *InsBefore, REGA2 TreeItem *Parent, REGA3 char *text,
		REGD0 BOOL IsOpen, REGD1 GuiBitMap *bm, REGD2 void *ItemData);
EXTC BOOL PROTOFOXLIB ItemIsOpen(REGA0 TreeItem *it);
EXTC void PROTOFOXLIB RemoveItem(REGA0 TreeItem *ti);
EXTC void PROTOFOXLIB OpenItem(REGA0 TreeItem *it);
EXTC void PROTOFOXLIB CloseItem(REGA0 TreeItem *it);
EXTC TreeItem* PROTOFOXLIB TCHiItem(REGA0 TreeControl *tc);
EXTC char* PROTOFOXLIB TCHiText(REGA0 TreeControl *tc);
EXTC void PROTOFOXLIB SetTreeControlHiItem(REGA0 TreeControl *tc, REGA1 TreeItem *HiItem, REGD0 BOOL refresh);
EXTC void* PROTOFOXLIB ItemData(REGA0 TreeItem *ti);
EXTC char* PROTOFOXLIB TCItemText(REGA0 TreeItem *ti);
EXTC void PROTOFOXLIB ClearTreeControl(REGA0 TreeControl *tc);
EXTC TreeItem* PROTOFOXLIB FindTreeItem(REGA0 TreeControl *tc, REGA1 char *text);
EXTC TreeItem* PROTOFOXLIB ReplaceTCItem(REGA0 TreeItem *old, REGA1 char *text, REGA2 GuiBitMap *bm, REGA3 void *ItemData);

/*************************
	Drop Down List Boxes
*************************/

EXTC void PROTOFOXLIB ClearDDListBox(REGA0 DDListBox *l);
EXTC BOOL PROTOFOXLIB RemoveFromDDListBox(REGA0 DDListBox *list, REGA1 char *str);
EXTC BOOL PROTOFOXLIB AddToDDListBox(REGA0 DDListBox *list, REGA1 char *str);
EXTC void PROTOFOXLIB SortDDListBox(REGA0 DDListBox *p, REGD0 int flags);
EXTC BOOL PROTOFOXLIB SetDDListBoxPopup(REGA0 DDListBox *l, REGD0 int x, REGD1 int y, REGD2 int width, REGD3 int height);
EXTC BOOL PROTOFOXLIB AssociateDDListBox(REGA0 DDListBox *l, REGA1 DDListBox *m);
EXTC DDListBox* PROTOFOXLIB MakeSubDDListBox(REGA0 DDListBox *lb, REGA1 char *string, REGD0 int left, REGD1 int top, REGD2 int width,
		REGD3 int height, REGD4 int id, REGA2 BOOL I_CALLBACK (*callfn)(DDListBox*), REGA3 void *extension);
EXTC DDListBox* PROTOFOXLIB MakeDDListBox(REGA0 void *Parent, REGD0 int x, REGD1 int y, REGD2 int len, REGD3 int buflen,
	REGD4 int MaxHeight, REGD5 int id, REGA1 BOOL I_CALLBACK (*callfn) (DDListBox*),
	REGD6 long flags, REGA2 void *extension);       /* Tcol must be between 0 & 7 */
EXTC BOOL PROTOFOXLIB SetDDListBoxText(REGA0 DDListBox *l, REGA1 char *c);
EXTC char* PROTOFOXLIB GetDDListBoxText(REGA0 DDListBox *l);
EXTC int PROTOFOXLIB GetDDListBoxID(REGA0 DDListBox *l);

/***************
	Edit Boxes
***************/

EXTC void PROTOFOXLIB RefreshEditBox(REGA0 EditBox *p);
EXTC BOOL PROTOFOXLIB SetEditBoxFocus(REGA0 EditBox *p);
EXTC BOOL PROTOFOXLIB SetEditBoxCols(REGA0 EditBox *p, REGD0 int BorderCol, REGD1 int Bcol, REGD2 int Tcol);
EXTC char* PROTOFOXLIB GetEditBoxText(REGA0 EditBox *p);
EXTC int PROTOFOXLIB GetEditBoxInt(REGA0 EditBox *p);
EXTC double PROTOFOXLIB GetEditBoxDouble(REGA0 EditBox *p);
EXTC BOOL PROTOFOXLIB SetEditBoxText(REGA0 EditBox *p, REGA1 char *text);
EXTC BOOL PROTOFOXLIB SetEditBoxInt(REGA0 EditBox *p, REGD0 int num);
EXTC BOOL PROTOFOXLIB SetEditBoxDouble(REGA0 EditBox *p, REGD0 double num);
EXTC BOOL PROTOFOXLIB SetEditBoxDP(REGA0 EditBox *p, REGD0 int num);
EXTC EditBox* PROTOFOXLIB MakeEditBox(REGA0 void *Parent, REGD0 int x, REGD1 int y, REGD2 int len, REGD3 int buflen,
		REGD4 int id, REGA1 BOOL I_CALLBACK (*callfn) (EditBox*), REGD5 long flags, REGA2 void *extension);
EXTC int PROTOFOXLIB GetEditBoxID(REGA0 EditBox *p);


/*******************
		Menus
*******************/

EXTC BOOL PROTOFOXLIB DisableWinMenus(REGA0 GuiWindow *win);
EXTC BOOL PROTOFOXLIB EnableWinMenus(REGA0 GuiWindow *win);
EXTC BOOL PROTOFOXLIB DisableMenu(REGA0 GuiWindow *win, REGA1 struct Menu *menu);
EXTC BOOL PROTOFOXLIB EnableMenu(REGA0 GuiWindow *win, REGA1 struct Menu *menu);
EXTC BOOL PROTOFOXLIB DisableMenuItem(REGA0 GuiWindow *win, REGA1 struct MenuItem *item);
EXTC BOOL PROTOFOXLIB EnableMenuItem(REGA0 GuiWindow *win, REGA1 struct MenuItem *item);
EXTC void PROTOFOXLIB SetWinMenuFn(REGA0 GuiWindow *win, REGA1 int I_CALLBACK (*fn) (GuiWindow*, struct MenuItem *));
EXTC void PROTOFOXLIB ClearMenus(REGA0 GuiWindow *win);
EXTC void PROTOFOXLIB ShareMenus(REGA0 GuiWindow *dest, REGA1 GuiWindow *source);
EXTC struct Menu* PROTOFOXLIB AddMenu(REGA0 GuiWindow *win, REGA1 char *name, REGD0 int leftedge, REGD1 int enabled);
EXTC struct MenuItem* PROTOFOXLIB AddMenuItem(REGA0 GuiWindow *win, REGA1 struct Menu *menu, REGA2 char *name, REGA3 char *selname,
		REGD0 unsigned short flags, REGD1 int key, REGD2 int enabled, REGD3 int checkit, REGD4 int checked, REGD5 int menutoggle);
EXTC struct MenuItem* PROTOFOXLIB AddSubMenuItem(REGA0 GuiWindow *win,
		REGA1 struct MenuItem *menuitem, REGA2 char *name, REGA3 char *selname, REGD0 unsigned short flags,
		REGD1 int key, REGD2 int enabled, REGD3 int checkit, REGD4 int checked, REGD5 int menutoggle);
EXTC BOOL PROTOFOXLIB RemoveMenuItem(REGA0 GuiWindow *win, REGA1 struct MenuItem *item);
EXTC BOOL PROTOFOXLIB IsMenuChecked(REGA0 struct MenuItem *mi);
EXTC BOOL PROTOFOXLIB SetMenuChecked(REGA0 GuiWindow *win, REGA1 struct MenuItem *item, REGD0 BOOL checked);

/*******************
		Windows
*******************/

EXTC void PROTOFOXLIB WriteText(REGA0 GuiWindow *gw, REGA1 char *text, REGD0 int x, REGD1 int y);
EXTC BOOL PROTOFOXLIB SleepPointer(REGA0 GuiWindow *win);
EXTC void PROTOFOXLIB WakePointer(REGA0 GuiWindow *win);
EXTC BOOL PROTOFOXLIB SetWindowLimits(REGA0 GuiWindow *gw, REGD0 long minwidth, REGD1 long minheight, REGD2 unsigned long maxwidth,
		REGD3 unsigned long maxheight);
EXTC GuiWindow* PROTOFOXLIB OpenGuiWindow(REGA0 void *Scr, REGD0 int Left, REGD1 int Top, REGD2 int Width, REGD3 int Height,
		REGD4 int Dpen, REGD5 int Bpen, REGA1 char *Title, REGD6 int flags,
		REGA2 int I_CALLBACK (*eventfn)(GuiWindow*, int, int, int, void*), REGA3 void *extension);
EXTC BOOL PROTOFOXLIB ShowFileRequester(REGA0 GuiWindow *Wnd, REGA1 char *path, REGA2 char *fname, REGA3 char *pattern, REGD0 char
	*title, REGD1 BOOL Save, REGD2 int I_CALLBACK (*callfn) (char*, char*));
EXTC void PROTOFOXLIB SetFName(REGA0 char *fname);
EXTC void PROTOFOXLIB SetPath(REGA0 char *path);
EXTC void PROTOFOXLIB UpdateFList(void);
EXTC void PROTOFOXLIB WinPrint(REGA0 GuiWindow *w, REGA1 char *str);
EXTC void PROTOFOXLIB WinTab(REGA0 GuiWindow *w, REGD0 int x, REGD1 int y);
EXTC void PROTOFOXLIB WinPrintTab(REGA0 GuiWindow *w, REGD0 int x, REGD1 int y, REGA1 char *str);
EXTC void PROTOFOXLIB WinPrintCol(REGA0 GuiWindow *w, REGA1 char *str, REGD0 int col);
EXTC void PROTOFOXLIB WinShowCursor(REGA0 GuiWindow *w);
EXTC void PROTOFOXLIB WinHideCursor(REGA0 GuiWindow *w);
EXTC void PROTOFOXLIB WinClear(REGA0 GuiWindow *w);
EXTC void PROTOFOXLIB WinHome(REGA0 GuiWindow *w);
EXTC void PROTOFOXLIB WinBlankToEOL(REGA0 GuiWindow *w);
EXTC void PROTOFOXLIB WinWrapOn(REGA0 GuiWindow *w);
EXTC void PROTOFOXLIB WinWrapOff(REGA0 GuiWindow *w);


/*******************
		Misc.
*******************/

EXTC void PROTOFOXLIB UseSafeMallocs(void);
EXTC void PROTOFOXLIB GuiLoop(void);
EXTC short PROTOFOXLIB LibVersion(void);
EXTC BOOL PROTOFOXLIB SetGuiPensFromPubScreen(REGA0 char *pub_screen_name);
EXTC void PROTOFOXLIB SetGuiPens(REGD0 short hipen, REGD1 short lopen);
EXTC BOOL PROTOFOXLIB ShowMessage(REGA0 GuiScreen *scr, REGA1 char *a, REGA2 char *b, REGA3 char *c, REGD0 int col);
EXTC BOOL PROTOFOXLIB DestroyMessage(void);
EXTC void PROTOFOXLIB SetPeriod(REGD0 int time);
EXTC void PROTOFOXLIB SetDelay(REGD0 int time);
EXTC void* PROTOFOXLIB GuiMalloc(REGD0 unsigned NoOfBytes, REGD1 unsigned long flags);
EXTC BOOL PROTOFOXLIB WasGuiMallocd(REGA0 void *p);
EXTC void PROTOFOXLIB GuiFreeMem(REGA0 void *p, REGD0 int line, REGA1 char *fname);
EXTC void PROTOFOXLIB DrawLines(REGA0 GuiWindow *win, REGA1 short *points, REGD0 int count, REGD1 int col);
EXTC short PROTOFOXLIB GuiMessage(REGA0 void *Scr, REGA1 char *text, REGA2 char *title, REGD0 int detail, REGD1 int block, REGD2 int flags);
EXTC BOOL PROTOFOXLIB Hide(REGA0 void *Control);
EXTC BOOL PROTOFOXLIB Show(REGA0 void *Control);
EXTC void PROTOFOXLIB DisableControl(REGA0 void *Control, REGD0 BOOL refresh);
EXTC void PROTOFOXLIB DisableM(REGD0 int ObjectType, REGA0 void *Parent, REGD1 BOOL refresh);
EXTC void PROTOFOXLIB EnableControl(REGA0 void *Control, REGD0 BOOL refresh);
EXTC void PROTOFOXLIB EnableM(REGD0 int ObjectType, REGA0 void *Parent, REGD1 BOOL refresh);
EXTC BOOL PROTOFOXLIB Destroy(REGA0 void *Control, REGD0 BOOL refresh);
EXTC void PROTOFOXLIB DestroyM(REGD0 int ObjectType, REGA0 void *Parent, REGD1 BOOL refresh);
EXTC GuiWindow* PROTOFOXLIB GetWindow(REGA0 void *Control);
EXTC BOOL PROTOFOXLIB RegisterGadget(REGA0 struct Gadget *gad, REGA1 GuiWindow *gadwin, REGA2 int I_CALLBACK (*gadfn)(struct Gadget*, struct IntuiMessage *));
EXTC BOOL PROTOFOXLIB UnRegisterGadget(REGA0 struct Gadget *gad);
EXTC struct Window* PROTOFOXLIB IntuiWindow(REGA0 GuiWindow *gw);
EXTC void PROTOFOXLIB CheckMessages(void);
EXTC unsigned long PROTOFOXLIB GetNextAvailableDisplayMode(REGD0 unsigned long previous);
EXTC BOOL PROTOFOXLIB ShowDisplayList(REGA0 void *Scr, REGA1 char *title, REGD0 int DPen, REGD1 int BPen,
		REGA2 unsigned long *displayModeID);
EXTC int PROTOFOXLIB GetModeName(REGD0 unsigned long displaymode, REGA0 char *buffer, REGD1 int buflen);
EXTC BOOL PROTOFOXLIB GetModeSize(REGD0 unsigned long displaymode, REGA0 long *width, REGA1 long *height);
EXTC long PROTOFOXLIB GuiTextLength(REGA0 char *text, REGA1 struct TextAttr *font);
EXTC void PROTOFOXLIB GuiGetLastErr(REGA0 char *error, REGA1 char *file, REGA2 int *line);
EXTC void PROTOFOXLIB SetDefaultCols(REGD0 int BorderCol, REGD1 int BackCol, REGD2 int TextCol);
EXTC void PROTOFOXLIB SetDefaultFont(REGA0 char *name, REGD0 int size, REGD1 int style);
EXTC void PROTOFOXLIB GetDefaultFontCopy(REGA0 char *fontname, REGD0 int bufsize, REGA1 int *height, REGA2 int *style);


/*******************
		Screens
*******************/

EXTC GuiScreen* PROTOFOXLIB OpenGuiScreen(REGD0 int Depth, REGD1 int DPen, REGD2 int BPen, REGA0 char *Title,
		REGA1 int I_CALLBACK (*LastWinFn)(GuiScreen *), REGD3 int flags, REGA2 char *PubName, REGD4 unsigned long DisplayID,
		REGD5 int OverscanType, REGD6 UWORD *pens, REGA3 void *extension);
EXTC struct Screen* PROTOFOXLIB GetScreenDetails(REGA0 void *scr, REGA1 unsigned long *mode, REGA2 int *depth, REGA3 char *fontname,
		REGD0 int bufsize, REGD1 int *reqbufsize, REGD2 int *fontheight, REGD3 int *fontstyle, REGD4 UWORD *pens, REGD5 int pensarraysize);
EXTC GuiScreen* PROTOFOXLIB ClonePublicScreen(REGD0 int mindepth, REGA3 UBYTE *pub_screen_name, REGA0 char *sScreenTitle,
		REGA1 int I_CALLBACK (*LastWinFn)(GuiScreen *), REGD1 int flags, REGA2 char *new_pub_name, REGD5 int OverscanType,
		REGD2 void *extension);

/*******************
		Buttons
*******************/

EXTC PushButton* PROTOFOXLIB MakeButton(REGA0 void *Parent, REGA1 char *name, REGD0 int left, REGD1 int top, REGD2 int
   width, REGD3 int height, REGD4 int key, REGA2 struct Border *cb, REGA3 int
   I_CALLBACK (*callfn) (PushButton*), REGD5 short flags, REGD6 void *extension);

/*******************
	Output Boxes
*******************/

EXTC void PROTOFOXLIB SetOutputBoxDP(REGA0 OutputBox *p, REGD0 int dp);
EXTC void PROTOFOXLIB SetOutputBoxInt(REGA0 OutputBox *p, REGD0 int num);
EXTC void PROTOFOXLIB SetOutputBoxDouble(REGA0 OutputBox *p, REGD0 double num);
EXTC void PROTOFOXLIB SetOutputBoxText(REGA0 OutputBox *p, REGA1 char *text);
EXTC void PROTOFOXLIB SetOutputBoxCols(REGA0 OutputBox *ob, REGD0 int Bcol, REGD1 int Tcol, REGD2 BOOL refresh);
EXTC OutputBox* PROTOFOXLIB MakeOutputBox(REGA0 void *Parent, REGD0 int x, REGD1 int y, REGD2 int width, REGD3 int len,
		REGD4 int id, REGA1 char *InitialValue, REGD5 long flags, REGA2 void *extension);
EXTC int PROTOFOXLIB GetOutputBoxID(REGA0 OutputBox *o);
EXTC OutputBox* PROTOFOXLIB SetPreText(REGA0 void *p, REGA1 char *t);
EXTC OutputBox* PROTOFOXLIB SetPostText(REGA0 void *p, REGA1 char *t);

/********************
	Boolean Gadgets
********************/

EXTC RadioButton* PROTOFOXLIB ActiveRadioButton(REGA0 RadioButton *rb);
EXTC RadioButton* PROTOFOXLIB MakeRadioButton(REGA0 void *Parent, REGA1 RadioButton *MutEx, REGD0 int left, REGD1 int top, REGD2 int width,
		REGD3 int height, REGD4 int fillcol, REGA2 int I_CALLBACK (*callfn) (RadioButton*), REGD5 int flags, REGA3 void *extension);
EXTC BOOL PROTOFOXLIB SetTickBoxValue(REGA0 TickBox *tb, REGD0 BOOL value);
EXTC BOOL PROTOFOXLIB TickBoxValue(REGA0 TickBox *tb);
EXTC TickBox* PROTOFOXLIB MakeTickBox(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGA1 int I_CALLBACK (*callfn) (TickBox*), REGD4 int flags, REGA2 void *extension);

/***********
	Timers
***********/

EXTC Timer* PROTOFOXLIB MakeTimer(REGD0 short flags, REGA0 int I_CALLBACK (*CallFn) (Timer *, long), REGA1 void *extension);
EXTC void PROTOFOXLIB StartTimer(REGA0 Timer *t);
EXTC void PROTOFOXLIB StopTimer(REGA0 Timer *t);
EXTC void PROTOFOXLIB PauseTimer(REGA0 Timer *t);
EXTC void PROTOFOXLIB UnpauseTimer(REGA0 Timer *t);
EXTC void PROTOFOXLIB AddTime(REGA0 Timer *t, REGD0 long secs);
EXTC void PROTOFOXLIB SetTime(REGA0 Timer *t, REGD0 long secs);

/*****************
   Tab Controls
*****************/

EXTC TabControl* PROTOFOXLIB MakeTabControlArray(REGA0 void *Parent, REGD0 int left, REGD1 int top, REGD2 int width, REGD3 int height,
		REGD4 int tabheight, REGD5 short flags, REGA1 int *tabwidth, REGA2 char **caption,
		REGA3 TabControlExtension *ext);
EXTC Frame* PROTOFOXLIB TabControlFrame(REGA0 TabControl *tc, REGD0 int frameno);

/************
   Signals
************/

void SetSignals(unsigned long mask, int (*fn)(unsigned long, void*), void *UserData);
void AddSignals(unsigned long mask);
void ClearSignals(unsigned long mask);

#ifdef __STORM__
	EXTC void PROTOFOXLIB SetupSizeOutlineData(REGD0 int x, REGD1 int y, REGD2 int width, REGD3 int height, REGD4 int minwidth,
			REGD5 int minheight);
#endif
