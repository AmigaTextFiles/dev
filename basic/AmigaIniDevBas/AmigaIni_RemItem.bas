' *EOF*

' *********************************************************************
'     AmigaINI_RemItem.bas by/de Dámaso D. Estévez {este, son, eu}
'         Based over the RemoveItem.e v1.0 wrote by Bruce Steer
'                  Basado en el código RemoveItem v1.0
'                     escrito en E por Bruce Steer

'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'            All rights reserved over this derivative work:
'                 my Hisoft Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'            in this package: if you create a derivate work,
'                 you MUST to include all legal notes.
'
'  Easy example: Finds a group, removes an item from it and informs
'      about their position (in which group is the library)...
'          WARNING! This version don't remove the item...
'                 as the E version in my machine! =8-o
'                             ------------
'    Ejemplo sencillo: Busca un grupo, elimina un ítem de éste e
'  informa sobre su posición (en qué grupo está la biblioteca)...
'           ¡ATENCIÓN! Esta versión no elimina el ítem...
'       igual que la versión en E, al menos en mi equipo =8-o
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
v$ = "$VER: AmigaINI_RemItem.bas 1.0 (10.03.2016) by Dámaso 'AmiSpaTra' Domínguez based over the E code wrote by Bruce Steers "+CHR$(0)

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

	PRINT
	PRINT "* Stripping blank lines"
	PRINT "  (Eliminando las líneas en blanco)..."
	Ini_Strip SADD(ai$)

	' First, search the group
	' Primero, busque el grupo
	' ------------------------

	PRINT
	PRINT "* Finding the [Ajustes] group"
	PRINT "  (Buscando el grupo [Ajustes])... ";
	rg$ = "Ajustes"+CHR$(0)
	e& = Ini_FindGroup&(SADD(ai$),SADD(rg$))

	PrtE ai$

	' Trying to remove an item from the current group
	'   Intentando borrar un ítem del grupo actual
	' -----------------------------------------------
	PRINT
	PRINT "* Trying to remove the 'Window' item"
	PRINT "  (Intentando eliminar el grupo ítem 'Window')... ";
	rg$ = "Window" + CHR$(0)
	e& = Ini_RemItem&(SADD(ai$),SADD(rg$))

	PrtE ai$

	' Searching an unavailable group for to check Ini_GroupName()
	' Buscando un grupo inexistente para verificar Ini_GroupName()
	' ------------------------------------------------------------
	PRINT
	PRINT "* Finding the unavailable [Dir23] group"
	PRINT "  (Buscando el grupo [Dir23] inexistente)... ";
	rg$ = "Dir23"+CHR$(0)
	e& = Ini_FindGroup&(SADD(ai$),SADD(rg$))

	PRINT "I'm in / Estoy en: [";
	PRINT PEEK$(Ini_GroupName&(SADD(ai$)));
	PRINT "]"

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
	PRINT "Done!"
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
