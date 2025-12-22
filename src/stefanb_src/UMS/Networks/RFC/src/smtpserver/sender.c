/*
 * sender.c V1.0.01
 *
 * UMS SMTP (server) sender handling functions
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Global data */
char FromAddr[BUFLEN];
char FromName[BUFLEN];

/* Handle MAIL command */
BOOL HandleMAILCommand(struct UMSRFCData *urd, char *args)
{
 char *bp, *ep;
 BOOL rc       = FALSE;

 /* Check syntax and retrieve recipient */
 if ((strnicmp(args, "FROM:", 5) == 0) && (bp = strchr(args + 3, '<')) &&
     (ep = strchr(++bp, '>'))) {

  /* Syntax OK, add string terminator */
  *ep++ = '\0';

  /* Empty address? Yes, error message, Set dummy address */
  if (*bp == '\0') bp = "error@unknown";

  /* Convert RFC address */
  UMSRFCConvertRFCAddress(urd, bp, FromAddr, FromName);

  DEBUGLOG(kprintf("MAIL: '%s' Name: '%s' Addr: '%s'\n", bp, FromName,
                   FromAddr);)

  /* Check sender */
  if (UMSWriteMsgTags(urd->urd_Account, UMSTAG_WFromName,    FromName,
                                        UMSTAG_WFromAddr,    FromAddr,
                                        UMSTAG_WToName,      "postmaster",
                                        UMSTAG_WSubject,     "dummy",
                                        UMSTAG_WAutoBounce,  FALSE,
                                        UMSTAG_WCheckHeader, TRUE,
                                        TAG_DONE)) {
   /* Sender OK */
   rc = TRUE;

   /* Check for ESMTP parameters */
   if (*ep)

    /* Scan ESMTP parameters */
    while (bp = ep) {

     /* Skip spaces */
     while (*bp == ' ') bp++;

     DEBUGLOG(kprintf("Rest of parameters: '%s'\n", bp);)

     /* Check for SIZE parameter */
     if (strnicmp(bp, "SIZE=", 5) == 0) {
      char *tmp;

      /* Get message size and check with maximum size */
      if (strtol(bp + 5, &tmp, 10) > MaxMsgSize) {

       /* Message to big */
       rc = FALSE;

       /* Send error message */
       QueueResponse(INTTOSTR(SMTP_OUT_OF_MEMORY) " message too big\r\n", 21);

       /* Leave loop */
       break;

      } else
       /* Message size OK */
       ep = tmp;

     /* Check for BODY parameter */
     } else if (strnicmp(bp, "BODY=", 5) == 0) {

      /* We accept a BODY parameter, but we ignore it */
      ep = bp + 5;

     /* Check for Unknown parameter */
     } else if (*bp) {
      /* Set error code */
      rc = FALSE;

      /* Send error message */
      QueueResponse(INTTOSTR(SMTP_UNKNOWN_PARAMETER)
                     " unknown ESMTP parameter\r\n", 29);

      /* Leave loop */
      break;

     /* End of line */
     } else
      ep = bp;

     /* Skip to next parameter */
     ep = strchr(ep, ' ');
    }

  } else
   /* Recipient unknown */
   QueueResponse(INTTOSTR(SMTP_ACTION_NOT_TAKEN) " sender not allowed\r\n",
                 24);

 } else
  /* Syntax error */
  QueueResponse(SyntaxError, 18);

 return(rc);
}
