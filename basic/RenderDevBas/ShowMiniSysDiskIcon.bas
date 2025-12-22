' *********************************************************************
'                          ShowMiniSysDiskIcon
'        HBASIC code 1.0 by Dámaso D. Estévez {amidde,arrakis,es}
'              AmiSpaTra - http://www.arrakis.es/~amidde/
'
'        Este ejemplo muestra la imagen del icono "SYS:Disk.info"
'                 si éste existe y si está instalado
'           el tipo de datos para este tipo de ficheros...
'              pero reduciendo su tamaño a la mitad.
'  Se requiere las bibiliotecas "render" (evidentemente ;) y "guigfx".

'               This example shows the "SYS:Disk.info" image
'    IF THIS FILE EXISTS & YOU HAVE INSTALLED THE Amiga Icon DT :)...
'                    but scaling their size to 1/2.
'    The program need the render (of course ;) & guigfx libraries.
' *********************************************************************

REM $NOWINDOW

OPTION BASE 0

REM $include exec.bc        ' NULL&
REM $include utility.bc     ' TAG_DONE&
REM $include graphics.bc    ' Estructuras / Structs: ViewPort
REM $include intuition.bc   ' Estructuras / Structs: Screen, Window
REM $include guigfx.bh
REM $include render.bh

pic1&  = NULL&
pic2&  = NULL&
psm&   = NULL&
chand& = NULL&
dhand& = NULL&
mhand& = NULL&

'               Atributos de la imagen:
' 5 valores + 256 valores de paleta - 1 (OPTION BASE 0)

'                   Image attribs: 
'  5 values + 256 palette's values - 1 (OPTION BASE 0)
' -----------------------------------------------------
DIM att&(5+256-1)

' Siete etiquetas como máximo: 7*2-1
'    Seven tags as maximum: 7*2-1
' ----------------------------------
DIM tags&(13)

' Mi ventana a través del HBasic
'     My window via HBasic
' ------------------------------
WINDOW 1,"Ejemplo / Example - (render|gfxgui).library",(68,99)-(460,190),1+2+4+16

' Abriendo las bibliotecas requeridas
'   Opening the libraries required
' -----------------------------------
LIBRARY OPEN "guigfx.library"
LIBRARY OPEN "render.library"

' Nombre del fichero gráfico / Graphic filename
' ---------------------------------------------
file$ = "SYS:Disk.info"

