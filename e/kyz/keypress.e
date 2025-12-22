-> execute a stream of raw keypresses (see rawkeys.m)

OPT MODULE,OSVERSION=36

MODULE 'devices/inputevent', 'devices/input', 'exec/io'

EXPORT OBJECT keypress
  code:CHAR, qual:CHAR
ENDOBJECT

EXPORT PROC presskeys(keylist:PTR TO keypress, listlen)
  DEF port, io:PTR TO iostd, evt:inputevent,
      lastc1=0, lastq1=0, lastc2=0, lastq2=0

  IF port := CreateMsgPort()
    IF io := CreateIORequest(port, SIZEOF iostd)
      IF OpenDevice('input.device', 0, io, 0)=0
        WHILE listlen-- >= 0
          evt.class         := IECLASS_RAWKEY
          evt.code          := keylist[].code
          evt.qualifier     := keylist[].qual
          evt.prev1downcode := lastc1
          evt.prev1downqual := lastq1
          evt.prev2downcode := lastc2
          evt.prev2downqual := lastq2

          io.command := IND_WRITEEVENT
          io.data    := evt
          io.length  := SIZEOF inputevent
          DoIO(io)

          lastc2 := lastc1
          lastq2 := lastq1
          lastc1 := keylist[].code
          lastq1 := keylist[].qual

          evt.class         := IECLASS_RAWKEY
          evt.code          := keylist[].code OR IECODE_UP_PREFIX
          evt.qualifier     := keylist[].qual
          evt.prev1downcode := lastc1
          evt.prev1downqual := lastq1
          evt.prev2downcode := lastc2
          evt.prev2downqual := lastq2

          io.command := IND_WRITEEVENT
          io.data    := evt
          io.length  := SIZEOF inputevent
          DoIO(io)

          keylist++
        ENDWHILE
        CloseDevice(io)
      ENDIF
      DeleteIORequest(io)
    ENDIF
    DeleteMsgPort(port)
  ENDIF
ENDPROC
