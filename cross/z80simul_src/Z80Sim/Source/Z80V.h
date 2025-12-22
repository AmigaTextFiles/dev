/**************************************************************
*    Z80V.H         The main variable definitions for Z80MH.c
*                   only!
*
*    FUNCTION:      Header file for Z80MH.c
*
*    LAST CHANGED:  21-Apr-2001
*
***************************************************************
*
*/

#ifndef  Z80V_H
#define  Z80V_H

#ifdef   ALLOCATE
#define  GLOBAL_
#else
#define  GLOBAL_   extern
#endif

GLOBAL_   BOOL     sregchanged[18], dregchanged[5]; // added on 21-Apr-2001

GLOBAL_   struct   IntuiMessage   *message;
GLOBAL_   char     *malloc(), *calloc(), *configptr;
GLOBAL_   FILE     *configfile;

GLOBAL_   UBYTE    *mem;

GLOBAL_   UBYTE    n1, n2, byte1, byte2, byte3, byte4, altAF, altregs,
                   IFF1_2, PORTS[ ],
                   imode, status, reg[ ];

GLOBAL_   UWORD    addr, dreg[ ];  /* PC, SP, IX, IY */

GLOBAL_   ULONG    class;
GLOBAL_   USHORT   code;

GLOBAL_   int      Base, numbytes;

GLOBAL_   UBYTE    from[ ], to[ ], patt[ ];
#endif
