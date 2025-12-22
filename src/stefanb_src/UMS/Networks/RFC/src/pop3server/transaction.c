/*
 * transaction.c V1.0.00
 *
 * UMS POP3 (server) handle transaction state
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umspop3d.h"

/* Constant strings */
static const char AllOK[]     = "+OK\r\n";
static const char ErrNoID[]   = "-ERR no id specified\r\n";
static const char ErrNoMsg[]  = "-ERR no such message\r\n";
static const char ErrMsgDel[] = "-ERR message already deleted\r\n";

/* Local data structures */
#define SELBIT1 0x0001
#define SELBIT2 0x0002
#define SELBITS (SELBIT1 | SELBIT2)

struct MessageData {
 UMSMsgNum md_MsgNum; /* Message number */
 ULONG     md_Size;   /* Message size   */
 ULONG     md_Flags;  /* Flags          */
};

#define MSGDATAF_DELETED 0x01

struct MailDropData {
 ULONG               mdd_AllMsgs;   /* All messages in mail drop  */
 ULONG               mdd_AllSize;   /* Size of all messages       */
 ULONG               mdd_AvailMsgs; /* Still available messages   */
 ULONG               mdd_AvailSize; /* Size of available messages */
 ULONG               mdd_LastMsg;   /* Last accessed message      */
 struct MessageData *mdd_MsgsData;  /* Array of message data      */
};

/* Local data */
static struct MailDropData mdd;

/* Global data */

/* Lock Mail Drop */
BOOL LockMailDrop(struct UMSRFCData *urd)
{
 UMSAccount Account = urd->urd_Account;

 /* Select all new messages */
 UMSSelectTags(Account, /* Read user flags. Select all messages with read */
                        /* & view access (and an additional select bit)   */
                        /* which have not been read.                      */
                        UMSTAG_SelMask,  UMSUSTATF_ReadAccess |
                                         UMSUSTATF_ViewAccess |
                                         UMSUSTATF_Old,
                        UMSTAG_SelMatch, UMSUSTATF_ReadAccess |
                                         UMSUSTATF_ViewAccess,

                        /* Set local select bit 1 on each message */
                        UMSTAG_SelWriteLocal, TRUE,
                        UMSTAG_SelSet,        SELBIT1,

                        TAG_DONE);

 /* Select all mail messages */
 UMSSelectTags(Account, /* Select all mail messages (Group = NULL) */
                        UMSTAG_WGroup,   NULL,
                        UMSTAG_SelQuick, TRUE,

                        /* Set local select bit 2 on each message */
                        UMSTAG_SelWriteLocal, TRUE,
                        UMSTAG_SelSet,        SELBIT2,

                        TAG_DONE);

 /* Count new msgs */
 mdd.mdd_AllMsgs = UMSSelectTags(Account, /* Select all messags with */
                                          /* both bits set           */
                                          UMSTAG_SelReadLocal, TRUE,
                                          UMSTAG_SelMask,      SELBITS,
                                          UMSTAG_SelMatch,     SELBITS,

                                          TAG_DONE);

 DEBUGLOG(kprintf("Messages: %ld\n", mdd.mdd_AllMsgs);)

 /* Reset data */
 mdd.mdd_AllSize  = 0;
 mdd.mdd_MsgsData = NULL;

 /* Allocate memory for messages data */
 if ((mdd.mdd_AllMsgs == 0) ||
     (mdd.mdd_MsgsData = AllocMem(mdd.mdd_AllMsgs * sizeof(struct MessageData),
                                  MEMF_PUBLIC))) {
  struct MessageData *md = mdd.mdd_MsgsData;
  UMSMsgNum newmsg       = 0;
  ULONG header, body;

  DEBUGLOG(kprintf("MsgsData: 0x%08lx\n", mdd.mdd_MsgsData);)

  while (newmsg = UMSSearchTags(Account, /* Start with this message */
                                         UMSTAG_SearchLast, newmsg,

                                         /* Search from low to high numbers */
                                         UMSTAG_SearchDirection, 1,

                                         /* Search for messages which have */
                                         /* both local select bits set     */
                                         UMSTAG_SearchLocal, TRUE,
                                         UMSTAG_SearchMask,  SELBITS,
                                         UMSTAG_SearchMatch, SELBITS,

                                         TAG_DONE)) {
   /* Initialize entry */
   md->md_MsgNum = newmsg;
   md->md_Size   = 0;
   md->md_Flags  = 0;

   /* Read message size information */
   if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,       newmsg,
                               UMSTAG_RHeaderLength, &header,
                               UMSTAG_RTextLength,   &body,
                               TAG_DONE)) {
    /* Calculate size */
    md->md_Size = header + body;

    /* Free message */
    UMSFreeMsg(Account, newmsg);
   }

   DEBUGLOG(kprintf("Msg: %ld (%ld Bytes)\n", newmsg, md->md_Size);)

   /* Add size */
   mdd.mdd_AllSize += md->md_Size;

   /* Next entry */
   md++;
  }

  DEBUGLOG(kprintf("AllSize: %ld\n", mdd.mdd_AllSize);)

  /* Initialize rest of data */
  mdd.mdd_AvailMsgs = mdd.mdd_AllMsgs;
  mdd.mdd_AvailSize = mdd.mdd_AllSize;
  mdd.mdd_LastMsg   = 1;

  return(TRUE);
 }

 return(FALSE);
}

