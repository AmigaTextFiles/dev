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

 include "exec/types.i"
 include "exec/initializers.i"
 include "exec/libraries.i"
 include "exec/lists.i"
 include "exec/nodes.i"
 include "exec/resident.i"
 include "libraries/dos.i"
 include "exec/alerts.i"

CALLSYS  MACRO
 jsr _LVO%1(a6)
 endm
XLIB  MACRO
 xref _LVO%1
 endm

 STRUCTURE DigitalLib,LIB_SIZE
  ULONG dl_SysLib
  ULONG dl_DosLib
  ULONG dl_SegList
  UBYTE dl_Flags
  UBYTE dl_Pad
 LABEL DigitalLib_SIZEOF

 XLIB OpenLibrary
 XLIB CloseLibrary
 XLIB FreeMem
 XLIB Remove
 XLIB Alert
 XREF _AllocChipMem
 XREF _AllocFastMem
 XREF _AllocMemory
 XREF _FreeMemory
 XREF _AllocRChipMem
 XREF _AllocRFastMem
 XREF _AllocRMemory
 XREF _FreeRMemory
 XREF _CreateMemHeader
 XREF _DeleteMemHeader
 XREF _AllocLMemory
 XREF _FreeLMemory
 XREF _AvailChipMem
 XREF _AvailFastMem
 XREF _AvailMemory
 XREF _AvailLMemory
 XREF _BackupRList
 XREF _RestoreRList
 XREF _AllocDRemember
 XREF _AllocDMemory
 XREF _AllocAddress
 XREF _AllocRAddress

Version   equ 38
Revision  equ 0
Pri       equ 75

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

LibName:  dc.b 'digital.library',0
idString: dc.b 'digital.library 38.0 (21 Apr 92)',13,10,0
DosName:  dc.b 'dos.library',0
 ds.w 0

EndCode:

Init:
 dc.l DigitalLib_SIZEOF
 dc.l FuncTable
 dc.l DataTable
 dc.l InitRoutine

FuncTable:
 dc.l Open
 dc.l Close
 dc.l Expunge
 dc.l Null

 dc.l AllocChipMem
 dc.l AllocFastMem
 dc.l AllocMemory
 dc.l FreeMemory

 dc.l AllocRChipMem
 dc.l AllocRFastMem
 dc.l AllocRMemory
 dc.l FreeRMemory

 dc.l CreateMemHeader
 dc.l DeleteMemHeader
 dc.l AllocLMemory
 dc.l FreeLMemory

 dc.l AvailChipMem
 dc.l AvailFastMem
 dc.l AvailMemory
 dc.l AvailLMemory

 dc.l BackupRList
 dc.l RestoreRList

 dc.l AllocSpecialMem
 dc.l AllocRSpecialMem
 dc.l AllocAddress
 dc.l AllocRAddress

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
 move.l a6,dl_SysLib(a5)
 move.l a0,dl_SegList(a5)
 lea DosName(pc),a1
 moveq.l #0,d0
 CALLSYS OpenLibrary
 move.l d0,dl_DosLib(a5)
 bne.s 1$
 ALERT AG_OpenLib!AO_DOSLib
1$:
 move.l a5,d0
 move.l (a7)+,a5
 rts

Open:
 addq.w #1,LIB_OPENCNT(a6)
 bclr #LIBB_DELEXP,dl_Flags(a6)
 move.l a6,d0
 rts

Close:
 clr.l d0
 subq.w #1,LIB_OPENCNT(a6)
 bne.s 1$
 btst #LIBB_DELEXP,dl_Flags(a5)
 beq.s 1$
 bsr Expunge
1$:
 rts

Expunge:
 movem.l d2/a5-a6,-(a7)
 move.l a6,a5
 move.l dl_SysLib(a5),a6
 tst.w LIB_OPENCNT(a5)
 beq.s 1$
 bset #LIBB_DELEXP,dl_Flags(a5)
 clr.l d0
 bra.s Expunge_end
1$:
 move.l dl_SegList(a5),d2
 move.l a5,a1
 CALLSYS Remove
 move.l dl_DosLib(a5),a1
 CALLSYS CloseLibrary
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
AllocChipMem:
 move.l d0,-(sp)
 jsr _AllocChipMem
 add.w #4,sp
 move.l d0,d1
 rts
AllocFastMem:
 move.l d0,-(sp)
 jsr _AllocFastMem
 add.w #4,sp
 move.l d0,d1
 rts
AllocMemory:
 move.l d0,-(sp)
 jsr _AllocMemory
 add.w #4,sp
 move.l d0,d1
 rts
FreeMemory:
 move.l a0,-(sp)
 jsr _FreeMemory
 add.w #4,sp
 rts
AllocRChipMem:
 move.l d0,-(sp)
 jsr _AllocRChipMem
 add.w #4,sp
 move.l d0,d1
 rts
AllocRFastMem:
 move.l d0,-(sp)
 jsr _AllocRFastMem
 add.w #4,sp
 move.l d0,d1
 rts
AllocRMemory:
 move.l d0,-(sp)
 jsr _AllocRMemory
 add.w #4,sp
 move.l d0,d1
 rts
FreeRMemory:
 jsr _FreeRMemory
 rts
CreateMemHeader:
 move.l a1,-(sp)
 move.l a0,-(sp)
 move.l d2,-(sp)
 move.l d1,-(sp)
 move.l d0,-(sp)
 jsr _CreateMemHeader
 add.w #20,sp
 move.l d0,d1
 rts
DeleteMemHeader:
 move.l a0,-(sp)
 jsr _DeleteMemHeader
 add.w #4,sp
 rts
AllocLMemory:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _AllocLMemory
 add.w #8,sp
 move.l d0,d1
 rts
FreeLMemory:
 move.l d0,-(sp)
 move.l a0,-(sp)
 jsr _FreeLMemory
 add.w #8,sp
 rts
AvailChipMem:
 jsr _AvailChipMem
 move.l d0,d1
 rts
AvailFastMem:
 jsr _AvailFastMem
 move.l d0,d1
 rts
AvailMemory:
 jsr _AvailMemory
 move.l d0,d1
 rts
AvailLMemory:
 move.l a0,-(sp)
 jsr _AvailLMemory
 add.w #4,sp
 move.l d0,d1
 rts
BackupRList:
 jsr _BackupRList
 move.l d0,d1
 rts
RestoreRList:
 move.l a0,-(sp)
 jsr _RestoreRList
 add.w #4,sp
 rts
AllocSpecialMem:
 move.l d1,-(sp)
 move.l d0,-(sp)
 jsr _AllocDMemory
 add.w #8,sp
 move.l d0,d1
 rts
AllocRSpecialMem:
 move.l d1,-(sp)
 move.l d0,-(sp)
 jsr _AllocDRemember
 add.w #8,sp
 move.l d0,d1
 rts
AllocAddress:
 move.l d1,-(sp)
 move.l d0,-(sp)
 jsr _AllocAddress
 add.w #8,sp
 move.l d0,d1
 rts
AllocRAddress:
 move.l d1,-(sp)
 move.l d0,-(sp)
 jsr _AllocRAddress
 add.w #8,sp
 move.l d0,d1
 rts
 END
