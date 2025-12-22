' *SOF*

' *********************************************************************
'   AmigaINI_StripBlanks.bas by/de Dámaso D. Estévez {este, son, eu}
'        Based over the StripBlanks.e v1.0 wrote by Bruce Steer
'   Basado en el código StripBlanks v1.0 escrito en E por Bruce Steer

'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'            All rights reserved over this derivative work:
'                 my Hisoft Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'            in this package: if you create a derivate work,
'                 you MUST to include all legal notes.
'
'            Modify an existing file stripping blank lines.
'       BEWARE! The blank lines in an INI file are dangerours...
'     I discover what the library would fails or works incorrectly
'                       destroying the INI file!
'    ALWAYS use this function after reading the INI file initially
'      and before performing any other operations on the file!:
'   An user could decides modify manually the INI file and inserts
'           a blank line by mistake (something very tempted
'               to improve the readability of the file)
'                             ------------
'   Modifica un fichero ya existente eliminando las líneas en blanco.
'  ¡CUIDADO! Las líneas en blanco en un fichero INI son peligrosas...
'      ¡He descubierto que la biblioteca podría fallar o funcionar
'              incorrectamente destruyendo el fichero INI!
'  ¡ Use esta función SIEMPRE tras leer inicialmente el fichero INI
'   y antes de realizar cualquier otra operación sobre el fichero,
'   por si el usuario decidiese modificar manualmente dicho fichero
'   e insertase por error alguna línea en blanco (algo muy tentador
'             para mejorar la legibilidad del fichero) !
'
'     Todos los derechos reservados sobre este trabajo derivado:
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
v$ = "$VER: AmigaINI_StripBlanks.bas 1.0 (10.03.2017) by Dámaso 'AmiSpaTra' Domínguez based over the E code wrote by Bruce Steers "+CHR$(0)

' ---------------------------------------------------------------------
'                               Variables
' ---------------------------------------------------------------------
ai$   = ""      ' AmigaINI struct / Estructura AmigaINI
fln$  = ""      '        Filename / Nombre del fichero
tfln$ = ""      '   Path+filename / Ruta+nombre del fichero

' ---------------------------------------------------------------------
'                  Main program / Programa principal
' ---------------------------------------------------------------------

'     "Struct" AmigaINI
'   "Estructura" AmigaINI
' --------------------------
ai$ = STRING$(inis_sizeof%, CHR$(0))

'  Opening the library
' Abriendo la biblioteca
' ----------------------
LIBRARY OPEN "amigaini.library", AMIGAINI_VMIN&

'   My example INI file
' Mi fichero INI de ejemplo
' -------------------------
fln$ = "AmigaINI_Cfg.ini"+CHR$(0)

' e& = SADD(ai$)+inis_error%
' --------------------------
e& = 0&

PRINT
PRINT "* Creating the struct"
PRINT "  (Creando la estructura)..."
PRINT
tfln$ = "PROGDIR:"+fln$
e& = Ini_Init&(SADD(ai$),SADD(tfln$))

PRINT "* Reading the config file"
PRINT "  (Leyendo el fichero de configuración)..."
PRINT
e& = Ini_Read&(SADD(ai$))

'    Global errors control for Ini_Init & Ini_Read?
' ¿Control de errores global para Ini_Init e Ini_Read?
' ----------------------------------------------------
IF PEEKB(PEEKL(SADD(ai$)+inis_error%)) = INIE_Ok& THEN

	PRINT "* Stripping blank lines"
	PRINT "  (Eliminando las líneas en blanco)..."
	PRINT
	Ini_Strip SADD(ai$)

	'     Writing the modified file in 'RAM:'
	' Escribiendo el fichero modificado en 'RAM:'
	' -------------------------------------------
	tfln$ = "RAM:"+fln$
	POKEL SADD(ai$)+inis_filename%, SADD(tfln$)

	PRINT "* Writing the modified INI file"
	PRINT "  (Escribiendo el fichero INI modificado)..."
	PRINT
	e& = Ini_Write&(SADD(ai$))

	PRINT
	PRINT "Done !"
	PRINT "(¡Hecho!)"
	PRINT
	PRINT
	PRINT "Compare the old file '";LEFT$(fln$,LEN(fln$)-1);"' (in 'PROGDIR:') and the new in 'RAM:'"
	PRINT "(Compare el viejo fichero '";LEFT$(fln$,LEN(fln$)-1); "'(en 'PROGDIR:') y el nuevo en 'RAM:')"
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

	' Something has failed / Algo ha fallado
	' --------------------------------------
	PRINT PEEK$(Ini_GetErrorMsg&(SADD(ai$)))

END IF

LIBRARY CLOSE

END

' *********************************************************************

' *EOF*
