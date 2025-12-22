;/* io_example.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 io_example.c
Blink FROM LIB:c.o,io_example.o TO io_example LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* IO_Example.c - an example of exec device IO using the trackdisk device 
 * Requires use of ANSI function prototypes.
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
#include <devices/trackdisk.h>
#include <libraries/dos.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL-C handling */
int chkabort(void) { return(0); }	/* really */
void cleanExit(int);
void main(void);
#endif

struct IOExtTD *trackIO;    /* global pointer to trackdisk IORequest */
short       openerror;  /* global flag */

void cleanExit(returncode)
int returncode;
{
if(!openerror)CloseDevice(trackIO);

if(trackIO)
    {
    /* extract Port address from I/O Request */
    DeletePort(trackIO->iotd_Req.io_Message.mn_ReplyPort);
    DeleteExtIO(trackIO);
    }
exit(returncode);
}

void main()
{
/* CreatePort() and pass the result to CreatreExtIO in one step */
trackIO=(struct IOExtTD *)
    CreateExtIO( CreatePort(0,0),sizeof(struct IOExtTD) );
if(!trackIO)cleanExit(RETURN_FAIL+1);

if(openerror=OpenDevice("trackdisk.device",0L,trackIO,0L))
    cleanExit(RETURN_FAIL+2);

trackIO->iotd_Req.io_Command=TD_SEEK;       /* command */

trackIO->iotd_Req.io_Offset =0L;            /* out */
DoIO(trackIO); printf("1\n");

trackIO->iotd_Req.io_Offset =79*11*2*512L;  /* in  */
DoIO(trackIO); printf("2\n");

trackIO->iotd_Req.io_Offset =0L;            /* out */
DoIO(trackIO); printf("3\n");

trackIO->iotd_Req.io_Offset =79*11*2*512L;  /* in  */
DoIO(trackIO); printf("4\n");

cleanExit(RETURN_OK);

}
