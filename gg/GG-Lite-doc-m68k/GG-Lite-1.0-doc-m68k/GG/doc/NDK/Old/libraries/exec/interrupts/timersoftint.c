;/* timersoftint.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 timersoftint.c
Blink FROM LIB:c.o,timersoftint.o TO timersoftint LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/*
 * TimerSoftInt.c - timer.device software interrupt example
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
#include <exec/interrupts.h>
#include <exec/memory.h>
#include <devices/timer.h>
#include <libraries/dos.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL-C handling */
int chkabort(void) { return(0); }	/* really */
#endif

#define MIC_DELAY  1000

/* our functions */
void *tsoftcode(void);  /* our timer softint code */
void cleanexit(UBYTE *, LONG);
void cleanup(void);
void begintr(struct timerequest *);

/* Opens and allocations we must clean up.
 * Note - casts of timerequest pointers to (struct IOStdReq *)
 * in this example are to eliminate compiler warnings.
 * A timerequest starts with but is larger than an IOStdReq.
 */ 
struct Interrupt    *tint = NULL;
struct timerequest  *treq = NULL;
struct MsgPort      *tport = NULL;
BOOL OpenedTimer = FALSE;

/* Global variables shared with the softint code
 * If our tsoftcode was in assembler, we could use is_Data
 * pointer instead to tell softint code where shared data is
 */
#define OFF 0
#define ON  1
#define STOPPED 2
BOOL SFlag=OFF;
ULONG counter;

char tportname[] = "RKM_timersoftint";

void main(int argc, char **argv)
   {
   ULONG endcount;

   if(!argc)  exit(RETURN_FAIL);  /* CLI only example...Uses printf */

   /* Allocate our MsgPort and Interrupt structures
    * Since we can't use CreatePort, we'll build the port ourselves.
    * Create Port creates a PA_SIGNAL and allocs a signal.
    * We want a PA_SOFTINT port;
    */

   if(!(tport = (struct MsgPort *)
       AllocMem(sizeof(struct MsgPort),MEMF_PUBLIC|MEMF_CLEAR)))
           cleanexit("Can't allocmem msgport\n",RETURN_FAIL);

   if(!(tint = (struct Interrupt *)
       AllocMem(sizeof(struct Interrupt),MEMF_PUBLIC|MEMF_CLEAR)))
           cleanexit("Can't allocmem interrupt\n",RETURN_FAIL);


   /* Set up the (software) interrupt structure.
    * Note that we are priority 0.  Software interrupts may only be
    * priority -32, -16, 0, +16, or +32.  Also note that the
    * correct node type for a software interrupt is NT_INTERRUPT.
    * (NT_SOFTINT is an internal flag of Exec's)
    * This is the same setup as that for a software interrupt
    * which you Cause().  If our interrupt code was in assembler,
    * you could initialize is_Data here to contain a pointer
    * to shared data structures.  An assembler software interrupt
    * routine would receive the is_Data pointer in A1.
    */
   tint->is_Code = (VOID (*)())tsoftcode;  /* Our softint routine */
   tint->is_Node.ln_Type = NT_INTERRUPT;
   tint->is_Node.ln_Pri = 0;


   /* Set up the PA_SOFTINT msgport */
   tport->mp_Node.ln_Type = NT_MSGPORT;
   tport->mp_Node.ln_Name = (char *)tportname;
   tport->mp_Flags = PA_SOFTINT;
   tport->mp_SigTask = (struct Task *)tint;  /* Ptr to interrupt struct */

   /* Not using CreatePort, so we must add the port ourselves */
   AddPort(tport);

   /* Now Create the IO request */
   if(!(treq=(struct timerequest *)
      CreateExtIO(tport,sizeof(struct timerequest))))
         cleanexit("Can't create ioreq\n", RETURN_FAIL);

   /* Open the timer device - Note 0 return means success */
   if(OpenDevice("timer.device",UNIT_MICROHZ,(struct IOStdReq *)treq,0))
      cleanexit("Can't open timer device\n",RETURN_FAIL);

   OpenedTimer = TRUE;    /* Flag for closing in cleanup */

   /* Now, let's do something with it */
   counter = 0L;
   SFlag = ON;
   begintr(treq);         /* Prime the pump with first timer request */

   printf("Timer softint is counting milliseconds. Press CTRL-C to exit...");
   Wait(SIGBREAKF_CTRL_C);

   endcount = counter;
   printf("\n\nSoftint counted %ld milliseconds\n",endcount);
   printf("Stopping timer and exiting\n");

   SFlag = OFF;
   while(SFlag != STOPPED)  Delay(10);

   cleanup();
   exit(RETURN_OK);
   }


/* Routine called as software interrupt */
VOID *tsoftcode()
   {
   struct timerequest *tr;

   /* Remove our message from our port */
   tr = (struct timerequest *)GetMsg(tport);

   /* If main hasn't flagged us to stop, keep the ball rolling */
   if((tr)&&(SFlag==ON))
      {
      /* Increment the counter and send the timer request out again.
       *
       * IMPORTANT: This self-perpetuating technique of calling
       * BeginIO during a software interrupt may only be used with
       * the audio and timer device.
       */
      counter++;
      begintr(tr);
      }
   /* Else flag main we have indeed stopped */
   else(SFlag=STOPPED);
   return(0);
   }


/* begintr(tr)
 * Sets up and sends off timer request.
 * IMPORTANT: Do not BeginIO to any device other than timer or audio
 * from within a software or hardware interrupt.  The BeginIO code
 * of other devices may allocate memory, wait, or perform other
 * functions which are illegal or dangerous during interrupts.
 */
void begintr(struct timerequest *tr)
   {
   /* Set up the timer command */
   tr->tr_node.io_Command = TR_ADDREQUEST;
   tr->tr_time.tv_secs = 0;	/* secs must be cleared each time */
   tr->tr_time.tv_micro = MIC_DELAY;
   BeginIO((struct IOStdReq *)tr);
   }

/* Prints message if any, cleans up, and exits */
void cleanexit(UBYTE *s, LONG n)
   {
   if(*s)  printf(s);
   cleanup();
   exit(n);
   }

/* Close/deallocate everything opened/allocated */
void cleanup()
   {
   if(OpenedTimer)  CloseDevice((struct IOStdReq *)treq);
   if(treq)         DeleteExtIO((struct IOStdReq *)treq);
   if(tport)
      {
      RemPort(tport);
      FreeMem(tport,sizeof(struct timerequest));
      }
   if(tint)  FreeMem(tint, sizeof(struct Interrupt));
   }



