/*
 * rnews.c  V0.8.04
 *
 * process incoming news files
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "uuxqt.h"

/* Tag array for news article */
static struct TagItem NewsTags[]={                            /* Index */
                                  UMSTAG_WSubject,      NULL, /*  0 */
                                  UMSTAG_WFromName,     NULL, /*  1 */
                                  UMSTAG_WFromAddr,     NULL, /*  2 */
                                  UMSTAG_WReplyName,    NULL, /*  3 */
                                  UMSTAG_WReplyAddr,    NULL, /*  4 */
                                  UMSTAG_WCreationDate, NULL, /*  5 */
                                  UMSTAG_WMsgCDate,     NULL, /*  6 */
                                  UMSTAG_WMsgID,        NULL, /*  7 */
                                  UMSTAG_WReferID,      NULL, /*  8 */
                                  UMSTAG_WOrganization, NULL, /*  9 */
                                  UMSTAG_WNewsreader,   NULL, /* 10 */
                                  UMSTAG_WMsgText,      NULL, /* 11 */
                                  UMSTAG_WAttributes,   NULL, /* 12 */
                                  UMSTAG_WComments,     NULL, /* 13 */
                                  UMSTAG_WHardLink,     NULL, /* 14 */
                                  UMSTAG_WGroup,        NULL, /* 15 */
                                  UMSTAG_WReplyGroup,   NULL, /* 16 */
                                  UMSTAG_WDistribution, NULL, /* 17 */
                                  UMSTAG_WHide,         NULL, /* 18 */
                                  TAG_DONE
                                 };

static const char CorruptMsg[]="corrupted news file '%s' (offset: %d)!\n";
static const char UMSErrMsg[]="(%s) file '%s' %s '%s' (offset: %d) "
                              "UMS-Error: %d - %s\n";
static const char UnknownID[]="<unknown>";

/* Print out error */
int LogUMSError(char *part, char *file, char *text, char *id, ULONG offset)
{
 ULONG errnum=UMSErrNum(Account);
 char *errtxt;

 /* Check if MsgId is valid */
 if (!id) id=UnknownID;

 /* No error?!?!? */
 if (errnum==UMSERR_OK) {
  /* Must be a dupe... */
  errnum=UMSERR_Dupe;
  errtxt="dupe";
 }
 else
  errtxt=UMSErrTxt(Account);

 /* Log to error log */
 ErrLog(UMSErrMsg,part,file,text,id,offset,errnum,errtxt);

 /* Dupe? Should we keep dupes? */
 if ((errnum==UMSERR_Dupe) && !KeepDupes)
  return(RETURN_OK);   /* No, delete dupes (pretend all is OK!) */

 /* Non-fatal errors? */
 if ((errnum<UMSERR_ServerTerminated) && (errnum!=UMSERR_FsFull))
  return(RETURN_WARN); /* Return warning level */

 /* All other errors are fatal! */
 return(RETURN_FAIL);
}

