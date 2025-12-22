/* copies memory blocks. They may not overlap!
** Returns the destination.
*/

OPT MODULE

/*EXPORT PROC memcpy(dest:PTR TO CHAR,src:PTR TO CHAR,size)
DEF dummy

  dummy:=dest
  WHILE size-->=0 DO dest[]++:=src[]++

ENDPROC dummy*/

/*
EXPORT PROC memcpy(dest:PTR TO CHAR,src:PTR TO CHAR,size)

  MOVE.L  size,D0
  MOVEA.L dest,A1
  MOVEA.L src,A0
  SUBQ.L  #1,D0
  BLT.S   memcpy_ende
memcpy_loop:
  MOVE.B  (A0)+,(A1)+
  SUBQ.L  #1,D0
  BGE.S   memcpy_loop

memcpy_ende:
ENDPROC dest
*/

/* exec.library tries to do LONG-copies and is therefore a lot
** faster.
*/
EXPORT PROC memcpy(dest:PTR TO CHAR,src:PTR TO CHAR,size)
  CopyMem(src,dest,size)
ENDPROC dest

