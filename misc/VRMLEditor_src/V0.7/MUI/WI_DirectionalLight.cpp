#include "MUI_CPP.include"

void CreateWI_DirectionalLight(struct ObjApp *MBObj)
{

	APTR    GP_RT_DirectionalLight, obj_aux0, obj_aux1, GR_grp_109, GR_grp_111;
	APTR    obj_aux2, obj_aux3, obj_aux4, obj_aux5, GR_grp_201, GR_grp_110, obj_aux6;
	APTR    obj_aux7, obj_aux8, obj_aux9, obj_aux10, obj_aux11, GR_grp_112, obj_aux12;
	APTR    obj_aux13, obj_aux14, obj_aux15, obj_aux16, obj_aux17, GR_grp_113;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/
	MBObj->STR_DEFDirectionalLightName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFDirectionalLightName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFDirectionalLightName,
	End;

	MBObj->CH_DirectionalLightOn = CheckMark(TRUE);

	obj_aux3 = Label2("on");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_DirectionalLightOn,
	End;

	MBObj->STR_DirectionalLightIntensity = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightIntensity",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux5 = Label2("intensity");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_DirectionalLightIntensity,
	End;

	GR_grp_111 = GroupObject,
		MUIA_HelpNode, "GR_grp_111",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	MBObj->STR_DirectionalLightR = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightR",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux7 = Label2("R");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_DirectionalLightR,
	End;

	MBObj->STR_DirectionalLightG = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightG",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux9 = Label2("G");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_DirectionalLightG,
	End;

	MBObj->STR_DirectionalLightB = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightB",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux11 = Label2("B");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_DirectionalLightB,
	End;

	GR_grp_110 = GroupObject,
		MUIA_HelpNode, "GR_grp_110",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Color",
		Child, obj_aux6,
		Child, obj_aux8,
		Child, obj_aux10,
	End;

	MBObj->STR_DirectionalLightX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux13 = Label2("X");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_DirectionalLightX,
	End;

	MBObj->STR_DirectionalLightY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux15 = Label2("Y");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_DirectionalLightY,
	End;

	MBObj->STR_DirectionalLightZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DirectionalLightZ",
		MUIA_String_Contents, "-1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux17 = Label2("Z");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_DirectionalLightZ,
	End;

	GR_grp_112 = GroupObject,
		MUIA_HelpNode, "GR_grp_112",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Direction",
		Child, obj_aux12,
		Child, obj_aux14,
		Child, obj_aux16,
	End;

	GR_grp_201 = GroupObject,
		MUIA_HelpNode, "GR_grp_201",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_110,
		Child, GR_grp_112,
	End;

	GR_grp_109 = GroupObject,
		MUIA_HelpNode, "GR_grp_109",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Atttributs",
		Child, GR_grp_111,
		Child, GR_grp_201,
	End;

	MBObj->BT_DirectionalLightOk = SimpleButton("Ok");

	MBObj->BT_DirectionalLightDefault = SimpleButton("Default");

	MBObj->BT_DirectionalLightCancel = SimpleButton("Cancel");

	GR_grp_113 = GroupObject,
		MUIA_HelpNode, "GR_grp_113",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_DirectionalLightOk,
		Child, MBObj->BT_DirectionalLightDefault,
		Child, MBObj->BT_DirectionalLightCancel,
	End;

	GP_RT_DirectionalLight = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_109,
		Child, GR_grp_113,
	End;

	MBObj->WI_DirectionalLight = WindowObject,
		MUIA_Window_Title, "DirectionalLight",
		MUIA_Window_ID, MAKE_ID('1', '8', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_DirectionalLight,
	End;

}

