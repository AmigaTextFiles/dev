MODULE '*testspeed'

CONST LOTS_OF_TIMES=100000

DEF x

PROC main()
  test({forendfor}, 'FOR & ENDFOR', LOTS_OF_TIMES)
  test({fordo},     'FOR & DO',     LOTS_OF_TIMES)
ENDPROC

PROC forendfor()
  FOR x:=0 TO 100
    Mul(13,4652)
  ENDFOR
ENDPROC

PROC fordo()
  FOR x:=0 TO 10 DO Mul(13,4652)
ENDPROC

