-> $VER: ansi.m 1.0 (25.9.97) © Frédéric Rodrigues
-> ansi functions

OPT MODULE
OPT EXPORT

PROC noansi(str)
-> removes ansi codes from a string
DEF s,t
  t:=str
  WHILE t[]
    IF t[]="\e"
      s:=t
      WHILE ((s[]<"a") OR (s[]>"z")) AND ((s[]<"A") OR (s[]++>"Z")) DO NOP
      AstrCopy(t,s,ALL)
    ELSE
      INC t
    ENDIF
  ENDWHILE
ENDPROC
