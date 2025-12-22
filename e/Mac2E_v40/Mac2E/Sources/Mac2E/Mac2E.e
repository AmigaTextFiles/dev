OPT OSVERSION=37


->*****
->** External modules
->*****
MODULE	'*TextLowLevel'
MODULE	'*MultiPartString'
MODULE	'*Hash'
MODULE	'*MacroFile'
MODULE	'*Macros'


->*****
->** Exception handling
->*****
ENUM	DOUBLE_DECLARATION	=	"main"	,
		ARGS_SENSLESS					,
		PREANALYSIS_AND_WITH			,
		VERBOSE_AND_DEBUG				,
		FORGOTTEN_SOMETHING

RAISE	"ARGS"	IF	ReadArgs()	=	NIL		,
		"^C"	IF	CtrlC()		=	TRUE	,
		"OPEN"	IF	Open()		=	NIL		,
		"IN"	IF	Read()		=	-1		,
		"OUT"	IF	Fwrite()	=	0


->*****
->** Global variables
->*****
DEF line_number
DEF verbose , debug
DEF preanalysis


/*******************
** Main procedure **
*******************/
PROC main() HANDLE

	DEF rdargs , args : PTR TO LONG
	DEF macro_hash_table : PTR TO hashtable
	DEF macro_file_arg : PTR TO macro_file
	DEF macro_files : PTR TO LONG

	PrintF( '              \c1;33;40\cMac2E\c0;31;40\c v4.0\n' , $9B , $6D , $9B , $6D )
	PutStr( 'Copyright © 1993, 1994, Lionel Vintenat\n' )
	PrintF( '\c1;32;40\c---------------------------------------\c0;31;40\c\n' , $9B , $6D , $9B , $6D )

	SetIoErr( 0 )

	args := [ NIL , NIL , NIL , FALSE , FALSE , FALSE , FALSE ]
	rdargs := ( rdargs := NIL ) BUT ReadArgs( 'FROM/A,TO/A,WITH/M,PA=PREANALYZE/S,VER=VERBOSE/S,KS=KEEPSPACES/S,DEBUG/S' , args , NIL )

	verbose := args[ 4 ]
	debug := args[ 6 ]

	IF verbose AND debug THEN Throw( ARGS_SENSLESS , VERBOSE_AND_DEBUG )

	NEW macro_hash_table.hashtable( HASH_HEAVY )

	IF args[ 3 ]

		IF args[ 2 ] THEN Throw( ARGS_SENSLESS , PREANALYSIS_AND_WITH )

		NEW macro_file_arg.create( args[ 0 ] )

		PrintF( 'Analysing macro file "\s"...\n' , args[ 0 ] )
		analyze_macro_file( macro_file_arg , macro_hash_table , args[ 5 ] )

		PutStr( 'Replacing macro calls inside macro bodies...\n' )
		macro_hash_table.iterate( {pre_analyse_macro} , macro_hash_table )

		PrintF( 'Writing pre-analyzed macro file "\s"...\n' , args[ 1 ] )
		save_pre_analyzed_macro_file( args[ 1 ] , macro_hash_table )

	ELSE

		IF ( macro_files := args[ 2 ] ) = NIL THEN Throw( ARGS_SENSLESS , FORGOTTEN_SOMETHING )

		WHILE macro_files[] DO load_macro_file( macro_hash_table , macro_files[]++ , args[ 5 ] )

		PrintF( 'Macro preprocessing "\s" to "\s"...\n' , args[ 0 ] , args[ 1 ] )
		preprocess_source( args[ 0 ] , args[ 1 ] , macro_hash_table )

	ENDIF

	FreeArgs( rdargs )

