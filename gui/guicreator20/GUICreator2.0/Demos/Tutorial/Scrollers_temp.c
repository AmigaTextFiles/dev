/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Scrollers_Includes.h"
#include "Scrollers.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
}
void SCScrollerClicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   GT_SetGadgetAttrs(wingads[SCID_Scroller2],win,NULL,GTSC_Visible,messagecode,TAG_END);
   GT_SetGadgetAttrs(wingads[SCID_Scroller3],win,NULL,GTSC_Visible,messagecode,TAG_END);
}
void SCScroller2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   GT_SetGadgetAttrs(wingads[SCID_Scroller1],win,NULL,GTSC_Visible,messagecode,TAG_END);
   GT_SetGadgetAttrs(wingads[SCID_Scroller3],win,NULL,GTSC_Visible,messagecode,TAG_END);
}
void SCScroller3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   GT_SetGadgetAttrs(wingads[SCID_Scroller1],win,NULL,GTSC_Visible,messagecode,TAG_END);
   GT_SetGadgetAttrs(wingads[SCID_Scroller2],win,NULL,GTSC_Visible,messagecode,TAG_END);
}

