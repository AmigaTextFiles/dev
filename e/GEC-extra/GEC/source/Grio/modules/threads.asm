


		rsreset
FAKESEG         rs.l  1
NEXT            rs.l  1
NAME            rs.b  32
PRIO            rs.l  1
STCK            rs.l  1
PROCESS         rs.l  1
READY           rs.l  1
FREEZE          rs.w  1
SIZEOF_THREAD   rs.b  0



AllocMem        EQU     -198
FreeMem         EQU     -210
CreateProc      EQU     -138
UnLoadSeg       EQU     -156
Forbid          EQU     -132
Permit          EQU     -138
FindTask        EQU     -294
RemTask         EQU     -288
Remove          EQU     -252
AddTail         EQU     -246
Disable         EQU     -120
Enable          EQU     -126


EL_TASKWAIT     EQU     420
EL_TASKREADY    EQU     406
TC_FLAGS        EQU     15
TS_READY        EQU     3
TF_ETASK        EQU     8




execbase        EQU     -$28
dosbase         EQU     -$2c



 XDEF     freezeThread_thread

freezeThread_thread:
 MOVE.L   4(A7),D0
 BEQ.S    .quit
 MOVE.L   D0,A2
 MOVEQ    #0,D2
 MOVE.L   execbase(A4),A6
; JSR      Disable(A6)
 JSR      Forbid(A6)
 MOVE.L   A2,D0
 BSR.W    isThreadReady
 BEQ.S    .skip
 SUBA.L   A1,A1
 JSR      FindTask(A6)
 MOVE.L   PROCESS(A2),A1
 CMP.L    A1,D0
 BEQ.S    .skip
 JSR      Remove(A6)
 MOVE.W   #$FFFF,FREEZE(A2)
 MOVE.L   PROCESS(A2),A1
 MOVE.B   #TF_ETASK,TC_FLAGS(A1)
 LEA      EL_TASKWAIT(A6),A0
 JSR      AddTail(A6)
 MOVEQ    #-1,D2
.skip:
; JSR      Enable(A6)
 JSR      Permit(A6)
 MOVE.L   D2,D0
.quit:
 RTS



 XDEF     activateThread_thread
 
activateThread_thread:
 MOVE.L   4(A7),D0
 BEQ.S    activateThreadquit
 MOVE.L   D0,A2
activateThread:
 MOVEQ    #0,D2
 MOVE.L   execbase(A4),A6
; JSR      Disable(A6)
 JSR      Forbid(A6)
 MOVE.L   A2,D0
 BSR.B    isThreadReady
 BEQ.S    .skip
 MOVE.L   A2,D0
 BSR.S    isThreadFreezed
 BEQ.S    .skip
 MOVEA.L  PROCESS(A2),A1
 JSR      Remove(A6)
 MOVEA.L  PROCESS(A2),A1
 MOVE.B   #TS_READY,TC_FLAGS(A1)
 LEA      EL_TASKREADY(A6),A0
 JSR      AddTail(A6)
 CLR.W    FREEZE(A2)
 MOVEQ    #-1,D2
.skip:
; JSR      Enable(a6)
 JSR      Permit(A6)
 MOVE.L   D2,D0
activateThreadquit:
 RTS




 XDEF     isThreadFreezed_thread

isThreadFreezed_thread:
 MOVE.L   4(A7),D0
 BEQ.S    quitisThreadFreezed
isThreadFreezed:
 MOVE.L   D0,A0
 MOVE.W   FREEZE(A0),D0
 EXT.L    D0
quitisThreadFreezed:
 RTS



 XDEF     numberOfThreads

numberOfThreads:
 MOVE.L   list(PC),D0
 BEQ.S    .quit
 MOVE.L   D0,D1
.loop:
 ADDQ.L   #1,D0
 MOVEA.L  D1,A0
 MOVE.L   NEXT(A0),D1
 BNE.S    .loop
.quit
 RTS


 XDEF     isThreadReady_thread

isThreadReady_thread:
 MOVE.L   4(A7),D0
 BEQ.S    quitis
isThreadReady:
 MOVEA.L  D0,A0
 MOVE.L   READY(A0),A0
 MOVE.W   (A0),D0
 EXT.L    D0
quitis:
 RTS




 XDEF     initThreads

initThreads:
 LEA      list(PC),A0
 CLR.L    (A0)
