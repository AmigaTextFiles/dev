#define __USE_SYSBASE
//#include <clib/extras_protos.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

/****** extras.lib/Busy ******************************************
*
*   NAME
*       Busy -- displays busy pointer.
*
*   SYNOPSIS
*       Busy(Window)
*
*       void Busy(struct Window *);
*
*   FUNCTION
*       Blocks input to a window by opening a requester.
*
*   INPUTS
*       Window - 
*
*   RESULT
*       None.
*
*   NOTES
*       requires intuition.library to be open.
*
*       This does not change the Window's IDCMP flags, so
*       unless you change them your still going to receive
*       input events.
*       This function does nothing in WB versions less than
*       3.0
*
*   SEE ALSO
*       NotBusy()
*
******************************************************************************
*
*/

struct Requester *Busy(struct Window *Win)
{
  struct Requester *req;
  
  if(req=AllocVec(sizeof(struct Requester),MEMF_PUBLIC|MEMF_CLEAR))
  {
    InitRequester(req);
    if(Request(req,Win))
    {
      if(IntuitionBase->LibNode.lib_Version>=39)
      {
        SetWindowPointer(Win,WA_BusyPointer,TRUE,
                             WA_PointerDelay,TRUE,
                             TAG_DONE);
      }
      return(req);
    }
    FreeVec(req);
  }
  return(0);
}

/****** extras.lib/NotBusy ******************************************
*
*   NAME
*       NotBusy -- displays busy pointer.
*
*   SYNOPSIS
*       NotBusy(Window)
*
*       void NotBusy(struct Window *);
*
*   FUNCTION
*       Removes the busy pointer for the specified
*       window.
*
*   INPUTS
*       Window - the window to remove the busy pointer
*                from.
*
*   RESULT
*       None.
*
*   NOTES
*       requires intuition.library to be open.
*
*       This does not change the Window's IDCMP flags.
*       This function does nothing in WB versions less than
*       3.0
*
*   SEE ALSO
*       Busy()
*
******************************************************************************
*
*/


void NotBusy(struct Window *Win, struct Requester *Req)
{
  if(Req && Win)
  {
    if(IntuitionBase->LibNode.lib_Version>=39)
    {
      SetWindowPointer(Win,TAG_DONE);
    }
    EndRequest(Req,Win);
  }
}
