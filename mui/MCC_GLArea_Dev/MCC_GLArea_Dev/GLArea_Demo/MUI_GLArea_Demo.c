#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#include <libraries/asl.h>
#include <intuition/intuition.h>
#include <utility/tagitem.h>
#include <libraries/gadtools.h>

#include <proto/alib.h>
#include <proto/exec.h>

#include "GLFunctions.h"

#include "MUI_GLArea_Demo.h"
#include "MUI_GLArea_DemoExtern.h"


struct ObjApp *CreateApp(void)
{
	struct ObjApp *MBObj;

	APTR    MN_Project, MNlabel1About, MNProjectBarLabel1, MNlabel1BarLabel0;
	APTR    GP_RT_Main, GR_SA, GR_grp_10, GR_grp_12, LA_label_0, GR_grp_13, LA_label_1;
	APTR    GR_grp_15, LA_label_2, GR_grp_8, Space_2, GR_MM, GR_LR, GR_grp_6;
	APTR    GR_grp_7, obj_aux0, obj_aux1, obj_aux2, obj_aux3, Space_0, GROUP_ROOT_1;
	APTR    TX_label_0, GROUP_ROOT_2;
	static const struct Hook SACmdHook = { {NULL, NULL}, (HOOKFUNC) SACmd, NULL, NULL};
	static const struct Hook LRCmdHook = { {NULL, NULL}, (HOOKFUNC) LRCmd, NULL, NULL};
	// static const struct Hook FSCmdHook = { {NULL, NULL}, (HOOKFUNC) FSCmd, NULL, NULL};
	// static const struct Hook StartScreenHook = { {NULL, NULL}, (HOOKFUNC) StartScreen, NULL, NULL};
	// static const struct Hook StopScreenHook = { {NULL, NULL}, (HOOKFUNC) StopScreen, NULL, NULL};
	static const struct Hook MenuCmdHook = { {NULL, NULL}, (HOOKFUNC) MenuCmd, NULL, NULL};


	if (!(MBObj = (struct ObjApp *) AllocVec(sizeof(struct ObjApp), MEMF_PUBLIC|MEMF_CLEAR)))
		return(NULL);

	MBObj->STR_TX_label_0 = "Resize window to redraw the scene";

	MBObj->CY_SAObjectContent[0] = "Cube";
	MBObj->CY_SAObjectContent[1] = "glutCube";
	MBObj->CY_SAObjectContent[2] = "glutSphere";
	MBObj->CY_SAObjectContent[3] = "gluCylinder";
	MBObj->CY_SAObjectContent[4] = "glutCone";
	MBObj->CY_SAObjectContent[5] = "glutTorus";
	MBObj->CY_SAObjectContent[6] = "glutDodecahedron";
	MBObj->CY_SAObjectContent[7] = "glutOctahedron";
	MBObj->CY_SAObjectContent[8] = "glutTetrahedron";
	MBObj->CY_SAObjectContent[9] = "glutIcosahedron";
	MBObj->CY_SAObjectContent[10] = "glutTeapot";
	MBObj->CY_SAObjectContent[11] = "Pawn";
	MBObj->CY_SAObjectContent[12] = NULL;
	MBObj->CY_SARenderingContent[0] = "Solid";
	MBObj->CY_SARenderingContent[1] = "Wire";
	MBObj->CY_SARenderingContent[2] = "Textured";
	MBObj->CY_SARenderingContent[3] = NULL;

	MBObj->GLAR_SimpleAnimation = GLAreaObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Simple animation",
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_MinWidth, 16,
		MUIA_GLArea_MaxWidth, 320,
		MUIA_GLArea_MinHeight, 16,
		MUIA_GLArea_MaxHeight, 240,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 80,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawSimpleAnimation,
	End;

	MBObj->CY_SAObject = CycleObject,
		MUIA_HelpNode, "CY_SAObject",
		MUIA_Cycle_Entries, MBObj->CY_SAObjectContent,
	End;

	MBObj->CY_SARendering = CycleObject,
		MUIA_HelpNode, "CY_SARendering",
		MUIA_Cycle_Entries, MBObj->CY_SARenderingContent,
	End;

	MBObj->GLAR_Background = GLAreaObject,
		MUIA_FillArea, FALSE,
		MUIA_GLArea_SingleTask, TRUE,
		// MUIA_GLArea_Buffered, FALSE,
		MUIA_GLArea_MinWidth, 60,
		MUIA_GLArea_MaxWidth, 60,
		MUIA_GLArea_MinHeight, 40,
		MUIA_GLArea_MaxHeight, 40,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawBackgroundStamp,
	End;

