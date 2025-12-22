; get the effective address of something in extension memory
Dlea    MACRO
        MOVE.L ExtAdr+ExtNb*16(A5),\2
        ADD.W #\1-MB,\2
        ENDM

; load the base of extension memory into a register
Dload   MACRO
        MOVE.L ExtAdr+ExtNb*16(A5),\1
        ENDM

; wrap code that doesn't take arguments with these
PreserveStackInstruction MACRO
  MOVEM.L A2-A6/D6-D7,-(SP)
  ENDM
RestoreStackInstruction MACRO
  MOVEM.L (SP)+,A2-A6/D6-D7
  ENDM

; wrap code that takes arguments with these
PreserveStackFunction MACRO
  MOVEM.L A2/A4-A6/D6-D7,-(SP)
  ENDM
RestoreStackFunction MACRO
  MOVEM.L (SP)+,A2/A4-A6/D6-D7
  ENDM

; Push and pop the extension's data storage into A3
WithDataStorageToA3 MACRO
  MOVE.L A3,-(SP)
  Dload A3
  ENDM
EndDataStorage MACRO
  MOVE.L (SP)+,A3
  ENDM

EvenOutStringAddress MACRO
    MOVE.W \1,\2
    AND.W #$0001,\2
    ADD.W \2,\1
    ENDM

