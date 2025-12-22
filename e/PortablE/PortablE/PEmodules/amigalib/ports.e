 OPT MODULE, POINTER

MODULE 'amigalib/lists',
       'exec/lists',
       'exec/memory',
       'exec/nodes',
       'exec/ports'
MODULE 'exec'

PROC createPort(name:ARRAY OF CHAR, pri)
  DEF sigBit, port:PTR TO mp
  sigBit:=-1
  sigBit:=AllocSignal(-1)
  port:=AllocMem(SIZEOF mp, MEMF_CLEAR OR MEMF_PUBLIC)
  port.ln.name:=name
  port.ln.pri:=pri !!BYTE
  port.ln.type:=NT_MSGPORT
  port.flags:=PA_SIGNAL
  port.sigbit:=sigBit !!UBYTE
  port.sigtask:=FindTask(NILA)
  IF name
    AddPort(port)
  ELSE
    newList(port.msglist !!PTR)
  ENDIF
FINALLY
  IF exception
    IF port THEN FreeMem(port, SIZEOF mp)
    IF sigBit<>-1 THEN FreeSignal(sigBit)
    port := NIL
  ENDIF
ENDPROC port

PROC deletePort(port:PTR TO mp)
  IF port.ln.name THEN RemPort(port)
  port.sigtask:=-1 !!VALUE!!ARRAY
  port.msglist.head:=-1 !!VALUE!!ARRAY
  FreeSignal(port.sigbit)
  FreeMem(port, SIZEOF mp)
ENDPROC
