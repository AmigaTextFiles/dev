	DoMethod((Object *) MBObj->WI_Texture2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_Texture2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Texture2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTexture2Name,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTexture2Name,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_Texture2WrapS,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_Texture2WrapS,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_Texture2WrapT,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_Texture2WrapT,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2Ok,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Texture2Default,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2Default,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	//--- Personnal add ---
	DoMethod((Object *) MBObj->STR_PA_Texture2,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PA_Texture2,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->WI_Texture2,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTexture2Name,
		MBObj->PA_Texture2,
		MBObj->CY_Texture2WrapS,
		MBObj->CY_Texture2WrapT,
		MBObj->BT_Texture2Ok,
		MBObj->BT_Texture2Default,
		MBObj->BT_Texture2Cancel,
		0
		);
