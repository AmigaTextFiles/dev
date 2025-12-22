OPT MODULE


->*****
->** External modules
->*****
MODULE 'libraries/mui'
MODULE 'tools/boopsi'
MODULE 'utility/tagitem'

MODULE '*Locale'
MODULE '*Defs'
MODULE '*GUI_MUIB'
MODULE '*Errors'


->*****
->** Error handling
->*****
RAISE	"MEM"	IF	ParsePatternNoCase()	=	-1


->*****
->** Global variables
->*****
EXPORT DEF deftII	:	PTR TO obj_app
EXPORT DEF cat		:	PTR TO catalog_DeftII
EXPORT DEF modified	:	LONG


/*****************************************************************/
/* The given string pointer is modified to point the next string */
/*****************************************************************/
PROC next_string( string_ptr_ptr : PTR TO LONG )

	^string_ptr_ptr := ^string_ptr_ptr + StrLen( ^string_ptr_ptr ) + 1

ENDPROC


/******************************/
/* Loads the preferences file */
/******************************/
EXPORT PROC load_prefs()

	DEF prefs_file , prefs_file_length , prefs_file_adr
	DEF string_ptr : PTR TO CHAR
	DEF def_tool : PTR TO default_tool
	DEF pattern_length

	prefs_file := Open( 'PROGDIR:Deft II.prefs' , OLDFILE )

	IF prefs_file <> NIL

		prefs_file_length := FileLength( 'PROGDIR:Deft II.prefs' )
		prefs_file_adr := NewR( prefs_file_length )
		Read( prefs_file , prefs_file_adr , prefs_file_length )
		string_ptr := prefs_file_adr

		IF StrCmp( string_ptr , 'DeftII_save_format_v1.0' )

			next_string( {string_ptr} )

			set( deftII.lv_paths , MUIA_List_Quiet , MUI_TRUE )
			set( deftII.lv_default_tools , MUIA_List_Quiet , MUI_TRUE )

			WHILE Char( string_ptr ) <> 0

				domethod( deftII.lv_paths , [ MUIM_List_InsertSingle , string_ptr , MUIV_List_Insert_Sorted ] )
				next_string( {string_ptr} )

			ENDWHILE

			INC string_ptr

			WHILE Char( string_ptr ) <> 0

				NEW def_tool

				def_tool.old := String( StrLen( string_ptr ) )
				StrCopy( def_tool.old , string_ptr , ALL )

				def_tool.old_raw := String ( StrLen( string_ptr ) + 2 )
				StringF( def_tool.old_raw , '\ei\s' , string_ptr )

				def_tool.pattern := FastNew( pattern_length := StrLen( def_tool.old ) * 2 + 2 )
				IF ParsePatternNoCase( def_tool.old , def_tool.pattern , pattern_length ) = 0 THEN def_tool.pattern := NIL

				next_string( {string_ptr} )

				def_tool.new := String( StrLen( string_ptr ) )
				StrCopy( def_tool.new , string_ptr , ALL )

				domethod( deftII.lv_default_tools , [ MUIM_List_InsertSingle , def_tool , MUIV_List_Insert_Sorted ] )

				next_string( {string_ptr} )

			ENDWHILE

			set( deftII.lv_default_tools , MUIA_List_Quiet , FALSE )
			set( deftII.lv_paths , MUIA_List_Quiet , FALSE )

		ELSE

	    	deftII_error( get_string( cat.msg_Wrong_Prefs_File ) )

		ENDIF

		Dispose( prefs_file_adr )
		Close( prefs_file )

	ELSE

    	deftII_error( get_string( cat.msg_Missing_Prefs_File ) )

	ENDIF

	modified := FALSE

ENDPROC


/******************************/
/* Saves the preferences file */
/******************************/
EXPORT PROC save_prefs( error_messages )

    DEF error_buf[ 81 ] : ARRAY OF CHAR , prefs_file
	DEF path_str : PTR TO CHAR
	DEF def_tool : PTR TO default_tool
	DEF i = 0 , return = 0

	prefs_file := Open( 'PROGDIR:Deft II.prefs' , NEWFILE )

	IF prefs_file <> NIL

		Fputs( prefs_file , 'DeftII_save_format_v1.0' ) ; FputC( prefs_file , 0 )

		REPEAT

			domethod( deftII.lv_paths , [ MUIM_List_GetEntry , i++ , {path_str} ] )
			IF path_str <> NIL THEN Fputs( prefs_file , path_str )
			FputC( prefs_file , 0 )

		UNTIL path_str = NIL

		i := 0

		REPEAT

			domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , i++ , {def_tool} ] )
			IF def_tool <> NIL

				Fputs( prefs_file , def_tool.old ) ; FputC( prefs_file , 0 )
				Fputs( prefs_file , def_tool.new )

			ENDIF
			FputC( prefs_file , 0 )

		UNTIL def_tool = NIL

		Close( prefs_file )
		modified := FALSE

	ELSE

	    Fault( IoErr() , NIL , error_buf , 80 )
    	IF error_messages THEN deftII_error( error_buf )
		return := 50

	ENDIF

ENDPROC return
