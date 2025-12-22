#include "MUI_CPP.include"

void CreateWI_AsciiText(struct ObjApp *MBObj)
{
	APTR    GP_RT_AsciiText, obj_aux0, obj_aux1, GR_grp_101, GR_grp_104, obj_aux2;
	APTR    obj_aux3, obj_aux4, obj_aux5, GR_grp_114, GR_grp_105, obj_aux6, obj_aux7;
	APTR    GR_grp_106, LA_label_29, GR_grp_102;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook AsciiTextChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) AsciiTextChangeContents, NULL, NULL};


	MBObj->CY_AsciiTextJustificationContent[0] = "LEFT";
	MBObj->CY_AsciiTextJustificationContent[1] = "CENTER";
	MBObj->CY_AsciiTextJustificationContent[2] = "RIGHT";
	MBObj->CY_AsciiTextJustificationContent[3] = NULL;

	MBObj->STR_DEFAsciiTextName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFAsciiTextName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFAsciiTextName,
	End;

	MBObj->LV_AsciiTextStrings = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_AsciiTextStrings = ListviewObject,
		MUIA_HelpNode, "LV_AsciiTextStrings",
		MUIA_Listview_List, MBObj->LV_AsciiTextStrings,
	End;

	MBObj->STR_AsciiTextString = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_AsciiTextString",
		MUIA_String_Contents, "NEW",
	End;

	obj_aux3 = Label2("string");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_AsciiTextString,
	End;

	MBObj->STR_AsciiTextWidth = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_AsciiTextWidth",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux5 = Label2("width");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_AsciiTextWidth,
	End;

	GR_grp_104 = GroupObject,
		MUIA_HelpNode, "GR_grp_104",
		Child, MBObj->LV_AsciiTextStrings,
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	GR_grp_101 = GroupObject,
		MUIA_HelpNode, "GR_grp_101",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attribut",
		Child, GR_grp_104,
	End;

	MBObj->BT_AsciiTextAdd = SimpleButton("Add new string");

	MBObj->BT_AsciiTextDelete = SimpleButton("Delete string");

	GR_grp_114 = GroupObject,
		MUIA_HelpNode, "GR_grp_114",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Actions",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_AsciiTextAdd,
		Child, MBObj->BT_AsciiTextDelete,
	End;

	MBObj->STR_AsciiTextSpacing = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_AsciiTextSpacing",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux7 = Label2("spacing");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_AsciiTextSpacing,
	End;

	LA_label_29 = Label("justification:");

	MBObj->CY_AsciiTextJustification = CycleObject,
		MUIA_HelpNode, "CY_AsciiTextJustification",
		MUIA_Cycle_Entries, MBObj->CY_AsciiTextJustificationContent,
	End;

	GR_grp_106 = GroupObject,
		MUIA_HelpNode, "GR_grp_106",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_29,
		Child, MBObj->CY_AsciiTextJustification,
	End;

	GR_grp_105 = GroupObject,
		MUIA_HelpNode, "GR_grp_105",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "spacing&justification",
		Child, obj_aux6,
		Child, GR_grp_106,
	End;

	MBObj->BT_AsciiTextOk = SimpleButton("Ok");

	MBObj->BT_AsciiTextCancel = SimpleButton("Cancel");

	GR_grp_102 = GroupObject,
		MUIA_HelpNode, "GR_grp_102",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_AsciiTextOk,
		Child, MBObj->BT_AsciiTextCancel,
	End;

	GP_RT_AsciiText = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_101,
		Child, GR_grp_114,
		Child, GR_grp_105,
		Child, GR_grp_102,
	End;

	MBObj->WI_AsciiText = WindowObject,
		MUIA_Window_Title, "AsciiText",
		MUIA_Window_ID, MAKE_ID('1', '7', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_AsciiText,
	End;

}

