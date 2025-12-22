#include <exec/execbase.h>
#include <amigem/utils.h>
#include <exec/resident.h>
#include <clib/_exec.h>
#include <clib/_expansion.h>

#include <amigem/fd_lib.h>

#define NewList(a) \
((a)->lh_Head=(struct Node *)&(a)->lh_Tail, \
 (a)->lh_Tail=NULL, \
 (a)->lh_TailPred=(struct Node *)&(a)->lh_Head)

APTR write;

void countfunc(void)
{
  for(;;)
    (*(void (*)(int,char *,int))write)(2,"b",1);
}

FC3(0,LONG,Test_Init,A1,APTR dummy1,D0,BPTR dummy2,A0,struct ExecBase *SysBase,A6)
{
  {
    struct ExpansionBase *ExpansionBase;
    struct newtsk
    { 
      struct Task t;
      UBYTE stk[MINSTACKSIZE];
    } *nt;
    struct MemList *ml;
    ExpansionBase=(struct ExpansionBase *)OpenLibrary("expansion.library",0);
    write=((APTR *)FindConfigDev(NULL,2011,88)->cd_BoardAddr)[63];
    ml=(struct MemList *)AllocMem(sizeof(struct MemList),MEMF_PUBLIC); /* Must not fail */
    nt=(struct newtsk *)AllocMem(sizeof(struct newtsk),MEMF_PUBLIC|MEMF_CLEAR);
    ml->ml_NumEntries=1;
    ml->ml_ME[0].me_Addr=nt;
    ml->ml_ME[0].me_Length=sizeof(struct newtsk);
    nt->t.tc_SPLower=nt->stk;
    nt->t.tc_SPUpper=nt->stk+MINSTACKSIZE;
    nt->t.tc_SPReg  =STACKPOINTER(nt->stk,nt->stk+MINSTACKSIZE);
    NewList(&nt->t.tc_MemEntry);
    AddHead(&nt->t.tc_MemEntry,&ml->ml_Node);
    AddTask(&nt->t,&countfunc,NULL);
  }
  for(;;)
    (*(void (*)(int,char *,int))write)(2,"a",1);
}

const struct Resident Test_RomTag=
{
  RTC_MATCHWORD,
  (struct Resident *)&Test_RomTag,
  NULL,
  0,
  0,
  0,
  0,
  NULL,
  NULL,
  (APTR)&__Test_Init
};
