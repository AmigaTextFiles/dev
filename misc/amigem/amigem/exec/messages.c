#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <clib/_exec.h>
#include <stdio.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FD1(62,struct Message *,GetMsg,struct MsgPort *port,A0)
{
  struct Message *msg;
  Forbid();
    msg=(struct Message *)RemHead(&port->mp_MsgList);
  Permit();
  return msg;
}

FD2(61,void,PutMsg,struct MsgPort *port,A0,struct Message *msg,A1)
{
  Forbid();
    msg->mn_Node.ln_Type=NT_MESSAGE;
    AddTail(&port->mp_MsgList,&msg->mn_Node);
    switch(port->mp_Flags&PF_ACTION)
    {
      case PA_SIGNAL:
        Signal((struct Task *)port->mp_SigTask,port->mp_SigBit);
        break;
      case PA_SOFTINT:
        Cause((struct Interrupt *)port->mp_SoftInt);
        break;
      case PA_IGNORE:
        break;
    }
  Permit();
}

FD1(63,void,ReplyMsg,struct Message *msg,A1)
{
  struct MsgPort *port;
  if((port=msg->mn_ReplyPort)==NULL)
    msg->mn_Node.ln_Type=NT_FREEMSG;
  else
  {
    Forbid();
      msg->mn_Node.ln_Type=NT_REPLYMSG;
      AddTail(&port->mp_MsgList,&msg->mn_Node);
      switch(port->mp_Flags&PF_ACTION)
      {
        case PA_SIGNAL:
          Signal((struct Task *)port->mp_SigTask,port->mp_SigBit);
          break;
        case PA_SOFTINT:
          Cause((struct Interrupt *)port->mp_SoftInt);
          break;
        case PA_IGNORE:
          break;
      }
    Permit();
  }
}

FD1(64,struct Message *,WaitPort,struct MsgPort *port,A0)
{
  if(port->mp_MsgList.lh_Head->ln_Succ==NULL)
    Wait(1<<port->mp_SigBit);
  return (struct Message *)port->mp_MsgList.lh_Head;
}

FD0(111,struct MsgPort *,CreateMsgPort)
{
  struct MsgPort *mp;
  if((mp=(struct MsgPort *)AllocVec(sizeof(struct MsgPort),MEMF_PUBLIC|MEMF_CLEAR))!=NULL)
  {
    BYTE sb;
    if((sb=AllocSignal(-1))!=-1)
    {
      mp->mp_SigBit=sb;
      mp->mp_MsgList.lh_Head=(struct Node *)&mp->mp_MsgList.lh_Tail;
      /* mp->mp_MsgList.lh_Tail=NULL; */
      mp->mp_MsgList.lh_TailPred=(struct Node *)&mp->mp_MsgList.lh_Head;
      /* mp->mp_Flags=PA_SIGNAL; */
      mp->mp_SigTask=FindTask(NULL);
      return mp;
    }
    FreeVec(mp);
  }
  return NULL;
}

FD1(112,void,DeleteMsgPort,struct MsgPort *port,A0)
{
  if(port!=NULL)
  {
    FreeSignal(port->mp_SigBit);
    FreeVec(port);
  }
}

FD1(65,struct MsgPort *,FindPort,STRPTR name,A1)
{
  return (struct MsgPort *)FindName(&SysBase->PortList,name);
}

FD1(59,void,AddPort,struct MsgPort *port,A1)
{
  port->mp_Node.ln_Type=NT_MSGPORT;
  port->mp_MsgList.lh_Head=(struct Node *)&port->mp_MsgList.lh_Tail;
  port->mp_MsgList.lh_Tail=NULL;
  port->mp_MsgList.lh_TailPred=(struct Node *)&port->mp_MsgList.lh_Head;
  Forbid();
    Enqueue(&SysBase->PortList,&port->mp_Node);
  Permit();
}

FD1(60,void,RemPort,struct MsgPort *port,A1)
{
  Forbid();
    Remove(&port->mp_Node);
  Permit();
}
