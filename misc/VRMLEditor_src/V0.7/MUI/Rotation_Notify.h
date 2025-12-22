	DoMethod((Object *) MBObj->WI_Rotation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_RotationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Rotation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Rotation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFRotationName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFRotationName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationA,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationA,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_RotationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Rotation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_RotationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_RotationOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_RotationDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_RotationDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_RotationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Rotation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_RotationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_RotationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Rotation,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFRotationName,
		MBObj->STR_RotationX,
		MBObj->STR_RotationY,
		MBObj->STR_RotationZ,
		MBObj->STR_RotationA,
		MBObj->BT_RotationOk,
		MBObj->BT_RotationDefault,
		MBObj->BT_RotationCancel,
		0
		);
