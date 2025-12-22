head	0.8;
access;
symbols;
locks
	MORB:0.8; strict;
comment	@# @;


0.8
date	98.04.26.12.40.05;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	98.03.30.18.56.38;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	98.02.13.17.20.19;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	98.02.13.16.50.48;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	98.02.13.16.20.22;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	98.02.13.16.13.09;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	98.02.13.13.37.39;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	98.02.13.13.08.23;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	98.02.12.18.57.53;	author MORB;	state Exp;
branches;
next	;


desc
@@


0.8
log
@Fixed a bug which was breaking the keyboard routines when a dead key was hit. There is still a problem with shifted dead keys.
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Keyboard routines
* $Id: Keyboard.s 0.7 1998/03/30 18:56:38 MORB Exp MORB $
*

KBLENGTH           = 128
KBABLENGTH         = 512
KBRBLENGTH         = 64

;fs "_InstallKBHandler"
_InstallKBHandler:
	 move.l    _RepeatDelay,_RepeatCounter

	 move.l    Low_Base,a6
	 lea       _KBHandler,a0
	 sub.l     a1,a1
	 CALL      AddKBInt
	 move.l    d0,_KBHandle
	 rts
_KBHandle:
	 ds.l      1
;fe
;fs "_RemoveKBHandler"
_RemoveKBHandler:
	 move.l    Low_Base,a6
	 move.l    _KBHandle,a1
	 CALL      RemKBInt
	 rts
;fe

;fs "_KBHandler"
_KBHandler:
	 movem.l   d2-7/a2-4,-(a7)

	 moveq     #0,d2
	 bsr.s     _FeedKBInput

	 movem.l   (a7)+,d2-7/a2-4
	 rts
;fe
;fs "_KBHandleRepeat"
_KBHandleRepeat:
	 move.b    _RepeatKey(pc),d0
	 beq.s     .Done

	 move.l    _RepeatCounter(pc),d1
	 beq.s     .Ok
	 subq.l    #1,d1
	 move.l    d1,_RepeatCounter
	 rts

.Ok:
	 move.l    _RepeatPeriod,_RepeatCounter
	 move.l    #IEQUALIFIER_REPEAT,d2
	 bsr.s     _FeedKBInput

.Done:
	 rts

_RepeatKey:
	 ds.b      1
	 even
_RepeatCounter:
	 ds.l      1
_RepeatDelay:
	 dc.l      15
_RepeatPeriod:
	 dc.l      3
;fe
;fs "_FeedKBInput"
_FeedKBInput:
	 or.w      KBKQual(pc),d2

	 move.b    d0,d1
	 and.b     #$7f,d1
	 and.b     #$80,d0
	 beq.s     .NotReleased

	 clr.b     _RepeatKey
	 move.l    _RepeatDelay,_RepeatCounter

.NotReleased:

	 cmp.b     #$60,d1
	 bne.s     .NotLShift
	 tst.b     d0
	 beq.s     .LShiftSet
	 and.w     #~IEQUALIFIER_LSHIFT,d2
	 bra.s     .Done
.LShiftSet:
	 or.w      #IEQUALIFIER_LSHIFT,d2
	 bra.s     .Done
.NotLShift:

	 cmp.b     #$61,d1
	 bne.s     .NotRShift
	 tst.b     d0
	 beq.s     .RShiftSet
	 and.w     #~IEQUALIFIER_RSHIFT,d2
	 bra.s     .Done
.RShiftSet:
	 or.w      #IEQUALIFIER_RSHIFT,d2
	 bra.s     .Done
.NotRShift:

	 cmp.b     #$64,d1
	 bne.s     .NotLAlt
	 tst.b     d0
	 beq.s     .LAltSet
	 and.w     #~IEQUALIFIER_LALT,d2
	 bra.s     .Done
.LAltSet:
	 or.w      #IEQUALIFIER_LALT,d2
	 bra.s     .Done
.NotLAlt:

	 cmp.b     #$65,d1
	 bne.s     .NotRAlt
	 tst.b     d0
	 beq.s     .RAltSet
	 and.w     #~IEQUALIFIER_RALT,d2
	 bra.s     .Done
.RAltSet:
	 or.w      #IEQUALIFIER_RALT,d2
	 bra.s     .Done
.NotRAlt:

	 cmp.b     #$63,d1
	 bne.s     .NotCtrl
	 tst.b     d0
	 beq.s     .CtrlSet
	 and.w     #~IEQUALIFIER_CONTROL,d2
	 bra.s     .Done
