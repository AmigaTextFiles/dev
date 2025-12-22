OPT OSVERSION=34
OPT PREPROCESS

MODULE 'tools/mempools','exec/memory'
#define PROGRAMVERSION 'memPOOLStest v1.1 (20.04.96)'

CONST PUDDLESIZE = 10240
CONST TRESHSIZE  = PUDDLESIZE

PROC main() HANDLE
  DEF pool:PTR TO pool,mem

  IF (pool:=libCreatePool(MEMF_ANY,PUDDLESIZE,TRESHSIZE))=NIL THEN RETURN
  mem:=libAllocVecPooled(pool,100)
  WriteF(IF mem THEN 'ALLOCATED!\n' ELSE 'ERROR!\n')

->  if you have OS39 then run PoolWatch,Sushi and try this
->  mem[-10]:=$11; mem[-12]:=$11
->  mem[110]:=$11; mem[112]:=$11
->  mem[-4]:=0
EXCEPT DO
  libFreeVecPooled(pool,mem)
  libDeletePool(pool)
  WriteF('DISPOSED!\n')
ENDPROC

CHAR '$VER: ',PROGRAMVERSION,0
