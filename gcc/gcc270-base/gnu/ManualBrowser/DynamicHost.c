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

/************************************************************************/

#ifdef __GNUC__

#include "Inlines.h"

#ifndef V39
APTR AllocPooled (APTR, ULONG);
void FreePooled (APTR, APTR, ULONG);
APTR CreatePool (ULONG, ULONG, ULONG);
void DeletePool (APTR);
#endif

#endif /* __GNUC__ */

/************************************************************************/

#define MESSAGE_NAME	".Message"
#define CONFIG_NAME     ".Config"

/************************************************************************/

static char AboutText[] =
"\n"
"  This is the manual browser " PROGVERSION " (" PROGDATE "), " CPU " version\n"
#ifdef V39
"  This executable was compiled for AmigaOS 3.0 (V39) and up.\n"
#endif
"  Copyright © 1994 Christian Stieber\n"
"\n"
"\n"
"  This program is free software; you can redistribute it and/or modify\n"
"  it under the terms of the @{\x22GNU General Public License\x22 LINK COPYING/Main} as published by\n"
"  the Free Software Foundation; either version 2 of the License, or\n"
"  (at your option) any later version.\n"
"\n"
"  This program is distributed in the hope that it will be useful,\n"
"  but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
"  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
"  @{\x22GNU General Public License\x22 LINK COPYING/Main} for more details.\n"
"\n"
"  You should have received a copy of the @{\x22GNU General Public License\x22 LINK COPYING/Main}\n"
"  along with this program; if not, write to the Free Software\n"
"  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n"
"\n"
"\n"
"  Author: Christian Stieber\n"
"          Konradstraﬂe 41\n"
"          D-85055 Ingolstadt\n"
"          (Germany)\n"
"\n"
"  Currently (1994) I'm a student and may reached at the following address:\n"
"\n"
"          Christian Stieber\n"
"          Seitzstraﬂe 6, Zi. 306\n"
"          D-80538 M¸nchen\n"
"          (Germany)\n"
"\n"
"          EMail: stieber@informatik.tu-muenchen.de\n"
"\n";

/************************************************************************/

struct DirNode
  {
    struct DirNode *Next;
    struct ActionNode *ActionNode;
    char Name[1];
  };

/************************************************************************/

static struct DirNode *DirectoryList;
static struct DirNode *FileList;
static char *NodeData;
static ULONG NodeLength;

static char *MessageText;

#ifdef __GNUC__
static struct FileInfoBlock FileInfoBlock __attribute__ ((aligned (4)));
#else
static struct FileInfoBlock __aligned FileInfoBlock;
#endif

static struct ActionNode *LocalActionList;

/************************************************************************/

static void 
InsertDirNode (struct DirNode *DirNode, struct DirNode **DirList)

{
  if (!*DirList)
    {
      *DirList = DirNode;
      DirNode->Next = NULL;
    }
  else
    {
      struct DirNode *Prev, *Current;

      Prev = (struct DirNode *) DirList;
      Current = Prev->Next;
      while (Current && (Stricmp (Current->Name, DirNode->Name) < 0))
	{
	  Prev = Current;
	  Current = Current->Next;
	}
      Prev->Next = DirNode;
      DirNode->Next = Current;
    }
}

/************************************************************************/

static void 
FreeDirNodes (struct DirNode **DirList)

{
  while (*DirList)
    {
      struct DirNode *Next;
      Next = (*DirList)->Next;
      Free (*DirList);
      *DirList = Next;
    }
}

/************************************************************************/
/*                                                                      */
/* Look for an action node matching a given filename.                   */
/* Checks the local list first, followed by the global list.            */
/* Returns NULL for "no action assigned"                                */
/*                                                                      */
/************************************************************************/

static struct ActionNode *
FindActionNode (char *Filename)

