				IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					IF makeobject = 1
						Fputs( self.file , '[ ' )
						INC makeobject
					ENDIF
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

			CASE TC_MUIARG_OBJ

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Mb_GetNextCode( {type} , {code} )

				IF inobj

					Fputs( self.file , ' ,\n' )
					return := TRUE

				ELSE

					IF func_level > 0

						IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
						return := FALSE

					ELSE

						Fputs( self.file , '\n\n')
						return := TRUE

					ENDIF

				ENDIF

			CASE TC_MUIARG_ATTRIBUT		->	same as TC_MUIARG_OBJ

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Mb_GetNextCode( {