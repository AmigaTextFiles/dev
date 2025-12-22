/*
 * MakeLink.c  V1.1
 *
 * (c) 1991 by Stefan Becker
 *
 */
#include <stdlib.h>
#include <clib/dos_protos.h>

const char VersionID[]="$VER: (Soft-)MakeLink 1.1 (21.07.1991)";

/* Stuff for ReadArgs */
const char Template[]="FROM/A,TO/A,HARD/S";
struct {
        char *fromname;
        char *toname;
        long hardlink;
       } ArgDef;

#define NAMELEN 50
char progname[NAMELEN];

extern struct Library *SysBase;

/* Main entry point */
__stkargs void _main()
{
 register struct RDArgs *rda;
 register LONG toobj;
 register long rc=RETURN_ERROR; /* Set return code */

 /* Check OS version */
 if (SysBase->lib_Version<37) _exit(RETURN_FAIL);

 /* Get program name */
 if (!GetProgramName(progname,NAMELEN-1)) progname[0]='\0';

 /* Parse command line arguments */
 ArgDef.hardlink=FALSE;
 if (rda=ReadArgs(Template,(LONG *) &ArgDef,NULL))
  {
   register BOOL softlink=!ArgDef.hardlink; /* Set flag */

   /* Set tobj and then call MakeLink().
        - soft: toobj points to name
        - hard: toobj points to lock
   */
   if ((toobj=softlink?(LONG) ArgDef.toname:Lock(ArgDef.toname,SHARED_LOCK)) &&
       MakeLink(ArgDef.fromname,toobj,softlink))
    rc=RETURN_OK; /* All OK! */

   /* Unlock object if hard link */
   if (!softlink) UnLock(toobj);

   /* Free resources */
   FreeArgs(rda);
  }

 /* Error? Yes, print error message */
 if (rc) PrintFault(IoErr(),progname);

 _exit(rc);
}
