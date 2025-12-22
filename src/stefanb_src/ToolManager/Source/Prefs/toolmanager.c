/*
 * toolmanager.c  V3.1
 *
 * Preferences editor main entry point
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

/* Local function prototypes */
static int Preferences(void);

/* Entry point (first in code hunk) */
static __geta4 int Entry(void)
{
 /* Initialize SysBase */
 SysBase = *((struct Library **) 4);

 /* Call the real code */
 return(Preferences());
}

/* Version string */
static const char Version[] = "$VER: ToolManager " TMVERSION
                              " (" __COMMODORE_DATE__ ")";

/* Error requester */
static const struct EasyStruct ErrorRequester = {
 sizeof(struct EasyStruct), 0, "ToolManager Preferences",
 "Program initialization failed!", "OK"
};

/* CLI command line parameters */
static const char Template[] = "FROM,EDIT/S,USE/S,SAVE/S,CREATEICONS/S";
static struct {
 char *From;
 LONG  Edit;
 LONG  Use;
 LONG  Save;
 LONG  Icons;
} CmdLineParameters = { NULL, TRUE, FALSE, FALSE, FALSE};

/* Structure for stack swap */
#define STACKSIZE 8192 /* Minimum for MUI applications */
static struct StackSwapStruct MUIStack = { NULL, NULL, NULL };

/* Global data */
struct Library         *DOSBase                   = NULL;
struct Library         *IconBase                  = NULL;
struct Library         *IFFParseBase              = NULL;
struct Library         *IntuitionBase             = NULL;
struct Library         *MUIMasterBase             = NULL;
struct Library         *SysBase                   = NULL;
struct Library         *UtilityBase               = NULL;
struct MUI_CustomClass *MainWindowClass           = NULL;
struct MUI_CustomClass *GlobalClass               = NULL;
struct MUI_CustomClass *ListPanelClass            = NULL;
struct MUI_CustomClass *ListTreeClass             = NULL;
struct MUI_CustomClass *PopASLClass               = NULL;
struct MUI_CustomClass *DropAreaClass             = NULL;
struct MUI_CustomClass *EntryListClass            = NULL;
struct MUI_CustomClass *BaseClass                 = NULL;
struct MUI_CustomClass *ObjectClasses[TMOBJTYPES] = { NULL, NULL, NULL, NULL,
                                                      NULL, NULL, NULL };
struct MUI_CustomClass *GroupClass                = NULL;
struct MUI_CustomClass *ClipWindowClass           = NULL;
struct MUI_CustomClass *ClipListClass             = NULL;
char                   *ProgramName               = NULL;
ULONG                   CreateIcons               = TRUE;
const char              ConfigSaveName[]          = "ENVARC:" TMCONFIGNAME;
const char              ConfigUseName[]           = "ENV:"    TMCONFIGNAME;

/* AppMessage function */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION AppMessageFunction
__geta4 static ULONG AppMessageFunction(__a0 struct Hook *h,
                                        __a1 struct AppMessage **amp,
                                        __a2 Object *obj)
{
 /* Send AppEvent method to MainWindow */
 DoMethod(h->h_Data, TMM_AppEvent, *amp, obj);
}

/* Hook */
struct Hook AppMessageHook = {
 {NULL, NULL}, (void *) AppMessageFunction, NULL, NULL
};

/* Open minimum set of Libraries */
static BOOL OpenLibraries(void)
{
 return((DOSBase       = OpenLibrary("dos.library",       39)) &&
        (IconBase      = OpenLibrary("icon.library",      39)) &&
        (IntuitionBase = OpenLibrary("intuition.library", 39)));
}

/* Close libraries */
static void CloseLibraries(void)
{
 if (IntuitionBase) CloseLibrary(IntuitionBase);
 if (IconBase)      CloseLibrary(IconBase);
 if (DOSBase)       CloseLibrary(DOSBase);
}

