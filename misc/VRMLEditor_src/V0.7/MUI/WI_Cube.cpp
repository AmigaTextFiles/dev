#include "MUI_CPP.include"

void CreateWI_Cube(struct ObjApp *MBObj)
{
	APTR    GP_RT_Cube, obj_aux0, obj_aux1, GR_CubeAttr, obj_aux2, obj_aux3, obj_aux4;
	APTR    obj_aux5, obj_aux6, obj_aux7, GR_CubeConfirm;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_DEFCubeName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFCubeName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFCubeName,
	End;

	MBObj->STR_CubeWidth = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CubeWidth",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux3 = Label2("Width (X)");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_CubeWidth,
	End;

	MBObj->STR_CubeHeight = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CubeHeight",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux5 = Label2("Height (Y)");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_CubeHeight,
	End;

	MBObj->STR_CubeDepth = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_CubeDepth",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux7 = Label2("Depth (Z)");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_CubeDepth,
	End;

	GR_CubeAttr = GroupObject,
		MUIA_HelpNode, "GR_CubeAttr",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->BT_CubeOk = SimpleButton("Ok");

	MBObj->BT_CubeDefault = SimpleButton("Default");

	MBObj->BT_CubeCancel = SimpleButton("Cancel");

	GR_CubeConfirm = GroupObject,
		MUIA_HelpNode, "GR_CubeConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_CubeOk,
		Child, MBObj->BT_CubeDefault,
		Child, MBObj->BT_CubeCancel,
	End;

	GP_RT_Cube = GroupObject,
		Child, obj_aux0,
		Child, GR_CubeAttr,
		Child, GR_CubeConfirm,
	End;

	MBObj->WI_Cube = WindowObject,
		MUIA_Window_Title, "Cube",
		MUIA_Window_ID, MAKE_ID('1', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Cube,
	End;

}

