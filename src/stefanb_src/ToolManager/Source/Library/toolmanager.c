/*
 * toolmanager.c  V3.1
 *
 * Library routines
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

/*
 * Object file dummy entry point
 */
static ULONG Dummy(void)
{
 return(0);
}

/* library name and ID string */
#define INTTOSTR(a) #a
static const char LibraryName[] = TMLIBNAME;
static const char LibraryID[]   = "$VER: " TMLIBNAME " " INTTOSTR(TMLIBVERSION)
                                  "." INTTOSTR(TMLIBREVISION) " ("
                                  __COMMODORE_DATE__ ")";

/* Constant strings */
const char DosName[] = "dos.library";

/* Standard library function prototypes */
__geta4 static struct Library *LibraryInit(__A0 BPTR, __A6 struct Library *);
__geta4 static struct Library *LibraryOpen(__A6 struct ToolManagerBase *);
__geta4 static BPTR            LibraryClose(__A6 struct ToolManagerBase *);
__geta4 static BPTR            LibraryExpunge(__A6 struct ToolManagerBase *);
        static ULONG           LibraryReserved(void);

/* Library specific function prototypes */
__geta4 static void            QuitToolManager(void);
__geta4 struct TMHandle       *AllocTMHandle(__A6 struct ToolManagerBase *);
__geta4 static void            FreeTMHandle(__A0 struct TMHandle *);
__geta4 static BOOL            CreateTMObjectTagList(__A0 struct TMHandle *,
                                                     __A1 char *, __D0 ULONG,
                                                     __A2 struct TagItem *);
__geta4 static BOOL            DeleteTMObject(__A0 struct TMHandle *,
                                              __A1 char *);
__geta4 static BOOL            ChangeTMObjectTagList(__A0 struct TMHandle *,
                                                     __A1 char *,
                                                     __A2 struct TagItem *);

/* ROMTag structure */
static const struct Resident ROMTag = { RTC_MATCHWORD, &ROMTag, &ROMTag + 1, 0,
 TMLIBVERSION, NT_LIBRARY, 0, LibraryName, LibraryID, LibraryInit
};

/* Library functions table */
static const APTR LibraryVectors[] = {
 /* Standard functions */
 (APTR) LibraryOpen,
 (APTR) LibraryClose,
 (APTR) LibraryExpunge,
 (APTR) LibraryReserved,

 /* Library specific functions */
 (APTR) LibraryReserved, /* reserved for ARexx */
 (APTR) QuitToolManager,
 (APTR) AllocTMHandle,
 (APTR) FreeTMHandle,
 (APTR) CreateTMObjectTagList,
 (APTR) DeleteTMObject,
 (APTR) ChangeTMObjectTagList,

 /* End of table */
 (APTR) -1
};

/* Handler process creation data */
static const struct TagItem TMHandlerTags[] = {
 NP_Entry,       (ULONG) ToolManagerHandler,
 NP_CurrentDir,  NULL,
 NP_Name,        (ULONG) TMHANDLERNAME,
 NP_Priority,    0,
 NP_ConsoleTask, NULL,
 NP_WindowPtr,   NULL,
 NP_HomeDir,     NULL,
 TAG_DONE
};

/* Library bases */
struct Library         *SysBase;
struct ToolManagerBase *ToolManagerBase;

