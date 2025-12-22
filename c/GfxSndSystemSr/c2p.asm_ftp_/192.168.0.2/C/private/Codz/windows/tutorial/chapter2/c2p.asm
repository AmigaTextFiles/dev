;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
       ; incdir "asminclude:"
        include "asminclude:exec/types.i"
        include "asminclude:graphics/gfx.i"
        

        xdef    WriteChunkyPixel256_Fast_v12

        section code,code

;**************************************************************
;*****  PROGRAMME:      CHUNKY TO PLANAR FAST
;*****  VERSION:        1.2 (version fast pour 060)
;*****  DATE:           12-4-1999
;*****
;*****  AUTEUR:         Sébastien Gréau
;*****                  Avenue des Fauvettes
;*****                  44390 Nort sur Erdre
;*****                  Tel: 02-40-29-57-44
;*****
;*****  COMMENTAIRE:    Top Speed!!!
;*****                  Routine adaptative.
;*****
;*****                  Attention:
;*****                  Ecran INTERLEAVED 256 couleurs obligatoire!
;*****                  32<=ChunkyWidth<=$7fe0 (multiple de 32)
;*****                  1<=ChunkyHeight<=$7fffffff (=nb de lignes)
;**************************************************************

;void __asm WriteChunkyPixel256_Fast_v12(register __a1 struct BitMap *,register __a0 UBYTE *,register __d0 LONG,register __d1 LONG,register __d2 WORD,register __d3 LONG);
;a1: struct BitMap
;a0: UBYTE *ChunkyScreenBase
;d0: LONG Left (multiple de 4)
;d1: LONG Top
;d2: WORD ChunkyWidth
;d3: LONG ChunkyHeight

	xdef	WriteChunkyPixel256_Fast_v12

WriteChunkyPixel256_Fast_v12:
        movem.l d0-d7/a0-a6,-(sp)

        lea     -8*4(sp),sp

        move.l  d3,-(sp)                ;CHEIGHT

        moveq   #0,d3
        move    bm_BytesPerRow(a1),d3
        move.l  d3,a5                   ;a5: BytesPerRow (8*SMOD)
        mulu    d3,d1

        lsr.l   #3,d3
        move.l  d3,a6                   ;a6: BytesPerRow/8 (SMOD)

        move.l  bm_Planes(a1),a1        ;pointe le plan 0 de la ligne 0
        lea     (a1,d1.l),a1            ;positionne sur la ligne Top
        add.l   d0,a1                   ;on ajoute left

        move.l  a1,a2                   ;adr temp debut de ligne
        add.l   a5,a1

        lsr     #5,d2                   ;CWIDTH/32
        move    d2,-(sp)
        move    #1,-(sp)                ;on fait un tour pour rien

        bra.b   C2P256_Fast_v1.2_Loop

;--------------------------------------------------------------

        cnop    0,8

C2P256_Fast_v1.2_Loop2:
        move.l  a2,a1
C2P256_Fast_v1.2_Loop:
        movem.l (a0)+,d0-d3
  ;      clr.l   (a0)+      pour effacer le chunky enlever les commentaires et enlever
  ;      clr.l   (a0)+      l'incrementation du movem (a fair ici et plus bas)
  ;      clr.l   (a0)+
  ;      clr.l   (a0)+



        sub.l   a6,a1
        move.l  8+7*4(sp),(a1)

        move.l  d1,d6
        move.l  d3,d7
        lsr.l   #4,d6
        lsr.l   #4,d7
        eor.l   d0,d6
        eor.l   d2,d7
        and.l   #$0f0f0f0f,d6
        and.l   #$0f0f0f0f,d7
        eor.l   d6,d0
        eor.l   d7,d2
        lsl.l   #4,d6
        lsl.l   #4,d7
        eor.l   d6,d1
        eor.l   d7,d3

        sub.l   a6,a1
        move.l  8+6*4(sp),(a1)

        move.l  d2,d6
        move.l  d3,d7
        lsr.l   #8,d6
        lsr.l   #8,d7
        eor.l   d0,d6
        eor.l   d1,d7
        and.l   #$00ff00ff,d6
        and.l   #$00ff00ff,d7
        eor.l   d6,d0
        eor.l   d7,d1
        lsl.l   #8,d6
        lsl.l   #8,d7
        eor.l   d6,d2
        eor.l   d7,d3

        sub.l   a6,a1
        move.l  8+5*4(sp),(a1)

        move.l  d2,d6
        move.l  d3,d7
        lsr.l   #1,d6
        lsr.l   #1,d7
        eor.l   d0,d6
        eor.l   d1,d7
        and.l   #$55555555,d6
        and.l   #$55555555,d7
        eor.l   d6,d0
        eor.l   d7,d1
        add.l   d6,d6
        add.l   d7,d7
        eor.l   d6,d2
        eor.l   d7,d3

        move.l  d1,a3
        move.l  d3,a4

        movem.l (a0)+,d4-d7
