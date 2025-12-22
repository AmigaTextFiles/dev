#include <extras/threads.h>
#include <clib/extras/thread_protos.h>

#include <dos.h>
#include <strings.h>

//#define DEBUG
#include <debug.h>

#include <clib/alib_protos.h>

#include <dos/dos.h>
#include <dos/dostags.h>
#include <exec/memory.h>

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/utility.h>

ULONG my_AToI(STRPTR Str);

/* internal use */
struct InitThread
{
  struct Task *it_CreaterTask;
  BYTE it_Signal;
  BYTE it_RetVal;
  struct Library *it_ModuleBase;
  struct Thread *it_Thread;
  void __asm (*it_MsgHandler)(register __a0 struct Thread *T,
                              register __a1 struct ThreadMessage *Msg);
};

void SingleMsgPort(struct MsgPort *MP);
void __asm __saveds ThreadEntry(register __a0 STRPTR Args);
void __asm __saveds ThreadSubEntry(register __a0 struct InitThread *it,
                                   register __a6 APTR LibBase);

struct ThreadMessage *InThreadGetMsg(struct Thread *T);          // Used by message to get messages for thread

/****** extras.lib/thread_StartThread ******************************************
*
*   NAME
*       thread_StartThread -- Create a thread.
*
*   SYNOPSIS
*       Thread thread_StartThread(Tags)
*
*       struct Thread *thread_StartThread(Tag, ... );
*
*   FUNCTION
*       Creates and starts a new thread (Process).
*
*   INPUTS
*       Tags - TagList (on stack)
*         TA_Name - Name of thread, defaults to "Thread".
*         TA_Stack - Stacksize, default 8192.
*         TA_Priority - default -1
*         TA_MsgHandler - Function to handle thread messages.
*         TA_UserData - (APTR)
*         TA_A6 - (struct Library *) 
*
*   RESULT
*       Pointer to the newly created Thread, or NULL on failure.
*       The Thread stucture is ReadOnly, except for
*         t_Node, UserData and ThreadData
*
*   NOTES
*       It's suggested that ThreadData be used store local data
*       for the Thread.
*
*   BUGS
*       1.3 - Made functional, some timing issues caused crashes.
*
*   SEE ALSO
*
******************************************************************************
*
*/

struct Thread *thread_StartThread(ULONG Tags, ... )
{
  struct TagItem *tl;
  struct Thread *thread;
  struct Process *proc=0;
  struct InitThread *init;
  UBYTE initaddr[11];
  BPTR input,output=0;
  BYTE sigbit;   
  APTR func;

  thread=0;
  tl=(APTR)&Tags;

DKP("1\n");

  if(func=(APTR)GetTagData(TA_MsgHandler, 0, tl))
  {
DKP("2\n");
    if(thread=AllocVec(sizeof(*thread),MEMF_CLEAR|MEMF_PUBLIC))
    {
DKP("3\n");
      thread->UserData=(APTR)GetTagData(TA_UserData, 0, tl);
      
      if((sigbit=AllocSignal(-1))!=-1)
      {
DKP("4\n");
        if(init=AllocVec(sizeof(struct InitThread),MEMF_PUBLIC|MEMF_CLEAR))
        {
DKP("5\n");
          init->it_CreaterTask  =FindTask(0);
          init->it_Signal      =sigbit;
          init->it_ModuleBase  =(struct Library *)getreg(REG_A6);  
          init->it_Thread      =thread;
          init->it_MsgHandler  =func;
          
 //         init->it_A6           =GetTagData(TA_A6, 0, tl))
    
          stci_d(initaddr,(LONG)init);
DKP("6  DosBase = %lx\n", DOSBase);           

          if(DOSBase)
          {   
            if(input=Open((STRPTR)"NIL:",MODE_OLDFILE))
            {
  DKP("7\n");
              if(output=Open((STRPTR)"NIL:",MODE_NEWFILE))
              {
                DKP("Creating Proc\n");
      
                if(proc=CreateNewProcTags(NP_Input         ,input,
                                          NP_Output        ,output,
                                          NP_Entry         ,ThreadEntry,
                                          NP_Name          ,GetTagData(TA_Name,           (ULONG)"Thread", tl),
                                          NP_StackSize     ,GetTagData(TA_Stack,          8192,           tl),
                                          NP_Arguments     ,initaddr,
                                          NP_Priority      ,GetTagData(TA_Priority,       -1,             tl),
                                          TAG_DONE))
                {
                  DKP("Proc Created - Waiting for Signal  it=%8lx a6=%8lx\n",init,init->it_ModuleBase);
                  Wait(1<<sigbit);
                  DKP("Signaled  RetVal=%ld\n",init->it_RetVal);
                  if(!init->it_RetVal)
                    proc=0;
                }
              }
            }
            if(!proc)
            {
              if(input)
                Close(input);
              if(output)
                Close(output);
            }
          }
          FreeVec(init);
        }
        FreeSignal(sigbit);
      }
      if(!thread->t_Process)
      {
        FreeVec(thread);
        thread=0;
      }
    }
  }
//  DKP("Leaving CreateInput\n");
  return(thread);
}      

