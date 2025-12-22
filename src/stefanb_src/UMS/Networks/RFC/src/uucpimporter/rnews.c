/*
 * rnews.c  V1.0.02
 *
 * process incoming news files
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "uuxqt.h"

static const char CorruptMsg[]="corrupted news file '%s' (offset: %d)!\n";
static const char UMSErrMsg[]="(%s) file '%s' %s '%s' (offset: %d) "
                              "UMS-Error: %d - %s\n";
static const char UnknownID[]="<unknown>";

/* Translate CR-LF to LF */
ULONG TranslateCRLF(char *buf)
{
 char *rp = buf;
 char *wp = buf;
 char c;
 BOOL cr  = FALSE; /* Last character was not a CR */

 /* Scan buffer */
 while (c = *rp++) {

  /* CR found? */
  if (c == '\r')

   /* Yes */
   cr = TRUE;

  else {

   /* CR-LF? */
   if ((c == '\n') && cr) wp--; /* Yes, suppress CR */

   cr = FALSE;
  }

  /* Copy character */
  *wp++ = c;
 }

 /* Add string terminator */
 *wp = '\0';

 /* Return new size */
 return(wp - buf);
}

/* Print out error */
int LogUMSError(char *part, char *file, char *text, char *id, ULONG offset)
{
 ULONG errnum = UMSErrNum(Account);

 /* Check if MsgId is valid */
 if (!id) id = UnknownID;

 /* No dupe error or shall we log dupes? */
 if ((errnum != UMSERR_Dupe) || LogDupes)
  /* Log to error log */
  UMSRFCLog(URData, UMSErrMsg, part, file, text, id, offset, errnum,
                               UMSErrTxt(Account));

 /* Dupe? Should we keep dupes? */
 if ((errnum == UMSERR_Dupe) && !KeepDupes)
  return(RETURN_OK);   /* No, delete dupes (pretend all is OK!) */

 /* Non-fatal errors? */
 if ((errnum < UMSERR_ServerTerminated) && (errnum != UMSERR_FsFull))
  return(RETURN_WARN); /* Return warning level */

 /* All other errors are fatal! */
 return(RETURN_FAIL);
}

int ReceiveNewsFile(char *newsfile, char *newsbuf, ULONG size)
{
 struct TagItem *tags = URData->urd_NewsTags;
 char *np             = newsbuf;
 LONG count;
 int rc               = RETURN_OK;

 /* Translate CR-LF to LF. We have to do this first, because   */
 /* RFC 1036 states that for the article length the EOLs are   */
 /* counted as ONE byte even if they are represented as CR-LF! */
 /*
  * ...but in the real world no-one seems to care about that.
  * Instead they always use the real article file length which
  * of course includes CR-LF as 2 bytes.
  *
  * *SIGH* I don't see a real solution for this mess.
  *
  * size = TranslateCRLF(newsbuf);
  *
  * The translation is now done for each article AFTER the
  * length has been read. (see below)
  *
  */

 /* Add '#' after last article */
 newsbuf[size] = '#';

 /* Process news file */
 count = size;
 while ((rc != RETURN_FAIL) && (count > 0)) {
  char *tp;

  /* Check for string "#! rnews " */
  if (strncmp(np, "#! rnews ", 9) != 0) {
   UMSRFCLog(URData, CorruptMsg, newsfile, np - newsbuf);
   rc = RETURN_WARN;
   break;
  }

  /* Skip string */
  np    += 9;
  count -= 9;

  /* Get news article length and pointer to article text */
  {
   ULONG artlen;

   /* Get article length */
   artlen = strtol(np, &tp, 10);

   /* Sanity check */
   if (*tp != '\n') {
    UMSRFCLog(URData, CorruptMsg, newsfile, tp - newsbuf);
    rc = RETURN_WARN;
    break;
   }

   /* Correct pointers */
   tp++;
   count -= tp - np + artlen;
   np     = tp;               /* Beginning of article text      */
   tp    += artlen;           /* Beginning of next command line */
  }

  /* Sanity check */
  if (*tp != '#') {
   UMSRFCLog(URData, CorruptMsg, newsfile, tp - newsbuf);
   rc = RETURN_WARN;
   break;
  }

  /* Append string terminator */
  *tp = '\0';

  /* Translate CRLF in one article (see comments above) */
  TranslateCRLF(np);

  /* Process RFC Header */
  if (UMSRFCReadMessage(URData, np, FALSE, FALSE)) {
   char *nextgroup = (char *) tags[UMSRFC_TAGS_GROUP].ti_Data;

   /* Group field valid? */
   if (nextgroup) {
    UMSMsgNum oldnum = 0;    /* linked (crossposted) messages */
    BOOL hidden      = TRUE; /* detect 'hidden' messages */

    do {
     char *group      = nextgroup;
     UMSMsgNum newnum;

     /* Scan newsgroup line for ',' */
     if (nextgroup = strchr(nextgroup, ',')) {
      char c;

      /* another group -> remove ',' and set string terminator */
      *nextgroup = '\0';

      /* Skip white space */
      while ((c = *++nextgroup) && ((c == ' ') || (c == '\t')));
     }

     /* Group name valid? */
     if (*group != '\0')

      /* Yes, write message, save message number */
      if (newnum = UMSRFCPutNewsMessage(URData, group, oldnum)) {

       /* All OK! Crossposting? */
       if (oldnum)
        CrossPostGood();
       else
        NewsGood();

       /* Save message number */
       oldnum = newnum;

       /* Message written */
       hidden = FALSE;

      } else if (UMSErrNum(Account) == UMSERR_NoWriteAccess)
       /* Error in crossposting (No write access) --> Ignore! */
       CrossPostBad();

      else {
       /* Real error! */
       rc = LogUMSError("News", newsfile, "msg id",
                        (char *) tags[UMSRFC_TAGS_MSGID].ti_Data,
                        np - newsbuf);
       NewsBad();
       hidden    = FALSE;   /* Suppress warning message */
       nextgroup = NULL; /* This breaks the loop! */
      }

     /* Repeat as long as news groups specified */
    } while (nextgroup);

    /* Hidden message? */
    if (hidden) {
     /* Message couldn't be written to ANY group */
     char *id = (char *) tags[UMSRFC_TAGS_MSGID].ti_Data;

     /* Check ID */
     if (!id) id = UnknownID;

     /* Write warning message */
     UMSRFCLog(URData, "(News) file '%s' msg id '%s' (offset: %d) "
               "Couldn't post message, check WriteAccess pattern!\n",
               newsfile, id, np - newsbuf);
     rc = RETURN_WARN;
    }

   } else {
    UMSRFCLog(URData, "Missing 'Newsgroups:' field (offset: %d)!\n",
              np - newsbuf);
    rc = RETURN_WARN;
   }
  }

  /* Next article */
  np  = tp;
  *np = '#'; /* Add # again */
 }

 return(rc);
}
