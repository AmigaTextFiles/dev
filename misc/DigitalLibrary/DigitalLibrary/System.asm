 ; ##########################################################################
 ; ####                                                                  ####
 ; ####     DigitalLibrary - An Amiga library for memory allocation      ####
 ; ####    =========================================================     ####
 ; ####                                                                  ####
 ; #### DigitalLib.asm                                                   ####
 ; ####                                                                  ####
 ; #### Version 1.00  --  October 06, 2000                               ####
 ; ####                                                                  ####
 ; #### Copyright (C) 1992  Thomas Dreibholz                             ####
 ; ####                     Molbachweg 7                                 ####
 ; ####                     51674 Wiehl/Germany                          ####
 ; ####                     EMail: Dreibholz@bigfoot.com                 ####
 ; ####                     WWW:   http://www.bigfoot.com/~dreibholz     ####
 ; ####                                                                  ####
 ; ##########################################################################

 ; ***************************************************************************
 ; *                                                                         *
 ; *   This program is free software; you can redistribute it and/or modify  *
 ; *   it under the terms of the GNU General Public License as published by  *
 ; *   the Free Software Foundation; either version 2 of the License, or     *
 ; *   (at your option) any later version.                                   *
 ; *                                                                         *
 ; ***************************************************************************


   XDEF _SysBase
_SysBase: EQU $4
   XDEF _LVOSupervisor
_LVOSupervisor: EQU -30
   XDEF _Supervisor
