        SECTION text,CODE

        INCLUDE "Flush_lib.i"

        XDEF    _FlushDo

_FlushDo
        MOVE.L  A6,-(SP)

        MOVE.L  _FlushBase,A6
        JSR     _LVOFlushDo(A6)

        MOVE.L  (SP)+,A6
        RTS

        END
