			Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , '( ' )
				return := FALSE
				Mb_GetNextCode( {type} , {code} )

			CASE TC_OBJFUNCTION

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , '( ' )
				INC func_level
				return := FALSE
				objfunction := TRUE
				IF Val( code ) = 750 THEN INC makeobject
				Mb_GetNextCode( {type} , {code} )

			CASE TC_MUIARG_OBJFUNCTION		->	same as TC_OBJFUNCTION

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , '( ' )
				INC func_level
				return := FALSE
				objfunction := TRUE
				Mb_GetNextCode( {type} , {code} 