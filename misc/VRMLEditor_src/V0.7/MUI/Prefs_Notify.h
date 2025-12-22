	DoMethod((Object *) MBObj->WI_Prefs,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_PrefsOutput,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsOutput,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->RA_PrefsType,
		MUIM_Notify, MUIA_Radio_Active, MUIV_EveryTime,
		MBObj->RA_PrefsType,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->CH_PrefsResolve,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_PrefsResolve,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsConeResolution,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsConeResolution,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsCylinderResolution,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsCylinderResolution,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsSphereResolution,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsSphereResolution,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsR,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsG,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsB,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsAngle,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsAngle,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->STR_PrefsGZip,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PrefsGZip,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->BT_PrefsUse,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PrefsSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PrefsSave,
		2,
		MUIM_CallHook, &PrefsCmdHook
		);

	DoMethod((Object *) MBObj->WI_Prefs,
		MUIM_Window_SetCycleChain, MBObj->GR_PrefsRegister,
		MBObj->STR_PrefsOutput,
		MBObj->RA_PrefsType,
		MBObj->CH_PrefsResolve,
		MBObj->STR_PrefsConeResolution,
		MBObj->STR_PrefsCylinderResolution,
		MBObj->STR_PrefsSphereResolution,
		MBObj->STR_PrefsR,
		MBObj->STR_PrefsG,
		MBObj->STR_PrefsB,
		MBObj->PA_PrefsScreen,
		MBObj->STR_PrefsAngle,
		MBObj->STR_PrefsGZip,
		MBObj->BT_PrefsUse,
		MBObj->BT_PrefsSave,
		0
		);

