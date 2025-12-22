OPT MODULE

MODULE 'exec/ports', 'exec/nodes', 'rexx/storage', 'rexxsyslib'

RAISE "MEM" IF CreateArgstring()=NIL

DEF rexxsysbase

EXPORT PROC rx_OpenPort(portname)
  DEF port:PTR TO mp,sig,exc=0
  NEW port
  Forbid()
  IF FindPort(portname)
    exc:="DOUB"
  ELSE
    port.sigtask:=FindTask(0)
    port.flags:=PA_SIGNAL
    port::ln.name:=portname
    port::ln.type:=NT_MSGPORT
    IF (sig:=AllocSignal(-1))=NIL
      exc:="SIG"
    ELSE
      port.sigbit:=sig
      AddPort(port)
    ENDIF
  ENDIF
  Permit()
  IF exc THEN Raise(exc)
ENDPROC port,Shl(1,sig)

EXPORT PROC rx_ClosePort(port:PTR TO mp)
  IF port
    FreeSignal(port.sigbit)
    RemPort(port)
    Dispose(port)
  ENDIF
ENDPROC

EXPORT PROC rx_GetMsg(port)
  DEF mes:PTR TO rexxmsg
  IF mes:=GetMsg(port)
    rexxsysbase:=mes.libbase
    RETURN mes,Long(mes.args)
  ENDIF
ENDPROC NIL,NIL

EXPORT PROC rx_ReplyMsg(mes:PTR TO rexxmsg,rc=0,resultstring=NIL)
  mes.result1:=rc
  mes.result2:=NIL
  IF mes.action AND RXFF_RESULT AND (rc=0) AND (resultstring<>NIL)
    mes.result2:=CreateArgstring(resultstring,StrLen(resultstring))
  ENDIF
  ReplyMsg(mes)
ENDPROC

EXPORT PROC rx_HandleAll(interpret_proc,portname) HANDLE
  DEF port=NIL,sig,quit=FALSE,mes,s,rc,rs
  port,sig:=rx_OpenPort(portname)
  REPEAT
    Wait(sig)
    REPEAT
      mes,s:=rx_GetMsg(port)
      IF mes 
        quit,rc,rs:=interpret_proc(s)
        rx_ReplyMsg(mes,rc,rs)
      ENDIF
    UNTIL (mes=NIL) OR (quit=TRUE)
  UNTIL quit
  Raise()
EXCEPT
  rx_ClosePort(port)
  IF exception THEN ReThrow()
ENDPROC
