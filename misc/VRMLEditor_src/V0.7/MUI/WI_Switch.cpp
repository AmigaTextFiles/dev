#include "MUI_CPP.include"

void CreateWI_Switch(struct ObjApp *MBObj)
{
	APTR    GP_RT_Switch, obj_aux0, obj_aux1, GR_Switch, LA_SwitchNum, GR_grp_79C;
	APTR    obj_aux2, obj_aux3, GR_grp_80C;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_TX_SwitchNum = NULL;

	MBObj->STR_DEFSwitchName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFSwitchName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("Switch DEF Name");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFSwitchName,
	End;

	LA_SwitchNum = Label("Number of children");

	MBObj->TX_SwitchNum = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_SwitchNum,
	End;

	GR_Switch = GroupObject,
		MUIA_HelpNode, "GR_Switch",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, LA_SwitchNum,
		Child, MBObj->TX_SwitchNum,
	End;

	MBObj->STR_SwitchWhich = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SwitchWhich",
		MUIA_String_Contents, "-1",
		MUIA_String_Accept, "-0123456789",
	End;

	obj_aux3 = Label2("whichChild");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_SwitchWhich,
	End;

	GR_grp_79C = GroupObject,
		MUIA_HelpNode, "GR_grp_79C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attribut",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux2,
	End;

	MBObj->BT_SwitchOk = SimpleButton("Ok");

	GR_grp_80C = GroupObject,
		MUIA_HelpNode, "GR_grp_80C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_SwitchOk,
	End;

	GP_RT_Switch = GroupObject,
		Child, obj_aux0,
		Child, GR_Switch,
		Child, GR_grp_79C,
		Child, GR_grp_80C,
	End;

	MBObj->WI_Switch = WindowObject,
		MUIA_Window_Title, "Switch",
		MUIA_Window_ID, MAKE_ID('3', '0', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Switch,
	End;

}

