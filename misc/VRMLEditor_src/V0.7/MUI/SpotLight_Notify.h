	DoMethod((Object *) MBObj->WI_SpotLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_SpotLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_SpotLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_SpotLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFSpotLightName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFSpotLightName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_SpotLightOn,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SpotLightOn,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightIntensity,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightIntensity,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightR,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightG,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightB,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDirX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDirX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDirY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDirY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDirZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDirZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDrop,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDrop,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightCut,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightCut,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SpotLightOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_SpotLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_SpotLightDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SpotLightDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SpotLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_SpotLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_SpotLight,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFSpotLightName,
		MBObj->CH_SpotLightOn,
		MBObj->STR_SpotLightIntensity,
		MBObj->STR_SpotLightR,
		MBObj->STR_SpotLightG,
		MBObj->STR_SpotLightB,
		MBObj->STR_SpotLightX,
		MBObj->STR_SpotLightY,
		MBObj->STR_SpotLightZ,
		MBObj->STR_SpotLightDirX,
		MBObj->STR_SpotLightDirY,
		MBObj->STR_SpotLightDirZ,
		MBObj->STR_SpotLightDrop,
		MBObj->STR_SpotLightCut,
		MBObj->BT_SpotLightOk,
		MBObj->BT_SpotLightDefault,
		MBObj->BT_SpotLightCancel,
		0
		);

