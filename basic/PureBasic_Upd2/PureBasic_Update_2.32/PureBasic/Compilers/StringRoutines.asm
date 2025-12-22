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

; PB_NeedString = 1
; PB_StringBankSize = 5000

; PB_NeedFastAllocateString = 0
; PB_NeedStringEqual        = 0
; PB_NeedStringSup          = 0
; PB_NeedStringInf          = 0


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
   JSR     -696(a6)
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
   JSR     -702(a6)

 ENDC
 endm


; --------------------------------------------------
; StringSubRoutines()
;

 macro PB_StringSubRoutines

 IF PB_NeedString

;
;    AllocString()
;    -------------
;
;      edx = StringSource
;      ecx = OldEmplacement

PB_AllocateString:
    MOVE.l $4,a6
    MOVE.l a0,d2
    TST.l (a5)
    BEQ _Skip_Free
    MOVE.l (a5),a1
    MOVE.l a1,a0
_PB_GetSize:
    MOVE.b (a0)+,d0
    BNE _PB_GetSize
    SUB.l a1,a0
    MOVE.l a0,d0
    MOVE.l (a4),a0
    JSR -714(a6)
_Skip_Free:
    MOVE.l a3,d0
    SUB.l d2,d0
    ADDQ.l #1,d0
    MOVE.l (a4),a0
    JSR -708(a6)
    MOVE.l d0,a0
    MOVE.l d0,(a5)
    MOVE.l d2,a1
_PB_CopyLoop:
    MOVE.b (a1)+,(a0)+
    BNE _PB_CopyLoop
    MOVE.l d2,a3
    RTS


; CopyString()
;

PB_CopyString:
    CMP.l  #0,a0
    BEQ   _PB_CopyStringEnd
_PB_CopyStringLoop:
    MOVE.b (a0)+,(a3)+
    BNE   _PB_CopyStringLoop
    SUB.l  #1,a3
_PB_CopyStringEnd:
    RTS



 IF PB_NeedFastAllocateString

PB_FastAllocateString:
      MOVE.l a1,-(a7)
      MOVE.l $4,a6
      MOVE.l d2,a0
_PB_FAS_GetSize
      MOVE.b (a0)+,d0
      BNE _PB_FAS_GetSize
      SUB.l d2,a0
      MOVE.l a0,d0    ; Get the size of the string
      ADDQ.l #1,d0    ; Add one for the '0' at the string end
      MOVE.l (a4),a0  ; Use the global memory pool
      JSR -708(a6)
      MOVE.l d0,a0
      MOVE.l d0,(a5)  ; Set the new memory pointer to the right emplacement
      MOVE.l d2,a1
_PB_FAS_CopyLoop:
      MOVE.b (a1)+,(a0)+
      BNE _PB_FAS_CopyLoop
      MOVE.l a1,d0
      MOVE.l (a7)+,a1
      SUB.l  d2,d0
      RTS
 ENDC

 

 IF PB_NeedStringEqual

PB_StringEqual:
      MOVE.l a0,d0
      BNE _PB_StringEqualNext1
      LEA.l PB_NullString,a0
_PB_StringEqualNext1:

      MOVE.l a1,d0
      BNE _PB_StringEqualNext2
      LEA.l PB_NullString,a1
_PB_StringEqualNext2:

_PB_StringEqualLoop:
      MOVE.b (a1)+,d0
      MOVE.b (a0)+,d2
      CMP.b d2,d0
      BNE _PB_StringFail
      TST.b d0
      BNE _PB_StringEqualLoop
      MOVEQ #1,d0
      RTS
 ENDC


 IF PB_NeedStringSup

PB_StringSup:
      MOVE.l a0,d0
      BNE _PB_StringSupNext1
      LEA.l PB_NullString,a0
_PB_StringSupNext1:

      MOVE.l a1,d0
      BNE _PB_StringSupNext2
      LEA.l PB_NullString,a1
_PB_StringSupNext2:

PB_StringSupLoop:
      MOVE.b (a1)+,d0
      MOVE.b (a0)+,d2
      CMP.b d2,d0
      BHI _PB_StringOk
      BCS _PB_StringFail
      TST.b d0
      BNE PB_StringSupLoop
      MOVEQ #0,d0
      RTS
 ENDC


 IF PB_NeedStringInf

PB_StringInf:
   MOVE.l a0,d0
   BNE _PB_StringInfNext1
   LEA.l PB_NullString,a0
_PB_StringInfNext1:

   MOVE.l a1,d0
   BNE _PB_StringInfNext2
   LEA.l PB_NullString,a1
_PB_StringInfNext2:

_PB_StringInfLoop:
   MOVE.b (a1)+,d0
   MOVE.b (a0)+,d2
   CMP.b d2,d0
   BCS _PB_StringOk
   BHI _PB_StringFail
   TST.b d0
   BNE _PB_StringInfLoop
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
 endm


; PB_InitString
; PB_FreeString
; PB_StringSubRoutines
