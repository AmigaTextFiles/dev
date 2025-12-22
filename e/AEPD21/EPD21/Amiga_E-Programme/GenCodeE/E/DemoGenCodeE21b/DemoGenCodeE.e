OPT OSVERSION = 37
OPT TURBO


/* ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// External modules /////
//////////////////////////////////////////////////////////////////////////// */
MODULE 'locale'
MODULE 'icon'

PMODULE 'GUI'


/* ////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// Exception handling /////
//////////////////////////////////////////////////////////////////////////// */
RAISE	"MEM"	IF	New()	=	NIL


/* ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// Global variables /////
//////////////////////////////////////////////////////////////////////////// */
DEF dgce	:	PTR TO app_obj	/* look at GUI.e for "app_obj" object */
DEF string_var	:	PTR TO CHAR	/* used by a notification (see GUI.e line 154) */


/* ////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////// Main Procedure /////
//////////////////////////////////////////////////////////////////////////// */
PROC main() HANDLE

	DEF running = TRUE , result_domethod , signal , mui_error
	DEF arexx : app_arexx , display : app_display
	DEF change_text_hook : hook , arexx_commands : PTR TO mui_command
	DEF icon = NIL

		/* needed libraries and icon init */
	IF ( muimasterbase := OpenLibrary( 'muimaster.library' , MUIMASTER_VMIN ) ) = NIL THEN Raise( "muim" )
	IF ( iconbase := OpenLibrary( 'icon.library' , 0 ) ) THEN icon := GetDiskObject( 'PROGDIR:DemoGenCodeE' ) ELSE Raise( "icon" )

		/* exported variables init */
	string_var := 'String variable put !'

		/* MUI GUI init */
			/* in GUI.e line 17, you can see the declaration of "app_display" object */
			/* each field of this object correspond to a hook function declared in MUIBuilder */
			/* in the present case, there is only the "button_pressed" hook function (see GUI.e line 166) */
	installhook( display.button_pressed , {button_pressed} )

		/* ARexx init */
			/* for ARexx init you must fill an "app_arexx" object defined in GUI.e line 12 */
			/* this object gets 2 fields : one for the commands and one for the arexx error hook function */
	installhook( change_text_hook , {change_text} )
	arexx.commands := ( arexx_commands := New( ( SIZEOF mui_command ) * 2 ) )
	arexx_commands[].mc_name := 'change_text'
	arexx_commands[].mc_template := ''
	arexx_commands[].mc_parameters := 0
	arexx_commands[].mc_hook := change_text_hook
	installhook( arexx.error , {arexx_error} )

		/* MUI application creation */
			/* for this you call the create method (see GUI.e line 43) on the "app_obj" object */
			/* to this method, you must give the "app_display" object */
			/* and if you want (not obliged), you can give an icon, the "app_arexx" object and a menu object (obsolete) */
	IF ( dgce := create_app( display , icon , arexx , NIL ) ) = NIL THEN Raise( "MUI" )
	init_notifications_app( dgce , display )

		/* Main loop */
	WHILE running

		result_domethod := domethod( dgce.app , [ MUIM_Application_Input , {signal} ] )
		SELECT result_domethod

			CASE ID_BUTTON_PRESSED	/* see GUI.em line 37 for the definition of this ID */

				set( dgce.tx_result , MUIA_Text_Contents , 'Modifed by ID returned !' )

			CASE MUIV_Application_ReturnID_Quit

				running := FALSE

		ENDSELECT

		IF ( signal AND running ) THEN Wait( signal )

	ENDWHILE

	dispose_app( dgce )
	IF icon			THEN FreeDiskObject( icon )
	IF iconbase		THEN CloseLibrary( iconbase )
	CloseLibrary( muimasterbase )

EXCEPT

	SELECT exception

		CASE "muim"

			error_simple( 'Can''t open muimaster.library !' )

		CASE "icon"

			error_simple( 'Can''t open icon.library !' )

		CASE "MEM"

			error( 'Not enough memory !' )

		CASE "MUI"

			mui_error := Mui_Error()

			SELECT mui_error

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

	IF dgce			THEN dispose_app( dgce )
	IF icon			THEN FreeDiskObject( icon )
	IF iconbase		THEN CloseLibrary( iconbase )
	IF muimasterbase	THEN CloseLibrary( muimasterbase )

ENDPROC


/* ////////////////////////////////////////////////////////////////////////////
///////////////////// Prints an error message with an intuition requester /////
//////////////////////////////////////////////////////////////////////////// */
PROC error_simple( message : PTR TO CHAR ) RETURN EasyRequestArgs(	NIL , [ 20 , 0 ,
									'DemoGenCodeE error !' ,
									message ,
									'_OK' ] , NIL , NIL )


/* ////////////////////////////////////////////////////////////////////////////
/////////////////////////// Prints an error message with an MUI requester /////
//////////////////////////////////////////////////////////////////////////// */
PROC error( message : PTR TO CHAR ) RETURN Mui_RequestA(	dgce.app ,
								dgce.wi_the_window ,
								NIL ,
								'DemoGenCodeE error !' ,
								'*_OK' ,
								message ,
								NIL )


/* ////////////////////////////////////////////////////////////////////////////
/////////// Hook function called each time bt_call_hook button is pressed /////
//////////////////////////////////////////////////////////////////////////// */
PROC button_pressed( hook , obj , msg ) RETURN set( dgce.tx_result , MUIA_Text_Contents , 'Modified by called hook function !' )


/* ////////////////////////////////////////////////////////////////////////////
/////////////////////// Hook function called by ARexx command change_text /////
//////////////////////////////////////////////////////////////////////////// */
PROC change_text( hook , obj , msg ) RETURN set( dgce.tx_result , MUIA_Text_Contents , 'Modifed by ARexx command change_text !' )


/* ////////////////////////////////////////////////////////////////////////////
////////////////////////// Hook function called by ARexx in case of error /////
//////////////////////////////////////////////////////////////////////////// */
PROC arexx_error( hook , obj , msg ) RETURN error_simple( 'Unknown ARexx command recieved !' )


/* ////////////////////////////////////////////////////////////////////////////
///////////////////////// Directly taken from the Amiga v3.0 distribution /////
//////////////////////////////////////////////////////////////////////////// */
PROC installhook(hook,func)

	DEF return

	MOVE.L	hook,A0
	MOVE.L	func,12(A0)
	LEA	hookentry(PC),A1
	MOVE.L	A1,8(A0)
	MOVE.L	A4,16(A0)
	MOVE.L	A0,return

ENDPROC return

hookentry:
	MOVEM.L	D2-D7/A2-A6,-(A7)
	MOVE.L	16(A0),A4
	MOVE.L	A0,-(A7)
	MOVE.L	A2,-(A7)
	MOVE.L	A1,-(A7)
	MOVE.L	12(A0),A0
	JSR	(A0)
	LEA	12(A7),A7
	MOVEM.L	(A7)+,D2-D7/A2-A6
	RTS
