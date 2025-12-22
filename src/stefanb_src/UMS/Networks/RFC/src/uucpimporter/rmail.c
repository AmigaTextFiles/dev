/*
 * rmail.c  V1.0.00
 *
 * process incoming mail files
 *
 * (c) 1992-1997 Stefan Becker
 *
 */

#include "uuxqt.h"

int ReceiveMailFile(char *mailfile, char *mailbuf, char *recipient)
{
 int rc = RETURN_WARN;

 /* Translate CR-LF to LF */
 TranslateCRLF(mailbuf);

 /* Process RFC Header */
 if (UMSRFCReadMessage(URData, mailbuf, TRUE, FALSE)) {
  char *nextaddress;

  /* Process message */
  rc = RETURN_OK;

  /* Loop through all recipients */
  do {

   /* Scan for next address */
   if (nextaddress = strchr(recipient, ' '))
    /* Another address found -> remove ' ' and add string terminator */
    *nextaddress = '\0';

   /* Skip empty recipients */
   if (*recipient == '\0') continue;

   /* Process mail */
   if (UMSRFCPutMailMessage(URData, recipient) != 0)
    /* All OK */
    MailGood();

   else {
    /* Error */
    int tmprc;

    /* Log error */
    if ((tmprc = LogUMSError("Mail", mailfile, "msg id",
                  (char *) URData->urd_MailTags[UMSRFC_TAGS_MSGID].ti_Data,0))
         == RETURN_FAIL)
     nextaddress=NULL; /* Real error, break loop */

    /* Set error level */
    if (tmprc > rc) rc = tmprc;

    /* Count bad mail */
    MailBad();
   }

   /* Set pointer to next address */
   recipient = nextaddress + 1;

   /* Loop until last recipient has been processed */
  } while (nextaddress);
 }
 return(rc);
}
