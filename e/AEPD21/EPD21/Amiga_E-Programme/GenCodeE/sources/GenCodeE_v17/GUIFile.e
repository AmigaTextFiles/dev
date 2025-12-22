OPT MODULE
OPT LARGE


->*****
->** External modules
->*****
MODULE 'muibuilder' , 'libraries/muibuilder'

MODULE '*Variable'
MODULE '*AuxProcs'


->*****
->** Exception handling
->*****
RAISE	"OPEN"	IF	Open()		=	NIL	,
		"OUT"	IF	Fputs()		=	-1	,
		"OUT"	IF	FputC()		=	-1	,
		"MEM"	IF	String()	=	NIL


->*****
->** Object definitions
->*****
EXPORT	OBJECT gui_file
			PRIVATE
				file				:	LONG
				number_vars			:	LONG
				vars				:	PTR TO variable
				ident_length_max	:	LONG
				hook_funcs			:	LONG
				main_object_ident	:	PTR TO CHAR
		ENDOBJECT


/***********************************
** Opens the GUI file to generate **
***********************************/
PROC open( filename : PTR TO CHAR , number_vars , vars : PTR TO variable , ident_length_max ) OF gui_file

	DEF i

	self.file := Open( filename , NEWFILE )
	self.number_vars := number_vars
	self.vars := vars
	self.ident_length_max := ident_length_max
	self.main_object_ident := vars[ 0 ].ident
	self.hook_funcs := FALSE

	FOR i := 0 TO ( number_vars - 1 ) DO IF vars[ i ].type = TYPEVAR_HOOK THEN self.hook_funcs := TRUE

ENDPROC


/************************************
** Closes the GUI file to generate **
************************************/
PROC close() OF gui_file

	IF self.file THEN Close( self.file )

ENDPROC


/******************************************
** Write to the GUI file its header part **
******************************************/
PROC put_header( application ) OF gui_file

	Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
	Fputs( self.file , '//////////////////////////////////////////////////////// External modules /////\n' )
	Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
	Fputs( self.file , 'MODULE ''muimaster'' , ''libraries/mui''\n' )
	Fputs( self.file , 'MODULE ''intuition/classes'', ''intuition/classusr''\n' )
	Fputs( self.file , 'MODULE ''utility/tagitem''' )

	Fputs( self.file , IF ( self.hook_funcs OR application ) THEN ' , ''utility/hooks''\n\n\n' ELSE '\n\n\n' )

ENDPROC


/*********************************************************
** Write to the GUI file the definitions of aux objects **
*********************************************************/
PROC put_aux_objects( environment , application ) OF gui_file

	DEF i

	IF environment

		Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
		Fputs( self.file , '////////////////////////////////////////////////////// Object definitions /////\n' )
		Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )

		IF application

			Fputs( self.file , 'OBJECT app_arexx\n' )
			Fputs( self.file , '\tcommands :\tLONG\n' )
			Fputs( self.file , '\terror    :\thook\n' )
			Fputs( self.file , 'ENDOBJECT\n\n' )

		ENDIF

	ENDIF

	IF self.hook_funcs

		IF environment

			Fputs( self.file , 'OBJECT ' )
			Fputs( self.file , self.main_object_ident )
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


/*****************************************************************
** Write to the GUI file the definition of the generated object **
*****************************************************************/
PROC put_main_object( environment ) OF gui_file

	DEF i

	IF environment

		Fputs( self.file , 'OBJECT ' )
		Fputs( self.file , self.main_object_ident )
		Fputs( self.file , '_obj\n' )

	ENDIF

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_PTR

			FputC( self.file , "\t" )
			Fputs( self.file , self.vars[ i ].ident )
			indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' :\tLONG\n' )

		ENDIF

	ENDFOR

	FOR i := 0 TO ( self.number_vars - 1 )

		IF ( self.vars[ i ].type = TYPEVAR_INT ) AND ( self.vars[ i ].type = TYPEVAR_BOOL )

			FputC( self.file , "\t" )
			Fputs( self.file , self.vars[ i ].ident )
			indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' :\tLONG\n' )

		ENDIF

	ENDFOR

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_STRING

			FputC( self.file , "\t" )
			Fputs( self.file , self.vars[ i ].ident )
			indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' :\tLONG\n' )

		ENDIF

	ENDFOR

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_TABSTRING

			FputC( self.file , "\t" )
			Fputs( self.file , self.vars[ i ].ident )
			indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' :\tLONG\n' )

		ENDIF

	ENDFOR

	Fputs( self.file , IF environment THEN 'ENDOBJECT\n\n\n' ELSE '\n\n' )

