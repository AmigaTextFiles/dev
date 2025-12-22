	DoMethod((Object *) MBObj->WI_PointSet,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PointSetCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_PointSet,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_PointSet,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFPointSetName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFPointSetName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointSetStartIndex,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointSetStartIndex,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointSetNumPoints,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointSetNumPoints,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PointSetOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointSetOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointSetOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointSet,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PointSetDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointSetDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointSetCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointSetCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointSetCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointSet,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_PointSet,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFPointSetName,
		MBObj->STR_PointSetStartIndex,
		MBObj->STR_PointSetNumPoints,
		MBObj->BT_PointSetOk,
		MBObj->BT_PointSetDefault,
		MBObj->BT_PointSetCancel,
		0
		);
