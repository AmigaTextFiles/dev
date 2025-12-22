' *********************************************************************
'                  PGP_Test.bas (Hisoft Basic version)
'                by/de Dámaso D. Estévez {este, son, eu}
'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
'
'       basado en el código fuente de 'pgptest.rexx' escrito por
'            based over 'pgptest.rexx' source code wrote by
'                    (C) Copyright 1997 André Schenk
'                             ------------
'            All rights reserved over this derivative work:
'                 my Hisoft Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'            in this package: if you create a derivate work,
'                 you MUST to include all legal notes.
'
'                       PGP library simple demo.
'          The PGP 2.6ui package must be installed CORRECTLY:
'                        You can obtain it from
'            http://aminet.net/package/util/crypt/PGPAmi26ui
'                             ------------
'           Demostración simple del uso de la biblioteca PGP.
'       El paquete PGP 2.6ui ha de estar instalado CORRECTAMENTE:
'                          Puede obtenerlo en
'            http://aminet.net/package/util/crypt/PGPAmi26ui
'
'      Todos los derechos reservados sobre este trabajo derivado:
'    mi paquete para desarrolladores que programen con Hisoft Basic.
'          Está prohibido eliminar cualquier comentario o nota
'     de autoría/legal de este paquete: si crea un trabajo derivado
'        HA DE INCLUIR OBLIGATORIAMENTE TODAS LAS NOTAS LEGALES.
' *********************************************************************

OPTION BASE 1

' ---------------------------------------------------------------------
'                Include files / Ficheros de inclusión
' ---------------------------------------------------------------------

'         OS / SO
' ------------------------
REM $include exec.bc

' PGP
' ---
REM $include pgp.bh

' ---------------------------------------------------------------------
'                 C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------
v$ = "$VER: PGP_Test.bas 1.2 (10.03.2013) by Dámaso 'AmiSpaTra' Domínguez based over 'pgptest.rexx' source wrote by André Schenk "+CHR$(0)

' ---------------------------------------------------------------------
'    From/De:  http://aminet.net/package/dev/basic/AST_HBRoutines
'                             ------------
'         Obtain a command line interface's argument (Shell)
'            and convert Basic's strings <-> C's strings.
'
'   Obtiene un argumento de la interfaz de línea de comandos (Shell)
'      y convierte cadenas del Basic <-> cadenas al estilo del C.
' ---------------------------------------------------------------------
REM $include BLib_AST/SGetArg.bas
REM $include BLib_AST/StrTo.bas

' =====================================================================
'           Deleting a pre-existant file (PGP would fails!)
'          Borrando un fichero preexistente (¡PGP fallaría!)
' =====================================================================
SUB DFile(BYVAL f$)

	IF FEXISTS(f$) THEN KILL f$

END SUB

' =====================================================================
'                  Main program / Programa principal
' =====================================================================

' ---------------------------------------------------------------------
'                   Only CLI/Shell - Sólo CLI/Shell
' ---------------------------------------------------------------------
IF PEEKL(SYSTAB+8) <> 0 THEN
	BEEP
	Goto Salida
END IF

' ---------------------------------------------------------------------
'         Initiating some vars / Inicializando algunas variables
' ---------------------------------------------------------------------
DIM tags&(10)

mantra$ = Str2C$("geheim")      ' Password / Contraseña
rf$     = "PGP_Test.bas"        ' Filename / Nombre del fichero
e&      = NULL&

buffer$ = STRING$(256,CHR$(0))  ' Buffer / Tampón

'   Obtaining the arg
' Obteniendo el argumento
' -----------------------
user$ = SGetArg$(1%,"USERID/A")

'IF user$ = "" THEN
'
'	PRINT CHR$(27);"[1m";Str2B$(RIGHT$(v$,LEN(v$)-6));CHR$(27);"[0m"
'
'	PRINT "           The program requires an usernameid as argument!"
'	PRINT "¡El programa exige un identificador de nombre de usuario como argumento!"
'	BEEP
'	Goto Salida
'
'END IF

LIBRARY OPEN "pgp.library"

PRINT CHR$(10);"Processing the file / Fichero a procesar: ";CHR$(34);rf$;CHR$(34);CHR$(10)

' ---------------------------------------------------------------------

PRINT "Signing with user / Firmando con el usuario: ";user$;"... ";

'  With PGP output redirected to NIL:
' Con la salida de PGP redigida a NIL:
' ------------------------------------
TAGLIST VARPTR(tags&(0)), _
	PGPTAG_Break&,		TRUE&, _
	PGPTAG_ConOutput&,	SADD("NIL:"+CHR$(0)), _
	PGPTAG_OutFile&,		SADD(Str2C$(rf$)), _
	PGPTAG_UserId&,		SADD(Str2C$(user$)), _
	TAG_END&

' *********************************************************************
'     Warning!!!!! As you can see the tags hasn't the same names
'     what the names included in the docs... this isn't my fault.
'  You can check it in the original pgp.h file in libraries drawer.
'
'   ¡¡¡Advertencia!!! Como puede ver las etiquetas no tienen el mismo
'   nombre que el que se cita en la documentación... no es culpa mía.
' Puede comprobarlo en el fichero pgp.h original en el cajón libraries.
' *********************************************************************

DFile rf$+".sig"

e& = PGPSign&(SADD(rf$), SADD(mantra$), VARPTR(tags&(0)))

IF e& <> NULL& THEN
 	l& = PGPFault&(e&, NULL&, SADD(buffer$), LEN(buffer$))
	PRINT PEEK$(SADD(buffer$))
ELSE
	PRINT "Done / Hecho"
END IF

PRINT

' ---------------------------------------------------------------------

PRINT "Encrypting / Cifrando... ";

'   With PGP output redirected to a window
' Con la salida de PHP redirigida a una ventana
' ---------------------------------------------
TAGLIST VARPTR(tags&(0)), _
 	PGPTAG_ConOutput&,	SADD("CON:15/15/500/50/PGPOutput"+CHR$(0)), _
	PGPTAG_Binary&,		TRUE&, _
	PGPTAG_OutFile&,		SADD(Str2C$(rf$)), _
	PGPTAG_Password&,		SADD(mantra$), _
	PGPTAG_Sign&,		FALSE&, _
	TAG_END&

DFile rf$+".pgp"

e& = PGPEncrypt&(SADD(rf$), SADD(Str2C$(user$)),  VARPTR(tags&(0)))

IF e& <> NULL& THEN
 	l& = PGPFault&(e&, NULL&, SADD(buffer$), LEN(buffer$))
	PRINT PEEK$(SADD(buffer$))
ELSE
	PRINT "Done / Hecho"
END IF

PRINT

' ---------------------------------------------------------------------

PRINT "Decrypting / Descifrando... "

'   With PGP output not redirected
' Con la salida de PGP no redirigida
' ----------------------------------
TAGLIST VARPTR(tags&(0)), _
	PGPTAG_OutFile&, 		SADD(Str2C$(rf$+".dec")), _
	TAG_END&

DFile rf$+".dec"

e& = PGPDecrypt&(SADD(Str2C$(rf$)), SADD(mantra$),  VARPTR(tags&(0)))

IF e& <> NULL& THEN
 	l& = PGPFault&(e&, NULL&, SADD(buffer$), LEN(buffer$))
	PRINT CHR$(10);PEEK$(SADD(buffer$))
ELSE
	PRINT CHR$(10);"Done / Hecho"
END IF

' >>>>>
Salida:
' <<<<<

PRINT

END
