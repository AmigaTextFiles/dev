' *EOF*

' *********************************************************************
'   AmigaINI_Set&ReadData.bas by/de Dámaso D. Estévez {este, son, eu}
'    Inspired over the SetDataExample.e v1.0 wrote by Bruce Steer
'               Inspirado en el código SetDataExample v1.0
'                      escrito en E por Bruce Steer

'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'             All rights reserved over this derivative work:
'                  my Hisoft Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'            in this package: if you create a derivate work,
'                  you MUST to include all legal notes.
'
'                Easy example: Adds and read some fields

'                              ------------

'                  Ejemplo sencillo: Añade y lee campos
'
'       Todos los derechos reservados sobre este trabajo derivado:
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

' Vars / Variables
' ----------------
ai$   = ""   ' AmigaINI struct / Estructura AmigaINI
fln$  = ""   '        Filename / Nombre del fichero
tfln$ = ""   '   Path+filename / Ruta+nombre del fichero
fld$  = ""   '      Field name / Nombre del campo
s$    = ""
i%    = 0%

' ---------------------------------------------------------------------
'                 C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------
v$ = "$VER: AmigaINI_SetData.bas 1.0 (12.03.2017) by Dámaso 'AmiSpaTra' Domínguez based over the E code wrote by Bruce Steers "+CHR$(0)

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
fln$ = "AmigaINI_Cfg.ini"+CHR$(0)

' e& = SADD(ai$)+inis_error%
' --------------------------
e& = 0&

