-> a2d.e

->>> Header (globals)
MODULE 'timer',
       'utility',
       'devices/timer',
       'exec/io',
       'utility/date'

ENUM ERR_NONE, ERR_DEV, ERR_LIB

RAISE ERR_DEV IF OpenDevice()<>0,
      ERR_LIB IF OpenLibrary()=NIL
->>>

->>> PROC main()
PROC main() HANDLE
  DEF clockdata:PTR TO clockdata, tr:PTR TO timerequest, tv:PTR TO timeval,
      seconds, open_dev=FALSE
  utilitybase:=OpenLibrary('utility.library', 37)
  NEW tr, tv, clockdata
  OpenDevice('timer.device', UNIT_VBLANK, tr, 0)
  open_dev:=TRUE
  timerbase:=tr.io.device

  GetSysTime(tv)

  WriteF('GetSysTime():\t\d \d\n', tv.secs, tv.micro)

  Amiga2Date(tv.secs, clockdata)

  WriteF('Amiga2Date():  sec \d min \d hour \d\n',
         clockdata.sec, clockdata.min, clockdata.hour)

  WriteF('               mday \d month \d year \d wday \d\n',
         clockdata.mday, clockdata.month, clockdata.year, clockdata.wday)

  seconds:=CheckDate(clockdata)

  WriteF('CheckDate():\t\d\n', seconds)

  seconds:=Date2Amiga(clockdata)

  WriteF('Date2Amiga():\t\d\n', seconds)
EXCEPT DO
  IF open_dev THEN CloseDevice(tr)
  END clockdata, tv, tr
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_DEV;  WriteF('Error: could not open timer device\n')
  CASE ERR_LIB;  WriteF('Error: could not open utility library\n')
  CASE "MEM";    WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC
->>>