{
  struct ActionNode *ActionNode;

  for (ActionNode = LocalActionList; ActionNode; ActionNode = ActionNode->Next)
    {
      if (MatchPatternNoCase (ActionNode->Pattern, Filename))
	{
	  return ActionNode;
	}
    }

  for (ActionNode = ActionList; ActionNode; ActionNode = ActionNode->Next)
    {
      if (MatchPatternNoCase (ActionNode->Pattern, Filename))
	{
	  return ActionNode;
	}
    }

  return NULL;
}

/************************************************************************/
/*                                                                      */
/* Free the local action list                                           */
/*                                                                      */
/************************************************************************/

static void 
FreeLocalActionList (void)

{
  while (LocalActionList)
    {
      struct ActionNode *ThisNode;

      ThisNode = LocalActionList;
      LocalActionList = ThisNode->Next;
      Free (ThisNode);
    }
}

/************************************************************************/
/*                                                                      */
/* Read the local action list for a directory, if available.            */
/*                                                                      */
/************************************************************************/

static void 
ReadLocalConfig (BPTR DirLock)

{
  BPTR OldCurrDir;
  BPTR FileHandle;

  OldCurrDir = CurrentDir (DirLock);
  if (FileHandle = Open (CONFIG_NAME, MODE_OLDFILE))
    {
      int Result;
      Result = ReadConfigFile (FileHandle, &LocalActionList);
      Close (FileHandle);
      if (!Result)
	{
	  FreeLocalActionList ();
	}
    }
  CurrentDir (OldCurrDir);
}

/************************************************************************/
/*                                                                      */
/*                                                                      */
/************************************************************************/

#define BUFFER_SIZE (4*1024)

static long 
ReadDir (BPTR DirLock)

{
  struct ExAllControl *ExAllControl;
  long DosError;

  DosError = 0;
  if ((ExAllControl = AllocDosObject (DOS_EXALLCONTROL, NULL)))
    {
      struct ExAllData *Buffer;
      if ((Buffer = Malloc (BUFFER_SIZE)))
	{
	  int more;
	  ReadLocalConfig (DirLock);
	  ExAllControl->eac_LastKey = 0;
	  ExAllControl->eac_MatchString = NULL;
	  ExAllControl->eac_MatchFunc = NULL;
	  do
	    {
	      more = ExAll (DirLock, Buffer, BUFFER_SIZE, ED_TYPE, ExAllControl);
	      if ((!more) && (IoErr () != ERROR_NO_MORE_ENTRIES))
		{
		  DosError = IoErr ();
		}
	      else
		{
		  if (ExAllControl->eac_Entries)
		    {
		      struct ExAllData *ExAllData;
		      ExAllData = Buffer;
		      do
			{
			  if (Stricmp (ExAllData->ed_Name, MESSAGE_NAME) || Stricmp (ExAllData->ed_Name, CONFIG_NAME))
			    {
			      struct ActionNode *ActionNode;
			      ActionNode = FindActionNode (ExAllData->ed_Name);
			      if (!ActionNode || Stricmp (ActionNode->Action, "IGNORE"))
				{
				  struct DirNode *DirNode;
				  if (ActionNode && !Stricmp (ActionNode->Action, "DEFAULT"))
				    {
				      ActionNode = NULL;
				    }
				  if ((DirNode = Malloc (sizeof (struct DirNode) + strlen (ExAllData->ed_Name))))
				    {
				      DirNode->ActionNode = ActionNode;
				      strcpy (DirNode->Name, ExAllData->ed_Name);
				      if (ExAllData->ed_Type == ST_SOFTLINK)
					{
					  BPTR LinkLock;
					  BPTR OldCurrDir;
					  OldCurrDir = CurrentDir (DirLock);
					  if ((LinkLock = Lock (ExAllData->ed_Name, SHARED_LOCK)))
					    {
					      if (Examine (LinkLock, &FileInfoBlock))
						{
						  InsertDirNode (DirNode, FileInfoBlock.fib_DirEntryType >= 0 ? &DirectoryList : &FileList);
						}
					      UnLock (LinkLock);
					    }
					  CurrentDir (OldCurrDir);
					}
				      else
					{
					  InsertDirNode (DirNode, ExAllData->ed_Type >= 0 ? &DirectoryList : &FileList);
					}
				    }
				  else
				    {
				      DosError = IoErr ();
				    }
				}
			    }
			  ExAllData = ExAllData->ed_Next;
			}
		      while (!DosError && ExAllData);
		    }
		}
	    }
	  while (!DosError && more);
	  if (more)
	    {
#ifdef V39
	      ExAllEnd (DirLock, Buffer, BUFFER_SIZE, ED_TYPE, ExAllControl);
#else
	      while (ExAll (DirLock, Buffer, BUFFER_SIZE, ED_TYPE, ExAllControl));
#endif
	    }
	  if (DosError)
	    {
	      FreeDirNodes (&DirectoryList);
	      FreeDirNodes (&FileList);
	    }
	  Free (Buffer);
	  FreeLocalActionList ();
	}
      else
	{
	  DosError = IoErr ();
	}
      FreeDosObject (DOS_EXALLCONTROL, ExAllControl);
    }
  else
    {
      DosError = IoErr ();
    }
  return DosError;
}

