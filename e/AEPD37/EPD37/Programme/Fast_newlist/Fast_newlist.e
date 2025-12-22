/* Hab ich aus der E-Mailing-Liste. Daniel */

-> As I see many sources on lists, I thought I should share this very fast
-> newList() implementation.

OPT MODULE

MODULE 'exec/lists'

-> very fast newList, from the C= v40 exec/lists.i assembly macros.
-> note that an earlier C= macro took 68 cycles, the v40 one only 58 :-)

-> FOLD newList
EXPORT PROC newList(mlh:PTR TO mlh)

  -> load header pointer into A0
  MOVEA.L mlh,A0

  -> set mlh.tailpred to mlh.head
  MOVE.L A0,8(A0) -> 16 cycles

  -> get address of mlh.tail
  ADDQ.L #4,A0 -> 8 cycles

  -> clear mlh.tail
  CLR.L (A0) -> 20 cycles

  -> address of mlh.tail to mlh.head
  MOVE.L A0,-(A0) -> 14 cycles

ENDPROC -> 58 cycles
-> FEND

/*

Bye,
--
Leon `LikeWise' Woestenberg <leon@stack.urc.tue.nl> <leon@esrac.ele.tue.nl>
Information Technology Science student, Eindhoven University of Technology.

Amiga - The most personal computer

*/

