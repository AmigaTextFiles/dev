#include "MUI_CPP.include"

void CreateWI_Scale(struct ObjApp *MBObj)
{
	APTR    GP_RT_Scale, obj_aux0, obj_aux1, GR_ScaleAttributs, obj_aux2, obj_aux3;
	APTR    obj_aux4, obj_aux5, obj_aux6, obj_aux7, GR_ScaleConfirm;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/
	MBObj->STR_DEFScaleName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFScaleName",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFScaleName,
	End;

	MBObj->STR_ScaleX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ScaleX",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_ScaleX,
	End;

	MBObj->STR_ScaleY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ScaleY",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_ScaleY,
	End;

	MBObj->STR_ScaleZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ScaleZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_ScaleZ,
	End;

	GR_ScaleAttributs = GroupObject,
		MUIA_HelpNode, "GR_ScaleAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->BT_ScaleOk = SimpleButton("Ok");

	MBObj->BT_ScaleDefault = SimpleButton("Default");

	MBObj->BT_ScaleCancel = SimpleButton("Cancel");

	GR_ScaleConfirm = GroupObject,
		MUIA_HelpNode, "GR_ScaleConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_ScaleOk,
		Child, MBObj->BT_ScaleDefault,
		Child, MBObj->BT_ScaleCancel,
	End;

	GP_RT_Scale = GroupObject,
		Child, obj_aux0,
		Child, GR_ScaleAttributs,
		Child, GR_ScaleConfirm,
	End;

	MBObj->WI_Scale = WindowObject,
		MUIA_Window_Title, "Scale",
		MUIA_Window_ID, MAKE_ID('1', '0', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Scale,
	End;

}

