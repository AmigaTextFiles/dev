/***************************************************************************
 * WPP_FreeHotKeys.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WPP_FreeHotKeys()
 */

#include "wpad_global.h"

VOID __regargs WPP_FreeHotKeys( struct Pad *pad )
{
	if( pad->pad_CxMsgPort )
	{
		struct PadItem *node;
		struct Message *msg;
		
		/* Delete main hotkey */
		DeleteCxObjAll(pad->pad_HotKeyH);
		pad->pad_HotKeyH = NULL;
		
		/* Delete hotkeys of the items */
		for(node = (struct PadItem *)pad->pad_Items->lh_Head; 
		    node->pi_Node.ln_Succ;
		    node = (struct PadItem *)node->pi_Node.ln_Succ)
		{
			if( node->pi_Handles && node->pi_Handles->pih_HotKey )
			{
				DeleteCxObjAll(node->pi_Handles->pih_HotKey);
				node->pi_Handles->pih_HotKey = NULL;
			}
		}
		
		/* Remove any messages */
		while( msg = GetMsg(pad->pad_CxMsgPort) )
			ReplyMsg(msg);
		
		/* Close message port */
		DeleteMsgPort(pad->pad_CxMsgPort);
		pad->pad_CxMsgPort = NULL;
	}
}
