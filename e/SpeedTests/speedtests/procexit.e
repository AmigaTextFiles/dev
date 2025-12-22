MODULE '*testspeed'

CONST LOTS_OF_TIMES=1000000

DEF x=5,y=5

PROC main()
  test({ifthen},  'IF THEN RETURN', LOTS_OF_TIMES)
  test({ifendif}, 'IF ENDIF',       LOTS_OF_TIMES)
ENDPROC

PROC ifendif()
  IF x
    NOP
    NOP
    IF y
      NOP
      NOP
    ENDIF
  ENDIF
ENDPROC

PROC ifthen()
  IF x=NIL THEN RETURN
  NOP
  NOP
  IF y=NIL THEN RETURN
  NOP
  NOP
ENDPROC

