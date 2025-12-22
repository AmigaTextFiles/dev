/* ------------------------------------------------------------------
    PSOP.H -- header file for A6 opcode parser
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

/* OPCODES */

#ifndef _PSOP_H
#define _PSOP_H

#define IMPLIED (0)
#define IMMEDIATE (1)
#define INDIRECT (2)
#define INDIRECT_Y (3)
#define INDIRECT_X (4)
#define ZEROPAGE (5)
#define ABSOLUTE (6)
#define ZEROPAGE_Y (7)
#define ABSOLUTE_Y (8)
#define ZEROPAGE_X (9)
#define ABSOLUTE_X (10)
#define RELATIVE (11)

#define ADRMODECOUNT (12)

#define NOUNDOCOPS (0)
#define UNDOCOPS (1)

void parseopcode(char *,char *);

#endif
