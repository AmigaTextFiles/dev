' *EOF*

' *********************************************************************
'      AmigaINI_Group.bas by/de Dámaso D. Estévez {este, son, eu}
'       Inspired over the RemoveGroup.e v1.0 wrote by Bruce Steer
'               Inspirado en el código RemoveGroup v1.0
'                     escrito en E por Bruce Steer

'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'            All rights reserved over this derivative work:
'                 my Hisoft Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'            in this package: if you create a derivate work,
'                 you MUST to include all legal notes.
'
'    Simple example: Adds an group, removes other group (fully) and
'     tries to remove other not available group generating an error
'                             ------------
'           Ejemplo sencillo: Añade un grupo, elimina otro e
'     intenta eliminar otro grupo que no existe generando un error
'
'      Todos los derechos reservados sobre este trabajo derivado:
'    mi paquete para desarrolladores que programen con Hisoft Basic.
'          Está prohibido eliminar cualquier comentario o nota
'     de autoría/legal de este paquete: si crea un trabajo derivado
'        HA DE INCLUIR OBLIGATORIAMENTE TODAS LAS NOTAS LEGALES.
' *********************************************************************

REM $NOWINDOW
REM $NOLIBRARY

' ---------------------------------------------------------------------
'                Include files / Ficheros de inclusión
' ---------------------------------------------------------------------

' AmigaINI
' --------
REM $include amigaini.bh

' ---------------------------------------------------------------------
'                 C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------
v$ = "$VER: AmigaINI_Group.bas 1.0 (10.03.2017) by Dámaso 'AmiSpaTra' Domínguez baser over the E code wrote by Bruce Steers "+CHR$(0)

' ---------------------------------------------------------------------
'                        Subroutine / Subrutina
' ---------------------------------------------------------------------

SUB PrtE(ai$)

	' Something has failed / Algo ha fallado
	' --------------------------------------
	BEEP

	PRINT CHR$(27);"[1m";PEEK$(Ini_GetErrorMsg&(SADD(ai$)));CHR$(27);"[0m"

END SUB

' ---------------------------------------------------------------------
'                     Main program / Programa principal
' ---------------------------------------------------------------------

'     "Struct" AmigaINI
'   "Estructura" AmigaINI
' --------------------------
ai$ = STRING$(inis_sizeof%, CHR$(0))

'  Opening the library
' Abriendo la biblioteca
' ----------------------
LIBRARY OPEN "amigaini.library", AMIGAINI_VMIN&

'   The example INI file
' El fichero INI de ejemplo
' -------------------------
f$ = "AmigaINI_Cfg.ini"+CHR$(0)

' e& = SADD(ai$)+inis_error%
' --------------------------
e& = 0&

PRINT
PRINT "* Creating the struct"
PRINT "  (Creando la estructura)..."
tf$ = "PROGDIR:"+f$
e& = Ini_Init&(SADD(ai$),SADD(tf$))

PRINT
PRINT "* Reading the INI file"
PRINT "  (Leyendo el fichero INI)..."
e& = Ini_Read&(SADD(ai$))

'   Global errors control for Ini_Init & Ini_Read?
' ¿Control de errores global para Ini_Init e Ini_Read?
' ----------------------------------------------------
IF PEEKB(PEEKL(SADD(ai$)+inis_error%)) = INIE_Ok& THEN

	'    VERY IMPORTANT! If the INI file includes blank lines,
	'      Ini_RemGroup would process incorrectly the file!

	' ¡Muy importante! Si el fichero INI incluye líneas en blanco,
	'  ¡Ini_RemGroup podría procesar incorrectamente el fichero!
	' ------------------------------------------------------------
	PRINT
	PRINT "* Stripping blank lines"
	PRINT "  (Eliminando las líneas en blanco)..."
	Ini_Strip SADD(ai$)

	'      Adds a new group to end of the list
	' Se añade un nuevo grupo al final de la lista
	' ---------------------------------------------
	PRINT
	PRINT "* Adding the [Misc] group to the end"
	PRINT "  (Añadiendo el grupo [Misc])... ";
	fld$ = "Misc"+CHR$(0)
	e& = Ini_NewGroup&(SADD(ai$),SADD(fld$))

	'  Errors control
	' Control de errores
	' ------------------
	IF PEEKB(PEEKL(SADD(ai$)+inis_error%)) <> INIE_Ok& THEN

		' INIE_Header& if the group don't exits
		'  INIE_Header& si el grupo no existe
		' -------------------------------------
		PrtE ai$

	ELSE

		PRINT "Added! / ¡Añadido!"

	END IF

	' Removing a group (with all their items)
	' Borrando un grupo (con todos sus ítems)
	' ---------------------------------------
	rg$ = "Dir2"+CHR$(0)

	PRINT
	PRINT "* Removing the ";
	PRINT PEEK$(Ini_Bracket&(SADD(rg$)));
	PRINT " group"
	PRINT "  (Eliminando el grupo ";
	PRINT PEEK$(Ini_Bracket&(SADD(rg$)));
	PRINT ")... ";
	e& = Ini_RemGroup&(SADD(ai$),SADD(rg$))

	'  Errors control
	' Control de errores
	' ------------------
	IF e& <> INIE_Ok& THEN

		' INIE_Header& if the group don't exits
		'  INIE_Header& si el grupo no existe
		' -------------------------------------
		PrtE ai$

	ELSE

		PRINT "Removed! / ¡Eliminado!"

	END IF

	' Removing a group (with their items)
	'  Borrando un grupo (con sus ítems)
	' ------------------------------------
	PRINT
	PRINT "* Trying to remove the NOT available [Dir9] group"
	PRINT "  (Intentando eliminar el grupo inexistente [Dir9])... ";
	rg$ = "Dir9"+CHR$(0)
	e& = Ini_RemGroup&(SADD(ai$),SADD(rg$))

	'  Errors control
	' Control de errores
	' ------------------
	IF PEEKB(PEEKL(SADD(ai$)+inis_error%)) <> INIE_Ok& THEN

		' INIE_Header& if the group don't exits
		'  INIE_Header& si el grupo no existe
		' -------------------------------------
		PrtE ai$

	ELSE

		PRINT "Removed! / ¡Eliminado!"

	END IF

	'      Writing the modified file in 'RAM:'
	' Escribiendo el fichero modificado en 'RAM:'
	' -------------------------------------------
	tf$ = "RAM:"+f$
	POKEL SADD(ai$)+inis_filename%, SADD(tf$)

	PRINT
	PRINT "* Writing the modified INI file"
	PRINT "  (Escribiendo el fichero INI modificado)..."
	e& = Ini_Write&(SADD(ai$))

	PRINT
	PRINT "Done !"
	PRINT "(¡Hecho!)"
	PRINT
	PRINT
	PRINT "Compare the old file '";LEFT$(f$,LEN(f$)-1);"' (in 'PROGDIR:') and the new in 'RAM:'"
	PRINT "(Compare el viejo fichero '";LEFT$(f$,LEN(f$)-1); "'(en 'PROGDIR:') y el nuevo en 'RAM:')"
	PRINT

	'   Here you must to delete de AmigaINI struct
	'     if it exists (unnecesary at this case,
	'  because I use a string var managed by Basic)

	' Aquí se borraría la estructura si se ha creado
	'     (algo innecesario siendo en este caso
	'       ya que uso una variable de cadena
	'         gestionada por el propio Basic)
	' ----------------------------------------------

ELSE

	PrtE ai$

END IF

LIBRARY CLOSE

END

' ---------------------------------------------------------------------

' *EOF*
