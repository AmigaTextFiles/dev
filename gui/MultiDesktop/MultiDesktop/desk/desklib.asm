 ; MultiDesktop-Library 10. April 1995

 include "exec/types.i"
 include "exec/initializers.i"
 include "exec/libraries.i"
 include "exec/lists.i"
 include "exec/nodes.i"
 include "exec/resident.i"
 include "exec/alerts.i"
 include "exec/memory.i"
 include "exec/tasks.i"
 include "exec/execbase.i"

 include "multidesktop.i"

CALLSYS  MACRO
 jsr _LVO%1(a6)
 endm

XLIB  MACRO
 xref _LVO%1
 endm

 XLIB FreeMem
 XLIB Remove
 XLIB CreateIORequest
 XLIB DeleteIORequest

 XREF _InitDesktopUser
 XREF _TerminateDesktopUser
 XREF _DesktopStartup
 XREF _DesktopExit
 XREF _TerminateTask

 XREF _OldError
 XREF _GetLStr
 XREF _ErrorL
 XREF _MultiRequest
 XREF _ErrorRequest
 XREF _OkayRequest

 XREF _SleepPointer
 XREF _SyncRun
 XREF _ASyncRun

 XREF _CreateTask
 XREF _CreateNewProcess
 XREF _CreatePort
 XREF _DeletePort

 XREF _GetMem
 XREF _DisposeMem

 XREF _AllocMemory
 XREF _AllocAlignedMemory
 XREF _FreeMemory
 XREF _FreeMemoryBlock

 XREF _FindID

 XREF _NewList
 XREF _FindNode
 XREF _CountNodes
 XREF _SortList
 XREF _InsertSort
 XREF _DupList
 XREF _ConcatList
 XREF _CopyConcatList
 XREF _FreeList
 XREF _StrIsGreaterThan
 XREF _StrIsLessThan

 XREF _InitHook
 XREF _GetTextID
 XREF _OpenDevLibrary
 XREF _CloseDevLibrary

 XREF _Time2Seconds
 XREF _Seconds2Time
 XREF _StarDate2Seconds
 XREF _Seconds2StarDate
 XREF _GetTime
 XREF _SetTime
 XREF _GetBattClockTime
 XREF _SetBattClockTime
 XREF _AddTimes
 XREF _SubTimes
 XREF _CompareTimes
 XREF _WaitTime
 XREF _SetAlarm
 XREF _CheckAlarm
 XREF _WaitAlarm
 XREF _AbortAlarm
 XREF _InitTime

 XREF _AvailSignals
 XREF _AvailTraps

 XREF _GetError
 XREF _GetGuru
 XREF _SetError
 XREF _SetGuru
 XREF _NoMemory
 XREF _GetTermProcedure
 XREF _GetSysTermProcedure
 XREF _SetTermProcedure
 XREF _SetSysTermProcedure
 XREF _Terminate
 XREF _Guru

 XREF _Halt
 XREF _Pause

 XREF _BreakOn
 XREF _BreakOff
 
 XREF _AvailChipMem
 XREF _AvailFastMem
 XREF _AvailVMem
 XREF _AvailPublicMem
 XREF _AvailMemory

 XREF _CString
 XREF _BString

 XREF _InitLib
 XREF _RemoveLib

Version   equ 38
Revision  equ 0
Pri       equ 5

Start:
 moveq #0,d0
 rts

Resident:
 dc.w RTC_MATCHWORD
 dc.l Resident
 dc.l EndCode
 dc.b RTF_AUTOINIT
 dc.b Version
 dc.b NT_LIBRARY
 dc.b Pri
 dc.l LibName
 dc.l idString
 dc.l Init

LibName:  dc.b 'multidesktop.library',0
verID:    dc.b '$VER: multidesktop.library 1.00 (Aug 21 1995) - Copyright (C) 1995 by Thomas Dreibholz',0
idString: dc.b 'multidesktop.library 38.00 (Aug 21 1995)',13,10,0

 even
 public _SleepPointerData
