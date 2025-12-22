 ; MultiSystem-Library

 include "exec/types.i"
 include "exec/initializers.i"
 include "exec/libraries.i"
 include "exec/lists.i"
 include "exec/nodes.i"
 include "exec/resident.i"
 include "exec/alerts.i"

CALLSYS  MACRO
 jsr _LVO%1(a6)
 endm

XLIB  MACRO
 xref _LVO%1
 endm

 STRUCTURE MultiSystemLib,LIB_SIZE
  ULONG msl_SysLib
  ULONG msl_SegList
  UBYTE msl_Flags
  UBYTE msl_Pad
 LABEL MultiSystemLib_SIZEOF

 XLIB OpenLibrary
 XLIB CloseLibrary
 XLIB FreeMem
 XLIB Remove
 XLIB Alert

 XREF _GetCPUType
 XREF _GetFPUType
 XREF _GetMMUType

 XREF _GetCACR
 XREF _SetCACR
 XREF _GetCRP
 XREF _SetCRP
 XREF _GetSRP
 XREF _SetSRP
 XREF _GetTC
 XREF _SetTC
 XREF _GetTT0
 XREF _SetTT0
 XREF _GetTT1
 XREF _SetTT1

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

LibName:  dc.b 'multisystem.library',0
verID:    dc.b '$VER: multisystem.library 68030 1.00 (May 5 1995) - Copyright (C) 1995 by Thomas Dreibholz',0
idString: dc.b 'multisystem.library 68030 38.00 (May 5 1995)',13,10,0
 even
EndCode:

Init:
 dc.l MultiSystemLib_SIZEOF
 dc.l FuncTable
 dc.l DataTable
 dc.l InitRoutine

FuncTable:
 dc.l Open
 dc.l Close
 dc.l Expunge
 dc.l Null

 dc.l _GetCPUType
 dc.l _GetFPUType
 dc.l _GetMMUType

 dc.l _GetCACR
 dc.l _SetCACR

 dc.l _GetCRP
 dc.l _SetCRP
 dc.l _GetSRP
 dc.l _SetSRP
 dc.l _GetTC
 dc.l _SetTC

 dc.l _GetTT0
 dc.l _SetTT0
 dc.l _GetTT1
 dc.l _SetTT1

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
 move.l a6,msl_SysLib(a5)
 move.l a0,msl_SegList(a5)
InitRoutine_end:
 move.l a5,d0
 move.l (a7)+,a5
 rts

Open:
 addq.w #1,LIB_OPENCNT(a6)
 bclr #LIBB_DELEXP,msl_Flags(a6)
 move.l a6,d0
 rts

Close:
 clr.l d0
 subq.w #1,LIB_OPENCNT(a6)
 bne.s 1$
 btst #LIBB_DELEXP,msl_Flags(a5)
 beq.s 1$
 bsr Expunge
1$:
 rts

Expunge:
 movem.l d2/a5-a6,-(a7)
 move.l a6,a5
 move.l msl_SysLib(a5),a6
 tst.w LIB_OPENCNT(a5)
 beq.s 1$
 bset #LIBB_DELEXP,msl_Flags(a5)
 clr.l d0
 bra Expunge_end
1$:
 move.l msl_SegList(a5),d2
 move.l a5,a1
 CALLSYS Remove
 clr.l d0
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

 END

