/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Numbers_Includes.h"
#include "Numbers.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   ULONG longpointer = 0;
   Delay(50);
   GT_GetGadgetAttrs(wingads[NBID_Number1],win,NULL,GTNM_Number, &longpointer  ,TAG_END);
   GT_SetGadgetAttrs(wingads[NBID_Number1],win,NULL,GTNM_Number,++longpointer  ,TAG_END);
   GT_SetGadgetAttrs(wingads[NBID_Number2],win,NULL,GTNM_Number,++longpointer*2,TAG_END);
   GT_SetGadgetAttrs(wingads[NBID_Number3],win,NULL,GTNM_Number,++longpointer*3,TAG_END);
}

