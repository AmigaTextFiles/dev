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

/* getsystime.c - get system time */
/* Lattice use -b1 - cfist -v -y */
/* Link with lc.lib, amiga.lib    */

#include <exec/types.h>
#include <devices/timer.h>
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }  /* really */
#endif

struct timerequest tr;
struct MsgPort *tport;
struct Message *msg;

void main(int argc,char **argv)
{
   LONG error;
   ULONG days,hrs,secs,mins,mics;

   /* Open the MICROHZ timer device */
   error = OpenDevice(TIMERNAME,UNIT_MICROHZ,(struct IORequest *) &tr,0);
   if(error) return;/* If the timer will not open then just return */

   tport=CreatePort(0,0);
   /* If we can't get a reply port then just quit */
   if(!tport)
        {
        CloseDevice((struct IORequest *) &tr );
        return;
        }

   /* Fill in the IO block with command data */
   tr.tr_node.io_Message.mn_Node.ln_Type = NT_MESSAGE;
   tr.tr_node.io_Message.mn_Node.ln_Pri  = 0;
   tr.tr_node.io_Message.mn_Node.ln_Name = NULL;
   tr.tr_node.io_Message.mn_ReplyPort    = tport;
   tr.tr_node.io_Command                 = TR_GETSYSTIME;

   /* Issue the command and wait for it to finish, then get the reply */
   DoIO((struct IORequest *) &tr);

   /* Get the results and close the timer device */
   mics=tr.tr_time.tv_micro;
   secs=tr.tr_time.tv_secs;
   DeletePort(tport);
   CloseDevice((struct IORequest *) &tr);

   /* Compute days, hours, etc. */
   mins=secs/60;
   hrs=mins/60;
   days=hrs/24;
   secs=secs%60;
   mins=mins%60;
   hrs=hrs%24;

   /* Display the time */
   printf("\nSystem Time (measured from Jan.1,1978)\n");
   printf("  Days   Hours  Minutes Seconds Microseconds\n");
   printf("%6ld %6ld %6ld %6ld %10ld\n",days,hrs,mins,secs,mics);

}      /* end of main */
