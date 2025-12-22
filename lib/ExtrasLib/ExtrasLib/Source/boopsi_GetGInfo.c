#include <intuition/classusr.h>
#include <intuition/cghooks.h>
#include <intuition/gadgetclass.h>

#include <clib/extras_protos.h>
#include <clib/extras/boopsi_protos.h>

/****** extras.lib/boopsi_GetGInfo ******************************************
*
*   NAME
*       boopsi_GetGInfo -- Get the GadgetInfo pointer from common BOOPSI messages
*
*   SYNOPSIS
*       ginfo = boopsi_GetGInfo(Message)
*
*       struct GadgetInfo *boopsi_GetGInfo(Msg);
*
*   FUNCTION
*       Gets the pointer to the GadgetInfo structure from a BOOPSI
*       message.
*
*   INPUTS
*       Message - BOOPSI message pointer.
*
*   RESULT
*       pointer to GadgetInfo structure or NULL.
*
*   NOTES
*       Only handles OM_SET, OM_UPDATE, OM_NOTIFY, GM_HITTEST,
*       GM_RENDER, GM_GOACTIVE, GM_HANDLEINPUT, GM_GOINACTIVE
*       and GM_LAYOUT methods.
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/

struct GadgetInfo *boopsi_GetGInfo(Msg Message)
{
  switch(Message->MethodID)
  {
    case OM_SET:
    case OM_UPDATE:
    case OM_NOTIFY:
      return( ((struct opSet *)Message)->ops_GInfo );
      
    case GM_HITTEST:
    case GM_RENDER:
    case GM_GOACTIVE:
    case GM_HANDLEINPUT:
    case GM_GOINACTIVE:
    case GM_LAYOUT:
      return( ((struct gpHitTest *)Message)->gpht_GInfo );
  }
  return(0);
}
      
