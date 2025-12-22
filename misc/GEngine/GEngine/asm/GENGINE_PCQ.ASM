
   incdir   "sys:devpac/include/"
   INCLUDE  "exec/types.i"
   INCLUDE  "exec/libraries.i"

          section DATA

*----- LIBINIT initializes an LVO value to -30 to skip the first four
*----- 6-byte required library vectors (Open, Expunge, etc)

             LIBINIT

*----- LIBDEF assigns the current LVO value to a label, and then
*----- bumps the LVO value by -6 in preparation for next LVO label

*----- This assigns the value -30 to our first _LVO label

             LIBDEF      _LVORGBtoHSL     ;-30
             XDEF        _LVORGBtoHSL

*----- The value -30-6 is asigned to our second _LVO label

             LIBDEF      _LVOGetFreePen   ;-36
             XDEF        _LVOGetFreePen

             LIBDEF      _LVOGetClosestPen
             XDEF        _LVOGetClosestPen

             LIBDEF      _LVOLook4Color
             XDEF        _LVOLook4Color

             LIBDEF      _LVOGetBestPen
             XDEF        _LVOGetBestPen

             LIBDEF      _LVOAllocGRPort
             XDEF        _LVOAllocGRPort

             LIBDEF      _LVOFreeGRPort
             XDEF        _LVOFreeGRPort

         LIBDEF     _LVOGetPenInfo
         XDEF     _LVOGetPenInfo

         LIBDEF     _LVOFreePenInfo
         XDEF     _LVOFreePenInfo

         LIBDEF     _LVOCModulo
         XDEF     _LVOCModulo

         LIBDEF     _LVOCAlpha
         XDEF     _LVOCAlpha

             LIBDEF      _LVOGE_AVLMax
             XDEF        _LVOGE_AVLMax

             LIBDEF      _LVOGE_AVLMin
             XDEF        _LVOGE_AVLMin

             LIBDEF      _LVOGE_AVLFind
             XDEF        _LVOGE_AVLFind

             LIBDEF      _LVOGE_AVLRLeft
             XDEF        _LVOGE_AVLRLeft

             LIBDEF      _LVOGE_AVLRRight
             XDEF        _LVOGE_AVLRRight

             LIBDEF      _LVOGE_AVLRLeftR
             XDEF        _LVOGE_AVLRLeftR

             LIBDEF      _LVOGE_AVLRRightL
             XDEF        _LVOGE_AVLRRightL

             LIBDEF      _LVOGE_AVLInsert
             XDEF        _LVOGE_AVLInsert

             LIBDEF      _LVOGE_AVLRemove
             XDEF        _LVOGE_AVLRemove

             LIBDEF      _LVONil
             XDEF        _LVONil

             LIBDEF      _LVOGE_NewMemPool
             XDEF        _LVOGE_NewMemPool

             LIBDEF      _LVOGE_PoolAlloc
             XDEF        _LVOGE_PoolAlloc

             LIBDEF      _LVOGE_PoolDealloc
             XDEF        _LVOGE_PoolDealloc

             LIBDEF      _LVOGE_FreeMemPool
             XDEF        _LVOGE_FreeMemPool

             LIBDEF      _LVONil2
             XDEF        _LVONil2

             LIBDEF      _LVOGE_MakeClass
             XDEF        _LVOGE_MakeClass

             LIBDEF      _LVOGE_FreeClass
             XDEF        _LVOGE_FreeClass

             LIBDEF      _LVOGE_AddClass
             XDEF        _LVOGE_AddClass

             LIBDEF      _LVOGE_RemoveClass
             XDEF        _LVOGE_RemoveClass

             LIBDEF      _LVOGE_IsObject
             XDEF        _LVOGE_IsObject

             LIBDEF      _LVOGE_NextTagItem
             XDEF        _LVOGE_NextTagItem

             LIBDEF      _LVOGE_GetTagData
             XDEF        _LVOGE_GetTagData
          section CODE

*------ Caller declares and initializes GEngineBase in their Pascal code

            XREF        _GEngineBase

