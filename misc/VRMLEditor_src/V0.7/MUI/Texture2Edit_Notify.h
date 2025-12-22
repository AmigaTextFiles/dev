	DoMethod((Object *) MBObj->WI_Texture2Edit,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2Edit,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->WI_Texture2Edit,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2Edit,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->SL_Texture2EditX,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_Texture2EditX,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_Texture2EditY,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_Texture2EditY,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2EditValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2EditValue,
		2,
		MUIM_CallHook, &Texture2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->WI_Texture2Edit,
		MUIM_Window_SetCycleChain, MBObj->SL_Texture2EditX,
		MBObj->SL_Texture2EditY,
		MBObj->STR_Texture2EditValue,
		0
		);
