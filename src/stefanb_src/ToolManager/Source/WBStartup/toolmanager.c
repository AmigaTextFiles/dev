/*
 * toolmanager.c  V3.1
 *
 * ToolManager starter
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

#ifdef DEBUG
/* Global data */
struct Library *SysBase = NULL; /* For debugging routines */
#endif

/* Local function prototypes */
static int Starter(void);

/* Entry point (first in code hunk) */
static __geta4 int Entry(void)
{
 /* Call the real code */
 return(Starter());
}

/* Local data (second in code hunk) */
static const struct TagItem CatalogParams[] = {
 OC_BuiltInLanguage, (ULONG) "english",
 OC_Version,         TMCATALOGVERSION,
 TAG_DONE
};
static const char VersionString[]           = "$VER: ToolManager_Starter "
                                              TMVERSION
                                              " (" __COMMODORE_DATE__ ")";
static struct EasyStruct Requester          = {
 sizeof(struct EasyStruct), 0, "ToolManager",
 LOCALE_WBSTARTUP_REQUESTER_TEXT_STR, LOCALE_WBSTARTUP_REQUESTER_GADGET_STR
};

/* The real code */
#define DEBUGFUNCTION Starter
static int Starter(void)
{
#ifndef DEBUG
 struct Library *SysBase;          /* For production code */
#endif
 struct Message *WBStartup       = NULL;
 struct Task    *HandlerTask;
 struct Library *ToolManagerBase;
 ULONG           rc              = RETURN_FAIL;

 /* Initialize SysBase */
 SysBase = *((struct Library **) 4);

 /* Retrieve Workbench startup message */
 {
  struct Process *pr = (struct Process *) FindTask(NULL);

  /* Started from CLI or Workbench? */
  if (pr->pr_CLI == NULL) {

   /* Started from Workbench, wait for the startup message */
   WaitPort(&pr->pr_MsgPort);

   /* Retrieve message */
   WBStartup = GetMsg(&pr->pr_MsgPort);
  }
 }

 INITDEBUG(ToolManagerStarterDebug)

 /* Find ToolManager handler task */
 Forbid();
 HandlerTask = FindTask(TMHANDLERNAME);
 Permit();

 MAIN_LOG(LOG1(Handler Task, "0x%08lx", HandlerTask))

 /* Now open the toolmanager library */
 if (ToolManagerBase = OpenLibrary(TMLIBNAME, 0)) {

  MAIN_LOG(LOG1(ToolManager Library, "0x%08lx", ToolManagerBase))

  /* Reset error code */
  rc = RETURN_OK;

  /* Handler active? Yes, call quit function */
  if (HandlerTask) {
   BOOL quit = TRUE;

   MAIN_LOG(LOG0(Handler active -> stop it))

   /* Was our process started from CLI or Workbench? */
   if (WBStartup) {
    struct Library *IntuitionBase;

    MAIN_LOG(LOG0(Started from Workbench))

    /* We were started from Workbench -> Create an Intuition EasyRequest */
    if (IntuitionBase = OpenLibrary("intuition.library", 39)) {
     struct Library *LocaleBase;
     struct Catalog *Catalog;

     MAIN_LOG(LOG1(Intuition Library, "0x%08lx", IntuitionBase))

     /* Try to open locale.library */
     if (LocaleBase = OpenLibrary("locale.library", 38)) {
      MAIN_LOG(LOG1(Locale Library, "0x%08lx", LocaleBase))

      /* Try to get catalog for current language */
      if (Catalog = OpenCatalogA(NULL, TMCATALOGNAME, CatalogParams)) {

       MAIN_LOG(LOG1(Catalog, "0x%08lx", Catalog))

       /* Localize strings */
       Requester.es_TextFormat   = GetCatalogStr(
                                             Catalog,
                                             LOCALE_WBSTARTUP_REQUESTER_TEXT,
                                             Requester.es_TextFormat);
       Requester.es_GadgetFormat = GetCatalogStr(
                                             Catalog,
                                             LOCALE_WBSTARTUP_REQUESTER_GADGET,
                                             Requester.es_GadgetFormat);
      }
     }

     MAIN_LOG(LOG0(Showing requester))

     /* Show requester */
     quit = EasyRequestArgs(NULL, &Requester, NULL, NULL) ? TRUE : FALSE;

     /* Locale library open? */
     if (LocaleBase) {

      /* Yes, free catalog */
      if (Catalog) CloseCatalog(Catalog);

      /* Close library */
      CloseLibrary(LocaleBase);
     }

     /* Close Intution */
     CloseLibrary(IntuitionBase);
    }
   }

   MAIN_LOG(LOG1(Stopping handler, "%ld", quit))

   /* Should we stop the handler? */
   if (quit) QuitToolManager();
  }

  /* Close library again */
  CloseLibrary(ToolManagerBase);
 }

 MAIN_LOG(LOG1(Result, "%ld", rc))

 /* Workbench startup message valid? */
 if (WBStartup) {

  /* Yes, disable multitasking */
  Forbid();

  /* Reply message */
  ReplyMsg(WBStartup);
 }

 return(rc);
}
