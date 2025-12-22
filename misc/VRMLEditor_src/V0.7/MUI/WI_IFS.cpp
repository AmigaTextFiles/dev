#include "MUI_CPP.include"

void CreateWI_IFS(struct ObjApp *MBObj)
{
	APTR    GP_RT_IndexedFaceSet, GR_IFSNum, obj_aux0, obj_aux1, LA_IFSNum, GR_IFSAttributs;
	APTR    GR_IFSIndex, GR_IFSSlider, GR_IFSFace, GR_IFSIndexes, GR_IFSCoordIndex;
	APTR    GR_IFSCoordIndexActions, obj_aux2, obj_aux3, GR_IFSMaterialIndex;
	APTR    GR_IFSMaterialIndexActions, obj_aux4, obj_aux5, GR_IFSNormalIndex;
	APTR    GR_IFSNormalIndexActions, obj_aux6, obj_aux7, GR_IFSTexIndex, GR_IFSTexIndexActions;
	APTR    obj_aux8, obj_aux9, GR_IFSSelect, GR_grp_237, Space_20, LA_label_58;
	APTR    GR_grp_236, Space_21, Space_22, GR_grp_238, Space_23, Space_24, GR_grp_239;
	APTR    Space_25, Space_26, GR_IFSConfirm;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook IFSChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) IFSChangeContents, NULL, NULL};
	*/

	MBObj->STR_TX_IFSNum = "0";
	MBObj->STR_TX_IFSIndex = "0";

	MBObj->STR_DEFIFSName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFIFSName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFIFSName,
	End;

	LA_IFSNum = Label("Num");

	MBObj->TX_IFSNum = TextObject,
		MUIA_Weight, 30,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_IFSNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_IFSNum = GroupObject,
		MUIA_HelpNode, "GR_IFSNum",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux0,
		Child, LA_IFSNum,
		Child, MBObj->TX_IFSNum,
	End;

	MBObj->TX_IFSIndex = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_IFSIndex,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_IFSIndex = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_IFSIndex",
		MUIA_Prop_Entries, 1,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 1,
		MUIA_FixHeight, 8,
	End;

	GR_IFSSlider = GroupObject,
		MUIA_HelpNode, "GR_IFSSlider",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_IFSIndex,
		Child, MBObj->PR_IFSIndex,
	End;

	MBObj->BT_IFSAddFace = SimpleButton("Add a new face");

	MBObj->BT_IFSDeleteFace = SimpleButton("Delete this face");

	GR_IFSFace = GroupObject,
		MUIA_HelpNode, "GR_IFSFace",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_IFSAddFace,
		Child, MBObj->BT_IFSDeleteFace,
	End;

	MBObj->LV_IFSCoordIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_IFSCoordIndex = ListviewObject,
		MUIA_HelpNode, "LV_IFSCoordIndex",
		MUIA_Listview_List, MBObj->LV_IFSCoordIndex,
	End;

	MBObj->BT_IFSAddPoint = SimpleButton("Add");

	MBObj->BT_IFSDeletePoint = SimpleButton("Delete");

	MBObj->STR_IFSValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_IFSValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux3 = Label2("Value");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_IFSValue,
	End;

	GR_IFSCoordIndexActions = GroupObject,
		MUIA_HelpNode, "GR_IFSCoordIndexActions",
		Child, MBObj->BT_IFSAddPoint,
		Child, MBObj->BT_IFSDeletePoint,
		Child, obj_aux2,
	End;

	GR_IFSCoordIndex = GroupObject,
		MUIA_HelpNode, "GR_IFSCoordIndex",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "coordIndex",
		Child, MBObj->LV_IFSCoordIndex,
		Child, GR_IFSCoordIndexActions,
	End;

	MBObj->LV_IFSMaterialIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_IFSMaterialIndex = ListviewObject,
		MUIA_HelpNode, "LV_IFSMaterialIndex",
		MUIA_Listview_List, MBObj->LV_IFSMaterialIndex,
	End;

	MBObj->BT_IFSAddMat = SimpleButton("Add");

	MBObj->BT_IFSDeleteMat = SimpleButton("Delete");

	MBObj->STR_IFSMatValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_IFSMatValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux5 = Label2("Value");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_IFSMatValue,
	End;

	GR_IFSMaterialIndexActions = GroupObject,
		MUIA_HelpNode, "GR_IFSMaterialIndexActions",
		Child, MBObj->BT_IFSAddMat,
		Child, MBObj->BT_IFSDeleteMat,
		Child, obj_aux4,
	End;

	GR_IFSMaterialIndex = GroupObject,
		MUIA_HelpNode, "GR_IFSMaterialIndex",
		MUIA_Disabled, TRUE,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "materialIndex",
		Child, MBObj->LV_IFSMaterialIndex,
		Child, GR_IFSMaterialIndexActions,
	End;

	MBObj->LV_IFSNormalIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_IFSNormalIndex = ListviewObject,
		MUIA_HelpNode, "LV_IFSNormalIndex",
		MUIA_Listview_List, MBObj->LV_IFSNormalIndex,
	End;

	MBObj->BT_IFSAddNormal = SimpleButton("Add");

	MBObj->BT_IFSDeleteNormal = SimpleButton("Delete");

	MBObj->STR_IFSNormalValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_IFSNormalValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux7 = Label2("Value");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_IFSNormalValue,
	End;

	GR_IFSNormalIndexActions = GroupObject,
		MUIA_HelpNode, "GR_IFSNormalIndexActions",
		Child, MBObj->BT_IFSAddNormal,
		Child, MBObj->BT_IFSDeleteNormal,
		Child, obj_aux6,
	End;

	GR_IFSNormalIndex = GroupObject,
		MUIA_HelpNode, "GR_IFSNormalIndex",
		MUIA_Disabled, TRUE,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "normalIndex",
		Child, MBObj->LV_IFSNormalIndex,
		Child, GR_IFSNormalIndexActions,
	End;

	MBObj->LV_IFSTexIndex = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_IFSTexIndex = ListviewObject,
		MUIA_HelpNode, "LV_IFSTexIndex",
		MUIA_Listview_List, MBObj->LV_IFSTexIndex,
	End;

	MBObj->BT_IFSAddTex = SimpleButton("Add");

	MBObj->BT_IFSDeleteTex = SimpleButton("Delete");

	MBObj->STR_IFSTexValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_IFSTexValue",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789",
	End;

	obj_aux9 = Label2("Value");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_IFSTexValue,
	End;

	GR_IFSTexIndexActions = GroupObject,
		MUIA_HelpNode, "GR_IFSTexIndexActions",
		Child, MBObj->BT_IFSAddTex,
		Child, MBObj->BT_IFSDeleteTex,
		Child, obj_aux8,
	End;

	GR_IFSTexIndex = GroupObject,
		MUIA_HelpNode, "GR_IFSTexIndex",
		MUIA_Disabled, TRUE,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "textureIndex",
		Child, MBObj->LV_IFSTexIndex,
		Child, GR_IFSTexIndexActions,
	End;

	GR_IFSIndexes = GroupObject,
		MUIA_HelpNode, "GR_IFSIndexes",
		MUIA_Group_Horiz, TRUE,
		Child, GR_IFSCoordIndex,
		Child, GR_IFSMaterialIndex,
		Child, GR_IFSNormalIndex,
		Child, GR_IFSTexIndex,
	End;

	Space_20 = HVSpace;

	LA_label_58 = Label("Active index part");

	GR_grp_237 = GroupObject,
		MUIA_HelpNode, "GR_grp_237",
		MUIA_Group_Horiz, TRUE,
		Child, Space_20,
		Child, LA_label_58,
	End;

	Space_21 = HVSpace;

	MBObj->CH_IFSMat = CheckMark(FALSE);

	Space_22 = HVSpace;

	GR_grp_236 = GroupObject,
		MUIA_HelpNode, "GR_grp_236",
		MUIA_Group_Horiz, TRUE,
		Child, Space_21,
		Child, MBObj->CH_IFSMat,
		Child, Space_22,
	End;

	Space_23 = HVSpace;

	MBObj->CH_IFSNormal = CheckMark(FALSE);

	Space_24 = HVSpace;

	GR_grp_238 = GroupObject,
		MUIA_HelpNode, "GR_grp_238",
		MUIA_Group_Horiz, TRUE,
		Child, Space_23,
		Child, MBObj->CH_IFSNormal,
		Child, Space_24,
	End;

	Space_25 = HVSpace;

	MBObj->CH_IFSTex = CheckMark(FALSE);

	Space_26 = HVSpace;

	GR_grp_239 = GroupObject,
		MUIA_HelpNode, "GR_grp_239",
		MUIA_Group_Horiz, TRUE,
		Child, Space_25,
		Child, MBObj->CH_IFSTex,
		Child, Space_26,
	End;

	GR_IFSSelect = GroupObject,
		MUIA_HelpNode, "GR_IFSSelect",
		MUIA_Group_Horiz, TRUE,
		Child, GR_grp_237,
		Child, GR_grp_236,
		Child, GR_grp_238,
		Child, GR_grp_239,
	End;

	GR_IFSIndex = GroupObject,
		MUIA_HelpNode, "GR_IFSIndex",
		Child, GR_IFSSlider,
		Child, GR_IFSFace,
		Child, GR_IFSIndexes,
		Child, GR_IFSSelect,
	End;

	GR_IFSAttributs = GroupObject,
		MUIA_HelpNode, "GR_IFSAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_IFSIndex,
	End;

	MBObj->BT_IFSOk = SimpleButton("Ok");

	MBObj->BT_IFSCancel = SimpleButton("Cancel");

	GR_IFSConfirm = GroupObject,
		MUIA_HelpNode, "GR_IFSConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_IFSOk,
		Child, MBObj->BT_IFSCancel,
	End;

	GP_RT_IndexedFaceSet = GroupObject,
		Child, GR_IFSNum,
		Child, GR_IFSAttributs,
		Child, GR_IFSConfirm,
	End;

	MBObj->WI_IFS = WindowObject,
		MUIA_Window_Title, "IndexedFaceSet",
		MUIA_Window_ID, MAKE_ID('1', '3', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_IndexedFaceSet,
	End;

	DoMethod((Object *) MBObj->CH_IFSMat,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_IFSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_IFSMat,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_IFSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_IFSNormal,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_IFSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_IFSNormal,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_IFSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_IFSTex,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_IFSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_IFSTex,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_IFSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);
}

