 ; ##########################################################################
 ; ####                                                                  ####
 ; ####     DigitalLibrary - An Amiga library for memory allocation      ####
 ; ####    =========================================================     ####
 ; ####                                                                  ####
 ; #### dig.asm                                                          ####
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


   XREF _DigitalBase
   XDEF _LVOAllocChipMem
_LVOAllocChipMem: EQU -30
   XDEF _AllocChipMem
_AllocChipMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -30(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocFastMem
_LVOAllocFastMem: EQU -36
   XDEF _AllocFastMem
_AllocFastMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -36(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocMemory
_LVOAllocMemory: EQU -42
   XDEF _AllocMemory
_AllocMemory:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -42(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeMemory
_LVOFreeMemory: EQU -48
   XDEF _FreeMemory
_FreeMemory:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _DigitalBase,A6
   JSR -48(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocRChipMem
_LVOAllocRChipMem: EQU -54
   XDEF _AllocRChipMem
_AllocRChipMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -54(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocRFastMem
_LVOAllocRFastMem: EQU -60
   XDEF _AllocRFastMem
_AllocRFastMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -60(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocRMemory
_LVOAllocRMemory: EQU -66
   XDEF _AllocRMemory
_AllocRMemory:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -66(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeRMemory
_LVOFreeRMemory: EQU -72
   XDEF _FreeRMemory
_FreeRMemory:
   MOVE.L A6,-(SP)
   MOVE.L _DigitalBase,A6
   JSR -72(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOCreateMemHeader
_LVOCreateMemHeader: EQU -78
   XDEF _CreateMemHeader
_CreateMemHeader:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L 16(SP),D2
   MOVE.L 20(SP),A0
   MOVE.L 24(SP),A1
   MOVE.L _DigitalBase,A6
   JSR -78(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVODeleteMemHeader
_LVODeleteMemHeader: EQU -84
   XDEF _DeleteMemHeader
_DeleteMemHeader:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _DigitalBase,A6
   JSR -84(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocLMemory
_LVOAllocLMemory: EQU -90
   XDEF _AllocLMemory
_AllocLMemory:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -90(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOFreeLMemory
_LVOFreeLMemory: EQU -96
   XDEF _FreeLMemory
_FreeLMemory:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L 12(SP),D0
   MOVE.L _DigitalBase,A6
   JSR -96(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAvailChipMem
_LVOAvailChipMem: EQU -102
   XDEF _AvailChipMem
_AvailChipMem:
   MOVE.L A6,-(SP)
   MOVE.L _DigitalBase,A6
   JSR -102(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAvailFastMem
_LVOAvailFastMem: EQU -108
   XDEF _AvailFastMem
_AvailFastMem:
   MOVE.L A6,-(SP)
   MOVE.L _DigitalBase,A6
   JSR -108(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAvailMemory
_LVOAvailMemory: EQU -114
   XDEF _AvailMemory
_AvailMemory:
   MOVE.L A6,-(SP)
   MOVE.L _DigitalBase,A6
   JSR -114(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAvailLMemory
_LVOAvailLMemory: EQU -120
   XDEF _AvailLMemory
_AvailLMemory:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _DigitalBase,A6
   JSR -120(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOBackupRList
_LVOBackupRList: EQU -126
   XDEF _BackupRList
_BackupRList:
   MOVE.L A6,-(SP)
   MOVE.L _DigitalBase,A6
   JSR -126(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVORestoreRList
_LVORestoreRList: EQU -132
   XDEF _RestoreRList
_RestoreRList:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),A0
   MOVE.L _DigitalBase,A6
   JSR -132(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocSpecialMem
_LVOAllocSpecialMem: EQU -138
   XDEF _AllocSpecialMem
_AllocSpecialMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _DigitalBase,A6
   JSR -138(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocRSpecialMem
_LVOAllocRSpecialMem: EQU -144
   XDEF _AllocRSpecialMem
_AllocRSpecialMem:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _DigitalBase,A6
   JSR -144(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocAddress
_LVOAllocAddress: EQU -150
   XDEF _AllocAddress
_AllocAddress:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _DigitalBase,A6
   JSR -150(A6)
   MOVE.L (SP)+,A6
   RTS
   XDEF _LVOAllocRAddress
_LVOAllocRAddress: EQU -156
   XDEF _AllocRAddress
_AllocRAddress:
   MOVE.L A6,-(SP)
   MOVE.L 8(SP),D0
   MOVE.L 12(SP),D1
   MOVE.L _DigitalBase,A6
   JSR -156(A6)
   MOVE.L (SP)+,A6
   RTS
