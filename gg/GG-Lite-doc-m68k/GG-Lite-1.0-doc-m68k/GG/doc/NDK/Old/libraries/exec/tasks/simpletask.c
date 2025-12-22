;/* simpletask.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 simpletask.c
Blink FROM LIB:c.o,simpletask.o TO simpletask LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* SimpleTask.c - simple task creation example
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
#include <exec/tasks.h>
#include <libraries/dos.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }	/* really */
#endif

#define STACK_SIZE 1000L

/* Task name, pointers for allocated task struct and stack */
APTR stack = NULL;
struct Task *tc = NULL;
char *simpletaskname = "MySimpleTask";

ULONG sharedvar;

void simpletask(void);
void cleanup(void);
void cleanexit(UBYTE *,LONG);


void main(int argc,char **argv)
    {
    if((stack = AllocMem(STACK_SIZE, MEMF_CLEAR)) == NULL)
        cleanexit("Not enough memory for task stack\n",RETURN_FAIL);
 
    if ((tc = (struct Task *)
        AllocMem(sizeof(struct Task),MEMF_CLEAR | MEMF_PUBLIC)) == NULL)
            cleanexit("Not enough memory for task structure\n",RETURN_FAIL);

    /* Initialize necessary fields, others were cleared by MEMF_CLEAR */
    tc->tc_Node.ln_Type = NT_TASK;
    tc->tc_Node.ln_Name = simpletaskname;
    tc->tc_SPLower = (APTR)stack;
    tc->tc_SPUpper = (APTR)(STACK_SIZE + (ULONG)stack);
    tc->tc_SPReg   = tc->tc_SPUpper;

    sharedvar = 0L;
    AddTask(tc, simpletask, 0L);

    printf("This program initialized a variable to zero, then started a\n");
    printf("separate task which is incrementing that variable right now,\n");
    printf("while this program waits for you to press RETURN.\n");
    printf("Press RETURN now: ");
    getchar();

    printf("The shared variable now equals %ld\n",sharedvar);
    /* We can simply remove the task we added because our simpletask
     * does not make any system calls which could cause it to be awakened
     * or signalled later.
     */
    RemTask(tc);

    cleanup();
    exit(RETURN_OK);
    }

void simpletask()
    {
    while(sharedvar < 0x8000000) sharedvar++;
    /* Wait forever because main() is going to RemTask() us */
    Wait(0L);
    }

void cleanexit(s,e)
UBYTE *s;
LONG e;
    {
    if(*s) printf(s);
    cleanup();
    exit(e);
    }

void cleanup()
    {
    if(tc) FreeMem(tc,sizeof(struct Task));
    if(stack) FreeMem(stack,STACK_SIZE);
    }
