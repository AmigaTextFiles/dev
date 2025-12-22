#include "MUI_CPP.include"

void CreateWI_LOD(struct ObjApp *MBObj)
{
	APTR    GP_RT_LOD, obj_aux0, obj_aux1, GR_grp_83, LA_LODInfo, GR_grp_84, GR_grp_122;
	APTR    obj_aux2, obj_aux3, GR_grp_197, GR_grp_123, obj_aux4, obj_aux5, obj_aux6;
	APTR    obj_aux7, obj_aux8, obj_aux9, GR_grp_85;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook LODChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) LODChangeContents, NULL, NULL};

	MBObj->STR_TX_LODNum = NULL;
	MBObj->STR_TX_LODRangeIndex = "0";

	MBObj->STR_DEFLODName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFLODName",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFLODName,
	End;

	LA_LODInfo = Label("Number of children");

	MBObj->TX_LODNum = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_LODNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_83 = GroupObject,
		MUIA_HelpNode, "GR_grp_83",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, LA_LODInfo,
		Child, MBObj->TX_LODNum,
	End;

	MBObj->TX_LODRangeIndex = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_LODRangeIndex,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_LODRangeIndex = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_LODRangeIndex",
		MUIA_Prop_Entries, 1,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 1,
		MUIA_FixHeight, 8,
	End;

	GR_grp_122 = GroupObject,
		MUIA_HelpNode, "GR_grp_122",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_LODRangeIndex,
		Child, MBObj->PR_LODRangeIndex,
	End;

	MBObj->STR_LODRange = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_LODRange",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("range");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_LODRange,
	End;

	MBObj->BT_LODAdd = SimpleButton("Add");

	MBObj->BT_LODDelete = SimpleButton("Delete");

	GR_grp_197 = GroupObject,
		MUIA_HelpNode, "GR_grp_197",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_LODAdd,
		Child, MBObj->BT_LODDelete,
	End;

	MBObj->STR_LODCenterX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_LODCenterX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux5 = Label2("X");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_LODCenterX,
	End;

	MBObj->STR_LODCenterY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_LODCenterY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux7 = Label2("Y");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_LODCenterY,
	End;

	MBObj->STR_LODCenterZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_LODCenterZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux9 = Label2("Z");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_LODCenterZ,
	End;

	GR_grp_123 = GroupObject,
		MUIA_HelpNode, "GR_grp_123",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "center",
		Child, obj_aux4,
		Child, obj_aux6,
		Child, obj_aux8,
	End;

	GR_grp_84 = GroupObject,
		MUIA_HelpNode, "GR_grp_84",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_grp_122,
		Child, obj_aux2,
		Child, GR_grp_197,
		Child, GR_grp_123,
	End;

	MBObj->BT_LODOk = SimpleButton("Ok");

	GR_grp_85 = GroupObject,
		MUIA_HelpNode, "GR_grp_85",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_LODOk,
	End;

	GP_RT_LOD = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_83,
		Child, GR_grp_84,
		Child, GR_grp_85,
	End;

	MBObj->WI_LOD = WindowObject,
		MUIA_Window_Title, "LOD",
		MUIA_Window_ID, MAKE_ID('1', '6', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_LOD,
	End;

}

