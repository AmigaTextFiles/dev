#include "multidesktop.h"

struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase  *SysBase;

APTR IntuitionBase,LocaleBase;
APTR UtilityBase,GfxBase;
struct Catalog  *Catalog;
struct Library  *VersionBase;
struct Library  *TimerBase,*InputBase;
struct timeval tv1,tv2;
struct MultiTime time;

main()
{
 struct Node *node;
 struct List  list;
 BOOL         b1,b2;
 long i,j;

 IntuitionBase=OpenLibrary("intuition.library",0L);
 GfxBase=OpenLibrary("graphics.library",0L);
 MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
 printf("base=%lx = %lx\n",MultiDesktopBase,FindName(&SysBase->LibList,"multidesktop.library"));
 if(MultiDesktopBase)
  {
   UtilityBase=MultiDesktopBase->UtilityLib;
   LocaleBase=MultiDesktopBase->LocaleLib;
   TimerBase=MultiDesktopBase->TimerLib;
   InputBase=MultiDesktopBase->InputLib;

   GetBattClockTime(&time);
   SetTime(&time);

   printf("%02d.%02d. %d   %2d:%02d:%02d\n",
           time.Day,time.Month,time.Year,
           time.Hour,time.Minute,time.Second);

   puts("SetAlarm()");
   SetAlarm(49);
   for(i=0;i<20;i++)
    {
     Delay(5);

   GetTime(&time);

     b1=CheckAlarm(); if(b1==TRUE) puts("Okay!"); else puts("Warte...");
    }
   puts("ENDE.");

   GetSysTime(&tv1);
   printf("%8ld  %8ld\n",tv1.tv_secs,tv1.tv_micro);

   RemLibrary(MultiDesktopBase);
   CloseLibrary(MultiDesktopBase);
   printf("Avail=%ld\n",AvailMem(MEMF_ANY));
  }
 else
   puts("No Libs!");
/* RemoveLib(); */
}

