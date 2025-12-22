/*
**      $VER: ioblix/ioblixser.h 37.3 (7.4.99)
**
**      include file for ioblixser.device
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_IOBLIXSER_H
#define IOBLIX_IOBLIXSER_H

#include <exec/io.h>

/* constants for SetCTRLLines */
#define SIOCMD_SETCTRLLINES     (CMD_NONSTD + 7)
#define SIOB_RTS                0
#define SIOF_RTS                (1 << SIOB_RTS)
#define SIOB_DTR                1
#define SIOF_DTR                (1 << SIOB_DTR)

#endif /* IOBLIX_IOBLIXSER_H */
