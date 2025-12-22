;mouseread.asm  17/12/97
;cHArRiOTt

                    SECTION NUM1,CODE
                    xdef           _ReadM


_ReadM:             MOVEQ          #$0,D0           ;0
                    BTST.L         #$6,$BFE001      ;peripheral data register A            0
                    BNE.S          L22A
                    MOVEQ          #$1,D0           ;1   LEFT
L22A:               BTST         #$A,$DFF016
                    BNE.S          L238
                    BSET.L         #$1,D0           ;2   RIGHT
L238:               BTST         #$8,$DFF016
                    BNE.S          L246
                    BSET.L         #$2,D0           ;3   BOTH
L246:               RTS

                    END