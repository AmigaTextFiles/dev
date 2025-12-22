/****************************************************************
   This file was created automatically by `FlexCat V1.3'
   Do not edit by hand!
****************************************************************/

OPT MODULE


->*****
->** External modules
->*****
MODULE 'locale' , 'libraries/locale'
MODULE 'utility/tagitem'


->*****
->** Object definitions
->*****
EXPORT OBJECT fc_type
	PRIVATE
		id	:	LONG
		str	:	LONG
ENDOBJECT

EXPORT OBJECT catalog_DemoGenCodeE
	PUBLIC
		msg_AppDescription		:	PTR TO fc_type
		msg_AppCopyright		:	PTR TO fc_type
		msg_WI_the_window		:	PTR TO fc_type
		msg_GR_grp_0Title		:	PTR TO fc_type
		msg_BT_put_constant_stringNotify0		:	PTR TO fc_type
		msg_BT_put_constant_string		:	PTR TO fc_type
		msg_BT_put_variable		:	PTR TO fc_type
		msg_BT_return_id		:	PTR TO fc_type
		msg_BT_call_hook		:	PTR TO fc_type
		msg_LA_result		:	PTR TO fc_type
		msg_TX_result		:	PTR TO fc_type
		msg_BT_quit		:	PTR TO fc_type
		msg_Missing_Muimaster_Library		:	PTR TO fc_type
		msg_Missing_Icon_Library		:	PTR TO fc_type
		msg_Not_Enough_Memory		:	PTR TO fc_type
		msg_Not_Enough_Chip_Memory		:	PTR TO fc_type
		msg_Missing_Library		:	PTR TO fc_type
		msg_Arexx_Port		:	PTR TO fc_type
		msg_Internal_Problem		:	PTR TO fc_type
		msg_DGCE_Error		:	PTR TO fc_type
		msg_OK		:	PTR TO fc_type
		msg_Simple_OK		:	PTR TO fc_type
		msg_String_Variable_Put		:	PTR TO fc_type
		msg_Modified_ID_Returned		:	PTR TO fc_type
		msg_Modified_By_Hook		:	PTR TO fc_type
		msg_Modified_By_Arexx		:	PTR TO fc_type
		msg_Unknown_ARexx_Command		:	PTR TO fc_type
ENDOBJECT


->*****
->** Global variables
->*****
DEF cat_DemoGenCodeE : PTR TO catalog


->*****
->** Creation procedure for fc_type object
->*****
PROC create( id , str : PTR TO CHAR ) OF fc_type

	self.id := id
	self.str := str

ENDPROC


->*****
->** Procedure which returns the correct string according to the catalog
->*****
PROC getstr() OF fc_type RETURN ( IF cat_DemoGenCodeE THEN GetCatalogStr( cat_DemoGenCodeE , self.id , self.str ) ELSE self.str )


->*****
->** Creation procedure for catalog_DemoGenCodeE object
->*****
PROC create() OF catalog_DemoGenCodeE

	DEF fct : PTR TO fc_type

	cat_DemoGenCodeE := NIL

	self.msg_AppDescription := NEW fct.create( 0 , 'Application example for GenCodeE' )
	self.msg_AppCopyright := NEW fct.create( 1 , 'Public Domain !' )
	self.msg_WI_the_window := NEW fct.create( 2 , 'The window !' )
	self.msg_GR_grp_0Title := NEW fct.create( 3 , 'Click !' )
	self.msg_BT_put_constant_stringNotify0 := NEW fct.create( 4 , 'Constant string put !' )
	self.msg_BT_put_constant_string := NEW fct.create( 5 , 'Put _Constant String' )
	self.msg_BT_put_variable := NEW fct.create( 6 , 'Put _Variable' )
	self.msg_BT_return_id := NEW fct.create( 7 , '_Return ID' )
	self.msg_BT_call_hook := NEW fct.create( 8 , 'Call _Hook' )
	self.msg_LA_result := NEW fct.create( 9 , 'Result' )
	self.msg_TX_result := NEW fct.create( 10 , 'Zzzzzzzzzzzzz' )
	self.msg_BT_quit := NEW fct.create( 11 , '_Quit' )
	self.msg_Missing_Muimaster_Library := NEW fct.create( 12 , 'Can''t open muimaster.library !' )
	self.msg_Missing_Icon_Library := NEW fct.create( 13 , 'Can''t open icon.library !' )
	self.msg_Not_Enough_Memory := NEW fct.create( 14 , 'Not enough memory !' )
	self.msg_Not_Enough_Chip_Memory := NEW fct.create( 15 , 'Not enough chip memory !' )
	self.msg_Missing_Library := NEW fct.create( 16 , 'Can''t open a needed library !' )
	self.msg_Arexx_Port := NEW fct.create( 17 , 'Can''t create arexx port !' )
	self.msg_Internal_Problem := NEW fct.create( 18 , 'Internal problem !' )
	self.msg_DGCE_Error := NEW fct.create( 19 , 'DemoGenCodeE error !' )
	self.msg_OK := NEW fct.create( 20 , '*_OK' )
	self.msg_Simple_OK := NEW fct.create( 21 , '_OK' )
	self.msg_String_Variable_Put := NEW fct.create( 22 , 'String variable put !' )
	self.msg_Modified_ID_Returned := NEW fct.create( 23 , 'Modifed by ID returned !' )
	self.msg_Modified_By_Hook := NEW fct.create( 24 , 'Modified by called hook function !' )
	self.msg_Modified_By_Arexx := NEW fct.create( 25 , 'Modifed by ARexx command change_text !' )
	self.msg_Unknown_ARexx_Command := NEW fct.create( 26 , 'Unknown ARexx command recieved !' )

ENDPROC


->*****
->** Opening catalog procedure (exported)
->*****
PROC open( loc : PTR TO locale , language : PTR TO CHAR ) OF catalog_DemoGenCodeE

	DEF tag , tagarg

	self.close()

	IF ( localebase AND ( cat_DemoGenCodeE = NIL ) )

		IF language

			tag := OC_LANGUAGE
			tagarg := language

		ELSE

			tag:= TAG_IGNORE

		ENDIF

		cat_DemoGenCodeE := OpenCatalogA( loc , 'DemoGenCodeE.catalog' ,
								[	OC_BUILTINLANGUAGE , 'english' ,
									tag , tagarg ,
									OC_VERSION , 0 ,
									TAG_DONE	] )

	ENDIF

ENDPROC


->*****
->** Closing catalog procedure
->*****
PROC close() OF catalog_DemoGenCodeE

	IF localebase THEN CloseCatalog( cat_DemoGenCodeE )
	cat_DemoGenCodeE := NIL

ENDPROC


/****************************************************************
   End of the automatically created part!
****************************************************************/
