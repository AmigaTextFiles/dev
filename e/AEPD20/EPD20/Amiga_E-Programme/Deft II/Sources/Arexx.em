OPT MODULE


->*****
->** External modules
->*****
MODULE 'muimaster' , 'libraries/mui'
MODULE 'tools/boopsi'
MODULE 'utility/tagitem' , 'utility/hooks'
MODULE 'tools/installhook'

MODULE '*Locale'
MODULE '*Defs'
MODULE '*Errors'
MODULE '*GUI_MUIB'
MODULE '*Work'
MODULE '*PrefsFile'
MODULE '*Paths'
MODULE '*DefaultTools'


->*****
->** Global variables
->*****
EXPORT DEF deftII					:	PTR TO obj_app
EXPORT DEF cat						:	PTR TO catalog_DeftII
EXPORT DEF modified					:	LONG
EXPORT DEF current_edited_path		:	LONG
EXPORT DEF current_edited_def_tool	:	LONG


/********************************************************************************************************/
/* Initializes the object which gives arexx information needed for the MUI application at creation time */
/********************************************************************************************************/
EXPORT PROC init_arexx()

	DEF arexx : PTR TO obj_arexx
	DEF arexx_commands : PTR TO mui_command
	DEF number_paths_hook			:	PTR TO hook
	DEF number_default_tools_hook	:	PTR TO hook
	DEF add_path_hook				:	PTR TO hook
	DEF add_default_tool_hook		:	PTR TO hook
	DEF delete_path_hook			:	PTR TO hook
	DEF delete_default_tool_hook	:	PTR TO hook
	DEF get_path_hook				:	PTR TO hook
	DEF get_old_default_tool_hook	:	PTR TO hook
	DEF get_new_default_tool_hook	:	PTR TO hook
	DEF save_prefs_hook				:	PTR TO hook
	DEF go_hook						:	PTR TO hook
	DEF loose_modifications_hook	:	PTR TO hook

	NEW	arexx , arexx_commands[ 13 ] ,
		number_paths_hook			,
		number_default_tools_hook	,
		add_path_hook				,
		add_default_tool_hook		,
		delete_path_hook			,
		delete_default_tool_hook	,
		get_path_hook				,
		get_old_default_tool_hook	,
		get_new_default_tool_hook	,
		save_prefs_hook				,
		go_hook						,
		loose_modifications_hook

	installhook(	number_paths_hook			, 	{number_paths}				)
	installhook(	number_default_tools_hook	,	{number_default_tools}		)
	installhook(	add_path_hook				,	{arexx_add_path}			)
	installhook(	add_default_tool_hook		,	{arexx_add_default_tool}	)
	installhook(	delete_path_hook			,	{arexx_delete_path}			)
	installhook(	delete_default_tool_hook	,	{arexx_delete_default_tool}	)
	installhook(	get_path_hook				,	{get_path}					)
	installhook(	get_old_default_tool_hook	,	{get_old_default_tool}		)
	installhook(	get_new_default_tool_hook	,	{get_new_default_tool}		)
	installhook(	save_prefs_hook				,	{arexx_save_prefs}			)
	installhook(	go_hook						,	{arexx_go}					)
	installhook(	loose_modifications_hook	,	{loose_modifications}		)

	arexx_commands := [	'number_paths' , '' , 0 , number_paths_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'number_default_tools' , '' , 0 , number_default_tools_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'add_path' , 'PATH/A' , 1 , add_path_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'add_default_tool' , 'OLD/A,NEW/A' , 2 , add_default_tool_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'delete_path' , 'PATH/N/A' , 1 , delete_path_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'delete_default_tool' , 'DEFAULT_TOOL=DT/N/A' , 1 , delete_default_tool_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'get_path' , 'PATH/N/A' , 1 , get_path_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'get_old_default_tool' , 'OLD_DEFAULT_TOOL=ODT/N/A' , 1 , get_old_default_tool_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'get_new_default_tool' , 'NEW_DEFAULT_TOOL=NDT/N/A' , 1 , get_new_default_tool_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'save_prefs' , '' , 0 , save_prefs_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'go' , '' , 0 , go_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						'loose_modifications' , '' , 0 , loose_modifications_hook ,
																			NIL , NIL , NIL , NIL ,NIL ,
						NIL , NIL , NIL , NIL ,
																			NIL , NIL , NIL , NIL ,NIL ] : mui_command

	arexx.commands := arexx_commands
	installhook( arexx.error , {arexx_error} )

ENDPROC arexx


/*************************************************************************/
/* Arexx hook function which returns the number of paths in the listview */
/*************************************************************************/
PROC number_paths()

	DEF number_entries
	DEF return_string[ 10 ] : STRING

	get( deftII.lv_paths , MUIA_List_Entries , {number_entries} )
	set( deftII.app , MUIA_Application_RexxString , StringF( return_string , '\d' , number_entries ) )

ENDPROC 0


/*********************************************************************************/
/* Arexx hook function which returns the number of default_tools in the listview */
/*********************************************************************************/
PROC number_default_tools()

	DEF number_entries
	DEF return_string[ 10 ] : STRING

	get( deftII.lv_default_tools , MUIA_List_Entries , {number_entries} )
	set( deftII.app , MUIA_Application_RexxString , StringF( return_string , '\d' , number_entries ) )

ENDPROC 0


/*********************************************************/
/* Arexx hook function to add a path inside the listview */
/*********************************************************/
PROC arexx_add_path( hook , obj , arg_array : PTR TO LONG )

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_paths )

