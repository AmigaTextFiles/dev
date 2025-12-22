/* MouseXY von Andreas Rehm ©1995 */

MODULE 'intuition/intuition' /* Systemmodul anfordern */

DEF win

PROC main()                  /* Hauptprozedur */
 DEF x:PTR TO INT, y:PTR TO INT, sx[17]:STRING
 IF EasyRequestArgs(0,[20,0,'MouseXY','                   MouseXY ©1995 von Andreas Rehm\n\nDas Programm braucht c.a. 0 bis 5\s Rechenleistung für sich.\n    (Maximal 35% auf einem A3000 - 68030 CPU und 10 MB RAM)\n\nDieses Programm ist noch nicht an die Programmierrichtlinien\nangepaßt! Es braucht also manchmal etwas mehr Prozessor-\nleistung. -> Wird noch geändert.\n\nDas Programm wird durch gleichzeitiges drücken auf den linken\nund rechten Mausknopf beendet!\n\n  Maximal darstellbare Screengröße: 10\a000 * 10\a000 Pixel.\n                  (X und Y von 0 bis 9999)\n\n\n              Wollen Sie MouseXY wirklich starten?','Ja|Um Himmels Willen NEIN !!!'],0,['%'])
  IF win:=OpenW(0,0,130,11,$200,0,'MouseXY',0,1,NIL,NIL) /* Fenster öffnen */
   SetWindowTitles(win,-1,'                MouseXY ©1995 bei Andreas Rehm') /* Fenstertitle ändern */
   Delay(50) /*  Eine Sekunde warten */
   WHILE Mouse()<>3 /* Wenn linker und rechter Mausknopf gedrückt Schleife verlassen */
    x:=MouseX(win)  /* X Mausposition holen */
    y:=MouseY(win)  /* Y Mausposition holen */
    StringF(sx,'X: \d[4] Y: \d[4]',x,y)  /* Ergebnisse formatieren */
    SetWindowTitles(win,sx,-1) /* Ergebnis in Titelzeile des Fensters */
    Delay(2)        /* 2/50 Sekunden warten, damit wir nicht zuviel Rechenpower brauchen */
   ENDWHILE         /* Ende der Schleife */
   SetWindowTitles(win,'Ende...','                MouseXY endet... Auf wiedersehen.')
   Delay(50)        /* Eine Sekunde warten */
  ELSE
   EasyRequestArgs(0,[20,0,'MouseXY','KannFenster nicht öffnen!','OK'],0,NIL) /* Wenn Fenster nicht erstellbar Fehlerausgabe */
  ENDIF
  CloseW(win)
 ENDIF              /* Fenster schließen */
 CleanUp(0)         /* Aufräumen und beenden */
ENDPROC

CHAR '\0$VER: MouseXY 1.01 (10.04.95) (© Copyright by Andreas Rehm - HAWK-Software)\0'
