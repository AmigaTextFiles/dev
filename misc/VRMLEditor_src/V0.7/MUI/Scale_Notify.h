	DoMethod((Object *) MBObj->WI_Scale,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Scale,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Scale,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_ScaleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFScaleName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFScaleName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ScaleX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ScaleX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ScaleY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ScaleY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ScaleZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ScaleZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ScaleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Scale,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ScaleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ScaleOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_ScaleDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ScaleDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_ScaleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Scale,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ScaleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ScaleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Scale,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFScaleName,
		MBObj->STR_ScaleX,
		MBObj->STR_ScaleY,
		MBObj->STR_ScaleZ,
		MBObj->BT_ScaleOk,
		MBObj->BT_ScaleDefault,
		MBObj->BT_ScaleCancel,
		0
		);
