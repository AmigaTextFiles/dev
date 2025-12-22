MODULE '*testspeed'

CONST LOTS_OF_TIMES=1000000

DEF x=5

PROC main()
  test({ifendif}, 'IF ENDIF', LOTS_OF_TIMES)
  test({ifthen},  'IF THEN',  LOTS_OF_TIMES)
ENDPROC

PROC ifendif()
  IF x=0
    NOP
  ENDIF
ENDPROC

PROC ifthen()
  IF x=0 THEN NOP
ENDPROC

