/***************************************************************************
 * WPP_Entry.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WPP_Entry()
 */

#include "wpad_global.h"

VOID LIBENT WPP_Entry( VOID )
{
	struct Process *proc;
	struct Pad *pad;
	
	/* Protect us from the library disapearing! */
	ObtainSemaphoreShared(&EntrySem);
	
	/* Fing our process block */
	proc = (struct Process *)FindTask(NULL);
	
	/* Retrieve the Pad structure which was hidden using the NP_ExitData tag */
	pad = (struct Pad *)proc->pr_ExitData;
	
	/* A wee message */
	Printf("Hello from process \"%s\" 0x%06lx\n", ((struct Node *)proc)->ln_Name, pad);
	
	/* Open a message port */
	if( pad->pad_MsgPort = CreateMsgPort() )
	{
		ULONG pmpsig, cxsig, winsig, signal;
		BOOL ABORT;
		ABORT = FALSE;

		WPP_AllocPIHandles(pad);
		WPP_AddHotKeys(pad);
		WPP_OpenWindow(pad);
		
		for(;;)
		{
			signal = Wait(WPP_GetSigMask(pad, &pmpsig, &cxsig, &winsig));
			
			if( signal & pmpsig )
			{
				struct WPMsg *wpmsg;
				Printf("Message to Pad->pad_MsgPort\n");
				while( wpmsg = (struct WPMsg *)GetMsg(pad->pad_MsgPort) )
				{
					switch( wpmsg->wpm_Action )
					{
						case WPM_ACTION_DIE:
							Printf("WPM_ACTION_DIE\n");
							ABORT = TRUE;
							Printf("Bye from process \"%s\" 0x06%lx\n", ((struct Node *)proc)->ln_Name, pad);
							WPP_FreeHotKeys(pad);
							WPP_CloseWindow(pad);
							WPP_FreePIHandles(pad);
							break;
						case WPM_ACTION_GETATTRS:
							Printf("WPM_ACTION_GETATTRS\n");
							break;
						case WPM_ACTION_SETATTRS:
							Printf("WPM_ACTION_SETATTRS\n");
							break;	
					}
					ReplyMsg(wpmsg);
				}
			}
			
			if( signal & cxsig )
			{
				CxMsg *msg;
				ULONG msgtype, msgid;
				
				Printf("Message to Pad->pad_CxMsgPort\n");
				while( msg = (CxMsg *)GetMsg(pad->pad_CxMsgPort) )
				{
					msgtype = CxMsgType(msg);
					msgid = CxMsgID(msg);
					ReplyMsg((struct Message *)msg);
					if( msgtype == CXM_IEVENT )
					{
						if( msgid )
						{
							if( msgid == EVENT_MAINHOTKEY )
								Printf("EVENT_MAINHOTKEY\n");
							else
							{
								if( pad->pad_Hook )
								{
									struct WPOPHookMsg *hmsg;
									if( hmsg = AllocVec(sizeof(struct WPOPHookMsg), MEMF_CLEAR) )
									{
										hmsg->hm_MethodID = WPOP_HOOK_EXEC;
										CallHookPkt(pad->pad_Hook, hmsg, (APTR)msgid);
										FreeVec(hmsg);
									}
								}
							}
						}
					}
				}
			}
			
			if( ABORT )
				break;
		}
		DeleteMsgPort(pad->pad_MsgPort);
	}
	
	/* Free the pad structure */
	CloseFont(pad->pad_TFont);
	FreeVec(pad);
	
	ReleaseSemaphore(&EntrySem);
	
	/* This process has been terminated... :) */
}