*------ Make C function stubs available to caller

            XDEF        _RGBtoHSL
            XDEF        _GetFreePen
            XDEF        _GetClosestPen
            XDEF        _Look4Color
            XDEF    _GetBestPen
            XDEF        _AllocGRPort
            XDEF        _FreeGRPort
        XDEF    _GetPenInfo
        XDEF    _FreePenInfo
        XDEF    _CModulo
        XDEF    _CAlpha
            XDEF        _GE_AVLMax
            XDEF        _GE_AVLMin
            XDEF        _GE_AVLFind
          XDEF        _GE_AVLRLeft
            XDEF        _GE_AVLRRight
            XDEF        _GE_AVLRLeftR
            XDEF        _GE_AVLRRightL
            XDEF        _GE_AVLInsert
            XDEF        _GE_AVLRemove
            XDEF        _GE_NewMemPool
            XDEF        _GE_PoolAlloc
            XDEF        _GE_PoolDealloc
            XDEF        _GE_FreeMemPool
            XDEF        _GE_MakeClass
            XDEF        _GE_FreeClass
            XDEF        _GE_AddClass
            XDEF        _GE_RemoveClass
            XDEF        _GE_IsObject
            XDEF        _GE_NextTagItem
            XDEF        _GE_GetTagData

*------- These stubs move Pascal args from stack to appropriate registers,
*------- call the library function, and return result in d0

_RGBtoHSL:
            MOVEM.L     d1-d2/A6/A0-A2,-(SP)     ;Save register(s)
            MOVE.L      28(SP),A2           ;Copy param to register
            MOVE.L      32(SP),A1
            MOVE.L      36(SP),A0
            MOVE.L      40(SP),D2
            MOVE.L      44(SP),D1
            MOVE.L      48(SP),D0
            MOVE.L      _GEngineBase,A6    ;Library base to A6
            JSR         _LVORGBtoHSL(A6)   ;Go to real routine
            MOVEM.L      (SP)+,d1-d2/A6/A0-A2    ;Restore register(s)
            RTS

_GetFreePen:
            MOVEM.L     A6/A0,-(SP)           ;Save register(s)
            MOVE.L      12(SP),A0        ;Copy params to registers
            MOVE.L      _GEngineBase,A6     ;Library base to A6
            JSR         _LVOGetFreePen(A6)   ;Go to real routine
            MOVEM.L     (SP)+,A6/A0           ;Restore register(s)
            RTS

