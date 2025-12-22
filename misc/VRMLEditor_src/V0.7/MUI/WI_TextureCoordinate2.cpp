#include "MUI_CPP.include"

void CreateWI_TextureCoordinate2(struct ObjApp *MBObj)
{
	APTR    GP_RT_TextureCoordinate2, GR_grp_131C, obj_aux0, obj_aux1, GR_grp_127C;
	APTR    GR_grp_129C, GR_grp_132C, obj_aux2, obj_aux3, obj_aux4, obj_aux5;
	APTR    GR_grp_130C, GR_grp_181;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook TextureCoordinate2ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) TextureCoordinate2ChangeContents, NULL, NULL};
	*/

	MBObj->STR_TX_TextureCoordinate2Num = "0";
	MBObj->STR_TX_TextureCoordinate2Index = "0";

	MBObj->STR_DEFTextureCoordinate2Name = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFTextureCoordinate2Name",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFTextureCoordinate2Name,
	End;

	MBObj->TX_TextureCoordinate2Num = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_TextureCoordinate2Num,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_131C = GroupObject,
		MUIA_HelpNode, "GR_grp_131C",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux0,
		Child, MBObj->TX_TextureCoordinate2Num,
	End;

	MBObj->TX_TextureCoordinate2Index = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_TextureCoordinate2Index,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_TextureCoordinate2Index = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_TextureCoordinate2Index",
		MUIA_Prop_Entries, 1,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 1,
		MUIA_FixHeight, 8,
	End;

	GR_grp_129C = GroupObject,
		MUIA_HelpNode, "GR_grp_129C",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_TextureCoordinate2Index,
		Child, MBObj->PR_TextureCoordinate2Index,
	End;

	MBObj->STR_TextureCoordinate2X = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TextureCoordinate2X",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_TextureCoordinate2X,
	End;

	MBObj->STR_TextureCoordinate2Y = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TextureCoordinate2Y",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_TextureCoordinate2Y,
	End;

	GR_grp_132C = GroupObject,
		MUIA_HelpNode, "GR_grp_132C",
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	GR_grp_127C = GroupObject,
		MUIA_HelpNode, "GR_grp_127C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_grp_129C,
		Child, GR_grp_132C,
	End;

	MBObj->BT_TextureCoordinate2Add = SimpleButton("Add");

	MBObj->BT_TextureCoordinate2Delete = SimpleButton("Delete");

	GR_grp_130C = GroupObject,
		MUIA_HelpNode, "GR_grp_130C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Actions",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_TextureCoordinate2Add,
		Child, MBObj->BT_TextureCoordinate2Delete,
	End;

	MBObj->BT_TextureCoordinate2Ok = SimpleButton("Ok");

	MBObj->BT_TextureCoordinate2Cancel = SimpleButton("Cancel");

	GR_grp_181 = GroupObject,
		MUIA_HelpNode, "GR_grp_181",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_TextureCoordinate2Ok,
		Child, MBObj->BT_TextureCoordinate2Cancel,
	End;

	GP_RT_TextureCoordinate2 = GroupObject,
		Child, GR_grp_131C,
		Child, GR_grp_127C,
		Child, GR_grp_130C,
		Child, GR_grp_181,
	End;

	MBObj->WI_TextureCoordinate2 = WindowObject,
		MUIA_Window_Title, "TextureCoordinate2",
		MUIA_Window_ID, MAKE_ID('3', '3', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_TextureCoordinate2,
	End;

}

