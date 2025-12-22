	DoMethod((Object *) MBObj->WI_SaveAs,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_SaveAs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->CH_SaveAsV1Tex,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SaveAsV1Tex,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->CH_SaveAsV1Inlines,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SaveAsV1Inlines,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->CH_SaveAsV1Compress,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SaveAsV1Compress,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->CH_SaveAsV1Normals,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SaveAsV1Normals,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->CH_SaveAsV2Tex,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SaveAsV2Tex,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->CH_SaveAsGLTex,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SaveAsGLTex,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->BT_SaveAsSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_SaveAs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_SaveAsSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SaveAsSave,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->WI_SaveAs,
		MUIM_Window_SetCycleChain, MBObj->PA_SaveAs,
		MBObj->CH_SaveAsV1Tex,
		MBObj->CH_SaveAsV1Inlines,
		MBObj->CH_SaveAsV2Tex,
		MBObj->CH_SaveAsGLTex,
		MBObj->BT_SaveAsSave,
		0
		);
