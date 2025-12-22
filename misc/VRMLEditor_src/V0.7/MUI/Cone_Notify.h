	DoMethod((Object *) MBObj->WI_Cone,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Cone,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Cone,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_ConeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFConeName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFConeName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ConeBottomRadius,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ConeBottomRadius,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ConeHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ConeHeight,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_ConeSides,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_ConeSides,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_ConeBottom,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_ConeBottom,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ConeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cone,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ConeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ConeCancel,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_ConeDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ConeDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_ConeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cone,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ConeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ConeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Cone,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFConeName,
		MBObj->STR_ConeBottomRadius,
		MBObj->STR_ConeHeight,
		MBObj->CH_ConeSides,
		MBObj->CH_ConeBottom,
		MBObj->BT_ConeOk,
		MBObj->BT_ConeDefault,
		MBObj->BT_ConeCancel,
		0
		);
