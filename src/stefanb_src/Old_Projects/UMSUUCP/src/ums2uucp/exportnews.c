/*
 * exportnews.c  V0.7.04
 *
 * export news (public) messages
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "ums2uucp.h"

static struct ExportData ed;
static outfilelen=0;

/* Init news export */
BOOL InitNewsExport(void)
{
 /* Get export data */
 return(GetExportData(UMSUUCP_NEWSEXPORT,&ed));
}

/* Export one news article */
BOOL ExportNews(UMSMsgNum msgnum)
{
 BOOL rc=TRUE;

 /* Finished with current outfile? */
 if (ed.ed_OutFile && (!ed.ed_Batch ||
     ((outfilelen+
        MessageData.md_HeaderLen+
        MessageData.md_TextLen) >= ed.ed_MaxSize))) {
  /* Yes. Close it */
  rc=FinishUUCPFiles(&ed);
  outfilelen=0;
 }

 /* Error? */
 if (rc) {
  /* No. Create new outfile? */
  if (!ed.ed_OutFile)
   rc=CreateUUCPFiles(&ed,"news",ed.ed_XFileCmd);

  /* File open? */
  if (rc)

   /* Yes, build from address */
   if (rc=ConvertAddress(FromAddrBuffer,MsgFields[UMSCODE_FromName],
                         MsgFields[UMSCODE_FromAddr])) {

    /* From address built, write message */
    FILE *outfh=ed.ed_OutFile;
    ULONG outfilepos=ftell(outfh); /* Remember current file position */
    ULONG articlelen;

    /* Write header */
    fprintf(outfh,"#! rnews 00000000\n");

    /* Write message */
    if (rc=WriteRFCMessage(outfh,msgnum,FALSE,FALSE)) {
     /* Message written */
     UMSMsgNum currentnum;

     /* Get article length */
     outfilelen=ftell(outfh);
     articlelen=outfilelen-outfilepos-18;

     /* Write article length */
     fseek(outfh,outfilepos+9,SEEK_SET);
     fprintf(outfh,"%08d",articlelen);
     fseek(outfh,0,SEEK_END);

     /* Tell UMS we have exported the message */
     UMSExportedMsg(Account,msgnum);

     /* Hard-linked? */
     if ((currentnum=MessageData.md_HardLink)!=0)
      /* Yes, scan hard-link until original message is reached again */
      while (currentnum!=msgnum) {
       UMSSet userflags;
       UMSMsgNum nextnum;

       /* Read msg number of next hard-linked message */
       if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,    currentnum,
                                   UMSTAG_RUserFlags, &userflags,
                                   UMSTAG_RHardLink,  &nextnum,
                                   TAG_DONE))
        break; /* ERROR! */

       /* Free message */
       FreeUMSMsg(Account,currentnum);

       /* Do we have read-access to the current message? */
       if (userflags & UMSUSTATF_ReadAccess) {
        /* Yes, clear local select bit on current message */
        UMSSelectTags(Account,UMSTAG_SelMsg,        currentnum,
                              UMSTAG_SelWriteLocal, TRUE,
                              UMSTAG_SelUnset,      SELBIT,
                              TAG_DONE);

        /* Tell UMS we have exported the current message */
        UMSExportedMsg(Account,currentnum);
       }

       /* Get next message number */
       currentnum=nextnum;
      }
    } else {

     /* Couldn't write message, tell MBP we couldn't export message */
     UMSCannotExport(Account,msgnum,"Error in writing news article!");

     /* Rewind data file to remove errornous article */
     fseek(outfh,outfilepos,SEEK_SET);
     fprintf(outfh,"                  "); /* clear header */
     fseek(outfh,outfilepos,SEEK_SET);
    }

   } else
    /* Couldn't build from address, tell MBP we couldn't export message */
    UMSCannotExport(Account,msgnum,
                    "Couldn't convert sender address of news message!");

  else
   /* Couldn't write message, tell MBP we couldn't export message */
   UMSCannotExport(Account,msgnum,"Couldn't open new news file!");

 } else
  /* Couldn't write message, tell MBP we couldn't export message */
  UMSCannotExport(Account,msgnum,"Error in news post-processing!");

 return(rc);
}

/* Finish news export */
BOOL FinishNewsExport(void)
{
 BOOL rc=TRUE;

 /* File open? */
 if (ed.ed_OutFile)
  /* Yes. Close it */
  rc=FinishUUCPFiles(&ed);

 return(rc);
}
