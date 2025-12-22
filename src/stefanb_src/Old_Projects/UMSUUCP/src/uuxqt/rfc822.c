/*
 * rfc822.c  V0.8.04
 *
 * scan RFC 822 header (with RFC 1341/1342 support), build UMS message tags
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "uuxqt.h"

static const char CorruptedHdrMsg[]="corrupted RFC header!\n";

/*
 * RFC date & time format
 *
 * [<day of week>,] <day> <mon> <year> <hr:min[:sec]> <zone>
 *        1           2     3      4         5           6
 */
#define MAXDATEARGS 6
static struct ClockData ClockData;
static char *DateTimeArray[MAXDATEARGS];

/* ClockData->month = 1 (Jan) ... 12 (Dec) */
static const char *Month[12] = {
 "Jan", "Feb", "Mar", "Apr", "May", "Jun",
 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

/* Add one line to comment buffer */
static char *AddComment(char *cbuf, char *line)
{
 /* Copy line to buffer */
 strcpy(cbuf,line);

 /* Correct pointer */
 cbuf+=strlen(cbuf);

 /* Add \n */
 *cbuf++='\n';

 /* Return new position in buffer */
 return(cbuf);
}

/* Create CDate from RFC date string */
static ULONG GetCDate(char *date)
{
 int count = 0;

 /* Tokenize date/time string */
 {
  char *ap = date;
  char c;

  do {

   /* Skip white space */
   while ((c = *ap) && ((c == ' ') || (c == '\t'))) ap++;

   /* Store pointer to next argument */
   DateTimeArray[count++] = ap;

   /* Skip to next white space */
   while ((c = *ap) && (c != ' ') && (c != '\t')) ap++;

   /* Append string terminator */
   *ap++ = '\0';

  } while (c && (count < MAXDATEARGS));
 }

 /* Enough parameters? */
 if (count >= 4) {
  char **arg = DateTimeArray;
  char *dummy;

  /* Clear rest of array */
  for (; count < MAXDATEARGS; count++) DateTimeArray[count] = "";

  /* Skip optional day of week field */
  if ((*arg)[strlen(*arg)-1] == ',') {
   arg++;
   count--;
  }

  /* Still enough parameters? */
  if (count >= 4) {

   /* Set day of week to 0 */
   ClockData.wday = 0;

   /* Get day of month */
   if (ClockData.mday = strtol(*arg++, &dummy, 10)) {

    /* Get month */
    ClockData.month = 0;
    count           = 0;
    do {

     /* Compare names */
     if (stricmp(*arg, Month[count++]) == 0) {
      ClockData.month = count;
      break;
     }

    } while (count < 12);

    /* Month valid? */
    if (ClockData.month) {

     /* Get year */
     ++arg;
     if (ClockData.year = strtol(*arg++, &dummy, 10)) {

      /* A little hack for the year 2000. UNIX epoch starts 1970 */
      ClockData.year += (ClockData.year < 70) ? 2000 : 1900;

      /* Get hour */
      ClockData.hour = strtol(*arg, &dummy, 10);
      if ((ClockData.hour <= 24) && (*dummy == ':')) {

       /* Get minute */
       ClockData.min = strtol(++dummy, &dummy, 10);
       if ((ClockData.min <= 59) && ((*dummy == ':') || (*dummy == '\0'))) {

        /* Get seconds (optional) */
        if (*dummy == ':')
         ClockData.sec = strtol(++dummy, &dummy, 10);
        else
         ClockData.sec = 0;

        /* Check seconds and convert date/time to Amiga format */
        if (ClockData.sec <= 59) return(CheckDate(&ClockData));
       }
      }
     }
    }
   }
  }
 }
 return(0);
}

/*
 * Scan RFC 822 message
 *
 * Uses temporary buffers to store name and address:
 *
 *  Tmp1Buffer: Name from From: line
 *  Tmp2Buffer: Address from From: line
 *  Tmp3Buffer: Name from Reply-To: line
 *  Tmp4Buffer: Address from Reply-To: line
 *
 * Don't use this buffers until message has been saved!
 *
 */
BOOL ScanRFCMessage(char *msgbuf, struct TagItem *msgtags, BOOL mail)
{
 char *tp,*cp;
 char *MIMEType=NULL,*MIMEEncoding=NULL,*MIMELength=NULL;
 BOOL firstline=mail;
 BOOL control=FALSE;

 /* Init pointers & buffers */
 tp=msgbuf;                           /* Pointer in text buffer */
 strcpy(MainBuffer,UMSUUCP_HEADERID); /* Init comment buffer */
 cp=MainBuffer+UMSUUCP_HDRIDLEN;      /* Pointer in comment buffer */

 /* Init tag array */
 {
  struct TagItem *ti;

  for (ti=msgtags; ti->ti_Tag!=TAG_DONE; ti++) ti->ti_Data=NULL;
 }

 /* Ignore CDate */
 msgtags[MSGTAGS_CDATE].ti_Tag=TAG_IGNORE;

 /*******************/
/* UMSDebugLog(10,">>> BEGIN >>>%s>>>END>>>\n",tp);
 return(FALSE); */
 /*******************/

 /* RFC 822 header processing loop */
 while (*tp) {
  char *kp=tp;  /* Pointer to begin of current line (RFC 822 keyword) */
  char *lp;     /* Pointer to data portion of current line */
  int klen;     /* Length of RFC 822 keyword */

  /* End of RFC 822 header reached? */
  if (*tp=='\n') break;

  /* Search ':' (end of RFC 822 keyword) */
  if (!firstline && !(lp=strchr(kp,':'))) {
   ErrLog(CorruptedHdrMsg);
   return(FALSE);
  }

  /* Skip ':' */
  if (firstline)
   lp=kp;
  else {
   klen=lp-kp;
   lp++;
  }

  /* Skip additional white space */
  while ((*lp==' ') || (*lp=='\t')) lp++;

  /* Search end of current line */
  if (!(tp=strchr(lp,'\n'))) {
   ErrLog(CorruptedHdrMsg);
   return(FALSE);
  }

  /* Concatenate splitted lines */
  {
   char *dp=tp; /* Destination pointer */

   /* Splitted lines begin with space or tab */
   while ((*(tp+1)==' ') || (*(tp+1)=='\t')) {
    /* Remove \n or \0 */
    *dp++=' ';

    /* Skip tabs & spaces */
    tp+=2;
    while ((*tp==' ') || (*tp=='\t')) tp++;

    /* Copy rest of line */
    while (*tp!='\n') *dp++=*tp++;

    /* Set string terminator */
    *dp='\0';
   }
  }

  /* Set string terminator */
  *tp++='\0';

  /* Handle first line of a mail as special case */
  if (firstline) {
   /* Got first line */
   firstline=FALSE;

   /* Create time string in Tmp1Buffer */
   {
    time_t t=time(NULL);         /* Get current calendar time */
    struct tm *tp=localtime(&t); /* Convert calendar time into local time */

    /* Create time string: <weekday name>, <day> <month name> <year> */
    /*                     <hour>:<minute>:<second> <time zone name> */
    strftime(Tmp1Buffer,TMP1BUFSIZE,"%a, %d %b %y %H:%M:%S %Z",tp);
   }

   /* Add "Received:" line to comment buffer */
   sprintf(cp,"Received: by %s (UMS-UUXQT/RMail" UMSUUCP_VERSION "); %s\n",
           DomainName,Tmp1Buffer);
   cp+=strlen(cp);

   /* UUCP envelope ("From ...")? Yes, skip further processing */
   if (!strnicmp(kp,"From ",5)) continue;

   /* No UUCP envelope. Search ':' (end of RFC 822 keyword) */
   if (!(lp=strchr(kp,':'))) {
    ErrLog(CorruptedHdrMsg);
    return(FALSE);
   }

   /* Skip ':' */
   klen=lp-kp;
   lp++;

   /* Skip additional white space */
   while ((*lp==' ') || (*lp=='\t')) lp++;
  }

  /* Interpret RFC 822 keyword. Mail & News RFC 822 fields */
  if (((klen==4)  && !strnicmp(kp,"From",4)) ||
      ((klen==10) && !strnicmp(kp,"Originator",10))) {
   /* From:, put original From: line into comment buffer */
   /* Originator: doesn't appear in the RFC822/1036 specs */
   cp=AddComment(cp,kp);
   DecodeRFC1342Line(lp);

   /* Get user name and address from From: line */
   GetAddress(lp,Tmp1Buffer,Tmp2Buffer,cp);
   msgtags[MSGTAGS_FROMNAME].ti_Data=(ULONG) Tmp1Buffer;
   msgtags[MSGTAGS_FROMADDR].ti_Data=(ULONG) Tmp2Buffer;

  } else if ((klen==4) && !strnicmp(kp,"Date",4)) {
   /* Date: */
   ULONG cdate;

   /* Set CreationDate field */
   msgtags[MSGTAGS_DATE].ti_Data=(ULONG) lp;

   /* Copy date/time string and convert it to Amiga date */
   strcpy(cp,lp);
   if (cdate=GetCDate(cp)) {
    msgtags[MSGTAGS_CDATE].ti_Tag =UMSTAG_WMsgCDate;
    msgtags[MSGTAGS_CDATE].ti_Data=cdate;
   }

  } else if ((klen==7) && !strnicmp(kp,"Subject",7)) {
   /* Subject: */
   DecodeRFC1342Line(lp);
   msgtags[MSGTAGS_SUBJECT].ti_Data=(ULONG) lp;

  } else if ((klen==8) && !strnicmp(kp,"Reply-To",8)) {
   /* Reply-To:, put original Reply-To: line into comment buffer */
   cp=AddComment(cp,kp);
   DecodeRFC1342Line(lp);

   /* Get user name and address from Reply-To: line */
   GetAddress(lp,Tmp3Buffer,Tmp4Buffer,cp);
   msgtags[MSGTAGS_REPLYNAME].ti_Data=(ULONG) Tmp3Buffer;
   msgtags[MSGTAGS_REPLYADDR].ti_Data=(ULONG) Tmp4Buffer;

  } else if ((klen==10) && !strnicmp(kp,"Message-ID",10)) {
   /* Message-ID: */
   char *refp,*closep;

   /* search opening AND closing braket */
   if ((refp=strchr(lp,'<')) && (closep=strchr(++refp,'>'))) {
    /* set string terminator */
    *closep='\0';

    /* complete message ID found */
    msgtags[MSGTAGS_MSGID].ti_Data=(ULONG) refp;
   } else
    /* No message ID found -> line into comment buffer */
    cp=AddComment(cp,kp);

  } else if ((klen==10) && !strnicmp(kp,"References",10)) {
   /* References: */
   char *refp,*closep;

   /* add complete References: line to comment buffer */
   cp=AddComment(cp,kp);

   /* search opening AND closing braket (from end of line) */
   if ((refp=strrchr(lp,'<')) && (closep=strchr(++refp,'>'))) {
    /* set string terminator */
    *closep='\0';

    /* complete ref-id found */
    msgtags[MSGTAGS_REFERID].ti_Data=(ULONG) refp;
   }

  } else if ((klen==12) && !strnicmp(kp,"Organization",12)) {
   /* Organization: */
   DecodeRFC1342Line(lp);
   msgtags[MSGTAGS_ORG].ti_Data=(ULONG) lp;

  } else if ((klen==12) && !strnicmp(kp,"Content-Type",12)) {
   /* Content-Type: */
   MIMEType=lp;

  } else if ((klen==14) && !strnicmp(kp,"Content-Length",14)) {
   /* Content-Length: */
   MIMELength=lp;

  } else if ((klen==25) && !strnicmp(kp,"Content-Transfer-Encoding",25)) {
   /* Content-Transfer-Encoding: */
   MIMEEncoding=lp;

   /* Mail only RFC 822 fields */
  } else if (mail) {

   if ((klen==8) && !strnicmp(kp,"X-Mailer",8)) {
    /* X-Mailer: (Mail only) */
    msgtags[MSGTAGS_MSGREADER].ti_Data=(ULONG) lp;

   } else if ((klen=11) && !strnicmp(kp,"In-Reply-To",11)) {
    /* In-Reply-To: (Mail only) */
    char *refp,*closep;

    /* Add line to comment buffer */
    cp=AddComment(cp,kp);

    /* search opening AND closing braket  */
    if ((refp=strchr(lp,'<')) && (closep=strchr(++refp,'>'))) {
     /* set string terminator */
     *closep='\0';

     /* complete message ID found */
     msgtags[MSGTAGS_REFERID].ti_Data=(ULONG) refp;
    }

   } else
    /* All other RFC 822 keywords are treated as comments... */
    cp=AddComment(cp,kp);

   /* News only RFC 822 fields */
  } else if ((klen==4) && !strnicmp(kp,"Path",4)) {
   /* Path: (News only) */
   /* Put path line (with our path name in front of it) into comment buffer */
   cp+=sprintf(cp,"Path: %s!%s\n",PathName,lp);

  } else if ((klen==7) && !strnicmp(kp,"Control",7)) {
   /* Control: (News only) */
   /* Add complete Control: line to comment buffer */
   cp=AddComment(cp,kp);

   /* This is a control message, only exporters should see it */
   msgtags[MSGTAGS_HIDE].ti_Data=1;
   control=TRUE;

   /* Cancel message? */
   if (!strnicmp(lp,"cancel",6)) {
    /* Yes, try to delete original message */
    char *refp,*closep;

    /* Search Msg-Id */
    if ((refp=strchr(lp+6,'<')) && (closep=strchr(++refp,'>'))) {
     UMSMsgNum orignum;

     /* Set string terminator */
     *closep='\0';

     /* Search original message */
     if (orignum=UMSSearchTags(Account,
                               UMSTAG_WMsgID,      refp,
                               UMSTAG_SearchQuick, TRUE,
                               TAG_DONE))
      /* Delete it */
      UMSDeleteMsg(Account,orignum);
    }
   }

  } else if ((klen==10) && !strnicmp(kp,"Newsgroups",10)) {
   /* Newsgroups: (News only) */
   /* Add complete Newsgroups: line to comment buffer */
   cp=AddComment(cp,kp);
   msgtags[MSGTAGS_GROUP].ti_Data=(ULONG) lp;

  } else if ((klen==11) && !strnicmp(kp,"Followup-To",11)) {
   /* Followup-To: (News only) */
   msgtags[MSGTAGS_FOLLOWUP].ti_Data=(ULONG) lp;

  } else if ((klen==12) && !strnicmp(kp,"Distribution",12)) {
   /* Distribution: (News only) */
   msgtags[MSGTAGS_DIST].ti_Data=(ULONG) lp;

  } else if ((klen==12) && !strnicmp(kp,"X-NewsReader",12)) {
   /* X-NewsReader: (News only) */
   msgtags[MSGTAGS_MSGREADER].ti_Data=(ULONG) lp;

  } else
   /* All other RFC 822 keywords are treated as comments... */
   cp=AddComment(cp,kp);
 }

 /* Set pointer to message text */
 msgtags[MSGTAGS_TEXT].ti_Data=(ULONG) ((*tp) ? ++tp : tp);

 /* MIME Message? */
 if (MIMEType || MIMEEncoding || MIMELength)
  /* Yes, try to decode it */
  if (DecodeRFC1341Message(MIMEType,MIMEEncoding,tp))
   /* Message decoded. Set MIME Attribute */
   msgtags[MSGTAGS_ATTRIBUTES].ti_Data=(ULONG) "MIME";
  else {
   /* Couldn't decode MIME message, copy headers to comment buffer */
   if (MIMEType)
    cp+=sprintf(cp,"Content-Type: %s\n",MIMEType);

   if (MIMEEncoding)
    cp+=sprintf(cp,"Content-Transfer-Encoding: %s\n",MIMEEncoding);

   if (MIMELength)
    cp+=sprintf(cp,"Content-Length: %s\n",MIMELength);
  }

 /* Append string terminator to comment buffer and set tag */
 *cp='\0';
 msgtags[MSGTAGS_COMMENT].ti_Data=(ULONG) MainBuffer;

 /* No or empty sender name? */
 if (!(cp=(char *) msgtags[MSGTAGS_FROMNAME].ti_Data) || (*cp=='\0')) {
  /* Yes --> set dummy name and address */
  msgtags[MSGTAGS_FROMNAME].ti_Data=(ULONG) "Unknown";
  msgtags[MSGTAGS_FROMADDR].ti_Data=(ULONG) "unknown@nowhere";
 }

 /* No or empty "Subject:" line? */
 if (!(cp=(char *) msgtags[MSGTAGS_SUBJECT].ti_Data) || (*cp=='\0'))
  /* Yes --> set dummy subject */
  msgtags[MSGTAGS_SUBJECT].ti_Data=(ULONG) "No subject";

 /* No or empty "Date:" line? */
 if (!(cp=(char *) msgtags[MSGTAGS_DATE].ti_Data) || (*cp=='\0'))
  msgtags[MSGTAGS_DATE].ti_Data=(ULONG) "Not specified";

 /* Control message? Yes -> write message to special group "rfc.control" */
 if (control) msgtags[MSGTAGS_GROUP].ti_Data=(ULONG) "rfc.control";

 /* Debugging */
 if (UMSDebugLevel>=2) {
  int i;
  struct TagItem *ti;

  /* Print all used tags */
  for (i=0, ti=msgtags; ti->ti_Tag!=TAG_DONE; i++, ti++)
   if (ti->ti_Data)
    switch (i) {
     case MSGTAGS_TEXT:    UMSDebugLog(4,"'%s'\n",ti->ti_Data);
                           break;
     case MSGTAGS_COMMENT: UMSDebugLog(3,"'%s'\n",ti->ti_Data);
                           break;
     case MSGTAGS_HIDE:    break;
     default:              UMSDebugLog(2,"'%s'\n",ti->ti_Data);
                           break;
    }
 }

 return(TRUE);
}
