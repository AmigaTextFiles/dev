MODULE '*testspeed'
MODULE 'exec/memory'

CONST LOTS_OF_TIMES=100,ALLOC_COUNT=1000,ALLOC_SIZE=2048

DEF pool

PROC main()
  DEF mem
  pool:=CreatePool(MEMF_ANY,ALLOC_COUNT*ALLOC_SIZE+1024,4*ALLOC_SIZE)
  mem:=AllocPooled(pool,100)
  test({allocmem},     'AllocMem() and FreeMem()',       LOTS_OF_TIMES)
  test({allocpooled},  'AllocPooled() and FreePooled()', LOTS_OF_TIMES)
  test({allocpooled2}, 'AllocPooled() and DeletePool()', LOTS_OF_TIMES)
  test({fastnew},      'FastNew() and FastDispose()   ', LOTS_OF_TIMES)
  FreePooled(pool,mem,100)
  DeletePool(pool)
ENDPROC

PROC fastnew()
  DEF i,alloctab[ALLOC_COUNT]:ARRAY OF LONG
  FOR i:=0 TO ALLOC_COUNT-1 DO alloctab[i]:=FastNew(ALLOC_SIZE)
  FOR i:=0 TO ALLOC_COUNT-1 DO FastDispose(alloctab[i],ALLOC_SIZE)
ENDPROC

PROC allocmem()
  DEF i,alloctab[ALLOC_COUNT]:ARRAY OF LONG
  FOR i:=0 TO ALLOC_COUNT-1 DO alloctab[i]:=AllocMem(ALLOC_SIZE,MEMF_ANY)
  FOR i:=0 TO ALLOC_COUNT-1 DO FreeMem(alloctab[i],ALLOC_SIZE)
ENDPROC

PROC allocpooled()
  DEF i,alloctab[ALLOC_COUNT]:ARRAY OF LONG
  FOR i:=0 TO ALLOC_COUNT-1 DO alloctab[i]:=AllocPooled(pool,ALLOC_SIZE)
  FOR i:=0 TO ALLOC_COUNT-1 DO FreePooled(pool,alloctab[i],ALLOC_SIZE)
ENDPROC

PROC allocpooled2()
  DEF i,mypool,alloctab[ALLOC_COUNT]:ARRAY OF LONG
  mypool:=CreatePool(MEMF_ANY,ALLOC_COUNT*ALLOC_SIZE+1024,4*ALLOC_SIZE)
  FOR i:=0 TO ALLOC_COUNT-1 DO alloctab[i]:=AllocPooled(mypool,ALLOC_SIZE)
  DeletePool(mypool)
ENDPROC


