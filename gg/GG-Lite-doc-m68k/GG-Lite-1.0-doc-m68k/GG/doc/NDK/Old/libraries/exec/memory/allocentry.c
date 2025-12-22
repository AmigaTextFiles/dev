/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

/* Compiled with Lattice C 5.04: LC -b1 -cfist -v -y
 * Linkage: blink from lib:c.o+allocentry.o to allocentry lib lib:lc.lib lib:amiga.lib
 */

#include <exec/types.h>
#include <exec/memory.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdio.h>
#include <stdlib.h>
#endif

#define ALLOCERROR 0x80000000

struct MemList *mymemlist;       /* pointer to a MemList */

/* define a new structure because C cannot initialize unions */
struct MyNeeds
{
    struct MemList  mn_head;     /* one entry in the header */
    struct MemEntry mn_body[3];  /* additional entries follow directly as *
                                  * part of the same data structure       */
} myneeds;

VOID main (VOID);

VOID main(VOID)
{
    myneeds.mn_head.ml_NumEntries = 4; /* 4! Since the MemEntry starts at 1! */
    
    myneeds.mn_body[0].me_Reqs   = MEMF_CHIP | MEMF_CLEAR;
    myneeds.mn_body[0].me_Length = 100000;

    myneeds.mn_body[1].me_Reqs   = MEMF_FAST | MEMF_CLEAR;
    myneeds.mn_body[1].me_Length = 200000;

    myneeds.mn_body[2].me_Reqs   = MEMF_PUBLIC;
    myneeds.mn_body[2].me_Length = 25000;

    /* saying 'struct MemEntry mn_body[3]' is simply a way of adding
     * extra MemEntry structures contiguously at the end of the first
     * such structure at the ned of the MemList. Thus members of the
     * MemList of type MemEntry can be referenced to in C as additional
     * members of the 'me[]' data structure.
     */

    mymemlist = (struct MemList *)AllocEntry((struct MemList *)&myneeds);

    if ((ULONG)mymemlist & ALLOCERROR)
    {                                     /* 'error' bit 31 is set */
       printf("AllocEntry FAILED\n");    /*       see below       */
       exit(200);
    }

    /* we got the memory we wanted. We can use FreeEntry() now */
    FreeEntry(mymemlist);
}
