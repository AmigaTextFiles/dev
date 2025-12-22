	DoMethod((Object *) MBObj->WI_Info,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_InfoCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Info,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Info,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFInfoName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFInfoName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_InfoString,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_InfoString,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_InfoOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_InfoOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_InfoOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Info,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_InfoCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_InfoCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_InfoCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Info,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Info,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFInfoName,
		MBObj->STR_InfoString,
		MBObj->BT_InfoOk,
		MBObj->BT_InfoCancel,
		0
		);
