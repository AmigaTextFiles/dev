	DoMethod((Object *) MBObj->WI_Texture2Transform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_Texture2TransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Texture2Transform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTexture2TransformName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTexture2TransformName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformTX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformTX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformTY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformTY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformRot,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformRot,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformSX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformSX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformSY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformSY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformCenterX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformCenterY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2TransformOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2TransformDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2TransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Texture2Transform,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTexture2TransformName,
		MBObj->STR_Texture2TransformTX,
		MBObj->STR_Texture2TransformTY,
		MBObj->STR_Texture2TransformRot,
		MBObj->STR_Texture2TransformSX,
		MBObj->STR_Texture2TransformSY,
		MBObj->STR_Texture2TransformCenterX,
		MBObj->STR_Texture2TransformCenterY,
		MBObj->BT_Texture2TransformOk,
		MBObj->BT_Texture2TransformDefault,
		MBObj->BT_Texture2TransformCancel,
		0
		);

