-> appwindow.e -- Show use of an AppWindow

OPT OSVERSION=37

MODULE 'wb',
       'exec/ports',
       'intuition/intuition',
       'workbench/startup',
       'workbench/workbench'

ENUM ERR_NONE, ERR_APPWIN, ERR_LIB, ERR_PORT, ERR_WIN

RAISE ERR_APPWIN IF AddAppWindowA()=NIL,
      ERR_LIB    IF OpenLibrary()=NIL,
      ERR_PORT   IF CreateMsgPort()=NIL,
      ERR_WIN    IF OpenWindowTagList()=NIL

PROC main() HANDLE
  DEF awport=NIL:PTR TO mp, win=NIL:PTR TO window, appwin=NIL,
      imsg:PTR TO intuimessage, amsg:PTR TO appmessage, argptr:PTR TO wbarg,
      winsig, appwinsig, signals, id=1, userdata=0, done=FALSE, i
  workbenchbase:=OpenLibrary('workbench.library', 37)
  -> The CreateMsgPort() function is in Exec version 37 and later only
  awport:=CreateMsgPort()
  win:=OpenWindowTagList(NIL, [WA_WIDTH, 200, WA_HEIGHT, 50,
                               -> E-Note: C version uses obsolete flags
                               WA_IDCMP, IDCMP_CLOSEWINDOW,
                               WA_FLAGS, WFLG_CLOSEGADGET OR WFLG_DRAGBAR,
                               WA_TITLE, 'AppWindow',
                               NIL])
  appwin:=AddAppWindowA(id, userdata, win, awport, NIL)
  WriteF('AppWindow added... Drag files into AppWindow\n')
  winsig:=Shl(1, win.userport.sigbit)
  appwinsig:=Shl(1, awport.sigbit)
  REPEAT
    -> Wait for IDCMP messages and AppMessages
    signals:=Wait(winsig OR appwinsig)

    IF signals AND winsig  -> Got an IDCMP message
      WHILE imsg:=GetMsg(win.userport)
        -> E-Note: C version uses obsolete flags
        IF imsg.class=IDCMP_CLOSEWINDOW THEN done:=TRUE
        ReplyMsg(imsg)
      ENDWHILE
    ENDIF
    IF signals AND appwinsig  -> Got an AppMessage
      WHILE amsg:=GetMsg(awport)
        WriteF('AppMsg: Type=\d, ID=\d, NumArgs=\d\n',
               amsg.type, amsg.id, amsg.numargs)
        argptr:=amsg.arglist
        FOR i:=0 TO amsg.numargs-1
          WriteF('   arg(\d): Name="\s", Lock=\h\n',
                 i, argptr.name, argptr.lock)
          argptr++
        ENDFOR
        ReplyMsg(amsg)
      ENDWHILE
    ENDIF
  UNTIL done

EXCEPT DO
  IF appwin THEN RemoveAppWindow(appwin)
  IF win THEN CloseWindow(win)
  IF awport
    -> Make sure there are no more outstanding messages
    WHILE amsg:=GetMsg(awport) DO ReplyMsg(amsg)
    DeleteMsgPort(awport)
  ENDIF
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  SELECT exception
  CASE ERR_APPWIN; WriteF('Error: Could not create AppWindow\n')
  CASE ERR_LIB;    WriteF('Error: Could not open required library\n')
  CASE ERR_PORT;   WriteF('Error: Could not create port\n')
  CASE ERR_WIN;    WriteF('Error: Could not open window\n')
  ENDSELECT
ENDPROC