.CtrlSet:
	 or.w      #IEQUALIFIER_CONTROL,d2
	 bra.s     .Done
.NotCtrl:

	 cmp.b     #$62,d1
	 bne.s     .NotCaps
	 tst.b     d0
	 beq.s     .CapsSet
	 and.w     #~IEQUALIFIER_CAPSLOCK,d2
	 bra.s     .Done
.CapsSet:
	 or.w      #IEQUALIFIER_CAPSLOCK,d2
	 bra.s     .Done
.NotCaps:

	 tst.b     d0
	 bne.s     .Done
	 move.w    KBPrev1(pc),KBPrev2
	 move.b    KBKCode+1(pc),KBPrev1
	 move.b    KBKQual+1(pc),KBPrev1+1

	 move.b    d1,_RepeatKey

	 move.b    d1,KBKCode+1

	 cmp2.b    KBArrows,d1
	 bcs.s     .Ascii

	 move.l    _KBRawLast(pc),a0
	 lea       KBRawEnd,a1
	 move.l    _KBRawNext(pc),a2
	 move.b    d1,(a0)+
	 cmp.l     a1,a0
	 bcs.s     .RawBufOk
	 lea       KBRawBeg,a0
.RawBufOk:

	 cmp.l     a0,a2
	 beq.s     .Done

	 move.l    a0,_KBRawLast
	 bra.s     .Done

.Ascii:
	 move.l    Keymap_Base,a6
	 lea       KBHIe(pc),a0
	 lea       KBHBuf,a1
	 move.l    #KBLENGTH,d1
	 sub.l     a2,a2
	 CALL      MapRawKey
	 tst.l     d0
	 beq.s     .Done
	 bpl.s     .Ok
	 move.l    #KBLENGTH,d0
.Ok:

	 subq.l    #1,d0
	 lea       KBAscEnd,a2
	 move.l    _KBAscNext(pc),a3
	 move.l    _KBAscLast(pc),a1
	 lea       KBHBuf,a0

.AscLoop:
	 move.l    a1,a4
	 move.b    (a0)+,(a1)+

	 cmp.l     a2,a1
	 bcs.s     .AscBufOk
	 lea       KBAscBeg,a1
.AscBufOk:

	 cmp.l     a1,a3
	 bne.s     .NotFull
	 move.l    a4,a1
	 bra.s     .Full
.NotFull:
	 dbf       d0,.AscLoop

.Full:
	 move.l    a1,_KBAscLast

.Done:
	 and.l     #~IEQUALIFIER_REPEAT,d2
	 move.w    d2,KBKQual
	 rts

KBArrows:
	 dc.b      $4c,$4f

_KBRawLast:
	 dc.l      KBRawBeg
_KBRawNext:
	 dc.l      KBRawBeg

_KBAscLast:
	 dc.l      KBAscBeg
_KBAscNext:
	 dc.l      KBAscBeg

KBHIe:
	 dc.l      0
	 dc.b      IECLASS_RAWKEY,0
KBKCode:
	 dc.w      0
KBKQual:
	 dc.w      0
KBPrev1:
	 dc.b      0,0
KBPrev2:
	 dc.b      0,0

	 ds.b      TV_SIZE
	 even
;fe

;fs "_ClearKeyBuffers"
_ClearKeyBuffers:
	 bsr.s     _ClearAscKeyBuffer
;fe
;fs "_ClearRawKeyBuffer"
_ClearRawKeyBuffer:
	 lea       KBRawBeg,a0
	 lea       _KBRawLast(pc),a1
	 move.l    a0,(a1)+
	 move.l    a0,(a1)
	 rts
;fe
;fs "_ClearAscKeyBuffer"
_ClearAscKeyBuffer:
	 lea       KBAscBeg,a0
	 lea       _KBAscLast(pc),a1
	 move.l    a0,(a1)+
	 move.l    a0,(a1)
	 rts
;fe

;fs "_GetRawKey"
_GetRawKey:
	 movem.l   a0-1,-(a7)
	 move.w    #$28,$dff09a
	 move.w    #$2700,sr

	 move.l    _KBRawLast(pc),a0
	 move.l    _KBRawNext(pc),a1
	 moveq     #0,d0

	 cmp.l     a0,a1
	 beq.s     .Empty

	 move.b    (a1)+,d0
	 cmp.l     #KBRawEnd,a1
	 bcs.s     .BufOk
	 lea       KBRawBeg,a1
