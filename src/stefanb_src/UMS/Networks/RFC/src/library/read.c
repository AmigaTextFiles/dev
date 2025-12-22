/*
 * read.c V1.0.02
 *
 * umsrfc.library/UMSRFCReadMessage()
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsrfc.h"

/* Constant strings */
static const char CorruptedHdrMsg[] = "UMSRFC: Corrupted RFC header!\n";
       const char UMSRFCHeader[]    = UMSRFC_HEADER;  /* Header for comments */
       const char DateNotSet[]      = "Not specified";

/* Local flags */
#define READ_FIRSTLINE     0x01
#define READ_USEORIGINATOR 0x02
#define READ_CONTROL       0x04
#define READ_URGENT        0x08
#define READ_RECEIPT       0x10

/* Add one line to comment buffer */
static char *AddComment(char *cbuf, char *line)
{
 /* Copy line to buffer */
 strcpy(cbuf, line);

 /* Correct pointer */
 cbuf += strlen(cbuf);

 /* Add \n */
 *cbuf++ = '\n';

 /* Return new position in buffer */
 return(cbuf);
}

/*
 * Scan RFC 822 message
 *
 * Uses temporary buffers to store name and address:
 *
 *  purd->purd_FromAddr:   Address from From: line
 *  purd->purd_FromName:   Name from From: line
 *  purd->purd_ReplyAddr:  Address from Reply-To: line
 *  purd->purd_ReplyName:  Name from Reply-To: line
 *  purd->purd_Attributes: Attributes for UMS message
 *
 * Don't use this buffers until message has been saved!
 *
 */
