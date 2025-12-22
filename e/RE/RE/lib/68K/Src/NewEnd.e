/*
compilatore re:lib/elib_68K/NewEnd.e
*/
OPT NOHEAD,NOEXE
MODULE 'exec'
DEF _repool
PROC ReNewR(size)
  IFN _repool THEN IFN _repool:=CreatePool($10005,$2000,$1000) THEN Raise("MEM")
ENDPROC AllocVecPooled(_repool,size)
PROC ReDispose(mem)
  IF mem THEN FreeVecPooled(_repool,mem)
ENDPROC