OPT MODULE

MODULE 'exec/io',
       'exec/memory',
       'exec/nodes',
       'exec/ports'

ENUM ERR_NONE, ERR_SIG

RAISE ERR_SIG IF AllocSignal()=-1

EXPORT PROC beginIO(ioreq:PTR TO io)
  DEF base
  base:=ioreq.device
  MOVEA.L base, A6
  MOVEA.L ioreq, A1
  JSR -30(A6)
ENDPROC

EXPORT PROC createStdIO(port) IS createExtIO(port, SIZEOF iostd)

EXPORT PROC deleteStdIO(ioReq) IS deleteExtIO(ioReq)

EXPORT PROC createExtIO(port, ioSize) HANDLE
  DEF ioReq=NIL:PTR TO io
  IF port
    ioReq:=NewM(ioSize, MEMF_CLEAR OR MEMF_PUBLIC)
    ioReq.mn.ln.type:=NT_REPLYMSG
    ioReq.mn.length:=ioSize
    ioReq.mn.replyport:=port
  ENDIF
EXCEPT DO
ENDPROC ioReq

EXPORT PROC deleteExtIO(ioReq:PTR TO io)
  IF ioReq
    ioReq.mn.ln.succ:=-1
    ioReq.mn.replyport:=-1
    ioReq.device:=-1
    Dispose(ioReq)
  ENDIF
ENDPROC
