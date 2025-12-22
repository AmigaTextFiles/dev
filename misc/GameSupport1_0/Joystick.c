#ifndef DEVICES_GAMEPORT_H
#include <devices/gameport.h>
#endif

#include <proto/exec.h>

#include "Global.h"

/************************************************************************/

struct SignalSemaphore JoystickSemaphore;

/****** gamesupport.library/GS_AllocateJoystick **************************
*
*   NAME
*	GS_AllocateJoystick -- allocate the joystick
*
*   SYNOPSIS
*	success = GS_AllocateJoystick(ReplyPort,ControllerType)
*	   d0                            a0           d0
*
*	ULONG GS_AllocateJoystick(struct MsgPort *, UBYTE);
*
*   FUNCTION
*	Allocate gameport 1 by assigning it the specified controller
*	type.
*	If you allocate GPCT_ABSJOYSTICK, the trigger will be set
*	to report all joystick events and no timeouts.
*	You can use GameSupportBase->Joystick.Request and
*	GameSupportBase->Joystick.Event to access the controller.
*
*   INPUTS
*	ReplyPort      - the port to use for the device I/O
*	ControllerType - the controller type (see <devices/gameport.h>)
*
*   RESULT
*	success - TRUE if you got the joystick. FALSE if someone else
*	    still owns it. You might want to try again later.
*
*   SEE ALSO
*	GS_FreeJoystick(), GS_SendJoystick(), <devices/gameport.h>
*
*************************************************************************/

SAVEDS_ASM_D0A0(ULONG,LibGS_AllocateJoystick,UBYTE,ControllerType,struct MsgPort *,ReplyPort)

{
  if (AttemptSemaphore(&JoystickSemaphore))
    {
      if (GameSupportBase->Joystick.Request.io_Device==NULL)
	{
	  GameSupportBase->Joystick.Request.io_Message.mn_ReplyPort=ReplyPort;
	  if (OpenDevice("gameport.device",1L,&GameSupportBase->Joystick.Request,0L)==0)
	    {
	      BYTE TheControllerType;

	      GameSupportBase->Joystick.Request.io_Command=GPD_ASKCTYPE;
	      GameSupportBase->Joystick.Request.io_Length=1;
	      GameSupportBase->Joystick.Request.io_Data=&TheControllerType;
	      TheControllerType=GPCT_NOCONTROLLER;
	      Forbid();
	      DoIO(&GameSupportBase->Joystick.Request);
	      if (TheControllerType==GPCT_NOCONTROLLER)
		{
		  GameSupportBase->Joystick.Request.io_Command=GPD_SETCTYPE;
		  GameSupportBase->Joystick.Request.io_Length=1;
		  GameSupportBase->Joystick.Request.io_Data=&TheControllerType;
		  TheControllerType=ControllerType;
		  DoIO(&GameSupportBase->Joystick.Request);
		  Permit();
		  if (ControllerType==GPCT_ABSJOYSTICK)
		    {
		      static struct GamePortTrigger JoystickTrigger=
			{
			  GPTF_UPKEYS | GPTF_DOWNKEYS,
			  0,
			  1, 1
			};

		      GameSupportBase->Joystick.Request.io_Command=GPD_SETTRIGGER;
		      GameSupportBase->Joystick.Request.io_Data=&JoystickTrigger;
		      GameSupportBase->Joystick.Request.io_Length=sizeof(JoystickTrigger);
		      DoIO(&GameSupportBase->Joystick.Request);
		    }
		  GameSupportBase->Joystick.Request.io_Command=CMD_CLEAR;
		  DoIO(&GameSupportBase->Joystick.Request);
		  return TRUE;
		}
	      Permit();
	      CloseDevice(&GameSupportBase->Joystick.Request);
	    }
	  GameSupportBase->Joystick.Request.io_Device=NULL;
	}
      ReleaseSemaphore(&JoystickSemaphore);
    }
  return FALSE;
}

/****** gamesupport.library/GS_SendJoystick ******************************
*
*    NAME
*	GS_SendJoystick -- send joystick request
*
*    SYNOPSIS
*	GS_SendJoystick()
*
*	void GS_SendJoystick(void);
*
*    FUNCTION
*	Initialize the GameSupportBase->Joystick.Request request
*	as GPD_READEVENT and send it to the gameport device.
*	Basically, joystick handling works like this:
*
*	GS_AllocateJoystick()
*	GS_SendJoystick()
*	while (..)
*	  {
*	    Wait until GameSupportBase->Joystick.Request arrives at
*	      your ReplyPort
*	    Process GameSupportBase->Joystick.Event
*	    GS_SendJoystick()
*	  }
*	AbortIO()
*	GS_FreeJoystick()
*
*************************************************************************/

SAVEDS(void,LibGS_SendJoystick)

{
  GameSupportBase->Joystick.Request.io_Command=GPD_READEVENT;
  GameSupportBase->Joystick.Request.io_Length=sizeof(GameSupportBase->Joystick.Event);
  GameSupportBase->Joystick.Request.io_Data=&GameSupportBase->Joystick.Event;
  SendIO(&GameSupportBase->Joystick.Request);
}

/****** gamesupport.library/GS_FreeJoystick ******************************
*
*   NAME
*	GS_FreeJoystick -- free the joystick
*
*   SYNOPSIS
*	GS_FreeJoystick()
*
*	void GS_FreeJoystick(void);
*
*   FUNCTION
*	Free the joystick you have allocated with GS_AllocateJoystick().
*	This makes the joystick available for other programs to use.
*
*   NOTE
*	You should only hold the joystick while your window is
*	active. Remember, this is a non shareable resource!
*	So, it seems reasonable to to adopt the idea of a window
*	having the focus to the joystick as well: as long as a
*	window has the focus, input is directed to that window.
*
*    NOTE
*	The joystick is allocated on a per-task basis. The same task
*	that successfully called GS_AllocateJoystick must call
*	GS_FreeJoystick().
*
*    NOTE
*	You may call this function even if you don't own the
*	joystick. In this case, nothing happens.
*
*    SEE ALSO
*	GS_AllocateJoystick()
*
*************************************************************************/

SAVEDS(void,LibGS_FreeJoystick)

{
  if (AttemptSemaphore(&JoystickSemaphore))
    {
      if (GameSupportBase->Joystick.Request.io_Device!=NULL)
	{
	  BYTE ControllerType;

	  GameSupportBase->Joystick.Request.io_Command=GPD_SETCTYPE;
	  GameSupportBase->Joystick.Request.io_Length=1;
	  GameSupportBase->Joystick.Request.io_Data=&ControllerType;
	  ControllerType=GPCT_NOCONTROLLER;
	  DoIO(&GameSupportBase->Joystick.Request);
	  CloseDevice(&GameSupportBase->Joystick.Request);
	  GameSupportBase->Joystick.Request.io_Device=NULL;
	  ReleaseSemaphore(&JoystickSemaphore);
	}
      ReleaseSemaphore(&JoystickSemaphore);
    }
}
