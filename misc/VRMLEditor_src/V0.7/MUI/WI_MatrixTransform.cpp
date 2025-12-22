#include "MUI_CPP.include"

void CreateWI_MatrixTransform(struct ObjApp *MBObj)
{
	APTR    GP_RT_MatrixTransform, obj_aux0, obj_aux1, GR_grp_125, GR_grp_126;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_DEFMatrixTransformName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFMatrixTransformName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFMatrixTransformName,
	End;

	MBObj->STR_MatrixTransform0 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform0",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform1 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform1",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform2 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform2",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform3 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform3",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform4 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform4",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform5 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform5",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform6 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform6",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform7 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform7",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform8 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform8",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform9 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform9",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform10 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform10",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform11 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform11",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform12 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform12",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform13 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform13",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform14 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform14",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-e",
	End;

	MBObj->STR_MatrixTransform15 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MatrixTransform15",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "0123456789.-e",
	End;

	GR_grp_125 = GroupObject,
		MUIA_HelpNode, "GR_grp_125",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		MUIA_Group_Columns, 4,
		MUIA_Group_HorizSpacing, 0,
		MUIA_Group_VertSpacing, 0,
		Child, MBObj->STR_MatrixTransform0,
		Child, MBObj->STR_MatrixTransform1,
		Child, MBObj->STR_MatrixTransform2,
		Child, MBObj->STR_MatrixTransform3,
		Child, MBObj->STR_MatrixTransform4,
		Child, MBObj->STR_MatrixTransform5,
		Child, MBObj->STR_MatrixTransform6,
		Child, MBObj->STR_MatrixTransform7,
		Child, MBObj->STR_MatrixTransform8,
		Child, MBObj->STR_MatrixTransform9,
		Child, MBObj->STR_MatrixTransform10,
		Child, MBObj->STR_MatrixTransform11,
		Child, MBObj->STR_MatrixTransform12,
		Child, MBObj->STR_MatrixTransform13,
		Child, MBObj->STR_MatrixTransform14,
		Child, MBObj->STR_MatrixTransform15,
	End;

	MBObj->BT_MatrixTransformOk = SimpleButton("Ok");

	MBObj->BT_MatrixTransformDefault = SimpleButton("Default");

	MBObj->BT_MatrixTransformCancel = SimpleButton("Cancel");

	GR_grp_126 = GroupObject,
		MUIA_HelpNode, "GR_grp_126",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MatrixTransformOk,
		Child, MBObj->BT_MatrixTransformDefault,
		Child, MBObj->BT_MatrixTransformCancel,
	End;

	GP_RT_MatrixTransform = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_125,
		Child, GR_grp_126,
	End;

	MBObj->WI_MatrixTransform = WindowObject,
		MUIA_Window_Title, "MatrixTransform",
		MUIA_Window_ID, MAKE_ID('2', '1', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_MatrixTransform,
	End;

}

