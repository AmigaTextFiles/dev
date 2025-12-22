    XDEF ___unwind_function
___unwind_function:
        move.l (A7)+,A0
        move.l (A7)+,A1
        unlk A5
        move.l (A7)+,A0
        move.l A1,-(A7)
        RTS
