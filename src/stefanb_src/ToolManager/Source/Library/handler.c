/*
 * handler.c  V3.1
 *
 * ToolManager handler main loop
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
struct Library *DOSBase                        = NULL;
struct Library *GfxBase                        = NULL;
struct Library *IntuitionBase                  = NULL;
struct Library *UtilityBase                    = NULL;
Class          *ToolManagerClasses[TMOBJTYPES] = { NULL, NULL, NULL, NULL,
                                                   NULL, NULL, NULL };
Class          *ToolManagerGroupClass          = NULL;
Class          *ToolManagerButtonClass         = NULL;
Class          *ToolManagerEntryClass          = NULL;

/* Local data */
static struct TMHandle *InternalTMHandle     = NULL;
static Class           *ToolManagerBaseClass = NULL;
static LONG             LowMemorySignal      = -1;
static LONG             IDCMPSignal          = -1;
static LONG             BrokerSignal         = -1;
static LONG             AppMessagesSignal    = -1;
static LONG             NetworkSignal        = -1;
static LONG             ScreenNotifySignal   = -1;
static LONG             IPCSignal            = -1;
static LONG             NotifySignal         = -1;

/* Allocate resources */
static BOOL GetResources(void)
{
 return(/* Libraries */
        (DOSBase       = OpenLibrary(DosName,               39)) &&
        (GfxBase       = OpenLibrary("graphics.library",    39)) &&
        (IntuitionBase = OpenLibrary("intuition.library",   39)) &&
        (UtilityBase   = OpenLibrary("utility.library",     39)) &&

        /* Workbench path */
        GetWorkbenchPath() &&

        /* Memory management */
        InitMemory() &&

        /* Classes */
        (ToolManagerBaseClass = CreateBaseClass()) &&
        (ToolManagerClasses[TMOBJTYPE_EXEC] =
                                     CreateExecClass(ToolManagerBaseClass)) &&
        (ToolManagerClasses[TMOBJTYPE_IMAGE] =
                                     CreateImageClass(ToolManagerBaseClass)) &&
        (ToolManagerClasses[TMOBJTYPE_SOUND] =
                                     CreateSoundClass(ToolManagerBaseClass)) &&
        (ToolManagerClasses[TMOBJTYPE_MENU] =
                                     CreateMenuClass(ToolManagerBaseClass)) &&
        (ToolManagerClasses[TMOBJTYPE_ICON] =
                                     CreateIconClass(ToolManagerBaseClass)) &&
        (ToolManagerClasses[TMOBJTYPE_DOCK] =
                                     CreateDockClass(ToolManagerBaseClass)) &&
        (ToolManagerGroupClass  = CreateGroupClass()) &&
        (ToolManagerButtonClass = CreateButtonClass()) &&
        (ToolManagerEntryClass  = CreateEntryClass()) &&

        /* Low memory warning */
        ((LowMemorySignal    = StartLowMemoryWarning())   != -1) &&

        /* IDCMP */
        ((IDCMPSignal        = StartIDCMP())              != -1) &&

        /* Commodities */
        ((BrokerSignal       = StartCommodities())        != -1) &&

        /* WB application messages */
        ((AppMessagesSignal  = StartAppMessages())        != -1) &&

        /* Networking */
        ((NetworkSignal      = StartNetwork())            != -1) &&

        /* ScreenNotify */
        ((ScreenNotifySignal = StartScreenNotify())       != -1) &&

        /* IPC Library <-> Handler */
        ((IPCSignal          = StartIPC())                != -1) &&

        /* Configuration file notification */
        ((NotifySignal       = StartConfigChangeNotify()) != -1) &&

        /* Misc. */
        (InternalTMHandle = GetMemory(sizeof(struct TMHandle))) &&
        (InitHandles(), InitToolManagerHandle(InternalTMHandle))
       );
}

/* Free resources */
static void FreeResources(void)
{
 int i;

 /* Misc. */
 if (InternalTMHandle) {
  DeleteToolManagerHandle(InternalTMHandle);
  FreeMemory(InternalTMHandle, sizeof(struct TMHandle));
  InternalTMHandle = NULL;
 }

 /* Free global parameters */
 FreeGlobalParameters();

 /* Configuration file notification */
 if (NotifySignal != -1) {
  StopConfigChangeNotify();
  NotifySignal = -1;
 }

 /* IPC */
 if (IPCSignal != -1) {
  StopIPC();
  IPCSignal = -1;
 }

 /* ScreenNotify */
 if (ScreenNotifySignal != -1) {
  StopScreenNotify();
  ScreenNotifySignal = -1;
 }

 /* Networking */
 if (NetworkSignal != -1) {
  StopNetwork();
  NetworkSignal = -1;
 }

 /* WB application messages */
 if (AppMessagesSignal != -1) {
  StopAppMessages();
  AppMessagesSignal = -1;
 }

 /* Commodities */
 if (BrokerSignal != -1) {
  StopCommodities();
  BrokerSignal = -1;
 }

 /* IDCMP */
 if (IDCMPSignal != -1) {
  StopIDCMP();
  IDCMPSignal = -1;
 }

 /* Low memory warning */
 if (LowMemorySignal != -1) {
  StopLowMemoryWarning();
  LowMemorySignal = -1;
 }

 /* Classes */
 if (ToolManagerEntryClass) {
  FreeClass(ToolManagerEntryClass);
  ToolManagerEntryClass = NULL;
 }
 if (ToolManagerButtonClass) {
  FreeClass(ToolManagerButtonClass);
  ToolManagerButtonClass = NULL;
 }
 if (ToolManagerGroupClass) {
  FreeClass(ToolManagerGroupClass);
  ToolManagerGroupClass = NULL;
 }
 for (i = TMOBJTYPES - 1; i >= 0; i--)
  if (ToolManagerClasses[i]) {
   FreeClass(ToolManagerClasses[i]);
   ToolManagerClasses[i] = NULL;
  }
 if (ToolManagerBaseClass) {
  FreeClass(ToolManagerBaseClass);
  ToolManagerBaseClass = NULL;
 }

 /* Memory management */
 DeleteMemory();

 /* Workbench path */
 FreeWorkbenchPath();

 /* Libraries */
 if (UtilityBase) {
  CloseLibrary(UtilityBase);
  UtilityBase = NULL;
 }
 if (IntuitionBase) {
  CloseLibrary(IntuitionBase);
  IntuitionBase = NULL;
 }
 if (GfxBase) {
  CloseLibrary(GfxBase);
  GfxBase = NULL;
 }
 if (DOSBase) {
  CloseLibrary(DOSBase);
  DOSBase = NULL;
 }
}

