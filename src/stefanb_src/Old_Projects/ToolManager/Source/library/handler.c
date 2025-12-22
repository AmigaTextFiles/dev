/*
 * handler.c  V2.1.07
 *
 * handler main loop
 *
 * (c) 1990-1996 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Constant strings */
static const char WBName[] = "Workbench";

/* misc. data */
struct Library *DOSBase=NULL;
struct Library *CxBase=NULL;
struct Library *UtilityBase=NULL;
struct IntuitionBase *IntuitionBase=NULL;
struct Library *GfxBase=NULL;
struct Library *GadToolsBase=NULL;
struct Library *NIPCBase=NULL;
struct Library *ScreenNotifyBase=NULL;
extern const char DosName[];
extern struct Library *LibBase;
static struct NotifyRequest PrefsNotify={
                                         PrefsFileName,NULL,0,
                                         NRF_SEND_SIGNAL,NULL
                                        };
static ULONG EntitySignal=-1;
static ULONG NotifySignal=-1;
static UBYTE *HostNameBuffer=NULL;
#define HOSTNAMEBUFLEN 256
static APTR ScreenNotifyHandle1=NULL;
static APTR ScreenNotifyHandle2=NULL;
static APTR ScreenNotifyHandle3=NULL;
static BOOL TimerOpen=FALSE;
static BOOL NotifyActive=FALSE;

/* Open handler resources */
static BOOL OpenResources(void)
{
 if (!(LibraryPort=CreateMsgPort()))                       return(FALSE);
 if (!(DOSBase=OpenLibrary(DosName,39)))                   return(FALSE);
 if (!(CxBase=OpenLibrary("commodities.library",39)))      return(FALSE);
 if (!(UtilityBase=OpenLibrary("utility.library",39)))     return(FALSE);
 if (!(IntuitionBase=(struct IntuitionBase *)
                      OpenLibrary("intuition.library",39))) return(FALSE);
 if (!(GfxBase=OpenLibrary("graphics.library",39)))        return(FALSE);
 if (!(GadToolsBase=OpenLibrary("gadtools.library",39)))   return(FALSE);
 if (!(DummyPort=CreateMsgPort()))                         return(FALSE);
 if (!(IDCMPPort=CreateMsgPort()))                         return(FALSE);
 if (!(TimerPort=CreateMsgPort()))                         return(FALSE);
 if (!(AppMsgPort=CreateMsgPort()))                        return(FALSE);
 if (!(BrokerPort=CreateMsgPort()))                        return(FALSE);
 if (!(deftimereq=CreateIORequest(TimerPort,sizeof(struct timerequest))))
                                                           return(FALSE);
 if (OpenDevice(TIMERNAME,UNIT_MICROHZ,(struct IORequest *) deftimereq,
                0))                                        return(FALSE);
 TimerOpen=TRUE;
 if (!(PrivateTMHandle=AllocMem(sizeof(struct TMHandle),MEMF_PUBLIC)))
                                                           return(FALSE);
 if (!(InternalAllocTMHandle(PrivateTMHandle)))            return(FALSE);
 if ((NotifySignal=AllocSignal(-1))==-1)                   return(FALSE);
 PrefsNotify.nr_stuff.nr_Signal.nr_Task=FindTask(NULL);
 PrefsNotify.nr_stuff.nr_Signal.nr_SignalNum=NotifySignal;
 if (!StartNotify(&PrefsNotify))                           return(FALSE);
 NotifyActive=TRUE;
 BrokerData.nb_Port=BrokerPort;

 /* Get locale stuff */
 GetLocale();

 if (!(Broker=CxBroker(&BrokerData,NULL)))                 return(FALSE);

 /* Copy path from Workbench process */
 {
  struct Process *wbproc=(struct Process *) FindTask(WBName);

  /* Task found? Make sure it IS a process */
  if (wbproc && (wbproc->pr_Task.tc_Node.ln_Type==NT_PROCESS)) {
   /* It is a process */
   struct CommandLineInterface *wbcli=BADDR(wbproc->pr_CLI);

   /* Make sure it is a CLI process */
   if (wbcli) {
    /* It is a CLI process */
    struct PathList *dummy;

    /* Copy it's path into global path */
    if (!CopyPathList(&GlobalPath,&dummy,
                      (struct PathList *) BADDR(wbcli->cli_CommandDir)))
     return(FALSE);
   }
  }
 }

 /* Get ScreenNotify stuff */
 if (ScreenNotifyBase = OpenLibrary("screennotify.library", 0)) {

  /* Allocate message port */
  if (!(ScreenNotifyPort = CreateMsgPort())) return(FALSE);

  /* Add handler as client */
  ScreenNotifyHandle1 = AddCloseScreenClient(NULL, ScreenNotifyPort, 0);
  ScreenNotifyHandle2 = AddPubScreenClient(ScreenNotifyPort, 0);
  ScreenNotifyHandle3 = AddWorkbenchClient(ScreenNotifyPort, 0);
 }

 /* Get network stuff */
 if (NIPCBase=OpenLibrary("nipc.library",37)) {
  /* Create local public entity */
  if (!(LocalEntity=CreateEntity(ENT_AllocSignal, &EntitySignal,
                                 ENT_Name,        ToolManagerName,
                                 ENT_Public,      TRUE,
                                 TAG_DONE)))
   return(FALSE);

  if (!(HostNameBuffer=AllocMem(HOSTNAMEBUFLEN,MEMF_PUBLIC))) return(FALSE);
 }

 /* All OK. */
 return(TRUE);
}

