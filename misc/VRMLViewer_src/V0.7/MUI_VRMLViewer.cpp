//#include "MUI_CPP.include"

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/muimaster.h>

#include <libraries/gadtools.h>

#include "GLFunctions.h"

#include "MUI_VRMLViewer.h"
#include "MUI_VRMLViewerExtern.h"

struct ObjApp *CreateApp(void)
{
	struct ObjApp *MBObj;

	APTR    MN_Main, MNProject, MNlabel1BarLabel0, MNlabel1BarLabel1, MNMainBarLabel4;
	APTR    MNPrefs, MNMainWindows, GP_RT_Main, GR_grp_17, Space_2, obj_aux0;
	APTR    obj_aux1, obj_aux2, obj_aux3, GP_RT_Prefs, GR_grp_3, GR_PrefsCyberGLEnv;
	APTR    GR_grp_9, GR_grp_10, obj_aux4, obj_aux5, obj_aux6, obj_aux7, obj_aux8;
	APTR    obj_aux9, GR_grp_14, obj_aux10, obj_aux11, GR_grp_7, GR_grp_21, obj_aux12;
	APTR    obj_aux13, obj_aux14, obj_aux15, obj_aux16, obj_aux17, GR_grp_8, LA_label_0;
	APTR    GR_PrefsCyberGL, GR_grp_16, obj_aux18, obj_aux19, GR_PrefsParser;
	APTR    GR_grp_11, GR_grp_18, obj_aux20, obj_aux21, GR_grp_12, obj_aux22;
	APTR    obj_aux23, GR_grp_13, Space_3, obj_aux24, obj_aux25, Space_4, GR_Cmd;
	APTR    GP_RT_Msg, Scale_0, GROUP_ROOT_3, GR_grp_19, obj_aux26, obj_aux27;
	APTR    obj_aux28, obj_aux29, obj_aux30, obj_aux31, GR_grp_20, obj_aux32;
	APTR    obj_aux33, obj_aux34, obj_aux35, obj_aux100;
	static const struct Hook PrefsWindowCmdHook = { {NULL, NULL}, (HOOKFUNC) PrefsWindowCmd, NULL, NULL};
	static const struct Hook StartScreenHook = { {NULL, NULL}, (HOOKFUNC) StartScreen, NULL, NULL};
	static const struct Hook StopScreenHook = { {NULL, NULL}, (HOOKFUNC) StopScreen, NULL, NULL};
	static const struct Hook ChangeCameraHook = { {NULL, NULL}, (HOOKFUNC) ChangeCamera, NULL, NULL};
	static const struct Hook PositionCmdHook = { {NULL, NULL}, (HOOKFUNC) PositionCmd, NULL, NULL};
	static const struct Hook MenuCmdHook = { {NULL, NULL}, (HOOKFUNC) MenuCmd, NULL, NULL};
	static const struct Hook MainWindowCmdHook = { {NULL, NULL}, (HOOKFUNC) MainWindowCmd, NULL, NULL};


	if (!(MBObj = (struct ObjApp *) AllocVec(sizeof(struct ObjApp), MEMF_PUBLIC|MEMF_CLEAR)))
		return(NULL);

	// MBObj->glarea=InitGLAreaCustomClass();

	MBObj->STR_TX_Msg = NULL;

	MBObj->CY_PolygoneContent[0] = "Smooth";
	MBObj->CY_PolygoneContent[1] = "Flat";
	MBObj->CY_PolygoneContent[2] = "Wire";
	MBObj->CY_PolygoneContent[3] = "Points";
	MBObj->CY_PolygoneContent[4] = "Wireframe";
	MBObj->CY_PolygoneContent[5] = "Bounding box";
	MBObj->CY_PolygoneContent[6] = "Transparent";
	MBObj->CY_PolygoneContent[7] = "Textured";
	MBObj->CY_PolygoneContent[8] = NULL;
	MBObj->CY_ModeContent[0] = "Rotate";
	MBObj->CY_ModeContent[1] = "Slide";
	MBObj->CY_ModeContent[2] = "Turn";
	MBObj->CY_ModeContent[3] = "Fly";
	MBObj->CY_ModeContent[4] = NULL;
	MBObj->STR_GR_grp_3[0] = "OpenGL environnement";
	MBObj->STR_GR_grp_3[1] = "OpenGL lightning";
	MBObj->STR_GR_grp_3[2] = "Parser";
	MBObj->STR_GR_grp_3[3] = NULL;
	MBObj->RA_PrefsModeContent[0] = "Only errors";
	MBObj->RA_PrefsModeContent[1] = "All messages";
	MBObj->RA_PrefsModeContent[2] = NULL;

