#include <exec/execbase.h>
#include <exec/interrupts.h>
#include <exec/tasks.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <clib/_exec.h>
#include <amigem/machine.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

#define RaiseInt	Private_4

FD2(27,struct Interrupt *,SetIntVector,ULONG intNumber,D0,struct Interrupt *interrupt,A1)
{
  APTR data=NULL;
  void (*code)()=NULL;
  struct Interrupt *ret;

  if(interrupt!=NULL)
  { data=interrupt->is_Data;
    code=interrupt->is_Code; }

  Disable();
    ret=(struct Interrupt *)SysBase->IntVects[intNumber].iv_Node;
    SysBase->IntVects[intNumber].iv_Data=data;
    SysBase->IntVects[intNumber].iv_Code=code;
    SysBase->IntVects[intNumber].iv_Node=&interrupt->is_Node;
  Enable();
  return ret;
}

FC2F(0,bi,LONG,IntServer,A5,APTR is_data,A1,struct ExecBase *SysBase,A6)
;

FC2F(0,b,void,IntHandler,A5,APTR is_data,A1,struct ExecBase *SysBase,A6)
{
  struct Interrupt *i=is_data;
  while(i!=NULL)
  {
    if(IntServer(i->is_Code,i->is_Data,SysBase))
      break;
    i=(struct Interrupt *)i->is_Node.ln_Succ;
  }
}

FC2F(0,b,void,SoftIntHandler,A5,APTR is_data,A1,struct ExecBase *SysBase,A6)
{
  int k;
  struct Interrupt *i;
  for(k=0;k<5;k++)
    while((i=(struct Interrupt *)RemHead(&SysBase->SoftInts[k].sh_List))!=NULL)
    { i->is_Node.ln_Type=NT_INTERRUPT;
      IntServer(i->is_Code,i->is_Data,SysBase); }
}

FD2(28,void,AddIntServer,long intNum,D0,struct Interrupt *inter,A1)
{
  Disable();
  {
    struct Interrupt *p1,*p2;
    p1=(struct Interrupt *)&SysBase->IntVects[intNum].iv_Node;
    p2=(struct Interrupt *)p1->is_Node.ln_Succ;
    while(p2!=NULL)
    {
      if(p2->is_Node.ln_Pri<inter->is_Node.ln_Pri)
        break;
      p1=p2;
      p2=(struct Interrupt *)p1->is_Node.ln_Succ;
    }
    inter->is_Node.ln_Succ=&p2->is_Node;
    inter->is_Node.ln_Pred=&p1->is_Node;
    p1->is_Node.ln_Succ=&inter->is_Node;
    if(p2!=NULL)
      p2->is_Node.ln_Pred=&inter->is_Node;
    SysBase->IntVects[intNum].iv_Data=SysBase->IntVects[intNum].iv_Node;
    SysBase->IntVects[intNum].iv_Code=&__IntHandler;
  }
  Enable();
}

FD2(29,void,RemIntServer,ULONG intNum,D0,struct Interrupt *interrupt,A1)
{
  Disable();
    interrupt->is_Node.ln_Pred->ln_Succ=interrupt->is_Node.ln_Succ;
    if(interrupt->is_Node.ln_Succ!=NULL)
      interrupt->is_Node.ln_Succ->ln_Pred=interrupt->is_Node.ln_Pred;
    if(SysBase->IntVects[intNum].iv_Node==NULL)
      SysBase->IntVects[intNum].iv_Code=NULL;
  Enable();
}

FD1(30,void,Cause,struct Interrupt *interrupt,A1)
{
  Disable();
  if(interrupt->is_Node.ln_Type!=NT_SOFTINT)
  {
    interrupt->is_Node.ln_Type=NT_SOFTINT;
    AddTail(&SysBase->SoftInts[interrupt->is_Node.ln_Pri/16+2].sh_List,
            &interrupt->is_Node);
  }
  Enable();
  RaiseInt(INTB_SOFTINT);
}

/* Dummy */
FD1(131,ULONG,ObtainQuickVector,APTR interruptCode,A0)
{ return 0; }
