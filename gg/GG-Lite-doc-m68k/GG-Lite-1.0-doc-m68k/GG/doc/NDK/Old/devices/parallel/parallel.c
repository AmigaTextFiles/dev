/*  parallel.c - Simple no tricks example of parallel.device usage
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
 *  Compile with Lattice 5.04: LC -Lt -catsfq
 */
#include <exec/types.h>
#include <devices/parallel.h>
#ifdef LATTICE
#include <proto/exec.h>
#include <stdio.h>
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL-C handling */
void main(void);
#endif

#define DEVICE_NAME "parallel.device"
#define UNIT_NUMBER 0

void main()
{
struct MsgPort	*ParallelMP;	      /* Define storage for one pointer */
struct IOExtPar *ParallelIO;	     /* Define storage for one pointer */

    if( ParallelMP=CreatePort(0,0) )
	{
	if( ParallelIO=(struct IOExtPar *)
	    CreateExtIO(ParallelMP,sizeof(struct IOExtPar)) )
	    {
	    ParallelIO->io_ParFlags=0;	  /* Example of setting flags */

	    if ( OpenDevice(DEVICE_NAME,UNIT_NUMBER,ParallelIO,0) )
		printf("Parallel.device did not open\\n");
	    else
		{
		ParallelIO->IOPar.io_Command  = CMD_WRITE;
		ParallelIO->IOPar.io_Length   = -1;
		ParallelIO->IOPar.io_Data     = (APTR)"Hey, Jude! ";
		DoIO(ParallelIO);             /* execute write */

		/* Add more commands here */
		CloseDevice(ParallelIO);
		}
	    DeleteExtIO(ParallelIO);
	    }
	DeletePort(ParallelMP);
	}
}
