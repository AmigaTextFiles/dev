; Siepinski Triange, random method
; ROMv5 and later, 32kB

_CPU    v5.vcpu

_INL    extsysv2.def
_INL    extsysvars.def

_VAR    FC_Main #$20A0
_VAR    TableXY #$20A0

; -----------------------

_VAR    random  #129

WORD    coordXY #0      ; auto-declaration variables
WORD    mask2   #$7f7f
WORD    Table   TableXY

BYTE    PosX    #0
BYTE    PosY    #8

_ORG    FC_Main

        DC_B    #40,  #4
        DC_B     #6, #64
        DC_B    #75, #64

; -- Clear screen -----

_RUN    ; if no parameter, run address
        ; is auto-calculated
        
        LDWI    SYS_SetMemory
        STW     sysFn

        LDI     #0
        ST      sysArg[1] ; copy value
_LAB #11        
        LDI     #160      ; lenght area
        ST      sysArg[0] ; copy count (c)
    
        LDW     PosX
        STW     sysArg[2] ; dest addr (c)
       
        SYS     SYS_SetMemory_Cycles
        
        INC     PosY
        LD      PosY
        XORI    #128
        BNE     #11

; -- random point ------
        
_LAB #1
        LDWI    #$04a7  ; SYS_Random
        STW     sysFn
        
        SYS     #34
        ANDI    #$3f
        STW     random

        LDWI    #$0687  ; SYS_LSRW6
        STW     sysFn

        LD      random
        LSLW
        ADDW    random  ; quick *3
        SYS     #48
        LSLW            ; (>>6) <<1
        ADDW    Table
        DEEK
        ADDW    coordXY
        STW     coordXY

        LDI     #62
        POKE    coordXY ; Draw point

        LDWI    #$0600  ; SYS_LSRW1
        STW     sysFn
        LDW     coordXY
        SYS     #48
        ANDW    mask2
        STW     coordXY

        BRA     #1

; -----------------------
