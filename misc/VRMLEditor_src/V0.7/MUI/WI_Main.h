
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Main
{
	APTR	WI_Main;
	APTR	MN_MenuBar;
	APTR	MNProjectNewAll;
	APTR	MNProjectNewOnlyMain;
	APTR	MNProjectNewOnlyClip;
	APTR	MNProjectOpen;
	APTR	MNProjectSaveasVRML;
	APTR	MNProjectSaveasOpenGL;
	APTR	MNProjectSaveasGEO;
	APTR	MNProjectAbout;
	APTR	MNProjectAboutMUI;
	APTR	MNProjectQuit;
	APTR	MNOptionParseroutput;
	APTR	MNOptionPrefs;
	APTR	IM_MainMoveLeft;
	APTR	IM_MainMoveRight;
	APTR	IM_MainMoveUp;
	APTR	IM_MainMoveDown;
	APTR	BT_MainCmdPreview;
	APTR	IM_MainCopyLeft;
	APTR	IM_MainCopyRight;
	APTR	CF_MainWorld;
	APTR	LV_MainNodes;
	APTR	CF_MainClip;
	APTR	LV_MainClipboard;
	APTR	BT_MainAdd;
	APTR	BT_MainDelete;
	APTR	BT_MainCopy;
	APTR	BT_MainClear;
	APTR	BT_MainExchange;
	APTR	BT_MainSave;
	APTR	BT_MainInsert;
};

extern struct ObjWI_Main * CreateWI_Main(void);
extern void DisposeWI_Main(struct ObjWI_Main *);
