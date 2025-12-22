/*
 * authorization.c V1.0.00
 *
 * UMS POP3 (server) handle authorization state
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umspop3d.h"

/* Constant strings */

/* Local data */
static char UserName[BUFLEN];

/* Local data structures */
enum AuthState {AUTH_START, /* Start state, expecting "USER" */
                AUTH_USER}; /* Got "USER", expecting "PASS"  */

/* Global data */
char LineBuffer[BUFLEN];
char TempBuffer[BUFLEN];

/* POP3 AUTHORIZATION state */
LONG AuthorizationState(struct UMSRFCData *urd, char *server)
{
 UMSAccount Account   = urd->urd_Account;
 enum AuthState state = AUTH_START;
 LONG rc              = RETURN_FAIL;
 BOOL notend          = TRUE;
 char *lp             = LineBuffer;
 ULONG len;

 /* Create & send greeting */
 len = sprintf(TempBuffer, "+OK %s UMS POP3 server V"
                INTTOSTR(UMSRFC_LIBRARY_VERSION) "." INTTOSTR(UMSRFC_REVISION)
                " ready\r\n", urd->urd_DomainName);
 Send(POP3DSocket, TempBuffer, len, 0);

 /* Command loop */
 while (notend) {

  /* Read command line from client */
  if (notend = ReadLine(SocketBase, POP3DSocket, lp, BUFLEN)) {

   /* Command line not empty? */
   if (*lp) {
    char *tp = lp;
    char c;

    DEBUGLOG(kprintf("(%08lx) CMD: '%s'\n", FindTask(NULL), lp);)

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

    /* USER */
    if ((state == AUTH_START) && (stricmp(lp, "USER") == 0)) {
     char *cp;

     /* Check user name */
     if (cp = UMSReadConfigTags(Account, UMSTAG_CfgUserName, tp,
                                         TAG_DONE)) {
      /* User is known, free UMS variable */
      UMSFreeConfig(Account, cp);

      /* copy user name */
      strcpy(UserName, tp);

      /* Send positive answer */
      Send(POP3DSocket, "+OK welcome\r\n", 13, 0);

      /* Move to next state */
      state = AUTH_USER;

     } else
      /* Send negative answer */
      Send(POP3DSocket, "-ERR user unknown\r\n", 19, 0);

    /* PASS */
    } else if ((state == AUTH_USER) && (stricmp(lp, "PASS") == 0)) {
     struct UMSRFCData *newurd;

     /* Try to login */
     if (newurd = UMSRFCAllocData(&urb, UserName, tp, server)) {

      /* Lock mail drop */
      if (LockMailDrop(newurd)) {

       /* Send positive answer */
       Send(POP3DSocket, "+OK mail drop ready\r\n", 21, 0);

       /* Go to TRANSACTION state */
       rc = TransactionState(newurd);

       /* Leave loop */
       notend = FALSE;

       /* Release mail drop */
       ReleaseMailDrop(newurd, rc);

      } else {
       /* Send negative answer */
       Send(POP3DSocket, "-ERR couldn't lock mail drop\r\n", 30, 0);

       /* Reset to start state */
       state = AUTH_START;
      }

      /* Log out */
      UMSRFCFreeData(newurd);

     } else {
      /* Send negative answer */
      Send(POP3DSocket, "-ERR wrong password\r\n", 21, 0);

      /* Reset to start state */
      state = AUTH_START;
     }

    } else if (stricmp(lp, "QUIT") == 0) {
     /* End of processing */
     rc = RETURN_OK;

     /* Leave loop */
     notend = FALSE;

    /* Unknown command */
    } else Send(POP3DSocket, "-ERR unknown command\r\n", 22, 0);

    DEBUGLOG(kprintf("(%08lx) UMS Error: %ld - %s\n", FindTask(NULL),
                      UMSErrNum(Account), UMSErrTxt(Account));)
   }
  }
 }

 return(rc);
}