;        clr.l   (a0)+
;        clr.l   (a0)+
;        clr.l   (a0)+
;        clr.l   (a0)+
;        addq.l  #4,(a0)

        sub.l   a6,a1
        move.l  8+4*4(sp),(a1)

        move.l  d5,d1
        move.l  d7,d3
        lsr.l   #4,d1
        lsr.l   #4,d3
        eor.l   d4,d1
        eor.l   d6,d3
        and.l   #$0f0f0f0f,d1
        and.l   #$0f0f0f0f,d3
        eor.l   d1,d4
        eor.l   d3,d6
        lsl.l   #4,d1
        lsl.l   #4,d3
        eor.l   d1,d5
        eor.l   d3,d7

        sub.l   a6,a1
        move.l  8+3*4(sp),(a1)

        move.l  d6,d1
        move.l  d7,d3
        lsr.l   #8,d1
        lsr.l   #8,d3
        eor.l   d4,d1
        eor.l   d5,d3
        and.l   #$00ff00ff,d1
        and.l   #$00ff00ff,d3
        eor.l   d1,d4
        eor.l   d3,d5
        lsl.l   #8,d1
        lsl.l   #8,d3
        eor.l   d1,d6
        eor.l   d3,d7

        sub.l   a6,a1
        move.l  8+2*4(sp),(a1)

        move.l  d6,d1
        move.l  d7,d3
        lsr.l   #1,d1
        lsr.l   #1,d3
        eor.l   d4,d1
        eor.l   d5,d3
        and.l   #$55555555,d1
        and.l   #$55555555,d3
        eor.l   d1,d4
        eor.l   d3,d5
        add.l   d1,d1
        add.l   d3,d3
        eor.l   d1,d6
        eor.l   d3,d7

        swap    d4
        swap    d6
        move    d4,d1
        move    d6,d3
        move    d0,d4
        move    d2,d6
        move    d1,d0
        move    d3,d2
        swap    d4
        swap    d6

        sub.l   a6,a1
        move.l  8+1*4(sp),(a1)

        move.l  d4,d1
        move.l  d6,d3
        lsr.l   #2,d1
        lsr.l   #2,d3
        eor.l   d0,d1
        eor.l   d2,d3
        and.l   #$33333333,d1
        and.l   #$33333333,d3
        eor.l   d1,d0
        eor.l   d3,d2
        lsl.l   #2,d1
        lsl.l   #2,d3
        eor.l   d1,d4
        eor.l   d3,d6

        move.l  d0,8+7*4(sp)
        move.l  d2,8+6*4(sp)
        move.l  d4,8+5*4(sp)
        move.l  d6,8+4*4(sp)

        move.l  a3,d1
        move.l  a4,d3

        swap    d5
        swap    d7
        move    d5,d0
        move    d7,d2
        move    d1,d5
        move    d3,d7
        move    d0,d1
        move    d2,d3
        swap    d5
        swap    d7

        sub.l   a6,a1
        move.l  8+0*4(sp),(a1)+

        move.l  d5,d0
        move.l  d7,d2
        lsr.l   #2,d0
        lsr.l   #2,d2
        eor.l   d1,d0
        eor.l   d3,d2
        and.l   #$33333333,d0
        and.l   #$33333333,d2
        eor.l   d0,d1
        eor.l   d2,d3
        lsl.l   #2,d0
        lsl.l   #2,d2
        eor.l   d0,d5
        eor.l   d2,d7

        move.l  d1,8+3*4(sp)
        move.l  d3,8+2*4(sp)
        move.l  d5,8+1*4(sp)
        move.l  d7,8+0*4(sp)

        add.l   a5,a1
        subq.w  #1,(sp)
        bgt.w   C2P256_Fast_v1.2_Loop
        add.l   a5,a2
;        move    #$00f,$dff180
        move    2(sp),(sp)
c2p256_Fast_v1.2_Jump:
        subq.l  #1,4(sp)
        bmi.b   endC2P256_Fast_v1.2
        bgt.w   C2P256_Fast_v1.2_Loop2
        subq.w  #1,(sp)
        bgt.w   C2P256_Fast_v1.2_Loop2

        move.l  a2,a1
endC2P256_Fast_v1.2:
        sub.l   a6,a1
        move.l  8+7*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+6*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+5*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+4*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+3*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+2*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+1*4(sp),(a1)
        sub.l   a6,a1
        move.l  8+0*4(sp),(a1)

        lea     8*4+8(sp),sp

        movem.l (sp)+,d0-d7/a0-a6
        rts

        end
