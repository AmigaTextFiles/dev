/*
 *	File:					cursorHook.c
 *	Description:	Cursor controlment from stringgadgets.
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef CURSORHOOK_C
#define CURSORHOOK_C

/*** INCLUDES ************************************************************************/
#include "System_Prefs.h"
#include "cursorHook.h"
#include "TASK_Main.h"
#include "TASK_Text.h"

/*** GLOBALS *************************************************************************/
struct Hook cursorHook;

/*** PROTOTYPES **********************************************************************/
void initCursorHook(void)
{
	cursorHook.h_Entry		=(HOOKFUNC)cursorHookFunc;
  cursorHook.h_SubEntry	=NULL;
  cursorHook.h_Data			=NULL;
}

__asm __saveds ULONG cursorHookFunc(register __a0 struct Hook		*hook,
																		register __a2 struct SGWork	*sgw,
																		register __a1 ULONG					*msg)
{
	ULONG return_code=0L;

	if(*msg==SGH_KEY)
		switch(sgw->IEvent->ie_Code)
		{
			case CURSORUP:
			case CURSORDOWN:
				{
					struct IntuiMessage *msg;

					if(msg=(struct IntuiMessage *)AllocVec(sizeof(struct IntuiMessage), MEMF_CLEAR))
					{
						msg->Qualifier		=sgw->IEvent->ie_Qualifier;
						msg->Code					=sgw->IEvent->ie_Code;
						msg->Class				=IDCMP_LISTVIEWCURSOR;
						msg->IAddress			=(APTR)sgw->Gadget;
						msg->IDCMPWindow	=sgw->GadgetInfo->gi_Window;
						msg->ExecMessage.mn_Node.ln_Type	=EG_INTUIMSG;
						PutMsg(eg->msgport, (struct Message *)msg);
					}
				}
				break;
		}
	return return_code;
}
#endif
