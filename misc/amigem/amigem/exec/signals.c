#include <exec/tasks.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <amigem/machine.h>
#include <clib/_exec.h>
#include "exec.h"

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

#define FallAsleep	Private_1
#define AddContext	Private_3
#define DISPATCH() Cause(SysBase->SoftDispatch)

FD1(55,BYTE,AllocSignal,long signum,D0)
{
  ULONG *mask;
  mask=&SysBase->ThisTask->tc_SigAlloc;
  if(signum<0)
  {
    ULONG mask1=*mask,mask2=1;
    for(signum=0;signum<sizeof(ULONG)*BITSPERBYTE;signum++)
    {
      if(!(mask1&mask2))
      {
        *mask|=mask2;
        return signum;
      }
      mask2<<=1;
    }
    return -1;
  }
  else
  {
    if(*mask&1<<signum)
      return -1;
    *mask|=1<<signum;
    return signum;
  }
}
      
FD1(56,void,FreeSignal,long signum,D0)
{
  if(signum>=0)
    SysBase->ThisTask->tc_SigAlloc&=~(1<<signum);
}

FD2(51,ULONG,SetSignal,ULONG new,D0,ULONG mask,D1)
{
  volatile ULONG *sig;
  ULONG old;
  Disable();
    sig=&SysBase->ThisTask->tc_SigRecvd;
    old=*sig;
    *sig=(old&~mask)|(new&mask);
  Enable();
  return old;
}

FD2(52,ULONG,SetExcept,ULONG newSignals,D0,ULONG signalMask,D1)
{
  struct Task *me;
  ULONG old;
  me=SysBase->ThisTask;
  Disable();
    old=me->tc_SigExcept;
    me->tc_SigExcept=(old&~signalMask)|(newSignals&signalMask);
    if(me->tc_SigExcept&me->tc_SigRecvd)
    { me->tc_State=TS_EXCEPT;
      DISPATCH(); }
  Enable();
  return old;
}

void __ExceptionMode();

FD2(54,void,Signal,struct Task *task,A1,ULONG sigs,D0)
{
  Disable();
    task->tc_SigRecvd|=sigs;
    if(task->tc_SigExcept&task->tc_SigRecvd)
    {
      if(task==SysBase->ThisTask)
      { SysBase->ThisTask->tc_State=TS_EXCEPT;
        DISPATCH(); }
      else
      {
        sigs=task->tc_SigExcept&task->tc_SigRecvd;
        task->tc_SigRecvd &=~sigs;
        task->tc_SigExcept&=~sigs;
        task->tc_SPReg=AddContext(task->tc_SPReg,&__ExceptionMode,(APTR)sigs);
        task->tc_State=TS_READY; /* two to Tolouse */
        Remove(&task->tc_Node);
        Enqueue(&SysBase->TaskReady,&task->tc_Node);
        DISPATCH();
      }
    }else if(task!=SysBase->ThisTask&&task->tc_SigRecvd&task->tc_SigWait)
    {
      task->tc_State=TS_READY;
      Remove(&task->tc_Node);
      Enqueue(&SysBase->TaskReady,&task->tc_Node);
      DISPATCH();
    }
  Enable();
}

FD1(53,ULONG,Wait,ULONG sigs,D0)
{
  ULONG rcvd;
  struct Task *me;
  me=SysBase->ThisTask;
  Disable();
    while(!(me->tc_SigRecvd&sigs))
    {
      me->tc_SigWait=sigs;
      me->tc_TDNestCnt=SysBase->TDNestCnt;
      SysBase->TDNestCnt=-1;
      me->tc_IDNestCnt=SysBase->IDNestCnt;
      SysBase->IDNestCnt=0;
      me->tc_State=TS_WAIT;
      Enable();
        DISPATCH();
      Disable();
      while(me->tc_State==TS_WAIT)
      { /* Dispatcher could not put me asleep (no ready tasks :-) ) */
        Enable();
          FallAsleep();
        Disable();
      }
      SysBase->IDNestCnt=me->tc_IDNestCnt;
      SysBase->TDNestCnt=me->tc_TDNestCnt;
    }
    rcvd=me->tc_SigRecvd;
    me->tc_SigRecvd&=~sigs;
  Enable();
  return rcvd;
}
