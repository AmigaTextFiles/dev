OPT MODULE


->*****
->** External modules
->*****
MODULE 'libraries/mui'
MODULE 'tools/boopsi' , 'tools/installhook'
MODULE 'utility/tagitem' , 'utility/hooks'

MODULE '*Defs'
MODULE '*GUI_MUIB'
MODULE '*Work'
MODULE '*PrefsFile'
MODULE '*Paths'
MODULE '*DefaultTools'


->*****
->** Global variables
->*****
EXPORT DEF deftII					:	PTR TO obj_app
EXPORT DEF current_edited_path		:	LONG
EXPORT DEF current_edited_def_tool	:	LONG


/***************************/
/* Initializes all the gui */
/***************************/
EXPORT PROC init_gui()

	DEF delete_path_hook			:	PTR TO hook
	DEF edit_path_hook				:	PTR TO hook
	DEF gui_add_path_hook			:	PTR TO hook
	DEF app_add_path_hook			:	PTR TO hook
	DEF delete_default_tool_hook	:	PTR TO hook
	DEF edit_default_tool_hook		:	PTR TO hook
	DEF gui_add_default_tool_hook	:	PTR TO hook
	DEF app_add_default_tool_hook	:	PTR TO hook
	DEF add_new_def_tool_hook		:	PTR TO hook
	DEF app_add_new_def_tool_hook	:	PTR TO hook
	DEF save_prefs_hook				:	PTR TO hook
	DEF go_hook						:	PTR TO hook

	NEW delete_path_hook			,
		edit_path_hook				,
		gui_add_path_hook			,
		app_add_path_hook			,
		delete_default_tool_hook	,
		edit_default_tool_hook		,
		gui_add_default_tool_hook	,
		app_add_default_tool_hook	,
		add_new_def_tool_hook		,
		app_add_new_def_tool_hook	,
		save_prefs_hook				,
		go_hook

	installhook(	delete_path_hook			,	{gui_delete_path}		)
	installhook(	edit_path_hook				,	{edit_path}				)
	installhook(	gui_add_path_hook			,	{gui_add_path}			)
	installhook(	app_add_path_hook			,	{app_add_path}			)
	installhook(	delete_default_tool_hook	,	{delete_default_tool}	)
	installhook(	edit_default_tool_hook		,	{edit_default_tool}		)
	installhook(	gui_add_default_tool_hook	,	{gui_add_default_tool}	)
	installhook(	app_add_default_tool_hook	,	{app_add_default_tool}	)
	installhook(	add_new_def_tool_hook		,	{add_new_def_tool}		)
	installhook(	app_add_new_def_tool_hook	,	{app_add_new_def_tool}	)
	installhook(	save_prefs_hook				,	{gui_save_prefs}		)
	installhook(	go_hook						,	{gui_go}				)

		/**********************************************************************/
	domethod(	deftII.wi_main , [ MUIM_Notify , MUIA_Window_CloseRequest , MUI_TRUE ,
				deftII.app , 2 , MUIM_Application_ReturnID , MUIV_Application_ReturnID_Quit ] )

	domethod(	deftII.bt_quit , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.app , 2 , MUIM_Application_ReturnID , MUIV_Application_ReturnID_Quit ] )

	domethod(	deftII.bt_about , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.app , 2 , MUIM_Application_ReturnID , ID_BT_ABOUT ] )

	domethod(	deftII.bt_save_prefs , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_save_prefs , 2 , MUIM_CallHook , save_prefs_hook ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.gr_paths , 3 , MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.gr_default_tools , 3 , MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_go , 3 , MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_save_prefs , 3 , MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_about , 3 , MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_quit , 3 , MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

	domethod(	deftII.bt_go , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_go , 2 , MUIM_CallHook , go_hook ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.gr_paths , 3 , MUIM_Set , MUIA_Disabled , FALSE ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.gr_default_tools , 3 , MUIM_Set , MUIA_Disabled , FALSE ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_go , 3 , MUIM_Set , MUIA_Disabled , FALSE ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_save_prefs , 3 , MUIM_Set , MUIA_Disabled , FALSE ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_about , 3 , MUIM_Set , MUIA_Disabled , FALSE ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_quit , 3 , MUIM_Set , MUIA_Disabled , FALSE ] )

	domethod(	deftII.bt_stop , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.app , 2 , MUIM_Application_ReturnID , ID_BT_STOP ] )
		/**********************************************************************/
	domethod(	deftII.bt_delete_path , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_delete_path , 2 , MUIM_CallHook , delete_path_hook ] )

	domethod(	deftII.lv_paths , [ MUIM_Notify , MUIA_Listview_DoubleClick , MUI_TRUE ,
				deftII.lv_paths , 2 , MUIM_CallHook , edit_path_hook ] )

	domethod(	deftII.stR_PA_path , [ MUIM_Notify , MUIA_String_Acknowledge , MUIV_EveryTime ,
				deftII.stR_PA_path , 2 , MUIM_CallHook , gui_add_path_hook ] ) 

	domethod(	deftII.gr_paths , [ MUIM_Notify , MUIA_AppMessage , MUIV_EveryTime ,
				deftII.gr_paths , 3 , MUIM_CallHook , app_add_path_hook , MUIV_TriggerValue ] )
		/**********************************************************************/
	domethod(	deftII.bt_delete_def_tool , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.bt_delete_def_tool , 2 , MUIM_CallHook , delete_default_tool_hook ] )

	domethod(	deftII.lv_default_tools , [ MUIM_Notify , MUIA_Listview_DoubleClick , MUI_TRUE ,
				deftII.lv_default_tools , 2 , MUIM_CallHook , edit_default_tool_hook ] )

	domethod(	deftII.stR_PO_new_def_tool , [ MUIM_Notify , MUIA_String_Acknowledge , MUIV_EveryTime ,
				deftII.stR_PO_new_def_tool , 2 , MUIM_CallHook , gui_add_default_tool_hook ] ) 

	domethod(	deftII.im_new_def_tool , [ MUIM_Notify , MUIA_Pressed , FALSE ,
				deftII.im_new_def_tool , 2 , MUIM_CallHook , add_new_def_tool_hook ] )

	domethod(	deftII.lv_default_tools , [ MUIM_Notify , MUIA_AppMessage , MUIV_EveryTime ,
				deftII.lv_default_tools , 3 , MUIM_CallHook , app_add_default_tool_hook , MUIV_TriggerValue ] )

	domethod(	deftII.stR_old_def_tool , [ MUIM_Notify , MUIA_AppMessage , MUIV_EveryTime ,
				deftII.stR_old_def_tool , 3 , MUIM_CallHook , app_add_default_tool_hook , MUIV_TriggerValue ] )

	domethod(	deftII.stR_PO_new_def_tool , [ MUIM_Notify , MUIA_AppMessage , MUIV_EveryTime ,
				deftII.stR_PO_new_def_tool , 3 , MUIM_CallHook , app_add_new_def_tool_hook , MUIV_TriggerValue ] )

	domethod(	deftII.stR_old_def_tool , [ MUIM_Notify , MUIA_String_Acknowledge , MUIV_EveryTime ,
				deftII.wi_main , 3 , MUIM_Set , MUIA_Window_ActiveObject , deftII.stR_PO_new_def_tool ] )

	domethod(	deftII.lv_new_def_tools , [ MUIM_Notify , MUIA_Listview_DoubleClick , MUI_TRUE ,
				deftII.po_new_def_tool , 2 , MUIM_Popstring_Close , TRUE ] )
		/**********************************************************************/

	domethod(	deftII.wi_main , [ MUIM_Window_SetCycleChain ,
									deftII.lv_default_tools , deftII.bt_delete_def_tool ,
									deftII.stR_old_def_tool , deftII.stR_PO_new_def_tool ,
									deftII.lv_paths , deftII.stR_PA_path , deftII.bt_delete_path ,
									deftII.bt_go , deftII.bt_stop , deftII.bt_save_prefs ,
									deftII.bt_about , deftII.bt_quit , NIL ] )

	set( deftII.wi_main	, MUIA_Window_ID , IDEX_WI_MAIN )
	set( deftII.wi_main , MUIA_Window_Open , MUI_TRUE )

