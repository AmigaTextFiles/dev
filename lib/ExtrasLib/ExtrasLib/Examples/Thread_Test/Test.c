#define DEBUG
#include <debug.h>


#include <extras/threads.h>
#include <clib/extras/thread_protos.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/diskfont.h>
#include <proto/dos.h>
#include <stdio.h>
#include <exec/memory.h>
#include <stdlib.h>

void __asm __saveds myMsgHandler(register __a0 struct Thread *T,
                                 register __a1 struct ThreadMessage *Msg);

void main(void)
{
  struct MsgPort *mp;
  struct Thread *t;
  struct ThreadMessage m;
  
  if(mp=CreateMsgPort())
  {
    DKP("Starting Thread\n");
    if(t=thread_StartThread(TA_MsgHandler,  myMsgHandler,
                        0))
    {
      DKP("Thread Running\n");

      m.tm_Command=1;
      m.tm_Msg.mn_ReplyPort=mp;
      m.tm_Msg.mn_Length=sizeof(m);

      Delay(50);
      
      DKP("Putting a Message\n");
      thread_PutTMsg(t, &m);
      WaitPort(mp);
      DKP("  replied\n");

      Delay(50);

      DKP("Putting another Message\n");
      m.tm_Command=20;
      thread_PutTMsg_TagList(t, 20, TAG_DONE);
//      WaitPort(mp);
      DKP("  replied\n");

      Delay(50);
      
      DKP("Ending Thread\n");
      thread_EndThread(t,0);
      DKP("  Thread ended\n");
      Delay(50);

    }
    DeleteMsgPort(mp);
  }
}

void __asm __saveds myMsgHandler(register __a0 struct Thread *T,
                                 register __a1 struct ThreadMessage *Msg)
{
//  printf("Msg Command=%d\n",Msg->tm_Command);

  switch(Msg->tm_Command)
  {
    case 1:
      DKP("Command 1: Delay(120);\n");
      Delay(60 * 2);
      break;
      
    case 20:
      DKP("Command 20:\n");
      Delay(50);
      break;
      
    case TMSG_DIE:
      Delay(30);
//      DKP("Ahhhh, you've killed me\n");
      break;
  }      

//  ReplyMsg((struct Message *)Msg);
}