/* Initialize library */
#define DEBUGFUNCTION LibraryInit
__geta4 static struct Library *LibraryInit(__A0 BPTR Segment,
                                           __A6 struct Library *ExecBase)
{
 struct ToolManagerBase *tmb;

 /* Initialize SysBase */
 SysBase = ExecBase;

 if (tmb = (struct ToolManagerBase *) MakeLibrary(LibraryVectors, NULL, NULL,
                                                sizeof(struct ToolManagerBase),
                                                NULL)) {

  /* Initialize libray structure */
  tmb->tmb_Library.lib_Node.ln_Type = NT_LIBRARY;
  tmb->tmb_Library.lib_Node.ln_Name = LibraryName;
  tmb->tmb_Library.lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
  tmb->tmb_Library.lib_Version      = TMLIBVERSION;
  tmb->tmb_Library.lib_Revision     = TMLIBREVISION;
  tmb->tmb_Library.lib_IdString     = (APTR) LibraryID;
  tmb->tmb_State                    = TMHANDLER_INACTIVE;
  tmb->tmb_Segment                  = Segment;
  tmb->tmb_Port                     = NULL;

  /* Add the library to the system */
  AddLibrary((struct Library *) tmb);

  /* Set global Library base pointer */
  ToolManagerBase = tmb;

  INFORMATION_LOG(KPutStr("\n+++\n\n"))
  INFORMATION_LOG(LOG2(Result, "Base %08lx Segment %08lx\n", tmb, Segment))
 }

 return((struct Library *) tmb);
}

/* Standard library function: Open */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION LibraryOpen
__geta4 static struct Library *LibraryOpen(__A6 struct ToolManagerBase *tmb)
{
 struct Library *rc = NULL;

 INITDEBUG(ToolManagerLibDebug)

 /* Is handler not just closing down? */
 if (tmb->tmb_State != TMHANDLER_LEAVING) {

  /* Is handler inactive? */
  if (tmb->tmb_State == TMHANDLER_INACTIVE) {
   struct Library *DOSBase;

   /* Yes, start it. First open DOS library */
   if (DOSBase = OpenLibrary(DosName, 39)) {

    /* Handler is starting now */
    tmb->tmb_State = TMHANDLER_STARTING;

    if ((tmb->tmb_Process = CreateNewProc(TMHandlerTags)) == NULL) {

     HANDLER_LOG(LOG0(Handler startup failed))

     /* Handler startup failed. Return to inactive state */
     tmb->tmb_State = TMHANDLER_INACTIVE;
    }

#ifdef DEBUG
    else {
     INFORMATION_LOG(KPutStr("\n---\n\n"))
     HANDLER_LOG(LOG0(Handler started))
    }
#endif

    /* Close DOS library */
    CloseLibrary(DOSBase);
   }
  }

  /* Is handler active? */
  if (tmb->tmb_State != TMHANDLER_INACTIVE) {

   /* Oh another user :-) */
   tmb->tmb_Library.lib_OpenCnt++;

   /* Reset delayed expunge flag */
   tmb->tmb_Library.lib_Flags &= ~LIBF_DELEXP;

   /* All OK! */
   rc = (struct Library *) tmb;

   INTERFACE_LOG(LOG1(Count, "%ld", tmb->tmb_Library.lib_OpenCnt))
  }
 }

 return(rc);
}

/* Standard library function: Close */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION LibraryClose
__geta4 static BPTR LibraryClose(__A6 struct ToolManagerBase *tmb)
{
 BPTR rc = NULL;

 /* Open count greater zero and only one user? */
 if ((tmb->tmb_Library.lib_OpenCnt > 0) &&
     (--tmb->tmb_Library.lib_OpenCnt == 0)) {

  INTERFACE_LOG(LOG1(Count, "%ld", tmb->tmb_Library.lib_OpenCnt))

  /* Last user closed the library. Was handler ordered to shut down? */
  if (tmb->tmb_State == TMHANDLER_CLOSING) {

   HANDLER_LOG(LOG0(Handler leaving))

   /* Yes, change state */
   tmb->tmb_State = TMHANDLER_LEAVING;

   /* Send handler a signal to shut him down */
   Signal(&tmb->tmb_Process->pr_Task, SIGBREAKF_CTRL_F);
  }

  /* Is the delayed expunge bit set?  Yes, try to remove the library */
  if (tmb->tmb_Library.lib_Flags & LIBF_DELEXP) rc = LibraryExpunge(tmb);
 }

 return(rc);
}