EXCEPT

	SELECT exception

		CASE "MEM"

			PutStr( 'Out of memory !\n' )

		CASE "ARGS"

			PrintFault( IoErr() , NIL )

		CASE "OPEN"

			PrintFault( IoErr() , NIL )

		CASE "IN"

			PrintFault( IoErr() , NIL )

		CASE "OUT"

			PrintFault( IoErr() , NIL )

		CASE "^C"

			PutStr( '***** Ctrl-C interrupt *****\n' )

		CASE FILE_END_REACHED

			PrintF( 'Macro file ends in the middle of a macro definition in line \d !\n' , exceptioninfo )

		CASE INCORRECT_DEFINE

			PrintF( 'Missing space or tabulation after #define in line \d !\n' , exceptioninfo )

		CASE WRONG_MACRO_NAME

			PrintF( 'Wrong macro name in line \d !\n' , exceptioninfo )

		CASE WRONG_MACRO_ARGS

			PrintF( 'Error in the declaration of the macro arguments in line \d !\n' , exceptioninfo )

		CASE WRONG_MACRO_BODY

			PrintF( 'Null body found in line \d !\n' , exceptioninfo )

		CASE DOUBLE_DECLARATION

			PrintF( '"\s" macro is defined twice !\n' , exceptioninfo )

		CASE BAD_NUMBER_ARGS

			IF args[ 3 ] OR preanalysis

				PrintF( 'Wrong number of arguments in "\s" call !\n' , exceptioninfo )

			ELSE

				PrintF( 'Wrong number of arguments in "\s" call in line \d !\n' , exceptioninfo , line_number )

			ENDIF

		CASE BAD_PLACED_ENTER

			PrintF( 'Bad placed ENTER in "\s" call in line \d !\n' , exceptioninfo , line_number )

		CASE UNEXPECTED_END_FILE

			IF args[ 3 ] OR preanalysis

				PrintF( 'Unexpected end of body in "\s" call !\n' , exceptioninfo )

			ELSE

				PrintF( 'Unexpected end of file in "\s" call in line \d !\n' , exceptioninfo , line_number )

			ENDIF

		CASE UNBALANCED_BRACKETS

			PrintF( 'Unbalanced brackets in "\s" call in line \d !\n' , exceptioninfo , line_number )

		CASE CYCLE_DETECTED

			PutStr( 'Cycle detected with macro dependencies !\n' )

		CASE ARGS_SENSLESS

			SELECT exceptioninfo

				CASE PREANALYSIS_AND_WITH

					PutStr( 'For a pre-analysis, only ONE macro file and a destination file can be specified !\n' )

				CASE VERBOSE_AND_DEBUG

					PutStr( 'VERBOSE mode is useless when DEBUG mode is already specified !\n' )

				CASE FORGOTTEN_SOMETHING

					PutStr( 'Hum... Are you sure you haven''t forgotten something in the command line ? ;-)\n' )

			ENDSELECT

	ENDSELECT

	IF rdargs THEN FreeArgs( rdargs )

	CleanUp( 100 )

ENDPROC


/*******************
** String version **
*******************/
CHAR '$VER: Mac2E 4.0 (02.09.94)' , 0


/**********************************
** Analyzes the given macro file **
**********************************/
PROC analyze_macro_file( macro_file_to_analyse : PTR TO macro_file , macro_hash_table : PTR TO hashtable , keepspaces )

	DEF macro_name : REG PTR TO CHAR , macro_name_length : REG , number_args : REG
	DEF macro : REG PTR TO hashed_macro , hash_value : REG

	WHILE macro_file_to_analyse.next_macro() <> NO_MORE_MACRO

		CtrlC()

		macro_name , macro_name_length , number_args := macro_file_to_analyse.current_macro_definition()
		macro , hash_value := macro_hash_table.find( macro_name , macro_name_length )

		IF macro

			error_macro( macro , DOUBLE_DECLARATION )

		ELSE

			macro_hash_table.add( NEW macro , hash_value , macro_name , macro_name_length )
			macro.number_args := number_args
			macro.raw_body := macro_file_to_analyse.current_macro_body( keepspaces )
			macro.analyzed := NOT_ANALYZED

		ENDIF

	ENDWHILE

ENDPROC


/********************************************************
** Saves all the macros in the pre-analyzed macro file **
********************************************************/
PROC save_pre_analyzed_macro_file( pre_analyzed_macro_file_name : PTR TO CHAR , macro_hash_table : PTR TO hashtable ) HANDLE

	DEF pre_analyzed_macro_file = NIL

    pre_analyzed_macro_file := Open( pre_analyzed_macro_file_name , NEWFILE )
    Fwrite( pre_analyzed_macro_file , 'PreMac2E_Save_Format_V2.0' , STRLEN , 1 )	;	FputC( pre_analyzed_macro_file , 0 )

	macro_hash_table.save( pre_analyzed_macro_file , {save_macro} )

    Close( pre_analyzed_macro_file )

EXCEPT

	IF pre_analyzed_macro_file

		Close( pre_analyzed_macro_file )
		DeleteFile( pre_analyzed_macro_file_name )

	ENDIF

	ReThrow()

ENDPROC


/************************************************************
** Loads a macro file and adds its contents the hash table **
************************************************************/
PROC load_macro_file( macro_hash_table : PTR TO hashtable , file_name : PTR TO CHAR , keepspaces ) HANDLE

	DEF file = NIL , file_length , file_adr , file_end
	DEF macro_file_arg : PTR TO macro_file

	file := Open( file_name , OLDFILE )
	file_length := FileLength( file_name )
	file_adr := NewR( file_length )
	file_end := file_adr + file_length
	Read( file , file_adr , file_length )
	Close( file ) BUT ( file := NIL )

	IF StrCmp( file_adr , 'PreMac2E_Save_Format_V2.0' , ALL )

		PrintF( 'Loading pre-analysed macro file "\s"...\n' , file_name )
		macro_hash_table.read( file_adr + 26 , {read_macro} )

	ELSE

		Dispose( file_adr )
		NEW macro_file_arg.create( file_name )
		PrintF( 'Analysing macro file "\s"...\n' , file_name )
		analyze_macro_file( macro_file_arg , macro_hash_table , keepspaces )

	ENDIF

EXCEPT

	IF file THEN Close( file )
	ReThrow()

ENDPROC


