	/*
	DoMethod((Object *) MBObj->WI_Add,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_AddCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);
	*/

	DoMethod((Object *) MBObj->WI_Add,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Add,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->LV_AddNode,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->BT_AddOk,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->LV_AddNode,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->WI_Add,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);
	/*
	DoMethod((Object *) MBObj->STR_AddNodeName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AddNodeName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);
	*/

	DoMethod((Object *) MBObj->BT_AddOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AddOk,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_AddOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Add,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	/*
	DoMethod((Object *) MBObj->BT_AddCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AddCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);
	*/

	DoMethod((Object *) MBObj->BT_AddCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Add,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Add,
		MUIM_Window_SetCycleChain, MBObj->LV_AddNode,
		MBObj->STR_AddNodeName,
		MBObj->BT_AddOk,
		MBObj->BT_AddCancel,
		0
		);
