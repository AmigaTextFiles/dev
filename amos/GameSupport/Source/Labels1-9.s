
**********************************************************************
; Please leave 1 or two labels free for future extension. You never
; know!
L1


; >>> How to get the parameters for the instruction?
;
; When an instruction or function is called, you get the parameters
; pushed in A3. Remember that you unpile them in REVERSE order than
; the instruction syntax.
; As you have a entry point for each set of parameters, you know
; how many are pushed...
;       - INTEGER:      move.l  (a3)+,d0
;       - STRING:       move.l  (a3)+,a0
;                       move.w  (a0)+,d0
;               A0---> start of the string.
;               D0---> length of the string
;       - FLOAT:        move.l  (a3)+,d0
;                       fast floatting point format.
;
; IMPORTANT POINT: you MUST unpile the EXACT number of parameters,
; to restore A3 to its original level. If you do not, you will not
; have a immediate error, and AMOS will certainely crash on next
; UNTIL / WEND / ENDIF / NEXT etc...
;
; So, your instruction must:
;       - Unpile the EXACT number of parameters from A3, and exit with
;       A3 at the original level it was before collecting your parameters)
;       - Preserve A4, A5 and A6
; You can use D0-D7/A0-A2 freely...
;
; You can jump to the error routine without thinking about A3 if an error
; occurs in your routine (via a RBra of course). BUT A4, A5 and A6 registers
; MUST be preserved!
;
; You end must end by a RTS.
;
; >>> Functions, how to return the parameter?
;
; To send a function`s parameter back to AMOS, you load it in D3,
; and put its type in D2:
;       moveq   #0,d2   for an integer
;       moveq   #1,d2   for a float
;       moveq   #2,d2   for a string
;

L_GSReadPort    equ     2
L2
        move.l  a6,-(a7)
        move.l  (a3)+,d0
        DLoad   a2
        move.l  MyLowLevelBase-MyBase(a2),d3
        beq     .error
        move.l  d3,a6
        jsr     _LVOReadJoyPort(a6)
        move.l  d0,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.error
        move.l  (a7)+,a6
        move.l  #0,d0
        Rbra    L_Custom

L_GSTimer equ     3
L3
        move.l  a6,-(a7)
        DLoad   a2
        move.l  MyLowLevelBase-MyBase(a2),d0
        beq     .error
        move.l  d0,a6
        lea     MyEClock-MyBase(a2),a0
        jsr     _LVOElapsedTime(a6)
        move.l  d0,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.error
        move.l  (a7)+,a6
        move.l  #0,d0
        Rbra    L_Custom

L_GSMouseDX equ 4
L4
        move.l  a6,-(a7)
        DLoad   a2
        move.l  (a3)+,d0
        bmi     .error
        beq     .port0
        cmp.l   #1,d0
        bne     .error
        move.l  LastXPort1-MyBase(a2),d0
        moveq   #0,d1
        move.w  $dff00c,d1
        and.w   #$ff,d1
        move.l  d1,LastXPort1-MyBase(a2)
        sub.l   d0,d1
        bsr     .fixdeltamouse
        move.l  d1,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.port0
        move.l  MouseDX0-MyBase(a2),d3
        move.l  #0,MouseDX0-MyBase(a2)
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.fixdeltamouse
        cmp.l   #128,d1
        bge     .sub
        cmp.l   #-128,d1
        bge     .dontadd
        add.l   #256,d1
.dontadd
        move.l  MouseSpeed-MyBase(a2),d0
        muls    d0,d1
        asr.l   #3,d1
        rts
.sub
        sub.l   #256,d1
        move.l  MouseSpeed-MyBase(a2),d0
        muls    d0,d1
        asr.l   #3,d1
        rts

.error
        moveq   #2,d0
        Rbra    L_Custom

L_GSMouseDY equ 5
L5
        move.l  a6,-(a7)
        DLoad   a2
        move.l  (a3)+,d0
        bmi     .error
        beq     .port0
        cmp.l   #1,d0
        bne     .error
        move.l  LastYPort1-MyBase(a2),d0
        moveq   #0,d1
        move.w  $dff00c,d1
        lsr.w   #8,d1
        move.l  d1,LastYPort1-MyBase(a2)
        sub.l   d0,d1
        bsr     .fixdeltamouse
        move.l  d1,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.port0
        move.l  MouseDY0-MyBase(a2),d3
        move.l  #0,MouseDY0-MyBase(a2)
        moveq   #0,d2
        move.l  (a7)+,a6
        rts

.fixdeltamouse
        cmp.l   #128,d1
        bge     .sub
        cmp.l   #-128,d1
        bge     .dontadd
        add.l   #256,d1
.dontadd
        move.l  MouseSpeed-MyBase(a2),d0
        muls    d0,d1
        asr.l   #3,d1
        rts
.sub
        sub.l   #256,d1
        move.l  MouseSpeed-MyBase(a2),d0
        muls    d0,d1
        asr.l   #3,d1
        rts

.error
        moveq   #2,d0
        Rbra    L_Custom

L_GSSetMouseSpeed equ 6
L6
        move.l  (a3)+,d0
        beq     .error
        DLoad   a2
        addq    #7,d0
        tst.w   d0
        bmi     .error
        move.l  d0,MouseSpeed-MyBase(a2)
        rts

.error
        moveq   #1,d0
        Rbra    L_Custom

L_GSIconify equ 7
L7
        DLoad   a2
        move.l  (a3)+,MyIconFilename-MyBase(a2)
        move.l  (a3)+,MyIconTitle-MyBase(a2)
        movem.l a3-6,-(a7)
        tst.l   MyWorkbenchBase-MyBase(a2)
        beq     .error
        tst.l   MyIconBase-MyBase(a2)
        beq     .error

        move.l  4,a6
        jsr     _LVOCreateMsgPort(a6)
        move.l  d0,IconMsgPort-MyBase(a2)
        tst.l   d0
        beq     .error2

        move.l  MyIconFilename-MyBase(a2),a0
        move.w  (a0)+,d0
        subq.w  #1,d0
        cmp.w   #128,d0
        blt     .nameok
        moveq   #23,d0
        Rjmp    L_Error
.nameok
        move.l  Name1(a5),a1
.namecopyloop
        move.b  (a0)+,(a1)+
        dbra    d0,.namecopyloop
        clr.b   (a1)
        Rjsr    L_Dsk.PathIt

        move.l  Name1(a5),a0
        move.l  MyIconBase-MyBase(a2),a6
        jsr     _LVOGetDiskObjectNew(a6)
        move.l  d0,MyDiskObject-MyBase(a2)
        tst.l   d0
        beq     .error3

        move.l  MyWorkbenchBase-MyBase(a2),a6
        moveq   #0,d0
        moveq   #0,d1
        move.l  MyIconTitle-MyBase(a2),a0
        lea     2(a0),a0
        move.l  IconMsgPort-MyBase(a2),a1
        move.l  MyDiskObject-MyBase(a2),a3
        move.l  #NO_ICON_POSITION,do_CurrentX(a3)
        move.l  #NO_ICON_POSITION,do_CurrentY(a3)
        move.l  #0,a2
        move.l  #0,a4
        jsr     _LVOAddAppIconA(a6)

        movem.l (a7),a3-6
        DLoad   a2
        move.l  d0,MyAppIcon-MyBase(a2)

        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVOWaitPort(a6)
        jsr     _LVOForbid(a6)
.loop   move.l  IconMsgPort-MyBase(a2),a0
        jsr     _LVOGetMsg(a6)
        tst.l   d0
        beq     .done
        move.l  d0,a1
        jsr     _LVOReplyMsg(a6)
.done
        move.l  MyAppIcon-MyBase(a2),a0
        move.l  MyWorkbenchBase-MyBase(a2),a6
        jsr     _LVORemoveAppIcon(a6)

        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVODeleteMsgPort(a6)

        jsr     _LVOPermit(a6)

        move.l  MyDiskObject-MyBase(a2),a0
        move.l  MyIconBase-MyBase(a2),a6
        jsr     _LVOFreeDiskObject(a6)

        movem.l (a7)+,a3-6
        moveq   #0,d3
        moveq   #0,d2
        rts

.error
        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

.error2
        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

.error3
        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVODeleteMsgPort(a6)

        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

.error4
        move.l  MyDiskObject-MyBase(a2),a0
        move.l  MyIconBase-MyBase(a2),a6
        jsr     _LVOFreeDiskObject(a6)

        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVODeleteMsgPort(a6)

        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

L_GSIconify2 equ 8
L8
;        illegal
        DLoad   a2
        move.l  (a3)+,MyIconTitle-MyBase(a2)
        movem.l a3-6,-(a7)
        tst.l   MyWorkbenchBase-MyBase(a2)
        beq     .error
        tst.l   MyIconBase-MyBase(a2)
        beq     .error

        move.l  4,a6
        jsr     _LVOCreateMsgPort(a6)
        move.l  d0,IconMsgPort-MyBase(a2)
        tst.l   d0
        beq     .error2

        move.l  MyIconBase-MyBase(a2),a6
        move.l  #WBTOOL,d0
        jsr     _LVOGetDefDiskObject(a6)
        move.l  d0,MyDiskObject-MyBase(a2)
        tst.l   d0
        beq     .error3

        move.l  MyWorkbenchBase-MyBase(a2),a6
        moveq   #0,d0
        moveq   #0,d1
        move.l  MyIconTitle-MyBase(a2),a0
        lea     2(a0),a0
        move.l  IconMsgPort-MyBase(a2),a1
        move.l  MyDiskObject-MyBase(a2),a3
        move.l  #0,a2
        move.l  #0,a4
        jsr     _LVOAddAppIconA(a6)

        movem.l (a7),a3-6
        DLoad   a2
        move.l  d0,MyAppIcon-MyBase(a2)

        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVOWaitPort(a6)
        jsr     _LVOForbid(a6)
.loop   move.l  IconMsgPort-MyBase(a2),a0
        jsr     _LVOGetMsg(a6)
        tst.l   d0
        beq     .done
        move.l  d0,a1
        jsr     _LVOReplyMsg(a6)
.done
        move.l  MyAppIcon-MyBase(a2),a0
        move.l  MyWorkbenchBase-MyBase(a2),a6
        jsr     _LVORemoveAppIcon(a6)

        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVODeleteMsgPort(a6)

        jsr     _LVOPermit(a6)

        move.l  MyDiskObject-MyBase(a2),a0
        move.l  MyIconBase-MyBase(a2),a6
        jsr     _LVOFreeDiskObject(a6)

        movem.l (a7)+,a3-6
        moveq   #0,d3
        moveq   #0,d2
        rts
.error
        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

.error2
        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

.error3
        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVODeleteMsgPort(a6)

        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

.error4
        move.l  MyDiskObject-MyBase(a2),a0
        move.l  MyIconBase-MyBase(a2),a6
        jsr     _LVOFreeDiskObject(a6)

        move.l  IconMsgPort-MyBase(a2),a0
        move.l  4,a6
        jsr     _LVODeleteMsgPort(a6)

        movem.l (a7)+,a3-6
        moveq   #1,d3
        moveq   #0,d2
        rts

L_GSSqr equ 9
L9
        move.l  (a3)+,d0
        move.l  d0,d2
        beq     .done   ; to handle a parameter of zero
        lsr.l   #8,d2   ; approx starting point.
        ext.l   d2
        addq    #7,d2
        moveq   #4,d3
.loop
        move.l  d2,d1
        move.l  d0,d2
        divu    d1,d2
        ext.l   d2
        add.l   d1,d2
        lsr.l   #1,d2
        cmp.l   d1,d2
        beq     .done
        dbf     d3,.loop
.done
        move.l  d2,d3
        moveq   #0,d2
        rts