_SleepPointerData:
 dc.w   0,0
 dc.w  %0000011000000000,%0000011000000000
 dc.w  %0000111101000000,%0000111101000000
 dc.w  %0011111111100000,%0011111111100000
 dc.w  %0111111111100000,%0111111111100000
 dc.w  %0111111111110000,%0110000111110000
 dc.w  %0111111111111000,%0111101111111000
 dc.w  %1111111111111000,%1111011111111000
 dc.w  %0111111111111100,%0110000111111100
 dc.w  %0111111111111100,%0111111100001100
 dc.w  %0011111111111110,%0011111111011110
 dc.w  %0111111111111100,%0111111110111100
 dc.w  %0011111111111100,%0011111100001100
 dc.w  %0001111111111000,%0001111111111000
 dc.w  %0000011111110000,%0000011111110000
 dc.w  %0000000111000000,%0000000111000000
 dc.w  %0000011100000000,%0000011100000000
 dc.w  %0000111111000000,%0000111111000000
 dc.w  %0000011010000000,%0000011010000000
 dc.w  %0000000000000000,%0000000000000000
 dc.w  %0000000011000000,%0000000011000000
 dc.w  %0000000011100000,%0000000011100000
 dc.w  %0000000001000000,%0000000001000000
 dc.w  0,0
_SleepPointerEnd:
 public _SleepPointerSize
_SleepPointerSize:
 dc.l _SleepPointerEnd-_SleepPointerData
 even

EndCode:

Init:
 dc.l MultiDesktopLib_SIZEOF
 dc.l FuncTable
 dc.l DataTable
 dc.l InitRoutine

FuncTable:
 dc.l Open
 dc.l Close
 dc.l Expunge
 dc.l Null

 dc.l .InitDesktopUser
 dc.l .TerminateDesktopUser
 dc.l .DesktopStartup
 dc.l .DesktopExit
 dc.l .TerminateTask

 dc.l .ThisTask
 dc.l .ThisUser

 dc.l .OldError

 dc.l .GetLStr
 dc.l .GetTextID
 dc.l .FindID
 dc.l .StrIsGreaterThan
 dc.l .StrIsLessThan

 dc.l .MultiRequest
 dc.l .OkayRequest
 dc.l .ErrorRequest
 dc.l .ErrorL

 dc.l .SleepPointer
 dc.l .SyncRun
 dc.l .ASyncRun

 dc.l .CreateNewTask
 dc.l .CreateNewProcess
 dc.l .CreateStdIO
 dc.l .DeleteExtIO
 dc.l .CreateExtIO
 dc.l .DeleteExtIO
 dc.l .CreatePort
 dc.l .DeletePort

 dc.l .GetMem
 dc.l .DisposeMem

 dc.l .AllocMemory
 dc.l .AllocAlignedMemory
 dc.l .FreeMemory
 dc.l .FreeMemoryBlock
 dc.l .ClearMem
 dc.l .ClearMemQuick

 dc.l .NewList
 dc.l .FindNode
 dc.l .CountNodes
 dc.l .SortList
 dc.l .InsertSort
 dc.l .DupList
 dc.l .ConcatList
 dc.l .CopyConcatList
 dc.l .FreeList

 dc.l .InitHook
 dc.l .OpenDevLibrary
 dc.l .CloseDevLibrary
 dc.l .GetFunction

 dc.l .Time2Seconds
 dc.l .Seconds2Time
 dc.l .StarDate2Seconds
 dc.l .Seconds2StarDate
 dc.l .GetTime
 dc.l .SetTime
 dc.l .GetBattClockTime
 dc.l .SetBattClockTime
 dc.l .AddTimes
 dc.l .SubTimes
 dc.l .CompareTimes
 dc.l .WaitTime
 dc.l .SetAlarm
 dc.l .CheckAlarm
 dc.l .WaitAlarm
 dc.l .AbortAlarm
 dc.l .InitTime

 dc.l .GetError
 dc.l .GetGuru
 dc.l .SetError
 dc.l .SetGuru
 dc.l .NoMemory

 dc.l .GetTermProcedure
 dc.l .GetSysTermProcedure
 dc.l .SetTermProcedure
 dc.l .SetSysTermProcedure
 dc.l .Terminate
 dc.l .Guru
 dc.l _Trap
 dc.l .Halt
 dc.l .Pause

 dc.l .BreakOn
 dc.l .BreakOff

 dc.l .AvailSignals
 dc.l .AvailTraps

 dc.l .AvailChipMem
 dc.l .AvailFastMem
 dc.l .AvailVMem
 dc.l .AvailPublicMem
 dc.l .AvailMemory

 dc.l .CPointer
 dc.l .BPointer
 dc.l .CString
 dc.l .BString

 dc.l -1

