/* MouseCheck ©1995 - bei Andreas Rehm

   Dieses Programm ist für die Startupsequence gedacht und es meldet,
   welcher MausKnopf gedrückt wurde. Mann kann durch ein Script dann
   verschiedene Operationen starten oder verhindern.
*/

OPT OSVERSION=37 /* Mindestens OS 2.04 */

PROC main()
 DEF butt
 IF butt:=Mouse()  /* Abfrage und Auswertung der Maus */
  IF butt=1
   WriteF('LB')    /* linker Knopf */
  ELSEIF butt=2
   WriteF('RB')    /* rechter Knopf */
  ELSEIF butt=3
   WriteF('LB+RB') /* linker und rechter Knopf */
  ELSEIF butt=4
   WriteF('MB')    /* mittlerer Knopf */
  ENDIF
 ELSE
  WriteF('0')      /* kein Knopf */
 ENDIF
 CleanUp(0)        /* beenden */
ENDPROC

CHAR '\0$VER:MouseChecker 1.001 (08.02.95)\0' /* Versionsinformation */
