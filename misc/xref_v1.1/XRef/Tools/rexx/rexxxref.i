;
; $PROJECT: rexxxref.library
;
; $VER: rexxxref.i 1.1 (08.01.95)
;
; by
;
; Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
;
; (C) Copyright 1995
; All Rights Reserved !
;
; $HISTORY:
;
; 08.01.95 : 001.001 : initial
;

        IFND REXXXREF_I
REXXXREF_I SET 1

;-----------------------------------------------------------------------

        INCLUDE "exec/types.i"
        INCLUDE "exec/libraries.i"
        INCLUDE "exec/lists.i"
        INCLUDE "exec/semaphores.i"
        INCLUDE "utility/tagitem.i"

        INCLUDE "rexxxref_rev.i"

;-----------------------------------------------------------------------

   STRUCTURE RexxXRef,LIB_SIZE
        ULONG   rxb_SysBase
        ULONG   rxb_DOSBase
        ULONG   rxb_IntuitionBase
        ULONG   rxb_UtilityBase
        ULONG   rxb_XRefBase
        ULONG   rxb_RexxSysBase
        ULONG   rxb_SegList
   LABEL RexxXRef_SIZEOF

;-----------------------------------------------------------------------

CALL MACRO <Function_Name>
        xref _LVO\1
        jsr _LVO\1(A6)
     ENDM

;-----------------------------------------------------------------------

GO   MACRO <Function_Name>
        xref _LVO\1
        jmp _LVO\1(A6)
     ENDM

;----------------------------------------------------------------------

        ENDC    ; REXXXREF_I

