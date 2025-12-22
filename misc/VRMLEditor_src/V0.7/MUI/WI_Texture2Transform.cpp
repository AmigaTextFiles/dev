#include "MUI_CPP.include"

void CreateWI_Texture2Transform(struct ObjApp *MBObj)
{
	APTR    GP_RT_Texture2Transform, obj_aux0, obj_aux1, GR_grp_176, GR_grp_178;
	APTR    obj_aux2, obj_aux3, obj_aux4, obj_aux5, obj_aux6, obj_aux7, GR_grp_179;
	APTR    obj_aux8, obj_aux9, obj_aux10, obj_aux11, GR_grp_180, obj_aux12, obj_aux13;
	APTR    obj_aux14, obj_aux15, GR_grp_177;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/
	MBObj->STR_DEFTexture2TransformName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFTexture2TransformName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFTexture2TransformName,
	End;

	MBObj->STR_Texture2TransformTX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformTX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_Texture2TransformTX,
	End;

	MBObj->STR_Texture2TransformTY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformTY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_Texture2TransformTY,
	End;

	GR_grp_178 = GroupObject,
		MUIA_HelpNode, "GR_grp_178",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "translation",
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	MBObj->STR_Texture2TransformRot = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformRot",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("rotation (DEG)");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_Texture2TransformRot,
	End;

	MBObj->STR_Texture2TransformSX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformSX",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux9 = Label2("X");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_Texture2TransformSX,
	End;

	MBObj->STR_Texture2TransformSY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformSY",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux11 = Label2("Y");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_Texture2TransformSY,
	End;

	GR_grp_179 = GroupObject,
		MUIA_HelpNode, "GR_grp_179",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "scaleFactor",
		Child, obj_aux8,
		Child, obj_aux10,
	End;

	MBObj->STR_Texture2TransformCenterX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformCenterX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux13 = Label2("X");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_Texture2TransformCenterX,
	End;

	MBObj->STR_Texture2TransformCenterY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2TransformCenterY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux15 = Label2("Y");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_Texture2TransformCenterY,
	End;

	GR_grp_180 = GroupObject,
		MUIA_HelpNode, "GR_grp_180",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "center",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux12,
		Child, obj_aux14,
	End;

	GR_grp_176 = GroupObject,
		MUIA_HelpNode, "GR_grp_176",
		Child, GR_grp_178,
		Child, obj_aux6,
		Child, GR_grp_179,
		Child, GR_grp_180,
	End;

	MBObj->BT_Texture2TransformOk = SimpleButton("Ok");

	MBObj->BT_Texture2TransformDefault = SimpleButton("Default");

	MBObj->BT_Texture2TransformCancel = SimpleButton("Cancel");

	GR_grp_177 = GroupObject,
		MUIA_HelpNode, "GR_grp_177",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_Texture2TransformOk,
		Child, MBObj->BT_Texture2TransformDefault,
		Child, MBObj->BT_Texture2TransformCancel,
	End;

	GP_RT_Texture2Transform = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_176,
		Child, GR_grp_177,
	End;

	MBObj->WI_Texture2Transform = WindowObject,
		MUIA_Window_Title, "Texture2Transform",
		MUIA_Window_ID, MAKE_ID('3', '2', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Texture2Transform,
	End;

}
