/*
 * write.c V1.0.05
 *
 * umsrfc.library/UMSRFCWriteMessage()
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsrfc.h"

/* Local data structure */
struct LocalData {
 struct PrivateURD    *ld_PrivateURD;
 struct Library       *ld_UMSBase;
 UMSAccount            ld_Account;
 UMSMsgTextFields     *ld_MsgFields;
 UMSRFCOutputFunction  ld_OutputFunction;
 void                 *ld_OutputData;
};

/* Constant strings */
static const char IDFormat[]    = " <%s>";     /* Message ID format        */
static const char MIMEHeaders[] = "Content-Type: text/plain; charset=%s\r\n"
                                  "Content-Transfer-Encoding: %s\r\n";

/* Check charset. Return TRUE for iso-8859-1, FALSE for us-ascii */
static BOOL CheckCharset(char *text)
{
 /* Text valid? */
 if (text) {
  char c;

  /* Check for 8-Bit characters */
  while (c = *text++) if (c & 0x80) return(TRUE); /* 8-Bit character found! */
 }

 /* No 8-Bit characters found */
 return(FALSE);
}

/* Recurse into Refer ID tree */
static void RecurseReferID(struct LocalData *ld, UMSMsgNum msgnum, char *msgid)
{
 struct Library *UMSBase = ld->ld_UMSBase;
 UMSAccount account      = ld->ld_Account;
 char *newmsgid;
 char *referid;
 UMSMsgNum refernum;

 /* Valid chain-up and can we read the data of the parent message? */
 if ((msgnum != 0) && TAGCALL(UMSReadMsgTags)(UMSBASE account,
                                              UMSTAG_RMsgNum,   msgnum,
                                              UMSTAG_RMsgID,   &newmsgid,
                                              UMSTAG_RChainUp, &refernum,
                                              UMSTAG_RReferID, &referid,
                                              TAG_DONE)) {
  /* Yes, recurse on step further */
  RecurseReferID(ld, refernum, referid);

  /* Write Message id */
  pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, IDFormat, newmsgid);

  /* Free message */
  UMSFreeMsg(account, msgnum);

  /* No, Message ID valid? */
 } else if (msgid)
  pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, IDFormat, msgid);
}

/* Write reply msg ID */
static void WriteReplyMsgID(struct LocalData *ld,
                            char *header, UMSMsgNum msgnum, BOOL recurse)

{
 struct Library *UMSBase = ld->ld_UMSBase;
 UMSAccount account      = ld->ld_Account;
 char *msgid;
 char *referid;
 UMSMsgNum refernum;

 /* Valid chain-up and can we read the data of the parent message? */
 if ((msgnum != 0) && TAGCALL(UMSReadMsgTags)(UMSBASE account,
                                              UMSTAG_RMsgNum,   msgnum,
                                              UMSTAG_RMsgID,   &msgid,
                                              UMSTAG_RChainUp, &refernum,
                                              UMSTAG_RReferID, &referid,
                                              TAG_DONE)) {
  /* Yes, Refer ID header */
  pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, "%s:", header);

  /* Recurse into referid tree? */
  if (recurse) RecurseReferID(ld, refernum, referid);

  /* Write Refer ID and close header line */
  pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, " <%s>\r\n", msgid);

  /* Free message */
  UMSFreeMsg(account, msgnum);

  /* No, is reply ID of message valid? */
 } else if (msgid = (*ld->ld_MsgFields)[UMSCODE_ReferID])
  /* Yes, write reply msg ID into header line */
  pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, "%s: <%s>\r\n",
           header, msgid);
}

/* Write header field if string is not empty */
static void WriteRFCHeaderField(struct LocalData *ld, char *header, char *text)
{
 /* Text valid? */
 if (text)
  /* Yes. Write header field */
  pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, "%s: %s\r\n",
           header, text);
}

/* Write address with or without name */
static BOOL WriteRFCAddressField(struct LocalData *ld, char *header,
                                 char *addr, char *name)
{
 BOOL rc;

 /* Address or name valid? */
 if (rc = (addr || name)) {
  UBYTE *buf = ld->ld_PrivateURD->purd_Buffer2;

  /* Yes, convert address */
  UMSRFCConvertUMSAddress((struct UMSRFCData *) ld->ld_PrivateURD,
                          addr, name, buf);

  /* Print header line */
  if (name)
   pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, "%s: \"%s\" <%s>\r\n",
            header, name, buf);
  else
   pfprintf(ld->ld_OutputFunction, ld->ld_OutputData, "%s: %s\r\n",
            header, buf);
 }

 return(rc);
}

