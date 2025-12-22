/*
 * Test REQUESTLib.Lib
 *
 * (c) 1999 by Michaela Prüß
 *
 */

#include "main.h"

int main(int argc, char *argv[])
{
	int		rv;

	rv=rtEZReq(  "rtEZReq",									/* title          */
				 "A simple requester\\nTwo buttons",        /* body           */
				 "_Yes|_No",                                /* buttontext     */
				 0,                                         /* default return */
				 TRUE,                                      /* center text    */
				 FALSE,                                     /* noreturnkey    */
				 3,                                         /* position       */
				 0,                                         /* top offset     */
				 0,                                         /* left offset    */
				 "");                                       /* pub screen     */

	printf("\n");
	if (rv==-1) fprintf(stderr,"Unable to allocate requester structure\n");
	else if (rv==-2) fprintf(stderr,"Error opening reqtools.library\n");
	else printf("rtEZReq (1) returning %d\n",rv);



	rv=rtEZReq(  "rtEZReq",									/* title          */
				 "An other simple requester\\nOne button",  /* body           */
				 "Kick here",                               /* buttontext     */
				 0,                                         /* default return */
				 TRUE,                                      /* center text    */
				 TRUE,                                      /* noreturnkey    */
				 1,                                         /* position       */
				 0,                                         /* top offset     */
				 0,                                         /* left offset    */
				 "");                                       /* pub screen     */

	printf("\n");
	if (rv==-1) fprintf(stderr,"Unable to allocate requester structure\n");
	else if (rv==-2) fprintf(stderr,"Error opening reqtools.library\n");
	else printf("rtEZReq (2) returning %d\n",rv);



	rv=rtFileReq("rtFileReq",       /* title            */
				 "Sys:",            /* drawer           */
				 "Disk.info",       /* file name        */
				 "#?",              /* pattern          */
				 FALSE,             /* no buffer        */
				 TRUE,              /* multi select     */
				 TRUE,              /* select dirs      */
				 FALSE,             /* save             */
				 FALSE,             /* no files         */
				 TRUE,              /* pattern gadget   */
				 15,                /* height           */
				 "YEAH",            /* OK button text   */
				 FALSE,             /* volume requester */
				 FALSE,             /* no assigns       */
				 FALSE,             /* no disks         */
				 TRUE,              /* all disks        */
				 TRUE,              /* empty allowed    */
				 2,                 /* position         */
				 0,                 /* top offset       */
				 0,                 /* left offset      */
				 "Ram:Output_File", /* output file name */
				 "");               /* pub screen       */

	printf("\n");
	if (rv==-1) fprintf (stderr, "Unable to open output file\n");
	else if (rv==-2) fprintf(stderr,"Unable to allocate requester structure\n");
	else if (rv==-3) fprintf(stderr,"Error opening reqtools.library\n");
	else printf("rtFileReq (1) returning %d\n",rv);

	printf("Type Ram:OutPut_File:\n");
	system("Type Ram:OutPut_File");



	rv=rtFileReq("rtFileReq / Vol", /* title            */
				 "",                /* drawer           */
				 "", 		        /* file name        */
				 "",                /* pattern          */
				 FALSE,             /* no buffer        */
				 FALSE,             /* multi select     */
				 FALSE,             /* select dirs      */
				 FALSE,             /* save             */
				 FALSE,             /* no files         */
				 FALSE,             /* pattern gadget   */
				 15,                /* height           */
				 "OK!",             /* OK button text   */
				 TRUE,              /* volume requester */
				 FALSE,             /* no assigns       */
				 FALSE,             /* no disks         */
				 TRUE,              /* all disks        */
				 TRUE,              /* empty allowed    */
				 4,                 /* position         */
				 0,                 /* top offset       */
				 0,                 /* left offset      */
				 "",                /* output file name */
				 "");               /* pub screen       */

	printf("\n");
	if (rv==-1) fprintf (stderr, "Unable to open output file\n");
	else if (rv==-2) fprintf(stderr,"Unable to allocate requester structure\n");
	else if (rv==-3) fprintf(stderr,"Error opening reqtools.library\n");
	else printf("rtFileReq (2) returning %d\n",rv);

	printf("\n");

	exit(0);
}

