	DoMethod((Object *) MBObj->WI_ShapeHints,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_ShapeHintsCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_ShapeHints,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_ShapeHints,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFShapeHintsName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFShapeHintsName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_ShapeHintsVertexOrdering,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_ShapeHintsVertexOrdering,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_ShapeHintsShapeType,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_ShapeHintsShapeType,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_ShapeHintsFaceType,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_ShapeHintsFaceType,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ShapeHintsCreaseAngle,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ShapeHintsCreaseAngle,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ShapeHintsOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ShapeHintsOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_ShapeHintsOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_ShapeHints,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ShapeHintsDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ShapeHintsDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_ShapeHintsCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ShapeHintsCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_ShapeHintsCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_ShapeHints,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_ShapeHints,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFShapeHintsName,
		MBObj->CY_ShapeHintsVertexOrdering,
		MBObj->CY_ShapeHintsShapeType,
		MBObj->CY_ShapeHintsFaceType,
		MBObj->STR_ShapeHintsCreaseAngle,
		MBObj->BT_ShapeHintsOk,
		MBObj->BT_ShapeHintsDefault,
		MBObj->BT_ShapeHintsCancel,
		0
		);

