
REM Changing the foreground and background colours using Python.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand.
REM
REM Syntax is:-
REM Color <foreground> <background><RETURN/ENTER>
REM
REM Where:-
REM 'foreground' is a value from 1 to 7, (31).
REM 'background' is a value from 1 to 7, (31).
REM
REM $VER: Color.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Set up variables.
  LET foreground$="1"
  LET background$="0"
  LET foreground=1
  LET background=0
  LET n=0

REM Now get arguments from Python.
  LET foreground$=ARG$(1)
  LET background$=ARG$(2)
  LET n=ARGCOUNT

REM Do NOT allow wrong number of arguments, 2 ARE needed.
  IF n<=1 THEN GOSUB settodefault:
  IF n>=3 THEN GOSUB settodefault:

REM Do not allow any error, IF there is an error set to default.
  LET foreground=VAL(foreground$)
  IF foreground<=0 THEN LET foreground=0
  IF foreground>=31 THEN LET foreground=31
  LET background=VAL(background$)
  IF background<=0 THEN LET background=0
  IF background>=31 THEN LET background=31

REM Do the command.
  COLOR foreground,background
  END

REM Correct any errors here.
settodefault:
  LET foreground$="1"
  LET background$="0"
  RETURN
