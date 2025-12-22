/*
 * recipient.c V1.0.00
 *
 * UMS SMTP (server) recipient handling functions
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtpd.h"

/* Global data */
struct List RecipientList;
char ToAddr[BUFLEN];
char ToName[BUFLEN];

/* Free recipient list */
void FreeRecipients(void)
{
 struct RecipientNode *rn;

 /* Remove entry from tail and free entry */
 while (rn = (struct RecipientNode *) RemTail(&RecipientList))
  FreeMem(rn, rn->rn_Size);
}

/* Add one recipient */
static BOOL AddRecipient(struct List *rl, const char *s, ULONG len)
{
 struct RecipientNode *rn;
 ULONG newlen             = len + sizeof(struct RecipientNode);

 /* Allocate memory for entry */
 if (rn = AllocMem(newlen, MEMF_PUBLIC)) {

  /* Initialize entry */
  rn->rn_Size = newlen;
  strcpy(rn->rn_Recipient, s);

  /* Append entry to list */
  AddTail((struct List *) rl, (struct Node *) rn);

 } else
  /* No memory */
  return(FALSE);
}

/* Handle RCPT command */
BOOL HandleRCPTCommand(struct UMSRFCData *urd, char *args)
{
 char *bp, *ep;
 BOOL rc       = FALSE;

 /* State OK, check syntax and retrieve recipient */
 if ((strnicmp(args, "TO:", 3) == 0) && (bp = strchr(args + 3, '<')) &&
     (ep = strchr(++bp, '>'))) {

  /* Syntax OK, add string terminator */
  *ep = '\0';

  /* Convert RFC address. Mail for local or remote user? */
  if (strpbrk(bp, "!@%:"))

   /* Remote user. Parse recipient address */
   UMSRFCConvertRFCAddress(urd, bp, ToAddr, ToName);

  else {
   /* Local user. Set name and empty address */
   strcpy(ToName, bp);
   *ToAddr = '\0';
  }

  DEBUGLOG(kprintf("RCPT: '%s' Name: '%s' Addr: '%s'\n", bp, ToName, ToAddr);)

  /* Check recipient */
  if (UMSWriteMsgTags(urd->urd_Account, UMSTAG_WFromName,    FromName,
                                        UMSTAG_WFromAddr,    FromAddr,
                                        UMSTAG_WToName,      ToName,
                                        UMSTAG_WToAddr,      ToAddr,
                                        UMSTAG_WSubject,     "dummy",
                                        UMSTAG_WAutoBounce,  FALSE,
                                        UMSTAG_WCheckHeader, TRUE,
                                        TAG_DONE))

   /* Add recipient */
   if (AddRecipient(&RecipientList, bp, ep - bp))

    /* Recipient OK */
    rc = TRUE;

   else
    /* No memory */
    QueueResponse(INTTOSTR(SMTP_OUT_OF_MEMORY) " out of memory\r\n", 19);

  else
   /* Recipient unknown */
   QueueResponse(INTTOSTR(SMTP_ACTION_NOT_TAKEN) " recipient unknown\r\n", 23);

 } else
  /* Syntax error */
  QueueResponse(SyntaxError, 18);

 return(rc);
}
