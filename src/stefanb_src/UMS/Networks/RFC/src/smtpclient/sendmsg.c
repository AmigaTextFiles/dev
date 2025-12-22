/*
 * sendmsg.c V1.0.01
 *
 * UMS SMTP (client) get an UMS message and send as mail messages
 *
 * (c) 1994-97 by Stefan Becker
 */

#include "umssmtp.h"

/* Local data */
static struct OutputData od;
static ULONG Recipients;
static char OutputBuffer[BUFLEN];
static char AddrBuf[UMSRFC_ADDRLEN];
static BOOL MessageOK;

/* Initialize messages sending */
void InitSendMessage(void)
{
 od.od_DOSBase = DOSBase;
 od.od_Handle  = NULL;
 od.od_Counter = 0;
 od.od_Length  = BUFLEN;
 od.od_Buffer  = OutputBuffer;
}

/* Mark message as (not) exported */
static void MarkMessage(UMSMsgNum msgnum, BOOL exported, const char *errtxt)
{
 DEBUGLOG(kprintf("Mark message %ld %sexported (%s)\n",
                  msgnum, exported ? "" : "not ", errtxt);)

 /* Message exported? */
 if (exported)

  /* Yes */
  UMSExportedMsg(Account, msgnum);

 else

  /* No */
  UMSCannotExport(Account, msgnum, errtxt);

 /* Reset local flags so this message won't be exported anymore... */
 UMSSelectTags(Account, UMSTAG_SelMsg,        msgnum,
                        UMSTAG_SelWriteLocal, TRUE,
                        UMSTAG_SelUnset,      SELBIT1 | SELBIT2,
                        TAG_DONE);
}

/* Handle MAIL FROM response */
void HandleMAILFROMResponse(ULONG rc)
{
 /* No valid recipients */
 Recipients = 0;

 /* Any negative response aborts the message sending */
 MessageOK = (rc == SMTP_ACTION_OK);
}

/* Handle RCTP TO response */
void HandleRCPTTOResponse(ULONG rc, UMSMsgNum msgnum)
{
 switch (rc) {
  case SMTP_ACTION_OK:             /* Recipient OK                   */
  case SMTP_WILL_FORWARD:          /* Will be forwarded to recipient */

   /* We can export msg -> mark it */
   UMSSelectTags(Account, UMSTAG_SelMsg,        msgnum,
                          UMSTAG_SelWriteLocal, TRUE,
                          UMSTAG_SelSet,        MARKBIT,
                          TAG_DONE);

   /* Increment valid recipients count */
   Recipients++;
   break;

  case SMTP_SERVICE_NOT_AVAILABLE: /* Connection lost */

   /* Abort message sending */
   MessageOK = FALSE;
   break;

  default:                         /* All other cases: Can't export msg */
   sprintf(AddrBuf, "Recipient not accepted (SMTP-Error %d)", rc);
   MarkMessage(msgnum, FALSE, AddrBuf);
   break;
 }
}

/* Queue sender (MAIL FROM: command) */
static ULONG QueueSender(const char *address, ULONG msglen, BOOL eightbit)
{
 ULONG cmdlen;

 /* Build start of command with senders address */
 cmdlen = sprintf(OutputBuffer, "MAIL FROM: <%s>", address);

 /* Does server support ESMTP SIZE extension? Yes, add size parameter */
 if (ESMTPSize) cmdlen += sprintf(OutputBuffer + cmdlen, " SIZE=%d", msglen);

 /* Does server support ESMTP 8BITMIME extension? Yes, add body parameter */
 if (MIME8Bit) cmdlen += sprintf(OutputBuffer + cmdlen, " BODY=%s",
                                 eightbit ? "8BITMIME" : "7BIT");

 /* Append line terminator */
 strcpy(OutputBuffer + cmdlen, "\r\n");

 /* Queue command */
 return(QueueCommand(OutputBuffer, cmdlen + 2, QUEUETYPE_MAILFROM, 0));
}

/* Queue recipient (RCPT TO: command) */
static ULONG QueueRecipient(struct UMSRFCData *urd, const char *addr,
                            const char *name, UMSMsgNum msgnum)
{
 ULONG rc = SMTP_SERVICE_NOT_AVAILABLE;

 /* Convert address first */
 if (UMSRFCConvertUMSAddress(urd, addr, name, AddrBuf)) {
  ULONG linelen;

  /* Address converted, build command */
  linelen = sprintf(OutputBuffer, "RCPT TO: <%s>\r\n", AddrBuf);

  /* Queue command */
  rc = QueueCommand(OutputBuffer, linelen, QUEUETYPE_RCPTTO, msgnum);

 } else

  /* Error, can't convert recipients address. We can't export this message! */
  MarkMessage(msgnum, FALSE, "Error in recipients address!");

 /* Return state of connection */
 return(rc);
}


/* Send message data */
static ULONG SendData(const char *buffer, ULONG length)
{
 ULONG rc;

 /* Yes, queue DATA command */
 QueueCommand("DATA\r\n", 6, QUEUETYPE_IGNORE, 0);

 /* Empty queue and check if server is ready */
 if ((rc = EmptyQueue()) == SMTP_START_MAIL_INPUT) {

  /* Any valid recipients? */
  if (Recipients > 0) {

   DEBUGLOG(kprintf("Sending message (%ld recipients)...", Recipients);)

   /* Yes, send message */
   Send(SMTPSocket, buffer, length, 0);

   /* Send message terminator */
   Send(SMTPSocket, "\r\n.\r\n", 5, 0);

   DEBUGLOG(kprintf(" Finished\n");)

   printf(" sent...");
   fflush(stdout);

  } else {

   DEBUGLOG(kprintf("No valid recipients, sending empty message...\n");)

   /* No, just send an empty message */
   Send(SMTPSocket, ".\r\n", 3, 0);
  }

  /* Get response */
  rc = GetReturnCode();
 }

 return(rc);
}

