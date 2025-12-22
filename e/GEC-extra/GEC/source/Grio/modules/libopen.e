OPT MODULE

OBJECT liblist
  prev,base
ENDOBJECT

DEF ll:PTR TO liblist


EXPORT PROC gLibOpen(name,version=33)
 MOVEA.L  execbase,A6
 MOVEQ    #8,D0
 MOVEQ    #1,D1
 JSR      AllocMem(A6)
 TST.L    D0
 BEQ.S    quit
 MOVEA.L  D0,A2
 MOVEA.L  name,A1
 MOVE.L   version,D0
 JSR      OpenLibrary(A6)
 MOVE.L   D0,4(A2)
 BNE.S    ok_lib
 MOVEA.L  A2,A1
 MOVEQ    #8,D0
 JSR      FreeMem(A6)
 MOVEQ    #0,D0
 BRA.S    quit
ok_lib:
 MOVE.L   ll,(A2)
 MOVE.L   A2,ll
quit:
ENDPROC D0


EXPORT PROC gLibsClose()
 MOVE.L  ll,D0
 BEQ.S   exit
 MOVEA.L execbase,A6
loop:
 MOVE.L  D0,A2
 MOVEA.L 4(A2),A1
 JSR     CloseLibrary(A6)
 MOVE.L  (A2),D2
 MOVEQ   #8,D0
 MOVEA.L A2,A1
 JSR     FreeMem(A6)
 MOVE.L  D2,D0
 BNE.S   loop
exit:
ENDPROC D0