/****** extras.lib/thread_EndThread ******************************************
*
*   NAME
*       thread_EndThread -- end a thread.
*
*   SYNOPSIS
*
*
*
*
*
*
*   FUNCTION
*
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*       Note, this function waits for a reply.
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


void thread_EndThread(struct Thread *Thread, APTR NullForNow)
{
  struct ThreadMessage diemsg;
  struct Message *cm;
  struct MsgPort mp;

  if(Thread)
  {
    SingleMsgPort(&mp);
  
    diemsg.tm_Msg.mn_ReplyPort     =&mp;
    diemsg.tm_Msg.mn_Length        =sizeof(diemsg);
    diemsg.tm_Command              =TMSG_DIE;
    
    if(Thread->t_MsgPort)
    {
      PutMsg(Thread->t_MsgPort,(struct Message *)&diemsg);
//      WaitForReply(&diemsg);
      while((cm=GetMsg(&mp))!=&diemsg)
      {
        WaitPort(&mp);
      }
    }
    FreeVec(Thread);
  }
}

void SingleMsgPort(struct MsgPort *MP)
{
  MP->mp_Flags=PA_SIGNAL;
  MP->mp_SigBit=SIGF_SINGLE; 
  MP->mp_SigTask=FindTask(0);
  NewList(&MP->mp_MsgList);
}

/* Meat & Potatoes */

void __asm __saveds ThreadEntry(register __a0 STRPTR Args)
{
  struct InitThread *it;
  
  it=(struct InitThread *)my_AToI(Args);

  ThreadSubEntry(it,it->it_ModuleBase);
}

void __asm __saveds ThreadSubEntry(register __a0 struct InitThread *it,
                                   register __a6 APTR LibBase)
{
  struct MsgPort *mp;
  struct Thread *me;
  struct ThreadMessage *diemsg=0;
  ULONG   isig,allsigs,sig; 
  BOOL    go=TRUE;
  void __asm (*MsgHandler)(register __a0 struct Thread *T,
                           register __a1 struct ThreadMessage *Msg,
                           register __a6 APTR LibBase);

  if(mp=CreateMsgPort())
  {
    isig=1<<mp->mp_SigBit;

    me=it->it_Thread;    
    it->it_Thread->t_MsgPort = mp;
    it->it_Thread->t_Process = (struct Process *)FindTask(0);
    MsgHandler=it->it_MsgHandler;

    it->it_RetVal=1;  /* Signal creator */
    Signal(it->it_CreaterTask,1<<it->it_Signal);

    it=0;  /* don't want to signal again, see below */

    allsigs=isig;
    while(go)
    {
//      DKP("Waiting for %8lx\n",allsigs);
      
//      sig=Wait(allsigs);
      sig=Wait(-1);
//      DKP("Signal recieved %8lx\n",sig);
      
      if(sig & isig)
      {
//        DKP("Message signal recieved\n");
        while(me->t_CurrentMsg=(struct ThreadMessage *)GetMsg(mp))
        {
//          DKP("Msg @ 0x%08lx\n",msg);
          switch(me->t_CurrentMsg->tm_Command)
          {
            case TMSG_DIE:
              MsgHandler(me,me->t_CurrentMsg,LibBase);
              diemsg=me->t_CurrentMsg;
              me->t_CurrentMsg=0;
              go=0;
              break;
            default:
              MsgHandler(me,me->t_CurrentMsg,LibBase);
              break;
          }
          if(me->t_CurrentMsg)
            ReplyMsg((APTR)me->t_CurrentMsg);
        }
      }
      
      if(sig & ~(isig))
      {
        struct TMsg_Signal tms;
        
        tms.TMsg.tm_Msg.mn_Length=sizeof(tms);
        tms.TMsg.tm_Command=TMSG_SIGNAL;
        tms.Signal=sig;
        
        MsgHandler(me,(APTR)&tms,LibBase);
      }
      
    }
    DeleteMsgPort(mp);  
  }
  
  if(it)
  {
    it->it_RetVal=0;  /* Signal creator */
    Signal(it->it_CreaterTask,1<<it->it_Signal);
  }
  
  Disable();
  
  if(diemsg)
    ReplyMsg((struct Message *)diemsg);
}

ULONG my_AToI(STRPTR Str)
{
  ULONG i=0;
  
  while(*Str>'9' || *Str<'0' && *Str)
    Str++;
  
  while(*Str<='9' && *Str>='0')
  {
    i=(i*10)+((*Str)-'0');
    Str++;
  }
  return(i);
}

