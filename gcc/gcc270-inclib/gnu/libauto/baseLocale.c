/* call this with the following defines (for example):
   
   LIBRARY_NAME		"intuition.library"
   LIBRARY_BASE 	IntuitionBase
   LIBRARY_VERS 	__auto_intui_vers

 */

#include <exec/types.h>
#include <inline/exec.h>

#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

struct Library * LIBRARY_BASE = 0;
extern int LIBRARY_VERS;

#define STRING(a) a, sizeof (a) - 1

static void
constructor ()
{
  /*
  ** since this is for "locale.library", we must not exit if the
  ** library does not exist since then we will use builtin strings
  */

  LIBRARY_BASE = OpenLibrary (LIBRARY_NAME, LIBRARY_VERS);
}

static void
destructor ()
{
  struct Library **lib;

  if (*(lib=&LIBRARY_BASE))
    {
      CloseLibrary (*lib);
      *lib = 0;
    }
}

asm ("	.text; 	.stabs \"___CTOR_LIST__\",22,0,0,_constructor");
asm ("	.text; 	.stabs \"___DTOR_LIST__\",22,0,0,_destructor");
