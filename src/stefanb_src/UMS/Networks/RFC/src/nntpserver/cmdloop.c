/*
 * cmdloop.c V1.0.01
 *
 * UMS NNTP (server) command processing loop
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsnntpd.h"

/* Constant strings */
static const char HelpText[] =
 INTTOSTR(NNTP_HELP)" help text follows\r\n"
 "\r\n"
 "UMS NNTP Server V" INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                     INTTOSTR(UMSRFC_REVISION)
                     " (" __COMMODORE_DATE__ ")"
 "\r\n"
 "Currently implemented commands:\r\n"
 "\r\n"
 "\tARTICLE, BODY, GROUP, HEAD, HELP, LAST, LIST,\r\n"
 "\tNEWGROUPS, NEWNEWS, NEXT, QUIT, SLAVE, STAT,\r\n"
 "\tXHDR, XOVER\r\n"
 "\r\n"
 "If there are any problems with this news server, please contact:\r\n"
 "\r\n"
 "\t<postmaster@%s>\r\n"
 ".\r\n";

/* Global data */
char LineBuffer[BUFLEN];

/* NNTP command loop */
ULONG CommandLoop(struct UMSRFCData *urd)
{
 UMSAccount Account = urd->urd_Account;
 char *lp           = LineBuffer;
 ULONG rc           = RETURN_FAIL;
 BOOL logcmd        = FALSE;
 BOOL notend        = TRUE;

 /* Command log enabled? */
 {
  char *cp;

  /* Read UMS config var */
  if (cp = UMSReadConfigTags(Account, UMSTAG_CfgName, "nntpd.log",
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
  if (notend = ReadLine(SocketBase, NNTPDSocket, lp, BUFLEN)) {

   /* Command line not empty? */
   if (*lp) {
    char *tp = lp;
    char c;

    DEBUGLOG(kprintf("(%08lx) CMD: '%s'\n", FindTask(NULL), lp);)

    /* Log command ? */
    if (logcmd) UMSLog(Account, 4, "NNTPD: '%s'", lp);

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

/**************** Move current article pointer commands *********************/
    /* NEXT */
    if (stricmp(lp, "NEXT") == 0) {
     /* Move current article pointer to next article in current newsgroup */

     MoveCurrentPointer(urd, 1);

    /* LAST */
    } else if (stricmp(lp, "LAST") == 0) {
     /* Move current article pointer to previous article in current group */

     MoveCurrentPointer(urd, -1);

    /* GROUP */
    } else if (stricmp(lp, "GROUP") == 0) {
     /* Select current newsgroup. Reset current article pointer */

     HandleGROUPCommand(urd, tp);

/************************ Retrieve article commands **************************/
    /* STAT */
    } else if (stricmp(lp, "STAT") == 0) {
     /* [Set current article pointer] Send information about [current] art. */

     RetrieveArticle(urd, ACTION_STAT, tp);

    /* HEAD */
    } else if (stricmp(lp, "HEAD") == 0) {
     /* [Set current article pointer] Send header of [current] article */

     RetrieveArticle(urd, ACTION_HEAD, tp);

    /* BODY */
    } else if (stricmp(lp, "BODY") == 0) {
     /* [Set current article pointer] Send body of [current] article */

     RetrieveArticle(urd, ACTION_BODY, tp);

    /* ARTICLE */
    } else if (stricmp(lp, "ARTICLE") == 0) {
     /* [Set current article pointer] Send [current] article */

     RetrieveArticle(urd, ACTION_ARTICLE, tp);

/************************ Post/send article commands *************************/
    /* POST */
    } else if (stricmp(lp, "POST") == 0) {
     /* Client wants to post an article */

     /* Check access right */
     if (AccessData->ad_Flags & NNTPDF_POSTING)

      /* Posting allowed, receive article */
      if (ReceiveArticle(urd, INTTOSTR(NNTP_POST_ARTICLE)
                               " send article to be posted\r\n", 31))

       /* Posted */
       Send(NNTPDSocket, INTTOSTR(NNTP_ARTICLE_POSTED) " article posted\r\n",
                          20, 0);

      else
       /* NOT posted */
       Send(NNTPDSocket, INTTOSTR(NNTP_POSTING_FAILED) " posting failed\r\n",
                          20, 0);

     else
      /* Posting NOT allowed, send error message */
      Send(NNTPDSocket, INTTOSTR(NNTP_POSTING_NOT_ALLOWED)
                         " posting not allowed\r\n", 25, 0);

    /* IHAVE */
    } else if (stricmp(lp, "IHAVE") == 0) {
     /* Server wants to send a new article */

     /* Check access rights */
     if ((AccessData->ad_Flags & (NNTPDF_POSTING | NNTPDF_SERVER)) ==
          (NNTPDF_POSTING | NNTPDF_SERVER)) {
      char *ep;

      /* Client is server and posting allowed, extract message id */
      if ((*tp == '<') && (ep = strchr(++tp, '>'))) {

       /* Append string terminator to message id */
       *ep = '\0';

       /* Check message id */
       if (UMSSearchTags(Account, UMSTAG_WMsgID,      tp,
                                  UMSTAG_SearchQuick, TRUE,
                                  TAG_DONE) == 0)

        /* Message ID not found. Must be a new article. Get it now */
        if (ReceiveArticle(urd, INTTOSTR(NNTP_SEND_ARTICLE)
                                 " send article\r\n", 18))

         /* Transferred */
         Send(NNTPDSocket, INTTOSTR(NNTP_ARTICLE_TRANSFERRED)
                            " article transferred\r\n", 25, 0);

         /* NOT transferred */
        else if (UMSErrNum(Account) == UMSERR_ToBig)

         /* Article too big */
         Send(NNTPDSocket, INTTOSTR(NNTP_ARTICLE_REJECTED)
                            " article too big\r\n", 21, 0);

        else

         /* Temporary problem? */
         Send(NNTPDSocket, INTTOSTR(NNTP_TRANSFER_FAILED)
                            " transfer failed\r\n", 21, 0);

       else
        /* Message ID found. Old news :-) */
        Send(NNTPDSocket, INTTOSTR(NNTP_ARTICLE_NOT_WANTED)
                           " old news to me\r\n", 20, 0);

      } else
       Send(NNTPDSocket, INTTOSTR(NNTP_SYNTAX_ERROR) " no message id\r\n",
                          19, 0);

     } else
      /* Client is no server or posting not allowed, send error message */
      Send(NNTPDSocket, INTTOSTR(NNTP_PERMISSION_DENIED)
                         " you are not allowed to use IHAVE\r\n", 38, 0);

/***************************** List news/groups ******************************/
    /* LIST */
    } else if (stricmp(lp, "LIST") == 0) {
     /* Send out a list of all available news groups */

     notend = HandleLISTCommand(urd, tp);

    /* NEWNEWS */
    } else if (stricmp(lp, "NEWNEWS") == 0) {
     /* Send a list of all new news articles */

     notend = HandleNEWNEWSCommand(urd, tp);

    /* NEWGROUPS */
    } else if (stricmp(lp, "NEWGROUPS") == 0) {
     /* Send a list of all new newsgroups */

     notend = HandleNEWGROUPSCommand(urd, tp);

/************************** non-RFC977 commands *****************************/
    /* XHDR */
    } else if (stricmp(lp, "XHDR") == 0) {
     /* Send a list with the header line of each article */

     notend = HandleXHDRCommand(urd, tp);

    /* XOVER */
    } else if (stricmp(lp, "XOVER") == 0) {
     /* Send a list with the overview information for each article */

     notend = HandleXOVERCommand(urd, tp);

/***************************** Misc. commands *******************************/
    /* QUIT? */
    } else if (stricmp(lp, "QUIT") == 0) {
     /* Normal end of processing */
     rc = RETURN_OK;

     /* Leave loop */
     notend = FALSE;

    /* HELP */
    } else if (stricmp(lp, "HELP") == 0) {
     /* Send help text */
     ULONG len;

     len = sprintf(LineBuffer, HelpText, urd->urd_DomainName);
     Send(NNTPDSocket, LineBuffer, len, 0);

    /* SLAVE */
    } else if (stricmp(lp, "SLAVE") == 0) {
     /* Send acknowledgement */
     Send(NNTPDSocket, INTTOSTR(NNTP_SLAVE_STATUS_NOTED)
                        " slave status noted\r\n", 24, 0);

/***************************** Unknown command *******************************/
    } else
     Send(NNTPDSocket, INTTOSTR(NNTP_ERROR) " unkown command\r\n", 20, 0);

    DEBUGLOG(kprintf("(%08lx) UMS Error: %ld - %s\n", FindTask(NULL),
                      UMSErrNum(Account), UMSErrTxt(Account));)
   }
  }
 }

 return(rc);
}