	LA_label_0 = Label("Background");

	MBObj->LV_Background = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
	End;

	MBObj->LV_Background = ListviewObject,
		MUIA_HelpNode, "LV_Background",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_Background,
	End;

	MBObj->STR_PO_Background = String("", 80);

	MBObj->PO_Background = PopobjectObject,
		MUIA_HelpNode, "PO_Background",
		MUIA_Popstring_String, MBObj->STR_PO_Background,
		MUIA_Popstring_Button, PopButton(MUII_PopUp),
		MUIA_Popobject_Object, MBObj->LV_Background,
	End;

	GR_grp_12 = GroupObject,
		MUIA_HelpNode, "GR_grp_12",
		Child, LA_label_0,
		Child, MBObj->PO_Background,
	End;

	MBObj->GLAR_Ground = GLAreaObject,
		// MUIA_Frame, MUIV_Frame_Group,
		// MUIA_FrameTitle, "Simple animation",
		MUIA_FillArea, FALSE,
		// MUIA_GLArea_Buffered, TRUE,
		// MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_MinWidth, 60,
		MUIA_GLArea_MaxWidth, 60,
		MUIA_GLArea_MinHeight, 40,
		MUIA_GLArea_MaxHeight, 40,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawGroundStamp,
		// MUIA_GLArea_DrawFunc, DrawSimpleAnimation,
	End;

	LA_label_1 = Label("Ground");

	MBObj->LV_Ground = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
	End;

	MBObj->LV_Ground = ListviewObject,
		MUIA_HelpNode, "LV_Ground",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_Ground,
	End;

	MBObj->STR_PO_Ground = String("", 80);

	MBObj->PO_Ground = PopobjectObject,
		MUIA_HelpNode, "PO_Ground",
		MUIA_Popstring_String, MBObj->STR_PO_Ground,
		MUIA_Popstring_Button, PopButton(MUII_PopUp),
		MUIA_Popobject_Object, MBObj->LV_Ground,
	End;

	GR_grp_13 = GroupObject,
		MUIA_HelpNode, "GR_grp_13",
		Child, LA_label_1,
		Child, MBObj->PO_Ground,
	End;

	MBObj->GLAR_Texture = GLAreaObject,
		// MUIA_Frame, MUIV_Frame_Group,
		// MUIA_FrameTitle, "Simple animation",
		MUIA_FillArea, FALSE,
		// MUIA_GLArea_Buffered, TRUE,
		// MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_MinWidth, 60,
		MUIA_GLArea_MaxWidth, 60,
		MUIA_GLArea_MinHeight, 40,
		MUIA_GLArea_MaxHeight, 40,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawObjectStamp,
	End;

	LA_label_2 = Label("Texture");

	MBObj->LV_Texture = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
	End;

	MBObj->LV_Texture = ListviewObject,
		MUIA_HelpNode, "LV_Texture",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_Texture,
	End;

	MBObj->STR_PO_Texture = String("", 80);

	MBObj->PO_Texture = PopobjectObject,
		MUIA_HelpNode, "PO_Texture",
		MUIA_Popstring_String, MBObj->STR_PO_Texture,
		MUIA_Popstring_Button, PopButton(MUII_PopUp),
		MUIA_Popobject_Object, MBObj->LV_Texture,
	End;

	GR_grp_15 = GroupObject,
		MUIA_HelpNode, "GR_grp_15",
		Child, LA_label_2,
		Child, MBObj->PO_Texture,
	End;

	GR_grp_10 = GroupObject,
		MUIA_HelpNode, "GR_grp_10",
		MUIA_Group_Columns, 2,
		Child, MBObj->GLAR_Background,
		Child, GR_grp_12,
		Child, MBObj->GLAR_Ground,
		Child, GR_grp_13,
		Child, MBObj->GLAR_Texture,
		Child, GR_grp_15,
	End;

	Space_2 = HVSpace;

	GR_grp_8 = GroupObject,
		MUIA_HelpNode, "GR_grp_8",
		MUIA_Weight, 0,
		MUIA_Group_Horiz, TRUE,
		Child, Space_2,
	End;

	GR_SA = GroupObject,
		MUIA_HelpNode, "GR_SA",
		MUIA_Weight, 60,
		Child, MBObj->GLAR_SimpleAnimation,
		Child, MBObj->CY_SAObject,
		Child, MBObj->CY_SARendering,
		Child, GR_grp_10,
		Child, GR_grp_8,
	End;

