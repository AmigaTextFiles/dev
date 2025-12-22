#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <clib/_exec.h>

#define SEMAPHORESIGF (0x8000)

#define SM_TYPE_OBTAIN	0
#define SM_TYPE_PROCURE	1

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase
 
FD1(93,VOID,InitSemaphore,struct SignalSemaphore *sem,A0)
{ 
  sem->ss_WaitQueue.mlh_Head    =(struct MinNode *)&sem->ss_WaitQueue.mlh_Tail;
  sem->ss_WaitQueue.mlh_Tail    =NULL;
  sem->ss_WaitQueue.mlh_TailPred=(struct MinNode *)&sem->ss_WaitQueue.mlh_Head;
  sem->ss_NestCount=0;
}

FD1(94,VOID,ObtainSemaphore,struct SignalSemaphore *sem,A0)
{
  struct Task *me;
  me=FindTask(NULL);
  Forbid();
    if(sem->ss_NestCount&&sem->ss_Owner!=me)
    {
      struct Message sm;
      sm.mn_ReplyPort=(struct MsgPort *)me;
      sm.mn_Node.ln_Type=SM_TYPE_OBTAIN;
      sm.mn_Node.ln_Name=(char *)SM_EXCLUSIVE;
      AddTail((struct List *)&sem->ss_WaitQueue,&sm.mn_Node);
      Wait(SEMAPHORESIGF);
    }
    else
      sem->ss_NestCount++;
  Permit();
} 

FD1(96,ULONG,AttemptSemaphore,struct SignalSemaphore *sem,A0)
{
  LONG ret=0;
  struct Task *me;
  me=FindTask(NULL);
  Forbid();
    if(!sem->ss_NestCount||sem->ss_Owner==me)
    {
      ObtainSemaphore(sem);
      ret=1;
    }
  Permit();
  return ret;
} 
    
FD1(113,VOID,ObtainSemaphoreShared,struct SignalSemaphore *sem,A0)
{
  struct Task *me;
  me=FindTask(NULL);
  Forbid();
    if(sem->ss_NestCount>0)
    {
      if(sem->ss_Owner!=me)
      { 
        struct Message sm;
        sm.mn_ReplyPort=(struct MsgPort *)me;
        sm.mn_Node.ln_Type=SM_TYPE_OBTAIN;
        sm.mn_Node.ln_Name=(char *)SM_SHARED;
        AddTail((struct List *)&sem->ss_WaitQueue,&sm.mn_Node);
        Wait(SEMAPHORESIGF);
      }
      else
        sem->ss_NestCount++;
    }
    else
      sem->ss_NestCount--;
  Permit();
} 

FD1(120,ULONG,AttemptSemaphoreShared,struct SignalSemaphore *sem,A0)
{
  LONG ret=0;
  struct Task *me;
  me=FindTask(NULL);
  Forbid();
    if(sem->ss_NestCount<=0||sem->ss_Owner==me)
    {
      ObtainSemaphoreShared(sem);
      ret=1;
    }
  Permit();
  return ret;
} 

