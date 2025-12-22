OPT MODULE


->*****
->** External modules
->*****
MODULE	'*Hash'
MODULE	'*MultiPartString'
MODULE	'*TextLowLevel'


->*****
->** Exception handling
->*****
EXPORT	ENUM	BAD_NUMBER_ARGS		=	"Macr"	,
				BAD_PLACED_ENTER				,
				UNEXPECTED_END_FILE             ,
				UNBALANCED_BRACKETS				,
				CYCLE_DETECTED

RAISE	"MEM"	IF	String()	=	NIL	,
		"OUT"	IF	Fwrite()	=	0


->*****
->** Object definitions
->*****
EXPORT	OBJECT hashed_macro OF hashlink
			number_args	:	LONG
			raw_body	:	PTR TO CHAR
			body		:	PTR TO multi_part_string
			analyzed	:	LONG
		ENDOBJECT


->*****
->** Constant definitions
->*****
EXPORT	ENUM	ANALYZED		,
				DURING_ANALYSIS	,
				NOT_ANALYZED

->*****
->** Global variables
->*****
EXPORT	DEF line_number
EXPORT	DEF verbose , debug
EXPORT	DEF preanalysis


/**********************************
** Called to pre-analyze a macro **
**********************************/
EXPORT PROC pre_analyse_macro( macro : PTR TO hashed_macro , macro_hash_table )

	IF macro.analyzed <> ANALYZED

		preanalysis := TRUE

		IF verbose

			PutStr( '\tPre-analyzing "' )
			Fwrite( stdout , macro.data , macro.len , 1 )
			PutStr( '"...\n' )

		ENDIF

		IF macro.analyzed = DURING_ANALYSIS THEN Raise( CYCLE_DETECTED )

		macro.analyzed := DURING_ANALYSIS
		macro.body := analyze_string( macro.raw_body , EstrLen( macro.raw_body ) , macro_hash_table )
		IF macro.number_args THEN macro.body := separate_args( macro.body )
		macro.analyzed := ANALYZED

		IF debug THEN display_macro( macro )

		preanalysis := FALSE

	ENDIF

ENDPROC


/*************************************
** Called for each macro to save it **
*************************************/
EXPORT PROC save_macro( macro : PTR TO hashed_macro , pre_analyzed_macro_file )

	FputC( pre_analyzed_macro_file , macro.number_args )
	macro.body.save( pre_analyzed_macro_file , TRUE )

ENDPROC


/****************************************
** Called for each macro to display it **
****************************************/
EXPORT PROC display_macro( macro : PTR TO hashed_macro , dummy = NIL )

	DEF macro_name[ 100 ] : STRING , tmp_string : PTR TO CHAR , i

	StrCopy( macro_name , macro.data , macro.len )
	PutStr( '**********\n' )
	PrintF( '*** Macro : \s \n' , macro_name )
	PrintF( '*** Number of arguments : \d\n' , macro.number_args )
	PutStr( '*** Raw body of the macro :\n>> ' )

	FOR i := 0 TO ( EstrLen( macro.raw_body ) - 1 )

		IF ( macro.raw_body[ i ] >= 128 ) AND ( macro.raw_body[ i ] < 160 )

			PrintF( 'ARG\d' , macro.raw_body[ i ] - 128 )

		ELSE

			PrintF( '\c' , macro.raw_body[ i ] )

		ENDIF

	ENDFOR

	IF macro.body

		PutStr( '\n*** Pre-analyzed body of the macro :\n>> ' )
		PutStr( tmp_string := macro.body.to_estring(	[	'ARG0'	,	'ARG1'	,	'ARG2'	,	'ARG3'	,
															'ARG4'	,	'ARG5'	,	'ARG6'	,	'ARG7'	,
															'ARG8'	,	'ARG9'	,	'ARG10'	,	'ARG11'	,
															'ARG12'	,	'ARG13' ,	'ARG14'	,	'ARG15'	,
															'ARG16'	,	'ARG17'	,	'ARG18'	,	'ARG19'	,
															'ARG20'	,	'ARG21'	,	'ARG22'	,	'ARG23'	,
															'ARG24'	,	'ARG25'	,	'ARG26'	,	'ARG27'	,
															'ARG28'	,	'ARG29' ,	'ARG30'	,	'ARG31'	] ) )
		DisposeLink( tmp_string )

	ENDIF

	PutStr( '\n**********\n' )

