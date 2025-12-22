OPT MORPHOS, MODULE, EXPORT

-> aboxlib/lists.e

PROC newList(list) -> list:R3
   ADDI R4, R3, 4
   STW R4, 0(R3) -> head
   ADDI R4, R0, 0
   STW R4, 4(R3) -> tail
   STW R3, 8(R3) -> tailpred
ENDPROC R3








