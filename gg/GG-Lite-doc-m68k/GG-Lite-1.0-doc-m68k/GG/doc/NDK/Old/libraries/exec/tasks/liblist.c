;/* liblist.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 liblist.c
Blink FROM LIB:c.o,liblist.o TO liblist LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* LibList.c - lists libraries currently in system
 *
 * Copyright (c) 1990 Commodore-Amiga, Inc.
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

#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/libraries.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }	/* really */
#endif

#define ARRAYSIZE 64L
extern struct ExecBase *SysBase;

void main(int argc,char **argv)
    {
    struct Library *lib;   
    ULONG count = 0L, k;
    char *names[ARRAYSIZE];

    Forbid();
    /* Note - printing within Forbid() would break the forbidden state */
    for ( lib = (struct Library *)SysBase->LibList.lh_Head;
          NULL != lib->lib_Node.ln_Succ;
          lib = (struct Library *)lib->lib_Node.ln_Succ)
        {
        if (count < ARRAYSIZE) names[count++] = lib->lib_Node.ln_Name;
        }
    Permit();

    printf("Libraries currently in system:\n");
    for (k=0; k<count; k++) printf(" %s\n",names[k]);    
    if (count == ARRAYSIZE) printf("Error: array overflow\n");
    }
