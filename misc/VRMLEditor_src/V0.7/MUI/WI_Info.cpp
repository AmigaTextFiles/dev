#include "MUI_CPP.include"

void CreateWI_Info(struct ObjApp *MBObj)
{
	APTR    GP_RT_info, obj_aux0, obj_aux1, GR_grp_120, obj_aux2, obj_aux3, GR_grp_121;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->STR_DEFInfoName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFInfoName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFInfoName,
	End;

	MBObj->STR_InfoString = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_InfoString",
		MUIA_String_Contents, "Undefined info",
		MUIA_String_MaxLen, 1000,
	End;

	obj_aux3 = Label2("string");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_InfoString,
	End;

	GR_grp_120 = GroupObject,
		MUIA_HelpNode, "GR_grp_120",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
	End;

	MBObj->BT_InfoOk = SimpleButton("Ok");

	MBObj->BT_InfoCancel = SimpleButton("Cancel");

	GR_grp_121 = GroupObject,
		MUIA_HelpNode, "GR_grp_121",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_InfoOk,
		Child, MBObj->BT_InfoCancel,
	End;

	GP_RT_info = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_120,
		Child, GR_grp_121,
	End;

	MBObj->WI_Info = WindowObject,
		MUIA_Window_Title, "Info",
		MUIA_Window_ID, MAKE_ID('2', '0', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_info,
	End;

}

