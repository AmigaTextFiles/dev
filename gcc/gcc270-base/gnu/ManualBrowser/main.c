/************************************************************************/
/*                                                                      */
/*  Copyright (C) 1994  Christian Stieber                               */
/*                                                                      */
/* This program is free software; you can redistribute it and/or modify */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation; either version 2 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* This program is distributed in the hope that it will be useful,      */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with this program; if not, write to the Free Software          */
/* Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.            */
/*                                                                      */
/************************************************************************/
/*                                                                      */
/* Author address:                                                      */
/*   Christian Stieber                                                  */
/*   Konradstraﬂe 41                                                    */
/*   D-85055 Ingolstadt                                                 */
/*   (Germany)                                                          */
/*   Phone: 0841-59896                                                  */
/*                                                                      */
/************************************************************************/

#ifndef V39
#define CreatePool LibCreatePool
#define DeletePool LibDeletePool
#define AllocPooled LibAllocPooled
#define FreePooled LibFreePooled
#endif

#ifndef DOS_DOSEXTENS_H
#include <dos/dosextens.h>
#endif

#ifndef DOS_EXALL_H
#include <dos/exall.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef LIBRARIES_AMIGAGUIDE_H
#include <libraries/amigaguide.h>
#endif

#ifndef WORKBENCH_STARTUP_H
#include <workbench/startup.h>
#endif

#ifndef WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif

#ifndef __GNUC__
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif

#ifndef CLIB_DOS_PROTOS_H
#include <clib/dos_protos.h>
#endif

#ifndef CLIB_UTILITY_PROTOS_H
#include <clib/utility_protos.h>
#endif

#ifndef CLIB_INTUITION_PROTOS_H
#include <clib/intuition_protos.h>
#endif

#ifndef CLIB_ICON_PROTOS_H
#include <clib/icon_protos.h>
#endif

#ifndef CLIB_AMIGAGUIDE_PROTOS_H
#include <clib/amigaguide_protos.h>
#endif

#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/amigaguide_pragmas.h>
#endif

#include <string.h>

#include "Globals.h"

/***********************************************/

struct DosLibrary *DOSBase;
struct IntuitionBase *IntuitionBase;
struct Library *AmigaGuideBase;
struct Library *UtilityBase;

/***********************************************/

#ifdef __GNUC__

#include "Inlines.h"

#ifndef V39
APTR AllocPooled (APTR, ULONG);
void FreePooled (APTR, APTR, ULONG);
APTR CreatePool (ULONG, ULONG, ULONG);
void DeletePool (APTR);
#endif

#endif /* __GNUC__ */

/***********************************************/

#define CONFIGFILE	"ManualBrowser.config"

/***********************************************/

char Version[] = "$VER: ManualBrowser " PROGVERSION " (" PROGDATE ")"
#ifdef V39
"(V39) "
#endif
"(" CPU ") "
"© 1994 Christian Stieber";

/***********************************************/

#define BASENAME   "ManBrowser"
#define PUDDLESIZE (20*1024)

/***********************************************/

struct ActionNode *ActionList;
BPTR ManDir;
long LineLength = 70;
char DatabaseName[64];

/***********************************************/

static void *MemoryPool;

static AMIGAGUIDEHOST AmigaGuideHostHandle;
static AMIGAGUIDECONTEXT AmigaGuideHandle;

static char Filename[64];

static BPTR FileHandle;

static struct WBStartup *WBStartupMessage;

static struct EasyStruct EasyStruct =
{
  5 * 4,
  0,
  "Manual browser " PROGVERSION " error",
  NULL,
  NULL
};

/***********************************************/

#ifdef __GNUC__
static void 
MyExit (int) __attribute__ ((noreturn));
#endif

     static void MyExit (int RC)

{
  if (WBStartupMessage)
    {
      Forbid ();
      ReplyMsg ((struct Message *) WBStartupMessage);
    }
  exit (RC);
}

