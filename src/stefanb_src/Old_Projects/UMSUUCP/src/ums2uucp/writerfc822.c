/*
 * writerfc822.c  V0.8.04
 *
 * write RFC message
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Message ID format */
static const char IDFormat[]=" <%s>";

/* Date format for strftime() */
char DateFormat[]="%a, %d %b %y %H:%M:%S -0000";
#define DF_GMTOFF 22 /* Offset for time zone in date format string */

/* MIME Headers */
static const char MIMEHeaders[]=
 "Content-Type: text/plain; charset=%s\n"
 "Content-Transfer-Encoding: %s\n";

/* FIX for DICE 2.07.54R -ms switch */
static const short fixdummy;

/* Locale library base */
static struct Library *LocaleBase;

/* Configuration data */
#define ENCODE_NONE             0
#define ENCODE_QUOTED_PRINTABLE 1
#define ENCODE_BASE64           2
static ULONG EncodingType=ENCODE_NONE;

/* MIME Encoding buffer */
#define MIME_LINELEN 74
static char EncodeBuffer[MIME_LINELEN+4]; /* Margin for 3 letters and '\0' */

/* UUENCODE encoding function */
#define ENCODE(c) ((c) ? ((c) & 0x3F) + ' ': '`')

/* Get RFC Data */
void GetRFCData(void)
{
 char *cp;

 /* Read UMS config var for encoding type */
 if (cp=ReadUMSConfigTags(Account,UMSTAG_CfgName,UMSUUCP_ENCODING,
                                  TAG_DONE)) {
  char *tp;

  /* Read number */
  EncodingType=strtol(cp,&tp,10);

  /* Sanity check */
  if (EncodingType>ENCODE_BASE64) EncodingType=ENCODE_NONE;

  /* Free UMS var */
  FreeUMSConfig(Account,cp);
 }

 /* Set time zone from Locale. Open locale library */
 if (LocaleBase=OpenLibrary("locale.library",38)) {
  struct Locale *loc;

  /* Open default Locale */
  if (loc=OpenLocale(NULL)) {
   /* Locale open, get offset in minutes _FROM_ GMT */
   /* Translate to RFC822 GMT +/- HHMM format       */
   LONG gmtoff=loc->loc_GMTOffset;

   /* Negative offset? */
   if (gmtoff<0) {
    /* Yes, that means "GMT +HHMM" */
    DateFormat[DF_GMTOFF]='+';
    gmtoff=-gmtoff;
   }

   /* Print offset to GMT into date string */
   sprintf(&DateFormat[DF_GMTOFF+1],"%02d%02d",gmtoff/60,gmtoff%60);

   /* Close Locale */
   CloseLocale(loc);
  }

  /* Close library */
  CloseLibrary(LocaleBase);
 }

 /* Debugging */
 ulog(1,"Encoding Type: %d, Time zone: GMT %s",
         EncodingType,&DateFormat[DF_GMTOFF]);
}

/* Free RFC data */
void FreeRFCData(void)
{
 /* Nothing to free (yet) */
}

/* Check charset. Return TRUE for iso-8859-1, FALSE for us-ascii */
static BOOL CheckCharset(char *text)
{
 /* Text valid? */
 if (text) {
  char c;

  /* Check for 8-Bit characters */
  while (c=*text++) if (c & 0x80) return(TRUE); /* 8-Bit character found! */
 }

 /* No 8-Bit characters found */
 return(FALSE);
}

