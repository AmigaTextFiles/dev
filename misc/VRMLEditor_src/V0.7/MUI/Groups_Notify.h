	DoMethod((Object *) MBObj->WI_Groups,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->BT_GroupsOk,
		2,
		MUIM_CallHook, &OkFuncHook
		);

	DoMethod((Object *) MBObj->WI_Groups,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Groups,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->STR_DEFGroupsName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_DEFGroupsName,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->PR_LODRangeIndex,
		MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
		MBObj->PR_LODRangeIndex,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODRange,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODRange,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_LODAdd,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LODAdd,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_LODDelete,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_LODDelete,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODCenterX,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODCenterX,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODCenterY,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODCenterY,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_LODCenterZ,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_LODCenterZ,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_SeparatorRenderCulling,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_SeparatorRenderCulling,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_SwitchWhich,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_SwitchWhich,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWAnchorName,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWAnchorName,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->STR_WWWAnchorDescription,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		MBObj->STR_WWWAnchorDescription,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->CY_WWWAnchorMap,
		MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		MBObj->CY_WWWAnchorMap,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_GroupsOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->BT_GroupsOk,
		2,
		MUIM_CallHook, &GroupsChangeContentsHook
		);

	DoMethod((Object *) MBObj->BT_GroupsOk,
		MUIM_Notify, MUIA_Pressed, FALSE,
		MBObj->WI_Groups,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);

	DoMethod((Object *) MBObj->WI_Groups,
		MUIM_Window_SetCycleChain, MBObj->STR_DEFGroupsName,
		MBObj->TX_GroupsType,
		MBObj->GR_GroupsLOD,
		MBObj->PR_LODRangeIndex,
		MBObj->STR_LODRange,
		MBObj->BT_LODAdd,
		MBObj->BT_LODDelete,
		MBObj->STR_LODCenterX,
		MBObj->STR_LODCenterY,
		MBObj->STR_LODCenterZ,
		MBObj->GR_GroupsSeparator,
		MBObj->CY_SeparatorRenderCulling,
		MBObj->GR_GroupsSwitch,
		MBObj->STR_SwitchWhich,
		MBObj->GR_GroupsWWWAnchor,
		MBObj->STR_WWWAnchorName,
		MBObj->STR_WWWAnchorDescription,
		MBObj->CY_WWWAnchorMap,
		MBObj->BT_GroupsOk,
		0
		);
