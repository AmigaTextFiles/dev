;
;
;                 PhxAss - String OS dependant routines (AmigaOS 680x0)
;                 -----------------------------------------------------
;
;
; 02/05/2001
;   First version
;
;

CreatePool  = -696 ; - d0,d1,d2
DeletePool  = -702 ; - a0
AllocPooled = -708 ; - a0, d0
FreePooled  = -714 ; - a0,a1,d0


; --------------------------------------------------
; InitString()
;

 macro PB_InitString

 IF PB_NeedString

   MOVE.l   #PB_StringBankSize,d0
   JSR      PB_AllocateGlobalMemory
   MOVE.l   d0,a3
   MOVEQ.l  #0,d0
   MOVEQ.l  #40,d1
   MOVE.l   d1,d2
   MOVE.l   $4,a6
   JSR      CreatePool(a6)
   MOVE.l   d0,(a4)

 ENDC
 endm


; --------------------------------------------------
; FreeString()
;

 macro PB_FreeString

 IF PB_NeedString

   MOVE.l   (a4),a0
   MOVEA.l  $4,a6
   JSR      DeletePool(a6)

 ENDC
 endm


; --------------------------------------------------
; StringSubRoutines()
;

 macro PB_StringSubRoutines

 IF PB_NeedString

SYS_FreeString:
    CMP.l   #0,a0
    BEQ    .Null
    MOVE.l  d0,-(a7) ; We need to preserve 'd0' as FreeString() can be called at the end of a procedure which needs to return a result
    MOVE.l  a0,a1
.GetSize:
    MOVE.b  (a0)+,d0
    BNE    .GetSize
    SUB.l   a1,a0
    MOVE.l  a0,d0
    MOVE.l  (a4),a0  ; Use the global memory pool
    MOVE.l  $4,a6
    JSR     FreePooled(a6)    ; (Pool, Memory, Size) - (a0/a1/d0)
    MOVE.l  (a7)+,d0
.Null:
    RTS

;
;    AllocString()
;    -------------
;
;      
SYS_AllocateString:
    MOVE.l  $4,a6
    MOVE.l  a0,d2
    MOVEA.l (a5),a0
    BSR     SYS_FreeString
    MOVE.l  a3,d0
    SUB.l   d2,d0
    ADDQ.l  #1,d0
    MOVE.l  (a4),a0
    JSR     AllocPooled(a6) ; a0/d0
    MOVE.l  d0,a0
    MOVE.l  d0,(a5)
    MOVE.l  d2,a1
.CopyLoop:
    MOVE.b  (a1)+,(a0)+
    BNE    .CopyLoop
    MOVE.l  d2,a3
    RTS


; CopyString()
;

SYS_CopyString:
    CMP.l  #0,a0
    BEQ   _PB_CopyStringEnd
.CopyLoop:
    MOVE.b (a0)+,(a3)+
    BNE   .CopyLoop
    SUB.l  #1,a3
_PB_CopyStringEnd:
    RTS



 IF PB_NeedFastAllocateString

SYS_FastAllocateString:
      MOVE.l a1,-(a7)
      MOVE.l $4,a6
      MOVE.l d2,a0
.GetSize:
      MOVE.b (a0)+,d0
      BNE   .GetSize
      SUB.l  d2,a0
      MOVE.l a0,d0    ; Get the size of the string
      ADDQ.l #1,d0    ; Add one for the '0' at the string end
      MOVE.l (a4),a0  ; Use the global memory pool
      JSR    AllocPooled(a6) ; a0/d0
      MOVE.l d0,a0
      MOVE.l d0,(a5)  ; Set the new memory pointer to the right emplacement
      MOVE.l d2,a1
.CopyLoop:
      MOVE.b (a1)+,(a0)+
      BNE   .CopyLoop
      MOVE.l a1,d0
      MOVE.l (a7)+,a1
      SUB.l  d2,d0
      RTS
 ENDC



 IF PB_NeedFastAllocateStringFree

; a5: Input string
; d2: Output string
SYS_FastAllocateStringFree:
      MOVE.l  a1,-(a7)
      MOVEA.l (a5),a0
      JSR     SYS_FreeString ; a0
      MOVE.l  $4,a6
      MOVE.l  d2,a0
.GetSize:
      MOVE.b  (a0)+,d0
      BNE    .GetSize
      SUB.l   d2,a0
      MOVE.l  a0,d0    ; Get the size of the string
      ADDQ.l  #1,d0    ; Add one for the '0' at the string end
      MOVE.l  (a4),a0  ; Use the global memory pool
      JSR     AllocPooled(a6) ; a0/d0
      MOVE.l  d0,a0
      MOVE.l  d0,(a5)  ; Set the new memory pointer to the right emplacement
      MOVE.l  d2,a1
