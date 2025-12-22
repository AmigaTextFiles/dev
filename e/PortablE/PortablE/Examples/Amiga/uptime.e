/* An old YAEC example converted to PortablE.
   Included with permission from Leif. */

-> uptime.e

MODULE 'dos/dos', 'dos/dosextens',
        'utility/date', 'utility'
MODULE 'exec', 'dos'

ENUM ERR_NONE, ERR_INFO, ERR_LIB, ERR_LOCK

RAISE ERR_INFO IF Info()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_LOCK IF Lock()=NIL

PROC main()
  DEF infodata:PTR TO infodata, ramdevice:PTR TO devlist
  DEF now:PTR TO datestamp, currenttime, boottime
  DEF lock:BPTR, d, h, m
  utilitybase:=OpenLibrary('utility.library', 37)
  NEW infodata
  NEW now
  lock:=Lock('RAM:', SHARED_LOCK)
  Info(lock, infodata)
  -> E-Note: convert BCPL pointer
  ramdevice:=Baddr(infodata.volumenode)
  -> yaec-note : operators are 32bit! we can use * instead of Mul()
  boottime:=(ramdevice.volumedate.days * 86400) + (ramdevice.volumedate.minute * 60) + Mod(ramdevice.volumedate.tick, TICKS_PER_SECOND)
  DateStamp(now)
  currenttime:=(now.days * 86400) + (now.minute * 60) + Mod(now.tick, TICKS_PER_SECOND)
  currenttime:=currenttime-boottime
  IF currenttime > 0
    -> E-Note: a multiple assignment gets the two UdivMod32() results
    d, h :=UdivMod32(currenttime, 86400)
    h, m :=UdivMod32(h, 3600)
    m:=UdivMod32(m, 60)
    Print('Up for \d days, \d hours, \d minutes\n', d, h, m)
  ENDIF
FINALLY
  IF lock THEN UnLock(lock)
  END now
  END infodata
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_INFO;  Print('Error: could not get info on lock\n')
  CASE ERR_LIB;   Print('Error: could not open utility library\n')
  CASE ERR_LOCK;  Print('Error: could not lock RAM:\n')
  CASE "MEM";     Print('Error: ran out of memory\n')
  ENDSELECT
ENDPROC

