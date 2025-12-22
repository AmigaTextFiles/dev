/* Library replacement routines */

#include <exec/libraries.h>
#include <proto/exec.h>
#include <intuition/classes.h>
#include <dos/dos.h>
#include "class.h"

#pragma libbase classbase  /* So StormCs linker knows the libbase size.. */

extern struct ExecBase *SysBase;
struct Library *IntuitionBase;
struct Library *UtilityBase;
struct Library *GfxBase;
struct Library *textibase;
struct Library *glyphibase;
struct Library *buttonbase;
#ifdef DEBUG
 #include "debug_protos.h"
 APTR console;
#endif

BPTR LibExpunge();
BOOL openlibs(void);
void closelibs(void);

struct classbase *LibInit(
	register __d0 struct classbase *base,
	register __a0 BPTR seglist,
	register __a6 APTR sysbase)
{
  base->seglist = seglist;
  SysBase = sysbase;
  if(openlibs()) return(base);
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
    closelibs();
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

BOOL openlibs(void)
{
  IntuitionBase = OpenLibrary("intuition.library",37);
  UtilityBase = OpenLibrary("utility.library",37);
  GfxBase = OpenLibrary("graphics.library",37);
  textibase = OpenLibrary("CFtext.image",NULL);
  if(!textibase) textibase = OpenLibrary("Images/CFtext.image",NULL);
  glyphibase = OpenLibrary("CFglyph.image",NULL);
  if(!glyphibase) glyphibase = OpenLibrary("Images/CFglyph.image",NULL);
  buttonbase = OpenLibrary("CFbutton.gadget",NULL);
  if(!buttonbase) buttonbase = OpenLibrary("Gadgets/CFbutton.gadget",NULL);
#ifdef DEBUG
  console = DLopencon();
#endif
  if(IntuitionBase&&UtilityBase&&GfxBase&&
  	textibase&&glyphibase&&buttonbase) return(TRUE);
  closelibs();
  return(FALSE);
}

void closelibs(void)
{
#ifdef DEBUG
  DLclosecon(console);
#endif
  CloseLibrary(buttonbase);
  CloseLibrary(glyphibase);
  CloseLibrary(textibase);
  CloseLibrary(GfxBase);
  CloseLibrary(UtilityBase);
  CloseLibrary(IntuitionBase);
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


