' *********************************************************************
'                 Original "p61test" by Petter E. Stokke

'            C -> HBasic conversion (with enhacements ;) done
'                by Dámaso D. Estévez [amidde,arrakis,es]

'           All Rights Reserved / Todos los derechos reservados

'                                  ----

'         BEWARE! The documentation and the original example uses
'            function/subroutine's names slighty different r8-?
'                       i.e. pl61Play vs P61Play ;)

'    You can obtain P61 FILES FOR TO check this example from PT FILES
'                with Aminet:mus/misc/P6102.lha converter.
'                  This simple example plays modules if
'         the instruments are included and theses AREN'T packed.
'       Check the lib developper documentation for to enhace it ;)

'                                  ----

'        ¡CUIDADO! La documentación y el ejemplo original utiliza
'       nombres de funciones/subrutinas ligeramente diferentes r8-?
'                   p. ej. pl61Play versus P61Play ;).

'     Puede obtener ficheros en formato P61 para probar este ejemplo
'       a partir de ficheros en formato Protracker con el conversor
'                disponible en Aminet:mus/misc/P6102.lha.
'             Este sencillo ejemplo reproduce módulos cuando
'            incluyen los instrumentos y NO están comprimidos.
'             Consulte la documentación para desarrolladores
'          de la biblioteca si quiere mejorar el reproductor ;)
' *********************************************************************

REM $include dos.bh      ' Delay
REM $include exec.bh     ' AllocMem&, FreeMem / NULL&, TRUE&
REM $include graphics.bh ' WaitTOF
REM $include player61.bh ' P61_Play&, P61_Stop, P61_Inquire, P61_SetVol

' ---------------------------------------------------------------------

LIBRARY OPEN "dos.library",NULL&
LIBRARY OPEN "exec.library",NULL&
LIBRARY OPEN "graphics.library",NULL&
LIBRARY OPEN "player61.library",37&

file$ = RTRIM$(LTRIM$(COMMAND$))

PRINT CHR$(13);"Mini-example / Mini-ejemplo"
PRINT "===========================";CHR$(13)

IF file$ = "" THEN

   PRINT "[ENGLISH] I need a file P61 as argument!"
   PRINT "[ESPAÑOL] ¡Necesito como argumento un fichero en formato P61!"

ELSE

    ' Obteniendo el tamaño del fichero de música
    '        Obtaining the Music file size
    ' ------------------------------------------
   OPEN file$ AS #1
      size& = LOF(1)
   CLOSE #1

   mem& = AllocMem&(size&,MEMF_CHIP& OR MEMF_CLEAR&)

   IF mem& <> NULL& THEN

      BLOAD file$,mem&

      IF P61_Play&(mem&,NULL&,NULL&) <> NULL& THEN

         PRINT "[ENGLISH] Replaying failed!!"
         PRINT "[ESPAÑOL] ¡¡La reproducción ha fracasado!!"

      ELSE

         p& = P61_Inquire

         ' Alguna información sobre el módulo
         '    Some info about the module
         ' ----------------------------------
         PRINT "[ENGLISH] Volume-tempo at start:"
         PRINT "[SPANISH] Volumen-tempo inicial:"
         vl% = PEEKW(p&+p61status_volume%)
         PRINT TAB(1);vl%;"-";PEEKW(p&+p61status_tempo%)
         PRINT

         PRINT "[ENGLISH] Press `Q' key for to stop the music/quit!"
         PRINT "[ESPAÑOL] ¡Presione `Q' para detener la música/salir!"

         DO
            ' Para evitar una carga excesiva del procesador
            '           For avoid high CPU usage
            ' ---------------------------------------------
            SLEEP
         LOOP UNTIL UCASE$(INKEY$) = "Q"

         PRINT
         PRINT "Exiting... / Saliendo..."

         ' Fundido de salida
         '     Fade off
         ' -----------------
         FOR a% = vl% TO 0% STEP -1
            P61_SetVol a%
            Delay 1
         NEXT a%

         ' Sale del programa deteniendo la música y liberando la memoria
         '           Exits stopping the music & releasing memory
         ' -------------------------------------------------------------
         WaitTOF
         P61_Stop

         '  If I don't restore the original value and I re-start
         '   the program the volume will be zero (not sound)!!!
         '                         ---
         ' Si no restauro el volumen original y vuelvo a ejecutar
         ' el programa, el volumen será CERO (¡¡no se oirá nada!!)
         ' -------------------------------------------------------
         P61_SetVol vl%

      END IF

      FreeMem mem&,size&

   ELSE

      PRINT "[ENGLISH] Loading failed - Out of memory!"
      PRINT "[ESPAÑOL] Carga del módulo fallida - ¡Memoria insuficiente!"

   END IF

END IF

' ---------------------------------------------------------------------

END

DATA "$VER: p61test.bas 1.0 (06.06.03) by Dámaso D. Estévez <amidde@arrakis.es> "+CHR$(0)