DataTable:
 INITBYTE LH_TYPE,NT_LIBRARY
 INITLONG LN_NAME,LibName
 INITBYTE LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
 INITWORD LIB_VERSION,Version
 INITWORD LIB_REVISION,Revision
 INITLONG LIB_IDSTRING,idString
 dc.l 0

InitRoutine:
 move.l a5,-(a7)
 move.l d0,a5
 move.l a5,_MultiDesktopBase
 move.l a6,mdl_SysLib(a5)
 move.l a0,mdl_SegList(a5)
 move.l $4,_SysBase

 movem.l d1-d7/a0-a6,-(sp)
 jsr _InitLib(pc)
 movem.l (sp)+,d1-d7/a0-a6
 tst.l d0
 beq InitRoutine_end

 move.l a5,d0
InitRoutine_end:
 move.l (a7)+,a5
 rts

Open:
 movem.l d1-d7/a0-a6,-(sp)
 clr.l -(sp)
 jsr _InitDesktopUser(pc)
 addq.w #4,sp
 movem.l (sp)+,d1-d7/a0-a6
 tst.l d0
 beq Open_end

 addq.w #1,LIB_OPENCNT(a6)
 bclr #LIBB_DELEXP,mdl_Flags(a6)
 move.l a6,d0

Open_end:
 rts

Close:
 movem.l d1-d7/a0-a6,-(sp)
 clr.l -(sp)
 jsr _TerminateDesktopUser(pc)
 addq.w #4,sp
 movem.l (sp)+,d1-d7/a0-a6

 clr.l d0
 subq.w #1,LIB_OPENCNT(a6)
 bne.s 1$
 btst #LIBB_DELEXP,mdl_Flags(a5)
 beq.s 1$
 bsr Expunge
1$:
 rts

Expunge:
 ; Library aus dem Speicher entfernen

 movem.l d2/a5-a6,-(a7)
 move.l a6,a5
 move.l mdl_SysLib(a5),a6
 tst.w LIB_OPENCNT(a5)
 beq.s 1$
 bset #LIBB_DELEXP,mdl_Flags(a5)
 clr.l d0
 bra Expunge_end
1$:
 move.l mdl_SegList(a5),d2
 move.l a5,a1
 CALLSYS Remove
 clr.l d0

 movem.l d1-d7/a0-a6,-(sp)
 jsr _RemoveLib(pc)
 movem.l (sp)+,d1-d7/a0-a6

 move.l a5,a1
 move.w LIB_NEGSIZE(a5),d0
 sub.l d0,a1
 add.w LIB_POSSIZE(a5),d0
 CALLSYS FreeMem
 move.l d2,d0
Expunge_end:
 movem.l (a7)+,d2/a5-a6
 rts

Null:
 moveq #0,d0
 rts

 public _Trap
_Trap:
 move.l 4(sp),d0
 cmp.b #16,d0
 bge _Trap.end

 cmp.b #0,d0
 bne 1$
 trap #0
 jmp _Trap.end
1$:

 cmp.b #1,d0
 bne 2$
 trap #1
 jmp _Trap.end
2$:

 cmp.b #2,d0
 bne 3$
 trap #2
 jmp _Trap.end
3$:

 cmp.b #3,d0
 bne 4$
 trap #3
 jmp _Trap.end
4$:

 cmp.b #4,d0
 bne 5$
 trap #4
 jmp _Trap.end
5$:

 cmp.b #5,d0
 bne 6$
 trap #5
 jmp _Trap.end