__LIB_PREFIX BOOL UMSRFCWriteMessage(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) UMSRFCOutputFunction func,
             __LIB_ARG(A2) void *outputdata,
             __LIB_ARG(D0) BOOL smtp
             /* __LIB_BASE */)
{
 struct PrivateURD *purd = (struct PrivateURD *) urd;
 struct Library *UMSBase = purd->purd_Bases.urb_UMSBase;
 UMSAccount account      = purd->purd_Public.urd_Account;
 UMSMsgNum msgnum        = purd->purd_Public.urd_MsgData.urmd_MsgNum;
 char *text              = purd->purd_Public.urd_MsgFields[UMSCODE_MsgText];
 char *charset           = NULL;
 char *encoding;
 ULONG encodingtype;
 struct LocalData ld;
 BOOL mail               = (purd->purd_Public.urd_MsgFields[UMSCODE_Group]
                            == NULL);
 BOOL NeedsEncoding      = CheckCharset(text);
 BOOL CreateAllHeaders;

 /* Initialize local data */
 ld.ld_PrivateURD     = purd;
 ld.ld_UMSBase        = UMSBase;
 ld.ld_Account        = account;
 ld.ld_MsgFields      = purd->purd_Public.urd_MsgFields;
 ld.ld_OutputFunction = func;
 ld.ld_OutputData     = outputdata;

 /* Get encoding type */
 encodingtype = mail ? purd->purd_MailEncodingType :
                       purd->purd_NewsEncodingType;

 /* Reset 8bit encoding flag for message */
 purd->purd_Public.urd_Flags &= ~UMSRFC_FLAGS_MSGIS8BIT;

 /* Set MIME Parameters. 8-Bit characters found? */
 if (NeedsEncoding) {
  /* Yes, set charset to iso-8859-1 */
  charset = "iso-8859-1";

  /* Check encoding type */
  switch (encodingtype) {
   case ENCODE_NONE:
    /* Is 8bit encoding allowed? */
    if (purd->purd_Public.urd_Flags & UMSRFC_FLAGS_8BITALLOWED) {

     /* Yes */
     encoding = "8bit";

     /* Do not encode! */
     NeedsEncoding = FALSE;

     /* Set 8bit encoding flag for message */
     purd->purd_Public.urd_Flags |= UMSRFC_FLAGS_MSGIS8BIT;

     /* Leave switch */
     break;
    }

    /* No, FLOW THROUGH to default encoding!!! */
    encodingtype = ENCODE_QUOTED_PRINTABLE;

   case ENCODE_QUOTED_PRINTABLE:
    encoding = "quoted-printable";
    break;

   case ENCODE_BASE64:
    encoding = "base64";
    break;
  }
 }

 /* Must we create all headers? */
 CreateAllHeaders = /* Message from local user (no from address) */
                    (purd->purd_Public.urd_MsgFields[UMSCODE_FromAddr]
                     == NULL) ||

                    /* No comments field (that means, no RFC header) */
                    (purd->purd_Public.urd_MsgFields[UMSCODE_Comments]
                     == NULL) ||

                    /* Message imported by UMS RFC? */
                    (strncmp(UMSRFCHeader,
                             purd->purd_Public.urd_MsgFields[UMSCODE_Comments],
                             UMSRFC_HEADER_LEN) != 0);

 /* I. Start RFC header --------------------------------------------------- */
 /* Create all headers? */
 if (CreateAllHeaders) {
  /* Yes. Mail? */
  if (mail) {
   /* Yes, create mail only fields */

   /* Does the system have its own domain name? */
   if ((purd->purd_Public.urd_Flags & UMSRFC_FLAGS_NOOWNFQDN) == 0) {

    /* Yes, get current date string for mail messages */
    UMSRFCPrintCurrentTime((struct UMSRFCData *) purd, purd->purd_Buffer1);

    /* Create "Received: ..." line */
    pfprintf(func, outputdata,
             "Received: by %s (UMSRFC "
              INTTOSTR(UMSRFC_LIBRARY_VERSION)  "."
              INTTOSTR(UMSRFC_REVISION)         "/"
              INTTOSTR(UMSRFC_LIBRARY_REVISION) ");\r\n\t%s\r\n",
             purd->purd_Public.urd_DomainName, purd->purd_Buffer1);
   }

   /* Create "To:" line. Logical recipient address set? */
   if (!WriteRFCAddressField(&ld, "To",
                     purd->purd_Public.urd_MsgFields[UMSCODE_LogicalToAddr],
                     purd->purd_Public.urd_MsgFields[UMSCODE_LogicalToName])) {

    /* No, list EACH recipient on the "To:" line. Convert first To-Address */
    UMSRFCConvertUMSAddress((struct UMSRFCData *) purd,
                            purd->purd_Public.urd_MsgFields[UMSCODE_ToAddr],
                            purd->purd_Public.urd_MsgFields[UMSCODE_ToName],
                            purd->purd_Buffer2);

    /* Print begin of "To: ..." line */
    pfprintf(func, outputdata, "To: \"%s\" <%s>",
             purd->purd_Public.urd_MsgFields[UMSCODE_ToName],
             purd->purd_Buffer2);

    /* Create rest of "To:" line */
    {
     UMSMsgNum currentnum;

     /* Message soft-linked? */
     if ((currentnum = purd->purd_Public.urd_MsgData.urmd_SoftLink) != 0) {
      char *nexttoaddr;
      char *nexttoname;
      char *nextgroup;
      UMSMsgNum nextnum;

      /* Yes, scan soft-link until original message is reached again */
      while (currentnum != msgnum) {

       /* Read msg number & ToAddress of next soft-linked message */
       if (!TAGCALL(UMSReadMsgTags)(UMSBASE account,
                                    UMSTAG_RMsgNum,   currentnum,
                                    UMSTAG_RToAddr,   &nexttoaddr,
                                    UMSTAG_RToName,   &nexttoname,
                                    UMSTAG_RGroup,    &nextgroup,
                                    UMSTAG_RSoftLink, &nextnum,
                                    TAG_DONE))
        break; /* ERROR! */

       /* Group not set? (Softlinked Mail<->News check) */
       if (nextgroup == NULL) {

        /* Convert To-Address */
        UMSRFCConvertUMSAddress((struct UMSRFCData *) purd, nexttoaddr,
                                nexttoname, purd->purd_Buffer2);

        /* Add ToAddress to RFC field */
        pfprintf(func, outputdata, ",\r\n\t\"%s\" <%s>",
                 nexttoname, purd->purd_Buffer2);
       }

       /* Free message */
       UMSFreeMsg(account, currentnum);

       /* Get next message number */
       currentnum = nextnum;
      }
     }
    }

    /* Close "To:" line */
    pfputs(func, outputdata, "\r\n");
   }

   /* Create "In-Reply-To: ...." line */
   WriteReplyMsgID(&ld, "In-Reply-To",
                        purd->purd_Public.urd_MsgData.urmd_ChainUp, FALSE);

   /* Create "Return-Receipt-To: ...." line */
   {
    char *name;

    /* Valid receipt request? */
    if (name = purd->purd_AttributesData.ad_ReceiptRequest) {
     char *addr;

     /* Yes, empty parameter specified? */
     if (strlen(name) == 0) {

      /* Yes, use senders name. addr == NULL */
      name = purd->purd_Public.urd_MsgFields[UMSCODE_FromName],
      addr = NULL;

     /* Scan receipt request string for last ',' */
     } else if (addr = strrchr(name, ','))

      /* Name and address specified, set string terminator for name */
      *addr++ = '\0';

     /* Only address specified? */
     else if (addr = strchr(name, '@')) {

      /* Yes */
      addr = name;
      name = "Unknown";
     }
     /* No: Only name of local user specified -> addr == NULL */

     /* Create field */
     WriteRFCAddressField(&ld, "Return-Receipt-To", addr, name);
    }
   }

  } else {
   /* No, create news only fields */

   /* Crest "Path: ..." line. Does the system have its own domain name? */
   if (purd->purd_Public.urd_Flags & UMSRFC_FLAGS_NOOWNFQDN)

    /* No, don't add a name to the path */
    pfputs(func, outputdata, "Path: not-for-mail\r\n");

   else
    /* Yes, add name to the path */
    pfprintf(func, outputdata,
             "Path: %s!not-for-mail\r\n", purd->purd_Public.urd_PathName);

   /* Create begin of "Newsgroups:" line */
   pfprintf(func, outputdata, "Newsgroups: %s",
            purd->purd_Public.urd_MsgFields[UMSCODE_Group]);

   /* Create rest of "Newsgroups:" line */
   {
    UMSMsgNum currentnum;

    /* Message hard-linked? */
    if ((currentnum = purd->purd_Public.urd_MsgData.urmd_HardLink) != 0)

     /* Yes, scan hard-link until original message is reached again */
     while (currentnum != msgnum) {
      char *group;
      UMSMsgNum nextnum;

      /* Read msg number & group of next hard-linked message */
      if (!TAGCALL(UMSReadMsgTags)(UMSBASE account,
                                   UMSTAG_RMsgNum,   currentnum,
                                   UMSTAG_RGroup,    &group,
                                   UMSTAG_RHardLink, &nextnum,
                                   TAG_DONE))
       break; /* ERROR! */

      /* Add group to RFC field */
      pfprintf(func, outputdata, ",%s", group);

      /* Free message */
      UMSFreeMsg(account, currentnum);

      /* Get next message number */
      currentnum = nextnum;
     }
   }

   /* Close "Newsgroups:" line */
   pfputs(func, outputdata, "\r\n");

   /* Create "References: ..." line */
   WriteReplyMsgID(&ld, "References",
                        purd->purd_Public.urd_MsgData.urmd_ChainUp, TRUE);
  }

  /* Create common fields for mail and news */

  /* Create message creation date string */
  {
   ULONG date;

   /* Creation date valid? */
   if ((date = purd->purd_Public.urd_MsgData.urmd_MsgCDate) == 0)
    date = purd->purd_Public.urd_MsgData.urmd_MsgDate; /* Use receive date */

   UMSRFCPrintTime((struct UMSRFCData *) purd, date, purd->purd_Buffer2);
  }

  /* Create "From: ...." and "Date: ...." line */
  pfprintf(func, outputdata, "From: \"%s\" <%s>\r\nDate: %s\r\n",
           purd->purd_Public.urd_MsgFields[UMSCODE_FromName],
           purd->purd_Public.urd_FromAddress, purd->purd_Buffer2);

  /* Create "Reply-To: ...." line */
  WriteRFCAddressField(&ld, "Reply-To",
                       purd->purd_Public.urd_MsgFields[UMSCODE_ReplyAddr],
                       purd->purd_Public.urd_MsgFields[UMSCODE_ReplyName]);

  /* Write MIME Headers (only if charset is specified) */
  if (charset) {
   pfputs(func, outputdata, "MIME-Version: 1.0\r\n");
   pfprintf(func, outputdata, MIMEHeaders, charset, encoding);
  }

  /* Urgent message? */
  if (purd->purd_AttributesData.ad_Urgent)
   pfputs(func, outputdata, "Priority: urgent\r\n");

  /* Print headers from "RFC Attributes" field */
  {
   char **hdrs = purd->purd_RFCAttributesData.rad_Misc;

   /* Any headers specified? */
   if (hdrs) {
    char *hdr;

    /* For each header */
    while (hdr = *hdrs++) pfprintf(func, outputdata, "%s\r\n", hdr);
   }
  }

  /* This message was imported by UMS RFC. Don't create all headers */
 } else {
  char *lp = purd->purd_Public.urd_MsgFields[UMSCODE_Comments]
              + UMSRFC_HEADER_LEN;
  char *cp;

  /* For each line in the comment field */
  while (cp = strchr(lp, '\n')) {

   /* Set string terminator */
   *cp++ = '\0';

   /* Print RFC header stored in the comments field */
   pfprintf(func, outputdata, "%s\r\n", lp);

   /* Next line */
   lp = cp;
  }

  /* Charset specified and MIME attribute set? */
  if (charset && purd->purd_AttributesData.ad_MIME)
   /* Yes, write MIME headers */
   pfprintf(func, outputdata, MIMEHeaders, charset, encoding);

  /* Create "Date: ..." line */
  if ((cp = purd->purd_Public.urd_MsgFields[UMSCODE_CreationDate]) &&
      (strcmp(cp, DateNotSet) != 0))
   pfprintf(func, outputdata, "Date: %s\r\n", cp);
 }

 /* II. Close RFC header -------------------------------------------------- */
 if (mail)
  /* Mail only fields */
  WriteRFCHeaderField(&ld, "X-Mailer",
                      purd->purd_Public.urd_MsgFields[UMSCODE_Newsreader]);
 else {
  /* News only fields */
  WriteRFCHeaderField(&ld, "Distribution",
                      purd->purd_Public.urd_MsgFields[UMSCODE_Distribution]);
  WriteRFCHeaderField(&ld, "Followup-To",
                      purd->purd_Public.urd_MsgFields[UMSCODE_ReplyGroup]);
  WriteRFCHeaderField(&ld, "X-NewsReader",
                      purd->purd_Public.urd_MsgFields[UMSCODE_Newsreader]);
 }

 /* Subject & Message-ID */
 pfprintf(func, outputdata, "Subject: %s\r\nMessage-ID: <%s>\r\n",
          purd->purd_Public.urd_MsgFields[UMSCODE_Subject],
          purd->purd_Public.urd_MsgFields[UMSCODE_MsgID]);

 /* MIME? */
 WriteRFCHeaderField(&ld, "Organization",
                     purd->purd_Public.urd_MsgFields[UMSCODE_Organization]);

/*** Temporarily removed until "Gateway Information" field is available ***/
#if 0
 /* Create "X-Gateway..." line (only if gated message) */
 if ((purd->purd_Public.urd_MsgFields[UMSCODE_FromAddr] != NULL) &&
     CreateAllHeaders)

  pfprintf(func, outputdata,
           "X-Gateway: ??? %s [UMSRFC " INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
           INTTOSTR(UMSRFC_LIBRARY_REVISION) "]\r\n",
           purd->purd_Public.urd_DomainName);
#endif

 /* Close header */
 pfputs(func, outputdata, "\r\n");

 /* III. Write message text ----------------------------------------------- */
 /* Text valid? */
 if (text)

  /* Encode text? */
  if (NeedsEncoding)

   /* Yes */
   EncodeMessage(func, outputdata, text, encodingtype, smtp);

  else {
   char *tp = text;

   /* No encoding needed, for each line */
   while (tp && *tp) {

    /* SMTP and first character a '.'? */
    if (smtp && (*tp == '.')) (*func)(outputdata, '.'); /* Yes, qoute it */

    /* Search end of line */
    if (tp = strchr(tp, '\n'))

     /* Add string terminator */
     *tp++ = '\0';

    /* Write line */
    pfputs(func, outputdata, text);

    /* Add line terminator */
    pfputs(func, outputdata, "\r\n");

    /* Move pointer */
    text = tp;
   }
  }

/* UUENCODE encoding function */
#define ENCODE(c) ((c) ? ((c) & 0x3F) + ' ': '`')

 /* Is a file attached to this message? */
 if (text = purd->purd_Public.urd_MsgFields[UMSCODE_FileName]) {
  struct Library *DOSBase = purd->purd_Bases.urb_DOSBase;
  BPTR fh;

  /* Open file */
  if (fh = Open(purd->purd_Public.urd_MsgFields[UMSCODE_TempFileName],
                MODE_OLDFILE)) {
   int n;

   /* Write header */
   pfprintf(func, outputdata,
            "--- start of uuencoded binary\r\nbegin 644 %s\r\n", text);

   /* Encode all bytes */
   do {
    int   i;
    int   checksum = 0;
    char *ip       = purd->purd_Buffer1;
    char *op       = purd->purd_Buffer2;

    /* Read 1..45 bytes */
    n = FRead(fh, ip, 1, 45);

    /* Write line length */
    *op++ = ENCODE(n);

    /* Encode 3 bytes into 4 characters */
    for (i = 0; i < n; i += 3) {
     UBYTE a = *ip++;
     UBYTE b = *ip++;
     UBYTE c = *ip++;
     UBYTE out;

     out   = a >> 2;
     *op++ = ENCODE(out);
     out   = ((a << 4) & 0x30) | ((b >> 4) & 0xF);
     *op++ = ENCODE(out);
     out   = ((b << 2) & 0x3C) | (( c>> 6) & 0x3);
     *op++ = ENCODE(out);
     *op++ = ENCODE(c);

     /* Add bytes to checksum */
     checksum += a + b + c;
    }

    /* Append checksum and line terminator */
    checksum &= 0x3F;
    *op++     = ENCODE(checksum);
    *op       = '\0';

    /* Encoding type quoted-printable? */
    if (encodingtype != ENCODE_QUOTED_PRINTABLE)

     /* Print line */
     pfprintf(func, outputdata, "%sX\r\n", purd->purd_Buffer2);

    else {
     char c;

     /* Yes, check for '=' characters */
     for (ip = purd->purd_Buffer2; c = *ip++; )

      /* '=' character? */
      if (c == '=')

       /* Yes, encode it */
       pfputs(func, outputdata, "=3D");

      else

       /* No, just print the character */
       (*func)(outputdata, c);

     /* Append line end */
     pfputs(func, outputdata, "X\r\n");
    }

    /* Repeat until all bytes are read */
   } while (n > 0);

   /* Write trailer */
   pfprintf(func, outputdata,
            "end\r\nsize %d\r\n--- end of uuencoded binary\r\n",
            Seek(fh, 0, OFFSET_BEGINNING));

   Close(fh);
  }
 }

 /* All OK! */
 return(TRUE);
}
