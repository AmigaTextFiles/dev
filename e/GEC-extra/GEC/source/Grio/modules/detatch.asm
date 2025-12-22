




port    EQUR    d7
memlist EQUR    d6
mes     EQUR    d5
return  EQUR    d4
argsize EQUR    d3


arg             EQU     -$20
wbmessage       EQU     -$24
execbase        EQU     -$28
dosbase         EQU     -$2c

NT_MESSAGE      EQU     5
MEMF_CLEAR      EQU     $10000
MEMF_PUBLIC     EQU     1
SIZEOF_mn       EQU     20




DET_WB          EQU     1
DET_DETACHED    EQU     2


	XDEF    DET_WB
	XDEF    DET_DETACHED



FindTask        EQU     -294
AllocMem        EQU     -198
FreeMem         EQU     -210
PutMsg          EQU     -366
AddTail         EQU     -246

CreateProc      EQU     -138






	XDEF    detatch_name

detatch_name:
   MOVEA.L   execbase(A4),A6
   MOVE.L    wbmessage(A4),D0
   BEQ.S     start_det
   MOVEA.L   D0,A1
   TST.L     14(A1)    ; mn.replyport
   BEQ.S     fakemsg
   MOVEQ     #DET_WB,D0
   RTS
fakemsg:
   MOVE.L    newarg(PC),D0
   BEQ.S     noarg
   MOVE.L    D0,arg(A4)
noarg:
   MOVEQ     #SIZEOF_mn,D0
   JSR       FreeMem(A6) 
   CLR.L     wbmessage(A4)
   MOVEQ     #DET_DETACHED,D0
   RTS
start_det:
   MOVEQ     #20,return
   LEA       newarg(PC),A0
   CLR.L     (A0)
   SUBA.L    A1,A1
   JSR       FindTask(A6)
   MOVEA.L   D0,A5
   MOVE.L    172(A5),D0   ;  pr.cli
   ASL.L     #2,D0
   MOVEA.L   D0,A3
   MOVEQ     #SIZEOF_mn,D0
   MOVE.L    #MEMF_CLEAR!MEMF_PUBLIC,D1
   JSR       AllocMem(A6)
   MOVE.L    D0,mes
   BEQ.W     clean
   MOVE.L    4(A7),D1     ;  name
   BNE.S     ok_name
   MOVE.L    16(A3),D1    ; cli.commandfile
   ASL.L     #2,D1
   ADDQ.L    #1,D1
ok_name:
   MOVE.B    9(A5),D2     ;  ln.pri
   EXT.W     D2
   EXT.L     D2
   LEA       60(A3),A3    ;  ptr to cli.module
   MOVEM.L   D3/D4/A6,-(A7)
   MOVE.L    (A3),D3
   MOVEQ     #64,D4
   ASL.L     #5,D4
   MOVEA.L   dosbase(A4),A6
   JSR       CreateProc(A6)
   MOVEM.L   (A7)+,D3/D4/A6
   MOVEA.L   mes,A1
   MOVE.L    D0,port
   BNE.S     ok_proc
   MOVEQ     #SIZEOF_mn,D0
   JSR       FreeMem(A6)
   BRA.W     clean
ok_proc:
   MOVE.B    #NT_MESSAGE,8(A1)  ; mn.type
   MOVEA.L   port,A0
   JSR       PutMsg(A6)
   MOVEA.L   arg(A4),A0
   MOVE.L    A0,D0
looplen:
   TST.B     (A0)+
   BNE.S     looplen
   SUB.L     D0,A0
   MOVE.L    A0,D0
   ADDQ.L    #8,D0
   MOVE.L    D0,D2
   MOVEQ     #0,D1
   JSR       AllocMem(A6)
   TST.L     D0
   BEQ.S     zero
   MOVE.L    D2,argsize
   LEA       newarg(PC),A0
   MOVE.L    D0,(A0)
   MOVEA.L   arg(A4),A0
   MOVEA.L   D0,A1
looparg:
   MOVE.B    (A0)+,(A1)+
   BNE.S     looparg
zero:
   MOVE.L    (A3),D1
   CLR.L     (A3)  ; cli.module
   ASL.L     #2,D1
   MOVE.L    D1,A3  ; seg
   MOVEQ     #0,return
   MOVEQ     #16,D0
   MOVEQ     #0,D2
loop:
   MOVEA.L   D1,A1
   ADDQ.L    #1,D2
   ADDQ.L    #8,D0
   MOVE.L    (A1),D1
   ASL.L     #2,D1
   BNE.S     loop
   TST.L     argsize
   BEQ.S     noarg1
   ADDQ.L    #8,D0
noarg1:
   MOVE.L    #MEMF_CLEAR!MEMF_PUBLIC,D1
   JSR       AllocMem(A6)
   MOVE.L    D0,memlist
   BEQ.S     clean
   MOVEA.L   D0,A2
   MOVEA.L   D0,A0
   MOVE.L    D2,D0
   LEA       16(A2),A2
   TST.L     argsize
   BEQ.S     noarg2
   ADDQ.W    #1,D0
   MOVE.L    newarg(PC),(A2)+
   MOVE.L    argsize,(A2)+
noarg2:
   MOVE.W    D0,14(A0)   ; ml.numentries
   TST.W     D2
   BEQ.S     noentry
loopentry:
   SUBQ.L    #4,A3
   MOVE.L    A3,(A2)+     ; segptr
   MOVE.L    (A3)+,(A2)+  ; segsize
   MOVE.L    (A3),D0
   ASL.L     #2,D0
   MOVEA.L   D0,A3        ; nextseg
   SUBQ.L    #1,D2
   BNE.S     loopentry
noentry:
   MOVEA.L   port,A0
   LEA       74-92(A0),A0   ; tc.mementry , process=port-92
   MOVEA.L   memlist,A1
   JSR       AddTail(A6)
clean:
   MOVE.L    return,-$1C(A4)    ; CleanUp(return)
   MOVEA.L   -$18(A4),A0
   JMP       (A0)

newarg:
   DC.L   0



