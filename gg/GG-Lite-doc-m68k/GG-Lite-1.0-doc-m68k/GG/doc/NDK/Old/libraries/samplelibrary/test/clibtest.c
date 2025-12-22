;/* clibtest.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 clibtest.c
Blink FROM LIB:c.o,clibtest.o TO clibtest LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
; note - you must also link with sample.lib if not using #pragmas in sample.h
*/

/*
 *  clibtest.c -- C example that calls the Sample.library functions
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
#include <exec/libraries.h>
#include <libraries/dos.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }	/* really */
#endif

#include "samplebase.h"
#include "sample.h"

void main(int,char**);
struct SampleBase *SampleBase;

void main(int argc, char **argv)
   {
   LONG n;
   struct Library *slib;

   /* Open sample.library */
   if(!(SampleBase=(struct SampleBase *)OpenLibrary("sample.library",0)))
      {
      printf("Can't open sample.library\n");
      exit(RETURN_FAIL);
      }

   /* Print library name, version, revision */
   slib = &SampleBase->LibNode;
   printf("%s   Version %ld   Revision %ld\n",
             slib->lib_Node.ln_Name, slib->lib_Version, slib->lib_Revision);

   /* Call the two functions */
   n = Double(-7);
   printf("Function Double(-7) returned %ld\n", n);

   n = AddThese(21,4);
   printf("Function AddThese(21,4) returned %ld\n", n);

   CloseLibrary((struct Library *)SampleBase);
   exit(RETURN_OK);
   }
