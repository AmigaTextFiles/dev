*-----------------------------------------------*
*	@Nappulat				*
*-----------------------------------------------*

BT_Start_Defrag_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Start_Defrag

BT_Switch_Defrag_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Switch_Defrag

BT_Abort_Defrag_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Abort_Defrag

*-----------------------------------------------*
*	@Ikkunat				*
*-----------------------------------------------*

WI_Defrag_Metodit:
	dc.l	MUIM_Notify,MUIA_Window_CloseRequest,TRUE
	dc.l	MUIV_Notify_Self,3
	dc.l	MUIM_CallHook,Hook_SuljeDefrag
