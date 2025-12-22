/*
 * greeting.c V1.0.01
 *
 * UMS SMTP (server) greeting handling routines
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Global data */
char LineBuffer[BUFLEN];
char TempBuffer[BUFLEN];
char ClientName[BUFLEN];

/* Get client name */
static BOOL GetClientName(char *buf)
{
 BOOL rc = FALSE;

 /* Skip HELO/EHLO command */
 buf += 5;

 /* Skip white space */
 {
  char c;

  while (((c = *buf) == ' ') || (c == '\t')) buf++;
 }

 /* Does a name follow? */
 if (*buf != '\0') {

  /* Yes, set return code */
  rc = TRUE;

  /* Copy client name */
  strcpy(ClientName, buf);

 } else
  /* No name given, how rude... */
  Send(SMTPDSocket, INTTOSTR(SMTP_SYNTAX_ERROR)
                     " please send your name\r\n", 27,0);

 return(rc);
}

/* Handle greeting and start SMTP command processing */
LONG HandleGreeting(struct UMSRFCData *urd)
{
 LONG rc = RETURN_FAIL;

 /* Create & send greeting message */
 {
  ULONG len;

  len = sprintf(TempBuffer,
                 INTTOSTR(SMTP_SERVICE_READY) " %s UMS SMTP server V"
                 INTTOSTR(UMSRFC_LIBRARY_VERSION) "." INTTOSTR(UMSRFC_REVISION)
                 " ready\r\n", urd->urd_DomainName);
  Send(SMTPDSocket, TempBuffer, len, 0);
 }

 /* Wait for HELO/EHLO command. Read command line from client */
 while (ReadLine(SocketBase, SMTPDSocket, LineBuffer, BUFLEN)) {

  /* Check for HELO command */
  if (strnicmp(LineBuffer, "HELO ", 5) == 0) {

   /* Client name valid? */
   if (GetClientName(LineBuffer)) {

    /* Yes, send reply */
    Send(SMTPDSocket, INTTOSTR(SMTP_ACTION_OK)
                      " nice to meet you\r\n", 22, 0);

    /* Start SMTP command processing */
    rc = CommandLoop(urd);

    /* Leave loop */
    break;
   }

  /* Check for EHLO command */
  } else if (strnicmp(LineBuffer, "EHLO ", 5) == 0) {

   /* Client name valid? */
   if (GetClientName(LineBuffer)) {
    ULONG len;

    /* Yes, create & send reply */
    len = sprintf(TempBuffer, INTTOSTR(SMTP_ACTION_OK) "-nice to meet you\r\n"
                              INTTOSTR(SMTP_ACTION_OK) "-HELP\r\n"
                              INTTOSTR(SMTP_ACTION_OK) "-PIPELINING\r\n"
                              INTTOSTR(SMTP_ACTION_OK) "-8BITMIME\r\n"
                              INTTOSTR(SMTP_ACTION_OK) " SIZE %d\r\n",
                              MaxMsgSize);
    Send(SMTPDSocket, TempBuffer, len, 0);

    /* Start SMTP command processing */
    rc = CommandLoop(urd);

    /* Leave loop */
    break;
   }

  /* Unknown command, send error reply */
  } else
   Send(SMTPDSocket, INTTOSTR(SMTP_ERROR) " must send HELO/EHLO first\r\n",
                     31, 0);

  DEBUGLOG(kprintf("Loop\n");)
 }
}
