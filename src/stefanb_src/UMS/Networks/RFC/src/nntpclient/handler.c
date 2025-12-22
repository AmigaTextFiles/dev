/*
 * handler.c V1.0.02
 *
 * UMS NNTP (client) news fetch handler
 *
 * (c) 1994-98 by Stefan Becker
 */

#include "umsnntp.h"

/* Private tag stub */
static BOOL PrivateUMSSearchTags(struct Library *UMSBase, UMSAccount account,
                                 Tag tag1, ...)
{
 return(UMSSearch(account, (struct TagItem *) &tag1));
}

/* Process commands */
static void CommandLoop(struct HandlerData *hd, struct HandlerMessage *hm,
                        struct MsgPort *mp)
{
 struct NNTPCommandData *ncd = &hd->hd_CommandData;

 /* Read greeting from server */
 if ((GetReturnCode(ncd)                == NNTP_READY_POST_ALLOWED) ||
     (strtol(ncd->ncd_Buffer, NULL, 10) == NNTP_READY_POST_NOT_ALLOWED)) {
  struct Library *SysBase = hd->hd_SysBase;

  DEBUGLOG(kprintf("(%08lx) Access allowed\n", FindTask(NULL));)

  /* Send MODE READER command to server, ignore return code */
  SendNNTPCommand(ncd, "MODE READER\r\n", 13);

  /* Access allowed, set message port for commands */
  hm->hm_Port = mp;

  /* Command loop */
  do {

   /* Reply last command */
   ReplyMsg((struct Message *) hm);

   /* Wait for next command */
   WaitPort(mp);

   /* Get next command from port */
   hm = (struct HandlerMessage *) GetMsg(mp);

   /* Process command */
   switch (hm->hm_Command) {
    case COMM_GETARTICLE: { /* Retrieve one article, parameter = message id */
      ULONG n;

      DEBUGLOG(kprintf("(%08lx) Article <%s>\n", FindTask(NULL),
                       hm->hm_Parameter);)

      /* Generate request */
      n = sprintf(hd->hd_Buffer, "ARTICLE <%s>\r\n", hm->hm_Parameter);

      /* Get article from server */
      GetArticle(hd, hd->hd_Buffer, n);
     }
     break;

    case COMM_GETGROUP: {   /* Retrieve complete news group, */
                            /* parameter = group name */
      ULONG n;

      DEBUGLOG(kprintf("(%08lx) Group '%s'\n", FindTask(NULL),
                       hm->hm_Parameter);)

      /* Ask server for group */
      n = sprintf(hd->hd_Buffer, "GROUP %s\r\n", hm->hm_Parameter);

      /* Group selected? */
      if (SendNNTPCommand(ncd, hd->hd_Buffer, n) == NNTP_GROUP_SELECTED) {
       struct Library *UMSBase = hd->hd_Bases.urb_UMSBase;
       UMSAccount      account = hd->hd_URData->urd_Account;
       char           *cmd     = "STAT\r\n";    /* First command is "STAT" */

       do {

        /* Check for read error and response code */
        if ((n = SendNNTPCommand(ncd, cmd, 6))
             == NNTP_ARTICLE_RETRIEVED_STAT) {
         char *bp;

         /* Look out for start of message ID */
         if (bp = strchr(ncd->ncd_Buffer, '<')) {
          char *ep;

          /* Look out for '>' */
          if (ep = strrchr(bp++, '>')) {

           /* Set string terminator */
           *ep = '\0';

           DEBUGLOG(kprintf("(%08lx) MsgID: %s\n", FindTask(NULL), bp);)

           /* Do we already have this article? */
           if (!PrivateUMSSearchTags(UMSBase, account,
                                                      UMSTAG_WMsgID,      bp,
                                                      UMSTAG_SearchQuick, TRUE,
                                                      TAG_DONE)) {

            DEBUGLOG(kprintf("(%08lx) Requesting: %s\n", FindTask(NULL), bp);)

            /* No, request article */
            GetArticle(hd, "ARTICLE\r\n", 9);
           }
          }
         }
        }

        /* Next command is "NEXT" */
        cmd = "NEXT\r\n";

        /* As long as articles are available */
       } while (n == NNTP_ARTICLE_RETRIEVED_STAT);
      }
     }
     break;
   }

   /* Stop processing if quit command arrives */
  } while (hm->hm_Command != COMM_QUIT);
 }
}

