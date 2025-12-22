OPT MODULE

MODULE 'exec/lists'

EXPORT PROC newList(mlh:PTR TO mlh)
  mlh.head:=mlh+4    -> Point to tail
  mlh.tail:=NIL
  mlh.tailpred:=mlh  -> Point to head
ENDPROC
