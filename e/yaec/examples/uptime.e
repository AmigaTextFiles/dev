-> uptime.e


MODULE 'dos/dos', 'dos/dosextens',
        'utility/date', 'utility'

ENUM ERR_NONE, ERR_INFO, ERR_LIB, ERR_LOCK

RAISE ERR_INFO IF Info()<>TRUE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_LOCK IF Lock()=NIL

PROC main() HANDLE
  DEF infodata=NIL:PTR TO infodata, ramdevice:PTR TO devlist
  DEF now=NIL:PTR TO datestamp, currenttime:LONG, boottime:LONG
  DEF lock=NIL, d:LONG, h:LONG, m:LONG
  DEF utilitybase 
  utilitybase:=OpenLibrary('utility.library', 37)
  NEW infodata
  NEW now
  lock:=Lock('RAM:', SHARED_LOCK)
  Info(lock, infodata)
  -> E-Note: convert BCPL pointer
  ramdevice:=BADDR(infodata.volumenode)
  -> yaec-note : operators are 32bit! we can use * instead of Mul()
  boottime:=(ramdevice.volumedate.days * 86400) +
            (ramdevice.volumedate.minute * 60) +
            Mod(ramdevice.volumedate.tick, TICKS_PER_SECOND)
  DateStamp(now)
  currenttime:=(now.days * 86400) +
               (now.minute * 60) +
               Mod(now.tick, TICKS_PER_SECOND)
  currenttime:=currenttime-boottime
  IF currenttime > 0
    -> E-Note: a multiple assignment gets the two UdivMod32() results
    d, h :=UDivMod32(currenttime, 86400)
    h, m :=UDivMod32(h, 3600)
    m:=UDivMod32(m, 60)
    WriteF('Up for \d days, \d hours, \d minutes\n', d, h, m)
  ENDIF
EXCEPT DO
  IF lock THEN UnLock(lock)
  END now
  END infodata
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_INFO;  WriteF('Error: could not get info on lock\n')
  CASE ERR_LIB;   WriteF('Error: could not open utility library\n')
  CASE ERR_LOCK;  WriteF('Error: could not lock RAM:\n')
  CASE "MEM";     WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC

