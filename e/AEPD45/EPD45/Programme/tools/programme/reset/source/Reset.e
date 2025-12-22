/* Reset Programm in AMIGA E. Mit ReqTools oder Standard Requester */

OPT OSVERSION=37     /* Benötige DOS2.04+ */

MODULE 'ReqTools'

PROC main()
  IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
   IF RtEZRequestA('Reset Routine durchführen?','* RESET *|* NEIN *',0,0,0)
    DisplayBeep(0)  /* Bildschirm Beep, RESET Anmeldung */
    Delay(100)      /* Warte sicherheitshalber 2 Sekunden */
    ColdReboot()    /* Reset durchführen */
   ELSE
    RtEZRequestA('OK! Ich führe kein Reset aus!','* ABBRUCH *',0,0,0)
    CloseLibrary(reqtoolsbase)
   ENDIF
  ELSE              /* ReqTools nicht vorhanden, nutze Standard */
   IF request('Reset Routine durchführen?','* RESET *|* NEIN *',0)
    DisplayBeep(0)  /* Bildschirm Beep, RESET Anmeldung */
    Delay(100)      /* Warte sicherheitshalber 2 Sekunden */
    ColdReboot()    /* Reset durchführen */
   ELSE
    request('OK! Ich führe kein Reset aus!','* ABBRUCH *',0)
   ENDIF
  ENDIF
  CleanUp(0)
ENDPROC

 CHAR '\0$VER: \e[1mRESET_Programm\e[m 1.11 (23.01.95)\0'

PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,0,body,gadgets],0,args)
