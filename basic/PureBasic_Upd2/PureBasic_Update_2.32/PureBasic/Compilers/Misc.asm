
;
;            Misc - OS dependant routines
;            ----------------------------
;
;
; 02/06/2001
;   First version
;

;PB_NeedAllocateMultiArray = 1
;PB_Debugger = 1

;PB_GlobalBankSize = 100
;PB_GraphicsOffset = 20
;PB_DebuggerPort   = 10
;PB_SourceAddr     = 100


 macro InitProgram

  MACHINE 68020
   
   MOVEM.l  d0-d7/a0-a6,-(a7)
   MOVEA.l  $4,a6
   LEA.l    PB_LibraryExecName,a1
   MOVEQ.l  #39,d0
   JSR     -552(a6)   ; OpenLibrary
   MOVE.l   d0,d0
   BEQ.l    PB_QuickEnd

   MOVE.l   #65536,d0
   MOVEQ.l  #40,d1
   MOVE.l   d1,d2
   JSR     -696(a6)  ; CreatePool()
   MOVE.l   d0,d7

   MOVE.l   d0,a0
   MOVE.l   #PB_GlobalBankSize,d0
   JSR     -708(a6)   ; Allocate the main memory bank on the Pool..
   MOVE.l   d0,a4

   MOVE.l   d7,44(a4)
   LEA      PB_AllocateGlobalMemory,a0
   MOVE.l   a0,40(a4)
   LEA      PB_AllocateNewString,a0
   MOVE.l   a0,60(a4)
   LEA      PB_FreeString,a0
   MOVE.l   a0,64(a4)
   LEA      PB_ReAllocateGlobalBank,a0
   MOVE.l   a0,68(a4)

 endm


 macro QuitProgram

   MOVE.l 44(a4),a0
   MOVEA.l $4,a6
   JSR -702(a6)  ; DeletePool()

PB_QuickEnd:
   MOVEM.l (a7)+,d0-d7/a0-a6
   RTS

PB_LibraryExecName:
   Dc.b "exec.library",0
   EVEN

 endm


 macro AmigaLock

   IF PB_AmigaLock
     MOVE.l PB_DosOffset(a4),a6
     MOVE.l #PB_AmigaLock,d1
     JSR   -$7E(a6) ; CurrentDir()
     MOVE.l $4,a6
   ENDC

 endm


 macro AmigaLockEnd

   IF PB_AmigaLock
     MOVE.l PB_DosOffset(a4),a6
     MOVE.l #PB_AmigaLock,d1
     JSR   -$5A(a6) ; Unlock()
     MOVE.l $4,a6
   ENDC

 endm


 macro SubRoutines


PB_AllocateGlobalMemory:
   MOVEM.l d1/d2/a0/a1/a6,-(a7)
   MOVEA.l $4,a6
   ADDQ.l #4,d0
   MOVE.l d0,d2
   MOVE.l 44(a4),a0
   JSR -708(a6)
   MOVE.l d0,a0
   MOVE.l d2,(a0)+
   MOVE.l a0,d0
   MOVEM.l (a7)+,d1/d2/a0/a1/a6
   RTS


PB_ReAllocateGlobalBank:
   MOVEM.l d1/d2/a1/a2/a6,-(a7)
   MOVEA.l $4,a6
   MOVE.l a0,a2
   JSR PB_AllocateGlobalMemory
   TST.l d0
   BEQ PB_RAGB_End
   MOVE.l a2,d2
   BEQ PB_RAGB_End
   MOVE.l d0,d2
   MOVE.l a2,a0
   MOVE.l d0,a1
   MOVE.l -4(a0),d0
   SUBQ.l #4,d0
   JSR -$270(a6)
   MOVE.l 44(a4),a0
   MOVE.l -(a2),d0
   MOVE.l a2,a1
   JSR -714(a6)
   MOVE.l d2,d0
PB_RAGB_End:
   MOVEM.l (a7)+,d1/d2/a1/a2/a6
   RTS


PB_AllocateNewString:
   MOVEM.l d1/d2/d3/a6,-(a7)
   MOVEA.l $4,a6
   MOVE.l a0,d2
PB_ANS_SizeLoop:
   MOVE.b (a0)+,d0
   BNE PB_ANS_SizeLoop
   SUB.l d2,a0
   MOVE.l a0,d0
   ADDQ.l #5,d0
   MOVE.l d0,d3
   MOVE.l a1,a0
   JSR -708(a6)
   MOVE.l d0,a0
   MOVE.l d3,(a0)+
   MOVE.l a0,d0
   MOVE.l d2,a1
