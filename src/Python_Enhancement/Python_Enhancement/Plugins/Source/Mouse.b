
REM !!!THIS IDEA IS TOTALLY EXPERIMENTAL. YOU USE IT AT YOUR OWN RISK!!!
REM --------------------------------------------------------------------

REM This is an experimental means of obtaining the horizontal, vertical
REM and left mouse button state and returning an encoded result into the
REM RC, (RETURN CODE), of the executable.
REM Bits 0 to 11 are the vertical position, from 0 to 4095.
REM Bits 12 to 23 are the horizontal position from 0 to 4095.
REM Bit 24 is either 0, no left mouse button or 1 LMB pressed.
REM Refer to the Python code on how to decode these states.

REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written so that kids can understand it... :)
REM
REM $VER: Mouse.b_Version.0.00.02_(C)2007_B.Walker_G0LCU.

REM Setup the variables and DO NOT aloow any errors.
  LET lmb&=MOUSE(0)
  LET lmb&=ABS(lmb&)
  IF lmb&<=0 THEN LET lmb&=0
  IF lmb&>=1 THEN LET lmb&=1
  LET x&=MOUSE(1)
  IF x&<=0 THEN LET x&=0
  IF x&>=4095 THEN LET x&=4095
  LET y&=MOUSE(2)
  IF y&<=0 THEN LET y&=0
  IF y&>=4095 THEN LET y&=4095

REM Encode here.
  LET rc&=((16777216*lmb&)+(4096*x&)+y&)

REM Now save in the RC, (RETURN CODE), and exit.
  SYSTEM rc&
  END
