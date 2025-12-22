#include "multidesktop.h"

struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase  *SysBase;
APTR IntuitionBase,GfxBase;

main()
{
 struct Node *node;
 struct List  list;
 BOOL         b1,b2;
 long i,j;

 IntuitionBase=OpenLibrary("intuition.library",0L);
 GfxBase=OpenLibrary("graphics.library",0L);
 MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
 if(MultiDesktopBase)
  {
   DesktopStartup(0L,STARTUP_ALERTHANDLER|STARTUP_TRAPHANDLER);
   puts("Programm gestartet!");

   FreeMem(0xffff0000,987);

   DesktopExit();
   CloseLibrary(MultiDesktopBase);
   printf("Avail=%ld\n",AvailMem(MEMF_ANY));
  }
 else
   puts("No Libs!");
}