.CopyLoop:
      MOVE.b  (a1)+,(a0)+
      BNE    .CopyLoop
      MOVE.l  a1,d0
      MOVE.l  (a7)+,a1
      SUB.l   d2,d0
      RTS
 ENDC
 

 IF PB_NeedStringEqual

SYS_StringEqual:
      MOVE.l a0,d0
      BNE   .NotNull1
      LEA.l  PB_NullString,a0
.NotNull1:
      MOVE.l a1,d0
      BNE   .NotNull2
      LEA.l  PB_NullString,a1
.NotNull2:
.Loop:
      MOVE.b (a1)+,d0
      MOVE.b (a0)+,d2
      CMP.b  d2,d0
      BNE   _PB_StringFail
      TST.b  d0
      BNE   .Loop
      MOVEQ #1,d0
      RTS
 ENDC


 IF PB_NeedStringSup

SYS_StringSup:
      MOVE.l a0,d0
      BNE   .NotNull1
      LEA.l  PB_NullString,a0
.NotNull1:
      MOVE.l a1,d0
      BNE   .NotNull2
      LEA.l  PB_NullString,a1
.NotNull2:
.Loop:
      MOVE.b (a1)+,d0
      MOVE.b (a0)+,d2
      CMP.b  d2,d0
      BHI   _PB_StringOk
      BCS   _PB_StringFail
      TST.b  d0
      BNE   .Loop
      MOVEQ  #0,d0
      RTS
 ENDC


 IF PB_NeedStringInf

SYS_StringInf:
   MOVE.l a0,d0
   BNE   .NotNull1
   LEA.l  PB_NullString,a0
.NotNull1:
   MOVE.l a1,d0
   BNE   .NotNull2
   LEA.l  PB_NullString,a1
.NotNull2:
.Loop:
   MOVE.b (a1)+,d0
   MOVE.b (a0)+,d2
   CMP.b  d2,d0
   BCS   _PB_StringOk
   BHI   _PB_StringFail
   TST.b  d0
   BNE   .Loop
   MOVEQ #0,d0
   RTS

 ENDC


 IF PB_NeedStringInf | PB_NeedStringSup

_PB_StringOk:
   MOVEQ #1,d0
   RTS

 ENDC


 IF PB_NeedStringInf | PB_NeedStringSup | PB_NeedStringEqual

_PB_StringFail:
   MOVEQ #0,d0
   RTS

 ENDC



 IF PB_NeedFreeStructureStrings

  ; a0 is the address of the structured variable
  ; a1 is the address of the map
  ;
SYS_FreeStructureStrings:
  MOVE.l  a2,-(a7) ; Need to be preserved
  MOVE.l  d0,-(a7) ; Need to be preserved
  MOVE.l  a3,-(a7)

  MOVE.l  a0,a3 ; variable is in a3
  MOVE.l  a1,a2 ; map is in a2

.Loop:
  
  MOVE.l  (a2)+,d0
  CMP.l   #-1, d0  ; -1 is the end marker in the map
  BEQ    .End

  CMP.l   #-2, d0  ; Array inside the structure
  BNE    .NoArray

  ; Array detected
  ;
  MOVE.l  (a2),d0 ; Nb of element
.ArrayLoop:
  SUBQ.l  #1,d0
  CMP.l   #0,d0
  BLT.l  .EndArrayLoop  ; Quit only if < 0 to be sure to release all the elements..

  MOVE.l  a0,-(a7) ; a0 is the main base address, so preserve it as well
  MOVE.l  d0,-(a7) ; d0 is our loop counter, preserve it

  MOVE.l   a3,a0
  ADD.l    4(a2),a0  ; The array structure index
  MOVE.l   8(a2),d1  ; The array element size
  MULS.w  d0,d1
  ADD.l   d1,a0      ; Now it should point to the correct array index
  MOVE.l  12(a2), a1 ;
  JSR     SYS_FreeStructureStrings

  MOVE.l  (a7)+,d0
  MOVE.l  (a7)+,a0
  
  JMP    .ArrayLoop

.EndArrayLoop:
  ADD.l   #16,a2
  JMP    .Loop
.NoArray:

  MOVE.l  a3,a0
  ADD.l   d0,a0
  TST.l   (a0)  ; Test against 0
  BEQ.l  .Loop  ; No free needed, so skip it
  MOVE.l  (a0),a0
  JSR     SYS_FreeString ; string address is expected in a0
  JMP    .Loop
.End:

  MOVE.l (a7)+,a3
  MOVE.l (a7)+,d0
  MOVE.l (a7)+,a2
  RTS

  ENDC

 endm


; PB_InitString
; PB_FreeString
; PB_StringSubRoutines
