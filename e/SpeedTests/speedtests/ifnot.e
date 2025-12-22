MODULE '*testspeed'

CONST LOTS_OF_TIMES=1000000

DEF x=5

PROC main()
  test({ifbiggerless}, 'IF <>',     LOTS_OF_TIMES)
  test({ifnot},        'IF Not(=)', LOTS_OF_TIMES)
ENDPROC

PROC ifbiggerless()
  IF x<>5 THEN NOP
ENDPROC

PROC ifnot()
  IF Not(x=5) THEN NOP
ENDPROC

