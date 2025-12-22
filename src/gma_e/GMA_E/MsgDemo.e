/* Demonstriert Abfrage von 2 Message-Ports */

OPT OSVERSION=37

ENUM ER_NONE, ER_NO_WBL, ER_NO_MSG_PORT, ER_NO_APP_ITEM

MODULE 'wb','exec/ports'

DEF appmsg1  = NIL,
    appmsg2  = NIL,
    appitem1 = NIL,
    appitem2 = NIL,
    port1    : mp,
    port2    : mp


PROC main() HANDLE
  IF (workbenchbase := OpenLibrary('workbench.library',
      37)) = NIL THEN Raise(ER_NO_WBL)

    IF (port1 := CreateMsgPort()) = NIL THEN Raise(ER_NO_MSG_PORT)
    IF (port2 := CreateMsgPort()) = NIL THEN Raise(ER_NO_MSG_PORT)
    IF (appitem1 := AddAppMenuItemA(0,0,'Item A', port1,
        NIL)) = NIL THEN Raise(ER_NO_APP_ITEM)
    IF (appitem2 := AddAppMenuItemA(0,0,'Item B', port2,
        NIL)) = NIL THEN Raise(ER_NO_APP_ITEM)

    Wait( Shl(1, port1.sigbit) OR
          Shl(1, port2.sigbit)  )

    WHILE appmsg1 := GetMsg(port1)
      ReplyMsg(appmsg1)
      WriteF('AppPort 1.\n')
    ENDWHILE

    WHILE appmsg2 := GetMsg(port2)
      ReplyMsg(appmsg2)
      WriteF('AppPort 2.\n')
    ENDWHILE

    DisplayBeep(NIL)
    Delay(100)
    Raise(ER_NONE)

EXCEPT
  IF appitem1 THEN RemoveAppMenuItem(appitem1)
  IF appitem2 THEN RemoveAppMenuItem(appitem2)

  WHILE appmsg1 := GetMsg(port1) DO ReplyMsg(appmsg1)
  WHILE appmsg2 := GetMsg(port2) DO ReplyMsg(appmsg2)

  IF port1 THEN DeleteMsgPort(port1)
  IF port2 THEN DeleteMsgPort(port2)

  IF workbenchbase THEN CloseLibrary(workbenchbase)
  WriteF('\n\n')
  SELECT exception
    CASE ER_NONE        ; NOP
    CASE ER_NO_WBL      ; WriteF('No wb.lib. !')
    CASE ER_NO_MSG_PORT ; WriteF('No MsgPort !')
    CASE ER_NO_APP_ITEM ; WriteF('No AppItem !')
  ENDSELECT
  WriteF('\n\n')
ENDPROC