	MBObj->BT_MainReset = TextObject,
		ButtonFrame,
		MUIA_Weight, 20,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Reset",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_MainReset",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	MBObj->BT_MainRefresh = TextObject,
		ButtonFrame,
		MUIA_Weight, 20,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Refresh",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_MainRefresh",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	MBObj->BT_MainBreak = TextObject,
		ButtonFrame,
		MUIA_Weight, 20,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Break",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_MainBreak",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	MBObj->STR_PA_MainFile = String("", 80);

	MBObj->PA_MainFile = PopButton(MUII_PopFile);

	MBObj->PA_MainFile = PopaslObject,
		MUIA_HelpNode, "PA_MainFile",
		MUIA_Popasl_Type, 0,
		MUIA_Popstring_String, MBObj->STR_PA_MainFile,
		MUIA_Popstring_Button, MBObj->PA_MainFile,
	End;

	GR_grp_17 = GroupObject,
		MUIA_HelpNode, "GR_grp_17",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainReset,
		Child, MBObj->BT_MainRefresh,
		Child, MBObj->BT_MainBreak,
		Child, MBObj->PA_MainFile,
	End;

	MBObj->GR_Up = GroupObject,
		MUIA_HelpNode, "GR_Up",
		Child, GR_grp_17,
	End;

	Space_2 = HVSpace;

	MBObj->AR_CyberGLArea = GLAreaObject,
	    MUIA_FillArea, FALSE,
	    // MUIA_GLArea_FullScreen, TRUE,
	    MUIA_GLArea_Threaded, TRUE,
	    MUIA_GLArea_Buffered, TRUE,
	    MUIA_GLArea_MinWidth, 240,
	    MUIA_GLArea_MaxWidth, 1024,
	    MUIA_GLArea_MinHeight, 180,
	    MUIA_GLArea_MaxHeight, 768,
	    MUIA_GLArea_InitFunc, Init,
	    MUIA_GLArea_ResetFunc, Reset,
	    MUIA_GLArea_DrawFunc, DrawScene,
	    MUIA_GLArea_DrawFunc2, DrawBoxScene,
	    MUIA_GLArea_MouseDownFunc, MouseDown,
	    MUIA_GLArea_MouseMoveFunc, MouseMove,
	    MUIA_GLArea_MouseUpFunc, MouseUp,
	End;

	MBObj->GR_CyberGLOutput = GroupObject,
		MUIA_HelpNode, "GR_CyberGLOutput",
		Child, MBObj->AR_CyberGLArea,
	End;

	MBObj->LV_Cameras = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
	End;

	MBObj->LV_Cameras = ListviewObject,
		MUIA_HelpNode, "LV_Cameras",
		MUIA_Listview_List, MBObj->LV_Cameras,
	End;

	// MBObj->STR_PO_Cameras = String("", 80);

	MBObj->TXT_PO_Cameras = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, "       none       ",
	End;

	MBObj->PO_Cameras = PopobjectObject,
		MUIA_HelpNode, "PO_Cameras",
		MUIA_Disabled, TRUE,
		MUIA_Popstring_String, MBObj->TXT_PO_Cameras,
		MUIA_Popstring_Button, PopButton(MUII_PopUp),
		MUIA_Popobject_Object, MBObj->LV_Cameras,
	End;

	MBObj->CY_Polygone = CycleObject,
		MUIA_HelpNode, "CY_Polygone",
		MUIA_Cycle_Entries, MBObj->CY_PolygoneContent,
	End;

