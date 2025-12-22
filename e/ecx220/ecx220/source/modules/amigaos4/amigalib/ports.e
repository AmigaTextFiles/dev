OPT AMIGAOS4, MODULE

-> amigalib/ports.e

MODULE 'exec/lists',
       'exec/memory',
       'exec/nodes',
       'exec/ports'

EXPORT PROC createPort(name, pri)
  DEF port:PTR TO mp
  port := CreateMsgPort()
  IF port
     IF name
        port.ln.name := name
        port.ln.pri := pri
        AddPort(port)
     ENDIF
  ENDIF
ENDPROC port

EXPORT PROC deletePort(port:PTR TO mp)
  IF port.ln.name THEN RemPort(port)
  DeleteMsgPort(port)
ENDPROC