/* Free handler resources */
static void FreeResources(void)
{
 if (HostNameBuffer) {
  FreeMem(HostNameBuffer,HOSTNAMEBUFLEN);
  HostNameBuffer=NULL;
 }
 if (LocalEntity) {
  DeleteEntity(LocalEntity);
  LocalEntity=NULL;
  EntitySignal=-1;
 }
 if (NIPCBase) {
  CloseLibrary(NIPCBase);
  NIPCBase=NULL;
 }

 if (ScreenNotifyHandle3) {
  while (!RemWorkbenchClient(ScreenNotifyHandle3)) Delay(10);
  ScreenNotifyHandle3 = NULL;
 }
 if (ScreenNotifyHandle2) {
  while (!RemPubScreenClient(ScreenNotifyHandle2)) Delay(10);
  ScreenNotifyHandle2 = NULL;
 }
 if (ScreenNotifyHandle1) {
  while (!RemCloseScreenClient(ScreenNotifyHandle1)) Delay(10);
  ScreenNotifyHandle1 = NULL;
 }
 if (ScreenNotifyPort) {
  DeleteMsgPort(ScreenNotifyPort);
  ScreenNotifyPort = NULL;
 }
 if (ScreenNotifyBase) {
  CloseLibrary(ScreenNotifyBase);
  ScreenNotifyBase = NULL;
 }

 FreePathList(GlobalPath); /* FreePath checks for NULL */
 GlobalPath=NULL;

 if (Broker) {
  DeleteCxObjAll(Broker);
  Broker=NULL;
 }
 FreeLocale();
 if (NotifyActive) {
  EndNotify(&PrefsNotify);
  NotifyActive=FALSE;
 }
 if (NotifySignal != -1) {
  FreeSignal(NotifySignal);
  NotifySignal=-1;
 }
 if (PrivateTMHandle) {
  InternalFreeTMHandle(PrivateTMHandle);
  FreeMem(PrivateTMHandle,sizeof(struct TMHandle));
  PrivateTMHandle=NULL;
 }
 if (TimerOpen) {
  CloseDevice((struct IORequest *) deftimereq);
  TimerOpen=FALSE;
 }
 if (deftimereq) {
  DeleteIORequest(deftimereq);
  deftimereq=NULL;
 }
 if (BrokerPort) {
  struct Message *msg;
  while (msg=GetMsg(BrokerPort)) ReplyMsg(msg);
  DeleteMsgPort(BrokerPort);
  BrokerPort=NULL;
 }
 if (AppMsgPort) {
  struct Message *msg;
  while (msg=GetMsg(AppMsgPort)) ReplyMsg(msg);
  DeleteMsgPort(AppMsgPort);
  AppMsgPort=NULL;
 }
 if (TimerPort) {
  DeleteMsgPort(TimerPort);
  TimerPort=NULL;
 }
 if (IDCMPPort) {
  DeleteMsgPort(IDCMPPort);
  IDCMPPort=NULL;
 }
 if (DummyPort) {
  DeleteMsgPort(DummyPort);
  DummyPort=NULL;
 }
 if (GadToolsBase) {
  CloseLibrary(GadToolsBase);
  GadToolsBase=NULL;
 }
 if (GfxBase) {
  CloseLibrary(GfxBase);
  GfxBase=NULL;
 }
 if (IntuitionBase) {
  CloseLibrary((struct Library *) IntuitionBase);
  IntuitionBase=NULL;
 }
 if (UtilityBase) {
  CloseLibrary(UtilityBase);
  UtilityBase=NULL;
 }
 if (CxBase) {
  CloseLibrary(CxBase);
  CxBase=NULL;
 }
 if (DOSBase) {
  CloseLibrary(DOSBase);
  DOSBase=NULL;
 }
 if (LibraryPort) {
  DeleteMsgPort(LibraryPort);
  LibraryPort=NULL;
 }
}

