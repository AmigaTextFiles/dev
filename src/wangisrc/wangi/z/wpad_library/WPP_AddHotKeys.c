/***************************************************************************
 * WPP_AddHotKeys.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WPP_AddHotKeys()
 */

#include "wpad_global.h"

VOID __regargs WPP_AddHotKeys( struct Pad *pad )
{
	pad->pad_CxMsgPort = NULL;
	if( pad->pad_Broker )
	{
		if( pad->pad_CxMsgPort = CreateMsgPort() )
		{
			struct PadItem *node;
			/* Add main hotkey */
			if( pad->pad_HotKey )
			{
				/* filter */
				if( pad->pad_HotKeyH = CxFilter(pad->pad_HotKey) )
				{
					CxObj *sender;
					/* sender */
					AttachCxObj(pad->pad_Broker, pad->pad_HotKeyH);
					if( sender = CxSender(pad->pad_CxMsgPort, EVENT_MAINHOTKEY) )
					{
						CxObj *trans;
						/* translater */
						AttachCxObj(pad->pad_HotKeyH, sender);
						if( trans = CxTranslate(NULL) )
						{
							AttachCxObj(pad->pad_HotKeyH, trans);
						}
					}
				}
			}
			
			/* Add hotkeys for the items */
			for(node = (struct PadItem *)pad->pad_Items->lh_Head; 
			    node->pi_Node.ln_Succ;
			    node = (struct PadItem *)node->pi_Node.ln_Succ)
			{
				if( node->pi_HotKey )
				{
					/* filter */
					if( node->pi_Handles->pih_HotKey = CxFilter(node->pi_HotKey) )
					{
						CxObj *sender;
						/* sender */
						AttachCxObj(pad->pad_Broker, node->pi_Handles->pih_HotKey);
						if( sender = CxSender(pad->pad_CxMsgPort, (LONG)node) )
						{
							CxObj *trans;
							AttachCxObj(node->pi_Handles->pih_HotKey, sender);
							/* translater */
							if( trans = CxTranslate(NULL) )
							{
								AttachCxObj(node->pi_Handles->pih_HotKey, trans);
							}
						}
					}
				}
			}
		}
	}
}
