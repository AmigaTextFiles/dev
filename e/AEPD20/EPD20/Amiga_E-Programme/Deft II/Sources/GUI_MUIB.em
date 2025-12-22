OPT MODULE


->*****
->** External modules
->*****
MODULE 'muimaster' , 'libraries/mui'
MODULE 'utility/tagitem' , 'utility/hooks'
MODULE 'libraries/asl'
MODULE 'workbench/workbench'

MODULE '*Locale'


->*****
->** Object definitions
->*****
EXPORT OBJECT obj_arexx
	commands	:	PTR TO mui_command
	error		:	hook
ENDOBJECT

EXPORT OBJECT obj_display
	display_def_tool	:	hook
	compare_def_tool	:	hook
	str_obj				:	hook
	obj_str				:	hook
ENDOBJECT

EXPORT OBJECT obj_app
	app					:	LONG
	wi_main				:	LONG
	lv_default_tools	:	LONG
	gr_default_tools	:	LONG
	stR_old_def_tool	:	LONG
	po_new_def_tool		:	LONG
	stR_PO_new_def_tool	:	LONG
	lv_new_def_tools	:	LONG
	im_new_def_tool		:	LONG
	bt_delete_def_tool	:	LONG
	gr_paths			:	LONG
	lv_paths			:	LONG
	pa_path				:	LONG
	stR_PA_path			:	LONG
	bt_delete_path		:	LONG
	tx_info				:	LONG
	bt_go				:	LONG
	bt_stop				:	LONG
	bt_save_prefs		:	LONG
	bt_about			:	LONG
	bt_quit				:	LONG
ENDOBJECT


->*****
->** Global variables
->*****
EXPORT DEF cat : PTR TO catalog_DeftII


