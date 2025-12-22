-> stayrandom()
-> Helps seed the random number generator.
OPT MODULE

MODULE 'dos/datetime','devices/timer','exec/ports','exec/nodes','dos/dos',
       'exec/io'

EXPORT PROC stayrandom()
 DEF ds:datestamp,
     timerMP:PTR TO mp, timerIO:PTR TO timerequest,
     io:PTR TO iostd,timername,time:PTR TO timeval,boo
 timername:='timer.device'
 IF timerMP := CreateMsgPort()
  IF timerIO:=CreateIORequest(timerMP,SIZEOF timerequest)
   IF OpenDevice(timername,UNIT_WAITUNTIL,timerIO,0)
    WriteF('¡\s did not open!\n',timername)
   ELSE
    io:=timerIO.io
    time:=timerIO.time
    io.command:=TR_GETSYSTIME
    IF DoIO(timerIO)
     WriteF('¡Timer \aGetSysTime\a Query failed.  Error - \d!\n', io.error)
    ELSE
     DateStamp(ds)
     Rnd(-VbeamPos()-ds.tick-time.micro)
     RndQ(VbeamPos()*ds.tick+time.micro)
    ENDIF
    CloseDevice(timerIO)
   ENDIF
   DeleteIORequest(timerIO)
   DeleteMsgPort(timerMP)
  ELSE
   WriteF('¡Couldn''t create I/O request!\n')
   DeleteMsgPort(timerMP)
  ENDIF
 ELSE
  WriteF('¡Couldn''t create message port!\n')
 ENDIF
ENDPROC
