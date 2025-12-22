/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Radios_Includes.h"
#include "Radios.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

ULONG computer=0,equipment=0;

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   GT_GetGadgetAttrs(wingads[MXID_Radio1],win,NULL,GTMX_Active,&computer ,TAG_END);
   GT_GetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GTMX_Active,&equipment,TAG_END);
}
void MXRadio1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   computer = messagecode;
   GT_SetGadgetAttrs(wingads[MXID_Radio2],win,NULL,GA_Disabled,computer == 0,TAG_END);
}
void MXRadio2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   equipment = messagecode;
}