	MBObj->CY_Mode = CycleObject,
		MUIA_HelpNode, "CY_Mode",
		MUIA_Cycle_Entries, MBObj->CY_ModeContent,
	End;

	MBObj->CH_Filled = CheckMark(FALSE);

	obj_aux1 = Label2("F");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->CH_Filled,
	End;

	MBObj->CH_Animated = CheckMark(FALSE);

	obj_aux3 = Label2("A");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_Animated,
	End;

	MBObj->GR_Down = GroupObject,
		MUIA_HelpNode, "GR_Down",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->PO_Cameras,
		Child, MBObj->CY_Polygone,
		Child, MBObj->CY_Mode,
		Child, obj_aux0,
		Child, obj_aux2,
	End;

	GP_RT_Main = GroupObject,
		Child, MBObj->GR_Up,
		Child, MBObj->GR_CyberGLOutput,
		Child, MBObj->GR_Down,
	End;

	MBObj->MNProjectOpen = MenuitemObject,
		MUIA_Menuitem_Title, "Open",
	End;

	MNlabel1BarLabel0 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectAbout = MenuitemObject,
		MUIA_Menuitem_Title, "About",
	End;

	MBObj->MNProjectAboutMUI = MenuitemObject,
		MUIA_Menuitem_Title, "About MUI...",
	End;

	MNlabel1BarLabel1 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectWorldinfo = MenuitemObject,
		MUIA_Menuitem_Title, "World info",
	End;

	MNMainBarLabel4 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectQuit = MenuitemObject,
		MUIA_Menuitem_Title, "Quit",
	End;

	MNProject = MenuitemObject,
		MUIA_Menuitem_Title, "Project",
		MUIA_Family_Child, MBObj->MNProjectOpen,
		MUIA_Family_Child, MNlabel1BarLabel0,
		MUIA_Family_Child, MBObj->MNProjectAbout,
		MUIA_Family_Child, MBObj->MNProjectAboutMUI,
		MUIA_Family_Child, MNlabel1BarLabel1,
		MUIA_Family_Child, MBObj->MNProjectWorldinfo,
		MUIA_Family_Child, MNMainBarLabel4,
		MUIA_Family_Child, MBObj->MNProjectQuit,
	End;

	MBObj->MNPrefsFull = MenuitemObject,
		MUIA_Menuitem_Title, "Full screen",
		MUIA_Menuitem_Checkit, TRUE,
		MUIA_Menuitem_Toggle, TRUE,
	End;

	MNPrefs = MenuitemObject,
		MUIA_Menuitem_Title, "Options",
		MUIA_Family_Child, MBObj->MNPrefsFull,
	End;

	MBObj->MNWinGeneralpreferences = MenuitemObject,
		MUIA_Menuitem_Title, "General preferences",
	End;

	MBObj->MNWinPosition = MenuitemObject,
		MUIA_Menuitem_Title, "Position",
	End;

	MBObj->MNWinParseroutput = MenuitemObject,
		MUIA_Menuitem_Title, "Parser output",
		MUIA_Menuitem_Checkit, TRUE,
		MUIA_Menuitem_Toggle, TRUE,
	End;

	MNMainWindows = MenuitemObject,
		MUIA_Menuitem_Title, "Windows",
		MUIA_Family_Child, MBObj->MNWinGeneralpreferences,
		MUIA_Family_Child, MBObj->MNWinPosition,
		MUIA_Family_Child, MBObj->MNWinParseroutput,
	End;

	MN_Main = MenustripObject,
		MUIA_Family_Child, MNProject,
		MUIA_Family_Child, MNPrefs,
		MUIA_Family_Child, MNMainWindows,
	End;

	MBObj->WI_Main = WindowObject,
		MUIA_Window_Title, "VRMLViewer V 0.7 Beta",
		MUIA_Window_Menustrip, MN_Main,
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GP_RT_Main,
	End;

	MBObj->STR_PrefsCone = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsCone",
		MUIA_String_Contents, "8",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux5 = Label2("Cone resolution");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_PrefsCone,
	End;

