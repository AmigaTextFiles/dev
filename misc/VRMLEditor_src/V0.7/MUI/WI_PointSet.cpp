#include "MUI_CPP.include"

void CreateWI_PointSet(struct ObjApp *MBObj)
{
	APTR    GP_RT_PointSet, obj_aux0, obj_aux1, GR_grp_166, obj_aux2, obj_aux3;
	APTR    obj_aux4, obj_aux5, GR_grp_167;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->STR_DEFPointSetName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFPointSetName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFPointSetName,
	End;

	MBObj->STR_PointSetStartIndex = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointSetStartIndex",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789-",
	End;

	obj_aux3 = Label2("startIndex");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_PointSetStartIndex,
	End;

	MBObj->STR_PointSetNumPoints = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_PointSetNumPoints",
		MUIA_String_Contents, "-1",
		MUIA_String_Accept, "-0123456789",
	End;

	obj_aux5 = Label2("numPoints");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_PointSetNumPoints,
	End;

	GR_grp_166 = GroupObject,
		MUIA_HelpNode, "GR_grp_166",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	MBObj->BT_PointSetOk = SimpleButton("Ok");

	MBObj->BT_PointSetDefault = SimpleButton("Default");

	MBObj->BT_PointSetCancel = SimpleButton("Cancel");

	GR_grp_167 = GroupObject,
		MUIA_HelpNode, "GR_grp_167",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_PointSetOk,
		Child, MBObj->BT_PointSetDefault,
		Child, MBObj->BT_PointSetCancel,
	End;

	GP_RT_PointSet = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_166,
		Child, GR_grp_167,
	End;

	MBObj->WI_PointSet = WindowObject,
		MUIA_Window_Title, "PointSet",
		MUIA_Window_ID, MAKE_ID('2', '7', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_PointSet,
	End;

}

