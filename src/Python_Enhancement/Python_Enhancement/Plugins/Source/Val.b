
REM Converting ANY string to a number using the VAL <somestring$> command.
REM Original idea copyright, (C)2007, B.Walker, G0LCU.
REM Compiled using ACE Basic compiler, (C)David Benn.
REM
REM Written so that youngsters can understand it.
REM
REM Val <somestring$><RETURN/ENTER>
REM 'somestring$' can be anything at all including a NULL.
REM
REM Limited to 'signed long integers' from -2147483648 to +2147483647.
REM
REM $VER: Val.b_Version_0.00.08_(C)2007_B.Walker_G0LCU.

REM Allocate definate values to variables.
  LET valstring$="0"
  LET n=0
  LET valstring=0

REM Now obtain the correct values and DO NOT allow any errors.
REM Set all errors to NUMBER 0.
  LET valstring$=ARG$(1)
  LET n=ARGCOUNT
  IF n<=0 THEN LET valstring$="0"
  IF n>=2 THEN LET valstring$="0"
  IF valstring$="" THEN LET valstring$="0"

REM Obtain some number from the random string.
  LET valstring&=VAL(valstring$)
REM Remove any floating point values.
  LET valstring&=INT(valstring&)
REM These two lines are NOT needed as ACE Basic allows for it anyhow!
REM They are kept in for good measure however!
  IF valstring&>=2147483647 THEN LET valstring&=2147483647
  IF valstring&<=-2147483648 THEN LET valstring&=-2147483648

REM Place the value into the RC.
  SYSTEM valstring&
REM End of command.
