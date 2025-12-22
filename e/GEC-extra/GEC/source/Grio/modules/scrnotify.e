OPT MODULE
OPT REG=5


MODULE 'exec/ports','exec/ports','exec/nodes','exec/tasks'
MODULE 'screennotify','libraries/screennotify'
MODULE 'intuition/screens'
MODULE 'dos/dosextens','dos/dostags','dos/dos'
MODULE 'other/geta4','grio/taskname'



EXPORT ENUM SCRNOTIFY_STATUS_WBCLOSE,
            SCRNOTIFY_STATUS_WBOPEN,
            SCRNOTIFY_STATUS_CHANGED,
            SCRNOTIFY_STATUS_CLOSED


OBJECT threadmsg
    mn:mn
    obj:LONG
ENDOBJECT



EXPORT OBJECT scrnotifymsg
   mn:mn
   status:LONG
ENDOBJECT



EXPORT OBJECT scrnotify
    signal
    port:PTR TO mp
    PRIVATE
    screen:PTR TO screen
    obase:LONG
    base:LONG
    thread:PTR TO process
    ownport
    pri
    mtask
    wbscr
    report
    break
ENDOBJECT



PROC new(screen=NIL) OF scrnotify
  DEF succ=FALSE
  self.obase:=screennotifybase
  self.mtask:=FindTask(NIL)
  IF KickVersion(36)
     IF (screennotifybase:=OpenLibrary('screennotify.library',1))
         IF (self.report:=CreateMsgPort())
            self.base:=screennotifybase
            self.wbscr:=OpenWorkBench()
            IF screen=NIL
               IF (screen:=LockPubScreen(NIL))
                  UnlockPubScreen(NIL,screen)
               ENDIF
            ENDIF
            IF screen
               self.screen:=screen
               succ:=TRUE
            ENDIF
         ENDIF
     ENDIF
  ENDIF
  IF succ=FALSE THEN RETURN self.end()
ENDPROC succ



PROC end() OF scrnotify
  DEF msg
  self.remnotify()
  IF self.report
     DeleteMsgPort(self.report)
     self.report:=NIL
  ENDIF
  IF self.ownport
     WHILE (msg:=GetMsg(self.ownport)) DO  ReplyMsg(msg)
     DeleteMsgPort(self.ownport)
  ENDIF
  IF self.base
     CloseLibrary(self.base)
     screennotifybase:=self.obase
  ENDIF
ENDPROC



PROC notify(port=NIL:PTR TO mp,pri=0) OF scrnotify
   DEF s[50]:STRING,succ=FALSE,mn:PTR TO threadmsg
   IF self.screen
      IF port=NIL
         self.ownport:=port:=CreateMsgPort()
      ENDIF
      IF port
         IF (mn:=New(SIZEOF threadmsg))
            mn::ln.type:=NT_MESSAGE
            mn.obj:=self
            mn.mn.length:=SIZEOF threadmsg
            mn.mn.replyport:=self.report
            StringF(s,'\s Screen Notifier',taskName())
            self.break:=FALSE
            storea4()
            IF (self.thread:=CreateNewProc([NP_ENTRY,{thread},NP_NAME,s,
                                            NP_PRIORITY,20,NIL]))
                self.port:=port
                self.signal:=Shl(1,port.sigbit)
                self.pri:=pri
                PutMsg(self.thread.msgport,mn)
                succ:=TRUE
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDPROC succ


PROC remnotify() OF scrnotify
IF self.thread
    self.break:=TRUE
    Signal(self.thread,SIGBREAKF_CTRL_C)
    WaitPort(self.report)
    Dispose(GetMsg(self.report))
    self.thread:=NIL
ENDIF
ENDPROC NIL




PROC thread()
  DEF sig,notsig,mn:PTR TO screennotifymessage,value,type
  DEF cls,wb,pub,obj:PTR TO scrnotify,mport:PTR TO mp,msig
  DEF port:PTR TO mp,mainmsg:PTR TO threadmsg
 -> GetA4()
  geta4()
  port:=FindTask(NIL)::process.msgport
  WaitPort(port)
  mainmsg:=GetMsg(port)
  obj:=mainmsg.obj
  IF (port:=CreateMsgPort())
     IF (mport:=CreateMsgPort())
        IF (cls:=AddCloseScreenClient(obj.screen,port,obj.pri))
           IF (pub:=AddPubScreenClient(port,obj.pri))
              IF (wb:=AddWorkbenchClient(port,obj.pri))
                 notsig:=Shl(1,port.sigbit)
                 msig:=Shl(1,mport.sigbit)
                 REPEAT
                    sig:=Wait(notsig OR msig OR SIGBREAKF_CTRL_C)
                    SELECT sig
                        CASE notsig
                           IF (mn:=GetMsg(port))
                              value:=mn.value
                              type:=mn.type
                              ReplyMsg(mn)
                              mn:=NIL
                              SELECT type
                                 CASE SCREENNOTIFY_TYPE_CLOSESCREEN
                                     IF obj.screen=value
                                        mn:=makemsg(mport,SCRNOTIFY_STATUS_CLOSED)
                                     ENDIF
                                 CASE SCREENNOTIFY_TYPE_WORKBENCH
                                     IF obj.wbscr=obj.screen
                                        mn:=makemsg(mport,value)
                                     ENDIF
                                 DEFAULT
                                     IF obj.screen=value::pubscreennode.screen
                                        mn:=makemsg(mport,SCRNOTIFY_STATUS_CHANGED)
                                     ENDIF
                              ENDSELECT
                              IF mn THEN PutMsg(obj.port,mn)
                           ENDIF
                        CASE msig
                           IF (mn:=GetMsg(mport))
                              Dispose(mn)
                           ENDIF
                    ENDSELECT
                 UNTIL obj.break
                 WHILE (mn:=GetMsg(port)) DO ReplyMsg(mn)
                 WHILE (mn:=GetMsg(mport)) DO Dispose(mn)
                 WHILE RemWorkbenchClient(wb)=FALSE DO Delay(10)
              ENDIF
              WHILE RemPubScreenClient(pub)=FALSE DO Delay(10)
           ENDIF
           WHILE RemCloseScreenClient(cls)=FALSE DO Delay(10)
        ENDIF
        DeleteMsgPort(mport)
     ENDIF
     DeleteMsgPort(port)
  ENDIF
  ReplyMsg(mainmsg)
ENDPROC


PROC makemsg(port,value)
  DEF mn:PTR TO scrnotifymsg
  IF (mn:=New(SIZEOF scrnotifymsg))
     mn::ln.type:=NT_MESSAGE
     mn.mn.length:=SIZEOF scrnotifymsg
     mn.mn.replyport:=port
     mn.status:=value
  ENDIF
ENDPROC mn




