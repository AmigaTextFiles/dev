*
* mymacros.i - © Copyright 1990-91 Jaba Development
*
* Author  : Jan van den Baard
*
* Some very simple macros to make life easier......(?)
*

    IFND    MYMACROS_I
MYMACROS_I  SET 1

*
*   libcall OpenWindow   equals   jsr _LVOOpenWindow(a6)
*
libcall macro
        ifc     '','\1'
        fail
        mexit
        endc
        jsr     _LVO\1(a6)
        endm

*
*   cldat d0   equals   moveq #0,d0
*
cldat   macro
        ifc     '','\1'
        fail
        mexit
        endc
        moveq   #0,\1
        endm

*
*   cladr a0   equals   suba.l a0,a0
*
cladr   macro
        ifc     '','\1'
        fail
        mexit
        endc
        suba.l  \1,\1
        endm

*
*   inc.l d0   equals   addq.l #1,d0
*
inc     macro
        ifc     '','\1'
        fail
        mexit
        endc
        addq.\0  #1,\1
        endm

*
*   dec.l d0   equals   subq.l #1,d0
*
dec     macro
        ifc     '','\1'
        fail
        mexit
        endc
        subq.\0  #1,\1
        endm

*
*   push.w d0   equals   move.w d0,-(sp)
*
push    macro
        ifc     '','\1'
        fail
        mexit
        endc
        move.\0 \1,-(sp)
        endm

*
*   pop.w d0   equals   move.w (sp)+,d0
*
pop     macro
        ifc     '','\1'
        fail
        mexit
        endc
        move.\0 (sp)+,\1
        endm

*
*   pull 4,d0   equals   move.l 4(sp),d0
*
pull    macro
        ifne    NARG-3
        fail
        mexit
        endc
        move.\0 \1(sp),\2
        endm

*
*   pushem.l d0-d2/a0/a6   equals   movem.l d0-d2/a0/a6,-(sp)
*
pushem  macro
        ifc     '','\1'
        fail
        mexit
        endc
        movem.\0 \1,-(sp)
        endm

*
*   popem.l d0-d2/a0/a6   equals   movem.l (sp)+,d0-d2/a0/a6
*
popem   macro
        ifc     '','\1'
        fail
        mexit
        endc
        movem.\0 (sp)+,\1
        endm

*
*   pullem.l 4,d0-d3/a0   equals   movem.l 4(sp),d0-d3/a0
*
pullem  macro
        ifne    NARG-3
        fail
        mexit
        endc
        movem.\0 \1(sp),\2
        endm

    ENDC    !MYMACROS_I