	MBObj->GLAR_MouseMove = GLAreaObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Mouse moves",
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		// MUIA_GLArea_FullScreen, TRUE,
		MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 128,
		MUIA_GLArea_DefHeight, 100,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawMouseMove,
		MUIA_GLArea_MouseDownFunc, DrawMouseDown,
		MUIA_GLArea_MouseMoveFunc, DrawMouseM,
		MUIA_GLArea_MouseUpFunc, DrawMouseUp,
	End;

	GR_MM = GroupObject,
		MUIA_HelpNode, "GR_MM",
		Child, MBObj->GLAR_MouseMove,
	End;

	MBObj->GLAR_LongRendering = GLAreaObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Long rendering",
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		// MUIA_GLArea_FullScreen, TRUE,
		MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 80,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		// MUIA_GLArea_DrawFunc, DrawLongRendering,
	End;

	MBObj->BT_LRStart = SimpleButton("Render");

	MBObj->BT_LRBreak = SimpleButton("Break");

	MBObj->CH_LRThreaded = CheckMark(TRUE);

	obj_aux1 = Label2("Threaded");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->CH_LRThreaded,
	End;

	MBObj->CH_LRBuffered = CheckMark(TRUE);

	obj_aux3 = Label2("Buffered");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_LRBuffered,
	End;

	GR_grp_7 = GroupObject,
		MUIA_HelpNode, "GR_grp_7",
		Child, obj_aux0,
		Child, obj_aux2,
	End;

	Space_0 = HVSpace;

	MBObj->BT_SingleTask = SimpleButton("Open single task window");
	/*
	//--- Full screen option NOT YET USED
	MBObj->BT_FullScreen = SimpleButton("Full screen window");

	MBObj->STR_PA_ScreenMode = String("", 80);

	MBObj->PA_ScreenMode = PopButton(MUII_PopUp);

	MBObj->PA_ScreenMode = PopaslObject,
		MUIA_HelpNode, "PA_ScreenMode",
		MUIA_Popasl_Type, 2,
		MUIA_Popstring_String, MBObj->STR_PA_ScreenMode,
		MUIA_Popstring_Button, MBObj->PA_ScreenMode,
		MUIA_Popasl_StartHook, &StartScreenHook,
		MUIA_Popasl_StopHook, &StopScreenHook,
	End;
	*/
	GR_grp_6 = GroupObject,
		MUIA_HelpNode, "GR_grp_6",
		Child, MBObj->BT_LRStart,
		Child, MBObj->BT_LRBreak,
		Child, GR_grp_7,
		Child, Space_0,
		Child, MBObj->BT_SingleTask,
		// Child, MBObj->BT_FullScreen,
		// Child, MBObj->PA_ScreenMode,
	End;

	GR_LR = GroupObject,
		MUIA_HelpNode, "GR_LR",
		MUIA_Weight, 60,
		Child, MBObj->GLAR_LongRendering,
		Child, GR_grp_6,
	End;

	GP_RT_Main = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, GR_SA,
		Child, GR_MM,
		Child, GR_LR,
	End;

	MBObj->MNOpen = MenuitemObject,
		MUIA_Menuitem_Title, "Load texture",
	End;

	MNProjectBarLabel1 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNAbout = MenuitemObject,
		MUIA_Menuitem_Title, "About",
	End;

	MBObj->MNAboutMUI = MenuitemObject,
		MUIA_Menuitem_Title, "About MUI...",
	End;

	MNlabel1BarLabel0 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNQuit = MenuitemObject,
		MUIA_Menuitem_Title, "Quit",
	End;

	MNlabel1About = MenuitemObject,
		MUIA_Menuitem_Title, "Project",
		MUIA_Family_Child, MBObj->MNOpen,
		MUIA_Family_Child, MNProjectBarLabel1,
		MUIA_Family_Child, MBObj->MNAbout,
		MUIA_Family_Child, MBObj->MNAboutMUI,
		MUIA_Family_Child, MNlabel1BarLabel0,
		MUIA_Family_Child, MBObj->MNQuit,
	End;

	MN_Project = MenustripObject,
		MUIA_Family_Child, MNlabel1About,
	End;

	MBObj->WI_Main = WindowObject,
		MUIA_Window_Title, "MCC GLArea demo",
		MUIA_Window_Menustrip, MN_Project,
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GP_RT_Main,
	End;