ENDPROC add_path( arg_array[] )


/*****************************************************************/
/* Arexx hook function to add a default tool inside the listview */
/*****************************************************************/
PROC arexx_add_default_tool( hook , obj , arg_array : PTR TO LONG )

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_default_tools )

ENDPROC add_default_tool( arg_array[] , arg_array[ 1 ] )


/************************************************************/
/* Arexx hook function to delete a path inside the listview */
/************************************************************/
PROC arexx_delete_path( hook , obj , arg_array : PTR TO LONG )

	DEF entry , number_entries , return = 0

	entry := Long( arg_array[] )
	get( deftII.lv_paths , MUIA_List_Entries , {number_entries} )

	IF ( entry >= 0 ) AND ( entry < number_entries )

		set( deftII.lv_paths , MUIA_List_Quiet , MUI_TRUE )
		domethod( deftII.lv_paths , [ MUIM_List_Remove , entry ] )
		set( deftII.lv_paths , MUIA_List_Quiet , FALSE )

	ELSE

		return := 10

	ENDIF

	current_edited_path := NO_CURRENT_EDITED_PATH
	set( deftII.stR_PA_path , MUIA_String_Contents , '' )

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_paths )

ENDPROC return


/********************************************************************/
/* Arexx hook function to delete a default tool inside the listview */
/********************************************************************/
PROC arexx_delete_default_tool( hook , obj , arg_array : PTR TO LONG )

	DEF entry , number_entries , return = 0

	entry := Long( arg_array[] )
	get( deftII.lv_default_tools , MUIA_List_Entries , {number_entries} )

	IF ( entry >= 0 ) AND ( entry < number_entries )

		set( deftII.lv_default_tools , MUIA_List_Quiet , MUI_TRUE )
		domethod( deftII.lv_default_tools , [ MUIM_List_Remove , entry ] )
		set( deftII.lv_default_tools , MUIA_List_Quiet , FALSE )

	ELSE

		return := 10

	ENDIF

	current_edited_def_tool := NO_CURRENT_EDITED_DEF_TOOL
	set( deftII.stR_old_def_tool , MUIA_String_Contents , '' )
	set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , '' )

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_default_tools )

ENDPROC return


/*******************************************************/
/* Arexx hook function to get from the listview a path */
/*******************************************************/
PROC get_path( hook , obj , arg_array : PTR TO LONG )

	DEF entry_number , entry : PTR TO CHAR
	DEF number_entries , return = 0

	entry_number := Long( arg_array[] )
	get( deftII.lv_paths , MUIA_List_Entries , {number_entries} )

	IF ( entry_number >= 0 ) AND ( entry_number < number_entries )

		domethod( deftII.lv_paths , [ MUIM_List_GetEntry , entry_number , {entry} ] )
		set( deftII.app , MUIA_Application_RexxString , entry )

	ELSE

		return := 10

	ENDIF

ENDPROC return


/********************************************************************/
/* Arexx hook function to get from the listview an old default tool */
/********************************************************************/
PROC get_old_default_tool( hook , obj , arg_array : PTR TO LONG )

	DEF entry_number , entry : PTR TO default_tool
	DEF number_entries , return = 0

	entry_number := Long( arg_array[] )
	get( deftII.lv_default_tools , MUIA_List_Entries , {number_entries} )

	IF ( entry_number >= 0 ) AND ( entry_number < number_entries )

		domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , entry_number , {entry} ] )
		set( deftII.app , MUIA_Application_RexxString , entry.old )

	ELSE

		return := 10

	ENDIF

ENDPROC return


/*******************************************************************/
/* Arexx hook function to get from the listview a new default tool */
/*******************************************************************/
PROC get_new_default_tool( hook , obj , arg_array : PTR TO LONG )

	DEF entry_number , entry : PTR TO default_tool
	DEF number_entries , return = 0

	entry_number := Long( arg_array[] )
	get( deftII.lv_default_tools , MUIA_List_Entries , {number_entries} )

	IF ( entry_number >= 0 ) AND ( entry_number < number_entries )

		domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , entry_number , {entry} ] )
		set( deftII.app , MUIA_Application_RexxString , entry.new )

	ELSE

		return := 10

	ENDIF

ENDPROC return


/*********************************************/
/* Saves the preferences file from the Arexx */
/*********************************************/
PROC arexx_save_prefs() IS save_prefs( FALSE )


/*************************************************************************/
/* The function which runs the icon default tool replacements from Arexx */
/*************************************************************************/
PROC arexx_go()

	set( deftII.gr_paths , MUIA_Disabled , MUI_TRUE )
	set( deftII.gr_default_tools , MUIA_Disabled , MUI_TRUE )
	set( deftII.bt_go , MUIA_Disabled , MUI_TRUE )
	set( deftII.bt_save_prefs , MUIA_Disabled , MUI_TRUE )
	set( deftII.bt_about , MUIA_Disabled , MUI_TRUE )
	set( deftII.bt_quit , MUIA_Disabled , MUI_TRUE )

ENDPROC go( FALSE )


/********************************************************************/
/* Hook function to loose any modification track of the preferences */
/********************************************************************/
PROC loose_modifications()

	modified := FALSE

ENDPROC 0


/*********************************************************************************/
/* This hook function is called when an unknown arexx command is sent to Deft II */
/*********************************************************************************/
PROC arexx_error()

	deftII_error( get_string( cat.msg_Unknown_Arexx_Command ) )

ENDPROC 100
