#include <exec/alerts.h>
#include <exec/resident.h>
#include <clib/_expansion.h>
#include <clib/_exec.h>
#include <amigem/utils.h>
#include "exec.h"

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

extern const struct Resident Exec_RomTag;
extern const char Exec_Name[];
extern const char Exec_VStr[];
extern void (*const exec_funcTable[])();

void __SoftIntHandler(void);
void __Dispatcher(void);
void InitKernel(struct ExecBase *SysBase);

FC2(0,void,Exec_Bootup,A0,struct ExecBase *SysBase,A6,APTR sp,A7)
;

FC3(0,LONG,Exec_Init,A1,struct ExecBase *SysBase,D0,BPTR segList,A0,struct ExpansionBase *ExpansionBase,A6)
{
  { /* Build library */
    APTR *f;
    UBYTE *t;
    ULONG s=0;
    UBYTE *freemem;
    struct ConfigDev *cd;

    freemem=(UBYTE *)ExpansionBase->ConfigDevList.lh_TailPred+sizeof(struct ConfigDev);
    freemem=(UBYTE *)ALIGN(freemem,sizeof(struct MemChunk));

    f=(APTR *)exec_funcTable;
    while((LONG)*f++!=-1)
      s+=LIB_VECTSIZE;

    s=(ULONG)ALIGN(s,sizeof(LONG));
    SysBase=(struct ExecBase *)(freemem+=s);
    freemem+=sizeof(struct ExecBase);
    freemem=(UBYTE *)ALIGN(freemem,sizeof(struct MemChunk));

    f=(APTR *)exec_funcTable;
    t=(UBYTE *)SysBase;
    while((long)*f!=-1)
    {
      t-=LIB_VECTSIZE;
      MINSETFUNCTION(t,*f);
      f++;
    }
    /* Copy addresses of Un*x functions (and some more) */
    cd=(struct ConfigDev *)ExpansionBase->ConfigDevList.lh_Head;
    while(cd->cd_Rom.er_Manufacturer!=2011||cd->cd_Rom.er_Product!=88||
          cd->cd_Rom.er_SerialNumber!=42424242)
      cd=(struct ConfigDev *)cd->cd_Node.ln_Succ;/* There's nothing I can do if this fails */
    f=(APTR *)cd->cd_BoardAddr;
    SysBase->functable[ 0]=f[10]; /* CacheClearU */
    SysBase->functable[ 1]=f[11]; /* CacheClearE */
    SysBase->functable[ 2]=f[12]; /* CachePreDMA */
    SysBase->functable[ 3]=f[13]; /* CachePostDMA */
    SysBase->functable[ 4]=f[36]; /* setjmp */
    SysBase->functable[ 5]=f[37]; /* longjmp */
    SysBase->functable[ 6]=f[40]; /* kill */
    SysBase->functable[ 7]=f[41]; /* getpid */
    SysBase->functable[ 8]=f[50]; /* sigprocmask */
    SysBase->functable[ 9]=f[51]; /* sigsuspend */
    SysBase->functable[10]=f[52]; /* sigaction */
    SysBase->functable[11]=f[80]; /* setitimer */
    SysBase->functable[12]=f[63]; /* write */
    SysBase->functable[13]=f[35]; /* exit */
    (*(void (*)(void))SysBase->functable[0])(); /* CacheClearU */

    SysBase->LibNode.lib_Node.ln_Type	=NT_LIBRARY;
    SysBase->LibNode.lib_Node.ln_Name	=(char *)Exec_Name;
    SysBase->LibNode.lib_Flags		=LIBF_CHANGED|LIBF_SUMUSED;
    SysBase->LibNode.lib_NegSize	=s;
    SysBase->LibNode.lib_PosSize	=sizeof(struct ExecBase);
    SysBase->LibNode.lib_Version	=LIB_VERSION;
    SysBase->LibNode.lib_Revision	=LIB_REVISION;
    SysBase->LibNode.lib_IdString	=(char *)LIB_ID(Exec_VStr);
    SysBase->LibNode.lib_OpenCnt	=0;

    SysBase->SysFlags=0;
    SysBase->AttnResched=0;
    SysBase->IDNestCnt=0;
    SysBase->TDNestCnt=0;
    NEWLIST(&SysBase->MemList);
    NEWLIST(&SysBase->ResourceList);
    NEWLIST(&SysBase->DeviceList);
    NEWLIST(&SysBase->IntrList);
    NEWLIST(&SysBase->LibList);
    NEWLIST(&SysBase->PortList);
    NEWLIST(&SysBase->TaskReady);
    NEWLIST(&SysBase->TaskWait);
    NEWLIST(&SysBase->SemaphoreList);
    /*
     * Add all memory. Don't allocabs memory in use - the first 8 bytes of
     * everything you AllocAbs() may be overwritten by a struct MemChunk.
     * Just don't add this memory to the free memory pool.
     */
    AddMemList((UBYTE *)ExpansionBase->LocalMemStart+ExpansionBase->LocalMemSize-freemem,
               MEMF_PUBLIC|MEMF_CHIP|MEMF_FAST|MEMF_LOCAL|MEMF_24BITDMA|MEMF_KICK,
               -1,freemem,NULL);
  }

  /* Tell expansion.library about us */
  ExpansionBase->SysBase=SysBase;
  InitSemaphore(&ExpansionBase->ConfigBinding);
  /* May open expansion.library here - but what for? */

  AddLibrary(&ExpansionBase->LibNode);
  AddLibrary(&SysBase->LibNode);

  { /* Clear all interrupt vectors */
    int i;
    for(i=0;i<16;i++)
    {
      SysBase->IntVects[i].iv_Data=NULL;
      SysBase->IntVects[i].iv_Code=NULL;
      SysBase->IntVects[i].iv_Node=NULL;
    }
  }

  { /* Clear the softint lists */
    int i;
    for(i=0;i<5;i++)
      NEWLIST(&SysBase->SoftInts[i].sh_List);
  }

  { /* Set supervisor stackpointer */
    APTR s;
    s=AllocMem(MINSTACKSIZE,MEMF_PUBLIC|MEMF_CLEAR);
    if(s==NULL)
      Alert(AT_DeadEnd|AO_ExecLib|AG_NoMemory);
    SysBase->SysStkLower=s;
    SysBase->SysStkUpper=(UBYTE *)s+MINSTACKSIZE;
  }

  InitKernel(SysBase);

  { /* Add myself as the first task to the task lists */
    struct Task *t;
    APTR s;
    struct MemList *ml;
    ml=(struct MemList *)AllocMem(sizeof(struct MemList),MEMF_PUBLIC);
    if(ml==NULL)
      Alert(AT_DeadEnd|AO_ExecLib|AG_NoMemory);
    t=(struct Task *)AllocMem(sizeof(struct Task),MEMF_PUBLIC|MEMF_CLEAR);
    if(t==NULL)
      Alert(AT_DeadEnd|AO_ExecLib|AG_NoMemory);
    s=AllocMem(MINSTACKSIZE,MEMF_PUBLIC);
    if(s==NULL)
      Alert(AT_DeadEnd|AO_ExecLib|AG_NoMemory);
    t->tc_Node.ln_Type=NT_TASK;
    t->tc_Node.ln_Pri=0;
    t->tc_Node.ln_Name="boot task";
    t->tc_State=TS_RUN;
    t->tc_SPLower=s; /* Oops, where am I running on now??? */
    t->tc_SPUpper=(APTR)((UBYTE *)s+MINSTACKSIZE);
    ml->ml_NumEntries=2;
    ml->ml_ME[0].me_Addr=(APTR)t;
    ml->ml_ME[0].me_Length=sizeof(struct Task);
    ml->ml_ME[1].me_Addr=s;
    ml->ml_ME[1].me_Length=MINSTACKSIZE;
    NEWLIST(&t->tc_MemEntry);
    AddHead(&t->tc_MemEntry,&ml->ml_Node);
    SysBase->ThisTask=t;
  }

  { /* Activate software interrupts */
    struct Interrupt *i;
    i=(struct Interrupt *)AllocMem(sizeof(struct Interrupt),MEMF_PUBLIC|MEMF_CLEAR);
    if(i==NULL)
      Alert(AT_DeadEnd|AN_IntrMem);
    i->is_Node.ln_Type=NT_INTERRUPT;
    i->is_Node.ln_Name="exec software interrupt handler";
    i->is_Data        =NULL;
    i->is_Code        =&__SoftIntHandler;    
    SetIntVector(INTB_SOFTINT,i);
  }

  { /* Install dispatcher */
    struct Interrupt *i1,*i2;
    i1=(struct Interrupt *)AllocMem(sizeof(struct Interrupt),MEMF_PUBLIC|MEMF_CLEAR);
    if(i1==NULL)
      Alert(AT_DeadEnd|AN_IntrMem);
    i2=(struct Interrupt *)AllocMem(sizeof(struct Interrupt),MEMF_PUBLIC|MEMF_CLEAR);
    if(i2==NULL)
      Alert(AT_DeadEnd|AN_IntrMem);
    i2->is_Node.ln_Type=i1->is_Node.ln_Type=NT_INTERRUPT;
    i2->is_Node.ln_Name=i1->is_Node.ln_Name="exec dispatcher";
    i2->is_Data        =i1->is_Data        =NULL;
    i2->is_Code        =i1->is_Code        =&__Dispatcher;
    AddIntServer(INTB_VERTB,i1);
    SysBase->SoftDispatch=i2;
    Enable();
    Permit();
  }

  /* Now initialize all other romtags */
  Exec_Bootup(&__Exec_Bootup,SysBase,
              STACKPOINTER(SysBase->ThisTask->tc_SPLower,SysBase->ThisTask->tc_SPUpper));
  /* This point is never reached */

  return 1; /* All OK */  
}

FC2(0,void,Exec_Bootup,A0,struct ExecBase *SysBase,A6,APTR sp,A7)
{
  UWORD *w=(UWORD *)&Exec_RomTag.rt_EndSkip; /* Top of scanning area */

  for(;;) /* Looking for more romtags. */
  {
    struct Resident *r=(struct Resident *)w;
    if(r->rt_MatchWord==RTC_MATCHWORD&&r==r->rt_MatchTag)
    {
      if(!InitResident(r,NULL))
        Alert(AT_DeadEnd|AO_ExecLib|AG_MakeLib);
      w=(UWORD *)r->rt_EndSkip;
    }else
      w++;
  }
}
  
FD1(1,struct Library *,Exec_Open,ULONG version,D0)
{ 
  SysBase->LibNode.lib_OpenCnt++;
  return &SysBase->LibNode;
}

FD0(2,BPTR,Exec_Close)
{ 
  SysBase->LibNode.lib_OpenCnt--;
  return 0;
}

FD0(3,BPTR,Exec_Expunge)
{
  return 0;
}

FD0(4,ULONG,Exec_Null)
{ return 0; }

