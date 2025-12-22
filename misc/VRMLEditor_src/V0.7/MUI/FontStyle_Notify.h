	DoMethod((Object *) MBObj->WI_FontStyle,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_FontStyleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_FontStyle,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_FontStyle,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFFontStyleName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFFontStyleName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_FontStyleSize,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_FontStyleSize,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_FontStyleFamily,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_FontStyleFamily,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_FontStyleBold,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_FontStyleBold,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_FontStyleItalic,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_FontStyleItalic,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_FontStyleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_FontStyle,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_FontStyleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FontStyleOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_FontStyleDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FontStyleDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_FontStyleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_FontStyle,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_FontStyleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FontStyleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_FontStyle,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFFontStyleName,
		MBObj->STR_FontStyleSize,
		MBObj->CY_FontStyleFamily,
		MBObj->CH_FontStyleBold,
		MBObj->CH_FontStyleItalic,
		MBObj->BT_FontStyleOk,
		MBObj->BT_FontStyleDefault,
		MBObj->BT_FontStyleCancel,
		0
		);
