/*
 * log.c V0.0.05
 *
 * umsrfc.library/UMSRFCVLog()
 * umsrfc.library/UMSRFCFlushLog()
 *
 * (c) 1994 Stefan Becker
 */

#include "umsrfc.h"

__LIB_PREFIX void UMSRFCVLog(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *format,
             __LIB_ARG(A2) const ULONG       *args
             /* __LIB_BASE */)
{
 struct PrivateURD *purd       = (struct PrivateURD *) urd;
 const struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;

 /* Log file open? No, open it */
 if (!(purd->purd_LogFile ||
       (purd->purd_LogFile = Open(CreateTempName(purd, TEMPNAME_LOG,
                                                 purd->purd_LogName),
                                  MODE_NEWFILE)))) {

  /* Couldn't open log file */
  const struct UMSBase *UMSBase = purd->purd_Bases.urb_UMSBase;
  UMSAccount account            = purd->purd_Public.urd_Account;

  /* Print error message to UMS log file */
  TAGCALL(UMSLog)(UMSBASE account, 4,
                   "UMSRFC: Couldn't open error log file '%s'!\n",
                   purd->purd_LogName);

 } else {
  /* Log file open, print log line */
  ULONG len = pvsprintf(purd->purd_Buffer3, format, args);
  Write(purd->purd_LogFile, purd->purd_Buffer3, len);
 }
}

/* Flush & close error log. If necessary, mail error log to "PostMaster" */
__LIB_PREFIX void UMSRFCFlushLog(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             /* __LIB_BASE */)
{
 struct PrivateURD *purd = (struct PrivateURD *) urd;
 BPTR               file;

 /* Got any error messages? */
 if (file = purd->purd_LogFile) {

  /* Yes, read log and mail it */
  const struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;
  const struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
  UMSAccount            account = purd->purd_Public.urd_Account;
  char                 *logbuf;
  ULONG                 loglen;

  /* Move pointer to start of file and get file size */
  loglen = Seek(file, 0, OFFSET_BEGINNING);

  /* Allocate memory for log file */
  if (logbuf = AllocMem(loglen + 1, MEMF_PUBLIC)) {

   /* Read log file into buffer */
   if (Read(file, logbuf, loglen) == loglen) {

    /* Add string terminator */
    logbuf[loglen]='\0';

    /* Send msg */
    if (!TAGCALL(UMSWriteMsgTags)(UMSBASE account,
                                   UMSTAG_WSubject, (ULONG) "UMSRFC error log",
                                   UMSTAG_WToName,  (ULONG) "postmaster",
                                   UMSTAG_WMsgText, (ULONG) logbuf,
                                   TAG_DONE))

     /* Ooops another error :-( */
     TAGCALL(UMSLog)(UMSBASE account, 4,
                      "UMSRFC: Couldn't mail error log! UMS-Error: %ld - %s",
                      UMSErrNum(account), UMSErrTxt(account));

   } else
    TAGCALL(UMSLog)(UMSBASE account, 4,
                     "UMSRFC: Couldn't read log file '%s'!",
                     purd->purd_LogName);

   /* Free error log buffer */
   FreeMem(logbuf, loglen + 1);
  } else
   TAGCALL(UMSLog)(UMSBASE account, 4,
                    "UMSRFC: Couldn't allocate buffer for log file '%s'!",
                    purd->purd_LogName);

  /* Close log file */
  Close(file);
  purd->purd_LogFile = NULL;

  /* Delete log file */
  DeleteFile(purd->purd_LogName);
 }
}