/************************************************************************/
/*                                                                      */
/* Malloc()                                                             */
/*                                                                      */
/************************************************************************/

void *
Malloc (ULONG Size)

{
  ULONG *Memory;

  Size += 4;
  if (Memory = AllocPooled (MemoryPool, Size))
    {
      *Memory = Size;
      Memory++;
    }
  return Memory;
}

/************************************************************************/
/*                                                                      */
/* Free()                                                               */
/*                                                                      */
/************************************************************************/

void 
Free (void *Memory)

{
  if (Memory)
    {
      FreePooled (MemoryPool, ((ULONG *) Memory) - 1, *(((ULONG *) Memory) - 1));
    }
}

/***********************************************/

static void 
DisplayError (char *Format,...)

{
  if (WBStartupMessage)
    {
      EasyStruct.es_TextFormat = Format;
      EasyStruct.es_GadgetFormat = "Quit";
      EasyRequestArgs (NULL, &EasyStruct, NULL, (&Format) + 1);
    }
  else
    {
      VPrintf (Format, (&Format) + 1);
      PutStr ("\n");
    }
}

/***********************************************/

static void 
DisplayDosError (char *Filename)

{
  if (WBStartupMessage)
    {
      char Buffer[256];
      char *t;

      t = Buffer;
      Fault (IoErr (), Filename, t, sizeof (Buffer));
      EasyStruct.es_TextFormat = "%s";
      EasyStruct.es_GadgetFormat = "Quit";
      EasyRequestArgs (NULL, &EasyStruct, NULL, &t);
    }
  else
    {
      PrintFault (IoErr (), Filename);
    }
}

/***********************************************/

#ifdef __GNUC__
static void 
CloseAll (int) __attribute__ ((noreturn));
#endif

     static void CloseAll (int RC)

{
  if (AmigaGuideHandle)
    CloseAmigaGuide (AmigaGuideHandle);
  if (AmigaGuideHostHandle)
    {
      while (RemoveAmigaGuideHostA (AmigaGuideHostHandle, NULL))
	{
	  Delay (TICKS_PER_SECOND);
	}
    }
  if (FileHandle)
    {
      DeleteFile (Filename);
    }
  if (ManDir)
    UnLock (ManDir);
  if (MemoryPool)
    DeletePool (MemoryPool);
  CloseLibrary (AmigaGuideBase);
  CloseLibrary (UtilityBase);
  CloseLibrary ((struct Library *) IntuitionBase);
  CloseLibrary ((struct Library *) DOSBase);
  MyExit (RC);
}

/***********************************************/

static void 
InitThings (void)

{
  struct Process *MyProcess;

  MyProcess = (struct Process *) FindTask (NULL);
  if (MyProcess->pr_CLI)
    {
      WBStartupMessage = NULL;
    }
  else
    {
      do
	{
	  WaitPort (&MyProcess->pr_MsgPort);
	}
      while (!(WBStartupMessage = (struct WBStartup *) GetMsg (&MyProcess->pr_MsgPort)));
    }

#ifdef V39
  if (!(DOSBase = (struct DosLibrary *) OpenLibrary ("dos.library", 39)))
#else
  if (!(DOSBase = (struct DosLibrary *) OpenLibrary ("dos.library", 37)))
#endif
    {
      MyExit (100);
    }

  if (!(IntuitionBase = (struct IntuitionBase *) OpenLibrary ("intuition.library", 37)))
    {
      CloseLibrary ((struct Library *) DOSBase);
      MyExit (100);
    }

  if (!(UtilityBase = OpenLibrary ("utility.library", 37)))
    {
      DisplayError ("Unable to open utility.library V37");
      CloseAll (RETURN_FAIL);
    }

  if (!(AmigaGuideBase = OpenLibrary ("amigaguide.library", 34)))
    {
      DisplayError ("Unable to open amigaguide.library V34");
      CloseAll (RETURN_FAIL);
    }

  if (!(MemoryPool = CreatePool (0, PUDDLESIZE, PUDDLESIZE)))
    {
      DisplayError ("Unable to create memory pool");
      CloseAll (RETURN_FAIL);
    }
}

