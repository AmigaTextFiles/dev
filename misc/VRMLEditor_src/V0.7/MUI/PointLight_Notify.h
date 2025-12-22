	DoMethod((Object *) MBObj->WI_PointLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PointLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_PointLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_PointLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFPointLightName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFPointLightName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_PointLightOn,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_PointLightOn,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightIntensity,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightIntensity,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightR,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightG,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightB,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PointLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointLightOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PointLightDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointLightDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_PointLight,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFPointLightName,
		MBObj->CH_PointLightOn,
		MBObj->STR_PointLightIntensity,
		MBObj->STR_PointLightX,
		MBObj->STR_PointLightY,
		MBObj->STR_PointLightZ,
		MBObj->STR_PointLightR,
		MBObj->STR_PointLightG,
		MBObj->STR_PointLightB,
		MBObj->BT_PointLightOk,
		MBObj->BT_PointLightDefault,
		MBObj->BT_PointLightCancel,
		0
		);
