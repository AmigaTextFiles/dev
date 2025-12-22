/*
 * greeting.c V1.0.01
 *
 * UMS SMTP (client) greeting handling routines
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtp.h"

/* Global data */
char LineBuffer[BUFLEN];
BOOL ESMTPSize;
BOOL MIME8Bit;

/* Read answer from server */
ULONG GetReturnCode(void)
{
 ULONG rc;
 char *p;

 /* Read multiple lines from server */
 do {

  /* Read line from server */
  if (ReadLine(SocketBase, SMTPSocket, LineBuffer, BUFLEN)) {

   DEBUGLOG(kprintf("%s\n", LineBuffer);)

   /* Convert number */
   rc = strtol(LineBuffer, &p, 10);

  } else {
   /* Error! */
   rc = SMTP_SERVICE_NOT_AVAILABLE;

   /* Leave loop */
   break;
  }

  /* Multiple line reply? */
 } while (*p != ' ');

 return(rc);
}

/* Initiate connection to new host */
ULONG InitConnection(struct UMSRFCData *urd, struct ConnectData *cd,
                     const char* host)
{
 ULONG rc = SMTP_SERVICE_NOT_AVAILABLE;

 /* Connect to host */
 if (ConnectToHost(cd, host) == CONNECT_OK) {

  /* Set Socket */
  SMTPSocket = cd->cd_Socket;

  /* Service ready? */
  if (GetReturnCode() == SMTP_SERVICE_READY) {
   ULONG len;
   char *domainname = (urd->urd_Flags & UMSRFC_FLAGS_NOOWNFQDN) ?
                       "privatehost" : urd->urd_DomainName;

   /* Create & send EHLO line. Does the system have a own domain name? */
   len = sprintf(LineBuffer, "EHLO %s\r\n", domainname);
   Send(SMTPSocket, LineBuffer, len, 0);

   /* Check if server supports ESMTP. Read line from server */
   if (ReadLine(SocketBase, SMTPSocket, LineBuffer, BUFLEN)) {
    char *p;

    DEBUGLOG(kprintf("%s\n", LineBuffer);)

    /* Reset ESMTP flags */
    ESMTPSize = FALSE;
    MIME8Bit  = FALSE;

    /* Disable command queuing */
    DisableQueue();

    /* Get return code. ESMTP supported? */
    if (strtol(LineBuffer, &p, 10) == SMTP_ACTION_OK) {

     DEBUGLOG(kprintf("Server supports ESMTP. Scanning options\n");)

     /* Yes, scan options list */
     while (*p != ' ') {
      char *option;

      /* Read next line from server */
      if (!ReadLine(SocketBase, SMTPSocket, LineBuffer, BUFLEN)) {
       /* Error! */
       rc = SMTP_SERVICE_NOT_AVAILABLE;
       break;
      }

      DEBUGLOG(kprintf("Next option: %s\n", LineBuffer);)

      /* Convert number */
      rc = strtol(LineBuffer, &p, 10);

      /* Check available options */
      option = p + 1;
      if      (strnicmp(option, "SIZE",        4) == 0) ESMTPSize = TRUE;
      else if (strnicmp(option, "8BITMIME",    8) == 0) MIME8Bit  = TRUE;
      else if (strnicmp(option, "PIPELINING", 10) == 0) EnableQueue();
     }

     DEBUGLOG(kprintf("End of options\n");)

    } else {
     /* No. Check if rest of response was complete */
     if (*p != ' ') GetReturnCode();

     /* Send standard HELO command */
     len = sprintf(LineBuffer, "HELO %s\r\n", domainname);
     Send(SMTPSocket, LineBuffer, len, 0);

     /* Get return code */
     rc = GetReturnCode();
    }

    /* 8BITMIME allowed? */
    urd->urd_Flags = (urd->urd_Flags & ~UMSRFC_FLAGS_8BITALLOWED) |
                     (MIME8Bit ? UMSRFC_FLAGS_8BITALLOWED : 0);
   }
  }

  /* Connection established? */
  if (rc != SMTP_ACTION_OK) CloseConnection(cd);
 }

 return(rc);
}
