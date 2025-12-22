/*
   ARexx IPC for Amiga Pike

   Copyright (c) 1996 by Bernhard Fastenrath
   (fasten@cs.bonn.edu / fasten@shw.com)

   This file may be distributed under the terms
   of the GNU General Public License.
*/

#include "global.h"
#include "error.h"
#include "types.h"
#include "svalue.h"
#include "stralloc.h"
#include "pike_types.h"
#include "constants.h"
#include "interpret.h"
#include "arexx.h"

/* arexx_addlib() currently works only if compiled with SAS/C
   because it requires the following #pragma
*/
#ifdef __SASC
#pragma libcall RexxFunctionHostLibrary RexxCall 1e 901
struct Library *RexxFunctionHostLibrary = NULL;
#endif

#if defined (__SASC)
#define RXSLIB struct Library
#elif defined (__GNUC__)
#define RXSLIB struct RxsLib
#endif

struct Library *ScriptBase = NULL;
RXSLIB *RexxSysBase = NULL;

static struct RexxMsg *Rmsg = NULL;
static struct MsgPort *MyPort = NULL;
static char RexxHost[60] = "rexx_ced";
static int RexxArgc = 0;
static List LibraryList;
static struct ScriptContext *ScriptC = NULL;

/*** pike functions ***/

void
f_arexx_addlib (INT32 args)
{
  char *str;
  Node *n;

  if (args < 1)
    error ("Too few arguments to arexx_addlib().\n");

  if (sp[-args].type != T_STRING)
    error ("Bad argument 1 to arexx_addlib().\n");

  str = sp[-args].u.string->str;
  if (!FindName (&LibraryList, str))
  {
    if (!(n = (Node *) malloc (sizeof (Node))))
      error ("Out of memory.\n");
    if (!(n -> ln_Name = malloc (strlen (str + 1))))
    {
      free (n);
      error ("Out of memory.\n");
    }
    strcpy (n -> ln_Name, str);
    AddHead (&LibraryList, n);
  }
  pop_n_elems (args);
  push_int (1);
}

void
f_arexx_host (INT32 args)
{
  if (args < 1)
    error ("Too few arguments to arexx_host().\n");

  if (sp[-args].type != T_STRING)
    error ("Bad argument 1 to arexx_host().\n");

  strncpy (RexxHost, sp[-args].u.string->str, 60);

  pop_n_elems (args);
}

void
f_arexx_import (INT32 args)
{
  char *variable_value;
  struct pike_string *ret;

  if (args < 1)
    error ("Too few arguments to arexx_import().\n");

  if(sp[-args].type != T_STRING)
    error("Bad argument 1 to arexx_import().\n");

  Script_GetStringVar (ScriptC, sp[-args].u.string->str, &variable_value);

  if (variable_value)
    ret = make_shared_string (variable_value);
  else
    ret = make_shared_string ("");

  pop_n_elems (args);
  push_string (ret);
}

void
f_arexx_export (INT32 args)
{
  char *variable_name, *variable_value;

  if (args < 2)
    error ("Too few arguments to arexx_export().\n");

  if(sp[-args].type != T_STRING)
    error ("Bad argument 1 to arexx_export().\n");

  if(sp[-args+1].type != T_STRING)
    error ("Bad argument 2 to arexx_export().\n");

  variable_name  = sp[-args].u.string->str;
  variable_value = sp[-args+1].u.string->str;

  switch (Script_SetStringVar (ScriptC, variable_name, variable_value))
  {
    case 0:
      break;
    case ERR10_003:
      error ("Insufficient Storage");
    case ERR10_009:
      error ("String too long");
    default:
      error ("Unknown error");
  }
  pop_n_elems (args);
}

void
f_arexx_cmd (INT32 args)
{
  int t, return_code;

  if (args < 1)
    error ("Too few arguments to arexx_cmd().\n");

#ifdef __SASC
  if (FindName (&LibraryList, RexxHost))
  {
    for (t=0; t<args; t++)
    {
      if (sp[-args+t].type != T_STRING)
        error ("Bad argument type: arexx arguments must be strings.\n");
      if (!SetARexxArg (t, (char *) sp[-args+t].u.string->str))
        error ("out of memory.\n");
    }
    if (!ArexxLibraryCommand (&return_code))
      error ("Invalid rexx library parameter.\n");
  }
  else
#endif
  {
    char s[256], *str, *ptr = s;
    int len, rem = 255;

    for (t=0; t<args; t++)
    {
      if (sp[-args+t].type != T_STRING)
        error ("Bad argument type: arexx arguments must be strings.\n");
      len = strlen (str = (char *) sp[-args+t].u.string->str);
      if (len > rem)
        error ("Arexx command exceeds 256 characters.\n");
      strcpy (ptr, str);
      rem -= len;
      ptr += len;
      *ptr = ' ';
      ptr ++;
    }
    *(ptr-1) = '\0';

    if (!ArexxCommand (s, &return_code))
      error ("Bad rexx host parameter.\n");
  }
  pop_n_elems (args);
  push_int (return_code);
}

/*** module interface ***/

