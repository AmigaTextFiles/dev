/* MultiDesktop-Library - Memory, Timer, Locale, Requester */
#include "multidesktop.h"

BOOL            StrIsGreaterThan();
BOOL            StrIsLessThan();
UBYTE          *AllocMemory();
UBYTE          *GetLStr();
UBYTE          *FindID();
void            Seconds2StarDate();
struct Library *OpenDevLibrary();
void            FreeMemory();
void            FreeMemoryBlock();
void            ErrorL();
void            OldError();
void            CloseDevLibrary();
void            RemoveLib();
extern ULONG    HookEntry();
extern UBYTE    ToUpper();

extern struct MultiDesktopBase *MultiDesktopBase;
extern struct ExecBase         *SysBase;

struct Catalog                 *Catalog;
struct Library                 *LocaleBase;
struct Library                 *UtilityBase;
struct Library                 *TimerBase;
struct Library                 *InputBase;
struct Library                 *BattClockBase;
struct Library                 *IntuitionBase;
struct Library                 *DOSBase;

extern ULONG  SleepPointerSize;
extern UBYTE *SleepPointerData;
UBYTE        *ChipData;

struct IntuiText t1=
{
 AUTOFRONTPEN,
 AUTOBACKPEN,
 AUTODRAWMODE,
 AUTOLEFTEDGE,
 AUTOTOPEDGE,
 NULL,
 NULL,
 NULL
};

struct IntuiText t2=
{
 AUTOFRONTPEN,
 AUTOBACKPEN,
 AUTODRAWMODE,
 AUTOLEFTEDGE,
 AUTOTOPEDGE,
 NULL,
 "Abort!",
 NULL
};