/* ToolManager Handler entry point */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ToolManagerHandler
__geta4 void ToolManagerHandler(void)
{
#ifdef DEBUG
 /* Store original state */
 ULONG OldSigAlloc = FindTask(NULL)->tc_SigAlloc;
#endif

 HANDLER_LOG(LOG0(Handler starting))

 /* Start localization */
 StartLocale();

 /* Allocate resources */
 if (GetResources()) {
  ULONG memmask;
  ULONG winmask;
  ULONG brkmask;
  ULONG apmmask;
  ULONG ntwmask;
  ULONG scnmask;
  ULONG ipcmask;
  ULONG cfnmask;
  ULONG sigmask;
  BOOL  configactive = FALSE;

  HANDLER_LOG(LOG0(Handler running))

  /* Announce IPC port */
  ToolManagerBase->tmb_Port = GetIPCPort();

  /* Set handler state to running */
  ToolManagerBase->tmb_State = TMHANDLER_RUNNING;

  /* Initialize signal masks */
  memmask = (1 << LowMemorySignal);
  winmask = (1 << IDCMPSignal);
  brkmask = (1 << BrokerSignal);
  apmmask = (1 << AppMessagesSignal);
  ntwmask = (1 << NetworkSignal);
  scnmask = (1 << ScreenNotifySignal);
  ipcmask = (1 << IPCSignal);
  cfnmask = (1 << NotifySignal);
  sigmask = memmask | winmask | brkmask | apmmask | ntwmask | scnmask |
            ipcmask | cfnmask |
            SIGBREAKF_CTRL_F;

  /* Main event loop */
  while (ToolManagerBase->tmb_State != TMHANDLER_LEAVING) {
   ULONG signals;

   /* If configuration is not active, then wait on next event  */
   /* Otherwise use Wait() only if some of our signals are set */
   if ((configactive == FALSE) || (signals = SetSignal(0, 0) & sigmask))

    /* Read and clear signals */
    signals = Wait(sigmask);

   HANDLER_LOG(LOG1(Wait, "Signals 0x%08lx", signals))

   /* Low memory warning? */
   if (signals & memmask) HandleLowMemory();

   /* IDCMP event? */
   if (signals & winmask) HandleIDCMP();

   /* Commodities event? */
   if (signals & brkmask) HandleCommodities();

   /* WB application message event? */
   if (signals & apmmask) HandleAppMessages();

   /* Network event ? */
   if (signals & ntwmask) HandleNetwork();

   /* ScreenNotify event? */
   if (signals & scnmask) HandleScreenNotify();

   /* Message from library routines? */
   if (signals & ipcmask) HandleIPC();

   /* Configuration file changed? */
   if (signals & cfnmask) {

    /* Yes, delete old configuration */
    DeleteToolManagerHandle(InternalTMHandle);

    /* Initialize TMHandle for new objects */
    InitToolManagerHandle(InternalTMHandle);

    /* Start to read the new configuration */
    configactive = HandleConfigChange();
   }

   /* If configuration is active then parse next configuration element */
   if (configactive) configactive = NextConfigParseStep(InternalTMHandle);
  }

  /* Remove IPC Port */
  ToolManagerBase->tmb_Port = NULL;
 }

 HANDLER_LOG(LOG0(Handler leaving))

 /* Free Resources */
 FreeResources();

 /* Stop localization */
 StopLocale();

#ifdef DEBUG
 /* Check allocated signals */
 if (OldSigAlloc ^= FindTask(NULL)->tc_SigAlloc) {

  /* Print remaining allocated signal bits */
  ERROR_LOG(LOG1(Unfreed signals, "0x%08lx", OldSigAlloc))

 } else {

  INFORMATION_LOG(LOG0(All signals released))
 }
#endif

 /* Shut down handler */
 Forbid();
 ToolManagerBase->tmb_State = TMHANDLER_INACTIVE;
}
