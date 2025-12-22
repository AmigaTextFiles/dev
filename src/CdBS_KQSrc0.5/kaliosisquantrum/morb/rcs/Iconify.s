head	0.1;
access;
symbols;
locks
	MORB:0.1; strict;
comment	@# @;


0.1
date	97.09.11.21.41.35;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.09.11.21.10.26;	author MORB;	state Exp;
branches;
next	;


desc
@@


0.1
log
@Première version complète que elle marche tout bien.
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Iconification routine
* $Id: Iconify.s 0.0 1997/09/11 21:10:26 MORB Exp MORB $
*

_Iconify:
         movem.l   d0-7/a0-6,-(a7)
         bsr       _SwitchToSystem
         move.l    (AbsExecBase).w,a6
         move.l    _SStack,d0
         CALL      UserState
         move.l    Gfx_Base,a6
         move.l    Int_Base,a1
         lea       ib_ViewLord(a1),a1
         CALL      LoadView
         CALL      DisownBlitter
         move.l    Int_Base,a6
         CALL      RemakeDisplay

         CALL      OpenWorkBench
         tst.l     d0
         beq.s     .OuinSnif
         move.l    d0,a0
         moveq     #0,d0
         move.b    sc_BarHeight(a0),d0
         addq.l    #1,d0

         sub.l     a0,a0
         pea       TAG_DONE
         move.l    d0,-(a7)
         pea       WA_Top
         move.l    d0,-(a7)
         pea       WA_Height
         pea       128.w
         pea       WA_Width
         pea       WinTitle
         pea       WA_Title
         pea       TRUE
         pea       WA_CloseGadget
         pea       TRUE
         pea       WA_DepthGadget
         pea       TRUE
         pea       WA_DragBar
         pea       TRUE
         pea       WA_RMBTrap
         pea       IDCMP_CLOSEWINDOW
         pea       WA_IDCMP
         move.l    a7,a1
         CALL      OpenWindowTagList
         lea       19*4(a7),a7
         move.l    d0,d7
         beq.s     .OuinSnif
         move.l    d0,a0

         move.l    (AbsExecBase).w,a6
         move.l    wd_UserPort(a0),a0
         CALL      WaitPort

         move.l    Int_Base,a6
         move.l    d7,a0
         CALL      CloseWindow


.OuinSnif:
         move.l    Gfx_Base,a6
         CALL      OwnBlitter
         sub.l     a1,a1
         CALL      LoadView
         move.l    (AbsExecBase).w,a6
         CALL      SuperState
         move.l    d0,_SStack
         bsr       _SwitchToCOUIN
         movem.l   (a7)+,d0-7/a0-6
         rts

WinTitle:
         dc.b      "COUIN",0
         even
@


0.0
log
@Couin paf. (Première version). Voilà.
@
text
@d6 1
a6 1
* $Id$
d8 74
@
