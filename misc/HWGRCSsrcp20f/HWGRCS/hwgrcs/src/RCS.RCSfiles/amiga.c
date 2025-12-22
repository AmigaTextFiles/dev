head	1.1;
access;
symbols
	V2_5:1.1
	V2_4:1.1
	V2_3:1.1
	V2_2:1.1
	V2_1:1.1;
locks; strict;
comment	@ * @;


1.1
date	96.03.03.10.57.16;	author heinz;	state Exp;
branches;
next	;


desc
@AMIGA support module.
@


1.1
log
@Initial revision
@
text
@/*------------------------------------------------------------------------*/
/*                                                                        *
 *  $Id: amiga.c,v 1.15 1994/02/14 19:29:45 heinz Exp $
 *
 *  $Log: amiga.c,v $
 * Revision 1.15  1994/02/14  19:29:45  heinz
 * First version of Amiga keywords implemented. Ugly, but acceptable for now.
 *
 * Revision 1.14  1994/01/22  12:43:12  heinz
 * Update for the C= Style version string generation.
 *
 * Revision 1.13  1993/12/18  16:12:22  heinz
 * Changed all checks for AMIGA to _AMIGA. This is more standard like
 * and helps future updates. Major patch cleanup on the way.
 * [Note: Added a VOID_CLOSEDIR define for this global change, too!]
 *
 * Revision 1.12  1993/12/16  19:55:54  heinz
 * Removed the error dummy. hwgunix.lib now handles a NULL pointer there
 * which seems to be much more straightforward to me.
 *
 * Revision 1.11  1993/10/17  17:17:47  heinz
 * Threw out most of the stuff. It is now all in hwgunix.lib in
 * the //addlib directory.
 *
 * Revision 1.10  1993/07/23  15:08:02  heinz
 * Added a replacement for the SAS/C __datecvt function. Minor
 * cosmetic cleanup work done, too.
 *
 * Revision 1.9  1993/07/07  20:33:01  heinz
 * The version string is now defined in the smakefile
 *
 * Revision 1.8  1993/07/07  16:39:59  heinz
 * I am using the SAS __stack feature  now. This should help if people
 * forget to set up their stack size.
 *
 * Revision 1.7  1993/04/14  19:13:19  heinz
 * Major work an the SAS/C replacement functions for networking compatibility.
 *
 * Revision 1.6  1993/03/20  20:38:01  heinz
 * __regargs was missing in statfuncs replacement.
 * This messed up my fstat bug fix for SAS/C 6.2
 *
 * Revision 1.5  1993/02/11  20:59:20  heinz
 * Removed SAS/C __timecvt() as it uses the timezone which we don't want here.
 * With manual conversion file dates are finally correct.
 *
 * Revision 1.4  1993/01/21  19:50:04  heinz
 * Version string update
 *
 * Revision 1.3  1993/01/21  19:31:37  heinz
 * Added the fix for stat and fstat of SAS/C 6.1.
 * These functions don't handle the extended protection bits correctly.
 *
 * Revision 1.2  1993/01/20  20:28:21  heinz
 * Added setup of the current timezone.
 *
 * Revision 1.1  1993/01/18  13:16:47  heinz
 * Initial revision
 *
 *                                                                        */
/*------------------------------------------------------------------------*/

/*------------------------------------------------------------------------*/

/*------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <ios1.h>
#include <dos/dos.h>

#define __USE_SYSBASE
#undef VOID
#define VOID void
#include <proto/exec.h>
#include <proto/dos.h>

/*------------------------------------------------------------------------*/
/* This is magic to make the SAS/C startup automatically set up the
   correct stack size for us. With >=6.3 this is supposed to work. */
long __stack = 32768;

/*------------------------------------------------------------------------*/
extern int AMIGA_run_v(int *const err,
                       const char *arg0,
                       const char *arg1,
                       const int append1,
                       const char *arg2,
                       const int append2,
                       const char **arglist,
                       const char *runcmd);

/*
 * Run a command.
 * The first two arguments are the input and output files (if nonnil);
 * the rest specify the command and its arguments.
 */
int AMIGArunv(int infd, const char *outname, const char **args)
{
    BPTR oldin;
    struct UFB *ufb;
    int res = -1;

    if(infd == -1)
    {
        infd = 0;
    } /* if */

    ufb = chkufb(infd);
    if(ufb)
    {
        oldin = SelectInput((BPTR)ufb->ufbfh);
    }
    else
    {
        oldin = NULL;
    } /* if */

    /* We fail without stdin! */
    if(oldin)
    {
        res = AMIGA_run_v(NULL, /* Use Input()! */NULL, outname, 0, NULL, 0, args, NULL);

        SelectInput(oldin);
    } /* if */

    return(res);

} /* AMIGArun */

/*------------------------------------------------------------------------*/

/* Ende des Quelltextes */

@