/* NNTP handler */
#ifdef DEBUG
__geta4
#endif
void NNTPHandler(void) {
 struct Library *SysBase   = *((struct Library **) 4); /* AbsExecBase */
 struct MsgPort *pmp       = &((struct Process *) FindTask(NULL))->pr_MsgPort;
 struct MsgPort *mp;
 struct HandlerMessage *hm;

 /* Wait for initialization message */
 WaitPort(pmp);

 /* Retrieve message from port */
 hm = (struct HandlerMessage *) GetMsg(pmp);

 /* Allocate message port */
 if (mp = CreateMsgPort()) {
  struct HandlerData *hd;

  /* Allocate memory for handler data */
  if (hd = AllocMem(sizeof(struct HandlerData), 0)) {

   /* Open ums.library */
   if (hd->hd_Bases.urb_UMSBase = OpenLibrary("ums.library", 11)) {

    /* Open dos.library */
    if (hd->hd_Bases.urb_DOSBase = OpenLibrary("dos.library", 37)) {

     /* Open utility.library */
     if (hd->hd_Bases.urb_UtilityBase = OpenLibrary("utility.library", 37)) {

      /* Open umsrfc.library */
      if (hd->hd_UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME,
                                          UMSRFC_LIBRARY_VERSION)) {
       struct Library *SocketBase;

       /* Open socket.library */
       if (SocketBase = OpenLibrary("bsdsocket.library", 0)) {
        struct Library *UMSRFCBase = hd->hd_UMSRFCBase;
        struct InitData *id        = hm->hm_Parameter;

        /* Login to UMS */
        if (hd->hd_URData = UMSRFCAllocData(&hd->hd_Bases, id->id_UMSUser,
                                            id->id_UMSPassword,
                                            id->id_UMSServer)) {
         struct ConnectData *cd = &hd->hd_CommandData.ncd_ConnectData;

         /* Initialize connection data */
         cd->cd_SocketBase = SocketBase;

         /* Get connection data */
         if (GetConnectData(cd, id->id_NNTPServiceName)) {

          DEBUGLOG(kprintf("(%08lx) Resources allocated\n", FindTask(NULL));)

          /* Connect to host */
          if (ConnectToHost(cd, id->id_NNTPHostName) == CONNECT_OK) {

           DEBUGLOG(kprintf("(%08lx) Connected to '%s'\n", FindTask(NULL),
                            id->id_NNTPHostName);)

           /* Initialize rest of handler data */
           hd->hd_SysBase                  = SysBase;
           hd->hd_CommandData.ncd_User     = id->id_AuthUser;
           hd->hd_CommandData.ncd_Password = id->id_AuthPassword;
           hd->hd_OutputData.od_DOSBase    = hd->hd_Bases.urb_DOSBase;
           hd->hd_OutputData.od_Buffer     = hd->hd_OutBuf;
           hd->hd_OutputData.od_Length     = BUFLEN;
           hd->hd_InputData.id_OutputData  = &hd->hd_OutputData;
           hd->hd_InputData.id_FileName    = hd->hd_FileName;
           hd->hd_InputData.id_Buffer      = hd->hd_Buffer;
           hd->hd_InputData.id_Length      = BUFLEN;
           hd->hd_InputData.id_SocketBase  = SocketBase;
           hd->hd_InputData.id_Socket      = cd->cd_Socket;
           hd->hd_InputData.id_SysBase     = SysBase;

           /* Create file name */
           sprintf(hd->hd_FileName, "T:nntpget-%08lx", FindTask(NULL));

           /* Process commands */
           CommandLoop(hd, hm, mp);

           CloseConnection(cd);
          }

          FreeConnectData(cd);
         }

         UMSRFCFreeData(hd->hd_URData);
        }

        CloseLibrary(SocketBase);
       }

       CloseLibrary(hd->hd_UMSRFCBase);
      }

      CloseLibrary(hd->hd_Bases.urb_UtilityBase);
     }

     CloseLibrary(hd->hd_Bases.urb_DOSBase);
    }

    CloseLibrary(hd->hd_Bases.urb_UMSBase);
   }

   FreeMem(hd, sizeof(struct HandlerData));
  }

  DeleteMsgPort(mp);
 }

 /* Reply last message */
 Forbid();
 ReplyMsg((struct Message *) hm);
}
