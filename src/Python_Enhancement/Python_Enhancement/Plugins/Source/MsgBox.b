
REM Generating a system requester for Python Version 1.4x.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM
REM Syntax:-
REM MsgBox <message$> <button1$> <button2$><RETURN/ENTER>
REM Where the rc, (return code), is 1 for button1$ and 0 for button2$.
REM
REM $VER: MsgBox.b_Version_0.00.04_(C)2007_B.Walker_G0LCU.

REM Set up all variables.
  GOSUB noerror:

REM Now get these variables from the arguments.
  LET message$=ARG$(1)
  LET button1$=ARG$(2)
  LET button2$=ARG$(3)
  LET rc=ARGCOUNT

REM Do NOT allow an error!
  IF rc<=2 THEN GOSUB noerror:
  IF rc>=4 THEN GOSUB noerror:

REM Now set the return code and draw the requester.
  LET rc=MSGBOX(message$,button1$,button2$)
  LET rc=ABS(rc)
REM Return a value.
  SYSTEM rc

REM DO NOT allow an error!
noerror:
  LET message$="(C)2007, B.Walker."
  LET button1$="G0LCU."
  LET button2$="Cancel."
  LET rc=0
  RETURN
