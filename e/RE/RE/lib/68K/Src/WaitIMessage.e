/*
*/
OPT NOHEAD,NOEXE
MODULE 'exec','intuition/intuition'
DEF code,qual,iaddr
PROC WaitIMessage(win:PTR TO Window)
  DEF port,mes:PTR TO IntuiMessage,class
  port:=win.UserPort
  IFN (mes:=GetMsg(port))
    REPEAT
      WaitPort(port)
    UNTIL (mes:=GetMsg(port))<>NIL
  ENDIF
  class:=mes.Class
  code:=mes.Code
  qual:=mes.Qualifier
  iaddr:=mes.IAddress
  ReplyMsg(mes)
ENDPROC class
PROC MsgCode() IS code
PROC MsgQualifier() IS qual
PROC MsgIaddr() IS iaddr
