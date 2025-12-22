/*
 * sendarticle.c V1.0.01
 *
 * UMS NNTP (client) get an UMS message and send it as news article
 *
 * (c) 1994-98 by Stefan Becker
 */

#include "umsnntp.h"

/* Data for output function */
static struct OutputData od;
static char OutputBuffer[BUFLEN];

/* Init message sending */
void InitSendArticle(void)
{
 od.od_DOSBase = DOSBase;
 od.od_Handle  = NULL;
 od.od_Counter = 0;
 od.od_Length  = BUFLEN;
 od.od_Buffer  = OutputBuffer;
}

/* Send buffer contents to remote host */
static ULONG SendBuffer(const char *buf, ULONG len)
{
 LONG Socket = CmdData.ncd_ConnectData.cd_Socket;

 DEBUGLOG(kprintf("Sending message...");)

 /* Send the whole bunch of bytes :-) */
 Send(Socket, buf, len, 0);

 /* Send message terminator */
 Send(Socket, "\r\n.\r\n", 5, 0);

 DEBUGLOG(kprintf(" Finished\n");)

 printf(" sent...");
 fflush(stdout);

 return(GetReturnCode(&CmdData));
}

/* Unselect all hard-linked messages */
static void UnselectMsgs(struct UMSRFCData *urd)
{
 /* Clear local select bit on current msg (and all hard-linked msgs) */
 UMSSelectTags(urd->urd_Account, UMSTAG_SelMsg,        urd->urd_MsgData.urmd_MsgNum,
                                 UMSTAG_SelWriteLocal, TRUE,
                                 UMSTAG_SelUnset,      SELBIT,
                                 TAG_DONE);
}

/* Mark message(s) as exported */
static void Exported(struct UMSRFCData *urd)
{
 UMSExportedMsg(urd->urd_Account, urd->urd_MsgData.urmd_MsgNum);
 UnselectMsgs(urd);
}

/* Send an UMS message as NNTP mail */
ULONG SendArticle(struct UMSRFCData *urd, BOOL modereader)
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
    UMSAccount account = urd->urd_Account;
    UMSMsgNum  msgnum  = urd->urd_MsgData.urmd_MsgNum;

    /* Delete temporary file */
    Close(od.od_Handle);
    DeleteFile(filename);

    /* MODE READER? */
    if (modereader) {

     /* Yes, use "POST" command, get return code and send article */
     if (((rc = SendNNTPCommand(&CmdData, "POST\r\n", 6))
           == NNTP_POST_ARTICLE) &&
         ((rc = SendBuffer(buf, len)) == NNTP_ARTICLE_POSTED)) {

      /* Post successful, mark message as exported */
      Exported(urd);

      /* Article accepted */
      rc = RETURN_OK;
     }

     /* No, use "IHAVE" command */
    } else {
     ULONG linelen;

     /* Send "IHAVE <Message-ID>" command */
     linelen = sprintf(OutputBuffer, "IHAVE <%s>\r\n",
                                     urd->urd_MsgFields[UMSCODE_MsgID]);

     /* Send command and get return code */
     switch (rc = SendNNTPCommand(&CmdData, OutputBuffer, linelen)) {

      case NNTP_SEND_ARTICLE:         /* Server wants this message */
       switch (rc = SendBuffer(buf, len)) {

        case NNTP_ARTICLE_TRANSFERRED: /* Transfer successful */
         Exported(urd);
         rc = RETURN_OK;
         break;

        case NNTP_ARTICLE_REJECTED:    /* Server doesn't want this message */
         UMSCannotExport(account, msgnum, "Article rejected");
         UnselectMsgs(urd);
         break;
       }
       break;

      case NNTP_ARTICLE_NOT_WANTED:   /* Server already has this message */
       Exported(urd);
       break;

      case NNTP_TRANSFER_NOT_ALLOWED: /* IHAVE not allowed -> Abort */
       printf(" IHAVE mode not allowed");
       fflush(stdout);
       rc = RETURN_FAIL;
       break;
     }
    }

   } else {
    fprintf(stderr, "Couldn't read temporary file '%s'!\n", filename);

    /* Delete temporary file */
    Close(od.od_Handle);
    DeleteFile(filename);
   }

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
