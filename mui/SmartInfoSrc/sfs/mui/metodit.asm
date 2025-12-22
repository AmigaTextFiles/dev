*-----------------------------------------------*
*	@Ikkunat				*
*-----------------------------------------------*

WI_Main_Metodit:
	dc.l	MUIM_Notify,MUIA_Window_CloseRequest,TRUE
	dc.l	MUIV_Notify_Application,2
	dc.l	MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit

*-----------------------------------------------*
*	@Listat					*
*-----------------------------------------------*

LV_LaiteLista_Metodit:
	dc.l	MUIM_Notify,MUIA_NList_Active,MUIV_EveryTime
	dc.l	MUIV_Notify_Application,2
	dc.l	MUIM_CallHook,Hook_AktiivinenLaite

GetActiveEntry:
	dc.l	MUIM_NList_GetEntry,MUIV_NList_GetEntry_Active,b,0

*-----------------------------------------------*
*	@Nappulat				*
*-----------------------------------------------*

BT_Suorita_SFScheck_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Suorita_SFScheck

BT_Eheyt‰_SFS_Metodit:
	dc.l	MUIM_Notify,MUIA_Pressed,FALSE
	dc.l	MUIV_Notify_Window,2
	dc.l	MUIM_CallHook,Hook_Eheyt‰_SFS

*-----------------------------------------------*
*	@Yleiset				*
*-----------------------------------------------*

OdotusMetodit:
	dc.l	MUIM_Application_NewInput,Signal
	dc.l	0

OpenMUIConfigWindow:
	dc.l	MUIM_Application_OpenConfigWindow,0,0

AboutMUIMethods:
	dc.l	MUIM_Application_AboutMUI
tgMainWindow0:
	dc.l	0,0

Lis‰‰IkkunaMetodit:
	dc.l	OM_ADDMEMBER
UusiIkkuna:
	dc.l	0,0

LataaAsetukset_Metodit:
	dc.l	MUIM_Application_Load,MUIV_Application_Load_ENV

TallennaAsetukset_ENV_Metodit:
	dc.l	MUIM_Application_Save,MUIV_Application_Save_ENV

TallennaAsetukset_ENVARC_Metodit:
	dc.l	MUIM_Application_Save,MUIV_Application_Save_ENVARC

	ENDASM
WI_Sulje_Metodit:
	dc.l	MUIM_Notify,MUIA_Window_CloseRequest,TRUE
	dc.l	MUIV_Notify_Self,3
	dc.l	MUIM_Set,MUIA_Window_Open,FALSE
	ASM

RenderMetodit:
	dc.l	MUIM_Oma_Render

ReDrawMetodit:
	dc.l	MUIM_Oma_ReDraw

*-----------------------------------------------*
*	@Listat					*
*-----------------------------------------------*

AddEntrySorted:
	dc.l	MUIM_NList_InsertSingle
AddSorted:
	dc.l	0,MUIV_NList_Insert_Sorted
