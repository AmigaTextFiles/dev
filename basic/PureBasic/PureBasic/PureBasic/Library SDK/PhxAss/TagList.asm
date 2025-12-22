;
; Tag List Library for PureBasic
;
; 20/09/1999
;   Recoded for PhxAss
;
; 03/08/1999
;   Added the debugger support
;
; 14/07/1999
;   Optimized a lot
;
; 10/05/1999
;   Removed the use of any forbidden registers (a2,a3,a4...)
;
; 10/04/1999
;   Added different return type (Byte, Word, Long)
;   Fixed a little bug
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

_MemPtr = 0
_CurPtr = _MemPtr+4

; Init the library stuff
; ----------------------
;
; In the Order:
;   + Name of the library
;   + Name of the help file in which are documented all the functions
;   + Version of the library
;   + Revision of the library (ie: 0.12 here)
;

 initlib "TagList", "TagList", "FreeTagList", 0, 1, 0

;
; Now do the functions...
;

 name      "InitTagList", "()"
 flags     LongResult
 amigalibs _ExecBase, a6
 params    d0_l
 debugger  1

   ADDQ.l   #2, d0              ; Needed to have the correct number + 1
   LSL.l    #3, d0              ; d0*8
   MOVE.l   #MEMF_CLEAR, d1     ;
   JSR     _AllocVec(a6)        ; (d0,d1)
   MOVE.l   d0, (a5)            ; Set *MemPtr
   RTS

 endfunc   1


 name      "FreeTagList", "()"
 flags
 amigalibs _ExecBase, a6
 params
 debugger  2

   MOVE.l   (a5), a1           ; Get *MemPtr
   JMP     _FreeVec(a6)        ; (a1)

 endfunc   2


 name      "AddTag", "()"
 flags
 amigalibs
 params    d0_l, d1_l
 debugger  3, _CurrentCheck

   LEA.l   _CurPtr(a5), a0
   MOVE.l   (a0), a1
   MOVE.l   d0, (a1)+  ; Put the 2 new tags
   MOVE.l   d1, (a1)+  ;
   MOVE.l   a1, (a0)   ; Set the new value...
   CLR.l    (a1)+      ; And finish the taglist
   CLR.l    (a1)       ;
   RTS

 endfunc   3


 name      "TagListID", "()"
 flags     LongResult
 amigalibs
 params
 debugger  4, _CurrentCheck

   MOVE.l   (a5), d0  ; Get TagPtr
   RTS

 endfunc   4


 name      "ResetTagList", "()"
 flags
 amigalibs
 params    d0_l, d1_l
 debugger  5, _InitCheck

   LEA.l   _CurPtr(a5), a0
   MOVE.l   (a5), (a0)     ; Get TagPtr
   MOVE.l   (a0), a1
   MOVE.l   d0, (a1)+  ; Put the 2 new tags
   MOVE.l   d1, (a1)+  ;
   MOVE.l   a1, (a0)   ; Set the new value...
   CLR.l    (a1)+      ; And finish the taglist
   CLR.l    (a1)       ;
   RTS

 endfunc   5

 name      "ChangeTag", "()"
 flags
 amigalibs
 params    d0_l, d1_l, d2_l
 debugger  6, _CurrentCheck

   MOVEA.l  (a5), a0   ; Get TagPtr
   LSL.l    #3, d0
   ADD.l    d0, a0
   MOVE.l   d1, (a0)+  ; Put the 2 new tags
   MOVE.l   d2, (a0)   ;
   RTS

 endfunc   6

;
; And the common part
;

 base
  Dc.l 0
  Dc.l 0

 endlib


 startdebugger

_InitCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  RTS


_CurrentCheck:
  TST.l   _MemPtr(a5)
  BEQ      Error0
  TST.l   _CurPtr(a5)
  BEQ      Error2
  RTS


Error0: debugerror "InitTagList() don't have been called before or can't correctly setup"
Error2: debugerror "ResetTagList() must be called at least one time before"

 enddebugger

