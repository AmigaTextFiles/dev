/* pAmiga_Time.e 05.05.2013
	A simple way of getting the current time.
*/
MODULE 'exec', 'exec/io', 'timer', 'devices/timer'

PRIVATE
DEF tr:timerequest
PUBLIC

PROC new()
	IF OpenDevice('timer.device', UNIT_VBLANK, tr.io, 0) = 0
		timerbase := tr.io.device
	ELSE
		timerbase := NIL
	ENDIF
ENDPROC

PROC end()
	CloseDevice(tr.io)
	timerbase := NIL
ENDPROC

->returns the current time as number of seconds (since 00:00 01-Jan-2000)
PROC currentTimeInSecs() RETURNS bigTime:BIGVALUE
	DEF tv:timeval
	
	IF timerbase = NIL THEN Throw("DEV", 'pAmiga_Time; currentTimeInSecs(); unable to open the timer.device')
	
	GetSysTime(tv)
	bigTime := tv.secs - 694224000
ENDPROC

->returns the current time as number of microseconds (since 00:00 01-Jan-2000)
PROC currentTimeInMicrosecs() RETURNS bigTime:BIGVALUE
	DEF tv:timeval
	
	IF timerbase = NIL THEN Throw("DEV", 'pAmiga_Time; currentTimeInMicrosecs(); unable to open the timer.device')
	
	GetSysTime(tv)
	bigTime := tv.secs - 694224000 !!BIGVALUE * 1000000 + tv.micro
ENDPROC
