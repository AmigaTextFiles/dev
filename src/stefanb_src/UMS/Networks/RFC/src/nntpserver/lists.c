/*
 * lists.c V1.0.03
 *
 * UMS NNTP (server) handle LIST/NEWNEWS/NEWGROUPS commands
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsnntpd.h"

/* Tag lists for HandleLISTCommand()
 *
 * Layout for local bits:
 *
 *  Bit 0 = 1: msg is a mail, we don't have ViewAccess or it was already
 *             in selected group
 *  Bit 1 = 1: we don't have view access to this message
 *  Bit 2 = 1: msg belongs to current group
 */
static const struct TagItem ClearBits[] = {
 UMSTAG_SelMask,       0,
 UMSTAG_SelMatch,      0,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelUnset,      7,
 TAG_DONE
};

static const struct TagItem SetIfNoViewAccess[] = {
 UMSTAG_SelMask,       UMSUSTATF_ViewAccess,
 UMSTAG_SelMatch,      0,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelSet,        3,
 TAG_DONE
};

static const struct TagItem SetIfMail[] = {
 UMSTAG_WGroup,        (ULONG) "",
 UMSTAG_SelQuick,      TRUE,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelSet,        1,
 TAG_DONE
};

/* Tag lists for HandleNEWNEWSCommand()
 *
 * Layout for local bits:
 *
 *  Bit 0 = 1: msg is younger, we have ViewAccess and it is a news article
 *  Bit 1 = 1: msg has matching group field
 *  Bit 2 = 1: msg has matching distribution field
 */
static const struct TagItem WithDistributions[] = {
 UMSTAG_SelMask,       0,
 UMSTAG_SelMatch,      0,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelUnset,      7,
 TAG_DONE
};

static const struct TagItem NoDistributions[] = {
 UMSTAG_SelMask,       0,
 UMSTAG_SelMatch,      0,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelSet,        4,
 UMSTAG_SelUnset,      3,
 TAG_DONE
};

static const struct TagItem ResetIfNoViewAccess[] = {
 UMSTAG_SelMask,       UMSUSTATF_ViewAccess,
 UMSTAG_SelMatch,      0,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelUnset,      7,
 TAG_DONE
};

static const struct TagItem ResetIfMail[] = {
 UMSTAG_WGroup,        (ULONG) "",
 UMSTAG_SelQuick,      TRUE,
 UMSTAG_SelWriteLocal, TRUE,
 UMSTAG_SelUnset,      7,
 TAG_DONE
};

/* Local data */
static struct ClockData ClockData;

