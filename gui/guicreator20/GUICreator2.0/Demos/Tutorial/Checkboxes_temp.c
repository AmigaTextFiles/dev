/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Checkboxes_Includes.h"
#include "Checkboxes.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

BOOL one=FALSE,two=TRUE,three=FALSE;

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
}
void CBCheckbox1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   one = messagecode;
   if (one && two)
      {
      GT_SetGadgetAttrs(wingads[CBID_Checkbox3],win,NULL,GA_Disabled,TRUE,GTCB_Checked,FALSE,TAG_END);
      three = FALSE;
      }
   else GT_SetGadgetAttrs(wingads[CBID_Checkbox3],win,NULL,GA_Disabled,FALSE,TAG_END);
}
void CBCheckbox2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   two = messagecode;
   if (one && two)
      {
      GT_SetGadgetAttrs(wingads[CBID_Checkbox3],win,NULL,GA_Disabled,TRUE,GTCB_Checked,FALSE,TAG_END);
      three = FALSE;
      }
   else GT_SetGadgetAttrs(wingads[CBID_Checkbox3],win,NULL,GA_Disabled,FALSE,TAG_END);
}
void CBCheckbox3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   three = messagecode;
}

