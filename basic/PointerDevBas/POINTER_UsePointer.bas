' *SOF*

' *********************************************************************
'                         POINTER_UsePointer.bas
'          by/de Copyright 2015-2017 Dแmaso "AmiSpaTra" Est้vez
'                          {miast, esteson, eu}
'          AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
' *********************************************************************
'                 Based over the example "UsePointer.c"
'                  included in the Pointer Lib package.

'              All rights reserved over MY derivative work:
'              This Hisoft/Maxon Basic developpers package.
'       Forbidden to remove ALL legal/copyrights remarks included
'      in this package: If you create a derivative work from mine,
'                  you MUST to include ALL legal notes.

'          The example can shows four different mouse pointers.
'                                  ----
'                  Basado en el ejemplo "UsePointer.c"
'            incluido en el paquete de la biblioteca Pointer.

'        Todos los derechos reservados sobre MI trabajo derivado:
'                   Este paquete para desarrolladores
'                 que programen con Hisoft/Maxon Basic.
'          Estแ prohibido eliminar cualquier comentario o nota
'     de autorํa/legal de este paquete: Si crea un trabajo derivado
'    del mํo HA DE INCLUIR OBLIGATORIAMENTE TODAS LAS NOTAS LEGALES.

'      El ejemplo puede mostrar cuatro punteros de rat๓n diferentes.
' *********************************************************************

OPTION BASE 1

' ---------------------------------------------------------------------
'        Compiler's metacommands (see the Hisoft Basic Manual)
' Metacomandos para el compilador (consulte el manual del Hisoft Basic)
' ---------------------------------------------------------------------
REM $NOWINDOW
REM $NOLIBRARY
REM $NOBREAK

' ---------------------------------------------------------------------
'                    Include files / Ficheros de inclusi๓n
' ---------------------------------------------------------------------

'   OS / SO
' ------------
REM $include exec.bh                     ' NULL&, FALSE&
REM $include intuition.bh
REM $include graphics.bh

' Pointer
' -------
REM $include pointer.bh

' ---------------------------------------------------------------------
'              C= string version / Cadena de versi๓n de C=
' ---------------------------------------------------------------------

vstring$ = "$VER: POINTER_UsePointer 1.1 (08.01.2017) by Dแmaso 'AmiSpaTra' Domํnguez based over 'UsePointer.c' code by Luke Wood "+CHR$(0)

' ---------------------------------------------------------------------
'           Some vars / Algunas variables
' ---------------------------------------------------------------------

PointerBase& = NULL&
ch&          = NULL& ' First custom pointer  / Primer puntero a medida
mych&        = NULL& ' Second custom pointer / Segundo puntero a medida
done&        = FALSE&
class&       = 0&
code&        = 0&
mesg&        = NULL&
x%           = 0%
y%           = 0%

' NewWindow struct / Estructura NewWindow para una nueva ventana
' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
wcfg$        = STRING$(NewWindow_sizeof%, CHR$(0))

win&         = NULL&

' IDCMP flags: I use the new IDCMP_#? tags
' Atributos IDCMP: Utilizo las nuevas etiquetas IDCMP_#?
' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
iflg&        = IDCMP_MOUSEBUTTONS& OR IDCMP_CLOSEWINDOW&

' I've removed the window size gadget & I use the new WFLG_#? tags
' He eliminado el tirador de tama๑o y utilizo las nuevas etiquetas WFLG_#?
' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
wflg&        = WFLG_ACTIVATE& OR WFLG_NOCAREREFRESH& OR WFLG_CLOSEGADGET& OR WFLG_DRAGBAR& OR WFLG_DEPTHGADGET&

' This value is for a 16 bits field (word)!
' กEste valor es para un campo de 16 bits (palabra)!
' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
wtype&       = WBENCHSCREEN&

