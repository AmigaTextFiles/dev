OPT MODULE

MODULE 'amigalib/io',
       'amigalib/ports',
       'devices/timer',
       'exec/io'

EXPORT PROC timeDelay(unit, seconds, micros)
  DEF port, tr:PTR TO timerequest, error=TRUE
  IF port:=createPort(NIL, 0)
    IF tr:=createExtIO(port, SIZEOF timerequest)
      IF OpenDevice('timer.device', unit, tr, 0)=0
        tr.time.secs:=seconds
        tr.time.micro:=micros
        tr.io.command:=TR_ADDREQUEST
        DoIO(tr)
        CloseDevice(tr)
        error:=FALSE
      ENDIF
      deleteExtIO(tr)
    ENDIF
    deletePort(port)
  ENDIF
ENDPROC error
