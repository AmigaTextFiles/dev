*-Revision Header-**********************************************************
*                                                                          *
*    Project: ReadSega                                 _____       ____    *
*                                                     /    |\    /|    \   *
*    Version: 1.0                                    /     | \  / |     \  *
*                                                   /      |  \/  |     /  *
*       File: ReadSega.s                           /-------|      |-----   *
*                                                 /        |      |     \  *
*     Author: Alastair M. Robinson               /         |      |      \ *
*                                                                          *
****Revision: 0014                                                © - 1995 *
*                                                                          *
****************************************************************************
*            *                                                             *
*    Date    *                          Comment                            *
*            *                                                             *
****************************************************************************
*            *                                                             *
* 20.05.1995 * File created to provide easy access to a MegaDrive control  *
*            * pad.  'Two-back' averaging added to eliminate stray buttons!*
*            *                                                             *
* 19.11.1996 * Two-back averaging no longer required, since a new delay    *
*            * system, as used in lowlevel.library for clocking a CD³²     *
*            * controller, eliminates stray buttons, and reduces the time  *
*            * for which interrupts are Disable()d.                        *
*************************************************************-RevisionTail-*


* ReadSega.s
* ~~~~~~~~~~
* Bits 0-7 refer to port 0, and bits 16-23 to port 1.
* The bits are mapped as follows:
* 76543210
* SACBRDLU  N.B.  bits 0-5 can be read from an unmodified control pad.
* Bits 6 & 7 are only valid if the controller has had wires 5 & 7 exchanged,
* and the 'ReadFourButtons' flag is set.

ReadGamePorts
        movem.l a6,-(a7)

        moveq   #0,d0
        move.w  $dff00c,d0
        bsr     DecodeJoyDat

        btst    #7,$bfe001
        bne     .notjoy1buttonb
        bset    #4,d0
.notjoy1buttonb

        btst    #6,$dff016
        bne     .notjoy1buttonc
        bset    #5,d0

.notjoy1buttonc
        move.w  #$e000,$dff034

        move.l  d0,-(a7)
        move.l  4,a6
        jsr     _LVODisable(a6)
        move.l  (a7)+,d0

        bsr     Delay

        btst    #7,$bfe001
        bne     .notjoy1buttona
        bset    #6,d0

.notjoy1buttona

        btst    #6,$dff016
        bne     .notjoy1buttons
        bset    #7,d0

.notjoy1buttons

        move.w  #$f000,$dff034

        move.l  d0,-(a7)
        move.l  4,a6
        jsr     _LVOEnable(a6)
        move.l  (a7)+,d0

.dontreadfour

        move.l  d0,d3
        moveq   #0,d2

        movem.l (a7)+,a6
        rts

DecodeJoyDat
        and.w   #$303,d0
        move.w  d0,d1
        lsl.w   #8,d0
        lsr.w   #8,d1
        or.b    d1,d0

        move.w  d0,d1
        lsr.w   #1,d1
        eor.w   d1,d0
        and.w   #$303,d0

        move.b  d0,d1
        lsr.w   #6,d0
        or.b    d1,d0
        rts

Delay
        lea     $bfe001,a6
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        tst.b   (a6)
        rts