ENDPROC


/***********************************************************************************
** Write to the GUI file the definitions of the constants used with MUIM_ReturnID **
***********************************************************************************/
PROC put_constants( environment ) OF gui_file

	DEF i , first_constant = TRUE , previous_ident : PTR TO CHAR , offset = 0

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_IDENT

			IF first_constant

				IF environment

					Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
					Fputs( self.file , '//////////////////////////////////////////////////// Constant definitions /////\n' )
					Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
					Fputs( self.file , 'ENUM ' )

				ENDIF

				Fputs( self.file , self.vars[ i ].ident )
				Fputs( self.file , ' = 1' )
				previous_ident := self.vars[ i ].ident
				first_constant := FALSE

			ELSE

				indent_defs( self.file , previous_ident , self.ident_length_max + offset )
				Fputs( self.file , ' ,\n     ' )
				Fputs( self.file , self.vars[ i ].ident )
				offset := 4
				previous_ident := self.vars[ i ].ident

			ENDIF

		ENDIF

	ENDFOR

	IF first_constant = FALSE THEN Fputs( self.file , '\n\n\n' )

ENDPROC


/*************************************************************
** Write to the GUI file the declaration of create() method **
*************************************************************/
PROC put_create_declaration( application ) OF gui_file

	Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
	Fputs( self.file , '///////////// Creates one instance of one object or the whole application /////\n' )
	Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
	Fputs( self.file , 'PROC create_' )
	Fputs( self.file , self.main_object_ident )
	FputC( self.file , "(" )

	IF application

		IF self.hook_funcs

			Fputs( self.file , ' display : PTR TO ' )
			Fputs( self.file , self.main_object_ident )
			Fputs( self.file , '_display ,\n            ' )

		ENDIF

		Fputs( self.file , ' icon ,\n' )
		Fputs( self.file , '             arexx : PTR TO app_arexx ,\n' )
		Fputs( self.file , '             menu ' )

	ELSE

		IF self.hook_funcs

			Fputs( self.file , ' display : PTR TO ' )
			Fputs( self.file , self.main_object_ident )
			Fputs( self.file , '_display ' )

		ENDIF

	ENDIF

	Fputs( self.file , ')\n\n' )

ENDPROC


/********************************************************************
** Write to the GUI file the local declarations of create() method **
********************************************************************/
PROC put_create_local_defs() OF gui_file

	DEF i , defs_string[ 70 ] : STRING

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_LOCAL_PTR

			IF ( EstrLen( defs_string ) + StrLen ( self.vars[ i ].ident ) ) <= 57

				IF EstrLen( defs_string ) <> 0 THEN StrAdd( defs_string , ' , ' )
				StrAdd( defs_string , self.vars[ i ].ident )

			ELSE

				Fputs( self.file, '\tDEF ' )
				Fputs( self.file, defs_string )
				FputC( self.file , "\n" )
				SetStr( defs_string , 0 )
				StrAdd( defs_string , self.vars[ i ].ident )

			ENDIF

		ENDIF
			
	ENDFOR

	IF EstrLen( defs_string ) <> 0

		Fputs( self.file , '\tDEF ' )
		Fputs( self.file , defs_string )
		FputC( self.file , "\n" )

	ENDIF

	Fputs( self.file , '\tDEF tmp_object : PTR TO ' )
	Fputs( self.file , self.main_object_ident )
	Fputs( self.file , '_obj\n\n' )

ENDPROC


