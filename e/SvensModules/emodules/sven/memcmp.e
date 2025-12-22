/* compares 2 memory blocks (max 32767 bytes).
** >0 if first different character within mem1 was greater than the character in mem2
** <0 if first different charcater within mem1 was smaller than the charcater in mem2
** =0 if contents of mem1 is equal to mem2
*/

OPT MODULE

/*EXPORT PROC memcmp(mem1:PTR TO CHAR,mem2:PTR TO CHAR,size)
DEF error=0

  WHILE ((size-->=0) AND (error=0)) DO error:=mem1[]++-mem2[]++

ENDPROC error*/

/* ToDo: LONG-compare
** 'size' IS word (signed) limited
*/
EXPORT PROC memcmp(mem1:PTR TO CHAR,mem2:PTR TO CHAR,size)

       MOVE.W  size.W,D1
       MOVEQ   #0,D0
       MOVEQ   #0,D2
       SUBQ.W  #1,D1
       BMI.S   memcmp_ende
       MOVEA.L mem1,A0
       MOVEA.L mem2,A1

memcmp_loop:
       MOVE.B  (A0)+,D0
       MOVE.B  (A1)+,D2
       SUB.W   D2,D0
       DBNE.S  D1,memcmp_loop

       EXT.L   D0

memcmp_ende:

ENDPROC D0