' ---------------------------------------------------------------------
'      Window's attribs (I don't initialize null fields, because
'            the struct was created filled with zeroes).
'                                 ---==---
'      Atributos de la ventana ( no inicializo los campos nulos,
'        porque la estructura ha sido creada rellena de ceros).
' ---------------------------------------------------------------------

'POKEW SADD(wcfg$)+NewWindowLeftEdge%,        0%
'POKEW SADD(wcfg$)+NewWindowTopEdge%,         0%
POKEW SADD(wcfg$)+NewWindowWidth%,          300%
POKEW SADD(wcfg$)+NewWindowHeight%,         100%
'POKEB SADD(wcfg$)+NewWindowDetailPen%,       0%
POKEB SADD(wcfg$)+NewWindowBlockPen%,         1%


POKEL SADD(wcfg$)+NewWindowIDCMPFlags%,    iflg&
POKEL SADD(wcfg$)+NewWindowFlags%,         wflg&
'POKEL SADD(wcfg$)+NewWindowFirstGadget%,  NULL&
'POKEL SADD(wcfg$)+NewWindowCheckMark%,    NULL&
POKEL SADD(wcfg$)+NewWindowTitle%,         SADD("MyWindow"+CHR$(0))
'POKEL SADD(wcfg$)+NewWindowScreen%,       NULL&
'POKEL SADD(wcfg$)+NewWindowBitMap%,       NULL&
POKEW SADD(wcfg$)+NewWindowMinWidth%,        25%
POKEW SADD(wcfg$)+NewWindowMinHeight%,       20%
POKEW SADD(wcfg$)+NewWindowMaxWidth%,     32767%
POKEW SADD(wcfg$)+NewWindowMaxHeight%,    32767%
POKEW SADD(wcfg$)+NewWindowType%,         wtype&

' ---------------------------------------------------------------------
'               Opening libraries / Abriendo bibliotecas
' ---------------------------------------------------------------------
LIBRARY OPEN "exec.library",         33&
LIBRARY OPEN "intuition.library",    33&
LIBRARY OPEN "graphics.library",     33&

PointerBase& = OpenLibrary(SADD("pointer.library"+CHR$(0)), 33&)

IF PointerBase& THEN

	' With this line, I can use now the PointerLib' functions/subs
	' Con esta lํnea, ya puedo utilizar las subrutinas y funciones de la biblioteca 'Pointer'
	' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
	LIBRARY VARPTR "pointer.library", PointerBase&

	' Loading a custom pointer (crosshair) : The C Example uses the file "Pointer.ilbm" not available r8-?
	' Cargando un puntero a medida (mirilla): El ejemplo en C utiliza el fichero " Pointer.ilbm" no disponible r8-?
	' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
	ch& = LoadPointer&(SADD("CrossHair.ilbm"+CHR$(0)))
	' Or/o... ch& = LoadPointer&(SADD("SYS:Prefs/Presets/CrossHair.ilbm"+CHR$(0)))

	' Enhacing the original example: Other custom pointer
	' Mejorando el ejemplo original: Otro puntero con dise๑o a medida
	' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
	mych& = LoadPointer&(SADD("GhostPointer.ilbm"+CHR$(0)))

	win& = OpenWindow&(SADD(wcfg$))

	IF win& THEN

		SetAPen PEEKL(win&+RPort%),   1
		Move    PEEKL(win&+RPort%),   0,  50
		Draw    PEEKL(win&+RPort%), 300,  50
		Move    PEEKL(win&+RPort%), 150,   0
		Draw    PEEKL(win&+RPort%), 150, 100

		Move    PEEKL(win&+RPort%), 205,  33
		Text    PEEKL(win&+RPort%), SADD("Ghost"+CHR$(0)), 5
		Move    PEEKL(win&+RPort%),  50,  80
		Text    PEEKL(win&+RPort%), SADD("CrossHair"+CHR$(0)), 9
		Move    PEEKL(win&+RPort%),  65,  32
		Text    PEEKL(win&+RPort%), SADD("Busy"+CHR$(0)), 4
		Move    PEEKL(win&+RPort%), 205,  80
		Text    PEEKL(win&+RPort%), SADD("Normal"+CHR$(0)), 6

		WHILE done& = FALSE&

			dummy& = WaitPort&(PEEKL(win&+UserPort%))
			' Or/o... dummy& = xWait&(1& << PEEKB(PEEKL(win&+UserPort%)+mp_SigBit%))

			mesg&  = GetMsg&(PEEKL(win&+UserPort%))

			IF mesg& THEN

				' Saving the relevant info / Guardando la informaci๓n relevante
				' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
				class& = PEEKL(mesg&+Class%)
				code&  = PEEKW(mesg&+IntuiMessageCode%)

				' The coordinates (0,0) will be at the window center (width: 300, height: 100)
				' Las coordenadas (0,0) estarแn en el centro de la ventana (anchura: 300, altura: 100)
				' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
				x%     = PEEKW(mesg&+IntuiMessageMouseX%)-(300/2)
				y%     = PEEKW(mesg&+IntuiMessageMouseY%)-(100/2)

				' Releasing the message / Liberando el mensaje
				' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
				ReplyMsg mesg&

				' Somebody has pressed the close gadget?
				' ฟSe ha pulsado el bot๓n de cierre de la ventana?
				' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
				IF class& = IDCMP_CLOSEWINDOW& THEN

					PRINT "Message: CLOSEWINDOW / Mensaje: CERRARVENTANA."
					done& = TRUE&

				ELSE

					' See the readme file / Lea el fichero tipo l้ame del paquete
					' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
					IF code& = SELECTDOWN& THEN

						PRINT "X:";x%;", Y:";y%

						' My version offers four pointers / Mi versi๓n ofrece cuatro punteros
						' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
						IF x% >= 0 THEN

							IF y% > 0 THEN

								PRINT "Normal pointer / Puntero: Normal"
								ClearPointer win&

							ELSE

								IF mych& THEN

									PRINT "Ghost pointer / Puntero: Fantasma"
									SetPointer win&, PEEKL(mych&+pointer_Data%), PEEKL(mych&+pointer_Height%), PEEKL(mych&+pointer_Width%), PEEKL(mych&+pointer_XOff%), PEEKL(mych&+pointer_YOff%)

								ELSE

									PRINT "LoadPointer() has failed: No Ghost pointer! / La funci๓n LoadPointer&() ha fracasado: กNo hay puntero ";CHR$(34);"fantasma";CHR$(34);"!"

								END IF

							END IF

						ELSE

							IF y% > 0 THEN

								IF ch& THEN

									PRINT "CrossHair pointer / Puntero: Mirilla"
									SetPointer win&, PEEKL(ch&+pointer_Data%), PEEKL(ch&+pointer_Height%), PEEKL(ch&+pointer_Width%), PEEKL(ch&+pointer_XOff%), PEEKL(ch&+pointer_YOff%)

								ELSE

									PRINT "LoadPointer() has failed: No CrossHair pointer! / La funci๓n LoadPointer&() ha fracasado: กNo hay puntero con forma de mira telesc๓pica!"

								END IF

							ELSE

								PRINT "Busy pointer / Puntero: Ocupado (Kickstart 2.x)"
								SetBusyPointer win&

							END IF

						END IF

					END IF

				END IF

			END IF

		WEND

		IF win& THEN CloseWindow win&

	ELSE

		PRINT "Window failed to open / กSe ha fracasado al intentar abrir la ventana!"

	END IF

ELSE

	PRINT "Pointer Library failed to open / กSe ha fracasado al intentar abrir la biblioteca 'Pointer'!"

END IF

' Releasing the custom pointers
' Liberando los punteros dise๑ados a medida
' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
IF mych& THEN FreePointer mych&
IF ch&   THEN FreePointer ch&

' The C version forget to close the Graphics Library
' La versi๓n en C olvida cerrar la biblioteca grแfica 'Graphics'
' จจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจจ
LIBRARY CLOSE

END

' *EOF*
