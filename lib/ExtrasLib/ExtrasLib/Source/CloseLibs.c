//#define __USE_SYSBASE

//#include <extras/libs.h>
#include <clib/extras_protos.h>

//#define __USE_SYSBASE
#include <proto/exec.h>

struct Library *MyExecBase;

/****** extras.lib/ex_CloseLibs ******************************************
*
*   NAME
*       ex_CloseLibs -- close multiple libraries.
*
*   SYNOPSIS
*       ex_CloseLibs(Libs)
*
*       void ex_CloseLibs(struct Libs *);
*
*   FUNCTION
*       Close multiple libraries using the same array of
*       struct Libs as used in OpenLibs.
*
*   INPUTS
*       Libs - A pointer to an array of struct Libs.
*
*   RESULT
*       none.
*
*   NOTES
*       exec.library must already be opened.(usually done by the 
*       compiler's startup code)
*
*       revision 1.1
*         corrected autodoc.
*         now openes ExecBase on it's own.
*       revision 1.2
*         renamed to ex_CloseLib due to conflict with reaction.lib
*
*   BUGS
*
*   SEE ALSO
*       ex_OpenLibs()
******************************************************************************
*
*/


void ex_CloseLibs(struct Libs *Libs)
{
  struct ExecBase *SysBase;
  struct Libs *l;
  
  l=Libs;
  
  SysBase=(struct ExecBase *)(*((ULONG *)4));
  
  while(l->LibName)
  {
    if(l->LibBase)
      if(*l->LibBase)
        CloseLibrary(*l->LibBase);
    l++;
  }   
}
