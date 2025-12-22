OPT MODULE

MODULE 'amigalib/lists',
       'exec/lists',
       'exec/memory',
       'exec/nodes',
       'exec/ports'

EXPORT PROC createPort(name, pri) HANDLE
  DEF sigBit=-1, port=NIL:PTR TO mp
  sigBit:=AllocSignal(-1)
  port:=NewM(SIZEOF mp, MEMF_CLEAR OR MEMF_PUBLIC)
  port.ln.name:=name
  port.ln.pri:=pri
  port.ln.type:=NT_MSGPORT
  port.flags:=PA_SIGNAL
  port.sigbit:=sigBit
  port.sigtask:=FindTask(NIL)
  IF name
    AddPort(port)
  ELSE
    newList(port.msglist)
  ENDIF
  RETURN port
EXCEPT
  IF port THEN Dispose(port)
  IF sigBit<>-1 THEN FreeSignal(sigBit)
  RETURN NIL
ENDPROC

EXPORT PROC deletePort(port:PTR TO mp)
  IF port.ln.name THEN RemPort(port)
  port.sigtask:=-1
  port.msglist.head:=-1
  FreeSignal(port.sigbit)
  Dispose(port)
ENDPROC
