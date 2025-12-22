OPT MODULE


->*****
->** External modules
->*****
MODULE '*TextLowLevel'
MODULE '*MultiPartString'


->*****
->** Exception handling
->*****
EXPORT ENUM	FILE_END_REACHED	=	"MacF"	,
			INCORRECT_DEFINE				,
			WRONG_MACRO_NAME				,
			WRONG_MACRO_ARGS				,
			WRONG_MACRO_BODY

RAISE	"OPEN"	IF	Open()		=	NIL	,
		"IN"	IF	Read()		=	-1	,
		"MEM"	IF	String()	=	NIL


->*****
->** Constant definitions
->*****
EXPORT	CONST	NO_MORE_MACRO	=	-1


->*****
->** Object definitions
->*****
OBJECT arg
	name	:	LONG
	length	:	LONG
ENDOBJECT

EXPORT	OBJECT macro_file
			PRIVATE
				file			:	LONG
				file_adr		:	LONG
				file_end		:	LONG
				line_number		:	LONG
				macro_ptr		:	PTR TO CHAR
				number_args		:	LONG
				args[ 32 ]		:	ARRAY OF arg
				args_code[ 32 ]	:	ARRAY OF LONG
		ENDOBJECT


/********************************************************
** Opens the given macro file and prepares the analyse **
********************************************************/
PROC create( file_name : PTR TO CHAR ) OF macro_file HANDLE

	DEF file_length , i , string_tmp : PTR TO CHAR

	self.file := Open( file_name , OLDFILE )
	file_length := FileLength( file_name )
	self.file_adr := NewR( file_length )
	self.file_end := self.file_adr + file_length
	Read( self.file , self.file_adr , file_length )
	Close( self.file )

	self.line_number := 1
	self.macro_ptr := self.file_adr

	FOR i := 0 TO 31

		string_tmp := String( 1 )
		self.args_code[ i ] := StringF( string_tmp , '\c' , i + 128 )

	ENDFOR

EXCEPT

	IF self.file THEN Close( self.file )
	ReThrow()

ENDPROC


/***************************************************************
** Moves the "macro pointer" of this object to the next one   **
** Returns NO_MORE_MACRO if there isn't any more macro else 0 **
***************************************************************/
PROC next_macro() OF macro_file

	DEF file_end , line_number
	DEF macro_ptr : PTR TO CHAR
	DEF return = NO_MORE_MACRO

	file_end := self.file_end
	line_number := self.line_number
	macro_ptr := self.macro_ptr

		-> search the "#define" string
	MOVE.L	macro_ptr , A0
	nm_while0:
		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.W	end_search
		MOVE.B	(A0)+ , D0
	nm_while1:
		CMP.B	#"\n" , D0			-> ^macro_ptr = "\n" ?
		BNE.B	nm_no_inc_line
		INC		line_number
		BRA.B	nm_while0
	nm_no_inc_line:
		CMP.B	#"#" , D0			-> ^macro_ptr = "#" ?
		BNE.B	nm_while0

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.W	end_search
		MOVE.B	(A0)+ , D0
		CMP.B	#"d" , D0			-> ^macro_ptr = "d" ?
		BNE.B	nm_while1

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.W	end_search
		MOVE.B	(A0)+ , D0
		CMP.B	#"e" , D0			-> ^macro_ptr = "e" ?
		BNE.B	nm_while1

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.W	end_search
		MOVE.B	(A0)+ , D0
		CMP.B	#"f" , D0			-> ^macro_ptr = "f" ?
		BNE.B	nm_while1

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.B	end_search
		MOVE.B	(A0)+ , D0
		CMP.B	#"i" , D0			-> ^macro_ptr = "i" ?
		BNE.B	nm_while1

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.B	end_search
		MOVE.B	(A0)+,D0
		CMP.B	#"n" , D0			-> ^macro_ptr = "n" ?
		BNE.B	nm_while1

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.B	end_search
		MOVE.B	(A0)+ , D0
		CMP.B	#"e" , D0			-> ^macro_ptr = "e" ?
		BNE.B	nm_while1

		CMPA.L	file_end , A0		-> macro_ptr = file_end ?
		BEQ.B	define_error
		MOVE.B	(A0)+ , D0
		CMP.B	#" " , D0			-> ^macro_ptr = " " ?
		BEQ.B	define_found
		CMP.B	#"\t" , D0			-> ^macro_ptr = "\t" ?
		BEQ.W	define_found

	define_error:
		Throw( INCORRECT_DEFINE , line_number )

	define_found:
		MOVE.L	A0 , macro_ptr
		self.macro_ptr := macro_ptr
		self.line_number := line_number
		return := NIL

	end_search:

ENDPROC return


