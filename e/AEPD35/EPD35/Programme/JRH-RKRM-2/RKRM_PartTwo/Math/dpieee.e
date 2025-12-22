f.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' :\tPTR TO LONG\n' )

		ENDIF

	ENDFOR

	Fputs( self.file , IF environment THEN 'ENDOBJECT\n\n\n' ELSE '\n\n' )

ENDPROC


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////// PROC put_constants /////
->/////////////////////////////////////////////////////////////////////////////
PROC put_constants( environment ) OF gui_file

	DEF i , first_constant = TRUE , previous_ident : PTR TO CHAR , offset = 0

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_IDENT

			IF first_constant

				IF environment THEN	Fputs( self.file ,
										'->//////////////////////////////////////////////////////