FD1(95,VOID,ReleaseSemaphore,struct SignalSemaphore *sem,A0)
{ 
  Forbid();
    if(sem->ss_NestCount>0) /* I hold an exclusive lock */
      sem->ss_NestCount--;
    else                    /* A shared lock */
      sem->ss_NestCount++;
    if(!sem->ss_NestCount&&sem->ss_WaitQueue.mlh_Head->mln_Succ!=NULL)
    { 
      struct SemaphoreMessage *sm;
      sm=(struct SemaphoreMessage *)sem->ss_WaitQueue.mlh_Head;
      if(sm->ssm_Message.mn_Node.ln_Name!=(char *)SM_EXCLUSIVE)
      { 
        struct MinNode *mn;
        mn=(struct MinNode *)sm;
        while(mn->mln_Succ!=NULL)
        { 
          sm=(struct SemaphoreMessage *)mn;
          mn=mn->mln_Succ;
          if(sm->ssm_Message.mn_Node.ln_Type!=SM_EXCLUSIVE)
          { 
            Remove((struct Node *)sm);
            if(sm->ssm_Message.mn_Node.ln_Type==SM_TYPE_OBTAIN)
              Signal((struct Task *)sm->ssm_Message.mn_ReplyPort,SEMAPHORESIGF);
            else
              ReplyMsg(&sm->ssm_Message);
            sem->ss_NestCount--;
          }
          sem->ss_Owner=NULL;
        }
      }
      else
      { 
        Remove((struct Node *)sm);
        if(sm->ssm_Message.mn_Node.ln_Type==SM_TYPE_OBTAIN)
        {
          sem->ss_Owner=(struct Task *)sm->ssm_Message.mn_ReplyPort;
          Signal((struct Task *)sm->ssm_Message.mn_ReplyPort,SEMAPHORESIGF);
        }
        else
        {
          sem->ss_Owner=(struct Task *)&sm->ssm_Message.mn_ReplyPort->mp_SigTask;
          ReplyMsg(&sm->ssm_Message);
        }
        sem->ss_NestCount++;
      }
    }
  Permit();
}

FD2(90,VOID,Procure,struct SignalSemaphore *sem,A0,struct SemaphoreMessage *sm,A1)
{
  sm->ssm_Message.mn_Length=sizeof(struct SemaphoreMessage);
  Forbid();
    if((ULONG)sm->ssm_Message.mn_Node.ln_Name==SM_SHARED?
       AttemptSemaphoreShared(sem):AttemptSemaphore(sem))
    {
      sm->ssm_Semaphore=sem;
      ReplyMsg(&sm->ssm_Message);
    }
    else
      AddTail((struct List *)&sem->ss_WaitQueue,&sm->ssm_Message.mn_Node);
  Permit();
}

FD2(91,VOID,Vacate,struct SignalSemaphore *sem,A0,struct SemaphoreMessage *sm,A1)
{
  struct MinNode *mn;
  Forbid();
    mn=(struct MinNode *)sem->ss_WaitQueue.mlh_Head;
    while(mn->mln_Succ!=NULL)
    { 
      if(sm==(struct SemaphoreMessage *)mn)
      {
        Remove((struct Node *)mn);
        ReplyMsg(&sm->ssm_Message);
        break;
      }
      mn=mn->mln_Succ;
    }
    if(mn->mln_Succ==NULL)
      ReleaseSemaphore(sem);
  Permit();
  sm->ssm_Semaphore=NULL;
}

/*
 * It would be nice if we could use the ss_MultipleLink to arbitrate
 * for all semaphores at once but the message semaphore mechanism
 * won't let us do it :(
 *
 * There's no problem with it though since other tasks will have to
 * arbitrate for the list in the same order we do. So the first
 * semaphore in the list arbitrates for the whole list.
 */
FD1(97,VOID,ObtainSemaphoreList,struct List *sl,A0)
{
  struct Node *n;
  n=sl->lh_Head;
  while(n->ln_Succ!=NULL)
  {
    ObtainSemaphore((struct SignalSemaphore *)n);
    n=n->ln_Succ;
  }
}

FD1(98,VOID,ReleaseSemaphoreList,struct List *sl,A0)
{
  struct Node *n;
  n=sl->lh_Head;
  while(n->ln_Succ!=NULL)
  {
    ReleaseSemaphore((struct SignalSemaphore *)n);
    n=n->ln_Succ;
  }
}

FD1(100,VOID,AddSemaphore,struct SignalSemaphore *sem,A1)
{
  sem->ss_Link.ln_Type=NT_SIGNALSEM;
  InitSemaphore(sem);
  Forbid();
    Enqueue(&SysBase->SemaphoreList,&sem->ss_Link);
  Permit();
}

FD1(101,VOID,RemSemaphore,struct SignalSemaphore *sem,A1)
{
  Forbid();
    Remove(&sem->ss_Link);
  Permit();
}

FD1(99,struct SignalSemaphore *,FindSemaphore,STRPTR name,A1)
{ 
  return (struct SignalSemaphore *)FindName(&SysBase->SemaphoreList,name);
}