	MBObj->STR_PrefsCylinder = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsCylinder",
		MUIA_String_Contents, "8",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux7 = Label2("Cylinder resolution");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_PrefsCylinder,
	End;

	MBObj->STR_PrefsSphere = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsSphere",
		MUIA_String_Contents, "8",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux9 = Label2("Sphere");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_PrefsSphere,
	End;

	GR_grp_10 = GroupObject,
		MUIA_HelpNode, "GR_grp_10",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Primitive resolution",
		Child, obj_aux4,
		Child, obj_aux6,
		Child, obj_aux8,
	End;

	MBObj->CH_PrefsBuffered = CheckMark(TRUE);

	MBObj->CH_PrefsThreaded = CheckMark(TRUE);

	obj_aux11 = Label2("OpenGL buffered");

	// obj_aux100 = Label2("Threaded rendering");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->CH_PrefsBuffered,
		// Child, obj_aux100,
		// Child, MBObj->CH_PrefsThreaded,
	End;

	GR_grp_14 = GroupObject,
		MUIA_HelpNode, "GR_grp_14",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "OpenGL rendering options",
		Child, obj_aux10,
	End;

	GR_grp_9 = GroupObject,
		MUIA_HelpNode, "GR_grp_9",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_10,
		Child, GR_grp_14,
	End;

	MBObj->SL_R = SliderObject,
		MUIA_HelpNode, "SL_R",
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 255,
		MUIA_Slider_Level, 0,
	End;

	obj_aux13 = Label2("R");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->SL_R,
	End;

	MBObj->SL_G = SliderObject,
		MUIA_HelpNode, "SL_G",
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 255,
		MUIA_Slider_Level, 0,
	End;

	obj_aux15 = Label2("G");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->SL_G,
	End;

	MBObj->SL_B = SliderObject,
		MUIA_HelpNode, "SL_B",
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 255,
		MUIA_Slider_Level, 0,
	End;

	obj_aux17 = Label2("B");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->SL_B,
	End;

	GR_grp_21 = GroupObject,
		MUIA_HelpNode, "GR_grp_21",
		Child, obj_aux12,
		Child, obj_aux14,
		Child, obj_aux16,
	End;

	MBObj->CF_Background = ColorfieldObject,
		MUIA_HelpNode, "CF_Background",
		MUIA_FixHeight, 50,
		MUIA_FixWidth, 50,
		MUIA_Colorfield_Red, 0,
		MUIA_Colorfield_Green, 0,
		MUIA_Colorfield_Blue, 0,
	End;

	GR_grp_7 = GroupObject,
		MUIA_HelpNode, "GR_grp_7",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Background color",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_21,
		Child, MBObj->CF_Background,
	End;

	LA_label_0 = Label("OpenGL full screen rendering");

	// MBObj->STR_PA_PrefsSMR = String("", 80);

	MBObj->TXT_PA_PrefsSMR = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, "",
	End;

	MBObj->PA_PrefsSMR = PopButton(MUII_PopUp);

	MBObj->PA_PrefsSMR = PopaslObject,
		MUIA_HelpNode, "PA_PrefsSMR",
		MUIA_Popasl_Type, 2,
		MUIA_Popstring_String, MBObj->TXT_PA_PrefsSMR,
		MUIA_Popstring_Button, MBObj->PA_PrefsSMR,
		MUIA_Popasl_StartHook, &StartScreenHook,
		MUIA_Popasl_StopHook, &StopScreenHook,
	End;

	GR_grp_8 = GroupObject,
		MUIA_HelpNode, "GR_grp_8",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Full screen mode",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_0,
		Child, MBObj->PA_PrefsSMR,
	End;

	GR_PrefsCyberGLEnv = GroupObject,
		MUIA_HelpNode, "GR_PrefsCyberGLEnv",
		Child, GR_grp_9,
		Child, GR_grp_7,
		Child, GR_grp_8,
	End;