PB_ANS_CopyLoop:
   MOVE.b (a1)+,(a0)+
   BNE PB_ANS_CopyLoop
   MOVEM.l (a7)+,d1/d2/d3/a6
   RTS


PB_FreeString:
   MOVE.l a6,-(a7)
   MOVE.l a0,d0
   BEQ PB_FS_End
   MOVEA.l $4,a6
   EXG.l a1,a0
   MOVE.l -(a1),d0
   JSR -714(a6)
PB_FS_End:
   MOVE.l (a7)+,a6
   RTS


 IF PB_NeedAllocateMultiArray

;
;    d1 = Size of each elements
;    d3 = Number of dimensions
;    a0 = Array address+4
;

PB_AllocateMultiArray:
     MOVE.l (a0)+,d0  ; Get the first dimension number (to initialize the register)
     SUBQ.l #1,d3
PB_AMA_NextDimension
     MOVE.l (a0)+,d2  ; Get the next dimension number and multiply...
     MULU d2,d0
     SUBQ.l #1,d3
     BNE PB_AMA_NextDimension
     JMP PB_AllocateArray          ;  Result in 'd0' contains the real number of element of the new array

PB_NeedAllocateArray = 1

 ENDC


 IF PB_NeedAllocateArray

;
;       d0 = Number of elements
;       d1 = Size of each elements
;

PB_AllocateArray:
     MOVE.l d0,d2     ; Save the elements number for further use
     ADDQ.l #1,d0     ; Add 1 to take the 0 as element
     MULU d1,d0       ; Multiply by the size...
     ADDQ.l #6,d0     ; Add 6 for extra informations
     JSR PB_AllocateGlobalMemory
     MOVE.l d0,a0
     MOVE.l d2,(a0)+  ; Store the number of elements
     RTS

 ENDC


 IF PB_Debugger

_PB_CheckDebugger:

_PB_CheckDebugger_Loop:
    MOVE.l 4(a4),d0
    BEQ _PB_SkipDebugger

_PB_DebugSTOP:
    CMP.l #1,d0
    BNE _PB_DebugSTEP
    MOVE.l PB_GraphicsOffset(a4),a6
    JSR -270(a6)
    BRA _PB_CheckDebugger_Loop

_PB_DebugSTEP:
    CMP.l #2,d0
    BNE _PB_DebugTRACE
    MOVE.l #1,4(a4)
    BRA _PB_SkipDebugger

_PB_DebugTRACE:
    CMP.l #3,d0
    BNE _PB_DebugCONT

_PB_DebugCONT:
    CMP.l #4,d0
    BNE _PB_DebugEXIT
    CLR.l 4(a4)
    BRA _PB_SkipDebugger

_PB_DebugEXIT:
    CMP.l #5,d0
    BNE _PB_DebugHALT
    CLR.l (a7)+
    JMP _PB_EOP

_PB_DebugHALT:
    CMP.l #8,d0
    BNE _PB_DebugSoftwareSTOP
    MOVE.l PB_GraphicsOffset(a4),a6
    JSR -270(a6)
    BRA _PB_CheckDebugger_Loop

_PB_DebugSoftwareSTOP:
    CMP.l #9,d0
    BNE _PB_SkipDebugger
    MOVE.l PB_GraphicsOffset(a4),a6
    JSR -270(a6)
    BRA _PB_CheckDebugger_Loop

_PB_SkipDebugger:
    RTS


_PB_FindDebuggerPort:
    MOVE.l $4,a6
    LEA.l _PB_MessageStruct1(pc),a1
    LEA.l 4(a4),a0
    MOVE.l a0,20(a1)
    MOVE.l #PB_SourceAddr,24(a1)
    MOVE.l #PB_DebuggerPort,a0
    JMP -366(a6)

_PB_SendEndMessage:
    CMP.l   #5,d0
    BEQ    _PB_SkipMessageEnd
    MOVE.l  #258,4(a4)
    MOVE.l  PB_GraphicsOffset(a4),a6
_PB_EndLoop:
    JSR    -270(a6)
    MOVE.l  4(a4),d0
    CMP.l   #258,d0
    BEQ    _PB_EndLoop
_PB_SkipMessageEnd:
    RTS

_PB_MessageStruct1:
  DC.l 0,0,0,0,0,0,0,0,0

_PB_MessageStruct2:
  DC.l 0,0,0,0,0,0,0,0,0

 ENDC

 endm


; InitProgram
; QuitProgram
; SubRoutines