/* Release Mail Drop */
void ReleaseMailDrop(struct UMSRFCData *urd, LONG result)
{
 /* UPDATE state? */
 if (result == RETURN_OK) {
  UMSAccount Account     = urd->urd_Account;
  struct MessageData *md = mdd.mdd_MsgsData;
  int i;

  DEBUGLOG(kprintf("UPDATE state\n");)

  /* Scan all messages */
  for (i = mdd.mdd_AllMsgs; i; i--, md++)

   /* Delete flag set? */
   if (md->md_Flags & MSGDATAF_DELETED) {

    DEBUGLOG(kprintf("Set Old flag on %ld\n", md->md_MsgNum);)

    /* Yes, set old Flag on message */
    UMSSelectTags(Account, UMSTAG_SelMsg, md->md_MsgNum,
                           UMSTAG_SelSet, UMSUSTATF_Old,
                           TAG_DONE);
   }
 }

 /* Memory allocated? */
 if (mdd.mdd_MsgsData) FreeMem(mdd.mdd_MsgsData,
                               mdd.mdd_AllMsgs * sizeof(struct MessageData));
}

/* Handle LIST command */
static void HandleLISTCommand(char *arg)
{
 /* Parameter specified? */
 if (*arg) {
  /* Yes, send information for one message */
  ULONG msg = strtol(arg, NULL, 10);

  /* Sanity check */
  if ((msg > 0) && (msg <= mdd.mdd_AllMsgs)) {
   struct MessageData *md = &mdd.mdd_MsgsData[msg - 1];

   /* Message deleted? */
   if (md->md_Flags & MSGDATAF_DELETED)

    Send(POP3DSocket, ErrMsgDel, sizeof(ErrMsgDel) - 1, 0);

   else {
    ULONG len = sprintf(TempBuffer, "+OK %d %d\r\n", msg, md->md_Size);

    Send(POP3DSocket, TempBuffer, len, 0);
   }

  } else
   Send(POP3DSocket, ErrNoMsg, sizeof(ErrNoMsg) - 1, 0);

 /* No parameter specified */
 } else {
  struct MessageData *md = mdd.mdd_MsgsData;
  int i;

  /* Send answer */
  Send(POP3DSocket, AllOK, sizeof(AllOK) - 1 , 0);

  /* Scan messages */
  for (i = 1; i <= mdd.mdd_AllMsgs; i++, md++) {

   /* Message deleted? */
   if ((md->md_Flags & MSGDATAF_DELETED) == 0) {
    ULONG len;

    len = sprintf(TempBuffer, "%d %d\r\n", i, md->md_Size);
    Send(POP3DSocket, TempBuffer, len, 0);
   }
  }

  /* Terminate list */
  Send(POP3DSocket, ".\r\n", 3, 0);
 }
}

