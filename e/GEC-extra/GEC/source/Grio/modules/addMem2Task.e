OPT MODULE


EXPORT PROC addMem2Task(task,mem,size)
MOVEA.L   execbase,A6
JSR       Forbid(A6)
MOVEQ     #16+8,D0
MOVEQ     #1,D1
SWAP      D1
JSR       AllocMem(A6)
TST.L     D0
BEQ.S     quit
MOVEA.L   D0,A1
MOVE.W    #1,14(A1)   ->ml.numentries
MOVE.L    mem,16(A1)
MOVE.L    size,20(A1)
MOVEA.L   task,A0
LEA       74(A0),A0   ->tc.mementry
JSR       AddTail(A6)
MOVEQ     #-1,D0
quit:
JSR       Permit(A6)
ENDPROC D0
