; Fire effect

_CPU vx0.vcpu

_INL extsysvars.def

_OBJ picture.gt1

_VAR FC_Main #$20A0
_VAR FC_Fill #$21A0
_VAR FC_Copy #$22A0
_VAR FC_Fire #$23A0
;_VAR FC_Fire #$0200

_RUN FC_Main

_VAR Adres_RND  #133

_ORG FC_Main

        LDWI    #$0B00
        STW     sysFn
        LDI     #2      ; gfx mode 2
        SYS     #80

;        PUSH

        CALLI   FC_Fill
        CALLI   FC_Copy
        
;        SYS     #$80

;        POP
;        RET

        CALLI   FC_Fire

; ---------------------

_VAR Adres      #129
_VAR Adres_H    #130
;_VAR Adres_T    #131
;_VAR Adres_TH   #132
_VAR Suma       #135
_VAR Suma_H     #136
_VAR Dana1      #137
_VAR Dana2      #139
_VAR Dana3      #141

_ORG FC_Fire

        LDWI    #$2D30
        STW     Adres_RND

        LDWI    #$0619
        STW     sysFn
_LAB #1
        MOVQB   #$1F, Adres_H
_LAB #2
        MOVQB   #$30, Adres
_LAB #3
        LDW     Adres
        DEEKA   Dana1
        ADDI    #255
        DEEKA   Dana2
        ADDI    #1
        DEEKA   Dana3
        ADDI    #1
        DEEK
        ADDW    Dana1
        ADDW    Dana2
        ADDW    Dana3

        SYS     #52
        STW     Suma
        ANDI    #%00111111
        ST      Suma
        BEQ     #4
        DEC     Suma
_LAB #4
        LD      Suma_H
        BEQ     #5
        DEC     Suma_H
_LAB #5
        LDW     Suma
        DOKEV+  Adres
        
        CMPI    #112, Adres
        BNE     #3

        RANDW
        ANDI    #63
        ADDW    Adres_RND
        POKEI   #63

        INC     Adres_H
        CMPI    #$2E, Adres_H
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
        DEEKV+  s
        DOKEV+  d

        INC     L
        CMPI    #48, L
        BNE     #1
        ST      @L

        LDI     #$20
        ST      @d
        LDI     #$A0
        ST      @s
        
        INC     @D
        INC     @H
        CMPI    #44, H
        BNE     #1

        RET