.BufOk:
	 move.l    a1,_KBRawNext

	 move.w    #$2000,sr
	 move.w    #$8028,$dff09a
	 movem.l   (a7)+,a0-1
	 rts

.Empty:
	 move.w    #$2000,sr
	 move.w    #$8028,$dff09a
	 movem.l   (a7)+,a0-1
	 moveq     #-1,d0
	 rts
;fe
;fs "_GetAsciiKey"
_GetAsciiKey:
	 movem.l   a0-1,-(a7)
	 move.w    #$28,$dff09a
	 move.w    #$2700,sr

	 move.l    _KBAscLast(pc),a0
	 move.l    _KBAscNext(pc),a1
	 moveq     #0,d0

	 cmp.l     a0,a1
	 beq.s     .Empty

	 move.b    (a1)+,d0
	 cmp.l     #KBAscEnd,a1
	 bcs.s     .BufOk
	 lea       KBAscBeg,a1
.BufOk:
	 move.l    a1,_KBAscNext
	 cmp.b     #$d,d0
	 bne.s     .Ok
	 moveq     #$a,d0
.Ok:
	 move.w    #$2000,sr
	 move.w    #$8028,$dff09a
	 movem.l   (a7)+,a0-1
	 rts

.Empty:
	 move.w    #$2000,sr
	 move.w    #$8028,$dff09a
	 movem.l   (a7)+,a0-1
	 moveq     #-1,d0
	 rts
;fe
@


0.7
log
@Added key repetition
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.6 1998/02/13 17:20:19 MORB Exp MORB $
d57 1
a57 2
	 ;move.l    #IEQUALIFIER_REPEAT,d2
	 moveq     #0,d2
d69 1
a69 1
	 dc.l      20
d155 3
a160 3
	 move.w    KBPrev1(pc),KBPrev2
	 move.b    KBKCode+1(pc),KBPrev1
	 move.b    KBKQual+1(pc),KBPrev1+1
d189 1
a213 1

d277 3
d293 3
a295 1
.Done:
d300 2
d309 3
d329 2
d335 2
@


0.6
log
@Changement de la taille du buffer ascii
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.5 1998/02/13 16:50:48 MORB Exp MORB $
d15 2
d38 39
a76 1
	 move.w    KBKQual(pc),d2
d81 6
d157 2
d221 1
a222 2

	 movem.l   (a7)+,d2-7/a2-4
d277 1
d292 1
d296 1
d302 1
d320 1
d324 1
@


0.5
log
@Le truc se bloque en cas de buffer plein
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.4 1998/02/13 16:20:22 MORB Exp MORB $
d10 1
a10 1
KBABLENGTH         = 10      ; 512
@


0.4
log
@Filtrag
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.3 1998/02/13 16:13:09 MORB Exp MORB $
d10 1
a10 1
KBABLENGTH         = 512
d121 1
d127 4
d132 1
d148 1
d153 1
d155 1
d160 7
d169 1
@


0.3
log
@Correction d'un pti bug dans GetRawKey et GetAsciiKey
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.2 1998/02/13 13:37:39 MORB Exp MORB $
d248 4
@


0.2
log
@Correction de quelques trucs nazes
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.1 1998/02/13 13:08:23 MORB Exp MORB $
d114 1
d116 1
a116 1
	 cmp2.b    KBArrows,d0
d121 1
a121 1
	 move.b    d0,(a0)+
d215 1
a215 1
	 moveq     #-1,d0
d218 1
a218 1
	 beq.s     .Done
d228 4
d237 1
a237 1
	 moveq     #-1,d0
d240 1
a240 1
	 beq.s     .Done
d248 4
a251 1
.Done:
@


0.1
log
@Tout implémenté (quasiment)
@
text
@d6 1
a6 1
* $Id: Keyboard.s 0.0 1998/02/12 18:57:53 MORB Exp MORB $
d27 1
a27 1
	 move.l    _KBHandle,d0
d70 1
a70 1
.LALtSet:
d81 1
a81 1
.RALtSet:
d130 2
a131 2
	 lea       KBHBuf(pc),a1
	 moveq     #KBLENGTH,d1
d136 1
a136 1
	 moveq     #KBLENGTH,d0
d160 3
d186 1
@


0.0
log
@Gbluuuuu
@
text
@d6 1
a6 1
* $Id$
d9 3
d13 229
@
