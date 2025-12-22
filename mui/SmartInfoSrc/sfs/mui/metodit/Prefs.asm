*-----------------------------------------------*
*	@Muut					*
*-----------------------------------------------*

WI_Prefs_Metodit:
	dc.l	MUIM_Notify,MUIA_Window_CloseRequest,TRUE
	dc.l	MUIV_Notify_Application,2
	dc.l	MUIM_CallHook,Hook_Prefs_Cancel

*-----------------------------------------------*
*	@Poppen					*
*-----------------------------------------------*

PP_UsedBlock_Metodit:
	dc.l	MUIM_Pendisplay_SetMUIPen,MPEN_TEXT

PP_NewBlock_Metodit:
	dc.l	MUIM_Pendisplay_SetMUIPen,MPEN_FILL

PP_RemovedBlock_Metodit:
	dc.l	MUIM_Pendisplay_SetMUIPen,MPEN_SHINE

*-----------------------------------------------*
*	@Nappulat				*
*-----------------------------------------------*

BT_Prefs_Save_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Prefs_Save

BT_Prefs_Use_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Prefs_Use

BT_Prefs_Cancel_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Prefs_Cancel
