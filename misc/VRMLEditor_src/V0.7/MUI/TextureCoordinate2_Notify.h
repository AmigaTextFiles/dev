	DoMethod((Object *) MBObj->WI_TextureCoordinate2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_TextureCoordinate2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_TextureCoordinate2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_TextureCoordinate2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTextureCoordinate2Name,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTextureCoordinate2Name,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_TextureCoordinate2Index,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_TextureCoordinate2Index,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TextureCoordinate2X,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TextureCoordinate2X,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TextureCoordinate2Y,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TextureCoordinate2Y,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Add,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Add,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Delete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Delete,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Ok,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_TextureCoordinate2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_TextureCoordinate2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_TextureCoordinate2,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTextureCoordinate2Name,
		MBObj->PR_TextureCoordinate2Index,
		MBObj->STR_TextureCoordinate2X,
		MBObj->STR_TextureCoordinate2Y,
		MBObj->BT_TextureCoordinate2Add,
		MBObj->BT_TextureCoordinate2Delete,
		MBObj->BT_TextureCoordinate2Ok,
		MBObj->BT_TextureCoordinate2Cancel,
		0
		);
