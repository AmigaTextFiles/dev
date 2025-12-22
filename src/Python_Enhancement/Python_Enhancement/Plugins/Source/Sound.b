
REM Generation of a VERY crude sine wave for a fixed duration.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand.
REM
REM Syntax:-
REM Sound <period> <length> <volume> <channel><RETURN/ENTER>
REM 'period' is a value from 128 to 4999.
REM 'length' is a value from 1 to 999
REM 'volume' is a value from 0 to 64.
REM 'channel' is a value from 0 to 3.
REM Channel '0' for left A, '1' for right A,'2' for right B and '3' for left B.
REM
REM $VER: Sound.b_Version_0.00.04_(C)2007_B.Walker_G0LCU.

REM Set up the required variables.
  LET period$="445"
  LET length$="5"
  LET volume$="64"
  LET channel$="0"
  LET period=445
  LET length=5
  LET volume=64
  LET channel=0
  LET n=0

REM Now obtain the real variables.
  LET period$=ARG$(1)
  LET length$=ARG$(2)
  LET volume$=ARG$(3)
  LET channel$=ARG$(4)
  LET n=ARGCOUNT

REM Set to default values if ARGCOUNT is wrong!.
  IF n<=3 THEN GOSUB noerror:
  IF n>=5 THEN GOSUB noerror:

REM Correct for out of range values.
  LET period=VAL(period$)
  IF period<=127 THEN LET period=445
  IF period>=5000 THEN LET period=445
  LET length=VAL(length$)
  IF length<=1 THEN LET length=5
  IF length>=1000 THEN LET length=5
  LET volume=VAL(volume$)
  IF volume<=0 THEN LET volume=0
  IF volume>=64 THEN LET volume=64
  LET channel=VAL(channel$)
  IF channel<=0 THEN LET channel=0
  IF channel>=3 THEN LET channel=3

REM Now generate that tone.
  SOUND period,length,volume,channel
  END

REM Do not allow any errors, set to a default.
REM Set to about 1KHz.
noerror:
  LET period$="445"
  LET length$="5"
  LET volume$="64"
  LET channel$="0"
  RETURN
