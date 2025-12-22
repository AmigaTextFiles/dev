/*
**      $VER: ioblix/extfifo.h 37.3 (7.4.99)
**
**      include file for access to IOBlix onboard FIFOs
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_EXTFIFO_H
#define IOBLIX_EXTFIFO_H 1

/* status flags for external FIFOs */
/* all flags are negative logic, ie WFIFOF_FULL set means FIFO is NOT full */

#define EXTFIFO_READ        0
#define EXTFIFO_WRITE       0
#define EXTFIFO_STATUS      1
#define EXTFIFO_REG_COUNT   2

struct ExtFIFORegisters {
    ULONG er_RegCount;
    volatile UBYTE *er_Regs[EXTFIFO_REG_COUNT];
};

#define fifo_read   er_Regs[EXTFIFO_READ]
#define fifo_write  er_Regs[EXTFIFO_WRITE]
#define fifo_status er_Regs[EXTFIFO_STATUS]

#define RFIFOB_FULL 0
#define RFIFOF_FULL (1 << RFIFOB_FULL)
#define RFIFOB_HFULL 1
#define RFIFOF_HFULL (1 << RFIFOB_HFULL)
#define RFIFOB_EMPTY 2
#define RFIFOF_EMPTY (1 << RFIFOB_EMPTY)

#define WFIFOB_FULL 4
#define WFIFOF_FULL (1 << WFIFOB_FULL)
#define WFIFOB_HFULL 5
#define WFIFOF_HFULL (1 << WFIFOB_HFULL)
#define WFIFOB_EMPTY 6
#define WFIFOF_EMPTY (1 << WFIFOB_EMPTY)

#endif /* IOBLIX_EXTFIFO_H */