/********************************************************************
** Write to the GUI file the local declarations of create() method **
********************************************************************/
PROC put_create_initialisations( locale , getstring_func : PTR TO CHAR ) OF gui_file

	DEF i , j , initialisations = FALSE
	DEF strptr : PTR TO CHAR

	Fputs( self.file , '\tIF ( tmp_object := New( SIZEOF ' )
	Fputs( self.file , self.main_object_ident )
	Fputs( self.file , '_obj ) ) = NIL THEN RETURN NIL\n\n' )

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type =TYPEVAR_STRING

			initialisations := TRUE

			Fputs( self.file , '\ttmp_object.' )
			Fputs( self.file , self.vars[ i ].ident )
			indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' := ' )

			IF Char( self.vars[ i ].init ) <> 0

				IF locale

					Fputs( self.file , getstring_func )
					Fputs( self.file , '( ' )
					Fputs( self.file , self.vars[ i ].init )
					Fputs( self.file , ' )\n' )

				ELSE

					Fputs( self.file , string_convert( self.vars[ i ].init ) )
					FputC( self.file , "\n" )

				ENDIF

			ELSE

				Fputs( self.file , 'NIL\n' )

			ENDIF

		ENDIF

	ENDFOR

	FOR i := 0 TO ( self.number_vars - 1 )

		IF self.vars[ i ].type = TYPEVAR_TABSTRING

			initialisations := TRUE

			Fputs( self.file , '\ttmp_object.' )
			Fputs( self.file , self.vars[ i ].ident )
			indent_defs( self.file , self.vars[ i ].ident , self.ident_length_max )
			Fputs( self.file , ' := [ ' )
			strptr := self.vars[ i ].init

			FOR j := 1 TO self.vars[ i ].size

				IF locale

					Fputs( self.file , getstring_func )
					Fputs( self.file , '( ' )
					Fputs( self.file , strptr )
					Fputs( self.file , ' ) ,\n\t\t' )

				ELSE

					Fputs( self.file , string_convert( strptr ) )
					Fputs( self.file , ' ,\n\t\t' )

				ENDIF

				strptr := strptr + StrLen( strptr ) + 1

			ENDFOR

			Fputs( self.file , 'NIL ]\n' )

		ENDIF

	ENDFOR

	IF initialisations THEN FputC( self.file , "\n" )

ENDPROC


