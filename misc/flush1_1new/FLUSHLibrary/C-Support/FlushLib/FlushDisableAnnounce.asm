        SECTION text,CODE

        INCLUDE "Flush_lib.i"

        XDEF    _FlushDisableAnnounce

_FlushDisableAnnounce
        MOVE.L  A6,-(SP)

        MOVE.L  8(SP),D0

        MOVE.L  _FlushBase,A6
        JSR     _LVOFlushDisableAnnounce(A6)

        MOVE.L  (SP)+,A6
        RTS

        END
