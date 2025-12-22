-> uptime.e

->>> Header (globals)
OPT PREPROCESS

MODULE 'utility',
       'dos/dos',
       'dos/dosextens',
       'utility/date'

ENUM ERR_NONE, ERR_INFO, ERR_LIB, ERR_LOCK

RAISE ERR_INFO IF Info()<>DOSTRUE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_LOCK IF Lock()=NIL
->>>

->>> PROC main()
PROC main() HANDLE
  DEF infodata=NIL:PTR TO infodata, ramdevice:PTR TO devlist,
      now=NIL:PTR TO datestamp, currenttime, boottime, lock=NIL, d, h, m
  utilitybase:=OpenLibrary('utility.library', 37)
  NEW infodata, now
  lock:=Lock('RAM:', SHARED_LOCK)
  Info(lock, infodata)
  -> E-Note: convert BCPL pointer
  ramdevice:=BADDR(infodata.volumenode)
  boottime:=Smult32(ramdevice.volumedate.days, 86400) +
            Smult32(ramdevice.volumedate.minute, 60) +
            SdivMod32(ramdevice.volumedate.tick, TICKS_PER_SECOND)
  DateStamp(now)
  currenttime:=Smult32(now.days, 86400) +
               Smult32(now.minute, 60) +
               SdivMod32(now.tick, TICKS_PER_SECOND)
  currenttime:=currenttime-boottime
  IF currenttime > 0
    -> E-Note: a multiple assignment gets the two UdivMod32() results
    d,h:=UdivMod32(currenttime, 86400)
    h,m:=UdivMod32(h, 3600)
    m:=UdivMod32(m, 60)
    WriteF('Up for \d days, \d hours, \d minutes\n', d, h, m)
  ENDIF
EXCEPT DO
  IF lock THEN UnLock(lock)
  END now, infodata
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_INFO;  WriteF('Error: could not get info on lock\n')
  CASE ERR_LIB;   WriteF('Error: could not open utility library\n')
  CASE ERR_LOCK;  WriteF('Error: could not lock RAM:\n')
  CASE "MEM";     WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC
->>>
