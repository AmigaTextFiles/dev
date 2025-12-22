
REM Generating an information box for Python Version 1.4x.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM
REM Syntax:-
REM Msg <message$> <button1$><RETURN/ENTER>
REM There is NO return code for this requester.
REM
REM $VER: Msg.b_Version_0.00.04_(C)2007_B.Walker_G0LCU.

REM Set up all variables.
  GOSUB noerror:

REM Now get these variables from the arguments.
  LET message$=ARG$(1)
  LET button1$=ARG$(2)
  LET n=ARGCOUNT

REM Do NOT allow an error!
  IF n<=1 THEN GOSUB noerror:
  IF n>=3 THEN GOSUB noerror:

REM Now draw the requester, only one button is allowed.
REM No return code is generated as it is an information box only!.
  MSGBOX message$,button1$
  END

REM DO NOT allow an error!
noerror:
  LET message$="(C)2007, B.Walker, G0LCU."
  LET button1$="OK."
  LET n=0
  RETURN
