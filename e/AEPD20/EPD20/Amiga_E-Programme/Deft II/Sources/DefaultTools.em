OPT MODULE


->*****
->** External modules
->*****
MODULE 'muimaster' , 'libraries/mui'
MODULE 'libraries/asl'
MODULE 'icon'
MODULE 'tools/boopsi'
MODULE 'utility/tagitem'
MODULE 'workbench/workbench' , 'workbench/startup'

MODULE '*Defs'
MODULE '*GUI_MUIB'
MODULE '*Work'


->*****
->** Error handling
->*****
RAISE	"MEM"	IF	ParsePatternNoCase()	=	-1	,
		"MEM"	IF	Mui_AllocAslRequest()	=	NIL


->*****
->** Global variables
->*****
EXPORT DEF deftII					:	PTR TO obj_app
EXPORT DEF modified					:	LONG
EXPORT DEF current_edited_def_tool	:	LONG

DEF new_def_tool_fr : PTR TO filerequester


/****************************************************
** Initializes the new default tool file requester **
****************************************************/
EXPORT PROC init_def_tools() IS
	new_def_tool_fr := Mui_AllocAslRequest( ASL_FILEREQUEST , [	ASLFR_REJECTICONS , TRUE , TAG_DONE ] )


/*****************************************************************/
/* Adds a default tool if it isn't already there in the listview */
/*****************************************************************/
EXPORT PROC add_default_tool( old_def_tool : PTR TO CHAR , new_def_tool : PTR TO CHAR )

	DEF def_tool : PTR TO default_tool
	DEF def_tool_tmp : PTR TO default_tool
	DEF i = 0 , already_there = FALSE
	DEF pattern_length
	DEF return = 0

	set( deftII.lv_default_tools , MUIA_List_Quiet , MUI_TRUE )

	REPEAT

		domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , i++ , {def_tool_tmp} ] )
		IF def_tool_tmp <> NIL THEN already_there := str_cmp_no_case( old_def_tool , def_tool_tmp.old )

	UNTIL ( def_tool_tmp = NIL ) OR already_there

	IF ( already_there = FALSE ) AND ( StrLen( old_def_tool ) > 0 )

		def_tool := NewR( SIZEOF default_tool )

		def_tool.old := String( StrLen( old_def_tool ) )
		StrCopy( def_tool.old , old_def_tool , ALL )

		def_tool.old_raw := String ( StrLen( old_def_tool ) + 2 )
		StringF( def_tool.old_raw , '\ei\s' , old_def_tool )

		def_tool.pattern := FastNew( pattern_length := StrLen( def_tool.old ) * 2 + 2 )
		IF ParsePatternNoCase( def_tool.old , def_tool.pattern , pattern_length ) = 0 THEN def_tool.pattern := NIL

		def_tool.new := String( StrLen( new_def_tool ) )
		StrCopy( def_tool.new , new_def_tool , ALL )

		domethod( deftII.lv_default_tools , [ MUIM_List_InsertSingle , def_tool , MUIV_List_Insert_Sorted ] )
		modified := TRUE

	ELSE

		return := 10
		DisplayBeep( NIL )

	ENDIF

	current_edited_def_tool := NO_CURRENT_EDITED_DEF_TOOL
	set( deftII.stR_old_def_tool , MUIA_String_Contents , '' )
	set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , '' )

	set( deftII.lv_default_tools , MUIA_List_Quiet , FALSE )

ENDPROC


/*******************************************************************/
/* Prepares the edition of the active default tool in the listview */
/*******************************************************************/
EXPORT PROC edit_default_tool()

	DEF def_tool : PTR TO default_tool

	get( deftII.lv_default_tools , MUIA_List_Active , {current_edited_def_tool} )
	domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , MUIV_List_GetEntry_Active , {def_tool} ] )
	set( deftII.stR_old_def_tool , MUIA_String_Contents , def_tool.old )
	set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , def_tool.new )
	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_old_def_tool )

ENDPROC


/***************************************************/
/* Deletes the active default tool in the listview */
/***************************************************/
EXPORT PROC delete_default_tool()

	set( deftII.lv_default_tools , MUIA_List_Quiet , MUI_TRUE )

	domethod( deftII.lv_default_tools , [ MUIM_List_Remove , MUIV_List_Remove_Active ] )
	current_edited_def_tool := NO_CURRENT_EDITED_DEF_TOOL
	set( deftII.stR_old_def_tool , MUIA_String_Contents , '' )
	set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , '' )

	set( deftII.lv_default_tools , MUIA_List_Quiet , FALSE )

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_default_tools )

ENDPROC


/**************************************************************/
/* Hook function called to add a default tool to the listview */
/**************************************************************/
EXPORT PROC app_add_default_tool( hook , obj , msg : PTR TO LONG )

	DEF app_def_tools : PTR TO appmessage
	DEF one_def_tool : PTR TO wbarg
	DEF icon : PTR TO diskobject
	DEF old_dir , i

	app_def_tools := msg[]
	one_def_tool := app_def_tools.arglist

	FOR i := 1 TO app_def_tools.numargs

		old_dir := CurrentDir( one_def_tool.lock )
		icon := GetDiskObject( one_def_tool.name )

		IF ( icon = NIL ) OR ( icon.type <> WBPROJECT )

			DisplayBeep( NIL )

		ELSE

			add_default_tool( icon.defaulttool , '' )
			FreeDiskObject( icon )

		ENDIF

		CurrentDir( old_dir )
		one_def_tool++

	ENDFOR

	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.lv_default_tools )

ENDPROC


