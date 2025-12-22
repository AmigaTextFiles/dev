' *SOF*

' *********************************************************************
'      AmigaINI_InitINI.bas by/de Dámaso D. Estévez {este, son, eu}
'             Based over the InitINI.e wrote by Bruce Steer
'        Basado en el código InitINI escrito en E por Bruce Steer

'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'             All rights reserved over this derivative work:
'                  my Hisoft Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'            in this package: if you create a derivate work,
'                  you MUST to include all legal notes.
'
'                 Easy example: AmigaINI struct creation
'                  and prints some fields initialized.
'                              ------------
'                  Ejemplo sencillo: Crea la estructura
'            AmigaINI e imprime algunos campos inicializados.
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

' ---------------------------------------------------------------------
'                 C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------
v$ = "$VER: AmigaINI_InitINI.bas 1.0 (10.03.2017) by Dámaso 'AmiSpaTra' Domínguez based over the E code wrote by Bruce Steers "+CHR$(0)

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

' My INI filename / El nombre de mi fichero INI
' ---------------------------------------------
f$ = "PROGDIR:AmigaIni_Cfg.ini"+CHR$(0)

' e& = SADD(ai$)+inis_error%
' --------------------------
e& = 0&

e& = Ini_Init&(SADD(ai$),SADD(f$))

'     The struct was created correctly?
' ¿La estructura se ha creado correctamente?
' ------------------------------------------
IF PEEKB(PEEKL(SADD(ai$)+inis_error%)) = INIE_Ok& THEN

	'       Printing the fields values
	'  Imprimiendo los valores de los campos
	' ---------------------------------------
	PRINT "ai.filename = ";                   CHR$(34);PEEK$(PEEKL(SADD(ai$)+inis_filename%));CHR$(34)
	PRINT "ai.error =";                                PEEKB(PEEKL(SADD(ai$)+inis_error%))
	PRINT "ai.length (string array length) =";         PEEKB(PEEKL(SADD(ai$)+inis_length%))
	PRINT "ai.groupstart =";                           PEEKB(PEEKL(SADD(ai$)+inis_groupstart%))
	PRINT "ai.groupend =";                             PEEKB(PEEKL(SADD(ai$)+inis_groupend%))

	'     Symbol that separates the field from their value
	'    (default '='). The coder could change it for i.e.
	'   ':' with... POKE(SADD(ai$)+inis_paramstr%), ASC(":")
	'           but this would be a wise decision??
	'                           -=-
	' Símbolo que separa el campo de su valor (por defecto '=').
	'  El programador podría cambiarlo por, por ejemplo, ':'
	'     con... POKE(SADD(ai$)+inis_paramstr%), ASC(":")
	'            ¿¿pero sería una decisión sabia??
	'-----------------------------------------------------------
	PRINT "ai.paramstr = ";                   CHR$(34);PEEK$(PEEKL(SADD(ai$)+inis_paramstr%));CHR$(34)

	'  Symbol that separates the lists' elements (default ',').
	'       The coder could change it for i.e. '; with...
	'          POKE(SADD(ai$)+inis_paramstr%), ASC(";")
	'            but this would be a wise decision??
	'                          -=-
	'  Símbolo que separa el campo de su valor (por defecto ',').
	'   El programador podría cambiarlo por, por ejemplo, ';'
	'      con... POKE(SADD(ai$)+inis_paramstr%), ASC(";")
	'             ¿¿pero sería una decisión sabia??
	' -----------------------------------------------------------
	PRINT "ai.arraystr = ";                   CHR$(34);PEEK$(PEEKL(SADD(ai$)+inis_arraystr%));CHR$(34)

	'       The E version seems don't print this two fields values
	' La versión en E parece no imprimir los valores de estos dos campos
	' ------------------------------------------------------------------

	'         This field controls how manage the lists.
	'            This command informs to library what
	'         the coder will use strings at next lists:
	'       POKE(SADD(ai$)+inis_arratype%), INIV_Type_Str&
	'               And this for to use integers:
	'       POKE(SADD(ai$)+inis_arratype%), INIV_Type_Int&
	'                         -=-
	'      Este campo controla cómo se manejan las listas.
	'     Este comando es para informar a la biblioteca que
	'    el programador va a usar cadenas en próximas listas:
	'       POKE(SADD(ai$)+inis_arratype%), INIV_Type_Str&
	'                 Y éste que usará enteros:
	'       POKE(SADD(ai$)+inis_arratype%), INIV_Type_Int&
	' -----------------------------------------------------------
	PRINT "ai.arraytype =";                            PEEKB(PEEKL(SADD(ai$)+inis_arratype%))
	PRINT "ai.casesense =";                            PEEKB(PEEKL(SADD(ai$)+inis_casesense%))

	'  Here you must to delete de AmigaINI struct if it exists
	'             (unnecesary at this case, because
	'            I use a string var managed by Basic)
	'                         -=-
	'    Aquí se borraría la estructura si se ha creado (algo
	'  innecesario siendo en este caso ya que uso una variable
	'         de cadena gestionada por el propio Basic)
	' -----------------------------------------------------------

ELSE

	' Something has failed / Algo ha fallado
	' --------------------------------------
	PRINT PEEK$(Ini_GetErrorMsg&(SADD(ai$)))

END IF

LIBRARY CLOSE

END

' *********************************************************************

' *EOF*
