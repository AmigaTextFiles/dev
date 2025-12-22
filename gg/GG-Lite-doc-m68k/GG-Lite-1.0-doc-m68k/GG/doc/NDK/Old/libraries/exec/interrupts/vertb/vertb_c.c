;/* vertb_c.c - Execute me to compile/assemble me with Lattice 5.04
Asm -iH:include/ -overtb_a.o vertb_a.asm
LC -b1 -cfistq -v -y -j73 vertb_c.c
Blink FROM LIB:c.o,vertb_c.o,vertb_a.o TO vertb LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* Vertb_c.c - C module of interrupt server example
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
#include <exec/memory.h>
#include <exec/interrupts.h>
#include <hardware/custom.h>
#include <hardware/intbits.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL-C handling */
int chkabort(void) { return(0); }	/* really */
#endif

extern void VertBServer();     /* our assembler interrupt server */

struct Interrupt *VBInterrupt;
ULONG counter;

void main(int argc,char **argv)
    {
    ULONG finalcount;

    /* Allocate an Interrupt node structure: */
    if (NULL == (VBInterrupt = (struct Interrupt *)
            AllocMem((LONG)sizeof(struct Interrupt), MEMF_PUBLIC|MEMF_CLEAR)))
       {
       printf("Can't allocate interrupt structure\n");
       exit(RETURN_FAIL);
       }

    /* Initialize the Interrupt node: */
    VBInterrupt->is_Node.ln_Type = NT_INTERRUPT;
    VBInterrupt->is_Node.ln_Pri = -60;
    VBInterrupt->is_Node.ln_Name = "VertB-example";
    VBInterrupt->is_Data = (APTR)&counter;
    VBInterrupt->is_Code = VertBServer;

    /* put the new interrupt server into action: */
    AddIntServer(INTB_VERTB, VBInterrupt);
    printf("VBlank server will increment a counter every frame.\n");
    printf("Counter now zero - wait a few seconds then press CTRL-C\n");
    counter = 0L;

    Wait(SIGBREAKF_CTRL_C);

    finalcount = counter;
    printf("\n%ld vertical blanks occurred.\n",finalcount);

    RemIntServer(INTB_VERTB, VBInterrupt);
    FreeMem(VBInterrupt, sizeof(struct Interrupt));
    }
