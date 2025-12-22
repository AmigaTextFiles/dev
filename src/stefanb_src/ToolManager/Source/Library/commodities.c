/*
 * commodities.c  V3.1
 *
 * ToolManager commodities handling routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Global data */
const char ToolManagerName[] = "ToolManager";

/* Local data */
static struct Library   *CxBase;
static struct MsgPort   *BrokerPort;
static struct CxObj     *Broker;
static struct NewBroker  BrokerData = {
 NB_VERSION, ToolManagerName,
 "ToolManager V" TMVERSION " © " TMCOPYRIGHTYEAR " Stefan Becker", NULL,
 NBU_UNIQUE, 0, 0, NULL, 0
};

/* Activate commodities */
#define DEBUGFUNCTION StartCommodities
LONG StartCommodities(void)
{
 LONG rc = -1;

 COMMODITIES_LOG(LOG0(Entry))

 /* Open commodities.library */
 if (CxBase = OpenLibrary("commodities.library", 39)) {

  COMMODITIES_LOG(LOG1(Library, "0x%08lx", CxBase))

  /* Create broker port */
  if (BrokerPort = CreateMsgPort()) {

   COMMODITIES_LOG(LOG1(Port, "0x%08lx", BrokerPort))

   /* Set broker port */
   BrokerData.nb_Port = BrokerPort;

   /* Localize broker description */
   BrokerData.nb_Descr = TranslateString(LOCALE_LIBRARY_COMMODITIES_STR,
                                         LOCALE_LIBRARY_COMMODITIES);

   /* Create broker */
   if (Broker = CxBroker(&BrokerData, NULL)) {

    COMMODITIES_LOG(LOG1(Broker, "0x%08lx", Broker))

    /* Activate broker */
    ActivateCxObj(Broker, TRUE);

    /* Return port signal */
    rc = BrokerPort->mp_SigBit;

   } else
    DeleteMsgPort(BrokerPort);
  }

  if (rc == -1) CloseLibrary(CxBase);
 }

 COMMODITIES_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Stop Commodities */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopCommodities
void StopCommodities(void)
{
 COMMODITIES_LOG(LOG3(Entry, "Broker 0x%08lx Port 0x%08lx CxBase 0x%08lx",
                      Broker, BrokerPort, CxBase))

 /* Deactivate broker */
 ActivateCxObj(Broker, FALSE);

 /* Delete commodities resources */
 DeleteCxObjAll(Broker);
 SafeDeleteMsgPort(BrokerPort);
 CloseLibrary(CxBase);
}

/* Handle commodities event */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleCommodities
void HandleCommodities(void)
{
 CxMsg *msg;

 COMMODITIES_LOG(LOG0(Entry))

 /* Empty message queue */
 while (msg = (CxMsg *) GetMsg(BrokerPort)) {

  COMMODITIES_LOG(LOG1(Event, "0x%08lx", CxMsgType(msg)))

  /* What type of Commodities event? */
  switch (CxMsgType(msg)) {
   case CXM_IEVENT:

    COMMODITIES_LOG(LOG1(Activating, "0x%08lx", CxMsgID(msg)))

    DoMethod((Object *) CxMsgID(msg), TMM_Activate, NULL);
    break;

   case CXM_COMMAND:

    /* Which commodities command? */
    switch (CxMsgID(msg)) {
     case CXCMD_DISABLE: ActivateCxObj(Broker, FALSE); break;
     case CXCMD_ENABLE:  ActivateCxObj(Broker, TRUE);  break;
     case CXCMD_KILL:    KillToolManager();            break;
     }
    break;
  }

  /* Reply message */
  ReplyMsg((struct Message *) msg);
 }
}

/* Create a commodities hotkey */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateHotKey
CxObj *CreateHotKey(const char *desc, Object *obj)
{
 CxObj *filter;
 CxObj *rc     = NULL;

 COMMODITIES_LOG(LOG3(Arguments, "Description '%s' (0x%08lx) Object 0x%08lx",
                      desc, desc, obj))

 /* Create dummy filter object */
 if (filter = CxFilter(desc)) {
  CxObj *sender;

  COMMODITIES_LOG(LOG1(Filter, "0x%08lx", filter))

  /* Create sender object */
  if (sender = CxSender(BrokerPort, obj)) {
   CxObj *translator;

   COMMODITIES_LOG(LOG1(Sender, "0x%08lx", sender))

   /* Attach sender to filter */
   AttachCxObj(filter, sender);

   /* Create a black hole translation object */
   if (translator = CxTranslate(NULL)) {

    COMMODITIES_LOG(LOG1(Translator, "0x%08lx", translator))

    /* Attach translator to filter */
    AttachCxObj(filter, translator);

    COMMODITIES_LOG(LOG1(Cx Error, "0x%08lx", CxObjError(filter)))

    /* Got a Commodities error? */
    if (CxObjError(filter) == 0) {

     /* Attach object to broker */
     AttachCxObj(Broker, filter);

     /* All OK */
     rc = filter;
    }
   }
  }

  /* Delete all CxObjects */
  if (rc == NULL) DeleteCxObjAll(filter);
 }

 COMMODITIES_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Delete a CxObject and remove all associated messages from the broker port */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SafeDeleteCxObjAll
void SafeDeleteCxObjAll(struct CxObj *cxobj, Object *obj)
{
 CxMsg *msg;

 COMMODITIES_LOG(LOG2(Arguments, "CxObj 0x%08lx Object 0x%08lx", cxobj, obj))

 /* Delete commodities object */
 DeleteCxObjAll(cxobj);

 /* Disable multi-tasking */
 Forbid();

 /* Scan message port list */
 msg = (CxMsg *) GetHead((struct MinList *) &BrokerPort->mp_MsgList);
 while (msg) {
  CxMsg *nextmsg = (CxMsg *) GetSucc((struct MinNode *) msg);

  /* Does the message point to this object? */
  if ((Object *) CxMsgID(msg) == obj) {

   /* Remove it from list */
   Remove((struct Node *) msg);

   /* Reply it */
   ReplyMsg((struct Message *) msg);
  }

  /* Next message */
  msg = nextmsg;
 }

 /* Enable multi-tasking */
 Permit();
}

/* Create and send an input event */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SendInputEvent
BOOL SendInputEvent(const char *desc)
{
 struct InputEvent *ie;
 BOOL               rc = FALSE;

 COMMODITIES_LOG(LOG2(Entry, "%s (0x%08lx)", desc, desc))

 /* Allocate memory for input event */
 if (ie = GetMemory(sizeof(struct InputEvent))) {
  static struct InputXpression  ParseBuffer = {IX_VERSION};

  COMMODITIES_LOG(LOG1(Event, "0x%08lx", ie))

  /* Parse description string */
  if (ParseIX(desc, &ParseBuffer) == 0) {

   COMMODITIES_LOG(LOG0(Parsed OK))

   /* Description OK, initialize input event */
   ie->ie_NextEvent    = NULL;
   ie->ie_Class        = ParseBuffer.ix_Class;
   ie->ie_SubClass     = 0;
   ie->ie_Code         = ParseBuffer.ix_Code;
   ie->ie_Qualifier    = ParseBuffer.ix_Qualifier;
   ie->ie_EventAddress = NULL;

   /* Set time stamp */
   CurrentTime(&ie->ie_TimeStamp.tv_secs, &ie->ie_TimeStamp.tv_micro);

   /* Enqueue event */
   AddIEvents(ie);

   /* All OK */
   rc = TRUE;
  }

  /* Free input event */
  FreeMemory(ie, sizeof(struct InputEvent));
 }

 return(rc);
}