/************************************************
** Write to the GUI file all the creating code **
************************************************/
PROC put_code( getstring_func : PTR TO CHAR , muistrings : PTR TO LONG ) OF gui_file

	DEF type , code
	DEF indent_level = 1 , func_level = 0
	DEF return = TRUE , objfunction = FALSE , inobj = FALSE

	Mb_GetNextCode( {type} , {code} )

	WHILE type <> -1

		SELECT type

			CASE TC_CREATEOBJ

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , ' ,\n' )
				INC indent_level
				return := TRUE
				inobj := TRUE

				IF Val( code ) = 113

					indent_code( self.file , indent_level , return )
					Fputs( self.file , '( IF icon THEN MUIA_Application_DiskObject ELSE TAG_IGNORE ) , icon ,\n' )

					indent_code( self.file , indent_level , return )
					Fputs( self.file , '( IF arexx THEN MUIA_Application_Commands ELSE TAG_IGNORE ) , ( IF arexx THEN arexx.commands ELSE NIL ) ,\n' )

					indent_code( self.file , indent_level , return )
					Fputs( self.file , '( IF arexx THEN MUIA_Application_RexxHook ELSE TAG_IGNORE ) , ( IF arexx THEN arexx.error ELSE NIL ) ,\n' )

					indent_code( self.file , indent_level , return )
					Fputs( self.file , '( IF menu THEN MUIA_Application_Menu ELSE TAG_IGNORE ) , menu ,\n' )

				ENDIF

				Mb_GetNextCode( {type} , {code} )

			CASE TC_ATTRIBUT

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , ' , ')
				return := FALSE
				Mb_GetNextCode( {type} , {code} )

			CASE TC_END

				DEC indent_level
				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , '\n\n')
				inobj := FALSE
				return := TRUE
				Mb_GetNextCode( {type} , {code} )

			CASE TC_FUNCTION

				indent_code( self.file , indent_level , return )

				IF Val( code ) = 673

					FputC( self.file , 34 )
					Mb_GetNextCode( {type} , {code} )
					Fputs( self.file , code )
					Mb_GetNextCode( {type} , {code} )
					Fputs( self.file , code )
					Mb_GetNextCode( {type} , {code} )
					Fputs( self.file , code )
					Mb_GetNextCode( {type} , {code} )
					Fputs( self.file , code )
					Mb_GetNextCode( {type} , {code} )
					Fputs( self.file , '" ,\n' )

					return := TRUE

				ELSE

					INC func_level
					Fputs( self.file , muistrings[ Val( code ) ] )
					Fputs( self.file , '( ' )
					return := FALSE

				ENDIF

				Mb_GetNextCode( {type} , {code} )

			CASE TC_MUIARG_FUNCTION		->	same as TC_FUNCTION

				indent_code( self.file , indent_level , return )
				INC func_level
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
				Mb_GetNextCode( {type} , {code} )

			CASE TC_MUIARG_OBJFUNCTION		->	same as TC_OBJFUNCTION

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , '( ' )
				INC func_level
				return := FALSE
				objfunction := TRUE
				Mb_GetNextCode( {type} , {code} )

			CASE TC_STRING

				indent_code( self.file , indent_level , return )
				Fputs( self.file , string_convert( code ) )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ' )
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n' )
					return := TRUE

				ENDIF

			CASE TC_INTEGER

				indent_code( self.file , indent_level , return )
				Fputs( self.file , code )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ' )
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n' )
					return := TRUE

				ENDIF

			CASE TC_CHAR

				indent_code( self.file , indent_level , return )
				FputC( self.file , 34 )
				Fputs( self.file , code )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , '" , ') ELSE FputC( self.file , 34 )
					return := FALSE

				ELSE

					Fputs( self.file , '" ,\n' )
					return := TRUE

				ENDIF

			CASE TC_VAR_AFFECT

				indent_code( self.file , indent_level , return )

				IF self.vars[ Val( code ) ].type <> TYPEVAR_LOCAL_PTR

					Fputs( self.file , 'tmp_object.' )

				ENDIF

				Fputs( self.file , self.vars[ Val( code ) ].ident )
				Fputs( self.file , ' := ')
				return := FALSE
				Mb_GetNextCode( {type} , {code} )

			CASE TC_VAR_ARG

				indent_code( self.file , indent_level , return )

				IF self.vars[ Val( code ) ].type <> TYPEVAR_LOCAL_PTR

					Fputs( self.file , 'tmp_object.' )

				ENDIF

				Fputs( self.file , self.vars[ Val( code ) ].ident )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

			CASE TC_OBJ_ARG		->	same as TC_VAR_ARG

				indent_code( self.file , indent_level , return )

				IF self.vars[ Val( code ) ].type <> TYPEVAR_LOCAL_PTR

					Fputs( self.file , 'tmp_object.' )

				ENDIF

				Fputs( self.file , self.vars[ Val( code ) ].ident )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

			CASE TC_END_FUNCTION

				indent_code( self.file , indent_level , return )
				DEC func_level
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					Fputs( self.file , ' )' )
					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' ,' )
					return := FALSE

				ELSE

					Fputs( self.file , IF objfunction THEN ' )\n\n' ELSE ' ) ,\n' )
					objfunction := FALSE
					return := TRUE

				ENDIF

			CASE TC_BOOL

				indent_code( self.file , indent_level , return )
				Fputs( self.file , IF Char( code ) = "0" THEN 'FALSE' ELSE 'MUI_TRUE')
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

			CASE TC_MUIARG

				indent_code( self.file , indent_level , return )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
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

			CASE TC_EXTERNAL_FUNCTION

				indent_code( self.file , indent_level , return )
				Fputs( self.file , 'display.' )
				Fputs( self.file , code )
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type <> TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

			CASE TC_LOCALESTRING

				indent_code( self.file , indent_level , return )
				Fputs( self.file , 'getMBstring( ')
				Fputs( self.file ,  code )
				Fputs( self.file , ' )')
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type<>TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

			CASE TC_LOCALECHAR

				indent_code( self.file , indent_level , return )
				Fputs( self.file , 'Char( ' )
				Fputs( self.file , getstring_func )
				Fputs( self.file , '( ')
				Fputs( self.file ,  code )
				Fputs( self.file , ' ) )')
				Mb_GetNextCode( {type} , {code} )

				IF func_level > 0

					IF type<>TC_END_FUNCTION THEN Fputs( self.file , ' , ')
					return := FALSE

				ELSE

					Fputs( self.file , ' ,\n')
					return := TRUE

				ENDIF

		ENDSELECT

	ENDWHILE

