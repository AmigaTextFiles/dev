/*
 * rbsmtp.c  V1.0.00
 *
 * process incoming batched SMTP (Simple Mail Transfer Protocol) files
 *
 * (c) 1992-97 Stefan Becker
 *
 */

#include "uuxqt.h"

/* Constant strings */
static const char RCPTTOCmd[]="RCPT TO:";

/* Get user name from SMTP command line */
static char *GetUserName(char **line, BOOL terminate)
{
 char *bra, *ket;

 /* Find opening and closing braket */
 if ((bra = strchr(*line, '<')) && (ket = strchr(bra + 1, '>'))) {

  /* Set string terminator */
  if (terminate) *ket = '\0';

  /* Position read pointer after address */
  *line = ket + 1;

  /* Return pointer to user name */
  return(bra + 1);
 }
 return(NULL);
}

int ReceiveBSMTPFile(char *bsmtpfile, char *bsmtpbuf)
{
 char *mp          = bsmtpbuf;
 char *mailfrom    = NULL;
 char *rcptto      = NULL;
 char *nextaddress;
 ULONG recipients;
 int rc            = RETURN_OK;

 /* Translate CR-LF to LF */
 TranslateCRLF(mp);

 /* Process batch */
 while ((rc != RETURN_FAIL) && mp && *mp) {
  char *endl;

  /* Set string terminator at end of command line */
  if (endl = strchr(mp, '\n')) *endl++ = '\0';

  /* Interpret SMTP command */
  if (strnicmp(mp, "MAIL FROM:", 10) == 0) {
   /* "MAIL FROM: <user>" - Recipient */
   /* Get user name */
   mp       += 10;
   mailfrom  = GetUserName(&mp, TRUE);

   /* Reset recipient data */
   rcptto     = NULL;
   recipients = 0;

  } else if (strnicmp(mp, RCPTTOCmd, 8) == 0) {
   /* "RCPT TO: <user>" - Recipient */
   char *tmp;

   /* Check user name */
   mp += 8;
   if (tmp = GetUserName(&mp, (rcptto == NULL) ? TRUE : FALSE)) {
    /* Valid recipient address */
    recipients++;

    /* First recipient? Yes, save pointers */
    if (rcptto == NULL) {
     rcptto      = tmp;
     nextaddress = mp;
    }
   }

  } else if (strnicmp(mp, "DATA", 4) == 0) {
   /* "DATA" - Mail data. Check if mail data follows and    */
   /* search end of mail data  (a line with only "." on it) */
   if ((mp = endl) && (endl = strstr(endl, "\n.\n"))) {

    /* Check if From/To lines are set */
    if (mailfrom && rcptto) {

     /* Append string terminator */
     *endl  = '\0';
     endl  += 3; /* Move end pointer behind '\n' */

     /* Process RFC Header */
     if (UMSRFCReadMessage(URData, mp, TRUE, TRUE)) {

      /* Loop through all recipients */
      while (recipients-- > 0) {

       /* Process RFC Mail */
       if (UMSRFCPutMailMessage(URData, rcptto))
        /* All OK */
        MailGood();

       else {
        /* Error */
        int tmprc;

        /* Log error */
        if ((tmprc = LogUMSError("BSMTP", bsmtpfile, "mail from", mailfrom,
                                 mp - bsmtpbuf)) == RETURN_FAIL) {
         rc = RETURN_FAIL;
         break; /* Real error, break loop */
        }

        /* Set error level */
        if (tmprc > rc) rc = tmprc;

        /* Count bad mail */
        MailBad();
       }

       /* Get next recipient */
       if (recipients > 0)
        while (TRUE) {

         /* Goto begin of next line */
         nextaddress += strlen(nextaddress) + 1;

         /* "RCPT TO:" command? */
         if (strnicmp(nextaddress, RCPTTOCmd, 8) == 0) {

          /* Get user name */
          nextaddress += 8;
          if (rcptto = GetUserName(&nextaddress, TRUE))
           break; /* Valid address */
         }
        }
      }

      /* Corrupt RFC header */
     } else
      rc = RETURN_WARN;

    } else {
     UMSRFCLog(URData, "(BSMTP) Missing 'MAIL FROM:' or 'RCPT TO:' line!\n");
     rc = RETURN_WARN;
    }

   } else {
    UMSRFCLog(URData, "corrupted BSMTP file '%s' (offset: %d)!\n", bsmtpfile,
              mp - bsmtpbuf);
    rc = RETURN_WARN;
    break;
   }

   /* Reset user name pointer */
   mailfrom = NULL;

  } else if (strnicmp(mp, "QUIT", 4) == 0)
   /* "QUIT" - End of BSMTP file reached */
   break;

  /* Set pointer to next line */
  mp = endl;
 }
 return(rc);
}