/***********************************************/

static void 
AddDatabase (void)

{
#ifdef __GNUC__
  static struct Hook AmigaGuideHook =
  {
    {NULL, NULL},
    HookEntryA1,
    AmigaGuideHostDispatcher,
    NULL
  };
#else
  static struct Hook AmigaGuideHook =
  {
    {NULL, NULL},
    AmigaGuideHostDispatcher,
    NULL,
    NULL
  };
#endif

  char *t;

  Sprintf (DatabaseName, BASENAME ".%lx", FindTask (NULL));
  Sprintf (Filename, "t:%s.guide", DatabaseName);

  if (!(FileHandle = Open (Filename, MODE_NEWFILE)))
    {
      DisplayDosError (Filename);
      CloseAll (RETURN_ERROR);
    }
  t = DatabaseName;
  if (VFPrintf (FileHandle, "@database %s.guide\n"
		"@node EnItSiRhC\n"
		"@endnode\n", &t) == -1)
    {
      DisplayDosError (Filename);
      Close (FileHandle);
      CloseAll (RETURN_ERROR);
    }
  Close (FileHandle);

  if (!(AmigaGuideHostHandle = AddAmigaGuideHostA (&AmigaGuideHook, DatabaseName, NULL)))
    {
      DisplayError ("Unable to add dynamic amiga guide host");
      CloseAll (RETURN_FAIL);
    }
}

/***********************************************/

static void 
OpenDatabase (void)

{
  struct NewAmigaGuide NewAmigaGuide;

  NewAmigaGuide.nag_Lock = NULL;
  NewAmigaGuide.nag_Name = Filename;
  NewAmigaGuide.nag_Screen = NULL;
  NewAmigaGuide.nag_PubScreen = NULL;
  NewAmigaGuide.nag_HostPort = NULL;
  NewAmigaGuide.nag_ClientPort = BASENAME;
  NewAmigaGuide.nag_BaseName = BASENAME;
  NewAmigaGuide.nag_Flags = HTF_NOACTIVATE;
  NewAmigaGuide.nag_Context = NULL;
  NewAmigaGuide.nag_Node = NULL;
  NewAmigaGuide.nag_Line = 0;
  NewAmigaGuide.nag_Extens = NULL;
  NewAmigaGuide.nag_Client = NULL;

  if (!(AmigaGuideHandle = OpenAmigaGuideA (&NewAmigaGuide, NULL)))
    {
      DisplayError ("Unable to open amiga guide database");
      CloseAll (RETURN_FAIL);
    }
}

/***********************************************/

#ifdef __GNUC__
#define ICONBASE IconBase,
#else
#define ICONBASE
#endif

static void 
GetParams (void)

{
  if (WBStartupMessage)
    {
      struct Library *IconBase;

      if ((IconBase = OpenLibrary ("icon.library", 33)))
	{
	  if (WBStartupMessage->sm_NumArgs)
	    {
	      BPTR OldCurrDir;
	      struct DiskObject *DiskObject;
	      OldCurrDir = CurrentDir (WBStartupMessage->sm_ArgList[0].wa_Lock);
	      if ((DiskObject = GetDiskObject (ICONBASE WBStartupMessage->sm_ArgList[0].wa_Name)))
		{
		  char *ManPath;
		  if (!((ManPath = FindToolType (ICONBASE (UBYTE **) DiskObject->do_ToolTypes, "MANUALDIR")) ||
			(ManPath = FindToolType (ICONBASE (UBYTE **) DiskObject->do_ToolTypes, "MANDIR")) ||
			(ManPath = FindToolType (ICONBASE (UBYTE **) DiskObject->do_ToolTypes, "DIR"))))
		    {
		      ManPath = "man:";
		    }
		  if (!(ManDir = Lock (ManPath, SHARED_LOCK)))
		    {
		      DisplayDosError (ManPath);
		    }
		  FreeDiskObject (ICONBASE DiskObject);
		}
	      CurrentDir (OldCurrDir);
	    }
	  CloseLibrary (IconBase);
	}
    }
  else
    {
      struct
      {
	char *ManualDir;
      }
      Arguments;

      struct RDArgs *RDArgs;

      Arguments.ManualDir = "man:";
      if (!(RDArgs = ReadArgs ("MANUALDIR=MANDIR=DIR", (long *) &Arguments, NULL)))
	{
	  PrintFault (IoErr (), NULL);
	  CloseAll (RETURN_FAIL);
	}
      if (!(ManDir = Lock (Arguments.ManualDir, SHARED_LOCK)))
	{
	  DisplayDosError (Arguments.ManualDir);
	}
      FreeArgs (RDArgs);
    }
  if (!ManDir)
    {
      CloseAll (RETURN_FAIL);
    }
}