/***************************************************************************
** Reads the definition part of the current macro                         **
** Returns the macro name, its length and the number of args of the macro **
***************************************************************************/
PROC current_macro_definition() OF macro_file

	DEF macro_name : PTR TO CHAR , macro_name_length : REG
	DEF macro_ptr : REG PTR TO CHAR , file_end : REG
	DEF arg_length : REG
	DEF ident_expected : REG

	ident_expected := TRUE
	macro_ptr := self.macro_ptr
	file_end := self.file_end
	self.number_args := 0

	macro_ptr := skip_spaces_tabs( macro_ptr , file_end )

	IF macro_ptr < file_end

		IF ( macro_name_length := isident( macro_ptr , file_end ) )

			macro_name := macro_ptr
			macro_ptr := macro_ptr + macro_name_length

			IF macro_ptr < file_end

				SELECT 127 OF macro_ptr[]++

					CASE " " , "\t"

						self.macro_ptr := skip_spaces_tabs( macro_ptr , file_end )
						RETURN macro_name , macro_name_length , 0

					CASE "("

						macro_ptr := skip_spaces_tabs( macro_ptr , file_end )

						WHILE macro_ptr < file_end

							SELECT 255 OF macro_ptr[]++

								CASE ","

									IF ident_expected

										Throw( WRONG_MACRO_ARGS , self.line_number )

									ELSE

										macro_ptr := skip_spaces_tabs( macro_ptr , file_end )
										ident_expected := TRUE

									ENDIF

								CASE ")"

									IF ident_expected

										Throw( WRONG_MACRO_ARGS , self.line_number )

									ELSE

										self.macro_ptr := skip_spaces_tabs( macro_ptr , file_end )
										RETURN macro_name , macro_name_length , self.number_args

									ENDIF

								DEFAULT

									IF ( arg_length := isident( macro_ptr-- ,file_end ) )

										self.args[ self.number_args ].name := macro_ptr
										self.args[ self.number_args ].length := arg_length
										self.number_args := self.number_args + 1
										ident_expected := FALSE
										macro_ptr := macro_ptr + arg_length
										macro_ptr := skip_spaces_tabs( macro_ptr , file_end )

									ELSE

										Throw( WRONG_MACRO_ARGS , self.line_number )

									ENDIF

							ENDSELECT

						ENDWHILE

						Throw( FILE_END_REACHED , self.line_number )

					DEFAULT

						Throw( WRONG_MACRO_ARGS , self.line_number )

				ENDSELECT

			ELSE

				Throw( FILE_END_REACHED , self.line_number )

			ENDIF

		ELSE

			Throw( WRONG_MACRO_NAME , self.line_number )

		ENDIF

	ELSE

		Throw( FILE_END_REACHED , self.line_number )

	ENDIF

ENDPROC


/*********************************************
** Reads the body part of the current macro **
** Returns this body                        **
*********************************************/
PROC current_macro_body( keep_spaces ) OF macro_file

	DEF body_tmp : REG PTR TO multi_part_string , body : PTR TO CHAR
	DEF macro_ptr : REG PTR TO CHAR , file_end : REG , part_start
	DEF length : REG , arg_pos : REG
	DEF continue = FALSE , comment = FALSE

	NEW body_tmp.create()
	part_start := ( macro_ptr := self.macro_ptr )
	file_end := self.file_end

	WHILE macro_ptr < file_end

		SELECT 255 OF macro_ptr[]++

			CASE "\\"

					continue := TRUE
					comment := FALSE

			CASE "-"

					comment := TRUE
					continue := FALSE

			CASE "\n"

				self.line_number := self.line_number + 1

				IF continue

					IF ( length := macro_ptr - part_start - 2 ) THEN body_tmp.add_string( part_start , length )
					continue := FALSE
					IF keep_spaces = FALSE THEN macro_ptr := skip_spaces_tabs( macro_ptr ,file_end )
					part_start := macro_ptr

				ELSE

					IF ( length := macro_ptr - part_start - 1 ) THEN body_tmp.add_string( part_start , length )

					IF EstrLen( body := body_tmp.to_estring( self.args_code ) )

						self.macro_ptr := macro_ptr
						RETURN body

					ELSE

						self.line_number := self.line_number - 1
						Throw( WRONG_MACRO_BODY , self.line_number )

					ENDIF

				ENDIF

			CASE ">"

				IF comment

					IF ( length := macro_ptr - part_start - 2 ) THEN body_tmp.add_string( part_start , length )
					comment := FALSE

					WHILE ( macro_ptr < file_end ) AND ( macro_ptr[] <> "\n" ) DO INC macro_ptr

					IF ( macro_ptr < file_end ) AND ( macro_ptr[ -1 ] = "\\" )

						INC macro_ptr
						self.line_number := self.line_number + 1
						IF keep_spaces = FALSE THEN macro_ptr := skip_spaces_tabs( macro_ptr ,file_end )

					ENDIF

					part_start := macro_ptr

				ELSE

					continue := FALSE

				ENDIF

			DEFAULT

				continue := FALSE
				comment := FALSE

				IF ( length := isident( macro_ptr-- , file_end ) )

					arg_pos := 0
					WHILE ( arg_pos < self.number_args ) AND ( IF ( self.args[ arg_pos ].length = length ) THEN ( StrCmp( self.args[ arg_pos ].name , macro_ptr , length ) = FALSE ) ELSE TRUE ) DO INC arg_pos

					IF arg_pos < self.number_args

						IF ( macro_ptr - part_start ) THEN body_tmp.add_string( part_start , macro_ptr - part_start )
						body_tmp.add_part( arg_pos )
						part_start := ( macro_ptr := macro_ptr + length )

					ELSE

						macro_ptr := macro_ptr + length

					ENDIF

				ELSE

					INC macro_ptr

				ENDIF

		ENDSELECT

	ENDWHILE

	IF ( length := macro_ptr - part_start ) THEN body_tmp.add_string( part_start , length )

	IF EstrLen( body := body_tmp.to_estring( self.args_code ) ) = 0 THEN Throw( WRONG_MACRO_BODY , self.line_number )

ENDPROC body
