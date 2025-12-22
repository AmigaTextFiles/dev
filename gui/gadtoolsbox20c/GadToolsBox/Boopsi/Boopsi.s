                opt     l+,o+,ow-,inconce

*-- AutoRev header do NOT edit!
*
*   Program         :   GetFile.s
*   Copyright       :   © Copyright 1992 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   21-Jan-92
*   Current version :   1.0
*   Translator      :   Devpac 3 ( version 3.01 )
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   21-Jan-92     1.0             "GetFile" boopsi image.
*
*-- REV_END --*

                incdir  "sys:asm20/"
                include "mymacros.i"
                include "intuition/intuition.i"
                include "intuition/classes.i"
                include "intuition/classusr.i"
                include "intuition/imageclass.i"
                include "libraries/gadtools.i"

                include "intuition/intuition_lib.i"
                include "graphics/graphics_lib.i"
                include "utility/utility_lib.i"
                include "libraries/gadtools_lib.i"

                XDEF    _initGet
                XDEF    initGet

                XREF    _IntuitionBase
                XREF    _GfxBase
                XREF    _UtilityBase
                XREF    _GadToolsBase

                SECTION "getfile",CODE

;
; --- This routine call's this class it's super class.
; --- First it get's the class it's super class in a0.
; --- Then it pushes "ourRet" on the stack which will be
; --- the return address of the superclass dispatcher.
; --- Then it pushes the lowlevel entry of the superclass
; --- dispatcher on the stack and performs an rts which
; --- causes a jump to the superclass dispatcher. When the
; --- superclass dispatcher is done it will return to "ourRet".
;
callSuper:      push.l      a2                  ; save a2
                move.l      cl_Super(a0),a0     ; get superclass in a0
                pea.l       ourRet              ; push return address
                push.l      h_Entry(a0)         ; push superclass dispatcher
                rts                             ; jump to super dispatcher
ourRet:         pop.l       a2                  ; restore a2
                rts

;
; --- Initialize our private class. It set's up a class
; --- with "imageclass" as superclass.
;
_initGet:
initGet:        pushem.l    a2/a6               ; save registers
                move.l      _IntuitionBase,a6
                cladr       a0                  ; class ID
                lea.l       IClassName,a1       ; points to "imageclass"
                cladr       a2                  ; no superclass pointer
                cldat       d0                  ; no instance data
                cldat       d1                  ; no flags
                libcall     MakeClass           ; make the class
                move.l      d0,a0               ; put class in a0
                tst.l       d0
                beq.s       noClass             ; failed!!!
                lea.l       dispatchGet(pc),a1  ; pointer to dispatcher
                move.l      a1,h_Entry(a0)      ; set our dispatcher
noClass:        popem.l     a2/a6               ; restore registers
                rts

dispatchGet:    pushem.l    d2-d7/a2-a6         ; save registers
                move.l      a0,a4               ; class to a4
                move.l      a1,a3               ; msg to a3

                cmp.l       #OM_NEW,(a3)        ; user want a new object ?
                bne.s       noNew               ; no!

                move.l      _UtilityBase,a6
                move.l      #GT_VisualInfo,d0   ; the tag we want
                cldat       d1                  ; default = NULL
                move.l      ops_AttrList(a3),a0 ; tags to a0
                libcall     GetTagData          ; look for the tag
                tst.l       d0                  ; tag found ?
                beq.s       newErrorV           ; no
                push.l      d0                  ; stack visualinfo

                move.l      a4,a0               ; class to a0
                move.l      a3,a1               ; msg to a1
                bsr         callSuper           ; call the superclass
                move.l      d0,a0               ; put object in a0
                tst.l       d0
                beq.s       newErrorO           ; failed!!!
                move.w      #20,ig_Width(a0)    ; set default width
                move.w      #14,ig_Height(a0)   ; set default height
                pop.l       ig_ImageData(a0)    ; set visualInfo
                bra         Done                ; return Object
newErrorO:      addq.w      #4,sp               ; restore stack
newErrorV:      cldat       d0                  ; 0 for error
                bra         Done

noNew:          cmp.l       #IM_DRAW,(a3)       ; must we draw  ?
                bne         default             ; no!