/* Handle RETR command */
static void HandleRETRCommand(struct UMSRFCData *urd, char *arg)
{
 /* Argument specified */
 if (*arg) {
  ULONG msg = strtol(arg, NULL, 10);

  /* Sanity check */
  if ((msg > 0) && (msg <= mdd.mdd_AllMsgs)) {
   struct MessageData *md = &mdd.mdd_MsgsData[msg - 1];

   /* Message deleted? */
   if (md->md_Flags & MSGDATAF_DELETED)

    Send(POP3DSocket, ErrMsgDel, sizeof(ErrMsgDel) - 1, 0);

   /* Get message */
   else if (UMSRFCGetMessage(urd, md->md_MsgNum)) {
    /* Send answer */
    Send(POP3DSocket, AllOK, sizeof(AllOK) -1 , 0);

    /* Send message */
    SendMessage(urd);

    /* Terminate message */
    Send(POP3DSocket, "\r\n.\r\n", 5, 0);

    /* Free message */
    UMSRFCFreeMessage(urd);

    /* Correct last msg pointer */
    if (msg > mdd.mdd_LastMsg) mdd.mdd_LastMsg = msg;

   /* Error */
   } else
    Send(POP3DSocket, "-ERR couldn't read message\r\n", 28, 0);

  } else
   Send(POP3DSocket, ErrNoMsg, sizeof(ErrNoMsg) - 1, 0);

 /* Error */
 } else
  Send(POP3DSocket, ErrNoID, sizeof(ErrNoID) - 1, 0);
}


/* Handle DELE command */
static void HandleDELECommand(char *arg)
{
 /* Argument specified */
 if (*arg) {
  ULONG msg = strtol(arg, NULL, 10);

  /* Sanity check */
  if ((msg > 0) && (msg <= mdd.mdd_AllMsgs)) {
   struct MessageData *md = &mdd.mdd_MsgsData[msg - 1];

   /* Message deleted? */
   if (md->md_Flags & MSGDATAF_DELETED)

    Send(POP3DSocket, ErrMsgDel, sizeof(ErrMsgDel) - 1, 0);

   else {
    /* Set deleted flag */
    md->md_Flags |= MSGDATAF_DELETED;

    /* Correct data */
    mdd.mdd_AvailMsgs--;
    mdd.mdd_AvailSize -= md->md_Size;

    /* Correct last msg pointer */
    if (msg > mdd.mdd_LastMsg) mdd.mdd_LastMsg = msg;

    /* Send answer */
    Send(POP3DSocket, AllOK, sizeof(AllOK) -1 , 0);
   }

  } else
   Send(POP3DSocket, ErrNoMsg, sizeof(ErrNoMsg) - 1, 0);

 /* Error */
 } else
  Send(POP3DSocket, ErrNoID, sizeof(ErrNoID) - 1, 0);
}

/* Handle RSET command */
static void HandleRSETCommand(void)
{
 struct MessageData *md = mdd.mdd_MsgsData;
 int i;

 /* Scan messages */
 for (i = mdd.mdd_AllMsgs; i; i--, md++)

  /* Reset flags */
  md->md_Flags = 0;

 /* Reset rest of data */
 mdd.mdd_AvailMsgs = mdd.mdd_AllMsgs;
 mdd.mdd_AvailSize = mdd.mdd_AllSize;
 mdd.mdd_LastMsg   = 1;

 /* Send answer */
 Send(POP3DSocket, AllOK, sizeof(AllOK) -1 , 0);
}

/* POP3 TRANSACTION state */
LONG TransactionState(struct UMSRFCData *urd)
{
 UMSAccount Account = urd->urd_Account;
 LONG rc            = RETURN_FAIL;
 BOOL notend        = TRUE;
 char *lp           = LineBuffer;

 /* Initialize message sending */
 InitSendMessage();

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

    /* STAT */
    if (stricmp(lp, "STAT") == 0) {
     ULONG len;

     /* Create & send response */
     len = sprintf(TempBuffer, "+OK %d %d\r\n", mdd.mdd_AvailMsgs,
                                                mdd.mdd_AvailSize);
     Send(POP3DSocket, TempBuffer, len, 0);

    /* LIST */
    } else if (stricmp(lp, "LIST") == 0) {

     HandleLISTCommand(tp);

    /* RETR */
    } else if (stricmp(lp, "RETR") == 0) {

     HandleRETRCommand(urd, tp);

    /* DELE */
    } else if (stricmp(lp, "DELE") == 0) {

     HandleDELECommand(tp);

    /* LAST */
    } else if (stricmp(lp, "LAST") == 0) {
     ULONG len;

     len = sprintf(TempBuffer, "+OK %d\r\n", mdd.mdd_LastMsg);
     Send(POP3DSocket, TempBuffer, len, 0);

    /* RSET */
    } else if (stricmp(lp, "RSET") == 0) {

     HandleRSETCommand();

    /* NOOP */
    } else if (stricmp(lp, "NOOP") == 0) {

     /* Send positive answer */
     Send(POP3DSocket, AllOK, sizeof(AllOK) - 1, 0);

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
