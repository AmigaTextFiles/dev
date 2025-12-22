	DoMethod((Object *) MBObj->WI_Texture2Display,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		MBObj->WI_Texture2Display,
		3,
		MUIM_Set, MUIA_Window_Open, FALSE
		);
