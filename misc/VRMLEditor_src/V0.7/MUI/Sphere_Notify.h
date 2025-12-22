	DoMethod((Object *) MBObj->WI_Sphere,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Sphere,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFSphereName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFSphereName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SphereRadius,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SphereRadius,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_SphereOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SphereOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_SphereOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Sphere,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_SphereDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SphereDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_SphereCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SphereCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_SphereCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Sphere,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Sphere,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFSphereName,
		MBObj->STR_SphereRadius,
		MBObj->BT_SphereOk,
		MBObj->BT_SphereDefault,
		MBObj->BT_SphereCancel,
		0
		);
