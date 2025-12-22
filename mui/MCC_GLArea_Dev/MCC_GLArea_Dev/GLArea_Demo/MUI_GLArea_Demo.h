
#include <libraries/mui.h>
#include <exec/memory.h>
#include <clib/muimaster_protos.h>

struct ObjApp
{
	APTR    App;
	APTR    IMDB_ImageDataBase;
	APTR    WI_Main;
	APTR    MNOpen;
	APTR    MNAbout;
	APTR    MNAboutMUI;
	APTR    MNQuit;
	APTR    GLAR_SimpleAnimation;
	APTR    CY_SAObject;
	APTR    CY_SARendering;
	APTR    GLAR_Background;
	APTR    PO_Background;
	APTR    STR_PO_Background;
	APTR    LV_Background;
	APTR    GLAR_Ground;
	APTR    PO_Ground;
	APTR    STR_PO_Ground;
	APTR    LV_Ground;
	APTR    GLAR_Texture;
	APTR    PO_Texture;
	APTR    STR_PO_Texture;
	APTR    LV_Texture;
	APTR    GLAR_MouseMove;
	APTR    GLAR_LongRendering;
	APTR    BT_LRStart;
	APTR    BT_LRBreak;
	APTR    CH_LRThreaded;
	APTR    CH_LRBuffered;
	APTR    BT_SingleTask;
	APTR    BT_FullScreen;
	APTR    PA_ScreenMode;
	APTR    STR_PA_ScreenMode;
	APTR    WI_SingleTask;
	APTR    GR_SingleTask;
	APTR    GLAR_SingleTask1;
	APTR    GLAR_SingleTask2;
	APTR    GLAR_SingleTask3;
	APTR    GLAR_SingleTask4;
	APTR    WI_FullScreen;
	APTR    GLAR_FullScreen;
	char *  STR_TX_label_0;
	char *  CY_SAObjectContent[13];
	char *  CY_SARenderingContent[4];
};


extern struct ObjApp * CreateApp(void);
extern void DisposeApp(struct ObjApp *);