->*****
->** Initializes the application object
->*****
PROC create(	icon	:	PTR TO diskobject	,
				arexx	:	PTR TO obj_arexx	,
				display	:	PTR TO obj_display	) OF obj_app

	DEF app , wi_main , lv_default_tools , gr_default_tools
	DEF stR_old_def_tool , po_new_def_tool , stR_PO_new_def_tool
	DEF lv_new_def_tools , bt_delete_def_tool , gr_paths , lv_paths , pa_path
	DEF stR_PA_path , bt_delete_path , tx_info , bt_go , bt_stop
	DEF bt_save_prefs , bt_about , bt_quit , im_new_def_tool

	app := ApplicationObject ,
		MUIA_Application_Author , 'Lionel Vintenat' ,
		MUIA_Application_Base , 'DEFT_II' ,
		MUIA_Application_Title , 'Deft II' ,
		MUIA_Application_Version , '$VER: Deft_II 1.3 (02.09.94)' ,
		MUIA_Application_Copyright , '© 1994, Lionel Vintenat' ,
		MUIA_Application_Description , get_string( cat.msg_AppDescription ) ,
		MUIA_Application_DiskObject , icon ,
		MUIA_Application_Commands , arexx.commands ,
		MUIA_Application_RexxHook , arexx.error ,
		MUIA_HelpFile, 'Deft II.guide',
		SubWindow , wi_main := WindowObject ,
			MUIA_Window_Title , get_string( cat.msg_WI_main ) ,
			MUIA_Window_ID , "0WIN" ,
			MUIA_Window_AppWindow , MUI_TRUE ,
			WindowContents , GroupObject ,
				Child , GroupObject ,
					MUIA_Group_Horiz , MUI_TRUE ,
					Child , gr_default_tools := GroupObject ,
						MUIA_Weight , 200 ,
						GroupFrameT( get_string( cat.msg_GR_default_tools ) ) ,
						MUIA_HelpNode , 'gr_default_tools' ,
						Child , lv_default_tools := ListviewObject ,
							MUIA_Listview_DoubleClick , MUI_TRUE ,
							MUIA_Listview_List , ListObject ,
								InputListFrame ,
								MUIA_HelpNode , 'lv_default_tools' ,
								MUIA_List_Format , 'DELTA=10,' ,
								MUIA_List_DisplayHook , display.display_def_tool ,
								MUIA_List_CompareHook , display.compare_def_tool ,
							End ,
						End ,
						Child , GroupObject ,
							MUIA_Group_Columns , 2 ,
							Child , Label( get_string( cat.msg_LA_old_def_tool ) ) ,
							Child , stR_old_def_tool := StringObject ,
								StringFrame ,
								MUIA_HelpNode , 'stR_old_def_tool' ,
								MUIA_String_MaxLen , 256 ,
								MUIA_String_Format , 0 ,
							End ,
							Child , Label( get_string( cat.msg_LA_new_def_tool ) ) ,
							Child , GroupObject ,
								MUIA_Group_Horiz , MUI_TRUE ,
								Child , po_new_def_tool := PopobjectObject ,
									MUIA_HelpNode , 'po_new_def_tool' ,
									MUIA_Popstring_String , stR_PO_new_def_tool := StringMUI( '' , 256 ) ,
									MUIA_Popstring_Button , PopButton( MUII_PopUp ) ,
									MUIA_Popobject_Light , MUI_TRUE ,
									MUIA_Popobject_Follow , MUI_TRUE ,
									MUIA_Popobject_Volatile , MUI_TRUE ,
									MUIA_Popobject_StrObjHook , display.str_obj ,
									MUIA_Popobject_ObjStrHook , display.obj_str ,
									MUIA_Popobject_Object , lv_new_def_tools := ListviewObject ,
										MUIA_Listview_DoubleClick , MUI_TRUE ,
										MUIA_Listview_List , ListObject ,
											InputListFrame ,
										End ,
									End ,
								End ,
								Child , im_new_def_tool := ImageObject ,
									MUIA_HelpNode , 'po_new_def_tool' ,
									MUIA_Image_Spec , 19 ,
									MUIA_Image_FontMatch , MUI_TRUE ,
									MUIA_InputMode, MUIV_InputMode_RelVerify,
									MUIA_Frame, MUIV_Frame_Button,
								End ,
							End ,
						End ,
						Child , bt_delete_def_tool := et_key_button( get_string( cat.msg_BT_delete_def_tool ) ) ,
					End ,
					Child , gr_paths := GroupObject ,
						GroupFrameT( get_string( cat.msg_GR_paths ) ) ,
						MUIA_HelpNode , 'gr_paths' ,
						Child , lv_paths := ListviewObject ,
							MUIA_Listview_DoubleClick , MUI_TRUE ,
							MUIA_Listview_List , ListObject ,
								InputListFrame ,
								MUIA_HelpNode , 'lv_paths' ,
								MUIA_List_ConstructHook , MUIV_List_ConstructHook_String ,
								MUIA_List_DestructHook , MUIV_List_DestructHook_String ,
							End ,
						End ,
						Child , pa_path := PopaslObject ,
							MUIA_HelpNode , 'pa_path' ,
							MUIA_Popasl_Type , 0 ,
							MUIA_Popstring_String , stR_PA_path := StringMUI( '' , 256 ) ,
							MUIA_Popstring_Button , PopButton( MUII_PopDrawer ) ,
							ASLFR_DRAWERSONLY , TRUE ,
						End ,
						Child , bt_delete_path := et_key_button( get_string( cat.msg_BT_delete_path ) ) ,
					End ,
				End ,
				Child , GroupObject ,
					MUIA_Group_Horiz , MUI_TRUE ,
					Child , Label( get_string( cat.msg_LA_info ) ) ,
					Child , tx_info := TextObject ,
						MUIA_Background , 128 ,
						MUIA_Text_Contents , get_string( cat.msg_TX_info ) ,
						MUIA_Text_SetMax , 0 ,
						MUIA_Text_SetMin , 1 ,
						MUIA_Frame , 3 ,
						MUIA_HelpNode , 'tx_info' ,
					End ,
				End ,
				Child , GroupObject ,
					GroupFrameT( get_string( cat.msg_GR_controls ) ) ,
					MUIA_HelpNode , 'gr_controls' ,
					MUIA_Group_Horiz , MUI_TRUE ,
					MUIA_Group_SameWidth , MUI_TRUE ,
					Child , bt_go := et_key_button( get_string( cat.msg_BT_go ) ) ,
					Child , bt_stop := et_key_button( get_string( cat.msg_BT_stop ) ) ,
					Child , bt_save_prefs := et_key_button( get_string( cat.msg_BT_save_prefs ) ) ,
					Child , bt_about := et_key_button( get_string( cat.msg_BT_about ) ) ,
					Child , bt_quit := et_key_button( get_string( cat.msg_BT_quit ) ) ,
				End ,
			End ,
		End ,
	End

	self.app                 := app
	self.wi_main             := wi_main
	self.lv_default_tools    := lv_default_tools
	self.gr_default_tools    := gr_default_tools
	self.stR_old_def_tool    := stR_old_def_tool
	self.po_new_def_tool     := po_new_def_tool
	self.stR_PO_new_def_tool := stR_PO_new_def_tool
	self.lv_new_def_tools    := lv_new_def_tools
	self.im_new_def_tool     := im_new_def_tool
	self.bt_delete_def_tool  := bt_delete_def_tool
	self.gr_paths            := gr_paths
	self.lv_paths            := lv_paths
	self.pa_path             := pa_path
	self.stR_PA_path         := stR_PA_path
	self.bt_delete_path      := bt_delete_path
	self.tx_info             := tx_info
	self.bt_go               := bt_go
	self.bt_stop             := bt_stop
	self.bt_save_prefs       := bt_save_prefs
	self.bt_about            := bt_about
	self.bt_quit             := bt_quit

ENDPROC self.app


->*****
->** Dispose the application object
->*****
PROC dispose() OF obj_app IS Mui_DisposeObject( self.app )


->*****
->** ExTended KeyButton function
->*****
PROC et_key_button( text : PTR TO CHAR ) RETURN KeyButton( ( text + 3 ), text[ 1 ] )