ENDPROC


/***********************************************/
/* Adds a new (or edited) path to the listview */
/***********************************************/
PROC gui_add_path()

	DEF path_str : PTR TO CHAR

	IF current_edited_path = NO_CURRENT_EDITED_PATH

		set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_PA_path )

	ELSE

		set( deftII.lv_paths , MUIA_List_Quiet , MUI_TRUE )
		domethod( deftII.lv_paths , [ MUIM_List_Remove , current_edited_path ] )
		set( deftII.lv_paths , MUIA_List_Quiet , FALSE )
		set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_paths )

	ENDIF

	get( deftII.stR_PA_path , MUIA_String_Contents , {path_str} )
	add_path( path_str )

ENDPROC


/*******************************************/
/* Deletes the active path in the listview */
/*******************************************/
PROC gui_delete_path()

	set( deftII.lv_paths , MUIA_List_Quiet , MUI_TRUE )

	domethod( deftII.lv_paths , [ MUIM_List_Remove , MUIV_List_Remove_Active ] )
	current_edited_path := NO_CURRENT_EDITED_PATH
	set( deftII.stR_PA_path , MUIA_String_Contents , '' )

	set( deftII.lv_paths , MUIA_List_Quiet , FALSE )

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_paths )

ENDPROC


/*******************************************************/
/* Adds a new (or edited) default tool to the listview */
/*******************************************************/
PROC gui_add_default_tool()

	DEF old_def_tool : PTR TO CHAR
	DEF new_def_tool : PTR TO CHAR

	IF current_edited_def_tool = NO_CURRENT_EDITED_DEF_TOOL

		set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_old_def_tool )

	ELSE

		set( deftII.lv_default_tools , MUIA_List_Quiet , MUI_TRUE )
		domethod( deftII.lv_default_tools , [ MUIM_List_Remove , current_edited_def_tool ] )
		set( deftII.lv_default_tools , MUIA_List_Quiet , FALSE )
		set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_default_tools )

	ENDIF

	get( deftII.stR_old_def_tool , MUIA_String_Contents , {old_def_tool} )
	get( deftII.stR_PO_new_def_tool , MUIA_String_Contents , {new_def_tool} )
	add_default_tool( old_def_tool , new_def_tool )

ENDPROC


/*******************************************/
/* Saves the preferences file from the gui */
/*******************************************/
PROC gui_save_prefs() IS save_prefs( TRUE )


/***************************************************************************/
/* The function which runs the icon default tool replacements from the gui */
/***************************************************************************/
PROC gui_go() IS go( TRUE )
