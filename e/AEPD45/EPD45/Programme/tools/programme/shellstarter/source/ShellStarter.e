/* CLI Starter im Hilfsmittel Menü ©1994 von HAWK */

OPT OSVERSION=37

MODULE 'wb'

DEF myport,appitem,appmsg

PROC main()
 IF EasyRequestArgs(0,[20,0,'Shell Starter für WB Menü ©1994-95','            Shell Starter in WB Menü einfügen?\n\nEr kann entfernt werden, indem man den Menüpunkt aktiviert\nund dann bei der Abfrage auf ENTFERNEN drückt.','* Start *|* Ende *'],0,NIL)
  IF workbenchbase:=OpenLibrary('workbench.library',37)
   pt:
   IF myport:=CreateMsgPort()
    IF appitem:=AddAppMenuItemA(0,0,'=> Shell <=',myport,NIL)
     WaitPort(myport)
     Execute('sys:system/cli',0,NIL)
     RemoveAppMenuItem(appitem)
     WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
    ENDIF
    DeleteMsgPort(myport)
    IF EasyRequestArgs(0,[20,0,'Shell Starter ©1994-95','Shell Starter entfernen?','* NEIN *| ENTFERNEN '],0,NIL)
     JUMP pt
    ENDIF
   ENDIF
  ENDIF
 ENDIF
 CleanUp(0)
ENDPROC

 CHAR '\0$VER: \e[1mShell Starter 1.02\e[m (23.01.95)\0'
