#include "MUI_CPP.include"

void CreateWI_SpotLight(struct ObjApp *MBObj)
{
	APTR    GP_RT_SpotLight, obj_aux0, obj_aux1, GR_grp_109CC, GR_grp_111CC, obj_aux2;
	APTR    obj_aux3, obj_aux4, obj_aux5, GR_grp_206, GR_grp_110CC, obj_aux6;
	APTR    obj_aux7, obj_aux8, obj_aux9, obj_aux10, obj_aux11, GR_grp_112CC;
	APTR    obj_aux12, obj_aux13, obj_aux14, obj_aux15, obj_aux16, obj_aux17;
	APTR    GR_grp_171, obj_aux18, obj_aux19, obj_aux20, obj_aux21, obj_aux22;
	APTR    obj_aux23, GR_grp_172, obj_aux24, obj_aux25, obj_aux26, obj_aux27;
	APTR    GR_grp_113CC;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->STR_DEFSpotLightName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFSpotLightName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFSpotLightName,
	End;

	MBObj->CH_SpotLightOn = CheckMark(TRUE);

	obj_aux3 = Label2("on");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->CH_SpotLightOn,
	End;

	MBObj->STR_SpotLightIntensity = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightIntensity",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux5 = Label2("intensity");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_SpotLightIntensity,
	End;

	GR_grp_111CC = GroupObject,
		MUIA_HelpNode, "GR_grp_111CC",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	MBObj->STR_SpotLightR = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightR",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux7 = Label2("R");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_SpotLightR,
	End;

	MBObj->STR_SpotLightG = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightG",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux9 = Label2("G");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_SpotLightG,
	End;

	MBObj->STR_SpotLightB = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightB",
		MUIA_String_Contents, "1.0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux11 = Label2("B");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_SpotLightB,
	End;

	GR_grp_110CC = GroupObject,
		MUIA_HelpNode, "GR_grp_110CC",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Color",
		Child, obj_aux6,
		Child, obj_aux8,
		Child, obj_aux10,
	End;

	MBObj->STR_SpotLightX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux13 = Label2("X");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_SpotLightX,
	End;

	MBObj->STR_SpotLightY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux15 = Label2("Y");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_SpotLightY,
	End;

	MBObj->STR_SpotLightZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux17 = Label2("Z");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_SpotLightZ,
	End;

	GR_grp_112CC = GroupObject,
		MUIA_HelpNode, "GR_grp_112CC",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Location",
		Child, obj_aux12,
		Child, obj_aux14,
		Child, obj_aux16,
	End;

	MBObj->STR_SpotLightDirX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightDirX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux19 = Label2("X");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->STR_SpotLightDirX,
	End;

	MBObj->STR_SpotLightDirY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightDirY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux21 = Label2("Y");

	obj_aux20 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux21,
		Child, MBObj->STR_SpotLightDirY,
	End;

	MBObj->STR_SpotLightDirZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightDirZ",
		MUIA_String_Contents, "-1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux23 = Label2("Z");

	obj_aux22 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux23,
		Child, MBObj->STR_SpotLightDirZ,
	End;

	GR_grp_171 = GroupObject,
		MUIA_HelpNode, "GR_grp_171",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "direction",
		Child, obj_aux18,
		Child, obj_aux20,
		Child, obj_aux22,
	End;

	MBObj->STR_SpotLightDrop = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightDrop",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux25 = Label2("dropOffRate");

	obj_aux24 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux25,
		Child, MBObj->STR_SpotLightDrop,
	End;

	MBObj->STR_SpotLightCut = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SpotLightCut",
		MUIA_String_Contents, "0.785398",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux27 = Label2("cutOffAngle");

	obj_aux26 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux27,
		Child, MBObj->STR_SpotLightCut,
	End;

	GR_grp_172 = GroupObject,
		MUIA_HelpNode, "GR_grp_172",
		Child, obj_aux24,
		Child, obj_aux26,
	End;

	GR_grp_206 = GroupObject,
		MUIA_HelpNode, "GR_grp_206",
		MUIA_Group_Columns, 2,
		Child, GR_grp_110CC,
		Child, GR_grp_112CC,
		Child, GR_grp_171,
		Child, GR_grp_172,
	End;

	GR_grp_109CC = GroupObject,
		MUIA_HelpNode, "GR_grp_109CC",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Atttributs",
		Child, GR_grp_111CC,
		Child, GR_grp_206,
	End;

	MBObj->BT_SpotLightOk = SimpleButton("Ok");

	MBObj->BT_SpotLightDefault = SimpleButton("Default");

	MBObj->BT_SpotLightCancel = SimpleButton("Cancel");

	GR_grp_113CC = GroupObject,
		MUIA_HelpNode, "GR_grp_113CC",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_SpotLightOk,
		Child, MBObj->BT_SpotLightDefault,
		Child, MBObj->BT_SpotLightCancel,
	End;

	GP_RT_SpotLight = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_109CC,
		Child, GR_grp_113CC,
	End;

	MBObj->WI_SpotLight = WindowObject,
		MUIA_Window_Title, "SpotLight",
		MUIA_Window_ID, MAKE_ID('2', '9', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_SpotLight,
	End;

}

