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

/* Compiled with Lattice 5.04: LC -b1 -cfist -v -y
 * Linkage: blink from lib:c.o+allocate.o to Allocate lib lib:lc.lib lib:amiga.lib
 */

#include <exec/types.h>
#include <exec/memory.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdio.h>
#include <stdlib.h>
#endif

#define BLOCKSIZE 4000     /* or whatever you want */
VOID main(VOID);

VOID main(VOID)
{
    struct MemHeader *mh;
    struct MemChunk  *mc;
    APTR   block1;
    APTR   block2;

    /* Get the MemHeader needed to keep track of our new block */
    mh = (struct MemHeader *)AllocMem((LONG)sizeof(struct MemHeader), MEMF_CLEAR);
    if (!mh)
        exit(10);

    /* Get the actual block the above MemHeader will manage */
    mc = (struct MemChunk *)AllocMem(BLOCKSIZE, 0);
    if (!mc)
        {
        FreeMem(mh, (LONG)sizeof(struct MemHeader)); exit(10);
        }

    mh->mh_Node.ln_Type = NT_MEMORY;
    mh->mh_Node.ln_Name = "myname";
    mh->mh_First = mc;
    mh->mh_Lower = (APTR)mc;
    mh->mh_Upper = (APTR)(BLOCKSIZE + (ULONG)mc);
    mh->mh_Free  = BLOCKSIZE;

    /* Set up first chunk in the freelist */
    mc->mc_Next  = NULL;
    mc->mc_Bytes = BLOCKSIZE;

    block1 = (APTR)Allocate(mh,20);
    block2 = (APTR)Allocate(mh, 314);

    printf("mh = $%lx mc=$%lx\n", mh, mc);
    printf("block1 = $%lx block2 = $%lx\n", block1, block2);

    FreeMem(mh, (LONG)sizeof(struct MemHeader));
    FreeMem(mc, (LONG)BLOCKSIZE);
}