/****** extras.lib/thread_PutTMsg ******************************************
*
*   NAME
*       thread_PutTMsg --
*
*   SYNOPSIS
*       success=thread_PutTMsg(Thread, Msg)
*
*       BOOL thread_PutTMsg(struct Thread *, struct ThreadMessage *)
*
*   FUNCTION
*       Send a message to the thread, this function does not
*       wait for a reply.  You must supply a reply port for
*       your message.
*
*   INPUTS
*       Thread - to send message to
*       Msg - Message to send.
*
*   RESULT
*       Non-zero if message successfully sent.     
*
*   NOTES
*       Note, this function does not wait for a reply.
*
******************************************************************************
*
*/


BOOL thread_PutTMsg(struct Thread *Thread, struct ThreadMessage *TM)
{
  if(Thread)
  {
    if(Thread->t_MsgPort)
    {
      PutMsg(Thread->t_MsgPort,(struct Message *)TM);
      return(1);
    }
  }
  return(0);
}


/****** extras.lib/thread_PutTMsg_TagList ******************************************
*
*   NAME
*       thread_PutTMsg_TagList -- Send a TagListTMsg to a thread (varargs)
*
*   SYNOPSIS
*       RetVal = thread_PutTMsg_TagList(Thread, Command, Tags ... )
*
*       ULONG thread_PutTMsg_TagList(struct Thread, ULONG, Tag, ...);
*
*   FUNCTION
*       Sends a message to the task, using the TMsg_TagList structure.
*       Waits for a reply, then returns tm_RetVal.
*
*   INPUTS
*       Thread - (struct Thread *)
*       Command - Command ID.
*       Tag - 
*
*   RESULT
*       returns zero on failure, otherwise returns value of TMsg_TagList.tm_RetVal.
*
*   NOTES
*       Note, this function waits for a reply.
*
******************************************************************************
*
*/


ULONG thread_PutTMsg_TagList(struct Thread *Thread, ULONG Command, ULONG Tag, ...)
{
  struct TMsg_TagList msg;
  struct MsgPort mp;

  if(Thread)
  {
    SingleMsgPort(&mp);
  
    msg.tm_Msg.mn_ReplyPort     =&mp;
    msg.tm_Msg.mn_Length        =sizeof(msg);
    msg.tm_Command              =Command;
    msg.tm_TagList              =(APTR)&Tag;
    
    if(Thread->t_MsgPort)
    {
      PutMsg(Thread->t_MsgPort,(struct Message *)&msg);
//      WaitForReply(&diemsg);

      while(&msg!=(APTR)GetMsg(&mp))
      {
        WaitPort(&mp);
      }
      return(msg.tm_RetVal);
    }
  }
  return(0);
}


/****** extras.lib/thread_PutTMsg_Sync ******************************************
*
*   NAME
*       thread_PutTMsg_Sync -- Send a ThreadMessage to a thread.
*
*   SYNOPSIS
*       success=thread_PutTMsg_Sync(Thread, Msg)
*
*       BOOL thread_PutTMsg_Sync(Thread, struct ThreadMessage);
*
*   FUNCTION
*       Send a message to the thread, this function will
*       wait for a reply.  The messages reply port will be changed.
*
*   INPUTS
*       Thread - to send message to
*       Msg - Message to send.
*
*   RESULT
*       Non-zero if message successfully sent.
*
*   NOTES
*       Note, this function waits for a reply.
*       replyport is changed
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


BOOL thread_PutTMsg_Sync(struct Thread *Thread, struct ThreadMessage *TMsg)//                         (1.3.1) (08/20/00)
{
  struct MsgPort mp;

  if(Thread)
  {
    SingleMsgPort(&mp);
  
    TMsg->tm_Msg.mn_ReplyPort     =&mp;
    
    if(Thread->t_MsgPort)
    {
      PutMsg(Thread->t_MsgPort,(struct Message *)TMsg);

      while(TMsg!=(APTR)GetMsg(&mp))
      {
        WaitPort(&mp);
      }
      TMsg->tm_Msg.mn_ReplyPort     =0;
      return(1);
    }
    TMsg->tm_Msg.mn_ReplyPort     =0;
  }
  return(0);
}

/****** extras.lib/thread_ReplyCurrentMsg ******************************************
*
*   NAME
*       thread_ReplyCurrentMsg -- replies the current ThreadMessage.
*
*   SYNOPSIS
*       thread_ReplyCurrentMsg(Thread)
*
*   FUNCTION
*       Replies the current ThreadMessage, only to be called from inside
*       the thread MsgHandler.  This may allow tasks waiting for a reply
*       while the MsgHandler processes the message.
*
*   INPUTS
*       The thread.
*
*   NOTE
*       You must cache the message data, once you reply the message,
*       that message data may no longer be valid..
*
*
******************************************************************************
*
*/


void thread_ReplyCurrentMsg(struct Thread *Thread)//                                                   (1.4.1) (08/24/00)
{
  ReplyMsg(Thread->t_CurrentMsg);
  Thread->t_CurrentMsg=0;
}