/* ---- Library initialisieren */
ULONG InitLib()
{
 MultiDesktopBase->IntLib=OpenLibrary("intuition.library",0L);
 if(MultiDesktopBase->IntLib==NULL)
  { RemoveLib(); exit(0); }

 IntuitionBase=MultiDesktopBase->IntLib;
 if(IntuitionBase->lib_Version<37) {
   OldError("This software requires AmigaDOS 2.0 (V37)!");
   RemoveLib(); return(0); }

 MultiDesktopBase->GfxLib=OpenLibrary("graphics.library",37L);
 if(MultiDesktopBase->GfxLib==NULL)
  { OldError("Unable to open graphics.library V37!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->DosLib=OpenLibrary("dos.library",37L);
 if(MultiDesktopBase->DosLib==NULL)
  { OldError("Unable to open dos.library V37!");
    RemoveLib(); exit(0); }
 DOSBase=MultiDesktopBase->DosLib;

 MultiDesktopBase->DiskfontLib=OpenLibrary("diskfont.library",36L);
 if(MultiDesktopBase->DiskfontLib==NULL)
  { OldError("Unable to open diskfont.library V36!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->GadToolsLib=OpenLibrary("gadtools.library",37L);
 if(MultiDesktopBase->GadToolsLib==NULL)
  { OldError("Unable to open gadtools.library V37!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->IconLib=OpenLibrary("icon.library",37L);
 if(MultiDesktopBase->IconLib==NULL)
  { OldError("Unable to open icon.library V37!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->LayersLib=OpenLibrary("layers.library",37L);
 if(MultiDesktopBase->LayersLib==NULL)
  { OldError("Unable to open layers.library V37!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->WorkbenchLib=OpenLibrary("workbench.library",37L);
 if(MultiDesktopBase->WorkbenchLib==NULL)
  { OldError("Unable to open workbench.library V37!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->ExpansionLib=OpenLibrary("expansion.library",37L);
 if(MultiDesktopBase->ExpansionLib==NULL)
  { OldError("Unable to open expansion.library V37!");
    RemoveLib(); exit(0); }

 MultiDesktopBase->UtilityLib=OpenLibrary("utility.library",37L);
 if(MultiDesktopBase->UtilityLib==NULL)
  { OldError("Unable to open utility.library V37!");
    RemoveLib(); exit(0); }
 UtilityBase=MultiDesktopBase->UtilityLib;

 MultiDesktopBase->KeymapLib=OpenLibrary("keymap.library",37L);
 if(MultiDesktopBase->KeymapLib==NULL)
  { OldError("Unable to open keymap.library V37!");
    RemoveLib(); exit(0); }


 MultiDesktopBase->VersionLib=OpenLibrary("version.library",0L);
 MultiDesktopBase->LocaleLib=OpenLibrary("locale.library",38L);
 if(MultiDesktopBase->LocaleLib!=NULL)
  {
   LocaleBase=MultiDesktopBase->LocaleLib;
   MultiDesktopBase->Locale=OpenLocale(NULL);
   if(MultiDesktopBase->Locale!=NULL)
    {
     MultiDesktopBase->Catalog=OpenCatalogA(MultiDesktopBase->Locale,
                                            "multidesktop.catalog",
                                            NULL);
     Catalog=MultiDesktopBase->Catalog;
    }
  }

 MultiDesktopBase->TimerLib=OpenDevLibrary("timer.device",0);
 if(MultiDesktopBase->TimerLib==NULL) {
   OldError("Unable to open timer.device!");
   RemoveLib(); return(0); }

 MultiDesktopBase->ConsoleLib=OpenDevLibrary("console.device",0);
 if(MultiDesktopBase->ConsoleLib==NULL) {
   OldError("Unable to open console.device!");
   RemoveLib(); return(0); }

 MultiDesktopBase->InputLib=OpenDevLibrary("input.device",0);
 if(MultiDesktopBase->InputLib==NULL) {
   OldError("Unable to open input.device!");
   RemoveLib(); return(0); }

 ChipData=AllocMem(SleepPointerSize,MEMF_CHIP|MEMF_PUBLIC);
 if(ChipData!=NULL)
   CopyMemQuick(&SleepPointerData,ChipData,SleepPointerSize);

 MultiDesktopBase->BattClockLib=OpenResource("battclock.resource",0);
 BattClockBase=MultiDesktopBase->BattClockLib;

 TimerBase=MultiDesktopBase->TimerLib;
 InputBase=MultiDesktopBase->InputLib;

 return(1L);
}

/* ---- Library entfernen */
void RemoveLib()
{
 if(ChipData) FreeMem(ChipData,SleepPointerSize);
 if(MultiDesktopBase->TimerLib) CloseDevLibrary(MultiDesktopBase->TimerLib);
 if(MultiDesktopBase->ConsoleLib) CloseDevLibrary(MultiDesktopBase->ConsoleLib);
 if(MultiDesktopBase->InputLib) CloseDevLibrary(MultiDesktopBase->InputLib);

 if(MultiDesktopBase->Catalog) CloseCatalog(MultiDesktopBase->Catalog);
 if(MultiDesktopBase->Locale) CloseLocale(MultiDesktopBase->Locale);
 if(MultiDesktopBase->LocaleLib) CloseLibrary(MultiDesktopBase->LocaleLib);
 if(MultiDesktopBase->VersionLib) CloseLibrary(MultiDesktopBase->VersionLib);
 if(MultiDesktopBase->KeymapLib) CloseLibrary(MultiDesktopBase->KeymapLib);
 if(MultiDesktopBase->ExpansionLib) CloseLibrary(MultiDesktopBase->ExpansionLib);
 if(MultiDesktopBase->UtilityLib) CloseLibrary(MultiDesktopBase->UtilityLib);
 if(MultiDesktopBase->WorkbenchLib) CloseLibrary(MultiDesktopBase->WorkbenchLib);
 if(MultiDesktopBase->LayersLib) CloseLibrary(MultiDesktopBase->LayersLib);
 if(MultiDesktopBase->IconLib) CloseLibrary(MultiDesktopBase->IconLib);
 if(MultiDesktopBase->GadToolsLib) CloseLibrary(MultiDesktopBase->GadToolsLib);
 if(MultiDesktopBase->DiskfontLib) CloseLibrary(MultiDesktopBase->DiskfontLib);
 if(MultiDesktopBase->GfxLib) CloseLibrary(MultiDesktopBase->GfxLib);
 if(MultiDesktopBase->IntLib) CloseLibrary(MultiDesktopBase->IntLib);
 if(MultiDesktopBase->DosLib) CloseLibrary(MultiDesktopBase->DosLib);
}

/* ---- Multi-Requester */
LONG MultiRequest(titel,text,gads)
 UBYTE *titel,*text,*gads;
{
 struct EasyStruct easy;

 easy.es_StructSize=sizeof(struct EasyStruct);
 easy.es_Flags=0;
 easy.es_Title=titel;
 easy.es_TextFormat=text;
 easy.es_GadgetFormat=gads;
 return(EasyRequestArgs(NULL,&easy,0L,0L));
}

/* ---- Fehler-Requester */
LONG ErrorRequest(titel,text,gads)
 UBYTE *titel,*text,*gads;
{
 if(titel==NULL) titel=GetLStr(1,"MultiDesktop - Error!");
 if(gads==NULL) gads=GetLStr(2,"Okay");
 return(MultiRequest(FindID(Catalog,titel),
                     FindID(Catalog,text),
                     FindID(Catalog,gads)));
}

/* ---- Okay-Requester */
void OkayRequest(text)
 UBYTE *text;
{
 MultiRequest("MultiDesktop",text,GetLStr(2,"Okay"));
}

/* ---- Einzeiliger Requester, Kickstart 1.1-kompatibel */
void OldError(text)
 UBYTE *text;
{
 struct IntuiText it;

 CopyMemQuick(&t1,&it,sizeof(struct IntuiText));
 it.IText=text;
 AutoRequest(NULL,&it,&t2,&t2,0L,0L,320,75);
}

/* ---- Fehler-Requester */
void ErrorL(num,text)
 int    num;
 UBYTE *text;
{
 if(text==NULL) text="Not enough memory!";
 MultiRequest(GetLStr(1,"MultiDesktop - Error!"),GetLStr(num,text),GetLStr(2,"Okay"));
}

/* ---- Stringadresse ermitteln */
UBYTE *GetLStr(num,def)
 LONG   num;
 UBYTE *def;
{
 if(Catalog==NULL) return(def);
 return(GetCatalogStr(Catalog,num,def));
}

struct ProcSegment
{
 ULONG Length;
 BPTR  Next;
 UWORD OpCode;
 VOID (* Address)();
};

/* ---- Neuen Prozess erstellen */
struct Task *CreateNewProcess(function,stack,name,pri)
 VOID   (* function)();
 ULONG  stack;
 UBYTE *name;
 BYTE   pri;
{
 struct Process *proc;
 struct ProcSegment *Segment;

 Segment=AllocMem(sizeof(struct ProcSegment),MEMF_CLEAR|MEMF_PUBLIC);
 if(Segment==NULL) return(NULL);
 Segment->Length=sizeof(struct ProcSegment);
 Segment->Next=NULL;
 Segment->OpCode=0x4EF9;
 Segment->Address=function;
 Segment=(LONG)(&(Segment->Next)) >> 2;

 proc=CreateProc(name,pri,Segment,stack);
 if(proc==NULL) return(NULL);

 return((struct Task *)((ULONG)proc-(ULONG)sizeof(struct Task)));
}

void SleepPointer(win)
 struct Window *win;
{
 if(ChipData) SetPointer(win,ChipData,22,16,-7,-7);
}

/* ---- User initialisieren */
struct MultiDesktopUser *InitDesktopUser(task)
 struct Task *task;
{
 struct MultiDesktopUser *mu;

 Forbid();
 if(task==NULL) task=SysBase->ThisTask;
 mu=task->tc_UserData;
 if(mu==NULL)
  {
   mu=AllocMem(MULTI_SIZE,MEMF_CLEAR|MEMF_PUBLIC);
   if(mu!=NULL)
    {
     mu->UserCount=1;
     mu->MagicID=MAGIC_ID;
     mu->TimerPort=CreatePort(0L,0L);
     if(mu->TimerPort!=NULL)
      {
       mu->TimerReq=CreateIORequest(mu->TimerPort,sizeof(struct timerequest));
       if(mu->TimerReq!=NULL)
        {
         mu->TimerDev=OpenDevice("timer.device",UNIT_VBLANK,mu->TimerReq,0);
         if(mu->TimerDev==0)
          {
           task->tc_UserData=mu;
           Permit();
           return(mu);
          }
         else
           ErrorL(6,"Unable to open timer.device!");
         DeleteIORequest(mu->TimerReq);
        }
       else
         ErrorL(0,0);
       DeletePort(mu->TimerPort);
      }
     else
       ErrorL(5,"Unable to create port!");
     FreeMem(mu,MULTI_SIZE);
     mu=NULL;
    }
  }
 else
  {
   if(mu->MagicID!=MAGIC_ID)
    {
     mu=NULL;
     ErrorL(4,"Task->tc_UserData is already used by another program or\n"
              "the structure is invalid! Try to start the program again\n"
              "with 'Run' or from Workbench!");
    }
   else
     mu->UserCount++;
  }
 Permit();
 return(mu);
}

/* ---- User entfernen */
void TerminateDesktopUser(task)
 struct Task *task;
{
 struct MultiDesktopUser *mu;

 Forbid();
 if(task==NULL) task=SysBase->ThisTask;
 mu=task->tc_UserData;
 if(mu!=NULL)
  {
   mu->UserCount--;
   if(mu->UserCount==0)
    {
     AbortIO(mu->TimerReq);
     CloseDevice(mu->TimerReq);
     DeleteIORequest(mu->TimerReq);
     DeletePort(mu->TimerPort);
     if(mu->Remember.FirstRemember) FreeMemory(&mu->Remember);
     FreeMem(mu,MULTI_SIZE);
     task->tc_UserData=NULL;
    }
  }
 Permit();
}

/* ---- Speicher belegen */
UBYTE *GetMem(size,flags)
 ULONG size,flags;
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 return(AllocMemory(&mu->Remember,size,flags));
}

/* ---- Speicher freigeben */
void DisposeMem(block)
 UBYTE *block;
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 if(block)
   FreeMemoryBlock(&mu->Remember,block);
}

/* ---- Speicher belegen */
UBYTE *AllocMemory(rem,size,flags)
 struct MultiRemember *rem;
 ULONG                 size,flags;
{
 struct MultiRememberEntry *mem;

 Forbid();
 mem=AllocMem(size+12L,flags);
 if(mem)
  {
   mem->PrevRemember=NULL;
   mem->NextRemember=NULL;
   mem->MemorySize=size+12L;

   if(rem->FirstRemember==NULL)
    {
     rem->FirstRemember=mem;
     rem->LastRemember=mem;
    }
   else
    {
     mem->PrevRemember=rem->LastRemember;
     rem->LastRemember->NextRemember=mem;
     rem->LastRemember=mem;
    }

   mem=(ULONG)mem+12L;
  }
 Permit();
 return(mem);
}

/* ---- Speicher mit bestimmten Alignment belegen */
UBYTE *AllocAlignedMemory(rem,size,flags,align)
 struct MultiRemember *rem;
 ULONG                 size,flags,align;
{
 ULONG                      add;
 struct MultiRememberEntry *mem;

 Forbid();
 mem=AllocMem(size+align+12L,flags);
 add=((ULONG)mem % align);
 if(add!=0)
  {
   FreeMem(mem,size+align+12L);
   mem=AllocAbs(size+12L,mem+add);
  }
 if(mem)
  {
   mem->PrevRemember=NULL;
   mem->NextRemember=NULL;
   mem->MemorySize=size+12L;

   if(rem->FirstRemember==NULL)
    {
     rem->FirstRemember=mem;
     rem->LastRemember=mem;
    }
   else
    {
     mem->PrevRemember=rem->LastRemember;
     rem->LastRemember->NextRemember=mem;
     rem->LastRemember=mem;
    }

   mem=(ULONG)mem+12L;
  }
 Permit();
 return(mem);
}

/* ---- Speicher freigeben */
void FreeMemory(rem)
 struct MultiRemember *rem;
{
 UBYTE                     *m;
 ULONG                      s;
 struct MultiRememberEntry *mem;

 Forbid();
 mem=rem->FirstRemember;
 while(mem!=NULL)
  {
   m=mem;
   s=mem->MemorySize;
   mem=mem->NextRemember;
   FreeMem(m,s);
  }
 rem->FirstRemember=NULL;
 rem->LastRemember=NULL;
 Permit();
}

/* ---- Speicherblock freigeben */
void FreeMemoryBlock(rem,block)
 struct MultiRemember      *rem;
 UBYTE                     *block;
{
 struct MultiRememberEntry *mem;

 mem=(ULONG)block-12L;

 Forbid();
 if(mem->PrevRemember)
   mem->PrevRemember->NextRemember=mem->NextRemember;
 if(mem->NextRemember)
   mem->NextRemember->PrevRemember=mem->PrevRemember;
 if(mem==rem->FirstRemember) rem->FirstRemember=mem->NextRemember;
 if(mem==rem->LastRemember) rem->LastRemember=mem->PrevRemember;
 Permit();

 FreeMem(mem,mem->MemorySize);
}

/* ---- Text einer ID-Nummer ermitteln */
UBYTE *FindID(cat,id)
 struct Catalog *cat;
 UBYTE           *id;
{
 UBYTE         num[200];
 REGISTER BOOL hasNum;
 ULONG         catID;
 register int  i;

 if(id==NULL) return(NULL);

 hasNum=FALSE;
 i=0;
 while(id[i]!=0x00)
  {
   if(id[i]!=':')
     num[i]=id[i];
   else
    {
     num[i]=0x00;
     hasNum=TRUE;
     break;
    }
   i++;
  }

 if(!hasNum)
   return(id);

 catID=atol(&num);
 if(catID==0)
   return(id);

 return(GetCatalogStr(cat,catID,&id[i+1]));
}

/* ---- Asynchroner Programmstart */
void ASyncRun(name)
 UBYTE *name;
{
 struct TagItem              tag[5];
 register struct FileHandle *con;

 con=Open("CON:10/20/620/150/MultiDesktop/AUTO/WAIT/CLOSE",MODE_NEWFILE);
 if(con!=NULL)
  {
   tag[0].ti_Tag=SYS_Input;
   tag[0].ti_Data=NULL;
   tag[1].ti_Tag=SYS_Output;
   tag[1].ti_Data=con;
   tag[2].ti_Tag=SYS_Asynch;
   tag[2].ti_Data=TRUE;
   tag[3].ti_Tag=SYS_UserShell;
   tag[3].ti_Data=TRUE;
   tag[4].ti_Tag=TAG_DONE;
   SystemTagList(name,&tag);
  }
 else
   ErrorL(3,"Unable to open AutoCon-window!");
}

/* ---- Synchroner Programmstart */
void SyncRun(name)
 UBYTE *name;
{
 struct TagItem tag[3];

 tag[0].ti_Tag=SYS_Input;
 tag[0].ti_Data=Input();
 tag[1].ti_Tag=SYS_Output;
 tag[1].ti_Data=Output();
 tag[2].ti_Tag=TAG_DONE;
 SystemTagList(name,&tag);
}

/* ---- Node suchen */
struct Node *FindNode(list,num)
 struct List *list;
 ULONG        num;
{
 register struct Node *node;
 register ULONG        i;

 i=0;
 for(node=list->lh_Head;node!=&list->lh_Tail;node=node->ln_Succ)
  {
   if(i==num) return(node);
   i++;
  }
 return(NULL);
}

/* ---- Nodes zählen */
struct Node *CountNodes(list)
 struct List *list;
{
 register struct Node *node;
 register ULONG        i;

 i=0;
 for(node=list->lh_Head;node!=&list->lh_Tail;node=node->ln_Succ)
   i++;
 return(i);
}

/*
   Stringvergleich für Sortierung:
   =>  TRUE,  wenn String A > B
*/
BOOL StrIsGreaterThan(a,b)
 UBYTE *a,*b;
{
 register int l1,l2,l,i;

 l1=strlen(a);
 l2=strlen(b);

 if(l1>l2) l=l2; else l=l1;

 for(i=0;i<l;i++)
  {
   if(ToUpper(a[i]) > ToUpper(b[i]))
     return(TRUE);
   else if(ToUpper(b[i]) > ToUpper(a[i]))
     return(FALSE);
  }
 if(l1>l2) return(TRUE);
 return(FALSE);
}

/*
   Stringvergleich für Sortierung:
   =>  TRUE,  wenn String A < B
*/
BOOL StrIsLessThan(a,b)
 UBYTE *a,*b;
{
 register int l1,l2,l,i;

 l1=strlen(a);
 l2=strlen(b);

 if(l1>l2) l=l2; else l=l1;

 for(i=0;i<l;i++)
  {
   if(ToUpper(a[i]) > ToUpper(b[i]))
     return(FALSE);
   else if(ToUpper(b[i]) > ToUpper(a[i]))
     return(TRUE);
  }
 if(l1>l2) return(TRUE);
 return(FALSE);
}

/* ---- Sortiert einfügen */
void InsertSort(list,node,place)
 struct List *list;
 struct Node *node;
 UBYTE        place;
{
 BOOL         okay;
 struct Node *old,*prev;
 BOOL         sort;

 if(place==SORT_DESCENDING) sort=TRUE; else sort=FALSE;
 prev=NULL; okay=FALSE;
 for(old=list->lh_Head;old!=&list->lh_Tail;old=old->ln_Succ)
  {
   if((StrIsGreaterThan(node->ln_Name,old->ln_Name))==sort)
    {
     okay=TRUE;
     if(prev==NULL)
       AddHead(list,node);
     else
       Insert(list,node,prev);
     break;
    }
   prev=old;
  }
 if(okay==FALSE) AddTail(list,node);
}

/* ---- QuickSort-Hauptteil (Aufsteigend sortieren) */
void QuickSortMainA(array,start,end)
 struct Node  **array;
 long           start,end;
{
 struct Node *help;
 UBYTE       *vge;
 long         i,j;

 vge=array[(start+end)/2]->ln_Name;
 i=start;
 j=end;
 do
  {
   while((StrIsLessThan(array[i]->ln_Name,vge))) i++;
   while((StrIsGreaterThan(array[j]->ln_Name,vge))) j--;

   if(i<=j)
    {
     help=array[i];
     array[i]=array[j];
     array[j]=help;
     i++;
     j--;
    }
  } while(i<=j);

 if(j>start) QuickSortMainA(array,start,j);
 if(end>i) QuickSortMainA(array,i,end);
}

/* ---- QuickSort-Hauptteil (Absteigend sortieren) */
void QuickSortMainD(array,start,end)
 struct Node  *array[];
 long          start,end;
{
 struct Node *help;
 UBYTE       *vge;
 long         i,j;

 vge=array[(start+end)/2]->ln_Name;
 i=start;
 j=end;
 do
  {
   while((StrIsGreaterThan(array[i]->ln_Name,vge))) i++;
   while((StrIsLessThan(array[j]->ln_Name,vge))) j--;

   if(i<=j)
    {
     help=array[i];
     array[i]=array[j];
     array[j]=help;
     i++;
     j--;
    }

  } while(i<=j);
 if(j>start) QuickSortMainD(array,start,j);
 if(end>i) QuickSortMainD(array,i,end);
}

/* ---- Liste sortieren */
BOOL SortList(list,place)
 struct List *list;
 UBYTE        place;
{
 REGISTER ULONG        i,count;
 REGISTER ULONG       *array;
 register struct Node *node;

 count=CountNodes(list);
 if(count<2) return;

 array=AllocVec((count*4)+8,MEMF_ANY);
 if(array)
  {
   for(node=list->lh_Head,i=0;node!=&list->lh_Tail;node=node->ln_Succ,i++)
     array[i]=node;
   NewList(list);

   if(place==SORT_DESCENDING)
     QuickSortMainD(array,0,count-1);
   else
     QuickSortMainA(array,0,count-1);

   for(i=0;i<count;i++)
     AddTail(list,array[i]);
   FreeVec(array);
  }
 else
  { ErrorL(0,0); return(FALSE); }
 return(TRUE);
}

/* ---- Listen zusammenfügen */
void ConcatList(list,list2)
 struct List *list,*list2;
{
 register struct Node *node,*succ;

 if(list==NULL) return;
 if(list2==NULL) return;

 node=list2->lh_Head;
 while(node!=&list2->lh_Tail)
  {
   succ=node->ln_Succ;
   AddTail(list,node);
   node=succ;
  }
 NewList(list2);
}

/* ---- Liste duplizieren */
struct List *DupList(list,size)
 struct List *list;
{
 REGISTER ULONG        name;
 register long         size2;
 register struct Node *node;
 register struct Node *xn;
 register struct List *xl;

 if(list==NULL) return;

 size += (size % 4);
 xl=GetMem(sizeof(struct List),MEMF_CLEAR|MEMF_PUBLIC);
 if(xl==NULL) return(NULL);
 NewList(xl);

 for(node=list->lh_Head;node!=&list->lh_Tail;node=node->ln_Succ)
  {
   size2=size;
   if(node->ln_Name) size2+=strlen(node->ln_Name)+1;
   xn=GetMem(size2,MEMF_PUBLIC);
   if(xn!=NULL)
    {
     CopyMemQuick(node,xn,size);
     if(node->ln_Name)
      {
       name=(ULONG)xn+(ULONG)size;
       strcpy(name,node->ln_Name);
       xn->ln_Name=name;
      }
     AddTail(xl,xn);
    }
  }

 return(xl);
}

/* ---- Liste freigeben */
void FreeList(list)
 struct List *list;
{
 struct Node *node,*succ;

 if(list==NULL) return;

 node=list->lh_Head;
 while(node!=&list->lh_Tail)
  {
   succ=node->ln_Succ;
   DisposeMem(node);
   node=succ;
  }
 DisposeMem(list);
}

/* ---- Listen zusammenfügen mit Kopieren der Quellliste */
void CopyConcatList(list,list2)
 struct List *list,*list2;
{
 register struct List *list3;

 if(list==NULL) return;
 if(list2==NULL) return;

 list3=DupList(list2);
 if(list3)
  {
   ConcatList(list,list3);
   DisposeMem(list3);
  }
}

/* ---- Hook-Entry-Prozedur */
#asm
H_SUBENTRY:   EQU 12

   public _HookEntry
_HookEntry:
   movem.l d0-d7/a0-a6,-(sp)
   move.l a1,-(sp)
   move.l a2,-(sp)
   move.l a0,-(sp)

   move.l H_SUBENTRY(a0),a0
   jsr (a0)

   lea 12(sp),sp
   movem.l (sp)+,d0-d7/a0-a6
   rts
#endasm

/* ---- Hook initialisieren */
void InitHook(hook,proc,data)
 struct Hook *hook;
 ULONG        (*proc)();
 ULONG       *data;
{
 hook->h_MinNode.mln_Succ=NULL;
 hook->h_MinNode.mln_Pred=NULL;
 hook->h_Entry=HookEntry;
 hook->h_SubEntry=proc;
 hook->h_Data=data;
}

/* ---- ID-Nummer ermitteln */
ULONG GetTextID(id)
 UBYTE *id;
{
 UBYTE         num[200];
 REGISTER BOOL hasNum;
 register int  i;

 if(id==NULL) return(NULL);

 hasNum=FALSE;
 i=0;
 while(id[i]!=0x00)
  {
   if(id[i]!=':')
     num[i]=id[i];
   else
    {
     num[i]=0x00;
     hasNum=TRUE;
     break;
    }
   i++;
  }

 if(!hasNum)
   return(0);

 return(atol(num));
}

/* ---- Device als Library öffnen */
struct Library *OpenDevLibrary(name,version)
 UBYTE *name;
 LONG   version;
{
 struct Library *lib;

 Forbid();
 lib=FindName(&SysBase->DeviceList,name);
 if(lib)
  {
   if(lib->lib_Version<version)
     lib=NULL;
   else
     lib->lib_OpenCnt++;
  }
 Permit();
 return(lib);
}

/* ---- Mit OpenDevLibrary() geöffnetes Device schließen */
void CloseDevLibrary(lib)
 struct Library *lib;
{
 Forbid();
 lib->lib_OpenCnt--;
 Permit();
}

/* ---- Sekunden in MultiTime umwandeln */
void Seconds2Time(secs,mt)
 ULONG             secs;
 struct MultiTime *mt;
{
 struct ClockData cd;

 Amiga2Date(secs,&cd);
 mt->Day=cd.mday;
 mt->Month=cd.month;
 mt->Year=cd.year;
 mt->WDay=cd.wday;
 mt->Second=cd.sec;
 mt->Minute=cd.min;
 mt->Hour=cd.hour;
 mt->SecondsSince1978=secs;
 Seconds2StarDate(secs,mt);
}

/* ---- MultiTime in Sekunden umwandeln */
ULONG Time2Seconds(mt)
 struct MultiTime *mt;
{
 struct ClockData cd;

 cd.mday=mt->Day;
 cd.month=mt->Month;
 cd.year=mt->Year;
 cd.wday=mt->WDay;
 cd.sec=mt->Second;
 cd.min=mt->Minute;
 cd.hour=mt->Hour;
 return(Date2Amiga(&cd));
}

#define SECONDS_PER_STARDATE 32400L   /* 9 Stunden */
#define STARDATE_1978        (((((12*365)+3)*24)*60*60)/SECONDS_PER_STARDATE)

/* ---- Sekunden in Sternzeit umwandeln */
void Seconds2StarDate(secs,mt)
 ULONG             secs;
 struct MultiTime *mt;
{
 ULONG a;
 FLOAT b;

 mt->StarDate[0]=(secs / SECONDS_PER_STARDATE) + STARDATE_1978;
 a=secs % SECONDS_PER_STARDATE;
 b=(FLOAT)a*(100000.0/(FLOAT)SECONDS_PER_STARDATE);
 mt->StarDate[1]=(ULONG)b/10L;
}

/* ---- Sekunden in Sternzeit umwandeln */
ULONG StarDate2Seconds(mt)
 struct MultiTime *mt;
{
 ULONG a;
 FLOAT b;

 b=(FLOAT)mt->StarDate[1]*10.0;
 a=(ULONG)(b*((FLOAT)SECONDS_PER_STARDATE/100000.0));
 return(a+(mt->StarDate[0]-STARDATE_1978)*SECONDS_PER_STARDATE);
}

/* ---- Datum und Uhrzeit ermitteln */
void GetTime(mt)
 struct MultiTime *mt;
{
 struct timeval tv;

 GetSysTime(&tv);
 Seconds2Time(tv.tv_secs,mt);
}

/* ---- Datum und Uhrzeit setzen */
void SetTime(mt)
 struct MultiTime *mt;
{
 struct MultiDesktopUser *mu;
 struct timerequest      *tr;
 struct timeval           tv;

 mu=SysBase->ThisTask->tc_UserData;
 tr=mu->TimerReq;
 AbortIO(tr);
 tr->tr_time.tv_secs=Time2Seconds(mt);
 tr->tr_time.tv_micro=0;
 tr->tr_node.io_Command=TR_SETSYSTIME;
 DoIO(tr);
}

/* ---- BattClock: Datum und Uhrzeit ermitteln */
void GetBattClockTime(mt)
 struct MultiTime *mt;
{
 if(BattClockBase)
   Seconds2Time(ReadBattClock(),mt);
}

/* ---- BattClock: Datum und Uhrzeit setzen */
void SetBattClockTime(mt)
 struct MultiTime *mt;
{
 if(BattClockBase)
   WriteBattClock(Time2Seconds(mt));
}

/* ---- Uhrzeiten addieren */
void AddTimes(source,dest)
 struct MultiTime *source,*dest;
{
 struct timeval t1,t2;

 t1.tv_secs=Time2Seconds(source);
 t1.tv_micro=0;
 t2.tv_secs=Time2Seconds(dest);
 t2.tv_micro=0;
 AddTime(&t2,&t1);
 Seconds2Time(t2.tv_secs,&dest);
}

/* ---- Uhrzeiten subtrahieren */
void SubTimes(source,dest)
 struct MultiTime *source,*dest;
{
 struct timeval t1,t2;

 t1.tv_secs=Time2Seconds(source);
 t1.tv_micro=0;
 t2.tv_secs=Time2Seconds(dest);
 t2.tv_micro=0;
 SubTime(&t2,&t1);
 Seconds2Time(t2.tv_secs,&dest);
}

/* ---- Uhrzeiten subtrahieren */
int CompareTimes(mt1,mt2)
 struct MultiTime *mt1,*mt2;
{
 struct timeval t1,t2;

 t1.tv_secs=Time2Seconds(mt1);
 t1.tv_micro=0;
 t2.tv_secs=Time2Seconds(mt2);
 t2.tv_micro=0;
 return(CmpTime(&t2,&t1));
}

/* ---- Warten */
void WaitTime(ticks)
 ULONG ticks;
{
 struct timerequest      *tr;
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 tr=mu->TimerReq;
 AbortIO(tr);
 tr->tr_time.tv_secs=ticks / 50;
 tr->tr_time.tv_micro=(ticks % 50)*20000;
 tr->tr_node.io_Command=TR_ADDREQUEST;
 DoIO(tr);
}

/* ---- Alarm setzen */
void SetAlarm(ticks)
 ULONG ticks;
{
 struct timerequest      *tr;
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 tr=mu->TimerReq;
 AbortIO(tr);
 tr->tr_time.tv_secs=ticks / 50;
 tr->tr_time.tv_micro=(ticks % 50)*20000;
 tr->tr_node.io_Command=TR_ADDREQUEST;
 SendIO(tr);
}

/* ---- Alarm testen */
BOOL CheckAlarm()
{
 struct timerequest      *tr;
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 tr=CheckIO(mu->TimerReq);
 if(tr!=NULL) return(TRUE);
 return(FALSE);
}

/* ---- Alarm abwarten */
void WaitAlarm()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 WaitIO(mu->TimerReq);
}

/* ---- Alarm testen */
void AbortAlarm()
{
 struct MultiDesktopUser *mu;

 mu=SysBase->ThisTask->tc_UserData;
 AbortIO(mu->TimerReq);
}

/* ---- MultiTime-Struktur initialisieren */
void InitTime(mt,day,month,year,h,m,s)
 struct MultiTime *mt;
 UBYTE             day,month;
 UWORD             year;
 UBYTE             h,m,s;
{
 ULONG sec;

 mt->Day=day;
 mt->Month=month;
 mt->Year=year;
 mt->Hour=h;
 mt->Minute=m;
 mt->Second=s;
 sec=Time2Seconds(mt);
 sec=sec/(60*60*24);
 mt->WDay=(sec % 7);
}

/* ---- Speicher ermitteln */
ULONG AvailChipMem()
{
 return(AvailMem(MEMF_CHIP|MEMF_PUBLIC));
}

/* ---- Speicher ermitteln */
ULONG AvailFastMem()
{
 return(AvailMem(MEMF_FAST|MEMF_PUBLIC));
}

/* ---- Speicher ermitteln */
ULONG AvailVMem()
{
 return(AvailMem(MEMF_ANY)-AvailMem(MEMF_PUBLIC));
}

/* ---- Speicher ermitteln */
ULONG AvailPublicMem()
{
 return(AvailMem(MEMF_PUBLIC));
}

/* ---- Speicher ermitteln */
ULONG AvailMemory()
{
 return(AvailMem(MEMF_TOTAL));
}

