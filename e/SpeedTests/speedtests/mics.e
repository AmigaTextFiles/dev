OPT LARGE
OPT PREPROCESS

MODULE '*testspeed'

CONST LOTS_OF_TIMES=100000

#define mics2(a1,a2,b1,b2) IF b1<b2 THEN Mul((a2-a1),1000000)+(b2-b1) ELSE Mul((a2-a1),1000000)-(b1-b2)

PROC main()
  test({test1}, 'Mics using procedure', LOTS_OF_TIMES)
  test({test2}, 'Mics using define',    LOTS_OF_TIMES)
ENDPROC

PROC test1()
  mics1(3232,231,23,55345)
  mics1(3232,231,23,55345)
  mics1(3232,231,23,55345)
  mics1(3232,231,23,55345)
  mics1(3232,231,23,55345)
ENDPROC

PROC test2()
  mics2(3232,231,23,55345)
  mics2(3232,231,23,55345)
  mics2(3232,231,23,55345)
  mics2(3232,231,23,55345)
  mics2(3232,231,23,55345)
ENDPROC

PROC mics1(a1,a2,b1,b2)
  DEF decc
  IF b1<b2
    decc:=Mul((a2-a1),1000000)+(b2-b1)
  ELSE
    decc:=Mul((a2-a1),1000000)-(b1-b2)
  ENDIF
ENDPROC decc