/* Allocate full set of resources */
static BOOL GetEditResources(void)
{
 return(/* Libraries */
        (IFFParseBase  = OpenLibrary("iffparse.library",  39)) &&
        (MUIMasterBase = OpenLibrary("muimaster.library", 18)) &&
        (UtilityBase   = OpenLibrary("utility.library",   39)) &&

        /* Memory management */
        InitMemory() &&

        /* Classes */
        (MainWindowClass                 = CreateMainWindowClass()) &&
        (GlobalClass                     = CreateGlobalClass())     &&
        (ListPanelClass                  = CreateListPanelClass())  &&
        (ListTreeClass                   = CreateListTreeClass())   &&
        (PopASLClass                     = CreatePopASLClass())     &&
        (DropAreaClass                   = CreateDropAreaClass())   &&
        (EntryListClass                  = CreateEntryListClass())  &&
        (BaseClass                       = CreateBaseClass())       &&
        (ObjectClasses[TMOBJTYPE_EXEC]   = CreateExecClass())       &&
        (ObjectClasses[TMOBJTYPE_IMAGE]  = CreateImageClass())      &&
        (ObjectClasses[TMOBJTYPE_SOUND]  = CreateSoundClass())      &&
        (ObjectClasses[TMOBJTYPE_MENU]   = CreateMenuClass())       &&
        (ObjectClasses[TMOBJTYPE_ICON]   = CreateIconClass())       &&
        (ObjectClasses[TMOBJTYPE_DOCK]   = CreateDockClass())       &&
        (ObjectClasses[TMOBJTYPE_ACCESS] = CreateAccessClass())     &&
        (GroupClass                      = CreateGroupClass())      &&
        (ClipWindowClass                 = CreateClipWindowClass()) &&
        (ClipListClass                   = CreateClipListClass())
       );
}

/* Free resources */
static void FreeEditResources(void)
{
 int i;

 /* Free global data */
 FreeGlobalData();

 /* Classes */
 if (ClipListClass)     MUI_DeleteCustomClass(ClipListClass);
 if (ClipWindowClass)   MUI_DeleteCustomClass(ClipWindowClass);
 if (GroupClass)        MUI_DeleteCustomClass(GroupClass);
 for (i = TMOBJTYPE_ACCESS; i >= TMOBJTYPE_EXEC; i--)
  if (ObjectClasses[i]) MUI_DeleteCustomClass(ObjectClasses[i]);
 if (BaseClass)         MUI_DeleteCustomClass(BaseClass);
 if (EntryListClass)    MUI_DeleteCustomClass(EntryListClass);
 if (DropAreaClass)     MUI_DeleteCustomClass(DropAreaClass);
 if (PopASLClass)       MUI_DeleteCustomClass(PopASLClass);
 if (ListTreeClass)     MUI_DeleteCustomClass(ListTreeClass);
 if (ListPanelClass)    MUI_DeleteCustomClass(ListPanelClass);
 if (GlobalClass)       MUI_DeleteCustomClass(GlobalClass);
 if (MainWindowClass)   MUI_DeleteCustomClass(MainWindowClass);

 /* Memory management */
 DeleteMemory();

 /* Libraries */
 if (UtilityBase)   CloseLibrary(UtilityBase);
 if (MUIMasterBase) CloseLibrary(MUIMasterBase);
 if (IFFParseBase)  CloseLibrary(IFFParseBase);
}

/* Create program name from Workbench arguments */
static char *CreateProgramName(struct WBArg *wa)
{
 char *rc;

 /* Get memory for buffer */
 if (rc = GetVector(LENGTH_FILENAME))

  /* Workbench or CLI startup? */
  if ((wa ?

  /* Workbench, convert directory lock and add name */
            (NameFromLock(wa->wa_Lock, rc, LENGTH_FILENAME) &&
             AddPart(rc, wa->wa_Name, LENGTH_FILENAME)) :

  /* CLI, copy program name to buffer */
            GetProgramName(rc, LENGTH_FILENAME)) == FALSE) {

   /* Error, free buffer */
   FreeVector(rc);
   rc = NULL;
  }

 return(rc);
}

