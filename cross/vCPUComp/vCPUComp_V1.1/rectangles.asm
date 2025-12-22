; Macros:

; _RUN x    - Address of start code.
; _ORG x    - Address where it will be uploaded the compiled code
;             in Gigatron RAM.
;             You can use a few _ORG macros for different codes in one source.
; _VAR char - Declaration of variable (a..z, A..Z).
;             Use variable not declarated is possible but that always = 0.
; _LAB x    - Label for jump, only digit char, exp: #10, max 255.
;             Except CALL and CALLI instruction!
; _OBJ path - Add another compiled code, exp: _OBJ test.gt1.
;             RUN code for this file is ignored.

; "x" can be in DEC, HEX or BIN. BIN max. 255(dec)
; Exp. in:
; DEC: #10
; HEX: #$aa
; BIN: #%1001011

; Simle example code
; Put rectangles on random places on the screen

_RUN #32672
_ORG #32672

_VAR A #0
_VAR B #%110  ; binary digit can by max to 255(dec) 

_LAB #3
        LD   @B
        ANDI #127
        ST   #$81

        LD   #$7
        ANDI #63
        ADDI #8   ; Y += 8 - adjust to 8 page
        ST   #$82

        LD   #$8
        ANDI #63
        ST   #$83

        LD   #$81
        ST   #$84 ; temp_X = X

        LDI  #200
        ST   #$86 ; lenght Y 

_LAB #2
        LDI  #224
        ST   #$85 ; lenght X 

        LD   #$84
        ST   #$81 ; X = temp_X

_LAB #1
        LD   #$83 ; restore color
        POKE #$81 ; put pixel at X,Y

        INC  #$81 ; increment X
        INC  #$85 ; increment temporary X

        LD   #$85
        BNE #1    ; line finished?

        INC #$82  ; increment Y
        INC #$86  ; increment temporary Y

        LD  #$86
        BNE #2    ; rectangle finished?

        BRA #3    ; start again, and again
