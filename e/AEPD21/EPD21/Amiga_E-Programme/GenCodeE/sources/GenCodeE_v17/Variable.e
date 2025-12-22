OPT MODULE
OPT EXPORT
OPT LARGE


->*****
->** External modules
->*****
MODULE 'muibuilder' , 'libraries/muibuilder'
MODULE 'utility/tagitem'


->*****
->** Exception handling
->*****
RAISE	"MEM"	IF	String()	=	NIL


->*****
->** Object definitions
->*****
OBJECT variable
	ident	:	PTR TO CHAR
	type	:	LONG
	size	:	LONG
	init	:	LONG
ENDOBJECT


/******************************************
** Returns an array of all the variables **
******************************************/
PROC init_variables( number_vars )

	DEF vars : PTR TO variable , ident_length_max = 0
	DEF ident : PTR TO CHAR , type , size , init
	DEF i , tmp_ident : PTR TO CHAR

	NEW vars[ number_vars ]

	FOR i := 0 TO ( number_vars - 1 )

		Mb_GetVarInfoA( i ,
						[	MUIB_VARTYPE	, {type}	,
							MUIB_VARNAME	, {ident}	,
							MUIB_VARSIZE	, {size}	,
							MUIB_VARINITPTR	, {init}	,
							TAG_END ] )

		tmp_ident := String( StrLen( ident ) )
		StrCopy( tmp_ident , ident )

		IF ( type <> TYPEVAR_HOOK ) AND ( type <> TYPEVAR_IDENT ) AND ( type <> TYPEVAR_EXTERNAL )

			IF ( tmp_ident[] >= "A" ) AND ( tmp_ident[] <= "Z" ) THEN tmp_ident[] :=  tmp_ident[] + 32
			IF EstrLen( tmp_ident ) >= 2 THEN
				IF ( tmp_ident[ 1 ] >= "A" ) AND ( tmp_ident[ 1 ] <= "Z" ) THEN tmp_ident[ 1 ] :=  tmp_ident[ 1 ] + 32

		ENDIF

		vars[ i ].ident := tmp_ident
		vars[ i ].type := type
		vars[ i ].size := size
		vars[ i ].init := init

		IF EstrLen( tmp_ident ) > ident_length_max THEN ident_length_max := EstrLen( tmp_ident )

	ENDFOR

ENDPROC vars , ident_length_max
