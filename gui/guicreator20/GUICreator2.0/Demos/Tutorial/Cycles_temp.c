/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Cycles_Includes.h"
#include "Cycles.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

static ULONG c1=0,c2=0,c3=0;

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   GT_GetGadgetAttrs(wingads[CYID_Cycle1],win,NULL,GTCY_Active,&c1,TAG_END);
   GT_GetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GTCY_Active,&c2,TAG_END);
   GT_GetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GTCY_Active,&c3,TAG_END);
}
void CYCycle1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   c1 = messagecode;
   if (c1 == 3)
      {
      GT_SetGadgetAttrs(wingads[CYID_Cycle2],win,NULL,GTCY_Active,2,TAG_END);
      GT_SetGadgetAttrs(wingads[CYID_Cycle3],win,NULL,GTCY_Active,3,TAG_END);
      }
}
void CYCycle2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   c2 = messagecode;
}
void CYcycle3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   c3 = messagecode;
}

