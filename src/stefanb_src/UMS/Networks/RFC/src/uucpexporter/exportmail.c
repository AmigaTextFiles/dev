/*
 * exportmail.c  V1.0.03
 *
 * export mail (private) messages
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Constant strings */
static const char QUITLine[]     = "QUIT\r\n";
static const char BSMTPLineEnd[] = "\r\n";
static const char UUCPLineEnd[]  = "\n";
static const char ConvError[]    = "Cannot convert recipient address!";

/* Global data */
UBYTE *MailOutBuffer;

/* Local data */
static struct ExportData ed;
static ULONG MaxRecipients = ULONG_MAX;
static ULONG EnvelopeType  = ENVELOPE_SMART;
static const char *EnvTypeName[] = { "none", "dumb", "smart" };

/* Init mail export */
BOOL InitMailExport(void)
{
 BOOL rc = FALSE;

 /* Get export data */
 if (GetExportData(UMSUUCP_MAILEXPORT, &ed)) {
  char *cp;
  char *tp;

  /* Set output buffer */
  ed.ed_Buffer = MailOutBuffer;

  /* compression IMPLIES BSMTP! */
  if (ed.ed_CompCmd) ed.ed_Flags |= EXPORTDATA_FLAGS_BATCH;

  /* Read UMS config var for envelope type */
  if (cp = UMSReadConfigTags(Account, UMSTAG_CfgName, UMSUUCP_ENVELOPE,
                                      TAG_DONE)) {
   /* Get type */
   if ((EnvelopeType = strtol(cp, &tp, 10)) > ENVELOPE_SMART)
    EnvelopeType = ENVELOPE_SMART;

   /* Free UMS config var */
   UMSFreeConfig(Account, cp);
  }

  /* Read UMS config var for recipient limit */
  if (cp = UMSReadConfigTags(Account, UMSTAG_CfgName, UMSUUCP_RECIPIENTS,
                                      TAG_DONE)) {
   /* Get number */
   if ((MaxRecipients = strtol(cp, &tp, 10)) == 0) MaxRecipients = ULONG_MAX;

   /* Free UMS config var */
   UMSFreeConfig(Account, cp);
  }

  /* Debugging */
  ulog(1, "Envelope: %s, Recipient limit: %lu",
          EnvTypeName[EnvelopeType], MaxRecipients);

  rc = TRUE;
 }

 return(rc);
}

/* Batched mail transfer? */
BOOL BatchedMail(void)
{
 return(ed.ed_Flags & EXPORTDATA_FLAGS_BATCH);
}