__LIB_PREFIX BOOL UMSRFCReadMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) char *msg,
             __LIB_ARG(D0) BOOL mail,
             __LIB_ARG(D1) BOOL smtp
             /* __LIB_BASE */)
{
 struct PrivateURD *purd         = (struct PrivateURD *) urd;
 struct TagItem    *msgtags      = mail ? purd->purd_Public.urd_MailTags :
                                          purd->purd_Public.urd_NewsTags;
 char              *MIMEType     = NULL;
 char              *MIMEEncoding = NULL;
 char              *MIMELength   = NULL;
 char              *tp, *cp;
 ULONG              flags        = (mail ? READ_FIRSTLINE : 0) | READ_USEORIGINATOR;

 /* Init pointers & buffers */
 tp = msg;                                          /* Text buffer pointer */
 strcpy(purd->purd_CommentBuffer, UMSRFCHeader);    /* Init comment buffer */
 cp = purd->purd_CommentBuffer + UMSRFC_HEADER_LEN; /* Comment buf pointer */

 /* Init tag array */
 {
  struct TagItem *ti;

  for (ti = msgtags; ti->ti_Tag != TAG_DONE; ti++) ti->ti_Data = NULL;
 }

 /* Ignore CDate */
 msgtags[UMSRFC_TAGS_CDATE].ti_Tag = TAG_IGNORE;

 /* RFC 822 header processing loop */
 while (*tp) {
  char *kp = tp;  /* Pointer to begin of current line (RFC 822 keyword) */
  char *lp;       /* Pointer to data portion of current line */
  int klen;       /* Length of RFC 822 keyword */

  /* End of RFC 822 header reached? */
  if (*tp == '\n') break;

  /* Search ':' (end of RFC 822 keyword) */
  if (((flags & READ_FIRSTLINE) == 0) && !(lp = strchr(kp, ':'))) {
   UMSRFCLog((struct UMSRFCData *) purd, CorruptedHdrMsg);
   return(FALSE);
  }

  /* Skip ':' */
  if (flags & READ_FIRSTLINE)
   lp = kp;
  else {
   klen = lp - kp;
   lp++;
  }

  /* Skip additional white space */
  while ((*lp == ' ') || (*lp == '\t')) lp++;

  /* Search end of current line */
  if (!(tp = strchr(lp,'\n'))) {
   UMSRFCLog((struct UMSRFCData *) purd, CorruptedHdrMsg);
   return(FALSE);
  }

  /* Concatenate splitted lines */
  {
   char *dp = tp; /* Destination pointer */

   /* Splitted lines begin with space or tab */
   while ((*(tp + 1) == ' ') || (*(tp + 1) == '\t')) {
    char c;

    /* Remove \n or \0 */
    *dp++ = ' ';

    /* Skip tabs & spaces */
    tp += 2;
    while ((c = *tp) && ((c == ' ') || (c == '\t'))) tp++;

    /* End of buffer reached? */
    if (c) {

     /* No, copy rest of line */
     while (*tp != '\n') *dp++ = *tp++;

     /* Set string terminator */
     *dp = '\0';

    } else {
     UMSRFCLog((struct UMSRFCData *) purd, CorruptedHdrMsg);
     return(FALSE);
    }
   }
  }

  /* Set string terminator */
  *tp++ = '\0';

  /* Handle first line of a mail as special case */
  if (flags & READ_FIRSTLINE) {
   /* Got first line */
   flags &= ~READ_FIRSTLINE;

   /* Does the system have its own domain name? */
   if ((purd->purd_Public.urd_Flags & UMSRFC_FLAGS_NOOWNFQDN) == 0) {

    /* Yes, create time string  */
    UMSRFCPrintCurrentTime((struct UMSRFCData *) purd, purd->purd_Buffer1);

    /* Add "Received:" line to comment buffer */
    cp += psprintf(cp, "Received: by %s (UMSRFC "
                        INTTOSTR(UMSRFC_LIBRARY_VERSION)  "."
                        INTTOSTR(UMSRFC_REVISION)         "/"
                        INTTOSTR(UMSRFC_LIBRARY_REVISION) "); %s\n",
                        purd->purd_Public.urd_DomainName, purd->purd_Buffer1);
   }

   /* UUCP envelope ("From ...")? Yes, skip further processing */
   if (strnicmp(kp, "From ", 5) == 0) continue;

   /* No UUCP envelope. Search ':' (end of RFC 822 keyword) */
   if (!(lp = strchr(kp, ':'))) {
    UMSRFCLog((struct UMSRFCData *) purd, CorruptedHdrMsg);
    return(FALSE);
   }

   /* Skip ':' */
   klen = lp - kp;
   lp++;

   /* Skip additional white space */
   while ((*lp == ' ') || (*lp == '\t')) lp++;
  }

  /* Interpret RFC 822 keyword. Mail & News RFC 822 fields */
  if (((klen ==  4) && (strnicmp(kp, "From",        4) == 0)) ||
      ((flags & READ_USEORIGINATOR) &&
       (klen == 10) && (strnicmp(kp, "Originator", 10) == 0))) {
   /* From:, put original From: line into comment buffer */
   /* Originator: doesn't appear in the RFC822/1036 specs */
   /* (It will only be used if there is no From: line) */
   cp = AddComment(cp, kp);
   DecodeHeaderLine(lp);

   /* Get user name and address from From: line */
   UMSRFCConvertRFCAddress(urd, lp, purd->purd_FromAddr, purd->purd_FromName);
   msgtags[UMSRFC_TAGS_FROMNAME].ti_Data = (ULONG) purd->purd_FromName;
   msgtags[UMSRFC_TAGS_FROMADDR].ti_Data = (ULONG) purd->purd_FromAddr;

   /* Got From: or Originator: line, don't use further Originator: lines */
   flags &= ~READ_USEORIGINATOR;

  } else if ((klen == 4) && (strnicmp(kp, "Date", 4) == 0)) {
   /* Date: */
   ULONG cdate;

   /* Set CreationDate field */
   msgtags[UMSRFC_TAGS_DATE].ti_Data = (ULONG) lp;

   /* Copy date/time string and convert it to Amiga date */
   strcpy(cp, lp);
   if (cdate = UMSRFCGetTime((struct UMSRFCData *) purd, cp)) {
    msgtags[UMSRFC_TAGS_CDATE].ti_Tag  = UMSTAG_WMsgCDate;
    msgtags[UMSRFC_TAGS_CDATE].ti_Data = cdate;
   }

  } else if ((klen == 7) && (strnicmp(kp, "Subject", 7) == 0)) {
   /* Subject: */
   DecodeHeaderLine(lp);
   msgtags[UMSRFC_TAGS_SUBJECT].ti_Data = (ULONG) lp;

  } else if ((klen == 8) && (strnicmp(kp, "Priority", 8) == 0)) {
   /* Priority:, put original line into comment buffer */
   cp = AddComment(cp, kp);

   /* Set urgent flag */
   flags |= READ_URGENT;

  } else if ((klen == 8) && (strnicmp(kp, "Reply-To", 8) == 0)) {
   /* Reply-To:, put original Reply-To: line into comment buffer */
   cp = AddComment(cp, kp);
   DecodeHeaderLine(lp);

   /* Get user name and address from Reply-To: line */
   UMSRFCConvertRFCAddress(urd, lp, purd->purd_ReplyAddr,
                                    purd->purd_ReplyName);
   msgtags[UMSRFC_TAGS_REPLYNAME].ti_Data = (ULONG) purd->purd_ReplyName;
   msgtags[UMSRFC_TAGS_REPLYADDR].ti_Data = (ULONG) purd->purd_ReplyAddr;

  } else if ((klen == 10) && (strnicmp(kp, "Message-ID", 10) == 0)) {
   /* Message-ID: */
   char *refp, *closep;

   /* search opening AND closing braket */
   if ((refp = strchr(lp, '<')) && (closep = strchr(++refp, '>'))) {
    /* set string terminator */
    *closep = '\0';

    /* complete message ID found */
    msgtags[UMSRFC_TAGS_MSGID].ti_Data = (ULONG) refp;
   } else
    /* No message ID found -> line into comment buffer */
    cp = AddComment(cp, kp);

  } else if ((klen == 10) && (strnicmp(kp, "References", 10) == 0)) {
   /* References: */
   char *refp, *closep;

   /* add complete References: line to comment buffer */
   cp = AddComment(cp, kp);

   /* search opening AND closing braket (from end of line) */
   if ((refp = strrchr(lp, '<')) && (closep = strchr(++refp, '>'))) {
    /* set string terminator */
    *closep = '\0';

    /* complete ref-id found */
    msgtags[UMSRFC_TAGS_REFERID].ti_Data = (ULONG) refp;
   }

  } else if ((klen == 12) && (strnicmp(kp, "Organization", 12) == 0)) {
   /* Organization: */
   DecodeHeaderLine(lp);
   msgtags[UMSRFC_TAGS_ORG].ti_Data = (ULONG) lp;

  } else if ((klen == 12) && (strnicmp(kp, "Content-Type", 12) == 0)) {
   /* Content-Type: */
   MIMEType = lp;

  } else if ((klen == 14) && (strnicmp(kp, "Content-Length", 14) == 0)) {
   /* Content-Length: */
   MIMELength = lp;

  } else if ((klen == 25) &&
             (strnicmp(kp, "Content-Transfer-Encoding", 25) == 0)) {
   /* Content-Transfer-Encoding: */
   MIMEEncoding = lp;

   /* Mail only RFC 822 fields */
  } else if (mail) {

   if ((klen == 8) && (strnicmp(kp, "X-Mailer", 8) == 0)) {
    /* X-Mailer: (Mail only) */
    msgtags[UMSRFC_TAGS_MSGREADER].ti_Data = (ULONG) lp;

   } else if ((klen == 11) && (strnicmp(kp, "In-Reply-To", 11) == 0)) {
    /* In-Reply-To: (Mail only) */
    char *refp, *closep;

    /* Add line to comment buffer */
    cp = AddComment(cp, kp);

    /* search opening AND closing braket  */
    if ((refp = strchr(lp, '<')) && (closep = strchr(++refp, '>'))) {
     /* set string terminator */
     *closep = '\0';

     /* complete message ID found */
     msgtags[UMSRFC_TAGS_REFERID].ti_Data = (ULONG) refp;
    }

   } else if ((klen == 17) && (strnicmp(kp, "Return-Receipt-To", 17) == 0)) {
    /* Return-Receipt-To: (Mail only) */
    /* Add complete line to comment buffer */
    cp = AddComment(cp, kp);

    /* Get address & name from Return-Receipt-To: line (stored in Buffer1 & 2) */
    UMSRFCConvertRFCAddress(urd, lp, purd->purd_Buffer1, purd->purd_Buffer2);

    /* Set receipt flag */
    flags |= READ_RECEIPT;

   } else
    /* All other RFC 822 keywords are treated as comments... */
    cp = AddComment(cp, kp);

   /* News only RFC 822 fields */
  } else if ((klen == 4) && (strnicmp(kp, "Path", 4) == 0)) {
   /* Path: (News only) */
   /* Put path line into comment buffer. Does the system have its own FQDN? */
   if (purd->purd_Public.urd_Flags & UMSRFC_FLAGS_NOOWNFQDN)

    /* No, don't add name to the path */
    cp = AddComment(cp, kp);

   else
    /* Yes, add name to the path */
    cp += psprintf(cp, "Path: %s!%s\n", purd->purd_Public.urd_PathName, lp);

  } else if ((klen == 7) && (strnicmp(kp, "Control", 7) == 0)) {
   /* Control: (News only) */
   /* Add complete Control: line to comment buffer */
   cp = AddComment(cp, kp);

   /* This is a control message, only exporters should see it */
   msgtags[UMSRFC_TAGS_HIDE].ti_Data = 1;

   /* Set control flag */
   flags |= READ_CONTROL;

   /* Cancel message? */
   if (strnicmp(lp, "cancel", 6) == 0) {
    /* Yes, try to delete original message */
    char *refp, *closep;

    /* Search Msg-Id */
    if ((refp = strchr(lp + 6, '<')) && (closep = strchr(++refp, '>'))) {
     struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
     UMSAccount      account = purd->purd_Public.urd_Account;
     UMSMsgNum       orignum;

     /* Set string terminator */
     *closep = '\0';

     /* Search original message */
     if (orignum = TAGCALL(UMSSearchTags)(UMSBASE account,
                                           UMSTAG_WMsgID,      refp,
                                           UMSTAG_SearchQuick, TRUE,
                                           TAG_DONE))
      /* Delete it */
      UMSDeleteMsg(account, orignum);
    }
   }

  } else if ((klen == 10) && (strnicmp(kp, "Newsgroups", 10) == 0)) {
   /* Newsgroups: (News only) */
   /* Add complete Newsgroups: line to comment buffer */
   cp = AddComment(cp, kp);
   msgtags[UMSRFC_TAGS_GROUP].ti_Data = (ULONG) lp;

  } else if ((klen == 11) && (strnicmp(kp, "Followup-To", 11) == 0)) {
   /* Followup-To: (News only) */
   msgtags[UMSRFC_TAGS_REPLYGROUP].ti_Data = (ULONG) lp;

  } else if ((klen == 12) && (strnicmp(kp, "Distribution", 12) == 0)) {
   /* Distribution: (News only) */
   msgtags[UMSRFC_TAGS_DIST].ti_Data = (ULONG) lp;

  } else if ((klen == 12) && (strnicmp(kp, "X-NewsReader", 12) == 0)) {
   /* X-NewsReader: (News only) */
   msgtags[UMSRFC_TAGS_MSGREADER].ti_Data = (ULONG) lp;

  } else
   /* All other RFC 822 keywords are treated as comments... */
   cp = AddComment(cp, kp);
 }

 /* Set pointer to message text */
 msgtags[UMSRFC_TAGS_MSGTEXT].ti_Data = (ULONG) ((*tp) ? ++tp : tp);

 /* Handle SMTP messages */
 if (smtp) {
  char *endl = tp + strlen(tp);

  /* Handle lines with a "." at the beginning */
  {
   char *lp = tp;

   while (lp = strstr(lp, "\n.")) {
    /* Skip '\n' */
    lp++;

    /* Copy rest of message, removes first '.' on a line */
    memmove(lp, lp + 1, endl - lp);
    endl--;
   }
  }
 }

 {
  char *ap = purd->purd_Attributes;

  /* MIME Message? */
  if (MIMEType || MIMEEncoding || MIMELength)

   /* Yes, try to decode it */
   if (DecodeMessage(MIMEType, MIMEEncoding, tp)) {

    /* Message decoded. Set MIME attribute */
    strcpy(ap, "MIME ");
    ap += 5;

   } else {
    /* Couldn't decode MIME message, copy headers to comment buffer */
    if (MIMEType)
     cp += psprintf(cp, "Content-Type: %s\n", MIMEType);

    if (MIMEEncoding)
     cp += psprintf(cp, "Content-Transfer-Encoding: %s\n", MIMEEncoding);

    if (MIMELength)
     cp += psprintf(cp, "Content-Length: %s\n", MIMELength);
   }

  /* Receipt request? */
  if (flags & READ_RECEIPT)
   ap += psprintf(ap, "RECEIPT-REQUEST \"%s,%s\" ", purd->purd_Buffer2,
                                                    purd->purd_Buffer1);

  /* Urgent message? */
  if (flags & READ_URGENT) {
   strcpy(ap, "URGENT ");
   ap += 7;
  }

  /* Attributes set? */
  if (purd->purd_Attributes != ap) {
   /* Yes, append string terminator to attributes buffer and set tag */
   *--ap = '\0';
   msgtags[UMSRFC_TAGS_ATTRIBUTES].ti_Data = (ULONG) purd->purd_Attributes;
  }
 }

 /* Append string terminator to comment buffer and set tag */
 *cp = '\0';
 msgtags[UMSRFC_TAGS_COMMENTS].ti_Data = (ULONG) purd->purd_CommentBuffer;

 /* No or empty sender name? */
 if (!(cp = (char *) msgtags[UMSRFC_TAGS_FROMNAME].ti_Data) || (*cp == '\0')) {
  /* Yes --> set dummy name and address */
  msgtags[UMSRFC_TAGS_FROMNAME].ti_Data = (ULONG) "Unknown";
  msgtags[UMSRFC_TAGS_FROMADDR].ti_Data = (ULONG) "unknown@nowhere";
 }

 /* No or empty "Subject:" line? */
 if (!(cp = (char *) msgtags[UMSRFC_TAGS_SUBJECT].ti_Data) || (*cp == '\0'))
  /* Yes --> set dummy subject */
  msgtags[UMSRFC_TAGS_SUBJECT].ti_Data = (ULONG) "No subject";

 /* No or empty "Date:" line? */
 if (!(cp = (char *) msgtags[UMSRFC_TAGS_DATE].ti_Data) || (*cp == '\0'))
  msgtags[UMSRFC_TAGS_DATE].ti_Data = (ULONG) "Not specified";

 /* Control message? Yes -> write message to special group "rfc.control" */
 if (flags & READ_CONTROL) msgtags[UMSRFC_TAGS_GROUP].ti_Data = (ULONG) "rfc.control";

#ifdef DEBUG
 {
  struct TagItem *ti;
  int             i;

  /* Print all used tags */
  for (i = 0, ti = msgtags; ti->ti_Tag != TAG_DONE; i++, ti++)
   if (ti->ti_Data)
    switch (i) {
     case UMSRFC_TAGS_CDATE: break;
     case UMSRFC_TAGS_HIDE:  break;
     default:                kprintf("'%s'\n",ti->ti_Data);
                             break;
    }
 }
#endif

 return(TRUE);
}
