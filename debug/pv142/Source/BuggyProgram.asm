   ;This program is buggy, if you try to run it normally it will crash
   ;See the 'debug' file for an example to debug this program

   addsym

SysBase        equ   4
;_LVOAllocMem   equ   -198
;_LVOFreeMem    equ   -210


StartProgram:
      moveq    #0,d1
      moveq    #100,d0

loop: addq.l   #1,d1
      dbra     d0,loop

      bsr      Sub1
      beq.s    theend
      bsr      Sub2
      bsr      Sub3

theend:
      moveq    #0,d0
      rts

Sub1:
      move.l   #100,d0
      moveq    #0,d1
      move.l   (SysBase).w,a6
      jsr      _LVOAllocMem(a6)
      lea      Block(pc),a0
      move.l   d0,(a0)
      rts

Sub2:
      moveq    #0,d0
      moveq    #1,d1
      moveq    #2,d2
      moveq    #3,d3
      moveq    #4,d4
      moveq    #5,d5
      moveq    #6,d6
      moveq    #7,d7
      move.l   Block(pc),a0
      illegal
      move.l   d0,(a0)+
      move.l   d1,(a0)+
      move.l   d2,(a0)+
      move.l   d3,(a0)+
      move.l   d4,(a0)+
      move.l   d5,(a0)+
      move.l   d6,(a0)+
      move.l   d7,(a0)+
      rts

Sub3:
      move.l   #64,d0
      move.l   Block(pc),a1
      move.l   (SysBase).w,a6
      jsr      _LVOFreeMem(a6)
      rts

Block:   dc.l  0

      END