quitinit:
 RTS


list:
 DC.L    0




 XDEF     deleteThreadByName_name

deleteThreadByName_name:
 MOVE.L   4(A7),D0
 BSR.S    findthread
 TST.L    D0
 BEQ.S    quitdelname
 BSR.S    deleteThread
 MOVEQ    #-1,D0
quitdelname:
 RTS



findthread:
 BEQ.S    quitdelname
 MOVEA.L  D0,A2
 MOVE.L   list(PC),D0
loopfindname:
 BEQ.S    quitdelname
 MOVEA.L  D0,A3
 LEA      NAME(A3),A1
 MOVEA.L  A2,A0
cmpfind:
 MOVE.B   (A0)+,D0
 CMP.B    (A1)+,D0
 BEQ.S    itsame
 MOVE.L   NEXT(A3),D0
 BRA.S    loopfindname
itsame:
 TST.B    D0
 BNE.S    cmpfind
 MOVE.L   A3,D0
quitfind:
 RTS


 XDEF     remThreadByName_name

remThreadByName_name:
 MOVE.L   4(A7),D0
 BSR.S    findthread
 TST.L    D0
 BNE.S    remThread
 RTS




 XDEF     deleteAllThreads

deleteAllThreads:
loopdelall:
 MOVE.L   list(PC),D0
 BEQ.S    quitdelall
 BSR.S    deleteThread
 BRA.S    loopdelall
quitdelall:
 RTS




 XDEF    deleteThread_thread

deleteThread_thread:
 MOVE.L  4(A7),D0
 BEQ.S   quitdel
deleteThread:
 MOVEQ   #0,D2
 BSR.S   remThread
 LEA     list(PC),A1
 MOVE.L  (A1),D0
loop_rem:
 BEQ.S   quitdel
 CMPA.L  D0,A2
 BEQ.S   remove
 MOVEA.L D0,A1
 LEA     NEXT(A1),A1
 MOVE.L  (A1),D0
 BRA.S   loop_rem
remove:
 MOVE.L  NEXT(A2),(A1)
 MOVE.L  FAKESEG(A2),D0
 BSR.W   freeFakeSeg
 MOVEQ   #-1,D2
freethread:
 MOVEA.L A2,A1
 MOVEQ   #SIZEOF_THREAD,D0
 JSR     FreeMem(A6)
 MOVE.L  D2,D0
quitdel:
 RTS



 XDEF    remThread_thread
 
remThread_thread:
 MOVE.L  4(A7),D0
 BEQ.S   quitrem
remThread:
 MOVEA.L D0,A2
 MOVEA.L execbase(A4),A6
 JSR     Forbid(A6)
 BSR.W   activateThread
 MOVE.L  FAKESEG(A2),D0
 BSR.W   fakeSegUsed
 MOVE.L  D0,-(A7)
 BEQ.S   no_taski
 MOVEA.L PROCESS(A2),A1
 JSR     RemTask(A6)
 MOVE.L  READY(A2),A0
 CLR.W   (A0)
no_taski:
 JSR     Permit(A6)
 MOVE.L  (A7)+,D0
quitrem:
 RTS




 XDEF      addThread_thread_argdata

addThread_thread_argdata:
 MOVE.L  8(A7),D0
 BEQ.S   quitadd
addThread:
 MOVE.L  D0,A2
 MOVEQ   #0,D2
 MOVEA.L execbase(A4),A6
 JSR     Forbid(A6)
 LEA     NAME(A2),A1
 JSR     FindTask(A6)
 TST.L   D0
 BNE.S   addpermit
 MOVE.L  FAKESEG(A2),D0
 LSL.L   #2,D0
 MOVE.L  D0,A0
 MOVE.L  4(A7),ArgPtr(A0)
 PEA     NAME(A2)
 MOVE.L  (A7)+,D1
 MOVE.L  PRIO(A2),D2
 MOVEM.L D3/D4/A6,-(A7)
 MOVE.L  FAKESEG(A2),D3
 MOVE.L  STCK(A2),D4
 MOVEA.L dosbase(A4),A6
 JSR     CreateProc(A6)
 MOVEM.L (A7)+,D3/D4/A6
 TST.L   D0
 BEQ.S   addpermit
 MOVEQ   #-92,D2    ;  SIZEOF Task = 92
 ADD.L   D0,D2
 MOVE.L  READY(A2),A0
 MOVE.W  #$FFFF,(A0)
