/* fills an memory block with an value (byte).
**
** Returns the memory block.
*/

OPT MODULE

/*EXPORT PROC memset(mem:PTR TO CHAR,value,size)
DEF dummy

  dummy:=mem
  WHILE size-->=0 DO mem[]++:=value

ENDPROC dummy*/


/*EXPORT PROC memset(mem:PTR TO CHAR,value,size)

       MOVE.B  value.B,D0
       MOVE.L  size,D1
       MOVEA.L mem,A0
       SUBQ.L  #1,D1
       BLT.S   memset_ende
memset_loop:
       MOVE.B  D0,(A0)+
       SUBQ.L  #1,D1
       BGE.S   memset_loop

memset_ende:
ENDPROC mem
*/

/* Uses LONG writes if possible
*/
EXPORT PROC memset(mem:PTR TO CHAR,value,size)

       MOVE.B  value.B,D0
       MOVE.L  size,D1
       BLE.S   memset_ende
       MOVEA.L mem,A0

       CMPI.L  #8,D1      -> less than eight bytes?
       BLT.S   memset_loop

       MOVE.L  A0,D2
       LSR.L   #1,D2       -> A0 odd?
       BCC.S   memset_a0even
       MOVE.B  D0,(A0)+
       SUBQ.L  #1,D1

memset_a0even:
       MOVE.L  A0,D2
       LSR.L   #1,D2       -> A0 odd?
       BCS.B   memset_loop
       SUBQ.L  #4,D1

       MOVE.B  D0,D2
       LSL.W   #8,D0
       MOVE.B  D2,D0
       MOVE.W  D0,D2
       SWAP    D0
       MOVE.W  D2,D0
memset_longset:
       MOVE.L  D0,(A0)+
       SUBQ.L  #4,D1
       BHI.S   memset_longset

       ADDQ.L  #4,D1
       BLE.S   memset_ende

memset_loop:
       MOVE.B  D0,(A0)+
       SUBQ.L  #1,D1
       BNE.S   memset_loop

memset_ende:
ENDPROC mem