/* Screen open event */
static void ScreenOpenEvent(char *name)
{
 struct TMObject *tmobj = GetHead(&PrivateTMHandle->tmh_ObjectLists[TMOBJTYPE_DOCK]);

 /* Traverse list */
 while (tmobj) {
  /* Open dock */
  ScreenOpenRequest(tmobj, name);

  /* Get next object */
  tmobj = GetSucc(tmobj);
 }
}

/* Screen close event */
static void ScreenCloseEvent(struct Screen *s)
{
 struct TMObject *tmobj = GetHead(&PrivateTMHandle->tmh_ObjectLists[TMOBJTYPE_DOCK]);

 /* Traverse list */
 while (tmobj) {
  /* Close dock */
  ScreenCloseRequest(tmobj, s);

  /* Get next object */
  tmobj = GetSucc(tmobj);
 }
}

/* handler main entry point */
__geta4 void HandlerEntry(void)
{
 ULONG sigmask,lpsig,ipsig,tpsig,apsig,bpsig,nwsig,npsig,scsig;

 /* Get resources */
 if (!OpenResources()) {
  FreeResources();
  return;
 }

 /* Read config */
 if (!Closing) ReadConfig();

 /* Build signal masks */
 lpsig = 1L << LibraryPort->mp_SigBit;
 ipsig = 1L << IDCMPPort->mp_SigBit;
 tpsig = 1L << TimerPort->mp_SigBit;
 apsig = 1L << AppMsgPort->mp_SigBit;
 bpsig = 1L << BrokerPort->mp_SigBit;
 nwsig = (EntitySignal != -1) ? (1L << EntitySignal) : 0;
 npsig = 1L << NotifySignal;
 scsig = (ScreenNotifyPort != NULL) ? (1L << ScreenNotifyPort->mp_SigBit) : 0;

 sigmask=ipsig|lpsig|tpsig|apsig|bpsig|nwsig|npsig|scsig|SIGBREAKF_CTRL_F;

 /* Activate broker */
 ActivateCxObj(Broker,TRUE);

 /* Wait until the end...*/
 while (!Closing || (LibBase->lib_OpenCnt>0)) {
  ULONG gotsigs;

  /* Wait for events */
  DEBUG_PUTSTR("Handler: Waiting for messages...\n")
  gotsigs=Wait(sigmask);

  /* Got an IDCMP event? (only dock objects!) */
  if (gotsigs & ipsig) HandleIDCMPEvents();

  /* Got a timer event? */
  if (gotsigs & tpsig) {
   struct List *l=&TimerPort->mp_MsgList;
   struct TMTimerReq *tr;

   /* Scan message list (special treatment for I/O Requests!) */
   while (tr=GetHead(l)) CallActivateTMObject(tr->tmtr_Link,NULL);
  }

  /* Got a Workbench App* message? */
  if (gotsigs & apsig) {
   struct AppMessage *msg;

   /* Empty message queue */
   while (msg=(struct AppMessage *) GetMsg(AppMsgPort)) {
    /* Activate object */
    CallActivateTMObject((struct TMLink *) msg->am_ID,msg);

    /* Reply message */
    ReplyMsg((struct Message *) msg);
   }
  }

  /* Got a Commodities event? */
  if (gotsigs & bpsig) {
   CxMsg *msg;

   /* Empty message queue */
   while (msg=(CxMsg *) GetMsg(BrokerPort)) {

    DEBUG_PRINTF("Commodities event (0x%08lx)\n",CxMsgType(msg));

    /* What type of Commodities event? */
    switch (CxMsgType(msg)) {
     case CXM_IEVENT: /* Hotkey event --> Activate object */
                     CallActivateTMObject((struct TMLink *) CxMsgID(msg),
                                          NULL);
                     break;

     case CXM_COMMAND: /* Commodities command */
                      switch (CxMsgID(msg)) {
                       case CXCMD_DISABLE: /* Disable broker */
                                          ActivateCxObj(Broker,FALSE);
                                          break;

                       case CXCMD_ENABLE:  /* Enable broker */
                                          ActivateCxObj(Broker,TRUE);
                                          break;

                       case CXCMD_KILL:    /* Quit application */
                                          Closing=TRUE;
                                          break;
                       }
                      break;
    }

    /* Reply message */
    ReplyMsg((struct Message *) msg);
   }
  }

  /* Got a network event? */
  if (gotsigs & nwsig) {
   struct Transaction *trans;

   /* Empty transaction queue */
   while (trans=GetTransaction(LocalEntity)) {
    struct TMLink *tml=NULL;
    ULONG errcode=ENVOYERR_APP;

    /* Get host name of remote machine */
    if (GetHostName(trans->trans_SourceEntity,HostNameBuffer,HOSTNAMEBUFLEN))

     /* Search Access object (with full host name) */
     if (!(tml=AddLinkTMObject(PrivateTMHandle,HostNameBuffer,TMOBJTYPE_ACCESS,
                               NULL))) {
      char *realm;

      /* Locate realm part */
      if (realm=strchr(HostNameBuffer,':')) {
       /* Set string terminator */
       *realm='\0';

       /* Search Access object (with realm name) */
       tml=AddLinkTMObject(PrivateTMHandle,HostNameBuffer,TMOBJTYPE_ACCESS,
                               NULL);
      }
     }

    DEBUG_PRINTF("Host name: '%s'\n",HostNameBuffer);

    /* Object not found? */
    if (!tml)
     /* Search default Access object */
     tml=AddLinkTMObject(PrivateTMHandle,"anyone",TMOBJTYPE_ACCESS,NULL);

    DEBUG_PRINTF("Link: 0x%08lx\n",tml);

    /* Object found? */
    if (tml) {
     /* Yes, activate Access object */
     CallActivateTMObject(tml,trans->trans_RequestData);

     /* Remove link */
     RemLinkTMObject(tml);

     /* All OK (hope so :-) */
     errcode=ENVOYERR_NOERROR;
    }

    /* Reply transaction */
    trans->trans_Error=errcode;
    ReplyTransaction(trans);
   }
  }

  /* Got a command from the library interface? */
  if (gotsigs & lpsig) {
   struct TMHandle *handle;

   /* Empty message queue */
   while (handle=(struct TMHandle *) GetMsg(LibraryPort)) {
    BOOL rc=FALSE;

    DEBUG_PRINTF("Got command (%1lx)\n",handle->tmh_Command);

    /* What command did we receive? */
    switch (handle->tmh_Command) {
     case TMIPC_AllocTMHandle:  rc=InternalAllocTMHandle(handle);
                                break;

     case TMIPC_FreeTMHandle:   rc=InternalFreeTMHandle(handle);
                                break;

     case TMIPC_CreateTMObject: rc=InternalCreateTMObject(handle,
                                                          handle->tmh_Object,
                                                          handle->tmh_Type,
                                                          handle->tmh_Tags);
                                break;

     case TMIPC_DeleteTMObject: rc=InternalDeleteTMObject(handle,
                                                          handle->tmh_Object);
                                break;

     case TMIPC_ChangeTMObject: rc=InternalChangeTMObject(handle,
                                                          handle->tmh_Object,
                                                          handle->tmh_Tags);
                                break;
    }

    /* Reply message */
    handle->tmh_Command=rc;
    DEBUG_PRINTF("Command reply (%1lx)\n",handle->tmh_Command);
    ReplyMsg((struct Message *) handle);
   }
  }

  /* Got a configuration file notification event? */
  if (gotsigs & npsig) {

   DEBUG_PRINTF("Preferences changed!\n");

   /* Free old config */
   InternalFreeTMHandle(PrivateTMHandle);
   FreeConfig();

   /* Read new config */
   ReadConfig();
  }

  /* Got a Workbench Close/Open event? */
  if (gotsigs & scsig) {
   struct ScreenNotifyMessage *snm;

   DEBUG_PRINTF("ScreenNotify event!\n");

   /* Retrieve message from port */
   while (snm = (struct ScreenNotifyMessage *) GetMsg(ScreenNotifyPort)) {

    /* Which event? */
    switch (snm->snm_Type) {
     case SCREENNOTIFY_TYPE_CLOSESCREEN:
      ScreenCloseEvent(snm->snm_Value);
      break;

     case SCREENNOTIFY_TYPE_PUBLICSCREEN:
      ScreenOpenEvent(((struct PubScreenNode *) snm->snm_Value)->psn_Node.ln_Name);
      break;

     case SCREENNOTIFY_TYPE_PRIVATESCREEN:
      ScreenCloseEvent(((struct PubScreenNode *) snm->snm_Value)->psn_Screen);
      break;

     case SCREENNOTIFY_TYPE_WORKBENCH:
      /* Close or open event? */
      switch (snm->snm_Value) {
       case FALSE: {            /* Close event */
         struct Screen *s;

         /* Lock Workbench screen */
         if (s = LockPubScreen(WBName)) {
          /* Close docks */
          ScreenCloseEvent(s);

          /* Unlock Workbench screen */
          UnlockPubScreen(NULL, s);
         }
        }
        break;

       case TRUE:               /* Open event */
        ScreenOpenEvent(WBName);
        break;
      }
      break;
    }

    /* Reply message */
    ReplyMsg((struct Message *) snm);
   }
  }
 }

 /* Deactivate broker */
 ActivateCxObj(Broker,FALSE);

 /* Free config buffers */
 InternalFreeTMHandle(PrivateTMHandle);
 FreeConfig();

 /* Free all resources &  Reset closing flag */
 DEBUG_PUTSTR("Handler signing off...\n")
/* Forbid(); */
 FreeResources();
 Closing=FALSE;
}
