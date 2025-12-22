#include <exec/types.h>
#include <exec/libraries.h>

#include <clib/alib_protos.h>

#include "protos.h"

BOOL i_OpenLibs(void);
void i_CloseLibs(void);

ULONG __asm DispatcherStub(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M);

/**************************************************************************************/

struct Library *SuperModelBase;

int __saveds __asm __UserLibInit(register __a6 struct Library *LibBase)
{
  SuperModelBase=LibBase;
  if(i_OpenLibs())
  {
    if(i_SuperModelInit())
    {
      return(0);
    }
    i_CloseLibs();
  }
  return(-1);
}

void __saveds __asm __UserLibCleanup(register __a6 struct Library *LibBase)
{
  i_SuperModelTerm();
  i_CloseLibs();
}
