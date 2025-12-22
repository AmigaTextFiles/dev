; Fire effect
; ROMv5 and later

_CPU v5.vcpu

_OBJ picture.gt1        ; add before compiled data

_INL extsysvars.def

_VAR FC_Main #$20A0
_VAR FC_Fill #$21A0
_VAR FC_Copy #$22A0
;_VAR FC_Fire #$0200
_VAR FC_Fire #$8200

_RUN FC_Main

_VAR Adres_RND  #133

_ORG FC_Main

        LDWI    #$2D30
        STW     Adres_RND

        PUSH

        LDWI    FC_Fill
        CALL    vAC

        LDWI    FC_Copy
        CALL    vAC

;        POP
;        RET

        LDWI    #$0B00
        STW     sysFn
        LDI     #2      ; gfx mode 2
        SYS     #80

        LDWI    #$0619
        STW     sysFn

        LDWI    FC_Fire
        CALL    vAC

; ---------------------

_VAR Adres      #129
_VAR Adres_H    #130
_VAR Adres_T    #131
_VAR Adres_TH   #132
_VAR Suma       #135
_VAR Suma_H     #136

_ORG FC_Fire

_LAB #1
        LDWI    #$1F30
        STW     Adres
_LAB #2
        LDW     Adres
        DEEK
        STW     Suma

        LDW     Adres
        ADDI    #255
        STW     Adres_T
        DEEK
        ADDW    Suma
        STW     Suma
        
        INC     Adres_T
        LDW     Adres_T
        DEEK
        ADDW    Suma
        STW     Suma

        INC     Adres_T
        LDW     Adres_T
        DEEK
        ADDW    Suma

        SYS     #52
        STW     Suma
        ANDI    #%00111111
        BEQ     #3

        SUBI    #1
_LAB #3
        POKE    Adres
        INC     Adres

        LD      Suma_H
        BEQ     #4
        SUBI    #1
_LAB #4
        POKE    Adres
        INC     Adres
        
        LD      Adres
        XORI    #112
        BNE     #2
        LDI     #$30
        ST      Adres

        LD      #$9
        XORW    #$e
        ANDI    #63
        ADDI    #48
        ST      Adres_RND
        LDI     #63
        POKE    Adres_RND

        INC     Adres_H
        LD      Adres_H
        XORI    #$2E
        BNE     #2

        BRA     #1

; ---------------------

_VAR d  #135
_VAR D  #136
_VAR s  #137
_VAR S  #138

_ORG FC_Fill

        LDWI    #$78A0
        STW     @s

        LDWI    #$0B03  ; SYS_SetMemory
        STW     #$22

        LDWI    #$0800  ; address of screen
        STW     @d

        LD      #0      ; color
        ST      #$25    ; copy value
_LAB #1        
        LD      @s      ; lenght area
        ST      #$24    ; copy count (c)
    
        LDW     @d
        STW     #$26    ; dest addr (c)
        
        SYS     #54
        
        INC     @D

        LD      @S      ; height area
        SUBI    #1
        ST      @S
        BNE     #1

        RET

; --------------------

_VAR L  #129
_VAR H  #130
        
_ORG FC_Copy

        LDWI    #$2E20
        STW     @d
        
        LDWI    #$53A0
        STW     @s

        LDI     #0
        ST      @H
        ST      @L
_LAB #1
        LDW     @s
        PEEK
        POKE    @d
        
        INC     @s
        INC     @d
        INC     @L
        LD      @L
        XORI    #96
        BNE     #1
        ST      @L

        LDI     #$20
        ST      @d

        LDI     #$A0
        ST      @s
        
        INC     @S
        INC     @D
        INC     @H
        LD      @H
        XORI    #44
        BNE     #1

        RET

