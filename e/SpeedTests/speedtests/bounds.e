OPT LARGE

MODULE '*testspeed'

CONST LOTS_OF_TIMES=1000000

DEF x,min=5,max=100

PROC main()
  test({limitbounds1}, 'Limit using Bounds()', LOTS_OF_TIMES)
  test({limitbounds2}, 'Limit using Bounds() and short PROC', LOTS_OF_TIMES)
  test({limitif1},     'Limit using IF THEN',  LOTS_OF_TIMES)
  test({limitif2},     'Limit using IF THEN and short PROC',  LOTS_OF_TIMES)
ENDPROC

PROC limitif1()
  IF x<min THEN x:=min
  IF x>max THEN x:=max
ENDPROC x

PROC limitif2() IS x:=IF x<min THEN min ELSE IF x>max THEN max ELSE x

PROC limitbounds1()
  x:=Bounds(x,min,max)
ENDPROC

PROC limitbounds2() IS x:=Bounds(x,min,max)

