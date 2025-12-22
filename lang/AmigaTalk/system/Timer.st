"----------------------------------------------------------------------"
" TimerDevice Class is derived from abstract Device Class.             "
""
"  WARNING:  You should know what you're doing to the Amiga OS before  "
"            messing with this Class, or any other System Class!       "
" ---------------------------------------------------------------------"

Class TimerDevice :Device ! private timerType !
[
   stop

      <primitive 228 2 private> "Kill Timer (you still have to close it)."
|
   startWithSecs: s withMicros: m

      <primitive 228 3 private s m>
|
   delaySeconds: s micros: m

      <primitive 228 4 private s m>
|
   test

      ^ <primitive 228 5 private>
|
   getTimerType

      ^ timerType
|
   getSeconds

      ^ <primitive 228 6 private>
|
   getMicros

      ^ <primitive 228 7 private> 
|
   setSeconds: s micros: m

      ^ <primitive 228 8 private s m>
|
   compare: s micros: m toSeconds: s2 micros: m2

      " if      t1 >  t2, return -1
      * else if t1 <  t2, return +1
      * else if t1 == t2, return 0
      "

      ^ <primitive 228 9 s m s2 m2>
|
   getEClockHigh

      ^ <primitive 228 10 private>
|
   getEClockLow

      ^ <primitive 228 11 private>
|
   openTimer: timerName type: newTimerType seconds: secs  micros: micros

      private   <- <primitive 228 1 newTimerType secs micros timerName>. "Setup Timer"

      timerType <- newTimerType.

      ^ self
|
   close

      <primitive 228 0 private>.   "Close the Timer"

      <primitive 250 5 0 private>. "Once closed, it's dead!"
      
      ^ nil             
] 
