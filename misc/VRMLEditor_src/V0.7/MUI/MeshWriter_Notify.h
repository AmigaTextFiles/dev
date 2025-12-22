	DoMethod((Object *) MBObj->WI_MeshWriter,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_MeshWriter,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->CY_MWFormat,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_MWFormat,
		2,
		MUIM_CallHook, &MWCmdHook
		);

	DoMethod((Object *) MBObj->STR_MWExtension,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MWExtension,
		2,
		MUIM_CallHook, &MWCmdHook
		);

	DoMethod((Object *) MBObj->BT_MWSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MWSave,
		2,
		MUIM_CallHook, &MWCmdHook
		);

	DoMethod((Object *) MBObj->BT_MWSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MeshWriter,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_MeshWriter,
		MUIM_Window_SetCycleChain, MBObj->CY_MWFormat,
		MBObj->PA_MWName,
		MBObj->STR_MWExtension,
		MBObj->BT_MWSave,
		0
		);
