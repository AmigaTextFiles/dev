/* Reset Programm in Hilfsmittel Menu */

OPT OSVERSION=37   /* Braucht mindestens Workbench/Kickstart 2.x */

MODULE 'wb'

DEF myport,appitem,appmsg

PROC main()
  IF workbenchbase:=OpenLibrary('workbench.library',37) /* Zugriff auf Workbench */
    IF myport:=CreateMsgPort()
      IF appitem:=AddAppMenuItemA(0,0,'»» Reset ««',myport,NIL) /* Menu einsetzen */
        IF EasyRequestArgs(0,[20,0,'Reset Tool ©1995 Andreas Rehm','Programm ist nun im Speicher.\nSoll es im Menu bleiben?','* Ja *|* Nein - ENTFERNEN *'],0,NIL)
         WaitPort(myport)
         DisplayBeep(NIL)
         Delay(100)
         ColdReboot()
        ENDIF
        RemoveAppMenuItem(appitem)
        WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
      ENDIF
      DeleteMsgPort(myport)
    ENDIF
  ENDIF
ENDPROC

CHAR '\0$VER: \e[32mResetprogramm Menu Version 1.05\e[m (23.01.95)\0'
