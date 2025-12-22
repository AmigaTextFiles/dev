
/* AppMenuItem.e, loosely adapted from RKRM libraries 3rd ed. */

OPT OSVERSION=37

MODULE 'wb'

DEF myport,appitem,appmsg

PROC main()
  DEF workbenchbase
  IF workbenchbase:=OpenLibrary('workbench.library',37)
    IF myport:=CreateMsgPort()
      IF appitem:=AddAppMenuItemA(0,0,'DisplayBeep()',myport,NIL)
        WriteF('Come on, go and see whats in the Tools menu ...\n')
        WaitPort(myport)
        DisplayBeep(NIL)
        WriteF('Wow, you found it!\n')
        RemoveAppMenuItem(appitem)
        WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
      ENDIF
      DeleteMsgPort(myport)
    ENDIF
  ENDIF
ENDPROC
