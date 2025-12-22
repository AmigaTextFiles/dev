	DoMethod((Object *) MBObj->WI_DirectionalLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_DirectionalLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_DirectionalLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_DirectionalLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFDirectionalLightName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFDirectionalLightName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_DirectionalLightOn,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_DirectionalLightOn,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightIntensity,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightIntensity,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightR,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightG,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightB,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_DirectionalLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_DirectionalLightOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_DirectionalLightDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_DirectionalLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_DirectionalLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_DirectionalLight,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFDirectionalLightName,
		MBObj->CH_DirectionalLightOn,
		MBObj->STR_DirectionalLightIntensity,
		MBObj->STR_DirectionalLightR,
		MBObj->STR_DirectionalLightG,
		MBObj->STR_DirectionalLightB,
		MBObj->STR_DirectionalLightX,
		MBObj->STR_DirectionalLightY,
		MBObj->STR_DirectionalLightZ,
		MBObj->BT_DirectionalLightOk,
		MBObj->BT_DirectionalLightDefault,
		MBObj->BT_DirectionalLightCancel,
		0
		);
