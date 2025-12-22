OPT OSVERSION = 37
OPT PREPROCESS


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////////////// MODULE ... /////
->/////////////////////////////////////////////////////////////////////////////
MODULE 'locale'
MODULE 'muimaster' , 'libraries/mui'
MODULE 'utility/tagitem' , 'utility/hooks'
MODULE 'tools/boopsi' , 'tools/installhook'
MODULE 'icon'

MODULE '*GUI'
MODULE '*Locale'


->/////////////////////////////////////////////////////////////////////////////
->///////////////////////////////////////////////////////// DEF ... : ... /////
->/////////////////////////////////////////////////////////////////////////////
DEF dgce	:	PTR TO app_obj			-> look at GUI.em for "app_obj" object
DEF cat		:	PTR TO catalog_DemoGenCodeE	-> look at Locale.e for "catalog_DemoGenCodeE" object
DEF string_var	:	PTR TO CHAR			-> used by a notification (see GUI.em, lines 49 and 155)


->/////////////////////////////////////////////////////////////////////////////
->///////////////////////////////////////////////////////////// PROC main /////
->/////////////////////////////////////////////////////////////////////////////
PROC main() HANDLE

	DEF running = TRUE , result_domethod , signal
	DEF arexx : app_arexx , display : app_display
	DEF change_text_hook : hook , arexx_commands : PTR TO mui_command
	DEF icon = NIL

		-> localization init
	localebase := OpenLibrary( 'locale.library' , 0 )
	NEW cat.create()	-> see Locale.e
	cat.open( NIL , NIL )	-> see Locale.e

		-> needed libraries and icon init
	IF ( muimasterbase := OpenLibrary( 'muimaster.library' , MUIMASTER_VMIN ) ) = NIL THEN Throw( "LIB" , "muim" )
	IF ( iconbase := OpenLibrary( 'icon.library' , 0 ) ) THEN icon := GetDiskObject( 'PROGDIR:DemoGenCodeE' ) ELSE Throw( "LIB" , "icon" )

		-> exported variables init
	string_var := cat.msg_String_Variable_Put.getstr()

		-> MUI GUI init
			-> in GUI.em line 22, you can see the declaration of "app_display" object
			-> each field of this object correspond to a hook function declared in MUIBuilder
			-> in the present case, there is only the "button_pressed" hook function (see GUI.em line 167)
	installhook( display.button_pressed , {button_pressed} )

		-> ARexx init
			-> for ARexx init you must fill an "app_arexx" object defined in GUI.em line 17
			-> this object gets 2 fields : one for the commands and one for the arexx error hook function
	installhook( change_text_hook , {change_text} )
	arexx.commands := NEW arexx_commands[ 2 ]
	arexx.commands[].mc_name := 'change_text'
	arexx.commands[].mc_template := ''
	arexx.commands[].mc_parameters := 0
	arexx.commands[].mc_hook := change_text_hook
	installhook( arexx.error , {arexx_error} )

		-> MUI application creation
			-> for this you call the create method (see GUI.em line 57) on the "app_obj" object
			-> to this method, you must give the "app_display" object
			-> and if you want (not obliged), you can give an icon, the "app_arexx" object and a menu object (obsolete)
	NEW dgce
	IF dgce.create( display , icon , arexx ) = NIL THEN Throw( "MUI" , Mui_Error() )
	dgce.init_notifications( display )

		-> Main loop
	WHILE running

		result_domethod := domethod( dgce.app , [ MUIM_Application_Input , {signal} ] )
		SELECT result_domethod

			CASE ID_BUTTON_PRESSED	-> see GUI.em line 42 for the definition of this ID

				set( dgce.tx_result , MUIA_Text_Contents , cat.msg_Modified_ID_Returned.getstr() )

			CASE MUIV_Application_ReturnID_Quit

				running := FALSE

		ENDSELECT

		IF ( signal AND running ) THEN Wait( signal )

	ENDWHILE

EXCEPT DO

	SELECT exception

		CASE "LIB"

			SELECT exceptioninfo

				CASE "muim"

					error_simple( cat.msg_Missing_Muimaster_Library.getstr() )

				CASE "icon"

					error_simple( cat.msg_Missing_Icon_Library.getstr() )

			ENDSELECT

		CASE "MEM"

			error( cat.msg_Not_Enough_Memory.getstr() )

		CASE "MUI"

			SELECT exceptioninfo

				CASE MUIE_OutOfMemory

					error_simple( cat.msg_Not_Enough_Memory.getstr() )

				CASE MUIE_OutOfGfxMemory

					error_simple( cat.msg_Not_Enough_Chip_Memory.getstr() )

				CASE MUIE_MissingLibrary

					error_simple( cat.msg_Missing_Library.getstr() )

				CASE MUIE_NoARexx

					error_simple( cat.msg_Arexx_Port.getstr() )

				DEFAULT

					error_simple( cat.msg_Internal_Problem.getstr() )

			ENDSELECT

	ENDSELECT

	IF dgce			THEN dgce.dispose()
	IF icon			THEN FreeDiskObject( icon )
	IF iconbase		THEN CloseLibrary( iconbase )
	IF muimasterbase	THEN CloseLibrary( muimasterbase )
	cat.close()
	IF localebase		THEN CloseLibrary( localebase )

ENDPROC


->/////////////////////////////////////////////////////////////////////////////
->/////////////////// Prints an error message with an intuition requester /////
->/////////////////////////////////////////////////////////////////////////////
PROC error_simple( message : PTR TO CHAR ) IS EasyRequestArgs(	NIL , [ 20 , 0 ,
									cat.msg_DGCE_Error.getstr() ,
									message ,
									cat.msg_Simple_OK.getstr() ] , NIL , NIL )


->/////////////////////////////////////////////////////////////////////////////
->///////////////////////// Prints an error message with an MUI requester /////
->/////////////////////////////////////////////////////////////////////////////
PROC error( message : PTR TO CHAR ) IS Mui_RequestA(	dgce.app ,
							dgce.wi_the_window ,
							NIL ,
							cat.msg_DGCE_Error.getstr() ,
							cat.msg_OK.getstr() ,
							message ,
							NIL )


->/////////////////////////////////////////////////////////////////////////////
->///////// Hook function called each time bt_call_hook button is pressed /////
->/////////////////////////////////////////////////////////////////////////////
PROC button_pressed( hook , obj , msg ) IS set( dgce.tx_result , MUIA_Text_Contents , cat.msg_Modified_By_Hook.getstr() )


->/////////////////////////////////////////////////////////////////////////////
->///////////////////// Hook function called by ARexx command change_text /////
->/////////////////////////////////////////////////////////////////////////////
PROC change_text( hook , obj , msg ) IS set( dgce.tx_result , MUIA_Text_Contents , cat.msg_Modified_By_Arexx.getstr() )


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////// Hook function called by ARexx in case of error /////
->/////////////////////////////////////////////////////////////////////////////
PROC arexx_error( hook , obj , msg ) IS error_simple( cat.msg_Unknown_ARexx_Command.getstr() )