ENDPROC


/**********************************
** Reads a macro from the memory **
**********************************/
EXPORT PROC read_macro( macro_ptr : PTR TO CHAR )

	DEF macro : PTR TO hashed_macro
	DEF dummy_body : PTR TO multi_part_string

	NEW macro
	macro.number_args := macro_ptr[]++
	macro.body := NEW dummy_body.create()
	macro_ptr := read_mps( macro_ptr , dummy_body )
	macro.analyzed := ANALYZED

ENDPROC macro_ptr , macro


/*************************************************************************************
** Searches and retrieves from the given starting pointer arguments of a macro call **
*************************************************************************************/
EXPORT PROC extract_args( call_ptr , call_end , macro_hash_table : PTR TO hashtable , macro : PTR TO hashed_macro )

	DEF string_ptr : REG PTR TO CHAR , end_string : REG , string_ptr_tmp
	DEF arg_number : REG , level_parenthesis : REG , level_bracket = 0
	DEF call_args : REG PTR TO LONG

	string_ptr := call_ptr
	end_string := call_end
	arg_number := 0
	level_parenthesis := 0
	NEW call_args[ macro.number_args ]

	IF ( string_ptr < end_string ) AND ( string_ptr[]++ = "(" )

		call_args[ 0 ] :=  string_ptr

		WHILE string_ptr < end_string

			SELECT 255 OF string_ptr[]++

				CASE "\n"

					INC line_number

					IF call_args[ arg_number ] = ( string_ptr - 1 )

						call_args[ arg_number ] := string_ptr

					ELSE

						string_ptr_tmp := string_ptr
						WHILE ( string_ptr < end_string ) AND ( string_ptr[]++ = "\n" ) DO INC line_number

						IF string_ptr = end_string THEN error_macro( macro , UNEXPECTED_END_FILE )

						IF ( string_ptr[ -1 ] <> ")" ) OR level_parenthesis

							line_number := line_number - ( string_ptr - string_ptr_tmp )
							error_macro( macro , BAD_PLACED_ENTER )

						ENDIF

						IF level_bracket THEN error_macro( macro , UNBALANCED_BRACKETS )
						IF ( arg_number + 1 ) <> macro.number_args THEN error_macro( macro , BAD_NUMBER_ARGS )
						call_args[ arg_number ] := analyze_string( call_args[ arg_number ] , string_ptr_tmp - call_args[ arg_number ] - 1 , macro_hash_table )
						RETURN string_ptr , call_args

					ENDIF

				CASE 34

					string_ptr := string_ptr + 2

				CASE ","

					IF ( level_parenthesis = 0 ) AND ( level_bracket = 0 )

						IF arg_number = macro.number_args THEN error_macro( macro , BAD_NUMBER_ARGS )
						call_args[ arg_number ] := analyze_string( call_args[ arg_number ] , string_ptr - call_args[ arg_number ] - 1 , macro_hash_table )
						INC arg_number
						call_args[ arg_number ] := string_ptr

					ENDIF

				CASE "("

					INC level_parenthesis

				CASE ")"

					IF level_parenthesis

						DEC level_parenthesis

					ELSE

						IF level_bracket THEN error_macro( macro , UNBALANCED_BRACKETS )
						IF ( arg_number + 1 ) <> macro.number_args THEN error_macro( macro , BAD_NUMBER_ARGS )
						call_args[ arg_number ] := analyze_string( call_args[ arg_number ] , string_ptr - call_args[ arg_number ] - 1 , macro_hash_table )
						RETURN string_ptr , call_args

					ENDIF

				CASE "["

					INC level_bracket

				CASE "]"

					IF level_bracket

						DEC level_bracket

					ELSE

						error_macro( macro , UNBALANCED_BRACKETS )

					ENDIF

				CASE "'"

					WHILE ( string_ptr < end_string ) AND ( string_ptr[] <> "'" ) DO INC string_ptr
					INC string_ptr

			ENDSELECT

		ENDWHILE

	ENDIF

	error_macro( macro , UNEXPECTED_END_FILE )

ENDPROC


