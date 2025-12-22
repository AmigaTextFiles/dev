	DoMethod((Object *) MBObj->WI_Translation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Translation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Translation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_TranslationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFTranslationName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTranslationName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TranslationX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TranslationX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TranslationY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TranslationY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TranslationZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TranslationZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TranslationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Translation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TranslationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TranslationOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_TranslationDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TranslationDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_TranslationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Translation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TranslationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TranslationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Translation,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTranslationName,
		MBObj->STR_TranslationX,
		MBObj->STR_TranslationY,
		MBObj->STR_TranslationZ,
		MBObj->BT_TranslationOk,
		MBObj->BT_TranslationDefault,
		MBObj->BT_TranslationCancel,
		0
		);
