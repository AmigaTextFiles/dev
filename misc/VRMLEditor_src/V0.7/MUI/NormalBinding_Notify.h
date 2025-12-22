	DoMethod((Object *) MBObj->WI_NormalBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_NormalBindingCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_NormalBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_NormalBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFNormalBindingName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFNormalBindingName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_NormalBindingValue,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_NormalBindingValue,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_NormalBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_NormalBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalBindingOk,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_NormalBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_NormalBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalBindingCancel,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->WI_NormalBinding,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFNormalBindingName,
		MBObj->CY_NormalBindingValue,
		MBObj->BT_NormalBindingOk,
		MBObj->BT_NormalBindingCancel,
		0
		);