6$:

 cmp.b #6,d0
 bne 7$
 trap #6
 jmp _Trap.end
7$:

 cmp.b #7,d0
 bne 8$
 trap #7
 jmp _Trap.end
8$:

 cmp.b #8,d0
 bne 9$
 trap #8
 jmp _Trap.end
9$:

 cmp.b #9,d0
 bne 10$
 trap #9
 jmp _Trap.end
10$:

 cmp.b #10,d0
 bne 11$
 trap #10
 jmp _Trap.end
11$:

 cmp.b #11,d0
 bne 12$
 trap #11
 jmp _Trap.end
12$:

 cmp.b #12,d0
 bne 13$
 trap #12
 jmp _Trap.end
13$:

 cmp.b #13,d0
 bne 14$
 trap #13
 jmp _Trap.end
14$:

 cmp.b #14,d0
 bne 15$
 trap #14
 jmp _Trap.end
15$:

 trap #15

_Trap.end
 rts

.InitDesktopUser:
 move.l a0,-(sp)
 jsr _InitDesktopUser(pc)
 addq.l #4,sp
 rts

.TerminateDesktopUser:
 move.l a0,-(sp)
 jsr _TerminateDesktopUser(pc)
 addq.l #4,sp
 rts

.DesktopStartup:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _DesktopStartup(pc)
 addq.l #8,sp
 rts

.DesktopExit:
 jmp _DesktopExit(pc)

.TerminateTask:
 move.l a0,-(sp)
 jsr _TerminateTask(pc)
 addq.l #4,sp
 rts

.OldError:
 move.l a0,-(sp)
 jsr _OldError(pc)
 addq.l #4,sp
 rts

.GetLStr:
 movem.l a0/d0,-(sp)
 jsr _GetLStr(pc)
 addq.l #8,sp
 rts

.ErrorL:
 movem.l a0/d0,-(sp)
 jsr _ErrorL(pc)
 addq.l #8,sp
 rts

.MultiRequest:
 movem.l a2/a1/a0,-(sp)
 jsr _MultiRequest(pc)
 lea 12(sp),sp
 rts

.ErrorRequest:
 movem.l a2/a1/a0,-(sp)
 jsr _ErrorRequest(pc)
 lea 12(sp),sp
 rts

.OkayRequest:
 move.l a0,-(sp)
 jsr _OkayRequest(pc)
 addq.l #4,sp
 rts

.SleepPointer:
 move.l a0,-(sp)
 jsr _SleepPointer(pc)
 addq.l #4,sp
 rts

.SyncRun:
 move.l a0,-(sp)
 jsr _SyncRun(pc)
 addq.l #4,sp
 rts

.ASyncRun:
 move.l a0,-(sp)
 jsr _ASyncRun(pc)
 addq.l #4,sp
 rts

.CreateNewTask:
 move.l a1,-(sp)
 move.l d1,-(sp)
 move.l a0,-(sp)
 move.l d0,-(sp)
 jsr _CreateTask(pc)
 lea 16(sp),sp
 rts

.CreateNewProcess:
 move.l d1,-(sp)
 move.l a1,-(sp)
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _CreateNewProcess(pc)
 lea 16(sp),sp
 rts

.CreateExtIO:
 move.l a6,-(sp)
 move.l $4,a6
 CALLSYS CreateIORequest
 move.l (sp)+,a6
 rts

.DeleteExtIO:
 move.l a6,-(sp)
 move.l $4,a6
 CALLSYS DeleteIORequest
 move.l (sp)+,a6
 rts

.CreateStdIO:
 move.l #42,d0
 jsr .CreateExtIO
 rts

.CreatePort:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _CreatePort(pc)
 addq.l #8,sp
 rts

.DeletePort:
 move.l a0,-(sp)
 jsr _DeletePort(pc)
 addq.l #4,sp
 rts

.NewList:
 move.l a0,-(sp)
 jsr _NewList(pc)
 addq.l #4,sp
 rts

