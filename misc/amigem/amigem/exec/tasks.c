#include <exec/tasks.h>
#include <exec/memory.h>
#include <stdio.h>
#include <amigem/utils.h>
#include <clib/_exec.h>
#include "exec.h"

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

#define FallAsleep 	Private_1
#define SwitchContext	Private_2
#define AddContext	Private_3
#define DISPATCH()	Cause(SysBase->SoftDispatch)

#define DISPATCH_PENDING 1

FD0F(22,p,void,Forbid)
{
  SysBase->TDNestCnt++;
}

FD0F(23,p,void,Permit)
{
  if(!SysBase->TDNestCnt--&&SysBase->SysFlags&DISPATCH_PENDING)
    DISPATCH();
}

FC1F(0,d,void,UserTask,A0,struct ExecBase *SysBase,A6)
;

FC2F(0,b,void,NewTask,A5,APTR is_data,A1,struct ExecBase *SysBase,A6)
{
  APTR *buf=(APTR *)is_data;
  Enable(); /* Called in disabled state */
  UserTask(buf[0],SysBase);
  if(buf[1]!=NULL)
    UserTask(buf[1],SysBase);
  else
    RemTask(0);
}

FD3(47,APTR,AddTask,struct Task *task,A1,APTR initialPC,A2,APTR finalPC,A3)
{
  APTR *buf;
  if(!task->tc_Node.ln_Type)
    task->tc_Node.ln_Type=NT_TASK;
  if(!task->tc_Node.ln_Name)
    task->tc_Node.ln_Name="unknown task";
  task->tc_State=TS_READY;
  if(!task->tc_SigAlloc)
    task->tc_SigAlloc=0xffff;
  /* exceptions & traps */
  if(!task->tc_SPReg)
    task->tc_SPReg=STACKPOINTER(task->tc_SPLower,task->tc_SPUpper);
  /* switch & launch */
  buf=(APTR *)ALLOCONSTACK(&task->tc_SPReg,2*sizeof(APTR));
  buf[0]=initialPC;
  buf[1]=finalPC;
  task->tc_SPReg=AddContext(task->tc_SPReg,&__NewTask,buf);
  task->tc_State=TS_READY;
  Disable();
    Enqueue(&SysBase->TaskReady,&task->tc_Node);
    DISPATCH();
  Enable();
  return task;
}

FD1(48,void,RemTask,struct Task *task,A1)
{
  Forbid(); /* The following may free the task structure */
  {
    struct MemList *mb; /* Free all memory */
    struct Task *t=(task==NULL?SysBase->ThisTask:task);
    while((mb=(struct MemList *)RemHead(&t->tc_MemEntry))!=NULL)
    {
      FreeEntry(mb);
      FreeMem(mb,sizeof(struct MemList)-sizeof(struct MemEntry)+
                 mb->ml_NumEntries*sizeof(struct MemEntry));
    }
    Disable();
      if(!task) /* cannot remove myself - let the dispatcher do it */
      {
        t->tc_State=TS_REMOVED;
        DISPATCH();
        SysBase->TDNestCnt=-1;
        SysBase->IDNestCnt=0;
        Enable();
        for(;;) /* Dispatcher could not remove this task */
          FallAsleep();
      }
      else
        Remove(&task->tc_Node);
    Enable();
  }
  Permit();
}

FD2(50,BYTE,SetTaskPri,struct Task *task,A1,long pri,D0)
{
  BYTE old;
  Disable();
    old=task->tc_Node.ln_Pri;
    task->tc_Node.ln_Pri=pri;
    if(task->tc_State!=TS_WAIT)
    {
      if(task!=SysBase->ThisTask)
      { Remove(&task->tc_Node);
        Enqueue(&SysBase->TaskReady,&task->tc_Node); }
      DISPATCH();
    }
  Enable();
  return old;
}

FD1(49,struct Task *,FindTask,STRPTR name,A1)
{ 
  struct Task *ret;
  if(name==NULL)
    ret=SysBase->ThisTask;
  else
  {
    Disable();
      if((ret=(struct Task *)FindName(&SysBase->TaskReady,name))==NULL)
        if((ret=(struct Task *)FindName(&SysBase->TaskWait,name))==NULL)
        {
          char *s1=SysBase->ThisTask->tc_Node.ln_Name;
          char *s2=name;
          while(*s1++==*s2)
            if(!*s2++)
            { 
              ret=SysBase->ThisTask;
              break;
            }
        }
    Enable();
  }
  return ret;
}

FC3(0,ULONG,UserException,A0,ULONG signals,D0,APTR exceptData,A1,struct ExecBase *SysBase,A6)
;

FC2F(0,b,void,ExceptionMode,A5,ULONG sigs,A1,struct ExecBase *SysBase,A6)
{
  struct Task *me=SysBase->ThisTask;
  do
  {
    APTR code,data;
    code=me->tc_ExceptCode;
    data=me->tc_ExceptData;
    Enable(); /* Function is called Disabled */
      sigs=UserException(code,sigs,data,SysBase);
    Disable();
    me->tc_SigExcept|=sigs;
    sigs=me->tc_SigExcept&me->tc_SigRecvd;
    me->tc_SigRecvd &=~sigs;
    me->tc_SigExcept&=~sigs;
  }while(sigs);
}

FC2F(0,bi,LONG,Dispatcher,A5,APTR is_data,A1,struct ExecBase *SysBase,A6)
{
  struct Task *t1,*t2;

  Disable(); /* Arbitrate for SysBase */

  SysBase->SysFlags&=~DISPATCH_PENDING;

  t1=SysBase->ThisTask;
  if(t1->tc_State==TS_EXCEPT) /* A task that wants to run in exception mode */
  {
    ULONG sigs;
    sigs=t1->tc_SigExcept&t1->tc_SigRecvd;
    t1->tc_SigRecvd &=~sigs;
    t1->tc_SigExcept&=~sigs;
    SwitchContext(AddContext(SwitchContext(NULL),&__ExceptionMode,(APTR)sigs));
    t1->tc_State=TS_RUN;
    goto end;
  }

  t2=(struct Task *)SysBase->TaskReady.lh_Head;
  if(!t2->tc_Node.ln_Succ)
    goto end; /* No ready task - no dispatching */

  if(SysBase->TDNestCnt!=-1) /* sceduling disabled */
  { SysBase->SysFlags|=DISPATCH_PENDING;
    goto end; }

  switch(t1->tc_State)
  {
    default:  /* illegal task state - treat it as TS_RUN */
    case TS_RUN: /* normal dispatching */
      if(t2->tc_Node.ln_Pri<t1->tc_Node.ln_Pri) /* priority too low */
        goto end;
      Enqueue(&SysBase->TaskReady,&t1->tc_Node);
      t1->tc_State=TS_READY;
      break;
    case TS_WAIT: /* A task that wants to go into the waiting queue */
      Enqueue(&SysBase->TaskWait,&t1->tc_Node);
      break;
    case TS_REMOVED: /* A task that wants to be removed */
      break; /* simply don't feed the waiting queue */
  }

  t1->tc_SPReg=SwitchContext(t2->tc_SPReg);
  Remove(&t2->tc_Node);
  SysBase->ThisTask=t2;
  t2->tc_State=TS_RUN;
  SysBase->DispCount++;

end:
  Enable();
  return 0;
}

/* No documentation available */
FD1(123,void,ChildFree,APTR tid,D0)
{}

FD1(124,void,ChildOrphan,APTR tid,D0)
{}

FD1(125,void,ChildStatus,APTR tid,D0)
{}

FD1(126,void,ChildWait,APTR tid,D0)
{}