_GetClosestPen:
            MOVEM.L     A6/A0/d1/d2,-(SP)
            move.w      20(sp),d2
            move.w      24(sp),d1
            move.w      28(sp),d0
            move.l      32(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGetClosestPen(a6)
            movem.l     (sp)+,a6/a0/d1/d2
            rts

_Look4Color:
            movem.l     a6/a0/d1/d2,-(sp)
            move.l      32(sp),a0
            move.l      28(sp),d0
            move.l      24(sp),d1
            move.l      20(sp),d2
            move.l      _GEngineBase,a6
            jsr         _LVOLook4Color(a6)
            movem.l     (sp)+,a6/a0/d1/d2
            rts

_GetBestPen:
            MOVEM.L     A6/A0/d1/d2,-(SP)
            move.l      20(sp),d2
            move.l      24(sp),d1
            move.l      28(sp),d0
            move.l      32(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGetBestPen(a6)
            movem.l     (sp)+,a6/a0/d1/d2
            rts

_AllocGRPort:
            movem.l     a6/d1-d2,-(sp)
            move.w    20(sp),d0
            move.w      18(sp),d1
            move.w      16(sp),d2
            move.l      _GEngineBase,a6
            jsr         _LVOAllocGRPort(a6)
            movem.l     (sp)+,a6/d1-d2
            rts

_FreeGRPort:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOFreeGRPort(a6)
            movem.l     (sp)+,a0/a6
            rts

_GetPenInfo:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGetPenInfo(a6)
            movem.l     (sp)+,a0/a6
            rts

_FreePenInfo:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOFreePenInfo(a6)
            movem.l     (sp)+,a0/a6
            rts

_CModulo:
            movem.l     d1/a6,-(sp)
            move.l      12(sp),d1
            move.l      16(sp),d0
            move.l      _GEngineBase,a6
            jsr         _LVOCModulo(a6)
            movem.l     (sp)+,d1/a6
            rts

_CAlpha:
            movem.l     d1/a6,-(sp)
            move.l      12(sp),d1
            move.l      16(sp),d0
            move.l      _GEngineBase,a6
            jsr         _LVOCAlpha(a6)
            movem.l     (sp)+,d1/a6
            rts

_GE_AVLMax:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGE_AVLMax(a6)
            movem.l     (sp)+,a0/a6
            rts

_GE_AVLMin:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGE_AVLMin(a6)
            movem.l     (sp)+,a0/a6
            rts

_GE_AVLFind:
            movem.l    a0-a1/a6,-(sp)
            move.l     24(sp),a0
            move.l     20(sp),d0
            move.l     16(sp),a1
            move.l     _GEngineBase,a6
            jsr        _LVOGE_AVLFind(a6)
            movem.l    (sp)+,a0-a1/a6
            rts

_GE_AVLRLeft:
            movem.l     a0-a1/a6,-(sp)
            move.l      20(sp),a0
            move.l      16(sp),a1
            move.l      _GEngineBase,a6
            jsr         _LVOGE_AVLRLeft(a6)
            movem.l     (sp)+,a0-a1/a6
            rts

_GE_AVLRRight:
            movem.l     a0-a1/a6,-(sp)
            move.l      20(sp),a0
            move.l      16(sp),a1
            move.l      _GEngineBase,a6
            jsr         _LVOGE_AVLRRight(a6)
            movem.l     (sp)+,a0-a1/a6
            rts

_GE_AVLRLeftR:
            movem.l     a0-a1/a6,-(sp)
            move.l      20(sp),a0
            move.l      16(sp),a1
            move.l      _GEngineBase,a6
            jsr         _LVOGE_AVLRLeftR(a6)
            movem.l     (sp)+,a0-a1/a6
            rts

_GE_AVLRRightL:
            movem.l     a0-a1/a6,-(sp)
            move.l      20(sp),a0
            move.l      16(sp),a1
            move.l      _GEngineBase,a6
            jsr         _LVOGE_AVLRRightL(a6)
            movem.l     (sp)+,a0-a1/a6
            rts

_GE_AVLInsert:
            movem.l    a0-a1/a6,-(sp)
            move.l     24(sp),a0
            move.l     20(sp),d0
            move.l     16(sp),a1
            move.l     _GEngineBase,a6
            jsr        _LVOGE_AVLInsert(a6)
            movem.l    (sp)+,a0-a1/a6
            rts

_GE_AVLRemove:
            movem.l    a0-a1/a6,-(sp)
            move.l     24(sp),a0
            move.l     20(sp),d0
            move.l     16(sp),a1
            move.l     _GEngineBase,a6
            jsr        _LVOGE_AVLRemove(a6)
            movem.l    (sp)+,a0-a1/a6
            rts

_GE_NewMemPool:
            movem.l    d1-d2/a6,-(sp)
            move.l     22(sp),d0
            move.l     18(sp),d1
            move.w     16(sp),d2
            move.l     _GEngineBase,a6
            jsr        _LVOGE_NewMemPool(a6)
            movem.l    (sp)+,d1-d2/a6
            rts

_GE_PoolAlloc:
            movem.l    a0/a6,-(sp)
            move.l     16(sp),a0
            move.l     12(sp),d0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_PoolAlloc(a6)
            movem.l    (sp)+,a0/a6
            rts

_GE_PoolDealloc:
            movem.l    a0-a1/a6,-(sp)
            move.l     24(sp),a0
            move.l     20(sp),a1
            move.l     16(sp),d0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_PoolDealloc(a6)
            movem.l    (sp)+,a0-a1/a6
            rts

_GE_FreeMemPool:
            movem.l    a0/a6,-(sp)
        move.l     12(sp),a0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_FreeMemPool(a6)
            movem.l    (sp)+,a0/a6
            rts

_GE_MakeClass:
            movem.l    a0-a2/a6/d1,-(sp)
            move.l     38(sp),a0
            move.l     34(sp),a1
            move.l     30(sp),a2
            move.w     28(sp),d0
            move.l     24(sp),d1
            move.l     _GEngineBase,a6
            jsr        _LVOGE_MakeClass(a6)
            movem.l    (sp)+,a0-a2/a6/d1
            rts

_GE_FreeClass:
            movem.l    a0/a6,-(sp)
        move.l     12(sp),a0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_FreeClass(a6)
            movem.l    (sp)+,a0/a6
            rts

_GE_AddClass:
            movem.l    a0/a6,-(sp)
        move.l     12(sp),a0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_AddClass(a6)
            movem.l    (sp)+,a0/a6
            rts

_GE_RemoveClass:
            movem.l    a0/a6,-(sp)
        move.l     12(sp),a0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_RemoveClass(a6)
            movem.l    (sp)+,a0/a6
            rts

_GE_IsObject:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGE_IsObject(a6)
            movem.l     (sp)+,a0/a6
            rts

_GE_NextTagItem:
            movem.l     a0/a6,-(sp)
            move.l      12(sp),a0
            move.l      _GEngineBase,a6
            jsr         _LVOGE_NextTagItem(a6)
            movem.l     (sp)+,a0/a6
            rts

_GE_GetTagData:
            movem.l    d1/a0/a6,-(sp)
            move.l     24(sp),d0
            move.l     20(sp),d1
            move.l     16(sp),a0
            move.l     _GEngineBase,a6
            jsr        _LVOGE_GetTagData(a6)
            movem.l    (sp)+,d1/a0/a6
            rts

          END
