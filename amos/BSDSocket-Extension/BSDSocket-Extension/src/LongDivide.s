; d0 = value to be divided
; d1 = divisor
; returns:
; d0 = divided value
; d1 = remainder
LongDivideD0ByD1 MACRO
  CMP.L D0,D1
  BMI _LongDivide_StartDivide\@

  MOVE.L D0,D1
  MOVEQ #0,D0
  BRA _LongDivide_Skip\@

_LongDivide_StartDivide\@:

  MOVEM.L D2-D4,-(SP)
    MOVEQ #0,D2      ; remainder
    MOVE.L #31,D3    ; bit tracking
                     ; d4 tracks the status register

_LongDivide_ContinueDivide\@:
    ASL.L #1,D0
    SCS D4      ; bit that got rolled out
    AND.L #1,D4
    ROL.L #1,D2
    ADD.L D4,D2 ; roll the value onto the remainder

    MOVE.L D2,D4
    SUB.L D1,D4

    BMI _LongDivide_NotDivisible\@
    ADDQ #1,D0
    MOVE.L D4,D2

_LongDivide_NotDivisible\@:
    DBRA D3,_LongDivide_ContinueDivide\@
    MOVE.L D2,D1
  MOVEM.L (SP)+,D2-D4

_LongDivide_Skip\@:
  ENDM