#undef BUFFER_SIZE

/***********************************************/

static char *NodeDataTmp;

static int 
PrintNodeText (char *Text)

{
  if (NodeDataTmp)
    {
      NodeDataTmp = Stpcpy (NodeDataTmp, Text);
    }
  return strlen (Text);
}

/***********************************************/

static int 
PrintDir (char *ThisDir, char *PathName)

{
  int Length;
  struct DirNode *Current;
  short ColWidth, Columns;
  short MaxLength;
  short Column;

  /* Max. length of the buttons */
  MaxLength = 0;
  for (Current = DirectoryList; Current; Current = Current->Next)
    {
      Length = strlen (Current->Name) + 1;
      if (Length > MaxLength)
	MaxLength = Length;
    }
  for (Current = FileList; Current; Current = Current->Next)
    {
      Length = strlen (Current->Name);
      if (Length > MaxLength)
	MaxLength = Length;
    }
  if (AmigaGuideBase->lib_Version >= 39)
    MaxLength++;

  Columns = LineLength / (MaxLength + 1);
  ColWidth = LineLength / Columns;
  if (AmigaGuideBase->lib_Version >= 39)
    ColWidth--;

  Length = 0;

  Column = 0;
  for (Current = DirectoryList; Current; Current = Current->Next)
    {
      int CurWidth;
      CurWidth = 0;
      Length += PrintNodeText ("@{\x22");
      CurWidth += PrintNodeText (Current->Name);
      CurWidth += PrintNodeText ("/");
      Length += PrintNodeText ("\x22 LINK \x22");
      if (*ThisDir)
	{
	  Length += PrintNodeText (ThisDir);
	  Length += PrintNodeText ("/");
	}
      Length += PrintNodeText (Current->Name);
      Length += PrintNodeText ("\x22}");
      Column++;
      if (Column >= Columns)
	{
	  Length += PrintNodeText ("\n");
	  Column = 0;
	}
      else
	{
	  while (CurWidth < ColWidth)
	    CurWidth += PrintNodeText (" ");
	}
      Length += CurWidth;
    }
  if (Column)
    {
      Length += PrintNodeText ("\n");
    }

  if (DirectoryList && FileList)
    {
      Length += PrintNodeText ("\n\n");
    }

  Column = 0;
  for (Current = FileList; Current; Current = Current->Next)
    {
      int CurWidth;
      CurWidth = 0;
      Length += PrintNodeText ("@{\x22");
      CurWidth += PrintNodeText (Current->Name);
      Length += PrintNodeText ("\x22 ");
      if (Current->ActionNode)
	{
	  char *t;
	  char x[4];

	  x[1] = '\0';
	  for (t = Current->ActionNode->Action; *t; t++)
	    {
	      if (*t == '%')
		{
		  switch (*(t + 1))
		    {
		    case '%':
		      Length += PrintNodeText ("%");
		      t++;
		      break;

		    case 'p':
		      Length += PrintNodeText (PathName);
		      t++;
		      break;

		    case 'f':
		      Length += PrintNodeText (Current->Name);
		      t++;
		      break;

		    case 'F':
		      {
			char *u, *v;
			v = NULL;
			for (u = Current->Name; *u; u++)
			  {
			    if (*u == '.')
			      v = u;
			  }
			if (!v)
			  v = u;
			for (u = Current->Name; u != v; u++)
			  {
			    x[0] = *u;
			    Length += PrintNodeText (x);
			  }
		      }
		      t++;
		      break;

		    default:
		      x[0] = *t;
		      Length += PrintNodeText (x);
		      break;
		    }
		}
	      else
		{
		  x[0] = *t;
		  Length += PrintNodeText (x);
		}
	    }
	}
      else
	{
	  Length += PrintNodeText ("LINK \x22");
	  if (*ThisDir)
	    {
	      Length += PrintNodeText (ThisDir);
	      Length += PrintNodeText ("/");
	    }
	  Length += PrintNodeText (Current->Name);
	  Length += PrintNodeText ("/Main");
	  Length += PrintNodeText ("\x22");
	}
      Length += PrintNodeText ("}");
      Column++;
      if (Column >= Columns)
	{
	  Length += PrintNodeText ("\n");
	  Column = 0;
	}
      else
	{
	  while (CurWidth < ColWidth)
	    CurWidth += PrintNodeText (" ");
	}
      Length += CurWidth;
    }
  if (Column)
    {
      Length += PrintNodeText ("\n");
    }

  return Length;
}

