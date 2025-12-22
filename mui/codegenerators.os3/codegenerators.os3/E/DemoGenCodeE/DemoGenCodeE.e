OPT OSVERSION = 37
OPT PREPROCESS


->/////////////////////////////////////////////////////////////////////////////
->////////////////////////////////////////////////////// External modules /////
->/////////////////////////////////////////////////////////////////////////////
MODULE 'locale'
MODULE 'muimaster' , 'libraries/mui'
MODULE 'utility/tagitem' , 'utility/hooks'
MODULE 'tools/boopsi' , 'tools/installhook'
MODULE 'icon'

MODULE '*GUI'


->/////////////////////////////////////////////////////////////////////////////
->/////////////////////////////////////////// Global variable definitions /////
->/////////////////////////////////////////////////////////////////////////////
DEF dgce	:	PTR TO app_obj			-> look at GUI.em for "app_obj" object
DEF string_var	:	PTR TO CHAR			-> used by a notification (see GUI.em, lines 49 and 155)


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////////// Main Procedure /////
->/////////////////////////////////////////////////////////////////////////////
PROC main() HANDLE

	DEF running = TRUE , result_domethod , signal
	DEF arexx : app_arexx , display : app_display
	DEF change_text_hook : hook , arexx_commands : PTR TO mui_command
	DEF icon = NIL

		-> needed libraries and icon init
	IF ( muimasterbase := OpenLibrary( 'muimaster.library' , MUIMASTER_VMIN ) ) = NIL THEN Throw( "LIB" , "muim" )
	IF ( iconbase := OpenLibrary( 'icon.library' , 0 ) ) THEN icon := GetDiskObject( 'PROGDIR:DemoGenCodeE' ) ELSE Throw( "LIB" , "icon" )

		-> exported variables init
	string_var := 'String variable put !'

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

				set( dgce.tx_result , MUIA_Text_Contents , 'Modifed by ID returned !' )

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

					error_simple( 'Can''t open muimaster.library !' )

				CASE "icon"

					error_simple( 'Can''t open icon.library !' )

			ENDSELECT

		CASE "MEM"

			error( 'Not enough memory !' )

		CASE "MUI"

			SELECT exceptioninfo

				CASE MUIE_OutOfMemory

					error_simple( 'Not enough memory !' )

				CASE MUIE_OutOfGfxMemory

					error_simple( 'Not enough chip memory !' )

				CASE MUIE_MissingLibrary

					error_simple( 'Can''t open a needed library !' )

				CASE MUIE_NoARexx

					error_simple( 'Can''t create arexx port !' )

				DEFAULT

					error_simple( 'Internal problem !' )

			ENDSELECT

	ENDSELECT

	IF dgce			THEN dgce.dispose()
	IF icon			THEN FreeDiskObject( icon )
	IF iconbase		THEN CloseLibrary( iconbase )
	IF muimasterbase	THEN CloseLibrary( muimasterbase )

ENDPROC


->/////////////////////////////////////////////////////////////////////////////
->/////////////////// Prints an error message with an intuition requester /////
->/////////////////////////////////////////////////////////////////////////////
PROC error_simple( message : PTR TO CHAR ) IS EasyRequestArgs(	NIL , [ 20 , 0 ,
									'DemoGenCodeE error !' ,
									message ,
									'_OK' ] , NIL , NIL )


->/////////////////////////////////////////////////////////////////////////////
->///////////////////////// Prints an error message with an MUI requester /////
->/////////////////////////////////////////////////////////////////////////////
PROC error( message : PTR TO CHAR ) IS Mui_RequestA(	dgce.app ,
							dgce.wi_the_window ,
							NIL ,
							'DemoGenCodeE error !' ,
							'*_OK' ,
							message ,
							NIL )


->/////////////////////////////////////////////////////////////////////////////
->///////// Hook function called each time bt_call_hook button is pressed /////
->/////////////////////////////////////////////////////////////////////////////
PROC button_pressed( hook , obj , msg ) IS set( dgce.tx_result , MUIA_Text_Contents , 'Modified by called hook function !' )


->/////////////////////////////////////////////////////////////////////////////
->///////////////////// Hook function called by ARexx command change_text /////
->/////////////////////////////////////////////////////////////////////////////
PROC change_text( hook , obj , msg ) IS set( dgce.tx_result , MUIA_Text_Contents , 'Modifed by ARexx command change_text !' )


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////// Hook function called by ARexx in case of error /////
->/////////////////////////////////////////////////////////////////////////////
PROC arexx_error( hook , obj , msg ) IS error_simple( 'Unknown ARexx command recieved !' )