.ThisTask:
 move.l a6,-(sp)
 move.l $4,a6
 move.l ThisTask(a6),d0
 move.l (sp)+,a6
 rts

.ThisUser:
 move.l a6,-(sp)
 move.l $4,a6
 move.l ThisTask(a6),a6
 move.l TC_Userdata(a6),d0
 move.l (sp)+,a6
 rts

.GetMem:
 movem.l d1/d0,-(sp)
 jsr _GetMem(pc)
 addq.l #8,sp
 rts

.DisposeMem:
 move.l a0,-(sp)
 jsr _DisposeMem(pc)
 addq.l #4,sp
 rts

.AllocMemory:
 movem.l d1/d0,-(sp)
 move.l a0,-(sp)
 jsr _AllocMemory(pc)
 lea 12(sp),sp
 rts

.AllocAlignedMemory:
 movem.l d2/d1/d0,-(sp)
 move.l a0,-(sp)
 jsr _AllocAlignedMemory(pc)
 lea 16(sp),sp
 rts

.FreeMemory:
 move.l a0,-(sp)
 jsr _FreeMemory(pc)
 addq.l #4,sp
 rts

.FreeMemoryBlock:
 movem.l a1/a0,-(sp)
 jsr _FreeMemoryBlock(pc)
 addq.l #8,sp
 rts

.ClearMem:
 movem.l a0/d0,-(sp)
1$:
 move.b #0,(a0)+
 sub.l #1,d0
 tst.l d0
 bne 1$
 movem.l (sp)+,a0/d0
 rts

.ClearMemQuick:
 movem.l a0/d0,-(sp)
1$:
 move.l #0,(a0)+
 sub.l #4,d0
 tst.l d0
 bne 1$
 movem.l (sp)+,a0/d0
 rts

.FindID:
 move.l d0,-(sp)
 move.l a1,-(sp)
 jsr _FindID(pc)
 addq.l #8,sp
 rts

.FindNode:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _FindNode(pc)
 addq.l #8,sp
 rts

.CountNodes:
 move.l a0,-(sp)
 jsr _CountNodes(pc)
 addq.l #4,sp
 rts

.SortList:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _SortList(pc)
 addq.l #8,sp
 rts

.InsertSort:
 move.l d0,-(sp)
 movem.l a1/a0,-(sp)
 jsr _InsertSort(pc)
 lea 12(sp),sp
 rts

.DupList:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _DupList(pc)
 addq.l #8,sp
 rts

.ConcatList:
 movem.l a1/a0,-(sp)
 jsr _ConcatList(pc)
 addq.l #8,sp
 rts

.CopyConcatList:
 movem.l a1/a0,-(sp)
 jsr _CopyConcatList(pc)
 addq.l #8,sp
 rts

.FreeList:
 move.l a0,-(sp)
 jsr _FreeList(pc)
 addq.l #4,sp
 rts

.StrIsGreaterThan:
 movem.l a1/a0,-(sp)
 jsr _StrIsGreaterThan(pc)
 addq.l #8,sp
 rts

.StrIsLessThan:
 movem.l a1/a0,-(sp)
 jsr _StrIsLessThan(pc)
 addq.l #8,sp
 rts

.InitHook:
 movem.l a2/a1/a0,-(sp)
 jsr _InitHook(pc)
 lea 12(sp),sp
 rts

.GetTextID:
 move.l a0,-(sp)
 jsr _GetTextID(pc)
 addq.l #4,sp
 rts

.OpenDevLibrary:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _OpenDevLibrary(pc)
 addq.l #8,sp
 rts

.CloseDevLibrary:
 move.l a0,-(sp)
 jsr _CloseDevLibrary(pc)
 addq.l #4,sp
 rts

.Time2Seconds:
 move.l a0,-(sp)
 jsr _Time2Seconds(pc)
 addq.l #4,sp
 rts

.Seconds2Time:
 movem.l a0/d0,-(sp)
 jsr _Seconds2Time(pc)
 addq.l #8,sp
 rts

.StarDate2Seconds:
 move.l d0,-(sp)
 jsr _StarDate2Seconds(pc)
 addq.l #4,sp
 rts

