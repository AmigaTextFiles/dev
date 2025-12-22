/***************************************************************************
 * WPP_FreePIHandles.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WPP_FreePIHandles()
 */

#include "wpad_global.h"

VOID __regargs WPP_FreePIHandles( struct Pad *pad )
{
	struct PadItem *node;
	for(node = (struct PadItem *)pad->pad_Items->lh_Head; 
	    node->pi_Node.ln_Succ;
	    node = (struct PadItem *)node->pi_Node.ln_Succ)
	{
		if( node->pi_Handles )
		{
			FreeVec(node->pi_Handles);
			node->pi_Handles = NULL;
		}
	}
}