/* Handle LIST command */
BOOL HandleLISTCommand(struct UMSRFCData *urd, char *args)
{
 BOOL rc = TRUE;

 /* Check for arguments                                             */
 /* NOTE: Arguments to the LIST command is an extension to RFC 977! */
 if (!*args || (stricmp(args, "ACTIVE") == 0)) {
  /* List "active" file */
  UMSAccount Account = urd->urd_Account;
  UMSMsgNum MsgNum   = 0;
  char *buf          = LineBuffer;
  char *Group;

  /* Send status response */
  Send(NNTPDSocket, INTTOSTR(NNTP_LIST_OF_GROUPS)
                     " list of newsgroups follows\r\n", 32, 0);

  /* Reset local bits */
  UMSSelect(Account, ClearBits);

  /* Set local bits 0 & 1 on all messages with no ViewAccess */
  UMSSelect(Account, SetIfNoViewAccess);

  /* Set local bit 0 on all mail messages */
  UMSSelect(Account, SetIfMail);

  /* For each group */
  while (TRUE) {
   ULONG n;

   /* Search next group */
   if ((MsgNum = UMSSearchTags(Account, UMSTAG_SearchLast,      MsgNum,
                                        UMSTAG_SearchDirection, 1,
                                        UMSTAG_SearchLocal,     TRUE,
                                        UMSTAG_SearchMask,      1,
                                        UMSTAG_SearchMatch,     0,
                                        TAG_DONE)) == 0)
    break; /* All groups found -> leave loop */

   /* Get group name */
   if (!UMSReadMsgTags(Account, UMSTAG_RMsgNum,  MsgNum,
                                UMSTAG_RGroup,  &Group,
                                TAG_DONE))
    break; /* ERROR! */

   /* Set local bits 0 & 2 on all messages in this group */
   UMSSelectTags(Account, UMSTAG_WGroup,        Group,
                          UMSTAG_SelQuick,      TRUE,
                          UMSTAG_SelStart,      MsgNum,
                          UMSTAG_SelWriteLocal, TRUE,
                          UMSTAG_SelSet,        5,
                          TAG_DONE);

   /* Count messages in group (Local bit 1 = 0 and Local bit 2 = 1 */
   n = UMSSelectTags(Account, UMSTAG_SelReadLocal,  TRUE,
                              UMSTAG_SelMask,       6,
                              UMSTAG_SelMatch,      4,
                              UMSTAG_SelStart,      MsgNum,
                              UMSTAG_SelWriteLocal, TRUE,
                              UMSTAG_SelUnset,      4,
                              TAG_DONE);


   /* Create group information */
   n = sprintf(buf, "%s %d 1 y\r\n", Group, n);

   /* Send group information (Check for write errors) */
   if (Send(NNTPDSocket, buf, n, 0) < n) {
    rc = FALSE;
    break;
   }

   /* Free UMS message */
   UMSFreeMsg(Account, MsgNum);
  }

  /* Send end marker */
  Send(NNTPDSocket, ".\r\n", 3, 0);

  /* Parameter OVERVIEW.FMT for XOVER support */
 } else if (stricmp(args, "OVERVIEW.FMT") == 0) {

  /* Only mandatory fields, No optional fields are available*/
  Send(NNTPDSocket, INTTOSTR(NNTP_LIST_OF_GROUPS)
                     " order of fields in XOVER responses follows\r\n"
                     "Subject:\r\n"
                     "From:\r\n"
                     "Date:\r\n"
                     "Message-ID:\r\n"
                     "References:\r\n"
                     "Bytes:\r\n"
                     "Lines:\r\n"
                     ".\r\n",
                     117, 0);

  /* Other arguments are currently not supported */
 } else if ((stricmp(args, "NEWSGROUPS") == 0) ||
            (stricmp(args, "DISTRIBUTIONS") == 0)) {

  Send(NNTPDSocket, INTTOSTR(NNTP_PROGRAM_FAULT)
                     " parameter not supported\r\n",
                     29, 0);

 } else
  /* Unknow argument */
  Send(NNTPDSocket, INTTOSTR(NNTP_SYNTAX_ERROR)
                     " unknown parameter\r\n", 23, 0);

 return(rc);
}

/* Error codes */
#define NEWNEWS_OK      0
#define NEWNEWS_SYNTAX  1
#define NEWNEWS_FAILURE 2
#define NEWNEWS_ABORT   3

/* Number of arguments for NEWNEWS/NEWGROUPS */
#define MAXTOKENS 5

/* Tokenize argument line */
static void Tokenize(char *args, char **tokens)
{
 int i;
 char next = ' ';

 /* Clear token array */
 for (i = 0; i < MAXTOKENS; i++) tokens[i] = NULL;

 /* For each token entry */
 args--;
 for (i = 0; i < MAXTOKENS; i++) {

  /* Another token? */
  if (next == '\0') break; /* No */

  /* Skip white space */
  while ((next = *++args) && ((next == ' ') || (next == '\t')));

  /* Another token? */
  if (next == '\0') break; /* No */

  /* Save token pointer */
  tokens[i] = args;

  /* Skip non-white space */
  while ((next = *++args) && (next != ' ') && (next != '\t'));

  /* Set string terminator */
  *args = '\0';
 }
}

/* Retrieve date from arguments */
static BOOL GetDate(struct ClockData *cd, char *token)
{
 /* Token valid? */
 if (token) {

  /* Token 6 characters long? */
  if (strlen(token) == 6) {
   LONG date;

   /* Convert string to number */
   date = strtol(token, NULL, 10);

   DEBUGLOG(kprintf("Date1: %ld\n", date);)

   /* First sanity check */
   if (date > 0) {

    /* Calculate year, month, and day from number */
    cd->year   = date / 10000;
    date      %= 10000;
    cd->month  = date / 100;
    cd->mday   = date % 100;

    DEBUGLOG(kprintf("Date2: %ld %ld %ld\n", cd->year, cd->month, cd->mday);)

    /* Second sanity check */
    if ((cd->month >= 1) && (cd->month <= 12) &&
        (cd->mday  >= 1) && (cd->mday  <= 31)) {

     /* A little hack for the year 2000. UNIX epoch starts 1970 */
     cd->year += (cd->year < 70) ? 2000 : 1900;

     return(TRUE);
    }
   }
  }
 }
 return(FALSE);
}

