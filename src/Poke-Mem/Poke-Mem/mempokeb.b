  LET pokeaddress$="(C)G0LCU."
  LET pokevalue$="B.Walker."
  LET pokeaddress&=0
  LET pokevalue&=0
  LET n=0
  LET pokeaddress$=ARG$(1)
  LET pokevalue$=ARG$(2)
  LET n=ARGCOUNT
  IF n<=1 THEN GOSUB noerror:
  IF n>=3 THEN GOSUB noerror:
  IF pokeaddress$="" THEN GOSUB noerror:
  IF pokeaddress$=CHR$(13) THEN GOSUB noerror:
  IF pokeaddress$=CHR$(10) THEN GOSUB noerror:
  IF pokeaddress$=(CHR$(10)+CHR$(13)) THEN GOSUB noerror:
  IF pokeaddress$=(CHR$(13)+CHR$(10)) THEN GOSUB noerror:
  IF LEN(pokeaddress$)<=0 THEN GOSUB noerror:
  IF LEN(pokeaddress$)>=9 THEN GOSUB noerror:
  IF pokevalue$="" THEN GOSUB noerror:
  IF pokevalue$=CHR$(13) THEN GOSUB noerror:
  IF pokevalue$=CHR$(10) THEN GOSUB noerror:
  IF pokevalue$=(CHR$(10)+CHR$(13)) THEN GOSUB noerror:
  IF pokevalue$=(CHR$(13)+CHR$(13)) THEN GOSUB noerror:
  IF LEN(pokevalue$)<=0 THEN GOSUB noerror:
  IF LEN(pokevalue$)>=4 THEN GOSUB noerror:
  LET pokeaddress&=VAL(pokeaddress$)
  LET pokevalue&=VAL(pokevalue$)
  IF pokeaddress&<=0 THEN LET pokeaddress&=0
  IF pokeaddress&>=16777215 THEN LET pokeaddress&=16777215
  IF pokevalue&<=0 THEN LET pokevalue&=0
  IF pokevalue&>=255 THEN LET pokevalue&=255
  POKE pokeaddress&,pokevalue&
  END
noerror:
  LET pokeaddress$="16777214"
  LET pokevalue$="0"
  RETURN 
