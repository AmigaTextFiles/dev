OPT OSVERSION = 37


->*****
->** External modules
->*****
MODULE 'locale'
MODULE 'muimaster' , 'libraries/mui'
MODULE 'tools/boopsi' , 'tools/installhook'
MODULE 'icon'

MODULE '*Defs'
MODULE '*GUI_MUIB'
MODULE '*Locale'
MODULE '*Errors'
MODULE '*PrefsFile'
MODULE '*DefaultTools'
MODULE '*Arexx'
MODULE '*GUI'
MODULE '*Work'


->*****
->** Error handling
->*****
RAISE	"MEM"	IF String()	= NIL


->*****
->** Global variables
->*****
DEF deftII					:	PTR TO obj_app
DEF cat						:	PTR TO catalog_DeftII
DEF modified				:	LONG
DEF current_edited_path		=	NO_CURRENT_EDITED_PATH
DEF current_edited_def_tool	=	NO_CURRENT_EDITED_DEF_TOOL


/******************/
/* Main procedure */
/******************/
PROC main() HANDLE

	DEF running = TRUE , result_DoMethod , signal
	DEF file_requester_active
	DEF display : obj_display
	DEF icon = NIL

	localebase := OpenLibrary( 'locale.library' , 0 )
	NEW cat.create()
	cat.open( NIL , NIL )

	IF ( muimasterbase := OpenLibrary( 'muimaster.library' , MUIMASTER_VMIN ) ) = NIL THEN Throw( "LIB" , "muim" )

	IF ( iconbase := OpenLibrary( 'icon.library' , 0 ) ) THEN icon := GetDiskObject( 'PROGDIR:Deft II' ) ELSE Throw( "LIB" , "icon" )

	installhook(	display.display_def_tool	,	{display_def_tool}			)
	installhook(	display.compare_def_tool	,	{compare_def_tool}			)
	installhook(	display.str_obj				,	{open_new_def_tools_list}	)
	installhook(	display.obj_str				,	{close_new_def_tools_list}	)
	IF NEW deftII.create( icon , init_arexx() , display ) = NIL THEN Throw( "MUI" , Mui_Error() )

	init_gui()
	load_prefs()
	init_def_tools()
	init_go()

		-> Main loop
	WHILE running

		result_DoMethod := domethod( deftII.app , [ MUIM_Application_Input , {signal} ] )
		SELECT result_DoMethod

			CASE ID_BT_ABOUT

				Mui_RequestA(	deftII.app , deftII.wi_main , NIL ,
								get_string( cat.msg_About_DeftII ) ,
								get_string( cat.msg_OK ) ,
								get_string( cat.msg_About_Text ) ,
								NIL )

			CASE MUIV_Application_ReturnID_Quit

				get( deftII.pa_path , MUIA_Popasl_Active , {file_requester_active} )

				IF file_requester_active

					deftII_error( get_string( cat.msg_File_Requester_Still_Opened ) )

				ELSE

					IF modified

						IF deftII_request( get_string( cat.msg_Really_Quit ) ) = 1 THEN running := FALSE

					ELSE

						running := FALSE

					ENDIF

				ENDIF

		ENDSELECT

		IF ( signal AND running ) THEN Wait( signal )

	ENDWHILE

	deftII.dispose()
	IF icon THEN FreeDiskObject( icon )
	IF iconbase THEN CloseLibrary( iconbase )
	CloseLibrary( muimasterbase )
	cat.close()
	IF localebase THEN CloseLibrary( localebase )

EXCEPT

	SELECT exception

		CASE "LIB"

			SELECT exceptioninfo

				CASE "muim"

					deftII_error_simple( get_string( cat.msg_Missing_Muimaster_Library ) )

				CASE "icon"

					deftII_error_simple( get_string( cat.msg_Missing_Icon_Library ) )

			ENDSELECT

		CASE "MEM"

			deftII_error( get_string( cat.msg_Not_Enough_Memory ) )

		CASE "MUI"

			SELECT exceptioninfo

				CASE MUIE_OutOfMemory

					deftII_error_simple( get_string( cat.msg_Not_Enough_Memory ) )

				CASE MUIE_OutOfGfxMemory

					deftII_error_simple( get_string( cat.msg_Not_Enough_Chip_Memory ) )

				CASE MUIE_MissingLibrary

					deftII_error_simple( get_string( cat.msg_Missing_Library ) )

				CASE MUIE_NoARexx

					deftII_error_simple( get_string( cat.msg_Arexx_Port ) )

				DEFAULT

					deftII_error_simple( get_string( cat.msg_Internal_Problem ) )

			ENDSELECT

	ENDSELECT

	IF deftII 				THEN deftII.dispose()
	IF icon					THEN FreeDiskObject( icon )
	IF iconbase				THEN CloseLibrary( iconbase )
	IF muimasterbase		THEN CloseLibrary( muimasterbase )
	cat.close()
	IF localebase			THEN CloseLibrary( localebase )

	CleanUp( 100 )

ENDPROC
