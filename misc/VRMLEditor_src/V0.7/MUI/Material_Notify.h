	DoMethod((Object *) MBObj->WI_Material,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Material,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Material,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_MaterialCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFMaterialName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFMaterialName,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_MaterialIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_MaterialIndex,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_MaterialAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialAdd,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_MaterialDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialDelete,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialAR,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialAR,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialAG,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialAG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialAB,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialAB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialDR,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialDR,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialDG,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialDG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialDB,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialDB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);
	/*
	DoMethod((Object *) MBObj->SL_MaterialSR,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->CF_MaterialSpecular,
		3,
		MUIM_Set, MUIA_Colorfield_Red,
		(MUIV_TriggerValue<<24)
		);
	*/

	DoMethod((Object *) MBObj->SL_MaterialSR,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialSR,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialSG,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialSG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialSB,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialSB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialER,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialER,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialEG,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialEG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialEB,
		MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime,
		MBObj->SL_MaterialEB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MaterialShininess,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MaterialShininess,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_MaterialTransparency,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_MaterialTransparency,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_MaterialOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_MaterialOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Material,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_MaterialCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Material,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Material,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFMaterialName,
		MBObj->GR_MatPreview,
		MBObj->PR_MaterialIndex,
		MBObj->BT_MaterialAdd,
		MBObj->BT_MaterialDelete,
		MBObj->SL_MaterialAR,
		MBObj->SL_MaterialAG,
		MBObj->SL_MaterialAB,
		MBObj->CF_MaterialAmbient,
		MBObj->SL_MaterialDR,
		MBObj->SL_MaterialDG,
		MBObj->SL_MaterialDB,
		MBObj->CF_MaterialDiffuse,
		MBObj->SL_MaterialSR,
		MBObj->SL_MaterialSG,
		MBObj->SL_MaterialSB,
		MBObj->CF_MaterialSpecular,
		MBObj->SL_MaterialER,
		MBObj->SL_MaterialEG,
		MBObj->SL_MaterialEB,
		MBObj->CF_MaterialEmmisive,
		MBObj->STR_MaterialShininess,
		MBObj->STR_MaterialTransparency,
		MBObj->BT_MaterialOk,
		MBObj->BT_MaterialDefault,
		MBObj->BT_MaterialCancel,
		0
		);