draw:           cldat       d4                  ; left = 0
                cldat       d5                  ; top = 0
                moveq       #20,d6              ; width = 20
                moveq       #14,d7              ; height = 14

                move.w      impd_OffsetX(a3),d4 ; left = x offset
                move.w      impd_OffsetY(a3),d5 ; top = y offset

                move.l      _GfxBase,a6
                move.l      impd_RPort(a3),a5   ; rport to a5
                move.l      ig_ImageData(a2),a4 ; visualinfo to a4

                move.l      impd_DrInfo(a3),a2  ; drawinfo to a2
                move.l      dri_Pens(a2),a2     ; drawinfo pens to a2

                clr.l       rp_AreaPtrn(a5)     ; clear area pattern
                clr.b       rp_AreaPtSz(a5)

                move.l      a5,a1               ; rport to a1

                cmp.l       #IDS_SELECTED,impd_State(a3) ; draw selected ?
                bne.s       noSel               ; no!
                move.w      hifillPen*2(a2),d0  ; FILLPEN color
                bra.s       penDone
noSel:          move.w      backgroundPen*2(a2),d0 ; BACKGROUNDPEN color
penDone:        libcall     SetAPen             ; set the pen

                move.l      a5,a1               ; rport to a1
                move.w      d4,d0               ; left to d0
                move.w      d5,d1               ; top to d1
                move.w      d4,d2
                add.w       d6,d2
                dec.w       d2                  ; left + width - 1 to d2
                move.w      d5,d3
                add.w       d7,d3
                dec.w       d3                  ; top + height - 1 to d3
                libcall     RectFill

                move.l      _GadToolsBase,a6
                move.l      a5,a0               ; rport to a0
                move.l      d4,d0               ; left to d0
                move.l      d5,d1               ; top to d1
                move.l      d6,d2               ; width to d2
                move.l      d7,d3               ; height to d3
                pea.l       TAG_DONE
                cmp.l       #IDS_SELECTED,impd_State(a3) ; draw recessed ?
                bne.s       normal
                pea.l       1                   ; recessed
                pea.l       GTBB_Recessed
normal:         push.l      a4
                pea.l       GT_VisualInfo
                move.l      sp,a1
                libcall     DrawBevelBoxA       ; draw the bevel box
                lea.l       12(sp),sp           ; restore stack ptr
                cmp.l       #IDS_SELECTED,impd_State(a3)
                bne.s       ok
                addq.w      #8,sp               ; restore stack a little more
ok:
                move.l      _GfxBase,a6
                move.l      a5,a1               ; rport to a1
                cmp.l       #IDS_SELECTED,impd_State(a3) ; selected text pen?
                bne.s       noFPen
                move.w      hifilltextPen*2(a2),d0 ; FILLTEXTPEN color
                bra.s       setPen
noFPen:         move.w      textPen*2(a2),d0    ; TEXTPEN color
setPen:         libcall     SetAPen             ; set the pen

                addq.w      #4,d4               ; set x for PolyDraw
                addq.w      #8,d5               ; set y for PolyDraw
                addq.w      #2,d5               ;  "  "  "   "   "

                lea.l       -52(sp),sp          ; create stack space

                moveq       #14,d0              ; 13 XY pairs
                lea.l       PolyArray(pc),a1    ; pointer to XY array in a1
                lea.l       (sp),a0             ; stack ptr to a0
loopCnt:        move.w      (a1)+,(a0)          ; X to (a0)
                add.w       d4,(a0)+            ; (a0) += left
                move.w      (a1)+,(a0)          ; Y to (a0)
                add.w       d5,(a0)+            ; (a0) += top
                dbra        d0,loopCnt

                move.l      a5,a1               ; rport to a1
                move.l      d4,d0               ; left to d0
                move.l      d5,d1               ; top to d1
                libcall     Move                ; move to this point

                move.l      a5,a1               ; rport to a1
                move.l      sp,a0               ; array pointer in a0
                moveq       #13,d0              ; 13 XY pairs
                libcall     PolyDraw            ; draw the lines

                lea.l       52(sp),sp           ; restore original stackptr

                moveq       #1,d0               ; return TRUE
                bra.s       Done

default:        move.l      a4,a0               ; class to a0
                move.l      a3,a1               ; msg to a1
                bsr         callSuper           ; call superclass
Done:           popem.l     d2-d7/a2-a6         ; restore registers
                rts

IClassName:     dc.b        'imageclass',0      ; superclass ID
                even

PolyArray:      dc.w        0,-6,1,-6,1,0,11,0,11,-6,9,-8,6
                dc.w        -8,4,-6,2,-6,2,-5,5,-5,6,-4,10,-4
