
REM Compiled using ACE Basic compiler, (C)David Benn.
REM CheckChipMem, (C)2007, B.Walker, G0LCU.
REM Written in 'baby BASIC' for kids to understand.
REM
REM $VER: CheckChipMem.b_Version_0.00.02_(C)2007_B.Walker_G0LCU.

REM Allocate some memory for Python and clear all the addresses to 0.
REM CheckChipMem allocates 65536 bytes of cleared ChipMem with NO parameters.

REM Set up all variables.
  LET amount$="65536"
  LET type$="C"
  LET amount=65536
  LET type=3
  LET n=0  

REM Now get the values from the command line arguments.
  LET amount$=ARG$(1)
  LET type$=ARG$(2)
  LET n=ARGCOUNT

REM Ensure no error with incorrect number of arguments.
  IF n<=1 THEN GOSUB setmem:
  IF n>=3 THEN GOSUB setmem:

REM Only allow the correct letters pertaining to the memory type.
  IF type$="C" OR type$="c" THEN GOTO correcttype:
  IF type$="F" OR type$="f" THEN GOTO correcttype:
  IF type$="P" OR type$="p" THEN GOTO correcttype:
REM If wrong set to the default, 65536 bytes of cleared ChipMem.
  GOSUB setmem:

REM All OK!.
correcttype:
  IF type$="C" OR type$="c" THEN LET type$="3"
  IF type$="F" OR type$="f" THEN LET type$="4"
  IF type$="P" OR type$="p" THEN LET type$="5"

REM Now convert to values.
  LET type=VAL(type$)
  LET amount=VAL(amount$)
  IF amount<=4 THEN LET amount=4
  IF amount>=65536 THEN LET amount=65536

REM Do it...
  LET addr&=ALLOC(amount,type)

REM Deallocate this 64KB.
  CLEAR ALLOC

REM Place the start address into the RC, (RETURN CODE), ready for Python.
  SYSTEM addr&
REM Not needed but added for safety!!!
  END

REM Ensure 65536 bytes of ChipMem as the default.
setmem:
  LET amount$="65536"
  LET type$="3"
  RETURN