	MBObj->STR_PrefsAngle = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsAngle",
		MUIA_String_Contents, "45",
		MUIA_String_Accept, "0123456789-.",
	End;

	obj_aux19 = Label2("Maximun normal smoothing angle (DEG)");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->STR_PrefsAngle,
	End;

	GR_grp_16 = GroupObject,
		MUIA_HelpNode, "GR_grp_16",
		Child, obj_aux18,
	End;

	GR_PrefsCyberGL = GroupObject,
		MUIA_HelpNode, "GR_PrefsCyberGL",
		Child, GR_grp_16,
	End;

	MBObj->STR_PrefsGZip = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsGZip",
		MUIA_String_Contents, "C:GZip",
	End;

	obj_aux21 = Label2("GZip cmd:");

	obj_aux20 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux21,
		Child, MBObj->STR_PrefsGZip,
	End;

	GR_grp_18 = GroupObject,
		MUIA_HelpNode, "GR_grp_18",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "GZip",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux20,
	End;

	MBObj->STR_PrefsCon = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PrefsCon",
		MUIA_String_Contents, "CON://320/240/VRML parser output",
	End;

	obj_aux23 = Label2("Parser console");

	obj_aux22 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux23,
		Child, MBObj->STR_PrefsCon,
	End;

	GR_grp_12 = GroupObject,
		MUIA_HelpNode, "GR_grp_12",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Parser output console or file",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux22,
	End;

	Space_3 = HVSpace;

	MBObj->RA_PrefsMode = RadioObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Message mode",
		MUIA_HelpNode, "RA_PrefsMode",
		MUIA_Radio_Entries, MBObj->RA_PrefsModeContent,
	End;

	MBObj->CH_PrefsInline = CheckMark(FALSE);

	obj_aux25 = Label2("Try to resolve WWWInline nodes");

	obj_aux24 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux25,
		Child, MBObj->CH_PrefsInline,
	End;

	Space_4 = HVSpace;

	GR_grp_13 = GroupObject,
		MUIA_HelpNode, "GR_grp_13",
		MUIA_Group_Horiz, TRUE,
		Child, Space_3,
		Child, MBObj->RA_PrefsMode,
		Child, obj_aux24,
		Child, Space_4,
	End;

	GR_grp_11 = GroupObject,
		MUIA_HelpNode, "GR_grp_11",
		Child, GR_grp_18,
		Child, GR_grp_12,
		Child, GR_grp_13,
	End;

	GR_PrefsParser = GroupObject,
		MUIA_HelpNode, "GR_PrefsParser",
		Child, GR_grp_11,
	End;

	GR_grp_3 = RegisterObject,
		MUIA_Register_Titles, MBObj->STR_GR_grp_3,
		MUIA_HelpNode, "GR_grp_3",
		Child, GR_PrefsCyberGLEnv,
		Child, GR_PrefsCyberGL,
		Child, GR_PrefsParser,
	End;

	MBObj->BT_PrefsUse = SimpleButton("Use");

	MBObj->BT_PrefsSave = SimpleButton("Save");

	GR_Cmd = GroupObject,
		MUIA_HelpNode, "GR_Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_PrefsUse,
		Child, MBObj->BT_PrefsSave,
	End;

	GP_RT_Prefs = GroupObject,
		Child, GR_grp_3,
		Child, GR_Cmd,
	End;

	MBObj->WI_Prefs = WindowObject,
		MUIA_Window_Title, "Prefs",
		// MUIA_Window_ID, MAKE_ID('1', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Prefs,
	End;

	MBObj->GA_Msg = GaugeObject,
		GaugeFrame,
		MUIA_HelpNode, "GA_Msg",
		MUIA_FixHeight, 10,
		MUIA_Gauge_Horiz, TRUE,
		MUIA_Gauge_Max, 100,
	End;

	Scale_0 = ScaleObject,
		MUIA_Scale_Horiz, TRUE,
	End;

	MBObj->TX_Msg = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Msg,
		MUIA_Text_SetMin, TRUE,
	End;

	GP_RT_Msg = GroupObject,
		Child, MBObj->GA_Msg,
		Child, Scale_0,
		Child, MBObj->TX_Msg,
	End;

