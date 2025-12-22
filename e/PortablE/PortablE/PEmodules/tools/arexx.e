/* History:
03-03-2009: Disabled "rexxsysbase:=mes.libbase" as it appears to be in error, and is not supported by AROS either.  AROS issue reported by Chris Young.
12-11-2008: Added auto-opening of rexxsyslib library, as Chris Young says it is done by his copy of this AmigaE module.
11-11-2008: Released as part of PortablE r3 beta1.
*/

OPT MODULE
OPT POINTER
OPT PREPROCESS

MODULE 'exec/ports', 'exec/nodes', 'rexx/storage', 'rexxsyslib'
MODULE 'exec'
MODULE 'std/pCallback', 'rexx/rxslib', 'dos/dos'

RAISE "MEM" IF CreateArgstring()=NIL

PROC new()
	rexxsysbase := OpenLibrary(rxsname, 39)
	IF rexxsysbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(rexxsysbase)
ENDPROC


PROC rx_OpenPort(portname:ARRAY OF CHAR)
  DEF port:PTR TO mp,sig:BYTE,exc:QUAD, ln:PTR TO ln
  NEW port
  exc:=0
  Forbid()
  IF FindPort(portname)
    exc:="DOUB"
  ELSE
    port.sigtask:=FindTask(NILA)
    port.flags:=PA_SIGNAL
    ln := port !!PTR!!PTR TO ln
    ln.name:=portname
    ln.type:=NT_MSGPORT
    IF (sig:=AllocSignal(-1))=NIL
      exc:="SIG"
    ELSE
      port.sigbit:=sig !!INT!!UBYTE
      AddPort(port)
    ENDIF
  ENDIF
  Permit()
  IF exc THEN Raise(exc)
ENDPROC port,Shl(1,sig)

PROC rx_ClosePort(port:PTR TO mp)
  IF port
    FreeSignal(port.sigbit)
    RemPort(port)
    END port
  ENDIF
ENDPROC

PROC rx_GetMsg(port:PTR TO mp)
  DEF mes:PTR TO rexxmsg,arg:ARRAY OF CHAR
  IF mes:=GetMsg(port) !!PTR!!PTR TO rexxmsg
    ->rexxsysbase:=mes.libbase
    arg := mes.args[0] #ifndef pe_TargetOS_AROS !!VALUE #endif !!ARRAY OF CHAR
  ELSE
    arg := NILA
  ENDIF
ENDPROC mes,arg

PROC rx_ReplyMsg(mes:PTR TO rexxmsg,rc=0,resultstring=NILA:ARRAY OF CHAR)
  mes.result1:=rc
  mes.result2:=NIL
  IF mes.action AND RXFF_RESULT AND (rc=0) AND (resultstring<>NIL)
    mes.result2:=CreateArgstring(resultstring,StrLen(resultstring))
  ENDIF
  ReplyMsg(mes !!PTR!!PTR TO mn)
ENDPROC

PROC rx_HandleAll(interpret_proc:PTR,portname:ARRAY OF CHAR)
  DEF port:PTR TO mp,sig,quit,mes:PTR TO rexxmsg,s,rc,rs:ARRAY OF CHAR, rsv
  port:=NIL
  quit:=FALSE
  port,sig:=rx_OpenPort(portname)
  REPEAT
    Wait(sig)
    REPEAT
      mes,s:=rx_GetMsg(port)
      IF mes 
        quit,rc,rsv:=call1many(interpret_proc, s) ; rs:=rsv!!ARRAY OF CHAR
        rx_ReplyMsg(mes,rc,rs)
      ENDIF
    UNTIL (mes=NIL) OR (quit=TRUE)
  UNTIL quit
  Raise(0)
FINALLY
  rx_ClosePort(port)
ENDPROC