/* Retrieve time from arguments */
static BOOL GetTime(struct ClockData *cd, char *token)
{
 /* Token valid? */
 if (token) {

  /* Token 6 characters long? */
  if (strlen(token) == 6) {
   LONG time;

   /* Convert string to number */
   time = strtol(token, NULL, 10);

   DEBUGLOG(kprintf("Time1: %ld\n", time);)

   /* First sanity check */
   if (time >= 0) {

    /* Calculate year, month, and day from number */
    cd->hour  = time / 10000;
    time     %= 10000;
    cd->min   = time / 100;
    cd->sec   = time % 100;

    DEBUGLOG(kprintf("Time2: %ld %ld %ld\n", cd->hour, cd->min, cd->sec);)

    /* Second sanity check */
    if ((cd->hour < 25) && (cd->min < 60) && (cd->sec < 60)) return(TRUE);
   }
  }
 }
 return(FALSE);
}

/* Handle NEWNEWS command */
BOOL HandleNEWNEWSCommand(struct UMSRFCData *urd, char *args)
{
 struct ClockData *cd     = &ClockData;
 char *tokens[MAXTOKENS];
 ULONG error              = NEWNEWS_SYNTAX;

 /* Tokenize arguments */
 Tokenize(args, tokens);

 DEBUGLOG(kprintf("Tokens: '%s' '%s' '%s' '%s' '%s'\n",
                    tokens[0], tokens[1], tokens[2], tokens[3], tokens[4]);)

 /* Newsgroups specified? (1st token, mandantory) */
 if (tokens[0]) {

  /* Retrieve date from arguments (2nd token, mandantory) */
  if (GetDate(cd, tokens[1])) {

   /* Retrieve time from arguments (3rd token, mandantory) */
   if (GetTime(cd, tokens[2])) {
    ULONG AmigaTime;

    DEBUGLOG(kprintf("Time/Date: %02ld:%02ld:%02ld %02ld-%02ld-%04ld\n",
             cd->hour, cd->min, cd->sec, cd->mday, cd->month, cd->year);)

    /* Transform to Amiga date */
    if (AmigaTime = CheckDate(cd)) {
     UMSAccount Account = urd->urd_Account;
     char *distributions;

     DEBUGLOG(kprintf("Amiga time: %ld\n", AmigaTime);)

     /* 4th token == "GMT"? */
     if ((distributions = tokens[3]) && (stricmp(distributions, "GMT") == 0)) {
      /* Yes, specified time is for GMT, add GMT offset */
      AmigaTime += GMTOffset;

      DEBUGLOG(kprintf("GMT time: %ld\n", AmigaTime);)

      /* 5th token specifies distributions */
      distributions = tokens[4];
     }

     DEBUGLOG(kprintf("Distributions1: '%s'\n", distributions);)

     /* Check distributions (must be specified in angle brackets "<...>") */
     if (distributions) {

      /* Check for opening bracket */
      if (*distributions++ == '<') {
       char *ep = distributions + strlen(distributions) - 1;

       /* Check for closing bracket */
       if (*ep == '>') {

        /* All OK, set string terminator and reset error flag */
        *ep   = '\0';
        error = NEWNEWS_OK;

        DEBUGLOG(kprintf("Distributions2: '%s'\n", distributions);)
       }
      }
     } else
      /* Reset error flag */
      error = NEWNEWS_OK;

     /* All OK? */
     if (error == NEWNEWS_OK) {

      /* Yes, set initial local bit configuration. Distributions specified? */
      if (distributions)
       UMSSelect(Account, WithDistributions);
      else
       UMSSelect(Account, NoDistributions);

      /* Set Local Bit 0 if younger than AmigaTime */
#ifdef DEBUG
      { ULONG count =
#endif
      UMSSelectTags(Account, UMSTAG_SelDate,       AmigaTime,
                             UMSTAG_SelWriteLocal, TRUE,
                             UMSTAG_SelSet,        1,
                             TAG_DONE);

      DEBUGLOG(kprintf("Selected by   Date        : %ld\n", count);)

      /* Reset Local Bit 0, 1, 2 on all messages with no ViewAccess */
#ifdef DEBUG
      count =
#endif
      UMSSelect(Account, ResetIfNoViewAccess);

      DEBUGLOG(kprintf("Deselected by NoViewAccess: %ld\n", count);)

      /* Reset Local Bit 0, 1, 2 on all mail messages */
#ifdef DEBUG
      count =
#endif
      UMSSelect(Account, ResetIfMail);

      DEBUGLOG(kprintf("Deselected by Mail        : %ld\n", count);)
#ifdef DEBUG
      }
#endif

      /*
       * Current status:
       *
       *  Local Bit 0 == 1 if message is younger than AmigaTime AND
       *                              ViewAccess == TRUE        AND
       *                              Group      != ""
       *
       *  Only messages with Local Bit 0 == 1 are examined in further scans
       */

      /* Convert newsgroups pattern list to UMS multiline config var */
      {
       char *nextgroup = tokens[0];

       /* Scan for ',', set '\n' */
       while (nextgroup = strchr(nextgroup, ',')) *nextgroup++ = '\n';
      }

      /* Create temporary local UMS config variable */
      {
       char *varname = OutBuffer;

       sprintf(varname, "temp.%x", FindTask(NULL));
       if (UMSWriteConfigTags(Account, UMSTAG_CfgName,  varname,
                                       UMSTAG_CfgData,  tokens[0],
                                       UMSTAG_CfgLocal, TRUE,
                                       TAG_DONE)) {
        UMSMsgNum msgnum = 0;

        /* Scan for messages with Local Bit 0 == 1           */
        /* Skip already selected messages (Local Bit 1 == 1) */
        while (msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      msgnum,
                                               UMSTAG_SearchDirection, 1,
                                               UMSTAG_SearchLocal,     TRUE,
                                               UMSTAG_SearchMask,      3,
                                               UMSTAG_SearchMatch,     1,
                                               TAG_DONE)) {
         char *group;

         /* Read message */
         if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,  msgnum,
                                     UMSTAG_RGroup,  &group,
                                     TAG_DONE)) {

           DEBUGLOG(kprintf("Match group: %s, MsgNum: %ld\n", group, msgnum);)

           /* Match group name with pattern list */
           if (UMSMatchConfigTags(Account, UMSTAG_MatchName,   varname,
                                           UMSTAG_MatchString, group,
                                           TAG_DONE))

            /* MATCHED, set local bit 1 on all messages in group */
#ifdef DEBUG
           { ULONG count;
             kprintf("Group matched\n");
             count =
#endif
            UMSSelectTags(Account, UMSTAG_WGroup,        group,
                                   UMSTAG_SelQuick,      TRUE,
                                   UMSTAG_SelStart,      msgnum,
                                   UMSTAG_SelWriteLocal, TRUE,
                                   UMSTAG_SelSet,        2,
                                   TAG_DONE);
#ifdef DEBUG
             kprintf("Selected: %ld\n", count); }
#endif

           else
            /* NOT MATCHED, reset Local Bit 0, 1, 2 on all messages in group */
#ifdef DEBUG
           { ULONG count;
             kprintf("Group not matched\n");
             count =
#endif
            UMSSelectTags(Account, UMSTAG_WGroup,        group,
                                   UMSTAG_SelQuick,      TRUE,
                                   UMSTAG_SelStart,      msgnum,
                                   UMSTAG_SelWriteLocal, TRUE,
                                   UMSTAG_SelUnset,      7,
                                   TAG_DONE);
#ifdef DEBUG
             kprintf("Deselected: %ld\n", count); }
#endif

           /* Free message */
           UMSFreeMsg(Account, msgnum);

         } else {
          /* Error, leave loop */
          error = NEWNEWS_FAILURE;
          break;
         }

         /* Check for fatal error */
         if (UMSErrNum(Account) >= UMSERR_ServerTerminated) {
          error = NEWNEWS_FAILURE;
          break;
         }
        }

        /* Delete config variable */
        UMSWriteConfigTags(Account, UMSTAG_CfgName,  varname,
                                    UMSTAG_CfgLocal, TRUE,
                                    TAG_DONE);
       } else
        /* Error */
        error = NEWNEWS_FAILURE;
      }

      /*
       * Current status:
       *
       *  Local Bit 0 == 1 if message is younger than AmigaTime AND
       *                              ViewAccess == TRUE        AND
       *                              Group      != ""
       *
       *  Local Bit 1 == 1 if message has matching group field
       *
       *  Only messages with Local Bit 0, 1 == 1 are examined in further scans
       */

      /* All OK? */
      if (error == NEWNEWS_OK) {

       /* Match distribution field */
       if (distributions) {
        char *nextdist = distributions;

        /* For each distribution */
        do {
         char *dist = nextdist;

         /* Scan for ',', set string terminator */
         if (nextdist = strchr(nextdist, ',')) *nextdist++ = '\0';

         /* Distribution valid? */
         if ((*dist != '\0') &&

         /* Yes, set Local Bit 2 on all messages with matching distribution */
         /* (Using index)                                                   */
             (UMSSelectTags(Account, UMSTAG_WDistribution, dist,
                                     UMSTAG_SelQuick,      TRUE,
                                     UMSTAG_SelWriteLocal, TRUE,
                                     UMSTAG_SelSet,        4,
                                     TAG_DONE) == 0) &&

         /* Index missing? */
             (UMSErrNum(Account) == UMSERR_MissingIndex)) {

           /* Yes, start a SLOW search! */
           UMSMsgNum msgnum = 0;

           DEBUGLOG(kprintf("Index for distribution field missing,"
                            " starting slow search for '%s'!\n", dist);)

           /* Scan for messages with Local Bit 0, 1 == 1        */
           /* Skip already selected messages (Local Bit 2 == 1) */
           while (msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      msgnum,
                                                  UMSTAG_SearchDirection, 1,
                                                  UMSTAG_SearchLocal,     TRUE,
                                                  UMSTAG_SearchMask,      7,
                                                  UMSTAG_SearchMatch,     3,
                                                  TAG_DONE)) {
            char *msgdist;

            /* Read message */
            if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,        msgnum,
                                        UMSTAG_RDistribution, &msgdist,
                                        TAG_DONE)) {

             DEBUGLOG(kprintf("Match distribution: '%s', MsgNum: %ld\n",
                              msgdist, msgnum);)

             /* Does distribution match? (No distribution means no match) */
             if (msgdist && (stricmp(dist, msgdist) == 0)) {

              /* MATCHED */
              UMSMsgNum msgnum1 = msgnum;

              DEBUGLOG(kprintf("Distribution matched\n");)

              /* Set Local Bit 2 for all messages with this dist */
              do {

               DEBUGLOG(kprintf("Selected: %ld, Error: %ld\n", msgnum1,
                                                               UMSErrNum(Account));)

               UMSSelectTags(Account, UMSTAG_SelMsg,        msgnum1,
                                      UMSTAG_SelWriteLocal, TRUE,
                                      UMSTAG_SelSet,        4,
                                      TAG_DONE);

               /* Search next message with same distribution and Local Bit */
               /* 0, 1 == 1. Skip already selected messages (Bit 2 == 1)   */
              } while (msgnum1 = UMSSearchTags(Account,
                                  UMSTAG_SearchLast,      msgnum1,
                                  UMSTAG_SearchDirection, 1,
                                  UMSTAG_SearchLocal,     TRUE,
                                  UMSTAG_SearchMask,      7,
                                  UMSTAG_SearchMatch,     3,
                                  UMSTAG_WDistribution,   dist,
                                  UMSTAG_SearchPattern,   0,
                                  TAG_DONE));

             } else {

              /* NOT MATCHED */
              UMSMsgNum msgnum1 = msgnum;

              DEBUGLOG(kprintf("Distribution not matched\n");)

              /* Check for msgdist == NULL and set msgdist = ""? */
              /* if (msgdist == NULL) msgdist = ""; */

              /* Reset Local Bit 0, 1, 2 for all messages with this dist */
              do {

               DEBUGLOG(kprintf("Deselected: %ld, Error: %ld\n", msgnum1,
                                                                 UMSErrNum(Account));)

               UMSSelectTags(Account, UMSTAG_SelMsg,        msgnum1,
                                      UMSTAG_SelWriteLocal, TRUE,
                                      UMSTAG_SelUnset,      7,
                                      TAG_DONE);

               /* Search next message with same distribution and Local Bit */
               /* 0, 1 == 1. Skip already selected messages (Bit 2 == 1)   */
              } while (msgnum1 = UMSSearchTags(Account,
                                  UMSTAG_SearchLast,      msgnum1,
                                  UMSTAG_SearchDirection, 1,
                                  UMSTAG_SearchLocal,     TRUE,
                                  UMSTAG_SearchMask,      7,
                                  UMSTAG_SearchMatch,     3,
                                  UMSTAG_WDistribution,   msgdist,
                                  UMSTAG_SearchPattern,   0,
                                  TAG_DONE));

             }

             /* Free message */
             UMSFreeMsg(Account, msgnum);
            }
           }
          }

         /* Check for fatal error */
         if (UMSErrNum(Account) >= UMSERR_ServerTerminated) {
          error = NEWNEWS_FAILURE;
          break;
         }

        /* Next distribution */
        } while (nextdist);
       }

       /*
        * Current status:
        *
        *  Local Bit 0 == 1 if message is younger than AmigaTime AND
        *                              ViewAccess == TRUE        AND
        *                              Group      != ""
        *
        *  Local Bit 1 == 1 if message has matching group field
        *
        *  Local Bit 2 == 1 if message has matching distribution field
        *                              (if no distributions are specified, then
        *                              all messages have Local Bit 2 == 1)
        *
        *  Only msgs with Local Bit 0, 1, 2 == 1 are examined in further scans
        */

       /* All OK? */
       if (error == NEWNEWS_OK) {
        UMSMsgNum msgnum = 0;
        char *buf        = LineBuffer;

        /* Send MsgID list */
        Send(NNTPDSocket, INTTOSTR(NNTP_LIST_OF_NEW_MSGIDS)
                           " list of new articles follows\r\n", 34, 0);

        /* Scan for Local Bit 0, 1, 2 == 1 */
        while (msgnum = UMSSearchTags(Account, UMSTAG_SearchLast,      msgnum,
                                               UMSTAG_SearchDirection, 1,
                                               UMSTAG_SearchLocal,     TRUE,
                                               UMSTAG_SearchMask,      7,
                                               UMSTAG_SearchMatch,     7,
                                               TAG_DONE)) {
         char *msgid;
         UMSMsgNum hardlink;

         /* Read message ID & hardlink */
         if (UMSReadMsgTags(Account, UMSTAG_RMsgNum,    msgnum,
                                     UMSTAG_RMsgID,    &msgid,
                                     UMSTAG_RHardLink, &hardlink,
                                     TAG_DONE)) {
           ULONG len;

           /* Create text response line */
           len = sprintf(buf, "<%s>\r\n", msgid);

           /* Send text response line (check for write errors) */
           if (Send(NNTPDSocket, buf, len, 0) < len) {
            error = NEWNEWS_ABORT;
            break;
           }

           /* Free message */
           UMSFreeMsg(Account, msgnum);

           /* if hard-linked, then clear Local Bits 0, 1, 2 for this msg */
           if (hardlink)
            UMSSelectTags(Account, UMSTAG_SelMsg,        msgnum,
                                   UMSTAG_SelWriteLocal, TRUE,
                                   UMSTAG_SelUnset,      7,
                                   TAG_DONE);

         } else {
          /* Error, leave loop */
          error = NEWNEWS_FAILURE;
          break;
         }
        }

        /* Send text response terminator */
        Send(NNTPDSocket, ".\r\n", 3, 0);
       }
      }
     }
    }
   }
  }
 }

 /* Syntax error? */
 switch (error) {
  case NEWNEWS_SYNTAX:  /* Syntax error */
   Send(NNTPDSocket, INTTOSTR(NNTP_SYNTAX_ERROR)
                      " command syntax error\r\n", 26, 0);
   break;

  case NEWNEWS_FAILURE: /* Program failure */
   Send(NNTPDSocket, INTTOSTR(NNTP_PROGRAM_FAULT)
                      " program fault - command not performed\r\n", 43, 0);
   break;
 }

 return(error < NEWNEWS_ABORT);
}

/* Handle NEWGROUPS command */
BOOL HandleNEWGROUPSCommand(struct UMSRFCData *urd, char *args)
{
 Send(NNTPDSocket, INTTOSTR(NNTP_LIST_OF_NEW_GROUPS)
                    " list of new newsgroups follows\r\n.\r\n", 39, 0);

 return(TRUE);
}
