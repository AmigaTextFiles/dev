-> appmenuitem.e -- Show use of an AppMenuItem

OPT OSVERSION=37

MODULE 'wb',
       'dos/dostags',
       'workbench/startup',
       'workbench/workbench'

ENUM ERR_NONE, ERR_APPMENU, ERR_LIB, ERR_PORT

RAISE ERR_APPMENU IF AddAppMenuItemA()=NIL,
      ERR_LIB     IF OpenLibrary()=NIL,
      ERR_PORT    IF CreateMsgPort()=NIL

PROC main() HANDLE
  DEF myport=NIL, appitem=NIL,
      appmsg=NIL:PTR TO appmessage, result, x, count=0, file
  workbenchbase:=OpenLibrary('workbench.library', 37)
  -> The CreateMsgPort() function is in Exec version 37 and later only
  myport:=CreateMsgPort()
  -> Add our own AppMenuItem to the Workbench Tools Menu
  appitem:=AddAppMenuItemA(0,                   -> Our ID# for item
                          'SYS:Utilities/More', -> Our UserData
                          'Browse Files',       -> MenuItem Text
                           myport, NIL)         -> MsgPort, no tags

  WriteF('Select Workbench Tools demo menuitem "Browse Files"\n')

  -> For this example, we allow the AppMenuItem to be selected only once,
  -> then we remove it and exit
  WaitPort(myport)
  WHILE (appmsg:=GetMsg(myport)) AND (count<1)
    -> Handle messages from the AppMenuItem - we have only one item so we don't
    -> have to check its appmsg.id number.  We'll System() the command string
    -> that we passed as userdata when we added the menu item.  We find our
    -> userdata pointer in appmsg.userdata

    WriteF('User picked AppMenuItem with \d icons selected\n', appmsg.numargs)
    FOR x:=0 TO appmsg.numargs-1
      WriteF('  #\d name="\s"\n', x+1, appmsg.arglist[x].name)
    ENDFOR

    INC count
    IF file:=Open('CON:0/40/640/150/AppMenu Example/auto/close/wait', OLDFILE)
      result:=SystemTagList(appmsg.userdata, [SYS_INPUT,  file,
                                              SYS_OUTPUT, NIL,
                                              SYS_ASYNCH, TRUE, NIL])
      -> If Asynch System() itself fails, we must close file
      IF result=-1 THEN Close(file)
    ENDIF
    ReplyMsg(appmsg)
  ENDWHILE

EXCEPT DO
  IF appitem THEN RemoveAppMenuItem(appitem)
  IF myport
    -> Clear away any messages that arrived at the last moment
    -> and let Workbench know we're done with the messages
    WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
    DeleteMsgPort(myport)
  ENDIF
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  SELECT exception
  CASE ERR_APPMENU; WriteF('Error: Could not attach AppMenuItem to Workbench\n')
  CASE ERR_LIB;     WriteF('Error: Could not open workbench.library\n')
  CASE ERR_PORT;    WriteF('Error: Could not create port\n')
  ENDSELECT
ENDPROC