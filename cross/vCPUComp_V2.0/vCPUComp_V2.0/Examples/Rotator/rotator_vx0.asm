; Blitter Storm effect
; ROMvX0, 64kB

_CPU    vx0.vcpu        ; ROM type

_INL    extsysvars.def  ; add extended SYS functions
_INL    extsysv2.def    ; and variables
_INL    extsysvx0.def

_VAR x          #129    ; definiton of varialbles
_VAR X          #130    ; all variables is global
_VAR y          #131
_VAR xx         #133
_VAR yy         #135
_VAR yyH        #136
_VAR offset     #139

_VAR ps         #143
_VAR sh_tbl     #144

_VAR loop       #147

_VAR FC_Main    #$20a0
_VAR FC_Rotate  #$5000

_VAR Table      #$21a0

_RUN FC_Main            ; start program address

; ------------------------

_ORG FC_Main            ; program block definition

        LDI     #0
        ST      ps              ; ps = 0

        MOVQB   #32, loop

        LDWI    Table
        STW     sh_tbl

        LDWI    #$1F1F
        STW     offset

        LDWI    #$0100
        STW     y
_LAB #1                         ; jump label
        LDW     y
        PEEK
        ADDI    #120
        POKE    y

        LD      y
        ADDI    #2
        ST      y
        
        XORI    #240
        BNE     #1

        LDWI    #$0101
        STW     x
        LDI     #40
        POKE    x

        LDWI    SYS_SetMode
        STW     sysFn
        LDI     SYS_SetMode_A___        ; gfx mode 3
        SYS     SYS_SetMode_Cycles

        LDWI    #$8020
        STW     x

        LDWI    SYS_SetMemory
        STW     sysFn

        MOVQB   #0, SYS_SetMemory_CopyValue
_LAB #2        
        MOVQB   #220, SYS_SetMemory_CopyCount
    
        LDW     x
        STW     SYS_SetMemory_Destination
       
        SYS     SYS_SetMemory_Cycles
        
        INC     X
        CMPI    #255, X
        BNE     #2

        CALLI   FC_Rotate
; ------------------------

_VAR sourceX    #149            ; more variables
_VAR sourceY    #150
_VAR destinX    #151
_VAR destinY    #152
_VAR temp       #157

_ORG FC_Rotate

_LAB #1                         ; jump label
        MOVQW   #10, y          ; for(y=10...

        LD      ps
        ANDI    #63             ; ps &= 31
        ADDW    sh_tbl
        DEEKA   yy
        BRA     #22             ; yy = shift + 160-111
_LAB #2
        ADDVI   #32, yy
        DC_B    yy
_LAB #22
        MOVQW   #5, x           ; for(x=5...

        ADDVB   temp, yy
        DC_B    y

        LD      yyH
        BRA     #33             ; xx = shift + 128-159
_LAB #3
        LD      xx
        ADDI    #32
_LAB #33
        ST      xx              ; xx += 32
;-----------------
        ST      destinX
        ADDW    y
        SUBW    x
        ST      sourceX

        ADDVB   sourceY, x
        DC_B    temp

        ADDBI   yy, destinY
        DC_B    #16

        LDW     sourceX
        SUBW    destinX

        BGT     #7      ; s < d, #5
        BEQ     #10

        ADDVW   destinX, destinX
        DC_B    offset
        ADDVW   sourceX, sourceX
        DC_B    offset
        LDI     SYS_MemCopyByte
        STW     sysFn
        LDWI    #$ffff  ;255
        STW     SYS_MemCopyByte_Src_step

        MOVB    sysArg[1], sourceY
        MOVB    sysArg[3], destinY
_LAB #4
        MOVB    SYS_MemCopyByte_Src, sourceX ; sXt
        MOVB    SYS_MemCopyByte_Dst, destinX ; dXt

        LDI     #32
        SYS     SYS_MemCopyByte_Cycles

        DEC     sysArg[1]
        DEC     sysArg[3]

        DBNE    #4, loop
        BRA     #10
;--------------------

_LAB #7
        LDI     SYS_CopyMemory
        STW     sysFn

        MOVB    sysArg[3], sourceY
        MOVB    sysArg[1], destinY
_LAB #6
        MOVB    SYS_CopyMemory_Src, sourceX
        MOVB    SYS_CopyMemory_Dst, destinX
        LDI     #32

        SYS     SYS_CopyMemory_Cycles

        INC     sysArg[1]
        INC     sysArg[3]

        DBNE    #6, loop
;-----------------

_LAB #10        
        MOVQB   #32, loop

        INC     x
        CMPI    #12, x
        BNE     #3              ; ... x<12; x++)
        
        DEC     y
        CMPI    #6, y
        BNE     #2              ; ... y>6; y--)

        ADDBI   ps, ps
        DC_B    #2
; -----------------------

        MOVQB   #191, X
_LAB #8
        MOVQB   #128, x
_LAB #9
        LDW     #$06
        DOKEV+  x        
        
        CMPI    #132, x
        BNE     #9
        
        INC     X
        CMPI    #195, X
        BNE     #8
        
        BRA     #1
; -----------------------

_ORG Table

DC_B    #81,  #1                ; add raw data
DC_B    #97,  #17               ; DC_B - BYTE, BYTE, BYTE, ...
DC_B    #89,  #9                ; DC_W - WORD, WORD, WORD, ...
DC_B    #105, #25               ; DC_S - string, exp: "Hello !"
DC_B    #85,  #5
DC_B    #101, #21
DC_B    #93,  #13
DC_B    #109, #29
DC_B    #83,  #3
DC_B    #99,  #19
DC_B    #91,  #11
DC_B    #107, #27
DC_B    #87,  #7
DC_B    #103, #23
DC_B    #95,  #15
DC_B    #111, #31

DC_B    #82,  #2
DC_B    #98,  #18
DC_B    #90,  #10
DC_B    #106, #26
DC_B    #86,  #6
DC_B    #102, #22
DC_B    #94,  #14
DC_B    #110, #30
DC_B    #84,  #4
DC_B    #100, #20
DC_B    #92,  #12
DC_B    #108, #28
DC_B    #88,  #8
DC_B    #104, #24
DC_B    #96,  #16
DC_B    #112, #32