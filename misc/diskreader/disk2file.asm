; basic disk2file
TRACKMODE=1
        include diskreader.asm
        moveq   #0,d7
.track	WRITEDOS d7
        addq.l  #1,d7
        cmp.w   #160,d7
        bne.s   .track
        rts
