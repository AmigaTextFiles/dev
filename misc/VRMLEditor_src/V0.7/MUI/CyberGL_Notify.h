	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_CyberGL,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_MainPreview,
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

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_CyberGL,
		2,
		MUIM_CallHook, &SpecialCmdHook
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

	DoMethod((Object *) MBObj->CH_CyberGLAxes,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_CyberGLAxes,
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

	DoMethod((Object *) MBObj->LV_CyberGLCameras,
		MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
		MBObj->LV_CyberGLCameras,
		2,
		MUIM_CallHook, &ChangeCameraHook
		);

	DoMethod((Object *) MBObj->RA_CyberGLActions,
		MUIM_Notify, MUIA_Radio_Active, MUIV_EveryTime,
		MBObj->RA_CyberGLActions,
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

	DoMethod((Object *) MBObj->CH_CyberGLFull,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_CyberGLFull,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->CH_CyberGLAnimated,
		MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
		MBObj->CH_CyberGLAnimated,
		2,
		MUIM_CallHook, &CyberGLCmdHook
		);

	DoMethod((Object *) MBObj->WI_CyberGL,
		MUIM_Window_SetCycleChain, MBObj->BT_CyberGLRefresh,
		MBObj->BT_CyberGLReset,
		MBObj->BT_CyberGLRender,
		MBObj->BT_CyberGLBreak,
		MBObj->GR_CyberGLOutput,
		MBObj->CH_CyberGLAxes,
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
		MBObj->IM_CyberGLBLeft,
		MBObj->IM_CyberGLBRight,
		MBObj->STR_CyberGLBacnk,
		MBObj->PO_CyberGLCameras,
		MBObj->RA_CyberGLActions,
		MBObj->CY_CyberGLWhich,
		MBObj->CY_CyberGLLevel,
		MBObj->CY_CyberGLMode,
		MBObj->CH_CyberGLFull,
		MBObj->CH_CyberGLAnimated,
		0
		);
