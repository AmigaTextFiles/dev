/* Test für den GadEd C-Source */

#include "unbekannt.h"
#include <exec/types.h>
#include <intuition/screens.h>
#include <libraries/gadtools.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/exec.h>

struct Screen		*S;
struct Window		*Wi;
struct Gadget		*TempGadget;
struct IntuiMessage	*Message;
WORD			ID;
UWORD			Code;
ULONG			Cla;
BOOL			OK;

static struct TagItem STags[] = {
 SA_Title,(ULONG)"User Tag Test *************",
/* SA_Top,5,
 SA_Left,10, */
 TAG_DONE,0
};

static struct TagItem WTags[] = {
 WA_Title,(ULONG)"Window **********",
/* WA_Activate,FALSE,
 WA_SizeGadget,TRUE,
 WA_MinWidth,40,
 WA_MinHeight,30,
 WA_MaxWidth,(ULONG)-1,
 WA_MaxHeight,(ULONG)-1, */
 TAG_DONE,0
};

void main(void)
{
   S=LockPubScreen(NULL);
   if (InitUnbekannt(S ,&STags[0] )) {

      Wi=InitProc00Mask(&WTags[0]);
      if (Wi) {
         do {
            do {
               WaitPort(Wi->UserPort);
               Message=GT_GetIMsg(Wi->UserPort);
            } while (Message==NULL);
            Cla  = Message->Class;
            Code = Message->Code;
            TempGadget = Message->IAddress;
            GT_ReplyIMsg(Message);
         } while (IDCMP_CLOSEWINDOW != Cla);
         CloseProc00Mask();
      }

      Wi=InitProc00Mask(&WTags[0]);
      if (Wi) {
         do {
            do {
               WaitPort(Wi->UserPort);
               Message=GT_GetIMsg(Wi->UserPort);
            } while (Message==NULL);
            Cla  = Message->Class;
            Code = Message->Code;
            TempGadget = Message->IAddress;
            GT_ReplyIMsg(Message);
         } while (IDCMP_CLOSEWINDOW != Cla);
         CloseProc00Mask();
      }

      FreeUnbekannt();
   }
   UnlockPubScreen(NULL,S);
}
