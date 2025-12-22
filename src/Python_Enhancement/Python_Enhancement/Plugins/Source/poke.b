
REM CAUTION!!! ...YOU USE THIS SOFTWARE AT YOUR OWN RISK!!!...
REM Original idea (C)01-01-2007, B.Walker, G0LCU.
REM Poking memory for Python access to AMIGA hardware.
REM Refer to the 'Manual' for ALL WARNINGS!!!
REM
REM $VER: poke.b_Version_0.20.00_(C)06-01-2007_B.Walker_G0LCU.
REM
REM Used from the command line as:-
REM poke <b|B|w|W> <address from 0 to 16777214> <value from 0 to 255|65535><RETURN/ENTER>

REM Set up all variables required.
  LET pokeaddress$="16777214"
  LET pokevalue$="0"
  LET type$="B"
  LET pokeaddress&=0
  LET pokevalue&=0
  LET n=0

REM Now obtain the required arguments from the 'command' line.
  LET type$=ARG$(1)
  LET pokeaddress$=ARG$(2)
  LET pokevalue$=ARG$(3)
  LET n=ARGCOUNT
REM Set type$ to upper case.
  LET type$=UCASE$(type$)

REM This should 'stop' the program IF the wrong number of arguments.
REM This should be 3 in ACE Basic!!!
  IF n<=2 THEN GOSUB settorom:
  IF n>=4 THEN GOSUB settorom:
  IF type$="B" OR type$="W" THEN GOTO typecorrect:
  GOSUB settorom:

REM Don't allow any errors for 'pokeaddress$'. Force address 16777214
REM in the event of an error!!!.
typecorrect:
  IF pokeaddress$="" THEN GOSUB settorom:
  IF pokeaddress$=CHR$(13) THEN GOSUB settorom:
  IF pokeaddress$=CHR$(10) THEN  GOSUB settorom:
  IF pokeaddress$=(CHR$(10)+CHR$(13)) THEN GOSUB settorom:
  IF pokeaddress$=(CHR$(13)+CHR$(10)) THEN GOSUB settorom:
  IF LEN(pokeaddress$)<=0 THEN GOSUB settorom:
  IF LEN(pokeaddress$)>=9 THEN GOSUB settorom:

REM Don't allow any errors for 'pokevalue$'. Force a value value
REM of 0 in the event of an error!!!.
  IF pokevalue$="" THEN GOSUB settorom:
  IF pokevalue$=CHR$(13) THEN GOSUB settorom:
  IF pokevalue$=CHR$(10) THEN GOSUB settorom:
  IF pokevalue$=(CHR$(10)+CHR$(13)) THEN GOSUB settorom:
  IF pokevalue$=(CHR$(13)+CHR$(10)) THEN GOSUB settorom:
  IF LEN(pokevalue$)<=0 THEN GOSUB settorom:
  IF LEN(pokevalue$)>=4 AND type$="B" THEN GOSUB settorom:
  IF LEN(pokevalue$)>=6 AND type$="W" THEN GOSUB settorom:

REM Convert ASCII string to decimal numbers.
  LET pokeaddress&=VAL(pokeaddress$)
  LET pokevalue&=VAL(pokevalue$)

REM Ensure 'pokeaddress' is in between 0 and 16777215.
  IF pokeaddress&<=0 THEN LET pokeaddress&=0
  IF pokeaddress&>=16777215 AND type$="B" THEN LET pokeaddress&=16777215
  IF pokeaddress&>=16777214 AND type$="W" THEN LET pokeaddress&=16777214

REM Ensure 'pokevalue&' is inside the correct limits.
  IF type$="W" AND pokevalue&>=65535 THEN LET pokevalue&=65535
  IF type$="B" AND pokevalue&>=255 THEN LET pokevalue&=255
  IF pokevalue&<=0 THEN LET pokevalue&=0

REM Now place 'pokevalue&' into the memory location 'pokeaddress&'
REM and exit the program without a return code.
  IF type$="B" THEN POKE pokeaddress&,pokevalue&
  IF type$="W" THEN POKEW pokeaddress&,pokevalue&
  END

REM Ensure something correct is poked, although inside ROM, having NO effect.
settorom:
  LET pokeaddress$="16777214"
  LET pokevalue$="0"
  LET type$="B"
  RETURN