	MBObj->GLAR_SingleTask1 = GLAreaObject,
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		// MUIA_GLArea_FullScreen, TRUE,
		// MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 100,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawLongRendering,
	End;

	MBObj->GLAR_SingleTask2 = GLAreaObject,
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 100,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawMouseMove,
		MUIA_GLArea_MouseDownFunc, DrawMouseDown,
		MUIA_GLArea_MouseMoveFunc, DrawMouseM,
		MUIA_GLArea_MouseUpFunc, DrawMouseUp,
	End;

	MBObj->GLAR_SingleTask3 = GLAreaObject,
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 100,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawSinglePawn,
		// MUIA_GLArea_MouseDownFunc, DrawMouseDown,
		// MUIA_GLArea_MouseMoveFunc, DrawMouseM,
		// MUIA_GLArea_MouseUpFunc, DrawMouseUp,
	End;

	MBObj->GLAR_SingleTask4 = GLAreaObject,
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 100,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawMouseMove,
		// MUIA_GLArea_MouseDownFunc, DrawMouseDown,
		// MUIA_GLArea_MouseMoveFunc, DrawMouseM,
		// MUIA_GLArea_MouseUpFunc, DrawMouseUp,
	End;

	MBObj->GR_SingleTask = GroupObject,
		MUIA_HelpNode, "GR_SingleTask",
		MUIA_Group_Columns, 2,
		Child, MBObj->GLAR_SingleTask1,
		Child, MBObj->GLAR_SingleTask2,
		Child, MBObj->GLAR_SingleTask3,
		Child, MBObj->GLAR_SingleTask4,
	End;

	TX_label_0 = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_label_0,
		MUIA_Text_SetMin, TRUE,
	End;

	GROUP_ROOT_1 = GroupObject,
		Child, MBObj->GR_SingleTask,
		Child, TX_label_0,
	End;