/* Export one mail message */
BOOL ExportMail(UMSMsgNum msgnum)
{
 BOOL batched = ed.ed_Flags & EXPORTDATA_FLAGS_BATCH;
 BOOL rc      = TRUE;

 /* Finished with current outfile? */
 if (ed.ed_Handle && (!batched ||
     ((Seek(ed.ed_Handle, 0, OFFSET_CURRENT) +
        URData->urd_MsgData.urmd_HeaderLen   +
        URData->urd_MsgData.urmd_TextLen) >= ed.ed_MaxSize))) {

  /* Yes. Batched mail? */
  if (batched)
   /* Yes, write "QUIT" line */
   FPuts(ed.ed_Handle, QUITLine);

  /* Close file */
  rc = FinishUUCPFiles(&ed);
 }

 /* Error? */
 if (rc) {

  /* No. Create new outfile? */
  if (!ed.ed_Handle) {
   char *cmd;

   /* Batched transfer? */
   if (batched)
    cmd = ed.ed_XFileCmd; /* Yes, set command name */

    /* Not batched, create rmail parameters */
    /* Convert first recipient address */
   else if (UMSRFCConvertUMSAddress(URData,
                                    URData->urd_MsgFields[UMSCODE_ToAddr],
                                    URData->urd_MsgFields[UMSCODE_ToName],
                                    TempBuffer2)) {
    UMSMsgNum currentnum;
    ULONG recipients     = 1;

    /* Start command line, add routing information */
    sprintf(TempBuffer1, "%s %s", ed.ed_XFileCmd,
            CreateRouteAddress(TempBuffer2, TempBuffer3));

    /* Message for multiple recipients? */
    if ((currentnum = URData->urd_MsgData.urmd_SoftLink) != 0) {

     /* Yes, scan soft-linked messages */
     ULONG  len = strlen(TempBuffer1);
     char  *cp  = TempBuffer1 + len;

     /* Scan soft-link until original msg or max recipient count is reached */
     while ((currentnum != msgnum) && (recipients < MaxRecipients)) {
      char *nexttoname;
      char *nexttoaddr;
      UMSSet userflags;
      UMSMsgNum nextnum;

      /* Read msg number, user flags and ToAddress of next soft-linked msg */
      if (!UMSReadMsgTags(Account, UMSTAG_RMsgNum,    currentnum,
                                   UMSTAG_RUserFlags, &userflags,
                                   UMSTAG_RToName,    &nexttoname,
                                   UMSTAG_RToAddr,    &nexttoaddr,
                                   UMSTAG_RSoftLink,  &nextnum,
                                   TAG_DONE))
       break; /* ERROR! */

      /* Do we have read-access to the current (unread) message? */
      if ((userflags & (UMSUSTATF_Old | UMSUSTATF_ReadAccess)) ==
          UMSUSTATF_ReadAccess)

       /* Yes, convert address */
       if (UMSRFCConvertUMSAddress(URData, nexttoaddr, nexttoname,
                                   TempBuffer2)) {

        /* Add ToAddress (with routing information) to command string */
        char *ap     = CreateRouteAddress(TempBuffer2, TempBuffer3);
        ULONG tmplen = strlen(ap) + 1;

        /* Command line length exceeded? */
        if ((len += tmplen) < TMPBUF1SIZE) {

         /* No, set local mark bit on current message */
         if (!UMSSelectTags(Account, UMSTAG_SelMsg,        currentnum,
                                     UMSTAG_SelWriteLocal, TRUE,
                                     UMSTAG_SelSet,        MARKBIT,
                                     TAG_DONE))
          nextnum = msgnum; /* Error! This breaks the loop */

         /* Add address */
         *cp = ' ';
         strcpy(cp + 1, ap);
         cp += tmplen;

         /* Increment recipient count */
         recipients++;

         /* Command line length exceeded */
        } else
         nextnum = msgnum; /* This breaks the loop */

        /* Address conversion error */
       } else
        nextnum = msgnum; /* This breaks the loop */

      /* Free message */
      UMSFreeMsg(Account,currentnum);

      /* Get next message number */
      currentnum = nextnum;
     }
    }

    /* Set command pointer */
    cmd = TempBuffer1;

    /* Address conversion error */
   } else {
    /* Couldn't convert recipient address, tell MBP we couldn't export msg */
    UMSCannotExport(Account, msgnum, ConvError);
    rc = FALSE;
   }

   /* All OK? */
   if (rc)

    /* Yes, create new file */
    if (rc = CreateUUCPFiles(&ed, "daemon", cmd)) {

     /* File open, batched mail? */
     if (batched) {

      /* Yes, write "HELO ..." line */
      FPrintf(ed.ed_Handle, "HELO %s\r\n", URData->urd_DomainName);
     }
    } else
     /* Couldn't write message, tell MBP we couldn't export message */
     UMSCannotExport(Account, msgnum, "Couldn't open new mail file!");
  }

  /* All OK? */
  if (rc) {
   BPTR  outfh      = ed.ed_Handle;
   ULONG outfilepos = Seek(outfh, 0, OFFSET_CURRENT);

   /* Batched? */
   if (batched)

    /* Yes, convert first recipient address */
    if (UMSRFCConvertUMSAddress(URData, URData->urd_MsgFields[UMSCODE_ToAddr],
                                        URData->urd_MsgFields[UMSCODE_ToName],
                                        TempBuffer1)) {
     /* Write BSMTP commands */
     UMSMsgNum currentnum;
     ULONG recipients     = 1;

     /* Write from address and first recipient address*/
     FPrintf(outfh, "MAIL FROM: <%s>\r\nRCPT TO: <%s>\r\n",
                    URData->urd_FromAddress,
                    CreateRouteAddress(TempBuffer1, TempBuffer2));

     /* Soft-linked? */
     if ((currentnum = URData->urd_MsgData.urmd_SoftLink) != 0)

      /* Scan soft-link until orig msg or max recipient count is reached */
      while ((currentnum != msgnum) && (recipients < MaxRecipients)) {
       char *nexttoname;
       char *nexttoaddr;
       UMSSet userflags;
       UMSMsgNum nextnum;

       /* Read msg number, user flags and ToAddress of next soft-linked msg */
       if (!UMSReadMsgTags(Account, UMSTAG_RMsgNum,    currentnum,
                                    UMSTAG_RUserFlags, &userflags,
                                    UMSTAG_RToName,    &nexttoname,
                                    UMSTAG_RToAddr,    &nexttoaddr,
                                    UMSTAG_RSoftLink,  &nextnum,
                                    TAG_DONE))
        break; /* ERROR! */

       /* Do we have read-access to the current message? */
       if ((userflags & (UMSUSTATF_Old | UMSUSTATF_ReadAccess)) ==
           UMSUSTATF_ReadAccess)

        /* Yes, convert address */
        if (UMSRFCConvertUMSAddress(URData, nexttoaddr, nexttoname,
                                    TempBuffer1)) {

         /* Set local mark bit on current message */
         if (!UMSSelectTags(Account, UMSTAG_SelMsg,        currentnum,
                                     UMSTAG_SelWriteLocal, TRUE,
                                     UMSTAG_SelSet,        MARKBIT,
                                     TAG_DONE))
          nextnum = msgnum; /* Error! This breaks the loop */

         /* Add "RCPT TO:" line */
         FPrintf(outfh, "RCPT TO: <%s>\r\n",
                        CreateRouteAddress(TempBuffer1, TempBuffer2));

         /* Increment recipient count */
         recipients++;

         /* Address conversion error */
        } else
         nextnum = msgnum; /* This breaks the loop */

       /* Free message */
       UMSFreeMsg(Account, currentnum);

       /* Get next message number */
       currentnum = nextnum;
      }

     /* Addresses written, begin of mail data */
     FPuts(outfh, "DATA\r\n");

     /* Address conversion error */
    } else {
     /* Couldn't convert recipient address, tell MBP we couldn't export msg */
     UMSCannotExport(Account, msgnum, ConvError);
     rc = FALSE;
    }

   /* All OK? */
   if (rc) {

    /* Yes, which UUCP envelope type? */
    switch (EnvelopeType) {
     case ENVELOPE_NONE:   /* No envelope */
      break;

     case ENVELOPE_DUMB: { /* Create RFC976 (dumb) UUCP envelope */
       char *cp;
       char *username = "unknown";

       /* Create current date string */
       UMSRFCPrintCurrentTime(URData, TempBuffer1);

       /* Get user name */
       if (cp = strchr(URData->urd_FromAddress, '@')) {
        ULONG len = cp - URData->urd_FromAddress;

        /* Copy it to a buffer */
        strncpy(TempBuffer2, URData->urd_FromAddress, len);
        TempBuffer2[len] = '\0';
        username         = TempBuffer2;
       }

       /* Write envelope */
       FPrintf(outfh, "From %s  %s remote from %s%s",
                      username, TempBuffer1, URData->urd_DomainName,
                      batched ? BSMTPLineEnd : UUCPLineEnd);
      }
      break;

     case ENVELOPE_SMART:  /* No, create normal (smart) UUCP envelope */

      /* Create current date string */
      UMSRFCPrintCurrentTime(URData, TempBuffer1);

      /* Write envelope */
      FPrintf(outfh, "From %s  %s%s",
                      URData->urd_FromAddress, TempBuffer1,
                      batched ? BSMTPLineEnd : UUCPLineEnd);
      break;
    }

    /* Flush output */
    Flush(outfh);

    /* Write message */
    if (rc = UMSRFCWriteMessage(URData, batched ? OutputFunction :
                                                  UUCPOutputFunction,
                                &ed, batched)) {

     /* Message written */
     UMSMsgNum currentnum;

     /* Flush output */
     FlushOutput(&ed);

     /* Append message terminator for batched messages */
     if (batched) FPuts(outfh, "\r\n.\r\n");

     /* Tell UMS we have exported the message */
     UMSExportedMsg(Account, msgnum);

     /* Soft-linked? */
     if ((currentnum = URData->urd_MsgData.urmd_SoftLink) != 0)

      /* Yes, scan soft-link until original message is reached again */
      while (currentnum != msgnum) {
       UMSSet localflags;
       UMSMsgNum nextnum;

       /* Read msg number of next soft-linked message */
       if (!UMSReadMsgTags(Account, UMSTAG_RMsgNum,     currentnum,
                                    UMSTAG_RLoginFlags, &localflags,
                                    UMSTAG_RSoftLink,   &nextnum,
                                    TAG_DONE))
        break; /* ERROR! */

       /* Free message */
       UMSFreeMsg(Account, currentnum);

       /* Is this message marked? */
       if (localflags & MARKBIT) {

        /* Yes, clear local select bit on current message */
        UMSSelectTags(Account, UMSTAG_SelMsg,        currentnum,
                               UMSTAG_SelWriteLocal, TRUE,
                               UMSTAG_SelUnset,      SELBIT,
                               TAG_DONE);

        /* Tell UMS we have exported the current message */
        UMSExportedMsg(Account, currentnum);
       }

       /* Get next message number */
       currentnum = nextnum;
      }

    } else {
     /* Couldn't write message, tell MBP we couldn't export message */
     UMSCannotExport(Account, msgnum, "Error in writing mail message!");

     /* Truncate data file to remove errornous article */
     FlushOutput(&ed);
     SetFileSize(outfh, outfilepos, OFFSET_BEGINNING);
     Seek(outfh, 0, OFFSET_END);
    }
   }
  }
 } else
  /* Couldn't post process UUCP file, tell MBP we couldn't export message */
  UMSCannotExport(Account, msgnum, "Error in mail post-processing!");

 return(rc);
}

/* Finish mail export */
BOOL FinishMailExport(void)
{
 BOOL rc = TRUE;

 /* File open? */
 if (ed.ed_Handle) {

  /* Yes. Batched mail? */
  if (ed.ed_Flags & EXPORTDATA_FLAGS_BATCH)

   /* Yes, write "QUIT" line */
   FPuts(ed.ed_Handle, QUITLine);

  /* Close file */
  rc = FinishUUCPFiles(&ed);
 }

 /* Free export data */
 FreeExportData(&ed);

 return(rc);
}
