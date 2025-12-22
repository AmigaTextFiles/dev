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

sys:            .byte $0b,$08           ;Seuraavan k„skyn osoite
                .byte $d0,$07           ;Rivinumero
                .byte $9e               ;SYS-tokeni
                .byte $32,$30,$36,$31   ;2061 ASCIIna
                .byte $00
                .byte $00,$00

start:          cld
                ldy #DEPACKLEN
copycode:       lda depacker-1,y
                sta DEPACKADR-1,y
                dey
                bne copycode
                sty srcl
                sty srch
                lda #<(packeddata+PACKLEN)
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
depackstart:    txa                             ;Otetaanko uusi bitti-koodi
                bne dp_nonew
                jsr dp_get
                sta bitcode
                ldx #$08                        ;Kahdeksan bitti„ j„ljell„
dp_nonew:       dex
                lsr bitcode                     ;Stringi vai tav. tavu?
                bcs dp_string
                jsr dp_get
                jsr dp_put
                jmp depackstart
dp_string:      jsr dp_get                         ;Otetaan stringin positio
                sta dp_copystrpos+1
                jsr dp_get                         ;Ja pituus
                sta strlen
dp_copystring:  dec desth
dp_copystrpos:  ldy #$00
                lda (destl),y
                inc desth
                ldy #$00
                jsr dp_put
                dec strlen
                bne dp_copystring
                jmp depackstart

dp_get:         lda srcl
                bne dp_get2
                lda srch
                bne dp_get2
                lda #$37
                sta $01
                cli
                jmp STARTADR
dp_get2:        lda (srcl),y
                inc srcl
                bne dp_get3
                inc srch
dp_get3:        rts

dp_put:         sta (destl),y
                inc destl
                bne dp_put2
                inc desth
dp_put2:        rts

depackend:
                rend

DEPACKLEN       = depackend - depackstart

packeddata:     incbin packed.bin
