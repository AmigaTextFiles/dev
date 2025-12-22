uts( self.file , self.main_object_ident )
			Fputs( self.file , '_display\n' )

		ENDIF

		FOR i := 0 TO ( self.number_vars - 1 )

			IF self.vars[ i ].type = TYPEVAR_HOOK

				FputC( self.file , "\t" )
				Fputs( self.file , self.vars[ i ].ident )
				indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
				Fputs( self.file , ' :\thook\n' )

			ENDIF

		ENDFOR

		IF environment THEN Fputs( self.file , 'ENDOBJECT\n\n' ) ELSE FputC( self.file , "\n" )

	ENDIF

ENDPROC


->/////////////////////////////////////////////////////////////////////////////
->////////////////////////////////////////////////// PROC put_main_object /////
->/////////////////////////////////////////////////////////////////////////////
PROC put_main_object( environment ) OF gui_file

	DEF i

	IF environment

		Fputs( self.file , 'EXPORT OBJECT ' )
		Fputs( self.file , self.main_object_ident )
		