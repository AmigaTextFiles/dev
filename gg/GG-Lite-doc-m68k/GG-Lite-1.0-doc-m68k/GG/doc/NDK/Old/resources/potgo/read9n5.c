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

/* An example of using the potgo.resource to read pins 9 and 5 of
 * port 1 (the non-mouse port).  This bypasses the gameport.device.
 * When the right button on a mouse plugged into port 1 is pressed,
 * the read value will change.
 *
 * Use of port 0 (mouse) is unaffected.
 *
 * Lattice use lc -b1 -cfist -v -y. Link with amiga.lib and lc.lib.
 */
#include <exec/types.h>
#include <libraries/dos.h>
#include <proto/all.h>
#include <stdio.h>

#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }  /* really */
#endif

struct PotgoBase *PotgoBase;
ULONG potbits;
UWORD value;

#define UNLESS(x) if(!(x))
#define UNTIL(x)  while(!(x))

#define OUTRY 1L<<15
#define DATRY 1L<<14
#define OUTRX 1L<<13
#define DATRX 1L<<12

void main(int argc,char **argv)
{
        UNLESS(PotgoBase=(struct PotgoBase *)OpenResource("potgo.resource"))
            return;
        printf("PotgoBase is at $%lx\n",PotgoBase);

        potbits=AllocPotBits(OUTRY|DATRY|OUTRX|DATRX);
        /* Get the bits for the right and middle mouse buttons
           on the alternate mouse port. */

        if(potbits != (OUTRY|DATRY|OUTRX|DATRX))
            {
            printf("Pot bits are already allocated! %lx\n",potbits);
            FreePotBits(potbits);
            return;
            }

        WritePotgo(0xFFFFFFFFL,potbits);
        /* Set all ones in the register (masked by potbits) */

        UNTIL(SIGBREAKF_CTRL_C & SetSignal(0L,0L))
            /* until CTRL-C is pressed */
            {
            value=*(UWORD *)0x00DFF016;
            /* Read word at $DFF016 */
            printf("POTINP = $%lx\n",value & potbits);
            /* Show what was read (restricted to our allocated bits) */
            }

        FreePotBits(potbits);
}

