/* Library replacement routines */

#include <exec/libraries.h>
#include <clib/exec_protos.h>
#include <intuition/classes.h>
#include <dos/dos.h>
#include "class.h"

#pragma libbase classbase  /* So StormCs linker knows the libbase size.. */

extern struct ExecBase *SysBase;
struct Library *IntuitionBase;
struct Library *UtilityBase;
struct Library *GfxBase;

BPTR LibExpunge();

struct classbase *LibInit(
	register __d0 struct classbase *base,
	register __a0 BPTR seglist,
	register __a6 APTR sysbase)
{
  base->seglist = seglist;
  SysBase = sysbase;
  if(IntuitionBase = OpenLibrary("intuition.library",37))
  {
    if(UtilityBase = OpenLibrary("utility.library",37))
    {
     if(GfxBase = OpenLibrary("graphics.library",37)) return(base);
     CloseLibrary(UtilityBase);
    }
    CloseLibrary(IntuitionBase);
  }
  return(NULL);
}

struct Library *LibOpen(register __a6 struct classbase *base)
{
  if(!(base->library.lib_OpenCnt)) initclass(base);
  base->library.lib_Flags &= ~LIBF_DELEXP;
  base->library.lib_OpenCnt++;
  return((struct Library *)base);
}

BPTR LibClose(register __a6 struct classbase *base)
{
  base->library.lib_OpenCnt--;
  if(!base->library.lib_OpenCnt)
    if(base->library.lib_Flags&LIBF_DELEXP) return(LibExpunge());
  return(NULL);
}

BPTR LibExpunge(register __a6 struct classbase *base)
{
  BPTR result;
  UBYTE *libmem;
  LONG libsize;

  if(base->library.lib_OpenCnt)
  {
    base->library.lib_Flags |= LIBF_DELEXP;
    return(NULL)
  }
  else
  {
    result = base->seglist;
    Remove((struct Node *)base);
    CloseLibrary(GfxBase);
    CloseLibrary(UtilityBase);
    CloseLibrary(IntuitionBase);
    removeclass(base);
    libmem = (UBYTE *)base;
    libsize = base->library.lib_NegSize;
    libmem -= libsize;
    libsize += base->library.lib_PosSize;
    FreeMem(libmem,libsize);
    return(result);
  }
}

 ULONG LibNull(void)
{
  return(NULL);
}


/* This function converts register-parameter hook calling
 * convention into standard C conventions.
 */
ULONG hookEntry(
    register __a0 struct Hook *h,
    register __a2 VOID *o,
    register __a1 VOID *msg)
{
    return ((*h->h_SubEntry)(h, o, msg));
}


