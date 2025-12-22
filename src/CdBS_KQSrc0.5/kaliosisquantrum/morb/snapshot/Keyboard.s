*
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
