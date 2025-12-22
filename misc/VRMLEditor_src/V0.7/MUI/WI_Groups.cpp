#include "MUI_CPP.include"

void CreateWI_Groups(struct ObjApp *MBObj)
{

	APTR    GP_RT_Group, obj_aux0, obj_aux1, GR_grp_81, LA_label_21, GR_grp_122;
	APTR    obj_aux2, obj_aux3, GR_grp_197, GR_grp_123, obj_aux4, obj_aux5, obj_aux6;
	APTR    obj_aux7, obj_aux8, obj_aux9, LA_label_20, obj_aux10, obj_aux11, obj_aux12;
	APTR    obj_aux13, obj_aux14, obj_aux15, GR_grp_185, LA_label_52, GR_grp_82;
	// static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	// static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	// static const struct Hook LODChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) LODChangeContents, NULL, NULL};
	// static const struct Hook GroupsChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) GroupsChangeContents, NULL, NULL};


	MBObj->STR_TX_GroupsNum = NULL;
	MBObj->STR_TX_LODRangeIndex = "0";

	MBObj->CY_SeparatorRenderCullingContent[0] = "AUTO";
	MBObj->CY_SeparatorRenderCullingContent[1] = "ON";
	MBObj->CY_SeparatorRenderCullingContent[2] = "OFF";
	MBObj->CY_SeparatorRenderCullingContent[3] = NULL;
	MBObj->CY_WWWAnchorMapContent[0] = "NONE";
	MBObj->CY_WWWAnchorMapContent[1] = "POINT";
	MBObj->CY_WWWAnchorMapContent[2] = NULL;

	MBObj->STR_DEFGroupsName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFGroupsName",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFGroupsName,
	End;

	MBObj->TX_GroupsType = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, "",
		MUIA_Text_SetMin, TRUE,
	End;

	LA_label_21 = Label("Number of children");

	MBObj->TX_GroupsNum = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_GroupsNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_81 = GroupObject,
		MUIA_HelpNode, "GR_grp_81",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_GroupsType,
		Child, LA_label_21,
		Child, MBObj->TX_GroupsNum,
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

	MBObj->GR_GroupsLOD = GroupObject,
		MUIA_HelpNode, "GR_GroupsLOD",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		MUIA_ShowMe, FALSE,
		Child, GR_grp_122,
		Child, obj_aux2,
		Child, GR_grp_197,
		Child, GR_grp_123,
	End;

	LA_label_20 = Label("renderCulling");

	MBObj->CY_SeparatorRenderCulling = CycleObject,
		MUIA_HelpNode, "CY_SeparatorRenderCulling",
		MUIA_Cycle_Entries, MBObj->CY_SeparatorRenderCullingContent,
	End;

	MBObj->GR_GroupsSeparator = GroupObject,
		MUIA_HelpNode, "GR_GroupsSeparator",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attribut",
		MUIA_Group_Horiz, TRUE,
		MUIA_ShowMe, FALSE,
		Child, LA_label_20,
		Child, MBObj->CY_SeparatorRenderCulling,
	End;

	MBObj->STR_SwitchWhich = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SwitchWhich",
		MUIA_String_Contents, "-1",
		MUIA_String_Accept, "-0123456789",
	End;

	obj_aux11 = Label2("whichChild");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_SwitchWhich,
	End;

	MBObj->GR_GroupsSwitch = GroupObject,
		MUIA_HelpNode, "GR_GroupsSwitch",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attribut",
		MUIA_Group_Horiz, TRUE,
		MUIA_ShowMe, FALSE,
		Child, obj_aux10,
	End;

	MBObj->STR_WWWAnchorName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWAnchorName",
	End;

	obj_aux13 = Label2("Name");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_WWWAnchorName,
	End;

	MBObj->STR_WWWAnchorDescription = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWAnchorDescription",
	End;

	obj_aux15 = Label2("description");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_WWWAnchorDescription,
	End;

	LA_label_52 = Label("map");

	MBObj->CY_WWWAnchorMap = CycleObject,
		MUIA_HelpNode, "CY_WWWAnchorMap",
		MUIA_Cycle_Entries, MBObj->CY_WWWAnchorMapContent,
	End;

	GR_grp_185 = GroupObject,
		MUIA_HelpNode, "GR_grp_185",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_52,
		Child, MBObj->CY_WWWAnchorMap,
	End;

	MBObj->GR_GroupsWWWAnchor = GroupObject,
		MUIA_HelpNode, "GR_GroupsWWWAnchor",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		MUIA_ShowMe, FALSE,
		Child, obj_aux12,
		Child, obj_aux14,
		Child, GR_grp_185,
	End;

	MBObj->BT_GroupsOk = SimpleButton("Ok");

	GR_grp_82 = GroupObject,
		MUIA_HelpNode, "GR_grp_82",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_GroupsOk,
	End;

	GP_RT_Group = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_81,
		Child, MBObj->GR_GroupsLOD,
		Child, MBObj->GR_GroupsSeparator,
		Child, MBObj->GR_GroupsSwitch,
		Child, MBObj->GR_GroupsWWWAnchor,
		Child, GR_grp_82,
	End;

	MBObj->WI_Groups = WindowObject,
		MUIA_Window_Title, "Grouping nodes",
		MUIA_Window_ID, MAKE_ID('1', '4', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Group,
	End;
}