addpermit:
 JSR     Permit(A6)
 MOVE.L  D2,D0
 MOVE.L  D2,PROCESS(A2)
quitadd:
 RTS






 XDEF    createThread_name_procaddr_pri_stack

		rsset   4
stack           rs.l    1
pri             rs.l    1
procaddr        rs.l    1
name            rs.l    1


createThread_name_procaddr_pri_stack:
 MOVE.L  name(A7),D0
 BEQ.B   quitstart
 MOVEA.L D0,A3
 MOVEA.L execbase(A4),A6 
 MOVEQ   #SIZEOF_THREAD,D0
 MOVEQ   #0,D1
 JSR     AllocMem(A6)
 TST.L   D0
 BEQ.S   quitstart
 MOVEA.L D0,A2
 LEA     NAME(A2),A0
 MOVEQ   #29,D1
copyname:
 MOVE.B  (A3)+,(A0)+
 DBEQ    D1,copyname
 CLR.B   (A0)
 MOVE.L  stack(A7),STCK(A2)
 MOVE.L  pri(A7),PRIO(A2)
 MOVEQ   #0,D1
 MOVE.L  procaddr(A7),D0
 BSR.S   createSeg
 MOVE.L  D1,READY(A2)
 MOVEQ   #0,D2
 MOVE.L  D0,FAKESEG(A2)
 BEQ.W   freethread
 LEA     list(PC),A1
 MOVE.L  (A1),NEXT(A2)
 MOVE.L  A2,(A1)
 CLR.W   FREEZE(A2)
 MOVE.L  A2,D0
quitstart:
 RTS
 



 XDEF     createFakeSeg_procaddr_argdata

createFakeSeg_procaddr_argdata:
 MOVE.L   8(A7),D1
 MOVE.L   4(A7),D0
createSeg:
 BEQ.S    quit
 LEA      procedure(PC),A0
 MOVEM.L  D0/D1/A4,(A0)
 MOVEQ    #segsize,D0
 MOVEQ    #0,D1
 MOVEA.L  execbase(A4),A6
 JSR      AllocMem(A6)
 MOVE.L   D0,D1
 BEQ.S    quit
 MOVE.L   D0,A1
 MOVEQ    #segsize,D1
 MOVE.L   D1,(A1)+
 MOVE.L   A1,D0
 LSR.L    #2,D0
 CLR.L    (A1)+ 
 LEA      fakecode(PC),A0
 MOVEQ    #(codesize/4)-1,D1
copymem:
 MOVE.L   (A0)+,(A1)+
 DBRA     D1,copymem
 MOVEQ    #-14,D1
 ADD.L    A1,D1
quit:
 RTS



fakecode:
  LEA      start(PC),A0
  MOVE.W   #-1,(A0)
  MOVEA.L  a4Base(PC),A4
  MOVE.L   argdata(PC),-(A7)
  MOVEA.L  procedure(PC),A0
  JSR      (A0)
  ADDQ.W   #4,A7
  LEA      start(PC),A0
  CLR.W    (A0)
  RTS
  DC.W     0
start:
  DC.W     0
procedure:
  DC.L     "PROC"
argdata:
  DC.L     " ARG"
a4Base:
  DC.L     "  A4"
endcode:

codesize    EQU    endcode-fakecode
segsize     EQU    codesize+8
ArgPtr      EQU    argdata-fakecode+4
ReadyPtr    EQU    ArgPtr-6







 XDEF     freeFakeSeg_fakeseg

freeFakeSeg_fakeseg:
 MOVE.L   4(A7),D0
freeFakeSeg:
 BEQ.S    quitfreeseg
 LSL.L    #2,D0
 MOVE.L   D0,A1
 MOVE.L   -(A1),D0
 MOVEA.L  execbase(A4),A6
 JSR      FreeMem(A6)
quitfreeseg:
 RTS



 XDEF     fakeSegUsed_fakeseg

fakeSegUsed_fakeseg:
 MOVE.L   4(A7),D0
fakeSegUsed:
 BEQ.S    .quit
 LSL.L    #2,D0
 MOVE.L   D0,A0
 MOVE.W   ReadyPtr(A0),D0
 EXT.L    D0
.quit:
 RTS



