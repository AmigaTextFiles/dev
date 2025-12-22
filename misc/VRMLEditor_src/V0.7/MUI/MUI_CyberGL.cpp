#include "MUI_CPP.include"

#include "MCC_GLArea.h"
#include "GLFunctions.h"

struct CreateWI_CyberGL(struct ObjApp *MBObj)
{
	APTR    GP_RT_CyberGL, GR_CyberGLZone, GR_CyberGLCmd, GR_grp_222, LA_label_56;
	APTR    obj_aux0, obj_aux1, GR_grp_267, GR_CyberGLViewPoint, GR_X, LA_label_59;
	APTR    GR_Y, LA_label_60, GR_Z, LA_label_61, GR_CyberGLOrientation, GR_Heading;
	APTR    LA_label_42C, GR_Pitch, LA_label_43C, GR_Bank, LA_label_43CC, GP_CyberGLRight;
	APTR    GR_CyberGLCameras, GR_CyberGLMouseEvent, GR_CyberGLPreviewType, GR_CyberGLOpenGL;
	APTR    GR_grp_265, obj_aux2, obj_aux3, obj_aux4, obj_aux5, GR_CyberGLDummy;
	APTR    Space_29;

	MBObj->RA_CyberGLActionsContent[0] = "Rotate";
	MBObj->RA_CyberGLActionsContent[1] = "Slide";
	MBObj->RA_CyberGLActionsContent[2] = "Turn";
	MBObj->RA_CyberGLActionsContent[3] = "Fly";
	MBObj->RA_CyberGLActionsContent[4] = NULL;
	MBObj->CY_CyberGLWhichContent[0] = "Main";
	MBObj->CY_CyberGLWhichContent[1] = "Clipboard";
	MBObj->CY_CyberGLWhichContent[2] = "Both";
	MBObj->CY_CyberGLWhichContent[3] = NULL;
	MBObj->CY_CyberGLLevelContent[0] = "Node";
	MBObj->CY_CyberGLLevelContent[1] = "Group";
	MBObj->CY_CyberGLLevelContent[2] = "World";
	MBObj->CY_CyberGLLevelContent[3] = NULL;
	MBObj->CY_CyberGLModeContent[0] = "Smooth";
	MBObj->CY_CyberGLModeContent[1] = "Flat";
	MBObj->CY_CyberGLModeContent[2] = "Wire";
	MBObj->CY_CyberGLModeContent[3] = "Points";
	MBObj->CY_CyberGLModeContent[4] = "Bounding boxe";
	MBObj->CY_CyberGLModeContent[5] = "Wireframe";
	MBObj->CY_CyberGLModeContent[6] = "Transparent";
	MBObj->CY_CyberGLModeContent[7] = "Textured";
	MBObj->CY_CyberGLModeContent[8] = NULL;

	MBObj->BT_CyberGLRefresh = SimpleButton("Refresh");

	MBObj->BT_CyberGLReset = SimpleButton("Reset");

	MBObj->BT_CyberGLRender = SimpleButton("Render");

	MBObj->BT_CyberGLBreak = SimpleButton("Break");

	GR_CyberGLCmd = GroupObject,
		MUIA_HelpNode, "GR_CyberGLCmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_CyberGLRefresh,
		Child, MBObj->BT_CyberGLReset,
		Child, MBObj->BT_CyberGLRender,
		Child, MBObj->BT_CyberGLBreak,
	End;

