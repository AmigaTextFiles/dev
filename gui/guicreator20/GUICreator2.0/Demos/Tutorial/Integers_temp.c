/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Integers_Includes.h"
#include "Integers.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

ULONG int1,int2,int3;

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   int1 = int2 = int3 = 4711;
   ActivateGadget(wingads[INID_Integer1],win,NULL);
}
void INInteger1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   int1 = atoi( ((struct StringInfo *)wingads[gadgetid]->SpecialInfo)->Buffer );
   GT_SetGadgetAttrs(wingads[gadgetid+1],win,NULL,GTIN_Number,int1*2,GA_Disabled,FALSE,TAG_END);
   ActivateGadget(wingads[INID_Integer2],win,NULL);
}
void INInteger2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   int2 = atoi( ((struct StringInfo *)wingads[gadgetid]->SpecialInfo)->Buffer );
   GT_SetGadgetAttrs(wingads[gadgetid+1],win,NULL,GTIN_Number,int2*2,GA_Disabled,FALSE,TAG_END);
   ActivateGadget(wingads[INID_Integer3],win,NULL);
}
void INInteger3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   int3 = atoi( ((struct StringInfo *)wingads[gadgetid]->SpecialInfo)->Buffer );
   GT_SetGadgetAttrs(wingads[gadgetid-1],win,NULL,GTIN_Number,int3*2,TAG_END);
}

