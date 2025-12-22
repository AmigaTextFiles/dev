	DoMethod((Object *) MBObj->WI_Coordinate3,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Coordinate3,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Coordinate3,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_Coordinate3Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFCoordinate3Name,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFCoordinate3Name,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_Coordinate3Index,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_Coordinate3Index,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Coordinate3X,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Coordinate3X,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Coordinate3Y,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Coordinate3Y,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Coordinate3Z,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Coordinate3Z,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Add,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Add,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Delete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Delete,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Coordinate3,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Ok,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Coordinate3,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Coordinate3,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFCoordinate3Name,
		MBObj->PR_Coordinate3Index,
		MBObj->STR_Coordinate3X,
		MBObj->STR_Coordinate3Y,
		MBObj->STR_Coordinate3Z,
		MBObj->BT_Coordinate3Add,
		MBObj->BT_Coordinate3Delete,
		MBObj->BT_Coordinate3Ok,
		MBObj->BT_Coordinate3Cancel,
		0
		);
