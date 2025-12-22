#include "MUI_CPP.include"

void CreateWI_FontStyle(struct ObjApp *MBObj)
{
	APTR    GP_RT_FontStyle, obj_aux0, obj_aux1, GR_grp_116, obj_aux2, obj_aux3;
	APTR    GR_grp_118, LA_label_32, GR_grp_119, Space_7, GR_grp_202, obj_aux4;
	APTR    obj_aux5, obj_aux6, obj_aux7, Space_8, GR_grp_117;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/
	MBObj->CY_FontStyleFamilyContent[0] = "SERIF";
	MBObj->CY_FontStyleFamilyContent[1] = "SANS";
	MBObj->CY_FontStyleFamilyContent[2] = "TYPEWRITER";
	MBObj->CY_FontStyleFamilyContent[3] = NULL;

	MBObj->STR_DEFFontStyleName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFFontStyleName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFFontStyleName,
	End;

	MBObj->STR_FontStyleSize = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_FontStyleSize",
		MUIA_String_Contents, "10",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux3 = Label2("size");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_FontStyleSize,
	End;

	LA_label_32 = Label("family");

	MBObj->CY_FontStyleFamily = CycleObject,
		MUIA_HelpNode, "CY_FontStyleFamily",
		MUIA_Cycle_Entries, MBObj->CY_FontStyleFamilyContent,
	End;

	GR_grp_118 = GroupObject,
		MUIA_HelpNode, "GR_grp_118",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_32,
		Child, MBObj->CY_FontStyleFamily,
	End;

	Space_7 = HVSpace;

	MBObj->CH_FontStyleBold = CheckMark(FALSE);

	obj_aux5 = Label2("BOLD");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->CH_FontStyleBold,
	End;

	MBObj->CH_FontStyleItalic = CheckMark(FALSE);

	obj_aux7 = Label2("ITALIC");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->CH_FontStyleItalic,
	End;

	GR_grp_202 = GroupObject,
		MUIA_HelpNode, "GR_grp_202",
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	Space_8 = HVSpace;

	GR_grp_119 = GroupObject,
		MUIA_HelpNode, "GR_grp_119",
		MUIA_Group_Horiz, TRUE,
		Child, Space_7,
		Child, GR_grp_202,
		Child, Space_8,
	End;

	GR_grp_116 = GroupObject,
		MUIA_HelpNode, "GR_grp_116",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, GR_grp_118,
		Child, GR_grp_119,
	End;

	MBObj->BT_FontStyleOk = SimpleButton("Ok");

	MBObj->BT_FontStyleDefault = SimpleButton("Default");

	MBObj->BT_FontStyleCancel = SimpleButton("Cancel");

	GR_grp_117 = GroupObject,
		MUIA_HelpNode, "GR_grp_117",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_FontStyleOk,
		Child, MBObj->BT_FontStyleDefault,
		Child, MBObj->BT_FontStyleCancel,
	End;

	GP_RT_FontStyle = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_116,
		Child, GR_grp_117,
	End;

	MBObj->WI_FontStyle = WindowObject,
		MUIA_Window_Title, "FontStyle",
		MUIA_Window_ID, MAKE_ID('1', '9', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_FontStyle,
	End;
}

