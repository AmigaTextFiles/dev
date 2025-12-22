/*
 * umsdebug.c V1.0
 *
 * UMS UUCP debuging stuff
 *
 * (c) 1992 Stefan Becker
 *
 */

#include "/ums_uucp.h"
#include <stdio.h>
#include <stdarg.h>

static FILE *debugfh=NULL;

void UMSDebugLog(long level, char *fmt, ...)
{
 va_list args;

 /* Start VarArgs processing */
 va_start(args,fmt);

 /* Log level high enough? */
 if (level <= UMSDebugLevel) {
  /* Log file open? No, open it */
  if (!debugfh && !(debugfh=fopen(UMSDebugFile,"a")))
   fprintf(stderr,"Couldn't open log file '%s'\n",UMSDebugFile);
  else {
   /* Log file open, print log line */
   fprintf(debugfh,"%s (%d): ",UMSDebugProgram,level);
   vfprintf(debugfh,fmt,args);
  }
 }

 /* End VarArgs processing */
 va_end(args);
}
