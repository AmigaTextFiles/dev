OPT MODULE, PREPROCESS

MODULE 'locale',
       'amitcp/sys/time',
       'devices/timer',
       'exec/devices',
       'exec/io',
       'exec/libraries',
       'libraries/locale'

RAISE "MEM" IF String()=NIL,
      "MEM" IF List()=NIL

EXPORT DEF timerbase:PTR TO dd, __time_zone:PTR TO timezone, __local_to_GMT,
           __daylight, __timezone, __tzname:PTR TO LONG, __zone_string

DEF unit

EXPORT PROC openTimer()
  DEF dummyTimer:timerequest, dstoff
  IF __time_zone=NIL
    NEW __time_zone
    __local_to_GMT:=Mul(8*365+(8/4),Mul(24,60*60))
    __tzname:=List(2)
    StrCopy(__zone_string:=String(12), 'GMT0')
  ENDIF
  IF timerbase=NIL
    OpenDevice('timer.device', UNIT_VBLANK, dummyTimer, 0)
    timerbase:=dummyTimer.node.unit
    IF timerbase.lib.version >= 36
      dstoff:=setlocale()
      __timezone:=__time_zone.minuteswest*60
      __local_to_GMT:=__local_to_GMT+__timezone
      IF dstoff>3 THEN __daylight:=TRUE ELSE dstoff:=3
      SetStr(__zone_string, 3)
      ListCopy(__tzname[0], [__zone_string, __zone_string+dstoff])
    ENDIF
  ENDIF
ENDPROC

PROC setlocale() HANDLE
  DEF thisLocale=NIL:PTR TO locale
  localebase:=OpenLibrary('locale.library', 38)
  thisLocale:=OpenLocale(NIL)
  __time_zone.minuteswest:=thisLocale.gmtoffset
EXCEPT DO
  IF thisLocale THEN CloseLocale(thisLocale)
  IF localebase THEN CloseLibrary(localebase)
ENDPROC IF exception THEN retrysetlocale() ELSE 0

PROC retrysetlocale()
  DEF file=NIL, len, i, dstoff=0, value
  IF file:=Open('ENV:TZ', OLDFILE)
    IF 3<(len:=Read(file, __zone_string, EstrLen(__zone_string)))
      FOR i:=0 TO len-1
        EXIT __zone_string[i] < " "
      ENDFOR
      SetStr(__zone_string, i)
      IF 0<(dstoff:=StrToLong(__zone_string+3, {value}))
        __time_zone.minuteswest:=value*60
        dstoff:=dstoff+3
      ENDIF
    ENDIF
    Close(file)
  ENDIF
ENDPROC dstoff

EXPORT PROC closeTimer()
  DEF dummyTimer:timerequest
  IF timerbase
    dummyTimer.node.device:=timerbase
    dummyTimer.node.unit:=unit
    CloseDevice(dummyTimer)
  ENDIF
ENDPROC

EXPORT PROC tzset()
ENDPROC
