' *********************************************************************
'                    IPFinfo.bas v1.0 (25.01.06)
'          based over IPFinfo.c included in the dev package
'       basado en IPFinfo.c incluido en el paquete de desarrollo
'
'       © 2006 Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es}
'                        All rights reserved
'
'             AmiSpaTra - http://www.arrakis.es/~amidde/
'
'               Ofrece información de un fichero IPF.
'                              ----
'                   Show info about an IPF file
' *********************************************************************

REM $NOWINDOW
REM $NOLIBRARY
REM $NOBREAK

REM $include capsimage.bh
REM $include exec.bh

' Available at Aminet / Disponible en Aminet
' ------------------------------------------
REM $include BLib_AST/SGetArg.bas

'  Version string
' Cadena de versión
' -----------------
ver$ = "$VER: IPFinfo 1.0a (25.01.06) by Dámaso D. Estévez {correoamidde-hbcoding,yahoo,es} (HBasic version) "+CHR$(0)

' ---------------------------------------------------------------------

SUB prt_info(name$)
	LOCAL id1&, id2&
	LOCAL   e&
	LOCAL pid&
	LOCAL cii$
	LOCAL   i&

	id1& = CAPSAddImage&

	'      Negative value if there is an error
	'          (I've included some check
	'        not included in the C version)
	'                     ----
	'        Valor negativo si hay un error
	'     (he incluido algunas comprobaciones
	'       no incluidas en la versión en C)
	' ---------------------------------------------
	IF id1& >= 0 THEN

		'     e& is reusable when the check is done (error)
		'  e& es reutilizable cuando ya se ha verificado (error)
		' ------------------------------------------------------
		e& = CAPSLockImage&(id1&,SADD(name$+CHR$(0)))

		IF e& = imgeOk& THEN

			' Allocating memory for the struct (this isn't the best method)
			' Reservando memoria para la estructura (no es el mejor método)
			' -------------------------------------------------------------
			cii$ = STRING$(CapsImageInfo_sizeof%,CHR$(0))

			e&  = CAPSGetImageInfo&(SADD(cii$),id1&)

			IF e& = imgeOk& THEN

				PRINT "Type          / Tipo             : "; PEEKL(SADD(cii$)+cii_type%)
				PRINT "Release       / Versión          : "; PEEKL(SADD(cii$)+cii_release%)
				PRINT "Revision      / Revisión         : "; PEEKL(SADD(cii$)+cii_revision%)
				PRINT "Min Cylinder  / Cilindro mínimo  : "; PEEKL(SADD(cii$)+cii_mincylinder%)
				PRINT "Max Cylinder  / Cilindro máximo  : "; PEEKL(SADD(cii$)+cii_maxcylinder%)
				PRINT "Min Head      / Cabeza máxima    : "; PEEKL(SADD(cii$)+cii_minhead%)
				PRINT "Max Head      / Cabeza mínima    : "; PEEKL(SADD(cii$)+cii_maxhead%)

				PRINT "Creation Date / Fecha de creación: ";

				'   The STR$/LTRIM$ is for to fix extra spaces
				'      (sign i.e.) includes by the HBasic.
				'                     -----
				' STR$/LTRIM$ las utilizo para eliminar espacios
				'   extras (p. ej. signo) incluidos por HBasic.
				' ----------------------------------------------
				PRINT STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_year%));"/";
				PRINT RIGHT$("0"+LTRIM$(STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_month%))),2);"/";
				PRINT RIGHT$("0"+LTRIM$(STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_day%))),2);
				PRINT CHR$(32);
				PRINT RIGHT$("0"+LTRIM$(STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_hour%))),2);":";
				PRINT RIGHT$("0"+LTRIM$(STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_min%))),2);":";
				PRINT RIGHT$("0"+LTRIM$(STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_sec%))),2);".";
				PRINT LTRIM$(STR$(PEEKL(SADD(cii$)+cii_crdt%+cdte_tick%)))

				PRINT "Platforms     / Plataformas      :  ";

				FOR i& = 0& TO CAPS_MAXPLATFORM&-1&
					pid& = PEEKL(SADD(cii$)+cii_platform%+CINT(i&)*4)
					IF  pid& <> ciipNA& THEN PRINT PEEK$(CAPSGetPlatformName&(pid&))
				NEXT

				e& = CAPSUnlockImage&(id1&)
				IF e& <> imgeOk& THEN	PRINT "Error:";e&;"(CAPSUnlockImage&)"

			ELSE

				PRINT "Error:"e&;"(CAPSGetImageInfo&)"

			END IF

		ELSE

			PRINT "Error:";e&;"(CAPSLockImage&)"

		END IF

		id2& = CAPSRemImage&(id1&)
		IF id2& < 0 THEN	PRINT "Error:";id2&;"(CAPSRemImage&)"

	ELSE

		PRINT "Error:";id1&;"(CAPSADDImage&)"

	END IF

END SUB

' ---------------------------------------------------------------------
'                     Main section /Sección principal
' ---------------------------------------------------------------------

LIBRARY OPEN "exec.library",LIBRARY_MINIMUM&

' Obtaining the argument / Obteniendo el argumento
' ------------------------------------------------
tmpt$ = "FILE/A"
arg$  = ""

p% = 0
WHILE TRUE&

	INCR p%
	t$ = UCASE$(SGetArg$(COMMAND$,p%,tmpt$))

	SELECT CASE t$
		CASE = "FILE"
			INCR p%
			arg$ = SGetArg$(COMMAND$,p%,tmpt$)
			EXIT SELECT
		CASE = ""
			EXIT WHILE
		CASE ELSE
			IF p% = 1 THEN
				arg$ = SGetArg$(COMMAND$,p%,tmpt$)
			ELSE
				EXIT WHILE
			END IF
	END SELECT

WEND

IF arg$ <> "" THEN

	msgport& = CreateMsgPort&

	IF msgport& THEN

		ioreq& = CreateIORequest(msgport&,IORequest_sizeof%)

		IF ioreq& THEN

			IF OpenDevice&(SADD("capsimage.device"+CHR$(0)),0,ioreq&,0) = 0 THEN

				CapsImageBase& = PEEKL(ioreq&+IORequestio_Device%)

				LIBRARY VARPTR "capsimage.device", CapsImageBase&

				dummy& = CAPSInit&

				IF dummy& = imgeOk& THEN
					prt_info arg$
				END IF

				CapsImageBase& = NULL&
				LIBRARY VARPTR "capsimage.device", CapsImageBase&
				CloseDevice ioreq&

			ELSE

				PRINT "Error: Can't open 'capsimage.device' / Imposible abrir 'capsimage.device'"

			END IF

			DeleteIORequest ioreq&

		ELSE

			PRINT "Error: Can't create IORequest / Imposible crear petición E/S"

		END IF

		DeleteMsgPort msgport&

	ELSE

		PRINT "Error: Can't create MsgPort / Imposible crear puerto de mensajes"

	END IF

ELSE

	PRINT "An IPF filename is required ! / ¡Se necesita un fichero IPF como argumento !"

END IF

LIBRARY CLOSE "exec.library"

END
