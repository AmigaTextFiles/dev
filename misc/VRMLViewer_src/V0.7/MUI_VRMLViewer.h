#ifndef MUI_VRMLVIEWER_H
#define MUI_VRMLVIEWER_H

// #include "MUI_H.include"
#include <libraries/mui.h>
#include <exec/memory.h>
#include <clib/muimaster_protos.h>

struct ObjApp
{
	// struct MUI_CustomClass *glarea;

	APTR    App;
	APTR    WI_Main;
	APTR    MNProjectOpen;
	APTR    MNProjectAbout;
	APTR    MNProjectAboutMUI;
	APTR    MNProjectWorldinfo;
	APTR    MNProjectQuit;
	APTR    MNPrefsFull;
	APTR    MNWinGeneralpreferences;
	APTR    MNWinPosition;
	APTR    MNWinParseroutput;
	APTR    GR_Up;
	APTR    BT_MainReset;
	APTR    BT_MainRefresh;
	APTR    BT_MainBreak;
	APTR    PA_MainFile;
	APTR    STR_PA_MainFile;
	APTR    GR_CyberGLOutput;
	APTR    AR_CyberGLArea;
	APTR    GR_Down;
	APTR    PO_Cameras;
	APTR    TXT_PO_Cameras;
	APTR    LV_Cameras;
	APTR    CY_Polygone;
	APTR    CY_Mode;
	APTR    CH_Filled;
	APTR    CH_Animated;
	APTR    WI_Prefs;
	APTR    STR_PrefsCone;
	APTR    STR_PrefsCylinder;
	APTR    STR_PrefsSphere;
	APTR    CH_PrefsBuffered;
	APTR    CH_PrefsThreaded;
	APTR    SL_R;
	APTR    SL_G;
	APTR    SL_B;
	APTR    CF_Background;
	APTR    PA_PrefsSMR;
	APTR    TXT_PA_PrefsSMR;
	APTR    STR_PrefsAngle;
	APTR    STR_PrefsGZip;
	APTR    STR_PrefsCon;
	APTR    RA_PrefsMode;
	APTR    CH_PrefsInline;
	APTR    BT_PrefsUse;
	APTR    BT_PrefsSave;
	APTR    WI_Msg;
	APTR    GA_Msg;
	APTR    TX_Msg;
	APTR    WI_Position;
	APTR    STR_X;
	APTR    STR_Y;
	APTR    STR_Z;
	APTR    STR_Heading;
	APTR    STR_Pitch;
	char *  STR_TX_Msg;
	char *  CY_PolygoneContent[9];
	char *  CY_ModeContent[5];
	char *  STR_GR_grp_3[4];
	char *  RA_PrefsModeContent[3];
};

extern struct ObjApp * CreateApp(void);
extern void DisposeApp(struct ObjApp *);
#endif