/* Recurse into Refer ID tree */
static void RecurseReferID(FILE *fh, UMSMsgNum msgnum, char *msgid)
{
 char *newmsgid,*referid;
 UMSMsgNum refernum;

 /* Valid chain-up and can we read the data of the parent message? */
 if ((msgnum!=0) && ReadUMSMsgTags(Account,UMSTAG_RMsgNum,   msgnum,
                                           UMSTAG_RMsgID,   &newmsgid,
                                           UMSTAG_RChainUp, &refernum,
                                           UMSTAG_RReferID, &referid,
                                           TAG_DONE)) {
  /* Yes, recurse on step further */
  RecurseReferID(fh,refernum,referid);

  /* Write Message id */
  fprintf(fh,IDFormat,newmsgid);

  /* Free message */
  FreeUMSMsg(Account,msgnum);

  /* No, Message ID valid? */
 } else if (msgid)
  fprintf(fh,IDFormat,msgid);
}

/* Write reply msg ID */
static void WriteReplyMsgID(FILE *fh, char *header, UMSMsgNum msgnum,
                            BOOL recurse)

{
 char *msgid,*referid;
 UMSMsgNum refernum;

 /* Valid chain-up and can we read the data of the parent message? */
 if ((msgnum!=0) && ReadUMSMsgTags(Account,UMSTAG_RMsgNum,   msgnum,
                                           UMSTAG_RMsgID,   &msgid,
                                           UMSTAG_RChainUp, &refernum,
                                           UMSTAG_RReferID, &referid,
                                           TAG_DONE)) {
  /* Yes, Refer ID header */
  fprintf(fh,"%s:",header);

  /* Recurse into referid tree? */
  if (recurse) RecurseReferID(fh,refernum,referid);

  /* Write Refer ID and close header line */
  fprintf(fh," <%s>\n",msgid);

  /* Free message */
  FreeUMSMsg(Account,msgnum);

  /* No, is reply ID of message valid? */
 } else if (msgid=MsgFields[UMSCODE_ReferID])
  /* Yes, write reply msg ID into header line */
  fprintf(fh,"%s: <%s>\n",header,msgid);
}

/* Write header field if string is not empty */
static void WriteRFCHeaderField(FILE *fh, char *header, char *text)
{
 /* Text valid? */
 if (text)
  /* Yes. Write header field */
  fprintf(fh,"%s: %s\n",header,text);
}

/* Write address with or without name */
static BOOL WriteRFCAddressField(FILE *fh, char *header, char *addr,
                                 char *name)
{
 BOOL rc;

 /* Address or name valid? */
 if (rc=(addr || name)) {
  /* Yes, convert address */
  ConvertAddress(Tmp2Buffer,name,addr);

  /* Print header line */
  if (name)
   fprintf(fh,"%s: \"%s\" <%s>\n",header,name,Tmp2Buffer);
  else
   fprintf(fh,"%s: %s\n",header,Tmp2Buffer);
 }

 return(rc);
}

