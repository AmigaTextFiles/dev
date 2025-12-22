head	0.5;
access;
symbols;
locks
	MORB:0.5; strict;
comment	@# @;


0.5
date	97.09.09.00.07.05;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.08.29.18.01.10;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.25.11.59.06;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.31.57;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.25.35;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.28;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.5
log
@Correction d'un chti bug dedans MergeCopperLists().
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Copper routine
* $Id: Copper.s 0.4 1997/08/29 18:01:10 MORB Exp MORB $
*

_CopperTable:
         ds.l      1
_CurrentCopperTable:
         ds.l      1
_Wait255Addr:
         ds.l      1
_Wait255:
         ds.b      1
         even

_MergeCopperLists:
         movem.l   d0-7/a0-6,-(a7)

         move.l    #$00960000,d1

         lea       _Wait255Addr,a0
         move.l    (a0),d0
         beq.s     .Schglubulu

         move.l    d0,a1
         move.l    d1,(a1)

.Schglubulu:

         clr.l     (a0)
         sf        _Wait255

         lea       _CopperRepairBuffer,a0

.Loop:
         move.l    (a0)+,d0
         beq.s     RepairDone
         move.l    d0,a1
         move.l    d1,(a1)+
         move.l    d1,(a1)+
         move.l    d1,(a1)
         bra.s     .Loop

RepairDone:
         move.l    _CopperTable(pc),_CurrentCopperTable
         lea       _CopperRepairBuffer,a5
         lea       _MergeCopTmp,a6

CTLoop:
         move.l    a6,a1
         move.l    _CurrentCopperTable(pc),a4
         lea       4(a4),a0

.InitLoop:
         move.l    (a0)+,d0
         bmi.s     InitDone
         move.l    d0,a2
         sf        d0

.Loop:
         move.l    a2,d1
         beq.s     .Done
         move.w    ce_YPos(a2),d1
         beq.s     .Done
         bpl.s     .CheckPrev
         move.l    a2,a3
         tst.w     ce_Type(a2)
         sne       d0
         move.l    (a2),a2
         bra.s     .Loop

.CheckPrev:
         tst.b     d0
         beq.s     .Done
         move.l    a3,a2

.Done:
         move.l    a2,(a1)+
         move.l    ce_YPos(a2),(a1)+
         bra.s     .InitLoop
InitDone:
         moveq     #-1,d0
         move.l    d0,(a1)

         move.l    (a4),a4
         moveq     #0,d6
         moveq     #0,d2

         moveq     #$20,d3   ; <----- provisoire (définitif)

.Loop:
         move.l    a6,a0
         moveq     #0,d7
         bset      #31,d7
         not.l     d7

.LLoop:
         move.l    (a0)+,d0
         beq.s     .Couin
         bmi.s     .ProcessEntry
         move.l    (a0)+,d1
         cmp.l     d7,d1
         bgt.s     .LLoop
         move.l    d1,d7
         move.l    d0,a2
         move.l    a0,d4
         bra.s     .LLoop
.Couin:
         addq.l    #4,a0
         bra.s     .LLoop

.ProcessEntry:
         cmp.l     #$00fffffe,d7
         bne.s     .NonRien
         st        _Wait255
.NonRien:

         swap      d7

         tst.b     _Wait255
         bne.s     .W255Ok

         move.w    #256,d0
         cmp.w     d0,d7
         bcs.s     .W255Ok

         st        _Wait255
         tst.w     d6
         bne.s     .Block
         move.l    #$ffe1fffe,(a4)+
         bra.s     .W255Ok

.Block:
         sub.w     d6,d0
         mulu      d5,d0
         lea       (a4,d0.l),a0
         move.l    #$ffe1fffe,(a0)
         move.l    a0,_Wait255Addr

.W255Ok:

         move.l    d4,a0
         subq.l    #8,a0

         move.w    ce_Type(a2),d0
         bpl.s     .Long

         cmp.w     d7,d3
         beq.s     .Chain
         move.w    d7,d3

         move.l    ce_Data(a2),d0
         bsr.s     InsertCopperJump

         move.l    d0,a3

         bra.s     .NextEntry

.Chain:
         move.l    ce_Data(a2),d0

         move.w    #$86,d1
         swap      d1
         move.w    d0,d1
         move.l    d1,(a3)+
         swap      d0
         move.w    #$84,d1
         swap      d1
         move.w    d0,d1
         move.l    d1,(a3)
         swap      d0

         move.l    d0,a3

         bra.s     .NextEntry

