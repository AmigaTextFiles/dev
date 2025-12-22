/*
 * exportnews.c  V1.0.02
 *
 * export news (public) messages
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Global data */
UBYTE *NewsOutBuffer;

/* Local data */
static struct ExportData ed;

/* Init news export */
BOOL InitNewsExport(void)
{
 /* Set output buffer */
 ed.ed_Buffer = NewsOutBuffer;

 /* Get export data */
 return(GetExportData(UMSUUCP_NEWSEXPORT, &ed));
}

/* Export one news article */
BOOL ExportNews(UMSMsgNum msgnum)
{
 BOOL rc = TRUE;

 /* Finished with current outfile? */
 if (ed.ed_Handle && (((ed.ed_Flags & EXPORTDATA_FLAGS_BATCH) == 0) ||
     ((Seek(ed.ed_Handle, 0, OFFSET_CURRENT) +
        URData->urd_MsgData.urmd_HeaderLen   +
        URData->urd_MsgData.urmd_TextLen) >= ed.ed_MaxSize))) {

  /* Yes. Close it */
  rc = FinishUUCPFiles(&ed);
 }

 /* Error? */
 if (rc) {

  /* No. Create new outfile? */
  if (!ed.ed_Handle)

   rc = CreateUUCPFiles(&ed, "news", ed.ed_XFileCmd);

  /* File open? */
  if (rc) {
   BPTR  outfh      = ed.ed_Handle;
   ULONG outfilepos = Seek(outfh, 0, OFFSET_CURRENT);
   ULONG articlelen;

   /* Write header */
   FPuts(outfh, "#! rnews 00000000\n");

   /* Flush output */
   Flush(outfh);

   /* Write message */
   if (rc = UMSRFCWriteMessage(URData, UUCPOutputFunction, &ed, FALSE)) {

    /* Flush output */
    FlushOutput(&ed);

    /* Message written, get article length */
    articlelen = Seek(outfh, 0, OFFSET_CURRENT) - outfilepos - 18;

    /* Write article length */
    Seek(outfh, outfilepos + 9, OFFSET_BEGINNING);
    FPrintf(outfh, "%08ld", articlelen);
    Seek(outfh, 0, OFFSET_END);

    /* Tell UMS we have exported the message (and all hard-linked msgs) */
    UMSExportedMsg(Account, msgnum);

    /* Hard-linked? */
    if (URData->urd_MsgData.urmd_HardLink != 0)

     /* Clear local select bit on current message (and all hard-linked msgs) */
     UMSSelectTags(Account, UMSTAG_SelMsg,        msgnum,
                            UMSTAG_SelWriteLocal, TRUE,
                            UMSTAG_SelUnset,      SELBIT,
                            TAG_DONE);

   } else {

    /* Couldn't write message, tell MBP we couldn't export message */
    UMSCannotExport(Account, msgnum, "Error in writing news article!");

    /* Truncate data file to remove errornous article */
    FlushOutput(&ed);
    SetFileSize(outfh, outfilepos, OFFSET_BEGINNING);
    Seek(outfh, 0, OFFSET_END);
   }
  } else
   /* Couldn't write message, tell MBP we couldn't export message */
   UMSCannotExport(Account, msgnum, "Couldn't open new news file!");

 } else
  /* Couldn't write message, tell MBP we couldn't export message */
  UMSCannotExport(Account, msgnum, "Error in news post-processing!");

 return(rc);
}

/* Finish news export */
BOOL FinishNewsExport(void)
{
 BOOL rc = TRUE;

 /* File open? */
 if (ed.ed_Handle)

  /* Yes. Close it */
  rc = FinishUUCPFiles(&ed);

 return(rc);
}
