
OPT MODULE
OPT PREPROCESS

MODULE 'sven/eVec'


/*
** Creates an big array in memory.
** The memory IS cleared.
*/
EXPORT PROC allocArray(entrysize, count)
DEF mem:PTR TO LONG

  mem:=eAllocVec(Mul(entrysize,count)+4)
  mem[]++:=entrysize

ENDPROC mem

/*
** Disposes an array allocated by allocArray().
** returns NIL.
*/
EXPORT PROC freeArray(mem)
  IF mem THEN eFreeVec(mem-4)
ENDPROC NIL


/*
** Returns the memory position at which the 'pos'
** element resides.
** The 'mem'-pointer must be an pointer returned
** by allocArray!!
*/
EXPORT PROC getArrayElement(mem:PTR TO LONG, pos) IS
  mem+Mul(mem[-1], pos)

