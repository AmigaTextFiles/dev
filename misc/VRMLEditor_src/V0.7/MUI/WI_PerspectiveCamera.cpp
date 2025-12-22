#include "MUI_CPP.include"

void CreateWI_PerspectiveCamera(struct ObjApp *MBObj)
{
	APTR    GP_RT_PerspectiveCamera, obj_aux0, obj_aux1, GR_grp_149, GR_grp_146;
	APTR    GR_grp_204, GR_grp_144, obj_aux2, obj_aux3, obj_aux4, obj_aux5, obj_aux6;
	APTR    obj_aux7, GR_grp_147, obj_aux8, obj_aux9, obj_aux10, obj_aux11, obj_aux12;
	APTR    obj_aux13, obj_aux14, obj_aux15, GR_grp_148, obj_aux16, obj_aux17;
	APTR    obj_aux18, obj_aux19, GR_grp_145;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook PerspectiveChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) PerspectiveChangeContents, NULL, NULL};

	MBObj->STR_DEFPerspectiveCameraName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFPerspectiveCameraName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("Camera name");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFPerspectiveCameraName,
	End;

	MBObj->BT_PerspectiveCameraView = TextObject,
		ButtonFrame,
		MUIA_Disabled, TRUE,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Camera view",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_PerspectiveCameraView",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	MBObj->BT_PerspectiveCameraGrab = TextObject,
		ButtonFrame,
		MUIA_Disabled, TRUE,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, "Grab camera position",
		MUIA_Text_PreParse, "\033c",
		MUIA_HelpNode, "BT_PerspectiveCameraGrab",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	GR_grp_149 = GroupObject,
		MUIA_HelpNode, "GR_grp_149",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_PerspectiveCameraView,
		Child, MBObj->BT_PerspectiveCameraGrab,
	End;

	MBObj->STR_PerspectiveCameraX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_PerspectiveCameraX,
	End;

	MBObj->STR_PerspectiveCameraY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_PerspectiveCameraY,
	End;

	MBObj->STR_PerspectiveCameraZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_PerspectiveCameraZ,
	End;

	GR_grp_144 = GroupObject,
		MUIA_HelpNode, "GR_grp_144",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "position",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->STR_PerspectiveCameraOX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraOX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux9 = Label2("X");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_PerspectiveCameraOX,
	End;

	MBObj->STR_PerspectiveCameraOY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraOY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux11 = Label2("Y");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_PerspectiveCameraOY,
	End;

	MBObj->STR_PerspectiveCameraOZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraOZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux13 = Label2("Z");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_PerspectiveCameraOZ,
	End;

	MBObj->STR_PerspectiveCameraOAngle = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraOAngle",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux15 = Label2("Angle (DEG)");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_PerspectiveCameraOAngle,
	End;

	GR_grp_147 = GroupObject,
		MUIA_HelpNode, "GR_grp_147",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "orientation",
		Child, obj_aux8,
		Child, obj_aux10,
		Child, obj_aux12,
		Child, obj_aux14,
	End;

	GR_grp_204 = GroupObject,
		MUIA_HelpNode, "GR_grp_204",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_144,
		Child, GR_grp_147,
	End;

	MBObj->STR_PerspectiveCameraFocal = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraFocal",
		MUIA_String_Contents, "5",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux17 = Label2("focalDistance");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_PerspectiveCameraFocal,
	End;

	MBObj->STR_PerspectiveCameraHeight = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PerspectiveCameraHeight",
		MUIA_String_Contents, "45",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux19 = Label2("heightAngle (DEG)");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->STR_PerspectiveCameraHeight,
	End;

	GR_grp_148 = GroupObject,
		MUIA_HelpNode, "GR_grp_148",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "focalDistance & heightAngle",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux16,
		Child, obj_aux18,
	End;

	GR_grp_146 = GroupObject,
		MUIA_HelpNode, "GR_grp_146",
		Child, GR_grp_204,
		Child, GR_grp_148,
	End;

	MBObj->BT_PerspectiveCameraOk = SimpleButton("Ok");

	MBObj->BT_PerspectiveCameraDefault = SimpleButton("Default");

	MBObj->BT_PerspectiveCameraCancel = SimpleButton("Cancel");

	GR_grp_145 = GroupObject,
		MUIA_HelpNode, "GR_grp_145",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_PerspectiveCameraOk,
		Child, MBObj->BT_PerspectiveCameraDefault,
		Child, MBObj->BT_PerspectiveCameraCancel,
	End;

	GP_RT_PerspectiveCamera = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_149,
		Child, GR_grp_146,
		Child, GR_grp_145,
	End;

	MBObj->WI_PerspectiveCamera = WindowObject,
		MUIA_Window_Title, "PerspectiveCamera",
		MUIA_Window_ID, MAKE_ID('2', '5', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_PerspectiveCamera,
	End;

}

