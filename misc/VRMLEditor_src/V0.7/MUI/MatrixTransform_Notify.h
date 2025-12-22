	DoMethod((Object *) MBObj->WI_MatrixTransform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_MatrixTransform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_MatrixTransform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_MatrixTransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFMatrixTransformName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFMatrixTransformName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform0,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform0,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform1,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform1,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform2,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform2,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform3,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform3,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform4,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform4,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform5,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform5,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform6,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform6,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform7,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform7,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform8,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform8,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform9,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform9,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform10,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform10,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform11,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform11,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform12,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform12,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform13,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform13,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform14,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform14,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MatrixTransform15,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MatrixTransform15,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_MatrixTransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MatrixTransform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MatrixTransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MatrixTransformOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_MatrixTransformDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MatrixTransformDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_MatrixTransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MatrixTransform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MatrixTransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MatrixTransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_MatrixTransform,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFMatrixTransformName,
		MBObj->STR_MatrixTransform0,
		MBObj->STR_MatrixTransform1,
		MBObj->STR_MatrixTransform2,
		MBObj->STR_MatrixTransform3,
		MBObj->STR_MatrixTransform4,
		MBObj->STR_MatrixTransform5,
		MBObj->STR_MatrixTransform6,
		MBObj->STR_MatrixTransform7,
		MBObj->STR_MatrixTransform8,
		MBObj->STR_MatrixTransform9,
		MBObj->STR_MatrixTransform10,
		MBObj->STR_MatrixTransform11,
		MBObj->STR_MatrixTransform12,
		MBObj->STR_MatrixTransform13,
		MBObj->STR_MatrixTransform14,
		MBObj->STR_MatrixTransform15,
		MBObj->BT_MatrixTransformOk,
		MBObj->BT_MatrixTransformDefault,
		MBObj->BT_MatrixTransformCancel,
		0
		);

