OPT LARGE

MODULE '*testspeed'

CONST LOTS_OF_TIMES=2000000

DEF x

PROC main()
  test({addone},   'x:=x+1',      LOTS_OF_TIMES) ; x:=0
  test({addql},    'ADDQ.L #1,x', LOTS_OF_TIMES) ; x:=0
  test({addqb},    'ADDQ.B #1,x', LOTS_OF_TIMES) ; x:=0
  test({increase}, 'INC x',       LOTS_OF_TIMES) ; x:=0
ENDPROC

PROC addone()
  x:=x+1
ENDPROC

PROC increase()
  INC x
ENDPROC

PROC addql()
  ADDQ.L #1,x
ENDPROC

PROC addqb()
  ADDQ.B #1,x
ENDPROC