.Long:
         bne.s     .Break

         move.l    a0,a6
         move.l    ce_Data(a2),d4
         move.l    d4,d0

         moveq     #0,d3

         tst.l     ce_SubType(a2)
         beq.s     .NoMansLand
         move.l    ce_BytesPerLine(a2),d5
         move.w    d3,d1
         move.w    d7,d3

         cmp.w     d7,d1
         ble.s     .NoMansLand

         sub.w     d1,d3
         mulu      d5,d3
         add.l     d3,d0

         move.w    d7,d3

.NoMansLand:
         bsr.s     InsertCopperJump
         move.l    d4,a4
         move.w    d3,d6
         moveq     #0,d2
         moveq     #0,d3

.NextEntry:
         move.l    (a2),a1
         move.l    a1,(a0)
         move.l    ce_YPos(a1),4(a0)
         bra.s     .Loop

.Break:
         move.l    ce_Data(a2),d0
         beq.s     .Terminate

         bsr.s     InsertCopperJump

         move.l    ce_CopperTable(a2),_CurrentCopperTable
         bra.s     CTLoop

.Terminate:
         bsr.s     TerminateChain

         tst.w     d6
         bne.s     .AllDone
         moveq     #-2,d0
         move.l    d0,(a4)
.AllDone:

         clr.l     (a5)
         movem.l   (a7)+,d0-7/a0-6
         rts

TerminateChain:
         tst.l     d2
         beq.s     .Done

         move.w    #$86,d1
         swap      d1
         move.w    d2,d1
         move.l    d1,(a3)+
         swap      d2
         move.w    #$84,d1
         swap      d1
         move.w    d2,d1
         move.l    d1,(a3)

.Done:
         rts

InsertCopperJump: ; d0=Dest
         bsr.s     TerminateChain

         tst.l     d6
         beq.s     NoMansLand

         moveq     #CET_BREAK,d1
         cmp.w     ce_Type(a2),d1
         beq.s     .Late

         moveq     #CET_LATE,d1
         cmp.w     ce_Type(a2),d1
         bne.s     .NoLate

.Late:
         move.l    d0,a1
         move.l    #$c9fffe00,d1
         move.b    d7,d1
         ror.l     #8,d1

         move.l    d1,8(a1)
.NoLate:

         sub.w     d6,d7
         mulu      d5,d7
         move.l    a4,a3
         add.l     d7,a3
         add.l     d5,a3

         subq.l    #8,a3
         subq.l    #4,a3

         move.l    a3,(a5)+

         move.w    #$86,d1
         swap      d1
         move.w    d0,d1
         move.l    d1,(a3)+
         swap      d0
         move.w    #$84,d1
         swap      d1
         move.w    d0,d1
         move.l    d1,(a3)+
         move.l    #$008a0000,(a3)+
         swap      d0

         move.l    a3,d2
         rts

NoMansLand:
         move.l    #$01fffe00,d1
         move.b    d7,d1
         ror.l     #8,d1
         move.l    d1,(a4)+

         moveq     #CET_BREAK,d2
         cmp.w     ce_Type(a2),d2
         beq.s     .Late

         moveq     #CET_LATE,d2
         cmp.w     ce_Type(a2),d2
         bne.s     .NoLate

.Late:
         move.l    d0,a1
         or.l      #$c80000,d1
         move.l    d1,8(a1)

.NoLate:

         move.w    #$86,d1
         swap      d1
         move.w    d0,d1
         move.l    d1,(a4)+
         swap      d0
         move.w    #$84,d1
         swap      d1
         move.w    d0,d1
         move.l    d1,(a4)+
         move.l    #$008a0000,(a4)+
         swap      d0
         move.l    a4,d2
         rts
@


0.4
log
@MergeCopperLists() sauvegarde tous les registres (utile pour Scrolling())
@
text
@d6 1
a6 1
* $Id: Copper.s 0.3 1997/08/25 11:59:06 MORB Exp MORB $
d137 1
a137 1
         sub.w     d3,d0
d139 3
a141 3
         lea       (a4,d0.l),a3
         move.l    #$ffe1fffe,(a3)
         move.l    a3,_Wait255Addr
@


0.3
log
@Changement d'origine ($20 au lieu de $29), et passage des CET_BREAK en late
@
text
@d6 1
a6 1
* $Id: Copper.s 0.2 1997/08/22 18:31:57 MORB Exp MORB $
d20 1
a20 1
         move.l    a6,-(a7)
d236 1
a236 1
         move.l    (a7)+,a6
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d92 1
a92 1
         moveq     #$29,d3   ; <----- provisoire (définitif)
d262 4
d270 1
d311 3
a313 2
         tst.w     ce_Type(a2)
         bpl.s     .NoLate
d319 1
@


0.1
log
@Gnaaa
@
text
@d6 1
a6 2
* $Revision$
* $Date$
@


0.0
log
@*** empty log message ***
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d5 3
a7 1
* Copper routines
@
