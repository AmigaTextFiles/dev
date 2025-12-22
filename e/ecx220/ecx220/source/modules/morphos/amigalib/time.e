OPT MORPHOS, MODULE

MODULE 'devices/timer',
       'exec/io'

EXPORT PROC timeDelay(unit, seconds, micros)
  DEF port, tr:PTR TO timerequest, error=TRUE
  IF port := CreateMsgPort()
    IF tr := CreateIORequest(port, SIZEOF timerequest)
      IF OpenDevice('timer.device', unit, tr, 0) = 0
        tr.time.secs := seconds
        tr.time.micro := micros
        tr.io.command := TR_ADDREQUEST
        DoIO(tr)
        CloseDevice(tr)
        error := FALSE
      ENDIF
      DeleteIORequest(tr)
    ENDIF
    DeleteMsgPort(port)
  ENDIF
ENDPROC error



