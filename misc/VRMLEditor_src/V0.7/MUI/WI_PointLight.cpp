#include "MUI_CPP.include"

void CreateWI_PointLight(struct ObjApp *MBObj)
{
	APTR    GP_RT_PointLight, obj_aux0, obj_aux1, GR_grp_109C, GR_grp_111C, obj_aux2;
	APTR    obj_aux3, obj_aux4, obj_aux5, GR_grp_205, GR_grp_112C, obj_aux6, obj_aux7;
	APTR    obj_aux8, obj_aux9, obj_aux10, obj_aux11, GR_grp_110C, obj_aux12;
	APTR    obj_aux13, obj_aux14, obj_aux15, obj_aux16, obj_aux17, GR_grp_113C;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->STR_DEFPointLightName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFPointLightName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFPointLightName,
	End;

	MBObj->CH_PointLightOn = CheckMark(TRUE);

	obj_aux3 = Label2("on");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_PointLightOn,
	End;

	MBObj->STR_PointLightIntensity = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightIntensity",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux5 = Label2("intensity");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_PointLightIntensity,
	End;

	GR_grp_111C = GroupObject,
		MUIA_HelpNode, "GR_grp_111C",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	MBObj->STR_PointLightX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("X");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_PointLightX,
	End;

	MBObj->STR_PointLightY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux9 = Label2("Y");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_PointLightY,
	End;

	MBObj->STR_PointLightZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightZ",
		MUIA_String_Contents, "-1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux11 = Label2("Z");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_PointLightZ,
	End;

	GR_grp_112C = GroupObject,
		MUIA_HelpNode, "GR_grp_112C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Location",
		Child, obj_aux6,
		Child, obj_aux8,
		Child, obj_aux10,
	End;

	MBObj->STR_PointLightR = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightR",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux13 = Label2("R");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_PointLightR,
	End;

	MBObj->STR_PointLightG = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightG",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux15 = Label2("G");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_PointLightG,
	End;

	MBObj->STR_PointLightB = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointLightB",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux17 = Label2("B");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_PointLightB,
	End;

	GR_grp_110C = GroupObject,
		MUIA_HelpNode, "GR_grp_110C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Color",
		Child, obj_aux12,
		Child, obj_aux14,
		Child, obj_aux16,
	End;

	GR_grp_205 = GroupObject,
		MUIA_HelpNode, "GR_grp_205",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_112C,
		Child, GR_grp_110C,
	End;

	GR_grp_109C = GroupObject,
		MUIA_HelpNode, "GR_grp_109C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Atttributs",
		Child, GR_grp_111C,
		Child, GR_grp_205,
	End;

	MBObj->BT_PointLightOk = SimpleButton("Ok");

	MBObj->BT_PointLightDefault = SimpleButton("Default");

	MBObj->BT_PointLightCancel = SimpleButton("Cancel");

	GR_grp_113C = GroupObject,
		MUIA_HelpNode, "GR_grp_113C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_PointLightOk,
		Child, MBObj->BT_PointLightDefault,
		Child, MBObj->BT_PointLightCancel,
	End;

	GP_RT_PointLight = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_109C,
		Child, GR_grp_113C,
	End;

	MBObj->WI_PointLight = WindowObject,
		MUIA_Window_Title, "PointLight",
		MUIA_Window_ID, MAKE_ID('2', '6', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_PointLight,
	End;

}

