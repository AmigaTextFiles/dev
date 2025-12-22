/* RND generatorius */
#asm
   blanks off
   section code
   xdef _rnd
_rnd  lea   rndseed,a0
      move.l   4(sp),d1
      tst.l d1
      ble.s setseed
      move.l   (a0),d0
      ADD.L d0,d0
      BHI.S over
      EORI.L   #$1D872B41,d0
over
      move.l d0,(a0)
      andi.l   #$FFFF,d0
      andi.l   #$FFFF,d1
      divu  d1,d0
      swap  d0
      ext.l d0
      rts
setseed  neg.l d1
      move.l   d1,(a0)
      rts

   section data
rndseed  dc.l  40
   section code
#endasm

