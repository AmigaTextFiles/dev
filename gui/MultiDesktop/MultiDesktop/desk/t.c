#include "multidesktop.h"

struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase  *SysBase;
APTR IntuitionBase,GfxBase;

/* ---- Text einer ID-Nummer ermitteln */
/*
  ID-Nummer:

  "Text"       für keine Umwandlung, Ergebnis = "Text"
  "xxx:Text"   für ID xxx aus dem angegebenen Katalog
  "xxx§Text"   für ID xxx aus dem MultiDesktop-Katalog (System-ID)
*/

ULONG Catalog=7466L;

UBYTE *FindIt(cat,id)
 struct Catalog *cat;
 UBYTE           *id;
{
 UBYTE num[30];
 BOOL  hasNum,sysID;
 ULONG catID;
 int   i;

 if(id==NULL) return(NULL);

 hasNum=sysID=FALSE;
 i=0;
 printf("<%c>\n",'§');
 printf("Scan=");
 while((id[i]!=0x00)&&(i<20))
  {
   if(id[i]==(UBYTE)':')
    {
     num[i]=0x00;
     hasNum=TRUE;
     break;
    }
   else if(id[i]==(UBYTE)0xa7)
    {
     num[i]=0x00;
     hasNum=TRUE;
     sysID=TRUE;
     printf("<STOP>");
     break;
    }
   else
    {  num[i]=id[i]; printf("%c  %ld\n",num[i],num[i]=='§'); }
   i++;
  }

 puts("\n---------");

 if(!hasNum)
   return(id);

 printf("Num=%s\n",&num);

 catID=atol(&num);
 if(catID==0)
   return(id);

 if(sysID)
   cat=Catalog;

 printf("Num=%ld\n",catID);
 printf("Cat=%ld\n",cat);
}

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

   FindIt(345L,"3§Test!");

   DesktopExit();
   CloseLibrary(MultiDesktopBase);
   printf("Avail=%ld\n",AvailMem(MEMF_ANY));
  }
 else
   puts("No Libs!");
}

