OPT MODULE
OPT EXPORT

MODULE 'exec/ports'
MODULE 'intuition/screens'
MODULE 'screennotify'
MODULE 'libraries/screennotify'

OBJECT dd_screennotify
  PRIVATE
  screen:PTR TO screen
  client:LONG
  port:PTR TO mp
  PUBLIC
  signalmask
ENDOBJECT

PROC new(screen) OF dd_screennotify
  self.screen:=screen
  IF screennotifybase:=OpenLibrary('screennotify.library',0)
    self.port:=CreateMsgPort()
    IF self.port
      self.signalmask:=Shl(1,self.port.sigbit)
      self.client:=AddCloseScreenClient(self.screen,self.port,0)
    ENDIF
  ENDIF
ENDPROC
PROC end() OF dd_screennotify
  DEF msg
  IF screennotifybase
    IF self.client
      RemCloseScreenClient(self.client)
      self.client:=NIL
    ENDIF
    IF self.port
      WHILE msg:=GetMsg(self.port) DO ReplyMsg(self.port)
      DeleteMsgPort(self.port)
      self.port:=NIL
      self.signalmask:=0
    ENDIF
    CloseLibrary(screennotifybase)
  ENDIF
ENDPROC

PROC signalmask() OF dd_screennotify IS self.signalmask

PROC handle() OF dd_screennotify
  DEF msg
  WHILE msg:=GetMsg(self.port) DO ReplyMsg(msg)
ENDPROC
