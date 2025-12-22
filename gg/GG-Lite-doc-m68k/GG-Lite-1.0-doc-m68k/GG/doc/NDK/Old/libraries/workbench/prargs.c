;/* prargs.c - Execute me to compile me
LC -b1 -cfistq -v -y -j73 prargs.c
Blink FROM LIB:c.o,prargs.o TO prargs LIBRARY LIB:LC.lib,LIB:Amiga.lib DEFINE __main=__tinymain
quit
*/

/* PrArgs.c - This program prints its Workbench or CLI arguments.
** Compiled with lattice c 5.04.  Works under workbench and CLI.
** 'tinymain' statement turns off default stdin/stdout handling.
** 
** NOTE: main and tinymain are prepended with two underscores.
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
#include <workbench/startup.h>
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
/*------------------------------------------------------------
** disable lattice CTRL-C handling
*/
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }	/* really */

/*------------------------------------------------------------
** program to print arguments,
** works if run from the CLI or WORKBENCH.
*/
void main(int argc, char **argv)
{
struct WBStartup *argmsg;
struct WBArg *wb_arg;
LONG ktr;
BPTR olddir;
FILE *outFile;

/* argc is zero when run from the Workbench,
**         positive when run from the CLI.
*/
if (argc == 0)
	{
	if (NULL != (outFile = fopen("CON:0/0/640/200/Print Args","r+")))
		{
		/* in lattice, argv is a pointer to the WBStartup message
		** when argc is zero.  (run under the Workbench.)
		*/
		argmsg = (struct WBStartup *)argv ;
		wb_arg = argmsg->sm_ArgList ;         /* head of the arg list */

		fprintf(outFile, "Run from the workbench, %ld args.\n",
		                 argmsg->sm_NumArgs);

		for (ktr = 0; ktr < argmsg->sm_NumArgs; ktr++, wb_arg++)
			{
			if (NULL != wb_arg->wa_Lock)
				{
				/* locks supported, change to the proper directory */
				olddir = CurrentDir(wb_arg->wa_Lock) ;

				/* process the file.
				** if you have done the CurrentDir( ) above,
				** then you can access the file by its name.
				** otherwise, you have to look at the lock to get
				** a complete path to the file.
				*/
				fprintf(outFile, "\tArg %2.2ld (w/ lock): '%s'.\n",
				                 ktr, wb_arg->wa_Name);

				/* change back to the original directory when done.
				** be sure to change back before you exit.
				*/
				CurrentDir(olddir) ;
				}
			else
				{
				/* something that does not support locks */
				fprintf(outFile, "\tArg %2.2ld (w/ lock): '%s'.\n",
				                 ktr, wb_arg->wa_Name);
				}
			}
		/* wait before closing down */
		Delay(500L);
		fclose(outFile);
		}
	}
else
	{
	/* using 'tinymain' from lattice c.
	** define a place to send the output (originating CLI window = "*")
        ** Note - if you open "*" and your program is RUN, the user will not
        ** be able to close the CLI window until you close the "*" file.
	*/
	if (NULL != (outFile = fopen("*","r+")))
		{
		fprintf(outFile, "Run from the CLI, %d args.\n", argc);

		for ( ktr = 0; ktr < argc; ktr++)
			{
			/* print an arg, and its number */
			fprintf(outFile, "\tArg %2.2ld: '%s'.\n", ktr, argv[ktr]);
			}
		fclose(outFile);
		}
	}
}
