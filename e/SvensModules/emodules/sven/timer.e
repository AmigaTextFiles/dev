
OPT MODULE
OPT PREPROCESS

MODULE 'timer','devices/timer',
       'exec/memory', 'exec/io'


/*
** Opens the timer device.
** Returns the NEW timerequest structure
*/
EXPORT PROC openTimerDevice(type=UNIT_VBLANK) HANDLE
DEF timerio=NIL:PTR TO timerequest

  timerio:=NewM(SIZEOF timerequest,MEMF_PUBLIC OR MEMF_CLEAR)
  IF OpenDevice(TIMERNAME,type,timerio,0) THEN Throw("DEV",'timer.device')

EXCEPT

  IF timerio THEN Dispose(timerio)
  ReThrow()

ENDPROC timerio


/*
** Closes an timer device
** Returns NIL.
*/
EXPORT PROC closeTimerDevice(timerio:PTR TO timerequest)

  IF timerio
    CloseDevice(timerio)
    Dispose(timerio)
  ENDIF
ENDPROC NIL

/*
** Gets the timerbase OF an timer device
*/
EXPORT PROC getTimerBase(timerio:PTR TO timerequest) IS
  IF timerio THEN timerio.io.device ELSE NIL


/*
** Sets the  timerbase TO an timer device
** Returns the old timerbase
*/
EXPORT PROC setTimerBase(timerio:PTR TO timerequest)
DEF oldbase

  oldbase:=timerbase
  timerbase:=getTimerBase(timerio)

ENDPROC oldbase

