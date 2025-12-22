/* Name:       StartDPK
** Template 1: StartDPK <TaskFile> [-p <Name>] <Arg1> <Arg2> ...
** Template 2: StartDPK <TaskFile> [PREFS=<Name>] <Arg1> <Arg2> ...
** Author:     Paul Manias
** Copyright:  DreamWorld Productions (c) 1997-1998.  All rights reserved.
** Date:       January 1998
** Docs:       This program is intended to allow multi-platform capabilities by
**             doing things like opening the kernel.  For example the following
**             code would not work on a Mac even if it is 68000 code:
**
**              move.l $4.w,a6
**              ...
**              CALL   OpenLibrary
**
**            To fix this problem we put this machine-specific code in a task
**            launcher (StartDPK) and pass the DPKBase onto the task.  Alakazam,
**            multiple platform capabilities!
**
** PROBLEMS:  Programs written in E cannot cope with this as far as I know :-(.
*/

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/dpkernel.h>
#include <workbench/startup.h>
#include <system/tasks.h>
#include <clib/icon_protos.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern struct ExecBase *SysBase;
extern struct Library  *IconBase;

/*** Proto-types ***/

void PrintUsage(void);
void Launch(void);
__asm LaunchTask(register __a0 struct Segment *);

/*** Program variables ***/

BYTE *TaskFile = NULL;
BYTE *Prefs    = NULL;
struct Segment *Segment = NULL;
struct StartUp *StartUp = NULL;
struct FileName file    = { ID_FILENAME, NULL };

/************************************************************************************
** Main code.
*/

LONG main(LONG argc, BYTE *argv[])
{
  struct WBStartup  *WBMsg;
  struct WBArg      *WBArg;
  struct DiskObject *dobj;
  BYTE   *str;
  LONG   PrefsSize = NULL;

  if (argc IS NULL) {
     /**** Launched from WorkBench ****/

     WBMsg = (struct WBStartup *)argv;
     WBArg = WBMsg->sm_ArgList;

     /* Skip StartDPK and program location */

     WBArg++;

     /* Process filename and location */

     printf("Loading: %s\n",WBArg->wa_Name);
     file.Name = WBArg->wa_Name;
     CurrentDir(WBArg->wa_Lock);

     /* Process tool types */

     if (IconBase = OpenLibrary("icon.library", 0)) {
        if (dobj = GetDiskObject(WBArg->wa_Name)) {
           if (str = FindToolType(dobj->do_ToolTypes, "PREFS")) {
              if (Prefs = AllocMem(strlen(str)+1,NULL)) {
                 PrefsSize = strlen(str)+1;
                 strcpy(Prefs, str);
              }
           }
           FreeDiskObject(dobj);
        }
        else printf("Error in getting DiskObject.\n");

        CloseLibrary((struct Library *)IconBase);
     }
     else printf("Could not open icon.library.\n");
  }
  else {
     /**** Launched from CLI ****/

     if ((argc < 2) OR (argv[1][0] IS '?')) {
        PrintUsage();
        return(NULL);
     }

     printf("Loading: %s\n",argv[1]);
     file.Name = argv[1];             /* Task is always specified in argument 1 */

     /* Check for preferences */

     if (argc > 2) {
        if (argc > 3) {
           if (stricmp("-p",argv[2]) IS NULL) {
              Prefs = argv[3];
           }
        }
        else {
           if (strnicmp("PREFS=",argv[2],6) IS NULL) {
              Prefs = argv[2] + 6;
           }
        }
     }
  }

  /* Open the library, launch the program and then
  ** shut down before exiting.
  */

  if (DPKBase = (struct DPKBase *)OpenLibrary("GMS:libs/dpkernel.library",0)) {
     Launch();
     CloseDPK();
  }
  else printf("Could not open the dpkernel.library.  Have you installed it?\n");

  if (PrefsSize) FreeMem(Prefs,PrefsSize);

  return(NULL);
}

/***********************************************************************************/

void PrintUsage(void)
{
  printf("\nSTARTDPK\n");
  printf("--------\n");
  printf("This program will launch DPK tasks for you, and in future will\n");
  printf("be required for setting up programs that have been compiled on other\n");
  printf("platforms.\n\n");
  printf("To use it, just type:\n\n");
  printf("  1> StartDPK <file> [-p prefsname] [Arg1] [Arg2] [Arg3] ...\n\n");
  printf("Example:\n");
  printf("  1> StartDPK DPK:demos/Redimension -p Settings1\n\n");
}

/************************************************************************************
**
**
**
*/

#define PREFSLEN 10

void Launch(void)
{
  struct DPKTask *Task;
  WORD i,j;

  if (Task = FindDPKTask()) {
     if (Prefs) {
        if (Task->Preferences = AllocMemBlock(PREFSLEN+strlen(Prefs)+2,MEM_DATA)) {
           strcpy(Task->Preferences,"GMS:Prefs/");
           j = NULL;
           i = PREFSLEN;
           while (Prefs[j] != NULL) {
              Task->Preferences[i++] = Prefs[j++];
           }
           Task->Preferences[i++] = '/';
           Task->Preferences[i]   = NULL;

           printf("Preferences: %s\n",Task->Preferences);
        }
        else {
           printf("Low memory error.");
           return;
        }
     }
     else {
        printf("Using default preferences.\n");
     }

     if (Segment = Load(&file,ID_SEGMENT)) {
        LaunchTask(Segment);
        Free(Segment);
     }
     else printf("Sorry, the file that you specified does not exist.\n");

     if (Prefs) {
        FreeMemBlock(Task->Preferences);
        Task->Preferences = NULL;
     }
  }
  else printf("Could not find DPK task, error.\n");
}

