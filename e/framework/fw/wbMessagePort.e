
-> wbMessagePort is an abstraction of exec message ports.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'exec/ports'
MODULE 'fw/wbObject'

OBJECT wbMessagePort OF wbObject
  port:PTR TO mp
ENDOBJECT

-> Exec signal associated with this WB object.
PROC signal() OF wbMessagePort
ENDPROC IF self.port THEN self.port.sigbit ELSE -1

-> Perform the appropriate action when a message is received.
PROC handleActivation() OF wbMessagePort
  DEF result=PASS,msg
  WHILE msg:=GetMsg(self.port)
    result:=self.handleMessage(msg)
    IF result=PASS THEN ReplyMsg(msg)
    EXIT result>CONTINUE
  ENDWHILE
ENDPROC result

-> Handle the receipt of a message at the object's MsgPort.
PROC handleMessage(msg) OF wbMessagePort IS STOPALL

-> Creates a MsgPort and attaches it to the object.
-> Return FALSE if failed.
PROC makePort() OF wbMessagePort
  self.port:=CreateMsgPort()
ENDPROC self.port<>NIL

-> Flush all pending messages at the object's MsgPort.
PROC flushPort() OF wbMessagePort
  DEF msg
  Forbid()
  WHILE msg:=GetMsg(self.port)
    ReplyMsg(msg)
  ENDWHILE
  Permit()
ENDPROC

-> Deletes the MsgPort attached to the object.
PROC deletePort() OF wbMessagePort
  DEF msg
  Forbid()
  self.flushPort()
  DeleteMsgPort(self.port)
  Permit()
  self.port:=NIL
ENDPROC

-> Remove the port.
PROC remove() OF wbMessagePort IS self.deletePort()

