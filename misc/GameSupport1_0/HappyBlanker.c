#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef DEVICES_INPUT_H
#include <devices/input.h>
#endif

#include <proto/alib.h>
#include <proto/exec.h>

#include "Global.h"

/************************************************************************/

#include "StaticSaveds.h"

/************************************************************************/

static struct Task *HappyBlankerTask;

static struct Task *Parent;	/* acknowledge */
static ULONG AckSignal;		/* acknowledge */

struct SignalSemaphore HappyBlankerSemaphore;
struct SignalSemaphore HappyBlankerSemaphore2;

static ULONG UserCount;

/************************************************************************/

STATIC_SAVEDS(void,HappyBlankerCode)

{
  struct MsgPort MsgPort;
  struct timerequest TimerRequest;

  ObtainSemaphore(&HappyBlankerSemaphore2);

  MsgPort.mp_SigTask=FindTask(NULL);
  MsgPort.mp_Flags=PA_SIGNAL;
  MsgPort.mp_SigBit=SIGBREAKB_CTRL_F;
  MsgPort.mp_MsgList.lh_Head=(struct Node *)&MsgPort.mp_MsgList.lh_Tail;
  MsgPort.mp_MsgList.lh_Tail=NULL;
  MsgPort.mp_MsgList.lh_TailPred=(struct Node *)&MsgPort.mp_MsgList.lh_Head;

  TimerRequest.tr_node.io_Message.mn_ReplyPort=&MsgPort;
  if (OpenDevice("timer.device",UNIT_VBLANK,&TimerRequest.tr_node,0)==0)
    {
      struct IOStdReq InputRequest;

      InputRequest.io_Message.mn_ReplyPort=&MsgPort;
      if (OpenDevice("input.device",0,&InputRequest,0)==0)
	{
	  int Done;

	  Signal(Parent,AckSignal);
	  Permit();
	  ReplyMsg(&TimerRequest.tr_node.io_Message);
	  Done=FALSE;
	  do
	    {
	      struct Message *Message;

	      if (Wait(SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_F) & SIGBREAKF_CTRL_C)
		{
		  Done=TRUE;
		}
	      else if ((Message=GetMsg(&MsgPort))!=NULL)
		{
		  struct InputEvent InputEvent;

		  assert(Message==&TimerRequest.tr_node.io_Message);
		  InputRequest.io_Command=IND_WRITEEVENT;
		  InputRequest.io_Data=&InputEvent;
		  InputRequest.io_Length=sizeof(InputEvent);
		  InputEvent.ie_NextEvent=NULL;
		  InputEvent.ie_Class=IECLASS_RAWKEY;
		  InputEvent.ie_SubClass=0;
		  InputEvent.ie_Code=0x6f;
		  InputEvent.ie_Qualifier=0;
		  InputEvent.ie_X=0;
		  InputEvent.ie_Y=0;
		  DoIO(&InputRequest);
		  TimerRequest.tr_node.io_Command=TR_ADDREQUEST;
		  TimerRequest.tr_time.tv_secs=30;
		  TimerRequest.tr_time.tv_micro=0;
		  SendIO(&TimerRequest.tr_node);
		}
	    }
	  while (!Done);
	  AbortIO(&TimerRequest.tr_node);
	  WaitIO(&TimerRequest.tr_node);
	  CloseDevice(&InputRequest);
	}
      CloseDevice(&TimerRequest.tr_node);
    }
  Forbid();
  HappyBlankerTask=NULL;
  ReleaseSemaphore(&HappyBlankerSemaphore2);
}

/****** gamesupport.library/GS_HappyBlanker ******************************
*
*    NAME
*	GS_HappyBlanker -- keep a screenblanker happy
*
*    SYNOPSIS
*	Success = GS_HappyBlanker()
*	   d0
*
*	ULONG GS_HappyBlanker(void);
*
*    FUNCTION
*	Turn the happy blanker on.
*	This means that input events will be sent down the input stream
*	to make sure that a screenblanker doesn't suddenly blank the
*	screen.
*	Turn this on while playing. Turn it off in pause or demo mode.
*
*    RESULT
*
*    SEE ALSO
*	GS_NoHappyBlanker()
*
*************************************************************************/

SAVEDS(ULONG,LibGS_HappyBlanker)

{
  ULONG RC;

  ObtainSemaphore(&HappyBlankerSemaphore);
  if (UserCount==0)
    {
      BYTE TheSignal;

      RC=FALSE;
      if ((TheSignal=AllocSignal(-1))!=-1)
	{
	  AckSignal=(1<<TheSignal);
	  SetSignal(0,AckSignal);
	  Parent=FindTask(NULL);
	  if ((HappyBlankerTask=CreateTask("gamesupport.library: Happy blanker",0,HappyBlankerCode,4096))!=NULL)
	    {
	      Wait(AckSignal);
	      if (HappyBlankerTask!=NULL)
		{
		  UserCount++;
		  RC=TRUE;
		}
	    }
	  FreeSignal(TheSignal);
	}
    }
  else
    {
      UserCount++;
      RC=TRUE;
    }
  ReleaseSemaphore(&HappyBlankerSemaphore);
  return RC;
}

/****** gamesupport.library/GS_NoHappyBlanker ****************************
*
*   NAME
*	GS_NoHappyBlanker -- turn the happy blanker off
*
*   SYNOPSIS
*	GS_NoHappyBlanker()
*
*	void GS_NoHappyBlanker(void);
*
*   FUNCTION
*	Turn off the happy blanker.
*
*   NOTE
*	Only call this if GS_HappyBlanker() returned success.
*
*   SEE ALSO
*	GS_HappyBlanker()
*
*************************************************************************/

SAVEDS(void,LibGS_NoHappyBlanker)

{
  ObtainSemaphore(&HappyBlankerSemaphore);
  if (--UserCount==0)
    {
      assert(HappyBlankerTask!=NULL);
      Signal(HappyBlankerTask,SIGBREAKF_CTRL_C);
      ObtainSemaphore(&HappyBlankerSemaphore2);
      ReleaseSemaphore(&HappyBlankerSemaphore2);
      HappyBlankerTask=NULL;
    }
  ReleaseSemaphore(&HappyBlankerSemaphore);
}
