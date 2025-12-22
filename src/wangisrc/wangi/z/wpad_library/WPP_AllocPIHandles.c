/***************************************************************************
 * WPP_AllocPIHandles.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WPP_AllocPIHandles()
 */

#include "wpad_global.h"

VOID __regargs WPP_AllocPIHandles( struct Pad *pad )
{
	struct PadItem *node;
	for(node = (struct PadItem *)pad->pad_Items->lh_Head; 
	    node->pi_Node.ln_Succ;
	    node = (struct PadItem *)node->pi_Node.ln_Succ)
	{
		ULONG size;
		size = 0;
		if( node->pi_HotKey )
			size = PIH_SIZE_HOTKEY;
		if( node->pi_Flags & PI_FLAGS_DATATYPE )
			size = PIH_SIZE_DATATYPE;
		if( (node->pi_Flags & PI_FLAGS_WBMENU) ||
		    (node->pi_Flags & PI_FLAGS_APPICON) )
			size = PIH_SIZE_APP;
		Printf("node \"%s\" size %ld\n", node->pi_Name, size);
		if( size )
			node->pi_Handles = AllocVec(size, MEMF_CLEAR);
		else
			node->pi_Handles = NULL;
	}
}