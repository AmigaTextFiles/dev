



AllocMem	EQU	-198
FreeMem		EQU	-210
AddIntServer	EQU	-168
RemIntServer	EQU	-174


MEMF_ANY	EQU	0
MEMF_CLEAR	EQU	$10000
MEMF_PUBLIC	EQU	1


SIZEOF_is	EQU	22

NT_INTERRUPT	EQU	2
CUSTOMADDR	EQU	$DFF000

INTB_VERTB	EQU	5





     XDEF       addVBlankInt_name_func_pri_argdata


addVBlankInt_name_func_pri_argdata:
     MOVEA.L    4.W,A6
     MOVEQ      #SIZEOF_code+8,D0
     MOVEQ      #MEMF_ANY,D1
     JSR        AllocMem(A6)
     TST.L      D0
     BEQ.S      quit_add
     MOVEA.L    D0,A1
     MOVE.L     12(A7),(A1)+     ; func  
     MOVE.L     A4,(A1)+
     MOVEA.L    A1,A2
     LEA        start(PC),A0
     MOVEQ      #(SIZEOF_code/4)-1,D0
copyloop:
     MOVE.L     (A0)+,(A1)+
     DBRA       D0,copyloop
     MOVEQ      #SIZEOF_is,D0
     MOVE.L     #MEMF_CLEAR!MEMF_PUBLIC,D1
     JSR        AllocMem(A6)
     MOVE.L     D0,D2
     BEQ.S      free_add
     MOVEA.L    D0,A1
     MOVE.B     #NT_INTERRUPT,8(A1)   ; ln.type
     MOVE.B     11(A7),9(A1)          ; ln.pri
     MOVE.L     16(A7),10(A1)         ; ln.name
     MOVE.L     4(A7),14(A1)          ; is.data
     MOVE.L     A2,18(A1)             ; is.code
     MOVEQ      #INTB_VERTB,D0
     JSR        AddIntServer(A6)
     MOVE.L     D2,D0
quit_add:
     RTS
free_add:
     LEA        -8(A2),A1
     MOVEQ      #SIZEOF_code+8,D0
     JSR        FreeMem(A6)
     MOVEQ      #0,D0
     RTS




start:
     MOVEM.L  D2-D7/A2-A4,-(A7)
     MOVEA.L  start-4(PC),A4
     MOVE.L   A1,-(A7)
     MOVEA.L  start-8(PC),A6
     JSR      (A6)
     ADDQ.W   #4,A7
     MOVEM.L  (A7)+,D2-D7/A2-A4
     LEA      CUSTOMADDR,A0
     MOVEQ    #0,D0    
     RTS
     DS.L     0
end:

SIZEOF_code	EQU	end-start





     XDEF     delVBlankInt_vbint


delVBlankInt_vbint:
     MOVE.L    4(A7),D0
     BEQ.S     quit_rem
     MOVEA.L   D0,A2
     MOVEA.L   4.W,A6
     MOVEA.L   A2,A1
     MOVEQ     #INTB_VERTB,D0
     JSR       RemIntServer(A6)
     MOVEA.L   18(A2),A1
     SUBQ.W    #8,A1
     MOVEQ     #SIZEOF_code+8,D0
     JSR       FreeMem(A6)
     MOVEA.L   A2,A1
     MOVEQ     #SIZEOF_is,D0
     JSR       FreeMem(A6)
     MOVEQ     #0,D0
quit_rem:
     RTS


