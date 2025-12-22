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

extern void HandleSoundPrefsWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata);

/* Defines for SoundPrefsWindow*/

#define LAID_Gadget1                   0
#define LAID_Gadget2                   1
#define LAID_Gadget3                   2
#define LAID_Gadget4                   3
#define LAID_Gadget6                   4
#define LAID_Gadget8                   5
#define LAID_Gadget9                   6
#define CBID_Gadget10                  7
#define CBID_Gadget11                  8
#define CYID_Gadget12                  9
#define SLID_Gadget14                  10
#define SLID_Gadget15                  11
#define SLID_Gadget1                   12
#define STID_Gadget4                   13
#define BTID_Gadget3                   14
#define BTID_Gadget5                   15
#define BTID_Gadget6                   16
#define BTID_Gadget8                   17
#define BTID_Gadget9                   18


/* Functions which you must define for SoundPrefsWindow */
extern void Gadget10Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget11Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget12Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget14Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget15Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget4Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget5Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget6Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget8Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void Gadget9Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);


