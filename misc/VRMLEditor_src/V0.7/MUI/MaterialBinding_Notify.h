	DoMethod((Object *) MBObj->WI_MaterialBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_MaterialBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_MaterialBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_MaterialBindingCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFMaterialBindingName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFMaterialBindingName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_MaterialBinding,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_MaterialBinding,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MaterialBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialBindingOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MaterialBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialBindingCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_MaterialBinding,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFMaterialBindingName,
		MBObj->CY_MaterialBinding,
		MBObj->BT_MaterialBindingOk,
		MBObj->BT_MaterialBindingCancel,
		0
		);
