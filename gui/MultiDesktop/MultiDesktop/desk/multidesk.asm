   XREF _MultiDesktopBase
   XDEF _LVOInitDesktopUser
_LVOInitDesktopUser: EQU -30
   XDEF _InitDesktopUser
_InitDesktopUser:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -30(A6)
   XDEF _LVOTerminateDesktopUser
_LVOTerminateDesktopUser: EQU -36
   XDEF _TerminateDesktopUser
_TerminateDesktopUser:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -36(A6)
   XDEF _LVODesktopStartup
_LVODesktopStartup: EQU -42
   XDEF _DesktopStartup
_DesktopStartup:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -42(A6)
   XDEF _LVODesktopExit
_LVODesktopExit: EQU -48
   XDEF _DesktopExit
_DesktopExit:
   MOVE.L _MultiDesktopBase,A6
   JMP -48(A6)
   XDEF _LVOTerminateTask
_LVOTerminateTask: EQU -54
   XDEF _TerminateTask
_TerminateTask:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -54(A6)
   XDEF _LVOThisTask
_LVOThisTask: EQU -60
   XDEF _ThisTask
_ThisTask:
   MOVE.L _MultiDesktopBase,A6
   JMP -60(A6)
   XDEF _LVOThisUser
_LVOThisUser: EQU -66
   XDEF _ThisUser
_ThisUser:
   MOVE.L _MultiDesktopBase,A6
   JMP -66(A6)
   XDEF _LVOOldError
_LVOOldError: EQU -72
   XDEF _OldError
_OldError:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -72(A6)
   XDEF _LVOGetLStr
_LVOGetLStr: EQU -78
   XDEF _GetLStr
_GetLStr:
   MOVE.L 4(SP),D0
   MOVE.L 8(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -78(A6)
   XDEF _LVOGetTextID
_LVOGetTextID: EQU -84
   XDEF _GetTextID
_GetTextID:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -84(A6)
   XDEF _LVOFindID
_LVOFindID: EQU -90
   XDEF _FindID
_FindID:
   MOVE.L 4(SP),A1
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -90(A6)
   XDEF _LVOStrIsGreaterThan
_LVOStrIsGreaterThan: EQU -96
   XDEF _StrIsGreaterThan
_StrIsGreaterThan:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -96(A6)
   XDEF _LVOStrIsLessThan
_LVOStrIsLessThan: EQU -102
   XDEF _StrIsLessThan
_StrIsLessThan:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -102(A6)
   XDEF _LVOMultiRequest
_LVOMultiRequest: EQU -108
   XDEF _MultiRequest
_MultiRequest:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),A2
   MOVE.L _MultiDesktopBase,A6
   JMP -108(A6)
   XDEF _LVOOkayRequest
_LVOOkayRequest: EQU -114
   XDEF _OkayRequest
_OkayRequest:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -114(A6)
   XDEF _LVOErrorRequest
_LVOErrorRequest: EQU -120
   XDEF _ErrorRequest
_ErrorRequest:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),A2
   MOVE.L _MultiDesktopBase,A6
   JMP -120(A6)
   XDEF _LVOErrorL
_LVOErrorL: EQU -126
   XDEF _ErrorL
