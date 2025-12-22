#include "MUI_CPP.include"

void CreateWI_Cone(struct ObjApp *MBObj)
{
	APTR    GP_RT_Cone, obj_aux0, obj_aux1, GR_ConeAttributs, obj_aux2, obj_aux3;
	APTR    obj_aux4, obj_aux5, GR_ConeParts, Space_5, GR_grp_199, obj_aux6, obj_aux7;
	APTR    obj_aux8, obj_aux9, Space_6, GR_ConeConfirm;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};


	MBObj->STR_DEFConeName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFConeName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFConeName,
	End;

	MBObj->STR_ConeBottomRadius = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ConeBottomRadius",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux3 = Label2("Bottom radius");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_ConeBottomRadius,
	End;

	MBObj->STR_ConeHeight = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ConeHeight",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "0123456789.",
	End;

	obj_aux5 = Label2("Height");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_ConeHeight,
	End;

	Space_5 = HVSpace;

	MBObj->CH_ConeSides = CheckMark(TRUE);

	obj_aux7 = Label2("Sides");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->CH_ConeSides,
	End;

	MBObj->CH_ConeBottom = CheckMark(TRUE);

	obj_aux9 = Label2("Bottom");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->CH_ConeBottom,
	End;

	GR_grp_199 = GroupObject,
		MUIA_HelpNode, "GR_grp_199",
		Child, obj_aux6,
		Child, obj_aux8,
	End;

	Space_6 = HVSpace;

	GR_ConeParts = GroupObject,
		MUIA_HelpNode, "GR_ConeParts",
		MUIA_Group_Horiz, TRUE,
		Child, Space_5,
		Child, GR_grp_199,
		Child, Space_6,
	End;

	GR_ConeAttributs = GroupObject,
		MUIA_HelpNode, "GR_ConeAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, GR_ConeParts,
	End;

	MBObj->BT_ConeOk = SimpleButton("Ok");

	MBObj->BT_ConeDefault = SimpleButton("Default");

	MBObj->BT_ConeCancel = SimpleButton("Cancel");

	GR_ConeConfirm = GroupObject,
		MUIA_HelpNode, "GR_ConeConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_ConeOk,
		Child, MBObj->BT_ConeDefault,
		Child, MBObj->BT_ConeCancel,
	End;

	GP_RT_Cone = GroupObject,
		Child, obj_aux0,
		Child, GR_ConeAttributs,
		Child, GR_ConeConfirm,
	End;

	MBObj->WI_Cone = WindowObject,
		MUIA_Window_Title, "Cone",
		MUIA_Window_ID, MAKE_ID('1', '1', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Cone,
	End;
}

