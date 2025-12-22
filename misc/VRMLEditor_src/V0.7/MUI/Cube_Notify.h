	DoMethod((Object *) MBObj->WI_Cube,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Cube,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Cube,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_CubeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFCubeName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFCubeName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CubeWidth,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CubeWidth,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CubeHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CubeHeight,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CubeDepth,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CubeDepth,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_CubeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cube,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_CubeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CubeOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_CubeDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CubeDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_CubeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cube,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_CubeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CubeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Cube,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFCubeName,
		MBObj->STR_CubeWidth,
		MBObj->STR_CubeHeight,
		MBObj->STR_CubeDepth,
		MBObj->BT_CubeOk,
		MBObj->BT_CubeDefault,
		MBObj->BT_CubeCancel,
		0
		);