_ErrorL:
   MOVE.L 4(SP),D0
   MOVE.L 8(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -126(A6)
   XDEF _LVOSleepPointer
_LVOSleepPointer: EQU -132
   XDEF _SleepPointer
_SleepPointer:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -132(A6)
   XDEF _LVOSyncRun
_LVOSyncRun: EQU -138
   XDEF _SyncRun
_SyncRun:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -138(A6)
   XDEF _LVOASyncRun
_LVOASyncRun: EQU -144
   XDEF _ASyncRun
_ASyncRun:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -144(A6)
   XDEF _LVOCreateNewTask
_LVOCreateNewTask: EQU -150
   XDEF _CreateNewTask
_CreateNewTask:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JMP -150(A6)
   XDEF _LVOCreateNewProcess
_LVOCreateNewProcess: EQU -156
   XDEF _CreateNewProcess
_CreateNewProcess:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JMP -156(A6)
   XDEF _LVOCreateStdIO
_LVOCreateStdIO: EQU -162
   XDEF _CreateStdIO
_CreateStdIO:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -162(A6)
   XDEF _LVODeleteStdIO
_LVODeleteStdIO: EQU -168
   XDEF _DeleteStdIO
_DeleteStdIO:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -168(A6)
   XDEF _LVOCreateExtIO
_LVOCreateExtIO: EQU -174
   XDEF _CreateExtIO
_CreateExtIO:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -174(A6)
   XDEF _LVODeleteExtIO
_LVODeleteExtIO: EQU -180
   XDEF _DeleteExtIO
_DeleteExtIO:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -180(A6)
   XDEF _LVOCreatePort
_LVOCreatePort: EQU -186
   XDEF _CreatePort
_CreatePort:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -186(A6)
   XDEF _LVODeletePort
_LVODeletePort: EQU -192
   XDEF _DeletePort
_DeletePort:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -192(A6)
   XDEF _LVOGetMem
_LVOGetMem: EQU -198
   XDEF _GetMem
_GetMem:
   MOVE.L 4(SP),D0
   MOVE.L 8(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JMP -198(A6)
   XDEF _LVODisposeMem
_LVODisposeMem: EQU -204
   XDEF _DisposeMem
_DisposeMem:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -204(A6)
   XDEF _LVOAllocMemory
_LVOAllocMemory: EQU -210
   XDEF _AllocMemory
_AllocMemory:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _MultiDesktopBase,A6
   JMP -210(A6)
   XDEF _LVOAllocAlignedMemory
_LVOAllocAlignedMemory: EQU -216
   XDEF _AllocAlignedMemory
_AllocAlignedMemory:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L 16(SP),D2
   MOVE.L _MultiDesktopBase,A6
   JMP -216(A6)
   XDEF _LVOFreeMemory
_LVOFreeMemory: EQU -222
   XDEF _FreeMemory
_FreeMemory:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -222(A6)
   XDEF _LVOFreeMemoryBlock
_LVOFreeMemoryBlock: EQU -228
   XDEF _FreeMemoryBlock
_FreeMemoryBlock:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -228(A6)
   XDEF _LVOClearMem
_LVOClearMem: EQU -234
   XDEF _ClearMem
_ClearMem:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -234(A6)
   XDEF _LVOClearMemQuick
_LVOClearMemQuick: EQU -240
   XDEF _ClearMemQuick
_ClearMemQuick:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -240(A6)
   XDEF _LVONewList
_LVONewList: EQU -246
   XDEF _NewList
_NewList:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -246(A6)
   XDEF _LVOFindNode
_LVOFindNode: EQU -252
   XDEF _FindNode
_FindNode:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -252(A6)
   XDEF _LVOCountNodes
_LVOCountNodes: EQU -258
   XDEF _CountNodes
_CountNodes:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -258(A6)
   XDEF _LVOSortList
_LVOSortList: EQU -264
   XDEF _SortList
_SortList:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -264(A6)
   XDEF _LVOInsertSort
_LVOInsertSort: EQU -270
   XDEF _InsertSort
_InsertSort:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -270(A6)
   XDEF _LVODupList
_LVODupList: EQU -276
   XDEF _DupList
_DupList:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -276(A6)
   XDEF _LVOConcatList
_LVOConcatList: EQU -282
   XDEF _ConcatList
_ConcatList:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -282(A6)
   XDEF _LVOCopyConcatList
_LVOCopyConcatList: EQU -288
   XDEF _CopyConcatList
_CopyConcatList:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -288(A6)
   XDEF _LVOFreeList
_LVOFreeList: EQU -294
   XDEF _FreeList
_FreeList:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -294(A6)
   XDEF _LVOInitHook
_LVOInitHook: EQU -300
   XDEF _InitHook
_InitHook:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),A2
   MOVE.L _MultiDesktopBase,A6
   JMP -300(A6)
   XDEF _LVOOpenDevLibrary
_LVOOpenDevLibrary: EQU -306
   XDEF _OpenDevLibrary
_OpenDevLibrary:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -306(A6)
   XDEF _LVOCloseDevLibrary
_LVOCloseDevLibrary: EQU -312
   XDEF _CloseDevLibrary
_CloseDevLibrary:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -312(A6)
   XDEF _LVOGetFunction
_LVOGetFunction: EQU -318
   XDEF _GetFunction
_GetFunction:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -318(A6)
   XDEF _LVOTime2Seconds
_LVOTime2Seconds: EQU -324
   XDEF _Time2Seconds
_Time2Seconds:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -324(A6)
   XDEF _LVOSeconds2Time
_LVOSeconds2Time: EQU -330
   XDEF _Seconds2Time
_Seconds2Time:
   MOVE.L 4(SP),D0
   MOVE.L 8(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -330(A6)
   XDEF _LVOStarDate2Seconds
_LVOStarDate2Seconds: EQU -336
   XDEF _StarDate2Seconds
_StarDate2Seconds:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -336(A6)
   XDEF _LVOSeconds2StarDate
_LVOSeconds2StarDate: EQU -342
   XDEF _Seconds2StarDate
_Seconds2StarDate:
   MOVE.L 4(SP),D0
   MOVE.L 8(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -342(A6)
   XDEF _LVOGetTime
_LVOGetTime: EQU -348
   XDEF _GetTime
_GetTime:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -348(A6)
   XDEF _LVOSetTime
_LVOSetTime: EQU -354
   XDEF _SetTime
_SetTime:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -354(A6)
   XDEF _LVOGetBattClockTime
_LVOGetBattClockTime: EQU -360
   XDEF _GetBattClockTime
_GetBattClockTime:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -360(A6)
   XDEF _LVOSetBattClockTime
_LVOSetBattClockTime: EQU -366
   XDEF _SetBattClockTime
_SetBattClockTime:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -366(A6)
   XDEF _LVOAddTimes
_LVOAddTimes: EQU -372
   XDEF _AddTimes
_AddTimes:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -372(A6)
   XDEF _LVOSubTimes
_LVOSubTimes: EQU -378
   XDEF _SubTimes
_SubTimes:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -378(A6)
   XDEF _LVOCompareTimes
_LVOCompareTimes: EQU -384
   XDEF _CompareTimes
_CompareTimes:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -384(A6)
   XDEF _LVOWaitTime
_LVOWaitTime: EQU -390
   XDEF _WaitTime
_WaitTime:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -390(A6)
   XDEF _LVOSetAlarm
_LVOSetAlarm: EQU -396
   XDEF _SetAlarm
_SetAlarm:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -396(A6)
   XDEF _LVOCheckAlarm
_LVOCheckAlarm: EQU -402
   XDEF _CheckAlarm
_CheckAlarm:
   MOVE.L _MultiDesktopBase,A6
   JMP -402(A6)
   XDEF _LVOWaitAlarm
_LVOWaitAlarm: EQU -408
   XDEF _WaitAlarm
_WaitAlarm:
   MOVE.L _MultiDesktopBase,A6
   JMP -408(A6)
   XDEF _LVOAbortAlarm
_LVOAbortAlarm: EQU -414
   XDEF _AbortAlarm
_AbortAlarm:
   MOVE.L _MultiDesktopBase,A6
   JMP -414(A6)
   XDEF _LVOInitTime
_LVOInitTime: EQU -420
   XDEF _InitTime
_InitTime:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L 16(SP),D2
   MOVE.L 20(SP),D3
   MOVE.L 24(SP),D4
   MOVE.L 28(SP),D5
   MOVE.L _MultiDesktopBase,A6
   JMP -420(A6)
   XDEF _LVOGetError
_LVOGetError: EQU -426
   XDEF _GetError
_GetError:
   MOVE.L _MultiDesktopBase,A6
   JMP -426(A6)
   XDEF _LVOGetGuru
_LVOGetGuru: EQU -432
   XDEF _GetGuru
_GetGuru:
   MOVE.L _MultiDesktopBase,A6
   JMP -432(A6)
   XDEF _LVOSetError
_LVOSetError: EQU -438
   XDEF _SetError
_SetError:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -438(A6)
   XDEF _LVOSetGuru
_LVOSetGuru: EQU -444
   XDEF _SetGuru
_SetGuru:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -444(A6)
   XDEF _LVONoMemory
_LVONoMemory: EQU -450
   XDEF _NoMemory
_NoMemory:
   MOVE.L _MultiDesktopBase,A6
   JMP -450(A6)
   XDEF _LVOGetTermProcedure
_LVOGetTermProcedure: EQU -456
   XDEF _GetTermProcedure
_GetTermProcedure:
   MOVE.L _MultiDesktopBase,A6
   JMP -456(A6)
   XDEF _LVOGetSysTermProcedure
_LVOGetSysTermProcedure: EQU -462
   XDEF _GetSysTermProcedure
_GetSysTermProcedure:
   MOVE.L _MultiDesktopBase,A6
   JMP -462(A6)
   XDEF _LVOSetTermProcedure
_LVOSetTermProcedure: EQU -468
   XDEF _SetTermProcedure
_SetTermProcedure:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -468(A6)
   XDEF _LVOSetSysTermProcedure
_LVOSetSysTermProcedure: EQU -474
   XDEF _SetSysTermProcedure
_SetSysTermProcedure:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -474(A6)
   XDEF _LVOTerminate
_LVOTerminate: EQU -480
   XDEF _Terminate
_Terminate:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -480(A6)
   XDEF _LVOGuru
_LVOGuru: EQU -486
   XDEF _Guru
_Guru:
   MOVE.L _MultiDesktopBase,A6
   JMP -486(A6)
   XDEF _LVOTrap
_LVOTrap: EQU -492
   XDEF _Trap
_Trap:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -492(A6)
   XDEF _LVOHalt
_LVOHalt: EQU -498
   XDEF _Halt
_Halt:
   MOVE.L _MultiDesktopBase,A6
   JMP -498(A6)
   XDEF _LVOPause
_LVOPause: EQU -504
   XDEF _Pause
_Pause:
   MOVE.L _MultiDesktopBase,A6
   JMP -504(A6)
   XDEF _LVOBreakOn
_LVOBreakOn: EQU -510
   XDEF _BreakOn
_BreakOn:
   MOVE.L _MultiDesktopBase,A6
   JMP -510(A6)
   XDEF _LVOBreakOff
_LVOBreakOff: EQU -516
   XDEF _BreakOff
_BreakOff:
   MOVE.L _MultiDesktopBase,A6
   JMP -516(A6)
   XDEF _LVOAvailSignals
_LVOAvailSignals: EQU -522
   XDEF _AvailSignals
_AvailSignals:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -522(A6)
   XDEF _LVOAvailTraps
_LVOAvailTraps: EQU -528
   XDEF _AvailTraps
_AvailTraps:
   MOVE.L 4(SP),A0
   MOVE.L _MultiDesktopBase,A6
   JMP -528(A6)
   XDEF _LVOAvailChipMem
_LVOAvailChipMem: EQU -534
   XDEF _AvailChipMem
_AvailChipMem:
   MOVE.L _MultiDesktopBase,A6
   JMP -534(A6)
   XDEF _LVOAvailFastMem
_LVOAvailFastMem: EQU -540
   XDEF _AvailFastMem
_AvailFastMem:
   MOVE.L _MultiDesktopBase,A6
   JMP -540(A6)
   XDEF _LVOAvailVMem
_LVOAvailVMem: EQU -546
   XDEF _AvailVMem
_AvailVMem:
   MOVE.L _MultiDesktopBase,A6
   JMP -546(A6)
   XDEF _LVOAvailPublicMem
_LVOAvailPublicMem: EQU -552
   XDEF _AvailPublicMem
_AvailPublicMem:
   MOVE.L _MultiDesktopBase,A6
   JMP -552(A6)
   XDEF _LVOAvailMemory
_LVOAvailMemory: EQU -558
   XDEF _AvailMemory
_AvailMemory:
   MOVE.L _MultiDesktopBase,A6
   JMP -558(A6)
   XDEF _LVOCPointer
_LVOCPointer: EQU -564
   XDEF _CPointer
_CPointer:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -564(A6)
   XDEF _LVOBPointer
_LVOBPointer: EQU -570
   XDEF _BPointer
_BPointer:
   MOVE.L 4(SP),D0
   MOVE.L _MultiDesktopBase,A6
   JMP -570(A6)
   XDEF _LVOCString
_LVOCString: EQU -576
   XDEF _CString
_CString:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -576(A6)
   XDEF _LVOBString
_LVOBString: EQU -582
   XDEF _BString
_BString:
   MOVE.L 4(SP),A0
   MOVE.L 8(SP),A1
   MOVE.L _MultiDesktopBase,A6
   JMP -582(A6)
 END

