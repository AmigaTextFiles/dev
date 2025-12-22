/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#include "Textfields_Includes.h"
#include "Textfields.h"

/*************************************************************************/
/*                                                                       */
/*   Functions                                                           */
/*                                                                       */
/*************************************************************************/

static unsigned char *mybuffer;

/* Functions for Window */
void UserSetupWindow(struct Window *win,struct Gadget *wingads[],APTR userdata)
{
   /* D: Diese Funktion wird aufgerufen, sobald das Fenster geöffnet worden ist */
   /* E: This Function is called when the window has been opened */

   unsigned long length;
   unsigned char *tbuffer;

   /* D: Bevor man beim Textfield-Gadget den Text lesen kann, muß das Gadget auf 'Lesen' geschaltet werden */
   /* E: Before you can read the gadget's text, you must put it into a 'read' state */

   SetGadgetAttrs(wingads[TFID_Textfield1],win,NULL,TEXTFIELD_ReadOnly,TRUE,TAG_END);
   GetAttr(TEXTFIELD_Size,wingads[TFID_Textfield1],&length);
   GetAttr(TEXTFIELD_Text,wingads[TFID_Textfield1],(ULONG *)&tbuffer);

   mybuffer = (unsigned char *)malloc (length + 1);
   if (mybuffer)
      {
      memcpy(mybuffer,tbuffer,length);
      mybuffer[length]=0;
      }
   else GUIC_ErrorReport(win,ERROR_NO_FREE_STORE);

   /* D: Mit der Funktion GUIC_ErrorReport() kann man die AmigaDOS-Fehlermeldungen (siehe dos/dos.h) als Requester ausgeben */
   /* E: With the function GUIC_ErrorReoirt() you can easily make Requesters with AmigaDOS error codes (see also dos/dos.h) */

   SetGadgetAttrs(wingads[TFID_Textfield1],win,NULL,TEXTFIELD_ReadOnly,FALSE,TAG_END);
}
void TFTexfield1Clicked(struct Window *win,struct Gadget *wingads[],ULONG gadgetid,ULONG messagecode,APTR userdata)
{
}

