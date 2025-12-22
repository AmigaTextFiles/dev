/*
 * clistart.c  V3.1
 *
 * ToolManager library CLI start handling routines
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

/* Local data */
static struct Library       *DOSPathBase       = NULL;
static struct PathListEntry *WorkbenchPathList = NULL;

#ifdef _DCC
/* VarArgs stub for SystemTagList */
LONG SystemTags(STRPTR cmd, Tag tag1, ...)
{
 return(SystemTagList(cmd, (struct TagItem *) &tag1));
}

/* VarArgs stub for BuildPathListTagList */
struct PathListEntry *BuildPathListTags(struct PathListEntry **anchor,
                                        Tag tag1, ...)
{
 return(BuildPathListTagList(anchor, (struct TagItem *) &tag1));
}
#endif

/* Start a CLI program */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StartCLIProgram
BOOL StartCLIProgram(const char *cmd, const char *cdir, const char **path,
                     const char *output, ULONG stack, WORD prio,
                     struct AppMessage *msg)
{
 BPTR newcd;
 BOOL rc    = FALSE;

 CLISTART_LOG(LOG5(Arguments,
                   "Cmd '%s' Dir '%s' Stack %ld Prio %ld Msg 0x%08lx",
                   cmd, cdir, stack, prio, msg))

 /* Get lock to program current directory */
 if (newcd = Lock(cdir, SHARED_LOCK)) {
  char *cmdline;

  CLISTART_LOG(LOG1(NewCD, "0x%08lx", newcd))

  /* Build command line */
  if (cmdline = BuildCommandLine(cmd, msg, newcd, NULL)) {
   BPTR ofh;

   CLISTART_LOG(LOG2(Cmdline, "%s (0x%08lx)", cmdline, cmdline))

   /* Open output file */
   if (ofh = Open(output, MODE_NEWFILE)) {
    BPTR            ifh;
    struct MsgPort *newct = NULL;

    CLISTART_LOG(LOG1(OFH, "0x%08lx", ofh))

    /* Is the output file an interactive file? */
    if (IsInteractive(ofh)) {
     struct MsgPort *oldct;

     /* Yes. We need the same file as input file for CTRL-C/D/E/F */
     /* redirection. Set our ConsoleTask to the new output file,  */
     /* so that we can re-open it.                                */
     newct = ((struct FileHandle *) BADDR(ofh))->fh_Type;
     oldct = SetConsoleTask(newct);

     /* Open the new input file (Now ifh points to the same file as ofh) */
     ifh = Open("CONSOLE:", MODE_OLDFILE);

     /* Change back to old ConsoleTask */
     SetConsoleTask(oldct);

    } else

     /* No, just open NIL: for input */
     ifh = Open(DefaultOutput, MODE_OLDFILE);

    CLISTART_LOG(LOG1(IFH, "0x%08lx", ifh))

    /* Input file opened? */
    if (ifh) {
     struct PathListEntry *pathlist;
     BPTR oldcd;

     /* Build command path */
     {
      struct PathListEntry *wbpath;
      struct PathListEntry *anchor = NULL;

      /* First build path list from supplied string array */
      pathlist = BuildPathListTags(&anchor, DOSPath_BuildFromArray, path,
                                            TAG_DONE);

      /* Then attach Workbench path */
      wbpath = CopyPathList(WorkbenchPathList, &anchor);

      /* First copy failed? Use head of second list */
      if (pathlist == NULL) pathlist = wbpath;
     }

     CLISTART_LOG(LOG1(Pathlist, "0x%08lx", pathlist))

     /* Change to new current directory */
     oldcd = CurrentDir(newcd);

     /* Start program */
     rc = SystemTags(cmdline, SYS_Output,     ofh,
                              SYS_Input,      ifh,
                              SYS_Asynch,     TRUE,
                              SYS_UserShell,  TRUE,
                              NP_StackSize,   stack,
                              NP_Priority,    prio,
                              NP_Path,        MKBADDR(pathlist),
                              NP_ConsoleTask, newct,
                              TAG_DONE) != -1;

     /* Go back to old current directory */
     CurrentDir(oldcd);

     /* Error? */
     if (rc == FALSE) {
      FreePathList(pathlist);
      Close(ifh);
     }
    }

    if (rc == FALSE) Close(ofh);
   }

   /* Free command line */
   FreeVector(cmdline);
  }

  /* Free lock to current directory */
  UnLock(newcd);
 }

 CLISTART_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Open DOSPath library and copy Workbench path */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetWorkbenchPath
BOOL GetWorkbenchPath(void)
{
 CLISTART_LOG(LOG0(Entry))

 /* Open DOSPath library */
 if (DOSPathBase = OpenLibrary("dospath.library", 0)) {

  CLISTART_LOG(LOG1(DOSPathBase, "0x%08lx", DOSPathBase))

  /* Copy Workbench path */
  WorkbenchPathList = CopyWorkbenchPathList(NULL, NULL);

  CLISTART_LOG(LOG1(WBPath, "0x%08lx", WorkbenchPathList))
 }

 return(DOSPathBase != NULL);
}

/* Free Workbench path */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeWorkbenchPath
void FreeWorkbenchPath(void)
{
 CLISTART_LOG(LOG2(Data, "WBPath 0x%08lx DOSPathBase 0x%08lx",
                   WorkbenchPathList, DOSPathBase))

 if (WorkbenchPathList) {
  FreePathList(WorkbenchPathList);
  WorkbenchPathList = NULL;
 }
 if (DOSPathBase) {
  CloseLibrary(DOSPathBase);
  DOSPathBase = NULL;
 }
}
