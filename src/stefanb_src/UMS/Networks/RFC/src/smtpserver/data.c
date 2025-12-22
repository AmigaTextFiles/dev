/*
 * data.c V1.0.00
 *
 * UMS SMTP (server) receive mail message
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Local defines */
#define REPLY_OK     0
#define REPLY_FAILED 1
#define REPLY_TOOBIG 2

/* Local data */
static struct OutputData OutputData;
static struct InputData  InputData;
static char              OutBuffer[BUFLEN];

/* Initialize message receiving */
void InitMessageReceiving(void)
{
 /* Set output & input data */
 OutputData.od_DOSBase   = DOSBase;
 OutputData.od_Length    = BUFLEN;
 OutputData.od_Buffer    = OutBuffer;
 InputData.id_OutputData = &OutputData;
 InputData.id_FileName   = TempBuffer;
 InputData.id_Buffer     = LineBuffer;
 InputData.id_Length     = BUFLEN;
 InputData.id_SocketBase = SocketBase;
 InputData.id_Socket     = SMTPDSocket;
 InputData.id_SysBase    = SysBase;
}

/* Handle DATA command */
void HandleDATACommand(struct UMSRFCData *urd)
{
 ULONG rc = REPLY_FAILED;

 /* Create temporary file name */
 sprintf(TempBuffer, "T:UMSSMTPD_%d", FindTask(NULL));

 /* Open temporary output file */
 if (OutputData.od_Handle = Open(TempBuffer, MODE_NEWFILE)) {
  char *buf;

  /* Send response to remote client */
  Send(SMTPDSocket, INTTOSTR(SMTP_START_MAIL_INPUT) " Start mail input\r\n",
                    22, 0);

  /* Get article from client */
  if (buf = ReadMessageFromSocket(&InputData)) {

   DEBUGLOG(kprintf("Message length: %ld\n", InputData.id_MsgLength - 1);)

   /* Process message */
   if (UMSRFCReadMessage(urd, buf, TRUE, TRUE)) {
    struct RecipientNode *rn = GetHead(&RecipientList);

    DEBUGLOG(kprintf("Message parsed!\n");)

    /* Reset error flag */
    rc = REPLY_OK;

    /* For each user in recipient list */
    while (rn) {

     /* Yes, write message, ignore dupes */
     if ((UMSRFCPutMailMessage(urd, rn->rn_Recipient) == 0) &&
         (UMSErrNum(urd->urd_Account) != UMSERR_Dupe)) {
      char *id = (char *) urd->urd_MailTags[UMSRFC_TAGS_MSGID].ti_Data;

      /* Real error */
      UMSRFCLog(urd, "UMS error: %d - %s, msg-id <%s> from %s\n",
                  UMSErrNum(urd->urd_Account), UMSErrTxt(urd->urd_Account),
                  id ? id : "none", ClientName);

      /* Message too big? */
      if (UMSErrNum(urd->urd_Account) == UMSERR_ToBig) {

       /* Yes, send response to client */
       Send(SMTPDSocket, INTTOSTR(SMTP_OUT_OF_MEMORY)
                          " message too big\r\n", 21, 0);
       rc = REPLY_TOOBIG;

      } else

       /* Other error */
       rc = REPLY_FAILED;

      /* Leave loop */
      break;
     }

     /* Next recipient */
     rn = GetSucc(rn);
    }

    /* Send mail to all recipients? If yes, send response to client */
    if (rc == RETURN_OK)
     Send(SMTPDSocket, INTTOSTR(SMTP_ACTION_OK) " OK\r\n", 8, 0);

   } else
    /* Couldn't parse RFC message */
    UMSRFCLog(urd, "Couldn't parse RFC message!\n");

   FreeMem(buf, InputData.id_MsgLength);
  }
 }

 /* Error in processing? */
 if (rc == REPLY_FAILED)
  Send(SMTPDSocket, INTTOSTR(SMTP_ACTION_ABORTED)
                     " error in processing\r\n", 25, 0);
}
