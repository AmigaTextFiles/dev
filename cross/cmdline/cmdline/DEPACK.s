;ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บDepacker for executables packed with PRGPACK                                 บ
;ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ

                processor 6502
                org $0801

PACKEDADR       = $0 - PACKLEN
DEPACKADR       = $0334

strlen          = $02
bitcode         = $fb
srcl            = $fc
srch            = $fd
destl           = $fe
desth           = $ff

sys:            .byte $14,$08           ;Address of next instruction
                .byte $0a,$00           ;Line number(10)
                .byte $9e               ;SYS-token
                .byte $32,$30,$37,$30   ;2070 as ASCII
                .byte $20,"PRGPACK!",$00
                .byte $00,$00           ;Instruction address 0 terminates
                                        ;the basic program

start:          ldy #DEPACKLEN
copycode:       lda depacker-1,y        ;Copy depacker routine before the
                sta DEPACKADR-1,y       ;screen memory, to allow depacking
                dey                     ;to $0401-$ffff
                bne copycode
                sty srcl                ;Copy packed data to bottom of memory
                sty srch                ;to prevent it being overwritten by
                lda #<(packeddata+PACKLEN) ;the unpacked data
                sta destl
                lda #>(packeddata+PACKLEN)
                sta desth
                sei
                lda #$34
                sta $01
copydata:       lda destl
                bne cd_not1
                dec desth
cd_not1:        dec destl
                lda srcl
                bne cd_not2
                dec srch
cd_not2:        dec srcl
                lda (destl),y
                sta (srcl),y
                lda destl
                cmp #<packeddata
                bne copydata
                lda desth
                cmp #>packeddata
                bne copydata
                lda #<LOADADR
                sta destl
                lda #>LOADADR
                sta desth
                ldx #$00
                jmp DEPACKADR

depacker:
                rorg DEPACKADR
depackstart:    txa                             ;Time to get new bit-code?
                bne dp_nonew
                jsr dp_get
                sta bitcode
                ldx #$08                        ;Eight bits now...
dp_nonew:       dex                             ;Get one bit from the bitcode,
                lsr bitcode                     ;that tells whether the next
                bcs dp_string                   ;byte in the stream is an
                jsr dp_get                      ;unpacked byte or a string
                jsr dp_put
                jmp depackstart
dp_string:      jsr dp_get                      ;If it's a string, take its
                sta dp_copystrpos+1             ;offset and length
                jsr dp_get
                sta strlen
dp_copystring:  dec desth                       ;String copying loop
dp_copystrpos:  ldy #$00
                lda (destl),y
                inc desth
                ldy #$00
                jsr dp_put
                dec strlen
                bne dp_copystring
                jmp depackstart

dp_get:         lda (srcl),y                    ;Get byte at source pointer
                pha
                tya
                sta (srcl),y
                pla
                inc srcl
                bne dp_get2
                inc srch
                bne dp_get2
                ldx #$ff                        ;When source pointer wraps to
                txs                             ;$0, program has been depacked
                lda #$37
                sta $01
                cli
                jmp STARTADR
dp_get2:        sta $0400
                rts

dp_put:         sta (destl),y                   ;Put byte at destination
                inc destl                       ;pointer
                bne dp_put2
                inc desth
dp_put2:        rts

depackend:
                rend

DEPACKLEN       = depackend - depackstart

packeddata:     incbin packed.bin
