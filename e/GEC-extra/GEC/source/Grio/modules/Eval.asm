


        XDEF    gEval_func_argslist


gEval_func_argslist:

        MOVE.L   8(A7),D0
        BEQ.S    nofunc
        MOVEA.L  D0,A1
        MOVE.L   4(A7),D1
        BNE.B    getargs
noargs:
        JMP      (A1)
getargs:
        MOVEA.L  D1,A0
        MOVE.W   -2(A0),D0
        BEQ.S    noargs
        LINK     A5,#0
loop:
        MOVE.L   (A0)+,-(A7)
        SUBQ.W   #1,D0
        BNE.B    loop
        JSR      (A1)
        UNLK     A5
nofunc:
        RTS



        
