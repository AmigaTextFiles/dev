OPT OSVERSION=34
OPT PREPROCESS

MODULE 'amigalib/mempools','exec/memory'
#define PROGRAMVERSION 'memPOOLS v1.1 (17.10.97)'

PROC main() HANDLE
  DEF pool,mem

  IF (pool:=libCreatePool(MEMF_ANY,10000,10000))=NIL THEN RETURN
  mem:=libAllocPooled(pool,100)
  WriteF(IF mem THEN 'ALLOCATED!\n' ELSE 'ERROR!\n')

  ->-  if you have OS39+ then run PoolWatch,Sushi and try this
  ->-  mem[-10]:=$11; mem[-12]:=$11
  ->-  mem[110]:=$11; mem[112]:=$11
  ->-  mem[-4]:=0
EXCEPT DO
  libFreePooled(pool,mem,100)
  libDeletePool(pool)
  WriteF('DISPOSED!\n')
ENDPROC

CHAR '$VER: ',PROGRAMVERSION,0