/* Copy configuration file */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CopyFile
static int CopyFile(const char *source, const char *dest)
{
 void *buffer;
 int   rc     = RETURN_FAIL;

 STARTUP_LOG(LOG2(Arguments, "Source %s Dest %s", source, dest))

 /* Allocate copy buffer */
 if (buffer = AllocMem(4096, MEMF_PUBLIC)) {
  BPTR in;

  STARTUP_LOG(LOG1(Buffer, "0x%08lx", buffer))

  /* Open source file */
  if (in = Open(source, MODE_OLDFILE)) {
   BPTR out;

   STARTUP_LOG(LOG1(Input, "0x%08lx", in))

   /* Open destination file */
   if (out = Open(dest, MODE_NEWFILE)) {
    LONG n;

    STARTUP_LOG(LOG1(Ouput, "0x%08lx", out))

    /* Copy file, read one block from source and write it to dest */
    while (((n = Read(in, buffer, 4096)) > 0) && (Write(out, buffer, n) == n));

    /* All bytes copied, that is the last read returned 0? */
    if (n == 0) rc = RETURN_OK;

    /* Close destination file */
    Close(out);
   }

   /* Close source file */
   Close(in);
  }

  /* Free copy buffer */
  FreeMem(buffer, 4096);
 }

 STARTUP_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Main entry point */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION main
static int Preferences(void)
{
 struct WBStartup *wbs = NULL;
 struct Process   *pr  = (struct Process *) FindTask(NULL);
 int               rc  = RETURN_FAIL;

 /* Started from CLI or Workbench? */
 if (pr->pr_CLI == NULL) {

  /* Started from Workbench, wait for startup message */
  WaitPort(&pr->pr_MsgPort);

  /* Retrieve message */
  wbs = (struct WBStartup *) GetMsg(&pr->pr_MsgPort);
 }

 /* Initialize debugging */
 INITDEBUG(ToolManagerPrefsDebug)

 /* Open minimum set of libraries */
 if (OpenLibraries()) {
  struct RDArgs     *rda    = NULL;
  BPTR               oldcd;
  struct DiskObject *dobj   = NULL;
  const char        *config = ConfigUseName;
  BOOL               edit   = FALSE;

  STARTUP_LOG(LOG0(Libraries opened))

  /* CLI or WB startup? */
  if (wbs) {

   /* Go to program directory */
   oldcd = CurrentDir(wbs->sm_ArgList->wa_Lock);

   /* Open program icon */
   if (dobj = GetDiskObject(wbs->sm_ArgList->wa_Name)) {
    char *value;

    /* Check for CREATEICONS tool type */
    if (value = FindToolType(dobj->do_ToolTypes, "CREATEICONS"))

     /* Get value */
     CreateIcons = MatchToolValue(value, "YES");

    /* Free icon */
    FreeDiskObject(dobj);
    dobj = NULL;
   }

   /* WB, read tool types from second icon */
   if (wbs->sm_NumArgs > 1) {

    STARTUP_LOG(LOG1(WBArg, "0x%08lx", &wbs->sm_ArgList[1]))

    /* Go to projects directory */
    CurrentDir(wbs->sm_ArgList[1].wa_Lock);

    /* Set configuration file name and get icon */
    if (dobj = GetDiskObjectNew(config = wbs->sm_ArgList[1].wa_Name)) {

     STARTUP_LOG(LOG1(Icon, "0x%08lx", dobj))

     /* USE switch ? */
     if (FindToolType(dobj->do_ToolTypes, "USE")) {

      STARTUP_LOG(LOG0(USE))

      /* Copy file to ENV: */
      rc = CopyFile(config, ConfigUseName);

     /* SAVE switch? */
     } else if (FindToolType(dobj->do_ToolTypes, "SAVE")) {

      STARTUP_LOG(LOG0(SAVE))

      /* Copy file to ENVARC: */
      rc = CopyFile(config, ConfigSaveName);

     /* Default is EDIT switch */
     } else
      edit = TRUE;
    }
   } else

    /* No second icon, edit is default */
    edit = TRUE;

  } else {

   /* CLI, read command line parameters */
   if (rda = ReadArgs(Template, (LONG *) &CmdLineParameters, NULL)) {

    STARTUP_LOG(LOG1(Command line, "0x%08lx", rda))

    /* Set configuration file name if specified */
    if (CmdLineParameters.From) config = CmdLineParameters.From;

    /* USE switch? */
    if (CmdLineParameters.Use) {

     STARTUP_LOG(LOG0(USE))

     /* Copy file to ENV: */
     rc = CopyFile(config, ConfigUseName);

    /* SAVE switch? */
    } else if (CmdLineParameters.Save) {

     STARTUP_LOG(LOG0(SAVE))

     /* Copy file to ENVARC: */
     rc = CopyFile(config, ConfigSaveName);

    /* Default is EDIT switch */
    } else
     edit        = TRUE;
     CreateIcons = CmdLineParameters.Icons;
   }
  }

  /* Start editing? */
  if (edit) {

   STARTUP_LOG(LOG0(Startup MUI application))

   /* Allocate minimum stack for a MUI application */
   if (MUIStack.stk_Lower = AllocMem(STACKSIZE, MEMF_PUBLIC)) {

    STARTUP_LOG(LOG0(Stack allocated))

    /* Init stack swap structure */
    MUIStack.stk_Upper   = (ULONG) MUIStack.stk_Lower + STACKSIZE;
    MUIStack.stk_Pointer = (APTR)  MUIStack.stk_Upper;

    /* Swap stacks */
    StackSwap(&MUIStack);

    /* Initialize locale */
    InitLocale();

    /* Allocate resources */
    if (GetEditResources()) {

     STARTUP_LOG(LOG0(Resources allocated))

     /* Allocate memory for program name */
     if (ProgramName = CreateProgramName(wbs ? wbs->sm_ArgList : NULL)) {
      Object *app, *win;

      STARTUP_LOG(LOG2(Program Name, "%s (0x%08lx)", ProgramName, ProgramName))

      if (app = ApplicationObject,
                 MUIA_Application_Title,       "ToolManagerPrefs",
                 MUIA_Application_Version,     Version,
                 MUIA_Application_Copyright,   TMCOPYRIGHTYEAR ", Stefan Becker",
                 MUIA_Application_Author,      "Stefan Becker",
                 MUIA_Application_Description, TextGlobalTitle,
                 MUIA_Application_Base,        "TOOLMANAGER",
                 MUIA_Application_HelpFile,    "ToolManager.guide",
                 MUIA_Application_SingleTask,
#ifdef DEBUG
                                               FALSE,
#else
                                               TRUE,
#endif
                 MUIA_Application_Window,      win =
                  NewObject(MainWindowClass->mcc_Class, NULL,
                 End,
                 MUIA_HelpNode,                "Top",
                End) {
       ULONG opened;

       STARTUP_LOG(LOG2(Application, "App 0x%08lx Win 0x%08lx", app, win))

       /* Initialize hook */
       AppMessageHook.h_Data = win;

       /* Open main window */
       SetAttrs(win, MUIA_Window_Open, TRUE, TAG_DONE);

       /* Get window open status */
       GetAttr(MUIA_Window_Open, win, &opened);

       /* Window open? */
       if (opened) {

        /* Reset return code */
        rc = RETURN_OK;

        STARTUP_LOG(LOG0(Window opened))

        /* Tell main window to load configuration */
        DoMethod(win, TMM_Load, config);

        STARTUP_LOG(LOG1(Configuration loaded, "%s", config))

        /* Event loop */
        {
         ULONG signals = 0;

         /* Handle application input */
         while (DoMethod(app, MUIM_Application_NewInput, &signals)
                != MUIV_Application_ReturnID_Quit) {

#if DEBUG_VERY_NOISY
          /* This just generates too much debug output... */
          STARTUP_LOG(LOG1(Signals, "0x%08lx", signals))
#endif

          /* Got any signals to wait for? Yes, then wait for them */
          if (signals &&
              (Wait(SIGBREAKF_CTRL_C | signals) & SIGBREAKF_CTRL_C))

           /* Got CTRL-C, leave loop */
           break;
         }
        }

        STARTUP_LOG(LOG0(Leaving))

        /* Close main window */
        SetAttrs(win, MUIA_Window_Open, FALSE, TAG_DONE);

        /* Remove main window object from application */
        DoMethod(app, OM_REMMEMBER, win);

        /* Dispose main window object (deletes all attached objects) */
        MUI_DisposeObject(win);
       }

       /* Delete application */
       MUI_DisposeObject(app);
      }

      /* Free program name buffer */
      FreeVector(ProgramName);
     }
    }

    /* Free resources */
    FreeEditResources();

    /* Remove locale */
    DeleteLocale();

    /* Swap back to original stack */
    StackSwap(&MUIStack);

    /* Free stack */
    FreeMem(MUIStack.stk_Lower, STACKSIZE);
   }
  }

  /* Free icon */
  if (dobj) FreeDiskObject(dobj);

  /* Started from Workbench? Go back to old directory */
  if (wbs) CurrentDir(oldcd);

  /* Free command line arguments */
  if (rda) FreeArgs(rda);

  /* Error? */
  if (rc != RETURN_OK)

   /* Inform the user */
   EasyRequestArgs(NULL, &ErrorRequester, NULL, NULL);

  /* Close rest of the libraries */
  CloseLibraries();
 }

 STARTUP_LOG(LOG1(Result, "%ld", rc))

 /* Workbench startup message valid? */
 if (wbs) {

  /* Yes, disable multitasking */
  Forbid();

  /* Reply message */
  ReplyMsg((struct Message *) wbs);
 }

 return(rc);
}
