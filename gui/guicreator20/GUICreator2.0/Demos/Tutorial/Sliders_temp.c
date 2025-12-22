/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Sliders_Includes.h"
#include "Sliders.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
}
void SLSlider1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   GT_SetGadgetAttrs(wingads[SLID_Slider2],win,NULL,GTSL_Level,messagecode,TAG_END);
   GT_SetGadgetAttrs(wingads[SLID_Slider3],win,NULL,GTSL_Level,messagecode/10,TAG_END);
}
void SLSlider2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   GT_SetGadgetAttrs(wingads[SLID_Slider1],win,NULL,GTSL_Level,messagecode,TAG_END);
   GT_SetGadgetAttrs(wingads[SLID_Slider3],win,NULL,GTSL_Level,messagecode/10,TAG_END);
}
void SLSlider3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   GT_SetGadgetAttrs(wingads[SLID_Slider1],win,NULL,GTSL_Level,messagecode*10,TAG_END);
   GT_SetGadgetAttrs(wingads[SLID_Slider2],win,NULL,GTSL_Level,messagecode*10,TAG_END);
}