/****************************************************************************************************************
** Replaces in the source file all the macro calls by their body and writes the result to the destination file **
****************************************************************************************************************/
PROC preprocess_source( source_file_name : PTR TO CHAR , destination_file_name : PTR TO CHAR , macro_hash_table : PTR TO hashtable ) HANDLE

	DEF file = NIL , file_length , file_adr , file_end

	file := Open( source_file_name , OLDFILE )
	file_length := FileLength( source_file_name )
	file_adr := NewR( file_length )
	file_end := file_adr + file_length
	Read( file , file_adr , file_length )
	Close( file ) BUT ( file := NIL )

	file := Open( destination_file_name , NEWFILE )
	preprocess( file , file_adr , file_end , macro_hash_table )
	Close( file )

EXCEPT

	IF file

		Close( file )
		DeleteFile( destination_file_name )

	ENDIF

	ReThrow()

ENDPROC


/****************************************************************************************************************
** Replaces in the source file all the macro calls by their body and writes the result to the destination file **
****************************************************************************************************************/
PROC preprocess( file , source_start : PTR TO CHAR , source_end , macro_hash_table : PTR TO hashtable )

	DEF source_ptr : REG PTR TO CHAR , source_limit : REG
	DEF source_part_start : PTR TO CHAR , ident_length : REG
	DEF macro : REG PTR TO hashed_macro , call_args : PTR TO LONG
	DEF preprocessed_source : REG PTR TO multi_part_string

	line_number := 1
	NEW preprocessed_source.create()
	source_ptr := ( source_part_start := source_start )
	source_limit := source_end

	WHILE source_ptr < source_end

		SELECT 255 OF source_ptr[]++

			CASE "\n"

				INC line_number

			CASE "/"

				MOVE.L	source_ptr , A0
				CMP.L	A0 , source_limit
				BEQ.W	end1
				CMP.B	#"*" , (A0)
				BNE.W	end1
				ADDQ.L	#1 , A0
				MOVE.B	#1 , D2

				while1:
					TST.B	D2
					BEQ.B	end_while1
					CMP.L	A0 , source_limit
					BEQ.B	end_while1

					while2:
						MOVE.B	(A0)+ , D0
					while2_:
						CMP.B	#10 , D0
						BNE.B	no_add_line1
						INC		line_number
						no_add_line1:
						CMP.L	A0 , source_limit
						BEQ.B	end_while1
						CMP.B	#"*" , D0
						BNE.B	no_star
						MOVE.B	(A0)+ , D0
						CMP.B	#"/" , D0
						BNE.B	while2_
						SUBQ.B	#1 , D2
						BRA.B	while1
						no_star:
						CMP.B	#"/" , D0
						BNE.B	while2
						MOVE.B	(A0)+ , D0
						CMP.B	#"*" , D0
						BNE.B	while2_
						ADDQ.B	#1 , D2
						BRA.B	while1
					end_while1:

					MOVE.L	A0 , source_ptr
				end1:

			CASE "'"

				MOVE.L	source_ptr , A0
				CMP.B	#34 , -2(A0)
				BNE.B	while3
				MOVE.L	source_start , A2
				ADDQ.L	#1 , A2
				CMPA.L	A0 , A2
				BNE.B 	end2

				while3:
					CMP.L	A0 , source_limit
					BEQ.B	end_while3
					CMP.B	#"'" , (A0)+
					BNE.B	while3
				end_while3:

				MOVE.L	A0 , source_ptr
				end2:

			CASE "-"

				MOVE.L	source_ptr , A0
				CMP.L	A0 , source_limit
				BEQ.B	end3
				CMP.B	#">" , (A0)
				BNE.B	end3
				ADDQ.L	#1 , A0

				while4:
					CMP.L	A0 , source_limit
					BEQ.B	end_while4
					CMP.B	#"\n" , (A0)+
					BNE.B	while4
					INC		line_number
				end_while4:

				MOVE.L	A0 , source_ptr
				end3:

            DEFAULT

				IF ( ident_length := isident( source_ptr-- , source_limit ) )

					IF ( macro := macro_hash_table.find( source_ptr , ident_length ) )

						CtrlC()
						preprocessed_source.add_string( source_part_start ,  source_ptr - source_part_start )
						source_ptr := source_ptr + ident_length

						IF macro.number_args

							source_ptr , call_args := extract_args( source_ptr , source_limit , macro_hash_table , macro )
							IF macro.analyzed THEN pre_analyse_macro( macro , macro_hash_table )
							preprocessed_source.join_mps( body_after_call( macro , call_args ) )

						ELSE

							IF ( source_ptr[] = "(" ) AND ( source_ptr < source_limit ) THEN error_macro( macro , BAD_NUMBER_ARGS )
							IF macro.analyzed THEN pre_analyse_macro( macro , macro_hash_table )
							preprocessed_source.add_mps( macro.body )

						ENDIF

						source_part_start := source_ptr

					ELSE

						source_ptr := source_ptr + ident_length

					ENDIF

				ELSE

					INC source_ptr

				ENDIF

		ENDSELECT

	ENDWHILE

	CtrlC()
	preprocessed_source.add_string( source_part_start ,  source_ptr - source_part_start )
	preprocessed_source.write( file )

ENDPROC
