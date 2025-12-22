/* Definition of percent gadget class */


#include "percent.h"


/*
 
  Accepted tags, see percent.h for definition :
 
    GA_ID
    GA_Left
    GA_Top
    GA_Width
    GA_Height
    PER_Min
    PER_Max
    PER_Val
    PER_PulseUp
    PER_PulseDown
    PER_Vertical
    
*/

struct PercentModelData
{
  long curval;
  long vertical;
  long minval;
  long maxval;
};


Class *percentclass;


ULONG dispatchpercentclass(Class *cl, Object *o, Msg msg)
{
  struct PercentModelData *pmd;
  APTR retval = NULL;
  
  switch (msg->MethodID)
    {
    case OM_NEW :
        if (retval = (APTR)DoSuperMethodA(cl, o, msg))
            {
            pmd = INST_DATA(cl,retval);
            
            /* set up initial values */
            
            }
        break;
    case OM_SET :
    case OM_UPDATE :
        pmd = INST_DATA(cl,o);
        break;
    case OM_GET :
        pmd = INST_DATA(cl,o);
        break;
    default:
        retval = (APTR)DoSuperMethodA(cl, o, msg);
        break;
    }
  return ((ULONG)retval);
}


void createpercentclass(void)
{
  extern ULONG HookEntry();
  
  if (percentclass = MakeClass ( "percent.gadget",
                                 "gadgetclass",
                                 NULL,
                                 sizeof(struct PercentModelData),
                                 0
                               ))
    {
    percentclass->cl_Dispatcher.h_Entry = HookEntry;
    percentclass->cl_Dispatcher.h_SubEntry = dispatchpercentclass;
    }
                           
}

void removepercentclass(void)
{
  FreeClass(percentclass);
}