/* Send an UMS message as SMTP mail */
ULONG SendMessage(struct UMSRFCData *urd, struct ConnectData *cd)
{
 char *filename = tmpnam(NULL);
 ULONG rc       = RETURN_FAIL;

 /* Open temporary file */
 if (od.od_Handle = Open(filename, MODE_NEWFILE)) {
  ULONG len;
  char *buf;

  /* Reset buffer */
  od.od_Counter = 0;

  /* Write UMS message as RFC message into temporary file */
  UMSRFCWriteMessage(urd, OutputFunction, &od, TRUE);

  /* Flush buffer */
  Write(od.od_Handle, OutputBuffer, od.od_Counter);

  /* Move to beginning of file */
  len = Seek(od.od_Handle, 0, OFFSET_BEGINNING);

  DEBUGLOG(kprintf("Length of msg: %ld Bytes\n", len);)

  /* Allocate memory for file */
  if (len && (buf = AllocMem(len, MEMF_PUBLIC))) {

   /* Read temporary file into memory */
   if (Read(od.od_Handle, buf, len) == len) {
    UMSMsgNum msgnum = urd->urd_MsgData.urmd_MsgNum;

    /* Delete temporary file */
    Close(od.od_Handle);
    DeleteFile(filename);

    /* If ConnectData is supplied then we are in multiple host mode */
    if (cd) {

     /* Connect to each single host and send message */

    } else {

     /* Single host mode: transmit all recipients, then the message */
     MessageOK = TRUE;

     /* Queue sender */
     if (((rc = QueueSender(urd->urd_FromAddress, len,
                            urd->urd_Flags & UMSRFC_FLAGS_MSGIS8BIT))
           != SMTP_SERVICE_NOT_AVAILABLE) &&

     /* Queue first recipient */
         ((rc = QueueRecipient(urd, urd->urd_MsgFields[UMSCODE_ToAddr],
                                    urd->urd_MsgFields[UMSCODE_ToName],
                                    msgnum))
           != SMTP_SERVICE_NOT_AVAILABLE) &&

     /* No errors? */
         MessageOK) {
      UMSMsgNum currentnum;

      /* Message soft-linked? */
      if ((currentnum = urd->urd_MsgData.urmd_SoftLink) != 0) {
       char *toaddr;
       char *toname;
       UMSSet userflags;
       UMSMsgNum nextnum;

       /* Yes, scan soft-link until original message is reached again */
       while (MessageOK &&
              (rc != SMTP_SERVICE_NOT_AVAILABLE) &&
              (currentnum != msgnum)) {

        /* Read msg number & ToAddress of next soft-linked message */
        if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,    currentnum,
                                    UMSTAG_RUserFlags, &userflags,
                                    UMSTAG_RToAddr,    &toaddr,
                                    UMSTAG_RToName,    &toname,
                                    UMSTAG_RSoftLink,  &nextnum,
                                    TAG_DONE)) {

         /* Do we have read-access to the current (unread) message? */
         if ((userflags & (UMSUSTATF_Old | UMSUSTATF_ReadAccess))
              == UMSUSTATF_ReadAccess)

          /* Yes, queue recipient */
          rc = QueueRecipient(urd, toaddr, toname, currentnum);

         /* Free message */
         UMSFreeMsg(Account, currentnum);

        } else

         /* Error, abort message sending */
         MessageOK = FALSE;

        /* Get next message number */
        currentnum = nextnum;
       }
      }

      /* All OK? */
      if (MessageOK && (rc != SMTP_SERVICE_NOT_AVAILABLE))

       /* Yes send message */
       rc = SendData(buf, len);
     }

     /* Mail sent? */
     if (MessageOK && ((rc == SMTP_ACTION_OK) || (rc == SMTP_WILL_FORWARD))) {

      /* Yes, mark mails as exported.... */
      UMSMsgNum currentnum;

      /* Mark message */
      MarkMessage(msgnum, TRUE, NULL);

      /* Message soft-linked? */
      if ((currentnum = urd->urd_MsgData.urmd_SoftLink) != 0) {
       ULONG flags;
       UMSMsgNum nextnum;

       /* Yes, scan soft-link until original message is reached again */
       while (currentnum != msgnum)

        /* Read msg number & ToAddress of next soft-linked message */
        if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,     currentnum,
                                    UMSTAG_RLoginFlags, &flags,
                                    UMSTAG_RSoftLink,   &nextnum,
                                    TAG_DONE)) {

         /* Mark message if needed */
         if (flags & MARKBIT) MarkMessage(currentnum, TRUE, NULL);

         /* Free message */
         UMSFreeMsg(Account, currentnum);

         /* Get next message number */
         currentnum = nextnum;

        } else

         /* Error, leave loop */
         break;
      }

      /* All OK */
      rc = RETURN_OK;

     } else

      /* Error, queue RSET command */
      QueueCommand("RSET\r\n", 6, QUEUETYPE_IGNORE, 0);
    }

   } else {
    fprintf(stderr, "Couldn't read temporary file '%s'!\n", filename);

    /* Delete temporary file */
    Close(od.od_Handle);
    DeleteFile(filename);
   }

   /* Free message buffer */
   FreeMem(buf, len);

  } else {
   fprintf(stderr, "Couldn't allocate %d bytes for message buffer!\n", len);

   /* Delete temporary file */
   Close(od.od_Handle);
   DeleteFile(filename);
  }

 } else
  fprintf(stderr, "Couldn't open temporary file '%s'!\n", filename);

 return(rc);
}
