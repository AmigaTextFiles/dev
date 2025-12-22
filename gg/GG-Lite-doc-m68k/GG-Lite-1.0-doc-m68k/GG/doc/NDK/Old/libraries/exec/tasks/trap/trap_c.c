;/* trap_c.c - Execute me to assemble/compile me with Lattice 5.04
Asm -iH:include/ -otrap_a.o trap_a.asm
LC -b1 -cfistq -v -y -j73 trap_c.c
Blink FROM LIB:c.o,trap_c.o,trap_a.o TO trap LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* Trap_c.c - C module of sample integer divide-by-zero trap
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
 *
 */

#include <exec/types.h>
#include <exec/tasks.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }	/* really */
#endif

/* assembler trap code in trap_a.asm */
extern ULONG trapa(); 

APTR oldTrapCode;
ULONG countdiv0;

void main(int argc,char **argv)
    {
    struct Task *thistask;
    ULONG k,j;

    thistask = FindTask(NULL);

    /* Save our task's current trap code pointer */
    oldTrapCode = thistask->tc_TrapCode;

    /* Point task to our assembler trap handler code 
     * Ours will just count divide-by-zero traps, and
     * pass other traps on to the normal TrapCode
     */
    thistask->tc_TrapCode = (APTR)trapa;

    countdiv0 = 0L;
    /* Let's divide by zero a few times */
    for(k=0; k<4; k++) 
       {
       printf("dividing %ld by zero... ",k);
       j = k/0L;
       printf("did it\n");
       }
    printf("\nDivide by zero happened %ld times\n",countdiv0);
    
    /* Restore old trap code */
    thistask->tc_TrapCode = oldTrapCode;
    }


