OPT MODULE
OPT EXPORT
OPT LARGE


/*******************************
** Display an error requester **
*******************************/
PROC error_request( text_body : PTR TO CHAR ) RETURN EasyRequestArgs(	NIL ,
																		[ 20 , 0 , 'GenCodeE error' , text_body , 'OK' ] ,
																		NIL , NIL )


/**********************************************
** Idents a definition in the generated file **
**********************************************/
PROC indent_defs( file , ident : PTR TO CHAR , ident_length_max )

	DEF i

	FOR i := 0 TO ( ident_length_max - EstrLen( ident ) ) DO FputC( file , " " )

ENDPROC


/**********************************************
** Idents a definition in the generated file **
**********************************************/
PROC indent_code( file , indent_level , return )

	DEF i

	IF return THEN FOR i := 1 TO indent_level DO FputC( file , "\t" )

ENDPROC


/********************************************************************
** Convert a C string with format codes to the equivalent E string **
********************************************************************/
PROC string_convert ( raw_string : PTR TO CHAR )

	DEF converted_string1 : PTR TO CHAR
	DEF converted_string2 : PTR TO CHAR
	DEF aux_string : PTR TO CHAR
	DEF v2_vs_v1 = FALSE , char , char_value
	DEF str_pos = 0 , offset = 0

	converted_string1 := String( ( StrLen( raw_string ) * 2 ) + 2 )
	StringF( converted_string1 , '\a\s\a' , raw_string )

	IF ( InStr( raw_string , '\\' , 0 ) <> -1 ) OR ( InStr( raw_string , '\a' , 0 ) <> -1 )

		aux_string := String( StrLen( raw_string ) + 2 )
		converted_string2 := String ( StrLen( raw_string ) * 4 + 8 )
		StrAdd( converted_string2 , '[' , 1 )

		WHILE ( char := raw_string[ str_pos++ ] )

			IF char = "\\"

				char := raw_string[ str_pos++ ]

				SELECT char

					CASE "r"

						StrAdd( converted_string2 , '13,' , ALL )
						converted_string1[ str_pos + offset ] := "b"

					CASE "n"

						StrAdd( converted_string2 , '10,' , ALL )

					CASE "t"

						StrAdd( converted_string2 , '9,' , ALL )

					CASE "e"

						StrAdd( converted_string2 , '27,' , ALL )

					CASE "0"

						IF raw_string[ str_pos ]

							char_value := raw_string[ str_pos++ ] - "0"

							IF raw_string[ str_pos ]

								char_value := char_value * 8 + ( raw_string[ str_pos++ ] - "0" )
								StringF( converted_string2 , '\s\d,' , converted_string2 , char_value )

								IF char_value = 27

									MidStr( aux_string , raw_string , str_pos , ALL )
									SetStr( converted_string1 , str_pos + offset - 3 )
									StringF( converted_string1 , '\s\\e\s\a' , converted_string1 , aux_string )
									offset := offset - 2

								ELSE

									v2_vs_v1 := TRUE

								ENDIF

							ENDIF

						ENDIF

					CASE "x"

						IF raw_string[ str_pos ]

							char := raw_string[ str_pos++ ]

							IF char >= "a"

								char_value := char - "a" + 10

							ELSEIF char >= "A"

								char_value := char - "A" + 10

							ELSE

								char_value := char - "0"

							ENDIF

							IF raw_string[ str_pos ]

								char := raw_string[ str_pos++ ]

								IF char>="a"

									char_value := char_value * 16 + ( char - "a" + 10 )

								ELSEIF char>="A"

									char_value := char_value * 16 + ( char - "A" + 10 )

								ELSE

									char_value := char_value * 16 + ( char - "0" )

								ENDIF

								StringF( converted_string2 , '\s\d,' , converted_string2 , char_value )

								IF char_value=27

									MidStr( aux_string , raw_string , str_pos , ALL )
									SetStr( converted_string1 , str_pos + offset - 3 )
									StringF( converted_string1 , '\s\\e\s\a' , converted_string1 , aux_string )
									offset := offset - 2

								ELSE

									v2_vs_v1 := TRUE

								ENDIF

							ENDIF

						ENDIF

					CASE 0

						StrAdd( converted_string2 , '"\\",' , ALL )
						DEC str_pos

					DEFAULT

						StringF( converted_string2 , '\s"\c",' , converted_string2 , char )

				ENDSELECT

			ELSEIF char="'"

				StrAdd( converted_string2 , '"\a",', ALL )

				MidStr( aux_string , raw_string , str_pos , ALL )
				SetStr( converted_string1 , str_pos + offset )
				StringF( converted_string1 , '\s\a\a\s\a' , converted_string1 , aux_string )
				INC offset

			ELSE

				StringF( converted_string2 , '\s"\c",' , converted_string2 , char )

			ENDIF

		ENDWHILE

		StrAdd( converted_string2 , '0]:CHAR' , ALL )

	ENDIF

ENDPROC IF v2_vs_v1 THEN converted_string2 ELSE converted_string1