	MBObj->AR_CyberGLArea = NewObject(MBObj->glmcc->mcc_Class,NULL,
		MUIA_FillArea, TRUE,
		MCCA_GLArea_MinWidth, 80,
		MCCA_GLArea_MaxWidth, 1024,
		MCCA_GLArea_MinHeight, 60,
		MCCA_GLArea_MaxHeight, 768,
		MCCA_GLArea_DrawFunc, DrawScene,
		MCCA_GLArea_InitFunc, Init,
		MCCA_GLArea_MouseDownFunc, MouseDown,
		MCCA_GLArea_MouseMoveFunc, MouseMove,
		MCCA_GLArea_MouseUpFunc, MouseUp,
	End;

	MBObj->GR_CyberGLOutput = GroupObject,
		MUIA_HelpNode, "GR_CyberGLOutput",
	    Child, MBObj->AR_CyberGLArea,
	End;

	MBObj->GA_CyberGLRendering = GaugeObject,
		GaugeFrame,
		MUIA_HelpNode, "GA_CyberGLRendering",
		MUIA_FixHeight, 10,
		MUIA_Gauge_Horiz, TRUE,
		MUIA_Gauge_Max, 100,
	End;

	LA_label_56 = Label("Rendering");

	MBObj->CH_CyberGLAxes = CheckMark(FALSE);

	obj_aux1 = Label2("Axes");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->CH_CyberGLAxes,
	End;

	GR_grp_222 = GroupObject,
		MUIA_HelpNode, "GR_grp_222",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->GA_CyberGLRendering,
		Child, LA_label_56,
		Child, obj_aux0,
	End;

	LA_label_59 = Label("X:");

	MBObj->IM_CyberGLXLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_CyberGLXRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->STR_CyberGLX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CyberGLX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
		MUIA_String_MaxLen, 20,
	End;

	GR_X = GroupObject,
		MUIA_HelpNode, "GR_X",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		Child, LA_label_59,
		Child, MBObj->IM_CyberGLXLeft,
		Child, MBObj->IM_CyberGLXRight,
		Child, MBObj->STR_CyberGLX,
	End;

	LA_label_60 = Label("Y:");

	MBObj->IM_CyberGLYLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_CyberGLYRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->STR_CyberGLY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CyberGLY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
		MUIA_String_MaxLen, 20,
	End;

	GR_Y = GroupObject,
		MUIA_HelpNode, "GR_Y",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		Child, LA_label_60,
		Child, MBObj->IM_CyberGLYLeft,
		Child, MBObj->IM_CyberGLYRight,
		Child, MBObj->STR_CyberGLY,
	End;

	LA_label_61 = Label("Z:");

	MBObj->IM_CyberGLZLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_CyberGLZRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->STR_CyberGLZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CyberGLZ",
		MUIA_String_Contents, "40",
		MUIA_String_Accept, "0123456789.-e",
		MUIA_String_MaxLen, 20,
	End;

	GR_Z = GroupObject,
		MUIA_HelpNode, "GR_Z",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		Child, LA_label_61,
		Child, MBObj->IM_CyberGLZLeft,
		Child, MBObj->IM_CyberGLZRight,
		Child, MBObj->STR_CyberGLZ,
	End;

	GR_CyberGLViewPoint = GroupObject,
		MUIA_HelpNode, "GR_CyberGLViewPoint",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Viewpoint",
		MUIA_Group_VertSpacing, 0,
		Child, GR_X,
		Child, GR_Y,
		Child, GR_Z,
	End;

	LA_label_42C = Label("H:");

	MBObj->IM_CyberGLHLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_CyberGLHRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->STR_CyberGLHeading = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CyberGLHeading",
		MUIA_String_Contents, "90",
		MUIA_String_Accept, "0123456789.-e",
	End;

	GR_Heading = GroupObject,
		MUIA_HelpNode, "GR_Heading",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		Child, LA_label_42C,
		Child, MBObj->IM_CyberGLHLeft,
		Child, MBObj->IM_CyberGLHRight,
		Child, MBObj->STR_CyberGLHeading,
	End;

	LA_label_43C = Label("P:");

	MBObj->IM_CyberGLPLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_CyberGLPRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->STR_CyberGLPitch = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CyberGLPitch",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	GR_Pitch = GroupObject,
		MUIA_HelpNode, "GR_Pitch",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		Child, LA_label_43C,
		Child, MBObj->IM_CyberGLPLeft,
		Child, MBObj->IM_CyberGLPRight,
		Child, MBObj->STR_CyberGLPitch,
	End;

	LA_label_43CC = Label("B:");

	MBObj->IM_CyberGLBLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_CyberGLBRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->STR_CyberGLBacnk = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CyberGLBacnk",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	GR_Bank = GroupObject,
		MUIA_HelpNode, "GR_Bank",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		Child, LA_label_43CC,
		Child, MBObj->IM_CyberGLBLeft,
		Child, MBObj->IM_CyberGLBRight,
		Child, MBObj->STR_CyberGLBacnk,
	End;

	GR_CyberGLOrientation = GroupObject,
		MUIA_HelpNode, "GR_CyberGLOrientation",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Orientation",
		MUIA_Group_VertSpacing, 0,
		Child, GR_Heading,
		Child, GR_Pitch,
		Child, GR_Bank,
	End;

	GR_grp_267 = GroupObject,
		MUIA_HelpNode, "GR_grp_267",
		MUIA_Group_Horiz, TRUE,
		Child, GR_CyberGLViewPoint,
		Child, GR_CyberGLOrientation,
	End;

	GR_CyberGLZone = GroupObject,
		MUIA_HelpNode, "GR_CyberGLZone",
		Child, GR_CyberGLCmd,
		Child, MBObj->GR_CyberGLOutput,
		Child, GR_grp_222,
		Child, GR_grp_267,
	End;

	MBObj->LV_CyberGLCameras = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
	End;

	MBObj->LV_CyberGLCameras = ListviewObject,
		MUIA_HelpNode, "LV_CyberGLCameras",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_CyberGLCameras,
	End;

	MBObj->STR_PO_CyberGLCameras = String("", 80);

	MBObj->PO_CyberGLCameras = PopobjectObject,
		MUIA_HelpNode, "PO_CyberGLCameras",
		MUIA_Popstring_String, MBObj->STR_PO_CyberGLCameras,
		MUIA_Popstring_Button, PopButton(MUII_PopUp),
		MUIA_Popobject_Object, MBObj->LV_CyberGLCameras,
	End;

	GR_CyberGLCameras = GroupObject,
		MUIA_HelpNode, "GR_CyberGLCameras",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cameras",
		Child, MBObj->PO_CyberGLCameras,
	End;

	MBObj->RA_CyberGLActions = RadioObject,
		MUIA_HelpNode, "RA_CyberGLActions",
		MUIA_Radio_Entries, MBObj->RA_CyberGLActionsContent,
	End;

	GR_CyberGLMouseEvent = GroupObject,
		MUIA_HelpNode, "GR_CyberGLMouseEvent",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Mouse event",
		Child, MBObj->RA_CyberGLActions,
	End;

	MBObj->CY_CyberGLWhich = CycleObject,
		MUIA_HelpNode, "CY_CyberGLWhich",
		MUIA_Cycle_Entries, MBObj->CY_CyberGLWhichContent,
	End;

	MBObj->CY_CyberGLLevel = CycleObject,
		MUIA_HelpNode, "CY_CyberGLLevel",
		MUIA_Cycle_Entries, MBObj->CY_CyberGLLevelContent,
	End;

	GR_CyberGLPreviewType = GroupObject,
		MUIA_HelpNode, "GR_CyberGLPreviewType",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Preview type",
		Child, MBObj->CY_CyberGLWhich,
		Child, MBObj->CY_CyberGLLevel,
	End;

	MBObj->CY_CyberGLMode = CycleObject,
		MUIA_HelpNode, "CY_CyberGLMode",
		MUIA_Cycle_Entries, MBObj->CY_CyberGLModeContent,
	End;

	MBObj->CH_CyberGLFull = CheckMark(FALSE);

	obj_aux3 = Label2("F");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_CyberGLFull,
	End;

	MBObj->CH_CyberGLAnimated = CheckMark(FALSE);

	obj_aux5 = Label2("A");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->CH_CyberGLAnimated,
	End;

	GR_grp_265 = GroupObject,
		MUIA_HelpNode, "GR_grp_265",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	GR_CyberGLOpenGL = GroupObject,
		MUIA_HelpNode, "GR_CyberGLOpenGL",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "OpenGL prefs",
		Child, MBObj->CY_CyberGLMode,
		Child, GR_grp_265,
	End;

	Space_29 = HVSpace;

	GR_CyberGLDummy = GroupObject,
		MUIA_HelpNode, "GR_CyberGLDummy",
		Child, Space_29,
	End;

	GP_CyberGLRight = GroupObject,
		MUIA_Weight, 25,
		Child, GR_CyberGLCameras,
		Child, GR_CyberGLMouseEvent,
		Child, GR_CyberGLPreviewType,
		Child, GR_CyberGLOpenGL,
		Child, GR_CyberGLDummy,
	End;

	GP_RT_CyberGL = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, GR_CyberGLZone,
		Child, GP_CyberGLRight,
	End;

	MBObj->WI_CyberGL = WindowObject,
		MUIA_Window_Title, "OpenGL preview window",
		MUIA_Window_ID, MAKE_ID('3', '5', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_CyberGL,
	End;
}

