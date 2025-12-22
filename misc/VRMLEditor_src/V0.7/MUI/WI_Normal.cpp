#include "MUI_CPP.include"

void CreateWI_Normal(struct ObjApp *MBObj)
{
	APTR    GP_RT_Normal, GR_grp_131, obj_aux0, obj_aux1, GR_grp_127, GR_grp_129;
	APTR    GR_grp_132, obj_aux2, obj_aux3, obj_aux4, obj_aux5, obj_aux6, obj_aux7;
	APTR    GR_grp_130, GR_grp_128;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	static const struct Hook NormalChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) NormalChangeContents, NULL, NULL};
	*/

	MBObj->STR_TX_NormalNum = "0";
	MBObj->STR_TX_NormalIndex = "0";

	MBObj->STR_DEFNormalName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFNormalName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFNormalName,
	End;

	MBObj->TX_NormalNum = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_NormalNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_131 = GroupObject,
		MUIA_HelpNode, "GR_grp_131",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux0,
		Child, MBObj->TX_NormalNum,
	End;

	MBObj->TX_NormalIndex = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_NormalIndex,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_NormalIndex = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_NormalIndex",
		MUIA_Prop_Entries, 1,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 1,
		MUIA_FixHeight, 8,
	End;

	GR_grp_129 = GroupObject,
		MUIA_HelpNode, "GR_grp_129",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_NormalIndex,
		Child, MBObj->PR_NormalIndex,
	End;

	MBObj->STR_NormalX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_NormalX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_NormalX,
	End;

	MBObj->STR_NormalY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_NormalY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_NormalY,
	End;

	MBObj->STR_NormalZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_NormalZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_NormalZ,
	End;

	GR_grp_132 = GroupObject,
		MUIA_HelpNode, "GR_grp_132",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	GR_grp_127 = GroupObject,
		MUIA_HelpNode, "GR_grp_127",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_grp_129,
		Child, GR_grp_132,
	End;

	MBObj->BT_NormalAdd = SimpleButton("Add");

	MBObj->BT_NormalDelete = SimpleButton("Delete");

	GR_grp_130 = GroupObject,
		MUIA_HelpNode, "GR_grp_130",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Actions",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_NormalAdd,
		Child, MBObj->BT_NormalDelete,
	End;

	MBObj->BT_NormalOk = SimpleButton("Ok");

	MBObj->BT_NormalCancel = SimpleButton("Cancel");

	GR_grp_128 = GroupObject,
		MUIA_HelpNode, "GR_grp_128",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_NormalOk,
		Child, MBObj->BT_NormalCancel,
	End;

	GP_RT_Normal = GroupObject,
		Child, GR_grp_131,
		Child, GR_grp_127,
		Child, GR_grp_130,
		Child, GR_grp_128,
	End;

	MBObj->WI_Normal = WindowObject,
		MUIA_Window_Title, "Normal",
		MUIA_Window_ID, MAKE_ID('2', '2', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Normal,
	End;
}

