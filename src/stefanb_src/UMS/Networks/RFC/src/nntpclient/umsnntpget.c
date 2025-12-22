/*
 * umsnntpget.c V1.0.03
 *
 * UMS NNTP (client) NNTP retriever main entry point
 *
 * (c) 1994-98 Stefan Becker
 */

#include "umsnntp.h"

/* Constant strings */
static const char Version[] = "$VER: umsnntpget "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";
static const char RequestName[] = "nntpget.lastrequest";
static const char GroupsName[]  = "nntpget.groups";

/* Local defines */
#define MODEF_GROUP   0x1 /* Request groups instead of articles */
#define MODEF_CMDLINE 0x2 /* Use command line arguments         */
#define MODEF_VERBOSE 0x4 /* Verbose mode (print msgids)        */

/* Local data */
static struct InitData         InitData  = { NULL, "nntp", "NNTP", "", NULL,
                                             "jduser", "secret"};
static struct List             Processes;
static struct HandlerMessage  *MsgArray;
static struct NNTPCommandData  RequestNCD;
static struct ClockData        cd;
static struct DateStamp        ds;
static char Buffer[BUFLEN];
static BOOL NoBreak = TRUE;

/* Dummy routine for CTRL-C */
static int brk(void)
{
 NoBreak = FALSE;
 return(0);
}

/* Get next free process */
static struct HandlerMessage *GetNextProcess(struct MsgPort *mp)
{
 struct HandlerMessage *hm;

 /* Retrieve message from free process list */
 if ((hm = (struct HandlerMessage *) RemHead(&Processes)) == NULL) {

  /* No processes available, wait until one is free again */
  WaitPort(mp);

  /* Retrieve message from port */
  hm = (struct HandlerMessage *) GetMsg(mp);
 }

 return(hm);
}

/* Send handler message to process */
static void SendHandlerMessage(struct HandlerMessage *hm, ULONG comm,
                               void *par)
{
 /* Initialize handler message */
 hm->hm_Command   = comm;
 hm->hm_Parameter = par;

 /* Send message to process */
 PutMsg(hm->hm_Port, (struct Message *) hm);
}

/* Stop processes */
static void StopProcesses(struct MsgPort *mp, ULONG max)
{
 ULONG sent    = max;
 ULONG stopped = max;

 /* For every process */
 while (sent--) {
  struct HandlerMessage *hm;

  while (TRUE) {
   /* Get next free process */
   hm = GetNextProcess(mp);

   /* Response from Running process? Yes, leave loop */
   if (hm->hm_Command != COMM_QUIT) break;

   /* Got response from stopped process, drop it */
   stopped--;
  }

  /* Send quit command */
  SendHandlerMessage(hm, COMM_QUIT, NULL);
 }

 /* Wait for missing responses */
 while (stopped--) GetNextProcess(mp);

 /* Free handler messages */
 FreeMem(MsgArray, max * sizeof(struct HandlerMessage));
}

/* Start processes */
static BOOL StartProcesses(struct MsgPort *mp, ULONG max)
{
 BOOL rc = FALSE;

 /* Allocate handler messages array */
 if (MsgArray = AllocMem(max * sizeof(struct HandlerMessage), MEMF_PUBLIC)) {
  ULONG count = 0;

  /* Initialize process list */
  NewList(&Processes);

  /* For each process */
  while (count < max) {

   struct Process *p;

   /* Create process */
   if (p = CreateNewProcTags(NP_Entry, &NNTPHandler,
                             NP_Name,  "NNTP fetch process",
                             TAG_DONE)) {
    struct HandlerMessage *hm = &MsgArray[count];

    /* Initialize handler message */
    hm->hm_Message.mn_ReplyPort = mp;
    hm->hm_Message.mn_Length    = sizeof(struct HandlerMessage);
    hm->hm_Port                 = NULL;
    hm->hm_Command              = COMM_INIT;
    hm->hm_Parameter            = &InitData;

    /* Send message to new process */
    PutMsg(&p->pr_MsgPort, (struct Message *) hm);

    /* Wait on response */
    WaitPort(mp);

    /* Remove message from port */
    GetMsg(mp);

    /* Process initialization OK? */
    if (hm->hm_Port) {

     /* Yes, increment counter */
     count++;

     /* Add process to list */
     AddTail(&Processes, (struct Node *) hm);

    /* Could not initialize process -> leave loop */
    } else
     break;

   /* Could not create process -> leave loop */
   } else
    break;
  }

  /* All processes started? */
  if (count == max)
   rc = TRUE; /* All OK */

  /* Already some processes running? */
  else if (count > 0)
   StopProcesses(mp, count); /* Abort processes */
 }

 return(rc);
}