/* Standard library function: Expunge */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION LibraryExpunge
__geta4 static BPTR LibraryExpunge(__A6 struct ToolManagerBase *tmb)
{
 BPTR rc;

 INTERFACE_LOG(LOG2(Arguments, "Library %08lx Segment %08lx",
                    tmb, tmb->tmb_Segment))

 /* Does anyone use library now or is handler active? */
 if ((tmb->tmb_Library.lib_OpenCnt > 0) ||
     (tmb->tmb_State != TMHANDLER_INACTIVE)) {

  /* Yes, library still in use -> set delayed expunge flag */
  tmb->tmb_Library.lib_Flags |= LIBF_DELEXP;

  /* Don't expunge library */
  rc = NULL;

 } else {
  /* No, remove library */
  Remove(&tmb->tmb_Library.lib_Node);

  /* Return BPTR to Library segment */
  rc = tmb->tmb_Segment;

  /* Free memory for library base */
  FreeMem((void *) ((ULONG) tmb - tmb->tmb_Library.lib_NegSize),
          tmb->tmb_Library.lib_NegSize + tmb->tmb_Library.lib_PosSize);

  INFORMATION_LOG(LOG0(Removing library))
 }

 return(rc);
}

/* Reserved function, returns NULL */
static ULONG LibraryReserved(void)
{
 return(NULL);
}

/* Set quit flag for handler process */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION QuitToolManager
__geta4 static void QuitToolManager(void)
{
 /* Is handler active? */
 if (ToolManagerBase->tmb_State == TMHANDLER_RUNNING) {

  HANDLER_LOG(LOG0(Handler closing))

  /* Yes, order him to shut down ASAP */
  ToolManagerBase->tmb_State = TMHANDLER_CLOSING;
 }
}

/* Send IPC message */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SendIPC
static BOOL SendIPC(struct TMHandle *tmh)
{
 BOOL rc = FALSE;

 INTERFACE_LOG(LOG0(Sending command))

 /* Handler ready? */
 if (ToolManagerBase->tmb_Port) {

  INTERFACE_LOG(LOG0(Handler ready))

  /* Yep, send message */
  PutMsg(ToolManagerBase->tmb_Port, (struct Message *) tmh);

  /* Wait on reply */
  WaitPort(tmh->tmh_Message.tmm_Msg.mn_ReplyPort);

  /* Get reply */
  GetMsg(tmh->tmh_Message.tmm_Msg.mn_ReplyPort);

  /* Get return code */
  rc = tmh->tmh_Message.tmm_Command;
 }

 return(rc);
}

/* Allocate a TMHandle */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AllocTMHandle
__geta4 void *AllocTMHandle(__A6 struct ToolManagerBase *tmb)
{
 struct TMHandle *tmh;

 INTERFACE_LOG(LOG0(Entry))

 /* Allocate memory for handle structure */
 if (tmh = AllocMem(sizeof(struct TMHandle), MEMF_PUBLIC)) {
  struct MsgPort *rp;
  BOOL rc            = FALSE;

  INTERFACE_LOG(LOG1(Handle, "0x%08lx", tmh))

  /* Create IPC Port */
  if (rp = CreateMsgPort()) {

   INTERFACE_LOG(LOG1(Port, "0x%08lx", rp))

   /* Initialize message */
   tmh->tmh_Message.tmm_Msg.mn_ReplyPort = rp;
   tmh->tmh_Message.tmm_Msg.mn_Length    = sizeof(struct TMHandle);
   tmh->tmh_Message.tmm_Command          = TMIPC_AllocTMHandle;

   /* Check that the handler is already awake */
   if (tmb->tmb_State != TMHANDLER_RUNNING) {
    ULONG delay = 25;

    INTERFACE_LOG(LOG0(Waiting for handler to start))

    /* Wait up to 5 second for handler to be ready */
    while (delay-- && (tmb->tmb_State != TMHANDLER_RUNNING)) Delay(10);
   }

   /* Send command to handler */
   if ((tmb->tmb_State == TMHANDLER_RUNNING) && ((rc = SendIPC(tmh)) == FALSE))

    /* Something went wrong, free message port */
    DeleteMsgPort(rp);
  }

  /* Error? */
  if (rc == FALSE) {
   FreeMem(tmh, sizeof(struct TMHandle));
   tmh = NULL;
  }
 }

 INTERFACE_LOG(LOG1(Result, "Handle 0x%08lx", tmh))

 return(tmh);
}