	MBObj->WI_SingleTask = WindowObject,
		MUIA_Window_Title, "Single Task gl rendering",
		MUIA_Window_ID, MAKE_ID('1', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GROUP_ROOT_1,
	End;

	/*
	MBObj->GLAR_FullScreen = GLAreaObject,
		MUIA_FillArea, FALSE,
		MUIA_GLArea_Buffered, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_FullScreen, TRUE,
		MUIA_GLArea_MinWidth, 64,
		MUIA_GLArea_MaxWidth, 1024,
		MUIA_GLArea_MinHeight, 64,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_DefWidth, 100,
		MUIA_GLArea_DefHeight, 100,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		MUIA_GLArea_DrawFunc, DrawMouseMove,
		MUIA_GLArea_MouseDownFunc, DrawMouseDown,
		MUIA_GLArea_MouseMoveFunc, DrawMouseM,
		MUIA_GLArea_MouseUpFunc, DrawMouseUp,
	End;

	GROUP_ROOT_2 = GroupObject,
		Child, MBObj->GLAR_FullScreen,
	End;

	MBObj->WI_FullScreen = WindowObject,
		// MUIA_Window_Title, "Full screen StormMesa window",
		// MUIA_Window_ID, MAKE_ID('2', 'W', 'I', 'N'),
		MUIA_Window_Borderless, TRUE,
		MUIA_Window_DragBar, TRUE,
		MUIA_Window_SizeGadget, FALSE,
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GROUP_ROOT_2,
	End;
	*/

	MBObj->App = ApplicationObject,
		MUIA_Application_Author, "Bodmer Stephan [sbodmer@lsi-media.ch]",
		MUIA_Application_Base, "GLArea_Demo",
		MUIA_Application_Title, "GLArea Demo",
		MUIA_Application_Version, "$VER: 1.40 ("__DATE__")",
		MUIA_Application_Copyright, "LSI Media SàRL [http://www.lsi-media.ch]",
		MUIA_Application_Description, "GLArea Custom class demo",
		SubWindow, MBObj->WI_Main,
		SubWindow, MBObj->WI_SingleTask,
		// SubWindow, MBObj->WI_FullScreen,
	End;

	//--- Stand ImageDB alone object ---
	MBObj->IMDB_ImageDataBase = ImageDBObject,
		MUIA_ImageDB_Application, MBObj->App,
	End;

	if (!MBObj->App)
	{
		FreeVec(MBObj);
		return(NULL);
	}

	DoMethod((Object *) MBObj->MNOpen,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNOpen,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNAbout,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNAbout,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNAboutMUI,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNAboutMUI,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNQuit,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod((Object *) MBObj->CY_SAObject,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_SAObject,
		2,
		MUIM_CallHook, &SACmdHook
		);

	DoMethod((Object *) MBObj->LV_Background,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->PO_Background,
		2,
		MUIM_Popstring_Close, TRUE
		);

	DoMethod((Object *) MBObj->LV_Background,
		MUIM_Notify, MUIA_Listview_DoubleClick, MUIV_EveryTime,
		MBObj->LV_Background,
		2,
		MUIM_CallHook, &SACmdHook
		);

	DoMethod((Object *) MBObj->LV_Ground,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->PO_Ground,
		2,
		MUIM_Popstring_Close, TRUE
		);

	DoMethod((Object *) MBObj->LV_Ground,
		MUIM_Notify, MUIA_Listview_DoubleClick, MUIV_EveryTime,
		MBObj->LV_Ground,
		2,
		MUIM_CallHook, &SACmdHook
		);

	DoMethod((Object *) MBObj->LV_Texture,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->PO_Texture,
		2,
		MUIM_Popstring_Close, TRUE
		);

	DoMethod((Object *) MBObj->LV_Texture,
		MUIM_Notify, MUIA_Listview_DoubleClick, MUIV_EveryTime,
		MBObj->LV_Texture,
		2,
		MUIM_CallHook, &SACmdHook
		);

	DoMethod((Object *) MBObj->CY_SARendering,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_SARendering,
		2,
		MUIM_CallHook, &SACmdHook
		);

	DoMethod((Object *) MBObj->BT_LRStart,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LRStart,
		2,
		MUIM_CallHook, &LRCmdHook
		);

	DoMethod((Object *) MBObj->BT_LRBreak,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LRBreak,
		2,
		MUIM_CallHook, &LRCmdHook
		);

	DoMethod((Object *) MBObj->CH_LRThreaded,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_LRThreaded,
		2,
		MUIM_CallHook, &LRCmdHook
		);

	DoMethod((Object *) MBObj->CH_LRBuffered,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_LRBuffered,
		2,
		MUIM_CallHook, &LRCmdHook
		);

	DoMethod((Object *) MBObj->BT_SingleTask,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_SingleTask,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->BT_SingleTask,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SingleTask,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	/*
	DoMethod((Object *) MBObj->BT_FullScreen,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FullScreen,
		2,
		MUIM_CallHook, &FSCmdHook
		);
	DoMethod((Object *) MBObj->BT_FullScreen,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_FullScreen,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);
	DoMethod((Object *) MBObj->BT_FullScreen,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FullScreen,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);
	*/
	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Window_SetCycleChain,
		MBObj->GLAR_SimpleAnimation,
		MBObj->CY_SAObject,
		MBObj->CY_SARendering,
		MBObj->GLAR_Background,
		MBObj->PO_Background,
		MBObj->GLAR_Ground,
		MBObj->PO_Ground,
		MBObj->GLAR_Texture,
		MBObj->PO_Texture,
		MBObj->GLAR_MouseMove,
		MBObj->GLAR_LongRendering,
		MBObj->BT_LRStart,
		MBObj->BT_LRBreak,
		MBObj->CH_LRThreaded,
		MBObj->CH_LRBuffered,
		MBObj->BT_SingleTask,
		// MBObj->BT_FullScreen,
		//MBObj->PA_ScreenMode,
		0
		);

	DoMethod((Object *) MBObj->WI_SingleTask,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_SingleTask,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_SingleTask,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_SingleTask,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);
	/*
	DoMethod((Object *) MBObj->WI_FullScreen,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_FullScreen,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_FullScreen,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_FullScreen,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->WI_FullScreen,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_FullScreen,
		2,
		MUIM_CallHook, &FSCmdHook
		);

	DoMethod((Object *) MBObj->WI_FullScreen,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_FullScreen,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);
	*/

	DoMethod((Object *) MBObj->WI_SingleTask,
		MUIM_Window_SetCycleChain, MBObj->GR_SingleTask,
		0
		);
	/*
	DoMethod((Object *) MBObj->WI_FullScreen,
		MUIM_Window_SetCycleChain, 0
		);
	*/

	set(MBObj->WI_Main,
		MUIA_Window_Open, TRUE
		);


	return(MBObj);
}

void DisposeApp(struct ObjApp * MBObj)
{
	MUI_DisposeObject( (Object *) MBObj->IMDB_ImageDataBase);
	MUI_DisposeObject( (Object *) MBObj->App);
	FreeVec(MBObj);
}
