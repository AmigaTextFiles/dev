MODULE 'oomodules/softtimer_oo'

PROC main() HANDLE
 DEF x, y, st:PTR TO softtimer
 NEW st.softtimer()

 st.startTimer(4,500000) -> 4.5 seconds
 st.waitForTimer()       -> will wait the 4.5 secs

 st.delay(60) -> delay one minute

 FOR x:=0 TO 99
  st.waitAndRestart(0,150000) -> make the loop go in constant speed
                              -> indemendent of the CPU!
  FOR y:=0 TO 10000 -> do someting slow..
  ENDFOR            -> ..like texturemapping ;)
 ENDFOR

 st.startTimer(3)
 REPEAT
  ping() -> just something stupid for 3 seconds
 UNTIL st.getTimerMsg()=TRUE

EXCEPT DO
 SELECT exception
 CASE ERR_DEV
  WriteF('Could not open timer.device!\n')
 CASE ERR_TIMER
  WriteF('Could not create timerrequest!\n')
 CASE ERR_MSGPORT
  WriteF('Could not create mesport!\n')
 CASE ERR_NONE
  END st      ->>> stop timer and delete msg-ports!
 DEFAULT
  WriteF('Out of memory or something!\n')
 ENDSELECT
ENDPROC

PROC ping()
ENDPROC
