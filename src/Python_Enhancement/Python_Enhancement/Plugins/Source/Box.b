
REM Generating a bevel box for Python.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007 B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand.
REM
REM Syntax:-
REM Box <xstart> <xfinish> <ystart> <yfinish> <type><RETURN/ENTER>
REM
REM Where:-
REM 'xstart' is from 0 to 1280, 'ystart' is from 0 to 1024.
REM 'xfinish' is from 0 to 1280, 'yfinish' is from 0 to 1024.
REM 'type' is from 1 to 3.
REM
REM IMPORTANT:-
REM The box drawn will take on the last known foreground and background
REM colours, so be VERY aware of this!!!
REM
REM $VER: Box.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Set up necessary variables.
  LET xstart$="0"
  LET xfinish$="0"
  LET ystart$="0"
  LET yfinish$="0"
  LET type$="1"
  LET xstart=0
  LET xfinish=0
  LET ystart=0
  LET yfinish=0
  LET type=1
  LET n=0

REM Get the arguments from Python.
  LET xstart$=ARG$(1)
  LET ystart$=ARG$(2)
  LET xfinish$=ARG$(3)
  LET yfinish$=ARG$(4)
  LET type$=ARG$(5)
  LET n=ARGCOUNT

REM Do not allow an incorrect number of arguments. This MUST be 5 for
REM ACE Basic compiler.
  IF n<=4 THEN GOSUB settodefault:
  IF n>=6 THEN GOSUB settodefault:

REM Set finite lengths to the x and y values from the Python arguments.
  LET xstart=VAL(xstart$)
  IF xstart<=0 THEN LET xstart=0
  IF xstart>=1280 THEN LET xstart=1280
  LET ystart=VAL(ystart$)
  IF ystart<=0 THEN LET ystart=0
  IF ystart>=1024 THEN LET ystart=1024
  LET xfinish=VAL(xfinish$)
  IF xfinish<=0 THEN LET xfinish=0
  IF xfinish>=1280 THEN LET xfinish=1280
  LET yfinish=VAL(yfinish$)
  IF yfinish<=0 THEN LET yfinish=0
  IF yfinish>=1024 THEN LET yfinish=1024
  LET type=VAL(type$)
  IF type<=1 THEN LET type=1
  IF type>=3 THEN LET type=3

REM Draw the line.
  BEVELBOX (xstart,ystart)-(xfinish,yfinish),type
  END

REM Set all values to zero.
settodefault:
  LET xstart$="0"
  LET xfinish$="0"
  LET ystart$="0"
  LET yfinish$="0"
  LET type$="1"
  RETURN
