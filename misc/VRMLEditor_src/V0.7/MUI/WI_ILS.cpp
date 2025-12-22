#include "MUI_CPP.include"

void CreateWI_ILS(struct ObjApp *MBObj)
{
	APTR    GP_RT_ILS, GR_ILSNum, obj_aux0, obj_aux1, LA_ILSNum, GR_ILSAttributs;
	APTR    GR_ILSIndex, GR_ILSSlider, GR_ILSLine, GR_ILSIndexes, GR_ILSCoordIndex;
	APTR    GR_ILSCoordIndexActions, obj_aux2, obj_aux3, GR_ILSMaterialIndex;
	APTR    GR_ILSMaterialIndexActions, obj_aux4, obj_aux5, GR_ILSNormalIndex;
	APTR    GR_ILSNormalIndexActions, obj_aux6, obj_aux7, GR_ILSTexIndex, GR_ILSTexIndexActions;
	APTR    obj_aux8, obj_aux9, GR_ILSSelect, GR_grp_237C, Space_20C, LA_label_58C;
	APTR    GR_grp_236C, Space_21C, Space_22C, GR_grp_238C, Space_23C, Space_24C;
	APTR    GR_grp_239C, Space_25C, Space_26C, GR_ILSConfirm;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook ILSChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ILSChangeContents, NULL, NULL};


	MBObj->STR_TX_ILSNum = "0";
	MBObj->STR_TX_ILSIndex = "0";

	MBObj->STR_DEFILSName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFILSName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFILSName,
	End;

	LA_ILSNum = Label("Num");

	MBObj->TX_ILSNum = TextObject,
		MUIA_Weight, 30,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_ILSNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_ILSNum = GroupObject,
		MUIA_HelpNode, "GR_ILSNum",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux0,
		Child, LA_ILSNum,
		Child, MBObj->TX_ILSNum,
	End;

	MBObj->TX_ILSIndex = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_ILSIndex,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_ILSIndex = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_ILSIndex",
		MUIA_Prop_Entries, 1,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 1,
		MUIA_FixHeight, 8,
	End;

	GR_ILSSlider = GroupObject,
		MUIA_HelpNode, "GR_ILSSlider",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_ILSIndex,
		Child, MBObj->PR_ILSIndex,
	End;

	MBObj->BT_ILSAddLine = SimpleButton("Add a new line");

	MBObj->BT_ILSDeleteLine = SimpleButton("Delete this line");

	GR_ILSLine = GroupObject,
		MUIA_HelpNode, "GR_ILSLine",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_ILSAddLine,
		Child, MBObj->BT_ILSDeleteLine,
	End;

	MBObj->LV_ILSCoordIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_ILSCoordIndex = ListviewObject,
		MUIA_HelpNode, "LV_ILSCoordIndex",
		MUIA_Listview_List, MBObj->LV_ILSCoordIndex,
	End;

	MBObj->BT_ILSAddPoint = SimpleButton("Add");

	MBObj->BT_ILSDeletePoint = SimpleButton("Delete");

	MBObj->STR_ILSValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ILSValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux3 = Label2("Value");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_ILSValue,
	End;

	GR_ILSCoordIndexActions = GroupObject,
		MUIA_HelpNode, "GR_ILSCoordIndexActions",
		Child, MBObj->BT_ILSAddPoint,
		Child, MBObj->BT_ILSDeletePoint,
		Child, obj_aux2,
	End;

	GR_ILSCoordIndex = GroupObject,
		MUIA_HelpNode, "GR_ILSCoordIndex",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "coordIndex",
		Child, MBObj->LV_ILSCoordIndex,
		Child, GR_ILSCoordIndexActions,
	End;

	MBObj->LV_ILSMaterialIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_ILSMaterialIndex = ListviewObject,
		MUIA_HelpNode, "LV_ILSMaterialIndex",
		MUIA_Listview_List, MBObj->LV_ILSMaterialIndex,
	End;

	MBObj->BT_ILSAddMat = SimpleButton("Add");

	MBObj->BT_ILSDeleteMat = SimpleButton("Delete");

	MBObj->STR_ILSMatValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ILSMatValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux5 = Label2("Value");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_ILSMatValue,
	End;

	GR_ILSMaterialIndexActions = GroupObject,
		MUIA_HelpNode, "GR_ILSMaterialIndexActions",
		Child, MBObj->BT_ILSAddMat,
		Child, MBObj->BT_ILSDeleteMat,
		Child, obj_aux4,
	End;

	GR_ILSMaterialIndex = GroupObject,
		MUIA_HelpNode, "GR_ILSMaterialIndex",
		MUIA_Disabled, TRUE,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "materialIndex",
		Child, MBObj->LV_ILSMaterialIndex,
		Child, GR_ILSMaterialIndexActions,
	End;

	MBObj->LV_ILSNormalIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_ILSNormalIndex = ListviewObject,
		MUIA_HelpNode, "LV_ILSNormalIndex",
		MUIA_Listview_List, MBObj->LV_ILSNormalIndex,
	End;

	MBObj->BT_ILSAddNormal = SimpleButton("Add");

	MBObj->BT_ILSDeleteNormal = SimpleButton("Delete");

	MBObj->STR_ILSNormalValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ILSNormalValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux7 = Label2("Value");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_ILSNormalValue,
	End;

	GR_ILSNormalIndexActions = GroupObject,
		MUIA_HelpNode, "GR_ILSNormalIndexActions",
		Child, MBObj->BT_ILSAddNormal,
		Child, MBObj->BT_ILSDeleteNormal,
		Child, obj_aux6,
	End;

	GR_ILSNormalIndex = GroupObject,
		MUIA_HelpNode, "GR_ILSNormalIndex",
		MUIA_Disabled, TRUE,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "normalIndex",
		Child, MBObj->LV_ILSNormalIndex,
		Child, GR_ILSNormalIndexActions,
	End;

	MBObj->LV_ILSTexIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_ILSTexIndex = ListviewObject,
		MUIA_HelpNode, "LV_ILSTexIndex",
		MUIA_Listview_List, MBObj->LV_ILSTexIndex,
	End;

	MBObj->BT_ILSAddTex = SimpleButton("Add");

	MBObj->BT_ILSDeleteTex = SimpleButton("Delete");

	MBObj->STR_ILSTexValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ILSTexValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux9 = Label2("Value");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_ILSTexValue,
	End;

	GR_ILSTexIndexActions = GroupObject,
		MUIA_HelpNode, "GR_ILSTexIndexActions",
		Child, MBObj->BT_ILSAddTex,
		Child, MBObj->BT_ILSDeleteTex,
		Child, obj_aux8,
	End;

	GR_ILSTexIndex = GroupObject,
		MUIA_HelpNode, "GR_ILSTexIndex",
		MUIA_Disabled, TRUE,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "textureIndex",
		Child, MBObj->LV_ILSTexIndex,
		Child, GR_ILSTexIndexActions,
	End;

	GR_ILSIndexes = GroupObject,
		MUIA_HelpNode, "GR_ILSIndexes",
		MUIA_Group_Horiz, TRUE,
		Child, GR_ILSCoordIndex,
		Child, GR_ILSMaterialIndex,
		Child, GR_ILSNormalIndex,
		Child, GR_ILSTexIndex,
	End;

	Space_20C = HVSpace;

	LA_label_58C = Label("Active index part");

	GR_grp_237C = GroupObject,
		MUIA_HelpNode, "GR_grp_237C",
		MUIA_Group_Horiz, TRUE,
		Child, Space_20C,
		Child, LA_label_58C,
	End;

	Space_21C = HVSpace;

	MBObj->CH_ILSMat = CheckMark(FALSE);

	Space_22C = HVSpace;

	GR_grp_236C = GroupObject,
		MUIA_HelpNode, "GR_grp_236C",
		MUIA_Group_Horiz, TRUE,
		Child, Space_21C,
		Child, MBObj->CH_ILSMat,
		Child, Space_22C,
	End;

	Space_23C = HVSpace;

	MBObj->CH_ILSNormal = CheckMark(FALSE);

	Space_24C = HVSpace;

	GR_grp_238C = GroupObject,
		MUIA_HelpNode, "GR_grp_238C",
		MUIA_Group_Horiz, TRUE,
		Child, Space_23C,
		Child, MBObj->CH_ILSNormal,
		Child, Space_24C,
	End;

	Space_25C = HVSpace;

	MBObj->CH_ILSTex = CheckMark(FALSE);

	Space_26C = HVSpace;

	GR_grp_239C = GroupObject,
		MUIA_HelpNode, "GR_grp_239C",
		MUIA_Group_Horiz, TRUE,
		Child, Space_25C,
		Child, MBObj->CH_ILSTex,
		Child, Space_26C,
	End;

	GR_ILSSelect = GroupObject,
		MUIA_HelpNode, "GR_ILSSelect",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_237C,
		Child, GR_grp_236C,
		Child, GR_grp_238C,
		Child, GR_grp_239C,
	End;

	GR_ILSIndex = GroupObject,
		MUIA_HelpNode, "GR_ILSIndex",
		Child, GR_ILSSlider,
		Child, GR_ILSLine,
		Child, GR_ILSIndexes,
		Child, GR_ILSSelect,
	End;

	GR_ILSAttributs = GroupObject,
		MUIA_HelpNode, "GR_ILSAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_ILSIndex,
	End;

	MBObj->BT_ILSOk = SimpleButton("Ok");

	MBObj->BT_ILSCancel = SimpleButton("Cancel");

	GR_ILSConfirm = GroupObject,
		MUIA_HelpNode, "GR_ILSConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_ILSOk,
		Child, MBObj->BT_ILSCancel,
	End;

	GP_RT_ILS = GroupObject,
		Child, GR_ILSNum,
		Child, GR_ILSAttributs,
		Child, GR_ILSConfirm,
	End;

	MBObj->WI_ILS = WindowObject,
		MUIA_Window_Title, "IndexedLineSet",
		MUIA_Window_ID, MAKE_ID('3', '6', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_ILS,
	End;

	DoMethod((Object *) MBObj->CH_ILSMat,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_ILSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_ILSMat,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_ILSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_ILSNormal,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_ILSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_ILSNormal,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_ILSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_ILSTex,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_ILSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_ILSTex,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_ILSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);
}