	MBObj->WI_Msg = WindowObject,
		MUIA_Window_Title, "Messages",
		MUIA_Window_ID, MAKE_ID('2', 'W', 'I', 'N'),
		MUIA_Window_CloseGadget, FALSE,
		MUIA_Window_SizeGadget, FALSE,
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Msg,
	End;

	MBObj->STR_X = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_X",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	obj_aux27 = Label2("X");

	obj_aux26 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux27,
		Child, MBObj->STR_X,
	End;

	MBObj->STR_Y = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Y",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	obj_aux29 = Label2("Y");

	obj_aux28 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux29,
		Child, MBObj->STR_Y,
	End;

	MBObj->STR_Z = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Z",
		MUIA_String_Contents, "40",
		MUIA_String_Accept, "01234567890.-e",
	End;

	obj_aux31 = Label2("Z");

	obj_aux30 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux31,
		Child, MBObj->STR_Z,
	End;

	GR_grp_19 = GroupObject,
		MUIA_HelpNode, "GR_grp_19",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Position",
		Child, obj_aux26,
		Child, obj_aux28,
		Child, obj_aux30,
	End;

	MBObj->STR_Heading = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Heading",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	obj_aux33 = Label2("Heading");

	obj_aux32 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux33,
		Child, MBObj->STR_Heading,
	End;

	MBObj->STR_Pitch = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Pitch",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	obj_aux35 = Label2("Pitch");

	obj_aux34 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux35,
		Child, MBObj->STR_Pitch,
	End;

	GR_grp_20 = GroupObject,
		MUIA_HelpNode, "GR_grp_20",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Orientation",
		Child, obj_aux32,
		Child, obj_aux34,
	End;

	GROUP_ROOT_3 = GroupObject,
		Child, GR_grp_19,
		Child, GR_grp_20,
	End;

	MBObj->WI_Position = WindowObject,
		MUIA_Window_Title, "Position",
		// MUIA_Window_ID, MAKE_ID('3', 'W', 'I', 'N'),
		WindowContents, GROUP_ROOT_3,
	End;

	MBObj->App = ApplicationObject,
		MUIA_Application_Author, "Bodmer Stephan [sbdmer@lsi-media.ch]",
		MUIA_Application_Base, "VRMLViewer",
		MUIA_Application_Title, "VRMLViewer",
		MUIA_Application_Version, "$VER:  0.7 ("__DATE__")",
		MUIA_Application_Copyright, "LSI Media SàRL [http://www.lsi-media.ch]",
		MUIA_Application_Description, "A VRML V1.0 ascii viewer",
		SubWindow, MBObj->WI_Main,
		SubWindow, MBObj->WI_Prefs,
		SubWindow, MBObj->WI_Msg,
		SubWindow, MBObj->WI_Position,
	End;


	if (!MBObj->App)
	{
		FreeVec(MBObj);
		return(NULL);
	}

	DoMethod((Object *) MBObj->MNProjectOpen,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->PA_MainFile,
		1,
		MUIM_Popstring_Open
		);

