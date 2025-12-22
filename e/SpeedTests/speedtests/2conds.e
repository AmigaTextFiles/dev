MODULE '*testspeed'

CONST LOTS_OF_TIMES=2000000

DEF x=5,y=5

PROC main()
  test({ifx2},  '2  x IF', LOTS_OF_TIMES)
  test({ifand}, 'IF AND',  LOTS_OF_TIMES)
ENDPROC

PROC ifx2()
  IF x=5
    IF y=5
    ENDIF
  ENDIF
ENDPROC

PROC ifand()
  IF (x=5) AND (y=5)
  ENDIF
ENDPROC