/* Write RFC message to outfile */
BOOL WriteRFCMessage(FILE *fh, UMSMsgNum msgnum, BOOL mail, BOOL smtp)
{
 char *text=MsgFields[UMSCODE_MsgText];
 char *charset, *encoding;
 BOOL NeedsEncoding=CheckCharset(text);
 BOOL CreateAllHeaders;

 /* Set MIME Parameters. 8-Bit characters found? */
 if (NeedsEncoding) {
  /* Yes, set charset to iso-8859-1 */
  charset="iso-8859-1";

  /* check encoding type */
  switch (EncodingType) {
   case ENCODE_NONE:             encoding="8bit";
                                 NeedsEncoding=FALSE; /* Do not encode */
                                 break;
   case ENCODE_QUOTED_PRINTABLE: encoding="quoted-printable";
                                 break;
   case ENCODE_BASE64:           encoding="base64";
                                 break;
  }
 } else {
  /* No, set charset to us-ascii and encoding to 7bit */
  charset="us-ascii";
  encoding="7bit";
 }

 /* Must we create all headers? */
 CreateAllHeaders= /* Message from local user (no from address) */
                   (MsgFields[UMSCODE_FromAddr] == NULL) ||

                   /* No comments field (that means, no RFC header) */
                   (MsgFields[UMSCODE_Comments] == NULL) ||

                   /* Message imported by UMSUUCPs uuxqt? */
                   (strnicmp(UMSUUCP_HEADERID,MsgFields[UMSCODE_Comments],
                             UMSUUCP_HDRIDLEN) != 0);

 /* I. Start RFC header --------------------------------------------------- */
 /* Create all headers? */
 if (CreateAllHeaders) {
  /* Yes. Mail? */
  if (mail) {
   /* Yes, create mail only fields */

#if 0
   /* Create current date string for mail messages */
   /* This can be left out, because Tmp1Buffer is initialized with the */
   /* current date string in exportmail.c already. */
   {
    time_t t=time(NULL);         /* Get current calendar time */
    struct tm *tp=localtime(&t); /* Convert calendar time into local time */

    strftime(Tmp1Buffer,TMP1BUFSIZE,DateFormat,tp);
   }
#endif

   /* Create "Received: ..." line */
   fprintf(fh,
           "Received: by %s (UMS-UUCP/sendmail" UMSUUCP_VERSION ");\n\t%s\n",
           DomainName,Tmp1Buffer);

   /* Create "To:" line. Logical recipient address set? */
   if (!WriteRFCAddressField(fh,"To",MsgFields[UMSCODE_LogicalToAddr],
                                MsgFields[UMSCODE_LogicalToName])) {

    /* No, list EACH recipient on the "To:" line. Convert first To-Address */
    ConvertAddress(Tmp2Buffer,
                   MsgFields[UMSCODE_ToName],MsgFields[UMSCODE_ToAddr]);

    /* Print begin of "To: ..." line */
    fprintf(fh, "To: \"%s\" <%s>", MsgFields[UMSCODE_ToName],Tmp2Buffer);

    /* Create rest of "To:" line */
    {
     UMSMsgNum currentnum;

     /* Message soft-linked? */
     if ((currentnum=MessageData.md_SoftLink)!=0)
      /* Yes, scan soft-link until original message is reached again */
      while (currentnum!=msgnum) {
       char *nexttoname;
       char *nexttoaddr;
       UMSMsgNum nextnum;

       /* Read msg number & ToAddress of next soft-linked message */
       if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,   currentnum,
                                   UMSTAG_RToName,   &nexttoname,
                                   UMSTAG_RToAddr,   &nexttoaddr,
                                   UMSTAG_RSoftLink, &nextnum,
                                   TAG_DONE))
        break; /* ERROR! */

       /* Convert To-Address */
       ConvertAddress(Tmp2Buffer,nexttoname,nexttoaddr);

       /* Add ToAddress to RFC field */
       fprintf(fh,",\n\t\"%s\" <%s>",nexttoname,Tmp2Buffer);

       /* Free message */
       FreeUMSMsg(Account,currentnum);

       /* Get next message number */
       currentnum=nextnum;
      }
    }

    /* Close "To: ..." line */
    fputc('\n',fh);
   }


   /* Create "In-Reply-To: ...." line */
   WriteReplyMsgID(fh,"In-Reply-To",MessageData.md_ChainUp,FALSE);

  } else {
   /* No, create news only fields */
   /* Create "Path: ..." and begin of "Newsgroups:" line */
   fprintf(fh,"Path: %s!postmaster\nNewsgroups: %s",
              PathName,MsgFields[UMSCODE_Group]);

   /* Create rest of "Newsgroups:" line */
   {
    UMSMsgNum currentnum;

    /* Message hard-linked? */
    if ((currentnum=MessageData.md_HardLink)!=0)
     /* Yes, scan hard-link until original message is reached again */
     while (currentnum!=msgnum) {
      char *group;
      UMSMsgNum nextnum;

      /* Read msg number & group of next hard-linked message */
      if (!ReadUMSMsgTags(Account,UMSTAG_RMsgNum,   currentnum,
                                  UMSTAG_RGroup,    &group,
                                  UMSTAG_RHardLink, &nextnum,
                                  TAG_DONE))
       break; /* ERROR! */

      /* Add group to RFC field */
      fprintf(fh,",%s",group);

      /* Free message */
      FreeUMSMsg(Account,currentnum);

      /* Get next message number */
      currentnum=nextnum;
     }
   }

   /* Close "Newsgroups:" line */
   fputc('\n',fh);

   /* Create "References: ..." line */
   WriteReplyMsgID(fh,"References",MessageData.md_ChainUp,TRUE);
  }

  /* Create message creation date string */
  {
   /* Convert UMS time into local time                              */
   /* Don't forget: UNIX and AmigaDOS have different epoch times!   */
   /* UNIX: 1-1-1970, AmigaDOS: 1-1-1978                            */
   /* -> (2*366 + 6*365) * 24 * 60 * 60 = 252460800 seconds to add! */
   time_t t=MessageData.md_MsgDate + 252460800;
   struct tm *tp=localtime(&t);

   strftime(Tmp2Buffer,TMP2BUFSIZE,DateFormat,tp);
  }

  /* Create common fields for mail and news */
  fprintf(fh,"From: \"%s\" <%s>\nDate: %s\n",
             MsgFields[UMSCODE_FromName],FromAddrBuffer,Tmp2Buffer);

  /* Create "Reply-To: ...." line */
  WriteRFCAddressField(fh,"Reply-To",MsgFields[UMSCODE_ReplyAddr],
                          MsgFields[UMSCODE_ReplyName]);

  /* Write MIME Headers */
  fputs("MIME-Version: 1.0\n",fh);
  fprintf(fh,MIMEHeaders,charset,encoding);

  /* This message was imported by UMS UUCP. Don't create all headers */
 } else {
  char *cp;

  /* Use the partial RFC header stored in the comments field */
  fputs(MsgFields[UMSCODE_Comments]+UMSUUCP_HDRIDLEN,fh);

  /* Attributes field valid and MIME message? */
  if ((cp=MsgFields[UMSCODE_Attributes]) && (!strcmp(cp,"MIME")))
   /* Yes, write MIME headers */
   fprintf(fh,MIMEHeaders,charset,encoding);

  /* Create "Date: ..." line */
  if ((cp=MsgFields[UMSCODE_CreationDate]) && strcmp(cp,"Not specified"))
   fprintf(fh,"Date: %s\n",cp);
 }

 /* II. Close RFC header -------------------------------------------------- */
 if (mail)
  /* Mail only fields */
  WriteRFCHeaderField(fh,"X-Mailer",MsgFields[UMSCODE_Newsreader]);
 else {
  /* News only fields */
  WriteRFCHeaderField(fh,"Distribution", MsgFields[UMSCODE_Distribution]);
  WriteRFCHeaderField(fh,"Followup-To", MsgFields[UMSCODE_ReplyGroup]);
  WriteRFCHeaderField(fh,"X-NewsReader", MsgFields[UMSCODE_Newsreader]);
 }
 fprintf(fh,"Subject: %s\nMessage-ID: <%s>\n",MsgFields[UMSCODE_Subject],
                                              MsgFields[UMSCODE_MsgID]);
 /* MIME? */
 WriteRFCHeaderField(fh,"Organization",MsgFields[UMSCODE_Organization]);

 /* Close header */
 fputc('\n',fh);

 /* III. Write message text ----------------------------------------------- */
 /* Text valid? */
 if (text)

  /* Encode text? */
  if (NeedsEncoding)
   /* Yes, check encoding type */
   if (EncodingType=ENCODE_QUOTED_PRINTABLE) {

    /* Encode with quoted-printable's */
    while (*text) {
     /* Encode one line */
     char c;
     char *ep=EncodeBuffer;
     int count=MIME_LINELEN;

     /* SMTP and '.' as next character (start of line!)? */
     if (smtp && (*text=='.')) {
      /* Quote '.' at start of line */
      *ep++='.';
      count--;
     }

     /* Parse line */
     while ((c=*text++) && (c!='\n') && (count>0))

      /* 8-Bit character or '='? */
      if ((c & 0x80) || (c=='=')) {
       /* Encode character */
       char d;

       /* '=' <hex digit 1> <hex digit 2> */
       *ep++='=';
       d=(c & 0xF0)>>4;
       *ep++=(d<10) ? (d+'0') : (d+'A'-10);
       d=c & 0x0F;
       *ep++=(d<10) ? (d+'0') : (d+'A'-10);

       /* Three characters added */
       count-=3;

      } else {
       /* Nothing to encode */
       *ep++=c;
       count--;
      }

     /* End of line? */
     if (c=='\n')
      /* Yes, remove trailing white space */
      while ((ep!=EncodeBuffer) && (((c=*(ep-1))==' ') || (c=='\t'))) ep--;

      /* Line length exceeded */
     else {
      *ep++='='; /* add soft line break */
      text--;    /* Move pointer back */
     }

     /* Add line terminator */
     *ep++='\n';
     *ep='\0';

     /* Write buffer to file */
     fputs(EncodeBuffer,fh);
    }
   } else {

    /* Encode with base64 */
   }
  else {

   /* No encoding needed. SMTP? */
   if (smtp) {
    /* Yes */
    char *tp;

    /* First character a '.'? */
    if (*text=='.') fputc('.',fh); /* Yes, qoute it */

    /* Do processing of "\n." lines */
    while (tp=strstr(text,"\n.")) {
     /* Add string terminator */
     *tp='\0';

     /* Write text upto special line */
     fputs(text,fh);

     /* Replace "\n." with "\n.." */
     fputs("\n.",fh);

     /* Move pointer */
     text=tp+1;
    }
   }

   /* Write (rest of) message */
   if (text) fputs(text,fh);
  }

 /* Fileattach? */
 if ((text=MsgFields[UMSCODE_Attributes]) && strstr(text,"file-attach")) {
  /* Append a file "uuencoded" */
  FILE *ifh;
  char *name=MsgFields[UMSCODE_Subject];

  /* Open file */
  if (ifh=fopen(name,"r")) {
   /* File open */
   int n;

   /* Write header */
   fprintf(fh,"--- start of uuencoded binary\nbegin 644 %s\n",FilePart(name));

   /* Encode all bytes */
   do {
    int i,checksum=0;
    char *cp;

    /* Read 1..45 bytes */
    n=fread(Tmp1Buffer,1,45,ifh);

    /* Write line length */
    fputc(ENCODE(n),fh);

    /* Encode 3 bytes into 4 characters */
    for (i=0,cp=Tmp1Buffer; i<n; i+=3) {
     UBYTE a=*cp++;
     UBYTE b=*cp++;
     UBYTE c=*cp++;
     UBYTE out;

     out=a>>2;
     fputc(ENCODE(out),fh);
     out=((a<<4) & 0x30) | ((b>>4) & 0xF);
     fputc(ENCODE(out),fh);
     out=((b<<2) & 0x3C) | ((c>>6) & 0x3);
     fputc(ENCODE(out),fh);
     fputc(ENCODE(c),fh);

     /* Add bytes to checksum */
     checksum+=a+b+c;
    }

    /* Append line checksum, 'X' boundery and line end */
    checksum&=0x3F;
    fprintf(fh,"%cX\n",ENCODE(checksum));

    /* Repeat until all bytes are read */
   } while (n>0);

   /* Write trailer */
   fprintf(fh,"end\nsize %d\n--- end of uuencoded binary\n",ftell(ifh));

   /* Close file */
   fclose(ifh);
  }
 }

 /* SMTP? */
 if (smtp)
  /* Yes, write SMTP terminator */
  fputs("\n.\n",fh);

 /* All OK! */
 return(TRUE);
}
