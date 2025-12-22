/*
 * cmdloop.c V1.0.00
 *
 * UMS SMTP (server) command processing loop
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Constant strings */
static const char HelpText[] =
 INTTOSTR(SMTP_HELP) "-help text follows\r\n"
 INTTOSTR(SMTP_HELP) "-\r\n"
 INTTOSTR(SMTP_HELP) "-UMS SMTP Server V" INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                                          INTTOSTR(UMSRFC_REVISION)   " ("
                                          __COMMODORE_DATE__          ")\r\n"
 INTTOSTR(SMTP_HELP) "-\r\n"
 INTTOSTR(SMTP_HELP) "-Currently implemented commands:\r\n"
 INTTOSTR(SMTP_HELP) "-\r\n"
 INTTOSTR(SMTP_HELP) "-\tDATA, MAIL, NOOP, QUIT, RCPT, RSET\r\n"
 INTTOSTR(SMTP_HELP) "-\r\n"
 INTTOSTR(SMTP_HELP) "-If there are any problems with this mail server,"
                     " please contact:\r\n"
 INTTOSTR(SMTP_HELP) "-\r\n"
 INTTOSTR(SMTP_HELP) "-\t<postmaster@%s>\r\n"
 INTTOSTR(SMTP_HELP) " \r\n";
const char SyntaxError[] = INTTOSTR(SMTP_SYNTAX_ERROR) " syntax error\r\n";

/* Local data structures */
enum SMTPState {SMTP_NORMAL, /* Normal state                           */
                SMTP_MAIL,   /* Received "MAIL", buffers cleared       */
                SMTP_RCPT};  /* Received "RCPT", collecting recipients */

/* SMTP command loop */
LONG CommandLoop(struct UMSRFCData *urd)
{
 UMSAccount Account   = urd->urd_Account;
 char *lp             = LineBuffer;
 enum SMTPState state = SMTP_NORMAL;
 LONG rc              = RETURN_FAIL;
 BOOL logcmd          = FALSE;
 BOOL notend          = TRUE;

 /* Initialize recipient list */
 NewList(&RecipientList);

 /* Initialize message receiver */
 InitMessageReceiving();

 /* Command log enabled? */
 {
  char *cp;

  /* Read UMS config var */
  if (cp = UMSReadConfigTags(Account, UMSTAG_CfgName, "smtpd.log",
                                      TAG_DONE)) {
   /* Set log variable */
   logcmd = (*cp == 'y') || (*cp == 'Y');

   /* Free UMS config var */
   UMSFreeConfig(Account, cp);
  }
 }

 /* Command loop */
 while (notend) {

  /* Read command line from client */
  if (notend = ReadLine(SocketBase, SMTPDSocket, lp, BUFLEN)) {

   /* Command line not empty? */
   if (*lp) {
    char *tp = lp;
    char c;

    DEBUGLOG(kprintf("(%08lx) CMD: '%s'\n", FindTask(NULL), lp);)

    /* Log command ? */
    if (logcmd) UMSLog(Account, 4, "SMTPD: '%s'", lp);

    /* Check for fatal UMS errors */
    if (UMSErrNum(Account) >= UMSERR_ServerTerminated) break;

    /* Seperate command */
    while ((c = *tp) && (c != ' ') && (c != '\t')) tp++;
    *tp = '\0';

    /* Move to first argument (if any) */
    if (c) {
     tp++;
     while ((c = *tp) && ((c == ' ') || (c == '\t'))) tp++;
    }

/************************ Mail transaction commands **************************/
    /* MAIL */
    if (stricmp(lp, "MAIL") == 0) {
     /* Start new mail transaction */

     /* Sender OK? */
     if (HandleMAILCommand(urd, tp)) {

      /* Yes, send reply */
      QueueResponse(INTTOSTR(SMTP_ACTION_OK) " sender OK\r\n", 15);

      /* Free old recipient list */
      FreeRecipients();

      /* Move to new state */
      state = SMTP_MAIL;
     }

    /* RCPT */
    } else if (stricmp(lp, "RCPT") == 0) {
     /* Next recipient */

     /* Check state first */
     if (state != SMTP_NORMAL) {

      /* Recipient OK? */
      if (HandleRCPTCommand(urd, tp)) {

       /* Recipient OK, send reply */
       QueueResponse(INTTOSTR(SMTP_ACTION_OK) " recipient OK\r\n", 18);

       /* Move to new state */
       state = SMTP_RCPT;
      }

     } else
      /* Not in mail receiving state */
      QueueResponse(INTTOSTR(SMTP_BAD_SEQUENCE) " must send MAIL first\r\n",
                    26);

    /* DATA */
    } else if (stricmp(lp, "DATA") == 0) {
     /* Start mail transmission */

     /* No queueing allowed */
     FlushResponseBuffer();

     /* Check state first */
     if (state == SMTP_RCPT) {

#ifdef DEBUG
      /* Print recipient list */
      {
       struct RecipientNode *rn = GetHead(&RecipientList);

       while (rn) {
        kprintf("recipient: %s\n", rn->rn_Recipient);
        rn = GetSucc(rn);
       }
      }
#endif

      /* Receive mail message */
      HandleDATACommand(urd);

     } else
      /* Not in mail receiving state or no recipient yet */
      Send(SMTPDSocket, INTTOSTR(SMTP_BAD_SEQUENCE)
                         " must send RCPT first\r\n", 26, 0);

    /* RSET */
    } else if (stricmp(lp, "RSET") == 0) {

     /* Reset state */
     state = SMTP_NORMAL;

     /* Queue response */
     QueueResponse(INTTOSTR(SMTP_ACTION_OK) " OK\r\n", 8);

/***************************** Misc. commands *******************************/
    /* QUIT */
    } else if (stricmp(lp, "QUIT") == 0) {
     /* End of processing */
     rc = RETURN_OK;

     /* Leave loop */
     notend = FALSE;

    /* HELP */
    } else if (stricmp(lp, "HELP") == 0) {
     ULONG len;

     /* No queueing allowed */
     FlushResponseBuffer();

     /* Send help text */
     len = sprintf(LineBuffer, HelpText, urd->urd_DomainName);
     Send(SMTPDSocket, LineBuffer, len, 0);

    /* NOOP */
    } else if (stricmp(lp, "NOOP") == 0) {
     /* No queueing allowed */
     FlushResponseBuffer();

     /* Send acknowledgement */
     Send(SMTPDSocket, INTTOSTR(SMTP_ACTION_OK) " OK\r\n", 8, 0);

/***************************** Unknown command *******************************/
    } else {
     /* No queueing allowed */
     FlushResponseBuffer();

     /* Send error response */
     Send(SMTPDSocket, INTTOSTR(SMTP_ERROR) " unknown command\r\n", 21, 0);
    }

    DEBUGLOG(kprintf("(%08lx) UMS Error: %ld - %s\n", FindTask(NULL),
                      UMSErrNum(Account), UMSErrTxt(Account));)
   }
  }
 }

 /* Free recipient list */
 FreeRecipients();

 return(rc);
}