IF FEXISTS(file$) THEN

	file$ = file$ + CHR$(0)

	pic1& = LoadPictureA&(SADD(file$),NULL&)

	psm&  = CreatePenShareMapA&(NULL&)

	IF (psm& AND pic1&) <> NULL& THEN

		chand& = AddPictureA&(psm&,pic1&,NULL&)

		IF chand& <> NULL& THEN

			' Puntero a la estructura de la ventana
			'   y a la pantalla de la que depende
			'
			'    Window and screen struct pointer
			' ----------------------------------------
			win&  = WINDOW(7)
			scr&  = PEEKL(win& + WScreen%)

			'  Puntero al puerto de barrido
			'        Rastport's pointer
			' -------------------------------
			rp&   = WINDOW(8)

			' Puntero al mapa de color de la pantalla
			'         ColorMap struct pointer
			' ---------------------------------------
			cmap& = PEEKL(scr& + ScreenViewPort% + ColorMap%)

			TAGLIST VARPTR(tags&(0)), _
				GGFX_DitherMode&, DITHERMODE_EDD&, _
			TAG_DONE&

			dhand& = ObtainDrawHandleA&(psm&, rp&, cmap&, VARPTR(tags&(0)))

		END IF

		DeletePenShareMap psm&

		' ====================================================================

		'       Obteniendo algunas características de la imagen
		'       que utilizaremos para crear una nueva (reducida)

		'  Obtaining some image attribs for to create a new (reduced)
		' ------------------------------------------------------------

		TAGLIST VARPTR(tags&(0)), _
			PICATTR_Width&,             VARPTR(att&(0)), _
			PICATTR_Height&,            VARPTR(att&(1)), _
			PICATTR_RawData&,           VARPTR(att&(2)), _
			PICATTR_NumPaletteEntries&, VARPTR(att&(3)), _
			PICATTR_PixelFormat&,       VARPTR(att&(4)), _
			PICATTR_Palette&,           VARPTR(att&(5)), _
		TAG_DONE&

		' Función de GuiGfx / GuiGfx function
		' -----------------------------------
		natt& = GetPictureAttrsA&(pic1&, VARPTR(tags&(0)))

		IF natt& = 6 THEN

			'       Mostrando información de la imagen:
			'     ancho x alto x número de planos de color
			'
			' Showing image info: width x height x color deep
			' -----------------------------------------------
			LOCATE 2,2:PRINT "Imagen original / Original image: ";att&(0);"x";att&(1);"x";
			IF att&(3) = NULL& THEN
				' Color real / Truecolor
				PRINT "24"
			ELSE
				PRINT CINT(LOG(att&(3))/LOG(2))
			END IF

			engine& = CreateScaleEngineA&(att&(0),att&(1),att&(0)\2,att&(1)\2,TAG_DONE&)

   			IF engine& <> NULL& THEN

				' Cuando la imagen se reduce, puesto que los datos de destino ocupan MENOS
				'       que el origen se permite que origen y destino sean al mismo.
				'
				'   Only when the image is reduced, you can use as target the source ;)
				' ------------------------------------------------------------------------
				dummy&  = ScaleA&(engine&,att&(2),att&(2),TAG_DONE&)
				
				DeleteScaleEngine engine&

			END IF

			' Atributos de la nueva imagen
			'  Attribs for the new image
			' ----------------------------
			TAGLIST VARPTR(tags&(0)), _
				GGFX_NumColors&,     att&(3), _
				GGFX_PixelFormat&,   att&(4), _
				GGFX_Palette&,       VARPTR(att&(5)), _
				GGFX_PaletteFormat&, PALFMT_RGB8&, _
			TAG_DONE&

			' Función de GuiGfx / GuiGfx function
			' -----------------------------------
			pic2& = MakePictureA&(att&(2),att&(0)\2,att&(1)\2,VARPTR(tags&(0)))

			IF pic2& <> NULL& THEN

				TAGLIST VARPTR(tags&(0)), _
					GGFX_DitherMode&, DITHERMODE_EDD&,_
				TAG_DONE&

				LOCATE 5,10:PRINT "Mostrando la imagen del icono reducida a la mitad..."
				LOCATE 7,10:PRINT "Showing the icon's image reduced (->x0,5)..."

				' Dibujando la imagen en la ventana (imagen centrada verticalmente ;)
				'   Drawing the image in the window (imagen centered vertically ;)
				' -------------------------------------------------------------------
				IF dhand& <> NULL& THEN
					dummy& = DrawPictureA&(dhand&,pic2&,5&,(WINDOW(3)-(att&(1)\2))\2,VARPTR(tags&(0)))
				END IF

			END IF

			IF pic2& <> NULL& THEN DeletePicture pict2&

		END IF

		' =====================================================================

		IF pic1& <> NULL& THEN DeletePicture pict1&
		
	END IF

	LOCATE 10,2:PRINT "Pulse una tecla para salir / Press any key for to end"

	' Esperando que se presione una tecla para terminar
	'              Press any key for to end
	' -------------------------------------------------
	DO
		SLEEP
	LOOP UNTIL INKEY$ <> ""

	'       El Sr. MÜller advierte que la imagen no puede estar visible, cuando
	'            se libere el gestor de dibujo ("drawhandle"), o sea,
	'   que deberá limpiar/borrar el puerto de barrido ("rastport") previamente.
	'
	'      You must to clear the rastport, previous to release the drawhandle.
	' -------------------------------------------------------------------------------

	IF dhand& <> NULL& THEN
		CLS
		ReleaseDrawHandle dhand&
	END IF

ELSE

	BEEP

END IF

WINDOW CLOSE 1

LIBRARY CLOSE

END

DATA "$VER: ShowMiniSysDiskIcon 1.0 (27.07.03) by Dámaso Domínguez <amidde@arrakis.es>"
