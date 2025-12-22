/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Strings_Includes.h"
#include "Strings.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

static char string1[64];
static char string2[64];
static char string3[64];

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   GT_SetGadgetAttrs(wingads[STID_String1],win,NULL,GTST_String,"Enter END in 2. stringgadget!",TAG_END);
   ActivateGadget(wingads[STID_String1],win,NULL);
}
void STString1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   strcpy (string1,((struct StringInfo *)wingads[gadgetid]->SpecialInfo)->Buffer);
   GT_SetGadgetAttrs(wingads[STID_String2],win,NULL,GTST_String,string1,TAG_END);
}
void STString2Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   strcpy (string2,((struct StringInfo *)wingads[gadgetid]->SpecialInfo)->Buffer);
   if ( strcmp(string2,"END") )
      {
      GT_SetGadgetAttrs(wingads[STID_String3],win,NULL,GTST_String,string2,TAG_END);
      }
   else Signal(FindTask(NULL),SIGBREAKF_CTRL_C);
}
void STString3Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
   strcpy (string3,((struct StringInfo *)wingads[gadgetid]->SpecialInfo)->Buffer);
   GT_SetGadgetAttrs(wingads[STID_String1],win,NULL,GTST_String,string3,TAG_END);
}