int ReceiveNewsFile(char *newsfile, char *newsbuf, ULONG size)
{
 char *np=newsbuf;
 LONG count;
 int rc=RETURN_OK;

 /* Add '#' after last article */
 newsbuf[size]='#';

 /* Process news file */
 count=size;
 while ((rc!=RETURN_FAIL) && (count>0)) {
  char *tp;

  /* Check for string "#! rnews " */
  if (strncmp(np,"#! rnews ",9)) {
   ErrLog(CorruptMsg,newsfile,np-newsbuf);
   rc=RETURN_WARN;
   break;
  }

  /* Skip string */
  np+=9;
  count-=9;

  /* Get news article length and pointer to article text */
  {
   ULONG artlen;

   /* Get article length */
   artlen=strtol(np,&tp,10);

   UMSDebugLog(1,"processing article, length %ld",artlen);

   /* Sanity check */
   if (*tp!='\n') {
    ErrLog(CorruptMsg,newsfile,tp-newsbuf);
    rc=RETURN_WARN;
    break;
   }

   /* Correct pointers */
   tp++;
   count-=tp-np+artlen;
   np=tp;      /* Beginning of article text */
   tp+=artlen; /* Beginning of next command line */
  }

  /* Sanity check */
  if (*tp!='#') {
   ErrLog(CorruptMsg,newsfile,tp-newsbuf);
   rc=RETURN_WARN;
   break;
  }

  /* Append string terminator */
  *tp='\0';

  /* Filter CRs? */
  if (FilterCR) {
   char *rp=np,*wp=np;
   char c;

   /* Scan message */
   while (c=*rp++)
    /* CR found? */
    if (c!='\r') *wp++=c; /* No, copy character */

   /* Add string terminator */
   *wp='\0';
  }

  /* Process RFC Header */
  if (ScanRFCMessage(np,NewsTags,FALSE)) {
   char *nextgroup=(char *) NewsTags[MSGTAGS_GROUP].ti_Data;

   /* Group field valid? */
   if (nextgroup) {
    UMSMsgNum oldnum=0; /* linked (crossposted) messages */
    BOOL hidden=TRUE;   /* detect 'hidden' messages */

    do {
     UMSMsgNum newnum;

     /* Linked message? */
     if (oldnum) {
      NewsTags[MSGTAGS_LINK].ti_Tag=UMSTAG_WHardLink;
      NewsTags[MSGTAGS_LINK].ti_Data=oldnum;
     } else
      /* Default: no crossposting */
      NewsTags[MSGTAGS_LINK].ti_Tag=TAG_IGNORE;

     /* Scan newsgroup line for ',' */
     if (nextgroup=strchr(nextgroup,',')) {
      char c;

      /* another group -> remove ',' and set string terminator */
      *nextgroup='\0';

      /* Skip white space */
      while ((c=*++nextgroup) && ((c==' ') || (c=='\t')));
     }

     /* Group name valid? */
     if (*((char *) NewsTags[MSGTAGS_GROUP].ti_Data)!='\0')
      /* Yes, write message, save message number */
      if (newnum=WriteUMSMsg(Account,NewsTags)) {
       /* All OK! Crossposting? */
       if (oldnum)
        CrossPostGood();
       else
        NewsGood();

       /* Save message number */
       oldnum=newnum;

       /* Message written */
       hidden=FALSE;

      } else if (UMSErrNum(Account) == UMSERR_NoWriteAccess)
       /* Error in crossposting (No write access) --> Ignore! */
       CrossPostBad();

      else {
       /* Real error! */
       rc=LogUMSError("News",newsfile,"msg id",
                      (char *) NewsTags[MSGTAGS_MSGID].ti_Data,np-newsbuf);
       NewsBad();
       hidden=FALSE;   /* Suppress warning message */
       nextgroup=NULL; /* This breaks the loop! */
      }

     /* Get next group */
     if (nextgroup) NewsTags[MSGTAGS_GROUP].ti_Data=(ULONG) nextgroup;

     /* Repeat as long as news groups specified */
    } while (nextgroup);

    /* Hidden message? */
    if (hidden) {
     /* Message couldn't be written to ANY group */
     char *id = (char *) NewsTags[MSGTAGS_MSGID].ti_Data;

     /* Check ID */
     if (!id) id=UnknownID;

     /* Write warning message */
     ErrLog("(News) file '%s' msg id '%s' (offset: %d) "
            "Couldn't post message, check WriteAccess pattern!\n",
            newsfile,id,np-newsbuf);
     rc=RETURN_WARN;
    }

   } else {
    ErrLog("Missing 'Newsgroups:' field (offset: %d)!\n",np-newsbuf);
    rc=RETURN_WARN;
   }
  }

  /* Next article */
  np=tp;
  *np='#'; /* Add # again */
 }

 return(rc);
}
