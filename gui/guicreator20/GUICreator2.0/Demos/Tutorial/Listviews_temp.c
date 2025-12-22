/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Listviews_Includes.h"
#include "Listviews.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

extern struct List list;
struct Node nodes[] = { &nodes[1],list.lh_Head, 0,0,"Hello",
                        &nodes[2],&nodes[0],    0,0,"this is an entry",
                        &nodes[3],&nodes[1],    0,0,"for the listview gadget",
                        list.lh_Tail,&nodes[2], 0,0,"Enjoy it." };

struct List list = { &nodes[0],NULL,&nodes[3],NT_USER };

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   GT_SetGadgetAttrs(wingads[LVID_Listview1],win,NULL,GTLV_Labels,~0,TAG_END);
   GT_SetGadgetAttrs(wingads[LVID_Listview1],win,NULL,GTLV_Labels,&list,GTLV_Selected,0,GTLV_Top,0,TAG_END);
}
void LVListview1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   ULONG longpointer = 0;
   struct List *l;
   GT_GetGadgetAttrs(wingads[LVID_Listview1],win,NULL,GTLV_Labels,&longpointer,TAG_END);
   l=(struct List *)longpointer;
   GT_SetGadgetAttrs(wingads[LVID_Listview2],win,NULL,GTLV_Labels,~0,TAG_END);
   GT_SetGadgetAttrs(wingads[LVID_Listview2],win,NULL,GTLV_Labels,&list,GTLV_Selected,0,GTLV_Top,0,TAG_END);
}

