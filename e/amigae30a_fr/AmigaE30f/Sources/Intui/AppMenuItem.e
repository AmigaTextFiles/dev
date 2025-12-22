/* AppMenuItem.e, en provenance des RKRM libraries 3ème edition. */

OPT OSVERSION=37

MODULE 'wb'

DEF myport,appitem,appmsg

PROC main()
  IF workbenchbase:=OpenLibrary('workbench.library',37)
    IF myport:=CreateMsgPort()
      IF appitem:=AddAppMenuItemA(0,0,'DisplayBeep()',myport,NIL)
        WriteF('Allez, regardez ce qu\ail y a des le menu Tools ...\n')
        WaitPort(myport)
        DisplayBeep(NIL)
        WriteF('Hé, vous l\aavez trouvé!\n')
        RemoveAppMenuItem(appitem)
        WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
      ENDIF
      DeleteMsgPort(myport)
    ENDIF
  ENDIF
ENDPROC
