 ; MultiDesktop-Library

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

 STRUCTURE MultiWindowsLib,LIB_SIZE
  ULONG mwl_DeskLib

  ULONG mwl_SegList
  UBYTE mwl_Flags
  UBYTE mwl_Pad
 LABEL MultiWindowsLib_SIZEOF

 XLIB OpenLibrary
 XLIB CloseLibrary
 XLIB FreeMem
 XLIB Remove
 XLIB Alert

 XREF _AddUser
 XREF _RemUser

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

LibName:  dc.b 'multiwindows.library',0
verID:    dc.b '$VER: multiwindows.library 1.00 (Apr 10 1995) - Copyright (C) 1995 by Thomas Dreibholz',0
idString: dc.b 'multiwindows.library 38.00 (Apr 10 1995)',13,10,0
DeskName: dc.b 'multidesktop.library',0

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
 dc.l MultiWindowsLib_SIZEOF
 dc.l FuncTable
 dc.l DataTable
 dc.l InitRoutine

FuncTable:
 dc.l Open
 dc.l Close
 dc.l Expunge
 dc.l Null

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
 move.l #0,_Catalog
 move.l #0,_Locale
 move.l a6,mwl_SysLib(a5)
 move.l a0,mwl_SegList(a5)
 move.l $4,_SysBase

 ; Öffnen der multidesktop.library

 lea DeskName(pc),a1
 move.l #0,d0
 CALLSYS OpenLibrary
 move.l d0,mwl_DeskLib(a5)
 move.l d0,_MultiDesktopBase
 move.l d0,a1
 bne.s 1$
 move.l #0,a5
 bra InitRoutine_end

 ; Basisadressen kopieren statt neu zu öffnen

1$:
 move.l mdl_GfxLib(a1),_GfxBase
 move.l mdl_IntLib(a1),_IntuitionBase
 move.l mdl_FontLib(a1),_DiskfontBase
 move.l mdl_LocaleLib(a1),_LocaleBase
 move.l mdl_GTLib(a1),_GadToolsBase
 move.l mdl_IconLib(a1),_IconBase
 move.l mdl_VersionLib(a1),_VersionBase
 move.l mdl_DosLib(a1),_DOSBase

InitRoutine_end:
 move.l a5,d0
 move.l (a7)+,a5
 rts

Open:
 ; Library öffnen

 jsr _InitUser(pc)
 tst.l d0
 beq 1$
 addq.w #1,LIB_OPENCNT(a6)
 bclr #LIBB_DELEXP,mwl_Flags(a6)
 move.l a6,d0
1$:
 rts

Close:
 ; Library schließen

 jsr _RemoveUser(pc)
 clr.l d0
 subq.w #1,LIB_OPENCNT(a6)
 bne.s 1$
 btst #LIBB_DELEXP,mwl_Flags(a5)
 beq.s 1$
 bsr Expunge
1$:
 rts

Expunge:
 ; Library aus dem Speicher entfernen

 movem.l d2/a5-a6,-(a7)
 move.l a6,a5
 move.l mwl_SysLib(a5),a6
 tst.w LIB_OPENCNT(a5)
 beq.s 1$
 bset #LIBB_DELEXP,mwl_Flags(a5)
 clr.l d0
 bra Expunge_end
1$:
 move.l mwl_SegList(a5),d2
 move.l a5,a1
 CALLSYS Remove

 ; MultiDesktop-Library schließen

 move.l mwl_DeskLib(a5),a1
 CALLSYS CloseLibrary

 ; Library entfernen

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

 global _GfxBase,4
 global _IntuitionBase,4
 global _DOSBase,4
 global _DiskfontBase,4
 global _SysBase,4
 global _LocaleBase,4
 global _GadToolsBase,4
 global _VersionBase,4
 global _IconBase,4
 global _MultiDesktopBase,4

 END

