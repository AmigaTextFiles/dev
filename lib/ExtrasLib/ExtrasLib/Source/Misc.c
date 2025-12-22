#define __USE_SYSBASE
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/commodities.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/diskfont.h>
#include <intuition/intuitionbase.h>
#include <intuition/gadgetclass.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <clib/extras_protos.h>



/****** extras.lib/AddHotKey ******************************************
*
*   NAME
*       AddHotKey -- Add a hotkey to a Broker.
*
*   SYNOPSIS
*       cxobj = AddHotKey(Broker,BrokerPort,HotKey,ID)
*
*       CxObj *AddHotKey(CxObj *,struct MsgPort *,STRPTR,ULONG)
*
*   FUNCTION
*       Creates a hotkey for a broker.
*
*   INPUTS
*       Broker     - Broker CxObj to attach hotkey to. 
*       BrokerPort - Broker's MsgPort.
*       HotKey     - Null terminated string.
*       ID         - Hot keys ID. 
*       
*   RESULT
*       pointer to a CxObj.
*
*   EXAMPLE
*
*   NOTES
*    requires commodities.library to be opened. 
*     commodities library already has HotKey()
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


CxObj *AddHotKey(CxObj *Broker,struct MsgPort *BrokerPort,UBYTE *HotKey,ULONG ID)
{
  CxObj *f, *s, *t;

  if(f=CxFilter(HotKey))
  {
    AttachCxObj(Broker,f);
    if(s=CxSender(BrokerPort,ID))
    {
      AttachCxObj(f,s);
      if(t=CxTranslate(NULL))
      {
        AttachCxObj(f,t);
        if(!CxObjError(f)) return(f);
      }
    }
  }
  if(f) DeleteCxObjAll(f);
  return(NULL);
}