/***********************************************/

static int 
PrintMessage (void)

{
  if (MessageText)
    {
      int Length;
      Length = PrintNodeText (MessageText);
      Length += PrintNodeText ("\n");
      return Length;
    }
  return 0;
}

/***********************************************/

static void 
ReadMessage (BPTR DirLock)

{
  BPTR OldCurrDir;
  BPTR FileHandle;

  OldCurrDir = CurrentDir (DirLock);
  if ((FileHandle = Open (MESSAGE_NAME, MODE_OLDFILE)))
    {
      if (ExamineFH (FileHandle, &FileInfoBlock))
	{
	  ULONG Length;

	  Length = FileInfoBlock.fib_Size + 1;
	  if (MessageText = Malloc (Length))
	    {
	      Read (FileHandle, MessageText, Length - 1);
	      MessageText[Length - 1] = '\0';
	    }
	}
      Close (FileHandle);
    }
  CurrentDir (OldCurrDir);
}

/***********************************************/

#ifdef __GNUC__
ULONG 
AmigaGuideHostDispatcher (Msg Message)
#else
ULONG __saveds __asm 
AmigaGuideHostDispatcher (register __a1 Msg Message)
#endif

{
  switch (Message->MethodID)
    {
    case HM_FINDNODE:
      {
	char *Name;

	Name = ((struct opFindHost *) Message)->ofh_Node;
	while (!Strnicmp (Name, DatabaseName, strlen (DatabaseName)))
	  {
	    Name += strlen (DatabaseName) + 1;
	  }

	((struct opFindHost *) Message)->ofh_Next = ((struct opFindHost *) Message)->ofh_Prev = ((struct opFindHost *) Message)->ofh_Node;

	if (!Stricmp ("main", Name))
	  {
	    ((struct opFindHost *) Message)->ofh_Title = "Manual browser " PROGVERSION;
	  }
	else if (!strcmp ("AbOuT", Name))
	  {
	    ((struct opFindHost *) Message)->ofh_Title = "About the manual browser";
	  }
	else
	  {
	    BPTR OldCurrDir;
	    BPTR TestLock;

	    OldCurrDir = CurrentDir (ManDir);
	    if ((TestLock = Lock (Name, SHARED_LOCK)))
	      {
		UnLock (TestLock);
	      }
	    CurrentDir (OldCurrDir);
	    if (!TestLock)
	      return FALSE;
	    ((struct opFindHost *) Message)->ofh_Title = Name;
	    ((struct opFindHost *) Message)->ofh_TOC = "main";
	  }
	return TRUE;
      }
      break;

    case HM_OPENNODE:
      {
	BPTR DirLock;
	BPTR OldCurrDir;
	char *Name;
	int Main;
	long DosError;

	DosError = 0;
	((struct opNodeIO *) Message)->onm_Flags = HTNF_CLEAN;
	((struct opNodeIO *) Message)->onm_FileName = NULL;
	Name = ((struct opNodeIO *) Message)->onm_Node;
	while (!Strnicmp (Name, DatabaseName, strlen (DatabaseName)))
	  {
	    Name += strlen (DatabaseName) + 1;
	  }

	if ((Main = !Stricmp ("main", Name)))
	  {
	    Name += 4;
	  }
	else if (!strcmp ("AbOuT", Name))
	  {
	    ((struct opNodeIO *) Message)->onm_DocBuffer = AboutText;
	    ((struct opNodeIO *) Message)->onm_BuffLen = sizeof (AboutText) - 1;
	    return TRUE;
	  }

	OldCurrDir = CurrentDir (ManDir);
	if ((DirLock = Lock (Name, SHARED_LOCK)))
	  {
	    char *DirName;
	    int DirNameLength;

	    DirNameLength = 256;
	    do
	      {
		if (DirName = Malloc (DirNameLength))
		  {
		    if (NameFromLock (DirLock, DirName, DirNameLength))
		      {
			break;
		      }
		    if (IoErr () != ERROR_LINE_TOO_LONG)
		      {
			DosError = IoErr ();
		      }
		    Free (DirName);
		    DirName = NULL;
		    DirNameLength += 256;
		  }
		else
		  {
		    DosError = IoErr ();
		  }
	      }
	    while (!DosError);
	    if (!DosError && !(DosError = ReadDir (DirLock)))
	      {
		NodeDataTmp = NULL;
		NodeLength = 0;
		ReadMessage (DirLock);
		NodeLength += PrintMessage ();
		NodeLength += PrintDir (Name, DirName);
		if (Main)
		  {
		    NodeLength += PrintNodeText ("\n\n"
						 "@{\x22" "About the manual browser\x22 LINK \x22" "AbOuT\x22}\n");
		  }

		if ((NodeData = Malloc (NodeLength + 1)))
		  {
		    NodeDataTmp = NodeData;
		    PrintMessage ();
		    PrintDir (Name, DirName);
		    if (Main)
		      {
			PrintNodeText ("\n\n"
				       "@{\x22" "About the manual browser\x22 LINK \x22" "AbOuT\x22}\n");
		      }
		    ((struct opNodeIO *) Message)->onm_DocBuffer = NodeData;
		    ((struct opNodeIO *) Message)->onm_BuffLen = NodeLength;
		    UnLock (OldCurrDir);
		    OldCurrDir = DirLock;
		  }
		else
		  {
		    DosError = IoErr ();
		  }
		Free (MessageText);
		MessageText = NULL;
	      }
	    if (!NodeData)
	      UnLock (DirLock);
	    if (DirName)
	      {
		Free (DirName);
	      }
	  }
	else
	  {
	    DosError = IoErr ();
	  }
	CurrentDir (OldCurrDir);
	if (DosError)
	  {
	    static char FaultString[84];
	    ((struct opNodeIO *) Message)->onm_DocBuffer = FaultString;
	    ((struct opNodeIO *) Message)->onm_BuffLen = Fault (DosError, NULL, FaultString, sizeof (FaultString));
	  }
	return TRUE;
      }
      break;

    case HM_CLOSENODE:
      {
	if (NodeData)
	  Free (NodeData);
	NodeData = NULL;
	FreeDirNodes (&DirectoryList);
	FreeDirNodes (&FileList);
	return TRUE;
      }
      break;
    }
  return FALSE;
}
