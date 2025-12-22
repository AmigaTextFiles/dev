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

extern void HandleWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata);

/* Defines for Window*/

#define LAID_Gadget1                   0
#define LAID_Gadget2                   1
#define LAID_Gadget3                   2
#define SLID_Slider1                   3
#define SLID_Slider2                   4
#define SLID_Slider3                   5


/* Functions which you must define for Window */
extern void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void SLSlider1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void SLSlider2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void SLSlider3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);


