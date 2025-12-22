#include <exec/resident.h>
#include <exec/execbase.h>
#include <exec/memory.h>
#include <amigem/utils.h>
#include "expansion.h"
#include <stdlib.h>
#include <unistd.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExpansionBase *ExpansionBase

#define malloc			    (*(char *(*)(size_t))ft[30])
#define write	       (*(ssize_t (*)(int,void *,size_t))ft[63])
#define exit				(*(void (*)(int))ft[35])
#define CacheClearU		       (*(void (*)(void))ft[10])

long Expansion_Start(void) /* Error return if started as a program */
{ return -1; }

/* Some globals */
FC3(0,LONG,Expansion_Init,A1,APTR dummy1,D0,BPTR dummy2,A0,void (**ft)(),A6)
;
extern const long Expansion_End;
extern void (*const expansion_funcTable[])(); 

const char Expansion_Name[]=LIB_NAME;
const char Expansion_VStr[]=LIB_VERSTRING(LIB_NAME,LIB_VERSION,LIB_REVISION,LIB_DATE);

const struct Resident Expansion_RomTag=
{
  RTC_MATCHWORD,
  (struct Resident *)&Expansion_RomTag,
  (APTR)&Expansion_End,
  0,
  LIB_VERSION,
  NT_LIBRARY,
  110,
  (char *)Expansion_Name,
  LIB_ID(Expansion_VStr),
  (APTR)&__Expansion_Init
};

FC3(0,LONG,Expansion_Init,A1,APTR dummy1,D0,BPTR dummy2,A0,void (**ft)(),A6)
{
  struct ExpansionBase *ExpansionBase;
  UBYTE *mem,*fmem;
  mem=(UBYTE *)malloc(LOCAL_MEM_SIZE+sizeof(struct MemChunk)-1);
  if(mem==NULL)
  {
    write(STDERR_FILENO,"Memory exhausted\n",17);
    exit(20);
  }
  fmem=mem=(UBYTE *)ALIGN(mem,sizeof(struct MemChunk));

  { /* Build library */
    APTR *f;
    UBYTE *t;
    ULONG s=0;

    f=(APTR)expansion_funcTable;
    while((long)*f++!=-1)
      s+=LIB_VECTSIZE;

    s=(ULONG)ALIGN(s,sizeof(ULONG));
    ExpansionBase=(struct ExpansionBase *)(fmem+=s);
    fmem+=sizeof(struct ExpansionBase);
    fmem=(UBYTE *)ALIGN(fmem,sizeof(struct MemChunk));

    f=(APTR)expansion_funcTable;
    t=(char *)ExpansionBase;
    while((long)*f!=-1)
    {
      t-=LIB_VECTSIZE;
      MINSETFUNCTION(t,*f);
      f++;
    }
    CacheClearU();

    ExpansionBase->LibNode.lib_Node.ln_Type	=NT_LIBRARY;
    ExpansionBase->LibNode.lib_Node.ln_Pri	=0;
    ExpansionBase->LibNode.lib_Node.ln_Name	=(char *)Expansion_Name;
    ExpansionBase->LibNode.lib_Flags		=LIBF_CHANGED|LIBF_SUMUSED;
    ExpansionBase->LibNode.lib_NegSize		=s;
    ExpansionBase->LibNode.lib_PosSize		=sizeof(struct ExpansionBase);
    ExpansionBase->LibNode.lib_Version		=LIB_VERSION;
    ExpansionBase->LibNode.lib_Revision		=LIB_REVISION;
    ExpansionBase->LibNode.lib_IdString		=LIB_ID(Expansion_VStr);
    ExpansionBase->LibNode.lib_OpenCnt		=1; /* Count exec as one opener */
    ExpansionBase->LocalMemStart		=(ULONG)mem;
    ExpansionBase->LocalMemSize			=LOCAL_MEM_SIZE;
    NEWLIST(&ExpansionBase->ConfigDevList);
    NEWLIST(&ExpansionBase->MountList);
    /*
     * exec.library puts it's own address into ExpansionBase->SysBase and initializes
     * the ExpansionBase->ConfigBinding signal semaphore. The first field cannot be
     * initialized by expansion.library itself (because exec does not yet exist)
     * the second prevents doubling the InitSemaphore function (and thus possible bugs).
     */
  }

  { /* Add the jumptable for the unix kernel functions as some hardware */
    struct ConfigDev *c;
    c=(struct ConfigDev *)fmem;
    c->cd_Flags			=0;
    c->cd_Rom.er_Type		=1;
    c->cd_Rom.er_Product	=88;
    c->cd_Rom.er_Manufacturer	=2011;
    c->cd_Rom.er_SerialNumber	=42424242;
    c->cd_BoardAddr		=ft;
    c->cd_BoardSize		=1;
    c->cd_Driver		=NULL;
    c->cd_NextCD		=NULL;
    ADDTAIL(&ExpansionBase->ConfigDevList,&c->cd_Node);
  }
  {/* Looking for exec */
    UWORD *w=(UWORD *)Expansion_RomTag.rt_EndSkip; /* Top of scanning area */

    while(((struct Resident *)w)->rt_MatchWord!=RTC_MATCHWORD||
          ((struct Resident *)w)!=((struct Resident *)w)->rt_MatchTag)
      w++;
    /* Even if it doesn't look like: This initializes exec!!! */
    Expansion_Init(((struct Resident *)w)->rt_Init,NULL,0,(void (**)())ExpansionBase);
  }

  return 1; /* Never reached */
}

FD1(1,struct Library *,Expansion_Open,ULONG version,D0)
{
  ExpansionBase->LibNode.lib_OpenCnt++;
  return &ExpansionBase->LibNode;
}

FD0(2,BPTR,Expansion_Close)
{
  ExpansionBase->LibNode.lib_OpenCnt--;
  return 0;
}

FD0(3,BPTR,Expansion_Expunge)
{
  return 0; /* Do not expunge expansion.library */
}

FD0(4,ULONG,Expansion_Null)
{ return 0; }
