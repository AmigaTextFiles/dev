/*
**      $VER: ioblix/ieee1284.h 37.3 (7.4.99)
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_IEEE1284_H
#define IOBLIX_IEEE1284_H 1

struct IEEE1284StateMachine {
    UWORD sm_Mode;
    UWORD sm_Phase;
};

#define IEEE1284_MODE_NIBBLE            0
#define IEEE1284_MODE_BYTE              (1 << 0)
#define IEEE1284_MODE_COMPAT            (1 << 8)
#define IEEE1284_MODE_BECP              (1 << 9)        /* Bounded ECP mode */
#define IEEE1284_MODE_ECP               (1 << 4)
#define IEEE1284_MODE_ECPRLE            (IEEE1284_MODE_ECP | (1 << 5))
#define IEEE1284_MODE_ECPSWE            (1 << 10)       /* Software-emulated */
#define IEEE1284_MODE_EPP               (1 << 6)
#define IEEE1284_MODE_EPPSL             (1 << 11)       /* EPP 1.7 */
#define IEEE1284_MODE_EPPSWE            (1 << 12)       /* Software-emulated */
#define IEEE1284_DEVICEID               (1 << 2)        /* This is a flag */
#define IEEE1284_EXT_LINK               (1 << 14)       /* This flag causes the extensibility link to be requested, using bits 0-6. */
#define IEEE1284_ADDR                   (1 << 13)       /* This is a flag */
#define IEEE1284_DATA                   0               /* So is this */

#define IEEE1284_PH_FWD_DATA            1
#define IEEE1284_PH_FWD_IDLE            2
#define IEEE1284_PH_TERMINATE           3
#define IEEE1284_PH_NEGOTIATION         4
#define IEEE1284_PH_HBUSY_DNA           5
#define IEEE1284_PH_REV_IDLE            6
#define IEEE1284_PH_HBUSY_DAVAIL        7
#define IEEE1284_PH_REV_DATA            8
#define IEEE1284_PH_ECP_SETUP           9
#define IEEE1284_PH_ECP_FWD_TO_REV      10
#define IEEE1284_PH_ECP_REV_TO_FWD      11

/* old obsolete definitions */
#define IEEE1284_DEVICE_STATUS          0x00
#define IEEE1284_DEVICE_INFO            0x04

#endif /* IOBLIX_IEEE1284_H */

