/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Buttons_Includes.h"
#include "Buttons.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
}
void BTEnableClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   ULONG longpointer = 0;

   GT_GetGadgetAttrs(wingads[BTID_Button],win,NULL,GA_Disabled,&longpointer,TAG_END);
   if (TRUE == longpointer)
      {
      GT_SetGadgetAttrs(wingads[BTID_Button ],win,NULL,GA_Disabled,FALSE,TAG_END);
      }
   else DisplayBeep(win->WScreen);
}
void BTDisableClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   ULONG longpointer = 0;

   GT_GetGadgetAttrs(wingads[BTID_Button],win,NULL,GA_Disabled,&longpointer,TAG_END);
   if (FALSE == longpointer)
      {
      GT_SetGadgetAttrs(wingads[BTID_Button ],win,NULL,GA_Disabled,TRUE,TAG_END);
      }
   else DisplayBeep(win->WScreen);
}