ENDPROC


/*****************************************************
** Write to the GUI file the end of create() method **
*****************************************************/
PROC put_create_end() OF gui_file

	Fputs( self.file , '\tIF tmp_object.app = NIL\n' )
	Fputs( self.file , '\t\tDispose( tmp_object )\n' )
	Fputs( self.file , '\t\ttmp_object := NIL\n' )
	Fputs( self.file , '\tENDIF\n\n' )
	Fputs( self.file , 'ENDPROC tmp_object\n\n\n' )

ENDPROC


/***********************************************
** Write to the GUI file the dispose() method **
***********************************************/
PROC put_dispose_method() OF gui_file

	Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
	Fputs( self.file , '//////////////////////////// Disposes the object or the whole application /////\n' )
	Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
	Fputs( self.file , 'PROC dispose_' )
	Fputs( self.file , self.main_object_ident )
	Fputs( self.file , '( tmp_object : PTR TO ' )
	Fputs( self.file , self.main_object_ident )
	Fputs( self.file , '_obj )\n\n' )
	Fputs( self.file , '\tIF tmp_object.app THEN Mui_DisposeObject( tmp_object.app )\n' )
	Fputs( self.file , '\tDispose( tmp_object )\n\n' )
	Fputs( self.file , 'ENDPROC\n\n\n' )

ENDPROC


/*************************************************************************
** Write to the GUI file the declaration of init_notifications() method **
*************************************************************************/
PROC put_init_notifications_declaration() OF gui_file

	Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
	Fputs( self.file , '///////////////////////// Initializes all the notifications of one object /////\n' )
	Fputs( self.file , '///////////////////////////////////////////// or of the whole application /////\n' )
	Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
	Fputs( self.file , 'PROC init_notifications_' )
	Fputs( self.file , self.main_object_ident )
	Fputs( self.file , '( tmp_object : PTR TO ' )
	Fputs( self.file , self.main_object_ident )
	Fputs( self.file , '_obj ' )

	IF self.hook_funcs

		Fputs( self.file , ', display : PTR TO ' )
		Fputs( self.file , self.main_object_ident )
		Fputs( self.file , '_display ' )

	ENDIF

	Fputs( self.file , ')\n\n' )

ENDPROC


/************************************************
** Write to the GUI file all the notifications **
************************************************/
PROC put_notifications( muistrings : PTR TO LONG ) OF gui_file

	DEF type , code , indent = FALSE

	Mb_GetNextNotify( {type} , {code} )

	WHILE ( type <> -1 )

		IF indent THEN Fputs( self.file , '\t\t' )

		SELECT type

			CASE TC_BEGIN_NOTIFICATION

				Fputs( self.file , '\tdomethod( tmp_object.' )
				Fputs( self.file , self.vars[ Val( code ) ].ident )
				Fputs( self.file , ' ,\n\t\t[ ' )
				indent := FALSE
				Mb_GetNextNotify( {type} , {code} )

			CASE TC_END_NOTIFICATION

				Fputs( self.file , ' ] )\n\n' )
				indent := FALSE
				Mb_GetNextNotify( {type} , {code} )

			CASE TC_FUNCTION

				FputC( self.file , "\t" )
				Fputs( self.file , muistrings[ Val( code ) ] )
				Fputs( self.file , '( ' )
				indent := FALSE
				Mb_GetNextNotify( {type} , {code} )

			CASE TC_END_FUNCTION

				Fputs( self.file , ' )\n\n' )
				indent := FALSE
				Mb_GetNextNotify( {type} , {code} )

			CASE TC_STRING

				Fputs( self.file , string_convert( code ) )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF

			CASE TC_LOCALESTRING

				Fputs( self.file , 'getMBstring( ')
				Fputs( self.file ,  code )
				Fputs( self.file , ' )')
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF


			CASE TC_INTEGER

				Fputs( self.file , code )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF


			CASE TC_CHAR

				FputC( self.file , 34)
				Fputs( self.file , code )
				FputC( self.file , 34)
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF

			CASE TC_BOOL

				Fputs( self.file , IF Char( code ) = "0" THEN 'FALSE' ELSE 'MUI_TRUE')
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF

			CASE TC_VAR_ARG

				Fputs( self.file , 'tmp_object.')
				Fputs( self.file , self.vars[ Val( code ) ].ident )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF

			CASE TC_MUIARG

				Fputs( self.file , muistrings[ Val( code ) ] )
				indent := FALSE
				Mb_GetNextNotify( {type} , {code} )
				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION ) THEN Fputs( self.file , ' , ' )

			CASE TC_MUIARG_OBJ		->	same as TC_MUIARG

				Fputs( self.file , muistrings[ Val( code ) ] )
				indent := FALSE
				Mb_GetNextNotify( {type} , {code} )
				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION ) THEN Fputs( self.file , ' , ' )

			CASE TC_MUIARG_ATTRIBUT

				Fputs( self.file , muistrings[ Val( code ) ] )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF

			CASE TC_EXTERNAL_CONSTANT

				Fputs( self.file , code )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF


			CASE TC_EXTERNAL_FUNCTION

				Fputs( self.file , 'display.' )
				Fputs( self.file , code )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF


			CASE TC_EXTERNAL_VARIABLE

				Fputs( self.file , code )
				Mb_GetNextNotify( {type} , {code} )

				IF ( type <> TC_END_FUNCTION ) AND ( type <> TC_END_NOTIFICATION )

					indent := TRUE
					Fputs( self.file , ' ,\n' )

				ELSE

					indent := FALSE

				ENDIF

		ENDSELECT

	ENDWHILE

