
REM Relocating the cursor to print to the screen using Python.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand.
REM
REM Syntax is:-
REM Locate <cursorline> <cursorcolumn><RETURN/ENTER>
REM
REM Where:-
REM 'cursorline' is a value from 1 to 60.
REM 'cursorcolumn' is a value from 1 to 160.
REM
REM $VER: Locate.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Set up variables.
  LET cursorline$="1"
  LET cursorcolumn$="1"
  LET cursorline=1
  LET cursorcolumn=1
  LET n=0

REM Now get arguments from Python.
  LET cursorline$=ARG$(1)
  LET cursorcolumn$=ARG$(2)
  LET n=ARGCOUNT

REM Do NOT allow wrong number of arguments, 2 ARE needed.
  IF n<=1 THEN GOSUB setalltoone:
  IF n>=3 THEN GOSUB setalltoone:

REM Do not allow any error, IF there is an error set either or both to 1.
  LET cursorline=VAL(cursorline$)
  IF cursorline<=1 THEN LET cursorline=1
  IF cursorline>=60 THEN LET cursorline=60
  LET cursorcolumn=VAL(cursorcolumn$)
  IF cursorcolumn<=1 THEN LET cursorcolumn=1
  IF cursorcolumn>=160 THEN LET cursorcolumn=160

REM Do the command.
  LOCATE cursorline,cursorcolumn
  END

REM Correct any errors here.
setalltoone:
  LET cursorline$="1"
  LET cursorcolumn$="1"
  RETURN
