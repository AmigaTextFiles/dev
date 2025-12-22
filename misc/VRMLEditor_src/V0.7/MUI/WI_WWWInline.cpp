#include "MUI_CPP.include"

void CreateWI_WWWInline(struct ObjApp *MBObj)
{
	APTR    GP_RT_WWWInline, obj_aux0, obj_aux1, GR_grp_187, obj_aux2, obj_aux3;
	APTR    GR_grp_207, GR_grp_188, obj_aux4, obj_aux5, obj_aux6, obj_aux7, obj_aux8;
	APTR    obj_aux9, GR_grp_189, obj_aux10, obj_aux11, obj_aux12, obj_aux13;
	APTR    obj_aux14, obj_aux15, GR_grp_190;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	static const struct Hook SpecialCmdHook = { {NULL, NULL}, (HOOKFUNC) SpecialCmd, NULL, NULL};
	*/
	MBObj->STR_DEFWWWInlineName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFWWWInlineName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFWWWInlineName,
	End;

	MBObj->STR_WWWInlineName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineName",
	End;

	obj_aux3 = Label2("Name");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_WWWInlineName,
	End;

	MBObj->BT_WWWInlineRead = SimpleButton("Read the inline world");

	MBObj->STR_WWWInlineBoxSizeX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineBoxSizeX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("X");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_WWWInlineBoxSizeX,
	End;

	MBObj->STR_WWWInlineBoxSizeY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineBoxSizeY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("Y");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_WWWInlineBoxSizeY,
	End;

	MBObj->STR_WWWInlineBoxSizeZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineBoxSizeZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux9 = Label2("Z");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_WWWInlineBoxSizeZ,
	End;

	GR_grp_188 = GroupObject,
		MUIA_HelpNode, "GR_grp_188",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "bboxSize",
		Child, obj_aux4,
		Child, obj_aux6,
		Child, obj_aux8,
	End;

	MBObj->STR_WWWInlineBoxCenterX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineBoxCenterX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux11 = Label2("X");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_WWWInlineBoxCenterX,
	End;

	MBObj->STR_WWWInlineBoxCenterY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineBoxCenterY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux13 = Label2("Y");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_WWWInlineBoxCenterY,
	End;

	MBObj->STR_WWWInlineBoxCenterZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWInlineBoxCenterZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux15 = Label2("Z");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_WWWInlineBoxCenterZ,
	End;

	GR_grp_189 = GroupObject,
		MUIA_HelpNode, "GR_grp_189",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "bboxCenter",
		Child, obj_aux10,
		Child, obj_aux12,
		Child, obj_aux14,
	End;

	GR_grp_207 = GroupObject,
		MUIA_HelpNode, "GR_grp_207",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_188,
		Child, GR_grp_189,
	End;

	GR_grp_187 = GroupObject,
		MUIA_HelpNode, "GR_grp_187",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, MBObj->BT_WWWInlineRead,
		Child, GR_grp_207,
	End;

	MBObj->BT_WWWInlineOk = SimpleButton("Ok");

	MBObj->BT_WWWInlineDefault = SimpleButton("Default");

	MBObj->BT_WWWInlineCancel = SimpleButton("Cancel");

	GR_grp_190 = GroupObject,
		MUIA_HelpNode, "GR_grp_190",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_WWWInlineOk,
		Child, MBObj->BT_WWWInlineDefault,
		Child, MBObj->BT_WWWInlineCancel,
	End;

	GP_RT_WWWInline = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_187,
		Child, GR_grp_190,
	End;

	MBObj->WI_WWWInline = WindowObject,
		MUIA_Window_Title, "WWWInline",
		MUIA_Window_ID, MAKE_ID('3', '5', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_WWWInline,
	End;

}