/***********************************************************/
/* Hook function to display a default tool in the listview */
/***********************************************************/
EXPORT PROC display_def_tool( hook , string_array : PTR TO LONG , def_tool : PTR TO default_tool )

	string_array[ 0 ] := ( IF EstrLen( def_tool.new ) = 0 THEN def_tool.old_raw ELSE def_tool.old )
	string_array[ 1 ] := def_tool.new

ENDPROC


/***********************************************************************/
/* Hook function to compare default tools to sort them in the listview */
/***********************************************************************/
EXPORT PROC compare_def_tool( hook , def_tool1 : PTR TO default_tool , def_tool2 : PTR TO default_tool )

	DEF name1 : PTR TO CHAR
	DEF name2 : PTR TO CHAR

	name1 := IF EstrLen( def_tool1.new ) > 0 THEN def_tool1.old ELSE def_tool1.old_raw
	name2 := IF EstrLen( def_tool2.new ) > 0 THEN def_tool2.old ELSE def_tool2.old_raw

ENDPROC OstrCmp( name1 , name2 )


/***********************************************************/
/* Hook function called before opening the pop object list */
/***********************************************************/
EXPORT PROC open_new_def_tools_list()

	DEF new_def_tool : PTR TO CHAR
	DEF new_def_tool_tmp : PTR TO CHAR
	DEF def_tool : PTR TO default_tool
	DEF i = 0 , j , found = FALSE , already_there

	set( deftII.lv_new_def_tools , MUIA_List_Quiet , MUI_TRUE )

	domethod( deftII.lv_new_def_tools , [ MUIM_List_Clear ] )

	REPEAT

		domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , i++ , {def_tool} ] )

		IF ( def_tool <> NIL ) AND ( EstrLen( def_tool.new ) > 0 )

			already_there := FALSE
			j := 0

			REPEAT

				domethod( deftII.lv_new_def_tools , [ MUIM_List_GetEntry , j++ , {new_def_tool_tmp} ] )
				already_there := str_cmp_no_case( def_tool.new , new_def_tool_tmp )

			UNTIL ( new_def_tool_tmp = NIL ) OR already_there

			IF already_there = FALSE THEN domethod( deftII.lv_new_def_tools , [ MUIM_List_InsertSingle , def_tool.new , MUIV_List_Insert_Sorted ] )

		ENDIF

	UNTIL def_tool = NIL

	get( deftII.stR_PO_new_def_tool , MUIA_String_Contents , {new_def_tool} )

	i := 0

	REPEAT

		domethod( deftII.lv_new_def_tools , [ MUIM_List_GetEntry , i++ , {new_def_tool_tmp} ] )
		IF new_def_tool_tmp <> NIL THEN found := str_cmp_no_case( new_def_tool , new_def_tool_tmp )

	UNTIL ( new_def_tool_tmp = NIL ) OR found

	IF found

		set( deftII.lv_new_def_tools , MUIA_List_Active , i - 1 )

	ELSE

		set( deftII.lv_new_def_tools , MUIA_List_Active , MUIV_List_Active_Top )

	ENDIF

	set( deftII.lv_new_def_tools , MUIA_List_Quiet , FALSE )

ENDPROC MUI_TRUE
  

/***********************************************************/
/* Hook function called before closing the pop object list */
/***********************************************************/
EXPORT PROC close_new_def_tools_list()

	DEF new_def_tool : PTR TO CHAR

	domethod( deftII.lv_new_def_tools , [ MUIM_List_GetEntry , MUIV_List_GetEntry_Active , {new_def_tool} ] )
	set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , new_def_tool )
	set( deftII.wi_main , MUIA_Window_Activate , MUI_TRUE )
	set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_PO_new_def_tool )

ENDPROC


/****************************************************************************************************
** Hook function called to update the new default tool string gadget according to a file requester **
****************************************************************************************************/
EXPORT PROC add_new_def_tool()

	DEF new_def_tool_name[ 256 ] : ARRAY OF CHAR

	set( deftII.app , MUIA_Application_Sleep , MUI_TRUE )

	IF Mui_AslRequest( new_def_tool_fr , [ TAG_DONE ] )

		set( deftII.app , MUIA_Application_Sleep , FALSE )

		AstrCopy( new_def_tool_name , new_def_tool_fr.drawer , 256 )
		AddPart( new_def_tool_name , new_def_tool_fr.file , 256 )
		set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , new_def_tool_name )
		set( deftII.wi_main , MUIA_Window_Activate , MUI_TRUE )
		set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_PO_new_def_tool )

	ELSE

		set( deftII.app , MUIA_Application_Sleep , FALSE )

	ENDIF

ENDPROC


/*********************************************************************************************
** Hook function called to update the new default tool string gadget according to a appicon **
*********************************************************************************************/
EXPORT PROC app_add_new_def_tool( hook , obj , msg : PTR TO LONG )

	DEF app_new_def_tool : PTR TO appmessage
	DEF new_def_tool : PTR TO wbarg
	DEF new_def_tool_name[ 256 ] : ARRAY OF CHAR

	app_new_def_tool := msg[]
	new_def_tool := app_new_def_tool.arglist

	IF app_new_def_tool.numargs <> 1

		DisplayBeep( NIL )

	ELSE

		NameFromLock( new_def_tool.lock , new_def_tool_name , 256 )
		AddPart( new_def_tool_name , new_def_tool.name , 256 )
		set( deftII.stR_PO_new_def_tool , MUIA_String_Contents , new_def_tool_name )
		set( deftII.wi_main , MUIA_Window_Activate , MUI_TRUE )
		set( deftII.wi_main , MUIA_Window_ActiveObject , deftII.stR_PO_new_def_tool )

	ENDIF

ENDPROC
