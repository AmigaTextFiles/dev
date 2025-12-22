#include "MUI_CPP.include"

void CreateWI_Group(struct ObjApp *MBObj)
{
	APTR    GP_RT_Group, obj_aux0, obj_aux1, GR_grp_81, LA_label_21, GR_grp_82;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_TX_GroupNum = NULL;

	MBObj->STR_DEFGroupName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFGroupName",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFGroupName,
	End;

	LA_label_21 = Label("Number of children");

	MBObj->TX_GroupNum = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_GroupNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_81 = GroupObject,
		MUIA_HelpNode, "GR_grp_81",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_21,
		Child, MBObj->TX_GroupNum,
	End;

	MBObj->BT_GroupOk = SimpleButton("Ok");

	GR_grp_82 = GroupObject,
		MUIA_HelpNode, "GR_grp_82",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_GroupOk,
	End;

	GP_RT_Group = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_81,
		Child, GR_grp_82,
	End;

	MBObj->WI_Group = WindowObject,
		MUIA_Window_Title, "Group",
		MUIA_Window_ID, MAKE_ID('1', '5', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Group,
	End;
}