_Supervisor:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -30(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOExitIntr
_LVOExitIntr: EQU -36
   XDEF _ExitIntr
_ExitIntr:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -36(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSchedule
_LVOSchedule: EQU -42
   XDEF _Schedule
_Schedule:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -42(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOReschedule
_LVOReschedule: EQU -48
   XDEF _Reschedule
_Reschedule:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -48(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSwitch
_LVOSwitch: EQU -54
   XDEF _Switch
_Switch:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -54(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVODispatch
_LVODispatch: EQU -60
   XDEF _Dispatch
_Dispatch:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -60(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOException
_LVOException: EQU -66
   XDEF _Exception
_Exception:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -66(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOInitCode
_LVOInitCode: EQU -72
   XDEF _InitCode
_InitCode:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _SysBase,A6
   JSR -72(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOInitStruct
_LVOInitStruct: EQU -78
   XDEF _InitStruct
_InitStruct:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),A2
   MOVE.L 16(SP),D0
   MOVE.L _SysBase,A6
   JSR -78(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOMakeLibrary
_LVOMakeLibrary: EQU -84
   XDEF _MakeLibrary
_MakeLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),A2
   MOVE.L 20(SP),D0
   MOVE.L 24(SP),D1
   MOVE.L _SysBase,A6
   JSR -84(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOMakeFunctions
_LVOMakeFunctions: EQU -90
   XDEF _MakeFunctions
_MakeFunctions:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),A2
   MOVE.L _SysBase,A6
   JSR -90(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFindResident
_LVOFindResident: EQU -96
   XDEF _FindResident
_FindResident:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -96(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOInitResident
_LVOInitResident: EQU -102
   XDEF _InitResident
_InitResident:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D1
   MOVE.L _SysBase,A6
   JSR -102(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAlert
_LVOAlert: EQU -108
   XDEF _Alert
_Alert:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D7
   MOVE.L 12(SP),A5
   MOVE.L _SysBase,A6
   JSR -108(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVODebug
_LVODebug: EQU -114
   XDEF _Debug
_Debug:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -114(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVODisable
_LVODisable: EQU -120
   XDEF _Disable
_Disable:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -120(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOEnable
_LVOEnable: EQU -126
   XDEF _Enable
_Enable:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -126(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOForbid
_LVOForbid: EQU -132
   XDEF _Forbid
_Forbid:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -132(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOPermit
_LVOPermit: EQU -138
   XDEF _Permit
_Permit:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -138(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetSR
_LVOSetSR: EQU -144
   XDEF _SetSR
_SetSR:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _SysBase,A6
   JSR -144(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSuperState
_LVOSuperState: EQU -150
   XDEF _SuperState
_SuperState:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -150(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOUserState
_LVOUserState: EQU -156
   XDEF _UserState
_UserState:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -156(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetIntVector
_LVOSetIntVector: EQU -162
   XDEF _SetIntVector
_SetIntVector:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -162(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddIntServer
_LVOAddIntServer: EQU -168
   XDEF _AddIntServer
_AddIntServer:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -168(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemIntServer
_LVORemIntServer: EQU -174
   XDEF _RemIntServer
_RemIntServer:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -174(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCause
_LVOCause: EQU -180
   XDEF _Cause
_Cause:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -180(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocate
_LVOAllocate: EQU -186
   XDEF _Allocate
_Allocate:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),D0
   MOVE.L _SysBase,A6
   JSR -186(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVODeallocate
_LVODeallocate: EQU -192
   XDEF _Deallocate
_Deallocate:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),D0
   MOVE.L _SysBase,A6
   JSR -192(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocMem
_LVOAllocMem: EQU -198
   XDEF _AllocMem
_AllocMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _SysBase,A6
   JSR -198(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocAbs
_LVOAllocAbs: EQU -204
   XDEF _AllocAbs
_AllocAbs:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -204(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeMem
_LVOFreeMem: EQU -210
   XDEF _FreeMem
_FreeMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D0
   MOVE.L _SysBase,A6
   JSR -210(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAvailMem
_LVOAvailMem: EQU -216
   XDEF _AvailMem
_AvailMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D1
   MOVE.L _SysBase,A6
   JSR -216(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocEntry
_LVOAllocEntry: EQU -222
   XDEF _AllocEntry
_AllocEntry:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -222(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeEntry
_LVOFreeEntry: EQU -228
   XDEF _FreeEntry
_FreeEntry:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -228(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOInsert
_LVOInsert: EQU -234
   XDEF _Insert
_Insert:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),A2
   MOVE.L _SysBase,A6
   JSR -234(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddHead
_LVOAddHead: EQU -240
   XDEF _AddHead
_AddHead:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -240(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddTail
_LVOAddTail: EQU -246
   XDEF _AddTail
_AddTail:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -246(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemove
_LVORemove: EQU -252
   XDEF _Remove
_Remove:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -252(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemHead
_LVORemHead: EQU -258
   XDEF _RemHead
_RemHead:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -258(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemTail
_LVORemTail: EQU -264
   XDEF _RemTail
_RemTail:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -264(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOEnqueue
_LVOEnqueue: EQU -270
   XDEF _Enqueue
_Enqueue:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -270(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFindName
_LVOFindName: EQU -276
   XDEF _FindName
_FindName:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -276(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddTask
_LVOAddTask: EQU -282
   XDEF _AddTask
_AddTask:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),A2
   MOVE.L 16(SP),A3
   MOVE.L _SysBase,A6
   JSR -282(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemTask
_LVORemTask: EQU -288
   XDEF _RemTask
_RemTask:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -288(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFindTask
_LVOFindTask: EQU -294
   XDEF _FindTask
_FindTask:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -294(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetTaskPri
_LVOSetTaskPri: EQU -300
   XDEF _SetTaskPri
_SetTaskPri:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D0
   MOVE.L _SysBase,A6
   JSR -300(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetSignal
_LVOSetSignal: EQU -306
   XDEF _SetSignal
_SetSignal:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _SysBase,A6
   JSR -306(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetExcept
_LVOSetExcept: EQU -312
   XDEF _SetExcept
_SetExcept:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _SysBase,A6
   JSR -312(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOWait
_LVOWait: EQU -318
   XDEF _Wait
_Wait:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -318(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSignal
_LVOSignal: EQU -324
   XDEF _Signal
_Signal:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D0
   MOVE.L _SysBase,A6
   JSR -324(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocSignal
_LVOAllocSignal: EQU -330
   XDEF _AllocSignal
_AllocSignal:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -330(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeSignal
_LVOFreeSignal: EQU -336
   XDEF _FreeSignal
_FreeSignal:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -336(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocTrap
_LVOAllocTrap: EQU -342
   XDEF _AllocTrap
_AllocTrap:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -342(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeTrap
_LVOFreeTrap: EQU -348
   XDEF _FreeTrap
_FreeTrap:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -348(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddPort
_LVOAddPort: EQU -354
   XDEF _AddPort
_AddPort:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -354(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemPort
_LVORemPort: EQU -360
   XDEF _RemPort
_RemPort:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -360(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOPutMsg
_LVOPutMsg: EQU -366
   XDEF _PutMsg
_PutMsg:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -366(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetMsg
_LVOGetMsg: EQU -372
   XDEF _GetMsg
_GetMsg:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -372(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOReplyMsg
_LVOReplyMsg: EQU -378
   XDEF _ReplyMsg
_ReplyMsg:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -378(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOWaitPort
_LVOWaitPort: EQU -384
   XDEF _WaitPort
_WaitPort:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -384(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFindPort
_LVOFindPort: EQU -390
   XDEF _FindPort
_FindPort:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -390(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddLibrary
_LVOAddLibrary: EQU -396
   XDEF _AddLibrary
_AddLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -396(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemLibrary
_LVORemLibrary: EQU -402
   XDEF _RemLibrary
_RemLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -402(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOOldOpenLibrary
_LVOOldOpenLibrary: EQU -408
   XDEF _OldOpenLibrary
_OldOpenLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -408(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCloseLibrary
_LVOCloseLibrary: EQU -414
   XDEF _CloseLibrary
_CloseLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -414(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSetFunction
_LVOSetFunction: EQU -420
   XDEF _SetFunction
_SetFunction:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),A0
   MOVE.L 16(SP),D0
   MOVE.L _SysBase,A6
   JSR -420(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSumLibrary
_LVOSumLibrary: EQU -426
   XDEF _SumLibrary
_SumLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -426(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddDevice
_LVOAddDevice: EQU -432
   XDEF _AddDevice
_AddDevice:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -432(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemDevice
_LVORemDevice: EQU -438
   XDEF _RemDevice
_RemDevice:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -438(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOOpenDevice
_LVOOpenDevice: EQU -444
   XDEF _OpenDevice
_OpenDevice:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),D0
   MOVE.L 16(SP),A1
   MOVE.L 20(SP),D1
   MOVE.L _SysBase,A6
   JSR -444(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCloseDevice
_LVOCloseDevice: EQU -450
   XDEF _CloseDevice
_CloseDevice:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -450(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVODoIO
_LVODoIO: EQU -456
   XDEF _DoIO
_DoIO:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -456(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSendIO
_LVOSendIO: EQU -462
   XDEF _SendIO
_SendIO:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -462(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCheckIO
_LVOCheckIO: EQU -468
   XDEF _CheckIO
_CheckIO:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -468(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOWaitIO
_LVOWaitIO: EQU -474
   XDEF _WaitIO
_WaitIO:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -474(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAbortIO
_LVOAbortIO: EQU -480
   XDEF _AbortIO
_AbortIO:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -480(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddResource
_LVOAddResource: EQU -486
   XDEF _AddResource
_AddResource:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -486(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemResource
_LVORemResource: EQU -492
   XDEF _RemResource
_RemResource:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -492(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOOpenResource
_LVOOpenResource: EQU -498
   XDEF _OpenResource
_OpenResource:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D0
   MOVE.L _SysBase,A6
   JSR -498(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORawIOInit
_LVORawIOInit: EQU -504
   XDEF _RawIOInit
_RawIOInit:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -504(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORawMayGetChar
_LVORawMayGetChar: EQU -510
   XDEF _RawMayGetChar
_RawMayGetChar:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -510(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORawPutChar
_LVORawPutChar: EQU -516
   XDEF _RawPutChar
_RawPutChar:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _SysBase,A6
   JSR -516(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORawDoFmt
_LVORawDoFmt: EQU -522
   XDEF _RawDoFmt
_RawDoFmt:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),A2
   MOVE.L 20(SP),A3
   MOVE.L _SysBase,A6
   JSR -522(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOGetCC
_LVOGetCC: EQU -528
   XDEF _GetCC
_GetCC:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -528(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOTypeOfMem
_LVOTypeOfMem: EQU -534
   XDEF _TypeOfMem
_TypeOfMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -534(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOProcure
_LVOProcure: EQU -540
   XDEF _Procure
_Procure:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L _SysBase,A6
   JSR -540(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOVacate
_LVOVacate: EQU -546
   XDEF _Vacate
_Vacate:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -546(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOOpenLibrary
_LVOOpenLibrary: EQU -552
   XDEF _OpenLibrary
_OpenLibrary:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L 12(SP),D0
   MOVE.L _SysBase,A6
   JSR -552(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOInitSemaphore
_LVOInitSemaphore: EQU -558
   XDEF _InitSemaphore
_InitSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -558(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOObtainSemaphore
_LVOObtainSemaphore: EQU -564
   XDEF _ObtainSemaphore
_ObtainSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -564(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOReleaseSemaphore
_LVOReleaseSemaphore: EQU -570
   XDEF _ReleaseSemaphore
_ReleaseSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -570(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAttemptSemaphore
_LVOAttemptSemaphore: EQU -576
   XDEF _AttemptSemaphore
_AttemptSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -576(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOObtainSemaphoreList
_LVOObtainSemaphoreList: EQU -582
   XDEF _ObtainSemaphoreList
_ObtainSemaphoreList:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -582(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOReleaseSemaphoreList
_LVOReleaseSemaphoreList: EQU -588
   XDEF _ReleaseSemaphoreList
_ReleaseSemaphoreList:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _SysBase,A6
   JSR -588(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFindSemaphore
_LVOFindSemaphore: EQU -594
   XDEF _FindSemaphore
_FindSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -594(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddSemaphore
_LVOAddSemaphore: EQU -600
   XDEF _AddSemaphore
_AddSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -600(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORemSemaphore
_LVORemSemaphore: EQU -606
   XDEF _RemSemaphore
_RemSemaphore:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A1
   MOVE.L _SysBase,A6
   JSR -606(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOSumKickData
_LVOSumKickData: EQU -612
   XDEF _SumKickData
_SumKickData:
   MOVE.L A6,-(SP)
   MOVE.L _SysBase,A6
   JSR -612(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAddMemList
_LVOAddMemList: EQU -618
   XDEF _AddMemList
_AddMemList:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L 16(SP),D2
   MOVE.L 20(SP),A0
   MOVE.L 24(SP),A1
   MOVE.L _SysBase,A6
   JSR -618(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCopyMem
_LVOCopyMem: EQU -624
   XDEF _CopyMem
_CopyMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),D0
   MOVE.L _SysBase,A6
   JSR -624(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCopyMemQuick
_LVOCopyMemQuick: EQU -630
   XDEF _CopyMemQuick
_CopyMemQuick:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),A1
   MOVE.L 16(SP),D0
   MOVE.L _SysBase,A6
   JSR -630(A6)
   MOVE.L (SP)+,A6
   RTS
 END

