
-> wbGadTools is an abstraction of GadTools gadgets.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'gadtools'
MODULE 'fw/wbObject','fw/wbIDCMP'

OBJECT wbGadTools OF wbIDCMP
ENDOBJECT

-> Performs the appropriate action when the signal is received.
PROC handleActivation() OF wbGadTools
  DEF result=PASS,msg
  WHILE msg:=Gt_GetIMsg(self.port)
    result:=self.handleMessage(msg)
    IF result=PASS THEN Gt_ReplyIMsg(msg)
    EXIT result>CONTINUE
  ENDWHILE
ENDPROC result

-> Flush all pending messages at the object's MsgPort.
PROC flushPort() OF wbGadTools
  DEF msg
  Forbid()
  WHILE msg:=Gt_GetIMsg(self.port)
    Gt_ReplyIMsg(msg)
  ENDWHILE
  Permit()
ENDPROC

