
REM Generating a line for use with Python.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM This ONLY works with a genuine AMIGADOS Shell!!!
REM The idea is copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand!!!
REM
REM Syntax:-
REM DrawLine <xstart> <ystart> <xfinish> <yfinish> <colour><RETURN/ENTER>
REM
REM Where:-
REM 'xstart' is from 0 to 1280, 'ystart' is from 0 to 1024.
REM 'xfinish' is from 0 to 1280, 'yfinish' is from 0 to 1024.
REM 'colour' is from 0 to 7, (31).
REM
REM $VER: DrawLine.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Set up necessary variables.
  LET xstart$="0"
  LET xfinish$="0"
  LET ystart$="0"
  LET yfinish$="0"
  LET colour$="0"
  LET xstart=0
  LET xfinish=0
  LET ystart=0
  LET yfinish=0
  LET colour=0
  LET n=0

REM Get the arguments from Python.
  LET xstart$=ARG$(1)
  LET ystart$=ARG$(2)
  LET xfinish$=ARG$(3)
  LET yfinish$=ARG$(4)
  LET colour$=ARG$(5)
  LET n=ARGCOUNT

REM Do not allow an incorrect number of arguments. This MUST be 5 for
REM ACE Basic compiler.
  IF n<=4 THEN GOSUB setalltozero:
  IF n>=6 THEN GOSUB setalltozero:

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
  LET colour=VAL(colour$)
  IF colour<=0 THEN LET colour=0
  IF colour>=31 THEN LET colour=31

REM Draw the line.
  LINE (xstart,ystart)-(xfinish,yfinish),colour
  END

REM Set all values to zero.
setalltozero:
  LET xstart$="0"
  LET xfinish$="0"
  LET ystart$="0"
  LET yfinish$="0"
  LET colour$="0"
  RETURN
