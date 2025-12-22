#include "MUI_CPP.include"

void CreateWI_Separator(struct ObjApp *MBObj)
{
	APTR    GR_RT_Separator, obj_aux0, obj_aux1, GR_Info, LA_SeparatorNum, GR_grp_79;
	APTR    LA_label_20, GR_grp_80;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_TX_SeparatorNum = NULL;

	MBObj->CY_SeparatorRenderCullingContent[0] = "AUTO";
	MBObj->CY_SeparatorRenderCullingContent[1] = "ON";
	MBObj->CY_SeparatorRenderCullingContent[2] = "OFF";
	MBObj->CY_SeparatorRenderCullingContent[3] = NULL;

	MBObj->STR_DEFSeparatorName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFSeparatorName",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("Separator DEF Name");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFSeparatorName,
	End;

	LA_SeparatorNum = Label("Number of children");

	MBObj->TX_SeparatorNum = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_SeparatorNum,
	End;

	GR_Info = GroupObject,
		MUIA_HelpNode, "GR_Info",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, LA_SeparatorNum,
		Child, MBObj->TX_SeparatorNum,
	End;

	LA_label_20 = Label("renderCulling");

	MBObj->CY_SeparatorRenderCulling = CycleObject,
		MUIA_HelpNode, "CY_SeparatorRenderCulling",
		MUIA_Cycle_Entries, MBObj->CY_SeparatorRenderCullingContent,
	End;

	GR_grp_79 = GroupObject,
		MUIA_HelpNode, "GR_grp_79",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attribut",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_20,
		Child, MBObj->CY_SeparatorRenderCulling,
	End;

	MBObj->BT_SeparatorOk = SimpleButton("Ok");

	GR_grp_80 = GroupObject,
		MUIA_HelpNode, "GR_grp_80",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_SeparatorOk,
	End;

	GR_RT_Separator = GroupObject,
		Child, obj_aux0,
		Child, GR_Info,
		Child, GR_grp_79,
		Child, GR_grp_80,
	End;

	MBObj->WI_Separator = WindowObject,
		MUIA_Window_Title, "Separator",
		MUIA_Window_ID, MAKE_ID('4', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GR_RT_Separator,
	End;

}