/* Free a TMHandle */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeTMHandle
__geta4 static void FreeTMHandle(__A0 struct TMHandle *tmh)
{
 INTERFACE_LOG(LOG1(Arguments, "Handle 0x%08lx", tmh))

 /* Sanity check */
 if (tmh) {

  /* Send command to handler */
  tmh->tmh_Message.tmm_Command = TMIPC_FreeTMHandle;
  SendIPC(tmh);

  /* Free handle */
  DeleteMsgPort(tmh->tmh_Message.tmm_Msg.mn_ReplyPort);
  FreeMem(tmh, sizeof(struct TMHandle));
 }
}

/* Create a TMObject (shared library version) */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateTMObjectTagList
__geta4 BOOL CreateTMObjectTagList(__A0 struct TMHandle *tmh,
                                   __A1 char *object,
                                   __D0 ULONG type,
                                   __A2 struct TagItem *tags)
{
 BOOL rc = FALSE;

 INTERFACE_LOG((LOG5(Arguments,
                 "Handle 0x%08lx Object '%s' (0x%08lx) Type %ld Tags 0x%08lx",
                 tmh, object, object, type, tags),
                PrintTagList(tags)))

 /* Sanity checks */
 if (tmh && object && (type < TMOBJTYPES)) {

  /* Build IPC command */
  tmh->tmh_Message.tmm_Command = TMIPC_CreateTMObject;
  tmh->tmh_Message.tmm_Type    = type;
  tmh->tmh_Message.tmm_Object  = object;
  tmh->tmh_Message.tmm_Tags    = tags;

  /* Send command to handler */
  rc = SendIPC(tmh);
 }

 INTERFACE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Delete a TMObject (shared library version) */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteTMObject
__geta4 BOOL DeleteTMObject(__A0 struct TMHandle *tmh, __A1 char *object)
{
 BOOL rc = FALSE;

 INTERFACE_LOG(LOG3(Arguments, "Handle 0x%08lx Object '%s' (0x%08lx) ",
                    tmh, object, object))

 /* Sanity checks */
 if (tmh && object) {

  /* Build IPC command */
  tmh->tmh_Message.tmm_Command = TMIPC_DeleteTMObject;
  tmh->tmh_Message.tmm_Object  = object;

  /* Send command to handler */
  rc = SendIPC(tmh);
 }

 INTERFACE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Change a TMObject (shared library version) */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ChangeTMObjectTagList
__geta4 BOOL ChangeTMObjectTagList(__A0 struct TMHandle *tmh,
                                   __A1 char *object,
                                   __A2 struct TagItem *tags)
{
 BOOL rc = FALSE;

 INTERFACE_LOG((LOG4(Arguments,
                     "Handle 0x%08lx Object '%s' (0x%08lx) Tags 0x%08lx",
                     tmh, object, object, tags),
                PrintTagList(tags)))

 /* Sanity checks */
 if (tmh && object) {

  /* Build IPC command */
  tmh->tmh_Message.tmm_Command = TMIPC_ChangeTMObject;
  tmh->tmh_Message.tmm_Object  = object;
  tmh->tmh_Message.tmm_Tags    = tags;

  /* Send command to handler */
  rc = SendIPC(tmh);
 }

 INTERFACE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Try to kill ToolManager */
void QuitTM(void);
#pragma libcall DummyBase QuitTM 24 00
void KillToolManager(void)
{
 struct Library *DummyBase;

 /* Open library */
 if (DummyBase = OpenLibrary(LibraryName, 0)) {

  /* Tell ToolManager to quit */
  QuitTM();

  /* Close library */
  CloseLibrary(DummyBase);
 }
}
