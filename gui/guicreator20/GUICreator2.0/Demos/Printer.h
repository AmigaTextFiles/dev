/* Structures used by GUICreator */

#define ERROR_NO_WINDOW_OPENED      1001L
#define ERROR_NO_PUBSCREEN_LOCKED   1002L
#define ERROR_NO_GADGETS_CREATED    1003L
#define ERROR_NO_VISUALINFO         1004L
#define ERROR_NO_PICTURE_LOADED     1005L
#define ERROR_NO_GADGETLIST_CREATED 1006L
#define ERROR_NO_WINDOW_MENU        1007L
#define ERROR_SCREEN_TOO_SMALL      1008L
#define ERROR_LIST_NOT_INITIALIZED  1009L

struct BevelFrame
	{
	ULONG    bb_LeftEdge;
	ULONG    bb_TopEdge;
	ULONG    bb_Width;
	ULONG    bb_Height;
	char *   bb_Title;
	ULONG    bb_Color;
	};

struct Line
	{
	ULONG    li_LeftEdge;
	ULONG    li_TopEdge;
	ULONG    li_Width;
	ULONG    li_Height;
	ULONG    li_Color;
	};

struct Text
	{
	ULONG    tx_LeftEdge;
	ULONG    tx_TopEdge;
	char *   tx_Text;
	ULONG    tx_Color;
	};

/* Functions created by GUICreator */

void ShowGadget(struct Window *win, struct Gadget *gad, int type);
void SleepWindow(struct Window *win);
void WakenWindow(struct Window *win);
void GUIC_ErrorReport(struct Window *win,ULONG type);
void CreateBevelFrames(struct Window *win,APTR visualinfo,ULONG bevelcount,struct BevelFrame bevels[]);
void CreateLines(struct Window *win,int linecount,struct Line lines[]);
void CreateTexts(struct Window *win,int textcount,struct Text texts[],long double xscale,long double yscale);
void About(struct Window *hostwin,struct Gadget **wingads,APTR userdata);

extern void HandlePrinterPrefsWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata);

/* Defines for PrinterPrefsWindow*/

#define LAID_Gadget1                   0
#define LVID_Gadget2                   1
#define BTID_Gadget3                   2
#define BTID_Gadget5                   3
#define BTID_Gadget4                   4
#define CYID_Gadget6                   5
#define CYID_Gadget7                   6
#define CYID_Gadget8                   7
#define CYID_Gadget9                   8
#define CYID_Gadget10                  9
#define CYID_Gadget11                  10
#define INID_Gadget12                  11
#define INID_Gadget13                  12
#define INID_Gadget14                  13
#define LAID_Gadget15                  14
#define LAID_Gadget16                  15
#define LAID_Gadget18                  16
#define LAID_Gadget19                  17
#define LAID_Gadget20                  18
#define LAID_Gadget21                  19
#define LAID_Gadget22                  20
#define LAID_Gadget23                  21
#define LAID_Gadget24                  22


/* Functions which you must define for PrinterPrefsWindow */
extern void UserSetupPrinterPrefsWindow(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void UserRefreshPrinterPrefsWindow(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void ItemOpenClicked(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void ItemSaveClicked(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void ItemQuitClicked(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void Gadget2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget5Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget4Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget6Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget7Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget8Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget9Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget10Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget11Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget12Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget13Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget14Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);


