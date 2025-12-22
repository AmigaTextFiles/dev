/* Test für den GadEd C-Source */

#include <exec/types.h>
#include <intuition/screens.h>
#include <libraries/gadtools.h>
#include <utility/utility.h>
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

static WORD ZoomArray[] = {
 400,160,100,18};

static struct TagItem STags[] = {
 SA_Title,(ULONG)"User Tags Test",
 TAG_DONE,0
};

static struct TagItem WTags[] = {
 WA_Zoom,(ULONG)&ZoomArray,
 WA_Title,(ULONG)"Neuer Window Name ***********",
 /*  WA_SizeGadget,TRUE,
 WA_MinWidth,40,
 WA_MinHeight,40,
 WA_MaxWidth,~0,
 WA_MaxHeight,~0,
 WA_Width,100,
 WA_Height,100,
 WA_Top,20,
 WA_Left,20, */
 TAG_DONE,0
};

/*
struct Screen __asm *InitUnbekannt(register __a0 struct Screen  *Scr);
struct Window __asm *InitProc00Mask(void);
*/

struct Screen __asm *InitUnbekannt(register __a0 struct Screen  *Scr,
                                   register __a1 struct TagItem *UserTags);
struct Window __asm *InitProc00Mask(register __a0 struct TagItem *UserTags);


void RefreshProc00(void);
struct Gadget __asm *GetProc00GPtr(register __d0 LONG Nummer);
void CloseProc00Mask(void);

void FreeUnbekannt(void);

void main(void)
{
   S=LockPubScreen(NULL);
   if (InitUnbekannt(NULL ,&STags[0]  )) {

      if ((Wi=InitProc00Mask( &WTags[0]  ))) {
         do {
            do {
               WaitPort(Wi->UserPort);
               Message=GT_GetIMsg(Wi->UserPort);
            } while (Message==NULL);
            Cla  = Message->Class;
            Code = Message->Code;
            TempGadget = Message->IAddress;
            GT_ReplyIMsg(Message);
            if (Cla & IDCMP_NEWSIZE) {
               GT_BeginRefresh(Wi);
               RefreshProc00();
               GT_EndRefresh(Wi,TRUE);
            }
         } while (IDCMP_CLOSEWINDOW != Cla);
         CloseProc00Mask();
      }

      FreeUnbekannt();
   }
   UnlockPubScreen(NULL,S);
}
