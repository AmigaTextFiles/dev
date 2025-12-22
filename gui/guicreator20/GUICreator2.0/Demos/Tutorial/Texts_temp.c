/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Texts_Includes.h"
#include "Texts.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   Delay(50);
   GT_SetGadgetAttrs(wingads[TXID_Text1],win,NULL,GTTX_Text,"And this is",TAG_END);
   GT_SetGadgetAttrs(wingads[TXID_Text2],win,NULL,GTTX_Text,"another",TAG_END);
   GT_SetGadgetAttrs(wingads[TXID_Text3],win,NULL,GTTX_Text,"boring text.",TAG_END);
}

