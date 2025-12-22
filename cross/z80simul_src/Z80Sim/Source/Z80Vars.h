/**************************************************************
**    Z80VARS.H      The main variable definitions for Z80S.c
**                   only!
**
**    PATHNAME:      DH0:CPGM/Z80/Z80Vars.h
**
**    FUNCTION:      Header file for Z80S.c
**
**    LAST CHANGED:  5/11/89
**
***************************************************************/

/* need to add a union of reg[] & dreg[] types! */

#ifndef  Z80VARS_H
# define  Z80VARS_H

IMPORT char *malloc(), *calloc(), *configptr;

# ifdef   ALLOCATE

struct   IntuiMessage   *message;
struct   FileHandle     *configfile;

UBYTE    n1, n2, byte1, byte2, byte3, byte4, altAF, altregs,
         IFF1_2, PORTS[ MAXDATA ],
         imode = 1, status = RUNNING,
         reg[ 18 ] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };

UWORD    addr = 0, dreg[ 5 ] = { 0,0,0,0,0 };

// Register value changed flags (for display usage only):

BOOL     sregchanged[18] = { 0, }; // 0 == FALSE
BOOL     dregchanged[5]  = { 0, }; // 0 == FALSE
       
int      Base = BIN, numbytes = 0;

char  strreg[ 18 ][ 10 ] = {

            "0000 0000", "0000 0000", "0000 0000",
            "0000 0000", "0000 0000", "0000 0000",
            "0000 0000", "0000 0000", "0000 0000",
            "0000 0000", "0000 0000", "0000 0000",
            "0000 0000", "0000 0000", "0000 0000",
            "0000 0000", "0000 0000", "0000 0000"
            };

char strdreg[ 4 ][ 20 ] = {

           "0000 0000 0000 0000", "0000 0000 0000 0000",
           "0000 0000 0000 0000", "0000 0000 0000 0000"
           };
                   
#else

IMPORT struct IntuiMessage *message;
IMPORT struct FileHandle   *configfile;

IMPORT UBYTE    n1, n2, byte1, byte2, byte3, byte4, altAF, altregs,
                IFF1_2, PORTS[ MAXDATA ],
                imode, status,
                reg[ 18 ];

IMPORT UWORD    addr, dreg[ 5 ];
IMPORT int      Base, numbytes;
IMPORT char     strreg[ 18 ][ 10 ];
IMPORT char     strdreg[ 4 ][ 20 ];

IMPORT BOOL sregchanged[18], dregchanged[5]; // register changed??

# endif

#endif

/* ---------------------- End of Z80Vars.h ------------------------ */
