#include "MUI_CPP.include"

void CreateWI_Cylinder(struct ObjApp *MBObj)
{
	APTR    GP_RT_Cylinder, obj_aux0, obj_aux1, GR_CylinderAttributs, obj_aux2;
	APTR    obj_aux3, obj_aux4, obj_aux5, GR_Parts, Space_3, GR_grp_198, obj_aux6;
	APTR    obj_aux7, obj_aux8, obj_aux9, obj_aux10, obj_aux11, Space_4, GR_CylinderConfirm;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};


	MBObj->STR_DEFCylinderName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFCylinderName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFCylinderName,
	End;

	MBObj->STR_CylinderRadius = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CylinderRadius",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.e",
	End;

	obj_aux3 = Label2("Bottom radius");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_CylinderRadius,
	End;

	MBObj->STR_CylinderHeight = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CylinderHeight",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "0123456789.e",
	End;

	obj_aux5 = Label2("Height");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_CylinderHeight,
	End;

	Space_3 = HVSpace;

	MBObj->CH_CylinderSides = CheckMark(TRUE);

	obj_aux7 = Label2("Sides ");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->CH_CylinderSides,
	End;

	MBObj->CH_CylinderTop = CheckMark(TRUE);

	obj_aux9 = Label2("Top  ");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->CH_CylinderTop,
	End;

	MBObj->CH_CylinderBottom = CheckMark(TRUE);

	obj_aux11 = Label2("Bottom");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->CH_CylinderBottom,
	End;

	GR_grp_198 = GroupObject,
		MUIA_HelpNode, "GR_grp_198",
		Child, obj_aux6,
		Child, obj_aux8,
		Child, obj_aux10,
	End;

	Space_4 = HVSpace;

	GR_Parts = GroupObject,
		MUIA_HelpNode, "GR_Parts",
		MUIA_Group_Horiz, TRUE,
		Child, Space_3,
		Child, GR_grp_198,
		Child, Space_4,
	End;

	GR_CylinderAttributs = GroupObject,
		MUIA_HelpNode, "GR_CylinderAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, GR_Parts,
	End;

	MBObj->BT_CylinderOk = SimpleButton("Ok");

	MBObj->BT_CylinderDefault = SimpleButton("Default");

	MBObj->BT_CylinderCancel = SimpleButton("Cancel");

	GR_CylinderConfirm = GroupObject,
		MUIA_HelpNode, "GR_CylinderConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_CylinderOk,
		Child, MBObj->BT_CylinderDefault,
		Child, MBObj->BT_CylinderCancel,
	End;

	GP_RT_Cylinder = GroupObject,
		Child, obj_aux0,
		Child, GR_CylinderAttributs,
		Child, GR_CylinderConfirm,
	End;

	MBObj->WI_Cylinder = WindowObject,
		MUIA_Window_Title, "Cylinder",
		MUIA_Window_ID, MAKE_ID('6', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Cylinder,
	End;

}