/***********************************************************************************************************
** Replaces in "string_before" all the macro calls by their body and returns the result in "string_after" **
***********************************************************************************************************/
PROC analyze_string( string_before : PTR TO CHAR , string_before_length , macro_hash_table : PTR TO hashtable )

	DEF string_after : REG PTR TO multi_part_string
	DEF string_before_ptr : REG PTR TO CHAR , end_string_before : REG , ident_length : REG
	DEF part_start : PTR TO CHAR
	DEF macro : REG PTR TO hashed_macro
	DEF call_args : PTR TO LONG

	NEW string_after.create()

	end_string_before := string_before + string_before_length
	string_before_ptr := string_before
	part_start := string_before

	WHILE string_before_ptr < end_string_before

		IF ( ident_length := isident( string_before_ptr , end_string_before ) )

			IF ( macro := macro_hash_table.find( string_before_ptr , ident_length ) )

				IF ( string_before_ptr - part_start ) THEN string_after.add_string( part_start , string_before_ptr - part_start )
				string_before_ptr := string_before_ptr + ident_length

				IF macro.number_args

					string_before_ptr , call_args := extract_args(	string_before_ptr , end_string_before , macro_hash_table , macro )
					IF macro.analyzed THEN pre_analyse_macro( macro , macro_hash_table )
					string_after.join_mps( body_after_call( macro , call_args ) )

				ELSE

					IF ( string_before_ptr[] = "(" ) AND ( string_before_ptr < end_string_before ) THEN error_macro( macro , BAD_NUMBER_ARGS )
					IF macro.analyzed THEN pre_analyse_macro( macro , macro_hash_table )
					string_after.add_mps( macro.body )

				ENDIF

				part_start := string_before_ptr

			ELSE

				string_before_ptr := string_before_ptr + ident_length

			ENDIF

		ELSE

			IF ( string_before_ptr[] = "'" ) AND ( ( string_before_ptr[ -1 ] <> 34 ) OR ( string_before_ptr = string_before ) )

				INC string_before_ptr
				WHILE ( string_before_ptr < end_string_before ) AND ( string_before_ptr[] <> "'" ) DO INC string_before_ptr

			ENDIF

			INC string_before_ptr

		ENDIF

	ENDWHILE

	IF ( string_before_ptr - part_start ) THEN  string_after.add_string( part_start , string_before_ptr - part_start )

ENDPROC string_after


/************************************************************************************
** Returns the macro of the given macro with the given args properly placed inside **
************************************************************************************/
EXPORT PROC body_after_call( macro : PTR TO hashed_macro , call_args : PTR TO LONG )

	DEF new_body : PTR TO multi_part_string
	DEF type , string_ptr : PTR TO CHAR , string_length
	DEF i

	NEW new_body.create()

	FOR i := 0 TO ( macro.body.number_parts - 1 )

		IF ( type := macro.body.get_part( i , {string_ptr} , {string_length} ) ) = MPS_TYPE_STRING

			new_body.add_string( string_ptr , string_length )

		ELSE

			new_body.add_mps( call_args[ type ] )

		ENDIF

	ENDFOR

ENDPROC new_body


/*********************************************************************
** Separates args inside the given body from the other string parts **
*********************************************************************/
PROC separate_args( body : PTR TO multi_part_string )

	DEF new_body : REG PTR TO multi_part_string
	DEF string_ptr : REG PTR TO CHAR , string_length
	DEF string_start : PTR TO CHAR , string_end : REG
	DEF i : REG

	NEW new_body.create()

	FOR i := 0 TO ( body.number_parts - 1 )

		body.get_part( i , {string_start} , {string_length} )

		string_ptr := string_start
		string_end := string_ptr + string_length

		WHILE ( string_ptr < string_end )

			IF ( string_ptr[] >= 128 ) AND ( string_ptr[] <= 159 )

				IF ( string_ptr - string_start ) THEN new_body.add_string( string_start , string_ptr - string_start  )
				new_body.add_part( string_ptr[] - 128 )
				string_start := string_ptr + 1

			ENDIF

			INC string_ptr

		ENDWHILE

		IF ( string_ptr - string_start ) THEN new_body.add_string( string_start , string_ptr - string_start  )

	ENDFOR

ENDPROC new_body


/*********************************************************
** Raises the given exception with the right macro name **
*********************************************************/
EXPORT PROC error_macro( macro : PTR TO hashed_macro , exception )

	DEF error_macro_name : PTR TO CHAR

	error_macro_name := String( macro.len )
	Throw( exception , StrCopy( error_macro_name , macro.data , macro.len ) )

ENDPROC
