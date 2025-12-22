
REM Generating a circle for Python 1.4x.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand... :)
REM
REM Syntax:-
REM
REM Circle <x> <y> <radius> <colour> <start> <finish> <aspect><RETURN/ENTER>
REM Where:-
REM 'x' is a value from 0 to 1280.
REM 'y' is a value from 0 to 1024.
REM 'radius' is a value from 1 to 1280.
REM 'colour' is a value from 0 to 7, (31).
REM 'start' is a value from 0 to 359.
REM 'finish' is a value from 0 to 359.
REM 'aspect' is a value from 0.1 to 10.
REM
REM $VER: Circle.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Set up necessary variables and allocate values.
  LET x$="160"
  LET y$="100"
  LET radius$="20"
  LET colour$="1"
  LET start$="0"
  LET finish$="359"
  LET aspect$="0.44"
  LET x=160
  LET y=100
  LET radius=20
  LET colour=1
  LET start=0
  LET finish=359
  LET aspect=0.44
  LET n=0

REM Now obtain the values from the 'command' line.
  LET x$=ARG$(1)
  LET y$=ARG$(2)
  LET radius$=ARG$(3)
  LET colour$=ARG$(4)
  LET start$=ARG$(5)
  LET finish$=ARG$(6)
  LET aspect$=ARG$(7)
  LET n=ARGCOUNT

REM Do NOT allow incorrect number of arguments.
  IF n<=6 THEN GOSUB noerror:
  IF n>=8 THEN GOSUB noerror:

REM Convert arguments and correct if necessary.
  LET x=VAL(x$)
  IF x<=0 THEN LET x=0
  IF x>=1280 THEN LET x=1280
  LET y=VAL(y$)
  IF y<=0 THEN LET y=0
  IF y>=1024 THEN LET y=1024
  LET radius=VAL(radius$)
  IF radius<=1 THEN LET radius=1
  IF radius>=1280 THEN LET radius=1280
  LET colour=VAL(colour$)
  IF colour<=0 THEN LET colour=0
  IF colour>=31 THEN LET colour=31
  LET start=VAL(start$)
  IF start<=0 THEN LET start=0
  IF start>=359 THEN LET start=359
  LET finish=VAL(finish$)
  IF finish<=0 THEN LET finish=0
  IF finish>=359 THEN LET finish=359
  LET aspect=VAL(aspect$)
  IF aspect<=0.1 THEN LET aspect=0.1
  IF aspect>=10 THEN LET aspect=10

REM Now do it...
  CIRCLE (x,y),radius,colour,start,finish,aspect
  END

REM Don't allow any errors at all.
noerror:
  LET x$="160"
  LET y$="100"
  LET radius$="20"
  LET colour$="1"
  LET start$="0"
  LET finish$="359"
  LET aspect$="0.44"
  RETURN
