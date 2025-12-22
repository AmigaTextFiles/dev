   XREF _MultiSystemBase
   XDEF _LVOGetCPUType
_LVOGetCPUType: EQU -30
   XDEF _GetCPUType
_GetCPUType:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -30(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetFPUType
_LVOGetFPUType: EQU -36
   XDEF _GetFPUType
_GetFPUType:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -36(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetMMUType
_LVOGetMMUType: EQU -42
   XDEF _GetMMUType
_GetMMUType:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -42(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetCACR
_LVOGetCACR: EQU -48
   XDEF _GetCACR
_GetCACR:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -48(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetCARC
_LVOSetCARC: EQU -54
   XDEF _SetCARC
_SetCARC:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -54(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetCRP
_LVOGetCRP: EQU -60
   XDEF _GetCRP
_GetCRP:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -60(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetCRP
_LVOSetCRP: EQU -66
   XDEF _SetCRP
_SetCRP:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -66(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetSRP
_LVOGetSRP: EQU -72
   XDEF _GetSRP
_GetSRP:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -72(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetSRP
_LVOSetSRP: EQU -78
   XDEF _SetSRP
_SetSRP:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -78(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetTC
_LVOGetTC: EQU -84
   XDEF _GetTC
_GetTC:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -84(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetTC
_LVOSetTC: EQU -90
   XDEF _SetTC
_SetTC:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -90(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetTT0
_LVOGetTT0: EQU -96
   XDEF _GetTT0
_GetTT0:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -96(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetTT0
_LVOSetTT0: EQU -102
   XDEF _SetTT0
_SetTT0:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -102(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetTT1
_LVOGetTT1: EQU -108
   XDEF _GetTT1
_GetTT1:
   MOVE.L A6,-(SP)
   MOVE.L _MultiSystemBase,A6
   JSR -108(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetTT1
_LVOSetTT1: EQU -114
   XDEF _SetTT1
_SetTT1:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _MultiSystemBase,A6
   JSR -114(A6)
   MOVE.L (SP)+,A6
   RTS
 END