/* Request one article */
static void RequestArticle(struct MsgPort *mp, char *id, BOOL verbose)
{
 struct HandlerMessage *hm;

 /* Get next free process */
 hm = GetNextProcess(mp);

 /* Print progress message */
 if (verbose) printf("Requesting article <%s>\n", id);

 /* Copy parameter */
 strcpy(hm->hm_ParBuf, id);

 /* Send command to process */
 SendHandlerMessage(hm, COMM_GETARTICLE, hm->hm_ParBuf);
}

/* Request one group */
static void RequestGroup(struct MsgPort *mp, char *group)
{
 struct HandlerMessage *hm;

 /* Get next free process */
 hm = GetNextProcess(mp);

 /* Print progress message */
 printf("Requesting group '%s'\n", group);

 /* Send command to process */
 SendHandlerMessage(hm, COMM_GETGROUP, group);
}

/* Main entry point */
int main(int argc, char **argv)
{
 int rc = RETURN_FAIL;

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Check Exec version */
 if (SysBase->lib_Version >= 37) {
  ULONG ModeFlags   = MODEF_VERBOSE;
  ULONG MaxHandlers = 1;

  /* Parse command line arguments */
  while (--argc) {
   char *arg = *++argv;

   /* Command? */
   if (*arg == '-')

    /* Yes */
    switch (arg[1]) {
     case 'I': /* NNTP authentication  */
      break;

     case 'N': /* NNTP authentication name */
      break;

     case 'P': /* Number of processes */
      {
       char *ap = *(argv + 1);
       char *cp = (ap && (*ap != '-')) ? (argc--, argv++, ap) : arg + 2;

       /* Convert string to number */
       MaxHandlers = strtol(cp, NULL, 10);

       /* Limit maximum number of processes */
       if (MaxHandlers == 0)
        MaxHandlers = 1;
       else if (MaxHandlers > MAXHANDLERS)
        MaxHandlers = MAXHANDLERS;
      }
      break;

     case 'S': /* NNTP service name */
      {
       char *ap                    = *(argv + 1);
       InitData.id_NNTPServiceName = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                            : arg + 2;
      }
      break;

     case 'c': /* Use command line arguments */
      ModeFlags |= MODEF_CMDLINE;
      break;

     case 'd': /* Log level */
      {
       char *ap = *(argv + 1);
       char *cp = (ap && (*ap != '-')) ? (argc--, argv++, ap) : arg + 2;

       /* Convert string to number */
       /* LogLevel = strtol(cp, NULL, 10); */
      }
      break;

     case 'h': /* NNTP host name */
      {
       char *ap                 = *(argv + 1);
       InitData.id_NNTPHostName = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                         : arg + 2;
      }
      break;

     case 'i': /* NNTP authentication password */
      {
       char *ap                 = *(argv + 1);
       InitData.id_AuthPassword = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                         : arg + 2;
      }
      break;

     case 'g': /* Use GROUP method */
      ModeFlags |= MODEF_GROUP;
      break;

     case 'n': /* NNTP authentication name */
      {
       char *ap             = *(argv + 1);
       InitData.id_AuthUser = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                     : arg + 2;
      }
      break;

     case 'p': /* UMS password */
      {
       char *ap                = *(argv + 1);
       InitData.id_UMSPassword = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                        : arg + 2;
      }
      break;

     case 'q': /* Quiet mode (don't print msgids) */
      ModeFlags &= ~MODEF_VERBOSE;
      break;

     case 's': /* UMS server name */
      {
       char *ap              = *(argv + 1);
       InitData.id_UMSServer = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                      : arg + 2;
      }
      break;

     case 'u': /* UMS user name */
      {
       char *ap             = *(argv + 1);
       InitData.id_UMSUser  = (ap && (*ap != '-')) ? (argc--, argv++, ap)
                                                     : arg + 2;
      }
      break;

     default:  /* Unknown option -> ignore */
      fprintf(stderr, "Unknown option '%c'!\n", arg[1]);
      break;
    }

   /* No, end of commands reached */
   else break;
  }

  /* Host name set? */
  if (InitData.id_NNTPHostName) {
   UMSAccount account;

   /* Login to UMS */
   if (account = UMSRLogin(InitData.id_UMSServer, InitData.id_UMSUser,
                           InitData.id_UMSPassword)) {
    struct MsgPort *mp;

    /* Allocate message port */
    if (mp = CreateMsgPort()) {

     /* Start processes */
     if (StartProcesses(mp, MaxHandlers)) {

      /* Use command line arguments? */
      if (ModeFlags & MODEF_CMDLINE) {

       /* Yes, groups or articles? */
       if (ModeFlags & MODEF_GROUP)

        /* For each group on command line */
        while (NoBreak && argc--) RequestGroup(mp, *argv++);

       else

        /* For each id on command line */
        while (NoBreak && argc--)
         RequestArticle(mp, *argv++, ModeFlags & MODEF_VERBOSE);

       /* Reset error flag */
       rc = RETURN_OK;

      /* Use UMS variables */
      } else

       /* Group or article mode? */
       if (ModeFlags & MODEF_GROUP) {
        char *var;

        /* Group mode, reset error flag */
        rc = RETURN_OK;

        /* Get group list from UMS config */
        if (var = UMSReadConfigTags(account, UMSTAG_CfgName, GroupsName,
                                             TAG_DONE)) {
         char *nextgroup = var;

         /* For each group */
         do {
          char *group = nextgroup;

          /* Scan for next group */
          if (nextgroup = strchr(nextgroup, '\n')) *nextgroup++ = '\0';

          /* Group name valid? */
          if (*group) RequestGroup(mp, group);

          /* Next group */
         } while (NoBreak && nextgroup);

         /* Free UMS variable */
         UMSFreeConfig(account, var);
        }

       /* Use NEWNEWS command */
       } else {
        struct Library *SocketBase;

        /* Open bsdsocket.library */
        if (SocketBase = OpenLibrary("bsdsocket.library", 0)) {

         /* Initialize connection data */
         RequestNCD.ncd_ConnectData.cd_SocketBase = SocketBase;

         /* Get connection data */
         if (GetConnectData(&RequestNCD.ncd_ConnectData,
                            InitData.id_NNTPServiceName)) {

          /* Connect to host */
          if (ConnectToHost(&RequestNCD.ncd_ConnectData,
                            InitData.id_NNTPHostName) == CONNECT_OK) {

           /* Read greeting from server */
           if ((GetReturnCode(&RequestNCD) == NNTP_READY_POST_ALLOWED) ||
               (strtol(RequestNCD.ncd_Buffer, NULL, 10)
                 == NNTP_READY_POST_NOT_ALLOWED)) {
            ULONG NewTime;
            char *var;

            /* Initialize authentication data */
            RequestNCD.ncd_User     = InitData.id_AuthUser;
            RequestNCD.ncd_Password = InitData.id_AuthPassword;

            /* Send MODE READER command to server, ignore return code */
            SendNNTPCommand(&RequestNCD, "MODE READER\r\n", 13);

            /* Reset error flag */
            rc = RETURN_OK;

            /* Get time of last NNTP transfer from UMS config */
            {
             ULONG lasttime;

             if (var = UMSReadConfigTags(account, UMSTAG_CfgName, RequestName,
                                                  TAG_DONE)) {

              /* Convert string to number */
              lasttime = strtol(var, NULL, 10);

              /* Free UMS variable */
              UMSFreeConfig(account, var);

             } else
               /* We never did a request, so get all :-) */
               lasttime = 1;

             /* Convert number to date & time */
             Amiga2Date(lasttime, &cd);
            }

            /* Get current time stamp */
            DateStamp(&ds);

            /* Calculate current time */
            NewTime = ds.ds_Days   * 86400            +
                      ds.ds_Minute * 60               +
                      ds.ds_Tick   / TICKS_PER_SECOND;

            /* Get group list from UMS config */
            if (var = UMSReadConfigTags(account, UMSTAG_CfgName, GroupsName,
                                                 TAG_DONE)) {
             LONG  NNTPSocket = RequestNCD.ncd_ConnectData.cd_Socket;
             char *nextgroup  = var;

             /* For each group pattern */
             do {
              char *group = nextgroup;

              /* Scan for next group */
              if (nextgroup = strchr(nextgroup, '\n')) *nextgroup++ = '\0';

              /* Group pattern valid? */
              if (*group) {
               ULONG len;

               /* Yes */
               printf("Group: %s\n", group);

               /* Create NEWNEWS request */
               len = sprintf(Buffer, "NEWNEWS %s %02d%02d%02d %02d%02d%02d\r\n",
                             group,
                             cd.year % 100, cd.month, cd.mday,
                             cd.hour, cd.min, cd.sec);

               /* Send NEWNEWS request */
               if (SendNNTPCommand(&RequestNCD, Buffer, len)
                    == NNTP_LIST_OF_NEW_MSGIDS) {

                /* Read article list from server */
                while (NoBreak) {

                 /* Read one line server */
                 if (ReadLine(SocketBase, NNTPSocket, Buffer, BUFLEN)
                      == FALSE) {
                  /* Error while reading, leave loop */
                  rc = RETURN_FAIL;
                  break;
                 }

                 /* End of list marker? */
                 if (*Buffer == '.') {
                  /* Yes, leave loop */
                  break;

                  /* No, extract message ID */
                 } else if (*Buffer == '<') {
                  char *ep;

                  /* Look out for '>' */
                  if (ep = strrchr(Buffer, '>')) {
                   char *id = Buffer + 1;

                   /* Set string terminator */
                   *ep = '\0';

                   /* Do we already have this article? */
                   if (!UMSSearchTags(account, UMSTAG_WMsgID,      id,
                                               UMSTAG_SearchQuick, TRUE,
                                               TAG_DONE))
                    /* No, get article */
                    RequestArticle(mp, id, ModeFlags & MODEF_VERBOSE);
                  }
                 }
                }
               } else {
                /* NEWNEWS failed, leave loop */
                rc = RETURN_FAIL;
               }
              }

               /* Next group pattern */
             } while ((rc == RETURN_OK) && NoBreak && nextgroup);

             /* Free UMS variable */
             UMSFreeConfig(account, var);
            }

            /* All OK? */
            if (NoBreak && (rc == RETURN_OK)) {
             /* Yes, write new time stamp */
             sprintf(Buffer, "%d", NewTime);
             UMSWriteConfigTags(account, UMSTAG_CfgName, RequestName,
                                         UMSTAG_CfgData, Buffer,
                                         TAG_DONE);
            }

           } else
            fprintf(stderr, "Access to this NNTP server not allowed!\n");

           /* Close connection */
           CloseConnection(&RequestNCD.ncd_ConnectData);
          } else
           fprintf(stderr, "Couldn't create connection to '%s'!\n",
                           InitData.id_NNTPHostName);

          FreeConnectData(&RequestNCD.ncd_ConnectData);
         } else
          fprintf(stderr, "Couldn't get connection data!\n");

         CloseLibrary(SocketBase);
        } else
         fprintf(stderr, "Couldn't open bsdsocket.library!\n");
       }

      StopProcesses(mp, MaxHandlers);
     } else
      fprintf(stderr, "Couldn't start processes!\n");

     DeleteMsgPort(mp);
    } else
     fprintf(stderr, "Couldn't allocate message port!\n");

    UMSLogout(account);
   } else
    fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n", InitData.id_UMSUser,
                    InitData.id_UMSServer ? InitData.id_UMSServer : "default");

  } else
   fprintf(stderr,
           "You have to specify the hostname of the NNTP server!\n");

 } else
  fprintf(stderr,
          "This version of umsnntpget needs Kickstart V37 or better!\n");

 return(rc);
}
