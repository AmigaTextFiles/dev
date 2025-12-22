; Siepinski Triange, random method
; ROMvX0, 32kB

_CPU    vx0.vcpu

_INL    extsysvars.def
_INL    extsysv1.def
_INL    extsysv2.def

_VAR    FC_Main #$20A0
_VAR    TableXY #$20A0

; -----------------------

BYTE    coordX  #0
BYTE    coordY  #0
WORD    Table   TableXY

_VAR    coordXY coordX

BYTE    PosX    #0
BYTE    PosY    #8

_ORG    FC_Main

        DC_B    #40,  #4
        DC_B     #6, #64
        DC_B    #75, #64

; -- Clear screen -----

_RUN
        LDWI    SYS_SetMemory
        STW     sysFn

        MOVQB   #0, SYS_SetMemory_CopyValue
_LAB #11        
        MOVQB   #160, SYS_SetMemory_CopyCount
    
        LDW     PosX
        STW     SYS_SetMemory_Destination
       
        SYS     SYS_SetMemory_Cycles
        
        INC     PosY
        CMPI    #128, PosY
        BNE     #11

; -- random point ------
 
        LDWI    SYS_LSRW6
        STW     sysFn
_LAB #1
        RANDW
        ANDI    #$3f
        MULW3
        SYS     SYS_LSRW6_Cycles
        LSLW            ; (>>6) <<1
        ADDW    Table
        DEEK
        ADDW    coordXY
        STW     coordXY

        POKEI   #62

        LSRB    coordX
        LSRB    coordY

        BRA     #1

; -----------------------
