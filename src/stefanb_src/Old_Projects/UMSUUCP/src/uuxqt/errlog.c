/*
 * errlog.c  V0.5
 *
 * log error messages to postmaster
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "uuxqt.h"

static FILE *errlogfh=NULL;
static char errlogname[L_tmpnam];

/* Tag array for emergency message to "postmaster" */
static struct TagItem ErrTags[]={
                                 UMSTAG_WSubject, (ULONG) "UUXQT error log",
                                 UMSTAG_WToName,  (ULONG) "postmaster",
                                 UMSTAG_WMsgText, NULL,
                                 TAG_DONE};
#define ERR_TEXT      2

/* Log an error message */
void ErrLog(char *fmt, ...)
{
 va_list args;

 /* Start VarArgs processing */
 va_start(args,fmt);

 /* Log file open? No, open it */
 if (!errlogfh && !(errlogfh=fopen(tmpnam(errlogname),"w")))
  fprintf(stderr,"Couldn't open error log file '%s'!\n",errlogname);
 else {
  /* Log file open, print log line */
  vfprintf(stderr,fmt,args);
  vfprintf(errlogfh,fmt,args);
 }

 /* End VarArgs processing */
 va_end(args);
}

/* Close error log. If necessary, mail error log to "PostMaster" */
void CloseErrLog(void)
{
 /* Got any error messages? */
 if (errlogfh) {
  char *logbuf;
  ULONG loglen;
  BOOL rc=FALSE;

  /* Yes, close log file */
  fclose(errlogfh);

  /* Get file size */
  {
   struct stat statbuf;

   /* Get file statistic */
   if (stat(errlogname,&statbuf)==-1) {
    /* Error */
    ulog(-1,"can't stat error log file '%s'!",errlogname);
    return;
   }
   loglen=statbuf.st_size;
  }

  /* Allocate memory for mail file */
  if (logbuf=AllocMem(loglen+1,MEMF_PUBLIC)) {
   int lfd;

   /* Open mail file */
   if ((lfd=open(errlogname,O_RDONLY))>=0) {

    /* Read mail file into buffer */
    if (read(lfd,logbuf,loglen)==loglen) {

     /* Add string terminator */
     logbuf[loglen]='\0';

     /* Create message to "Postmaster" */
     ErrTags[ERR_TEXT].ti_Data=(ULONG) logbuf;

     /* Send msg */
     if (WriteUMSMsg(Account,ErrTags))
      rc=TRUE; /* All OK */
     else
      /* Ooops another error :-( */
      fprintf(stderr,"\nUMS-Error: %d - %s\n",UMSErrNum(Account),
                      UMSErrTxt(Account));
    } else
     ulog(-1,"couldn't read error log file '%s'!",errlogname);

    close(lfd);
   } else
    ulog(-1,"couldn't open error log file '%s'!",errlogname);

   /* Free error log buffer */
   FreeMem(logbuf,loglen+1);
  } else
   ulog(-1,"couldn't allocate buffer for error log file '%s'!",errlogname);

  /* Delete log file */
  if (rc) DeleteFile(errlogname);
 }
}
