   XREF _MultiDesktopBase
   XDEF _LVOOldError
_LVOOldError: EQU -30
   XDEF _OldError
_OldError:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -30(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOGetLStr
_LVOGetLStr: EQU -36
   XDEF _GetLStr
_GetLStr:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),D0
   MOVE.L 60(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -36(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOErrorL
_LVOErrorL: EQU -42
   XDEF _ErrorL
_ErrorL:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),D0
   MOVE.L 60(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -42(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOMultiRequestA
_LVOMultiRequestA: EQU -48
   XDEF _MultiRequestA
_MultiRequestA:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),A1
   MOVE.L 64(SP),A2
   MOVE.L _MultiDesktopBase,A6
   JSR -48(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOSleepPointer
_LVOSleepPointer: EQU -54
   XDEF _SleepPointer
_SleepPointer:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -54(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOSyncRun
_LVOSyncRun: EQU -60
   XDEF _SyncRun
_SyncRun:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -60(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOASyncRun
_LVOASyncRun: EQU -66
   XDEF _ASyncRun
_ASyncRun:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -66(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCreateNewTask
_LVOCreateNewTask: EQU -72
   XDEF _CreateNewTask
_CreateNewTask:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L 64(SP),A1
   MOVE.L 68(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JSR -72(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCreateNewProcess
_LVOCreateNewProcess: EQU -78
   XDEF _CreateNewProcess
_CreateNewProcess:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L 64(SP),A1
   MOVE.L 68(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JSR -78(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCreateStdIO
_LVOCreateStdIO: EQU -84
   XDEF _CreateStdIO
_CreateStdIO:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -84(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVODeleteStdIO
_LVODeleteStdIO: EQU -90
   XDEF _DeleteStdIO
_DeleteStdIO:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -90(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCreateExtIO
_LVOCreateExtIO: EQU -96
   XDEF _CreateExtIO
_CreateExtIO:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -96(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVODeleteExtIO
_LVODeleteExtIO: EQU -102
   XDEF _DeleteExtIO
_DeleteExtIO:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -102(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCreatePort
_LVOCreatePort: EQU -108
   XDEF _CreatePort
_CreatePort:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -108(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVODeletePort
_LVODeletePort: EQU -114
   XDEF _DeletePort
_DeletePort:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -114(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOThisTask
_LVOThisTask: EQU -120
   XDEF _ThisTask
_ThisTask:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L _MultiDesktopBase,A6
   JSR -120(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOThisUser
_LVOThisUser: EQU -126
   XDEF _ThisUser
_ThisUser:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L _MultiDesktopBase,A6
   JSR -126(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOGetMem
_LVOGetMem: EQU -132
   XDEF _GetMem
_GetMem:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),D0
   MOVE.L 60(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JSR -132(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVODisposeMem
_LVODisposeMem: EQU -138
   XDEF _DisposeMem
_DisposeMem:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -138(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOAllocMemory
_LVOAllocMemory: EQU -144
   XDEF _AllocMemory
_AllocMemory:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L 64(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JSR -144(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOFreeMemory
_LVOFreeMemory: EQU -150
   XDEF _FreeMemory
_FreeMemory:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -150(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOFreeMemoryBlock
_LVOFreeMemoryBlock: EQU -156
   XDEF _FreeMemoryBlock
_FreeMemoryBlock:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JSR -156(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOFindID
_LVOFindID: EQU -162
   XDEF _FindID
_FindID:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),A1
   MOVE.L 64(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -162(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVONewList
_LVONewList: EQU -168
   XDEF _NewList
_NewList:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -168(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOFindNode
_LVOFindNode: EQU -174
   XDEF _FindNode
_FindNode:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -174(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCountNodes
_LVOCountNodes: EQU -180
   XDEF _CountNodes
_CountNodes:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -180(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOSortList
_LVOSortList: EQU -186
   XDEF _SortList
_SortList:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -186(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOInsertSort
_LVOInsertSort: EQU -192
   XDEF _InsertSort
_InsertSort:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),A1
   MOVE.L 64(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -192(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVODupList
_LVODupList: EQU -198
   XDEF _DupList
_DupList:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JSR -198(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOConcatList
_LVOConcatList: EQU -204
   XDEF _ConcatList
_ConcatList:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JSR -204(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOCopyConcatList
_LVOCopyConcatList: EQU -210
   XDEF _CopyConcatList
_CopyConcatList:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L 60(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JSR -210(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
   XDEF _LVOFreeList
_LVOFreeList: EQU -216
   XDEF _FreeList
_FreeList:
   MOVEM.L D2-D7/A0-A6,-(SP)
   MOVE.L 56(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JSR -216(A6)
   MOVEM.L (SP)+,D2-D7/A0-A6
   RTS
 END

