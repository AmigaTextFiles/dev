*-----------------------------------------------*
*	@Sekalaiset				*
*-----------------------------------------------*

ApplicationTags:
	dc.l	MUIA_Application_Author,t_AuthorInfo
	dc.l	MUIA_Application_Base,t_AppBase
	dc.l	MUIA_Application_Title,t_AppTitle
	dc.l	MUIA_Application_Copyright,t_AppRights
	dc.l	MUIA_Application_Version,t_VerString
	dc.l	MUIA_Application_Description,t_AppDescription
	dc.l	MUIA_Application_Menustrip
MN_Menustrip:
	dc.l	0
	dc.l	MUIA_Application_Window
WI_PrefsWindow:
	dc.l	0
	dc.l	MUIA_Application_Window
WI_Main:
	dc.l	0
	dc.l	TAG_DONE

MapTags:
	dc.l	MUIA_Frame,MUIV_Frame_ReadList
	dc.l	MUIA_Background,MUII_BACKGROUND
	dc.l	TAG_DONE

*-----------------------------------------------*
*	@Yleiset				*
*-----------------------------------------------*

AddHelpStringTags:
	dc.l	MUIA_CycleChain,TRUE
	dc.l	MUIA_ShortHelp
HelpString:
	dc.l	0
	dc.l	TAG_DONE

AddCheckMarkTags:
	dc.l	MUIA_CycleChain,TRUE
	dc.l	MUIA_ObjectID
CheckMarkID:
	dc.l	0
	dc.l	MUIA_Selected
CheckMarkState:
	dc.l	0
	dc.l	TAG_DONE

PopUpPenTags:
	dc.l	MUIA_FixHeightTxt,DoubleTxtHeight
	dc.l	MUIA_CycleChain,TRUE
	dc.l	TAG_DONE

HorizBarTags:
	dc.l	MUIA_Rectangle_HBar,TRUE
	dc.l	TAG_DONE

*-----------------------------------------------*
*	@Listviewit				*
*-----------------------------------------------*

DeviceListviewTags:
	dc.l	MUIA_NListview_Horiz_ScrollBar,MUIV_NListview_HSB_None
	dc.l	MUIA_NListview_Vert_ScrollBar,MUIV_NListview_VSB_FullAuto
	dc.l	MUIA_NListview_NList
LV_LaiteLista_obj:
	dc.l	0
	dc.l	MUIA_CycleChain,TRUE
	dc.l	MUIA_Weight,30
	dc.l	TAG_DONE

DeviceListTags:
	dc.l	MUIA_NList_CompareHook,Hook_J‰rjest‰LaiteLista
	dc.l	MUIA_NList_DisplayHook,Hook_MuotoileLaiteLista
	dc.l	MUIA_NList_Format,DeviceListFormat
;	dc.l	MUIA_NList_Title,TRUE
	dc.l	MUIA_Frame,MUIV_Frame_InputList
	dc.l	TAG_DONE

*-----------------------------------------------*
*	@Tekstit				*
*-----------------------------------------------*

TextTags2:
	dc.l	MUIA_Text_PreParse,PreParse2
TextTags:
	dc.l	MUIA_Frame,MUIV_Frame_Text
	dc.l	MUIA_Background,MUII_TextBack
	ENDASM
	dc.l	MUIA_Text_SetMin,FALSE
	dc.l	MUIA_Weight,0
	dc.l	MUIA_InnerLeft,0,MUIA_InnerRight,0
	dc.l	MUIA_FramePhantomHoriz,TRUE
	dc.l	MUIA_Text_Contents,0
	ASM
	dc.l	TAG_DONE

TimeTextTags:
	dc.l	MUIA_Weight,50
	dc.l	MUIA_Text_Contents,t_DefStartTime
	dc.l	MUIA_Text_PreParse,PreParse
	dc.l	TAG_DONE

*-----------------------------------------------*
*	@Stringit				*
*-----------------------------------------------*

AddBuffersStringTags:
	dc.l	MUIA_ObjectID,'BUFS'
	dc.l	MUIA_String_Integer,1000
	dc.l	MUIA_String_Accept,Numerals
	dc.l	MUIA_String_MaxLen,8
	dc.l	MUIA_CycleChain,TRUE
	dc.l	MUIA_Frame,MUIV_Frame_String
	dc.l	MUIA_String_AdvanceOnCR,TRUE
	dc.l	TAG_DONE
