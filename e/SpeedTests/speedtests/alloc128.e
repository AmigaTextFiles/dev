MODULE '*testspeed'
MODULE 'exec/memory'

CONST LOTS_OF_TIMES=100000

DEF x,pool

PROC main()
  DEF mem
  pool:=CreatePool(MEMF_PUBLIC OR MEMF_CLEAR,4096,2048)
  mem:=AllocPooled(pool,100)
  test({allocmem},     'AllocMem()',     LOTS_OF_TIMES)
  test({allocpooled},  'AllocPooled()',  LOTS_OF_TIMES)
  test({fastnew},      'FastNew()',      LOTS_OF_TIMES)
  FreePooled(pool,mem,100)
  DeletePool(pool)
ENDPROC

PROC fastnew()
  x:=FastNew(128)
  FastDispose(x,128)
ENDPROC

PROC allocmem()
  x:=AllocMem(128,MEMF_PUBLIC)
  FreeMem(x,128)
ENDPROC

PROC allocpooled()
  x:=AllocPooled(pool,128)
  FreePooled(pool,x,128)
ENDPROC

