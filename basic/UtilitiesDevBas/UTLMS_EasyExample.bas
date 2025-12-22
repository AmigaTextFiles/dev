' *********************************************************************
'                          UTLMS_EasyExample
'                 by Dámaso D. Estévez {este, son, eu}
'         AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
'
'             All rights reserved over this derivative work:
'                my Hisoft Basic developpers package.
'      Forbidden to remove ALL legal/copyrights remarks included
'          in this package: if you create a derivate work,
'                 you MUST to include all legal notes.
'
'      Todos los derechos reservados sobre este trabajo derivado:
'   mi paquete para desarrolladores que programen con Hisoft Basic.
'         Está prohibido eliminar cualquier comentario o nota
'    de autoría/legal de este paquete: si crea un trabajo derivado
'       HA DE INCLUIR OBLIGATORIAMENTE TODAS LAS NOTAS LEGALES.
' *********************************************************************

OPTION BASE 1

'        Compiler's metacommands (see the Hisoft Basic Manual)
' Metacomandos para el compilador (consulte el manual del Hisoft Basic)
' ---------------------------------------------------------------------
REM $NOWINDOW

'                Include files / Ficheros de inclusión
' ---------------------------------------------------------------------
REM $include utilities.bh

'    From/De:  http://aminet.net/package/dev/basic/AST_HBRoutines
' ---------------------------------------------------------------------
REM $include BLib_AST/StrTo.bas

'                 C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------
v$ = "$VER: UTLMS_EasyExample 1.1 (06.03.2013) by Dámaso 'AmiSpaTra' Domínguez "

'                Example for to use only from CLI
' Ejemplo para utilizar sólo de la interfaz de línea de comandos
' --------------------------------------------------------------------
IF PEEKL(SYSTAB+8) <> 0 THEN
	BEEP
	GOTO Salida
END IF

'              Opening the library / Abriendo la biblioteca
' ---------------------------------------------------------------------
LIBRARY OPEN "utilities.library", 3&

'                      Some vars / Algunas variables
' ---------------------------------------------------------------------
n%    = 24%				' How many numbers? / ¿Cuántos números?
c%    = 6%				' # items per colum / Ítems por columna
seed& = 0&				' Random seed       / Semilla aleatoria
cd$   = ""				' Superstring       / Supercadena
l&    = 0&

DIM numbers&(n%)

' ---------------------------------------------------------------------

PRINT CHR$(10);"* Generating and printing some random numbers / Generando e imprimiendo algunos números aleatorios...";CHR$(10)

FOR a% = LBOUND(numbers&,1) TO UBOUND(numbers&,1)

	' v1
	numbers&(a%) = UTLMSRnd&(VARPTR(seed&), &HFFFF&)
	
	' Format: Hexadecimal value with 4 digits
	' Formato: Valor hexadecimal con 4 dígitos
	' ----------------------------------------
	PRINT "&H";RIGHT$("000"+HEX$(numbers&(a%)),4);CHR$(32);

	' Table with c% colums
	' Tabla con c% columnas
	' --------------------
	IF INT(a%/c%)*c% = a% OR a% = UBOUND(numbers&,1) THEN

		PRINT

	END IF

NEXT a%

' ---------------------------------------------------------------------

PRINT CHR$(10);"* The max & min values are... / Los valores máximo y mínimo son... ";

m2& = numbers&(1)
m1& = numbers&(1)

FOR a% = LBOUND(numbers&,1) TO UBOUND(numbers&,1)

	' v1
	m2& = UTLMSMin&(numbers&(a%),m2&)
	m1& = UTLMSMax&(numbers&(a%),m1&)

NEXT a%

PRINT "&H";RIGHT$("000"+HEX$(m2&),4);" (";m2&;") / ";"&H";RIGHT$("000"+HEX$(m1&),4);" (";m1&;")";CHR$(10)

' ---------------------------------------------------------------------

PRINT "* The 64000 value is in min-max range? / ¿El valor 64000 está dentro del rango mínimo-máximo? ";

' v1
IF UTLMSMinMax&(64000,m1&,m2&) = 64000 THEN
	PRINT " YES!!! / ¡¡¡SÍ!!!"
ELSE
	PRINT " NON / NO"
END IF

PRINT

' ---------------------------------------------------------------------

PRINT "* Creating a superstring... / Creando una supercadena..."

' I will use only the first 50% of random numbers generated
' Utilizaré sólo el 50% de los números aleatorios generados
' ---------------------------------------------------------
FOR a% = LBOUND(numbers&,1) TO INT(UBOUND(numbers&,1)/2)

	'         Buffer (&HFFFF, 4 chars > 65535, five chars)
	' Tampón (&HFFFF, cuatro caracteres > 65535, cinco caracteres)
	' ------------------------------------------------------------
	bf$   = STRING$(6,CHR$(0))	

	'v2
	UTLMSNumToStr numbers&(a%), SADD(bf$)

	' The super-string / La supercadena
	' ---------------------------------	
	cd$ = cd$ + PEEK$(SADD(bf$))

NEXT a%

PRINT
PRINT cd$

' ---------------------------------------------------------------------

PRINT CHR$(10);"* Their length is... / Su longitud es... ";

cd$ = Str2C$(cd$)


' v1
l& = UTLMSStrLen&(SADD(cd$))

PRINT l&

' ---------------------------------------------------------------------

PRINT CHR$(10);"* Printing the reversed string / Imprimiendo la cadena invertida..."

' Warning! / ¡Atención!
' ---------------------
' a1& = SADD(cd$+CHR$(0))
' cd$ = cd$ + CHR$(0)
' a2& = SADD(cd$)
'
'        The addresses a1& and a2& aren't
'       the same, specially because a1& is
'         a point to a temporal string
'         (this ISN'T the real cd$ var).
'   This is important when you try to use with
' routines what modify the variable as StrRev...
'
'    UTLMSStrRec(SADD(cd$+CHR$(0)) don't work
'          and for this reason I rewrote
'                  the code as:
'
'               cd$ = cd$ + CHR$(0)
'              UTLMSStrRev SADD(cd$)
'
'                       ---
'
'         Las direcciones a1& and a2& NO
'    son la misma, especialmente porque a1& es
'        un puntero a una cadena temporal
'   (NO es la variable cd$ original/verdadera).
'  Esto es importante cuando intente utilizarla
'  con rutinas que la modifiquen como StrRev...
'
'          UTLMSStrRec(SADD(cd$+CHR$(0))
'          NO funciona y por esta razón
'           he reescrito el código así:
'
'               cd$ = cd$ + CHR$(0)
'              UTLMSStrRev SADD(cd$)
' -----------------------------------------------

' v1
UTLMSStrRev SADD(cd$)

PRINT:PRINT Str2B$(cd$)

' ---------------------------------------------------------------------

PRINT CHR$(10);"* Times what the '5' digit appears... / Veces que el dígito '5' aparece... ";

' v3
PRINT UTLMSStrCnt&(SADD(cd$),SADD(Str2C$("5")))

' ---------------------------------------------------------------------

PRINT CHR$(10);"* Searching the '11' substring... / Buscando la subcadena '11'... ";

' v1
l& = UTLMSStrFind&(SADD(cd$),SADD(Str2C$("11")))

IF l& = 0& THEN
	PRINT "Not found / No encontrada"
ELSE
	PRINT "Found! / ¡Encontrada!"
END IF

PRINT

' >>>>>
Salida:
' <<<<<

LIBRARY CLOSE

END
