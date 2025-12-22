*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Ripolin generator
* $Id: Ripolin.s 0.2 1997/11/06 21:07:28 MORB Exp MORB $
*

;fs "_Ripolin"
_Ripolin:
	 lea       MntRipolinData(pc),a0
	 lea       RipolinBuf,a1

	 moveq     #0,d0
	 move.l    #$2909fffe,d1
	 moveq     #0,d2
	 moveq     #0,d3
	 moveq     #0,d4

	 addq.l    #1,a0
	 move.b    (a0)+,d2
	 move.b    (a0)+,d3
	 move.b    (a0)+,d4

	 swap      d2
	 swap      d3
	 swap      d4

	 sub.l     a5,a5

.Loop:
	 move.l    (a0)+,d0
	 bmi.s     .Done

	 move.l    a5,d5
	 move.l    d0,a5
	 sub.l     d5,d0

	 moveq     #0,d5
	 moveq     #0,d6
	 moveq     #0,d7

	 addq.l    #1,a0
	 move.b    (a0)+,d5
	 move.b    (a0)+,d6
	 move.b    (a0)+,d7

	 swap      d5
	 swap      d6
	 swap      d7

	 sub.l     d2,d5
	 sub.l     d3,d6
	 sub.l     d4,d7

	 divs.l    d0,d5
	 divs.l    d0,d6
	 divs.l    d0,d7

	 subq.w    #1,d0
.GnaLoop:
	 move.l    d0,a2
	 move.l    d1,a3
	 move.l    d5,a4

	 move.l    #$960000,(a1)+
	 move.l    d1,(a1)+
	 ;add.l     #$1000000,d1

	 swap      d2
	 move.b    d2,d0
	 and.w     #$f0,d0
	 move.b    d2,d1
	 and.w     #$f,d1
	 swap      d2

	 swap      d3
	 move.b    d3,d5
	 and.b     #$f,d5
	 lsl.b     #4,d1
	 or.b      d5,d1

	 move.b    d3,d5
	 and.b     #$f0,d5
	 lsr.b     #4,d5
	 or.b      d5,d0
	 swap      d3

	 swap      d4
	 move.b    d4,d5
	 and.b     #$f,d5
	 lsl.w     #4,d1
	 or.b      d5,d1

	 move.b    d4,d5
	 and.b     #$f0,d5
	 lsr.b     #4,d5
	 lsl.w     #4,d0
	 or.b      d5,d0
	 swap      d4

	 lea       4*4(a1),a1

	 move.w    #color+2*5,(a1)+
	 move.w    d0,(a1)+

	 move.w    #color+2*21,(a1)+
	 move.w    d0,(a1)+

	 move.l    #$01063220,(a1)+

	 move.w    #color+2*5,(a1)+
	 move.w    d1,(a1)+

	 move.w    #color+2*21,(a1)+
	 move.w    d1,(a1)+

	 move.l    #$01063020,(a1)+

	 move.w    #color+2*9,(a1)+
	 move.w    d0,(a1)+

	 move.w    #color+2*25,(a1)+
	 move.w    d0,(a1)+

	 move.w    #color+2*13,(a1)+
	 move.w    d0,(a1)+

	 move.l    #$01063220,(a1)+
	 move.w    #color+2*9,(a1)+
	 move.w    d1,(a1)+

	 move.w    #color+2*25,(a1)+
	 move.w    d1,(a1)+

	 move.w    #color+2*13,(a1)+
	 move.w    d1,(a1)+

	 move.l    #$01061020,(a1)+

	 move.l    #$960000,(a1)+
	 move.l    #$960000,(a1)+
	 move.l    #$960000,(a1)+

	 move.l    a4,d5
	 move.l    a3,d1
	 move.l    a2,d0

	 add.l     d5,d2
	 add.l     d6,d3
	 add.l     d7,d4
	 add.l     #$1000000,d1

	 dbf       d0,.GnaLoop

	 bra       .Loop

.Done:
	 move.l    #$960000,RipolinBuf+4
;fe
;fs "_BGRipolin"
_BGRipolin:
	 lea       BGRipolinData(pc),a0
	 lea       RipolinBuf+2*4,a1

	 moveq     #0,d0
	 moveq     #0,d2
	 moveq     #0,d3
	 moveq     #0,d4

	 addq.l    #1,a0
	 move.b    (a0)+,d2
	 move.b    (a0)+,d3
	 move.b    (a0)+,d4

	 swap      d2
	 swap      d3
	 swap      d4

	 sub.l     a5,a5

.Loop:
	 move.l    (a0)+,d0
	 bmi.s     .Done

	 move.l    a5,d5
	 move.l    d0,a5
	 sub.l     d5,d0

	 moveq     #0,d5
	 moveq     #0,d6
	 moveq     #0,d7

	 addq.l    #1,a0
	 move.b    (a0)+,d5
	 move.b    (a0)+,d6
	 move.b    (a0)+,d7

	 swap      d5
	 swap      d6
	 swap      d7

	 sub.l     d2,d5
	 sub.l     d3,d6
	 sub.l     d4,d7

	 divs.l    d0,d5
	 divs.l    d0,d6
	 divs.l    d0,d7

	 subq.w    #1,d0
.GnaLoop:
	 move.l    d0,a2
	 move.l    d1,a3
	 move.l    d5,a4

	 swap      d2
	 move.b    d2,d0
	 and.w     #$f0,d0
	 move.b    d2,d1
	 and.w     #$f,d1
	 swap      d2

	 swap      d3
	 move.b    d3,d5
	 and.b     #$f,d5
	 lsl.b     #4,d1
	 or.b      d5,d1

	 move.b    d3,d5
	 and.b     #$f0,d5
	 lsr.b     #4,d5
	 or.b      d5,d0
	 swap      d3

	 swap      d4
	 move.b    d4,d5
	 and.b     #$f,d5
	 lsl.w     #4,d1
	 or.b      d5,d1

	 move.b    d4,d5
	 and.b     #$f0,d5
	 lsr.b     #4,d5
	 lsl.w     #4,d0
	 or.b      d5,d0
	 swap      d4

	 ;lea       4*4(a1),a1

	 move.w    #color,(a1)+
	 move.w    d0,(a1)+

	 move.l    #$01061220,(a1)+

	 move.w    #color,(a1)+
	 move.w    d1,(a1)+

	 move.l    #$01063020,(a1)

	 lea       20*4(a1),a1

	 move.l    a4,d5
	 move.l    a3,d1
	 move.l    a2,d0

	 add.l     d5,d2
	 add.l     d6,d3
	 add.l     d7,d4

	 dbf       d0,.GnaLoop

	 bra       .Loop

.Done:
	 rts
;fe
;fs "Ripolin datas"
gnabg    = 32

MntRipolinData:
	 dc.l      $808080
	 dc.l      gnabg,$808080
	 dc.l      61+gnabg,$909090
	 dc.l      122+gnabg,$f0f0f0
	 dc.l      256,$f0f0f0
	 dc.l      -1

BGRipolinData:
	 dc.l      $f0f0f0
	 dc.l      121+gnabg,$f0f0f0
	 dc.l      121+16+gnabg,$b0d0a0
	 ;dc.l      125+gnabg,$beceae
	 ;dc.l      125+gnabg,$508030
	 ;dc.l      122+gnabg,$e0e0d0
	 dc.l      173+gnabg,$508030
	 dc.l      203+gnabg,$305000
	 dc.l      256,$204000
	 dc.l      -1
;fe
