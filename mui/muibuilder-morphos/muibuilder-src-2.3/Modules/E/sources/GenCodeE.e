OPT OSVERSION=37
OPT PREPROCESS


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////////////// MODULE ... /////
->/////////////////////////////////////////////////////////////////////////////
MODULE 'muibuilder' , 'libraries/muibuilder'
MODULE 'utility/tagitem'

MODULE '*MUIStrings'
MODULE '*AuxProcs'
MODULE '*Variable'
MODULE '*GUIFile'


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////// RAISE ... IF ... = ... /////
->/////////////////////////////////////////////////////////////////////////////
RAISE	"LIB"	IF	OpenLibrary()	=	NIL	,
		"MBtf"	IF	Mb_Open()		=	NIL	,
		"MEM"	IF	String()		=	NIL


->/////////////////////////////////////////////////////////////////////////////
->///////////////////////////////////////////////////////////// PROC main /////
->/////////////////////////////////////////////////////////////////////////////
PROC main() HANDLE

	DEF application = FALSE , declarations = FALSE , code = FALSE
	DEF notifications = FALSE , environment = FALSE , locale = FALSE
	DEF filename : PTR TO CHAR , catalog_filename : PTR TO CHAR
	DEF catalog_name : PTR TO CHAR , getstring_func : PTR TO CHAR
	DEF number_vars , vars : PTR TO variable , ident_length_max
	DEF genfile = NIL : PTR TO gui_file
	DEF tmp_string : PTR TO CHAR

	muibbase := OpenLibrary( 'muibuilder.library' , 0 )
	Mb_Open()

	Mb_GetA( [	MUIB_VARNUMBER		, {number_vars}			,
				MUIB_APPLICATION	, {application}			,
				MUIB_DECLARATIONS	, {declarations}		,
				MUIB_CODE			, {code}				,
				MUIB_NOTIFICATIONS	, {notifications}		,
				MUIB_ENVIRONMENT	, {environment}			,
				MUIB_LOCALE			, {locale}				,
				MUIB_FILENAME		, {filename}			,
				MUIB_CATALOGNAME	, {catalog_filename}	,
				MUIB_GETSTRINGNAME	, {getstring_func}		,
				TAG_END ] )

	tmp_string := filename
	filename := String( StrLen( filename ) + 2 )
	StringF( filename , '\s.e' , tmp_string )

	catalog_filename := FilePart( catalog_filename )
	catalog_name := String( StrLen( catalog_filename ) + 5 )
	StringF( catalog_name , 'catalog_\s' , catalog_filename )

	vars , ident_length_max := init_variables( number_vars )

	NEW genfile.open( filename , number_vars , vars , ident_length_max )

	IF declarations

		IF environment THEN genfile.put_header( application , locale )
		genfile.put_aux_objects( environment , application )
		genfile.put_main_object( environment )
		genfile.put_constants( environment )
		genfile.put_global_vars( environment , locale , catalog_name )

	ENDIF

	IF code

		IF environment THEN genfile.put_create_declaration( application )
		IF environment THEN genfile.put_create_local_defs()
		IF environment THEN genfile.put_create_initialisations( locale , getstring_func )
		genfile.put_code( getstring_func , muistrings_contents() )
		IF environment THEN genfile.put_create_end()
		IF environment THEN genfile.put_dispose_method()

	ENDIF

	IF notifications

		IF environment THEN genfile.put_init_notifications_declaration()
		genfile.put_notifications( muistrings_contents() , getstring_func )
		IF environment THEN genfile.put_init_notifications_end()

	ENDIF

	IF environment AND locale THEN genfile.put_aux_funcs()

EXCEPT DO

	SELECT exception

		CASE "MEM"

			error_request( 'Out of memory !' )

		CASE "LIB"

			error_request( 'Can''t open muibuilder.library !' )

		CASE "MBtf"

			error_request( 'Unable to get temporary files !' )

		CASE "OPEN"

			error_request( 'Unable to open file to generate !' )

		CASE "OUT"

			error_request( 'Trouble writing file to generate !' )

	ENDSELECT

	IF genfile	THEN genfile.close()
	IF muibbase	THEN Mb_Close()
	IF muibbase	THEN CloseLibrary( muibbase )

ENDPROC


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////////// Version string /////
->/////////////////////////////////////////////////////////////////////////////
CHAR '$VER: GenCodeE 2.4 (12.9.95)' , 0
