/*
 * getmsgs.c V1.0.00
 *
 * UMS POP3 (client) retrieve messages from mail box
 *
 * (c) 1994-96 Stefan Becker
 */

#include "umspop3.h"

/* Retrieve messages from mail box */
ULONG GetMessages(struct UMSRFCData *urd, ULONG maxmsgs, const char *recipient,
                  BOOL delete)
{
 UMSAccount account = urd->urd_Account;
 ULONG rc           = RETURN_OK;
 ULONG i;

 /* For each message in mail box */
 for (i = 1; (i <= maxmsgs) && (rc == RETURN_OK); i++) {
  LONG n;

  /* Request message */
  n = sprintf(Buffer, "RETR %d\r\n", i);
  Send(POP3Socket, Buffer, n, 0);

  /* Read one line from server */
  if (ReadLine(SocketBase, POP3Socket, Buffer, BUFLEN)) {

   DEBUGLOG(kprintf("%s", Buffer);)

   /* No, check return code */
   if (*Buffer == '+') {

    /* Open temporary output file */
    if (InputData.id_OutputData->od_Handle = Open(InputData.id_FileName,
                                                  MODE_NEWFILE)) {
     char *buf;

     /* Get article from client */
     if (buf = ReadMessageFromSocket(&InputData)) {

      DEBUGLOG(kprintf("Mail length: %ld\n", InputData.id_MsgLength - 1);)

      /* Process message */
      if (UMSRFCReadMessage(urd, buf, TRUE, TRUE)) {
       char *msgid = (char *) urd->urd_MailTags[UMSRFC_TAGS_MSGID].ti_Data;
       BOOL dupe = FALSE;

       printf("Retrieving message <%s>...", msgid ? msgid : "");
       fflush(stdout);

       /* Yes, write message, check for "dupes" */
       if ((UMSRFCPutMailMessage(urd, recipient) != 0) ||
           (dupe = (UMSErrNum(account) == UMSERR_Dupe))) {
        ULONG linelen;

        /* Delete messages? */
        if (delete) {
         /* Message written, delete it from mail box */
         linelen = sprintf(Buffer, "DELE %d\r\n", i);
         Send(POP3Socket, Buffer, linelen, 0);

         /* Read response from server */
         GetReturnCode();
        }

        /* Print result */
        if (dupe)
         printf(" dupe\n");
        else
         printf(" done\n");

       } else {
        /* Real error! */
        printf(" error\n");
        fprintf(stderr, "UMS error %d (%s)!\n",
                        UMSErrNum(account), UMSErrTxt(account));
        if (UMSErrNum(account) >= UMSERR_ServerTerminated)
         rc = RETURN_FAIL;
       }

      } else {
       fprintf(stderr, "Couldn't process message!\n");
       rc = RETURN_FAIL;
      }

      /* Free message buffer */
      FreeMem(buf, InputData.id_MsgLength);
     } else {
      fprintf(stderr, "Couldn't read message from server!\n");
      rc = RETURN_FAIL;
     }

    } else
     fprintf(stderr, "Couldn't create temporary file '%s'!\n",
                     InputData.id_FileName);

   } else
    /* Error */
    rc = RETURN_FAIL;

   /* Read error */
  } else
   rc = RETURN_FAIL;
 }

 return(rc);
}