PRINT
PRINT "* Creating the struct"
PRINT "  (Creando la estructura)..."
tfln$ = "PROGDIR:"+fln$
e& = Ini_Init&(SADD(ai$),SADD(tfln$))

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

	' Searching the group...
	'  Buscando el grupo...
	' ----------------------
	PRINT
	PRINT "* Finding the [Dir5] group"
	PRINT "  (Buscando el grupo [Dir5])... ";
	fld$ = "Dir5"+CHR$(0)
	e& = Ini_FindGroup&(SADD(ai$),SADD(fld$))

	PrtE ai$

	' ... and adding the fields with their values using the generic function
	' ... y añadiendo los campos con sus valores usando la función genérica
	' ----------------------------------------------------------------------

	' A string / Una cadena
	' ---------------------
	PRINT
	PRINT "* Adding the 'Calle' item"
	PRINT "  (Añadiendo el ítem 'Calle')... ";
	fld$ = "Calle"+CHR$(0)
	s$ = "Avenida Ficticia"+CHR$(0)
	e& = Ini_Set&(SADD(ai$),SADD(fld$),INIV_Type_Str&,SADD(s$))
	' or / o
	' e& = Ini_SetStr&(SADD(ai$),SADD(fld$),SADD(s$))

	PrtE ai$

	' An integer / Un entero
	' ----------------------
	PRINT
	PRINT "* Adding the 'Num' item"
	PRINT "  (Añadiendo el ítem 'Num')... ";
	fld$ = "Num"+CHR$(0)
	i% = 969
	e& = Ini_Set&(SADD(ai$),SADD(fld$),IBIV_Type_Int&,i%)
	' or / o
	' e& = Ini_SetInt&(SADD(ai$),SADD(fld$),i%)

	PrtE ai$

	' Searching other group...
	'  Buscando otro grupo...
	' -------------------------
	PRINT
	PRINT "* Finding the [Dir2] group"
	PRINT "  (Buscando el grupo [Dir2])... ";
	fld$ = "Dir2"+CHR$(0)
	e& = Ini_FindGroup&(SADD(ai$),SADD(fld$))

	PrtE ai$

	'      Modifying a string value using the specific function
	' Modificando un campo de cadena utilizando una función específica
	' ----------------------------------------------------------------
	PRINT
	PRINT "* Modifying the 'Calle' item"
	PRINT "  (Modificando el ítem 'Calle')... ";
	fld$ = "Calle"+CHR$(0)
	s$ = "Avenida Inicial"+CHR$(0)
	e& = Ini_SetStr&(SADD(ai$),SADD(fld$),SADD(s$))
	' or / o
	' e& = Ini_Set&(SADD(ai$),SADD(fld$),INIV_Type_Str&,SADD(s$))

	PrtE ai$

	'    Modifying an integer field using the specific function
	' Modificando un campo entero utilizando una función específica
	' -------------------------------------------------------------
	PRINT
	PRINT "* Modifying the 'Num' item"
	PRINT "  (Modificando el ítem 'Num')... ";
	fld$ = "Num"+CHR$(0)
	i% = -11111
	e& = Ini_SetInt&(SADD(ai$),SADD(fld$),i%)
	' or / o
	' e& = Ini_Set&(SADD(ai$),SADD(fld$),IBIV_Type_Int&,i%)

	PrtE ai$

	' Searching a third group...
	'  Buscando un tercer grupo...
	' -------------------------
	PRINT
	PRINT "* Finding the [Ajustes] group"
	PRINT "  (Buscando el grupo [Ajustes])... ";
	fld$ = "Ajustes"+CHR$(0)
	e& = Ini_FindGroup&(SADD(ai$),SADD(fld$))

	PrtE ai$

	'    Recoving info from an integer field
	' Recuperando información de un campo entero
	' ------------------------------------------
	PRINT
	PRINT "* Printing the info saved in 'ShowGUI' item"
	PRINT "  (Imprimiendo la información guardada en el ítem 'ShowGUI')... ";
	fld$ = "ShowGUI"+CHR$(0)
	i% = 1
	e& = Ini_GetInt&(SADD(ai$),SADD(fld$),i%)
	' or / o
	' e& = Ini_Get&(SADD(ai$),SADD(fld$),IBIV_Type_Int&,i%)
	PRINT e&;" - ";

	PrtE ai$

	'            Recoving the info from an unavailable integer field:
	'     The library seems to add this field with default value to INI file!

	'         Recuperando información de un campo enterno no disponible:
	' ¡La biblioteca parece añadir este campo con su valor por defecto al fichero INI!
	' --------------------------------------------------------------------------------
	PRINT
	PRINT "* Printing the info saved in unavailable 'Counter' item"
	PRINT "  (Imprimiendo la información guardada en el ítem inexistente 'Counter')... ";
	fld$ = "Counter"+CHR$(0)
	i% = 4
	e& = Ini_Get&(SADD(ai$),SADD(fld$),IBIV_Type_Int&,i%)
	' or / o
	' e& = Ini_GetInt&(SADD(ai$),SADD(fld$),i%)
	PRINT e&;" - ";

	PrtE ai$

	'            Recoving info from an string field
	'   (if you can't know how to manage the integers/strings
	' arrays, you can read as a string and parsing them later ;)
	
	'     Recuperando información de un campo de cadena
	'    (si no sabe cómo manejar las listas de enteros
	' o cadenas, puede leer la información como una cadena
	'              y procesarla con posteridad ;)
	' ----------------------------------------------------------
	PRINT
	PRINT "* Printing the info saved in 'Shortcut' item"
	PRINT "  (Imprimiendo la información guardada en el ítem 'Shortcut')... ";
	fld$ = "Shortcut"+CHR$(0)
	s$ = "lshift F1"+CHR$(0)
	e& = Ini_GetStr&(SADD(ai$),SADD(fld$),SADD(s$))
	' or / o
	' e& = Ini_Get&(SADD(ai$),SADD(fld$),INIV_Type_Str&,SADD(s$))
	PRINT PEEK$(e&);" - ";

	PrtE ai$

	'      Writing the modified file in 'RAM:'
	' Escribiendo el fichero modificado en 'RAM:'
	' -------------------------------------------
	tfln$ = "RAM:"+fln$
	POKEL SADD(ai$)+inis_filename%, SADD(tfln$)

	PRINT
	PRINT "* Writing the modified INI file"
	PRINT "  (Escribiendo el fichero INI modificado)..."
	e& = Ini_Write&(SADD(ai$))

	PRINT
	PRINT "Done!"
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

	PrtE ai$

END IF

LIBRARY CLOSE

END

' ---------------------------------------------------------------------

' *EOF*