/***********************************************/

int 
ReadConfigFile (BPTR ConfigFile, struct ActionNode **ActionList)

{
  BPTR OldInput;

  OldInput = SelectInput (ConfigFile);
  while (TRUE)
    {
      struct
	{
	  char *Pattern;
	  char *Action;
	}
      CurrentLine;
      struct RDArgs *LineArgs;

      while (TRUE)
	{
	  int Character;

	  Character = FGetC (ConfigFile);
	  if (Character != '\n' && Character != ' ' && Character != '\t')
	    {
	      if (Character == -1)
		{
		  if (IoErr ())
		    {
		      return FALSE;
		    }
		  SelectInput (OldInput);
		  return TRUE;
		}
	      UnGetC (ConfigFile, Character);
	      break;
	    }
	}
      CurrentLine.Pattern = NULL;
      CurrentLine.Action = NULL;
      if (LineArgs = ReadArgs ("P/A,A/A/F", (long *) &CurrentLine, NULL))
	{
	  struct ActionNode *ActionNode;
	  int AllocSize, PatternSize;
	  PatternSize = 2 * strlen (CurrentLine.Pattern);
	  AllocSize = sizeof (struct ActionNode) + strlen (CurrentLine.Action) + PatternSize;
	  if ((ActionNode = Malloc (AllocSize)))
	    {
	      ActionNode->Pattern = Stpcpy (ActionNode->Action, CurrentLine.Action) + 1;
	      if (ParsePatternNoCase (CurrentLine.Pattern, ActionNode->Pattern, PatternSize) != -1)
		{
		  ActionNode->Next = *ActionList;
		  *ActionList = ActionNode;
		}
	      else
		{
		  DisplayError ("Error in pattern: %s", CurrentLine.Pattern);
		  ActionNode = NULL;
		}
	    }
	  FreeArgs (LineArgs);
	  if (!ActionNode)
	    {
	      return FALSE;
	    }
	}
      else
	{
	  return FALSE;
	}
    }
  /* Not reached */
}

/***********************************************/

static void 
ReadConfig (void)

{
  static char *ConfigFile[] =
  {
    "PROGDIR:" CONFIGFILE,
    "S:" CONFIGFILE,
    "ENV:" CONFIGFILE
  };

  int i;

  for (i = 0; i < 3; i++)
    {
      BPTR FileHandle;
      if ((FileHandle = Open (ConfigFile[i], MODE_OLDFILE)))
	{
	  int Result;

	  Result = ReadConfigFile (FileHandle, &ActionList);
	  Close (FileHandle);
	  if (!Result)
	    {
	      DisplayDosError (ConfigFile[i]);
	      CloseAll (RETURN_FAIL);
	    }
	}
    }
}

/***********************************************/

void Main (void);

void 
Main (void)

{
  InitThings ();
  GetParams ();
  ReadConfig ();
  AddDatabase ();
  OpenDatabase ();
  CloseAll (RETURN_OK);
  /* Not reached */
}
