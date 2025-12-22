	DoMethod((Object *) MBObj->WI_AsciiText,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_AsciiTextCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_AsciiText,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_AsciiText,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFAsciiTextName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFAsciiTextName,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_AsciiTextStrings,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_AsciiTextStrings,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_AsciiTextString,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AsciiTextString,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_AsciiTextWidth,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AsciiTextWidth,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextAdd,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextDelete,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_AsciiTextSpacing,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AsciiTextSpacing,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_AsciiTextJustification,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_AsciiTextJustification,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_AsciiText,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_AsciiTextCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_AsciiText,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_AsciiText,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFAsciiTextName,
		MBObj->LV_AsciiTextStrings,
		MBObj->STR_AsciiTextString,
		MBObj->STR_AsciiTextWidth,
		MBObj->BT_AsciiTextAdd,
		MBObj->BT_AsciiTextDelete,
		MBObj->STR_AsciiTextSpacing,
		MBObj->CY_AsciiTextJustification,
		MBObj->BT_AsciiTextOk,
		MBObj->BT_AsciiTextCancel,
		0
		);