.Seconds2StarDate:
 movem.l a0/d0,-(sp)
 jsr _Seconds2StarDate(pc)
 addq.l #8,sp
 rts

.GetTime:
 move.l a0,-(sp)
 jsr _GetTime(pc)
 addq.l #4,sp
 rts

.SetTime:
 move.l a0,-(sp)
 jsr _SetTime(pc)
 addq.l #4,sp
 rts

.GetBattClockTime:
 move.l a0,-(sp)
 jsr _GetBattClockTime(pc)
 addq.l #4,sp
 rts

.SetBattClockTime:
 move.l a0,-(sp)
 jsr _SetBattClockTime(pc)
 addq.l #4,sp
 rts

.AddTimes:
 movem.l a1/a0,-(sp)
 jsr _AddTimes(pc)
 addq.l #8,sp
 rts

.SubTimes:
 movem.l a1/a0,-(sp)
 jsr _SubTimes(pc)
 addq.l #8,sp
 rts

.CompareTimes:
 movem.l a1/a0,-(sp)
 jsr _CompareTimes(pc)
 addq.l #8,sp
 rts

.WaitTime:
 move.l d0,-(sp)
 jsr _WaitTime(pc)
 addq.l #4,sp
 rts

.SetAlarm:
 move.l d0,-(sp)
 jsr _SetAlarm(pc)
 addq.l #4,sp
 rts

.CheckAlarm:
 jmp _CheckAlarm(pc)

.WaitAlarm:
 jmp _WaitAlarm(pc)

.AbortAlarm:
 jmp _AbortAlarm(pc)

.InitTime:
 movem.l d5/d4/d3/d2/d1/d0,-(sp)
 move.l a0,-(sp)
 jsr _InitTime(pc)
 lea 28(sp),sp
 rts

.GetError:
 jmp _GetError(pc)

.GetGuru:
 jmp _GetGuru(pc)

.SetError:
 move.l d0,-(sp)
 jsr _SetError(pc)
 addq.l #4,sp
 rts

.SetGuru:
 move.l d0,-(sp)
 jsr _SetGuru(pc)
 addq.l #4,sp
 rts

.NoMemory:
 jmp _NoMemory(pc)

.GetTermProcedure:
 jmp _GetTermProcedure(pc)

.GetSysTermProcedure:
 jmp _GetSysTermProcedure(pc)

.SetTermProcedure:
 move.l a0,-(sp)
 jsr _SetTermProcedure(pc)
 addq.l #4,sp
 rts

.SetSysTermProcedure:
 move.l a0,-(sp)
 jsr _SetTermProcedure(pc)
 addq.l #4,sp
 rts

.Terminate:
 jmp _Terminate(pc)

.Guru:
 jmp _Guru(pc)

.AvailSignals:
 move.l a0,-(sp)
 jsr _AvailSignals(pc)
 addq.l #4,sp
 rts

.AvailTraps:
 move.l a0,-(sp)
 jsr _AvailTraps(pc)
 addq.l #4,sp
 rts

.Halt:
 jmp _Halt(pc)

.Pause:
 jmp _Pause(pc)

.GetFunction:
  move.l 2(a0,d0),d0
  rts

.BreakOn:
 jmp _BreakOn(pc)

.BreakOff:
 jmp _BreakOff(pc)

.AvailChipMem:
 jmp _AvailChipMem(pc)

.AvailFastMem:
 jmp _AvailFastMem(pc)

.AvailVMem:
 jmp _AvailVMem(pc)

.AvailPublicMem:
 jmp _AvailPublicMem(pc)

.AvailMemory:
 jmp _AvailMemory(pc)

.CPointer:
 asl.l #4,d0
 rts

.BPointer:
 asr.l #4,d0
 rts

.CString
 movem.l a1/a0,-(sp)
 jsr _CString(pc)
 addq.w #8,sp
 rts

.BString
 movem.l a1/a0,-(sp)
 jsr _BString(pc)
 addq.w #8,sp
 rts

 global _SysBase,4
 global _MultiDesktopBase,4

 END

