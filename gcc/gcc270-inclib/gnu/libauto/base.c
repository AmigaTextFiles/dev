/* call this with the following defines (for example):
   
   LIBRARY_NAME 	"intuition.library"
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
  if (!(LIBRARY_BASE = OpenLibrary (LIBRARY_NAME, LIBRARY_VERS)))
    {
      write (2, STRING("Can't open " LIBRARY_NAME "!\n"));
      abort ();
    }
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

asm (".text; .stabs \"___CTOR_LIST__\",22,0,0,_constructor");
asm (".text; .stabs \"___DTOR_LIST__\",22,0,0,_destructor");