ENDPROC


/*****************************************************************
** Write to the GUI file the end of init_notifications() method **
*****************************************************************/
PROC put_init_notifications_end() OF gui_file IS Fputs( self.file , 'ENDPROC\n\n\n' )


/*************************************************
** Write to the GUI file getMBstring() function **
*************************************************/
PROC put_aux_funcs( locale , getstring_func : PTR TO CHAR ) OF gui_file

	IF locale

		Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
		Fputs( self.file , '////////////// Special GetString() function for MUIBuilder generated code /////\n' )
		Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
		Fputs( self.file , 'PROC getMBstring( string_reference )\n\n' )
		Fputs( self.file , '	DEF local_string\n\n' )
		Fputs( self.file , '	local_string := ' )
		Fputs( self.file , getstring_func )
		Fputs( self.file , '( string_reference )\n\n' )
		Fputs( self.file , 'ENDPROC ( IF local_string[ 1 ] = 0 THEN ( local_string + 2 ) ELSE local_string )\n\n\n' )

	ENDIF

	Fputs( self.file , '/* ////////////////////////////////////////////////////////////////////////////\n' )
	Fputs( self.file , '/////////////////////////////////////////////////////// domethod function /////\n' )
	Fputs( self.file , '//////////////////////////////////////////////////////////////////////////// */\n' )
	Fputs( self.file , 'PROC domethod( obj : PTR TO object , msg : PTR TO msg )\n\n' )
	Fputs( self.file , '\tDEF h : PTR TO hook , o : PTR TO object , dispatcher\n\n' )
	Fputs( self.file , '\tIF obj\n' )
	Fputs( self.file , '\t\to := obj-SIZEOF object\t\t/* instance data is to negative offset */\n' )
	Fputs( self.file , '\t\th := o.class\n' )
	Fputs( self.file , '\t\tdispatcher := h.entry\t\t/* get dispatcher from hook in iclass */\n' )
	Fputs( self.file , '\t\tMOVEA.L h,A0\n' )
	Fputs( self.file , '\t\tMOVEA.L msg,A1\n' )
	Fputs( self.file , '\t\tMOVEA.L obj,A2\t\t\t/* probably should use CallHookPkt, but the */\n' )
	Fputs( self.file , '\t\tMOVEA.L dispatcher,A3\t\t/*   original code (DoMethodA()) doesn''t. */\n' )
	Fputs( self.file , '\t\tJSR (A3)\t\t\t/* call classDispatcher() */\n' )
	Fputs( self.file , '\t\tMOVE.L D0,o\n' )
	Fputs( self.file , '\t\tRETURN o\n' )
	Fputs( self.file , '\tENDIF\n\n' )
	Fputs( self.file , 'ENDPROC NIL\n' )

ENDPROC
