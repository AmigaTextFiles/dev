' *SOF*

'  *********************************************************************
'                             TM_ShowImage.bas
'             by/de Copyright 2015 Dámaso "AmiSpaTra" Estévez
'                            {miast, esteson,eu}
'           AmiSpaTra - http://www.xente.mundo-r.com/amispatra/
'  *********************************************************************
'                 Based over the ShowImage.c example code
'                   by Copyright 1990-1998 Stefan Becker
'               All rights reserved over MY derivative work:
'               This Hisoft/Maxon Basic developpers package.
'        Forbidden to remove ALL legal/copyrights remarks included
'       in this package: If you create a derivative work from mine,
'                   you MUST to include ALL legal notes.
'
'              Shows an image file using a ToolManager's dock
'                                   ----
'              Basado en el código de ejemplo de ShowImage.c
'        escrito por/propiedad de Copyright 1990-1998 Stefan Becker.
'         Todos los derechos reservados sobre MI trabajo derivado:
'                    Este paquete para desarrolladores
'                  que programen con Hisoft/Maxon Basic.
'           Está prohibido eliminar cualquier comentario o nota
'      de autoría/legal de este paquete: Si crea un trabajo derivado
'     del mío HA DE INCLUIR OBLIGATORIAMENTE TODAS LAS NOTAS LEGALES.
'
'    Muestra un imagen en fichero utilizando un "botón" de ToolManager
'  *********************************************************************

OPTION BASE 1

' ---------------------------------------------------------------------
'        Compiler's metacommands (see the Hisoft Basic Manual)
' Metacomandos para el compilador (consulte el manual del Hisoft Basic)
' ---------------------------------------------------------------------
REM $NOWINDOW
REM $NOLIBRARY
REM $NOBREAK

' ---------------------------------------------------------------------
'                    Include files / Ficheros de inclusión
' ---------------------------------------------------------------------

'   OS / SO
' ------------
REM $include exec.bh
REM $include dos.bc
REM $include utility.bc

' ToolManager
' -----------
REM $include toolmanager.bh

' ---------------------------------------------------------------------
'    From/De:  http://aminet.net/package/dev/basic/AST_HBRoutines
' ---------------------------------------------------------------------
REM $include BLib_AST/SGetArg.bas
REM $include BLib_AST/StrTo.bas

' ---------------------------------------------------------------------
'              C= string version / Cadena de versión de C=
' ---------------------------------------------------------------------

vstring$ = "$VER: TM_ShowImage 1.0 (27.09.2015) by Dámaso 'AmiSpaTra' Domínguez based over the C code wrote by Stephan Becker"+CHR$(0)

'   =====================================================================
'                       Main section / Sección principal
'   =====================================================================

' Return code / Código de retorno (hipótesis inicial)
' ---------------------------------------------------
rc& = RETURN_FAIL&

'            Only from Shell/CLI
' Sólo desde la interfaz de línea de comandos
' -------------------------------------------
IF PEEKL(SYSTAB+8) <> 0 THEN
        BEEP
        GOTO quitting
END IF

'          Obtaining the image filename
'   Obteniendo el nombre del fichero con la imagen
' ------------------------------------------------
p$ = SGetArg$(1%,"IMGFILE")

IF FEXISTS(p$) <> 0 THEN

        LIBRARY OPEN "exec.library",36&
        LIBRARY OPEN "toolmanager.library", TMLIBVERSION&

        ' An string (C style) / Una cadena al estilo C
        ' --------------------------------------------
        p$ =Str2C$(p$)

        ' Some vars / Algunas variables
        ' -----------------------------
        DIM tool&(3)

        objtype1$ = Str2C$("Image-Imagen")
        objtype2$ = Str2C$("View-Mostrar")

        DIM tags&(2*2-1) ' Tags & their values / Etiquetas y sus valores
        DIM dock&(8*2-1) ' Tags & their values / Etiquetas y sus valores

        tool&(1) = NULL&
        tool&(2) = SADD(objtype1$)
        tool&(3) = NULL&

        TAGLIST VARPTR(tags&(1)),                  _
                TMOP_File&,              SADD(p$), _
                TAG_DONE&

        TAGLIST VARPTR(dock&(1)),               _
                TMOP_Activated&,            TRUE&, _
                TMOP_Border&,               TRUE&, _
                TMOP_Centered&,             TRUE&, _
                TMOP_FrontMost&,            TRUE&, _
                TMOP_Images&,               TRUE&, _
                TMOP_Columns&,                 1&, _
                TMOP_Tool&,      VARPTR(tool&(1)), _
                TAG_DONE&

        ' Creating the handle / Creando el manejador
        ' ------------------------------------------
        handle& = AllocTMHandle&

        IF handle& THEN

                ' Creating the image / Creando la imagen
                ' --------------------------------------
                IF CreateTMObjectTagList&(handle&, tool&(2), TMOBJTYPE_IMAGE&, VARPTR(tags&(1))) THEN

                        ' Creating the dock with your image / Creando el botón con su imagen
                        ' ------------------------------------------------------------------
                        IF CreateTMObjectTagList&(handle&, SADD(objtype2$), TMOBJTYPE_DOCK&, VARPTR(dock&(1))) THEN

                                ' Show info how to quit the program / Muestra información de cómo salir del programa
                                ' ----------------------------------------------------------------------------------
                                PRINT "Press CTRL C, D, E or F for to end this little example!"
                                PRINT "¡Presione CTRL C, D, E o F para terminar este pequeño ejemplo!"

                                ' Waiting the CTRL C|D|E|F signals / Esperando las señales CTRL C|D|E|F
                                ' ---------------------------------------------------------------------
                                dummy& = xWait&(&H0000F000&)

                                '          Releasing the object (simple example: I check none)
                                ' Liberando el objeto (como es un ejemplo sencillo no compruebo si fracasa)
                                ' -------------------------------------------------------------------------
                                dummy& = DeleteTMObject&(handle&, SADD(objtype2$))

                                rc& = RETURN_OK&

                        END IF

                      '          Releasing the object (simple example: I check none)
                      ' Liberando el objeto (como es un ejemplo sencillo no compruebo si fracasa)
                      ' -------------------------------------------------------------------------
                      dummy& = DeleteTMObject&(handle&, tool&(2))

               END IF

               '  Releasing the handle
               ' Liberando el manejador
               ' ----------------------
               FreeTMHandle handle&

        END IF

ELSE

        BEEP
        PRINT "[INGLÉS ] You must add the name of a graphic file exists as an argument."
        PRINT "[SPANISH] Ha de añadir como argumento el nombre de un fichero gráfico que exista."

END IF

' =======
quitting:
' =======
LIBRARY CLOSE

STOP rc&

' *EOF*
