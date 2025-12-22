/*
 * exportmail.c  V0.8.01
 *
 * export mail (private) messages
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "ums2uucp.h"

extern char DateFormat[];
static struct ExportData ed;
static int outfilelen=0;
static ULONG MaxRecipients=ULONG_MAX;
static BOOL DumbHost=FALSE;
static const char QUITLine[]="QUIT\n";
static const char ConvError[]="Cannot convert recipient address!";

/* Init mail export */
BOOL InitMailExport(void)
{
 BOOL rc=FALSE;

 /* Get export data */
 if (GetExportData(UMSUUCP_MAILEXPORT,&ed)) {
  char *cp;

  /* compression IMPLIES BSMTP! */
  if (ed.ed_CompCmd) ed.ed_Batch=TRUE;

  /* Read UMS config var for host type */
  if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_DUMBHOST,
                                   TAG_DONE)) {

   /* Is the remote system a dumb UUCP host? */
   if ((*cp=='Y') || (*cp=='y')) DumbHost=TRUE;

   /* Free UMS config var */
   FreeUMSConfig(Account,cp);
  }

  /* Read UMS config var for recipient limit */
  if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_RECIPIENTS,
                                   TAG_DONE)) {
   char *tp;

   /* Get number */
   if ((MaxRecipients=strtol(cp,&tp,10))==0) MaxRecipients=ULONG_MAX;

   /* Free UMS config var */
   FreeUMSConfig(Account,cp);
  }

  /* Debugging */
  ulog(1,"Host type: %s, Recipient limit: %lu",
         (DumbHost ? "dumb" : "smart"),MaxRecipients);

  rc=TRUE;
 }

 return(rc);
}

/* Batched mail transfer? */
BOOL BatchedMail(void)
{
 return(ed.ed_Batch);
}

