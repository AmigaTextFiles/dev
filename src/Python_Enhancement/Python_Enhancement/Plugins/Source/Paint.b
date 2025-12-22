
REM Colouring in an enclosed 'box' in a Python Shell window.
REM Compiled using ACE Basic Compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand.
REM
REM Syntax:-
REM Paint <x> <y> <colour1> <colour2><RETURN/ENTER>
REM
REM Where:-
REM 'x' is a value from 0 to 1280.
REM 'y' is a value from 0 to 1024.
REM 'colour1' is a value from 0 to 7, (31).
REM 'colour2' is a value from 0 to 7, (31).
REM
REM $VER: Paint.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Set up the necessary variables.
  LET x$="0"
  LET y$="0"
  LET colour1$="0"
  LET colour2$="1"
  LET x=0
  LET y=0
  LET colour1=0
  LET colour2=1
  LET n=0

REM Now get the values from the command line.
  LET x$=ARG$(1)
  LET y$=ARG$(2)
  LET colour1$=ARG$(3)
  LET colour2$=ARG$(4)
  LET n=ARGCOUNT

REM Check for the correct number of arguments, do NOT allow an error.
  IF n<=3 THEN GOSUB setdefaults:
  IF n>=5 THEN GOSUB setdefaults:

REM Limit the positions to the values shown.
  LET x=VAL(x$)
  IF x<=0 THEN LET x=0
  IF x>=1280 THEN LET x=1280
  LET y=VAL(y$)
  IF y<=0 THEN LET y=0
  IF y>=1024 THEN LET y=1024
  LET colour1=VAL(colour1$)
  IF colour1<=0 THEN LET colour1=0
  IF colour1>=31 THEN LET colour1=31
  LET colour2=VAL(colour2$)
  IF colour2<=0 THEN LET colour2=0
  IF colour2>=31 THEN LET colour2=31

REM Now 'PAINT' to the screen location given.
  PAINT (x,y),colour1,colour2
  END

REM Do NOT allow an error and set to the centre of an NTSC Lores screen.
setdefaults:
  LET x$="160"
  LET y$="100"
  LET colour1$="0"
  LET colour2$="1"
  RETURN
