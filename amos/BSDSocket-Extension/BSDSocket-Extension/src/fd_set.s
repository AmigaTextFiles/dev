; fdset macros
EnsureValidFdset MACRO
    CMP.L #MaxFd_sets,\1
    BLT \2

    MOVE.L #Error_FdsetOutOfRange,D3
    RestoreStackFunction
    Ret_Int
    ENDM

EnsureValidFdsetBit MACRO
    CMP.L #64,\1
    BGE _EnsureValidFdsetBit_Fail\@
    BRA \2
_EnsureValidFdsetBit_Fail\@:
    MOVE.L \3,D3
    RestoreStackFunction
    Ret_Int
    ENDM

; LeaFdset fd_set reg,target
LeaFdset MACRO
    MOVE.L \1,-(SP)
    Dlea fd_sets,\2 ; base of all, these are longs
    ROL.L #3,\1     ; multiply by 8
    ADD.L \1,\2     ; add to base of all
    MOVE.L (SP)+,\1
    ENDM

; LeaFdsetForBit fd_set reg,target address,target bit in address
LeaFdsetForBit MACRO
  LeaFdset \1,\2 ; get fdset base address in \2
  MOVE.L D3,-(SP)
    MOVE.L \3,D3 ; Put target bit into D3
    ROR.L #5,D3  ; lop off the first 5 bits
    AND.L #$7,D3 ; only keep the top three
    ROL.L #2,D3  ; multiply by 4
    ADD.L D3,\2  ; add that value to the fdset address

    AND.L #$1F,\3 ; only keep 0-31 in \3

    MOVEQ #1,D3
    ROL.L \3,D3   ; shift that bit left as many as target
    MOVE.L D3,\3  ; put that in the target
  MOVE.L (SP)+,D3

  ENDM
