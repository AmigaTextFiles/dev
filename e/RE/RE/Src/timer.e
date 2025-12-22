/*
*/
MODULE	'devices/timer',
        'timer',
        'exec/io',
        'exec/memory'

/*
;====================================================================
; taken from MysticView source ?
;--------------------------------------------------------------------
;
;	handle = timerstart()
;	d0
;		initialisiert und startet den Timer.
;
;	millisec = timerstop(handle)
;	d0		      d0
;
;		liest den Timer und liefert
;		die Anzahl der Tausendstel Sekunden.
;
;--------------------------------------------------------------------
*/

OBJECT mytimer
  val1:EClockVal
  val2:EClockVal
  base
  request:timerequest
ENDOBJECT

PROC timerstart()
  DEF timer:PTR TO mytimer,
      error

  IF timer:=AllocVec(SIZEOF mytimer,MEMF_ANY OR MEMF_CLEAR)
    IF (error:=OpenDevice('timer.device',UNIT_MICROHZ,timer.request,0))=0
      TimerBase:=timer.request.node.Device
      ReadEClock(timer)
      timer.base:=TimerBase
    ELSE
      FreeVec(timer)
    ENDIF
  ENDIF
ENDPROC timer

PROC timerstop(timer:PTR TO mytimer)
  DEF elapsedtime,freq

  IF timer.base
    freq:=ReadEClock(timer+SIZEOF EClockVal)
    elapsedtime:=!((timer.val2.lo-timer.val1.lo)!)*1000.0/(freq!)!
    CloseDevice(timer.request)
    FreeVec(timer)
  ENDIF
ENDPROC elapsedtime

PROC main()
  DEF timer
  
  timer:=timerstart()
  Delay(50)
  IF timer THEN WriteF('micros \d\n',timerstop(timer))
ENDPROC
