' *********************************************************************
'     ShowTextAlert © 2003 by Dámaso Domínguez [amidde,arrakis,es]
'                          All Rights Reserved
' *********************************************************************

REM $NOLIBRARY

REM $include dos.bh
REM $include exec.bh
REM $include identify.bh
REM $include expansion.bc

LIBRARY OPEN "identify.library",3&
LIBRARY OPEN "dos.library",LIBRARY_MINIMUM&
LIBRARY OPEN "exec.library",LIBRARY_MINIMUM&

	'       Tags 5 + 1 (zero element array ;)
	' Etiquetas: 5 + 1 (elemento cero de la matriz)
	' ---------------------------------------------
	DIM tags&(5)

	arg$ = LTRIM$(RTRIM$(COMMAND$))

	' The buffer's size / Tamaño del área tampón
	' ------------------------------------------
	buf& = 128&

	'         Creating the message buffers
	' Creando las áreas tampón para los mensajes
	' ------------------------------------------
	ds$=STRING$(buf&,CHR$(0))
	ss$=STRING$(buf&,CHR$(0))
	gs$=STRING$(buf&,CHR$(0))
	st$=STRING$(buf&,CHR$(0))

	PRINT "------------------------------------------------------"
	PRINT "Example #2 for IdentifyDevBas package: Show Text Alert"
	PRINT "------------------------------------------------------";CHR$(13)
	
	IF arg$ <> "" THEN

		'     Converts the hexa numbers from C format to Basic format
		' Convierte los numeros hexadecimales en formato C a formato Basic
		' ----------------------------------------------------------------
		IF LEFT$(arg$,2)="0x" THEN
			arg$="&H"+RIGHT$(arg$,LEN(arg$)-2)
		END IF

		TAGLIST VARPTR(tags&(0)), _
			IDTAG_DeadStr&    ,SADD(ds$), _
			IDTAG_SubsysStr&  ,SADD(ss$), _
			IDTAG_GeneralStr& ,SADD(gs$), _
			IDTAG_SpecStr&    ,SADD(st$), _
			IDTAG_StrLength&  ,buf&-1&  , _
			TAG_DONE&

		e& = IdAlert&(VAL(arg$),VARPTR(tags&(0)))

		' --------------------------------------------------
		' From v8+ and if the apropiate catalog is available
		'        the strings will appears translated :)
		'                      -------
		'     Desde la octava versión de la biblioteca,
		'  y si el catálogo correspondiente está disponible,
		'       los mensajes aparecerán traducidos :)
		' --------------------------------------------------

		IF e& = NULL& THEN

			PRINT "Alert type     / Tipo de alerta    : ";UCASE$(PEEK$(SADD(ds$)))
			PRINT "Subsystem      / Subsistema        : ";PEEK$(SADD(ss$))
			PRINT "General cause  / Motivo general    : ";PEEK$(SADD(gs$))
			PRINT "Specific cause / Motivo específico : ";PEEK$(SADD(st$))

		ELSE

			PRINT "Error # / Error nº: ";e&

		END IF

	ELSE

		PRINT "I need an alert number! / ¡Necesito un nº de alerta!"

	END IF

LIBRARY CLOSE

END

DATA "$VER: ShowTextAlert 1.0 (25.04.03) "+CHR$(0)

