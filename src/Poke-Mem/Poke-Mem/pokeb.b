
REM CAUTION!!! ...YOU USE THIS SOFTWARE AT YOUR OWN RISK!!!...
REM Poking AMIGA memory using an A1200(HD) and Python Version 1.4.
REM Compiled using ACE Basic Compiler, (C)David Benn.
REM Original copyright for the idea, (C)20007, B.Walker, G0LCU.
REM This is very controversial BUT it works!!! :)
REM Written in what I call 'baby BASIC' for youngsters to
REM understand and expand on. :)

REM Deliberately limited to the A1200(HD) 16MB boundary.
REM WARNING!!!, all errors are corrected and changed to VALID
REM addresses and byte values. Addresses 0 to 3 are ENFORCER hits
REM so treat them as such!!!. Addresses 16252928 to 16777215
REM inclusive is the 1/2MB ROM area so don't bother poking around
REM that area.
REM $VER: pokeb.b_Version_0.10.00_(C)01-01-2007_B.Walker_G0LCU.

REM Set up all variables required.
  LET pokeaddress$="(C)G0LCU."
  LET pokevalue$="B.Walker."
  LET pokeaddress&=0
  LET pokevalue&=0
  LET n=0

REM Now obtain the required arguments from the 'command' line.
  LET pokeaddress$=ARG$(1)
  LET pokevalue$=ARG$(2)
  LET n=ARGCOUNT

REM Don't allow incorrect number of arguments, MUST be 2 for
REM ACE Basic Compiler, don't confuse with the ~ANSI C~ equivalent.
  IF n<=1 THEN GOSUB noerror:
  IF n>=3 THEN GOSUB noerror:

REM Don't allow any errors for 'pokeaddress$'. Force address 0
REM in the event of an error!!!.
  IF pokeaddress$="" THEN GOSUB noerror:
  IF pokeaddress$=CHR$(13) THEN GOSUB noerror:
  IF pokeaddress$=CHR$(10) THEN GOSUB noerror:
  IF pokeaddress$=(CHR$(10)+CHR$(13)) THEN GOSUB noerror:
  IF pokeaddress$=(CHR$(13)+CHR$(10)) THEN GOSUB noerror:
  IF LEN(pokeaddress$)<=0 THEN GOSUB noerror:
  IF LEN(pokeaddress$)>=9 THEN GOSUB noerror:

REM Don't allow any errors for 'pokevalue$'. Force a byte value
REM of 0 in the event of an error!!!.
  IF pokevalue$="" THEN GOSUB noerror:
  IF pokevalue$=CHR$(13) THEN GOSUB noerror:
  IF pokevalue$=CHR$(10) THEN GOSUB noerror:
  IF pokevalue$=(CHR$(10)+CHR$(13)) THEN GOSUB noerror:
  IF pokevalue$=(CHR$(13)+CHR$(13)) THEN GOSUB noerror:
  IF LEN(pokevalue$)<=0 THEN GOSUB noerror:
  IF LEN(pokevalue$)>=4 THEN GOSUB noerror:

REM Convert ASCII string to decimal numbers.
  LET pokeaddress&=VAL(pokeaddress$)
  LET pokevalue&=VAL(pokevalue$)

REM Ensure 'pokeaddress&' is in between 0 and 16777215.
  IF pokeaddress&<=0 THEN LET pokeaddress&=0
  IF pokeaddress&>=16777215 THEN LET pokeaddress&=16777215

REM Ensure 'pokevalue&' is in between 0 and 255.
  IF pokevalue&<=0 THEN LET pokevalue&=0
  IF pokevalue&>=255 THEN LET pokevalue&=255

REM Now place 'pokevalue&' into the memory location 'pokeaddress&'
REM and exit the program without a return code.
  POKE pokeaddress&,pokevalue&
  END

REM Do not allow an error, set address to ROM area and value of 0.
noerror:
  LET pokeaddress$="16777214"
  LET pokevalue$="0"
  RETURN 
