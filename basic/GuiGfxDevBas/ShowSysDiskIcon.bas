' *********************************************************************
'                      Based over the instructions
'               included in "GuiGFXLib/doc/examples" file
'                by Tim S. Müller -- All Rights Reserved

'                           ShowSysDiskIcon
'      HBasic code 1.0a by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'       Este ejemplo muestra la imagen del icono "SYS:Disk.info"
'                si éste existe y si está instalado
'           el tipo de datos para este tipo de ficheros :).

'            This example shows the "SYS:Disk.info" image
'    IF THE FILE EXISTS & YOU HAVE INSTALLED THE Amiga Icon DT :).
' *********************************************************************

REM $NOWINDOW

REM $include exec.bc        ' NULL&
REM $include utility.bc     ' TAG_DONE&
REM $include graphics.bc    ' Estructuras/Structs: ViewPort
REM $include intuition.bc   ' Estructuras/Structs: Screen, Window
REM $include guigfx.bh

pict&  = NULL&
psm&   = NULL&
chand& = NULL&
dhand& = NULL&

' Dos etiquetas y sus dos valores (0-3)
'  Two tags and their two values (0-3)
' -------------------------------------
DIM tags&(3)

WINDOW 1,"Ejemplo / Example - guigfx.library",(48,69)-(480,130),1+2+4+16

LIBRARY OPEN "guigfx.library"

' Nombre del fichero gráfico / Graphic filename
' ---------------------------------------------
file$ = "SYS:Disk.info"

IF FEXISTS(file$) THEN

	file$ = file$ + CHR$(0)

	pict& = LoadPictureA&(SADD(file$),NULL&)

	psm&  = CreatePenShareMapA&(NULL&)

	IF (psm& AND pict&) <> NULL& THEN

		chand& = AddPictureA&(psm&,pict&,NULL&)

		IF chand& <> NULL& THEN

			win&  = WINDOW(7)
			scr&  = PEEKL(win& + WScreen%)

			'    Hay dos posibilidades: o rp& = WINDOW(8) o...
			' There is two posibilities: or rp&  = WINDOW(8) or...
			' ------------------------------------------------------
			rp&   = PEEKL(win& + RPort%)

			cmap& = PEEKL(scr& + ScreenViewPort% + ColorMap%)

			TAGLIST VARPTR(tags&(0)), _
				GGFX_DitherMode&, DITHERMODE_EDD&, _
				TAG_DONE&

			dhand& = ObtainDrawHandleA&(psm&, rp&, cmap&, VARPTR(tags&(0)))

		END IF

		DeletePenShareMap psm&

		END IF

		IF dhand& <> NULL& THEN
				dummy& = DrawPictureA&(dhand&, pict&, 5&, 5&, NULL&)
		END IF

	IF pict& <> NULL& THEN DeletePicture pict&

	LOCATE 4,15:PRINT "Pulse una tecla para salir/Press any key for to end"+CHR$(13)

	' Esperando que se presione una tecla para terminar
	'              Press any key for to end
	' -------------------------------------------------
	DO
		SLEEP
	LOOP UNTIL INKEY$ <> ""

	IF dhand& <> NULL& THEN

		'       El Sr. MÜller advierte que la imagen no puede estar visible, cuando
		'            se libere el gestor de dibujo ("drawhandle"), o sea,
		'   que deberá limpiar/borrar el puerto de barrido ("rastport") previamente.
		'
		'      You must to clear the rastport, previous to release the drawhandle.
		' -------------------------------------------------------------------------------
		CLS
		ReleaseDrawHandle dhand&

	END IF

ELSE

	BEEP

END IF

WINDOW CLOSE 1

LIBRARY CLOSE

END

DATA "$VER: ShowSysDiskIcon 1.0a (20.07.03) by Dámaso Domínguez <amidde@arrakis.es> "+CHR$(0)
