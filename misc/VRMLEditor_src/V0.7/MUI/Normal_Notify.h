	DoMethod((Object *) MBObj->WI_Normal,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_NormalCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Normal,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Normal,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFNormalName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFNormalName,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_NormalIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_NormalIndex,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_NormalX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_NormalX,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_NormalY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_NormalY,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_NormalZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_NormalZ,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalAdd,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalDelete,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_NormalOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Normal,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_NormalCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalCancel,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Normal,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Normal,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFNormalName,
		MBObj->PR_NormalIndex,
		MBObj->STR_NormalX,
		MBObj->STR_NormalY,
		MBObj->STR_NormalZ,
		MBObj->BT_NormalAdd,
		MBObj->BT_NormalDelete,
		MBObj->BT_NormalOk,
		MBObj->BT_NormalCancel,
		0
		);

