
	DoMethod((Object *) MBObj->MNProjectNewAll,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectNewAll,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectNewOnlyMain,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectNewOnlyMain,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectNewOnlyClip,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectNewOnlyClip,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectOpen,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectOpen,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectSaveasVRML,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSaveasVRML,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectSaveasOpenGL,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSaveasOpenGL,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectSaveasGEO,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSaveasGEO,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectAbout,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectAbout,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectAboutMUI,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectAboutMUI,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectQuit,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod((Object *) MBObj->MNOptionParseroutput,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNOptionParseroutput,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNOptionPrefs,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->WI_Prefs,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod((Object *) MBObj->IM_MainMoveLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_MainMoveLeft,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->IM_MainMoveRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_MainMoveRight,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->IM_MainMoveUp,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_MainMoveUp,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->IM_MainMoveDown,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_MainMoveDown,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainCmdPreview,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_CyberGL,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainCmdPreview,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);
	/*
	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->ModifyCmd,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->ActionsCmd,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);
	*/

	DoMethod((Object *) MBObj->IM_MainCopyLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_MainCopyLeft,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->IM_MainCopyRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_MainCopyRight,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->LV_MainWorld,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->LV_MainWorld,
		2,
		MUIM_CallHook, &ModifyCmdHook
		);

	DoMethod((Object *) MBObj->LV_MainWorld,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_MainWorld,
		2,
		MUIM_CallHook, &SelectNodeHook
		);

	DoMethod((Object *) MBObj->LV_MainClip,
		MUIM_Notify, MUIA_Listview_DoubleClick, TRUE,
		MBObj->LV_MainClip,
		2,
		MUIM_CallHook, &ModifyCmdHook
		);

	DoMethod((Object *) MBObj->LV_MainClip,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_MainClip,
		2,
		MUIM_CallHook, &SelectNodeHook
		);

	DoMethod((Object *) MBObj->BT_MainAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Add,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->BT_MainDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainDelete,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainCopy,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainCopy,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainClear,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainClear,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainSave,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainSave,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainInsert,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainInsert,
		2,
		MUIM_CallHook, &InOutCmdHook
		);

	DoMethod((Object *) MBObj->GR_MainColor,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->CF_MainWorld,
		2,
		MUIM_CallHook, &SelectNodeHook
		);

	DoMethod((Object *) MBObj->GR_ClipColor,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->CF_MainClip,
		2,
		MUIM_CallHook, &SelectNodeHook
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Window_SetCycleChain, MBObj->IM_MainMoveLeft,
		MBObj->IM_MainMoveRight,
		MBObj->IM_MainMoveUp,
		MBObj->IM_MainMoveDown,
		MBObj->BT_MainCmdPreview,
		MBObj->IM_MainCopyLeft,
		MBObj->IM_MainCopyRight,
		MBObj->CF_MainWorld,
		MBObj->LV_MainWorld,
		MBObj->CF_MainClip,
		MBObj->LV_MainClip,
		MBObj->BT_MainAdd,
		MBObj->BT_MainDelete,
		MBObj->BT_MainCopy,
		MBObj->BT_MainClear,
		MBObj->BT_MainExchange,
		MBObj->BT_MainSave,
		MBObj->BT_MainInsert,
		0
		);

