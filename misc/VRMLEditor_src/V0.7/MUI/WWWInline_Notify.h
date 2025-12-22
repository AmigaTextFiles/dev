	DoMethod((Object *) MBObj->WI_WWWInline,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_WWWInlineCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_WWWInline,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_WWWInline,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFWWWInlineName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFWWWInlineName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineRead,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineRead,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxSizeX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxSizeX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxSizeY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxSizeY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxSizeZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxSizeZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxCenterX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxCenterY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxCenterZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxCenterZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_WWWInline,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_WWWInlineDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_WWWInline,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_WWWInline,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFWWWInlineName,
		MBObj->STR_WWWInlineName,
		MBObj->BT_WWWInlineRead,
		MBObj->STR_WWWInlineBoxSizeX,
		MBObj->STR_WWWInlineBoxSizeY,
		MBObj->STR_WWWInlineBoxSizeZ,
		MBObj->STR_WWWInlineBoxCenterX,
		MBObj->STR_WWWInlineBoxCenterY,
		MBObj->STR_WWWInlineBoxCenterZ,
		MBObj->BT_WWWInlineOk,
		MBObj->BT_WWWInlineDefault,
		MBObj->BT_WWWInlineCancel,
		0
		);

