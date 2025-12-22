/*
**      $VER: ioblix/board.h 37.3 (7.4.99)
**
**      include file for access to IOBlix board
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_BOARD_H
#define IOBLIX_BOARD_H

struct IOBlixBoard {
    UBYTE ib_pad0;          /* these next entries are now obsolete          */
    UBYTE ib_pad1;
    UBYTE ib_Special;       /* interrupt enable register, see below         */
};

/*
The register ib_Special is the most important register on the IOBlix board, as
it is responsible for all interrupts. By setting the correct value you can
enable or disable all interrupts from the board. If this register is left in its
bootup state then NO interrupts from the board will ever happen!

Currently just these three bits are defined. Everything else must be left AS-IS!
*/

/* enable all interrupts */
#define ISPB_IRQ_ALL        7
#define ISPF_IRQ_ALL        (1 << ISPB_IRQ_ALL)
/* enable interrupts from audio module, ISPF_IRQ_ALL must also be set */
#define ISPB_IRQ_AUDIO      6
#define ISPF_IRQ_AUDIO      (1 << ISPB_IRQ_AUDIO)
/* enable interrupts from EtherNet module, ISPF_IRQ_ALL must also be set */
#define ISPB_IRQ_ETHER      5
#define ISPF_IRQ_ETHER      (1 << ISPB_IRQ_ETHER)

#endif /* IOBLIX_BOARD_H */

