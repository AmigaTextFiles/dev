        SECTION text,CODE

        INCLUDE "Flush_lib.i"

        XDEF    _FlushEnableAnnounce

_FlushEnableAnnounce
        MOVEM.L D2/A6,-(SP)

        MOVE.L  12(SP),D0
        MOVE.L  16(SP),A0
        MOVE.L  20(SP),D1
        MOVE.L  24(SP),D2

        MOVE.L  _FlushBase,A6
        JSR     _LVOFlushEnableAnnounce(A6)

        MOVEM.L (SP)+,D2/A6
        RTS

        END
