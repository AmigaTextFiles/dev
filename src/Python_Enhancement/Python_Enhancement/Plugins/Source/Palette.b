
REM Changing the palette register using Python.
REM Compiled using ACE Basic, (C)Bavid Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understsnd.
REM
REM USE THIS COMMAND WITH EXTREME CARE!!!
REM
REM Syntax:-
REM Palette <register> <red> <green> <blue><RETURN/ENTER>
REM
REM Where:-
REM 'register' is a value from 0 to 7, (31).
REM 'red' is a floating point value from 0.00 to 1.00.
REM 'green' is a floating point value from 0.00 to 1.00.
REM 'blue' is a floating point value from 0.00 to 1.00.
REM
REM $VER: Palette.b_Version_0.00.03_(C)2007_B.Walker_G0LCU.

REM Set up all variables.
  LET register$="4"
  LET red$="0"
  LET green$="0"
  LET blue$="0"
  LET register=4
  LET red=0
  LET green=0
  LET blue=0
  LET n=0

REM Get arguments from the 'command' line.
  LET register$=ARG$(1)
  LET red$=ARG$(2)
  LET green$=ARG$(3)
  LET blue$=ARG$(4)
  LET n=ARGCOUNT

REM Do NOT allow incorrect number of arguments error.
  IF n<=3 THEN GOSUB noerror:
  IF n>=5 THEN GOSUB noerror:

REM Now obtain the values of the agruments.
  LET register=VAL(register$)
  IF register<=0 THEN LET register=0
  IF register>=31 THEN LET register=31
  LET red=VAL(red$)
  IF red<=0 THEN LET red=0
  IF red>=1 THEN LET red=1
  LET green=VAL(green$)
  IF green<=0 THEN LET green=0
  IF green>=1 THEN LET green=1
  LET blue=VAL(blue$)
  IF blue<=0 THEN LET blue=0
  IF blue>=1 THEN LET blue=1

REM Now change the palette colour(s).
  PALETTE register,red,green,blue
  END

REM Do NOT allow an error.
noerror:
  LET register$="4"
  LET red$="0"
  LET green$="0"
  LET blue$="0"
  RETURN