/* Export one mail message */
BOOL ExportMail(UMSMsgNum msgnum)
{
 BOOL batched=ed.ed_Batch;
 BOOL rc=TRUE;

 /* Finished with current outfile? */
 if (ed.ed_OutFile && (!batched ||
     ((outfilelen+
        MessageData.md_HeaderLen+
        MessageData.md_TextLen) >= ed.ed_MaxSize))) {
  /* Yes. Batched mail? */
  if (batched)
   /* Yes, write "QUIT" line */
   fprintf(ed.ed_OutFile,QUITLine);

  /* Close file */
  rc=FinishUUCPFiles(&ed);
  outfilelen=0;
 }

 /* Error? */
 if (rc) {
  /* No. Create new outfile? */
  if (!ed.ed_OutFile) {
   char *cmd;

   /* Batched transfer? */
   if (ed.ed_Batch)
    cmd=ed.ed_XFileCmd; /* Yes, set command name */

    /* Not batched, create rmail parameters */
    /* Convert first recipient address */
   else if (ConvertAddress(FromAddrBuffer,MsgFields[UMSCODE_ToName],
                                          MsgFields[UMSCODE_ToAddr])) {
    UMSMsgNum currentnum;
    ULONG recipients=1;

    /* Start command line, add routing information */
    sprintf(Tmp1Buffer,"%s %s", ed.ed_XFileCmd,
            CreateRouteAddress(FromAddrBuffer,Tmp2Buffer));

    /* Message for multiple recipients? */
    if ((currentnum=MessageData.md_SoftLink)!=0) {
     /* Yes, scan soft-linked messages */
     char *cp=Tmp1Buffer+strlen(Tmp1Buffer);

     /* Scan soft-link until original msg or max recipient count is reached */
     while ((currentnum!=msgnum) && (recipients<MaxRecipients)) {
      char *nexttoname;
      char *nexttoaddr;
      UMSSet userflags;
      UMSMsgNum nextnum;
      ULONG len=strlen(cp);

      /* Read msg number, user flags and ToAddress of next soft-linked msg */
      if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,    currentnum,
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
       if (ConvertAddress(FromAddrBuffer,nexttoname,nexttoaddr)) {

        /* Add ToAddress (with routing information) to command string */
        char *ap=CreateRouteAddress(FromAddrBuffer,Tmp2Buffer);
        ULONG tmplen=strlen(ap)+1;

        /* Command line length exceeded? */
        if ((len+=tmplen)<TMP1BUFSIZE) {
         /* No, set local mark bit on current message */
         if (!UMSSelectTags(Account,UMSTAG_SelMsg,        currentnum,
                                    UMSTAG_SelWriteLocal, TRUE,
                                    UMSTAG_SelSet,        MARKBIT,
                                    TAG_DONE))
          nextnum=msgnum; /* Error! This breaks the loop */

         /* Add address */
         *cp=' ';
         strcpy(cp+1,ap);
         cp+=tmplen;

         /* Increment recipient count */
         recipients++;

         /* Command line length exceeded */
        } else
         nextnum=msgnum; /* This breaks the loop */

        /* Address conversion error */
       } else
        nextnum=msgnum; /* This breaks the loop */

      /* Free message */
      FreeUMSMsg(Account,currentnum);

      /* Get next message number */
      currentnum=nextnum;
     }
    }

    /* Set command pointer */
    cmd=Tmp1Buffer;

    /* Address conversion error */
   } else {
    /* Couldn't convert recipient address, tell MBP we couldn't export msg */
    UMSCannotExport(Account,msgnum,ConvError);
    rc=FALSE;
   }

   /* All OK? */
   if (rc)

    /* Yes, create new file */
    if (rc=CreateUUCPFiles(&ed,"daemon",cmd)) {
     /* File open, batched mail? */
     if (batched) {
      /* Yes */
      FILE *outfh=ed.ed_OutFile;

      /* Write "HELO ..." line */
      fprintf(outfh,"HELO %s\n",DomainName);
      outfilelen=ftell(outfh);
     }
    } else
     /* Couldn't write message, tell MBP we couldn't export message */
     UMSCannotExport(Account,msgnum,"Couldn't open new mail file!");
  }

  /* All OK? */
  if (rc)

   /* Yes, build from address */
   if (rc=ConvertAddress(FromAddrBuffer,MsgFields[UMSCODE_FromName],
                         MsgFields[UMSCODE_FromAddr])) {

    /* From address built, write message */
    FILE *outfh=ed.ed_OutFile;
    ULONG outfilepos=ftell(outfh); /* Remember current file position */

    /* Batched? */
    if (batched)

     /* Yes, convert first recipient address */
     if (ConvertAddress(Tmp1Buffer,MsgFields[UMSCODE_ToName],
                                   MsgFields[UMSCODE_ToAddr])) {
      /* Write BSMTP commands */
      UMSMsgNum currentnum;
      ULONG recipients=1;

      /* Write from address and first recipient address*/
      fprintf(outfh,"MAIL FROM: <%s>\nRCPT TO: <%s>\n", FromAddrBuffer,
                    CreateRouteAddress(Tmp1Buffer,Tmp2Buffer));

      /* Soft-linked? */
      if ((currentnum=MessageData.md_SoftLink)!=0)
       /* Scan soft-link until orig msg or max recipient count is reached */
       while ((currentnum!=msgnum) && (recipients<MaxRecipients)) {
        char *nexttoname;
        char *nexttoaddr;
        UMSSet userflags;
        UMSMsgNum nextnum;

        /* Read msg number, user flags and ToAddress of next soft-linked msg */
        if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,    currentnum,
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
         if (ConvertAddress(Tmp1Buffer,nexttoname,nexttoaddr)) {

          /* Set local mark bit on current message */
          if (!UMSSelectTags(Account,UMSTAG_SelMsg,        currentnum,
                                     UMSTAG_SelWriteLocal, TRUE,
                                     UMSTAG_SelSet,        MARKBIT,
                                     TAG_DONE))
           nextnum=msgnum; /* Error! This breaks the loop */

          /* Add "RCPT TO:" line */
          fprintf(outfh,"RCPT TO: <%s>\n",
                        CreateRouteAddress(Tmp1Buffer,Tmp2Buffer));

          /* Increment recipient count */
          recipients++;

          /* Address conversion error */
         } else
          nextnum=msgnum; /* This breaks the loop */

        /* Free message */
        FreeUMSMsg(Account,currentnum);

        /* Get next message number */
        currentnum=nextnum;
       }

      /* Addresses written, begin of mail data */
      fputs("DATA\n",outfh);

      /* Address conversion error */
     } else {
      /* Couldn't convert recipient address, tell MBP we couldn't export msg */
      UMSCannotExport(Account,msgnum,ConvError);
      rc=FALSE;
     }

    /* All OK? */
    if (rc) {
     /* Yes, create current date string */
     {
      time_t t=time(NULL);         /* Get current calendar time */
      struct tm *tp=localtime(&t); /* Convert calendar time into local time */

      strftime(Tmp1Buffer,TMP1BUFSIZE,DateFormat,tp);
     }

     /* Create UUCP envelope. Dumb UUCP host? */
     if (DumbHost) {
      /* Yes, create RFC976 (dumb) UUCP envelope */
      char *cp;
      char *username="unknown";

      /* Get user name */
      if (cp=strchr(FromAddrBuffer,'@')) {
       ULONG len=cp-FromAddrBuffer;

       /* Copy it to a buffer */
       strncpy(Tmp2Buffer,FromAddrBuffer,len);
       Tmp2Buffer[len]='\0';
       username=Tmp2Buffer;
      }

      /* Write envelope */
      fprintf(outfh,"From %s  %s remote from %s\n",
                    username,Tmp1Buffer,DomainName);
     } else
      /* No, create normal (smart) UUCP envelope */
      fprintf(outfh,"From %s  %s\n",FromAddrBuffer,Tmp1Buffer);

     /* Write message */
     if (rc=WriteRFCMessage(outfh,msgnum,TRUE,batched)) {
      /* Message written */
      UMSMsgNum currentnum;

      /* Get new file length */
      outfilelen=ftell(outfh);

      /* Tell UMS we have exported the message */
      UMSExportedMsg(Account,msgnum);

      /* Soft-linked? */
      if ((currentnum=MessageData.md_SoftLink)!=0)
       /* Yes, scan soft-link until original message is reached again */
       while (currentnum!=msgnum) {
        UMSSet localflags;
        UMSMsgNum nextnum;

        /* Read msg number of next soft-linked message */
        if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,     currentnum,
                                    UMSTAG_RLoginFlags, &localflags,
                                    UMSTAG_RSoftLink,   &nextnum,
                                    TAG_DONE))
         break; /* ERROR! */

        /* Free message */
        FreeUMSMsg(Account,currentnum);

        /* Is this message marked? */
        if (localflags & MARKBIT) {
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
      UMSCannotExport(Account,msgnum,"Error in writing mail message!");

      /* Rewind data file to remove errornous article */
      fseek(outfh,outfilepos,SEEK_SET);
      fprintf(outfh,"                  "); /* clear header */
      fseek(outfh,outfilepos,SEEK_SET);
     }
    }
   } else
    /* Couldn't build from address, tell MBP we couldn't export message */
    UMSCannotExport(Account,msgnum,
                    "Couldn't convert sender address of mail message!");

 } else
  /* Couldn't post process UUCP file, tell MBP we couldn't export message */
  UMSCannotExport(Account,msgnum,"Error in mail post-processing!");

 return(rc);
}

/* Finish mail export */
BOOL FinishMailExport(void)
{
 BOOL rc=TRUE;

 /* File open? */
 if (ed.ed_OutFile) {
  /* Yes. Batched mail? */
  if (ed.ed_Batch)
   /* Yes, write "QUIT" line */
   fprintf(ed.ed_OutFile,QUITLine);

  /* Close file */
  rc=FinishUUCPFiles(&ed);
 }

 /* Free export data */
 FreeExportData(&ed);

 return(rc);
}