	DoMethod((Object *) MBObj->MNProjectAbout,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectAbout,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectAboutMUI,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectAboutMUI,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectWorldinfo,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectWorldinfo,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectQuit,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod((Object *) MBObj->MNPrefsFull,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNPrefsFull,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNWinGeneralpreferences,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->MNWinPosition,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->WI_Position,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->MNWinParseroutput,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNWinParseroutput,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Main,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod((Object *) MBObj->BT_MainReset,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainReset,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainRefresh,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainRefresh,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainBreak,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainBreak,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	//---------------- File name String update -----------
	DoMethod((Object *) MBObj->STR_PA_MainFile,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PA_MainFile,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->LV_Cameras,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_Cameras,
		2,
		MUIM_CallHook, &ChangeCameraHook
		);

	DoMethod((Object *) MBObj->LV_Cameras,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->PO_Cameras,
		2,
		MUIM_Popstring_Close, TRUE
		);

	DoMethod((Object *) MBObj->CY_Polygone,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_Polygone,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->CY_Mode,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_Mode,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->CH_Filled,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_Filled,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->CH_Animated,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_Animated,
		2,
		MUIM_CallHook, &MainWindowCmdHook
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Window_SetCycleChain, MBObj->GR_Up,
		MBObj->BT_MainReset,
		MBObj->BT_MainRefresh,
		MBObj->PA_MainFile,
		MBObj->GR_CyberGLOutput,
		MBObj->GR_Down,
		MBObj->PO_Cameras,
		MBObj->CY_Polygone,
		MBObj->CY_Mode,
		MBObj->CH_Filled,
		MBObj->CH_Animated,
		0
		);

	DoMethod((Object *) MBObj->WI_Prefs,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PrefsUse,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->WI_Prefs,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_PrefsCone,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsCone,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsCylinder,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsCylinder,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsSphere,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsSphere,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->CH_PrefsBuffered,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_PrefsBuffered,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);
	/*
	DoMethod((Object *) MBObj->CH_PrefsThreaded,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_PrefsThreaded,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);
	*/

	DoMethod((Object *) MBObj->SL_R,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_R,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->SL_G,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_G,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->SL_B,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_B,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsAngle,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsAngle,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsGZip,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsGZip,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsCon,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsCon,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->RA_PrefsMode,
		MUIM_Notify, MUIA_Radio_Active, MUIV_EveryTime,
		MBObj->RA_PrefsMode,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->CH_PrefsInline,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_PrefsInline,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->BT_PrefsUse,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PrefsUse,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PrefsUse,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->BT_PrefsSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PrefsSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PrefsSave,
		2,
		MUIM_CallHook, &PrefsWindowCmdHook
		);

	DoMethod((Object *) MBObj->WI_Prefs,
		MUIM_Window_SetCycleChain, MBObj->STR_PrefsCone,
		MBObj->STR_PrefsCylinder,
		MBObj->STR_PrefsSphere,
		MBObj->CH_PrefsBuffered,
		MBObj->SL_R,
		MBObj->SL_G,
		MBObj->SL_B,
		MBObj->CF_Background,
		MBObj->PA_PrefsSMR,
		MBObj->STR_PrefsAngle,
		MBObj->STR_PrefsGZip,
		MBObj->STR_PrefsCon,
		MBObj->RA_PrefsMode,
		MBObj->CH_PrefsInline,
		MBObj->BT_PrefsUse,
		MBObj->BT_PrefsSave,
		0
		);

	DoMethod((Object *) MBObj->WI_Msg,
		MUIM_Window_SetCycleChain, 0
		);

	DoMethod((Object *) MBObj->WI_Position,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Position,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_X,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_X,
		2,
		MUIM_CallHook, &PositionCmdHook
		);

	DoMethod((Object *) MBObj->STR_Y,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Y,
		2,
		MUIM_CallHook, &PositionCmdHook
		);

	DoMethod((Object *) MBObj->STR_Z,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Z,
		2,
		MUIM_CallHook, &PositionCmdHook
		);

	DoMethod((Object *) MBObj->STR_Heading,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Heading,
		2,
		MUIM_CallHook, &PositionCmdHook
		);

	DoMethod((Object *) MBObj->STR_Pitch,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Pitch,
		2,
		MUIM_CallHook, &PositionCmdHook
		);

	DoMethod((Object *) MBObj->WI_Position,
		MUIM_Window_SetCycleChain, MBObj->STR_X,
		MBObj->STR_Y,
		MBObj->STR_Z,
		MBObj->STR_Heading,
		MBObj->STR_Pitch,
		0
		);

	/*
	set(MBObj->WI_Main,
		MUIA_Window_Open, TRUE
		);
	*/

	return(MBObj);
}

void DisposeApp(struct ObjApp * MBObj)
{
	MUI_DisposeObject( (Object *) MBObj->App);
	// DeleteGLAreaCustomClass(MBObj->glarea);
	FreeVec(MBObj);
}
