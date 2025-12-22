* mac/call.i

CALLSYS MACRO
        jsr     _LVO\1(a6)
        ENDM

CALLEXE MACRO
        movea.l _SysBase,a6
        jsr     _LVO\1(a6)
        ENDM

CALLGFX MACRO
        movea.l _GfxBase,a6
        jsr     _LVO\1(a6)
        ENDM

CALLITU MACRO
        movea.l _IntuitionBase,a6
        jsr     _LVO\1(a6)
        ENDM

CALLDOS MACRO
        movea.l _DOSBase,a6
        jsr     _LVO\1(a6)
        ENDM

LINKSYS MACRO
        move.l  a6,-(a7)
        move.l  \2,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKEXE MACRO
        move.l  a6,-(a7)
        movea.l _SysBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKGFX MACRO
        move.l  a6,-(a7)
        movea.l _GfxBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKITU MACRO
        move.l  a6,-(a7)
        movea.l _IntuitionBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM

LINKDOS MACRO
        move.l  a6,-(a7)
        movea.l _DOSBase,a6
        jsr     _LVO\1(a6)
        move.l  (a7)+,a6
        ENDM
