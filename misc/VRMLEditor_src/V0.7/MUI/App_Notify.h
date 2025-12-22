	/*
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
		MBObj->BT_OrthographicCameraView,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraView,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->BT_MainCmdPreview,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

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
	*/
	/*
	DoMethod((Object *) MBObj->WI_Cube,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Cube,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Cube,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_CubeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFCubeName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFCubeName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CubeWidth,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CubeWidth,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CubeHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CubeHeight,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_CubeDepth,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CubeDepth,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_CubeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cube,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_CubeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CubeOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_CubeDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CubeDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_CubeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cube,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_CubeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CubeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Cube,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFCubeName,
		MBObj->STR_CubeWidth,
		MBObj->STR_CubeHeight,
		MBObj->STR_CubeDepth,
		MBObj->BT_CubeOk,
		MBObj->BT_CubeDefault,
		MBObj->BT_CubeCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Transform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Transform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_TransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFTransformName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTransformName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TTranslationX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TTranslationX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TTranslationY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TTranslationY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TTranslationZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TTranslationZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TRotationX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TRotationX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TRotationY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TRotationY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TRotationZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TRotationZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TRotationA,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TRotationA,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleFX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleFX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleFY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleFY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleFZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleFZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleOX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleOX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleOY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleOY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleOZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleOZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TScaleOA,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TScaleOA,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TCenterX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TCenterY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TCenterZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TCenterZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TransformOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_TransformDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TransformDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_TransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Transform,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTransformName,
		MBObj->STR_TTranslationX,
		MBObj->STR_TTranslationY,
		MBObj->STR_TTranslationZ,
		MBObj->STR_TRotationX,
		MBObj->STR_TRotationY,
		MBObj->STR_TRotationZ,
		MBObj->STR_TRotationA,
		MBObj->STR_TScaleFX,
		MBObj->STR_TScaleFY,
		MBObj->STR_TScaleFZ,
		MBObj->STR_TScaleOX,
		MBObj->STR_TScaleOY,
		MBObj->STR_TScaleOZ,
		MBObj->STR_TScaleOA,
		MBObj->STR_TCenterX,
		MBObj->STR_TCenterY,
		MBObj->STR_TCenterZ,
		MBObj->BT_TransformOk,
		MBObj->BT_TransformDefault,
		MBObj->BT_TransformCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Separator,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Separator,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Separator,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_SeparatorOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFSeparatorName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFSeparatorName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_SeparatorRenderCulling,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_SeparatorRenderCulling,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_SeparatorOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Separator,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_SeparatorOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SeparatorOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_Separator,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFSeparatorName,
		MBObj->CY_SeparatorRenderCulling,
		MBObj->BT_SeparatorOk,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Translation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Translation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Translation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_TranslationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFTranslationName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTranslationName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TranslationX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TranslationX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TranslationY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TranslationY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TranslationZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TranslationZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TranslationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Translation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TranslationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TranslationOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_TranslationDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TranslationDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_TranslationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Translation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TranslationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TranslationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Translation,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTranslationName,
		MBObj->STR_TranslationX,
		MBObj->STR_TranslationY,
		MBObj->STR_TranslationZ,
		MBObj->BT_TranslationOk,
		MBObj->BT_TranslationDefault,
		MBObj->BT_TranslationCancel,
		0
		);
	*/
	/*
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
	*/
	/*
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
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialAR,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialAG,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialAG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialAB,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialAB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialDR,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialDR,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialDG,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialDG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialDB,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialDB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialSR,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialSR,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialSG,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialSG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialSB,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialSB,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialER,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialER,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialEG,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
		MBObj->SL_MaterialEG,
		2,
		MUIM_CallHook, &MatChangeContentsHook
		);

	DoMethod((Object *) MBObj->SL_MaterialEB,
		MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
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
		MBObj->WI_Material,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialOk,
		2,
		MUIM_CallHook, &OkFuncHook
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
	*/
	/*
	DoMethod((Object *) MBObj->WI_MaterialBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_MaterialBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_MaterialBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_MaterialBindingCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFMaterialBindingName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFMaterialBindingName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_MaterialBinding,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_MaterialBinding,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MaterialBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialBindingOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_MaterialBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_MaterialBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_MaterialBindingCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_MaterialBinding,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFMaterialBindingName,
		MBObj->CY_MaterialBinding,
		MBObj->BT_MaterialBindingOk,
		MBObj->BT_MaterialBindingCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Rotation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Rotation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Rotation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_RotationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFRotationName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFRotationName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_RotationA,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_RotationA,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_RotationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Rotation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_RotationOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_RotationOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_RotationDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_RotationDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_RotationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Rotation,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_RotationCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_RotationCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Rotation,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFRotationName,
		MBObj->STR_RotationX,
		MBObj->STR_RotationY,
		MBObj->STR_RotationZ,
		MBObj->STR_RotationA,
		MBObj->BT_RotationOk,
		MBObj->BT_RotationDefault,
		MBObj->BT_RotationCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Scale,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Scale,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Scale,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_ScaleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFScaleName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFScaleName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ScaleX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ScaleX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ScaleY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ScaleY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ScaleZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ScaleZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ScaleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Scale,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ScaleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ScaleOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_ScaleDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ScaleDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_ScaleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Scale,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ScaleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ScaleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Scale,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFScaleName,
		MBObj->STR_ScaleX,
		MBObj->STR_ScaleY,
		MBObj->STR_ScaleZ,
		MBObj->BT_ScaleOk,
		MBObj->BT_ScaleDefault,
		MBObj->BT_ScaleCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Cone,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Cone,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Cone,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_ConeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFConeName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFConeName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ConeBottomRadius,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ConeBottomRadius,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ConeHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ConeHeight,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_ConeSides,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_ConeSides,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_ConeBottom,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_ConeBottom,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ConeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cone,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ConeOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ConeCancel,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_ConeDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ConeDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_ConeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Cone,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ConeCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ConeCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Cone,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFConeName,
		MBObj->STR_ConeBottomRadius,
		MBObj->STR_ConeHeight,
		MBObj->CH_ConeSides,
		MBObj->CH_ConeBottom,
		MBObj->BT_ConeOk,
		MBObj->BT_ConeDefault,
		MBObj->BT_ConeCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Coordinate3,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Coordinate3,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Coordinate3,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_Coordinate3Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFCoordinate3Name,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFCoordinate3Name,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_Coordinate3Index,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_Coordinate3Index,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Coordinate3X,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Coordinate3X,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Coordinate3Y,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Coordinate3Y,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Coordinate3Z,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Coordinate3Z,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Add,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Add,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Delete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Delete,
		2,
		MUIM_CallHook, &CoordinateChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Coordinate3,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Ok,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Coordinate3,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Coordinate3Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Coordinate3Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Coordinate3,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFCoordinate3Name,
		MBObj->PR_Coordinate3Index,
		MBObj->STR_Coordinate3X,
		MBObj->STR_Coordinate3Y,
		MBObj->STR_Coordinate3Z,
		MBObj->BT_Coordinate3Add,
		MBObj->BT_Coordinate3Delete,
		MBObj->BT_Coordinate3Ok,
		MBObj->BT_Coordinate3Cancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_IFS,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_IFSCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_IFS,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_IFS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFIFSName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFIFSName,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_IFSIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_IFSIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddFace,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddFace,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteFace,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteFace,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSCoordIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSCoordIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddPoint,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddPoint,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeletePoint,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeletePoint,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSMaterialIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSMaterialIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddMat,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddMat,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteMat,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteMat,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSMatValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSMatValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSNormalIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSNormalIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddNormal,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddNormal,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteNormal,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteNormal,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSNormalValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSNormalValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_IFSTexIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_IFSTexIndex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSAddTex,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSAddTex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_IFSDeleteTex,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSDeleteTex,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_IFSTexValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_IFSTexValue,
		2,
		MUIM_CallHook, &IFSChangeContentsHook
		);

	/*
	DoMethod((Object *) MBObj->CH_IFSMat,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_IFSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_IFSMat,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_IFSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_IFSNormal,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_IFSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_IFSNormal,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_IFSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_IFSTex,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_IFSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_IFSTex,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_IFSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->BT_IFSOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_IFSOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_IFS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_IFSCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_IFSCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_IFSCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_IFS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_IFS,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFIFSName,
		MBObj->PR_IFSIndex,
		MBObj->BT_IFSAddFace,
		MBObj->BT_IFSDeleteFace,
		MBObj->LV_IFSCoordIndex,
		MBObj->BT_IFSAddPoint,
		MBObj->BT_IFSDeletePoint,
		MBObj->STR_IFSValue,
		MBObj->LV_IFSMaterialIndex,
		MBObj->BT_IFSAddMat,
		MBObj->BT_IFSDeleteMat,
		MBObj->STR_IFSMatValue,
		MBObj->LV_IFSNormalIndex,
		MBObj->BT_IFSAddNormal,
		MBObj->BT_IFSDeleteNormal,
		MBObj->STR_IFSNormalValue,
		MBObj->LV_IFSTexIndex,
		MBObj->BT_IFSAddTex,
		MBObj->BT_IFSDeleteTex,
		MBObj->STR_IFSTexValue,
		MBObj->CH_IFSMat,
		MBObj->CH_IFSNormal,
		MBObj->CH_IFSTex,
		MBObj->BT_IFSOk,
		MBObj->BT_IFSCancel,
		0
		);
	*/
	/*
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
	*/
	/*
	DoMethod((Object *) MBObj->WI_Group,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_GroupOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_Group,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Group,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFGroupName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFGroupName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_GroupOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_GroupOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_GroupOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Group,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Group,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFGroupName,
		MBObj->BT_GroupOk,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_LOD,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_LODOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_LOD,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_LOD,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFLODName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFLODName,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_LODRangeIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_LODRangeIndex,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODRange,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODRange,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_LODAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LODAdd,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_LODDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LODDelete,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODCenterX,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODCenterY,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODCenterZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODCenterZ,
		2,
		MUIM_CallHook, &LODChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_LODOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LODOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_LODOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_LOD,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_LOD,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFLODName,
		MBObj->PR_LODRangeIndex,
		MBObj->STR_LODRange,
		MBObj->BT_LODAdd,
		MBObj->BT_LODDelete,
		MBObj->STR_LODCenterX,
		MBObj->STR_LODCenterY,
		MBObj->STR_LODCenterZ,
		MBObj->BT_LODOk,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_AsciiText,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_AsciiTextCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_AsciiText,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_AsciiText,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFAsciiTextName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFAsciiTextName,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_AsciiTextStrings,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_AsciiTextStrings,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_AsciiTextString,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AsciiTextString,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_AsciiTextWidth,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AsciiTextWidth,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextAdd,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextDelete,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_AsciiTextSpacing,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_AsciiTextSpacing,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_AsciiTextJustification,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_AsciiTextJustification,
		2,
		MUIM_CallHook, &AsciiTextChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_AsciiText,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_AsciiTextCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AsciiTextCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_AsciiTextCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_AsciiText,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_AsciiText,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFAsciiTextName,
		MBObj->LV_AsciiTextStrings,
		MBObj->STR_AsciiTextString,
		MBObj->STR_AsciiTextWidth,
		MBObj->BT_AsciiTextAdd,
		MBObj->BT_AsciiTextDelete,
		MBObj->STR_AsciiTextSpacing,
		MBObj->CY_AsciiTextJustification,
		MBObj->BT_AsciiTextOk,
		MBObj->BT_AsciiTextCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_DirectionalLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_DirectionalLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_DirectionalLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_DirectionalLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFDirectionalLightName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFDirectionalLightName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_DirectionalLightOn,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_DirectionalLightOn,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightIntensity,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightIntensity,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightR,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightG,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightB,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_DirectionalLightZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DirectionalLightZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_DirectionalLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_DirectionalLightOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_DirectionalLightDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_DirectionalLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_DirectionalLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_DirectionalLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_DirectionalLight,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFDirectionalLightName,
		MBObj->CH_DirectionalLightOn,
		MBObj->STR_DirectionalLightIntensity,
		MBObj->STR_DirectionalLightR,
		MBObj->STR_DirectionalLightG,
		MBObj->STR_DirectionalLightB,
		MBObj->STR_DirectionalLightX,
		MBObj->STR_DirectionalLightY,
		MBObj->STR_DirectionalLightZ,
		MBObj->BT_DirectionalLightOk,
		MBObj->BT_DirectionalLightDefault,
		MBObj->BT_DirectionalLightCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_FontStyle,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_FontStyleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_FontStyle,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_FontStyle,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFFontStyleName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFFontStyleName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_FontStyleSize,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_FontStyleSize,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_FontStyleFamily,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_FontStyleFamily,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_FontStyleBold,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_FontStyleBold,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_FontStyleItalic,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_FontStyleItalic,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_FontStyleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_FontStyle,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_FontStyleOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FontStyleOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_FontStyleDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FontStyleDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_FontStyleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_FontStyle,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_FontStyleCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_FontStyleCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_FontStyle,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFFontStyleName,
		MBObj->STR_FontStyleSize,
		MBObj->CY_FontStyleFamily,
		MBObj->CH_FontStyleBold,
		MBObj->CH_FontStyleItalic,
		MBObj->BT_FontStyleOk,
		MBObj->BT_FontStyleDefault,
		MBObj->BT_FontStyleCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Info,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_InfoCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Info,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Info,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFInfoName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFInfoName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_InfoString,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_InfoString,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_InfoOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_InfoOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_InfoOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Info,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_InfoCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_InfoCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_InfoCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Info,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Info,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFInfoName,
		MBObj->STR_InfoString,
		MBObj->BT_InfoOk,
		MBObj->BT_InfoCancel,
		0
		);
	*/
	/*
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
	*/
	/*
	DoMethod((Object *) MBObj->WI_Normal,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_NormalCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Normal,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Normal,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFNormalName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFNormalName,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_NormalIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_NormalIndex,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_NormalX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_NormalX,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_NormalY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_NormalY,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_NormalZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_NormalZ,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalAdd,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalDelete,
		2,
		MUIM_CallHook, &NormalChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_NormalOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Normal,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_NormalCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalCancel,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Normal,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Normal,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFNormalName,
		MBObj->PR_NormalIndex,
		MBObj->STR_NormalX,
		MBObj->STR_NormalY,
		MBObj->STR_NormalZ,
		MBObj->BT_NormalAdd,
		MBObj->BT_NormalDelete,
		MBObj->BT_NormalOk,
		MBObj->BT_NormalCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_NormalBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_NormalBindingCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_NormalBinding,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_NormalBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFNormalBindingName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFNormalBindingName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_NormalBindingValue,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_NormalBindingValue,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_NormalBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_NormalBindingOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalBindingOk,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_NormalBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_NormalBinding,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_NormalBindingCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_NormalBindingCancel,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->WI_NormalBinding,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFNormalBindingName,
		MBObj->CY_NormalBindingValue,
		MBObj->BT_NormalBindingOk,
		MBObj->BT_NormalBindingCancel,
		0
		);
	*/
	DoMethod((Object *) MBObj->WI_OrthographicCamera,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_OrthographicCameraCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_OrthographicCamera,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_OrthographicCamera,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFOrthographicCameraName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFOrthographicCameraName,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraView,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraView,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraGrab,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraGrab,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraPosX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraPosX,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraPosY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraPosY,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraPosZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraPosZ,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraOX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraOX,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraOY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraOY,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraOZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraOZ,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraOAngle,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraOAngle,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraFocal,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraFocal,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_OrthographicCameraHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_OrthographicCameraHeight,
		2,
		MUIM_CallHook, &OrthoChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_OrthographicCamera,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_OrthographicCameraCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_OrthographicCameraCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_OrthographicCamera,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_OrthographicCamera,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFOrthographicCameraName,
		MBObj->BT_OrthographicCameraView,
		MBObj->BT_OrthographicCameraGrab,
		MBObj->STR_OrthographicCameraPosX,
		MBObj->STR_OrthographicCameraPosY,
		MBObj->STR_OrthographicCameraPosZ,
		MBObj->STR_OrthographicCameraOX,
		MBObj->STR_OrthographicCameraOY,
		MBObj->STR_OrthographicCameraOZ,
		MBObj->STR_OrthographicCameraOAngle,
		MBObj->STR_OrthographicCameraFocal,
		MBObj->STR_OrthographicCameraHeight,
		MBObj->BT_OrthographicCameraOk,
		MBObj->BT_OrthographicCameraDefault,
		MBObj->BT_OrthographicCameraCancel,
		0
		);

	DoMethod((Object *) MBObj->WI_PerspectiveCamera,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PerspectiveCameraCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_PerspectiveCamera,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_PerspectiveCamera,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFPerspectiveCameraName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFPerspectiveCameraName,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraView,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraView,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraGrab,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraGrab,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraX,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraY,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraZ,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraOX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraOX,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraOY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraOY,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraOZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraOZ,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraOAngle,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraOAngle,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraFocal,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraFocal,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PerspectiveCameraHeight,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PerspectiveCameraHeight,
		2,
		MUIM_CallHook, &PerspectiveChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PerspectiveCamera,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PerspectiveCameraCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_PerspectiveCameraCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PerspectiveCamera,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_PerspectiveCamera,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFPerspectiveCameraName,
		MBObj->BT_PerspectiveCameraView,
		MBObj->BT_PerspectiveCameraGrab,
		MBObj->STR_PerspectiveCameraX,
		MBObj->STR_PerspectiveCameraY,
		MBObj->STR_PerspectiveCameraZ,
		MBObj->STR_PerspectiveCameraOX,
		MBObj->STR_PerspectiveCameraOY,
		MBObj->STR_PerspectiveCameraOZ,
		MBObj->STR_PerspectiveCameraOAngle,
		MBObj->STR_PerspectiveCameraFocal,
		MBObj->STR_PerspectiveCameraHeight,
		MBObj->BT_PerspectiveCameraOk,
		MBObj->BT_PerspectiveCameraDefault,
		MBObj->BT_PerspectiveCameraCancel,
		0
		);
	/*
	DoMethod((Object *) MBObj->WI_PointLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PointLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_PointLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_PointLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFPointLightName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFPointLightName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_PointLightOn,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_PointLightOn,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightIntensity,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightIntensity,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightR,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightG,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointLightB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointLightB,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PointLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointLightOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PointLightDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointLightDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_PointLight,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFPointLightName,
		MBObj->CH_PointLightOn,
		MBObj->STR_PointLightIntensity,
		MBObj->STR_PointLightX,
		MBObj->STR_PointLightY,
		MBObj->STR_PointLightZ,
		MBObj->STR_PointLightR,
		MBObj->STR_PointLightG,
		MBObj->STR_PointLightB,
		MBObj->BT_PointLightOk,
		MBObj->BT_PointLightDefault,
		MBObj->BT_PointLightCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_PointSet,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PointSetCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_PointSet,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_PointSet,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFPointSetName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFPointSetName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointSetStartIndex,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointSetStartIndex,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_PointSetNumPoints,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_PointSetNumPoints,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_PointSetOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointSetOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointSetOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointSet,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_PointSetDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointSetDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointSetCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_PointSetCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_PointSetCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_PointSet,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_PointSet,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFPointSetName,
		MBObj->STR_PointSetStartIndex,
		MBObj->STR_PointSetNumPoints,
		MBObj->BT_PointSetOk,
		MBObj->BT_PointSetDefault,
		MBObj->BT_PointSetCancel,
		0
		);
	*/
	/*
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
	*/

	/*
	DoMethod((Object *) MBObj->WI_SpotLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_SpotLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_SpotLight,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_SpotLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFSpotLightName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFSpotLightName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CH_SpotLightOn,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_SpotLightOn,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightIntensity,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightIntensity,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightR,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightR,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightG,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightG,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightB,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightB,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDirX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDirX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDirY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDirY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDirZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDirZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightDrop,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightDrop,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SpotLightCut,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SpotLightCut,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SpotLightOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_SpotLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_SpotLightDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SpotLightDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SpotLightCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_SpotLightCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_SpotLight,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_SpotLight,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFSpotLightName,
		MBObj->CH_SpotLightOn,
		MBObj->STR_SpotLightIntensity,
		MBObj->STR_SpotLightR,
		MBObj->STR_SpotLightG,
		MBObj->STR_SpotLightB,
		MBObj->STR_SpotLightX,
		MBObj->STR_SpotLightY,
		MBObj->STR_SpotLightZ,
		MBObj->STR_SpotLightDirX,
		MBObj->STR_SpotLightDirY,
		MBObj->STR_SpotLightDirZ,
		MBObj->STR_SpotLightDrop,
		MBObj->STR_SpotLightCut,
		MBObj->BT_SpotLightOk,
		MBObj->BT_SpotLightDefault,
		MBObj->BT_SpotLightCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Switch,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_SwitchOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_Switch,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Switch,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFSwitchName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFSwitchName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SwitchWhich,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SwitchWhich,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_SwitchOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SwitchOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_SwitchOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Switch,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Switch,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFSwitchName,
		MBObj->STR_SwitchWhich,
		MBObj->BT_SwitchOk,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Texture2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_Texture2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Texture2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTexture2Name,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTexture2Name,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2Filename,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2Filename,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_Texture2WrapS,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_Texture2WrapS,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_Texture2WrapT,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_Texture2WrapT,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2Ok,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Texture2Default,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2Default,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Texture2,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTexture2Name,
		MBObj->STR_Texture2Filename,
		MBObj->CY_Texture2WrapS,
		MBObj->CY_Texture2WrapT,
		MBObj->STR_Texture2Width,
		MBObj->STR_Texture2Height,
		MBObj->STR_Texture2Component,
		MBObj->BT_Texture2Ok,
		MBObj->BT_Texture2Default,
		MBObj->BT_Texture2Cancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Texture2Transform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_Texture2TransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Texture2Transform,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTexture2TransformName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTexture2TransformName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformTX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformTX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformTY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformTY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformRot,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformRot,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformSX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformSX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformSY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformSY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformCenterX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_Texture2TransformCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_Texture2TransformCenterY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2TransformOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2TransformDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_Texture2TransformCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_Texture2TransformCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Texture2Transform,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Texture2Transform,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTexture2TransformName,
		MBObj->STR_Texture2TransformTX,
		MBObj->STR_Texture2TransformTY,
		MBObj->STR_Texture2TransformRot,
		MBObj->STR_Texture2TransformSX,
		MBObj->STR_Texture2TransformSY,
		MBObj->STR_Texture2TransformCenterX,
		MBObj->STR_Texture2TransformCenterY,
		MBObj->BT_Texture2TransformOk,
		MBObj->BT_Texture2TransformDefault,
		MBObj->BT_Texture2TransformCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_TextureCoordinate2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_TextureCoordinate2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_TextureCoordinate2,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_TextureCoordinate2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTextureCoordinate2Name,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTextureCoordinate2Name,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_TextureCoordinate2Index,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_TextureCoordinate2Index,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TextureCoordinate2X,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TextureCoordinate2X,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_TextureCoordinate2Y,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_TextureCoordinate2Y,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Add,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->TX_TextureCoordinate2Index,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Delete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Delete,
		2,
		MUIM_CallHook, &TextureCoordinate2ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Ok,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Ok,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_TextureCoordinate2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TextureCoordinate2Cancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_TextureCoordinate2Cancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_TextureCoordinate2,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_TextureCoordinate2,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTextureCoordinate2Name,
		MBObj->PR_TextureCoordinate2Index,
		MBObj->STR_TextureCoordinate2X,
		MBObj->STR_TextureCoordinate2Y,
		MBObj->BT_TextureCoordinate2Add,
		MBObj->BT_TextureCoordinate2Delete,
		MBObj->BT_TextureCoordinate2Ok,
		MBObj->BT_TextureCoordinate2Cancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_WWWAnchor,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_WWWAnchorOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_WWWAnchor,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_WWWAnchor,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFWWWAnchorName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFWWWAnchorName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWAnchorName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWAnchorName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWAnchorDescription,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWAnchorDescription,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_WWWAnchorMap,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_WWWAnchorMap,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_WWWAnchorOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWAnchorOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWAnchorOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_WWWAnchor,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_WWWAnchor,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFWWWAnchorName,
		MBObj->STR_WWWAnchorName,
		MBObj->STR_WWWAnchorDescription,
		MBObj->CY_WWWAnchorMap,
		MBObj->BT_WWWAnchorOk,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_WWWInline,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_WWWInlineCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_WWWInline,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_WWWInline,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFWWWInlineName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFWWWInlineName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineRead,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineRead,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxSizeX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxSizeX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxSizeY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxSizeY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxSizeZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxSizeZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxCenterX,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxCenterY,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWInlineBoxCenterZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWInlineBoxCenterZ,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_WWWInline,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_WWWInlineDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_WWWInlineCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_WWWInlineCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_WWWInline,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_WWWInline,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFWWWInlineName,
		MBObj->STR_WWWInlineName,
		MBObj->BT_WWWInlineRead,
		MBObj->STR_WWWInlineBoxSizeX,
		MBObj->STR_WWWInlineBoxSizeY,
		MBObj->STR_WWWInlineBoxSizeZ,
		MBObj->STR_WWWInlineBoxCenterX,
		MBObj->STR_WWWInlineBoxCenterY,
		MBObj->STR_WWWInlineBoxCenterZ,
		MBObj->BT_WWWInlineOk,
		MBObj->BT_WWWInlineDefault,
		MBObj->BT_WWWInlineCancel,
		0
		);
	*/
	DoMethod((Object *) MBObj->WI_ILS,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_ILS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_ILS,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_ILSCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->STR_DEFILSName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFILSName,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_ILSIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_ILSIndex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSAddLine,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSAddLine,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSDeleteLine,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSDeleteLine,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_ILSCoordIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_ILSCoordIndex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSAddPoint,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSAddPoint,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSDeletePoint,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSDeletePoint,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ILSValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ILSValue,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_ILSMaterialIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_ILSMaterialIndex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSAddMat,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSAddMat,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSDeleteMat,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSDeletePoint,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ILSMatValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ILSMatValue,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_ILSNormalIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_ILSNormalIndex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSAddNormal,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSAddNormal,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSDeleteNormal,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSDeleteNormal,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ILSNormalValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ILSNormalValue,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->LV_ILSTexIndex,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_ILSTexIndex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSAddTex,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSAddTex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_ILSDeleteTex,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSDeleteTex,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_ILSTexValue,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_ILSTexValue,
		2,
		MUIM_CallHook, &ILSChangeContentsHook
		);
	/*
	DoMethod((Object *) MBObj->CH_ILSMat,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_ILSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_ILSMat,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_ILSMaterialIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_ILSNormal,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_ILSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_ILSNormal,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_ILSNormalIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->CH_ILSTex,
		MUIM_Notify, MUIA_Selected, TRUE,
		GR_ILSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->CH_ILSTex,
		MUIM_Notify, MUIA_Selected, FALSE,
		GR_ILSTexIndex,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);
	*/
	DoMethod((Object *) MBObj->BT_ILSOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_ILS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ILSOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_ILSCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_ILS,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_ILSCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_ILSCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_ILS,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFILSName,
		MBObj->PR_ILSIndex,
		MBObj->BT_ILSAddLine,
		MBObj->BT_ILSDeleteLine,
		MBObj->LV_ILSCoordIndex,
		MBObj->BT_ILSAddPoint,
		MBObj->BT_ILSDeletePoint,
		MBObj->STR_ILSValue,
		MBObj->LV_ILSMaterialIndex,
		MBObj->BT_ILSAddMat,
		MBObj->BT_ILSDeleteMat,
		MBObj->STR_ILSMatValue,
		MBObj->LV_ILSNormalIndex,
		MBObj->BT_ILSAddNormal,
		MBObj->BT_ILSDeleteNormal,
		MBObj->STR_ILSNormalValue,
		MBObj->LV_ILSTexIndex,
		MBObj->BT_ILSAddTex,
		MBObj->BT_ILSDeleteTex,
		MBObj->STR_ILSTexValue,
		MBObj->CH_ILSMat,
		MBObj->CH_ILSNormal,
		MBObj->CH_ILSTex,
		MBObj->BT_ILSOk,
		MBObj->BT_ILSCancel,
		0
		);

	/*
	DoMethod((Object *) MBObj->WI_TransformSeparator,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_TransformSeparatorOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_TransformSeparator,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_TransformSeparator,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFTransformSeparatorName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFTransformSeparatorName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_TransformSeparatorOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_TransformSeparatorOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_TransformSeparatorOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_TransformSeparator,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_TransformSeparator,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFTransformSeparatorName,
		MBObj->BT_TransformSeparatorOk,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Sphere,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_SphereCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->WI_Sphere,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Sphere,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFSphereName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFSphereName,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SphereRadius,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SphereRadius,
		2,
		MUIM_CallHook, &ChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_SphereOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SphereOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->BT_SphereOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Sphere,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->BT_SphereDefault,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SphereDefault,
		2,
		MUIM_CallHook, &DefaultFuncHook
		);

	DoMethod((Object *) MBObj->BT_SphereCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_SphereCancel,
		2,
		MUIM_CallHook, &CancelFuncHook
		);

	DoMethod((Object *) MBObj->BT_SphereCancel,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Sphere,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Sphere,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFSphereName,
		MBObj->STR_SphereRadius,
		MBObj->BT_SphereOk,
		MBObj->BT_SphereDefault,
		MBObj->BT_SphereCancel,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_Msg,
		MUIM_Window_SetCycleChain, 0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_CyberGL,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_MainCmdPreview,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_CyberGL,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_OrthographicCameraView,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_OrthographicCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PerspectiveCameraView,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_PerspectiveCameraGrab,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod((Object *) MBObj->BT_CyberGLRefresh,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CyberGLRefresh,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->BT_CyberGLReset,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CyberGLReset,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->BT_CyberGLRender,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CyberGLRender,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->BT_CyberGLBreak,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_CyberGLBreak,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLXLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLXLeft,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLXRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLXRight,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->STR_CyberGLX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CyberGLX,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLYLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLYLeft,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLYRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLYRight,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->STR_CyberGLY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CyberGLY,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLZLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLZLeft,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLZRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLZRight,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->STR_CyberGLZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CyberGLZ,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLHLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLHLeft,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLHRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLHRight,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->STR_CyberGLHeading,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CyberGLHeading,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLPLeft,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLPLeft,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->IM_CyberGLPRight,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->IM_CyberGLPRight,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->STR_CyberGLPitch,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_CyberGLPitch,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->CY_CyberGLMouseEvent,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_CyberGLMouseEvent,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->CY_CyberGLWhich,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_CyberGLWhich,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->CY_CyberGLLevel,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_CyberGLLevel,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->CY_CyberGLMode,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_CyberGLMode,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->CY_CyberGLBox,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_CyberGLBox,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Window_SetCycleChain, MBObj->BT_CyberGLRefresh,
		MBObj->BT_CyberGLReset,
		MBObj->BT_CyberGLRender,
		MBObj->GR_CyberGLOutput,
		MBObj->BT_CyberGLBreak,
		MBObj->IM_CyberGLXLeft,
		MBObj->IM_CyberGLXRight,
		MBObj->STR_CyberGLX,
		MBObj->IM_CyberGLYLeft,
		MBObj->IM_CyberGLYRight,
		MBObj->STR_CyberGLY,
		MBObj->IM_CyberGLZLeft,
		MBObj->IM_CyberGLZRight,
		MBObj->STR_CyberGLZ,
		MBObj->IM_CyberGLHLeft,
		MBObj->IM_CyberGLHRight,
		MBObj->STR_CyberGLHeading,
		MBObj->IM_CyberGLPLeft,
		MBObj->IM_CyberGLPRight,
		MBObj->STR_CyberGLPitch,
		MBObj->CY_CyberGLMouseEvent,
		MBObj->CY_CyberGLWhich,
		MBObj->CY_CyberGLLevel,
		MBObj->CY_CyberGLMode,
		MBObj->CY_CyberGLBox,
		0
		);
	*/
	/*
	DoMethod((Object *) MBObj->WI_About,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_AboutOk,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->BT_AboutOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_AboutOk,
		2,
		MUIM_CallHook, &SpecialCmdHook
		);

	DoMethod((Object *) MBObj->WI_About,
		MUIM_Window_SetCycleChain, MBObj->GR_AboutGL,
		MBObj->GR_AboutText,
		MBObj->LV_AboutText,
		MBObj->BT_AboutOk,
		0
		);
	*/
	SetAttrs((Object *) MBObj->WI_Main,
		MUIA_Window_Open, TRUE
		);

