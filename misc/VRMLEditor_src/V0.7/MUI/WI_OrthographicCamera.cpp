#include "MUI_CPP.include"

void CreateWI_OrthographicCamera(struct ObjApp *MBObj)
{
	APTR    GP_RT_OrthographicCamera, obj_aux0, obj_aux1, GR_grp_143, GR_grp_139;
	APTR    GR_grp_203, GR_grp_140, obj_aux2, obj_aux3, obj_aux4, obj_aux5, obj_aux6;
	APTR    obj_aux7, GR_grp_141, obj_aux8, obj_aux9, obj_aux10, obj_aux11, obj_aux12;
	APTR    obj_aux13, obj_aux14, obj_aux15, GR_grp_142, obj_aux16, obj_aux17;
	APTR    obj_aux18, obj_aux19, GR_grp_138;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook OrthoChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) OrthoChangeContents, NULL, NULL};

	MBObj->STR_DEFOrthographicCameraName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFOrthographicCameraName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("Camera name");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFOrthographicCameraName,
	End;

	MBObj->BT_OrthographicCameraView = TextObject,
		ButtonFrame,
		MUIA_Disabled, TRUE,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Camera view",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_OrthographicCameraView",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	MBObj->BT_OrthographicCameraGrab = TextObject,
		ButtonFrame,
		MUIA_Disabled, TRUE,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Grab camera position",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_OrthographicCameraGrab",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	GR_grp_143 = GroupObject,
		MUIA_HelpNode, "GR_grp_143",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_OrthographicCameraView,
		Child, MBObj->BT_OrthographicCameraGrab,
	End;

	MBObj->STR_OrthographicCameraPosX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraPosX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_OrthographicCameraPosX,
	End;

	MBObj->STR_OrthographicCameraPosY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraPosY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_OrthographicCameraPosY,
	End;

	MBObj->STR_OrthographicCameraPosZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraPosZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_OrthographicCameraPosZ,
	End;

	GR_grp_140 = GroupObject,
		MUIA_HelpNode, "GR_grp_140",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "position",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->STR_OrthographicCameraOX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraOX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux9 = Label2("X");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		MUIA_Weight, 80,
		Child, obj_aux9,
		Child, MBObj->STR_OrthographicCameraOX,
	End;

	MBObj->STR_OrthographicCameraOY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraOY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux11 = Label2("Y");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		MUIA_Weight, 80,
		Child, obj_aux11,
		Child, MBObj->STR_OrthographicCameraOY,
	End;

	MBObj->STR_OrthographicCameraOZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraOZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux13 = Label2("Z");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		MUIA_Weight, 80,
		Child, obj_aux13,
		Child, MBObj->STR_OrthographicCameraOZ,
	End;

	MBObj->STR_OrthographicCameraOAngle = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraOAngle",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux15 = Label2("Angle (DEG)");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_OrthographicCameraOAngle,
	End;

	GR_grp_141 = GroupObject,
		MUIA_HelpNode, "GR_grp_141",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "orientation",
		Child, obj_aux8,
		Child, obj_aux10,
		Child, obj_aux12,
		Child, obj_aux14,
	End;

	GR_grp_203 = GroupObject,
		MUIA_HelpNode, "GR_grp_203",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_140,
		Child, GR_grp_141,
	End;

	MBObj->STR_OrthographicCameraFocal = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraFocal",
		MUIA_String_Contents, "5",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux17 = Label2("focal distance");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_OrthographicCameraFocal,
	End;

	MBObj->STR_OrthographicCameraHeight = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_OrthographicCameraHeight",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux19 = Label2("height");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->STR_OrthographicCameraHeight,
	End;

	GR_grp_142 = GroupObject,
		MUIA_HelpNode, "GR_grp_142",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "focal distance & height",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux16,
		Child, obj_aux18,
	End;

	GR_grp_139 = GroupObject,
		MUIA_HelpNode, "GR_grp_139",
		Child, GR_grp_203,
		Child, GR_grp_142,
	End;

	MBObj->BT_OrthographicCameraOk = SimpleButton("Ok");

	MBObj->BT_OrthographicCameraDefault = SimpleButton("Default");

	MBObj->BT_OrthographicCameraCancel = SimpleButton("Cancel");

	GR_grp_138 = GroupObject,
		MUIA_HelpNode, "GR_grp_138",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_OrthographicCameraOk,
		Child, MBObj->BT_OrthographicCameraDefault,
		Child, MBObj->BT_OrthographicCameraCancel,
	End;

	GP_RT_OrthographicCamera = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_143,
		Child, GR_grp_139,
		Child, GR_grp_138,
	End;

	MBObj->WI_OrthographicCamera = WindowObject,
		MUIA_Window_Title, "OrthographicCamera",
		MUIA_Window_ID, MAKE_ID('2', '4', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_OrthographicCamera,
	End;
}

