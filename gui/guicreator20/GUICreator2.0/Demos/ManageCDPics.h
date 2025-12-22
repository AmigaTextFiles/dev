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

extern void HandleManageCDPicsWindow(struct Screen *customscreen,LONG left,LONG top,APTR userdata);

/* Defines for ManageCDPicsWindow*/

#define LVID_CD                        0
#define LVID_Category                  1
#define LVID_Picture                   2
#define LAID_Gadget5                   3
#define LAID_Gadget6                   4
#define LAID_Gadget7                   5
#define TXID_Text                      6
#define LAID_Gadget9                   7
#define STID_String                    8
#define LAID_Gadget12                  9
#define CYID_ToShow                    10
#define BTID_SavePrefs                 11
#define BTID_Show                      12


/* Functions which you must define for ManageCDPicsWindow */
extern void UserSetupManageCDPicsWindow(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void ItemQuitClicked(struct Window *win,struct Gadget *wingads[],APTR userdata);
extern void CDClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void CategoryClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void PictureClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void StringClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void ToShowClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void SavePrefsClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);
extern void ShowClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata);


