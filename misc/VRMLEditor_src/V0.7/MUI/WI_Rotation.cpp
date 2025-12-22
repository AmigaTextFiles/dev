#include "MUI_CPP.include"

void CreateWI_Rotation(struct ObjApp *MBObj)
{
	APTR    GP_RT_Rotation, obj_aux0, obj_aux1, GR_Rotation, obj_aux2, obj_aux3;
	APTR    obj_aux4, obj_aux5, obj_aux6, obj_aux7, obj_aux8, obj_aux9, GR_RotationConfirm;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/
	MBObj->STR_DEFRotationName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFRotationName",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFRotationName,
	End;

	MBObj->STR_RotationX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_RotationX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_RotationX,
	End;

	MBObj->STR_RotationY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_RotationY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_RotationY,
	End;

	MBObj->STR_RotationZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_RotationZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_RotationZ,
	End;

	MBObj->STR_RotationA = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_RotationA",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux9 = Label2("Angle (DEG)");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_RotationA,
	End;

	GR_Rotation = GroupObject,
		MUIA_HelpNode, "GR_Rotation",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
		Child, obj_aux8,
	End;

	MBObj->BT_RotationOk = SimpleButton("Ok");

	MBObj->BT_RotationDefault = SimpleButton("Default");

	MBObj->BT_RotationCancel = SimpleButton("Cancel");

	GR_RotationConfirm = GroupObject,
		MUIA_HelpNode, "GR_RotationConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_RotationOk,
		Child, MBObj->BT_RotationDefault,
		Child, MBObj->BT_RotationCancel,
	End;

	GP_RT_Rotation = GroupObject,
		Child, obj_aux0,
		Child, GR_Rotation,
		Child, GR_RotationConfirm,
	End;

	MBObj->WI_Rotation = WindowObject,
		MUIA_Window_Title, "Rotation",
		MUIA_Window_ID, MAKE_ID('9', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Rotation,
	End;
}

