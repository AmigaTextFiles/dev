	DoMethod((Object *) MBObj->WI_Cylinder,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Cylinder,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Cylinder,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_CylinderCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFCylinderName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFCylinderName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CylinderRadius,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CylinderRadius,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CylinderHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CylinderHeight,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_CylinderSides,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_CylinderSides,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_CylinderTop,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_CylinderTop,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_CylinderBottom,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_CylinderBottom,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_CylinderOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cylinder,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_CylinderOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CylinderOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_CylinderDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CylinderDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_CylinderCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cylinder,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_CylinderCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CylinderCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Cylinder,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFCylinderName,
		MBObj->STR_CylinderRadius,
		MBObj->STR_CylinderHeight,
		MBObj->CH_CylinderSides,
		MBObj->CH_CylinderTop,
		MBObj->CH_CylinderBottom,
		MBObj->BT_CylinderOk,
		MBObj->BT_CylinderDefault,
		MBObj->BT_CylinderCancel,
		0
		);
