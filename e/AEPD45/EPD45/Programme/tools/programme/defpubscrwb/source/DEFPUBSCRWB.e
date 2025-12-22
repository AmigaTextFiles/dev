/* DEFAULT Public Screen TO Workbench Programm */

OPT OSVERSION=37    /* Sicherheitshalber Dos Abfrage OS2+ */ 

MODULE 'reqtools', 'libraries/reqtools', 'intuition/screens' /* MODULE holen */

PROC main()         /* Programm beginnen */
 IF request('Soll die Workbench der DEFAULT PublicScreen sein?','* Ja *|* Nein *')
  SetDefaultPubScreen(NIL)
 ENDIF
ENDPROC

 CHAR '\0$VER:\e[1mDEFPUBSCRWB 1.1\e[0m (23.01.95)\0'

PROC request(txt,knopf) /* Requester Wahl und Ausgabe */
 DEF erg
 IF reqtoolsbase:=OpenLibrary('reqtools.library',38)
  erg:=RtEZRequestA(txt,knopf,0,0,[RTEZ_REQTITLE,'DEFPUBSCRWB 1.1'])
 ELSE
  erg:=EasyRequestArgs(0,[20,0,'DEFPUBSCRWB 1.1',txt,knopf],0,NIL)
 ENDIF
 CloseLibrary(reqtoolsbase)
ENDPROC erg
