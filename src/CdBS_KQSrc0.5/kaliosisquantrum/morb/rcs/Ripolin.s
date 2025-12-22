head	0.2;
access;
symbols;
locks
	MORB:0.2; strict;
comment	@# @;


0.2
date	97.11.06.21.07.28;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.09.09.00.13.41;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.09.08.18.26.16;	author MORB;	state Exp;
branches;
next	;


desc
@@


0.2
log
@Ajout de ripolin dans la couleur 0.
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Ripolin generator
* $Id: Ripolin.s 0.1 1997/09/09 00:13:41 MORB Exp MORB $
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
         dc.l      $888888
         dc.l      gnabg,$888888
         dc.l      61+gnabg,$999999
         dc.l      122+gnabg,$ffffff
         dc.l      256,$ffffff
         dc.l      -1

BGRipolinData:
         dc.l      $ffffff
         dc.l      122+gnabg,$ffffff
         dc.l      173+gnabg,$508030
         dc.l      256,$204000
         dc.l      -1
;fe
@


0.1
log
@Terminu et débuggu MakeRipolin().
@
text
@d6 1
a6 1
* $Id: Ripolin.s 0.0 1997/09/08 18:26:16 MORB Exp MORB $
d9 3
a11 2
_MakeRipolin:
         lea       RipolinData(pc),a0
d15 1
a15 1
         move.l    #$2929fffe,d1
d68 1
a68 2
         add.l     #$1000000,d1
         move.l    #$01063020,(a1)+
d102 2
d139 2
d156 1
a156 1
         bra.s     .Loop
d160 116
d277 2
d281 1
a281 1
RipolinData:
d288 8
@


0.0
log
@Première version pas fini beuark.
@
text
@d6 1
a6 1
* $Id$
d10 1
a10 1
         lea       RipolinsData(pc),a0
d13 2
d24 6
d31 2
a32 2
         move.l    (a0)+,d1
         beq.s     .Done
d34 3
a36 2
         sub.l     d0,d1
         move.l    d1,d0
a46 4
         sub.l     d2,d5
         sub.l     d3,d6
         sub.l     d4,d7

d51 3
a53 3
         divu      d0,d5
         divu      d0,d6
         divu      d0,d7
d55 94
d150 1
d152 1
d155 1
d157 1
d159 1
a159 1
RastersData:
d161 3
a163 3
         dc.l      67,$888888
         dc.l      128,$999999
         dc.l      134,$ffffff
a165 1

@
