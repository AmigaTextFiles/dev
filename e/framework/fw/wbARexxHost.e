
-> wbARexxHost is an abstraction of Rexx language Host.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'exec/nodes','rexx/storage','rexxsyslib'
MODULE 'fw/wbObject','fw/wbMessagePort'

OBJECT wbARexxHost OF wbMessagePort
ENDOBJECT

-> Create an ARexx Host.
-> Return FALSE if failed.
PROC create(name) OF wbARexxHost HANDLE
  IF rexxsysbase=NIL THEN Raise(0)
  Forbid()
  IF FindPort(name)
    Permit()
    Raise(0)
  ENDIF
  Permit()
  IF self.makePort()=FALSE THEN Raise(0)
  PutLong(self.port+10,name)
  AddPort(self.port)
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> Handle the receipt of a REXX message.
PROC handleMessage(msg:PTR TO rexxmsg) OF wbARexxHost
ENDPROC PASS

-> Handle the receipt of QUIT command.
PROC handleQuit() OF wbARexxHost IS STOPALL

-> Remove the ARexx Host.
PROC remove() OF wbARexxHost
  IF self.port THEN self.deletePort()
ENDPROC

