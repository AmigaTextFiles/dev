#ifndef INTUITION_INTUITIONBASE_H
#include <intuition/intuitionbase.h>
#endif

#include <proto/intuition.h>

#include "Global.h"

/****** gamesupport.library/GS_WindowSleep *******************************
*
*    NAME
*	GS_WindowSleep -- put window to sleep
*
*    SYNOPSIS
*	Success = GS_WindowSleep(Window)
*	                          a0
*
*	ULONG GS_WindowSleep(struct Window *);
*
*    FUNCTION
*	Put window to sleep.
*
*    INPUTS
*	Window - the window.
*
*    RESULT
*	Success - TRUE for success (or for a NULL window)
*
*    NOTE
*	There are two possible reasons for failure: not enough memory
*	available to allocate a requester structure, or the maximum
*	number of requesters in the window would be exceeded.
*
*    SEE ALSO
*	GS_WindowWakeup()
*
*************************************************************************/

SAVEDS_ASM_A0(ULONG,LibGS_WindowSleep,struct Window *,Window)

{
  if (Window!=NULL)
    {
      struct Requester *Requester;

      if ((Requester=GS_MemoryAlloc(sizeof(*Requester)))!=NULL)
	{
	  InitRequester(Requester);
	  Requester->Flags|=NOREQBACKFILL | SIMPLEREQ;
	  if (Request(Requester,Window))
	    {
	      SetWindowPointer(Window,WA_BusyPointer,TRUE,WA_PointerDelay,TRUE,TAG_DONE);
	      return TRUE;
	    }
	  GS_MemoryFree(Requester);
	}
      return FALSE;
    }
  return TRUE;
}

/****** gamesupport.library/GS_WindowWakeup ******************************
*
*    NAME
*	GS_WindowWakeup -- wakeup window
*
*    SYNOPSIS
*	GS_WindowWakeup(Window)
*	                  a0
*
*	void GS_WindowWakeup(struct Window *);
*
*    FUNCTION
*	Undo the effects of GS_WindowSleep().
*
*    INPUTS
*	Window - the window
*
*    NOTE
*	This function removes the Window->FristRequester requester
*	and GS_MemoryFree()s it. So you better make sure it's not
*	another requester...
*
*************************************************************************/

SAVEDS_ASM_A0(void,LibGS_WindowWakeup,struct Window *,Window)

{
  if (Window!=NULL)
    {
      struct Requester *Requester;

      if ((Requester=Window->FirstRequest)!=NULL)
	{
	  EndRequest(Requester,Window);
	  ClearPointer(Window);
	  GS_MemoryFree(Requester);
	}
    }
}

#if 0
	  static UWORD __chip BusyPointer[] =
	    {
	      0x0000, 0x0000,     /* reserved, must be NULL */

	      0x0400, 0x07C0,
	      0x0000, 0x07C0,
	      0x0100, 0x0380,
	      0x0000, 0x07E0,
	      0x07C0, 0x1FF8,
	      0x1FF0, 0x3FEC,
	      0x3FF8, 0x7FDE,
	      0x3FF8, 0x7FBE,
	      0x7FFC, 0xFF7F,
	      0x7EFC, 0xFFFF,
	      0x7FFC, 0xFFFF,
	      0x3FF8, 0x7FFE,
	      0x3FF8, 0x7FFE,
	      0x1FF0, 0x3FFC,
	      0x07C0, 0x1FF8,
	      0x0000, 0x07E0,

	      0x0000, 0x0000,     /* reserved, must be NULL */
	    };

	  SetPointer(Window,BusyPointer,16,16,-6,0);
#endif
