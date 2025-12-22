/****************************************************************
   This file was created automatically by `FlexCat V1.3'
   Do not edit by hand!
****************************************************************/


	/* External modules */
MODULE 'locale' , 'libraries/locale'
MODULE 'utility/tagitem'

	/* Object definitions */
OBJECT fc_type
	id	:	LONG
	str	:	LONG
ENDOBJECT

	/* Global variables */
DEF catalog_DemoGenCodeE : PTR TO catalog
DEF msg_AppDescription : fc_type
DEF msg_AppCopyright : fc_type
DEF msg_WI_the_window : fc_type
DEF msg_GR_grp_0Title : fc_type
DEF msg_BT_put_constant_stringNotify0 : fc_type
DEF msg_BT_put_constant_string : fc_type
DEF msg_BT_put_variable : fc_type
DEF msg_BT_return_id : fc_type
DEF msg_BT_call_hook : fc_type
DEF msg_LA_result : fc_type
DEF msg_TX_result : fc_type
DEF msg_BT_quit : fc_type
DEF msg_Missing_Muimaster_Library : fc_type
DEF msg_Missing_Icon_Library : fc_type
DEF msg_Not_Enough_Memory : fc_type
DEF msg_Not_Enough_Chip_Memory : fc_type
DEF msg_Missing_Library : fc_type
DEF msg_Arexx_Port : fc_type
DEF msg_Internal_Problem : fc_type
DEF msg_DGCE_Error : fc_type
DEF msg_OK : fc_type
DEF msg_Simple_OK : fc_type
DEF msg_String_Variable_Put : fc_type
DEF msg_Modified_ID_Returned : fc_type
DEF msg_Modified_By_Hook : fc_type
DEF msg_Modified_By_Arexx : fc_type
DEF msg_Unknown_ARexx_Command : fc_type


	/* Opening catalog procedure */
PROC open_DemoGenCodeE_catalog( loc : PTR TO locale , language : PTR TO CHAR )

	DEF tag , tagarg

	msg_AppDescription.id := 0 ; msg_AppDescription.str := 'Application example for GenCodeE'
	msg_AppCopyright.id := 1 ; msg_AppCopyright.str := 'Public Domain !'
	msg_WI_the_window.id := 2 ; msg_WI_the_window.str := 'The window !'
	msg_GR_grp_0Title.id := 3 ; msg_GR_grp_0Title.str := 'Click !'
	msg_BT_put_constant_stringNotify0.id := 4 ; msg_BT_put_constant_stringNotify0.str := 'Constant string put !'
	msg_BT_put_constant_string.id := 5 ; msg_BT_put_constant_string.str := 'Put _Constant String'
	msg_BT_put_variable.id := 6 ; msg_BT_put_variable.str := 'Put _Variable'
	msg_BT_return_id.id := 7 ; msg_BT_return_id.str := '_Return ID'
	msg_BT_call_hook.id := 8 ; msg_BT_call_hook.str := 'Call _Hook'
	msg_LA_result.id := 9 ; msg_LA_result.str := 'Result'
	msg_TX_result.id := 10 ; msg_TX_result.str := 'Zzzzzzzzzzzzz'
	msg_BT_quit.id := 11 ; msg_BT_quit.str := '_Quit'
	msg_Missing_Muimaster_Library.id := 12 ; msg_Missing_Muimaster_Library.str := 'Can''t open muimaster.library !'
	msg_Missing_Icon_Library.id := 13 ; msg_Missing_Icon_Library.str := 'Can''t open icon.library !'
	msg_Not_Enough_Memory.id := 14 ; msg_Not_Enough_Memory.str := 'Not enough memory !'
	msg_Not_Enough_Chip_Memory.id := 15 ; msg_Not_Enough_Chip_Memory.str := 'Not enough chip memory !'
	msg_Missing_Library.id := 16 ; msg_Missing_Library.str := 'Can''t open a needed library !'
	msg_Arexx_Port.id := 17 ; msg_Arexx_Port.str := 'Can''t create arexx port !'
	msg_Internal_Problem.id := 18 ; msg_Internal_Problem.str := 'Internal problem !'
	msg_DGCE_Error.id := 19 ; msg_DGCE_Error.str := 'DemoGenCodeE error !'
	msg_OK.id := 20 ; msg_OK.str := '*_OK'
	msg_Simple_OK.id := 21 ; msg_Simple_OK.str := '_OK'
	msg_String_Variable_Put.id := 22 ; msg_String_Variable_Put.str := 'String variable put !'
	msg_Modified_ID_Returned.id := 23 ; msg_Modified_ID_Returned.str := 'Modifed by ID returned !'
	msg_Modified_By_Hook.id := 24 ; msg_Modified_By_Hook.str := 'Modified by called hook function !'
	msg_Modified_By_Arexx.id := 25 ; msg_Modified_By_Arexx.str := 'Modifed by ARexx command change_text !'
	msg_Unknown_ARexx_Command.id := 26 ; msg_Unknown_ARexx_Command.str := 'Unknown ARexx command recieved !'

	close_DemoGenCodeE_catalog()

	IF (localebase AND (catalog_DemoGenCodeE = NIL))

		IF language

			tag := OC_LANGUAGE
			tagarg := language

		ELSE

			tag:= TAG_IGNORE

		ENDIF

		catalog_DemoGenCodeE := OpenCatalogA( loc , 'DemoGenCodeE.catalog' ,
									[	OC_BUILTINLANGUAGE , 'english' ,
										tag , tagarg ,
										OC_VERSION , 0 ,
										TAG_DONE	])

	ENDIF

ENDPROC
	
	/* Closing catalog procedure */
PROC close_DemoGenCodeE_catalog()

	IF localebase THEN CloseCatalog( catalog_DemoGenCodeE )
	catalog_DemoGenCodeE := NIL

ENDPROC


	/* Procedure which returns the correct string according to the catalog */
PROC get_DemoGenCodeE_string( fcstr : PTR TO fc_type ) RETURN IF catalog_DemoGenCodeE THEN GetCatalogStr( catalog_DemoGenCodeE , fcstr.id , fcstr.str ) ELSE fcstr.str
/****************************************************************
   End of the automatically created part!
****************************************************************/
