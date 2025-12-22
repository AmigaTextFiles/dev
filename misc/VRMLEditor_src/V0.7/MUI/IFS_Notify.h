	DoMethod((Object *) MBObj->WI_IFS,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_IFSCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_IFS,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_IFS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFIFSName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFIFSName,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_IFSIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_IFSIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddFace,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddFace,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteFace,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteFace,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSCoordIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSCoordIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddPoint,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddPoint,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeletePoint,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeletePoint,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSMaterialIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSMaterialIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddMat,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddMat,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteMat,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteMat,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSMatValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSMatValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSNormalIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSNormalIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddNormal,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddNormal,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteNormal,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteNormal,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSNormalValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSNormalValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSTexIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSTexIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddTex,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddTex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteTex,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteTex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSTexValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSTexValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	/*
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
	*/
	DoMethod((Object *) MBObj->BT_IFSOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_IFSOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_IFS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_IFSCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_IFSCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_IFS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_IFS,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFIFSName,
		MBObj->PR_IFSIndex,
		MBObj->BT_IFSAddFace,
		MBObj->BT_IFSDeleteFace,
		MBObj->LV_IFSCoordIndex,
		MBObj->BT_IFSAddPoint,
		MBObj->BT_IFSDeletePoint,
		MBObj->STR_IFSValue,
		MBObj->LV_IFSMaterialIndex,
		MBObj->BT_IFSAddMat,
		MBObj->BT_IFSDeleteMat,
		MBObj->STR_IFSMatValue,
		MBObj->LV_IFSNormalIndex,
		MBObj->BT_IFSAddNormal,
		MBObj->BT_IFSDeleteNormal,
		MBObj->STR_IFSNormalValue,
		MBObj->LV_IFSTexIndex,
		MBObj->BT_IFSAddTex,
		MBObj->BT_IFSDeleteTex,
		MBObj->STR_IFSTexValue,
		MBObj->CH_IFSMat,
		MBObj->CH_IFSNormal,
		MBObj->CH_IFSTex,
		MBObj->BT_IFSOk,
		MBObj->BT_IFSCancel,
		0
		);

