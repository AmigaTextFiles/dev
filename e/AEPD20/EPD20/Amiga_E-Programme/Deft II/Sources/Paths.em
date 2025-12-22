OPT MODULE
OPT EXPORT


->*****
->** External modules
->*****
MODULE 'libraries/mui'
MODULE 'tools/boopsi'
MODULE 'utility/tagitem'
MODULE 'workbench/workbench' , 'workbench/startup'

MODULE '*Defs'
MODULE '*GUI_MUIB'
MODULE '*Work'


->*****
->** Global variables
->*****
DEF deftII				:	PTR TO obj_app
DEF modified			:	LONG
DEF current_edited_path	:	LONG


/*********************************************************/
/* Adds a path if it isn't already there in the listview */
/*********************************************************/
PROC add_path( path_str : PTR TO CHAR )

	DEF already_there = FALSE , i = 0
	DEF path_tmp : PTR TO CHAR
	DEF return = 0

	set( deftII.lv_paths , MUIA_List_Quiet , MUI_TRUE )

	REPEAT

		domethod( deftII.lv_paths , [ MUIM_List_GetEntry , i++ , {path_tmp} ] )
		already_there := str_cmp_no_case( path_str , path_tmp )

	UNTIL ( path_tmp = NIL ) OR already_there

	IF ( already_there = FALSE ) AND ( StrLen( path_str ) > 0 )

		domethod( deftII.lv_paths , [ MUIM_List_InsertSingle , path_str , MUIV_List_Insert_Sorted ] )
		modified := TRUE

	ELSE

		return := 10
		DisplayBeep( NIL )

	ENDIF

	current_edited_path := NO_CURRENT_EDITED_PATH
	set( deftII.stR_PA_path , MUIA_String_Contents , '' )

	set( deftII.lv_paths , MUIA_List_Quiet , FALSE )

ENDPROC return


/***********************************************************/
/* Prepares the edition of the active path in the listview */
/***********************************************************/
PROC edit_path()

	DEF path_str : PTR TO CHAR

	get( deftII.lv_paths , MUIA_List_Active , {current_edited_path} )
	domethod( deftII.lv_paths , [ MUIM_List_GetEntry , MUIV_List_GetEntry_Active , {path_str} ] )
	set( deftII.stR_PA_path , MUIA_String_Contents , path_str )
	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_PA_path )

ENDPROC


/******************************************************/
/* Hook function called to add a path to the listview */
/******************************************************/
PROC app_add_path( hook , obj , msg : PTR TO LONG )

	DEF app_paths : PTR TO appmessage
	DEF one_path : PTR TO wbarg
	DEF path_str[ 512 ] : ARRAY OF CHAR , i

	app_paths := msg[]
	one_path := app_paths.arglist

	FOR i := 1 TO app_paths.numargs

		NameFromLock( one_path.lock , path_str , 512 )
		add_path( path_str )
		one_path++

	ENDFOR

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_paths )

ENDPROC
