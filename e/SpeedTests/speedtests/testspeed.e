OPT LARGE
OPT MODULE

MODULE 'dos/dos','exec/memory'

CONST TICKS_PER_MINUTE=TICKS_PER_SECOND*60

DEF offset

EXPORT PROC test(proc,message,loops)
  DEF t
  IF offset=0 THEN offset:=time({emptyproc},loops)  /* Calculate offset */
  t:=time(proc,loops)
  WriteF('\l\s[40]: \r\d[3] ticks\n',message,t-offset)
ENDPROC

/* Time the repeated calls, and calculate number of ticks */
PROC time(proc,loops)
  DEF ds1:datestamp,ds2:datestamp,i
  Forbid()
  DateStamp(ds1)
  FOR i:=0 TO loops DO proc()
  DateStamp(ds2)
  Permit()
  IF CtrlC() THEN CleanUp(1)
ENDPROC ((ds2.minute-ds1.minute)*TICKS_PER_MINUTE)+ds2.tick-ds1.tick

emptyproc:
  RTS