void exit_arexx (void);

void
init_arexx_efuns (void)
{
  atexit (exit_arexx);

  NewList (&LibraryList);

  if (!(RexxSysBase = (struct RxsLib *) OpenLibrary ("rexxsyslib.library", 36)))
    return;

  if (!(MyPort = CreateMsgPort ()))
    return;

  if (!(Rmsg = CreateRexxMsg (MyPort, NULL, NULL)))
    return;

  if (!(ScriptBase = OpenLibrary ("script.library", 0)))
    return;

  if (!(ScriptC = Script_AllocContext ()))
    return;

  Script_SetMsgContext (Rmsg, ScriptC);

  add_efun ("arexx_addlib", f_arexx_addlib,  "function(mixed ... : int)", OPT_SIDE_EFFECT);
  add_efun ("arexx_host", f_arexx_host, "function(string : void)", OPT_SIDE_EFFECT);
  add_efun ("arexx_export", f_arexx_export,  "function(string, string : void)", OPT_SIDE_EFFECT);
  add_efun ("arexx_import", f_arexx_import,  "function(string : string)", OPT_SIDE_EFFECT);
  add_efun ("arexx_cmd", f_arexx_cmd,  "function(mixed ... : int)", OPT_SIDE_EFFECT);
}

void
init_arexx_programs (void)
{}

void
exit_arexx (void)
{
  Node *n;

  if (!RexxSysBase)
    return;

  while (n = RemHead (&LibraryList))
  {
    free (n -> ln_Name);
    free (n);
  }
  if (ScriptC)
    Script_FreeContext (ScriptC);
  if (Rmsg)
    DeleteRexxMsg (Rmsg);
  if (MyPort)
    DeleteMsgPort (MyPort);
  if (RexxSysBase)
    CloseLibrary ((struct Library *) RexxSysBase);
  if (ScriptBase)
    CloseLibrary (ScriptBase);

  RexxSysBase = NULL;
}

/*** internal functions ***/

static void
ClearRexxResult (struct RexxMsg *r)
{
  /**  Hmmm :-) Probably correct.
   **  (My docs don't mention it)
   **/

  if (r -> rm_Result2)
  {
    DeleteArgstring ((UBYTE *) r -> rm_Result2);
    r -> rm_Result2 = 0;
  }
}

static int
SetARexxArg (int n, char *arg)
{
  RexxArgc = n;
  return (int) (Rmsg -> rm_Args[n] = CreateArgstring (arg, strlen (arg)));
}

static int
ArexxCommand (char *cmd, int *rc)
{
  struct MsgPort *hport;

  if (!(Rmsg -> rm_Args[0] = CreateArgstring (cmd, strlen (cmd))))
    error ("Out of memory.\n");
  Rmsg -> rm_Node.mn_Node.ln_Type = NT_MESSAGE;
  Rmsg -> rm_Node.mn_Length = sizeof (struct RexxMsg);
  Rmsg -> rm_Action = RXFUNC | RXFF_RESULT;
  Rmsg -> rm_Node.mn_ReplyPort = MyPort;

  Forbid ();
  if (!(hport = FindPort (RexxHost)))
  {
    Permit ();
    return 0;
  }
  PutMsg (hport, (struct Message *) Rmsg);
  Permit ();
  do
    WaitPort (MyPort);
  while (GetMsg (MyPort) != (struct Message *) Rmsg);

  if (Rmsg -> rm_Result2)
    *rc = atoi ((char *) Rmsg -> rm_Result2);
  else
    *rc = Rmsg -> rm_Result1;

  ClearRexxMsg (Rmsg, 1);
  ClearRexxResult (Rmsg);
  return 1;
}

#ifdef __SASC
static int
ArexxLibraryCommand (int *rc)
{
  if (!(RexxFunctionHostLibrary = OpenLibrary (RexxHost, 0L)))
    return 0;

#ifdef DEBUG
  PrintRexxArgs (Rmsg);
#endif

  Rmsg -> rm_Action = RXFUNC | RXFF_RESULT | RexxArgc;
  RexxCall (Rmsg);
  CloseLibrary (RexxFunctionHostLibrary);

#ifdef DEBUG
  PrintRexxArgs (Rmsg);
#endif

  if (Rmsg -> rm_Result2)
    *rc = atoi ((char *) Rmsg -> rm_Result2);
  else
    *rc = Rmsg -> rm_Result1;

  ClearRexxMsg (Rmsg, RexxArgc + 1);
  ClearRexxResult (Rmsg);

  RexxArgc = 0;
  return 1;
}
#endif

#ifdef DEBUG
static int
PrintRexxArgs (struct RexxMsg *rm)
{
  int t;

  printf ("--- printargs ---\n");
  for (t=0; t <= MAXRMARG; t++)
  {
    if (rm -> rm_Args[t])
      printf ("Arg[%d] = \"%s\".\n", t, rm -> rm_Args[t]);
  }
  if (rm -> rm_Result2)
    printf ("Result = \"%s\".\n", rm -> rm_Result2);
  else
    printf ("Result = <null>.\n");
  return 0;
}
#endif
