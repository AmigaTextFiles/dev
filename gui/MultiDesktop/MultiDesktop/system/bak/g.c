#include "multidesktop.h"

APTR MultiSystemBase;

ULONG crp[4];
ULONG tc;
ULONG tt0,tt1;

ULONG *PageTable;

main()
{
 ULONG a,b,c;

 MultiSystemBase=OpenLibrary("multisystem.library",0L);
 c=GetMMUType();
 if(c==68030)
  {
   puts("68030 MMU");
   GetCRP(&crp);
   tc=GetTC();
   tt0=GetTT0();
   tt1=GetTT1();
   printf("%08lx%08lx  %08lx  %08lx  %08lx\n",crp[0],crp[1],tc,tt0,tt1);


   PageTable=crp[1];




  } else puts("No 68030 MMU");
 puts("ok");
 RemLibrary(MultiSystemBase);
 CloseLibrary(MultiSystemBase);
}

