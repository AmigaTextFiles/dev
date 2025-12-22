MODULE '*testspeed'

CONST LOTS_OF_TIMES=4000000

DEF x=0

PROC main()
  test({ifbiggerless}, 'IF x<>0',     LOTS_OF_TIMES)
  test({ifnot},        'IF Not(x=0)', LOTS_OF_TIMES)
  test({ifempty},      'IF x',        LOTS_OF_TIMES)
ENDPROC

PROC ifbiggerless()
  IF x<>0 THEN NOP
ENDPROC

PROC ifnot()
  IF Not(x=0) THEN NOP
ENDPROC

PROC ifempty()
  IF x THEN NOP
ENDPROC


