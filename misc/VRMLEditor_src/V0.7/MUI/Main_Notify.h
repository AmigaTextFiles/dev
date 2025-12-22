
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

	DoMethod((Object *) MBObj->MNProjectSave,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSave,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectSaveasVRML,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSaveasVRML,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectSaveasVRML2,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSaveasVRML2,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectSaveasOpenGL,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNProjectSaveasOpenGL,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNProjectExport,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->WI_MeshWriter,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
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

	DoMethod((Object *) MBObj->MNEditCut,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNEditCut,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNEditCopy,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNEditCopy,
		2,
		MUIM_CallHook, &MenuCmdHook
		);

	DoMethod((Object *) MBObj->MNEditPaste,
		MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
		MBObj->MNEditPaste,
		2,
		MUIM_CallHook, &MenuCmdHook
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

	DoMethod((Object *) MBObj->BT_MainInfo,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainInfo,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_CyberGL,
		3,
		MUIM_Set, MUIA_Window_Open, TRUE
		);

	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraView,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);
	/*
	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Add,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainPreview,
		2,
		MUIM_CallHook, &ModifyCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainPreview,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);
	*/

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

	DoMethod((Object *) MBObj->BT_MainExchange,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainExchange,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->BT_MainTransform,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainTransform,
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

	DoMethod((Object *) MBObj->BT_MainMoveRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainMoveRight,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	 DoMethod((Object *) MBObj->BT_MainMoveLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainMoveLeft,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	 DoMethod((Object *) MBObj->BT_MainMoveUp,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainMoveUp,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	 DoMethod((Object *) MBObj->BT_MainMoveDown,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainMoveDown,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	//-------------- Color --------------
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
	//--------------------------------------------

	DoMethod((Object *) MBObj->BT_MainAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MainAdd,
		2,
		MUIM_CallHook, &ActionsCmdHook
		);

	DoMethod((Object *) MBObj->WI_Main,
		MUIM_Window_SetCycleChain, MBObj->BT_MainInfo,
		MBObj->BT_MainPreview,
		MBObj->GR_MainColor,
		MBObj->CF_MainWorld,
		MBObj->LV_MainWorld,
		MBObj->BT_MainMoveRight,
		MBObj->BT_MainMoveLeft,
		MBObj->BT_MainMoveUp,
		MBObj->BT_MainMoveDown,
		MBObj->GR_ClipColor,
		MBObj->CF_MainClip,
		MBObj->LV_MainClip,
		MBObj->BT_MainAdd,
		MBObj->BT_MainDelete,
		MBObj->BT_MainCopy,
		MBObj->BT_MainClear,
		MBObj->BT_MainExchange,
		MBObj->BT_MainTransform,
		MBObj->BT_MainSave,
		MBObj->BT_MainInsert,
		0
		);

